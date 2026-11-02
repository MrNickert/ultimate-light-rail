-- Supported viaduct, real stair openings and individual concrete stair treads.
local terminus=require "mrnickert_ultimate_metro::/terminus_util.lua"
local through=require "mrnickert_ultimate_metro::/through_station_util.lua"
local decorate=require "mrnickert_ultimate_metro::/surface_station_util.lua"
local H,FLOOR=8,8.25
local SLAB="::/infrastructure/bridge/concrete/c_6_rep_rep.mdl"
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
 local sub=r.subconstructions[1]
 local vehicles=isThrough and 2 or 4
 local centre=L/2
 local first,last=isThrough and -10 or -30,isThrough and L+10 or L+4
 local stairStart,stairEnd=centre-6,centre+6
 -- A single public entrance branches below the tracks to both stairs.
 local paths={}
 for i=1,vehicles do paths[#paths+1]=sub.laneLists[i] end
 for _,side in ipairs({-1,1}) do
  paths[#paths+1]=lane({{0,side*4.65,FLOOR},{centre,side*4.65,FLOOR},
   {stairEnd,side*4.65,FLOOR},{L,side*4.65,FLOOR}})
 end
 for _,side in ipairs({-1,1}) do
  paths[#paths+1]=lane({{stairStart,side*6.5,0},{stairEnd,side*6.5,FLOOR},
   {stairEnd,side*4.65,FLOOR}})
 end
 paths[#paths+1]=lane({{stairStart,-6.5,0},{stairStart,6.5,0}})
 paths[#paths+1]=lane({{centre,-14,0},{centre,-6.5,0},{stairStart,-6.5,0}},true)
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
  if m.id~="mrnickert_ultimate_metro::/surface_platform.mdl" and m.id~=FENCE then
   m.transf[15]=m.transf[15]+H;models[#models+1]=m
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
 -- Native slab is 6 x 4m and extends 2.4m below its top face.
 local function slab(x0,x1,y0,y1,z,thickness)
  -- Repeat normal 6m pieces instead of stretching one texture over a viaduct.
  while x0<x1-1e-8 do
   local span=math.min(6,x1-x0)
   add(SLAB,x0,y0,z,span/6,(y1-y0)/4,thickness/2.4)
   x0=x0+span
  end
 end
 -- 0.8m load-bearing deck; two actual 12 x 2.4m stair openings.
 slab(first,stairStart,-9,9,H,0.8);slab(stairEnd,last,-9,9,H,0.8)
 slab(stairStart,stairEnd,-4,4,H,0.8)
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
  deck(0,stairStart,6.5,5);deck(stairEnd,L,6.5,5)
  deck(stairStart,stairEnd,4.65,1.3);deck(stairStart,stairEnd,8.35,1.3)
  -- Forty-one visible treads: 29.3cm deep, 20.1cm high.
  for i=1,41 do
   slab(stairStart+(i-1)*12/41,stairStart+i*12/41,
    side*6.5-1.2,side*6.5+1.2,i*FLOOR/41,FLOOR/41)
  end
  -- A sloping concrete waist supports the treads all the way to the ground.
  local waist=matrix(stairStart,side*6.5-1.2,0,12/6,2.4/4,0.25/2.4)
  waist[3]=FLOOR/6
  models[#models+1]={id=SLAB,transf=waist}
 end
 -- Native fascias provide mandatory outer platform safety railings.
 for _,side in ipairs({-1,1}) do
  local id=side==-1 and "::/infrastructure/bridge/concrete/c_6_rep_l.mdl"
   or "::/infrastructure/bridge/concrete/c_6_rep_r.mdl"
  local x=0
  while x<L do local span=math.min(6,L-x);add(id,x,side*9,FLOOR,span/6,1,1);x=x+span end
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
  for _,y in ipairs({5.25,7.75}) do
   fenceLine(stairStart,stairEnd,side*y,FLOOR)
   fenceLine(stairStart,stairEnd,side*y,0,FLOOR)
  end
  crossGuard(stairStart,side*6.5-1.2,side*6.5+1.2,FLOOR)
  if fence then
   fenceLine(first,0,side*5.65,H)
   if isThrough then fenceLine(L,L+10,side*5.65,H) end
  end
 end
 if not isThrough then slab(L,L+4,-9,9,FLOOR,0.25);crossGuard(L+4,-9,9,FLOOR) end
 -- Piers/crossbeams avoid the stairs and lower pedestrian cross-passage.
 local pads={rectangle(centre-8,centre+8,-14,9)}
 local rows={}
 local function row(x)
  if x<first+2 or x>last-2 or math.abs(x-centre)<8 then return end
  for _,other in ipairs(rows) do if math.abs(other-x)<3 then return end end
  rows[#rows+1]=x
  slab(x-1.2,x+1.2,-9,9,7.2,0.8)
  for _,y in ipairs({-2.8,2.8}) do
   add("::/infrastructure/bridge/concrete/c_pillar_small_bot_m.mdl",x,y-0.75,0,0.5,0.5,6.4/3.4)
   pads[#pads+1]=rectangle(x-0.9,x+0.9,y-0.9,y+0.9)
  end
 end
 row(centre-10);row(centre+10);row(first+4);row(last-4)
 for x=first+4,last-4,20 do row(x) end
 -- Exactly one ground entrance porch, centred along the station.
 slab(centre-8,centre+8,-14,9,0,0.15)
 add("::/stations/street/small_stops/small_new.mdl",centre,-11.5,0)
 sub.groundFaces={{face=rectangle(centre-8,centre+8,-14,9),
  modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}}}
 sub.terrainAlignmentLists={{type="EQUAL",faces=pads,slopeLow=0,slopeHigh=0}}
 sub.station.catchmentAreas={{position={centre,-14,0},radius=200}}
 r.snapPoint={transf={0,-1,0,0,1,0,0,0,0,0,1,0,centre,-14,0,1},
  snapToBaseEdgeTypes={"STREET"},allowSnapToBaseEdgeEnds=true}
 return r
end
