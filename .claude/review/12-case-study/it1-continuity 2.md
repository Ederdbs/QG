# 12-case-study -- iteration 1 continuity report (chapter mode, read-only on chapters and THREAD)

Chapter: `book/12-case-study.qmd` (282 lines; last chapter of "Evidence and practice" and of the book).
Read: CLAUDE.md, `_quarto.yml`, `90-notation.qmd`, THREAD entries 00-10b, the verdict files named in the brief, and the earlier chapters passages each finding cites. Line numbers are the current worktree files. I did not re-run the chapter; numbers taken from `it1-audit.md` are marked (audit).
Files named in the brief but absent from the worktree: `11b-diversity-across-cycles/it4-verdict.md` (only it3 exists). 04d it4, 04f it5 and 11 it4 verdicts contain no mention of chapter 12 (grep) and open nothing against it. Nothing below rests on an open item of 04e, 04g, 10 or 11c: where a finding touches them, the independent source is named.

Owner key: **12** = this chapter changes; **earlier, now** = an earlier chapter should be edited in this round; **later/Owed** = open chapter (04e, 04g, 10, 11c) or an Owed line.

## What the opening and the promises to 12 look like

- Opening (12:8-9): "Everything the book has built, run once, on one dataset ... Then the checklist." It does not say why it follows 11c, and the claim is wider than the chapter (12-C16).
- Promises made to 12 by earlier chapters, and whether 12 keeps them:
  - 00:751 (reading map, "how does one run end to end"): kept.
  - 03:483 (additive-model caveats "of @sec-case-study remain"): kept (12:172-176).
  - 02b:643 (`weights = NULL` taken by 12): kept (12:26).
  - 05b:2100 ("states the same separation from the other side"): kept (12:172-176). 05b:2139 ("the extension @sec-case-study names and the book does not attempt"): kept, wording issue 12-C17.
  - 05:983 (z-scores through `discriminatory_power()`): kept (`res$z_scores`).
  - 05:1821 ("`ne_parents()`, which @sec-case-study reports alongside the two lenses for every scenario"): kept as a table, but 12:74-76 attributes to 05 a diagnostic 05 did not call for (12-C1).
  - 05:2147-2148 ("owns ... the status number and allelic richness"): **not kept for allelic richness** (12-C9).
  - 07:926-929, 08b:24 (the prediction-error caveat repeated): kept in substance (12:166-170), sources thin (12-C13).
  - 10:1584 and 10b:1935 ("validate on the second lens and on allelic richness ... (@sec-case-study)"): the checklist has the item (12:235-240) but the chapter computes no allelic richness (12-C9).
  - 11b:40 (one-cycle item), 11b:285 (freeze p0 in the checklist), 11b:632 (log(1 - F) item), 11b:857 (injection), 11b:1024-1032 (the four "Across cycles" items): all four items exist at 12:247-253; 11b:1031 is right that "freeze p0" is in "Setting up" (12:206). Kept.
  - 11c:132 (the book "declines to report" a rate-based N_e, citing @sec-case-study) and **11c:854-858 (two across-cycles items of 12 that do not exist): broken** (12-C8).
  - 90:162, index.qmd:131-134 (12 writes the simulation setting as F_ST; read as F_BN): Owed 00-C18, still open (12-C6).
- Owed items settled elsewhere: `11:306` and `11b:201` no longer carry the encoding/DE wording (grep of 11, 11b, 10: no "encoding, not the algorithm", no "slightly better plans per cycle"; 11:654-660 and 11b:513-517 state the budgets and defer to @sec-advanced). 12 is the last carrier (12-C3).

## Findings

