-- Hub boosters joined by peer; native player/index determines the health-bar row.
local M={}
local function call(f,...)if type(f)=='function'then local ok,a=pcall(f,...);if ok then return a end end end
local data=require('mods/integrated_hud/mdl_gamesession/booster_data')
local icon=require('mods/integrated_hud/mdl_gamesession/booster_icon')
function M.new(E,log)
 local cfg=require('mods/integrated_hud/mdl_gamesession/booster_layout')
 local identity=require('mods/integrated_hud/mdl_gamesession/squad_identity').new(E,log)
 local c=require('mods/integrated_hud/mdl_gamesession/mdl_canvas').new(45,'reference',log,88)
 local R={};local next_read=0;local provider=nil;local epoch=nil;local rows={};local key=nil;local logged=nil
 local function clear()rows={};key=nil;identity.reset();c.clear();c.commit()end
 local function read(D,now)
  local snapshot=data.read(D);if not snapshot then return nil end
  local local_player=snapshot.local_player;local remotes={}
  local native=identity.read(snapshot.rows,now)
  if native then
   for _,p in ipairs(snapshot.rows)do
    p.native_index=native[p.peer]
    if not p.is_local then remotes[#remotes+1]=p end
   end
   table.sort(remotes,function(a,b)return a.native_index>b.native_index end)
  end
  local out={}
  for i,p in ipairs(remotes)do
   p.y=cfg.last_teammate_tag_center_y-(#remotes-i)*cfg.teammate_row_spacing-cfg.above_tag_center
   out[#out+1]=p
  end
  local_player.y=cfg.local_tag_center_y-cfg.above_tag_center;out[#out+1]=local_player
  return out
 end
 function R.update(now)
  local D=rawget(_G,'HD2Data')
  local mission=type(D)=='table'and call(D.mission)
  if D~=provider or(type(mission)=='table'and mission.epoch~=epoch)then
   clear();next_read=0;provider=D;epoch=type(mission)=='table'and mission.epoch or nil
  end
  if type(D)~='table'or call(D.ready)~=true or type(mission)~='table'or mission.in_mission~=true then clear();return end
  if now>=next_read then
   next_read=now+.2
   rows=read(D,now)or{}
   local after=call(D.mission)
   if rawget(_G,'HD2Data')~=D or call(D.ready)~=true or type(after)~='table'or after.epoch~=epoch or after.in_mission~=true then rows={}end
  end
  if E.Window and call(E.Window.show_cursor)==true then key=nil;c.clear();c.commit();return end
  local screen=c.screen();if not screen then return end
  local parts={screen.w,screen.h,tostring(epoch)}
  for _,p in ipairs(rows)do parts[#parts+1]=table.concat({p.peer,p.slot,p.y,tostring(p.known),tostring(p.none),p.booster or'',tostring(p.id)},':')end
  local k=table.concat(parts,'/')
  if k~=key then
   c.clear();key=k
   for _,p in ipairs(rows)do icon.draw(c,p,cfg.icon_center_x,p.y,cfg.icon_size)end
   if logged~=k then
    logged=k
    for _,p in ipairs(rows)do if log then log('BOOSTER peer='..p.peer..' name='..tostring(p.name)..' slot='..p.slot
     ..' native_index='..tostring(p.native_index)..' local='..tostring(p.is_local)..' known='..tostring(p.known)..' booster='..tostring(p.booster)..' none='..tostring(p.none)
     ..' center='..cfg.icon_center_x..','..p.y)end end
   end
  end
  c.commit()
 end
 function R.shutdown()identity.reset();rows={};key=nil;provider=nil;epoch=nil;c.shutdown()end
 return R
end
return M
