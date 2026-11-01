local function main()
 local function resource(path)
  local env=setmetatable({_ = function(k)return k end},{__index=_G})
  assert(loadfile(path,"t",env))();return env.data()
 end
 local def=resource("content/bidirectional_stop.con.lua")
 assert(def.updateScript.fileName=="mrnickert_ultimate_metro::/bidirectional_stop.script@updateFn")
 local baseline=resource("content/edge_stop.script.lua").updateFn({}, {})
 local trial=resource("content/bidirectional_stop.script.lua").updateFn({}, {})
 assert(trial.edgeLists[1].params.type=="mrnickert_ultimate_metro::/mode_probe.street_template","uses exact measured row-B resource")
 trial.edgeLists[1].params.type=baseline.edgeLists[1].params.type
 local function equal(a,b)
  if type(a)~=type(b) then return false end
  if type(a)~="table" then return a==b end
  for k,v in pairs(a) do if not equal(v,b[k]) then return false end end
  for k in pairs(b) do if a[k]==nil then return false end end
  return true
 end
 assert(equal(baseline,trial),"only the referenced profile changes from accepted station geometry")
 local profile=resource("content/mode_probe.street_template.lua")
 assert(profile.roadType=="STREET" and #profile.laneConfigs==1,"one actual tram street lane")
 local terminal=trial.subconstructions[1].station.terminals[1]
 local allowed={};for _,m in ipairs(terminal.transportModes) do allowed[m]=true end
 local matching=0
 for _,lane in ipairs(profile.laneConfigs) do
  local accepts=false
  for _,mode in ipairs(lane.transportModes) do if allowed[mode] then accepts=true end end
  if accepts then matching=matching+1 end
 end
 assert(matching==1,"direct binding remains unambiguous")
 local node=trial.edgeLists[1].edges[terminal.vehicleNode[2]+1]
 assert(terminal.vehicleNode[1]==-1 and node[1][1]==0,"terminal remains on root midpoint")
 for _,lane in ipairs(trial.subconstructions[1].laneLists) do
  for _,mode in ipairs(lane.transportModes) do assert(mode=="PERSON","no internal vehicle duplication") end
 end
 print("PASS: measured mixed profile is the only geometry delta, direct terminal remains unambiguous. New station and vehicle reversal need native testing.")
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),"\n");os.exit(1) end