### 12-C1 (H) -- N_s is read as a head count of "a healthy pool"; owner 12
- 12:74-76, 12:84, 12:87-89 ("the status number barely moves ... A programme reporting only N_s would see a healthy pool"), 12:242 ("N_s is reported").
- 06:176-222 (@sec-ns, approved): on molecular `f`, N_s = 1/(2 theta) lies in [1/2, 1], "Five individuals give N_s = 1, not 5", a static descriptor of a set. 07:984-986 (Finding 5 of the recommendation list, approved): N_s "adds no information: it is a monotone rescaling of theta ... lies in [1/2, 1] and is not a head count". 11b:704-712 (callout "N_s does not project this"): a number in [1/2, 1] "cannot be set beside an effective size in individuals". 12:183-184 itself says N_s is a static descriptor.
- The chapter divides N_s by its maximum (`Ns_relative`) and sets it against `Ne_parents` as if both were counts; "healthy" has no definition on a scale floored at 0.5. The audit's point (R2): since alpha pins theta (alpha 0 to 3.9 %), N_s moving ~1.5 % is algebra, not a finding. The contrast that survives is theta (pinned) against a head-count-scale metric (`Ne_parents`, audit 27.5 to 13.5, random 37.3).
- Also 12:74-76: "the diagnostic @sec-genomic-era called for". 05:1815-1821 ("The diagnostic nobody runs") calls for F_hom and F_drift computed separately on a panel not used in the management, with `ne_parents()` as this book's implementation of the parent-count side; it does not call for N_s against N_e,par. The F_hom/F_drift diagnostic is what 12:93-103 does. 05's "not used in management" qualifier is absent from 12:235 (12-C14).

### 12-C2 (H) -- the GD_BS rise "is heterosis"; owner 12
- 12:106-109: "`GD_BS` rising across scenarios is selection concentrating on the most complementary line pairs ... it is heterosis".
- 06:553-560 (approved): concentrating usage inside one pool raises GD_BS "without any change in the lines" (tbl-catalogue-gdbs-conc, concentration alone reproduces a share of the truncation rise); 05 @sec-era-step6 algebra, same; 11b:1015-1020 (approved): "this chapter has no arm that separates drift from selection for GD_BS, so the rise is not attributed to selection, and with an additive index it is not evidence about heterosis"; 05b (flat-dominance conditions of the GD_BS row, THREAD 05b entry): GD_BS is the heterosis engine only under flat dominance, inbred parents, complete factorial. 12:172-176 says six lines later that the index is additive and that `index` values are not performance predictions.
- Complementarity is not in the objective and dominance is not in the model; the mechanism is untested here. 12's own pointer (@sec-stages, Trap 3, "hold in a band") stays true.

### 12-C3 (H) -- "Running the optimiser" contradicts 07 Finding 4, 10b and the chapter's own run; owner 12 (settles Owed 12:222)
- 12:225 "The search is encoded on **line weights**, not hybrid keys"; 12:228 "The per-line usage cap is enforced in the decoder, not by penalty"; 12:226 warm start (true).
- The chapter runs `stage2_select()`, which calls `sel_de()` on n_sel hybrid keys (R/11_stage2.R:115-116) with `max_use = NULL` (R/11_stage2.R:75; CLAUDE.md, default NULL on purpose). So the pipeline it prints is hybrid-key DE with no cap.
- 07:540-546, 07:611-632 (approved): Finding 4 is a verdict on an N-key arm at one budget, 3 seeds, "Neither arm is `sel_de()`", and does not settle which encoding is ahead; 10b (THREAD 10b entry, @sec-advanced / 10b:754-840): `sel_de()` is **ahead** of the line-encoded `sel_de_fast()` uncapped (+0.3004, s.e. 0.0087, book; +0.1103, not resolved, production), equal when capped (the decoder satisfies the cap by construction), and a swap local search is ahead of both as whole algorithms; 11:654-660 and 11b:513-517 already say so. For the hybrid encoding the cap is a penalty/repair that coincides, because `decode_rank()` takes no `max_use` (R/03_de_select.R:138-139; also 10:898, 10 open, so R/03 is the cited source).
- Evaluation budget: 12:28 `NP = 100, itermax = 200` is 2e4 nominal evaluations; 10 and 10b measure DE below a fine greedy sweep at 30,000 evaluations (10b: "DE below greedy is the 30,000 reading, not a property of the method"). The chapter's price list (12:145-159) is built from a DE at a budget the cited chapters place below a fine greedy sweep; the audit measured the alpha = 0 point 1.100 at this budget against 1.178 at package defaults (audit R7). The chapter states neither budget nor this.
- Owed from THREAD (10b entry, "-> `11`, `12`, `11b`"; 07 entry "-> `12`: `12:222` echoes ..."): this is the one still open. 12:225-228 has to say which encoding the run uses, its budget, and that the cap is enforced by the decoder only in the line-encoded route.

