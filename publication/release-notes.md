# Ultimate Light Rail 1.2.2

## Revision 73

Ultimate Light Rail 1.2.2 adds a dedicated Light Rail filter to the line manager. It shows lines serving Ultimate Light Rail stations or compatible add-on stations. Light Rail lines also remain available under the standard Tram filter.

## Revision 70

Ultimate Light Rail 1.2.1 improves road snapping for stations. Surface through stations align along the platform side, and surface termini snap at the end plaza. Elevated stations can align parallel or perpendicular to the road. The Underground Interchange entrance stays aligned with the street when the first level rotates.

## Revision 68

Surface through stations can now use paved pedestrian crossings at both platform ends. Choose Crossing under Platform access to replace the stairs with level access between platforms. Underpass remains the default.

## Revision 66

Platform capacity now scales with platform length at 35 waiting passengers per 20 m per track. Each Interchange layer uses its own platform length.

## Revision 65

- Added the configurable Underground Interchange with up to four layers and internal transfers.
- Added optional Turnback crossovers to both ends of through stations.
- Station API v1 and the existing example mod retain their public contract.

- Dedicated Light Rail construction menu with the native tram depot, fenced track and registered stations in one searchable catalogue.
- Surface, underground and elevated stations; through and reversing terminus layouts.
- Two platform tracks and 40/60/80/100/120m platform lengths.
- Integrated terminus crossovers and pedestrian access using native game assets.
- Bundled stations and public light rail track available from 1925.
- Public Station API v1, shared menu helper and modular 20m component interface.
- English documentation, standalone API examples and a developer kit.

API v1 updates and extensions remain backward compatible with the documented contract. Breaking changes will use a new API version alongside v1.
