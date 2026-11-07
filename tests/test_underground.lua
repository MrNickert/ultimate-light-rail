local function main()
-- Native lane/model/terrain helper code is loaded by test_native_layout.py.
-- Only Teal math and engine serialization dependencies are replaced here.
local nativeMatrix={}
local function identity() return setmetatable({1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1},nativeMatrix) end
local mat={}
function mat.transl(v) local m=identity();m[13]=v.x;m[14]=v.y;m[15]=v.z;return m end
function mat.rotZ(a) local m=identity();m[1]=math.cos(a);m[2]=math.sin(a);m[5]=-m[2];m[6]=m[1];return m end
function mat.mul(a,b)
 assert(getmetatable(a)==nativeMatrix or getmetatable(b)==nativeMatrix,"native mat4.mul requires a native matrix operand")
 local m=identity()
 for c=0,3 do for r=0,3 do local v=0;for k=0,3 do v=v+a[k*4+r+1]*b[c*4+k+1] end;m[c*4+r+1]=v end end
 return m
end
function mat.gemv(m,v)
 return {x=m[1]*v.x+m[5]*v.y+m[9]*v.z+m[13],y=m[2]*v.x+m[6]*v.y+m[10]*v.z+m[14],z=m[3]*v.x+m[7]*v.y+m[11]*v.z+m[15]}
