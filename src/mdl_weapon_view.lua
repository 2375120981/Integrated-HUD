local M={}
local cfg=require('mods/integrated_hud/mdl_gamesession/layout')
local icons=require('mods/integrated_hud/mdl_gamesession/mode_images')
local canvas=require('mods/integrated_hud/mdl_gamesession/mdl_canvas')
local white={218,222,219}
local function number(v)return type(v)=='number'and string.format('%.0f',v)or'--'end
function M.new(log)
 local c=canvas.new(50,'reference',log,90);local R={}
 local key=nil
 function R.update(v,scale,ammo_scale)
  local screen=c.screen();if not screen then return end
  local k=table.concat({screen.w,screen.h,scale,ammo_scale,v.state,tostring(v.entity),v.kind or'',number(v.rounds),number(v.mags),
   number(v.heat_percent),tostring(v.overheated),tostring(v.ratio and math.floor(v.ratio*200+.5)),v.mode or'',v.rpm or'',v.safety or''},'/')
  if k~=key then
   c.clear();key=k
   if v.state=='READY'then
    local cx,cy=screen.w/2,screen.h/2
    local function triangle(x1,y1,x2,y2,x3,y3,alpha,color)
     c.add('triangle',cx+x1*scale,cy-y1*scale,cx+x2*scale,cy-y2*scale,cx+x3*scale,cy-y3*scale,
      {color[1],color[2],color[3],math.floor(alpha*255)})
    end
    local function band(outer,inner,f,alpha,color)
     for i=1,cfg.segments do
      local lo=(i-1)/cfg.segments;local hi=math.min(i/cfg.segments,f)
      local opacity=alpha
      -- Keep the arc's primitive count constant so MDL updates shapes in place.
      if hi<=lo then hi=i/cfg.segments;opacity=0 end
       local a=math.rad(cfg.start_degrees+(cfg.end_degrees-cfg.start_degrees)*lo)
       local b=math.rad(cfg.start_degrees+(cfg.end_degrees-cfg.start_degrees)*hi)
       local x0,y0=math.cos(a)*outer,math.sin(a)*outer;local x1,y1=math.cos(b)*outer,math.sin(b)*outer
       local x2,y2=math.cos(a)*inner,math.sin(a)*inner;local x3,y3=math.cos(b)*inner,math.sin(b)*inner
       triangle(x0,y0,x1,y1,x2,y2,opacity,color);triangle(x1,y1,x3,y3,x2,y2,opacity,color)
     end
    end
    local outer=cfg.radius+2;local inner=outer-cfg.thickness
    band(outer+1,inner-1,1,.75,{0,0,0});band(outer,inner,1,.18,white)
    band(outer,inner,math.max(0,math.min(1,v.ratio or 0)),.95,v.kind=='heat'and(v.overheated and{235,60,45}or{236,190,72})or white)
    local function text(s,x,y,size,center)
     local xx,yy=cx+x*scale,cy-y*scale
     c.add('text',s,xx+scale,yy+scale,{size=size*scale,color={0,0,0,200},align=center and'center'or'left',valign='middle'})
     c.add('text',s,xx,yy,{size=size*scale,color=white,align=center and'center'or'left',valign='middle'})
    end
    text(v.kind=='heat'and(number(v.heat_percent)..'%')or(number(v.rounds)..' / '..number(v.mags)),
     cfg.count_x,cfg.count_y,cfg.number_height*(v.kind=='heat'and 1 or ammo_scale),true)
    local row=0
    for mode in ((v.mode or'')..'  '):gmatch('(.-)  ')do if mode~=''then
     local x,y=cfg.label_x,cfg.label_y-row*42
     local image=icons[mode]
     if image then c.add('image',image,cx+(x-17)*scale,cy-(y+17)*scale,34*scale,34*scale,{color=white})
     else text(mode,x,y,cfg.mode_height,false)end
     row=row+1
    end end
    for _,s in ipairs({v.safety or'',v.rpm or''})do if s~=''then
     text(s,cfg.label_x,cfg.label_y-row*42,cfg.mode_height,false);row=row+1
    end end
   end
  end
  c.commit()
 end
 function R.hide()c.clear();key=nil;c.commit()end
 function R.shutdown()c.shutdown();key=nil end
 return R
end
return M
