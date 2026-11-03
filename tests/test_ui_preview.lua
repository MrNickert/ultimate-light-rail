_ = function(key)return key end
local catalog=assert(loadfile("ui-preview/content/gui/catalog.lua"))()
local function def(name,year)
 return {resName=name,name=name,action="NATIVE_ACTION",availability={yearFrom=year or 0,yearTo=0},params={{key="unchanged"}}}
end
local depot1=def("::/depots/road/tram_depot/tram_depot.con",1900)
local depot2=def("::/depots/road/tram_depot/tram_depot.con",1940)
local depot3=def("::/depots/road/tram_depot/tram_depot.con",1980)
local station=def("mrnickert_ultimate_metro::/light_rail_station.con")
local example=def("ulr_contract_example::/kit_example.con")
local marked=def("future_author::/station.con")
local track=def("mrnickert_ultimate_metro::/lightrail_fenced.street_template")
local road=def("::/infrastructure/street/town/town_new_small.street_template")
local menus={ROAD={{{category="road_buildings"},{depot1,depot2,depot3,station,example}}},
 ROADS={{{category="roads_small"},{road,track}}},
 LIGHT_RAIL={{{category="ulr_stations"},{marked}}}}
local result=catalog.inject(menus)
assert(#result.LIGHT_RAIL==3)
assert(#result.LIGHT_RAIL[1][2]==3,"all native depot eras retained")
assert(#result.LIGHT_RAIL[2][2]==1 and result.LIGHT_RAIL[2][2][1].resName==track.resName)
assert(#result.LIGHT_RAIL[3][2]==3,"standard, known example and marker-based future station discovered")
assert(#result.ROAD[1][2]==3,"native depots still in normal menu")
assert(#result.ROADS[1][2]==1 and result.ROADS[1][2][1]==road,"our track leaves normal road menu")
assert(result.LIGHT_RAIL[2][2][1]~=track,"catalogue uses definition copies")
assert(result.LIGHT_RAIL[2][2][1].params==track.params and track.action=="NATIVE_ACTION","native builder data preserved")
catalog.inject(result)
assert(#result.LIGHT_RAIL[1][2]==3 and #result.LIGHT_RAIL[2][2]==1 and #result.LIGHT_RAIL[3][2]==3,"no duplication on repeat")
local files={"catalog.lua","replacement.res.lua","replacement.script.lua","stations_category.res.lua",
 "native_bar.lua","native_construction.lua","native_bar.css.lua","native_construction.css.lua"}
for _,file in ipairs(files) do assert(loadfile("ui-preview/content/gui/"..file),"generated Lua syntax: "..file) end
-- Verify that exactly the two intended public native recipes are replaced.
local calls={}
local baseBar={GameBar={tag="baseBar"}}
local previewBar={GameBar={tag="previewBar"}}
local baseWindow={tag="baseWindow"};local previewWindow={tag="previewWindow"}
local imports={
 ["::/gui/main/react.lua"]={},["::/gui/game_bar/game_bar.tl"]=baseBar,
 ["::/gui/construction/construction.tl"]=baseWindow,
 ["mrnickert_ulr_ui_preview::/gui/native_bar.lua"]=previewBar,
 ["mrnickert_ulr_ui_preview::/gui/native_construction.lua"]=previewWindow,
}
local env={ug_require=function(path)assert(imports[path],path);return imports[path]end}
local replacement=assert(loadfile("ui-preview/content/gui/replacement.script.lua","t",env))()
replacement.doReplaceFn({ReplaceRecipe=function(a,b)calls[#calls+1]={a,b}end})
assert(#calls==2 and calls[1][1]==baseBar.GameBar and calls[1][2]==previewBar.GameBar)
assert(calls[2][1]==baseWindow and calls[2][2]==previewWindow)
-- Execute both stylesheet data functions: animation registration is global,
-- so syntax checks alone cannot detect the duplicate-name crash.
local dummy
dummy=setmetatable({}, {__index=function()return dummy end,__call=function()return dummy end})
local registered={['appear-construction-list']=true,['info-callout-popup-pop']=true}
local animationCount=0
for _,kind in ipairs({'bar','construction'}) do
 local styles={}
 local env={api=dummy,_=function(key)return key end,require=function(path)
  if path:find('stylesheetutil',1,true) then
   return {makeAdder=function()return function(_,style)styles[#styles+1]=style end end}
  end
  return dummy
 end}
 assert(loadfile('ui-preview/content/gui/native_'..kind..'.css.lua','t',env))()
 local result=env.data()
 for name in pairs(result.animations or {}) do
  assert(not registered[name],'duplicate global animation: '..name)
  assert(name:find('ulr-ui-'..kind..'-',1,true)==1,'animation lacks preview namespace')
  registered[name]=true
  animationCount=animationCount+1
 end
 for _,style in ipairs(styles) do
  if style.animationName then assert(registered[style.animationName],'unresolved animation: '..style.animationName) end
 end
end
assert(animationCount==2,'expected both construction animations to be exercised')
print("PASS: UI catalogue, depot eras, discovery/filtering, repeat injection, generated Lua syntax, two-recipe replacement wiring and global animation registration. Engine UI rendering not tested.")
