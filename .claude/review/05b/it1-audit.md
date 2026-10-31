# 05b audit, iteration 1 (book/05b-heterosis-dominance.qmd)

Method: purled the chapter, ran it top to bottom in book/ (1 s) against the installed hybdiv
(every function deparse-identical to the worktree R/ under load_all), recomputed every inline
`r` expression, re-derived each displayed equation, and compared with the frozen markdown.
Freeze hash (html + typ) == md5 of the qmd (9151bd5e...); frozen numbers equal the live run
(0.78, 7.9, 0.365/0.3646, 2 %/38 %, 1.55, 70/30/28/30 %, 5.29, 10 lines/23 crosses, 56 %, ...).

## Findings

| ID | file:line | sev | problem | evidence | proposed fix |
|---|---|---|---|---|---|
| 05b-R1 | :1203, :1221, :1353 | medium | Marker coding in the protocol's **Call** lines is inconsistent. Step 1 says `diag(molecular_coancestry(GL))`; steps 2 and 5 say `pool_freqs(GL / 2, pool)`, `s1_monitor(GL / 2, ...)`. Both cannot be right for one `GL`. Package convention (R/05_pipeline_metrics.R:8-10, `mrd_matrix`/`pool_complementarity` docs) is GL coded 0/1, so `GL / 2` gives 0/0.5 frequencies halved; with the chapter's own 0/2 `L`, step 1 fails. | `range(diag(molecular_coancestry(L)))` = 2.876..3.040 (L 0/2), vs 1..1 for `L / 2`. A reader following step 1 on 0/1/2 data sees "self-coancestry not 1" for perfectly inbred lines. | Use the package convention throughout: "GL, line genotypes coded 0/1 (`L / 2` here)"; `pool_freqs(GL, pool)`, `s1_monitor(GL, pool, cycle)`, `diag(molecular_coancestry(GL))`. |
| 05b-R2 | :1513-1517, :1561-1565 | medium | "related but carry **no linkage disequilibrium**" / "isolates relatedness only -- there is no LD in it" is false. Lines descended from 6 founders carry founder-sampling LD across the population of lines even with every locus drawn independently within a DH; relatedness among lines *is* cross-locus covariance, which is exactly the term the per-locus closed forms omit and the deviations measure. What is absent is physical linkage. | Mean inter-locus r^2 over 400 polymorphic loci: independent lines (U) 0.0415 = the 1/(n-1) = 0.0417 floor; recycled (set.seed(501); recycle(U, 6)) 0.0676, 1.6x the floor. | Reword: "related, with free recombination -- the only LD they carry is what sampling six founders induces"; split "relatedness half / linkage half" into "LD from founder sampling (measured here) / LD maintained by physical linkage (not measured)". |
| 05b-R3 | chunks at :162, :170, :199, :222, :286, :310, :346, :372, :423, :622, :683, :709, :774, :790, :1124 | medium | Identities the prose asserts are printed, not `stopifnot()`-ed (check 3). Only :259 (Falconer), :486, :1300, :1418, :1431 assert. test-dominance.R / test-response.R / test-stage-metrics.R cover the oracle, cancellation, closed-form mean, GD_T/GD_BS, 2 GD_WI_hyb, 1 - theta_AB, ID == shared, distance identity, reconstruction, lm residual, mean_sq_delta_p -- but on the test ctx, not the book's. **Not covered anywhere**: the alignment two-term identity (:622-626), shared-term invariance under within-group permutation (:693, "identical to the digit"), inbred-line dominance value == 0 (:372, :1126-1129), and :709-712 compares only sweep *means* of `mean_sq_delta_p / 2` and `divergence`. | All hold now: residuals 0 to 7e-12; :709 both 0.039983. | Wrap each in `stopifnot(isTRUE(all.equal(...)))` (or `== 0` for the inbred zero); make :709 row-wise: `all.equal(sw$mean_sq_delta_p / 2, sw$divergence)`. |
| 05b-R4 | :852-865 | low-medium | `s_ij = -d m DC(f^L)_ij` is asserted as an identity with no chunk and no test. | Verified: `heterosis_gca_sca(U, V, rep(1, m))$sca` vs `-m * DC(fL[A, B])`: max abs diff 1.07e-12. | Add a 3-line chunk with `stopifnot()` after the display. |
| 05b-R5 | :1359 | low | Step 5 **Check** "`mean_sq_delta_p / 2` against `gd_partition()`'s `GD_BS`" omits the weighting caveat that step 4 itself establishes: it holds on the full factorial / uniform usage only. | Step 4 table: unweighted divergence off by -35.9 % on the 60-hybrid truncation set. | Append "on the full factorial, or with usage-weighted frequencies (step 4)". |
| 05b-R6 | :59, :726, :654 / :1608 / :1662, :1481, :321-325 | low | Hand-typed numbers (check 1). "a factor of five" (computed 5.29, inline at :1182); "first exceeds 1% of markers at `fst = 0.30`" (true: 0.002 at 0.20, 0.012 at 0.30, but the fst is typed while step 5 computes its sibling inline); "half again" x3 and in fig-cap :654 (1.55, seed-dependent); "five to ten [testers] to rank GCA at r > 0.85" (k = 5 gives 0.8518, a 0.002 margin that a seed change can flip); test parameters "40-hybrid", "12 lines, 800 markers", "5e-3", "2e-3", "smaller again" (verified against tests/testthat/setup.R:3-6 and test-dominance.R:58: gap 7.5e-4, relative 2.0e-3). | Values listed are the recomputed ones; all currently true. | Inline the first four (`fmt(closed_form / mean(...), 0)`, `sw$fst[which(sw$frac_opposite_fixed > 0.01)[1]]`, `round(max(al$total)/min(al$total), 2)`, threshold from `ts`). Test parameters may stay typed but cite the file:line. |
| 05b-R7 | :326-328 | low | "A subset chosen by an optimiser ... @sec-era-fhom ... measured on four such subsets" -- the four rows of era-hom-two-levels (05-genomic-era.qmd:216-220) are a random draw, two greedy and a truncation; one is random and none is an optimiser. | 05-genomic-era.qmd:217 `random = sample.int(ctx$N, 60)`. | "on four 60-hybrid subsets (a random draw and three heuristic selections)". |
| 05b-R8 | :884, :1524 | low | Observed variances use `var()` (divisor n - 1) against closed forms that are divisor-n population variances, adding a systematic +4.17 % to every GCA row (n = 25) and +0.16 % to SCA. Conclusions unaffected (-8.6/-6.4/-1.5 % become -12.3/-10.3/-1.7 %, still inside the 28 % band). | 25/24 - 1 = 0.0417. | Use `mean((x - mean(x))^2)` or multiply by (n-1)/n; or say which divisor is meant. |
| 05b-R9 | :1096 | low | "zero only at the degenerate limit where one pool is fixed at every locus" -- sigma^2_SCA = 4 sum d^2 pAqA pBqB is zero iff at *every locus at least one* of the pools is fixed; one pool fixed everywhere is a special case. | Closed form at :877. | "where, at every locus, at least one pool is fixed". |
| 05b-R10 | :1353-1354 | low | "Of its three divergence columns" -- `s1_monitor()` also returns `Fst_Wright` and `Gst_Nei` (R/05_pipeline_metrics.R:161-170). | -- | "Of its three complementarity columns". |
| 05b-R11 | :943-950, :1001-1005 | low (optional) | "The sweep's grid ... cannot locate it [the GCA peak]" -- the chapter's own result locates it: the d^2 (pq)^2-weighted mean of F*_k. | E over p ~ U(0.05, 0.95), d independent: 0.383; realised p_anc (seed 5) and d: 0.384 -- consistent with the grid peak at 0.30 between 0.20 and 0.45. | Compute it inline and show it on fig-heterosis-relocation, or leave as is. |
| 05b-R12 | :359, :1150, :1537 | trivial | `1:300`, `1:5` (x2) instead of `seq_len()`. | -- | `seq_len(300)`, `seq_len(5)`. |

