-- Save/UI compatibility adapter. New designs call the versioned API directly.
local api=require "mrnickert_ultimate_metro::/station_api_v1.lua"
local standard=require "mrnickert_ultimate_metro::/station_standard_kit.lua"
return function(capture,params)
 params=params or {}
 local lengths={40,60,80,100,120}
 local placementIndex=tonumber(params.placement)
 local placement=placementIndex==2 and "underground" or (placementIndex==3 and "elevated" or "surface")
 return api.buildStation({
  apiVersion=1,
  placement=placement,
  stationType=tonumber(params.stationType)==1 and "through" or "terminus",
  platformLength=lengths[tonumber(params.platformLength) or 3] or 80,
  platformTracks=2,
  fence=tonumber(params.fence or 2)~=1,
  design=standard(placement),
 },capture,params)
end
