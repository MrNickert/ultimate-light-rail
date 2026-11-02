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
local function tramSurface(models,lane,layer)
 -- Native tram-track texture follows the existing lane; no new network edges.
 for i=1,#lane.nodes,2 do
  local a,b=lane.nodes[i],lane.nodes[i+1]
  local dx,dy=b[1][1]-a[1][1],b[1][2]-a[1][2]
  local steps=math.ceil(math.sqrt(dx*dx+dy*dy)/0.5)
  local previous=curve(a,b,0)
  for step=1,steps do
   local current=curve(a,b,step/steps)
   local x,y=current[1]-previous[1],current[2]-previous[2]
   local length=math.sqrt(x*x+y*y)
   models[#models+1]={id="mrnickert_ultimate_metro::/tram_ribbon.mdl",
    transf={x/0.5,y/0.5,0,0,-y/length,x/length,0,0,0,0,1,0,previous[1],previous[2],0.015+(layer-1)*0.001,1}}
   previous=current
  end
 end
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
 -- Replace only the old ground-level railway rail visuals. Wires are added later.
 local models={}
 for _,model in ipairs(sub.models) do
  if model.id~="::/infrastructure/track/shared/single_rail.mdl" then models[#models+1]=model end
 end
 sub.models=models
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
 -- Keep the native asphalt ground face below the rails. A flattened platform
 -- mesh had its floor at z=0 too, causing depth fighting with the terrain.
 -- Raised passenger platforms and the head plaza remain separate models.
 -- Continuous low tram platforms: world x=0..80, y=4..9 / -9..-4.
 for _,side in ipairs({-1,1}) do
  for _,x in ipairs({0,40}) do add(PLATFORM,x,side*6.5,0,0,1,1,PLATFORM_SCALE) end
  local facing=side==1 and -math.pi/2 or math.pi/2
  for _,x in ipairs({20,60}) do
   add("::/assets/buildings/res/grd_frn/bench_c_metal.mdl",x,side*7.7,PLATFORM_HEIGHT,facing)
   add("::/assets/buildings/com/misc/trashcan_c_01.mdl",x+3,side*8.2,PLATFORM_HEIGHT)
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
 -- Four native 5x10m connecting tiles: no squashed 40m platform at the head.
 for _,x in ipairs({85,90}) do
  for _,y in ipairs({-4.5,4.5}) do
   add("mrnickert_ultimate_metro::/surface_head_tile.mdl",x,y,0,0,1,0.9,PLATFORM_SCALE)
  end
 end
 -- Greenery belongs only on the head plaza, clear of the overhead wiring.
 -- The public walkway at x=85 and the central entrance at y=0 remain open.
 for _,side in ipairs({-1,1}) do
  add("::/assets/streets/tree_bed_new.mdl",88.5,side*5.5,PLATFORM_HEIGHT)
  add("::/assets/vegetation/trees/apple_01/apple_01.mdl",88.5,side*5.5,PLATFORM_HEIGHT,0,0.65,0.65,0.65)
  for _,x in ipairs({82,88}) do
   add("::/assets/buildings/res/flower_pots/raised_bed_c.mdl",x,side*8.2,PLATFORM_HEIGHT)
   for _,offset in ipairs({-0.5,0.5}) do
    add("::/assets/vegetation/trees/azalea_01/azalea_01.mdl",x+offset,side*8.2,PLATFORM_HEIGHT+0.72,0,0.35,0.35,0.35)
   end
  end
 end
 for i=1,vehicles do
  tramSurface(models,sub.laneLists[i],i)
  wires(models,sub.laneLists[i],i>2)
 end
 return result
end
