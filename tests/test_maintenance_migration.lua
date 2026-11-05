local function main()
local checks=0
local function eq(a,b,label)assert(a==b,label..': '..tostring(a)..' ~= '..tostring(b));checks=checks+1 end
local function clone(value)
 if type(value)~='table'then return value end
 local copy={};for k,v in pairs(value)do copy[k]=clone(v)end;return copy
end
local function fixture(mode)
 local objects={}
 local function station(id,params,cost,path,owner)
  objects[id]={CONSTRUCTION={fileName=path or 'mrnickert_ultimate_metro::/light_rail_station.con.lua',params=params,stationMarker={keep=true}},
   PLAYER_OWNED={player=owner or 10},MAINTENANCE_COST={maintenanceCost=cost,accumulatedCost={keep=77}}}
 end
 station(1,nil,180000);objects[1].CONSTRUCTION.params_native={find=function(_,key)assert(key=='placement');return 1 end}
 station(2,{placement=2},180000);station(3,{placement=3},180000);station(4,{placement=1},30000)
 station(5,nil,150000,'::/stations/street/underground_station/underground_station.con.lua')
 station(6,{placement=1},180000,'another_author::/light_rail_station.con.lua')
 station(7,nil,180000,'mrnickert_ultimate_metro::underground_terminus.con.tl')
 station(8,{placement=1},42000);station(9,{placement=1},180000,nil,99);station(10,nil,180000)
 station(11,{placement=1},180000)
 station(12,{placement=1},180000);objects[12].CONSTRUCTION.params_native={find=function()return 2 end}
 station(13,{placement=1},180000);objects[13].CONSTRUCTION.params_native={find=function()error('unreadable native params')end}
 station(14,{placement='1'},180000);station(15,{placement=1},180000);objects[15].MAINTENANCE_COST=nil
 local commands,queue,messages={},{},{}
 local state={value={}}
 function state:get()return self.value end
 function state:set(value)self.value=value end
 local function apply(cmd)if objects[cmd.id]and objects[cmd.id].MAINTENANCE_COST then objects[cmd.id].MAINTENANCE_COST.maintenanceCost=cmd.amount end end
 api={engine={entityExists=function(id)return objects[id]~=nil end,
 getEntitiesWithComponent=function()local ids={};for id in pairs(objects)do ids[#ids+1]=id end;table.sort(ids);return ids end,
 getComponent=function(id,kind)return objects[id]and objects[id][kind]end,util={getPlayer=function()return 10 end}},
 type={ComponentType={CONSTRUCTION='CONSTRUCTION',PLAYER_OWNED='PLAYER_OWNED',MAINTENANCE_COST='MAINTENANCE_COST'}},
 cmd={debug={makeMaintenanceCostUpdateCmd=function(id,amount,reset)return{id=id,amount=amount,reset=reset}end},
 sendCommand=function(cmd,...)
  assert(select('#',...)==0,'No command callbacks are allowed in game scripts')
  if mode=='throw'then error('command rejected')end
  commands[#commands+1]=cmd
  if mode=='deferred'then queue[#queue+1]=cmd elseif mode~='no_change'then apply(cmd)end
 end}}
 log={message=function(s)messages[#messages+1]=s end,warning=function(s)messages[#messages+1]=s end}
 return {objects=objects,state=state,commands=commands,messages=messages,
 load=function()local env=setmetatable({},{__index=_G});assert(loadfile('content/maintenance_migration.script.lua','t',env))();return env.data()end,
 flush=function()while #queue>0 do apply(table.remove(queue,1))end end}
end
local f=fixture();local m=f.load();m.update({},f.state,0);eq(f.state.value.version,nil,'Paused game does not scan')
local originalConstruction=f.objects[1].CONSTRUCTION
m.update({},f.state,1);eq(#f.commands,1,'First eligible station submitted')
eq(f.commands[1].amount,30000,'Absolute target equals rebalanced vanilla base')
eq(f.commands[1].reset,false,'Accrued charges preserved')
eq(f.state.value.updated,0,'Command must be verified next tick')
for _=1,12 do m.update({},f.state,1)end
eq(f.state.value.completed,true,'Migration finishes')
eq(f.state.value.updated,4,'Only known owned underground stations adjusted')
eq(#f.commands,4,'One command per eligible station')
for _,id in ipairs({1,7,11,14})do eq(f.objects[id].MAINTENANCE_COST.maintenanceCost,30000,'Underground target for '..id)end
for _,id in ipairs({2,3,6,9,10,12,13})do eq(f.objects[id].MAINTENANCE_COST.maintenanceCost,180000,'Excluded station unchanged '..id)end
eq(f.objects[4].MAINTENANCE_COST.maintenanceCost,30000,'Already reduced unchanged')
eq(f.objects[5].MAINTENANCE_COST.maintenanceCost,150000,'Vanilla remains the cost mod responsibility')
eq(f.objects[8].MAINTENANCE_COST.maintenanceCost,42000,'Custom maintenance unchanged')
eq(f.objects[1].MAINTENANCE_COST.accumulatedCost.keep,77,'Accrual retained')
eq(f.objects[1].CONSTRUCTION,originalConstruction,'Construction component never rebuilt')
m=f.load();m.update({},f.state,1);eq(#f.commands,4,'Save reload does not repeat completed work')
f.state.value={};m=f.load();m.update({},f.state,1);eq(#f.commands,4,'Fresh state does not compound reductions')
f=fixture();m=f.load();m.update({},f.state,1);f.state.value=clone(f.state.value);m=f.load();m.update({},f.state,1)
eq(f.state.value.updated,1,'Saved pending verification resumes after reload')
eq(#f.commands,1,'Pending command is not resubmitted')
f=fixture('deferred');m=f.load();m.update({},f.state,1);f.flush();m.update({},f.state,1)
eq(f.state.value.updated,1,'Deferred engine command verified')
for _,mode in ipairs({'throw','no_change','missing_api'})do
 f=fixture(mode);if mode=='missing_api'then api.cmd.debug=nil end;m=f.load();m.update({},f.state,1);m.update({},f.state,1)
 eq(f.state.value.failed,true,'Failure stops safely: '..mode)
 local count=#f.commands;m.update({},f.state,1);eq(#f.commands,count,'No repeated failed commands: '..mode)
end
f=fixture();local factory=api.cmd.debug.makeMaintenanceCostUpdateCmd
api.cmd.debug.makeMaintenanceCostUpdateCmd=setmetatable({},{__call=function(_,...)return factory(...)end})
m=f.load();m.update({},f.state,1);m.update({},f.state,1);eq(f.state.value.updated,1,'Native callable object accepted')
f=fixture();m=f.load();m.update({},f.state,1);f.objects[7]=nil
for _=1,12 do m.update({},f.state,1)end
eq(f.state.value.skipped,1,'Demolished queued station skipped')
eq(f.state.value.updated,3,'Remaining candidates still updated')
f=fixture();m=f.load()
f.objects[2].MAINTENANCE_COST.maintenanceCost=20000
f.objects[3].MAINTENANCE_COST.maintenanceCost=20000
f.state.value={version=1,completed=true}
for _=1,14 do m.update({},f.state,1)end
eq(f.objects[2].MAINTENANCE_COST.maintenanceCost,20000,'Surface remains at the original base')
eq(f.objects[3].MAINTENANCE_COST.maintenanceCost,24000,'Existing elevated station increases once after v1 migration')
eq(f.state.value.updated,5,'Both eligible placements migrated')
f.state.value={};m=f.load();m.update({},f.state,1)
eq(#f.commands,5,'Rescan does not compound elevated maintenance')
local env={};assert(loadfile('content/maintenance_migration.gs.lua','t',env))()
eq(env.data().updateScript.fileName,'mrnickert_ultimate_metro::/maintenance_migration.script@update','Qualified migration script linkage')
print('PASS: '..checks..' maintenance migration checks; native params, ownership, exact baselines, saved progress, accrued charges and command failures')
end
local ok,err=pcall(main)
if not ok then io.stderr:write(tostring(err),'\n');os.exit(1)end
