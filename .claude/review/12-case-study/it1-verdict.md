# 12-case-study -- iteration 1 verdict

Text judged: `book/12-case-study.qmd` (282 lines, no uncommitted diff against HEAD). Line numbers are the current file. The audit, refs and continuity reports were read as pointers only. Every decisive number below was recomputed in a scratch directory with `pkgload::load_all()` of this checkout.

VERDICT: REJECTED

INPUT-REPORT IDS (iteration 1, so there is no previous verdict. The IDs of the three input reports are mapped here and never renumbered.)
- 12-R1 / 12-C22(z) -- CONFIRMED -> 12-D2
- 12-R2 / 12-C1 -- CONFIRMED -> 12-D1
- 12-R3 / 12-C2 -- CONFIRMED -> 12-D3
- 12-R4 / 12-C3 / 12-C4 / 12-C5 / 12-B2 / 12-B3 -- CONFIRMED -> 12-D4
- 12-R5 / 12-B7 / 12-C22(Eq3) -- CONFIRMED (non-disqualifying) -> 12-M2
- 12-R6 -- CONFIRMED -> 12-D6 (the caption contradicts the figure). The label/alt-text form belongs to quant-editor.
- 12-R7 / 12-C7(knee, "realised once") / 12-C22(knee) -- CONFIRMED -> 12-D5
- 12-R8 -- CONFIRMED -> 12-D8
- 12-R9 / 12-C14 -- CONFIRMED -> 12-D10. The F_BN half -> 12-D9
- 12-R10 / 12-C7(count) -- CONFIRMED -> 12-D7
- 12-R11 / 12-B4 / 12-C12 -- CONFIRMED -> 12-D12
- 12-R12 / 12-C8 -- CONFIRMED -> 12-D14. "However well" -> 12-D15
- 12-R13 / 12-C21 -- CONFIRMED -> 12-D16, plus 12-M8 for the undisclosed n_sel and B values
- 12-R14 / 12-C13 -- CONFIRMED (non-disqualifying) -> 12-M5
- 12-R15 / 12-C17 -- CONFIRMED (non-disqualifying) -> 12-M4
- 12-R16 / 12-C15 -- CONFIRMED -> 12-D11
- 12-R17 / 12-C9 -- CONFIRMED -> 12-D13
- 12-R18 / 12-C22(suppressWarnings) -- CONFIRMED (non-disqualifying) -> 12-M1
- 12-R19 -- CONFIRMED (non-disqualifying) -> 12-M3
- 12-R20 -- process note for the author. It is not a finding on the text.
- 12-B1 -- REFUTED. @sec-baseline runs from 06:814 to 06:943 and does contain the attainable ceiling: chunk `attainable-alpha` (06:928-931) computes `alpha_loss(sel_truncation(...))` and 06:935 says "truncation reaches alpha = ...". 09:441-442 also cites @sec-baseline for it. The pointer at 12:58 is valid.
- 12-B5 / 12-C19 -- CONFIRMED -> 12-D15
- 12-B6 -- CONFIRMED (non-disqualifying) -> 12-M9
- 12-C6 / 12-C10 -- CONFIRMED -> 12-D9
- 12-C11 / 12-C18 -- CONFIRMED (non-disqualifying) -> 12-M10
- 12-C16 -- CONFIRMED (non-disqualifying) -> 12-M7
- 12-C20 -- CONFIRMED (non-disqualifying) -> 12-M6
- 12-C22(G) -- CONFIRMED (non-disqualifying) -> 12-M6

DISQUALIFYING FAILURES

- 12-D1 [criterion 1, 4] 12:74-89 (the N_s / N_e,par table and its reading) and 12:242.
  - The chapter divides `Ns` by its maximum and sets `Ns_relative` (0.975-1.000) beside `Ne_par_relative` (0.36-1.00). It concludes that "A programme reporting only N_s would see a healthy pool".
  - On molecular `f`, theta_S lies in [1/2, 1] at biallelic loci, so N_s = 1/(2 theta) lies in [1/2, 1] (06 @sec-ns, 06:189-205: "not a number of individuals"). A ratio to the maximum of a quantity floored at 1/2 does not measure "health". Reading N_s beside a head-count quantity treats it as one.
  - "Barely moves" is not a finding either. Because GD = gd_ref (1 - alpha) and theta = 1 - GD, N_s = 1 / (2 (1 - gd_ref (1 - alpha))) is a fixed function of the alpha the DE constrains. With gd_ref = 0.32598: alpha 0 gives 0.7418 and alpha 0.0394 gives 0.7280, which are exactly the printed values. The column restates the constraint.
  - "The diagnostic @sec-genomic-era called for" (12:75) is wrong. 05 calls for F_hom against F_drift, not N_s against N_e,par.
  - Interpretation is presented as a result.

