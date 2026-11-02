-- Independent RTT GUI stays visible in equipment screens and cursor-based menus.
local Module={}
local function call(f,...)if type(f)~='function'then return nil end;local ok,a,b=pcall(f,...);if ok then return a,b end end
function Module.new(E,log)
 local reader=require('mods/integrated_hud/mdl_gamesession/network_ping').new(E,log)
 local art=require('mods/integrated_hud/mdl_gamesession/network_font_index')
 local gui,world,ids,key=nil,nil,{},nil;local next_gui=0
 local A,W,Q=E.Application,E.World,E.Gui
 local white={218,222,219}
 local function live(worlds,w)for _,v in pairs(worlds)do if v==w then return true end end;return false end
 local function clear()
  for _,id in ipairs(ids)do call(Q.destroy_triangle,gui,id)end;ids={};key=nil
 end
 local function triangle(x1,y1,x2,y2,x3,y3,a,c)
  local uv=E.Vector2(.5,0)
  local id=Q.triangle(gui,E.Vector3(x1,0,y1),E.Vector3(x2,0,y2),E.Vector3(x3,0,y3),3,E.Color(math.floor(a*255),c[1],c[2],c[3]),'mods/driver_hud/solid',uv,uv,uv)
  assert(id~=nil and id~=false,'RTT triangle creation failed');ids[#ids+1]=id
 end
 local font=require('mods/integrated_hud/mdl_gamesession/network_text').new(art,triangle,log)
 local scale=1
 local position_x,position_y=0,50
 local function label(s,x,y,size,color,max_width)return font.text(gui,nil,s,x,y,size,color or white,false,1,max_width)end
 local R={}
 function R.set_scale(v)
  scale=type(v)=='number'and v==v and math.max(.5,math.min(1.5,v))or 1
 end
 local function percent(v,default)
  return type(v)=='number'and v==v and math.max(0,math.min(100,v))or default
 end
 function R.set_position(x,y)position_x=percent(x,0);position_y=percent(y,50)end
 function R.update(now)
  local v=reader.read(now)
  local worlds=call(A.worlds)
  if type(worlds)~='table'then return end
  if gui and not live(worlds,world)then gui,world,ids,key=nil,nil,{},nil end
  if v.state=='NO SESSION'then if gui then clear()end;return end
  if not gui then
   if now<next_gui then return end;next_gui=now+1
   local main=call(A.main_world)
   for _,w in pairs(worlds)do if w~=main then
    gui=call(W.create_screen_gui,w,'scale',1,1);if gui then world=w;break end
   end end
   if not gui and live(worlds,main)then gui=call(W.create_screen_gui,main,'scale',1,1);if gui then world=main end end
   if not gui then return end
  end
  local width,height=call(A.back_buffer_size)
  if type(width)~='number'or type(height)~='number'or width~=width or height~=height or width<=0 or height<=0 or width==math.huge or height==math.huge then return end
  local parts={width,height,v.state,tostring(v.local_slot),v.source or'',scale,position_x,position_y}
  for _,r in ipairs(v.rows)do parts[#parts+1]=r.peer..':'..(r.label or r.peer)..':'..tostring(r.ms)end
  local next_key=table.concat(parts,'/')
  if key==next_key then return end;clear()
  local s=math.min(width/1920,height/1080)*scale
  local lines=v.state=='READY'and #v.rows or 1
  local title=v.source=='CONNECTIONS'and'CONNECTION RTT'or'LOCAL RTT'
  local title_width=font.width(title,16*s)
  local status={['SESSION ONLY']='SESSION LIST: SELF',['WAIT PLAYER SCHEMA']='WAITING FOR SCHEMA',['WAIT SQUAD']='WAITING FOR SQUAD',
   ['CONFIRMING PLAYER IDS']='CONFIRMING IDS',['AMBIGUOUS PLAYER IDS']='AMBIGUOUS IDS',
   ['HUB REQUIRED']='ENABLE HD2 DATA HUB',['WAIT HUB']='WAITING FOR HUB',['WAIT MISSION']='WAITING FOR MISSION'}
  local message=status[v.state]or'WAITING FOR IDS'
  local panel_width=title_width
  if v.state=='READY'then
   for _,r in ipairs(v.rows)do
    panel_width=math.max(panel_width,title_width+8*s+font.width(r.ms and(r.ms..'ms')or'--',18*s))
   end
  else panel_width=math.max(panel_width,font.width(message,14*s))end
  -- Position percentages use the available area: 0/100 align with each edge.
  local x=math.max(0,width-panel_width-2*s)*position_x/100
  local half_height=(lines*27/2+12)*s
  local cy=half_height+math.max(0,height-2*half_height)*(1-position_y/100)
  local y=cy+lines*27*s/2
  label(title,x,y,16*s)
  if v.state=='READY'then
   local divider=x+title_width
   local top,bottom=y-17*s,y-lines*27*s-10*s
   if lines>0 then
    triangle(divider,bottom,divider+s,bottom,divider,top,.7,white)
    triangle(divider+s,bottom,divider+s,top,divider,top,.7,white)
   end
   for i,r in ipairs(v.rows)do
    local yy=y-i*27*s
    local name=font.prefix(r.label or r.peer,title_width-6*s,14*s)
    label(name,x,yy,14*s,white)
    local color=r.ms and(r.ms<100 and{170,235,185}or r.ms<200 and{255,215,100}or{255,125,110})or{190,190,190}
    label(r.ms and(r.ms..'ms')or'--',divider+8*s,yy,18*s,color)
   end
  else
   label(message,x,y-27*s,14*s)
  end
  key=next_key
 end
 function R.shutdown()
  reader.shutdown();local worlds=call(A.worlds)
  if gui and type(worlds)=='table'and live(worlds,world)then clear();call(W.destroy_gui,world,gui)end
  gui,world,ids,key=nil,nil,{},nil
 end
 return R
end
return Module
