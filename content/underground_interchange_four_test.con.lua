local menu=require "mrnickert_ultimate_metro::/station_menu.lua"
function data()
 return {
  undergroundView=true,
  availability={yearFrom=1925,yearTo=0},
  description={name=_("LR_INTERCHANGE_TEST_NAME"),description=_("LR_INTERCHANGE_TEST_DESC"),
   icon="mrnickert_ultimate_metro::/ui/metro_underground_terminus.tga",
   previewIcon="mrnickert_ultimate_metro::/ui/metro_underground_terminus_preview.tga",
   attributes={cost={31200000,-1},maintenanceCost={120000,-1}},
   cargoTypeSet={cargoClassesIncluded={"PASSENGERS"},cargoClassesExcluded={},cargoTypesIncluded={},cargoTypesExcluded={}}},
  menuCategory=menu.getMenuCategory(1021),
  params={},
  updateScript={fileName="mrnickert_ultimate_metro::/underground_interchange.script@updateFn",params={fourLevelTest=true}},
  configureLayerScript={fileName="::/gui/construction/construction_desc_layers.script@configureDefaultLayerFn",params={heightmapContours=true}},
  configureHudIconsScript={fileName="::/gui/construction/construction_desc_hud_icons.script@configureStationHudIconsFn",params={cargo=false}},
 }
end
