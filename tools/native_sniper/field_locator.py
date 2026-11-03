"""Read-only native-sniper field locator. Never writes game files or plaintext dumps."""
from pathlib import Path
import argparse
import datetime
import hashlib
import json
import re
import struct
import sys
import traceback

VERSION = '0.1.0'
TARGETS = {'APW-1': 0x89C5493E08CA4207, 'R-40': 0x41F2DEF484634B59,
           'AMW-20': 0xB814EECE17533BC4}
KNOWN = {'4121f332a6d163074521073c250d49514d5b7d20593ba34a0d1f808521370683': 'current_baseline',
         '700d880b14b571e07c6f2ff04a17426a0bb6cd1a4078f778cb38b2ae9a9adb9e': 'reported_variant'}


class FormatError(ValueError):
    pass


def require(condition, message):
    if not condition:
        raise FormatError(message)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def unpack(fmt, data, at):
    size = struct.calcsize(fmt)
    require(isinstance(at, int) and at >= 0 and at + size <= len(data), 'out-of-bounds data read')
    return struct.unpack_from(fmt, data, at)


def type_hash(name):
    value = 5381
    for byte in name.encode('ascii'):
        value = (value * 33 + byte) & 0xFFFFFFFF
    return (value - 5381) & 0xFFFFFFFF


def decode(data, kind):
    if kind == 'types' and data[:4] in (b'LTLD', b'DLTL'):
        return data, 'plain'
    if kind == 'entities' and data[4:8] in (b'LDLD', b'DLDL'):
        return data, 'plain'
    from nacl.bindings import crypto_box_seal_open
    from decode_profile import PUBLIC_KEY, PRIVATE_KEY
    try:
        return crypto_box_seal_open(data, PUBLIC_KEY, PRIVATE_KEY), 'sealed_box'
    except Exception as error:
        raise FormatError('data authentication/decode failed; this encoding profile may not apply') from error


def parse_types(data):
    magic, version, nt, ne, nm, nv, na, nd, ns = unpack('<4s8I', data, 0)
    require(magic in (b'LTLD', b'DLTL') and version == 4, 'unsupported type-library format')
    require(0 < nt <= 10000 and ne <= 10000 and nm <= 100000 and nv <= 100000 and na <= 100000,
            'unreasonable type-library counts')
    types_at = 36 + nt * 4 + ne * 4
    members_at = types_at + nt * 36 + ne * 32
    strings_at = members_at + nm * 72 + nv * 16 + na * 8 + nd
    require(strings_at + ns <= len(data), 'type-library tables exceed input')
    wanted = {type_hash(n) for n in ('WeaponDataComponentData', 'WeaponDataComponent', 'ComponentIndexData')}
    result = {}
    for i in range(nt):
        key, = unpack('<I', data, 36 + i * 4)
        if key not in wanted:
            continue
        require(key not in result, 'duplicate target type')
        _, _, _, size, _, alignment, count, first, _ = unpack('<9I', data, types_at + i * 36)
        require(0 < size <= 100000000 and first + count <= nm, 'invalid target type dimensions')
        fields = []
        for j in range(first, first + count):
            row = unpack('<3IBBH10I', data, members_at + j * 72)
            name, comment, unknown, atom, storage, array_len, tid, s32, s64, a32, a64, o32, o64, default, ds, flags = row
            require(o64 + s64 <= size, 'field exceeds containing record')
            fields.append({'offset': o64, 'size': s64, 'type': tid,
                           'atom': atom, 'storage': storage, 'array_len': array_len})
        result[key] = {'size': size, 'alignment': alignment, 'fields': fields}
    require(wanted == set(result), 'required weapon schema types missing')
    return result


def unique(items, message):
    require(len(items) == 1, message)
    return items[0]


def section(data, key):
    needle = struct.pack('<I', key)
    matches, start = [], 0
    while True:
        at = data.find(needle, start)
        if at < 0:
            break
        start = at + 1
        if at + 28 > len(data) or data[at + 4:at + 8] not in (b'LDLD', b'DLDL'):
            continue
        version, kind, size = unpack('<3I', data, at + 8)
        if version == 1 and kind == key:
            require(at + 28 + size <= len(data), 'weapon section exceeds input')
            matches.append((at, at + 28, size))
    return unique(matches, 'weapon data section absent or ambiguous')


