# 05b verdict, iteration 2 (book/05b-heterosis-dominance.qmd)

VERDICT: REJECTED

PREVIOUS IDS
- 05b-D1 -- CLOSED -- book/05b-heterosis-dominance.qmd:1713-1726 now states only what @eq-het-alignment gives: at equal GD_BS (usage-weighted) the divergence terms differ by m/2 times delta cov(d, y^2). It says the attainable between-plan gap is not measured, and that @tbl-het-alignment compares architectures, not plans. Algebra checked (d-bar is common to all plans, GD_BS fixes y^2-bar).
- 05b-D2 -- CLOSED -- the bare sigma^2_GCA is gone (grep). :1093-1094 writes the three-term denominator. :1793-1795 names sigma^2_SCA/sigma^2_GCA_A = 2.29 as one pool's GCA variance. Reproduced v_sca/v_gca = 2.287; the two-pool ratio is 1.08.
- 05b-M1 -- CLOSED -- :373-374 (1/m) sum 2 p_k q_k and 2F sum d_k p_k q_k.
- 05b-M2 -- CLOSED -- the local convention paragraph after the sweep introduction. F_BN/(2 - F_BN) for the two-pool frequency statistic was re-derived: E[y^2/4] / E[p-bar q-bar] = (F/2)/(1 - F/2).
- 05b-M3 -- CLOSED -- Step 6 now opens with the forward pointer to @sec-mating-connectivity and @sec-mating-tester. The mapping sigma^2_g = sigma^2_GCA_A, sigma^2_s = sigma^2_SCA, c = k, sigma^2_e = 0 agrees with 04e's tbl-mating-quantities row (04e:218). At sigma^2_e = 0 it reduces to [1 + (s/g)/k]^(-1/2), the n_B -> inf limit of @eq-het-rho-k.
- 05b-R1 -- CLOSED -- :1169-1173 declares GL as 0/1, matching R/05_pipeline_metrics.R:25,59,238,253,321. The Call lines :1277, :1295, :1428 now all take GL unhalved.
- 05b-R2 -- CLOSED -- :1666-1672 and :1680-1690 now attribute the omitted cross-locus covariance to founder-sampling LD under free recombination. Physical-linkage LD is declared unmeasured.
- 05b-R3 -- CLOSED -- the stopifnot calls are present. The knit ran top to bottom with no error.
- 05b-R4 -- CLOSED -- the chunk het-sca-dc-coancestry asserts s = -m DC(f^L_AB). It passes in the knit.
- 05b-R5 -- CLOSED -- the Step 5 Check (:1437-1441) is restricted to the full factorial and states the gap to expect on a subset.
- 05b-R6 -- CLOSED -- the hand-typed numbers are now inline (1.55, fst 0.3, the k threshold), or "a multiple of the true gain" at :59. Step 1 still reports 5.287.
- 05b-R7 -- CLOSED -- :325-329 now matches 05-genomic-era.qmd:219-222 (random, two sel_greedy, one sel_truncation, 60 hybrids each).
- 05b-R8 -- CLOSED -- pvar (divisor n) is used in the variance table, step 6 and step 7, and the prose names the divisor. Reproduced: ratio 2.29, residuals -0.47/+0.72 s.d. (-2.1/+3.2 SE), step 7 independent-lines maximum 12.3 %, recycled 5 of 15 outside 28 %, maximum 57 %, SCA <= 10.5 %.
- 05b-R9 -- CLOSED -- :1160-1162 states the correct iff.
- 05b-R10 -- CLOSED -- "three complementarity columns".
- 05b-R11 -- CLOSED as raised. The weighted-mean peak is computed and asserted. Its interpretation is the subject of a new finding, 05b-M4.
- 05b-R12 -- CLOSED -- seq_len.
- 05b-B1 -- CLOSED -- not required (it1), and unchanged.
- 05b-B2 -- CLOSED -- mackay2020 now includes Powell.
- 05b-B3 -- CLOSED -- white2020 issue and pages added.
- 05b-B4 -- CLOSED -- the citation is now scoped to [@falconer1996, Ch. 7], which the formula does not exceed.
- 05b-B5 -- CLOSED -- :113 [@fisher1918; @falconer1996, Ch. 7]. Whether the bib year should be 1918 or 1919 (Crossref "issued") is quant-refcheck's to settle. Fisher (1918) is the citation form used throughout the literature.
- 05b-B6 -- CLOSED -- :797-798 [@sprague1942; @griffing1956] for the GCA/SCA decomposition. That is the correct primary attribution.
- 05b-E1..E8 -- CLOSED -- form items owned by quant-editor. I checked only that nothing contradicts the text. The sweep legend now has five entries and matches the caption (dashed = BN predictions, dotted = mean total). The "(its column in @tbl-het-sweep)" pointer resolves: frac_opposite_fixed is printed in tbl-het-sweep. tbl-het-step1-noninbred carries the same values (overstatement 5.287).

