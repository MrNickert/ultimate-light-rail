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
 local graph={}
 local function key(p)return table.concat(p,",")end
 local function connect(a,b)
  a,b=key(a),key(b)
  graph[a]=graph[a] or {};graph[b]=graph[b] or {}
  graph[a][b]=true;graph[b][a]=true
 end
 for i=1,4 do
  local l=sub.laneLists[i]
  assert(l.forwardOnly==false and l.needsReservation,"bidirectional reserved vehicle lanes")
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
   assert(reachable({0,platformY,0},{-half-30,y,0}),"each platform reaches both approach lanes")
  end
 end
 for i,terminal in ipairs(sub.station.terminals) do
  assert(terminal.vehicleNode[1]==i-1 and terminal.vehicleNode[2]==2)
  assert(sub.laneLists[i].nodes[4][1][1]==0,"terminal references platform midpoint")
 end
 for i=3,4 do
  local l=sub.laneLists[i]
  assert(l.nodes[1][2][2]==0 and l.nodes[2][2][2]==0,"smooth horizontal turnout tangents")
  assert(l.nodes[1][1][2]==-l.nodes[2][1][2],"crosses between distinct tracks")
 end
end
print("PASS: crossover topology, both platforms, approach alignment and all platform lengths. Native routing, crossing safety and reversal need game testing.")
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),"\n");os.exit(1) end
