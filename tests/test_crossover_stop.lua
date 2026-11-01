local function main()
local function resource(path)
 local env=setmetatable({_ = function(k)return k end},{__index=_G})
 assert(loadfile(path,"t",env))();return env.data()
end
local script=resource("content/crossover_stop.script.lua")
local con=resource("content/crossover_stop.con.lua")
assert(con.updateScript.fileName:find("crossover_stop.script",1,true))
for selected,length in ipairs({60,80,120}) do
 local r=script.updateFn({}, {platformLength=selected})
 local half=length/2
 local sub=r.subconstructions[1]
 assert(#r.edgeLists==1,"only one double-track approach, no hidden exit/loop")
 assert(r.edgeLists[1].params.type=="::/infrastructure/street/tram/tram_new.street_template")
 assert(#sub.station.terminals==2,"two individually selectable platforms")
 assert(r.snapPoint.transf[13]==-half-50,"snap anchor at approach endpoint")
 assert(r.edgeLists[1].edges[1][1][1]==r.snapPoint.transf[13])
 assert(sub.laneLists[8].linkable,"public pedestrian connection")
 assert(sub.groundFaces and #sub.groundFaces==4 and not r.groundFaces,"ground belongs to subconstruction")
 assert(sub.terrainAlignmentLists and not r.terrainAlignmentLists,"terrain belongs to subconstruction")
 -- Native snapping aligns the frame's X axis along the existing road. For a
 -- collinear approach, frame X must be perpendicular to the station track.
 local snap=r.snapPoint.transf
 assert(snap[1]==0 and snap[2]==-1 and snap[5]==1 and snap[6]==0,"snap frame rotated for inline placement")
 assert(-snap[5]==-1 and -snap[6]==0,"outward snap axis agrees with approach direction")
 local graph={}
 local function key(p)return table.concat(p,",")end
 local function connect(a,b)
  a,b=key(a),key(b)
  graph[a]=graph[a] or {};graph[b]=graph[b] or {}
  graph[a][b]=true
 end
 for i=1,4 do
  local l=sub.laneLists[i]
  assert(l.forwardOnly==false and l.needsReservation==false,"bidirectional lanes use native tram reservation defaults")
  for n=1,#l.nodes,2 do
   local a,b=l.nodes[n],l.nodes[n+1]
   assert(b[1][1]>a[1][1],"no vehicle turnaround curve")
   connect(a[1],b[1])
  end
 end
 local function reachable(a,b)
  local target=key(b);local seen={};local queue={key(a)}
  while #queue>0 do
   local p=table.remove(queue)
   if p==target then return true end
   if not seen[p] then
    seen[p]=true
    for neighbor in pairs(graph[p] or {}) do queue[#queue+1]=neighbor end
   end
  end
  return false
 end
 for _,y in ipairs({-2.5,2.5}) do
  for _,platformY in ipairs({-2.5,2.5}) do
   assert(reachable({-half-30,y,0},{0,platformY,0}),"each approach lane reaches both platforms")
   assert(not reachable({0,platformY,0},{-half-30,y,0}),"known missing return route remains unresolved")
  end
 end
 for i,terminal in ipairs(sub.station.terminals) do
  local laneIndex,nodeIndex=terminal.vehicleNode[1],terminal.vehicleNode[2]
  local stop=sub.laneLists[laneIndex+1].nodes[nodeIndex+1][1]
  assert(stop[1]==0 and stop[2]==(i==1 and -2.5 or 2.5),"declared terminal actually references platform midpoint")
 end
 for i=3,4 do
  local l=sub.laneLists[i]
  assert(l.nodes[1][2][2]==0 and l.nodes[2][2][2]==0,"smooth horizontal turnout tangents")
  assert(l.nodes[1][1][2]==-l.nodes[2][1][2],"crosses between distinct tracks")
 end
end
print("PASS: inbound crossover topology, known missing return path, platform references and placement at all lengths. Native routing, crossing safety and reversal need game testing.")
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),"\n");os.exit(1) end