## Checks with no finding

- Check 1 otherwise clean: every other number is inline and recomputes to the frozen value
  (N 625; 289.8; 0.78; 7.9, 0.0739, 0.0756; 0.365 vs 0.3646; offsets 0.0072/0.0040 vs gaps
  0.0070/0.0025, 2 %, 38 %, 0.0036; 1.55; 4.0 and 13 %; 28 %; 70 %, 64.0, 30 %, 17.8, peak 0.3
  between 0.2 and 0.45, 28 %, 151.9 -> 105.7, 30 %, 0.605 -> 0.263; 0.294, 355.4/355.1, s.d.
  1.71, gain 67.2, 65.9, 5.29, 287.9; +5.0 %, 35.9 %, 10 lines, 23 of 60; 2.30, 0.0107, 0.0246,
  0.2, 4.1; 0.49 (0.12), 0.85, 0.94, -0.5, 0.6, 0.066, -2.4, 2.6, 2.2; 8.6 %, 5 of 15, 56 %, 10.3 %).
  Prose readings of them hold (e.g. k = 3 residual larger than k = 1; GCA columns carry the
  recycled deviations; offset exceeds pred_divergence at fst 0.02, 5 % of it at 0.45).
- Check 2: `set.seed(4)` before `rgamma` (:15), `set.seed(9)` (:171), seeds inside
  `intra_pool_f1` (:1142), per draw at :1151, :1424, :1538; `ref_inbreeding_depression(seed = 2)`;
  `simulate_lines()` seeds from `cfg$seed`, and `set.seed(seed)` -> `runif` first confirms the
  sweep's ancestral vector is shared across fst (R/00_data.R:38-42). `sel_truncation` is
  deterministic. No AlphaSimR.
