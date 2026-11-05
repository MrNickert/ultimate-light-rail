-- Add one button to the native group; preserve any previous recipe wrapper.
local M={}
local installed=false
function M.install()
 if installed then return true end
 local react=ug_require '::/gui/main/react.lua'
 local builtin=ug_require '::/gui/main/builtin.lua'
 local bar=ug_require '::/gui/game_bar/game_bar.tl'
 local layout=ug_require 'mrnickert_ultimate_metro::/gui/native_bar.lua'
 local bridge=ug_require 'mrnickert_ultimate_metro::/gui/ui_bridge.lua'
 if not _react or not _react.originalRecipeFn or not _react.recipeReplace then
  bridge.trace('registry-missing','Button integration skipped: native recipe registry unavailable')
  return false
 end
 local first=react.GetRecipeId(bar.MainRadialMenu)
 local last=react.GetRecipeId(bar.GameBar)
 if not first or not last or last-first~=layout.anchorSpan then
  bridge.trace('layout-mismatch','Button integration skipped: native recipe layout differs from build manifest')
  return false
 end
 local groupId=first+layout.groupOffset
 local buttonId=first+layout.buttonOffset
 local groupPrevious=_react.recipeReplace[groupId] or _react.originalRecipeFn[groupId]
 local buttonPrevious=_react.recipeReplace[buttonId] or _react.originalRecipeFn[buttonId]
 if type(groupPrevious)~='function' or type(buttonPrevious)~='function' then
  bridge.trace('recipe-missing','Button integration skipped: expected native button recipes unavailable')
  return false
 end
 local group=react.RegisterRecipe('ULRAdditiveConstructionButtonGroup',function(...)
  local args=table.pack(...)
  local nativeRef=react.useNodeRef()
  local forwarded={}
  for index=1,args.n do
   local value=args[index]
   local modified,added=bridge.addButton(value)
   args[index]=modified
   if added then bridge.trace('button-added','Light Rail button added to existing native group') end
   if type(value)=='table' and type(value.buttonData)=='table' then
    for _,button in ipairs(value.buttonData)do
     if button.iaForward and not forwarded[button.iaForward] then
      react.useInputAction(button.iaForward,react.iaForward(nativeRef))
      forwarded[button.iaForward]=true
     end
    end
   end
  end
  return builtin.BoxLayout{orientation=builtin.type.Orientation.Horizontal,
   children={groupPrevious(react.ref(nativeRef),table.unpack(args,1,args.n))}}
 end)
 local button=react.RegisterRecipe('ULRAdditiveConstructionButton',function(param)
  local stateEmpty=react.useState(false)
  react.onEvent('ulrConstructionCategoryAvailability',function(_,event)
   if event.categoryId=='light_rail' then stateEmpty:set(event.empty) end
  end)
  local show=function()
   bridge.trace('open-request','Requested construction category light_rail by name')
   api.gui.byId.setVisible('menu.construction.react',true)
   api.gui.fireReactEvent('ulrConstructionOpenCategory',{categoryId='light_rail'})
  end
  react.onEvent('openLightRail',function()show()end)
  local toolButtonRef=react.useNodeRef()
  react.useInputAction('ACTION_CLICK',react.iaForward(toolButtonRef))
  return builtin.BoxLayout{children={builtin.ToolButton(react.ref(toolButtonRef),{
   meta={id=param.id,tooltip=param.tooltip,enabled=not stateEmpty:old()},
   content=builtin.ImageView{path=param.iconPath,scaling=builtin.type.ImageViewScaling.AutoFit},
   toolName='Construction',toolVariant='light_rail',toolStack=param.gameCtx.toolStack,
   showFn=show,hideFn=function()react.fireEvent(nil,'closeConstructionWindow')end,
  })}}
 end)
 -- Two leaf slots only. No GameBar replacement and no unrelated recipe scan.
 _react.recipeReplace[groupId]=group
 _react.recipeReplace[buttonId]=function(...)
  local args=table.pack(...)
  local param=args[args.n]
  if type(param)=='table' and param.id=='menu.construction.light_rail' then return button(...) end
  return buttonPrevious(...)
 end
 installed=true
 bridge.trace('installed','Additive button hook installed; native GameBar retained; existing group wrapper='..tostring(react.GetRecipeName(groupPrevious) or 'native'))
 return true
end
return M
