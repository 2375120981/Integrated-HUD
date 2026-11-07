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
local ammo_number_scale_api=nil
local scale_api=nil
local network_scale_api=nil
local network_position_apis={}
local definition
local SCALE_ID='integrated_hud.weapon_scale'
local AMMO_NUMBER_SCALE_ID='integrated_hud.ammo_number_scale'
local NETWORK_SCALE_ID='integrated_hud.network_scale'
local NETWORK_POSITION={
 {key='network_x',id='integrated_hud.network_x',label='延迟面板横向位置',default=0,
  description='百分比：0 靠左、50 居中、100 靠右。'},
 {key='network_y',id='integrated_hud.network_y',label='延迟面板纵向位置',default=50,
  description='百分比：0 顶部、50 垂直居中、100 底部。'}
}
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
  local f=io.open(base..'/Arrowhead/Helldivers2/IntegratedHUD-MDL-0.8.13.log','a')
  if f then f:write(string.format('%.3f %s\n',clock,s));f:close()end
 end)
end
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
 local settings=type(ctx)=='table'and type(ctx.settings)=='table'and ctx.settings or{}
 local mode=settings.booster_display
 if mode~='仅血条'and mode~='仅列表'and mode~='血条+列表'then mode='血条+列表'end
 local enabled=settings.booster_hud~=false
 local blood_boosters=enabled and mode~='仅列表'
 local list_boosters=enabled and mode~='仅血条'
 local latency=settings.network_hud==true
 if latency or list_boosters then
  if not network_hud then network_hud=require('mods/integrated_hud/mdl_gamesession/network_ping_hud').new(E,log)end
 elseif network_hud then call(network_hud.shutdown);network_hud=nil end
 if network_hud then
  network_hud.set_content(latency,list_boosters)
  local percent=network_scale_api and call(network_scale_api.get,NETWORK_SCALE_ID)or settings.network_scale
  network_hud.set_scale(scale_percent(percent)/100)
  local position={}
  for i,spec in ipairs(NETWORK_POSITION)do
   local api=network_position_apis[spec.key]
   position[i]=position_percent(api and call(api.get,spec.id)or settings[spec.key],spec.default)
  end
  network_hud.set_position(position[1],position[2])
 end
 if blood_boosters then
  if not booster_hud then booster_hud=require('mods/integrated_hud/mdl_gamesession/squad_boosters').new(E,log)end
 elseif booster_hud then call(booster_hud.shutdown);booster_hud=nil end
 local percent=scale_api and call(scale_api.get,SCALE_ID)or settings.weapon_scale
 weapon_scale=scale_percent(percent)/100
 local ammo_percent=ammo_number_scale_api and call(ammo_number_scale_api.get,AMMO_NUMBER_SCALE_ID)or settings.ammo_number_scale
 ammo_number_scale=scale_percent(ammo_percent)/100
 if settings.weapon_hud~=false then
  if not reader then
   reader=require('mods/integrated_hud/mdl_gamesession/reader').new(E,log)
   reader.reset()
  end
 elseif reader or weapon_view then stop_weapon()end
 local frv,tank,mech=settings.frv_hud~=false,settings.tank_hud~=false,settings.mech_hud~=false
 if frv or tank or mech then
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
local function register_scale()
 -- MDL's built-in Mod Options Menu API provides an actual draggable slider.
 -- Poll the saved value; avoid retaining on_change callbacks after disable.
 local api=rawget(_G,'ModOptionsMenu')
 scale_api=nil
 ammo_number_scale_api=nil
 network_scale_api=nil
 network_position_apis={}
 if type(api)=='table'and type(api.get)=='function'then
  local ok=call(api.register_option,SCALE_ID,{type='slider',label='武器 HUD 大小',
   mod='集成HUD',mod_id='mods/integrated_hud/mdl_gamesession/main',
   description='百分比；整体等比例缩放，固定准星中心锚点，仅影响武器 HUD。',
   min=50,max=150,step=5,default=100})
  if ok==true then scale_api=api end
  local ammo_ok=call(api.register_option,AMMO_NUMBER_SCALE_ID,{type='slider',label='弹药数字大小',
   mod='集成HUD',mod_id='mods/integrated_hud/mdl_gamesession/main',
   description='百分比；仅缩放弹匣及备弹数字，固定数字中心位置，与武器 HUD 整体缩放叠加。',
   min=50,max=150,step=5,default=100})
  if ammo_ok==true then ammo_number_scale_api=api end
  local network_ok=call(api.register_option,NETWORK_SCALE_ID,{type='slider',label='延迟面板大小',
   mod='集成HUD',mod_id='mods/integrated_hud/mdl_gamesession/main',
   description='百分比；整体等比例缩放，仅影响延迟面板。默认位置为左侧贴边、垂直居中。',
   min=50,max=150,step=5,default=100})
  if network_ok==true then network_scale_api=api end
  for _,spec in ipairs(NETWORK_POSITION)do
   local registered=call(api.register_option,spec.id,{type='slider',label=spec.label,
    mod='集成HUD',mod_id='mods/integrated_hud/mdl_gamesession/main',description=spec.description,
    min=0,max=100,step=1,default=spec.default})
   if registered==true then network_position_apis[spec.key]=api end
  end
 end
 for i=#definition.options,1,-1 do
  local key=definition.options[i].key
  if key=='weapon_scale'or key=='ammo_number_scale'or key=='network_scale'or key=='network_x'or key=='network_y'then table.remove(definition.options,i)end
 end
 if not scale_api then
  -- Older/configured MDL installations can still adjust the same percentage.
  definition.options[#definition.options+1]={key='weapon_scale',type='number',
   label='武器 HUD 大小',min=50,max=150,step=5,default=100}
  log('SCALE slider API unavailable; numeric setting fallback')
 end
 if not ammo_number_scale_api then
  definition.options[#definition.options+1]={key='ammo_number_scale',type='number',
   label='弹药数字大小',min=50,max=150,step=5,default=100}
 end
 if not network_scale_api then
  definition.options[#definition.options+1]={key='network_scale',type='number',
   label='延迟面板大小',min=50,max=150,step=5,default=100}
 end
 for _,spec in ipairs(NETWORK_POSITION)do
  if not network_position_apis[spec.key]then
   definition.options[#definition.options+1]={key=spec.key,type='number',label=spec.label,
    min=0,max=100,step=1,default=spec.default}
  end
 end
