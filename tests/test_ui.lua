_ = function(key)return key end
local catalog=assert(loadfile("content/gui/catalog.lua"))()
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
local menus={ROAD={{{category="road_buildings"},{depot1,depot2,depot3}}},
 ROADS={{{category="roads_small"},{road,track}}},
 LIGHT_RAIL={{{category="ulr_stations"},{station,example,marked}}}}
local result=catalog.inject(menus)
assert(#result.LIGHT_RAIL==1,"single combined category: no depot/track/station tabs")
local all=result.LIGHT_RAIL[1][2]
assert(#all==7,"all depot eras, track, standard/example/future stations retained")
assert(all[1].availability.yearFrom==1900 and all[2].availability.yearFrom==1940 and all[3].availability.yearFrom==1980)
assert(all[4].resName==track.resName)
assert(#result.ROAD[1][2]==3,"native depots still in normal menu")
assert(#result.ROADS[1][2]==1 and result.ROADS[1][2][1]==road,"our track leaves normal road menu")
assert(all[4]~=track,"catalogue uses definition copies")
assert(all[4].params==track.params and track.action=="NATIVE_ACTION","native builder data preserved")
catalog.inject(result)
assert(#result.LIGHT_RAIL==1 and #result.LIGHT_RAIL[1][2]==7,"no duplication or loss on repeat, including third-party stations")
local menu=assert(loadfile("content/station_menu.lua"))()
local first=menu.getMenuCategory(123)
local second=menu.getMenuCategory()
assert(first.categories[1].category=="ulr_stations" and first.categories[1].order==123)
assert(second.categories[1].order==1000 and first~=second and first.categories~=second.categories)
for _,bad in ipairs({-1,0.5,"100",math.huge}) do assert(not pcall(menu.getMenuCategory,bad)) end
local trackEnv={_=function(key)return key end}
assert(loadfile("content/lightrail_fenced.street_template.lua","t",trackEnv))()
local trackAvailability=trackEnv.data().availability
assert(trackAvailability.yearFrom==1925 and trackAvailability.yearTo==0)
for _,path in ipairs({"content/light_rail_station.con.lua",
 "examples/contract_station/content/example.con.lua",
 "examples/contract_station/content/kit_example.con.lua"}) do
 local descriptionEnv={_=function(key)return key end,require=function(name)
  if path=="content/light_rail_station.con.lua" and name=="mrnickert_ultimate_metro::/underground_levels.lua" then
   return assert(loadfile("content/underground_levels.lua","t",{type=type}))()
  end
  assert(name=="mrnickert_ultimate_metro::/station_menu.lua","construction must use lightweight menu helper")
  return menu
 end}
 assert(loadfile(path,"t",descriptionEnv))()
 local description=descriptionEnv.data()
 assert(description.menuCategory.categories[1].category=="ulr_stations",path)
 assert(description.availability.yearFrom==trackAvailability.yearFrom and description.availability.yearTo==trackAvailability.yearTo,"station availability must match modern tram track: "..path)
end
local files={"catalog.lua","ui_bridge.lua","additive_bar.lua","additive_construction.lua","additive_line_filter.lua","replacement.res.lua","replacement.script.lua","stations_category.res.lua","native_bar.lua","native_construction.lua","native_bar.css.lua","native_construction.css.lua"}
for _,file in ipairs(files)do assert(loadfile('content/gui/'..file),file)end
local calls={}
local env={pcall=pcall,tostring=tostring,log={message=function()end,warning=function()end},ug_require=function(path)
 assert(path=='mrnickert_ultimate_metro::/gui/additive_bar.lua' or path=='mrnickert_ultimate_metro::/gui/additive_construction.lua'
  or path=='mrnickert_ultimate_metro::/gui/additive_line_filter.lua')
 return {install=function()calls[#calls+1]=path;return true end}
end}
assert(loadfile('content/gui/replacement.script.lua','t',env))()
assert(#calls==0,'UI setup must be deferred until the engine setup callback')
env.data().doReplaceFn({ReplaceRecipe=function()error('Whole native recipes must not be replaced')end})
assert(#calls==3 and calls[3]=='mrnickert_ultimate_metro::/gui/additive_line_filter.lua')
dofile('tests/test_additive_ui.lua')
print('PASS: catalogue, availability, generated syntax and additive UI integration. Engine rendering still requires in-game testing.')
