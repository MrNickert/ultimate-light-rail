local build=require "mrnickert_ultimate_metro::/station_config_util.lua"
function data()
 return {updateFn=function(capture,params) return build(capture,params) end}
end
