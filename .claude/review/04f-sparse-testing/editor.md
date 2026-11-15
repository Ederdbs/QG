# 04f-sparse-testing -- editor (form pass)

Chapter: book/04f-sparse-testing.qmd. Worktree: SB_quanti_gen-review-04-06. No quarto render run. book/downloads re-generated with make_downloads.R (04f and, as a side effect of an earlier source change, 04g). No chunk code was changed; only `#|` options, `fig-cap`/`fig-alt`/`tbl-cap`, the `names()`/`col.names` of two tables, prose, and callout types.

## 1. Edits applied

### Figures (11 labelled; all already had fig- labels and fig-cap; no label added or renamed)
- fig-alt on every figure was a title or a truncated copy of the caption. Rewritten as descriptions of what is drawn, read off the code: fig-sparse-pipeline, -genealogy, -taxonomy, -cv, -overlap, -testcross, -phenomics, -frontier (both panels), -genomic, -estimates (both panels), -twostage (the old text was cut off at "at each bu").
- Caption wording changes (quant-advice: please check these):
  - fig-sparse-genealogy: appended "Schematic, not simulated data: four panels are drawn by hand and the fourth (genomic sparse testing) is one random draw of `sparse_alloc()` for 12 hybrids in 4 locations with 2 locations per hybrid." (chunk: `sparse_alloc(4, 3, 4, 2, "random")`).
  - fig-sparse-taxonomy: "; dark cells are planted" added.
  - fig-sparse-cv: appended "Schematic: 8 genotypes x 5 environments, not simulated data." (`matrix(1, 8, 5)`).
  - fig-sparse-overlap: "Bars are two standard errors" -> "Error bars span the mean plus and minus two standard errors" (code: `acc_all +- 2 * acc_all_se`).
  - fig-sparse-testcross: "Schematic." appended.
  - fig-sparse-phenomics: hand-typed "after Hild Aono and Chawade (2026)" -> "after @hildaono2026".
  - fig-sparse-frontier: "Points are cell means; no error bars are drawn." added (the text already says the right panel has no error bars).
  - fig-sparse-genomic: "Colour is the strategy; solid lines are 4 locations and dashed lines 8; points are means over replicates and no error bars are drawn." (code: `aggregate(..., mean)`, `lty = ifelse(L == 4, 1, 2)`).
  - fig-sparse-estimates: "(the values are in the table below)" -> "(the values are in @tbl-sparse-median-bias)"; left panel now names the four lines (female GCA variance, GCA x location variance, SCA variance, plot h2) with "(%)"; right panel "orange where some REML fits did not converge" (legend `frac_conv < 1`).
  - fig-sparse-twostage: "(see the table above)" -> "(see @tbl-sparse-twostage-matched)".
- First citation before the float: a one-sentence citation added before fig-sparse-genealogy, -taxonomy, -cv, -overlap, -testcross, -phenomics, -frontier, -genomic, -estimates, -twostage (none was cited, or only after the figure). fig-sparse-pipeline was already cited (Scope paragraph).

### Tables
- First citations added before: tbl-sparse-taxonomy, tbl-sparse-testers, tbl-sparse-parameters, tbl-sparse-coverage, tbl-sparse-median-bias (it was cited only after the table), tbl-sparse-reproduce.
- tbl-sparse-median-bias caption: "(the left panel of the figure above)" -> "(the left panel of @fig-sparse-estimates)".
- tbl-sparse-reproduce caption: "`z` is the difference in standard errors of the difference" (ungrammatical) -> "`z` is the in-repo minus the cached accuracy divided by the standard error of that difference" (code: `z <- (acc_all - cached) / sqrt(se^2 + cached_se^2)`).
- Units in the header: tbl-sparse-median-bias column names and tbl-sparse-s2s-spread `col.names` now carry "(%)" (captions already said percent; values unchanged).
- Hand-typed author names in the Example column of tbl-sparse-taxonomy ("Li et al.", "Jarquin's", "Lubanga", "Atanda") -> Quarto citations. "NOL" kept as written (04f-E6).

### Equations
Four display equations labelled and cited: eq-sparse-breeder, eq-sparse-gca-sca, eq-sparse-kernels, eq-sparse-model. Citing sentences changed: "of the terms of @eq-sparse-breeder", "This split (@eq-sparse-gca-sca) is", "In @eq-sparse-kernels, $\sigma^2_f$ and", "In @eq-sparse-model the target is".

### Callouts
Box 1, Quick glossary, Box 3, Box 5: tip -> note (definition/clarification). Box 2: tip -> warning (the entry-mean formula assumes balance and gives a wrong number in sparse trials). Box 4 and Box 6 stay tip; "Where the numbers come from" and the REML box stay note; the naming-collision callout stays warning. No callout-caution; all have titles.

