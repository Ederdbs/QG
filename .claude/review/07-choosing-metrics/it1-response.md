# 07-choosing-metrics -- response to iteration 1 (quant-Rwrite-prose pass)

Chapter: book/07-choosing-metrics.qmd. Also touched: book/02-subdivided.qmd (the sentence at 02:988-992),
book/06-metric-catalogue.qmd (06:316-319), regenerated book/downloads/{02,06,07}-*.R. R/ untouched.
Whole chapter knitted end to end with knitr (rc 0, every stopifnot passes). No Quarto render, no freeze update:
07, 06 and 02 are stale in docs/ and book/_freeze/ until the render batch.

## Disqualifying and non-disqualifying IDs

| ID | Status | What was done |
|---|---|---|
| 07-D1 | fixed | Every Finding-2 number is now inline from cost_per_eval.csv: swap 5 us = 5.0 s per million; bitset = 8.4x the line route and 178x the swap (both stated, with the right denominators); 482x, 14.2 h, 5.7x, 1.47 h recomputed. |
| 07-D2 | fixed | F_ST -> F_BN (identity sweep from the file's `fst` column; redundancy caveat). |
| 07-D3 | fixed (scoped, not recomputed) | Declared in the text: eff_dim form (cache mean 1.486, read as the UNCENTRED ratio, not the package eff_dim(); claims about eff_dim restricted to that form), lens (homozygosity only, F_drift/F_hom absent), strategy mix (300/120/113/88 inline), within-strategy rho(theta, Ne_par) -0.60 random / -0.95 truncation vs -0.925 overall. I did not recompute the column with the package eff_dim(): the cache has no producer and no G^L/ctx. |
| 07-D4 | fixed | Assumptions (i)-(v) declared before the derivation; equations labelled (@eq-collapse-f, @eq-collapse-theta) with symbols, domains and the line-usage margins; "sufficient statistic" restricted to the diversity quantities, excluding GD_WI_hyb/F1 heterozygosity (pairing) and non-additive index (05b); "rank-2" replaced by four rank-1 updates (R/04 `theta_swap`); OCS statement restated with lattice, margins and realisability; limited to diversity objective + additive index. |
| 07-D5 | fixed | Accuracy table now 20 seeds with s.e.; monotone counts (4/20, 10/20) inline; alpha "falls" reworded to "moves little", mechanism marked untested; nominal vs realised accuracy reported; correlated vs independent: paired difference, s.e., n positive, over 60 seeds (not 20, see below), realised-gain difference declared not a result, block means printed. |
| 07-D6 | fixed | Finding 4 rewritten: max_use hybrid arm 5,6,6 vs cap 6 (cap reached 2/3); pool_imbalance 0 in all 9 rows (slack everywhere, so "four" bind on two at most); encoding vs decoder (cap by construction) separated; penalty/repair only in hybrid arm; neither arm sel_de(), sel_de() figures from search_benchmark.csv inline; N, L (dim column), not-recorded n/NP/itermax stated; both arms cold; NP guidance as documentation (Mullen 2011) with 36,000 vs 1,200 and generations; "5.7x" replaced by a difference (index has no zero); recommendation "reparameterise on line weights" scoped. |
| 07-D7 | fixed | Provenance paragraph naming all cached csv/png as external, no producer, never reproducible; hardware undeclared; "12,000 markers" -> 2m alleles (m = 6,000, inference); identity table: tolerance 1e-12 asserted (`stopifnot`), 2 of 10 columns without producer, comparators named, "literal transcriptions" withdrawn; live identity chunks now assert. |
| 07-D8 | fixed (withdrawn) | The 2.337 / 1.62 % / 33.2 / 17 / 85 % comparison removed; the withdrawal and why are stated in the text. No fair comparator computed (n_sel of the run unknown). |
| 07-D9 | fixed | New inline table of the residual fraction for all 10 non-copy metrics; "the one exception/metric" withdrawn; A_NE 0.556, E_NE 0.523, theta_between 0.653, n_lines_used 0.503 stated next to allelic richness 0.521; MAF loss no longer dismissed by marginal rho (0.352 ~ Ne_par 0.364); "171 markers" -> 171 alleles; the residual criterion called necessary, not sufficient. |
| 07-D10 | fixed | PC1/PC2 recomputed inline on a declared column set (16 diversity columns 87.6/6.6; without the 4 theta copies 85.4/7.5); Ne_par |rho| 0.925 printed, not ">= 0.93"; band rule |theta - median| < 0.002 stated with its realised edges; live caption no longer carries a number; live chunk now Ne_par only (says so); cost table claim "same ordering is visible" withdrawn, timer quantisation/missing line-route row stated. |
| 07-D11 | fixed | (i) New subsection on the GD/ANE contrast: A-NE/E-NE are not redundant, excluded from the loop for form and cost, offered once at validation (assembly from f^L is an inference, not implemented/timed). (ii) Drop-in code now `sel_de_fast()` (warm start, all four restrictions, NP = 10 x n_lines, seeds). |
| 07-D12 | fixed | (a) "post-2018 consistent ..." removed; replaced by "reports no consensus ... not relied on". (b) Delta f claim cited to Gomez-Romano 2016 as reported in @sec-ocs, sign-by-matrix to @sec-genomic-era. (c) E-NE/A-NE cited to De Beukelaer 2018 / Odong 2013 for the definitions; "needs the hybrid matrix" now argued from `ane()` itself, not attributed. (d) "warns" -> documentation recommendation, Mullen 2011. |
| 07-M1 | fixed | "shares the state vector" confined to make_fitness_fast(); 5 vs 7 us not an ordering (n=200 values inline). |
| 07-M2 | fixed | "Five findings"; G^L defined; equations labelled. |
| 07-M3 | fixed | H_S/H_ref -> GD_S/GD_ref; `w` as index weight defined (omega of 90) and kept apart from the usage vector. |
| 07-M4 | fixed | "benchmark scale" vs "teaching scale" defined; GiB; scales of the caches stated or declared unrecorded. |
| 07-M5 | fixed | N_s reported as a rescaling of theta, [1/2, 1], not a head count (@sec-ns). |
| 07-M6 | fixed | Fourth bullet: line vs matrix route values inline, including the case where the line route is slower. |
| 07-M7 | fixed here, circularity owed | Finding 4 declared a preview of 09/10 with terms defined; 10:455 -> Owed. |
| 07-M8 | fixed | `ctx[["f"]]` in the code; `all` -> `pts`; fig-alt strings describe the panels; "candidate pool" -> "candidate set". |
| 07-M9 | fixed | "comparable accuracy" replaced by CV2 top / CV1 bottom of the range; B = 400 vs 06's B = 2000 4.129 % stated. |
| 07-M10 | partly fixed | Nei 1973, Caballero & Toro 2002, De Beukelaer 2018, Odong 2013, Mullen 2011, Gomez-Romano 2016 now cited by key; Lacy 1989 for status number not added (06 owns that citation, which refcheck left UNVERIFIED). |

## Audit, refcheck and continuity IDs

R1 -> D9; R2, R3 -> D6; R4 -> D8; R5 -> D1; R6 -> D10; R7 -> D5; R8, R9, R10 -> D7 (R9, R10 assertions were pure code but were one line each and the prose depends on them, so done here); R11, R12 -> D3; R13 -> D10 (live timing chunk unchanged, claim withdrawn; adaptive-repetition timing needs a change in R/02, left); R14 -> M1; R15 -> D6/D11; R16 -> D11; R17, R18 -> M2; R19 -> D4; R20 -> M8; R21 -> M5; R22 -> D12b; R23 -> D2/M8; R24 -> M8: all fixed.
B1 -> D12c; B2 -> D12d; B3 -> D12a; B4 -> M10 (partial); B5 closed; B6 -> M9: fixed.
C1 -> D1; C2 -> D11; C3 -> D3; C4 -> D9 (02:990 reconciled); C5 -> D6; C6 -> D11; C7 -> M3; C8 -> M4; C9 -> D2; C10 -> D10; C11 -> M6; C12 -> D12b/M8; C13 -> D3/M5; C14 -> D4; C15 -> M9; C17 -> M7: fixed. C16: Owed, below.

## Earlier chapters edited (minimal)

- 02-subdivided.qmd:988-992 -- "survives the redundancy analysis ... as the one genuinely independent axis" -> allelic richness "is one axis independent of theta and not the only one" (E-NE, A-NE, between-pool coancestry keep as much).
- 06-metric-catalogue.qmd:316-319 -- "the metrics keeping most rank variation ... are allelic richness and Ne_par" -> the residual-fraction statement, cross-referenced to @tbl-redundancy-residual (a label that now exists in 07), no typed numbers.

## Things I changed that the verdict did not ask for (read these)

1. The live Ne_par figure's greedy grid `seq(0, 4, length.out = 30)` produced only TWO distinct selections (checked: 2 unique (theta, Ne_par) pairs); the "greedy sweep" was degenerate and a caption saying it traced a band would have been false. Replaced by `c(0, 10^seq(-5, -2, length.out = 29))`. Band at the same rule: 62 selections, Ne_par 22.9-41.9, ratio 1.83 (seed 77). The earlier 1.33 and the 55-59 counts belong to the old grid.
2. Finding 5's correlated-vs-independent comparison runs 60 seeds, not 20. First run of seeds 1-20 gave the realised paired difference -0.074; the block means over 1-20 / 21-40 / 41-60 are -0.074 / 0.002 / 0.001, i.e. the 20-seed block was an outlier. Both the 20-seed result (alpha paired diff 0.0270, s.e. 0.00097, 20/20 positive; max-line ratio 1.44) and the 60-seed one (alpha 0.0245, s.e. 0.0008, 60/60; max-line 17.33/12.98, 52/60) are in my run log; only the 60-seed one is in the text, with the block means printed.
3. Finding 5's accuracy table keeps 20 seeds (4 accuracies x 20 seeds x 2 methods), matching the audit.
4. Runs made: Finding 5 twice (seeds 1-20, then 1-60 for the comparison); the live band chunk with the old and new grid; the whole chapter 5 times with knitr. No seed, tolerance or metric was changed to make a result look right; the two changes above were made because a result was degenerate or unstable, and are reported.

## Owed (later chapters; not edited)

- 08:26-29 -- "N_s as the interpretable size, allelic richness as the one non-redundant addition": 07 now recommends Ne_par as the second constraint, N_s as a rescaling, and says allelic richness is one of several. Owner 08.
- 08b:729-745 consistent with the new wording; no action.
- 09:383-385 -- "Allelic richness, A-NE and G_st ... the same conclusion @sec-choosing reached": 07 does not mention G_st and now lists A-NE as an optional validation item, not recommended for the loop. Owner 09.
- 10:455 -- reuses "the four simultaneous restrictions of @sec-choosing"; 07 now defines them but points to 10 for the full treatment, so 10 should stop citing back for the definition (circular). 10:464-475 reproduces the same table in full; 10 owns it.
- 10b:1245 -- "@sec-catalogue's rule applies: one diversity lens ..." (06-C13): unresolved; 07's lens statement (Finding 3 scope, validation item 6) is the nearest text. Owner 10b.
- 11:23, 11:306 -- "minimal non-redundant set" / "the encoding, not the algorithm, decides": 07 now says the result is a verdict on the N-dimensional key encoding only. Owner 11. 11:247-266 "the consensus, such as it is" carries no key (B3). 12:222 echoes the encoding claim. Owner 12.
- 04b:1195 -- cites @sec-choosing for `max_use`; 07 now defines it in Finding 4 (once). Owner 04b to follow.
- 92 / index -- F_ST -> F_BN (00-C18) still open at 92:57, 92:397 and index.
- 06 (closed): 06:464 "12000 markers" -> 12,000 alleles (m = 6,000 inferred in 07); 06:458-467 `eff_dim` reading is now stated in 07 as a reading, consistent.
- R/02 (not mine): `cost_per_eval()` quantised timing and unseeded sampling (R13); `make_fitness_fast()` roxygen cites "1.988 against 0.351 ... same budget" (R/12 `sel_de_fast` docs) -- same claim 07 scoped.
- Render batch: docs/ and book/_freeze/ for 02, 06, 07 (figure chunk labelled `fig-ne-par-at-fixed-theta`, so the old unnamed-chunk-10-1 PNGs are orphaned in docs/07_files and _freeze/07).

## For quant-Rwrite

- Chunks added: redundancy-stats, tbl-redundancy-residual, fig-ne-par-at-fixed-theta, ne-par-band, f5-accuracy, f5-monotone, f5-kinds, f5-blocks.
- Not done: adaptive-repetition timing for the live cost chunk (needs R/02); no recomputation of the cached eff_dim column with the package (no producer); table cross-references inside `knitr::kable()` cells were avoided on purpose (plain text), check the first table renders; confirm `fmt(tr, 3)` under `#| tbl-cap` renders as a captioned table in Quarto (same pattern as 06).
- Not rendered by me. Spot checks to do after a render: @tbl-redundancy-residual resolves from 06, @sec-hybrid-programme, @sec-notation, @eq-collapse-f / @eq-collapse-theta, @tbl-catalogue-seeds-z.

## quant-Rwrite pass (code), iteration 1

| ID | Status | Evidence |
|---|---|---|
| 07-R13 / D10 (cost_per_eval) | fixed | R/02_benchmark.R `cost_per_eval(ctx, n_sel, reps = 30, target = 0.2, seed = 1)`: `set.seed(seed)` before `sample.int`; `reps` is the initial count, multiplied by 4 until the timed block lasts >= `target` s (same rule as `bench_us` in regenerate.R); `vapply` with FUN.VALUE. Book-scale call (ctx of 07: 12+12 lines, m = 800, n_sel = 60): 10.7 / 56.1 / 3.2 / 61.6 / 67.7 / 105.5 / 110.9 / 152.7 us -- no multiples of 25, no 0. Signature stays backward compatible (09 calls `reps = 20`). New test in test-metrics.R (metric names, all finite and > 0). 07 prose at the live cost table rewritten (seeded, adaptive, no line/swap/bitset row, wall-clock of the render machine); chunk labelled `live-cost`. Ordering across routes still not claimed from this table (timings are wall-clock, 0.2 s blocks). |
| 07-R9 | already closed by writer; checked | 07:175 `stopifnot(all(worst < tol))`, `tol <- 1e-12`; 2 of 10 columns without producer named in the text. |
| 07-R10 | already closed by writer; checked | 07:191 `stopifnot(abs(via_matrix - via_line) < 1e-12)`, 07:203 `stopifnot(abs(st2$theta - recomputed) < 1e-12)`. |
| 07-R14 | already closed by writer | no code involved. |
| Chunk labels (rule 6) | fixed | Knitted the whole chapter: the only figure written is `fig-ne-par-at-fixed-theta-1.png` (labelled); every other chunk (now incl. `live-cost`) produces no figure, so no `unnamed-chunk-*` figure can be orphaned by later edits. |
| R/12 + R/04 roxygen "1.988 vs 0.351" | fixed | `sel_de_fast` and `decode_lines` docs now say: one recorded run, 3 seeds, 60,000 evaluations, four restrictions, both arms cold; N-key encoding, not `sel_de()` with its warm start (which scores higher uncapped in the search benchmark); the decoder confound is stated. `devtools::document()` run (man/cost_per_eval.Rd, decode_lines.Rd, sel_de_fast.Rd). ASCII checked. |

Verification: `devtools::test()` -> FAIL 0 | WARN 0 | SKIP 0 | PASS 494 (492 + the 2 expectations of the new test; no existing number moved: `cost_per_eval` is called by no pipeline function). Chapter knitted end to end with knitr, rc 0, every stopifnot passes. `make_downloads.R` re-run after the last edit.
Not done: installed package in the shared library NOT updated (other sessions use it); the live-cost chunk works with the old and new signature. Run `devtools::install()` before the render batch.
