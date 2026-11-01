
-- Integrated HUD frame coordinator. NarrowHUD's picker/normaliser remain above.
local next_scan,next_read,shown,world_seen=0,0,nil,nil
local check_i,checked=1,false
local avatar_seen=nil
if chef.weapon_menu_down then N.keys.weapon_menu={down=chef.weapon_menu_down}end
local function wipe(t)for k in pairs(t)do t[k]=nil end end
local function reset_world()
 for _,t in ipairs({N.objs,N.queue,N.queue_2,N.queue_b,N.checked,N.pack_vals,N.distrust,N.av_refs,N.av_said})do wipe(t)end
 N.me.player,N.me.avatar=nil,nil
 wipe(N.hand);N.swap.used,N.swap.from=true,nil
 N.seat.goid,N.seat.gun,N.seat.pose_since=nil,nil,nil
 N.pack_prev=nil;shown=nil;next_scan=0;next_read=0
 avatar_seen=nil
end
function M.avatar()return avatar_seen end
function M.player()return N.me.player end
function M.inspect()return N end -- Basic offline verification only.
function M.update()
 local now=chef.time();N.now=now;N.frame=N.frame+1
 if N.dirty_at and now>=N.dirty_at then N.dirty_at=nil;N.save_learned()end
 if N.game_build.known==false then return nil,'UNSUPPORTED BUILD'end
 local wid=chef.world_id()
 if wid~=world_seen then reset_world();world_seen=wid end
 if not chef.in_mission()then shown=nil;return nil,'NO MISSION'end
 local s,peer=N.call('session','Network.game_session'),N.call('peer','Network.peer_id')
 if s==nil or peer==nil then shown=nil;return nil,'WAIT SESSION'end
 -- Refuse types whose live field declaration does not match the supplied data.
 if not checked then
  for _=1,25 do
   local t=N.TYPES[check_i]
   if not t then checked=true;break end
   local fields=N.live_fields(t.name);local ok=fields~=nil
   if ok then for role in pairs(t.has)do
    if N.ROLE[role]and not fields[N.norm_id(N.ROLE[role].id)]then ok=false end
   end end
   t.gone=not ok;check_i=check_i+1
  end
  return nil,'CHECK FIELDS'
 end
 N.blocked.since=N.blocked.since or now
 N.classify(s)
 if now>=next_scan then next_scan=now+1;N.scan(s,peer)end
 -- A life can change without a new world. Resolve the player->avatar link
 -- before any pose, unit position, weapon learning or retained heat work.
 local p=N.me.player
 local a=nil
 if p~=nil and N.call('player.exists','GameSession.game_object_exists',s,p)==true
  and N.call('player.type','GameSession.game_object_is_type',s,p,N.TYPES[1].name)==true then
  local id=N.call('player.avatar','GameSession.game_object_field',s,p,DATA.player.avatar)
  if type(id)=='number'and id>0 and id<N.NO_OBJECT and id==math.floor(id)
   and N.call('avatar.exists','GameSession.game_object_exists',s,id)==true
   and N.call('avatar.type','GameSession.game_object_is_type',s,id,N.TYPES[2].name)==true then
   local where=N.call('avatar.where','GameSession.game_object_field',s,id,'gls4w9b')
   local state=N.call('avatar.state','GameSession.game_object_field',s,id,'state')
   if where==100 and state==0 then a=id end
  end
 end
 if avatar_seen~=nil and a~=avatar_seen then
  avatar_seen=nil;shown=nil
  -- The host replaces this sensor, including private animation/learning caches.
  return nil,'AVATAR CHANGE'
 end
 avatar_seen=a;N.me.avatar=a
 if not a then shown=nil;return nil,'NO AVATAR'end
 N.read_fire_button(now);N.read_swap(now)
 if now>=next_read then
  next_read=now+.1
  N.read_av_refs(s)
  local grip=N.hand_pose(s);N.watch_fire(s,grip)
  local goid=N.pick(s,grip,now)
  local hand=N.hand;local old=hand.goid and N.objs[hand.goid]
  -- Original short movement grace; no motion_enabled/seat-based HUD gate.
  if not goid and grip~=nil and not N.THROWABLE[grip]and old and old.t and old.on and not old.notmine
     and now-(N.swap.at or -100)>1 then
   hand.lost_at=hand.lost_at or now
   if now-hand.lost_at<2 then goid=hand.goid end
  elseif goid then hand.lost_at=nil end
  hand.goid,hand.grip=goid,grip
  local o=goid and N.objs[goid];local t=o and o.t and N.TYPES[o.t]
  local w=t and N.read_weapon(s,goid,t)
  shown=w and not w.gone and N.shown(s,goid,t,w,o)or nil
  if shown then
   shown.raw_fire_mode=w.fire_mode
   if not shown.kind then shown=nil end
  end
 end
 local d=shown
 if d and not N.alive(s,d.goid0,d.t0)then shown=nil;return nil,'GONE'end
 if d and d.kind=='heat'and d.o and d.o.h_last and not d.charge_anim then N.heat_model(s,d,now)
 elseif d and d.kind=='heat'and d.charge_anim and d.o and d.o.charge_t0 then
  local h=d.charge_from+(d.top_raw-d.charge_from)*math.min(1,(now-d.o.charge_t0)/d.charge_secs)
  d.value=math.max(0,h-d.rest)
 end
 return d,d and'READY'or'IDENTIFY'
end
function M.shutdown()N.save_learned();reset_world()end
return M
