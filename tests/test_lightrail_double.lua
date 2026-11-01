local function main()
 local function resource(path)
  local env=setmetatable({_ = function(k)return k end},{__index=_G})
  assert(loadfile(path,"t",env))();return env.data()
 end
 local single=resource("content/lightrail_test.street_template.lua")
 local double=resource("content/lightrail_double.street_template.lua")
 local lanes=double.laneConfigs
 assert(#lanes==2 and lanes[1].offset<0 and lanes[2].offset>0,"two distinct physical lane positions, not coincident reverse curves")
 assert(lanes[1].offset==-0.25 and lanes[2].offset==0.25,"native double-tram offsets")
 assert(lanes[1].forward==false and lanes[2].forward==true,"native opposing logical orientations")
 for _,lane in ipairs(lanes) do
  assert(lane.height==single.laneConfigs[1].height and lane.speed==single.laneConfigs[1].speed and lane.width==single.laneConfigs[1].width,"preserve proven lane dimensions and speed")
  local modes={};for _,mode in ipairs(lane.transportModes) do modes[mode]=true end
  assert(modes.TRAM and modes.ELECTRIC_TRAM and modes.TRAM_TRACK and modes.ELECTRIC_TRAM_TRACK,"both lanes retain all measured tram modes")
 end
 assert(double.menuCategory.categories[1].category==single.menuCategory.categories[1].category,"same tram construction category")
 assert(double.description.name=="UM_LIGHTRAIL_DOUBLE_NAME","distinct selectable double profile")
 double.laneConfigs=single.laneConfigs;double.menuCategory=single.menuCategory;double.description=single.description
 local function equal(a,b)
  if type(a)~=type(b) then return false end
  if type(a)~="table" then return a==b end
  for k,v in pairs(a) do if not equal(v,b[k]) then return false end end
  for k in pairs(b) do if a[k]==nil then return false end end
  return true
 end
 assert(equal(single,double),"only lane topology, display and menu differ from working single track")
 print("PASS: native separated double lanes, measured mode support and preserved baseline fields. New routing and track use require native tests.")
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),"\n");os.exit(1) end
