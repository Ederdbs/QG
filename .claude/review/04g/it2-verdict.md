# 04g-joint-allocation -- verdict, iteration 2

VERDICT: REJECTED

PREVIOUS IDS
- 04g-D1 -- CLOSED -- :445-474 now calls the pair a necessary screen and says the three-way metric "remains open". The implication n_comp_cross = 1 => n_comp_loc = 1 (every location planted) holds: each cross lies wholly in one parent-disjoint location set. The live chunk tbl-joint-alias reproduces the counter-example: counts (1, 1), rank 3 of 4. Roxygen R/18:131-146 is aligned.
- 04g-D2 -- CLOSED -- :82-86 scopes result 3: not detected pooled, tester family past 2 SE but not 3, four cells with one design each (z = 2.71 recomputed).
- 04g-D3 -- CLOSED -- the causal SCA clause is deleted. :903-908 now reports numbers only.
- 04g-D4 -- CLOSED -- the lines-in-data mechanism is withdrawn from result 1, and :1252-1257 correctly restricts "every line in the data" to the circulant comparison. The replacement parenthesis at :138 is a new error, see 04g-D9.
- 04g-D5 -- CLOSED -- the unsourced "earlier, unpaired sweep" clause is gone (:1003).
- 04g-D6 -- CLOSED -- gonzalezbarrios2019 is now "could potentially raise ... by up to 43 %" (:351-352).
- 04g-D7 -- CLOSED -- montesinoslopez2024 is now "performed better than random and were less variable" and is moved to the better-than-random side at :1027.
- 04g-D8 -- CLOSED -- kadam2021 is now *expected* accuracy, "a model forecast, not a realised accuracy", with the conditional conclusion (:358-361).
- 04g-M1 -- CLOSED -- "within 0.001 of the ceiling" is inline (cov_t[2] = 0.54875), and the stopifnot on the 0.55 ceiling passes.
- 04g-M2 -- CLOSED -- the criterion is now an A-type criterion on effects, explicitly distinguished from the mean PEV of pairwise differences. That this is Butler et al.'s A-value is left to quant-refcheck. A scale-factor remnant in the roxygen is recorded as M11.
- 04g-M3 -- CLOSED -- :416-419 now separates a random family x location interaction (via A_f) from a systematic one. This is correct under (A_f (x) I_L) sigma2_fl.
- 04g-M4 -- CLOSED -- lell2021 is now "one promising design".
- 04g-M5 -- CLOSED -- the 30 min is marked as one unrecorded timing, the kept search time is inline (16.4 min recomputed), and "machine sleep" is replaced by "cause not recorded".
- 04g-M6 -- CLOSED -- the step labels, tester crosses/plots, cell counts and disconnected-plan counts are now inline. Each was re-evaluated against the current CSVs (see below).
- 04g-M7 -- CLOSED -- :1023-1026 now states the measured result first and then reads it "as consistent with ..., not as a replication".
- 04g-M8 -- CLOSED -- checklist item 7 now carries its evidence base and the missing design-to-design variance.
- 04g-M9 -- CLOSED -- headline 1 states the non-reversal at h2 = 0.2, high SCA (made: 80 at two = 0.610 vs 160 at one = 0.618).
- 04g-B6 (contested) -- CLOSED -- the identity D_ST = H_T - H_S is Nei's. The plot weighting is applied consistently to both H_T (GD_P at plot-weighted pbar) and H_S, and the parenthesis "(the plain mean under equal loads)" marks the weighted form as the general case. No misattribution.
- 04g-R2 (contested) -- CLOSED -- already not upheld at iteration 1 (coverage allocation timed at 0.66 ms). An order-of-magnitude statement is supported.
- 04g-R13 (deferred) -- not a failure of the text. Every number is reproducible from regenerate.R as it stands. The shared seed stream across cells makes the optimiser cells fragile to edits, but it does not falsify any reported value. The one-design-per-cell dependence it implies is already declared (:1068-1070, checklist 7).
- Sufficient three-way check (deferred) -- properly circumscribed. :465-474 says the counts do not detect GCA-location aliasing, names the rank check that would, says joint_connectivity() does not compute it, and declares the metric open. Checklist 6 (:1180-1183) repeats "necessary, not sufficient".

