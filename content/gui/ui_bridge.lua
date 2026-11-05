-- Narrow engine/UI integration helpers. No station or simulation changes.
local M={}
local seen={}
function M.trace(key,message)
 if not seen[key] then seen[key]=true; print('[ULR UI] '..message) end
end
function M.findCategory(categories,id)
 local found
 for index,category in ipairs(categories or {}) do
  if category.id==id then
   if found then return nil,'duplicate category: '..id end
   found=index
  end
 end
 return found,found and nil or ('missing category: '..tostring(id))
end
function M.addButton(params)
 if type(params)~='table' or type(params.buttonData)~='table' then return params,false end
 local hasRoad=false
 local railIndex
 for index,button in ipairs(params.buttonData) do
  if button.id=='menu.construction.light_rail' then return params,false end
  if button.id=='menu.construction.road' then hasRoad=true end
  if button.id=='menu.construction.rail' then railIndex=index end
 end
 if not hasRoad or not railIndex then return params,false end
 local result={};for k,v in pairs(params)do result[k]=v end
 local buttons={};for index,button in ipairs(params.buttonData)do buttons[index]=button end
 table.insert(buttons,railIndex,{
  gameCtx=buttons[railIndex].gameCtx,toolVariant='light_rail',
  id='menu.construction.light_rail',categoryId='light_rail',
  iconPath='mrnickert_ultimate_metro::/gui/light_rail.tga',tooltip=_("ULR_UI_MENU"),
 })
 result.buttonData=buttons
 return result,true
end
-- Copy catalogue containers before the existing collector groups our resources.
function M.copyMenus(menus)
 local result={}
 for menu,entries in pairs(menus) do
  local copy={};result[menu]=copy
  for index,entry in ipairs(entries)do
   local item={};for k,v in pairs(entry)do item[k]=v end
   local definitions={};for i,definition in ipairs(entry[2])do definitions[i]=definition end
   item[2]=definitions;copy[index]=item
  end
 end
 return result
end
function M.isCategoryList(value)
 if type(value)~='table' then return false end
 local road,rail=false,false
 for _,item in ipairs(value)do
  if type(item)~='table' or type(item.id)~='string' or (type(item.getSublists)~='function' and type(item.definition)~='table') then return false end
  road=road or item.id=='road';rail=rail or item.id=='rail'
 end
 return road and rail
end
function M.appendCategory(categories,entries)
 if M.findCategory(categories,'light_rail') then return categories end
 if type(entries)~='table' then
  M.trace('catalogue-unavailable','Cannot add category: native catalogue was not collected')
  return categories
 end
 local definitions={}
 for _,entry in ipairs(entries)do
  for _,definition in ipairs(entry[2])do definitions[#definitions+1]=definition end
 end
 local sublists={
  {name=_("ULR_UI_SEARCH"),tabId='menu.construction.light_rail.search',isSearchTab=true,getDefinitions=function()return definitions end},
  {name=_("ULR_UI_MENU"),icon='mrnickert_ultimate_metro::/gui/light_rail.tga',tabId='menu.construction.light_rail.ulr_all',getDefinitions=function()return definitions end},
 }
 categories[#categories+1]={id='light_rail',name='LIGHT_RAIL',dynamic=false,
  styleClass='construction-menu-category',getSublists=function()return sublists end}
 M.trace('category-added','Light Rail category appended to existing native categories; resources='..tostring(#definitions))
 return categories
end
return M
