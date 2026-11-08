local menu = require "mrnickert_ultimate_metro::/station_menu.lua"

function data()
 return {
  availability={yearFrom=1925,yearTo=0},
  description={name="Example Light Rail Interchange",description="Two connected Light Rail levels.",
   icon="mrnickert_ultimate_metro::/ui/light_rail_station.tga",previewIcon="",
   attributes={cost={396000,-1},maintenanceCost={44000,-1}},
   cargoTypeSet={cargoClassesIncluded={"PASSENGERS"},cargoClassesExcluded={},cargoTypesIncluded={},cargoTypesExcluded={}}},
  menuCategory=menu.getMenuCategory(1100),
  params={},
  updateScript={fileName="my_light_rail_mod::/station.script@updateFn"},
  configureLayerScript={fileName="::/gui/construction/construction_desc_layers.script@configureDefaultLayerFn",params={heightmapContours=true}},
  configureHudIconsScript={fileName="::/gui/construction/construction_desc_hud_icons.script@configureStationHudIconsFn",params={cargo=false}},
 }
end
