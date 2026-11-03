local api=require "mrnickert_ultimate_metro::/station_api_v1.lua"
function data()
 return {updateFn=function(capture,params)
  local lengths={40,60,80,100,120}
  local minimal=tonumber(params.appearance)==2
  local kit={platform={model="ulr_contract_example::/example_platform20.mdl",moduleLength=20},
   shelter=false,trees=false,planters=false,
   canopy={model="ulr_contract_example::/example_roof20.mdl",moduleLength=20},
   benches="default",bins="default",lights="default"}
  -- False explicitly means no component; it is not a missing/default value.
  if minimal then kit.canopy=false;kit.benches=false;kit.bins=false;kit.lights=false end
  return api.buildStation({apiVersion=1,placement="surface",
   stationType=tonumber(params.layout)==2 and "terminus" or "through",
   platformLength=lengths[tonumber(params.length) or 3] or 80,platformTracks=2,fence=true,
   design={apiVersion=1,id="ulr_component_example",components=kit}},capture,params)
 end}
end
