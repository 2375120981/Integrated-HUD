"""Validate community translation data and compile a bundled Lua catalog."""
import json
import re
from pathlib import Path
from archive import lua_value


def unique_pairs(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f'Duplicate translation key: {key}')
        result[key] = value
    return result


def compile_locales(root: Path):
    catalogs = {}
    for path in sorted((root / 'locales').glob('*.json')):
        assert re.fullmatch(r'[A-Za-z][A-Za-z0-9-]*', path.stem), path.name
        data = json.loads(path.read_text(encoding='utf-8'), object_pairs_hook=unique_pairs)
        assert set(data) == {'name', 'strings'}, path.name
        assert isinstance(data['name'], str) and data['name'].strip(), path.name
        assert isinstance(data['strings'], dict), path.name
        for key, text in data['strings'].items():
            assert re.fullmatch(r'[A-Za-z0-9_.-]+', key), (path.name, key)
            assert isinstance(text, str) and text.strip() and '\0' not in text, (path.name, key)
        catalogs[path.stem] = data
    assert 'en' in catalogs and 'zh-CN' in catalogs
    base = catalogs['en']['strings']
    for code, data in catalogs.items():
        assert not set(data['strings']) - set(base), f'Unknown translation keys: {code}'
    # Missing translations deliberately fall back to English at runtime.
    return 'return ' + lua_value(catalogs)