- 12-D2 [criterion 1, 4] 12:118-120 "A metric near zero is not distinguishing this plan from chance, and cannot be serving as a constraint."
  - The table directly above contradicts it: `z_GD` = 0.00 at `DE_alpha_0.00`, the scenario in which GD is the binding constraint (achieved alpha -8.3e-6).
  - The zero holds by construction, because alpha is measured against the mean of the same random null. Over DE/null seeds 1-6, z_GD at alpha = 0 is 0, -0.12, -0.08, 0.13, -0.03, 0.05.
  - The stated rule fails exactly on the metric the chapter constrains.

- 12-D3 [criterion 2, 4] 12:106-109 "GD_BS rising across scenarios is selection concentrating on the most complementary line pairs ... it is heterosis."
  - The objective is an additive index. The chapter says so at 12:172-176, and the model has no dominance, so "complementary pairs" has no meaning in this objective.
  - The rise is measured: GD_BS 0.0393 (alpha 0) to 0.0514 (truncation), against 0.0357 random. Its cause is not.
  - 06:553-560 shows that concentration of line usage alone raises GD_BS. 11b:1020-1023 (approved) says "the rise is not attributed to selection, and with an additive index it is not evidence about heterosis".
  - The GD_BS = heterosis-divergence identity holds only under the flat-dominance, inbred, complete-factorial conditions of 05b/02 @tbl-keystone, and none of them is declared here.
  - A mechanism is asserted with no arm that tests it.

- 12-D4 [criterion 1, 5] 12:225-231, "Running the optimiser". Each item contradicts the code the chapter runs or the approved chapters.
  - (a) "Encoded on line weights, not hybrid keys". `stage2_select()` calls `sel_de()` on n_sel hybrid keys (R/11_stage2.R:115-116), so the chapter's own frontier comes from hybrid-key DE. 10b:1947-1955 finds `sel_de()` ahead of the line-encoded `sel_de_fast()` uncapped, and says no experiment isolates the encoding.
  - (b) "Cap enforced in the decoder, not by penalty". In `sel_de()` the cap is a penalty (R/03_de_select.R:199-214, `viol + sum(pmax(0, cnt - max_use))/(2 n_sel)`). The chapter's run has no cap (`max_use = NULL`).
  - (c) "N_e,par is a second constraint, not a report line". `stage2_select()` has no N_e,par argument (R/11_stage2.R:71-75), so in this run N_e,par is a report line. It falls from 27.5 at alpha 0 to 13.5 under truncation, against 37.3 random.
  - (d) "Checked against the continuous relaxation. A large gap means the optimiser has not converged". The valid bound is the Lagrangian `ocs_bound()` with its `converged` attribute. A point of the relaxation inside the budget is not a bound (CLAUDE.md; 10b @sec-bound). A gap mixes optimiser and relaxation slack and does not separate them (10:1316-1331). "A slack constraint means the search never reached the boundary" is "not a general rule" (07:639-642).
  - (e) The chapter computes no bound and no gap, so the item is untested here.
  - (f) It cites none of @sec-ocs, @sec-combinatorial or @sec-advanced.

