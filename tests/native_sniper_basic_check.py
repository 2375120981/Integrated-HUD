"""Finite real Lua/file checks, confined to a temporary directory."""
from pathlib import Path
import copy,json,tempfile,zlib
from lupa.lua51 import LuaRuntime

ENTRY='mods/integrated_hud/native_sniper_setup'

def checksum(b):
    rolling=5381
    for v in b:rolling=(rolling*33+v)&0xffffffff
    return {'adler':zlib.adler32(b),'roll':rolling}

def render(template,mode,spec,version,literal):
    return template.replace('__NATIVE_MODE__',json.dumps(mode)).replace('__NATIVE_SPEC__',literal(spec)).replace('__VERSION__',json.dumps(version))

def check(template,literal,work):
    original=bytes((i*17+3)%256 for i in range(4096));patched=bytearray(original)
    for at,size in [(32,16),(1300,1),(1800,1),(2100,1),(3500,2),(4000,7)]:
        for i in range(size):patched[at+i]^=0x35
    patched=bytes(patched)
    delta=[]
    for at,size in [(32,16),(1300,1),(1800,1),(2100,1),(3500,2),(4000,7)]:
        delta.append({'at':at,'before':original[at:at+size].hex(),'after':patched[at:at+size].hex()})
    base={'size':len(original),'build':'fixture','chunk':1024,'before':checksum(original),'after':checksum(patched),
          'delta':delta,'anchors':[{'at':100,'hex':original[100:116].hex()}]}
    # PUC Lua's Windows fopen needs an ANSI-compatible path. The project's
    # Chinese directory name is outside its narrow CRT file API encoding.
    with tempfile.TemporaryDirectory(prefix='native-sniper-') as temp:
        root=Path(temp)
        def run(name,initial,mode,startup=True,stop_after=None):
            home=root/name;logs=home/'Arrowhead/Helldivers2';logs.mkdir(parents=True)
            target=home/'game.dl_bin';target.write_bytes(initial)
            spec=copy.deepcopy(base);spec['paths']=[target.as_posix()]
            lua=LuaRuntime(unpack_returned_tuples=True)
            lua.globals().HOME=home.as_posix();lua.globals().SOURCE=render(template,mode,spec,'test',literal)
            lua.globals().STARTUP=startup;lua.globals().STOP_AFTER=stop_after
            lua.execute('''
local env=setmetatable({},{__index=_G});env._G=env
env.os=setmetatable({getenv=function(k)if k=='APPDATA'then return HOME end end},{__index=os})
env.CowboyBingusModLoader={modules={['mods/integrated_hud/native_sniper_setup']=STARTUP and 'loading'or'managed'}}
env.require=function(name)
 assert(name=='mods/integrated_hud/native_sniper_notice')
 return {new=function()return {update=function(state)NOTICE_STATE=state end,shutdown=function()NOTICE_CLEANED=true end}end}
end
local f=assert(loadstring(SOURCE));setfenv(f,env);addon=f();addon.on_enable()
for i=1,(STOP_AFTER or 100)do addon.on_update(nil,.016)end
addon.on_disable()
''')
            state=lua.globals().NOTICE_STATE
            text=(logs/'IntegratedHUD-NativeSniper.log').read_text(encoding='utf-8')
            if f' {mode} SUCCESS ' in text: assert state=='success'
            elif 'FAILED' in text: assert state=='failed'
            elif 'DEFERRED' in text: assert state=='deferred'
            assert lua.globals().NOTICE_CLEANED
            return target.read_bytes(),logs,(logs/'IntegratedHUD-NativeSniper.log').read_text(encoding='utf-8')
        result,logs,log=run('apply',original,'apply')
        assert result==patched and 'SUCCESS installed' in log
        assert (logs/'IntegratedHUD-NativeSniper-fixture-original.dl_bin').read_bytes()==original
        # Disabling the MDL task above must not undo the installed disk state.
        result,logs,log=run('restore',patched,'restore')
        assert result==original and 'SUCCESS restored' in log
        assert (logs/'IntegratedHUD-NativeSniper-fixture-original.dl_bin').read_bytes()==original
        result,_,log=run('already',patched,'apply')
        assert result==patched and 'SUCCESS already installed' in log
        result,_,log=run('hot-apply',original,'apply',False)
        assert result==original and 'DEFERRED' in log
        result,_,log=run('hot-restore',patched,'restore',False)
        assert result==patched and 'DEFERRED' in log
        bad=bytearray(original);bad[2500]^=1
        result,_,log=run('unknown',bytes(bad),'apply')
        assert result==bad and 'FAILED' in log and 'APPLIED' not in log
        result,logs,log=run('cancel',original,'apply',stop_after=6)
        assert result==original and 'CANCELLED' in log
        assert not list(logs.glob('*.tmp'))
    return {'native_notice_only_after_verified_success':True,'native_apply_restore':True,'native_reconstruct_verified_backup':True,
            'native_hot_activation_refused':True,'native_disable_keeps_disk_state':True,
            'native_unknown_file_refused':True,'native_cancel_before_write':True}
