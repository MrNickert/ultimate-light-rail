# Architecture — Ultimate Light Rail 1.1.0

## Runtime

`light_rail_station.con.lua` describes the construction menu and settings. Its update script translates selections into named values and calls `station_api_v1.buildStation()`. The public API validates the contract; `station_layout_builder.lua` dispatches to the surface, underground or elevated builder. `station_components.lua` applies the visual kit without changing transport geometry.

`station_standard_kit.lua` selects explicit 20m models for bundled designs. `station_menu.lua` provides a lightweight, standalone category helper for construction descriptions. External asset mods use the same public helpers.

## Public API stability

The documented v1 API and model interface remain backward compatible across updates and extensions. Breaking changes require a new, separately versioned API alongside v1. Internal builders and GUI recipes are implementation details, not extension points. See the [compatibility policy](compatibility.md).

## UI

The core uses the native pre-UI setup phase to install small additive adapters. `GameBar` and `ConstructionListWindow` remain native. The button adapter calls existing wrappers through and inserts Light Rail beside Rail; the scoped construction adapter appends a category and restores helper functions after the native callback. Named routing resolves the category's current index rather than storing a fixed tab number. See [UI integration](ui-integration.md).

`content/gui/catalog.lua` collects the native tram depot, the custom track and constructions in `ulr_stations`. The native tram depot retains its ordinary menu entry. The GUI build generates checked native recipe-layout descriptors and source hashes, without copying the complete native renderers or styles. Engine-internal coupling is isolated and checked; arbitrary mods that bypass native recipes still require separate compatibility investigation.

## Maintenance

The shared underground builder sets maintenance to 30,000 builder units; elevated construction and maintenance costs are 120% of their surface equivalents. A single production game script performs the saved, owner- and baseline-checked maintenance migration for existing bundled underground and elevated stations. It sends only maintenance-component commands and preserves accrued charges. No station reconstruction or geometry changes are submitted. See [maintenance](maintenance.md).

## Build

Generate the GUI and transparent 30×30 menu icon before packaging. `package.py` uses an explicit runtime file list, checks local resources and translations and writes only the core mod. The example mod and developer kit have separate ZIPs. Test files are not included in the core package.

## Underground interchange

The native construction settings select one to four consecutive layers. Each active layer has an independent angle (0, 45, 90 or 135 degrees) and platform length (40, 60, 80, 100 or 120m). Track depths are fixed at 18m intervals. The construction update builds the geometry for the native placement preview from the current settings.

The core uses Station API v1 to build each underground through layer with Turnback. It centres and combines the layers into one station, with a single public street entrance and two stair flights between each adjacent pair of concourses. The default two-layer layout preserves the earlier fixed configuration. The separate four-level test resource remains loadable for existing saves.
