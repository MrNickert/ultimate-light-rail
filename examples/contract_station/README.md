# Independent API v1 example

This is a separate, optional test mod, not part of the main mod ZIP. It requires Ultimate Light Rail revision 45 or newer and adds one fixed surface through station with 80m platforms.

Its script imports the core API through the other mod namespace. Its own platform wrapper points at installed native meshes/materials, with exactly the reference dimensions. No native binary assets are included. The appearance intentionally matches the standard station so geometry can be compared directly.

The local integration test checks this consumer through a namespace-aware test loader. Actual two-mod loading, dependency activation and placement still require a game test. This is not proof that community add-ons already work in-game.


## Component kit example 0.2.0

Requires core revision 45 (0.16.0). Adds a second menu entry: ULR Component Kit Example. Select through/terminus, five lengths and Covered/Minimal. Covered uses independent 20m platform/roof wrappers, no shelters or greenery; Minimal also removes canopy, benches, bins and lights. Both use the same unchanged core routes and fixed stairs. Short platform infills and stair modules remain native/core pieces. The original asset-role example remains as a compatibility consumer.

Build separately with `python scripts/package_contract_example.py`. Native wrappers are our own declarations referencing installed resources, without copied native binary files. No two-mod game validation has happened yet.
