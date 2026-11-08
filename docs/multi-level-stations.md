# Multi-level stations in Station API v1

`buildInterchange()` is an additive feature in the current review checkout. The published core revision 73 (Ultimate Light Rail 1.2.2) predates it. Use the reviewed core locally to try the example. A minimum public core revision will be assigned when the feature ships. The existing single-station API remains backward compatible. Breaking changes require a new API version.

## Build a station from layers

Call `station_api_v1.lua.buildInterchange({apiVersion=1,layers={...}}, capture, params)` from the construction update script. It returns a normal TF3 construction result. Each layer is a two-track through station with Turnback at both ends. The core places the tracks, merges terminal references and track ends into one station, and connects the platforms to one pedestrian network with shared access. Layer order in the input does not affect terminal order. The core emits level `0`, then `1`, then underground levels from `-1` down. Each level contributes two terminals at 35 waiting passengers per 20 m per terminal.

| Layer field | Meaning |
| --- | --- |
| `level` | Required. A unique logical level from `-4` to `1`. |
| `platformLength` | 40, 60, 80, 100 or 120 metres. Defaults to 80. |
| `rotation` | Track axis in degrees in the construction frame, with values 0, 45, 90 or 135. Angles describe an axis modulo 180 degrees. |
| `offset` | `{x=number,y=number}` in metres. The origin is the centre of level `0` or, in an underground-only layout, level `-1`. With level `0`, the offset axes rotate with that layer. |
| `design` | Optional Station API v1 design for this layer. Defaults to the standard kit for its placement. Each layer can use a different design ID and different models. |
| `fence` | Optional approach-fence flag. Defaults to true above ground. Underground approaches use the native tunnel profile. |

See the [logical height table](station-api-v1.md#logical-levels) and [asset guide](asset-kit-v1.md) for dimensions. Supply different `components` kits for surface and elevated layers. For an underground layer, `assets.undergroundBench` and `assets.undergroundTicketMachine` replace the corresponding visual models. The underground hall, concourse, platform dimensions and stairs are fixed. Models must keep the reference origin, profile and pedestrian clearances.

## Supported arrangements

The schema requires at least two distinct layers. Underground levels start at `-1` and are consecutive. A layout with an above-ground layer includes both `0` and `1`. Other pairings, arbitrary station angles and arbitrary access coordinates are outside the current layout contract.

- **Underground-only** uses the native street entrance at a fixed frame. Level `-1` has offset `{x=0,y=0}` and defaults to rotation `0`. Each deeper level defaults to the same centre and to an axis perpendicular to the preceding level. Set any supported angle per deeper layer and offsets within 4 m of the `-1` centre along each axis. The core creates flights between adjacent concourses.
- **Surface and elevated** uses level `0` as the origin with default rotation `0`. Level `1` is perpendicular to `0` and defaults to `{x=0,y=20.5}` in the surface frame. The upper centre can move within `x=-3..3` and `y=20.25..20.75`. This keeps the stairs, piers and street connection aligned with the shared entrance plaza.
- **Mixed** adds `-1` parallel to `1`, with the same `x` and `y` 4 m farther along the surface frame. That anchor meets the stairwell in the shared plaza. Deeper layers use the underground rules relative to the `-1` centre. The core joins the street and surface paths, the upper stairs and the underground concourses. No per-layer street entrances or custom access points are required in the asset spec.

These limits reflect the current entrance and connection geometry. A configuration outside them receives an API error. Building within the limits establishes a connected generated network. Actual placement still depends on terrain, collision bounds, road access and connecting tracks in TF3. Shared stair openings, landing geometry and plaza finishes are core-owned. In particular, inspect the mixed plaza opening, retaining walls and paving seams in game before publishing a design.

## Use the independent example

The developer kit includes `multi-level-example/station.con.lua` and `multi-level-example/station.script.lua`. In the repository these are under `examples/multi_level/`. The example gives the surface and elevated levels different lengths, offsets and visual kits using bundled models.

1. Create `my_light_rail_mod/mod.json` and a `content/` directory. Copy the two example files into `content/`. Use your own `modId` and change `my_light_rail_mod::` in the construction's `updateScript.fileName` to match.
2. Add the [required ULR dependency](station-api-v1.md#dependency) to `mod.json`. For this local review only, use `revisionMin=73` with the reviewed checkout enabled. The live revision 73 lacks `buildInterchange()`. Use the actual minimum feature revision when it is published.
3. The construction description uses the public `station_menu.lua.getMenuCategory()` helper. The update script imports only the public station API. Enable the reviewed core and your own mod, then find **Example Light Rail Interchange** in the Light Rail menu from 1925.
4. Check placement, both approach ends on each level, boarding and a transfer, then save and reload. Swap one layer's design and verify that the other layer's models and routes still match.

This manifest is enough for local review.

```json
{
  "modId": "my_light_rail_mod",
  "revision": 1,
  "severityAdd": "None",
  "severityRemove": "Critical",
  "visible": true,
  "cosmetic": false,
  "dependencies": [{
    "mod": {"modId": "mrnickert_ultimate_metro", "revisionMin": 73, "revisionMax": -1},
    "modInfo": {"displayName": "Ultimate Light Rail"},
    "loadBefore": true,
    "optional": false
  }]
}
```

## Validation status

- **In game.** The published Underground Interchange has been tested with two layers, including a transfer, and with working tram lines at all four underground depths. The Aboveground prototype at `0` and `1` was placed and a passenger transfer was confirmed. Those results describe the original constructions.
- **Mixed prototype.** The mixed build was loaded in game. Placement and end-to-end transfers through the final shared-plaza arrangement have not been confirmed. The current public API and independent example still need a TF3 run.
- **Automated.** The independent example runs through the same public entry point an add-on uses. Tests check per-level assets, capacity, rotation, offsets, six connected platforms in the mixed configuration and twelve connected platforms for the full `-4` through `1` arrangement. These checks establish generated geometry and network connectivity, not in-game placement, boarding or save/reload for the full stack.
