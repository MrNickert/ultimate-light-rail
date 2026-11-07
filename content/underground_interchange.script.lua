local stationApi=require "mrnickert_ultimate_metro::/station_api_v1.lua"
local concourse=require "mrnickert_ultimate_metro::/underground_concourse_util.lua"
local geometry=require "mrnickert_ultimate_metro::/underground_geometry.lua"
local levels=require "mrnickert_ultimate_metro::/underground_levels.lua"
local LENGTHS={40,60,80,100,120}
local DEFAULT_ANGLES={1,3,2,4}
local DIAGONAL=math.sqrt(0.5)
local FOUR_LEVEL_ROTATIONS={{1,0},{DIAGONAL,DIAGONAL},{0,1},{-DIAGONAL,DIAGONAL}}

local function append(target,source)
 for _,value in ipairs(source) do target[#target+1]=value end
end

local function buildLevel(capture,params,internal,length)
 local result=stationApi.buildStation({apiVersion=1,placement="underground",
  stationType="through",platformLength=length,turnback=true},capture,params)
 result.subconstructions[1]=concourse(result.subconstructions[1],params,true,length,true,
  {centred=true,internal=internal})
 result.snapPoint.transf[13]=length/2+8
 return result
end

local function connectLevels(sub,upperRotation,lowerRotation,offset,side)
 local c,s=upperRotation[1],upperRotation[2]
 local points={{0,11.75,-12},{0,16,-12},{-26,18,-21}}
 for i,point in ipairs(points) do
  points[i]={side*(c*point[1]-s*point[2]),side*(s*point[1]+c*point[2]),point[3]+offset}
 end
 local lc,ls=lowerRotation[1],lowerRotation[2]
 points[4]={-side*ls*16,side*lc*16,-30+offset}
 points[5]={-side*ls*11.75,side*lc*11.75,-30+offset}
 geometry.addStairs(sub,points)
end

local function connectConfiguredLevels(sub,upper,lower,offset,side)
 local ux,uy=-side*upper[2],side*upper[1]
 local lx,ly=-lower[2],lower[1]
 -- Use the same exterior quadrant when possible. Return the lower landing side
 -- so the next flight can depart from the opposite side of that concourse.
 local lowerSide=ux*lx+uy*ly<0 and -1 or 1
 lx,ly=lx*lowerSide,ly*lowerSide
 local scale=36/(1+ux*lx+uy*ly)
 local x,y=(ux+lx)*scale,(uy+ly)*scale
 local dx,dy=(uy+ly)*2,-(ux+lx)*2
 geometry.addStairs(sub,{
  {ux*11.75,uy*11.75,-12+offset},{ux*16,uy*16,-12+offset},
  {x+dx,y+dy,-21+offset},{x-dx,y-dy,-21+offset},
  {lx*16,ly*16,-30+offset},{lx*11.75,ly*11.75,-30+offset},
 })
 return lowerSide
end

local function appendLevel(result,level)
 local top,bottom=result.subconstructions[1],level.subconstructions[1]
 local offset=#top.laneLists
 -- All terminals share one station, with zero-based references into its lanes.
 for _,terminal in ipairs(bottom.station.terminals) do
  terminal.vehicleNode[1]=terminal.vehicleNode[1]+offset
  for _,ref in ipairs(terminal.personEdges) do ref[1]=ref[1]+offset end
  for _,ref in ipairs(terminal.personNodes) do ref[1]=ref[1]+offset end
 end
 append(top.station.terminals,bottom.station.terminals)
 append(top.laneLists,bottom.laneLists)
 append(top.models,bottom.models)
 append(top.colliders,bottom.colliders)
 append(result.edgeLists,level.edgeLists)
 result.cost=result.cost+level.cost
 result.maintenanceCost=result.maintenanceCost+level.maintenanceCost
end

function data()
 return {updateFn=function(capture,params)
  local fourLevels=capture and capture.fourLevelTest==true
  params=params or {}
  local count=tonumber(params.levelCount)
  if not count or count%1~=0 or count<1 or count>levels.count then count=2 end
  if fourLevels then count=4 end
  local rotations,lengths={},{}
  local legacy=count==2
  for i=1,count do
   local angle=fourLevels and i or tonumber(params["levelAngle"..i])
   local lengthIndex=not fourLevels and tonumber(params["levelLength"..i])
   lengths[i]=LENGTHS[lengthIndex] or 80
   rotations[i]=FOUR_LEVEL_ROTATIONS[angle] or FOUR_LEVEL_ROTATIONS[DEFAULT_ANGLES[i]]
   legacy=legacy and rotations[i]==FOUR_LEVEL_ROTATIONS[DEFAULT_ANGLES[i]] and lengths[i]==80
  end
  local result
  for i,rotation in ipairs(rotations) do
   local c,s=rotation[1],rotation[2]
   local length=lengths[i]
   local centre=length/2
   local level=buildLevel(capture,params,i>1,length)
   geometry.transformLevel(level,{c,s,0,0,-s,c,0,0,0,0,1,0,-centre*c,-centre*s,levels.offset(-i),1})
   if i==1 then result=level else appendLevel(result,level) end
  end
  local sub=result.subconstructions[1]
  if fourLevels then
   for i=1,#rotations-1 do
    -- Opposite landings on intermediate levels avoid overlapping stair routes.
    connectLevels(sub,rotations[i],rotations[i+1],levels.offset(-i),i%2==1 and 1 or -1)
   end
  elseif legacy then
   geometry.addStairs(sub,{{0,11.75,-12},{0,15.5,-12},{-16,15.5,-21},{-16,0,-30},{-11.75,0,-30}})
  else
   local side=1
   for i=1,count-1 do
    side=-connectConfiguredLevels(sub,rotations[i],rotations[i+1],levels.offset(-i),side)
   end
  end
  return result
 end}
end
