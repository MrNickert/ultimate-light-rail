local function main()
 local function resource(path)
  local env=setmetatable({_ = function(k)return k end},{__index=_G})
  assert(loadfile(path,"t",env))();return env.data()
 end
 local con=resource("content/twin_terminus.con.lua")
 assert(con.updateScript.fileName=="mrnickert_ultimate_metro::/twin_terminus.script@updateFn")
 local r=resource("content/twin_terminus.script.lua").updateFn({}, {})
 local sub=r.subconstructions[1]
 assert(#r.edgeLists==5 and #sub.station.terminals==2,"approach, two main tracks and two crossover routes")
 local single=resource("content/mode_probe.street_template.lua")
 local double=resource("content/lightrail_double.street_template.lua")
 local profiles={
  ["mrnickert_ultimate_metro::/mode_probe.street_template"]=single,
  ["mrnickert_ultimate_metro::/lightrail_double.street_template"]=double,
 }
 local function vector(v,sign)return string.format("%.6f,%.6f,%.6f",v[1]*sign+0,v[2]*sign+0,v[3]*sign+0)end
 local function nodeKey(n)return vector(n[1],1)end
 local seen,graph,root={},{},{}
 local function connect(a,b)
  a,b=nodeKey(a),nodeKey(b)
  graph[a]=graph[a] or {};graph[b]=graph[b] or {}
  graph[a][b]=true;graph[b][a]=true
 end
 for listIndex,list in ipairs(r.edgeLists) do
  assert(list.type=="STREET" and list.params.tramTrackType=="ELECTRIC","real electric tram street segments")
  local profile=assert(profiles[list.params.type])
  if listIndex==1 then
   assert(#list.snapNodes==1 and list.snapNodes[1]==0 and #profile.laneConfigs==2,"only the double front end connects externally")
  else assert(#list.snapNodes==0 and #list.freeNodes==0 and #profile.laneConfigs==1,"platforms and switches use fixed single-lane edges") end
  for _,node in ipairs(list.edges) do root[#root+1]={node=node,profile=profile} end
  for i=1,#list.edges,2 do
   local a,b=list.edges[i],list.edges[i+1]
   local f=nodeKey(a).."|"..vector(a[2],1).."|"..nodeKey(b).."|"..vector(b[2],1)
   local rev=nodeKey(b).."|"..vector(b[2],-1).."|"..nodeKey(a).."|"..vector(a[2],-1)
   assert(not seen[f] and not seen[rev],"no duplicate or coincident reverse curve")
   seen[f]=true
   assert(b[1][1]>a[1][1] and a[2][1]>0 and b[2][1]>0,"no constructed vehicle turnaround curve")
   local c1={a[1][1]+a[2][1]/3,a[1][2]+a[2][2]/3}
   local c2={b[1][1]-b[2][1]/3,b[1][2]-b[2][2]/3}
   assert(a[1][1]<=c1[1] and c1[1]<=c2[1] and c2[1]<=b[1][1],"Bezier curve cannot turn backwards between endpoints")
   assert(math.abs(c1[2])<=6 and math.abs(c2[2])<=6,"switch curves remain within track envelope")
   connect(a,b)
  end
 end
 for i,terminal in ipairs(sub.station.terminals) do
  assert(terminal.vehicleNode[1]==-1,"direct root binding")
  local selected=assert(root[terminal.vehicleNode[2]+1])
  assert(#selected.profile.laneConfigs==1,"terminal never points into ambiguous double approach")
  assert(selected.node[1][1]==40 and selected.node[1][2]==(i==1 and -6 or 6),"both terminals actually resolve to distinct platform midpoints")
  for _,reference in ipairs(terminal.personNodes) do
   assert(sub.laneLists[reference[1]+1].nodes[reference[2]+1],"pedestrian references exist")
  end
 end
 local function reachable(a,b)
  local seen,queue={}, {a}
  while #queue>0 do
   local n=table.remove(queue)
   if n==b then return true end
   if not seen[n] then seen[n]=true;for nextNode in pairs(graph[n] or {}) do queue[#queue+1]=nextNode end end
  end
  return false
 end
 for _,y in ipairs({-6,6}) do
  local target=vector({40,y,0},1)
  assert(reachable("-130.000000,0.000000,0.000000",target) and reachable(target,"-130.000000,0.000000,0.000000"),"physical root graph connects each platform to approach and back")
 end
 local crossing=graph["-40.000000,0.000000,0.000000"]
 local degree=0;for _ in pairs(crossing or {}) do degree=degree+1 end
 assert(degree==4,"crossovers share an explicit four-arm coordinate")
 for _,lane in ipairs(sub.laneLists) do for _,mode in ipairs(lane.transportModes) do assert(mode=="PERSON","no internal vehicle lane workaround") end end
 assert(sub.laneLists[4].linkable,"public passenger entrance")
 assert(r.snapPoint.transf[13]==-130 and r.snapPoint.transf[2]==-1,"front approach snap frame")
 print("PASS: distinct terminal bindings, connected root graph, explicit crossover coordinate and no duplicate curves. Native junctions, placement and platform routes still require game testing.")
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),"\n");os.exit(1) end
