-- GUI callback stays independent of world/construction helpers.
function data()
 return {
  checkTurnbackFn=function(_capture,params)
   return tonumber((params or {}).stationType)==1 and "Enabled" or "Disabled"
  end,
  checkFenceFn=function(_capture,params)
   return tonumber((params or {}).placement)==1 and "Disabled" or "Enabled"
  end,
 }
end
