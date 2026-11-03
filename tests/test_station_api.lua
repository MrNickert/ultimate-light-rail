return function(resource)
 local api=require "mrnickert_ultimate_metro::/station_api_v1.lua"
 local function equal(a,b,path)
  path=path or "result";assert(type(a)==type(b),path..": type differs")
  if type(a)~="table" then assert(a==b,path..": value differs");return end
  for k,v in pairs(a) do equal(v,b[k],path.."."..tostring(k)) end
  for k in pairs(b) do assert(a[k]~=nil,path..": extra key "..tostring(k)) end
 end
 local function copy(v)
  if type(v)~="table" then return v end
  local t={};for k,x in pairs(v) do t[k]=copy(x) end;return t
 end
 local placements={"surface","underground","elevated"}
 local kinds={"through","terminus"}
 local script=resource("light_rail_station.script.lua")
 for placement=1,3 do for kind=1,2 do for index,length in ipairs({40,60,80,100,120}) do for fence=1,2 do
  local spec={apiVersion=1,placement=placements[placement],stationType=kinds[kind],platformLength=length,platformTracks=2,fence=fence==2}
  local params={placement=placement,stationType=kind,platformLength=index,fence=fence,seed=42,crossover=1}
  local savedSpec,savedParams=copy(spec),copy(params)
  equal(api.buildStation(spec,{},params),script.updateFn({},params),"direct API equals standard station")
  equal(spec,savedSpec,"no specification mutation");equal(params,savedParams,"no save parameter mutation")
 end end end end
 local defaults=api.getDefaultDesign()
 defaults.assets.platformSurface="example_design::/platform.mdl"
 assert(api.getDefaultDesign().assets.platformSurface~="example_design::/platform.mdl","fresh default design")
 for _,placement in ipairs({"surface","elevated"}) do
  local spec={apiVersion=1,placement=placement,stationType="through",platformLength=80,fence=true}
  local baseline=api.buildStation(spec,{}, {seed=42})
  spec.design={apiVersion=1,id="example_design",assets={platformSurface="example_design::/platform.mdl"}}
  local original=copy(spec)
  local custom=api.buildStation(spec,{}, {seed=42})
  local replaced=0
  for _,sub in ipairs(custom.subconstructions) do for _,m in ipairs(sub.models) do
   if m.id=="example_design::/platform.mdl" then m.id=api.getDefaultDesign().assets.platformSurface;replaced=replaced+1 end
  end end
  assert(replaced>0,"custom design actually applied")
  equal(custom,baseline,"design changes only selected model identifiers")
  equal(spec,original,"no design mutation")
 end
 local valid={apiVersion=1,placement="surface",stationType="through",platformLength=80}
 local invalid={
  {apiVersion=2},{placement="space"},{stationType="loop"},{platformLength=70},
  {platformTracks=4},{fence=1},{crossover=true},{design=false},
  {design={apiVersion=2,id="x",assets={}}},
  {design={apiVersion=1,id="x",assets={typo="example::/x.mdl"}}},
  {design={apiVersion=1,id="x",assets={platformSurface="platform.mdl"}}},
  {design={apiVersion=1,id="x",assets={platformSurface="example::/../x.mdl"}}},
  {design={apiVersion=1,id="x",assets={},changePaths=function()end}},
 }
 for _,changes in ipairs(invalid) do
  local spec=copy(valid);for k,v in pairs(changes) do spec[k]=v end
  local ok,err=pcall(api.buildStation,spec,{}, {})
  assert(not ok and tostring(err):find("Ultimate Light Rail API v1:",1,true),"invalid contract must fail clearly")
 end
 -- Independent example uses its own .con/.script and model namespace.
 local env=setmetatable({},{__index=_G})
 assert(loadfile("examples/contract_station/content/example.script.lua","t",env))()
 local addon=env.data().updateFn({}, {seed=42})
 local base=api.buildStation(valid,{}, {seed=42})
 local count=0
 for _,sub in ipairs(addon.subconstructions) do for _,m in ipairs(sub.models) do
  if m.id=="ulr_contract_example::/example_platform.mdl" then
   m.id=api.getDefaultDesign().assets.platformSurface;count=count+1
  end
 end end
 assert(count>0,"separate add-on consumer used its own qualified model resource")
 equal(addon,base,"external example retains core layout")
 local modelEnv=setmetatable({},{__index=_G})
 assert(loadfile("examples/contract_station/content/example_platform.mdl","t",modelEnv))()
 equal(modelEnv.data(),resource("surface_platform.mdl"),"example wrapper obeys reference geometry")
 print("PASS: API v1 matches all 60 standard combinations; isolated visual overrides, fresh defaults, unchanged caller tables and explicit invalid-contract errors.")
end
