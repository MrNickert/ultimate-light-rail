-- Core-owned circulation for a surface/elevated interchange and its shared shaft.
local interchange=require "mrnickert_ultimate_metro::/interchange_util.lua"
local geometry=require "mrnickert_ultimate_metro::/underground_geometry.lua"
local track=require "mrnickert_ultimate_metro::/station_turnback_track.lua"
local levels=require "mrnickert_ultimate_metro::/station_levels.lua"
local PLAZA_HEIGHT=0.15
local CONCOURSE_HEIGHT=levels.trackZ(-1)+6

local function addWall(sub,x0,x1,y0,y1)
 sub.models[#sub.models+1]={id="mrnickert_ultimate_metro::/elevated_concrete_visual.mdl",
  transf={(x1-x0)/6,0,0,0,0,(y1-y0)/4,0,0,0,0,(PLAZA_HEIGHT-CONCOURSE_HEIGHT)/2.4,0,
   x0,y0,PLAZA_HEIGHT,1}}
end

local function addRail(sub,x0,y0,x1,y1)
 local dx,dy=x1-x0,y1-y0
 local length=math.sqrt(dx*dx+dy*dy)
 local count=math.ceil(length/1.6)
 for i=1,count do
  local t=(i-0.5)/count
  sub.models[#sub.models+1]={id="mrnickert_ultimate_metro::/lightrail_fence.mdl",
   transf={dx/(1.6*count),dy/(1.6*count),0,0,-dy/length,dx/length,0,0,0,0,1,0,
    x0+t*dx,y0+t*dy,PLAZA_HEIGHT,1}}
 end
end

local function connectPlaza(sub,opening,upper,landingY)
 local a,b=opening.x0,opening.x1
 local near,far=opening.y0,opening.y1
 local left,right=a+1.5,b-1.5
 local turn=far-1.5
 local halfway=(PLAZA_HEIGHT+CONCOURSE_HEIGHT)/2
 geometry.addStairs(sub,{
  {0,landingY,PLAZA_HEIGHT},{left,near,PLAZA_HEIGHT},
  {left,turn,halfway},{right,turn,halfway},
  {right,near,CONCOURSE_HEIGHT},{upper.x,near,CONCOURSE_HEIGHT},
 })
 addWall(sub,a,a+0.2,near,far)
 addWall(sub,b-0.2,b,near,far)
 addWall(sub,a+0.2,b-0.2,far-0.2,far)
 addRail(sub,a,near,a,far)
 addRail(sub,b,near,b,far)
 addRail(sub,a,far,b,far)
 addRail(sub,(a+b)/2,near,b,near)
end

return function(surface,upper,underground,build)
 local result=build(surface,{ulrPlatformAccess=2})
 local elevatedOptions={ulrStreetAlignment=1,ulrInterchangePlazaJoin=upper.x}
 local opening
 if underground then
  opening={x0=upper.x-4,x1=upper.x+2,y0=upper.y-4.5,y1=upper.y+7.5}
  local middle=upper.length/2
  elevatedOptions.ulrInterchangePlazaOpening={x0=middle-4.5,x1=middle+7.5,y0=-2,y1=4}
 end
 local viaduct=build(upper,elevatedOptions)
 local ground,deck=result.subconstructions[1],viaduct.subconstructions[1]
 interchange.appendLevel(result,viaduct)
 interchange.append(ground.groundFaces,deck.groundFaces)
 interchange.append(ground.terrainAlignmentLists,deck.terrainAlignmentLists)

 -- Join the surface midpoint exit to the common landing under the viaduct.
 local landingY=upper.y-8
 ground.laneLists[#ground.laneLists+1]=track.lane({{0,11,0.25},
  {0,landingY,PLAZA_HEIGHT}},{"PERSON"},false,false)
 ground.models[#ground.models+1]={id="mrnickert_ultimate_metro::/elevated_paving.mdl",
  transf={1,0,0,0,0,(landingY-9)/3,-0.1/3,0,0,0,1,0,-1.5,9,0.25,1}}
 local streetY=upper.y-40.5
 ground.laneLists[#ground.laneLists+1]=track.lane({{0,streetY+1,PLAZA_HEIGHT},
  {0,-11,0.25}},{"PERSON"},false,true)
 result.snapPoint={transf={1,0,0,0,0,1,0,0,0,0,1,0,0,streetY,0,1},
  snapToBaseEdgeTypes={"STREET"},allowSnapToBaseEdgeEnds=true}
 if opening then connectPlaza(ground,opening,upper,landingY) end
 return result
end
