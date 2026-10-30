# Verdict: Foundations continuity round, re-review (iteration 2)

Scope: `git diff main -- book/` in /Users/ederdbs/Documents/SB_quanti_gen-review
(01, 02, 02b, index, 90-notation, downloads). Paths relative to the worktree.

VERDICT: REJECTED

PREVIOUS IDS
- C1 -- CLOSED -- book/01-coancestry.qmd:235-242 now states the result 03/05b deliver; mean F1 heterozygous fraction = 1 - mean f_AB, measured 0.3622 / 0.3617 / 0.3619 at fst = 0.02 / 0.15 / 0.40 (simulate_pools, 25+25, m = 2000, seed 1): flat.
- C2 -- OPEN -- index:88-96 and 02:672-679 are correct in the A x B hybrid context, but the third locus, book/02-subdivided.qmd:503-507 (Base population bullet), now applies the A x B factorial result to a base population formed by mixing sources for recurrent selection. See detail under DISQUALIFYING.
- C3 -- CLOSED -- index:97-103 budgets 1 - theta of the selected hybrids = GD_BI + GD_BS with inbred parents (@tbl-keystone, asserted in keystone-check), and states the budget does not isolate the within-pool loss.
- C4 -- OPEN -- 90 gives the parameter its own symbol F_BN and 02b captions are fixed, but the same appendix still writes the Balding-Nichols expectation with F_ST at book/90-notation.qmd:185. See detail under DISQUALIFYING. The deferred 03 half is acceptable as it stands: 90:129-133 now tells the reader that 03 writes F_ST for the parameter.
- C5 -- CLOSED (in-scope half) -- book/02b-response.qmd:436-440: alpha inherits the restriction and not the zero; it is an inequality bounded against a same-size random subset, consistent with 09:70-73. 09 handles the inequality (Setting alpha_max, the bound, the attainable ceiling). The dedup is deferred to the 09 review, and that is acceptable.
- C6 -- deferred (09) -- 02b's example is untouched and still PD-asserted. Nothing in the changed text contradicts 09 beyond the pre-existing finding.
- C7 -- CLOSED -- the criteria vector is now xi (02b:330-341), and xi is used only in 02b and in 90 (90:375, 398), where it is distinguished from c.
- C8 -- CLOSED (in-scope half) -- 02b:201-231 uses p-bar_k, matching the 90 heterosis table. 90:390 documents 03's p_{A,k} and its ancestral p_k. The 03 rename is deferred.
- C9 -- CLOSED -- 02:524-530: with census weights, f-bar is the mean of the full matrix with the diagonal included, which is theta. This is algebraically exact (C&T weights N_i N_j / N_T^2) and keystone-check asserts 1 - theta == GD_T. 90:63 agrees.
- C10 -- CLOSED -- 01:167-170 "molecular inbreeding coefficient", explicitly not F_hom (05:114, 142). The code comment at 01:231 is aligned.
- C11 -- CLOSED (02b half) -- 02b:464-465 now points to @sec-simulating-crosses. The 03 opening is deferred.
- C12 -- CLOSED -- 02b:24-33 matches R/09_reference.R:27-52 line for line: BN pools from runif(0.05, 0.95), 0/1 lines, factorial X, N(0,1) effects on n_qtl loci, gv standardised, noise variance 1/h2 - 1, index rescaled.
- C13 -- CLOSED -- 02:12, "bounds its total (@tbl-keystone)", is supported in 02 itself.
- C14 -- deferred (03) -- 02's drift arithmetic and its deferral to @sec-heterosis are unchanged and correct.
- C15 -- CLOSED -- 90:93 and 02:628 now name the same term. index:86-87 credits the derivation to @sec-subdivided.
- C16 -- CLOSED -- the lambda rows at 90:186 and 90:229 now disambiguate each other. The r pointer at 90:318-319 names the GP table (r at 90:250) and the response table (90:375).
- C17 -- CLOSED -- 02:514-516 now defines u as selection-criterion values: EBVs in Meuwissen 1997, the index u_i in @sec-ocs.

