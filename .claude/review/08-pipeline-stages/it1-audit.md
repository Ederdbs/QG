# 08-pipeline-stages -- iteration 1 audit (read-only)

Chapter: `book/08-pipeline-stages.qmd` (459 lines, 25 code chunks, 1 figure-producing). Worktree `SB_quanti_gen-review-04-06`, HEAD 172ec6c.
Method: whole chapter knitted end to end against the worktree (`pkgload::load_all`) and against the installed package (same numbers); every cached csv read and recomputed; scratch scripts under the session scratchpad, nothing in the repo edited. Machine timings are one run each.

Severity: H = a claim the chapter's own output or data contradicts; M = unsupported or mis-stated; L = hygiene.

## Summary table

| ID | Sev | Where | One line |
|---|---|---|---|
| 08-R1 | H | 08:309-321, R/05:375 | `select_lines_constrained()` does NOT meet the ceiling in the chapter's own chunk (`met` prints 0, selection == plain truncation); repair is a 2-cycle, silent |
| 08-R2 | H | 08:123-147 | "frequency-side statistics decouple from F_ST" contradicted by the chunk's table: `mean_sq_delta_p` = 0.365 x Fst, r = 0.9997 |
| 08-R3 | H | 08:391-411 | "diversity benefit is not [real]" rests on 2 low-power outcomes; the ledger's own final-set GD is higher under the diversity term (paired p = 0.015, 7/8) |
| 08-R4 | H | 08:6-8, 110, 249-252, 358-399 | three csv + two png have no producer; chapter does not say so; the end-of-pipeline table is hand-typed; design numbers (6000 markers, 20 crosses...) have no source |
| 08-R5 | M | 08:361, 381, 394-399 | "merit only" is the csv's "UC only" (usefulness criterion, includes progeny sd); table headers render as `loss_pct.UC only` |
| 08-R6 | M | 08:167, 381-387, 451 | "77% of all diversity lost" is a share of a sum of re-based stage losses, unconditional in the prose, contradicted by the UC + div arm; structural explanation untested |
| 08-R7 | M | 08:293-307 | caption "unreachable at every smaller size" holds for random sets only; optimised sets of n = 12..19 reach the ceiling; figure chunk unseeded |
| 08-R8 | M | 08:264-266, 449 | "constrain within each pool" is advised and not demonstrated; the demo is pooled (6 A / 14 B) |
| 08-R9 | M | 08:23-25, 58-103, 175-199, 337-354 | "max deviation reported next to every identity" false for DH (a)-(c), sigma2, He; no `stopifnot` anywhere; missing identity `ratio = 2 - Fst_W` |
| 08-R10 | M | continuity (THREAD) | F_ST / G_ST naming vs 05b/02 (08's "G_ST" IS the book's F_ST), theta_B, F_BN, Ne, Kadoumi, S1 "under selection", tbl-hp-stages |
| 08-R11 | M | 08:26-29, 48, 152 | 07 Owed: N_s / allelic-richness wording; `Ns_total = 0.756` printed with no caveat |
| 08-R12 | L | 08:413-433 | cost table: `theta_decompose(GL)` is O(L^2 m) not O(L^2); "swaps typically under 20" unsupported and contradicted by R1 |
| 08-R13 | L | 08:190-199 | crosses chunk: 20 draws, 1 self-pair dropped, 18 distinct, pool A only; none stated |
| 08-R14 | L | 08:226, 221, 358-360, 382, 385, 402 | hand-typed numbers in prose/code |
| 08-R15 | L | seeds | seed audit; Trap 5 / Trap 3 stochastic assertions over 20 seeds |
| 08-R16 | L | 08:228-258 | Trap 4: correct on the data; rank consequence and stratum design not shown |
| 08-R17 | L | docs/, _freeze | chunk labels / orphan figures; downloads script in sync |

---

## 08-R1 (H) The "working route" does not work on the chapter's own example

Chunk at 08:313-321 prints, from the knit:

```
n_selected 20 | theta 0.6755400 | ceiling 0.6746394 | met 0 (= FALSE) | mean_merit 1.0724564 | merit_of_top 1.0724564
```

