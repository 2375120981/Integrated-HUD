-- NarrowHUD-derived function/RPM decoding. Hub entity and network ID stay separate.
-- Only an unambiguous local carried-slot match supplies supplemental settings.
local M={}
local DATA=require('mods/integrated_hud/mdl_gamesession/weapon_detail_data')
local OPTIONS={
 c920c2d3={4,'GUIDED','UNGUIDED'},fd585726={4,'GUIDED','UNGUIDED'},
 ['7bfb2e06']={4,'APHET','FLAK'},b2bfd847={4,'HEAT','HE'},
 ['8a3c6fee']={4,'FLAK','CLUSTER'},['6b2c3bed']={256,'DEPLOY','DETONATE'},
 ['656d507b']={4,'BURST','ARTILLERY'}
}
local UB={cd0e4b4a={'12MM','FLAME'},['8fcdd35c']={'4MM','10G'},['3244dc49']={'8MM','40MM HE'}}
local function call(f,...)if type(f)=='function'then local ok,a=pcall(f,...);if ok then return a end end end
local function finite(v)return type(v)=='number'and v==v and math.abs(v)<1e9 end
local function norm(v)
 if type(v)=='number'then v=string.format('%x',v)end
 return type(v)=='string'and v:lower():gsub('^0x',''):gsub('^0+','')or nil
end
function M.new(E,log)
 local G,N=E.GameSession or{},E.Network or{}
 local R={};local verified={};local next_read=0;local last_id,last_session,last_result=nil,nil,nil
 local rpm_seen={};local rpmadj={};local bases={};local option_values={}
 for h,v in pairs(DATA.rpmadj)do rpmadj[h]=v end
 for h,v in pairs(DATA.rpmbase)do bases[h]=v end
 for h,v in pairs(DATA.options1)do option_values[h]=v end
 -- Keep previously learned adjustable settings; deliberately ignore all pose/slot entries.
 local base=os.getenv('APPDATA')
 local f=base and io.open(base..'/Arrowhead/Helldivers2/IntegratedHUD-Narrow200-learned.txt','r')
 if f then for line in f:lines()do
  local k,h,v=line:match('^(%w+)\t(%x%x%x%x%x%x%x%x)\t([%w.,%-]+)$')
  if k=='rpmadj'and v=='true'then rpmadj[h]=true elseif k=='rpmbase'then bases[h]=v
  elseif k=='options1'then option_values[h]=v end
 end;f:close()end
 local function valid(t)
  if verified[t.name]~=nil then return verified[t.name]end
  local info=call(N.object_info,t.name);local found={}
  if type(info)~='table'or type(info.fields)~='table'then return false end
  for _,r in pairs(info.fields)do
   local id=type(r)=='table'and norm(r.id)
   if id then found[id]=true end
  end
  local good=true
  for _,role in ipairs({'options','fire_mode','rpm','selected','guide','carry','owner','floor','rounds','slot0','slot1','chamber','heat'})do
   local r=DATA.roles[role]
   if t.roles:find(r.letter,1,true)and not found[norm(r.id)]then good=false end
  end
  verified[t.name]=good;return good
 end
 local function read_field(s,id,t,role)
  local r=DATA.roles[role]
  if t.roles:find(r.letter,1,true)then return call(G.game_object_field,s,id,r.name)end
 end
 local binding=require('mods/integrated_hud/mdl_gamesession/weapon_network_binding').new(E,DATA,valid,read_field,log)
 function R.reset()verified={};rpm_seen={};next_read=0;last_id,last_session,last_result=nil,nil,nil;binding.reset()end
 function R.refresh()next_read=0;binding.refresh()end
 function R.read(entity,now,me)
  local s=call(N.game_session)
  if not s or call(G.in_session,s)~=true then return nil end
  if s~=last_session then R.reset();last_session=s end
  if entity==last_id and now<next_read then return last_result end
  last_id=entity;next_read=now+.1;last_result=nil
  local id,t=binding.resolve(s,entity,now,me)
  if not id or not t then
   if binding.state~='CLASSIFYING LOCAL OBJECTS'then next_read=now+.5 end
   return nil
  end
  local options=read_field(s,id,t,'options');local fm=read_field(s,id,t,'fire_mode')
  local rpm=read_field(s,id,t,'rpm');local selected=read_field(s,id,t,'selected')
  local mode=nil;local names=OPTIONS[t.id]
  if names and finite(options)then mode=names[math.floor(options/names[1])%4+2]end
  if not names and finite(options)then
   local value=math.floor(options/4)%4
   local list=option_values[t.id]or''
   if not(','..list..','):find(','..value..',',1,true)then list=list==''and tostring(value)or list..','..value end
   option_values[t.id]=list
   if list:find(',',1,true)then mode='OPT '..value end
  end
  if t.id=='9c06f074'and finite(selected)then mode=({[0]='FLECHETTE',[1]='STUN'})[selected]end
  local main=finite(fm)and math.floor(fm/8)%2==0
  if UB[t.id]then mode=UB[t.id][finite(fm)and not main and 2 or 1]end
  if t.id=='cfaa9ddc'and main then mode=({[1]='AUTO',[4]='VOLLEY',[7]='TOTAL'})[fm%8]end
  -- Epoch also uses mode 6 internally, but has no selectable safety mode.
  local safety=t.id=='26acc614'and main and({[5]='SAFE',[6]='UNSAFE'})[fm%8]or nil
  local guide=read_field(s,id,t,'guide')
  if guide==true or guide==false then mode=(mode and mode..'  'or'')..(guide and'LASER'or'NO LASER')end
  local setting=nil
  if finite(rpm)and rpm>0 and not t.heat then
   local prev=rpm_seen[t.id]
   if prev and prev.fm==fm and math.abs(prev.rpm-rpm)>1.5
    and math.abs(prev.rpm*.9-rpm)>1.5 and math.abs(rpm*.9-prev.rpm)>1.5 then rpmadj[t.id]=true end
   rpm_seen[t.id]={rpm=rpm,fm=fm}
   if rpmadj[t.id]then
    local value=math.floor(rpm+.5);local warm=nil;local exact=false
    for n in tostring(bases[t.id]or''):gmatch('[^,]+')do
     n=tonumber(n)
     if n and math.abs(n-rpm)<=1.5 then value=n;exact=true;break end
     if n and math.abs(n*.9-rpm)<=1.5 then warm=n end
    end
    if not exact and warm then value=warm end
    setting=tostring(math.floor(value+.5))..' RPM'
   end
  end
  last_result={hash=t.id,network_id=id,mode=mode,rpm=setting,safety=safety,backpack_fed=DATA.packres[t.id]==true}
  return last_result
 end
 return R
end
return M
