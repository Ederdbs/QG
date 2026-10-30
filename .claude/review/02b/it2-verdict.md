# 02b-response -- verdict, iteration 2

VERDICT: REJECTED

PREVIOUS IDS
- 02b-D1 -- CLOSED -- Seed 1 is now labelled as a single draw. tbl-response-replicated reruns it over 30 seeds (mean relative gap 0.006, s.e. 0.016, range -0.211 to 0.134; 19/30 overpredict) and guards the claim with stopifnot. The causal skewness/normality reading and the "upper bound" callout are gone. The infinite-population assumption of phi(z)/(n/N) and the teaching-scale limit are both declared. 90-notation is updated to match.
- 02b-D2 -- CLOSED -- @eq-response-hybrid-var is correct and asserted (the ratio is 0.107-0.500, re-run). The "same sum" and "variance constraint in disguise" claims are withdrawn, and the link to GD now runs through the within-pool part.
- 02b-D3 -- CLOSED -- Sigma_G = [[2,0.3],[0.3,0.3]] has eigenvalues 2.051 and 0.249, and Sigma_P - Sigma_G has 2.460 and 0.240. Both are positive definite and asserted in the chunk. b_SH = (0.617, -0.141) and b_r = (0.654, -0.654) were recomputed.
- 02b-D4 -- CLOSED -- The iff condition (a is an eigenvector of Sigma_P^-1 Sigma_G), with Sigma_G = c Sigma_P as a sufficient condition, is correct and consistent with R/15_response.R. The counterexample is asserted.
- 02b-D5 -- CLOSED -- The callout is restricted to the frequency-based metrics, and eff_dim() is named as the multilocus exception.
- 02b-D6 -- CLOSED -- "Never once used" is removed. The pointers to @sec-stages (08:219, usefulness_criterion) and @sec-alphasimr (04c:751) are correct and labelled as later chapters.
- 02b-D7 -- CLOSED -- H is declared as an illustrative dominance-only value unrelated to beta, and the shares are declared as shares of H. The unsupported accumulation and "by luck" claims are removed. GCA is framed against the tester pool, with [@sprague1942].
- 02b-D8 -- CLOSED -- [@falconer1996, ch. 11] and [@bulmer1971] are added, and all keys resolve in the bib. Content verification belongs to quant-refcheck.
- 02b-D9 -- CLOSED -- The crossover is now described as seed-dependent, which matches 11b (tbl at :273-276).
- 02b-M1 -- CLOSED -- All four identities are now enforced by stopifnot. The chapter purls and runs clean.
- 02b-M2 -- CLOSED -- The citations are linked.
- 02b-M3 -- CLOSED -- Fixed in both the chapter (:398) and R/15_response.R:12-14.
- 02b-M4 -- CLOSED -- Now stated as the C = Sigma_G R form "not necessarily their notation".

DISQUALIFYING FAILURES
- 02b-D10 [criteria 1, 2] book/02b-response.qmd:332-345, read with :301-303 (section "What `weights = NULL` is assuming"). The rewritten paragraph concludes that wherever b is not proportional to a, "the index being maximised is not the index anyone intended", and the section applies this to stage2_select()'s equal-weight default. Eq. @eq-response-smith-hazel, b = Sigma_P^-1 Sigma_G a, is the optimum only when the index is built on phenotypic records whose covariance is Sigma_P. That is not what weights = NULL weights. The criteria are *predicted* trait values: R/00_data.R:125-130 ("predicted GEBVs") and :150 ("Numeric matrix of predicted trait values"), and build_ctx standardises them before weighting (:168-171). For a predictor ghat of g, the Smith-Hazel weights are Var(ghat)^-1 Cov(ghat, g) a. When ghat is the (multi-trait) BLUP, Cov(ghat, g') = Var(ghat), so b = a exactly, and equal weighting on the predictions is then the optimum, not a departure from it. What the default actually assumes is something else, and the chapter never states it: the traits are standardised before equal weighting, so the implied economic weights are 1/sd(ghat_j) in trait units. The chapter therefore puts a phenotypic-index result onto a prediction-based criterion without declaring that assumption (criterion 2). It also misidentifies what the default assumes (criterion 1). The algebra above is standard index theory and needs no outside source, so none is invoked.

