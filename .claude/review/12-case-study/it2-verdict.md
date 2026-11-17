# 12-case-study -- iteration 2 verdict

Text judged: `book/12-case-study.qmd` (630 lines, working tree of branch `review-pending-chapters`), the new target `case_study` in `book/scripts/regenerate.R` (949-997), the cached `book/data/case_study_frontier.csv` (120 rows) and `case_study_kept.csv` (355 rows), the one-sentence edits at `book/06-metric-catalogue.qmd:940-941` and `book/10-combinatorial-selection.qmd:1575-1576`, and the 12 entry of `.claude/review/THREAD.md` (676-684). Line numbers are the current files. The author's response (content and code passes) was read as a pointer only. Every decisive number was recomputed in a scratch directory against `pkgload::load_all()` of this checkout: the chapter was knitted in full (every `stopifnot()` passed), and the whole `case_study` cache was regenerated independently from the 20 `stage2_select()` calls.

VERDICT: REJECTED

PREVIOUS IDS
- 12-D1 -- CLOSED -- `Ns_relative` is no longer read as pool health. 12:139-147 places N_s in [1/2, 1] (@sec-ns) and derives N_s = 1/{2[1 - GD_ref(1 - alpha)]}, which 12:128-130 asserts. The column is stated to restate the constraint. "Healthy pool" and the misattributed "diagnostic" are gone, and 12:114-117 matches 05:1815-1822.
- 12-D2 -- CLOSED -- 12:206-216 no longer says that a z near zero means "not a constraint", and it states the alpha = 0 exception. A residual imprecision in the reason given is recorded as 12-M15.
- 12-D3 -- CLOSED -- 12:179-190 measures the GD_BS rise (0.0393 -> 0.0514, random 0.0357) and says its cause is not identified. It cites @tbl-catalogue-gdbs-conc for concentration, denies a heterosis reading under the additive model, and names the @tbl-keystone conditions as 02:1039 states them.
- 12-D4 -- CLOSED -- Checked against the code, 12:531-554 now holds. (a) `stage2_select()` calls `sel_de()` on hybrid keys (R/11_stage2.R:115-116). (b) In `sel_de()` the cap is a penalty. (c) The only route that takes `ne_par_min` is `sel_de_fast()` (R/12_search.R:297), and it enters as a penalty that is not enforced (roxygen 274-281). (d) The `ocs_bound()` protocol matches 10b:1928-1934. (e) "This chapter computes no bound and no gap". (f) @sec-ocs, @sec-combinatorial, @sec-combinatorial-warm, @sec-advanced, @sec-bound and @sec-defast-restrictions are cited and resolve.
- 12-D5 -- CLOSED -- Each part is fixed. (a) The DE budget is stated (12:43-46), and replication over 10 DE/null seeds at both budgets is reported with s.d., paired gain, s.e. and seeds positive (12:291-314, 402-418). The cache reproduces exactly (see WHAT WAS VERIFIED). (b) The ceiling-budget shortfall against truncation is disclosed and counted, 10/10 seeds at both budgets (12:394-400, 410-413). (c) The knee is withdrawn, with secant slopes at both budgets (12:391-393, 413-414, 427-429). (d) "Realised once" is withdrawn (12:430-432).
- 12-D6 -- CLOSED -- The figure was knitted and viewed. The red DE line joins the five DE rows only, the four references are separate black marks with a legend, and the grey and blue seed lines sit behind. The caption (`cap_frontier`) and the alt text are built from objects and describe what is drawn.
- 12-D7 -- CLOSED -- 12:490-494 gives the draws (five) and does not count cycles by hand. It says the crossing is not resolved by five draws, as 11b @sec-cycles-trajectory says.
- 12-D8 -- CLOSED -- "Backbone" and "robust to alpha" are withdrawn. 12:265-276 reports kept-under-every-budget counts per seed and the intersection and union over 10 seeds, from a cache whose seed 1 is asserted equal to the live run. The cache reproduces exactly.
- 12-D9 -- CLOSED for 12 -- 12:457 writes $F_{BN}$, and 12:163-164 defines the `F_ST` column as GD_BS/GD_T (@eq-f-stats), distinct from F_BN. $\alpha_{\text{trunc}}$ (ceiling) and $\alpha_{\max}$ (requested) are separated (12:87-91), and so are the requested label and the achieved column (12:106-109). The notation appendix has not followed: see 12-M16.
- 12-D10 -- CLOSED -- 12:455-466 reads the 4.69 / 12.01 asymmetry as a property of the draw in exchangeable pools, and per-pool reporting is motivated on that basis.
- 12-D11 -- CLOSED -- 12:471-481 declares the assumptions. Inbred parents (A2). Unlinked biallelic markers that are also the effect loci: `simulate_data()` draws an effect for every marker (R/00_data.R:130). The complete 25 x 25 factorial, with the design assumed away (@sec-mating/@sec-sparse/@sec-joint). n = 10 %, no cap, and the hybrid-key DE.
- 12-D12 -- CLOSED -- 12:577-582 carries 08:849-855's scope: one study, 8 cached pools, the merit-only arm, similar shares with the term, and "where diversity goes in general is not established".
- 12-D13 -- CLOSED -- 12:561-565 names $A_{\text{ret}}$ (@sec-richness) and drops "the one metric". It states that the chapter reports A_lost and `rare_retained` only. The 05:2147, 10:1585 and 10b:1935 pointers now land on a checklist item that exists.
- 12-D14 -- CLOSED -- 12:583-587 reads the log(1 - F) regression as a linearity diagnostic and not as an N_e. It carries 11c:854-858's two points, and it agrees with 12:569-571 and 07:982-986.
- 12-D15 -- CLOSED -- The mechanism claim is replaced by an association that 11b does not test (12:620-623). "However well" is replaced by provenance: @sanchez2023 via approved 11:426-430/694-697, and 11b's three closed arms still falling at cycle 15, recomputed below.
- 12-D16 -- CLOSED -- The callout (12:52-68) no longer says "identical". It separates the `sim_config` default (50 + 50, 5000; R/00_data.R:17-19) from the declared production scale (71 + 71, 25000). It states n at 4 % (run_all.R:33) and the default B/NP/itermax, and it removes the typed timings.
- 12-M1 -- CLOSED -- `suppressWarnings()` is replaced by `withCallingHandlers()`, which muffles only messages containing `'NP'` (12:27-36; regenerate.R uses the same handler). The new wording of 12:92-97 is recorded as 12-M12 and 12-M13.
- 12-M2 -- CLOSED -- Eq. 3 is asserted at 100 eps (12:174-175; observed 6.68e-17), along with the ceiling identity (12:83-84) and the three N_s identities (12:128-130). @eq-era-cov and Meuwissen et al. (2020) Eq. 3 are cited. `sum(G) == 0` is now a citation (@eq-g-sum-zero), not an unrun check.
- 12-M3 -- CLOSED -- A-NE is defined, consistent with 06:390-401, and the "worse" direction is stated per column. The relative s.e. 1/sqrt(2 * 79) = 7.96 % is given under declared normality, as 06:970-974 gives it.
- 12-M4 -- CLOSED -- "Dominance effects" is used. The two needs are separated as 05b:2128-2139 separates them, and @sec-heterosis-protocol is cited.
- 12-M5 -- CLOSED -- The scope matches 07 Finding 5 (07:868-892): one cycle, teaching scale, truncation at nominal r = 0.6, correlated against independent error. No ratio is typed. @sec-genomic-prediction is cited, and no bound is claimed across cycles.
- 12-M6 -- CLOSED -- The VanRaden symbol is gone. The `build_ctx()` sentence now matches the code.
- 12-M7 -- CLOSED -- 12:8-14 limits the scope to the two stages and names what is not run.
- 12-M8 -- CLOSED -- 12:39-50 states n = 62, B_null 500, B_full 80, NP/itermax and seed 1, and that the results are not comparable with 07/09.
- 12-M9 -- CLOSED -- 12:483-489 now uses 08's terms (a set the file does not record) and names the final-set GD as post hoc.
- 12-M10 -- CLOSED -- The ledger cites @sec-stages-ledger and is distinguished from @sec-programme-ledger. The cycle-time item says that no chapter measures a rate. The injection item carries its provenance and 11b's cost (11b:881-891).
- 12-M11 -- CLOSED -- Every one of the 47 distinct @sec/@eq/@tbl/@fig targets in 12 resolves (grep, listed below).
- 12-B1 -- CLOSED (no defect) -- It was refuted at it1: @sec-baseline contains the ceiling (06:926-935). The pointer stays, and @sec-ocs (09:439-446, where $\alpha_{\text{trunc}}$ is named) is added. Nothing to fix.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 12-M12 12:95-97 -- "The call above muffles one warning only, the `DEoptim` advice ...; any other warning, that one included, would surface."
  - The nearest antecedent of "that one" is the muffled DEoptim advice, so the sentence reads as saying that the muffled warning would surface.
  - The intended referent, the over-ceiling warning of 12:92-93, is two clauses back.
  - The muffled warning does fire: 5 times per call, 100 times over the 20 cached calls in the reproduction. The sentence never says so.
