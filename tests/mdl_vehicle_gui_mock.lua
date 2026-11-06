-- Supply the documented MDL GUI contract to the existing vehicle workflow.
-- Engine-GUI functions below exist only in this offline harness, as counters.
local mdl_modules={}
local original_require=env.require
env.require=function(name)
 if name=='mods/integrated_hud/mdl_gamesession/driver_mdl_gui'or name=='mods/integrated_hud/mdl_gamesession/mdl_canvas'then
  if not mdl_modules[name]then
   local fn=assert(loadstring(SOURCES[name]));setfenv(fn,env);mdl_modules[name]=fn()
  end
  return mdl_modules[name]
 end
 return original_require(name)
end
env.MDL3={gui={api=1,canvas=function(opts)
 local gui=W.create_screen_gui(world_overlay,'scale',1,1)
 local c={}
 function c:screen()return {w=1920,h=1080}end
 function c:measure(text,size)return #text*size*.6 end
 function c:status()return {font=true}end
 function c:begin()self.pending={}end
 function c:triangle(x1,y1,x2,y2,x3,y3,col)
  self.pending[#self.pending+1]={{x1,0,1080-y1},{x2,0,1080-y2},{x3,0,1080-y3},{col[4]or 255,col[1],col[2],col[3]}}
 end
 function c:text(label,x,y,options)
  local size=options.size;local width=#label*size*.6
  local x0=options.align=='center'and x-width/2 or x
  local yy=1080-y;local col=options.color
  self.pending[#self.pending+1]={{x0,0,yy},{x0+width,0,yy},{x0,0,yy+size/2},{col[4]or 255,col[1],col[2],col[3]}}
 end
 function c:finish()
  local old={};for id in pairs(pools[gui])do old[#old+1]=id end
  for _,id in ipairs(old)do Q.destroy_triangle(gui,id)end
  for _,p in ipairs(self.pending)do Q.triangle(gui,p[1],p[2],p[3],3,p[4],'mods/driver_hud/solid')end
 end
 function c:destroy()
  local old={};for id in pairs(pools[gui])do old[#old+1]=id end
  for _,id in ipairs(old)do Q.destroy_triangle(gui,id)end
  W.destroy_gui(world_overlay,gui)
 end
 return c
end}}
