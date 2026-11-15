# 07-choosing-metrics -- continuity review, iteration 1 (chapter mode)

Worktree `/Users/ederdbs/Documents/SB_quanti_gen-review-04-06`. Read: CLAUDE.md, `_quarto.yml`, `90-notation.qmd`, `THREAD.md` (Owed items naming 07), 06 (closing promises, `eff_dim`, redundancy cache), 03:395-415, 05 (A8, tbl-era-matrix-signs), 10:420-515 and 565, 10b:255-275 and 515-525, 08:22-30, 08b:8-18 and 722-745, 09:310-318 and 376-390, 11:20-30 and 255-310, 92, index:190-225.
I recomputed from `book/data/*.csv` and ran the live chunks of Findings 3 and 5 (seeded). Nothing was written except this file.
Owner key: THIS = 07 changes; EARLIER = already-approved chapter, change now; LATER = Owed to a chapter not yet reviewed.

## Opening and Owed items

- Opening (07:11-16) says why it follows 06 (catalogue -> which to keep; cost and redundancy) and names the recommendation. OK.
- Owed settled: 03 -> 07 (collapse makes precise 03:402-406): kept, 07:38-60. 06 -> 07 "N_e,par into the objective": kept, 07:441-445. 06 -> 07 "52 % / 36 %": both reproduce from the cache (quadratic fit of rank on rank(theta): allelic richness 0.521, N_e,par 0.364, eff_dim 0.250).
- Owed NOT settled: 00-C18 (F_ST/F_BN, 07-C9), "candidate pool" at 07:481 (07-C12), 06 `eff_dim` cache form (07-C3), 06 promise on the GD/ANE contrast (07-C2), 02:982-990 "keep true" (07-C4), 04b/`max_use` (07-C13).

## Findings

### 07-C1 (H) -- number: "178x the cost of the line-route theta" is 8.4x; "1.4 seconds per million" is 5 s. Owner THIS
- 07:175-177: bitset allelic richness is "still 178x the cost of the line-route theta". `cost_per_eval.csv` (L=300, N=22500, m=10000, n_sel=1000): bitset 891.9 us, line route 106.1 us (ratio 8.4), incremental swap 5.0 us (ratio 178.1). The 178 is against the swap.
- 07:172-173: swap "5 us, or 1.4 seconds per million evaluations". 5.007 us x 1e6 = 5.0 s; the table on the same page (`hours per 1e6 evals` = 0.0014 h) is 5.0 s. 1.4 is the hours figure of allelic richness float / MAF loss mis-read.
- Consequence: "Allelic richness cannot go inside the loop" (07:175) rests on 178x; against the line route it is 8.4x, a weaker claim. 482x (51113/106.1), 14.2 h, 5.7x, 1.47 h, 0.9 ms, 62 us, 7 us all reproduce.

### 07-C2 (H) -- broken promise: 06 says 07 turns the GD/ANE contrast into a recommendation; 07 never mentions it. Owner THIS (or 06 reword -- 06 is closed, so THIS)
- 06:989-990 and THREAD (06 Owed): "That contrast between lenses is what @sec-choosing turns into a recommendation." In 07 the only appearances of E-NE/A-NE are the cost caption (07:164) and "Not recommended ... both require the O(N^2) matrix ... a different problem" (07:462-465).
- The cache says the opposite of "redundant": quadratic-residual rank sd retained is A_NE 0.556 and E_NE 0.523, above allelic richness (0.521), and 06's z-table has ANE at z = 16.4 for capped truncation where GD is -1.4. 07 lists retention for allelic richness, N_e,par, eff_dim only (07:209-212) and omits A_NE, E_NE, alleles_lost_MAF (0.352).
- Also 07:461-462 dismisses MAF allele loss by marginal rho = 0.93, after 07:204 says "the marginal correlation is the wrong test"; its retained fraction (0.352) is the same as N_e,par (0.364), which 07 recommends.
- The chapter must either make the recommendation 06 promised (what the GD/ANE contrast means for what is constrained and what is validated) or say it does not, with the reason (cost / O(N^2)); 06's sentence then changes only if 07 cannot.

