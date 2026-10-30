# 04g audit, iteration 1 (book/04g-joint-allocation.qmd)

Method: purled the chapter, ran it against the installed hybdiv (deparse-identical to
worktree R/16, R/17, R/18), recomputed every inline quantity and checked each prose claim
against book/data/joint_*.csv. Freeze hash (html + typ) == md5 of the qmd (cff7d210...).

## Findings

| ID | file:line | problem | evidence |
|---|---|---|---|
| 04g-R1 | book/04g-joint-allocation.qmd:87, :1128-1129 | Hand-typed timing "about 30 minutes of CPU, two thirds of it in the exchange searches"; total sweep time is not recorded in any versioned file. | joint_optimiser.csv sec_600: 21 un-slept cells sum to 16.4 min; the 3 slept cells are unusable (max 8338 s). Total CPU is not in book/data. |
| 04g-R2 | :1013-1014 | "against a millisecond for the greedy start" is hand-typed and never measured (regenerate.R times only the search, :834-838). | No coverage-allocation timing anywhere in book/data or the chunk. |
| 04g-R3 | :832-835 | The steps that fall under 2 SE are named by hand ("160 versus 80 at low SCA, 80 versus 40 at h2 = 0.2"; "160 versus 80 at h2 = 0.4 and high SCA ... z84[4]"). The count is inline, the labels are not, so they go stale on regeneration. | Correct now: z84 = 0.51, 1.15, 3.41, 2.14; z42 = 1.86, 3.37, 0.48, 4.38; under 2 = z84[1:2], z42[c(1,3)]. Derive labels from `which(c(z84, z42) < 2)`. |
| 04g-R4 | :757, :787, :835-838 | "76 crosses", "152 against 160 plots", "tester 152" are typed; "sits below ... in every scenario" is asserted nowhere. `tst` (:817) is computed and never used. | js: tester n_crosses 76, n_plots 152; tester < circulant c=4 at k=2 in all 4 scenarios under all 3 strategies (e.g. low/0.4/coverage 0.714 vs 0.767). True, but unwired. |
| 04g-R5 | :1040-1043 | "two of the 120 random sparse plans", "one replicate in each of two scenarios" hand-typed; derivable from js. | js n_comp_cross = 1.0333 (1/30 reps) in exactly 4 rows: random c=4, sca high, h2 0.2 and 0.4, strategies random and coverage. n_comp_loc == 1 everywhere. Correct now. |
| 04g-R6 | :1031 (tbl-cap), :1033 | "three cells ran across a machine sleep" hand-typed; tied to an unexplained 600 s cutoff; the sleep cause is unverifiable from the data. | sum(jo$sec_600 > 600) == 3; other cells 45.7-47.8 s. |
| 04g-R7 | :905, :907, :914, :1024, :1019-1020, :1006, :847-848 | Counts typed in prose: "24 cells" (x4), "all four cells positive", "positive ... in all four scenarios", "the smallest, ... at h2 = 0.2 and low SCA". | All true now: pc_all$cells == 24; pot$positive == 4; rho_made 0.20-0.66 all > 0; which.min(zm) == 1. Low severity; wire to pc_all$cells etc. |
| 04g-R8 | :926-927 | "an earlier, unpaired sweep had suggested the opposite" -- no versioned source; a claim about a result the reader cannot see. | Nothing in book/data or regenerate.R produces an unpaired sweep. Cite a file or drop the clause. |
| 04g-R9 | :762-763, :882, :1056 | Identity "genetic correlation of 2/3 between locations" (and "SCA a quarter of, or equal to, a GCA variance") asserted in prose only. | sparse_vc(): s2f/(s2f+s2fl) = 1/1.5 and s2s/(s2s+s2sl) = 0.25/0.375 (low), 1/1.5 (high) -- true, no stopifnot. |
| 04g-R10 | :919-923 | "only from 0.494 to 0.549, which is the ceiling" -- the value is not the ceiling and the bound is not asserted. | cov_t[2] = 0.54875 vs (18*4/8+2)/20 = 0.55. Say "within 0.002 of the ceiling" and `stopifnot(cov_t[2] <= 0.55 + 1e-12)`. |
| 04g-R11 | :106, :466-467, :233, :656 | Budget identity B = n_c k r (N_P = n_c k r) never asserted; the incidence chunk prints sum(M) without a check; :656 sets `NP <- 2 * nrow(pl)` assuming it. | Add `stopifnot(sum(M) == nrow(p) * k)` in joint-incidence and `NP == sum(Mc)` in tbl-joint-freq. Holds numerically. |
| 04g-R12 | :231-233 | joint_alloc(strategy = "coverage") draws (R/18_joint_allocation.R:67, :71: sample.int, runif) with no set.seed() before it. | Printed output (12, 12, 4/4/4) is RNG-invariant, so no number moves; convention only. |
| 04g-R13 | book/scripts/regenerate.R:827 | set.seed(5050) once for all 24 cells: each cell's M_start/M_opt plan (random sparse) and its replicate seed vector (:845) inherit the stream left by every earlier optimiser run, so changing n_iter or one config moves all later cells. | Seed per cell (e.g. set.seed(5050 + 100*v + i)) immediately before make_plan(i). Requires regeneration; numbers would change. |

## Checks with no finding

- Check 4 (sources): reads only book_data() (:6-8); report/joint_raw.rds is mentioned as an output, never read.
- Check 5 (exports): design_circulant, design_random_sparse, joint_alloc, joint_pev, joint_connectivity, relmat_halfsib, sparse_vc, sparse_simulate, sparse_blup, molecular_coancestry all exported; installed package deparse-identical to worktree R/16-R/18. No install needed.
- Check 6 (figures): no chunk changed in this audit. Both figures labelled (fig-joint-budget, fig-joint-pev); docs HTML references exactly those two, present in docs/ and _freeze (html png + typst svg); no unnamed-chunk figures, no " N" duplicates.
- Check 2 otherwise clean: set.seed before every draw in joint-misspec (:179, :195), tbl-joint-live (:440), tbl-joint-freq (:575, :641), change-of-base chunk (:664).
- Check 3 asserted: ANOVA split, GD_l identity, GD_BS = D_bar = 2 SS_B/(N_P N_SNP), change of base, zero drift on circulant, per-marker GD loss, I-kernel GLS == sparse_blup, exact permutation table; PEV exactness and component counts covered by tests/testthat/test-joint.R:24, :44.
- Prose claims verified against recomputation: ms |z| 0.95/1.15 ("nothing detectable"); pc_all z 1.74 (not detected), random family z 2.29 (2-3 SE), 2 cells > 2 SE (2.32, 2.68); zm 1.24-6.03, zm[2] 2.67; zc(4,8,0.2,high,made) = -0.32; r_pev -0.96; rho -1.00 to -0.89, p 0.003-0.033, rho_crit 0.886; rho_made p 0.18-0.71; g300 0.10 %, g600 0.15 % ("fraction of a percent"); tester largest mean PEV reduction (0.34 % vs 0.14/0.20 %); tester optimised-start z 2.71, 4/4 positive; 8 of 24 cells with second >= 0.65; margin c=8 vs c=2 grows with SCA (0.064->0.096 at h2 0.2, 0.087->0.146 at 0.4); fr table: coverage 3.97 -> 1.08 % vs d_rand 4.40 %, marker search no PEV cost (0.4938 -> 0.4921), family search 0.79 vs ceiling 0.80, fem_cover 0.891 -> 0.860.
