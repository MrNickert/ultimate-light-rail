local function main()
 local function resource(path)
  local env=setmetatable({_ = function(k)return k end},{__index=_G})
  assert(loadfile(path,"t",env))();return env.data()
 end
 local result=resource("content/direction_probe.script.lua").updateFn({}, {})
 assert(#result.edgeLists==3,"three independent references")
 assert(not result.subconstructions[1].station and not result.subconstructions[1].laneLists,"fixture adds no terminal or vehicle lanes")
 for i,row in ipairs(result.edgeLists) do
  assert(#row.edges==2,"one physical segment per reference")
  assert(#row.snapNodes==0 and #row.freeNodes==0,"isolated fixed test endpoints")
  assert(row.edges[1][1][2]==(i-1)*20 and row.edges[2][1][2]==(i-1)*20,"rows do not overlap")
  assert(row.edges[1][1][1]==-20 and row.edges[2][1][1]==20,"same straight baseline geometry")
 end
 assert(result.edgeLists[1].type=="STREET" and result.edgeLists[2].type=="STREET" and result.edgeLists[3].type=="TRACK")
 local baseline=resource("content/edge_test.street_template.lua")
 local mixed=resource("content/mode_probe.street_template.lua")
 assert(#mixed.laneConfigs==1 and mixed.roadType=="STREET","mode experiment preserves one street lane")
 assert(#mixed.laneConfigs[1].transportModes==4 and #mixed.transportModesStreet==4)
 local function equal(a,b)
  if type(a)~=type(b) then return false end
  if type(a)~="table" then return a==b end
  for k,v in pairs(a) do if not equal(v,b[k]) then return false end end
  for k in pairs(b) do if a[k]==nil then return false end end
  return true
 end
 mixed.laneConfigs[1].transportModes=baseline.laneConfigs[1].transportModes
 mixed.transportModesStreet=baseline.transportModesStreet
 assert(equal(baseline,mixed),"A/B experiment changes only transport mode sets")
 local objects={
  [1]={CONSTRUCTION={fileName="mrnickert_ultimate_metro::/direction_probe.con",frozenEdges={11,12,13}}},
  [2]={CONSTRUCTION={fileName="mrnickert_ultimate_metro::/edge_stop.con",frozenEdges={14}}},
 }
 local tm={TRAM="TRAM",ELECTRIC_TRAM="ELECTRIC_TRAM",TRAM_TRACK="TRAM_TRACK",ELECTRIC_TRAM_TRACK="ELECTRIC_TRAM_TRACK"}
 for i,id in ipairs({11,12,13}) do
  objects[id]={BASE_EDGE={roadTemplate=result.edgeLists[i].params.type},
   TRANSPORT_NETWORK={edges={{conns={{entity=id,index=0},{entity=id,index=1}},
    transportModes=i==3 and {TRAM_TRACK=true,ELECTRIC_TRAM_TRACK=true} or {TRAM=true,ELECTRIC_TRAM=true},
    forwardOnly=i~=3,needsReservation=i==3}}}}
 end
 local output,queries={},{}
 api={type={ComponentType={CONSTRUCTION="CONSTRUCTION",BASE_EDGE="BASE_EDGE",TRANSPORT_NETWORK="TRANSPORT_NETWORK"},["enum"]={TransportMode=tm}},
  engine={getEntitiesWithComponent=function() return {1,2} end,
   getComponent=function(id,kind)return objects[id] and objects[id][kind]end,
   util={pathfinding={findPathNodeToNode=setmetatable({}, {__call=function(_,from,to,modes)
    queries[#queries+1]={from=from[1],to=to[1],mode=modes[1]}
    if from[1].entity==13 and modes[1]=="ELECTRIC_TRAM_TRACK" then return {{}} end
    if from[1].index==0 and modes[1]=="TRAM" then return {{}} end
    return {}
   end})}}},cmd=setmetatable({}, {__index=function()error("world commands forbidden")end})}
 log={message=function(s)output[#output+1]=s end,warning=function(s)output[#output+1]=s end}
 local script=resource("content/direction_probe_diagnostics.script.lua")
 local state={value=nil};function state:get()return self.value end;function state:set(v)self.value=v end
 script.update({},state,0);assert(#queries==0,"paused is silent")
 script.update({},state,5);assert(#queries==24,"three rows times four modes times both directions")
 local text=table.concat(output,"\n")
 assert(text:find("row=A-tram-STREET",1,true) and text:find("row=B-mixed-STREET",1,true) and text:find("row=C-native-TRACK",1,true))
 assert(text:find("mode=ELECTRIC_TRAM_TRACK direction=reverse enabled=true edges=1",1,true),"mock reverse result is reported without inference")
 script.update({},state,5);assert(#queries==24,"unchanged fixture is not reprobed every tick")
 objects[12].TRANSPORT_NETWORK=nil;state.value.reports={};script.update({},state,5)
 assert(table.concat(output,"\n"):find("no vehicle edge available; no directional conclusion",1,true),"missing network is not treated as a negative path result")
 print("PASS: isolated geometry, A/B mode-only comparison and read-only directional reporting. Native mode behavior remains unproven.")
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),"\n");os.exit(1) end
