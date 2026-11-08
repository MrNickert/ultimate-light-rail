local function engineBinding(fn)
 return setmetatable({}, {__call = function(_, ...) return fn(...) end, __metatable = false})
end

local function harness(readOnly)
 local currentRecipe = 'LineManagerActionButtons'
 local stats = {
  createCarrierCategoryFilter = function(categories, kind, get, transform, extra)
   return {categories = categories, kind = kind, get = get, transform = transform, extra = extra}
  end,
  getCarrierFilterFromCategories = function(categories, active)
   local result
   for index, enabled in pairs(active or {}) do
    if enabled then
     assert(type(index) == 'number' and categories[index])
     result = result or {}
     result[#result + 1] = categories[index].carrier
    end
   end
   return result
  end,
  areCarriersContainedInTransportModes = function() return true end,
 }
 local lines = {filterLine = function(carriers, entity) return carriers[1] == 'tram' and entity ~= 5 end}
 local carrierApi = {isLineCompatibleWithAnyCarrier = engineBinding(function(entity, carriers, flag)
  assert(flag == false)
  return lines.filterLine(carriers, entity)
 end)}
 if readOnly then
  carrierApi = setmetatable({}, {__index = carrierApi, __newindex = function() error('read-only') end})
 end
 local byComponent = {
  LINE = {
   [1] = {stops = {{stationGroup = 10, station = 0}}},
   [2] = {stops = {{stationGroup = 10, station = 1}}},
   [3] = {stops = {{stationGroup = 12, station = 0}}},
   [4] = {stops = {}},
   [5] = {stops = {{stationGroup = 10, station = 0}}},
   [6] = {stops = {{stationGroup = 10, station = 2}}},
  },
  STATION_GROUP = {[10] = {stations = {20, 21}}, [12] = {stations = {22}}},
  CONSTRUCTION = {
   [30] = {fileName = 'mrnickert_ultimate_metro::/underground_interchange.con'},
   [31] = {fileName = '::/ordinary_tram_stop.con'},
   [32] = {fileName = 'addon::/station.con.lua'},
  },
 }
 local react = {getCurrentRecipeName = function() return currentRecipe end}
 local env = setmetatable({
  _ = function(key) return key end,
  log = {message = function() end},
  ug_require = function(path)
   if path:find('statistics_react_util', 1, true) then return stats end
   if path:find('line_util', 1, true) then return lines end
   return react
  end,
  api = {
   type = {['enum'] = {Carrier = {TRAM = 'tram'}}, ComponentType = {
    LINE = 'LINE', STATION_GROUP = 'STATION_GROUP', CONSTRUCTION = 'CONSTRUCTION',
   }},
   engine = {
    util = {line = carrierApi},
    system = {streetConnectorSystem = {getConstructionEntityForStation = engineBinding(function(entity) return entity + 10 end)}},
    entityExists = function(entity) return entity ~= 9 end,
    getComponent = function(entity, component) return byComponent[component][entity] end,
   },
   res = {constructionRep = {
    find = function(file) return file == 'addon::/station.con.lua' and 0 or -1 end,
    get = function(index) assert(index == 0); return {menuCategory = {categories = {{category = 'ulr_stations'}}}} end,
   }},
  },
 }, {__index = _G})
 local adapter = assert(loadfile('content/gui/additive_line_filter.lua', 't', env))()
 return adapter, stats, lines, carrierApi, function(name) currentRecipe = name end
end

local adapter, stats, lines, carrierApi, setRecipe = harness()
assert(adapter.install() and adapter.install())
local categories = {{carrier = 'road'}, {carrier = 'foreign'}, {carrier = 'tram'}, {carrier = 'rail'}}
local state = {category = {[4] = true}, search = 'City', onlyVisible = true}
local function get() return state end
local function transform(change) state = change(state) end
local function draw(kind) return stats.createCarrierCategoryFilter(categories, kind, get, transform, 'foreign argument') end
local rendered = draw('Lines')
assert(#categories == 4 and #rendered.categories == 5 and rendered.categories[3] == categories[3])
assert(rendered.categories[4].imageFile == 'mrnickert_ultimate_metro::/gui/light_rail_line_filter.tga')
assert(rendered.get().category[5] and rendered.extra == 'foreign argument')
rendered.transform(function(next) next.category[4] = true; return next end)
assert(state.category.ulrOnly and state.category[4] and state.search == 'City' and state.onlyVisible)
local selection = stats.getCarrierFilterFromCategories(categories, state.category)
assert(not lines.filterLine(selection, 1), 'Light Rail combines with the native Rail filter')
rendered.transform(function(next)
 next.category[5] = false
 next.onlyVisible = false
 return next
end)
assert(state.category.ulrOnly and not state.category[4] and not state.onlyVisible and state.search == 'City')
selection = stats.getCarrierFilterFromCategories(categories, state.category)
for _, entity in ipairs({1, 3, 5}) do
 assert(lines.filterLine(selection, entity))
 assert(carrierApi.isLineCompatibleWithAnyCarrier(entity, selection, false))
end
for _, entity in ipairs({2, 4, 6, 9}) do
 assert(not lines.filterLine(selection, entity))
 assert(not carrierApi.isLineCompatibleWithAnyCarrier(entity, selection, false))
end
assert(not stats.areCarriersContainedInTransportModes({}, selection))
assert(lines.filterLine({'tram'}, 2))
assert(carrierApi.isLineCompatibleWithAnyCarrier(2, {'tram'}, false))
assert(stats.areCarriersContainedInTransportModes({}, {'tram'}))
rendered.transform(function(next) next.category[4] = false; next.category[3] = true; return next end)
assert(not state.category.ulrOnly and state.category[3])
assert(stats.getCarrierFilterFromCategories(categories, state.category)[1] == 'tram')
setRecipe('Unrelated')
assert(draw('Lines').categories == categories)
setRecipe('LineManagerActionButtons')
assert(draw('Vehicles').categories == categories)
assert(stats.createCarrierCategoryFilter({{carrier = 'road'}}, 'Lines', get, transform).categories[2] == nil)

local disabled, untouchedStats = harness(true)
local original = untouchedStats.createCarrierCategoryFilter
local installed, reason = disabled.install()
assert(not installed and reason:find('cannot wrap isLineCompatibleWithAnyCarrier', 1, true))
assert(untouchedStats.createCarrierCategoryFilter == original)
print('PASS: callable engine bindings, additive line controls, foreign categories, light rail station detection, list and bulk-selection predicates, and read-only API fallback.')