end
local vec={new=function(x,y,z)return{x=x,y=y,z=z}end,fromArray=function(v)return{x=v[1],y=v[2],z=v[3]}end}
function vec.toArray(v)return{v.x,v.y,v.z}end
function orderedPairs(values)
 local keys={};for k in pairs(values) do keys[#keys+1]=k end
 table.sort(keys,function(a,b) if type(a)~=type(b) then return type(a)<type(b) end;return a<b end)
 local i=0
 return function() i=i+1;local k=keys[i];if k~=nil then return k,values[k] end end
end
local cache={}
function require(name)
 local own=name:match('^mrnickert_ultimate_metro::/(.+)$')
 if cache[name] then return cache[name] end
 local result
 if own then result=assert(loadfile('content/'..own))()
 elseif name:find('mat4.tl',1,true) then result=mat
 elseif name:find('vec3.tl',1,true) then result=vec
 elseif name:find('collider_util_serialized.tl',1,true) then
  result={createPointCloud=function(points)local p={};for _,v in ipairs(points)do p[#p+1]=vec.toArray(v)end;return{params={points=p}}end}
 elseif name:find('street_util_serialized.tl',1,true) or name:find('asset_util.tl',1,true) or name:find('mathutil.lua',1,true) then result={}
 else
  local file=name:match('/([^/]+)%.lua$');assert(file,'unexpected native import: '..name)
  result=assert(loadfile(arg[1]..'/'..file..'.lua'))()
 end
 cache[name]=result;return result
end
local function resource(path)
 local env=setmetatable({_ = function(k)return k end},{__index=_G})
 assert(loadfile('content/'..path,'t',env))();return env.data()
end
if arg[2] then
 assert(loadfile('tests/station_contract_snapshot.lua'))()(resource,arg[2]);return
end
local underground=resource('underground_terminus.script.lua')
local surface=resource('twin_terminus.script.lua')
local con=resource('underground_terminus.con.lua')
assert(con.undergroundView and con.configureLayerScript,'underground placement layer')
local function key(p)return string.format('%.3f,%.3f,%.3f',p[1]+0,p[2]+0,p[3]+0)end
for _,option in ipairs({1,2})do
 local r=underground.updateFn({}, {crossover=option,seed=42})
 local base=surface.updateFn({}, {crossover=option,seed=42})
 local sub=r.subconstructions[1]
 local vehicles=option==2 and 4 or 2
 assert(#sub.laneLists==vehicles+6)
 assert(r.edgeLists[1].edgeType=='TUNNEL')
 for _,n in ipairs(r.edgeLists[1].edges)do assert(n[1][3]==-18)end
 for i=1,vehicles do
  local a,b=sub.laneLists[i],base.subconstructions[1].laneLists[i]
  assert(a.speedLimit==(i>2 and 40 or 80))
  assert(a.forwardOnly==false and a.needsReservation==true)
  for j,n in ipairs(a.nodes)do
   assert(n[1][1]==b.nodes[j][1][1] and n[1][2]==b.nodes[j][1][2] and n[1][3]==-18,'same vehicle geometry, shifted down')
   for k=1,3 do assert(n[2][k]==b.nodes[j][2][k],'same switch tangents')end
  end
 end
 local graph={}
 for i=vehicles+1,#sub.laneLists do
  local lane=sub.laneLists[i]
  for j=1,#lane.nodes,2 do
   local a,b=key(lane.nodes[j][1]),key(lane.nodes[j+1][1])
   graph[a]=graph[a] or {};graph[b]=graph[b] or {};graph[a][b]=true;graph[b][a]=true
  end
 end
 local start=sub.laneLists[vehicles+1].nodes[1][1]
 assert(start[3]==0 and sub.laneLists[vehicles+1].linkable,'street-level public entrance')
 assert(math.abs(start[1]-69)<1e-6 and math.abs(start[2]+3)<1e-6,'entrance rotated towards closed head')
 assert(r.snapPoint.transf[13]==68 and r.snapPoint.transf[14]==0,'surface-road snap follows head entrance')
 local visited,queue={},{key(start)}
 while #queue>0 do
  local p=table.remove(queue)
  if not visited[p] then visited[p]=true;for n in pairs(graph[p] or {})do queue[#queue+1]=n end end
 end
 for _,terminal in ipairs(sub.station.terminals)do
  for _,ref in ipairs(terminal.personNodes)do
   local point=sub.laneLists[ref[1]+1].nodes[ref[2]+1][1]
   assert(point[3]==-17.65 and visited[key(point)],'public stairs reach both platforms')
  end
 end
 assert(#sub.models>20 and #sub.colliders>0,'native station shell and collision data')
 for _,alignment in ipairs(sub.terrainAlignmentLists)do
  for _,triangle in ipairs(alignment.triangles)do for _,p in ipairs(triangle)do
   assert(p[1]>=69-1e-6 and p[1]<=84+1e-6 and p[2]>=-8-1e-6 and p[2]<=8+1e-6 and p[3]==0,'only head entrance alters surface terrain')
  end end
 end
 for _,m in ipairs(sub.models)do
  assert(m.id:sub(1,3)=='::/','all native assets use absolute resource IDs')
  for _,v in ipairs(m.transf)do assert(v==v and math.abs(v)<1e6)end
 end
 local wall
 for _,model in ipairs(sub.models)do if model.id=='::/assets/buildings/res/misc/wall_2m_m.mdl' then wall=model end end
 assert(wall and wall.transf[13]>80,'visible closed head beyond track endpoints')
end
assert(loadfile('tests/test_station_api.lua'))()(resource)
assert(loadfile('tests/test_station_components.lua'))()(resource)
assert(loadfile('tests/test_station_config.lua'))()(resource)
assert(loadfile('tests/test_station_lengths.lua'))()(resource)
assert(loadfile('tests/test_elevated_station.lua'))()(resource)
assert(loadfile('tests/test_turnback.lua'))()(resource)
assert(loadfile('tests/test_underground_interchange.lua'))()(resource)
assert(loadfile('tests/test_underground_depth.lua'))()(resource)
print('PASS: both switch settings, identical vehicle geometry at -18m, native pedestrian paths reach both platforms, native models/colliders/entrance terrain, 80/40 km/h limits. Engine placement still needs in-game validation.')
end
local ok,err=xpcall(main,debug.traceback)
if not ok then io.stderr:write(tostring(err),'\n');os.exit(1)end
