-- Integrated HUD weapon-only update; the association and normalisation above
-- are derived from NarrowHUD. No stims, grenades, independent pack HUD or UI.
local next_scan,next_read,shown_now=0,0,nil
local check_i,check_ready=1,false
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
  read_fire_button(now);read_swap(now)
  if now>=next_read then
    next_read=now+0.1
    local grip=hand_pose()
    watch_fire(s,grip)
    local goid=pick(s,grip,now)
    if goid==nil and grip and grip~=0 and not THROWABLE[grip] and chef.held_type then
      local h=chef.held_type(grip)
      if h then
        local candidate,count=nil,0
        for id,item in pairs(objs) do
          local t=item.t and TYPES[item.t]
          if t and t.id==h and item.on and not item.ub and alive(s,id,t) then
            candidate=id;count=count+1
          end
        end
        if count==1 then
          local item=objs[candidate]
          item.notmine=nil;item.mine=true
          add_pose(h,grip)
          goid=candidate
          log('cold hand model confirmed: type %s pose %s object %s',h,tostring(grip),tostring(candidate))
        end
      end
    end
    M.wait_reason=goid and nil or ('pose='..tostring(grip)..' queued='..tostring(#queue+#queue_2))
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
