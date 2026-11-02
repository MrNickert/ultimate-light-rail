-- Read-only inspection of effective engine limits, separate from the main mod.
-- No api.cmd, world mutations, modifiers, resource patches or vehicle changes.
local elapsed=0
local completed=false
local function message(text)log.message("[UMSPEED] "..text)end
local function value(number)
 if type(number)~="number" then return "unavailable" end
 return string.format("%.5g",number)
end
local function speed(number)
 if type(number)~="number" then return "unavailable" end
 return value(number).." m/s ("..value(number*3.6).." km/h)"
end
local function isMetro(con)
 return con and con.fileName and con.fileName:match("^mrnickert_ultimate_metro::/")
  and (con.fileName:find("twin_terminus.con",1,true) or con.fileName:find("underground_terminus.con",1,true))
end
local function reportNetwork(entity,label,ct,modes,seen)
 if seen[entity] then return end
 seen[entity]=true
 local network=api.engine.getComponent(entity,ct.TRANSPORT_NETWORK)
 if not network then message(label.." network missing="..entity);return end
 local count=0
 for index,edge in ipairs(network.edges)do
  if edge.transportModes[modes.TRAM] or edge.transportModes[modes.ELECTRIC_TRAM] then
   count=count+1
   local location=""
   local ok,description=pcall(function()
    local a=api.engine.util.transport.calcPosition(edge.geometry,0)
    local b=api.engine.util.transport.calcPosition(edge.geometry,1)
    return string.format(" world=(%.2f,%.2f,%.2f)->(%.2f,%.2f,%.2f)",a.x,a.y,a.z,b.x,b.y,b.z)
   end)
   if ok then location=description end
   message(label.." network="..entity.." edge="..(index-1)
    .." limit="..speed(edge.speedLimit).." curve="..speed(edge.curveSpeedLimit)
    .." reservation="..tostring(edge.needsReservation)
    .." forwardOnly="..tostring(edge.forwardOnly)..location)
   if count>=32 then message(label.." remaining vehicle edges omitted");break end
  end
 end
end
local function inspect(entity,con,ct,modes,seen)
 message("construction="..entity.." resource="..con.fileName)
 for _,segment in ipairs(con.frozenEdges)do reportNetwork(segment,"approach",ct,modes,seen)end
 for _,stationEntity in ipairs(con.stations)do
  local station=api.engine.getComponent(stationEntity,ct.STATION)
  if station then
   for index,terminal in ipairs(station.terminals)do
    local node=terminal.vehicleNodeId
    message("station="..stationEntity.." terminal="..(index-1).." vehicleNode="..node.entity..":"..node.index)
    reportNetwork(node.entity,"station-lanes",ct,modes,seen)
   end
  end
 end
end
function data()
 return {update=function(_params,_state,dt)
  if completed or dt<=0 then return end
  elapsed=elapsed+dt
  if elapsed<5 then return end
  completed=true
  local ct=api.type.ComponentType
  local modes=api.type["enum"].TransportMode
  local seen,count={},0
  message("BEGIN read-only effective speed report; no speed or geometry changes")
  for _,entity in ipairs(api.engine.getEntitiesWithComponent(ct.CONSTRUCTION))do
   local con=api.engine.getComponent(entity,ct.CONSTRUCTION)
   if isMetro(con)then
    local ok,err=pcall(inspect,entity,con,ct,modes,seen)
    if not ok then message("inspection failed="..tostring(err))end
    count=count+1
    if count>=8 then break end
   end
  end
  message("END constructions="..count.."; compare limit vs curve; observed speed also depends on braking, acceleration and reservations")
 end}
end
