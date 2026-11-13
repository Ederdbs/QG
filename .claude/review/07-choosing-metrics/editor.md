# 07-choosing-metrics -- editor (form) pass

File edited: book/07-choosing-metrics.qmd. No render run. No stray files (knitr scratch went to the scratchpad; book/figure does not exist). The edited chapter purls and parses (`knitr::purl` + `parse`).

## 1. Edits applied

### Figures (4 figures labelled, 1 already labelled)
- `cost_scaling.png` chunk: added `#| label: fig-choosing-cost-scaling`; cited at the head of Finding 2 (new sentence, see PROSE list).
- `metric_redundancy.png` chunk: `#| label: fig-choosing-redundancy`; cited in "Assumptions and scope" paragraph.
- `de_convergence.png` chunk: `#| label: fig-choosing-de-convergence`; cited in "What was run".
- `fig-ne-par-at-fixed-theta` (already labelled, caption and alt present): now cited with `@fig-ne-par-at-fixed-theta` before it; caption "the band of the next chunk" replaced by the chunk name (PROSE list).
- Captions and `fig-alt` already existed on all five; not rewritten.

### Tables (7 labelled, `caption=` moved to `#| tbl-cap:`; no code changed beyond removing the `caption =` argument)
- `tbl-choosing-recommendation` (top table), `tbl-choosing-identity`, `tbl-choosing-cost`, `tbl-choosing-de`: caption text moved verbatim (one wording change in the first, see PROSE list).
- `tbl-choosing-live-cost` (was `live-cost`, an unnumbered data frame printed by `df-print: kable`): caption written from `cost_per_eval()` and the chunk.
- `tbl-choosing-accuracy` (was `f5-accuracy`) and `tbl-choosing-kinds` (was `f5-kinds`): captions written from the code (n, N, seeds, B, columns, units, s.e.).
- `tbl-redundancy-residual`: already labelled and cited; unchanged.
- Every table is cited with `@tbl-` before it appears.

### Equations
- `@eq-collapse-f`, `@eq-collapse-theta` labelled and cited already. Nothing changed. Symbols checked against 90-notation: see 07-E4.

### Callouts
- Three callouts (warning, note, warning), all typed correctly and titled; no `callout-caution`. No change.

### Text
- Acronyms defined at first use: DE, OCS, GD, PCA, MAF, GBLUP, SWAR, F_BN (new parentheticals, PROSE list).
- `@sec-collapse` replaces "derived below" (Five findings paragraph).
- `ctx$f`: only occurrence is the callout text explaining the trap (correct); code uses `ctx[["f"]]`. "Five findings" is consistent with the five Finding sections; no "three findings" in the chapter.
- No hand-typed (Author, Year) citations found.

## PROSE / CAPTION WORDING CHANGES (for quant-advice to check)
No number, claim or sign changed. Each is an added definition, a cross-reference or a verbatim move.
1. Line 28-30: "The recommendation is **two** metrics inside the optimiser" -> "The recommendation (@tbl-choosing-recommendation) is **two** metrics inside the optimiser (differential evolution, DE)".
2. Line 59: "derived below" -> "derived in @sec-collapse".
3. Provenance paragraph: "$F_{BN}$" (second occurrence, in "not $N$, $L$, $m$, $n$ or $F_{BN}$") -> adds ", the Balding-Nichols divergence of @sec-notation".
4. Derivation: "gene diversity $1 - \theta_S$" -> "gene diversity ($GD = 1 - \theta_S$)".
5. "the OCS literature of @sec-ocs" -> "the literature on optimal-contribution selection (OCS, @sec-ocs)".
6. Verification: "has N rows:" -> "has N rows (@tbl-choosing-identity):".
7. Callout 1: "branch-free SWAR routine" -> "branch-free SWAR (SIMD within a register) routine".
8. Finding 2 head: NEW sentence "@fig-choosing-cost-scaling shows how the cost of each route scales and @tbl-choosing-cost gives its values at the benchmark scale."
9. "The live table below times" -> "The live table below (@tbl-choosing-live-cost) times".
10. Finding 3: "It reads `metric_redundancy.csv`," -> "... (@fig-choosing-redundancy),"; "PCA shares" -> "principal-component analysis (PCA) shares"; "for MAF-threshold allele loss" -> "for allele loss at a minor allele frequency (MAF) threshold".
11. "The chunk below does the Ne_par half" -> "The chunk below (@fig-ne-par-at-fixed-theta) does the Ne_par half".
12. Caption of fig-ne-par-at-fixed-theta: "the range inside the band of the next chunk is computed there" -> "the range inside the band is computed in the chunk `ne-par-band`".
13. Finding 4: "`de_constraints.csv` holds" -> "`de_constraints.csv` (@fig-choosing-de-convergence, @tbl-choosing-de) holds".
14. Finding 5: "GBLUP model" -> "genomic BLUP (GBLUP) model"; "(the table reports both kinds;" -> "(@tbl-choosing-accuracy reports both kinds;"; "comparing the two kinds *within* each seed (sixty" -> "(@tbl-choosing-kinds; sixty".
15. Caption of tbl-choosing-recommendation: "(cached, see the provenance paragraph below)" -> "(cached; provenance in the paragraph headed 'Provenance of what is cached')"; "E-NE and A-NE are not redundant" -> "E-NE and A-NE (the nearest-entry distances of @eq-catalogue-ene-ane) are not redundant". The A-NE/E-NE gloss is read off 06 (eq-catalogue-ene-ane: distance to the nearest selected entry).
16. NEW captions (written from code): tbl-choosing-live-cost, tbl-choosing-accuracy, tbl-choosing-kinds. Check that "the prediction is scaled to unit s.d." (the `scale()` call) and "realised: mean true index of the plan" are as intended; units of `ctx$index` are stated as "index" only.

