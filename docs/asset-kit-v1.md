# Component Kit v1 — Ultimate Light Rail 1.0.0

For creators of visual station designs. Requires core revision 49. Bundled stations use the same public build API and component rules.

Updates and extensions within API v1 remain backward compatible with the documented contract. Breaking changes will use a new API version alongside v1, leaving existing conforming v1 add-ons supported. Read the [compatibility policy](compatibility.md).

## Responsibilities

Creators supply their own mod, construction description, update script and any models replacing the standard appearance. Use `station_menu.lua.getMenuCategory()` to join the shared Light Rail menu. See the [API and example code](station-api-v1.md).

The core supplies two platform tracks, terminus crossovers, stopping positions, terminals, entrances, stairs, pedestrian routes, structural supports and safety features. Do not copy this logic into an asset mod.

## Three choices per component

| Value | Meaning |
| --- | --- |
| Omitted or `"default"` | Context-dependent standard component |
| `false` | Omit an optional component |
| `{model="my_mod::/model.mdl"}` | Use a custom model at the fixed positions |

`platform` and `canopy` also require `moduleLength=20`. A platform cannot be omitted. `true`, bare model strings, callbacks and custom positioning fields are not supported.

```lua
design={apiVersion=1,id="my_station",components={
 platform={model="my_mod::/platform20.mdl",moduleLength=20},
 canopy={model="my_mod::/roof20.mdl",moduleLength=20},
 shelter=false, trees=false, planters=false,
 benches="default", bins="default", lights="default",
}}
```

## Components

| Key | Placement |
| --- | --- |
| `platform` | Straight 20m platform sections outside fixed stair and infill sections |
| `shelter` | Fixed shelter positions; elevated stations provide positions for a custom shelter |
| `canopy` | 20m canopy modules, both surface and elevated |
| `trees` | Surface terminus forecourt or elevated entrance plaza |
| `planters` | The same fixed plazas |
| `benches` | Platform benches and the elevated entrance bench |
| `bins` | Fixed platform bin positions |
| `lights` | Fixed platform light positions |

A custom bench can optionally specify `entranceModel="my_mod::/entrance_bench.mdl"` for a separate elevated entrance model. Without it, the entrance uses the same custom bench model.

`trees=false` also removes tree beds; a custom tree retains the bed. `planters=false` also removes associated shrubs; a custom planter retains those shrubs and must fit them. Catenary, safety fences, structural pillars and canopy supports remain core-owned.

Defaults depend on context: surface stations have no canopy by default; elevated stations do. Choose an explicit canopy model table for a surface canopy. Selecting a component does not create new positions: a surface through station, for example, has no terminus forecourt for trees.

## Required 20m modules

Ordinary straight platform and canopy models are exactly **20m long**. The core repeats custom models without length, width or height scaling. `moduleLength=20` is the creator's declaration; the API does not measure external meshes automatically.

The core replaces only complete 20m sections in the available build area. Fixed stairs, the native underpass, narrow strips next to openings and short connection/end pieces remain core-owned. A short through station can consist entirely of fixed pieces, so a custom platform model may not be used there. These pieces cannot be styled individually in v1.

Canopies cover the usable platform length 0..L in whole 20m modules. Elevated crossover/end zones use fixed canopy infills. The core places supports safely, keeps shelters clear and moves surface catenary poles outside the canopy; contact wires retain their positions.

The supplied reference wrappers use native 40m visuals internally at half length. Independently authored 20m assets do not need this internal scaling.

## Model dimensions

| Component | Local model space |
| --- | --- |
| Platform | x=0..20m, y=-2.5..2.5m; walking floor z=0.25m; origin at track/deck level |
| Canopy | x=0..20m; reference width approximately 5.29m; roof z=3.1499..4.385m above the platform floor; origin at platform floor |
| Canopy supports | Supplied by the core; do not include fixed columns in the roof model |
| Shelter | Follow the origin and safe envelope of native `small_new.mdl` |
| Trees, planters, furniture | Follow reference poses and scales; no custom placement coordinates |

A reference roof may extend a few centimetres beyond its nominal length. Keep stairs, walking space, contact wires and canopy beams clear. Use appropriate colliders. Do not add transport providers, terminals or additional pedestrian/vehicle lanes to models.

## Fixed boundaries

- Two platform tracks; lengths 40/60/80/100/120m.
- Platform width 5m; walking floor 0.25m above local track/deck level.
- Fixed entrance, stair, underpass and route positions.
- Fully fixed underground hall: components may only be omitted or `"default"`. Custom models and `false` are rejected.

Platform height, additional tracks, free placement and alternative stair positions are not creator options in v1.

## Supplying and testing a mod

```text
my_station_mod/
  mod.json
  _metadata/modinfo.json
  content/
    station.con.lua
    station.script.lua
    platform20.mdl
    roof20.mdl
    ... custom meshes, materials and textures
```

Use your own mod ID and namespace. Declare the required core dependency on revision 49. Test with both mods enabled: menu discovery, short and long stations, through and terminus layouts, stair clearance, street/track connections, boarding, crossovers and save/reload. A valid schema does not prove that an arbitrary external model fits in the engine.
