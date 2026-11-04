-- Flamer FRV: exact typed/schema-checked discovery with two front cabin cells.
-- Field declaration comes from the installed entity/network data, not shape guesses.
do
 local spec=require('mods/integrated_hud/driver_reference/flamer_frv_data')
 FRV.profiles[spec.resource]={name=spec.name,t=spec.type,fields=spec.fields,
  seat_kind='FLAMER',wheel_damage_index=spec.wheel_damage_index}
 FRV.profile_resources[spec.resource]=true
 seat_bits.FLAMER={spec.gunner_seat_bit,spec.front_seat_bits[1],spec.front_seat_bits[2]}
 seat_labels.FLAMER={[spec.gunner_seat_bit]='gunner',
  [spec.front_seat_bits[1]]='driver',[spec.front_seat_bits[2]]='front_passenger'}
 local cabin_bits=Lua51.frv_cabin_bits
 Lua51.frv_cabin_bits=function(p)
  if p and p.name==spec.name then return spec.front_seat_bits end
  return cabin_bits(p)
 end
 local draw_seat=FRV.draw_seat
 FRV.draw_seat=function(i,...)
  if FRV.profile and FRV.profile.name==spec.name and i>2 then return end
  return draw_seat(i,...)
 end
 local draw=FRV.draw
 FRV.draw=function(...)
  if FRV.profile and FRV.profile.name==spec.name then
   local bound=Lua51.bound_vehicle()
   if not bound or not FRV.vehicle or bound.id~=FRV.vehicle.goid
    or(bound.bit~=spec.front_seat_bits[1]and bound.bit~=spec.front_seat_bits[2])then
    clear();return
   end
  end
  return draw(...)
 end
 log('IHUD_FLAMER_FRV type='..spec.type..' resource='..spec.resource
  ..' cabin_bits='..table.concat(spec.front_seat_bits,',')..' gunner_hidden=true')
end
