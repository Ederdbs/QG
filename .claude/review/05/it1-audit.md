# Audit 05-genomic-era -- iteration 1

Scope: book/05-genomic-era.qmd (1566 lines, 33 chunks, ~110 inline expressions), the package functions it
calls (R/00, R/01, R/02, R/03, R/07, R/14). Run read-only at 12c1ee6: `knitr::purl` + `pkgload::load_all`
of the worktree, all chunks top to bottom in 3.4 s, every inline `r` expression evaluated afterwards.
Re-run against the installed hybdiv 0.1.0: output byte-identical (no reinstall needed).

## Checks that pass
- Runs clean; every `stopifnot()` holds (10 of them).
- Check 4: the chapter reads no file at all -- no `book_data()`, `book_fig()`, `report/`, `data/`, `reference/`.
  Nothing cached, so nothing to regenerate via regenerate.R.
- Check 5: every function called exists in the installed package (identical output under `library(hybdiv)`).
- Check 6: no chunk change proposed here that is forced; the only figure is labelled (`fig-era-lens-divergence`),
  freeze holds exactly `figure-html/fig-era-lens-divergence-1.png` and `figure-typst/...svg`, no orphans.
- `book/downloads/05-genomic-era.R` code is in sync with a fresh purl. Freeze html.json carries the same
  inline values as the live run (spot-checked 1319, 35.08, 2.26, 0.0521, 1.81, 1563, -4.3e-13).
- All 25 `@sec-/@eq-/@fig-` targets resolve; all 6 citation keys exist in the .bib.
- Verified numerically: both lenses read exactly 0 at the base and after rebasing (bit-exact 0);
  `f == 0.5 + 2 Zh Zh'/m` (1.1e-16); `He == GD_T`; `F1_het == 2 GD_WI_hyb`; on the full factorial
  `F1_het == GD_T + GD_BS` (0.3617); `G_0.5 = 4f - 2J` algebra (rank 49, same as f); the MAF algebra
  `F_drift = c^2 W`, `cov_diag = -2cW`; z-scores reproduce by hand ((-0.0113-0.0069)/0.0038 = -4.79);
  `optimal_contributions()`/`ocs_quadprog()` do add `diag(1e-8, n)` (R/07:173,203); `build_ctx()` does set
  `p0 <- colMeans(X)` (R/00:163); `sel_greedy()` consumes no RNG; w = 1 == truncation (and so is every
  w >= 1.8e-2; overlap with truncation 12/60 at w = 1e-5, 40/60 at 3e-4, 60/60 at 1.8e-2 -- supports
  "three orders of magnitude, not two" at L845).
- Truncation's F1-heterozygosity advantage (L249-252) survives a 1000-subset null: z = 2.45, 0.7% of
  random subsets reach it (see 05-R5 for why the chapter should say so).

## Findings

