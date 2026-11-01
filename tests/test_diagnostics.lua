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
    queries[#queries+1]={from=from[1].entity,to=to[1].entity,mode=modes[1]}
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
script.update({},state,2)
local text=table.concat(output,"\n")
check(text:find("total prototype constructions=2",1,true),"only own prototype constructions selected")
check(not text:find("construction=30",1,true),"vanilla construction excluded")
check(text:find("degrees=2:1",1,true),"outer attachment degree reported")
check(text:find("forwardOnly=false",1,true),"actual native lane direction reported")
check(text:find("geometry=(0.00,0.00,0.00)->(10.00,0.00,0.00)",1,true),"actual edge coordinates reported")
check(text:find("path 101->201 mode=ELECTRIC_TRAM edges=0",1,true),"missing electric path distinguished")
check(text:find("path 201->101 mode=TRAM edges=1",1,true),"reverse reachability inspected")
check(#queries==4,"both modes queried in both directions")
check(objects[10].CONSTRUCTION.fileName=="mrnickert_ultimate_metro::/surface_stop.con.lua","construction unchanged")
check(objects[301].TRANSPORT_NETWORK.edges[1].forwardOnly==false,"network unchanged")
local old=#output;script.update({},state,100);check(#output==old,"report does not spam each update")
script,state,output=fixture(true);script.update({},state,3)
check(table.concat(output,"\n"):find("path query failed",1,true),"native read failures logged safely")
check(table.concat(output,"\n"):find("report complete",1,true),"report continues after failed path query")
print("PASS: "..count.." read-only diagnostic checks; native runtime still requires confirmation")
end
local ok,message=pcall(main)
if not ok then io.stderr:write(tostring(message),"\n");os.exit(1) end
