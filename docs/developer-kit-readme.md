# Ultimate Light Rail Developer Kit

**Core 1.0.0 · revision 53 · Station API v1**

This package contains documentation, a standalone example mod and reference declarations. Install the core mod separately. Do not activate the developer kit itself in the game.

## API compatibility commitment

Updates and extensions within API v1 remain backward compatible with its documented public contract. Existing conforming v1 add-ons will continue to work without a rewrite for each core update. Any breaking changes will be introduced in a new API version alongside v1. The v1 entry point and contract will remain supported; existing add-ons will not be migrated automatically. Core release numbers and API versions are independent. Read `docs/compatibility.md` for the complete policy.

## Getting started

1. Read `docs/asset-kit-v1.md` for dimensions and supported components.
2. Copy `example/` into your own mod folder. Change the mod ID, visible names and every reference to the example namespace `ulr_contract_example`.
3. Declare Ultimate Light Rail revision 49 as a required dependency with `loadBefore=true` and `optional=false`.
4. Use `station_menu.lua.getMenuCategory()` in your `.con.lua`. Your station will appear in the shared Light Rail menu.
5. Call `station_api_v1.lua.buildStation()` from your update script and supply your own 20m models.
6. Test short and long platforms, both station types, stair clearance, boarding, crossing movements and save/reload.

The example mod contains a configurable 20m component kit and a fixed design using asset roles. Use the component kit as the starting point for new designs. Both examples demonstrate the shared menu integration.

## Package contents

- `docs/asset-kit-v1.md`: component choices, model dimensions and fixed parts.
- `docs/station-api-v1.md`: API, dependency, construction description and asset roles.
- `docs/compatibility.md`: public API stability and versioning policy.
- `example/`: the complete optional example mod.
- `reference/`: model declarations and the concrete standard kit; no copies of native meshes or textures.

Platform and canopy modules are exactly 20m long. Platform width, floor height, two tracks, entrances and stairs are fixed. The underground hall cannot be customised with component models. Models must respect reference profiles and clear routes; schema validation does not inspect every mesh or collider automatically.

The bundled example stations start in 1925, matching the standard stations and modern native tram track. Availability is declared in each construction description; custom asset mods choose their own dates. This does not change the API v1 build contract or its minimum required revision.

## Visual references

The kit also includes `docs/component-kit-in-game.png` with the real independent example and component choices, and `docs/api-integration-reference.png` with menu/build reference code. `reference/api-presentation-snippets.lua` provides copyable text for those integration examples; use the complete example mod as the runnable starting point. These are documentation panels, not additional asset types or API capabilities.
