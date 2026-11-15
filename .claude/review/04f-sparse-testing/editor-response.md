# 04f-sparse-testing -- response to editor.md (04f-E1..E10) and it3-verdict M17

Files touched: book/04f-sparse-testing.qmd, book/90-notation.qmd, book/downloads/04f-sparse-testing.R (regenerated). No result, seed or cached file changed. Knit-check (scratchpad, 10.1 s): no error, `stopifnot()` pass. No render run.

| ID | Status | What was done |
|---|---|---|
| M17 / 04f-E1 | fixed | Closing paragraph scoped to the six- and ten-location trials; the four-location step is stated with its z computed inline from `spr_d()`: 2.3 at h2 0.4 and 1.2 at h2 0.2 (verified in the knit output). |
| 04f-E2 | fixed | The cycle length is renamed from `t` to `T` and the gain from `Delta G_t` to `Delta G_T` (eq-sparse-breeder, the bullet, Box 1 table). `tau` was rejected: Kendall's tau is already in the chapter. 90-notation, "Sparse testing" table: rows `Delta G_T`, `T`, `i` added; the `T` row says it is not the `t` (testers), the cycle index `t`, Kendall's tau, nor the set `T` of testers of 05b. `i` points to the response table (`sel_intensity()`). |
| 04f-E3 | fixed | Box 1-3 tables labelled `tbl-sparse-box-terms`, `tbl-sparse-box-h2`, `tbl-sparse-box-cv` with captions, each cited once in the text before the callout. "Box N" titles and the numbering are untouched (they remain typed by hand, as before; Box 4 and the prose "Box N" references are unchanged). |
| 04f-E4 | fixed | The Box 4 chunk is split at `fmt(rec, 3)`: the new chunk `tbl-sparse-recipe` prints `knitr::kable(fmt(rec, 3))` with a caption defining the four columns; the `stopifnot` and `rel10` code moved to chunk `sparse-connectivity-check`. RNG order unchanged (set.seed(8) ... set.seed(9)); numbers identical (0.625 / 0.703 / 0.705). No new claim. |
| 04f-E5 | fixed | `#d98e04` (pipeline annotation) and `#1f5f8b` (genealogy, taxonomy planted cells) replaced by `book_pal[["ink"]]`; the grid cells are still dark on grey95, the annotation still dark text with arrow. Not re-viewed as an image (knit only). `fig-sparse-cv` keeps its light blue/orange (not pool colours, not requested). |
| 04f-E6 | fixed | "NOL" expanded as "NOL" (non-overlapping) at its first use (taxonomy table row); source: Lubanga et al. 2025 abbreviations list ("NOL, non-overlapping"). |
| 04f-E7 | fixed | The tbl-sparse-taxonomy caption now says CV is cross-validation and that Li et al.'s "CV1".."CV5" name allocation designs here. The warning callout's text is unchanged. |
| 04f-E8 | owed (render batch) | Typst: six figures 9-9.5 in wide scaled to 6.5 in, `cex` 0.68-0.85 gives about 4-5 pt: fig-sparse-pipeline, -genealogy, -taxonomy, -testcross, -phenomics, and two-panel -frontier, -estimates. To check in the PDF; remedy (smaller fig-width, larger cex) deferred. |
| 04f-E9 | owed (render batch) | Typst: six wide tables to check: tbl-sparse-minimal, -contrasts, -primary, -coverage, -reproduce, -parameters. |
| 04f-E10 | fixed | tbl-sparse-minimal prints "Rel. accuracy (%)" and "Rel. cost (%)" as percent (one decimal); caption defines both as percent of the complete design at the largest number of locations (10) in the same scenario (checked on one row: 0.8253/0.9577 = 0.8618 = complete at 10 locations; 320/0.4 = 800 plots). |

