"""Lua resource archive and standalone boot wrapper helpers."""
import struct
import json
PREFIX="mods/integrated_hud/driver_reference/"
LUA=0xA14E8DFA2CD117E2

def resource_hash(name):
    data = name.encode()
    mask, mix = (1 << 64) - 1, 0xC6A4A7935BD1E995
    value = len(data) * mix & mask
    end = len(data) // 8 * 8
    for offset in range(0, end, 8):
        word = int.from_bytes(data[offset:offset + 8], 'little')
        word = word * mix & mask
        word ^= word >> 47
        value = (value ^ (word * mix & mask)) * mix & mask
    if end != len(data):
        value = (value ^ int.from_bytes(data[end:], 'little')) * mix & mask
    value ^= value >> 47
    value = value * mix & mask
    return value ^ (value >> 47)

def archive(sources):
    count = len(sources)
    start = (104 + count * 80 + 15) // 16 * 16
    body, entries = bytearray(), bytearray()
    for index, (name, source) in enumerate(sorted(sources.items())):
        source.decode('utf-8')
        assert b'\0' not in source
        payload = struct.pack('<II', len(source), 2) + source
        entries.extend(struct.pack('<7Q6I', resource_hash(name), LUA, start + len(body),
                                   0, 0, 0, 0, len(payload), 0, 0, 16, 16, index))
        body.extend(payload)
        body.extend(b'\0' * (-len(body) % 16))
    head = struct.pack('<III20sQQ24s', 0xF0000011, 1, count, b'', start + len(body), 0, b'')
    result = head + struct.pack('<IIQIIII', 0, 0, LUA, count, 0, 16, 16) + entries
    result += b'\0' * (start - len(result)) + body
    assert len(result) == start + len(body)
    assert len({resource_hash(n) for n in sources}) == count
    for i, (name, source) in enumerate(sorted(sources.items())):
        e = struct.unpack_from('<7Q6I', result, 104 + i * 80)
        assert e[:2] == (resource_hash(name), LUA)
        assert struct.unpack_from('<II', result, e[2]) == (len(source), 2)
        assert result[e[2] + 8:e[2] + e[7]] == source
    return bytes(result)

def boot_source(original):
    size, fmt = struct.unpack_from('<II', original)
    assert size == len(original) - 8 and fmt == 1
    payload = original[8:]
    assert payload.startswith(b'\x1bLuaQ')
    literal = '"' + ''.join('\\%03d' % byte for byte in payload) + '"'
    return ("-- Current original boot bytecode is preserved byte-for-byte.\n"
            "local original = " + literal + "\n"
            "local loader = rawget(_G, 'loadstring') or rawget(_G, 'load')\n"
            "if type(loader) ~= 'function' then error('IHUD: Lua loader missing') end\n"
            "local chunk, why = loader(original, '@integrated_hud_original_boot')\n"
            "if not chunk then error('IHUD: original boot rejected: ' .. tostring(why)) end\n"
            "local original_result = chunk()\n"
            "local ok, result = pcall(function()\n"
            "  return require('" + PREFIX + "runtime').attach()\n"
            "end)\n"
            "if not ok then\n"
            "  pcall(function()\n"
            "    local base = os.getenv('APPDATA')\n"
            "    local path = base and (base .. '/Arrowhead/Helldivers2/IntegratedHUD-bootstrap.log') or 'IntegratedHUD-bootstrap.log'\n"
            "    local f = io.open(path, 'a')\n"
            "    if f then f:write('ATTACH_FAILED ' .. tostring(result) .. '\\n'); f:close() end\n"
            "  end)\n"
            "  if type(print) == 'function' then print('[IHUD] ' .. tostring(result)) end\n"
            "end\nreturn original_result\n").encode()

def lua_value(value):
    if isinstance(value, dict):
        return '{' + ','.join('[' + json.dumps(k, ensure_ascii=False) + ']=' + lua_value(v) for k, v in value.items()) + '}'
    if isinstance(value, list):
        return '{' + ','.join(map(lua_value, value)) + '}'
    if isinstance(value, bool):
        return 'true' if value else 'false'
    if value is None:
        return 'nil'
    return json.dumps(value, ensure_ascii=False)
