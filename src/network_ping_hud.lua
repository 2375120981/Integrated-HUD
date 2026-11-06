-- MDL canvas stays visible in equipment screens and cursor-based menus.
local M={}
local function call(f,...)if type(f)=='function'then local ok,v=pcall(f,...);if ok then return v end end end
local utf8=require('mods/integrated_hud/mdl_gamesession/utf8_text')
local boosters=require('mods/integrated_hud/mdl_gamesession/booster_data')
local icon=require('mods/integrated_hud/mdl_gamesession/booster_icon')
function M.new(E,log)
 local reader=require('mods/integrated_hud/mdl_gamesession/network_ping').new(E,log)
 local c=require('mods/integrated_hud/mdl_gamesession/mdl_canvas').new(70,'reference',log,85)
 local R={};local scale=1;local px,py=0,50;local key=nil;local next_boosters=0;local snapshot=nil;local provider=nil
 local show_latency,show_boosters=true,true
 function R.set_content(latency,boosters_on)
  local a,b=latency==true,boosters_on==true
  if b~=show_boosters then snapshot=nil;next_boosters=0 end
  show_latency,show_boosters=a,b
 end
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
  if not show_latency and not show_boosters then
   if key~=false then c.clear();c.commit();key=false end
   return
  end
  local screen=c.screen();if not screen then return end
  local D=rawget(_G,'HD2Data')
  if D~=provider then provider=D;snapshot=nil;next_boosters=0 end
  local phase=type(D)=='table'and call(D.mission)
  if snapshot and type(phase)=='table'and(snapshot.epoch~=phase.epoch or snapshot.in_mission~=phase.in_mission)then snapshot=nil;next_boosters=0 end
  if show_boosters and now>=next_boosters then next_boosters=now+.2;snapshot=boosters.read(D)end
  if type(D)~='table'or call(D.ready)~=true then snapshot=nil end
  local v=show_latency and reader.read(now)or{state=type(D)~='table'and'HUB REQUIRED'or'WAIT HUB',rows={}}
  -- A booster-only list depends on Hub identity, not RTT/session readiness.
  if show_boosters and snapshot and(not show_latency or v.state~='READY')then
   local rows={}
   for _,p in ipairs(snapshot.rows)do if not p.is_local then
    rows[#rows+1]={peer=p.peer,slot=p.slot,label=p.name or p.peer}
   end end
   table.sort(rows,function(a,b)return a.slot<b.slot end)
   v={state=#rows>0 and'READY'or'SESSION ONLY',rows=rows}
  end
  local parts={screen.w,screen.h,v.state,v.source or'',scale,px,py,tostring(show_latency),tostring(show_boosters)}
  for _,r in ipairs(v.rows)do
   local p=snapshot and snapshot.by_peer[boosters.peer(r.peer)]
   parts[#parts+1]=r.peer..':'..(r.label or r.peer)..':'..tostring(r.ms)..':'..icon.key(p and not p.is_local and p or nil)
  end
  local k=table.concat(parts,'/')
  if key~=k then
   c.clear();key=k
   do
    local lines=v.state=='READY'and #v.rows or 1
    local title=show_latency and(v.source=='CONNECTIONS'and'CONNECTION RTT'or'LOCAL RTT')or'SQUAD'
    local title_width=math.max(measure('LOCAL RTT',16*scale),measure(title,16*scale))
    local latency_gap=(show_boosters and 14 or 8)*scale
    local message=status[v.state]or'WAITING FOR IDS'
    local width=title_width
    if v.state=='READY'then
     if show_boosters then width=title_width+10*scale end
     if show_latency then
      for _,r in ipairs(v.rows)do width=math.max(width,title_width+latency_gap+measure(r.ms and(r.ms..'ms')or'--',18*scale))end
     end
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
     for i,r in ipairs(v.rows)do
      local yy=y+i*27*scale
      label(prefix(r.label or r.peer,title_width-(show_boosters and 14 or 6)*scale,14*scale),x,yy,14*scale)
      local p=snapshot and snapshot.by_peer[boosters.peer(r.peer)]
      if show_boosters and p and not p.is_local then icon.draw(c,p,divider,yy,20*scale)end
      local color=r.ms and(r.ms<100 and{170,235,185}or r.ms<200 and{255,215,100}or{255,125,110})or{190,190,190}
      if show_latency then label(r.ms and(r.ms..'ms')or'--',divider+latency_gap,yy,18*scale,color)end
     end
    else label(message,x,y+27*scale,14*scale)end
   end
  end
  c.commit()
 end
 function R.shutdown()reader.shutdown();c.shutdown();key=nil;snapshot=nil;provider=nil end
 return R
end
return M
