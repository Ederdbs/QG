# 02b-response -- verdict, iteration 1

VERDICT: REJECTED

DISQUALIFYING FAILURES

- 02b-D1 [criteria 3, 4, 6] book/02b-response.qmd:56-57, 71-94 (overprediction paragraph, both "failures", callout "Read the breeder's equation as an upper bound").
  A single seed (simulate_pools(seed = 1)) yields a 13% overprediction, and the text turns it into structural claims: it is "a property of *this* population", the cause is the lack of bivariate normality "a two-pool hybrid population does not have", and the gap "is not noise and does not shrink with more markers". No replication, no dispersion and no marker-number contrast support any of this. Audit 02b-R1 gives the evidence against it. The residual mean over the selected 60 is z = -1.25 even on the naive SE, which is optimistic given shared parents. Observed i_real (1.701) is about 1 sd below the finite-N expectation of 1.771 (sd 0.066). Over seeds 1:30 of the same call, prediction exceeds realisation in 60% of seeds, the mean relative gap is 0.9% (SE 1.2%), and mean index skewness is -0.001. The chapter therefore presents interpretation as a result, infers a cause from one draw, and leaves out seed dependence. The "upper bound" reading also contradicts @sec-alphasimr (04c-alphasimr-pipeline.qmd:740-795), whose 20 replicated draws find the equation unbiased (criterion 5). Separately, line 73 calls i = phi(z)/q "exact for a normal criterion". That holds only for an infinite population, and with N = 625 and n = 60 the finite-sample assumption goes unstated (criterion 2).

- 02b-D2 [criteria 1, 5] book/02b-response.qmd:122-127 and 258-259 (V_genic "is sum beta^2 p q up to a coding constant ... the same sum over the same loci, weighted differently"; "a diversity constraint is a variance constraint in disguise").
  The hybrid is x_k = (u_A + u_B)/2, with inbred parents drawn from two pools. So Var(x_k) = (pA qA + pB qB)/4 = p_k q_k/2 - (pA_k - pB_k)^2/8, which is not proportional to p_k q_k. On the chapter's own X the per-locus ratio Var(x_k)/(p_k q_k) runs from 0.107 to 0.501. genic_var = 25.205, whereas sum beta^2 p q / 2 = 27.921. The term that is missing is the between-pool divergence (F_ST / GD_BS, Caballero & Toro 2002 Eq. 8), which is exactly the structure the book is about. The claimed identity is therefore false in the population studied. Lines 258-259 then go further and contradict the chapter's own caveat at 129-140.

- 02b-D3 [criterion 1] book/02b-response.qmd:197 (example G) and every number derived from it (200-202, 231-236).
  G = [[2.0, 0.9], [0.9, 0.3]] has eigenvalues 2.388 and -0.088 and an implied genetic correlation of 0.9/sqrt(0.6) = 1.162. It is not a covariance matrix. The Smith-Hazel weights, the restricted weights (including the negative yield weight) and the "gain in restricted trait" column are all computed on an impossible genetic covariance (Falconer & Mackay ch. 19; Lynch & Walsh require G positive semidefinite).

- 02b-D4 [criteria 1, 5] book/02b-response.qmd:205-207 ("coincide only when P^-1 G is proportional to the identity, which requires the traits to be equally variable, equally heritable and mutually uncorrelated").
  Wrong on both counts. b = P^-1 G a is proportional to a if and only if a is an eigenvector of P^-1 G. P^-1 G = cI is equivalent to G = cP, which means equal heritabilities and r_G = r_P. It does not require equal variances or zero correlation. With the chapter's own P and G = 0.5 P, b = (0.5, 0.5) even though the variances are 4 and 1 and the covariance is 1.2 (verified). The package documentation of the function under discussion (R/15_response.R:62-70) states the correct condition, so the chapter also contradicts its own code. Audit 02b-R4 and refcheck 02b-B4 agree.

- 02b-D5 [criterion 1] book/02b-response.qmd:133-140 (callout "No metric in this book can see the disequilibrium term").
  This is false. eff_dim() (R/01_metrics.R:275, exported, in metrics_full) is the participation ratio of the double-centred f, which is the marker-covariance spectrum and therefore a multilocus, LD-sensitive quantity. Audit 02b-R5 ran the test: permuting each column of X independently leaves every allele frequency and theta (0.67191) unchanged and moves eff_dim from 46.6 to 451.9. The single-locus statement holds for the listed metrics only, not for "no metric in this book".

- 02b-D6 [criterion 5] book/02b-response.qmd:41-42 ("`sel_intensity()` ... has never once been used to compute a response").
  This contradicts the book. usefulness_criterion() (R/05_pipeline_metrics.R:279) computes mu + i h sigma using sel_intensity(). 08-pipeline-stages.qmd:219 uses it that way. 04c-alphasimr-pipeline.qmd:751 uses sel_intensity() in a replicated breeder's-equation sweep. "Since @sec-stages" also points forward: 08 comes after 02b in _quarto.yml.

