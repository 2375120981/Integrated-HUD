"""Bake Fusion Pixel into small lazy-loaded bitmap pages for network HUD text."""
from pathlib import Path
import io
import json
import hashlib
from fontTools.ttLib import TTFont
from PIL import ImageFont

ROOT = Path(__file__).resolve().parents[1]


def main():
    family = ROOT / 'third_party/fusion_pixel'
    source = family / 'fusion-pixel-12px-proportional-zh_hans.ttf.woff2'
    origin = json.loads((family / 'ORIGIN.json').read_text(encoding='utf-8'))
    assert hashlib.sha256(source.read_bytes()).hexdigest() == origin['font_sha256']
    tt = TTFont(source)
    cmap = tt.getBestCmap()
    tt.flavor = None
    buffer = io.BytesIO()
    tt.save(buffer)
    font = ImageFont.truetype(io.BytesIO(buffer.getvalue()), 12)
    pages = {}
    for cp in sorted(cmap):
        if cp < 32 or 127 <= cp < 160 or 0xD800 <= cp <= 0xDFFF:
            continue
        mask, (ox, oy) = font.getmask2(chr(cp), mode='1', anchor='ls')
        w, h = mask.size
        assert w <= 32 and h <= 32, (cp, w, h)
        digits = (w + 7) // 8 * 2
        rows = []
        for y in range(h):
            value = 0
            for x in range(w):
                if mask[y * w + x]:
                    value |= 1 << ((w + 7) // 8 * 8 - 1 - x)
            rows.append(f'{value:0{digits}x}' if digits else '')
        pages.setdefault(f'{cp // 256:x}', {})[f'{cp:x}'] = [
            float(font.getlength(chr(cp))), w, h, ox, oy, ''.join(rows)]
    out = ROOT / 'data/network_font'
    out.mkdir(exist_ok=True)
    for page, glyphs in pages.items():
        (out / f'{page}.json').write_text(json.dumps(glyphs, separators=(',', ':')) + '\n', encoding='utf-8')
    index = {'font': 'Fusion Pixel 12px proportional SC', 'size': 12, 'ascent': 10, 'descent': 2,
             'pages': {page: True for page in pages}, 'glyph_count': sum(map(len, pages.values())),
             'license': 'SIL OFL 1.1', 'font_program_embedded': False}
    (out / 'index.json').write_text(json.dumps(index, separators=(',', ':')) + '\n', encoding='utf-8')
    assert '4e2d' in pages['4e'] and 'ff01' in pages['ff'] and '3f' in pages['0']
    print('Baked network font:', index['glyph_count'], 'glyphs in', len(pages), 'lazy pages')


if __name__ == '__main__':
    main()