### 07-C3 (H) -- assumption/definition: the `eff_dim` statements are about a cache column that is not the package's `eff_dim()`. Owner THIS
- THREAD 06 Owed: cache column mean 1.486 (1.438-1.506); package double-centered 26.19 and uncentered ratio 1.47 on 06's subset (06:458-467). Confirmed: `summary(metric_redundancy.csv$eff_dim)` = 1.438 / 1.486 / 1.506.
- 07:200-201 (|rho| >= 0.93), 07:211-212 ("retains 25 % ... close to a restatement of theta"), 07:460-461 ("|rho| = 0.97 with theta") are all read off that column. 06:449-456 shows an uncentered version re-measures theta by the Rayleigh bound, so "redundant with theta" is a property of the uncentered form; the package's double-centered `eff_dim()` (which 07:183 times live) was never in the redundancy analysis.
- 07 does not say which form the cache used and does not recompute it (cost_per_eval at book scale already runs `eff_dim()`). Same open point for A-NE (self-distance 0 or 1 - f_ii, 06:404-415).
- 07 also does not flag the cache as external data with no producer (index:198-205 lists `metric_redundancy.csv`, `cost_per_eval.csv`, `de_constraints.csv`, `theta_identity_check.csv` as "no writer in this repository"); 07:35 says "each is derived and verified below rather than asserted". 06:312-319 says so for the same file.

### 07-C4 (H) -- "allelic richness is the one exception" is not what the cache shows, and 07 contradicts itself. Owner THIS, then EARLIER (02)
- 07:257-259 "near one-dimensionality, with allelic richness as the exception"; 07:451-452 "The one metric carrying information theta does not"; 02:982-990 "survives the redundancy analysis ... as the one genuinely independent axis" (THREAD 02 Owed: keep true).
- 07:441-445 puts N_e,par in the optimiser because theta "tolerates" concentration, and 07:213-215 shows N_e,par spanning 30.1-55.8 at fixed theta. Cache: A_NE and E_NE retain more rank sd than allelic richness (C2). So "the one" is false against 07's own table and the cache.
- 02:990 cannot stay "the one genuinely independent axis" if 07 changes; 02 is approved, reopen only that sentence.

