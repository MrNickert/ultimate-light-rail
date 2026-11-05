# Ultimate Light Rail 1.0.0 — publication package

Prepared locally for review and upload. Nothing has been published or made public by this preparation step.

## Copy-ready material

- `modio-fields.json`: title, summary, version, revision, suggested slug and release destinations.
- `summary.txt`: the short description, within the core metadata's 100-character budget.
- `modio-description.md`: the English page copy for an editor supporting Markdown.
- `modio-description.html`: visual mod.io page content with wide image panels; no custom CSS or JavaScript required.
- `modio-preview.html`: a local content preview with the images resolved locally.
- `landing/index.html`: the complete responsive, interactive player/creator landing-page preview.
- `modhub-description.html`: tag-free text for the game's native RichTextView; presentation images are supplied through its gallery.
- `release-notes.md`: concise 1.0.0 release notes.
- `github-release.md`: copy for the GitHub Release containing the three downloads.
- `screenshots-needed.md`: supplied evidence and optional additional capture guidance.
- `media/api-components.png`: the real independent component example with supported visual choices.
- `media/api-contract.png`: readable public menu/build reference code and the v1 compatibility commitment.
- `api-presentation-snippets.lua`: the matching copyable reference fragments.
- `media/cover.png`: the finished 1920×1080 cover, with a title/footer frame around the unscaled gameplay capture.
- `media/cover-layout.svg`: the editable vector layout source.
- `media/gameplay-elevated.png` and `media/gameplay-fenced-crossing.png`: original gallery captures.
- `media-provenance.json`: source and authenticity record for the packaged media.

Choose one page-copy format appropriate to the website editor; do not paste the HTML source into a plain-text field. Only tags actually offered by the game's upload form should be selected. `Script Mod` is the existing core tag; additional category suggestions in the field sheet still need confirmation in the form.

## Downloads

The exported upload folder contains the current core, developer kit, optional example and their checksum file. Upload only the core as the active mod.io game download. The developer kit and example belong on the public GitHub Release, with links from the mod.io description.

The prepared GitHub links point to `MrNickert/ultimate-light-rail` and the `v1.0.0` release. They are intended destinations, not a claim that those URLs are public or live. The connected GitHub account did not expose this repository during preparation (404); verify visibility and release downloads before making the mod page public.

## Packaged Mod Hub metadata

The core archive includes the cover, four gameplay gallery captures, two API documentation panels, tag-free native description, summary, author, tags and homepage. The screenshot region in the cover is drawn at the original resolution and checked pixel-for-pixel by `scripts/build_publication_media.ps1`; only the surrounding vector frame is new. After extracting the updated archive, click **Refresh** in the Mod Hub. Validation errors and warnings must be inspected from the fresh game report; packaging checks are not a claim of a green engine validation.

## Remaining release gates

1. Confirm the 1924/1925 transition in-game, including whether the Light Rail button appears without reloading.
2. Review the cover and gallery (`_metadata/0.png` through `6.png`). The API panels are documentation graphics; gameplay scenes are authentic supplied captures. Native Mod Hub formatting is represented by `modhub-description.html`. The full website content is in `modio-description.html`.
3. Push the final release commit. Check that `v1.0.0` identifies the intended final release content. Do not force-update a tag already published to users; resolve versioning before publishing.
4. Make the intended source/release repository public and create the GitHub Release with all three archives plus checksums. Verify the download links as a logged-out visitor.
5. Extract the core ZIP into the game's staging area. Preserve any existing mod.io linkage file when updating an already-created listing.
6. Use the in-game Mod Manager's validation/upload flow, review the metadata and cover, and check whether it will create a new mod or update an existing one. Keep the listing hidden/private while reviewing where that option is available.
7. In the mod.io website editor, apply `modio-description.html` for the visual long-form page after the repository is public. Its image URLs use the committed publication media, so check that each image loads as a logged-out visitor. Check all downloads and gallery images, then make the listing public after final review.

The page copy states the 1925 introduction year and the public API v1 backward-compatibility commitment. It makes no promise of console compatibility, arbitrary stair placement, a new vehicle fleet or a customisable underground hall.

## Reference sources checked

- [TF3 in-game upload workflow](https://mod.io/g/transportfever3/r/creating-and-updating-mods-via-the-in-game-mod-manager)
- [mod.io: adding a mod](https://docs.mod.io/restapi/docs/add-mod)
- [mod.io: adding gallery media](https://docs.mod.io/restapi/docs/add-mod-media)
- [mod.io: allowed tags belong to the parent game](https://docs.mod.io/restapi/docs/add-mod-tags)

The game-specific guide is a community workflow reference. Treat the current in-game validation and upload dialog as the final check for this installation. The suggested 1920×1080 artwork target is a design choice; a platform upload limit has not been assumed.

## Landing page versus the mod.io page

`landing/index.html` is an independent local presentation with responsive CSS, a length-grid illustration, image enlargement and a FAQ. It is not assumed to be embeddable unchanged inside mod.io. The mod.io version uses basic rich HTML plus pre-rendered image panels, preserving the API visuals without relying on our stylesheet or JavaScript. The game uses a native RichTextView, so its metadata description stays tag-free and image-free while the same presentation images are in its gallery.

The web-copy image destinations use `https://raw.githubusercontent.com/MrNickert/ultimate-light-rail/main/publication/media/`. They will not be available to other users while the repository is private or before these files are pushed. The local preview resolves the same panels locally for review.

## Native description crash guard

The 2026-11-05 crash log reports `Unbound UI transformation for tag name` inside the Mod Hub RichTextView. The packaged native description now contains escaped plain text with no HTML elements. The seven cover/gallery images remain included. The visual web description stays in `modio-description.html`; do not replace the native description with that file. Reopening the Mod Hub and loading a game still require engine validation.
