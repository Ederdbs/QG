# 04c-alphasimr-pipeline -- audit, iteration 1

Scope: `book/04c-alphasimr-pipeline.qmd` (1873 lines), `R/13_alphasimr_bridge.R`.
Read-only. Nothing under `book/_freeze`, `docs/` or `book/` was written; no `book/Rplots.pdf`.

## Method

- `knitr::purl()` of the chapter -> `ch.R`; executed from `book/` after
  `pkgload::load_all("..")`, graphics to a scratch PDF. **Three independent
  executions** (run1, run2, run3), plus the committed freeze (`execute-results/html.json`,
  hash equal to the current `.qmd` md5, so the freeze is current) as a fourth sample.
- All 188 inline `` `r ...` `` expressions extracted with a regex and evaluated in each
  run's session: 0 errors. 61 of 188 differ between run1 and run2; every one of them is
  in Step 8 or is the wall-clock line 165.
- Every `stopifnot()` passes in all three runs; no warnings emitted (including from
  `stage2_select()`). Runtime ~1.8 min per execution.
- Installed `hybdiv` exports every function the chapter calls (checked against
  `getNamespaceExports`); installed `alphasimr_rrs_cycle` body equals `R/13`.
- Extra experiment: `runMacs()`/`runMacs2()` with `nThreads = 1` are still not
  reproducible from `set.seed()` (both `identical(...) == FALSE`), so the
  non-reproducibility is not thread scheduling. Supports the chapter's Step 1 claim.

## What holds

