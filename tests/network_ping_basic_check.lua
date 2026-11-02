-- One bounded Hub/RTT workflow; forbidden remote-object calls are counted even under pcall.
local BASE='mods/integrated_hud/mdl_gamesession/'
local env=setmetatable({},{__index=_G});env._G=env
env.require=function(name)assert(name==BASE..'utf8_text');return assert(loadstring(SOURCES[name]))()end
local f=assert(loadstring(SOURCES[BASE..'network_ping']));setfenv(f,env);local make=f()
local peers={'1111111111111111','2222222222222222','3333333333333333','4444444444444444'}
local me,session,epoch=peers[3],1,1
local members={peers[4],peers[2],peers[3],peers[1]}
local players={{peer=peers[4],slot=1,is_local=false},{peer=peers[3],slot=2,is_local=true},
 {peer=peers[1],slot=0,is_local=false},{peer=peers[2],slot=3,is_local=false}}
local ready,in_mission=true,true
local links=nil;local host_peer=peers[1];local broken_links={};local inactive_links={}
local forbidden,pings,lease=0,0,0;local mid_sample=nil
local trap=function()forbidden=forbidden+1;error('forbidden remote object API')end
local G=setmetatable({peers=function()return members end,in_session=function()return true end,game_session_host=function()return host_peer end},{__index=function()return trap end})
local N=setmetatable({connections=function()return links end,
 has_connection=function(p)return not inactive_links[p]end,is_broken=function(p)return broken_links[p]==true end,
 game_session=function()return session end,peer_id=function()return me end,
 ping=function(p)
  assert(p~=me);pings=pings+1
  if mid_sample then local fn=mid_sample;mid_sample=nil;fn()end
  return p==peers[1]and .041 or p==peers[2]and .1234 or .245
 end},{__index=function()return trap end})
local D={ready=function()return ready end,mission=function()return{in_mission=in_mission,epoch=epoch}end,
 players=function(detail)assert(detail==false,'unneeded detailed Hub lease');lease=lease+1;return players end}
