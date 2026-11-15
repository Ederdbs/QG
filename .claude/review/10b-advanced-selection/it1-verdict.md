# 10b-advanced-selection -- verdict, iteration 1

Chapter: `book/10b-advanced-selection.qmd` (1340 lines). Worktree `/Users/ederdbs/Documents/SB_quanti_gen-review-04-06`
(HEAD 172ec6c plus uncommitted edits; package loaded with `pkgload::load_all` from the worktree). Read: the chapter, `it1-audit.md`,
`it1-refs.md`, `it1-continuity.md`, `THREAD.md` (09 entry, owed lines). Chapter 10 is OPEN after 3 iterations; 10b is judged on its own text,
and 10 is cited only where 10b states something 10 contradicts. CLAUDE.md design decisions are not relitigated (see "Design decisions kept").

VERDICT: REJECTED

PREVIOUS IDS (re-review only)
- None (iteration 1). The audit/continuity/refs IDs (10b-R, 10b-C, 10b-B) are mapped to the verdict IDs below; every one is listed at the end.

DISQUALIFYING FAILURES

- 10b-D1 [criterion 5, 1, 6] 10b:291-297 and 10b:1103-1114 (`f-free-routes`, @sec-ffree) -- The prose describes a behaviour the package no longer has
  and that the chapter's own table contradicts. It says `theta_group()` "`$` partial-matches `ctx$fL`", "what surfaces is `subscript out of bounds`",
  "measured in @sec-ffree", and that a small selection "would have returned a diversity computed from the wrong matrix, silently". Reproduced on the
  worktree: `theta_group()`, `alpha_loss()`, `null_distribution()`, `sel_local_search(start = NULL)` and `ocs_round()` on a context without `f`
  return `ctx[["f"]] (hybrid coancestry) is missing` (guard at `R/01_metrics.R:21-22`); `sel_greedy()` returns `argument is of length zero`. The
  table the chapter prints therefore says the opposite of the paragraph under it, and the claim "measured" is false (the frozen html.json still holds
  the old message; the knit does not). The "silent wrong matrix" statement is a hypothetical about a state that no longer exists, stated as a hazard of
  the current code. Owner 10b (audit R1, continuity C18).

- 10b-D2 [criterion 1, 3, 4] 10b:644-647, 672-677 (@sec-bound, chunk `bound` falsification) -- (a) "nothing makes it the best index achievable *at* that
  diversity. A discrete plan can beat it, and does" contradicts 09 @eq-ocs-weak: a relaxation point bounds every plan at least as diverse as itself,
  so at equal diversity a plan cannot beat it (owed 09-M12b, still unedited). (b) The "falsification" is a grid artefact, and the chapter does not say so.
  Recomputed (book ctx, gd_ref 0.3258386, B = 400): in the 12-point grid the point the "old bound" uses at the 1% budget has alpha = 0.820% (lambda 81.1,
  index 1.4879 at 2000 iterations) -- strictly inside the budget -- and the 0.25% and 0.5% rows use one and the same point (alpha = -0.805%, index 0.8459),
  so the four rows are not four independent refutations. With a 200-point grid on lambda in [10, 158], 4000 iterations, the best relaxation point inside
  the 1% budget sits at alpha = 0.9933%, index 1.5376, lambda 80.08, which is above the chapter's feasible plan 1.5202 (recomputed: 1.520217): the old
  construction is a bound once the point is at the budget, exactly as @eq-ocs-weak says. What the experiment shows is that the last grid point inside a
  budget is below a plan that spends the budget -- a statement about finite grids. (c) `feasible_plan` is described as "the best plan any method in this
  book could find"; it is the best of eight plans (one annealed local search, seven greedy weights). The section title, the callout and the Lagrangian
  statement can stay (the construction as used was invalid); the mechanism is stated wrongly. Owner 10b (audit R2, continuity C2).