DISQUALIFYING FAILURES
- 05b-D3 [criterion 1, 5] book/90-notation.qmd:212 (heterosis table, new row theta_A, theta_B, theta_AB), with :213 (p_{A,w}) -- theta_AB is defined as w_A' f^L w_B "with w_A the pool-A block of w". The same appendix defines w as the line-usage weights w_a = k_a/(2n) (book/90-notation.qmd, line-level table, row $\mathbf{w}$), which sum to 1 over BOTH pools. The pool-A block therefore sums to 1/2, and the row as written gives theta_AB/4. The code does not follow it: `theta_pools()` uses `line_weights()`, which renormalises within each pool (R/01_metrics.R:103-105, `wA / sum(wA)`). Measured on the step-4 truncation set: theta_pools()$theta_AB = 0.6352, and the global-w block form = 0.1588, ratio exactly 4. The same global-w block form does reproduce theta_S = w' f^L w = 0.6876, so the global w is the right weight for the hybrid coancestry and the wrong one for theta_AB. The p_{A,w} row (sum_i w_i u_ik "at line weights w") inherits the same ambiguity: under 90's w it is p_A/2. 05b:1345-1346 is correct only because it says "weights over the lines of a pool". This is a factor error in a definition, in text added in this iteration.

NON-DISQUALIFYING OBSERVATIONS
- 05b-M4 book/05b-heterosis-dominance.qmd:991-1003 and :1243-1244 -- "the expected peak computed from @eq-het-gca-peak, 0.38, lies inside that interval". 0.38 is the Balding-Nichols expectation for the true pool frequencies. The plotted curve (tbl-het-relocation, fig-heterosis-relocation) is the closed form evaluated at 25-line sample frequencies against the target F_BN. Sampling acts as F_eff = F + (1 - F)/n, so on the plotted axis the expected peak is (0.3826 - 0.04)/0.96 = 0.357. A Monte Carlo check at this scale gave an argmax of 0.35 on a 0.025 grid. The chapter sized exactly this sample-frequency offset for the mean in @sec-heterosis-flat and does not carry it here. The stated conclusion (the peak is inside (0.2, 0.45)) holds either way, so this does not reject.

WHAT WAS VERIFIED
- Whole chapter knitted under pkgload::load_all (worktree, book_cfg). Every stopifnot passes and there is no chunk error. Scratch: /Users/ederdbs/.claude/jobs/1f3dbb75/tmp/05b.md.
- Inline values in the changed text: alignment factor 1.55; frac_opposite_fixed first > 1 % at fst 0.3; F_peak 0.3826; grid bracket 0.2/0.45; SCA -70 %, GCA +30 %, recovery 28 %, total 151.9 -> 105.7 (-30 %); step 6 ratio 2.29, closed form first > 0.85 at k = 5 (0.8509), scan 0.8518 = 0.2 SE above 0.85, k = 10 gives 0.94; step 7 12.3 %, 5/15, 57 %, 10.5 %.
- F*_k and the weighted-mean peak: E[sigma^2_GCA_A,k] = d^2 pq [G - 4pq G^2] with G = 1 - F. The sum peaks at G = sum d^2 pq / (8 sum d^2 (pq)^2), which equals the d^2 (pq)^2-weighted mean of F*_k. The code's integral, int pq(8pq - 1)/8 / int (pq)^2, is the same quantity.
- D1 rewrite: divergence = m/2 [d-bar y^2-bar + cov(d, y^2)]. d-bar is common to every plan and GD_BS = y^2-bar/2 under usage weights (step 4 identity), so the difference is exactly m/2 delta cov. Correct.
- rho_k fpc with divisor-n variances: Var of a mean of k draws without replacement from N values = sigma^2_pop (N - k)/(k (N - 1)). Consistent with pvar.
- Sampling offset of the GCA peak (M4): analytic F_eff and a 20-replicate Monte Carlo (m = 20000, n = 25).
- theta_AB normalisation (D3): computed directly against theta_pools() and line_weights().
- New 90 rows M, G(x), h_i, GD_WI-hyb, MRD (MRD^2 = 1 - f^L for inbred 0/1 lines), mu, DC, sigma^2_GCA_A/B, F*_k, rho_k: checked against the chapter's definitions. Only the theta and p_{A,w} rows fail.
- simulate_lines: ancestral p ~ U(0.05, 0.95), BN beta pools (R/00_data.R:40-45), as the chapter states.
