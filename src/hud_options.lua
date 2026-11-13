-- One public ModOptionsMenu group for both MDL settings entry points.
-- Keep existing slider IDs. Native settings only serve migration/fallback.
local M={}
local i18n=require('mods/integrated_hud/mdl_gamesession/localization')
local OWNER='mods/integrated_hud/mdl_gamesession/main'
local CHOICES={'仅血条','仅列表','血条+列表'}
local SPECS={
 {key='language',type='choice',default=1,choices={'auto','zh-CN','en','ru-RU'},choice_keys={'language.auto','language.zh-CN','language.en','language.ru-RU'},native_choices={'跟随 MDL','简体中文','English','Русский'}},
 {key='weapon_hud',type='toggle',default=true,legacy=true},
 {key='frv_hud',type='toggle',default=true,legacy=true},
 {key='tank_hud',type='toggle',default=true,legacy=true},
 {key='mech_hud',type='toggle',default=true,legacy=true},
 {key='booster_hud',type='toggle',default=true,legacy=true},
 {key='booster_display',type='choice',default=3,choices=CHOICES,choice_keys={'booster.healthbar','booster.list','booster.both'},legacy=true},
 {key='network_hud',type='toggle',default=true,legacy=true},
 {key='weapon_scale',type='slider',min=50,max=150,step=5,default=100},
 {key='ammo_number_scale',type='slider',min=50,max=150,step=5,default=100},
 {key='network_scale',type='slider',min=50,max=150,step=5,default=100},
 {key='network_x',type='slider',min=0,max=100,step=1,default=0},
 {key='network_y',type='slider',min=0,max=100,step=1,default=50}
}
local function source(key)return function()return i18n.t(key)end end
local group_source=source('mod.title')
for _,spec in ipairs(SPECS)do
 spec.label_source=source('options.'..spec.key..'.label')
 spec.description_source=source('options.'..spec.key..'.description')
 if spec.choice_keys then
  spec.choice_sources={};for i,key in ipairs(spec.choice_keys)do spec.choice_sources[i]=source(key)end
 end
end
local function call(f,...)if type(f)=='function'then local ok,a=pcall(f,...);if ok then return a end end end
local function value(spec,v)
 if spec.type=='toggle'then if type(v)=='boolean'then return v end
 elseif spec.type=='choice'then
  if type(v)=='number'and v==math.floor(v)and spec.choices[v]then return v end
  for i,s in ipairs(spec.choices)do if v==s or(spec.native_choices and v==spec.native_choices[i])then return i end end
 elseif type(v)=='number'and v==v and math.abs(v)<math.huge then
  return math.max(spec.min,math.min(spec.max,math.floor((v-spec.min)/spec.step+.5)*spec.step+spec.min))
 end
end
function M.new(log)
 local R={};local api=nil;local registered={};local saved_settings={}
 local function preference()
  local spec=SPECS[1]
  local v=registered.language and api and value(spec,call(api.get,registered.language))
  if v==nil then v=value(spec,saved_settings.language)end
  return spec.choices[v or spec.default]
 end
 function R.register(ctx)
  local saved=type(ctx)=='table'and type(ctx.settings)=='table'and ctx.settings or{}
  saved_settings=saved;i18n.set_source(preference)
  local candidate=rawget(_G,'ModOptionsMenu')
  api=type(candidate)=='table'and type(candidate.get)=='function'and type(candidate.set)=='function'and type(candidate.register_option)=='function'and candidate or nil
  registered={};local fallback={};local migrated=true
  for _,spec in ipairs(SPECS)do
   local id='integrated_hud.'..spec.key
   local public={type=spec.type,label=spec.label_source,default=spec.default,description=spec.description_source,
    choices=spec.choice_sources or spec.choices,min=spec.min,max=spec.max,step=spec.step,mod=group_source,mod_id=OWNER}
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
     label=spec.label_source(),default=spec.type=='choice'and(spec.native_choices or spec.choices)[spec.default]or spec.default,
     choices=spec.native_choices or spec.choices,min=spec.min,max=spec.max,step=spec.step}
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
   out[spec.key]=spec.type=='choice'and spec.choices[v]or v
  end
  return out
 end
 return R
end
return M
