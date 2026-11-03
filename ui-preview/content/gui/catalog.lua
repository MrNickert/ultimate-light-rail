-- GUI definitions only. Never change engine resources, station data or routes.
local M={}
local core="mrnickert_ultimate_metro::/"
local example="ulr_contract_example::/"
local function kind(def,category)
 local name=def.resName or ""
 if name:find("/depots/road/tram_depot/tram_depot.con",1,true) then return "depot" end
 if name:find(core.."lightrail_fenced.street_template",1,true)==1 then return "track" end
 if name:find(core.."light_rail_station.con",1,true)==1 or name:find(example,1,true)==1 or category=="ulr_stations" or category=="ulr_all" then return "station" end
end
function M.inject(menus)
 local buckets={depot={},track={},station={}}
 local seen={depot={},track={},station={}}
 for _,categories in pairs(menus) do
  for _,entry in ipairs(categories) do
   local kept={}
   for _,def in ipairs(entry[2]) do
    local k=kind(def,entry[1].category)
    if k then
     local a=def.availability or {}
     local id=(def.resName or "").."|"..tostring(def.templateIndex or "").."|"..tostring(a.yearFrom or "").."|"..tostring(a.yearTo or "")
     if not seen[k][id] then
      seen[k][id]=true
      local clone={};for field,value in pairs(def) do clone[field]=value end
      buckets[k][#buckets[k]+1]=clone
     end
    end
    -- Native depots keep their ordinary menu entry. Only our track/stations
    -- and explicitly marked ULR stations leave other construction catalogues.
    if not k or k=="depot" then kept[#kept+1]=def end
   end
   entry[2]=kept
  end
 end
 -- A single native category automatically hides its category tab while
 -- retaining the normal search field and item availability/placement logic.
 local all={}
 for _,k in ipairs({"depot","track","station"}) do
  for _,def in ipairs(buckets[k]) do all[#all+1]=def end
 end
 menus.LIGHT_RAIL={
  {{category="ulr_all",menu="LIGHT_RAIL",name=_("ULR_UI_MENU"),order=100,
    icon="mrnickert_ulr_ui_preview::/gui/light_rail.tga"},all},
 }
 return menus
end
return M
