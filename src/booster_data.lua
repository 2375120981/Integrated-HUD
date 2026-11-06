-- Join official per-player booster records by peer, never by array order.
local M={}
local function call(f,...)if type(f)=='function'then local ok,v=pcall(f,...);if ok then return v end end end
function M.peer(v)return type(v)=='string'and v:match('^%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x$')and v:lower()or nil end
local function slot(v)return type(v)=='number'and v>=0 and v<=3 and v==math.floor(v)end
function M.read(D)
 if type(D)~='table'or call(D.ready)~=true then return nil end
 local before=call(D.mission)
 local roster=call(D.players,false);local buffs=call(D.buffs)
 if type(roster)~='table'or type(buffs)~='table'or type(buffs.players)~='table'then return nil end
 local effects,rows,by_peer,slots={},{},{},{};local local_player=nil
 for _,p in pairs(buffs.players)do
  if type(p)~='table'then return nil end
  local id=M.peer(p.peer);if not id or effects[id]then return nil end
  effects[id]=p
 end
 for _,p in pairs(roster)do
  if type(p)~='table'then return nil end
  local id=M.peer(p.peer)
  if not id or by_peer[id]or not slot(p.slot)or slots[p.slot]or type(p.is_local)~='boolean'then return nil end
  slots[p.slot]=true
  local b=effects[id]
  local r={peer=id,slot=p.slot,name=p.name,is_local=p.is_local,player_entity=p.player_entity,known=b~=nil}
  if b then
   if b.is_local~=p.is_local or b.slot~=p.slot or(b.booster~=nil and type(b.booster)~='table')then return nil end
   local v=b.booster;r.none=v==nil or v.id==0 or v.name=='None'or v.name=='Count'
   if not r.none then r.booster=v.name;r.id=v.id end
  end
  if r.is_local then if local_player then return nil end;local_player=r end
  rows[#rows+1]=r;by_peer[id]=r;if #rows>4 then return nil end
 end
 local after=call(D.mission)
 if not local_player or call(D.ready)~=true or rawget(_G,'HD2Data')~=D
  or(type(before)=='table'and(type(after)~='table'or before.epoch~=after.epoch or before.in_mission~=after.in_mission))then return nil end
 return {rows=rows,by_peer=by_peer,local_player=local_player,epoch=type(after)=='table'and after.epoch,in_mission=type(after)=='table'and after.in_mission}
end
return M
