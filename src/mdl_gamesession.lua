-- HD2-Addon: mods/integrated_hud/mdl_gamesession/main
-- MDL-managed validation entry. Only HD2Data supplies gameplay state.
local reader
local vehicles
local next_vehicle_error=0
local art=require('mods/integrated_hud/mdl_gamesession/font')
local text_ui=require('mods/integrated_hud/mdl_gamesession/art_ui')
local cfg=require('mods/integrated_hud/mdl_gamesession/layout')
local E=stingray
local App,W,Q=E.Application,E.World,E.Gui
local gui,world,groups,active=nil,nil,{},nil
local clock,next_poll,next_gui=0,0,0
local snapshot={state='WAIT HUB'}
local last_log,next_log,next_error=nil,0,0
local last_diag,next_diag=nil,0
local last_slots,next_slots=nil,0
local white,amber={218,222,219},{236,190,72}
local function call(fn,...)
 if type(fn)~='function'then return nil end
 local ok,a,b=pcall(fn,...);if ok then return a,b end
end
local function log(s)
 pcall(function()
  local base=os.getenv('APPDATA');if not base then return end
  local f=io.open(base..'/Arrowhead/Helldivers2/IntegratedHUD-MDL-0.5.4.log','a')
  if f then f:write(string.format('%.3f %s\n',clock,s));f:close()end
 end)
end
local function live(worlds,value)
 for _,w in pairs(worlds or{})do if w==value then return true end end
 return false
end
local function clear()
 for _,g in pairs(groups)do for _,id in ipairs(g.ids)do call(Q.destroy_triangle,gui,id)end end
 groups={}
end
local function dispose()
 local worlds=call(App.worlds)
 if gui and live(worlds,world)then clear();call(W.destroy_gui,world,gui)end
 gui=nil;world=nil;groups={};active=nil;next_gui=0
end
local function surface(worlds)
 if gui and live(worlds,world)then return true end
 gui=nil;world=nil;groups={}
 if clock<next_gui then return false end
 next_gui=clock+.5
 local main=call(App.main_world);local tried=0
 local function attempt(w)
  tried=tried+1
  local result=call(W.create_screen_gui,w,'scale',1,1)
  if result then gui=result;world=w;return true end
 end
 for _,w in pairs(worlds or{})do if w~=main and tried<4 and attempt(w)then return true end end
 return live(worlds,main)and attempt(main)or false
