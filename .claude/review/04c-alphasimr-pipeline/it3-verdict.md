# 04c-alphasimr-pipeline -- iteration 3 verdict (head of department)

Scope: form pass (editor.md, editor-response.md) and M12/M13 only, judged by reading each edit (no it2 snapshot in git).

VERDICT: REJECTED

## PREVIOUS IDS
- 04c-M12 -- CLOSED -- 04c:1626-1627, 1718-1734. Multiplicity declared: 7 tests (2 contrasts of tbl-alphasimr-contrast + GCA_var_dom contrast + covariance term at 4 splits), computed from `t_sweep`, not typed. Recomputed (purl run, wd book/): n_tests_sweep = 7, qt(1 - 0.05/14, 19) = 3.013625 -> "3.01" correct; 2.093 unadjusted. t_sweep = 5.72, -5.49, -0.49, 0.52, 1.79, 2.30, 1.99: 2 beyond Bonferroni, 3 beyond 2.09 in my run (counts are inline, render-dependent, wording conditional). "Conservative" removed; permissive/strict wording right. Exploratory applied consistently: ascertainment bookkeeping, gca_only(), F_ST/GD_BS/GD_T movements declared descriptive/untested/exploratory; 2097 and 2137 consistent with it. The two Step-8 families (11 tests paired, 7 sweep) are distinct and each declared.
- 04c-M13 -- CLOSED -- cap_pipeline (l.42-43) now says the call uses replicate 1's seed and that return of the same founders was not established; matches l.2174-2178 and Step 1.
- Form pass: E1, E2 (acronyms), E3 (labels: 7 `alphasimr-*` labels present, no figure renamed), E5 (no "N %" left in prose; only a code comment `5%`), E7 (no "a later chapter"/"earlier chapters" left) verified by grep. No number, claim or scope changed beyond M12/M13 wording and E4.
- 04c-E6 (contested) -- RULING: contest ACCEPTED. Code-name headers with units in captions is the book's convention; renaming would break `fmt()` indexing. Non-disqualifying; closed.
- 04c-E4 -- cross-references RESOLVE in 02-subdivided: @eq-gd-partition (l.434), @tbl-gd-partition (l.437), @eq-ratio-identities (l.461, GD_BS/GD_T = F_ST), @eq-f-stats (l.350-352), and the "other F_ST" referenced to between-population coancestry is in 02:408 (so the disclaimer is true). Use in 04c (partition not re-derived, F_ST = GD_BS/GD_T) is what those labels say. BUT see D9.

## DISQUALIFYING FAILURES
- 04c-D9 [criterion 1/5] book/04c-alphasimr-pipeline.qmd:1482-1483 (new E4 text, "What `split` does") -- "$\bar f$ the mean molecular coancestry over all pairs of the pooled hybrids" names the wrong object. The `split_draw()` chunk (l.1513-1519) computes `ct_partition(pullSegSiteGeno(c(pop_A, pop_B)), pool)` on the founder INDIVIDUALS of the two pools (`alphasimr_founder_pools()` returns `newPop(founders)` split in two; R/13), not on hybrids; the cycle chunk (l.1869) likewise partitions the recombined-pool individuals. The partition over hybrids (parent-line slots, usage weights, `gd_partition()`) is the other route of 02-subdivided:1040-1050, and the chapter itself says here the partition is `ct_partition()`, "the general form of `gd_partition()`". GD_WI as "half the observed heterozygosity of a plant" is correct for founders, which makes "hybrids" internally inconsistent in the same paragraph. The sentence is the new inline definition added to fix E4, and it defines the quantity the formula does not compute. Fixing is the author's.

## NON-DISQUALIFYING OBSERVATIONS
- 04c-M10 -- carried unchanged (unverified secondary sources, each scoped in the text); not touched by this pass.
- 04c-E6 -- units only in captions (accepted above).

## WHAT WAS VERIFIED
- purl of book/04c-alphasimr-pipeline.qmd run in book/ (wd for _common.R): 118 s, exit clean, all 24 stopifnot passed, END_OK reached (output in scratchpad it3/out.txt). book/Rplots.pdf produced by the run removed.
- n_tests_sweep = 7; t_bonf_sweep = 3.013625; cov_t_crit = 2.093024; 2 of 7 beyond Bonferroni, 3 beyond unadjusted in this run.
- Cross-reference targets in 02-subdivided exist (lines above).
- `grep` for "N %", "a later chapter", BLUP/QTL first-use expansions, chunk labels.

## NOT VERIFIED
- The Quarto render (docs/, _freeze stale per M17); inline values read from the purl run, not from a render.
