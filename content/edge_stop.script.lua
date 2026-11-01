-- Proof of concept: apply the rail station's direct edge-node terminal binding
-- to an ordinary STREET tram template. This combination is NOT engine-proven.
-- No internal vehicle lanes, reverse duplicates, railway templates or commands.
local function transform(x,y,z)
    return {1,0,0,0, 0,1,0,0, 0,0,1,0, x,y,z,1}
end
local function people(points,linkable)
    local nodes={}
    for i=1,#points-1 do
        local a,b=points[i],points[i+1]
        local tangent={b[1]-a[1],b[2]-a[2],b[3]-a[3]}
        nodes[#nodes+1]={a,tangent,2};nodes[#nodes+1]={b,tangent,2}
    end
    return {nodes=nodes,transportModes={"PERSON"},speedLimit=2,
        linkable=linkable,forwardOnly=false}
end
local function rectangle(x0,x1,y0,y1)
    return {{x0,y0,0},{x1,y0,0},{x1,y1,0},{x0,y1,0}}
end
function data()
    return {updateFn=function(_captureParams,params)
        local half=40
        local tangent={half,0,0}
        return {
            edgeLists={{type="STREET",
                params={type="::/infrastructure/street/tram/tram_new.street_template",tramTrackType="ELECTRIC"},
                edges={{{-half,0,0},tangent},{{0,0,0},tangent},
                       {{0,0,0},tangent},{{half,0,0},tangent}},
                snapNodes={0,3},freeNodes={0,3}}},
            snapPoint={transf={0,-1,0,0, 1,0,0,0, 0,0,1,0, -half,0,0,1},
                snapToBaseEdgeTypes={"STREET"},transportModes={"TRAM","ELECTRIC_TRAM"},
                allowSnapToBaseEdgeEnds=true},
            subconstructions={{
                models={{id="::/stations/street/small_stops/small_new.mdl",transf=transform(0,8,0)}},
                laneLists={
                    people({{-30,6,0},{0,6,0},{30,6,0}},false), -- 0: platform
                    people({{0,6,0},{0,12,0}},true), -- 1: public access
                },
                station={tag=1,pool={edges={},capacity=0},
                    terminals={{
                        -- Rail station convention: -1 selects the root edgeLists,
                        -- and 1 is the raw zero-based endpoint at x=0.
                        -- Does the converter support this for STREET as well as
                        -- TRACK, and which generated directional tram lane wins?
                        -- Both questions require the first placement diagnostic.
                        vehicleNode={-1,1},
                        transportModes={"TRAM","ELECTRIC_TRAM"},
                        personEdges={{0,0},{0,1}},personNodes={{0,0},{0,1},{0,3}},
                        passengers=true,cargo=false,capacity=100,
                    }},catchmentAreas={{position={0,8,0},radius=160}}},
                groundFaces={{face=rectangle(-30,30,5,10),
                    modes={{type="FILL",key="::/stations/shared/industry_floor_high_priority.gtex"}}}},
                terrainAlignmentLists={{type="EQUAL",faces={rectangle(-half,half,-6,13)},slopeLow=0,slopeHigh=0}},
            }},cost=30000,maintenanceCost=5000,
        }
    end}
end
