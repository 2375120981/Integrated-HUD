"""Interactive offline native sniper crosshair switch; confirmation required before writes."""
from pathlib import Path
import argparse
import datetime
import json
import os
import struct
import subprocess
import sys
import tempfile

from field_locator import require, digest, decode, locate, find_game
from integrity import MASK, MUL, INV, SEED, walk, undo, hash64

VERSION = '0.2.0'


def closed_game():
    result = subprocess.run(['tasklist', '/FI', 'IMAGENAME eq helldivers2.exe', '/FO', 'CSV', '/NH'],
                            capture_output=True, creationflags=0x08000000, timeout=15)
    require(result.returncode == 0, 'cannot verify whether the game is closed')
    require(b'helldivers2.exe' not in result.stdout.lower(), '请先退出游戏，再运行工具。')


def headers(data):
    found = []
    at = data.find(b'LDLD\1\0\0\0', 0, 64)
    while at >= 0:
        require(at + 24 <= len(data), 'truncated block header')
        size, = struct.unpack_from('<I', data, at + 12)
        end = at + 24 + size
        require(end <= len(data) and data[at + 16] == 1, 'unsupported block bounds/flags')
        found.append(at)
        at = data.find(b'LDLD\1\0\0\0', end, min(len(data), end + 64))
    require(len(found) >= 2 and len(found) < 10000, 'unsupported block chain')
    x, salt = found[-1], found[-2]
    require(x % 8 == 4 and salt + 24 < x, 'unsupported correction-header alignment')
    return x, salt


def prepare(sealed, plain, types, dll, destination):
    require(decode(sealed, 'entities')[1] == 'sealed_box', 'write requires authenticated encrypted input')
    info = locate(types, plain)
    require(all(w['current_value'] == 3 - destination for w in info['weapons']), 'mixed/unknown crosshair state')
    x, salt = headers(plain)
    target = hash64(plain)
    require(struct.pack('<Q', target) in dll, 'data checksum not recognised by this game.dll; no writes')
    edited = bytearray(plain)
    for w in info['weapons']:
        struct.pack_into('<I', edited, w['field_plain_offset'], destination)
    end = len(plain) // 8 * 8
    final = target ^ (target >> 47)
    final = final * INV & MASK
    final ^= final >> 47
    if end < len(plain):
        final = (final * INV & MASK) ^ int.from_bytes(plain[end:], 'little')
    after = undo(edited, final, x + 28, end)
    lo = (salt + 17) // 8 * 8
    before = walk(edited, SEED ^ (len(edited) * MUL & MASK), 0, lo)
    fixed = struct.unpack_from('<Q', edited, x + 12)[0] & ((1 << 40) - 1)
    high = struct.unpack_from('<Q', edited, x + 20)[0] >> 32
    batch = bytearray(struct.pack('<IQQ', 1024, fixed, high))
    for s in range(1, 1025):
        struct.pack_into('<H', edited, salt + 17, s)
        state = walk(edited, before, lo, x + 12)
        batch.extend(struct.pack('<IQQ', s, state, after * INV & MASK))
    home = Path(getattr(sys, '_MEIPASS', Path(__file__).parent))
    with tempfile.TemporaryDirectory(prefix='ihud-solver-') as tmp:
        work = Path(tmp)
        (work / 'input.bin').write_bytes(batch)
        run = subprocess.run([str(home / 'solve.exe'), 'input.bin', 'output.bin'], cwd=work,
                             capture_output=True, creationflags=0x08000000, timeout=180)
        require(run.returncode == 0, 'checksum solver failed; no writes')
        answer = (work / 'output.bin').read_bytes()
    require(len(answer) == 20, 'invalid solver result')
    s, w12, w20 = struct.unpack('<IQQ', answer)
    require(1 <= s <= 1024, 'invalid correction salt')
    struct.pack_into('<H', edited, salt + 17, s)
    struct.pack_into('<Q', edited, x + 12, w12)
    struct.pack_into('<Q', edited, x + 20, w20)
    permitted = {w['field_plain_offset'] for w in info['weapons']} | set(range(x + 17, x + 24)) | set(range(salt + 17, salt + 19))
    require(all(a == b or i in permitted for i, (a, b) in enumerate(zip(plain, edited))), 'unexpected plaintext changes')
    require(hash64(edited) == target, 'checksum reconstruction failed')
    require(all(w['current_value'] == destination for w in locate(types, edited)['weapons']), 'field validation failed')
    from nacl.bindings import crypto_box_beforenm, crypto_box_afternm
    from decode_profile import PUBLIC_KEY, PRIVATE_KEY
    import hashlib
    nonce = hashlib.blake2b(sealed[:32] + PUBLIC_KEY, digest_size=24).digest()
    result = sealed[:32] + crypto_box_afternm(bytes(edited), nonce, crypto_box_beforenm(sealed[:32], PRIVATE_KEY))
    require(len(result) == len(sealed) and decode(result, 'entities')[0] == edited, 'encrypted output verification failed')
    return result