## Prose / caption / code-visible wording changes
1. 04f closing paragraph (Limits of the evidence): "its differences from the two-location trial are beyond two standard errors at both heritabilities" -> "the differences of the six- and ten-location trials from the two-location trial are beyond two standard errors at both heritabilities (the four-location step has z = [2.3] at h2 = 0.4 and [1.2] at h2 = 0.2)", z inline.
2. eq-sparse-breeder: `\Delta G_t ... / t` -> `\Delta G_T ... / T`; bullet "cycle length $t$" -> "$T$"; Box 1 row `$t$` -> "`$T$` (cycle length)".
3. "moves at least three of the terms of @eq-sparse-breeder together:" + " (@tbl-sparse-box-terms)".
4. Box 1, 2, 3 each gain a caption line (": ... {#tbl-sparse-box-...}"): "The terms of @eq-sparse-breeder and the design decisions that move each."; "Four heritability-type quantities and their behaviour under sparsity."; "The four cross-validation schemes by what is new."
5. New sentence before Box 2: "@tbl-sparse-box-h2 sets the heritability-type quantities that can be reported side by side." New sentence in the validation section: "@tbl-sparse-box-cv arranges the four by what is new."
6. Box 4: new caption of tbl-sparse-recipe; "In the one draw above the reliability" -> "(@tbl-sparse-recipe). In that one draw the reliability"; "All three designs cost N plots" gains "(@tbl-sparse-recipe)".
7. tbl-sparse-taxonomy: row text `"NOL" of @lubanga2025` -> `"NOL" (non-overlapping) of @lubanga2025`; caption sentence added on CV (E7).
8. tbl-sparse-minimal: caption sentence on the two relative columns; headers "(%)"; values x 100 (display only; `mn` unchanged).
9. Code (colour only): the amber annotation in fig-sparse-pipeline and the pool-A blue planted cells in fig-sparse-genealogy and -taxonomy now `book_pal[["ink"]]`.
10. 90-notation: three rows added to the Sparse testing table (E2).

## Housekeeping
No `book/figure` or `Rplots.pdf` was created (knit used the scratchpad `fig.path`); nothing to remove. `make_downloads.R` re-run.

## Iteration 4 verdict -- response (alt text, captions, notation)

| ID | Status | Evidence |
|---|---|---|
| 04f-D16 | fixed | fig-sparse-estimates alt and caption rewritten. Recomputed from sparse_scenarios.csv: non-converged (frac_conv < 1) 39 / 27 / 9 at k = 1 / 2 / 3, none at k >= 4; all 39 scenarios at k = 1 are non-converged (no converged point there); at k >= 2 slopes 0.845-1.076 converged, 0.787-1.480 non-converged. A stopifnot() added to the chunk pins these counts and ranges (rounded to 2 decimals as quoted). Result unchanged. The sentence at 04f:~1724 ("median dispersion slope at k = 1 ... with outliers") was not touched. |
| 04f-D17 | fixed | Caption: "four of the five panels are drawn by hand; the fourth of the five (genomic sparse testing) is one random draw of `sparse_alloc()`". Code: mats has five entries, only "Genomic sparse" calls sparse_alloc(). |
| 04f-M18 | fixed | Alt now describes the drawing: arrows(30, 13, 8, 9) leaves the underside of the stage 1 box (y = 13 under box 14-28) and ends at y = 9, below the DH box (x 1-16, y 14-28), not touching it; label 'recycle parents (GCA)' at (19, 6); second label and arrow for stage 1. |
| 04f-M19 | fixed | Data (sparse_genomic_layer.csv, aggregated as in the chunk): random, optimised_blocks, parentage have two shares (0.25, 0.5) per nLoc; complete has one point (share 1) per nLoc. Alt says so and names markers (circle = 4, triangle = 8 locations; solid/dashed). |
| 04f-M20 | fixed | 90-notation T row: "not ... or the T2 / T1 / T0 hybrid classes of @sec-mating-genomic and of this chapter" added. |
| 04f-M21 | fixed | Closing sentence reordered: "The result least in doubt is that, at a fixed number of plots, more locations raised accuracy up to about six (result 2): the differences of the six- and ten-location trials ... beyond two standard errors at both heritabilities, and the four-location step has z = [2.3] ... [1.2]." Same content, same inline z. |

Housekeeping: knit of 04f into the scratchpad (10 s, load_all of the worktree): no error, new stopifnot() passes. No book/figure or Rplots.pdf created. make_downloads.R re-run. Not re-rendered with quarto (freeze for 04f is stale: the chunk changed).
