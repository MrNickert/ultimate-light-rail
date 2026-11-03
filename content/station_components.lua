-- Optional presentation only. Fixed routes, stairs, structure and safety stay core-owned.
local M={}
local standardKit=require "mrnickert_ultimate_metro::/station_standard_kit.lua"
local PREFIX="mrnickert_ultimate_metro::/"
local keys={platform=true,shelter=true,canopy=true,trees=true,planters=true,benches=true,bins=true,lights=true}
local ids={
 shelter={"::/stations/street/small_stops/small_new.mdl"},
 trees={"::/assets/vegetation/trees/apple_01/apple_01.mdl","::/assets/streets/tree_bed_new.mdl"},
 planters={"::/assets/buildings/res/flower_pots/raised_bed_c.mdl","::/assets/vegetation/trees/azalea_01/azalea_01.mdl"},
 benches={"::/assets/buildings/res/grd_frn/bench_c_metal.mdl",PREFIX.."elevated_entrance.mdl"},
 bins={"::/assets/buildings/com/misc/trashcan_c_01.mdl"},
 lights={"::/assets/buildings/res/garden_lamp/garden_lamp_c_stand.mdl"},
}
local function fail(ok,message) if not ok then error("Ultimate Light Rail API v1: "..message,3) end end
local function modelId(value)
 if type(value)~="string" or not value:match("^[a-z0-9_-]*::/[a-z0-9_./-]+%.mdl$") then return false end
 for part in value:gmatch("[^/]+") do if part==".." then return false end end
 return true
end
function M.validate(components,spec)
 fail(type(components)=="table","design components must be a table")
 for key,value in pairs(components) do
  fail(keys[key],"unknown component "..tostring(key))
  fail(value==false or value=="default" or type(value)=="table","component "..key.." must be default, false or a model table")
  fail(key~="platform" or value~=false,"the platform is required")
  fail(spec.placement~="underground" or value=="default","custom components are not supported in the fixed underground hall")
  if type(value)=="table" then
   for field in pairs(value) do fail(field=="model" or (key=="benches" and field=="entranceModel") or ((key=="platform" or key=="canopy") and field=="moduleLength"),"unknown field "..tostring(field).." in component "..key) end
   fail(modelId(value.model),"component "..key.." needs a qualified .mdl model")
   if value.entranceModel~=nil then fail(modelId(value.entranceModel),"entranceModel needs a qualified .mdl model") end
   if key=="platform" or key=="canopy" then fail(value.moduleLength==20,"component "..key.." must declare moduleLength=20") end
  end
 end
end
local function copy(t)local r={};for k,v in pairs(t) do r[k]=v end;return r end
local function transform(x,y,z,angle)
 local c,s=math.cos(angle or 0),math.sin(angle or 0)
 return {c,s,0,0,-s,c,0,0,0,0,1,0,x,y,z,1}
