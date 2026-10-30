# 03-simulating-crosses -- chapter audit, iteration 1

Scope: book/03-simulating-crosses.qmd (259 lines), book/_common.R, R/00_data.R
(simulate_lines, molecular_coancestry, vanraden_G, simulate_data, build_ctx), R/10_stage1.R
(stage1_simulate, stage1_build), R/01_metrics.R gene_diversity; frozen outputs
book/_freeze/03-simulating-crosses/execute-results/html.json. Verification script: session
scratchpad a03.R (pkgload::load_all on the worktree). Every frozen output reproduced exactly
(table of L, fst sweep table, cor(traits), sum_G = -4.18e-11, f range 0.64475..0.83175,
str(ctx), GD 0.3280928 / 0.3259023 / 0.6677 %).

Verified TRUE: Beta(p(1-F)/F, q(1-F)/F) has mean p, variance F p q (:46-47; 1e6 draws: 0.29993,
0.031530 vs 0.0315); lines only 0/2 (:63); het_fraction = 1 - mean fL[A,B] equals the
directly counted A x B heterozygous fraction to all digits (:83-85, :104); closed-form
E[het] = mean(2 p_anc q_anc) = 0.364 for every fst (the seed fixes p_anc across the grid);
within-pool Nei D gain 0.1465 vs within-pool GD loss 0.139 over the grid (":101 unit for
unit", holds in expectation); f == tcrossprod(cbind(X, 1 - X))/m; chapter ctx identical to
simulate_data(book_cfg) and to stage1_simulate (traits all.equal ignoring attributes, f
identical) -- so ":193 All of the above is stage1_simulate()" holds; population GD above all
400 random-subset GDs (:242-244), and mean(gd_random) 0.32590 vs closed form
1 - (mean diag f / 60 + (1 - 1/60) mean offdiag f) = 0.32587; fst ratio 0.40/0.02 = 20
(":99 twentyfold").

## Findings

| ID | Severity | file:line | Problem | Evidence |
|---|---|---|---|---|
| 03-R1 | high | book/03-simulating-crosses.qmd:43-48, :90 | The Balding-Nichols parameter is written $F_{ST}$ and the prose asserts "the parameter `fst` *is* the expected between-pool divergence -- it is not a proxy for it". Both contradict book/90-notation.qmd:126-137 and :441-445: the parameter is $F_{BN}$, the divergence of *each* pool from the ancestral frequency, and the $F_{ST}$ statistic between the two pools estimates ~$F_{BN}/(2 - F_{BN})$, not $F_{BN}$. Between pools, Var(p_A - p_B) = 2 F_BN p q. The notation chapter's "read it there as F_BN" disclaimer cannot rescue the explicit "is ... not a proxy" sentence, which is false. Rewrite the display and :47-48 with $F_{BN}$ (each pool vs the ancestor), and relabel the axis `expression(F[BN])`. | 90-notation.qmd:127-137 (stopifnot there checks fst_off ~ fst_bn/(2 - fst_bn)); Beta moments verified above. |
| 03-R2 | medium | book/03-simulating-crosses.qmd:148-151 | "The realised trait correlations recover the target `R`" -- they do not: realised 0.259 / -0.440 / 0.049 vs target 0.3 / -0.3 / 0.1. With 625 hybrids from 50 lines, Z has rank 48, so the trait correlation is estimated on ~48 effective dimensions: over 300 effect draws on the same Z, sd ~0.145 per entry, 95% band for r13 (-0.545, 0.010). The target is recovered only in expectation over effect draws (means 0.293 / -0.294 / 0.105). State that, and print the expectation or the rank. | a03.R: qr(vr$Z)$rank = 48; spread table. |
| 03-R3 | medium | book/03-simulating-crosses.qmd (whole chapter) | Check 3: no `stopifnot()` anywhere. Identities asserted in prose and unchecked: Beta mean/variance :46-47; only 0/2 genotypes :63 (printed table only); het fraction flat :99 / caption :74 (should assert against the closed form mean(2 p q) with a tolerance, since the realised column moves by 0.0096); het_fraction == 1 - theta_AB :104; sum(G) == 0 and f in [0, 1] :177-178 (printed only); f == tcrossprod(cbind(X, 1 - X))/m (not shown at all, the defining identity of @sec-coancestry); coding invariance :223-224 (printed TRUE); population GD above random subsets :242-244. All hold (header). | a03.R. |
| 03-R4 | medium | book/03-simulating-crosses.qmd:235 | Check 2: the draw `replicate(400, gene_diversity(sample.int(ctx$N, 60), ctx))` has no `set.seed()` before it. Its stream is inherited implicitly from the `set.seed(cfg$seed)` / `set.seed(cfg$seed + 99)` buried inside `stage1_simulate()` at :200, so the figure and the 0.6677 % at :250 move if stage1_simulate's internal draws change or the chunk at :200 is removed. Add `set.seed()` immediately before :235. (All other draws are seeded: simulate_lines reseeds itself; :138 seeds the effects.) | R/00_data.R:39, :121; chapter :200. |
| 03-R5 | low | book/03-simulating-crosses.qmd:84, :100-101 | `within_pool_f = mean(c(fL[A, A], fL[B, B]))` includes the diagonal (self-coancestry 1 of an inbred line, weight 1/25), so it is the group coancestry, not the between-line within-pool coancestry the prose compares with between_pool_f: biased up by ~0.013 (0.6564 vs off-diagonal 0.6421 at fst = 0.02). The "unit for unit" trade (:101) is a statement about off-diagonal terms (Nei D gain 0.1465 vs within GD loss 0.139). Use off-diagonal means or say "group coancestry". | a03.R res table. |
| 03-R6 | low | book/03-simulating-crosses.qmd:74, :89-91 | The figure caption says "What moves is the within-pool coancestry, which climbs throughout", but the plot draws only het_fraction; within_pool_f appears only in the table at :96. Either add the second series or move the sentence out of the caption. Also :99 "does not move" -- the realised column ranges 0.3630-0.3726 against an expectation of 0.364; say "flat within sampling noise". | frozen table; a03.R het_exp. |
| 03-R7 | low | book/03-simulating-crosses.qmd:99, :113-114, :230/:236 | Check 1: hand-typed numbers. "twentyfold" (= max/min of fst_grid), "25 lines ... 625 candidates", "71 per pool ... 5041", "random subsets of 60" in the caption (hard-coded 60 in two places in the chunk, not a variable). All correct today; make them inline `r` from book_cfg / fst_grid / a single `n_sub <- 60`. | qmd text; values recomputed. |
| 03-R8 | low | book/03-simulating-crosses.qmd:193-197 | Prose says "All of the above is `stage1_simulate()`" and then prints the source of `stage1_build`, which shows none of "the above" (lines, factorial, effects). Print `stage1_simulate` and `simulate_data` (the function that actually contains the steps), or reword. | R/10_stage1.R:23-26; R/00_data.R:111-138. |
| 03-R9 | low | book/03-simulating-crosses.qmd:217-225; R/10_stage1.R:51 | The coding-invariance demo cannot fail: `st1$X * 2` divided back by 2 is exact in floating point (identical TRUE by construction). The detection rule `max(X) > 1` that it is meant to exercise silently misreads a 0/1/2 matrix with no dosage-2 call as 0/0.5/1 (a03.R: 2 x 2 matrix of 0/1 returned unchanged, max 1), and returns NA/errors on any NA. Package-level; the chapter should not call the rule verified. | a03.R "detect" line. |
| 03-R10 | low | book/03-simulating-crosses.qmd:186-189 | "recomputing it per scenario ... -- the single most common error in applying these metrics" is an unsourced empirical claim. Cite or soften. Also "would silently zero out": with p recomputed on the selected set F_drift relative to that set is zero by construction, so "zero out" is right for drift; F_hom is not zeroed. Narrow to F_drift. | CLAUDE.md "Two lenses"; R/00_data.R:174. |
| 03-R11 | info | book/_freeze/03-simulating-crosses/execute-results/html 2.json; .../figure-html/unnamed-chunk-5-1 2.png; docs/03-simulating-crosses_files/figure-html/unnamed-chunk-5-1 {2..10}.png | Tracked macOS duplicates (part of the 64; removal is a deliberate `git rm`). Untracked in the worktree: docs/03-simulating-crosses 7.html, unnamed-chunk-5-1 11.png, 12.png (sweepable). The two figure chunks (:73, :229) are unlabelled; any chunk added above them renumbers unnamed-chunk-5-1 / unnamed-chunk-15-1 -- labelling them is the cheap guard. | git ls-files; git status. |

## Checks with no finding

1. All prose numbers other than 03-R7 are absent (the chapter states no numeric results in prose; results appear only as chunk output). 
2. Seeds: simulate_lines reseeds with cfg$seed (R/00_data.R:39), :138 seeds the effect draw; no AlphaSimR call. Only gap is 03-R4.
4. Data sources: reads nothing from disk; no report/, data/, reference/.
5. All called functions (simulate_lines, molecular_coancestry, vanraden_G, build_ctx, stage1_simulate, stage1_build, gene_diversity) are exported and present in the installed hybdiv 0.1.0. Frozen outputs match a fresh load_all run exactly, so no reinstall is needed for this chapter.
6. No chunk changes in this iteration. docs/03-simulating-crosses.html references exactly unnamed-chunk-5-1.png and unnamed-chunk-15-1.png; nothing currently orphaned beyond the duplicates in 03-R11. Fixes for 03-R3/03-R4 add or alter chunks *after* the first figure (fine for 5-1) but any chunk inserted before :229 renumbers unnamed-chunk-15-1 in both docs/03-simulating-crosses_files/figure-html/ and book/_freeze/03-simulating-crosses/figure-{html,typst}/ -- label the figures first. Listed in book/_quarto.yml:27; book/downloads/03-simulating-crosses.R exists (regenerate with make_downloads.R after edits).
