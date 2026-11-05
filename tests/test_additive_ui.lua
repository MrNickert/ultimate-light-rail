-- These are real adapter calls, including the installed foreign wrapper when present.
local bridge=assert(loadfile('content/gui/ui_bridge.lua'))()
local source={buttonData={{id='menu.construction.road',gameCtx={}},{id='foreign.button'},{id='menu.construction.rail',gameCtx={}}},foreignOption={}}
local changed,added=bridge.addButton(source)
assert(added and #changed.buttonData==4 and #source.buttonData==3)
assert(changed.buttonData[3].id=='menu.construction.light_rail' and changed.buttonData[3].tab==nil)
assert(changed.foreignOption==source.foreignOption and changed.buttonData[2]==source.buttonData[2])
local unchanged,again=bridge.addButton(changed);assert(unchanged==changed and not again)
assert(bridge.findCategory({{id='foreign'},{id='light_rail'}},'light_rail')==2)
assert(bridge.findCategory({{id='light_rail'},{id='light_rail'}},'light_rail')==nil)
local function node(kind,...)
 local args=table.pack(...);local p=args[args.n] or {};p.kind=kind;return p
end
local function treeCount(tree,id)
 if type(tree)~='table'then return 0 end
 local count=tree.meta and tree.meta.id==id and 1 or 0
 for _,v in ipairs(tree.children or {})do count=count+treeCount(v,id)end
 if tree.content then count=count+treeCount(tree.content,id)end
 if tree.layout then count=count+treeCount(tree.layout,id)end
 return count
end
local undoPath='C:/Users/Public/mod.io/10640/mods/6432516/content/undo/undo_ui.script.lua'
local function runBarTest(order)
 local base={MainRadialMenu=function()end,GameBar=function()end}
 local registry={originalRecipeFn={},recipeReplace={}}
 local ids={[base.MainRadialMenu]=100,[base.GameBar]=115}
 local events={}
 local react={GetRecipeId=function(fn)return ids[fn]end,GetRecipeName=function()return 'previous wrapper'end,
 RegisterRecipe=function(_,fn)return function(...)local args=table.pack(...);if args.n>1 and type(args[1])=='table'and args[1].reference then return fn(table.unpack(args,2,args.n))end;return fn(...)end end,RegisterPluginRecipe=function(_,_,fn)return fn end,
 useNodeRef=function()return {get=function()end}end,ref=function(value)return {reference=value}end,
 useInputAction=function()end,iaForward=function()return function()end end,
 useState=function(value)return {old=function()return value end,set=function()end}end,
 onEvent=function(name,fn)events[name]=fn end,onStep=function()end,
 fireEvent=function()end}
 local builtin={type={Orientation={Horizontal=1},ImageViewScaling={AutoFit=1}}}
 for _,k in ipairs({'BoxLayout','ToolButton','Button','ImageView','Component','TextView'})do builtin[k]=function(...)return node(k,...)end end
 registry.originalRecipeFn[108]=function(...)
  local args=table.pack(...);local param=args[args.n]
  return {meta={id=param.id},reference=args[1]}
 end
 registry.originalRecipeFn[109]=function(...)
  local args=table.pack(...);local param=args[args.n];local children={}
  for _,b in ipairs(param.buttonData)do
   local ref={reference='original-button-reference'}
   local child=(registry.recipeReplace[108]or registry.originalRecipeFn[108])(ref,b)
   if b.id~='menu.construction.light_rail'then assert(child.reference==ref,'Native references must pass through unchanged')end
   children[#children+1]=child
  end
  return {children=children}
 end
 local imports={['::/gui/main/react.lua']=react,['::/gui/main/builtin.lua']=builtin,
 ['::/gui/game_bar/game_bar.tl']=base,
 ['mrnickert_ultimate_metro::/gui/native_bar.lua']=assert(loadfile('content/gui/native_bar.lua'))(),
 ['mrnickert_ultimate_metro::/gui/ui_bridge.lua']=bridge,
 ['::/gui/main/styleutil.tl']={makeStyle=function()return {}end},
 ['undo_tf3_test::/undo/locale.script.lua']={text=function(v)return v end},
 ['undo_tf3_test::/undo/bridge_ui_fix.script.lua']={install=function()end},
 ['::/gui/main/main_mod_button_area.tl']={MainModButtonAreaExtension={}}}
 local env=setmetatable({_react=registry,ug_require=function(path)assert(imports[path],path);return imports[path]end,
 api={gui={byId={setVisible=function()end},fireReactEvent=function()end},type={Vec4f={new=function()return {}end},Vec2i={new=function()return {}end}}}}, {__index=_G})
 local additive=assert(loadfile('content/gui/additive_bar.lua','t',env))()
 local function installForeign()
  if order=='generic' then
   local previous=registry.recipeReplace[109]or registry.originalRecipeFn[109]
   registry.recipeReplace[109]=function(...)return {children={previous(...),{meta={id='foreign-preserved'}}}}end
  else
   local foreign=assert(loadfile(undoPath,'t',env))();foreign.doReplace({})
  end
 end
 if order=='before'then assert(additive.install());installForeign()else installForeign();assert(additive.install())end
 local hook=registry.recipeReplace[109];assert(additive.install() and registry.recipeReplace[109]==hook,'Repeated setup must be idempotent')
 local routes=registry.recipeReplace[109]({buttonData={{id='menu.construction.road',gameCtx={}},{id='menu.construction.rail',gameCtx={}}}})
 assert(treeCount(routes,'menu.construction.light_rail')==1)
 assert(treeCount(routes,'menu.construction.road')==1 and treeCount(routes,'menu.construction.rail')==1)
 if order=='generic'then assert(treeCount(routes,'foreign-preserved')==1)else
  local bulldozer=registry.recipeReplace[109]({buttonData={{id='menu.bulldozer'}}})
  for _,id in ipairs({'undo','redo','clear'})do assert(treeCount(bulldozer,'undo-tf3-button-'..id)==1,'Foreign Undo controls must remain visible')end
 end
 assert(registry.recipeReplace[115]==nil,'GameBar itself must remain untouched')
end
runBarTest('generic')
local f=io.open(undoPath,'r')
if f then f:close();runBarTest('before');runBarTest('after');print('PASS: installed Undo wrapper + additive Light Rail, both setup orders, including Undo/Redo/Clear and native reference forwarding')
else print('SKIP: optional installed Undo integration fixture unavailable')end
-- The construction callback and helpers remain native, including foreign additions.
local window=function()end
local events={};local fired
local originalMenus={ROAD={{{category='native'},{{resName='native-road'}}}},ROADS={{{category='tracks'},{{resName='mrnickert_ultimate_metro::/lightrail_fenced.street_template'}}}},LIGHT_RAIL={{{category='ulr_stations'},{{resName='mrnickert_ultimate_metro::/light_rail_station.con'}}}}}
local getMenus=function()return originalMenus end
local util={getMenuCategories=getMenus}
local nativeState=function(generate)local value=generate();return {old=function()return value end}end
local react={GetRecipeId=function(value)assert(value==window);return 300 end,useStateLazy=nativeState,
 onEvent=function(name,fn)events[name]=fn end,fireEvent=function(_,name,p)fired={name=name,params=p}end}
local category=function(id)return {id=id,getSublists=function()return {}end}end
local registry={recipes={},recipeReplace={}}
local priorCalls=0
registry.recipes[299]=function(ctx)
 priorCalls=priorCalls+1
 react.useStateLazy(function()return false end)
 ctx.categories=react.useStateLazy(function()
  util.getMenuCategories({})
  return {category('road'),category('rail'),{id='module-bulldozer',definition={}},category('foreign-category')}
 end):old()
 if ctx.fail then error('intentional foreign callback failure')end
 ctx.foreignDecoration='preserved'
 return 'native-result',nil,23
end
local env=setmetatable({_react=registry,ug_require=function(path)
 if path=='::/gui/main/react.lua'then return react end
 if path=='::/gui/construction/construction_react_util.tl'then return util end
 if path=='::/gui/construction/construction.tl'then return window end
 if path=='mrnickert_ultimate_metro::/gui/native_construction.lua'then return assert(loadfile('content/gui/native_construction.lua'))()end
 if path=='mrnickert_ultimate_metro::/gui/ui_bridge.lua'then return bridge end
 if path=='mrnickert_ultimate_metro::/gui/catalog.lua'then return assert(loadfile('content/gui/catalog.lua'))()end
 error(path)
end},{__index=_G})
local adapter=assert(loadfile('content/gui/additive_construction.lua','t',env))();assert(adapter.install())
local ctx={};local a,b,c=registry.recipes[299](ctx)
assert(a=='native-result'and b==nil and c==23 and ctx.foreignDecoration=='preserved')
assert(priorCalls==1 and #ctx.categories==5 and ctx.categories[4].id=='foreign-category')
assert(originalMenus.ROADS[1][2][1].resName=='mrnickert_ultimate_metro::/lightrail_fenced.street_template','Foreign/native source catalogue must not be mutated')
assert(react.useStateLazy==nativeState and util.getMenuCategories==getMenus,'Temporary helpers must be restored')
events.ulrConstructionOpenCategory(nil,{categoryId='light_rail'})
assert(fired.name=='constructionMenuSetTab'and fired.params.tabIndex==5)
table.insert(ctx.categories,1,category('another-foreign-category'))
events.ulrConstructionOpenCategory(nil,{categoryId='light_rail'})
assert(fired.params.tabIndex==6,'Named routing must follow category insertion by other mods')
assert(not pcall(registry.recipes[299],{fail=true}))
assert(react.useStateLazy==nativeState and util.getMenuCategories==getMenus,'Restore helpers after errors too')
assert(registry.recipeReplace[300]==nil,'ConstructionListWindow itself must remain untouched')
print('PASS: native construction callback preserved, foreign category retained, name-based routing, catalogue isolation and helper restoration after success/error')
