-- Preserve the public script ID used by existing saves.
local build = require "mrnickert_ultimate_metro::/terminus_util.lua"
function data() return {updateFn=build} end
