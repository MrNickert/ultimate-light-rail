-- Native entrance/circulation shared by the configurable underground variants.
-- The legacy underground script is deliberately left intact for saved stations.
local terminus=require "mrnickert_ultimate_metro::/terminus_util.lua"
local through=require "mrnickert_ultimate_metro::/through_station_util.lua"
local concourse=require "mrnickert_ultimate_metro::/underground_concourse_util.lua"
local entrance=require "mrnickert_ultimate_metro::/underground_entrance_util.lua"
local geometry=require "mrnickert_ultimate_metro::/underground_geometry.lua"
local levels=require "mrnickert_ultimate_metro::/underground_levels.lua"

local function addDeepEntrance(result,params,length,level)
 local offset=levels.offset(level)
 local sub=result.subconstructions[1]
 local snap,catchment=result.snapPoint.transf,sub.station.catchmentAreas
 sub.station.catchmentAreas={}
 geometry.transformLevel(result,{1,0,0,0,0,1,0,0,0,0,1,0,0,0,offset,1})
 result.snapPoint.transf=snap
 sub.station.catchmentAreas=catchment
 local street=entrance(params,{length=length,entranceOnly=true})
 for _,field in ipairs({"models","colliders","laneLists"}) do
  for _,value in ipairs(street[field]) do sub[field][#sub[field]+1]=value end
 end
 sub.groundFaces=street.groundFaces
 sub.terrainAlignmentLists=street.terrainAlignmentLists
 -- The native street entrance ends at the first concourse height. Stack
 -- switchback flights outside the station shell down to the selected hall.
 local centre=length-20
 local points={{centre,8.5,-12},{centre,16,-12}}
 for layer=-1,level+1,-1 do
  local top=-12+levels.offset(layer)
  local bottom=-12+levels.offset(layer-1)
  local mid=(top+bottom)/2
  points[#points+1]={centre,34,mid}
  points[#points+1]={centre+3.5,34,mid}
  points[#points+1]={centre+3.5,16,bottom}
  points[#points+1]={centre,16,bottom}
 end
 points[#points+1]={centre,11.75,-12+offset}
 geometry.addStairs(sub,points)
end

return function(capture,params,isThrough,length,turnback,level)
 local L=length or 80
 local baseZ=levels.trackZ(-1)
 local deep=level~=nil and level~=-1
 local layout={length=L,turnback=turnback}
 local result=isThrough and through(capture,params,layout) or terminus(capture,params,layout)
 local source=result.subconstructions[1]
 local vehicles=turnback and 6 or (isThrough and 2 or 4)
 for i=1,vehicles do
  for _,node in ipairs(source.laneLists[i].nodes) do node[1][3]=baseZ end
 end
 local sub=concourse(source,params,isThrough,L,turnback,{internal=deep})
 for _,edge in ipairs(result.edgeLists) do
  -- No fences below ground; preserve native tram traffic for through stations.
  if isThrough then edge.params.type="::/infrastructure/street/tram/tram_new.street_template" end
  for _,node in ipairs(edge.edges) do node[1][3]=baseZ end
  edge.edgeType="TUNNEL"
  edge.edgeTypeName="::/infrastructure/tunnel/tunnel_b_car.tunnel"
  edge.params.edgeType=edge.edgeType
  edge.params.edgeTypeName=edge.edgeTypeName
 end
 result.snapPoint={transf={0,-1,0,0,1,0,0,0,0,0,1,0,L-12,0,0,1},
  snapToBaseEdgeTypes={"STREET"},allowSnapToBaseEdgeEnds=true}
 result.subconstructions={sub}
 result.cost=900000
 result.maintenanceCost=30000
 if deep then addDeepEntrance(result,params,L,level) end
 return result
end
