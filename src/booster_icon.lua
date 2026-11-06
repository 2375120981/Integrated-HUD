local M={}
local images=require('mods/integrated_hud/mdl_gamesession/booster_images')
local function hexagon(c,x,y,size,color)
 local r=size/2;local h=r*math.sqrt(3)/2
 local p={{x-r,y},{x-r/2,y-h},{x+r/2,y-h},{x+r,y},{x+r/2,y+h},{x-r/2,y+h}}
 for i,a in ipairs(p)do local b=p[i%6+1];c.add('line',a[1],a[2],b[1],b[2],size*.07,color)end
end
function M.draw(c,p,x,y,size)
 if not p or not p.known then return end
 local image=p.booster and images[p.booster]
 if p.none then hexagon(c,x,y,size,{218,222,219,230})
 elseif image then c.add('image',image,x-size/2,y-size/2,size,size)
 else
  hexagon(c,x,y,size,{255,221,31,240})
  c.add('text','?',x,y,{size=size*.6,align='center',valign='middle',color={255,221,31}})
 end
end
function M.key(p)
 return p and table.concat({tostring(p.known),tostring(p.none),p.booster or'',tostring(p.id)},':')or'unknown'
end
return M
