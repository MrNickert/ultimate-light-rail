-- Internal assembly behind station_api_v1.buildInterchange().
local levels=require "mrnickert_ultimate_metro::/station_levels.lua"
local kit=require "mrnickert_ultimate_metro::/station_standard_kit.lua"
local geometry=require "mrnickert_ultimate_metro::/underground_geometry.lua"
local interchange=require "mrnickert_ultimate_metro::/interchange_util.lua"
local plaza=require "mrnickert_ultimate_metro::/interchange_plaza.lua"
local DIAGONAL=math.sqrt(0.5)
local rotations={[0]={1,0},[45]={DIAGONAL,DIAGONAL},[90]={0,1},[135]={-DIAGONAL,DIAGONAL}}
local fields={apiVersion=true,layers=true}
local layerFields={level=true,platformLength=true,rotation=true,offset=true,design=true,fence=true}
local offsetFields={x=true,y=true}

local function coordinates(offset,x,y,check,onlyFields)
 if offset==nil then return x,y end
 check(type(offset)=="table","offset must be a table with numeric x and y")
 onlyFields(offset,offsetFields,"offset")
 check(type(offset.x)=="number" and math.abs(offset.x)<math.huge
  and type(offset.y)=="number" and math.abs(offset.y)<math.huge,"offset must have finite numeric x and y")
 return offset.x,offset.y
end

local function normalize(spec,check,onlyFields)
 check(type(spec)=="table","interchange specification must be a table")
 onlyFields(spec,fields,"interchange")
 check(spec.apiVersion==1,"apiVersion must be 1")
 check(type(spec.layers)=="table","layers must be an array")
 local count,byLevel=0,{}
 for key,layer in pairs(spec.layers) do
  check(type(key)=="number" and key%1==0 and key>=1 and key<=#spec.layers,"layers must be an array")
  check(type(layer)=="table","each layer must be a table")
  onlyFields(layer,layerFields,"layer")
  check(levels.placement(layer.level),"each layer needs a level from -4 to +1")
  check(not byLevel[layer.level],"duplicate interchange level "..layer.level)
  check(layer.rotation==nil or rotations[layer.rotation],"rotation must be 0, 45, 90 or 135 degrees")
  local length=layer.platformLength
  check(length==nil or (type(length)=="number" and length>=40 and length<=120 and length%20==0),
   "platformLength must be 40, 60, 80, 100 or 120 metres")
  byLevel[layer.level]=layer
  count=count+1
 end
 check(count==#spec.layers and count>=2,"an interchange requires at least two layers")
 local surface,elevated=byLevel[0],byLevel[1]
 check((surface~=nil)==(elevated~=nil),"a surface interchange requires both levels 0 and +1")
 local groundAngle=surface and surface.rotation or 0
 local upperAngle=(groundAngle+90)%180
 local frames={}
 local function place(level,angle,x,y)
  local spec=byLevel[level]
  angle=spec.rotation or angle
  x,y=coordinates(spec.offset,x,y,check,onlyFields)
  local r=rotations[(angle-groundAngle)%180]
  local frame={r[1],r[2],level=level,x=x,y=y,angle=angle,length=spec.platformLength or 80,
   design=spec.design,fence=spec.fence}
  frames[level]=frame
  return frame
 end
 local upper
 if surface then
  local ground=place(0,groundAngle,0,0)
  upper=place(1,upperAngle,0,20.5)
  check(ground.x==0 and ground.y==0,"level 0 is the offset origin")
  check(upper.angle==upperAngle,"level +1 must be perpendicular to level 0")
  check(math.abs(upper.x)<=3 and upper.y>=20.25 and upper.y<=20.75,
   "level +1 offset requires x from -3 to 3 and y from 20.25 to 20.75 for the shared plaza")
 end
 local top,previous
 for level=-1,-4,-1 do
  if byLevel[level] then
   check(level==-1 or previous,"underground levels must start at -1 and be consecutive")
   local layer
   if level==-1 then
    local x,y=0,0
    if upper then x,y=upper.x,upper.y+4 end
    layer=place(level,upper and upperAngle or 0,x,y)
    check(layer.x==x and layer.y==y,"level -1 must stay at the shared entrance anchor")
    check(not upper or layer.angle==upperAngle,"level -1 must be parallel to level +1 at the plaza")
    top=layer
   else
    layer=place(level,(previous.angle+90)%180,top.x,top.y)
    check(math.abs(layer.x-top.x)<=4 and math.abs(layer.y-top.y)<=4,
     "deeper levels must stay within 4 m of level -1 on each axis")
   end
   previous=layer
  else
   previous=nil
  end
 end
 return frames,groundAngle
end

return function(spec,capture,params,buildStation,check,onlyFields)
 local frames,angle=normalize(spec,check,onlyFields)
 local function build(frame,options)
  local config={}
  for key,value in pairs(params) do config[key]=value end
  config.ulrInterchangePlazaOpening=nil
  config.ulrInterchangePlazaJoin=nil
  config.ulrInterchangeInternalConcourse=frame.level<0
  for key,value in pairs(options or {}) do config[key]=value end
  local result=buildStation({apiVersion=1,level=frame.level,stationType="through",platformLength=frame.length,
   turnback=true,fence=frame.fence,design=frame.design==nil and kit(levels.placement(frame.level)) or frame.design},capture,config)
  interchange.placeLevel(result,frame.length,frame)
  return result
 end
 local result
 if frames[0] then result=plaza(frames[0],frames[1],frames[-1],build) end
 local side=1
 for level=-1,-4,-1 do
  local frame=frames[level]
  if frame then
   local current=build(frame)
   if result then interchange.appendLevel(result,current) else result=current end
   if level<-1 then
    side=-interchange.connectUnderground(result.subconstructions[1],frames[level+1],frame,
     levels.trackZ(level+1)+6,levels.trackZ(level)+6,side)
   end
  end
 end
 if not frames[0] then interchange.addStreetEntrance(result,params) end
 if angle~=0 then
  local c,s=table.unpack(rotations[angle])
  geometry.transformLevel(result,{c,s,0,0,-s,c,0,0,0,0,1,0,0,0,0,1})
 end
 for _,edge in ipairs(result.edgeLists) do edge.maxNodeSnapAngle=0 end
 return result
end
