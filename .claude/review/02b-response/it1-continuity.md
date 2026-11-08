# Continuity review: book/02b-response.qmd (iteration 1, chapter mode)

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05, branch review-01-05. Date 2026-11-07. Read-only on the book.
Read: CLAUDE.md, THREAD.md (entries 00, 01, 02; the one Owed item naming 02b), part-introduction.md, _quarto.yml, 90-notation.qmd, index.qmd, 00, 01, 02, 02b in full; targets of 02b's forward claims (03, 04c, 05b, 08, 08b, 09, 11b, 11c), R/15_response.R, R/09_reference.R (simulate_pools), R/00_data.R.
Citations "file:line" are book/ files unless a path is given. Findings: 19 (H 2, M 9, L 8). By owner: 02b 15, 09 2, 04c 1, later chapters (11b, 08, 08b) 1; 02 is co-owner of 02b-C4.

## Checked and consistent (not findings)

- The within/between statement of 02b:225-236 agrees with 02:809-811 and 02:1100-1109 in substance: genic variance among A x B hybrids is the within-pool part of gene diversity weighted by squared effect; the between-pool term does not enter; the proxy holds only if effects are unrelated to which loci lose diversity. The identity 2 pbar qbar = pA qA + pB qB + (pA - pB)^2/2 (02b:230-231) is the one-locus form of 02's F_ST (02:404-427) and checks algebraically. `index:91-99` states the same result.
- The "gene diversity of the hybrid pool" (1/m) sum 2 pbar qbar (02b:229) equals GD_T = 1 - theta_S for the complete factorial with equal pool weights (02:827-846, `tbl-keystone-check`). 02b states "inbred lines" and "complete A x B factorial" (02b:200-206), which are the conditions 02 needs (A2, complete factorial, equal weights).
- `eff_dim()` is computed on the double-centred submatrix of f (R/01_metrics.R:277-283), as 02b:248-250 says. The frequency-only list in the callout (02b:245-247) agrees with 00:463-465 and 11c:98-100.
- `build_ctx()` standardises each trait column and then weights (R/00_data.R:170-172); `weights = NULL` is equal weights (R/11_stage2.R:24); `12-case-study` passes `weights = NULL` (12:26). 02b:313-323 is true of the code.
- Forward claims confirmed: @sec-cycles crossover varies with seed (11b:270-282); `sel_intensity()` inside the usefulness criterion (08:210-226); the replicated breeder's-equation check in 04c (04c:803-880: gap -0.5 % and 2.5 %, largest 1.1 s.e., "same reading"); Finding 5 of @sec-choosing exists (07:315); `heterosis_gca_sca(U, V, d)` has the signature 02b uses (05b:764-830) and the factorial index order matches; @sec-baseline defines the random-subset reference (06:516); every @sec- target of 02b resolves (no broken target in the book, 0 of all @sec- citations).
- alpha: 02b:436-439 (alpha <= alpha_max on the loss relative to a random subset of the same size) agrees with 00:313-316 and 90:290. 02 is explicit that its own alpha_i is not this alpha; 02b uses only the constraint alpha.
- Notation against 90:492-540: R, i, z, phi, r, b, S_I, sigma_A, V_genic, beta_k, p_Ak/p_Bk, u_k/v_k, d_k, W, g, Sigma_P/Sigma_G, b (bold), xi, a, R (bold), n_t/n_r, C all match 90's "Response to selection" table, including the `P`/`G` code names and the "not the relationship matrix G" warning. N and n/n_sel match 90:20-35.

## Findings

