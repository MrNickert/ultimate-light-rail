-- Stable resource IDs and parameter indices preserve existing station instances.
function data()
    return {
        availability = { yearFrom = 0, yearTo = 0 },
        description = {
            name = _("METRO_THROUGH_NAME"),
            description = _("METRO_THROUGH_DESC"),
            icon = "::/stations/rail/modular_station/addon_platform_passenger_stairs_era_c.tga",
            previewIcon = "::/stations/rail/modular_station/addon_platform_passenger_stairs_era_c_preview.tga",
            attributes = { cost = {180000, -1}, maintenanceCost = {20000, -1} },
            cargoTypeSet = { cargoClassesIncluded = {"PASSENGERS"}, cargoClassesExcluded = {},
                cargoTypesIncluded = {}, cargoTypesExcluded = {} },
        },
        menuCategory = { categories = {{ category = "road_buildings",
            filterCategories = {"passenger", "station"}, order = 1017 }} },
        params = {},
        updateScript = { fileName = "mrnickert_ultimate_metro::/through_station.script@updateFn" },
        configureHudIconsScript = {
            fileName = "::/gui/construction/construction_desc_hud_icons.script@configureStationHudIconsFn",
            params = {},
        },
    }
end
