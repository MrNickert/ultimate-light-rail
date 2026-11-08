-- Build and merge internal station levels through the public station contract.
local stationApi=require "mrnickert_ultimate_metro::/station_api_v1.lua"
local undergroundLevels=require "mrnickert_ultimate_metro::/underground_levels.lua"
local interchange={}
local abovegroundPlacements={[0]="surface",[1]="elevated"}

function interchange.buildLevel(level,length,capture,params)
 local placement=abovegroundPlacements[level]
 local undergroundLevel
 if undergroundLevels.trackZ(level) then
  placement="underground"
  undergroundLevel=level
 end
 assert(placement,"Unsupported interchange level: "..tostring(level))
 return stationApi.buildStation({apiVersion=1,placement=placement,undergroundLevel=undergroundLevel,
  stationType="through",platformLength=length,turnback=true,design=stationApi.getDefaultKit(placement)},capture,params)
end

local function append(target,source)
 for _,value in ipairs(source) do target[#target+1]=value end
end

interchange.append=append

function interchange.appendLevel(result,level)
 local combined,additional=result.subconstructions[1],level.subconstructions[1]
 local offset=#combined.laneLists
 -- All terminals share one station, with zero-based references into its lanes.
 for _,terminal in ipairs(additional.station.terminals) do
  terminal.vehicleNode[1]=terminal.vehicleNode[1]+offset
  for _,ref in ipairs(terminal.personEdges) do ref[1]=ref[1]+offset end
  for _,ref in ipairs(terminal.personNodes) do ref[1]=ref[1]+offset end
 end
 append(combined.station.terminals,additional.station.terminals)
 append(combined.laneLists,additional.laneLists)
 append(combined.models,additional.models)
 if additional.colliders then
  combined.colliders=combined.colliders or {}
  append(combined.colliders,additional.colliders)
 end
 append(result.edgeLists,level.edgeLists)
 result.cost=result.cost+level.cost
 result.maintenanceCost=result.maintenanceCost+level.maintenanceCost
end

return interchange