### 12-C4 (H) -- "checked against the continuous relaxation" and "a slack constraint means the search never reached the boundary"; owner 12
- 12:229-231. 10b (@sec-bound, 10b:990-1192; THREAD 10b): the old construction (a relaxation point inside the budget) is **not** a bound; the valid statement is the Lagrangian `ocs_bound()`; `converged` is a stalling criterion, not a certificate; where it did not converge (production) "report no gap at all"; "converged and gap large: keep going". 10b:1926-1935 gives the six-step protocol the chapter should follow or point at. CLAUDE.md ("Never report a gap against an uncertified bound").
- "A slack constraint means the search never reached the boundary" holds as an unconverged-search sign only in the cached run of 07 ("not a general rule", 07:639-642); 10b @sec-advanced-headtohead: at production "the cap binds and the budget does not". At the ceiling the budget is slack by definition (12:58-61).
- The chapter never computes a bound or a gap (no chunk), so the item is a recommendation untested in the chapter, and the chapter cites neither @sec-ocs, @sec-combinatorial nor @sec-advanced (0 citations of the Optimisation part).

### 12-C5 (M) -- N_e,par "is a second constraint" and "the reason" are not what the run does; owner 12
- 12:74-77, 12:227. `stage2_select()` has no `ne_par_min` (R/11_stage2.R:71-75); the chapter's own table shows `Ne_parents` falling across scenarios (audit: 27.5 to 13.5, random 37.3). 10b @sec-defast-restrictions (10b:842-988): the only route with an N_e,par floor is `sel_de_fast()`, the floor of 30 binds and was not met (25.71 at floor 30, missed by 4.29); `sel_local_search()` has no such argument. So "a second constraint" is a recommendation no route in the package meets in the evidence of the book. Say so, or call it a report line here.

### 12-C6 (H) -- F_ST for the simulation setting at 12:179 (Owed 00-C18); owner 12
- 12:179 "the same $F_{ST}$" is the Balding-Nichols setting (`fst = 0.15`); 12:95 has a column `F_ST`, the statistic GD_BS/GD_T. Two quantities, one symbol in one chapter. 90:158-163 (and index.qmd:131-134) list 12 among the chapters that write the setting as F_ST and say "read it there as F_BN"; 05b:618-623 and 05:663, 05:1784 use F_BN. Change 12:179 to F_BN.

### 12-C7 (H) -- the Across-cycles paragraph against 11b: count of cycles, resolution, "the index gain is realised once"; owner 12
- 12:186-194: "@sec-cycles runs fifteen of them and finds the unconstrained programme ahead of the alpha_max = 0.02 programme, on the seed mean, for eight cycles and behind it for the rest."
- 11b:333-345 (crossover-means chunk, approved): seed-mean index of the unconstrained programme is highest "through cycle 7" (k_02 = 8) and below the 0.02 programme from cycle 8; 11b:345-352: at cycle 8 the paired difference is "not resolved by five seeds"; 11b:737: "About eight cycles" is the mean of the five per-seed crossovers; 11b:777-778: all five seeds ahead only from a later cycle; 11c:127-128: cycle 0 "is the displacement of the selection from the base before any recycling, not a generation". "Fifteen cycles" are cycles 1-15; "ahead for eight cycles" counts cycles 0-7 (eight including 0, seven without). "Behind it for the rest" then covers 8-15, not 7. The sentence mixes both counts, drops "five founder draws" and presents the cycle-8 tie as a finding.
- 12:157-159 "the diversity is not recoverable next cycle while the index gain is realised once" is the opposite of the finding the paragraph at 12:186-194 cites: gain accumulates over cycles (11b: cycle-15 gain +~2.3 for 0.02 over unconstrained, audit) and the constraint's cost is paid back after about eight cycles. One chapter, two opposite statements.

