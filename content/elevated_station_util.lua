-- Supported viaduct, real stair openings and individual concrete stair treads.
local terminus=require "mrnickert_ultimate_metro::/terminus_util.lua"
local through=require "mrnickert_ultimate_metro::/through_station_util.lua"
local decorate=require "mrnickert_ultimate_metro::/surface_station_util.lua"
local H,FLOOR=12,12.25
local RUN,STEPS=18,61
local GROUND,PLAZA_HALF,PIER_SPACING=0.15,10.5,20
local RISE=FLOOR-GROUND
local BEAM_TOP,PIER_TOP=H-0.8,H-1.6
local SLAB="mrnickert_ultimate_metro::/elevated_concrete.mdl"
local VISUAL="mrnickert_ultimate_metro::/elevated_concrete_visual.mdl"
local FENCE="mrnickert_ultimate_metro::/lightrail_fence.mdl"
local function matrix(x,y,z,sx,sy,sz)
 return {sx or 1,0,0,0,0,sy or 1,0,0,0,0,sz or 1,0,x,y,z,1}
end
local function rectangle(x0,x1,y0,y1)
 return {{x0,y0,0},{x1,y0,0},{x1,y1,0},{x0,y1,0}}
end
local function lane(points,public)
 local nodes={}
 for i=1,#points-1 do
  local a,b=points[i],points[i+1]
  local t={b[1]-a[1],b[2]-a[2],b[3]-a[3]}
  nodes[#nodes+1]={a,t,2};nodes[#nodes+1]={b,t,2}
 end
 return {nodes=nodes,transportModes={"PERSON"},speedLimit=2,
  forwardOnly=false,needsReservation=false,linkable=public or false}
end
return function(capture,params,isThrough,L,fence)
 local layout={length=L}
 local r=isThrough and through(capture,params,layout) or terminus(capture,params,layout)
 r.cost=r.cost*1.2
 r.maintenanceCost=r.maintenanceCost*1.2
 local sub=r.subconstructions[1]
 local vehicles=isThrough and 2 or 4
 local centre=L/2
 local first,last=isThrough and -10 or -30,isThrough and L+10 or L+4
 local stairStart,stairEnd=centre-RUN/2,centre+RUN/2
 local groundCross=stairStart+1
 -- A single public entrance branches below the tracks to both stairs.
 local paths={}
 for i=1,vehicles do paths[#paths+1]=sub.laneLists[i] end
 for _,side in ipairs({-1,1}) do
  paths[#paths+1]=lane({{0,side*4.65,FLOOR},{centre,side*4.65,FLOOR},
   {stairEnd,side*4.65,FLOOR},{L,side*4.65,FLOOR}})
 end
 for _,side in ipairs({-1,1}) do
  paths[#paths+1]=lane({{groundCross,side*6.5,GROUND},{stairStart,side*6.5,GROUND},
   {stairEnd,side*6.5,FLOOR},
   {stairEnd,side*4.65,FLOOR}})
 end
 paths[#paths+1]=lane({{groundCross,-6.5,GROUND},{groundCross,6.5,GROUND}})
 paths[#paths+1]=lane({{centre,-14,GROUND},{centre,-6.5,GROUND},{groundCross,-6.5,GROUND}},true)
 sub.laneLists=paths
 for i,terminal in ipairs(sub.station.terminals) do
  local index=vehicles+i-1
  terminal.personEdges={{index,0},{index,1},{index,2}}
  terminal.personNodes={{index,0},{index,1},{index,3},{index,5}}
 end
 -- Reuse tram ribbons, wires and furniture, not the surface foundation.
 local shelters={}
 for _,m in ipairs(sub.models) do
  if m.id=="::/stations/street/small_stops/small_new.mdl" then shelters[#shelters+1]=m end
 end
 sub.models=shelters
 local poles={-6}
 for _,x in ipairs({8,centre-12,centre+12,L-8,L+6}) do
  if x~=poles[#poles] then poles[#poles+1]=x end
 end
 decorate(r,{through=true,length=L,poles=poles})
 local models={}
 for _,m in ipairs(sub.models) do
  if m.id~="mrnickert_ultimate_metro::/surface_platform.mdl" and m.id~=FENCE
   and m.id~="::/stations/street/small_stops/small_new.mdl"
   and not (m.id=="::/assets/streets/tram_pole_crossbar.mdl" and (m.transf[13]<first+0.5 or m.transf[13]>last-0.5)) then
   m.transf[15]=m.transf[15]+H
   if m.id=="::/assets/streets/tram_pole_crossbar.mdl" then
    -- Outside the canopy/fascia; extend the inward bracket to the same wire.
    m.transf[14]=m.transf[14]<0 and -9.8 or 9.8
    m.transf[5]=m.transf[5]*7.3/4;m.transf[6]=m.transf[6]*7.3/4
    m.transf[15]=FLOOR
   end
   models[#models+1]=m
  end
 end
 sub.models=models
 for i=1,vehicles do for _,node in ipairs(paths[i].nodes) do node[1][3]=H end end
 for _,edge in ipairs(r.edgeLists) do
  for _,node in ipairs(edge.edges) do node[1][3]=H end
  edge.params.type=isThrough and (fence and "mrnickert_ultimate_metro::/lightrail_fenced.street_template"
   or "::/infrastructure/street/tram/tram_new.street_template")
   or (fence and "mrnickert_ultimate_metro::/lightrail_station_approach.street_template"
   or "mrnickert_ultimate_metro::/lightrail_double.street_template")
  edge.edgeType="BRIDGE";edge.edgeTypeName="::/infrastructure/bridge/concrete.bridge"
  edge.params.edgeType=edge.edgeType;edge.params.edgeTypeName=edge.edgeTypeName
 end
 local function add(id,x,y,z,sx,sy,sz)
  models[#models+1]={id=id,transf=matrix(x,y,z,sx,sy,sz)}
 end
 -- Original rigid unit is 6 x 4m and extends 2.4m below its top face.
 local function slab(x0,x1,y0,y1,z,thickness,visual)
  -- Repeat normal 6m pieces instead of stretching one texture over a viaduct.
  while x0<x1-1e-8 do
   local span=math.min(6,x1-x0)
   add(visual and VISUAL or SLAB,x0,y0,z,span/6,(y1-y0)/4,thickness/2.4)
   x0=x0+span
  end
 end
 -- Outboard pole footings support the relocated catenary masts beyond the canopy.
 local mounts={}
 for _,m in ipairs(models) do
  if m.id=="::/assets/streets/tram_pole_crossbar.mdl" then mounts[#mounts+1]={m.transf[13],m.transf[14]} end
 end
 for _,p in ipairs(mounts) do
  slab(p[1]-0.5,p[1]+0.5,p[2]<0 and -10.2 or 9,p[2]<0 and -9 or 10.2,FLOOR,0.35)
 end
 -- 0.8m load-bearing deck; two actual 18 x 2.4m stair openings.
 -- Continuous track bed, independent of the stair/platform module seams.
 -- Leave physical separation below transparent tram decals to prevent the
 -- underlying concrete triangles from showing through the rail layers.
 slab(first,last,-4,4,H-0.04,0.76)
 for _,interval in ipairs({{first,stairStart},{stairEnd,last}}) do
  slab(interval[1],interval[2],-9,-4,H,0.8)
  slab(interval[1],interval[2],4,9,H,0.8)
 end
 for _,side in ipairs({-1,1}) do
  for _,band in ipairs({{4,5.3},{7.7,9}}) do
   slab(stairStart,stairEnd,side==1 and band[1] or -band[2],
    side==1 and band[2] or -band[1],H,0.8)
  end
  local function deck(x0,x1,y,width)
   while x0<x1-1e-8 do
    local length=math.min(40,x1-x0)
    add("mrnickert_ultimate_metro::/surface_platform.mdl",x0,side*y,H,length/40,width/5,0.25/0.8)
    x0=x0+length
   end
  end
  deck(first,stairStart,6.5,5);deck(stairEnd,last,6.5,5)
  deck(stairStart,stairEnd,4.65,1.3);deck(stairStart,stairEnd,8.35,1.3)
  -- Sixty-one visible treads: about 29.5cm deep and 20.1cm high.
  for i=1,STEPS do
   slab(stairStart+(i-1)*RUN/STEPS,stairStart+i*RUN/STEPS,
    side*6.5-1.2,side*6.5+1.2,GROUND+i*RISE/STEPS,RISE/STEPS)
  end
  -- A sloping concrete waist supports the treads all the way to the ground.
  local waist=matrix(stairStart,side*6.5-1.2,GROUND,RUN/6,2.4/4,0.25/2.4)
  waist[3]=RISE/6
  models[#models+1]={id=SLAB,transf=waist}
 end
 -- Closed concrete trough edges sit below the boarding/platform floor.
 for _,side in ipairs({-1,1}) do
  slab(first,last,side*3.9-0.1,side*3.9+0.1,H+0.18,0.28)
  -- Rigid outer fascia, with a separate visible safety railing added below.
  slab(first,last,side==1 and 9 or -9.25,side==1 and 9.25 or -9,FLOOR,1.45)
 end
 local function fenceLine(x0,x1,y,z,rise)
  local count=math.ceil((x1-x0)/1.6)
  for i=1,count do
   local span=(x1-x0)/count
   local x=x0+(i-0.5)*span
   local t=matrix(x,y,z+(rise or 0)*(x-x0)/(x1-x0),span/1.6,1,1)
   t[3]=(rise or 0)/(x1-x0)*span/1.6
   models[#models+1]={id=FENCE,transf=t}
  end
 end
 local function crossGuard(x,y0,y1,z)
  local count=math.ceil((y1-y0)/1.6)
  for i=1,count do
   local span=(y1-y0)/count
   models[#models+1]={id=FENCE,transf={0,span/1.6,0,0,-1,0,0,0,0,0,1,0,x,y0+(i-0.5)*span,z,1}}
  end
 end
 for _,side in ipairs({-1,1}) do
  fenceLine(first,last,side*9.25,FLOOR)
  for _,y in ipairs({5.25,7.75}) do
   fenceLine(stairStart,stairEnd,side*y,FLOOR)
   fenceLine(stairStart,stairEnd,side*y,GROUND,RISE)
  end
  crossGuard(stairStart,side*6.5-1.2,side*6.5+1.2,FLOOR)
  if fence then
   fenceLine(first,0,side*5.65,H)
   if isThrough then fenceLine(L,L+10,side*5.65,H) end
  end
 end
 if not isThrough then slab(L,L+4,-4,4,FLOOR,0.25);crossGuard(L+4,-9,9,FLOOR) end
 -- Native passenger-platform canopies cover the entire structural deck,
 -- including the terminus crossover sides. Only a final module is shortened.
 local roofRows={}
 local function roofPost(x)
  if x<first+0.5 or x>last-0.5 or (x>stairStart-0.5 and x<stairEnd+0.5) then return end
  for _,other in ipairs(roofRows) do if math.abs(x-other)<3 then return end end
  roofRows[#roofRows+1]=x
 end
 roofPost(first+2);roofPost(last-2);roofPost(stairStart-1);roofPost(stairEnd+1)
 for x=first+2,last-2,10 do roofPost(x) end
 for _,side in ipairs({-1,1}) do
  local x=first
  while x<last-1e-8 do
   local span=math.min(40,last-x)
   add("mrnickert_ultimate_metro::/elevated_platform_roof.mdl",x,side*6.5,FLOOR-1.1,span/40,1,1)
   x=x+span
  end
  for _,x in ipairs(roofRows) do
   add("::/assets/stations/rail/era_c_perron_pillar.mdl",x,side*6.5,FLOOR,1,1,3.82385/3.7637)
   add("::/assets/stations/rail/era_c_perron_holder.mdl",x,side*6.5,FLOOR+3.82385)
  end
 end
 -- Piers/crossbeams avoid the stairs and lower pedestrian cross-passage.
 local pads={rectangle(centre-PLAZA_HALF,centre+PLAZA_HALF,-14,9)}
 local rows={}
 local function row(x)
  if x<first+2 or x>last-2 or math.abs(x-centre)<PLAZA_HALF-0.01 then return end
  for _,other in ipairs(rows) do if math.abs(other-x)<3 then return end end
  rows[#rows+1]=x
  slab(x-1.2,x+1.2,-9,9,BEAM_TOP,0.8)
  for _,y in ipairs({-2.8,2.8}) do
   add(SLAB,x-0.75,y-0.75,PIER_TOP,1.5/6,1.5/4,PIER_TOP/2.4)
   pads[#pads+1]=rectangle(x-0.9,x+0.9,y-0.9,y+0.9)
  end
 end
 -- Anchor both pier lines at the plaza sides. No extra end piers may
 -- consume the 18.2m clear road corridor between successive foundations.
 for _,side in ipairs({-1,1}) do
  local distance=PLAZA_HALF
  while centre+side*distance>=first+2 and centre+side*distance<=last-2 do
   row(centre+side*distance);distance=distance+PIER_SPACING
  end
 end
 -- Exactly one ground entrance porch, centred along the station.
 slab(centre-PLAZA_HALF,centre+PLAZA_HALF,-14,9,GROUND,GROUND,true)
 -- 3m tiles retain the native sidewalk pattern at a constant world scale.
 for x=centre-PLAZA_HALF,centre+PLAZA_HALF-0.001,3 do
  for y=-14,9-0.001,3 do
   local depth=math.min(3,9-y)
   add("mrnickert_ultimate_metro::/elevated_paving.mdl",x,y,GROUND+0.001,1,depth/3,1)
  end
 end
 -- A park bench faces the street, beside the central walking route.
 add("mrnickert_ultimate_metro::/elevated_entrance.mdl",centre+2.8,-11.5,GROUND)
 local bench=models[#models].transf
 bench[1]=0;bench[2]=-1;bench[5]=1;bench[6]=0
 -- Keep the central public route and the frontage clear for a separately
 -- placed native bus stop. All greenery is behind the street-facing strip.
 for _,y in ipairs({-8.8,3.8}) do
  add("::/assets/streets/tree_bed_new.mdl",centre+7.8,y,GROUND)
  add("::/assets/vegetation/trees/apple_01/apple_01.mdl",centre+7.8,y,GROUND,0.45,0.45,0.45)
 end
 for _,position in ipairs({{-5.5,-10.2},{5.5,-10.2},{4.5,1.8},{8.5,1.8}}) do
  local x,y=centre+position[1],position[2]
  add("::/assets/buildings/res/flower_pots/raised_bed_c.mdl",x,y,GROUND)
  for _,offset in ipairs({-0.5,0.5}) do
   add("::/assets/vegetation/trees/azalea_01/azalea_01.mdl",x+offset,y,GROUND+0.72,0.35,0.35,0.35)
  end
 end
 sub.groundFaces={{face=rectangle(centre-PLAZA_HALF,centre+PLAZA_HALF,-14,9),
  modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}}}
 sub.terrainAlignmentLists={{type="EQUAL",faces=pads,slopeLow=0,slopeHigh=0}}
 sub.station.catchmentAreas={{position={centre,-14,0},radius=200}}
 -- Street tangent follows the front edge of the entrance apron (local X).
 -- The previous rail-end frame rotated the road across the pier rows.
 -- Match the native street-entrance convention: public walking node 1m
 -- inside the snap line, with the station extending along positive local Y.
 r.snapPoint={transf={1,0,0,0,0,1,0,0,0,0,1,0,centre,-15,0,1},
  snapToBaseEdgeTypes={"STREET"},allowSnapToBaseEdgeEnds=true}
 return r
end
