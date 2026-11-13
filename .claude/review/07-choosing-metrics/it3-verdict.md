# 07-choosing-metrics -- verdict, iteration 3

VERDICT: APPROVED

PREVIOUS IDS (re-review only)
- 07-D13 -- CLOSED -- both error kinds now run (`kind` column, 20 seeds each) and declared in the Assumptions paragraph (07:653-657); "alpha moves little with accuracy" is scoped to correlated error (07:744-745); the yardstick is the s.e. of the paired r = 1 minus r = 0.5 difference, run at those two accuracies only and said so (07:764-769). My recomputation (own script, ctx as _common.R, B = 400, seeds 1-20) reproduces the text.
- 07-D14 -- CLOSED -- limit (b) now names the uncapped rows, 3 seeds, sd and s.e. of the difference, declares the production difference unresolved, reports the capped rows (the setting of Finding 4) and the benchmark's own caps (5, 4 vs 6); the recommendation sentence (07:908-912) is scoped to "only without a cap and at one of two scales (3 seeds)". All numbers reproduced from search_benchmark.csv.
- 07-M11 -- CLOSED -- 06:465 now says the setting is not recorded and reads 12,000 as 2m, m = 6,000 (inference); consistent with 07:345.
- 07-M12 -- CLOSED -- realised accuracy: "does not differ reliably"; difference -0.011 (s.e. 0.0088) and the spread are reported; the claim moved to the spread.
- 07-M13 -- CLOSED -- 28 distinct greedy selections of 30 weights, caption and text count distinct selections; band 62; the 1.83 vs cached comparison is declared non-comparable.
- 07-M14 -- CLOSED -- "about 5 seconds per million", one significant figure, matches the ~1 us timer resolution.
- 07-M15 -- CLOSED -- the 3-seed sd is now in limit (b).
- 07-M16 -- CLOSED -- table row reads "not ordered against the swap (Finding 2)".

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS (two; the threshold for rejection is three)
- 07-M17 book/07-choosing-metrics.qmd:~606-618 (limit b) -- the capped rows are called "tie" and the text concludes "with a cap it shows no difference". At the book scale de_hybrid_cap = 1.1097 and de_lines_cap = 1.1056 in all 3 seeds (sd 0 in both): a constant gap of 0.0041, not zero. The printed numbers are correct and the substantive conclusion (the benchmark does not support "sel_de() ahead" under a cap) stands, but "no difference" is wrong as worded at the book scale (it is exact only at production scale, 1.1223 = 1.1223). Also, de_hybrid_cap is bitwise identical to tempering_cap and de_lines_cap to ocs_round_cap in every seed (book) and all four are identical at production; with sd 0 the s.e. yardstick used for the uncapped rows does not exist. The text says why the seeds agree was not examined, which circumscribes it.
- 07-M18 book/07-choosing-metrics.qmd:~758-775 -- under independent error and r = 0.5 greedy alpha is negative (-0.66%, in the table; my run: -0.0066), i.e. the greedy plan is more diverse than the random baseline; the response admits it is not discussed in prose. The "closer to random selection" reading is offered (and labelled untested) for truncation only, so no claim is false, but the table's sign flip is left unexplained.

WHAT WAS VERIFIED
- Truncation alpha by accuracy and error kind (own script, scratchpad it3.R, ctx = fast_ctx(simulate_data(book_cfg)), null B = 400 seed 7, seeds 1-20): correlated 4.12 / 4.16 / 3.96 / 3.79 % at r = 1 / 0.9 / 0.7 / 0.5; independent 4.12 / 3.38 / 1.83 / 0.75 %. Matches the response and my it2 numbers.
- Paired r = 1 minus r = 0.5, truncation: correlated mean 0.335 pp, s.e. 0.115, 2.9 s.e., positive 16/20, 8% of the r = 1 loss; independent 3.375 pp, s.e. 0.072, 47 s.e., positive 20/20. Matches (0.33 / 0.11 / 2.9 / 16; 3.38 / 0.07 / 47 / 20).
- Realised index and r_real (seeds 1-20): truncation realised 1.99 (r = 1) falls to 0.92 (correlated) / 1.00 (independent) at r = 0.5, so "accuracy worth tens of percent" holds; r_real 0.449 / 0.498; greedy alpha independent r = 0.5 = -0.0066 (M18).
- search_benchmark.csv, n = 3 per cell: uncapped book de_hybrid 1.3598 (sd 0.018) vs de_lines 1.0594 (sd 0.015), diff 0.300, s.e. 0.0135; production 1.4460 (0.018) vs 1.3357 (0.067), diff 0.110, s.e. 0.040 (2.7 s.e. on 3 seeds, correctly "not resolved"). Capped: book 1.1097 vs 1.1056, production 1.1223 vs 1.1223, sd 0 in all four capped cells (M17).
- Greedy grid seed 77: 28 distinct selections of 30 weights, band 62 selections, Ne_par ratio 1.83.
- Chapter code purls and the dependent chunks execute against the worktree package (pkgload); live chunks use the same code I recomputed.
- Inbound text read: 06:465 (consistent with 07:345), 08b:729-740 and 02b:913 (consistent with the scoped Finding 5; neither states "alpha moves little").
- Previous-iteration verifications (it2) of Findings 1-4, redundancy table, cost arithmetic, de_constraints.csv, citations are unchanged text and stay as in it2.

NOT VERIFIED
- Cached external files (cost, identity sweep, redundancy, DE constraints): no producer in the repository; only arithmetic on stored values (declared as such in the chapter).
- Quarto render, freeze/docs state (declared stale by the author); cross-references checked by grep only in it2.
- Whole-suite `devtools::test()`: not run by me in this iteration.
- Later-chapter inbound claims owed by 08, 09, 10, 10b, 11, 12, 04b: not judged here.
- Why capped benchmark arms are seed-invariant and identical across methods: not examined by the author nor by me; declared in the text, not decisive for the chapter's claims after scoping.
