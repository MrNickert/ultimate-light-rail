-- Merge internal station levels without changing the public station contract.
local interchange={}

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
