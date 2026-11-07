-- One public ModOptionsMenu group for both MDL settings entry points.
-- Keep existing slider IDs. Native settings only serve migration/fallback.
local M={}
local OWNER='mods/integrated_hud/mdl_gamesession/main'
local CHOICES={'仅血条','仅列表','血条+列表'}
local SPECS={
 {key='weapon_hud',type='toggle',label='武器 HUD',default=true,legacy=true,description='包含弹药、热量与独立蓄力圆弧。局内热切换后可能需要武器开火刷新状态。'},
 {key='frv_hud',type='toggle',label='FRV HUD',default=true,legacy=true,description='局内热切换后可能需要上下车刷新状态。'},
 {key='tank_hud',type='toggle',label='坦克 HUD',default=true,legacy=true,description='局内热切换后可能需要上下车刷新状态。'},
 {key='mech_hud',type='toggle',label='机甲 HUD',default=true,legacy=true,description='局内热切换后可能需要上下车刷新状态。'},
 {key='booster_hud',type='toggle',label='小队强化图标',default=true,legacy=true,description='强化显示总开关；血条旁队友强化仍可能错位，列表按玩家身份对应。'},
 {key='booster_display',type='choice',label='强化显示位置',default=3,choices=CHOICES,legacy=true,description='血条版本可能不准确，推荐使用准确的列表版本。列表只显示队友。'},
 {key='network_hud',type='toggle',label='延迟数字',default=true,legacy=true,description='只控制延迟数字；延迟数字与列表强化均关闭时隐藏面板。'},
 {key='weapon_scale',type='slider',label='武器 HUD 大小',min=50,max=150,step=5,default=100,description='百分比；整体等比例缩放，固定准星中心锚点，仅影响武器 HUD。'},
 {key='ammo_number_scale',type='slider',label='弹药数字大小',min=50,max=150,step=5,default=100,description='百分比；仅缩放弹匣及备弹数字，固定数字中心位置，与武器 HUD 整体缩放叠加。'},
 {key='network_scale',type='slider',label='延迟面板大小',min=50,max=150,step=5,default=100,description='百分比；整体等比例缩放，仅影响延迟面板。默认位置为左侧贴边、垂直居中。'},
 {key='network_x',type='slider',label='延迟面板横向位置',min=0,max=100,step=1,default=0,description='百分比：0 靠左、50 居中、100 靠右。'},
 {key='network_y',type='slider',label='延迟面板纵向位置',min=0,max=100,step=1,default=50,description='百分比：0 顶部、50 垂直居中、100 底部。'}
}
local function call(f,...)if type(f)=='function'then local ok,a=pcall(f,...);if ok then return a end end end
local function value(spec,v)
 if spec.type=='toggle'then if type(v)=='boolean'then return v end
 elseif spec.type=='choice'then
  if type(v)=='number'and v==math.floor(v)and CHOICES[v]then return v end
  for i,s in ipairs(CHOICES)do if v==s then return i end end
 elseif type(v)=='number'and v==v and math.abs(v)<math.huge then
  return math.max(spec.min,math.min(spec.max,math.floor((v-spec.min)/spec.step+.5)*spec.step+spec.min))
 end
end
function M.new(log)
 local R={};local api=nil;local registered={}
 function R.register(ctx)
  local saved=type(ctx)=='table'and type(ctx.settings)=='table'and ctx.settings or{}
  local candidate=rawget(_G,'ModOptionsMenu')
  api=type(candidate)=='table'and type(candidate.get)=='function'and type(candidate.set)=='function'and type(candidate.register_option)=='function'and candidate or nil
  registered={};local fallback={};local migrated=true
  for _,spec in ipairs(SPECS)do
   local id='integrated_hud.'..spec.key
   local public={type=spec.type,label=spec.label,default=spec.default,description=spec.description,
    choices=spec.choices,min=spec.min,max=spec.max,step=spec.step,mod='集成HUD',mod_id=OWNER}
   local existing=api and call(api.get,id)
   local ok=api and call(api.register_option,id,public)==true
   if ok then
    registered[spec.key]=id
    if spec.legacy and saved.options_menu_migrated_v1~=true and existing==nil then
     local old=value(spec,saved[spec.key])
     if old~=nil and call(api.set,id,old)~=true then migrated=false end
    end
   else
    if spec.legacy then migrated=false end
    fallback[#fallback+1]={key=spec.key,type=spec.type=='slider'and'number'or spec.type,
     label=spec.label,default=spec.type=='choice'and CHOICES[spec.default]or spec.default,
     choices=spec.choices,min=spec.min,max=spec.max,step=spec.step}
    if log then log('OPTIONS native fallback: '..spec.key)end
   end
  end
  -- MDL persists the context settings with its configuration. Once migrated,
  -- old values must never overwrite changes made through the public menu.
  if api and migrated and type(ctx)=='table'and type(ctx.settings)=='table'then saved.options_menu_migrated_v1=true end
  return fallback
 end
 function R.read(ctx)
  local saved=type(ctx)=='table'and type(ctx.settings)=='table'and ctx.settings or{}
  local out={}
  for _,spec in ipairs(SPECS)do
   local v=registered[spec.key]and api and value(spec,call(api.get,registered[spec.key]))
   if v==nil then v=value(spec,saved[spec.key])end
   if v==nil then v=spec.default end
   out[spec.key]=spec.type=='choice'and CHOICES[v]or v
  end
  return out
 end
 return R
end
return M
