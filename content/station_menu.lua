-- Lightweight public helper: safe in resource-description loading contexts.
local M={}
function M.getMenuCategory(order)
 if order~=nil and not (type(order)=="number" and order==order and order>=0 and order<math.huge and order%1==0) then
  error("Ultimate Light Rail API v1: menu order must be a nonnegative integer",2)
 end
 return {categories={{category="ulr_stations",filterCategories={"passenger","station"},order=order or 1000}}}
end
return M
