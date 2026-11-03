"""Package the optional independent API consumer, separately from the core mod."""
from pathlib import Path
import json, zipfile
root=Path(__file__).resolve().parents[1]
source=root/'examples/contract_station'
mod=json.loads((source/'mod.json').read_text(encoding='utf-8'))
core=json.loads((root/'mod.json').read_text(encoding='utf-8'))
dep=mod['dependencies'][0]
assert dep['mod']['modId']==core['modId']
assert dep['mod']['revisionMin']==45 and core['revision']>=45
assert dep['loadBefore'] is True and dep['optional'] is False
files=['mod.json','content/example.con.lua','content/example.script.lua','content/example_platform.mdl','content/kit_example.con.lua','content/kit_example.script.lua','content/example_platform20.mdl','content/example_roof20.mdl','_metadata/modinfo.json']
assert {p.relative_to(source).as_posix() for p in (source/'content').glob('*')}=={name for name in files if name.startswith('content/')}
# The wrapper is our original visual declaration, not native binary content.
assert (source/'content/example_platform.mdl').read_bytes()==(root/'content/surface_platform.mdl').read_bytes()
assert (source/'content/example_platform20.mdl').read_bytes()==(root/'content/platform20.mdl').read_bytes()
assert (source/'content/example_roof20.mdl').read_bytes()==(root/'content/platform_roof20.mdl').read_bytes()
out=root/'dist/ultimate-light-rail-contract-example-0.2.0.zip'
out.parent.mkdir(exist_ok=True)
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as archive:
    for name in files:archive.write(source/name,mod['modId']+'/'+name)
with zipfile.ZipFile(out) as archive:
    assert archive.testzip() is None and len(archive.namelist())==len(files)
print(out)
print('Optional independent example packaged. In-game evidence and remaining limits are documented in its README.')
