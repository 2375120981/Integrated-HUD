-- HD2-Addon: mods/integrated_hud/native_sniper_setup
-- One-shot disk setup selected by the mod manager, never a live HUD setting.
local MODE=__NATIVE_MODE__
local C=__NATIVE_SPEC__
local ENTRY='mods/integrated_hud/native_sniper_setup'
local loader=rawget(_G,'CowboyBingusModLoader')
local startup=type(loader)=='table'and type(loader.modules)=='table'and loader.modules[ENTRY]=='loading'
local handles={};local job=nil;local started=false;local committed=false
local backup_temporary=nil
local base=os.getenv('APPDATA')
local folder=base and(base..'/Arrowhead/Helldivers2/')
local function log(text)
 if not folder then return end
 local f=io.open(folder..'IntegratedHUD-NativeSniper.log','a')
 if f then f:write(os.date('!%Y-%m-%dT%H:%M:%SZ')..' '..MODE..' '..text..'\n');f:close()end
end
local function open(path,mode)
 local f,err=io.open(path,mode);assert(f,err or('cannot open '..path));handles[f]=true;return f
end
local function close(f)
 if f then handles[f]=nil;assert(f:close(),'file close failed')end
end
local function cleanup()
 for f in pairs(handles)do pcall(f.close,f)end;handles={}
 if backup_temporary then pcall(os.remove,backup_temporary);backup_temporary=nil end
