-- Injected inside the credited DRIVER HUD core after its final reader/update
-- definitions. Presentation only: no new GUI/world/frame/identity machinery.
do
 local spec=require('mods/integrated_hud/driver_reference/own_style_data')
 local height=spec.canvas[2]
 local function up(points)
  local out={};for i,p in ipairs(points)do out[i]={p[1],height-p[2]}end;return out
 end
 local hull=up(spec.hull);local tracks={}
 for i,p in ipairs(spec.tracks)do tracks[i]=up(p)end
 local function tone(r)
  if not r then return {110,114,113}end
  if r<=.25 then return {226,52,40}elseif r<=.5 then return {232,120,52}elseif r<=.75 then return {236,190,72}end
  return {218,222,219}
 end
 -- NETWORK_MASK knows that a seat is occupied, but not who occupies it. OTHER
 -- is a display category here; no avatar or inventory identity is invented.
 local publish=FrvSeats.publish
 FrvSeats.publish=function(slots,status)
  if status=='NETWORK_MASK'then
   for _,slot in ipairs(slots)do if slot.kind=='UNKNOWN'then slot.kind='OTHER'end end
  end
  return publish(slots,status)
 end
 function Tank.draw(w,h)
  -- All source acquisition remains in the original update/reader. Never
  -- perform a second resolver, field read or scan from the drawing function.
  local bound=Lua51.bound_vehicle()
  local entry=Lua51.entry
  local record=entry and entry.registry[M.hull]
  local value=record and record.value
  local mask=value and M.clock-value.at<=.3 and value.mask or nil
  local self_bit=bound and bound.id==M.hull and bound.bit or nil
  local label=M.hp~=nil and tostring(math.floor(M.hp+.5))or '--'
  local key=table.concat({'ihud_tank',w,h,tostring(M.hull),label,tostring(M.max),tostring(mask),tostring(self_bit),C.scale,Position.x,Position.y,C.alpha},':')
  if key==M.draw_key then return end
  -- render_view supplies the original transaction/rollback around this call.
  clear()
  local ds=math.min(w/1920,h/1080);local s=ds*C.scale
  -- Share the FRV normalized screen anchor, accounting for the taller canvas.
  local x=w*Position.x-64*s;local y=h*(1-Position.y)-height/2*s
  x=math.max(8*ds,math.min(w-128*s-8*ds,x))
  y=math.max(8*ds,math.min(h-height*s-8*ds,y))
  local a=C.alpha;local white={218,222,219}
  local function panel(points,c,fill,opacity,width)
   if fill>0 then
    local dark={math.floor(c[1]*fill),math.floor(c[2]*fill),math.floor(c[3]*fill)}
    FRV.fill_polygon(points,x,y,s,.72*a,dark)
   end
   FRV.path(points,x,y,s,width,opacity*a,c,true)
  end
  for _,points in ipairs(tracks)do panel(points,white,.045,.65,1.2)end
  for _,tx in ipairs({10,106})do for ty=40,138,12 do
   FRV.line(x+tx*s,y+(height-ty)*s,x+(tx+12)*s,y+(height-ty-4)*s,.75*s,.20*a,white)
  end end
  panel(hull,white,.035,.9,1.3)
  -- Saved layout order: front driver; rear left passenger, gunner, right.
  for i,seat in ipairs(spec.seats)do
   local bit=({1,4,2,8})[i]
   local known=type(mask)=='number'
   local occupied=known and Lua51.seat_occupied(mask,bit)
   local own=occupied and self_bit==bit
   local c=own and {255,145,48}or occupied and white or {128,138,148}
   local fill=own and .17 or occupied and .12 or 0
   local alpha=own and 1 or occupied and .95 or known and .24 or .36
   local b=seat.box;local sx,sy,sw,sh=b[1],b[2],b[3],b[4]
   panel(up({{sx+2,sy},{sx+sw-2,sy},{sx+sw,sy+2},{sx+sw,sy+sh-2},
    {sx+sw-2,sy+sh},{sx+2,sy+sh},{sx,sy+sh-2},{sx,sy+2}}),c,fill,alpha,1.1)
  end
  local ratio=M.hp and M.max and M.max>0 and M.hp/M.max or nil
  -- Use the original stable geometric digits, never our old pixel font.
  assert(HudNumber.draw(label,x+spec.health_center[1]*s,y+(height-spec.health_center[2])*s,13*s,.9*a,tone(ratio),'center'))
  M.draw_key=key
 end
 -- No Tank.draw_ring / ammo / reticle calls in the active tank presentation.
 log('IHUD_STYLE version=0.2.4 tank=final_hull_tracks_four_seats_integer_hp anchor=shared_frv frv=original_layout_occupied_white renderer=original_driver_gui')
end
