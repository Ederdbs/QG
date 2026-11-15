# 08-pipeline-stages -- continuity review, iteration 1 (chapter mode, read-only)

Scope: `book/08-pipeline-stages.qmd` (459 lines) against 00, 01, 02, 02b, 04, 05, 05b, 06, 07, 90 and the THREAD / part-*.md `Owed` lines naming 08.
Checks run: 1-4, 6, 8, plus the chapter-mode questions (opening, imported results, Owed items). Numbers marked "run" were recomputed in this worktree (`pkgload::load_all`, same seeds as the chunks) and agree with `book/_freeze/08-pipeline-stages` unless stated.
Owner key: THIS = 08 changes; EARLIER = earlier chapter, fix now; LATER = later chapter, goes to Owed.

Opening (08:11-14): says it follows "the previous chapters" and places the metric set at the four stages; it does not say that 07 ended with a recommendation that 08 then applies (see 08-C1), but the transition itself is stated. All outbound `@sec-` targets (sec-hp-cycle, sec-choosing, sec-heterosis, sec-cycles, sec-plant-literature, sec-collapse) resolve.

## Status of the Owed items that name 08

| Owed item (source) | Status in 08 now |
|---|---|
| 07: 08:26-29 metric set | NOT settled -> 08-C1 |
| 00-E4: rename theta_B at 08:91, 08:105; package clash | NOT settled -> 08-C3 |
| 00-C1 / 02-C2: F_ST / G_ST naming of Trap 2 | NOT settled -> 08-C2 |
| 00-C3: 08:69-71 erosion "under selection" | NOT settled -> 08-C16 |
| 00 (B1): 08:160-163 Kadoumi "exactly the two opposite trends" | NOT settled -> 08-C16 |
| 00-C15: largest share unconditional (08:167, 376, 451-452) | NOT settled -> 08-C8 |
| 00: ledger provenance (08:8, 378) | NOT settled -> 08-C10 |
| 00-C35: `Ne` label at 08:352 | NOT settled -> 08-C7 |
| 00-C25: 08:16-21 restates @tbl-hp-stages | NOT settled -> 08-C22 |
| 00-C18: target F_ST = 0.15 at 08:359 is F_BN | NOT settled -> 08-C4 |
| 04-C10: do not claim a plants-per-cross measurement | no claim made; one untested causal sentence -> 08-C18 |
| 05b-C22: Trap 3 / panel quote 05b correctly | symptom sentence yes; two conditions of 05b dropped -> 08-C17 |
| 02b-C14: no back-citation of @sec-response (decide at 08) | open -> 08-C20 |
| foundations-C13 (secondary 08): protocol steps of 05b not cited | not cited; low -> 08-C17 |

## Findings

**08-C1 (H) -- the metric set of 08:26-29 is not the one 07 establishes.** Owner: THIS (Owed from 07).
08:26-29: "the metric set is the one established in @sec-choosing: molecular coancestry as the kernel, GD = 1 - theta as the scale, N_s as the interpretable size, allelic richness as the one non-redundant addition". 07 (THREAD 07 entry; 07:933-975, 07:391, 07:449-454): inside the optimiser proportional loss alpha **and N_e,par** as second constraint; N_s is a free rescaling of theta in [1/2, 1], "not a head count" (06:181-191; 90:636-639); allelic richness is one of several metrics that vary at fixed theta, and the "one real second axis" label is withdrawn. 08 then uses none of N_s or allelic richness in S1-S4 (N_e,par appears only as the mislabelled `Ne`, 08:352), so the sentence also does not describe the chapter.

