-- One bounded original-core workflow. No appdata IO or game process access.
local sr={Application={},Network={},GameSession={},World={},Gui={}}
local A,N,G,W,Q=sr.Application,sr.Network,sr.GameSession,sr.World,sr.Gui
sr.Vector2=function(...)return {...}end;sr.Vector3=function(...)return {...}end;sr.Color=function(...)return {...}end
sr.Window={show_cursor=function()return false end}
local world_main,world_overlay='simulation','overlay'
A.worlds=function()return {world_main,world_overlay}end;A.main_world=function()return world_main end
A.back_buffer_size=function()return 1920,1080 end
N.game_session=function()return 1 end;N.peer_id=function()return 0 end
local native={batch=0,field=0,owned=0};local per_id={}
local measurements={}
local motion=true;local types={[0]='un6y1d',[10]='gl7xl2w',[100]='3LHk6DNB'}
local fields={[10]={[64]={[25]=32767}},[100]={[10]=2400,[15]=127,[20]={},[24]=2400,[25]=255,[52]=0}}
G.in_session=function()return true end;G.objects_owned_by=function()native.owned=native.owned+1;return {0,10,100}end
G.game_object_exists=function(_,id)return types[id]~=nil end
G.game_object_is_type=function(_,id,t)return types[id]==t end
G.game_object_field=function(_,id,key)
 native.field=native.field+1
 if id==0 and key=='baegche'then return 10 end
 if id==10 then if key=='motion_enabled'then return motion elseif key=='rotation_enabled'then return true
  elseif key=='gls4w9b'then return 100 elseif key=='state'then return 0 end end
