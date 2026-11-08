"""Validate integrated Light Rail UI resources against the installed game."""
from pathlib import Path
import hashlib, json, re, struct, zipfile
root=Path(__file__).resolve().parents[1]
source=root
mod=json.loads((source/'mod.json').read_text(encoding='utf-8'))
assert mod['modId']=='mrnickert_ultimate_metro' and mod['revision']==68
manifest=json.loads((source/'content/gui/build_manifest.json').read_text(encoding='utf-8'))
files=[p.relative_to(source).as_posix() for p in sorted((source/'content/gui').rglob('*')) if p.is_file()]
assert len(files)==13,files
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
window=(source/'content/gui/native_construction.lua').read_text(encoding='utf-8')
assert 'RegisterRecipe' not in bar and 'RegisterRecipe' not in window, 'Descriptors must not copy native UI'
assert manifest['integration']=='additive-native-recipes'
setup=(source/'content/gui/replacement.script.lua').read_text(encoding='utf-8')
assert 'replacementApi.ReplaceRecipe(' not in setup and '.GameBar,' not in setup
button=(source/'content/gui/additive_bar.lua').read_text(encoding='utf-8')
bridge=(source/'content/gui/ui_bridge.lua').read_text(encoding='utf-8')
construction=(source/'content/gui/additive_construction.lua').read_text(encoding='utf-8')
assert 'groupPrevious(' in button and 'buttonPrevious(...)' in button
assert "tab = 17" not in button and "tab=17" not in button
assert 'ulrConstructionOpenCategory' in button and 'findCategory(categories,request.categoryId)' in construction
assert 'react.useStateLazy=originalState' in construction and 'util.getMenuCategories=originalMenus' in construction
assert "menus.LIGHT_RAIL" in construction and 'M.appendCategory' in bridge
icon=(source/'content/gui/light_rail.tga').read_bytes()
w,h,depth=struct.unpack_from('<HHB',icon,12)
assert (w,h,depth)==(30,30,32) and len(icon)==18+w*h*4 and icon[17]==40
pixels=[tuple(icon[i:i+4]) for i in range(18,len(icon),4)]
assert all(pixel[:3]==(255,255,255) for pixel in pixels),'icon must be a tintable white mask'
assert any(p[3]==0 for p in pixels) and any(p[3]==255 for p in pixels),'transparent background and opaque symbol required'
assert all(pixels[y*w+x][3]==0 for y in range(h) for x in range(w) if x in (0,w-1) or y in (0,h-1)),'icon must fit inside its button'
assert hashlib.sha256((source/'artwork/light_rail_reference.png').read_bytes()).hexdigest()==manifest['iconSourceSha256']
print('PASS: additive native integration, scoped helpers, name-based routing, transparent icon and source provenance.')
