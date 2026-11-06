return function(resource)
 local con=resource("underground_interchange.con.lua")
 assert(con.undergroundView and #con.params==0)
 assert(con.menuCategory.categories[1].category=="ulr_stations")
 local result=resource("underground_interchange.script.lua").updateFn({}, {seed=42})
 assert(#result.subconstructions==1 and #result.edgeLists==4)
 assert(result.cost==1800000 and result.maintenanceCost==60000)
 local sub=result.subconstructions[1]
 assert(#sub.station.terminals==4)
 local function key(point)
  return ("%d,%d,%d"):format(math.floor(point[1]*1000+0.5),
   math.floor(point[2]*1000+0.5),math.floor(point[3]*1000+0.5))
 end
 local graph,entry={},nil
 for _,lane in ipairs(sub.laneLists) do
  if lane.transportModes[1]=="PERSON" then
   if lane.linkable then
    assert(not entry and lane.nodes[1][1][3]==0)
    entry=key(lane.nodes[1][1])
   end
   for i=1,#lane.nodes,2 do
    local a,b=key(lane.nodes[i][1]),key(lane.nodes[i+1][1])
    graph[a]=graph[a] or {}
    graph[b]=graph[b] or {}
    graph[a][b],graph[b][a]=true,true
   end
  end
 end
 assert(entry)
 local queue,visited={entry},{[entry]=true}
 local nextIndex=1
 while queue[nextIndex] do
  for neighbour in pairs(graph[queue[nextIndex]]) do
   if not visited[neighbour] then visited[neighbour]=true;queue[#queue+1]=neighbour end
  end
  nextIndex=nextIndex+1
 end
 for i,terminal in ipairs(sub.station.terminals) do
  local upper=i<=2
  local vehicle=sub.laneLists[terminal.vehicleNode[1]+1]
  local stop=vehicle.nodes[terminal.vehicleNode[2]+1][1]
  assert(stop[3]==(upper and -18 or -36) and stop[upper and 1 or 2]==0)
  assert(vehicle.needsReservation and not vehicle.forwardOnly)
  for _,ref in ipairs(terminal.personNodes) do
   local lane=sub.laneLists[ref[1]+1]
   assert(lane.transportModes[1]=="PERSON" and visited[key(lane.nodes[ref[2]+1][1])])
  end
 end
 for i,edge in ipairs(result.edgeLists) do
  local upper=i<=2
  local axis=upper and 1 or 2
  local endpoint=edge.edges[edge.snapNodes[1]+1][1]
  assert(edge.edgeType=="TUNNEL" and endpoint[3]==(upper and -18 or -36))
  assert(math.abs(endpoint[axis])==80 and endpoint[3-axis]==0)
 end
 local switchCount=0
 for _,lane in ipairs(sub.laneLists) do
  if lane.transportModes[1]=="TRAM" and lane.speedLimit==40 then
   assert(lane.needsReservation and not lane.forwardOnly)
   switchCount=switchCount+1
  end
 end
 assert(switchCount==8)
 print("PASS: fixed interchange, four tunnel ends, four terminals, four scissors crossovers and pedestrian routes from one public entrance.")
end