### 02b-C1 (H) -- broken promise to @sec-limits; owner: 02b (11c is what its data show)
- 02b:461-463: "@sec-limits is where the disequilibrium term this chapter isolated (@eq-response-ld) turns out to matter more than @eq-response-breeders suggests."
- 11c:207-226 ("The two costs of selection"): the disequilibrium cost is "invisible to every metric in this book and is largely self-correcting" because recombination repays it (11c:217-218), the frequency cost is permanent, and "that is the justification for constraining the second and ignoring the first" (11c:221); the constraint on allele frequencies would manage "the smaller of the two bills" only if disequilibrium did not decay (11c:223-226). The chapter finds the term significant (t from the paired control, 11c:139-150) but not the larger cost. "Matters more" is the opposite ordering.
- Fix is in 02b (state what 11c measures: a selection-induced, decaying term that the metrics cannot see). 11c's conclusion is the book's result and is not changed.

### 02b-C2 (H) -- broken promise to @sec-ocs; owner: 02b (or 09, if the passage is wanted there)
- 02b:436-440: "@sec-ocs works out what changes when the equality restriction becomes an inequality."
- 09 has no such passage. Its headings (09:17, 44, 67, 80, 103, 115, 170, 185, 225, 295, 310, 320, 343, 372) and a search for "inequal/equality/binding/slack" find nothing. The only treatment is one clause: the alpha constraint "is bounded relative to a resampling baseline rather than held at zero" (09:72-74), and `Setting alpha_max` (09:185-189), which is about calibration, not about equality versus inequality.
- Either 02b withdraws the promise or 09 supplies the passage; as the book stands, a reader sent to @sec-ocs does not find it.

### 02b-C3 (M) -- opening does not say why it follows 02; owner: 02b
- 02b:8-22 opens "Every chapter so far measures what selection *spends*" and motivates from @sec-cycles (a later part). It cites none of 00, 01, 02. The first backward link is `@sec-subdivided` at 02b:232, and `@sec-keystone`/`@tbl-keystone` are never cited.
- 02 hands over explicitly: "$GD_{BI}$ is the raw material of next cycle's response, which @sec-response makes precise" (02:1100-1103) and the mixture-base bullet (02:806: "@sec-response, where this derivation belongs"). 02b delivers that (02b:225-236) without saying it is the promise being kept.
- 00 already defines GCA/SCA on a reference set (00:98-132, @eq-hp-gca-sca) and the data scale (A8). 02b:263-264 says GCA is "used here ahead of that derivation" and cites only 05b; it never mentions that 00 introduced it.
- Also `index:94-99` item 3 is the preface's statement of what 02b establishes; 02b does not point back to it.

### 02b-C4 (M) -- Owed item 02-M9 not settled: the genic-variance derivation is still developed in 02, and 02b does not carry the mixture-base case; owners: 02b (to own) and 02 (to cross-reference)
- 02:788-809 develops it for a mixture base intermated to Hardy-Weinberg: variance of the 0/0.5/1 genotype pbar qbar/2, genic variance sum beta^2 pbar qbar/2, and with equal effects m beta^2 GD_T/4. It says the hybrid case "belongs" to @sec-response.
- 02b has the hybrid case, @eq-response-hybrid-var (02b:208-209), whose first form pbar qbar/2 - (pA - pB)^2/8 contains the mixture-base case at pA = pB, but never states it, never states the equal-effects corollary, and never says that 02's bullet is the Delta = 0 case. The equal-effects corollary for hybrids (m beta^2 GD_WS/4, since Var(x_k) = (pA qA + pB qB)/4 is a quarter of the per-locus within-pool diversity) is also absent. So the derivation is in 02 for one case and in 02b for the other, and neither points to the other beyond 02:806.
- Consistency demanded by the THREAD item holds (see "Checked and consistent"). What remains is the ownership: 02b should hold both cases; 02:788-809 should shrink to a cross-reference. Low in the THREAD; M here only because the two chapters now carry different halves of one derivation under different baseline assumptions (HW-intermated mixture versus fixed-line factorial), which 02b does not distinguish.