- 12-D5 [criterion 3, 6, 4] 12:63-72, 12:145-159, 12:221 (the price list and "choose the knee").
  - (a) Every point is one DE run (one seed) at a reduced budget the text does not state: NP = 100, itermax = 200, about 2e4 evaluations. The package default, and the `run_all.R` setting, is NP = 300, itermax = 2000, about 6e5.
  - Recomputed: at the defaults the alpha = 0 point is 1.178, against 1.100 in the chapter (+0.078). Across six DE/null seeds at the chapter's budget, the sd at alpha = 0 is 0.019, so the gap is about 4 sd. At 0.98 % the values are 1.472 against 1.414.
  - The "price per percentage point" therefore measures the optimiser's budget, and no dispersion is shown.
  - (b) At the loosest budget (requested alpha = the ceiling, which truncation satisfies), the DE plan scores index 1.960 at alpha 0.0357. Truncation scores 1.970 at 0.0394, a feasible point the DE does not reach. This holds in all six seeds (1.9600-1.9606). The warm start in R/11_stage2.R:105-108 does not include truncation.
  - The endpoint of the plotted frontier is therefore not the constrained optimum, and the text does not say so (a limitation omitted, criterion 6).
  - (c) "Choose the knee" (12:157, 12:221): the chapter's curve has no knee. The secant slopes are 0.32, 0.27, 0.18, 0.18 index per percentage point. 09:486-487 (approved): "It does not locate a sharp knee, and none is claimed. Where along it to set the budget is the committee's decision."
  - (d) "the diversity is not recoverable next cycle while the index gain is realised once" (12:158-159) contradicts the trajectory the chapter cites at 12:191-194. In `book/data/cycles_trajectory.csv` the index accumulates, and the alpha = 0.02 arm ends +2.33 (paired s.e. 0.32, 5/5 draws) above the unconstrained arm at cycle 15.

- 12-D6 [criterion 5] 12:147-155, the figure (`unnamed-chunk-13-1.png`, viewed).
  - The caption says "Each point is one diversity budget; the curve is what index it buys".
  - `type = "b"` joins all nine rows of `res$metrics` in row order. Four of the nine are references (`ref_truncation`, `ref_trunc_cap`, `ref_max_div`, `ref_random`), not budgets.
  - The drawn "curve" includes a diagonal from truncation to `ref_trunc_cap` and a segment from `ref_max_div` to `ref_random`.
  - The caption contradicts the figure.

- 12-D7 [criterion 3, 5] 12:191-194 "@sec-cycles runs fifteen of them and finds the unconstrained programme ahead ... on the seed mean, for eight cycles and behind it for the rest."
  - Recomputed from `book/data/cycles_trajectory.csv` as paired differences (0.02 minus unconstrained, 5 founder draws): negative at cycles 0-7, +0.020 (s.e. 0.374, 3/5 draws) at cycle 8, +0.34 (s.e. 0.34) at cycle 9, +0.68 (s.e. 0.35) at cycle 10, and 5/5 draws ahead only from cycle 12.
  - The count is inconsistent. The fifteen cycles are 1-15, of which seven (1-7) are ahead. "Eight" holds only if cycle 0 is counted, and then there are sixteen points.
  - The crossing at cycle 8 is a tie inside Monte Carlo error. 11b:345-352 says it is "not resolved by five seeds".
  - The sentence gives neither n = 5 nor any dispersion.

- 12-D8 [criterion 3] 12:139-143, the "backbone" and robustness to alpha.
  - 18 hybrids are chosen under all five DE budgets in one DE/null seed. Over seeds 1-6 the count is stable (18, 16, 18, 19, 19, 18) but the membership is not: the intersection of the six sets is 3 and the union 38.
  - "Robust to the choice of alpha" holds within one run and not across the optimiser's seed, and the seed dependence is undisclosed.
  - "Hybrids that appear only at the loosest budget are the ones being bought with diversity" is computed in no chunk (2 hybrids in seed 1). It is an interpretation with no measurement.

- 12-D9 [criterion 5] Two symbols, each with two meanings in one chapter.
  - $F_{ST}$: at 12:179 ("the same $F_{ST}$") it is the Balding-Nichols simulation setting `fst = 0.15` (R/00_data.R:21, `bn()` at 41), i.e. F_BN. The column `F_ST` at 12:94-95 is the statistic GD_BS/GD_T (0.110 random, 0.164 truncation). 90-notation lists 12 among the chapters where the setting must be read as F_BN (Owed 00-C18). Confusing F_BN with a realised F_ST rejects in its own right.
  - alpha_max: it is the attainable ceiling at 12:58 ("`alpha_max` is the attainable ceiling") and the policy budget at 12:193 ("the alpha_max = 0.02 programme") and 12:216.
  - The scenario label `DE_alpha_3.94` reports the requested value. The `alpha` column reports the achieved value (0.0357), and the text does not say so.

