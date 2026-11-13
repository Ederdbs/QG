# 07-choosing-metrics -- response to iteration 2 (content fix)

Files: book/07-choosing-metrics.qmd, book/06-metric-catalogue.qmd (one sentence, 06:465),
regenerated book/downloads/*.R. R/ untouched. Chapter knitted end to end with knitr (rc 0, all stopifnot pass).
Not rendered with Quarto; docs/ and _freeze/ stay stale until the render batch.

| ID | Status | What was done |
|---|---|---|
| 07-D13 | fixed | `run()` now takes `kind` and the accuracy table (chunk f5-accuracy) runs BOTH kinds, 20 seeds each, with a `kind` column; Assumptions paragraph says both are run and that `predicted()` defaults to correlated. Truncation alpha inline: correlated 4.12/4.16/3.96/3.79 %, independent 4.12/3.38/1.83/0.75 % at r = 1/0.9/0.7/0.5 (matches the verdict). "alpha moves little with accuracy" scoped to correlated error. Yardstick fixed: paired r = 1 minus r = 0.5 within seed, truncation: correlated 0.33 pp, s.e. 0.11, 2.9 s.e., positive 16/20 (small, 8 % of the r = 1 loss, not nil); independent 3.38 pp, s.e. 0.07, 47 s.e., 20/20. Monotone counts by kind: truncation 4 and 20, greedy 10 and 20. The seed-sd-vs-difference sentence is removed. Heading "matters more than the amount" -> "of the error matters" (under independent error the amount matters). The paired contrast was run at r = 1 vs 0.5 only, stated. |
| 07-D14 | fixed | Limit (b) rewritten with inline numbers from search_benchmark.csv: uncapped rows named uncapped, 3 seeds per cell, sd and s.e. of the difference given: book 1.360 (sd 0.018) vs 1.059 (sd 0.015), diff 0.30, s.e. 0.013; production 1.446 (0.018) vs 1.336 (0.067), diff 0.11, s.e. 0.04, declared unresolved. Capped rows (the setting of Finding 4): 1.1097 vs 1.1056 book, 1.1223 vs 1.1223 production, sd 0 in every capped cell (cause not examined, said so). Benchmark's own caps (5 and 4, N, L, n) stated against Finding 4's cap of 6. The recommendation sentence ("Which search to run...") scoped to "uncapped and at one of two scales, tied under a cap". R/12 roxygen not touched (the verdict found it correct for uncapped rows). |
| 07-M11 | fixed | 06:465 "built at 12000 markers (@sec-choosing)" -> setting not recorded, 12,000 alleles read as 2m with m = 6,000 (inference). |
| 07-M12 | fixed | Realised accuracy: means 0.59 vs 0.60, paired difference -0.011, s.e. 0.0088, positive 25/60 -> "does not differ reliably"; what differs is the spread (sd 0.069 vs 0.017, ranges). Assumptions paragraph no longer says the realised correlation "differs between the two kinds". |
| 07-M13 | fixed | Greedy grid deduplicated by selection (`duplicated()` on sorted selections): 28 distinct of 30 weights, inline; caption no longer says 30 selections; band count (62) is now of distinct selections (unchanged: the duplicates fell outside the band). The 1.83 vs 1.85 comparison now says the two analyses differ in mix, size and number of selections and are not comparable. |
| 07-M14 | fixed | "5.0 seconds per million" -> "about 5 seconds per million (timings are multiples of about 1 us, one significant figure)". |
| 07-M15 | fixed (with D14) | The 3-seed sd is now in limit (b). |
| 07-M16 | fixed | Recommendation-table row for Ne_par: "not ordered against the swap (Finding 2)" instead of "the same order". |

Runs: the chapter knitted three times (after the D14/D13 edits, after the grid/M edits, after the final sentence); the accuracy table is deterministic in its seeds 1-20 and reproduced the verdict's numbers on the first run. No seed, parameter or metric changed. Unfavourable results reported in the text: correlated paired difference is 2.9 s.e. (not nil); greedy alpha under independent error at r = 0.5 is negative (-0.66 %, in the table; not discussed in prose).
Verdict's "NOT VERIFIED" items (cached external files, Quarto render) unchanged.
