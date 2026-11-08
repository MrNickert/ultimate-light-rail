# API compatibility policy

**Ultimate Light Rail 1.2.2 · Station API v1**

## Our commitment to add-on creators

Updates and extensions within API v1 will remain backward compatible with its documented public contract. An add-on that follows that contract will continue to work with API v1 without requiring a rewrite whenever Ultimate Light Rail is updated.

New features within v1 will be additive: new optional capabilities may be introduced, but existing documented calls, valid inputs and their documented meaning will remain supported. A new optional setting will not become a requirement for existing v1 callers.

If a feature requires a breaking change, it will be introduced in a new, explicitly versioned API, for example `station_api_v2.lua` with `apiVersion=2`. API v1 will remain available and supported alongside it. Existing add-ons will not be switched to the new contract automatically or forced to migrate to use a core update. API v1 will not be silently repurposed or replaced.

## What the public v1 contract covers

- The `station_api_v1.lua` module and its documented methods, including `buildStation`, `getContract`, `getDefaultKit`, `getDefaultDesign` and `getMenuCategory`.
- The lightweight `station_menu.lua.getMenuCategory` helper and registration in the shared Light Rail menu.
- Documented station fields, accepted values, component choices and supported asset roles.
- The documented 20m module interface, reference profiles and fixed layout responsibilities.
- The documented handling of optional fields and independent caller-owned tables.

This includes both supported design forms, `components` and `assets`. Existing valid v1 designs remain supported when new features are added.

## Version numbers and dependencies

The core's release number, numeric mod revision and station API version have different purposes. A newer core release does not by itself require a new API version or an add-on rewrite.

Use `revisionMin` to require the first core revision containing the features your add-on uses. The 1.0.0 developer kit requires revision 49. `revisionMax=-1` leaves later compatible core revisions available. When opting into a new v1 feature, increase the minimum revision only if that feature requires it. State the required minimum in your add-on documentation.

## Scope of the promise

Compatibility concerns documented API behaviour and model interfaces; it does not freeze every visual detail of the standard kit. Standard decorations and implementation details may receive fixes or improvements while preserving the v1 contract and reference profiles. Use explicit custom component models when a design needs its own fixed appearance.

Internal builders, generated GUI recipes, native engine hooks and undocumented implementation details are not extension points. Add-ons should call the public API instead of importing or modifying them. Engine updates, other UI-replacement mods and invalid external model geometry require their own testing; they are distinct from an intentional breaking change to the public station API.

## Verification

Core changes are checked against station-output regressions, public API validation, component layout tests and independent example consumers. Add-on creators should also test their own models and colliders in the game. These checks support the compatibility commitment; they do not replace it.
