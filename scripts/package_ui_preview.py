"""Validate and package only the experimental UI add-on, not the core."""
from pathlib import Path
import hashlib, json, re, struct, zipfile
root=Path(__file__).resolve().parents[1]
source=root/'ui-preview'
mod=json.loads((source/'mod.json').read_text(encoding='utf-8'))
assert mod['modId']=='mrnickert_ulr_ui_preview' and mod['cosmetic'] is True
assert mod['severityRemove']=='None'
dep=mod['dependencies'][0]
assert dep['mod']['modId']=='mrnickert_ultimate_metro' and dep['mod']['revisionMin']==48 and dep['optional'] is False
manifest=json.loads((source/'build_manifest.json').read_text(encoding='utf-8'))
files=['mod.json','strings.json','_metadata/modinfo.json','README.md','build_manifest.json']
files += [p.relative_to(source).as_posix() for p in sorted((source/'content').rglob('*')) if p.is_file()]
assert len(files)==14, files
native=set()
game=Path(r'C:\Program Files (x86)\Steam\steamapps\common\Transport Fever 3/base/content')
for archive_path in game.rglob('*.zip'):
    prefix=archive_path.parent.relative_to(game).as_posix()
    with zipfile.ZipFile(archive_path) as archive:
        native.update((prefix+'/'+n).removeprefix('./') for n in archive.namelist())
for name in files:
    data=(source/name).read_bytes();assert not data.startswith(b'\xef\xbb\xbf')
    if name.endswith('.lua'):
        text=data.decode('utf-8')
        for resource in re.findall(r'["\']::/([^"\'\n]+)["\']',text):
            # Only literal file references, not UI selector/event strings.
            if resource.endswith(('.lua','.tl','.tga','.gres','.wav')):
                assert resource in native or resource.removesuffix('.tga')+'@2x.tga' in native or resource+'.lua' in native,(name,resource)
        for recipe in re.findall(r'react.Register(?:Wrapper)?Recipe\(\s*"([^"\n]+)"',text):
            if name.startswith('content/gui/native_'):assert recipe.startswith('ULR'),recipe
        if name.startswith('content/gui/native_'):assert 'react.RegisterTool' not in text
        assert not re.search(r'["\']/[^"\'\n]+\.(?:lua|tl|tga|gres)["\']',text),'unqualified native path'
bar=(source/'content/gui/native_bar.lua').read_text(encoding='utf-8')
assert bar.index('toolVariant = "road"')<bar.index('toolVariant = "light_rail"')<bar.index('toolVariant = "rail"')
assert re.search(r'toolVariant = "light_rail"[\s\S]{0,350}tab = 17',bar)
window=(source/'content/gui/native_construction.lua').read_text(encoding='utf-8')
assert window.index('addCategoryNew("TRACKS")')<window.index('addCategoryNew("LIGHT_RAIL")')
assert 'ulrCatalog.inject(construction_react_util.getMenuCategories(params.repository))' in window
assert 'construction.ConstructionTool = nativeTool' in window and 'getActiveTool()' in window
icon=(source/'content/gui/light_rail.tga').read_bytes()
w,h,depth=struct.unpack_from('<HHB',icon,12)
assert (w,h,depth)==(342,227,32) and len(icon)==18+w*h*4 and icon[17]==40
assert hashlib.sha256((source/'artwork/light_rail_icon.png').read_bytes()).hexdigest()==manifest['iconSourceSha256']
out=root/'dist/ultimate-light-rail-ui-preview-0.1.0.zip';out.parent.mkdir(exist_ok=True)
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as archive:
    for name in files:archive.write(source/name,mod['modId']+'/'+name)
with zipfile.ZipFile(out) as archive:assert archive.testzip() is None and len(archive.namelist())==len(files)
print(out)
print(f'{len(files)} files; native references, unique preview recipes, tab order, icon format and ZIP checked. Engine UI unverified.')
