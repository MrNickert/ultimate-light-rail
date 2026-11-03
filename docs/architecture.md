# Architecture — Ultimate Light Rail 1.0.0

## Runtime

`light_rail_station.con.lua` describes the construction menu and settings. Its update script translates selections into named values and calls `station_api_v1.buildStation()`. The public API validates the contract; `station_layout_builder.lua` dispatches to the surface, underground or elevated builder. `station_components.lua` applies the visual kit without changing transport geometry.

`station_standard_kit.lua` selects explicit 20m models for bundled designs. `station_menu.lua` provides a lightweight, standalone category helper for construction descriptions. External asset mods use the same public helpers.

## Public API stability

The documented v1 API and model interface remain backward compatible across updates and extensions. Breaking changes require a new, separately versioned API alongside v1. Internal builders and GUI recipes are implementation details, not extension points. See the [compatibility policy](compatibility.md).

## UI

The core registers a native `react-replacement-config`. The script supplies `data().doReplaceFn` and replaces the GameBar and ConstructionListWindow recipes. The existing Construction tool remains responsible for building; the adapter uses its descriptor from `_react.tools.Construction`.

`content/gui/catalog.lua` collects the native tram depot, the custom track and constructions in the `ulr_stations` category. One combined category retains the native search field and hides category tabs. The native tram depot also remains in its regular menu. Catalogue filtering does not modify engine resources or save objects.

`scripts/build_ui.py` derives adapters and styles from the installed GUI sources. Recipes and animations receive unique names; imports explicitly target native or core namespaces. The package includes generated Lua and source hashes. Internal UI integration and source anchors need checking after game updates. Mods replacing the same recipes may conflict.

## Build

Generate the GUI and transparent 30×30 menu icon before packaging. `package.py` uses an explicit runtime file list, checks local resources and translations and writes only the core mod. The example mod and developer kit have separate ZIPs. Test files are not included in the core package.
