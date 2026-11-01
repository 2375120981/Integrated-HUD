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
 function M.integrated_set_views(frv,tank,mech)
  visible.FRV=frv~=false;visible.TANK=tank~=false;visible.MECH=mech~=false
  if current_view and visible[current_view]==false then
   local worlds=call(App.worlds)
   if type(worlds)=='table'then surface_reset(worlds)end
  end
 end
end
