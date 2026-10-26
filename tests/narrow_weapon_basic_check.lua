local facts=assert(loadstring(WEAPON_DATA_SOURCE))()
local pistol,laser='1220e497','960653cb'
local rows={}
for line in facts.data.weapons:gmatch('[^\n]+') do
 if line:sub(1,8)==pistol or line:sub(1,8)==laser then rows[#rows+1]=line end
end
facts.data.weapons=table.concat(rows,'\n');facts.data.backpacks=''
facts.seed.poses[laser]=nil;facts.seed.grip[laser]=nil
facts.bootstrap={[laser]={resource='laser_model',offset=0}}
local role={};for k,v in pairs(facts.data.roles)do role[v.name]=k end
local selected=1
local states={
 [20]={rounds=5,magazines=3,chamber=false,fire_mode=2,carry=0,owner='peer',reload_stage=0,options=80,held=false},
 [21]={heat=6.6,magazines=2,fire_mode=1,carry=0,owner='peer',reload_stage=0,options=80,held=false,overheated=false,charging=false}}
local G,U,N,W={},{},{},{}
G.objects_owned_by=function()return {1,10,20,21}end
G.game_session_host=function()return 'peer'end
G.game_object_exists=function(_,id)return id==1 or id==10 or states[id]~=nil end
G.game_object_is_type=function(_,id,t)
 return (id==1 and t==facts.data.player.id) or (id==10 and t==facts.data.avatar.id)
  or (id==20 and t==pistol) or (id==21 and t==laser)
end
G.game_object_field=function(_,id,f)
 if id==1 and f==facts.data.player.avatar then return 10 end
 if id==10 and f=='position'then return 0 end
 return states[id] and states[id][role[f]]
end
N.object_info=function()
 local fields={};for _,r in pairs(facts.data.roles)do fields[#fields+1]={id=r.id}end
 return {fields=fields}
end
U.alive=function()return true end;U.num_scene_graph_items=function()return 2 end
U.world_position=function()return 0 end;U.has_animation_state_machine=function()return true end
U.animation_has_variable=function()return true end;U.animation_find_variable=function()return 0 end
U.animation_get_variable=function()return selected end
U.has_node=function()return true end;U.node=function()return 1 end
W.units_by_resource=function(_,r)
 if r=='4d1c334d294dfa97'then return {'body'}end
 if r=='laser_model'and selected==15 then return {'laser'}end
 return {}
end
local sr={GameSession=G,Unit=U,Network=N,World=W,IdString32={from_hex=function(v)return v end},
 IdString64={from_hex=function(v)return v end},Vector3={distance=function()return 0 end}}
local create=assert(loadstring(SENSOR_SOURCE))()
local cache_rows=nil
local env=setmetatable({io={open=function(_,mode)
 if mode~='r' or not cache_rows then return nil end
 return {lines=function()local n=0;return function()n=n+1;return cache_rows[n]end end,close=function()end}
end},require=function(name)
 assert(name=='mods/integrated_hud/driver_reference/narrowhud_weapon_sensor');return create
end},{__index=_G})
local chunk=assert(loadstring(WEAPON_SOURCE));setfenv(chunk,env)
local r=chunk().new(sr,facts,function()end)
local c={session=1,world='world',avatar=10,peer='peer',motion=true,where=100,state=0}
local t=0
local function step(n)
 local v
 for _=1,n or 1 do t=t+.11;v=r.update(t,c)end
 return v
end
local v=step(20)
assert(v and v.id==20 and v.rounds==6 and v.capacity==5 and v.mode=='SEMI','seeded pistol/chamber/fixed mode failed')
states[20].rounds=4;v=step();assert(v.rounds==5,'live chamber ammo failed')
states[20].fire_mode=5;v=step();assert(v.functional_status=='SAFE','functional safe mode was hidden')
states[20].fire_mode=6;v=step();assert(v.functional_status=='UNSAFE','functional unsafe mode was hidden')
states[20].fire_mode=2
states[20].reload_stage=1;v=step();assert(v.reloading,'reload not detected')
states[20].reload_stage=0;states[20].rounds=5;v=step();assert(not v.reloading and v.rounds==6,'reload completion failed')
selected=15;v=step(3);assert(v and v.id==21 and v.heat_ratio~=nil,'LAS-12 pose failed')
states[21].held=true;states[21].heat=50;v=step(6)
assert(v.heat_ratio>0 and v.heat_ratio<=1 and v.rounds==nil,'heat simulation failed')
c.motion=false;assert(step()==nil,'vehicle entry failed to hide weapon')
c.motion=true;c.world='world2';selected=1;v=step(20)
assert(v and v.id==20,'world ID reset failed')
-- First held LAS-12, no prelearned pose and no swap/fire input: a verified
-- hand model supplies association. This reproduces the cold-start gap.
r=chunk().new(sr,facts,function()end);selected=15;c.world='cold-laser'
states[21].heat=6.6;states[21].held=false
v=step(20);assert(v and v.id==21,'cold LAS-12 required a weapon swap')
-- Numeric-looking lists must survive data-only cache loading as strings.
cache_rows={'poses\t960653cb\t15','modes\t960653cb\t1','options1\t960653cb\t0'}
facts.bootstrap={};r=chunk().new(sr,facts,function()end);c.world='cached-laser'
v=step(20);assert(v and v.id==21,'single numeric pose was discarded by cache parser')
return {narrow_pistol_chamber_and_fixed_mode=true,narrow_live_ammo=true,narrow_reload_state=true,
 narrow_las12_heat=true,narrow_vehicle_hide=true,narrow_world_reset=true,
 narrow_las12_cold_hand_model=true,narrow_cache_numeric_strings_preserved=true}
