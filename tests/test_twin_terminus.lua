local function main()
 local function resource(path)
  local env=setmetatable({_ = function(k)return k end},{__index=_G})
  assert(loadfile(path,"t",env))();return env.data()
 end
 local con=resource("content/twin_terminus.con.lua")
 assert(con.updateScript.fileName=="mrnickert_ultimate_metro::/twin_terminus.script@updateFn")
 assert(con.params[1].key=="crossover" and con.params[1].defaultIndex==2,"crossover enabled by default")
 local script=resource("content/twin_terminus.script.lua")
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
   assert(sub.laneLists[i].nodes[1][1][1]==-100 and sub.laneLists[i].nodes[1][1][2]==y,"internal endpoints match native double tram offsets")
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
   assert(laneIndex==track-1 and point[1]==40 and point[2]==(track==1 and -6 or 6),"internal terminal actually targets its own platform midpoint")
   for _,reference in ipairs(terminal.personNodes) do
    local lane=assert(sub.laneLists[reference[1]+1])
    assert(lane.transportModes[1]=="PERSON" and lane.nodes[reference[2]+1],"passenger references adjust with crossover option")
   end
   for approach,y in ipairs({-2.5,2.5}) do
    local from=vector({-100,y,0},1);local to=vector(point,1)
    assert(reachable(from,to)==(setting==2 or approach==track),"both approaches reach both platforms only when crossover is present")
   end
  end
  if setting==2 then
   local degree=0;for _ in pairs(graph["-40.000000,0.000000,0.000000"] or {}) do degree=degree+1 end
   assert(degree==4,"explicit four-arm shared crossover coordinate")
  end
  assert(sub.laneLists[#sub.laneLists].linkable,"public pedestrian access")
  assert(#sub.models>4,"existing rail model visuals generated")
  for _,model in ipairs(sub.models) do
   for _,value in ipairs(model.transf) do assert(value==value and math.abs(value)<1e6,"decorative transforms finite") end
  end
 end
 print("PASS: straight external approach, four-mode internal switch topology, both terminals, crossover-on/off reachability and finite decorative geometry. Native acceptance still requires a game test.")
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),"\n");os.exit(1) end
