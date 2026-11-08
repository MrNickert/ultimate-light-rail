-- Additive initialization using the engine's pre-UI setup phase.
-- No ReplaceRecipe call for GameBar or ConstructionListWindow.
function data()
 return {doReplaceFn=function(_replacementApi)
  local bar=ug_require 'mrnickert_ultimate_metro::/gui/additive_bar.lua'
  local construction=ug_require 'mrnickert_ultimate_metro::/gui/additive_construction.lua'
  bar.install()
  construction.install()
  local ok, added, reason = pcall(function()
   return (ug_require 'mrnickert_ultimate_metro::/gui/additive_line_filter.lua').install()
  end)
  if not ok or not added then
   log.warning('[ULR UI] Light Rail line filter skipped: ' .. tostring(ok and reason or added))
  else
   log.message('[ULR UI] Light Rail line filter installed')
  end
 end}
end