### Text
- Acronyms expanded at first use: BLUP, REML, SCA, GCA, GLS, DH, AR(1), G x E, GBLUP, PEV, CV (at the validation section; see 04f-E7), MSE, BLUE, NIRS, PCA.
- "Section @sec-sparse-phenomics" -> "@sec-sparse-phenomics" (Quarto already prefixes "Section").
- Relative references replaced: "simulations below" (Box 2 table) -> "simulations of @sec-sparse-results"; "The experiment above" -> "The experiment of @fig-sparse-overlap"; "the callout above" -> "the callout in @sec-sparse-what"; "addressed only descriptively below" -> "in @tbl-sparse-s2s-spread". Left as is: in-paragraph "above" referring to the same paragraph, and "Scope below".

## 2. Findings passed on

- **04f-E1** (quant-writer; it3 verdict M17) 04f:1964-1966. "its differences from the two-location trial are beyond two standard errors at both heritabilities" fails for 4 locations at h2 0.2 (z 1.2). Scope it to 6 and 10 locations. Not edited (changes a claim).
- **04f-E2** (quant-writer) 04f:301-311 and 90-notation.qmd. $\Delta G_t$, $i$ and $t$ (cycle length) of eq-sparse-breeder are not in 90-notation, and `t` is already "testers" in the mating-design row ("$t$, $r$, $\rho(t,r)$"). Add the symbols with the clash noted, or rename the cycle length.
- **04f-E3** (quant-writer) 04f:327, 457, 674. Boxes 1-3 hold pipe tables with no `tbl-` label, and the callouts are numbered by hand ("Box 1" ...), so "Box 4" is not a cross-reference. Make them real floats or accept them as unnumbered inline tables; a book-level decision.
- **04f-E4** (quant-Rwrite/writer) 04f:911-930. `fmt(rec, 3)` prints a console matrix (plots, fem_cover, disconnected_pairs, reliability for three designs) as the result of the recipe. Needs `knitr::kable()` plus a `tbl-` label and `tbl-cap`; the call is mid-chunk, so it is a code change I did not make.
- **04f-E5** (quant-Rwrite) palette. fig-sparse-pipeline (amber #d98e04 for the "sparse testing lives here" annotation), fig-sparse-genealogy and -taxonomy (pool-A blue #1f5f8b for "observed/planted") use the pool colours with a non-pool meaning; fig-sparse-cv uses its own blue/orange. Colours are chunk code, not changed.
- **04f-E6** (quant-writer) 04f:581. "NOL" (Lubanga design) is undefined in the chapter; needs the full name from the paper.
- **04f-E7** (quant-writer) 04f:579-582 and 621. First prose use of CV is in tbl-sparse-taxonomy ("CV1" ... "CV5"), before the expansion in the validation section. Expand in the table caption (the labels are allocation names of @li2026, not cross-validation schemes) or move the expansion earlier; the wording touches the warning callout's claim, so not edited.
- **04f-E8** (Typst check, not verified; no render) wide figures: fig-width 9-9.5 in is scaled to the 6.5 in text width (about 0.68), so `cex` 0.68-0.85 text is about 4-5 pt: fig-sparse-pipeline, -genealogy, -taxonomy (six two-line panel titles), -testcross, -phenomics, and the two-panel -frontier and -estimates (9 in). Check each in the PDF; the remedy (smaller fig-width, larger `cex`) is a chunk-code change.
- **04f-E9** (Typst check, not verified) wide tables: tbl-sparse-minimal (11 columns), tbl-sparse-contrasts (9 columns, strings such as "optimised_blocks - random"), tbl-sparse-primary (8 columns, free-text Model/Conclusion), tbl-sparse-coverage (8 columns, long headers), tbl-sparse-reproduce (8 columns), tbl-sparse-parameters (free-text Source). tbl-sparse-minimal is a candidate for transposing or splitting by heritability (layout change, reported not done).
- **04f-E10** (quant-writer) tbl-sparse-minimal prints "Rel. accuracy" and "Rel. cost" as fractions (0.95) while the text quotes percentages; units are not in the header. Author to choose one form.

## 3. Orphaned figure files
None: no chunk label was added or renamed.

## 4. Housekeeping not completed
- `book/figure/` (untracked knitr scratch from the it3 knit; 0 tracked files) was NOT removed: the shell gate rejected the delete three times even after the facts were presented. Remove it by hand or approve the command. There is no `Rplots.pdf`.
- The worktree's `docs/` already carries modified files and many " 2"-style untracked duplicates from earlier renders; this pass did not create or touch them.
