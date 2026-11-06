-- MDL canvas stays visible in equipment screens and cursor-based menus.
local M={}
local utf8=require('mods/integrated_hud/mdl_gamesession/utf8_text')
function M.new(E,log)
 local reader=require('mods/integrated_hud/mdl_gamesession/network_ping').new(E,log)
 local c=require('mods/integrated_hud/mdl_gamesession/mdl_canvas').new(70,'reference',log,85)
 local R={};local scale=1;local px,py=0,50;local key=nil
 function R.set_scale(v)scale=type(v)=='number'and v==v and math.max(.5,math.min(1.5,v))or 1 end
 local function percent(v,d)return type(v)=='number'and v==v and math.max(0,math.min(100,v))or d end
 function R.set_position(x,y)px,py=percent(x,0),percent(y,50)end
 local status={['SESSION ONLY']='SESSION LIST: SELF',['WAIT PLAYER SCHEMA']='WAITING FOR SCHEMA',['WAIT SQUAD']='WAITING FOR SQUAD',
  ['CONFIRMING PLAYER IDS']='CONFIRMING IDS',['AMBIGUOUS PLAYER IDS']='AMBIGUOUS IDS',
  ['HUB REQUIRED']='ENABLE HD2 DATA HUB',['WAIT HUB']='WAITING FOR HUB',['WAIT MISSION']='WAITING FOR MISSION'}
 local function measure(s,size)return c.measure(s,size)or 0 end
 local function prefix(s,width,size)
  local chars=utf8.split(s)or{};local out={}
  for _,ch in ipairs(chars)do
   local next_text=table.concat(out)..ch.text
   if measure(next_text,size)>width then break end
   out[#out+1]=ch.text
  end
  return table.concat(out)
 end
 function R.update(now)
  local v=reader.read(now);local screen=c.screen();if not screen then return end
  local parts={screen.w,screen.h,v.state,v.source or'',scale,px,py}
  for _,r in ipairs(v.rows)do parts[#parts+1]=r.peer..':'..(r.label or r.peer)..':'..tostring(r.ms)end
  local k=table.concat(parts,'/')
  if key~=k then
   c.clear();key=k
   if v.state~='NO SESSION'then
    local lines=v.state=='READY'and #v.rows or 1
    local title=v.source=='CONNECTIONS'and'CONNECTION RTT'or'LOCAL RTT'
    local title_width=measure(title,16*scale)
    local message=status[v.state]or'WAITING FOR IDS'
    local width=title_width
    if v.state=='READY'then
     for _,r in ipairs(v.rows)do width=math.max(width,title_width+8*scale+measure(r.ms and(r.ms..'ms')or'--',18*scale))end
    else width=math.max(width,measure(message,14*scale))end
    local height=(lines*27+24)*scale
    local x=math.max(0,screen.w-width-2*scale)*px/100
    local y=math.max(0,screen.h-height)*py/100+12*scale
    local function label(text,xx,yy,size,color)
     c.add('text',text,xx,yy,{size=size,color=color or{218,222,219},valign='middle'})
    end
    label(title,x,y,16*scale)
    if v.state=='READY'then
     local divider=x+title_width
     if lines>0 then c.add('line',divider,y+17*scale,divider,y+(lines*27+10)*scale,scale,{218,222,219,178})end
     for i,r in ipairs(v.rows)do
      local yy=y+i*27*scale
      label(prefix(r.label or r.peer,title_width-6*scale,14*scale),x,yy,14*scale)
      local color=r.ms and(r.ms<100 and{170,235,185}or r.ms<200 and{255,215,100}or{255,125,110})or{190,190,190}
      label(r.ms and(r.ms..'ms')or'--',divider+8*scale,yy,18*scale,color)
     end
    else label(message,x,y+27*scale,14*scale)end
   end
  end
  c.commit()
 end
 function R.shutdown()reader.shutdown();c.shutdown();key=nil end
 return R
end
return M
