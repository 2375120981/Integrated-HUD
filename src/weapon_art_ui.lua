-- Self-contained Monocraft glyphs and bundled mode art. Only the proven solid
-- triangle renderer is used: no Gui.text, Gui.bitmap or native icon lookup.
local Module={}
function Module.new(art,triangle,log)
 local R={pending=false};local warned={}
 function R.begin()end
 local function rect(x,y,w,h,a,c)
  triangle(x,y,x+w,y,x,y+h,a,c);triangle(x+w,y,x+w,y+h,x,y+h,a,c)
 end
 function R.text(_,_,text,x,y,height,color,center,alpha)
  if not text or text==''then return 0 end
  local width=0
  for i=1,#text do local g=art.glyphs[text:sub(i,i)];width=width+(g and g.advance or .6)*height end
  local origin=center and x-width/2 or x
  local function paint(dx,dy,a,c)
   local at=origin+dx;local baseline=y-height/2+dy
   for i=1,#text do
    local g=art.glyphs[text:sub(i,i)]
    if g then
     for _,t in ipairs(g.triangles)do
      triangle(at+t[1]*height,baseline+t[2]*height,at+t[3]*height,baseline+t[4]*height,at+t[5]*height,baseline+t[6]*height,a,c)
     end
    end
    at=at+(g and g.advance or .6)*height
   end
  end
  local shadow=math.max(1,height/18)
  paint(shadow,-shadow,.8*alpha,{0,0,0});paint(0,0,.96*alpha,color)
  return width
 end
 function R.icon(_,_,name,x,y,size,alpha)
  local icon=art.icons[name]
  if not icon then
   if not warned[name]then warned[name]=true;log('BUNDLED_ICON unknown_mode='..name)end
   return false
  end
  -- Fit the full silhouette inside the same square. Tall FLAK is unchanged;
  -- wide APHET is reduced proportionally instead of growing beyond the slot.
  local scale=size/math.max(1,icon.aspect)
  local ox,oy=x-icon.aspect*scale/2,y-scale/2
  for _,r in ipairs(icon.rects)do
   local xx,yy=ox+r[1]*scale,oy+r[2]*scale
   rect(xx+1,yy-1,r[3]*scale,r[4]*scale,.8*alpha*r[5]/255,{0,0,0})
  end
  for _,r in ipairs(icon.rects)do
   rect(ox+r[1]*scale,oy+r[2]*scale,r[3]*scale,r[4]*scale,alpha*r[5]/255,{218,222,219})
  end
  return true
 end
 return R
end
return Module
