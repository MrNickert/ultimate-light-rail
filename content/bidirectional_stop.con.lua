-- New prototype construction; vanilla resources are not modified.
function data()
    return {
        availability = { yearFrom = 0, yearTo = 0 },
        description = {
            name = _("UM_BIDIRECTIONAL_STOP_NAME"),
            description = _("UM_BIDIRECTIONAL_STOP_DESC"),
            icon = "::/stations/street/small_stops/small_new.tga",
            previewIcon = "::/stations/street/small_stops/small_new_preview.tga",
            attributes = { cost = {30000, -1}, maintenanceCost = {5000, -1} },
            cargoTypeSet = { cargoClassesIncluded = {"PASSENGERS"}, cargoClassesExcluded = {},
                cargoTypesIncluded = {}, cargoTypesExcluded = {} },
        },
        menuCategory = { categories = {{ category = "road_buildings",
            filterCategories = {"passenger", "station"}, order = 1014 }} },
        params = {},
        updateScript = { fileName = "mrnickert_ultimate_metro::/bidirectional_stop.script@updateFn" },
        configureHudIconsScript = {
            fileName = "::/gui/construction/construction_desc_hud_icons.script@configureStationHudIconsFn",
            params = {cargo = false},
        },
    }
end
