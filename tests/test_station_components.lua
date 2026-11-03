return function(resource)
 local api=require "mrnickert_ultimate_metro::/station_api_v1.lua"
 local function copy(v)
  if type(v)~="table" then return v end
  local r={};for k,x in pairs(v) do r[k]=copy(x) end;return r
 end
 local function equal(a,b,path)
  path=path or "result";assert(type(a)==type(b),path..": type")
  if type(a)~="table" then assert(a==b,path..": value");return end
  for k,v in pairs(a) do equal(v,b[k],path.."."..tostring(k)) end
  for k in pairs(b) do assert(a[k]~=nil,path..": extra key") end
 end
 local function functional(result)
  local r=copy(result);for _,sub in ipairs(r.subconstructions) do sub.models=nil end;return r
 end
 local contract=api.getContract()
 assert(contract.moduleLength==20 and contract.platformWidth==5 and contract.platformFloorHeight==0.25)
 assert(contract.fixedStairs and contract.fixedEntrances and contract.fixedRoutes)
 contract.moduleLength=99;assert(api.getContract().moduleLength==20)
 local kit=api.getDefaultKit();kit.components.shelter=false;assert(api.getDefaultKit().components.shelter=="default")
 local platform=resource("platform20.mdl")
 assert(platform.boundingInfo.bbMax[1]==20)
 for _,lod in ipairs(platform.lods) do
  assert(lod.node.transf[1]==0.5 and math.abs(lod.node.transf[11]*1.1-0.25)<1e-8)
 end
 local roof=resource("platform_roof20.mdl")
 assert(roof.boundingInfo.bbMax[1]<20.1 and roof.boundingInfo.bbMax[3]==4.385)
 for _,lod in ipairs(roof.lods) do assert(lod.node.transf[1]==0.5 and lod.node.transf[15]==-1.1) end
 local light=roof.metadata.lightSourceList.lights[1]
 assert(light.transf[13]==10 and light.transf[15]==3.9)
 local removable={
  ["::/stations/street/small_stops/small_new.mdl"]=true,
  ["::/assets/vegetation/trees/apple_01/apple_01.mdl"]=true,
  ["::/assets/streets/tree_bed_new.mdl"]=true,
  ["::/assets/buildings/res/flower_pots/raised_bed_c.mdl"]=true,
  ["::/assets/vegetation/trees/azalea_01/azalea_01.mdl"]=true,
  ["::/assets/buildings/res/grd_frn/bench_c_metal.mdl"]=true,
  ["mrnickert_ultimate_metro::/elevated_entrance.mdl"]=true,
  ["::/assets/buildings/com/misc/trashcan_c_01.mdl"]=true,
  ["::/assets/buildings/res/garden_lamp/garden_lamp_c_stand.mdl"]=true,
  ["mrnickert_ultimate_metro::/elevated_platform_roof.mdl"]=true,
  ["::/assets/stations/rail/era_c_perron_pillar.mdl"]=true,
  ["::/assets/stations/rail/era_c_perron_holder.mdl"]=true,
 }
 for _,placement in ipairs({"surface","elevated"}) do for _,kind in ipairs({"through","terminus"}) do
  for _,L in ipairs({40,60,80,100,120}) do for _,fence in ipairs({false,true}) do
   local spec={apiVersion=1,placement=placement,stationType=kind,platformLength=L,fence=fence}
   local base=api.buildStation(spec,{}, {seed=42})
   spec.design={apiVersion=1,id="bare_station",components={shelter=false,canopy=false,trees=false,planters=false,benches=false,bins=false,lights=false}}
   local before=copy(spec)
   local bare=api.buildStation(spec,{}, {seed=42})
   equal(functional(base),functional(bare),"optional removals preserve all functional fields")
   equal(before,spec,"caller specification intact")
   for _,sub in ipairs(bare.subconstructions) do for _,m in ipairs(sub.models) do assert(not removable[m.id],"optional component really removed: "..m.id) end end
   spec.design={apiVersion=1,id="covered_station",components={
    platform={model="mrnickert_ultimate_metro::/platform20.mdl",moduleLength=20},
    canopy={model="mrnickert_ultimate_metro::/platform_roof20.mdl",moduleLength=20},
    shelter=false,trees=false,planters=false,
   }}
   before=copy(spec)
   local covered=api.buildStation(spec,{}, {seed=42})
   equal(before,spec,"custom components not mutated")
   equal(functional(base),functional(covered),"custom modules preserve all routes/stairs/terminals/terrain/costs")
   local roofs,platforms,posts=0,0,0
   for _,sub in ipairs(covered.subconstructions) do for _,m in ipairs(sub.models) do
    local t=m.transf
    if m.id=="mrnickert_ultimate_metro::/platform_roof20.mdl" then
     roofs=roofs+1;assert(t[1]==1 and t[6]==1 and t[11]==1,"never stretch authored 20m roof modules")
     assert(t[13]>=0 and t[13]+20<=L and math.abs(t[14])==6.5)
     assert(t[15]==(placement=="elevated" and 12.25 or 0.25))
    elseif m.id=="mrnickert_ultimate_metro::/platform20.mdl" then
     platforms=platforms+1;assert(t[1]==1 and t[6]==1 and t[11]==1,"never stretch authored 20m platform modules")
     local centre=L/2
     if placement=="elevated" then assert(t[13]+20<=centre-9+1e-6 or t[13]>=centre+9-1e-6,"plain platforms clear elevated stair shafts")
     elseif kind=="through" then assert(t[13]+20<=centre-20+1e-6 or t[13]>=centre+20-1e-6,"fixed underpass module stays intact") end
    elseif m.id=="mrnickert_ultimate_metro::/surface_platform.mdl" then
     assert(math.abs(t[11]*1.1-0.25)<1e-8,"core infills meet custom 20m floor height")
    elseif m.id=="::/assets/stations/rail/era_c_perron_pillar.mdl" then
     posts=posts+1
     if placement=="surface" and kind=="through" then assert(math.abs(t[13]-L/2)>=11,"roof post clears fixed underpass opening") end
    elseif m.id=="::/assets/streets/tram_pole_crossbar.mdl" and placement=="surface" then
     assert(math.abs(t[14])==9.8,"mast outside new surface canopy")
     assert(math.abs(math.abs(t[14]+3.13368*t[6])-2.5)<1e-6,"contact wire location unchanged")
    end
   end end
   assert(roofs==2*L/20 and posts>=4)
   if placement=="elevated" or kind=="terminus" or L>=80 then assert(platforms>0) end
  end end
 end end
 -- Shelters must also fit when a short station retains its default shelter
 -- under a new roof. Reference shelter minY=-1.08571, maxY=1.30928;
 -- canopy column radius=0.166464m and outer elevated railing is y=9.25.
 for _,placement in ipairs({"surface","elevated"}) do
  local spec={apiVersion=1,placement=placement,stationType="through",platformLength=40,
   design={apiVersion=1,id="shelter_clearance",components={
    canopy={model="mrnickert_ultimate_metro::/platform_roof20.mdl",moduleLength=20}}}}
  if placement=="elevated" then spec.design.components.shelter={model="test_kit::/shelter.mdl"} end
  local count=0
  for _,sub in ipairs(api.buildStation(spec).subconstructions) do for _,m in ipairs(sub.models) do
   if m.id=="::/stations/street/small_stops/small_new.mdl" or m.id=="test_kit::/shelter.mdl" then
    count=count+1;local y=math.abs(m.transf[14])
    assert(y-1.08571>6.5+0.166464,"shelter clears native canopy columns")
    assert(y+1.30928<9.25,"shelter inside outer safety railing")
   end
  end end
  assert(count==2)
 end
 local valid={apiVersion=1,placement="surface",stationType="through",platformLength=80}
 for _,c in ipairs({{platform=false},{canopy=true},{platform={model="x::/p.mdl",moduleLength=40}},
  {canopy={model="x::/r.mdl",moduleLength=10}},{trees={model="tree.mdl"}},
  {trees={model="x::/t.mdl",x=1}},{stairs=false}}) do
  valid.design={apiVersion=1,id="invalid",components=c}
  local ok,err=pcall(api.buildStation,valid)
  assert(not ok and tostring(err):find("Ultimate Light Rail API v1:",1,true))
 end
 valid.design={apiVersion=1,id="invalid",components={},assets={}}
 assert(not pcall(api.buildStation,valid),"no ambiguous old/new design forms")
 valid.placement="underground";valid.design={apiVersion=1,id="invalid",components={trees=false}}
 assert(not pcall(api.buildStation,valid),"underground hall explicitly fixed in v1")
 local env=setmetatable({},{__index=_G})
 assert(loadfile("examples/contract_station/content/kit_example.script.lua","t",env))()
 for appearance=1,2 do
  local result=env.data().updateFn({}, {length=3,layout=1,appearance=appearance,seed=42})
  local roofs=0
  for _,sub in ipairs(result.subconstructions) do for _,m in ipairs(sub.models) do
   if m.id=="ulr_contract_example::/example_roof20.mdl" then roofs=roofs+1 end
  end end
  assert(roofs==(appearance==1 and 8 or 0),"independent example changes actual components")
 end
 print("PASS: component contract on 40 surface/elevated combinations; optional removal, unscaled 20m modules, surface canopies, safe fixed stairs/masts and unchanged functional output.")
end
