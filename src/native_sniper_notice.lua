-- Persistent, independent startup-result notice; visible in menus and gameplay.
local M={}
M.messages={
 apply={
  '狙击枪准星成功启用，重启以应用更改',
  '此提示在勾选启用/关闭狙击枪准星时出现',
  '此功能为一次性功能，启用或禁用后',
  '即可在管理器中取消这一项的选择',
  '准星状态仍会保持'
 },
 restore={
  '狙击枪准星成功禁用，重启以应用更改',
  '此提示在勾选启用/关闭狙击枪准星时出现',
  '此功能为一次性功能，启用或禁用后',
  '即可在管理器中取消这一项的选择',
  '准星状态仍会保持'
 },
 pending={'正在检查狙击枪准星配置，请稍候','完成前请勿退出游戏；成功后将提示重启'},
 failed={'狙击枪准星操作未成功','请查看 IntegratedHUD-NativeSniper.log','数据不兼容时可退出游戏后使用随包独立修复工具'},
 deferred={'狙击枪准星任务需重新启动游戏后执行','管理器选项部署后，请重启游戏','MDL 局内启停不能执行这项一次性操作'}
}
local function call(fn,...)
 if type(fn)~='function'then return nil end
 local ok,a,b=pcall(fn,...);if ok then return a,b end
end
function M.new(E,mode)
 local A,W,Q=E.Application,E.World,E.Gui
 local gui,world,ids,key=nil,nil,{},nil
 local retry=0
 local function live(worlds,w)for _,v in pairs(worlds or{})do if v==w then return true end end;return false end
 local function clear()
  for _,id in ipairs(ids)do call(Q.destroy_triangle,gui,id)end
  ids={};key=nil
 end
 local function triangle(x1,y1,x2,y2,x3,y3,a,c)
  local uv=E.Vector2(.5,0)
  local id=Q.triangle(gui,E.Vector3(x1,0,y1),E.Vector3(x2,0,y2),E.Vector3(x3,0,y3),999,
   E.Color(math.floor(a*255),c[1],c[2],c[3]),'mods/driver_hud/solid',uv,uv,uv)
  assert(id~=nil and id~=false,'sniper notice triangle failed');ids[#ids+1]=id
 end
 local index=require('mods/integrated_hud/mdl_gamesession/network_font_index')
 local font=require('mods/integrated_hud/mdl_gamesession/network_text').new(index,triangle)
 local R={}
 function R.update(state,now)
  local worlds=call(A.worlds)
  if type(worlds)~='table'then return end
  if gui and not live(worlds,world)then gui,world,ids,key=nil,nil,{},nil end
  if not gui then
   if now<retry then return end;retry=now+1
   local main=call(A.main_world)
   for _,w in pairs(worlds)do if w~=main then
    gui=call(W.create_screen_gui,w,'scale',1,1);if gui then world=w;break end
   end end
   if not gui and live(worlds,main)then gui=call(W.create_screen_gui,main,'scale',1,1);if gui then world=main end end
   if not gui then return end
  end
  local width,height=call(A.back_buffer_size)
  if type(width)~='number'or type(height)~='number'or width<=0 or height<=0 or width~=width or height~=height or width==math.huge or height==math.huge then return end
  local next_key=state..'/'..width..'/'..height
  if key==next_key then return end
  clear()
  local lines=state=='success'and M.messages[mode]or M.messages[state]
  if not lines then return end
  local scale=math.min(width/1920,height/1080)
  local title_size,body_size=32*scale,24*scale
  local available=width*.92
  local panel_width=0
  for i,text in ipairs(lines)do panel_width=math.max(panel_width,math.min(available,font.width(text,i==1 and title_size or body_size)))end
  panel_width=panel_width+48*scale
  local line_height=46*scale;local panel_height=(#lines-1)*line_height+76*scale
  local x,y=(width-panel_width)/2,(height-panel_height)/2
  triangle(x,y,x+panel_width,y,x,y+panel_height,.88,{0,0,0})
  triangle(x+panel_width,y,x+panel_width,y+panel_height,x,y+panel_height,.88,{0,0,0})
  for i,text in ipairs(lines)do
   font.text(gui,nil,text,width/2,height/2+(#lines+1-2*i)*line_height/2,
    i==1 and title_size or body_size,i==1 and(state=='success'and{175,245,175}or{255,210,100})or{240,240,240},true,1,available)
  end
  key=next_key
 end
 function R.shutdown()
  if gui and live(call(A.worlds),world)then clear();call(W.destroy_gui,world,gui)end
  gui,world,ids,key=nil,nil,{},nil
 end
 return R
end
return M