## 2. Findings passed on

- 07-E1 (code, quant-writer / quant-Rwrite). Raw console output stands in for tables, no label possible without wrapping in code: the live identity vector (qmd ~L201-205), the swap vector (~L216-220), `ne-par-band` vector (~L490-495), `f5-monotone` (`mono` and `pc` matrices, ~L722-740), `f5-blocks` (~L820). Suggest `knitr::kable(fmt(...))` with `tbl-` labels, or fold `mono`/`pc` into prose (they are already read out inline).
- 07-E2 (non-blocking, from it3, quant-writer only). M17 (capped rows "tie"/"no difference" is wrong at the book scale: 1.1097 vs 1.1056, a constant 0.0041 gap, sd 0) and M18 (greedy alpha negative under independent error at r = 0.5, sign flip unexplained). Form pass did not touch these sentences (limit (b) of Finding 4; the Finding 5 second paragraph).
- 07-E3 (relative references). "declared in the next paragraph" (~L61), "quantities in the next paragraph" (~L118), "printed above" (~L849), "as above" (~L991), cell "item 6 of the recommendation below" and "(Finding 2)" in the top table (code cells). Fix needs section labels: suggest `{#sec-choosing-recommendation}` on "The recommendation, stated" and `{#sec-choosing-cost}`, `-redundancy`, `-search`, `-error` on Findings 2-5, then `@sec-` in prose; the two table cells are code and go to quant-writer.
- 07-E4 (notation). Not in 90-notation: bold `$\mathbf{k}$` (usage-count vector; `$k_a$` is listed), `$\bar{\mathbf{p}}$` (vector form; `$\bar p_k$` listed), `$f_{(ab),(cd)}$`, `$\mathbf{z}$`, `$e$`, and `$\mathbf{L}$` (Cholesky factor of f + 1e-8 I, Finding 5), which clashes visually with the number of lines `$L$`. `$r$` is listed only as the accuracy of ghat and in the mating-design table; here it is a nominal prediction accuracy. Add rows or rename `\mathbf{L}` (e.g. `\mathbf{C}`).
- 07-E5 (palette, code). `fig-ne-par-at-fixed-theta` hard-codes `"#b2182b"` and `"grey60"`; `book_pal[["loss"]]`/`book_pal[["mid"]]` exist in `_common.R`. Colour meaning there is not pool A/B, so no pool-palette violation; hard-coding only.
- 07-E6 (number formats, code). `tbl-choosing-cost` uses `round()` and `tbl-choosing-de` uses `kable(digits = 3)` rather than `fmt()`; the top table uses `sprintf`. Not wrong, inconsistent with the checklist; left as is.
- 07-E7 (acronyms in code strings). E-NE/A-NE, MAF, and "allele loss at MAF threshold" appear first inside data-frame strings (top table cells, identity table row labels) before any prose definition. E-NE/A-NE are glossed in the first caption; MAF is not (identity row label ~L177).
- 07-E8 (Typst width, not rendered). `tbl-choosing-recommendation` (4 columns of long text) and `tbl-choosing-accuracy` (9 columns) are the candidates for overflowing A4 at 10.5 pt; check in the PDF. Wide table 9 columns could be split by method or transposed; I did not do it.
- 07-E9 (fig-alt unverifiable). The `fig-alt` of `fig-ne-par-at-fixed-theta` states that where the clouds overlap "the greedy selections have the smaller effective number of parents"; I could not check this without running the chunk. Please confirm against the plot.
- 07-E10 (downloads). `book/downloads/07-choosing-metrics.R` is stale (chunk labels `live-cost`, `f5-accuracy`, `f5-kinds` renamed): run `Rscript book/scripts/make_downloads.R` before rendering.

## 3. Orphaned files
Chunk labels changed on chunks whose output is a table or `include_graphics` (no PNG written), so the label changes orphan nothing. Pre-existing staleness, not caused by these edits: `book/_freeze/07-choosing-metrics/figure-html/unnamed-chunk-10-1.png`, `book/_freeze/07-choosing-metrics/figure-typst/unnamed-chunk-10-1.svg` and `docs/07-choosing-metrics_files/*/unnamed-chunk-10-1.png` come from before `fig-ne-par-at-fixed-theta` was labelled; the next render writes `fig-ne-par-at-fixed-theta-1.*` and these become orphans. Delete after that render, then re-render both formats (freeze `typ.json` and `html.json` must both be regenerated).
