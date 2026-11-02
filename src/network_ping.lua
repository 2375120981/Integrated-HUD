-- Optional Hub roster + engine RTT. Never enumerate or read remote game objects.
local Module={}
local text=require('mods/integrated_hud/mdl_gamesession/utf8_text')
local function call(f,...)
 if type(f)~='function'then return nil end
 local ok,a=pcall(f,...);if ok then return a end
end
local function probe(f,...)
 if type(f)~='function'then return nil,'missing'end
 local ok,a=pcall(f,...)
 if ok then return a,'ok'end
 return nil,'error:'..tostring(a):sub(1,160):gsub('[%c]',' ')
end
local function describe(v)
 if type(v)=='table'then
  local out,n={},0
  for k,x in pairs(v)do
   n=n+1;if n<=8 then out[#out+1]=tostring(k)..'='..tostring(x):sub(1,96):gsub('[%c]',' ')end
  end
  table.sort(out);return 'table('..n..'){'..table.concat(out,',')..'}'
 end
 return type(v)..':'..tostring(v):sub(1,160):gsub('[%c]',' ')
end
local function player_description(v)
 if type(v)~='table'then return describe(v)end
 local out={}
 for _,key in ipairs({'peer','slot','is_local','name','entity','player_entity','health','life'})do
  out[#out+1]=key..'='..describe(v[key])
 end
 return table.concat(out,' ')
end
local function integer(v,lo,hi)return type(v)=='number'and v==math.floor(v)and v>=lo and v<=hi end
local function peer_key(v)
 if type(v)~='string'or not v:match('^%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x$')or v=='0000000000000000'then return nil end
 return v:lower()
end
local function name_label(v,peer)
 return text.name(v)or peer
end
function Module.new(E,log)
 local N,G=E.Network or{},E.GameSession or{}
 local R={};local session,mine,hub,next_read,previous=nil,nil,nil,0,nil
 local shown={state='NO SESSION',rows={}};local last_log,next_log=nil,0
 local last_diag,next_diag=nil,0
 local function result(state,rows,slot,now,source)
  shown={state=state,rows=rows or{},local_slot=slot,source=source}
  local parts={state,tostring(slot),source or''}
  for _,r in ipairs(shown.rows)do parts[#parts+1]=string.format('%q',r.label)..'='..r.peer..':'..tostring(r.ms)end
  local key=table.concat(parts,' ')
  if state~=last_log or now>=next_log then
   log('PING HUB '..key);last_log=state;next_log=now+10
  end
  return shown
 end
 local function reset()previous=nil;next_read=0;last_diag=nil;next_diag=0;shown={state='NO SESSION',rows={}}end
 local function members(s,me)
  local raw=call(G.peers,s);if type(raw)~='table'then return nil end
  local list,set={},{}
  for _,p in pairs(raw)do
   local k=peer_key(p)
   if not k or set[k]then return nil end
   set[k]=true;list[#list+1]=k
   if #list>4 then return nil end
  end
  if not set[me]then return nil end
  local source='SESSION';local diag={'session_peers='..describe(raw)}
  -- A staging ship can have a self-only GameSession while network links to the
  -- destination still exist. These links are not asserted to be squad members.
  if #list==1 then
   local links,why=probe(N.connections)
   diag[#diag+1]='connections '..why..' '..describe(links)
   if type(links)=='table'then
    for _,p in pairs(links)do
     local k=peer_key(p)
     local reason=not k and'invalid_peer'or k==me and'local_peer'or set[k]and'duplicate'
     if k and k~=me and not set[k]then
      local has,has_status=probe(N.has_connection,p)
      local broken,broken_status=probe(N.is_broken,p)
      local connected=has_status=='missing'or has==true
      local healthy=broken_status=='missing'or broken==false
      reason='has_connection '..has_status..' '..describe(has)..'; is_broken '..broken_status..' '..describe(broken)
      if connected and healthy then set[k]=true;list[#list+1]=k;source='CONNECTIONS'end
      if #list>4 then return nil end
     end
     if #diag<12 then diag[#diag+1]='link '..describe(p)..' '..tostring(reason)end
    end
   end
   if #list==1 then
    local raw_host,host_status=probe(G.game_session_host,s)
    local host=peer_key(raw_host)
    diag[#diag+1]='host '..host_status..' '..describe(raw_host)..' local='..me
    if host and host~=me then return nil end -- Joining, not proof of a solo lobby.
   end
  end
  table.sort(list);return {list=list,set=set,source=source,signature=source..'/'..table.concat(list,'|'),diagnostic=diag}
 end
 local function roster(D,m,me)
  local raw=call(D.players,false);if type(raw)~='table'then return nil end
  local list,peers,slots,labels={}, {},{},{}
  local local_slot=nil
  for _,p in pairs(raw)do
   if type(p)~='table'then return nil end
   local k=peer_key(p.peer);local slot=p.slot
   if not k or not m.set[k]or peers[k]or not integer(slot,0,3)or slots[slot]
    or type(p.is_local)~='boolean'or p.is_local~=(k==me)then return nil end
   peers[k]=true;slots[slot]=true
   local label=name_label(p.name,k)
   labels[label]=(labels[label]or 0)+1
   list[#list+1]={peer=k,slot=slot+1,label=label}
   if k==me then local_slot=slot+1 end
  end
  if #list~=#m.list or not local_slot then return nil end
  table.sort(list,function(a,b)return a.slot<b.slot end)
  local sig={m.signature}
  for _,p in ipairs(list)do
   if labels[p.label]>1 then p.label=p.peer end
   sig[#sig+1]=p.peer..':'..p.slot..':'..string.format('%q',p.label)
  end
  return {list=list,local_slot=local_slot,signature=table.concat(sig,'|')}
 end
 local function mission(D)
  local v=call(D.mission)
  -- Lifecycle token, not an eligibility gate: session RTT also exists aboard ship.
  if type(v)=='table'and type(v.in_mission)=='boolean'and integer(v.epoch,0,2147483647)then
   return v.epoch..':'..tostring(v.in_mission)
  end
  return 'unknown'
 end
 local function peer_roster(m)
  local list={}
  for _,p in ipairs(m.list)do list[#list+1]={peer=p,label=p}end
  -- No synthetic slot numbers or cached names: current session peer is the label.
  return {list=list,signature='PEER/'..m.signature}
 end
 local function diagnose(D,m,s,me,now)
  local parts={'session='..describe(s),'local='..me}
  for _,v in ipairs(m.diagnostic)do parts[#parts+1]=v end
  if type(D)=='table'then
   local ready,rstatus=probe(D.ready);local state,sstatus=probe(D.state)
   local phase,mstatus=probe(D.mission)
   -- Renew only basic leases once per poll. No getters, detailed squad reads or remote objects.
   local player,pstatus=probe(D.player);local squad,qstatus=probe(D.players,false)
   parts[#parts+1]='hub_ready '..rstatus..' '..describe(ready)..' hub_state '..sstatus..' '..describe(state)
   parts[#parts+1]='hub_mission '..mstatus..' '..(type(phase)=='table'
    and('epoch='..describe(phase.epoch)..' in_mission='..describe(phase.in_mission))or describe(phase))
   parts[#parts+1]='hub_player '..pstatus..' '..player_description(player)
   parts[#parts+1]='hub_players '..qstatus..' '..type(squad)
   if type(squad)=='table'then
    local count=0
    for _,p in pairs(squad)do count=count+1;if count<=4 then parts[#parts+1]='hub_member '..player_description(p)end end
    parts[#parts+1]='hub_count='..count
   end
  else parts[#parts+1]='hub='..type(D)end
  local key=table.concat(parts,' | ')
  if key~=last_diag or now>=next_diag then
   for _,line in ipairs(parts)do log('PING DIAG '..line)end
   last_diag=key;next_diag=now+10
  end
 end
 function R.read(now)
  -- A Hub shutdown/reload withdraws cached readings without waiting for the poll.
  local D=rawget(_G,'HD2Data')
  if D~=hub then reset();hub=D end
  if now<next_read then return shown end;next_read=now+1
  local s=call(N.game_session);local me=peer_key(call(N.peer_id))
  if not s or not me or call(G.in_session,s)~=true then
   reset();session,mine=nil,nil;next_read=now+1;return result('NO SESSION',nil,nil,now)
  end
  if s~=session or me~=mine then previous=nil;session,mine=s,me end
  local m=members(s,me)
  if not m then previous=nil;return result('WAIT SQUAD',nil,nil,now)end
  if #m.list==1 then
   diagnose(D,m,s,me,now)
   previous=nil;return result('SESSION ONLY',nil,nil,now)
  end
  if type(D)~='table'then previous=nil;return result('HUB REQUIRED',nil,nil,now)end
  if call(D.ready)~=true then previous=nil;return result('WAIT HUB',nil,nil,now)end
  local epoch=mission(D)
  local ids=(m.source=='SESSION'and roster(D,m,me))or peer_roster(m)
  local sig=tostring(epoch)..'/'..ids.signature
  if sig~=previous then
   -- Local/host identities expose local-first slots without guessing a corrective permutation.
   log('PING HUB ROSTER source='..m.source..' local='..me..' host='..tostring(peer_key(call(G.game_session_host,s)))..' epoch='..epoch)
   for _,p in ipairs(ids.list)do log('PING HUB ID peer='..p.peer..' hub_slot='..tostring(p.slot and p.slot-1)..' name='..string.format('%q',p.label))end
   previous=sig;return result('CONFIRMING PLAYER IDS',nil,nil,now)
  end
  local rows={}
  for _,p in ipairs(ids.list)do if p.peer~=me then
   local seconds=call(N.ping,p.peer)
   local ms=type(seconds)=='number'and seconds==seconds and seconds>0 and seconds<60
    and math.floor(seconds*1000+.5)or nil
   rows[#rows+1]={peer=p.peer,slot=p.slot,label=p.label,ms=ms}
  end end
  -- Revalidate both providers; never publish RTT against a replaced/stale roster.
  local after=members(s,me)
  local check=after and((after.source=='SESSION'and roster(D,after,me))or peer_roster(after))
  if rawget(_G,'HD2Data')~=D or call(D.ready)~=true or mission(D)~=epoch
   or call(N.game_session)~=s or peer_key(call(N.peer_id))~=me or call(G.in_session,s)~=true
   or not check or check.signature~=ids.signature then
   previous=nil;return result('WAIT PLAYER IDS',nil,nil,now)
  end
  return result('READY',rows,ids.local_slot,now,m.source)
 end
 function R.shutdown()reset();session,mine,hub=nil,nil,nil end
 return R
end
return Module