def locate(types_plain, entities_plain):
    types = parse_types(types_plain)
    component = types[type_hash('WeaponDataComponent')]
    table = types[type_hash('WeaponDataComponentData')]
    index_type = types[type_hash('ComponentIndexData')]
    field = unique([f for f in component['fields'] if f['type'] == type_hash('CrosshairWeaponType')],
                   'CrosshairWeaponType field absent or ambiguous')
    require(field['size'] == 4 and field['atom'] == 0 and field['array_len'] == 0 and field['storage'] == 16,
            'crosshair field is not a supported scalar enum')
    indices = unique([f for f in table['fields'] if f['type'] == type_hash('ComponentIndexData')],
                     'component resource index absent or ambiguous')
    rows = unique([f for f in table['fields'] if f['type'] == type_hash('WeaponDataComponent')],
                  'weapon component array absent or ambiguous')
    resource_field = unique([f for f in index_type['fields'] if f['size'] == 8 and f['atom'] == 0 and f['storage'] == 7],
                            'resource hash member absent or ambiguous')
    index_field = unique([f for f in index_type['fields'] if f['size'] == 4 and f['atom'] == 0 and f['storage'] == 6],
                         'record index member absent or ambiguous')
    for member, element in ((indices, index_type), (rows, component)):
        require(member['atom'] == 2 and member['storage'] == 20 and member['array_len'] > 0,
                'expected a fixed component array')
        require(member['size'] == member['array_len'] * element['size'], 'array stride/schema size mismatch')
    header, base, length = section(entities_plain, type_hash('WeaponDataComponentData'))
    require(table['size'] <= length, 'weapon section too short for declared schema')
    matches = {resource: [] for resource in TARGETS.values()}
    for i in range(indices['array_len']):
        at = base + indices['offset'] + i * index_type['size']
        resource, = unpack('<Q', entities_plain, at + resource_field['offset'])
        if resource in matches:
            row, = unpack('<I', entities_plain, at + index_field['offset'])
            matches[resource].append(row)
    found = []
    for weapon, resource in TARGETS.items():
        row = unique(matches[resource], weapon + ' resource absent or ambiguous')
        require(row < rows['array_len'], weapon + ' index outside record array')
        record = base + rows['offset'] + row * component['size']
        at = record + field['offset']
        require(base <= record and record + component['size'] <= base + length, 'record exceeds section')
        value, = unpack('<I', entities_plain, at)
        found.append({'weapon': weapon, 'resource': f'{resource:016x}', 'record_index': row,
                      'record_plain_offset': record, 'field': 'CrosshairWeaponType',
                      'field_type_hash': f'{field["type"]:08x}', 'field_offset_in_record': field['offset'],
                      'field_plain_offset': at, 'current_value': value, 'proposed_value': 0,
                      'value_status': {0: 'already_default', 3: 'expected_candidate'}.get(value, 'unrecognised_value')})
    return {'type_library_version': 4, 'component_record_size': component['size'],
            'section_plain_offset': header, 'component_record_count': rows['array_len'],
            'all_target_fields_located': True,
            'expected_field_values': all(f['current_value'] in (0, 3) for f in found), 'weapons': found}


