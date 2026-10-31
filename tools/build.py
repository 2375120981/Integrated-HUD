"""Build MDL-managed Integrated HUD with GameSession readers, no Hub/Chef/boot."""
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
    extensions = ['driver_own_style', 'driver_seat_acquisition', 'driver_tank_acquisition',
                  'driver_mech_hud', 'driver_performance']
    core = replace(core, '-- Diagnostics attachment API 1.',
                   '\n'.join(read('src/' + n + '.lua') for n in extensions) + '\n-- Diagnostics attachment API 1.')
    # MDL owns dispatch. Do not install DRIVER globals, extension registries,
    # global hooks, or singleton flags; each enable receives a fresh factory.
    core = core[:core.index("local old=rawget(_G,'update');")]
    core += '''return {installed=true,update=update,shutdown=function()
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
    entry = BASE + 'main'
    sources = {
        entry: read('src/mdl_gamesession.lua'),
        BASE + 'reader': read('src/narrow200_reader.lua'),
        BASE + 'sensor': read('src/vendor/narrowhud_weapon_200.lua'),
        BASE + 'art_ui': read('src/weapon_art_ui.lua'),
        BASE + 'font': 'return ' + lua_value(json.loads(read('data/weapon_art.json'))),
        BASE + 'layout': 'return ' + lua_value(json.loads(read('layout/weapon.json'))),
        PREFIX + 'driver_core': vehicle_source(),
        PREFIX + 'mech_binding': read('src/mech_binding.lua'),
    }
    layout = json.loads(read('layout/vehicles.json'))
    mech = layout['mech']
    mech['fill_triangles'] = triangulate_polygon(mech['outline'])
    sources[PREFIX + 'own_style_data'] = 'return ' + lua_value(layout['tank'])
    sources[PREFIX + 'mech_style_data'] = 'return ' + lua_value(mech)
    assert sources[entry].startswith('-- HD2-Addon: ' + entry + '\n')
    from lupa.lua51 import LuaRuntime
    lua = LuaRuntime(unpack_returned_tuples=True)
    for name, source in sources.items():
        lua.compile(source, name=name)
        for dep in re.findall(r"require\(['\"]([^'\"]+)['\"]\)", source):
            assert dep in sources, (name, dep)
    lua.globals().SOURCES = lua.table_from(sources)
    checks = dict(lua.execute(read('tests/mdl_gamesession_basic_check.lua')).items())
    # Reuse the existing finite seat/HP/exit workflow with managed dispatch.
    vehicle_test = LuaRuntime(unpack_returned_tuples=True)
    managed = sources[PREFIX + 'driver_core']
    wrapper = ('local create=(function()\n' + managed + '\nend)()\n'
               'local core=create()\nupdate=core.update\nshutdown=core.shutdown\nreturn core')
    for key, value in {'CORE_SOURCE': wrapper, 'STYLE_SOURCE': sources[PREFIX + 'own_style_data'],
                       'MECH_STYLE_SOURCE': sources[PREFIX + 'mech_style_data'],
                       'MECH_BINDING_SOURCE': sources[PREFIX + 'mech_binding'], 'PERF_EXPECTED': True}.items():
        vehicle_test.globals()[key] = value
    workflow = read('tests/driver_reference_basic_check.lua').replace(
        'assert(result.installed and env.__DRIVER_HUD_INSTALLED)',
        'assert(result.installed and env.__DRIVER_HUD_INSTALLED==nil)')
    checks.update({'vehicle_' + k: v for k, v in dict(vehicle_test.execute(workflow).items()).items()
                   if not k.startswith('weapon_')})
    inputs = json.loads(read('build-inputs.json'))
    report = {'version': VERSION, 'steam_build': cfg['steam_build'], 'pe_key': cfg['pe_key'],
              'loader': 'MDL3', 'weapon_reader': 'NarrowHUD 2.0.0 GameSession modules',
              'chef_required': False, 'hd2data_required': False, 'ffi_required': False,
              'vehicle_hud_enabled': True, 'mech_hud_enabled': True,
              'runtime_verified': False, 'deployed': False, 'boot_override': False,
              'checksum_sidecars': False, 'basic_checks': checks,
              'source_sha256': {k: hashlib.sha256(v.encode()).hexdigest() for k, v in sources.items()}}
    patch = archive({k: v.encode() for k, v in sources.items()})
    count = struct.unpack_from('<I', patch, 8)[0]
    assert resource_hash('boot') not in [struct.unpack_from('<Q', patch, 104 + i * 80)[0] for i in range(count)]
    manifest = {'Version': 1, 'Guid': '61710665-8698-4f23-bff7-00fbd715b2d8',
                'Name': '集成HUD MDL ' + VERSION,
                'Description': 'MDL加载及启停；GameSession读取武器弹药/热量/功能模式/射速/背包供弹；恢复FRV、坦克及机甲HUD。采用Monocraft及自带图标；换弹隐藏武器HUD。仅依赖MDL3，无需Chef或HD2Data。',
                'Options': [{'Name': '集成HUD', 'Description': '停用旧集成HUD及冲突HUD后启用并部署。', 'Include': ['HUD']}]}
    files = {'manifest.json': json.dumps(manifest, ensure_ascii=False, indent=2).encode(),
             'HUD/9ba626afa44a3aa3.patch_0': patch,
             'HUD/9ba626afa44a3aa3.patch_0.stream': b'',
             'HUD/9ba626afa44a3aa3.patch_0.gpu_resources': b'',
             'VERIFICATION.json': json.dumps(report, ensure_ascii=False, indent=2).encode(),
             'README.md': read('README.md').encode(),
             'version.json': read('version.json').encode(),
             'CREDITS.md': read('CREDITS.md').encode(),
             'LICENSE.md': read('LICENSE.md').encode()}
    for name, expected in inputs['assets_sha256'].items():
        data = (ROOT / 'assets/driver_hud' / name).read_bytes()
        assert hashlib.sha256(data).hexdigest() == expected
        files['HUD/' + name] = data
    for family in ['driver_hud', 'narrowhud200', 'monocraft']:
        for path in sorted((ROOT / 'third_party' / family).glob('*')):
            if path.is_file(): files['third_party/' + family + '/' + path.name] = path.read_bytes()
    files['CREDITS.txt'] = ('Integrated HUD: 2375120981.\nBased on NarrowHUD 2.0.0 by luka189 (reading modules, modified).\n'
                            'Vehicle core and solid material: DRIVER HUD; see bundled notices.\n'
                            'Monocraft: Idrees Hassan, SIL OFL 1.1.\n'
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
