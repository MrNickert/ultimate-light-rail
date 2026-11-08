local api=require "mrnickert_ultimate_metro::/station_api_v1.lua"
local geometry=require "mrnickert_ultimate_metro::/underground_geometry.lua"
local interchange=require "mrnickert_ultimate_metro::/interchange_util.lua"
local track=require "mrnickert_ultimate_metro::/station_turnback_track.lua"
local LENGTH=80
local CENTRE=LENGTH/2
-- Shift the viaduct along its own axis so the stock stairs and forecourt
-- clear the ground-level tram corridor and the two nearest pier rows straddle it.
local ELEVATED_OFFSET=20.5
local STREET_Y=-20

local function build(placement,capture,params)
 return api.buildStation({apiVersion=1,placement=placement,stationType="through",
  platformLength=LENGTH,turnback=true,design=api.getDefaultKit(placement)},capture,params)
end

function data()
 return {updateFn=function(capture,params)
  local surfaceParams={ulrPlatformAccess=2}
  local elevatedParams={}
  for key,value in pairs(params or {}) do
   if key~="ulrPlatformAccess" then surfaceParams[key]=value end
   if key~="ulrStreetAlignment" then elevatedParams[key]=value end
  end
  local result=build("surface",capture,surfaceParams)
  local elevated=build("elevated",capture,elevatedParams)
  geometry.transformLevel(elevated,{0,1,0,0,-1,0,0,0,0,0,1,0,CENTRE,ELEVATED_OFFSET-CENTRE,0,1})
  local ground,upper=result.subconstructions[1],elevated.subconstructions[1]
  interchange.appendLevel(result,elevated)
  interchange.append(ground.groundFaces,upper.groundFaces)
  interchange.append(ground.terrainAlignmentLists,upper.terrainAlignmentLists)

  -- Join the surface midpoint exit to a native ground landing under the viaduct.
  local landingY=ELEVATED_OFFSET-8
  ground.laneLists[#ground.laneLists+1]=track.lane({{CENTRE,11,0.25},
   {CENTRE,landingY,0.15},{CENTRE+6.5,landingY,0.15}},{"PERSON"},false,false)
  ground.models[#ground.models+1]={id="mrnickert_ultimate_metro::/elevated_paving.mdl",
   transf={1,0,0,0,0,(landingY-9)/3,-0.1/3,0,0,0,1,0,CENTRE-1.5,9,0.25,1}}

  -- The street runs across the viaduct between consecutive pier rows.
  ground.laneLists[#ground.laneLists+1]=track.lane({{CENTRE,STREET_Y+1,0.15},
   {CENTRE,-11,0.25}},{"PERSON"},false,true)
  result.snapPoint={transf={1,0,0,0,0,1,0,0,0,0,1,0,CENTRE,STREET_Y,0,1},
   snapToBaseEdgeTypes={"STREET"},allowSnapToBaseEdgeEnds=true}
  for _,edge in ipairs(result.edgeLists) do edge.maxNodeSnapAngle=0 end
  return result
 end}
end
