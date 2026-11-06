# Station API v1 — Ultimate Light Rail 1.1.0

The public API builds tram-based passenger stations. The core owns geometry, the transport network, terminals, entrances and pedestrian routes; a design supplies visual components.

## Compatibility commitment

Updates and extensions within API v1 remain backward compatible with its documented public contract. Existing conforming v1 add-ons will continue to work without being rewritten for each core update. New v1 features are additive and optional for existing callers.

If a breaking change is necessary, it will be introduced in a new, explicitly versioned API alongside v1. The v1 module and contract will remain available and supported. Existing callers will not be silently switched to new behaviour or forced to migrate. Core release versions and API versions are independent. See the [compatibility policy](compatibility.md) for the complete commitment and scope.

## Dependency

Include this in your own `mod.json`:

```json
"dependencies": [{
  "mod": {"modId": "mrnickert_ultimate_metro", "revisionMin": 49, "revisionMax": -1},
  "modInfo": {"displayName": "Ultimate Light Rail"},
  "loadBefore": true,
  "optional": false
}]
```

The minimum revision identifies the required feature set; it is not an API version. Leaving `revisionMax=-1` allows later compatible core revisions.

## Construction description and shared menu

Use the lightweight menu helper in your `.con.lua`; it does not load station builders:

```lua
local menu = require "mrnickert_ultimate_metro::/station_menu.lua"
function data()
 return {
  availability={yearFrom=1925,yearTo=0},
  description={name="My Light Rail Station",description="My station design.",
   icon="my_mod::/station.tga"},
  menuCategory=menu.getMenuCategory(1100),
  params={},
  updateScript={fileName="my_mod::/station.script@updateFn"},
 }
end
```

`getMenuCategory(order)` returns a fresh table with the shared `ulr_stations` category and the `passenger` and `station` filters. `order` is optional, defaults to 1000 and must be a nonnegative integer. The same helper is available as `station_api_v1.getMenuCategory`. Prefer the lightweight module in resource descriptions. The menu recognises the category regardless of your mod ID; do not modify the core. Calling `buildStation()` alone does not register a menu item.

Availability belongs to the construction description, not to `buildStation`. Bundled stations and examples use 1925 to match the native modern tram track. Creators choose their own `yearFrom` and `yearTo`; the API does not impose an introduction year on third-party designs.

## Update script

```lua
local station = require "mrnickert_ultimate_metro::/station_api_v1.lua"
function data()
 return {updateFn=function(capture,params)
  return station.buildStation({
   apiVersion=1, placement="surface", stationType="through",
   platformLength=80, platformTracks=2, fence=true,
   design={apiVersion=1,id="my_design",components={
    platform={model="my_mod::/platform20.mdl",moduleLength=20},
    canopy={model="my_mod::/roof20.mdl",moduleLength=20},
    shelter=false, trees=false, planters=false,
   }},
  },capture,params)
 end}
end
```

The return value is directly usable as the construction update result. `capture` and `params` are optional tables; the API does not mutate caller-owned tables.

## Station fields

| Field | Contract |
| --- | --- |
| `apiVersion` | Required; exactly 1 |
| `placement` | Required: `surface`, `underground`, `elevated` |
| `stationType` | Required: `through`, `terminus` |
| `platformLength` | Required: 40, 60, 80, 100 or 120 metres |
| `platformTracks` | Optional, defaults to 2; only 2 is accepted |
| `fence` | Optional boolean; defaults to true, effectively false underground |
| `design` | Optional; omitting it uses the standard kit |

A terminus includes one crossover. A through station adds two crossovers when Turnback is enabled. Locations are named values, not menu indices. Unknown fields and invalid values produce an API error.

## Designs and helpers

A design contains `apiVersion=1`, a lowercase `id` and exactly one of `components` or `assets`. Prefer `components` for new designs; the [component guide](asset-kit-v1.md) describes standard/custom/none choices and all model dimensions.

- `getContract()`: module length, platform dimensions, supported components and fixed layout responsibilities.
- `getDefaultKit()`: fresh context-dependent default selections.
- `getDefaultKit(placement)`: the concrete standard surface/elevated kit; an empty component kit for the fixed underground hall.
- `getDefaultDesign()`: a fresh standard configuration using asset roles.

Model references are mod-qualified: `my_mod::/model.mdl` or a native `::/model.mdl`. Do not supply callbacks, custom transforms or transport metadata in a design.

## Asset roles

As an alternative to components, `assets` supports replacement of these roles. Missing roles retain their standard model. The core preserves all transforms, including scaling; use this form for visual replacements matching the exact reference profile.

| Role | Reference model, prefixed with `mrnickert_ultimate_metro::/` unless stated otherwise |
| --- | --- |
| `platformSurface` | `surface_platform.mdl` |
| `headSurface` | `surface_head_tile.mdl` |
| `shelter` | native `::/stations/street/small_stops/small_new.mdl` |
| `elevatedRoof` | `elevated_platform_roof.mdl` |
| `elevatedEntranceBench` | `elevated_entrance.mdl` |
| `entrancePaving` | `elevated_paving.mdl` |

A role applies only where the builder places that model. The platform role uses local x=0..40m, y=-2.5..2.5m with its reference floor around z=1.1m before core transforms. The terminus forecourt uses x=-5..0m, y=-5..5m. The entrance pavement is a local 3×3m plane at z=0. Preserve the origin, clearance and complete reference profile. Use `components` for unscaled 20m modules.

## Boundaries

API v1 supports exactly two tracks, fixed platform width and floor height, fixed entrances/stairs and the specified lengths. The underground hall is a fixed assembly. The API validates schemas and model paths; creators must check external meshes and colliders in the game.

These fixed model interfaces and supported public calls are covered by the compatibility policy. Internal builder modules and generated UI recipes are not public extension points. Bug fixes and improvements must preserve the documented v1 contract; changes that cannot do so require a new API version.

## Turnback

With core revision 58 or later, pass `turnback = true` for a through station at any placement. This adds a 30 m scissors crossover at each end while retaining both external connections. The option defaults to false. Use a vehicle that fits the platform when reversing, and select terminals or waypoints if the line needs a specific track.
