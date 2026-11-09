-- Augment any construction window that uses the shared TF3 catalogue and state shape.
local M={}
local installed=false
function M.install()
 if installed then return true end
 local react=ug_require '::/gui/main/react.lua'
 local util=ug_require '::/gui/construction/construction_react_util.tl'
 local bridge=ug_require 'mrnickert_ultimate_metro::/gui/ui_bridge.lua'
 local catalog=ug_require 'mrnickert_ultimate_metro::/gui/catalog.lua'
 local originalState=react.useStateLazy
 if type(originalState)~='function' or type(util.getMenuCategories)~='function' then
  bridge.trace('construction-missing','Category integration skipped: shared construction helpers unavailable')
  return false
 end

 local categoryStates=setmetatable({},{__mode='k'})
 local active
 local function collectMenus(...)
  local scope=active
  local menus=catalog.inject(bridge.copyMenus(scope.getMenus(...)))
  scope.entries=menus.LIGHT_RAIL
  return menus
 end

 react.useStateLazy=function(generate)
  local state=originalState(function(...)
   local originalMenus=util.getMenuCategories
   local previous=active
   local scope={getMenus=originalMenus==collectMenus and previous.getMenus or originalMenus}
   active=scope
   util.getMenuCategories=collectMenus
   local ok,value=pcall(generate,...)
   util.getMenuCategories=originalMenus
   active=previous
   if not ok then error(value,0) end
   if scope.entries and bridge.isCategoryList(value) then
    bridge.appendCategory(value,scope.entries)
    categoryStates[value]=true
   end
   return value
  end)

  -- The same category list is returned on later renders without reinitializing.
  local categories=state:old()
  if categoryStates[categories] then
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
 installed=true
 bridge.trace('construction-installed','Category adapter installed on shared construction catalogue')
 return true
end
return M
