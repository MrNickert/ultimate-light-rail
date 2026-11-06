# Validation status — release 1.1.0

## Automated checks

- 72 functional station cases are compared with recorded reference outputs; routing, terminals and other non-visual build data remain unchanged.
- 27 fixed underground/internal layouts also have complete-output comparisons.
- Native resources, mesh buffers, platform/canopy coverage, fixed stairs, clear pole zones, fences and all supported lengths are checked.
- Bundled and example station descriptions are checked against the public track introduction year, 1925.
- API validation, default selections, model replacement and unchanged caller-owned tables are tested.
- GUI tests cover one combined catalogue, depot eras, external category discovery, repeat construction without loss or duplication, resource `data()` and both UI replacements.
- Stylesheet functions execute with test dependencies; global animation names and references are checked. The construction window is tested without an active Construction tool.
- Packaging validates runtime file lists, local resource references, translations, the transparent icon, ZIP contents and CRC.

These checks support the [API v1 compatibility commitment](compatibility.md). They do not make undocumented internals part of the public contract.

## In-game confirmation by the user

All three station locations have been placed and confirmed working. All platform lengths have been placed for visual inspection. Testing includes boarding/alighting, native connections, reversing, multiple lines/vehicles, crossing movements and save/reload. Independent component examples have been placed at 40m/80m with and without roofs; boarding and crossovers were confirmed for two variants.

The dedicated Light Rail button, compact icon and combined catalogue containing the tram depot, track and station have been confirmed in-game.

The fixed two-layer interchange was tested in-game, including a passenger transfer. The four-layer prototype was placed and connected to working lines at all four depths. Its generated pedestrian network passed all 56 directed inter-platform checks. The configurable station settings were confirmed in-game. Automated tests cover one to four layers, all adjacent angle pairs and mixed platform lengths. The final upload candidate still needs Mod Hub validation and a visual check of the tile and settings.

## Scope

The integrated 1.0.0 core has been used to build a working light rail line in an existing save, as confirmed by the user.

The introduction-year adjustment still needs an in-game boundary check: the bundled stations and track should be unavailable in 1924 and available in 1925. The native depot keeps its own availability. Existing stations are not removed when a construction introduction year changes.

Not every combination of length, vehicle and external model has been tested individually in the engine. Automated checks do not replace that practical testing. Overlong vehicles can block terminus crossovers. External colliders can block pedestrian routes. Other UI-replacement mods and future game updates require separate checks.
