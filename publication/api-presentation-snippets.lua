-- Construction description example
local menu = require
  "mrnickert_ultimate_metro::/station_menu.lua"

function data()
  return {
    availability = {yearFrom=1925, yearTo=0},
    description = {
      name = "Your Light Rail Station",
      description = "Your station design.",
      icon = "your_stations::/station.tga",
    },
    menuCategory = menu.getMenuCategory(1100),
    params = {},
    updateScript = {
      fileName =
        "your_stations::/station.script@updateFn",
    },
  }
end

-- Build call inside updateFn(capture, params)
local api = require
  "mrnickert_ultimate_metro::/station_api_v1.lua"

return api.buildStation({
  apiVersion = 1,
  placement = "elevated",
  stationType = "terminus",
  platformLength = 80,
  platformTracks = 2,
  fence = true,
}, capture, params)

-- Add design.components for custom visuals.
-- Ordinary platform / canopy modules: 20m.
-- Stairs and routes stay core-owned.
