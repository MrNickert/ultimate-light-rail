-- New prototype construction; vanilla resources are not modified.
function data()
    return {
        availability = { yearFrom = 0, yearTo = 0 },
        description = {
            name = _("UM_SURFACE_STOP_NAME"),
            description = _("UM_SURFACE_STOP_DESC"),
            icon = "::/stations/street/small_stops/small_new.tga",
            previewIcon = "::/stations/street/small_stops/small_new_preview.tga",
            attributes = { cost = {30000, -1}, maintenanceCost = {5000, -1} },
            cargoTypeSet = { cargoClassesIncluded = {"PASSENGERS"}, cargoClassesExcluded = {},
                cargoTypesIncluded = {}, cargoTypesExcluded = {} },
        },
        menuCategory = { categories = {{ category = "road_buildings",
            filterCategories = {"passenger", "station"}, order = 1010 }} },
        params = {{ key = "platformLength", name = _("UM_LENGTH"),
            values = {"60 m", "80 m", "120 m"}, defaultIndex = 2 }},
        updateScript = { fileName = "mrnickert_ultimate_metro::/surface_stop.script@updateFn" },
        configureHudIconsScript = {
            fileName = "::/gui/construction/construction_desc_hud_icons.script@configureStationHudIconsFn",
            params = {cargo = false},
        },
    }
end
