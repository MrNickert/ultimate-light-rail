local api=require "mrnickert_ultimate_metro::/station_api_v1.lua"
local heights={[-4]=-72,[-3]=-54,[-2]=-36,[-1]=-18,[0]=0,[1]=12}
local function key(point)
 return ("%d,%d,%d"):format(math.floor(point[1]*1000+0.5),
  math.floor(point[2]*1000+0.5),math.floor(point[3]*1000+0.5))
end
local function close(a,b) return math.abs(a-b)<1e-7 end

local function checkNetwork(result,levels,lengths,axes,centres)
 assert(#result.subconstructions==1 and #result.edgeLists==2*#levels)
 local sub=result.subconstructions[1]
 assert(#sub.station.terminals==2*#levels)
 local graph,entries,switches={},{},0
 for _,lane in ipairs(sub.laneLists) do
  if lane.transportModes[1]=="PERSON" then
   if lane.linkable then entries[#entries+1]=key(lane.nodes[1][1]) end
   for i=1,#lane.nodes,2 do
    local a,b=key(lane.nodes[i][1]),key(lane.nodes[i+1][1])
    graph[a]=graph[a] or {};graph[b]=graph[b] or {}
    graph[a][b],graph[b][a]=true,true
   end
  elseif lane.speedLimit==40 then
   assert(lane.needsReservation and not lane.forwardOnly)
   switches=switches+1
  end
 end
 assert(#entries>0 and switches==4*#levels)
 local visited,queue={[entries[1]]=true},{entries[1]}
 local cursor=1
 while queue[cursor] do
  for point in pairs(graph[queue[cursor]]) do
   if not visited[point] then visited[point]=true;queue[#queue+1]=point end
  end
  cursor=cursor+1
 end
 for _,entry in ipairs(entries) do assert(visited[entry],"street paths belong to one network") end
 for i,terminal in ipairs(sub.station.terminals) do
  local index=math.ceil(i/2)
  local level=levels[index]
  local lane=sub.laneLists[terminal.vehicleNode[1]+1]
  assert(terminal.capacity==lengths[index]/20*35 and lane.needsReservation and not lane.forwardOnly)
  assert(lane.nodes[terminal.vehicleNode[2]+1][1][3]==heights[level])
  for _,ref in ipairs(terminal.personNodes) do
   local waiting=sub.laneLists[ref[1]+1]
   local point=waiting.nodes[ref[2]+1][1]
   assert(waiting.transportModes[1]=="PERSON" and visited[key(point)],"perron is disconnected")
   assert(close(point[3],heights[level]+(level<0 and 0.35 or 0.25)))
  end
  for _,ref in ipairs(terminal.personEdges) do
   local waiting=sub.laneLists[ref[1]+1]
   assert(waiting.transportModes[1]=="PERSON" and waiting.nodes[ref[2]*2+2])
  end
 end
 for i=1,#levels do
  local z=heights[levels[i]]
  local p={}
  for j=1,2 do
   local edge=result.edgeLists[(i-1)*2+j]
   local index=edge.snapNodes[1]
   assert(index==edge.freeNodes[1] and edge.maxNodeSnapAngle==0)
   p[j]=edge.edges[index+1][1]
   assert(p[j][3]==z and edge.edgeType==(z<0 and "TUNNEL" or (z>0 and "BRIDGE" or nil)))
  end
  local dx,dy=p[2][1]-p[1][1],p[2][2]-p[1][2]
  local angle=math.rad(axes[i])
  assert(close(dx*math.sin(angle)-dy*math.cos(angle),0))
  assert(close((p[1][1]+p[2][1])/2,centres[i][1]) and close((p[1][2]+p[2][2])/2,centres[i][2]))
 end
 return sub,graph
end

return function()
 for level,z in pairs(heights) do
  local result=api.buildStation({apiVersion=1,level=level,stationType="through",platformLength=80})
  assert(result.edgeLists[1].edges[1][1][3]==z)
 end
 local function surface(override)
  local spec={apiVersion=1,placement="surface",stationType="through",platformLength=80}
  for k,v in pairs(override) do spec[k]=v end
  return api.buildStation(spec)
 end
 assert(surface({level=0}).edgeLists[1].edges[1][1][3]==0)
 assert(not pcall(surface,{level=1}))
 assert(not pcall(surface,{level=-1,placement="underground",undergroundLevel=-2}))
 assert(surface({placement="underground"}).edgeLists[1].edges[1][1][3]==-18)

 -- The developer-kit example is executed as an independent consumer, with
 -- only the documented ULR import available in either construction resource.
 local function example(file)
  local env=setmetatable({require=function(path)
   if file=="station.con.lua" then
    assert(path=="mrnickert_ultimate_metro::/station_menu.lua")
    return {getMenuCategory=api.getMenuCategory}
   end
   assert(path=="mrnickert_ultimate_metro::/station_api_v1.lua");return api
  end},{__index=_G})
  assert(loadfile("examples/multi_level/"..file,"t",env))()
  return env.data()
 end
 local desc=example("station.con.lua")
 assert(desc.menuCategory.categories[1].category=="ulr_stations")
 local publicExample=example("station.script.lua").updateFn({}, {seed=42})
 local exampleSub=checkNetwork(publicExample,{0,1},{60,100},{0,90},{{0,0},{1,20.5}})
 local roof=0
 for _,model in ipairs(exampleSub.models) do
  assert(model.id~="::/stations/street/small_stops/small_new.mdl")
  if model.id=="mrnickert_ultimate_metro::/platform_roof20.mdl" then
   assert(model.transf[15]>12);roof=roof+1
  end
 end
 assert(roof>0)

 local mixed={apiVersion=1,layers={{level=-1},{level=1},{level=0}}}
 local plaza,graph=checkNetwork(api.buildInterchange(mixed),{0,1,-1},{80,80,80},{0,90,90},{{0,0},{0,20.5},{0,24.5}})
 assert(mixed.layers[1].rotation==nil and mixed.layers[2].offset==nil)
 assert(graph[key({0,12.5,0.15})][key({-2.5,16,0.15})])
 assert(graph[key({0.5,16,-12})][key({0,16,-12})])
 local holes=0
 for _,face in ipairs(plaza.groundFaces) do
  if face.modes[1].key=="::/infrastructure/shared/hole.gtex" then
   local corners={[key({-4,16,0})]=true,[key({2,16,0})]=true,[key({-4,28,0})]=true,[key({2,28,0})]=true}
   assert(#face.face==4)
   for _,point in ipairs(face.face) do assert(corners[key(point)]);corners[key(point)]=nil end
   holes=holes+1
  end
 end
 assert(holes==1)
 local piers,foundations=0,0
 for _,model in ipairs(plaza.models) do
  assert(model.id~="::/stations/street/underground_station/models/underground_station_surface.mdl")
  local t=model.transf
  if model.id=="mrnickert_ultimate_metro::/elevated_concrete.mdl" and t[11]>4 then
   local minY,maxY=t[14],t[14]+6*t[2]
   assert(minY>=9 or maxY<=-9,"a pier overlaps the surface platform")
   assert(minY>=-11 or maxY<=-29,"a pier overlaps the street corridor")
   piers=piers+1
  end
  local paver=model.id=="mrnickert_ultimate_metro::/elevated_paving.mdl" and t[15]==0.151
  local foundation=model.id=="mrnickert_ultimate_metro::/elevated_concrete_visual.mdl" and t[15]>0 and t[15]<0.15 and math.abs(t[15]-2.4*t[11])<1e-8
  if foundation then foundations=foundations+1;assert(0.151-t[15]>=0.05) end
  if paver or foundation then
   local xMax,yMin=t[13],t[14]
   local xMin=xMax+t[5]*(paver and 3 or 4)
   local yMax=yMin+t[2]*(paver and 3 or 6)
   assert(xMax<=-4 or xMin>=2 or yMax<=16 or yMin>=28,"plaza geometry covers the stair opening")
  end
 end
 assert(piers>0 and foundations>0)
 for _,collider in ipairs(plaza.colliders) do
  for _,point in ipairs(collider.params.points) do assert(point[3]<0) end
 end
 local shallow={level=-1,rotation=45,platformLength=40,
  design={apiVersion=1,id="test_a",assets={undergroundBench="test::/shallow.mdl"}}}
 local deep={level=-2,rotation=135,platformLength=120,offset={x=4,y=-3},
  design={apiVersion=1,id="test_b",assets={undergroundBench="test::/deep.mdl"}}}
 local underground=checkNetwork(api.buildInterchange({apiVersion=1,layers={shallow,deep}}),
  {-1,-2},{40,120},{45,135},{{0,0},{4,-3}})
 local seen={}
 for _,model in ipairs(underground.models) do
  if model.id=="test::/shallow.mdl" then assert(close(model.transf[15],-17.65));seen.shallow=true end
  if model.id=="test::/deep.mdl" then assert(close(model.transf[15],-35.65));seen.deep=true end
 end
 assert(seen.shallow and seen.deep)

 local all=api.buildInterchange({apiVersion=1,layers={{level=-4},{level=-3},{level=-2},{level=-1},
  {level=0,rotation=90,platformLength=40},{level=1,offset={x=-3,y=20.75},platformLength=120}}})
 checkNetwork(all,{0,1,-1,-2,-3,-4},{40,120,80,80,80,80},{90,0,0,90,0,90},
  {{0,0},{-20.75,-3},{-24.75,-3},{-24.75,-3},{-24.75,-3},{-24.75,-3}})
 for _,invalid in ipairs({{{level=0},{level=-1}},{{level=-1},{level=-3}},{{level=0},{level=0}},
  {{level=0},{level=1,rotation=45}},{{level=0},{level=1,offset={x=4,y=20.5}}},
  {{level=0},{level=1},{level=-1,rotation=0}},{{level=-1},{level=-2,platformLength=42}},
  {{level=-1},{level=-2,design=false}},{{level=0},[3]={level=1}}}) do
  local ok,reason=pcall(api.buildInterchange,{apiVersion=1,layers=invalid})
  assert(not ok and reason:find("Ultimate Light Rail API v1",1,true))
 end
 for _,name in ipairs({"aboveground_interchange","mixed_interchange"}) do
  for _,extension in ipairs({".con.lua",".script.lua"}) do
   assert(not loadfile("content/"..name..extension),"temporary construction is still registered")
  end
 end
 print("PASS: public interchange example, legacy and numeric single-station calls, isolated designs, shared routes, and all six levels in Lua.")
end