- 12-D10 [criterion 4] 12:178-181 "The pools are symmetric by construction ... a real programme will find one pool eroding faster than the other".
  - The sentence attributes asymmetric erosion to real-pool differences. The chapter's own symmetric pools already show it: truncation `Ne_lines_A/B` = 4.69 / 12.01 (12:66-67 table).
  - Recomputed over simulation seeds 1-8, the direction flips: 4.69/12.01, 10.62/6.36, 9.47/6.36, 4.55/14.78, 6.77/10.06, 10.45/5.82, 6.12/9.42, 10.22/6.08.
  - The inference is contradicted by the chapter's own output.

- 12-D11 [criterion 2] 12:161-200, "What this simulation cannot tell you". The assumptions the results rest on are used and not declared:
  - inbred parent lines (A2);
  - unlinked neutral markers that are also the causal set (A5);
  - the complete 25 x 25 factorial with every hybrid made and evaluated;
  - n_sel = 10 % of the candidates;
  - no per-line cap.
  11c:849-853 names the crossing plan (@sec-mating, @sec-sparse, @sec-joint), marker-effect estimation (@sec-genomic-prediction) and the selector (@sec-advanced) as assumed. Chapter 12, which runs the pipeline, names none of them.

- 12-D12 [criterion 3, 7] 12:247-248 "DH induction, not hybrid mining, is usually where the diversity goes."
  - 08:849-851 (approved) limits this to the merit-only arm, in 8 cached founder pools of one external study, "not about DH induction in general". With the diversity term "the three stages carry similar shares".
  - "Usually" generalises one arm of one cached study, attributed to no source.

- 12-D13 [criterion 1, 5] 12:237-238 "Allelic richness is computed on the returned plan -- it is the one metric carrying information theta does not."
  - The chapter computes `alleles_lost` (A_lost at MAF 0.05) and `rare_retained`, not allelic richness A_ret. `stage2_select()` uses `metrics_full()`, which has no A_ret. 90-notation separates A_ret from A_lost.
  - "The one metric" contradicts 12:98-100 of the same chapter (F_drift / cov_diag is the lens alpha does not pin) and 07 Finding 3.
  - The promises of 05:2147-2148 and 10b:1935 that this chapter computes allelic richness are not kept.

- 12-D14 [criterion 5] 12:242 against 12:249, and 11c:854-858.
  - 12:242 says a rate-based N_e is not reported. 12:249 asks for the log(1 - F) regression, whose slope is that rate. 11c:126-132 cites @sec-case-study for the refusal and declares the contradiction unresolved. Chapter 12 does not say in what sense the regression is read.
  - 11c:854-858 says two points (a projection from a fitted rate is not validated by the R^2 of the regression; the covariance term is outside every one-locus metric) "belong with the across-cycles items of @sec-case-study". The four items at 12:247-253 contain neither.
  - Cross-chapter H finding (12-C8), open.

- 12-D15 [criterion 4, 7] Two universal or causal claims that the cited chapter does not support.
  - 12:273-275 "@sec-cycles shows concentration is what erodes the programme's future". 11b:626-630 says such a mechanism "is a hypothesis; nothing here tests it", and its genic-variance analysis is declared an association. This is causation attributed to a chapter that disclaims it.
  - 12:251-252 "A closed elite pool depletes however well the constraint is managed" is universal. The evidence is one simulator, three budgets, five founder draws and fifteen cycles (11b), with no reference for the general statement.

- 12-D16 [criterion 5, 3] 12:34-41 "The identical pipeline at the production scale of `sim_config` ... is `inst/scripts/run_all.R`".
  - Not identical. `run_all.R:33` uses `n_sel = round(0.04 * N)` against the chapter's 0.10, and the package-default B_null/B_full/NP/itermax against the chapter's 500/80/100/200 (see 12-D5 for what that budget moves).
  - "Production scale of `sim_config`" conflicts with the package's own declaration (`book/_common.R:20-21`: "The production scale is n_pool_A = n_pool_B = 71 and m = 25000"), with 05 A8 and with 06:936-939, which name both scales separately (Owed 00-C22).
  - "~4 min" and "~6 min" are typed, not measured.

