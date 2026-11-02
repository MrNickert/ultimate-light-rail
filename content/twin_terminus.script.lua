-- Stable public script ID; surface appearance stays separate from vehicle logic.
local build=require "mrnickert_ultimate_metro::/terminus_util.lua"
local decorate=require "mrnickert_ultimate_metro::/surface_station_util.lua"
function data()
 return {updateFn=function(capture,params) return decorate(build(capture,params)) end}
end