- 12-M13 12:92-93 -- "`stage2_select()` raises a warning for any budget above it rather than return a plan that merely looks constrained."
  - The code does both. It warns (R/11_stage2.R:99-102) and then runs `sel_de()` for every requested alpha, inoperative ones included (R/11_stage2.R:114-117). It returns that scenario's plan under its `DE_alpha_*` label.
  - The description of the function's behaviour is wrong. No number in this run depends on it, because the automatic grid ends at the ceiling.
- 12-M14 12:423-424 -- "Its loosest point stays below a feasible plan at both budgets, so that shortfall is not a matter of evaluations."
  - The evidence is two budgets, nominal 2e4 and 6e5 evaluations. The paired gain at k = 5 is +0.0013 (s.e. 0.0005, 7/10 seeds), against a truncation margin of 0.0057-0.0102 over the 20 (seed, budget) pairs.
  - That supports "not closed by a 30-fold increase in evaluations". The sentence states it without that scope.
  - The same paragraph already says that whether the warm start explains it "is not run here".
- 12-M15 12:209-211 -- "it is near zero by construction: alpha is measured against the mean of the same null".
  - `gd_ref` is the mean of the `B_null` = 500 cheap draws (R/02_benchmark.R:19, 22). `z_GD` is centred and scaled on the separate `B_full` = 80 draws (R/02_benchmark.R:60-62).
  - So z_GD at alpha = 0 is zero in expectation only, with a Monte Carlo s.d. of about sqrt(1/80 + 1/500) = 0.12 z units, which is the "error of the null mean" that 06:978-980 adds.
  - The 0.00 printed at seed 1 is the near-coincidence of the two means: (gd_ref - mean_80)/sd_80 = -0.002 at seed 1, against -0.163, -0.089 and +0.068 at seeds 2-4.
  - "Near zero" holds. The stated reason ("the same null") is inexact.
