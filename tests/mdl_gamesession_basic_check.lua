-- Bounded checks: actual Narrow normalisation, managed UI and vehicle isolation.
local BASE='mods/integrated_hud/mdl_gamesession/'
local clock=0;local fake_fields={};local N
local host={time=function()return clock end,world_id=function()return 1 end,
 log=function()end,in_mission=function()return true end,unit_alive=function()return false end,
 player_unit=function()return nil end,
 call=function()return nil end,call_kind=function(name,kind,session,id,key)
  if name=='GameSession.game_object_exists'then return fake_fields[id]~=nil end
  if name=='GameSession.game_object_is_type'then return true end
  if name=='GameSession.game_object_field'then return fake_fields[id]and fake_fields[id][key]end
 end}
local sensor=assert(loadstring(SOURCES[BASE..'sensor']))()(host)
N=sensor.inspect()
local function weapon(hash)
 for _,t in ipairs(N.TYPES)do if t.id==hash then return t end end
 error('missing weapon '..hash)
end
local t=weapon('b697955d');fake_fields[100]={}
local o={};local w={rounds=5,chamber=false,magazines=3,options=80,fire_mode=1,reload_stage=0}
local d=N.shown(1,100,t,w,o)
assert(d.kind=='ammo'and d.value==6 and d.reserve==3,'magazine/chamber/reserve normalisation')
t=weapon('7bfb2e06');w.slot0=5;w.slot1=0;w.selected=0
d=N.shown(1,100,t,w,o)
assert(d.mode=='APHET','function mode missing')
w.options=84;d=N.shown(1,100,t,w,o);assert(d.mode=='FLAK','mode change not applied')
w.reload_stage=1;assert(N.shown(1,100,t,w,o).reloading,'reload state missing')
local rpm_type
for _,candidate in ipairs(N.TYPES)do if N.learned.rpmadj[candidate.id]and candidate.has.rpm and not candidate.has.heat then rpm_type=candidate;break end end
assert(rpm_type,'adjustable RPM seed missing')
fake_fields[101]={}
d=N.shown(1,101,rpm_type,{rounds=10,chamber=true,magazines=2,rpm=600,fire_mode=1,options=80},{})
assert(d.setting and d.setting:find('RPM',1,true),'valid RPM setting hidden')
d=N.shown(1,100,t,{rounds=5,chamber=true,magazines=3,options=80,fire_mode=1},{})
assert(d.setting==nil,'missing RPM drew a placeholder')
local pack,pi
for i,pt in ipairs(N.TYPES)do if pt.pack and pt.has.remaining then pack,pi=pt,i;break end end
assert(pack);fake_fields[200]={[N.ROLE.remaining.name]=7}
N.objs[200]={t=pi,on=true,mine=true}
assert(N.pack_ammo(1)==7,'separate backpack remaining not read')
-- Real managed entry with a stub reader: lifecycle and independent GUI ownership.
local current={state='READY',entity=100,kind='ammo',ratio=.5,rounds=6,mags=3,mode='APHET',rpm='600 RPM'}
local vehicle_updates,stops,reads=0,0,0
local pool,serial={},0;local cursor=false
local E={Application={},World={},Gui={},Window={}}
E.Application.worlds=function()return {'world'}end;E.Application.main_world=function()return 'world'end
E.Application.back_buffer_size=function()return 1920,1080 end
E.World.create_screen_gui=function()return 'gui'end
E.World.destroy_gui=function()assert(next(pool)==nil)end
E.Window.show_cursor=function()return cursor end
E.Vector2=function(...)return {...}end;E.Vector3=E.Vector2;E.Color=E.Vector2
E.Gui.triangle=function()serial=serial+1;pool[serial]=true;return serial end
E.Gui.destroy_triangle=function(_,id)assert(pool[id]);pool[id]=nil end
local env=setmetatable({stingray=E,os={getenv=function()return nil end}},{__index=_G});env._G=env
local modules={}
env.require=function(name)
 if name==BASE..'reader'then return {new=function()return {
  reset=function()end,read=function()reads=reads+1;return current end,shutdown=function()stops=stops+1 end}end}end
 if name=='mods/integrated_hud/driver_reference/driver_core'then return function()return {
  update=function()vehicle_updates=vehicle_updates+1 end,shutdown=function()stops=stops+1 end}end end
 if modules[name]then return modules[name]end
 local f=assert(loadstring(SOURCES[name]));setfenv(f,env);modules[name]=f();return modules[name]
end
local addon=env.require(BASE..'main');addon.on_enable();addon.on_update(nil,.1)
assert(next(pool)~=nil and vehicle_updates==1,'weapon/vehicle dispatch failed')
local before=serial;addon.on_update(nil,.1);assert(serial==before,'stable GUI recreated')
-- A seated snapshot has the same path: no motion gate in the entry.
current.mags=2;addon.on_update(nil,.1);assert(serial>before)
current.state='RELOADING';addon.on_update(nil,.1);assert(next(pool)==nil,'reload not hidden')
current.state='READY';addon.on_update(nil,.1);assert(next(pool)~=nil)
cursor=true;local n=reads;addon.on_update(nil,.1);assert(next(pool)==nil and reads==n)
cursor=false;addon.on_disable();assert(next(pool)==nil and stops==2)
addon.on_enable();addon.on_update(nil,.1);assert(next(pool)~=nil)
addon.on_disable();assert(next(pool)==nil and stops==4)
assert(env.update==nil and env.__DRIVER_HUD_INSTALLED==nil,'managed entry installed global hooks')
return {narrow200_normalisation=true,function_mode=true,adjustable_rpm_only=true,
 backpack_remaining=true,reload_hide=true,cached_gui=true,managed_enable_disable=true,
 independent_vehicle_dispatch=true,no_global_hooks=true}
