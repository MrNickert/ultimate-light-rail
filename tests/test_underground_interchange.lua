local function check(resource,construction,rotations)
 local con=resource(construction)
 local levels=#rotations
 assert(con.undergroundView and #con.params==0)
 assert(con.menuCategory.categories[1].category=="ulr_stations")
 local result=resource("underground_interchange.script.lua").updateFn(con.updateScript.params or {}, {seed=42})
 assert(#result.subconstructions==1 and #result.edgeLists==2*levels)
 assert(result.cost==900000*levels and result.maintenanceCost==30000*levels)
 local sub=result.subconstructions[1]
 assert(#sub.station.terminals==2*levels)
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
  local level=math.ceil(i/2)
  local c,s=table.unpack(rotations[level])
  local vehicle=sub.laneLists[terminal.vehicleNode[1]+1]
  local stop=vehicle.nodes[terminal.vehicleNode[2]+1][1]
  assert(stop[3]==-18*level and math.abs(stop[1]*c+stop[2]*s)<1e-8)
  assert(vehicle.needsReservation and not vehicle.forwardOnly)
  for _,ref in ipairs(terminal.personNodes) do
   local lane=sub.laneLists[ref[1]+1]
   assert(lane.transportModes[1]=="PERSON" and visited[key(lane.nodes[ref[2]+1][1])])
  end
 end
 for i,edge in ipairs(result.edgeLists) do
  local level=math.ceil(i/2)
  local c,s=table.unpack(rotations[level])
  local endpoint=edge.edges[edge.snapNodes[1]+1][1]
  assert(edge.edgeType=="TUNNEL" and endpoint[3]==-18*level)
  assert(math.abs(math.abs(endpoint[1]*c+endpoint[2]*s)-80)<1e-8)
  assert(math.abs(-endpoint[1]*s+endpoint[2]*c)<1e-8)
 end
 local switchCount=0
 for _,lane in ipairs(sub.laneLists) do
  if lane.transportModes[1]=="TRAM" and lane.speedLimit==40 then
   assert(lane.needsReservation and not lane.forwardOnly)
   switchCount=switchCount+1
  end
 end
 assert(switchCount==4*levels)
end

return function(resource)
 local diagonal=math.sqrt(0.5)
 check(resource,"underground_interchange.con.lua",{{1,0},{0,1}})
 check(resource,"underground_interchange_four_test.con.lua",{{1,0},{diagonal,diagonal},{0,1},{-diagonal,diagonal}})
 print("PASS: two- and four-level interchanges; terminal and tunnel geometry, Turnback and pedestrian reachability.")
end
