-- Internal geometry adapter. Public callers use station_api_v1.lua.
local terminus=require "mrnickert_ultimate_metro::/terminus_util.lua"
local through=require "mrnickert_ultimate_metro::/through_station_util.lua"
local decorate=require "mrnickert_ultimate_metro::/surface_station_util.lua"
local underground=require "mrnickert_ultimate_metro::/underground_station_util.lua"
local elevated=require "mrnickert_ultimate_metro::/elevated_station_util.lua"
local function applyPlacementSnap(result,placement,length,isThrough)
 if placement=="surface" then
  local frame
  if isThrough then
   -- Align the long platform edge to the street, just outside its deck.
   frame={1,0,0,0,0,1,0,0,0,0,1,0,length/2,-10,0,1}
  else
   -- The tram approach is at the opposite end from the public head plaza.
   frame={0,1,0,0,-1,0,0,0,0,0,1,0,length+6,0,0,1}
  end
  result.snapPoint={transf=frame,snapToBaseEdgeTypes={"STREET"},allowSnapToBaseEdgeEnds=true}
 end
 for _,edge in ipairs(result.edgeLists) do
  -- Constrain automatic approach alignment when building the station.
  -- The end nodes remain exposed for drawing connections afterwards.
  edge.maxNodeSnapAngle=0
 end
 return result
end

return function(capture,params,spec)
 params=params or {}
 -- Copy: the UI/save parameter table must not be changed by a builder.
 local config={};for k,v in pairs(params) do config[k]=v end
 local length=spec.platformLength
 local layout={length=length,turnback=spec.turnback}
 local isThrough=spec.stationType=="through"
 local isUnderground=spec.placement=="underground"
 local fence=spec.fence
 -- Terminus geometry always includes its crossover. Through stations use turnback.
 config.crossover=isThrough and 1 or 2
 if isUnderground then return underground(capture,config,isThrough,length,spec.turnback,spec.undergroundLevel) end
 if spec.placement=="elevated" then
  local result=elevated(capture,config,isThrough,length,fence,spec.turnback)
  return applyPlacementSnap(result,spec.placement,length,isThrough)
 end
 local result
 if isThrough then
  layout.platformCrossing=tonumber(config.ulrPlatformAccess)==2
  result=through(capture,config,layout)
 else
  result=decorate(terminus(capture,config,layout),layout)
  result.edgeLists[1].params.type="mrnickert_ultimate_metro::/lightrail_station_approach.street_template"
 end
 if not fence then
  for _,sub in ipairs(result.subconstructions) do
   local models={}
   for _,model in ipairs(sub.models) do
    if model.id~="mrnickert_ultimate_metro::/lightrail_fence.mdl" then models[#models+1]=model end
   end
   sub.models=models
  end
  for _,edge in ipairs(result.edgeLists) do
   edge.params.type=isThrough and "::/infrastructure/street/tram/tram_new.street_template"
    or "mrnickert_ultimate_metro::/lightrail_double.street_template"
  end
 end
 return applyPlacementSnap(result,spec.placement,length,isThrough)
end