- Line 240 ("two independent executions agree on every number in Steps 1 to 7 except
  the wall-clock seconds and the `runMacs` rows"): **confirmed** -- Steps 1-7 objects
  (`vtab`, `lottery`, `traj`, `sweep_q`, `grid`, `jensen`, `idx_tab`) bit-identical
  across runs and equal to the freeze.
- Step 1: `same_twice` = TRUE/FALSE, `R_stream_same_after` = TRUE/TRUE in all runs;
  `runMacs` adjacent `r^2` / floor = 11.7 (freeze), 13.0, 13.5; "overall barely above"
  (0.0119 vs 0.0101) stable.
- Every `r if (...)` verdict in Step 8 (lines 1408, 1413, 1683-1689, 1709, 1715, 1718,
  1727) came out the same in all four executions. Paired `t` at 48 draws:
  `gd_elite_mean` -7.5 / -7.9 / -5.5 / -4.8; `hybrid_meanG` 14 / 18.2 / 18.6 / 12.3;
  `GD_BS` 11 / 9.5 / 6.5 / 7.5.
- Hand-written Step 8 directions that survive all four executions: `F_ST`, `GD_BS` and
  heterosis-divergence share rise; `GD_T_other` falls; `GD_T_fixed` rises from 0;
  `GCA_dominance_share` rises (t 3.9-6.3); `cor_perse_GCA` falls (t -3.9 to -6.0) and
  stays below Step 6's 0.997 (max 0.951); mean-testcross pooling correlation 0.87-0.93.
- Seeding of founder draws: `set.seed()` immediately before every `quickHaplo()`/`runMacs()`
  call (lines 81, 122-129, 211-213, 280, 1041) and inside `alphasimr_founder_pools()`;
  both RRS arms branch off one `fp_s` (line 1533-1535), pairing asserted (1538).
- No reads from `report/`, `data/` or `reference/`; no cached files; chapter correctly
  says none are needed.

## Findings

### 04c-R1 -- medium -- mechanism sentence contradicts the chapter's own decomposition; dominance-part direction flips between executions
`book/04c-alphasimr-pipeline.qmd:1409-1411, 1423-1424` (also 876-878)

Evidence: `GCA_var_dom` split 0 -> 1000: freeze 0.054 -> 0.053; run1 0.064 -> 0.032;
run2 0.051 -> 0.046; run3 0.054 -> **0.085**. Its direction flips with the MaCS draw.
The `gca_only()` split that decides line 1408 was add/dom = 0.220/0.102 (freeze),
0.331/0.061, 0.196/0.088, **0.164/0.149** (run3: close to flipping, handled
conditionally, fine). But line 1423 states unconditionally "the dominance weights
(1 - 2 p_Bk) move away from zero and a growing part of a line's combining ability is
invisible to its own genetic value" -- offered as the mechanism, while the chapter's own
measurement says the rise in the ratio is driven by the *additive* part falling, and the
dominance part does not grow in three of four executions. The helper `dom_change`
(line 1328) is computed and never used, and `cov_frac_max` (1320) likewise -- the
conditional that would have handled this was started and not wired in.
Fix: replace 1423-1424 with a sentence conditioned on `dom_change` (sign and its t
across splits), and attribute the rise in the ratio to the additive part, which is what
`gca_only()` measures; delete `cov_frac_max` or use it.

### 04c-R2 -- medium -- hand-typed, unverifiable "24 pairs" anecdote; overstated near-threshold language
`book/04c-alphasimr-pipeline.qmd:1826-1828` and `1719-1721`

Evidence: "has been seen both above and below `t_crit` at 24 pairs" is a hand-typed
number and a historical claim no chunk produces. Measured: at 48 pairs `|t|` for
`gd_elite_mean` is 4.8-7.9 over four executions; splitting run3 (the weakest) into
halves gives t = -3.03 and -4.17 (t_crit,23 = 2.07); over 2000 random 24-subsets of
run3's draws P(|t| < t_crit) = 0.03. Lines 1719-1721 ("the selection component ... is
of the same order as its paired standard deviation ... so the conclusion, not only the
number, is what the `t` decides") are true per draw (mean/sd ~0.7-1.1) but read as
"near threshold", which `t` = -5 to -8 is not.
Fix: drop the anecdote or compute it (e.g. the 24-subsample probability, inline); say the
per-draw effect is ~1 paired s.d. and the 48-draw `t` is far from `t_crit`.

### 04c-R3 -- low -- the chapter's central Step 1 claim is printed, not asserted
`book/04c-alphasimr-pipeline.qmd:132, 150-158`

Evidence: only `R_stream_same_after` is asserted; "Yet the third column says the
haplotypes differ" rests on a printed `FALSE`. If an AlphaSimR/MaCS update made
`runMacs()` reproducible, the render would pass and the prose (and the callout, and
CLAUDE.md policy rationale) would silently be wrong.
Fix: `stopifnot(identical(qa@geno, qb@geno), !identical(ma@geno, mb@geno))`, or make
the sentence conditional. Optional: one sentence that `nThreads = 1` does not change it
(measured here).

### 04c-R4 -- low -- Steps 3-4 draws not reseeded; standalone-reproducibility claim overstated
`book/04c-alphasimr-pipeline.qmd:370, 386-387, 498-503`; claim at `236-239`

Evidence: `setPheno(pop)`, the three `randCross()` building `mixed`, and the Step 4
`makeCross()`/`makeDH()` lottery inherit R's stream from `set.seed(101)` (line 280)
through chunk order. `mixed` then feeds all of Step 6's per-se block, and line 518
asserts on the lottery outcome. Results are reproducible end-to-end (confirmed), but
lines 236-239 claim each step "is reproducible on its own", which holds only for the
founder draws.
Fix: `set.seed()` immediately before line 370, 386 and 498 (moves the frozen Step 3-6
numbers: re-render), or narrow the claim to founder draws.

### 04c-R5 -- low -- comment contradicts Step 1's assertion
`book/04c-alphasimr-pipeline.qmd:276-279`

Evidence: "everything downstream would move with any edit or re-execution of Step 1";
Step 1 asserts that re-execution leaves `.Random.seed` identical.
Fix: "with any edit of Step 1".

### 04c-R6 -- low -- "four trait constructors" is wrong for AlphaSimR 2.1.0
`book/04c-alphasimr-pipeline.qmd:288-296`

Evidence: `SimParam` has `addTraitA, AD, ADE, ADEG, ADG, AE, AEG, AG` (eight).
Fix: "four of the trait constructors" or list all with the four rows as the relevant ones.

### 04c-R7 -- low -- hand-typed numbers in prose
`book/04c-alphasimr-pipeline.qmd:441` ("60 founders"), `523` ("Two hundred"),
`551-552` ("1--30", "31--60"), `609-611` ("about a third", "two DH standard
deviations", "a few percent"; values 0.320, 1.95/2.19, 0.025/0.010), `694-702` and
`1815` ("400"), `790` (`` `r 1000` `` -- a literal wrapped in inline code, not tied to
`nCrosses = 1000` in `be_draw`), `1119-1120` ("four times larger": the *requested*
`var = c(1, 4)`, not the realised `diag(G)`).
All currently correct (quickHaplo is reproducible), but untied to the objects.
Fix: inline from `pop@nInd`, `A@nInd`, `B@nInd`, `lottery`, a named `n_f1 <- 400`,
`n_prog <- 1000`, `diag(G)[2] / diag(G)[1]`.

### 04c-R8 -- low -- hand-typed timings for `run_alphasimr.R` are off
`book/04c-alphasimr-pipeline.qmd:1833-1834`

Evidence: "~10 s" / "~2 min". Measured on this machine (one concurrent R job):
`--test` 40 s wall (pipeline 0.1 s; the rest is `stage2_select()`), full run 29 s wall
(pipeline 1.9 s). Related, outside the chapter: the script header
(`inst/scripts/run_alphasimr.R:15-16`) tells the user to copy outputs to
`book/data/alphasimr_*.csv`, which do not exist and which the chapter does not read.
Fix: drop the timings or say "under a minute"; delete the stale header lines.

### 04c-R9 -- low -- identities stated but not asserted here
`book/04c-alphasimr-pipeline.qmd:1208` (`F_ST = GD_BS / GD_T`, asserted in
`02-subdivided.qmd:318` but not on these pools), `1123` (restricted index holds
trait 2 "at exactly zero": 6.6e-17, printed only), `689-691` (`makeDH()` homozygosity
"1.0 exactly", printed only).
Fix: one `stopifnot()` each -- inside `split_draw()`, after `idx_tab`, after `traj`.

### 04c-R10 -- low -- unmeasured causal claim
`book/04c-alphasimr-pipeline.qmd:1729-1730`

Evidence: "`F_ST` rises partly because `GD_T` falls" -- `GD_T` of the pools is not in
`metrics`/`rep_tab`, so the claim has no number behind it.
Fix: add `GD_T` to `pools_row()` and `metrics`, or drop the clause.

### 04c-R11 -- low (package, outside chapter) -- `$` on config lists
`R/13_alphasimr_bridge.R:79-90, 135-151, 225-235`

Evidence: `cfg$seed`, `cfg$n_sel`, `fp$pop_A`, `cy$elite_A` etc. Current names are
unambiguous, so no wrong value today; project rule is `[[`.
Fix: `cfg[["seed"]]` etc. (no number moves).

## Chunk / figure bookkeeping

No chunk change proposed is mandatory. If R4/R9 fixes add `set.seed()` lines or
`stopifnot()` inside existing chunks, no chunk is added or relabelled; the only figure is
labelled (`fig-alphasimr-cycles`), so no `unnamed-chunk-*` figure can be orphaned.
R4 will move Steps 3-6 numbers and therefore the freeze (both `html.json` and
`typ.json`).

## Summary

| ID | Severity | Line(s) | One line |
|---|---|---|---|
| 04c-R1 | medium | 1409-1411, 1423-1424 | mechanism sentence contradicts `gca_only()`; `GCA_var_dom` direction flips between MaCS draws; `dom_change` unused |
| 04c-R2 | medium | 1826-1828, 1719-1721 | "24 pairs" anecdote hand-typed and not reproducible (P ~ 0.03); "near threshold" wording at t = -5 to -8 |
| 04c-R3 | low | 132, 150-158 | `runMacs` non-reproducibility printed, not asserted |
| 04c-R4 | low | 370, 386, 498; 236-239 | Steps 3-4 draws not reseeded; "each step reproducible on its own" overstated |
| 04c-R5 | low | 276-279 | comment says re-execution of Step 1 moves the stream; Step 1 asserts it does not |
| 04c-R6 | low | 288 | AlphaSimR has eight trait constructors, not four |
| 04c-R7 | low | 441, 523, 551, 609-611, 694-702, 790, 1120, 1815 | hand-typed numbers (all currently correct) |
| 04c-R8 | low | 1833-1834 | CLI timings off (40 s / 29 s measured) |
| 04c-R9 | low | 689, 1123, 1208 | identities stated, not asserted |
| 04c-R10 | low | 1729 | `F_ST`/`GD_T` causal claim unmeasured |
| 04c-R11 | low | R/13 | `$` on config lists |

Verdict: chapter runs clean, Steps 1-7 are exactly reproducible as claimed, and every
conditional Step 8 verdict held across four executions. Two medium items: one
hand-written mechanistic sentence in the split sweep that its own numbers do not
support and that flips with the founder draw (R1), and one hand-typed, unreproducible
anecdote about `t` at 24 pairs (R2).