DISQUALIFYING FAILURES
- C2 (reopened) [criteria 1, 2] book/02-subdivided.qmd:503-507, "Base population for recurrent selection" bullet. The bullet's own object is a base formed by mixing seed of the sources in proportions c and then recurrently selecting it. Mixing followed by intermating restores Hardy-Weinberg proportions at the merged frequency p-bar = sum c_i p_i. The additive genic variance of that base is then 2 sum_k beta_k^2 p-bar_k q-bar_k (Falconer & Mackay ch. 8; Lynch & Walsh ch. 4), and it contains the between-source term (p_i - p_j)^2 in full. Under the assumptions the sentence has just listed (additive action, equal effects, markers representing the QTL), maximising GD_T = mean 2 p-bar q-bar is therefore proportional to maximising genic variance. The new text says the opposite, that "even then the two differ by more than the squared-effect weighting", and supports it with an A x B factorial result (02b eq-response-hybrid-var). That result holds only for a non-intermated two-pool hybrid set. The structural assumption it rests on (hybrids are a factorial of two pools that are never intermated) is imported silently into a context that violates it. The sentence is also internally incoherent: under the equal-effects assumption it states, there is no squared-effect weighting left to differ by.
- C4 (reopened) [criterion 5] book/90-notation.qmd:185, heterosis table, the H-bar row: "falls as (1 - F_ST)^2". That is the Balding-Nichols expectation E[p_A q_A] E[p_B q_B] = (p q)^2 (1 - F_BN)^2, so it is in terms of the parameter. Yet the same appendix has just defined F_ST = GD_BS / GD_T as the statistic (90:98) and introduced F_BN for the parameter (90:126-128). Read with the appendix's own definition, the expression is wrong: the statistic is about F_BN/(2 - F_BN), roughly 0.081 against 0.15. The new paragraph at 90:129-133 lists the chapters that write the parameter as F_ST and omits the appendix itself. The symbol is redefined within one file, which is the failure C4 was raised for.

NON-DISQUALIFYING OBSERVATIONS
- F-M1 book/90-notation.qmd:129-133 -- The list of chapters that write the BN parameter as F_ST ("@sec-simulating-crosses, @sec-heterosis, @sec-choosing, @sec-stages and @sec-case-study") is presented as complete, but it is not. book/92-verification.qmd:57 ("F_ST in {0.05, 0.15, 0.35}", simulation settings) and :378, and book/11-plant-literature.qmd:333 ("invariant to F_ST under neutral divergence") also use F_ST for the parameter. A reader of those pages gets no mapping.
- F-M2 book/index.qmd:97-98 -- "the loss of gene diversity of the selected hybrids, $1 - \theta$" can be read as saying that the loss itself equals 1 - theta. The budgeted quantity is alpha, the loss relative to the random-subset baseline, and the reader has to infer the comparison from the following clause.

WHAT WAS VERIFIED
- notation-fst-parameter numbers -- re-run independently with the package loaded from the worktree. F_BN/(2 - F_BN) = 0.08108; the simulated ratio of expectations (2e5 loci) = 0.08137, so the stopifnot tolerance of 0.005 holds. The book_cfg statistic from ct_partition = 0.10240, and an independent computation from fL (census-weighted f-tilde, full mean f-bar, diagonal included) gives 0.10240. The off-diagonal version = 0.08370. Text values 0.081 / 0.081 / 0.102 / 0.084 are correct.
- Seed robustness of the off-diagonal assertion -- over seeds 1 to 20, mean 0.0820 and s.d. 0.0035 (range 0.0757 to 0.0868). Seed 1 passes with margin 0.0026. The text reports only the seed-1 value, so no generalisation is claimed.
- Expected GD_BS = F_BN p q and GD_T = (2 - F_BN) p q per locus (90:134-136) -- derived: E[(pA - pB)^2/2] = Var(pA) = F p q, and E[2 p-bar q-bar] = 2(p q - F p q / 2). The ratio of the sums is F/(2 - F) for any distribution of the ancestral p. Correct.
- 02b identity 2 p-bar q-bar = pA qA + pB qB + (pA - pB)^2/2 -- expanded by hand, exact. Var(x_k) over the factorial = (pA qA + pB qB)/4, which is 1/4 of the per-locus within-pool part of GD. The index/02-closing wording "within-pool part, weighted by squared effect" is correct up to that constant.
- C1 claim -- for 0/1 lines, the hybrid i x j is heterozygous at k iff u != v, so its heterozygous fraction is 1 - f_ij. Under BN, E[pA qB + pB qA] = 2 p q, independent of F_BN. Numerically flat (see C1).
- C9 -- f-bar = sum_ij (N_i N_j / N_T^2) f-bar_ij with within-group f-bar_ii including self-coancestry, which is the full-matrix mean. Confirmed by keystone-check's assertion all.equal(1 - theta, GD_T).
- C12 -- R/09_reference.R:27-52 read against 02b:24-33.
- Anchors -- @sec-baseline (06:321), @sec-heterosis-flat (05b:452), @sec-stages (08:1, S1 panel 08:148), @sec-genomic-era (05:1) and @sec-ocs (09:1) all exist. xi does not appear outside 02b and 90.

