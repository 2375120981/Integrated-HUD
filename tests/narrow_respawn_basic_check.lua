-- One life transition and invalid-node workflow, without game/native access.
local BASE='mods/integrated_hud/mdl_gamesession/'
local now,avatar,state,exists,pose=0,10,0,true,0
local N
local host={time=function()return now end,world_id=function()return 'world'end,
 in_mission=function()return true end,log=function()end,player_unit=function()return nil end,
 call=function()return nil end,call_kind=function(name,kind,s,id,key)
  if name=='Network.game_session'then return 1 end
  if name=='Network.peer_id'then return 0 end
  if name=='Network.object_info'then
   local fields={};for _,r in pairs(N.ROLE)do fields[#fields+1]={id=r.id}end
   return {fields=fields}
  end
  if name=='GameSession.game_object_exists'then return id==0 or(id==avatar and exists)end
  if name=='GameSession.game_object_is_type'then return true end
  if name=='GameSession.game_object_field'then
   if id==0 then return avatar end
   assert(exists,'field read against destroyed avatar')
   if key=='gls4w9b'then return 100 end
   if key=='state'then return state end
  end
 end}
local sensor=assert(loadstring(SOURCES[BASE..'sensor']))()(host);N=sensor.inspect()
N.scan=function()N.me.player=0 end;N.classify=function()end
N.hand_pose=function()pose=pose+1;return 1 end
N.watch_fire=function()end;N.read_av_refs=function()end
N.read_fire_button=function()end;N.read_swap=function()end;N.pick=function()return nil end
for _=1,20 do now=now+.11;sensor.update()end
assert(pose>0 and sensor.avatar()==10,'live avatar not recognised')
local before=pose;state=2;now=now+.01
local _,status=sensor.update()
assert(status=='AVATAR CHANGE'and pose==before,'death continued pose reads between 0.1s polls')
exists=false;now=now+.11;sensor.update();assert(pose==before,'destroyed avatar reached pose reads')
avatar=20;exists=true;state=0;now=now+.11;sensor.update()
assert(pose>before and sensor.avatar()==20,'new avatar discovery blocked by old death state')
before=pose;avatar=30;now=now+.01;_,status=sensor.update()
assert(status=='AVATAR CHANGE'and pose==before,'direct avatar replacement used an old pose')

-- Exercise the real host: membership/type/node checks before native vectors.
local nodes,reference,position_reads,unit_reads=1,10,0,0
local sensor_count,shutdowns,change=0,0,false
local weapon_data=nil
local world='world';local field_ok=true;local bound_avatar=10
local E={Application={},Network={},GameSession={},Unit={},World={},IdString64={},Vector3={}}
E.Application.main_world=function()return world end
E.Application.worlds=function()return {world}end
E.Network.game_session=function()return 1 end;E.Network.peer_id=function()return 0 end
E.GameSession.in_session=function()return true end
E.GameSession.game_object_exists=function(_,id)return id==0 or(id==bound_avatar and field_ok)end
E.GameSession.game_object_is_type=function()return true end
E.GameSession.game_object_field=function(_,id,key)
 if id==0 then return reference end
 if key=='gls4w9b'then return 100 elseif key=='state'then return 0 end
 if key=='position'then assert(field_ok);position_reads=position_reads+1;return 0 end
end
E.IdString64.from_hex=function(s)return s end
E.World.units_by_resource=function()return {'unit'}end
E.Unit.alive=function()return true end
E.Unit.has_animation_state_machine=function()return true end
E.Unit.num_scene_graph_items=function()return nodes end
E.Unit.world_position=function()assert(nodes>=2,'invalid node passed to engine');unit_reads=unit_reads+1;return 0 end
E.Vector3.distance=function()return 0 end
local env=setmetatable({os={getenv=function()return nil end}},{__index=_G})
env.require=function(name)
 assert(name==BASE..'sensor')
 return function(h)
  sensor_count=sensor_count+1
  return {avatar=function()return bound_avatar end,player=function()return 0 end,
   update=function()
    if change then change=false;return nil,'AVATAR CHANGE'end
    if weapon_data then return weapon_data,'READY'end
    h.player_unit();return nil,'IDENTIFY'
   end,shutdown=function()shutdowns=shutdowns+1 end}
 end
end
local chunk=assert(loadstring(SOURCES[BASE..'reader']));setfenv(chunk,env)
local reader=chunk().new(E,function()end)
reader.read(1);assert(unit_reads==0,'node count guard missing')
nodes=2;reader.read(1.2);assert(unit_reads==1,'valid model position was blocked')
local p,u=position_reads,unit_reads
field_ok=false;reader.read(1.4)
assert(position_reads==p and unit_reads==u,'old avatar position reached engine')
field_ok=true;reference=20;reader.read(1.6)
assert(position_reads==p and unit_reads==u,'player link mismatch read old position')
reference=10;change=true;local made=sensor_count
reader.read(1.61);assert(sensor_count==made+1 and shutdowns==1,'life transition retained sensor caches')
-- The real host must pass only VG-70's special firing patterns to drawing.
weapon_data={tid='cfaa9ddc',goid0=100,kind='ammo',value=43,top=49,reserve=3}
for raw,expected in pairs({[1]='AUTO',[4]='VOLLEY',[7]='TOTAL'})do
 weapon_data.raw_fire_mode=raw
 local v=reader.read(1.62)
 assert(v.mode==expected and v.rounds==43 and v.mags==3,'VG-70 pattern not refreshed')
end
for _,raw in ipairs({0,2,3,9,-1,1.5,math.huge})do
 weapon_data.raw_fire_mode=raw;assert(reader.read(1.63).mode=='','invalid VG-70 mode shown')
end
weapon_data.tid='b697955d';weapon_data.raw_fire_mode=1;weapon_data.fmode='AUTO'
assert(reader.read(1.64).mode=='','ordinary auto selector became visible')
weapon_data.mode='APHET';assert(reader.read(1.65).mode=='APHET','existing function mode lost')
weapon_data=nil
world='new_world';made=sensor_count;reader.read(1.8)
assert(sensor_count==made+1,'world change retained old unit context')
reader.shutdown()
return {death_stops_pose=true,missing_avatar_blocks_reads=true,respawn_recovers=true,
 direct_avatar_change=true,position_node_guard=true,player_link_rechecked=true,
 sensor_recreated_on_life_change=true,world_context_reset=true,vg70_firing_patterns=true}
