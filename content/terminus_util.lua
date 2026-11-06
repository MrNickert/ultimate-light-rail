-- Compact tram-style construction: one straight external STREET approach,
-- internal mixed-mode vehicle lanes. No root STREET switch junctions.
-- Use native construction-lane values directly (native underground uses 40).
-- Do not reuse the m/s conversion of street-template LaneConfig.speed here.
local track=require "mrnickert_ultimate_metro::/station_turnback_track.lua"
local lane=track.lane
local function transform(x,y,z,reverse)
 local a=reverse and -1 or 1
 return {a,0,0,0, 0,a,0,0, 0,0,1,0, x,y,z,1}
end
local function rectangle(x0,x1,y0,y1)
 return {{x0,y0,0},{x1,y0,0},{x1,y1,0},{x0,y1,0}}
end
return function(_captureParams,params,options)
  local L=(options or {}).length or 80
  params=params or {}
  local crossover=tonumber(params.crossover or 2)~=1
  local modes=track.modes
  local lanes={
   lane({{-30,-2.5,0},{0,-2.5,0},{L/2,-2.5,0},{L,-2.5,0}},modes,true,false),
   lane({{-30,2.5,0},{0,2.5,0},{L/2,2.5,0},{L,2.5,0}},modes,true,false),
  }
  if crossover then track.addCrossover(lanes,-30,modes) end
  local vehicles=#lanes
  local models={
   {id="::/stations/street/small_stops/small_new.mdl",transf=transform(L/2,-7.5,0,true)},
   {id="::/stations/street/small_stops/small_new.mdl",transf=transform(L/2,7.5,0)},
  }
  for i=1,vehicles do track.addRailVisuals(models,lanes[i]) end
  lanes[#lanes+1]=lane({{0,-5.5,0},{L/2,-5.5,0},{L,-5.5,0}},{"PERSON"},false,false)
  lanes[#lanes+1]=lane({{0,5.5,0},{L/2,5.5,0},{L,5.5,0}},{"PERSON"},false,false)
  lanes[#lanes+1]=lane({{L,-5.5,0},{L+5,-5.5,0},{L+5,0,0},{L+5,5.5,0},{L,5.5,0}},{"PERSON"},false,false)
  lanes[#lanes+1]=lane({{L+5,0,0},{L+10,0,0}},{"PERSON"},false,true)
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
    },catchmentAreas={{position={L+5,0,0},radius=160}}},
    groundFaces={
     {face=rectangle(-30,L,-4,4),modes={{type="FILL",key="::/infrastructure/street/shared/street_fill.gtex"}}},
     {face=rectangle(0,L,-9,-4),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
     {face=rectangle(0,L,4,9),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
     {face=rectangle(L,L+12,-9,9),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
    },terrainAlignmentLists={{type="EQUAL",faces={rectangle(-40,L+12,-10,10)},slopeLow=0,slopeHigh=0}},
   }},cost=120000,maintenanceCost=20000,
  }
end