end
G.game_object_field_batched=function(_,id)native.batch=native.batch+1;per_id[id]=(per_id[id]or 0)+1;return fields[id]end
-- Use the declaration carried by the original core, not our previous adapter.
local declaration=assert(CORE_SOURCE:match('%["9b2140378640432e"%]=%{name="supply_frv",t="3LHk6DNB",fields=%{([^}]+)%}'))
N.object_info=function(t)
 if t=='3LHk6DNB'then local f={};for h in declaration:gmatch('"([0-9a-f]+)"')do f[#f+1]={id=h}end;return {fields=f}end
end
local pools={};local serial,created,destroyed=0,0,0;local gui_world
W.create_screen_gui=function(world,option,x,y)
 assert(option=='scale'and x==1 and y==1);gui_world=world;local gui={};pools[gui]={};return gui
end
W.destroy_gui=function(world,gui)assert(pools[gui]);pools[gui]=nil end
Q.triangle=function(gui,a,b,c,z,color,material,...)
 assert(pools[gui]and material=='mods/driver_hud/solid');serial=serial+1;pools[gui][serial]={a,b,c,color};created=created+1;return serial
end
Q.destroy_triangle=function(gui,id)assert(pools[gui]and pools[gui][id]);pools[gui][id]=nil;destroyed=destroyed+1 end
local env
env=setmetatable({stingray=sr,os={getenv=function()return nil end},io={},update=function()end,shutdown=function()end,
 require=function(name)
  if MECH_STYLE_SOURCE and name=='mods/integrated_hud/driver_reference/mech_style_data'then return assert(loadstring(MECH_STYLE_SOURCE))()end
  if MECH_BINDING_SOURCE and name=='mods/integrated_hud/driver_reference/mech_binding'then
   local module=assert(loadstring(MECH_BINDING_SOURCE));setfenv(module,env);return module()
  end
  if MECH_SOURCE and name=='mods/integrated_hud/driver_reference/mech_trace'then
   local module=assert(loadstring(MECH_SOURCE));setfenv(module,env);return module()
  end
  assert(STYLE_SOURCE and name=='mods/integrated_hud/driver_reference/own_style_data','unexpected require')
  return assert(loadstring(STYLE_SOURCE))()
 end},{__index=_G})
env._G=env
local f=assert(loadstring(CORE_SOURCE,'@original_driver_core'));setfenv(f,env)
local result=f();assert(result.installed and env.__DRIVER_HUD_INSTALLED)
for _=1,30 do env.update(.1)end
motion=false;fields[100][15]=119
for _=1,30 do env.update(.1)end
assert(gui_world==world_overlay,'original non-main-world GUI selection not exercised')
assert(created>0,'original FRV renderer did not create geometry')
local before=created
for _=1,20 do env.update(.1)end
assert(created==before,'unchanged original FRV unexpectedly rebuilt')
fields[100][24]=1200
for _=1,5 do env.update(.1)end
assert(created>before and destroyed>0,'original health change did not replace geometry')
motion=true;fields[100][15]=127
for _=1,10 do env.update(.1)end
for _,pool in pairs(pools)do assert(next(pool)==nil,'original exit did not clear geometry')end
-- Reproduce both captured no-direct-reference supply-FRV rear entries.
for _,rear_mask in ipairs({126,125})do
 fields[100][15]=127;motion=true
 for _=1,12 do env.update(.1)end
 fields[100][15]=rear_mask;motion=false
 for _=1,15 do env.update(.1)end
 local active,self_color=0,false
 for _,pool in pairs(pools)do for _,tri in pairs(pool)do
  active=active+1
  if tri[4][2]==255 and tri[4][3]==145 and tri[4][4]==48 then self_color=true end
 end end
 assert(active>0 and self_color,'captured supply FRV rear entry or local seat highlight failed')
 motion=true;fields[100][15]=127
 for _=1,10 do env.update(.1)end
 for _,pool in pairs(pools)do assert(next(pool)==nil,'supply rear exit did not clear')end
end
if STYLE_SOURCE then
 -- The styled tank still uses the original core's binding, GUI and cleanup.
 types[298]='rHVbvgIu';types[299]='fZwFCDKT';types[300]='tank'
 fields[300]={[15]=8000,[22]=14,[30]=8000,[56]={298,299}}
 fields[10][64][25]=300
 G.objects_owned_by=function()native.owned=native.owned+1;return {0,10,298,299}end
 motion=false
 for _=1,30 do env.update(.1)end
 local active=0;local self_color=false
 for _,pool in pairs(pools)do for _,tri in pairs(pool)do
  active=active+1
  for i=1,3 do local p=tri[i]
   assert(p[1]>=1300 and p[1]<=1440 and p[3]>=15 and p[3]<=200,'tank is outside the FRV anchor or emitted old geometry')
  end
  if tri[4][2]==255 and tri[4][3]==145 and tri[4][4]==48 then self_color=true end
 end end
 assert(active>100 and self_color,'tank shape or local seat absent')
 local weapon_before=(per_id[298]or 0)+(per_id[299]or 0)
 before=created;for _=1,10 do env.update(.1)end;assert(created==before,'unchanged styled tank rebuilt')
 measurements.metric_old_tank_steady_weapon_batches=(per_id[298]or 0)+(per_id[299]or 0)-weapon_before
 if PERF_EXPECTED then assert(measurements.metric_old_tank_steady_weapon_batches==0,'unused old tank weapons still sampled')end
 fields[300][22]=13;fields[300][30]=4000
 for _=1,10 do env.update(.1)end;assert(created>before,'styled tank seat/health change failed')
 motion=true;fields[300][22]=15
 for _=1,10 do env.update(.1)end
 for _,pool in pairs(pools)do assert(next(pool)==nil,'styled tank exit did not clear')end
end
-- A fresh five-child tank with no avatar reference and no legacy weapon
-- types must bind on its first gunner entry, before visiting any other seat.
if MECH_BINDING_SOURCE then
 local children={681,684,686,690,696}
 for _,id in ipairs(children)do types[id]='new_tank_child';fields[id]={}end
 types[700]='new_tank_hull'
 fields[700]={[15]=8000,[22]=15,[30]=8000,[56]=children}
 fields[10][64][25]=32767
 G.objects_owned_by=function()native.owned=native.owned+1;return {0,10,681,684,686,690,696,700}end
 motion=true
 for _=1,20 do env.update(.1)end
 for _,pool in pairs(pools)do assert(next(pool)==nil,'tank discovery displayed while walking')end
 fields[700][22]=13;motion=false
 for _=1,20 do env.update(.1)end
 local active,self_color=0,false
 for _,pool in pairs(pools)do for _,tri in pairs(pool)do
  active=active+1
  if tri[4][2]==255 and tri[4][3]==145 and tri[4][4]==48 then self_color=true end
 end end
 assert(active>100 and self_color,'fresh tank gunner entry needs previous seat visit')
 local weapon_before=0;for _,id in ipairs(children)do weapon_before=weapon_before+(per_id[id]or 0)end
 for _=1,10 do env.update(.1)end
 local after=0;for _,id in ipairs(children)do after=after+(per_id[id]or 0)end
 measurements.metric_new_tank_steady_child_batches=after-weapon_before
 if PERF_EXPECTED then assert(after==weapon_before,'unused new tank children still sampled')end
 -- Health and destruction still have to work without weapon/variant updates.
 fields[700][30]=4000;before=created
 for _=1,5 do env.update(.1)end;assert(created>before,'optimized tank health did not redraw')
 fields[700][30]=0
 for _=1,5 do env.update(.1)end
 for _,pool in pairs(pools)do assert(next(pool)==nil,'zero-health tank remained visible')end
 motion=true;fields[700][22]=15
 for _=1,10 do env.update(.1)end
 for _,pool in pairs(pools)do assert(next(pool)==nil,'fresh tank gunner exit did not clear')end
end
if MECH_BINDING_SOURCE then
 types[498]='arm';types[499]='arm';types[500]='mech';fields[498]={};fields[499]={}
 fields[500]={[19]={[3]=6000,[6]={498,499}},[27]=10,[28]='position',[56]=1800,[65]=1800,[76]=3}
 fields[10][64][25]=32767;G.objects_owned_by=function()native.owned=native.owned+1;return {0,10,498,499,500}end
 -- Exercise the real original-core idle hook before entry, no walking GUI.
 for _=1,10 do env.update(.1)end
 for _,pool in pairs(pools)do assert(next(pool)==nil,'prewarm drew while walking')end
 motion=false
 for _=1,6 do env.update(.1)end
 local active=0;for _,pool in pairs(pools)do for _,tri in pairs(pool)do
  active=active+1
  for i=1,3 do assert(tri[i][1]>1270 and tri[i][1]<1470 and tri[i][3]>=0 and tri[i][3]<210,'mech outside shared vehicle anchor')end
 end end
 assert(active>100 and active<500,'whole mech did not render or unexpected module geometry')
 local owned_before,field_before=native.owned,native.field
 before=created;for _=1,10 do env.update(.1)end;assert(created==before,'stable whole mech rebuilt')
 measurements.metric_mech_steady_owned_calls=native.owned-owned_before
 measurements.metric_mech_steady_field_calls=native.field-field_before
 if PERF_EXPECTED then assert(native.owned-owned_before<=5,'mech ownership cache not used')end
 fields[500][56]=1170;for _=1,5 do env.update(.1)end;assert(created>before,'mech total health redraw failed')
 motion=true;for _=1,10 do env.update(.1)end
 for _,pool in pairs(pools)do assert(next(pool)==nil,'mech exit did not clear')end
end
env.shutdown()
local checks={original_core_attaches=true,original_non_main_world_selected=true,original_frv_draws=true,
 original_cache_reuses_primitives=true,original_health_redraw=true,original_exit_clears=true,captured_supply_rear_entries_and_local_highlight=true,final_tank_style=STYLE_SOURCE~=nil,
 whole_mech_view=MECH_BINDING_SOURCE~=nil,fresh_five_child_tank_first_gunner_entry=MECH_BINDING_SOURCE~=nil}

for k,v in pairs(measurements)do checks[k]=v end
return checks