- 10b-D3 [criterion 3, 4] 10b:339-341, 385-410, 1301-1308 (hill versus anneal "ordering that flips with the budget") -- The sign flip rests on 3 seeds. Recomputed
  over 20 seeds (seeds 1:20, same call as `ls-modes`, book ctx): hill minus anneal = +0.93 thousandths (s.e. 1.41) at 20,000 moves, hill > anneal in 10/20;
  -0.91 thousandths (s.e. 1.10) at 30,000 moves, hill > anneal in 8/20. Neither differs from zero; the 3-seed +6.2 thousandths that the chapter calls "not noise
  at that budget" is not reproduced, and the cached 30,000-move cell (-0.2 thousandths, 3 seeds, within-mode s.d. 1.2-3.9) lies far inside its own dispersion.
  "That ordering is therefore a property of the move budget and not of the schedule" (10b:405-406) and "the sign of the difference changing" in protocol step 4
  (10b:1307) are interpretations presented as results about a difference that is zero within error. Further, "the two panels are read against the same draws"
  (10b:340) is false: same seeds, different `iters`. The part that stands: tempering below both (verified in the audit over 20 seeds; not re-run here).

- 10b-D4 [criterion 3, 4] 10b:476-496 (@sec-localsearch, move-versus-schedule) -- "What moves the index at both scales is the neighbourhood" is a causal claim the
  design cannot carry. The arms differ in the whole algorithm (swap neighbourhood + annealing + greedy-sweep warm start against DEoptim operators + a different
  warm start); no arm runs the same search on the other neighbourhood. The ratio (11.7x, 2.9x) divides a method difference by the spread of three schedules that
  includes tempering's split-budget artefact (10b:393-396). The DE arm is NP 100 x itermax 300 = 30,000 evaluations, stated nowhere in the chapter, and `sel_de()` at
  larger budgets passes the greedy and the fine sweep (10: 120,000 and 600,000 evaluations; `R/03` roxygen 1.481 at the default budget against 1.360 here), so
  "DE below greedy", the caption "the differential evolution reaches only 1.45 after two seconds" and "not the obvious choice, and never was" (10b:513-515) are
  claims about a stated-nowhere budget. The cost argument (10b:256-272) supports the mechanism for time, not for index. Audit R4, continuity C10.

- 10b-D5 [criterion 3, 5] 10b:435, 1145, 1163-1176, 1256-1269, 1294-1296 -- Replication and the "winner" claims. The independent unit in `search_benchmark.csv` is the
  optimiser seed on ONE simulated dataset per scale (3 rows per method). Recomputed from the CSV: `greedy`, `greedy_cap`, `ocs_round`, `ocs_round_cap` have s.d. exactly
  0; every capped arm has s.d. 0 at production; production capped indices are 1.1225 (greedy_cap) against 1.1223 (tempering_cap = de_hybrid_cap = de_lines_cap =
  ocs_round_cap) -- a 0.2-thousandth difference with no dispersion at all; book capped greedy_cap 1.1122 against de_hybrid_cap 1.1097 on one dataset. The text
  nevertheless says the capped greedy has the "highest index of any capped route at both scales", "tops them", "the winner" and "a cap this tight leaves the optimiser
  nothing to find", while 10 reads the same rows as a tie at production. The captions say "mean of 3 seeds" without saying one dataset and zero dispersion for
  deterministic rows. The anytime figure is one seed per arm and one independent DE run per budget. Two chapters, same rows, two verdicts (criterion 5).

