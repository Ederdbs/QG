# 06-metric-catalogue, iteration 1 audit (read-only)

Chapter: book/06-metric-catalogue.qmd (656 lines). Chunks run top to bottom (knitr::purl + source) at the
teaching scale; all stopifnot() in the chapter pass. Stochastic claims rerun over 20 simulation seeds
(`book_cfg$seed` = 1..20; `set.seed(42)` kept for the random subset; null B = 400, B_full = 300).
Scratch scripts: scratchpad a1.R, a2.R, a3.R (not versioned).

## Verified clean (no finding)
- eq-catalogue-split asserted on 5 selections; theta == theta_from_freq (difference exactly 0); GD == He_Nei.
- N_s bounds (fake f = 0.5 -> Ns 1, f = 1 -> Ns 0.5) consistent with 01:112-114.
- eq-catalogue-bias: algebra re-derived (E[theta_S] - theta_N = (1/n - 1/N)(fd - fo)); residual in s.e. over 20 ctx seeds
  ranges -0.99..2.55, assertion at 4 s.e. holds 20/20 (seed 1: 1.32).
- Spearman(theta, offdiag) = 1 on 20/20 seeds; ane ranking unchanged 20/20; ane_gap >= 0 (algebraic).
- GD_BS(truncation) > GD_BS(random) 20/20 (0.044..0.052 vs 0.033..0.038); |z F_drift| > |z GD| for truncation 20/20.
- attainable alpha < 0.05 on 20/20 seeds (range 0.027..0.047; seed 12 is 0.047, narrow). Seed 1: 0.0412.
- GD_BS == mean((pA - pB)^2)/2 and GD_T == mean(2 pbar (1 - pbar)) on usage-weighted line frequencies, error <= 2e-16 (supports 06:415-416).
- 06:406 (keep true): index is exactly additive in the two parents, `lm(index ~ factor(a) + factor(b))` R^2 = 1 (simulate_data: M = (La + Lb)/2, traits linear in Z).
- eq-catalogue-het-hs-dg per-locus algebra checked by hand; eq-catalogue-lambda-d algebra checked numerically (see R9).
- Timing chunk: theta_from_freq / theta_group = 13.3, 14.0, 16.0, 17.0, 20.8 over 5 repeats (n = 60, m = 2000); 06:142 holds.
- Baseline numbers (06:578-585): GD_population 0.3280928, GD_reference 0.3258386, gd_sd 0.00076545, apparent loss 0.0068707 = 0.687 %. 03 gives 0.32809 / 0.32586 / 0.681 %, s.e. 3.8e-5: GD_ref differs by 2e-5 (< 1 s.e.), consistent with 03:706-708. Both true; see R11 for the unit mismatch.
- set.seed before every draw (06:8, 06:50, 06:542; null_distribution seeds internally, default 7 = caption). No figure chunks, so no orphaned unnamed-chunk figures (docs/06-metric-catalogue_files absent; _freeze has execute-results only). All @-citations in references.bib. R/ ASCII-clean (grep -P non-ASCII on R/*.R empty).

## Findings

### 06-R1 (medium) 06:12-14 "every one operates on the molecular coancestry matrix"
Contradicted inside the chapter: 06:199 ("A metric independent of f, computed purely from the pedigree"), 06:231-264 (alleles_lost: marker frequencies),
06:101-107 (theta_from_freq, he_nei: colMeans(X)), 06:393-436 (theta_pools / gd_partition on fL; ne_lines_pool on the pedigree, "needs no fL"), and the
z table's F_hom / F_drift (frequency lenses, 00:463-465). R/01_metrics.R:1-4 itself separates "coancestry-based" from frequency-based.
Fix: keep the shared signature `f(idx, ctx) -> scalar`; say "the coancestry-based metrics operate on f (@sec-coancestry); the frequency, pedigree and
line-level ones read X, the pedigree or fL from the same ctx". Owed 01-C7.

### 06-R2 (medium) 06:154 "Molecular f has no base"
Against 01:235-256 (E[f_ij] = A_ij/2 + (1 - A_ij/2) * floor, floor = m^-1 sum(p_b^2 + q_b^2) >= 1/2; "not the same as having no reference") and 00:465-475.
The argument that follows (theta in [1/2, 1]) is itself the base-frequency floor.
Fix: "Molecular f is identity in state, with a floor set by the marker allele frequencies (@sec-coancestry), not a coancestry against a pedigree base in
which unrelated individuals sit at 0." The [1/2, 1] range and the two edge cases stay (they agree with 01:112-114).

### 06-R3 (low) 06:395 bare scientific inline value; 06:112 same family
`r signif(max(abs(gdp[, "GD_WI"])), 2)` renders 6.7e-16 (values -2.2e-16, 0, 0, -6.7e-16, -2.2e-16), a bare `e` in prose. Fix: `r fmt_sci(max(abs(gdp[, "GD_WI"])))`
(fmt_sci is in _common.R:48). 06:112 `signif(theta_group - theta_from_freq, 2)` prints "0" today; on another BLAS it can print 1.1e-16 bare. Fix: say
"identical to machine precision" and use fmt_sci only if nonzero, or report the all.equal tolerance only.

### 06-R4 (low) two symbols (four names) for one quantity, 06:568-572
Equation uses GD_random(n); 06:570 says GD_ref; chunk prints `GD_reference`; code `gd_ref`; caption 06:594 GD_random(n); 90:272 alpha row uses GD_ref and
90:280-295 carries a separate row for GD_random(n) "the same quantity as GD_ref". Fix: one symbol, $GD_{\text{ref}}$, in eq-catalogue-alpha, caption 06:594
and the notation table (merge the two rows of 90-notation); delete the reconciling sentence 06:570-572; rename the printed element to `GD_ref`.
Owed 00-C28.

### 06-R5 (low) 06:92-94 restates @eq-hp-gd
eq-catalogue-gd-he repeats 00:395 (GD_S = 1 - theta_S = m^-1 sum 2 pbar qbar = H_e). 00:399 and 02:78 send the reader here ("@sec-identity derives the identity"),
so keep the derivation (06:82-90) and replace the displayed result with "which is @eq-hp-gd". No chapter outside 06 cites eq-catalogue-gd-he (grep), only 06:155
and the 06:631 caption, to be retargeted at @eq-hp-gd. Also the derivation shows only the x_i x_j term and writes "Hence ... + qbar^2": add one clause that
f_ij = m^-1 sum [x_ik x_jk + (1 - x_ik)(1 - x_jk)] (@eq-f-molecular) so the (1 - x) term is visible. Owed 00-C25.

### 06-R6 (low) 06:364, 06:479 "dominance deviation(s)"
05b:153-156 reserves "dominance deviation" for Fisher's statistical object and calls d_k the dominance effect; 06 is not among the chapters 05b lists as
converted. Fix: "weighted by dominance effects" (06:364), "With dominance effects d_k" (06:479).

### 06-R7 (medium) 06:361-366 heterosis-engine slogan without conditions
"the diversity between pools is the engine of heterosis and cannot be spent" is stated bare; 06:363-365 then says GD_BS "weighted by dominance deviations is the
divergence half", which is right for the d-weighted term but a reader takes it for GD_BS. 05b:297-306 states the identity only for flat d, inbred parents, complete
factorial; with varying d it holds for the d-weighted term, not for GD_BS. 06:477 already states flat d correctly. (R/01_metrics.R:128-129 roxygen carries the same
slogan; out of scope here.)
Fix: "Under flat dominance, inbred parents and the complete factorial the divergence term of expected heterosis is GD_BS (@sec-heterosis); with d_k varying it is the d-weighted
version, which GD_BS does not fix." Owed 05b.

### 06-R8 (low) 06:467-480 re-derives @eq-het-split
06:469-474 re-expands H_S + 2 D_G (the same expansion as 05b:273). Algebra is correct (checked: H_T - H_S = y^2/2; het = H_T + D_G = H_S + 2 D_G; error 1e-16),
but cite @eq-het-split for p_A + p_B - 2 p_A p_B = H_T + D_G and keep only what is new (D_G,k = y_k^2/2 in the H_S / D_G vocabulary, and the move H_T = H_S + D_G ->
H_S + 2 D_G). Units: 06:477-478 "summed over loci" gives 2(D_G + H_S/2) in sums, 06:498 maps D_G = GD_BS, a per-locus mean; state "per locus" or divide by m. Owed 05b-C13.

### 06-R9 (medium) @eq-catalogue-lambda-d and the varying-d identity are not asserted
tbl-catalogue-het-identity (06:504-513) checks only the d = 1 case (and its HS_plus_2DG column is GD_T + GD_BS by construction, so it tests eq-het-theta-ab). The chapter asserts
sum_k d_k (H_S,k + 2 D_G,k) = 2 dbar_D (D_G + lambda_d H_S) and lambda_d = 1/2 at flat d without a stopifnot, and nothing in 05b asserts it either (05b:2123-2129 only cites it).
Numerically true: gamma(2, 4) d, seeds 101..120, plan = truncation, pools from usage-weighted line frequencies (`simulate_lines`/2): relative error <= 2.5e-15,
heterosis_expected() matches sum d (H_S + 2 D_G) to 3e-16; lambda_d range 0.480..0.522 (mean 0.501). Fix: add a chunk with `stopifnot(all.equal(...))` for the
varying-d identity and `lambda_d == 1/2` at d = 1 (tolerance 1e-12). Keep-true @eq-catalogue-lambda-d confirmed (cited at 05b:2123, 90:236, 90:209).

### 06-R10 (medium) 06:404-418 the mechanism of the GD_BS rise is cheap to settle and the chapter says it is not evaluated
06:417-418 "A plan with the same line concentration but lines drawn at random ... is not evaluated". It costs seconds. Result (200 draws each, 60 random hybrids from a random subset
of kA lines in pool A x kB in pool B): GD_BS random full 0.0358; 15 x 15 lines (Ne 12.9/12.8) 0.0395; 10 x 10 (Ne 9.4/9.4) 0.0438; 5 x 12 (Ne 5/12, truncation's concentration) **0.0492**;
truncation 0.0524, greedy_w 0.0498. So concentration alone reproduces ~80 % of the rise (0.0492 - 0.0358 over 0.0524 - 0.0358) without any selection on the index. Fix: add the chunk
(set.seed before it), report the comparison, and replace "consistent with" by what it shows; keep the additive-index sentence (verified, above) and add `stopifnot(R^2 == 1)`.

### 06-R11 (medium) baseline gap 06:516-590: unit and cross-chapter comparison
Numbers are right and consistent with 03 (see Verified). But the chunk prints `apparent_loss_if_wrong_baseline` as a fraction (0.0068707) while 03:705-730 reports percent (0.681);
06 never states the percentage in prose, the s.e. of the gap, or 03's value, although 03 points the reader here for the comparison ("percentages differ only by the draw of the subsets").
Fix: print in % (0.687 via fmt), add one inline sentence "03's @tbl-gd-baseline gave 0.681 % from another 400 subsets; the difference is of the order of the Monte Carlo error", and the s.e. of the mean (sd/sqrt(400) = 3.8e-5).
Keep 06 as owner of these three numbers (THREAD).

### 06-R12 (medium) 06:248-251 "the one genuinely non-redundant with theta"
07:199-209: allele loss has |rho| >= 0.93 with theta (cached CSV: Spearman 0.93), allelic richness retains 52 % of its rank s.d. after regressing on theta, but N_e,par retains 36 % and spans 30.1-55.8 at fixed theta.
"the one" is false against its own source and against 06:208-209, 06:224-227 (Ne_par "catches what coancestry blurs"). 07 also names "allelic richness" (alleles retained), not `alleles_lost`.
Fix: "the metric that retains most after theta (52 %, 07; Ne_par retains 36 %)". Also 06:251 "F_drift separates truncation from random subsets more strongly than any other metric": true of the eight columns of @tbl-catalogue-z
(36.0 vs 18.0 for GD) but the full discriminatory_power() output has Gst at 36.1 > F_drift 36.0 (cheap/full both computed here); say "of the metrics in the table".

### 06-R13 (medium) 06:322-323 claim about a cached analysis that cannot be verified here, and whose eff_dim column looks uncentered
"The package keeps its definition because the cached redundancy analysis of @sec-choosing and the case-study z-scores were computed with it." `book/data/metric_redundancy.csv` / `book/figs/metric_redundancy.png`
have no producer in regenerate.R, inst/scripts or R/ (grep metric_redundancy) and are not labelled external; so the sentence is unverifiable. Worse: the csv `eff_dim` column spans 1.438..1.506 (random mean 1.496), while
package `eff_dim()` gives 27.6 for a random 60-subset at book scale and the **uncentered** participation ratio gives 1.48, i.e. the cached analysis (07:199-201 lists "effective dimensionality") seems to use the
uncentered form that 06:350-357 calls a mistake. Production vs teaching scale differ, but 1.5 vs ~27 is not a scale effect. Fix: drop the "were computed with it" justification or state "cached from an external study, not regenerable here";
raise the eff_dim definition as a 07 finding (Owed 07). Nothing else in 06 changes.

### 06-R14 (medium) 06:638-649 trunc_cap row is one draw; the sign/size statement does not hold across seeds
trunc_cap z on GD: seed 1 = -1.44 (chapter, B_full = 1000) but over 20 ctx seeds -4.45..-0.25, |z| > 2 on 11/20. "close to the random subsets" and "A constraint on GD alone would not flag it" therefore depend on the draw and on a threshold nobody states.
What does hold: ANE z 14.4..19.7 on 20/20, alleles_lost z 0.6..4.3 (median 2.4), so the pattern ANE >> GD is robust. Fix: reword to the robust pattern ("GD z is small relative to ANE z: -1.4 here, between -4.5 and -0.3 across 20 simulation seeds, against ANE 14..20") and state the seeds run as a sentence, or drop the "would not flag it".
Related, 06:224-225 "On the z scale ... the order reverses": |z Ne_parents| < |z GD| on 18/20 seeds (fails on seeds 13 and 18: 10.97 vs 10.44, 11.37 vs 10.41 reversed the other way); seed 1 margin 12.6 vs 18.0. Hold with "here"/state the 18/20; the cause given (theta s.d. 0.23 % vs Ne_par 5.1 % of the mean, checked, B_full = 1000) is correct.
Ne_par reduction 62.2 % and theta +2.0 % on seed 1 are computed, fine.

### 06-R15 (low) `ctx$f` 06:539 (twice), `fake$f` 06:163, 06:166
Project rule: `ctx[["f"]]` never `ctx$f`. No live bug (names(ctx) = X f G traits ped n_lines pool fL cfg N m index p0 maf_pop; the exact name `f` exists, so partial matching to `fL` cannot fire), but 06:539 sits beside `ctx[["f"]]` uses elsewhere in the same chunk file.
Fix: `ctx[["f"]]`; for the fake ctx use `fake[["f"]] <- ...`.

### 06-R16 (low) caption numbers not covered by the stopifnot at 06:57
Nine captions state: simulation seed 1 (book_cfg$seed), "each line used at most 4 times" (checked here: max_line_use(sel_truncation_cap) == 4 = default cap), "at most 25 per pool", "400 / 1000 subsets, seed 7" (null_distribution default seed = 7;
nrow(null$cheap) == 400, nrow(null$full) == 1000 verified), "at most 59", "625 candidates". The stopifnot covers n_sel, N, n_lines, m only. Fix: add `book_cfg$seed == 1`, `max_line_use(sels$trunc_cap, ctx) == 4`, `nrow(null$cheap) == 400`, `nrow(null$full) == 1000`, `book_cfg$n_pool_A == 25`.

### 06-R17 (low) 06:119-120 "Losing 5 % of diversity ... 5 % of the set's expected heterozygosity"
Against 06:565-568: alpha is relative to the random-subset reference GD_ref, not to the set's own heterozygosity. Fix: "5 % below the expected heterozygosity of a random subset of the same size (@sec-baseline)".

### 06-R18 (low) 06:612-614 logical coerced to numeric
`c(alpha_truncation = ..., intended_limit = 0.05, constraint_is_active = attainable > 0.05)` prints `constraint_is_active 0`. Fix: return a list or `format()`.

### 06-R19 (info) 06:620 "production scale of `sim_config`"
Consistent with CLAUDE.md and _common.R:20-22 (sim_config 50 + 50, 5000; real 71, 25000). Conflicts with 05:108 (71 + 71, 25000), Owed 00-C22 on 05; 06 should stay, no change here, but the phrase "production scale" is ambiguous until 05 is aligned.

### Hand-typed numbers (low, no action unless the fixes above are done)
06:111 (1.5e-8 = all.equal default, correct); 06:122-123 (200, 25000, 40 000, 5 000 000: illustrative arithmetic, correct); 06:208 (200 hybrids / 12 lines: hypothetical, flag as such); 06:553 "400" and "within 4" (match the chunk);
06:617 "25 + 25 lines, 2000 markers" (asserted at 06:57).

## Owed-item status
| Owed | ID | Status |
|---|---|---|
| 06:395 bare scientific | 06-R3 | open |
| GD_ref vs GD_random(n) (06:568-572, 90:280-290) | 06-R4 | open |
| @eq-hp-gd instead of restating (06:92-94) | 06-R5 | open |
| 06:13-14 overstatement | 06-R1 | open |
| 06:154 "no base" | 06-R2 | open |
| 06:364, 06:479 dominance deviation | 06-R6 | open |
| 06:363-364 slogan | 06-R7 | open |
| 06:468-480 re-derives eq-het-split | 06-R8 | open |
| keep true eq-catalogue-lambda-d | 06-R9 | true, but add the check |
| keep true 06:406 additive index | verified (R^2 = 1) | true; add stopifnot (06-R10) |
| baseline gap numbers vs 03 | 06-R11 | numbers true and consistent; unit/percent gap |
