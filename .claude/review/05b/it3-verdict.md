# 05b verdict, iteration 3 (book/05b-heterosis-dominance.qmd)

VERDICT: APPROVED

PREVIOUS IDS
- 05b-D3 -- CLOSED -- book/90-notation.qmd:212 now defines theta_AB = w_A' f^L w_B with the pool blocks rescaled to sum to 1 within each pool, as `line_weights()` returns (R/01_metrics.R:103-105). It also states that the unrescaled block gives theta_AB/4. :213 defines p_{A,w} at the within-pool weights. 05b:1363-1367 uses the same convention. Reproduced on the step-4 truncation set: theta_pools()$theta_AB = 0.6352 = mean(pAw pBw + qAw qBw). The global block (wt/2)' f^L (wt/2) = 0.1588, ratio 4. theta_A = 0.7581 = mean(pAw^2 + qAw^2). The new asserts in tbl-het-step4-usage pass.
- 05b-M4 -- CLOSED -- het-gca-peak (05b:1002-1013) and the paragraph at :1015-1024 now carry the sample-frequency offset. The interpretation at :1083-1087 and the bracket stopifnot at :1055 use F_peak_axis = 0.357, not 0.383. The derivation is correct (see below), and it agrees with the (1 - F)/n offset already used for the mean in @sec-heterosis-flat (the offset expression in that section).

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
None new. M1-M4 closed. There are no open minor findings.

WHAT WAS VERIFIED
- The whole chapter was purled from the current worktree and run top to bottom under pkgload::load_all. Every stopifnot passes and no chunk errors. Scratch: /Users/ederdbs/.claude/jobs/1f3dbb75/tmp/it3/{ch.R,run.R}.
- Var(p-hat | p) = pq F_BN + E[p_pool q_pool]/n. simulate_lines (R/00_data.R:38-52) draws each inbred line as Bernoulli(p_pool), with p_pool ~ Beta(p(1-F)/F, q(1-F)/F). So Var(p_pool) = pqF, Var(p-hat | p_pool) = p_pool q_pool / n, and E[p_pool q_pool] = pq - pqF = pq(1 - F). The total is pq[F + (1 - F)/n], so F_eff = F + (1 - F)/n. The GCA closed form (1 - 2b)^2 a(1 - a) is a product of independent quadratics in the two pools' estimates, so its expectation depends only on second moments. Substituting F -> F_eff is therefore exact.
- The axis transform F_peak_axis = (F_peak - 1/n)/(1 - 1/n) inverts F_eff = F(1 - 1/n) + 1/n. With n = 25 it gives 0.3826 -> 0.3569 (chapter value 0.3569089).
- I recomputed the analytic peak independently: maximising E[sum GCA_A] over F_eff on U(0.05, 0.95) gives 0.38263, mapped to 0.35691. A Monte Carlo check (30 replicates, m = 20000, n = 25, d ~ Gamma(2, 4), grid 0.25-0.47 by 0.01) gives a quadratic vertex of 0.3561 and a grid argmax of 0.34. Both agree with 0.357. Scratch: tmp/it3/mc.R.
- Inline values in the changed text: F_peak 0.383, F_peak_axis 0.357 (0.36 inline), sweep argmax fst 0.30, bracket (0.2, 0.45). The peak lies inside the bracket, which the stopifnot asserts. The tbl-het-relocation values are unchanged from it2.
- The 90 F*_k row (bar F* = d^2 (pq)^2-weighted mean) agrees with 05b:989-991 and with the it2 derivation.
