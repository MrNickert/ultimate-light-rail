-- Native tram_new traffic/layout data; only name, menu order and fences differ.
function data()
return { 
		availability = {
			yearFrom = 1925,
			yearTo = 0,
			notifyWhenAvailable = false,
		},
		borderGroundTex = "::/infrastructure/street/shared/street_border.gtex",
		cost = 120,
        -- Native edge decorations: one on each OUTER side of the double track.
        defaultEdgeDecorations = {
            { "mrnickert_ultimate_metro::/lightrail_fence.edge", false },
            { "mrnickert_ultimate_metro::/lightrail_fence.edge", true },
        },
		country = true,
		description = { 
			description = _("LR_TRACK_DESC"),
			icon = "::/infrastructure/street/tram/tram_new.tga",
			name = _("LR_TRACK_NAME"),
			previewIcon = "::/infrastructure/street/tram/tram_new_preview.tga",
		},
		emissions = { 
			noise = 0,
			pollution = 0,
			pollutionRadius = 0,
			radius = 0,
		},
		fillGroundTex = "::/infrastructure/street/shared/street_fill.gtex",
		laneConfigs = {
			{ 
				forward = false,
				height = 0,
				offset = -0.25,
				speed = 27.77777862548828125,
				transportModes = { "TRAM", "ELECTRIC_TRAM", },
				width = 5.5,
			},
			{ 
				forward = true,
				height = 0,
				offset = 0.25,
				speed = 27.77777862548828125,
				transportModes = { "TRAM", "ELECTRIC_TRAM", },
				width = 5.5,
			},
		},
		maintenanceCost = 20,
		menuCategory = { 
			categories = {
				{ 
					category = "roads_small",
					filterCategories = { },
					order = 9002,
				},
				-- { 
				-- 	category = "road_tools",
				-- 	filterCategories = { },
				-- 	order = 9002,
				-- },
			},
		},
		modifiers = { 
			maxSpeedModifier = 0,
			noiseModifier = 0,
			pollutionModifier = 0,
		},
		priority = 100,
		roadType = "STREET",
		sidewalkFillGroundTex = "::/infrastructure/street/shared/street_sidewalk_fill.gtex",
		streetStyle = "::/infrastructure/street/tram/tram_new.street",
		transportModesStreet = { "TRAM", "ELECTRIC_TRAM", },
		builderAudioRes = "::/gui/construction/sound/buildoze_street.builder_audio",
	}
end