end
function M.apply(result,spec,components)
 if spec.placement=="underground" then return result end
 -- Resolve defaults to the same explicit kit used by our bundled stations.
 -- Preserve false: it means absent, not fallback.
 local defaults=standardKit(spec.placement).components
 local resolved={}
 for key in pairs(keys) do
  local value=components[key]
  if value==nil or value=="default" then value=defaults[key] end
  resolved[key]=value
 end
 components=resolved
 local elevated=spec.placement=="elevated"
 local L,centre=spec.platformLength,spec.platformLength/2
 local floor=elevated and 12.25 or 0.25
 local function add(models,id,x,y,z,angle)
  models[#models+1]={id=id,transf=transform(x,y,z,angle)}
 end
 for _,sub in ipairs(result.subconstructions) do
  local models={}
  for _,m in ipairs(sub.models or {}) do
   local keep=true;local replacement
   for key,list in pairs(ids) do
    for i,id in ipairs(list) do if m.id==id then
     if components[key]==false then keep=false
     elseif type(components[key])=="table" and (i==1 or key=="benches") then
      replacement=(key=="benches" and i==2 and components[key].entranceModel) or components[key].model
     end
    end end
   end
   if m.id==PREFIX.."elevated_platform_roof.mdl" or m.id=="::/assets/stations/rail/era_c_perron_pillar.mdl" or m.id=="::/assets/stations/rail/era_c_perron_holder.mdl" then
    if components.canopy==false then keep=false
    elseif type(components.canopy)=="table" and m.id==PREFIX.."elevated_platform_roof.mdl" then keep=false end
   end
   -- Replace only complete 20m units of plain, full-width platform. The fixed
   -- stair surrounds, narrow strips and short end infills remain core parts.
   local platform=components.platform
   if keep and type(platform)=="table" and m.id==PREFIX.."surface_head_tile.mdl" then
    local t=copy(m.transf);t[11]=0.25/1.1;m={id=m.id,transf=t}
   end
   if keep and type(platform)=="table" and m.id==PREFIX.."surface_platform.mdl" then
    -- Native perron_5 floor vertices are at z=1.1, verified from the installed
    -- mesh. All core infills in a custom kit must meet the fixed 0.25m floor.
    local t=copy(m.transf);t[11]=0.25/1.1;m={id=m.id,transf=t}
    if math.abs(m.transf[6]-1)<1e-8 then
    local span=40*m.transf[1];local count=math.floor((span+1e-8)/20)
    if count>0 then
     keep=false
     for i=0,count-1 do
      local t=copy(m.transf);t[1]=1;t[11]=1;t[13]=t[13]+20*i
      models[#models+1]={id=platform.model,transf=t}
     end
     local tail=span-count*20
     if tail>1e-8 then
      local t=copy(m.transf);t[1]=tail/40;t[13]=t[13]+20*count
      models[#models+1]={id=m.id,transf=t}
     end
    end
    end
   end
   if keep then
    if replacement then m={id=replacement,transf=copy(m.transf)} end
    models[#models+1]=m
   end
  end
  -- Optional elevated shelters use fixed safe positions clear of the stairs.
  if elevated and type(components.shelter)=="table" then
   for _,side in ipairs({-1,1}) do
    add(models,components.shelter.model,L==40 and 4 or 10,side*7.9,floor,side<0 and math.pi or 0)
   end
  end
  local canopy=components.canopy
  if type(canopy)=="table" then
   for _,side in ipairs({-1,1}) do
    for x=0,L-20,20 do add(models,canopy.model,x,side*6.5,floor) end
   end
   if elevated then
    -- Fixed native end/switch infills retain the complete elevated silhouette.
    local first,last=spec.stationType=="through" and -10 or -30,spec.stationType=="through" and L+10 or L+4
    for _,interval in ipairs({{first,0},{L,last}}) do for _,side in ipairs({-1,1}) do
     local x=interval[1]
     while x<interval[2]-1e-8 do
      local span=math.min(40,interval[2]-x)
      local t=transform(x,side*6.5,floor-1.1);t[1]=span/40
      models[#models+1]={id=PREFIX.."elevated_platform_roof.mdl",transf=t};x=x+span
     end
    end end
   else
    -- Native reference roof has no feet. The core owns supports and avoids the
    -- fixed +/-10m stair opening in a through station.
    local rows={2,L-2}
    for x=22,L-2,20 do rows[#rows+1]=x end
    local placed={}
    for _,x in ipairs(rows) do
     if not placed[x] and (spec.stationType~="through" or math.abs(x-centre)>=11) then
      placed[x]=true
      for _,side in ipairs({-1,1}) do
       local t=transform(x,side*6.5,floor);t[11]=3.82385/3.7637
       models[#models+1]={id="::/assets/stations/rail/era_c_perron_pillar.mdl",transf=t}
       add(models,"::/assets/stations/rail/era_c_perron_holder.mdl",x,side*6.5,floor+3.82385)
      end
     end
    end
    -- Move masts outside the roof; contact-wire position and vehicle lanes stay.
    for _,m in ipairs(models) do if m.id=="::/assets/streets/tram_pole_crossbar.mdl" then
     m.transf=copy(m.transf);m.transf[14]=m.transf[14]<0 and -9.8 or 9.8
     m.transf[5]=m.transf[5]*7.3/4;m.transf[6]=m.transf[6]*7.3/4
    elseif m.id=="::/stations/street/small_stops/small_new.mdl" or (type(components.shelter)=="table" and m.id==components.shelter.model) then
     -- Keep the reference shelter footprint clear of canopy columns at y=6.5.
     m.transf=copy(m.transf);m.transf[14]=m.transf[14]<0 and -7.9 or 7.9
    end end
   end
  end
  sub.models=models
 end
 return result
end
return M
