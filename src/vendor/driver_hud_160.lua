-- HD2-Addon: mods/driverhud/driver_hud
-- DRIVER HUD 1.6. EAC-compatible Lua 5.1 vehicle HUD.
local sr = rawget(_G, 'stingray')
if not sr then return {installed=false} end
if rawget(_G,'__DRIVER_HUD_INSTALLED') then return {installed=true} end
local App,Net,GS,World,Gui = sr.Application,sr.Network,sr.GameSession,sr.World,sr.Gui
local V2,V3,Color = sr.Vector2,sr.Vector3,sr.Color
local function call(f,...) if type(f)~='function' then return nil end local ok,a,b=pcall(f,...);if ok then return a,b end end
local C={geometry_numbers=true,debug=true,offset_y=155,scale=1,alpha=0.76}
local dir=call(os.getenv,'APPDATA')
if dir and io and io.open then
 local f=io.open(dir..'/Arrowhead/Helldivers2/driver_hud.cfg','r')
 if f then
  for l in f:lines() do
   local k,v=l:match('^%s*([%w_]+)%s*=%s*([%w%.%-]+)')
   if k=='geometry_numbers' then if v=='true' or v=='false' then C[k]=v=='true' end elseif k=='debug' then C[k]=v=='true' elseif C[k]~=nil then
    local n=tonumber(v);if n and n==n then
     if k=='offset_y' then C[k]=math.max(45,math.min(500,n))
     elseif k=='scale' then C[k]=math.max(0.5,math.min(2,n))
     elseif k=='alpha' then C[k]=math.max(0.1,math.min(1,n)) end
    end
   end
  end
  f:close()
 end
end
-- Append to a separate port log; preserve every original log and config.
local LOG_PATH=dir and (dir..'/Arrowhead/Helldivers2/driver_hud_lua51.log')
local function log(s)
 if not C.debug or not LOG_PATH or not io or not io.open then return end
 local ok,f=pcall(io.open,LOG_PATH,'a')
 if ok and f then pcall(f.write,f,tostring(s)..'\n');pcall(f.close,f) end
end
log('DRIVER_HUD SESSION_START version=1.6 pid='..tostring(call(App.process_id))
 ..' utc='..tostring(call(os.date,'!%Y-%m-%dT%H:%M:%SZ'))..' lua='..tostring(_VERSION))
local FRV, Tank -- Forward declarations for lifecycle reset.
local M={ids={},frame=0,clock=0,seated=false,hull=nil,vehicle_ref=nil,cache={},known={},bind_retry=0,bind_weak=false,seat_enter_frame=0,preseat_owned={},entry_new_seen={},entry_owned_cursor=1,bg_owned_cursor=1}
local function clear()
 if FRV then FRV.render_parts=nil end
 if Tank and Tank.clear_ring then Tank.clear_ring() end
 if M.gui then for _,p in ipairs(M.ids) do call(Gui[p[1]],M.gui,p[2]) end end
 if next(M.ids)~=nil then M.ids={} end;M.draw_key=nil
end
local function live(worlds,w) for _,v in pairs(worlds or {}) do if v==w then return true end end return false end
local function surface_reset(worlds)
 if M.gui and live(worlds,M.gui_world) then clear();call(World.destroy_gui,M.gui_world,M.gui) end
 M.ids={};M.gui=nil;M.gui_world=nil;M.draw_key=nil
 if FRV then FRV.render_parts=nil end
 if Tank then Tank.ring_ids={};Tank.ring_key=nil;Tank.ring_gui=nil end
end
local function clear_values()
 M.hp=nil;M.max=nil;M.ammo=nil;M.mg=nil
end
local function full_reset()
 M.idle_settled=nil;M.next_idle_probe=nil
 if Tank then Tank.detach() end
 if FRV then FRV.reset() end
 M.cache={};M.pending_bind=nil;M.seat_hint=nil;M.ownership=nil;M.seat_scan=nil;M.next_bind=0;M.seat_unknown_since=nil
 M.seated=false;M.hull=nil;M.vehicle_ref=nil;M.bind_retry=0;M.bind_weak=false;M.seat_enter_frame=0;M.entry_new_seen={};M.entry_owned_cursor=1;clear_values()
end
local function integer(n,hi) return type(n)=='number' and n==math.floor(n) and n>=0 and n<=hi end
-- One shared native batch budget; time-based, never catch-up bursts.
local batch_clock,batch_tokens,batch_frame,batch_count=0,4,-1,0
local discovery_clock,discovery_tokens=0,2
-- Shared global batch budget; the second return value exposes the gate.
local batch_snapshots={frame=-1}
local function sample(session,id)
 if batch_snapshots.frame~=M.frame or batch_snapshots.session~=session then
  batch_snapshots={frame=M.frame,session=session}
 end
 local cached=batch_snapshots[id]
 if cached and call(GS.game_object_exists,session,id)==true then return cached,'table' end
 local now=M.clock
 batch_tokens=math.min(4,batch_tokens+math.max(0,now-batch_clock)*40);batch_clock=now
 if batch_frame~=M.frame then batch_frame=M.frame;batch_count=0 end
 if batch_tokens<1 or batch_count>=4 then return nil,'budget' end
 if type(id)~='number' then return nil,'invalid_id' end
 local exists=call(GS.game_object_exists,session,id)
 if exists~=true then return nil,'exists_'..tostring(exists) end
 if type(GS.game_object_field_batched)~='function' then return nil,'api_absent' end
 batch_tokens=batch_tokens-1;batch_count=batch_count+1
 local ok,f=pcall(GS.game_object_field_batched,session,id,{})
 if not ok then return nil,'api_error' end
 if type(f)~='table' then return nil,'api_'..type(f) end
 batch_snapshots[id]=f
 return f,'table'
end
local function discovery_sample(session,id)
 local now=M.clock
 discovery_tokens=math.min(2,discovery_tokens+math.max(0,now-discovery_clock)*8);discovery_clock=now
 if discovery_tokens<1 then return nil end
 discovery_tokens=discovery_tokens-1
 return sample(session,id)
end
local function hull_sig(f)
 return type(f)=='table' and type(f[15])=='number' and math.abs(f[15]-8000)<0.001 and type(f[30])=='number' and f[30]>=0 and f[30]<=f[15]
end
local function main_sig(f)
 return type(f)=='table' and integer(f[5],30) and integer(f[6],1) and integer(f[11],1)
end
local function coax_sig(f)
 return type(f)=='table' and integer(f[6],2000) and type(f[11])=='number' and f[11]>=0 and f[11]<=100
end
local function valid_goid(session,v)
 return type(v)=='number' and v==math.floor(v) and v>0 and v<32767 and call(GS.game_object_exists,session,v)==true
end
local function current_vehicle_ref(session,avatar)
 local av=discovery_sample(session,avatar)
 if type(av)~='table' then return nil,'unknown' end
 local a64=av[64]
 if type(a64)~='table' then return nil,'unknown' end
 local v=a64[25]
 if type(v)~='number' then return nil,'unknown' end
 if v==32767 then return 32767,'none' end
 return v,'ref'
end
local function cache_for(hid)
 local c=M.cache[hid]
 if not c then c={};M.cache[hid]=c end
 return c
end
local function seat_mask(f)
 local v=type(f)=='table' and f[22] or nil
 if integer(v,15) then return v end
 return nil
end
local function hull_has_ref(f,ref)
 local t=type(f)=='table' and f[56] or nil
 if type(t)~='table' then return false end
 for _,v in pairs(t) do if v==ref then return true end end
 return false
end
local function remember_hull(hid,hf)
 local k=M.known[hid]
 if not k then k={};M.known[hid]=k end
 local sm=seat_mask(hf)
 if sm~=nil then k.seatmask=sm;k.last_seen=M.frame;k.seen_time=M.clock end
end
local function bind_hull(hid,hf,why)
 if not hull_sig(hf) then return false end
 -- Seat changes elsewhere are a hint, never proof of local occupancy.
 if why=='known_seat_bit' then
  M.seat_hint=hid
  return false
 end
 if why~='avatar64.25_hull' and why~='avatar64.25_weapon' and why~='local_gunner_owned_weapon' and why~='native_seater' and why~='entry_mask' then return false end
 if M.hull==hid then
  if why=='avatar64.25_hull' or why=='avatar64.25_weapon' or why=='native_seater' then M.bind_weak=false end
  return
 end
 local pending=M.pending_bind
 if why~='native_seater' and (not pending or pending.hid~=hid or M.clock-pending.last>5) then
  M.pending_bind={hid=hid,last=M.clock,frame=M.frame}
  log('BASTION_CONFIRM_PENDING hull='..hid..' evidence='..why)
  return false
 end
 -- The discovery scheduler provides separate observations; no fixed UI delay.
 if why~='native_seater' and pending.frame==M.frame then return false end
 M.pending_bind=nil;M.seat_hint=nil
 M.hull=hid;M.bind_retry=0;M.seat_scan=nil;M.ownership=nil
 M.bind_weak=not (why=='avatar64.25_hull' or why=='avatar64.25_weapon' or why=='native_seater')
 remember_hull(hid,hf)
 local c={};M.cache={[hid]=c};c.hp=hf[30];c.max=hf[15];c.hull_valid_at=M.clock;c.bound_at=M.clock
 c.main_id=hid-2;c.coax_id=hid-1;c.next_weapon_resolve=M.clock
 if c.next_hull==nil then c.next_hull=M.clock+0.033333 end
 if c.next_main==nil then c.next_main=M.clock end
 if c.next_coax==nil then c.next_coax=M.clock+0.066667 end
 M.hp,M.max,M.ammo,M.mg=c.hp,c.max,c.ammo,c.mg
 log('BASTION_BIND '..tostring(why)..' hull='..tostring(hid))
end
local function resolve_weapon_hull(session,ref)
 local offset
 if call(GS.game_object_is_type,session,ref,'rHVbvgIu')==true then offset=2
 elseif call(GS.game_object_is_type,session,ref,'fZwFCDKT')==true then offset=1 end
 if not offset then return nil,nil end
 local hid=ref+offset
 local hf=discovery_sample(session,hid)
 if hull_sig(hf) then return hid,hf end
 return nil,nil
end
local function single_seat_clear(old,new)
 if not integer(old,15) or not integer(new,15) then return false end
 local cleared=0
 for _,b in ipairs({1,2,4,8}) do
  local o=math.floor(old/b)%2
  local n=math.floor(new/b)%2
  if n>o then return false end
  if o==1 and n==0 then cleared=cleared+1 end
 end
 return cleared==1
end
local function gunner_seat_occupied(hf)
 local sm=seat_mask(hf)
 return sm~=nil and math.floor(sm/2)%2==0
end
local function discover_owned_bastions(session,ids)
 if M.clock<(M.next_background or 0) or #ids==0 then return end
 M.next_background=M.clock+0.5
 if M.bg_owned_cursor>#ids then M.bg_owned_cursor=1 end
 local id=ids[M.bg_owned_cursor];M.bg_owned_cursor=M.bg_owned_cursor+1
 local f=discovery_sample(session,id)
 if hull_sig(f) then remember_hull(id,f) end
