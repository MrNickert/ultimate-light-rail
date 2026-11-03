# Independent Ultimate Light Rail API examples

This is a separate optional test mod, not part of the main mod ZIP. The example requires core revision 45 or newer and remains usable with 0.17.0. Our main standard stations do not depend on this example mod.

## Menu entries

- **ULR Contract Example**: the original fixed surface through station, 80m, replacing one platform model through the older asset-role contract. Kept as a compatibility consumer.
- **ULR Component Kit Example**: choose through/terminus, 40/60/80/100/120m and Covered/Minimal. Covered uses independent 20m platform/roof wrappers with no shelters or greenery; Minimal also removes canopy, benches, bins and lights.

Short platform infills and fixed stairs remain core-owned. The wrappers reference installed native meshes/materials; no native binary assets are included.

## Confirmed versus pending

The user placed the component example at 40m/80m with and without a roof. Boarding and switch operation were confirmed in two tested variants. This confirms that particular independent mod/API coupling in-game. It does not validate every combination or future external model. The migrated bundled 0.17.0 station family still needs an end check.

## Developing your own station

Use these files as source templates, then change the mod ID, visible name and all own namespace references. New authors following the current API helper/entrance-bench-variant documentation should require revision 46. This historical example keeps revision 45 because it uses the earlier feature subset.

Build with `python scripts/package_contract_example.py`. The developer pack includes these sources, maker documentation and original reference wrappers. It is not a mod ZIP to activate directly.
