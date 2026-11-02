return function(resource)
 local concrete=resource("elevated_concrete.mdl")
 local node=concrete.lods[1].node.children[1]
 assert(node.mesh=="mrnickert_ultimate_metro::/elevated_concrete.msh" and not node.skin)
 assert(node.materials[1]=="::/infrastructure/bridge/concrete/mat/c_concrete_unskinned.mtl")
 assert(concrete.boundingInfo.bbMax[1]==6 and concrete.boundingInfo.bbMax[2]==4 and concrete.boundingInfo.bbMin[3]==-2.4)
 assert(not concrete.metadata.transportNetworkProvider)
 local roof=resource("elevated_platform_roof.mdl")
 assert(not roof.metadata.transportNetworkProvider and roof.metadata.lightSourceList)
 local function checkRoofNode(node)
  assert(not node.skin,"native canopy must be rigid")
  if node.mesh then assert(not node.mesh:find("feets",1,true),"fixed roof supports must not land in stair holes") end
  for _,child in ipairs(node.children or {}) do checkRoofNode(child) end
 end
 for _,lod in ipairs(roof.lods) do checkRoofNode(lod.node) end
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
 local entrance=resource("elevated_entrance.mdl")
 for _,lod in ipairs(entrance.lods) do
  for _,child in ipairs(lod.node.children) do
   assert(child.mesh:find("::/assets/buildings/res/grd_frn/msh/era_c_park_bench_01_",1,true)==1)
   for _,material in ipairs(child.materials) do assert(material:sub(1,3)=="::/","native material must use base namespace") end
  end
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
   assert(entry[1]==L/2 and entry[2]==-14 and entry[3]==0.15)
   local frame=r.snapPoint.transf
   local apron=sub.groundFaces[1].face
   -- A road snapped along this tangent must follow the frontage, not cross
   -- the station's pier rows. Its inward normal must point to the public node.
   local frontage={apron[2][1]-apron[1][1],apron[2][2]-apron[1][2]}
   assert(math.abs(frame[1]*frontage[2]-frame[2]*frontage[1])<1e-6,"road tangent parallel to entrance frontage")
   local delta={entry[1]-frame[13],entry[2]-frame[14],entry[3]-frame[15]}
   assert(math.abs(delta[1]*frame[1]+delta[2]*frame[2])<1e-6,"entry centred on snap frame")
   assert(math.abs(delta[1]*frame[5]+delta[2]*frame[6]-1)<1e-6,"public node 1m inward from snap line")
   assert(frame[13]==L/2 and frame[14]==-15 and frame[15]==0)
   -- A street running along the frontage must stay clear of all solid
   -- near-ground structural boxes (including the piers).
   for _,m in ipairs(sub.models) do
    local t=m.transf
    if m.id=="mrnickert_ultimate_metro::/elevated_concrete.mdl" then
     local minZ=t[15]-2.4*t[11]+math.min(0,6*t[3])
     if minZ<9.5 then
      assert(t[14]>frame[14]+1,"low structure cannot cross the snapped street frontage")
     end
    end
   end
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
      assert(t[13]==L/2-9 and t[15]==0.15 and math.abs(t[3]*6-12.1)<1e-8 and t[1]*6==18)
     elseif t[15]==10.4 then
      piers=piers+1
      assert(math.abs(t[13]+0.75-L/2)>=10.5-1e-8,"piers clear central stairs/concourse")
      assert(math.abs(t[11]*2.4-10.4)<1e-6,"piers reach crossbeams")
      local distance=math.abs(t[13]+0.75-L/2)
      assert(math.abs((distance-10.5)/20-math.floor((distance-10.5)/20+0.5))<1e-8,"pier rows anchored at plaza sides every 20m")
      for _,side in ipairs({-1,1}) do
       local roadCentre=L/2+side*20.5
       assert(t[13]+1.5<=roadCentre-8 or t[13]>=roadCentre+8,"standard 16m road clears pier solids")
      end
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
   local first,last=kind==1 and -10 or -30,kind==1 and L+10 or L+4
   local roofs={[-1]={},[1]={}}
   local posts,trees,planters=0,0,0
   for _,m in ipairs(sub.models) do
    local t=m.transf
    if m.id=="mrnickert_ultimate_metro::/elevated_platform_roof.mdl" then
     local side=t[14]<0 and -1 or 1
     roofs[side][#roofs[side]+1]={t[13],t[13]+40*t[1]}
     assert(t[6]==1 and t[11]==1 and t[15]==12.25-1.1,"canopy retains native width and height")
     assert(t[15]+roof.boundingInfo.bbMax[3]<17.5,"roof must clear longitudinal contact wire")
    elseif m.id=="::/assets/stations/rail/era_c_perron_pillar.mdl" then
     posts=posts+1
     assert(t[13]<=L/2-10 or t[13]>=L/2+10,"roof supports clear stair openings")
    elseif m.id=="::/assets/streets/tram_pole_crossbar.mdl" then
     assert(math.abs(t[14])==9.8 and t[13]>=first+0.5 and t[13]<=last-0.5)
     local wireY=t[14]+3.13368*t[6]
     assert(math.abs(math.abs(wireY)-2.5)<1e-6,"outboard mast still supports the same contact wire")
     assert(t[15]==12.25)
    elseif m.id=="::/assets/vegetation/trees/apple_01/apple_01.mdl" then
     trees=trees+1;assert(t[15]==0.15 and t[14]>-11,"tree behind free bus-stop frontage")
    elseif m.id=="::/assets/buildings/res/flower_pots/raised_bed_c.mdl" then
     planters=planters+1
     assert(math.abs(t[13]-L/2)>3 and t[14]>-11,"planter clear of central entrance and street frontage")
    end
   end
   assert(posts>=8 and trees==2 and planters==4)
   for _,segments in pairs(roofs) do
    table.sort(segments,function(a,b)return a[1]<b[1]end)
    local endpoint=first
    for _,segment in ipairs(segments) do assert(math.abs(segment[1]-endpoint)<1e-6);endpoint=segment[2] end
    assert(math.abs(endpoint-last)<1e-6,"canopy covers whole structural platform length")
   end
   -- Both inner and outer walking strips remain floored over the full asset,
   -- including the terminus crossover sides; the stair channel stays open.
   for _,side in ipairs({-1,1}) do for _,y in ipairs({4.65,8.35}) do
    for x=first+0.1,last-0.1,0.5 do
     local covered=false
     for _,m in ipairs(sub.models) do
      local t=m.transf
      if m.id=="mrnickert_ultimate_metro::/surface_platform.mdl" and x>=t[13]-1e-6 and x<=t[13]+40*t[1]+1e-6
       and side*y>=t[14]-2.5*t[6]-1e-6 and side*y<=t[14]+2.5*t[6]+1e-6 then covered=true end
     end
     assert(covered,"platform deck continues to both structural ends")
    end
   end end
   assert(math.abs(firstTop-(0.15+12.1/61))<1e-8 and lastTop==12.25,"stairs run from ground to platform floor")
   for _,y in ipairs({-2.5,2.5}) do
    for x=(kind==1 and -10 or -30)+0.1,(kind==1 and L+10 or L+4)-0.1,0.5 do
     local covered=false
     for _,m in ipairs(sub.models) do
      local t=m.transf
      if m.id=="mrnickert_ultimate_metro::/elevated_concrete.mdl" and math.abs(t[15]-11.96)<1e-8 and t[3]==0 then
       if x>=t[13]-1e-6 and x<=t[13]+6*t[1]+1e-6 and y>=t[14] and y<=t[14]+4*t[6] then covered=true end
      end
     end
     assert(covered,"no gap in rigid track trough")
    end
   end
   local entryVisuals,paving=0,0
   for _,m in ipairs(sub.models) do
    if m.id=="mrnickert_ultimate_metro::/elevated_paving.mdl" then
     paving=paving+1;assert(m.transf[15]==0.151 and m.transf[1]==1 and m.transf[6]<=1)
    end
    if m.id=="mrnickert_ultimate_metro::/elevated_entrance.mdl" then entryVisuals=entryVisuals+1;assert(m.transf[15]==0.15 and m.transf[13]==L/2+2.8 and m.transf[2]==-1) end
   end
   assert(entryVisuals==1 and paving==56,"complete tiled entrance sidewalk")
   assert(#sub.groundFaces==1 and sub.groundFaces[1].face[1][1]==L/2-10.5)
   for _,alignment in ipairs(sub.terrainAlignmentLists) do
    for _,face in ipairs(alignment.faces) do for _,point in ipairs(face) do assert(point[3]==0,"never raise terrain to deck height") end end
   end
  end end
 end
 print("PASS: 20 elevated combinations; unchanged vehicle geometry at +12m, exactly one central ground entrance reaches both platforms, 122 visible treads and two supporting waists, clear stair shafts, piers, bridge approaches and safety railings.")
end
