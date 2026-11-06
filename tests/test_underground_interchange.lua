local function check(resource,construction,rotations,params,lengths)
 local con=resource(construction)
 local levels=#rotations
 assert(con.undergroundView)
 params=params or {}
 params.seed=42
 local result=resource("underground_interchange.script.lua").updateFn(con.updateScript.params or {}, params)
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
  local extent=(lengths and lengths[level] or 80)/2+40
  assert(math.abs(math.abs(endpoint[1]*c+endpoint[2]*s)-extent)<1e-8)
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
 local con=resource("underground_interchange.con.lua")
 local menu=resource("station_menu.script.lua")
 assert(#con.params==9 and con.params[1].defaultIndex==2)
 assert(con.description.previewIcon=="" and con.description.icon~="")
 assert(con.menuCategory.categories[1].category=="ulr_stations")
 assert(#resource("underground_interchange_four_test.con.lua").menuCategory.categories==0)
 for i=1,4 do
  local angle,length=con.params[i*2],con.params[i*2+1]
  assert(angle.key=="levelAngle"..i and length.key=="levelLength"..i)
  assert(#angle.values==4 and #length.values==5)
  assert(menu.checkInterchangeLevelFn(angle.checkEnabledScript.params,{levelCount=i})=="Enabled")
  assert(menu.checkInterchangeLevelFn(length.checkEnabledScript.params,{levelCount=i-1})=="Hidden")
 end
 check(resource,"underground_interchange.con.lua",{{1,0},{0,1}})
 check(resource,"underground_interchange_four_test.con.lua",{{1,0},{diagonal,diagonal},{0,1},{-diagonal,diagonal}})
 local rotations={{1,0},{diagonal,diagonal},{0,1},{-diagonal,diagonal}}
 local lengths={40,60,80,100,120}
 for i,upper in ipairs(rotations) do
  for j,lower in ipairs(rotations) do
   check(resource,"underground_interchange.con.lua",{upper,lower},
    {levelCount=2,levelAngle1=i,levelAngle2=j,levelLength1=i,levelLength2=j+1},
    {lengths[i],lengths[j+1]})
  end
 end
 check(resource,"underground_interchange.con.lua",{{0,1}},
  {levelCount=1,levelAngle1=3,levelLength1=5},{120})
 check(resource,"underground_interchange.con.lua",{{1,0},{-diagonal,diagonal},{0,1}},
  {levelCount=3,levelAngle1=1,levelAngle2=4,levelAngle3=3,levelLength1=5,levelLength2=1},{120,40,80})
 check(resource,"underground_interchange.con.lua",{{-diagonal,diagonal},{-diagonal,diagonal},{1,0},{diagonal,diagonal}},
  {levelCount=4,levelAngle1=4,levelAngle2=4,levelAngle3=1,levelAngle4=2,levelLength4=2},{80,80,80,60})
 print("PASS: one to four configured levels, all adjacent angle pairs, mixed lengths, legacy geometry, tunnel ends and pedestrian reachability.")
end
