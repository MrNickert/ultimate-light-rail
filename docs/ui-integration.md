# Additive UI integration

The core retains the native `GameBar` and `ConstructionListWindow`. It does not replace either root recipe or register a second Construction tool. There is no Undo-specific branch in runtime code.

## Construction bar

A checked descriptor identifies the two native leaf recipes for construction button groups and individual construction buttons. The descriptor is generated from installed game sources, using exported recipe anchors and their source registration order. Runtime installation checks the anchor span and expected callable slots before changing anything.

The group adapter shallow-copies the button descriptor list and inserts Light Rail before the existing Rail entry only when Road and Rail are present. Existing descriptors and unrelated groups remain intact. Any earlier wrapper is called through, including its extra controls. Unrelated button calls pass through unchanged, including references and arguments. Keyboard actions are forwarded to the retained child group.

## Construction categories

The category adapter uses TF3's shared lazy state and construction catalogue helpers. It adds Light Rail when an initializer calls the catalogue helper and returns a construction category list. The catalogue wrapper is scoped to initialization and restored even after an error. The active window keeps its renderer, APIs and categories. The adapter does not use a construction recipe ID or registration offset, so replacement windows using the same helpers can receive the category.

The Light Rail button requests `light_rail` by category ID. The category adapter resolves its current index when opening it. No fixed Light Rail tab number is stored. Availability notifications are translated by category ID while the native notifications remain intact.

## Line manager

The Light Rail filter adds a control next to Tram in the native line manager. A line matches when it serves a built-in or API-registered Light Rail station. The native Tram filter still includes Light Rail lines. The adapter retains the existing search, visibility filter and selection controls and applies the Light Rail predicate to both the list and bulk selection. If the required native helpers cannot be wrapped, the adapter skips the filter and logs the reason.

## Limits and engine coupling

The engine does not expose a public construction-category extension point. The bar integration uses checked native recipe registry entries, and the catalogue integration uses shared TF3 helpers. A bar layout mismatch skips the affected hook and writes a diagnostic. A replacement catalogue using a different state structure or ignoring the native tab-selection event can still be incompatible.

## Diagnostics and verification

Short messages prefixed `[ULR UI]` report hook installation, retained prior wrappers, actual button/category insertion, open requests and ID resolution. Each message category is logged once per UI session. No world scans or every-frame log output are introduced.

`tests/test_ui.lua` covers catalogue and year behaviour. `tests/test_additive_ui.lua` checks foreign controls, reference forwarding, idempotent setup, category shifts, catalogue isolation and helper restoration after errors. If the installed Undo mod is available locally, its real button-wrapper code is exercised in both setup orders; the foreign source is not copied into the mod or developer kit. Engine rendering and input still require in-game verification.
