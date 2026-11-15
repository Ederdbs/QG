# 04g-joint-allocation -- verdict, iteration 2

Chapter: book/04g-joint-allocation.qmd (1,502 lines, rewritten), plus the edits to R/18_joint_allocation.R (roxygen, one code comment), man/joint_alloc.Rd, tests/testthat/test-joint.R, book/04f-sparse-testing.qmd (line 1277). Package loaded with pkgload::load_all of the worktree; chapter knitted in the scratchpad (knitr::knit, 17 s, all stopifnot() in the chunks passed); scripts in .../scratchpad/chk.R, empty.R, knit/.

VERDICT: REJECTED

(The rejection rests on the accumulation rule only: no disqualifying criterion fails in the changed text and all five old D are closed. Three non-disqualifying failures are open, 04g-M14, M15, M16, plus the residual of M13.)

PREVIOUS IDS
- 04g-D1 -- CLOSED -- "under another name" is gone from the chapter, from R/18 roxygen and from 04f:1277 ("closest analogue, not the same allocation"). Recomputed: chunk joint-parentage, complete 20 x 20, 8 locations, k = 2, seeds 1..20: allocations differ in 20/20, coverage and load range equal, frac_disconn 0.000 (coverage) vs 0.286 (parentage), conc_hmean 13.4 vs 0. The structural argument (20 groups x one pair < 28 pairs) agrees with R/17 sparse_alloc.
- 04g-D2 -- CLOSED -- 04g:63-64 and 160-162 say 80 % planted, 320 of 400, consistent with the limitations. R/18 header line 3-5 ("taking the whole factorial as given") describes R/17 code, which does allocate every hybrid; it is not a chapter claim.
- 04g-D3 -- CLOSED -- "tested here" removed (04g:1471-1476, 1167-1168); non-detection reported, z printed live (1.74), and the text says the contrast moves coverage and concurrence together and is not a test of 04f result 4. Recomputed from joint_contrasts.csv: 24 cells, +0.005695, se 0.003272, z 1.741, 16/24 positive.
- 04g-D4 -- CLOSED -- result 1 now carries the difference of differences. Recomputed from joint_core_sweep.csv (own script, chk.R): 160-vs-40, coverage, circulant: h2 0.2 low 0.0636, high 0.0960, dd 0.0324, se 0.0377, z 0.858; h2 0.4 0.0873, 0.1463, dd 0.0590, se 0.0298, z 1.979; 80-vs-40 at h2 0.2 low 0.0520, high 0.0130. The claim "no dependence on the SCA variance is established" is what the data allow. (A wording residue is in M15.)
- 04g-D5 -- CLOSED -- @seye2020 removed from the "favours lines never crossed" clause; the Melchinger symmetric cost added. Checked against the PubMed abstracts (efetch 37532821, 35918515, 32185420): Melchinger c = 1 highest for H0 hybrids and GCA of I0 lines, lowest for H1, H2 and GCA of I1 lines, optimum depends on programme size; Seye "small impact" of the contribution number; Seye and Lorenzi "as efficient ... outperformed for some traits". The statement is now scoped to abstracts. (Wording residue in M16.)
- 04g-M1 -- CLOSED -- tbl-joint-cap reproduced (seeds 1-100 / 101-200 / max excess): circulant c=4,k=2 2/3/1; c=2,k=4 20/18/1; random c=4 0/4/1; tester 0/1/1; c=8 and random c=8 0/0/0. Roxygen and test list now say penalty, not constraint; behaviour unchanged and disclosed. New test asserts excess <= 1 over seeds 1..40, not zero, as the text says.
- 04g-M2 -- CLOSED -- 16 pairs, all tester below circulant c = 4, z 2.10 to 3.78 (chk.R), printed live; plans differ in crosses (76 vs 80) and structure, stated.
- 04g-M3 -- CLOSED -- the four-locations mechanism is a hypothesis; the made subsets (160, 80, 40) are stated not to be one estimand.
- 04g-M4 -- CLOSED -- circulant-only spread printed 0.3 to 4.7 %, overall 0.3 to 4.7 % median 1.8 %; plan variation in the random and tester clusters stated. Recomputed in the knit.
- 04g-M5 -- CLOSED -- the 65 % cut-off is declared post hoc and descriptive (04g:1313).
- 04g-M6 -- CLOSED -- "reproducible" is now scoped to the numbers, the literature search is declared non-reproducible, "30 minutes" removed. Rerun done, see WHAT WAS VERIFIED: joint_core_sweep.csv and joint_contrasts.csv are byte-identical.
- 04g-M7 -- CLOSED -- the REML mechanism is 04f's hypothesis in the checklist and the limitations (04g:1383).
- 04g-M8 -- CLOSED -- the diversity argument is 04e's hypothesis, only the measured drift term of @sec-joint-freq is cited (04g:1477-1483).
- 04g-M9 -- CLOSED -- closing paragraph matches 11-plant-literature.qmd and _quarto.yml (Evidence and practice starts at 11).
- 04g-M10 -- CLOSED -- 04e's regime (200 x 200, unrelated lines, no relationship matrix, one location, line GCA) named; agreement in direction only; marker panel declared not the generator of @sec-simulating-crosses.
- 04g-M11 -- CLOSED (chapter side) -- sigma^2 mapping, plot h2, n_c / L / r reuse, N_SNP as Meuwissen's symbol, joint_pev vs Box 4 of 04f all stated in the chapter. 90-notation has rows for n_c, B, N_P, N_SNP.
- 04g-M12 -- CLOSED -- Heslot, Butler/Cullis/Lisle, Guo, Nei, Comstock, Thomsen wordings are now at the level of the evidence the text says it read.
- 04g-M13 -- OPEN (residual only) -- the chapter-side items (n_unc format, timings measured in-chunk, "resolved" bars, T-level of acc_unmade) are done; the author's own "Owed" list (90 wording of n_c and r/L rows, 91 file map for R/18, 92 table of the three joint_*.csv) is not done. 92-verification.qmd:239 only lists @sec-joint in a cross-reference vector; 91-package.qmd does not mention R/18.

