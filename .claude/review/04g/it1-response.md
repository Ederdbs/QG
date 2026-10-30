## quant-writer

| ID | Status | Note / evidence |
|---|---|---|
| 04g-D1 | fixed | "Two component counts" rewritten: the counts are necessary only; `n_comp_cross = 1` implies `n_comp_loc = 1` when every location gets a plot (argument in text; 0 violations in 1468 random 4x4x3 allocations with all locations used); the reviewer's counter-example is a new live chunk `tbl-joint-alias` that asserts counts (1,1) and fixed-effect rank 3 of 4; the pair is now called a screen and the three-way metric "remains open". Checklist item 6 says necessary, not sufficient. No R/ edit. |
| 04g-D2 | fixed | Result 3 headline scoped: no detected gain pooled; tester family past 2 SE, not 3, four cells with one design each. |
| 04g-D3 | fixed | Causal "because ... no replication can reveal" clause deleted. |
| 04g-D4 | fixed | :121 no longer claims more lines in data (parenthesis: every line is in the data at every split); "Where this connects" bullet made conditional and states result 1 does not measure it. |
| 04g-D5 | fixed | "earlier, unpaired sweep" clause deleted (same edit as R8). |
| 04g-D6 | fixed | "could potentially raise selection response by up to 43 %" (= B1). |
| 04g-D7 | fixed | montesinoslopez2024 now "performed better than random and were less variable"; added to the better-than-random side at the "mixed record" sentence (= B2). |
| 04g-D8 | fixed | kadam2021: "raised the *expected* prediction accuracy ... (a model forecast, not a realised accuracy) and conclude that it may be worthwhile" (= B4). |
| 04g-M1 | fixed | "within `r ...` of the ceiling" (prints 0.001); same edit as R10 minus the stopifnot, left to quant-Rwrite. |
| 04g-M2 | fixed | Criterion defined as trace of GCA block / order, an A-type criterion on effects, explicitly not the mean PEV of pairwise differences; "need not rank designs identically". |
| 04g-M3 | fixed | Parenthesis replaced: GCA x location terms, correlated within family through A_f, carry a random family x location interaction, not a systematic one. |
| 04g-M4 | fixed | lell2021: "one promising design, with high accuracy and low variability" (= B3). |
| 04g-M5 | fixed | Both "30 minutes" sentences marked as one unrecorded timing; "two thirds" replaced by inline sum of kept sec_600 (16.4 min); "machine sleep" replaced by "cause not recorded" (same edit as R1, R6). |
| 04g-M6 | fixed | Same edit as R3, R4, R5, R7: step labels built from z84/z42 (`step_lab`), tester crosses/plots and "every scenario and strategy" from `js` (`tst_below`, merge on scenario x strategy), connectivity counts from `js` with stopifnot on n_comp_loc == 1, "24 cells"/"four cells positive" from `pc_all$cells`, `pot`, `nrow(jo)`. All inline expressions evaluated clean against current data. |
| 04g-M7 | fixed | Reworded as interpretation: "consistent with ..., not as a replication of it", after stating the measured result. |
| 04g-M8 | fixed | Checklist item 7 now states its evidence: four cells, one design each, past 2 SE not 3, SE without design-to-design variance. |
| 04g-M9 | fixed | Headline 1 states the 80-vs-160 made-cross step at h2 = 0.2, high SCA does not reverse. |
| 04g-B1 | fixed | = D6. |
| 04g-B2 | fixed | = D7. |
| 04g-B3 | fixed | = M4. |
| 04g-B4 | fixed | = D8. |
| 04g-B5 | fixed | Weighting now attributed to the book's convention: "as that chapter [@sec-subdivided] weights the subpopulations of @caballero2002"; algebra verified by the verdict. |
| 04g-B6 | contested | Reviewer: "no change is required"; the text already carries "(the plain mean under equal loads)". |
| 04g-B7 | fixed | volume/pages added to all 14 listed entries; journal string normalised for the four TAG entries. (melchinger2023b, lorenzi2024 still carry the TAG string; not 04g keys, left.) |

Notes for quant-Rwrite:
- D1, code side: roxygen of `joint_connectivity()` (R/18_joint_allocation.R:128-140) still says `n_comp_cross` "is what links GCA contrasts by data"; align with the chapter. A sufficient check would be a new output, e.g. the rank deficiency of `model.matrix(~ loc + female + male)` over planted plots (`qr()$rank` vs 1 + (L-1) + (nF-1) + (nM-1)); requires test + install + 04f/04g re-render.
- M2, code side: roxygen at R/18:28-30 and :101-102 still calls `joint_pev()` "the A-optimality criterion of Butler".
- 04f-sparse-testing.qmd:653 says "@sec-joint-criteria proposes one" (a three-way metric); 04g now says it remains open. Not edited (outside 04g).
- R10 stopifnot (cov_t[2] <= 0.55) not added; R2, R9, R11-R13 untouched.
- New live chunk `tbl-joint-alias` changes 04g freeze; chapter not rendered.

## quant-Rwrite