- 12-M16 90-notation.qmd:160-163 (dependency of the 12-D9 fix) -- The notation appendix still lists @sec-case-study among the chapters that "write that parameter as $F_{ST}$ ... read it there as $F_{BN}$".
  - After the fix, 12 writes $F_{BN}$ for the setting (12:457), and its only `F_ST` is the statistic GD_BS/GD_T (12:163-164).
  - A reader who follows 90 would now read 12's `F_ST` column (0.110-0.164) as the Balding-Nichols parameter, which is the confusion 12-D9 removed.
  - It is recorded as Owed -> 90 in THREAD:680. It is open, and it is outside 12's file.
- 12-M17 .claude/review/THREAD.md:676, 683-684 -- The 12 entry describes a state that no longer exists.
  - The heading still reads "it1 fix, content pass; verdict pending".
  - The "Owed -> quant-Rwrite (12 chunk code)" bullet lists as owed the items that the code pass has done: the figure label and redraw, the three `stopifnot()` groups, the dispersion over seeds and the kept-across-seeds count.
  - The render-batch bullet still says "if the 12 figure gets a label". It now has one, so the orphan `book/_freeze/12-case-study/figure-html/unnamed-chunk-13-1.png` (present) is due for deletion.
  - The entry does not record the new `case_study` target or the two cached files. `book/data/case_study_frontier.csv` and `case_study_kept.csv` are untracked (`git status`). The purled script fetches them from GitHub raw (book/downloads/12-case-study.R:63, 312, 355), so it cannot run until they are pushed.