theta of the selected set is above the ceiling, and `mean_merit == merit_of_top` to 7 digits: the "repaired" set is the plain top-20 (`identical(sort(top), sel)` TRUE). The prose at 08:309-311 ("swap ... until the ceiling is met") and 08:323-325 never mentions that it was not. `met` prints as `0`, not `FALSE`, because `c()` coerces.

Diagnosis (`R/05_pipeline_metrics.R:375-401`, traced with `max_swap = 0..5001`): the swap rule does not decrease theta monotonically (merit_weight = 0.25 enters both the drop and the add score); after one swap theta rises 0.67554 -> 0.675655, the second swap undoes it. It is a 2-cycle, so the returned set is the top-20 when `max_swap` is even (5000 default) and a different, equally bad set when odd. The loop ends at `max_swap` with no warning. This is exactly the silent failure Trap 5 indicts in the incremental greedy.

The ceiling is attainable: a 4000-step single-swap local search from a random start reaches theta = 0.6644 at n = 20 (< 0.6746).

Not a one-seed accident. 20 `simulate_pools(30, 30, 3000, 0.15, seed = 1..20)` worlds, same chunk logic (alpha 0.005, top-20 by `GL %*% beta`):
top-20 already violates the ceiling in 10/20; after repair the ceiling is met in 13/20, i.e. repair fixes 3 of the 10 violating cases and fails 7; the returned set equals plain truncation in 15/20 (so at least 5 of the 10 violating cases come back unchanged).

Why the package test passes: `test-stage-metrics.R:35-43` uses `rnorm` merit, alpha = 0.002, seed-6 world; there the top set happens to be repairable. No test has a case where truncation violates and the repair cycles.

Fix owner: R/05 (accept a swap only if theta decreases, or drop merit from the add score once violated; `warning()` + an attribute `met` when `max_swap` is hit; return the swap count) plus a test on the chapter's world (`simulate_pools(30,30,3000,0.15,seed=12)`, alpha 0.005). Chapter: print `met` as logical, add `stopifnot(met)` after the fix, and state the merit price against `merit_of_top` in prose from the output. Until then 08:309-325, checklist item 5 and `91-package` row 235 present a route that fails here. "swaps typically under 20" (08:425) is also contradicted (R12).

## 08-R2 (H) Trap 3: the table does not show the claimed decoupling

08:123-124: "The frequency-side statistics decouple from F_ST accordingly" then the sweep (`target_fst` 0.05/0.15/0.25/0.40, seed 3, one draw per row). Its output:

```
target Fst    GD_within frac_opp  mean_abs_dp mean_sq_dp
0.05  0.0907  0.3321    0.0005    0.1412      0.0331
0.15  0.1857  0.3003    0.0000    0.1995      0.0685
0.25  0.2711  0.2644    0.0045    0.2379      0.0984
0.40  0.4348  0.2106    0.0370    0.2940      0.1620
```

`mean_sq_delta_p / Fst` = 0.365, 0.369, 0.363, 0.373. Over 20 seeds x 4 levels (80 draws, 25+25 lines, 2000 markers): `mean_sq_delta_p / Fst_Wright` = 0.365 / 0.365 / 0.363 / 0.366 per level (sd 0.003-0.004), pooled `cor(Fst, mean_sq_delta_p) = 0.9997`, within level 0.93-0.97. Both statistics are functions of the same frequencies; under neutral Balding-Nichols divergence `mean_sq_delta_p` is F_ST rescaled. What decouples is *expected heterosis* (05b:604-640, total flat along the sweep), not the frequency-side statistics. As written the sentence is false for the one statistic the chapter then recommends logging (08:143-147, 08:155-157).

