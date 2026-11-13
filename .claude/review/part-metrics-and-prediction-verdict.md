# Verdict -- Part "Metrics and prediction" (05, 06, 07, 08, 08b), iteration 2

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-04-06. Read: part-metrics-and-prediction.md
(21 findings), part-metrics-and-prediction-response.md, and the edited text of 04d, 04e, 05, 06, 07,
08, 08b, 90, 92 plus R/01, R/04, R/05, R/14 and the cached CSVs they read. Chapter 09 not judged.

VERDICT: REJECTED

The part does NOT close. One H-equivalent defect (metrics-D1) is open: the fix to metrics-C8 states
something the code and the cached data contradict. No H finding of the original list is left open
apart from that one reopened item (C1-C5 are closed).

PREVIOUS IDS (re-review)
- metrics-C1 -- CLOSED -- @eq-catalogue-alleles-retained (06:318-326) is correct and equals `alleles_retained()` (R/05:327) and `alleles_retained_fast()` (R/04:278), checked numerically below; 07:961-968 now points to the right quantity and to @eq-catalogue-alleles-retained, not to the MAF count; 90:97 row present. Residuals recorded as metrics-M1, M2, M3.
- metrics-C2 -- CLOSED -- 06:171-173 no longer promises "cheaper still"; it defers to @sec-choosing-cost, which says cheaper only for large n (07:299-310). No other "cheaper still" asserted as fact (grep).
- metrics-C3 -- CLOSED -- 92:57 writes F_BN with `fst` named; 92:394-398 no longer asserts F_ST = 0.15 and says the setting of the cached file is not recorded, as 07:355-361 does; the "re-derived on real genotypes" statement is in 07:526-528 (wording there is "before treating the recommendation as final").
- metrics-C4 -- CLOSED -- 04e:729-733 and 04e:1147-1150 now say the book fits one additive GBLUP, no pool split, trait without SCA, validated by masking (08b:55-64, @sec-hybrid-cv); matches 08b.
- metrics-C5 -- CLOSED -- 04d:423-428 now agrees with 08b (trait generated from the markers the models see; finiteness from training size, noise and rank bound); 04d:402-404 still says the accuracy is assumed.
- metrics-C6 -- CLOSED -- 08b:12-14 no longer says 08 "closes with" S4 or ranks on `ctx$index`; 08:691-722 is a selection among given hybrids with no trait values derived, so "whose values it does not derive" is true.
- metrics-C7 -- CLOSED -- 05:1792 and 05:2164 now say F_ST (GD_BS/GD_T) in a band with GD_BS and GD_T reported beside it; matches 08:277 and Trap 3 (F_ST is the book's GD_BS/GD_T there). Which statistic is the band's target is now stated.
- metrics-C8 -- OPEN -- the fix introduced a false statement; see metrics-D1.
- metrics-C9, C10, C11, C14 -- OWED (not judged here; chapters 09, 10, 11, 12, 11b/11c).
- metrics-C12 -- CLOSED -- 07:670-673 no longer says "real residuals" and now says one simulation, not a formal test, not compared with the generator; CV1 "between 0.5 and 0.7" and CV2 "between 0.9 and 1" match 08b (recomputed, see below); wording residue in metrics-M4.
- metrics-C13 -- CLOSED (no change accepted) -- redundancy, 05:1786 points to Trap 2; not a contradiction.
- metrics-C15 -- CLOSED -- 08:142-146 maps theta_T = f-bar, theta_w = f-tilde (02:39 and 90:321 agree) and separates census-weighted from usage-weighted theta_AB.
- metrics-C16 -- CLOSED -- 06:489-492 states w_A of 06 = twice the pool-A block of 07's w_a = k_a/(2n) (07:100-103); 06:255-256 p_i = k_i/(2n) gives 1/sum p_i^2 = (sum k)^2/sum k^2 of 07:943.
- metrics-C17 to C21 -- NOT JUDGED -- L, not touched by the author; remain owed to 07 (and 12 for C17).

DISQUALIFYING FAILURES
- metrics-D1 [criterion 5; also 1 (statement about what the code computes)] book/06-metric-catalogue.qmd:499-500 (Decomposition by heterotic group, the C8 fix) -- the new sentence says "@sec-cycles logs only the merged `GD` and `GD_BS` (not `GD_WS` or `theta_A`/`theta_B`)". `run_cycles()` logs `theta_A`, `theta_B`, `GD_T` and `GD_BS` every cycle (R/14_cycles.R:139-146), and the cached `book/data/cycles_maxuse.csv`, `cycles_injection.csv`, `cycles_selector.csv` all carry columns `theta_A`, `theta_B`, `GD_T`, `GD_BS` (header read). What 11b does is aggregate and plot a subset (11b:8-13: index, GD, GD_BS, F_hom, F_drift, max_line) and never read the within-pool columns. So "logs only" is false; "reads only" would be true. The error originates in the first review's C8 wording (it cited 11b:12-13, which is the `avg()` subset, not the log); the author propagated it into the text. A false statement about the package, introduced by the fix, stays: the part cannot close on it. The "alternative left open" in the response (11b adds a within-pool column) is also moot in terms of data: the columns already exist in the cached files.

NON-DISQUALIFYING OBSERVATIONS
- metrics-M1 06:317-318 and 06:329-330 -- "the rest of the book uses 'allelic richness' for the second one" / "in the rest of the book 'allelic richness' means A_ret" is wider than the text: 02:983-990 uses the label for Caballero & Toro's allelic diversity (a general concept), 11:40 and 11:268 report literature values of allelic richness in another sense, and R/01_metrics.R:232 (see owed list) labels a third quantity (`rare_retained`) the same. The scope should be the part (06, 07, 08, 90), not the book.
- metrics-M2 06:341, 07:344-349 and 90:97 -- the equation is the package definition, but the cached columns that carry the evidence for it are identified with it by inference only: `metric_redundancy.csv` column `alleles_retained` (consistent with A_ret: range 11,386-11,851, within [m, 2m] with m = 6,000 inferred, and `alleles_retained + alleles_fixed = 12000`) and the ledger column `alleles` of 08, whose own text (08:754) says the set on which it was computed (S3 lines or S4 hybrids) is not recorded. 90:97 says "in 07 and 08" as a fact. Consistency with the equation is shown for 07's cache, not proved for either; 08's is not even consistent-by-check.
- metrics-M3 06:318-322 vs 07:961-968, 07:1077 -- A_ret is defined on a set of lines S_L; 07 applies it to the returned plan of hybrids (`alleles_retained_fast(idx, ctx)` takes hybrid indices and goes through `line_counts()` to the parent lines). The mapping (S_L = lines used as parents of the plan) is stated nowhere in the book; the response states the limit only in its own text. It is numerically harmless (checked below) under A2.
- metrics-M4 07:671-673 -- "lies between 0.9 and 1 of the range explored here" is ungrammatical as a quantity; and it drops 08b:1186-1188's caveat that the comparison is of orders of magnitude only (08b's accuracy is against one trait `g`, Finding 5's against a three-trait index). Recomputed means: CV2 0.905 (sd 0.023, range 0.866-0.941), at the very edge of "between 0.9 and 1".
- Accumulation: M1-M4 are four non-disqualifying observations; the rule of three or more would reject on its own. The verdict does not rest on that alone: D1 rejects.

WHAT WAS VERIFIED
- A_ret equation against the package and the literal count: scratch script scratchpad/aret.R, `pkgload::load_all` of the worktree, `simulate_pools(25, 25, m = 2000)` default seed 1, GL in {0,1}, 50 x 2000. For random line sets of sizes 1, 2, 5, 10, 25, 50 (seed 11): equation by colSums, a literal loop with `any(G == 1) + any(G == 0)`, and `alleles_retained()` agree: 2000, 2617, 3365, 3580, 3868, 3934; size 1 gives exactly m = 2000 (lower bound), all values in [m, 2m]. Bitset route `alleles_retained_fast(idx, ctx)` on hybrid indices (4 draws of 40 hybrids of the 25 x 25 factorial, seed 3) equals the equation on the parent set: 3913, 3911, 3913, 3912; and equals the count on the F1 genotype matrix (0/0.5/1) for a fifth draw (3929 on both).
- Redundancy fractions quoted in 06:341-345 (residual rank sd after quadratic fit on rank theta, `metric_redundancy.csv`): alleles_retained 0.521, E_NE 0.523, A_NE 0.556, theta_between 0.653 ("more than half"), alleles_lost_MAF 0.352, Ne_parents 0.364 ("about a third, as much as N_e,par"). Agree.
- 08b CV numbers (purled chunk up to `genpred-cv`, 20 replicates, seeds 1-20): CV2 0.905, CV1 0.665, CV0 0.144; err_f over 40 draws mean 0.1437, sd 0.0139 (matches 08b/07/response).
- Label `eq-catalogue-alleles-retained` defined once (06:326), cited at 06:341, 07:964, 90:97. 90 defines G^L coded 0/1 (90:22,30).
- N_e,par identity: 06 (p_i = k_i/(2n), 1/sum p_i^2) = 07:943 ((sum k)^2/sum k^2) by algebra; w_a = k_a/(2n), pool sums 1/2 (07:100-103).
- 05's undeclared edit of the theta_w/theta_AB statistic (05 diff, first hunk: (theta_w - theta_AB)/(1 - theta_AB), `theta_decompose()` names the between term `theta_B`) is correct against R/05:73-78 and 90:321.
- 92:57 `fst` is the argument name of `simulate_pools()` (args printed).
- No "cheaper still" claim left (grep over book/*.qmd).

NOT VERIFIED
- The `@`-references of the edited text resolve by grep only (no Quarto render); `docs/` and `book/_freeze/` of 04d, 04e, 05, 06, 07, 08, 08b, 90, 92 are stale, as the response says. Process, not content.
- That `metric_redundancy.csv` `alleles_retained` and 08's ledger `alleles` are computed as @eq-catalogue-alleles-retained (producers are external; M2).
- Chapter 09 and everything owed below: not judged.

OWED TO LATER CHAPTERS (do not block this part's re-review, but the part is not closed)
- 09: C9 (09:382-386), C14(c) (09:11-14). Under its own review.
- 10: C10 (10:455, caption 10:475; circular definition of the four restrictions), C14(b) (10:43-46, re-point to @sec-simulating-crosses).
- 10b: 10b:1245 "@sec-catalogue's rule applies" (06 states no such rule), 10b:1273 (C20).
- 11, 12: C11 (11:23, 11:306, 12:222); C17 (12:35); 12:164-172; 12:264 and 04e:176 "dominance deviation" for d_k.
- 11b: C14(a) cross-link to @sec-genomic-prediction; within-pool diversity is already in the logged data (theta_A, theta_B; see D1) and is not read; 11b:77-79 and 11b:344-346 (simulation-C4, C11).
- 11c: cross-link to @sec-genomic-prediction (C14a).
- 90: rows for G_VR1, G_VR2, G_i(p), G_LA, G_ROH; u / u-hat roles and the truth called u in 07 and g in 08b; sigma^2_u against sigma^2_G (04f:278, 684); n_DH row citing `n_per`.
- 04b: 04b:1195 cites @sec-choosing for `max_use`.
- 07 (own, L): C17, C18, C19, C20, C21 not done.
- R/ docs-only: R/01_metrics.R:232. Correction to how it was described: it is an inline code comment (not roxygen) above `rare_retained` in `freq_metrics()`, "Allelic richness: rare pool markers still segregating", i.e. a third quantity (share of markers rare in the pool still segregating), not `alleles_lost`. It contradicts M1's scope and, if kept, should be renamed or reworded with `document()` and install. R/04_fast_metrics.R:211 ("Allelic richness by bitset") and R/15_response.R:32 are consistent with A_ret.
