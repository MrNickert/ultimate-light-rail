-- Two paved crossings inside the straight platform tracks, clear of Turnback switches.
local track=require "mrnickert_ultimate_metro::/station_turnback_track.lua"
local FLOOR=0.25
local PAVING_Z=0.012 -- Above the tram paving and below the straight rail texture.
local PLATFORM_EDGE=4
local RAMP_FOOT=3.45
local WALKWAY=5.5
local HALF_WIDTH=1.25
local INSET=1.5
local function walk(points,linkable)
 return track.lane(points,{"PERSON"},false,linkable)
end
local function paving(x,y0,y1,z0,z1)
 -- Reuse the visual-only 3m square, with a shallow wedge at each platform edge.
 return {id="mrnickert_ultimate_metro::/elevated_paving.mdl",
  transf={2*HALF_WIDTH/3,0,0,0,0,(y1-y0)/3,(z1-z0)/3,0,0,0,1,0,x-HALF_WIDTH,y0,z0,1}}
end
return function(length)
 local front,centre,back=INSET,length/2,length-INSET
 local lanes,waiting,models={},{},{}
 for _,side in ipairs({-1,1}) do
  local y=side*WALKWAY
  lanes[#lanes+1]=walk({{0,y,FLOOR},{front,y,FLOOR},{centre,y,FLOOR},{back,y,FLOOR},{length,y,FLOOR}},false)
  waiting[#waiting+1]={edges={0,1,2,3},nodes={0,1,2,3,4,5,6,7}}
 end
 for _,x in ipairs({front,back}) do
  lanes[#lanes+1]=walk({
   {x,-WALKWAY,FLOOR},{x,-PLATFORM_EDGE,FLOOR},{x,-RAMP_FOOT,PAVING_Z},
   {x,RAMP_FOOT,PAVING_Z},{x,PLATFORM_EDGE,FLOOR},{x,WALKWAY,FLOOR},
  },false)
  models[#models+1]=paving(x,-PLATFORM_EDGE,-RAMP_FOOT,FLOOR,PAVING_Z)
  models[#models+1]=paving(x,-RAMP_FOOT,RAMP_FOOT,PAVING_Z,PAVING_Z)
  models[#models+1]=paving(x,RAMP_FOOT,PLATFORM_EDGE,PAVING_Z,FLOOR)
 end
 for _,side in ipairs({-1,1}) do
  for _,x in ipairs({front,centre,back}) do
   lanes[#lanes+1]=walk({{x,side*11,FLOOR},{x,side*9,FLOOR},{x,side*WALKWAY,FLOOR}},true)
  end
 end
 return {lanes=lanes,waiting=waiting,models=models,holes={},floor=FLOOR}
end