end
local function triangle(x1,y1,x2,y2,x3,y3,a,c)
 local uv=E.Vector2(.5,0)
 local id=Q.triangle(gui,E.Vector3(x1,0,y1),E.Vector3(x2,0,y2),E.Vector3(x3,0,y3),3,
  E.Color(math.floor(a*255),c[1],c[2],c[3]),'mods/driver_hud/solid',uv,uv,uv)
 assert(id~=nil and id~=false,'HUD triangle creation failed')
 active[#active+1]=id
end
local font=text_ui.new(art,triangle,log)
local function label(s,x,y,size,color,center)
 return font.text(gui,nil,s,x,y,size,color or white,center,1)
end
local function group(name,key,draw)
 local old=groups[name];if old and old.key==key then return end
 if old then for _,id in ipairs(old.ids)do call(Q.destroy_triangle,gui,id)end end
 local ids={};groups[name]={key=key,ids=ids};active=ids
 draw();active=nil
end
local function arc(cx,cy,s,ratio,color)
 local outer=(cfg.radius+2)*s;local inner=outer-cfg.thickness*s
 local function band(ro,ri,f,alpha,c)
  for i=1,cfg.segments do
   local lo=(i-1)/cfg.segments;local hi=math.min(i/cfg.segments,f)
   if hi>lo then
    local a=math.rad(cfg.start_degrees+(cfg.end_degrees-cfg.start_degrees)*lo)
    local b=math.rad(cfg.start_degrees+(cfg.end_degrees-cfg.start_degrees)*hi)
    local x0,y0=cx+math.cos(a)*ro,cy+math.sin(a)*ro
    local x1,y1=cx+math.cos(b)*ro,cy+math.sin(b)*ro
    local x2,y2=cx+math.cos(a)*ri,cy+math.sin(a)*ri
    local x3,y3=cx+math.cos(b)*ri,cy+math.sin(b)*ri
    triangle(x0,y0,x1,y1,x2,y2,alpha,c);triangle(x1,y1,x3,y3,x2,y2,alpha,c)
   end
  end
 end
 band(outer+s,inner-s,1,.75,{0,0,0});band(outer,inner,1,.18,white)
 band(outer,inner,ratio,.95,color or white)
end
local function id(v)return v~=nil and string.format('%.0f',v)or'-'end
local function frame(dt)
 clock=clock+(type(dt)=='number'and dt>0 and math.min(dt,.5)or 1/60)
 if vehicles then
  local ok,err=pcall(vehicles.update,dt)
  if not ok and clock>=next_vehicle_error then next_vehicle_error=clock+5;log('VEHICLE_ERROR '..tostring(err))end
 end
 local worlds=call(App.worlds)
 if gui and not live(worlds,world)then gui=nil;world=nil;groups={};next_gui=0 end
 if E.Window and call(E.Window.show_cursor)==true then if gui then clear()end;return end
 snapshot=reader.read(clock)
 if not surface(worlds)then return end
 local width,height=call(App.back_buffer_size)
 if type(width)~='number'or type(height)~='number'then return end
 local s=math.min(width/1920,height/1080);local cx,cy=width/2,height/2
 local v=snapshot;local base=width..'/'..height..'/'
 local key=table.concat({v.state,id(v.entity),v.kind or'',id(v.rounds),id(v.mags),id(v.heat_percent),
  tostring(v.overheated),tostring(v.ratio and math.floor(v.ratio*200+.5)),v.mode or'',v.rpm or'',v.safety or''},'/')
 if key~=last_log and clock>=next_log then last_log=key;next_log=clock+.5;log('WEAPON '..key)end
 group('weapon',base..key,function()
  if v.state~='READY'then return end
  local c=v.kind=='heat'and(v.overheated and{235,60,45}or amber)or white
  arc(cx,cy,s,v.ratio,c)
  local number=v.kind=='heat'and(id(v.heat_percent)..'%')or(id(v.rounds)..' / '..id(v.mags))
  label(number,cx+cfg.count_x*s,cy+cfg.count_y*s,cfg.number_height*s,white,true)
  local row=0
  for mode in ((v.mode or'')..'  '):gmatch('(.-)  ')do if mode~=''then
   local x,y=cx+cfg.label_x*s,cy+(cfg.label_y-row*42)*s
   if art.icons[mode]then font.icon(gui,nil,mode,x,y,34*s,1)
   else label(mode,x,y,cfg.mode_height*s,white)end
   row=row+1
  end end
  for _,text in ipairs({v.safety or'',v.rpm or''})do if text~=''then
   label(text,cx+cfg.label_x*s,cy+(cfg.label_y-row*42)*s,cfg.mode_height*s,white);row=row+1
  end end
 end)
end
local function stop()
 dispose()
 if vehicles then call(vehicles.shutdown);vehicles=nil end
 if reader then call(reader.shutdown);reader=nil end
 snapshot={state='DISABLED'}
end
return {
 name='集成HUD',version='0.5.4',author='2375120981',
 description='MDL加载；GameSession读取武器、背包和载具；无需HD2Data或Chef。',
 on_enable=function()
  stop()
  reader=require('mods/integrated_hud/mdl_gamesession/reader').new(E,log)
  reader.reset()
  vehicles=require('mods/integrated_hud/driver_reference/driver_core')()
  assert(vehicles and type(vehicles.update)=='function','vehicle module unavailable')
  log('START MDL managed; GameSession; NarrowHUD 2.0.0 sensor; vehicle+mech enabled')
 end,
 on_update=function(_,dt)
  if not reader then return end
  local ok,err=pcall(frame,dt)
  if not ok then dispose();if clock>=next_error then next_error=clock+5;log('ERROR '..tostring(err))end end
 end,
 on_disable=function()stop();log('STOP')end
}
