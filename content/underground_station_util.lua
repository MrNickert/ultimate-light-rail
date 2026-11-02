-- Native entrance/circulation shared by the configurable underground variants.
-- The legacy underground script is deliberately left intact for saved stations.
local terminus=require "mrnickert_ultimate_metro::/terminus_util.lua"
local through=require "mrnickert_ultimate_metro::/through_station_util.lua"
local entrance=require "mrnickert_ultimate_metro::/underground_entrance_util.lua"
return function(capture,params,isThrough)
 local result=isThrough and through(capture,params) or terminus(capture,params)
 local source=result.subconstructions[1]
 local vehicles=isThrough and 2 or 4
 local sub=entrance(params,{through=isThrough})
 local pedestrians=sub.laneLists
 sub.laneLists={}
 for i=1,vehicles do
  local lane=source.laneLists[i]
  for _,node in ipairs(lane.nodes) do node[1][3]=-18 end
  sub.laneLists[#sub.laneLists+1]=lane
 end
 for _,lane in ipairs(pedestrians) do sub.laneLists[#sub.laneLists+1]=lane end
 if not isThrough then
  for _,model in ipairs(source.models) do
   if model.id:find("single_rail.mdl",1,true) and model.transf[13]<0 then
    model.transf[15]=model.transf[15]-18
    sub.models[#sub.models+1]=model
   end
  end
 end
 sub.station=source.station
 sub.station.catchmentAreas={{position={69,0,0},radius=200}}
 for i,terminal in ipairs(sub.station.terminals) do
  local pedestrianIndex=vehicles+3+i
  terminal.personEdges={{pedestrianIndex,0},{pedestrianIndex,1},{pedestrianIndex,2}}
  terminal.personNodes={{pedestrianIndex,0},{pedestrianIndex,1},{pedestrianIndex,2}}
 end
 for _,edge in ipairs(result.edgeLists) do
  -- No fences below ground; preserve native tram traffic for through stations.
  if isThrough then edge.params.type="::/infrastructure/street/tram/tram_new.street_template" end
  for _,node in ipairs(edge.edges) do node[1][3]=-18 end
  edge.edgeType="TUNNEL"
  edge.edgeTypeName="::/infrastructure/tunnel/tunnel_b_car.tunnel"
  edge.params.edgeType=edge.edgeType
  edge.params.edgeTypeName=edge.edgeTypeName
 end
 result.snapPoint={transf={0,-1,0,0,1,0,0,0,0,0,1,0,68,0,0,1},
  snapToBaseEdgeTypes={"STREET"},allowSnapToBaseEdgeEnds=true}
 result.subconstructions={sub}
 result.cost=900000
 result.maintenanceCost=180000
 return result
end
