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
    if file.suffix not in ('.lua', '.mdl', '.msh'):
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
# Original decal mesh: validate float/index buffers, upward winding and safe UVs.
blob = (root / 'content/tram_ribbon.msh.blob').read_bytes()
assert len(blob) == 288
positions = [struct.unpack_from('<3f', blob, i * 12) for i in range(4)]
assert all(point[2] == 0 for point in positions)
for offset in (192, 216, 240, 264):
    assert all(index < 4 for index in struct.unpack_from('<6I', blob, offset))
a, b, c = positions[:3]
assert (b[0]-a[0])*(c[1]-a[1])-(b[1]-a[1])*(c[0]-a[0]) > 0
assert 1.88 < positions[2][1]-positions[1][1] < 1.89
print('PASS: native resource references, transparent UI textures and original tram-ribbon vertex/index buffers.', flush=True)
with tempfile.TemporaryDirectory(prefix='metro-native-test-') as temp:
    with zipfile.ZipFile(content / 'infrastructure/street.zip') as archive:
        native_tram = Path(temp, 'native_tram.lua')
        native_tram.write_bytes(archive.read('street/tram/tram_new.street_template.lua'))
    subprocess.run([args.teal, 'run', 'tests/test_fenced_track.lua', str(native_tram)], cwd=root, check=True)
    with zipfile.ZipFile(args.game / 'base/content/scripts.zip') as archive:
        for name in ('laneutil', 'modulesutil', 'constructionutil'):
            Path(temp, name + '.lua').write_bytes(archive.read('scripts/construction/' + name + '.lua'))
    with zipfile.ZipFile(content / 'infrastructure/bridge.zip') as archive:
        for name in ('c_6_rep_rep', 'c_pillar_small_bot_m'):
            Path(temp, name + '.mdl').write_bytes(archive.read('bridge/concrete/' + name + '.mdl'))
    subprocess.run([args.teal, 'run', 'tests/test_underground.lua', temp], cwd=root, check=True)
