# Ultimate Light Rail 1.0.0 — publication package

Prepared locally for review and upload. Nothing has been published or made public by this preparation step.

## Copy-ready material

- `modio-fields.json`: title, summary, version, revision, suggested slug and release destinations.
- `summary.txt`: the short description, within the core metadata's 100-character budget.
- `modio-description.md`: the English page copy for an editor supporting Markdown.
- `modio-description.html`: the same copy as HTML for an HTML/source editor.
- `release-notes.md`: concise 1.0.0 release notes.
- `github-release.md`: copy for the GitHub Release containing the three downloads.
- `screenshots-needed.md`: final capture list and framing guidance.
- `media/cover.png`: the finished 1920×1080 cover, with a title/footer frame around the unscaled gameplay capture.
- `media/cover-layout.svg`: the editable vector layout source.
- `media/gameplay-elevated.png` and `media/gameplay-fenced-crossing.png`: original gallery captures.
- `media-provenance.json`: source and authenticity record for the packaged media.

Choose one page-copy format appropriate to the website editor; do not paste the HTML source into a plain-text field. Only tags actually offered by the game's upload form should be selected. `Script Mod` is the existing core tag; additional category suggestions in the field sheet still need confirmation in the form.

## Downloads

The exported upload folder contains the current core, developer kit, optional example and their checksum file. Upload only the core as the active mod.io game download. The developer kit and example belong on the public GitHub Release, with links from the mod.io description.

The prepared GitHub links point to `MrNickert/ultimate-metro` and the `v1.0.0` release. They are intended destinations, not a claim that those URLs are public or live. The connected GitHub account did not expose this repository during preparation (404); verify visibility and release downloads before making the mod page public.

## Packaged Mod Hub metadata

The core archive includes the cover, two screenshots, formatted HTML description, summary, author, tags and homepage. The screenshot region in the cover is drawn at the original resolution and checked pixel-for-pixel by `scripts/build_publication_media.ps1`; only the surrounding vector frame is new. After extracting the updated archive, click **Refresh** in the Mod Hub. Validation errors and warnings must be inspected from the fresh game report; packaging checks are not a claim of a green engine validation.

## Remaining release gates

1. Confirm the 1924/1925 transition in-game, including whether the Light Rail button appears without reloading.
2. Review the packaged cover and two gallery captures. The core ZIP includes `_metadata/0.png`, `1.png`, `2.png` and the formatted `description.html`. Additional terminus/underground/settings images from `screenshots-needed.md` can improve the gallery, but the supplied media are ready for the next Mod Hub check.
3. Push the final release commit. Check that `v1.0.0` identifies the intended final release content. Do not force-update a tag already published to users; resolve versioning before publishing.
4. Make the intended source/release repository public and create the GitHub Release with all three archives plus checksums. Verify the download links as a logged-out visitor.
5. Extract the core ZIP into the game's staging area. Preserve any existing mod.io linkage file when updating an already-created listing.
6. Use the in-game Mod Manager's validation/upload flow, review the metadata and cover, and check whether it will create a new mod or update an existing one. Keep the listing hidden/private while reviewing where that option is available.
7. Add the actual gameplay gallery and prepared page text, check links and screenshots, then make the intended listing public after the final review.

The page copy states the 1925 introduction year and the public API v1 backward-compatibility commitment. It makes no promise of console compatibility, arbitrary stair placement, a new vehicle fleet or a customisable underground hall.

## Reference sources checked

- [TF3 in-game upload workflow](https://mod.io/g/transportfever3/r/creating-and-updating-mods-via-the-in-game-mod-manager)
- [mod.io: adding a mod](https://docs.mod.io/restapi/docs/add-mod)
- [mod.io: adding gallery media](https://docs.mod.io/restapi/docs/add-mod-media)
- [mod.io: allowed tags belong to the parent game](https://docs.mod.io/restapi/docs/add-mod-tags)

The game-specific guide is a community workflow reference. Treat the current in-game validation and upload dialog as the final check for this installation. The suggested 1920×1080 artwork target is a design choice; a platform upload limit has not been assumed.
