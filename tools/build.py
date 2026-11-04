"""Build MDL-managed Integrated HUD with GameSession readers and optional Hub RTT; no Chef/boot."""
from pathlib import Path
import argparse
import hashlib
import json
import re
import struct
import zipfile
from archive import archive, resource_hash, lua_value, PREFIX
from geometry import triangulate_polygon

ROOT = Path(__file__).resolve().parents[1]
BASE = 'mods/integrated_hud/mdl_gamesession/'
VERSION = json.loads((ROOT / 'version.json').read_text(encoding='utf-8'))['version']


def read(name):
    return (ROOT / name).read_text(encoding='utf-8').replace('\r\n', '\n')


def replace(s, before, after):
    assert s.count(before) == 1, before[:80]
    return s.replace(before, after, 1)


def vehicle_source():
    core = read('src/vendor/driver_hud_160.lua')
    expected = json.loads(read('build-inputs.json'))['driver_core_sha256']
    assert hashlib.sha256((ROOT / 'src/vendor/driver_hud_160.lua').read_bytes()).hexdigest() == expected
    core = replace(core, "if rawget(_G,'__DRIVER_HUD_INSTALLED') then return {installed=true} end", '')
    core = replace(core, 'if not show_frv and not M.hull then clear();return end',
                   'if not show_frv and not M.hull then if M.integrated_mech_render then M.integrated_mech_render(session,avatar,worlds,world,motion,where,state);return end;clear();return end')
    core = replace(core, '  M.preseat_owned=set',
                   '  if M.integrated_mech_prewarm then M.integrated_mech_prewarm(session,avatar,world,owned_ids)end\n  M.preseat_owned=set')
    core = replace(core, 'if not stable or not cached or M.clock>=cached.until_time then',
                   'if not cached or M.clock>=cached.until_time then')
    core = replace(core,
                   "local function seat_key(kind,p)return kind=='FRV'and p and p.name=='hmg_frv'and'HMG'or kind end",
                   "local function seat_key(kind,p)return kind=='FRV'and p and(p.seat_kind or(p.name=='hmg_frv'and'HMG'))or kind end")
    core = replace(core,
                   "local index=p.name=='hmg_frv'and 53 or p.name=='supply_frv'and 52",
                   "local index=p.wheel_damage_index or(p.name=='hmg_frv'and 53 or p.name=='supply_frv'and 52)")
    extensions = ['driver_own_style', 'driver_seat_acquisition', 'driver_flamer_frv', 'driver_tank_acquisition',
                  'driver_mech_hud', 'driver_performance', 'driver_visibility']
    core = replace(core, '-- Diagnostics attachment API 1.',
                   '\n'.join(read('src/' + n + '.lua') for n in extensions) + '\n-- Diagnostics attachment API 1.')
    # MDL owns dispatch. Do not install DRIVER globals, extension registries,
    # global hooks, or singleton flags; each enable receives a fresh factory.
    core = core[:core.index("local old=rawget(_G,'update');")]
    core += '''return {installed=true,update=update,set_views=M.integrated_set_views,shutdown=function()
 diagnostic_shutdown=true;detach_diagnostics('shutdown')
 surface_reset(call(App.worlds)or{});full_reset()
end}
'''
    core = core.replace('-- HD2-Addon: mods/driverhud/driver_hud\n', '')
    return 'return function()\n' + core + '\nend\n'