- 10b-D6 [criterion 1, 3, 6] 10b:608-634, 1252, 1270 (@sec-defast-restrictions) -- (a) `pool_A` is identically 0.5 for ANY set of A x B crosses, not only in a complete factorial:
  `make_fitness_fast()` computes the share of line uses in pool A (`R/04_fast_metrics.R:416-419`) and every hybrid has one pool-A and one pool-B parent. Recomputed:
  5 random 60-subsets of the book candidates give 0.5 each. So 10b:631-633 ("an incomplete factorial where pool balance is a real degree of freedom") is false and the table row
  "Ne floor, pool balance" (10b:1252) recommends a route for a restriction that cannot bind. (b) The one niche left, an N_e,par floor, was run and the route failed it.
  Recomputed (`set.seed(7)`, NP 100, itermax 300, cap 5, pool_tol 0.05): floors 20, 25 and 30 all return index 1.105585, alpha 0.8859%, N_e,par 25.714. The floor of 30 binds
  and is violated by 4.3; the chapter's own wording ("met with room to spare at 20 and 25 [25.71 against 25 is 0.71], missed at 30 with a penalty that does not recover it")
  concedes it and then recommends the route "when ... an N_e,par floor actually binds". A feasible plan exists: the capped greedy sweep (cap 5, 26 weights, recomputed) has 5 plans
  with alpha <= 1% and N_e,par >= 30 (best index 0.6731), which on `make_fitness_fast`'s own penalised objective (penalty 5, floor 30: DE plan 1.1056 - 5 x (30 - 25.71)/30 = 0.391)
  beats the DE plan. "Accepts" is not "satisfies". (c) "The swap neighbourhood cannot test" an N_e,par floor is false as a structural statement: `theta_state()` carries the count vector, so
  N_e,par = (2n)^2 / sum(cnt^2) is O(1) per swap; what is missing is an `ne_par_min` argument. Same recommendation in 07:1049-1077 and 10:874 (cross-chapter, C20). Audit R6, continuity C11.

- 10b-D7 [criterion 3, 5] 10b:522-526 and 10b:1324-1328 -- "the measured difference between [sel_de and sel_de_fast] is small and runs the other way". Paired over seeds (recomputed from
  `search_benchmark.csv`, de_hybrid minus de_lines, index): uncapped book +0.3004 (s.e. 0.0087; seeds 0.3098, 0.2830, 0.3082); uncapped production +0.1103 (s.e. 0.0322; 0.106, 0.168,
  0.057); capped book +0.0041 (s.e. 0), capped production 0 (s.e. 0). Uncapped, "small" is wrong: 0.30 exceeds the 0.168 local-search-minus-best-DE gap that 10b calls decisive (10b:481).
  "It goes the other way" is never given a number or a scope (uncapped / capped, book / production, 3 seeds, 30,000 evaluations), and 10 (10:906-962) scopes the same pairing and delegates the
  head-to-head to 10b, which does not pair the arms. Audit R9, continuity C4.

