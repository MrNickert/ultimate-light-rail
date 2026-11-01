-- Read-only inspection of prototype stops. No world mutation or command callbacks.
local function message(text) log.message("[UMNET] "..text) end
local function nodeLabel(node)
    return tostring(node.entity)..":"..tostring(node.index)
end
local function positions(edge)
    local ok, text = pcall(function()
        local a=api.engine.util.transport.calcPosition(edge.geometry,0)
        local b=api.engine.util.transport.calcPosition(edge.geometry,1)
        return string.format("(%.2f,%.2f,%.2f)->(%.2f,%.2f,%.2f)",a.x,a.y,a.z,b.x,b.y,b.z)
    end)
    return ok and text or "position-unavailable"
end
local function report()
    local ct=api.type.ComponentType
    local modes=api.type["enum"].TransportMode
    local segments=api.engine.system.streetSystem.getNode2SegmentMap()
    local terminals={}
    local constructions=0
    for _,entity in ipairs(api.engine.getEntitiesWithComponent(ct.CONSTRUCTION)) do
        local con=api.engine.getComponent(entity,ct.CONSTRUCTION)
        if con and con.fileName:match("^mrnickert_ultimate_metro::/?surface_stop%.con") then
            constructions=constructions+1
            message("construction="..entity.." resource="..con.fileName.." stubs="..#con.frozenEdges.." stations="..#con.stations)
            for _,edgeEntity in ipairs(con.frozenEdges) do
                local base=api.engine.getComponent(edgeEntity,ct.BASE_EDGE)
                if base then
                    message("stub="..edgeEntity.." template="..base.roadTemplate
                        .." baseNodes="..base.node0..":"..base.node1
                        .." degrees="..#(segments[base.node0] or {})..":"..#(segments[base.node1] or {}))
                end
            end
            for _,stationEntity in ipairs(con.stations) do
                local station=api.engine.getComponent(stationEntity,ct.STATION)
                if station then
                    for index,terminal in ipairs(station.terminals) do
                        local node=terminal.vehicleNodeId
                        message("station="..stationEntity.." terminal="..(index-1).." vehicleNode="..nodeLabel(node))
                        if #terminals<4 then terminals[#terminals+1]={station=stationEntity,node=node} end
                        local net=api.engine.getComponent(node.entity,ct.TRANSPORT_NETWORK)
                        if net then
                            message("network="..node.entity.." nodes="..#net.nodes.." edges="..#net.edges)
                            for edgeIndex,edge in ipairs(net.edges) do
                                if edgeIndex<=12 and (edge.transportModes[modes.TRAM] or edge.transportModes[modes.ELECTRIC_TRAM]) then
                                    message("edge="..(edgeIndex-1).." conns="..nodeLabel(edge.conns[1]).."->"..nodeLabel(edge.conns[2])
                                        .." forwardOnly="..tostring(edge.forwardOnly).." reservation="..tostring(edge.needsReservation)
                                        .." tram="..tostring(edge.transportModes[modes.TRAM]).." electric="..tostring(edge.transportModes[modes.ELECTRIC_TRAM])
                                        .." geometry="..positions(edge))
                                end
                            end
                        else message("terminal network missing") end
                    end
                end
            end
        end
    end
    message("total prototype constructions="..constructions.." sampled terminals="..#terminals)
    for from=1,#terminals do
        for to=1,#terminals do
            if from~=to then
                for _,modeName in ipairs({"TRAM","ELECTRIC_TRAM"}) do
                    local ok,path=pcall(function()
                        return api.engine.util.pathfinding.findPathNodeToNode(
                            {terminals[from].node},{terminals[to].node},{modes[modeName]})
                    end)
                    if ok then
                        message("path "..terminals[from].station.."->"..terminals[to].station
                            .." mode="..modeName.." edges="..(path and #path or 0))
                    else message("path query failed: "..tostring(path)) end
                end
            end
        end
    end
    message("report complete; path reachability alone does not prove a valid service or reversal")
end
function data()
    return {update=function(_params,state,dt)
        if dt<=0 then return end
        local saved=state:get() or {}
        if saved.version~=1 then saved={version=1,elapsed=0,done=false} end
        if saved.done then return end
        saved.elapsed=saved.elapsed+dt
        if saved.elapsed<3 then state:set(saved);return end
        saved.done=true
        state:set(saved)
        local ok,err=pcall(report)
        if not ok then log.warning("[UMNET] diagnostic failed: "..tostring(err)) end
    end}
end
