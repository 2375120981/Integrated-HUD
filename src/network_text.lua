-- Fusion Pixel OFL bitmap pages, loaded only for characters actually displayed.
local M={}
local BASE='mods/integrated_hud/mdl_gamesession/'
local utf8=require('mods/integrated_hud/mdl_gamesession/utf8_text')
function M.new(index,triangle)
 local R={};local pages,cache={},{}
 local function glyph(cp)
  if cache[cp]then return cache[cp]end
  local page=string.format('%x',math.floor(cp/256))
  if pages[page]==nil then
   pages[page]=index.pages[page]and require(BASE..'network_font_'..page)or false
  end
  local data=pages[page]and pages[page][string.format('%x',cp)]
  if not data then
   if cp~=63 then return glyph(63)end
   return {advance=6,rects={}}
  end
  local adv,w,h,ox,oy,bits=data[1],data[2],data[3],data[4],data[5],data[6]
  local rects,active={},{};local digits=math.ceil(w/8)*2
  for row=0,h-1 do
   local value=tonumber(bits:sub(row*digits+1,(row+1)*digits),16)or 0
   local next_active={};local x=0
   while x<w do
    local function on(col)return math.floor(value/2^(math.ceil(w/8)*8-1-col))%2==1 end
    if not on(x)then x=x+1 else
     local first=x;x=x+1;while x<w and on(x)do x=x+1 end
     local key=first..':'..x;local r=active[key]
     if r then r[2]=oy+row;r[4]=r[4]+1 else
      r={ox+first,oy+row,x-first,1};rects[#rects+1]=r
     end
     next_active[key]=r
    end
   end
   active=next_active
  end
  local g={advance=adv,rects=rects};cache[cp]=g;return g
 end
 function R.width(text,height)
  local chars=utf8.split(text);if not chars then return 0 end
  local width=0;for _,c in ipairs(chars)do width=width+glyph(c.code).advance end
  return width*height/index.size
 end
 function R.prefix(text,max_width,height)
  local chars=utf8.split(text);if not chars then return '',0 end
  local out,width={},0;local scale=height/index.size
  for _,c in ipairs(chars)do
   local advance=glyph(c.code).advance*scale
   if width+advance>max_width+1e-6 then break end
   out[#out+1]=c.text;width=width+advance
  end
  return table.concat(out),width
 end
 function R.text(_,_,text,x,y,height,color,center,alpha,max_width)
  local chars=utf8.split(text);if not chars or #chars==0 then return 0 end
  local gs,width={},0
  for _,c in ipairs(chars)do local g=glyph(c.code);gs[#gs+1]=g;width=width+g.advance end
  local scale=height/index.size
  if max_width and width*scale>max_width then scale=max_width/width end
  local origin=center and x-width*scale/2 or x
  local baseline=y-(index.ascent-index.descent)*scale/2
  local function paint(dx,dy,a,c)
   local at=origin+dx
   for _,g in ipairs(gs)do
    for _,r in ipairs(g.rects)do
     local xx=at+r[1]*scale;local yy=baseline-(r[2]+1)*scale+dy
     local w,h=r[3]*scale,r[4]*scale
     triangle(xx,yy,xx+w,yy,xx,yy+h,a,c)
     triangle(xx+w,yy,xx+w,yy+h,xx,yy+h,a,c)
    end
    at=at+g.advance*scale
   end
  end
  local shadow=height/14
  paint(shadow,-shadow,.8*alpha,{0,0,0});paint(0,0,.96*alpha,color)
  return width*scale
 end
 return R
end
return M
