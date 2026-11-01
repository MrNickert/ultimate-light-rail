-- New prototype construction; vanilla resources are not modified.
function data()
    return {
        availability = { yearFrom = 0, yearTo = 0 },
        description = {
            name = _("UM_TWIN_TERMINUS_NAME"),
            description = _("UM_TWIN_TERMINUS_DESC"),
            icon = "::/stations/street/small_stops/small_new.tga",
            previewIcon = "::/stations/street/small_stops/small_new_preview.tga",
            attributes = { cost = {120000, -1}, maintenanceCost = {20000, -1} },
            cargoTypeSet = { cargoClassesIncluded = {"PASSENGERS"}, cargoClassesExcluded = {},
                cargoTypesIncluded = {}, cargoTypesExcluded = {} },
        },
        menuCategory = { categories = {{ category = "road_buildings",
            filterCategories = {"passenger", "station"}, order = 1015 }} },
        params = {{key="crossover",name=_("UM_CROSSOVER"),values={_("UM_SWITCH_OFF"),_("UM_SWITCH_ON")},defaultIndex=2}},
        updateScript = { fileName = "mrnickert_ultimate_metro::/twin_terminus.script@updateFn" },
        configureHudIconsScript = {
            fileName = "::/gui/construction/construction_desc_hud_icons.script@configureStationHudIconsFn",
            params = {cargo = false},
        },
    }
end
