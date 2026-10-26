-- Presentation and reciprocal mech adapter inside the stable original core.
do
 local style=require('mods/integrated_hud/driver_reference/mech_style_data')
 local reader=require('mods/integrated_hud/driver_reference/mech_binding').new(GS,log)
 local H=style.canvas[2];local outline={}
 for i,p in ipairs(style.outline)do outline[i]={p[1],H-p[2]}end
 local snapshot=nil
 local reader_context={}
 local function context(session,avatar,world,owned_ids)
  local c=reader_context
  c.session=session;c.peer=M.peer;c.world=world;c.avatar=avatar;c.sample=sample
  c.owned_ids=owned_ids;c.owned_set=M.owned_cache and M.owned_cache.set
  return c
 end
 local function tone(r)
  if r<=.25 then return {226,52,40}elseif r<=.5 then return {232,120,52}elseif r<=.75 then return {236,190,72}end
  return {218,222,219}
 end
 HudViews.MECH=function(w,h)
  local v=snapshot;if not v then return end
  local key=table.concat({'ihud_mech_total',w,h,v.id,v.hp,v.max,Position.x,Position.y,Position.scale,C.alpha},':')
  if key==M.draw_key then return end
  clear() -- original render_view transaction owns replacement and rollback
  local ds=math.min(w/1920,h/1080);local s=ds*Position.scale
  local x=w*Position.x-style.canvas[1]/2*s;local y=h*(1-Position.y)-H/2*s
  x=math.max(8*ds,math.min(w-style.canvas[1]*s-8*ds,x));y=math.max(8*ds,math.min(h-H*s-8*ds,y))
  local ratio=math.max(0,math.min(1,v.hp/v.max));local c=tone(ratio);local a=C.alpha
  local fill=ratio>.75 and .07 or .18
  local dark={math.floor(c[1]*fill),math.floor(c[2]*fill),math.floor(c[3]*fill)}
  -- Offline ear-clipped triangles fill the concave silhouette without bridging
  -- the gaps under the arms or between the legs.
  for _,t in ipairs(style.fill_triangles)do
   FRV.triangle(x+t[1][1]*s,y+(H-t[1][2])*s,x+t[2][1]*s,y+(H-t[2][2])*s,
    x+t[3][1]*s,y+(H-t[3][2])*s,.72*a,dark)
  end
  FRV.path(outline,x,y,s,1.2,.9*a,c,true)
  -- Visual body/limb seams only: all pieces keep the same total-HP colour.
  for _,seam in ipairs(style.separators or {})do
   local points={};for i,p in ipairs(seam)do points[i]={p[1],H-p[2]}end
   FRV.path(points,x,y,s,.9,.75*a,c,false)
  end
  local cy=y+(H-style.health_center[2])*s;local size=style.health_size*s
  local number=tostring(math.floor(v.hp+.5))
  assert(HudNumber.draw(number,x+style.health_center[1]*s,cy,size,.9*a,c,'center'))
  M.draw_key=key
 end
 -- Called only from the original unsupported-seated-vehicle branch. The same
 -- ensure_gui/world selection, menu check and render_view own this view.
 M.integrated_mech_prewarm=function(session,avatar,world,owned_ids)
  reader.prewarm(M.clock,context(session,avatar,world,owned_ids))
 end
 M.integrated_mech_render=function(session,avatar,worlds,world,motion,where,state)
  local c=context(session,avatar,world,M.owned_cache and M.owned_cache.ids)
  c.avatar_checked=true;c.motion=motion;c.where=where;c.state=state
  snapshot=reader.update(M.clock,c)
  if not snapshot then clear();return end
  if not ensure_gui(worlds,world)then return end
  if sr.Window and call(sr.Window.show_cursor)==true then clear();return end
  local w,h=call(App.back_buffer_size)
  if type(w)=='number'and type(h)=='number'and w>0 and h>0 then render_view('MECH',w,h)end
 end
 local original_reset=full_reset
 full_reset=function()reader.release();snapshot=nil;return original_reset()end
 log('IHUD_MECH_UI version=0.3.3 silhouette=symmetric_raised_arms health=current_only visual_seams=true module_health=false model_names=false')
end
