local track=require "mrnickert_ultimate_metro::/station_turnback_track.lua"
local entrance=require "mrnickert_ultimate_metro::/underground_entrance_util.lua"

return function(source,params,isThrough,L,turnback,options)
 options=options or {}
 local vehicles=turnback and 6 or (isThrough and 2 or 4)
 local sub=entrance(params,{through=isThrough,length=L,turnback=turnback,
  centred=options.centred,internal=options.internal})
 local pedestrians=sub.laneLists
 sub.laneLists={}
 for i=1,vehicles do
  local lane=source.laneLists[i]
  sub.laneLists[#sub.laneLists+1]=lane
 end
 for _,lane in ipairs(pedestrians) do sub.laneLists[#sub.laneLists+1]=lane end
 if turnback then
  local first=#sub.models+1
  for i=3,vehicles do track.addRailVisuals(sub.models,sub.laneLists[i]) end
  for i=first,#sub.models do sub.models[i].transf[15]=sub.models[i].transf[15]-18 end
 elseif not isThrough then
  for _,model in ipairs(source.models) do
   if model.id:find("single_rail.mdl",1,true) and model.transf[13]<0 then
    local transf={table.unpack(model.transf)}
    transf[15]=transf[15]-18
    sub.models[#sub.models+1]={id=model.id,transf=transf}
   end
  end
 end
 sub.station=source.station
 sub.station.catchmentAreas={{position={(options.centred and L/2 or L-20)+9,0,0},radius=200}}
 for i,terminal in ipairs(sub.station.terminals) do
  local pedestrianIndex=vehicles+(options.internal and 1 or 3)+i
  terminal.personEdges={{pedestrianIndex,0},{pedestrianIndex,1},{pedestrianIndex,2}}
  terminal.personNodes={{pedestrianIndex,0},{pedestrianIndex,1},{pedestrianIndex,2}}
 end
 return sub
end
