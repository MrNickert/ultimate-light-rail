local function main()
local count=0
local function check(value,label) assert(value,label);count=count+1 end
local function fixture(failPath)
 local output,queries={},{}
 local ct={CONSTRUCTION="CONSTRUCTION",BASE_EDGE="BASE_EDGE",STATION="STATION",TRANSPORT_NETWORK="TRANSPORT_NETWORK"}
 local tm={TRAM="TRAM",ELECTRIC_TRAM="ELECTRIC_TRAM"}
 local objects={}
 objects[10]={CONSTRUCTION={fileName="mrnickert_ultimate_metro::/surface_stop.con.lua",frozenEdges={11},stations={101}}}
 objects[20]={CONSTRUCTION={fileName="mrnickert_ultimate_metro::/surface_stop.con.lua",frozenEdges={21},stations={201}}}
 objects[30]={CONSTRUCTION={fileName="::/stations/street/small_stops/small_new.con.lua"}}
 objects[11]={BASE_EDGE={roadTemplate="mrnickert_ultimate_metro::/test_track.street_template",node0=1,node1=2}}
 objects[21]={BASE_EDGE={roadTemplate="mrnickert_ultimate_metro::/test_track.street_template",node0=3,node1=4}}
 objects[101]={STATION={terminals={{vehicleNodeId={entity=301,index=1}}}}}
 objects[201]={STATION={terminals={{vehicleNodeId={entity=401,index=1}}}}}
 for _,entity in ipairs({301,401}) do
  objects[entity]={TRANSPORT_NETWORK={nodes={{},{},{}},edges={{
   conns={{entity=entity,index=0},{entity=entity,index=1}},
   transportModes={TRAM=true,ELECTRIC_TRAM=true},forwardOnly=false,needsReservation=true,
   geometry={a={x=0,y=0,z=0},b={x=10,y=0,z=0}},
  }}}}
 end
 api={type={ComponentType=ct,["enum"]={TransportMode=tm}},engine={
  getEntitiesWithComponent=function() return {10,20,30} end,
  getComponent=function(entity,kind) return objects[entity] and objects[entity][kind] end,
  system={streetSystem={getNode2SegmentMap=function() return {[1]={11,99},[2]={11},[3]={21},[4]={21,98}} end}},
  util={transport={calcPosition=function(geometry,t) return t==0 and geometry.a or geometry.b end},
   pathfinding={findPathNodeToNode=setmetatable({}, {__call=function(_,from,to,modes)
    queries[#queries+1]={from=from[1].entity,to=to[1].entity,mode=modes[1],modeCount=#modes}
    if failPath then error("read query rejected") end
    if modes[1]=="ELECTRIC_TRAM" then return {} end
    return {{entity=1,index=0}}
   end})}},
 },cmd=setmetatable({}, {__index=function() error("world commands must not be accessed") end})}
 log={message=function(s) output[#output+1]=s end,warning=function(s) output[#output+1]=s end}
 local env=setmetatable({}, {__index=_G});assert(loadfile("content/network_diagnostics.script.lua","t",env))()
 local script=env.data();local state={value={}}
 function state:get() return self.value end
 function state:set(v) self.value=v end
 return script,state,output,queries,objects
end
local script,state,output,queries,objects=fixture(false)
script.update({},state,0);check(#output==0,"paused simulation emits no report")
script.update({},state,1);check(#output==0,"wait for loaded-world settling")
script.update({},state,4)
local text=table.concat(output,"\n")
check(text:find("total prototype constructions=2",1,true),"only own prototype constructions selected")
check(not text:find("construction=30",1,true),"vanilla construction excluded")
check(text:find("degrees=2:1",1,true),"outer attachment degree reported")
check(text:find("forwardOnly=false",1,true),"actual native lane direction reported")
check(text:find("geometry=(0.00,0.00,0.00)->(10.00,0.00,0.00)",1,true),"actual edge coordinates reported")
check(text:find("path 101->201 mode=ELECTRIC_TRAM edges=0",1,true),"missing electric path distinguished")
check(text:find("path 201->101 mode=TRAM edges=1",1,true),"reverse reachability inspected")
check(#queries==12,"terminal paths and direct-edge controls queried")
check(text:find("probe single-edge",1,true),"direct edge control included")
check(objects[10].CONSTRUCTION.fileName=="mrnickert_ultimate_metro::/surface_stop.con.lua","construction unchanged")
check(objects[301].TRANSPORT_NETWORK.edges[1].forwardOnly==false,"network unchanged")
local old=#output;script.update({},state,100);check(#output==old,"report does not spam each update")
script,state,output=fixture(true);script.update({},state,5)
check(table.concat(output,"\n"):find("path query failed",1,true),"native read failures logged safely")
check(table.concat(output,"\n"):find("report complete",1,true),"report continues after failed path query")
-- Reproduce the real sequence: diagnostic starts before the user builds stops.
script,state,output,queries,objects=fixture(false)
local first,second=objects[10],objects[20];objects[10]=nil;objects[20]=nil
script.update({},state,5)
check(table.concat(output,"\n"):find("waiting for two prototype stops; currently 0",1,true),"empty map waits instead of finishing")
check(#queries==0,"no path queries on an empty map")
objects[10]=first;script.update({},state,5)
check(#queries==0,"one stop waits for its counterpart")
objects[20]=second;script.update({},state,5)
check(#queries==12,"newly built pair triggers the report automatically")
-- An external segment attached later changes the signature and triggers a new report.
api.engine.system.streetSystem.getNode2SegmentMap=function()
 return {[1]={11,99,1000},[2]={11},[3]={21},[4]={21,98}}
end
script.update({},state,5)
check(#queries==24,"connection edits trigger a fresh report")
local previous=#output;script.update({},state,5)
check(#output==previous,"unchanged topology does not spam logs")
-- A save containing the old empty one-shot report is automatically upgraded.
script,state,output,queries=fixture(false);state.value={version=1,done=true,elapsed=50}
script.update({},state,5)
check(#queries==12,"old saved done=true no longer suppresses the report")
check(state.value.version==8,"saved diagnostic state upgraded")
-- The new two-track stops expose four terminals instead of two.
script,state,output,queries,objects=fixture(false)
for _,entity in ipairs({10,20}) do
 objects[entity].CONSTRUCTION.fileName="mrnickert_ultimate_metro::/crossover_stop.con"
end
objects[101].STATION.terminals[2]={vehicleNodeId={entity=301,index=2}}
objects[201].STATION.terminals[2]={vehicleNodeId={entity=401,index=2}}
script.update({},state,5)
check(#queries==32,"four crossover terminals inspected in both tram modes")
check(table.concat(output,"\n"):find("sampled terminals=4",1,true),"new construction resources recognized")
check(table.concat(output,"\n"):find("nodes=301:1",1,true),"terminal nodes distinguish platforms in the same station")
-- First edge-binding proof needs just one stop, not a two-stop line setup.
script,state,output,queries,objects=fixture(false)
objects[10].CONSTRUCTION.fileName="mrnickert_ultimate_metro::/edge_stop.con"
objects[20]=nil
script.update({},state,5)
check(table.concat(output,"\n"):find("total prototype constructions=1 sampled terminals=1",1,true),"single direct-bound stop reports without a counterpart")
check(#queries==4,"single-stop report includes local directional probes")
-- Separate bidirectional stop resource must be reported and retain base-edge flags.
script,state,output,queries,objects=fixture(false)
objects[10].CONSTRUCTION.fileName="mrnickert_ultimate_metro::/bidirectional_stop.con"
objects[20]=nil
objects[11].TRANSPORT_NETWORK=objects[301].TRANSPORT_NETWORK
script.update({},state,5)
local report=table.concat(output,"\n")
check(report:find("total prototype constructions=1 sampled terminals=1",1,true),"new bidirectional stop resource is inspected alone")
check(report:find("segment-network=11 edge=0 forwardOnly=false reservation=true",1,true),"direct station segment flags reported from actual segment network")
-- Compare local station paths with the complete connection using both mode families.
script,state,output,queries,objects=fixture(false)
api.type["enum"].TransportMode.TRAM_TRACK="TRAM_TRACK"
api.type["enum"].TransportMode.ELECTRIC_TRAM_TRACK="ELECTRIC_TRAM_TRACK"
for _,id in ipairs({10,20}) do objects[id].CONSTRUCTION.fileName="mrnickert_ultimate_metro::/bidirectional_stop.con" end
objects[11].TRANSPORT_NETWORK=objects[301].TRANSPORT_NETWORK
objects[21].TRANSPORT_NETWORK=objects[401].TRANSPORT_NETWORK
script.update({},state,5)
local full=table.concat(output,"\n")
check(full:find("probe station-span construction=10",1,true),"local station span is probed independently of the interstation route")
check(full:find("mode=ELECTRIC_TRAM+ELECTRIC_TRAM_TRACK",1,true),"combined tram/rail mode paths are reported")
local combined=false
for _,query in ipairs(queries) do if query.modeCount==2 then combined=true end end
check(combined,"native query receives both actual modes, not just a combined label")
-- Measure both approach lanes to both terminus platforms without world edits.
script,state,output,queries,objects=fixture(false)
objects[10].CONSTRUCTION.fileName="mrnickert_ultimate_metro::/twin_terminus.con"
objects[20]=nil
objects[11].BASE_EDGE.roadTemplate="mrnickert_ultimate_metro::/lightrail_double.street_template"
objects[11].TRANSPORT_NETWORK={edges={
 {conns={{entity=1,index=0},{entity=2,index=0}},transportModes={TRAM=true,ELECTRIC_TRAM=true},forwardOnly=false,needsReservation=true},
 {conns={{entity=2,index=1},{entity=1,index=1}},transportModes={TRAM=true,ELECTRIC_TRAM=true},forwardOnly=false,needsReservation=true},
}}
objects[101].STATION.terminals[2]={vehicleNodeId={entity=301,index=2}}
script.update({},state,5)
local terminusLog=table.concat(output,"\n")
check(terminusLog:find("total prototype constructions=1 sampled terminals=2",1,true),"single twin terminus is measured immediately")
check(terminusLog:find("terminus=10 terminal=0 measured approach lanes=2",1,true),"both generated approach lanes recognized even with reversed edge order")
check(terminusLog:find("terminus=10 terminal=1 measured approach lanes=2",1,true),"second platform receives the same approach coverage")
check(terminusLog:find("probe terminal-approach construction=10 terminal=1",1,true) and terminusLog:find("probe terminal-departure construction=10 terminal=1",1,true),"arrival and departure are measured separately")
print("PASS: "..count.." read-only diagnostic checks; native runtime still requires confirmation")
end
local ok,message=pcall(main)
if not ok then io.stderr:write(tostring(message),"\n");os.exit(1) end
