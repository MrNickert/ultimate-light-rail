local function main()
 local messages={}
 local ct={CONSTRUCTION=1,TRANSPORT_NETWORK=2,STATION=3}
 local modes={TRAM=1,ELECTRIC_TRAM=2,PERSON=3}
 local vehicleEdge={transportModes={[1]=true},speedLimit=80/3.6,curveSpeedLimit=13/3.6,
  needsReservation=true,forwardOnly=false,geometry={}}
 local personEdge={transportModes={[3]=true},speedLimit=2,curveSpeedLimit=2}
 local data={
  [10]={[ct.CONSTRUCTION]={fileName="mrnickert_ultimate_metro::/twin_terminus.con",frozenEdges={20},stations={30}}},
  [11]={[ct.CONSTRUCTION]={fileName="unrelated::/station.con",frozenEdges={},stations={}}},
  [20]={[ct.TRANSPORT_NETWORK]={edges={vehicleEdge,personEdge}}},
  [30]={[ct.STATION]={terminals={{vehicleNodeId={entity=40,index=3}},{vehicleNodeId={entity=40,index=9}}}}},
  [40]={[ct.TRANSPORT_NETWORK]={edges={vehicleEdge}}},
 }
 local env=setmetatable({
  log={message=function(message)messages[#messages+1]=message end},
  api={type={ComponentType=ct,["enum"]={TransportMode=modes}},
   engine={getEntitiesWithComponent=function()return{10,11}end,
    getComponent=function(entity,component)return assert(data[entity])[component]end,
    util={transport={calcPosition=function(_,t)return{x=t,y=0,z=0}end}}},
   cmd=setmetatable({},{__index=function()error("world command forbidden")end})},
 },{__index=_G})
 assert(loadfile("diagnostics/speed_probe/content/speed_report.script.lua","t",env))()
 local report=env.data()
 local state=setmetatable({},{__index=function()error("no saved-state access expected")end})
 report.update({},state,0);report.update({},state,4)
 assert(#messages==0,"report waits for running simulation")
 report.update({},state,1)
 local text=table.concat(messages,"\n")
 assert(text:find("limit=22.222 m/s (80 km/h)",1,true),"effective speed limit conversion")
 assert(text:find("curve=3.6111 m/s (13 km/h)",1,true),"effective curve limit conversion")
 assert(not text:find("unrelated",1,true),"only Metro constructions inspected")
 local _,count=text:gsub("station%-lanes network=40 edge=0","")
 assert(count==1,"shared terminal network reported once")
 local size=#messages;report.update({},state,100)
 assert(#messages==size,"report stops after one snapshot")
 print("PASS: optional speed probe waits, filters, reports raw/converted effective limits and stops; no commands or saved-state writes.")
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),"\n");os.exit(1)end
