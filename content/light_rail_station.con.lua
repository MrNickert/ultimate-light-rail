local stationApi=require "mrnickert_ultimate_metro::/station_menu.lua"
local levels=require "mrnickert_ultimate_metro::/underground_levels.lua"
-- One new resource ID; legacy construction IDs remain available to saved games.
function data()
 local depths={}
 for i=1,levels.count do depths[i]=levels.trackZ(-i).." m" end
 return {
  availability={yearFrom=1925,yearTo=0},
  description={name=_("LR_STATION_NAME"),description=_("LR_STATION_DESC"),
   icon="mrnickert_ultimate_metro::/ui/light_rail_station.tga",
   previewIcon="mrnickert_ultimate_metro::/ui/light_rail_station_preview.tga",
   attributes={cost={120000,900000},maintenanceCost={20000,30000}},
   cargoTypeSet={cargoClassesIncluded={"PASSENGERS"},cargoClassesExcluded={},cargoTypesIncluded={},cargoTypesExcluded={}}},
  menuCategory=stationApi.getMenuCategory(1015),
  params={
   {key="placement",group="ulr_location",name=_("LR_STATION_PLACEMENT"),values={_("LR_STATION_UNDERGROUND"),_("LR_STATION_SURFACE"),_("LR_STATION_ELEVATED")},
    tooltips={_("LR_STATION_UNDERGROUND_TOOLTIP"),_("LR_STATION_SURFACE_TOOLTIP"),_("LR_STATION_ELEVATED_TOOLTIP")},
    defaultIndex=2,uiType="Button",displayMode="Vertical"},
   {key="stationType",group="ulr_station",name=_("LR_STATION_TYPE"),values={_("LR_STATION_THROUGH"),_("LR_STATION_TERMINUS")},
    defaultIndex=2,uiType="Button",displayMode="Horizontal"},
   {key="platformLength",group="ulr_station",name=_("LR_STATION_LENGTH"),tooltip=_("LR_STATION_LENGTH_TOOLTIP"),values={"40 m","60 m","80 m","100 m","120 m"},
    defaultIndex=3,uiType="Button",displayMode="Horizontal"},
   {key="fence",group="ulr_fences",name=_("LR_STATION_FENCE"),tooltip=_("LR_STATION_FENCE_TOOLTIP"),
    values={_("LR_STATION_NO"),_("LR_STATION_YES")},defaultIndex=2,uiType="Button",displayMode="Horizontal",
    checkEnabledScript={fileName="mrnickert_ultimate_metro::/station_menu.script@checkFenceFn",params={}}},
   {key="turnback",group="ulr_station",name=_("LR_STATION_TURNBACK"),tooltip=_("LR_STATION_TURNBACK_TOOLTIP"),
    values={_("LR_STATION_NO"),_("LR_STATION_YES")},defaultIndex=1,uiType="Button",displayMode="Horizontal",
    checkEnabledScript={fileName="mrnickert_ultimate_metro::/station_menu.script@checkTurnbackFn",params={}}},
   {key="depth",group="ulr_location",name=_("LR_STATION_DEPTH"),values=depths,
    defaultIndex=1,uiType="Button",displayMode="Horizontal",
    checkEnabledScript={fileName="mrnickert_ultimate_metro::/station_menu.script@checkDepthFn",params={}}},
   {key="ulrPlatformAccess",group="ulr_station",name=_("LR_STATION_PLATFORM_ACCESS"),
    values={_("LR_STATION_UNDERPASS"),_("LR_STATION_CROSSING")},defaultIndex=1,uiType="Button",displayMode="Horizontal",
    checkEnabledScript={fileName="mrnickert_ultimate_metro::/station_menu.script@checkPlatformAccessFn",params={}}},
   {key="ulrStreetAlignment",group="ulr_location",name=_("LR_STATION_STREET_ALIGNMENT"),
    values={_("LR_STATION_STREET_PARALLEL"),_("LR_STATION_STREET_PERPENDICULAR")},defaultIndex=1,uiType="Button",displayMode="Horizontal",
    checkEnabledScript={fileName="mrnickert_ultimate_metro::/station_menu.script@checkStreetAlignmentFn",params={}}},
  },
  updateScript={fileName="mrnickert_ultimate_metro::/light_rail_station.script@updateFn"},
  configureLayerScript={fileName="::/gui/construction/construction_desc_layers.script@configureDefaultLayerFn",params={heightmapContours=true}},
  configureHudIconsScript={fileName="::/gui/construction/construction_desc_hud_icons.script@configureStationHudIconsFn",params={cargo=false}},
 }
end
