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
local function isPrototype(con)
    return con and (con.fileName:match("^mrnickert_ultimate_metro::/?surface_stop%.con")
        or con.fileName:match("^mrnickert_ultimate_metro::/?crossover_stop%.con")
        or con.fileName:match("^mrnickert_ultimate_metro::/?edge_stop%.con")
        or con.fileName:match("^mrnickert_ultimate_metro::/?bidirectional_stop%.con"))
end
local function report()
    local ct=api.type.ComponentType
    local modes=api.type["enum"].TransportMode
    local segments=api.engine.system.streetSystem.getNode2SegmentMap()
    local terminals={}
    local inspected={}
    local function probe(label,a,b)
        for _,name in ipairs({"TRAM","ELECTRIC_TRAM"}) do
            local ok,path=pcall(function()
                return api.engine.util.pathfinding.findPathNodeToNode({a},{b},{modes[name]})
            end)
            message("probe "..label.." nodes="..nodeLabel(a).."->"..nodeLabel(b)
                .." mode="..name.." edges="..(ok and tostring(path and #path or 0) or "query-failed"))
        end
    end
    local constructions=0
    for _,entity in ipairs(api.engine.getEntitiesWithComponent(ct.CONSTRUCTION)) do
        local con=api.engine.getComponent(entity,ct.CONSTRUCTION)
        if isPrototype(con) then
            constructions=constructions+1
            message("construction="..entity.." resource="..con.fileName.." stubs="..#con.frozenEdges.." stations="..#con.stations)
            for _,edgeEntity in ipairs(con.frozenEdges) do
                local base=api.engine.getComponent(edgeEntity,ct.BASE_EDGE)
                if base then
                    message("stub="..edgeEntity.." template="..base.roadTemplate
                        .." baseNodes="..base.node0..":"..base.node1
                        .." degrees="..#(segments[base.node0] or {})..":"..#(segments[base.node1] or {}))
                    -- Direct-bound stations own their vehicle edges on the base
                    -- segments; their terminal-node networks contain no edges.
                    local segmentNet=api.engine.getComponent(edgeEntity,ct.TRANSPORT_NETWORK)
                    if segmentNet then
                        for i,edge in ipairs(segmentNet.edges) do
                            if i<=4 and (edge.transportModes[modes.TRAM] or edge.transportModes[modes.ELECTRIC_TRAM]) then
                                message("segment-network="..edgeEntity.." edge="..(i-1)
                                    .." forwardOnly="..tostring(edge.forwardOnly)
                                    .." reservation="..tostring(edge.needsReservation))
                            end
                        end
                    end
                end
            end
            for _,stationEntity in ipairs(con.stations) do
                local station=api.engine.getComponent(stationEntity,ct.STATION)
                if station then
                    for index,terminal in ipairs(station.terminals) do
                        local node=terminal.vehicleNodeId
                        message("station="..stationEntity.." terminal="..(index-1).." vehicleNode="..nodeLabel(node))
                        terminals[#terminals+1]={station=stationEntity,node=node,
                            priority=con.fileName:find("bidirectional_stop",1,true) and -1
                                or (con.fileName:find("edge_stop",1,true) and 0
                                or (con.fileName:find("crossover_stop",1,true) and 1 or 2))}
                        local net=api.engine.getComponent(node.entity,ct.TRANSPORT_NETWORK)
                        if net then
                            message("network="..node.entity.." nodes="..#net.nodes.." edges="..#net.edges)
                            if not inspected[node.entity] then
                                inspected[node.entity]=true
                                local first,second=net.edges[1],net.edges[2]
                                if first then
                                    probe("single-edge",first.conns[1],first.conns[2])
                                    probe("single-edge-reverse",first.conns[2],first.conns[1])
                                end
                                if first and second then
                                    probe("two-edge-span",first.conns[1],second.conns[2])
                                    probe("two-edge-span-reverse",second.conns[2],first.conns[1])
                                end
                            end
                            for edgeIndex,edge in ipairs(net.edges) do
                                if edgeIndex<=24 and (edge.transportModes[modes.TRAM] or edge.transportModes[modes.ELECTRIC_TRAM]) then
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
    -- Prefer the new crossover pair when the old research stops remain in the save.
    table.sort(terminals,function(a,b)
        if a.priority~=b.priority then return a.priority<b.priority end
        if a.station~=b.station then return a.station<b.station end
        return a.node.index<b.node.index
    end)
    while #terminals>4 do table.remove(terminals) end
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
                            .." mode="..modeName.." edges="..(path and #path or 0)
                            .." nodes="..nodeLabel(terminals[from].node).."->"..nodeLabel(terminals[to].node))
                    else message("path query failed: "..tostring(path)) end
                end
            end
        end
    end
    message("report complete; path reachability alone does not prove a valid service or reversal")
end
local function scanSignature()
    local ct=api.type.ComponentType
    local segments=api.engine.system.streetSystem.getNode2SegmentMap()
    local signatures={}
    local hasEdgeStop=false
    for _,entity in ipairs(api.engine.getEntitiesWithComponent(ct.CONSTRUCTION)) do
        local con=api.engine.getComponent(entity,ct.CONSTRUCTION)
        if isPrototype(con) then
            hasEdgeStop=hasEdgeStop or con.fileName:find("edge_stop",1,true)~=nil
                or con.fileName:find("bidirectional_stop",1,true)~=nil
            local parts={tostring(entity)}
            if con.fileName:find("edge_stop",1,true) then parts[#parts+1]="direct-edge-binding" end
            for _,station in ipairs(con.stations) do parts[#parts+1]="station="..station end
            for _,edgeEntity in ipairs(con.frozenEdges) do
                local base=api.engine.getComponent(edgeEntity,ct.BASE_EDGE)
                parts[#parts+1]="stub="..edgeEntity
                if base then
                    parts[#parts+1]=base.roadTemplate
                    for _,node in ipairs({base.node0,base.node1}) do
                        local neighbors={}
                        for _,neighbor in ipairs(segments[node] or {}) do neighbors[#neighbors+1]=neighbor end
                        table.sort(neighbors)
                        parts[#parts+1]="node="..node..":"..table.concat(neighbors,",")
                    end
                end
            end
            signatures[#signatures+1]=table.concat(parts,"|")
        end
    end
    table.sort(signatures)
    return #signatures,table.concat(signatures,";"),hasEdgeStop
end
function data()
    return {update=function(_params,state,dt)
        if dt<=0 then return end
        local saved=state:get() or {}
        -- Discard revision 2's saved done=true status, including empty reports.
        if saved.version~=6 then saved={version=6,elapsed=0} end
        saved.elapsed=saved.elapsed+dt
        if saved.elapsed<5 then state:set(saved);return end
        saved.elapsed=0
        local ok,count,signature,hasEdgeStop=pcall(scanSignature)
        if not ok then
            if saved.error~=tostring(count) then log.warning("[UMNET] scan failed: "..tostring(count)) end
            saved.error=tostring(count)
            state:set(saved)
            return
        end
        if count<2 and not hasEdgeStop then
            if saved.waitingCount~=count then message("waiting for two prototype stops; currently "..count) end
            saved.waitingCount=count
            saved.signature=nil
            state:set(saved)
            return
        end
        saved.waitingCount=nil
        if saved.signature==signature then state:set(saved);return end
        local success,err=pcall(report)
        if success then
            saved.signature=signature
            saved.error=nil
        elseif saved.error~=tostring(err) then
            log.warning("[UMNET] diagnostic failed: "..tostring(err))
            saved.error=tostring(err)
        end
        state:set(saved)
    end}
end