| ID | Status | Note / evidence |
|---|---|---|
| 04g-R2 | contested | Verdict timed coverage allocation (circulant c = 4, 20 x 20, 8 loc, k = 2) at 0.66 ms; "a millisecond" is an order of magnitude, supported. A wall-clock inline would make the frozen text machine-dependent. |
| 04g-R9 | fixed | Setup chunk asserts for h2 in {0.2, 0.3, 0.4} x {low, high}: s2s/s2f == 0.25 / 1, and s2f/(s2f+s2fl), s2s/(s2s+s2sl), Vg/(Vg+VgxE) all == 2/3. |
| 04g-R10 | fixed | `stopifnot(all(js$fem_cover[tester] <= (18*4/8+2)/20 + 1e-12))` in the strategy include:false chunk (cov_t[2] = 0.54875 vs 0.55); prose wording already fixed by quant-writer (M1). |
| 04g-R11 | fixed | joint-incidence: `stopifnot(sum(M) == nrow(p) * 1, all(rowSums(M) %in% c(0, 1)))`; tbl-joint-freq: `stopifnot(sum(Mc) == 2 * nrow(pl))` inside the replicate, before `NP <- 2 * nrow(pl)` is used. No RNG consumed. |
| 04g-R12 | fixed | `set.seed(21)` before `joint_alloc()` in joint-incidence; printed output unchanged (12, 12, 4/4/4). Next chunk drawing is tbl-joint-live, which seeds itself. |
| 04g-R13 | deferred | Needs user authorisation to regenerate (`regenerate.R joint`, ~30 min; would move every number in joint_*.csv). Fix when authorised: `set.seed(5050 + cell)` immediately before each cell's `make_plan()`. |
| D1/M2 code side | fixed | Roxygen of `joint_alloc()` ("optimised"), `joint_pev()` and `joint_connectivity()` in R/18: no longer "the A-optimality criterion of Butler" (now A-type on effects, not mean PEV of pairwise differences) nor "what links GCA contrasts by data"; the pair is a necessary screen, with the 2 x 2 aliasing counter-example. man/ regenerated. |
| sufficient connectivity check | deferred | New output (rank deficiency of `model.matrix(~ loc + female + male)` over planted plots) is out of scope this iteration; needs test + install + 04f/04g re-render. 04f-sparse-testing.qmd:653 ("@sec-joint-criteria proposes one") still out of sync with 04g. |

Verification: devtools::document() ok; test(filter = "joint") 24 pass / 0 fail; full test() 466 pass / 0 fail / 0 warn / 0 skip; install() from worktree ok; purled 04g run end to end against the installed package, every stopifnot passes (3.7 s). make_downloads.R re-run. No chunk added/removed/relabelled by me; not rendered (04g freeze is stale from the writer's tbl-joint-alias and these edits).

## quant-writer (editor findings)

| ID | Status | Note / evidence |
|---|---|---|
| 04g-E1 | fixed | Kept $g^f/g^m$ (the chapter inherits 04f's $\mathrm{GCA}^f/\mathrm{GCA}^m$, `s2f`/`s2m`, $\mathbf A_f$); after @eq-joint-model the text now says they are "the $g^A_i$, $g^B_j$ and $s_{ij}$ of @sec-mating, with the female pool as A; @sec-notation", and the new appendix table states the same equivalence. |
| 04g-E2 | fixed | book/90-notation.qmd: new `### Joint allocation` table after Sparse testing (minimal addition): $g^f_i,g^m_j$, $n_F,n_M$, $n_c$, $B$, $N_P$, $N_{SNP}$ ("replaces $m$, which marks the male pool"), $n_l$, $\mathbf X_P$, $SS_B$, $GD_l,GD_P$, $\mathbf Z,w$, $\mathbf A_f,\mathbf A_m$, $\sigma^2_{f\ell},\sigma^2_{m\ell},\sigma^2_{s\ell}$. |
| 04g-E3 | fixed | Chunk relabelled `tbl-joint-misspec` with a standalone caption; raw `signif(ms, 2)` replaced by `kable(fmt(t(ms), 6))` (SCA level, Mean difference, SE: -1.8e-05/1.9e-05 low, -5.7e-05/5.0e-05 high, same values as before); cited before it appears. Nothing referenced the old label `joint-misspec`. |
| 04g-E4 | fixed | fig-joint-budget at fig-width 6.5, fig-height 6.5 (native Typst width, no down-scaling; tick labels at cex 0.75 of 12 pt). Checked on a 6.5 x 6.5 in PNG from the purled run: no overlap. Not rendered. |
| 04g-E5 | fixed | Panel titles via `bquote(italic(h)^2 == ...)`; x-axis title "Configuration" added (`title(xlab =, line = 6.3)`), clear of the rotated labels in the PNG check. |
| 04g-E6 | fixed | tbl-joint-freq printed transposed (`fmt(apply(fr_a, 1:2, mean), 4)`: metrics as rows, four strategies as columns); verified equal to `t(fr)`. `fr` itself unchanged, so every inline value is unchanged. Prose "Columns:" -> "Rows:"; caption updated. |
| 04g-E7 | deferred | Typst fit can only be judged on a render, which this pass was told not to run; no content change made blind. |
| 04g-E8 | fixed | "appear below only in the label `tester k=2`" -> "appear in this chapter only in the label `tester k=2` of @fig-joint-budget". |
| 04g-E9 | fixed | Headings labelled `{#sec-joint-split}`, `{#sec-joint-strategy}`, `{#sec-joint-criterion}` (no clash book-wide); "result 1/2/3" citations in 04g now point to them (lines ~135, 357 and the checklist). Hand numbering of the headings kept (the prose calls them results 1-3). |

Verification: make_downloads.R re-run; 04g purled to scratch and sourced from book/ with _common.R against the installed package: runs end to end, all stopifnot pass. Not rendered: 04g freeze stale (new label `tbl-joint-misspec`, figure options), and 90-notation re-executes.
