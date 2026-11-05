local function main()
local path='../underground-lightrail-cost-rebalance/work/mod.script.lua'
local f=io.open(path,'r')
if not f then print('SKIP: optional compiled vanilla cost-mod fixture unavailable');return end
f:close()
local modifiers={}
local env=setmetatable({addModifier=function(kind,fn)modifiers[kind]=fn end,log={warning=function()end}},{__index=_G})
local costMod=assert(loadfile(path,'t',env))();costMod.runFn(nil,{}, {})
for _,name in ipairs({'mrnickert_ultimate_metro::/light_rail_station.script.lua','mrnickert_ultimate_metro::/underground_terminus.script.lua'})do
 local original=function()return {maintenanceCost=30000,cost=900000}end
 local resource={updateFn=original};modifiers.loadScript(name,resource)
 assert(resource.updateFn==original and resource.updateFn().maintenanceCost==30000,'Vanilla rebalance must not reduce ULR a second time')
end
local vanilla={updateFn=function()return{maintenanceCost=150000,cost=900000}end}
modifiers.loadScript('::/stations/street/underground_station/underground_station.script.lua',vanilla)
assert(vanilla.updateFn().maintenanceCost==30000 and vanilla.updateFn().cost==900000)
local descriptor={description={attributes={maintenanceCost={20000,30000}}}}
modifiers.loadConstruction('mrnickert_ultimate_metro::/light_rail_station.con.lua',descriptor)
assert(descriptor.description.attributes.maintenanceCost[1]==20000 and descriptor.description.attributes.maintenanceCost[2]==30000)
print('PASS: unchanged vanilla cost mod preserves ULR prices and menu range, while matching its vanilla target to the new ULR base')
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),'\n');os.exit(1)end
