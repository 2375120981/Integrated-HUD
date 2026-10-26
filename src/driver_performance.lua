-- Keep the proven original GUI and binding; update only displayed telemetry.
do
 refresh_bound=function(session,owned)
  local hid=M.hull;if not hid then return end
  if call(GS.game_object_exists,session,hid)~=true then FRV.drop_tank();return end
  local c=cache_for(hid);local now=M.clock
  if now>=(c.next_hull or 0)then
   c.next_hull=now+.1
   local hf=sample(session,hid)
   if type(hf)=='table'then
    if not FRV.hull_values(hf,hid)or(type(hf[30])=='number'and hf[30]<=0)then
     if type(hf[30])=='number'and hf[30]<=0 then Lua51.dead_id=hid end
     FRV.drop_tank();return
    end
    c.hp=hf[30];c.max=hf[15];c.hull_valid_at=now
    remember_hull(hid,hf)
   end
  end
  if not c.hull_valid_at or now-c.hull_valid_at>.3 then
   c.hp,c.max=nil,nil;clear_values();return
  end
  M.hp,M.max=c.hp,c.max;M.ammo=nil;M.mg=nil
 end
 -- No weapon channels, reload bookkeeping, field dumps or periodic status
 -- formatting run in the active path. Preserve concise lifecycle/error logs.
 Lua51.report=function()end
 local verbose_log=log
 log=function(s)
  if s:find('ERROR',1,true)or s:find('RECOVER',1,true)or s:find('UNAVAILABLE',1,true)
   or s:find('HUD_ENTER',1,true)or s:find('HUD_EXIT',1,true)
   or s:find('MECH_BIND',1,true)or s:find('MECH_UNBIND',1,true)
   or s:find('BASTION_BIND',1,true)or s:find('entry_mask_confirmed',1,true)
   or s:find('vehicle_bound_',1,true)or s:find('SHUTDOWN',1,true)then verbose_log(s)end
 end
 verbose_log('IHUD_PERFORMANCE version=0.3.0 tank=hull_and_seats_only ownership_cache_seconds=0.2 logging=lifecycle_and_errors')
end