### 12-C8 (H) -- the Across-cycles list vs 11b/11c: 11c:854-858 points at items that do not exist; 12:242 against 12:249; owner 11c (reword, open) and 12 (pointer-only line)
- 11c:854-858: "Two points of this chapter belong with the across-cycles items of @sec-case-study: a projection from a fitted rate is not validated by the R^2 of the log(1 - F) regression, and the covariance term is outside every one-locus metric." 12:245-253 has four items (ledger, log(1 - F) linearity, injection, cost per cycle); no item on forecasts, R^2, or the covariance term. 11b:1024-1032 describes the same four items correctly. THREAD (11b/11c entries) records the "12 gains one line" sentence as gone from 11c, but the pointer remains.
- 11c:126-132: "N_e is rate-based ... a quantity that the book declines to report for managed populations (@sec-choosing-recommendation, @sec-case-study) ... The contradiction is not resolved here." 12:242 says a rate-based N_e is not reported, and 12:249 asks for the regression whose slope gives Delta F = 1 - e^slope and so N_e = 1/(2 Delta F) (05:1155-1230; 11b:645-700 fits it and declines to report N_e for the managed arms). Within 12 the two lines need one sentence (the regression is read for linearity, not converted to N_e); 11c then applies the rate as a fitted parameter, which is its open issue (11c-D16), not 12's.
- 12:249 "checked for linearity" omits the check 05 prescribes ($R^2$ threshold 0.995, @sec-era-step4) and that 11b:662-668 found the threshold does not separate the arms at 11b's scale; cite @sec-era-step4 and @sec-cycles-rate.
- Resolution: nothing of 11c's open results should be carried into 12. Either 11c rewords its sentence to a pointer at @sec-limits itself (later/Owed to 11c), or 12 adds one line for forecasts/R^2/covariance term with a bare pointer to @sec-limits and no number (this chapter). Choose one; today it is neither.

### 12-C9 (H) -- "Allelic richness is computed on the returned plan" (12:237-238); broken promise of 05:2147-2148 and 10:1584/10b:1935; owner 12
- The chapter prints `alleles_lost` (count of markers with MAF >= 0.05 in the pool and < 0.05 in the plan, A_lost) and `rare_retained` (12:66-67, 12:94-95, 12:115). It computes no `alleles_retained`/`alleles_retained_fast()`: `stage2_select()` builds its metrics with `metrics_full()` (R/01_metrics.R:365-372), which has neither. 90:99 (and 07:966-972): allelic richness A_ret is "not A_lost".
- 05:2147-2148 says the checklist of 12 "owns the ones that need its data (for instance the status number and allelic richness)"; 10:1584 and 10b:1935 send the reader to 12 for "validate on ... allelic richness". Nothing in 12 does that.
- 12:237-238 "the one metric carrying information theta does not": 12:98-100 says F_drift/cov_diag is the unpinned lens; 07:1000-1005 (Finding 3, approved) says A-NE, E-NE, theta_between and allelic richness all keep rank variation at fixed theta; R/01_metrics.R calls `alleles_lost` "genuinely independent of theta". Drop "the one"; say which quantity (A_ret or A_lost) is meant and compute it or rename the item.

### 12-C10 (H) -- `alpha_max` names the ceiling in 12:58 and the budget in 12:193, 12:216; owner 12
- 12:58 "`alpha_max` is the attainable ceiling from @sec-baseline: the loss pure truncation would incur"; 12:193 "alpha_max = 0.02 programme" (a budget); 12:216 "The attainable alpha ceiling is computed *before* choosing alpha_max."
- 90:290-296 and 90:306: $\alpha_{\max}$ is the budget ("a policy decision"); $\alpha_{\text{trunc}}$ is the ceiling ("a ceiling for $\alpha_{\max}$", @sec-ocs, @sec-baseline); 09:436-446 and 06:922-936 use alpha_trunc/"attainable". The collision is real because the code list element `res$ref$alpha_max` (R/11_stage2.R:165) and the column `alpha_max` of `res$metrics` (R/11_stage2.R:137) are the same name for the ceiling and the requested budget respectively. Say once that the ceiling is $\alpha_{\text{trunc}}$ and that `res$ref$alpha_max` is its code name.

