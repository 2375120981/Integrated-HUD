-- Pure-data translations compiled from locales/*.json. No runtime file IO.
local catalogs=require('mods/integrated_hud/mdl_gamesession/locale_data')
local M={};local preference=nil;local resolving=false;local last_code='en'
local function call(f,...)if type(f)=='function'then local ok,v=pcall(f,...);if ok then return v end end end
local function language(v)
 if type(v)~='string'or v==''then return nil end
 local s=v:lower():gsub('_','-')
 if s=='auto'or s=='system'or s=='default'then return nil end
 if s:sub(1,2)=='zh'or s=='chinese'or s=='simplified chinese'then return 'zh-CN' end
 if s:sub(1,2)=='ru'or s=='russian'then return 'ru-RU' end
 if catalogs[v]then return v end
 if catalogs[s]then return s end
 for k,_ in pairs(catalogs) do
  if k:lower()==s then return k end
 end
 return s:match('^[a-z]+')
end
function M.set_source(reader)preference=reader end
local function resolve()
 local selected=language(call(preference))
 if selected and catalogs[selected]then return selected end
 local mdl=rawget(_G,'MDL');local host=rawget(_G,'MDL3')
 local i18n=type(mdl)=='table'and mdl.i18n
 local code=type(i18n)=='table'and(language(i18n.code)or language(i18n.language)or language(i18n.lang))
 local ui=type(host)=='table'and host.ui
 if not code and type(ui)=='table'then code=language(ui.language)or language(ui.language_code)or language(ui.lang)end
 if not code then
  for _,v in ipairs({mdl or false,host or false})do if type(v)=='table'then
   local cfg=v.config or v.cfg or v.settings;local c=type(cfg)=='table'and cfg.ui
   if type(c)=='table'then code=language(c.language)or language(c.lang);if code then break end end
  end end
 end
 return (code and catalogs[code] and code) or (not code and catalogs[last_code] and last_code) or 'en'
end
-- Menu APIs may resolve label callbacks while reading a setting. Guard
-- re-entry and contain malformed/temporarily unavailable host language state.
function M.code()
 if resolving then return last_code end
 resolving=true
 local ok,code=pcall(resolve)
 resolving=false
-- Preserve the last valid language if resolution fails, instead of resetting to English.
 if ok and type(code)=='string'and catalogs[code]then last_code=code
 end
 return last_code
end
function M.t(key)
 local catalog=catalogs[M.code()]or catalogs.en
 return catalog.strings[key]or catalogs.en.strings[key]or key
end
return M
