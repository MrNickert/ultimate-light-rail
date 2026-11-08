local aboveground=require "mrnickert_ultimate_metro::/aboveground_interchange_util.lua"
local interchange=require "mrnickert_ultimate_metro::/interchange_util.lua"
local geometry=require "mrnickert_ultimate_metro::/underground_geometry.lua"
local track=require "mrnickert_ultimate_metro::/station_turnback_track.lua"
local LENGTH=80
local DIAGONAL=math.sqrt(0.5)

local function streetEntrance(sub)
 for _,lane in ipairs(sub.laneLists) do
  if lane.linkable and lane.transportModes[1]=="PERSON" then return lane.nodes[1][1] end
 end
 error("The underground interchange level has no public entrance")
end

local function connectEntrance(sub,from,to)
 sub.laneLists[#sub.laneLists+1]=track.lane({from,to},{"PERSON"},false,false)
 local dx,dy=to[1]-from[1],to[2]-from[2]
 local distance=math.sqrt(dx*dx+dy*dy)
 local nx,ny=-dy/distance,dx/distance
 sub.models[#sub.models+1]={id="mrnickert_ultimate_metro::/elevated_paving.mdl",
  transf={dx/3,dy/3,(to[3]-from[3])/3,0,nx*0.8,ny*0.8,0,0,0,0,1,0,
   from[1]-nx*1.2,from[2]-ny*1.2,from[3],1}}
end

function data()
 return {updateFn=function(capture,params)
  local result=aboveground(capture,params)
  local underground=interchange.buildLevel(-1,LENGTH,capture,params)
  local c=DIAGONAL
  -- The diagonal level has its native entrance next to the far surface exit,
  -- clear of the viaduct and the surface tracks.
  geometry.transformLevel(underground,{c,c,0,0,-c,c,0,0,0,0,1,0,
   LENGTH/2+12-c*LENGTH/2,-1-c*LENGTH/2,0,1})
  local combined,lower=result.subconstructions[1],underground.subconstructions[1]
  interchange.appendLevel(result,underground)
  interchange.append(combined.groundFaces,lower.groundFaces)
  interchange.append(combined.terrainAlignmentLists,lower.terrainAlignmentLists)
  connectEntrance(combined,{LENGTH-1.5,11,0.25},streetEntrance(lower))
  for _,edge in ipairs(underground.edgeLists) do edge.maxNodeSnapAngle=0 end
  return result
 end}
end
