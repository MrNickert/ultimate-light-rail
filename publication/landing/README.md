# Local presentation preview

Open `index.html` in a browser after extracting the complete upload bundle. Keep `landing/`, `media/` and `downloads/` next to one another. The page uses system fonts and local assets, with no build dependencies.

For a local HTTP preview from the `publication/` directory, run `python -m http.server 8766 --bind 127.0.0.1`, then visit `/landing/`. The download links expect the three current release archives in `publication/downloads/`; the upload bundle supplies them automatically. That source-side directory is ignored by Git.

`api-components.html` and `api-contract.html` are fixed 1920×1080 documentation boards. Their PNG exports are in `../media/` and included as reference material in the developer kit. Export them using a full-page browser screenshot; save or convert the captured image as a real PNG. The component-board source image is the original supplied gameplay capture, shown at its natural dimensions.

`../modio-preview.html` represents the mod.io content version, using the same image panels with local image URLs. `../modio-description.html` is the copy for the website editor and uses the intended public repository image URLs. It does not depend on this landing page's CSS or JavaScript. `../modhub-description.html` is the game's tag-free native description; its gallery carries the image panels.

The current preview uses the selected cover and API overview. HTML nesting and local image references are checked locally. Earlier browser interaction checks do not constitute visual verification of the latest revision or publication inside mod.io.
