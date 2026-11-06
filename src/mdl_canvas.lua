-- MDL3.gui retained primitives. No engine GUI handles or world lifetime calls.
local M={}
function M.api()
 local mdl=rawget(_G,'MDL3')
 local g=type(mdl)=='table'and mdl.gui
 if not g then mdl=rawget(_G,'MDL');g=type(mdl)=='table'and mdl.gui end
 return type(g)=='table'and type(g.api)=='number'and g.api>=1 and g or nil
end
function M.new(layer,units,log,text_layer)
 local R={};local shapes,texts,provider=nil,nil,nil
 local records,order={},{};local serial=0;local dirty=true;local warned=false
 local function destroy()
  if shapes then pcall(shapes.destroy,shapes)end
  if texts then pcall(texts.destroy,texts)end
  shapes,texts,provider=nil,nil,nil
 end
 local function ensure()
  local g=M.api()
  if g~=provider then destroy()end
  if not g then return false end
  if not shapes then
   shapes=g.canvas({layer=layer,units=units or'reference'})
   local ok,c=pcall(g.canvas,{layer=text_layer or layer+1,units=units or'reference'})
   if not ok then destroy();error(c)end
   texts=c;provider=g;dirty=true;warned=false
  end
  return true
 end
 function R.screen()if ensure()then return shapes:screen()end end
 function R.measure(s,size)if ensure()then return texts:measure(s,size)end end
 function R.add(kind,...)
  serial=serial+1;records[serial]={kind=kind,args={...}};order[#order+1]=serial;dirty=true
  return serial
 end
 function R.remove(id)if records[id]then records[id]=nil;dirty=true end end
 function R.clear()records,order={},{};dirty=true end
 function R.commit()
  if not ensure()then return false end
  if dirty then
   shapes:begin();texts:begin()
   local kept={}
   for _,id in ipairs(order)do
    local r=records[id]
    if r then
     local c=r.kind=='text'and texts or shapes
     c[r.kind](c,unpack(r.args));kept[#kept+1]=id
    end
   end
   shapes:finish();texts:finish();order=kept;dirty=false
  end
  if not warned then
   local st=texts:status()
   if st and st.font==false then
    warned=true;if log then log('MDL_GUI_FONT_UNAVAILABLE enable MDL native interface service')end
   end
  end
  return true
 end
 function R.shutdown()destroy();records,order={},{};dirty=true end
 return R
end
return M
