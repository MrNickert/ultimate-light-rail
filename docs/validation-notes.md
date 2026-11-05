# Release validation notes

The core's generated construction UI module must be loadable without a populated `_react.tools` registry. Tool resolution is deferred until a UI event needs to push or pop the native Construction tool. Local regression coverage exercises absent and empty registries as well as registered-tool startup.

## Native texture compression warnings

The Mod Hub may report four BC3/DXT5-versus-BC1/DXT1 recommendations:

| Mod model | Referenced native texture |
| --- | --- |
| `elevated_entrance.mdl` | `::/assets/buildings/res/mat/tex/assets_res_add_albo.dds` |
| `elevated_platform_roof.mdl` | `::/stations/rail/era_c/mat/tex/era_c_rail_station_perron_atlas_albo.dds` |
| `platform_roof20.mdl` | The same native canopy atlas |
| `tram_paving.mdl` | `::/infrastructure/street/tram/mat/tex/new_medium_tram_metal_gloss_ao.dds` |

These are native game resources referenced by model adapters. No replacement copies are distributed, and no base-game files are modified. They are compression recommendations, separate from Lua errors. The actual game validation report remains authoritative for upload readiness.
