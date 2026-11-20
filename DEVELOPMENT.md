# Site development notes

## Preview and build
- Preview (private in Codespaces): `quarto preview --port 4200 --host 0.0.0.0 --no-browser`, then open forwarded port 4200 from the Ports tab. Keep its visibility **Private**.
- Build: `quarto render` (output in `_site/`, git-ignored).

## Updating profile details
All profile text lives in [`_variables.yml`](_variables.yml): name, qualifications, position, affiliation, research focus, bio and profile links. Pages use `{{< var ... >}}`; never retype these values in `.qmd` files.

**Profile links** are rendered by the `profile-links` shortcode ([`_extensions/profile/`](_extensions/profile/profile-links.lua)). A link shows only if its key exists in `_variables.yml`. Supported keys, in display order: `github`, `orcid`, `scholar`, `wehi`, `linkedin`, `email` (plain address; `mailto:` is added), `cv`. Delete a key to hide the link.

## Structure
- `_quarto.yml` — light/dark themes, render scope. (Quarto navbar is not used: the top bar is `_partials/header.qmd`; tabs come from the `site-tabs` shortcode in `_extensions/profile/site-tabs.lua` — add a line there for a new page.)
- `_partials/header.qmd`, `_partials/sidebar.qmd` — shared header and sidebar, included by each page.
- `styles.scss` — layout (sticky sidebar on ≥992px, stacked on narrow screens).
- `theme-light.scss`, `theme-dark.scss` — the "academic navy" palettes (Bootstrap variables plus the `--brand/--accent/--warm/--soft/…` tokens). Change colours only here; `styles.scss` (layout, type, components) is shared and uses the tokens, so light and dark differ only in colour.
- `index.qmd` (Publications, homepage), `software.qmd`; `content/` — catalogue entries.

## Catalogue entries
Entries are Markdown files in `content/publications/` and `content/software/`; the `catalogue` shortcode (`_extensions/profile/catalogue.lua`) renders them using the shared `.catalogue`/`.entry` styles in `styles.scss`. Schema and how to add an entry: [`content/README.md`](content/README.md).

## Automatic preview
`.devcontainer/devcontainer.json` runs `.devcontainer/start-preview.sh` each time you attach to the codespace (`postAttachCommand`); it starts `quarto preview` on port 4200 unless it already responds, and opens the private forwarded port. Log: `/tmp/quarto-preview.log`. Applies after a rebuild or the next attach/restart.

## Don't render while previewing
`quarto preview` re-renders automatically on save. Running `quarto render` at the same time writes to the same `_site/` and can make the preview error or 404. To check a clean build while the preview is running, render to a separate folder inside the project (git-ignored): `quarto render --output-dir _check`, then delete `_check/`. (An output directory outside the project triggers Quarto warnings.)