### 02b-C5 (M) -- the disequilibrium term of tbl-response-genic is sampling, labelled as the Bulmer effect; owner: 02b
- 02b:174-178: "The difference is exactly the gametic-phase disequilibrium term [@bulmer1971], which @tbl-response-genic evaluates for the seed-1 draw."
- In `simulate_pools()` the lines are drawn independently per locus from pool frequencies (R/09_reference.R:36-37) and no selection precedes the evaluation, so Cov(x_k, x_l) over the factorial is pure sampling covariance of 25 + 25 lines. Bulmer 1971 is the covariance that selection builds. 11c:106-110 and 11c:118-124 say so explicitly: the gap "is not on its own a measure of the Bulmer effect. A finite founder base leaves disequilibrium in the very first cycle, and two divergent pools add more", which is why 11c uses a random-selection control. R/15_response.R:18-21 also ties the sign (negative) to directional selection.
- The identity @eq-response-ld is exact and is not in question. The attribution, and the absence of any statement that the seed-1 value is sampling noise with arbitrary sign, are. 04c:480 calls the same term "sampling (gametic-phase) disequilibrium" and cites 02b for it.

### 02b-C6 (M) -- the callout and the @sec-limits promise read the proxy gap as disequilibrium only, against the chapter's own within/between result; owner: 02b
- 02b:252-254: "A flat gene diversity trajectory therefore does not imply flat additive variance: reading it as one puts the error of @eq-response-ld, the whole disequilibrium term, into sigma_A^2 ... @sec-limits measures how far apart the two can travel."
- 02b:229-236 and 02:1085-1100 (drift: GD_WS falls by twice what GD_BS gains while GD_T falls by half the gain) show a second source: a flat GD_T can hide a falling within-pool term, which is the only part genic variance contains. The callout attributes the whole error to disequilibrium.
- 11c does not measure "how far apart" gene diversity and additive variance travel. It measures the selected-minus-random difference of Var - V_genic (11c:128-150, 11c:172-185) and the Robertson prediction; it has no gene diversity versus variance trajectory comparison. The sentence over-describes the target.

### 02b-C7 (M) -- GCA stated as pool-dependent without the dominance condition; section has no role in the chapter's sigma_A; owner: 02b
- 02b:259-266: "in a two-pool hybrid population the average effect of an allele substitution depends on which pool it is substituted into ... each line's GCA is its average effect against the opposite pool, i.e. the additive part *relative to that tester pool*."
- 00:126-129 and 00:158-165: without dominance (d_k = 0) the GCA of a line is the same against every tester set; the tester dependence is the dominance part, the additive part sum a_k delta u_ik is the same against both halves. 02b's own trait `gv` has no dominance (02b:53-54, "purely additive in the marker coding"), so for the chapter's sigma_A the statement is false; it holds only for the dominance-only H of the chunk that follows (02b:267-270).
- The section heading ("Combining ability as the additive part") and the opening sentence promise a link to the additive variance of @eq-response-breeders that the section never makes: sd(gv) is the genotypic s.d., which equals sigma_A only because d_k = 0. The shares of tbl-response-gca-sca are of an unrelated H and "not measured" for cycles (02b:306-309).
- Illustrative draw: d_k ~ N(0.3, 0.1^2), seed 7 (02b:268, 275), against rgamma(m, 2, 4), seed 4 in 05b (05b:16) and "the draw @sec-heterosis uses" in 00:130. 02b gives no reason to differ. Redundancy: 05b owns GCA/SCA (05b:764-830, with the `lm()` identity); 02b's table (02b:298-304) repeats it on a different draw. Owner for the derivation: 05b; 02b should cross-reference and restrict itself to the one sentence it needs.

