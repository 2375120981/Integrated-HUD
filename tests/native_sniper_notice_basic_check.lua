-- Finite check of the real bilingual notice renderer, without running the game.
local pool,serial={},0
local width,height=1920,1080
local E={Application={},World={},Gui={}}
E.Application.worlds=function()return {'world'}end
E.Application.main_world=function()return 'world'end
E.Application.back_buffer_size=function()return width,height end
E.World.create_screen_gui=function()return 'notice_gui'end
E.World.destroy_gui=function()assert(next(pool)==nil)end
E.Vector2=function(...)return {...}end;E.Vector3=E.Vector2;E.Color=E.Vector2
E.Gui.triangle=function(_,a,b,c,layer)
 assert(layer==999,'notice not drawn above HUD')
 serial=serial+1;pool[serial]={a,b,c};return serial
end
E.Gui.destroy_triangle=function(_,id)assert(pool[id]);pool[id]=nil end
local modules={}
local env=setmetatable({},{__index=_G});env._G=env
env.require=function(name)
 if modules[name]then return modules[name]end
 local fn=assert(loadstring(assert(SOURCES[name],name)));setfenv(fn,env);modules[name]=fn();return modules[name]
end
local M=env.require('mods/integrated_hud/native_sniper_notice')
assert(M.messages.apply[1]:find('成功启用',1,true))
assert(M.messages.restore[1]:find('成功禁用',1,true))
local utf8=env.require('mods/integrated_hud/mdl_gamesession/utf8_text')
local index=env.require('mods/integrated_hud/mdl_gamesession/network_font_index')
for _,lines in pairs(M.messages)do for _,text in ipairs(lines)do
 for _,c in ipairs(assert(utf8.split(text)))do
  local page=string.format('%x',math.floor(c.code/256))
  assert(index.pages[page],'missing font page')
  local data=env.require('mods/integrated_hud/mdl_gamesession/network_font_'..page)
  assert(data[string.format('%x',c.code)],'notice character missing from font')
 end
end end
local r=M.new(E,'apply')
r.update('pending',0);assert(next(pool),'pending notice absent')
r.update('success',1);assert(next(pool),'success notice absent')
local previous=serial;r.update('success',2);assert(serial==previous,'cached notice recreated')
local first=serial-#(function()local t={}for id in pairs(pool)do t[#t+1]=id end;return t end)()+1
local panel=pool[first]
assert(panel and math.abs((panel[1][1]+panel[2][1])/2-width/2)<1e-6,'notice not centered horizontally')
assert(math.abs((panel[1][3]+panel[3][3])/2-height/2)<1e-6,'notice not centered vertically')
width,height=1280,720;r.update('success',3);assert(serial>previous,'resolution change not applied')
r.shutdown();assert(next(pool)==nil,'notice not removed on shutdown')
return {native_notice_centered=true,native_notice_chinese_font=true,native_notice_cached_and_cleanup=true}
