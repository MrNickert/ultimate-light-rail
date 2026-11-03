-- Save/UI compatibility adapter. New designs call the versioned API directly.
local api=require "mrnickert_ultimate_metro::/station_api_v1.lua"
local standard=require "mrnickert_ultimate_metro::/station_standard_design.lua"
return function(capture,params)
 params=params or {}
 local lengths={40,60,80,100,120}
 local placement=tonumber(params.placement)
 return api.buildStation({
  apiVersion=1,
  placement=placement==2 and "underground" or (placement==3 and "elevated" or "surface"),
  stationType=tonumber(params.stationType)==1 and "through" or "terminus",
  platformLength=lengths[tonumber(params.platformLength) or 3] or 80,
  platformTracks=2,
  fence=tonumber(params.fence or 2)~=1,
  design=standard(),
 },capture,params)
end