### 02b-C8 (M) -- scope of R, sigma_A and r differs from the chapters that reuse them; owners: 02b (state scope), 04c (define r)
- 02b:44-58, 02b:63-73: "realised response" is the mean genetic value of the selected hybrids minus that of all hybrids, with sigma_A = sd(gv) and r = cor(index, gv). This is the gain on the selected hybrids themselves (the product), valid because gv is additive. The motivation (02b:11-22) is the cycle-by-cycle gain of 11b/11c, where the hybrids are not recycled: lines are (A3, 00:199-211), so what is transmitted is a line breeding value/GCA against a tester pool. 02b never says which response it is, and 11c:21 ("@sec-response wrote down the response to one cycle of selection") and 04d:260 ("breeder's equation of @sec-response is a rate per unit time") read it as the cycle response.
- 04c:850-856 defines r as the correlation of the phenotype with the breeding value (`bv()`), "not with the total genetic value: only the additive part is transmitted", and measures R as progeny change. 02b:51-52 defines r as accuracy "as a predictor of genetic value" and 90:497-507 as "accuracy of the selection criterion". The two are the same only for d = 0.
- The 02b statement that the 04c replicated sweep "reaches the same reading" (02b:158-159) is correct as a numerical statement (04c: largest gap 1.1 s.e.) but the two sweeps measure different quantities (selected hybrids' genetic value in 02b, progeny mean in 04c).

### 02b-C9 (M) -- 09 repeats 02b's restricted-index example with a different, invalid G; owner: 09
- 02b:353-365 uses P = [[4.0, 1.2], [1.2, 1.0]], G = [[2.0, 0.3], [0.3, 0.3]], a = (1, 1) and asserts that G and P - G are positive definite (02b:359-360). 09:52-60 uses the same names, the same P, a and R = (0, 1)', but G = [[2.0, 0.9], [0.9, 0.3]] (09:56). det G = 2(0.3) - 0.81 = -0.21: not a covariance matrix. The "exactly zero" result survives algebraically, but 09 presents the example as the same construction.
- Redundancy: 09:44-78 re-argues the Kempthorne lineage (09:48-51), repeats the unrestricted/restricted demonstration (09:52-60) and carries a callout "What is actually new here" (09:67-78) that is a near-verbatim parallel of 02b:442-453. 02b owns it (it has the equation, the table, the identity assertion). 09 should cross-reference @tbl-response-restricted and keep only what is specific to the OCS formulation.

### 02b-C10 (M) -- 04c Step 7 re-develops 02b's Smith-Hazel/weights = NULL discussion with a tension in the conclusion; owner: 04c
- 02b:384-394: the gap between b and a is a property of an index on phenotypes; with BLUP predictions weighting by a is optimal, "not a defect of `weights = NULL`".
- 04c:1176-1178 says Step 7 "is where that default gets examined", then reads "Equal weights are not the Smith-Hazel solution" (04c:1210-1226) and "The cost on the objective is modest here" (04c:1228-1237) on the phenotypic indices (`P`, `G` are varP/varG of phenotypes). Both are true, but 04c never states the 02b distinction (phenotypic versus predicted criteria) that decides whether the finding bears on the pipeline's default. The reader of 02b, then 04c, meets two verdicts on the same default.
- The same table is also developed twice (02b:353-382 and 04c:1185-1244, with `cor_with_H` and the optim check). 02b owns the theory; 04c may keep its AlphaSimR instance and should say what it adds.

### 02b-C11 (M) -- 09 says 02b "derives" the Kempthorne-Nordskog solution; 02b gives a formula; owners: 09 (wording), 02b (wording)
- 09:50-51: "@sec-response derives their solution"; 09:48: "the identical problem".
- 02b:403-412 states @eq-response-restricted "algebraically equivalent; not necessarily their notation" and verifies by assertion that R'Gb = 0 (02b:431); there is no derivation. 02b:403 says "exactly the same problem", also stronger than 02b:436-440 grants (an equality on a trait gain versus an inequality on a diversity loss). it1-refs.md (02b-B1, B2) already flags the overclaim; the two chapters should change together.

### 02b-C12 (L) -- symbols and metric names against 90 and 02; owner: 02b
- 02b:245-246: bare `$\theta$` and `$GD$` for the metrics ("$\theta$, the only metric the DE selector constrains"). 02 settled on $\theta_S$ and $GD_S$/$GD_T$ (THREAD 02, Owed 02-C4); 90 has no bare GD row. 11c:98 has the same wording (owner 11c).
- 02b:245 writes `F_hom` and `F_drift` in code font; 00:561-585 and 02 write $F_{hom}$, $F_{drift}$.
- 02b:229-233 describes the quantity as "gene diversity of the hybrid pool" and its parts as "between-pool term of the partition of @sec-subdivided" and "within-pool part"; the book's names are $GD_T$, $GD_{BS}$ and $GD_{WS}$ ($=GD_{BI}$ with inbred parents, @tbl-keystone). With the names, the section's result is the one-line "V_genic uses GD_WS, not GD_T".
- 02b:201 introduces $\bar q_k$, not a row of 90 (trivial).

### 02b-C13 (L) -- two "connects" claims that the targets do not bear out; owner: 02b
- 02b:457-459: "@sec-genomic-era and @sec-catalogue measure the allele frequencies from which, through @eq-response-hybrid-var, the genic variance defined here is built." Neither 05 nor 06 mentions genic variance, V_genic, or @eq-response-*; the only 05 row is a checklist line pointing the other way (05:1856, "Is true genetic variance ... being tracked? -> @sec-response").
- 02b:459-460: "@sec-genomic-prediction measures the $r$ this chapter took as given." 02b does not take r as given: it constructs it, r = cor(index, gv), set by h^2 = 0.5 (R/09_reference.R:46-47; r is near sqrt(h^2)). 08b measures a GBLUP accuracy (08b:284) of a different object. "Finding 5 of @sec-choosing" does assume r = 1 (07:318-324) and is accurate as cited.

### 02b-C14 (L) -- links promised in 02b are not returned by the target chapters; owners: 11b, 08, 08b
- Inbound @sec-response citations come from 14 files, none of 11b, 08, 08b, 07, 10, 10b, 12. 02b motivates itself from 11b's crossover (02b:11-17), says 08 uses `sel_intensity()` (02b:55-57) and sends the reader to 08b for r (02b:459); 11b has no @sec-response (its C1 assumption, 11b:76-82, is the Bulmer statement 02b isolates and 11c restates), 08:210-226 has no citation of 02b, and 08b:284 does not cite it. Not a defect of 02b; recorded so that the next reviews of those chapters decide.

### 02b-C15 (L) -- "a lighter form of the generator that @sec-simulating-crosses builds"; owner: 02b
- 02b:24-25 and 02b:464-467 say 03 builds `simulate_pools()` data step by step. 03:11-19 says the opposite split: 03 builds with `simulate_lines()` and `simulate_data()`, and `simulate_pools()` "uses the same Balding-Nichols pool frequencies, homozygous lines and A x B factorial, but a different trait" (n_qtl effects plus noise versus correlated effects at every marker, no noise); 03:88-92 asserts the equality of lines and X for seed 1. "Lighter form" mislocates the difference (the trait, not the weight).

### 02b-C16 (L) -- preface promise on printed deviations; owner: 02b (and index, with introduction-C1)
- `index:73-76`: for an exact identity "the deviation from a simulated oracle is printed next to it". In 02b only `genic_var()` vs `ref_genic_var()` prints a deviation (tbl-response-genic, last row). The identity b S_I = i r sigma_A (02b:93-101), the per-locus variance identities (02b:211-223, no print) and the orthogonality/reconstruction of GCA and SCA (02b:272-293, `results: hide`, so `identity_dev` is computed and not shown) are asserted, not printed. Same pattern as introduction-C1 for 00.

### 02b-C17 (L) -- variance scale not stated for @eq-response-genic; owner: 02b
- 02b:206-209 marks @eq-response-hybrid-var as "population-variance scale"; the chunk asserts it with `colMeans(X^2) - colMeans(X)^2` (02b:217). `genic_var()` divides by n - 1 (R/15_response.R:47-53) and is what tbl-response-genic prints, with `var(gv)` also on n - 1. The two scales differ by 624/625 at N = 625; @eq-response-genic and the table state neither. No number is wrong; the equation of the table and the equation proved are not the same scale.

### 02b-C18 (L) -- quoted phrase not in the target; owner: 02b
- 02b:399-400 puts "I accept losing five percent" in quotation marks as what @sec-ocs argues; 09:25-27 reads "I accept losing at most $\alpha_{\max}$ of diversity." Paraphrase should not be quoted.

### 02b-C19 (L) -- the alpha lineage does not say which quantity is restricted; owner: 02b
- 02b:436-440 and the callout 02b:442-453 restrict "the loss of molecular gene diversity". The quantity the budget constrains is $GD_T = 1 - \theta_S$ (index:96-100: "the budget does not isolate the within-pool loss"), which contains the between-pool term that 02b:229-236 has just shown does not feed genic variance. The restricted direction is therefore not even the direction that carries response, a point `index:96-100` makes and 02b leaves implicit in the section that argues the lineage.

## Owed items naming 02b

- 02-M9 (genic-variance derivation to be owned by 02b, 02 to cross-reference; keep 02b:229-234 consistent with 02's statements): consistency holds, ownership is not settled. See 02b-C4. Leave open until 02b carries the mixture-base case and 02:788-809 is reduced.

## Inbound @sec- count

@sec- labels mapped to the file that owns them; citations from a file to itself discarded; counted over all .qmd files (index counts as a citing file but owns no label). No broken @sec- target (0). Counts are at the state of this worktree, so 00 and 01 differ from part-introduction.md, which was computed before 01 and 02 were reviewed.

| Chapter | Inbound | Citing files |
|---|---|---|
| 00-hybrid-programme | 29 | 8 |
| 01-coancestry | 31 | 14 |
| 02-subdivided | 40 | 14 |
| 02b-response | 28 | 14 |
| 05b-heterosis-dominance | 80 | 21 |
| 03-simulating-crosses | 28 | 16 |
| 04-population-sizing | 17 | 10 |
| 04b-backcross-introgression | 8 | 7 |
| 04c-alphasimr-pipeline | 21 | 11 |
| 05-genomic-era | 39 | 16 |
| 06-metric-catalogue | 44 | 19 |
| 07-choosing-metrics | 47 | 20 |
| 08-pipeline-stages | 39 | 18 |
| 08b-genomic-prediction | 26 | 14 |
| 09-optimal-contributions | 37 | 16 |
| 10-combinatorial-selection | 31 | 14 |
| 10b-advanced-selection | 25 | 8 |
| 04e-mating-design | 58 | 8 |
| 04f-sparse-testing | 38 | 6 |
| 04g-joint-allocation | 11 | 4 |
| 11-plant-literature | 15 | 8 |
| 04d-breeding-programme | 19 | 6 |
| 11b-diversity-across-cycles | 51 | 20 |
| 11c-limits | 19 | 9 |
| 12-case-study | 21 | 15 |
| 90-notation | 18 | 7 |
| 91-package | 0 | 0 |
| 92-verification | 5 | 5 |
| 93-corpora | 2 | 2 |

02b's 28 come from: index 2, 00 1, 02 2, 03 4, 04c 5, 04d 2, 04f 1, 05 1, 05b 1, 09 1, 11c 3, 90 2, 91 1, 92 2 (14 files, 28 citations). It has a job (the objective side, the proxy argument, the restricted-index lineage); nothing to report on the low-count rule. 91 (0) is an appendix of package reference, 93 (2) and 92 (5) are low as in part-introduction.md; not 02b's concern.
