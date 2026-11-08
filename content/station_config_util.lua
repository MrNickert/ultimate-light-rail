-- UI adapter: clean order 1=underground, 2=surface, 3=elevated.
-- New designs call the versioned API directly with named placements.
local levels=require "mrnickert_ultimate_metro::/underground_levels.lua"
local api=require "mrnickert_ultimate_metro::/station_api_v1.lua"
local standard=require "mrnickert_ultimate_metro::/station_standard_kit.lua"
return function(capture,params)
 params=params or {}
 local lengths={40,60,80,100,120}
 local placementIndex=tonumber(params.placement)
 local placement=placementIndex==1 and "underground" or (placementIndex==3 and "elevated" or "surface")
 local level=-(tonumber(params.depth) or 1)
 local length=lengths[tonumber(params.platformLength) or 3] or 80
 local isThrough=tonumber(params.stationType)==1
 return api.buildStation({
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
end
