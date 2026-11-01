-- Two-track terminus: real STREET edges, direct terminals, explicit crossover.
-- Track/profile primitives are proven separately. Native switch junctions and
-- the combined terminus remain experimental. No overlapping reverse edges.
local function transform(x,y,z,reverse)
 local a=reverse and -1 or 1
 return {a,0,0,0, 0,a,0,0, 0,0,1,0, x,y,z,1}
end
local function rectangle(x0,x1,y0,y1)
 return {{x0,y0,0},{x1,y0,0},{x1,y1,0},{x0,y1,0}}
end
local function people(points,linkable)
 local nodes={}
 for i=1,#points-1 do
  local a,b=points[i],points[i+1]
  local t={b[1]-a[1],b[2]-a[2],b[3]-a[3]}
  nodes[#nodes+1]={a,t,2};nodes[#nodes+1]={b,t,2}
 end
 return {nodes=nodes,transportModes={"PERSON"},speedLimit=2,forwardOnly=false,linkable=linkable}
end
function data()
 return {updateFn=function(_captureParams,_params)
  local single="mrnickert_ultimate_metro::/mode_probe.street_template"
  local double="mrnickert_ultimate_metro::/lightrail_double.street_template"
  local result={edgeLists={},subconstructions={},cost=120000,maintenanceCost=20000}
  local rawCount=0
  local function add(points,template,snap,overrides)
   local edges={}
   for i=1,#points-1 do
    local a,b=points[i],points[i+1]
    local t={b[1]-a[1],b[2]-a[2],b[3]-a[3]}
    local custom=overrides and overrides[i]
    edges[#edges+1]={a,custom and custom[1] or t}
    edges[#edges+1]={b,custom and custom[2] or t}
   end
   local prefix=rawCount;rawCount=rawCount+#edges
   result.edgeLists[#result.edgeLists+1]={type="STREET",params={type=template,tramTrackType="ELECTRIC"},
    edges=edges,snapNodes=snap or {},freeNodes=snap or {}}
   return prefix
  end
  -- One standard-width double approach. Its internal node is shared by both
  -- single-track branch origins, creating a native three-way junction.
  add({{-130,0,0},{-100,0,0}},double,{0})
  local lower=add({{-100,0,0},{-60,-6,0},{-20,-6,0},{0,-6,0},{40,-6,0},{80,-6,0}},single,{},
   {[1]={{40,-12,0},{40,0,0}}})
  local upper=add({{-100,0,0},{-60,6,0},{-20,6,0},{0,6,0},{40,6,0},{80,6,0}},single,{},
   {[1]={{40,12,0},{40,0,0}}})
  -- Two distinct crossing routes. Both contain the same explicit middle NODE
  -- so crossing movement shares a reservable junction rather than overlapping
  -- unconnected vehicle edges. Native conflict safety still needs testing.
  add({{-60,-6,0},{-40,0,0},{-20,6,0}},single,{},
   {[1]={{20,12,0},{20,6,0}},[2]={{20,6,0},{20,12,0}}})
  add({{-60,6,0},{-40,0,0},{-20,-6,0}},single,{},
   {[1]={{20,-12,0},{20,-6,0}},[2]={{20,-6,0},{20,-12,0}}})
  local modes={"TRAM","ELECTRIC_TRAM"}
  local sub={
   models={
    {id="::/stations/street/small_stops/small_new.mdl",transf=transform(25,0,0)},
    {id="::/stations/street/small_stops/small_new.mdl",transf=transform(55,0,0,true)},
   },
   laneLists={
    people({{0,-2,0},{40,-2,0},{80,-2,0}},false), -- 0: lower platform side
    people({{0,2,0},{40,2,0},{80,2,0}},false), -- 1: upper platform side
    people({{80,-2,0},{88,-2,0},{88,0,0},{88,2,0},{80,2,0}},false), -- 2: behind rail ends
    people({{88,0,0},{98,0,0}},true), -- 3: public pedestrian access
   },
   station={tag=1,pool={edges={},capacity=0},terminals={
    -- Raw endpoint index 7 is x=40 on each main-track list. Prefixes include
    -- all root edgeLists, including the two-lane approach. Never bind there.
    {vehicleNode={-1,lower+7},transportModes=modes,personEdges={{0,0},{0,1}},
     personNodes={{0,0},{0,1},{0,3}},passengers=true,cargo=false,capacity=100},
    {vehicleNode={-1,upper+7},transportModes=modes,personEdges={{1,0},{1,1}},
     personNodes={{1,0},{1,1},{1,3}},passengers=true,cargo=false,capacity=100},
   },catchmentAreas={{position={88,0,0},radius=160}}},
   groundFaces={
    {face=rectangle(0,88,-3,3),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
    {face=rectangle(80,100,-8,8),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
   },
   terrainAlignmentLists={{type="EQUAL",faces={rectangle(-130,100,-12,12)},slopeLow=0,slopeHigh=0}},
  }
  result.subconstructions={sub}
  result.snapPoint={transf={0,-1,0,0, 1,0,0,0, 0,0,1,0, -130,0,0,1},
   snapToBaseEdgeTypes={"STREET"},transportModes=modes,allowSnapToBaseEdgeEnds=true}
  return result
 end}
end
