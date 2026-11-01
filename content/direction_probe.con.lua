-- Research fixture, not an operational station.
function data()
 return {
  availability={yearFrom=0,yearTo=0},
  description={name=_("UM_DIRECTION_PROBE_NAME"),description=_("UM_DIRECTION_PROBE_DESC"),
   icon="::/stations/street/small_stops/small_new.tga",
   previewIcon="::/stations/street/small_stops/small_new_preview.tga"},
  menuCategory={categories={{category="road_buildings",filterCategories={"passenger","station"},order=1013}}},
  params={},updateScript={fileName="mrnickert_ultimate_metro::/direction_probe.script@updateFn"},
 }
end
