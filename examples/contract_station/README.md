# Ultimate Light Rail — API Examples 1.0.0

A standalone, optional asset mod. Requires **Ultimate Light Rail 1.0.0 / revision 49**. The core does not depend on this example.

Both example stations are available from 1925, matching the bundled stations and modern tram track.

## Designs

- **ULR Component Kit Example**: surface, through/terminus, 40/60/80/100/120m, Covered/Minimal. Covered uses custom 20m platform and canopy wrappers without shelters or greenery. Minimal also omits the canopy, benches, bins and lights.
- **ULR Contract Example**: a fixed 80m surface through station replacing one platform model through asset roles.

Both construction descriptions use the public menu helper. They appear in the same Light Rail menu as bundled stations. Fixed stairs and infills remain core-owned. Model wrappers reference installed native resources; no native mesh/texture binaries are redistributed.

## Creating your own asset mod

Copy this example and change the mod ID, visible names and all references to its own namespace. Keep the required dependency on core revision 49. Use the component example as your starting point; replace its models with your own 20m assets and test your design in the game.

API v1 updates and extensions remain backward compatible with the documented public contract. Breaking changes will be introduced in a new API version alongside v1; conforming existing v1 add-ons will remain supported without forced migration. Consult the developer kit's `docs/compatibility.md` for the policy.

Read the developer kit for fixed dimensions and boundaries. Install the full core to use this example. Build its separate archive with `python scripts/package_contract_example.py`.
