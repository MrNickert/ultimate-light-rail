-- Augment the native category state; do not replace a window or render tree.
-- The two temporary helper wrappers exist only during this native callback.
local M={}
local installed=false
function M.install()
 if installed then return true end
 local react=ug_require '::/gui/main/react.lua'
 local util=ug_require '::/gui/construction/construction_react_util.tl'
 local nativeWindow=ug_require '::/gui/construction/construction.tl'
 local layout=ug_require 'mrnickert_ultimate_metro::/gui/native_construction.lua'
 local bridge=ug_require 'mrnickert_ultimate_metro::/gui/ui_bridge.lua'
 local catalog=ug_require 'mrnickert_ultimate_metro::/gui/catalog.lua'
 if not _react or not _react.recipes or type(util.getMenuCategories)~='function' then
  bridge.trace('construction-missing','Category integration skipped: native callback registry unavailable')
  return false
 end
 local windowId=react.GetRecipeId(nativeWindow)
 local contentId=windowId and windowId+layout.contentOffset
 local previous=contentId and _react.recipes[contentId]
 if type(previous)~='function' then
  bridge.trace('construction-layout','Category integration skipped: native content callback unavailable')
  return false
 end
 _react.recipes[contentId]=function(...)
  local originalState=react.useStateLazy
  local originalMenus=util.getMenuCategories
  local lightRailEntries
  util.getMenuCategories=function(...)
   local menus=catalog.inject(bridge.copyMenus(originalMenus(...)))
   lightRailEntries=menus.LIGHT_RAIL
   return menus
  end
  react.useStateLazy=function(generate)
   local state=originalState(function()
    local value=generate()
    if bridge.isCategoryList(value)then return bridge.appendCategory(value,lightRailEntries)end
    return value
   end)
   local categories=state:old()
   if bridge.isCategoryList(categories)then
    react.onEvent('ulrConstructionOpenCategory',function(_,request)
     local index,reason=bridge.findCategory(categories,request.categoryId)
     if not index then bridge.trace('category-missing',reason);return end
     bridge.trace('category-resolved','Resolved light_rail by name to current tab '..tostring(index))
     react.fireEvent(nil,'constructionMenuSetTab',{tabIndex=index,allowStacking=false})
    end)
    react.onEvent('constructionMenuCategoryEmpty',function(_,event)
     local category=categories[event.index]
     if category and category.id=='light_rail' then
      react.fireEvent(nil,'ulrConstructionCategoryAvailability',{categoryId='light_rail',empty=event.empty})
     end
    end)
   end
   return state
  end
  local result=table.pack(pcall(previous,...))
  -- Restore foreign/native helpers even if the native callback raises an error.
  react.useStateLazy=originalState
  util.getMenuCategories=originalMenus
  if not result[1]then error(result[2],0)end
  return table.unpack(result,2,result.n)
 end
 installed=true
 bridge.trace('construction-installed','Category adapter installed; native ConstructionListWindow retained')
 return true
end
return M