Also:
- "Buying oppositely-fixed loci costs within-pool gene diversity, and it costs a great deal of it" (08:139-140): the sweep varies `fst` (F_BN), not the number of oppositely fixed loci (0.0005-0.037 of markers); GD_within falls 0.332 -> 0.211 (-36 %, 20-seed means .333/.298/.262/.211) with divergence as a whole. Causal wording is not what was varied.
- "frac_opposite_fixed sits at essentially zero across the whole range of divergence a real dent-versus-flint pair occupies" (08:145-147): no real range is sourced here; the only real value in the book is Kadoumi's F_ST 0.178 -> 0.223 (00:343-349), which is the F_BN ~ 0.1-0.15 stretch (frac_opp ~ 0.0003 in `fst_definitions.csv`) but the statement needs that value, and at 0.40 the column is 0.023-0.037, not "essentially zero".
- "watch `mean_sq_delta_p` for heterosis potential" (08:156-157): 05b:905-918 says it is the *unweighted* (d = 1) divergence term and "cannot carry the weighting by d"; and under neutral divergence divergence is paid for by the shared term (05b:765-772). 08:143-145 says "exactly twice the divergence term of expected heterosis" without the d = 1 condition.
- "F_ST keeps rising ... at loci that are *already* divergent" (08:118-119) is a mechanism 05b cites as a symptom statement and does not test.

Fix: say the sweep shows F_ST and `mean_sq_delta_p` rise together and the heterosis total does not (05b:Tbl het-sweep), drop "decouple from F_ST", state d = 1, replicate over seeds (20 is cheap), and add `stopifnot` on the ratio band if the sentence is kept.

## 08-R3 (H) "The diversity benefit is not [real]" (08:399-411)

The table (typed, R4) compares two outcomes, `Ne` (N_e,par) and marker alleles retained, at n = 8 pools: paired t p = 0.243 and 0.519. I recomputed from the csv: Ne diff +1.13, 95 % CI [-0.97, +3.22] = [-4 %, +13 %] of 24.2; alleles diff +40.6, CI [-101, +182] = [-0.9 %, +1.6 %] of 11274. Absence of significance at n = 8 is not absence of a benefit, and the intervals do not exclude the sizes the chapter's own stage ledger shows.

The ledger's own end-of-pipeline quantity, GD of the final 200 hybrids (`GD_after`, S4 row, the diversity scale used everywhere else in the book), is higher under the diversity term: UC only 0.2899, UC + div 0.2977, paired diff +0.0078, 95 % CI [0.0021, 0.0136], t-test p = 0.0147, higher in 7/8 pools. (Post hoc, unadjusted for the three outcomes; stated as a counter-example to "neither end-of-pipeline outcome improves", not as the headline.) Same data: stage S2 loss lower under the term in 8/8 pools, S3 and S4 loss higher in 8/8 pools, i.e. "reconverges" (08:404-406) is a description of the signs of the stage losses, and "diversity spent at S2 is partly reclaimed at S3 and S4" is a mechanism the ledger does not test (S3/S4 baselines are re-based, R6).

The merit statement checks out: 33.40 vs 29.71, loss 11.05 % (ratio of means; mean of ratios 10.97 %), lower in 8/8 pools, paired p = 0.000236.

Fix: report mean, paired difference, CI and n positive for all of GD_after, Ne, alleles; replace "the diversity benefit is not" by what the CIs support; say outcomes were chosen before/after seeing the data (they cannot have been decided from this file alone).

## 08-R4 (H) Provenance: cached data with no producer, not labelled

`grep` over `book/scripts/regenerate.R`, `inst/scripts/`, `R/`: no writer for `fst_definitions.csv`, `dist_vs_variance.csv`, `pipeline_loss_ledger.csv`, `metric_pitfalls.png`, `pipeline_loss.png` (index.qmd:200-204 lists them as cached/external). The chapter reads them at 08:6-8 and 08:249-252, 08:374-378 and says "were simulated end to end" (08:358) with no statement that the code is not in the repository. Rule: cached external data is never presented as reproducible; THREAD already asks for this (08:8, 08:378).