- 10b-D8 [criterion 7] Attributions the sources do not carry.
  (a) 10b:1239 -- "log det(I + beta f_S) ... is genuinely submodular and monotone, so its greedy carries a 1 - 1/e guarantee [@chen2018]". Fetched arXiv 1709.05135 and searched the text:
  it says the DPP log-probability is submodular and that greedy has "relatively weak theoretical guarantees"; neither "monotone" nor 1 - 1/e appears. The mathematics is defensible
  (eigenvalues of I + beta f >= 1, @nemhauser1978 under cardinality) but it is the book's own derivation and is attributed to the wrong paper (refs B2).
  (b) 10b:501-504 -- "@debeukelaer2018 found a plain stochastic hill-climber already competitive with a considerably more complex genetic algorithm". Read in the PDF on disk (Core Hunter 3,
  BMC Bioinformatics 19:203): "Although the genetic algorithm also outperforms random descent, it is not as effective as parallel tempering"; the conclusion is that "a basic stochastic
  hill-climber (random descent) already yields high-quality cores and a global optimization engine (genetic algorithm) did not provide any further advantage", and the GA uses random
  descent as its mutation operator. The comparison that supports the chapter's sentence is GA against parallel tempering; GA beat random descent in the paper. "Considerably more complex" is the
  book's gloss (refs B3).
  (c) 10b:1241-1243 -- "@sec-catalogue's rule applies: one diversity lens, chosen deliberately, reported against a null". Grep of 06 finds no such rule (the null is @sec-catalogue-null, the lenses are
  @sec-genomic-era's); the statement is 09 assumption 5 / 10 assumption 3 (owed 06-C13, 09-M12b, still unedited; continuity C1).
  (d) 10b:506-509 (Yadav et al. 2025) -- the AUCs 0.879/0.860/0.820/0.769 are for the OPV fitness function only (refs B4); "two to three times slower" is not in the text read by refcheck and I could not
  confirm it: unsupported. 10b:1226-1229 (Younis et al. 2024) -- "when to recycle" and "its successors" are not in the paper (refs B5); unsupported. 10b:181, 208 (Fisher et al. 1978, 1/(p+1))
  full text unreachable (refs B6): not decisive, listed under NOT VERIFIED. 10b:1209-1243 name NSGA-II and DPPs and state "worse quality per point" with no source (refs B10).

- 10b-D9 [criterion 5] 10b:125 -- the objective is written "lambda sum u_i - sum f_ij": lambda weights the index. Everywhere else in the chapter (10b:644, 689, 699, 701, 779-782), in 09 (@eq-ocs-V) and in 90,
  lambda multiplies c'fc; the symbol for the index weight is omega (90:303), reciprocal to lambda. A redefined symbol in the first equation that introduces the objective; the same defect 10-D18 closed in 10.

- 10b-D10 [criterion 1, 4, 5] 10b:683, 716, 719-727, 733, 1198, 1311-1313 and 10b:810-816 (@sec-bound, "certified") -- (a) The chapter calls `converged == TRUE` a "certificate", the bound "certified" and further effort
  "provably wasted"/"stop". `converged` is a stalling criterion on the doubling (relative change < 1e-3 of the min over the lambda grid, `R/12_search.R:344-348`); 09:263-265 and 10:1289-1293 call it "not a certificate". The same
  word has two meanings across the Optimisation part; "provably" and "stop" are stronger than the criterion supports. (b) 10b:719-727 says the two numbers in the first two rows of the `certified-bound` chunk are
  "the same formula at two iteration counts" and attributes the whole 1.2% difference to the under-convergence. The chunk's own row labels show the grids differ as well (`hand_12_lambdas_2000_iters` against
  `ocs_bound` with 25 multipliers); the audit decomposition (12/2000 = 1.5355, 12/8000 = 1.5399, 25/2000 = 1.5468, 25/8000 = 1.5532, not re-run by me) puts the larger share on the grid, which has no systematic sign.
  The same attribution is reused at 10b:812-816 ("more than a point tighter than the truth"). (c) 10b:808-810 says the B = 400 against B = 500 reference changes the bound "in the fourth decimal"; the values
  (1.5532, 1.5543 per the audit/continuity) differ in the third decimal.

- 10b-D11 [criterion 5, 1] Hand-typed numbers and ratios the data contradict.
  (i) 10b:182 "the measured gap is around 1%": book-scale gap to the Lagrangian bound is 1.72% (anneal), 1.73% (hill), 2.64% (tempering) (recomputed from `search_benchmark.csv`: 1.718, 1.733, 2.645).
  (ii) 10b:415 "one evaluation costs seventeen times what another does": no source; cached ratios hybrid/swap 2.4 to 31.5 (N = 400 to 10,000), 10.6x and 9.8x at book scale (audit, not re-run by me).
  (iii) 10b:419 fig-cap "Local search is at 1.52 within a tenth of a second": from `search_anytime.csv` (recomputed), hill reaches 1.52 at 0.103 s, anneal at 0.22 s, tempering at 0.41 s; best within 0.1 s is
  1.517 (hill), 1.439 (anneal), 1.488 (tempering). True of one mode, narrowly. (iv) 10b:448-452: "at production scale the same ratio is what decides whether a frontier of ten budgets is an afternoon or a minute" --
  recomputed from the CSV, production seconds are greedy 0.221, hill 0.341, anneal 0.343 (1.5x, not 29x), and the greedy is 17% below hill there (1.5002 against 1.8162): the sentence is contradicted by the table
  at 10b:1139-1145. (v) 10b:444-452 "swept finely over w reaches 1.378" and "9.8% below the leading method": the benchmark grid is 20 values; 09 and 10 report 1.4227 for the fine grid at the same budget and scale
  (6.9% below 1.5276). Two greedy numbers for one budget and scale exist in the book, the table does not say which grid it is, and the percentage is against the coarse one (continuity C8). (vi) 10b:1234
  "Ours costs 5 microseconds": the swap costs 4.2 us at N = 10,000; the fitness DE or BO would call costs 132-169 us (the table at 10b:261-266).

