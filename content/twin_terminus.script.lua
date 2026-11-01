-- Native-stop-style construction: one straight external STREET approach,
-- internal mixed-mode vehicle lanes. No root STREET switch junctions.
local function transform(x,y,z,reverse)
 local a=reverse and -1 or 1
 return {a,0,0,0, 0,a,0,0, 0,0,1,0, x,y,z,1}
end
local function rectangle(x0,x1,y0,y1)
 return {{x0,y0,0},{x1,y0,0},{x1,y1,0},{x0,y1,0}}
end
local function lane(points,modes,vehicle,linkable,overrides)
 local nodes={}
 for i=1,#points-1 do
  local a,b=points[i],points[i+1]
  local t={b[1]-a[1],b[2]-a[2],b[3]-a[3]}
  local custom=overrides and overrides[i]
  nodes[#nodes+1]={a,custom and custom[1] or t,2}
  nodes[#nodes+1]={b,custom and custom[2] or t,2}
 end
 return {nodes=nodes,transportModes=modes,speedLimit=vehicle and 15 or 2,
  forwardOnly=false,needsReservation=vehicle,linkable=linkable}
end
local function position(a,b,t)
 local t2,t3=t*t,t*t*t
 local p={}
 for k=1,3 do
  p[k]=(2*t3-3*t2+1)*a[1][k]+(t3-2*t2+t)*a[2][k]
       +(-2*t3+3*t2)*b[1][k]+(t3-t2)*b[2][k]
 end
 return p
end
local function addRailVisuals(models,vehicleLane)
 -- Existing 2m game model has x bounds [-1,1] and rail top z=0.53.
 -- Chord approximations are decorative only: mdl metadata has no network.
 for i=1,#vehicleLane.nodes,2 do
  local a,b=vehicleLane.nodes[i],vehicleLane.nodes[i+1]
  local dx,dy=b[1][1]-a[1][1],b[1][2]-a[1][2]
  local count=math.max(1,math.ceil(math.sqrt(dx*dx+dy*dy)/2))
  local first=position(a,b,0)
  for step=1,count do
   local last=position(a,b,step/count)
   local x,y=last[1]-first[1],last[2]-first[2]
   local length=math.sqrt(x*x+y*y)
   models[#models+1]={id="::/infrastructure/track/standard/2m_standard.mdl",
    transf={x/2,y/2,0,0, -y/length,x/length,0,0, 0,0,1,0,
      (first[1]+last[1])/2,(first[2]+last[2])/2,-0.50,1}}
   first=last
  end
 end
end
function data()
 return {updateFn=function(_captureParams,params)
  params=params or {}
  local crossover=tonumber(params.crossover or 2)~=1
  local modes={"TRAM","ELECTRIC_TRAM","TRAM_TRACK","ELECTRIC_TRAM_TRACK"}
  local lanes={
   lane({{-100,-2.5,0},{-60,-6,0},{-20,-6,0},{0,-6,0},{40,-6,0},{80,-6,0}},modes,true,false,
    {[1]={{40,0,0},{40,0,0}}}),
   lane({{-100,2.5,0},{-60,6,0},{-20,6,0},{0,6,0},{40,6,0},{80,6,0}},modes,true,false,
    {[1]={{40,0,0},{40,0,0}}}),
  }
  if crossover then
   lanes[#lanes+1]=lane({{-60,-6,0},{-40,0,0},{-20,6,0}},modes,true,false,
    {[1]={{20,12,0},{20,6,0}},[2]={{20,6,0},{20,12,0}}})
   lanes[#lanes+1]=lane({{-60,6,0},{-40,0,0},{-20,-6,0}},modes,true,false,
    {[1]={{20,-12,0},{20,-6,0}},[2]={{20,-6,0},{20,-12,0}}})
  end
  local vehicles=#lanes
  local models={
   {id="::/stations/street/small_stops/small_new.mdl",transf=transform(25,0,0)},
   {id="::/stations/street/small_stops/small_new.mdl",transf=transform(55,0,0,true)},
   {id="::/infrastructure/track/standard/bumper_standard.mdl",transf=transform(80,-6,-0.50)},
   {id="::/infrastructure/track/standard/bumper_standard.mdl",transf=transform(80,6,-0.50)},
  }
  for i=1,vehicles do addRailVisuals(models,lanes[i]) end
  lanes[#lanes+1]=lane({{0,-2,0},{40,-2,0},{80,-2,0}},{"PERSON"},false,false)
  lanes[#lanes+1]=lane({{0,2,0},{40,2,0},{80,2,0}},{"PERSON"},false,false)
  lanes[#lanes+1]=lane({{80,-2,0},{88,-2,0},{88,0,0},{88,2,0},{80,2,0}},{"PERSON"},false,false)
  lanes[#lanes+1]=lane({{88,0,0},{98,0,0}},{"PERSON"},false,true)
  local terminalModes={"TRAM","ELECTRIC_TRAM"}
  return {
   edgeLists={{type="STREET",params={type="mrnickert_ultimate_metro::/lightrail_double.street_template",tramTrackType="ELECTRIC"},
    edges={{{-130,0,0},{30,0,0}},{{-100,0,0},{30,0,0}}},snapNodes={0},freeNodes={0}}},
   snapPoint={transf={0,-1,0,0, 1,0,0,0, 0,0,1,0, -130,0,0,1},
    snapToBaseEdgeTypes={"STREET"},transportModes=terminalModes,allowSnapToBaseEdgeEnds=true},
   subconstructions={{models=models,laneLists=lanes,
    station={tag=1,pool={edges={},capacity=0},terminals={
     {vehicleNode={0,7},transportModes=terminalModes,personEdges={{vehicles,0},{vehicles,1}},
      personNodes={{vehicles,0},{vehicles,1},{vehicles,3}},passengers=true,cargo=false,capacity=100},
     {vehicleNode={1,7},transportModes=terminalModes,personEdges={{vehicles+1,0},{vehicles+1,1}},
      personNodes={{vehicles+1,0},{vehicles+1,1},{vehicles+1,3}},passengers=true,cargo=false,capacity=100},
    },catchmentAreas={{position={88,0,0},radius=160}}},
    groundFaces={
     {face=rectangle(-100,0,-9,9),modes={{type="FILL",key="::/infrastructure/street/shared/street_fill.gtex"}}},
     {face=rectangle(0,80,-9,-3),modes={{type="FILL",key="::/infrastructure/street/shared/street_fill.gtex"}}},
     {face=rectangle(0,80,3,9),modes={{type="FILL",key="::/infrastructure/street/shared/street_fill.gtex"}}},
     {face=rectangle(0,88,-3,3),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
     {face=rectangle(80,100,-8,8),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
    },terrainAlignmentLists={{type="EQUAL",faces={rectangle(-130,100,-12,12)},slopeLow=0,slopeHigh=0}},
   }},cost=120000,maintenanceCost=20000,
  }
 end}
end
