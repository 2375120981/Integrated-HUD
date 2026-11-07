-- Hub owns identity and ammo. The supplemental reader never selects a weapon.
local M={}
local function call(f,...)if type(f)=='function'then local ok,a=pcall(f,...);if ok then return a end end end
local function finite(v)return type(v)=='number'and v==v and math.abs(v)<1e9 end
local function entity(v)return finite(v)and v>0 and v==math.floor(v)end
local function clamp(v)return math.max(0,math.min(1,v))end
local function fields(t,keys)
 local out={};t=type(t)=='table'and t or{}
 for _,k in ipairs(keys)do
  local v=t[k];local kind=type(v)
  out[#out+1]=k..'='..((kind=='string'or kind=='number'or kind=='boolean')and tostring(v):sub(1,80):gsub('[%c]',' ')or kind)
 end
 return table.concat(out,',')
end
local function supported(D)
 local a,b,c=tostring(D.version or''):match('(%d+)%.(%d+)%.(%d+)')
 a,b,c=tonumber(a),tonumber(b),tonumber(c)
 return a and(a>0 or b>=6)
end
function M.new(E,log)
 local details=require('mods/integrated_hud/mdl_gamesession/weapon_details').new(E,log)
 local R={};local last_context=nil;local next_diag=0;local next_input_diag=0;local fed_entities={};local backpack_key=nil
 function R.reset()last_context=nil;fed_entities={};backpack_key=nil;details.reset()end
 function R.read(now)
  local D=rawget(_G,'HD2Data')
  if type(D)~='table'then R.reset();return{state='HUB REQUIRED'}end
  if not supported(D)then R.reset();return{state='HUB 0.6 REQUIRED'}end
  if call(D.ready)~=true then R.reset();return{state='WAIT HUB'}end
  local mission=call(D.mission)
  if type(mission)~='table'or mission.in_mission~=true then R.reset();return{state='NO MISSION'}end
  local me=call(D.player_ammo)
  if type(me)~='table'or not entity(me.entity)or me.alive==false or me.life=='dead'then
   R.reset();return{state='NO AVATAR'}
  end
  local context=tostring(D)..'/'..tostring(type(mission)=='table'and mission.epoch)..'/'..tostring(me.peer)..'/'..me.entity..'/'..tostring(me.player_entity)
  if context~=last_context then details.reset();fed_entities={};backpack_key=nil;last_context=context end
  local w=me.weapon
  if type(w)~='table'or not entity(w.entity)then return{state='NO WEAPON'}end
  -- Keep the optional backpack lease warm before a support weapon gets its pack.
  -- This reads Hub snapshots only; no new GameSession/remote-object scan.
  local bp=type(me.backpack)=='table'and me.backpack or nil
  local rows=(w.slot=='support'or w.backpack_fed==true or fed_entities[w.entity]or w.ammo_type==nil)and call(D.backpacks)or nil
  local deposit=nil;local ambiguous=false
  for _,p in pairs(type(rows)=='table'and rows or{})do
   if type(p)=='table'and p.is_local==true and type(p.peer)=='string'and type(me.peer)=='string'
    and p.peer:lower()==me.peer:lower()and not p.error and type(p.backpack)=='table'and p.backpack.type=='deposit'
    and(not bp or not bp.entity or p.backpack.entity==bp.entity)then
    if deposit then ambiguous=true end;deposit=p.backpack
   end
  end
  if ambiguous then deposit=nil end
  -- Record inputs BEFORE unsupported-ammo/reload early returns. Keep only
  -- bounded scalar fields from public Hub snapshots; no native object reads.
  if log and w.ammo_type==nil and now>=next_input_diag then
   next_input_diag=now+5
   local parts={'HUB_INPUT held{'..fields(w,{'entity','category','slot','ammo_type','backpack_fed','rounds','capacity','mags'})..'}',
    'backpack{'..fields(bp,{'entity','count','max'})..'}',
    'inventory{'..fields(me.weapons,{'primary','secondary','support'})..'}'}
   local loadout=type(me.loadout)=='table'and me.loadout or{}
   for _,slot in ipairs({'primary','secondary','support'})do
    parts[#parts+1]=slot..'{'..fields(loadout[slot],{'entity','held','ammo_type','backpack_fed'})..'}'
   end
   local n=0
   for _,p in pairs(type(rows)=='table'and rows or{})do
    n=n+1;if n>4 then break end
    if type(p)=='table'then
     parts[#parts+1]='pack_row{'..fields(p,{'peer','is_local','error'})..';'..fields(p.backpack,{'entity','owned','type','count','max','fill'})..'}'
    end
   end
   log(table.concat(parts,' '))
  end
  local next_key=tostring(bp and bp.entity)..'/'..tostring(deposit and deposit.entity)..'/'
   ..tostring(finite(bp and bp.count)or finite(deposit and deposit.count))
  if backpack_key and next_key~=backpack_key then call(details.refresh)end
  backpack_key=next_key
  -- Do not retain a different weapon across an empty/changing Hub snapshot.
  if type(w.reload)=='table'and w.reload.active==true then return{state='RELOADING',entity=w.entity}end
  local v={state='READY',entity=w.entity,mode='',rpm='',safety=''}
  local extra=details.read(w.entity,now,me)
  if extra and extra.backpack_fed==true then fed_entities[w.entity]=true end
  -- Captured connected weapons report backpack_fed=false: that flag cannot
  -- identify this path. Corroborate held identity with both Hub inventory views
  -- and require the current local deposit snapshot instead of a cached count.
  local support=type(me.loadout)=='table'and me.loadout.support
  local connected_support=w.category==3 and type(me.weapons)=='table'and me.weapons.support==w.entity
   and type(support)=='table'and support.entity==w.entity and support.held==true
   and support.ammo_type==nil and support.rounds==nil and support.capacity==nil
  local connected_pack=connected_support and deposit and deposit.owned==true and entity(deposit.entity)
  if w.ammo_type==nil and w.slot=='support'and(w.backpack_fed==true or connected_support)then
   local pack=connected_pack and deposit or(w.backpack_fed==true and(deposit or(not ambiguous and bp)))
   local count,maximum=pack and pack.count,pack and pack.max
   if not finite(count)or not finite(maximum)or count<0 or maximum<=0 or count>maximum then
    return{state='WAIT BACKPACK',entity=w.entity}
   end
   v.kind='ammo';v.backpack_direct=true
   v.rounds=math.floor(count+.5);v.capacity=maximum;v.ratio=clamp(count/maximum)
  elseif w.ammo_type=='heat'then
   local h=w.heat
   if type(h)~='table'then return{state='WAIT HEAT',entity=w.entity}end
   local ratio=finite(h.frac)and h.frac or(finite(h.value)and finite(h.max)and h.max>0 and h.value/h.max)
   if not finite(ratio)then return{state='WAIT HEAT',entity=w.entity}end
   v.kind='heat';v.ratio=clamp(ratio);v.heat_percent=math.floor(v.ratio*100+.5)
   v.overheated=h.locked==true or(finite(h.value)and finite(h.overheat)and h.value>=h.overheat)or false
  elseif w.ammo_type=='magazine'or w.ammo_type=='rounds'then
   if not finite(w.rounds)or not finite(w.capacity)or w.rounds<0 or w.capacity<=0 then return{state='WAIT AMMO',entity=w.entity}end
   v.kind='ammo';v.rounds=math.floor(w.rounds+.5);v.capacity=w.capacity;v.ratio=clamp(w.rounds/w.capacity)
   v.mags=finite(w.mags)and math.max(0,math.floor(w.mags+.5))or nil
  else return{state='UNSUPPORTED AMMO',entity=w.entity}end
  if extra then v.mode,v.rpm,v.safety=extra.mode or'',extra.rpm or'',extra.safety or'';v.hash=extra.hash end
  if v.kind=='ammo'and not v.backpack_direct and(w.backpack_fed==true or fed_entities[w.entity])and not finite(w.mags_backpack)then
   local count=bp and bp.count
   if not finite(count)and deposit then count=deposit.count end
   if finite(count)and count>=0 then v.mags=(v.mags or 0)+math.floor(count+.5)end
  end
  -- Charge data is taken from the same authoritative held-weapon snapshot.
  local charge=nil;local charge_source=nil
  if v.kind=='heat'then
   local h=w.heat
   if type(h)=='table'and h.charging==true and finite(h.charge)and h.charge>0.00001 then
    charge=h.charge/100;charge_source='heat.charge/100'
   end
  elseif finite(w.charge)and w.charge>0.00001 then
   charge=w.charge;charge_source='weapon.charge'
  end
  if charge then
   v.charging=true;v.charge_source=charge_source;v.charge_raw=charge
   v.charge_ratio=clamp(charge);v.charge_percent=math.floor(charge*100+.5)
  end
  if now>=next_diag then
   next_diag=now+5
   if log then log('HUB_WEAPON entity='..tostring(w.entity)..' slot='..tostring(w.slot)..' kind='..tostring(w.ammo_type)
    ..' raw_mags='..tostring(w.mags)..' mags_backpack='..tostring(w.mags_backpack)..' backpack_fed='..tostring(w.backpack_fed)
    ..' backpack_count='..tostring(type(me.backpack)=='table'and me.backpack.count)..' shown_reserve='..tostring(v.mags)
    ..' network_id='..tostring(extra and extra.network_id)..' mode='..tostring(v.mode))end
  end
  -- A reloaded Hub must not publish a snapshot from its former instance.
  if rawget(_G,'HD2Data')~=D or call(D.ready)~=true then R.reset();return{state='WAIT HUB'}end
  local after=call(D.mission)
  if type(after)~='table'or after.in_mission~=true or after.epoch~=mission.epoch then
   R.reset();return{state='NO MISSION'}
  end
  return v
 end
 function R.shutdown()R.reset()end
 return R
end
return M
