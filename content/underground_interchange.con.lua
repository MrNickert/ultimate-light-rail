local menu=require "mrnickert_ultimate_metro::/station_menu.lua"
function data()
 local params={{key="levelCount",name=_("LR_INTERCHANGE_LEVEL_COUNT"),
  values={"1","2","3","4"},defaultIndex=2,uiType="Button",displayMode="Horizontal"}}
 local labels={_("LR_INTERCHANGE_ANGLE_1"),_("LR_INTERCHANGE_ANGLE_2"),
  _("LR_INTERCHANGE_ANGLE_3"),_("LR_INTERCHANGE_ANGLE_4")}
 for i=1,4 do
  local group="ulr_interchange_level_"..i
  local enabled={fileName="mrnickert_ultimate_metro::/station_menu.script@checkInterchangeLevelFn",params={level=i}}
  params[#params+1]={key="levelAngle"..i,group=group,name=labels[i],
   values={"0°","45°","90°","135°"},defaultIndex=({1,3,2,4})[i],uiType="Button",
   displayMode="Horizontal",checkEnabledScript=enabled}
  params[#params+1]={key="levelLength"..i,group=group,name=_("LR_STATION_LENGTH"),
   values={"40 m","60 m","80 m","100 m","120 m"},defaultIndex=3,uiType="Button",
   displayMode="Horizontal",checkEnabledScript=enabled}
 end
 return {
  undergroundView=true,
  availability={yearFrom=1925,yearTo=0},
  description={name=_("LR_INTERCHANGE_NAME"),description=_("LR_INTERCHANGE_DESC"),
   icon="mrnickert_ultimate_metro::/ui/metro_underground_terminus.tga",
   previewIcon="",
   attributes={cost={900000,3600000},maintenanceCost={30000,120000}},
   cargoTypeSet={cargoClassesIncluded={"PASSENGERS"},cargoClassesExcluded={},cargoTypesIncluded={},cargoTypesExcluded={}}},
  menuCategory=menu.getMenuCategory(1020),
  params=params,
  updateScript={fileName="mrnickert_ultimate_metro::/underground_interchange.script@updateFn"},
  configureLayerScript={fileName="::/gui/construction/construction_desc_layers.script@configureDefaultLayerFn",params={heightmapContours=true}},
  configureHudIconsScript={fileName="::/gui/construction/construction_desc_hud_icons.script@configureStationHudIconsFn",params={cargo=false}},
 }
end
