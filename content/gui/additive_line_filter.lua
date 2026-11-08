-- Add one Lines filter to the native controls. Only carrier lists created by
-- this filter take the extra path through the native selection predicates.
local M = {}
local installed = false
local traced = {}

local function traceOnce(key, message)
 if traced[key] then return end
 traced[key] = true
 log.message('[ULR UI] Light Rail line filter: ' .. message)
end
local filterKey = 'ulrOnly'
local namespace = 'mrnickert_ultimate_metro'
local coreStations = {
 light_rail_station = true,
 underground_interchange = true,
 aboveground_interchange = true,
 mixed_interchange = true,
 underground_interchange_four_test = true,
 underground_terminus = true,
 through_station = true,
 twin_terminus = true,
}

local function copy(source)
 local result = {}
 for key, value in pairs(source) do result[key] = value end
 return result
end

local function isLightRailConstruction(fileName)
 if type(fileName) ~= 'string' then return false end
 local mod, resource = fileName:match('^([^:]+)::/?([^/]+)%.con')
 if mod == namespace and coreStations[resource] then return true end

 local rep = api.res.constructionRep
 local index = rep.find(fileName)
 local desc = index and index >= 0 and rep.get(index)
 local menu = desc and desc.menuCategory
 for _, category in ipairs(menu and menu.categories or {}) do
  if category.category == 'ulr_stations' then return true end
 end
 return false
end

local function isLightRailLine(entity)
 local engine, components = api.engine, api.type.ComponentType
 if not engine.entityExists(entity) then return false end
 local line = engine.getComponent(entity, components.LINE)
 if not line then return false end
 for _, stop in ipairs(line.stops) do
  local group = engine.getComponent(stop.stationGroup, components.STATION_GROUP)
  local station = group and group.stations and type(stop.station) == 'number' and group.stations[stop.station + 1]
  if station then
   local owner = engine.system.streetConnectorSystem.getConstructionEntityForStation(station)
   if owner and engine.entityExists(owner) then
    local construction = engine.getComponent(owner, components.CONSTRUCTION)
    if construction and isLightRailConstruction(construction.fileName) then return true end
   end
  end
 end
 return false
end

-- The extra visual slot is translated to a named flag. The game only receives
-- its original indices when computing its own transport mode selection.
local function extendControls(nativeFilter, slot, categories, kind, oldState, transform, ...)
 local choices = copy(categories)
 table.insert(choices, slot, {
  imageFile = 'mrnickert_ultimate_metro::/gui/light_rail_line_filter.tga',
  tooltip = _("ULR_SHOW_LIGHT_RAIL_LINES"),
  carrier = categories[slot - 1].carrier,
 })
 local function visualState(native)
  local state = copy(native)
  state.category = {}
  for i = 1, #categories do
   state.category[i < slot and i or i + 1] = native.category[i]
  end
  state.category[slot] = native.category[filterKey]
  return state
 end
 return nativeFilter(choices, kind, function()
  return visualState(oldState())
 end, function(change)
  transform(function(current)
   local nextState = change(visualState(current))
   local visual = nextState.category
   nextState.category = copy(current.category)
   for i = 1, #categories do
    nextState.category[i] = visual[i < slot and i or i + 1]
   end
   nextState.category[filterKey] = visual[slot] and true or nil
   return nextState
  end)
 end, ...)
end

