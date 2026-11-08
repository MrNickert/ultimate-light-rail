return function(resource)
 local con=resource("aboveground_interchange.con.lua")
 assert(not con.undergroundView and con.availability.yearFrom==1925)
 assert(con.menuCategory.categories[1].category=="ulr_stations" and #con.params==0)
 local params={seed=42,ulrPlatformAccess=1,ulrStreetAlignment=2}
 local result=resource("aboveground_interchange.script.lua").updateFn({},params)
 assert(params.ulrPlatformAccess==1 and params.ulrStreetAlignment==2)
 local attributes=con.description.attributes
 assert(#attributes.cost==2 and attributes.cost[1]==result.cost and attributes.cost[2]==-1)
 assert(#attributes.maintenanceCost==2 and attributes.maintenanceCost[1]==result.maintenanceCost
  and attributes.maintenanceCost[2]==-1)
 assert(#result.subconstructions==1 and #result.edgeLists==4)
 local sub=result.subconstructions[1]
 assert(#sub.station.terminals==4)
 for i,edge in ipairs(result.edgeLists) do
  local elevated=i>2
  local index=edge.snapNodes[1]
  assert(index==edge.freeNodes[1] and edge.maxNodeSnapAngle==0)
  assert(edge.edges[index+1][1][3]==(elevated and 12 or 0))
  if elevated then
   assert(edge.edgeType=="BRIDGE" and edge.edges[index+1][1][1]==40)
  else
   assert(edge.edgeType==nil and edge.edges[index+1][1][2]==0)
  end
 end

 local function key(point)
  return ("%d,%d,%d"):format(math.floor(point[1]*1000+0.5),
   math.floor(point[2]*1000+0.5),math.floor(point[3]*1000+0.5))
 end
 local graph,switches,stairs={},0,0
 for _,lane in ipairs(sub.laneLists) do
  if lane.transportModes[1]=="PERSON" then
   for i=1,#lane.nodes,2 do
    local first,last=lane.nodes[i][1],lane.nodes[i+1][1]
    local a,b=key(first),key(last)
    graph[a]=graph[a] or {}
    graph[b]=graph[b] or {}
    graph[a][b],graph[b][a]=true,true
    if first[3]==0.15 and last[3]==12.25 then
     assert(first[2]>=11.5 and last[2]>first[2],"elevated stair flights clear the surface station")
     stairs=stairs+1
    end
   end
  elseif lane.speedLimit==40 then
   assert(lane.needsReservation and not lane.forwardOnly)
   switches=switches+1
  end
 end
 assert(switches==8 and stairs==2)
 local snap=result.snapPoint.transf
 local entry=key({snap[13],snap[14]+1,0.15})
 local visited,queue={[entry]=true},{entry}
 local cursor=1
 while queue[cursor] do
  for nextPoint in pairs(graph[queue[cursor]]) do
   if not visited[nextPoint] then
    visited[nextPoint]=true
    queue[#queue+1]=nextPoint
   end
  end
  cursor=cursor+1
 end
 for i,terminal in ipairs(sub.station.terminals) do
  local elevated=i>2
  assert(terminal.capacity==140)
  local vehicle=sub.laneLists[terminal.vehicleNode[1]+1]
  assert(vehicle.needsReservation and not vehicle.forwardOnly)
  assert(vehicle.nodes[terminal.vehicleNode[2]+1][1][3]==(elevated and 12 or 0))
  for _,ref in ipairs(terminal.personNodes) do
   local lane=sub.laneLists[ref[1]+1]
   local point=lane.nodes[ref[2]+1][1]
   assert(lane.transportModes[1]=="PERSON" and visited[key(point)])
   assert(point[3]==(elevated and 12.25 or 0.25))
  end
  for _,ref in ipairs(terminal.personEdges) do
   local lane=sub.laneLists[ref[1]+1]
   assert(lane.transportModes[1]=="PERSON" and lane.nodes[ref[2]*2+2])
  end
 end
 local porch=sub.terrainAlignmentLists[2].faces[1]
 for _,point in ipairs(porch) do assert(point[2]>=10 and point[3]==0) end
 local piers=0
 for _,model in ipairs(sub.models) do
  local t=model.transf
  if model.id=="mrnickert_ultimate_metro::/elevated_concrete.mdl" and t[11]>4 then
   local minY,maxY=t[14],t[14]+6*t[2]
   assert(minY>=9 or maxY<=-9,"a pier overlaps the surface platform")
   assert(minY>=snap[14]+9 or maxY<=snap[14]-9,"a pier overlaps the street corridor")
   piers=piers+1
  end
 end
 assert(piers>0)
 print("PASS: Aboveground Interchange has four connected platforms, two clear stair flights, eight turnback switch lanes and four native track ends.")
end
