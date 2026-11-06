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
-- No supplemental selector is allowed to influence Hub's identity or ammo type.
local details_read={};local extra_available=true;local detail_refreshes=0;local backpack_reads=0
overrides[B..'weapon_details']={new=function()return{read=function(id)details_read[#details_read+1]=id;if extra_available then return{mode='FLAK',backpack_fed=id==105}end end,reset=function()end,refresh=function()detail_refreshes=detail_refreshes+1 end}end}
local me={entity=10,player_entity=1,peer='1111111111111111',life='alive',alive=true,
 weapon={entity=101,slot='primary',ammo_type='heat',heat={value=30,max=100,frac=.3,locked=false},reload={active=false}}}
local ready=true
env.HD2Data={version='0.6.0',ready=function()return ready end,player_ammo=function()return me end,backpacks=function()backpack_reads=backpack_reads+1;return nil end}
local reader=env.require(B..'reader').new(E,function()end)
local v=reader.read(0);assert(v.kind=='heat'and v.entity==101 and v.heat_percent==30)
me.weapon={entity=102,slot='secondary',ammo_type='magazine',rounds=2,capacity=3,mags=4,reload={active=false}}
v=reader.read(.001);assert(v.kind=='ammo'and v.entity==102 and v.rounds==2 and v.mags==4,'switch without firing remained stale')
me.weapon.entity=103;me.weapon.rounds=7;me.weapon.mags=5
v=reader.read(.002);assert(v.entity==103 and v.rounds==7,'support identity failed')
me.weapon.reload.active=true;assert(reader.read(.003).state=='RELOADING')
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
ready=false;assert(reader.read(.007).state=='WAIT HUB');ready=true
local hub=env.HD2Data;env.HD2Data=nil;assert(reader.read(.008).state=='HUB REQUIRED');env.HD2Data=hub
hub.version='0.3.0';assert(reader.read(.009).state=='HUB 0.6 REQUIRED');hub.version='0.6.0'
reader.shutdown()
-- Real MDL view: one arc, native text, images, scaling and reload clearing.
local view=env.require(B..'weapon_view').new(function()end)
v={state='READY',entity=102,kind='ammo',ratio=.5,rounds=2,mags=4,mode='FLAK',rpm='600 RPM'}
view.update(v,1,1);assert(count('triangle')>0 and count('text')==4 and count('image')==1)
local arcs=count('triangle');v.ratio=.2;view.update(v,1,1);assert(count('triangle')==arcs,'arc cannot use MDL in-place updates');v.ratio=.5;view.update(v,1,1)
local old=finishes;view.update(v,1,1);assert(finishes==old,'stable MDL content rebuilt')
local ammo=text_items()[2];assert(ammo[1]=='2 / 4'and ammo[4].size==24)
local x,y=ammo[2],ammo[3]
view.update(v,1.5,1.5);ammo=text_items()[2]
assert(math.abs(ammo[2]-(960+(x-960)*1.5))<1e-6 and math.abs(ammo[3]-(540+(y-540)*1.5))<1e-6,'fixed anchor lost')
assert(ammo[4].size==54,'ammo size did not compose')
view.update({state='RELOADING'},1,1);assert(count()==0,'reload did not hide HUD')
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
ping.update(0);assert(count('text')==5 and count('line')==1)
local texts=text_items();assert(texts[2][1]~='中文，Very long player'and texts[2][1]:find('中文',1,true),'UTF8 prefix failed')
local oldx,oldy=texts[1][2],texts[1][3]
ping.set_position(50,25);ping.update(1);texts=text_items();assert(texts[1][2]>oldx and texts[1][3]<oldy)
cursor=true;old=finishes;ping.update(2);assert(count('text')==5 and old==finishes)
ping.shutdown();assert(count()==0)
-- Real one-shot notice presentation; no write task is executed here.
local notice=env.require('mods/integrated_hud/native_sniper_notice').new(E,'apply')
notice.update('success',0);assert(count('rect')==1 and count('text')==5)
assert(text_items()[1][1]:find('成功启用',1,true));notice.shutdown();assert(count()==0)
-- Managed toggles still dispatch and independently stop each view.
local reads,vehicle_updates,vehicle_stops=0,0,0
local current=v
overrides[B..'reader']={new=function()return{reset=function()end,read=function()reads=reads+1;return current end,shutdown=function()end}end}
overrides['mods/integrated_hud/driver_reference/driver_core']=function()return{
 update=function()vehicle_updates=vehicle_updates+1 end,set_views=function()end,shutdown=function()vehicle_stops=vehicle_stops+1 end}end
local mod=env.require(B..'main');local ctx={settings={}}
mod.on_enable(ctx);cursor=false;mod.on_update(ctx,.1);assert(reads==1 and vehicle_updates==1 and count()>0)
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
local booster_log={}
local boosters=env.require(B..'squad_boosters').new(E,function(v)booster_log[#booster_log+1]=v end)
boosters.update(0);assert(count('image')==2 and count('line')==6,'individual booster/empty hex missing')
local booster_images={}
for _,c in ipairs(canvases)do if c.opts.layer==45 then for _,i in ipairs(c.items)do
 if i.kind=='image'then booster_images[#booster_images+1]=i.args end
end end end
assert(booster_images[1][1]:find('vitality',1,true)and booster_images[2][1]:find('stamina',1,true),'shuffled peer association misplaced booster')
local spec=env.require(B..'booster_layout')
assert(booster_images[2][2]+spec.icon_size<spec.tag_left,'booster overlaps colored label')
assert(booster_images[2][3]+spec.icon_size<spec.local_tag_center_y,'booster not above microphone/label row')
local old=finishes;squad={squad[2],squad[1],squad[3]};boosters.update(.21)
assert(finishes==old,'roster iteration order changed displayed rows')
-- Missing member data is not confirmation of no booster.
buffs.players={buffs.players[2],buffs.players[3]};boosters.update(.42)
assert(count('image')==2 and count('line')==0,'unknown booster data rendered as unequipped')
-- No icon may survive Hub shutdown or an ambiguous roster.
booster_ready=false;boosters.update(.5);assert(count()==0)
booster_ready=true;squad[3]=squad[1];boosters.update(.7);assert(count()==0,'duplicate peer roster was accepted')
boosters.shutdown();assert(count()==0)
return {squad_boosters_peer_join_and_self=true,squad_boosters_native_images_and_empty_hex=true,squad_boosters_unknown_and_cleanup=true,squad_boosters_upper_left_anchor=true,hub_exact_weapon_no_firing_needed=true,hub_network_ids_separated=true,hub_backpack_fallback_no_double_count=true,hub_backpack_lease_warm_and_pickup_refresh=true,vehicle_hp_measured_center_and_75pct_size=true,hub_heat_magazine_switch=true,hub_backpack_reserve_passthrough=true,
 hub_reload_hidden=true,hub_respawn_and_disable_clear=true,mdl_native_text_and_images=true,mdl_weapon_fixed_anchor_scale=true,
 mdl_vehicle_adapter=true,mdl_ping_unicode_and_position=true,mdl_one_shot_notice=true,mdl_lifecycle_cleanup=true}