| ID | file:line | Sev | Problem | Evidence | Fix |
|---|---|---|---|---|---|
| 05-R1 | book/05-genomic-era.qmd:1376-1379, :1429-1432 | major | Wrong mathematics. Prose bounds `rank(f) <= min(rank(B), m) + 1` and says `rank_f == rank_incidence` "is a measurement ... not a theorem -- the extra dimension the bound allows is not attained in any of the five". The extra dimension can never be attained: every row of B has two 1s, so `B 1_L = 2 1_N` and the constant vector already lies in col(B). With `Z_h = X - 0.5 = B (M_L - 0.5 J)/2` and `f = 0.5 J + (2/m) Z_h Z_h'`, col(f) is inside col(B): `rank(f) <= rank(B)` IS a theorem (and `<= m + 1`). Only the equality is empirical (generic position of M_L). | `range(B %*% rep(1, L))` = 2 2 on the full factorial; 200 random subsets of size 10-200 (set.seed(99)): rank_f > rank_B never, equal always. | State `rank(f) <= rank(B)` as the theorem with the one-line reason (`B 1 = 2 1`); keep equality as the measured part. The `stopifnot(rank_f == rank_incidence)` asserts the empirical part -- fine, but say that is what it asserts. |
| 05-R2 | :1060-1063, :1076, fig-cap :1034, :827 | moderate | The managed-arm drift rate is quoted from a fit the chapter's own threshold rejects. Step 4 threshold (L1089): "treat R^2 < 0.995 on an averaged series as a non-constant rate". `fit_m["F_drift","R2"]` = 0.9924 < 0.995, yet the prose reports dF = 0.0228, N_e = 22.0 and "2.26 times the unmanaged rate" from it, and only flags the F_hom fit. The series is visibly non-constant: per-cycle increments of F_drift rise 0.0122 -> 0.0221 (the pull is deterministic displacement compounding on drift). | `diff(managed$F_drift)` = 0.0122, 0.0144, 0.0160, ..., 0.0221; R2 = 0.99243. | Either report the drift lens R^2 inline and say the diagnostic fires on both lenses (then quote the ratio as a cycle-12 stock ratio, `managed$F_drift[13] / block$F_drift[13]` = 2.02, rather than a rate), or justify why 0.992 passes. |
| 05-R3 | :1527 | moderate | Hand-typed numbers inside the transposition kable: "(39.3 to 13.0)". They match `pr[, "Ne_parents"]` today but will not follow a re-execution. | live: 39.3443, 13.0199. | Build that cell with `sprintf("... (%.1f to %.1f)", pr["random","Ne_parents"], pr["truncation","Ne_parents"])`. |
| 05-R4 | :553, :624-626 | moderate | "exceeded targets by ~40%" / "overshot by ~40%" for A is hand-typed and true for one lens only: dF_hom 0.0070 is +40%, dF_drift 0.0084 is +68% against 0.005. "targets" (plural) is wrong for drift. | `ref_res` rows A(M,~): 0.0070/0.005 = 1.40, 0.0084/0.005 = 1.68. | Compute both overshoots inline from `ref_res` and name the lens; fix the Behaviour cell ("exceeded the dF_hom target by ~40% and the dF_drift target by ~70%"). |
| 05-R5 | :246-259 (chunk :216-234) | moderate | Internal inconsistency of method: Step 2 (L808-815) argues "no single draw can serve as a control", but the F_hom ranking, the F1-heterozygosity comparison and the GD_BS comparison at L246-259 are all made against the single `random` draw. The conclusion happens to survive a resampled null, but the chapter does not show it. | 1000 random 60-subsets (set.seed(7)): F1_het mean 0.36172, sd 0.00116; truncation z = +2.45 (0.7% of null >= it); GD_BS z = +27.9; F_hom z = +9.36; the `random` row itself sits at F1_het z = -0.90. | Reuse `null60` (or a small F1_het/GD_BS null) and quote z inline, or move these sentences after Step 2. |
| 05-R6 | :246, :258 | minor | "Truncation has the highest F_hom ... the worst of the four": it is tied with `balanced`, which is the identical set (L835 shows `w = 1` == truncation). The table has three distinct plans, not four. | `two_levels` rows balanced and truncation identical in every column. | Say "the two index rows (identical, see Step 2)" or drop `balanced` from `sels`. |
| 05-R7 | :986-990 | minor | Wrong yardstick: the deviation of a 20-replicate MEAN from the closed form is compared with the between-replicate SD of a single replicate (and the max over all cycles with the SD at the last cycle). The right scale is the SE, sd/sqrt(20). | max dev / SE: block 1.56, DH 2.06 -- still sampling-compatible, but the prose's "within its s.d." is ~4.5x too lenient a yardstick. | Compare with `sd_hom / sqrt(reps)` per cycle and report the max ratio inline. |
| 05-R8 | :992, :1089-1090 | minor | "R^2 >= 0.999 on all four fits" is hand-typed and unasserted; the threshold 0.995 is derived from it. | min(fit_n[, "R2"]) = 0.99935. | `stopifnot(all(fit_n[, "R2"] >= 0.999))` and inline `fmt(min(fit_n[, "R2"]), 4)`. |
| 05-R9 | :612-613, :628, :823, :1438 | minor | Hand-typed derived numbers: "within about 2%", "14% below target ... (0.0043 against 0.005)", "less than 0.3%" (gain change M,M vs M,D), "0.0176 against a 0.005 target", "four orders of magnitude" (1e-8 vs ev_min). All correct today. | 1-0.0049/0.005 = 0.02; 1-0.0043/0.005 = 0.14; 1-7.107/7.124 = 0.0024; log10(1e-8/4.3e-13) = 4.4. | Inline from `ref_res` / `ev_min`. Panel-M part of "2%" is a transcription, label it as such. |
| 05-R10 | :411, :718-721, :1345-1351, :673-676, :61-65 | minor | Check 3: identities asserted in prose but only printed: "both lenses must read zero" at the base (era-base-zero); "identically zero, both lenses" after rebasing (era-rebase); `f == 0.5 + 2 Zh Zh'/m`, `sum(G) == 0`, `rank_G == rank_f - 1` (era-centering-vs-structure); the unequal-pool and incomplete-balanced p0 identities (era-p0-identity, only the complete one is asserted); `F1_het == 2 GD_WI_hyb` on the full factorial (era-inbred-check). | all hold: base and rebased lenses bit-exact 0; 1.1e-16; G_sum -4.2e-11; ranks 49/48; 1.1e-16 x2; 0.3616896 both. | Add `stopifnot()` lines (tolerance `1e-12` for the zeros, `all.equal` elsewhere). |
| 05-R11 | :1390-1397 | minor | Check 2: one `set.seed(31)` before two draws that matter (`random_60`, `random_20`); `random_20` inherits the stream after `random_60`. (Reusing 31 so `random_60` equals `sels$random` is deliberate and fine.) No MaCS/AlphaSimR in this chapter. | code inspection; sel_* consume no RNG, so currently stable. | `set.seed(32)` (or similar) immediately before `random_20`. |
| 05-R12 | :1335-1337 vs :124 | minor | "G_0.5, which is the molecular coancestry this book calls f" contradicts the table caption "G_0.5 = 4f - 2J, an affine function of f"; the chunk then checks f, not G_0.5. The conclusion holds for G_0.5 too, but the text should say so. | rank(4f - 2J) = 49 = rank(f); its row sums 414-449, not zero. | "G_0.5 = 4f - 2J (an affine map of f) ..." and optionally add its rank to the chunk. |
| 05-R13 | :1421 | minor | "A subset of 20 hybrids drawn from 50 lines is full rank" generalises one draw (31 lines used). Generic, not guaranteed (rank(B) can drop below 20 for an unlucky draw). | rk row random_20: lines_used 31, rank 20. | "This 20-hybrid draw is full rank". |
| 05-R14 | :1034 fig-cap, :1043 | minor | Caption hand-types the parameters (12 cycles, 20 replicates, 50 plants, 100 gametes, 5%, "more than twice") and `ylim = c(-0.42, 0.26)` is hard-coded to the current data; a change of `n_line`, `n_cyc` or `pull` silently desyncs both. | current extremes: min F_hom -0.366, max F_drift 0.231 (fit inside the ylim). | `ylim = range(unlist(lapply(arms, \(a) c(a$F_hom, a$F_drift))))`; caption via `#| fig-cap: !expr` or keep and note the parameters are fixed. |
| 05-R15 | :105, :771/:804/:811, :989/:997 | info | Hand-typed constants that mirror code literals: production scale "71 + 71, 25000" (not in any code object; `sim_config` is 50+50/5000), "1000 resampled subsets" (= B_full), "20 replicates" (= reps default). Correct; low risk. | -- | Optionally inline `nrow(null60$full)` and a `reps` variable. |
| 05-R16 | book/11b-diversity-across-cycles.qmd:240-242 (cross-chapter) | info | This chapter insists (L152-154, L1552) that dF = 1 - exp(slope) and -slope is only first order; @sec-cycles, which Step 4 cites as doing "this on run_cycles() output", uses `-coef(f)` and `Ne = 1/(-2 slope)`. | code inspection. | Align 11b with `dF_fit()` here (outside this chapter's scope; flag to the 11b audit). |

## Summary
Chapter runs clean in 3.4 s, reads no external file, is in sync with its download script and freeze, and every
`stopifnot()` holds; installed package needs no reinstall. 16 findings: 1 major (05-R1: the rank bound is
stated as `rank(B)+1` and the equality called "not a theorem", but `rank(f) <= rank(B)` is a theorem because
`B 1 = 2 1`), 4 moderate (05-R2 managed drift rate quoted from an R^2 = 0.992 fit that fails the chapter's own
0.995 threshold; 05-R3 hand-typed 39.3/13.0 in a kable; 05-R4 "~40%" overshoot true for dF_hom only (drift
+68%); 05-R5 single-draw comparisons the chapter itself forbids two sections later -- the claims survive the
resampled null, z = 2.45), 9 minor (identities printed not asserted, hand-typed derived numbers, SD-vs-SE
yardstick, tied rows, one seed for two draws, G_0.5 vs f wording, hard-coded ylim/caption), 2 info.
