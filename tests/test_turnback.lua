return function(resource)
 local update=resource("light_rail_station.script.lua").updateFn
 for placement=1,3 do
  local z=({-18,0,12})[placement]
  for index,L in ipairs({40,60,80,100,120}) do
   for fence=1,2 do
    local params={placement=placement,platformLength=index,stationType=1,turnback=2,fence=fence,seed=42}
    local result=update({},params)
    local sub=result.subconstructions[1]
    local paths=sub.laneLists
    assert(#result.edgeLists==2 and #sub.station.terminals==2)
    for i,edge in ipairs(result.edgeLists) do
     local inner=edge.edges[i==1 and 2 or 1][1]
     local outer=edge.edges[i==1 and 1 or 2][1]
     assert(inner[1]==(i==1 and -30 or L+30) and inner[3]==z)
     assert(outer[1]==(i==1 and -40 or L+40) and outer[3]==z)
     assert(edge.snapNodes[1]==i-1 and edge.freeNodes[1]==i-1)
    end
    for i=1,6 do
     local path=paths[i]
     assert(path.forwardOnly==false and path.needsReservation and not path.linkable)
     assert(path.transportModes[4]=="ELECTRIC_TRAM_TRACK")
     assert(path.speedLimit==(i<=2 and 80 or 40))
     for _,node in ipairs(path.nodes) do assert(node[1][3]==z) end
     if i<=2 then
      assert(path.nodes[1][1][1]==-30 and path.nodes[#path.nodes][1][1]==L+30)
     else
      local first,last=path.nodes[1][1],path.nodes[4][1]
      local x=i<=4 and -30 or L
      local y=i%2==1 and -2.5 or 2.5
      assert(first[1]==x and first[2]==y and last[1]==x+30 and last[2]==-y)
      assert(path.nodes[1][2][2]==0 and path.nodes[4][2][2]==0)
     end
    end
    for i,terminal in ipairs(sub.station.terminals) do
     assert(terminal.vehicleNode[1]==i-1)
     assert(paths[i].nodes[terminal.vehicleNode[2]+1][1][1]==L/2)
     for _,ref in ipairs(terminal.personEdges) do
      assert(paths[ref[1]+1].transportModes[1]=="PERSON")
      assert(paths[ref[1]+1].nodes[ref[2]*2+2])
     end
     for _,ref in ipairs(terminal.personNodes) do
      assert(paths[ref[1]+1].transportModes[1]=="PERSON")
      assert(paths[ref[1]+1].nodes[ref[2]+1])
     end
    end
    params.turnback=1
    local normal=update({},params)
    assert(normal.cost==result.cost and normal.maintenanceCost==result.maintenanceCost)
    assert(normal.subconstructions[1].laneLists[3].transportModes[1]=="PERSON")
    params.stationType=2
    params.turnback=2
    local terminus=update({},params)
    assert(#terminus.edgeLists==1 and terminus.subconstructions[1].laneLists[5].transportModes[1]=="PERSON")
   end
  end
 end
 print("PASS: 30 Turnback configurations, both snap ends, reservable crossovers, midpoint stops and pedestrian references.")
end
