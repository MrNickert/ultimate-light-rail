local function main()
 local function resource(path)
  local env=setmetatable({_ = function(k)return k end},{__index=_G})
  assert(loadfile(path,"t",env))();return env.data()
 end
 local station=resource("content/mode_probe.street_template.lua")
 local link=resource("content/lightrail_test.street_template.lua")
 assert(link.menuCategory.categories[1].category=="roads_small","same native tram construction category")
 assert(link.description.name=="UM_LIGHTRAIL_TRACK_NAME","distinct test resource name")
 link.menuCategory=station.menuCategory;link.description=station.description
 local function equal(a,b)
  if type(a)~=type(b) then return false end
  if type(a)~="table" then return a==b end
  for k,v in pairs(a) do if not equal(v,b[k]) then return false end end
  for k in pairs(b) do if a[k]==nil then return false end end
  return true
 end
 assert(equal(station,link),"only display and build-menu fields differ from measured station profile")
 assert(link.roadType=="STREET" and #link.laneConfigs==1,"tram basis and one matching lane retained")
 print("PASS: buildable link matches station simulation profile exactly. Native network connections, line operation and vehicle reversal still require testing.")
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),"\n");os.exit(1) end
