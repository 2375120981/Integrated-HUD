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

return {ping_provider_basic_checks=true}
