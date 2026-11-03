"""Package the optional independent API consumer, separately from the core mod."""
from pathlib import Path
import json, zipfile
root=Path(__file__).resolve().parents[1]
source=root/'examples/contract_station'
mod=json.loads((source/'mod.json').read_text(encoding='utf-8'))
core=json.loads((root/'mod.json').read_text(encoding='utf-8'))
dep=mod['dependencies'][0]
assert dep['mod']['modId']==core['modId']
assert dep['mod']['revisionMin']==44 and core['revision']>=44
assert dep['loadBefore'] is True and dep['optional'] is False
files=['mod.json','content/example.con.lua','content/example.script.lua','content/example_platform.mdl']
assert {p.relative_to(source).as_posix() for p in (source/'content').glob('*')}==set(files[1:])
# The wrapper is our original visual declaration, not native binary content.
assert (source/files[-1]).read_bytes()==(root/'content/surface_platform.mdl').read_bytes()
out=root/'dist/ultimate-light-rail-contract-example-0.1.0.zip'
out.parent.mkdir(exist_ok=True)
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as archive:
    for name in files:archive.write(source/name,mod['modId']+'/'+name)
with zipfile.ZipFile(out) as archive:
    assert archive.testzip() is None and len(archive.namelist())==4
print(out)
print('Optional independent example packaged; actual two-mod engine loading remains unverified.')
