"""Package maker documentation, example sources and reference declarations only."""
from pathlib import Path
import json, zipfile
root=Path(__file__).resolve().parents[1]
assert json.loads((root/'mod.json').read_text(encoding='utf-8'))['revision']>=46
prefix='ultimate-light-rail-developer-kit-v1'
files={
 'docs/asset-kit-v1.md':'docs/asset-kit-v1.md',
 'docs/station-api-v1.md':'docs/station-api-v1.md',
 'reference/platform20.mdl':'content/platform20.mdl',
 'reference/platform_roof20.mdl':'content/platform_roof20.mdl',
 'reference/standard_kit.lua':'content/station_standard_kit.lua',
}
for path in (root/'examples/contract_station').rglob('*'):
    if path.is_file():
        assert path.suffix in ('.md','.json','.lua','.mdl')
        files['example/'+path.relative_to(root/'examples/contract_station').as_posix()]=path.relative_to(root).as_posix()
intro="""# Ultimate Light Rail maker kit — API v1 / core 0.17.2

This ZIP is developer material, not a game mod to activate directly.
Install Ultimate Light Rail revision 48 (0.17.2) separately.

1. Read docs/asset-kit-v1.md for the fixed layout and supported components.
2. Copy example/ to your own mod folder; change its mod ID, name and every own namespace reference. The supplied example ID is already used by our test mod.
3. Require core revision 46 in your own mod.json when using this current contract/placement helper or entrance bench variant. The historical example declares 45 because its original feature set also works there.
4. Supply only the parts you want to replace. Missing/default components use the real bundled kit; false removes optional parts.
5. Test placement, short/long platforms, stair clearance, boarding, switches and save/reload with both mods active.

reference/ contains original model declarations that reference the installed game's native resources. No native mesh or texture binary is included. The 20m reference wrappers internally halve native 40m visuals; an independently authored exact 20m model needs no internal halving. Fixed stair/end infills remain core-owned.

The existing example has been placed in-game and two variants were confirmed boarding and switching. The user also confirmed all three bundled 0.17.0 placements working and all lengths visually; operation at every length was not separately tested. The new 0.17.2 menu separators still need a visual in-game check. This is not a claim that all future assets fit automatically.
"""
out=root/'dist/ultimate-light-rail-developer-kit-v1-0.17.2.zip'
out.parent.mkdir(exist_ok=True)
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as archive:
    archive.writestr(prefix+'/README.md',intro)
    for target,source in sorted(files.items()):archive.write(root/source,prefix+'/'+target)
with zipfile.ZipFile(out) as archive:
    assert archive.testzip() is None
    assert len(archive.namelist())==len(files)+1
    assert not any(n.endswith(('.blob','.dds','.tga')) for n in archive.namelist())
print(out)
print('Developer kit verified: docs, complete example sources and original reference declarations; no native binary assets.')
