-- Decoration is applied only by the surface adapter, after the shared builder.
-- The underground builder never loads this module or the visual platform model.
local PLATFORM_HEIGHT=0.25
local PLATFORM_SCALE=PLATFORM_HEIGHT/0.8
local PLATFORM="mrnickert_ultimate_metro::/surface_platform.mdl"
local function matrix(x,y,z,angle,sx,sy,sz)
 local c,s=math.cos(angle or 0),math.sin(angle or 0)
 return {c*(sx or 1),s*(sx or 1),0,0,-s*(sy or 1),c*(sy or 1),0,0,
  0,0,sz or 1,0,x,y,z,1}
end
local function curve(a,b,t)
 local t2,t3=t*t,t*t*t;local p={}
 for k=1,3 do p[k]=(2*t3-3*t2+1)*a[1][k]+(t3-2*t2+t)*a[2][k]
  +(-2*t3+3*t2)*b[1][k]+(t3-t2)*b[2][k] end
 return p
end
local function wires(models,lane,curved)
 -- The existing bare rail mesh becomes a thin decorative metal contact wire.
 -- This is visual only; electrical availability still comes from the lanes.
 for i=1,#lane.nodes,2 do
  local a,b=lane.nodes[i],lane.nodes[i+1]
  local steps=curved and 6 or 1
  local previous=curve(a,b,0)
  for step=1,steps do
   local current=curve(a,b,step/steps)
   local dx,dy=current[1]-previous[1],current[2]-previous[2]
   local length=math.sqrt(dx*dx+dy*dy)
   models[#models+1]={id="::/infrastructure/track/shared/single_rail.mdl",
    transf={dx/4,dy/4,0,0,-dy/length*0.15,dx/length*0.15,0,0,0,0,0.15,0,
     (previous[1]+current[1])/2,(previous[2]+current[2])/2,5.5-0.53*0.15,1}}
   previous=current
  end
 end
end
return function(result)
 local sub=result.subconstructions[1]
 local models=sub.models
 local function add(id,x,y,z,angle,sx,sy,sz)
  models[#models+1]={id=id,transf=matrix(x,y,z,angle,sx,sy,sz)}
 end
 local vehicles=0
 for _,lane in ipairs(sub.laneLists) do
  if lane.transportModes[1]=="PERSON" then
   -- Lift each shared point once, preserving passenger graph and references.
   for _,node in ipairs(lane.nodes) do node[1][3]=PLATFORM_HEIGHT end
  else vehicles=vehicles+1 end
 end
 -- Existing shelters stay in their original positions, standing on the slabs.
 for _,model in ipairs(models) do
  if model.id=="::/stations/street/small_stops/small_new.mdl" then
   model.transf[15]=PLATFORM_HEIGHT
  end
 end
 -- Real visible paving below the rails, rather than a terrain tint alone.
 for _,segment in ipairs({{-30,30},{0,40},{40,40}}) do
  add(PLATFORM,segment[1],0,-0.008,0,segment[2]/40,8/5,0.01)
 end
 -- Continuous low tram platforms: world x=0..80, y=4..9 / -9..-4.
 for _,side in ipairs({-1,1}) do
  for _,x in ipairs({0,40}) do add(PLATFORM,x,side*6.5,0,0,1,1,PLATFORM_SCALE) end
  local facing=side==1 and -math.pi/2 or math.pi/2
  for _,x in ipairs({20,60}) do
   add("::/assets/buildings/res/grd_frn/bench_c_metal.mdl",x,side*7.7,PLATFORM_HEIGHT,facing)
   add("::/assets/buildings/com/misc/trashcan_c_01.mdl",x+3,side*8.2,PLATFORM_HEIGHT)
  end
  for _,x in ipairs({12,68}) do
   add("::/assets/buildings/res/flower_pots/raised_bed_c.mdl",x,side*8.2,PLATFORM_HEIGHT)
  end
  for _,x in ipairs({6,28,52,74}) do
   add("::/assets/buildings/res/garden_lamp/garden_lamp_c_stand.mdl",x,side*8.7,PLATFORM_HEIGHT,
    side==1 and 0 or math.pi)
  end
  for _,x in ipairs({-15,8,28,52,72}) do
   add("::/assets/streets/tram_pole_crossbar.mdl",x,side*6.5,x<0 and 0 or PLATFORM_HEIGHT,
    side==1 and math.pi or 0,1,4/3.13368,0.75)
  end
 end
 -- Broad paved head plaza joins both platforms and their public access lane.
 add(PLATFORM,80,0,0,0,10/40,18/5,PLATFORM_SCALE)
 for i=1,vehicles do wires(models,sub.laneLists[i],i>2) end
 return result
end