### 12-C11 (M) -- the checklist item "diversity cost per cycle is reported when cycle time is shortened" (12:253) and the "per-stage loss ledger" (12:247); owner 12
- 04d:8-14 and 11:716-718 (both approved): the book reports the year-15 **stock** and the cycle length, "not a per-cycle rate", because the cycles of that programme overlap (04d @sec-programme-assumptions); 11b:1031-1032: its rate is per cycle in a discrete-cycle model (C11), "so it says nothing about the fourth item". So no chapter measures the per-cycle cost the item asks for; 12 neither says that nor cites @sec-programme.
- "The per-stage loss ledger" (12:247) is 08's re-based stage ledger (@sec-stages-ledger, cached external, 8 pools); 04d has a different "diversity ledger" (@sec-programme-ledger, GD of PYT and parents in years 1-15, 90:94 cites it). One word, two objects; 12 cites neither.

### 12-C12 (M) -- "DH induction, not hybrid mining, is usually where the diversity goes" (12:247-248); owner 12
- 08:849-854 (approved): S2 carries the largest share of the summed (re-based) stage losses only for the `UC only` arm, in 8 cached pools of an external study, "a statement about the first arm, not about DH induction in general"; with the diversity term "the three stages carry similar shares"; the shares do not add to an end-to-end loss. "Usually" generalises it. The same file's 12:186-190 already states the arm-specific form correctly.

### 12-C13 (M) -- sources for the prediction-error caveat and "optimistic ceiling" (12:164-172); owner 12 (Owed 08b-C16)
- 12:164-172 cites only 07 Finding 5. 08b:17-25 (it "will repeat the caveat" is promised by 08b:24) fits actual GBLUP/BayesB and reports realised accuracies per CV scheme; 07:671-678 compares orders of magnitude (CV2 about 0.9, CV1 0.5-0.7). Add @sec-genomic-prediction. THREAD 08b entry: "`11b`, `11c` and `12` cite @sec-genomic-prediction nowhere" (still true).
- "costs several times the diversity that independent error of the same size does": 07:876-884 is a ratio of means for truncation at nominal r = 0.6, 60 seeds, one teaching scale (audit: about 3.0), and greedy behaves the other way under independent error (07:808-818); the realised-gain difference is "not a result" (07:885-893).
- 11b:178-186 (C7): "no claim is made that they are an upper bound, for any budget" across cycles, "the direction of that effect is not known". 12:169-170 "optimistic ceiling" is true for one cycle and the reported index (07:926-929, 03 callout) and stays; it must not be read as covering trajectories.

### 12-C14 (M) -- "The pools are symmetric by construction" (12:178-181); owner 12
- 12:178-181 says a real programme "will find one pool eroding faster". The chapter's own symmetric pools already do (audit: truncation `Ne_lines_A/B` 4.7/12.0 in 12:67 and, over 10 simulation seeds, a flip of direction with ratios 1.2 to 3.2); 05:1796-1800 and 06:553-562 show the same on the same dataset (06:559-562 prints truncation `Ne_lines_A`/`Ne_lines_B`). So per-pool reporting is not a precaution for asymmetric real pools; it is needed even here.
- Also 05 A5/A2 assumptions are silent in the cannot-tell list (12-C15).

### 12-C15 (M) -- assumptions of the chapter not stated in its "cannot tell you" list, and the crossing/testing part uncited (check 8, check 5); owner 12
- 12 reuses results derived under A1-A8 (00:20-35): inbred parent lines (A2), neutral unlinked markers in linkage equilibrium (A5), markers that are also the causal set (00:~34-39; 05 A5), the complete 25 x 25 factorial with every hybrid made and evaluated. The list at 12:161-200 names six limits and none of these. 11b:146-165 (C1, C2) and 11b:194-200 (C10) state them; 11c:849-853 names "the crossing plan behind the 625 hybrids (@sec-mating, @sec-sparse, @sec-joint), the estimation of marker effects (@sec-genomic-prediction), the selector (@sec-advanced)" as assumed.
- 12 cites none of @sec-mating, @sec-sparse, @sec-joint (Mating and testing design part, 0 citations), @sec-limits (0), @sec-programme (0), @sec-plant-literature (0), @sec-genomic-prediction (0), @sec-ocs/@sec-combinatorial/@sec-advanced (0). Owed (audit R16): one item for the crossing plan and testing design, naming 04e/04f/04g without any number from them (04e, 04g are open; nothing in 12 may rest on 04e-D19/D20, 04g-D6).

