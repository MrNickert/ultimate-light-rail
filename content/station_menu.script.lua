-- GUI callback stays independent of world/construction helpers.
function data()
 return {
  checkFenceFn=function(_capture,params)
   return tonumber((params or {}).placement)==1 and "Disabled" or "Enabled"
  end,
 }
end
