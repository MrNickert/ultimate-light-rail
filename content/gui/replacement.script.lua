function data()
 return {doReplaceFn=function(replacementApi)
  local baseBar=ug_require "::/gui/game_bar/game_bar.tl"
  local baseWindow=ug_require "::/gui/construction/construction.tl"
  local lightRailBar=ug_require "mrnickert_ultimate_metro::/gui/native_bar.lua"
  local lightRailWindow=ug_require "mrnickert_ultimate_metro::/gui/native_construction.lua"
  replacementApi.ReplaceRecipe(baseBar.GameBar,lightRailBar.GameBar)
  replacementApi.ReplaceRecipe(baseWindow,lightRailWindow)
 end}
end
