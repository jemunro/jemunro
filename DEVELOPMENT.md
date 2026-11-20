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
- `index.qmd` (Publications, homepage), `software.qmd`.