end
local COAX_TYPE='fZwFCDKT'
local MAIN_BIND_TYPE='rHVbvgIu'
local function bind_local_gunner_ownership(session,ids)
 if M.hull or #ids==0 then return false end
 local present={};for _,id in ipairs(ids) do present[id]=true end
 local j=M.ownership
 if not j then
  local list={};for _,id in ipairs(ids) do list[#list+1]=id end;table.sort(list)
  j={list=list,index=1,hulls={}};M.ownership=j
 end
 -- Only type checks while searching; no full-batch expansion of arbitrary objects.
 for _=1,8 do
  local id=j.list[j.index]
  if not id then break end
  j.index=j.index+1
  if present[id] and valid_goid(session,id) then
   local hid
   if call(GS.game_object_is_type,session,id,MAIN_BIND_TYPE)==true then hid=id+2
   elseif call(GS.game_object_is_type,session,id,COAX_TYPE)==true then hid=id+1 end
   if hid then j.hulls[id]=hid end
  end
 end
 if j.index<=#j.list then return false end
 local all,fresh={},{}
 for id,hid in pairs(j.hulls) do
  if present[id] then all[hid]=true;if not M.preseat_owned[id] then fresh[hid]=true end end
 end
 local choices=next(fresh) and fresh or all
 local hid,count=nil,0;for h in pairs(choices) do hid=h;count=count+1 end
 if count==1 then
  local hf=discovery_sample(session,hid)
  if hull_sig(hf) then M.ownership=nil;bind_hull(hid,hf,'local_gunner_owned_weapon');return true end
 end
 M.ownership=nil
 return false
end
local function refresh_known_masks(session,force)
 if M.clock<(M.next_masks or 0) then return end
 M.next_masks=M.clock+0.5
 local keys={};for hid in pairs(M.known) do keys[#keys+1]=hid end;table.sort(keys)
 if #keys==0 then return end
 M.mask_cursor=(M.mask_cursor or 0)%#keys+1
 local hid=keys[M.mask_cursor]
 if call(GS.game_object_exists,session,hid)==false then M.known[hid]=nil;return end
 local hf=discovery_sample(session,hid)
 if hull_sig(hf) then remember_hull(hid,hf) end
end
local function bind_known_seat_transition(session)
 if M.hull or not M.seat_enter_time or M.clock-M.seat_enter_time>5 then return false end
 local j=M.seat_scan
 if not j then
  j={keys={},index=1,count=0,updates={}}
  for hid,k in pairs(M.known) do
   if M.clock-(k.seen_time or -100)<5 then j.keys[#j.keys+1]=hid end
  end
  table.sort(j.keys);M.seat_scan=j
 end
 local hid=j.keys[j.index]
 if hid then
  local hf=discovery_sample(session,hid)
  if not hull_sig(hf) then return false end
  j.index=j.index+1
  local k=M.known[hid];local sm=seat_mask(hf)
  if sm~=nil and k then
   j.updates[hid]={sm=sm,hf=hf}
   if single_seat_clear(k.seatmask,sm) then j.count=j.count+1;j.hid=hid;j.hf=hf end
  end
  return false
 end
 M.seat_scan=nil
 for h,v in pairs(j.updates) do remember_hull(h,v.hf) end
 if j.count==1 then bind_hull(j.hid,j.hf,'known_seat_bit');return true end
 return false
end
local function fallback_bind(session,owned_ids)
 -- Local ownership is specific to this player; the global seat-bit heuristic can
 -- be triggered by another player's seat change when several Bastions are alive.
 if bind_local_gunner_ownership(session,owned_ids) then return true end
 if M.ownership then return false end
 return bind_known_seat_transition(session)
end
local function bind_current_vehicle(session,avatar,owned_ids)
 local ref,state=current_vehicle_ref(session,avatar)
 if state=='unknown' then
  if not M.hull then fallback_bind(session,owned_ids) end
  return
 end
 M.vehicle_ref=ref
 if state=='none' then
  if M.hull then return end
  fallback_bind(session,owned_ids)
  return
 end
 if not valid_goid(session,ref) then
  if not M.hull then fallback_bind(session,owned_ids) end
  return
 end
 if M.hull==ref then M.bind_weak=false;return end
 if M.pending_bind and ref~=M.pending_bind.hid and ref~=M.pending_bind.hid-2 and ref~=M.pending_bind.hid-1 then M.pending_bind=nil end
 if M.hull and ref~=M.hull then
  local c=M.cache[M.hull]
  if not c or (ref~=c.main_id and ref~=c.coax_id) then M.hull=nil;M.cache={};clear_values() end
 end
 local is_weapon=call(GS.game_object_is_type,session,ref,MAIN_BIND_TYPE)==true or call(GS.game_object_is_type,session,ref,COAX_TYPE)==true
 local f
 if not is_weapon then f=discovery_sample(session,ref) end
 if hull_sig(f) then
  bind_hull(ref,f,'avatar64.25_hull')
  return
 end
 local hid,hf=resolve_weapon_hull(session,ref)
 if hid then
  bind_hull(hid,hf,'avatar64.25_weapon')
  return
 end
 M.bind_retry=M.bind_retry+1
end

-- Only the coax type confirmed by the supplied in-game schema log is eligible.
local COAX_FIELD='BLKY2IrV'
local COAX_FIELDS={"49c250a6","31f86165","09d8bef4","50ac6619","ec64918b","d7a5d63e","4a893e74","e0a79052","9611c029","cc0b45e5","9d5d6cc7","c336a25c","3132608f","6f3ab277","4cbcc2a2","7030c54e","3ccffa7f"}
local coax_session,coax_declared,coax_retry
local function coax_schema(session)
 if coax_session~=session then coax_session=session;coax_declared=nil;coax_retry=0 end
 if coax_declared==true or (coax_declared==false and M.clock<(coax_retry or 0)) then return coax_declared end
 coax_retry=M.clock+5
 coax_declared=false
 local info=call(Net.object_info,COAX_TYPE)
 local fs=type(info)=='table' and info.fields
 if type(fs)=='table' and #fs==#COAX_FIELDS then
  coax_declared=true
  for i,expected in ipairs(COAX_FIELDS) do
   local d=fs[i]
   local h=type(d)=='table' and type(d.id)=='string' and d.id:lower():gsub('^0x','') or ''
   if #h<8 then h=string.rep('0',8-#h)..h end
   if h~=expected then coax_declared=false;break end
  end
 end
 log('COAX_SCHEMA declared='..tostring(coax_declared))
 return coax_declared
end
local function resolve_bound_weapon_ids(session,hid,hf,c)
 local refs=type(hf)=='table' and hf[56]
 local main_id,coax_id
 -- Prefer explicit current hull references over arithmetic adjacency.
 local checked=0
 if type(refs)=='table' then
  for _,ref in pairs(refs) do
   checked=checked+1;if checked>16 then break end
   if valid_goid(session,ref) then
    if not main_id and call(GS.game_object_is_type,session,ref,MAIN_BIND_TYPE)==true then main_id=ref end
    if not coax_id and call(GS.game_object_is_type,session,ref,COAX_TYPE)==true then coax_id=ref end
   end
  end
 end
 if not main_id and valid_goid(session,hid-2) and call(GS.game_object_is_type,session,hid-2,MAIN_BIND_TYPE)==true then main_id=hid-2 end
 if not coax_id and valid_goid(session,hid-1) and call(GS.game_object_is_type,session,hid-1,COAX_TYPE)==true then coax_id=hid-1 end
 -- Missing refs alone do not erase a still-live previously resolved weapon.
 if not main_id and valid_goid(session,c.main_id) and call(GS.game_object_is_type,session,c.main_id,MAIN_BIND_TYPE)==true then main_id=c.main_id end
 if not coax_id and valid_goid(session,c.coax_id) and call(GS.game_object_is_type,session,c.coax_id,COAX_TYPE)==true then coax_id=c.coax_id end
 if c.main_id~=main_id then c.ammo=nil;c.main_valid_at=nil;c.main_profile=nil;c.main_scan_done=nil;c.main_scan_index=nil;c.main_observed_count=nil;c.main_diag=nil end
 if c.coax_id~=coax_id then c.mg=nil;c.coax_valid_at=nil;c.coax_diag=nil end
 if c.main_id~=main_id or c.coax_id~=coax_id then log('WEAPON_IDS hull='..hid..' main='..tostring(main_id)..' coax='..tostring(coax_id)) end
 c.main_id=main_id;c.coax_id=coax_id
end
local function read_coax(session,cid,c)
 -- Caller has confirmed the bound hull's weapon reference and its 10 Hz budget.
 -- Recheck type on every read so a reused GOID cannot inherit getter eligibility.
 local matched=call(GS.game_object_is_type,session,cid,COAX_TYPE)==true
 local targeted=matched and coax_schema(session) and type(GS.game_object_field)=='function'
 local value
 if targeted then
  if call(GS.game_object_exists,session,cid)~=true then return end
  value=call(GS.game_object_field,session,cid,COAX_FIELD)
  -- Do not add a batch read on a transient missing/invalid targeted value.
 elseif matched then
  local cf=sample(session,cid)
  if coax_sig(cf) then value=cf[6] end
 end
 local mode=targeted and 'targeted' or 'batch'
 local d=c.coax_diag
 if not d or d.mode~=mode then
  d={mode=mode,start=M.clock,attempts=0,valid=0,changed=0};c.coax_diag=d
  log('COAX_PATH goid='..cid..' mode='..mode)
 end
 d.attempts=d.attempts+1
 if integer(value,2000) then
  d.valid=d.valid+1
  if c.mg~=nil and value~=c.mg then d.changed=d.changed+1 end
  c.mg=value;c.coax_seen=true;c.coax_valid_at=M.clock
 end
 if M.clock-d.start>=10 then
  log('COAX_READ goid='..cid..' mode='..mode..' seconds='..string.format('%.1f',M.clock-d.start)..' attempts='..d.attempts..' valid='..d.valid..' changed='..d.changed..' ammo='..tostring(c.mg))
  d.start=M.clock;d.attempts=0;d.valid=0;d.changed=0
 end
end


-- Main-gun discovery is declaration-first and session-local. Candidate rows only
-- keep the three fields the existing proven batch formula used (#5 + #6 + #11).
local MAIN_CANDIDATES={
{t="xlo1r28A",n=47,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="vrNKKeFq",n=27,h5="82830aed",h6="cad5b537",h11="09d8bef4",f5="N9x5u6Zj",f6="kxpUORmS",f11="QV5FvHIL"},
{t="aACY7h0e",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="ACKHl9Xm",n=27,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="yK3X1Mh2",n=41,h5="a4c332a8",h6="9bbb856e",h11="e0a79052",f5="NETPpspy",f6="HKp0lyah",f11="4Chz2o0P"},
{t="xbKbp8F4",n=24,h5="67526982",h6="31182caf",h11="c20428c6",f5="h76pxW38",f6="1e0RO6az",f11="YPS57cC4"},
{t="aYQGmjlX",n=20,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="De7tagkk",n=24,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="NmJstHF0",n=46,h5="e725d2d1",h6="83a70c01",h11="a1659a75",f5="LpvOeetG",f6="mpIxakPJ",f11="mXjKo3Oi"},
{t="mVRZuV4X",n=19,h5="2d27198c",h6="3ccffa7f",h11="d7a5d63e",f5="T8Mr110g",f6="kUTNXZFj",f11="BLKY2IrV"},
{t="DkIBk3pW",n=12,h5="4a893e74",h6="c336a25c",h11="31f86165",f5="MDEpeNtZ",f6="E27zoa7X",f11="o2PUBIn9"},
{t="M2yoGCO3",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="AR62F1rI",n=22,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="4L2lAhHw",n=19,h5="09d8bef4",h6="6f3ab277",h11="ec64918b",f5="QV5FvHIL",f6="sC8CWlnR",f11="B9h6f9a4"},
{t="5HAXCmRy",n=24,h5="0565f571",h6="169d5ed7",h11="ec64918b",f5="iveGBMZF",f6="E9ARXHkz",f11="B9h6f9a4"},
{t="6ykLNGcD",n=45,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="LEbinxaq",n=39,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="zpVUjezE",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="lHL7eIoX",n=24,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="7U34wVsx",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="tmAFBgfS",n=28,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="rpZ2bCDz",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="W16lvntr",n=82,h5="83a70c01",h6="4f4d9f0d",h11="9bbb856e",f5="mpIxakPJ",f6="byRCOpAI",f11="HKp0lyah"},
{t="c7WEVAvf",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="R9u6Lz7a",n=22,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="DC4hjnLa",n=28,h5="09d8bef4",h6="078c5d3b",h11="d7a5d63e",f5="QV5FvHIL",f6="CQSBbdGK",f11="BLKY2IrV"},
{t="LbxcDJPg",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="MU4c5HHY",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="hsBS26F5",n=24,h5="67526982",h6="31182caf",h11="c20428c6",f5="h76pxW38",f6="1e0RO6az",f11="YPS57cC4"},
{t="6PbNW0d8",n=20,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="fZwFCDKT",n=17,h5="ec64918b",h6="d7a5d63e",h11="9d5d6cc7",f5="B9h6f9a4",f6="BLKY2IrV",f11="SiDCvled"},
{t="W4aoiPNm",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="SSvLXkYU",n=35,h5="e9bb563f",h6="09c56a96",h11="d7a5d63e",f5="xRhGae3u",f6="IIq9LOZH",f11="BLKY2IrV"},
{t="84ufSRap",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="kR8Wt84A",n=45,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="W39LbrUR",n=33,h5="09d8bef4",h6="078c5d3b",h11="d7a5d63e",f5="QV5FvHIL",f6="CQSBbdGK",f11="BLKY2IrV"},
{t="Z6VzY3yJ",n=42,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="Nf7cYA1Q",n=22,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="qciZDjGk",n=27,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="nNDrtLKN",n=28,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="aKXpM4z0",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="t9sxjuv8",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="DLL9rgyD",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="WIQvpJQb",n=35,h5="e9bb563f",h6="09c56a96",h11="d7a5d63e",f5="xRhGae3u",f6="IIq9LOZH",f11="BLKY2IrV"},
{t="901qiB7F",n=13,h5="4a893e74",h6="8bbeb160",h11="31f86165",f5="MDEpeNtZ",f6="h7m5n4Mf",f11="o2PUBIn9"},
{t="c7Zd0uXW",n=25,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="JxYAip3r",n=27,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="cEitkNtE",n=84,h5="83a70c01",h6="4f4d9f0d",h11="a1659a75",f5="mpIxakPJ",f6="byRCOpAI",f11="mXjKo3Oi"},
{t="SH3YTx0S",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="KzjuB86r",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="mzohJST2",n=11,h5="4cbcc2a2",h6="7030c54e",h11="3132608f",f5="pZboIHGF",f6="JCFA8O9q",f11="iTzoRYlr"},
{t="6kbD51Xx",n=27,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="jgnfGqrg",n=12,h5="d7a5d63e",h6="4a893e74",h11="4cbcc2a2",f5="BLKY2IrV",f6="MDEpeNtZ",f11="pZboIHGF"},
{t="kZQHPWOx",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="S8pAsI7Y",n=29,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="ac2aYKwB",n=45,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="cvjBs8Wv",n=28,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="WNTBCq6O",n=19,h5="4a893e74",h6="8bbeb160",h11="31f86165",f5="MDEpeNtZ",f6="h7m5n4Mf",f11="o2PUBIn9"},
{t="PtE5eSAN",n=24,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="hth6MYPf",n=12,h5="d7a5d63e",h6="4a893e74",h11="4cbcc2a2",f5="BLKY2IrV",f6="MDEpeNtZ",f11="pZboIHGF"},
{t="MNoIdfUn",n=22,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="SItHVcrp",n=12,h5="31f86165",h6="09d8bef4",h11="d7a5d63e",f5="o2PUBIn9",f6="QV5FvHIL",f11="BLKY2IrV"},
{t="Y76HdQm1",n=35,h5="e9bb563f",h6="09c56a96",h11="d7a5d63e",f5="xRhGae3u",f6="IIq9LOZH",f11="BLKY2IrV"},
{t="qId6jM4R",n=43,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="CM1rGKnH",n=24,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="8Fod6jU1",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="EgVBinkV",n=42,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="MvmBshOn",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="PEqirql6",n=86,h5="83a70c01",h6="4f4d9f0d",h11="40ac6a69",f5="mpIxakPJ",f6="byRCOpAI",f11="cT4XMaZr"},
{t="DZ2VbIUK",n=46,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="1qrBea82",n=12,h5="4a893e74",h6="49c250a6",h11="4cbcc2a2",f5="MDEpeNtZ",f6="fmBtb1Dh",f11="pZboIHGF"},
{t="ou6xcKpr",n=37,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="OOeBKS07",n=27,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="fp1DwXPR",n=22,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="DklquRRt",n=28,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="8YG2we6r",n=21,h5="d7a5d63e",h6="4a893e74",h11="ac08fe53",f5="BLKY2IrV",f6="MDEpeNtZ",f11="uIrWoowi"},
{t="dvQBs8Il",n=23,h5="95c46304",h6="cd889dbc",h11="9611c029",f5="9WAL35qM",f6="L8h7VinJ",f11="VTNrxYhK"},
{t="IYWgKQf0",n=12,h5="4a893e74",h6="c336a25c",h11="31f86165",f5="MDEpeNtZ",f6="E27zoa7X",f11="o2PUBIn9"},
{t="LLeLDaOH",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="ZOJBgY50",n=24,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="V7AINQtp",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="jSz7RdwQ",n=12,h5="ec64918b",h6="d7a5d63e",h11="31f86165",f5="B9h6f9a4",f6="BLKY2IrV",f11="o2PUBIn9"},
{t="Ea5lP5yv",n=41,h5="a4c332a8",h6="9bbb856e",h11="e0a79052",f5="NETPpspy",f6="HKp0lyah",f11="4Chz2o0P"},
{t="EUZPM0P8",n=12,h5="d7a5d63e",h6="4a893e74",h11="4cbcc2a2",f5="BLKY2IrV",f6="MDEpeNtZ",f11="pZboIHGF"},
{t="iaykIw21",n=29,h5="60e13e87",h6="3132608f",h11="c336a25c",f5="NSybVjZW",f6="iTzoRYlr",f11="E27zoa7X"},
{t="Nm0TQY3i",n=12,h5="4a893e74",h6="c336a25c",h11="31f86165",f5="MDEpeNtZ",f6="E27zoa7X",f11="o2PUBIn9"},
{t="BNCyayV7",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="Z5YGpNGQ",n=12,h5="ec64918b",h6="d7a5d63e",h11="31f86165",f5="B9h6f9a4",f6="BLKY2IrV",f11="o2PUBIn9"},
{t="pdMG3nWj",n=23,h5="169d5ed7",h6="82830aed",h11="3132608f",f5="E9ARXHkz",f6="N9x5u6Zj",f11="iTzoRYlr"},
{t="MxiDo2VG",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="fvXnCLeO",n=37,h5="3ccffa7f",h6="d22b948c",h11="b897e2d8",f5="kUTNXZFj",f6="Mi1ttQ1V",f11="RQzW9tCw"},
{t="iBpMg1n2",n=82,h5="83a70c01",h6="4f4d9f0d",h11="ead4dd3f",f5="mpIxakPJ",f6="byRCOpAI",f11="gI7pAcYS"},
{t="kXGcIuIi",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="U2vlVWku",n=21,h5="b6347304",h6="95c46304",h11="c336a25c",f5="PDOsp7Rj",f6="9WAL35qM",f11="E27zoa7X"},
{t="IzGAzB11",n=27,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="BJDSwjuN",n=24,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="SoLWJ5Lg",n=86,h5="83a70c01",h6="4f4d9f0d",h11="40ac6a69",f5="mpIxakPJ",f6="byRCOpAI",f11="cT4XMaZr"},
{t="13NWb9b4",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="g18jjLob",n=41,h5="a4c332a8",h6="9bbb856e",h11="e0a79052",f5="NETPpspy",f6="HKp0lyah",f11="4Chz2o0P"},
{t="qCrez3w1",n=87,h5="83a70c01",h6="4f4d9f0d",h11="7f6b358d",f5="mpIxakPJ",f6="byRCOpAI",f11="pIwOlUyg"},
{t="6hg2aAnG",n=24,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="ipJX9Wyx",n=21,h5="ec64918b",h6="d7a5d63e",h11="4cbcc2a2",f5="B9h6f9a4",f6="BLKY2IrV",f11="pZboIHGF"},
{t="vbcZUKZk",n=11,h5="4cbcc2a2",h6="7030c54e",h11="3132608f",f5="pZboIHGF",f6="JCFA8O9q",f11="iTzoRYlr"},
{t="jTj5zCzv",n=18,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="OyPvwHVR",n=28,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="mfF0o0Gm",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="8hg8HAw6",n=20,h5="2d27198c",h6="6f3ab277",h11="4a893e74",f5="T8Mr110g",f6="sC8CWlnR",f11="MDEpeNtZ"},
{t="V92yZqGg",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="bsBMuIVZ",n=30,h5="95c46304",h6="cd889dbc",h11="9611c029",f5="9WAL35qM",f6="L8h7VinJ",f11="VTNrxYhK"},
{t="TmOKDKTK",n=19,h5="2d27198c",h6="3ccffa7f",h11="d7a5d63e",f5="T8Mr110g",f6="kUTNXZFj",f11="BLKY2IrV"},
{t="6dWX1t6T",n=35,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="giUpqlCN",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="eJk59LKi",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="82mm3kqJ",n=18,h5="67526982",h6="31182caf",h11="c20428c6",f5="h76pxW38",f6="1e0RO6az",f11="YPS57cC4"},
{t="uUQY4v8C",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="1Agpa5Go",n=21,h5="ec64918b",h6="d7a5d63e",h11="4cbcc2a2",f5="B9h6f9a4",f6="BLKY2IrV",f11="pZboIHGF"},
{t="a8VdruCJ",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="3JyWPMmp",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="RdHwBIxp",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="9P3hwtQV",n=46,h5="e725d2d1",h6="83a70c01",h11="a1659a75",f5="LpvOeetG",f6="mpIxakPJ",f11="mXjKo3Oi"},
{t="fECZdbQv",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="JSy55q4b",n=24,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="JhJKzgIx",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="jGPtSa4Q",n=38,h5="3ccffa7f",h6="d22b948c",h11="b897e2d8",f5="kUTNXZFj",f6="Mi1ttQ1V",f11="RQzW9tCw"},
{t="IiVHF36Q",n=38,h5="3ccffa7f",h6="d22b948c",h11="b897e2d8",f5="kUTNXZFj",f6="Mi1ttQ1V",f11="RQzW9tCw"},
{t="0y7l0QeN",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="XZfcNh3y",n=21,h5="ec64918b",h6="d7a5d63e",h11="4cbcc2a2",f5="B9h6f9a4",f6="BLKY2IrV",f11="pZboIHGF"},
{t="rtrfrywL",n=82,h5="83a70c01",h6="4f4d9f0d",h11="9bbb856e",f5="mpIxakPJ",f6="byRCOpAI",f11="HKp0lyah"},
{t="t55cYrRU",n=42,h5="b897e2d8",h6="a1659a75",h11="9a9b14c4",f5="RQzW9tCw",f6="mXjKo3Oi",f11="ubzsdeZ9"},
{t="E7hdT1gf",n=35,h5="e9bb563f",h6="09c56a96",h11="d7a5d63e",f5="xRhGae3u",f6="IIq9LOZH",f11="BLKY2IrV"},
{t="CqC6onVU",n=23,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="Q8WPyCgN",n=24,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="37v4RANg",n=21,h5="ec64918b",h6="d7a5d63e",h11="4cbcc2a2",f5="B9h6f9a4",f6="BLKY2IrV",f11="pZboIHGF"},
{t="ZJ1b9Ahf",n=12,h5="4a893e74",h6="c336a25c",h11="31f86165",f5="MDEpeNtZ",f6="E27zoa7X",f11="o2PUBIn9"},
{t="RrqbQpz4",n=17,h5="4a893e74",h6="95c46304",h11="49c250a6",f5="MDEpeNtZ",f6="9WAL35qM",f11="fmBtb1Dh"},
{t="FlxCS9q5",n=29,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="pJtqnoTt",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="4bJq0jZR",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="sPQLfFt2",n=35,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="K9PDApjZ",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="59vM5uM3",n=87,h5="83a70c01",h6="4f4d9f0d",h11="7f6b358d",f5="mpIxakPJ",f6="byRCOpAI",f11="pIwOlUyg"},
{t="BD5QAD3e",n=24,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="XGR2nJo4",n=27,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="g6BcKTn2",n=34,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="oEM5Garr",n=12,h5="ec64918b",h6="d7a5d63e",h11="31f86165",f5="B9h6f9a4",f6="BLKY2IrV",f11="o2PUBIn9"},
{t="6ugE3vNs",n=27,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="nM6fk00C",n=22,h5="ec64918b",h6="d7a5d63e",h11="6f3ab277",f5="B9h6f9a4",f6="BLKY2IrV",f11="sC8CWlnR"},
{t="Imd1bdSH",n=11,h5="31f86165",h6="09d8bef4",h11="3132608f",f5="o2PUBIn9",f6="QV5FvHIL",f11="iTzoRYlr"},
{t="J4StVAdF",n=46,h5="e725d2d1",h6="83a70c01",h11="a1659a75",f5="LpvOeetG",f6="mpIxakPJ",f11="mXjKo3Oi"},
{t="lkakIMiW",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="gEWqNbKK",n=27,h5="82830aed",h6="cad5b537",h11="09d8bef4",f5="N9x5u6Zj",f6="kxpUORmS",f11="QV5FvHIL"},
{t="UPciGtwi",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="DSABFuE0",n=24,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="1d8UAM8X",n=41,h5="a4c332a8",h6="9bbb856e",h11="e0a79052",f5="NETPpspy",f6="HKp0lyah",f11="4Chz2o0P"},
{t="E44mEnzI",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="yo5XZ75S",n=37,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="k6sOS9E1",n=35,h5="e9bb563f",h6="09c56a96",h11="d7a5d63e",f5="xRhGae3u",f6="IIq9LOZH",f11="BLKY2IrV"},
{t="FzLfCXXL",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="l9182Xsq",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="Ya7auduJ",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="nkAn6ag9",n=35,h5="e9bb563f",h6="09c56a96",h11="d7a5d63e",f5="xRhGae3u",f6="IIq9LOZH",f11="BLKY2IrV"},
{t="Pr77BrvV",n=39,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="JmVdNJdW",n=15,h5="4a893e74",h6="8bbeb160",h11="31f86165",f5="MDEpeNtZ",f6="h7m5n4Mf",f11="o2PUBIn9"},
{t="rYIyZPzu",n=27,h5="49c250a6",h6="31f86165",h11="9d5d6cc7",f5="fmBtb1Dh",f6="o2PUBIn9",f11="SiDCvled"},
{t="L3nSxTaG",n=22,h5="ec64918b",h6="d7a5d63e",h11="6f3ab277",f5="B9h6f9a4",f6="BLKY2IrV",f11="sC8CWlnR"},
{t="6nCDJIIO",n=28,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="r9NkfOBC",n=41,h5="a4c332a8",h6="9bbb856e",h11="e0a79052",f5="NETPpspy",f6="HKp0lyah",f11="4Chz2o0P"},
{t="uy0hfBmC",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="HvWv6fVc",n=15,h5="4a893e74",h6="8bbeb160",h11="31f86165",f5="MDEpeNtZ",f6="h7m5n4Mf",f11="o2PUBIn9"},
{t="zFFmTqVX",n=35,h5="e9bb563f",h6="09c56a96",h11="d7a5d63e",f5="xRhGae3u",f6="IIq9LOZH",f11="BLKY2IrV"},
{t="Ezb6IXvp",n=27,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="9WL7Rliv",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="CXpgv7AO",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="DO8EsVax",n=46,h5="268ac291",h6="0fab729a",h11="5ac80a00",f5="gNCU4IFV",f6="uf4MVqY8",f11="LYy5JbEb"},
{t="GsZftK5s",n=45,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="MIWyUoSq",n=41,h5="a4c332a8",h6="9bbb856e",h11="e0a79052",f5="NETPpspy",f6="HKp0lyah",f11="4Chz2o0P"},
{t="A69xyHpk",n=15,h5="31f86165",h6="09d8bef4",h11="cd889dbc",f5="o2PUBIn9",f6="QV5FvHIL",f11="L8h7VinJ"},
{t="QoHgU161",n=33,h5="9611c029",h6="cc0b45e5",h11="b6347304",f5="VTNrxYhK",f6="eRW24wJv",f11="PDOsp7Rj"},
{t="AYtHsvgZ",n=87,h5="83a70c01",h6="4f4d9f0d",h11="7f6b358d",f5="mpIxakPJ",f6="byRCOpAI",f11="pIwOlUyg"},
{t="VIf1E2DR",n=45,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="XDeQy9oE",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="JKUKBAef",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="A2xzKGnq",n=39,h5="8bbeb160",h6="9a9b14c4",h11="09d8bef4",f5="h7m5n4Mf",f6="ubzsdeZ9",f11="QV5FvHIL"},
{t="ADbtkO2h",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="KYIz3wOe",n=32,h5="9611c029",h6="cc0b45e5",h11="b6347304",f5="VTNrxYhK",f6="eRW24wJv",f11="PDOsp7Rj"},
{t="iQ6EoFmm",n=13,h5="4a893e74",h6="8bbeb160",h11="31f86165",f5="MDEpeNtZ",f6="h7m5n4Mf",f11="o2PUBIn9"},
{t="PnuEPlQR",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="p8Pbgujj",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="zdmjNbiG",n=27,h5="49c250a6",h6="31f86165",h11="9d5d6cc7",f5="fmBtb1Dh",f6="o2PUBIn9",f11="SiDCvled"},
{t="ylnZPCUn",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="yIRNiJvL",n=19,h5="2d27198c",h6="3ccffa7f",h11="d7a5d63e",f5="T8Mr110g",f6="kUTNXZFj",f11="BLKY2IrV"},
{t="y9mcMPJg",n=28,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="D7JCO2Mf",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="o2akuixy",n=27,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="VSWTQQFi",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="qD9SMFSs",n=24,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="wkARpI1b",n=46,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="QTy2ToLH",n=12,h5="ec64918b",h6="d7a5d63e",h11="31f86165",f5="B9h6f9a4",f6="BLKY2IrV",f11="o2PUBIn9"},
{t="4vbuOeX6",n=27,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="xQExJF3F",n=11,h5="4cbcc2a2",h6="7030c54e",h11="3132608f",f5="pZboIHGF",f6="JCFA8O9q",f11="iTzoRYlr"},
{t="yK9rsnyk",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="U4dhYSWp",n=21,h5="ec64918b",h6="d7a5d63e",h11="4cbcc2a2",f5="B9h6f9a4",f6="BLKY2IrV",f11="pZboIHGF"},
{t="GBOzTDQv",n=21,h5="ec64918b",h6="d7a5d63e",h11="4cbcc2a2",f5="B9h6f9a4",f6="BLKY2IrV",f11="pZboIHGF"},
{t="zxLvnAU1",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="loNSFG2W",n=15,h5="4a893e74",h6="8bbeb160",h11="31f86165",f5="MDEpeNtZ",f6="h7m5n4Mf",f11="o2PUBIn9"},
{t="5q80wl2C",n=19,h5="d7a5d63e",h6="4a893e74",h11="4cbcc2a2",f5="BLKY2IrV",f6="MDEpeNtZ",f11="pZboIHGF"},
{t="yMuXzxfg",n=28,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="TvBHuMki",n=45,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="TEDfNjpT",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="BxrSiZJs",n=42,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="Um3MMe4L",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="nqHKoKUy",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="ZRQCfaLJ",n=12,h5="4a893e74",h6="c336a25c",h11="31f86165",f5="MDEpeNtZ",f6="E27zoa7X",f11="o2PUBIn9"},
{t="M9lKJpkm",n=41,h5="a4c332a8",h6="9bbb856e",h11="e0a79052",f5="NETPpspy",f6="HKp0lyah",f11="4Chz2o0P"},
{t="PuouxBx0",n=28,h5="82830aed",h6="cad5b537",h11="09d8bef4",f5="N9x5u6Zj",f6="kxpUORmS",f11="QV5FvHIL"},
{t="bw4G9tXw",n=27,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="M86b4LWW",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="6qEARSB5",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="YXCAELoC",n=34,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="D33t4Yq4",n=21,h5="ec64918b",h6="d7a5d63e",h11="4cbcc2a2",f5="B9h6f9a4",f6="BLKY2IrV",f11="pZboIHGF"},
{t="wlrNDnp6",n=27,h5="0565f571",h6="169d5ed7",h11="9a34c336",f5="iveGBMZF",f6="E9ARXHkz",f11="jCr15Dyv"},
{t="CZrBoIsc",n=46,h5="e725d2d1",h6="83a70c01",h11="a1659a75",f5="LpvOeetG",f6="mpIxakPJ",f11="mXjKo3Oi"},
{t="33tTKuBx",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="ShYEl3p4",n=41,h5="a4c332a8",h6="9bbb856e",h11="e0a79052",f5="NETPpspy",f6="HKp0lyah",f11="4Chz2o0P"},
{t="cG7oY0ES",n=21,h5="ec64918b",h6="d7a5d63e",h11="4cbcc2a2",f5="B9h6f9a4",f6="BLKY2IrV",f11="pZboIHGF"},
{t="1WInU5zi",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="bkw6pFy9",n=46,h5="e725d2d1",h6="83a70c01",h11="a1659a75",f5="LpvOeetG",f6="mpIxakPJ",f11="mXjKo3Oi"},
{t="bTJUrtuo",n=35,h5="e9bb563f",h6="09c56a96",h11="d7a5d63e",f5="xRhGae3u",f6="IIq9LOZH",f11="BLKY2IrV"},
{t="GrRkjKnK",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="mVdLxCvC",n=28,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="wSiN4FfF",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="2UaFstb9",n=21,h5="d7a5d63e",h6="4a893e74",h11="c336a25c",f5="BLKY2IrV",f6="MDEpeNtZ",f11="E27zoa7X"},
{t="oYrsgCxu",n=11,h5="49c250a6",h6="31f86165",h11="3132608f",f5="fmBtb1Dh",f6="o2PUBIn9",f11="iTzoRYlr"},
{t="1y3kV2RF",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="o3mPP8Yy",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="OUSpKVon",n=13,h5="4a893e74",h6="8bbeb160",h11="31f86165",f5="MDEpeNtZ",f6="h7m5n4Mf",f11="o2PUBIn9"},
{t="7E9RrAfA",n=35,h5="e9bb563f",h6="09c56a96",h11="d7a5d63e",f5="xRhGae3u",f6="IIq9LOZH",f11="BLKY2IrV"},
{t="JgyQjtSu",n=32,h5="9611c029",h6="cc0b45e5",h11="b6347304",f5="VTNrxYhK",f6="eRW24wJv",f11="PDOsp7Rj"},
{t="xvcR94QE",n=25,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="0XdGDIMr",n=29,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="Wxqxtfmp",n=92,h5="83a70c01",h6="4f4d9f0d",h11="b897e2d8",f5="mpIxakPJ",f6="byRCOpAI",f11="RQzW9tCw"},
{t="f0QhhXWF",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="FKuPsook",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="HXKv5Hto",n=29,h5="95c46304",h6="cd889dbc",h11="9611c029",f5="9WAL35qM",f6="L8h7VinJ",f11="VTNrxYhK"},
{t="6JJ2KEcW",n=13,h5="4a893e74",h6="8bbeb160",h11="31f86165",f5="MDEpeNtZ",f6="h7m5n4Mf",f11="o2PUBIn9"},
{t="PLWpyKhh",n=27,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="pihpFLlF",n=13,h5="4a893e74",h6="8bbeb160",h11="31f86165",f5="MDEpeNtZ",f6="h7m5n4Mf",f11="o2PUBIn9"},
{t="O1utWERF",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="odBQRXe0",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="HlvPmSLK",n=29,h5="95c46304",h6="cd889dbc",h11="9611c029",f5="9WAL35qM",f6="L8h7VinJ",f11="VTNrxYhK"},
{t="HvmWGMdc",n=20,h5="4a893e74",h6="c336a25c",h11="60e13e87",f5="MDEpeNtZ",f6="E27zoa7X",f11="NSybVjZW"},
{t="onA35xQx",n=34,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="TxZKD7Jt",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="E8PdVbxY",n=98,h5="ea04d444",h6="d92082f9",h11="ec64918b",f5="9XOL6IVs",f6="qXzao97y",f11="B9h6f9a4"},
{t="ykO3xi59",n=45,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="ETvIjb00",n=39,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="vamGR36I",n=19,h5="2d27198c",h6="3ccffa7f",h11="d7a5d63e",f5="T8Mr110g",f6="kUTNXZFj",f11="BLKY2IrV"},
{t="z2t7zI8M",n=46,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="m8zZJCiw",n=46,h5="e725d2d1",h6="83a70c01",h11="a1659a75",f5="LpvOeetG",f6="mpIxakPJ",f11="mXjKo3Oi"},
{t="bb14Em9T",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="dWMgnjBO",n=11,h5="4cbcc2a2",h6="7030c54e",h11="3132608f",f5="pZboIHGF",f6="JCFA8O9q",f11="iTzoRYlr"},
{t="OdO9IpMd",n=28,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="niOqavRX",n=41,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="BI234Nln",n=24,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="BEZhAo5V",n=32,h5="49c250a6",h6="31f86165",h11="9d5d6cc7",f5="fmBtb1Dh",f6="o2PUBIn9",f11="SiDCvled"},
{t="wWaJYoCx",n=31,h5="d8320b91",h6="364ba71a",h11="c336a25c",f5="yOziMCUW",f6="Vgr3qvXE",f11="E27zoa7X"},
{t="KQ4dnvxo",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="DngqTgmg",n=45,h5="82830aed",h6="cad5b537",h11="c336a25c",f5="N9x5u6Zj",f6="kxpUORmS",f11="E27zoa7X"},
{t="wNGBrVCG",n=21,h5="ec64918b",h6="d7a5d63e",h11="4cbcc2a2",f5="B9h6f9a4",f6="BLKY2IrV",f11="pZboIHGF"},
{t="rHVbvgIu",n=27,h5="ec64918b",h6="d7a5d63e",h11="9611c029",f5="B9h6f9a4",f6="BLKY2IrV",f11="VTNrxYhK"},
{t="fYPmjvKj",n=44,h5="e725d2d1",h6="83a70c01",h11="a1659a75",f5="LpvOeetG",f6="mpIxakPJ",f11="mXjKo3Oi"},
{t="8Xb1bA4q",n=20,h5="49c250a6",h6="31f86165",h11="82830aed",f5="fmBtb1Dh",f6="o2PUBIn9",f11="N9x5u6Zj"},
{t="dpTn49Ym",n=11,h5="4a893e74",h6="c336a25c",h11="3ccffa7f",f5="MDEpeNtZ",f6="E27zoa7X",f11="kUTNXZFj"},
{t="iLpqaa4Q",n=12,h5="ec64918b",h6="d7a5d63e",h11="31f86165",f5="B9h6f9a4",f6="BLKY2IrV",f11="o2PUBIn9"},
{t="DR0qy4Oq",n=12,h5="4a893e74",h6="c336a25c",h11="4cbcc2a2",f5="MDEpeNtZ",f6="E27zoa7X",f11="pZboIHGF"},
{t="lD4ajClR",n=46,h5="e725d2d1",h6="83a70c01",h11="a1659a75",f5="LpvOeetG",f6="mpIxakPJ",f11="mXjKo3Oi"},
{t="GRdesBBX",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="incUXe4M",n=35,h5="e9bb563f",h6="09c56a96",h11="d7a5d63e",f5="xRhGae3u",f6="IIq9LOZH",f11="BLKY2IrV"},
{t="txXYboZT",n=28,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="1U4RO9x9",n=82,h5="83a70c01",h6="4f4d9f0d",h11="9bbb856e",f5="mpIxakPJ",f6="byRCOpAI",f11="HKp0lyah"},
{t="nv3XEPTG",n=35,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="CYpr25ch",n=82,h5="83a70c01",h6="4f4d9f0d",h11="9bbb856e",f5="mpIxakPJ",f6="byRCOpAI",f11="HKp0lyah"},
{t="syr4tkzd",n=12,h5="4cbcc2a2",h6="7030c54e",h11="d7a5d63e",f5="pZboIHGF",f6="JCFA8O9q",f11="BLKY2IrV"},
{t="BJ8HSBj6",n=26,h5="98b4aaf0",h6="c336a25c",h11="31f86165",f5="eohDtPWr",f6="E27zoa7X",f11="o2PUBIn9"},
{t="iuhtfy7R",n=13,h5="4a893e74",h6="8bbeb160",h11="31f86165",f5="MDEpeNtZ",f6="h7m5n4Mf",f11="o2PUBIn9"}
}
local MAIN_PREFERRED
for i,p in ipairs(MAIN_CANDIDATES) do
 if p.t==MAIN_BIND_TYPE then MAIN_PREFERRED=p;table.remove(MAIN_CANDIDATES,i);table.insert(MAIN_CANDIDATES,1,p);break end
end
local main_profile_session=nil
local known_main_profiles={}
local known_main_profile_seen={}
local function remember_main_profile(p)
 if not known_main_profile_seen[p.t] and #known_main_profiles<#MAIN_CANDIDATES then
  known_main_profile_seen[p.t]=true;known_main_profiles[#known_main_profiles+1]=p
 end
end
local function hash_of_field(d)
 local h=type(d)=='table' and type(d.id)=='string' and d.id:lower():gsub('^0x','') or ''
 if #h<8 then h=string.rep('0',8-#h)..h end
 return h
end
local function main_schema_ok(p)
 if p.schema_session~=main_profile_session then p.schema_session=main_profile_session;p.schema_ok=nil;p.schema_retry=0 end
 if p.schema_ok==true or (p.schema_ok==false and M.clock<(p.schema_retry or 0)) then return p.schema_ok end
 p.schema_retry=M.clock+5
 p.schema_ok=false
 local info=call(Net.object_info,p.t)
 local fs=type(info)=='table' and info.fields
 if type(fs)=='table' and #fs==p.n then
  p.schema_ok=hash_of_field(fs[5])==p.h5 and hash_of_field(fs[6])==p.h6 and hash_of_field(fs[11])==p.h11
 end
 log('MAIN_SCHEMA type='..p.t..' ok='..tostring(p.schema_ok)..' count='..tostring(type(fs)=='table' and #fs or -1))
 return p.schema_ok
end
local function reset_main_profiles_for_session(session)
 if main_profile_session~=session then main_profile_session=session;known_main_profiles={};known_main_profile_seen={} end
end
local function known_main_profile(session,mid)
 reset_main_profiles_for_session(session)
 for _,p in ipairs(known_main_profiles) do
  if call(GS.game_object_is_type,session,mid,p.t)==true and main_schema_ok(p) then return p end
 end
 return nil
end
local function discover_main_profile(session,mid,c)
 reset_main_profiles_for_session(session)
 if not valid_goid(session,mid) then return nil end
 if MAIN_PREFERRED and call(GS.game_object_is_type,session,mid,MAIN_BIND_TYPE)==true then
  if main_schema_ok(MAIN_PREFERRED) then c.main_profile=MAIN_PREFERRED;c.main_scan_done=true;return MAIN_PREFERRED end
  return nil
 end
 if c.main_scan_done then
  if M.clock<(c.main_retry or 0) then return nil end
  c.main_scan_done=false;c.main_scan_index=1;c.main_retry=M.clock+5
 end
 if c.main_profile and call(GS.game_object_is_type,session,mid,c.main_profile.t)==true and main_schema_ok(c.main_profile) then return c.main_profile end
 local known=known_main_profile(session,mid)
 if known then c.main_profile=known;c.main_scan_done=true;return known end
 local i=c.main_scan_index or 1
 -- Once one fallback batch reveals the dense field count, rows with other counts
 -- are skipped in Lua. At most one native type comparison is made per frame.
 while true do
  local p=MAIN_CANDIDATES[i]
  if not p then c.main_scan_done=true;c.main_retry=M.clock+5;log('MAIN_PROFILE_NO_MATCH goid='..tostring(mid)..' count='..tostring(c.main_observed_count));return nil end
  i=i+1;c.main_scan_index=i
  if c.main_observed_count==nil or p.n==c.main_observed_count then
   if call(GS.game_object_is_type,session,mid,p.t)==true then
    c.main_scan_done=true;c.main_retry=M.clock+5
    if main_schema_ok(p) then
     c.main_profile=p;remember_main_profile(p)
     log('MAIN_PROFILE_MATCH goid='..tostring(mid)..' type='..p.t..' fields='..p.h5..','..p.h6..','..p.h11)
     return p
    end
    log('MAIN_PROFILE_SCHEMA_REJECT goid='..tostring(mid)..' type='..p.t)
   end
   return nil
  end
 end
end
local function bit01(v)
 if v==true then return 1 elseif v==false then return 0 elseif integer(v,1) then return v end
 return nil
end
local function dense_count(t)
 if type(t)~='table' then return nil end
 local n=0
 for k,v in pairs(t) do if type(k)=='number' and k==math.floor(k) and k>n then n=k end end
 return n>=11 and n or nil
end
local function read_main(session,mid,c)
 local p=c.main_profile
 if not p then p=discover_main_profile(session,mid,c) end
 local targeted=p and call(GS.game_object_is_type,session,mid,p.t)==true and main_schema_ok(p) and type(GS.game_object_field)=='function'
 local a,b,total
 if targeted then
  if call(GS.game_object_exists,session,mid)~=true then return end
  a=call(GS.game_object_field,session,mid,p.f5)
  b=call(GS.game_object_field,session,mid,p.f6)
  local b1=bit01(b)
  -- Bastion main gun is 30 in magazine + 1 chambered = 31 total.
  -- Field #11 remains part of declaration identity, but is not ammunition.
  if integer(a,30) and b1~=nil then
   local t=a+b1
   if integer(t,31) then total=t end
  end
 elseif call(GS.game_object_is_type,session,mid,MAIN_BIND_TYPE)==true then
  local mf=sample(session,mid)
  local observed=dense_count(mf)
  if observed and c.main_observed_count==nil then
   c.main_observed_count=observed
   log('MAIN_BATCH_SHAPE goid='..tostring(mid)..' count='..tostring(observed))
  end
  if main_sig(mf) then
   a,b=mf[5],mf[6];local t=a+b
   if integer(t,31) then total=t end
  end
 end
 local mode=targeted and 'targeted' or 'batch'
 local diag=c.main_diag
 if not diag or diag.mode~=mode then
  diag={mode=mode,start=M.clock,attempts=0,valid=0,changed=0};c.main_diag=diag
  log('MAIN_PATH goid='..tostring(mid)..' mode='..mode)
 end
 diag.attempts=diag.attempts+1
 if total~=nil then
  diag.valid=diag.valid+1
  if c.ammo~=nil and total~=c.ammo then diag.changed=diag.changed+1 end
  c.main_reserve=a;c.main_current=bit01(b);c.ammo=total;c.main_seen=true;c.main_valid_at=M.clock
 end
 if M.clock-diag.start>=10 then
  log('MAIN_READ goid='..tostring(mid)..' mode='..mode..' seconds='..string.format('%.1f',M.clock-diag.start)..' attempts='..diag.attempts..' valid='..diag.valid..' changed='..diag.changed..' ammo='..tostring(c.ammo))
  diag.start=M.clock;diag.attempts=0;diag.valid=0;diag.changed=0
 end
end

local function refresh_bound(session,owned_set)
 local hid=M.hull;if not hid then return end
 local c=cache_for(hid);local now=M.clock
 if call(GS.game_object_exists,session,hid)==false then
  log('BASTION_LOST hull='..hid);M.hull=nil;M.cache={};clear_values();return
 end
 local function due(key,interval)
  if now<(c[key] or 0) then return false end
  c[key]=now+interval;return true
 end
 if due('next_hull',0.1) then
  local hf=sample(session,hid)
  if FRV.hull_values(hf,hid) then
   c.hp=hf[30];c.max=hf[15];c.hull_valid_at=now;remember_hull(hid,hf)
   if due('next_weapon_resolve',1) then resolve_bound_weapon_ids(session,hid,hf,c) end
  end
 end
 local mid,cid=c.main_id,c.coax_id
 if due('next_main',0.1) and valid_goid(session,mid) then read_main(session,mid,c) end
 if due('next_coax',0.1) and valid_goid(session,cid) then read_coax(session,cid,c) end
 M.hp,M.max,M.ammo,M.mg=c.hp,c.max,c.ammo,c.mg
end

-- Version-scoped, identity-keyed readers. Only the Win32 adapter reads memory.
-- Pure Lua byte decoding avoids rounding uint64 resource IDs through doubles.
-- Native contracts are explicitly unavailable. Never require loader FFI stubs.
local Native={}
local function unavailable() return nil,'unavailable_in_lua51','UNSUPPORTED' end
for _,name in ipairs({'relation','health','frv_occupancy','frv_slot3','weapon','resolve_proxy'}) do
 Native[name]=unavailable
end
function Native.same(a,b) return a and b and a.goid==b.goid and a.resource==b.resource end

-- A small data-only flat JSON parser. Never execute an editable config as Lua.
local Position = {x=0.714,y=0.90,scale=1,revision=0,next_read=0}
do
 local defaults={x=0.714,y=0.90,scale=1}
 local function parse(s)
  if #s>4096 then return nil,'configuration exceeds 4 KiB' end
  s=s:gsub('^\239\187\191','')
  local at,len=1,#s
  local function ws() while at<=len and s:sub(at,at):match('%s') do at=at+1 end end
  local function quoted()
   if s:sub(at,at)~='"' then error('expected JSON string',0) end
   at=at+1;local out={}
   while at<=len do
    local c=s:sub(at,at);at=at+1
    if c=='"' then return table.concat(out) end
    if c=='\\' then
     local e=s:sub(at,at);at=at+1
     if e=='u' then
      local h=s:sub(at,at+3);if not h:match('^%x%x%x%x$') then error('invalid JSON escape',0) end
      out[#out+1]='\\u'..h;at=at+4
     elseif e=='"' or e=='\\' or e=='/' or e=='n' or e=='r' or e=='t' or e=='b' or e=='f' then out[#out+1]=e
     else error('invalid JSON escape',0) end
    elseif c:byte()<32 then error('control character in string',0)
    else out[#out+1]=c end
   end
   error('unterminated JSON string',0)
  end
  local function decode()
   ws();if s:sub(at,at)~='{' then error('expected JSON object',0) end;at=at+1;ws()
   local out,seen={},{}
   if s:sub(at,at)=='}' then error('missing position keys',0) end
   while true do
    ws();local key=quoted();if seen[key] then error('duplicate key '..key,0) end;seen[key]=true
    ws();if s:sub(at,at)~=':' then error('expected colon',0) end;at=at+1;ws()
    if key:sub(1,1)=='_' then quoted()
    elseif key=='x' or key=='y' or key=='scale' then
     local start=at
     while at<=len and s:sub(at,at):match('[%d%.%+%-%e%E]') do at=at+1 end
     local token=s:sub(start,at-1)
     -- This dictionary intentionally accepts finite ordinary decimal JSON numbers.
     if not (token:match('^%-?%d+$') or token:match('^%-?%d+%.%d+$')) then error('use an ordinary decimal for '..key,0) end
     local digits=token:gsub('^%-','');if digits:match('^0%d') then error('invalid leading zero',0) end
     local v=tonumber(token)
     if not v or v~=v or v==math.huge or v==-math.huge then error('invalid number '..key,0) end
     if key=='scale' then if v<0.5 or v>2 then error('scale must be 0.5..2',0) end
     elseif v<0 or v>1 then error(key..' must be 0..1',0) end
     out[key]=v
    else error('unknown position key '..key,0) end
    ws();local c=s:sub(at,at);at=at+1
    if c=='}' then break elseif c~=',' then error('expected comma or object end',0) end
   end
   ws();if at<=len then error('trailing JSON content',0) end
   if out.x==nil or out.y==nil or out.scale==nil then error('x, y and scale are required',0) end
   return out
  end
  local ok,out=pcall(decode);if ok then return out end;return nil,tostring(out)
 end
 Position.parse=parse

 -- TXT is authoritative after first creation. JSON parser above is migration-only.
 local function ascii_text(s)
  s=s:gsub('^\239\187\191','')
  local le=s:sub(1,2)=='\255\254';local be=s:sub(1,2)=='\254\255'
  if le or be then
   if #s%2~=0 then return nil end
   local t={}
   for i=3,#s,2 do
    local a,b=s:byte(i,i+1);local n=le and (a+b*256) or (b+a*256)
    t[#t+1]=n<128 and string.char(n) or '?'
   end
   return table.concat(t)
  end
  return s
 end
 function Position.parse_txt(s)
  if type(s)~='string' or #s>4096 then return nil,'configuration exceeds 4 KiB' end
  s=ascii_text(s);if not s or s:find('\0',1,true) then return nil,'invalid text encoding' end
  local out={}
  for line in (s..'\n'):gmatch('(.-)\n') do
   line=line:gsub('[#;].*$',''):match('^%s*(.-)%s*$')
   if line~='' then
    local k,v=line:match('^([a-z_]+)%s*=%s*([%d%.%-%+]+)%s*$')
    if not k or (k~='x' and k~='y' and k~='scale') or out[k]~=nil then return nil,'invalid or duplicate setting' end
    if not (v:match('^%d+$') or v:match('^%d+%.%d+$')) then return nil,'use ordinary positive decimals' end
    local n=tonumber(v)
    if not n or n~=n or n==math.huge or (k=='scale' and (n<.5 or n>2)) or (k~='scale' and (n<0 or n>1)) then return nil,'setting out of range' end
    out[k]=n
   end
  end
  if out.x==nil or out.y==nil or out.scale==nil then return nil,'x, y and scale are all required' end
  return out
 end
 function Position.template(v)
  return '# DRIVER HUD 1.4 - FRV HUD position / FRV HUD 位置与大小\r\n'
   ..'# Edit THIS file in Notepad, save, wait about 2 seconds in game.\r\n'
   ..'# 使用记事本修改本文件，保存后约两秒生效；无需重新部署。\r\n'
   ..'# This file is outside the Arsenal ZIP. Do not edit the ZIP copy.\r\n'
   ..'# 本文件位于 AppData，不在安装 ZIP 内；更新 MOD 不会覆盖它。\r\n'
   ..'# x: 0 = left / 左, 1 = right / 右 (HUD centre / 中心)\r\n'
   ..'# y: 0 = top / 顶部, 1 = bottom / 底部 (HUD centre / 中心)\r\n'
   ..'# scale: 0.5 to 2.0 / 大小范围 0.5 至 2.0\r\n'
   ..'# Keep all three settings. Defaults / 默认: x=0.714 y=0.90 scale=1\r\n'
   ..'# Invalid or incomplete edits keep the previous position.\r\n'
   ..'# 格式错误或缺项时保留上次有效设置；不要改文件扩展名。\r\n'
   ..string.format('\r\nx = %.6f\r\ny = %.6f\r\nscale = %.6f\r\n',v.x,v.y,v.scale)
 end
 local function read_file(path)
  local ok,f,err,code=pcall(io.open,path,'rb')
  if not ok then return nil,'open_error' end
  if not f then return nil,(code==2 or (code==nil and err==nil)) and 'missing' or 'open_error' end
  local rok,s=pcall(f.read,f,4097);pcall(f.close,f)
  if not rok or type(s)~='string' then return nil,'read_error' end
  return s
 end
 function Position.reload(now)
  if now<Position.next_read then return end;Position.next_read=now+2
  if not dir or not io or not io.open then return end
  local path=dir..'/Arrowhead/Helldivers2/frv_hud_position.txt'
  local content,reason=read_file(path)
  local value,why
  if content then value,why=Position.parse_txt(content)
  elseif reason=='missing' then
   -- Do not revert to obsolete JSON after a player's TXT has already been loaded.
   value={x=Position.x,y=Position.y,scale=Position.scale}
   if not Position.txt_seen then
    local old=read_file(dir..'/Arrowhead/Helldivers2/frv_hud_position.json')
    local imported=old and parse(old);if imported then value=imported end
   end
   if now>=(Position.next_create or 0) then
    Position.next_create=now+30
    -- Recheck immediately before creation; never intentionally truncate an existing file.
    local check,absent=read_file(path)
    if not check and absent=='missing' then
     local ok,f=pcall(io.open,path,'wb')
     if ok and f then
      local wrote,result=pcall(f.write,f,Position.template(value));pcall(f.close,f)
      if wrote and result~=nil then Position.txt_seen=true;log('FRV_CONFIG created=frv_hud_position.txt') end
     end
    end
   end
  else return end
  if not value then
   if Position.error~=why then log('FRV_CONFIG rejected='..tostring(why)..' keeping_previous=true');Position.error=why end
   return
  end
  if content then Position.txt_seen=true end
  Position.error=nil
  if value.x~=Position.x or value.y~=Position.y or value.scale~=Position.scale then
   Position.x,Position.y,Position.scale=value.x,value.y,value.scale;Position.revision=Position.revision+1
   log('FRV_CONFIG x='..value.x..' y='..value.y..' scale='..value.scale)
  end
 end
end

-- The vehicle resolver owns identity. Health failure never invokes a second resolver.
FRV = {next_poll=0}
FRV.profiles={["cc21c7ffd3ebefb9"]={name="hmg_frv",t="MJAkcNku",fields={"50ac6619","a09ccd0a","b19ad128","d7082cbf","dab52fe8","0565f571","169d5ed7","82830aed","cad5b537","9ddf0683","95417727","a5f83fa0","9256767e","7f6b358d","788b9753","99901914","1dd07f05","39d141d6","98b4aaf0","e144c5e3","6fa852e3","6d2d83f8","7d9563dd","d8819b3e","cb0453ea","9d550ad3","bbecde19","8fd2d63e","c336a25c","af4c7e8a","0d4e190d","308e0842","0c0bd772","d9810f60","3b5a954f","6396946a","791943f0","91f98cec","7615f45d","eeb1225e","cca43d10","5a8871e3","e00857ad","d648e3a3","4828beb2","8db8f9a4","13daabe6","b23ad39c","ad7ddda8","fafc1456","b8ba2a04","5b7d5691","da1ad977","256605bd","dba62235","da68ae40","42f493f9","69a28ffa","93699a9f","f4b46247","f299681b","6ed6cc5a","bd5b4583","3ccffa7f"}},["9b2140378640432e"]={name="supply_frv",t="3LHk6DNB",fields={"50ac6619","a09ccd0a","b19ad128","d7082cbf","dab52fe8","0565f571","169d5ed7","82830aed","cad5b537","9ddf0683","95417727","a5f83fa0","9256767e","7f6b358d","788b9753","99901914","1dd07f05","39d141d6","98b4aaf0","e144c5e3","6d2d83f8","7d9563dd","d8819b3e","cb0453ea","9d550ad3","bbecde19","8fd2d63e","c336a25c","af4c7e8a","0d4e190d","308e0842","0c0bd772","d9810f60","3b5a954f","6396946a","791943f0","91f98cec","7615f45d","eeb1225e","cca43d10","5a8871e3","e00857ad","d648e3a3","4828beb2","8db8f9a4","13daabe6","b23ad39c","ad7ddda8","fafc1456","b8ba2a04","5b7d5691","da1ad977","256605bd","dba62235","da68ae40","42f493f9","69a28ffa","93699a9f","f4b46247","f299681b","6ed6cc5a","bd5b4583","3ccffa7f","69889752","a5ae4500"}}}
FRV.profile_resources={['cc21c7ffd3ebefb9']=true,['9b2140378640432e']=true}
-- Only this already observed Bastion resource gets the early direct path.
FRV.tank_resources={['16474112801385b6']=true,['b0c9faf4af8903f9']=true}
FRV.zone_hashes={'fed0a478','f3cb00ad','c6bf05a9','f12186b7'}
local function reset_proxy_state()
 FRV.proxy_key=nil;FRV.proxy_vehicle=nil;FRV.proxy_retry=0;FRV.proxy_log=nil;FRV.proxy_log_at=nil
 FRV.proxy_reject_key=nil;FRV.proxy_reject_count=0;FRV.proxy_negative=false
 FRV.proxy_tank_key=nil;FRV.proxy_uncertain_count=0
end
local function reset_invalid_backoff()
 FRV.invalid_key=nil;FRV.invalid_streak=0;FRV.invalid_until=0
end
local function apply_invalid_backoff(session,avatar,kind,why)
 -- Table/owner lifecycle changes still fail closed, but must not impose a
 -- five-second lockout on a legitimate seat/vehicle transition.
 local text=tostring(why)
 local stable=text:match('^identity lookup probe limit') or text:match('^invalid ')
  or text=='read bounds' or text=='noncanonical pointer' or text=='native sample budget'
 if kind~='INVALID' or not stable then reset_invalid_backoff();return end
 local stage=text:match('stage=([^ ]+)');local lookup_key=text:match(' key=([^ ]+)')
 local reason=stage and ('lookup:'..stage..':'..tostring(lookup_key)) or text
 local key=table.concat({tostring(session),tostring(avatar),tostring(kind),reason},':')
 if FRV.invalid_key==key then FRV.invalid_streak=(FRV.invalid_streak or 0)+1
 else FRV.invalid_key=key;FRV.invalid_streak=1 end
 local delay=FRV.invalid_streak==1 and 0.25 or (FRV.invalid_streak==2 and 1.0 or 5.0)
 FRV.invalid_until=M.clock+delay;FRV.next_poll=FRV.invalid_until
end
function FRV.schema(p,session)
 if p.session~=session then p.session=session;p.ok=nil;p.retry=0 end
 if p.ok==true then return true end
 if M.clock<(p.retry or 0) then return false end;p.retry=M.clock+5
 local info=call(Net.object_info,p.t);local fs=type(info)=='table' and info.fields
 if type(fs)~='table' then return false end
 local n=0;local valid=true
 for k in pairs(fs) do
  if type(k)~='number' or k~=math.floor(k) or k<1 or k>#p.fields then valid=false;break end;n=n+1
 end
 if n~=#p.fields then valid=false end
 if valid then for i,v in ipairs(p.fields) do if hash_of_field(fs[i])~=v then valid=false;break end end end
 if p.ok~=valid then log('FRV_SCHEMA type='..p.name..' ok='..tostring(valid)) end
 p.ok=valid;return valid
end
function FRV.invalidate(reason)
 if FRV.reset_occupancy then FRV.reset_occupancy(reason) end
 if FRV.vehicle then log('FRV_LOST entity='..FRV.vehicle.entity..' goid='..FRV.vehicle.goid..' reason='..reason) end
 FRV.vehicle=nil;FRV.profile=nil;FRV.hp=nil;FRV.max=nil;FRV.data=nil;FRV.data_at=nil;FRV.log_key=nil;FRV.lua_health_ok=nil
end
function FRV.reset()
 FRV.last_relation=nil;FRV.relation_at=nil;FRV.relation_session=nil;FRV.relation_avatar=nil;FRV.grace_until=nil
 FRV.invalidate('context_reset');FRV.next_poll=0;FRV.mode=nil;FRV.identity_key=nil;FRV.block_legacy=false;FRV.native_seen=false
 reset_proxy_state();reset_invalid_backoff();FRV.probe_log=nil;FRV.probe_log_at=nil
 FRV.poll_session=nil;FRV.poll_avatar=nil;FRV.last_error=nil;FRV.native_error_at=nil
end
function FRV.drop_tank()
 if Tank then Tank.detach() end
 if M.hull then log('BASTION_CONTEXT_CLEAR hull='..M.hull) end
 M.hull=nil;M.cache={};M.pending_bind=nil;M.ownership=nil;M.seat_scan=nil;M.seat_hint=nil;clear_values()
end
function FRV.wheel_model(data,i)
 if not data then return {kind='unknown'} end
 local state=data.damage and data.damage[i]
 if state==2 then return {kind='hub',state=2} end
 local hp,mx=data.hp and data.hp[i],data.max and data.max[i]
 local hp_ok=(data.hp_valid==nil or data.hp_valid[i]~=false)
 if data.precision=='LOCAL_RUNTIME' and hp_ok and type(hp)=='number' and type(mx)=='number' and mx>0 then
  return {kind='tire',ratio=math.max(0,math.min(1,hp/mx)),state=state,precision='LOCAL_RUNTIME'}
 end
 local q=data.q and data.q[i]
 if q~=nil and q>=0 and q<=3 and q==math.floor(q) then
  return {kind='tire',ratio=q/3,upper=math.min(1,(q+1)/3),state=state,precision='QUANTIZED_OR_UNKNOWN'}
 end
 return {kind='unknown',state=state}
end
function FRV.color(ratio)
 if ratio==nil then return {148,155,157} end
 if ratio<=0.5 then return {255,96,83} elseif ratio<=0.75 then return {255,205,83} end
 return {240,244,239}
end
function FRV.body_valid(hp,mx)
 -- Values may be fractional; finiteness and a bounded range matter here.
 return type(mx)=='number' and mx==mx and mx>0 and mx<=10000000
  and type(hp)=='number' and hp==hp and hp>=0 and hp<=mx
end
function FRV.read(session)
 local d,p=FRV.vehicle,FRV.profile
 if not d or not p then return end
 -- Named Lua getters retain their exact type/schema guards. Failure of that
 -- OPTIONAL channel must not erase the separately validated vehicle or Native
 -- Health/seat channels. Positive destruction still ends the whole binding.
 local exists=call(GS.game_object_exists,session,d.goid)
 if exists==false then FRV.invalidate('explicit_destroy');return end
 local lua_ok=exists==true and call(GS.game_object_is_type,session,d.goid,p.t)==true and FRV.schema(p,session)
 local hp,mx
 if lua_ok then
  hp=call(GS.game_object_field,session,d.goid,'sd7m7FWA')
  mx=call(GS.game_object_field,session,d.goid,'nZ5Vxt8x')
 end
 if FRV.lua_health_ok~=lua_ok then
  FRV.lua_health_ok=lua_ok
  log('FRV_LUA_HEALTH available='..tostring(lua_ok)..' native_channel_independent=true')
 end
 local data,why=Native.health(d,FRV.zone_hashes)
 if data then FRV.data=data;FRV.data_at=M.clock;FRV.read_error=nil
 else
  -- No indefinitely stale bars. Keep only a short last-good display for THIS ID.
  if not FRV.data_at or M.clock-FRV.data_at>0.25 then FRV.data=nil end
  if FRV.read_error~=why or M.clock>=(FRV.error_log_at or 0) then
   log('FRV_READ_REJECT entity='..d.entity..' reason='..tostring(why));FRV.read_error=why;FRV.error_log_at=M.clock+10
  end
 end
 if not FRV.body_valid(hp,mx) then hp=data and data.body end
 if FRV.body_valid(hp,mx) then FRV.hp=hp;FRV.max=mx
 elseif type(hp)=='number' and hp==hp and hp>=0 and hp<=10000000 and (mx==nil or not lua_ok) then
  -- An independently validated current HP can be shown without inventing a
  -- maximum or a health percentage. Unknown maximum => neutral body outline.
  FRV.hp=hp;FRV.max=nil
 else FRV.hp=nil;FRV.max=nil end
 if data then
  local valid_bits={}
  for i=1,4 do valid_bits[i]=(not data.hp_valid or data.hp_valid[i]~=false) and '1' or '0' end
  local valid_text=table.concat(valid_bits,'')
  local sync_status=data.sync_valid and 'OK' or tostring(data.sync_error or 'unavailable')
  local key=table.concat({d.entity,d.goid,data.flags,tostring(data.synced_flags),data.precision,sync_status,table.concat(data.hp,','),valid_text,table.concat(data.max,','),table.concat(data.q or {},','),table.concat(data.damage,','),tostring(FRV.hp)},'|')
  if key~=FRV.log_key and M.clock>=(FRV.log_at or 0) then
   log('FRV_STATE resource='..d.resource..' entity='..d.entity..' goid='..d.goid..' authority_bit0='..tostring(data.flags%2==1)
    ..' precision='..data.precision..' sync='..sync_status..' hp='..table.concat(data.hp,',')..' hp_valid='..valid_text..' max='..table.concat(data.max,',')
    ..' q2='..table.concat(data.q or {},',')..' damage='..table.concat(data.damage,',')..' body='..tostring(FRV.hp)
    ..' health_index='..data.health_index..' read_bytes='..data.bytes..' read_calls='..data.calls)
   FRV.log_key=key;FRV.log_at=M.clock+0.5
  end
 end
end
function FRV.poll_tank(session,d)
 -- poll() has just validated the same native relation and clears M.hull on
 -- identity change. refresh_bound owns ongoing HP/weapon sampling and expiry.
 if call(GS.game_object_exists,session,d.goid)==false then FRV.drop_tank();FRV.mode='NONE';return FRV.mode end
 if FRV.mode=='TANK' and M.hull and M.vehicle_ref==d.goid
  and (valid_goid(session,M.hull) or (M.hull==d.goid and FRV.exact_tank(session,d))) then return 'TANK' end
 FRV.invalidate('not_frv');FRV.block_legacy=true;FRV.mode='PENDING'
 -- Tank HP/ammo readers below are retained from 1.2.1. Only identity acquisition
 -- gains this exact collection relation, including direct-to-gunner entry.
 local hf=sample(session,d.goid)
 -- A missing batch is not negative evidence for an unknown vehicle.
 FRV.tank_probe_complete=type(hf)=='table' and next(hf)~=nil
 if FRV.bind_exact_tank(session,d,hf) then FRV.mode='TANK';return FRV.mode end
 if hull_sig(hf) then
  bind_hull(d.goid,hf,'native_seater');M.vehicle_ref=d.goid;FRV.mode='TANK';return FRV.mode
 end
 local hid,hull=resolve_weapon_hull(session,d.goid)
 if hid then bind_hull(hid,hull,'native_seater');M.vehicle_ref=d.goid;FRV.mode='TANK';return FRV.mode end
 -- A budget miss may retain only a tank already tied to this unchanged native ID.
 -- It never authorizes the old avatar reference to pick some other hull.
 if M.hull and (M.hull==d.goid or M.vehicle_ref==d.goid) then FRV.mode='TANK'
 else FRV.drop_tank();FRV.mode='NONE' end
 return FRV.mode
end
function FRV.clear_identity(reason)
 FRV.grace_until=nil;FRV.last_relation=nil;FRV.relation_at=nil;FRV.identity_key=nil
 reset_proxy_state()
 FRV.invalidate(reason);FRV.drop_tank();FRV.mode='NONE'
end
function FRV.can_hold(session,avatar)
 local function retained(id)return integer(id,32766) and id>0 and call(GS.game_object_exists,session,id)~=false end
 if FRV.relation_session~=session or FRV.relation_avatar~=avatar then return false end
 if not FRV.last_relation or not retained(FRV.last_relation.vehicle.goid) then return false end
 if FRV.mode=='FRV' then
  return FRV.vehicle~=nil and retained(FRV.vehicle.goid)
 elseif FRV.mode=='TANK' then return retained(M.hull) end
 return false
end
function FRV.poll(session,avatar,entry_relation)
 if FRV.poll_session~=session or FRV.poll_avatar~=avatar then
  FRV.reset();FRV.poll_session=session;FRV.poll_avatar=avatar
 end
 -- Explicit destruction ends retention even while the native reader is unavailable.
 if FRV.grace_until and not FRV.can_hold(session,avatar) then
  FRV.clear_identity('native_read_grace_expired')
 end
 if M.clock<FRV.next_poll then return FRV.mode end
 FRV.next_poll=M.clock+0.1 -- Time based, no catch-up burst and no whole-world scan.
 local relation,why,kind=entry_relation
 if not relation then relation,why,kind=Native.relation(avatar,M.clock,FRV.last_relation) end
 if not relation then
  apply_invalid_backoff(session,avatar,kind,why)
  local probe_detail=type(why)=='string' and why:match('^identity lookup probe limit%s+(.+)$')
  if probe_detail and (FRV.probe_log~=probe_detail or M.clock>=(FRV.probe_log_at or 0)) then
   log('IDENTITY_LOOKUP_LIMIT '..probe_detail);FRV.probe_log=probe_detail;FRV.probe_log_at=M.clock+10
  end
  if FRV.last_error~=why or M.clock>=(FRV.native_error_at or 0) then
   log('NATIVE_UNAVAILABLE kind='..tostring(kind)..' reason='..tostring(why));FRV.last_error=why;FRV.native_error_at=M.clock+10
  end
  if kind=='TRANSIENT_READ' and FRV.last_relation and FRV.relation_at
   and FRV.can_hold(session,avatar) then
   if not FRV.grace_until then log('NATIVE_READ_GRACE retain_until_identity_result=true mode='..FRV.mode) end
   FRV.grace_until=FRV.relation_at+0.3
   return FRV.mode -- Display only: no Health refresh or alternative vehicle search.
  end
  -- Once a native relation was in use, a missed read must NOT revive stale tank
  -- references/ownership hints. Only a verified relation or explicit exit resets it.
  if FRV.native_seen or FRV.block_legacy then
   FRV.clear_identity('native_identity_unavailable')
  else FRV.mode='LEGACY' end
  return FRV.mode
 end
 FRV.last_error=nil;FRV.grace_until=nil;reset_invalid_backoff()
 if relation.status=='NO_SEATER' then
  FRV.last_relation=nil;FRV.relation_at=nil
  if FRV.native_seen then FRV.clear_identity('seater_gone')
  else FRV.mode='LEGACY' end
  return FRV.mode
 end
 FRV.native_seen=true
 if relation.status~='VEHICLE' then
  FRV.clear_identity('collection_empty');FRV.identity_key=nil;return FRV.mode
 end
 FRV.last_relation=relation;FRV.relation_at=M.clock;FRV.relation_session=session;FRV.relation_avatar=avatar
 local collection=relation.vehicle
 local proxy_key=table.concat({avatar,relation.avatar.entity,collection.entity,collection.goid,collection.resource,collection.unit},':')
 if FRV.identity_key~=proxy_key then
  FRV.invalidate('identity_changed');FRV.drop_tank();FRV.identity_key=proxy_key
  reset_proxy_state()
  log('NATIVE_VEHICLE avatar='..avatar..' avatar_entity='..relation.avatar.entity..' entity='..collection.entity..' goid='..collection.goid..' resource='..collection.resource..' unit='..tostring(collection.unit)..' role_raw='..relation.role)
 end
 local d=collection
 local p=FRV.profiles[d.resource]
 if not p and (FRV.tank_resources[collection.resource]
  or call(GS.game_object_is_type,session,collection.goid,'rHVbvgIu')==true
  or call(GS.game_object_is_type,session,collection.goid,'fZwFCDKT')==true) then
  return FRV.poll_tank(session,collection)
 end
 if not p then
  -- Two conclusive misses suppress further proxy scans for this identity.
  -- Incomplete/ambiguous scans cannot establish that fact and back off instead.
  -- A successful weak tank bind is latched to the same validated relation.
  if FRV.proxy_tank_key==proxy_key then return FRV.poll_tank(session,collection) end
  if FRV.proxy_key==proxy_key and FRV.proxy_vehicle then
   d=FRV.proxy_vehicle;p=FRV.profiles[d.resource]
  elseif FRV.proxy_negative then
   FRV.block_legacy=true;FRV.mode='NONE';return FRV.mode
  elseif M.clock<(FRV.proxy_retry or 0) then
   FRV.block_legacy=true;FRV.mode='NONE';return FRV.mode
  else
   local resolved,meta=Native.resolve_proxy(collection,FRV.profile_resources)
   FRV.proxy_retry=M.clock+0.5
   if resolved then
    d=resolved;p=FRV.profiles[d.resource];FRV.proxy_key=proxy_key;FRV.proxy_vehicle=d
    FRV.proxy_reject_key=nil;FRV.proxy_reject_count=0;FRV.proxy_negative=false
    log('FRV_PROXY_RESOLVE proxy_entity='..collection.entity..' proxy_goid='..collection.goid..' proxy_resource='..collection.resource
     ..' unit='..tostring(collection.unit)..' hull_entity='..d.entity..' hull_goid='..d.goid..' hull_resource='..d.resource
     ..' evidence='..tostring(type(meta)=='table' and meta.reason or meta))
   else
    -- Preserve the pre-1.4.6 weak tank-shaped recognition seam, but bound it to
    -- the same proxy attempts instead of running it on every 0.1 s poll.
    local tank_mode=FRV.poll_tank(session,collection)
    if tank_mode=='TANK' then
     FRV.proxy_reject_key=nil;FRV.proxy_reject_count=0;FRV.proxy_negative=false
     FRV.proxy_tank_key=proxy_key;FRV.proxy_uncertain_count=0
     return tank_mode
    end
    local reason=type(meta)=='table' and tostring(meta.reason) or tostring(meta)
    local candidates=type(meta)=='table' and tostring(meta.candidates) or 'error'
    local detail=type(meta)=='table' and ('reason='..reason..' unit='..tostring(meta.unit)..' entries='..tostring(meta.entries)..' candidates='..candidates) or reason
    local reject_key=proxy_key..'|'..reason..'|'..candidates
    if FRV.proxy_log~=reject_key or M.clock>=(FRV.proxy_log_at or 0) then
     log('FRV_PROXY_REJECT proxy_entity='..collection.entity..' proxy_goid='..collection.goid..' proxy_resource='..collection.resource..' '..detail)
     FRV.proxy_log=reject_key;FRV.proxy_log_at=M.clock+5
    end
    local conclusive=FRV.tank_probe_complete and type(meta)=='table' and (
     (meta.reason=='no exact same-unit FRV Health owner' and meta.candidates==0
      and type(meta.entries)=='number' and meta.entries>0)
     or meta.reason=='proxy has no usable unit key')
    if conclusive then
     FRV.proxy_uncertain_count=0
     if FRV.proxy_reject_key==reject_key then FRV.proxy_reject_count=(FRV.proxy_reject_count or 0)+1
     else FRV.proxy_reject_key=reject_key;FRV.proxy_reject_count=1 end
     if FRV.proxy_reject_count>=2 then
      FRV.proxy_negative=true
      log('FRV_PROXY_NEGATIVE_CACHE proxy_entity='..collection.entity..' proxy_goid='..collection.goid..' proxy_resource='..collection.resource
       ..' unit='..tostring(collection.unit)..' reason='..reason..' candidates='..candidates..' attempts='..tostring(FRV.proxy_reject_count))
     end
    else
     FRV.proxy_reject_key=nil;FRV.proxy_reject_count=0
     FRV.proxy_uncertain_count=math.min(4,(FRV.proxy_uncertain_count or 0)+1)
     local delays={0.5,1,2,5}
     FRV.proxy_retry=M.clock+delays[FRV.proxy_uncertain_count]
    end
    FRV.block_legacy=true;FRV.mode='NONE';return FRV.mode
   end
  end
 end
 if p then
  FRV.block_legacy=true;FRV.mode='FRV';FRV.drop_tank()
  FRV.vehicle=d;FRV.profile=p;FRV.read(session);return FRV.mode
 end
 -- Directly supported tanks were handled above. Any remaining native identity is
 -- unsupported for this version and stays fail-closed until the identity changes.
 FRV.block_legacy=true;FRV.mode='NONE';return FRV.mode
end

-- A verified native collection/resource establishes which HUD to show.
-- Optional HP replication does not establish (or erase) that identity.
-- The legacy 8000-HP heuristic remains unchanged for all weak discovery paths.
function FRV.exact_tank(session,d)
 local r=FRV.last_relation
 return d and FRV.tank_resources[d.resource]==true and r and r.status=='VEHICLE'
  and Native.same(r.vehicle,d) and FRV.relation_session==session
  and FRV.relation_avatar==M.avatar and not FRV.grace_until
  and FRV.relation_at and M.clock-FRV.relation_at>=0 and M.clock-FRV.relation_at<=.25
end
function FRV.hull_values(f,hid)
 if hull_sig(f) then return true end
 local d=FRV.last_relation and FRV.last_relation.vehicle
 if not d or d.goid~=hid or not FRV.exact_tank(M.session,d) or type(f)~='table' then return false end
 return FRV.body_valid(f[30],f[15])
end
function FRV.bind_exact_tank(session,d,hf)
 if not FRV.exact_tank(session,d) or call(GS.game_object_exists,session,d.goid)==false then return false end
 if M.hull~=d.goid then
  FRV.drop_tank()
  M.hull=d.goid;M.bind_retry=0;M.bind_weak=false;M.pending_bind=nil;M.seat_hint=nil;M.seat_scan=nil;M.ownership=nil
  local c={bound_at=M.clock,next_hull=M.clock,next_main=M.clock,next_coax=M.clock+.066667,next_weapon_resolve=M.clock}
  -- Preserve the old weapon resolver's separately type-checked candidate seam.
  -- New tanks use only their explicit child references in Tank.refresh_new.
  if d.resource~='b0c9faf4af8903f9' then c.main_id=d.goid-2;c.coax_id=d.goid-1 end
  M.cache={[d.goid]=c}
  log('BASTION_BIND native_exact_resource hull='..d.goid..' resource='..d.resource)
 end
 local c=cache_for(d.goid)
 if FRV.hull_values(hf,d.goid) then
  c.hp,c.max,c.hull_valid_at=hf[30],hf[15],M.clock;remember_hull(d.goid,hf)
 end
 M.vehicle_ref=d.goid;M.hp,M.max,M.ammo,M.mg=c.hp,c.max,c.ammo,c.mg
 return true
end

-- Independent 20 Hz occupancy channel. The 10 Hz vehicle/Health scheduler and
-- all RC2 Tank readers remain unchanged. No catch-up burst after a slow frame.
local FrvSeats={period=.05,next_due=0,revision=0,slots={},status='UNKNOWN',cursor=0}
FRV.seats=FrvSeats
local function seat_identity(d)
 if not d then return '-' end
 return table.concat({d.entity,d.goid,d.unit,d.resource},'/')
end
FRV.seat_identity=seat_identity
local function seats_key(slots)
 local out={}
 for i=1,4 do local v=slots[i];out[i]=v and (v.kind..'/'..seat_identity(v.avatar)) or 'UNKNOWN/-' end
 return table.concat(out,',')
end
function FrvSeats.publish(slots,status)
 local key=seats_key(slots)
 if FrvSeats.key~=key then FrvSeats.revision=FrvSeats.revision+1;FrvSeats.key=key end
 FrvSeats.slots=slots;FrvSeats.status=status
end
function FrvSeats.unknown()
 local slots={};for i=1,4 do slots[i]={kind='UNKNOWN'} end
 FrvSeats.publish(slots,'UNKNOWN')
end
function FRV.reset_occupancy(reason)
 FrvSeats.unknown();FrvSeats.snapshot=nil;FrvSeats.valid_at=nil;FrvSeats.next_due=0
 FrvSeats.context=nil;FrvSeats.node_key=nil;FrvSeats.error=nil;FrvSeats.last_change=nil
 if FRV.reset_slot3 then FRV.reset_slot3(reason) end
end
-- Visual/scheduler identity snapshots use copied scalar fields. Native still
-- performs its complete roundtrip/owner checks at every actual 20 Hz sample.
local function same_descriptor(a,b)
 if not a or not b then return a==b end
 return a.entity==b.entity and a.goid==b.goid and a.unit==b.unit and a.resource==b.resource
end
local function copy_descriptor(d)
 return d and {entity=d.entity,goid=d.goid,unit=d.unit,resource=d.resource} or nil
end
local function context_matches(c,session,avatar)
 local relation=FRV.last_relation
 return c and c.session==session and c.avatar==avatar and c.identity==FRV.identity_key
  and same_descriptor(c.vehicle,FRV.vehicle) and same_descriptor(c.collection,relation and relation.vehicle)
  and same_descriptor(c.local_avatar,relation and relation.avatar)
end
local function capture_context(session,avatar)
 local relation=FRV.last_relation
 return {session=session,avatar=avatar,identity=FRV.identity_key,vehicle=copy_descriptor(FRV.vehicle),
  collection=copy_descriptor(relation and relation.vehicle),local_avatar=copy_descriptor(relation and relation.avatar)}
end
function FrvSeats.active(session,avatar)
 return M.seated and FRV.mode=='FRV' and FRV.vehicle and FRV.last_relation
  and not FRV.grace_until and FRV.relation_session==session and FRV.relation_avatar==avatar
end
function FrvSeats.tick(session,avatar)
 if not FrvSeats.active(session,avatar) then
  if FrvSeats.context or FrvSeats.snapshot then FRV.reset_occupancy('inactive') end
  return
 end
 local now=M.clock
 if not context_matches(FrvSeats.context,session,avatar) then
  FRV.reset_occupancy('identity');FrvSeats.context=capture_context(session,avatar)
 end
 if FrvSeats.valid_at and now-FrvSeats.valid_at>.100001 then FrvSeats.unknown() end
 if now+1e-7<FrvSeats.next_due then return end
 if FrvSeats.next_due==0 then FrvSeats.next_due=now end
 local missed=math.max(1,math.floor((now-FrvSeats.next_due+1e-7)/FrvSeats.period)+1)
 FrvSeats.next_due=FrvSeats.next_due+missed*FrvSeats.period
 local sample,why,kind=Native.frv_occupancy(FRV.last_relation,FRV.vehicle,now)
 if sample then
  FrvSeats.snapshot=sample;FrvSeats.valid_at=now;FrvSeats.error=nil
  FrvSeats.publish(sample.slots,'VALID')
  local raw={}
  for _,r in ipairs(sample.rows or {}) do raw[#raw+1]=(r.local_player and 'self' or 'other')..':'..table.concat(r.nodes,'/') end
  local node_key=table.concat(raw,',')
  if C.debug and (FrvSeats.last_change~=FrvSeats.key or FrvSeats.node_key~=node_key) then
   local display={};for i=1,4 do display[i]=sample.slots[i].kind end
   log(string.format('FRV_OCC_STATE t=%.3f hull=%s states=%s nodes14_18_1c=%s dense=%d',
    now,tostring(FRV.vehicle.goid),table.concat(display,','),node_key,sample.count or 0))
   FrvSeats.last_change=FrvSeats.key;FrvSeats.node_key=node_key
  end
 else
  -- A short byte copy may keep at most 100 ms of THIS identity. Any evidence
  -- of a transition/owner conflict immediately removes the old orange claim.
  if kind~='TRANSIENT_READ' or not FrvSeats.valid_at or now-FrvSeats.valid_at>.100001 then
   FrvSeats.unknown()
  else FrvSeats.status='HELD' end
  if FrvSeats.error~=why or now>=(FrvSeats.error_at or 0) then
   log('FRV_OCC_REJECT reason='..tostring(why)..' isolated=true');FrvSeats.error=why;FrvSeats.error_at=now+10
  end
 end

end
function FRV.tick_occupancy(session,avatar)
 local ok,err=pcall(FrvSeats.tick,session,avatar)
 if not ok then
  FrvSeats.unknown();FrvSeats.next_due=M.clock+.05
  if M.clock>=(FrvSeats.throw_at or 0) then
   log('FRV_OCC_ERROR isolated=true '..tostring(err));FrvSeats.throw_at=M.clock+10
  end
 end
 if FRV.tick_slot3 then
  local good,why=pcall(FRV.tick_slot3,session,avatar)
  if not good then
   FRV.reset_slot3('exception')
   if M.clock>=(FrvSeats.icon_error_at or 0) then
    log('FRV_SLOT3_ERROR isolated=true '..tostring(why));FrvSeats.icon_error_at=M.clock+10
   end
  end
 end
end
FrvSeats.unknown()

-- DRIVER HUD extension API 1. An addon supplies DATA, never a draw callback,
-- network accessor, shared GUI or a replacement core. Copies are validated and
-- normalized once so mutable addon tables cannot corrupt retained GUI state.
local FrvSlot3={api=1,pack=nil,rows={},cursor=0,revision=0,next_pending=0,visual_faults={}}
local registered=setmetatable({}, {__mode='kv'}) -- successful DATA sources, no owning references
local seen_pending=setmetatable({}, {__mode='k'})
FRV.slot3=FrvSlot3
local SLOT3_PENDING='__DRIVER_HUD_SLOT3_ICONS_V1'
local function plain(t) return type(t)=='table' and getmetatable(t)==nil end
local function compile_layer(rows,size)
 if not plain(rows) then return nil,'mask must be a plain table' end
 local n=0;for k in pairs(rows) do
  if type(k)~='number' or k~=math.floor(k) or k<1 or k>size then return nil,'mask row index' end;n=n+1
 end
 if n~=size then return nil,'mask must be '..size..'x'..size end
 local rects,active={},{}
 for y=1,size do
  local row=rows[y]
  if type(row)~='string' or #row~=size or row:find('[^%.#]') then return nil,'mask pixels must be dot/hash' end
  local next_active={};local x=1
  while x<=size do
   if row:sub(x,x)=='#' then
    local first=x;repeat x=x+1 until x>size or row:sub(x,x)~='#'
    local key=first..':'..x;local r=active[key]
    if r then r[2]=size-y;r[4]=r[4]+1
    else
     if #rects>=160 then return nil,'icon layer too complex' end
     r={first-1,size-y,x-first,1};rects[#rects+1]=r
    end
    next_active[key]=r
   else x=x+1 end
  end
  active=next_active
 end
 local bounds=nil
 for _,r in ipairs(rects) do
  local x0,y0,x1,y1=r[1],r[2],r[1]+r[3],r[2]+r[4]
  if not bounds then bounds={x0,y0,x1,y1}
  else
   bounds[1]=math.min(bounds[1],x0);bounds[2]=math.min(bounds[2],y0)
   bounds[3]=math.max(bounds[3],x1);bounds[4]=math.max(bounds[4],y1)
  end
 end
 return rects,bounds
end
function FrvSlot3.register(spec)
 -- Validate plain data BEFORE accessing optional fields or constructing tokens.
 -- Id/version equality alone is not evidence that a different table is valid.
 if not plain(spec) or spec.api~=1 or type(spec.id)~='string' or #spec.id>64
  or not spec.id:match('^[%w_%.%-]+$') or not plain(spec.icons) or not plain(spec.weapon_names) then
  return false,'invalid Slot3 icon pack'
 end
 if registered[spec] and registered[spec]==FrvSlot3.pack then return true end
 local size=spec.size or 24
 if size~=24 and size~=64 then return false,'unsupported icon size' end
 local pack={id=spec.id,size=size,icons={},weapon_names={}};local count,total=0,0
 for name,icon in pairs(spec.icons) do
  count=count+1
  if count>64 or type(name)~='string' or #name>24 or not name:match('^[%w_]+$') or not plain(icon) then
   return false,'invalid/big icon dictionary'
  end
  local weapon,wb=compile_layer(icon.weapon,size);if not weapon then return false,wb end
  local support,sb=compile_layer(icon.support,size);if not support then return false,sb end
  if #weapon+#support>160 then return false,'icon too complex' end
  total=total+#weapon+#support
  if total>8192 then return false,'icon pack too complex' end
  -- Do not use ipairs({wb,sb}): when wb=nil the white-only layer is skipped.
  local b=wb and {wb[1],wb[2],wb[3],wb[4]} or nil
  if sb then
   if not b then b={sb[1],sb[2],sb[3],sb[4]} else
    b[1]=math.min(b[1],sb[1]);b[2]=math.min(b[2],sb[2]);b[3]=math.max(b[3],sb[3]);b[4]=math.max(b[4],sb[4])
   end
  end
  pack.icons[name]={weapon=weapon,support=support,bounds=b or {0,0,size,size}}
 end
 if count==0 then return false,'empty icon pack' end
 count=0
 for resource,name in pairs(spec.weapon_names) do
  count=count+1
  if count>128 or type(resource)~='string' or #resource~=16 or not resource:match('^[0-9a-f]+$')
   or type(name)~='string' then return false,'invalid resource dictionary' end
  if pack.icons[name] then pack.weapon_names[resource]=name end
 end
 if count==0 or next(pack.weapon_names)==nil then return false,'empty usable resource dictionary' end
 FrvSlot3.pack=pack;registered[spec]=pack;FrvSlot3.revision=FrvSlot3.revision+1
 FrvSlot3.visual_faults={}
 FRV.reset_slot3('register')
 log('FRV_SLOT3_ADDON registered='..pack.id..' api=1 optional_inventory=true size='..size)
 return true
end
function FRV.reset_slot3(reason)
 if next(FrvSlot3.rows)~=nil then FrvSlot3.revision=FrvSlot3.revision+1 end
 if next(FrvSlot3.rows)~=nil then FrvSlot3.rows={} end
 FrvSlot3.cursor=0
 if (reason=='context_reset' or reason=='register') and next(FrvSlot3.visual_faults) then FrvSlot3.visual_faults={} end
end
local function register_safely(spec)
 local ok,valid,why=pcall(FrvSlot3.register,spec)
 if not ok then return false,'icon pack registration error' end
 if valid and rawget(_G,SLOT3_PENDING)==spec then rawset(_G,SLOT3_PENDING,nil) end
 return valid,why
end
local function import_pending()
 local spec=rawget(_G,SLOT3_PENDING)
 if spec==nil then return end
 if plain(spec) and seen_pending[spec] then return end
 if plain(spec) then seen_pending[spec]=true end
 local ok,why=register_safely(spec)
 if not ok then
  log('FRV_SLOT3_ADDON rejected='..tostring(why)..' core_unaffected=true')
  if rawget(_G,SLOT3_PENDING)==spec then rawset(_G,SLOT3_PENDING,nil) end
 end
end
function FRV.install_extension_api()
 local api={api=1,version='1.6',capabilities={frv_seats=true,frv_slot3_icons=true,frv_slot3_mask_sizes={24,64}}}
 function api.register_frv_slot3_icons(spec)
  return register_safely(spec)
 end
 function api.unregister_frv_slot3_icons(id)
  if not FrvSlot3.pack or FrvSlot3.pack.id~=id then return false end
  FrvSlot3.pack=nil;FrvSlot3.visual_faults={};FrvSlot3.revision=FrvSlot3.revision+1;FRV.reset_slot3('unregister')
  return true
 end
 rawset(_G,'DriverHUD',api);import_pending()
 log('FRV_OCCUPANCY network_mask local_seat=true api=1')
end
function FRV.tick_slot3(session,avatar)
 if M.clock>=FrvSlot3.next_pending then FrvSlot3.next_pending=M.clock+.5;import_pending() end
 if not FrvSlot3.pack then return end -- Zero Inventory reads in the base HUD.
 if not FrvSeats.active(session,avatar) or FrvSeats.status~='VALID' or not FrvSeats.valid_at
  or M.clock-FrvSeats.valid_at>.100001 then FRV.reset_slot3('no_fresh_occupancy');return end
 -- Reconcile all four cells BEFORE any reading so an occupant leaving cannot
 -- carry a former occupant's weapon into an empty/new seat.
 for i=1,4 do
  local occupant=FrvSeats.slots[i]
  local eligible=occupant and (occupant.kind=='SELF' or occupant.kind=='OTHER') and occupant.avatar
  local key=eligible and FRV.seat_identity(occupant.avatar) or nil
  local old=FrvSlot3.rows[i]
  if not key then
   if old then FrvSlot3.rows[i]=nil;FrvSlot3.revision=FrvSlot3.revision+1 end
  elseif not old or old.key~=key then
   FrvSlot3.rows[i]={key=key,next_due=0};FrvSlot3.revision=FrvSlot3.revision+1
  elseif old.at and M.clock-old.at>.35 and old.resource then
   old.resource=nil;FrvSlot3.revision=FrvSlot3.revision+1
  end
 end
 -- At most ONE optional native sample in a frame. Each occupied cell is due
 -- every 250 ms. This scheduler does not gate the independent 50 ms seat tick.
 for step=1,4 do
  local i=(FrvSlot3.cursor+step-1)%4+1;local row=FrvSlot3.rows[i]
  if row and M.clock+1e-7>=row.next_due then
   FrvSlot3.cursor=i;row.next_due=M.clock+.25
   local sample,why=Native.frv_slot3(FRV.last_relation,FRV.vehicle,FrvSeats.slots[i].avatar,M.clock)
   if sample then
    if row.resource~=sample.resource then row.resource=sample.resource;FrvSlot3.revision=FrvSlot3.revision+1 end
    row.at=M.clock;row.error=nil
   else
    if row.resource then row.resource=nil;FrvSlot3.revision=FrvSlot3.revision+1 end
    if row.error~=why or M.clock>=(row.error_at or 0) then
     log('FRV_SLOT3_REJECT seat='..i..' reason='..tostring(why)..' isolated=true');row.error=why;row.error_at=M.clock+10
    end
   end
   break
  end
 end
end
function FrvSlot3.icon(i)
 local row=FrvSlot3.rows[i];local pack=FrvSlot3.pack
 if not row or not row.resource or not pack then return nil end
 local name=pack.weapon_names[row.resource]
 return name and pack.icons[name] or nil
end

-- 1.4.4: staged reload and retained telemetry. Raw ammo values; no ammo prediction.
-- No type brute force, world scan, GOID adjacency binding or ammo prediction.
Tank={active=nil,history={},history_serial=0,MAX_HISTORY=8,KEEP_PROGRESS=120,STALE_AFTER=3,RELOAD_STALE_AFTER=1}
Tank.NEW_RESOURCE='b0c9faf4af8903f9'
local function tank_copy(t) local o={};for k,v in pairs(t or {}) do o[k]=v end;return o end
function Tank.context_key()
 local d=FRV.last_relation and FRV.last_relation.vehicle
 return table.concat({tostring(M.session),tostring(M.peer),tostring(M.world),tostring(M.avatar),
  tostring(M.hull),d and tostring(d.entity) or '?',d and d.resource or 'legacy',d and tostring(d.unit) or '?'},':')
end
function Tank.is_new()
 local d=FRV.last_relation and FRV.last_relation.vehicle
 return FRV.mode=='TANK' and d and d.goid==M.hull and d.resource==Tank.NEW_RESOURCE
end
-- Observed stage durations/checkpoints, used only to animate the indicator.
Tank.stages={old={{4,1.256},{5,1.249},{7,.566},{4,.929}},new={{4,.06},{5,2.50},{7,1.43}}}
function Tank.new_reload(kind)
 return {kind=kind,phase='idle',elapsed=0,stage_elapsed=0,tick_at=M.clock,checkpoints={}}
end
local function tank_stage_start(r,stage)
 local t=0;for i=1,stage-1 do t=t+Tank.stages[r.kind][i][2] end;return t
end
function Tank.advance(r,now)
 local dt=math.max(0,now-(r.tick_at or now));r.tick_at=now
 if r.phase=='running' and r.stage then
  local duration=Tank.stages[r.kind][r.stage][2]
  r.stage_elapsed=math.min(duration*.985,(r.stage_elapsed or 0)+dt)
  r.elapsed=tank_stage_start(r,r.stage)+r.stage_elapsed
 end
end
function Tank.feed_reload(r,v,now)
 if r.last_sample and now-r.last_sample>.3 then r.stage_observed=false end
 Tank.advance(r,now)
 local prior_current,prior_reserve=r.current,r.reserve
 if v.current~=nil then r.current=v.current end
 if v.reserve~=nil then r.reserve=v.reserve end
 local committed=(prior_reserve~=nil and r.reserve~=nil and r.reserve<prior_reserve and (r.current or 0)>0)
 if r.kind=='old' and prior_current==0 and r.current==1 and r.phase~='idle' then committed=true end
 if committed then
  r.committed=true
  if r.kind=='old' then
   r.stage=4;r.stage_elapsed=0;r.elapsed=tank_stage_start(r,4);r.phase='running';r.known_start=true
  elseif v.state==nil or v.state==0 then
   r.phase='idle';r.elapsed=0;r.stage=nil;r.checkpoints={}
  end
 end
 local state=v.state
 if state==nil then return end
 local previous=r.state;r.state=state;r.last_seen=now
 if state==0 then
  r.last_sample=now;r.stage_observed=false
  -- Old initial-stage interruptions also return 0 while the chamber is empty.
  if r.kind=='old' and r.phase~='idle' and r.current==0 then
   r.phase='paused';r.restart_initial=true
  else r.phase='idle';r.stage=nil;r.elapsed=0;r.checkpoints={};r.committed=false end
  return
 end
 local paused=state==1 or state==3
 local stage=(state==5 or state==1) and 2 or ((state==7 or state==3) and 3 or nil)
 if state==4 then stage=(r.kind=='old' and (r.current==1 or r.committed)) and 4 or 1 end
 if not stage then r.phase='paused';return end
 if paused then
  if r.stage~=stage or r.phase=='idle' then
   r.stage=stage;r.stage_elapsed=0;r.elapsed=tank_stage_start(r,stage);r.known_start=false
  end
  -- Infer checkpoint ONLY from a locally observed stage start and recent samples.
  local cp=r.kind=='new' and (stage==2 and 1.15 or .30) or nil
  if cp and r.stage_observed and r.last_sample and now-r.last_sample<=.3 and r.stage_elapsed>=cp+.1 then r.checkpoints[stage]=cp end
  r.phase='paused';r.last_sample=now;return
 end
 if r.stage~=stage or r.phase=='idle' or r.restart_initial then
  r.stage_elapsed=0;r.stage_observed=(previous~=nil and previous~=state and r.last_sample~=nil and now-r.last_sample<=.3)
  r.known_start=r.stage_observed or (r.kind=='old' and committed) or false
 elseif r.phase=='paused' then
  r.stage_elapsed=r.checkpoints[stage] or 0;r.stage_observed=true;r.known_start=true
 end
 r.restart_initial=nil;r.stage=stage;r.phase='running'
 r.elapsed=tank_stage_start(r,stage)+r.stage_elapsed;r.last_sample=now;r.needs_reconcile=nil
end
function Tank.detach()
 local a=Tank.active;if not a then return end
 Tank.advance(a.reload,M.clock)
 if a.reload.phase~='idle' then
  local r=tank_copy(a.reload)
  r.stage_observed=false -- Detached history cannot establish an unobserved checkpoint.
  r.phase='paused';r.tick_at=M.clock;r.needs_reconcile=true
  Tank.history_serial=Tank.history_serial+1
  Tank.history[a.key]={reload=r,at=M.clock,serial=Tank.history_serial,ref_key=a.ref_key}
  local count,oldkey,serial=0,nil,math.huge
  for k,v in pairs(Tank.history) do count=count+1;if v.serial<serial then oldkey,serial=k,v.serial end end
  if count>Tank.MAX_HISTORY then Tank.history[oldkey]=nil end
 end
 Tank.active=nil
end
function Tank.ensure(kind)
 local key=Tank.context_key()
 if Tank.active and (Tank.active.key~=key or Tank.active.kind~=kind) then Tank.detach() end
 if not Tank.active then
  local r=Tank.new_reload(kind);local saved=Tank.history[key]
  if saved and M.clock-saved.at<=Tank.KEEP_PROGRESS then
   r=tank_copy(saved.reload);r.phase='paused';r.tick_at=M.clock;r.last_seen=nil
  end
  Tank.history[key]=nil
  Tank.active={key=key,kind=kind,reload=r,refs={},ref_key='',children={},next_hull=0,next_weapon=M.clock+.04,
   next_gatling=M.clock+.04,next_rack_a=M.clock+.04,next_rack_b=M.clock+.04,
   cursor=1,phase=0,next_old=0,next_log=M.clock+5,diag={},saved_ref_key=saved and saved.ref_key}
  log('TANK_VARIANT hull='..tostring(M.hull)..' variant='..kind..' telemetry=cache_candidate_plus_bounded_batch')
 end
 local a=Tank.active;local role=M.lua51_role or (FRV.last_relation and FRV.last_relation.role)
 if a.last_role==1 and role~=nil and role~=1 and a.reload.phase~='idle' then
  Tank.advance(a.reload,M.clock);a.reload.phase='paused'
 end
 a.last_role=role
 return a
end
function Tank.shape(f)
 if type(f)~='table' then return nil end
 local n=dense_count(f)
 -- Incomplete telemetry is not proof of a changed object type.
 local required=n==28 and {1,2,3,4,12,13,14,19,21} or (n==33 and {1,2,11,13,14,15,24,32})
 if required then for _,i in ipairs(required) do if f[i]==nil then return nil end end end
 if n==28 and f[1]==1 and f[2]==64 and (f[3]==50 or f[3]==52) and type(f[4])=='boolean'
  and f[12]==1 and f[13]==35 and f[14]==25 and f[19]==2 and f[21]==10 then return 'gatling' end
 if n==33 and type(f[1])=='number' and f[1]>=0 and f[1]<=1.01 and type(f[2])=='number'
  and f[2]>=0 and f[2]<=1.01 and f[11]==16 and f[13]==2 and f[14]==64 and (f[15]==50 or f[15]==52)
  and f[24]==10 and f[32]==2 then return 'rack' end
 return 'other'
end
function Tank.decode(kind,f)
 if type(f)~='table' then return nil end
 if kind=='gatling' then
  if not integer(f[6],6) or not integer(f[7],300) then return nil end
  return {reserve=f[6],current=f[7],state=integer(f[28],7) and f[28] or nil}
 elseif kind=='rack' then if integer(f[18],10) then return {ammo=f[18]} end
 elseif kind=='old' then
  if integer(f[5],30) and integer(f[6],1) then
   return {reserve=f[5],current=f[6],state=integer(f[14],7) and f[14] or nil}
  end
 end
end
function Tank.set_refs(a,hf)
 local refs=type(hf)=='table' and hf[56]
 if refs==nil then return nil end -- unavailable is not an explicitly changed reference set
 if type(refs)~='table' then return false end
 local ids,seen={},{}
 for k,id in pairs(refs) do
  if not integer(k,16) or k<1 or not integer(id,32766) or id==0 or id==M.hull or seen[id] then return false end
  seen[id]=true;ids[#ids+1]=id
 end
 -- The captured variant has exactly five explicitly referenced children.
 if #ids~=5 then return false end
 a.refs_at=M.clock
 table.sort(ids);local key=table.concat(ids,',')
 if key~=a.ref_key then
  local changed=a.ref_key~='' or (a.saved_ref_key and a.saved_ref_key~=key)
  a.refs=ids;a.ref_key=key;a.children={};a.gatling=nil;a.racks={};a.cursor=1;a.ambiguous=false
  a.observed={};a.rocket_ref_key=nil;a.rack_unknown_since=nil
  -- A changed weapon set is NOT a continuation of the previous reload.
  if changed then a.reload=Tank.new_reload('new') end
  log('TANK_CHILDREN hull='..M.hull..' refs='..key)
 end
 return true
end
function Tank.bind_shape(a,id,shape)
 if shape~='gatling' and shape~='rack' then return false end
 local c=a.children[id]
 if c and c.shape~=shape then
  a.children[id]=nil;if a.gatling==id then a.gatling=nil;a.reload=Tank.new_reload('new') end
  local keep={};for _,v in ipairs(a.racks or {})do if v~=id then keep[#keep+1]=v end end;a.racks=keep;c=nil
 end
 if not c then c={shape=shape};a.children[id]=c end
 if shape=='gatling' then
  if a.gatling and a.gatling~=id then a.ambiguous=true;return false end;a.gatling=id
 else
  local found=false;for _,v in ipairs(a.racks or {})do if v==id then found=true end end
  if not found then a.racks=a.racks or {};a.racks[#a.racks+1]=id;table.sort(a.racks)end
  if #a.racks>2 then a.ambiguous=true;return false end
 end
 return true
end
function Tank.accept(a,id,f,now)
 local shape=Tank.shape(f)
 if not Tank.bind_shape(a,id,shape) then return end
 local c=a.children[id];local value=Tank.decode(shape,f)
 if value then c.value=value;c.at=now;if shape=='gatling' then Tank.feed_reload(a.reload,value,now) end end
end
local function tank_diag_hit(a,name,ok,value)
 local d=a.diag[name] or {attempts=0,valid=0,gaps=0};a.diag[name]=d
 d.attempts=d.attempts+1
 if ok then d.valid=d.valid+1;d.last=value;d.last_at=M.clock else d.gaps=d.gaps+1 end
end
local function tank_diag_state(a,name,state)
 local k='state_'..name
 if a[k]~=state then
  log('TANK_TELEM_STATE channel='..name..' hull='..tostring(M.hull)..' role='..tostring(a.last_role)..' old='..tostring(a[k])..' new='..tostring(state))
  a[k]=state
 end
end
local function tank_diag_log(a)
 if M.clock<(a.next_log or 0) then return end
 a.next_log=M.clock+5
 local function part(name)
  local d=a.diag[name] or {attempts=0,valid=0,gaps=0}
  local age=d.last_at and string.format('%.2f',M.clock-d.last_at) or 'nil'
  local out=name..'='..d.valid..'/'..d.attempts..' gaps='..d.gaps..' changes='..(d.changes or 0)..' age='..age..' last='..tostring(d.last)
  d.attempts,d.valid,d.gaps,d.changes=0,0,0,0
  return out
 end
 if a.kind=='new' then
  log('TANK_NEW_READ hull='..tostring(M.hull)..' role='..tostring(a.last_role)..' '..part('gatling')..' '..part('rack_a')..' '..part('rack_b'))
 else
  log('TANK_OLD_RELOAD_READ hull='..tostring(M.hull)..' role='..tostring(a.last_role)..' '..part('old_reload'))
 end
end
function Tank.refresh_new(session)
 local a=Tank.ensure('new');local now=M.clock;local hid=M.hull
 if call(GS.game_object_exists,session,hid)==false then Tank.detach();FRV.drop_tank();return end
 local c=cache_for(hid)
 if now>=a.next_hull then
  a.next_hull=now+.2
  local hf=sample(session,hid)
  if FRV.hull_values(hf,hid) then
   c.hp,c.max,c.hull_valid_at=hf[30],hf[15],now
   Tank.set_refs(a,hf) -- Malformed/partial children are gaps; valid replacements reset channels.
  end
 end

 if #a.refs>0 then
  -- Each identified weapon advances independently. An unreadable rack cannot
  -- prevent Gatling or the other rack from being sampled.
  if a.gatling and now>=a.next_gatling then
   Tank.sample_child(session,a,a.gatling,'gatling',now)
   local c=a.children[a.gatling];a.next_gatling=now+.1
  end
  if a.racks and a.racks[1] and now>=a.next_rack_a then a.next_rack_a=now+.2;Tank.sample_child(session,a,a.racks[1],'rack_a',now) end
  if a.racks and a.racks[2] and now>=a.next_rack_b then a.next_rack_b=now+.2;Tank.sample_child(session,a,a.racks[2],'rack_b',now) end
  if now>=a.next_weapon then
   a.next_weapon=now+.1
   local id=a.refs[a.cursor];a.cursor=a.cursor%#a.refs+1
   local c=id and a.children[id]
   if id and not (c and (c.shape=='gatling' or c.shape=='rack')) then Tank.discover_child(session,a,id,now) end
  end
 end
 tank_diag_log(a)
 Tank.advance(a.reload,now)
 M.hp,M.max=c.hp,c.max
 -- Never pass new rack objects into the old main/coax readers.
 M.ammo=nil;M.mg=nil
end
function Tank.refresh_old(session)
 if not M.hull then Tank.detach();return end
 local a=Tank.ensure('old');local c=M.cache[M.hull];if not c then return end
 local id=c.main_id
 if a.old_id and a.old_id~=id then a.reload=Tank.new_reload('old');a.old_schema=nil end
 a.old_id=id
 if M.clock>=a.next_old then
  a.next_old=M.clock+.1
  local v,source
  if valid_goid(session,id) and call(GS.game_object_is_type,session,id,MAIN_BIND_TYPE)==true then
   if not a.old_schema and M.clock>=(a.schema_retry or 0) then
    a.schema_retry=M.clock+5
    local info=call(Net.object_info,MAIN_BIND_TYPE);local fs=type(info)=='table' and info.fields
    a.old_schema=type(fs)=='table' and #fs==27 and hash_of_field(fs[14])=='cd889dbc'
     and hash_of_field(fs[5])=='ec64918b' and hash_of_field(fs[6])=='d7a5d63e' or nil
   end
   if a.old_schema then
    local state=call(GS.game_object_field,session,id,'L8h7VinJ')
    if integer(state,7) then v={current=c.main_current,reserve=c.main_reserve,state=state};source='targeted' end
   end
   if not v then v=Tank.decode('old',sample(session,id));source='batch' end
   tank_diag_hit(a,'old_reload',v~=nil,v and ('state='..tostring(v.state)..',source='..source))
   if v then tank_diag_state(a,'old_reload',v.state);Tank.feed_reload(a.reload,v,M.clock) end
  else tank_diag_hit(a,'old_reload',false,'invalid') end
 end
 tank_diag_log(a);Tank.advance(a.reload,M.clock)
end
-- The old ammo path remains intact. Only the stale-display policy changes in build.py.
local tank_legacy_refresh=refresh_bound
refresh_bound=function(session,owned_set)
 if Tank.is_new() then Tank.refresh_new(session)
 else tank_legacy_refresh(session,owned_set);Tank.refresh_old(session) end
end

-- Bounded cache evaluation tied to the already bound child. Paired observations
-- choose a channel; a later disagreement revokes it without hiding the HUD.
function Tank.cache_candidates(kind,n)
 local out={};local m=n and n.magazine;local r=n and n.rounds
 if kind=='gatling' then
  if m and integer(m.reserve,6) and integer(m.current,300) then out.magazine={reserve=m.reserve,current=m.current} end
 else
  if m then
   if integer(m.current,10) then out.magazine_current={ammo=m.current} end
   if integer(m.reserve,10) then out.magazine_reserve={ammo=m.reserve} end
  end
  if r then
   if integer(r.reserve,10) then out.rounds_reserve={ammo=r.reserve} end
   if integer(r.rounds_0,10) then out.rounds_0={ammo=r.rounds_0} end
   if integer(r.rounds_1,10) then out.rounds_1={ammo=r.rounds_1} end
  end
 end
 return out
end
local function equivalent(a,b,kind)
 return a and b and (kind=='gatling' and a.current==b.current and a.reserve==b.reserve or kind=='rack' and a.ammo==b.ammo)
end
function Tank.cache_pair(c,kind,n,v)
 if c.cache_rejected or not v or (kind=='gatling' and (not integer(v.current,300) or not integer(v.reserve,6)))
  or (kind=='rack' and not integer(v.ammo,10)) then return end
 local choices=Tank.cache_candidates(kind,n)
 if c.cache_model and not equivalent(choices[c.cache_model],v,kind) then
  -- Independently updated stores can disagree while firing. Stop using the
  -- native mapping for now, then require TWO fresh matching pairs to rebind.
  -- A value mismatch alone cannot permanently blacklist a valid identity.
  log('TANK_CACHE_REVALIDATE reason=batch_disagreement model='..c.cache_model)
  c.cache_model=nil;c.cache_live=false;c.cache_choices=nil;c.cache_pairs=0
  c.state_cache_ok=false;c.state_pairs=0;return
 end
 local remaining={};local count,name=0,nil
 for k,x in pairs(choices) do
  if equivalent(x,v,kind) and (not c.cache_choices or c.cache_choices[k]) then remaining[k]=true;count=count+1;name=k end
 end
 if count==0 and not c.cache_model then
  c.cache_choices=nil;c.cache_pairs=0;return
 end
 c.cache_choices=remaining;c.cache_pairs=(c.cache_pairs or 0)+1
 if count==1 and c.cache_pairs>=2 and not c.cache_model then c.cache_model=name;log('TANK_CACHE_BOUND model='..name..' paired='..c.cache_pairs) end
 if kind=='gatling' and v.state~=nil and n.state~=nil then
  -- These are separate reads of independently updated stores. Once the field
  -- mapping is validated, a transition mismatch cannot invalidate that mapping.
  -- The native reader still validates owner identity, component and state range.
  if n.state~=v.state then
   c.state_pairs=0
   if not c.state_disagreement then log('TANK_RELOAD_PAIR_GAP native='..n.state..' batch='..v.state..' validated='..tostring(c.state_cache_ok==true)) end
   c.state_disagreement=true
  else
   c.state_disagreement=nil;c.state_pairs=(c.state_pairs or 0)+1
   if c.state_pairs>=2 then c.state_cache_ok=true end
  end
 end
end
function Tank.sample_child(session,a,id,name,now)
 if not id then return end
 local c=a.children[id];if not c then return end
 local exists=call(GS.game_object_exists,session,id)
 if exists==false then
  a.children[id]=nil;if a.gatling==id then a.gatling=nil;a.reload=Tank.new_reload('new') end
  local racks={};for _,v in ipairs(a.racks or {}) do if v~=id then racks[#racks+1]=v end end;a.racks=racks
  log('TANK_CHANNEL_LOST channel='..name..' goid='..id);return
 end
 -- An unavailable Lua exists() result does not block an independently validated native read.
 if C.weapon_cache==false then c.cache_live=false end
 local n,why,native_attempt
 if C.weapon_cache~=false and (not c.cache_rejected or C.debug) and now>=(c.next_cache or 0) then
  native_attempt=true;c.next_cache=now+(c.cache_rejected and 1 or .1)
  n,why=Native.weapon(id,c.native_descriptor)
  if n then c.native_descriptor=n.descriptor end
  c.cache_live=not c.cache_rejected and n~=nil and c.cache_model~=nil and Tank.cache_candidates(c.shape,n)[c.cache_model]~=nil
  if why and (c.cache_error~=why or now>=(c.cache_log_at or 0)) then
   log('TANK_CACHE_GAP channel='..name..' reason='..tostring(why));c.cache_error=why;c.cache_log_at=now+10
  end
 end
 -- A fallback remains tied to its original descriptor. Contradictory data
 -- cannot be hidden by the last-good display policy.
 if c.gatling_fallback and (C.weapon_cache==false or exists==false
  or why=='weapon identity changed' or (n and not Tank.gatling_native(a,id,n,true))) then
  Tank.clear_gatling_fallback(a,id,'native_contract_changed');return
 end
 local v,source,f,reason,batch_attempt
 if C.weapon_cache==false or not c.cache_live or now>=(c.next_compare or 0) then
  c.next_compare=now+1
  batch_attempt=true;f,reason=sample(session,id)
  if c.gatling_fallback then
   local shape_ok=Tank.gatling_batch_status(f)
   if shape_ok==false then
    Tank.clear_gatling_fallback(a,id,'batch_structure_changed');return
   end
   local decoded=shape_ok and Tank.decode('gatling',f) or nil
   if shape_ok and not decoded then
    Tank.clear_gatling_fallback(a,id,'batch_ammo_bounds');return
   end
   -- Paired streams may differ during firing/reload. Once the exact mapping
   -- was confirmed twice, use only this tick's identity-validated native value.
   v=nil
  else v=Tank.shape(f)==c.shape and Tank.decode(c.shape,f) or nil end
  if v then
   -- Select one source before feeding the reload machine. Feeding the batch
   -- here could reset an active native reload with a delayed idle value.
   source='batch'
   if n then Tank.cache_pair(c,c.shape,n,v);Tank.learn_profile(c,n) end
  end
 end
 if n and c.cache_model and not c.cache_rejected then
  local x=Tank.cache_candidates(c.shape,n)[c.cache_model]
  if x then
   local batch_state=v and v.state
   v=x;source='component_cache';c.cache_live=true
   if c.shape=='gatling' then
    local p=Tank.profile_for(n)
    if p and p.shape==c.shape and p.model==c.cache_model and p.state_ok then c.state_cache_ok=true end
    if c.state_cache_ok and n.state~=nil then v.state=n.state
    else v.state=batch_state end
   end
  end
 end
 Tank.observe(a,id,exists,f,reason,n,why,batch_attempt,native_attempt)
 local d=a.diag[name] or {attempts=0,valid=0,gaps=0};a.diag[name]=d
 d.attempts=d.attempts+1
 if v then
  local value_key=v.ammo and tostring(v.ammo) or (tostring(v.current)..'/'..tostring(v.reserve))
  if d.value_key and d.value_key~=value_key then d.changes=(d.changes or 0)+1 end;d.value_key=value_key
  d.valid=d.valid+1;d.last_at=now;d.last=source..':'..(v.ammo and ('ammo='..v.ammo) or ('cur='..v.current..',res='..v.reserve..',state='..tostring(v.state)))
  c.value=v;c.at=now
  if c.shape=='gatling' then
   Tank.feed_reload(a.reload,v,now)
   if v.state~=nil and a.last_reload_log~=v.state then
    log('TANK_TELEM_STATE channel=gatling role='..tostring(a.last_role)..' new='..v.state..' source='..source);a.last_reload_log=v.state
   end
  end
 else d.gaps=d.gaps+1 end
end

-- Cold-discovery observations are independent of successful batch classification.
-- Exactly the five Hull references; no ownership edits, scans, RPCs or game writes.
Tank.resource_profiles={}
local function profiles()
 if Tank.profile_session~=M.session then Tank.profile_session=M.session;Tank.resource_profiles={} end
 return Tank.resource_profiles
end
local function resource(n)
 local r=n and n.descriptor and n.descriptor.resource
 return type(r)=='string' and #r==16 and r:match('^%x+$') and r or nil
end
function Tank.profile_for(n)
 local p=profiles()[resource(n) or ''];return p and not p.conflict and p or nil
end
function Tank.learn_profile(c,n)
 local r=resource(n);if not r or not c.cache_model or c.cache_rejected or c.gatling_fallback then return end
 local all=profiles();local p=all[r]
 if p and (p.shape~=c.shape or p.model~=c.cache_model) then
  p.conflict=true;return
 end
 if p and c.state_cache_ok then p.state_ok=true end
 if not p then
  local count=0;for _ in pairs(all)do count=count+1 end;if count>=16 then return end
  all[r]={shape=c.shape,model=c.cache_model,state_ok=c.state_cache_ok==true};log('TANK_RESOURCE_LEARNED resource='..r..' shape='..c.shape..' model='..c.cache_model)
 end
end
-- Narrow cold-start fallback for the two verified rocket pods. Evidence is
-- local to the current hull/reference set and never teaches a session profile.
local ROCKET_RESOURCE='8aff7f0793a5bced'
local function rocket_sample(a,q,id,exists,n,now)
 if a.kind~='new' then return end
 if a.rocket_ref_key~=a.ref_key then a.rocket_ref_key=a.ref_key;a.rack_unknown_since=now end
 if not a.rack_unknown_since then a.rack_unknown_since=now end
 local m=n and n.magazine;local d=n and n.descriptor
 if C.weapon_cache==false or exists==false or resource(n)~=ROCKET_RESOURCE
  or not m or not integer(m.current,10) or not d or d.goid~=id then q.rocket_evidence=nil;return end
 local old=q.rocket_evidence;local same=old and old.ref_key==a.ref_key and now-old.at<=1.2
  and old.descriptor.entity==d.entity and old.descriptor.unit==d.unit
  and old.descriptor.goid==d.goid and old.descriptor.resource==d.resource
 q.rocket_evidence={descriptor=d,current=m.current,at=now,ref_key=a.ref_key,
  samples=same and old.samples+1 or 1,
  decreased=same and (old.decreased or m.current<old.current) or false}
end
function Tank.try_rocket_fallback(a,now)
 if C.weapon_cache==false or a.kind~='new' or not Tank.is_new() or a.ambiguous or #a.refs~=5 then return end
 local complete=#(a.racks or {})==2
 if complete then
  for _,id in ipairs(a.racks)do local c=a.children[id];complete=complete and c and c.value and c.value.ammo~=nil end
 end
 if complete then a.rack_unknown_since=nil;return end
 a.rack_unknown_since=a.rack_unknown_since or now
 local candidates={};local decreased=false
 for _,id in ipairs(a.refs)do
  local q=a.observed and a.observed[id]
  if q and resource(q.native)==ROCKET_RESOURCE then
   local e=q.rocket_evidence;local c=a.children[id]
   if not e or e.ref_key~=a.ref_key or e.samples<2 or now-e.at>1.2 or q.exists==false
    or (c and (c.shape~='rack' or c.cache_rejected)) then return end
   candidates[#candidates+1]={id=id,e=e};decreased=decreased or e.decreased
  end
 end
 if #candidates~=2 or (not decreased and now-a.rack_unknown_since<2) then return end
 local allowed={};for _,v in ipairs(candidates)do allowed[v.id]=true end
 for _,id in ipairs(a.racks or {})do if not allowed[id] then return end end
 for _,v in ipairs(candidates)do
  local c=a.children[v.id]
  -- A healthy channel keeps its existing calibration and sampling schedule.
  if not c or not c.value or c.value.ammo==nil then
   if not Tank.bind_shape(a,v.id,'rack') then return end
   c=a.children[v.id];c.native_descriptor=v.e.descriptor;c.cache_model='magazine_current'
   c.value={ammo=v.e.current};c.at=v.e.at;c.cache_live=true
   log('TANK_ROCKET_FALLBACK hull='..M.hull..' id='..v.id..' reason='..(decreased and 'observed_decrease' or 'unknown_timeout'))
  end
 end
end
local function scalar(x)
 if x==nil then return 'nil' end
 if type(x)=='number' or type(x)=='boolean' then return tostring(x) end
 if type(x)=='table' then return 'table' end
 if type(x)=='string' then return 'str:'..x:gsub('[%s=,;]','_'):sub(1,32) end
 return type(x)
end
local function batch_key(f)
 if type(f)~='table' then return 'nil' end
 local out={};for i=1,33 do out[#out+1]=i..':'..scalar(f[i]) end;return table.concat(out,',')
end
local function native_ammo(n)
 if not n or (not n.magazine and not n.rounds) then return 'nil' end
 local m,r=n.magazine or {},n.rounds or {}
 return table.concat({scalar(m.reserve),scalar(m.current),scalar(r.reserve),scalar(r.rounds_0),scalar(r.rounds_1)},'/')
end
local function batch_ammo(f,shape)
 local v=Tank.decode(shape,f);if not v then return 'nil' end
 return v.ammo and ('rack:'..v.ammo) or (tostring(v.reserve)..'/'..tostring(v.current))
end
function Tank.observe(a,id,exists,f,reason,n,why,batch_attempt,native_attempt)
 a.observed=a.observed or {};local q=a.observed[id] or {};a.observed[id]=q;local now=M.clock
 q.exists=exists;q.role=a.last_role
 if batch_attempt then
  q.batch_attempts=(q.batch_attempts or 0)+1;q.batch_at=now;q.batch_count=dense_count(f);q.batch=nil
  if type(f)=='table' then q.batch_success_at=now;q.batch={};for i=1,33 do q.batch[i]=f[i] end end;q.batch_reason=reason
  q.batch_shape=Tank.shape(f);local key=batch_ammo(f,q.batch_shape)
  if key~='nil' then
   if q.batch_value and q.batch_value~=key then q.batch_change_at=now;q.batch_changes=(q.batch_changes or 0)+1 end
   q.batch_value=key
  end
 end
 if native_attempt then
  rocket_sample(a,q,id,exists,n,now)
  q.native_attempts=(q.native_attempts or 0)+1;q.native_at=now;q.native=n;q.native_reason=why
  if n then q.native_success_at=now end
  local key=native_ammo(n)
  if key~='nil' then
   if q.native_value and q.native_value~=key then q.native_change_at=now;q.native_changes=(q.native_changes or 0)+1 end
   q.native_value=key
  end
 end
 if not C.debug or now<(q.next_log or 0) then return end;q.next_log=now+1
 local d=q.native and q.native.descriptor or {};local m=q.native and q.native.magazine or {};local r=q.native and q.native.rounds or {}
 local c=a.children[id] or {};local bind=(a.gatling and 'gatling' or '-')..'/'..#(a.racks or {})
 local function age(at)return at and string.format('%.2f',now-at) or 'never' end
 local fingerprint=table.concat({scalar(q.exists),scalar(q.role),scalar(q.batch_shape),scalar(q.batch_reason),batch_key(q.batch),
  native_ammo(q.native),scalar(q.native and q.native.state),scalar(d.flags),scalar(q.native_reason),scalar(c.cache_model),scalar(c.shape)},'|')
 if q.last_log==fingerprint and now<(q.heartbeat or 0) then return end
 q.last_log=fingerprint;q.heartbeat=now+5
 local utc=call(os.date,'!%Y-%m-%dT%H:%M:%SZ') or 'unavailable'
 log('TANK_OBSERVE utc='..utc..' t='..string.format('%.3f',now)..' avatar='..tostring(M.avatar)..' hull='..tostring(M.hull)..' role='..tostring(a.last_role)..' id='..id..
  ' bind='..bind..' exists='..scalar(q.exists)..' batch='..scalar(q.batch_reason)..' count='..scalar(q.batch_count)..' shape='..scalar(q.batch_shape)..
  ' batch_attempts='..(q.batch_attempts or 0)..' batch_attempt_age='..age(q.batch_at)..' batch_read_age='..age(q.batch_success_at)..' batch_change_age='..age(q.batch_change_at)..' batch_changes='..(q.batch_changes or 0)..
  ' native='..(q.native and 'ok' or scalar(q.native_reason))..' native_attempts='..(q.native_attempts or 0)..' native_attempt_age='..age(q.native_at)..' native_read_age='..age(q.native_success_at)..
  ' native_change_age='..age(q.native_change_at)..' native_changes='..(q.native_changes or 0)..' resource='..scalar(d.resource)..' entity='..scalar(d.entity)..
  ' unit='..scalar(d.unit)..' flags='..scalar(d.flags)..' magazine='..scalar(m.reserve)..'/'..scalar(m.current)..' rounds='..scalar(r.reserve)..'/'..scalar(r.rounds_0)..'/'..scalar(r.rounds_1)..
  ' state='..scalar(q.native and q.native.state)..' model='..scalar(c.cache_model)..' current_shape='..scalar(c.shape)..' fields='..batch_key(q.batch))
end
function Tank.sync_uncertain(a,id)
 if not a then return false end
 local c=a.children[id];if c and c.cache_rejected then return true end
 if a.last_role==1 then return false end
 local q=a.observed and a.observed[id]
 local changed=q and math.max(q.native_change_at or -1e9,q.batch_change_at or -1e9) or -1e9
 return M.clock-changed>3 -- No recent change is uncertainty, not proof of stale data.
end
function Tank.discover_child(session,a,id,now)
 a.observed=a.observed or {};local q=a.observed[id] or {};a.observed[id]=q
 if now<(q.next_discovery or 0) then return end
 local exists=call(GS.game_object_exists,session,id)
 local f,reason=sample(session,id);local shape=Tank.shape(f)
 -- Read native even when Lua reports absent/nil or batch classification fails.
 -- Contradictory exists=false is logged, never used to bind a HUD channel.
 local n,why,native_attempt
 if C.weapon_cache~=false then n,why=Native.weapon(id);native_attempt=true
 else q.native=nil;q.native_reason='disabled' end
 Tank.observe(a,id,exists,f,reason,n,why,true,native_attempt)
 local count=dense_count(f)
 q.next_discovery=now+((shape=='other' and count~=28 and count~=33) and 5 or .45)
 if exists==false then return end
 if shape=='gatling' or shape=='rack' then
  Tank.accept(a,id,f,now)
  local c=a.children[id]
  if c and n then
   c.native_descriptor=n.descriptor;Tank.cache_pair(c,c.shape,n,Tank.decode(c.shape,f) or {})
   Tank.learn_profile(c,n)
  end
 else
  if Tank.try_gatling_fallback(a,id,exists,f,n,now) then return end
  local p=Tank.profile_for(n)
  if p and Tank.cache_candidates(p.shape,n)[p.model] and Tank.bind_shape(a,id,p.shape) then
   local c=a.children[id];c.native_descriptor=n.descriptor;c.cache_model=p.model;c.state_cache_ok=p.state_ok
   -- Mapping evidence is reusable. Ammo/reload state is always read afresh.
   local v=Tank.cache_candidates(c.shape,n)[c.cache_model]
   if v then c.value=v;c.at=now;c.cache_live=true end
   log('TANK_NATIVE_DISCOVERY hull='..M.hull..' id='..id..' resource='..n.descriptor.resource..' shape='..c.shape..' source=session_resource_profile')
  end
 end
 Tank.try_rocket_fallback(a,now)
end

-- Exact-resource cold-start recovery for fingerprint drift in fields 13/14.
-- No new lookups or scans: consume only the same tick's existing batch/native
-- samples of one of the five explicitly referenced children of a Storm hull.
Tank.GATLING_RESOURCE='d58ae6a04edb10de'
local function descriptor_copy(d)
 return {goid=d.goid,entity=d.entity,unit=d.unit,resource=d.resource,flags=d.flags}
end
function Tank.gatling_batch_shape(f)
 if type(f)~='table' or dense_count(f)~=28 then return false end
 local function finite(x)return type(x)=='number' and x==x and x>-math.huge and x<math.huge end
 return f[1]==1 and f[2]==64 and (f[3]==50 or f[3]==52) and type(f[4])=='boolean'
  and f[12]==1 and finite(f[13]) and finite(f[14]) and type(f[18])=='string'
  and f[19]==2 and f[21]==10 and type(f[8])=='boolean'
  and type(f[10])=='boolean' and type(f[11])=='boolean'
  and type(f[23])=='boolean' and type(f[27])=='boolean' and integer(f[28],7)
end
function Tank.gatling_batch_status(f)
 if type(f)~='table' then return nil end
 local count=dense_count(f)
 if count and count>28 then return false end
 -- A partial replicated batch is a gap, not positive proof of a new layout.
 -- Cold start still demands the complete validated shape and paired values.
 for i=1,28 do if f[i]==nil then return nil end end
 return Tank.gatling_batch_shape(f) and true or false
end
function Tank.gatling_native(a,id,n,allow_missing)
 if C.weapon_cache==false or a.kind~='new' or not Tank.is_new() or a.ambiguous or #a.refs~=5 then return false end
 local found=false;for _,ref in ipairs(a.refs)do if ref==id then found=true end end
 local d=n and n.descriptor;local m=n and n.magazine
 return found and d and d.goid==id and d.resource==Tank.GATLING_RESOURCE
  and integer(d.entity,4294967294) and integer(d.unit,4294967294)
  and ((allow_missing and m==nil) or (m and integer(m.reserve,6) and integer(m.current,300)))
  and ((allow_missing and n.state==nil) or integer(n.state,7))
end
function Tank.clear_gatling_fallback(a,id,reason)
 local c=a.children[id];if not c or not c.gatling_fallback then return end
 a.children[id]=nil
 if a.gatling==id then a.gatling=nil;a.reload=Tank.new_reload('new') end
 if a.observed and a.observed[id] then a.observed[id].gatling_evidence=nil end
 log('TANK_GATLING_FALLBACK_LOST hull='..tostring(M.hull)..' id='..id..' reason='..reason)
end
function Tank.reset_fallback_policy()
 local a=Tank.active;if not a then return end
 for id,c in pairs(a.children)do
  if c.gatling_fallback then Tank.clear_gatling_fallback(a,id,'weapon_cache_setting') end
 end
 for _,q in pairs(a.observed or {})do q.gatling_evidence=nil;q.rocket_evidence=nil end
end
function Tank.try_gatling_fallback(a,id,exists,f,n,now)
 local q=a.observed and a.observed[id];if not q then return false end
 local c=a.children[id]
 local valid=exists~=false and not (c and c.cache_rejected)
  and Tank.gatling_batch_shape(f) and Tank.gatling_native(a,id,n)
 local v=valid and Tank.decode('gatling',f)
 if not v or v.reserve~=n.magazine.reserve or v.current~=n.magazine.current or v.state~=n.state then
  q.gatling_evidence=nil;return false
 end
 if a.gatling and a.gatling~=id then a.ambiguous=true;q.gatling_evidence=nil;return false end
 -- Do not choose between two exact-resource candidates, even when only one
 -- happens to have finished its two-pair calibration.
 for _,ref in ipairs(a.refs)do
  if ref~=id then
   local other=a.observed and a.observed[ref];local d=other and other.native and other.native.descriptor
   if d and d.resource==Tank.GATLING_RESOURCE and other.exists~=false then
    a.ambiguous=true;q.gatling_evidence=nil;return false
   end
  end
 end
 local old=q.gatling_evidence;local d=n.descriptor
 local same=old and old.ref_key==a.ref_key and Native.same(old.descriptor,d)
  and now>old.at and now-old.at<=1.2
 -- A repeated call using the same sample cannot count twice.
 if old and old.at==now then return false end
 local count=same and old.samples+1 or 1
 q.gatling_evidence={descriptor=descriptor_copy(d),ref_key=a.ref_key,at=now,samples=count}
 if count<2 then return false end
 if not Tank.bind_shape(a,id,'gatling') then return false end
 c=a.children[id];c.gatling_fallback=true;c.native_descriptor=descriptor_copy(d)
 c.cache_model='magazine';c.cache_live=true;c.state_cache_ok=true
 c.value={reserve=n.magazine.reserve,current=n.magazine.current,state=n.state};c.at=now
 c.next_cache=now+.1;c.next_compare=now+1;a.next_gatling=now+.1
 Tank.feed_reload(a.reload,c.value,now)
 log('TANK_GATLING_FALLBACK hull='..tostring(M.hull)..' id='..id
  ..' resource='..d.resource..' reason=exact_resource_paired samples='..count
  ..' f13='..tostring(f[13])..' f14='..tostring(f[14]))
 -- Deliberately do not export this evidence to Tank.resource_profiles.
 return true
end

-- Unified data dictionary. No eval/loadstring, shell, external executable or writes
-- to game state. Existing CFG/FRV position settings are imported on first creation.
local HudConfig={next_read=0,revision=0}
HudConfig.schema={
 tank_offset_y={45,500},tank_scale={.5,2},frv_x={0,1},frv_y={0,1},frv_scale={.5,2},
 alpha={.1,1},font={new=true,old=true},reload_ring={boolean=true},reticle={boolean=true},
 weapon_cache={boolean=true},debug={boolean=true},perf={boolean=true,legacy=true}
}
function HudConfig.current()
 return {tank_offset_y=C.offset_y,tank_scale=C.scale,frv_x=Position.x,frv_y=Position.y,frv_scale=Position.scale,
  alpha=C.alpha,font=C.geometry_numbers and 'new' or 'old',reload_ring=C.reload_ring~=false,reticle=C.reticle~=false,
  weapon_cache=C.weapon_cache~=false,debug=C.debug}
end
function HudConfig.parse(s)
 if type(s)~='string' or #s>8192 then return nil,'file exceeds 8 KiB' end
 s=s:gsub('^\239\187\191','')
 if s:sub(1,2)=='\255\254' or s:sub(1,2)=='\254\255' then
  local le=s:sub(1,2)=='\255\254';if #s%2~=0 then return nil,'invalid UTF-16' end
  local out={};for i=3,#s,2 do local a,b=s:byte(i,i+1);local n=le and (a+b*256) or (b+a*256);out[#out+1]=n<128 and string.char(n) or '?' end;s=table.concat(out)
 end
 if s:find('\0',1,true) then return nil,'invalid encoding' end
 local out={}
 for line in (s..'\n'):gmatch('(.-)\n') do
  line=line:gsub('[#;].*$',''):match('^%s*(.-)%s*$')
  if line~='' then
   local k,v=line:match('^([a-z_]+)%s*=%s*([%w%.%-]+)$');local spec=k and HudConfig.schema[k]
   if not spec or out[k]~=nil then return nil,'unknown/duplicate setting '..tostring(k) end
   if spec.boolean then
    if v~='true' and v~='false' then return nil,'expected true/false for '..k end;out[k]=v=='true'
   elseif spec[1] then
    if not (v:match('^%d+$') or v:match('^%d+%.%d+$')) then return nil,'invalid decimal '..k end
    local n=tonumber(v);if not n or n~=n or n<spec[1] or n>spec[2] then return nil,'out of range '..k end;out[k]=n
   else if not spec[v] then return nil,'expected new/old for font' end;out[k]=v end
  end
 end
 for k,spec in pairs(HudConfig.schema) do if not spec.legacy and out[k]==nil then return nil,'missing setting '..k end end
 out.perf=nil -- accept old perf=true/false without enabling anything or rejecting settings
 return out
end
function HudConfig.template(v)
 local lines={
 '# DRIVER HUD 1.6 - Unified HUD settings / 统一设置',
 '# Edit in Notepad and save; applies in about 2 seconds / 记事本保存后约两秒生效',
 '# Invalid edits preserve ALL previous settings / 格式错误保留全部上次设置',
 '# font = new (default / 默认几何字体) or old (旧版字体)',
 '# tank_offset_y: 45..500, from bottom at reference resolution / 参考分辨率距底部',
 '# tank_scale / frv_scale: 0.5..2; alpha: 0.1..1',
 '# frv_x: left 0 -> right 1; frv_y: top 0 -> bottom 1 / FRV中心归一化位置',
 '# weapon_cache=false uses bounded batch only / 关闭组件缓存仅保留有限频率批量读取',
 '# debug writes ordinary diagnostics / debug 控制普通故障诊断日志',
 '# 原 driver_hud.cfg / frv_hud_position.txt 仅首次迁入；以后修改本文件', ''}
 for _,k in ipairs({'tank_offset_y','tank_scale','frv_x','frv_y','frv_scale','alpha','font','reload_ring','reticle','weapon_cache','debug'}) do lines[#lines+1]=k..' = '..tostring(v[k]) end
 return table.concat(lines,'\r\n')..'\r\n'
end
function HudConfig.apply(v)
 local prev=HudConfig.current();local changed=false
 for k,x in pairs(v) do if prev[k]~=x then changed=true end end
 if not changed then return end
 C.offset_y,C.scale,C.alpha=v.tank_offset_y,v.tank_scale,v.alpha
 C.geometry_numbers=v.font=='new';C.reload_ring,C.reticle,C.weapon_cache=v.reload_ring,v.reticle,v.weapon_cache
 C.debug=v.debug
 Position.x,Position.y,Position.scale=v.frv_x,v.frv_y,v.frv_scale
 Position.revision=Position.revision+1;HudConfig.revision=HudConfig.revision+1;M.draw_key=nil
 if Tank then
  Tank.ring_key=nil
  if prev.weapon_cache~=v.weapon_cache and Tank.reset_fallback_policy then Tank.reset_fallback_policy() end
 end
 log('HUD_CONFIG applied revision='..HudConfig.revision..' font='..v.font)
end
function HudConfig.reload(now)
 if now<HudConfig.next_read then return end;HudConfig.next_read=now+2
 if not dir or not io or not io.open then return end
 local path=dir..'/Arrowhead/Helldivers2/driver_hud_settings.txt'
 local ok,f,err,code=pcall(io.open,path,'rb');if not ok then return end
 if not f then
  if code~=2 and not (err==nil and code==nil) then return end
  if not HudConfig.imported then Position.reload(now);HudConfig.imported=true end
  if now<(HudConfig.next_create or 0) then return end;HudConfig.next_create=now+30
  local check,existing,again_error,again_code=pcall(io.open,path,'rb');if not check then return end
  if existing then pcall(existing.close,existing);return end
  if again_code~=2 and not (again_error==nil and again_code==nil) then return end
  local good,output=pcall(io.open,path,'wb')
  if good and output then local wrote,result=pcall(output.write,output,HudConfig.template(HudConfig.current()));pcall(output.close,output);if wrote and result then log('HUD_CONFIG created=driver_hud_settings.txt') end end
  return
 end
 HudConfig.imported=true
 local good,s=pcall(f.read,f,8193);pcall(f.close,f);if not good then return end
 local value,why=HudConfig.parse(s)
 if value then HudConfig.error=nil;HudConfig.apply(value)
 elseif HudConfig.error~=why then log('HUD_CONFIG rejected='..tostring(why)..' keeping_previous=true');HudConfig.error=why end
end

local material='mods/driver_hud/solid'
local function remember(kind,id) if id~=nil then M.ids[#M.ids+1]={kind,id} end end
local function tri(x1,y1,x2,y2,x3,y3,a)
 local uv=V2(0.5,0)
 remember('destroy_triangle',Gui.triangle(M.gui,V3(x1,0,y1),V3(x2,0,y2),V3(x3,0,y3),3,Color(math.floor(a*255),255,255,255),material,uv,uv,uv))
end
local function rect(x,y,w,h,a) if w<=0 or h<=0 then return end tri(x,y,x+w,y,x,y+h,a);tri(x+w,y,x+w,y+h,x,y+h,a) end
-- Numeric HUD glyphs use the SAME triangle/material/GUI path as the surrounding
-- shapes. This compatibility path does not depend on the debug-font material
-- transform. HUD Curve still requires live-game visual verification; no HUD
-- setting is written, and no game font data is copied.
local HudNumber = (function()
 local H={};local WHITE={255,255,255}
 local segments={{{0,1},{1,1}},{{1,1},{1,.5}},{{1,.5},{1,0}},{{0,0},{1,0}},{{0,.5},{0,0}},{{0,1},{0,.5}},{{0,.5},{1,.5}},{{0,0},{1,1}}}
 local glyphs={['0']={1,2,3,4,5,6},['1']={2,3},['2']={1,2,7,5,4},['3']={1,2,7,3,4},['4']={6,7,2,3},['5']={1,6,7,3,4},['6']={1,6,7,5,3,4},['7']={1,2,3},['8']={1,2,3,4,5,6,7},['9']={1,2,3,4,6,7},['-']={7},['/']={8},[' ']={}}
 -- Cache only small, normalized glyph geometry. No engine IDs or transient
 -- Vector userdata is cached here, and bounds include actual stroke width.
 local font={};local thickness=.085;local cw=.43;local advance=.63
 for ch,indices in pairs(glyphs) do
  local g={quads={},xmin=math.huge,ymin=math.huge,xmax=-math.huge,ymax=-math.huge,advance=ch==' ' and .32 or advance}
  for _,i in ipairs(indices) do
   local p,q=segments[i][1],segments[i][2]
   local x1,y1,x2,y2=p[1]*cw,p[2],q[1]*cw,q[2]
   local dx,dy=x2-x1,y2-y1;local length=math.sqrt(dx*dx+dy*dy)
   local nx,ny=-dy/length*thickness/2,dx/length*thickness/2
   local quad={{x1+nx,y1+ny},{x1-nx,y1-ny},{x2+nx,y2+ny},{x2-nx,y2-ny}}
   g.quads[#g.quads+1]=quad
   for _,v in ipairs(quad) do g.xmin=math.min(g.xmin,v[1]);g.xmax=math.max(g.xmax,v[1]);g.ymin=math.min(g.ymin,v[2]);g.ymax=math.max(g.ymax,v[2]) end
  end
  font[ch]=g
 end
 function H.bounds(label,size)
  if type(label)~='string' or #label>32 or type(size)~='number' or size~=size or size<=0 or size>10000 then return nil end
  local at,xmin,ymin,xmax,ymax=0,math.huge,math.huge,-math.huge,-math.huge
  for i=1,#label do
   local g=font[label:sub(i,i)];if not g then return nil end
   if #g.quads>0 then xmin=math.min(xmin,at+g.xmin);xmax=math.max(xmax,at+g.xmax);ymin=math.min(ymin,g.ymin);ymax=math.max(ymax,g.ymax) end
   at=at+g.advance
  end
  if xmin==math.huge then return nil end
  return xmin*size,ymin*size,xmax*size,ymax*size
 end
 function H.draw(label,x,y,size,a,c,anchor)
  local xmin,ymin,xmax,ymax=H.bounds(label,size);if xmin==nil then return false end
  local ox,oy=x-xmin,y
  if anchor=='center' then ox=x-(xmin+xmax)/2;oy=y-(ymin+ymax)/2 end
  c=c or WHITE
  local color=Color(math.floor(a*255),c[1],c[2],c[3]);local at=0
  local function emit(p,q,r)
   local uv=V2(.5,0)
   remember('destroy_triangle',Gui.triangle(M.gui,V3(ox+(at+p[1])*size,0,oy+p[2]*size),V3(ox+(at+q[1])*size,0,oy+q[2]*size),V3(ox+(at+r[1])*size,0,oy+r[2]*size),3,color,material,uv,uv,uv))
  end
  for i=1,#label do
   local g=font[label:sub(i,i)]
   for _,q in ipairs(g.quads) do emit(q[1],q[2],q[3]);emit(q[2],q[4],q[3]) end
   at=at+g.advance
  end
  return true
 end
 return H
end)()

local function text(s,x,y,size,a) if C.geometry_numbers and HudNumber.draw(s,x,y,size,a,nil,'left') then return end;remember('destroy_text',Gui.text(M.gui,s,'core/performance_hud/debug',size,'core/performance_hud/debug',V2(x,y),Color(math.floor(a*255),255,255,255))) end
local function bullet(x,y,s,a) rect(x,y,4*s,11*s,a);tri(x,y+11*s,x+4*s,y+11*s,x+2*s,y+15*s,a);rect(x-s,y-s,6*s,s,a) end
local function disk(x,y,r,a)
 for i=0,23 do local t=i*math.pi/12;local u=(i+1)*math.pi/12;tri(x,y,x+math.cos(t)*r,y+math.sin(t)*r,x+math.cos(u)*r,y+math.sin(u)*r,a) end
end
-- FRV geometry only: no texture background, no numeric wheel labels.
function FRV.triangle(x1,y1,x2,y2,x3,y3,a,c)
 local uv=V2(0.5,0)
 local id=Gui.triangle(M.gui,V3(x1,0,y1),V3(x2,0,y2),V3(x3,0,y3),3,Color(math.floor(a*255),c[1],c[2],c[3]),material,uv,uv,uv)
 if id==nil or id==false then error('FRV triangle creation failed',0) end
 remember('destroy_triangle',id)
end
function FRV.line(x1,y1,x2,y2,width,a,c)
 local dx,dy=x2-x1,y2-y1;local l=math.sqrt(dx*dx+dy*dy);if l<0.001 then return end
 local nx,ny=-dy/l*width*0.5,dx/l*width*0.5
 FRV.triangle(x1+nx,y1+ny,x1-nx,y1-ny,x2+nx,y2+ny,a,c)
 FRV.triangle(x1-nx,y1-ny,x2-nx,y2-ny,x2+nx,y2+ny,a,c)
end
function FRV.path(points,x,y,s,width,a,c,closed)
 if not closed then
  for i=1,#points-1 do
   local p,q=points[i],points[i+1]
   FRV.line(x+p[1]*s,y+p[2]*s,x+q[1]*s,y+q[2]*s,width*s,a,c)
  end
  return
 end
 -- Shared miter vertices form a continuous ring, including every corner.
 -- No detached edge rectangles and no overlapping translucent corner patches.
 local outer,inner={},{}
 for i,p in ipairs(points) do
  local prev,nextp=points[(i-2)%#points+1],points[i%#points+1]
  local ax,ay=p[1]-prev[1],p[2]-prev[2]
  local bx,by=nextp[1]-p[1],nextp[2]-p[2]
  local al,bl=math.sqrt(ax*ax+ay*ay),math.sqrt(bx*bx+by*by)
  if al==0 or bl==0 then return end
  local nx,ny=-ay/al,ax/al;local mx,my=-by/bl,bx/bl
  local denom=1+nx*mx+ny*my;if denom<0.001 then return end
  local dx,dy=(nx+mx)*width*0.5/denom,(ny+my)*width*0.5/denom
  outer[i]={x+(p[1]+dx)*s,y+(p[2]+dy)*s}
  inner[i]={x+(p[1]-dx)*s,y+(p[2]-dy)*s}
 end
 for i=1,#points do
  local j=i%#points+1;local p,q,r,t=outer[i],inner[i],outer[j],inner[j]
  FRV.triangle(p[1],p[2],q[1],q[2],r[1],r[2],a,c)
  FRV.triangle(q[1],q[2],t[1],t[2],r[1],r[2],a,c)
 end
end
function FRV.bar(x,y,w,h,a,c)
 if w<=0 or h<=0 then return end
 FRV.triangle(x,y,x+w,y,x,y+h,a,c);FRV.triangle(x+w,y,x+w,y+h,x,y+h,a,c)
end
function FRV.wheel(x,y,s,model,a)
 if model.kind=='hub' then
  local c=FRV.color(0)
  -- A narrow, bare rim. No rubber silhouette, life bar, axle or numeric label.
  FRV.path({{7,5},{13,5},{15,7},{15,27},{13,29},{7,29},{5,27},{5,7}},x,y,s,1.8,a,c,true)
  FRV.line(x+10*s,y+9*s,x+10*s,y+25*s,1.5*s,a*0.7,c)
  return
 end
 local c=FRV.color(model.ratio)
 FRV.path({{4,0},{16,0},{20,4},{20,30},{16,34},{4,34},{0,30},{0,4}},x,y,s,2,a,c,true)
 if model.kind=='unknown' then
  FRV.line(x+7*s,y+17*s,x+13*s,y+17*s,1.5*s,a*0.7,c);return
 end
 -- A single continuous track and fill; HP is never rendered as text.
 FRV.bar(x+5*s,y+5*s,10*s,24*s,a*0.10,c)
 if model.upper and model.upper>model.ratio then
  -- Remote/unknown precision: translucent tail is the coarse interval, not an
  -- invented precise measurement. The underlying tire remains at q2 == 0.
  FRV.bar(x+5*s,y+(5+24*model.ratio)*s,10*s,24*(model.upper-model.ratio)*s,a*0.23,c)
 end
 FRV.bar(x+5*s,y+5*s,10*s,24*model.ratio*s,a*0.78,c)
end
function FRV.layout(w,h)
 local ds=math.min(w/1920,h/1080);local s=ds*Position.scale
 local x=w*Position.x-64*s;local y=h*(1-Position.y)-62*s
 x=math.max(8*ds,math.min(w-128*s-8*ds,x))
 y=math.max(8*ds,math.min(h-124*s-8*ds,y))
 return x,y,s
end
function FRV.number_fallback(label,cx,cy,size,a,c)
 return HudNumber.draw(label,cx,cy,size,a,c,'center')
end
function FRV.centered_number(label,cx,cy,size,a,c)
 if C.geometry_numbers and HudNumber.draw(label,cx,cy,size,a,c,'center') then return end
 local font='core/performance_hud/debug'
 local low,high=call(Gui.text_extents,M.gui,label,font,size)
 if low and high then
  local function xy(v)
   -- Stingray's documented result is Vector2; use its accessors, not guessed
   -- userdata fields. A table/property fallback also supports older bindings.
   local ok,fx,fy=pcall(function()return V2.x,V2.y end)
   if ok and type(fx)=='function' and type(fy)=='function' then return fx(v),fy(v) end
   return v.x,v.y
  end
  local ok,lx,ly,hx,hy=pcall(function()
   local ax,ay=xy(low);local bx,by=xy(high);return ax,ay,bx,by
  end)
  if ok and type(lx)=='number' and type(ly)=='number' and type(hx)=='number' and type(hy)=='number'
   and lx==lx and ly==ly and hx==hx and hy==hy
   and hx>=lx and hy>=ly and hx-lx<size*20 and hy-ly<size*5
   and math.abs(lx)<size*20 and math.abs(ly)<size*20 then
   remember('destroy_text',Gui.text(M.gui,label,font,size,font,V2(cx-(lx+hx)/2,cy-(ly+hy)/2),Color(math.floor(a*255),c[1],c[2],c[3])))
   return
  end
 end
 FRV.number_fallback(label,cx,cy,size,a,c)
end
-- Four cabin cells only. The former gunner cell is the hull number. The
-- 40x5 logical-unit gap above it is reserved for future vehicle ammunition;
-- no placeholder bar or inferred ammunition value is drawn in this build.
FRV.seat_cells={{38,73,25,23},{65,73,25,23},{38,47,25,23},{65,47,25,23}}
FRV.future_ammo_rect={44,35,40,5}
local function seat_polygon(w,h,r)
 return {{r,0},{w-r,0},{w,r},{w,h-r},{w-r,h},{r,h},{0,h-r},{0,r}}
end
function FRV.fill_polygon(points,x,y,s,a,c)
 -- These are convex bevelled cells, so a fan has no overlapping interiors.
 for i=2,#points-1 do
  FRV.triangle(x+points[1][1]*s,y+points[1][2]*s,x+points[i][1]*s,y+points[i][2]*s,
   x+points[i+1][1]*s,y+points[i+1][2]*s,a,c)
 end
end
function FRV.seat_style(kind)
 if kind=='SELF' then return {255,145,48},1,.17 end
 if kind=='OTHER' then return {245,247,244},.95,.13 end
 if kind=='UNKNOWN' then return {128,138,148},.36,0 end
 return {128,138,148},.24,0
end
function FRV.draw_slot3_icon(i,cx,cy,w,h,s,a)
 local icon=FrvSlot3.icon(i);if not icon then return end
 local b=icon.bounds or {0,0,24,24};local bw,bh=b[3]-b[1],b[4]-b[2]
 if bw<=0 or bh<=0 then return end
 local unit=math.min(w*s/bw,h*s/bh)
 local ox=cx-(b[1]+bw*.5)*unit;local oy=cy-(b[2]+bh*.5)*unit
 for _,layer in ipairs({{icon.weapon,{73,173,201}},{icon.support,{245,247,244}}}) do
  for _,rect in ipairs(layer[1]) do
   FRV.bar(ox+rect[1]*unit,oy+rect[2]*unit,rect[3]*unit,rect[4]*unit,a,layer[2])
  end
 end
end
function FRV.draw_slot3_isolated(i,cx,cy,w,h,s,a)
 local icon=FrvSlot3.icon(i)
 if not icon or FrvSlot3.visual_faults[icon] then return end
 local first=#M.ids
 local ok,why=pcall(FRV.draw_slot3_icon,i,cx,cy,w,h,s,a)
 if not ok then
  -- Roll back ONLY this optional icon's newly allocated handles. The current
  -- base HUD (including its first frame) can still commit successfully.
  for n=#M.ids,first+1,-1 do
   local p=M.ids[n];call(Gui[p[1]],M.gui,p[2]);M.ids[n]=nil
  end
  FrvSlot3.visual_faults[icon]=true
  log('FRV_ICON_DRAW_DISABLED seat='..i..' core_unaffected=true reason='..tostring(why))
 end
end
function FRV.draw_seat(i,x,y,s,a)
 local slot=FrvSeats.slots[i];local c,opacity,fill=FRV.seat_style(slot and slot.kind or 'UNKNOWN')
 local cell=FRV.seat_cells[i];local cx,cy=x+cell[1]*s,y+cell[2]*s
 if fill>0 then FRV.fill_polygon(seat_polygon(cell[3]-2,cell[4]-2,1.5),cx+s,cy+s,s,a*fill,c) end
 FRV.path(seat_polygon(cell[3],cell[4],2),cx,cy,s,1.15,a*opacity,c,true)
 if slot and (slot.kind=='SELF' or slot.kind=='OTHER') then
  FRV.draw_slot3_isolated(i,cx+cell[3]*s/2,cy+cell[4]*s/2,cell[3]-2,cell[4]-2,s,a)
 end
end
-- Retain ten disjoint drawing groups: body, four seat+icon cells, four wheels,
-- hull number. M.ids remains the sole flat owner used by clear/surface_reset.
-- New handles for changed groups are staged together; any base drawing failure
-- destroys ONLY the staged handles and keeps the last complete presentation.
local function part_values(index,d)
 if index==1 or index==10 then return FRV.hp,FRV.max end
 if index<=5 then
  local i=index-1;local slot=FrvSeats.slots[i]
  local kind=slot and slot.kind or 'UNKNOWN'
  local av=slot and slot.avatar
  local icon=(kind=='SELF' or kind=='OTHER') and FrvSlot3.icon(i) or nil
  return kind,icon,icon and FrvSlot3.visual_faults[icon],
   av and av.entity,av and av.goid,av and av.unit,av and av.resource
 end
 local i=index-5
 return d~=nil,d and d.precision,d and d.damage and d.damage[i],
  d and d.hp and d.hp[i],d and d.max and d.max[i],
  d and d.hp_valid and d.hp_valid[i],d and d.q and d.q[i]
end
local function part_matches(part,...)
 if not part or part.n~=select('#',...) then return false end
 for i=1,part.n do if part.values[i]~=select(i,...) then return false end end
 return true
end
local function part_record(ids,...)
 return {ids=ids,n=select('#',...),values={...}}
end
local WHEEL_POSITIONS={{8,84},{100,84},{8,8},{100,8}}
local BODY_POINTS={{43,2},{85,2},{92,10},{92,92},{85,122},{43,122},{36,92},{36,10}}
local WINDSCREEN_POINTS={{43,99},{47,113},{81,113},{85,99}}
local function paint_part(index,x,y,s,a,d)
 if index==1 then
  local c=FRV.color(FRV.hp and FRV.max and FRV.hp/FRV.max or nil)
  FRV.path(BODY_POINTS,x,y,s,1.8,a*0.9,c,true)
  FRV.path(WINDSCREEN_POINTS,x,y,s,1.5,a*0.70,c,true)
 elseif index<=5 then FRV.draw_seat(index-1,x,y,s,a)
 elseif index<=9 then
  local i=index-5;local p=WHEEL_POSITIONS[i]
  FRV.wheel(x+p[1]*s,y+p[2]*s,s,FRV.wheel_model(d,i),a)
 else
  local c=FRV.color(FRV.hp and FRV.max and FRV.hp/FRV.max or nil)
  local label=FRV.hp~=nil and tostring(math.floor(FRV.hp+0.5)) or '--'
  FRV.centered_number(label,x+64*s,y+20*s,13*s,a,c)
 end
end
function FRV.draw(w,h)
 local d,v=FRV.data,FRV.vehicle;if not v then return end
 local old=FRV.render_parts
 -- Descriptor scalars are copied, not retained by mutable table alias. No
 -- native pointer/telemetry authorization is cached by this visual-only path.
 local reuse=old and M.draw_key~=nil and M.draw_key==old.key and old.owner==M.ids and old.gui==M.gui
  and old.session==M.session and old.avatar==M.avatar and old.identity==FRV.identity_key
  and old.entity==v.entity and old.goid==v.goid and old.unit==v.unit and old.resource==v.resource
  and old.w==w and old.h==h and old.position==Position.revision
  and old.x==Position.x and old.y==Position.y and old.scale==Position.scale
  and old.alpha==C.alpha and old.font==C.geometry_numbers
 -- Health snapshots are new private Lua tables returned by Native.health;
 -- seat/icon changes publish revisions. These are drawing cues only, never
 -- memory addresses or permissions. A new sample still compares every part.
 if reuse and old.data==d and old.hp==FRV.hp and old.max==FRV.max
  and old.seats_revision==FrvSeats.revision and old.icons_revision==FrvSlot3.revision then return end
 local dirty=0
 for i=1,10 do
  if not reuse or not part_matches(old.parts[i],part_values(i,d)) then dirty=dirty+2^(i-1) end
 end
 if dirty==0 then
  old.data=d;old.hp=FRV.hp;old.max=FRV.max
  old.seats_revision=FrvSeats.revision;old.icons_revision=FrvSlot3.revision
  return
 end -- scalar comparisons only: no draw-key strings/tables
 local before=M.ids
 local staged={};M.ids=staged
 local parts={};local combined,next_state,next_serial
 local x,y,s=FRV.layout(w,h);local a=math.min(1,C.alpha+0.12)
 local ok,err=pcall(function()
  for i=1,10 do
   if math.floor(dirty/2^(i-1))%2==0 then parts[i]=old.parts[i]
   else
    local first=#staged;paint_part(i,x,y,s,a,d)
    local ids={};for j=first+1,#staged do ids[#ids+1]=staged[j] end
    parts[i]=part_record(ids,part_values(i,d))
   end
  end
  -- Allocate all bookkeeping while rollback is still possible. No Lua table
  -- or key-string allocation is required after retirement starts.
  combined={}
  for i=1,10 do for _,p in ipairs(parts[i].ids) do combined[#combined+1]=p end end
  next_serial=(M.frv_commit or 0)+1
  next_state={key='frv_parts:'..next_serial,owner=combined,parts=parts,gui=M.gui,session=M.session,avatar=M.avatar,
   identity=FRV.identity_key,entity=v.entity,goid=v.goid,unit=v.unit,resource=v.resource,
   w=w,h=h,position=Position.revision,x=Position.x,y=Position.y,scale=Position.scale,
   alpha=C.alpha,font=C.geometry_numbers,data=d,hp=FRV.hp,max=FRV.max,
   seats_revision=FrvSeats.revision,icons_revision=FrvSlot3.revision}
 end)
 M.ids=before -- restore ownership before any return/error path
 if not ok then
  for _,p in ipairs(staged) do call(Gui[p[1]],M.gui,p[2]) end
  error(err,0)
 end
 -- Build the replacement owner list before retiring anything. A partial
 -- creation must never discard a still-valid HUD or leak its new handles.
 if reuse then
  for i=1,10 do
   if parts[i]~=old.parts[i] then
    for _,p in ipairs(old.parts[i].ids) do call(Gui[p[1]],M.gui,p[2]) end
   end
  end
 else
  for _,p in ipairs(before) do call(Gui[p[1]],M.gui,p[2]) end
  if Tank then Tank.clear_ring() end
 end
 M.ids=combined;M.frv_commit=next_serial;M.draw_key=next_state.key;FRV.render_parts=next_state
end

local function draw(w,h)
 local key=table.concat({w,h,tostring(M.hull),tostring(M.hp),tostring(M.max),tostring(M.ammo),tostring(M.mg)},':')
 if key==M.draw_key then return end
 clear()
 local s=math.min(w/1920,h/1080)*C.scale
 local x=w/2-150*s;local y=C.offset_y*s;local a=C.alpha
 rect(x,y,300*s,1.5*s,a);rect(x,y+14.5*s,300*s,1.5*s,a);rect(x,y,1.5*s,16*s,a);rect(x+298.5*s,y,1.5*s,16*s,a)
 rect(x+3*s,y+3*s,294*s,10*s,0.12)
 if M.hp and M.max then rect(x+3*s,y+3*s,294*s*M.hp/M.max,10*s,a*0.66) end
 local hp=M.hp and (tostring(math.floor(M.hp+0.5))..' / '..tostring(math.floor(M.max+0.5))) or '-- / --'
 text(hp,x,y+23*s,18*s,a)
 bullet(x+179*s,y+23*s,s,a);text(M.ammo and tostring(M.ammo) or '--',x+191*s,y+23*s,18*s,a)
 for i=0,2 do bullet(x+(228+i*5)*s,y+23*s,s*0.7,a) end
 text(M.mg and tostring(M.mg) or '--',x+247*s,y+23*s,18*s,a)
 local ds=math.min(w/1920,h/1080)
 if C.reticle~=false then disk(w/2,h/2,3.2*ds,0.10);disk(w/2,h/2,2.5*ds,0.18);disk(w/2,h/2,1.8*ds,0.35);disk(w/2,h/2,1.1*ds,0.5) end
 M.draw_key=key
end
-- Tank variant presentation: static HUD and a separately cached reload overlay.
-- No 144-Hz recreation of the reticle/health/numbers while the ring advances.
Tank.ring_ids={}
function Tank.clear_ring()
 if #Tank.ring_ids==0 then Tank.ring_key=nil;Tank.ring_gui=nil;return end
 if Tank.ring_gui==M.gui and M.gui then
  for _,p in ipairs(Tank.ring_ids) do call(Gui[p[1]],M.gui,p[2]) end
 end
 Tank.ring_ids={};Tank.ring_key=nil;Tank.ring_gui=nil
end
local function tank_outline(x,y,w,h,a,s)
 rect(x,y,w,s,a);rect(x,y+h-s,w,s,a);rect(x,y,s,h,a);rect(x+w-s,y,s,h,a)
end
function Tank.draw_new(w,h)
 local a=Tank.active;if not a then return end
 local gat=a.gatling and a.children[a.gatling];local g=not a.ambiguous and gat and gat.value
 local ra=a.racks and a.racks[1] and a.children[a.racks[1]]
 local rb=a.racks and a.racks[2] and a.children[a.racks[2]]
 local missiles=not a.ambiguous and ra and rb and ra.value and rb.value and (ra.value.ammo+rb.value.ammo)
 local stale_g=g and M.clock-(gat.at or 0)>Tank.STALE_AFTER or false
 local stale_m=missiles and (M.clock-(ra.at or 0)>Tank.STALE_AFTER or M.clock-(rb.at or 0)>Tank.STALE_AFTER) or false
 local uncertain_g=g and Tank.sync_uncertain(a,a.gatling) or false
 local uncertain_m=missiles and (Tank.sync_uncertain(a,a.racks[1]) or Tank.sync_uncertain(a,a.racks[2])) or false
 local key=table.concat({'new_tank',w,h,a.key,tostring(M.hp),tostring(M.max),g and g.current or '?',
  g and g.reserve or '?',tostring(missiles),tostring(stale_g),tostring(stale_m),tostring(uncertain_g),tostring(uncertain_m)},':')
 if key==M.draw_key then return end
 clear()
 local s=math.min(w/1920,h/1080)*C.scale;local x=w/2-180*s;local y=C.offset_y*s;local alpha=C.alpha
 tank_outline(x,y,360*s,16*s,alpha,1.5*s)
 rect(x+3*s,y+3*s,354*s,10*s,.12)
 if M.hp and M.max and M.max>0 then rect(x+3*s,y+3*s,354*s*math.max(0,math.min(1,M.hp/M.max)),10*s,alpha*.66) end
 text(M.hp and (tostring(M.hp)..' / '..tostring(M.max)) or '-- / --',x,y+23*s,18*s,alpha)
 local ga=alpha*(stale_g and .45 or 1)
 for i=0,2 do bullet(x+(168+i*5)*s,y+26*s,.7*s,ga) end
 -- Current belt above; SIX reserve indicators below, never seven.
 local bx=x+190*s;local bw=104*s
 tank_outline(bx,y+34*s,bw,8*s,ga,s)
 if g then rect(bx+2*s,y+36*s,(bw-4*s)*g.current/300,4*s,ga*.82)
 else rect(bx+bw/2-3*s,y+37*s,6*s,s,ga*.6) end
 tank_outline(bx,y+22*s,bw,8*s,ga,s)
 local gap=2*s;local cell=(bw-4*s-gap*5)/6
 for i=0,5 do
  local cx=bx+2*s+i*(cell+gap)
  rect(cx,y+24*s,cell,4*s,ga*(g and i<g.reserve and .82 or .12))
 end
 if not g then rect(bx+bw/2-3*s,y+25*s,6*s,s,ga*.65) end
 -- A short dotted underline denotes last-known, NOT freshly sampled, telemetry.
 if stale_g or uncertain_g then for i=0,7 do rect(bx+i*13*s,y+19*s,4*s,s,alpha*.45) end end
 local ma=alpha*(stale_m and .45 or 1)
 bullet(x+314*s,y+25*s,s,ma);text(missiles and tostring(missiles) or '--',x+329*s,y+23*s,18*s,ma)
 if stale_m or uncertain_m then for i=0,2 do rect(x+(329+i*7)*s,y+20*s,3*s,s,alpha*.45) end end
 local ds=math.min(w/1920,h/1080)
 if C.reticle~=false then disk(w/2,h/2,3.2*ds,.10);disk(w/2,h/2,2.5*ds,.18);disk(w/2,h/2,1.8*ds,.35);disk(w/2,h/2,1.1*ds,.5) end
 M.draw_key=key
end
function Tank.draw_ring(w,h)
 local a=Tank.active;local r=a and a.reload
 if C.reload_ring==false or not r or r.phase=='idle' then Tank.clear_ring();return end
 local suspended=FRV.grace_until~=nil
 -- Rendering may continue in native display-grace, but state must not advance.
 local progress=r.known_start and math.max(0,math.min(.985,r.elapsed/4)) or nil
 local steps=progress and math.floor(progress*48+.0001) or -1
 local key=table.concat({a.key,w,h,steps,r.phase,tostring(r.telemetry_stale),tostring(suspended),tostring(M.gui)},':')
 if key==Tank.ring_key then return end
 Tank.clear_ring()
 local saved=M.ids;M.ids={}
 local ok,err=pcall(function()
  local s=math.min(w/1920,h/1080)*C.scale
  -- Standalone reload ring sits LEFT of the reloadable weapon icon/group.
  -- Old main-cannon icon is centered near +31 px; new Gatling group near -5 px.
  -- Keep a visible gap so the ring never crowds the icon or ammo text/bars.
  local cx=w/2+(a.kind=='new' and -25 or 14)*s;local cy=(C.offset_y+31)*s
  local radius=(a.kind=='new' and 8.5 or 8.0)*s
  local alpha=C.alpha*.9 -- Constant brightness through pauses and telemetry gaps.
  for i=0,47 do
   local from=math.pi*.5-i*math.pi/24;local to=math.pi*.5-(i+.86)*math.pi/24
   local bright=steps>=0 and i<steps
   -- Unknown initial progress uses a static dotted ring, never a fake percentage.
   if steps>=0 or i%3==0 then
    FRV.line(cx+math.cos(from)*radius,cy+math.sin(from)*radius,
     cx+math.cos(to)*radius,cy+math.sin(to)*radius,1.3*s,bright and alpha or alpha*.2,{255,255,255})
   end
  end
 end)
 Tank.ring_ids=M.ids;M.ids=saved;Tank.ring_gui=M.gui
 if not ok then Tank.clear_ring();error(err,0) end
 Tank.ring_key=key
end
function Tank.draw(w,h)
 if Tank.active and Tank.active.kind=='new' then Tank.draw_new(w,h) else draw(w,h) end
 local ok,err=pcall(Tank.draw_ring,w,h)
 if not ok then
  pcall(Tank.clear_ring)
  if M.clock>=(Tank.ring_error_at or 0) then log('TANK_RING_ERROR '..tostring(err));Tank.ring_error_at=M.clock+10 end
 end
end

-- One dictionary dispatches supported HUDs. A failed redraw restores the last
-- complete static HUD; telemetry exceptions do not reset vehicle identity.
local HudViews={FRV=function(...)return FRV.draw(...)end,TANK=function(...)return Tank.draw(...)end}
local real_clear=clear
clear=function()
 local tx=M.render_transaction
 if not tx then return real_clear() end
 if not tx.cleared then
  tx.cleared=true;M.ids={};M.draw_key=nil
  if Tank then Tank.clear_ring() end
 end
end
local function render_view(mode,w,h)
 if M.clock<(M.next_draw_retry or 0) then return end
 local tx
 if mode~='FRV' then tx={ids=M.ids,key=M.draw_key};M.render_transaction=tx end
 local ok,err=pcall(HudViews[mode],w,h);M.render_transaction=nil
 if tx and tx.cleared then
  if ok then
   for _,p in ipairs(tx.ids) do call(Gui[p[1]],M.gui,p[2]) end
  else
   for _,p in ipairs(M.ids) do call(Gui[p[1]],M.gui,p[2]) end
   M.ids=tx.ids;M.draw_key=tx.key
  end
 end
 if not ok then M.next_draw_retry=M.clock+.25 else M.next_draw_retry=nil end
 if not ok and M.clock>=(M.draw_error_at or 0) then
  log('HUD_DRAW_ERROR mode='..mode..' retaining_display=true '..tostring(err));M.draw_error_at=M.clock+10
 end
end
-- An ownership-list API gap must not freeze the new seat telemetry behind its
-- 200 ms ownership refresh. Reuse only the already bound context; the native
-- seat sample still verifies the local Avatar and current collection itself.
local function render_existing_frv(worlds)
 if FRV.mode~='FRV' or not FRV.vehicle or not M.gui or not live(worlds,M.gui_world) then return end
 if sr.Window and call(sr.Window.show_cursor)==true then clear();return end
 local w,h=call(App.back_buffer_size)
 if type(w)=='number' and type(h)=='number' and w>0 and h>0 then render_view('FRV',w,h) end
end
-- Do not assume App.worlds is dense or that a second world always exists.
local function ensure_gui(worlds,world)
 if M.gui and live(worlds,M.gui_world) then return true end
 surface_reset(worlds)
 if M.clock<(M.next_gui_retry or 0) then return false end
 M.next_gui_retry=M.clock+.5
 local attempts=0
 local function attempt(v)
  attempts=attempts+1
  local gui=call(World.create_screen_gui,v,'scale',1,1)
  if gui then
   M.gui=gui;M.gui_world=v;M.next_gui_retry=nil
   if M.gui_missing then log('HUD_GUI_RECOVERED');M.gui_missing=nil end
   return true
  end
 end
 for _,v in pairs(worlds) do
  if v~=world and attempts<4 and attempt(v) then return true end
 end
 if live(worlds,world) and attempt(world) then return true end
 if not M.gui_missing then log('HUD_GUI_UNAVAILABLE retry_seconds=0.5');M.gui_missing=true end
 return false
end
-- Inlined after the original HUD functions by tools/make_lua51_port.py.
-- Network-only adapter. All data channels are reads; GUI calls only draw the HUD.
local Lua51 = {version='1.6',next_report=0,next_variant=0}
C.weapon_cache=false

-- The network word contains four two-bit bands, not exact wheel HP.
-- Signed int32 snapshots (-1/-2/-3/-4) are decoded without LuaJIT bit/ffi.
function Lua51.wheel_bands(word)
 if type(word)~='number' or word~=word or word~=math.floor(word)
  or word < -2147483648 or word > 4294967295 then return nil end
 local q={};for i=0,3 do q[i+1]=math.floor(word/4^i)%4 end
 return q
end

-- da1ad977 is the visibility word: a depleted HP band is NOT a detached tire.
-- Recorded LF/LR detachments set bits 14/18. The published entity table has
-- four consecutive tire dismemberment groups targeting visibility bits
-- 14/16/18/20, identical for HMG and supply. RF/RR order follows those groups;
-- left wheels are live-confirmed, right wheels still need live confirmation.
-- See build/wheel-component-evidence.json for the static and captured evidence.
local wheel_detach_bits={16384,65536,262144,1048576} -- LF, RF, LR, RR
function Lua51.wheel_damage(p,f)
 if not p or type(f)~='table'then return nil end
 local index=p.name=='hmg_frv'and 53 or p.name=='supply_frv'and 52
 if not index then return nil end
 local flags=f[index]
 if not Lua51.wheel_bands(flags)then return nil end
 local damage={}
 for i=1,4 do damage[i]=math.floor(flags/wheel_detach_bits[i])%2==1 and 2 or 0 end
 return damage
end

-- Preserve the live reference instead of spending the separate discovery budget twice.
function Lua51.avatar_ref(session,avatar)
 local av=sample(session,avatar)
 local fields=type(av)=='table' and av[64]
 local ref=type(fields)=='table' and fields[25]
 if ref==32767 then return ref,'none' end
 if integer(ref,32766) then return ref,'ref' end
 return nil,'unknown'
end

function Lua51.report(force)
 if not force and M.clock<Lua51.next_report then return end
 Lua51.next_report=M.clock+1
 local a=Tank.active
 local wheels=FRV.data and FRV.data.q and table.concat(FRV.data.q,',') or 'unknown'
 local wheel_states=FRV.data and FRV.data.damage and table.concat(FRV.data.damage,',')or'unknown'
 local key=table.concat({tostring(M.seated),tostring(FRV.mode),tostring(M.hull),
  tostring(FRV.vehicle and FRV.vehicle.goid),tostring(M.hp or FRV.hp),tostring(M.max or FRV.max),
  tostring(M.ammo),tostring(M.mg),tostring(a and a.kind),tostring(M.gui~=nil),tostring(#M.ids),wheels,wheel_states},'|')
 if force or key~=Lua51.report_key or M.clock>=(Lua51.heartbeat or 0) then
  Lua51.report_key=key;Lua51.heartbeat=M.clock+30
  log('LUA51_STATUS t='..string.format('%.3f',M.clock)..' seated='..tostring(M.seated)
   ..' mode='..tostring(FRV.mode)..' hull='..tostring(M.hull)..' ref='..tostring(M.vehicle_ref)
   ..' frv='..tostring(FRV.vehicle and FRV.vehicle.goid)..' hp='..tostring(M.hp or FRV.hp)
   ..' max='..tostring(M.max or FRV.max)..' ammo='..tostring(M.ammo)..' coax='..tostring(M.mg)
   ..' variant='..tostring(a and a.kind)..' gui='..tostring(M.gui~=nil)..' primitives='..#M.ids
   ..' wheel_q='..wheels..' wheel_states='..wheel_states..' exact_wheel_hp=false seats='..tostring(FRV.seats.status)
   ..' binding='..tostring(Lua51.binding)..' local_seat='..tostring(Lua51.bound_vehicle()and Lua51.bound_vehicle().seat))
 end
end

-- A profile is eligible only when its entire declaration matches the known schema.
function Lua51.frv_profile(session,id)
 for resource,p in pairs(FRV.profiles) do
  if FRV.schema(p,session) and call(GS.game_object_is_type,session,id,p.t)==true then return p,resource end
 end
end

-- Vehicle identity survives a seat change. Masks update local seat telemetry;
-- they never revoke an otherwise live vehicle just because the old seat emptied.
local seat_bits={TANK={1,2,4,8},FRV={8,16,32,64},HMG={8,16,1,2,4}}
local tank_roles={[1]=0,[2]=1,[4]=2,[8]=3}
local seat_labels={TANK={[1]='driver',[2]='gunner',[4]='left_passenger',[8]='right_passenger'},
 FRV={[8]='driver',[16]='front_passenger',[32]='rear_left',[64]='rear_right'},
 HMG={[8]='driver',[16]='front_passenger',[1]='rear_left',[2]='rear_right',[4]='gunner'}}
local function seat_key(kind,p)return kind=='FRV'and p and p.name=='hmg_frv'and'HMG'or kind end
function Lua51.frv_cabin_bits(p)return p and p.name=='hmg_frv'and{8,16,1,2}or{8,16,32,64}end
function Lua51.seat_occupied(mask,bit)
 return integer(mask,255)and math.floor(mask/bit)%2==0
end
function Lua51.new_seat_bit(old,new,kind,p)
 if not integer(old,255)or not integer(new,255)then return nil end
 local found
 for _,bit in ipairs(seat_bits[seat_key(kind,p)]or{})do
  if not Lua51.seat_occupied(old,bit)and Lua51.seat_occupied(new,bit)then
   if found then return nil end;found=bit
  end
 end
 return found
end
function Lua51.only_seat_bit(mask,kind,p)
 local found
 for _,bit in ipairs(seat_bits[seat_key(kind,p)]or{})do
  if Lua51.seat_occupied(mask,bit)then if found then return nil end;found=bit end
 end
 return found
end
function Lua51.entry_values(id,kind,p,f)
 if type(f)~='table'then return nil,'missing' end
 local hp,mx,mask,refs
 if kind=='FRV'then
  hp=f[p.name=='supply_frv'and 24 or 25];mx=f[10];mask=f[15];refs=f[20]
 else
  if not hull_sig(f)then return nil,'shape'end
  hp=f[30];mx=f[15];mask=f[22];refs=f[56]
 end
 if not FRV.body_valid(hp,mx)then return nil,'shape'end
 local links={}
 if type(refs)=='table'then for _,v in pairs(refs)do
  if integer(v,32766)then links[#links+1]=v end
 end end
 table.sort(links)
 return {hp=hp,mask=mask,key=kind..':'..mx..':'..table.concat(links,','),links=links,at=M.clock}
end
-- A hull encountered through the avatar reference can later be found through
-- any of its explicit children, including the new tank's gatling/rocket racks.
function Lua51.remember_reference_hull(session,id,f)
 local e=Lua51.entry
 if not e or e.session~=session or not hull_sig(f)or type(f[56])~='table'then return end
 local v=Lua51.entry_values(id,'TANK',nil,f);if not v or #v.links==0 then return end
 local r=e.registry[id]or{kind='TANK'};r.confirmed=true;r.value=v;e.registry[id]=r
 return id,f
end
function Lua51.resolve_linked_hull(session,ref,f)
 local e=Lua51.entry;if not e then return end
 for id,r in pairs(e.registry)do
  if r.kind=='TANK'and r.value then for _,child in ipairs(r.value.links)do
   if child==ref and valid_goid(session,id)then
    local hf=sample(session,id)
    if hull_sig(hf)and hull_has_ref(hf,ref)then return id,hf end
   end
  end end
 end
 local shape=Tank.shape(f)
 if shape~='gatling'and shape~='rack'then return end
 -- The observed new tank allocates five children before the hull. This only
 -- nominates candidates: each must contain an explicit backlink to this ref.
 local q=e.link_search
 if not q or q.ref~=ref then q={ref=ref,offset=1};e.link_search=q end
 for _=1,2 do
  local id=ref+q.offset;q.offset=q.offset%5+1
  if valid_goid(session,id)then
   local hf=sample(session,id)
   if hull_sig(hf)and hull_has_ref(hf,ref)then
    return Lua51.remember_reference_hull(session,id,hf)
   end
  end
 end
end
function Lua51.entry_sample(session,id,r)
 if not valid_goid(session,id)then return nil,'gone'end
 if r.kind=='FRV'and(not FRV.schema(r.p,session)
  or call(GS.game_object_is_type,session,id,r.p.t)~=true)then return nil,'type'end
 local f,why=sample(session,id);if type(f)~='table'then return nil,why end
 if r.kind=='TANK'and not r.confirmed then
  if not valid_goid(session,id-2)or not valid_goid(session,id-1)
   or call(GS.game_object_is_type,session,id-2,'rHVbvgIu')~=true
   or call(GS.game_object_is_type,session,id-1,'fZwFCDKT')~=true
   or not hull_has_ref(f,id-2)or not hull_has_ref(f,id-1)then return nil,'children'end
 end
 return Lua51.entry_values(id,r.kind,r.p,f)
end
function Lua51.entry_note(e,reason,id)
 local key=reason..':'..tostring(id)
 if key~=e.note then e.note=key
  log('LUA51_ENTRY t='..string.format('%.3f',M.clock)..' status='..reason..' hull='..tostring(id))
 end
end
function Lua51.update_seat(e,b,v)
 local bit=b.bit
 if not bit or not Lua51.seat_occupied(v.mask,bit)then
  bit=Lua51.new_seat_bit(b.last_mask,v.mask,b.kind,b.p)or Lua51.only_seat_bit(v.mask,b.kind,b.p)
 end
 b.bit=bit;b.last_mask=v.mask
 b.seat=bit and seat_labels[seat_key(b.kind,b.p)][bit]or nil
 M.lua51_role=b.kind=='TANK'and tank_roles[bit]or nil
 if b.logged_bit~=bit then
  b.logged_bit=bit
  log('LUA51_SEAT t='..string.format('%.3f',M.clock)..' hull='..b.id..' kind='..b.kind
   ..' mask='..tostring(v.mask)..' bit='..tostring(bit)..' seat='..tostring(b.seat))
 end
end
function Lua51.track_vehicle(session,id,kind,p,resource,f,origin)
 local e=Lua51.entry;if not e or e.session~=session then return end
 local v=Lua51.entry_values(id,kind,p,f);if not v or v.hp<=0 then return end
 local r=e.registry[id]or{kind=kind,p=p,resource=resource}
 r.confirmed=true;r.value=v;e.registry[id]=r
 local b=e.bound
 if not b or b.id~=id then
  local base=e.baseline and e.baseline[id]
  b={id=id,kind=kind,p=p,key=v.key,origin=origin,
   bit=base and Lua51.new_seat_bit(base.mask,v.mask,kind,p)or Lua51.only_seat_bit(v.mask,kind,p)}
  e.bound=b;Lua51.entry_note(e,'vehicle_bound_'..origin,id)
 end
 Lua51.update_seat(e,b,v)
end
function Lua51.bound_vehicle()
 local e=Lua51.entry;local b=e and e.bound
 if e and e.session==M.session and e.avatar==M.avatar and e.world==M.world then return b end
end
function Lua51.observe_entry(session,avatar,ids,owned,motion,rotation,where,state)
 local e=Lua51.entry
 if not e or e.session~=session or e.avatar~=avatar or e.world~=M.world then
  e={session=session,avatar=avatar,world=M.world,registry={},baseline={},cursor=1,
   read_cursor=1,next_scan=0,next_read=0}
  Lua51.entry=e;M.lua51_role=nil
 end
 local foot=motion==true and where==100 and state==0
 local seated=motion==false and where==100 and state==0
 if where==30 or state==2 then
  e.bound=nil;e.baseline={};e.entered=nil;e.foot_since=nil;M.lua51_role=nil;return false
 end
 -- Brief movement-flag pulses can accompany a seat animation. Keep the live
 -- vehicle during the pulse; sustained walking still dismisses the HUD.
 local keep=false
 if foot and e.bound then
  e.foot_since=e.foot_since or M.clock
  keep=M.clock-e.foot_since<.35
  if keep then foot=false;seated=true
  else e.bound=nil;e.entered=nil;e.pending=nil;M.lua51_role=nil end
 elseif not foot then e.foot_since=nil end
 if not foot and not seated then return e.bound~=nil end
 if foot then e.entered=nil;e.pending=nil
 elseif not e.entered then e.entered=M.clock end
 if foot and M.clock>=(e.next_reference or 0)then
  e.next_reference=M.clock+.15
  local ref,state=Lua51.avatar_ref(session,avatar)
  if state=='ref'and valid_goid(session,ref)then
   Lua51.remember_reference_hull(session,ref,sample(session,ref))
  end
 end
 -- Local candidate discovery remains bounded, with no three-second deadline.
 -- A known vehicle is retained when ownership migrates to another seat/peer.
 if M.clock>=e.next_scan and #ids>0 and(not e.bound or foot)then
  e.next_scan=M.clock+.1
  for _=1,math.min(16,#ids)do
   if e.cursor>#ids then e.cursor=1 end
   local id=ids[e.cursor];e.cursor=e.cursor+1
   if valid_goid(session,id)then
    local p,resource=Lua51.frv_profile(session,id)
    if p then e.registry[id]=e.registry[id]or{kind='FRV',p=p,resource=resource}
    elseif call(GS.game_object_is_type,session,id,'rHVbvgIu')==true then
     local hid=id+2;if valid_goid(session,hid)then e.registry[hid]=e.registry[hid]or{kind='TANK'}end
    end
   end
  end
 end
 if M.clock<e.next_read then return keep end;e.next_read=M.clock+(e.bound and .2 or .1)
 local keys={}
 for id in pairs(e.registry)do
  if not valid_goid(session,id)then
   e.registry[id]=nil;e.baseline[id]=nil
   if e.bound and e.bound.id==id then e.bound=nil;M.lua51_role=nil;Lua51.entry_note(e,'vehicle_destroyed',id)end
  else keys[#keys+1]=id end
 end
 table.sort(keys)
 local reads={}
 if e.bound then reads[1]=e.bound.id
 elseif #keys>0 then
  for _=1,math.min(2,#keys)do
   if e.read_cursor>#keys then e.read_cursor=1 end
   reads[#reads+1]=keys[e.read_cursor];e.read_cursor=e.read_cursor+1
  end
 end
 for _,id in ipairs(reads)do local r=e.registry[id]
  if r then
   local v,why=Lua51.entry_sample(session,id,r)
   if v then
    r.previous=r.value;r.value=v
    if foot then e.baseline[id]={mask=v.mask,key=v.key,at=v.at}end
    if e.bound and e.bound.id==id then
     if v.hp<=0 or v.key~=e.bound.key then
      if v.hp<=0 then Lua51.dead_id=id end
      e.bound=nil;M.lua51_role=nil;Lua51.entry_note(e,'vehicle_invalidated',id)
     else Lua51.update_seat(e,e.bound,v)end
    end
   elseif why=='gone'or why=='type'or why=='shape'then
    r.value=nil;e.baseline[id]=nil
    if e.bound and e.bound.id==id then e.bound=nil;M.lua51_role=nil;Lua51.entry_note(e,'vehicle_invalidated',id)end
   end
  end
 end
 if foot or e.bound then return keep end
 local found,ambiguous
 for id,r in pairs(e.registry)do local v=r.value;local b=e.baseline[id]
  if v and v.hp>0 and M.clock-v.at<1 and b and v.key==b.key then
   local bit=Lua51.new_seat_bit(b.mask,v.mask,r.kind,r.p)
   if bit then
    if found then ambiguous=true end
    found={id=id,bit=bit,key=v.key,kind=r.kind,p=r.p,origin='entry_mask'}
   end
  end
 end
 if ambiguous or not found then e.pending=nil
  Lua51.entry_note(e,ambiguous and'ambiguous_candidates'or'waiting_vehicle');return keep end
 if not e.pending or e.pending.id~=found.id or e.pending.bit~=found.bit then
  e.pending=found;e.pending.at=M.clock;return keep
 end
 if M.clock-e.pending.at>=.15 then
  e.bound=found;e.registry[found.id].confirmed=true
  Lua51.update_seat(e,found,e.registry[found.id].value)
  Lua51.entry_note(e,'entry_mask_confirmed',found.id)
 end
 return keep
end


-- A vehicle binding persists across seat/reference/ownership changes. A new
-- explicit vehicle reference can replace it; walking and destruction clear it.
function FRV.poll(session,avatar)
 if FRV.poll_session~=session or FRV.poll_avatar~=avatar then
  FRV.reset();FRV.poll_session=session;FRV.poll_avatar=avatar
 end
 if M.clock<FRV.next_poll then return FRV.mode end
 FRV.next_poll=M.clock+.2
 local ref,state=Lua51.avatar_ref(session,avatar)
 Lua51.binding='avatar_reference'
 local dead=Lua51.dead_id;local dead_ref=dead and ref==dead
 local dr=dead and Lua51.entry and Lua51.entry.registry[dead]
 if dr and dr.value then for _,child in ipairs(dr.value.links or{})do
  if ref==child then dead_ref=true end
 end end
 if dead_ref then
  FRV.invalidate('destroyed_hull');FRV.drop_tank();FRV.mode='NONE';return FRV.mode
 end
 local b=Lua51.bound_vehicle()
 if b then
  local same=ref==b.id
  local r=Lua51.entry.registry[b.id];local v=r and r.value
  if v then for _,child in ipairs(v.links or{})do if ref==child then same=true end end end
  -- Seat transitions may expose an intermediate object unrelated to the hull's
  -- published children. Replace a live binding only with another proven vehicle.
  if state=='ref'and not same then
   local p=valid_goid(session,ref)and Lua51.frv_profile(session,ref)
   local f=not p and valid_goid(session,ref)and discovery_sample(session,ref)
   if not p and not hull_sig(f)then
    local hid=valid_goid(session,ref)and resolve_weapon_hull(session,ref)
    if not hid and valid_goid(session,ref)then hid=Lua51.resolve_linked_hull(session,ref,f)end
    if hid then ref=hid;same=hid==b.id else same=true end
   end
  end
  if state~='ref'or same then ref=b.id;state='ref';Lua51.binding=b.origin or'vehicle_hold'end
 end
 if Lua51.dead_id and Lua51.dead_id==ref then
  FRV.invalidate('destroyed_hull');FRV.drop_tank();FRV.mode='NONE';return FRV.mode
 end
 if state=='unknown' then
  if not Lua51.identity_at or M.clock-Lua51.identity_at>.3 then
   FRV.invalidate('network_reference_unavailable');FRV.drop_tank();FRV.mode='NONE'
  end
  return FRV.mode
 end
 if state=='none' or not valid_goid(session,ref) then
  FRV.invalidate('network_reference_absent');FRV.drop_tank();FRV.last_relation=nil;FRV.mode='NONE'
  Lua51.identity_at=nil;Lua51.ref=nil;Lua51.new_hull=nil;return FRV.mode
 end
 if Lua51.ref~=ref then
  FRV.invalidate('network_reference_changed');FRV.drop_tank();FRV.last_relation=nil
  Lua51.ref=ref;Lua51.next_variant=0;Lua51.new_hull=nil;Lua51.variant_cursor=1
 end
 Lua51.identity_at=M.clock;M.vehicle_ref=ref
 local p,resource=Lua51.frv_profile(session,ref)
 if p then
  FRV.drop_tank();FRV.mode='FRV'
  FRV.vehicle={goid=ref,entity=ref,unit='network',resource=resource};FRV.profile=p
  FRV.read(session);return FRV.mode
 end
 -- Existing Bastion path: avatar reference -> hull or explicit hull child.
 FRV.invalidate('not_direct_frv');FRV.mode='LEGACY'
 return FRV.mode
end

bind_current_vehicle=function(session,avatar,owned_ids)
 local ref=Lua51.ref
 if not Lua51.identity_at or M.clock-Lua51.identity_at>.3 or not valid_goid(session,ref) then return end
 if M.hull==ref then return end
 local f=discovery_sample(session,ref)
 if hull_sig(f) and f[30]>0 then
  Lua51.track_vehicle(session,ref,'TANK',nil,nil,f,Lua51.binding)
  bind_hull(ref,f,Lua51.binding=='entry_mask'and'entry_mask'or'avatar64.25_hull');return
 end
 -- Arithmetic identifies a candidate only; the hull must explicitly reference this weapon.
 local hid,hf=resolve_weapon_hull(session,ref)
 if not hid then hid,hf=Lua51.resolve_linked_hull(session,ref,f)end
 if hid and hull_has_ref(hf,ref) then
  Lua51.track_vehicle(session,hid,'TANK',nil,nil,hf,'avatar_reference')
  bind_hull(hid,hf,'avatar64.25_weapon')
 end
end

function FRV.read(session)
 local d,p=FRV.vehicle,FRV.profile
 if not d or not p then return end
 if not valid_goid(session,d.goid) or not FRV.schema(p,session)
  or call(GS.game_object_is_type,session,d.goid,p.t)~=true then
  FRV.invalidate('network_type_changed');return
 end
 local f=sample(session,d.goid)
 -- HMG and supply differ by one optional reference before the current HP field.
 local hp_index=p.name=='supply_frv' and 24 or 25
 local hp,mx=type(f)=='table' and f[hp_index],type(f)=='table' and f[10]
 if type(hp)=='number'and hp<=0 then
  Lua51.dead_id=d.goid;FRV.invalidate('zero_health');FRV.mode='NONE';return
 end
 if FRV.body_valid(hp,mx) then FRV.hp,FRV.max,FRV.data_at=hp,mx,M.clock
  Lua51.track_vehicle(session,d.goid,'FRV',p,d.resource,f,Lua51.binding)
 elseif not FRV.data_at or M.clock-FRV.data_at>.25 then FRV.hp,FRV.max=nil,nil end
 local wheel_index=p.name=='supply_frv' and 25 or 26
 local q=Lua51.wheel_bands(type(f)=='table' and f[wheel_index])
 local damage=Lua51.wheel_damage(p,f)
 if q or damage then
  FRV.data={q=q,damage=damage,precision='NETWORK_QUANTIZED'};FRV.wheel_at=M.clock
 elseif not FRV.wheel_at or M.clock-FRV.wheel_at>.25 then FRV.data=nil end
 -- Destruction is independent of the coarse HP band; no exact HP is invented.
end

function FRV.tick_occupancy(session,avatar)
 local e=Lua51.entry;local b=Lua51.bound_vehicle();local id=FRV.vehicle and FRV.vehicle.goid
 local r=e and id and e.registry[id];local v=r and r.value
 if FRV.mode~='FRV'or not v or not integer(v.mask,255)or M.clock-v.at>1 then
  FrvSeats.unknown();FrvSeats.self_slot=nil;return
 end
 local slots={};local self_slot
 for i,bit in ipairs(Lua51.frv_cabin_bits(FRV.profile))do
  local occupied=Lua51.seat_occupied(v.mask,bit)
  local self=occupied and b and b.id==id and b.bit==bit
  slots[i]={kind=self and'SELF'or(occupied and'UNKNOWN'or'EMPTY')}
  if self then
   self_slot=i;slots[i].local_player=true
   slots[i].avatar={entity=avatar,goid=avatar,unit='network',resource='avatar'}
  end
 end
 FrvSeats.publish(slots,'NETWORK_MASK');FrvSeats.self_slot=self_slot;FrvSeats.valid_at=M.clock
end

function Lua51.variant(session)
 if Lua51.new_hull==M.hull then return end
 if not M.hull or M.clock<Lua51.next_variant then return end
 Lua51.next_variant=M.clock+.5
 local hf=sample(session,M.hull)
 if not hull_sig(hf) then return end
 local refs=hf[56]
 if type(refs)~='table' then return end
 local ids,seen={},{}
 for _,id in pairs(refs) do
  if not integer(id,32766) or id==0 or id==M.hull or seen[id] then return end
  seen[id]=true;ids[#ids+1]=id
 end
 if #ids~=5 then return end
 -- Five children alone do not identify the new tank. Require an observed weapon shape.
 table.sort(ids)
 local established=false
 for _=1,2 do
  Lua51.variant_cursor=(Lua51.variant_cursor or 1)
  local id=ids[Lua51.variant_cursor];Lua51.variant_cursor=Lua51.variant_cursor%#ids+1
  local shape=Tank.shape(sample(session,id))
  if shape=='gatling' then established=true;break end
 end
 if not established then return end
 local d={goid=M.hull,entity=M.hull,unit='network',resource=Tank.NEW_RESOURCE}
 FRV.last_relation={status='VEHICLE',vehicle=d,avatar={entity=M.avatar},role=nil}
 FRV.relation_session=session;FRV.relation_avatar=M.avatar;FRV.relation_at=M.clock
 -- poll remains network based; this marker is used only by the variant renderer.
 Lua51.new_hull=M.hull
end
function Tank.is_new()
 return M.hull~=nil and Lua51.new_hull==M.hull and FRV.last_relation~=nil
  and FRV.last_relation.vehicle.goid==M.hull
end

-- A destroyed hull ends telemetry before any weapon read. All optional child
-- readers keep their existing positive type/schema guards.
refresh_bound=function(session,owned)
 local hid=M.hull;if not hid then return end
 if call(GS.game_object_exists,session,hid)~=true then
  FRV.drop_tank();return
 end
 local c=cache_for(hid);local now=M.clock
 if now>=(c.next_hull or 0)then
  c.next_hull=now+.1;local hf=sample(session,hid)
  if type(hf)=='table'then
   if not FRV.hull_values(hf,hid)or(type(hf[30])=='number'and hf[30]<=0)then
    if type(hf[30])=='number'and hf[30]<=0 then Lua51.dead_id=hid end
    FRV.drop_tank();return
   end
   c.hp=hf[30];c.max=hf[15];c.hull_valid_at=now;remember_hull(hid,hf)
   if now>=(c.next_weapon_resolve or 0)then
    c.next_weapon_resolve=now+1;resolve_bound_weapon_ids(session,hid,hf,c)
   end
  end
 end
 if not c.hull_valid_at or now-c.hull_valid_at>.3 then
  c.hp,c.max,c.ammo,c.mg=nil,nil,nil,nil;clear_values();return
 end
 Lua51.variant(session)
 if Tank.is_new()then Tank.refresh_new(session);return end
 if now>=(c.next_main or 0)then c.next_main=now+.1
  if valid_goid(session,c.main_id)then read_main(session,c.main_id,c)end
 end
 if now>=(c.next_coax or 0)then c.next_coax=now+.1
  if valid_goid(session,c.coax_id)then read_coax(session,c.coax_id,c)end
 end
 if c then
  if not c.hull_valid_at or M.clock-c.hull_valid_at>1 then c.hp,c.max=nil,nil end
  if not c.main_valid_at or M.clock-c.main_valid_at>1 then c.ammo=nil end
  if not c.coax_valid_at or M.clock-c.coax_valid_at>1 then c.mg=nil end
  M.hp,M.max,M.ammo,M.mg=c.hp,c.max,c.ammo,c.mg
 end
 Tank.refresh_old(session)
end
local old_full_reset=full_reset
full_reset=function()
 old_full_reset();Lua51.dead_id=nil;Lua51.identity_at=nil;Lua51.ref=nil;Lua51.new_hull=nil;M.lua51_role=nil
end
log('LUA51_CAPABILITIES network=true gui=true native_memory=false wheels=network_2bit exact_wheel_hp=false seats=network_mask')

-- Only repeated, positively observed on-foot state uses the idle timer.
-- Pending acquisition, missing fields and active HUDs keep the original cadence.
local function settle_idle()
 if not M.idle_settled or M.seated or M.hull or FRV.mode or FRV.vehicle or (Tank and Tank.active) then
  full_reset();clear();M.idle_settled=true
 end
end
local function schedule_idle_probe()
 local due=M.next_idle_probe or M.clock
 local missed=math.max(1,math.floor((M.clock-due+1e-7)/.05)+1)
 M.next_idle_probe=due+missed*.05 -- at most one probe per rendered frame; never catch up
end
local function update(dt)
 M.frame=M.frame+1
 local step=type(dt)=='number' and dt or 0.016667
 if step~=step then step=0 elseif step<0 then step=0 elseif step>0.25 then step=0.25 end
 M.clock=M.clock+step;HudConfig.reload(M.clock)
 local session=call(Net.game_session);local peer=call(Net.peer_id)
 local worlds=call(App.worlds);local world=call(App.main_world)
 -- A missing listing is not proof every world was destroyed. Do not operate
 -- on GUI handles until the world list can be positively checked again.
 if type(worlds)~='table' then return end
 if session~=M.session or peer~=M.peer or world~=M.world then
  surface_reset(worlds);full_reset();M.player=nil;M.avatar=nil;M.avatar_valid_at=nil;M.cache={};M.known={};M.preseat_owned={};M.bg_owned_cursor=1
  M.owned_cache=nil
  M.session,M.peer,M.world=session,peer,world
 end
 -- A GUI world can disappear without App.main_world changing. Never call
 -- destroy_triangle on handles from a world absent from this verified list.
 if M.gui and not live(worlds,M.gui_world) then surface_reset(worlds) end
 local in_session=session and call(GS.in_session,session)
 if not session or not peer or not live(worlds,world) or in_session==false then
  if M.gui or next(M.ids)~=nil then surface_reset(worlds) end
  settle_idle();M.next_idle_probe=nil;return
 end
 if in_session~=true then return end
 -- Session/peer/main-world, GUI-world lifetime and in_session are checked above
 -- EVERY frame. The skip cannot touch native or GUI state from a cached world.
 if not M.seated and M.idle_settled and M.next_idle_probe and M.clock+1e-7<M.next_idle_probe then
  return
 end
 -- Cache ownership only after native binding, not during legacy acquisition or
 -- on each on-foot probe (supplies the pre-entry ownership snapshot).
 local cached=M.owned_cache
 local stable=M.seated and (FRV.mode=='FRV' or FRV.mode=='TANK') and not FRV.grace_until
 if not stable or not cached or M.clock>=cached.until_time then
  local owned=call(GS.objects_owned_by,session,peer)
  if type(owned)~='table' then
   M.next_idle_probe=nil;
   if stable and cached and M.avatar then
    FRV.tick_occupancy(session,M.avatar);render_existing_frv(worlds)
   end
   return -- Preserve RC2 vehicle binding/Health on a transient ownership gap.
  end
  local set,ids={},{}
  for _,id in pairs(owned) do if integer(id,32766) then set[id]=true;ids[#ids+1]=id end end
  cached={set=set,ids=ids,until_time=M.clock+0.2};M.owned_cache=cached
 end
 local set,owned_ids=cached.set,cached.ids
 -- Player object 0 is legitimate in captured sessions. Vehicle/Avatar GOIDs keep
 -- the existing stricter checks; do not reuse valid_goid() for the player object.
 if M.player==nil or not set[M.player] or call(GS.game_object_is_type,session,M.player,'un6y1d')~=true then
  M.player=nil
  for id in pairs(set) do
   if call(GS.game_object_is_type,session,id,'un6y1d')==true then
    if M.player~=nil then clear();full_reset();return end
    M.player=id
   end
  end
 end
 if M.player==nil or call(GS.game_object_exists,session,M.player)~=true then
  settle_idle();M.next_idle_probe=nil;M.avatar=nil;M.avatar_valid_at=nil;return
 end
 local avatar=call(GS.game_object_field,session,M.player,'baegche')
 if avatar==nil and M.avatar and M.seated then avatar=M.avatar
 elseif avatar~=nil then M.avatar_valid_at=M.clock end
 if avatar~=M.avatar then full_reset();M.avatar=avatar end
 if not integer(avatar,32766) or avatar==0 or call(GS.game_object_exists,session,avatar)~=true or call(GS.game_object_is_type,session,avatar,'gl7xl2w')~=true then
  settle_idle();M.next_idle_probe=nil;return
 end
 local motion=call(GS.game_object_field,session,avatar,'motion_enabled')
 local rotation=call(GS.game_object_field,session,avatar,'rotation_enabled')
 local where=call(GS.game_object_field,session,avatar,'gls4w9b')
 local state=call(GS.game_object_field,session,avatar,'state')
 local keep_seated=Lua51.observe_entry(session,avatar,owned_ids,set,motion,rotation,where,state)
 local explicit_exit=(motion==true and not keep_seated) or where==30 or state==2
 local seated_now=keep_seated or (motion==false and where==100 and state==0)
 local missing=motion==nil or rotation==nil
 if not explicit_exit and missing and M.seated then
  M.seat_unknown_since=M.seat_unknown_since or M.clock;seated_now=true
 else M.seat_unknown_since=nil end
 local entry_relation
 if not seated_now and not explicit_exit and missing and not M.seated and M.clock>=(M.next_seat_probe or 0) then
  M.next_seat_probe=M.clock+.1
  local candidate=Native.relation(avatar,M.clock)
  if candidate and candidate.status=='VEHICLE' then seated_now=true;entry_relation=candidate end
 end
 if explicit_exit then M.next_seat_probe=nil end
 if not seated_now then
  local was=M.seated
  if was then log('HUD_EXIT avatar='..avatar) end
  settle_idle()
  M.preseat_owned=set
  if explicit_exit then schedule_idle_probe() else M.next_idle_probe=nil end
  return
 end
 M.idle_settled=nil;M.next_idle_probe=nil
 if not M.seated then
  M.seated=true;M.hull=nil;M.vehicle_ref=nil;M.bind_retry=0;M.bind_weak=false;M.seat_enter_frame=M.frame;M.seat_enter_time=M.clock
  M.pending_bind=nil;M.seat_hint=nil;M.next_bind=0;M.ownership=nil;M.seat_scan=nil;M.entry_new_seen={};M.entry_owned_cursor=1
  FRV.reset();clear_values();log('HUD_ENTER avatar='..avatar)
 end
 local mode=FRV.poll(session,avatar,entry_relation)
 if mode=='LEGACY' then
  if M.clock>=(M.next_bind or 0) then M.next_bind=M.clock+(M.hull and 0.5 or 0.2);bind_current_vehicle(session,avatar,owned_ids) end
  refresh_bound(session,set)
 elseif mode=='TANK' and not FRV.grace_until then refresh_bound(session,set) end
 FRV.tick_occupancy(session,avatar) -- Independent 20 Hz channel; optional icons are isolated.
 local show_frv=mode=='FRV' and FRV.vehicle~=nil
 if not show_frv and not M.hull then clear();return end
 if not ensure_gui(worlds,world) then return end
 if sr.Window and call(sr.Window.show_cursor)==true then clear();return end
 local w,h=call(App.back_buffer_size)
 if type(w)~='number' or type(h)~='number' or w<=0 or h<=0 then return end
 render_view(show_frv and 'FRV' or 'TANK',w,h)
end
-- Diagnostics attachment API 1. No clocks, counters, reports or per-frame
-- event dispatch without an attached addon. Only the listed function slots
-- are wrapped, at registration time; their originals are restored on detach.
-- Callbacks receive scalar metadata, never game objects or mutable HUD state.
local diagnostic_owner
local diagnostic_shutdown=false
local function diagnostic_mode()
 return not M.seated and 'ON_FOOT' or (FRV.mode=='FRV' and 'FRV' or (M.hull and 'TANK' or 'PENDING'))
end
local function diagnostic_table_slot(name,object,key)
 return {name=name,get=function()return object[key]end,set=function(f)object[key]=f end}
end
local diagnostic_slots={
 {name='update',get=function()return update end,set=function(f)update=f end},
 {name='render',get=function()return render_view end,set=function(f)render_view=f end},
 {name='tank_telemetry',get=function()return refresh_bound end,set=function(f)refresh_bound=f end},
 diagnostic_table_slot('vehicle_poll',FRV,'poll'),
 diagnostic_table_slot('seats_icons',FRV,'tick_occupancy'),
 diagnostic_table_slot('native_relation',Native,'relation'),
 diagnostic_table_slot('native_health',Native,'health'),
 diagnostic_table_slot('native_occupancy',Native,'frv_occupancy'),
 diagnostic_table_slot('native_slot3',Native,'frv_slot3'),
 diagnostic_table_slot('native_weapon',Native,'weapon'),
 diagnostic_table_slot('native_proxy',Native,'resolve_proxy')
}
local function detach_diagnostics(reason)
 local owner=diagnostic_owner
 if not owner then return false end
 diagnostic_owner=nil;owner.active=false
 for _,slot in ipairs(owner.slots) do
  -- Do not overwrite a later third-party wrapper. Ours becomes inert if it is
  -- still referenced by that wrapper. No other mod's update chain is changed.
  if slot.target.get()==slot.wrapper then slot.target.set(slot.original) end
 end
 if owner.detached and not owner.notifying then
  owner.notifying=true;pcall(owner.detached,reason or 'detached');owner.notifying=false
 end
 return true
end
local function diagnostic_notify(owner,fn,...)
 if not owner.active or owner.notifying then return false end
 owner.notifying=true
 local ok,value=pcall(fn,...)
 owner.notifying=false
 if not ok then
  detach_diagnostics('callback_error')
  pcall(log,'HUD_DIAGNOSTICS detached=callback_error hud_continues=true')
 end
 return ok,value
end
local function diagnostic_completed(owner,slot,token,ok,...)
 local first=select(1,...);local reads,bytes
 if ok and type(first)=='table' then
  reads=rawget(first,'calls');bytes=rawget(first,'bytes')
  if type(reads)~='number' or reads~=reads or reads<0 or reads==math.huge then reads=nil end
  if type(bytes)~='number' or bytes~=bytes or bytes<0 or bytes==math.huge then bytes=nil end
 end
 if owner.active then
  diagnostic_notify(owner,owner.after,token,slot.name,diagnostic_mode(),M.clock,
   ok,ok and first~=nil,reads,bytes)
 end
 -- Exact return arity including trailing nils. A HUD error is propagated once,
 -- not swallowed or retried by diagnostics; the existing HUD recovery owns it.
 if not ok then error(first,0) end
 return ...
end
local function register_diagnostics(spec)
 if diagnostic_shutdown then return false,'HUD has shut down' end
 if diagnostic_owner then return false,'a diagnostics addon is already attached' end
 if type(spec)~='table' or getmetatable(spec)~=nil or spec.api~=1
  or type(spec.id)~='string' or #spec.id<1 or #spec.id>64 or not spec.id:match('^[%w_.%-]+$')
  or type(spec.before)~='function' or type(spec.after)~='function'
  or (spec.attached~=nil and type(spec.attached)~='function')
  or (spec.detached~=nil and type(spec.detached)~='function') then return false,'invalid diagnostics addon' end
 local owner={id=spec.id,before=spec.before,after=spec.after,attached=spec.attached,detached=spec.detached,slots={}}
 -- Stage every closure before changing dispatch. Registration does not call any
 -- native reader, change sampling deadlines, or create GUI resources.
 for _,target in ipairs(diagnostic_slots) do
  local original=target.get()
  if type(original)~='function' then return false,'diagnostics target unavailable: '..target.name end
  local slot={target=target,name=target.name,original=original}
  slot.wrapper=function(...)
   if not owner.active or owner.notifying then return original(...) end
   local good,token=diagnostic_notify(owner,owner.before,slot.name,diagnostic_mode(),M.clock)
   if not good or not owner.active then return original(...) end
   return diagnostic_completed(owner,slot,token,pcall(original,...))
  end
  owner.slots[#owner.slots+1]=slot
 end
 owner.active=true;diagnostic_owner=owner
 for _,slot in ipairs(owner.slots) do slot.target.set(slot.wrapper) end
 if owner.attached then
  local ok=diagnostic_notify(owner,owner.attached,'1.6',1)
  if not ok or not owner.active then return false,'diagnostics startup failed' end
 end
 return true
end
local function install_diagnostics_api()
 local api=rawget(_G,'DriverHUD')
 if type(api)~='table' then return end
 api.diagnostics_api=1
 function api.register_diagnostics(spec)
  local ok,accepted,why=pcall(register_diagnostics,spec)
  if not ok then detach_diagnostics('registration_error');return false,'diagnostics registration error' end
  return accepted,why
 end
 function api.unregister_diagnostics(id)
  if not diagnostic_owner or diagnostic_owner.id~=id then return false end
  return detach_diagnostics('requested')
 end
 local key='__DRIVER_HUD_DIAGNOSTICS_PENDING_V1'
 local pending=rawget(_G,key)
 if pending~=nil then
  rawset(_G,key,nil)
  local accepted,why=api.register_diagnostics(pending)
  if not accepted then pcall(log,'HUD_DIAGNOSTICS rejected='..tostring(why)) end
 end
end

local old=rawget(_G,'update');if type(old)~='function' then return {installed=false} end
rawset(_G,'__DRIVER_HUD_INSTALLED',true)
FRV.install_extension_api()
install_diagnostics_api()
local retry_at=0
rawset(_G,'update',function(...)
 if M.clock>=retry_at then
  local ok,err=pcall(update,...)
  pcall(Lua51.report,false)
  if not ok then
   retry_at=M.clock+1;log('HUD_RECOVERABLE_ERROR retaining_display=true '..tostring(err))
  end
 else
  -- Keep the retry clock moving without running failed rendering/native work.
  local dt=select(1,...)
  M.clock=M.clock+(type(dt)=='number' and dt==dt and math.max(0,math.min(0.25,dt)) or 0.016667)
 end
 return old(...)
end)
local stop=rawget(_G,'shutdown')
rawset(_G,'shutdown',function(...)
 log('LUA51_SHUTDOWN');Lua51.report(true)
 diagnostic_shutdown=true;detach_diagnostics('shutdown')
 pcall(surface_reset,call(App.worlds) or {});pcall(full_reset)
 if type(stop)=='function' then return stop(...) end
end)
return {installed=true}
