# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A GitHub Pages static site — the Hybrid Athlete Training Library for @ormazaaes. No build step, no package manager, no framework. Edit HTML files and push to `main`; GitHub Pages deploys automatically.

## Files

- `index.html` — The entire app (~1619 lines): all CSS, HTML structure, and JavaScript are inline in a single file.
- `train_by_mood.html` — A separate standalone page with its own self-contained CSS and JS, same visual design system.
- `hybrid_athlete_month1_v2-2.docx` — Source document for the training program content.

## Development

No build or install step. Open either HTML file directly in a browser to preview. To serve locally with live reload:

```bash
python3 -m http.server 8080
# or
npx serve .
```

Push to `main` to deploy to production (GitHub Pages).

## Architecture of `index.html`

The file is a vanilla JS tab-based SPA. Understanding the layered navigation is essential for making changes without breaking state.

### Layer 1 — Top tabs (Programme / Standalone / Train by Mood / Glossary)

Each tab maps to a `<div class="section" id="section-{name}">`. `switchTab(tab, btn)` removes `.active` from all `.section` elements and adds it to the target. Active sections are `display:block`; others are `display:none`.

### Layer 2 — Week sub-tabs (inside Programme)

A `.scroll-nav` bar with buttons calling `switchWeek(id, btn)`. Each week panel is a `.sub-content` div (`id="w1"` through `id="w4"`, plus `id="wrun"`, `id="wbench"`, `id="w5"`). The function scopes to the nearest `.section` ancestor to avoid cross-section conflicts.

### Layer 3 — Run version sub-tabs (inside Running panel)

`switchRun(id, btn)` handles the nested 10K/5K tab set inside the Running sub-panel. Panel IDs are `r10ka`, `r10kb`, `r5ka`, `r5kb`.

### Session cards

Each workout card is a `.session-card` (programme) or `.free-card` (standalone). Cards have a `.card-toggle` button that calls `tog(this)` to expand/collapse the `.card-body` div by toggling `.open`. The toggle also flips the arrow indicator and changes the button label text.

### Standalone category filter

`.free-card` elements carry a `data-cat` attribute (`push`, `pull`, `legs`, `hyrox`, `run`). `filterFree(btn)` reads `btn.dataset.cat` and toggles `.hidden` on cards that don't match.

### Mood detail

Four mood states: `savage`, `flow`, `focus`, `forty`. `openMood(mood)` shows the matching `.mood-detail` div by adding `.visible`. `closeMood()` collapses all and scrolls back to the mood grid.

## CSS design system

All CSS is inline in `<style>` at the top of each HTML file. Both files share the same variables and class naming.

**Color tokens** (CSS custom properties):
- `--cream` / `--cream2` / `--cream3` — background shades
- `--ink` / `--ink2` — body text, secondary text
- `--muted` — labels, metadata
- `--green` / `--green2` / `--green-lt` — brand accent, hover, light tint
- `--rule` — borders and dividers

**Typography**:
- `Inter` weight 300 — body text
- `Cormorant Garamond` italic weight 300 — display headings (`.big-title`, `.week-title`, `.mood-name`)
- `DM Mono` weight 300/400 — labels, tags, metadata, monospace values

**Responsive breakpoint**: `@media(max-width:768px)` — collapses multi-column grids to single column, reduces padding from 56px to 20px.

## Content patterns

- **Exercise item**: `.ex-item` grid with `.ex-num` (01), `.ex-name` (+ optional `<small>` for tempo note), `.ex-vol` (sets×reps + `.ex-rest` for rest/intensity).
- **Block labels**: `.blk-lbl` monospace uppercase label before a group (e.g. "Superset A", "Warm up").
- **Notes**: `.card-note` with `.note-lbl` + `.note-text` — green left-bordered callout.
- **Info boxes**: `.info-box` with optional `<span class="info-lbl">` — neutral bordered callout for scores/finishers.
- **Tags**: `.tag` (neutral) or `.tag.tag-g` (green border) inside `.card-tags`.

When adding new sessions, follow the existing element structure exactly — the CSS targets these class names directly with no component abstraction.
