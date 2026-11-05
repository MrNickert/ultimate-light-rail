"""Compare complete generated station results against the pre-contract 0.14.2 build."""
from pathlib import Path
import argparse, hashlib, json, subprocess, tempfile, zipfile
root=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser()
p.add_argument('--record', action='store_true', help='Create the one-time baseline before any generator changes')
p.add_argument('--game', type=Path, default=Path(r'C:\Program Files (x86)\Steam\steamapps\common\Transport Fever 3'))
p.add_argument('--teal', default=r'C:\Program Files\Teal\0.24.8\tl.exe')
p.add_argument('--record-functional', action='store_true', help='One-time functional capture before 0.17 standard-kit migration')
a=p.parse_args()
manifest=root/'tests/fixtures/stations-0.14.2.json'
functional_manifest=root/'tests/fixtures/stations-functional-0.16.0.json'
with tempfile.TemporaryDirectory(prefix='ulr-contract-') as temp:
    temp=Path(temp)
    with zipfile.ZipFile(a.game/'base/content/scripts.zip') as archive:
        for name in ('laneutil','modulesutil','constructionutil'):
            (temp/(name+'.lua')).write_bytes(archive.read('scripts/construction/'+name+'.lua'))
    output=temp/'results';output.mkdir()
    subprocess.run([a.teal,'run','tests/test_underground.lua',str(temp),str(output)],cwd=root,check=True)
    def comparable(file):
        data=file.read_bytes()
        underground=file.stem.startswith('2-') or file.stem=='defaults-4' or file.stem.startswith('underground_terminus-')
        if underground:
            assert data.count(b'"maintenanceCost":30000,')==1, 'Unexpected underground maintenance: '+file.stem
            data=data.replace(b'"maintenanceCost":30000,',b'"maintenanceCost":180000,',1)
        return data
    actual={f.stem:hashlib.sha256(comparable(f)).hexdigest() for f in sorted(output.glob('*.txt'))}
    assert len(actual)==72, 'Incomplete baseline coverage'
    functional={f.stem:hashlib.sha256(comparable(f)).hexdigest() for f in sorted(output.glob('*.functional'))}
    assert len(functional)==72
    if a.record_functional:
        assert not functional_manifest.exists(), 'Never overwrite the functional baseline'
        functional_manifest.write_text(json.dumps({'sourceCommit':'da3fb3b','version':'0.16.0','excludes':'subconstructions[*].models only','sha256':functional},indent=2)+'\n',encoding='utf-8')
        print('Captured all 72 functional results before standard-kit migration.')
    if a.record:
        assert not manifest.exists(), 'Never overwrite an existing baseline to make tests pass'
        manifest.parent.mkdir(exist_ok=True)
        manifest.write_text(json.dumps({'sourceCommit':'d3ce898','version':'0.14.2','sha256':actual},indent=2)+'\n',encoding='utf-8')
        print('Recorded 72 complete station results from 0.14.2 before the contract refactor.')
    else:
        expected=json.loads(manifest.read_text(encoding='utf-8'))['sha256']
        # Standard surface/elevated presentation intentionally migrates to 20m.
        # Underground + legacy consumers still require complete old output parity.
        fixed={k:v for k,v in expected.items() if k.startswith('2-') or k=='defaults-4' or k.split('-')[0] in ('twin_terminus','through_station','underground_terminus')}
        assert len(fixed)==27
        changed=[k for k in sorted(fixed) if fixed[k]!=actual.get(k)]
        assert not changed, 'Fixed/legacy full output changed: '+', '.join(changed)
        expected_functional=json.loads(functional_manifest.read_text(encoding='utf-8'))['sha256']
        assert functional==expected_functional, 'Functional output changed: '+', '.join(k for k in expected_functional if functional.get(k)!=expected_functional[k])
        print('PASS: all 72 functional results equal 0.16.0; all 27 underground/legacy complete results equal 0.14.2. Only the approved underground maintenance change is normalized; its raw value is asserted at 30000. Standard presentation may use 20m modules.')
