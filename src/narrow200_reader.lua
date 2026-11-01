-- MDL-owned host for the licensed NarrowHUD 2.0.0 reading modules.
-- No Chef loader, HD2Data, FFI, hand-model scanner or global update hooks.
local Module={}
local function call(fn,...)
 if type(fn)~='function'then return nil end
 local ok,a,b,c=pcall(fn,...);if ok then return a,b,c end
end
local function finite(v)return type(v)=='number'and v==v and math.abs(v)<1e9 end
local function path()
 local base=os.getenv('APPDATA')
 return base and base..'/Arrowhead/Helldivers2/IntegratedHUD-Narrow200-learned.txt'
end
local STR={modes=true,poses=true,rpms=true,options1=true,rpmbase=true}
-- VG-70's selectable firing patterns are weapon functions, unlike the
-- ordinary auto/semi selector intentionally omitted for other weapons.
local VG70_MODES={[1]='AUTO',[4]='VOLLEY',[7]='TOTAL'}
local function load_table()
 local p=path();local f=p and io.open(p,'r');if not f then return nil end
 local out={_v=1}
 for line in f:lines()do
  local k,h,v=line:match('^(%w+)\t(%x%x%x%x%x%x%x%x)\t([%w.,%-]+)$')
  if k and #line<512 then
   local value=STR[k]and v or(v=='true'and true or tonumber(v))
   if v=='false'then value=false end
   if value~=nil then out[k]=out[k]or{};out[k][h]=value end
  end
 end
 f:close();return out
