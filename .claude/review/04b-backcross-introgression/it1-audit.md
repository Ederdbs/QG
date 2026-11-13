# 04b-backcross-introgression -- audit, iteration 1

Chapter: `book/04b-backcross-introgression.qmd` (949 lines). Read-only; no render. Chapter chunks purl'd and run against the
worktree (`pkgload::load_all`): every chunk and every `stopifnot()` passes, no error. R/08_mabc.R is ASCII; the chapter
never touches `ctx`; every figure and table chunk carries a `#| label:` (no `unnamed-chunk-*` in the qmd, in
`book/_freeze/04b-backcross-introgression/figure-html` or in the rendered HTML); `set.seed()` sits immediately before
each draw (qmd:658, 660, 673, 692, 890). No draw is unseeded.

THREAD Owed for 04b: `grep '-> `04b`'` returns nothing. The only 04b mention in THREAD is the index note (THREAD:203):
"04b:874 uses the same form" -- confirmed: qmd:874 says "item 5 of the Preface's chain of argument"; `index.qmd:115-120`
item 5 does cite `@sec-backcross` ("a set of near-copies cannot be rescued by any optimiser"). No action owed.
The references findings (rodgersmelnick2015 "measured from", gametophyte factors, xenia, haldane1919) are in
`it1-refs.md` (04b-B1..B4) and are not repeated.

## Findings

**04b-R1 -- Medium -- qmd:235-236 -- "At most 47 plants per generation at four genes, and that is the whole foreground problem."**
47 is the per-generation size for P = 0.95 (`n_for_count(1/16)`, `tbl-bc-foreground` caption says so). The programme has
three backcrosses, each of which can lose the targets, and one lost generation ends the lineage. At N = 47 the
programme-level survival is (1 - (15/16)^47)^3 = 0.862 (13.8% lost); the smallest N giving 0.95 over three generations is 64
(R: `n_prog`, k = 1..4 -> 6, 15, 31, 64, against per-generation 5, 11, 23, 47). The chapter's own scan agrees:
`mabc_uniform.csv`, rec_drag, s = 0.6, k = 4, BC3: `p_lost` = 0.193 at N = 40 (300 reps), 0.050 at N = 60 (200 reps).
Fix: say "per generation" and add that three independent generations at 0.95 each keep the lineage with probability
0.857, so about 64 plants per generation at k = 4 (computed inline from `n_for_count` with `P = 0.95^(1/3)`), and
that the scan's `p_lost` falls to 0.05 at N = 60; drop "the whole foreground problem".

**04b-R2 -- Low -- qmd:252-254 (and the `tbl-bc-ibd` caption, qmd:271)** -- "simulated IBD at BC3 with four genes ranges from 0.946 to 0.964."
`summarise_reps()` and the driver average IBD over replicates that kept the targets only (`mean(ok$ibd)`); at N = 20,
k = 4 that is 40% of replicates (`p_lost` = 0.603). The range is correct (recomputed: min 0.9462 at N = 20, max 0.9640 at
N = 320) but is a conditional mean, and the prose reads as unconditional. Fix: "among the replicates that kept all
targets" in the prose and caption.

**04b-R3 -- Low -- qmd:6-24 `MB` list** -- Design inputs typed in `MB` (`n_bc`, `ibd_target`, `drag_per_gene`, `flank_cM`,
`P`, `n_keep`) duplicate `mabc_opt` (`n_bc`, `target_ibd`, `drag_per_gene`, `flank_cM`, `P_crit`, `n_keep_f2`), which the
live chunks use. They agree today (checked) but nothing asserts it, and the captions/prose read `MB`, the code reads
`mabc_opt`. Fix: one `stopifnot(MB$n_bc == mabc_opt$n_bc, MB$ibd_target == mabc_opt$target_ibd, ...)`, or build `MB`
from `mabc_opt`. (The CSVs cannot be checked against `MB`: they do not record the criteria.)

**04b-R4 -- Low -- qmd:626 `fig-alt` of `fig-bc-sizing`** -- hand-typed "1610 plants ... 99 doubled-haploid lines". Equal to
`mb_sz$n_F2_3plants[4]` and `n_DH_3lines[4]` today; moves with nothing. Fix: `fig-alt: !expr` with `sprintf` from `mb_sz`
(the chapter already does this for captions, qmd:19-33).

**04b-R5 -- Low -- qmd:787** -- `$r^2 = `r fmt(haldane_r(MB$flank_cM)^2 * 1e3, 2)` \times 10^{-3}$` builds the exponent by hand
inside `$...$`. It renders (2.26 x 10^-3, verified `haldane_r(5)^2 = 2.264e-3`), but the book convention is `fmt_sci()`.
Fix: `$r^2 =$ `r fmt_sci(haldane_r(MB$flank_cM)^2)``.

**04b-R6 -- Low -- model section (qmd:~170-200) and Assumptions (qmd:~775-835)** -- `drag_total()` counts whole 5 cM cells
(`e[b+1] - e[a]`), so drag has a floor of 5 cM per target and takes values on a 5 cM lattice. Visible in the data: 1-gene
rec_drag mean drag is 5.00 at N = 200 and 400 (`mabc_uniform.csv`; my re-run 5.01), and the left panel of
`mabc_policies.png` flattens there. The chapter never states it; the "30 cM per gene" ceiling is six cells, and the
"close-in trimming" statements in the interference paragraph are limited by the same resolution. Fix: one sentence in
"The model" ("drag is measured in whole 5 cM marker cells; its floor is 5 cM per target").

