# Additive UI integration

The core retains the native `GameBar` and `ConstructionListWindow`. It does not replace either root recipe or register a second Construction tool. There is no Undo-specific branch in runtime code.

## Construction bar

A checked descriptor identifies the two native leaf recipes for construction button groups and individual construction buttons. The descriptor is generated from installed game sources, using exported recipe anchors and their source registration order. Runtime installation checks the anchor span and expected callable slots before changing anything.

The group adapter shallow-copies the button descriptor list and inserts Light Rail before the existing Rail entry only when Road and Rail are present. Existing descriptors and unrelated groups remain intact. Any earlier wrapper is called through, including its extra controls. Unrelated button calls pass through unchanged, including references and arguments. Keyboard actions are forwarded to the retained child group.

## Construction categories

The native construction-content callback continues to execute. During that callback only, scoped wrappers collect a copy of the native catalogue and augment the native lazy category state with Light Rail. The original callback's render result, APIs and other categories are preserved. Both helper functions are restored after success or an exception; they are not left globally replaced between callbacks.

The Light Rail button requests `light_rail` by category ID. The category adapter resolves its current index when opening it. No fixed Light Rail tab number is stored. Availability notifications are translated by category ID while the native notifications remain intact.

## Limits and engine coupling

The engine does not expose a public construction-category extension point. The small integration layer therefore uses checked native recipe registry entries and a scoped native-state adapter. It still needs review after engine changes. Layout mismatch skips the affected hook and writes a diagnostic instead of guessing a different target.

Mods that add controls or categories through the retained native recipes can coexist. A mod that entirely replaces the native construction-content implementation can bypass this adapter; arbitrary UI rewrites are not guaranteed compatible. That condition needs its own investigation, not an ever-growing list of per-mod patches.

## Diagnostics and verification

Short messages prefixed `[ULR UI]` report hook installation, retained prior wrappers, actual button/category insertion, open requests and ID resolution. Each message category is logged once per UI session. No world scans or every-frame log output are introduced.

`tests/test_ui.lua` covers catalogue and year behaviour. `tests/test_additive_ui.lua` checks foreign controls, reference forwarding, idempotent setup, category shifts, catalogue isolation and helper restoration after errors. If the installed Undo mod is available locally, its real button-wrapper code is exercised in both setup orders; the foreign source is not copied into the mod or developer kit. Engine rendering and input still require in-game verification.
