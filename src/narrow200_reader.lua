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
 local R={};local now,sensor,unit,unit_until=0,nil,nil,0
 local G,U,W=sr.GameSession or{},sr.Unit or{},sr.World or{}
 local function engine(name,...)
  local group,key=name:match('^([^.]+)%.(.+)$');local api=sr[group]
  return api and call(api[key],...)
 end
 local function player_unit()
  if unit and now<unit_until and call(U.alive,unit)==true then return unit end
  unit=nil;unit_until=now+.1
  local avatar=sensor and sensor.avatar();local session=call((sr.Network or{}).game_session)
  if not avatar or not session then return nil end
  local pos=call(G.game_object_field,session,avatar,'position');if not pos then return nil end
  local best,second=math.huge,math.huge
  for _,resource in ipairs({'4d1c334d294dfa97','d0cf4d493ca08bed'})do
   local hash=call((sr.IdString64 or{}).from_hex,resource)
   local list=hash and call(W.units_by_resource,call((sr.Application or{}).main_world),hash)
   local n=0
   for _,u in pairs(type(list)=='table'and list or{})do
    n=n+1;if n>8 then unit=nil;return nil end
    if call(U.alive,u)==true and call(U.has_animation_state_machine,u)==true then
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
 world_id=function()return call((sr.Application or{}).main_world)end,
 in_mission=function()
  local session=call((sr.Network or{}).game_session)
  return session~=nil and call(G.in_session,session)==true
 end,player_unit=player_unit,unit_alive=function(u)return call(U.alive,u)end,
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
  unit=nil;unit_until=0
  sensor=require('mods/integrated_hud/mdl_gamesession/sensor')(host)
 end
 function R.read(t)
  now=t;if not sensor then R.reset()end
  local d,status=sensor.update();if not d then return {state=status}end
  local ratio=finite(d.value)and finite(d.top)and d.top>0 and math.max(0,math.min(1,d.value/d.top))or nil
  if not ratio then return {state='WAIT AMMO'}end
  local fm=d.fmode
  if not fm and finite(d.raw_fire_mode)and math.floor(d.raw_fire_mode/8)%2==0 then
   fm=({[5]='SAFE',[6]='UNSAFE'})[d.raw_fire_mode%8]
  end
  return {state=d.reloading and'RELOADING'or'READY',entity=d.goid0,hash=d.tid,ratio=ratio,
   kind=d.kind,rounds=d.kind=='ammo'and d.value or nil,capacity=d.top,mags=d.reserve,
   heat_percent=d.kind=='heat'and math.floor(100*d.value/(d.pct_top or d.top)+.5)or nil,
   overheated=d.overheated==true,mode=d.mode or'',rpm=d.setting or'',
   safety=(fm=='SAFE'or fm=='UNSAFE')and fm or''}
 end
 function R.shutdown()if sensor then sensor.shutdown();sensor=nil end;unit=nil end
 return R
end
return Module
