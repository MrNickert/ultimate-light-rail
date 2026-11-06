local stationApi=require "mrnickert_ultimate_metro::/station_api_v1.lua"
local concourse=require "mrnickert_ultimate_metro::/underground_concourse_util.lua"
local laneutil=require "::/scripts/construction/laneutil.lua"
local DEPTH=18
local LENGTHS={40,60,80,100,120}
local DEFAULT_ANGLES={1,3,2,4}
local DIAGONAL=math.sqrt(0.5)
local FOUR_LEVEL_ROTATIONS={{1,0},{DIAGONAL,DIAGONAL},{0,1},{-DIAGONAL,DIAGONAL}}

local function transform(m,p,point)
 local offset=point and 1 or 0
 return {m[1]*p[1]+m[5]*p[2]+offset*m[13],
  m[2]*p[1]+m[6]*p[2]+offset*m[14],p[3]+offset*m[15]}
end

-- Construction model and snap transforms are serialized 4x4 arrays.
local function transformMatrix(level,matrix)
 local result={}
 for i=1,16,4 do
  local w=matrix[i+3]
  result[i]=level[1]*matrix[i]+level[5]*matrix[i+1]+level[13]*w
  result[i+1]=level[2]*matrix[i]+level[6]*matrix[i+1]+level[14]*w
  result[i+2]=matrix[i+2]+level[15]*w
  result[i+3]=w
 end
 return result
end

local function transformLevel(result,m)
 local sub=result.subconstructions[1]
 for _,lane in ipairs(sub.laneLists) do
  for _,node in ipairs(lane.nodes) do
   node[1]=transform(m,node[1],true)
   node[2]=transform(m,node[2],false)
  end
 end
 for _,edge in ipairs(result.edgeLists) do
  for _,node in ipairs(edge.edges) do
   node[1]=transform(m,node[1],true)
   node[2]=transform(m,node[2],false)
  end
 end
 for _,model in ipairs(sub.models) do model.transf=transformMatrix(m,model.transf) end
 for _,collider in ipairs(sub.colliders) do
  for i,p in ipairs(collider.params.points) do collider.params.points[i]=transform(m,p,true) end
 end
 for _,entry in ipairs(sub.station.catchmentAreas) do entry.position=transform(m,entry.position,true) end
 if sub.groundFaces then
  for _,face in ipairs(sub.groundFaces) do
   for i,p in ipairs(face.face) do face.face[i]=transform(m,p,true) end
  end
 end
 for _,alignment in ipairs(sub.terrainAlignmentLists or {}) do
  for _,triangle in ipairs(alignment.triangles or {}) do
   for i,p in ipairs(triangle) do triangle[i]=transform(m,p,true) end
  end
 end
 result.snapPoint.transf=transformMatrix(m,result.snapPoint.transf)
end

local function append(target,source)
 for _,value in ipairs(source) do target[#target+1]=value end
end

local function transfer(sub,points)
 local curves={}
 for i=1,#points-1 do
  local a,b=points[i],points[i+1]
  curves[#curves+1]={a,b}
  local dx,dy,dz=b[1]-a[1],b[2]-a[2],b[3]-a[3]
  local run=math.sqrt(dx*dx+dy*dy)
  local steps=math.max(1,math.ceil(math.abs(dz)/0.2))
  for j=1,steps do
   local t=(j-1)/steps
   local nx,ny=-dy/run,dx/run
   sub.models[#sub.models+1]={id="mrnickert_ultimate_metro::/elevated_concrete_visual.mdl",
    transf={dx/(6*steps),dy/(6*steps),0,0,nx*0.6,ny*0.6,0,0,0,0,0.12,0,
     a[1]+dx*t-nx*1.2,a[2]+dy*t-ny*1.2,a[3]+dz*t,1}}
  end
 end
 sub.laneLists[#sub.laneLists+1]=laneutil.createLane(curves,{"PERSON"},2,2,false)
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
 transfer(sub,points)
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
 transfer(sub,{
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
  if not count or count%1~=0 or count<1 or count>4 then count=2 end
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
   transformLevel(level,{c,s,0,0,-s,c,0,0,0,0,1,0,-centre*c,-centre*s,-DEPTH*(i-1),1})
   if i==1 then result=level else appendLevel(result,level) end
  end
  local sub=result.subconstructions[1]
  if fourLevels then
   for i=1,#rotations-1 do
    -- Opposite landings on intermediate levels avoid overlapping stair routes.
    connectLevels(sub,rotations[i],rotations[i+1],-DEPTH*(i-1),i%2==1 and 1 or -1)
   end
  elseif legacy then
   transfer(sub,{{0,11.75,-12},{0,15.5,-12},{-16,15.5,-21},{-16,0,-30},{-11.75,0,-30}})
  else
   local side=1
   for i=1,count-1 do
    side=-connectConfiguredLevels(sub,rotations[i],rotations[i+1],-DEPTH*(i-1),side)
   end
  end
  return result
 end}
end
