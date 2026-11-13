# 07-choosing-metrics -- verdict, iteration 4 (form-pass diff)

VERDICT: APPROVED

PREVIOUS IDS (re-review only)
- 07-M17 -- CLOSED -- limit (b) now reports means 1.1097 vs 1.1056 (difference 0.0041, sd 0 in every capped cell, "no standard error exists to judge it by") at the book scale and 1.1223 vs 1.1223 (difference 0) at production; "no difference" replaced by "an unjudged gap of 0.0041 at the book scale and none at the production scale". Numbers reproduced from book/data/search_benchmark.csv (de_hybrid_cap 1.10972, de_lines_cap 1.10559, production both 1.12233, sd 0 in all four). The recommendation sentence (07:955-957) matches and points to limit (b).
- 07-M18 -- CLOSED -- the sign flip of greedy alpha under independent error is now stated (1.33% at r = 1 to -0.66% at r = 0.5, s.e. 0.03 pp, monotone in 20/20 seeds, correlated error stays positive at 0.92%), the truncation reading is said not to account for a value below random, and the greedy-penalises-theta reading is marked "not tested here". All numbers recomputed (below).
- 07-E1..E10 (editor items) -- not re-judged as findings; only the wording changes they produced were read for content (list items 1-17 of editor-response.md): no claim or number changed except the M17/M18 ones.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS (two; the threshold for rejection is three)
- 07-M19 book/07-choosing-metrics.qmd:898 and :904 (callout "The worst case is not the noisiest one") -- the inline expressions `acc$alpha[acc$method == "truncation" & acc$r == 1]` and `acc$realised[...]` were not updated when the accuracy table gained the `kind` column: at r = 1 there are two rows (correlated, independent), so the knitted text reads "loses 4.12, 4.12% of gene diversity" and "of the 1.99, 1.99 a perfect index delivers". The two values are identical (the prediction is the truth at r = 1), so no number is wrong, but the sentence prints a duplicate in the published prose. Seen in my knit of the chapter (07.md lines 907-908 and 914).
- 07-M20 book/07-choosing-metrics.qmd:714 (tbl-choosing-accuracy caption) -- "with the standard error over seeds (s.e.)" does not say that only realised and alpha carry an s.e. column (reported and r_real do not). Minor.

WHAT WAS VERIFIED
- M18 numbers: own script (scratchpad it4.R; pkgload of the worktree; ctx = fast_ctx(simulate_data(book_cfg)), null_distribution B = 400, B_full = 60, seeds 1-20, predicted() as in the chapter). Greedy (w = 3e-4) alpha in %, independent error: 1.334 (r = 1), 0.222 (0.9), -0.348 (0.7), -0.664 (0.5), s.e. 0.028 at r = 0.5; all 20 seeds negative at r = 0.5 (range -0.0091 to -0.0045); monotone non-decreasing in r in 20/20 seeds. Correlated error: 1.334 / 1.143 / 1.024 / 0.919 (monotone in 10/20). Truncation: independent 4.122 / 3.379 / 1.831 / 0.747, correlated 4.122 / 4.164 / 3.959 / 3.787. Chapter's knit prints 1.33, -0.66, s.e. 0.03, 20 of 20, 0.92: identical.
- Logic of M18: truncation reading (noisy selection tends to random, alpha tends to 0) cannot give alpha < 0; the text says so and labels the greedy-penalty reading untested. Correct as scoped.
- Chapter knits end to end (knitr, root book/, output in scratchpad k4/07.md); inline values of limit (b) print 1.1097 / 1.1056 / 0.0041 / 1.1223 / 1.1223 / 0 / sd 0.
- tbl-choosing-live-cost caption vs cost_per_eval(): reps x4 until >= 0.2 s (R/02_benchmark.R:81-93), seed = 1 selection of n = 60, ctx$N = 625, rounded to 1 decimal; run gives 8 rows (theta_group 9.0 us ... Gst 2043.7 us), caption claims hold. (The R change is in the worktree, uncommitted; the caption depends on it.)
- tbl-choosing-accuracy and tbl-choosing-kinds captions vs chunk code: n, N, w = 3e-4, B = 400, 20 and 60 seeds, column definitions (reported, realised, r_real, max_line, paired_difference, se, n_positive) match; s.e. is zero at r = 1 (alpha identical across kinds at r = 1: TRUE).
- First-table gloss: eq-catalogue-ene-ane (06:370-372) defines E-NE as mean over S of nearest other selected entry and A-NE as mean over all N of nearest selected entry; "nearest-entry distances" is accurate.
- T rename: no remaining `\mathbf{L}` in 07 or 90 (grep); `\mathbf{T}` appears only in 07:679-680 and 90:285, 297; elsewhere in the book `T` is non-bold (05b:1074 set of testers; 02:889 generations; H_T/GD_T subscripts; 10b uses lowercase t_k for temperature) -- no clash. Code variable `Lc` unchanged, as declared. sd(ctx$index) = 1, so "r is the weight of u" in the 90 row is exact.
- 90-notation additions: `\bar{\mathbf p} = w'G^L` consistent with 07:111 (G^L coded 0/1, w sums to 1); `\mathbf k`, sum k_a = 2n consistent with w_a = k_a/(2n); e, z, T row consistent with the chapter's predicted(); r row "nominal accuracy" consistent with 07.
- Every @sec-/@tbl-/@fig-/@eq- reference in 07 and 90 resolves to a label in book/*.qmd (grep loop; no MISSING).

NOT VERIFIED
- Quarto render / Typst width (editor item 07-E8, deferred by the author): no render run; table overflow in the PDF unknown. Non-decisive.
- Cached external files (cost, identity sweep, redundancy, DE constraints): no producer in the repository, as declared in the chapter.
- Why the capped benchmark arms are seed-invariant and identical across methods: not examined (declared in the text).
- Whole-suite devtools::test() not run.
- Side effect of mine, disclosed: I ran `Rscript book/scripts/make_downloads.R` once; the list of modified tracked files did not change, and the knit's stray book/figure/ directory was removed.