### 07-C5 (H) -- Finding 4 omits the qualifiers that 10 (same file, same table) states, and the recommendation built on it conflicts with 10/10b. Owner THIS; LATER 11:306
- 07:265-313 and 07:446-447 ("Reparameterise the search on line weights") present `de_constraints.csv` as "The encoding, not the constraint handler, decides". 10:452-515 reads the same file and says: neither arm is `sel_de()`; `sel_de()` finishes ahead of line-encoded `sel_de_fast()` at both scales (10:502-506, 10b:519-525: "a verdict on N-dimensional encodings, not on sel_de()"); the line decoder satisfies the per-line cap by construction, so the comparison is not like-for-like (10:496-515, third bullet); the selected-set size was not recorded (10:515). CLAUDE.md records the same limits.
- 07:295-298 "Only the line encoding makes the constraints bind ... max uses exactly 6" -- the cap binds by construction. 07:287-293 claims the handler does not matter, but the line arm was run with repair only (3 line-weights/repair rows, no line/penalty row); the claim is about the hybrid arm.
- 07:301 ("A slack constraint ... is a diagnostic of a failed search") and 07:309-313 (NP: "At dimension 120 the recommendation is 1,200 ... entirely reachable") against the drop-in code `NP = 200` (07:498) = 60,000 evaluations / 300 iterations, the cached budget: the measured run did not follow the NP >= 10 x dim guidance it praises.
- 07:303-306 "unconstrained truncation reaches index 2.337 ... loss 1.62 %, N_e,par 33.2, one line 17 times; 85 %": these numbers are in no csv of the repository and appear nowhere else (grep of book/*.qmd). Unsourced.
- Scale of the run (N = 3600 = 60 x 60, L = 120, n_sel unknown) is not stated in 07; 10:454-455 states N and L.
- Redundancy (check 4): the same table (07:279-285, 10:464-475) is developed in full twice. 10 owns it (it is the optimisation chapter and has the limits); 07 should state the result with 10's qualifiers and cross-reference.
- LATER: 11:306 repeats "the encoding, not the algorithm, is what decides" (07 says "not the constraint handler"); 11b/12 not checked.

### 07-C6 (H) -- drop-in code is a cold-start DE. Owner THIS
- 07:496-498 calls `DEoptim::DEoptim()` directly with no `initialpop`. 90:643-645 ("Warm start ... Not optional here: without it the differential evolution finishes below a plain greedy"), 10:565 ("The warm start is not optional") and CLAUDE.md (`sel_de(seeds = NULL)` builds the warm start) say never cold. 07 contradicts the book's own rule in the code it tells the reader to copy.

### 07-C7 (M) -- notation: `H_S`, `\bar H_ref` against `GD_S`, `GD_ref`; `w` against `\omega`. Owner THIS
- 07:436-440 writes the loss as `(\bar H_ref - H_S)/\bar H_ref` with `H_S = 1 - w' f^L w`. 90 (alpha row, 90:282-296 region) and 06 (@eq-catalogue-alpha) use `GD_S`, `GD_ref`. `H_S` is also the within-subpopulation mean gene diversity of 06's @eq-catalogue-het-hs-dg / 05b (H_T, H_S, D_G), a different quantity; so one quantity has two symbols and one symbol two quantities.
- 07:189 "a grid of diversity weights" for `sel_greedy(ctx, 60, w = w)` (07:227-228, 354): 90 and R/03 define it as the INDEX weight in `w u_i - theta` (omega; "written w in @sec-combinatorial"). In 07 the argument `w` sits beside the line-usage vector `\mathbf w` (07:56) and in the same chunk. 06 uses omega with omega = 0 = coancestry alone. Direction of the weight is described wrongly.
- 07:59 uses `\mathbf G^L` without definition; 90 defines it (0/1 line genotypes) -- cite or define on first use, since `G` is the VanRaden matrix everywhere else.

### 07-C8 (M) -- "production scale" means three things. Owner THIS
- 07:149, 164, 464 "production scale" = L=300, N=22,500, m=10,000, n=1,000 (stated only at 07:154). 05:150-156 (A8): production is 71+71 lines, 25,000 markers; the `sim_config` default (50+50, 5000) "several chapters also call the production scale"; 10:347 uses 5041 binary dimensions (71 x 71). `introduction-C10` (part-introduction.md:25) left "book scale" in 07 to this review: 07:179 "the book's scale", 07:221 "book scale", `index`/A8 say "teaching scale".
- Same gap for the other caches: the redundancy analysis (m = 12,000, F_ST 0.15, L/N/n_sel unstated, 07:214-215, 257), the identity sweep (L=50, N=625, m=1500 per regenerate.R:100-118, unstated at 07:86-88), the DE run (C5). 06:464 had to infer the 12,000 from the text.

### 07-C9 (M) -- Owed 00-C18: F_ST for a simulation setting. Owner THIS
- 07:87 "F_ST in {0.05, 0.15, 0.35}" and 07:257 "F_ST = 0.15" are the Balding-Nichols parameter (regenerate.R:107 `fst =`). 90:151-157 and 590-598: write F_BN where it is a setting. Open (also 92:57, 92:397, index).

### 07-C10 (M) -- cache numbers that do not reproduce as stated. Owner THIS
- 07:199 "PC1 absorbs 88 %; PC2 7 %" of "all 17 metrics" (07:189): PCA of the ranks of the 17 numeric columns gives 84.4 % / 7.2 %; 87.9 % / 6.1 % only after dropping mean_index, n_lines_used and alleles_fixed (14 columns). "17 metrics" also counts theta, gene_diversity, He_Nei, loss_pct and status_number, which are the same quantity (CLAUDE.md; 07:460).
- 07:200 "|rho| >= 0.93" for N_e,par: the cache gives 0.925 (06 reports -0.925); 0.925 is not >= 0.93.
- 07:213 band "theta in [0.666, 0.670] containing 399 selections": 393 selections, span 136 (11,715-11,851), N_e,par 33.0-56.25. 399 / 171 / 11,680 / 30.1-55.8 holds for [0.6661, 0.6701]: rounded edges, state them or round the text.
- 07:224 figure caption "At fixed theta, the effective number of parents still varies by a factor of two": the live chunk (seed 77) gives 55 selections in the band, N_e,par 31.6-41.9 (factor 1.33); the cache gives 1.85. The caption states the cache's result on a live figure.
- 07:183 live cost table at book scale: `cost_per_eval(ctx, 60, reps = 40)` prints `ne_parents` 0 us and steps of 25 us (timer quantisation; CLAUDE.md adaptive-repetition rule), against "7 us" at 07:174; and it has no line-route, swap or bitset row, so "the same ordering is visible" (07:179) is not shown for the recommended routes.
- 07:155-157, 65: "3.77 GB" is 22500^2 x 8 B in GiB (4.05 GB); 10b:1137 says GiB.

### 07-C11 (M) -- the collapse is cheaper than the matrix route only for large n; 07 never compares against the matrix route. Owner THIS
- 06:172-173 "@sec-collapse makes it cheaper still" (06 Owed). 07:169-171 compares the line route only with the allele-frequency route (482x). `cost_per_eval.csv` has the matrix route up to N=10,000: n_sel=50: matrix 6.9 us vs line 10.0 us (N=2500, line slower); n_sel=200: 88 vs 16; N=10,000, n_sel=1000: 4313 vs 52 us (83x). The promise is kept only for large n, and the case where the line route is slower is not reported.

### 07-C12 (M) -- Owed from 00/03/10: "candidate pool", and a claim not carried by the cited chapter. Owner THIS
- 07:481 "as the candidate pool shrinks": 00/part-foundations ask for "candidate set" for the hybrid set ("pool" is a heterotic pool in 07:99 and 07:269). 
- 07:478-482 cites @sec-genomic-era for "managing on molecular coancestry controls homozygosity, not drift; a plan optimal on one is not optimal on the other", then states "Predicted Delta f is biased downward, with the bias growing as the candidate pool shrinks". 05 has no such statement (grep: no "downward"); 05:586-600 (tbl-era-matrix-signs) says the sign of the bias is a property of the matrix (negative for G_0.5, the one the book constrains), not unconditionally downward. Source absent.
- 07:473 relies on @sec-plant-literature (11, later) for "matrix choice demonstrably changes allele-frequency trajectories"; no "later" marker (check 7); 11:255-265 supports it.

### 07-C13 (M) -- scope of "nearly one-dimensional" and of "everything else is redundant". Owner THIS
- 07:32 (table caption) "Everything else is redundant with theta, too expensive, or both" and 07:186 "the metric space is nearly one-dimensional": the 17 columns are all homozygosity-lens (06:319-328, THREAD 06: the analysis does not include F_drift or F_hom). 05's result is that F_drift is the lens the constraint does not pin (|z_Fdrift| > |z_GD| on 20/20 draws, 06 Owed) and 05's seven-step protocol asks the programme to monitor it. 07's validation list (07:449-456) has no F_drift/F_hom item; 07:478-480 gives one sentence. State that the redundancy is inside one lens.
- Also "pool decomposition" is in the recommendation as validation-only (62 us, rho with theta 0.76-0.92, not expensive and not marked redundant) -- the stated rationale of the table caption does not cover it. The four restrictions of Finding 4 include pool balance within 5 %, which the recommendation (two metrics + cap, 07:432-447; drop-in 07:492-494) does not carry.
- N_s (07:455): reported as "the reportable descriptor" without 06's caveat (@sec-ns: on molecular f, N_s in [1/2, 1], a monotone rescaling, not a head count); the cache values are ~0.75.

### 07-C14 (M) -- "the discrete hybrid problem is exactly optimal-contribution selection on lines" needs its assumptions. Owner THIS
- 07:78-82. Holds for the diversity side. The objective is the hybrid index sum of u_i, a function of w only if the index is additive in the parents (A3; 03:402-406 gives the additive index; 05b: not under dominance, nor for the pairing-dependent quantities of 06:225-245, `GD_WI_hyb`, realised F1 heterozygosity, which are not functions of w). Feasibility is also not "any k with sum 2n": each hybrid has one parent per pool (03:`ped` = complete A x B factorial), so k sums to n in each pool and the degree sequence must be realisable by candidate pairs. 07:69-72 ("w is a sufficient statistic") is right for the listed quantities and should say they are the diversity quantities.
- 07:74 "a rank-2 update" is not shown (four entries of w change; O(L) holds).

### 07-C15 (L) -- numbers across chapters. Owner THIS
- 07:407-409 "Truncation on a perfect index loses 4.12 %" (live, `null_distribution(B = 400)`, gd_ref differs by resample: 0.041216) against 06's 4.129 % (0.04128766, B = 2000, seed 7; THREAD 06 "how to set the alpha limit"). Same quantity at the same scale to two decimals; state B or cite 06.
- Finding 5: 07:320-328 "at a comparable accuracy" (08b); 08b:729-745 says CV2 is top of the r range, CV1 0.65 near the bottom, CV0 below: "comparable" is loose. Consistent otherwise; 08b/12/11b/02b citations of Finding 5 agree.

### 07-C16 (M) -- LATER chapters cite 07 inconsistently with it. Owner LATER
- 08:26-29 "the metric set established in @sec-choosing: ... N_s as the interpretable size, allelic richness as the one non-redundant addition" -- 07 recommends N_e,par as the second constraint and the pool decomposition; N_s is a rescaling (06). Owner 08.
- 09:383-385 "Allelic richness, A-NE and G_st are computed once on the final solution ... the same conclusion @sec-choosing reached" -- 07 does not mention G_st, and lists A-NE as not recommended. Owner 09.
- 11:23, 11:306: see C5. 10:455 reuses "the four simultaneous restrictions of @sec-choosing" (they are defined only parenthetically at 07:267-269). 10b:1245 "@sec-catalogue's rule applies: one diversity lens, chosen deliberately, reported against a null" (THREAD 06 Owed, 06-C13): neither 06 nor 07 states it; 07's nearest text is 07:478-480 plus C13. Owner 10b to reword (the Owed stays with 10b).
- 04b:1195 cites @sec-choosing for `max_use`; 07 uses `max_use` only inside Finding 4 and the recommendation without a definition (07:267-269, 446-447). Owner THIS to define once (L); 04b follows.

### 07-C17 (M) -- Part structure: Finding 4 depends on later chapters. Owner THIS
- 07:265-313 and 07:446-447 use DE, penalty/repair handlers, `decode_lines`, `make_fitness_fast`, NP, `alpha_max`, `max_use`, none introduced before 09/10 in `_quarto.yml` order, and 07:424 points at 12. The only flagged forward pointer is 07:326 ("later"). 10:455 in turn cites back to 07 for the four restrictions: circular. Declare Finding 4 as a preview of @sec-combinatorial or move its table to 10 (C5).

## Cross-reference graph (self-citations discarded; from `grep` over `book/*.qmd`)

Both `{#sec-}` ids of 07 are in 07. 07 cites out to one section each of 06, 09, 03, 08b, 12, 11, 05; no broken target from 07; no broken `@sec-` in the book.

| id | inbound (other files) | from |
|---|---|---|
| sec-choosing | 36 | 06 (8), 11 (4), 10 (4), 10b (2), 09 (2), 08b (2), 12 (2), 92 (2), index (2), 00, 02, 02b, 04b, 08, 11b, 90, 91 (1 each) |
| sec-collapse | 12 | 00 (2), 10b (2), 03, 06, 08, 09, 10, 11, 90, index (1 each) |
| chapter total | 48 | 06 9, 11 5, 10 5, 10b 4, 09 3, index 3, 00 3, 08 2, 08b 2, 90 2, 12 2, 92 2, 02 1, 02b 1, 03 1, 04b 1, 11b 1, 91 1 |

07 has a job (48 inbound from 18 files). Outbound: sec-catalogue (06) 1, sec-ocs (09) 1, sec-simulating-crosses (03) 1, sec-genomic-prediction (08b) 1, sec-case-study (12) 1, sec-plant-literature (11) 1, sec-genomic-era (05) 1; forward to 09, 08b, 11, 12 (later).

## Summary
H: C1-C6 (C1 numbers, C2 broken promise to 06, C3 eff_dim form and cache provenance, C4 "one exception", C5 Finding 4 qualifiers vs 10/10b, C6 cold-start code). M: C7-C14, C16, C17. L: C15.
Redundancy: Finding 4 table with 10; identity table with 92:57-72; collapse check with 08:335-343 (08 and 92 should cross-reference).
