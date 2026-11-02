local terminus=require "mrnickert_ultimate_metro::/terminus_util.lua"
local through=require "mrnickert_ultimate_metro::/through_station_util.lua"
local decorate=require "mrnickert_ultimate_metro::/surface_station_util.lua"
local underground=require "mrnickert_ultimate_metro::/underground_station_util.lua"
return function(capture,params)
 params=params or {}
 -- Copy: the UI/save parameter table must not be changed by a builder.
 local config={};for k,v in pairs(params) do config[k]=v end
 local isThrough=tonumber(params.stationType)==1
 local isUnderground=tonumber(params.placement)==2
 local fence=not isUnderground and tonumber(params.fence or 2)~=1
 -- No public crossover parameter. Even stale/injected values cannot override type.
 config.crossover=isThrough and 1 or 2
 if isUnderground then return underground(capture,config,isThrough) end
 local result
 if isThrough then
  result=through(capture,config)
 else
  result=decorate(terminus(capture,config))
  result.edgeLists[1].params.type="mrnickert_ultimate_metro::/lightrail_station_approach.street_template"
 end
 if not fence then
  for _,sub in ipairs(result.subconstructions) do
   local models={}
   for _,model in ipairs(sub.models) do
    if model.id~="mrnickert_ultimate_metro::/lightrail_fence.mdl" then models[#models+1]=model end
   end
   sub.models=models
  end
  for _,edge in ipairs(result.edgeLists) do
   edge.params.type=isThrough and "::/infrastructure/street/tram/tram_new.street_template"
    or "mrnickert_ultimate_metro::/lightrail_double.street_template"
  end
 end
 return result
end