What cannot be checked from the repo, and is stated as fact in the prose:
- 08:358-360: "8 independent founder pools (120 lines, 6000 markers, target F_ST = 0.15; 20 crosses, 40 DH each, 80 lines selected, 200 hybrids mined)". The ledger records only n_in/n_out (120/800, 800/80, 1600/200) and seeds 1-8; markers (6000), crosses (20), and the F_BN value are not in any file.
- The cross-selection rule: the csv strategy labels are `UC only` / `UC + div`; the form and weight of the "diversity term on parental coancestry" are unknown (R5).
- What `Ne` (24.2) and `alleles` (11274 of 2m = 12000 if m = 6000) were computed on: S4 hybrid set? S3 lines? Not recorded.
- `fst_definitions.csv`: pool sizes, m, replicates, seeds unrecorded (`ratio == 2 - Fst_Wright` to 4e-15 in all 7 rows, so equal pool weights are inferred).
- `dist_vs_variance.csv`: 300 crosses per stratum, `A x A` only (no `B x B`), parent sampling and overlap of parents unrecorded; the crosses share parents, so the 300 are not independent replicates.
- `metric_pitfalls.png`: "on the full simulation" (08:249) undefined; panel B repeats `fst_definitions.csv`; unreadable as numbers.

What did verify against the files: `loss_pct = 100 (GD_before - GD_after) / GD_before` in all 48 rows (max dev 2.8e-13); `share_of_total = 100 loss_pct / sum(loss_pct)` per seed x strategy; the typed table values 33.40 / 29.71, 24.20 / 25.33, 11274 / 11314 and p = 0.0002 / 0.24 / 0.52 equal the csv (recomputed: 33.40/29.71, 24.20/25.33, 11273.6/11314.3, p 0.000236/0.243/0.519). They match; they are still typed (08:393-399) and must come from `led` in a chunk.

Fix: a provenance sentence at 08:358 and 08:228 ("cached from an external study; the generating code is not in this repository; one draw of 8 pools"), compute the table from `led`, record or drop the unrecoverable design numbers.

## 08-R5 (M) "merit only" is not the strategy in the data

csv `strategy` = `UC only` / `UC + div`. UC is the usefulness criterion `mu + i h sigma` (R/05:279), which includes the progeny standard deviation; prose calls it "merit only" (08:361-362, 381, 394), also 00:330. "Merit" is the line breeding value (`merit` of 08:271), a different quantity. Also the rendered table (08:368-372) has the headers `loss_pct.UC + div`, `share_of_total.UC + div`, ... (from `reshape`), with the diversity arm first. "mean over 8 founder pools" with no dispersion (the S3 UC-only mean 0.32 % hides two negative pools, -0.20 and -0.03 %).

## 08-R6 (M) The 77 % claim and the stage-dominance statements

