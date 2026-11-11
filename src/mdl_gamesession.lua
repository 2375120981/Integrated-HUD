-- HD2-Addon: mods/integrated_hud/mdl_gamesession/main
-- MDL lifecycle/GUI; Hub supplies weapon identity, ammo, heat and reload state.
local reader
local vehicles
local network_hud
local booster_hud
local next_booster_error=0
local next_network_error=0
local vehicle_views_key=nil
local active_mod=false
local next_vehicle_error=0
local weapon_scale=1
local ammo_number_scale=1
local definition
local function position_percent(value,default)
 if type(value)~='number'or value~=value or math.abs(value)==math.huge then return default end
 return math.max(0,math.min(100,math.floor(value+.5)))
end
local function scale_percent(value)
 if type(value)~='number'or value~=value or math.abs(value)==math.huge then return 100 end
 return math.max(50,math.min(150,math.floor(value/5+.5)*5))
end
local E=stingray
local weapon_view=nil
local clock=0
local last_log,next_log,next_error=nil,0,0
local function call(fn,...)
 if type(fn)~='function'then return nil end
 local ok,a,b=pcall(fn,...);if ok then return a,b end
end
local function log(s)
 pcall(function()
  local base=os.getenv('APPDATA');if not base then return end
  local f=io.open(base..'/Arrowhead/Helldivers2/IntegratedHUD-MDL-0.9.0.log','a')
  if f then f:write(string.format('%.3f %s\n',clock,s));f:close()end
 end)
end
local options=require('mods/integrated_hud/mdl_gamesession/hud_options').new(log)
local function frame(dt)
 clock=clock+(type(dt)=='number'and dt>0 and math.min(dt,.5)or 1/60)
 if vehicles then
  local ok,err=pcall(vehicles.update,dt)
  if not ok and clock>=next_vehicle_error then next_vehicle_error=clock+5;log('VEHICLE_ERROR '..tostring(err))end
 end
 if network_hud then
  local ok,err=pcall(network_hud.update,clock)
  if not ok and clock>=next_network_error then next_network_error=clock+5;log('NETWORK_ERROR '..tostring(err))end
 end
 if booster_hud then
  local ok,err=pcall(booster_hud.update,clock)
  if not ok and clock>=next_booster_error then next_booster_error=clock+5;log('BOOSTER_ERROR '..tostring(err))end
 end
 if not reader then return end
 local v=reader.read(clock)
 if vehicles and call(vehicles.weapon_blocked)==true then if weapon_view then weapon_view.hide()end;return end
 if E.Window and call(E.Window.show_cursor)==true then if weapon_view then weapon_view.hide()end;return end
 local key=table.concat({v.state,tostring(v.entity),v.kind or'',tostring(v.rounds),tostring(v.mags),tostring(v.heat_percent),v.mode or'',v.rpm or''},'/')
 if key~=last_log and clock>=next_log then last_log=key;next_log=clock+.5;log('WEAPON '..key)end
 if not weapon_view then weapon_view=require('mods/integrated_hud/mdl_gamesession/weapon_view').new(log)end
 weapon_view.update(v,weapon_scale,ammo_number_scale)
end
local function stop_weapon()
 if weapon_view then call(weapon_view.shutdown);weapon_view=nil end
 if reader then call(reader.shutdown);reader=nil end
end
local function stop_vehicle()
 if vehicles then call(vehicles.shutdown);vehicles=nil end
 vehicle_views_key=nil
end
local function sync_settings(ctx)
 if not active_mod then return end
 local settings=options.read(ctx)
 local mode=settings.booster_display
 if mode~='仅血条'and mode~='仅列表'and mode~='血条+列表'then mode='血条+列表'end
 local enabled=settings.booster_hud~=false
 local blood_boosters=enabled and mode~='仅列表'
 local list_boosters=enabled and mode~='仅血条'
 local latency=settings.network_hud~=false
 if latency or list_boosters then
  if not network_hud then network_hud=require('mods/integrated_hud/mdl_gamesession/network_ping_hud').new(E,log)end
 elseif network_hud then call(network_hud.shutdown);network_hud=nil end
 if network_hud then
  network_hud.set_content(latency,list_boosters)
  network_hud.set_scale(scale_percent(settings.network_scale)/100)
  network_hud.set_position(position_percent(settings.network_x,0),position_percent(settings.network_y,50))
 end
 if blood_boosters then
  if not booster_hud then booster_hud=require('mods/integrated_hud/mdl_gamesession/squad_boosters').new(E,log)end
 elseif booster_hud then call(booster_hud.shutdown);booster_hud=nil end
 weapon_scale=scale_percent(settings.weapon_scale)/100
 ammo_number_scale=scale_percent(settings.ammo_number_scale)/100
 if settings.weapon_hud~=false then
  if not reader then
   reader=require('mods/integrated_hud/mdl_gamesession/reader').new(E,log)
   reader.reset()
  end
 elseif reader or weapon_view then stop_weapon()end
 local frv,tank,mech=settings.frv_hud~=false,settings.tank_hud~=false,settings.mech_hud~=false
 if frv or tank or mech or reader then
  if not vehicles then
   vehicles=require('mods/integrated_hud/driver_reference/driver_core')()
   assert(vehicles and type(vehicles.update)=='function','vehicle module unavailable')
  end
  local key=tostring(frv)..'/'..tostring(tank)..'/'..tostring(mech)
  if key~=vehicle_views_key then
   vehicles.set_views(frv,tank,mech);vehicle_views_key=key
  end
 else stop_vehicle()end
end
local function stop()
 active_mod=false;stop_weapon();stop_vehicle()
 if booster_hud then call(booster_hud.shutdown);booster_hud=nil end
 if network_hud then call(network_hud.shutdown);network_hud=nil end
end
definition={
 name='集成HUD',version='0.9.0',author='2375120981',
 description='需要 MDL dev43 与 HD2 Data Hub 0.6.0；MDL GUI 绘制全部 HUD，Hub 读取手持武器及弹药。',
 options={},
 on_enable=function(ctx)
  stop()
  local settings=ctx and ctx.settings
  if type(settings)=='table'and settings.vehicle_hud~=nil then
   -- Migrate the former combined toggle once, including a saved off state.
   if settings.vehicle_hud==false then
    settings.frv_hud=false;settings.tank_hud=false;settings.mech_hud=false
   end
   settings.vehicle_hud=nil
  end
  definition.options=options.register(ctx)
  active_mod=true;sync_settings(ctx)
  log('START MDL dev43 GUI; Hub 0.6 weapon identity/ammo; GameSession vehicle and weapon settings')
 end,
 on_setting=function(ctx,key,value)
  if key=='language'or key=='booster_display'or key=='booster_hud'or key=='weapon_hud'or key=='frv_hud'or key=='tank_hud'or key=='mech_hud'or key=='weapon_scale'or key=='ammo_number_scale'or key=='network_hud'or key=='network_scale'or key=='network_x'or key=='network_y'then
   sync_settings(ctx);log('SETTING '..key..'='..tostring(value))
  end
 end,
 on_update=function(ctx,dt)
  if not active_mod then return end
  sync_settings(ctx)
  local ok,err=pcall(frame,dt)
  if not ok then if weapon_view then call(weapon_view.shutdown);weapon_view=nil end;if clock>=next_error then next_error=clock+5;log('ERROR '..tostring(err))end end
 end,
 on_disable=function()stop();log('STOP')end
}
return definition
