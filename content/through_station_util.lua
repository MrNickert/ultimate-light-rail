-- First member of the through-station layout family. Future configuration
-- can select length/platform layout through adapters while retaining save IDs.
local decorate=require "mrnickert_ultimate_metro::/surface_station_util.lua"
local underpass=require "mrnickert_ultimate_metro::/passenger_underpass_util.lua"
local function transform(x,y,z,reverse)
 local a=reverse and -1 or 1
 return {a,0,0,0,0,a,0,0,0,0,1,0,x,y,z,1}
end
local function rectangle(x0,x1,y0,y1)return{{x0,y0,0},{x1,y0,0},{x1,y1,0},{x0,y1,0}}end
local function vehicle(points)
 local nodes={}
 for i=1,#points-1 do
  local a,b=points[i],points[i+1];local t={b[1]-a[1],b[2]-a[2],0}
  nodes[#nodes+1]={a,t,2};nodes[#nodes+1]={b,t,2}
 end
 -- Same construction-lane convention as the native station scripts.
 return {nodes=nodes,transportModes={"TRAM","ELECTRIC_TRAM"},speedLimit=80,
  forwardOnly=true,needsReservation=false,linkable=false}
end
return function(_capture,_params)
 local layout={kind="through",length=80,platforms=2,crossing="underpass"}
 local crossing=underpass()
 local lanes={vehicle({{-10,-2.5,0},{0,-2.5,0},{40,-2.5,0},{80,-2.5,0},{90,-2.5,0}}),
  vehicle({{90,2.5,0},{80,2.5,0},{40,2.5,0},{0,2.5,0},{-10,2.5,0}})}
 for _,lane in ipairs(crossing.lanes)do lanes[#lanes+1]=lane end
 local modes={"TRAM","ELECTRIC_TRAM"}
 local terminals={}
 for i,waiting in ipairs(crossing.waiting)do
  local personLane=i+1 -- zero-based lanes 2 and 3, after the vehicle lanes
  local edges,nodes={},{}
  for _,index in ipairs(waiting.edges)do edges[#edges+1]={personLane,index}end
  for _,index in ipairs(waiting.nodes)do nodes[#nodes+1]={personLane,index}end
  terminals[#terminals+1]={vehicleNode={i-1,3},transportModes=modes,personEdges=edges,personNodes=nodes,
   passengers=true,cargo=false,capacity=100}
 end
 local models={
  {id="::/stations/street/small_stops/small_new.mdl",transf=transform(10,-7.5,crossing.floor,true)},
  {id="::/stations/street/small_stops/small_new.mdl",transf=transform(10,7.5,crossing.floor)},
 }
 for _,model in ipairs(crossing.models)do models[#models+1]=model end
 local faces={
  {face=rectangle(-10,90,-5.5,5.5),modes={{type="FILL",key="::/infrastructure/street/shared/street_fill.gtex"}}},
  {face=rectangle(0,80,-9,-4),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
  {face=rectangle(0,80,4,9),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
 }
 for _,hole in ipairs(crossing.holes)do faces[#faces+1]=hole end
 local result={
  edgeLists={{type="STREET",params={type="::/infrastructure/street/tram/tram_new.street_template",tramTrackType="ELECTRIC"},
   edges={{{-20,0,0},{10,0,0}},{{-10,0,0},{10,0,0}},{{90,0,0},{10,0,0}},{{100,0,0},{10,0,0}}},
   snapNodes={0,3},freeNodes={0,3}}},
  snapPoint={transf={0,-1,0,0,1,0,0,0,0,0,1,0,-20,0,0,1},snapToBaseEdgeTypes={"STREET"},
   transportModes=modes,allowSnapToBaseEdgeEnds=true},
  subconstructions={{models=models,laneLists=lanes,
   station={tag=1,pool={edges={},capacity=0},terminals=terminals,
    catchmentAreas={{position={40,0,0},radius=160}}},groundFaces=faces,
   terrainAlignmentLists={{type="EQUAL",faces={rectangle(-20,100,-12,12)},slopeLow=0,slopeHigh=0}}}},
  cost=180000,maintenanceCost=20000,
 }
 assert(layout.length==80 and layout.platforms==2,"only validated prototype dimensions exposed")
 return decorate(result,{through=true,platformHeight=crossing.floor,platformScale=crossing.floor/1.1,
  poles={-6,8,28,52,72,86}})
end
