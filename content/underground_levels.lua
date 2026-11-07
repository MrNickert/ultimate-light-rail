local levels={count=4}

function levels.trackZ(level)
 if type(level)=="number" and level>=-levels.count and level<=-1 and level%1==0 then
  return 18*level
 end
end

function levels.offset(level)
 return levels.trackZ(level)-levels.trackZ(-1)
end

return levels
