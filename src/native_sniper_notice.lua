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
function M.new(E,mode,log)
 local c=require('mods/integrated_hud/mdl_gamesession/mdl_canvas').new(98,'reference',log)
 local key=nil;local R={}
 function R.update(state,now)
  local screen=c.screen();if not screen then return end
  local k=state..'/'..screen.w..'/'..screen.h
  if key~=k then
   c.clear();key=k
   local lines=state=='success'and M.messages[mode]or M.messages[state]
   if lines then
    local width=0
    for i,text in ipairs(lines)do width=math.max(width,c.measure(text,i==1 and 32 or 24)or 0)end
    width=math.min(screen.w*.94,width+48)
    local height=(#lines-1)*46+76
    c.add('rect',(screen.w-width)/2,(screen.h-height)/2,width,height,{0,0,0,224})
    for i,text in ipairs(lines)do
     c.add('text',text,screen.w/2,screen.h/2+(2*i-#lines-1)*23,
      {size=i==1 and 32 or 24,align='center',valign='middle',max_width=screen.w*.92,
       color=i==1 and(state=='success'and{175,245,175}or{255,210,100})or{240,240,240}})
    end
   end
  end
  c.commit()
 end
 function R.shutdown()c.shutdown();key=nil end
 return R
end
return M
