-- Compact tram-style construction: one straight external STREET approach,
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
 -- Bare shared rail mesh (4m long), embedded almost flush in the paved surface.
 -- Two rails per path, no sleepers, ballast segments or railway buffer blocks.
 local halfGauge=1.435/2
 for i=1,#vehicleLane.nodes,2 do
  local a,b=vehicleLane.nodes[i],vehicleLane.nodes[i+1]
  local dx,dy=b[1][1]-a[1][1],b[1][2]-a[1][2]
  local count=math.max(1,math.ceil(math.sqrt(dx*dx+dy*dy)))
  local first=position(a,b,0)
  for step=1,count do
   local last=position(a,b,step/count)
   local x,y=last[1]-first[1],last[2]-first[2]
   local length=math.sqrt(x*x+y*y)
   local nx,ny=-y/length,x/length
   for _,side in ipairs({-1,1}) do
    models[#models+1]={id="::/infrastructure/track/shared/single_rail.mdl",
     transf={x/4,y/4,0,0, nx,ny,0,0, 0,0,1,0,
       (first[1]+last[1])/2+side*halfGauge*nx,
       (first[2]+last[2])/2+side*halfGauge*ny,-0.52,1}}
   end
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
   lane({{-30,-2.5,0},{0,-2.5,0},{40,-2.5,0},{80,-2.5,0}},modes,true,false),
   lane({{-30,2.5,0},{0,2.5,0},{40,2.5,0},{80,2.5,0}},modes,true,false),
  }
  if crossover then
   -- Exact halves of a smooth 30m S-curve. At both switches the
   -- tangents are horizontal, matching the main track without a kink.
   lanes[#lanes+1]=lane({{-30,-2.5,0},{-15,0,0},{0,2.5,0}},modes,true,false,
    {[1]={{15,0,0},{15,3.75,0}},[2]={{15,3.75,0},{15,0,0}}})
   lanes[#lanes+1]=lane({{-30,2.5,0},{-15,0,0},{0,-2.5,0}},modes,true,false,
    {[1]={{15,0,0},{15,-3.75,0}},[2]={{15,-3.75,0},{15,0,0}}})
   lanes[3].speedLimit=10;lanes[4].speedLimit=10
  end
  local vehicles=#lanes
  local models={
   {id="::/stations/street/small_stops/small_new.mdl",transf=transform(40,-7.5,0,true)},
   {id="::/stations/street/small_stops/small_new.mdl",transf=transform(40,7.5,0)},
  }
  for i=1,vehicles do addRailVisuals(models,lanes[i]) end
  lanes[#lanes+1]=lane({{0,-5.5,0},{40,-5.5,0},{80,-5.5,0}},{"PERSON"},false,false)
  lanes[#lanes+1]=lane({{0,5.5,0},{40,5.5,0},{80,5.5,0}},{"PERSON"},false,false)
  lanes[#lanes+1]=lane({{80,-5.5,0},{85,-5.5,0},{85,0,0},{85,5.5,0},{80,5.5,0}},{"PERSON"},false,false)
  lanes[#lanes+1]=lane({{85,0,0},{90,0,0}},{"PERSON"},false,true)
  local terminalModes={"TRAM","ELECTRIC_TRAM"}
  return {
   edgeLists={{type="STREET",params={type="mrnickert_ultimate_metro::/lightrail_double.street_template",tramTrackType="ELECTRIC"},
    edges={{{-40,0,0},{10,0,0}},{{-30,0,0},{10,0,0}}},snapNodes={0},freeNodes={0}}},
   snapPoint={transf={0,-1,0,0, 1,0,0,0, 0,0,1,0, -40,0,0,1},
    snapToBaseEdgeTypes={"STREET"},transportModes=terminalModes,allowSnapToBaseEdgeEnds=true},
   subconstructions={{models=models,laneLists=lanes,
    station={tag=1,pool={edges={},capacity=0},terminals={
     {vehicleNode={0,3},transportModes=terminalModes,personEdges={{vehicles,0},{vehicles,1}},
      personNodes={{vehicles,0},{vehicles,1},{vehicles,3}},passengers=true,cargo=false,capacity=100},
     {vehicleNode={1,3},transportModes=terminalModes,personEdges={{vehicles+1,0},{vehicles+1,1}},
      personNodes={{vehicles+1,0},{vehicles+1,1},{vehicles+1,3}},passengers=true,cargo=false,capacity=100},
    },catchmentAreas={{position={85,0,0},radius=160}}},
    groundFaces={
     {face=rectangle(-30,80,-4,4),modes={{type="FILL",key="::/infrastructure/street/shared/street_fill.gtex"}}},
     {face=rectangle(0,80,-9,-4),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
     {face=rectangle(0,80,4,9),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
     {face=rectangle(80,92,-9,9),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
    },terrainAlignmentLists={{type="EQUAL",faces={rectangle(-40,92,-10,10)},slopeLow=0,slopeHigh=0}},
   }},cost=120000,maintenanceCost=20000,
  }
 end}
end
