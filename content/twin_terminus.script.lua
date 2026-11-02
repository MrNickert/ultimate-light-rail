-- Stable public script ID; surface appearance stays separate from vehicle logic.
local build=require "mrnickert_ultimate_metro::/terminus_util.lua"
local decorate=require "mrnickert_ultimate_metro::/surface_station_util.lua"
function data()
 return {updateFn=function(capture,params)
  local result=build(capture,params)
  -- Surface-only fenced variant, identical lane geometry and traffic modes.
  result.edgeLists[1].params.type="mrnickert_ultimate_metro::/lightrail_station_approach.street_template"
  return decorate(result)
 end}
end