NON-DISQUALIFYING OBSERVATIONS

- 12-M1 12:58-61 with 12:22 -- "`stage2_select()` says so" (with a `warning()`, R/11_stage2.R:98-101), but the call is wrapped in `suppressWarnings()`. True of the function, not shown by this chapter.
- 12-M2 12:98-103 -- the deviation is printed, not asserted. The chapter only prints it ("verify it"), declares no tolerance and has no `stopifnot()`, so nothing fails if the identity breaks. Recomputed: 6.68e-17. "Eq3" is Meuwissen et al. (2020) Eq. 3 (book label @eq-era-cov), and it is cited neither way. The `sum(G) == 0` check prescribed at 12:207-208 and the ceiling identity (ref_truncation alpha == res$ref$alpha_max; recomputed equal, 0.03938109) are not run either.
- 12-M3 12:113-120 -- `z_ANE` is defined nowhere in the chapter. The "worse" direction differs by column (`z_F_drift` positive = worse, `z_Ne_parents` negative = worse), and the text does not say so. No Monte Carlo error is given for z computed from B_full = 80 subsets (06:965-975 gives about 8 % relative s.e.).
- 12-M4 12:265-269 -- two problems.
  - "Dominance deviations" for d_k: the book's name is "dominance effects" (90:210, Owed from 05b).
  - "Putting a number on the lambda of @sec-catalogue ... waits on an estimate of d" merges two things that 05b:2120-2139 separates: lambda needs two covariances, not d locus by locus, while ranking crosses needs d per locus.
  - @sec-heterosis-protocol is not cited (Owed foundations-C13).
- 12-M5 12:166-170 -- the error caveat.
  - "Several times" is a ratio of means of about 3.0 (07 Finding 5: truncation, nominal r = 0.6, teaching scale), and the scope is not stated.
  - "Optimistic ceiling" is supported for the reported index of one cycle only, and 11b C7 makes no bound claim across cycles.
  - @sec-genomic-prediction is not cited (Owed 08b-C16).
- 12-M6 Notation and code wording.
  - 12:172 "An additive $\mathbf G$" uses the VanRaden symbol (90:42-47) for the additive index.
  - 12:196-197 "set once in `build_ctx()`": `build_ctx()` sets `p0 <- colMeans(X)` on every call, and `cycle_ctx()` overrides it (R/14_cycles.R:46-47, 64).
- 12-M7 12:8-11 -- "Everything the book has built" and "the whole pipeline" overstate the scope. Only stage1_simulate -> stage2_select runs. S1-S3 of @sec-stages and the mating/testing design are not run (00:174-178).
- 12-M8 12:21, 12:28 -- three run settings are not stated: n_sel = 62 (10 %) where the rest of the book uses 60 of 625, B_null = 500, and B_full = 80. The ceiling 0.0394 is therefore not comparable with 09's 0.0412 or 07's 4.129 %.
- 12-M9 12:187-190 -- "the effective number of parents" names this book's `Ne_parents`. 08's row is the N_e of an unrecorded set. The one end-of-pipeline outcome that did move (GD of the final set, post hoc) is omitted.
- 12-M10 12:247, 12:251-253 -- three checklist items lack measurement or provenance.
  - "Per-stage loss ledger" names two different objects in the book (08 @sec-stages-ledger, 04d @sec-programme-ledger), and neither is cited.
  - No chapter measures a per-cycle diversity cost under shortened cycle time (04d reports stock, 11b C11).
  - The injection item carries neither provenance nor the cost measured in 11b.
- 12-M11 (whole chapter) -- 0 citations of @sec-limits, of the Mating and testing design part (04e/04f/04g), of @sec-ocs/@sec-combinatorial/@sec-advanced and of @sec-genomic-prediction, although the checklist rests on each.

Count of non-disqualifying failures: 11. That alone exceeds the threshold of three.

