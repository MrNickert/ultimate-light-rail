-- Public, versioned contract. Geometry is owned by the core, visuals by designs.
local build=require "mrnickert_ultimate_metro::/station_layout_builder.lua"
local standard=require "mrnickert_ultimate_metro::/station_standard_design.lua"
local kit=require "mrnickert_ultimate_metro::/station_standard_kit.lua"
local components=require "mrnickert_ultimate_metro::/station_components.lua"
local api={apiVersion=1}
local lengths={[40]=true,[60]=true,[80]=true,[100]=true,[120]=true}
local fields={apiVersion=true,placement=true,stationType=true,platformLength=true,platformTracks=true,fence=true,turnback=true,design=true}
local function check(ok,message)
 if not ok then error("Ultimate Light Rail API v1: "..message,3) end
end
local function onlyFields(value,allowed,label)
 for k in pairs(value) do check(allowed[k],label..": unknown field "..tostring(k)) end
end
local function modelId(value)
 if type(value)~="string" or not value:match("^[a-z0-9_-]*::/[a-z0-9_./-]+%.mdl$") then return false end
 for part in value:gmatch("[^/]+") do if part==".." then return false end end
 return true
end
api.getMenuCategory=require("mrnickert_ultimate_metro::/station_menu.lua").getMenuCategory
function api.getDefaultDesign() return standard() end
function api.getDefaultKit(placement)
 check(placement==nil or placement=="surface" or placement=="elevated" or placement=="underground","unsupported default-kit placement")
 return kit(placement)
end
function api.getContract()
 return {apiVersion=1,moduleLength=20,platformWidth=5,platformFloorHeight=0.25,platformTracks=2,
  platformLengths={40,60,80,100,120},fixedStairs=true,fixedEntrances=true,fixedRoutes=true,
  components={"platform","shelter","canopy","trees","planters","benches","bins","lights"}}
end
function api.buildStation(spec,captureParams,constructionParams)
 check(type(spec)=="table","station specification must be a table")
 onlyFields(spec,fields,"station")
 check(spec.apiVersion==1,"apiVersion must be 1")
 check(spec.placement=="surface" or spec.placement=="underground" or spec.placement=="elevated","unsupported placement")
 check(spec.stationType=="through" or spec.stationType=="terminus","unsupported stationType")
 check(lengths[spec.platformLength],"platformLength must be 40, 60, 80, 100 or 120 metres")
 check(spec.platformTracks==nil or spec.platformTracks==2,"v1 supports exactly two platform tracks")
 check(spec.fence==nil or type(spec.fence)=="boolean","fence must be a boolean")
 check(spec.turnback==nil or type(spec.turnback)=="boolean","turnback must be a boolean")
 check(not spec.turnback or spec.stationType=="through","turnback requires a through station")
 check(captureParams==nil or type(captureParams)=="table","captureParams must be a table")
 check(constructionParams==nil or type(constructionParams)=="table","constructionParams must be a table")
 local defaults=standard()
 local design=spec.design
 if design==nil then design=kit() end
 check(type(design)=="table","design must be a table")
 onlyFields(design,{apiVersion=true,id=true,assets=true,components=true},"design")
 check(design.apiVersion==1,"design apiVersion must be 1")
 check(type(design.id)=="string" and design.id:match("^[a-z0-9_-]+$"),"design id must be a lowercase identifier")
 check(not (design.assets~=nil and design.components~=nil),"choose assets or components, not both")
 local replacements={}
 if design.components~=nil then
  components.validate(design.components,spec)
 else
  check(type(design.assets)=="table","design assets or components must be a table")
  for role,id in pairs(design.assets) do
   check(defaults.assets[role]~=nil,"unknown asset role "..tostring(role))
   check(modelId(id),"asset "..tostring(role).." must be a mod-qualified .mdl reference")
   replacements[defaults.assets[role]]=id
  end
 end
 local normalized={placement=spec.placement,stationType=spec.stationType,platformLength=spec.platformLength,
  turnback=spec.turnback,
  fence=spec.placement~="underground" and spec.fence~=false}
 local result=build(captureParams or {},constructionParams or {},normalized)
 -- Only model identifiers are replaceable. Core transforms, network references,
 -- terrain, entrances, terminal indices and safety guards stay owned by the
 -- layout. External model geometry/colliders must obey the reference envelope.
 for _,sub in ipairs(result.subconstructions or {}) do
  for _,model in ipairs(sub.models or {}) do model.id=replacements[model.id] or model.id end
 end
 if design.components~=nil then return components.apply(result,normalized,design.components) end
 return result
end
return api
