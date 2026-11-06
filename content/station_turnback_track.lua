-- Shared tram reservation and crossover geometry for reversing stations.
local track={}
track.modes={"TRAM","ELECTRIC_TRAM","TRAM_TRACK","ELECTRIC_TRAM_TRACK"}
local STATION_SPEED=80
local CROSSOVER_SPEED=40
function track.lane(points,modes,vehicle,linkable,overrides)
 local nodes={}
 for i=1,#points-1 do
  local a,b=points[i],points[i+1]
  local t={b[1]-a[1],b[2]-a[2],b[3]-a[3]}
  local custom=overrides and overrides[i]
  nodes[#nodes+1]={a,custom and custom[1] or t,2}
  nodes[#nodes+1]={b,custom and custom[2] or t,2}
 end
 return {nodes=nodes,transportModes=modes,speedLimit=vehicle and STATION_SPEED or 2,
  forwardOnly=false,needsReservation=vehicle,linkable=linkable}
end
local function position(a,b,t)
 local t2,t3=t*t,t*t*t
 local p={}
 for k=1,3 do
  p[k]=(2*t3-3*t2+1)*a[1][k]+(t3-2*t2+t)*a[2][k]
       +(-2*t3+3*t2)*b[1][k]+(t3-t2)*b[2][k]
 end
 return p
end
function track.addRailVisuals(models,vehicleLane)
 -- Bare shared rail mesh (4m long), embedded almost flush in the paved surface.
 -- Two rails per path, no sleepers, ballast segments or railway buffer blocks.
 local halfGauge=1.435/2
 for i=1,#vehicleLane.nodes,2 do
  local a,b=vehicleLane.nodes[i],vehicleLane.nodes[i+1]
  local dx,dy=b[1][1]-a[1][1],b[1][2]-a[1][2]
  local count=math.max(1,math.ceil(math.sqrt(dx*dx+dy*dy)))
  local first=position(a,b,0)
  for step=1,count do
   local last=position(a,b,step/count)
   local x,y=last[1]-first[1],last[2]-first[2]
   local length=math.sqrt(x*x+y*y)
   local nx,ny=-y/length,x/length
   for _,side in ipairs({-1,1}) do
    models[#models+1]={id="::/infrastructure/track/shared/single_rail.mdl",
     transf={x/4,y/4,0,0, nx,ny,0,0, 0,0,1,0,
       (first[1]+last[1])/2+side*halfGauge*nx,
       (first[2]+last[2])/2+side*halfGauge*ny,-0.52,1}}
   end
   first=last
  end
 end
end
function track.addCrossover(lanes,x,modes)
 for _,side in ipairs({-1,1}) do
  -- Horizontal tangents at the switches and exact halves of a 30m S-curve.
  local y=side*2.5
  local slope=-side*3.75
  local crossover=track.lane({{x,y,0},{x+15,0,0},{x+30,-y,0}},modes,true,false,
   {{{15,0,0},{15,slope,0}},{{15,slope,0},{15,0,0}}})
  crossover.speedLimit=CROSSOVER_SPEED
  lanes[#lanes+1]=crossover
 end
end
return track
