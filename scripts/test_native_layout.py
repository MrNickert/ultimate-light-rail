"""Exercise native Lua construction helpers from the installed game, without shipping them."""
from pathlib import Path
import argparse
import re
import struct
import subprocess
import tempfile
import zipfile

parser = argparse.ArgumentParser()
parser.add_argument('--game', type=Path, default=Path(r'C:\Program Files (x86)\Steam\steamapps\common\Transport Fever 3'))
parser.add_argument('--teal', default=r'C:\Program Files\Teal\0.24.8\tl.exe')
args = parser.parse_args()
root = Path(__file__).resolve().parents[1]
# Validate native resources against the installed archives, without extracting assets.
content = args.game / 'base/content'
resources = set()
for package in content.rglob('*.zip'):
    prefix = package.parent.relative_to(content).as_posix()
    with zipfile.ZipFile(package) as archive:
        for name in archive.namelist():
            resources.add((prefix + '/' + name).removeprefix('./'))
for file in (root / 'content').rglob('*'):
    if file.suffix not in ('.lua', '.mdl'):
        continue
    for resource in re.findall(r'"::/([^"@]+)', file.read_text(encoding='utf-8')):
        candidates = (resource, resource + '.lua', resource + '.tl', resource.removesuffix('.tga') + '@2x.tga')
        assert any(candidate in resources for candidate in candidates), (file.name, resource)
for texture in (root / 'content/ui').glob('*.tga'):
    data = texture.read_bytes()
    width, height, depth = struct.unpack_from('<HHB', data, 12)
    assert (width, height) == ((720, 405) if '_preview' in texture.name else (120, 75))
    assert depth == 32 and len(data) == 18 + width * height * 4
    alpha = data[21::4]
    assert min(alpha) == 0 and max(alpha) == 255, (texture.name, 'requires real transparent background and opaque station')
    for x, y in ((0, 0), (width-1, 0), (0, height-1), (width-1, height-1)):
        assert alpha[y * width + x] == 0, (texture.name, 'opaque corner')
print('PASS: all native resource references exist; four UI textures have native dimensions and valid pixel payloads.', flush=True)
with tempfile.TemporaryDirectory(prefix='metro-native-test-') as temp:
    with zipfile.ZipFile(args.game / 'base/content/scripts.zip') as archive:
        for name in ('laneutil', 'modulesutil', 'constructionutil'):
            Path(temp, name + '.lua').write_bytes(archive.read('scripts/construction/' + name + '.lua'))
    subprocess.run([args.teal, 'run', 'tests/test_underground.lua', temp], cwd=root, check=True)
