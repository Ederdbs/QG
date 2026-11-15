# 09-optimal-contributions -- editor (form pass)

File: `book/09-optimal-contributions.qmd`. No render run. Scratch (`book/figure`, `Rplots.pdf`): none present. `book/scripts/make_downloads.R` re-run.

## 1. Edits applied

Chunk options, labels, fig-alt, fig-cap: nothing to add. Every figure (fig-ocs-relaxation, fig-ocs-frontier) and table (11 `tbl-ocs-*`) chunk already has label, caption, and the two figures have `fig-alt`. No `callout-caution`. Callout types are consistent (note / warning x2 / tip). No chunk code touched.

Cross-references (Checklist 2, 3, 5: cited before the table appears, `@` instead of "above/below"). Every wording change, for the quant-advice diff:

| # | Location (after edit) | Before | After |
|---|---|---|---|
| 1 | l.15 | "the optimal-contribution literature" | "the optimal-contribution selection (OCS) literature" (acronym at first use; OCS was first used undefined in the l.159 heading) |
| 2 | l.36 | "(A7)" | "(A7 of @sec-era-programme)" |
| 3 | l.50 | "(A8)" | "(A8 of @sec-era-programme)" |
| 4 | l.80 | "the section on the bound below reports it" | "@sec-relaxation reports it" |
| 5 | l.98 | "1000 x 0.1 x $\alpha_{\max}$ index units" | "$1000 \times 0.1 \times \alpha_{\max}$ index units (@tbl-ocs-penalty)" (table now cited before it appears) |
| 6 | tbl-ocs-penalty caption | "0.1 x alpha_max ... 1000 x overshoot" | "0.1 × alpha_max ... 1000 × overshoot" (typography only) |
| 7 | l.119 | "The bound derived below treats the budget as exact." | "The bound of @eq-ocs-bound treats the budget as exact." |
| 8 | l.257 | "returns the minimum over a grid, doubles" | "returns the minimum over a grid (one row per $\lambda$ in @tbl-ocs-relaxation), doubles" (cite before table) |
| 9 | callout warning, l.377 | "...penalised value $V = ...$, not the index" | "... $V = ...$ (@tbl-ocs-convergence), not the index" (cite before table) |
| 10 | l.436 | "not the optimum." | "not the optimum. @tbl-ocs-frontier lists a subset of its plans." (cite before table) |
| 11 | l.483 | "a density and an ascertainment scenario, **but the index is not**" | "... scenario (@tbl-ocs-panel-seed1), **but the index is not**" |
| 12 | l.516-517 | "with the thinning below, ... (simulation seeds 1 to 20;" | "with the thinning of @tbl-ocs-thin, ... (simulation seeds 1 to 20; @tbl-ocs-panel-spread;" (tbl-ocs-panel-spread was never cited in prose) |
| 13 | l.541 | "seed 1, the draw above, is" | "seed 1, the draw of @tbl-ocs-panel-seed1, is" |
| 14 | l.543 | "equals the live table above" | "equals the live value of @tbl-ocs-panel-seed1" |
| 15 | l.552 | "Density adds noise." | "Density adds noise (@tbl-ocs-thin)." |
| 16 | l.630 | "...in the next generation as" | "...in the next generation as follows (@eq-ocs-gr-delta):" (labelled equation was never cited) |
| 17 | l.668 | "solved as a quadratic programme rather than by search" | "...quadratic programme (QP) rather than by search" (QP used undefined at l.694-ish) |
| 18 | l.674 | "The example below uses all 50 lines" | "The example below (@tbl-ocs-qp) uses all 50 lines" |
| 19 | l.729 | "allelic richness and A-NE are kept for validation" | "allelic richness and A-NE (accession-to-nearest-entry distance, @sec-catalogue) are kept for validation" |

No number, claim or code changed. `ctx$f` accessor: not used in the chapter (`ctx$fL`, `ctx$p0` are exact names).

## 2. Findings passed on (nothing here changes a number)