WHAT WAS VERIFIED
- The chapter's pipeline, purled by hand with the chapter's arguments. Scratch file `v12/run.R` (book_cfg seed 1, stage2 seed 1; 3.5 s) printed:
  - `res$ref`: gd_ref 0.3259845, alpha_max 0.03938109, n_sel 62.
  - DE index 1.1004 / 1.4141 / 1.6767 / 1.8523 / 1.9600 at achieved alpha -8.3e-6 / 0.00983 / 0.01954 / 0.02951 / 0.03566; truncation 1.9701 at 0.03938.
  - Ns 0.7418 -> 0.7292 (truncation 0.7280); Ns_relative 0.977-1.000.
  - Ne_parents 27.46 -> 14.37 (truncation 13.49, random 37.32).
  - GD_BS 0.0393 -> 0.0499 (truncation 0.0514, random 0.0357); F_ST column 0.110-0.164.
  - max |cov_diag - (F_hom - F_drift)| = 6.68e-17.
  - z_GD = 0.00 at alpha 0; z_Ne_parents -5.63; z_F_drift +7.71.
  - Backbone 18; never chosen 386.
- N_s as a fixed function of alpha -- derived above (12-D1). 1/(2(1 - 0.32598)) = 0.7418 and 1/(2(1 - 0.32598 * 0.96062)) = 0.7280 match the printed values.
- DE/null seed dependence -- `v12/seeds.R` with seeds 1-6:
  - backbone sizes 18, 16, 18, 19, 19, 18; intersection 3, union 38;
  - alpha-0 index range 1.069-1.116 (sd 0.019);
  - ceiling-budget DE index 1.9600-1.9606 every seed, against truncation 1.9701;
  - z_GD at alpha 0: 0, -0.12, -0.08, 0.13, -0.03, 0.05;
  - "only at loosest budget" = 2 (seed 1).
- The DE at package defaults -- same script, 1.1 min. Index 1.178 / 1.472 / 1.714 / 1.864 / 1.962, truncation 1.970.
- The cycle trajectory -- `book/data/cycles_trajectory.csv`, paired 0.020 minus unconstrained by cycle (mean, s.e., draws > 0):
  - cycle 0: -0.288 (0.056, 0); cycle 7: -0.256 (0.358, 2); cycle 8: +0.020 (0.374, 3); cycle 9: +0.341 (0.340, 3); cycle 10: +0.677 (0.346, 4); cycle 12: +1.364 (0.336, 5); cycle 15: +2.331 (0.323, 5);
  - cycles range 0-15.
- Per-pool asymmetry under symmetric pools -- `v12/pools.R`, truncation of 62 hybrids, simulation seeds 1-8 (values listed in 12-D10).
- Code facts, read from source:
  - `stage2_select()` calls `sel_de()` with no N_e,par argument and a warm start without truncation (R/11_stage2.R:71-116);
  - the `sel_de()` cap is a penalty (R/03_de_select.R:199-214);
  - `run_all.R:33` uses n_sel at 4 %;
  - `sim_config` fst = 0.15 (R/00_data.R:21);
  - `_common.R:20-21` declares 71 + 71 / 25000 as production.
- Figure `book/_freeze/12-case-study/figure-html/unnamed-chunk-13-1.png`, viewed: the line joins the reference rows.
- Cross-chapter text read directly:
  - 06:814-943 (@sec-baseline contains the ceiling, so 12-B1 is refuted);
  - 06:176-205 (@sec-ns);
  - 09:436-446 and 09:480-488 (no knee claimed);
  - 11b:1015-1035 (GD_BS not heterosis; the four across-cycles items);
  - 11b:630 (mechanism a hypothesis);
  - 10b:1945-1955 (encoding not isolated; sel_de ahead uncapped);
  - 11c:850-858 (pointer to non-existent 12 items);
  - 08:851 ("not about DH induction in general");
  - 05b:2118-2139 (lambda needs two covariances).

NOT VERIFIED
- The "~4 min" / "~6 min" timings of `run_all.R` / `run_benchmark.R` and the README numbers (12:39-40) -- not run here. Running both scripts would verify them. They are non-decisive, and the "identical" claim fails on source alone (12-D16).
- 07 Finding 5's ratio of about 3.0 (12-M5) -- taken from the audit and refs reading of 07, not recomputed. Re-running 07's error chunk would verify it. Non-decisive here.
- 08's ledger numbers (12-M9, 12-D12) -- cached external data with no producer in the repo. The wording of 08:849-851 was read; the numbers were not recomputed.
