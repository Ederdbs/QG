# 11b-diversity-across-cycles -- editor report (form pass, after it3 APPROVED)

File: `book/11b-diversity-across-cycles.qmd`. One knit of the edited chapter (installed package, wd = book, output in the scratchpad): no error, no warning, every `stopifnot()` passed, all inline values unchanged. 51 mechanical edits (one script, each pattern asserted unique). No chunk code beyond `#|` lines and the `caption`/`col.names` of table calls was touched. Numbers: none changed.

## 1. Edits applied

### Figures
- Diagram chunk (was unlabelled, `unnamed-chunk-2-1`): added `#| label: fig-cycles-diagram`; `fig-alt` rewritten (was "One cycle") as a description of the diagram; `fig-cap` extended (see wording list W1); `fig-width: 9 -> 6.5`, `fig-height: 4.2 -> 3.05` (same aspect). Reason: at 9 in the text (cex 0.62-0.72) was about 5 pt once scaled to the Typst text width; at 6.5 in it is 7-8.6 pt. Knitted image checked: boxes and labels fit, no overlap.
- `fig-cycles-gain`, `fig-cycles-diversity`: captions now give colours, n_sel, scale, replicates (W2, W3); `fig-alt` replaced by descriptions read from the cached `book/figs/cycles_gain.png` and `cycles_diversity.png` (W2, W3). The cached PNGs are 1050 x 680 px at 150 dpi (7 in), legible at 6.5 in; legends sit in empty regions.
- Citations before the figure: `@fig-cycles-diagram` (before the chunk), `@fig-cycles-gain` and `@fig-cycles-diversity` (the latter replaces "The figure below"), see W4-W6.

### Tables (all eight were bare `kable(caption=)`, unnumbered)
Each now has `#| label: tbl-cycles-*` and `#| tbl-cap:` (the `caption=` argument removed), is cited with `@tbl-...` before it appears, and has math/units in the header via `col.names`:
| old label | new label |
|---|---|
| `cycles-gain-table` | `tbl-cycles-gain` |
| `de-same-context-table` | `tbl-cycles-de` |
| `rate-fit` | `tbl-cycles-rate` |
| `crossover-by-seed` | `tbl-cycles-crossover` |
| `cycles-horizon-table` | `tbl-cycles-horizon` |
| `cap-table` | `tbl-cycles-cap` |
| `injection-table` | `tbl-cycles-injection` |
| `partition-table` | `tbl-cycles-partition` |
No other file references the old labels (grep over `book/*.qmd`, `book/scripts`, `docs/*.html`).
`col.names` changes: `alpha_max = ...`/`F_drift`/`GD_T`/`R^2`/`dF` -> `$\alpha_{\max}$`, `$F_{drift}$`, `$GD_T$`, `$R^2$`, `$\Delta F$`; `index (founding s.d.)` added to the cap and injection tables (unit in the header); DE table: `alpha DE`, `alpha greedy` -> `$\alpha$ DE`, `$\alpha$ greedy`.