- 09-E1 `book/90-notation.qmd` -- owed entries for $\alpha_{\text{trunc}}$, $\theta_{\max}$, $V(\lambda)$, $\bar u_S$ (= 09-M9 of it2). They are defined in the chapter text (l.18-65, l.205-210, l.423); `$\alpha_{\max}$` is already in the table (l.288). For quant-writer; I did not edit the notation chapter.
- 09-E2 l.~553 (`(see the warning below)` in the thinning paragraph) -- a relative reference to an unnumbered callout. Quarto 1.10 can cross-reference a callout only with an id prefix (`#wrn-...`), which would number it "Warning 1" and appear nowhere else in the book (no chapter uses callout ids). Not applied. Options for quant-writer: reword to name the callout title ("the callout on `null_distribution()` below"), or adopt callout ids book-wide.
- 09-E3 All 11 tables print raw `fmt(data.frame)` column names (`alpha_max`, `bound_term`, `rel_sd_median`, `within_1sd`, `Ne_par`); the captions define each one in words, but headers carry no symbols or units, and there is no `col.names`. Mechanical only if the chunk call is changed (`col.names` on a kable call), which is chunk code -> quant-writer / quant-Rwrite.
- 09-E4 fig-ocs-frontier: the frontier line uses `#1f5f8b`, the pool-A colour of the book palette, for data that is not pool A (the greedy frontier); fig-ocs-relaxation hard-codes `#b2182b`, `grey45`. `book_pal` in `_common.R` exists (`A`, `B`, `loss`, `ink`, `mid`). The frontier should not use pool A blue. Code change -> quant-Rwrite.
- 09-E5 Flag for the Typst check (no render, so unverified): (a) tbl-ocs-relaxation, 16 rows x at least 7 numeric columns (lambda, index, theta, GD, ..., alpha, bound_term), four decimals; (b) tbl-ocs-thin, 7 columns (markers, bias, se, rel_sd_median/min/max, within_1sd), the widest header strings; (c) tbl-ocs-qp, 5 columns, 8 rows, fine; (d) fig-ocs-relaxation legend `bottomright` with four entries may cover the greedy points near the truncation corner at 6.5 in width, and the in-plot labels `random`/`trunc_cap`/`truncation` may collide with it; (e) fig-ocs-frontier label "truncation" at `min(fd$index)`.
- 09-E6 l.~613 callout-tip "Quote $\alpha_{\text{trunc}}$ and the budget with the panel that produced them": the content is a trap that yields a wrong comparison (an $\alpha$ across differently genotyped studies), the checklist's `callout-warning`. Not changed: a type change alters the book's emphasis; quant-writer to decide.
- 09-E7 Style notes, not applied: "25 + 25 lines" and "NP x itermax" keep the plain "x" in code-adjacent text; consistent with the rest of the book.

## 3. Open non-blocking items from it2 for quant-writer (M7-M11, unchanged by me)

- 09-M7 convergence paragraph after tbl-ocs-convergence ("the same count is not enough at larger lambda") is asserted and shown nowhere; measured relative difference 4000 vs 64000 iterations is 4.1e-5 (lambda 30) falling to 6.3e-8 (lambda 1000). Conservative, but unsupported as written.
- 09-M8 "the $10^{-3}$ that `ocs_bound()` uses as its tolerance" is applied to V at lambda = 10 (about -4.87); `ocs_bound()` applies `tol` to `V + lambda theta_max` (about 1.55). `converged` is a stalling criterion on the doubling, not a certificate.
- 09-M9 notation entries (= 09-E1 above).
- 09-M10 thin-panel paragraph: "a thin panel does not bias the ceiling on average" -> what the numbers carry is "no bias detected, resolution about 0.002" (mean difference -0.0004, s.e. 0.0011 at 250 markers; mean alpha_trunc about 0.04).
- 09-M11 assumption 3: "an upper bound on what the same plan delivers when selection runs on predicted values" is loose; the bounded quantity is the true index of the plan an exact optimiser finds on truth against the plan it finds on predictions.
- 09-M12 (cross-chapter, owned by other reviews): 07:1053-1054, 10b:641-643, 02b:745-756, CLAUDE.md "same diversity" phrasing.
- `book/data/ocs_panel_sweep.csv` is untracked (`??`); the chapter reads it and the downloadable script fetches it from GitHub raw: it must be committed.

## 4. Orphaned figure files (do not hand-edit docs/)

The chapter's old unnamed chunks are replaced by labelled chunks (`fig-ocs-relaxation`, `fig-ocs-frontier`). After the render these are orphans:

- `book/_freeze/09-optimal-contributions/figure-html/unnamed-chunk-6-1.png`
- `book/_freeze/09-optimal-contributions/figure-html/unnamed-chunk-9-1.png`
- `book/_freeze/09-optimal-contributions/figure-typst/unnamed-chunk-5-1.svg`, `unnamed-chunk-6-1.svg`, `unnamed-chunk-8-1.svg`, `unnamed-chunk-9-1.svg`
- `docs/09-optimal-contributions_files/figure-html/unnamed-chunk-6-1.png`
- `docs/09-optimal-contributions_files/figure-html/unnamed-chunk-9-1.png`

The editing in this pass created no new orphans (no label added or renamed). The Typst `unnamed-chunk-5/8` files are orphans from earlier chunk numbering; confirm against the rendered HTML/Typst before deleting.
