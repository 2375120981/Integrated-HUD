-- Basic dev43 contract checks: real Hub adapter, MDL view, settings and cleanup.
local B='mods/integrated_hud/mdl_gamesession/'
local env=setmetatable({os={getenv=function()return nil end}},{__index=_G});env._G=env
local modules={};local overrides={}
env.require=function(n)
 if overrides[n]then return overrides[n]end
 if not modules[n]then local f=assert(loadstring(assert(SOURCES[n],n),n));setfenv(f,env);modules[n]=f()end
 return modules[n]
end
local width,height=1920,1080;local canvases={};local finishes=0
local function api()
 return {api=1,canvas=function(opts)
  local c={opts=opts,items={}};canvases[#canvases+1]=c
  function c:screen()return {w=opts.units=='pixels'and width or width*1080/height,h=opts.units=='pixels'and height or 1080}end
  function c:begin()self.pending={}end
  function c:finish()self.items=self.pending;finishes=finishes+1 end
  function c:destroy()self.items={};self.dead=true end
  function c:measure(s,size)local n=0;for _ in s:gmatch('[%z\1-\127\194-\244][\128-\191]*')do n=n+1 end;return n*size*.6 end
  function c:status()return {font=true}end
  for _,kind in ipairs({'triangle','rect','line','text','image'})do
   c[kind]=function(self,...)self.pending[#self.pending+1]={kind=kind,args={...}}end
  end
  return c
 end}
end
env.MDL3={gui=api()}
local function count(kind)
 local n=0;for _,c in ipairs(canvases)do for _,i in ipairs(c.items)do if not kind or i.kind==kind then n=n+1 end end end;return n
end
local function text_items()
 local t={};for _,c in ipairs(canvases)do for _,i in ipairs(c.items)do if i.kind=='text'then t[#t+1]=i.args end end end;return t
end
local cursor=false
local E={Window={show_cursor=function()return cursor end},Application={},Network={},GameSession={}}
env.stingray=E
local fields,types={},{};local checked={}
local meta=env.require(B..'weapon_detail_data')
local type_by_hash={};for _,t in ipairs(meta.types)do type_by_hash[t.id]=t end
local t=assert(type_by_hash['7bfb2e06']);types[201]=t.name
for role,value in pairs({options=84,fire_mode=1,selected=0,rpm=600,carry=0,owner='1111111111111111',floor=32767,rounds=5,slot0=5,slot1=0,chamber=true})do fields[meta.roles[role].name]=value end
local owned={201}
E.Network.peer_id=function()return '1111111111111111'end
E.Network.game_session=function()return 1 end
E.GameSession.objects_owned_by=function()return owned end
E.Network.object_info=function(name)
 local f={};for _,r in pairs(meta.roles)do f[#f+1]={id=r.id}end;return {fields=f}
end
E.GameSession.in_session=function()return true end
local gone_type_reads=0
E.GameSession.game_object_exists=function(_,id)if id==203 then return false end;assert(id==201 or id==202);return true end
E.GameSession.game_object_is_type=function(_,id,name)if id==203 then gone_type_reads=gone_type_reads+1;error('gone object type read')end;assert(id==201 or id==202);return types[id]==name end
E.GameSession.game_object_field=function(_,id,name)assert(id==201 or id==202,'supplement used Hub entity as network ID');checked[#checked+1]=id;return fields[name]end
local detail=env.require(B..'weapon_details').new(E,function()end)
local identity={peer='1111111111111111',weapon={entity=4194505,slot='support',ammo_type='magazine',rounds=5}}
local actual=detail.read(4194505,0,identity)
assert(actual and actual.mode=='FLAK'and actual.network_id==201,'Hub/network identity binding missing')
fields[meta.roles.rounds.name]=4;fields[meta.roles.slot0.name]=4
assert(detail.read(4194505,.2,identity).mode=='FLAK','network sync lag hid an established mode')
fields[meta.roles.rounds.name]=5;fields[meta.roles.slot0.name]=5
owned={201,202};types[202]=t.name;detail.reset()
assert(detail.read(4194505,1,identity)==nil,'ambiguous local carried weapons guessed a mode')
owned={201,203};detail.reset();assert(detail.read(4194505,2,identity).mode=='FLAK'and gone_type_reads==0,'gone object reached type/field reads')
assert(#checked>0)
-- Both charged weapons must bind to the support slot.
owned={201}
local function charged_weapon(hash,slot,fm)
 types[201]=assert(type_by_hash[hash]).name
 fields[meta.roles.fire_mode.name]=fm
 identity.weapon.slot=slot
 detail.reset()
 local result
 for i=0,12 do result=detail.read(identity.weapon.entity,3+i*.2,identity);if result then break end end
 return result
end
local safe=charged_weapon('26acc614','support',5)
assert(safe and safe.hash=='26acc614'and safe.safety=='SAFE','support Railgun lost SAFE mode')
local unsafe=charged_weapon('26acc614','support',6)
assert(unsafe and unsafe.safety=='UNSAFE','support Railgun lost UNSAFE mode')
local epoch=charged_weapon('314a1bf5','support',6)
assert(epoch and epoch.hash=='314a1bf5'and not epoch.safety,'support Epoch displayed Railgun safety')
assert(not charged_weapon('26acc614','primary',6),'Railgun bound to primary slot')
assert(not charged_weapon('314a1bf5','primary',6),'Epoch bound to primary slot')
-- Belt grenade launcher RPM exists even though Hub supplies no magazine.
local belt_type=assert(type_by_hash['6b47e064'])
assert(belt_type.direct_feed,'connected type metadata lost')
identity.weapon={entity=4194506,slot='support',category=3,backpack_fed=false}
identity.weapons={support=4194506}
identity.loadout={support={entity=4194506,held=true,backpack_fed=false}}
types[201]=belt_type.name;owned={201}
for i,rpm in ipairs({160,240,320})do
 fields[meta.roles.rpm.name]=rpm
 detail.reset()
 local result
 for j=0,12 do result=detail.read(identity.weapon.entity,6+i+j*.2,identity);if result then break end end
 assert(result and result.hash=='6b47e064'and result.rpm==rpm..' RPM','belt grenade RPM missing or stale')
end
owned={201,202};types[202]=belt_type.name;detail.reset()
assert(detail.read(identity.weapon.entity,20,identity)==nil,'ambiguous belt objects guessed RPM')
owned={201};identity.loadout.support.held=false;detail.reset()
assert(detail.read(identity.weapon.entity,21,identity)==nil,'holstered belt object supplied RPM')
-- Underbarrels corroborate ammo via a typed rifle->child reference, never pose.
local old_field=E.GameSession.game_object_field
local child_rounds=1;local child_reserve=6;local child_reload=0
E.GameSession.game_object_field=function(session,id,name)
 if id==202 and(name==meta.roles.magazines.name or name==meta.roles.spare.name)then return child_reserve end
 if id==202 and name==meta.roles.reload_stage.name then return child_reload end
 if id==202 and(name==meta.roles.rounds.name or name==meta.roles.slot0.name)then return child_rounds end
 return old_field(session,id,name)
end
identity.weapon={entity=4194507,slot='primary',ammo_type='magazine',rounds=1}
for _,pair in ipairs({{'3244dc49','16425925','8MM','40MM HE'},
 {'8fcdd35c','da0f356e','4MM','10G'},{'cd0e4b4a','2166c7a1','12MM','FLAME'}})do
 types[201]=assert(type_by_hash[pair[1]]).name;types[202]=assert(type_by_hash[pair[2]]).name
 owned={201,202}
 fields[meta.roles.underbarrel.name]=202
 fields[meta.roles.rounds.name]=30;fields[meta.roles.slot0.name]=30
 fields[meta.roles.fire_mode.name]=9
 detail.reset()
 local result
 for j=0,30 do result=detail.read(identity.weapon.entity,30+j*.2,identity);if result then break end end
 assert(result and result.hash==pair[1]and result.mode==pair[4],'linked underbarrel mode missing')
 assert(result.underbarrel_active and result.underbarrel_ammo.rounds==1 and result.underbarrel_ammo.mags==6,'child ammo borrowed rifle contents')
 child_rounds=0;child_reserve=5;child_reload=1
 result=detail.read(identity.weapon.entity,38,identity)
 assert(result.underbarrel_ammo.rounds==0 and result.underbarrel_ammo.mags==5 and result.underbarrel_ammo.reload.active,'child ammo/reload did not refresh')
 child_rounds=1;child_reserve=6;child_reload=0
 -- Switching selectors while staying on the same Hub entity refreshes the label.
 fields[meta.roles.fire_mode.name]=1;identity.weapon.rounds=30
 assert(detail.read(identity.weapon.entity,40,identity).mode==pair[3],'main ammo label stale')
 fields[meta.roles.fire_mode.name]=9;identity.weapon.rounds=1
 assert(detail.read(identity.weapon.entity,41,identity).mode==pair[4],'underbarrel label stale')
 fields[meta.roles.underbarrel.name]=32767;detail.reset()
 assert(not detail.read(identity.weapon.entity,42,identity),'unlinked child supplied mode')
end
E.GameSession.game_object_field=old_field
-- No supplemental selector is allowed to influence Hub's identity or ammo type.
local details_read={};local extra_available=true;local underbarrel_extra=nil;local detail_refreshes=0;local backpack_reads=0
overrides[B..'weapon_details']={new=function()return{read=function(id)details_read[#details_read+1]=id;if underbarrel_extra then return underbarrel_extra end;if extra_available then return{mode='FLAK',backpack_fed=id==105}end end,reset=function()end,refresh=function()detail_refreshes=detail_refreshes+1 end}end}
local me={entity=10,player_entity=1,peer='1111111111111111',life='alive',alive=true,
 weapon={entity=101,slot='primary',ammo_type='heat',heat={value=30,max=100,frac=.3,locked=false},reload={active=false}}}
local ready=true
local weapon_mission={in_mission=true,epoch=1}
local weapon_ammo_reads=0
env.HD2Data={version='0.6.0',ready=function()return ready end,mission=function()return weapon_mission end,player_ammo=function()weapon_ammo_reads=weapon_ammo_reads+1;return me end,backpacks=function()backpack_reads=backpack_reads+1;return nil end}
local input_logs={}
local reader=env.require(B..'reader').new(E,function(line)input_logs[#input_logs+1]=line end)
local v=reader.read(0);assert(v.kind=='heat'and v.entity==101 and v.heat_percent==30)
-- Active linked ammo replaces main-gun heat/counts, without mutating Hub.
underbarrel_extra={mode='40MM HE',underbarrel_active=true,
 underbarrel_ammo={entity=101,ammo_type='magazine',rounds=1,capacity=1,mags=4,reload={active=false}}}
v=reader.read(.000001)
assert(v.kind=='ammo'and v.rounds==1 and v.mags==4 and v.ratio==1 and v.mode=='40MM HE','underbarrel UI used main ammo')
assert(me.weapon.ammo_type=='heat','underbarrel mutated Hub snapshot')
underbarrel_extra.underbarrel_ammo.reload.active=true
underbarrel_extra.underbarrel_ammo.rounds=0;underbarrel_extra.underbarrel_ammo.mags=3
v=reader.read(.000002);assert(v.state=='READY'and v.reloading and v.rounds==0 and v.mags==3,'child reload did not show current ammo')
underbarrel_extra.underbarrel_ammo=nil
assert(reader.read(.000003).state=='WAIT UNDERBARREL','missing child leaked main ammo')
underbarrel_extra=nil
assert(reader.read(.000004).kind=='heat','switching back failed to restore main ammo')
me.weapon.heat.charge=50;me.weapon.heat.charging=true
v=reader.read(.00001);assert(v.ratio==.3 and v.charge_ratio==.5 and v.heat_percent==30,'charge overwrote heat display')
me.weapon.heat.charging=false;assert(not reader.read(.00002).charging,'cancel did not hide heat charge')
me.weapon.heat.charge=nil

weapon_mission={in_mission=false,epoch=0}
local ammo_before=weapon_ammo_reads;local details_before=#details_read
assert(reader.read(.0001).state=='NO MISSION'and weapon_ammo_reads==ammo_before and #details_read==details_before,'ship weapon data reached HUD/supplemental reader')
local mission_api=env.HD2Data.mission
env.HD2Data.mission=function()return nil end
assert(reader.read(.0002).state=='NO MISSION','unknown scene displayed weapon HUD')
env.HD2Data.mission=mission_api;weapon_mission={in_mission=true,epoch=1}
assert(reader.read(.0003).state=='READY','mission weapon HUD failed to restore')
-- Ship transition/epoch change while the ammo snapshot is being read.
local ammo_api=env.HD2Data.player_ammo
env.HD2Data.player_ammo=function()weapon_mission={in_mission=false,epoch=2};return me end
assert(reader.read(.0004).state=='NO MISSION','ship transition leaked a READY snapshot')
weapon_mission={in_mission=true,epoch=3}
env.HD2Data.player_ammo=function()weapon_mission={in_mission=true,epoch=4};return me end
assert(reader.read(.0005).state=='NO MISSION','changed mission epoch leaked a READY snapshot')
env.HD2Data.player_ammo=ammo_api;weapon_mission={in_mission=true,epoch=4}

me.weapon={entity=102,slot='secondary',ammo_type='magazine',rounds=2,capacity=3,mags=4,reload={active=false}}
v=reader.read(.001);assert(v.kind=='ammo'and v.entity==102 and v.rounds==2 and v.mags==4,'switch without firing remained stale')
me.weapon.charge=.7;v=reader.read(.0011)
assert(v.charge_ratio==.7 and v.ratio==2/3 and v.rounds==2,'ammo charge did not stay independent')
me.weapon.charge=0;assert(not reader.read(.0012).charging,'released ammo charge remained visible')

me.weapon.entity=103;me.weapon.rounds=7;me.weapon.mags=5
v=reader.read(.002);assert(v.entity==103 and v.rounds==7,'support identity failed')
me.weapon.reload.active=true;me.weapon.rounds=0;me.weapon.mags=4
v=reader.read(.003);assert(v.state=='READY'and v.reloading and v.rounds==0 and v.mags==4 and v.ratio==0,'reload used old/invented ammo or hid HUD')
me.weapon=nil;assert(reader.read(.004).state=='NO WEAPON','previous weapon leaked across empty held item')
me.alive=false;assert(reader.read(.005).state=='NO AVATAR')
me.alive=true;me.entity=11
me.weapon={entity=104,ammo_type='heat',heat={value=20,max=100,frac=.2}}
assert(reader.read(.006).entity==104,'respawn retained former object')
me.weapon={entity=105,slot='support',ammo_type='magazine',rounds=5,capacity=10,mags=0,backpack_fed=true}
me.weapon.backpack_fed=false;me.backpack=nil
local lease_before=backpack_reads;reader.read(.00605);assert(backpack_reads>lease_before,'support weapon did not warm backpack lease before pickup')
extra_available=false;me.backpack={entity=600,count=5}
assert(reader.read(.0061).mags==5 and detail_refreshes>0,'pickup waited for settings retry or lost confirmed fed type')
extra_available=true
me.weapon.mags=5;me.weapon.mags_backpack=5;assert(reader.read(.0062).mags==5,'backpack ammo counted twice')
me.weapon.mags=0;me.weapon.mags_backpack=nil;me.backpack.count=nil
env.HD2Data.backpacks=function()return{{is_local=true,peer=me.peer,backpack={entity=600,type='deposit',count=6}}}end
assert(reader.read(.0063).mags==6,'independent Hub backpack API not used')
env.HD2Data.backpacks=function()return{{is_local=true,peer='2222222222222222',backpack={entity=600,type='deposit',count=9}}}end
assert(reader.read(.0064).mags==0,'another peer backpack leaked into local reserve')
-- Direct backpack supply: only Hub identity/feed flag and local count/max.
me.weapon={entity=106,slot='support',backpack_fed=true}
me.backpack={entity=600,count=750,max=1000}
env.HD2Data.backpacks=function()return nil end
v=reader.read(.0065)
assert(v.state=='READY'and v.backpack_direct and v.rounds==750 and v.ratio==.75 and v.mags==nil,'direct feed needs conventional ammo or double-counted backpack')
me.backpack.count=0;v=reader.read(.00651)
assert(v.state=='READY'and v.rounds==0 and v.ratio==0,'empty belt pack hidden')
me.backpack=nil
env.HD2Data.backpacks=function()return{{is_local=true,peer=me.peer,backpack={entity=600,type='deposit',count=250,max=1000}}}end
assert(reader.read(.00652).rounds==250,'local Hub backpack count/max not used for direct feed')
env.HD2Data.backpacks=function()return{{is_local=true,peer='2222222222222222',backpack={entity=600,type='deposit',count=999,max=1000}}}end
assert(reader.read(.00653).state=='WAIT BACKPACK','foreign pack used for belt weapon')
me.backpack={entity=600,count=400,max=1000}
me.weapon.backpack_fed=nil
assert(reader.read(.00654).state=='UNSUPPORTED AMMO','unknown support inferred as backpack-fed')
me.weapon.backpack_fed=true;me.weapon.reload={active=true}
v=reader.read(.00655);assert(v.state=='READY'and v.reloading and v.backpack_direct and v.rounds==400,'belt reload hid current backpack ammo')
me.weapon.reload=nil;me.backpack.count=nil
assert(reader.read(.00656).state=='WAIT BACKPACK','missing pack count reused or invented')
me.backpack={entity=600,count=1200,max=1000}
assert(reader.read(.00657).state=='WAIT BACKPACK','invalid backpack capacity accepted')
-- Replay the three captured Hub shapes: real connected weapons all report
-- backpack_fed=false, no conventional ammo, and a matching held support slot.
for i,pair in ipairs({{1000,952},{120,110},{500,470}})do
 local id=610+i;local pack_id=620+i
 me.weapon={entity=id,category=3,slot='support',backpack_fed=false}
 me.weapons={support=id}
 me.loadout={support={entity=id,held=true,backpack_fed=false}}
 me.backpack={entity=pack_id,count=pair[1],max=pair[1]}
 env.HD2Data.backpacks=function()return{{is_local=true,peer=me.peer,
  backpack={entity=pack_id,owned=true,type='deposit',count=me.backpack.count,max=pair[1]}}}end
 v=reader.read(.0066+i*.00001)
 assert(v.state=='READY'and v.backpack_direct and v.rounds==pair[1]and v.ratio==1 and v.mags==nil,'captured full belt pack rejected')
 me.backpack.count=pair[2];v=reader.read(.0067+i*.00001)
 assert(v.rounds==pair[2]and v.ratio==pair[2]/pair[1],'captured firing did not update belt count')
 me.backpack.count=0;assert(reader.read(.0068+i*.00001).rounds==0,'captured empty belt hidden')
end
local keep_packs=env.HD2Data.backpacks
me.loadout.support.entity=999
assert(reader.read(.0069).state=='UNSUPPORTED AMMO','disagreeing held/inventory accepted')
me.loadout.support.entity=me.weapon.entity
me.backpack=nil;env.HD2Data.backpacks=function()return nil end
assert(reader.read(.00691).state=='WAIT BACKPACK','dropped pack retained old belt count')
env.HD2Data.backpacks=function()return{{is_local=true,peer='2222222222222222',backpack={entity=623,owned=true,type='deposit',count=100,max=500}}}end
assert(reader.read(.00692).state=='WAIT BACKPACK','captured connected weapon used foreign peer pack')
me.weapon={entity=101,slot='primary',ammo_type='heat',heat={frac=.2,value=20,max=100}}
v=reader.read(.00693);assert(v.kind=='heat'and not v.backpack_direct,'holstered belt replaced held primary HUD')
ready=false;assert(reader.read(.007).state=='WAIT HUB');ready=true
local hub=env.HD2Data;env.HD2Data=nil;assert(reader.read(.008).state=='HUB REQUIRED');env.HD2Data=hub
hub.version='0.3.0';assert(reader.read(.009).state=='HUB 0.6 REQUIRED');hub.version='0.6.0'
-- Actual unsupported/alternate held slots must still request Hub packs and
-- record the input snapshot instead of hiding the reason behind an early return.
me.weapon={entity=107,slot='held_item',category=4,backpack_fed=false}
local pack_calls=backpack_reads
hub.backpacks=function()backpack_reads=backpack_reads+1;return{{is_local=true,peer=me.peer,backpack={entity=600,type='deposit',count=300,max=1000}}}end
assert(reader.read(10).state=='UNSUPPORTED AMMO','diagnostic route invented belt classification')
assert(backpack_reads>pack_calls,'alternate held slot did not request Hub backpack snapshot')
local trace=false
for _,line in ipairs(input_logs)do if line:find('HUB_INPUT held{entity=107',1,true)then
 trace=line:find('slot=held_item',1,true)and line:find('backpack_fed=false',1,true)and line:find('count=300',1,true)
end end
assert(trace,'unsupported weapon returned before logging Hub inputs')
reader.shutdown()
-- Real MDL view: one arc, native text, images, scaling and reload visibility.
local view=env.require(B..'weapon_view').new(function()end)
view.update({state='READY',entity=106,kind='ammo',backpack_direct=true,ratio=.75,rounds=750},1,1)
local belt_number=false
for _,t in ipairs(text_items())do if t[1]=='750'then belt_number=true end;assert(not t[1]:find('/',1,true),'belt HUD fabricated separate magazine/reserve')end
assert(belt_number,'direct backpack count not rendered')
v={state='READY',entity=102,kind='ammo',ratio=.5,rounds=2,mags=4,mode='FLAK',rpm='600 RPM'}
view.update(v,1,1);assert(count('triangle')>0 and count('text')==4 and count('image')==1)
local outer={}
for _,c in ipairs(canvases)do if c.opts.layer==50 then for _,i in ipairs(c.items)do
 if i.kind=='triangle'and #outer<120 then outer[#outer+1]=i.args end
end end end
v.charging=true;v.charge_ratio=.7;v.charge_percent=70;view.update(v,1,1)
local index,cyan=0,0
for _,c in ipairs(canvases)do if c.opts.layer==50 then for _,i in ipairs(c.items)do if i.kind=='triangle'then
 index=index+1
 if index<=120 then for k=1,6 do assert(i.args[k]==outer[index][k],'charging moved outer ammo arc')end end
 if i.args[7][1]==100 and i.args[7][4]>0 then
  cyan=cyan+1;for k=1,5,2 do local x,y=i.args[k]-960,i.args[k+1]-540;assert(math.sqrt(x*x+y*y)<153,'charge arc not inside ammo arc')end
 end
end end end end
assert(cyan>0 and count('text')==4,'charge arc missing or introduced charge text')
for _,t in ipairs(text_items())do assert(t[1]~='70%','charge percentage leaked into HUD')end
v.charging=nil;v.charge_ratio=nil;v.charge_percent=nil;view.update(v,1,1)
local arcs=count('triangle');v.ratio=.2;view.update(v,1,1);assert(count('triangle')==arcs,'arc cannot use MDL in-place updates');v.ratio=.5;view.update(v,1,1)
local old=finishes;view.update(v,1,1);assert(finishes==old,'stable MDL content rebuilt')
local ammo=text_items()[2];assert(ammo[1]=='2 / 4'and ammo[4].size==24)
local x,y=ammo[2],ammo[3]
view.update(v,1.5,1.5);ammo=text_items()[2]
assert(math.abs(ammo[2]-(960+(x-960)*1.5))<1e-6 and math.abs(ammo[3]-(540+(y-540)*1.5))<1e-6,'fixed anchor lost')
assert(ammo[4].size==54,'ammo size did not compose')
view.update({state='NO MISSION'},1,1);assert(count()==0,'ship did not clear weapon drawings')
view.update(v,1,1)
v.reloading=true;view.update(v,1,1);assert(count()>0,'reload hid valid weapon HUD');v.reloading=false
view.update(v,1,1);env.MDL3.gui=api();view.update(v,1,1);assert(count()>0,'GUI provider reload lost drawings')
view.shutdown();assert(count()==0)
-- Vehicle renderer adapter: bottom-up to MDL top-down, native numbers, retained IDs.
local d=env.require(B..'driver_mdl_gui').new()
local c=d.World.create_screen_gui()
local id=d.Gui.triangle(c,{10,0,20},{20,0,20},{10,0,30},3,{255,255,255,200})
local n=d.number(c,'2900',100,100,16,.9,nil,'center');d.flush()
assert(count('triangle')==1 and count('text')==1)
assert(text_items()[1][3]==980 and text_items()[1][4].size==24 and text_items()[1][4].align=='left'and math.abs(text_items()[1][2]+4*24*.6/2-100)<1e-6,'vehicle HP size/anchor changed incorrectly')
d.Gui.destroy_triangle(c,id);d.Gui.destroy_text(c,n);d.flush();assert(count()==0)
d.shutdown()
-- Network panel: Unicode prefix, compact columns, menu visibility and positioning.
local net={state='READY',rows={{peer='1',label='中文，Very long player',ms=40},{peer='2',label='Name',ms=210}}}
overrides[B..'network_ping']={new=function()return{read=function()return net end,shutdown=function()end}end}
local ping=env.require(B..'network_ping_hud').new(E,function()end)
ping.update(0);assert(count('text')==5 and count('line')==0)
local texts=text_items();assert(texts[2][1]~='中文，Very long player'and texts[2][1]:find('中文',1,true),'UTF8 prefix failed')
local oldx,oldy=texts[1][2],texts[1][3]
ping.set_position(50,25);ping.update(1);texts=text_items();assert(texts[1][2]>oldx and texts[1][3]<oldy)
cursor=true;old=finishes;ping.update(2);assert(count('text')==5 and old==finishes)
ping.shutdown();assert(count()==0)
-- Managed toggles still dispatch and independently stop each view.
local reads,vehicle_updates,vehicle_stops=0,0,0
local weapon_blocked=false
local current=v
overrides[B..'reader']={new=function()return{reset=function()end,read=function()reads=reads+1;return current end,shutdown=function()end}end}
overrides['mods/integrated_hud/driver_reference/driver_core']=function()return{
 update=function()vehicle_updates=vehicle_updates+1 end,weapon_blocked=function()return weapon_blocked end,set_views=function()end,shutdown=function()vehicle_stops=vehicle_stops+1 end}end
local mod=env.require(B..'main');local ctx={settings={booster_hud=false,network_hud=false}}
mod.on_enable(ctx);cursor=false;mod.on_update(ctx,.1);assert(reads==1 and vehicle_updates==1 and count()>0)
weapon_blocked=true;mod.on_update(ctx,.1);assert(count()==0,'restricted vehicle seat did not hide weapon HUD')
weapon_blocked=false;mod.on_update(ctx,.1);assert(count()>0,'passenger seat did not restore weapon HUD')
ctx.settings.frv_hud=false;ctx.settings.tank_hud=false;ctx.settings.mech_hud=false
mod.on_setting(ctx,'frv_hud',false)
weapon_blocked=true;mod.on_update(ctx,.1);assert(count()==0 and vehicle_stops==0,'vehicle toggles disabled seat filtering')
weapon_blocked=false;mod.on_update(ctx,.1);assert(count()>0,'disabled vehicle views blocked passenger weapon HUD')
ctx.settings.weapon_hud=false;mod.on_setting(ctx,'weapon_hud',false);assert(count()==0)
mod.on_disable();assert(vehicle_stops==1 and count()==0)
-- Booster provider: join shuffled arrays by peer; keep self on its own row.
local bp1,bp2,bp3='1111111111111111','2222222222222222','3333333333333333'
local squad={{peer=bp3,slot=2,is_local=true,name='Self'},
 {peer=bp2,slot=1,is_local=false,name='Other 2'},{peer=bp1,slot=0,is_local=false,name='Other 1'}}
local buffs={players={{peer=bp1,slot=0,is_local=false},
 {peer=bp3,slot=2,is_local=true,booster={id=2,name='Stamina'}},
 {peer=bp2,slot=1,is_local=false,booster={id=1,name='Vitality'}}}}
local booster_ready=true
local booster_provider={ready=function()return booster_ready end,
 mission=function()return{in_mission=true,epoch=1}end,
 players=function(detail)assert(detail==false);return squad end,buffs=function()return buffs end}
env.HD2Data=booster_provider;cursor=false
-- More than 256 host-owned objects: scan incrementally, then reuse IDs.
local native_index={[bp1]=1,[bp2]=0,[bp3]=3}
local owner={[11]=bp1,[12]=bp2,[13]=bp3}
local ids={[bp1]=11,[bp2]=12,[bp3]=13}
local exists_checks,owned_calls=0,0
E.Network={peer_id=function()return bp3 end,game_session=function()return 7 end}
local index_id=newproxy(true);getmetatable(index_id).__tostring=function()return '[IdString32]'end
E.IdString32={to_hex=function(v)assert(v==index_id);return 'b03b8bce'end}
E.Network.object_info=function(t)assert(t=='un6y1d');return{fields={{id=index_id}}}end
E.GameSession={in_session=function(s)return s==7 end,
 objects_owned_by=function(s,p)
  owned_calls=owned_calls+1;local out={ids[p]}
  if p==bp2 then for i=1000,1299 do out[#out+1]=i end end
  return out
 end,
 game_object_exists=function(s,id)exists_checks=exists_checks+1;return owner[id]~=nil end,
 game_object_is_type=function(s,id,t)return owner[id]~=nil and t=='un6y1d'end,
 game_object_owner=function(s,id)return owner[id]end,
 game_object_field=function(s,id,f)assert(f=='index');return native_index[owner[id]]end}
local booster_log={}
local boosters=env.require(B..'squad_boosters').new(E,function(v)booster_log[#booster_log+1]=v end)
boosters.update(0);assert(count('image')==1 and count('line')==0,'pending identity must keep only local booster')
local bt=2.01
for i=1,20 do
 local before=exists_checks;boosters.update(bt)
 assert(exists_checks-before<=40,'identity scan exceeded per-update budget')
 bt=bt+.21
end
assert(count('image')==2 and count('line')==6,'large host object list blocked native mapping')
local booster_images={}
for _,c in ipairs(canvases)do if c.opts.layer==45 then for _,i in ipairs(c.items)do
 if i.kind=='image'then booster_images[#booster_images+1]=i.args end
end end end
assert(booster_images[1][1]:find('vitality',1,true)and booster_images[2][1]:find('stamina',1,true),'peer association misplaced booster')
local spec=env.require(B..'booster_layout')
assert(booster_images[2][2]+spec.icon_size<spec.tag_left,'booster overlaps colored label')
assert(booster_images[2][3]+spec.icon_size<spec.local_tag_center_y,'booster not above label row')
local old_owned=owned_calls;local old=finishes
squad={squad[2],squad[1],squad[3]};boosters.update(bt);bt=bt+.21
assert(finishes==old and owned_calls==old_owned,'cached identity rescanned on shuffled Hub roster')
buffs.players={buffs.players[2],buffs.players[3]};boosters.update(bt);bt=bt+.21
assert(count('image')==2 and count('line')==0,'unknown data rendered as unequipped')
booster_ready=false;boosters.update(bt);bt=bt+.21;assert(count()==0)
booster_ready=true;squad[3]=squad[1];boosters.update(bt);assert(count()==0,'duplicate peer accepted')
boosters.shutdown();assert(count()==0)
-- Four players: native C3,A2,N1 rows disagree with Hub slots 1,2,3.
local bp4='4444444444444444';owner[14]=bp4;ids[bp4]=14
native_index[bp1]=0;native_index[bp2]=2;native_index[bp4]=1
squad={{peer=bp3,slot=0,is_local=true},{peer=bp1,slot=1,is_local=false},
 {peer=bp2,slot=2,is_local=false},{peer=bp4,slot=3,is_local=false}}
buffs.players={}
for _,p in ipairs(squad)do buffs.players[#buffs.players+1]={peer=p.peer,slot=p.slot,is_local=p.is_local,
 booster={id=1,name=({[bp1]='Stamina',[bp2]='HellpodSpaceOptimization',[bp4]='CombatDrugs',[bp3]='Vitality'})[p.peer]}}end
boosters=env.require(B..'squad_boosters').new(E)
bt=10;boosters.update(bt)
for i=1,30 do bt=bt+.21;boosters.update(bt)end
local function image_names(layer)
 local out={};for _,c in ipairs(canvases)do if c.opts.layer==layer then for _,i in ipairs(c.items)do
  if i.kind=='image'then out[#out+1]=i.args[1]end
 end end end;return out
end
local names=image_names(45)
assert(#names==4 and names[1]:find('hellpodspaceoptimization',1,true)
 and names[2]:find('combatdrugs',1,true)and names[3]:find('stamina',1,true),'native index order ignored')
native_index[bp4]=native_index[bp2];boosters.update(bt+2.1)
assert(count('image')==1,'duplicate native index must hide teammate icons')
boosters.shutdown();assert(count()==0)
-- RTT comparison path has no native scan and joins by peer, not RTT/Hub order.
local function forbidden()error('RTT booster attempted native scan')end
E.Network=setmetatable({},{__index=function()return forbidden end})
E.GameSession=setmetatable({},{__index=function()return forbidden end})
net={state='READY',rows={{peer=bp4,label='Andew',ms=119},{peer=bp1,label='neo',ms=41},{peer=bp2,label='charlie',ms=124}}}
ping=env.require(B..'network_ping_hud').new(E,function()end)
local ping_reads=0
overrides[B..'network_ping']={new=function()return{read=function()ping_reads=ping_reads+1;return net end,shutdown=function()end}end}
ping.shutdown();ping=env.require(B..'network_ping_hud').new(E,function()end)
ping.update(0);names=image_names(70)
assert(#names==3 and names[1]:find('combatdrugs',1,true)and names[2]:find('stamina',1,true)
 and names[3]:find('hellpodspaceoptimization',1,true),'RTT boosters not joined to displayed peers')
assert(count('line')==0,'RTT divider was not replaced')
local icon_before=nil
for _,c in ipairs(canvases)do if c.opts.layer==70 then for _,i in ipairs(c.items)do
 if i.kind=='image'and not icon_before then icon_before=i.args end
end end end
ping.set_scale(1.5);ping.update(.1)
for _,c in ipairs(canvases)do if c.opts.layer==70 then for _,i in ipairs(c.items)do
 if i.kind=='image'then assert(i.args[4]==icon_before[4]*1.5,'RTT icon scaling inconsistent')end
end end end
-- Switch columns live: booster-only skips RTT reads; RTT-only omits icons.
local reads_before=ping_reads
ping.set_content(false,true);ping.update(.15)
assert(ping_reads==reads_before and #image_names(70)==3 and #text_items()==4,'booster-only panel must retain identities/icons without RTT calls')
for _,t in ipairs(text_items())do assert(not t[1]:find('ms',1,true),'hidden RTT text remained')end
ping.set_content(true,false);ping.update(.16)
assert(#image_names(70)==0 and #text_items()==7,'RTT-only panel retained booster icons')
ping.set_content(false,false);ping.update(.17);assert(count()==0,'both columns off must hide entire panel')
ping.set_content(false,true);ping.update(.18);assert(#image_names(70)==3,'list did not restore after hiding')
booster_ready=false;ping.update(.4);assert(count('image')==0,'Hub shutdown left RTT boosters visible')
ping.shutdown();assert(count()==0)
-- MDL three-way choice routes blood-bar/list renderers independently of RTT.
local panel_live,blood_live=false,false;local shown_latency,shown_list=nil,nil
local function noop()end
overrides[B..'network_ping_hud']={new=function()
 panel_live=true
 return{set_content=function(a,b)shown_latency=a;shown_list=b end,set_scale=noop,set_position=noop,update=noop,
 shutdown=function()panel_live=false end}
end}
overrides[B..'squad_boosters']={new=function()
 blood_live=true;return{update=noop,shutdown=function()blood_live=false end}
end}
local modes={'仅血条','仅列表','血条+列表'}
ctx={settings={weapon_hud=false,frv_hud=false,tank_hud=false,mech_hud=false,booster_hud=true}}
mod.on_enable(ctx)
for _,mode in ipairs(modes)do for _,latency in ipairs({false,true})do
 ctx.settings.booster_display=mode;ctx.settings.network_hud=latency
 mod.on_setting(ctx,'booster_display',mode)
 local list=mode~='仅血条';local blood=mode~='仅列表'
 assert(blood_live==blood and panel_live==(latency or list),'MDL mode routed to wrong renderer')
 if panel_live then assert(shown_latency==latency and shown_list==list,'MDL column flags changed meaning')end
end end
ctx.settings.booster_hud=false;ctx.settings.network_hud=false;mod.on_setting(ctx,'booster_hud',false)
assert(not blood_live and not panel_live,'all display options off left a panel alive')
ctx.settings.network_hud=true;mod.on_setting(ctx,'network_hud',true)
assert(panel_live and shown_latency and not shown_list and not blood_live,'booster master interfered with RTT')
mod.on_disable();assert(not panel_live and not blood_live)
-- Both MDL entry points share the same public owner and persisted values.
local public_values={['integrated_hud.weapon_scale']=125}
local specs={};local fail_key=nil
local menu={
 get=function(id)return public_values[id]end,
 set=function(id,v)public_values[id]=v;return true end,
 register_option=function(id,spec)
  if id==fail_key then return false end
  specs[id]=spec
  if public_values[id]==nil then public_values[id]=spec.default end
  return true
 end
}
env.ModOptionsMenu=menu
local settings=env.require(B..'hud_options').new()
local migrated={settings={weapon_hud=false,frv_hud=false,tank_hud=false,mech_hud=false,
 booster_hud=true,booster_display='仅列表',network_hud=false,weapon_scale=75}}
local fallback=settings.register(migrated)
assert(#fallback==0,'registered options duplicated in native menu')
local n=0;for id,spec in pairs(specs)do
 n=n+1;assert(spec.mod_id==B..'main'and type(spec.mod)=='function'and spec.mod()=='Integrated HUD','public settings split into different groups')
end
assert(n==13,'incomplete public options menu')
-- Dynamic text follows MDL by default; forcing Chinese does not change values.
local loc=env.require(B..'localization')
local language_spec=specs['integrated_hud.language']
assert(language_spec.default==1 and #language_spec.choices==3 and language_spec.choices[1]()=='Follow MDL','language defaults/options differ from request')
env.MDL={i18n={code='en'}}
assert(loc.code()=='en'and specs['integrated_hud.weapon_hud'].label()=='Weapon HUD','English MDL not followed')
local label_callback=specs['integrated_hud.weapon_hud'].label
local boost_choices=specs['integrated_hud.booster_display'].choices
env.MDL.i18n.code='zh_hans'
assert(loc.code()=='zh-CN'and label_callback()=='武器 HUD'and boost_choices[2]()=='仅列表','MDL language change did not refresh dynamic strings')
menu.set('integrated_hud.language',2);env.MDL.i18n.code='en'
assert(loc.code()=='zh-CN'and label_callback()=='武器 HUD','forced Chinese followed English MDL')
local catalogs=env.require(B..'locale_data');local saved_label=catalogs['zh-CN'].strings['options.tank_hud.label']
catalogs['zh-CN'].strings['options.tank_hud.label']=nil
assert(specs['integrated_hud.tank_hud'].label()=='Tank HUD','missing translation did not fall back to English')
catalogs['zh-CN'].strings['options.tank_hud.label']=saved_label
settings.register(migrated)
assert(specs['integrated_hud.weapon_hud'].label==label_callback and loc.code()=='zh-CN','re-enable recreated text callbacks or lost language preference')
menu.set('integrated_hud.language',1);env.MDL.i18n.code='fr'
assert(loc.code()=='en'and label_callback()=='Weapon HUD','untranslated MDL language did not fall back')
env.MDL.i18n.code='auto';env.MDL3.ui={language='zh-CN'}
assert(loc.code()=='zh-CN','MDL3 UI language fallback missing')
menu.set('integrated_hud.language',3);env.MDL.i18n.code='zh-CN'
assert(loc.code()=='en'and label_callback()=='Weapon HUD','forced English followed Chinese MDL')
menu.set('integrated_hud.language',1)
env.MDL=setmetatable({},{__index=function()error('temporary host language failure')end})
env.MDL3.ui=nil
assert(loc.code()=='en'and label_callback()=='Weapon HUD','host language exception escaped to HUD')
env.MDL=nil
assert(loc.code()=='en','missing MDL language did not fall back')
-- Re-entrant settings providers must not overflow translated label callbacks.
loc.set_source(function()loc.t('mod.title');return 'en'end)
assert(loc.code()=='en','recursive menu language lookup was not contained')
settings.register(migrated)
env.MDL={i18n={code='en'}}
assert(settings.read(migrated).booster_display=='仅列表','translated choice changed internal booster mode')

local values=settings.read(migrated)
assert(values.weapon_hud==false and values.network_hud==false and values.booster_display=='仅列表','legacy false/choice not migrated')
assert(values.weapon_scale==125 and migrated.settings.options_menu_migrated_v1,'saved slider overwritten or migration missing')
menu.set('integrated_hud.network_hud',true);menu.set('integrated_hud.booster_display',1)
settings.register(migrated);values=settings.read(migrated)
assert(values.network_hud==true and values.booster_display=='仅血条','stale native settings overwrote public changes')
fail_key='integrated_hud.tank_hud';fallback=settings.register(migrated)
assert(#fallback==1 and fallback[1].key=='tank_hud','registration failure must only restore affected native setting')
fail_key=nil
-- Main lifecycle consumes public toggles/choice and retains them across enable.
mod.on_enable(migrated)
assert(#mod.options==0 and panel_live and shown_latency and not shown_list and blood_live,'main did not consume unified public settings')
menu.set('integrated_hud.booster_display',2);menu.set('integrated_hud.network_hud',false)
mod.on_update(migrated,0.016)
assert(panel_live and not shown_latency and shown_list and not blood_live,'public choice did not apply live')
mod.on_disable();mod.on_enable(migrated)
assert(panel_live and not shown_latency and shown_list and not blood_live,'public menu values lost on re-enable')
menu.set('integrated_hud.booster_hud',false);mod.on_update(migrated,0.016)
assert(not panel_live and not blood_live,'public master toggle ignored')
mod.on_disable()
return {localization_three_choices_safe_fallback_and_mdl_default=true,belt_grenade_three_rpm_settings_and_ambiguity=true,hub_captured_three_connected_weapons_false_feed_flag=true,hub_unsupported_input_diagnostics_and_pack_lease=true,hub_direct_backpack_feed_and_empty_count=true,mdl_unified_options_migration_and_live_poll=true,weapon_independent_inner_charge_without_numbers=true,weapon_ship_gate_and_scene_transition=true,booster_three_modes_and_panel_visibility=true,squad_boosters_incremental_native_index_and_cache=true,network_boosters_peer_join_no_native_scan=true,squad_boosters_peer_join_and_self=true,squad_boosters_native_images_and_empty_hex=true,squad_boosters_unknown_and_cleanup=true,squad_boosters_upper_left_anchor=true,hub_exact_weapon_no_firing_needed=true,hub_network_ids_separated=true,hub_backpack_fallback_no_double_count=true,hub_backpack_lease_warm_and_pickup_refresh=true,vehicle_hp_measured_center_and_75pct_size=true,hub_heat_magazine_switch=true,hub_backpack_reserve_passthrough=true,
 hub_reload_keeps_current_ammo_visible=true,hub_respawn_and_disable_clear=true,mdl_native_text_and_images=true,mdl_weapon_fixed_anchor_scale=true,
 mdl_vehicle_adapter=true,mdl_ping_unicode_and_position=true,mdl_lifecycle_cleanup=true}
