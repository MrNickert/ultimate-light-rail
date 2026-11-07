return function(resource)
 local con=resource("light_rail_station.con.lua")
 local menu=resource("station_menu.script.lua")
 local update=resource("light_rail_station.script.lua").updateFn
 local api=require "mrnickert_ultimate_metro::/station_api_v1.lua"
 local depth=con.params[6]
 assert(depth.key=="depth" and depth.defaultIndex==1)
 assert(depth.checkEnabledScript.fileName=="mrnickert_ultimate_metro::/station_menu.script@checkDepthFn")
 assert(menu.checkDepthFn({}, {placement=1})=="Enabled")
 assert(menu.checkDepthFn({}, {placement=2})=="Hidden")
 assert(menu.checkDepthFn({}, {placement=3})=="Hidden")
 assert(menu.checkDepthFn({}, {})=="Hidden")
 local function key(p)
  return ("%.0f,%.0f,%.0f"):format(math.floor(p[1]*1000+0.5),
   math.floor(p[2]*1000+0.5),math.floor(p[3]*1000+0.5))
 end
 local function check(result,z,length,vehicleCount,isTerminus)
  local sub=result.subconstructions[1]
  assert(result.snapPoint.transf[15]==0 and sub.station.catchmentAreas[1].position[3]==0)
  assert(#result.edgeLists==(isTerminus and 1 or 2))
  for _,edge in ipairs(result.edgeLists) do
   assert(edge.edgeType=="TUNNEL" and #edge.snapNodes==1 and #edge.freeNodes==1)
   for _,node in ipairs(edge.edges) do assert(node[1][3]==z) end
  end
  local graph,street,count={},nil,0
  for _,lane in ipairs(sub.laneLists) do
   if lane.transportModes[1]=="PERSON" then
    if lane.linkable then
     assert(not street and lane.nodes[1][1][3]==0)
     street=key(lane.nodes[1][1])
    end
    for i=1,#lane.nodes,2 do
     local a,b=key(lane.nodes[i][1]),key(lane.nodes[i+1][1])
     assert(a~=b,"pedestrian lanes must have nonzero length")
     graph[a],graph[b]=graph[a] or {},graph[b] or {}
     graph[a][b]=true
     if not lane.forwardOnly then graph[b][a]=true end
    end
   else
    count=count+1
    assert(lane.forwardOnly==(vehicleCount==2) and lane.needsReservation==(vehicleCount~=2))
    assert(lane.speedLimit==(count<=2 and 80 or 40))
    for _,node in ipairs(lane.nodes) do assert(node[1][3]==z) end
   end
  end
  assert(street and count==vehicleCount)
  local queue,seen={street},{[street]=true}
  local head=1
  while queue[head] do
   for nextNode in pairs(graph[queue[head]]) do
    if not seen[nextNode] then seen[nextNode]=true;queue[#queue+1]=nextNode end
   end
   head=head+1
  end
  assert(#sub.station.terminals==2)
  for _,terminal in ipairs(sub.station.terminals) do
   local ref=terminal.vehicleNode
   local stop=sub.laneLists[ref[1]+1].nodes[ref[2]+1][1]
   assert(stop[1]==length/2 and stop[3]==z)
   assert(terminal.capacity==length/20*35)
   for _,node in ipairs(terminal.personNodes) do
    local lane=sub.laneLists[node[1]+1]
    local p=lane.nodes[node[2]+1][1]
    assert(lane.transportModes[1]=="PERSON" and math.abs(p[3]-(z+0.35))<1e-8)
    assert(seen[key(p)],"both perrons must be reachable from the street")
   end
  end
  for _,alignment in ipairs(sub.terrainAlignmentLists) do
   for _,triangle in ipairs(alignment.triangles) do
    for _,p in ipairs(triangle) do assert(p[3]==0) end
   end
  end
  local entrance,deepCollider=false,false
  for _,model in ipairs(sub.models) do
   if model.id:find("underground_station_surface.mdl",1,true) then
    assert(not entrance and model.transf[15]==0)
    entrance=true
   end
  end
  for _,collider in ipairs(sub.colliders) do
   for _,p in ipairs(collider.params.points) do
    if p[3]==z-2 then deepCollider=true end
   end
  end
  assert(entrance and deepCollider)
 end
 for index=1,4 do
  local z=-18*index
  assert(depth.values[index]==z.." m")
  for lengthIndex,length in ipairs({40,60,80,100,120}) do
   for _,variant in ipairs({{1,1,2},{1,2,6},{2,1,4}}) do
    local params={placement=1,depth=index,platformLength=lengthIndex,seed=42,
     stationType=variant[1],turnback=variant[2]}
    check(update({},params),z,length,variant[3],variant[1]==2)
   end
  end
 end
 local spec={apiVersion=1,placement="underground",stationType="through",platformLength=80,turnback=true}
 check(api.buildStation(spec,{}, {seed=42,depth=4}),-18,80,6,false)
 spec.undergroundLevel=-4
 check(api.buildStation(spec,{}, {seed=42}),-72,80,6,false)
 for _,invalid in ipairs({-5,0,-1.5,"-2",true}) do
  spec.undergroundLevel=invalid
  local ok,err=pcall(api.buildStation,spec,{}, {seed=42})
  assert(not ok and tostring(err):find("undergroundLevel",1,true))
 end
 check(update({}, {placement=1,depth=99,stationType=1,seed=42}),-18,80,2,false)
 for placement=2,3 do
  local result=update({}, {placement=placement,depth=4,seed=42})
  assert(result.edgeLists[1].edges[1][1][3]==(placement==2 and 0 or 12))
 end
 print("PASS: all 60 underground depth/length/layout combinations; tracks, capacity, colliders, surface access and pedestrian paths.")
end