- Recomputed: UC only, mean over pools of `share_of_total` at S2 = 77.46 (pool range 63.0-81.4); share of the mean losses 77.0; S2/S4 loss ratio 9.40/2.48 = 3.78 ("more than three times" holds). The denominator is `sum(loss_pct)` over S2, S3, S4, each loss measured against its own re-based baseline (S3 `GD_before` 0.3027 != S2 `GD_after` 0.3063, same pool). It is a share of the sum of stage-wise proportional losses, not of the end-to-end loss; proportional losses on different bases do not add. 2 of 48 rows are negative (S3), which can push a share above 100 %.
- "This is where the largest share of pipeline diversity is lost" (08:167), 08:381 ("77 % of all diversity lost in the pipeline"), checklist 8 (08:451-452) are unconditional. In the UC + div arm of the same table S2 = 35.5 %, S3 29.0 %, S4 35.5 % (shares of mean per pool 34.7 / 30.2 / 35.1). 00:322-331 already conditions it on the S2 strategy (THREAD, 00-C15). Checklist 8 "not hybrid mining, is where the diversity goes" is true of one arm.
- 08:385-387 "20 crosses out of 1770 ... a far harsher bottleneck than 200 hybrids out of 1600": 1770 = choose(60, 2) is the number of pairs inside ONE pool of 60; with 20 crosses (and from which pool or pools?) the comparison is of sampling fractions (1.1 % vs 12.5 %). The loss is driven by parent usage, not by the fraction of combinations; no run in the chapter varies it. State as a hypothesis or test it (`dh_pool_theta`/`hybrid_theta_from_usage` make the usage argument computable on the chapter's world).

## 08-R7 (M) Trap 5 figure and claims (08:279-307)

- Chunk output (checked): `ceiling 0.6746`, `theta_single_line 1`, `theta_best_pair 0.8008`, `any_pair_admissible FALSE`. "No single line and no pair can satisfy the ceiling" holds.
- Caption 08:297-298 "A ceiling calibrated at the target size is unreachable at every smaller size". The figure plots the mean theta of random sets, n = 2..60 (n = 20: 0.6727 +- 0.0002 s.e., 50 reps, ceiling 0.6746). Optimised sets reach it at smaller sizes: local search (4000 swaps, one start each) gives min theta 0.8023 (n = 2), 0.7513 (3), 0.7065 (5), 0.6828 (8), 0.6716 (12), 0.668 (15), 0.6656 (18); so the ceiling is reachable by a chosen set from about n = 12 here and unreachable only below ~n = 9. Restrict the caption to random sets / to the incremental greedy path (theta(1) = 1, theta(2) >= 0.80), which is what matters for the argument.
- "fails silently by returning an empty set" (08:279-281): no incremental greedy is run; it is shown structurally, correctly (theta(1) = 1). Either a 6-line greedy or "would".
- The figure chunk (08:299-306) draws `sample.int` with no `set.seed()`; the stream continues from `set.seed(88)` through the 08:191 chunk. The figure is the only unseeded draw that matters in the chapter (rule 2); seed it.

## 08-R8 (M) "Apply the constraint within each pool" is advised, not shown

08:264-266 and checklist 6 (08:447-448). The S3 chunks select 20 of 60 lines pooled: top-20 is 6 from pool A / 14 from pool B (checked), the ceiling is calibrated on random sets of the pooled 60 (which include between-pool structure), and `select_lines_constrained()` has no pool argument. The chunk therefore demonstrates the very thing the paragraph above it warns against, with a visible pool imbalance that goes unmentioned. Either run it per pool (`pool == "A"`, `n_sel = 10`) or label the demonstration pooled and say the within-pool version is not implemented.

## 08-R9 (M) Identities: asserted in prose, not checked in code

08:23-25 "where a result is an exact algebraic identity, the maximum deviation from simulation is reported next to it". Reality (all numbers from the knit and my checks):

| Identity | In chapter | Measured | Needs |
|---|---|---|---|
| f = 1 - MRD^2 (08:63) | printed 1.1e-16 | 1.1e-16 | `stopifnot(< 1e-12)` (inbred 0/1 only; false for hybrids, say so) |
| theta_T partition (08:79-84) | printed 0.0000000 | exactly 0 | `stopifnot` |
| G_ST == Nei classical (08:98-102) | 0.1003525 twice, 7 digits | equal | `stopifnot(all.equal(..., 1e-12))` |
| ratio F_ST^(W)/G_ST == 2 - F_ST^(W) | not stated | live 2.2e-16; 7 csv rows 4.4e-15 | state it: it is the content of "up to 2x" and "stays near two" (08:86, 111). Equal pool weights; ratio 1.96 -> 1.59 over the table, a 19 % fall, so "near two" is loose at F_BN >= 0.3 |
| DH (a), (b), (c) (08:172-199) "Three verified identities" | values printed, compared with nothing | (c) literal pair-by-pair expectation vs `dh_pool_theta`: dev 8.9e-16; Monte Carlo (free recombination, 200 reps, 19 crosses x 40 DH): 0.701101 +- 1.2e-5 s.e. vs formula 0.701091, z = 0.85; self-term contribution 0.000207 (about 17 MC s.e., resolved) | one `stopifnot` against the literal oracle; state free recombination (also needed by sigma2, below); the self-term mean is n_c-weighted when n_c differ (equal here) |
| sigma2_DH = 1/4 sum beta^2 over segregating loci (08:212-214) | no check | holds only for unlinked loci, additive, 0/1 coding; none declared (chapters 03/04 simulate maps) | a 3-line gene-dropping check or the assumption |
| H_e == 1 - theta_hyb (08:346-354) | He computed as `1 - theta` in the chunk (tautology) | independent `mean(2 p (1-p))` from `colMeans(ctx$X[hyb, ])`: 0.3379152, dev 5.6e-17 | compute He from frequencies and assert |
| theta from usage == hybrid matrix, "Deviation exactly zero" (08:342) | printed 0.0000000 | exactly 0 | `stopifnot(< 1e-12)`; "exactly" -> tolerance |
| `sel_intensity(0.05)` 2.0627 vs 2.063 (08:221, 226) | typed 2.0627 and 2.063 | 2.062713 | assert `abs(. - 2.063) < 5e-4`, inline value |

Also `usefulness_criterion(h = 0.6)` (08:220): h is the square root of heritability (roxygen only); undefined in the chapter.

## 08-R10 (M) Continuity items from THREAD, re-checked in the file

a. `theta_B` (08:91, 105; `theta_w` never defined) vs 00/90 `theta_AB`; package clash `theta_decompose()$theta_B` (between pools) vs `theta_pools()[["theta_B"]]` (within pool B) -- 00-E4.
b. F_ST / G_ST (08:86-106). Numerically: with equal weights `GD_BS / GD_T` = 0.1003525 = `Gst_Nei` (the chapter's G_ST, smaller one), not `Fst_Wright` (0.1824). So 08's "G_ST" is the book's F_ST of 02 (@eq-f-stats) and of 05b (05b:621 "F_ST is the statistic GD_BS/GD_T"), and 08's "F_ST^(W)" is the other one. The Trap 3 sweep (08:127-136), the S1 panel and checklist 2 (08:439-440) band/monitor `Fst_Wright`, while 05b:1426 and 05b Step 8 cite "@sec-stages Trap 3 ... hold F_ST in a band" for the GD_BS/GD_T statistic. A reader cannot tell which statistic is banded. Also the label for Wright is withdrawn in 02 (THREAD, 02-C2): 08:91 "Wright" in `F_ST^(W)` and `Fst_Wright` remains attached.
c. `fst` is F_BN: 08:111 caption "true divergence", 08:359 "target F_ST = 0.15", column `target_fst`; the realised statistic is 0.0446 at F_BN = 0.02 (csv), 0.1676 at 0.15.
d. 08:69-71 within-pool diversity "erodes under selection", between-pool "inflates": 00:333-341 gives a drift-only argument and 00:343-357 the Kadoumi result (F_ST 0.178 -> 0.223, mean between-group Hamming 0.430 -> 0.420, SS He stable, NSS 0.371 -> 0.279, authors attribute the loss to merging of groups into NSS and "can only speculate" about selection). 08:160-163 "found exactly the two opposite trends this panel is built to separate" overstates it.
e. 08:352 / table `Ne`: it is N_e,par (`ne_parents_from_counts`, = (sum u)^2 / sum u^2; 49.6 here), 90:79; the chunk prints the name `Ne`; the end-of-pipeline table row is "effective no. parent lines".
f. 08:16-21 restates @tbl-hp-stages; cross-reference it (00-C25).
g. THREAD 04-C10 check: 08 fixes `n_per = 40`, never varies plants per cross, never cites @sec-sizing, claims nothing about plants-per-cross. Satisfied. THREAD 02b-C14: 08 carries no @sec-response back-citation; nothing to remove.

## 08-R11 (M) 07 "Owed": 08:26-29 and the N_s wording

`it1-response.md` (07), Owed: 08:26-29 says the "metric set established in @sec-choosing" is "molecular coancestry as the kernel, GD = 1 - theta as the scale, N_s as the interpretable size, allelic richness as the one non-redundant addition". 07 now: Ne_par is the recommended second constraint; N_s is a rescaling of theta in [1/2, 1], not a head count; allelic richness is one of several (A-NE, E-NE, between-pool coancestry, n_lines_used keep as much of the residual). Suggested text, from 07's statements:

"... molecular coancestry as the kernel, GD = 1 - theta as the scale, N_{e,par} as the second constraint, N_s only as a rescaling of theta (a value in [1/2, 1] on molecular coancestry, not a head count, @sec-ns), allelic richness as one non-redundant addition among several, and proportional loss measured against a same-size resampling baseline."

In the chapter itself: 08:47-48 defines `N_s = 1/(2 theta)` as a size with no caveat, and the S1 panel (08:152) prints `Ns_total = 0.7559` (theta_T 0.6614) which reads as 0.76 of a line. The ledger and S4 use N_e,par and allele counts as outcomes (consistent with 07). 08:408-411 (richness as the target, constraint through all four stages) is consistent with 07's scoping.

## 08-R12 (L) Cost table (08:413-433), measured

No measurement behind the table. One run each, adaptive repetitions >= 0.3 s, this machine (us):

| config | `theta_decompose(GL, pool)` | same with `f=` | `dh_pool_theta` | `sigma_dh_crosses` | `hybrid_theta_from_usage` |
|---|---|---|---|---|---|
| L 60, m 3000, C 20 | 2266 | 122 | 21 | 454 | 4 |
| L 120, m 6000, C 20 | 19750 | 130 | 26 | 947 | 11 |
| L 300, m 6000, C 100 | 90250 | 318 | 107 | 5953 | 58 |

`theta_decompose(GL, pool)` builds `f` when `f = NULL`: it is O(L^2 m) (4 x L^2 x m... 2.3 ms -> 90 ms), not O(L^2); O(L^2) only with `f` supplied. `sigma_dh_crosses` is the dominant per-plan cost, as stated (45x `dh_pool_theta` at L = 120). "microseconds" holds (4-107 us). "swaps typically under 20" (08:425): unsupported; `select_lines_constrained()` returns no swap count and ran to `max_swap = 5000` on the chapter's world (R1). State the L, m, C and the machine, or drop the figures.

## 08-R13 (L) The crosses chunk (08:190-199)

`sample(A, 20, replace = TRUE)` twice with `A <- 1:30` (pool A lines only): 20 draws, 1 self-pair dropped = 19 rows, 18 distinct pairs (a pair is used twice), and none of this is stated; the quantity `dh_pool_theta` receives has non-uniform usage. Harmless for the identity (the literal oracle matches, R9), misleading for "20 crosses" read against 08:359.

## 08-R14 (L) Hand-typed numbers (rule 1)

08:221 `textbook = 2.063` (reference value, fine if labelled as such), 08:226 "2.0627" (typed output), 08:358-360 design, 08:382 "77 %" and "three times", 08:385-387 "1770", "1600", 08:393-399 the whole table incl. p-values (verified equal to the csv, R4), 08:402 "11 %", "all 8 pools". Each is computable from `led`/`sim` inline (`r ...`) except the design numbers (R4).

## 08-R15 (L) Seeds and stochastic assertions

| Chunk | Seed | Status |
|---|---|---|
| 08:32 `simulate_pools(..., seed = 12)` | inside the function (`set.seed(seed)`) | ok |
| 08:127 sweep, `seed = 3` | inside the function | ok, one draw per row (R2: 20-seed rerun) |
| 08:191 `set.seed(88)` | immediately before | ok |
| 08:274 `loss_vs_resampling(seed = 1)`, 08:286 `theta_ceiling(seed = 1)` | default arg, `set.seed` inside | ok (the same 200-subset stream is used by both, B differs) |
| 08:299-301 `replicate(50, sample.int)` | none (stream from `set.seed(88)`) | unseeded (R7) |
| 08:334 `set.seed(91)` | immediately before | ok |
| `_common.R` `set.seed(2026)` | top | irrelevant; no AlphaSimR/MaCS in this chapter |

20-seed reruns (cheap): Trap 5 repair (R1: top violates 10/20, repaired ok 13/20); Trap 3 (R2: ratio constant, all 4 levels); both reported above. The S3 loss-vs-resampling result (loss 0.80 %, percentile 0.07; the top-20 loses MORE than the alpha = 0.5 % the ceiling allows) is one world; it is the reason the repair is needed in the first place and the chapter does not state it.

## 08-R16 (L) Trap 4 (08:228-258)

Checked on the csv: r(sigma_DH, MRD) = 0.103 (A x B, p = 0.075), 0.219 (A x A, p = 1.3e-4), pooled 0.576; R^2 0.011 / 0.048 / 0.332 as typed in the table (computed in the chunk, fine). r(sigma_DH, n_seg) = 0.102 / 0.218 / 0.576 and r(MRD, n_seg) = 1.000 within strata: "a raw count of segregating loci explains the same variance" (08:254) is true and is shown by no code. Missing: what the claim costs a breeder (overlap of the top-q crosses by UC vs by MRD) -- 08:257-258 "Rank on sigma_dh ... never on distance" is advice, not a result. 300 crosses per stratum with shared parents; within-pool stratum is A x A only.

## 08-R17 (L) Rule 4 / 5 / 6 / downloads

- Reads only `book/data`, `book/figs` and the package (`source("_common.R")`, `book_data()`, `book_fig()`); no `report/`, `data/`, `reference/`.
- Every function the chapter calls exists and runs in the installed package (`simulate_pools`, `ctx_from_pools`, `theta_decompose`, `gst_nei`, `pool_complementarity`, `s1_monitor`, `dh_*`, `sigma_dh_crosses`, `usefulness_criterion`, `sel_intensity`, `loss_vs_resampling`, `theta_ceiling`, `select_lines_constrained`, `s3_theta`, `hybrid_theta_from_usage`, `line_usage`, `ne_parents_from_counts`, `pool_balance`, `ref_theta`, `mrd_matrix`, `coancestry_from_mrd`); `devtools::install()` not needed for 08 unless R/05 changes (R1).
- Cross-references resolve: `sec-hp-cycle` (00), `sec-choosing`, `sec-collapse` (07), `sec-heterosis` (05b), `sec-cycles` (11b), `sec-plant-literature` (11), `sec-ns`, `sec-catalogue` (06). Kadoumi 2025 is in `references.bib` but 08:160 writes "Kadoumi et al. (2025)" as plain text, not `@kadoumi2025`.
- Chunk labels (rule 6): only one figure-producing chunk, `unnamed-chunk-15-1` (08:296-307); tracked in `docs/08-pipeline-stages_files/figure-html/`, `book/_freeze/08-pipeline-stages/figure-html/unnamed-chunk-15-1.png` and `figure-typst/unnamed-chunk-15-1.svg`. Any chunk added/removed before line 296 renumbers it and orphans those three files (and the html/typ freeze json). Label it `#| label: fig-theta-by-size`. `metric_pitfalls.png` and `pipeline_loss.png` are static (no orphan risk).
- `book/downloads/08-pipeline-stages.R`: code lines equal `knitr::purl` of the .qmd (only the inlined `_common.R` header differs); regenerate after any edit.

## Chunk-by-chunk status (every code chunk)

| Chunk (line) | Runs | Result checked | Verdict |
|---|---|---|---|
| setup 3-9 | yes | csv read | R4 |
| sim 31-36 | yes | 60 lines, 3000 markers, 900 hybrids | ok |
| MRD 58-61 | yes | 1.1e-16 | R9 |
| partition 79-84 | yes | 0 | R9 |
| F_ST defs 98-103 | yes | 0.1824 / 0.1004 / ratio 1.8176 = 2 - 0.1824 | R9, R10 |
| fst table 108-112 | yes | csv | R4, R9 |
| sweep 126-137 | yes | table above | R2 |
| s1_monitor 151-153 | yes | Ns_total 0.7559 | R11 |
| DH 190-199 | yes | 0.70109 / 0.70088 / 0.8493 | R9, R13 |
| sigma/UC 216-224 | yes | 2.062713 | R9 |
| Trap 4 table 234-245 | yes | csv | R16 |
| loss_vs_resampling 270-275 | yes | loss 0.80 %, pct 0.07 | R15 |
| ceiling 285-291 | yes | pair/line facts hold | R7 |
| figure 296-307 | yes | caption false for optimised sets | R7 |
| repair 313-321 | yes | FAILS the ceiling | R1 |
| S4 usage 333-340 | yes | 0 | R9 |
| He/Ne 349-354 | yes | tautology; label Ne | R9, R10 |
| ledger table 366-372 | yes | csv | R4, R5, R6 |
| outcomes table 391-400 | yes | hand-typed, equals csv | R3, R4 |
| cost table 415-427 | yes | static | R12 |

## Not done / limits

No R/ file or chapter edited. The 20-seed Trap 5 and Trap 3 reruns are scratch scripts (not committed). The Monte Carlo DH check ignores linkage by construction (the chapter's assumption). The ledger csv cannot be rerun (R4), so every ledger number above is a re-computation from the cached file, not a reproduction.
