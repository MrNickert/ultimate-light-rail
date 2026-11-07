# Ultimate Light Rail 1.1.1 — publication package

Current release candidate: mod revision 66, Station API v1. Nothing is published by these packaging scripts.

## Visual direction and gallery

- `media/cover.png`: selected user-supplied illustrated cover, normalised to 1920×1080.
- `media/api-overview.png`: the selected API infographic, with its misleading JSON replaced by documented v1 capabilities; 1920×1080.
- `media/gameplay-elevated.png` and `media/gameplay-fenced-crossing.png`: unchanged gameplay captures.

The cover is `_metadata/0.png`. The detail gallery deliberately starts with that same designed cover (`1.png`), then the API overview (`2.png`), and the two gameplay captures (`3.png`, `4.png`). The cover and API panel are promotional illustrations, not screenshots. Model assemblies in the game are shown by the two gameplay captures. Source and image hashes are recorded in `media-provenance.json`.

## Text and previews

- `modhub-description.html`: concise escaped plain text for the native Mod Hub. No HTML elements are allowed; unsupported tags can crash its RichTextView.
- `modio-description.html`: image-led web description for the mod.io website editor. Copy into its HTML/source editing mode, not a plain-text field. Do not copy this file over the native description.
- `modio-description.md`: matching copy for a Markdown-capable editor.
- `modio-preview.html`: local preview of the web description with local image paths.
- `landing/index.html`: independent interactive landing preview using the same selected cover and API artwork. Its CSS/JavaScript is not embedded in mod.io.
- `modio-fields.json`: current title, summary, tags, revision, download destinations and validation status.

The web description's image URLs target the public GitHub repository. They work for visitors only after the repository and assets are public and pushed. The in-game description and galleries are packaged locally and do not depend on those URLs. The local preview is not proof that content has been published to mod.io.

## Tags

Script Mod, Tram, Road Station, Road Construction, Depot. These labels were present in the user's in-game tag picker and describe actual included content. No Official, Curated or unrelated vehicle tags are assigned.

## Validation

The test candidate uses additive native recipe integration. GameBar and ConstructionListWindow are retained. A small checked bar adapter inserts the button and calls previous wrappers through; a scoped construction-content adapter appends the category and restores native helpers after each callback. See `docs/ui-integration.md`. The earlier integration was tested alongside Undo!. Validate the final candidate in Mod Hub before uploading.

Four known model warnings concern native game textures using BC3/DXT5 where the validator recommends BC1/DXT1 for opaque maps. They reference the native park-bench material, station canopy atlas (two models), and tram paving metal/gloss map. Those textures are not bundled or modified by this mod. The warning is recorded rather than suppressed or "fixed" by redistributing modified base-game textures.

## Upload workflow

1. Build UI and artwork, then the core, example, developer kit and publication packages with the scripts under `scripts/`.
2. Apply the refreshed candidate to the staging area, preserve any mod.io linkage file, and archive obsolete gallery files `5.png` and `6.png` outside `_metadata`.
3. Refresh the Mod Hub. Check the cover, selected gallery, concise description and five tags. Run its validation again and confirm that the Construction-tool error is absent. Record any remaining warnings.
4. Load the updated staging copy and check the Interchange tile, layer settings, placement and a line after save/reload.
5. Push the final commit. If distributing this update on GitHub, use the new `v1.1.1` release tag and attach the core, developer kit, example and checksums.
6. Upload the staged core through Mod Hub. Confirm the dialog says it will update the existing listing. Use the text in `capacity-update-changelog.txt`. Leave Update Metadata off if keeping the current listing copy and artwork. The web description is available separately.

The developer kit is documentation and source; it is not a directly installable mod. The example is an optional add-on requiring the core. Updates within the documented API v1 contract remain backward compatible; breaking changes use a new API version alongside v1.