- 10b-D12 [criterion 3, 6] 10b:939-958 (@sec-oa) -- The exact-oracle reading goes beyond its evidence. "The heuristic is not leaving anything on the table at all" rests on three budgets of one N = 36 instance
  (n = 8, one dataset, one tempering run); the next paragraph limits the scale but not the instance count. "And would not [converge] at production scale either" is a prediction with no run (the book scale, 4 cuts in 300 s,
  is the only measurement); "the number of cuts needed grows fast" is unmeasured (20-73 cuts at N = 36, 4 at N = 625 time-limited). "Evidence that the move ... right" does not test the move under a cap (the oracle runs carry no
  `max_use`). Omitted: at book scale the oracle's dual bound (1.6995 at 1%) is looser than the Lagrangian one (1.554), so the 10.1% gap against the oracle sits beside 1.7% against the other for the same plan, and two
  different bounds are both called "certified" in the chapter (10b:957). Audit R11, continuity C19.

NON-DISQUALIFYING OBSERVATIONS
(More than three; under the rule, they reject independently as well.)

- 10b-M1 10b:91-104, 118-123, 154-162, 1085-1090 -- identities the prose asserts are printed, not asserted (Gram identity and eigenvalue sign, submatrix identity, matroid counts, `with_f_start_NULL` = `no_f_start_given`).
  Audit R7.
- 10b-M2 10b:914-920 -- `exact-budget` chunk prints `structural_rows = 1 + n_lines`, the capped-model count, at N = 625 beside a table whose tiny rows are N = 36 and carry no `max_use` (R12).
- 10b-M3 10b:79-80 -- "none of which has been stated in this book so far": the Gram form of `f` is stated and asserted in 03 (`tcrossprod(cbind(X, 1 - X)) / m`, 03:147-148) and 05 (R15).
- 10b-M4 10b:434-443, 1294-1296 -- the `gap to bound %` of the capped rows (about 28%) is against an uncapped bound (10b:857-859 says it goes loose under a cap); caption and prose present the column as "the only column that says
  whether the leader is near optimal" without the qualifier (R17).
- 10b-M5 10b:1206-1222 -- "worse quality per point", "which the sweep currently throws away": unmeasured design opinions stated as facts (R18; also refs B10, uncited NSGA-II / DPP / epsilon-constraint).
- 10b-M6 10b:1010-1021 -- "That number is the rounding and nothing else": the 157 ms includes ten per-lambda frontier evaluations and `alpha_loss()` against the 0.745 GiB matrix; not measured which dominates (R19).
- 10b-M7 10b:1252, 1293 -- `w` for the greedy index weight where 09, 10 and 90 write omega, and `w` also names the line-usage weight vector within 10b (C6); 10b:165-166 `c` for the cap and `c` for contributions where 10 uses k_max (C7).
- 10b-M8 10b:1245-1274 and 10:1540-1565 -- two strategy tables recommend different optimisers for "a budget a grid steps over" (C14); 10b's table has no row for it.
- 10b-M9 10b:685-693 -- the Lagrangian bound is derived a third time (09:223-243, 10:1276-1294) without citing @eq-ocs-bound / @eq-ocs-weak; `ocs_round()`'s line merit and `upper = max_use/2n` redefined without a pointer to @sec-ocs (C16).
- 10b-M10 10b:710 and elsewhere -- `ocs_bound()` default grid (25 values) not printed where a bound is quoted (C13); "book scale" against "teaching scale" (C17).
- 10b-M11 provenance -- the four CSVs and two figures are called "cached" and nowhere said to be output of `regenerate.R search` / `search_exact`, reproducible in the repository (they are: I did not rerun the producers, the audit did and
  reproduced the deterministic cells), with timings from one machine and `sel_exact()` / `ocs_quadprog()` needing `highs` / `quadprog` (`Suggests`) (R14). Not a failure of criterion 3's provenance clause (none is external), but the reader cannot tell.