end
local function save_table(_,values)
 local p=path();if not p then return false end
 local rows={}
 for k,t in pairs(values)do if type(t)=='table'then for h,v in pairs(t)do
  if type(h)=='string'and h:match('^%x%x%x%x%x%x%x%x$')and(type(v)=='number'or type(v)=='boolean'or type(v)=='string')then
   rows[#rows+1]=k..'\t'..h..'\t'..tostring(v)..'\n'
  end
 end end end
 table.sort(rows);local f=io.open(p,'w');if not f then return false end
 f:write(table.concat(rows));f:close();return true
end
function Module.new(sr,log)
 local R={};local now,sensor=0,nil
 local context=nil;local units={}
 local G,U,W=sr.GameSession or{},sr.Unit or{},sr.World or{}
 local function live_world(w)
  local worlds=call((sr.Application or{}).worlds)
  for _,v in pairs(type(worlds)=='table'and worlds or{})do if v==w then return true end end
  return false
 end
 local function unit_ready(u)
  if not context or not units[u]then return false end
  if call(U.alive,u)~=true then return false end
  local n=call(U.num_scene_graph_items,u)
  return finite(n)and n==math.floor(n)and n>=2 and call(U.has_animation_state_machine,u)==true
 end
 local function engine(name,...)
  local group,key=name:match('^([^.]+)%.(.+)$');local api=sr[group]
  if group=='Unit'then
   local u=...
   if not unit_ready(u)then return nil end
  end
  return api and call(api[key],...)
 end
 local function player_unit()
  units={}
  local unit=nil
  local avatar=sensor and sensor.avatar();local player=sensor and sensor.player()
  local session=context and context.session
  if not avatar or player==nil or not session or not live_world(context.world)then return nil end
  if call(G.game_object_exists,session,player)~=true
   or call(G.game_object_is_type,session,player,'un6y1d')~=true then return nil end
  if call(G.game_object_field,session,player,'u4d1h9a')~=avatar
   or call(G.game_object_exists,session,avatar)~=true
   or call(G.game_object_is_type,session,avatar,'vvhx8ga')~=true then return nil end
  if call(G.game_object_field,session,avatar,'gls4w9b')~=100
   or call(G.game_object_field,session,avatar,'state')~=0 then return nil end
  local pos=call(G.game_object_field,session,avatar,'position');if not pos then return nil end
  local best,second=math.huge,math.huge
  for _,resource in ipairs({'4d1c334d294dfa97','d0cf4d493ca08bed'})do
   local hash=call((sr.IdString64 or{}).from_hex,resource)
   local list=hash and call(W.units_by_resource,context.world,hash)
   local n=0
   for _,u in pairs(type(list)=='table'and list or{})do
    n=n+1;if n>8 then unit=nil;return nil end
    units[u]=true
    if unit_ready(u)then
     local p=call(U.world_position,u,1);local d=p and call((sr.Vector3 or{}).distance,pos,p)
     if finite(d)and d<=2 then
      if d<best then second,best,unit=best,d,u elseif d<second then second=d end
     end
    end
   end
   if unit then break end
  end
  if second-best<.15 or(best>.5 and second<math.huge)then unit=nil end
  return unit
 end
 local host={time=function()return now end,log=function(fmt,...)
  local ok,s=pcall(string.format,fmt,...);if ok then log(s)end
 end,call=engine,call_kind=function(name,_,...)return engine(name,...)end,
 world_id=function()return context and context.world end,
 in_mission=function()
  local session=call((sr.Network or{}).game_session)
  return session~=nil and call(G.in_session,session)==true
 end,player_unit=player_unit,unit_alive=unit_ready,
 key_pressed=function(k)local kb=sr.Keyboard or{};local i=call(kb.button_index,k);return i and call(kb.pressed,i)==true end,
 wheel=function()
  local mouse=sr.Mouse or{};local i=call(mouse.axis_index,'wheel');local v=i and call(mouse.axis,i)
  if type(v)=='number'then return v end
  return v and call((sr.Vector3 or{}).y,v)or 0
 end,weapon_menu_down=function()
  local kb=sr.Keyboard or{};local i=call(kb.button_index,'r');local v=i and call(kb.button,i)
  return v==true or(type(v)=='number'and v>.5)
 end,load_table=load_table,save_table=save_table}
 function R.reset()
  if sensor then sensor.shutdown()end
  units={}
  sensor=require('mods/integrated_hud/mdl_gamesession/sensor')(host)
 end
 function R.read(t)
  now=t;units={}
  local w=call((sr.Application or{}).main_world)
  local s=call((sr.Network or{}).game_session);local peer=call((sr.Network or{}).peer_id)
  if not w or not live_world(w)or not s or peer==nil or call(G.in_session,s)~=true then
   if context then R.shutdown()end
   context=nil;return {state='NO MISSION'}
  end
  if not context or context.world~=w or context.session~=s or context.peer~=peer then
   R.reset();context={world=w,session=s,peer=peer}
  elseif not sensor then R.reset()end
  local d,status=sensor.update()
  if status=='AVATAR CHANGE'then
   log('AVATAR_CHANGE clear_unit_pose_weapon_caches=true')
   R.reset();return {state=status}
  end
  if not d then return {state=status}end
  local ratio=finite(d.value)and finite(d.top)and d.top>0 and math.max(0,math.min(1,d.value/d.top))or nil
  if not ratio then return {state='WAIT AMMO'}end
  local fm=d.fmode
  local mode=d.mode
  if d.tid=='cfaa9ddc' then
   local raw=d.raw_fire_mode
   mode=finite(raw)and raw>=0 and raw==math.floor(raw)
    and math.floor(raw/8)%2==0 and VG70_MODES[raw%8]or nil
  end
  if not fm and finite(d.raw_fire_mode)and math.floor(d.raw_fire_mode/8)%2==0 then
   fm=({[5]='SAFE',[6]='UNSAFE'})[d.raw_fire_mode%8]
  end
  return {state=d.reloading and'RELOADING'or'READY',entity=d.goid0,hash=d.tid,ratio=ratio,
   kind=d.kind,rounds=d.kind=='ammo'and d.value or nil,capacity=d.top,mags=d.reserve,
   heat_percent=d.kind=='heat'and math.floor(100*d.value/(d.pct_top or d.top)+.5)or nil,
   overheated=d.overheated==true,mode=mode or'',rpm=d.setting or'',
   safety=(fm=='SAFE'or fm=='UNSAFE')and fm or''}
 end
 function R.shutdown()if sensor then sensor.shutdown();sensor=nil end;units={};context=nil end
 return R
end
return Module
