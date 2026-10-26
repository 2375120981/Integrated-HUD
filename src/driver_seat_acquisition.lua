-- Narrow seat-acquisition fix and change-only supply-FRV diagnostics.
-- Uses data already read by the original core; no extra native batch reads.
do
 -- Captured supply-FRV entries: empty=127, first rear=126 (bit1),
 -- second rear=125 (bit2). The old 32/64 mapping missed both entries.
 seat_bits.FRV={8,16,1,2}
 seat_labels.FRV={[8]='driver',[16]='front_passenger',[1]='rear_left',[2]='rear_right'}
 local cabin_bits=Lua51.frv_cabin_bits
 Lua51.frv_cabin_bits=function(p)
  if p and p.name=='supply_frv'then return {8,16,1,2}end
  return cabin_bits(p)
 end
 local seat_debug=false
 local entry_sample=Lua51.entry_sample
 Lua51.entry_sample=function(session,id,r)
  local v,why=entry_sample(session,id,r)
  local e=Lua51.entry
  if why=='budget'and e and not e.ihud_budget_retry then e.ihud_budget_retry=id end
  if seat_debug and v and r.kind=='FRV'and r.p and r.p.name=='supply_frv'and e then
   local motion=call(GS.game_object_field,session,e.avatar,'motion_enabled')
   local where=call(GS.game_object_field,session,e.avatar,'gls4w9b')
   local state=call(GS.game_object_field,session,e.avatar,'state')
   local signature=table.concat({tostring(v.mask),tostring(motion),tostring(where),tostring(state)},':')
   e.ihud_supply_notes=e.ihud_supply_notes or{}
   local old=e.ihud_supply_notes[id]
   if old~=signature then
    e.ihud_supply_notes[id]=signature
    log('IHUD_SUPPLY_SEAT t='..string.format('%.3f',M.clock)..' avatar='..e.avatar..' hull='..id
     ..' mask='..tostring(v.mask)..' motion='..tostring(motion)..' where='..tostring(where)..' state='..tostring(state)
     ..' hp='..tostring(v.hp)..' ref='..tostring(M.vehicle_ref)..' links='..table.concat(v.links or{},','))
   end
  end
  return v,why
 end
 local observe=Lua51.observe_entry
 Lua51.observe_entry=function(...)
  local e=Lua51.entry;if e then e.ihud_budget_retry=nil end
  local keep=observe(...)
  e=Lua51.entry
  if e and e.ihud_budget_retry and not e.bound then
   -- The original two-object loop advances the cursor before sampling. If
   -- the second object is always budget-gated it can be skipped forever.
   local keys={};for id in pairs(e.registry)do
    if valid_goid(e.session,id)then keys[#keys+1]=id end
   end
   table.sort(keys)
   for i,id in ipairs(keys)do if id==e.ihud_budget_retry then e.read_cursor=i;break end end
  end
  return keep
 end
 log('IHUD_SEAT_ACQUISITION version=0.3.0 budget_retry=true supply_mask_diagnostics=false supply_seat_bits=8,16,1,2')
end
