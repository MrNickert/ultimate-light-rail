-- One new resource ID; legacy construction IDs remain available to saved games.
function data()
 return {
  availability={yearFrom=0,yearTo=0},
  description={name=_("LR_STATION_NAME"),description=_("LR_STATION_DESC"),
   icon="mrnickert_ultimate_metro::/ui/metro_terminus.tga",
   previewIcon="mrnickert_ultimate_metro::/ui/metro_terminus_preview.tga",
   attributes={cost={120000,900000},maintenanceCost={20000,180000}},
   cargoTypeSet={cargoClassesIncluded={"PASSENGERS"},cargoClassesExcluded={},cargoTypesIncluded={},cargoTypesExcluded={}}},
  menuCategory={categories={{category="road_buildings",filterCategories={"passenger","station"},order=1015}}},
  params={
   {key="placement",name=_("LR_STATION_PLACEMENT"),values={_("LR_STATION_SURFACE"),_("LR_STATION_UNDERGROUND")},
    defaultIndex=1,uiType="Button",displayMode="Horizontal"},
   {key="stationType",name=_("LR_STATION_TYPE"),values={_("LR_STATION_THROUGH"),_("LR_STATION_TERMINUS")},
    defaultIndex=2,uiType="Button",displayMode="Horizontal"},
   {key="fence",name=_("LR_STATION_FENCE"),tooltip=_("LR_STATION_FENCE_TOOLTIP"),
    values={_("LR_STATION_NO"),_("LR_STATION_YES")},defaultIndex=2,uiType="Button",displayMode="Horizontal",
    checkEnabledScript={fileName="mrnickert_ultimate_metro::/station_menu.script@checkFenceFn",params={}}},
  },
  updateScript={fileName="mrnickert_ultimate_metro::/light_rail_station.script@updateFn"},
  configureLayerScript={fileName="::/gui/construction/construction_desc_layers.script@configureDefaultLayerFn",params={heightmapContours=true}},
  configureHudIconsScript={fileName="::/gui/construction/construction_desc_hud_icons.script@configureStationHudIconsFn",params={cargo=false}},
 }
end