### 12-C16 (M) -- opening and scope: "Everything the book has built", "The whole pipeline" (12:8-11); owner 12
- 00:174-178: the package's stage 1 / stage 2 "are not" the S1-S4 stages of @sec-stages; they are the data flow. The chapter's "whole pipeline" is `stage1_simulate()` -> `stage2_select()`, the hybrid-selection side only (S4 and the contract of 03); S1-S3 (pool conservation, DH crosses, line selection) and the mating/testing design are not run. The opening does not say why it follows 11c (the limits chapter: what the metrics and the forecast cannot see) or why a single-cycle run closes a part titled "Evidence and practice"; 11b:1024-1028 already says "a pointer to this chapter and not its cycle 0".

### 12-C17 (M) -- "Estimating the dominance deviations" (12:264-269); owner 12 (Owed 05b/04e/06/08b/12 residue; 05b-protocol)
- 12:265 "dominance deviations" for $d_k$: the name is "dominance effects" (90:210; 06, 08b changed; THREAD 05b entry: 04e:176 and 12:265 remain).
- 12:267-269 "putting a number on the lambda of @sec-catalogue -- waits on an estimate of d": 05b:2120-2135 (@sec-heterosis-lambda): lambda "needs two covariances, not d itself", "A programme does not need per-locus dominance effects to weight the two diversity terms"; per-locus d is needed for ranking crosses (05b:2136-2139, "the extension @sec-case-study names and the book does not attempt"). 12 merges the two.
- The "what to run" half of 05b (@sec-heterosis-protocol, 05b:1447) has no inbound citation (THREAD, foundations-C13); 12:265-269 and 12:172-176 are the natural place; cite it.

### 12-C18 (M) -- "Periodic germplasm injection is planned. A closed elite pool depletes however well the constraint is managed" (12:251-252); owner 12
- 11:435-437 and 11:695-697 (approved): "on the one simulation reviewed [sanchez2023]", an inference; 11b:853-905: the book's own injection is one event, the programme's own founders (not exotic or bridging material), five founder draws; GD_T up and F_drift down at once, index lower, "has not repaid by cycle 15"; 11b:853-857 says 12 "prescribes" it. The checklist item carries neither the provenance nor the cost.

### 12-C19 (M) -- "Where to go next": prediction error compounded across cycles (12:271-275); owner 12
- "@sec-cycles shows concentration is what erodes the programme's future": 11b measures an association between parental genic variance and last-cycle gain over 225 run-cycles (five independent founder draws), and says the mechanism was not tested (11b:~395-430, 11b:620-625); it does not isolate concentration. 11b C7 (11b:178-186): "the direction of that effect is not known". "(C7)" resolves (11b:178). The sentence should carry 11b's wording or point at it.

### 12-C20 (L) -- `p0` "set once in `build_ctx()`" (12:196-197) and the re-anchoring demonstration (12:199-200); owner 12
- 11b:226-232: `build_ctx()` sets `p0 <- colMeans(X)` **on every call** and has no `p0` argument; `run_cycles()`/`cycle_ctx()` overwrite it with the founding value (11b:283-290). "Set once" is true of a single call in this chapter only. The zero is exact only for the set the base was built from (the whole pool); on a selected subset the re-anchored value is the displacement from the pool, not zero (11b:226-236). 12:199-200 states the whole-pool case as general.

