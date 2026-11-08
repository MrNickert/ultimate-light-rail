local menu=require "mrnickert_ultimate_metro::/station_menu.lua"
function data()
 return {
  availability={yearFrom=1925,yearTo=0},
  description={name=_("LR_MIXED_INTERCHANGE_NAME"),description=_("LR_MIXED_INTERCHANGE_DESC"),
   icon="mrnickert_ultimate_metro::/ui/underground_interchange.tga",previewIcon="",
   attributes={cost={1296000,-1},maintenanceCost={74000,-1}},
   cargoTypeSet={cargoClassesIncluded={"PASSENGERS"},cargoClassesExcluded={},cargoTypesIncluded={},cargoTypesExcluded={}}},
  menuCategory=menu.getMenuCategory(1030),
  params={},
  updateScript={fileName="mrnickert_ultimate_metro::/mixed_interchange.script@updateFn"},
  configureLayerScript={fileName="::/gui/construction/construction_desc_layers.script@configureDefaultLayerFn",params={heightmapContours=true}},
  configureHudIconsScript={fileName="::/gui/construction/construction_desc_hud_icons.script@configureStationHudIconsFn",params={cargo=false}},
 }
end
