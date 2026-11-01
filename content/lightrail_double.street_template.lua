-- Derived from Urban Games street/tram/tram_new.street_template.lua; original game by Urban Games.
function data()
return {
		availability = {
			yearFrom = 1925,
			yearTo = 0,
			notifyWhenAvailable = false,
		},
		borderGroundTex = "::/infrastructure/street/shared/street_border.gtex",
		cost = 120,
		country = true,
		description = {
			description = _("UM_LIGHTRAIL_DOUBLE_DESC"),
			icon = "::/infrastructure/street/tram/tram_new.tga",
			name = _("UM_LIGHTRAIL_DOUBLE_NAME"),
			previewIcon = "::/infrastructure/street/tram/tram_new_preview.tga",
		},
		emissions = {
			noise = 0,
			pollution = 0,
			pollutionRadius = 0,
			radius = 0,
		},
		fillGroundTex = "::/infrastructure/street/shared/street_fill.gtex",
        -- Native double-tram spacing, with the measured mixed transport modes.
        -- Separate offsets avoid coincident reverse curves. Each lane may still
        -- be engine-bidirectional; per-direction use requires native route tests.
        laneConfigs = {
            {forward=false,height=0,offset=-0.25,speed=15,
                transportModes={"TRAM","ELECTRIC_TRAM","TRAM_TRACK","ELECTRIC_TRAM_TRACK"},width=5.5},
            {forward=true,height=0,offset=0.25,speed=15,
                transportModes={"TRAM","ELECTRIC_TRAM","TRAM_TRACK","ELECTRIC_TRAM_TRACK"},width=5.5},
        },
		maintenanceCost = 20,
		menuCategory = { categories = {{category="roads_small",filterCategories={},order=9003}} },
		modifiers = {
			maxSpeedModifier = 0,
			noiseModifier = 0,
			pollutionModifier = 0,
		},
		priority = 100,
		roadType = "STREET",
		sidewalkFillGroundTex = "::/infrastructure/street/shared/street_sidewalk_fill.gtex",
		streetStyle = "::/infrastructure/street/tram/tram_new.street",
		transportModesStreet = { "TRAM", "ELECTRIC_TRAM", "TRAM_TRACK", "ELECTRIC_TRAM_TRACK", },
		builderAudioRes = "::/gui/construction/sound/buildoze_street.builder_audio",
	}
end
