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
  local r={};for k,v in pairs(result) do r[k]=v end
  r.subconstructions={}
  for i,sub in ipairs(result.subconstructions or {}) do
   local t={};for k,v in pairs(sub) do if k~="models" then t[k]=v end end
   r.subconstructions[i]=t
  end
  return r
 end
 local con=resource("light_rail_station.con.lua")
 assert(#con.menuCategory.categories==1 and #con.params==4)
 local expected={"placement","stationType","platformLength","fence"}
 for i,param in ipairs(con.params) do
  assert(param.key==expected[i] and (#param.values==(i==3 and 5 or (i==1 and 3 or 2))) and param.uiType=="Button")
  assert(param.key~="crossover" and not param.postConstructionModifiable)
 end
 assert(con.params[1].values[1]=="LR_STATION_UNDERGROUND" and con.params[1].values[2]=="LR_STATION_SURFACE" and con.params[1].values[3]=="LR_STATION_ELEVATED")
 assert(con.params[1].defaultIndex==2 and con.params[1].displayMode=="Vertical","full-width location row, Surface selected by default")
 assert(#con.params[1].tooltips==3)
 for i=2,4 do assert(con.params[i].displayMode=="Horizontal") end
 for _,name in ipairs({"twin_terminus","through_station","underground_terminus"}) do
  assert(#resource(name..".con.lua").menuCategory.categories==0,"legacy menu entry hidden, not deleted")
 end
 local script=resource("light_rail_station.script.lua")
 local menu=resource("station_menu.script.lua")
 assert(con.params[4].checkEnabledScript.fileName=="mrnickert_ultimate_metro::/station_menu.script@checkFenceFn")
 assert(menu.checkFenceFn({}, {placement=1})=="Disabled")
 assert(menu.checkFenceFn({}, {placement=2})=="Enabled")
 assert(menu.checkFenceFn({}, nil)=="Enabled")
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
 print("PASS: one four-option menu; all eight selections; fixed type/crossover; legacy layout equality, fence isolation, both underground platform accesses and open through tunnels.")
end
