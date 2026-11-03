# Design constraints — Ultimate Light Rail 1.0.0

The mod uses the tram traffic system to connect to existing tram tracks and roads. The public light rail track preserves native reservations and traffic handling. Station logic supports reversing and crossovers; the mod does not replace the general route planner.

API v1 uses fixed, tested track and pedestrian geometry. Creators can style components without defining routes or terminals. Two tracks, platform width/height and entrance/stair positions are fixed. Only supported lengths are offered. These boundaries keep asset mods predictable.

The underground station uses a fixed native hall; surface and elevated stations support custom 20m components. Elevated stations have a structural deck and central street access. Space for a separately placed bus stop is decoration; the core does not create an integrated functional bus stop.

A dedicated Light Rail menu keeps bundled stations and third-party designs together. The UI uses native replacement mechanisms and internal recipe/tool integration. Compatibility with every other UI mod is not guaranteed.

Updates and extensions preserve the documented API v1 contract. A feature that requires a breaking contract change belongs in a new API version alongside v1, rather than changing the meaning of existing v1 designs. See the [compatibility policy](compatibility.md).
