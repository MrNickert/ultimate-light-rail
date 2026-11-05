"""Generate checked native recipe layout descriptors, not copies of native UI."""
from pathlib import Path
import argparse, hashlib, json, re, zipfile
root=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser()
p.add_argument('--game',type=Path,default=Path(r'C:\Program Files (x86)\Steam\steamapps\common\Transport Fever 3'))
a=p.parse_args()
content=root/'content/gui'
manifest={'version':'1.0.0','integration':'additive-native-recipes','nativeSources':{},'registeredRecipes':{'bar':[],'construction':[]},'animations':{'bar':[],'construction':[]}}
with zipfile.ZipFile(a.game/'base/content/gui.zip') as archive:
 for kind,path in [('bar','gui/game_bar/game_bar.tl'),('construction','gui/construction/construction.tl')]:
  raw=archive.read(path);s=raw.decode('utf-8');manifest['nativeSources'][path]=hashlib.sha256(raw).hexdigest()
  names=re.findall(r'react.Register(?:Wrapper)?Recipe\("([^"\n]+)"',s)
  if kind=='bar':
   first=names.index('MainRadialMenu')
   layout={'anchorSpan':names.index('GameBar')-first,'groupOffset':names.index('ConstructionToolButtonGroup')-first,'buttonOffset':names.index('ConstructionToolButton')-first}
  else:
   assert re.search(r'local categories[^\n]*react.useStateLazy',s) and 'construction_react_util.getMenuCategories(params.repository)' in s
   assert s.count('react.onEvent("constructionMenuSetTab",')==2
   layout={'contentOffset':names.index('ConstructionListContent')-names.index('ConstructionListWindow')}
  manifest[kind+'Layout']=layout
  (content/('native_'+kind+'.lua')).write_text('-- Checked native recipe layout only. No copied UI recipes.\nreturn {'+', '.join(k+'='+str(v) for k,v in layout.items())+'}\n',encoding='utf-8')
  (content/('native_'+kind+'.css.lua')).write_text('-- Native UI styles remain in use.\nfunction data()return {}end\n',encoding='utf-8')
manifest['iconSourceSha256']=hashlib.sha256((root/'artwork/light_rail_reference.png').read_bytes()).hexdigest()
(content/'build_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print('Generated additive integration descriptors; native GameBar and ConstructionListWindow are retained.')