function M.install()
 if installed then return true end
 local react = ug_require '::/gui/main/react.lua'
 local stats = ug_require '::/gui/statistics/statistics_react_util.tl'
 local lines = ug_require '::/gui/line_vehicle_mgmt/line_util.tl'
 local native = api.engine.util.line
 local tram = api.type['enum'].Carrier.TRAM
 local createFilter = stats.createCarrierCategoryFilter
 local getCarriers = stats.getCarrierFilterFromCategories
 local depotMatches = stats.areCarriersContainedInTransportModes
 local lineMatches = lines.filterLine
 local compatible = native.isLineCompatibleWithAnyCarrier
 local dependencies = {
  { 'react.getCurrentRecipeName', react.getCurrentRecipeName },
  { 'statistics.createCarrierCategoryFilter', createFilter },
  { 'statistics.getCarrierFilterFromCategories', getCarriers },
  { 'statistics.areCarriersContainedInTransportModes', depotMatches },
  { 'line_util.filterLine', lineMatches },
  { 'engine.util.line.isLineCompatibleWithAnyCarrier', compatible, true },
  { 'streetConnectorSystem.getConstructionEntityForStation', api.engine.system.streetConnectorSystem.getConstructionEntityForStation, true },
 }
 local missing = {}
 for _, dependency in ipairs(dependencies) do
  local name, value, engineBinding = table.unpack(dependency)
  local valueType = type(value)
  -- TF3 also exports native functions as callable tables. Their metatable
  -- is managed by the game, so only accept tables for known engine bindings.
  if valueType ~= 'function' and not (engineBinding and valueType == 'table') then
   missing[#missing + 1] = name .. ' (' .. valueType .. ')'
  end
 end
 if #missing > 0 then return false, 'missing native helpers: ' .. table.concat(missing, ', ') end

 local marked = setmetatable({}, {__mode = 'k'})
 local function filterLine(original, carriers, entity, ...)
  local hasNativeSelection = marked[carriers]
  if hasNativeSelection == nil then return original(carriers, entity, ...) end
  return isLightRailLine(entity) and (not hasNativeSelection or original(carriers, entity, ...))
 end

 -- The stock table and bulk-selection code call different predicates. Only
 -- marked Lua lists are intercepted, leaving every other caller untouched.
 local function compatibleWithFilter(entity, carriers, ...)
  return filterLine(function(selection, id, ...)
   return compatible(id, selection, ...)
  end, carriers, entity, ...)
 end
 local function filterLineRow(carriers, entity, ...)
  return filterLine(lineMatches, carriers, entity, ...)
 end
 local function filterDepot(modes, carriers, ...)
  if marked[carriers] ~= nil then return false end
  return depotMatches(modes, carriers, ...)
 end
 local function resolveCarriers(categories, active, ...)
  if not (active and active[filterKey]) then return getCarriers(categories, active, ...) end
  local nativeActive = copy(active)
  nativeActive[filterKey] = nil
  local carriers = getCarriers(categories, nativeActive, ...)
  local selection = carriers and copy(carriers) or {}
  marked[selection] = carriers ~= nil
  return selection
 end
 local function createControls(categories, kind, oldState, transform, ...)
  local inLineManager = false
  if kind == 'Lines' then
   local ok, name = pcall(react.getCurrentRecipeName)
   traceOnce('scope-' .. tostring(name), 'Lines controls called from ' .. tostring(name))
   inLineManager = ok and name == 'LineManagerActionButtons'
  end
  if inLineManager then
   for i, category in ipairs(categories) do
    if category.carrier == tram then
     traceOnce('button', 'added to the native Lines controls')
     return extendControls(createFilter, i + 1, categories, kind, oldState, transform, ...)
    end
   end
  end
  return createFilter(categories, kind, oldState, transform, ...)
 end
 -- Roll back earlier hooks if a later export cannot be wrapped. In particular,
 -- a list-only filter would leave the stock Select All action out of sync.
 local hooks = {
  {native, 'isLineCompatibleWithAnyCarrier', compatible, compatibleWithFilter},
  {lines, 'filterLine', lineMatches, filterLineRow},
  {stats, 'areCarriersContainedInTransportModes', depotMatches, filterDepot},
  {stats, 'getCarrierFilterFromCategories', getCarriers, resolveCarriers},
  {stats, 'createCarrierCategoryFilter', createFilter, createControls},
 }
 for index, hook in ipairs(hooks) do
  local target, key, _, wrapper = table.unpack(hook)
  local ok, reason = pcall(function()
   target[key] = wrapper
   assert(target[key] == wrapper, 'export did not retain the wrapper')
  end)
  if not ok then
   for previous = index, 1, -1 do
    local object, field, original, replacement = table.unpack(hooks[previous])
    if object[field] == replacement then object[field] = original end
   end
   return false, 'cannot wrap ' .. key .. ': ' .. tostring(reason)
  end
 end
 installed = true
 return true
end
return M