DISQUALIFYING FAILURES

None.

NON-DISQUALIFYING OBSERVATIONS

- 04g-M13 (residual, see above) -- appendices 90/91/92 do not yet list the R/18 file and the three joint CSVs; owed by the author.
- 04g-M14 04g:523-527 (text unchanged since it1; found on re-reading, and the changed roxygen of joint_connectivity depends on it) -- "n_comp_loc adds information only when n_comp_cross > 1 or a location is empty". By the chapter's own definition (components of the location graph) an empty location is an isolated node; the implementation takes components over locations that have a plot (lc[!is.na(lc)]). Recomputed (empty.R): circulant c = 2, 6 x 6, 3 locations plus a fourth empty column: n_comp_cross 1, n_comp_loc 1, ncol 4. So the count does not flag an empty location, and checklist item 6 ("check n_comp_loc == 1") would not either. No sweep result is affected (all 8 locations are occupied in every replicate, asserted at 04g:1335). The new oracle test draws a blank location in 30 of 150 allocations and agrees with the code because the oracle also drops it, so it fixes the divergence from the definition rather than exposing it. Counted under criterion 1, low weight, outside the changed text.
- 04g-M15 04g:87-93 and 04g:1011-1012 -- result 1 says the dd is "not detected in the first, short of three standard errors in the second"; the second is z = 1.979, below the chapter's own bar of two standard errors (04g:952, "detected past two"). The wording invites reading it as detected between two and three. The conclusion that follows ("no dependence ... established") is right. In the results section "With high SCA the steps are larger" (0.682, 0.636, 0.535 against 0.787, 0.767, 0.700) is stated without the dd z or the h2 = 0.2 counter-case that the opening gives. The 160-vs-40 dd is a third look (with the 80-vs-40 step and the h2 split) and no multiplicity is mentioned.
- 04g-M16 04g:415-422 -- the Melchinger 2023 sentence says one cross per line gives "the highest accuracy for hybrids and for the GCA of lines never crossed and the lowest for hybrids and the GCA of lines already crossed". "Hybrids" appears on both sides without the H0 / H1-H2 qualifier of the abstract (highest for H0 hybrids, lowest for H1 and H2), so the sentence reads as self-contradictory. Abstract level, direction correct.
- 04g-M17 04g:1170-1175 -- "The sweep above contains such draws" (coverage load above the cap) is not checked: per-replicate allocations are not stored (joint_raw.rds holds scores only). At 20 % of draws at circulant c = 2, k = 4 it is near certain, but it is an inference.
- 04g-M18 (cosmetic) -- regenerate.R prints "regenerate: complete" before the joint block (owed by the author); unchanged.

