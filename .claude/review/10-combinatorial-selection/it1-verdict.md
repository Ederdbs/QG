# Chapter 10 (book/10-combinatorial-selection.qmd) -- verdict, iteration 1

VERDICT: REJECTED

PREVIOUS IDS (re-review only)
- Not applicable (iteration 1). Status of every audit (10-R*), refs (10-B*) and continuity (10-C*) finding is in the table after the findings: all OPEN, no author response yet and the qmd is unchanged in the lines concerned.

DISQUALIFYING FAILURES

- 10-D1 [3, 6] 10:450-452, 10:515-517, 10:461-476 -- cached external result presented as in-repo and "reproducible in direction". `book/data/de_constraints.csv` has no producer in `book/scripts/regenerate.R` (audit table; the repository states so in index.qmd:198 and 07). The chapter gives it a wrong path (`data/`, gitignored; the file is `book/data/`), never says it has no writer here, and says "reproducible in direction, not to the digit". NP, n_sel, itermax, penalty and hardware are unrecorded. Criterion 3 (Provenance) and 6. (R1; C16 in part.)
- 10-D2 [3, 4] 10:346-347, 10:450-452, 10:488-495, 10:508-513, 10:519-521 -- the "infeasible ... measured rather than asserted" claim and the constraint-handler claim exceed the evidence. Read from the CSV (recomputed): 3 seeds per arm; hybrid-key mean 0.351 (range 0.014), line-weight mean 1.988 (range 0.061); `index` identical to every digit between "penalty" and "repair" in the hybrid arm (TRUE for all 3 seeds). The comparison is two encodings at 60,000 evaluations with NP unrecorded; 3,600 dimensions at 60,000 evaluations is fewer than two generations at NP = 10 x dim, so the search is under-powered by construction and "infeasible" is a statement about that budget, not about the encoding. Constraints are slack in all 9 rows (violation 0, feasible TRUE, hybrid arm loss 0.05-0.07% vs 0.5%, Ne 75.8-77.2 vs 50, pool imbalance 0), so "a penalty the other arm had to pay" has no support, and the closing sentence "the constraint handler does not [decide]" rests on a line arm with no penalty counterpart. The mechanism offered for the penalty/repair identity ("never travels far enough from its random start") is untested; `make_fitness_fast(encoding = "hybrid")` calls `decode_rank()`, which takes no `max_use` (R/04_fast_metrics.R:394), so the two handlers are the same function in that arm, which is the likelier reason (inference: the external run's code is not available). The ratio 5.667 printed by `encoding-spread` is the ratio 07 withdrew (no natural zero). Criterion 3 (replication, proportionality) and 4 (mechanism as fact). (R2, R4, R5, R6, C3, C4, C15, C17.)
- 10-D3 [3] 10:500-507, 10:842-875 -- "`sel_de()` finishes ahead of the line-encoded `sel_de_fast()` at both scales" and "the highest index of any capped route at both scales" are read from means of 3 seeds without dispersion or pairing. Recomputed from `search_benchmark.csv` (3 seeds per method and scale): uncapped, book `de_hybrid` - `de_lines` = 0.310, 0.283, 0.308 (resolved); production 0.106, 0.168, 0.057, mean 0.110, s.e. 0.032, t = 3.4 on 2 df -- not resolved by three seeds (07 says so itself). Capped rows: book 0.0041 in every seed (sd 0, no s.e.); production difference 0 in every seed; production `greedy_cap` 1.12252 vs 1.12233 for the other capped routes: 2e-4 with sd 0 is a tie, not a ranking. Criterion 3 (Monte Carlo error, resolution, pairing). (R3, R21, C11.)
- 10-D4 [3, 4] 10:626-636, 10:830-836 -- "shrinks the run-to-run spread by an order of magnitude" is a standard deviation from n = 3 (warm 0.0023, cold 0.0353), and the same 0.002 is then quoted as "the DE's seed-to-seed spread" against the steps between budgets. The arms are not paired as stated: in the cold arm `sample.int()` is consumed inside `sel_de()` before the random remainder, so the shared seed does not share the initial population. The audit reran 20 seeds with the chapter's own calls (seed 9 reproduces): warm sd 0.0225, cold sd 0.0291 (ratio 1.3, not 10); location effect holds (paired difference 0.139, s.e. 0.0079, 20/20). The qualitative location claim is supported; the spread claim is not. Criterion 3 (replication, Monte Carlo error). (R8.) Not rerun by me, see NOT VERIFIED.
- 10-D5 [1, 4] 10:764, 10:822-831 -- the relaxation paragraph states a wrong reason and rests on a grid artefact. Recomputed (book ctx, n = 60, gd_ref 0.3258386): 10-point lambda grid, 2 points inside the 1% budget, best 1.12895 (the chapter's 1.129); 48-point grid on lambda in [1, 158] at 8000 iterations, 7 points inside, best 1.52069, above the DE plan (1.330) and the best feasible greedy (1.378), below the bound 1.553244. So the number does not show that a relaxation point inside the budget cannot exceed discrete plans; it shows a coarse grid. The stated reason ("each point maximises a penalised objective rather than the index at its own diversity") is also wrong against 09's weak duality (@eq-ocs-weak): each point is the index maximiser at its own diversity and bounds every plan at least as diverse as itself; what fails is the step to "the plan that spends the budget". The caption ("a relaxation, not a bound at matched diversity") has the same defect. The pointer to 10b @sec-bound for the derivation is also wrong: the derivation is 09 @eq-ocs-bound; 10b falsifies the old construction. Criterion 1 and 4. (R12, R13, C1.)
- 10-D6 [3] 10:586-590, 10:673-675, 10:794-820 -- "the DE is ahead at 4 of 5 budgets" and "best feasible greedy of the finely swept grid" depend on the greedy grid. Recomputed (my run), best greedy index with alpha <= alpha_max at alpha_max = 0, 0.0025, 0.005, 0.01, 0.02: chapter's 20-value grid 0.867, 0.867, 0.867, 1.378, 1.378; 09's 60-value grid (1e-6 to 1e-1) 1.1765, 1.1765, 1.2856, 1.4227, 1.6841. The DE values of the chapter's front (0.955, 1.081, 1.183, 1.318, 1.631, taken from the continuity run, not recomputed by me; single seed per budget) are above the 20-grid greedy at 4 of 5 budgets (the chapter's reading) and below the 60-grid greedy at all five, so the count reverses with the grid. Five budgets, one seed per budget, one grid: no dispersion for the DE side, and the grid is not declared as a tuning choice. The chapter's own concession (artefact of a coarse grid) applies to its 20-value grid as well, and the word "fine" is not earned. Criterion 3 (robustness, multiplicity, Monte Carlo error). (C2, R11.)
- 10-D7 [4, 5] 10:19-22, 10:340-342, 10:895-900 vs 10:673-679, 10:811-820 -- the introduction promises "the differential evolution that beats them -- and explains why the DE only beats them under one specific condition"; no condition is named and the body shows the warm-started DE below the best feasible greedy at the 1% budget (audit: in 20/20 seeds, 1.340 vs 1.378; chapter run 1.330 vs 1.378) and concludes that an optimiser earns its place only in the last row. 10:340-342 ("the difference between the DE working and not working") overstates the same way. Criterion 5. (R11, R10 in part, C9.)
- 10-D8 [4] 10:409-417, 10:654-668 -- two mechanisms stated as results with no measurement. (i) "The mechanism is dimensional ... it gives the DE something worth improving on": the table at 10:641-652 shows one feasible seed (w = 0, index 0.134) and seven copies of the infeasible truncation plan; no ablation separates which seed matters (the best feasible greedy at 1.378 is not in the grid). (ii) The repair bias is "slight", "has not mattered at these scales": the audit measured 2.74 duplicates per random vector, all repaired members going to one B line (candidates 1-25 share `ped$b == 26`), i.e. a line-usage bias, not a diffuse low-index one, and nothing measures its effect on the DE plans. Criterion 4. (R7, R10.)
- 10-D9 [7] 10:567-573 -- "recorded as finding 7 of `README.md`": README.md has no numbered findings and no cold-start result (grep for cold/warm start/finding 7: empty; audit: `git log -S"finding 7"` empty). The 2500-candidate, n = 100, 4.5e5-evaluation result has no source in the repository. Criterion 7 (and 3, provenance). (R9.)
- 10-D10 [7] 10:734-743 -- De Beukelaer et al. (2018) described as optimising "an allele-coverage objective". I confirmed in the PDF (`reference/papers/Core Hunter 3 flexible core subset selection.pdf`): "configured to maximize E-NE", Table 1 caption "when maximizing the entry-to-nearest-entry", "experiments only for the E-NE measure": a distance-based diversity objective, not allele coverage; the section title "E-NE and A-NE" does not mean A-NE was in the three-way comparison. The ranking, test and datasets are correctly reported (refs B3). Criterion 7. (B1.)
- 10-D11 [1] 10:163-166 -- "Feasibility is arithmetic, not luck": n <= min(L_A, L_B) c is necessary, not sufficient. I simulated the chapter's own walk (rank at random, admit while both parents < c) on complete L_A x L_B factorials, L_A, L_B in 2..6, c in 1..4, n = min(L_A, L_B) c, 20000 draws: the walk returned fewer than n in 1572 (7.9%); the audit got 3.2% under its own design. False as written (harmless at n = 60 vs 100, but it is stated as an identity). Criterion 1. (R15.)
- 10-D12 [1, 6] 10:716-729 -- the reading of the bound. (i) "a bound the function certifies as converged": 09 calls `converged` a stalling criterion on the doubling, not a certificate; recomputed here, `ocs_bound()` = 1.553244, lambda* 68.129, 8000 iterations, converged TRUE (audit: 1.55242 / 1.553244 / 1.55339 / 1.553398 at 4000-32000 iterations, so the flag is plausible at this scale, and CLAUDE.md's "do not report a gap against an uncertified bound" is respected here). At production scale the flag is FALSE in 36/36 rows (recomputed from `bound_certified`: book 1, production 0), which the chapter never mentions although it quotes production numbers. (ii) "A large gap means the optimiser has not converged, not that the problem is intrinsically hard": the gap is to a continuous relaxation of a discrete problem and contains the relaxation's own looseness; it is established as optimiser shortfall only by 10b's search reaching 1.527 (about 1.7% from the bound), which is not cited. (iii) Steps 1-4 at 10:700-713 re-derive 09's equations without citing them. Criterion 1 (a quantity read as one it is not) and 6. (R13, R14, C14.)
- 10-D13 [5] 10:347, 10:504-507, 10:568, 10:851-873 -- "production" means three scales and the capped numbers use a cap that is not the chapter's. Recomputed from the CSV: the benchmark is book (N = 625, L = 50, n = 60, cap 5) and production (N = 10000, L = 200, n = 200, cap 4); 10:347 uses 71 + 71 lines (5041 candidates); 10:568 uses 50 + 50 lines, n = 100. The chapter's own capped truncation is cap 4 at book scale (index 0.820) while the table row quotes greedy_cap 1.112 at cap 5, unlabelled. Also "capped benchmark ... a budget and a per-line cap" at production has alpha 0.31% against the 1% budget (audit): the cap binds, the budget does not. Criterion 5. (R20, R21, C6, C10.)
- 10-D14 [2] 10:47-58 -- declared assumptions omit two that the conclusions use: the index is treated as the truth (every index value is `ctx$index`, no error), and the constraint pins the homozygosity lens only (09 items 3 and 5); and "the index carries error that is correlated with relatedness (@sec-choosing, finding 5)" states one simulation scenario of 07 as a property. Criterion 2. (C18.)
- 10-D15 [1, 5] 10:268-289, 10:293 -- "a grid ... spans six decades around the crossover", "a decade or two above it, every point collapses onto truncation". The grid runs from 1e-5 to 10 and `w_crossover` (computed at k = 31, `S30`, not at n = 60) is about 5e-5 per the audit, so the grid starts at about 0.2x the crossover and is almost wholly above it; the plan is flat only from w = 0.0215, about 2.6 decades above. The numbers inside the chunks are right; the prose describing them is not. (I did not recompute `w_crossover`; the audit did. The two-decade statement is in the chapter's own `flat_from` output.) Criterion 5. (R18.)

NON-DISQUALIFYING OBSERVATIONS (record; with 15 disqualifying failures they are not what decides)

- 10-M1 10:109-120, 10:383-406 -- load-bearing identities only printed (`setequal`, `seed_roundtrip`, `in_range`, `deterministic`), not asserted. (R16)
- 10-M2 10:91-99 -- `sel_random` unseeded; reproducible only through `null_distribution()`'s internal `set.seed(7)`. (R17)
- 10-M3 10:45, 10:52-53, 10:125, 10:52, 10:899 -- "candidate pool" for the candidate set; @sec-genomic-prediction for the standardised index (03:575, 03:680); generic @sec-choosing instead of @sec-choosing-error / @sec-choosing-cost. (R19, C7, C8)
- 10-M4 10:62-73 -- instance chunk prints scientific notation. (R22)
- 10-M5 -- nine orphaned figure files tracked for chunks `unnamed-chunk-{6,13,16}`; downloads and docs stale after any edit. (R24)
- 10-M6 10:255, 10:433, 10:866 -- `max_use` / `cap` / `max_line` never defined once, no statement of the `NULL` default (CLAUDE.md: bit-for-bit pre-cap behaviour), the penalty term for the cap absent from 10:533-538. (C5)
- 10-M7 10:263-289, 10:887 -- index weight written $w$ here and $\omega$ in 09, 07, 90. (C12)
- 10-M8 10:140, 10:264, 10:81-84, 10:822 -- "ceiling" for three things; "truncation is the floor on diversity" against 09's statement that alpha_trunc is not the largest loss an n-subset can reach (not recomputed by me). (C13)
- 10-M9 10:461-517 -- the encoding table is duplicated with 07; the full treatment lacks what 07 reports (slack constraints, pool imbalance). (C16, R2)
- 10-M10 10:346, 10:423, 10:457-459 -- three names for the encoding under test (0/1, key vector, rank keys). (C17)
- 10-M11 10:130-132 -- N_s printed without its reading on molecular f (in [1/2, 1], a rescaling of theta, not a head count); $L_A$, $L_B$ absent from 90. (C19)
- 10-M12 10:758 -- "epsilon-constraint method" without a source (optional; the Haimes et al. 1971 suggestion is unverified, not looked up). (B5)
- 10-M13 10:809-836 -- the figure shows the DE curve below the connected greedy line at every budget; the line interpolates between plans that do not exist and the DE-ahead reading rests on the step table at 10:794-801. (R12 tail)

Non-disqualifying count: 13, well above the threshold of three; this alone would also reject.

Agreement with CLAUDE.md design decisions (not relitigated): the chapter agrees on `ocs_bound()` as the Lagrangian min over lambda (10:707-709, steps correct), on the line encoding not making an evaluation cheaper (10:508-509), on never removing the warm start (10:670-671) and on penalty 1000 on the absolute violation. Two disagreements: the printed `ratio_of_means` revives the 5.7x that CLAUDE.md and 07 tell the book not to restate (10-D2), and `max_use`'s `NULL` default is never stated (10-M6).

STATUS OF EVERY INPUT FINDING (all open; severity as judged here)

| Input | Maps to | Status | Severity |
|---|---|---|---|
| R1 | D1 | OPEN | disqualifying |
| R2 | D2 (+M9) | OPEN | disqualifying |
| R3 | D3 | OPEN | disqualifying |
| R4 | D2 | OPEN | disqualifying |
| R5 | D2 | OPEN | disqualifying (ratio the book withdrew) |
| R6 | D2 | OPEN | disqualifying |
| R7 | D8 | OPEN | disqualifying |
| R8 | D4 | OPEN | disqualifying |
| R9 | D9 | OPEN | disqualifying |
| R10 | D7, D8 | OPEN | disqualifying |
| R11 | D6, D7 | OPEN | disqualifying |
| R12 | D5 | OPEN | disqualifying |
| R13 | D5, D12 | OPEN | disqualifying |
| R14 | D12 | OPEN | disqualifying |
| R15 | D11 | OPEN | disqualifying |
| R16 | M1 | OPEN | non-disqualifying |
| R17 | M2 | OPEN | non-disqualifying |
| R18 | D15 | OPEN | disqualifying (prose against its own numbers) |
| R19 | M3 | OPEN | non-disqualifying |
| R20 | D13 | OPEN | disqualifying |
| R21 | D3, D13 | OPEN | disqualifying |
| R22 | M4 | OPEN | non-disqualifying |
| R23 | = B1 | OPEN | see D10 |
| R24 | M5 | OPEN | non-disqualifying |
| B1 | D10 | OPEN | disqualifying (verified in the PDF) |
| B2, B3 | -- | no finding | citations correct |
| B4 | -- | no finding | not cited in this chapter |
| B5 | M12 | OPEN | non-disqualifying, optional |
| C1 (H) | D5 | OPEN | disqualifying |
| C2 (H) | D6 | OPEN | disqualifying |
| C3 (H) | D2 | OPEN | disqualifying |
| C4 (H) | D2, M9 | OPEN | disqualifying in part (restrictions defined by a circular citation, binding ones not reported) |
| C5 (M) | M6 | OPEN | non-disqualifying |
| C6 (M) | D13 | OPEN | disqualifying |
| C7 (L) | M3 | OPEN | non-disqualifying |
| C8 (M) | M3 | OPEN | non-disqualifying |
| C9 (M) | D7 | OPEN | disqualifying |
| C10 (M) | D13 | OPEN | disqualifying |
| C11 (M) | D3 | OPEN | disqualifying |
| C12 (M) | M7 | OPEN | non-disqualifying |
| C13 (M) | M8 | OPEN | non-disqualifying |
| C14 (M) | D12 | OPEN | disqualifying |
| C15 (M) | D2 | OPEN | disqualifying (part of D2) |
| C16 (L) | M9 | OPEN | non-disqualifying |
| C17 (L) | M10 (and D2) | OPEN | non-disqualifying |
| C18 (L) | D14 | OPEN | disqualifying (criterion 2) |
| C19 (L) | M11 | OPEN | non-disqualifying |

The three continuity findings marked H (C1, C2, C3) and C4 are open H findings under criteria 2 and 5: they reject on their own.

WHAT WAS VERIFIED
- Provenance and encoding CSV: `Rscript` on `book/data/de_constraints.csv` -- hybrid-key mean index 0.35078 (range 0.01420), line-weight mean 1.98776 (range 0.06091); penalty and repair `index` identical in all 3 seeds (`all(==)` TRUE); all 9 rows feasible, violation 0, pool_imbalance 0.
- Benchmark CSV (`book/data/search_benchmark.csv`, 72 rows, 3 seeds per method and scale; N, L, n_sel, cap per scale: 625/50/60/5 and 10000/200/200/4): paired differences `de_hybrid - de_lines`: book 0.3098, 0.2830, 0.3082 (mean 0.3004, s.e. 0.0087); production 0.1060, 0.1682, 0.0567 (mean 0.1103, s.e. 0.0322). Capped: book 0.004138 in all seeds, production 0 in all seeds. Means of greedy_cap 1.11220 / 1.12252; sd 0 in every capped cell. `bound_certified` mean by scale: book 1, production 0.
- Relaxation grid: `chk.R` (scratchpad, `simulate_data(book_cfg)`, n = 60, `null_distribution(B = 400, B_full = 60)`, `pkgload::load_all` of the worktree) -- gd_ref 0.3258386, ceiling 4.1216%; `ocs_relaxation` on the chapter's 10 lambdas: 2 inside 1%, best 1.12895; on 48 lambdas in [1, 158], iters 8000: 7 inside, best 1.520691.
- `ocs_bound(ctx, 60, 0.01, gd_ref)`: 1.553244, lambda 68.12921, iters 8000, converged TRUE.
- Greedy grids (same run): best index with alpha <= alpha_max at 0, 0.0025, 0.005, 0.01, 0.02: chapter's 20-value grid 0.8672, 0.8672, 0.8672, 1.3782, 1.3782; 09's 60-value grid 1.1765, 1.1765, 1.2856, 1.4227, 1.6841.
- Feasibility counter-example: `feas.R`, `set.seed(1)`, 20000 random complete factorials, n = min(L_A, L_B) c: walk short in 1572 (7.9%).
- `decode_rank()` ignores `max_use`: R/04_fast_metrics.R:394 read.
- README: grep for "cold", "warm start", "finding 7", numbered findings: no match in README.md.
- De Beukelaer et al. objective: `pdftotext` on the PDF in `reference/papers/`, lines 593, 622, 671 ("configured to maximize E-NE", "when maximizing the entry-to-nearest-entry", "experiments only for the E-NE measure").
- Taken from the audit and not re-run here because the arithmetic was easy to check against the CSV or the code and agreed: penalty 1000 on the absolute violation (read R/03_de_select.R:177-192 by the audit), the unlabelled-tolerance tables in the baselines section (inline numbers).

NOT VERIFIED
- 20-seed warm vs cold results (D4, D7: warm 1.340 +/- 0.0225, cold 1.201 +/- 0.0291, paired 0.139, DE below greedy 20/20, DE ahead of greedy at 17 of 20 seed-budget cells) -- audit's 140 `sel_de` runs, about 8 minutes on 8 cores; I did not rerun them. D4 does not depend on them: a standard deviation from n = 3 cannot support the claim, whatever the 20-seed value.
- Repair-bias measurement (D8 ii: 2.74 duplicates, all to B line 26) -- audit's, not rerun.
- `w_crossover` 5.4e-5 and `flat_from` 0.0215 (D15) -- audit's; the chunks that print them are the chapter's own.
- "Truncation is not the floor on diversity" (M8) -- taken from 09's statement; not recomputed.
- The 4.5e5-evaluation cold-start result at 2500 candidates (D9) -- no source exists in the repository; it cannot be verified.
- Knit of the whole chapter (about 6 min) was not repeated; I relied on the audit's knit plus the targeted recomputations above.
- Haimes et al. 1971 (M12) -- not looked up by anyone.
