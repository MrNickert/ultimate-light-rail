-- UI adapter: clean order 1=underground, 2=surface, 3=elevated.
-- New designs call the versioned API directly with named placements.
local levels=require "mrnickert_ultimate_metro::/underground_levels.lua"
local api=require "mrnickert_ultimate_metro::/station_api_v1.lua"
local standard=require "mrnickert_ultimate_metro::/station_standard_kit.lua"
return function(capture,params,withPlacementSnap)
 params=params or {}
 local lengths={40,60,80,100,120}
 local placementIndex=tonumber(params.placement)
 local placement=placementIndex==1 and "underground" or (placementIndex==3 and "elevated" or "surface")
 local level=-(tonumber(params.depth) or 1)
 local length=lengths[tonumber(params.platformLength) or 3] or 80
 local isThrough=tonumber(params.stationType)==1
 local result=api.buildStation({
  apiVersion=1,
  placement=placement,
  stationType=isThrough and "through" or "terminus",
  platformLength=length,
  platformTracks=2,
  undergroundLevel=placement=="underground" and levels.trackZ(level) and level or nil,
  turnback=isThrough and tonumber(params.turnback)==2,
  fence=tonumber(params.fence or 2)~=1,
  design=standard(placement),
 },capture,params)
 if not withPlacementSnap or placement=="underground" then return result end
 if placement=="surface" then
  local frame
  if isThrough then
   -- Align the long platform edge to the street, just outside its deck.
   frame={1,0,0,0,0,1,0,0,0,0,1,0,length/2,-10,0,1}
  else
   -- The tram approach is at the opposite end from the public head plaza.
   frame={0,1,0,0,-1,0,0,0,0,0,1,0,length+6,0,0,1}
  end
  result.snapPoint={transf=frame,snapToBaseEdgeTypes={"STREET"},allowSnapToBaseEdgeEnds=true}
 end
 for _,edge in ipairs(result.edgeLists) do
  -- Constrain automatic approach alignment when building the station.
  -- The end nodes remain exposed for drawing connections afterwards.
  edge.maxNodeSnapAngle=0
 end
 return result
end
