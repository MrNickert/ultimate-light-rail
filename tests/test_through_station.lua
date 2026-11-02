local originalRequire=require
function require(name)
 local path=name:match('^mrnickert_ultimate_metro::/(.+)$')
 if path then return assert(loadfile('content/'..path))()end
 return originalRequire(name)
end
local function main()
 local function resource(name)
  local env=setmetatable({_ = function(k)return k end},{__index=_G})
  assert(loadfile('content/'..name,'t',env))();return env.data()
 end
 local con=resource('through_station.con.lua')
 assert(#con.params==0,'only the tested 80m/two-platform prototype is exposed')
 local result=resource('through_station.script.lua').updateFn({}, {})
 local sub=result.subconstructions[1]
 local root=result.edgeLists[1]
 assert(root.params.type=='::/infrastructure/street/tram/tram_new.street_template','native tram approach, no mixed modes outside terminus')
 assert(#root.edges==4 and root.snapNodes[1]==0 and root.snapNodes[2]==3,'both outside endpoints connect')
 assert(root.edges[1][1][1]==-20 and root.edges[4][1][1]==100,'front and back approach geometry')
 assert(#sub.laneLists==7 and #sub.station.terminals==2,'two tracks plus underpass/platform/access lanes')
 for i=1,2 do
  local lane=sub.laneLists[i]
  assert(lane.forwardOnly==true and lane.needsReservation==false,'normal directional tram semantics')
  assert(lane.speedLimit==80,'station lane limit is direct, not divided by street-speed conversion')
  assert(#lane.transportModes==2 and lane.transportModes[1]=='TRAM' and lane.transportModes[2]=='ELECTRIC_TRAM','no rail modes')
  assert(lane.nodes[1][1][2]==(i==1 and -2.5 or 2.5),'native track spacing')
  for j=1,#lane.nodes,2 do
   local a,b=lane.nodes[j],lane.nodes[j+1]
   assert(a[1][3]==0 and b[1][3]==0)
   assert((b[1][1]-a[1][1])*(i==1 and 1 or -1)>0,'opposed driving directions')
  end
  local ref=sub.station.terminals[i].vehicleNode
  assert(ref[1]==i-1 and sub.laneLists[ref[1]+1].nodes[ref[2]+1][1][1]==40,'platform midpoint stop')
 end
 local function key(p)return string.format('%.5f,%.5f,%.5f',p[1]+0,p[2]+0,p[3]+0)end
 local graph={}
 for i=3,#sub.laneLists do
  local lane=sub.laneLists[i]
  assert(lane.transportModes[1]=='PERSON')
  for j=1,#lane.nodes,2 do
   local a,b=lane.nodes[j],lane.nodes[j+1]
   local from,to=key(a[1]),key(b[1])
   assert(from~=to,'no zero-length passenger edge')
   for _,v in ipairs(a[2])do assert(v==v and math.abs(v)<1000,'finite native stair tangent')end
   if a[1][2]*b[1][2]<0 then
    assert(a[1][3]<-7 and b[1][3]<-7,'crossing between tracks only underground')
   end
   graph[from]=graph[from]or{};graph[to]=graph[to]or{}
   graph[from][to]=true;graph[to][from]=true
  end
 end
 local function reachable(start)
  local visited,queue={},{key(start)}
  while #queue>0 do
   local p=table.remove(queue)
   if not visited[p]then visited[p]=true;for n in pairs(graph[p]or{})do queue[#queue+1]=n end end
  end
  return visited
 end
 local entries=0
 for _,lane in ipairs(sub.laneLists)do
  if lane.linkable then
   entries=entries+1
   local reached=reachable(lane.nodes[1][1])
   for _,terminal in ipairs(sub.station.terminals)do
    assert(#terminal.personEdges>0 and #terminal.personNodes>0)
    for _,ref in ipairs(terminal.personNodes)do
     local point=assert(sub.laneLists[ref[1]+1].nodes[ref[2]+1])[1]
     assert(math.abs(point[3]-0.25)<1e-6,'waiting passengers only on platform floor')
     assert(reached[key(point)],'either public entrance reaches both platforms through stairs')
    end
   end
  end
 end
 assert(entries==2,'two side entrances')
 local underpasses,slabs,holes=0,0,0
 for _,model in ipairs(sub.models)do
  if model.id=='mrnickert_ultimate_metro::/surface_underpass.mdl'then
   underpasses=underpasses+1
   assert(model.transf[1]==1 and model.transf[6]==1 and model.transf[11]==1,'native stairs retain their proportions')
   assert(math.abs(model.transf[15]+1.1-0.25)<1e-6,'native 1.1m floor moved to metro height')
  elseif model.id=='mrnickert_ultimate_metro::/surface_platform.mdl'then
   slabs=slabs+1
   assert(model.transf[13]==0 or model.transf[13]==60,'plain decks never cover stair opening')
   assert(model.transf[1]==0.5,'20m platform extensions')
  end
  assert(model.id~='mrnickert_ultimate_metro::/surface_head_tile.mdl','no head plaza blocking through tracks')
  assert(not model.id:find('apple_01',1,true),'no terminus trees in through track exit')
 end
 for _,face in ipairs(sub.groundFaces)do
  if face.modes[1].key=='::/infrastructure/shared/hole.gtex'then
   holes=holes+1
   for _,p in ipairs(face.face)do assert(math.abs(p[2])>4,'terrain hole does not cut the tram track bed')end
  end
 end
 assert(underpasses==2 and slabs==4 and holes==2,'native stair decks replace the middle of both platforms')
 local model=resource('surface_underpass.mdl')
 assert(not model.metadata.transportNetworkProvider,'model cannot add hidden rail or pedestrian lanes')
 print('PASS: two directional through tracks and native connections; both side entrances reach both platforms underground; finite paths, native stair proportions and safe terrain holes. Native placement/routing/boarding still need in-game validation.')
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),'\n');os.exit(1)end