def pe(path):
    with path.open('rb') as f:
        data = f.read(4096)
    at = struct.unpack_from('<I', data, 60)[0]
    assert data[at:at + 4] == b'PE\0\0'
    return struct.unpack_from('<I', data, at + 8)[0], struct.unpack_from('<I', data, at + 80)[0]


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--game-root', type=Path, required=True)
    p.add_argument('--output-dir', type=Path, default=ROOT / 'dist')
    args = p.parse_args()
    cfg = json.loads(read('version.json'))
    acf = (args.game_root.parent.parent / 'appmanifest_553850.acf').read_text(encoding='utf-8')
    assert re.search(r'"buildid"\s+"(\d+)"', acf)[1] == cfg['steam_build']
    gs, size = pe(args.game_root / 'data/game/game.dll')
    es, _ = pe(args.game_root / 'bin/helldivers2.exe')
    assert f'{gs:08X}:{size:08X}:{es:08X}' == cfg['pe_key']
    flamer = json.loads(read('data/flamer_frv.json'))
    assert resource_hash(flamer['type']) >> 32 == int(flamer['network_type_hash'], 16)
    entry = BASE + 'main'
    sources = {
        entry: read('src/mdl_gamesession.lua'),
        BASE + 'reader': read('src/narrow200_reader.lua'),
        BASE + 'network_ping': read('src/network_ping.lua'),
        BASE + 'network_ping_hud': read('src/network_ping_hud.lua'),
        BASE + 'network_text': read('src/network_text.lua'),
        BASE + 'utf8_text': read('src/utf8_text.lua'),
        BASE + 'network_font_index': 'return ' + lua_value(json.loads(read('data/network_font/index.json'))),
        BASE + 'sensor': read('src/vendor/narrowhud_weapon_200.lua'),
        BASE + 'art_ui': read('src/weapon_art_ui.lua'),
        BASE + 'font': 'return ' + lua_value(json.loads(read('data/weapon_art.json'))),
        BASE + 'layout': 'return ' + lua_value(json.loads(read('layout/weapon.json'))),
        PREFIX + 'driver_core': vehicle_source(),
        PREFIX + 'mech_binding': read('src/mech_binding.lua'),
        PREFIX + 'flamer_frv_data': 'return ' + lua_value(json.loads(read('data/flamer_frv.json'))),
    }
    for page in sorted((ROOT / 'data/network_font').glob('*.json')):
        if page.stem != 'index':
            sources[BASE + 'network_font_' + page.stem] = 'return ' + lua_value(json.loads(page.read_text(encoding='utf-8')))
    layout = json.loads(read('layout/vehicles.json'))
    mech = layout['mech']
    mech['fill_triangles'] = triangulate_polygon(mech['outline'])
    sources[PREFIX + 'own_style_data'] = 'return ' + lua_value(layout['tank'])
    sources[PREFIX + 'mech_style_data'] = 'return ' + lua_value(mech)
    assert sources[entry].startswith('-- HD2-Addon: ' + entry + '\n')
    from lupa.lua51 import LuaRuntime
    lua = LuaRuntime(unpack_returned_tuples=True)
    import sys
    sys.path.insert(0, str(ROOT / 'tests'))
    from native_sniper_basic_check import check as check_native, render as render_native
    native_spec = json.loads(read('data/native_sniper.json'))
    assert native_spec['build'] == cfg['steam_build']
    native_template = read('src/native_sniper_setup.lua')
    native_entry = 'mods/integrated_hud/native_sniper_setup'
    notice_source = read('src/native_sniper_notice.lua')
    # The one-shot task can display Chinese even if HUD core is not selected.
    notice_support = {'mods/integrated_hud/native_sniper_notice': notice_source}
    for key in ('network_text', 'utf8_text', 'network_font_index'):
        notice_support[BASE + key] = sources[BASE + key]
    for page in {format(ord(c) // 256, 'x') for c in notice_source}:
        key = BASE + 'network_font_' + page
        if key in sources:
            notice_support[key] = sources[key]
    native_sources = {mode: dict(notice_support, **{native_entry: render_native(native_template, mode, native_spec, VERSION, lua_value)})
                      for mode in ('apply', 'restore')}
    for variant in native_sources.values():
        for name, source in variant.items():
            lua.compile(source, name=name)
            for dep in re.findall(r"require\(['\"]([^'\"]+)['\"]\)", source):
                assert dep in variant, (name, dep)
    args.output_dir.mkdir(parents=True, exist_ok=True)
    for name, source in sources.items():
        lua.compile(source, name=name)
        for dep in re.findall(r"require\(['\"]([^'\"]+)['\"]\)", source):
            assert dep in sources, (name, dep)
    lua.globals().SOURCES = lua.table_from(sources)
    checks = dict(lua.execute(read('tests/mdl_gamesession_basic_check.lua')).items())
    checks.update(check_native(native_template, lua_value, args.output_dir))
    notice_test = LuaRuntime(unpack_returned_tuples=True)
    notice_test.globals().SOURCES = notice_test.table_from(notice_support)
    checks.update(dict(notice_test.execute(read('tests/native_sniper_notice_basic_check.lua')).items()))
    ping_test=LuaRuntime(unpack_returned_tuples=True)
    ping_test.globals().SOURCES=ping_test.table_from(sources)
    checks.update(dict(ping_test.execute(read('tests/network_ping_basic_check.lua')).items()))
    respawn_test = LuaRuntime(unpack_returned_tuples=True)
    respawn_test.globals().SOURCES = respawn_test.table_from(sources)
    checks.update({'respawn_' + k: v for k, v in dict(respawn_test.execute(
        read('tests/narrow_respawn_basic_check.lua')).items()).items()})
    # Reuse the existing finite seat/HP/exit workflow with managed dispatch.
    vehicle_test = LuaRuntime(unpack_returned_tuples=True)
    managed = sources[PREFIX + 'driver_core']
    wrapper = ('local create=(function()\n' + managed + '\nend)()\n'
               'local core=create()\nupdate=core.update\nshutdown=core.shutdown\nreturn core')
    for key, value in {'CORE_SOURCE': wrapper, 'STYLE_SOURCE': sources[PREFIX + 'own_style_data'],
                       'MECH_STYLE_SOURCE': sources[PREFIX + 'mech_style_data'],
                       'MECH_BINDING_SOURCE': sources[PREFIX + 'mech_binding'], 'FLAMER_FRV_SOURCE': sources[PREFIX + 'flamer_frv_data'], 'PERF_EXPECTED': True}.items():
        vehicle_test.globals()[key] = value
    workflow = read('tests/driver_reference_basic_check.lua').replace(
        'assert(result.installed and env.__DRIVER_HUD_INSTALLED)',
        'assert(result.installed and env.__DRIVER_HUD_INSTALLED==nil)')
    checks.update({'vehicle_' + k: v for k, v in dict(vehicle_test.execute(workflow).items()).items()
                   if not k.startswith('weapon_')})
    inputs = json.loads(read('build-inputs.json'))
    report = {'version': VERSION, 'steam_build': cfg['steam_build'], 'pe_key': cfg['pe_key'],
              'loader': 'MDL3', 'weapon_reader': 'NarrowHUD 2.0.0 GameSession modules',
              'chef_required': False, 'hd2data_required': False, 'hd2data_optional_features': ['network_ping'],
              'network_ping_reader': '0.6.9 logic: session/connection gates + HD2Data roster + Network.ping + diagnostics', 'ffi_required': False,
              'vehicle_hud_enabled': True, 'mech_hud_enabled': True,
              'flamer_frv': {'front_seats_only': True, 'driver_bit': 2, 'passenger_bit': 4, 'gunner_bit': 1, 'user_verified': True, 'validated_as': 'standalone MDL hot-loaded test before integration'},
              'runtime_verified': False, 'deployed': False, 'boot_override': False,
              'checksum_sidecars': False, 'basic_checks': checks,
              'native_sniper': {'tool_version': inputs['native_sniper_tool']['version'],
                                'standalone_tool': True, 'confirmation_required': True,
                                'user_verified': inputs['native_sniper_tool']['user_verified'],
                                'startup_installer_bundled': True, 'startup_exact_data_check': True,
                                'manager_choices': ['restore', 'apply'], 'center_result_notice': True,
                                'game_data_bundled': False, 'standalone_tool_deployed_by_manager': False},
              'source_sha256': {k: hashlib.sha256(v.encode()).hexdigest() for k, v in sources.items()}}
    patch = archive({k: v.encode() for k, v in sources.items()})
    count = struct.unpack_from('<I', patch, 8)[0]
    assert resource_hash('boot') not in [struct.unpack_from('<Q', patch, 104 + i * 80)[0] for i in range(count)]
    manifest = {'Version': 1, 'Guid': '61710665-8698-4f23-bff7-00fbd715b2d8',
                'Name': '集成HUD MDL ' + VERSION,
                'Description': '管理器提供准星开启/关闭一次性启动任务，成功后屏幕中央提示重启及取消选项；不兼容数据可使用随包NativeSniperTool独立修复工具。MDL加载及启停，支持武器、FRV、坦克和机甲HUD独立实时开关及武器HUD整体大小、弹匣/备弹数字独立大小及左侧锚定的延迟面板独立缩放、横向位置及纵向位置滑动条；网络延迟可选依赖HD2 Data Hub，左侧紧凑双列以玩家名或peer标识RTT，标题右边缘纵向分隔，长名字截短，支持舰船阶段尝试采样及装备/菜单界面常显，中途加入临时会话回退到连接peer，原生编号待适配，不扫描远端对象；GameSession读取武器弹药/热量/功能模式/射速/背包供弹；FRV支持机枪型、补给型及喷火型前座；喷火型显示两个前座，机枪位不显示载具HUD。恢复坦克及机甲HUD。武器采用Monocraft及自带图标，延迟面板采用支持中英文的Fusion Pixel；换弹隐藏武器HUD。核心依赖MDL3，无需Chef；延迟功能另需HD2 Data Hub。',
                'Options': [
                    {'Name': 'HUD核心',
                     'Description': '武器、载具及可选Hub延迟HUD；支持MDL局内启停及设置。狙击枪准星可选择下方一次性任务；亦随包提供独立修复工具。',
                     'SubOptions': [
                         {'Name': '集成HUD', 'Description': '武器、载具HUD；支持MDL局内启停及设置。', 'Include': ['HUD']}
                     ]},
                    {'Name': '狙击枪原生准星（一次性操作，需重启）',
                     'Description': '开启/关闭互斥。启动后完成校验与修改，屏幕中央显示结果。成功后重启，并可在管理器取消本组选项，准星状态仍保留。不兼容数据拒绝写入，可使用随包独立工具。',
                     'SubOptions': [
                         {'Name': '关闭狙击枪准星（恢复原版）', 'Description': '一次性恢复原版准星，成功后显示中央提示；重启应用后可取消本选项。', 'Include': ['ReticleRestore']},
                         {'Name': '开启狙击枪准星', 'Description': '一次性为APW-1、R-40、AMW-20启用原生准星，成功后显示中央提示；重启应用后可取消本选项。', 'Include': ['ReticleApply']}
                     ]}
                ]}
    files = {'manifest.json': json.dumps(manifest, ensure_ascii=False, indent=2).encode(),
             'HUD/9ba626afa44a3aa3.patch_0': patch,
             'HUD/9ba626afa44a3aa3.patch_0.stream': b'',
             'HUD/9ba626afa44a3aa3.patch_0.gpu_resources': b'',
             'VERIFICATION.json': json.dumps(report, ensure_ascii=False, indent=2).encode(),
             'README.md': read('README.md').encode(),
             'version.json': read('version.json').encode(),
             'CREDITS.md': read('CREDITS.md').encode(),
             'LICENSE.md': read('LICENSE.md').encode()}
    # The confirmed standalone switch runs only when explicitly launched by the user.
    # Offline repair and manager-selected startup jobs must not run concurrently.
    tool_assets = ROOT / 'assets/native_sniper_tool'
    tool_spec = inputs['native_sniper_tool']
    expected_tool_files = tool_spec['files_sha256']
    assert {p.relative_to(tool_assets).as_posix() for p in tool_assets.rglob('*') if p.is_file()} == set(expected_tool_files)
    for name, expected in expected_tool_files.items():
        data = (tool_assets / name).read_bytes()
        assert hashlib.sha256(data).hexdigest() == expected, 'Unverified sniper tool asset: ' + name
        files['NativeSniperTool/' + name] = data
    files['NativeSniperTool/README.md'] = read('tools/native_sniper/README.md').encode()
    for path in sorted((ROOT / 'tools/native_sniper').iterdir()):
        if path.is_file() and path.suffix in ('.py', '.cpp', '.exe'):
            files['NativeSniperTool/source/' + path.name] = path.read_bytes()
    for mode, folder in [('apply', 'ReticleApply'), ('restore', 'ReticleRestore')]:
        files[folder + '/9ba626afa44a3aa3.patch_0'] = archive({k: v.encode() for k, v in native_sources[mode].items()})
        files[folder + '/9ba626afa44a3aa3.patch_0.stream'] = b''
        files[folder + '/9ba626afa44a3aa3.patch_0.gpu_resources'] = b''
    assert len(manifest['Options']) == 2 and manifest['Options'][0]['Name'] == 'HUD核心'
    assert len(manifest['Options'][1]['SubOptions']) == 2
    assert not any(name.endswith(('.dl_bin', '.dll')) for name in files)
    for name, expected in inputs['assets_sha256'].items():
        data = (ROOT / 'assets/driver_hud' / name).read_bytes()
        assert hashlib.sha256(data).hexdigest() == expected
        for folder in ('HUD', 'ReticleApply', 'ReticleRestore'):
            files[folder + '/' + name] = data
    for family in ['driver_hud', 'narrowhud200', 'monocraft', 'fusion_pixel']:
        for path in sorted((ROOT / 'third_party' / family).rglob('*')):
            if path.is_file(): files['third_party/' + family + '/' + path.relative_to(ROOT / 'third_party' / family).as_posix()] = path.read_bytes()
    files['CREDITS.txt'] = ('Integrated HUD: 2375120981.\nBased on NarrowHUD 2.0.0 by luka189 (reading modules, modified).\n'
                            'Vehicle core and solid material: DRIVER HUD; see bundled notices.\n'
                            'Monocraft: Idrees Hassan, SIL OFL 1.1.\n'
                            'Fusion Pixel: TakWolf and upstream font authors, SIL OFL 1.1; network panel.\n'
                            'MDL3 is a separately installed dependency; official link in README.\n'
                            'No Chef, MDL3 or HD2 Data Hub component bundled.\n').encode()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    out = args.output_dir / ('IntegratedHUD-MDL-' + VERSION + '.zip')
    assert not out.exists(), 'Preserve existing test packages'
    with zipfile.ZipFile(out, 'x', zipfile.ZIP_DEFLATED) as z:
        for name, data in files.items(): z.writestr(name, data)
    with zipfile.ZipFile(out) as z:
        assert z.testzip() is None and set(z.namelist()) == set(files)
        assert all(z.read(n) == b for n, b in files.items())
        assert not any(n.endswith('.sha256') for n in z.namelist())
    print(json.dumps({'package': str(out), 'bytes': out.stat().st_size, 'checks': checks}, ensure_ascii=True))


if __name__ == '__main__':
    main()
