-- Stable resource IDs and parameter indices preserve existing station instances.
function data()
    return {
        undergroundView = true,
        configureLayerScript = {fileName="::/gui/construction/construction_desc_layers.script@configureDefaultLayerFn", params={heightmapContours=true}},
        availability = { yearFrom = 0, yearTo = 0 },
        description = {
            name = _("METRO_UNDERGROUND_TERMINUS_NAME"),
            description = _("METRO_UNDERGROUND_TERMINUS_DESC"),
            icon = "mrnickert_ultimate_metro::/ui/metro_underground_terminus.tga",
            previewIcon = "mrnickert_ultimate_metro::/ui/metro_underground_terminus_preview.tga",
            attributes = { cost = {900000, -1}, maintenanceCost = {180000, -1} },
            cargoTypeSet = { cargoClassesIncluded = {"PASSENGERS"}, cargoClassesExcluded = {},
                cargoTypesIncluded = {}, cargoTypesExcluded = {} },
        },
        menuCategory = { categories = {{ category = "road_buildings",
            filterCategories = {"passenger", "station"}, order = 1016 }} },
        params = {{key="crossover",name=_("METRO_CROSSOVER"),values={_("METRO_NO_CROSSOVER"),_("METRO_WITH_CROSSOVER")},defaultIndex=2}},
        updateScript = { fileName = "mrnickert_ultimate_metro::/underground_terminus.script@updateFn" },
        configureHudIconsScript = {
            fileName = "::/gui/construction/construction_desc_hud_icons.script@configureStationHudIconsFn",
            params = {cargo = false},
        },
    }
end
