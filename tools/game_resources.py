"""Read original bundled resources without reconstructing/writing game archives."""
from pathlib import Path
import struct
from lz4 import block


class GameResources:
    def __init__(self, data_root):
        self.root = Path(data_root)
        self.chunk_cache = {}
        self.index = self._whole_dsar(self.root / 'bundles.nxa')

    def _chunks(self, path):
        if path not in self.chunk_cache:
            with path.open('rb') as stream:
                header = stream.read(32)
                assert header[:4] == b'DSAR', f'Unsupported bundle: {path.name}'
                count = struct.unpack_from('<I', header, 8)[0]
                assert 0 < count <= 2_000_000
                table = stream.read(count * 32)
                assert len(table) == count * 32
            chunks = [struct.unpack_from('<QQIIBB6x', table, i * 32) for i in range(count)]
            self.chunk_cache[path] = chunks
        return self.chunk_cache[path]

    @staticmethod
    def _decode(stream, item):
        _, offset, size, compressed_size, compression, _ = item
        stream.seek(offset)
        data = stream.read(compressed_size)
        assert len(data) == compressed_size
        if compression == 3:
            data = block.decompress(data, uncompressed_size=size)
        else:
            assert compression == 0, f'Unsupported compression {compression}'
        assert len(data) == size
        return data

    def _whole_dsar(self, path):
        with path.open('rb') as stream:
            return b''.join(self._decode(stream, item) for item in self._chunks(path))

    def _resource(self, path, offset):
        chunks = self._chunks(path)
        start = next(i for i, item in enumerate(chunks) if item[0] == offset)
        data = []
        with path.open('rb') as stream:
            for i in range(start, len(chunks)):
                if i != start and chunks[i][5] & 2:
                    break
                data.append(self._decode(stream, chunks[i]))
        return b''.join(data)

    def _parts(self, name):
        count = struct.unpack_from('<I', self.index, 16)[0]
        for i in range(count):
            offset = 24 + i * 24
            _, name_offset, entries, entries_offset = struct.unpack_from('<QIII', self.index, offset)
            end = self.index.index(b'\0', name_offset)
            if self.index[name_offset:end].decode('utf-8') != name:
                continue
            result = []
            for j in range(entries):
                position = entries_offset + j * 16
                original, start = struct.unpack_from('<QI', self.index, position)
                bundle = self.index[position + 15]
                result.append((original, start, bundle))
            return result
        raise ValueError(f'Original package not found: {name}')

    def resource(self, package, resource_id, resource_type):
        parts = self._parts(package)
        first = min(parts)
        assert first[0] == 0
        toc = self._resource(self.root / f'bundles.{first[2]:02d}.nxa', first[1])
        magic, types, count = struct.unpack_from('<III', toc)
        assert magic == 0xF0000011
        matches = []
        for i in range(count):
            entry = struct.unpack_from('<7Q6I', toc, 72 + 32 * types + 80 * i)
            if entry[:2] == (resource_id, resource_type):
                matches.append(entry)
        assert len(matches) == 1, 'Expected exactly one original resource'
        entry = matches[0]
        part = max(item for item in parts if item[0] <= entry[2])
        raw = self._resource(self.root / f'bundles.{part[2]:02d}.nxa', part[1] + entry[2] - part[0])
        assert len(raw) >= entry[7]
        return raw[:entry[7]], entry
