-- Detect identical vehicle curves, including an opposite-direction definition.
local function main()
 local function loadScript(path)
  local env=setmetatable({}, {__index=_G})
  assert(loadfile(path,"t",env))();return env.data()
 end
 local function vector(v,sign)
  return string.format("%.6f,%.6f,%.6f",v[1]*sign+0,v[2]*sign+0,v[3]*sign+0)
 end
 local function key(a,b)
  return vector(a[1],1).."|"..vector(a[2],1).."|"..vector(b[1],1).."|"..vector(b[2],1)
 end
 local function reverseKey(a,b)
  return vector(b[1],1).."|"..vector(b[2],-1).."|"..vector(a[1],1).."|"..vector(a[2],-1)
 end
 local function validate(result)
  for _,sub in ipairs(result.subconstructions) do
   local seen={}
   for _,lane in ipairs(sub.laneLists or {}) do
    local vehicle=false
    for _,mode in ipairs(lane.transportModes) do
     if mode=="TRAM" or mode=="ELECTRIC_TRAM" then vehicle=true end
    end
    if vehicle then
     for i=1,#lane.nodes,2 do
      local a,b=lane.nodes[i],lane.nodes[i+1]
      assert(not seen[key(a,b)] and not seen[reverseKey(a,b)],"duplicate vehicle curve, including reverse orientation")
      seen[key(a,b)]=true
     end
    end
   end
  end
 end
 local script=loadScript(arg[1] or "content/crossover_stop.script.lua")
 for length=1,3 do validate(script.updateFn({}, {platformLength=length})) end
 -- A deliberately reversed copy must be rejected, matching the native crash.
 local sample=script.updateFn({}, {platformLength=2})
 local lane=sample.subconstructions[1].laneLists[1]
 local a,b=lane.nodes[1],lane.nodes[2]
 sample.subconstructions[1].laneLists[#sample.subconstructions[1].laneLists+1]={
  transportModes={"TRAM"},nodes={
   {b[1],{-b[2][1],-b[2][2],-b[2][3]},2},
   {a[1],{-a[2][1],-a[2][2],-a[2][3]},2}}}
 local ok,err=pcall(validate,sample)
 assert(not ok and tostring(err):find("duplicate vehicle curve",1,true),"reverse duplicate regression must fail")
 print("PASS: no duplicate tram curves at all lengths; reverse duplicate regression rejected")
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),"\n");os.exit(1) end
