local data,avatar_ref,motion,owner,exists={},500,false,10,true
local G={}
G.game_object_exists=function(_,id)return id==10 or id==500 and exists end
G.game_object_field=function(_,id,key)
 if key=='motion_enabled'then return motion elseif key=='gls4w9b'then return 100 elseif key=='state'then return 0 end
end
local body={[19]={[3]=6000,[6]={498,499}},[27]=10,[28]='position',[56]=1800,[65]=1800,[76]=3}
local c={session=1,peer=0,world='main',avatar=10,sample=function(_,id)
 if id==10 then return {[64]={[25]=avatar_ref}}else return body end
end}
local logs={};local reader=assert(loadstring(BINDING_SOURCE))().new(G,function(s)logs[#logs+1]=s end)
motion=true;assert(reader.update(1,c)==nil,'walking proximity reference must not bind')
motion=false;body[27]=11;assert(reader.update(2,c)==nil,'foreign pilot bound')
body[27]=10;local s=reader.update(3,c);assert(s and s.id==500 and s.hp==1800)
body[56]=1170;s=reader.update(3.2,c);assert(s.hp==1170 and s.max==1800)
body[27]=32767;s=reader.update(3.4,c);assert(s and s.id==500,'brief reciprocal transition dropped')
assert(reader.update(4.1,c)==nil,'expired reciprocal proof retained')
body[27]=10;assert(reader.update(4.3,c))
body[19][6]={};assert(reader.update(4.5,c),'missing weapon must not hide a proven body')
motion=true;assert(reader.update(4.7,c)==nil)
body[19][6]={498,499};motion=false;body[27]=10;assert(reader.update(5,c))
body[56]=0;assert(reader.update(5.2,c)==nil,'destroyed body retained')
-- Reproduce the live failure: seated with no direct avatar reference.
reader.reset();avatar_ref=32767;body[56]=1800;body[27]=10
local other={[19]={[3]=6000,[6]={598,599}},[27]=11,[28]='position',[56]=1800,[65]=1800,[76]=3}
local blocked=true
c.owned_ids={10,499,500,600}
c.sample=function(_,id)
 if id==10 then return {[64]={[25]=avatar_ref}}end
 if id==500 and blocked then blocked=false;return nil,'budget'end
 if id==500 then return body elseif id==600 then return other else return {}end
end
local result
for i=1,10 do result=reader.update(6+i*.2,c);if result then break end end
assert(result and result.id==500,'reverse lookup or budget retry failed')
body[27]=32767;assert(reader.update(9,c)==nil,'reverse-only binding retained without driver proof')
reader.reset();body[27]=10;other[27]=10
for i=1,10 do assert(reader.update(10+i*.2,c)==nil,'ambiguous reverse candidates bound')end
reader.reset();other[27]=11;motion=true
assert(reader.update(13,c)==nil,'reverse lookup bound while walking')
-- An owned roster of 263 objects can be classified while walking. Only the
-- genuine mech candidate needs fresh validation after entering the seat.
reader.reset();motion=true;body[27]=32767;other[27]=11
c.owned_ids={10,500,600}
for id=1000,1259 do c.owned_ids[#c.owned_ids+1]=id end
local reads=0
c.sample=function(_,id)
 reads=reads+1
 if id==10 then return {[64]={[25]=32767}}elseif id==500 then return body
 elseif id==600 then return other else return {}end
end
for i=1,80 do reader.prewarm(14+i*.1,c)end
assert(reader.snapshot==nil,'prewarming drew a walking HUD')
reader.release();motion=false;body[27]=10;reads=0
assert(reader.update(22.1,c)==nil)
local fast=reader.update(22.3,c)
assert(fast and fast.id==500 and reads<=6,'warm entry rescanned the full roster')
motion=true;assert(reader.update(22.4,c)==nil,'warm entry exit did not clear')
-- Re-enter long after the 15s negative-hint expiry, with hundreds of new
-- unrelated objects. Known mech driver confirmation must bypass that backlog.
for id=2000,2399 do c.owned_ids[#c.owned_ids+1]=id end
reader.release();motion=false;reads=0
assert(reader.update(40,c)==nil)
local crowded=reader.update(40.2,c)
assert(crowded and crowded.id==500 and reads<=6,'crowded scene blocked cached mech')
-- Never use a cached driver relationship while network proof is absent.
reader.release();body[27]=32767
assert(reader.update(41,c)==nil)
assert(reader.update(41.2,c)==nil,'cached driver proof reused')
body[27]=10
reader.update(41.4,c)
assert(reader.update(41.6,c),'known candidate was not retried during background scan')
motion=true;assert(reader.update(41.8,c)==nil)
-- Cache context must not survive changing sessions.
c.session=2;reader.prewarm(43,c);motion=false
assert(reader.update(43.2,c)==nil,'old context warm cache reused')
return {reciprocal_binding=true,walking_and_foreign_rejected=true,live_total_hp=true,transition_bounded=true,missing_arm_keeps_body=true,exit_and_death_clear=true,missing_direct_reverse_lookup=true,budget_retry=true,ambiguous_reverse_rejected=true,reverse_proof_loss_clears=true,onfoot_warm_entry_skips_full_roster=true,warm_context_invalidated=true,crowded_cached_entry_bypasses_roster=true,cached_driver_proof_not_reused=true}
