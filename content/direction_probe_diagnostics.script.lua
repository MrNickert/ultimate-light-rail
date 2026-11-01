-- Read-only probes of generated native segment networks. No commands.
local function message(s) log.message("[UMDIR] "..s) end
local modeNames={"TRAM","ELECTRIC_TRAM","TRAM_TRACK","ELECTRIC_TRAM_TRACK"}
local function label(template)
 if template:find("mode_probe.street_template",1,true) then return "B-mixed-STREET" end
 if template:find("edge_test.street_template",1,true) then return "A-tram-STREET" end
 if template:find("standard_catenary.street_template",1,true) then return "C-native-TRACK" end
 return "unknown"
end
local function inspect(con,entity)
 local ct=api.type.ComponentType
 local modes=api.type["enum"].TransportMode
 message("construction="..entity.." segments="..#con.frozenEdges)
 for _,segment in ipairs(con.frozenEdges) do
  local base=api.engine.getComponent(segment,ct.BASE_EDGE)
  local network=api.engine.getComponent(segment,ct.TRANSPORT_NETWORK)
  local row=base and label(base.roadTemplate) or "missing-base"
  message("row="..row.." segment="..segment.." networkEdges="..(network and #network.edges or -1))
  local vehicleEdge=nil
  if network then
   for _,edge in ipairs(network.edges) do
    local matching=false
    for _,name in ipairs(modeNames) do
     if modes[name]~=nil and edge.transportModes[modes[name]] then matching=true end
    end
    if matching then vehicleEdge=edge;break end
   end
  end
  if vehicleEdge then
   message("row="..row.." forwardOnly="..tostring(vehicleEdge.forwardOnly)
    .." reservation="..tostring(vehicleEdge.needsReservation))
   for _,name in ipairs(modeNames) do
    if modes[name]~=nil then
     for _,reverse in ipairs({false,true}) do
      local from=vehicleEdge.conns[reverse and 2 or 1]
      local to=vehicleEdge.conns[reverse and 1 or 2]
      local ok,path=pcall(function()
       return api.engine.util.pathfinding.findPathNodeToNode({from},{to},{modes[name]})
      end)
      message("row="..row.." mode="..name.." direction="..(reverse and "reverse" or "forward")
       .." enabled="..tostring(vehicleEdge.transportModes[modes[name]] or false)
       .." edges="..(ok and tostring(path and #path or 0) or "query-failed"))
     end
    end
   end
  else
   message("row="..row.." no vehicle edge available; no directional conclusion")
  end
 end
 message("complete: isolated path reachability does not prove station reversal, vehicle service or a tram/rail transition")
end
function data()
 return {update=function(_params,state,dt)
  if dt<=0 then return end
  local saved=state:get() or {elapsed=0,reports={}}
  saved.reports=saved.reports or {};saved.elapsed=(saved.elapsed or 0)+dt
  if saved.elapsed<5 then state:set(saved);return end
  saved.elapsed=0
  local ct=api.type.ComponentType
  for _,entity in ipairs(api.engine.getEntitiesWithComponent(ct.CONSTRUCTION)) do
   local con=api.engine.getComponent(entity,ct.CONSTRUCTION)
   if con and con.fileName:match("^mrnickert_ultimate_metro::/?direction_probe%.con") then
    local parts={}
    for _,edge in ipairs(con.frozenEdges) do parts[#parts+1]=tostring(edge) end
    local signature=table.concat(parts,",")
    if saved.reports[tostring(entity)]~=signature then
     local ok,err=pcall(inspect,con,entity)
     if ok then saved.reports[tostring(entity)]=signature
     else log.warning("[UMDIR] probe failed: "..tostring(err)) end
    end
   end
  end
  state:set(saved)
 end}
end
