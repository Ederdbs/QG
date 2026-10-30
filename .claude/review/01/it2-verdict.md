# 01-coancestry -- verdict, iteration 2

VERDICT: APPROVED

PREVIOUS IDS
- 01-D1 -- CLOSED -- :115-126 now states 1_S'G1_S = ||Z'1_S||^2/(2 sum pq) >= 0 and E = n(N-n)/(N-1) mean(G_ii). Both reproduced (see below), and chunk :128-135 asserts non-negativity.
- 01-D2 -- CLOSED -- :219 reads s_i - 0.5 = F_i/2 ("half the fraction"). This is consistent with :227 (2*fd - 1), and :230 asserts it.
- 01-D3 -- CLOSED -- @eq-g05 (:262-266) gives G_0.5 = 4f - 2J and calls it affine, not f. The ordering equivalence is restricted to 1'c = 1 (:270-274), and chunk :277-285 asserts it. 05-genomic-era.qmd:118 and 90-notation agree.
- 01-D4 -- CLOSED -- toro2014 is now Livest. Sci. 166:48-53. The text routes the claim as "@meuwissen2020, citing @toro2014" (:256), so the chapter does not attribute the result directly to an unverified full text. The identity itself is verified numerically.
- 01-D5 -- CLOSED -- Each of these now has a source: @vanraden2008 (:70), @lindgren1997 (:97), @malecot1948 (:148) and @falconer1996 ch. 5 (:166-167). lindgren1997 metadata is unverified, but the chapter uses it only to name N_s = 1/(2 theta), which is standard and not decisive.
- 01-D6 -- CLOSED -- caballero2000 has been removed. :152 cites [@caballero2002; @eding2001], and eding2001 has verified metadata. caballero2002 remains UNVERIFIED, which makes it unsupported, not false. It is not decisive: @eq-f-molecular is checked algebraically against a literal double sum in chunk :206-211.
- 01-D7 -- CLOSED -- :314-320 now describes the three assertions that test-metrics.R actually makes, including the new "diversity metrics read f, not G" test. That test exists, discriminates (theta_group(all) = mean(f) = 0.672, against ~0 on G) and passes. A residual overgeneralisation is recorded as 01-M7.
- 01-M1 -- CLOSED -- :110-113 separates the exact zero from floating-point residue. The table cell now reads "0 in exact arithmetic".
- 01-M2 -- CLOSED -- :190-192 says O(n^2 m) and attributes the gain to the BLAS constant factor.
- 01-M3 -- CLOSED -- :39 now reads "Given the homozygous parents declared above". :33-35 and :221 make the "absence of epistasis" qualifier explicit (Falconer & Mackay H_F1 = sum d y^2, with y^2 = 1 exactly at the differing loci of inbred parents).
- 01-M4 -- CLOSED -- :251-253 names the range violation (Gomez-Romano 2016) and the zero total as distinct symptoms of one cause.
- 01-M5 -- CLOSED -- ctx[["X"]], ctx[["G"]] and ctx[["f"]] are used throughout the chapter.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 01-M6 book/01-coancestry.qmd:269-270 vs :284 -- The prose says G_0.5 entries "lie in [-2, 2] and are signed". The chunk printed four lines later shows range(G05) = [0.579, 1.327], all positive on the book data, and the text does not remark on it. The bound is correct and the sign is possible in general (f_ij < 0.5), but the demonstration offered next to the claim does not exhibit the property it states.
- 01-M7 book/01-coancestry.qmd:317-320 -- "so a metric that silently switched to G fails the suite". The new test covers theta_group() and therefore gene_diversity(), status_number() and alpha, all of which route through it. Several metrics read ctx$f directly instead (ene, eff_dim, mean_offdiag, GD_WI_hyb in R/01_metrics.R; ane is covered separately by its ref_ane oracle). I could not confirm that a switch in each of those would fail the suite. The general "a metric" therefore claims more than the cited test establishes.

Two non-disqualifying observations: below the accumulation threshold.

Unverified citations (caballero2002, toro2014 full text, the 1997 form of nejatijavaremi, lindgren1997 metadata): the chapter does not lean on any of them for anything decisive. Each claim they accompany is either verified in-chapter by stopifnot (molecular f, G_0.5 = 4f - 2J, the allelic-similarity average) or is a standard definition (N_s = 1/(2 theta)).

WHAT WAS VERIFIED
- E[1_S'G1_S] = n(N-n)/(N-1) mean(G_ii) -- 3000 draws at book_cfg (N = 625). Observed vs formula: n = 10, 8.91 vs 8.85; n = 300, 140.40 vs 140.25; n = 600, 21.46 vs 21.58. This also follows analytically from the without-replacement variance of a total of mean-zero rows.
- G_0.5 = 4f - 2J -- all.equal TRUE. range(4f - 2) = [0.579, 1.327].
- s_i = (1 + F_i)/2, with F_i = rowMeans(X != 0.5) -- all.equal TRUE. min(G) = -0.139, which matches the min_G cited at :119.
- theta_group(1:N) = mean(f) = 0.6719 -- this is the new test's premise, confirmed.
- devtools::test(filter = "metrics") -- FAIL 0, PASS 141. The new test is present at tests/testthat/test-metrics.R:25-32.
- Heterosis statement :33-35 -- Falconer & Mackay ch. 14, H_F1 = sum d y^2. For inbred parents, y^2 = 1 exactly at the heterozygous loci of the F1. Correct under no epistasis, as stated.
- heterozygous_fraction = 2(1 - fd) at :228 -- 1 - F = 1 - (2 fd - 1). Correct.
- 05-genomic-era.qmd:118 caption and the 90-notation G_0.5/Z/J/M^H/M^L/s_i rows -- consistent with @eq-g05, @eq-hybrid-dosage and :165.
