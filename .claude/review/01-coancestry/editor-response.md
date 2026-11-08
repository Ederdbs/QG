# editor-response: book/01-coancestry.qmd (step 5)

| ID | Status | What was done |
|---|---|---|
| 01-E1 | fixed | l.222-ish "as the next paragraph states" -> `as the paragraph "What the scale of $\mathbf{f}$ is" below states`. The "chunk below"/"printed below" pointers (same section, chunk output) left, as the editor allowed. |
| 01-E2 | fixed | `\mathbf{1}` defined at first use in the preamble of eq-vanraden-g (vector of ones of conforming length, N for both uses before l.260). The later definition with eq-f-matrix is kept (it adds length m and J). |
| 01-E3 | fixed | `m` named as the number of markers at its first use ("L lines, m markers"); `M^H` named "the hybrid dosage matrix (one row per hybrid, m columns)" in the sentence introducing eq-hybrid-dosage. |
| 01-E4 | owed -> 90 | Symbols absent from `book/90-notation.qmd`: `\overline{G}_{ii}`, `\mathbf{1}_S`, `p_{b,k}`, `q_{b,k}`, `\bar f^{L}_{AB}`; `GD_S` appears there only as `GD`. Chapter 90 not edited. |
| 01-E5 | contested (not done) | No other chapter cites these heads: grep of `book/*.qmd` finds no `@sec-` to them and only `@sec-coancestry` / `@sec-why-not-g` / `@sec-f-molecular` are used elsewhere. In-chapter, only the one pointer fixed in E1 refers to "What the scale of f is", and it now does so by name. "A limit of constraining this matrix" is not cited. Promoting would add ids nobody uses and change the TOC/section numbering of a frozen chapter. |
| 01-M14 | fixed | Two names, one per quantity. "Base-population floor" = m^-1 sum_k (p_{b,k}^2+q_{b,k}^2) (in "What the scale of f is" and in the G_0.5 paragraph, where it replaces "the floor of @eq-hp-ibs-ibd"). "Panel floor" = m^-1 sum_k (p_k^2+q_k^2) with p_k the frequency in the N hybrids (the f-summary paragraph, now stating that it is an identity of the set and not a measurement of the base-population floor; and the G_0.5 closing sentence "not the panel floor of the marker panel at hand"). A third use, "0.5 is the floor of the diagonal", now reads "the minimum of the diagonal". Chunk `panel-floor` and its `floor_p` object untouched. |
| 01-E6, 01-M15 | not mine | quant-Rwrite: chunks and R/ untouched. |

No number, claim or chunk code changed. Prose-only edits in l.26, 33-36, 72-74, 221-222, 233, 288-296, 315, 415, 419.

Checks: `Rscript book/scripts/make_downloads.R` run (01-coancestry.R regenerated); `knitr::knit` of the chapter under `pkgload::load_all` with `_common.R` completed with no error (output in the session scratchpad). No book/Rplots.pdf present. Not committed, not rendered.

## quant-Rwrite rows (step 5, code side)

| ID | Status | What was done |
|---|---|---|
| 01-E6 | fixed | Seven console vectors became labelled tables (`knitr::kable` on a two-column Quantity/Value data frame, values through `fmt()`, 4 decimals; `sum_G` block keeps 4 significant digits via `format(digits = 4)` because `fmt()` would round the round-off residue and `Ns_on_G` to 0 / a wrong magnitude). Labels, each cited with `@tbl-` in the sentence that introduced the vector: `tbl-g-sums` (was l.115-119; cited at the `theta_S_on_G` mention, the `sum_G` sentence and the `min_G` mention), `tbl-ns-on-f` (l.138; chunk label `ns-on-f` renamed), `tbl-subset-sum-mc` (l.175; one clause added to the preceding sentence naming the Monte Carlo check, no claim changed), `tbl-f-summary` (l.272-275; cited at "minimum of f" and "Everything in ... is inside [0, 1]"), `tbl-panel-floor` (l.301-304; chunk label `panel-floor` renamed), `tbl-diagonal` (l.322-325 and l.333 merged into one table of four rows; its `fmt()` print moved below the stopifnot block, the stopifnots untouched), `tbl-g05-range` (l.431, `range(G05)` -> min/max). "printed below" wording replaced by the @tbl- citation at l.127, 238, 342, 413. `args(vanraden_G)` and `cat(deparse(molecular_coancestry))` left as listings. Not merged as the editor suggested: l.115-119 and l.138 stay two tables because prose sits between the two chunks. Every stopifnot is unchanged and passes; every printed number equals the previous output (min f 0.6448, 75.7129 vs 75.5192 s.e. 0.1065, 0.3617, range 0.579-1.327). Captions carry constants that are chunk code (1000 subsets, 20000 draws, n = 100, MAF 0.30 / 0.15). |
| 01-M15 | fixed | `R/01_metrics.R` header: now says the coancestry-based metrics read `ctx[["f"]]`, and that `theta_from_freq()`, `he_nei()` and `freq_metrics()` read `colMeans(X[idx, ])` (freq_metrics() also the frozen `ctx[["p0"]]`). Comment only, ASCII. |

Checks: `devtools::document()` (no Rd change), `devtools::test()` 0 fail / 0 warn / 0 skip / 492 pass, `devtools::install()` done, chapter knitted under `pkgload::load_all`, no error. `make_downloads.R` rerun. Not rendered with Quarto, so the `tbl-` cross-references are untested by Pandoc. No Rplots.pdf.
