-- Native entrance/circulation shared by the configurable underground variants.
-- The legacy underground script is deliberately left intact for saved stations.
local terminus=require "mrnickert_ultimate_metro::/terminus_util.lua"
local through=require "mrnickert_ultimate_metro::/through_station_util.lua"
local concourse=require "mrnickert_ultimate_metro::/underground_concourse_util.lua"
return function(capture,params,isThrough,length,turnback)
 local L=length or 80
 local layout={length=L,turnback=turnback}
 local result=isThrough and through(capture,params,layout) or terminus(capture,params,layout)
 local source=result.subconstructions[1]
 local vehicles=turnback and 6 or (isThrough and 2 or 4)
 for i=1,vehicles do
  for _,node in ipairs(source.laneLists[i].nodes) do node[1][3]=-18 end
 end
 local sub=concourse(source,params,isThrough,L,turnback)
 for _,edge in ipairs(result.edgeLists) do
  -- No fences below ground; preserve native tram traffic for through stations.
  if isThrough then edge.params.type="::/infrastructure/street/tram/tram_new.street_template" end
  for _,node in ipairs(edge.edges) do node[1][3]=-18 end
  edge.edgeType="TUNNEL"
  edge.edgeTypeName="::/infrastructure/tunnel/tunnel_b_car.tunnel"
  edge.params.edgeType=edge.edgeType
  edge.params.edgeTypeName=edge.edgeTypeName
 end
 result.snapPoint={transf={0,-1,0,0,1,0,0,0,0,0,1,0,L-12,0,0,1},
  snapToBaseEdgeTypes={"STREET"},allowSnapToBaseEdgeEnds=true}
 result.subconstructions={sub}
 result.cost=900000
 result.maintenanceCost=30000
 return result
end
