-- Experimental surface terminus: one physical centreline and one terminal.
-- Geometry assertions cannot prove that the native tram router accepts reversal.
local function transform(x, y, z)
    return {1,0,0,0, 0,1,0,0, 0,0,1,0, x,y,z,1}
end
local function lane(points, modes, width, bidirectional, linkable)
    local nodes = {}
    for index = 1, #points - 1 do
        local first, last = points[index], points[index + 1]
        local tangent = {last[1]-first[1],last[2]-first[2],last[3]-first[3]}
        nodes[#nodes+1] = {first, tangent, width}
        nodes[#nodes+1] = {last, tangent, width}
    end
    return { nodes = nodes, transportModes = modes, speedLimit = 25,
        forwardOnly = not bidirectional, linkable = linkable,
        needsReservation = modes[1] == "TRAM" }
end
local function rectangle(x0, x1, y0, y1)
    return {{x0,y0,0},{x1,y0,0},{x1,y1,0},{x0,y1,0}}
end
function data()
    return {
        updateFn = function(_captureParams, params)
            params = params or {}
            local lengths = {60,80,120}
            local selected = math.floor(tonumber(params.platformLength) or 2)
            local half = (lengths[selected] or lengths[2]) / 2
            local tramModes = {"TRAM","ELECTRIC_TRAM"}
            local template = "mrnickert_ultimate_metro::/test_track.street_template"
            local platformFace = rectangle(-half, half, 2, 7)
            local trackFace = rectangle(-half, half, -1.7, 1.7)
            return {
                -- Stock-style external STREET stubs connect to the station lanes.
                edgeLists = {
                    {type="STREET", params={type=template,tramTrackType="ELECTRIC"},
                        edges={{{-half-10,0,0},{10,0,0}},{{-half,0,0},{10,0,0}}},
                        snapNodes={0},freeNodes={0}},
                    {type="STREET", params={type=template,tramTrackType="ELECTRIC"},
                        edges={{{half,0,0},{10,0,0}},{{half+10,0,0},{10,0,0}}},
                        snapNodes={1},freeNodes={1}},
                },
                subconstructions = {{
                    models = {{id="::/stations/street/small_stops/small_new.mdl",transf=transform(0,5.4,0)}},
                    laneLists = {
                        lane({{-half,0,0},{0,0,0},{half,0,0}},tramModes,3,true,false),
                        lane({{-half,3,0},{0,3,0},{half,3,0}},{"PERSON"},2,true,false),
                        lane({{0,3,0},{0,9,0}},{"PERSON"},2,true,true),
                    },
                    station = {
                        tag=1,pool={edges={},capacity=0},
                        terminals={{vehicleNode={0,1},vehicleEdges={{0,0},{0,1}},
                            personEdges={{1,0},{1,1}},personNodes={{1,0},{1,1},{1,2}},
                            transportModes=tramModes,passengers=true,cargo=false,capacity=100}},
                        catchmentAreas={{position={0,3,0},radius=160}},
                    },
                }},
                terrainAlignmentLists = {{type="EQUAL",faces={rectangle(-half-10,half+10,-3,9)},
                    slopeLow=0,slopeHigh=0}},
                groundFaces = {
                    {face=platformFace,modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}},
                    {face=trackFace,modes={{type="FILL",key="::/infrastructure/street/shared/street_fill.gtex"}}},
                },
                cost=30000,maintenanceCost=5000,
            }
        end,
    }
end