**08-C2 (H) -- Trap 2 names the book's F_ST "G_ST" and gives the other statistic the symbol F_ST with a "Wright" label.** Owner: THIS (90:270 secondary, LATER/EARLIER-fixable).
- 08:91-96: F_ST^(W) = (theta_w - theta_B)/(1 - theta_B) ("Wright"); G_ST = (theta_w - theta_T)/(1 - theta_T) = Nei's (H_T - H_S)/H_T; 08:88 "Both are in routine use"; 08:114-115 "never compare against a published threshold computed the other way".
- 00:575-581 and 02:348-427 (@eq-f-stats, @eq-f-stats-het): the book's F_ST IS (f~ - f-bar)/(1 - f-bar) = (H_T - H_S)/H_T = GD_BS/GD_T, i.e. 08's G_ST; the between-referenced statistic is "also written F_ST", and 02:409-413 says "This chapter cites no external source for that usage and does not use the statistic"; 05:1770-1790 says "the label 'Wright' is the code's, not a claim about a paper" and cites 08 Trap 2 for the three-way distinction. 90:123 (F_ST = GD_BS/GD_T) and 90:270 (a G_ST row "the F_ST of @sec-genomic-era is this quantity") give one quantity two symbols.
- Consequence inside 08: the sweep column `Fst` (08:131) and the panel column `Fst_Wright` are the between-referenced statistic, but 08:140 ("Hold F_ST in a band"), 08:156 ("treat F_ST as a descriptor") and the checklist (08:439-440) are read by 05b:1426 and 05:1790 as the book's F_ST / GD_BS. Which statistic is held in a band is not stated.
- Ratio claims: 08:86 "up to 2x" matches 02 ([1,2], to 2 as delta p -> 0); the table caption (08:111) "stays near two" is not what `fst_definitions.csv` shows (1.96 at fst 0.02 down to 1.59 at 0.40; run: 1.82 on the chunk's pools).
- Needed from 08: use 02's name for the book's F_ST, name the between-referenced one without "Wright" and "routine use" (02 and 05 found no source), and say which one the band applies to. 90:270 must then carry one symbol for the quantity.

**08-C3 (H) -- theta_B means between-pool coancestry in 08 and within-pool-B coancestry in 90.** Owner: THIS (and EARLIER 05:1777, fix now).
08:91, 08:105 (`theta_B`); 90:205,226 (theta_A, theta_B, theta_AB = within A, within B, between); 00:579 and 02:409-410 write theta_AB for the between term; 05:1777 repeats 08's theta_B. Package clash persists: `theta_decompose()$theta_B` is the between-pool mean (a weighted mean of pair means when more than two pools), `theta_pools()[["theta_B"]]` is within pool B (`R/05_pipeline_metrics.R:74-75`; 90 function column for `theta_pools()`). Also 08 introduces theta_T and theta_w (08:77, 08:91-93) that 90 does not list (00:579 and 02:409 define theta_w locally); foundations-C1 left the home of these symbols open.

**08-C4 (H) -- F_ST used for the Balding-Nichols parameter and for the statistic in the same argument.** Owner: THIS.
08:119-124 and 08:359: "F_ST keeps rising ..."; "expected heterosis does not depend on F_ST at all"; "target F_ST = 0.15" (and `target_fst = fst`, 08:130). 90:150-157 lists @sec-stages among the chapters that write the simulation setting F_BN as F_ST and says "read it there as F_BN"; 05b settled this by writing F_BN for every expectation (05b:617-628). In 08 the same paragraph also uses F_ST for the computed statistic (column `Fst`). Under 05b's statement the independence of expected heterosis is from F_BN (an expectation over the draw of the pools), not from any statistic F_ST of a sampled pair of pools. 90:154 and 90:150 must stay true once 08 is corrected.

**08-C5 (H) -- symbols `u`, `w`, theta_hyb, theta_pool collide with 07 / 90.** Owner: THIS.
- 08:329-331 `u` = line-usage count vector and theta_hyb = u'f^L u/(2n)^2. 90:311 (u, u-hat = multi-trait index / genomic value), 90:280-291 and 07 (@eq-collapse-theta): the count vector is **k** (k_a, sum 2n), the weights are **w** = k/(2n), the group coancestry is theta_S = w'f^L w. Same letter, two quantities (index vs count), and a second symbol (theta_hyb) for theta_S.
- 08:77 `w_p` (scalar pool census weight) against 08:184 **w** (parent-usage weights, "the parent-usage weight vector") and 90:290 w_a = k_a/(2n); 08:184 `theta_pool` is another symbol for theta_S of the DH set. 90 lists none of theta_hyb, theta_pool.

**08-C6 (M) -- `GD_within` against GD_WS, and "per pool".** Owner: THIS.
08:131, 08:155, 08:439: `GD_within` = 1 - theta_w (a census-weighted mean over pools). 02:442,460 and 90:110-115 call that quantity GD_WS ("equals GD_BI with inbred lines"). 08:155 "Defend `GD_within` per pool" and the checklist "Monitor within-pool GD per pool" refer to a column that is not per pool: the per-pool values are the panel's `GD_A`, `GD_B` (run: GD_within 0.3046, GD_A 0.3050, GD_B 0.3042).

**08-C7 (H) -- `Ne` for N_e,par.** Owner: THIS (Owed, 00-C35).
08:352 `Ne = ne_parents_from_counts(u)` (run: 49.63); 90:79 N_e,par = 1/sum p_i^2 over parent-line usage; 90:72,87 reserve N_e for a size defined by a rate (@eq-hp-drift); 00:701.

**08-C8 (H) -- "DH induction dominates" is stated unconditionally in three places; the cached ledger conditions it.** Owner: THIS (Owed, 00-C15).
08:167 ("the largest share of pipeline diversity is lost"), 08:376 (figure caption "DH induction dominates"), 08:451-452 (checklist 8: "DH induction, not hybrid mining, is where the diversity goes"). 08:381 and 00:322-331 condition it on merit-only cross selection. `pipeline_loss_ledger.csv` (run, mean over 8 pools): merit-only share S2 77.5, S3 2.5, S4 20.0 %; with the diversity term S2 35.5, S3 29.0, S4 35.5 % (S4 equals S2). Per-pool S2 share under merit-only spans 63.0 to 81.4 %.

**08-C9 (H) -- what the ledger's "same-size resampling baseline" is at S2, and what "77% of all diversity lost" is a share of.** Owner: THIS.
08:363-364 says every stage is measured against its own same-size resampling baseline; 00:310-321 says the random-subset algebra covers S3 and S4 and "not S2, where each line is a new gamete". 08 never says what the S2 baseline is. `loss_ledger()` (`R/05_pipeline_metrics.R:472-480`) computes (GD_before - GD_after)/GD_before from values the caller supplies, and `share_of_total` is the share of the SUM of the three per-stage proportional losses. In the csv GD_after of S2 (0.3063, seed 1, merit-only) is not GD_before of S3 (0.3027), so the stage losses are against different baselines and are not parts of one pipeline total. 08:381 "accounts for 77% of all diversity lost in the pipeline" and "more than three times the loss at hybrid mining" (loss_pct 9.40 against 2.48, ratio 3.8; shares 77.5/20.0) read the share as a share of a total. The producer is absent (08-C10), so the S2 baseline cannot be recovered.

**08-C10 (M) -- four cached artefacts presented as simulated here; "full simulation" scale unnamed.** Owner: THIS (Owed).
`fst_definitions.csv` (08:6), `dist_vs_variance.csv` (08:7), `pipeline_loss_ledger.csv` (08:8), `metric_pitfalls.png` (08:251), `pipeline_loss.png` (08:378): none has a writer in `book/scripts/regenerate.R`, `inst/`, `R/` (grep). index:186-206 and 92:276-283 say so; 08 says "were simulated end to end" (08:358) and "on the full simulation" (08:249) without saying cached, external, or at what scale (the ledger header gives 120 lines, 6000 markers, 8 pools; the Trap 4 data's scale is not stated at all). Also: 08:23-25 "Every formula was verified numerically before it was written" is not true of what the chapter shows for the DH identities (08-C11).

**08-C11 (M) -- "three verified identities" at S2 have no check in the chapter.** Owner: THIS.
08:23-25 promises a maximum deviation next to every exact identity; 08:170-199 states (a)-(c) and shows only the values of `dh_pool_theta` with and without the self term and one `dh_sib_coancestry` call (08:196-198), no comparison with a brute-force DH sample. The package test (`tests/testthat/test-stage-metrics.R:21-22`) checks (a) against its own formula. The chapter's own claim also leaves open how the n_c weights enter the overline in (c) (the mean is n_c-weighted; the example uses equal `n_per`). The independence of loci under which sigma^2_DH = (1/4) sum beta_k^2 (08:214) holds is not stated.

**08-C12 (H) -- the Trap 5 repair route, the chapter's "working route", does not meet the ceiling in its own example.** Owner: THIS.
Chunk at 08:313-321, frozen output (`book/_freeze/08-pipeline-stages/execute-results/typ.json`, reproduced in this run): `theta` 0.67554 against `ceiling` 0.67464, `met` = FALSE (0), `mean_merit` 1.0725 equal to `merit_of_top` 1.0725 -- the repair returned the truncation set unchanged (`select_lines_constrained` leaves its loop at `add == out`, `R/05_pipeline_metrics.R:392`). 08:309-311 calls it "the working route"; 08:323-325 follows without reading the output. 92:182-183 lists "the constrained selection silently returns an infeasible plan" as the failure the test would catch. The truncation set's own loss (run: `loss_vs_resampling(top)` 0.80 %) exceeds the 0.5 % budget, so the example is the case the repair is for.

**08-C13 (M) -- S3 advice is "within each pool separately"; the S3 example constrains the 60 lines pooled.** Owner: THIS.
08:264-266 against 08:313-321 (`fL` is the 60 x 60 matrix of both pools, `theta_ceiling` and the swap run across both) and the argument of S1 (08:69-73). No per-pool count of selected lines is printed.

**08-C14 (H) -- the S4 cost claim contradicts 07's measurement.** Owner: THIS (06:172-173 flagged the same wording; owed to 06 as reword).
08:342-343 "cost drops from O(n^2) over an N x N hybrid matrix to O(L^2)"; 08:429-430 "With L in the hundreds it is microseconds"; checklist 7 (08:449-450). 07:300-310: the line route is slower than the matrix route at N = 2,500, n = 50 and cheaper only for large n (N = 10,000, n = 1,000); 07:268-299 gives 106 us per evaluation at L = 300 (5 us only for the incremental swap). In 08's own example n = 100 hybrids and L = 60 lines. What 07 establishes without qualification is memory O(N^2) -> O(L^2) (07:120-125).

**08-C15 (M) -- "expected heterozygosity of the hybrid set" (08:346-347) needs 06's qualifier.** Owner: THIS.
06:225-245 and 00:385-406: GD = 1 - theta_S is H_e of the merged set's frequencies, NOT the heterozygosity the F1s carry (2 GD_WI-hyb; H_o = GD_T + GD_BS on the complete factorial); a selection can move them in different directions. 08:346 "for hybrids of fixed lines it is exactly 1 - theta_hyb" and `He` (08:351) can be read as the heterozygosity of the F1s.

**08-C16 (M) -- S1 mechanism and Kadoumi paragraph overstate what 00 allows.** Owner: THIS (Owed, 00-C3 and 00 B1); 11:135-143 LATER (already owed, same sentence).
08:69-73 "within-pool diversity erodes under selection, while between-pool divergence inflates ... both pools collapse internally and drift apart"; 08:160-163 "found exactly the two opposite trends this panel is built to separate". 00:333-341: the opposition is derived for drift in two closed pools; no argument for selection; the rise of GD_BS under `run_cycles()` is a simulation result with drift and selection not separated. 00:343-357: Kadoumi report F_ST 0.178 -> 0.223 while mean between-group Hamming distance fell 0.430 -> 0.420; the within-group decline is concentrated in NSS, SS stable; NSS merged Iodent and Lancaster; the authors "can only speculate" that selection caused the divergence. 11:137 repeats "within both groups declined". "Decades" is forty years of one private programme; 11's corpus begins in 2017 (00:359).

**08-C17 (M) -- Trap 3 and the S1 panel: three sentences not supported as written by 05b or by the chapter's own table.** Owner: THIS.
- 08:139-140 "Buying oppositely-fixed loci costs within-pool gene diversity, and it costs a great deal of it" against the same table: `frac_opposite_fixed` is 0.0005-0.037 (run, 25 + 25 lines, 2000 markers) while GD_within falls 0.332 -> 0.211; 05b:925-936 (first exceeds 1 % of markers near the top of the sweep; divergence lives at intermediate frequency differences). The cost in GD_within is that of divergence, not of fixed opposite loci.
- 08:144-146 "exactly twice the divergence term of expected heterosis": 05b:906-908 states it per locus at d_k = 1 (unweighted); with d-weights it is not exact (06:472-479, 05b alignment sections). 08:146-147 "essentially zero across the whole range of divergence a real dent-versus-flint pair occupies" has no source (05b gives a range only for the simulation's own sweep).
- 08:121-123 cites @sec-heterosis for the reason; the sections that hold it (sweep, alignment, S1-panel section "Reading the S1 panel") are not cited, and 05b's protocol steps stay uncited (foundations-C13, secondary 08). Low weight.

**08-C18 (M) -- causal explanation of the S2 spike not tested here, and "cheapest stage to constrain".** Owner: THIS.
08:385-387 "The reason is structural: 20 crosses out of 1770 ... a far harsher bottleneck than 200 hybrids out of 1600, and the S2 collapse makes it the cheapest stage to constrain." The ledger has one setting (20 crosses, 40 DH each); 04:1178-1180 states 08 does not vary plants per cross and that what more plants would buy is not established; nothing varies the number of crosses either. The ratio of crosses chosen to combinations is not the quantity that sets the loss (distinct parents used is). 1770 = C(60,2) is per pool for 60 lines; the ledger has 120 lines in two pools, so the number of within-pool combinations is 3,540 unless the 20 crosses are all in one pool (not stated). "Cheapest" is not measured (the S2 diversity term moved loss rather than removing it, 08:402-406).

**08-C19 (M) -- the blockquote at 08:408-411 generalises from one S2 penalty at one weight to "a diversity constraint applied at one stage".** Owner: THIS; 12:187 LATER (cites it as "a constraint").
The tested arm is a diversity TERM on parental coancestry at S2 (08:359-361), not a constraint; 8 founder pools; Ne p = 0.24, alleles p = 0.52 are absences of evidence at n = 8 (run: paired t on the csv reproduces 0.0002, 0.243, 0.519; hybrid merit 33.40 -> 29.71, a 11 % mean cost, per-pool 5.3 to 14.9 %). The ledger shows the total sum of per-stage losses falls (12.2 -> 9.9) and S3/S4 losses rise, but "partly reclaimed at S3 and S4" (08:405-406) is a reading, not tested. "If allelic richness is the target the constraint has to be carried through all four stages" is a recommendation no arm tests.

**08-C20 (M) -- back-citations and definitions 08 relies on but does not point to.** Owner: THIS.
- Same-size baseline (08:268, 363, checklist 5) is @sec-baseline / @eq-catalogue-alpha (06); the partition (08:75-77) is @eq-gd-partition (02); N_s is @sec-ns. None is cited. 08:23-29 and 08:268 restate rather than cite.
- UC, i, h: 08:210-226, 08:220 `h = 0.6`. 02b:104-105 says "later chapters use `sel_intensity()` inside the usefulness criterion (@sec-stages)"; 08 writes no UC formula and does not define h (02b:95-101: accuracy form i r sigma_A, "for r = h" i h sigma_A); 90:294 UC = mu + i h sigma, and 90:177-178 uses h_i for the heterozygous fraction. 02b-C14 asked this decision of 08: cite @sec-response for i and the accuracy form, and say what h = 0.6 is and that mu, sigma are those of the DH family of cross (i,j) (08:217-220).
- MRD: first used at 05b:554-556 ("modified Rogers distance between the two lines"), never defined by a formula before 08; 08 Trap 1 (08:63) gives only f = 1 - MRD^2 and 11:98 says "Recall from @sec-stages". 90 defines it through that identity. Low.

**08-C21 (M) -- scales of the live chunks and of the cached results are not named.** Owner: THIS.
Chunk 1 (08:32) 30 + 30 lines, 3,000 markers, 900 hybrids (index:168-172 declares it); the sweep (08:127-135) 25 + 25, 2,000 (the teaching scale, A8); the ledger 120 lines, 6,000 markers, 8 pools; Trap 4 data and `metric_pitfalls.png` ("full simulation") unrecorded. 07:251-255 and 00 (A8) have named scales and the book's convention is to say which; 08 states none of them in prose.

**08-C22 (L) -- 08:16-21 restates @tbl-hp-stages (without its third column) instead of citing it.** Owner: THIS (Owed, 00-C25). The S4 section (08:327-354) also does not say that @tbl-hp-stages assigns S4 to @sec-collapse, @sec-ocs, @sec-combinatorial, @sec-advanced and @sec-genomic-prediction.

**08-C23 (L) -- redundancy.** Owner: THIS (shorten to a pointer) / 07 keeps ownership.
The S4 identity demonstration (08:329-342, deviation 0 in run) duplicates 00's numeric assertion and 07's derivation and live identity at 1e-12 (07:79-152, 194-223); 08 should use it, cite @sec-collapse for the assumptions (inbred parents, n distinct A x B crosses, 07:83-93) and not re-derive. `sel_intensity(0.05)` = 2.0627 (08:221-226) repeats a check 02b (02b:131) and 04c (04c:923-984, against AlphaSimR) already make.

**08-C24 (L) -- later chapters cite 08 for content it does not hold.** Owner: LATER (10, 08b, 12 -> Owed).
10:36 "the three-object contract of @sec-stages" (X, f, hybrids): 08 contains no such contract (owner @tbl-stage1-contract, 03:56-59; 91:74); 00:178-181 says S1-S4 are not the package's stage 1 and 2. 08b:43 "the saving @sec-stages calls hybrid mining (S4)": 08 does not discuss genotyping saving. 12:187 see 08-C19. 04e:1138 ("the loss of gene diversity @sec-stages tracks ... starts in the nursery plan") is 04e's own extension; 08's ledger starts at DH induction.

**08-C25 (M) -- the promise at 08:157-158 is only partly kept.** Owner: THIS (reword) or LATER 11b.
"@sec-cycles is what the time series looks like when it is actually run out to fifteen cycles": 11b runs fifteen cycles (11b:152,158), but its table logs `index, GD, GD_BS, F_hom, F_drift, max_line` (11b:12-13), not the S1 panel (GD_within per pool, Fst, mean_sq_delta_p, complementarity). 11b:106 (C8) points back to 08 for "the multi-stage version"; 08's ledger is one cycle, S2-S4, no recycling (00:327).

**08-C26 (L) -- small statements not backed.** Owner: THIS. Table caption 08:111 and ratio (08-C2); "swaps typically under 20" (08:424) with no count printed; "microseconds" (08-C14); typed numbers of the end-of-pipeline table (08:393-399: 33.40/29.71, 24.20/25.33, 11274/11314, p = 0.0002/0.24/0.52) match the csv now (run) but are typed, not computed from `led`; "consistent in all 8 pools" is the sign only.

## Items checked and found consistent
- f_ij = 1 - MRD^2 (run: max deviation 1.1e-16) with 90:226; theta_T partition identity; S4 identity (deviation 0); `sel_intensity(0.05)` 2.0627; group coancestry with diagonal, single-line theta = 1, pair (1 + f)/2 (Trap 5) with 06; the ceiling as proportional loss with 06's alpha; G_ST < F_ST because theta_T > theta_B (monotone in the reference, equal weights); hand-typed ledger table matches the csv; S1-S4 names and order with 00 @tbl-hp-stages; 02:1085 ("S1 as separate monitoring stage") true of 08; 05b:781-786 and 05b:1425-1426 quote Trap 3 correctly as to the symptom sentence.

## Inbound `@sec-` references to chapter 08 (`sec-stages`; self-citations discarded; grep over `book/*.qmd`)

Only one label exists in 08 (`{#sec-stages}`, line 1); Traps and stages are cited by prose ("Trap 3 of @sec-stages").

| Citing file | Count |
|---|---|
| 00-hybrid-programme | 10 (:10, :173, :175, :182-184, :224, :327, :579, :747) |
| 05b-heterosis-dominance | 8 (:29, :71, :574, :786, :912, :1426, :1434, :2151) |
| 11-plant-literature | 3 (:98, :144, :151) |
| index | 3 (:114, :149, :171) |
| 05-genomic-era | 2 (:1658, :1786) |
| 12-case-study | 2 (:108, :187) |
| 92-verification | 2 (:179, :237) |
| 02, 02b, 04, 04e, 04g, 08b, 10, 11b, 90, 91 | 1 each (02:1085, 02b:105, 04:1178, 04e:1138, 04g:1297, 08b:43, 10:36, 11b:106, 90:154, 91:62) |
| **Total** | **40 in 17 files** (part-introduction.md recorded 39) |

08 is not at risk of the zero-or-one inbound rule. Outbound from 08: sec-hp-cycle (00) 1, sec-choosing (07) 1, sec-heterosis (05b) 2, sec-cycles (11b) 1, sec-plant-literature (11) 1, sec-collapse (07) 1; no broken targets. Chapters 08 uses and does not cite: 02 (partition, F_ST), 06 (baseline, N_s), 02b (i, accuracy), 03 (the generators).

## Summary by owner
- THIS (08): C1-C23, C25, C26 (H: C1, C2, C3, C4, C5, C7, C8, C9, C12, C14).
- EARLIER, fix now: C3 (05:1777 theta_B); C2 secondary 90:270 (two symbols for one quantity).
- LATER, Owed: C16 (11:135-143, already owed), C19/C24 (12:187, 10:36, 08b:43), C25 (11b:12-13 if the promise is kept by adding the panel instead).
- Fixes to 08's text that touch results (C12, C14, C17) need the live chunks or the cached csv re-read; C9 and C10 cannot be resolved by editing prose alone because the ledger producer is absent.
