-- Integrated HUD weapon-only update; the association and normalisation above
-- are derived from NarrowHUD. No stims, grenades, independent pack HUD or UI.
local next_scan,next_read,shown_now=0,0,nil
local check_i,check_ready=1,false
-- Fire input still guards ownership learning. Swap inputs are deliberately
-- unused: a requested swap is not evidence the game actually switched guns.
local input_at=nil
function M.capture_input(now)
  if input_at==now then return end
  input_at=now
  read_fire_button(now)
end
function M.update()
  frame=frame+1
  local now=chef.time()
  if dirty_at and now>=dirty_at then dirty_at=nil;save_learned() end
  local s,peer=chef.session(),chef.peer()
  if not s or not peer then return nil end
  if not check_ready then
    for _=1,25 do
      local t=TYPES[check_i]
      if not t then check_ready=true;break end
      local set=live_fields(t.name)
      local valid=set~=nil
      if valid then for role in pairs(t.has) do
        if ROLE[role] and not set[norm_id(ROLE[role].id)] then valid=false end
      end end
      t.gone=not valid
      check_i=check_i+1
    end
    return nil
  end
  blocked.since=blocked.since or now
  if now>=next_scan then next_scan=now+1;scan(s,peer) end
  classify(s)
  M.capture_input(now)
  if now>=next_read then
    next_read=now+0.1
    local grip=hand_pose()
    watch_fire(s,grip)
    -- Reconcile actual hand evidence every 0.1 s, independent of swap keys.
    -- Several weapons can share weapon_selected, so pose alone is not enough.
    local goid,source=nil,'unresolved'
    if grip and grip~=0 and not THROWABLE[grip] then
      local eligible,hashes={},{}
      for id,item in pairs(objs) do
        local t=item.t and TYPES[item.t]
        if t and HANDHELD[t.id] and not t.pack and not t.other and item.on
          and not item.ub and not item.notmine and alive(s,id,t) then
          eligible[#eligible+1]={id=id,item=item,t=t};hashes[#hashes+1]=t.id
        end
      end
      local evidence=chef.hand_models and chef.hand_models(hashes) or {}
      evidence=evidence or {}
      local matches,possible,ambiguous={},{},false
      for _,e in ipairs(eligible) do
        local state=evidence[e.t.id]
        if state=='ambiguous' then ambiguous=true
        elseif state==true then matches[#matches+1]=e
        elseif state~=false and has_pose(e.t.id,grip) then possible[#possible+1]=e end
      end
      local chosen
      if not ambiguous and #matches==1 then chosen=matches[1];source='hand_model'
      elseif not ambiguous and #matches==0 and #possible==1 then chosen=possible[1];source='pose_and_model_exclusion' end
      if chosen then
        goid=chosen.id
        if source=='hand_model' then
          chosen.item.mine=true;add_pose(chosen.t.id,grip)
        end
      else source='ambiguous_hand' end
    end
    if M.hand_id~=goid or M.hand_source~=source then
      M.hand_id,M.hand_source=goid,source
      log('HAND_CHECK object=%s source=%s pose=%s',tostring(goid),source,tostring(grip))
    end
    if goid then M.wait_reason=nil
    else M.wait_reason='pose='..tostring(grip)..' hand='..source..' queued='..tostring(#queue+#queue_2) end
    hand.goid,hand.grip=goid,grip
    local o=goid and objs[goid]
    shown_now=o and o.t and shown(s,goid,TYPES[o.t],o.prev or read_weapon(s,goid,TYPES[o.t]),o) or nil
    if shown_now and not shown_now.kind then shown_now=nil end
  end
  local d=shown_now
  if d and not alive(s,d.goid0,d.t0) then shown_now=nil;return nil end
  if d and d.kind=='heat' and d.o and d.o.h_last and not d.charge_anim then
    local o=d.o
    local held
    if d.t.has.held and learned.charge2[d.tid]==nil then held=field(s,d.goid,d.t,'held')==true
    else held=o.firing==true end
    local dt=math.min(0.1,now-(o.sim_t or now));o.sim_t=now
    if o.sim==nil then o.sim,o.err,o.sim_seen=o.h_last,0,o.h_last_t
    else
      local rate=held and heat_rate('up',d.tid) or (not held and heat_rate('down',d.tid) and -heat_rate('down',d.tid)) or 0
      o.sim=o.sim+rate*dt
      if o.sim_seen~=o.h_last_t then o.sim_seen=o.h_last_t;o.err=o.h_last-o.sim end
      local take=(o.err or 0)*math.min(1,dt/0.25)
      o.sim,o.err=o.sim+take,(o.err or 0)-take
    end
    o.sim=math.max(0,math.min(d.top_raw,o.sim));d.value=math.max(0,o.sim-d.rest)
  elseif d and d.o then d.o.sim=nil end
  if d and d.kind=='heat' and d.charge_anim and d.o and d.o.charge_t0 then
    local h=d.charge_from+(d.top_raw-d.charge_from)*math.min(1,(now-d.o.charge_t0)/d.charge_secs)
    d.value=math.max(0,h-d.rest)
  end
  return d
end
function M.flush() save_learned() end
