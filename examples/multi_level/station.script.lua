local station = require "mrnickert_ultimate_metro::/station_api_v1.lua"

function data()
 local surface = station.getDefaultKit("surface")
 surface.id = "example_open_platform"
 surface.components.shelter = false
 local elevated = station.getDefaultKit("elevated")
 elevated.id = "example_covered_platform"
 elevated.components.canopy = {
  model = "mrnickert_ultimate_metro::/platform_roof20.mdl", moduleLength = 20,
 }
 return {updateFn=function(capture, params)
  return station.buildInterchange({apiVersion=1,layers={
   {level=0,platformLength=60,rotation=0,design=surface},
   {level=1,platformLength=100,rotation=90,offset={x=1,y=20.5},design=elevated},
  }},capture,params)
 end}
end
