-- GUI callback stays independent of world/construction helpers.
function data()
 return {
  checkInterchangeLevelFn=function(capture,params)
   return (tonumber((params or {}).levelCount) or 2)>=capture.level and "Enabled" or "Hidden"
  end,
  checkTurnbackFn=function(_capture,params)
   return tonumber((params or {}).stationType)==1 and "Enabled" or "Disabled"
  end,
  checkDepthFn=function(_capture,params)
   return tonumber((params or {}).placement)==1 and "Enabled" or "Hidden"
  end,
  checkFenceFn=function(_capture,params)
   return tonumber((params or {}).placement)==1 and "Disabled" or "Enabled"
  end,
 }
end
