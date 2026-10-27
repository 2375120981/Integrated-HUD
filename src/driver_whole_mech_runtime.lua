-- Independent entry only. All reading, world/GUI selection, geometry, cache and
-- primitive ownership are supplied by the unchanged DRIVER HUD 1.6 core.
local M={}
function M.attach()
 local key='__INTEGRATED_HUD_DRIVER_REFERENCE_041'
 if rawget(_G,key)then return rawget(_G,key)end
 local function log(s)
  pcall(function()
   local base=os.getenv('APPDATA');if not base then return end
   local f=io.open(base..'/Arrowhead/Helldivers2/IntegratedHUD-0.4.1.log','a')
   if f then f:write('[IHUD 0.4.1] '..s..'\n');f:close()end
  end)
 end
 assert(type(rawget(_G,'stingray'))=='table','IHUD: stingray unavailable')
 assert(type(rawget(_G,'update'))=='function','IHUD: original update unavailable')
 assert(not rawget(_G,'__DRIVER_HUD_INSTALLED'),'IHUD: another DRIVER HUD core is already installed')
 log('START standalone=true core=DRIVER_HUD_1.6_PRESENTATION_PATCH gui=original reader=original world_selection=original style=final mech=whole_total_hp')
 local core=require('mods/integrated_hud/driver_reference/driver_core')
 assert(type(core)=='table'and core.installed==true and rawget(_G,'__DRIVER_HUD_INSTALLED'),'IHUD: DRIVER HUD core failed to attach')
 local state={installed=true,version='0.4.1',core='DRIVER HUD 1.6 with own style'}
 rawset(_G,key,state)
 log('ATTACH_OK native_log=driver_hud_lua51.log settings=driver_hud_settings.txt')
 return state
end
return M
