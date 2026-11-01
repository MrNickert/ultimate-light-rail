-- Same vehicle topology as the surface terminus; native pedestrian entrance.
local build = require "mrnickert_ultimate_metro::/terminus_util.lua"
local entrance = require "mrnickert_ultimate_metro::/underground_entrance_util.lua"
function data()
 return {updateFn=function(capture,params)
  params=params or {}
  local result=build(capture,params)
  local surface=result.subconstructions[1]
  local vehicles=tonumber(params.crossover or 2)~=1 and 4 or 2
  local sub=entrance(params)
  local pedestrians=sub.laneLists
  sub.laneLists={}
  for i=1,vehicles do
   local lane=surface.laneLists[i]
   -- Adjacent segments share their endpoint tables: assign depth once.
   for _,node in ipairs(lane.nodes) do node[1][3]=-18 end
   sub.laneLists[#sub.laneLists+1]=lane
  end
  for _,lane in ipairs(pedestrians) do sub.laneLists[#sub.laneLists+1]=lane end
  -- Native station meshes contain their platform rails. Add only throat rails.
  for _,model in ipairs(surface.models) do
   if model.id:find("single_rail.mdl",1,true) and model.transf[13]<0 then
    model.transf[15]=model.transf[15]-18
    sub.models[#sub.models+1]=model
   end
  end
  sub.station=surface.station
  sub.station.catchmentAreas={{position={40,9,0},radius=200}}
  for i,terminal in ipairs(sub.station.terminals) do
   local pedestrianIndex=vehicles+3+i
   terminal.personEdges={{pedestrianIndex,0},{pedestrianIndex,1},{pedestrianIndex,2}}
   terminal.personNodes={{pedestrianIndex,0},{pedestrianIndex,1},{pedestrianIndex,2}}
  end
  for _,edge in ipairs(result.edgeLists) do
   for _,node in ipairs(edge.edges) do node[1][3]=-18 end
   edge.edgeType="TUNNEL"
   edge.edgeTypeName="::/infrastructure/tunnel/tunnel_b_car.tunnel"
   edge.params.edgeType=edge.edgeType
   edge.params.edgeTypeName=edge.edgeTypeName
  end
  -- Placement follows the native underground stop: entrance at street level.
  result.snapPoint={transf={1,0,0,0,0,1,0,0,0,0,1,0,40,8,0,1},
   snapToBaseEdgeTypes={"STREET"},allowSnapToBaseEdgeEnds=true}
  result.subconstructions={sub}
  result.cost=900000
  result.maintenanceCost=180000
  return result
 end}
end