### Equations
No displayed equation in the chapter; none referenced. `@eq-catalogue-alpha` cited correctly. `$F_{drift}$`, `$F_{hom}$` already in the form without `\text{}` (90's form); no `\text{drift}` found. See E4, E5.

### Callouts
- Line 277: `callout-important` -> `callout-warning` ("This is the commonest way to get a multi-cycle report wrong": a trap that produces a wrong number; the design decision it mentions, `cycle_ctx()` taking `p0` once, stays in the body). The other callout (line 651, `callout-warning`, $N_s$) already conforms. Both have titles; no `callout-caution`.

### Text
- Heading ids added so tables/prose can cite sections: `{#sec-cycles-freezing}`, `{#sec-cycles-trajectory}`, `{#sec-cycles-rate}`, `{#sec-cycles-horizon}` (the last two unused for now). Heading case already sentence case.
- Acronyms at first use: DH, QTL, GD, DE, s.e., GEBV (W7-W12).
- Relative references replaced by `@` references (W13-W22).
- Citations: no hand-typed "(Author, Year)" found.

## Prose/caption wording changes (for the quant-advice diff)

New text is marked +; removed text is quoted.
- W1 (fig-cycles-diagram caption). Old: "One cycle. Hybrids are evaluated across the pool boundary; lines are recycled inside it. The usage weights are the only channel between the two, and they are what `line_weights()` returns." New: "One cycle of `run_cycles()` (schematic; no data). Solid arrows: every $A \times B$ hybrid of the two pools is evaluated across the pool boundary, `n_sel` of them are selected (the diversity budget applies at this step), and the selection yields line-usage weights $w_A$, $w_B$. Dashed red arrows: lines are recycled inside their own pool, by intermating within the pool and deriving doubled haploids (DH). The usage weights are the only channel between the two pools, and they are what `line_weights()` returns." (everything added is read off the diagram's own labels.)
- W2 (fig-cycles-gain caption). Old: "Mean index of the selected hybrids, in founding-cycle standard deviations, averaged over five founder draws; no dispersion is drawn (paired contrasts with their standard errors are in the table below). The unconstrained ..." New: "Mean index of the 60 selected hybrids, in founding-cycle standard deviations, by cycle, for three diversity budgets $\alpha_{\max}$ (red: unconstrained; blue: 0.02; green: 0.005). Mean over five founder draws, 25 + 25 lines and 2000 markers; dots mark the cycles. No dispersion is drawn (paired contrasts with their standard errors are in @tbl-cycles-horizon). The unconstrained programme has the highest mean through cycle 7 ..." (last two sentences unchanged; "the table below" -> `@tbl-cycles-horizon`; colours from `regenerate.R:502`, 60 and the scale from the chapter).
- W3 (fig-cycles-diversity caption). Old: "... (the `GD` column; within-pool diversity is in the table of the last section). Right: ... Legend: $\alpha_{\max}$. Mean over five founder draws, no dispersion drawn." New: "... of the 60 selected hybrids (the `GD` column; within-pool diversity is in @tbl-cycles-partition). Right: ... Colours as in @fig-cycles-gain; legend: $\alpha_{\max}$. Mean over five founder draws, by cycle, 25 + 25 lines and 2000 markers; no dispersion drawn."
- W4 (before the diagram). + " @fig-cycles-diagram draws the cycle."
- W5 (end of the "The trajectory" first paragraph). Old: "... not evidence at a stated error rate. The five `cycles_*.csv` files ..." New: "... not evidence at a stated error rate. @fig-cycles-gain and @tbl-cycles-gain give the trajectory of the mean index. The five `cycles_*.csv` files ..."
- W6. "The figure below shows the diversity side." -> "@fig-cycles-diversity shows the diversity side."
- W7. "a doubled haploid derived from" -> "a doubled haploid (DH) derived from".
- W8. "are QTL with effects" -> "are quantitative trait loci (QTL) with effects".
- W9 (C10). Old: "The `GD_BS` of the 60 selected hybrids below is the between-pool component of their partition at unequal line usage, ..." New: "The between-pool gene diversity ($GD_{BS}$, column `GD_BS`) of the 60 selected hybrids below is the between-pool component of their partition at unequal line usage, ..." (defines GD at first prose use; the claim is the same.)
- W10. "puts differential evolution (`sel_de()`" -> "puts differential evolution (DE, `sel_de()`".
- W11. "its standard error (the standard deviation of the five differences ..." -> "its standard error (s.e.: the standard deviation of the five differences ...".
- W12. "selection on GEBVs after" -> "selection on genomic estimated breeding values (GEBVs) after".
- W13. "This is the subject of the next section." -> "This is the subject of @sec-cycles-freezing."
- W14. "the neutral arm of the previous section (equal usage" -> "the neutral arm of @sec-cycles-freezing (equal usage".
- W15. "(the $R^2$ column is what says so)" -> "($R^2$ in @tbl-cycles-rate)".
- W16. "the linearity of $\log(1 - F)$ (the $R^2$ column above)" -> "... ($R^2$ in @tbl-cycles-rate)".
- W17. "(\"The trajectory\")" -> "(@sec-cycles-trajectory)".
- W18. "is shown above." (freezing $p_0$) -> "is shown in @sec-cycles-freezing."
- W19. "and the table above is the only DE result of this chapter" -> "and @tbl-cycles-de is the only DE result of this chapter".
- W20. Introductions to tables: "... trajectory of seed 1 (@tbl-cycles-de)."; "... as the reference on the same estimator (@tbl-cycles-rate):"; "... varies across seeds (@tbl-cycles-crossover):"; "... selected cycles are in @tbl-cycles-horizon:"; "... 6 and 3 (@tbl-cycles-cap):"; "The cost is immediate and the return is slow (@tbl-cycles-injection)."; "(@tbl-cycles-partition)" after "...nor the `GD` column shows".
- W21. "a lower index (tables above)" -> "a lower index (@tbl-cycles-injection)".
- W22. "neither the left panel of the diversity figure" -> "neither the left panel of @fig-cycles-diversity".
- Table captions (all new `tbl-cap`, same content as the old `caption=` except where stated): gain adds "in founding-cycle standard deviations"; DE adds "cycles 0 to 12", "(founding-cycle standard deviations)", "the difference DE minus greedy", "(dimensionless)"; rate adds "per cycle", "$F_{drift}$ at cycle 15 and the ratio of the fitted rate to that of the neutral arm" (those are two of its columns); crossover adds "in mean index"; horizon adds "(founding-cycle standard deviations)" and "$k$"; cap adds "at cycles 0, 5, 10 and 15 (`none`: no cap). `max_line` is the largest number of times one line enters the 60 selected hybrids." (from `max_line_use()`); injection adds "(six founder lines per pool)" and the listed columns/cycles; partition adds "at cycles 0 and 15" and "by diversity budget ... (unconstrained, 0.02, 0.005)".
- fig-alt (three figures): new descriptions; the values quoted in them ("about 0.32 -> 0.18 / 0.21 / 0.25", "F_drift about 0.46 / 0.43 / 0.34", "ends near 12 / 11 / 9.5") are read off the cached PNGs and agree with the rate table (0.457 / 0.431 / 0.343) and the text.

## 2. Findings passed on

For `quant-writer` (content):
- **11b-M17** (from it3, not applied) lines 379-383, 408-431, 433: the gain-vs-genic correlations carry no dispersion; the unit is the founder draw (5), not the 225 run-cycles. Per the it3 verdict: cycle-removed rho is positive in all five draws (0.23 to 0.64), bootstrap over draws 0.35-0.59; the association is concentrated late (within cycles 2-6 only 0.16 pooled, within 12-15 0.84; arm ordering matches in none of cycles 2-9 and in 5 of 6 from cycle 10); arm-wise cycle-removed 0.16 / 0.35 / 0.51 (0.005 / 0.02 / unconstrained). "Follows" is stronger than a within-cycle 0.46.
- **11b-M18** lines 362-377 against 408-431: two sets of "genic variance at cycle 15": 0.001 / 0.08 / 0.22 (pool of cycle 15, lines 362-366, paired with a last-cycle gain selected from the cycle-14 pool) and 0.003 / 0.1 / 0.26 (parental pool of cycle 14, lines 425-431). Label unambiguously, preferably use the parental pool in both places.
- **11b-E1** `book/11b-diversity-across-cycles.qmd:266` (chunk `neutral-arm`): the chunk ends with a bare `c(frozen_p0 = ..., reanchored = ...)`, which prints raw console output as the result the next paragraph cites ("The first number ... The second is exactly zero"). Needs a small `kable` (or inline values) -- chunk code, so not applied.
- **11b-E2** lines 71-101 (diagram code): both pools are drawn in the same light blue (`#d1e5f0`), not the book palette (`$pool-a` #1f5f8b, `$pool-b` #d98e04); the figure cannot show "pool A" vs "pool B" by colour. Chunk code (`box_()` fills) -- quant-Rwrite/quant-writer.
- **11b-E3** lines 595-612 (`tbl-cycles-rate`): the arm column carries the code labels `neutral`, `alpha_max 0.02`, `alpha_max 0.005` (they are also used as keys in the prose chunk, so renaming needs code changes). Same for `budget` values `0.020` / `0.005` / `unconstrained` in `tbl-cycles-partition` and the `max_use` / `regime` values in the cap and injection tables.
- **11b-E4** lines 118-124 (the Balding-Nichols Beta draw): the symbols `$p_a$` (ancestral frequency) and `$p_A$, $p_B$` (pool frequencies; 90 has `$p_{Ak}$, $p_{Bk}$`) are not in `90-notation.qmd` as such; `$\bar I_t$` (mean index of the selection, line 382) is not in 90 either. Report only; add to 90 or reword. If the author wants the Beta draw referenced, it would need to be a labelled display equation (`{#eq-cycles-bn}`); it is inline now and cited nowhere.
- **11b-E5** tables use `kable(digits=)`, not `fmt()` (columns have uniform decimals, so no inconsistency; chunk code, left as is). Horizon-table cells are strings from `pc()` with sign and fixed decimals.

For the Typst check:
- `tbl-cycles-de` is the widest: 7 columns, 13 rows, headers "DE minus greedy", "$\alpha$ DE", "$\alpha$ greedy"; should fit at 6.5 in, to be confirmed.
- `tbl-cycles-horizon` cells ("+0.52 (0.40; 3/5)") in 4 columns: likely fits; check no wrapping inside cells.
- `tbl-cycles-cap` / `tbl-cycles-injection` (6 columns, the header "index (founding s.d.)" may wrap).
- Table headers now contain inline math in `col.names`; check the Typst output renders them (the same device is used in 90-notation).
- `fig-cycles-diagram` now 6.5 x 3.05 in; check text size and the left-hand arrow stubs in the PDF.

Not wrapped / out of scope: chunk-local `stopifnot()` checks, the DE/stream-shift chunks (no table/figure).

## 3. Orphaned figure files (not deleted)

The label rename `unnamed-chunk-2-1` -> `fig-cycles-diagram` orphans, after the next render:
- `book/_freeze/11b-diversity-across-cycles/figure-html/unnamed-chunk-2-1.png`
- `book/_freeze/11b-diversity-across-cycles/figure-typst/unnamed-chunk-2-1.svg`
- `book/_freeze/11b-diversity-across-cycles/figure-typst/unnamed-chunk-2-1.png`
- `docs/11b-diversity-across-cycles_files/figure-html/unnamed-chunk-2-1.png`
New names will be `fig-cycles-diagram-1.png` (html) and `.svg`/`.png` (typst). The two cached figures (`book/figs/cycles_*.png`) are included with `include_graphics` and are unaffected. `book/_freeze/11b-diversity-across-cycles/execute-results/{html,typ}.json` and `docs/11b-*.html` are stale until the batch render; the PDF embeds the old diagram.

## 4. Scratch

- Knit output went to `scratchpad/k/` only; no `Rplots.pdf` in the repo or in `book/`.
- `book/figure/` (untracked): `fig-joint-budget-1.png`, `fig-joint-pev-1.png` left alone. `book/figure/unnamed-chunk-2-1.png` (20 KB, dated 14 Nov 20:27, before this session; not created by me) IS this chapter's cycle diagram (viewed: pool A/B boxes, hybrid, select, usage, dashed recycling arrows): the scratch of an earlier knit of `11b` with the default `fig.path` in `book/`. Not tracked, safe to delete; I left it because I did not create it.
- `book/scripts/make_downloads.R` re-run: `book/downloads/11b-diversity-across-cycles.R` regenerated (contains the new `tbl-cycles-*` labels). The run also rewrote the other chapters' scripts whose `.qmd` already differ from HEAD in this worktree (00, 04c, 04d, 04f, 04g, 06, 11, 11c, 12, ...): expected, not from this pass.