- Check 4: the chapter reads no file at all; nothing cached in book/data or book/figs, so
  regenerate.R is not involved.
- Check 5: all 19 functions called are exported; installed package == worktree. No install needed.
- Check 6: no chunk changed. Three figures, all labelled; docs/05b-heterosis-dominance_files and
  _freeze reference exactly those three; no unnamed-chunk figures.
- Algebra re-derived and correct: shared/divergence split; GD_T + GD_BS = 1 - theta_AB from
  gd_partition's definitions (R/01_metrics.R:158-163); self-coancestry 1 - h/2; Falconer
  Ch. 14 factor of two and "shared = mean RM heterozygosity + y^2/2"; BN expectations of both
  halves, Ep = 0.365; sample-frequency offset (V_A + V_B)/2 and its (1 - F) scaling; GCA/SCA
  expansion, opposite-pool weights, both limits; variance closed forms; E[sigma^2] under BN,
  concavity, F*_k, the interval 1/2(1 -+ 1/sqrt 2), weighted-mean peak; SCA/GCA ratio monotone;
  r_k with finite-population correction; 2 GD_WI_hyb test claim (setup.R idx = 40 random
  hybrids, gap 7.5e-4).

## Summary

The chapter runs cleanly in 1 s, its freeze is current, and every inline number recomputes
exactly; the algebra (partition, Balding-Nichols halves, GCA/SCA expansion, variance closed
forms, turnover point, tester correlation) checks out. Two substantive issues: the protocol's
Call lines mix marker codings so that step 1, as written, reports self-coancestry ~3 for
inbred lines (R1), and step 7 mislabels founder-sampling LD as "no linkage disequilibrium",
which misattributes what its deviations measure (R2). The rest is hygiene: many identities are
printed rather than asserted, four of them covered by no test and the DC(f^L) identity checked
nowhere (R3, R4); a handful of hand-typed numbers that are true now but seed-dependent (R6);
and small wording and divisor points (R5, R7-R12).
