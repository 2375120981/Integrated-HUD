"""Build Integrated HUD from the checked-in sources and local installed game."""
from pathlib import Path
import argparse
import hashlib
import json
import os
import re
import struct
import zipfile
from archive import archive, resource_hash, boot_source, PREFIX, LUA, lua_value
from geometry import triangulate_polygon
from game_resources import GameResources

ROOT = Path(__file__).resolve().parents[1]


def digest(data):
    return hashlib.sha256(data).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--game-root', default=os.environ.get('HD2_GAME_ROOT'),
                        help='Installed HELLDIVERS 2 directory; or set HD2_GAME_ROOT')
    parser.add_argument('--output-dir', type=Path, default=ROOT / 'dist')
    args = parser.parse_args()
    if not args.game_root:
        parser.error('Provide --game-root or set HD2_GAME_ROOT')
    cfg = json.loads((ROOT / 'version.json').read_text(encoding='utf-8'))
    version = cfg['version']
    assert re.fullmatch(r'\d+\.\d+\.\d+', version), 'Version must have no suffix'
    inputs = json.loads((ROOT / 'build-inputs.json').read_text(encoding='utf-8'))
    game = Path(args.game_root).resolve()
    acf = (game.parent.parent / 'appmanifest_553850.acf').read_text(encoding='utf-8')
    assert re.search(r'"buildid"\s+"(\d+)"', acf)[1] == cfg['steam_build'], 'Installed game build changed'
    assert digest((game / 'data/game/game.dll').read_bytes()) == cfg['game_dll_sha256'], 'Game DLL changed'
    original, _ = GameResources(game / 'data').resource('9ba626afa44a3aa3', resource_hash('boot'), LUA)
    assert digest(original) == cfg['boot_sha256'], 'Original boot changed'

    original_core = (ROOT / 'src/vendor/driver_hud_160.lua').read_bytes()
    assert digest(original_core) == inputs['driver_core_sha256'], 'Original vendor source changed'
    core = original_core
    patches = [
        (b'if not show_frv and not M.hull then clear();return end',
         b'if not show_frv and not M.hull then if M.integrated_mech_render then M.integrated_mech_render(session,avatar,worlds,world,motion,where,state);return end;clear();return end'),
        (b'  M.preseat_owned=set',
         b'  if M.integrated_mech_prewarm then M.integrated_mech_prewarm(session,avatar,world,owned_ids)end\n  if M.integrated_weapon_tick then M.integrated_weapon_tick(session,avatar,worlds,world,owned_ids,motion,where,state)end\n  M.preseat_owned=set'),
        (b'if not stable or not cached or M.clock>=cached.until_time then',
         b'if not cached or M.clock>=cached.until_time then'),
        (b' local worlds=call(App.worlds);local world=call(App.main_world)',
         b' local worlds=call(App.worlds);local world=call(App.main_world)\n if M.integrated_weapon_begin then M.integrated_weapon_begin(worlds,world)end'),
        (b' M.idle_settled=nil;M.next_idle_probe=nil\n if not M.seated then',
         b' if M.integrated_weapon_hide then M.integrated_weapon_hide()end\n M.idle_settled=nil;M.next_idle_probe=nil\n if not M.seated then'),
    ]
    for before, after in patches:
        assert core.count(before) == 1, 'Original core patch location changed'
        core = core.replace(before, after, 1)
    extension_names = ['driver_own_style', 'driver_seat_acquisition', 'driver_tank_acquisition',
                       'driver_mech_hud', 'driver_performance', 'driver_weapon_hud']
    extensions = [(ROOT / 'src' / (name + '.lua')).read_bytes() for name in extension_names]
    injected = b'-- BEGIN INTEGRATED HUD EXTENSIONS\n' + b'\n'.join(extensions) + b'\n-- END INTEGRATED HUD EXTENSIONS\n'
    marker = b'-- Diagnostics attachment API 1.'
    assert core.count(marker) == 1
    core = core.replace(marker, injected + marker, 1)
    recovered = core.replace(injected, b'', 1)
    for before, after in reversed(patches):
        recovered = recovered.replace(after, before, 1)
    assert recovered == original_core, 'Unaccounted change to vendor core'

    layout = json.loads((ROOT / 'layout/vehicles.json').read_text(encoding='utf-8'))
    tank_data = ('return ' + lua_value(layout['tank']) + '\n').encode()
    mech = dict(layout['mech'])
    mech['fill_triangles'] = triangulate_polygon(mech['outline'])
    mech_data = ('return ' + lua_value(mech) + '\n').encode()
    binding = (ROOT / 'src/mech_binding.lua').read_bytes()
    sources = {
        PREFIX + 'driver_core': core,
        PREFIX + 'runtime': (ROOT / 'src/driver_whole_mech_runtime.lua').read_bytes(),
        PREFIX + 'own_style_data': tank_data,
        PREFIX + 'mech_style_data': mech_data,
        PREFIX + 'mech_binding': binding,
        'boot': boot_source(original),
    }
    weapon_facts = json.loads((ROOT / 'data/weapon_narrow.json').read_text(encoding='utf-8'))
    for field in weapon_facts['data']['roles'].values():
        assert resource_hash(field['name']) >> 32 == int(field['id'], 16), 'Invalid NarrowHUD field token'
    weapon_data = ('return ' + lua_value(weapon_facts) + '\n').encode()
    weapon_layout = ('return ' + lua_value(json.loads((ROOT / 'layout/weapon.json').read_text(encoding='utf-8'))) + '\n').encode()
    weapon_reader = (ROOT / 'src/narrow_weapon_reader.lua').read_bytes()
    sensor = (ROOT / 'src/vendor/narrowhud_weapon_105.lua').read_bytes()
    sources[PREFIX + 'weapon_data'] = weapon_data
    sources[PREFIX + 'weapon_layout'] = weapon_layout
    sources[PREFIX + 'weapon_reader'] = weapon_reader
    sources[PREFIX + 'narrowhud_weapon_sensor'] = sensor
    native_ui = (ROOT / 'src/weapon_art_ui.lua').read_bytes()
    presentation = json.loads((ROOT / 'data/weapon_presentation.json').read_text(encoding='utf-8'))
    art = json.loads((ROOT / 'data/weapon_art.json').read_text(encoding='utf-8'))
    assert art['font'] == 'Monocraft' and not art['font_program_embedded']
    assert len(art['icons']) == 13 and all(art['glyphs'][ch]['triangles'] for ch in '0123456789RPM%/')
    art_source = ('return ' + lua_value(art) + '\n').encode()
    presentation_source = ('return ' + lua_value(presentation) + '\n').encode()
    sources[PREFIX + 'weapon_art_ui'] = native_ui
    sources[PREFIX + 'weapon_art'] = art_source
    sources[PREFIX + 'weapon_presentation'] = presentation_source
    for name, source in sources.items():
        for dep in re.findall(rb"require\(['\"]([^'\"]+)['\"]\)", source):
            assert dep.decode() in sources, (name, dep)
    from lupa.lua51 import LuaRuntime
    lua = LuaRuntime(encoding=None)
    for name, source in sources.items():
        lua.compile(source, name=name.encode())
    literal = sources['boot'].split(b'local original = ', 1)[1].split(b'\n', 1)[0]
    assert lua.execute(b'return ' + literal) == original[8:]
    test = LuaRuntime(unpack_returned_tuples=True)
    for key, source in [('CORE_SOURCE', core), ('STYLE_SOURCE', tank_data),
                        ('MECH_STYLE_SOURCE', mech_data), ('MECH_BINDING_SOURCE', binding)]:
        test.globals()[key] = source.decode()
    test.globals().WEAPON_SOURCE = weapon_reader.decode()
    test.globals().WEAPON_DATA_SOURCE = weapon_data.decode()
    test.globals().WEAPON_LAYOUT_SOURCE = weapon_layout.decode()
    test.globals().WEAPON_RENDER_TEST = True
    test.globals().NATIVE_UI_SOURCE = native_ui.decode()
    test.globals().WEAPON_ART_SOURCE = art_source.decode()
    test.globals().PRESENTATION_SOURCE = presentation_source.decode()
    test.globals().PERF_EXPECTED = True
    checks = dict(test.execute((ROOT / 'tests/driver_reference_basic_check.lua').read_text(encoding='utf-8')).items())
    mech_test = LuaRuntime(unpack_returned_tuples=True)
    mech_test.globals().BINDING_SOURCE = binding.decode()
    checks.update({'mech_' + key: val for key, val in dict(mech_test.execute(
        (ROOT / 'tests/mech_binding_basic_check.lua').read_text(encoding='utf-8')).items()).items()})

    weapon_test = LuaRuntime(unpack_returned_tuples=True)
    weapon_test.globals().WEAPON_SOURCE = weapon_reader.decode()
    weapon_test.globals().WEAPON_DATA_SOURCE = weapon_data.decode()
    weapon_test.globals().SENSOR_SOURCE = sensor.decode()
    checks.update({'weapon_' + key: val for key, val in dict(weapon_test.execute(
        (ROOT / 'tests/narrow_weapon_basic_check.lua').read_text(encoding='utf-8')).items()).items()})
    patch = archive(sources)
    _, types, count = struct.unpack_from('<III', patch)
    entries = [struct.unpack_from('<7Q6I', patch, 72 + 32 * types + i * 80) for i in range(count)]
    entry = next(row for row in entries if row[0] == resource_hash(PREFIX + 'driver_core'))
    assert patch[entry[2] + 8:entry[2] + entry[7]] == core
    report = {
        'name': cfg['name'], 'version': version, 'steam_build': cfg['steam_build'],
        'standalone': True, 'external_loader_required': False, 'ffi_required': False,
        'original_boot_preserved': True, 'vendor_source_sha256': inputs['driver_core_sha256'],
        'core_sha256': digest(core), 'vendor_changes_restricted_to_declared_patches': True,
        'tank_weapon_telemetry': False, 'ownership_cache_seconds': 0.2,
        'mech_health_text': 'current_only', 'periodic_debug_logging': False,
        'weapon_hud': 'narrowhud_1.0.5_sensor_independent_host', 'weapon_capacity': 'object_calibrated_with_seed_fallback',
        'reload_progress': 'hidden_while_reloading', 'crosshair_anchor': 'screen_center', 'weapon_arc_count': 1, 'weapon_arc_priority': ['heat','ammo'],
        'weapon_arc_geometry': 'annular_quads_two_triangles_outline_63_degrees',
        'weapon_font': 'bundled_monocraft_geometry', 'font_program_embedded': False, 'fire_mode_display': False,
        'weapon_mode_icons': 'bundled_original_icon_geometry', 'native_text_or_bitmap_required': False,
        'weapon_input_capture': 'fire_only_per_render_frame',
        'weapon_selection': 'pose_and_hand_models_0.1_seconds', 'swap_input_selects_weapon': False,
        'weapon_primitive_groups': ['arc', 'count', 'modes'], 'hudplus_runtime_dependency': False,
        'syntax': True, 'basic_checks': checks, 'deployed': False, 'checksum_sidecars': False,
    }
    manifest = {
        'Version': 1, 'Guid': 'ae374de7-86d0-5fa6-8a42-8fcb4d9b07fe',
        'Name': cfg['name'],
        'Description': ('集成HUD（Integrated HUD）' + version + '\n'
                        '武器HUD：准星右侧单圆弧显示弹匣余量或热量，显示弹药数字、功能模式图标及射速设置；换弹时自动隐藏，采用Monocraft字体。\n'
                        'FRV／坦克HUD：显示载具外形、座位占用和当前血量，突出标记本地玩家座位；FRV额外显示轮胎状态。\n'
                        '机甲HUD：统一机甲剪影，显示当前血量，并随血量变化调整颜色。\n'
                        '前置依赖：独立加载，无需Chef、BSL、BML、MDL、FFI、Python或外部采样器；使用支持本包格式的模组管理器安装。'),
        'Options': [{'Name': '集成HUD', 'Description': '启用潜兵武器弹药／热量圆弧、功能模式，以及FRV、坦克和机甲HUD；独立加载，无额外加载器依赖。', 'Include': ['HUD']}],
    }
    files = {
        'manifest.json': json.dumps(manifest, ensure_ascii=False, indent=2).encode(),
        'HUD/9ba626afa44a3aa3.patch_0': patch,
        'HUD/9ba626afa44a3aa3.patch_0.gpu_resources': b'',
        'HUD/9ba626afa44a3aa3.patch_0.stream': b'',
        'version.json': (ROOT / 'version.json').read_bytes(),
        'VERIFICATION.json': json.dumps(report, ensure_ascii=False, indent=2).encode(),
    }
    for name, expected in inputs['assets_sha256'].items():
        data = (ROOT / 'assets/driver_hud' / name).read_bytes()
        assert digest(data) == expected, 'Required material asset changed: ' + name
        files['HUD/' + name] = data
    for name in ['README.md', 'CREDITS.md', 'LICENSE.md', 'WEAPON-TEST.md']:
        files[name] = (ROOT / name).read_bytes()
    for name in ['LICENSE.txt', 'CREDITS.txt']:
        files['third_party/driver_hud/' + name] = (ROOT / 'third_party/driver_hud' / name).read_bytes()
    for name in ['LICENSE.txt', 'ORIGIN.json']:
        files['third_party/narrowhud/' + name] = (ROOT / 'third_party/narrowhud' / name).read_bytes()
    for name in ['LICENSE.txt', 'ORIGIN.json']:
        files['third_party/monocraft/' + name] = (ROOT / 'third_party/monocraft' / name).read_bytes()
    for path in sorted((ROOT / 'assets/weapon_icons').glob('*.png')):
        files['Artwork/WeaponIcons/' + path.name] = path.read_bytes()
    files['Artwork/README.md'] = (ROOT / 'assets/weapon_icons/README.md').read_bytes()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    out = args.output_dir / ('IntegratedHUD-' + version + '.zip')
    assert not out.exists(), 'Preserve existing release; choose a different output directory'
    with zipfile.ZipFile(out, 'x', compression=zipfile.ZIP_DEFLATED) as z:
        for name, data in files.items():
            z.writestr(name, data)
    with zipfile.ZipFile(out) as z:
        assert z.testzip() is None and set(z.namelist()) == set(files)
        assert all(z.read(name) == data for name, data in files.items())
        assert not any(name.lower().endswith('.sha256') for name in z.namelist())
    (args.output_dir / 'VERIFICATION.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({'package': str(out), 'bytes': out.stat().st_size, 'checks': report}, ensure_ascii=True))


if __name__ == '__main__':
    main()