Count of non-disqualifying failures: 6 (12-M12 to 12-M17). That is at or above the threshold of three, and it rejects the text. Of these, 12-M12, 12-M13, 12-M14 and 12-M15 are in the chapter's own changed prose. Those four alone exceed the threshold.

WHAT WAS VERIFIED
- Full knit of the chapter -- `v12b/knit/ch12.Rmd` (a copy of 12-case-study.qmd with `_common.R` and the two CSVs, `knitr::knit` after `pkgload::load_all()` of this checkout). It completed with no error, and every `stopifnot()` passed: the ceiling identity, the three N_s identities, Eq. 3 within 100 eps, kept seed 1 = live, frontier seed 1 = live, gain > sd_ch at k = 1-4, and trunc_wins == 10. The inline values obtained:
  - gd_ref 0.3259845, alpha_trunc 0.03938109, n 62 of N 625;
  - N_s 0.7418 -> 0.728; Ne_parents 27.5 -> 13.5 (random 37.3); GD_BS 0.0393 -> 0.0514 (random 0.0357); F_ST 0.1205-0.1640 = GD_BS/GD;
  - z_GD 0 / z_Ne_parents -5.6 / z_F_drift 7.7 at DE_alpha_0.00; relative s.e. 8 %; max |cov_diag - (F_hom - F_drift)| = 6.68e-17;
  - chosen_in_all_DE 18, never chosen 386;
  - live secant slopes 0.32, 0.27, 0.18, 0.18; DE at the ceiling budget 1.960 at alpha 0.0357, against truncation 1.970 at 0.0394;
  - Ne_lines_A/B under truncation 4.69 / 12.01; F_BN 0.15.
- Figure `fig-case-study-frontier`, knitted and viewed. The red line joins the five DE rows, the references are four separate black marks (truncation 1.97 at 3.94 %; the others between 0.07 and 0.78), and the grey and blue seed lines sit behind. The caption and alt text match the figure.
- Independent regeneration of the whole `case_study` cache -- `v12b/regen.R`, the same 20 `stage2_select()` calls as regenerate.R:960-990 (simulation seed 1, n 62, B_null 500, B_full 80, seeds 1-10 x {NP 100/itermax 200, NP 300/itermax 2000}), 12 min. Against the committed files:
  - `case_study_frontier.csv`: 120/120 rows matched on (budget, seed, scenario); max |diff| = 0 for alpha_max, alpha, index and Ne_parents; k coded 1-5 on DE rows and NA on ref_truncation.
  - `case_study_kept.csv`: identical after sorting.
  - No warning other than DEoptim's `'NP'` advice was raised (that advice fired 100 times).
