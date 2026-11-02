return function(resource)
 local function nativeModel(name)
  local env=setmetatable({},{__index=_G})
  assert(loadfile(arg[1].."/"..name..".mdl","t",env))()
  return env.data()
 end
 local deck=nativeModel("c_6_rep_rep")
 assert(math.abs(deck.boundingInfo.bbMax[1]-6)<1e-4 and math.abs(deck.boundingInfo.bbMax[2]-4)<1e-4)
 assert(math.abs(deck.boundingInfo.bbMin[3]+2.4)<1e-4 and math.abs(deck.boundingInfo.bbMax[3])<1e-4)
 assert(not deck.metadata.transportNetworkProvider,"native structural model must add no lanes")
 local pier=nativeModel("c_pillar_small_bot_m")
 assert(math.abs(pier.boundingInfo.bbMax[3]-3.4)<1e-4)
 local script=resource("light_rail_station.script.lua")
 local con=resource("light_rail_station.con.lua")
 assert(#con.params[1].values==3 and con.params[1].values[3]=="LR_STATION_ELEVATED")
 assert(resource("station_menu.script.lua").checkFenceFn({}, {placement=3})=="Enabled")
 local function key(p)return string.format("%.5f,%.5f,%.5f",p[1]+0,p[2]+0,p[3]+0)end
 for index,L in ipairs({40,60,80,100,120}) do
  for kind=1,2 do for fence=1,2 do
   local p={placement=3,stationType=kind,fence=fence,platformLength=index,seed=42}
   local r=script.updateFn({},p)
   local surface=script.updateFn({}, {placement=1,stationType=kind,fence=fence,platformLength=index,seed=42})
   local sub=r.subconstructions[1]
   local vehicles=kind==1 and 2 or 4
   assert(#sub.laneLists==vehicles+6 and #sub.station.terminals==2)
   for i=1,vehicles do
    local a,b=sub.laneLists[i],surface.subconstructions[1].laneLists[i]
    assert(a.speedLimit==b.speedLimit and a.forwardOnly==b.forwardOnly and a.needsReservation==b.needsReservation)
    for j,node in ipairs(a.nodes) do
     assert(node[1][1]==b.nodes[j][1][1] and node[1][2]==b.nodes[j][1][2] and node[1][3]==8)
     for k=1,3 do assert(node[2][k]==b.nodes[j][2][k],"unchanged vehicle tangents") end
    end
   end
   for _,edge in ipairs(r.edgeLists) do
    assert(edge.edgeType=="BRIDGE" and edge.params.edgeType=="BRIDGE")
    assert(edge.edgeTypeName=="::/infrastructure/bridge/concrete.bridge")
    for _,n in ipairs(edge.edges) do assert(n[1][3]==8) end
    if fence==1 then assert(edge.params.type==surface.edgeLists[1].params.type) end
   end
   local graph,public,curves={},{},{}
   for i=vehicles+1,#sub.laneLists do
    local lane=sub.laneLists[i]
    if lane.linkable then public[#public+1]=lane end
    for j=1,#lane.nodes,2 do
     local a,b=lane.nodes[j],lane.nodes[j+1]
     local ak,bk=key(a[1]),key(b[1])
     assert(ak~=bk,"no zero-length person paths")
     local id=ak<bk and ak.."|"..bk or bk.."|"..ak
     assert(not curves[id],"no duplicate person paths")
     curves[id]=true
     graph[ak]=graph[ak] or {};graph[bk]=graph[bk] or {};graph[ak][bk]=true;graph[bk][ak]=true
    end
   end
   assert(#public==1,"exactly one public entrance, no elevated street links")
   local entry=public[1].nodes[1][1]
   assert(entry[1]==L/2 and entry[2]==-14 and entry[3]==0)
   assert(r.snapPoint.transf[13]==L/2 and r.snapPoint.transf[14]==-14 and r.snapPoint.transf[15]==0)
   local seen,queue={},{key(entry)}
   while #queue>0 do
    local point=table.remove(queue)
    if not seen[point] then seen[point]=true;for n in pairs(graph[point] or {}) do queue[#queue+1]=n end end
   end
   for _,terminal in ipairs(sub.station.terminals) do
    local ref=terminal.vehicleNode
    assert(sub.laneLists[ref[1]+1].nodes[ref[2]+1][1][1]==L/2)
    for _,n in ipairs(terminal.personNodes) do
     local point=sub.laneLists[n[1]+1].nodes[n[2]+1][1]
     assert(point[3]==8.25 and seen[key(point)],"ground entrance reaches both elevated platforms")
    end
   end
   local steps,waists,piers,fascias=0,0,0,0
   local firstTop,lastTop=math.huge,-math.huge
   for _,m in ipairs(sub.models) do
    local t=m.transf
    for _,v in ipairs(t) do assert(v==v and math.abs(v)<1e6) end
    assert(m.id~="mrnickert_ultimate_metro::/surface_underpass.mdl","no incomplete buried stair visual at height")
    if m.id=="::/infrastructure/bridge/concrete/c_6_rep_rep.mdl" then
     if math.abs(t[1]-12/41/6)<1e-8 and math.abs(t[6]-0.6)<1e-8 then
      steps=steps+1;firstTop=math.min(firstTop,t[15]);lastTop=math.max(lastTop,t[15])
     elseif t[3]>0 then
      waists=waists+1
      assert(t[13]==L/2-6 and t[15]==0 and t[3]*6==8.25 and t[1]*6==12)
     elseif t[15]==8 then
      -- No horizontal foundation slab may block either stair shaft.
      local x0,x1=t[13],t[13]+6*t[1]
      local y0,y1=t[14],t[14]+4*t[6]
      for _,side in ipairs({-1,1}) do
       local cy=side*6.5
       local overlaps=x0<L/2+6-1e-6 and x1>L/2-6+1e-6 and y0<cy+1.2-1e-6 and y1>cy-1.2+1e-6
       assert(not overlaps,"real stair opening must remain free of structural deck")
      end
     end
    elseif m.id=="::/infrastructure/bridge/concrete/c_pillar_small_bot_m.mdl" then
     piers=piers+1
     assert(t[15]==0 and math.abs(t[13]-L/2)>=8,"piers clear central stairs/concourse")
     assert(math.abs(t[11]*3.4-6.4)<1e-6,"piers reach crossbeams")
    elseif m.id=="::/infrastructure/bridge/concrete/c_6_rep_l.mdl" or m.id=="::/infrastructure/bridge/concrete/c_6_rep_r.mdl" then
     fascias=fascias+1;assert(t[15]==8.25)
    end
   end
   assert(steps==82 and waists==2 and piers>=4 and fascias>=2,"complete supported structure, both visible stairs and mandatory guards")
   assert(math.abs(firstTop-8.25/41)<1e-8 and lastTop==8.25,"stairs run from ground to platform floor")
   assert(#sub.groundFaces==1 and sub.groundFaces[1].face[1][1]==L/2-8)
   for _,alignment in ipairs(sub.terrainAlignmentLists) do
    for _,face in ipairs(alignment.faces) do for _,point in ipairs(face) do assert(point[3]==0,"never raise terrain to deck height") end end
   end
  end end
 end
 print("PASS: 20 elevated combinations; unchanged vehicle geometry at +8m, exactly one central ground entrance reaches both platforms, 82 visible treads and two supporting waists, clear stair shafts, piers, bridge approaches and safety railings.")
end
