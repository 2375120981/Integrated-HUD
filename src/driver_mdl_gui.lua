-- Local presentation adapter for DRIVER's retained IDs. All drawing is MDL3.gui.
-- Network/seat acquisition remains in the credited vehicle core.
local M={}
function M.new(log)
 local canvas=require('mods/integrated_hud/mdl_gamesession/mdl_canvas')
 local live={};local R={Gui={},World={}}
 function R.World.create_screen_gui()
  if not canvas.api()then return nil end
  local c=canvas.new(40,'pixels',log,80);live[c]=true;return c
 end
 function R.World.destroy_gui(_,c)if c then c.shutdown();live[c]=nil end end
 function R.Gui.triangle(c,a,b,d,_,color)
  local screen=c.screen();if not screen then return nil end
  return c.add('triangle',a[1],screen.h-a[3],b[1],screen.h-b[3],d[1],screen.h-d[3],color)
 end
 function R.Gui.destroy_triangle(c,id)c.remove(id)end
 R.Gui.destroy_text=R.Gui.destroy_triangle
 function R.number(c,label,x,y,size,alpha,color,anchor)
  local screen=c and c.screen();if not screen then return false end
  color=color or{255,255,255}
  local height=size*1.5 -- 75% of 0.8.1's 2x health text.
  local align='left'
  if anchor=='center'then
   -- Measure at the final font size and place the left edge explicitly.
   -- Keep the vehicle's geometric center, independent of the label's length.
   local width=c.measure(label,height)
   if type(width)=='number'and width==width and width>0 and width<10000 then x=x-width/2
   else align='center'end
  end
  local options={size=height,color={color[1],color[2],color[3],math.floor(alpha*255)},
   align=align,valign=anchor=='center'and'middle'or'bottom'}
  return c.add('text',label,x,screen.h-y,options)
 end
 function R.Gui.text(c,label,_,size,__,pos,color)
  local screen=c.screen();if not screen then return nil end
  return c.add('text',label,pos[1],screen.h-pos[2],{size=size,color=color,valign='bottom'})
 end
 function R.flush()for c in pairs(live)do c.commit()end end
 function R.shutdown()for c in pairs(live)do c.shutdown()end;live={}end
 return R
end
return M
