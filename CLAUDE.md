# Academic portfolio — guidance for Claude Code

## Purpose
Build a minimal, maintainable personal academic portfolio using **Quarto**, developed in **GitHub Codespaces** and eventually published on **GitHub Pages**. The site showcases publications and selected software repositories as searchable catalogues. Repository READMEs and external publication pages provide the detailed documentation; this site provides concise summaries and links.

## Working principles
- **Work on one milestone at a time.** Read `PLAN.md` before making changes; implement only the current approved milestone. Stop and report before starting another.
- **Start small, test, then extend.** Keep the site renderable after each change. Use placeholder content before connecting external services.
- **Prefer Quarto's native capabilities** and simple, understandable code. Avoid unnecessary frameworks, services, abstractions and dependencies.
- **Test what you change.** At minimum, render the website and check relevant navigation/functionality. Explain anything not tested.
- **Keep development previews private.** Do not enable or configure public GitHub Pages deployment until its milestone is approved.
- **Separate automated metadata from curated content.** Never silently overwrite manually edited descriptions, tags, authorship roles, featured status, exclusions or project links.
- **Keep changes reviewable.** Make focused changes, avoid unrelated refactoring and record decisions that affect later work.
- **Do not invent publication details, credentials, affiliations or citation metrics.** Use clearly labelled placeholders until verified information is supplied or retrieved.
- **Never commit credentials or API keys.** Prefer environment secrets when those integrations are eventually introduced.

## Agreed website design
- The **Publications** catalogue is the homepage; **Software** is the other main tab.
- A compact header displays name, qualifications, position and affiliation.
- A persistent desktop sidebar contains a short bio and links to GitHub, ORCID, Google Scholar, WEHI profile, LinkedIn, email and CV; it adapts to mobile.
- Catalogue entries use compact lists rather than large cards: title, relevant metadata, a 1–2 sentence description, shared keywords and external links.
- Featured entries are manually pinned above regular entries. Regular entries are reverse chronological.
- One controlled keyword vocabulary is shared across both catalogues.
- Publications include preprints; manual exclusions are supported.
- Authorship roles (first, senior and corresponding where appropriate) are separate from research-topic keywords and subject to human review.
- Do not create individual project-detail pages by default. Link to original publications and repository documentation.

## Planned content and automation (not for initial milestones)
- Curated, version-controlled Markdown files hold descriptions, keywords, featured flags, authorship roles, exclusions and cross-links.
- **ORCID** is the source for publication discovery; **OpenAlex** provides citation metrics and may enrich identifiers. Do not use OpenAlex to discover additional publications independently.
- New papers receive an individual reviewable pull request with an AI-drafted description/tags and proposed authorship role. Approved text is never automatically regenerated.
- Software repos are selected manually; AI may draft initial descriptions/tags for review.
- Routine bibliographic metadata may refresh automatically; substantive changes need review.
- OpenAlex citation counts will eventually be refreshed daily into a JSON cache that the browser reads. The site should not require a complete Quarto rebuild just to refresh counts.
- Add integrations manually and test them before enabling scheduled automation.

## Definition of done for each milestone
1. The scoped feature works and the Quarto site renders.
2. Relevant behaviour is tested (including mobile layout where applicable).
3. The README or other relevant documentation reflects how to use or maintain it.
4. Report files changed, tests run/results, unresolved issues and suggested next step.
5. Stop. Do **not** begin the next milestone without approval.

`PLAN.md` defines the sequence and acceptance criteria; if scope is unclear, ask before broadening it.
