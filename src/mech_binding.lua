-- EXO45 reciprocal avatar/body relationship verified in v0.2.7. Other mech
-- variants share presentation, but their data path still needs in-game checks.
local M={}
local diagnostics=false
local function owned_set(c)
 if c.owned_set then return c.owned_set end
 local set={};for _,id in pairs(c.owned_ids or{})do if (type(id)=='number'and id%1==0 and id>0 and id<32767)then set[id]=true end end
 return set
end
local function call(fn,...)if type(fn)=='function'then local ok,a=pcall(fn,...);if ok then return a end end end
local function goid(v)return type(v)=='number'and v%1==0 and v>0 and v<32767 end
local function finite(v)return type(v)=='number'and v==v and math.abs(v)<1e9 end
local function shape(f,initial)
 if type(f)~='table'or type(f[19])~='table'or type(f[19][6])~='table'then return false end
 if not finite(f[56])or not finite(f[65])or f[65]<=0 or f[65]>100000 or f[56]<0 or f[56]>f[65]then return false end
 if f[28]==nil or not finite(f[76])or not finite(f[19][3])then return false end
 local children=f[19][6]
 if initial and(not goid(children[1])or not goid(children[2])or children[1]==children[2]or children[3]~=nil)then return false end
 return true
end
function M.new(G,log)
 local S={snapshot=nil,status='WAIT MECH'}
 local ctx,bound,proof_at,next_read,last_data=nil,nil,0,0,nil
 local scan,pending,next_diag=nil,nil,0
 local quick,quick_next=nil,0
 local warm_seen,warm_candidates,warm_ids,warm_cursor,warm_next={},{},nil,1,0
 local warm_owned=nil
 local function clear(reason)
  if bound then log('MECH_UNBIND id='..bound..' reason='..reason)end
  bound=nil;proof_at=0;S.snapshot=nil;last_data=nil;S.status='WAIT MECH'
  scan=nil;pending=nil;quick=nil;quick_next=0
 end
 function S.reset()
  clear('context_reset');ctx=nil;next_read=0;next_diag=0
  warm_seen={};warm_candidates={};warm_ids=nil;warm_cursor=1;warm_next=0;warm_owned=nil
 end
 -- Core idle cleanup releases the visible binding, while context-keyed schema
 -- hints survive exit. Every candidate is sampled again before a new bind.
 function S.release()clear('core_reset');next_read=0 end
 local function context(c)
  if not ctx or ctx.session~=c.session or ctx.peer~=c.peer or ctx.world~=c.world or ctx.avatar~=c.avatar then
   S.reset();ctx={session=c.session,peer=c.peer,world=c.world,avatar=c.avatar}
  end
 end
 function S.prewarm(t,c)
  context(c)
  if t<warm_next then return end;warm_next=t+.05
  local owned=owned_set(c)
  if warm_owned~=owned then
   for id in pairs(warm_seen)do if not owned[id]then warm_seen[id]=nil;warm_candidates[id]=nil end end
   warm_owned=owned
  end
  if not warm_ids or warm_cursor>#warm_ids then
   warm_ids={};warm_cursor=1
   for id in pairs(owned)do if id~=c.avatar and goid(id)then warm_ids[#warm_ids+1]=id end end
   table.sort(warm_ids,function(a,b)
    local ta,tb=warm_seen[a]or -1,warm_seen[b]or -1
    if ta==tb then return a<b end;return ta<tb
   end)
  end
  for _=1,4 do
   local id=warm_ids[warm_cursor];if not id then break end
   if owned[id]then
    local f,why=c.sample(c.session,id)
    if why=='budget'then break end
    if f then warm_seen[id]=t;warm_candidates[id]=shape(f,true)and true or nil
    elseif why=='exists_false'then warm_seen[id]=nil;warm_candidates[id]=nil end
   end
   warm_cursor=warm_cursor+1
  end
 end
 -- The positive candidate lane is independent of the background roster scan.
 -- Every candidate needs a fresh body27 proof; cached driver values never bind.
 local function cached_relation(t,c,owned)
  if not quick then
   if t<quick_next then return nil end
   quick={ids={},cursor=1,matches={},errors=0}
   for id in pairs(warm_candidates)do if owned[id]then quick.ids[#quick.ids+1]=id end end
   table.sort(quick.ids)
   if #quick.ids==0 then quick=nil;quick_next=t+.25;return nil end
  end
  for _=1,4 do
   local id=quick.ids[quick.cursor];if not id then break end
   if owned[id]then
    local f,why=c.sample(c.session,id)
    if why=='budget'then return nil end
    if not f and why~='exists_false'then quick.errors=quick.errors+1 end
    if f and shape(f,true)and f[56]>0 and f[27]==c.avatar then quick.matches[id]=true end
   end
   quick.cursor=quick.cursor+1
  end
  if quick.cursor<=#quick.ids then return nil end
  local found,count=nil,0
  for id in pairs(quick.matches)do if owned[id]then found=id;count=count+1 end end
  local complete=quick.errors==0;quick=nil;quick_next=t+.25
  if count>1 then return nil,true end
  if count==1 and complete then
   if diagnostics then log('MECH_FAST_MATCH avatar='..c.avatar..' body='..found..' proof=fresh_cached_candidates_body27')end
   return found
  end
 end
 local function discover(t,c,ref)
  local owned=owned_set(c)
  for id in pairs(warm_seen)do if not owned[id]then warm_seen[id]=nil;warm_candidates[id]=nil end end
  local fast,ambiguous=cached_relation(t,c,owned)
  if ambiguous then scan=nil;return end
  if fast then scan=nil;return fast end
  if not scan then
   scan={ids={},cursor=1,matches={},errors=0}
   for id in pairs(owned)do
    -- Only recent non-mech schema hints can skip a read. Mech candidates and
    -- all unseen/expired IDs always get fresh driver and health validation.
    if goid(id)and id~=c.avatar and (not warm_seen[id]or t-warm_seen[id]>15 or warm_candidates[id])then scan.ids[#scan.ids+1]=id end
   end
   table.sort(scan.ids,function(a,b)
    local pa=warm_candidates[a]and 0 or(not warm_seen[a]and 1 or 2)
    local pb=warm_candidates[b]and 0 or(not warm_seen[b]and 1 or 2)
    if pa==pb then return a<b end;return pa<pb
   end)
  end
  for _=1,4 do
   local id=scan.ids[scan.cursor];if not id then break end
   if owned[id]then
    local f,why=c.sample(c.session,id)
    -- A budget gate is not a completed read. Retry this exact object.
    if why=='budget'then break end
    if not f and why~='exists_false'then scan.errors=scan.errors+1 end
    if f then warm_seen[id]=t;warm_candidates[id]=shape(f,true)and true or nil end
    if shape(f,true)and f[56]>0 and f[27]==c.avatar then scan.matches[id]=true end
   end
   scan.cursor=scan.cursor+1
  end
  if diagnostics and t>=next_diag then
   next_diag=t+5
   log('MECH_SEARCH avatar='..c.avatar..' direct='..tostring(ref)..' checked='..(scan.cursor-1)..' total='..#scan.ids)
  end
  if scan.cursor>#scan.ids then
   local found,count=nil,0
   for id in pairs(scan.matches)do if owned[id]then found=id;count=count+1 end end
   if diagnostics and #scan.ids>0 then log('MECH_SEARCH_DONE avatar='..c.avatar..' total='..#scan.ids..' reverse_matches='..count..' read_errors='..scan.errors)end
   local complete=scan.errors==0;scan=nil
   if count==1 and complete then return found end
  end
 end
 function S.update(t,c)
  context(c)
  if not c.avatar_checked and call(G.game_object_exists,c.session,c.avatar)~=true then clear('avatar_gone');return end
  local motion,where,state=c.motion,c.where,c.state
  if not c.avatar_checked then
   motion=call(G.game_object_field,c.session,c.avatar,'motion_enabled')
   where=call(G.game_object_field,c.session,c.avatar,'gls4w9b')
   state=call(G.game_object_field,c.session,c.avatar,'state')
  end
  if motion~=false or where~=100 or state~=0 then clear('not_seated');return end
  if t<next_read then return S.snapshot end;next_read=t+.1
  local av=c.sample(c.session,c.avatar)
  local ref=type(av)=='table'and type(av[64])=='table'and av[64][25]or nil
  local direct=goid(ref)
  if direct then
   if bound and bound~=ref then clear('reference_changed')end
   pending=nil;scan=nil
  else
   ref=bound or pending
   if not ref then pending=discover(t,c,ref);return end
   if not owned_set(c)[ref]then clear('body_not_owned');return end
  end
  if call(G.game_object_exists,c.session,ref)~=true then clear('body_gone');return end
  local f=c.sample(c.session,ref)
  if not f then
   if S.snapshot and t-S.snapshot.at>.3 then S.snapshot=nil end
   return S.snapshot
  end
  if not shape(f,not bound)then clear('schema_shape_changed');return end
  if f[56]<=0 then clear('destroyed');return end
  if f[27]==c.avatar then
   proof_at=t
   if not bound then
    bound=ref;pending=nil
    log('MECH_BIND avatar='..c.avatar..' body='..ref..' proof='..(direct and 'avatar64.25_and_body27' or 'fresh_owned_body27')..' children='..tostring(f[19][6][1])..','..tostring(f[19][6][2]))
   end
  elseif not bound or not direct or f[27]~=32767 or t-proof_at>.75 then clear('back_reference_missing_or_foreign');return end
  local value=S.snapshot or{}
  value.id=ref;value.hp=f[56];value.max=f[65];value.at=t;S.snapshot=value
  S.status='MECH TOTAL HP'
  if diagnostics then
   local key=ref..':'..f[56]..':'..f[65]
   if key~=last_data then last_data=key;log('MECH_HEALTH body='..ref..' current='..f[56]..' max='..f[65]..' fields=56,65 damage_response_observed_exo45_only=true')end
  end
  return S.snapshot
 end
 return S
end
return M
