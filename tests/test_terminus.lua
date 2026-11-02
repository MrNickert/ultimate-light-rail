local nativeRequire=require
function require(name)
 local path=name:match("^mrnickert_ultimate_metro::/(.+)$")
 if path then return assert(loadfile("content/"..path))() end
 return nativeRequire(name)
end
local function main()
 local function resource(path)
  local env=setmetatable({_ = function(k)return k end},{__index=_G})
  assert(loadfile(path,"t",env))();return env.data()
 end
 local con=resource("content/twin_terminus.con.lua")
 assert(con.updateScript.fileName=="mrnickert_ultimate_metro::/twin_terminus.script@updateFn")
 assert(con.params[1].key=="crossover" and con.params[1].defaultIndex==2,"crossover enabled by default")
 local approach=resource("content/lightrail_double.street_template.lua")
 assert(#approach.menuCategory.categories==0,"saved station approach remains loadable but is hidden from building menu")
 assert(approach.roadType=="STREET" and #approach.laneConfigs==2,"station approach topology preserved")
 for _,lane in ipairs(approach.laneConfigs) do
  local modes={};for _,mode in ipairs(lane.transportModes) do modes[mode]=true end
  assert(modes.TRAM and modes.ELECTRIC_TRAM and modes.TRAM_TRACK and modes.ELECTRIC_TRAM_TRACK,"required internal approach modes retained")
 end
 local script=resource("content/twin_terminus.script.lua")
 local shared=require "mrnickert_ultimate_metro::/terminus_util.lua"
 local function equal(a,b)
  if type(a)~=type(b) then return false end
  if type(a)~="table" then return a==b end
  for k,v in pairs(a)do if not equal(v,b[k])then return false end end
  for k in pairs(b)do if a[k]==nil then return false end end
  return true
 end
 local function vector(v,sign)return string.format("%.6f,%.6f,%.6f",v[1]*sign+0,v[2]*sign+0,v[3]*sign+0)end
 local function key(n)return vector(n[1],1)end
 for _,setting in ipairs({1,2}) do
  local r=script.updateFn({}, {crossover=setting})
  local sub=r.subconstructions[1]
  assert(#r.edgeLists==1 and #r.edgeLists[1].edges==2,"only one straight root STREET segment, no rejected street junctions")
  assert(r.edgeLists[1].params.type=="mrnickert_ultimate_metro::/lightrail_double.street_template")
  assert(r.edgeLists[1].snapNodes[1]==0 and #r.edgeLists[1].snapNodes==1,"only front endpoint is free")
  assert(#sub.station.terminals==2,"two platform terminals")
  local graph,seen={},{}
  local vehicles=setting==2 and 4 or 2
  local undecorated=shared({}, {crossover=setting})
  assert(equal(r.edgeLists,undecorated.edgeLists) and equal(r.snapPoint,undecorated.snapPoint),"surface decoration preserves track approach and snapping")
  assert(equal(sub.station.terminals,undecorated.subconstructions[1].station.terminals),"surface decoration preserves terminal and passenger references")
  for i=1,vehicles do assert(equal(sub.laneLists[i],undecorated.subconstructions[1].laneLists[i]),"vehicle lanes, speed and reservation flags unchanged")end
  assert(#sub.laneLists==vehicles+4,"vehicle and passenger lane counts follow crossover option")
  local function connect(a,b)
   a,b=key(a),key(b);graph[a]=graph[a] or {};graph[b]=graph[b] or {}
   graph[a][b]=true;graph[b][a]=true
  end
  for i=1,vehicles do
   local lane=sub.laneLists[i]
   assert(lane.forwardOnly==false and lane.needsReservation==true,"explicit internal rail-style direction and reservation flags")
   local modes={};for _,mode in ipairs(lane.transportModes) do modes[mode]=true end
   assert(modes.TRAM and modes.ELECTRIC_TRAM and modes.TRAM_TRACK and modes.ELECTRIC_TRAM_TRACK,"all measured modes on every internal vehicle lane")
   for j=1,#lane.nodes,2 do
    local a,b=lane.nodes[j],lane.nodes[j+1]
    local forward=key(a).."|"..vector(a[2],1).."|"..key(b).."|"..vector(b[2],1)
    local reverse=key(b).."|"..vector(b[2],-1).."|"..key(a).."|"..vector(a[2],-1)
    assert(not seen[forward] and not seen[reverse],"no duplicate opposite vehicle curves")
    seen[forward]=true
    assert(a[1][1]<b[1][1] and a[2][1]>0 and b[2][1]>0,"no vehicle turnaround curve")
    connect(a,b)
   end
  end
  for i,y in ipairs({-2.5,2.5}) do
   assert(sub.laneLists[i].nodes[1][1][1]==-30 and sub.laneLists[i].nodes[1][1][2]==y,"internal endpoints match native double tram offsets")
  end
  local function reachable(a,b)
   local visited,queue={},{a}
   while #queue>0 do
    local node=table.remove(queue)
    if node==b then return true end
    if not visited[node] then visited[node]=true;for other in pairs(graph[node] or {}) do queue[#queue+1]=other end end
   end
   return false
  end
  for track,terminal in ipairs(sub.station.terminals) do
   local laneIndex,nodeIndex=terminal.vehicleNode[1],terminal.vehicleNode[2]
   local point=assert(sub.laneLists[laneIndex+1].nodes[nodeIndex+1])[1]
   assert(laneIndex==track-1 and point[1]==40 and point[2]==(track==1 and -2.5 or 2.5),"internal terminal actually targets its own platform midpoint")
   for _,reference in ipairs(terminal.personNodes) do
    local lane=assert(sub.laneLists[reference[1]+1])
    assert(lane.transportModes[1]=="PERSON" and lane.nodes[reference[2]+1],"passenger references adjust with crossover option")
   end
   for approach,y in ipairs({-2.5,2.5}) do
    local from=vector({-30,y,0},1);local to=vector(point,1)
    assert(reachable(from,to)==(setting==2 or approach==track),"both approaches reach both platforms only when crossover is present")
   end
  end
  if setting==2 then
   local degree=0;for _ in pairs(graph["-15.000000,0.000000,0.000000"] or {}) do degree=degree+1 end
   assert(degree==4,"explicit four-arm shared crossover coordinate")
   for _,i in ipairs({3,4}) do
    local lane=sub.laneLists[i]
    local first,last=lane.nodes[1],lane.nodes[#lane.nodes]
    assert(first[1][1]==-30 and last[1][1]==0,"30m crossover envelope")
    assert(first[2][2]==0 and last[2][2]==0,"switch endpoints tangent to main tracks, not angled junctions")
    local before,after=lane.nodes[2][2],lane.nodes[3][2]
    assert(before[1]==after[1] and before[2]==after[2],"crossover midpoint has continuous tangents")
   end
  end
  assert(sub.laneLists[#sub.laneLists].linkable,"public pedestrian access")
  for i=vehicles+1,#sub.laneLists do
   for _,node in ipairs(sub.laneLists[i].nodes)do assert(node[1][3]==0.25,"pedestrians stand on the low platform floor")end
  end
  local slabs=0;local platforms=0;local poles=0;local heads=0;local trees=0;local flowers=0;local ribbons=0;local paving=0
  for _,model in ipairs(sub.models)do
   if model.id=="mrnickert_ultimate_metro::/surface_platform.mdl" then
    slabs=slabs+1
    assert(model.transf[11]>0.3,"no flattened platform mesh overlapping the asphalt ground")
    if math.abs(model.transf[14])==6.5 then
     platforms=platforms+1
     assert(model.transf[13]==0 or model.transf[13]==40,"two consecutive native 40m slabs per platform")
     assert(math.abs(model.transf[11]*0.8-0.25)<1e-9,"walking floor matches native mesh height")
    end
   elseif model.id=="mrnickert_ultimate_metro::/surface_head_tile.mdl" then
    heads=heads+1
    assert(model.transf[1]==1 and model.transf[6]==0.9,"head tiles retain their native paving scale")
    assert(model.transf[13]==85,"head tiles fill a single 5m row")
   elseif model.id=="mrnickert_ultimate_metro::/tram_paving.mdl" then
    paving=paving+1
    assert(model.transf[15]>=0.008 and model.transf[15]<0.009,"native paving above gravel, below rail texture")
   elseif model.id=="mrnickert_ultimate_metro::/tram_ribbon.mdl" then
    ribbons=ribbons+1
    assert(model.transf[15]>=0.015 and model.transf[15]<=0.018001,"tram decals clear the ground and have separate switch layers")
   elseif model.id=="::/assets/vegetation/trees/apple_01/apple_01.mdl" then
    trees=trees+1
    assert(model.transf[13]==83.8 and math.abs(model.transf[14])==5.5,"trees only at the compact head, clear of central entrance")
    assert(model.transf[13]-2.83192*model.transf[1]>81,"tree crowns stay beyond the end of the overhead wires")
    assert(model.transf[13]-1.02263>82.5,"tree bed footprint clears the cross-platform walking corridor")
   elseif model.id=="::/assets/buildings/res/flower_pots/raised_bed_c.mdl" then
    flowers=flowers+1
    assert(model.transf[13]>=81.2 and model.transf[13]<=83.8 and math.abs(model.transf[14])==8.2,"all planters on the compact head plaza, no side greenery")
   elseif model.id=="::/assets/streets/tram_pole_crossbar.mdl" then poles=poles+1 end
  end
  assert(slabs==4 and platforms==4 and heads==2 and poles==10,"80m platforms and one 5m head row")
  assert(trees==2 and flowers==4 and ribbons>400 and paving==ribbons,"each rail strip has its native paving layer; greenery retained")
  assert(sub.groundFaces[1].modes[1].key=="::/infrastructure/street/shared/street_fill.gtex","native gravel underlay retained below the paving")
  local throat=sub.groundFaces[2].face
  local approachWidth=0;for _,config in ipairs(approach.laneConfigs)do approachWidth=approachWidth+config.width end
  assert(throat[1][1]==-30 and throat[2][1]==0,"wider underlay only covers switch throat")
  assert(throat[4][2]-throat[1][2]==approachWidth,"throat ground matches native approach width")
  local entry=sub.laneLists[#sub.laneLists]
  assert(entry.nodes[1][1][1]==81.5 and entry.nodes[#entry.nodes][1][1]==85,"public access follows shortened head")
  local pedestrianGraph={}
  for i=vehicles+1,#sub.laneLists do
   local lane=sub.laneLists[i]
   for j=1,#lane.nodes,2 do
    local a,b=lane.nodes[j],lane.nodes[j+1]
    local from,to=key(a),key(b)
    pedestrianGraph[from]=pedestrianGraph[from] or {};pedestrianGraph[to]=pedestrianGraph[to] or {}
    pedestrianGraph[from][to]=true;pedestrianGraph[to][from]=true
    for k=1,3 do
     assert(math.abs(a[2][k]-(b[1][k]-a[1][k]))<1e-9 and a[2][k]==b[2][k],"pedestrian tangents match remapped segment lengths")
    end
   end
  end
  local pending={key(entry.nodes[#entry.nodes])};local reached={}
  while #pending>0 do
   local point=table.remove(pending)
   if not reached[point]then reached[point]=true;for other in pairs(pedestrianGraph[point]or{})do pending[#pending+1]=other end end
  end
  for _,terminal in ipairs(sub.station.terminals)do
   for _,ref in ipairs(terminal.personNodes)do
    assert(reached[key(sub.laneLists[ref[1]+1].nodes[ref[2]+1])],"shortened public path reaches both platform terminals")
   end
  end
  for _,alignment in ipairs(sub.terrainAlignmentLists)do
   for _,face in ipairs(alignment.faces)do for _,point in ipairs(face)do assert(point[1]<=87,"terrain footprint shortened by 5m")end end
  end
  assert(#sub.models>4,"existing rail model visuals generated")
  assert(r.edgeLists[1].edges[1][1][1]==-40 and r.edgeLists[1].edges[2][1][1]==-30,"10m entry replaces long approach")
  for i=1,2 do
   for _,node in ipairs(sub.laneLists[i].nodes) do
    assert(node[1][2]==(i==1 and -2.5 or 2.5),"native 5m spacing without flared track")
   end
  end
  for _,model in ipairs(sub.models) do
   assert(not model.id:find("_standard.mdl",1,true),"no sleeper-track models or railway buffers")
   if model.id:find("single_rail.mdl",1,true) then
    assert(model.transf[15]>5,"rail mesh is used only for overhead wires; ground uses native tram texture")
   end
   for _,value in ipairs(model.transf) do assert(value==value and math.abs(value)<1e6,"decorative transforms finite") end
  end
 end
 local platform=resource("content/surface_platform.mdl")
 assert(not platform.metadata.transportNetworkProvider,"visual platform never adds native passenger or vehicle lanes")
 local pavingModel=resource("content/tram_paving.mdl").lods[1].node.children[1]
 local railModel=resource("content/tram_ribbon.mdl").lods[1].node.children[1]
 assert(pavingModel.mesh==railModel.mesh,"native paving and rail textures use the same strip mapping")
 assert(pavingModel.materials[1]=="::/infrastructure/street/tram/mat/new_medium_tram_paving.mtl","standard native tram fill material")
 assert(railModel.materials[1]=="::/infrastructure/street/tram/mat/new_medium_tram_track.mtl","standard native tram rail material")
 for _,path in ipairs({"content/surface_head_tile.mdl","content/tram_ribbon.mdl","content/tram_paving.mdl"})do
  local model=resource(path)
  assert(not model.metadata.transportNetworkProvider,"new visual assets add no network lanes")
 end
 print("PASS: unchanged vehicle paths, both terminals and crossover options; low visible platforms, passenger floor height, visual-only model metadata, paving and masts. Appearance and boarding need an in-game check.")
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),"\n");os.exit(1) end
