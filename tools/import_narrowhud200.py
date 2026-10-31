"""Extract licensed data-reading modules; no Chef runtime or NarrowHUD renderer."""
from pathlib import Path
import argparse
import hashlib
import json
import re
import zipfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('archive', type=Path)
    args = p.parse_args()
    with zipfile.ZipFile(args.archive) as z:
        raw = z.read('Source/narrowhud.lua')
        license_text = z.read('LICENSE.txt')
    s = raw.decode('utf-8').replace('\r\n', '\n')
    data = s[s.index('local DATA ='):s.index('local BALLISTICS =')]
    modules = []
    for tag in ['01_core', '03_learned', '04_objects', '05_hand', '06_learning', '07_weapon', '12_heat']:
        m = re.search(r';\(function\(\) -- ' + tag + r'\n.*?(?=;\(function\(\) -- |\Z)', s, re.S)
        assert m, tag
        module = m[0]
        if tag == '05_hand':
            module = module.replace('local function my_unit(s) return nearest_unit() end',
                                    'local function my_unit(s) return chef.player_unit() end')
            assert 'return chef.player_unit()' in module
        modules.append(module)
    head = ('-- Based on NarrowHUD 2.0.0 by luka189; see third_party/narrowhud200/LICENSE.txt.\n'
            '-- Generated reading modules only; MDL host, no Chef loader or original drawing.\n'
            'return function(chef)\n' + data + '\nlocal M={version="2.0.0"}\n'
            'local log=chef.log\nlocal N={}\n')
    cfg = ('\nN.cfg={research=false,fire=1,wheel=1,any_build=false}\n'
           'N.MOUSE_BUTTONS={"left","right","middle","extra_1","extra_2"}\n'
           'N.KNOWN_FIELDS={}\nN.read_level=2\n')
    source = head + modules[0] + cfg + '\n'.join(modules[1:])
    source += (ROOT / 'src/narrow200_sensor_tail.lua').read_text(encoding='utf-8') + '\nend\n'
    (ROOT / 'src/vendor/narrowhud_weapon_200.lua').write_text(source, encoding='utf-8')
    out = ROOT / 'third_party/narrowhud200'
    out.mkdir(parents=True, exist_ok=True)
    (out / 'LICENSE.txt').write_bytes(license_text)
    (out / 'ORIGIN.json').write_text(json.dumps({
        'name': 'NarrowHUD', 'version': '2.0.0', 'author': 'luka189',
        'url': 'https://github.com/luka189/NarrowHUD', 'source_sha256': hashlib.sha256(raw).hexdigest(),
        'changes': 'Data and seven read/learning modules extracted. MDL-owned update/cleanup, local-avatar unit binding, own host and presentation. No Chef runtime, original renderer or unrelated HUD.'
    }, indent=2) + '\n', encoding='utf-8')


if __name__ == '__main__':
    main()
