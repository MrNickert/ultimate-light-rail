-- Native maintenance units, not a literal annual UI price.
local OLD=180000
local TARGET=30000
local VERSION=1
local PREFIX='mrnickert_ultimate_metro::'
local function nameOf(value)
 if type(value)~='string'then return ''end
 return (value:gsub('^::/?',''):gsub('^/',''):gsub('::/','::'):gsub('%.lua$',''):gsub('%.tl$',''))
end
local function underground(construction)
 local name=nameOf(construction.fileName)
 if name==PREFIX..'underground_terminus.con'then return true end
 if name~=PREFIX..'light_rail_station.con'then return false end
 local placement
 if construction.params_native then
  local ok,value=pcall(function()return construction.params_native:find('placement')end)
  if not ok then return false end
  placement=value
 elseif type(construction.params)=='table'then placement=construction.params.placement end
 return (type(placement)=='number'or type(placement)=='string')and tonumber(placement)==1
end
local function eligible(entity)
 if not api.engine.entityExists(entity)then return false end
 local construction=api.engine.getComponent(entity,api.type.ComponentType.CONSTRUCTION)
 if not construction or not underground(construction)then return false end
 local owner=api.engine.getComponent(entity,api.type.ComponentType.PLAYER_OWNED)
 if not owner or owner.player~=api.engine.util.getPlayer()then return false end
 local cost=api.engine.getComponent(entity,api.type.ComponentType.MAINTENANCE_COST)
 return cost~=nil and cost.maintenanceCost==OLD
end
local function message(text)log.message('[ULR maintenance] '..text)end
local function warning(text)log.warning('[ULR maintenance] '..text)end
function data()
 return {update=function(_,state,dt)
  if dt<=0 then return end
  local progress=state:get()
  if progress.version~=VERSION then
   local candidates={}
   for _,entity in ipairs(api.engine.getEntitiesWithComponent(api.type.ComponentType.CONSTRUCTION))do
    if eligible(entity)then candidates[#candidates+1]=entity end
   end
   progress={version=VERSION,candidates=candidates,cursor=1,updated=0,skipped=0,completed=false,failed=false,pending=-1}
   state:set(progress)
   message('Scan complete: '..tostring(#candidates)..' existing underground stations eligible')
  end
  if progress.completed or progress.failed then return end
  if progress.pending>=0 then
   local cost=api.engine.entityExists(progress.pending)and api.engine.getComponent(progress.pending,api.type.ComponentType.MAINTENANCE_COST)
   if not cost or cost.maintenanceCost~=TARGET then
    progress.failed=true
    warning('Stopped: maintenance verification failed for entity '..tostring(progress.pending))
   else
    progress.updated=progress.updated+1
    progress.cursor=progress.cursor+1
   end
   progress.pending=-1
   state:set(progress)
   return
  end
  if progress.cursor>#progress.candidates then
   progress.completed=true;state:set(progress)
   message('Complete: '..tostring(progress.updated)..' updated, '..tostring(progress.skipped)..' skipped')
   return
  end
  local entity=progress.candidates[progress.cursor]
  if not eligible(entity)then
   progress.skipped=progress.skipped+1;progress.cursor=progress.cursor+1;state:set(progress);return
  end
  local commandApi=api.cmd
  local factory=commandApi and commandApi.debug and commandApi.debug.makeMaintenanceCostUpdateCmd
  if not factory then
   progress.failed=true;state:set(progress);warning('Stopped: maintenance update command unavailable');return
  end
  progress.pending=entity;state:set(progress)
  local ok,err=pcall(function()
   -- No callback: game scripts reject them. false retains accrued charges.
   commandApi.sendCommand(factory(entity,TARGET,false))
  end)
  if not ok then
   progress.pending=-1;progress.failed=true;state:set(progress);warning('Stopped: '..tostring(err))
  end
 end}
end
