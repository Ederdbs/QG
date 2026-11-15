# Editor report, chapter 04 (book/04-population-sizing.qmd)

Known book-wide Typst items 00-E1, 00-E2, 00-E8 not re-reported. No render run.

## 1. Edits applied (no chunk code, no numbers, no labels changed)

Figures
- `fig-sizing-ancestry`: `fig-alt` rewritten so it describes the curves (N = 20 wanders, N = 300 departs only at the three distorters). Taken from the caption, no new claim.
- `@fig-sizing-multilocus` was never cited in the prose. Added "(@fig-sizing-multilocus plots the replicate means)" in the "Recovery is measured on replicate populations" paragraph, before the chunk.
- "in the figure" (ssd_attr deficit) replaced by `@fig-sizing-diversity`.

Tables
- `@tbl-sizing-twin` was never cited. Added "(@tbl-sizing-twin)" where the neutral twin is introduced, before the chunk.
- "the last row of the table" -> `@tbl-sizing-f4-identities`; "the ordering at equal N above" -> `@tbl-sizing-bulk-vs-ssd`; "what the table supports" -> `@tbl-sizing-block-length`; "the table therefore also gives a ... bracket" -> `@tbl-sizing-saturation`; "The values above" (N_s callout) -> `@tbl-sizing-bridge`.

Equations
- "the formula above" (SA3, the junction formula) -> "the formula $(2 + g/2)L$".

Text and cross-references
- A2/A5/A8 in the Scope-of-the-bridge paragraph: added `@sec-era-programme`, where A1--A8 are declared (the chapter's first mention already linked it).
- Checked and clean: all `@sec-/@tbl-/@fig-/@eq-` targets exist; all nine bibliography keys exist; no hand-typed "(Author, Year)"; no `callout-caution`; every callout has a title; no footnotes; heading case consistent; SI spacing OK; every figure has `fig-alt`; every table chunk has `tbl-` label and `tbl-cap`.

## 2. Findings for quant-writer (not applied)

- **04-E1** `04-population-sizing.qmd:85-89`. The SA3 chunk prints a bare named vector (chromosomes, markers, total_cM, morgans) as raw console output. If it is meant as a result, it should be a labelled table (or the numbers moved to inline `r` in the prose, which already gives total cM and Morgans). Changes chunk code, so not applied.
- **04-E2** `04-population-sizing.qmd:125-130`. `f2_distorters` is printed as a raw data frame. It is the model-input table that SA5 and the callout refer to ("The three distorters below"), so it needs `#| label: tbl-sizing-distorters`, `#| tbl-cap:` (type, chromosome, position in cM, k, fitnesses; "bin numbers are placeholders") via `knitr::kable()`, and a `@tbl-sizing-distorters` citation in SA5. Changes chunk code.
- **04-E3** `04-population-sizing.qmd:891-892` (`fig-sizing-multilocus`). `legend("topright")` sits on the k = 3 and k = 5 curves, which reach P close to 1 for N > 100 (alt text says 0.99-1). Move to `"right"`, `"bottomright"` or `inset`, or place it outside the panel. Chunk code change.
- **04-E4** `04-population-sizing.qmd:562-563` (`fig-sizing-ancestry`). Horizontal legend at `topleft` with `ylim = c(0, 1)`; the N = 20 curve can reach 0.9-1 at the left edge. Check in the rendered PNG and extend `ylim` (e.g. c(0, 1.1)) or move the legend if it overlaps.
- **04-E5** `tbl-sizing-bridge` (1075-1105). Ten numeric columns (n_F2, D, theta, GD, Ns, fixed, GD_random, GD_random_sd, GD_greedy, bound) are likely too wide at Typst A4 width with `fmt(.,4)`. Split into two tables (diversity identities: n_F2, D, theta, GD, Ns, fixed, bound; subset comparison: n_F2, GD_random (s.d.), GD_greedy, GD, bound), or fold `GD_random_sd` into `GD_random` as "mean (s.d.)" as `tbl-sizing-bulk-vs-ssd` does. Splitting is yours to decide.
- **04-E6** `tbl-sizing-saturation` (6 columns, long text cells) and `tbl-sizing-working-numbers` (3 columns, cells of 150-250 characters). Check the Typst PDF for overflow or wrapping; this is separate from 00-E8 (justification) and only becomes a finding if the cells wrap badly.
- **04-E7** Column-name inconsistency between tables for the same quantity: replicate count is `replicates` in `tbl-sizing-ssd-grid`, `n_rep` in `tbl-sizing-bulk-vs-ssd` and `replicates` in `tbl-sizing-verify-junctions`; s.e. is "se", "s.e." and "SE" across captions. Unify (`col.names` only).
- **04-E8** Notation (`90-notation.qmd`, "Population sizing"): `n_{rep}` (replicate count, in prose and captions), `n_{final}` (inline, F4 lines after attrition), `c` (column of `tbl-sizing-f4-identities`), `m` (markers, defined in the main table but used with a different role in eq-sizing-div's text) are not in the section's symbol table. Report; the notation file is not mine to extend.
- **04-E9** Callout use: "The distorters are plausible, not measured" is typed `callout-warning`; it fits only if read as "a trap that produces a wrong number" (using it to size field area). Left as is. If the book reserves warnings for numerical traps, it would be an `callout-important` (design decision: one fixed configuration). Your call.
- **04-E10** Tables `tbl-sizing-f1` (`formatC(digits = 3, format = "g")`) and `tbl-sizing-saturation` (`fmt_ms`, mixed digits) do not use `fmt()` throughout; the caption of `tbl-sizing-f1` states the three-significant-digit rule, so I did not touch it. Chunk code, not applied.

## 3. Orphaned figure files

None. No chunk label was added, renamed or removed; `fig-sizing-diversity`, `fig-sizing-ancestry`, `fig-sizing-multilocus` keep their PNG names.

## Side effects to handle at close

- `book/downloads/04-population-sizing.R` is generated from the chapter: re-run `Rscript book/scripts/make_downloads.R` after the last edit (prose changed in the edits above).
- Chapter source changed, so `book/_freeze/04-population-sizing/` will re-execute on the next render (the chapter has expensive live chunks: 20 live populations x 20 grid sizes).
