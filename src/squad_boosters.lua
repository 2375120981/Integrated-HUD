-- Player-specific boosters, not the team's aggregate effects. Hub-only reads.
local M={}
local function call(f,...)if type(f)=='function'then local ok,a=pcall(f,...);if ok then return a end end end
local function peer(v)return type(v)=='string'and v:match('^%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x$')and v:lower()or nil end
local function slot(v)return type(v)=='number'and v>=0 and v<=3 and v==math.floor(v)end
function M.new(E,log)
 local cfg=require('mods/integrated_hud/mdl_gamesession/booster_layout')
 local images=require('mods/integrated_hud/mdl_gamesession/booster_images')
 local c=require('mods/integrated_hud/mdl_gamesession/mdl_canvas').new(45,'reference',log,88)
 local R={};local next_read=0;local provider=nil;local epoch=nil;local rows={};local key=nil;local logged=nil
 local function clear()rows={};key=nil;c.clear();c.commit()end
 local function read(D)
  local roster=call(D.players,false);local buffs=call(D.buffs)
  if type(roster)~='table'or type(buffs)~='table'or type(buffs.players)~='table'then return nil end
  local effects={};local seen={};local slots={};local local_player=nil;local remotes={};local count=0
  for _,p in pairs(buffs.players)do
   if type(p)~='table'then return nil end
   local id=peer(p.peer)
   if not id or effects[id]then return nil end
   effects[id]=p
  end
  for _,p in pairs(roster)do
   if type(p)~='table'then return nil end
   local id=peer(p.peer)
   if not id or seen[id]or not slot(p.slot)or slots[p.slot]or type(p.is_local)~='boolean'then return nil end
   seen[id]=true;slots[p.slot]=true;count=count+1;if count>4 then return nil end
   local b=effects[id]
   local row={peer=id,slot=p.slot,name=p.name,is_local=p.is_local,known=b~=nil}
   if b then
    if b.is_local~=p.is_local or b.slot~=p.slot then return nil end
    if b.booster~=nil and type(b.booster)~='table'then return nil end
    local booster=b.booster
    row.none=booster==nil or booster.id==0 or booster.name=='None'or booster.name=='Count'
    if not row.none then row.booster=booster.name;row.id=booster.id end
   end
   if p.is_local then if local_player then return nil end;local_player=row else remotes[#remotes+1]=row end
  end
  if not local_player then return nil end
  table.sort(remotes,function(a,b)return a.slot<b.slot end)
  local out={}
  for i,p in ipairs(remotes)do
   p.y=cfg.last_teammate_tag_center_y-(#remotes-i)*cfg.teammate_row_spacing-cfg.above_tag_center
   out[#out+1]=p
  end
  local_player.y=cfg.local_tag_center_y-cfg.above_tag_center;out[#out+1]=local_player
  return out
 end
 local function hexagon(x,y,size,color)
  local r=size/2;local h=r*math.sqrt(3)/2
  local p={{x-r,y},{x-r/2,y-h},{x+r/2,y-h},{x+r,y},{x+r/2,y+h},{x-r/2,y+h}}
  for i,a in ipairs(p)do local b=p[i%6+1];c.add('line',a[1],a[2],b[1],b[2],size*.07,color)end
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
   rows=read(D)or{}
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
   for _,p in ipairs(rows)do if p.known then
    local x,y,size=cfg.icon_center_x,p.y,cfg.icon_size
    local image=p.booster and images[p.booster]
    if p.none then hexagon(x,y,size,{218,222,219,230})
    elseif image then c.add('image',image,x-size/2,y-size/2,size,size)
    else
     hexagon(x,y,size,{255,221,31,240})
     c.add('text','?',x,y,{size=size*.6,align='center',valign='middle',color={255,221,31}})
    end
   end end
   if logged~=k then
    logged=k
    for _,p in ipairs(rows)do if log then log('BOOSTER peer='..p.peer..' name='..tostring(p.name)..' slot='..p.slot
     ..' local='..tostring(p.is_local)..' known='..tostring(p.known)..' booster='..tostring(p.booster)..' none='..tostring(p.none)
     ..' center='..cfg.icon_center_x..','..p.y)end end
   end
  end
  c.commit()
 end
 function R.shutdown()rows={};key=nil;provider=nil;epoch=nil;c.shutdown()end
 return R
end
return M
