-- Shared station composition and underground access.
local entrance=require "mrnickert_ultimate_metro::/underground_entrance_util.lua"
local geometry=require "mrnickert_ultimate_metro::/underground_geometry.lua"
local interchange={}

local function append(target,source)
 for _,value in ipairs(source) do target[#target+1]=value end
end

interchange.append=append

function interchange.appendLevel(result,level)
 local combined,additional=result.subconstructions[1],level.subconstructions[1]
 local offset=#combined.laneLists
 -- All terminals share one station, with zero-based references into its lanes.
 for _,terminal in ipairs(additional.station.terminals) do
  terminal.vehicleNode[1]=terminal.vehicleNode[1]+offset
  for _,ref in ipairs(terminal.personEdges) do ref[1]=ref[1]+offset end
  for _,ref in ipairs(terminal.personNodes) do ref[1]=ref[1]+offset end
 end
 append(combined.station.terminals,additional.station.terminals)
 append(combined.laneLists,additional.laneLists)
 append(combined.models,additional.models)
 if additional.colliders then
  combined.colliders=combined.colliders or {}
  append(combined.colliders,additional.colliders)
 end
 append(result.edgeLists,level.edgeLists)
 result.cost=result.cost+level.cost
 result.maintenanceCost=result.maintenanceCost+level.maintenanceCost
end

function interchange.addStreetEntrance(result,params)
 local sub=result.subconstructions[1]
 -- The street entrance uses the native frontage frame. Its lower landings
 -- at (+/-8.5,0,-12) meet the 45-degree joints of the first concourse ring.
 local street=entrance(params,{entranceOnly=true,streetAligned=true})
 for _,field in ipairs({"models","colliders","laneLists"}) do
  append(sub[field],street[field])
 end
 sub.groundFaces=street.groundFaces
 sub.terrainAlignmentLists=street.terrainAlignmentLists
 sub.station.catchmentAreas={{position={0,9,0},radius=200}}
 result.snapPoint.transf={1,0,0,0,0,1,0,0,0,0,1,0,0,8,0,1}
end

function interchange.connectUnderground(sub,upper,lower,upperZ,lowerZ,side)
 local ux,uy=-side*upper[2],side*upper[1]
 local lx,ly=-lower[2],lower[1]
 -- Use the same exterior quadrant when possible. Return the lower landing side
 -- so the next flight can depart from the opposite side of that concourse.
 local lowerSide=ux*lx+uy*ly<0 and -1 or 1
 lx,ly=lx*lowerSide,ly*lowerSide
 local scale=36/(1+ux*lx+uy*ly)
 local ax,ay=upper.x or 0,upper.y or 0
 local bx,by=lower.x or 0,lower.y or 0
 local x,y=(ux+lx)*scale+(ax+bx)/2,(uy+ly)*scale+(ay+by)/2
 local dx,dy=(uy+ly)*2,-(ux+lx)*2
 local middleZ=(upperZ+lowerZ)/2
 geometry.addStairs(sub,{
  {ax+ux*11.75,ay+uy*11.75,upperZ},{ax+ux*16,ay+uy*16,upperZ},
  {x+dx,y+dy,middleZ},{x-dx,y-dy,middleZ},
  {bx+lx*16,by+ly*16,lowerZ},{bx+lx*11.75,by+ly*11.75,lowerZ},
 })
 return lowerSide
end

function interchange.placeLevel(result,length,frame)
 local c,s=frame[1],frame[2]
 local centre=length/2
 geometry.transformLevel(result,{c,s,0,0,-s,c,0,0,0,0,1,0,frame.x-centre*c,frame.y-centre*s,0,1})
end

return interchange
