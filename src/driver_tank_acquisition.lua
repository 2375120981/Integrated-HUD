-- Discover the observed five-child tank hull from existing shared samples.
-- Register structure/baselines only: actual binding remains the original
-- unique seat-change or explicit avatar-reference path.
do
 local original_sample=sample
 local checked_frame,checked_entry,checked=-1,nil,{}
 sample=function(session,id)
  local f,why=original_sample(session,id)
  local e=Lua51.entry
  if e and e.session==session and e.avatar==M.avatar and e.world==M.world
   and hull_sig(f)and seat_mask(f)~=nil and type(f[56])=='table'then
   if checked_frame~=M.frame or checked_entry~=e then
    checked_frame=M.frame;checked_entry=e;checked={}
   end
   if checked[id]==f then return f,why end;checked[id]=f
   local count,seen,valid=0,{},true
   for _,child in pairs(f[56])do
    if child==id or not valid_goid(session,child)or seen[child]then valid=false;break end
    seen[child]=true;count=count+1
   end
   if valid and count==5 then
    local known=e.registry[id]and e.registry[id].confirmed
    Lua51.remember_reference_hull(session,id,f)
    if not known then
     log('IHUD_TANK_CANDIDATE hull='..id..' children=5 source=shared_batch actual_seat_proof_required=true')
    end
    local motion=call(GS.game_object_field,session,e.avatar,'motion_enabled')
    local where=call(GS.game_object_field,session,e.avatar,'gls4w9b')
    local state=call(GS.game_object_field,session,e.avatar,'state')
    if motion==true and where==100 and state==0 then
     local v=e.registry[id].value
     e.baseline[id]={mask=v.mask,key=v.key,at=v.at}
    end
   end
  end
  return f,why
 end
 log('IHUD_TANK_ACQUISITION version=0.3.3 five_child_hull_discovery=shared_batch seat_binding=original')
end