def find_game():
    roots = []
    try:
        import winreg
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r'Software\Valve\Steam') as key:
            roots.append(Path(winreg.QueryValueEx(key, 'SteamPath')[0]))
    except (ImportError, OSError):
        pass
    for root in list(roots):
        vdf = root / 'steamapps/libraryfolders.vdf'
        if vdf.exists():
            roots.extend(Path(p.replace('\\\\', '\\')) for p in re.findall(r'"path"\s+"([^"]+)"', vdf.read_text(encoding='utf-8')))
    candidates = [p / 'steamapps/common/Helldivers 2' for p in roots]
    candidates.append(Path(r'D:\steam\steamapps\common\Helldivers 2'))
    return next((p for p in candidates if (p / 'data/game/generated_entities.dl_bin').is_file()), None)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--game-root', type=Path)
    parser.add_argument('--entities', type=Path, help='Optional alternate entities file to inspect read-only')
    parser.add_argument('--typelib', type=Path, help='Optional matching alternate type library')
    parser.add_argument('--output-dir', type=Path)
    parser.add_argument('--no-pause', action='store_true')
    args = parser.parse_args()
    game = args.game_root or find_game()
    if not game:
        if sys.stdin.isatty():
            game = Path(input('请输入游戏安装目录：').strip().strip('"'))
        else:
            parser.error('game installation not found; provide --game-root')
    game = game.resolve()
    stamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')
    home = Path(sys.executable).parent if getattr(sys, 'frozen', False) else Path(__file__).parent
    out = (args.output_dir or home / 'reports' / stamp).resolve()
    require(not out.is_relative_to(game), 'report output must be outside the game installation')
    require(not (out / 'FieldLocator.json').exists(), 'report already exists; use a new output directory')
    out.mkdir(parents=True, exist_ok=True)
    report = {'tool_version': VERSION, 'diagnostic_only': True, 'game_files_changed': False,
              'writes_implemented': False, 'runtime_patch_ready': False, 'status': 'failed',
              'note': 'Field offsets refer to decrypted data; they are NOT offsets for writing encrypted files.'}
    try:
        manifest = game.parent.parent / 'appmanifest_553850.acf'
        if manifest.exists():
            match = re.search(r'"buildid"\s+"(\d+)"', manifest.read_text(encoding='utf-8'))
            report['game_build'] = match[1] if match else None
        paths = {'entities': (args.entities or game / 'data/game/generated_entities.dl_bin').resolve(),
                 'typelib': (args.typelib or game / 'data/game/dl_library.dl_typelib').resolve()}
        blobs = {}
        for name, path in paths.items():
            require(path.is_file() and 48 <= path.stat().st_size <= 512 * 1024 * 1024, 'invalid ' + name + ' input')
            sealed = path.read_bytes()
            report[name] = {'path': str(path), 'bytes': len(sealed), 'sha256': digest(sealed)}
            blobs[name], encoding = decode(sealed, 'types' if name == 'typelib' else 'entities')
            report[name]['encoding'] = encoding
            report[name]['plain_bytes'] = len(blobs[name])
        report['entities']['known_variant'] = KNOWN.get(report['entities']['sha256'], 'unknown_accepted_for_analysis')
        report.update(locate(blobs['typelib'], blobs['entities']))
        report['inputs_unchanged_during_analysis'] = all(digest(path.read_bytes()) == report[name]['sha256'] for name, path in paths.items())
        require(report['inputs_unchanged_during_analysis'], 'input changed while being inspected; rerun after Steam completes updates')
        report['status'] = 'located'
    except Exception as error:
        report['error'] = str(error)
    (out / 'FieldLocator.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    lines = ['原生狙击准星：只读字段定位 v' + VERSION, '状态：' + report['status'],
             '没有修改游戏文件；没有生成可安装补丁。']
    if report['status'] == 'located':
        lines.append('数据文件 SHA256：' + report['entities']['sha256'])
        for item in report['weapons']:
            lines.append(f"{item['weapon']}: 字段偏移={item['field_plain_offset']} 当前值={item['current_value']} ({item['value_status']})")
        lines.append('定位成功仅证明能够找到字段；加密封装、内部校验和写入兼容性仍未验证。')
    else:
        lines.append('失败原因：' + report.get('error', 'unknown'))
    (out / '结果说明.txt').write_text('\n'.join(lines) + '\n', encoding='utf-8')
    print('\n'.join(lines))
    print('报告目录：' + str(out))
    return 0 if report['status'] == 'located' else 1


if __name__ == '__main__':
    if hasattr(sys.stdout, 'reconfigure'):
        sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    result = main()
    if getattr(sys, 'frozen', False) and len(sys.argv) == 1:
        input('按回车关闭……')
    raise SystemExit(result)
