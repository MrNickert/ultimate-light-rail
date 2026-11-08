local menu=require "mrnickert_ultimate_metro::/station_menu.lua"
function data()
 return {
  availability={yearFrom=1925,yearTo=0},
  description={name=_("LR_ABOVEGROUND_INTERCHANGE_NAME"),description=_("LR_ABOVEGROUND_INTERCHANGE_DESC"),
   icon="mrnickert_ultimate_metro::/ui/light_rail_station.tga",previewIcon="",
   attributes={cost={396000},maintenanceCost={44000}},
   cargoTypeSet={cargoClassesIncluded={"PASSENGERS"},cargoClassesExcluded={},cargoTypesIncluded={},cargoTypesExcluded={}}},
  menuCategory=menu.getMenuCategory(1025),
  updateScript={fileName="mrnickert_ultimate_metro::/aboveground_interchange.script@updateFn"},
  configureLayerScript={fileName="::/gui/construction/construction_desc_layers.script@configureDefaultLayerFn",params={heightmapContours=true}},
  configureHudIconsScript={fileName="::/gui/construction/construction_desc_hud_icons.script@configureStationHudIconsFn",params={cargo=false}},
 }
end
