local api=require "mrnickert_ultimate_metro::/station_api_v1.lua"
function data()
 return {updateFn=function(capture,params)
  return api.buildStation({
   apiVersion=1,placement="surface",stationType="through",platformLength=80,platformTracks=2,fence=true,
   design={apiVersion=1,id="ulr_contract_example",assets={platformSurface="ulr_contract_example::/example_platform.mdl"}},
  },capture,params)
 end}
end