WHAT WAS VERIFIED
- f-free table after the R/01 guard -- worktree `pkgload::load_all`, script `scratchpad/v/c1.R`: `theta_group`, `alpha_loss`, `null_distribution`, `sel_local_search(start=NULL)`, `ocs_round` ->
  `ERROR: ctx[["f"]] (hybrid coancestry) is missing`; `sel_greedy` -> `ERROR: argument is of length zero`. Contradicts 10b:291-297, 1103-1114.
- 200-point lambda grid at the 1% budget -- c1.R, book ctx, gd_ref 0.3258386: best relaxation point inside the budget alpha = 0.9933%, index 1.5376 (lambda 80.08), >= feasible plan 1.520217. (Audit: 0.986%, 1.5356, a slightly different grid.)
  12-point grid (chapter's): 1% -> alpha 0.8199%, index 1.4879; 0.25% and 0.5% both -> alpha -0.8049%, index 0.8459 (same point).
- `pool_A` identically 0.5 -- c1.R, `set.seed(3)`, 5 random 60-subsets: 0.5 0.5 0.5 0.5 0.5; `R/04_fast_metrics.R:416-419` read.
- Ne floor 30 with `sel_de_fast` -- `scratchpad/v/c3.R`, `set.seed(7)`, NP 100, itermax 300, cap 5, pool_tol 0.05: floors 20, 25, 30 -> index 1.105585, alpha 0.8859%, N_e,par 25.71429, max_line 5, pool_A 0.5. Capped greedy sweep
  (26 weights): 5 plans with alpha <= 1% and N_e,par >= 30, best index 0.6731.
- hill versus anneal, 20 seeds -- c3.R: 20,000 moves, +0.925 thousandths (s.e. 1.413), hill > anneal in 10/20; 30,000 moves, -0.915 thousandths (s.e. 1.102), 8/20.
- Paired sel_de minus sel_de_fast from `search_benchmark.csv` -- `scratchpad/v/c2.R`: uncapped book +0.3004 (s.e. 0.0087), uncapped production +0.1103 (0.0322), capped book +0.0041 (0), capped production 0 (0).
  Deterministic and capped rows have s.d. 0; production capped means 1.1225 / 1.1223 / 1.1223 / 1.1223 / 1.1223; book gaps to the Lagrangian bound 1.718 (hill), 1.733 (anneal), 2.645 (tempering); production seconds greedy 0.221,
  hill 0.341, anneal 0.343.
- `search_anytime.csv` -- hill >= 1.52 first at 0.103 s, anneal 0.22 s, tempering 0.413 s; DE best within 2.1 s 1.448.
- De Beukelaer et al. 2018 -- `pdftotext` of `reference/papers/Core Hunter 3 flexible core subset selection.pdf`, lines 598-602 and 983-1010: GA "outperforms random descent ... not as effective as parallel tempering"; conclusion as quoted in D8(b).
- Chen et al. 2018 (arXiv 1709.05135, fetched, `pdftotext`, grep): no "monotone", no 1 - 1/e; "relatively weak theoretical guarantees". Nemhauser 1978 as the source of 1 - 1/e under cardinality is per refs B7 (abstract) -- the chapter's
  own use at 10b:181, 192, 208 is correct and the DPP derivation (eigenvalues >= 1) is algebraically sound.
- `@sec-catalogue` grep in 06: no statement of "one diversity lens ... reported against a null"; 09:264 and 09:427 call `converged` a stalling criterion; `ocs_bound()` code (`R/12_search.R:336-352`) read.

NOT VERIFIED
- Decomposition of the 1.2% hand-sweep / `ocs_bound()` gap into grid and iteration effects (audit R10): reported by the audit, not re-run here (the grid difference is visible in the chunk itself, which suffices for D10b).
- Tempering below hill and anneal in 20/20 seeds at 20,000 moves (audit); not re-run here.
- "Seventeen times" and the 10.6x / 9.8x book-scale ratios (audit measured at N = 625); not re-run.
- Yadav et al. 2025 "two to three times slower than GA" (refs B4) and Younis et al. 2024 "when to recycle", "successors" (B5): unsupported by the text refcheck read; figures/tables unread. Fisher et al. 1978 (1/(p+1)), Minoux 1978, Duran and Grossmann 1986
  (B6, B8, B9): full text unreachable. None decisive alone; D8 stands on (a), (b), (c).
- The knit (4.5 min) was not repeated; the chapter's own outputs were taken from the audit's knit (every `stopifnot` passes) and from the targeted recomputations above. `quarto render` not run; Typst/HTML layout out of scope.
- Behaviour at N = 10,000 and at 71 + 71 lines: only the cached CSV rows exist; the production-scale convergence flag (FALSE) is read from the cache.

DESIGN DECISIONS KEPT (CLAUDE.md, not relitigated)
- The line encoding does not make an evaluation cheaper (10b:256-272, numbers from `search_scaling.csv`); `ocs_bound()` is the Lagrangian bound, not "best relaxation point" (10b:685-706, and D2 concerns only the wording of
  why); `max_use` default NULL; `sel_exact()` is an oracle, outer approximation, `mip_dual_bound`; NULL never means a cold start. All agree with the chapter.

OPEN FINDINGS BY SOURCE (every audit R, refs B and continuity C finding mapped; severity as used by the originating report, with the verdict mapping)
Audit R:
- R1 (H) -> 10b-D1. R2 (H) -> 10b-D2. R3 (M, rated D here) -> 10b-D3. R4 (M, rated D) -> 10b-D4. R5 (M, rated D) -> 10b-D5. R6 (H) -> 10b-D6. R7 (M) -> 10b-M1 (non-disqualifying).
- R8 (M, rated D) -> 10b-D10(c), D11. R9 (M, rated D) -> 10b-D7. R10 (M, rated D) -> 10b-D10. R11 (M, rated D) -> 10b-D12. R12 (L) -> 10b-M2. R13 (L, owed) -> 10b-D8(c) and (a). R14 (M) -> 10b-M11.
- R15 (L) -> 10b-M3. R16 (L) -> NOT VERIFIED / refs B4, B5 (D8(d)). R17 (L) -> 10b-M4. R18 (L) -> 10b-M5. R19 (L) -> 10b-M6.
Refs B:
- B1 (bib pages of ahadi2024, 80--90 against Heredity 133(2):113-125): OPEN, bibliographic, owner `references.bib`; not decisive. B2 (chen2018 attribution) -> 10b-D8(a), OPEN, disqualifying. B3 (debeukelaer2018) -> 10b-D8(b), OPEN, disqualifying.
- B4 (yadav2025) -> 10b-D8(d), OPEN, unsupported detail. B5 (younis2024) -> 10b-D8(d), OPEN, unsupported detail. B6, B8, B9 (fisher1978, minoux1978, duran1986): UNVERIFIED, not decisive. B7 (nemhauser1978): abstract-level, consistent.
- B10 (NSGA-II, DPP, epsilon-constraint, BO uncited) -> 10b-M5 / D8(d).
Continuity C:
- C1 (H) -> 10b-D8(c). C2 (H) -> 10b-D2. C3 (H) -> 10b-D10. C4 (H) -> 10b-D7. C5 (H) -> 10b-D9. C6 (M) -> 10b-M7. C7 (M) -> 10b-M7. C8 (M, rated D) -> 10b-D11(v). C9 (M, rated D) -> 10b-D5 (and the pointer to the wrong subsection at 10b:1270).
- C10 (M, rated D) -> 10b-D4. C11 (M, rated D) -> 10b-D6(c). C12 (M, owner 09, EARLIER-NOW): not a 10b failure; 09:242/266 point to @sec-bound where the claim is in @sec-scaling -- fix in 09 (and 03:473 to add @sec-oa).
- C13 (L) -> 10b-M10. C14 (M) -> 10b-M8. C15 (L, rated D) -> 10b-D11(ii). C16 (L) -> 10b-M9. C17 (L) -> 10b-M10. C18 (L) -> 10b-D1. C19 (L) -> 10b-D11, D12.
Owed to other chapters from this verdict: 07:1049-1077 and 10:874 (D6: pool balance vacuous, floor 30 unmet); 10:962 / 10b delegation of the DE-encoding head-to-head (D7); 09:242/266 pointer (C12); `R/12_search.R:116-117` "about 5 microseconds ... against 85" (D11(vi)).
