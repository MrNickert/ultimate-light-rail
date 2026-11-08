return function(resource)
 local con=resource("mixed_interchange.con.lua")
 assert(not con.undergroundView and con.availability.yearFrom==1925 and #con.params==0)
 assert(con.menuCategory.categories[1].category=="ulr_stations")
 local result=resource("mixed_interchange.script.lua").updateFn({}, {seed=42})
 local attributes=con.description.attributes
 assert(attributes.cost[1]==result.cost and attributes.cost[2]==-1)
 assert(attributes.maintenanceCost[1]==result.maintenanceCost and attributes.maintenanceCost[2]==-1)
 assert(#result.subconstructions==1 and #result.edgeLists==6)
 local sub=result.subconstructions[1]
 assert(#sub.station.terminals==6)
 local heights={0,12,-18}
 for i,edge in ipairs(result.edgeLists) do
  local level=math.ceil(i/2)
  local index=edge.snapNodes[1]
  assert(index==edge.freeNodes[1] and edge.maxNodeSnapAngle==0)
  local point,tangent=table.unpack(edge.edges[index+1])
  assert(point[3]==heights[level])
  if level==1 then
   assert(edge.edgeType==nil and tangent[2]==0)
  elseif level==2 then
   assert(edge.edgeType=="BRIDGE" and tangent[1]==0)
  else
   assert(edge.edgeType=="TUNNEL" and point[1]==40 and tangent[1]==0 and tangent[2]~=0)
  end
 end

 local function key(point)
  return ("%d,%d,%d"):format(math.floor(point[1]*1000+0.5),
   math.floor(point[2]*1000+0.5),math.floor(point[3]*1000+0.5))
 end
 local graph,switches={},0
 for _,lane in ipairs(sub.laneLists) do
  if lane.transportModes[1]=="PERSON" then
   for i=1,#lane.nodes,2 do
    local a,b=key(lane.nodes[i][1]),key(lane.nodes[i+1][1])
    graph[a]=graph[a] or {}
    graph[b]=graph[b] or {}
    graph[a][b],graph[b][a]=true,true
   end
  elseif lane.speedLimit==40 then
   assert(lane.needsReservation and not lane.forwardOnly)
   switches=switches+1
  end
 end
 assert(switches==12)
 local snap=result.snapPoint.transf
 local entrance=key({snap[13],snap[14]+1,0.15})
 local visited,queue={[entrance]=true},{entrance}
 local cursor=1
 while queue[cursor] do
  for point in pairs(graph[queue[cursor]]) do
   if not visited[point] then
    visited[point]=true
    queue[#queue+1]=point
   end
  end
  cursor=cursor+1
 end
 for i,terminal in ipairs(sub.station.terminals) do
  local level=math.ceil(i/2)
  local lane=sub.laneLists[terminal.vehicleNode[1]+1]
  assert(terminal.capacity==140 and lane.needsReservation and not lane.forwardOnly)
  assert(lane.nodes[terminal.vehicleNode[2]+1][1][3]==heights[level])
  for _,ref in ipairs(terminal.personNodes) do
   local personLane=sub.laneLists[ref[1]+1]
   local point=personLane.nodes[ref[2]+1][1]
   assert(personLane.transportModes[1]=="PERSON" and visited[key(point)])
   assert(point[3]==({0.25,12.25,-17.65})[level])
  end
  for _,ref in ipairs(terminal.personEdges) do
   local personLane=sub.laneLists[ref[1]+1]
   assert(personLane.transportModes[1]=="PERSON" and personLane.nodes[ref[2]*2+2])
  end
 end
 local plaza=key({40,12.5,0.15})
 assert(visited[plaza] and graph[plaza][key({37.5,16,0.15})])
 assert(graph[key({40.5,16,-12})][key({40,16,-12})])
 local holes=0
 for _,groundFace in ipairs(sub.groundFaces) do
  if groundFace.modes[1].key=="::/infrastructure/shared/hole.gtex" then
   local corners={[key({36,16,0})]=true,[key({42,16,0})]=true,
    [key({36,28,0})]=true,[key({42,28,0})]=true}
   assert(#groundFace.face==4)
   for _,point in ipairs(groundFace.face) do
    local corner=key(point)
    assert(corners[corner]); corners[corner]=nil
   end
   holes=holes+1
  end
 end
 assert(holes==1)
 for _,model in ipairs(sub.models) do
  assert(model.id~="::/stations/street/underground_station/models/underground_station_surface.mdl")
  local t=model.transf
  local paver=model.id=="mrnickert_ultimate_metro::/elevated_paving.mdl" and t[15]==0.151
  local foundation=model.id=="mrnickert_ultimate_metro::/elevated_concrete_visual.mdl"
   and t[15]==0.15 and t[11]==0.15/2.4
  if paver or foundation then
   local xMax,yMin=t[13],t[14]
   local xMin=xMax+t[5]*(paver and 3 or 4)
   local yMax=yMin+t[2]*(paver and 3 or 6)
   assert(xMax<=36 or xMin>=42 or yMax<=16 or yMin>=28,"plaza geometry covers the stair opening")
  end
 end
 for _,collider in ipairs(sub.colliders) do
  for _,point in ipairs(collider.params.points) do assert(point[3]<0) end
 end
 print("PASS: parallel tunnel and viaduct, six connected platforms and six track ends, one shared plaza stairwell with clear paving.")
end