### 12-C21 (L) -- numbers the reader will compare with other chapters; owner 12
- `n_sel = round(0.10 * 625) = 62` (12:21) where 05-11b use 60 of 625 (09:8, 07:664-668, 11b:1026 notes it). The ceiling printed in `res$ref` (0.0394, audit) is not comparable with 09's alpha_trunc 0.0412 (n = 60, B = 400) or 07's 4.129 % (B = 2000); the chapter says neither, and says nothing of its `B_null = 500`, `B_full = 80`. 06:965-975 gives the relative standard error of a z computed from `B_full` subsets (1/sqrt(2(B_full - 1)), 8 % at B_full = 80); the z of +7.7 in 12 (audit) carries that, undisclosed. 12:34-41 also says "identical pipeline" for `run_all.R`, which runs `round(0.04 * N)` (inst/scripts/run_all.R:33) and `NP`/`itermax` of the package defaults, not 10 %, 100, 200.
- Scale names (Owed 00-C22): 12:35 "the production scale of `sim_config`". 05:150-156 (A8): production in the package's own declaration is 71 + 71 lines, 25000 markers (R/00_data.R:9-10, `_common.R:20-22`); `sim_config` default 50 + 50, 5000 is what `inst/scripts/` run "which several chapters also call the production scale". 06:936-940 and 06:904-910 name both. 12:35 still uses the one word for the `sim_config` default without saying which. This is the Owed item (H by the brief's rule, kept L here only because the text is one sentence; raise to H if the part closes without it).

