-- Invoked with real native construction helpers by test_underground.lua.
return function(resource)
 local function equal(a,b,path)
  path=path or "result"
  assert(type(a)==type(b),path..": type differs")
  if type(a)~="table" then assert(a==b,path..": value differs");return end
  for k,v in pairs(a) do equal(v,b[k],path.."."..tostring(k)) end
  for k in pairs(b) do assert(a[k]~=nil,path..": extra key "..tostring(k)) end
 end
 local function functional(result)
  local r={};for k,v in pairs(result) do if k~="snapPoint" then r[k]=v end end
  r.edgeLists={}
  for i,edge in ipairs(result.edgeLists) do
   local t={};for k,v in pairs(edge) do if k~="maxNodeSnapAngle" then t[k]=v end end
   r.edgeLists[i]=t
  end
  r.subconstructions={}
  for i,sub in ipairs(result.subconstructions or {}) do
   local t={};for k,v in pairs(sub) do if k~="models" then t[k]=v end end
   r.subconstructions[i]=t
  end
  return r
 end
 local con=resource("light_rail_station.con.lua")
 assert(#con.menuCategory.categories==1 and #con.params==9)
 local expected={"placement","stationType","platformLength","fence","turnback","depth","ulrPlatformAccess","ulrUndergroundAlignment","ulrStreetAlignment"}
 for i,param in ipairs(con.params) do
  assert(param.key==expected[i] and (#param.values==({3,2,5,2,2,4,2,2,2})[i]) and param.uiType=="Button")
  assert(param.key~="crossover" and not param.postConstructionModifiable)
 end
 assert(con.params[1].values[1]=="LR_STATION_UNDERGROUND" and con.params[1].values[2]=="LR_STATION_SURFACE" and con.params[1].values[3]=="LR_STATION_ELEVATED")
 assert(con.params[1].defaultIndex==2 and con.params[1].displayMode=="Vertical","full-width location row, Surface selected by default")
 assert(#con.params[1].tooltips==3)
 for i=2,9 do assert(con.params[i].displayMode=="Horizontal") end
 for _,name in ipairs({"twin_terminus","through_station","underground_terminus"}) do
  assert(#resource(name..".con.lua").menuCategory.categories==0,"legacy menu entry hidden, not deleted")
 end
 local script=resource("light_rail_station.script.lua")
 local menu=resource("station_menu.script.lua")
 assert(con.params[4].checkEnabledScript.fileName=="mrnickert_ultimate_metro::/station_menu.script@checkFenceFn")
 assert(menu.checkFenceFn({}, {placement=1})=="Disabled")
 assert(menu.checkFenceFn({}, {placement=2})=="Enabled")
 assert(menu.checkFenceFn({}, nil)=="Enabled")
 assert(con.params[5].defaultIndex==1)
 assert(con.params[5].checkEnabledScript.fileName=="mrnickert_ultimate_metro::/station_menu.script@checkTurnbackFn")
 assert(menu.checkTurnbackFn({}, {stationType=1})=="Enabled")
 assert(menu.checkTurnbackFn({}, {stationType=2})=="Disabled")
 assert(menu.checkTurnbackFn({}, nil)=="Disabled")
 local access=con.params[7]
 assert(access.defaultIndex==1 and access.values[1]=="LR_STATION_UNDERPASS" and access.values[2]=="LR_STATION_CROSSING")
 assert(access.checkEnabledScript.fileName=="mrnickert_ultimate_metro::/station_menu.script@checkPlatformAccessFn")
 for placement=1,3 do for stationType=1,2 do
  local params={placement=placement,stationType=stationType,platformLength=3,fence=1,seed=42}
  local enabled=placement==2 and stationType==1
  assert(menu.checkPlatformAccessFn({},params)==(enabled and "Enabled" or "Hidden"))
  if not enabled then
   local ordinary=script.updateFn({},params)
   params.ulrPlatformAccess=2
   equal(script.updateFn({},params),ordinary,"crossing selection is ignored when unavailable")
  end
 end end
 assert(menu.checkPlatformAccessFn({},nil)=="Hidden")
 for index,L in ipairs({40,60,80,100,120}) do for turnback=1,2 do for fence=1,2 do
  local params={placement=2,stationType=1,platformLength=index,turnback=turnback,fence=fence,seed=42}
  local ordinary=script.updateFn({},params)
  params.ulrPlatformAccess=1
  equal(script.updateFn({},params),ordinary,"missing access parameter defaults to the underpass")
  params.ulrPlatformAccess=2
  local result=script.updateFn({},params)
  local sub=result.subconstructions[1]
  local vehicleCount=turnback==2 and 6 or 2
  equal(result.edgeLists,ordinary.edgeLists,"crossing retains track approaches")
  for i=1,vehicleCount do
   equal(sub.laneLists[i],ordinary.subconstructions[1].laneLists[i],"crossing retains vehicle lanes")
  end
  assert(#sub.groundFaces==3,"solid platform ground without stair holes")
  local slabs=0
  for _,model in ipairs(sub.models) do
   assert(model.id~="mrnickert_ultimate_metro::/surface_underpass.mdl")
   if model.id=="mrnickert_ultimate_metro::/elevated_paving.mdl" then slabs=slabs+1 end
  end
  assert(slabs==6,"two crossing surfaces, each with two ramps")
  local crossingCount,entranceCount=0,0
  for i=vehicleCount+1,#sub.laneLists do
   local lane=sub.laneLists[i]
   assert(lane.transportModes[1]=="PERSON" and not lane.forwardOnly)
   for _,node in ipairs(lane.nodes) do assert(node[1][3]>=0,"crossing routes never go underground") end
   if lane.linkable then entranceCount=entranceCount+1 end
   local start,last=lane.nodes[1][1],lane.nodes[#lane.nodes][1]
   if start[2]<0 and last[2]>0 then
    crossingCount=crossingCount+1
    local x=crossingCount==1 and 1.5 or L-1.5
    assert(start[1]==x and last[1]==x and not lane.linkable)
    for side,point in ipairs({start,last}) do
     local terminal=sub.station.terminals[side]
     assert(terminal.capacity==L/20*35)
     local platform=sub.laneLists[terminal.personNodes[1][1]+1]
     local connected=false
     for _,node in ipairs(platform.nodes) do
      local p=node[1]
      if p[1]==point[1] and p[2]==point[2] and p[3]==point[3] then connected=true end
     end
     assert(connected,"each crossing must connect directly to both terminal paths")
    end
   end
  end
  assert(crossingCount==2 and entranceCount==6)
 end end end
 local api=require "mrnickert_ultimate_metro::/station_api_v1.lua"
 local undergroundAlignment=con.params[8]
 assert(undergroundAlignment.defaultIndex==2 and undergroundAlignment.values[1]=="LR_STATION_STREET_PARALLEL")
 assert(undergroundAlignment.values[2]=="LR_STATION_STREET_PERPENDICULAR")
 assert(undergroundAlignment.checkEnabledScript.fileName==con.params[6].checkEnabledScript.fileName)
 local alignment=con.params[9]
 assert(alignment.defaultIndex==1 and alignment.values[1]=="LR_STATION_STREET_PARALLEL")
 assert(alignment.values[2]=="LR_STATION_STREET_PERPENDICULAR")
 assert(alignment.checkEnabledScript.fileName=="mrnickert_ultimate_metro::/station_menu.script@checkStreetAlignmentFn")
 for placement=1,3 do
  assert(menu.checkStreetAlignmentFn({}, {placement=placement})==(placement==3 and "Enabled" or "Hidden"))
  for stationType=1,2 do for i,L in ipairs({40,60,80,100,120}) do
   local params={placement=placement,stationType=stationType,platformLength=i,turnback=2,seed=42}
   local result=script.updateFn({},params)
   local spec={apiVersion=1,placement=({"underground","surface","elevated"})[placement],
    stationType=stationType==1 and "through" or "terminus",platformLength=L,turnback=stationType==1}
   local direct=api.buildStation(spec,{},params)
   local frame=result.snapPoint.transf
   if placement==2 and stationType==1 then
    assert(frame[1]==1 and frame[2]==0 and frame[13]==L/2 and frame[14]==-10 and frame[15]==0)
   elseif placement==2 then
    assert(frame[1]==0 and frame[2]==1 and frame[13]==L+6 and frame[14]==0 and frame[15]==0)
   elseif placement==3 then
    assert(frame[1]==1 and frame[2]==0 and frame[13]==L/2 and frame[14]==-15 and frame[15]==0)
    params.ulrStreetAlignment=2
    local side=script.updateFn({},params)
    equal(side,api.buildStation(spec,{},params),"public elevated snapping matches the perpendicular builder")
    local sideFrame=side.snapPoint.transf
    assert(sideFrame[1]==0 and sideFrame[2]==-1 and sideFrame[5]==1 and sideFrame[6]==0)
    assert(sideFrame[13]==L/2-11.5 and sideFrame[14]==-12.5 and sideFrame[15]==0)
    equal(side.edgeLists,result.edgeLists,"elevated orientation keeps the same track ends")
    local paths=side.subconstructions[1].laneLists
    local entry=paths[#paths]
    equal(entry.nodes[1][1],{sideFrame[13]+1,sideFrame[14],0.15},"haaks public entry")
    equal(entry.nodes[#entry.nodes][1],{L/2-8,-6.5,0.15},"haaks route joins the existing stairs")
   end
   if placement~=1 then
    equal(result.snapPoint.snapToBaseEdgeTypes,{"STREET"},"road placement target")
    assert(not result.snapPoint.transportModes)
    for _,edge in ipairs(result.edgeLists) do
     assert(edge.maxNodeSnapAngle==0 and #edge.snapNodes==1 and #edge.freeNodes==1)
    end
   end
   equal(result,direct,"public station snapping matches the built-in builder")
   if placement~=1 then
    local before=script.updateFn({},params)
    params.ulrUndergroundAlignment=1
    equal(script.updateFn({},params),before,"Underground alignment is ignored for other locations")
   end
  end end
 end
 local legacySurface=resource("twin_terminus.script.lua")
 local legacyThrough=resource("through_station.script.lua")
 local legacyUnderground=resource("underground_terminus.script.lua")
 local results={}
 for placement=1,2 do for stationType=1,2 do for fence=1,2 do
  local params={placement=({2,1,3})[placement],stationType=stationType,fence=fence,seed=42,crossover=1}
  local r=script.updateFn({},params)
  assert(params.crossover==1 and params.fence==fence,"builder must not mutate UI/save parameters")
  local sub=r.subconstructions[1]
  local vehicles=stationType==1 and 2 or 4
  for i=1,vehicles do
   local lane=sub.laneLists[i]
   assert(lane.transportModes[1]=="TRAM" and lane.transportModes[2]=="ELECTRIC_TRAM")
   assert(lane.forwardOnly==(stationType==1) and lane.needsReservation==(stationType==2))
   assert(lane.speedLimit==(i<=2 and 80 or 40))
   for _,node in ipairs(lane.nodes) do assert(node[1][3]==(placement==2 and -18 or 0)) end
  end
  assert(sub.laneLists[vehicles+1].transportModes[1]=="PERSON","station type fixes number of vehicle lanes")
  assert(#sub.station.terminals==2 and #r.edgeLists==(stationType==1 and 2 or 1))
  local fences=0
  for _,m in ipairs(sub.models) do if m.id=="mrnickert_ultimate_metro::/lightrail_fence.mdl" then fences=fences+1 end end
  assert((fences>0)==(placement==1 and fence==2))
  if placement==1 then
   local baseline=(stationType==1 and legacyThrough or legacySurface).updateFn({}, {crossover=2,seed=42})
   equal(sub.laneLists,baseline.subconstructions[1].laneLists,"validated surface vehicle/passenger paths")
   equal(sub.station,baseline.subconstructions[1].station,"validated surface station terminals")
   if fence==2 then equal(functional(r),functional(baseline),"validated fenced surface functional layout") end
   for _,edge in ipairs(r.edgeLists) do
    local profile=edge.params.type
    if fence==1 then
     assert(profile==(stationType==1 and "::/infrastructure/street/tram/tram_new.street_template"
      or "mrnickert_ultimate_metro::/lightrail_double.street_template"),"no implicit native fences")
    end
   end
  else
   assert(#sub.laneLists==vehicles+6 and #sub.colliders>0)
   if stationType==2 then
    equal(r,legacyUnderground.updateFn({}, {crossover=2,seed=42}),"validated underground terminus")
   else
    assert(#sub.laneLists[1].transportModes==2,"underground through uses only native tram modes")
    local ends={}
    for _,m in ipairs(sub.models) do
     assert(m.id~="::/assets/buildings/res/misc/wall_2m_m.mdl","through station cannot have a closed head")
     if m.id=="::/stations/street/underground_station/models/underground_station_end.mdl" then ends[m.transf[13]]=true end
    end
    assert(ends[-10] and ends[90],"both station shells end at internal tunnel connections")
    local expectedX={{-20,-10},{90,100}}
    for i,edge in ipairs(r.edgeLists) do
     assert(edge.params.type=="::/infrastructure/street/tram/tram_new.street_template")
     for j,node in ipairs(edge.edges) do assert(node[1][1]==expectedX[i][j]) end
    end
   end
   for _,edge in ipairs(r.edgeLists) do
    assert(edge.edgeType=="TUNNEL" and edge.params.edgeType=="TUNNEL")
    for _,node in ipairs(edge.edges) do assert(node[1][3]==-18) end
   end
   -- Traverse actual native stairs/concourse/platform curves from the public entrance.
   local function key(p)return string.format("%.3f,%.3f,%.3f",p[1]+0,p[2]+0,p[3]+0)end
   local graph={}
   for i=vehicles+1,#sub.laneLists do
    local lane=sub.laneLists[i]
    for j=1,#lane.nodes,2 do
     local a,b=key(lane.nodes[j][1]),key(lane.nodes[j+1][1])
     graph[a]=graph[a] or {};graph[b]=graph[b] or {};graph[a][b]=true;graph[b][a]=true
    end
   end
   local entry=sub.laneLists[vehicles+1]
   assert(entry.linkable and entry.nodes[1][1][3]==0,"public street-level entrance")
   local queue={key(entry.nodes[1][1])};local seen={}
   while #queue>0 do
    local p=table.remove(queue)
    if not seen[p] then seen[p]=true;for n in pairs(graph[p] or {}) do queue[#queue+1]=n end end
   end
   for _,terminal in ipairs(sub.station.terminals) do
    for _,ref in ipairs(terminal.personNodes) do
     local point=sub.laneLists[ref[1]+1].nodes[ref[2]+1][1]
     assert(point[3]==-17.65 and seen[key(point)],"public entrance reaches both underground platforms")
    end
   end
  end
  local id=placement..":"..stationType
  if results[id] then
   equal(sub.laneLists,results[id].subconstructions[1].laneLists,"fence choice cannot change routing")
   if placement==2 then equal(r,results[id],"underground ignores disabled fence choice") end
  end
  results[id]=r
 end end end
 equal(functional(script.updateFn({},nil)),functional(legacySurface.updateFn({}, {crossover=2})),"defaults use validated surface terminus function")
 print("PASS: nine station settings; street alignment and retained track ends; two connected level crossings in 20 combinations; all eight selections; fixed type/crossover; legacy layout equality, fence isolation, both underground platform accesses and open through tunnels.")
end
