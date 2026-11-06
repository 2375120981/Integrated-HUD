"""Read the installed game's native booster vectors and render them for MDL GUI.

Paths and colors are unchanged. Only the 20 small resulting icons enter the mod.
The full native resource and game/MDL code are never bundled.
"""
from pathlib import Path
import hashlib
import json
import subprocess
from archive import resource_hash
from game_resources import GameResources


def prepare(game_root, work):
    root = Path(__file__).resolve().parents[1]
    spec = json.loads((root / 'data/booster_icons.json').read_text(encoding='utf-8'))
    raw, _ = GameResources(Path(game_root) / 'data').resource(
        spec['package'], resource_hash(spec['resource']), int(spec['type'], 16))
    assert hashlib.sha256(raw).hexdigest() == spec['sha256'], 'Native booster icon resource changed; review before building'
    folder = Path(work).resolve() / 'native_booster_images'
    folder.mkdir(parents=True, exist_ok=True)
    source = folder / 'booster_icons.xaml'
    source.write_bytes(raw[16:])
    subprocess.run(['powershell.exe', '-NoProfile', '-STA', '-ExecutionPolicy', 'Bypass',
                    '-File', str(root / 'tools/render_booster_icons.ps1'),
                    '-Source', str(source), '-Output', str(folder)], check=True, capture_output=True)
    from PIL import Image
    images = {}
    for name in spec['names']:
        with Image.open(folder / (name + '.png')) as image:
            assert image.size == (128, 128) and image.getbbox(), name
            images['mods/integrated_hud/mdl_gamesession/img/booster_' + name.lower()] = image.convert('RGBA')
    return images