local diagnostic_log={}
local reader=make.new({Network=N,GameSession=G},function(s)diagnostic_log[#diagnostic_log+1]=s end)
assert(reader.read(0).state=='HUB REQUIRED'and pings==0)
env.HD2Data=D
assert(reader.read(.1).state=='CONFIRMING PLAYER IDS')
local d=reader.read(1.1)
assert(d.state=='READY'and #d.rows==3 and d.local_slot==3 and pings==3)
assert(d.rows[1].slot==1 and d.rows[1].peer==peers[1]and d.rows[1].ms==41)
assert(d.rows[2].slot==2 and d.rows[2].peer==peers[4]and d.rows[2].ms==245)
assert(d.rows[3].slot==4 and d.rows[3].peer==peers[2]and d.rows[3].ms==123)
local n=lease;reader.read(1.2);assert(lease==n and pings==3,'sampling not throttled')
-- Slot reassignment is confirmed again, never filled from connection order.
players[1].slot,players[4].slot=3,1
assert(reader.read(2.1).state=='CONFIRMING PLAYER IDS')
d=reader.read(3.1);assert(d.rows[2].peer==peers[2]and d.rows[3].peer==peers[4])
players[1].slot=1;assert(reader.read(4.1).state=='CONFIRMING PLAYER IDS')
players[1].slot=3;reader.read(5.1);reader.read(6.1)
mid_sample=function()members={me,peers[1]}end
assert(#reader.read(7.1).rows==0,'mid-sample leave published old rows')
-- Hub's stale four-person snapshot cannot be relabelled to the new roster.
assert(reader.read(8.1).state=='CONFIRMING PLAYER IDS')
players={players[2],players[3]};reader.read(9.1);d=reader.read(10.1)
assert(#d.rows==1 and d.rows[1].peer==peers[1])
-- Hub reload, mission change, and same-count replacement invalidate confirmation.
epoch=2;assert(reader.read(11.1).state=='CONFIRMING PLAYER IDS')
reader.read(12.1)
env.HD2Data=nil;assert(reader.read(12.2).state=='HUB REQUIRED')
env.HD2Data=D;assert(reader.read(12.3).state=='CONFIRMING PLAYER IDS')
local replacement='5555555555555555'
members={me,replacement};assert(reader.read(13.3).state=='CONFIRMING PLAYER IDS')
players[2]={peer=replacement,slot=0,is_local=false}
reader.read(14.3);d=reader.read(15.3);assert(d.rows[1].peer==replacement)
-- Both local roles read every remote. No host/client branch filters RTT targets.
me=peers[1];members={peers[4],peers[2],peers[3],peers[1]}
players={{peer=peers[1],slot=0,is_local=true},{peer=peers[2],slot=3,is_local=false},
 {peer=peers[3],slot=2,is_local=false},{peer=peers[4],slot=1,is_local=false}}
reader.read(16.3);d=reader.read(17.3);assert(#d.rows==3 and d.local_slot==1)
N.ping=function()return 0/0 end
d=reader.read(18.3);for _,r in ipairs(d.rows)do assert(r.ms==nil)end
ready=false;assert(reader.read(19.3).state=='WAIT HUB')
ready=true;in_mission=false;assert(reader.read(20.3).state=='CONFIRMING PLAYER IDS')
members={me};assert(reader.read(21.3).state=='SESSION ONLY')
session=nil;assert(reader.read(22.3).state=='NO SESSION')
-- Reproduce the reported client-first Hub slots: local C2 has slot 0; host R1 has slot 1.
-- The remote row must use its name, never pretend that Hub slot 1 means native P2.
session=2;epoch=3;me=peers[3];members={peers[1],me}
players={{peer=me,slot=0,is_local=true,name='Creeper'},
 {peer=peers[1],slot=1,is_local=false,name='RPlayer'}}
in_mission=true;N.ping=function()return .261 end
reader.read(23.3);d=reader.read(24.3)
assert(d.state=='READY'and #d.rows==1 and d.rows[1].peer==peers[1]and d.rows[1].label=='RPlayer'and d.rows[1].ms==261)
players[1].name='Same';players[2].name='Same';reader.read(25.3);d=reader.read(26.3)
assert(d.rows[1].label==peers[1],'duplicate names were ambiguous')
players[2].name=string.char(228,184,173);reader.read(27.3);d=reader.read(28.3)
assert(d.rows[1].label==string.char(228,184,173),'Chinese name fell back to peer ID')
-- Aboard ship / late join before dropping: Hub has no avatars/roster yet.
local named=players
in_mission=false;epoch=4;players=nil
assert(reader.read(29.3).state=='CONFIRMING PLAYER IDS')
d=reader.read(30.3)
assert(d.state=='READY'and #d.rows==1 and d.rows[1].peer==peers[1]and d.rows[1].label==peers[1]and d.rows[1].ms==261)
assert(d.rows[1].slot==nil,'invented player slot in peer fallback')
-- Arrival on the ground reconfirms phase and switches to names only when a full roster exists.
in_mission=true;epoch=5
assert(reader.read(31.3).state=='CONFIRMING PLAYER IDS')
assert(reader.read(32.3).state=='READY')
players=named;players[2].name='RPlayer'
assert(reader.read(33.3).state=='CONFIRMING PLAYER IDS')
d=reader.read(34.3);assert(d.rows[1].label=='RPlayer'and d.rows[1].peer==peers[1])
-- Invalid Hub identities must fall back to session IDs, never to their unverified names.
players[2].peer='9999999999999999'
reader.read(35.3);d=reader.read(36.3);assert(d.rows[1].label==peers[1]and d.rows[1].peer==peers[1])
-- Late join: staging GameSession contains only self, but destination connections exist.
players=nil;members={me};links={me,peers[1],peers[1],'invalid',peers[2],peers[4]}
broken_links[peers[2]]=true;inactive_links[peers[4]]=true
local lease_before=lease
assert(reader.read(37.3).state=='CONFIRMING PLAYER IDS')
d=reader.read(38.3)
assert(d.state=='READY'and d.source=='CONNECTIONS'and #d.rows==1)
assert(d.rows[1].peer==peers[1]and d.rows[1].label==peers[1]and d.rows[1].ms==261)
assert(lease==lease_before,'connection targets received unverified Hub names')
-- A remote host with no established link is a pending roster, not SOLO.
links={};assert(reader.read(39.3).state=='WAIT SQUAD')
host_peer=me;assert(reader.read(40.3).state=='SESSION ONLY')
-- Authoritative session membership takes priority over unrelated network links.
host_peer=peers[1];members={me,peers[1]};links={peers[2]}
players={{peer=me,slot=0,is_local=true,name='Creeper'},{peer=peers[1],slot=1,is_local=false,name='RPlayer'}}
assert(reader.read(41.3).state=='CONFIRMING PLAYER IDS')
d=reader.read(42.3);assert(d.source=='SESSION'and #d.rows==1 and d.rows[1].label=='RPlayer'and d.rows[1].peer==peers[1])
-- Diagnose the early return: a suppressed connection error and a Hub list that was never queried before.
members={me};host_peer=me;N.connections=function()error('SIMULATED_DENIED')end
D.player=function()return {peer=me,name='Creeper',slot=0,is_local=true}end
D.state=function()return 'ready'end
local pings_before=pings
assert(reader.read(43.3).state=='SESSION ONLY')
local dump=table.concat(diagnostic_log,'\n')
assert(dump:find('SIMULATED_DENIED',1,true)and dump:find('hub_count=2',1,true)and dump:find('hub_player ok',1,true))
N.connections=function()return {peers[1]}end;N.has_connection=function()return nil end;N.is_broken=function()return false end
assert(reader.read(44.3).state=='SESSION ONLY')
dump=table.concat(diagnostic_log,'\n');assert(dump:find('has_connection ok nil:nil',1,true),'filtered peer reason not captured')
assert(pings==pings_before,'diagnostics probed unverified peer latency')
reader.shutdown();assert(forbidden==0,'remote object API reached')

-- Independent GUI uses only the network reader and its own primitives.
local current={state='READY',local_slot=3,rows={{slot=2,label='中文，Name！',peer=peers[1],ms=41},{slot=2,peer=peers[2],ms=123},{slot=4,peer=peers[4],ms=245}}}
local serial,pool,cursor=0,{},false;local read_count,stopped=0,0;local geometry={}
local E={Application={worlds=function()return{'world'}end,main_world=function()return'world'end,back_buffer_size=function()return 1920,1080 end},World={},Gui={},Window={}}
E.World.create_screen_gui=function()return'ping-gui'end
E.World.destroy_gui=function()assert(next(pool)==nil)end
E.Vector2=function(...)return{...}end;E.Vector3=E.Vector2;E.Color=E.Vector2
E.Gui.triangle=function(_,a,b,c)serial=serial+1;pool[serial]=true;geometry[#geometry+1]={a,b,c};return serial end
E.Gui.destroy_triangle=function(_,id)assert(pool[id]);pool[id]=nil end
E.Window.show_cursor=function()return cursor end
local env=setmetatable({},{__index=_G});local modules={};local drawn={};local draw_calls={}
env.require=function(name)
 if name==BASE..'network_ping'then return{new=function()return{read=function()read_count=read_count+1;return current end,shutdown=function()stopped=stopped+1 end}end}end
 if modules[name]then return modules[name]end
 local f=assert(loadstring(SOURCES[name]));setfenv(f,env);modules[name]=f()
 if name==BASE..'network_text'then
  local original=modules[name].new
  modules[name].new=function(...)
   local art=original(...);local text=art.text
   art.text=function(...)local args={...};drawn[args[3]]=true;local width=text(...);draw_calls[#draw_calls+1]={text=args[3],x=args[4],y=args[5],height=args[6],width=width};return width end
   return art
  end
 end
 return modules[name]
end
local hud=env.require(BASE..'network_ping_hud').new(E,function()end)
hud.update(0);assert(next(pool)~=nil and not drawn.P2,'Hub slot leaked into native badge')
local first_name=draw_calls[2]
assert(first_name.text:sub(1,#'中文')=='中文'and #'中文，Name！'>#first_name.text,'Unicode name was not truncated to column')
assert(first_name.height==14,'long name was shrunk')
local divider_x=draw_calls[1].width
for _,i in ipairs({2,4,6})do
 local name,delay=draw_calls[i],draw_calls[i+1]
 assert(name.x+name.width<=divider_x-6+1e-6,'name crosses divider')
 assert(delay.x==divider_x+8 and delay.x<208,'latency column not compact/aligned')
 assert(delay.text:find('ms',1,true),'latency suffix missing')
end
local utf8=env.require(BASE..'utf8_text')
assert(utf8.split(first_name.text),'truncation split a UTF-8 character')
local full=current.rows[1].label
assert(full=='中文，Name！','display truncation mutated player identity')
before=serial;hud.update(1);assert(serial==before,'stable RTT geometry rebuilt')
local baseline=geometry;geometry={}
hud.set_scale(1.5);hud.update(1.1)
assert(#geometry==#baseline,'uniform scale changed pixel geometry')
for i,t in ipairs(baseline)do for j,p in ipairs(t)do
 local q=geometry[i][j]
 assert(math.abs(q[1]-p[1]*1.5)<1e-6,'horizontal left anchor/scale changed')
 assert(math.abs(q[3]-(540+(p[3]-540)*1.5))<1e-6,'vertical center anchor/scale changed')
end end
hud.set_scale(1);hud.update(1.2)
geometry={};hud.set_position(50,25);hud.update(1.3)
assert(#geometry==#baseline,'position changed panel size or layout')
local dx=geometry[1][1][1]-baseline[1][1][1]
local dy=geometry[1][1][3]-baseline[1][1][3]
assert(dx>0 and dy>0,'position axes directions incorrect')
for i,t in ipairs(baseline)do for j,p in ipairs(t)do
 local q=geometry[i][j]
 assert(math.abs(q[1]-p[1]-dx)<1e-6 and math.abs(q[3]-p[3]-dy)<1e-6,'position distorted relative layout')
end end
before=serial;hud.set_position(50,25);hud.update(1.35);assert(serial==before,'unchanged position rebuilt geometry')
geometry={};hud.set_position(100,100);hud.update(1.4)
for _,t in ipairs(geometry)do for _,p in ipairs(t)do assert(p[1]>=0 and p[1]<=1920 and p[3]>=0 and p[3]<=1080,'edge position left screen')end end
hud.set_position(0,50);hud.update(1.5)

current.rows[1].ms=42;hud.update(2);assert(serial>before)
before=serial;cursor=true;hud.update(3)
assert(next(pool)~=nil and serial==before,'equipment/menu cursor hid or rebuilt RTT')
current.rows[1].ms=43;hud.update(3.5)
assert(serial>before and next(pool)~=nil,'RTT stopped refreshing in menus')
cursor=false;before=serial;hud.update(4);assert(next(pool)~=nil and serial==before)
current.source='CONNECTIONS';hud.update(4.5);assert(drawn['CONNECTION RTT'],'connection-only peers mislabeled as squad')
current={state='NO SESSION',rows={}};hud.update(5);assert(next(pool)==nil)
hud.shutdown();assert(stopped==1)
return {ping_singleton_raw_diagnostics=true,ping_staging_connections=true,ping_pending_host_not_solo=true,ping_session_priority_over_connections=true,ping_ship_peer_fallback=true,ping_ship_to_ground_reconfirm=true,ping_hub_identity_binding=true,ping_client_first_slots_not_badges=true,ping_all_remotes_as_client=true,ping_all_remotes_as_host=true,
 ping_no_remote_object_apis=true,ping_hub_reload_and_epoch=true,ping_roster_churn_rejected=true,
 ping_invalid_rtt_not_zero=true,ping_independent_gui=true,ping_cached_geometry=true,ping_menu_visible_and_updates=true,ping_unicode_name_font=true,ping_left_anchored_scale=true,ping_compact_divider_columns=true,ping_utf8_prefix_without_shrink=true,ping_position_translation_and_bounds=true}
