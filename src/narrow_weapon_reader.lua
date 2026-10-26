-- Independent adapter for NarrowHUD's licensed weapon sensor. No Chef or FFI.
local Module={}
local function call(fn,...)
 if type(fn)~='function' and type(fn)~='table' then return nil end
 local ok,a,b,c=pcall(fn,...);if ok then return a,b,c end
end
local function finite(x)return type(x)=='number' and x==x and math.abs(x)<1e9 end
local function storage()
 local root=os.getenv('APPDATA')
 return root and root..'/Arrowhead/Helldivers2/IntegratedHUD-weapon-learned-v1.txt'
end
-- Data-only cache; never executes cached Lua.
local function load_learned()
 local path=storage();if not path then return nil end
 local f=io.open(path,'r');if not f then return nil end
 local t={_v=1}
 local string_kind={modes=true,poses=true,rpms=true,options1=true,rpmbase=true}
 for line in f:lines() do
  local k,id,v=line:match('^(%w+)\t(%x%x%x%x%x%x%x%x)\t([%w.,%-]+)$')
  if k and #line<512 then
   local x=string_kind[k] and v or tonumber(v)
   if not string_kind[k] then
    if v=='true' then x=true elseif v=='false' then x=false elseif not x then x=v end
   end
   t[k]=t[k] or {};t[k][id]=x
  end
 end
 f:close();return t
