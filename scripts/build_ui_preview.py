"""Build a separate experimental GUI add-on from the installed native GUI sources.
No installed game files or stable-core runtime files are modified.
"""
from pathlib import Path, PurePosixPath
import argparse, hashlib, json, re, subprocess, tempfile, zipfile
root=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser()
p.add_argument('--game',type=Path,default=Path(r'C:\Program Files (x86)\Steam\steamapps\common\Transport Fever 3'))
p.add_argument('--teal',default=r'C:\Program Files\Teal\0.24.8\tl.exe')
a=p.parse_args()
preview=root/'ui-preview'
content=preview/'content/gui';content.mkdir(parents=True,exist_ok=True)
manifest={'coreTag':'v0.17.2-core-stable','nativeSources':{},'registeredRecipes':{}}
def replace_once(s,old,new):
    assert s.count(old)==1, f'Native GUI anchor changed: {old[:90]}'
    return s.replace(old,new,1)
def imports(s,native_path):
    def fix(m):
        ref=m[2]
        if '::' not in ref:
            if ref.startswith('/'):ref='::'+ref
            else:ref='::/'+str(PurePosixPath(native_path).parent/ref)
        return m[1]+'"'+ref+'"'
    s=re.sub(r'((?:ug_require|require)\s*\(?\s*)"([^"\n]+)"',fix,s)
    s=re.sub(r'"/([^"\n]+)"',r'"::/\1"',s)
    s=re.sub(r'"(gui/[^"\n]+\.(?:tga|gres))"',r'"::/\1"',s)
    return s
with zipfile.ZipFile(a.game/'base/content/gui.zip') as archive, tempfile.TemporaryDirectory(prefix='ulr-ui-build-') as temp:
    for kind,native in [('bar','gui/game_bar/game_bar.tl'),('construction','gui/construction/construction.tl')]:
        raw=archive.read(native)
        manifest['nativeSources'][native]=hashlib.sha256(raw).hexdigest()
        s=raw.decode('utf-8')
        if kind=='bar':
            start=s.index('local routesGroup :')
            position=s.index('\n\t\t{\n\t\t\tgameCtx = param.gameCtx,\n\t\t\ttoolVariant = "rail",',start)
            s=s[:position]+"""
        {
            gameCtx = param.gameCtx,
            toolVariant = "light_rail",
            id = "menu.construction.light_rail",
            iconPath = "mrnickert_ulr_ui_preview::/gui/light_rail.tga",
            tooltip = _("ULR_UI_MENU"),
            tab = 17,
            eventName = "openLightRail",
        },"""+s[position:]
        else:
            s=replace_once(s,'construction_react_util.getMenuCategories(params.repository)',
                'ulrCatalog.inject(construction_react_util.getMenuCategories(params.repository))')
            s='local ulrCatalog = ug_require "mrnickert_ulr_ui_preview::/gui/catalog.lua"\n'+s
            s=replace_once(s,'\taddCategoryNew("TRACKS")\n','\taddCategoryNew("TRACKS")\n\taddCategoryNew("LIGHT_RAIL")\n')
            # The stable native Construction tool owns the state/actions. Replace
            # only its window recipe, not the native tool registration itself.
            assert s.count('::/gui/construction/menu/category_bulldozer.tga')==2
            s=s.replace('::/gui/construction/menu/category_bulldozer.tga','::/gui/game_bar/icons/symbol_bulldozer_30.tga')
            cutoff=s.index('local makeToolWindowParam =')
            s=s[:cutoff]+'return construction.ConstructionListWindow\n'
            # The native module only exports its window recipe. Capture the
            # actual registered tool through the public ToolStack API when its
            # replacement window renders, rather than leaving a nil local tool.
            anchor='construction.ConstructionListWindow = react.RegisterWrapperRecipe("ConstructionListWindow",  builtin.Window, function(param : ConstructionToolWindowParam) : TreeNodeId\n'
            s=replace_once(s,anchor,anchor+"\tlocal nativeTool = getToolStackApi(param.payload.toolParam.gameCtx).getActiveTool()\n\tassert(nativeTool ~= nil and nativeTool.name == \"Construction\", \"ULR UI: expected active native Construction tool\")\n\tconstruction.ConstructionTool = nativeTool\n")
        names=re.findall(r'react.Register(?:Wrapper)?Recipe\("([^"\n]+)"',s)
        manifest['registeredRecipes'][kind]=names
        for name in names:
            s=s.replace('Recipe("'+name+'"','Recipe("ULR'+name+'"')
        s=imports(s,native)
        target=Path(temp)/(kind+'.tl');target.write_text(s,encoding='utf-8')
        output=content/('native_'+kind+'.lua')
        subprocess.run([a.teal,'gen',str(target),'-o',str(output)],cwd=root,check=True)
        generated=output.read_text(encoding='utf-8')
        output.write_text('-- Generated UI preview adapter. Source hashes are in build_manifest.json.\n'+generated,encoding='utf-8',newline='\n')
        css_path=native.removesuffix('.tl')+'.css.lua'
        css_raw=archive.read(css_path)
        manifest['nativeSources'][css_path]=hashlib.sha256(css_raw).hexdigest()
        css=imports(css_raw.decode('utf-8'),css_path)
        # Animation names are global across stylesheets, even when their
        # recipe selectors are scoped. Rename declarations and references.
        animation_names=re.findall(r'^\s*\["([^"\n]+)"\]\s*=\s*\{',css,re.M)
        for animation in animation_names:
            css=css.replace('"'+animation+'"','"ulr-ui-'+kind+'-'+animation+'"')
        manifest.setdefault('animations',{})[kind]=['ulr-ui-'+kind+'-'+name for name in animation_names]
        for name in sorted(names,key=len,reverse=True):
            css=re.sub(r'R::'+re.escape(name)+r'(?![A-Za-z0-9])','R::ULR'+name,css)
        # Emit styles only for preview recipes, leave original GUI selectors alone.
        old='local a = ssu.makeAdder(result)'
        replacement="""local addNative = ssu.makeAdder(result)
 local a = function(selector, style)
  for part in selector:gmatch("[^,]+") do
   if part:find("R::ULR",1,true) then addNative(part,style) end
  end
 end"""
        css=replace_once(css,old,replacement)
        (content/('native_'+kind+'.css.lua')).write_text('-- Generated preview-only recipe styles.\n'+css,encoding='utf-8',newline='\n')
manifest['iconSourceSha256']=hashlib.sha256((preview/'artwork/light_rail_icon.png').read_bytes()).hexdigest()
(preview/'build_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print('Generated UI adapters and preview-scoped styles; stable core untouched.')
