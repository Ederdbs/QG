# 04c Step 8 -- targeted check after MaCS re-execution

Scope: the four hand-written phrases named by the caller, plus a scan of the rest of Step 8
(book/04c-alphasimr-pipeline.qmd:1142-1760) for hand-written qualitative claims against the
rendered inline numbers in docs/04c-alphasimr-pipeline.html.

VERDICT: REJECTED (one failure, 04c-D1)

## The four phrases

1. "is close to ... pooling does what it should there" (qmd:1678-1682) -- HOLDS.
   Rendered: cor_AB = 0.12, sd_pooled = 0.021 vs sd_if_independent = 0.02.
   Contrast sentence also holds: mean_tc cor 0.91, pooled 1.41 vs 1.02 if independent,
   against per-pool paired s.d. 1.42 / 1.46 ("does not reduce that noise").

2. "negligible ... within <cov_se_max> standard errors" (qmd:1403-1406, also 1388-1389) --
   FAILS (04c-D1). The phrase no longer says 1.5: it now renders "within 1.9 standard errors
   of zero at every split". Rendered split_0 GCA_cov2 = -0.027, between-draw s.d. 0.064,
   n = 20 draws -> 0.027 / (0.064/sqrt(20)) = 1.89 SE; t_{0.975,19} = 2.093, two-sided
   p = 0.074. See 04c-D1.

3. "the selection component of the loss is of the same order as its paired standard
   deviation" (qmd:1704-1705) -- HOLDS. Rendered gd_elite_mean diff -0.015, paired s.d. 0.021
   (ratio 0.71); gd_pool_mean diff -0.015. With t = -4.9 the "what the t decides" clause is
   consistent (verdict() renders "does" for both).

4. "its *overall* r^2 is barely above it" (qmd:223) -- HOLDS. Rendered runMacs overall
   0.0119 vs noise floor 0.0101 (1.18x); adjacent 0.1182 (inline "12 times the floor").
   Note: this sentence is in Step 1, not Step 8.

## Disqualifying failures

- 04c-D1 [criteria 3 and 6] book/04c-alphasimr-pipeline.qmd:1403-1406 ("The ratio is a
  partition of var(GCA) only insofar as the covariance term is negligible; here that term is
  within `r fmt(cov_se_max, 1)` standard errors of zero at every split") -- the hand-written
  word "negligible" is now carried by a rendered 1.9 SE, which sits just under the 5% point
  (t_{0.975,19} = 2.09, p = 0.074) that the text never states. "Not significant at p = 0.07
  with 20 draws" is absence of evidence, not negligibility; and in magnitude the split_0
  term (-0.027) is half of the numerator it qualifies (GCA_var_dom = 0.054). Unlike the RRS
  paragraph (qmd:1665-1673, 1699-1703), whose verdicts are computed from sig_paired, this
  verdict is hard-coded, so a further MaCS render that moves cov_se_max past 2.09 would leave
  "negligible" asserted against a significant covariance with no change of wording. The
  limitation (render-dependent, near-threshold) is not acknowledged at this sentence.
  Consequence for the conclusion is small: var(dom)/(var(add)+var(dom)) at split_0 is
  0.054/0.547 = 0.099 vs the reported 0.105, against a contrast of 0.082 (t = 5.4); the
  failure is in the unconditional qualitative claim, not in the direction of the result.

## Rest of Step 8 scanned -- all HOLD against rendered numbers

- "each step many standard deviations wide" (qmd:~1326): F_ST 0.021/0.046/0.255/0.563,
  s.d. 0.002-0.015; GD_BS 0.007/0.014/0.076/0.185, s.d. 0.001-0.006. Smallest step
  (GD_BS 0->10, 0.007 vs s.d. 0.001) still ~7 s.d.
- "GD_T does not stay flat" / "14 standard errors": 0.309, 0.299, 0.329; rise 0.03.
- "GD_T_other falls": 0.309 -> 0.238 (monotone 0.309, 0.303, 0.294, 0.238).
- "the ratio can rise without the dominance part growing at all": GCA_var_dom 0.054 -> 0.055.
- Conditional "fall of the additive part accounts for more": gca_only add 0.207 vs dom 0.106.
- "Both correlations are below the 0.997": 0.948, 0.905.
- RRS paragraph: all five verdicts render "is beyond it" (t = 13, -4.9, -4.9, 5.6, 5.4 vs
  t_crit 2.01); "selected arm's mean loss exceeds the control's": 0.572 vs 0.509 (A),
  0.572 vs 0.501 (B); "the control loses gene diversity too": 0.509 / 0.501 > 0.
- Final stage2_select paragraph is hedged ("Depending on the draw ... may warn"); no
  contradiction with the rendered table.
