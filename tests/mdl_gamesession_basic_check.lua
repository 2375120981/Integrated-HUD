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
local views=nil
local pool,serial={},0;local cursor=false
local E={Application={},World={},Gui={},Window={}}
E.Application.worlds=function()return {'world'}end;E.Application.main_world=function()return 'world'end
E.Application.back_buffer_size=function()return 1920,1080 end
E.World.create_screen_gui=function()return 'gui'end
E.World.destroy_gui=function()assert(next(pool)==nil)end
E.Window.show_cursor=function()return cursor end
E.Vector2=function(...)return {...}end;E.Vector3=E.Vector2;E.Color=E.Vector2
E.Gui.triangle=function(_,a,b,c)serial=serial+1;pool[serial]={a,b,c};return serial end
E.Gui.destroy_triangle=function(_,id)assert(pool[id]);pool[id]=nil end
local env=setmetatable({stingray=E,os={getenv=function()return nil end}},{__index=_G});env._G=env
local scale_value,scale_spec=100,nil
local ammo_scale_value,ammo_scale_spec=100,nil
local labels={}
local network_scale_value,network_scale_spec=100,nil
local position_specs={};local position_values={network_x=0,network_y=50};local applied_position,applied_network_scale=nil,nil
env.ModOptionsMenu={register_option=function(id,spec)
 local key=id:match('integrated_hud%.(network_[xy])$')
 if key then assert(spec.type=='slider'and spec.min==0 and spec.max==100 and spec.step==1 and spec.default==(key=='network_x'and 0 or 50));position_specs[key]=spec;return true end
 assert((id=='integrated_hud.weapon_scale'or id=='integrated_hud.network_scale'or id=='integrated_hud.ammo_number_scale')and spec.type=='slider')
 assert(spec.min==50 and spec.max==150 and spec.step==5 and spec.default==100)
 if id=='integrated_hud.weapon_scale'then scale_spec=spec elseif id=='integrated_hud.ammo_number_scale'then ammo_scale_spec=spec else network_scale_spec=spec end;return true
end,get=function(id)local key=id:match('integrated_hud%.(network_[xy])$');if key then return position_values[key]end;if id=='integrated_hud.network_scale'then return network_scale_value end;if id=='integrated_hud.ammo_number_scale'then return ammo_scale_value end;assert(id=='integrated_hud.weapon_scale');return scale_value end}
local function geometry()
 local ids,out={},{}
 for id in pairs(pool)do ids[#ids+1]=id end;table.sort(ids)
 for _,id in ipairs(ids)do out[#out+1]=pool[id]end
 return out
end
local function scaled(base,factor)
 local now=geometry();assert(#now==#base,'scale changed primitive count')
 for i,tri in ipairs(base)do for j,p in ipairs(tri)do
  local q=now[i][j]
  assert(math.abs(q[1]-(960+(p[1]-960)*factor))<1e-6,'horizontal anchor/layout changed')
  assert(math.abs(q[3]-(540+(p[3]-540)*factor))<1e-6,'vertical anchor/layout changed')
 end end
end
local modules={}
env.require=function(name)
 if name==BASE..'network_ping_hud'then return {new=function()return {set_scale=function(v)applied_network_scale=v end,set_position=function(x,y)applied_position={x,y}end,update=function()end,shutdown=function()end}end}end
 if name==BASE..'reader'then return {new=function()return {
  reset=function()end,read=function()reads=reads+1;return current end,shutdown=function()stops=stops+1 end}end}end
 if name=='mods/integrated_hud/driver_reference/driver_core'then return function()return {
  set_views=function(f,t,m)views={f,t,m}end,update=function()vehicle_updates=vehicle_updates+1 end,shutdown=function()stops=stops+1 end}end end
 if modules[name]then return modules[name]end
 local f=assert(loadstring(SOURCES[name]));setfenv(f,env);modules[name]=f()
 if name==BASE..'art_ui'then
  local original_new=modules[name].new
  modules[name].new=function(...)
   local font=original_new(...);local draw=font.text
   font.text=function(g,m,text,x,y,height,...)labels[text]={x=x,y=y,height=height};return draw(g,m,text,x,y,height,...)end
   return font
  end
 end
 return modules[name]
end
local addon=env.require(BASE..'main');addon.on_enable();addon.on_update(nil,.1)
assert(next(pool)~=nil and vehicle_updates==1,'weapon/vehicle dispatch failed')
local before=serial;addon.on_update(nil,.1);assert(serial==before,'stable GUI recreated')
local art=env.require(BASE..'font')
for _,mode in ipairs({'AUTO','VOLLEY','TOTAL'})do
 assert(art.icons[mode]and #art.icons[mode].rects>0,'VG-70 bundled icon missing')
 current.mode=mode;local previous=serial;addon.on_update(nil,.1)
 assert(serial>previous,'VG-70 icon did not refresh')
 previous=serial;addon.on_update(nil,.1);assert(serial==previous,'stable VG-70 icon recreated')
end
assert(scale_spec and ammo_scale_spec and network_scale_spec and position_specs.network_x and position_specs.network_y,'MDL sliders not registered')
local baseline=geometry();local stop_before=stops
for _,percent in ipairs({50,150,100})do
 scale_value=percent;addon.on_update(nil,.1);scaled(baseline,percent/100)
 local previous=serial;addon.on_update(nil,.1)
 assert(serial==previous,'unchanged scale rebuilt geometry')
 assert(stops==stop_before and views[1]and views[2]and views[3],'weapon scale reset vehicle module')
end
-- Changing the count size redraws immediately, retains its anchor and does not resize the arc or mode art.
local number_before=labels['6 / 3'];local geometry_before=geometry()
for _,percent in ipairs({150,50,100})do
 ammo_scale_value=percent;addon.on_update(nil,.1)
 local number=labels['6 / 3'];assert(number.x==number_before.x and number.y==number_before.y,'ammo number anchor moved')
 assert(number.height==number_before.height*percent/100,'ammo slider not applied')
 local now=geometry()
 for i=1,100 do for j,p in ipairs(geometry_before[i])do
  assert(now[i][j][1]==p[1]and now[i][j][3]==p[3],'ammo slider changed arc geometry')
 end end
 local previous=serial;addon.on_update(nil,.1);assert(serial==previous,'unchanged ammo scale rebuilt geometry')
 assert(stops==stop_before,'ammo slider reset vehicle module')
end
current.kind='heat';current.heat_percent=50;addon.on_update(nil,.1)
local heat_before=labels['50%'].height
ammo_scale_value=150;addon.on_update(nil,.1);assert(labels['50%'].height==heat_before,'ammo slider resized heat percentage')
current.kind='ammo';current.heat_percent=nil;ammo_scale_value=100;addon.on_update(nil,.1)
-- A seated snapshot has the same path: no motion gate in the entry.
current.mags=2;addon.on_update(nil,.1);assert(serial>before)
current.state='RELOADING';addon.on_update(nil,.1);assert(next(pool)==nil,'reload not hidden')
current.state='READY';addon.on_update(nil,.1);assert(next(pool)~=nil)
local ready_geometry=geometry()
cursor=true;local n=reads;addon.on_update(nil,.1);assert(next(pool)==nil and reads==n)
cursor=false;addon.on_disable();assert(next(pool)==nil and stops==2)
scale_value=125
addon.on_enable();addon.on_update(nil,.1);assert(next(pool)~=nil);scaled(ready_geometry,1.25)
addon.on_disable();assert(next(pool)==nil and stops==4)
scale_value=100
-- Four MDL options with plain labels; vehicle filtering shares one reader.
local toggle_count=0
for _,option in ipairs(addon.options)do
 if option.type=='toggle'then toggle_count=toggle_count+1;assert(option.default==(option.key~='network_hud'))end
 assert(not option.label:find('／',1,true))
end
assert(toggle_count==5)
local ctx={settings={weapon_hud=false,frv_hud=true,tank_hud=true,mech_hud=true}}
local read_before,vehicle_before=reads,vehicle_updates
addon.on_enable(ctx);addon.on_update(ctx,.1)
assert(next(pool)==nil and reads==read_before and vehicle_updates==vehicle_before+1,'vehicle-only option failed')
ctx.settings.frv_hud=false;addon.on_setting(ctx,'frv_hud',false)
assert(views[1]==false and views[2]and views[3],'FRV switch changed another type')
ctx.settings.tank_hud=false;addon.on_setting(ctx,'tank_hud',false)
assert(views[1]==false and views[2]==false and views[3],'tank switch changed mech')
ctx.settings.mech_hud=false;addon.on_setting(ctx,'mech_hud',false)
vehicle_before=vehicle_updates;addon.on_update(ctx,.1)
assert(reads==read_before and vehicle_updates==vehicle_before,'all disabled still polled')
ctx.settings.weapon_hud=true;addon.on_setting(ctx,'weapon_hud',true);addon.on_update(ctx,.1)
assert(next(pool)~=nil and reads>read_before and vehicle_updates==vehicle_before,'weapon-only option failed')
ctx.settings.mech_hud=true;addon.on_setting(ctx,'mech_hud',true);addon.on_update(ctx,.1)
assert(views[1]==false and views[2]==false and views[3],'mech-only settings failed')
assert(next(pool)~=nil and vehicle_updates==vehicle_before+1,'vehicle re-enable failed')
ctx.settings.weapon_hud=false;addon.on_setting(ctx,'weapon_hud',false)
assert(next(pool)==nil,'weapon setting did not immediately clear GUI')
read_before=reads;addon.on_update(ctx,.1);assert(reads==read_before,'disabled weapon reader polled')
addon.on_disable();assert(next(pool)==nil)
addon.on_enable(ctx);addon.on_update(ctx,.1)
assert(next(pool)==nil and reads==read_before,'saved weapon-off setting ignored on enable')
addon.on_disable()
local legacy={settings={weapon_hud=false,vehicle_hud=false,frv_hud=true,tank_hud=true,mech_hud=true}}
vehicle_before=vehicle_updates;addon.on_enable(legacy);addon.on_update(legacy,.1)
assert(legacy.settings.vehicle_hud==nil and legacy.settings.frv_hud==false
 and legacy.settings.tank_hud==false and legacy.settings.mech_hud==false,'combined toggle migration failed')
assert(vehicle_updates==vehicle_before and reads==read_before,'legacy off choice ignored')
addon.on_disable()
-- Saved position sliders dispatch independently from weapon and vehicle settings.
position_values.network_x=30;position_values.network_y=60;network_scale_value=125
local position_ctx={settings={weapon_hud=false,frv_hud=false,tank_hud=false,mech_hud=false,network_hud=true,network_x=99,network_y=99}}
addon.on_enable(position_ctx);addon.on_update(position_ctx,.1)
assert(applied_position[1]==30 and applied_position[2]==60 and applied_network_scale==1.25,'saved position sliders not applied')
addon.on_disable()
-- If MDL's optional slider provider is disabled, retain a bounded numeric control.
env.ModOptionsMenu=nil
local fallback={settings={weapon_hud=true,frv_hud=false,tank_hud=false,mech_hud=false,weapon_scale=150}}
addon.on_enable(fallback);addon.on_update(fallback,.1);scaled(ready_geometry,1.5)
local numeric=false
for _,option in ipairs(addon.options)do if option.key=='weapon_scale'then numeric=option.type=='number'end end
assert(numeric,'missing numeric fallback')
local ammo_numeric=false;for _,option in ipairs(addon.options)do if option.key=='ammo_number_scale'then ammo_numeric=option.type=='number'end end
assert(ammo_numeric,'missing ammo scale numeric fallback')
fallback.settings.ammo_number_scale=125;addon.on_setting(fallback,'ammo_number_scale',125);addon.on_update(fallback,.1)
assert(labels['6 / 2'].height==24*1.25,'ammo numeric fallback not applied')
fallback.settings.ammo_number_scale=100;addon.on_setting(fallback,'ammo_number_scale',100);addon.on_update(fallback,.1)

local network_numeric=false;for _,option in ipairs(addon.options)do if option.key=='network_scale'then network_numeric=option.type=='number'end end
assert(network_numeric,'missing network scale fallback')
local axes=0;for _,option in ipairs(addon.options)do if option.key=='network_x'or option.key=='network_y'then assert(option.type=='number');axes=axes+1 end end
assert(axes==2,'missing position fallbacks')
fallback.settings.weapon_scale=math.huge;addon.on_setting(fallback,'weapon_scale',math.huge)
addon.on_update(fallback,.1);scaled(ready_geometry,1)
addon.on_disable()
local position_fallback={settings={weapon_hud=false,frv_hud=false,tank_hud=false,mech_hud=false,network_hud=true,network_x=25,network_y=75}}
addon.on_enable(position_fallback);addon.on_update(position_fallback,.1)
assert(applied_position[1]==25 and applied_position[2]==75,'position numeric fallback not applied')
addon.on_disable()
assert(env.update==nil and env.__DRIVER_HUD_INSTALLED==nil,'managed entry installed global hooks')
return {ammo_number_scale_slider=true,ammo_number_scale_anchor_and_cache=true,ammo_number_scale_fallback=true,narrow200_normalisation=true,function_mode=true,adjustable_rpm_only=true,vg70_icons=true,
 network_position_sliders=true,network_position_saved_and_fallback=true,weapon_scale_slider=true,weapon_scale_anchor=true,weapon_scale_persisted=true,weapon_scale_fallback=true,
 backpack_remaining=true,reload_hide=true,cached_gui=true,managed_enable_disable=true,
 independent_vehicle_dispatch=true,no_global_hooks=true,independent_hud_options=true,
 option_cleanup_immediate=true,disabled_reader_stops=true,saved_options_respected=true,five_hud_options=true,legacy_vehicle_option_migrated=true}
