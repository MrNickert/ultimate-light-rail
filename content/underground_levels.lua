local stationLevels=require "mrnickert_ultimate_metro::/station_levels.lua"
local levels={count=stationLevels.undergroundCount}

function levels.trackZ(level)
 if stationLevels.placement(level)=="underground" then return stationLevels.trackZ(level) end
end

function levels.offset(level)
 return levels.trackZ(level)-levels.trackZ(-1)
end

return levels