- 02b-D7 [criteria 4, 7] book/02b-response.qmd:145-149, 151-183 (GCA/SCA section).
  The section starts from the additive variance of the breeding values behind gv = X beta. It then decomposes H = heterosis_value(X, d), a dominance-only toy value with d ~ N(0.3, 0.1) drawn ad hoc, which shares nothing with beta (audit 02b-R10). The 23.8/22.8/53.5% shares belong to that toy trait. Read as stated, they look like shares of hybrid genetic variance. Two conclusions are drawn from them with no source and no measurement in the chapter: that SCA "does not accumulate across cycles the way the general components do", and that a programme "selecting on an additive index ... [gets] the third by luck". Refcheck 02b-B7 found no citation (Sprague & Tatum 1942 and Comstock et al. 1949 are in the bib but not cited).

- 02b-D8 [criterion 7] book/02b-response.qmd:37-41, 73 and 101-111.
  Refcheck 02b-B5/B6 flag three uncited results: the breeder's equation R = i r sigma_A, the truncation-intensity formula i = phi(z)/q, and the split of additive variance into genic variance plus a gametic-phase disequilibrium term (Bulmer 1971). In each case a known result is quoted without naming its source. The chapter cites no @key at all (02b-B1/B2 below).

- 02b-D9 [criteria 3, 5] book/02b-response.qmd:11-15 ("overtaking ... after eight cycles", "whether the crossover arrives at cycle 8").
  The text presents a fixed crossover cycle as the book's finding. book/data/cycles_crossover.csv shows the crossover at 8 only for seed 1 at budget 0.020. Across seeds it is 7-12 at that budget (seeds 1-4: 8, 12, 10, 7) and 9-15 at 0.005 (audit 02b-R7). One seed is reported as the result, with its dispersion left out.

NON-DISQUALIFYING OBSERVATIONS

- 02b-M1 book/02b-response.qmd:78-80, 105-118, 164-170, 239-240 -- The text asserts "agree to machine precision", "orthogonal, so their variances add exactly" and "moves the restricted trait by exactly zero". The chunks display these only rounded to 3-4 dp, or printed without being asserted. The identities themselves hold (audit 02b-R6: 0, 1.1e-14, 5e-13, 2.1e-17).
- 02b-M2 book/02b-response.qmd:191, 218, 247 -- Smith 1936, Hazel 1943 and Kempthorne & Nordskog 1959 are named in plain prose. The bib entries exist (smith1936, hazel1943, kempthorne1959) but are never linked, so they do not reach the bibliography (refcheck 02b-B1/B2).
- 02b-M3 book/02b-response.qmd:252 (and R/15_response.R:12-13) -- "A sixty-year-old theorem": 1959 to 2026 is 67 years (refcheck 02b-B8).
- 02b-M4 book/02b-response.qmd:222-224 -- The displayed restricted-index form is algebraically correct and matches the code. It is the C = GR form, and I could not confirm that it is Kempthorne & Nordskog's own notation (refcheck 02b-B3, UNVERIFIED, JSTOR unreachable). The chapter does not claim verbatim notation.

Three non-disqualifying observations are recorded. They would reject on accumulation alone, but the verdict already rests on D1-D9.

WHAT WAS VERIFIED

- Hybrid per-locus variance: Var(x_k) = p q/2 - (pA - pB)^2/8 holds on the chapter's X to 1.5e-15 (population-variance scale). The ratio Var/(pq) ranges 0.107-0.501, and genic_var = 25.205 versus sum beta^2 pq/2 = 27.921. Re-run in R with pkgload on the worktree, seed 1.
- G at line 197: eigenvalues 2.388 and -0.088, r_G = 1.162. Computed in R.
- Smith-Hazel counterexample: with P from line 196 and G = 0.5 P, b = (0.5, 0.5). Computed in R.
- Crossover cycle: book/data/cycles_crossover.csv, budget 0.020, seeds 1-4 give 8, 12, 10, 7.
- b S_I = i r sigma_A: holds identically, since b = cov/var(I) and S_I = i sd(I), so b S_I = i cov/sd(I) = i r sd(g). The algebraic claim at :80 is correct.
- index_restricted and the K&N formula at :222-224: R'G b = 0 holds algebraically with C = GR. Matching the code and the null-space oracle (1.1e-16) is taken from audit 02b-R* and not redone.
- Frozen outputs reproduce (pred 5.908, real 5.116, skew -0.170, genic 25.205, shares 0.238/0.228/0.535). Taken from the audit and not redone.
- Seed-replicated gap, finite-N intensity and the eff_dim permutation test: taken from audit 02b-R1/R5 and not redone.