end
local function save_learned(_,t)
 local path=storage();if not path then return false end
 local rows={}
 for k,values in pairs(t) do if type(values)=='table' then
  for id,v in pairs(values) do rows[#rows+1]=k..'\t'..id..'\t'..tostring(v)..'\n' end
 end end
 table.sort(rows)
 local f=io.open(path,'w');if not f then return false end
 f:write(table.concat(rows));f:close();return true
end
function Module.new(sr,facts,log)
 local create=require('mods/integrated_hud/driver_reference/narrowhud_weapon_sensor')
 local G,U,W=sr.GameSession or{},sr.Unit or{},sr.World or{}
 local I,I64=sr.IdString32 or{},sr.IdString64 or{}
 local R={value=nil,status='WAIT'}
 local ctx,now,sensor,world,session,avatar,unit,unit_at,next_log=nil,0,nil,nil,nil,nil,nil,0,0
 local last_signature=nil
 local names={}
 for _,list in ipairs({facts.data.weapons,facts.data.backpacks}) do
  for line in list:gmatch('[^\n]+') do local id,name=line:match('^(%x+) (%S+)');names[name]=id end
 end
 names[facts.data.player.name]=facts.data.player.id;names[facts.data.avatar.name]=facts.data.avatar.id
 local function kind(name)return call(I.from_hex,names[name] or name) end
 local function engine(name,...)
  local group,key=name:match('^([^.]+)%.(.+)$');local api=group and sr[group]
  if not api then return nil end
  if name=='GameSession.game_object_is_type' then
   local s,id,t=...;return call(api[key],s,id,kind(t))
  elseif name=='Network.object_info' then return call(api[key],kind(...)) end
  return call(api[key],...)
 end
 local function position(u)
  if call(U.alive,u)~=true then return nil end
  local n=call(U.num_scene_graph_items,u)
  if not finite(n) or n<2 then return nil end
  return call(U.world_position,u,1)
 end
 local function player_unit()
  if unit and now<unit_at and call(U.alive,unit)==true then return unit end
  unit=nil;unit_at=now+.1
  local pos=call(G.game_object_field,ctx.session,ctx.avatar,'position');if not pos then return nil end
  local best,second=math.huge,math.huge
  for _,resource in ipairs({'4d1c334d294dfa97','d0cf4d493ca08bed'}) do
   local list=call(W.units_by_resource,ctx.world,call(I64.from_hex,resource))
   local n=0
   for _,u in pairs(type(list)=='table' and list or{}) do
    n=n+1;if n>8 then unit=nil;return nil end
    local p=position(u);local d=p and call((sr.Vector3 or{}).distance,pos,p)
    if finite(d) and d<=2 and call(U.has_animation_state_machine,u)==true then
     if d<best then second=best;best=d;unit=u elseif d<second then second=d end
    end
   end
   if unit then break end
  end
  if second-best<.15 or (best>.5 and second<math.huge) then unit=nil end
  return unit
 end
 local function key_pressed(k)
  local kb=sr.Keyboard or{};local i=call(kb.button_index,k)
  return type(i)=='number' and call(kb.pressed,i)==true
 end
 local function held_type(grip)
  local b=player_unit();if not b or call(U.has_node,b,'attach_hand_r')~=true then return nil end
  local node=call(U.node,b,'attach_hand_r');if not finite(node) then return nil end
  local hand=call(U.world_position,b,node);if not hand then return nil end
  local found=nil
  for h,p in pairs(facts.bootstrap or{}) do
   -- Only a model near the verified local hand can supply missing cold-start
   -- association. Ownership/type checks still run in the sensor.
   local list=call(W.units_by_resource,ctx.world,call(I64.from_hex,p.resource))
   local count,visited=0,0
   for _,u in pairs(type(list)=='table' and list or{}) do
    visited=visited+1;if visited>16 then return nil end
    local pos=position(u);local d=pos and call((sr.Vector3 or{}).distance,hand,pos)
    if finite(d) and math.abs(d-(p.offset or 0))<=.15 then count=count+1 end
   end
   if count>1 then return nil end
   if count==1 then if found then return nil end;found=h end
  end
  return found
 end
 local function wheel()
  local mouse=sr.Mouse or{};local i=call(mouse.axis_index,'wheel')
  local v=type(i)=='number' and call(mouse.axis,i)
  if type(v)=='number' then return v end
  local y=v and call((sr.Vector3 or{}).y,v)
  return finite(y) and y or 0
 end
 local host={data=facts.data,seed=facts.seed,
  time=function()return now end,session=function()return ctx.session end,peer=function()return ctx.peer end,
  world_id=function()return ctx.world end,player_unit=player_unit,held_type=held_type,
  in_mission=function()return ctx.motion==true and ctx.where==100 and ctx.state==0 end,
  unit_alive=function(u)return call(U.alive,u) end,
  call_kind=function(name,_,...)return engine(name,...)end,
  key_pressed=key_pressed,wheel=wheel,load_table=load_learned,save_table=save_learned,
  log=function(fmt,...)local ok,s=pcall(string.format,fmt,...);if ok then log(s)end end}
 function R.reset()
  if sensor then call(sensor.flush) end
  sensor=nil;unit=nil;R.value=nil;R.status='WAIT';world=nil;session=nil;avatar=nil
 end
 function R.hide()R.value=nil end
 function R.update(t,c)
  now=t;ctx=c
  if world~=c.world or session~=c.session then
   R.reset();world=c.world;session=c.session;sensor=create(host)
  end
  if avatar~=c.avatar then avatar=c.avatar;unit=nil end
  if c.motion~=true or c.where~=100 or c.state~=0 then R.hide();return nil end
  local d=sensor.update()
  if not d then R.value=nil;R.status='IDENTIFY'
  else
   local ratio=finite(d.value) and finite(d.top) and d.top>0 and math.max(0,math.min(1,d.value/d.top)) or nil
   local mode=d.fmode
   -- Fixed fire modes need no second observed mode to be shown here.
   local fm=d.raw_fire_mode
   if not mode and finite(fm) and math.floor(fm/8)%2==0 then
    mode=({[1]='AUTO',[2]='SEMI',[3]='BURST',[4]='VOLLEY',[5]='SAFE',[6]='UNSAFE',[7]='TOTAL'})[fm%8]
   end
   R.value={id=d.goid0,hash=d.t0.id,mode=mode or'',weapon_mode=d.mode or'',setting=d.setting or'',
    functional_status=(mode=='SAFE' or mode=='UNSAFE') and mode or'',
    raw_options=d.raw_options,underbarrel=d.underbarrel==true,
    rounds=d.kind=='ammo' and d.value or nil,reserve=d.reserve,
    ammo_ratio=d.kind=='ammo' and ratio or nil,heat_ratio=d.kind=='heat' and ratio or nil,
    heat_percent=d.kind=='heat' and math.floor(100*d.value/(d.pct_top or d.top)+.5) or nil,
    overheated=d.overheated==true,reloading=d.reloading==true,capacity=d.top,raw_mode=fm}
   R.status=d.reloading and 'RELOADING' or 'READY'
  end
  local v=R.value
  local sig=R.status..(v and ':'..v.hash..':'..tostring(v.rounds)..':'..tostring(v.heat_percent)..':'..v.mode..':function='..v.weapon_mode..':options='..tostring(v.raw_options)..':underbarrel='..tostring(v.underbarrel) or(':'..tostring(sensor.wait_reason)))
  if now>=next_log and sig~=last_signature then next_log=now+.5;last_signature=sig;log('WEAPON '..sig)end
  return v
 end
 return R
end
return Module