WHAT WAS VERIFIED

- Chapter knits end to end with the worktree package: knitr::knit in scratchpad, 16.6 s, no error, every chunk stopifnot() passes (joint-parentage, tbl-joint-misspec, tbl-joint-alias, joint-uncrossed, tbl-joint-freq, Spearman block).
- D1: numbers above from the chunk output (20 of 20; 0.000 vs 0.286; 13.4 vs 0).
- D3 / D4 / M2 / M4: independent script chk.R from the CSVs, outputs as quoted. Eight budget steps: z160v80 0.51, 1.15, 3.41, 2.14; z80v40 1.86, 3.37, 0.48, 4.38 (four under two, one at 2.14, as printed). Tester pairs 16, range 2.10 to 3.78, all below. Spread 0.3 to 4.7 %, median 1.8 % in the knit.
- M1: tbl-joint-cap table as printed in the knit (values above).
- Tests: devtools::test(filter = "joint"): 8 tests, 325 expectations, 0 failed, 0 skipped, 0 errors. HEAD's test-joint.R run alone: 6 tests, 24 expectations. Difference 301 = 300 oracle expectations (150 draws x 2) + 1 cap, as the R agent says. Full suite devtools::test(): 130 tests, 816 expectations, 0 failed, 0 skipped, 0 errors, 0 warnings. The 515 baseline follows from 816 - 301 only because git shows test-joint.R as the sole changed test file; I did not run the full suite at HEAD.
- Union-find oracle test: it builds its own union-find (ref_components) from the definition, hard-codes the male-fastest row index, and calls neither design_components() nor plan_clean() nor sparse_parent_index(); independent of the code under test. Limitation: it treats an empty location as absent, like the code (M14).
- Roxygen: man/joint_alloc.Rd contains the new text; R/18 change otherwise a comment. The 04f edit at 1277 reads "closest analogue, not the same allocation: it has no term for the hybrids two locations share".
- Byte identity, rerun of `regenerate.R joint` from a scratch copy of R/, DESCRIPTION, NAMESPACE and the script (33 min CPU, 14:11 to 14:53, finished "joint: done"): cmp joint_core_sweep.csv IDENTICAL; cmp joint_contrasts.csv IDENTICAL; joint_optimiser.csv differs only in sec_600 (all.equal TRUE on the other eight columns; wall time cannot be byte-identical). Side finding: in the rerun all 24 exchange searches took 62 to 71 s (sum 25.7 min); the tracked file has three cells at 1,861, 6,694 and 8,338 s and 21 at 46 to 49 s. The omitted long times are therefore not a property of the search; the chapter's "cause not recorded" stays accurate and its 16.4-minute figure is a lower bound on this machine, as it says.
- M9: 11-plant-literature.qmd opens "@sec-choosing derived a recommendation ..." and _quarto.yml puts it first in Evidence and practice.
- Literature: Melchinger 2023, Lorenzi 2022, Seye 2020 against PubMed abstracts (efetch), as in D5.

NOT VERIFIED

- Literature beyond the abstract level (about 28 sources, abstracts only; four at full text per it1-refs); none is decisive for a measured result of the chapter and each is worded at the level read.
- Whether the sweep's own draws include the cap-exceeding allocations (M17).
- docs/ and book/_freeze/ against a fresh render; no render was run (the R/chapter agents say the same).
- 91/92 appendices and 90 wording (owed).
