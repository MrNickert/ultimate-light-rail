-- Two-track surface terminus, with an explicit scissors crossover in the throat.
-- Based on the vanilla underground stop's tram lane spacing and STREET connection.
local function transform(x,y,z,reverse)
    local a=reverse and -1 or 1
    return {a,0,0,0, 0,a,0,0, 0,0,1,0, x,y,z,1}
end
local function rectangle(x0,x1,y0,y1)
    return {{x0,y0,0},{x1,y0,0},{x1,y1,0},{x0,y1,0}}
end
local function lane(points,modes,reservation)
    local nodes={}
    for i=1,#points-1 do
        local a,b=points[i],points[i+1]
        local t={b[1]-a[1],b[2]-a[2],b[3]-a[3]}
        nodes[#nodes+1]={a,t,2};nodes[#nodes+1]={b,t,2}
    end
    return {nodes=nodes,transportModes=modes,speedLimit=15,
        forwardOnly=false,linkable=false,needsReservation=reservation}
end
local function crossover(x0,x1,y0,y1,modes)
    -- Horizontal end tangents meet the straight tracks without a kink.
    local t={x1-x0,0,0}
    return {nodes={{{x0,y0,0},t,2},{{x1,y1,0},t,2}},
        transportModes=modes,speedLimit=10,forwardOnly=false,
        linkable=false,needsReservation=true}
end
function data()
    return {updateFn=function(_captureParams,params)
        params=params or {}
        local lengths={60,80,120}
        local selected=math.floor(tonumber(params.platformLength) or 2)
        local half=(lengths[selected] or lengths[2])/2
        local throat=-half-30
        local entrance=throat-20
        local modes={"TRAM","ELECTRIC_TRAM"}
        local people={"PERSON"}
        local result={
            edgeLists={{type="STREET",
                params={type="::/infrastructure/street/tram/tram_new.street_template",tramTrackType="ELECTRIC"},
                edges={{{entrance,0,0},{20,0,0}},{{throat,0,0},{20,0,0}}},
                snapNodes={0},freeNodes={0}}},
            snapPoint={transf=transform(entrance,0,0),snapToBaseEdgeTypes={"STREET"},
                transportModes=modes,allowSnapToBaseEdgeEnds=true},
            subconstructions={{
                models={
                    {id="::/stations/street/small_stops/small_new.mdl",transf=transform(0,8,0)},
                    {id="::/stations/street/small_stops/small_new.mdl",transf=transform(0,-8,0,true)},
                },
                laneLists={
                    lane({{throat,-2.5,0},{-half,-2.5,0},{0,-2.5,0},{half,-2.5,0}},modes,true), -- 0
                    lane({{throat,2.5,0},{-half,2.5,0},{0,2.5,0},{half,2.5,0}},modes,true), -- 1
                    crossover(throat,-half,-2.5,2.5,modes), -- 2
                    crossover(throat,-half,2.5,-2.5,modes), -- 3
                    lane({{-half,-6,0},{0,-6,0},{half,-6,0}},people,false), -- 4
                    lane({{-half,6,0},{0,6,0},{half,6,0}},people,false), -- 5
                    lane({{half,-6,0},{half+5,-6,0},{half+5,6,0},{half,6,0}},people,false), -- 6
                    lane({{0,6,0},{0,12,0}},people,false), -- 7
                },
                station={tag=1,pool={edges={},capacity=0},terminals={
                    {vehicleNode={0,2},transportModes=modes,personEdges={{4,0},{4,1}},
                        personNodes={{4,0},{4,1},{4,2}},passengers=true,cargo=false,capacity=100},
                    {vehicleNode={1,2},transportModes=modes,personEdges={{5,0},{5,1}},
                        personNodes={{5,0},{5,1},{5,2}},passengers=true,cargo=false,capacity=100},
                },catchmentAreas={{position={0,8,0},radius=160}}},
            }},
            terrainAlignmentLists={{type="EQUAL",faces={rectangle(entrance,half+8,-11,13)},slopeLow=0,slopeHigh=0}},
            groundFaces={
                {face=rectangle(-half,half,-10,-5),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
                {face=rectangle(-half,half,5,10),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
                {face=rectangle(throat,half,-4.5,4.5),modes={{type="FILL",key="::/infrastructure/street/shared/street_fill.gtex"}}},
                {face=rectangle(half,half+8,-10,10),modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
            },
            cost=60000,maintenanceCost=10000,
        }
        result.subconstructions[1].laneLists[8].linkable=true
        return result
    end}
end
