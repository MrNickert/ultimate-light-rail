"""Package local upload materials; does not upload or publish anything."""
from pathlib import Path
import base64,hashlib,json,struct,zipfile,xml.etree.ElementTree as ET
root=Path(__file__).resolve().parents[1]
pub=root/'publication'
fields=json.loads((pub/'modio-fields.json').read_text(encoding='utf-8'))
mod=json.loads((root/'mod.json').read_text(encoding='utf-8'))
info=json.loads((root/'_metadata/modinfo.json').read_text(encoding='utf-8'))
assert fields['modId']==mod['modId'] and fields['revision']==mod['revision']
assert fields['name']==info['name'] and fields['summary']==info['summary'] and len(fields['summary'])<=100
assert fields['version']=='1.0.0'
assert info['url']==fields['homepage'] and 'Available from 1925' in info['description']
md=(pub/'modio-description.md').read_text(encoding='utf-8')
assert 'approachFences' not in md and 'backward compatible' in md and '1925' in md
provenance=json.loads((pub/'media-provenance.json').read_text(encoding='utf-8'))
original=(pub/'media/gameplay-elevated.png').read_bytes()
for filename in ['gameplay-elevated.png','gameplay-fenced-crossing.png']:
    assert hashlib.sha256((pub/'media'/filename).read_bytes()).hexdigest()==provenance[filename]['sha256']
svg=ET.parse(pub/'media/cover-layout.svg').getroot()
assert svg.attrib['width']=='1920' and svg.attrib['height']=='1080'
embedded=svg.find('{http://www.w3.org/2000/svg}image').attrib['href']
assert base64.b64decode(embedded.split(',',1)[1])==original,'gameplay source must be preserved'
for metadata,source in [('0.png','cover.png'),('1.png','gameplay-elevated.png'),('2.png','gameplay-fenced-crossing.png')]:
    assert (root/'_metadata'/metadata).read_bytes()==(pub/'media'/source).read_bytes()
assert struct.unpack_from('>II',(root/'_metadata/0.png').read_bytes(),16)==(1920,1080)
assert (root/'_metadata/description.html').read_bytes()==(pub/'modhub-description.html').read_bytes()
for metadata,source in [('3.png','api-components.png'),('4.png','api-contract.png'),('5.png','gameplay-elevated-daylight.png'),('6.png','gameplay-station-variants.png')]:
    assert (root/'_metadata'/metadata).read_bytes()==(pub/'media'/source).read_bytes()
for name in ['api-components.png','api-contract.png']:
    assert struct.unpack_from('>II',(pub/'media'/name).read_bytes(),16)==(1920,1080)
assert (pub/'landing/index.html').exists() and (pub/'modio-preview.html').exists()
assert '<script' not in (pub/'modio-description.html').read_text(encoding='utf-8')
names=['ultimate-light-rail-1.0.0.zip','ultimate-light-rail-developer-kit-1.0.0.zip','ultimate-light-rail-contract-example-1.0.0.zip']
for name in names:
    with zipfile.ZipFile(root/'dist'/name) as z:
        assert z.testzip() is None
        if name==names[0]:
            for file in ['mod.json','_metadata/modinfo.json',*[f'_metadata/{n}.png' for n in range(7)],'_metadata/description.html']:
                assert z.read(mod['modId']+'/'+file)==(root/file).read_bytes(),'rebuild core before packaging upload material'
        if 'developer-kit' in name:assert any(n.endswith('/docs/compatibility.md') for n in z.namelist())
checksums=''.join(hashlib.sha256((root/'dist'/n).read_bytes()).hexdigest()+'  '+n+'\n' for n in names)
prefix='ultimate-light-rail-modio-upload-1.0.0/'
out=root/'dist/ultimate-light-rail-modio-upload-1.0.0.zip'
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as z:
    for p in sorted(pub.rglob('*')):
        if p.is_file() and 'downloads' not in p.relative_to(pub).parts:z.write(p,prefix+p.relative_to(pub).as_posix())
    for n in names:z.write(root/'dist'/n,prefix+'downloads/'+n)
    z.writestr(prefix+'downloads/SHA256SUMS.txt',checksums)
with zipfile.ZipFile(out) as z:assert z.testzip() is None
print(out)
print('PASS: copy-ready metadata, current core ZIP, API policy, original gameplay sources, packaged cover/gallery/HTML and upload-bundle integrity. In-game validation and the year check remain pending.')
