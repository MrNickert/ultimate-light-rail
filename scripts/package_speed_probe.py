"""Build the optional, read-only speed helper independently of Ultimate Metro."""
from pathlib import Path
import json
import zipfile

root = Path(__file__).resolve().parents[1]
source = root / 'diagnostics/speed_probe'
mod_id = 'mrnickert_ultimate_metro_speed_probe'
metadata = {
    'mod.json': {'modId': mod_id, 'revision': 1, 'severityAdd': 'None', 'severityRemove': 'None', 'visible': True},
    '_metadata/modinfo.json': {
        'name': 'Ultimate Metro Speed Probe',
        'summary': 'Temporary read-only report of effective metro station and crossover speed limits.',
        'description': 'Enable alongside Ultimate Metro, load a save with existing metro stations and run five seconds. Writes one [UMSPEED] report to stdout.txt. Reads speedLimit and curveSpeedLimit from generated station and approach edges. Does not change stations, vehicles, resources or speed limits. Disable after diagnosis.',
        'authors': [{'name': 'MrNickert', 'role': 'CREATOR'}], 'tags': ['Script Mod'], 'url': ''},
}
payload = {name: (json.dumps(data, indent=4)+'\n').encode() for name, data in metadata.items()}
for file in sorted((source/'content').glob('*.lua')):
    data = file.read_bytes()
    text = data.decode('utf-8')
    assert 'api.cmd.' not in text and 'state:set' not in text and 'addModifier(' not in text
    payload['content/'+file.name] = data
assert len(payload) == 4
out = root/'dist/ultimate-metro-speed-probe-0.1.0.zip'
out.parent.mkdir(exist_ok=True)
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as archive:
    for name, data in payload.items(): archive.writestr(mod_id+'/'+name, data)
with zipfile.ZipFile(out) as archive: assert archive.testzip() is None
print(out)
print('4 files; separate optional helper, no world modifications or persisted state.')
