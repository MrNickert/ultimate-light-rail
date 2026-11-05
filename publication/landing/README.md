# Local presentation preview

Open `index.html` in a browser after extracting the complete upload bundle. Keep `landing/`, `media/` and `downloads/` next to one another. The page uses system fonts and local assets, with no build dependencies.

For a local HTTP preview from the `publication/` directory, run `python -m http.server 8766 --bind 127.0.0.1`, then visit `/landing/`. The download links expect the three current release archives in `publication/downloads/`; the upload bundle supplies them automatically. That source-side directory is ignored by Git.

`api-components.html` and `api-contract.html` are fixed 1920×1080 documentation boards. Their PNG exports are in `../media/` and packaged in the core gallery and developer kit. Export them using a full-page browser screenshot; save or convert the captured image as a real PNG. The component-board source image is the original supplied gameplay capture, shown at its natural dimensions.

`../modio-preview.html` represents the mod.io content version, using the same image panels with local image URLs. `../modio-description.html` is the copy for the website editor and uses the intended public repository image URLs. It does not depend on this landing page's CSS or JavaScript. `../modhub-description.html` is the game's native rich-text description; its gallery carries the image panels.

Local preview checks cover loaded images, a working platform-length illustration, API image enlargement, FAQ interaction and a 390px layout without horizontal overflow. These checks are not a claim that the content has been published or tested inside mod.io's website editor.
