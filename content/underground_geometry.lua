-- Internal transforms and pedestrian stair flights for underground construction geometry.
local laneutil=require "::/scripts/construction/laneutil.lua"
local geometry={}

local function transform(m,p,point)
 local offset=point and 1 or 0
 return {m[1]*p[1]+m[5]*p[2]+offset*m[13],
  m[2]*p[1]+m[6]*p[2]+offset*m[14],p[3]+offset*m[15]}
end

-- Construction model and snap transforms are serialized 4x4 arrays.
local function transformMatrix(level,matrix)
 local result={}
 for i=1,16,4 do
  local w=matrix[i+3]
  result[i]=level[1]*matrix[i]+level[5]*matrix[i+1]+level[13]*w
  result[i+1]=level[2]*matrix[i]+level[6]*matrix[i+1]+level[14]*w
  result[i+2]=matrix[i+2]+level[15]*w
  result[i+3]=w
 end
 return result
end

function geometry.transformLevel(result,m)
 local sub=result.subconstructions[1]
 for _,lane in ipairs(sub.laneLists) do
  for _,node in ipairs(lane.nodes) do
   node[1]=transform(m,node[1],true)
   node[2]=transform(m,node[2],false)
  end
 end
 for _,edge in ipairs(result.edgeLists) do
  for _,node in ipairs(edge.edges) do
   node[1]=transform(m,node[1],true)
   node[2]=transform(m,node[2],false)
  end
 end
 for _,model in ipairs(sub.models) do model.transf=transformMatrix(m,model.transf) end
 for _,collider in ipairs(sub.colliders) do
  for i,p in ipairs(collider.params.points) do collider.params.points[i]=transform(m,p,true) end
 end
 for _,entry in ipairs(sub.station.catchmentAreas) do entry.position=transform(m,entry.position,true) end
 if sub.groundFaces then
  for _,face in ipairs(sub.groundFaces) do
   for i,p in ipairs(face.face) do face.face[i]=transform(m,p,true) end
  end
 end
 for _,alignment in ipairs(sub.terrainAlignmentLists or {}) do
  for _,triangle in ipairs(alignment.triangles or {}) do
   for i,p in ipairs(triangle) do triangle[i]=transform(m,p,true) end
  end
 end
 result.snapPoint.transf=transformMatrix(m,result.snapPoint.transf)
end

function geometry.addStairs(sub,points)
 local curves={}
 for i=1,#points-1 do
  local a,b=points[i],points[i+1]
  curves[#curves+1]={a,b}
  local dx,dy,dz=b[1]-a[1],b[2]-a[2],b[3]-a[3]
  local run=math.sqrt(dx*dx+dy*dy)
  local steps=math.max(1,math.ceil(math.abs(dz)/0.2))
  for j=1,steps do
   local t=(j-1)/steps
   local nx,ny=-dy/run,dx/run
   sub.models[#sub.models+1]={id="mrnickert_ultimate_metro::/elevated_concrete_visual.mdl",
    transf={dx/(6*steps),dy/(6*steps),0,0,nx*0.6,ny*0.6,0,0,0,0,0.12,0,
     a[1]+dx*t-nx*1.2,a[2]+dy*t-ny*1.2,a[3]+dz*t,1}}
  end
 end
 sub.laneLists[#sub.laneLists+1]=laneutil.createLane(curves,{"PERSON"},2,2,false)
end

return geometry
