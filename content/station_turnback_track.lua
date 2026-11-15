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

-- Overhead line, as on vanilla tram streets: ::/assets/streets/tram_pole_crossbar.mdl
-- (arm underside flat at z=5.17 from 2.03 m out to the tip at 3.13 m) with
-- ::/assets/streets/cable_isolator.mdl (0.35 m tall) hanging from the arm to the wire.
local ARM_Z,ARM_TIP,ISOLATOR=5.17,3.13368,0.35
track.WIRE_HEIGHT=ARM_Z-ISOLATOR
track.WIRE_MODEL="mrnickert_ultimate_metro::/tram_wire.mdl"
track.ISOLATOR_MODEL="::/assets/streets/cable_isolator.mdl"
-- Where the isolator hangs along the unscaled arm (2.03..3.13 m; near the tip = least stretch).
track.HANG_POINT=2.9
-- Surface masts: distance from the track centre (y=+/-2.5); 4.0 = mast at y=6.5.
track.MAST_DISTANCE=4.0
function track.poleScale(base)
 -- z scale so the arm meets the isolator from a mast standing at height `base`.
 return (track.WIRE_HEIGHT+ISOLATOR-base)/ARM_Z
end
function track.armScale(distance)
 -- y scale putting the hang point `distance` metres from the mast (over the track).
 return distance/track.HANG_POINT
end
function track.crossingArmScale(distance)
 -- y scale making the arm tip reach the centreline `distance` metres from the mast.
 return distance/ARM_TIP
end
local function key(x) return string.format("%.1f",x) end
function track.crossoverCentres(lanes)
 -- x of each crossover pair's centre, where the two crossover wires cross at y=0.
 -- Vehicle lanes come first; lanes 3+ are the crossovers (see addCrossover).
 local centres,vehicle={},0
 for _,lane in ipairs(lanes) do
  if lane.transportModes[1]~="PERSON" then
   vehicle=vehicle+1
   if vehicle>2 then
    local a,b=lane.nodes[1][1][1],lane.nodes[#lane.nodes][1][1]
    centres[key((a+b)/2)]=true
   end
  end
 end
 return centres
end
function track.isCrossover(centres,x) return centres[key(x)]==true end
function track.crossingPoles(models)
 -- Crossing masts are marked by the single isolator at y=0 on their x.
 local found={}
 for _,m in ipairs(models) do
  if m.id==track.ISOLATOR_MODEL and math.abs(m.transf[14])<0.1 then found[key(m.transf[13])]=true end
 end
 return found
end
function track.fitArm(m,mastY,crossings)
 -- Rescale a relocated mast's arm for a mast standing |mastY| from the centreline:
 -- crossover masts reach the centreline (both arms touch), others hang over their track.
 local d=math.abs(mastY)
 local s=crossings[key(m.transf[13])] and track.crossingArmScale(d) or track.armScale(d-2.5)
 s=s/math.sqrt(m.transf[5]^2+m.transf[6]^2)
 m.transf[5]=m.transf[5]*s;m.transf[6]=m.transf[6]*s
end
return track