DISQUALIFYING FAILURES
- 04g-D9 [criteria 1, 5] book/04g-joint-allocation.qmd:137-138, "The two terms buy different things" -- "(in the plans compared in @sec-joint-results every line is in the data at every split)" is false. @sec-joint-results compares the random sparse family at c = 8 (1 loc) and c = 4 (2 loc) alongside the circulant one (@fig-joint-budget). design_random_sparse() (R/16_mating_design.R:72-76) samples round(c*nA) of the nA*nB cells with no per-line guarantee. At 20 x 20 and c = 4, P(a given line uncrossed) = C(380,80)/C(400,80) = 0.0102, giving 0.41 uncrossed lines per plan in expectation. Simulated: 33 % of plans have at least one uncrossed line. At c = 8 the expectation is 0.001 per plan. Within the random family, the number of lines in the data therefore changes with the budget split, which is exactly the confound the parenthesis rules out. The new text also disagrees with :1256-1257, which correctly restricts the property to the circulant comparison. This is a factual claim about the simulated design, introduced by the D4 fix, and it is wrong for one of the three plan families it covers. Related: such a plan passes the connectivity screen. On a random c = 4 plan with male 19 uncrossed, joint_connectivity() returned n_comp_cross = 1 and n_comp_loc = 1. The prose at :460 ("necessary") is not contradicted by this, but no part of the chapter tells the reader that an uncrossed line is invisible to both counts.

NON-DISQUALIFYING OBSERVATIONS
- 04g-M10 book/04f-sparse-testing.qmd:653 (outside the file under review, consequence of the D1 fix) -- 04f says of the female x male x location metric "@sec-joint-criteria proposes one". 04g:472-474 now says the counts are "a screen, not the female x male x location metric @sec-sparse-limits asked for, which remains open". The book contradicts itself across the two chapters. 04f:1403 ("defines a pair of counts for it") is compatible only loosely.
- 04g-M11 R/18_joint_allocation.R:102-104 (roxygen of joint_pev) -- "It is trace(C^GCA) / (nF + nM)". The code (:122) returns that quantity times vc$s2res, because sparse_coef() builds the residual-scaled coefficient matrix (W'W + G^-1 * s2res/s2). The roxygen identity therefore lacks the s2res factor. The chapter prose (:436-437) does not name which coefficient matrix it means and is not wrong under the sigma-weighted MME convention, but the documented identity does not match the returned value. Rankings at fixed components are unaffected.

WHAT WAS VERIFIED
- Purled 04g ran end to end against the worktree package (3.5 s). Every stopifnot passed: sparse_vc ratios, incidence N_P = n_c k, tester ceiling, alias chunk, connectivity counts.
- tbl-joint-alias: n_comp_cross = 1, n_comp_loc = 1, rank 3 of 4 columns. The cell ordering "male fastest" matches sparse_parent_index() (R/17:24-26).
- Implication n_comp_cross = 1 => n_comp_loc = 1 when every location is planted -- proved by hand. A cross planted in two parent-disjoint location sets would share its parents between them, so each cross lies wholly in one set, and both parent sets are non-empty.
- Inline step z-values: 0.51, 1.15, 3.41, 2.14 (160 vs 80) and 1.86, 3.37, 0.48, 4.38 (80 vs 40). Four steps are under 2 SE, and the labels printed match. One step is in [2, 3): 160 vs 80 at h2 = 0.4, high SCA, z = 2.14. tst_below = TRUE (tester below circulant c = 4 in every scenario and strategy).
- Headline 1 made-cross claim: the 40-vs-160 extremes reverse in all four scenarios. At h2 = 0.2, high SCA, 80 at two (0.610) < 160 at one (0.618). Every other 80-vs-160 made-cross step reverses.
- n_disc = 2 of n_plans = 120 random c = 4 plans, in 2 scenarios. n_comp_loc == 1 everywhere.
- pot: tester optimised - start +0.0189 +/- 0.0070, z = 2.71, 4/4 positive. po_all +0.0027 +/- 0.0022. pc_all +0.0057 +/- 0.0033, 16/24 positive.
- Kept exchange-search time: 16.4 min. Three cells are omitted at 1861, 6694 and 8338 s. The rest are 46-49 s, so the caption's "far outside the rest" holds.
- tbl-joint-misspec values: -1.8e-05 +/- 1.9e-05 (low), -5.7e-05 +/- 5.0e-05 (high), unchanged from iteration 1.
- Notation table (90-notation.qmd): the sparse_vc() names s2fl/s2ml/s2sl exist, g^A/g^B are defined earlier in the appendix, and GD_l = 1 - theta matches 2 pbar(1 - pbar) for 0/0.5/1 hybrid coding with self-coancestry included.
- Uncrossed-line probability in random sparse plans: hypergeometric 0.0102 per line at c = 4. Simulated over 2000 plans: mean 0.40 uncrossed lines per plan, P(>= 1) = 0.33. At c = 8 the mean is 0.0015.
