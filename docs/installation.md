# Installation — Ultimate Light Rail 1.3.0

1. Extract `ultimate-light-rail-1.3.0.zip` into your local mod directory or Steam `staging_area`. The ZIP contains the `mrnickert_ultimate_metro` folder.
2. Enable **Ultimate Light Rail** and load your save.
3. Open **Light Rail**, between Road and Rail. Place a station and connect native electric tram track or the light rail track.
4. Connect a tram depot, create a line and assign tram vehicles that fit the selected platforms.

The UI is included. If your test installation has the separate **Ultimate Light Rail UI Preview**, disable it; do not enable it alongside 1.3.0. Overwrite the core files when updating. Reloading the save is sufficient; you do not need to close the game completely.

Bundled stations and light rail track are available from 1925. Before that year, the native tram depot may still appear according to its own availability dates.

## Using stations

Choose the location, station type, platform length and fences before placement. Fences are disabled underground. Terminus stations include crossovers automatically. The central elevated entrance connects at street level; keep stairs and support areas clear.

A line chooses a valid path, which does not necessarily use both tracks. Select terminals or place waypoints when you need a specific path. Vehicles must fit the platform length.

## Optional example mod

`ultimate-light-rail-contract-example-1.3.0.zip` is optional. Enable it with the core to view two API examples in the same menu. The core does not require the example. The developer-kit ZIP contains documentation and sources; it is not a directly installable mod.

## Compatibility

The technical core mod ID is `mrnickert_ultimate_metro`. This release does not migrate development saves. Use a separate save copy when checking an existing test world. Mods replacing the same native construction UI may conflict. The UI integration needs checking after game updates.

Public API v1 updates remain backward compatible. Breaking contract changes will use a new API version alongside v1. See the [compatibility policy](compatibility.md).

Do not remove the core from a save containing its stations or infrastructure. Do not remove an asset mod while its stations are still present in the save.