end
local function unhex(text)return(text:gsub('%x%x',function(v)return string.char(tonumber(v,16))end))end
local function sites(f,state)
 assert(f:seek('end')==C.size,'unsupported file size')
 for _,d in ipairs(C.delta)do
  assert(f:seek('set',d.at)==d.at,'seek failed')
  local expected=unhex(d[state]);assert(f:read(#expected)==expected,'patch site mismatch at '..d.at)
 end
 for _,d in ipairs(C.anchors)do
  assert(f:seek('set',d.at)==d.at,'anchor seek failed')
  local expected=unhex(d.hex);assert(f:read(#expected)==expected,'unsupported data anchor')
 end
end
local function accumulator()return{a=1,b=0,r=5381,n=0}end
local function digest(h,s)
 local a,b,r=h.a,h.b,h.r
 for i=1,#s do local v=s:byte(i);a=(a+v)%65521;b=(b+a)%65521;r=(r*33+v)%4294967296 end
 h.a,h.b,h.r,h.n=a,b,r,h.n+#s
end
local function valid(h,state)
 local expected=C[state]
 return h.n==C.size and h.b*65536+h.a==expected.adler and h.r==expected.roll
end
local function scan(f,state)
 sites(f,state);assert(f:seek('set',0)==0,'rewind failed')
 local h=accumulator()
 while true do
  local s=f:read(C.chunk);if not s or #s==0 then break end
  digest(h,s);coroutine.yield()
 end
 assert(valid(h,state),'whole-file verification failed ('..state..')')
end
local function replace_chunk(s,at,from,to)
 for _,d in ipairs(C.delta)do
  local a,b=math.max(at,d.at),math.min(at+#s,d.at+#d[from]/2)
  if a<b then
   local expected=unhex(d[from]):sub(a-d.at+1,b-d.at)
   assert(s:sub(a-at+1,b-at)==expected,'backup delta mismatch')
   s=s:sub(1,a-at)..unhex(d[to]):sub(a-d.at+1,b-d.at)..s:sub(b-at+1)
  end
 end
 return s
end
local function ensure_backup(source,state,path)
 local existing=io.open(path,'rb')
 if existing then
  handles[existing]=true;scan(existing,'before');close(existing);log('BACKUP verified');return
 end
 -- A previous standalone installation may already have patched the file.
 -- Reconstruct the original only from a fully verified known patched state.
 local temporary=path..'.tmp'
 local pending=io.open(temporary,'rb')
 if pending then pending:close();error('incomplete backup exists: '..temporary)end
 local output=open(temporary,'wb');backup_temporary=temporary;assert(source:seek('set',0)==0)
 local h=accumulator();local at=0
 while true do
  local s=source:read(C.chunk);if not s or #s==0 then break end
  if state=='after'then s=replace_chunk(s,at,'after','before')end
  digest(h,s);assert(output:write(s),'backup write failed');at=at+#s;coroutine.yield()
 end
 assert(valid(h,'before'),'backup content verification failed')
 assert(output:flush());close(output)
 local verify=open(temporary,'rb');scan(verify,'before');close(verify)
 assert(os.rename(temporary,path),'backup commit failed');backup_temporary=nil;log('BACKUP created and verified')
end
local function write_delta(f,from,to)
 sites(f,from)
 -- Payload first, authenticated tag last; no yields inside the transaction.
 for pass=1,2 do for _,d in ipairs(C.delta)do
  if(pass==1 and d.at~=32)or(pass==2 and d.at==32)then
   assert(f:seek('set',d.at)==d.at);assert(f:write(unhex(d[to])),'patch write failed')
  end
 end;assert(f:flush(),'flush failed')end
 sites(f,to)
end
local function run()
 assert(folder,'APPDATA missing')
 local path,source
 for _,p in ipairs(C.paths)do
  local f=io.open(p,'rb');if f then path,source=p,f;handles[f]=true;break end
 end
 assert(source,'game data not found')
 local state=nil
 for _,candidate in ipairs({'before','after'})do if pcall(sites,source,candidate)then state=candidate;break end end
 assert(state,'unsupported or interrupted game-data state; no writes')
 log('VERIFY '..state..' (wait for SUCCESS before exiting)');scan(source,state)
 local wanted=MODE=='apply'and'after'or'before'
 if state=='before'and wanted=='before'then close(source);log('SUCCESS already restored');return end
 local backup=folder..'IntegratedHUD-NativeSniper-'..C.build..'-original.dl_bin'
 ensure_backup(source,state,backup);close(source)
 if state==wanted then log('SUCCESS already installed; backup verified');return end
 local live=open(path,'r+b')
 -- Recheck the live file after preparing the backup and before writing.
 scan(live,state)
 local ok,err=pcall(write_delta,live,state,wanted)
 if not ok then
  -- Roll back only our exact known bytes; never overwrite unrelated changes.
  local recovered=pcall(function()
   for _,d in ipairs(C.delta)do
    assert(live:seek('set',d.at)==d.at)
    local value=live:read(#d.before/2)
    assert(value==unhex(d.before)or value==unhex(d.after),'external change; rollback refused')
   end
   for _,d in ipairs(C.delta)do assert(live:seek('set',d.at)==d.at);assert(live:write(unhex(d[state])))end
   assert(live:flush());sites(live,state)
  end)
  error(tostring(err)..'; rollback='..tostring(recovered)..'; original backup='..backup)
 end
 committed=true;log('APPLIED '..wanted..'; verifying saved result')
 scan(live,wanted);close(live)
 log('SUCCESS '..(wanted=='after'and'installed'or'restored')..'; restart game to load the new data')
end
return {
 name='狙击准星安装任务（需重启）',version=__VERSION__,
 description='管理器选择开启或关闭。只在启动加载时执行；MDL局内启停不切换准星。结果见IntegratedHUD-NativeSniper.log。',
 on_enable=function()
  if started then return end;started=true
  if not startup then log('DEFERRED live activation refused; deploy selection and restart game');return end
  committed=false;job=coroutine.create(run);log('START startup-only '..MODE)
 end,
 on_update=function()
  if not job then return end
  local ok,err=coroutine.resume(job)
  if not ok then log('FAILED '..tostring(err));cleanup();job=nil
  elseif coroutine.status(job)=='dead'then cleanup();job=nil end
 end,
 on_disable=function()
  if job then log(committed and'POSTCHECK interrupted; data remains changed; restart to verify'or'CANCELLED before game write; no reticle change')end
  cleanup();job=nil
 end
}
