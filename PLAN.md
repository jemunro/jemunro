# Academic portfolio — incremental implementation plan

## Goal
Build a minimal Quarto/GitHub Pages portfolio with a **Publications** homepage and **Software** catalogue. Develop and test privately in Codespaces. Add placeholder entries and a stable editing workflow before attempting APIs or automation.

**Process:** Complete one milestone, test it, review it, then explicitly approve the next. Update the status in this file as work progresses. No public deployment until Stage 5.

| Stage | Milestone | Status |
|---|---|---|
| 0 | Reproducible Codespaces environment | In progress / verify |
| 1 | Website shell and private preview | Next |
| 2 | Placeholder catalogue entries and presentation | Not started |
| 3 | Editable Markdown content model | Not started |
| 4 | Search, filters, featured ordering | Not started |
| 5 | GitHub Pages deployment | Not started |
| 6 | Manual ORCID publication import | Not started |
| 7 | Identity matching, preprint relationships and exclusions | Not started |
| 8 | Manual OpenAlex citation matching and retrieval | Not started |
| 9 | Curated GitHub repository metadata import | Not started |
| 10 | AI-assisted draft descriptions and tags | Not started |
| 11 | One-PR-per-paper review workflow | Not started |
| 12 | Scheduled discovery, metadata and citation updates | Not started |

## Stage 0 — Development environment
**Scope:** Devcontainer with Quarto, relevant VS Code extensions and a private forwarded preview port. No website implementation.

**Pass when:** Container rebuild succeeds, `quarto --version` and `quarto check` work, and the preview port is private.

## Stage 1 — Website shell
**Scope:** Minimal Quarto site with header (name/qualifications/position/affiliation), desktop sidebar (short bio and profile-link placeholders), Publications homepage and Software page, responsive styling. No catalogue entries or data integrations. Preview privately in Codespaces.

**Pass when:** `quarto render` succeeds; both pages and navigation work; sidebar/header behave sensibly on desktop and narrow screens; a private Codespaces preview is available. No public deployment.

## Stage 2 — Placeholder catalogues
**Scope:** Add a few clearly identified sample publications and software projects; iterate compact entry layout, descriptions, links, tags, authorship/featured indicators. Use hardcoded data temporarily.

**Pass when:** Both catalogues are legible and visually consistent at desktop/mobile widths; no invented bibliographic metadata appears as verified fact.

## Stage 3 — Editable content model
**Scope:** Move entries to one version-controlled Markdown file per item, with stable IDs and curated fields. Choose a clean separation between curated files and future generated metadata.

**Pass when:** Adding, editing and removing an entry requires editing content files, not site rendering code; manual fields persist unchanged across builds.

## Stage 4 — Search and filtering
**Scope:** Add text search, shared controlled-vocabulary keyword filters and featured-first ordering; keep regular entries chronological. Prefer native Quarto listings where practical.

**Pass when:** Search and tag filtering work for both catalogues, including mobile; featured ordering works; empty results and filter reset behave sensibly.

## Stage 5 — First publication
**Scope:** Configure GitHub Actions/GitHub Pages deployment of approved `main` only. Continue testing unfinished work privately in Codespaces on feature branches.

**Pass when:** Public site matches approved preview; updates to approved `main` deploy; development branches do not publish automatically.

## Stage 6 — Manual ORCID importer
**Scope:** Fetch works from a supplied ORCID profile using a manually run importer. Save source metadata separately; no automatic publication or PRs yet.

**Pass when:** Imported works and identifiers can be inspected; errors do not erase cached data; curated files are untouched.

## Stage 7 — Matching and publication lifecycle
**Scope:** Stable identifiers, DOI matching, preprint/journal relationships, deduplication and manual exclusions.

**Pass when:** Repeated import is idempotent; test cases for duplicates and preprint updates are handled; exclusions persist.

## Stage 8 — OpenAlex citations (manual)
**Scope:** Resolve catalogue items to OpenAlex works and fetch citation counts, keeping citation data separate from curated content.

**Pass when:** A sample of counts is checked against source records; unmatched works are flagged rather than guessed; API failures preserve prior values.

## Stage 9 — Selected GitHub repositories
**Scope:** Manually define which repositories appear, then retrieve supported GitHub metadata without overwriting curated fields.

**Pass when:** Only explicitly selected repos appear; missing/private repos fail gracefully; descriptions/tags remain editable.

## Stage 10 — AI-assisted draft content
**Scope:** Generate initial 1–2 sentence descriptions, candidate keywords and possible authorship role for new items, using available abstracts/documentation. No automatic regeneration of approved text.

**Pass when:** Generated fields are clearly drafts; no unsupported claims are inserted; an edited approved entry cannot be overwritten.

## Stage 11 — Review pull requests
**Scope:** Propose each newly discovered paper in a separate GitHub PR; review substantive metadata changes. Avoid duplicating pending or merged proposals.

**Pass when:** One test discovery creates one reviewable PR, a repeat creates none, and merge publishes only approved content.

## Stage 12 — Scheduled updates
**Scope:** Schedule ORCID discovery and routine metadata refresh; update OpenAlex citation JSON daily, independently of full Quarto rerenders. Maintain reliable cached fallbacks.

**Pass when:** Scheduled jobs are idempotent, errors are visible, curated content remains protected, and citation numbers update on the deployed site without a full site rebuild.

## Deferred unless explicitly requested
Blog, individual project pages, citation dashboards/graphs, full-text abstract hosting, scraping Google Scholar, automatic inclusion of all GitHub repos, and extra frontend frameworks.

## Review log
Record milestone completion dates, decisions and relevant caveats here as the project progresses.