- Summary statistics recomputed from my regeneration, with my own pairing code rather than the chapter's (seed, k):
  - chapter-budget s.d. per k: 0.023, 0.018, 0.017, 0.019, 0.0006;
  - paired default-minus-chapter gain: 0.063 (s.e. 0.008, 10/10), 0.042 (0.006, 10/10), 0.034 (0.006, 10/10), 0.040 (0.008, 9/10), 0.0013 (0.0005, 7/10);
  - default-mean secants 0.324, 0.232, 0.164, 0.122;
  - truncation above the loosest DE point in 10/10 seeds at each budget, by 0.0057-0.0102;
  - Ne_parents at k = 1 (chapter budget) 25.29-27.46;
  - kept under every budget per seed: 15-23 (chapter) and 8-24 (default); in all 10 seeds 1 and 0; in any seed 41 and 45.
  - All match the text at 12:265-276 and 12:402-418.
- Null construction (12-M15) -- `null_distribution(ctx, 62, B = 500, B_full = 80, seed = s)` for s = 1-4. (gd_ref - mean_80)/sd_80 = -0.002, -0.163, -0.089, +0.068.
- Code facts read from source:
  - the warm start is 7 greedy plans plus `sel_truncation_cap()`, with no plain truncation (R/11_stage2.R:108-110), as 12:399-400 states;
  - the over-ceiling warning is followed by the DE run (R/11_stage2.R:99-117);
  - z uses `null$full` (R/02_benchmark.R:60);
  - `ne_par_min` exists only on `sel_de_fast()` and `make_fitness_fast()` (grep R/);
  - every marker gets an effect (R/00_data.R:130);
  - `sim_config` is 50 + 50 / 5000 / fst 0.15 (R/00_data.R:17-21);
  - run_all.R:33 uses n at 4 %;
  - the run_benchmark.R:3 header names README.md as its output.
- Cross-references: all 47 distinct @sec/@eq/@tbl/@fig targets of 12 resolve to a label (grep of `{#...}` and `#| label:` over book/*.qmd). @sanchez2023 and @meuwissen2020 are in references.bib.
- Cross-chapter text read directly:
  - 02:1036-1042 (@tbl-keystone GD_BS row conditions);
  - 05:1813-1822 (`ne_parents()` as the implementation), 05:2143-2148;
  - 05b:2120-2139 (lambda needs two covariances; ranking needs d per locus);
  - 06:384-401 (A-NE), 06:546-567 (@tbl-catalogue-gdbs-conc), 06:926-943 (the edited sentence in context), 06:965-980 (relative s.e.);
  - 07:868-892 (Finding 5 scope), 07:932-1001 (recommendation; A-NE/E-NE in Finding 3; no rate-based N_e);
  - 08:840-905 (S2 share in the merit-only arm; S3/S4 raised; final-set GD post hoc);
  - 09:439-446, 09:482-487 ($\alpha_{\text{trunc}}$; no knee);
  - 10:1565-1580 (the edited step 4 in context; step 2 consistent with 12's ceiling finding);
  - 10b:1928-1935;
  - 11:420-430, 11:694-697 (@sanchez2023 as approved);
  - 11b:268-279 (exactly none), 11b:855-891 (injection cost; all three arms still losing), 11b:1026-1036 (the four items);
  - 11c:124-133, 11c:850-858;
  - 90:155-163.
- 11b's "all three closed budgets still losing at cycle 15" -- `book/data/cycles_trajectory.csv`, mean GD_T over the 5 draws at cycles 13/14/15: 0.005 arm 0.2563/0.2535/0.2502; 0.02 arm 0.2166/0.2115/0.2065; unconstrained 0.1836/0.1822/0.1813. All three are falling.
- The two minimal diffs: 06:940-941 and 10:1575-1576 now agree with 09:486-487. A grep of `knee` over book/*.qmd finds no remaining claim to locate one.

NOT VERIFIED
- That `run_benchmark.R` produces "the numbers quoted in `README.md`" (12:61). The script's own header says so. The README now quotes almost no numbers ("10% of your rare alleles"), and running `run_benchmark.R` at the sim_config default would settle it. It is non-decisive, and the chapter quotes none of those numbers.
- 07's rendered A-NE/E-NE residual fractions behind 12:563-564. The wording matches 07:999-1001; the cached redundancy analysis was not re-run. Non-decisive.