## iteration 2

Scope: re-review of C2, C4, F-M1, F-M2, and new failures only in the text that changed
(book/02-subdivided.qmd:497-516, book/90-notation.qmd:126-133 and :186, book/index.qmd:97-104).

VERDICT: APPROVED

PREVIOUS IDS (re-review only)
- C2 -- CLOSED -- book/02-subdivided.qmd:497-516 now separates the two cases. Intermated mixture: GD_T = 1 - sum f_ij c_i c_j = mean_k 2 pbar_k qbar_k (between-source term kept), HWE 0/0.5/1 genotype variance pbar qbar / 2, genic variance sum beta_k^2 pbar_k qbar_k / 2 = m beta^2 GD_T / 4 under equal effects (Falconer & Mackay ch. 8: 2pq alpha^2 with alpha = beta/2 on the 0/0.5/1 scale). Never-intermated A x B hybrids: within-pool part only (@sec-response). Assumptions (intermating to HWE, additive action, equal effects, markers representing QTL frequencies) are declared, and the LD blind spot is stated for both cases. No in-chapter check is required: the claim is a closed-form derivation, every step is stated, and no number is reported. The identity GD_T = 1 - theta that it starts from is already asserted in the chapter.
- C4 -- CLOSED -- book/90-notation.qmd:186 now reads "its Balding-Nichols expectation falls as (1 - F_BN)^2". It is consistent with F_ST = GD_BS/GD_T (90:98) and F_BN (90:126-128). The remaining F_ST occurrences in 90 (98, 126, 132, 141, 444) all use the statistic, or name the parameter's alias explicitly.
- F-M1 -- CLOSED -- 90:129-133 now adds @sec-plant-literature and @sec-verification. Grep over book/*.qmd: 04g:618, 04f:758, 04c:1207, 05 and 02 use the statistic and need no mapping, and 11:333 and 92:57/378 are now covered.
- F-M2 -- CLOSED -- index.qmd:97-100 defines alpha as the relative shortfall of the selected hybrids' GD_T = 1 - theta below that of a same-size random selection. That is the definition make_fitness() computes, (gd_ref - gd)/gd_ref with gd = 1 - mean(f[idx, idx]) (R/03_de_select.R:177-178).

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
None.

WHAT WAS VERIFIED
- GD_T = 1 - c'fc = mean_k 2 pbar_k qbar_k with f_ij = mean_k (p_ik p_jk + q_ik q_jk) and pbar = sum c_i p_i -- independent R check: 4 sources, 200 loci, c = (0.4, 0.1, 0.3, 0.2), seed 7, all.equal TRUE.
- Genic variance of the intermated mixture = m beta^2 GD_T / 4 -- 1e5 HWE individuals drawn at pbar, 0/0.5/1 coding, beta = 0.3: sum beta^2 Var(x_k) = 2.05405 against m beta^2 GD_T / 4 = 2.05352. Agrees with the writer's scratch figure (0.5058 vs 0.5054). Also derived by hand: Var(x) = 2 pbar qbar / 4.
- F-M2 -- R/03_de_select.R:168-185 read: the gd_ref baseline is the random-subset reference (stage2_select step 1), and the relative form matches the index wording.
- F_ST usage across book/*.qmd -- grep. Every use of F_ST for the BN parameter is in a chapter that the 90 mapping now lists.
