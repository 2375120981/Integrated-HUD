"""Pack bundled mode silhouettes in the texture/material format used by MDL gui_assets.py.

Only mod-owned input geometry and Lua resources are packed. No MDL runtime or game files.
"""
import struct
from archive import resource_hash, LUA


def pack(sources, icons):
    from PIL import Image, ImageDraw
    texture_type, material_type = resource_hash('texture'), resource_hash('material')
    rows = [(LUA, resource_hash(n), struct.pack('<II', len(s.encode()), 2) + s.encode(), b'')
            for n, s in sources.items()]
    for word, icon in sorted(icons.items()):
        # Same fit as the old icon renderer: identical 34-unit square, aspect retained.
        image = Image.new('RGBA', (128, 128))
        draw = ImageDraw.Draw(image)
        scale = 128 / max(1, icon['aspect'])
        ox, oy = (128 - icon['aspect'] * scale) / 2, (128 - scale) / 2
        for x, y, w, h, alpha in icon['rects']:
            x0, y0 = round(ox + x * scale), round(oy + (1 - y - h) * scale)
            x1, y1 = round(ox + (x + w) * scale), round(oy + (1 - y) * scale)
            if x1 > x0 and y1 > y0:
                draw.rectangle((x0, y0, x1 - 1, y1 - 1), fill=(255, 255, 255, alpha))
        levels = []
        while True:
            levels.append(image.tobytes())
            if image.size == (1, 1):
                break
            image = image.resize((max(1, image.width // 2), max(1, image.height // 2)), Image.Resampling.BOX)
        name = 'mods/integrated_hud/mdl_gamesession/img/' + word.lower().replace(' ', '_')
        tex_id = resource_hash(name + '/tex')
        header = bytearray(192)
        struct.pack_into('<I', header, 8, 0xFFFFFFFF)
        dds = bytearray(148)
        dds[:4] = b'DDS '
        struct.pack_into('<7I', dds, 4, 124, 0x00021007, 128, 128, 512, 0, len(levels))
        struct.pack_into('<2I4s', dds, 76, 32, 4, b'DX10')
        struct.pack_into('<I', dds, 108, 0x00401008)
        struct.pack_into('<5I', dds, 128, 28, 3, 0, 1, 0)
        material = bytearray(160)
        for at, v in {0: 0x120, 4: 1, 8: 0x18, 12: 0x7C, 64: 1, 128: 0xBA25DE35, 136: 0x3AA8B87E}.items():
            struct.pack_into('<I', material, at, v)
        struct.pack_into('<Q', material, 140, tex_id)
        rows.extend([(texture_type, tex_id, bytes(header + dds), b''.join(levels)),
                     (material_type, resource_hash(name), bytes(material), b'')])
    rows.sort(key=lambda r: (r[0], r[1]))
    types = sorted({r[0] for r in rows})
    offset = (72 + 32 * len(types) + 80 * len(rows) + 15) & ~15
    body, gpu, entries = bytearray(offset), bytearray(), bytearray()
    for index, (kind, name, data, gdata) in enumerate(rows):
        goff = 0
        if gdata:
            gpu += b'\0' * (-len(gpu) % 64)
            goff = len(gpu)
            gpu += gdata
        entries += struct.pack('<7Q6I', name, kind, offset, 0, goff, 0, 0, len(data), 0, len(gdata),
                               16, 16 if kind == LUA else 64, index)
        body += data
        body += b'\0' * (-len(body) % 16)
        offset = len(body)
    header = struct.pack('<III20sQQ24s', 0xF0000011, len(types), len(rows), b'', len(body), 0, b'')
    table = b''.join(struct.pack('<IIQIIII', 0, 0, t, sum(r[0] == t for r in rows), 0, 16,
                                 16 if t == LUA else 64) for t in types)
    prefix = header + table + entries
    body[:len(prefix)] = prefix
    assert len({(r[0], r[1]) for r in rows}) == len(rows)
    # Check payload and GPU offsets against every resource before packaging.
    for i, (_, _, data, gdata) in enumerate(rows):
        e = struct.unpack_from('<7Q6I', body, 72 + 32 * len(types) + 80 * i)
        assert body[e[2]:e[2] + e[7]] == data
        assert not gdata or gpu[e[4]:e[4] + e[9]] == gdata
    return bytes(body), bytes(gpu)
