-- Additive initialization using the engine's pre-UI setup phase.
-- No ReplaceRecipe call for GameBar or ConstructionListWindow.
function data()
 return {doReplaceFn=function(_replacementApi)
  local bar=ug_require 'mrnickert_ultimate_metro::/gui/additive_bar.lua'
  local construction=ug_require 'mrnickert_ultimate_metro::/gui/additive_construction.lua'
  bar.install()
  construction.install()
 end}
end
