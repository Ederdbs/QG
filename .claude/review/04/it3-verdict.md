# 04-population-sizing -- verdict, iteration 3

VERDICT: APPROVED

PREVIOUS IDS
- 04-D12 -- CLOSED -- The bold "90 (N90 for D)" is gone. The F2 rows of tbl-sizing-working-numbers (qmd:765-786) are now: 270 conditional on recovery at k = 5 as the binding objective, disclosed as one population per N with a non-monotone curve; "not reached" for k >= 8; and N90 for D labelled "a reference point, not a size", with its bracket (70 to 110). The caption (qmd:757) now agrees with the rows.
- 04-D13 -- CLOSED -- qmd:697-748 names the f1_sizing() quantity "parental alleles lost". It declares that heterozygosity arises independently in the two parents, and derives the biallelic count of loci made monomorphic, n_loc[2h(1-h)(1/2)^n + h^2 2(1/4)^n], with thresholds 10 and 9 both stated. The roxygen (R/06_f2size.R:570-598) and the test descriptions (tests/testthat/test-f2size.R:69-89) use the same wording. The test threshold is now derived (floor(log2(4 h n_loc)) + 1 = 10). No prose calls the f1_sizing() quantity "lost loci". The one remaining occurrence (qmd:712, "That is not the number of loci lost") states the distinction. The column name expected_loci_lost is kept for the callers, and the roxygen says so.
- 04-D14 -- CLOSED -- n90_bracket() (qmd:561-570) puts a 2-s.e. bracket on each N90, with the threshold variance 0.01 se_1^2 + 0.81 se_n^2. For min(p, 1-p) the bracket is 30 to 350, and the prose (qmd:635-643) says the grid does not locate its N90 and takes the objective contrast off it. The writer's further result is confirmed: with threshold error included, D at N = 90 sits at z = +1.54, so D's N90 is not resolved either (bracket 70 to 110). The table, the prose and the working-numbers row all print 70 to 110, and none of them calls it resolved. My iteration-2 statement that it "is resolved" omitted the threshold error and is withdrawn.
- 04-D15 -- CLOSED -- qmd:178-183 now gives the setup per table: het and diversity on a 10 cM map with distortion off; junctions on the cached 2 cM grid with distortion active; spacing on live neutral panels at 2 and 1 cM. This matches each caption.
- 04-M10 -- CLOSED -- WLS slope -0.00025 per 100 plants, s.e. 0.00013, z = -2.00. Over the grid that is -0.00096, against a mean gap of 0.0095. All are inline and reproduced. "Barely reduce ... at the margin of detection" (qmd:423-429) matches the number. The s.e. treats the 10-40-replicate s.d. as known, and the text says it is computed "from those variances".
- 04-M11 -- CLOSED -- qmd:321-340 sets the panel against the grid (-1.8 panel s.e.), states that the data cannot separate sampling error from the effect of distortion, and reports the 2 vs 1 cM contrast as 2.9 pp (s.e. 1.1), called imprecise.
- 04-M12 -- CLOSED -- the row and the caption both say "one population per N ... no replicate error".
- 04-M13 -- CLOSED -- P_neutral 0.8245 (s.e. 0.0079) against 0.8309, and the assertion is now 4 s.e., with the basis stated.
- 04-M14 -- CLOSED -- qmd:620-624 prints inline values (0.717 vs 0.583 at N = 10; first reaches 0.95 at grid N = 50, both).

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 04-M15 book/04-population-sizing.qmd:106-107 -- the distorters callout says the distortion gap is one "more plants barely reduce" without the "inside the range tested" limit that qmd:425-429 attaches to the same claim. The callout's pointer to @fig-sizing-diversity carries the scope only implicitly.

Count of non-disqualifying observations: 1 (below the threshold of 3).

WHAT WAS VERIFIED
- The chapter, purled and executed in full against the worktree package (pkgload::load_all, sourced from book/), runs clean. Every stopifnot passes.
- N90 brackets: z for D at N = 10..150 is -28.0, -13.4, -7.7, -2.28, +1.54, +2.11, +4.60, +4.12, which gives a bracket of 70 to 110 (the writer's claim is confirmed). min(p, 1-p): crossing between 70 and 90, bracket 30 to 350.
- Distortion gap: unweighted slope -0.000165 per 100 plants. WLS slope -0.000253 per 100 plants, s.e. 0.000126 (1/sqrt(sum w (N - Nbar_w)^2), the correct known-variance s.e.), z = -1.998. Over the grid that is -0.00096 against a mean gap of 0.00949, about 10% of the gap, consistent with "barely reduce" (the writer's claim is confirmed).
- F1: alleles lost 1.953 / 0.977 at n = 9 / 10, so n_f1 = 10. Loci made monomorphic: 1.856 / 0.928 at n = 8 / 9, so n_f1_loc = 9. 5000 x (0.095 x 2^-9 + 0.0025 x 2 x 4^-9) = 0.9278 by hand. The 2(1/4)^n term for Aa x Aa (all F1 AA or all aa) is correct. The roxygen's "about half" agrees with the ratio (1 - h)/2 = 0.475.
- test-f2size.R oracle: 4000 (parent, locus) rows at n = 3 give an expectation of 4000 x 2/8 = 1000, equal to f1_sizing(3, h_res = 0.4, 5000). The threshold formula gives floor(log2(1000)) + 1 = 10.
- Spacing reconciliation: z_sp2_grid = -1.81. The 1 vs 2 cM difference is 2.87 pp, s.e. 1.07.
- Working numbers: k_hit = 5, with first grid N reaching 0.95 at 50 (k = 3) and 270 (k = 5), and NA for k = 8 and 10.
