-- Resolve native player/index using a bounded incremental search, then cache
-- only live, correctly typed, peer-owned player IDs. No generic field batches.
local M={}
local function call(f,...)if type(f)=='function'then local ok,v=pcall(f,...);if ok then return v end end end
local function integer(v,a,b)return type(v)=='number'and v==math.floor(v)and v>=a and v<=b end
local function peer(v)return type(v)=='string'and v:lower()or nil end
local function hash(v)
 if type(v)=='number'and integer(v,0,4294967295)then return string.format('%x',v)end
 local s=v~=nil and tostring(v):lower():gsub('^0x','')or nil
 return s and s:match('^%x+$')and s:gsub('^0+','')or nil
end
function M.new(E,log)
 local N,G=E.Network or{},E.GameSession or{}
 local R={};local session,signature=nil,nil;local due=0;local saved,objects,jobs=nil,nil,nil
 local job_index=1;local last_log=nil;local next_log=0
 local function report(s,now)
  if log and(s~=last_log or now>=next_log)then log('BOOSTER_ID '..s);last_log=s;next_log=now+15 end
 end
 function R.reset()session=nil;signature=nil;due=0;saved=nil;objects=nil;jobs=nil;job_index=1 end
 local function reject(s,now)jobs=nil;objects=nil;saved=nil;due=now+2;report(s,now);return nil end
 local function valid(s,id,p)
  return integer(id,0,32766)and call(G.game_object_exists,s,id)==true
   and call(G.game_object_is_type,s,id,'un6y1d')==true
   and peer(call(G.game_object_owner,s,id))==p
 end
 function R.read(roster,now)
  local s=call(N.game_session)
  if not s or call(G.in_session,s)~=true then R.reset();report('NO_SESSION',now);return nil end
  local keys={};local me=nil
  for _,p in ipairs(roster)do
   keys[#keys+1]=p.peer..':'..tostring(p.player_entity)
   if p.is_local then me=p.peer end
  end
  table.sort(keys);local sig=table.concat(keys,'/')
  if session~=s or signature~=sig then
   R.reset();session=s;signature=sig;due=now+2;report('SETTLING',now)
  end
  if not me or peer(call(N.peer_id))~=me then return reject('LOCAL_MISMATCH',now)end
  if now<due then return saved end
  if not objects and not jobs then
   local info=call(N.object_info,'un6y1d');local declared=false
   if type(info)=='table'and type(info.fields)=='table'then
    for _,f in pairs(info.fields)do
     if type(f)=='table'and(hash(f.id)or hash(call((E.IdString32 or{}).to_hex,f.id)))=='b03b8bce'then declared=true end
    end
   end
   if not declared then return reject('SCHEMA',now)end
   jobs={};job_index=1
   for _,p in ipairs(roster)do
    local list=call(G.objects_owned_by,s,p.peer)
    if type(list)~='table'then return reject('NO_OBJECTS peer='..p.peer,now)end
    local ids,seen={},{};local n=0
    for _,id in pairs(list)do
     n=n+1;if n>8192 then return reject('INVALID_OBJECT_LIST peer='..p.peer,now)end
     if integer(id,0,32766)and not seen[id]then seen[id]=true;ids[#ids+1]=id end
    end
    table.sort(ids);jobs[#jobs+1]={peer=p.peer,ids=ids,cursor=1}
    report('SCAN_BEGIN peer='..p.peer..' objects='..#ids,now)
   end
  end
  if jobs then
   local budget=24 -- total candidate checks per update, not a total object limit
   while jobs[job_index]and budget>0 do
    local j=jobs[job_index];local id=j.ids[j.cursor]
    if not id then job_index=job_index+1
    else
     budget=budget-1;j.cursor=j.cursor+1
     if valid(s,id,j.peer)then
      if j.found then return reject('DUPLICATE_PLAYER peer='..j.peer,now)end
      j.found=id
     end
    end
   end
   if jobs[job_index]then report('SCANNING',now);return nil end
   objects={}
   for _,j in ipairs(jobs)do
    if not j.found then return reject('NO_PLAYER peer='..j.peer,now)end
    objects[j.peer]=j.found
   end
   jobs=nil
  end
  local out,used={},{}
  for _,p in ipairs(roster)do
   local id=objects[p.peer]
   if not valid(s,id,p.peer)then return reject('PLAYER_CHANGED peer='..p.peer,now)end
   local index=call(G.game_object_field,s,id,'index')
   if not integer(index,0,3)or used[index]or not valid(s,id,p.peer)then
    return reject('INVALID_INDEX peer='..p.peer..' value='..tostring(index),now)
   end
   used[index]=true;out[p.peer]=index
  end
  if call(N.game_session)~=s or call(G.in_session,s)~=true or peer(call(N.peer_id))~=me then return reject('SESSION_CHANGED',now)end
  saved=out;due=now+2;report('READY',now);return out
 end
 return R
end
return M
