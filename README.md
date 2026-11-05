# Ultimate Light Rail

**Release 1.0.0 · mod revision 56 · Station API v1**

The additive UI integration (revision 52) has been tested in-game alongside Undo. The current station maintenance update (revision 56) still needs in-game validation. See [UI integration](docs/ui-integration.md).

Tram-based light rail for Transport Fever 3, with a dedicated construction menu, track and configurable passenger stations.

## Playing

Open **Light Rail**, between Road and Rail. The tram depot, light rail track and participating stations share one searchable catalogue.

| Setting | Choices |
| --- | --- |
| Location | Underground / Surface / Elevated; Surface selected by default |
| Station type | Through / Terminus |
| Platform length | 40 / 60 / 80 / 100 / 120 metres |
| Fences | No / Yes; disabled underground |

Bundled stations and the public light rail track become available in **1925**, matching the native modern tram track. The tram depot retains its native availability dates.

All stations have two platform tracks. Terminus stations include a crossover and support reversing without a visible turning loop. Use tram vehicles and native electric tram track. Vehicles must fit the selected platform length: overlong vehicles can keep a crossover occupied. Select terminals or add waypoints when you need a particular track assignment.

Surface stations have low platforms, furniture and a landscaped forecourt at the terminus end. Through stations have a pedestrian underpass. Elevated stations include a concrete structure, canopies and one central street-level entrance; tracks are at +12m. Underground tracks are at -18m, with a fixed hall and street access. The public light rail track has low metal fences and preserves native tram traffic behaviour.

Underground stations use a maintenance base of **30,000** (about **$180,000/year at the previously tested settings**), matching the rebalanced vanilla underground stop. No separate cost mod is required for ULR stations. A saved, one-time migration updates player-owned bundled underground stations still using the previous base of 180,000. Surface/elevated stations, build prices, geometry, lines and accrued charges are preserved. Already adjusted or nonstandard costs are skipped. Migration changes remain in the save after removing a mod; no automatic refunds or reversions are performed.

[Maintenance and existing stations](docs/maintenance.md) · [Installation](docs/installation.md) · [Validation and limitations](docs/validation.md)

## Creating stations

Bundled stations and third-party designs use the same public API. Creators can select standard components, provide custom models or omit optional decorations. The core owns two-track layouts, entrances, stairs, pedestrian routes, terminals and crossovers.

- [Developer kit: getting started](docs/developer-kit-readme.md)
- [20m components and model dimensions](docs/asset-kit-v1.md)
- [Station API v1 and the shared menu](docs/station-api-v1.md)
- [Standalone example mod](examples/contract_station/README.md)

Use `station_menu.lua` in your construction description to register stations in the Light Rail menu. Your own namespace requires no changes to the core mod.

## API compatibility commitment

Updates and extensions within API v1 will remain backward compatible with its documented public contract. Existing conforming API v1 add-ons will continue to work without being rewritten for each core update. If a change must break that contract, it will be introduced in a new API version alongside v1; it will not silently change or replace API v1. Core release numbers and API versions are independent. See the [compatibility policy](docs/compatibility.md) for the supported interface and boundaries.

## Building and checking

You need Windows, Python 3, PowerShell, Teal 0.24.8 and an installed Steam copy of Transport Fever 3. VS Code can use the supplied `all_def.tl`. Use `tlconfig.example.lua` as the basis for your local configuration.

```powershell
python scripts/build_ui.py
./scripts/convert_ui_icon.ps1
python scripts/test_station_contract.py
python scripts/test_native_layout.py
& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_ui.lua
& 'C:\Program Files\Teal\0.24.8\tl.exe' run tests/test_maintenance_migration.lua
python scripts/check_ui.py
python scripts/package.py
python scripts/package_contract_example.py
python scripts/package_sdk.py
```

The three ZIPs in `dist/` contain the core mod, optional example mod and developer kit. The UI is part of the core. Native GUI adapters are generated from the installed game's sources; source hashes are included in the build manifest. [Architecture](docs/architecture.md) · [Credits](CREDITS.md).

## Publishing

The [publication package](publication/README.md) contains the English mod.io page copy, GitHub release text, a gameplay-based cover layout and the final screenshot capture list. It also records the remaining year-boundary and public-download checks.
