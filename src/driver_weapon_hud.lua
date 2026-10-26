-- Separate retained foot-view handles on the original DRIVER screen GUI.
do
 local data=require('mods/integrated_hud/driver_reference/weapon_data')
 local cfg=require('mods/integrated_hud/driver_reference/weapon_layout')
 local log_next=0
 local function note(text)
  pcall(function()
   local base=os.getenv('APPDATA');if not base then return end
   local f=io.open(base..'/Arrowhead/Helldivers2/IntegratedHUD-Weapon-0.3.11.log','a')
   if f then f:write(text..'\n');f:close()end
  end)
 end
 local reader=require('mods/integrated_hud/driver_reference/weapon_reader').new(sr,data,note)
 local groups,owner,owner_world,last_tick={},nil,nil,-1
 local latest_worlds=nil
 local c={}
 local function erase()
  if owner and owner==M.gui and live(latest_worlds,owner_world)then
   for _,group in pairs(groups)do for _,p in ipairs(group.ids)do call(Gui[p[1]],owner,p[2])end end
  end
  groups={};owner=nil;owner_world=nil
 end
 local function draw_group(name,signature,fn)
  local old=groups[name]
  if old and old.key==signature then return end
  if old then for _,p in ipairs(old.ids)do call(Gui[p[1]],owner,p[2])end end
  local saved=M.ids;M.ids={}
  local ok,err=pcall(fn)
  groups[name]={ids=M.ids,key=ok and signature or nil};M.ids=saved
  if not ok then error(err,0)end
 end
 M.integrated_weapon_hide=function()erase();reader.hide()end
 M.integrated_weapon_begin=function(worlds,world)
  latest_worlds=worlds
  if reader.capture_inputs then reader.capture_inputs(M.clock,world)end
  if owner and(owner~=M.gui or not live(worlds,owner_world))then groups={};owner=nil end
  if M.clock-last_tick>.35 then erase();reader.hide()end
 end
 local presentation=require('mods/integrated_hud/driver_reference/weapon_presentation')
 local art=require('mods/integrated_hud/driver_reference/weapon_art')
 local native=require('mods/integrated_hud/driver_reference/weapon_art_ui').new(art,FRV.triangle,note)
 local function emit(kind,id)remember(kind,id)end
 local function label(text,x,y,height,color,center)
  return native.text(M.gui,emit,text,x,y,height,color,center,C.alpha)
 end
 local function arc(cx,cy,r,ratio,color,scale)
  if type(ratio)~='number'then return end
  local n=cfg.segments;local fraction=math.max(0,math.min(1,ratio))
  local outer=r+2*scale;local inner=outer-cfg.thickness*scale
  -- HUD+ ring geometry: annular quads, two triangles per segment, black
  -- expanded outline, and a partially filled final segment. Our material and
  -- retained GUI handles come from the already working DRIVER renderer.
  local function band(ro,ri,f,a,c)
   for i=1,n do
    local lo=(i-1)/n;local hi=math.min(i/n,f)
    if hi>lo then
     local a0=math.rad(cfg.start_degrees+(cfg.end_degrees-cfg.start_degrees)*lo)
     local a1=math.rad(cfg.start_degrees+(cfg.end_degrees-cfg.start_degrees)*hi)
     local x0,y0=cx+math.cos(a0)*ro,cy+math.sin(a0)*ro
     local x1,y1=cx+math.cos(a1)*ro,cy+math.sin(a1)*ro
     local x2,y2=cx+math.cos(a0)*ri,cy+math.sin(a0)*ri
     local x3,y3=cx+math.cos(a1)*ri,cy+math.sin(a1)*ri
     FRV.triangle(x0,y0,x1,y1,x2,y2,a*C.alpha,c)
     FRV.triangle(x1,y1,x3,y3,x2,y2,a*C.alpha,c)
    end
   end
  end
  band(outer+scale,inner-scale,1,.75,{0,0,0})
  band(outer,inner,1,.18,color)
  band(outer,inner,fraction,.95,color)
 end
 M.integrated_weapon_tick=function(session,avatar,worlds,world,owned_ids,motion,where,state)
  latest_worlds=worlds;last_tick=M.clock
  c.session=session;c.avatar=avatar;c.peer=M.peer;c.world=world;c.owned_ids=owned_ids
  c.owned_set=M.owned_cache and M.owned_cache.set or{}
  c.motion=motion;c.where=where;c.state=state
  local good,v=pcall(reader.update,M.clock,c)
  if not good then
   erase()
   if M.clock>=log_next then log_next=M.clock+5;note('WEAPON_READ_ERROR '..tostring(v))end
   return
  end
  if not v or v.reloading or motion~=true or where~=100 or state~=0 or sr.Window and call(sr.Window.show_cursor)==true then erase();return end
  if not ensure_gui(worlds,world)then erase();return end
  local w,h=call(App.back_buffer_size);if type(w)~='number'or type(h)~='number'then erase();return end
  local function quant(x)return x and math.floor(x*200+.5)or -1 end
  -- One geometry slot, selected by state; zero is a valid progress value.
  local ratio,color,kind
  if type(v.heat_ratio)=='number'then
   ratio=v.heat_ratio;color=v.overheated and{235,60,45}or{236,190,72};kind='heat'
  else
   ratio=v.ammo_ratio;color={218,222,219};kind='ammo'
  end
  if owner and owner~=M.gui then erase()end
  owner=M.gui;owner_world=M.gui_world
  local base=table.concat({w,h,C.alpha},':')
  local ok,err=pcall(function()
   local s=math.min(w/1920,h/1080);local x,y=w/2,h/2
   draw_group('arc',base..':'..kind..':'..quant(ratio)..':'..tostring(v.overheated),function()
    arc(x,y,cfg.radius*s,ratio,color,s)
   end)
   local white={218,222,219}
   draw_group('modes',base..':'..(v.weapon_mode or '')..':'..(v.setting or '')..':'..(v.functional_status or ''),function()
   local row=0
   local mode=v.weapon_mode or ''
   for name in (mode..'  '):gmatch('(.-)  ')do if name~=''then
    native.icon(M.gui,emit,name,x+cfg.label_x*s,y+(cfg.label_y-row*42)*s,presentation.icon_size*s,C.alpha)
    row=row+1
   end end
   if v.functional_status and v.functional_status~=''then
    label(v.functional_status,x+cfg.label_x*s,y+(cfg.label_y-row*42)*s,cfg.mode_height*s,white)
    row=row+1
   end
   if v.setting and v.setting~=''then
    label(v.setting,x+cfg.label_x*s,y+(cfg.label_y-row*42)*s,cfg.mode_height*s,white)
   end
   end)
   draw_group('count',base..':'..tostring(v.rounds)..':'..tostring(v.reserve)..':'..tostring(v.heat_percent),function()
   if v.rounds then
    local width=label(tostring(v.rounds),x+cfg.count_x*s,y+cfg.count_y*s,cfg.number_height*s,white,true)
    if v.reserve~=nil then label('/ '..tostring(v.reserve),x+cfg.count_x*s+width/2+12*s,y+cfg.count_y*s,cfg.reserve_height*s,white)end
   elseif v.heat_percent then
    label(tostring(v.heat_percent)..'%',x+cfg.count_x*s,y+cfg.count_y*s,cfg.number_height*s,white,true)
   end
   end)
  end)
  if not ok then erase();if M.clock>=log_next then log_next=M.clock+5;note('WEAPON_DRAW_ERROR '..tostring(err))end end
 end
 local reset=full_reset
 full_reset=function()M.integrated_weapon_hide();return reset()end
 note('WEAPON_START version=0.3.11 reader=NarrowHUD_1.0.5_sensor host=independent cold_model_confirmation=true font=monocraft_geometry modes=bundled_geometry firemode_display=false reload=hidden anchor=screen_center')
end