def exact_backup(directory, current, types):
    if not directory.is_dir():
        return None
    for path in sorted(directory.glob('*.json')):
        meta = json.loads(path.read_text(encoding='utf-8'))
        if meta.get('after_sha256') != digest(current) or meta.get('destination') != 0:
            continue
        backup = directory / (meta['before_sha256'] + '.dl_bin')
        candidate = backup.read_bytes()
        require(digest(candidate) == meta['before_sha256'], 'backup checksum mismatch')
        require(all(w['current_value'] == 3 for w in locate(types, decode(candidate, 'entities')[0])['weapons']), 'backup state invalid')
        return candidate
    return None


def save_new(path, data):
    if path.exists():
        require(path.read_bytes() == data, 'existing backup conflict')
        return
    with path.open('xb') as stream:
        stream.write(data)
        stream.flush()
        os.fsync(stream.fileno())


def commit(path, before, after, types_path, types_digest, dll_path, dll_digest, destination, report):
    closed_game()
    require(path.read_bytes() == before, 'game data changed since analysis; no writes')
    require(digest(types_path.read_bytes()) == types_digest and digest(dll_path.read_bytes()) == dll_digest,
            'game schema/executable changed since analysis; no writes')
    directory = path.parent / 'IntegratedHUD-NativeSniper-Backups'
    directory.mkdir(exist_ok=True)
    backup = directory / (digest(before) + '.dl_bin')
    save_new(backup, before)
    meta = {'before_sha256': digest(before), 'after_sha256': digest(after), 'destination': destination,
            'backup': str(backup), 'tool_version': VERSION, 'state': 'prepared'}
    journal = directory / (digest(after) + '.json')
    # A separate transaction journal is retained before the atomic replace.
    journal.write_text(json.dumps(meta, indent=2), encoding='utf-8')
    report['transaction'] = meta.copy()
    fd, temp_name = tempfile.mkstemp(prefix='.integrated-hud-', suffix='.tmp', dir=path.parent)
    temp_path = Path(temp_name)
    try:
        with os.fdopen(fd, 'wb') as stream:
            stream.write(after)
            stream.flush()
            os.fsync(stream.fileno())
        require(temp_path.read_bytes() == after, 'staged file verification failed')
        closed_game()
        require(path.read_bytes() == before, 'game data changed before commit; no writes')
        require(digest(types_path.read_bytes()) == types_digest and digest(dll_path.read_bytes()) == dll_digest,
                'game installation changed before commit; no writes')
        os.replace(temp_path, path)
        report['game_files_changed'] = True
        require(path.read_bytes() == after, 'post-write verification failed; retain backup and restore it before playing')
        meta['state'] = 'committed'
        journal.write_text(json.dumps(meta, indent=2), encoding='utf-8')
        report['transaction'] = meta
    finally:
        if temp_path.exists():
            temp_path.unlink()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--game-root', type=Path)
    parser.add_argument('--output-dir', type=Path)
    parser.add_argument('--inspect-only', action='store_true')
    parser.add_argument('--no-pause', action='store_true')
    args = parser.parse_args()
    game = args.game_root or find_game()
    if game is None:
        game = Path(input('请输入游戏安装目录：').strip().strip('"'))
    game = game.resolve()
    home = Path(sys.executable).parent if getattr(sys, 'frozen', False) else Path(__file__).parent
    stamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')
    out = (args.output_dir or home / 'reports' / stamp).resolve()
    require(not out.is_relative_to(game), 'report output must be outside game installation')
    out.mkdir(parents=True, exist_ok=False)
    report = {'tool_version': VERSION, 'status': 'failed', 'game_files_changed': False}
    lines = ['原生狙击准星交互工具 v' + VERSION]
    displayed = 0
    try:
        data = game / 'data/game'
        path, types_path, dll_path = (data / n for n in ('generated_entities.dl_bin', 'dl_library.dl_typelib', 'game.dll'))
        sealed = path.read_bytes()
        types_raw, dll = types_path.read_bytes(), dll_path.read_bytes()
        plain, encoding = decode(sealed, 'entities')
        types, _ = decode(types_raw, 'types')
        info = locate(types, plain)
        report.update(info)
        report['source_sha256'] = digest(sealed)
        report['status'] = 'located'
        values = {w['current_value'] for w in info['weapons']}
        for w in info['weapons']:
            lines.append(f"{w['weapon']}: " + {0: '已启用', 3: '未启用'}.get(w['current_value'], '未知状态'))
        print('\n'.join(lines), flush=True)
        displayed = len(lines)
        require(values in ({0}, {3}), '三把枪状态不一致或未知，仅生成报告，不自动覆盖。')
        if args.inspect_only:
            lines.append('只读检查完成，没有写入。')
        else:
            closed_game()
            require(encoding == 'sealed_box', 'plaintext input is inspection-only')
            destination = 0 if values == {3} else 3
            operation = '启用' if destination == 0 else '禁用'
            print('将备份原文件，校验通过后切换 APW-1、R-40、AMW-20。请关闭游戏及 Steam 更新。', flush=True)
            answer = input(f'是否{operation}原生第三人称准星？输入 YES 确认，其余输入取消：').strip()
            if answer.upper() != 'YES':
                report['status'] = 'cancelled'
                lines.append('已取消，没有修改游戏文件。')
            else:
                print('正在生成并校验候选文件，请稍候；完成前不会写入游戏数据……', flush=True)
                candidate = exact_backup(data / 'IntegratedHUD-NativeSniper-Backups', sealed, types) if destination == 3 else None
                report['exact_backup_restore'] = candidate is not None
                if candidate is None:
                    candidate = prepare(sealed, plain, types, dll, destination)
                else:
                    require(hash64(decode(candidate, 'entities')[0]) == hash64(plain), 'restore checksum mismatch')
                    require(struct.pack('<Q', hash64(plain)) in dll, 'checksum unrecognised by game.dll')
                commit(path, sealed, candidate, types_path, digest(types_raw), dll_path, digest(dll), destination, report)
                report['output_sha256'] = digest(candidate)
                report['status'] = 'success'
                lines.append(f'SUCCESS：已{operation}，下次启动游戏生效。备份路径见报告。')
    except (Exception, KeyboardInterrupt) as error:
        report['status'] = 'failed'
        report['error'] = str(error) or '操作中断'
        lines.append('未完成：' + report['error'])
        if report['game_files_changed']:
            lines.append('写入已发生，请根据报告内备份检查或恢复，不要直接重复操作。')
        else:
            lines.append('未修改游戏数据。')
    (out / 'SniperToggle.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    (out / '结果说明.txt').write_text('\n'.join(lines) + '\n', encoding='utf-8')
    print('\n'.join(lines[displayed:]))
    print('报告目录：' + str(out))
    return 0 if report['status'] in ('success', 'located', 'cancelled') else 1


if __name__ == '__main__':
    if hasattr(sys.stdout, 'reconfigure'):
        sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    try:
        result = main()
    except Exception as error:
        print('失败：' + str(error))
        result = 1
    if getattr(sys, 'frozen', False) and '--no-pause' not in sys.argv:
        input('按回车关闭……')
    raise SystemExit(result)
