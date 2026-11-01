local function main()
local checks=0
local function eq(a,b,label) assert(a==b,label..": "..tostring(a).." != "..tostring(b));checks=checks+1 end
local function loadResource(path)
 local env=setmetatable({_ = function(key) return key end},{__index=_G})
 assert(loadfile(path,"t",env))()
 return env.data()
end
local definition=loadResource("content/surface_stop.con.lua")
local script=loadResource("content/surface_stop.script.lua")
local template=loadResource("content/test_track.street_template.lua")
eq(definition.menuCategory.categories[1].category,"road_buildings","uses existing station menu")
eq(definition.updateScript.fileName,"mrnickert_ultimate_metro::/surface_stop.script@updateFn","new namespaced update script")
eq(#definition.params[1].values,3,"three test platform lengths")
eq(#template.laneConfigs,2,"two native logical directions")
eq(template.laneConfigs[1].offset,0,"first direction centered")
eq(template.laneConfigs[2].offset,0,"second direction centered")
eq(template.laneConfigs[1].forward,false,"reverse logical direction")
eq(template.laneConfigs[2].forward,true,"forward logical direction")
eq(template.roadType,"STREET","remains tram street infrastructure")
eq(#template.menuCategory.categories,0,"internal template is not extra build-menu clutter")
for _,config in ipairs(template.laneConfigs) do
 eq(#config.transportModes,2,"tram-only transport modes")
 eq(config.transportModes[1],"TRAM","no train mode conversion")
 eq(config.transportModes[2],"ELECTRIC_TRAM","electric tram supported")
end
local cases={{value=1,half=30},{value=2,half=40},{value=3,half=60},{value=0,half=40},{value=999,half=40},{value="invalid",half=40}}
for _,case in ipairs(cases) do
 local result=script.updateFn({}, {platformLength=case.value})
 eq(#result.edgeLists,2,"only two straight external stubs")
 eq(#result.subconstructions,1,"one station subconstruction")
 local sub=result.subconstructions[1]
 eq(#sub.station.terminals,1,"one terminal, not two directional stops")
 eq(#sub.laneLists,3,"one vehicle lane and two pedestrian lanes")
 local track=sub.laneLists[1]
 eq(track.forwardOnly,false,"experimental bidirectional station lane")
 eq(track.needsReservation,true,"reservation requested, runtime safety unproven")
 eq(track.nodes[1][1][1],-case.half,"correct left end")
 eq(track.nodes[4][1][1],case.half,"correct right end")
 for _,node in ipairs(track.nodes) do
  eq(node[1][2],0,"central physical track")
  eq(node[1][3],0,"surface elevation")
  assert(node[2][1]>0,"no closed loop or hidden turnaround geometry");checks=checks+1
 end
 eq(sub.station.terminals[1].vehicleNode[1],0,"terminal targets vehicle lane")
 eq(sub.station.terminals[1].vehicleNode[2],1,"terminal at center node")
 eq(sub.station.terminals[1].passengers,true,"passenger terminal")
 eq(sub.station.terminals[1].cargo,false,"not a freight stop")
 eq(sub.laneLists[3].linkable,true,"external pedestrian link requested")
 eq(sub.models[1].id,"::/stations/street/small_stops/small_new.mdl","reuses existing shelter")
 eq(result.edgeLists[1].params.type,"mrnickert_ultimate_metro::/test_track.street_template","only own internal template")
 eq(result.edgeLists[1].snapNodes[1],0,"left outer endpoint can snap")
 eq(result.edgeLists[2].snapNodes[1],1,"right outer endpoint can snap")
 eq(result.edgeLists[1].edges[2][1][1],-case.half,"left stub joins station lane")
 eq(result.edgeLists[2].edges[1][1][1],case.half,"right stub joins station lane")
 eq(result.cost,30000,"prototype build price stable")
 eq(result.maintenanceCost,5000,"prototype maintenance explicit")
end
local first=script.updateFn({},nil);first.subconstructions[1].station.terminals={}
eq(#script.updateFn({},nil).subconstructions[1].station.terminals,1,"build results are independent")
print("PASS: "..checks.." structure checks. Native connection, routing and reversal still require in-game testing.")
end
local ok,message=pcall(main)
if not ok then io.stderr:write(tostring(message),"\n");os.exit(1) end