**04b-R7 -- Info -- qmd:730-748 provenance of the three cached full-run tables** -- accurate and appropriately hedged, but
"produced by the predecessor of the current driver" cannot be checked from history: `e302107` (data, 2026-08-29 19:25) is
before the driver's first commit `016c71a` (19:43), and `git diff 016c71a 06e653c -- inst/scripts/run_mabc.R` adds only
the paired experiments and their defaults; `run_uniform_scan`, `run_allocation_scan`, `run_f2_scan` are textually
unchanged. Cheap producer re-run (current code, unpaired, 1000 reps, rec_drag and rec_bg, k = 1,3,4, N = 20..400, 36 cells,
seeds 1000+10k+N) against the CSV: mean z = +0.37, sum z^2 = 47.3 on 36 cells, the only large cell (rec_drag, k = 3, N = 120,
z = 4.6) is a CSV estimate of 100/100 with zero binomial variance (re-run 0.978); no cell disagrees beyond its s.e.
Chapter statement "a bit-for-bit match is not expected ... no full re-run has been diffed" stays true. Optional: say the
three scans' code is unchanged since the driver's first commit.

**04b-R8 -- Info -- paired tables reproduce bit for bit** -- `paired_cell()` re-run with the recorded `seed` reproduces
`mabc_index_comparison.csv` (k = 3, N = 80) and `mabc_allocation_recheck.csv` (300/40/20): drag, IBD, `p_lost`, `p_both`
identical to all printed digits (9.7 s for both). The qmd:722-739 claim "each cell can be re-run in isolation" is verified. Note
these two are producer = `inst/scripts/run_mabc.R`, not `book/scripts/regenerate.R`; the chapter says so.

## Checked, no finding

- `sizing_table()` == `mabc_analytical_sizing.csv` (`all.equal`, TRUE); the staggered numbers 401 and 99 are computed inline
  (qmd:640-642) and "hundreds" holds (401, 99); BC3F2/BC1 ratios 4.6 and 34.3, F2/DH 16.3 from the table.
- `mabc_bcnf2.csv` against the cumulative binomial `1 - pbinom(2, n, 0.25^k)`, 85 points, 250/80 replicates: max |z| = 2.25,
  mean z = -0.11, sd(z) = 0.81. Replicate counts in `MB_f2` match driver (run_mabc.R:210).
- `mabc_allocation.csv` 96 rows = 2 gene numbers x 4 x 4 x 3 schedules; `mabc_uniform.csv` strategy x s coverage as stated
  (rec_bg at 0.5/0.6/0.7, others at 0.6), n_rep 90-300.
- Index comparison: R/08 roxygen figures (0.26-1.19 points of IBD, mean 0.92, one failure in 1000 at k = 3, N = 80)
  recomputed from `mabc_index_comparison.csv`: 0.262, 1.195, 0.924, `p_ibd` 0.999 with `p_lost` 0; `rec_drag` beats `rec_bg` in `p_both`
  at all 8 cells. Both seeds in the CSVs equal `opt$seed + 1000k + N` and `opt$seed + sum(ns * c(1e6,1e3,1))`.
- z tests of the allocation recheck (qmd:508-516, asserted): z_top, z_low recomputed; the "separated" pair (20/150/190 against
  200/120/40, z about 3.9) survives a Bonferroni threshold over the 10 schedule pairs (about 2.8). No claim rests on z < 2.
- Stochastic chunks over seeds: qmd:671-679 (H1, 200 plants, tol 0.06) holds on 30/30 seeds (max rel. error 0.030 and 0.036,
  margin 1.7x); qmd:890-909 conversion ratio (tol 0.15) holds on 30/30 seeds (max 0.110, margin 1.4x; sd about 0.06, so
  about 1% failure per untried seed). Both are declared "this seed only" in the chunk comments; keep.
- Paired RNG: both arms restart at `set.seed(rs[rp])`, the same state that opened the mask draw (run_mabc.R:240-243). Tested
  with independent streams (offset 7919) at (k4,N150) and (k3,N80), 1000 reps: 0.527/0.740 and 0.677/0.877 against CSV
  0.540/0.751 and 0.712/0.893; differences at most 1.7 s.e., no ordering change. No finding.
- `tests/testthat/test-mabc.R:110-111` asserts the first IBD identity at tolerance 0.02 as the prose (qmd:176-177) says.
- `ibd`, `donor_specific` exact identity, `p_same_segment`, `expected_ibd(3, 0.5) == 0.969` unchanged from the previous review.
- Figures `mabc_policies.png` and `mabc_sizing.png` viewed: legend, line types, 0.95 dotted line, bar counts (5, 125, 23, 11 ...
  47, 1006, 1610, 99) agree with `cap_pol`/`cap_siz` and the tables. `fig-bc-flow` note at qmd:134 prints 0.98 for
  `1 - 0.4 * 0.0625 = 0.975`, consistent with the 0.975 of qmd:~245.
- Cross-references from 04b (`@sec-sizing`, `@sec-coancestry`, `@sec-ocs`, `@sec-stages`, `@sec-choosing`) all resolve;
  inbound: 04:30, 04c:2036, 11b:345, 90:414, 91:63, index:118. `book/downloads/04b-backcross-introgression.R` contains the
  current chunk names (16 hits for `N_cert|bg_miss|MB_f2`).
- `book/data/mabc_*.csv` all have a writer in `inst/scripts/run_mabc.R` (none in `regenerate.R`); the chapter labels each and
  does not call the three unpaired scans regenerable bit for bit.

## Cost

Everything above ran in under 2 minutes (largest: the 36-cell unpaired re-run, about 40 s; the two paired cells, 9.7 s).
