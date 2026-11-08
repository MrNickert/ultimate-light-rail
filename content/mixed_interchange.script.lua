local aboveground=require "mrnickert_ultimate_metro::/aboveground_interchange_util.lua"
local interchange=require "mrnickert_ultimate_metro::/interchange_util.lua"
local geometry=require "mrnickert_ultimate_metro::/underground_geometry.lua"
local LENGTH=80
local CENTRE=LENGTH/2
local PLAZA_HEIGHT=0.15
local CONCOURSE_HEIGHT=-12
-- These bounds align with the 3 m plaza tile grid, between the up stairs.
local OPENING={x0=36,x1=42,y0=16,y1=28}

local function addWall(sub,x0,x1,y0,y1)
 sub.models[#sub.models+1]={id="mrnickert_ultimate_metro::/elevated_concrete_visual.mdl",
  transf={(x1-x0)/6,0,0,0,0,(y1-y0)/4,0,0,0,0,(PLAZA_HEIGHT-CONCOURSE_HEIGHT)/2.4,0,
   x0,y0,PLAZA_HEIGHT,1}}
end

local function addRail(sub,x0,y0,x1,y1)
 local dx,dy=x1-x0,y1-y0
 local length=math.sqrt(dx*dx+dy*dy)
 local count=math.ceil(length/1.6)
 for i=1,count do
  local t=(i-0.5)/count
  sub.models[#sub.models+1]={id="mrnickert_ultimate_metro::/lightrail_fence.mdl",
   transf={dx/(1.6*count),dy/(1.6*count),0,0,-dy/length,dx/length,0,0,0,0,1,0,
    x0+t*dx,y0+t*dy,PLAZA_HEIGHT,1}}
 end
end

local function connectPlaza(sub)
 local a,b=OPENING.x0,OPENING.x1
 local near,far=OPENING.y0,OPENING.y1
 local left,right=a+1.5,b-1.5
 local turn=far-1.5
 local halfway=(PLAZA_HEIGHT+CONCOURSE_HEIGHT)/2
 geometry.addStairs(sub,{
  {CENTRE,12.5,PLAZA_HEIGHT},{left,near,PLAZA_HEIGHT},
  {left,turn,halfway},{right,turn,halfway},
  {right,near,CONCOURSE_HEIGHT},{CENTRE,near,CONCOURSE_HEIGHT},
 })
 addWall(sub,a,a+0.2,near,far)
 addWall(sub,b-0.2,b,near,far)
 addWall(sub,a+0.2,b-0.2,far-0.2,far)
 addRail(sub,a,near,a,far)
 addRail(sub,b,near,b,far)
 addRail(sub,a,far,b,far)
 addRail(sub,(a+b)/2,near,b,near)
end

function data()
 return {updateFn=function(capture,params)
  local result=aboveground(capture,params,OPENING)
  local undergroundParams={}
  for key,value in pairs(params or {}) do undergroundParams[key]=value end
  undergroundParams.ulrInterchangeInternalConcourse=true
  local underground=interchange.buildLevel(-1,LENGTH,capture,undergroundParams)
  -- Same axis as the elevated layer. The concourse ring meets the bottom
  -- landing at the ring's near end, 8.5 m from its centre.
  local concourseCentre=OPENING.y0+8.5
  geometry.transformLevel(underground,{0,1,0,0,-1,0,0,0,0,0,1,0,
   CENTRE,concourseCentre-CENTRE,0,1})
  interchange.appendLevel(result,underground)
  connectPlaza(result.subconstructions[1])
  for _,edge in ipairs(underground.edgeLists) do edge.maxNodeSnapAngle=0 end
  return result
 end}
end
