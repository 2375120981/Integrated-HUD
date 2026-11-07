-- Hub entity IDs are NOT GameSession object IDs. Resolve only local-owned,
-- carried objects in the authoritative inventory slot. Never choose HUD ammo.
local M={}
local SLOT={primary=1,secondary=2,support=3}
-- Both Railgun and Epoch use the support slot; override the learned seed.
local OVERRIDE={cfaa9ddc=1,['9c06f074']=1,cd0e4b4a=1,['3244dc49']=1,['656d507b']=3,
 ['26acc614']=3,['314a1bf5']=3}
local function call(f,...)if type(f)=='function'then local ok,a=pcall(f,...);if ok then return a end end end
local function finite(v)return type(v)=='number'and v==v and math.abs(v)<1e9 end
local function peer(v)return type(v)=='string'and v:lower():gsub('^0+','')or nil end
local function connected_held(w,me)
 local support=type(me.loadout)=='table'and me.loadout.support
 return w.slot=='support'and w.category==3 and w.ammo_type==nil
  and type(me.weapons)=='table'and me.weapons.support==w.entity
  and type(support)=='table'and support.entity==w.entity and support.held==true
  and support.ammo_type==nil and support.rounds==nil and support.capacity==nil
end
function M.new(E,data,valid,field,log)
 local G,N=E.GameSession or{},E.Network or{}
 local R={};local objects={};local ids={};local refresh=0;local hub_id=nil;local last_log=nil;local bound=nil
 local by_slot={{},{},{}}
 for _,t in ipairs(data.types)do
  local slot=OVERRIDE[t.id]or data.slots[t.id]
  if slot and by_slot[slot]then by_slot[slot][#by_slot[slot]+1]=t end
 end
 function R.reset()objects={};ids={};refresh=0;hub_id=nil;last_log=nil;bound=nil end
 function R.refresh()refresh=0 end
 local function report(state,id,n)
  R.state=state
  local key=state..'/'..tostring(id)..'/'..tostring(n)
  if key~=last_log then last_log=key;if log then log('WEAPON_BIND '..key)end end
 end
 function R.resolve(s,entity,now,me)
  local w=type(me)=='table'and me.weapon
  local slot=type(w)=='table'and SLOT[w.slot]
  if not slot or w.entity~=entity then report('NO HUB SLOT',entity);return nil end
  if hub_id~=entity then hub_id=entity;refresh=0;bound=nil end
  local local_peer=call(N.peer_id)
  if not peer(local_peer)or peer(me.peer)~=peer(local_peer)then return nil end
  if now>=refresh then
   refresh=now+.5
   local owned=call(G.objects_owned_by,s,local_peer)
   if type(owned)~='table'then ids={};bound=nil;report('WAIT LOCAL OBJECTS',entity);return nil end
   local next_ids,seen={},{}
   for _,id in pairs(owned)do
    if finite(id)and id>=0 and id<32767 and id==math.floor(id)and not seen[id]then
     seen[id]=true;next_ids[#next_ids+1]=id
     if #next_ids>1024 then report('LOCAL OBJECT LIMIT',entity);return nil end
    end
   end
   for id in pairs(objects)do if not seen[id]then objects[id]=nil end end
   table.sort(next_ids,function(a,b)return a>b end);ids=next_ids
  end
  if bound and(not bound.t.direct_feed or connected_held(w,me))and objects[bound.id]and call(G.game_object_exists,s,bound.id)==true
   and call(G.game_object_is_type,s,bound.id,bound.t.name)==true then
   local carry=field(s,bound.id,bound.t,'carry');local owner=field(s,bound.id,bound.t,'owner')
   local floor=field(s,bound.id,bound.t,'floor')
   if finite(carry)and carry%4==0 and peer(owner)==peer(local_peer)and(not finite(floor)or floor==32767)then
    return bound.id,bound.t
   end
  end
  bound=nil
  local budget=128;local pending=false;local matches={}
  for _,id in ipairs(ids)do
   if call(G.game_object_exists,s,id)==true then
   local o=objects[id]or{tried={}};objects[id]=o
   if o.t and call(G.game_object_is_type,s,id,o.t.name)~=true then o.t=nil;o.tried={} end
   if not o.t then
    for _,t in ipairs(by_slot[slot])do if not o.tried[t.name]then
     if budget<=0 then pending=true;break end
     budget=budget-1;o.tried[t.name]=true
     if call(G.game_object_is_type,s,id,t.name)==true then o.t=t;break end
    end end
   end
   local t=o.t
   if t and(OVERRIDE[t.id]or data.slots[t.id])==slot and valid(t)
    and call(G.game_object_exists,s,id)==true then
    local carry=field(s,id,t,'carry');local owner=field(s,id,t,'owner')
    local floor=field(s,id,t,'floor')
    if finite(carry)and carry%4==0 and peer(owner)==peer(local_peer)and(not finite(floor)or floor==32767)then
     -- Compare current contents as corroboration, never the mode we want to show.
     local same=false
     if t.direct_feed and connected_held(w,me)then
      -- No magazine count exists to compare. Still require one unambiguous
      -- local carried direct-feed type in the authoritative support slot.
      same=true
     elseif w.ammo_type=='heat'and t.heat then
      local h=field(s,id,t,'heat');local hv=type(w.heat)=='table'and w.heat.value
      same=finite(h)and finite(hv)and math.abs(h-hv)<=16
     elseif w.ammo_type~='heat'and not t.heat and finite(w.rounds)then
      local n=field(s,id,t,'rounds')
      if not finite(n)then
       local selected=field(s,id,t,'selected')
       n=field(s,id,t,selected==1 and'slot1'or'slot0')
      end
      if finite(n)then
       if field(s,id,t,'chamber')==false then n=n+1 end
       same=n==w.rounds
      end
     end
     if same then matches[#matches+1]={id=id,t=t}end
    end
   end
   else objects[id]=nil end
  end
  if pending then report('CLASSIFYING LOCAL OBJECTS',entity);return nil end
  if #matches~=1 then report(#matches==0 and'NO MATCH'or'AMBIGUOUS',entity,#matches);return nil end
  report('BOUND',entity,matches[1].id)
  bound=matches[1]
  return matches[1].id,matches[1].t
 end
 return R
end
return M
