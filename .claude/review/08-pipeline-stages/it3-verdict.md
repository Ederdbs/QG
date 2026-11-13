# 08-pipeline-stages -- verdict, iteration 3

Chapter: book/08-pipeline-stages.qmd. Read: it2-verdict, it2-response, the chapter passages changed (Trap 3, formula (c) and its chunk, ledger/e2e paragraph), the diffs against origin/main of R/05_pipeline_metrics.R, tests/testthat/test-stage-metrics.R, book/05b (~786), book/12 (~187), book/00 (~327), book/10 (~36), and book/03 (new target of the cross-reference). No refcheck or continuity report supplied for iteration 3. Scratch scripts in /private/tmp/claude-501/scr (untracked).

VERDICT: APPROVED

## PREVIOUS IDS
- 08-D11 -- CLOSED -- the invented quotation is gone from 05b:786-791. The paragraph now attributes to Trap 3 what the rewritten Trap 3 (08:199-282) contains: mean_sq_delta_p = 2 F_ST GD_T for equal pool sizes (asserted in the chunk), no decoupling from F_ST, expected heterosis as what decouples (pointing to 05b), hold F_ST in a band. No residual quotation: checked 05b:735-800 and the "Reading the S1 panel" pointer (05b:911 exists; "half of it is GD_BS" agrees with msdp = 2 GD_BS). One wording residue is recorded as 08-M12 (not disqualifying).
- 08-M8 -- CLOSED -- dh_pool_theta() now uses sum(n_per/D * (1 + f_c)/2), which is formula (c) of 08:319-330. Derivation checked by hand: replacing the D diagonal pairs, each valued Fbar_cc = (1 + f_c)/2 inside w'fLw, by 1 gives (1/D^2) sum_c n_c (1 - (1 + f_c)/2) = (1/D)(1 - sum_c (n_c/D)(1 + f_c)/2). Verified numerically against the literal pair-by-pair oracle for unequal n_c (see below). Roxygen states the weights. The chapter's claim "(c) asserted against the literal pair-by-pair average" is made for its equal n_c = 40 and stays true; the general case is covered by the package test. No printed value in 08 moves (theta_c = oracle = 0.701091 before and after).
- 08-M9 -- CLOSED -- 08:803-806 now describes the end-to-end change as from the S2 GD_before (a same-size baseline whose set the file does not record, not the GD of the 120 founder lines) to the S4 GD_after; consistent with 08:717-730. Values 13.069 % / 10.729 % reproduced by me.
- 08-M10 -- CLOSED -- the roxygen of hybrid_theta_from_usage (R/05_pipeline_metrics.R:447-452) no longer claims "cost drops from O(n^2) to O(L^2)"; it states an asymptotic ratio and that the line route measured slower at N = 2500, n = 50. grep "cost drops" over R/, man/ and book/*.qmd: no hit. (The location was R/05, not R/04 as my it2 note said; the R/04 diff is the separate decode_lines roxygen, also reduced to what was measured.)
- 08-M11 -- not content; render batch still pending (see NOT VERIFIED).
- All previous D1-D10, M1-M7: not reopened; the text they cover did not change (diff of the sections checked: only the M9 sentence and (c)-adjacent text).

## DISQUALIFYING FAILURES
None.

Walk of the criteria on the changed text and its dependents:
- 12:187-192 (reworded): "found, in 8 cached founder pools, that a diversity term on cross choice at S2 lowered the S2 loss and raised the S3 and S4 losses, and could not say whether it improved N_e or alleles retained" matches 08's paired table (S2 lower 8/8; S3, S4 higher 8/8; N_e and alleles intervals contain no change). No quotation, no result beyond 08.
- 00:327-331 (reworded, chapter already approved): "cross selection on the usefulness criterion alone" and "the three stages carry similar shares" match 08:717-722 (UC only = usefulness criterion, including progeny s.d.) and the shares 35.5/29.0/35.5; "similar" is loose for 29.0 vs 35.5 but is qualified in the same sentence as the simulation's result at its scale. 00:576-582 ($F_{ST}$ = GD_BS/GD_T; $F^{btw}_{ST}$ separate) agrees with 08's definitions. Chapter 00 stays consistent.
- 10:36 now points to @sec-simulating-crosses, whose "What has to be produced" section (03-simulating-crosses.qmd:54-76, @tbl-stage1-contract) lists X, f, hybrids and optional fL with the shapes and uses that 10 repeats (X N x m in {0, 0.5, 1}; f N x N; hybrids with parents and traits). The target holds the contract; 08 does not.
- 05b:524 "its SA9" matches 04-population-sizing.qmd:55, 227 (SA1 to SA9).
- Formula (c) and dh_pool_theta: correct for equal and unequal n_c, assumptions of (a)-(c) (per-locus 1/2 marginal, inbred parents, f_c from fL) declared at 08:312-316; the self-pair of a DH line is 1 as the chapter states.

## NON-DISQUALIFYING OBSERVATIONS
- 08-M12 book/05b-heterosis-dominance.qmd:786-791 -- "That section shows that ... what does decouple from [F_ST] is expected heterosis, and that F_ST should be held in a band": Trap 3 states the second and third points and says the first is "not in this chunk"; only the mean_sq_delta_p identity is shown there. "Shows" over-credits the chapter for two statements it makes by pointing to 05b, and "@tbl-het-sweep ... are that evidence" then makes the support circular in wording. The content is the same on both sides, so not a failed attribution; wording only.
- 08-M11 -- docs/ and book/_freeze/ for 00, 05, 05b, 08, 10, 12, 90 stale until the render batch; orphaned unnamed-chunk figures. Process, not content.
- Two non-disqualifying observations in total: below the threshold of three.

## WHAT WAS VERIFIED
- Unequal n_c against the literal oracle -- /private/tmp/claude-501/scr/dh.R, simulate_pools(30, 30, 3000, 0.15, seed = 12), crosses drawn with set.seed(s), s in {1, 2, 3, 88, 5} (6 crosses each, self-pairs removed), n_c in {(5,40,10,80,20,60), (1,...,1), (100,3,3,3,3,3), 40 recycled}; oracle = mean of the D x D matrix of mean(fL[parents_c, parents_c']) with the diagonal set to 1. Differences dh_pool_theta - oracle: all within 4e-15 (e.g. 3e-15, -1e-16, 5.6e-16, -4.4e-16 for s = 1; -2.1e-15 for s = 2 with (100,3,...)). Max abs 3.6e-15.
- Tests -- devtools::test(filter = "stage-metrics"): FAIL 0, WARN 0, SKIP 0, PASS 41. I read the new test "dh_pool_theta weights the self-coancestry correction by n_c / D": it uses unequal n_c (5,40,10,80,20,60), tolerance 1e-12, an independent oracle, plus the equal-n_c case; it would fail on the unweighted code (the it2 difference of ~1e-5 on the verdict's world is far above 1e-12).
- Whole chapter -- purl of 08-pipeline-stages.qmd run in book/ against load_all of the worktree: no error, every stopifnot passes; theta_c = theta_oracle = 0.701091; e2e = 13.069 (UC only), 10.729 (UC + div), as printed in the text.
- Callers of dh_pool_theta: R/05, the chapter chunk (n_per = 40, equal), test file, 91-package.qmd (listing only). No other numeric consumer, so the weighting change moves no other number.
- Trap 3 identity and claims in 05b:786-791 read against 08:199-282; cross-reference targets (@sec-simulating-crosses, @tbl-stage1-contract, "Reading the S1 panel") exist.
- Roxygen in R/05 and R/04 matches the code; no "cost drops" left.

## NOT VERIFIED
- Quarto render of 00, 05b, 08, 10, 12 and the Typst output -- no render run; non-decisive (form/process).
- Kadoumi et al. (2025) beyond the abstract; the ledger's generating process -- as in iteration 2, declared by the chapter as not checkable here; non-decisive.