NON-DISQUALIFYING OBSERVATIONS
- 02b-M5 book/02b-response.qmd:250 (with the unchanged heading :246) -- "@sec-heterosis-gca-sca already built the exact orthogonal split". That section is in 05b-heterosis-dominance.qmd, which _quarto.yml places after 02b, so a reader in book order has not yet seen it. This is the same forward-as-backward pattern that was flagged in D6.
- 02b-M6 book/02b-response.qmd:148-150 -- The first "limit" offered for the replicated s.e. is not a limit. The seeds are independent replicates. The within-seed noise from 625 hybrids sharing 50 parents is already part of the between-seed s.d. that gap_se uses, so it does not make that s.e. optimistic. The sentence invites the reader to discount a valid s.e.
- 02b-M7 book/02b-response.qmd:194, 264-265; 41 vs 307 -- The pool-B parental allele is u_{Bk} in the prose, but the same chapter's code calls the pool-B line matrix `V`, and 90-notation's heterosis table (and @sec-heterosis-gca-sca) use v for pool B (delta u_ik delta v_jk). The 90-notation Response table now adds u_{Bk}, so the book has two letters for one object. Separately, scalar $g$ (:41, the hybrid genetic value, then never used in any equation) and bold $\mathbf{g}$ (:307, the vector of traits' genetic values) are both introduced, and neither appears in 90-notation.

Three non-disqualifying observations are recorded, so the chapter would also reject on accumulation alone.

WHAT WAS VERIFIED
- The chapter was purled and sourced from book/ in the review worktree. Every stopifnot passes.
- Replicated chunk: mean rel_gap 0.00631, s.e. 0.0161 (sd 0.0882 / sqrt 30), t-test p = 0.70, 19/30 seeds overpredict, range -0.211 to 0.134. Seed 1 (0.134) is the largest gap of the 30, which the table min/max shows. Mean i_real 1.776, finite-N normal expectation 1.771 (sd 0.044, 4000 draws), infinite-population 1.774. Seed-1 i_real 1.701. The finite-N value being "smaller" holds by 0.003 (MC s.e. about 0.0007).
- Positive definiteness: eig(Sigma_G) = 2.051 and 0.249, eig(Sigma_P - Sigma_G) = 2.460 and 0.240, r_G = 0.387. Hand check: b_SH = P^-1 G a = (1.58, -0.36)/2.56 = (0.617, -0.141). For b_r = (0.654, -0.654), the second element of G b_r is 0.3*0.654 - 0.3*0.654 = 0.
- 2pq = pAqA + pBqB + (pA - pB)^2/2 was checked by hand. For equal pools, the Caballero & Toro (2002) GD_BS per locus is 2*D_AB/4 with D_AB = (pA - pB)^2, giving (pA - pB)^2/2, so the "between-pool term of @sec-subdivided" identification is correct. Hybrid-set GD = 1 - mean(f), with the diagonal included, equals (1/m) sum 2 p_k q_k for the full factorial.
- Over the factorial, Cov(x_k, x_l) = (D_A + D_B)/4, which is within-pool LD only, so the "gametic-phase disequilibrium" reading of @eq-response-ld holds. Realised variance is 22.484 and genic variance 25.205 (seed 1).
- GCA/SCA shares are 0.238, 0.228 and 0.535 (re-run, unchanged from it1).
- Symbols: W, Sigma_P/Sigma_G, n_t/n_r, C and q = 1 - p are applied consistently inside 02b, and the selected fraction is written n/N throughout. None of them collides with 01-coancestry (p_k there is the same hybrid frequency) or 02-subdivided. The one exception is u_{Bk} vs v (M7).
- @sec-alphasimr (04c:740-795) replicates over 20 draws and finds the gap small relative to its s.e., which supports the "same reading" sentence at :147-148. Note that 04c tests R = S h2 with the empirical intensity, not the normal-theory prediction.
