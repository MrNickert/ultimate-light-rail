"""Package the current public developer kit, example sources and references."""
from pathlib import Path
import json, zipfile
root=Path(__file__).resolve().parents[1]
assert json.loads((root/'mod.json').read_text(encoding='utf-8'))['revision']==52
prefix='ultimate-light-rail-developer-kit-1.0.0'
files={
 'README.md':'docs/developer-kit-readme.md',
 'docs/asset-kit-v1.md':'docs/asset-kit-v1.md',
 'docs/station-api-v1.md':'docs/station-api-v1.md',
 'docs/compatibility.md':'docs/compatibility.md',
 'docs/validation-notes.md':'docs/validation-notes.md',
 'reference/platform20.mdl':'content/platform20.mdl',
 'reference/platform_roof20.mdl':'content/platform_roof20.mdl',
 'reference/standard_kit.lua':'content/station_standard_kit.lua',
 'reference/station_menu.lua':'content/station_menu.lua',
 'reference/api-presentation-snippets.lua':'publication/api-presentation-snippets.lua',
 'docs/station-api-overview.png':'publication/media/api-overview.png',
 'docs/component-kit-in-game.png':'publication/media/api-components.png',
 'docs/api-integration-reference.png':'publication/media/api-contract.png',
}
for path in (root/'examples/contract_station').rglob('*'):
    if path.is_file():
        assert path.suffix in ('.md','.json','.lua','.mdl')
        files['example/'+path.relative_to(root/'examples/contract_station').as_posix()]=path.relative_to(root).as_posix()
out=root/'dist/ultimate-light-rail-developer-kit-1.0.0.zip'
out.parent.mkdir(exist_ok=True)
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as archive:
    for target,source in sorted(files.items()):archive.write(root/source,prefix+'/'+target)
with zipfile.ZipFile(out) as archive:
    assert archive.testzip() is None and len(archive.namelist())==len(files)
    assert not any(n.endswith(('.blob','.dds','.tga')) for n in archive.namelist())
    for name in ['README.md','docs/asset-kit-v1.md','docs/station-api-v1.md','docs/compatibility.md','example/README.md']:
        text=archive.read(prefix+'/'+name).decode('utf-8')
        assert '0.17.' not in text and 'UI Preview' not in text
        assert 'backward compatible' in text and 'new API version' in text
print(out)
print('Developer kit verified: current API v1 documentation, complete example and reference declarations; no native binaries.')