### 12-C22 (L) -- notation and pointer details; owner 12
- 12:172 "An additive $\mathbf{G}$ misses heterosis": 90:42-47 reserves $\mathbf G$ for the VanRaden prediction matrix; the chapter uses no G (the index is the additive `X %*% beta`, 03). Say "an additive index".
- 12:102 `max_deviation_from_Eq3`: Meuwissen's numbering; the book's label is @eq-era-cov (05:510-516); cite it. The identity is printed, not asserted (audit R5).
- 12:58-61 "`stage2_select()` says so rather than returning a solution that merely looks constrained": true of the function (09:444); the call at 12:22 is wrapped in `suppressWarnings()`.
- 12:118-120 "A metric near zero ... cannot be serving as a constraint": contradicted by `z_GD` = 0.00 at the alpha = 0 scenario in the chapter's own table (audit R1) and by 06:970-975 ("the lens the constraint does not pin separates truncation more strongly than the lens it does"): a constrained metric is zero at its own budget by construction; it reads against the reference of the budget, not zero.
- 12:221 and 12:157 "the knee": 09:484-488 (approved): "It does not locate a sharp knee, and none is claimed. Where along it to set the budget is the committee's decision" (and 90:290 "a policy decision"); 11b:736-790: the best budget depends on the horizon and "no budget is recommended for any horizon outside the cycles tabulated". 06:940 and 10:1575 (10 open) still say "locate the knee"; so the book says two things. Owner 12 first (carry 09's wording); later/Owed: 06 (closed) and 10 (open) at their next edit.

## Items for earlier chapters

| Chapter | Line | Matter | Status |
|---|---|---|---|
| 11c | 854-858 | points at two across-cycles items of 12 that do not exist (12-C8) | open chapter: later/Owed to 11c (or 12 gains the line) |
| 11c | 126-132 | "the book declines to report" a rate-based N_e, then reports it; 12 is cited as the source (12-C8) | open: Owed 11c-D16, not resolved by 12 |
| 06 / 10 | 06:940, 10:1575 | "locate the knee" vs 09:486 (12-C22) | 10 open: Owed; 06 at next edit |
| 05 | 05:1821, 05:2147-2148 | attributes to 12 the status number and allelic richness; 12 computes neither as such | keep 05; 12 changes (12-C1, 12-C9) |
| 90 | 162 | lists 12 among chapters to read F_ST as F_BN | keep; 12 changes (12-C6) |

No earlier approved chapter needs an edit now for 12 to be consistent; every H finding is owned by 12 except the 11c pointer (12-C8).

## Owed items naming 12: state at this iteration

| Owed (THREAD) | State | Finding |
|---|---|---|
| 12:222 encoding / DE-budget wording (07 Finding 4, 10b) | OPEN (now 12:225-231); 11:306 and 11b:201 settled | 12-C3, 12-C4 |
| 12:164-172 cites only Finding 5 | OPEN | 12-C13 |
| 12:191 "ahead ... on the seed mean" | PARTLY (arm named; count of cycles and five draws open) | 12-C7 |
| 12:241-252 Across cycles (forecasts, R^2, covariance term; fifth of six; 11c:854-858; 12:242 vs 12:249) | OPEN | 12-C8 (and 12-C7 for "one cycle, not a trajectory") |
| 12:264 "dominance deviation" | OPEN (now 12:265) | 12-C17 |
| 12:35 scale names (00-C22) | OPEN | 12-C21 |
| 12:179 F_ST for F_BN (00-C18) | OPEN | 12-C6 |
| 12:174-175 / 12:262-266 keep true, cite protocol | OPEN (cite) | 12-C17 |
| @sec-limits and the Mating and testing design part uncited | OPEN | 12-C15 |
| 12:170 "optimistic ceiling", 12:167 Finding 5 (keep true) | kept; add scope | 12-C13 |
| 12:187 stage-level diversity; 12:205 freeze p0; 12:196-200 | kept true | 12-C20 (qualifier only) |
| 11:306, 11b:201 reworded earlier | SETTLED in 11 and 11b | -- |

## Inbound `@sec-` counts

Method: every `{#sec-...}` mapped to its file (`book/*.qmd`, 29 files; chapter 12 owns one label, `sec-case-study`); every `@sec-...` match resolved to its owner; citations from a file to itself discarded; one count per match (a line with two matches counts twice). Broken targets: **none**. Columns: matches / distinct citing files.

| Chapter | Inbound | Files | | Chapter | Inbound | Files |
|---|---|---|---|---|---|---|
| 00 hybrid-programme | 77 | 20 | | 10 combinatorial-selection | 50 | 14 |
| 01 coancestry | 42 | 15 | | 10b advanced-selection | 48 | 14 |
| 02 subdivided | 66 | 18 | | 04e mating-design | 93 | 17 |
| 02b response | 57 | 16 | | 04f sparse-testing | 58 | 11 |
| 05b heterosis-dominance | 117 | 22 | | 04g joint-allocation | 24 | 10 |
| 03 simulating-crosses | 46 | 21 | | 11 plant-literature | 18 | 8 |
| 04 population-sizing | 31 | 13 | | 04d breeding-programme | 27 | 8 |
| 04b backcross-introgression | 17 | 10 | | 11b diversity-across-cycles | 56 | 20 |
| 04c alphasimr-pipeline | 31 | 13 | | 11c limits | 22 | 9 |
| 05 genomic-era | 85 | 23 | | **12 case-study** | **23** | **15** |
| 06 metric-catalogue | 81 | 24 | | 90 notation | 40 | 12 |
| 07 choosing-metrics | 97 | 21 | | 91 package | 0 | 0 |
| 08 pipeline-stages | 51 | 17 | | 92 verification | 7 | 7 |
| 08b genomic-prediction | 40 | 17 | | 93 corpora | 5 | 2 |
| 09 optimal-contributions | 73 | 19 | | | | |

Chapter 12's 23 inbound citations come from 00:751, 02b:643, 03:483, 05:983, 05:1821, 05:2147, 05b:2100, 05b:2139, 07:926, 08b:24, 10:1584, 10b:1935, 11b:40, 11b:285, 11b:632, 11b:857, 11b:1024, 11c:132, 11c:856, 90:162 and the structural 91:67, 92:240, index:150. It has a job: eight earlier chapters promise it something and four of the promises are checked above.

Outbound from 12 (the other direction): 03 (1), 05 (2), 05b (2), 06 (3), 07 (2), 08 (2), 11b (4). **Zero** citations of 00, 01, 02, 02b, 04, 04b, 04c, 04d, 04e, 04f, 04g, 08b, 09, 10, 10b, 11, 11c. For the three chapters of the Mating and testing design part, inbound from the "Evidence and practice" part is 04d (all three), 11 (all three), 11c (all three), 11b (04e only via @sec-mating:197, 309), 12 (none). 04g has 24 matches from 10 files, none from Metrics, Optimisation or 12.

## Not verified

I did not re-run chapter 12 or any chunk. Figures marked (audit) (27.5 to 13.5 `Ne_parents`, DE index 1.960 against truncation 1.970, alpha = 0 point 1.100 against 1.178 at defaults, the 3.0 ratio of 07, `Ne_lines_A/B` flip over 10 seeds, z of +7.7) come from `it1-audit.md` and are not independently confirmed here. 10b's numbers are taken from its THREAD entry and the passages quoted, not recomputed. The missing `11b it4-verdict.md` was not located.
