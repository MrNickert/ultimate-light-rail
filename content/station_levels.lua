-- Logical levels shared by single stations and interchanges.
local levels={undergroundCount=4}
local trackHeights={[-4]=-72,[-3]=-54,[-2]=-36,[-1]=-18,[0]=0,[1]=12}
function levels.trackZ(level)
 return trackHeights[level]
end
function levels.placement(level)
 if level==0 then return "surface" end
 if level==1 then return "elevated" end
 if trackHeights[level] then return "underground" end
end
return levels
