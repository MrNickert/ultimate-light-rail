-- Stable full-result serialization: all fields, model order and numeric precision.
return function(resource,directory)
 local function writeValue(file,value)
  local kind=type(value)
  if kind=="table" then
   local keys={};for k in pairs(value) do keys[#keys+1]=k end
   table.sort(keys,function(a,b)
    if type(a)~=type(b) then return type(a)<type(b) end
    return a<b
   end)
   file:write("{")
   for _,k in ipairs(keys) do writeValue(file,k);file:write(":");writeValue(file,value[k]);file:write(",") end
   file:write("}")
  elseif kind=="number" then file:write(string.format("%.17g",value))
  elseif kind=="string" then file:write(string.format("%q",value))
  elseif kind=="boolean" then file:write(tostring(value))
  else error("Unsupported snapshot value: "..kind) end
 end
 local function snapshot(name,build,params)
  local file=assert(io.open(directory.."/"..name..".txt","wb"))
  local result=build({},params)
  writeValue(file,result);file:close()
  -- Preserve a separate functional baseline before the standard-kit migration.
  for _,sub in ipairs(result.subconstructions or {}) do sub.models=nil end
  file=assert(io.open(directory.."/"..name..".functional","wb"))
  writeValue(file,result);file:close()
 end
 -- Historical snapshots predate the road-placement frames. Keep that comparison
 -- focused on geometry; the public and built-in snap results are tested separately.
 local buildStandard=require "mrnickert_ultimate_metro::/station_config_util.lua"
 local rawThrough=require "mrnickert_ultimate_metro::/through_station_util.lua"
 local rawTerminus=require "mrnickert_ultimate_metro::/terminus_util.lua"
 local function standard(capture,params)
  local result=buildStandard(capture,params)
  if params.placement~=1 then
   for _,edge in ipairs(result.edgeLists) do edge.maxNodeSnapAngle=nil end
   if params.placement~=3 then
    local raw=params.stationType==1 and rawThrough or rawTerminus
    result.snapPoint=raw(capture,params).snapPoint
   end
  end
  return result
 end
 for placement=1,3 do for kind=1,2 do for length=1,5 do for fence=1,2 do
  snapshot(table.concat({placement,kind,length,fence},"-"),standard,
   {placement=({2,1,3})[placement],stationType=kind,platformLength=length,fence=fence,seed=42})
 end end end end
 for i,params in ipairs({{}, {seed=42}, {placement=3,seed=42},
  {placement=1,stationType=1,seed=42},
  {placement=2,stationType=2,crossover=1,seed=42},
  {placement=2,stationType=1,platformLength=99,seed=42}}) do snapshot("defaults-"..i,standard,params) end
 for _,name in ipairs({"twin_terminus","through_station","underground_terminus"}) do
  for option=1,2 do snapshot(name.."-"..option,resource(name..".script.lua").updateFn,{crossover=option,seed=42}) end
 end
end
