local react=ug_require "::/gui/main/react.lua"
local baseBar=ug_require "::/gui/game_bar/game_bar.tl"
local baseWindow=ug_require "::/gui/construction/construction.tl"
local previewBar=ug_require "mrnickert_ulr_ui_preview::/gui/native_bar.lua"
local previewWindow=ug_require "mrnickert_ulr_ui_preview::/gui/native_construction.lua"
return {doReplaceFn=function(replacementApi)
 replacementApi.ReplaceRecipe(baseBar.GameBar,previewBar.GameBar)
 replacementApi.ReplaceRecipe(baseWindow,previewWindow)
end}
