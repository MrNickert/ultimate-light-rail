"""Validate and package the current publication assets. No files are uploaded."""
from pathlib import Path
import hashlib, json, re, struct, zipfile
root=Path(__file__).resolve().parents[1]
pub=root/'publication'
fields=json.loads((pub/'modio-fields.json').read_text(encoding='utf-8'))
mod=json.loads((root/'mod.json').read_text(encoding='utf-8'))
info=json.loads((root/'_metadata/modinfo.json').read_text(encoding='utf-8'))
assert fields['modId']==mod['modId'] and fields['revision']==mod['revision']==70
assert fields['name']==info['name'] and fields['summary']==info['summary'] and len(info['summary'])<=100
assert fields['version']=='1.2.1' and info['url']==fields['homepage']
assert fields['tags']==info['tags']==['Script Mod','Tram','Road Station','Road Construction','Depot']
assert fields['galleryImages']==[f'_metadata/{n}.png' for n in range(1,5)]
md=(pub/'modio-description.md').read_text(encoding='utf-8')
web=(pub/'modio-description.html').read_text(encoding='utf-8')
assert 'backward compatible' in md and '1925' in md and 'approachFences' not in md
assert '<script' not in web and 'api-overview.png' in web
assert 'illustrative promotional artwork' in web
for image in re.findall(r'<img src="[^"]+/([^/" ]+)"',web): assert (pub/'media'/image).is_file(),image
native=(root/'_metadata/description.html').read_text(encoding='utf-8')
assert '<' not in native and len(native)<2000, 'Native copy stays concise and tag-free'
assert native==(pub/'modhub-description.html').read_text(encoding='utf-8')
provenance=json.loads((pub/'media-provenance.json').read_text(encoding='utf-8'))
for name in ['cover.png','api-overview.png','gameplay-elevated.png','gameplay-fenced-crossing.png']:
 data=(pub/'media'/name).read_bytes()
 assert hashlib.sha256(data).hexdigest()==provenance[name]['sha256'],name
for name in ['cover.png','api-overview.png']:
 data=(pub/'media'/name).read_bytes()
 assert data[:8]==b'\x89PNG\r\n\x1a\n' and struct.unpack_from('>II',data,16)==(1920,1080)
gallery={'0.png':'cover.png','1.png':'cover.png','2.png':'api-overview.png','3.png':'gameplay-elevated.png','4.png':'gameplay-fenced-crossing.png'}
assert {p.name for p in (root/'_metadata').glob('*.png')}==set(gallery)
for target,source in gallery.items(): assert (root/'_metadata'/target).read_bytes()==(pub/'media'/source).read_bytes()
assert (pub/'landing/index.html').is_file() and (pub/'modio-preview.html').is_file()
names=['ultimate-light-rail-1.2.1.zip','ultimate-light-rail-developer-kit-1.2.1.zip','ultimate-light-rail-contract-example-1.2.1.zip']
for name in names:
 with zipfile.ZipFile(root/'dist'/name) as z:
  assert z.testzip() is None
  if name==names[0]:
   for file in ['mod.json','_metadata/modinfo.json','_metadata/description.html',*[f'_metadata/{n}.png' for n in range(5)],'content/gui/native_construction.lua','content/passenger_crossing_util.lua']:
    assert z.read(mod['modId']+'/'+file)==(root/file).read_bytes(),'Rebuild the core package first: '+file
  if 'developer-kit' in name: assert any(n.endswith('/docs/compatibility.md') for n in z.namelist())
checksums=''.join(hashlib.sha256((root/'dist'/n).read_bytes()).hexdigest()+'  '+n+'\n' for n in names)
prefix='ultimate-light-rail-modio-upload-1.2.1/'
out=root/'dist/ultimate-light-rail-modio-upload-1.2.1.zip'
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as z:
 for p in sorted(pub.rglob('*')):
  if p.is_file() and 'downloads' not in p.relative_to(pub).parts: z.write(p,prefix+p.relative_to(pub).as_posix())
 for n in names:z.write(root/'dist'/n,prefix+'downloads/'+n)
 z.writestr(prefix+'downloads/SHA256SUMS.txt',checksums)
with zipfile.ZipFile(out) as z:assert z.testzip() is None
print(out)
print('PASS: revision 70, approved tags, selected artwork, source provenance, concise native copy, API promise and current download integrity. In-game validation remains a separate check.')
