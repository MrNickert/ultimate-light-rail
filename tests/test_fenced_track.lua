-- Compare against the installed game's real template, not a duplicated baseline.
_ = function(key) return key end
local function read(path)
 assert(loadfile(path))()
 return data()
end
local function equal(a,b,path)
 assert(type(a)==type(b),path..": different types")
 if type(a)~="table" then assert(a==b,path..": different value");return end
 for k,v in pairs(a) do equal(v,b[k],path.."."..tostring(k)) end
 for k in pairs(b) do assert(a[k]~=nil,path..": unexpected key "..tostring(k)) end
end
local native=read(assert(arg[1],"native template path required"))
local track=read("content/lightrail_fenced.street_template.lua")
assert(track.description.name=="LR_TRACK_NAME")
assert(track.description.description=="LR_TRACK_DESC")
assert(track.menuCategory.categories[1].order==9002)
equal(track.defaultEdgeDecorations,{
 {"mrnickert_ultimate_metro::/lightrail_fence.edge",false},
 {"mrnickert_ultimate_metro::/lightrail_fence.edge",true},
},"both exterior edges")
assert(track.description.icon=="mrnickert_ultimate_metro::/ui/lightrail_fenced.tga")
assert(track.description.previewIcon=="mrnickert_ultimate_metro::/ui/lightrail_fenced_preview.tga")
track.description.icon=native.description.icon
track.description.previewIcon=native.description.previewIcon
track.description.name=native.description.name
track.description.description=native.description.description
track.menuCategory.categories[1].order=native.menuCategory.categories[1].order
track.defaultEdgeDecorations=nil
equal(track,native,"native traffic, geometry, costs and materials")
local edge=read("content/lightrail_fence.edge.lua")
assert(edge.length==1.6 and edge.stretch and edge.snapMode=="Side")
assert(edge.verticalAlignment=="Shear" and edge.offset>=0)
assert(edge.cost.price==0 and edge.maintenance.runningCosts==0)
assert(not edge.preventParcels and #edge.menuCategory.categories==0)
equal(edge.incompatibleTags,{"tunnel"},"no tunnel fences")
for _,value in pairs(edge.modifiers) do assert(value==0) end
assert(edge.repModel=="mrnickert_ultimate_metro::/lightrail_fence.mdl")
local model=read("content/lightrail_fence.mdl")
assert(next(model.metadata)==nil)
assert(model.boundingInfo.bbMax[3]==1.3568 and #model.lods==3)
for _,lod in ipairs(model.lods) do
 local n=lod.node
 -- The source fence is long along Y. Edge repeat direction is X, as shown
 -- by the perpendicular-panel regression in the first in-game test.
 local t=n.transf
 local function point(x,y,z)
  return {t[1]*x+t[5]*y+t[9]*z+t[13],t[2]*x+t[6]*y+t[10]*z+t[14],t[3]*x+t[7]*y+t[11]*z+t[15]}
 end
 local a,b=point(0,-2,0),point(0,2,0)
 assert(math.abs(math.abs(b[1]-a[1])-edge.length)<1e-6)
 assert(math.abs(b[2]-a[2])<1e-6, "fence must run along edge, not across it")
 local top=point(0,0,3.392)
 assert(math.abs(top[3]-1.3568)<1e-6)
 -- All transformed native bounds must fit the wrapper's rotated bounds.
 for _,x in ipairs({-0.0657591,0.0675269}) do
  for _,y in ipairs({-2.03296,2.0105}) do
   for _,z in ipairs({-3.00359,3.392}) do
    local p=point(x,y,z)
    for k=1,3 do
     assert(p[k]>=model.boundingInfo.bbMin[k]-1e-6 and p[k]<=model.boundingInfo.bbMax[k]+1e-6)
    end
   end
  end
 end
 assert(#n.children==1)
 local child=n.children[1]
 assert(child.mesh:match("^::/assets/buildings/ind/fences/msh/fence_metal_4m_"))
 assert(#child.materials==2)
 for _,material in ipairs(child.materials) do
  assert(material:match("^::/assets/buildings/ind/mat/"))
 end
end
print("PASS: fenced track matches native tram traffic/layout exactly; two visual exterior fences, no added costs or modifiers.")
