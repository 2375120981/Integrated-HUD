-- Independent presentation switches on the shared, proven vehicle binding.
do
 local visible={FRV=true,TANK=true,MECH=true}
 local current_view=nil
 local draw=render_view
 render_view=function(kind,...)
  current_view=kind
  if visible[kind]==false then clear();return end
  return draw(kind,...)
 end
 -- Publish already sampled local seat state; no extra native reads and no
 -- dependency on whether the vehicle drawing is enabled.
 function M.integrated_weapon_blocked()
  if M.integrated_in_mech and M.integrated_in_mech()then return true end
  if not M.seated then return false end
  local b=Lua51.bound_vehicle()
  if not b then return false end
  return(b.kind=='TANK'and(b.seat=='driver'or b.seat=='gunner'))
   or(b.kind=='FRV'and b.seat=='driver')or false
 end
 function M.integrated_set_views(frv,tank,mech)
  visible.FRV=frv~=false;visible.TANK=tank~=false;visible.MECH=mech~=false
  if current_view and visible[current_view]==false then
   local worlds=call(App.worlds)
   if type(worlds)=='table'then surface_reset(worlds)end
  end
 end
end
