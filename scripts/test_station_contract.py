"""Compare complete generated station results against the pre-contract 0.14.2 build."""
from pathlib import Path
import argparse, hashlib, json, subprocess, tempfile, zipfile
root=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser()
p.add_argument('--record', action='store_true', help='Create the one-time baseline before any generator changes')
p.add_argument('--game', type=Path, default=Path(r'C:\Program Files (x86)\Steam\steamapps\common\Transport Fever 3'))
p.add_argument('--teal', default=r'C:\Program Files\Teal\0.24.8\tl.exe')
a=p.parse_args()
manifest=root/'tests/fixtures/stations-0.14.2.json'
with tempfile.TemporaryDirectory(prefix='ulr-contract-') as temp:
    temp=Path(temp)
    with zipfile.ZipFile(a.game/'base/content/scripts.zip') as archive:
        for name in ('laneutil','modulesutil','constructionutil'):
            (temp/(name+'.lua')).write_bytes(archive.read('scripts/construction/'+name+'.lua'))
    output=temp/'results';output.mkdir()
    subprocess.run([a.teal,'run','tests/test_underground.lua',str(temp),str(output)],cwd=root,check=True)
    actual={f.stem:hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted(output.glob('*.txt'))}
    assert len(actual)==72, 'Incomplete baseline coverage'
    if a.record:
        assert not manifest.exists(), 'Never overwrite an existing baseline to make tests pass'
        manifest.parent.mkdir(exist_ok=True)
        manifest.write_text(json.dumps({'sourceCommit':'d3ce898','version':'0.14.2','sha256':actual},indent=2)+'\n',encoding='utf-8')
        print('Recorded 72 complete station results from 0.14.2 before the contract refactor.')
    else:
        expected=json.loads(manifest.read_text(encoding='utf-8'))['sha256']
        changed=[k for k in sorted(expected.keys()|actual.keys()) if expected.get(k)!=actual.get(k)]
        assert not changed, 'Generated output changed: '+', '.join(changed)
        print('PASS: all 72 complete station results equal pre-contract 0.14.2 (60 combinations, 6 defaults, 6 legacy variants).')
