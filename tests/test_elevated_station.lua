return function(resource)
 local concrete=resource("elevated_concrete.mdl")
 local node=concrete.lods[1].node.children[1]
 assert(node.mesh=="mrnickert_ultimate_metro::/elevated_concrete.msh" and not node.skin)
 assert(node.materials[1]=="::/infrastructure/bridge/concrete/mat/c_concrete_unskinned.mtl")
 assert(concrete.boundingInfo.bbMax[1]==6 and concrete.boundingInfo.bbMax[2]==4 and concrete.boundingInfo.bbMin[3]==-2.4)
 assert(not concrete.metadata.transportNetworkProvider)
 for _,file in ipairs({"elevated_concrete_visual.mdl","elevated_entrance.mdl"}) do
  for _,extent in ipairs(resource(file).collider.params.halfExtents) do
   assert(extent==0,"entry visuals cannot obstruct a snapped street")
  end
 end
 for _,file in ipairs({"street_light_eu_c","tram_pole_crossbar"}) do
  local env=setmetatable({},{__index=_G})
  assert(loadfile(arg[1].."/"..file..".mdl","t",env))()
  assert(env.data().boundingInfo.bbMax[3]+1<10.4,"beam clearance must exceed street furniture by at least 1m")
 end
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
     assert(node[1][1]==b.nodes[j][1][1] and node[1][2]==b.nodes[j][1][2] and node[1][3]==12)
     for k=1,3 do assert(node[2][k]==b.nodes[j][2][k],"unchanged vehicle tangents") end
    end
   end
   for _,edge in ipairs(r.edgeLists) do
    assert(edge.edgeType=="BRIDGE" and edge.params.edgeType=="BRIDGE")
    assert(edge.edgeTypeName=="::/infrastructure/bridge/concrete.bridge")
    for _,n in ipairs(edge.edges) do assert(n[1][3]==12) end
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
     assert(point[3]==12.25 and seen[key(point)],"ground entrance reaches both elevated platforms")
    end
   end
   local steps,waists,piers,fascias=0,0,0,0
   local firstTop,lastTop=math.huge,-math.huge
   for _,m in ipairs(sub.models) do
    local t=m.transf
    for _,v in ipairs(t) do assert(v==v and math.abs(v)<1e6) end
    assert(m.id~="mrnickert_ultimate_metro::/surface_underpass.mdl","no incomplete buried stair visual at height")
    if m.id=="mrnickert_ultimate_metro::/elevated_concrete.mdl" then
     if math.abs(t[1]-18/61/6)<1e-8 and math.abs(t[6]-0.6)<1e-8 then
      steps=steps+1;firstTop=math.min(firstTop,t[15]);lastTop=math.max(lastTop,t[15])
     elseif t[3]>0 then
      waists=waists+1
      assert(t[13]==L/2-9 and t[15]==0 and t[3]*6==12.25 and t[1]*6==18)
     elseif t[15]==10.4 then
      piers=piers+1
      assert(math.abs(t[13]+0.75-L/2)>=11.4,"piers clear central stairs/concourse")
      assert(math.abs(t[11]*2.4-10.4)<1e-6,"piers reach crossbeams")
     elseif t[15]==12.25 and math.abs(t[6]-0.25/4)<1e-8 then
      fascias=fascias+1
     elseif t[15]==12 then
      -- No horizontal foundation slab may block either stair shaft.
      local x0,x1=t[13],t[13]+6*t[1]
      local y0,y1=t[14],t[14]+4*t[6]
      for _,side in ipairs({-1,1}) do
       local cy=side*6.5
       local overlaps=x0<L/2+9-1e-6 and x1>L/2-9+1e-6 and y0<cy+1.2-1e-6 and y1>cy-1.2+1e-6
       assert(not overlaps,"real stair opening must remain free of structural deck")
      end
     end
    end
    assert(not m.id:match("^::/infrastructure/bridge/concrete/"),"standalone structure must not use bridge-rig models")

   end
   assert(steps==122 and waists==2 and piers>=4 and fascias>=2,"complete supported structure, both visible stairs and mandatory guards")
   assert(math.abs(firstTop-12.25/61)<1e-8 and lastTop==12.25,"stairs run from ground to platform floor")
   for _,y in ipairs({-2.5,2.5}) do
    for x=(kind==1 and -10 or -30)+0.1,(kind==1 and L+10 or L+4)-0.1,0.5 do
     local covered=false
     for _,m in ipairs(sub.models) do
      local t=m.transf
      if m.id=="mrnickert_ultimate_metro::/elevated_concrete.mdl" and t[15]==12 and t[3]==0 then
       if x>=t[13]-1e-6 and x<=t[13]+6*t[1]+1e-6 and y>=t[14] and y<=t[14]+4*t[6] then covered=true end
      end
     end
     assert(covered,"no gap in rigid track trough")
    end
   end
   local entryVisuals=0
   for _,m in ipairs(sub.models) do
    if m.id=="mrnickert_ultimate_metro::/elevated_entrance.mdl" then entryVisuals=entryVisuals+1;assert(m.transf[15]==0) end
   end
   assert(entryVisuals==1)
   assert(#sub.groundFaces==1 and sub.groundFaces[1].face[1][1]==L/2-10.5)
   for _,alignment in ipairs(sub.terrainAlignmentLists) do
    for _,face in ipairs(alignment.faces) do for _,point in ipairs(face) do assert(point[3]==0,"never raise terrain to deck height") end end
   end
  end end
 end
 print("PASS: 20 elevated combinations; unchanged vehicle geometry at +12m, exactly one central ground entrance reaches both platforms, 122 visible treads and two supporting waists, clear stair shafts, piers, bridge approaches and safety railings.")
end
