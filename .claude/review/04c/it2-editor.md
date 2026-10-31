# 04c -- quant-editor, close-step form fix (after close-recheck.md)

## Edits applied (book/04c-alphasimr-pipeline.qmd)

### 1. Figures -- 04c-E3 (reopened) CLOSED
- `fig-alphasimr-cycles` (chunk ~:1813-1846): both legends moved out of the plotting region into the bottom
  margin, one column, centred under each panel, anchored a fixed 0.8 in below the x axis
  (`grconvertY(... "inches" ...)`, `xpd = NA`). Placement no longer depends on the data range, so no founder
  draw can make it collide with the bars. `legend_pos` argument dropped from `panel()`; `mar` bottom 4.2 -> 9;
  `fig-height` 4 -> 5. Label, `fig-width: 6.5`, `book_pal` colours, caption and fig-alt unchanged.
- Verified: drew the chunk at 6.5 x 5 in from two independent runMacs2 founder sets of 48 draws each (different
  numbers, e.g. right-panel ylim top 0.18 vs 0.20). Both PNGs are clean. The legend sits below "Cycle" and
  clears it, and nothing is clipped. Scratch: /Users/ederdbs/.claude/jobs/1f3dbb75/tmp/draw5.png, draw6.png.

### 2. Tables -- tbl-subcap
- All 15 subcaps in 6 tables (`tbl-alphasimr-lottery`, `-breeders`, `-split`, `-rep1`, `-paired`,
  `-pipeline`) are now short plain text, with no backticks, math, emphasis, subscripts or @refs. The column
  definitions, `@caballero2002`, `@tbl-alphasimr-cycle1` and `@tbl-alphasimr-rep1` moved into the parent
  `tbl-cap` as "(a) ... (b) ...". The breeders entry `*i r* σ~A~` became `$i\,r\,\sigma_A$`, which matches
  90-notation's $R = i\,r\,\sigma_A$. The wording of each definition is unchanged.
- No other book/*.qmd uses `tbl-subcap`, so there is nothing to report outside 04c.

## Findings passed on
- None new.

## Side effects
- No label added or renamed, so no new orphans. `fig-alphasimr-cycles-1.png` in book/_freeze and docs/ is stale
  until the next render, which will overwrite it under the same name.
- book/downloads/04c-alphasimr-pipeline.R regenerated (make_downloads.R). No Rplots.pdf was left behind.
- Pre-existing untracked " 2" duplicates under docs/ are from an earlier render, not from this step. Sweep them
  after the next render.