end
local function stop()
 active_mod=false;stop_weapon();stop_vehicle()
 if booster_hud then call(booster_hud.shutdown);booster_hud=nil end
 if network_hud then call(network_hud.shutdown);network_hud=nil end
 scale_api=nil
 ammo_number_scale_api=nil
 network_scale_api=nil
 network_position_apis={}
end
definition={
 name='集成HUD',version='0.8.13',author='2375120981',
 description='需要 MDL dev43 与 HD2 Data Hub 0.6.0；MDL GUI 绘制全部 HUD，Hub 读取手持武器及弹药。',
 options={
  {key='weapon_hud',type='toggle',label='武器 HUD',default=true},
  {key='frv_hud',type='toggle',label='FRV HUD',default=true},
  {key='tank_hud',type='toggle',label='坦克 HUD',default=true},
  {key='mech_hud',type='toggle',label='机甲 HUD',default=true},
  {key='booster_hud',type='toggle',label='小队强化图标',default=true},
  {key='booster_display',type='choice',label='强化显示位置',choices={'仅血条','仅列表','血条+列表'},default='血条+列表'},
  {key='network_hud',type='toggle',label='延迟数字',default=false},
  {key='network_note',type='text',label='武器、强化与延迟显示需启用 Hub 0.6.0',default=''},
  {key='hot_toggle_note_1',type='text',label='局内热切换后可能需要',default=''},
  {key='hot_toggle_note_2',type='text',label='上下车或武器开火刷新状态',default=''}
 },
 on_enable=function(ctx)
  stop()
  register_scale()
  local settings=ctx and ctx.settings
  if type(settings)=='table'and settings.vehicle_hud~=nil then
   -- Migrate the former combined toggle once, including a saved off state.
   if settings.vehicle_hud==false then
    settings.frv_hud=false;settings.tank_hud=false;settings.mech_hud=false
   end
   settings.vehicle_hud=nil
  end
  active_mod=true;sync_settings(ctx)
  log('START MDL dev43 GUI; Hub 0.6 weapon identity/ammo; GameSession vehicle and weapon settings')
 end,
 on_setting=function(ctx,key,value)
  if key=='booster_display'or key=='booster_hud'or key=='weapon_hud'or key=='frv_hud'or key=='tank_hud'or key=='mech_hud'or key=='weapon_scale'or key=='ammo_number_scale'or key=='network_hud'or key=='network_scale'or key=='network_x'or key=='network_y'then
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
