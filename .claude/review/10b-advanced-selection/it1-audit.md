# 10b-advanced-selection -- iteration 1 audit (read-only)

Chapter: `book/10b-advanced-selection.qmd` (1340 lines). Worktree HEAD 172ec6c plus the uncommitted edits already in the tree
(10b diff vs HEAD: the 10-review edits at 10b:42-50, 519-526, 638, 746-749). Line numbers are those of the worktree file.

Method. The chapter was knitted end to end against the worktree package (`pkgload::load_all`, scratchpad, not rendered): 4.5 min,
every `stopifnot()` passes (swap identity, zero-weight decode, `gd_free`). Cached files were read; the cheap producers were re-run
(below). Extra numerical checks were run where a claim is stochastic or timed. `highs` and `quadprog` are installed here; both are
`Suggests` (`sel_exact()` needs `highs`; `ocs_quadprog()`/`ocs_round()`/`ocs_bound()`-adjacent code needs `quadprog`). The chapter
runs `sel_exact()` nowhere (its table is a cached CSV) and runs `ocs_quadprog()` live (`10b:785`, `1068`).

Severity: H = a statement the chapter's own output or the package contradicts; M = unsupported or mis-attributed claim; L = wording,
hygiene, owed pointer.

---

## Findings

### 10b-R1 (H) -- 10b:291-297, 1103-1114: the "partial-matching" account of the f-free failures is out of date
The chunk `f-free-routes` now returns (executed here)
`ERROR: ctx[["f"]] (hybrid coancestry) is missing` for `theta_group()/alpha_loss()`, `null_distribution()`, `sel_local_search(start = NULL)`
and `ocs_round()`, and `argument is of length zero` for `sel_greedy()`. The prose says the opposite: `theta_group()` "is
`mean(ctx$f[idx, idx])`, and with no `f` in the list that `$` partial-matches `ctx$fL`", "what surfaces is `subscript out of bounds`"
(10b:1103-1108), "Had the selection been small enough to index a 20 x 20 matrix legally, the same line would have returned a diversity
computed from the wrong matrix, silently" (10b:1112-1114), and 10b:293-297 ("fails -- `subscript out of bounds`, measured in
@sec-ffree"). Cause: commit 90e7966 (ancestor of HEAD) replaced `ctx$f` by `ctx[["f"]]` and added
`if (!is.matrix(f)) stop(...)` (`R/01_metrics.R:21-22`); there is no `ctx$f` left in `R/` (grep). `book/_freeze/.../html.json` still
holds `subscript out of bounds` (frozen before the guard was relied on), so the contradiction appears only at the render batch.
Fix: rewrite both passages as the package's current behaviour (loud failure with a named message; `sel_greedy()` dies on a `NULL`
`f`), and keep the trap as history ("before 90e7966 `$` partial-matched `ctx$fL`; CLAUDE.md records the rule"). The table, the
`gd_free` identity and the recipe in 10b:1116-1125 stay true. The `ls_warm_start` "alpha_loss unguarded" sentence (10b:291-295) is also
no longer a finding about the ranking -- the same guard fires. Owner: 10b.

### 10b-R2 (H, owed 09-M12b) -- 10b:638-647, 672-677, 735-750: "falsification" of the old construction is a grid artefact; the wording is wrong by 09 @eq-ocs-weak
10b:644-647 ("nothing makes it the best index achievable *at* that diversity. A discrete plan can beat it, and does") is false at equal
diversity (09:223-243; `R/12_search.R` roxygen now says so). Executed here: in the chunk's 12-point grid the point used by the "old
bound" is lambda = 81.1 at alpha = 0.82% (budget 1%) -- strictly inside the budget -- and for the 0.25% and 0.5% budgets the same
lambda = 187 point (alpha = -0.80%), which is why `old_bound` is 0.8459 in both rows. With a 200-point lambda grid on [10, 158], 4000
iterations, the best relaxation point inside 1% sits at alpha = 0.986% and has index 1.5356 >= the feasible plan 1.5202 (the chunk's
own `feasible_plan` at 1%): the old construction holds, as @eq-ocs-weak says, once the point is at the budget. So `old_valid = FALSE`
shows that a finite grid's last point inside the budget is below what a plan spending the budget can reach (10 already found the same,
10-audit item on 10:826), not that the quantity is "not a bound" in general.
Fix (the owed edit plus its consequence): (a) replace 10b:644-647 by the 09 statement -- a plan that spends the budget is less diverse
than a relaxation point strictly inside it and can beat it; at equal diversity it cannot (@eq-ocs-weak); (b) print `a_rel` of the point
each `old_bound` uses, so the reader sees "inside the budget by x points"; (c) 10b:672-677 "the 'bound' is below a plan that exists,
which is a contradiction": keep, but say it is the grid; (d) 10b:672 "`feasible_plan` is the best plan any method in this book could
find" -> "the best of the eight plans in the chunk (one annealed local search, seven greedy weights)"; (e) the callout 10b:735-750 and
the section title stay (the construction as used was invalid), cite @eq-ocs-weak and @eq-ocs-bound for why the valid statement is the
Lagrangian one. Cross-chapter: `92-verification.qmd:257` lists "the invalid-versus-Lagrangian bound comparison" for 10b; keep true.

### 10b-R3 (M) -- 10b:339-341, 385-410, 1301-1308: the hill-versus-anneal "ordering that flips with budget" is noise
Executed over 20 seeds (book ctx, gd_ref 0.32584, same call as `ls-modes`, seeds 1:20): hill minus anneal = +0.93 thousandths
(s.e. 1.41) at 20,000 moves and -0.91 thousandths (s.e. 1.10) at 30,000; hill > anneal in 10/20 and 8/20 seeds. Neither differs from
zero. The chapter's seeds 1:3 give +6.2 thousandths ("more than the 3.7-thousandth within-mode standard deviation, so not noise at that
budget"), which the 20-seed run does not reproduce; the cached 30,000-move cell (-0.2 thousandths, 3 seeds, within-mode s.d. 1.2-3.9)
is far inside its own dispersion. Hence 10b:397-406 ("does not survive a change in budget ... a property of the move budget") and
10b:1303-1308 ("sign of the difference changing") are claims about nothing. What is supported (20 seeds, 20,000 moves): hill 1.5227,
anneal 1.5218, tempering 1.4997; s.d. 0.0037, 0.0039, 0.0069; tempering below both in 20/20 seeds -- so "tempering behind both" (10b:390-391)
holds and the chapter may say so with n = 20. Fix: state hill and anneal are indistinguishable at both budgets (paired difference
and s.e. over a stated number of seeds), drop the sign-flip sentences and the `hill_minus_anneal` column's "sign changing" reading
(10b:1303-1308). Also 10b:339-341 "so the two panels are read against the same draws" -- same seeds, different `iters` (20,000 vs
30,000), so not the same draws. Repro script: scratchpad `hill_anneal.R`, `extra10b.R` (E).

### 10b-R4 (M) -- 10b:476-496: "what moves the index is the neighbourhood" is not isolated by the comparison
The comparison is `sel_local_search` (swap, annealing, warm start from the greedy sweep) against `sel_de` / `sel_de_fast` (DEoptim
operators, a different warm start, 30,000 evaluations = NP 100 x itermax 300, `regenerate.R:313-324`). It varies the whole algorithm,
not the neighbourhood; no arm runs the same search on the decode move (nor DE on the swap). The ratio the text computes (11.7x book,
2.9x production) divides a method difference by the spread of three schedules that includes tempering's split-budget artefact (10b:393-396).
Also the DE budget is never stated in the chapter text, and `R/03_de_select.R` roxygen records that at the default 600,000 evaluations
`sel_de()` reaches 1.481 (10 seeds, 1% budget, book scale) against 1.360 here -- the chapter's DE arm is a budget-limited result, as
the 10 review already established (10 it1 response, DE budget item). Fix: say the DE arm is NP 100 / itermax 300, point to 10's 120,000- and
600,000-evaluation runs, and soften the causal sentence to "the local search reaches higher index in less time; the comparison does
not separate the neighbourhood from the rest of the algorithm" (the cost argument at 10b:256-272 does support the mechanism for time,
not for index). Optional ablation if the writer wants the causal claim: capped-truncation-start DE seeded from the same warm start.

### 10b-R5 (M) -- every "mean of 3 seeds" table and figure: unit of replication is the optimiser seed on ONE simulated dataset per scale
`search_benchmark.csv` has 3 rows per method per scale, seeds 1:3 passed to the optimiser; the dataset is `simulate_data` with
seed 1 at both scales. Deterministic arms (`greedy`, `greedy_cap`, `ocs_round`, `ocs_round_cap`) are three identical rows; at production
every capped arm has s.d. exactly 0 and four capped arms share the index 1.122328. So the headline reading "highest index of any capped
route at both scales" (10b:1163, 1258-1259, 1295-1296) is a 0.19-thousandth difference (production) and a 2.5-thousandth difference (book)
on one dataset each, with no dispersion that can speak to it. The captions (10b:435, 1145) say "mean of 3 seeds" without saying
"3 optimiser seeds, one dataset, deterministic rows have zero dispersion". The anytime figure (10b:417-422) is one seed per arm and one
independent DE run per budget (the DE points are separate runs: 1.296 at 10,000 evaluations, 1.270 at 20,000; the plotted line is
`cummax`). Fix: captions and the 10b:476-496 caveat say what the replicate is; qualify "highest" as "highest on this dataset"; the
recommendation table keeps its content.

### 10b-R6 (H) -- 10b:608-634, 1252, 1270: the Ne-floor niche of `sel_de_fast()` was run and the route failed it; pool balance cannot bind in this design at all
(a) `pool_A` is identically 0.5 for any set of A x B crosses, complete factorial or not: `make_fitness_fast()` computes the share of
line uses that fall in pool A (`R/04_fast_metrics.R:416-419`), and every hybrid has exactly one pool-A and one pool-B parent. So 10b:612-614
(qualifier "in a complete factorial") is too narrow and 10b:631-633 ("an incomplete factorial where pool balance is a real degree of
freedom") is false; the `pool_tol` argument is vacuous for every candidate set this package builds. Same wording in the recommendation
table (10b:1252 "Ne floor, pool balance") and in 07:1049-1077 (owner 07; metrics-C20).
(b) The Ne floor: 10b:616-619 reports all three floors give the same plan, with Ne = 25.7: "met with room to spare at 20 and 25
[25.71 against 25 is 0.71], missed at 30 with a penalty that does not recover it". The floor of 30 is binding and the route did not
satisfy it, also at itermax 1500 (Ne 25.71, index 1.1056, alpha 0.886%). A plan satisfying it exists: the chapter's own capped greedy
sweep (cap 5) contains plans with Ne >= 30 and alpha <= 1% (5 of 20 weights); the best-penalised of them has Ne 29.39, index 0.917, and a
`make_fitness_fast` penalised value of 0.815 against 0.391 for the DE plan (same cap, floor 30, penalty 5): the DE returns a plan that is
worse on its own objective than a one-line greedy plan. So the single use case recommended for the route (10b:630-634, 1252, 1270 "the
only route that accepts them") is the one this chapter's run shows it failing; "accepts" is not "satisfies". (c) "the swap
neighbourhood cannot test" an Ne floor: `theta_state()` carries `cnt`, so Ne = (2n)^2 / sum(cnt^2) is O(1) per swap; the local search
lacks an `ne_par_min` argument, which is an implementation gap, not a limit of the neighbourhood. (d) "All three floors return the same
selection" (10b:617): over 6 seeds the three floors give identical index and Ne but two distinct sets of hybrids per seed -- the same
line-usage plan paired differently (the index is additive, so re-pairing leaves index and theta unchanged); the chunk correctly uses
`unique(index)`; the prose should say "same line usage, same index".
Fix: state (a) and (b) plainly, drop "pool balance" from 10b:631-633/1252, recommend `sel_de_fast()` only as "the route that accepts
those arguments; at floor 30 it did not meet the floor here", and either add `ne_par_min` to the local search later (R/ owed, not
this iteration) or leave the table row saying "no tested route satisfies a binding Ne floor". Cross-chapter: 07:1049-1077 and 10:874
carry the same recommendation (C20).

### 10b-R7 (M) -- identities the prose asserts are not `stopifnot()`ed
Criterion 3. (i) Gram identity (10b:91-104): prose "the difference is exactly zero, and the smallest eigenvalue is zero to the
eigensolver's rounding" -- nothing asserts it (observed 0 and -4.3e-13, ratio -1.0e-15). Suggest
`stopifnot(isTRUE(all.equal(ctx[["f"]], tcrossprod(V) / ctx$m, tolerance = 1e-12)), min(ev) > -1e-10 * max(ev))`. (ii) submatrix identity
(10b:118-123): shown difference 1.8e-12, relative 7e-16; assert `all.equal(theta*n^2, sum(f[s,s]))` at 1e-12. (iii) matroid-check
(10b:154-162): `uses_pool_A == uses_pool_B == n_sel` is the claim; assert it. (iv) 10b:1085-1090 `with_f_start_NULL` vs `no_f_start_given`
both 1.5804 -- prose says "buying the starting point and nothing else"; assert or print the difference. (v) `structural_rows` at
10b:919 (see R12).

### 10b-R8 (M) -- hand-typed numbers (criterion 1), each with what the data give
- 10b:182 "the measured gap is around 1%": book-scale gap to the Lagrangian bound is 1.72% (anneal), 1.73% (hill), 2.64% (tempering)
  (`search_benchmark.csv`, `gap_pct`); the oracle's book interval is 10.1% at 1%. State 1.7% (inline) or drop the number.
- 10b:182, 1001-1003, 1322 "0.745 GiB", "0.3 MiB", "3.8 GiB": equal `scal$f_GB` (0.745, 3.772) and `8 * 200^2 / 2^20` = 0.305; typed.
- 10b:261-266 table (40, 132, 83, 169, 77, 159, 3.3, 4.2 us): equal `search_scaling.csv` rows N = 3600 and 10,000 after rounding; typed
  (the prose introduces them as "two rows of @sec-scaling's table"). Read them from `scal`.
- 10b:415 "one evaluation costs seventeen times what another does": no source. Cached sweep: hybrid/swap = 2.4 (N = 400) to 31.5
  (N = 10,000); line/swap 6.6 to 40.2; measured here at the book scale (N = 625, n = 60): hybrid 38.2 us, line 35.4 us, swap 3.6 us =
  10.6x and 9.8x (line/hybrid 0.9, i.e. not slower at N = 625). Compute from `scal` at the stated N.
- 10b:419 fig-cap "Local search is at 1.52 within a tenth of a second; the differential evolution reaches only 1.45 after two seconds":
  `search_anytime.csv`: hill first reaches 1.52 at 0.103 s, anneal at 0.22 s, tempering at 0.41 s; DE 1.448 at 2.03 s. "Within a tenth"
  holds for one of three modes, narrowly. Remove numbers from the caption or build it with `!expr`.
- 10b:993 fig-cap "9.4x", "20x": equal `growth_lines` 9.42 and `growth_hybrid` 20.11 (printed by the preceding chunk); typed.
- 10b:1234 "Ours costs 5 microseconds": swap 4.2 us at N = 10,000, but the fitness the DE/BO would call costs 132-169 us (table). Say
  which route. (R/12 roxygen "about 5 microseconds ... against 85 for the f-submatrix route" at `R/12_search.R:116-117` is the same typed
  figure and disagrees with the 132 us of the table; R/ owed, comment-only.)
- 10b:448-452 "at production scale the same ratio is what decides whether a frontier of ten budgets is an afternoon or a minute": the
  production ratio is not the book one. Production `secs`: greedy 0.221, hill 0.341, anneal 0.343 (1.5x, not 29x); the greedy is 17%
  below hill there (1.500 vs 1.816). The sentence is contradicted by the table at 10b:1139-1145.

### 10b-R9 (M) -- 10b:1324-1328: "the measured difference between [sel_de and sel_de_fast] is small and runs the other way"
Paired over seeds (`search_benchmark.csv`, de_hybrid minus de_lines, index): uncapped book +0.300 (s.e. 0.009, three seeds 0.283-0.310);
uncapped production +0.110 (s.e. 0.032); capped book +0.0041, capped production 0 (s.e. 0 in both). `de_lines` uncapped is the worst arm of
the book table (1.059). 0.30 is larger than the local-search-minus-best-DE gap the chapter calls decisive (0.168, 10b:481). The
sentence at 10b:522-526 ("it goes the other way") is true and is never given a number in the chapter. Fix: quote the paired
differences and s.e. above where 10b:522-526 and 10b:1324-1328 say it, and drop "small". Consistent with 07:912 (the same paired table).

### 10b-R10 (M) -- 10b:679-683, 719-727, 812-816: the 1.2% between the hand sweep and `ocs_bound()` is attributed to iterations alone
The two numbers differ in the lambda grid (12 points 0.1-1000 vs 25 points) and in iterations (2000 vs 4000 doubled to 8000). Executed
here (book ctx): 12 lambdas / 2000 it = 1.5355 (the chapter's); 12 / 8000 = 1.5399 (+0.28%); 25 / 2000 = 1.5468 (+0.74% from the grid alone);
25 / 8000 = 1.5532 (`ocs_bound`). The iteration effect (+0.28% to +0.42%) has the sign the text says (under-convergence pushes
the bound down); the grid effect is larger and has no such sign in general (the 12-point grid straddles lambda* = 68.1 with 35 and 81).
The same attribution is reused at 10b:812-816 ("the cheap sweep would have reported 3.2% ... more than a point tighter"). Fix: run the
hand sweep on `ocs_bound`'s grid (`lambdas = 10^seq(-1, 3, length.out = 25)`, `iters = 2000`) so only the iteration count differs,
or describe both differences. Also `converged` is a stalling criterion (relative change < `tol` = 1e-3 between a count and its double,
`R/12_search.R:355`), which 09:263-265 says is "not a certificate" and 10 changed to say so; 10b says "certified" at 10b:435, 682-683,
957, 1184-1204, 1311-1313 without the qualifier. Define once ("certified" here means `converged = TRUE`: the value moved by less than 0.1%
on doubling) and keep it. This is the project's term (`bound_certified`), so the request is a definition, not a rename.

### 10b-R11 (M) -- 10b:939-958: the exact-oracle reading goes beyond three instances and omits the Lagrangian comparison
(a) "the heuristic is not leaving anything on the table at all" rests on three budgets of one N = 36 instance (n = 8, dataset seed 5,
one tempering run); the next paragraph limits the scale but not the instance count. State "three budgets, one instance".
(b) "and would not [converge] at production scale either" (10b:946-947) is a prediction with no run; the book scale (4 cuts in 300 s) is
the evidence (03:473 and CLAUDE.md state only the book scale). (c) "the number of cuts needed grows fast ... gradient cuts are weak"
(10b:947-948): the table shows 20-73 cuts at N = 36 and 4 at N = 625 (time-limited); the growth is not measured. (d) At book scale the
oracle's dual bound is 1.6424 (0.5%) and 1.6995 (1%) while `ocs_bound()` gives 1.5543 at 1% (`search_benchmark.csv`): the Lagrangian bound
is the tighter of the two valid bounds there, and the table's 10.1% gap against the oracle sits next to a 1.7% gap against the
Lagrangian bound for the same plan. Say so in one sentence under the table; the reader will otherwise take 10.1% as the heuristic's gap.
(e) 10b:955-958 "evidence that the move and the objective are right": exact equality at three tiny budgets does not test the move at
the cap (the oracle runs carry no `max_use`).
Design decision kept: `sel_exact()` is an oracle, not a route (callout 10b:960-968 agrees with CLAUDE.md; `highs` outer approximation
at 10b:871-886 agrees with CLAUDE.md; `mip_dual_bound` at 10b:909-912 agrees). The callout does not mention that `highs` is `Suggests`
and the table is cached -- see R14.

### 10b-R12 (L) -- 10b:914-920 `exact-budget` chunk describes a capped model that the table's runs are not
`structural_rows = 1 + ctx$n_lines` (51) is the row count when `max_use` is set (`R/12_search.R:516-523`); the runs behind the table
(`regenerate.R:552-554, 568-570`) carry no `max_use`, so they have one structural row; and the chunk prints N = 625 values while the
tiny rows are N = 36. Label the chunk as "the model at book scale, with a cap" or print the uncapped count.

### 10b-R13 (L, owed) -- 10b:1241-1243 `@sec-catalogue`'s rule
06 states no such rule (06-C13). The nearest statement is 09's assumption 5 (09:46-52, "The constraint pins one lens ...", @sec-ocs) and
07's lens scope. Reword: "@sec-ocs (assumption 5) applies: the constraint pins one lens, chosen deliberately, and the plan is judged
on the others against the null." Second point on the same paragraph: the `1 - 1/e` guarantee for monotone submodular functions under a
cardinality constraint is @nemhauser1978; `chen2018` is the greedy MAP routine. The attribution of the guarantee to `chen2018` is
not checkable offline here (see R16); cite both.

### 10b-R14 (M, criterion 9) -- provenance of the cached data is never stated in the chapter
10b reads `search_benchmark.csv`, `search_scaling.csv`, `search_anytime.csv`, `search_exact_gap.csv`, `figs/search_anytime.png`,
`figs/search_scaling.png` and says only "cached" (10b:340, 361, 808, 977). All six have an in-repo producer: `regenerate.R search`
(`regenerate.R:220-434`, about 15 min: benchmark, anytime, scaling and the two figures) and `regenerate.R search` / `search_exact`
(`regenerate.R:536-580`, the exact table; 120 s per tiny run, 300 s per book run). None is an external cache (unlike 04e/04f). Reproduced
here (deterministic cells, book scale): greedy 1.378197, greedy_cap 1.112203, hill seed 1 1.526271, anneal seed 2 1.523193,
tempering_cap seed 1 1.109723 all equal the CSV to 6 digits; tiny exact row alpha = 0.02: heuristic 1.250005, dual 1.250005, "optimal",
20 cuts, equal to the CSV. Timing columns (`secs`, `us_*`, `seconds`) are machine-dependent and do not reproduce bit for bit; the chapter
quotes them without the machine. Fix: one sentence in the opening or at 10b:340: the four CSVs and two figures are cached output of
`regenerate.R search` (and `search_exact`), reproducible in this repository; timings are from one machine. Also say that `sel_exact()`
needs `highs` and `ocs_quadprog()` needs `quadprog` (both `Suggests`), because the downloadable script calls `ocs_round()`.

### 10b-R15 (L) -- 10b:79-80, 82-87: "none of which has been stated in this book so far"
The Gram form of `f` is stated and asserted in 03 (`03:148`, `03:498`, `03:542`: `f == tcrossprod(cbind(X, 1 - X)) / m`), in 05
(`05:1880-1882`: "f is half plus a Gram matrix", under `stopifnot`), and used as "f positive semi-definite" in 09:251. Fact 1 is a
re-statement; say "03 asserts the identity; here it is used for convexity". Facts 2 and 3 (submatrix sum, partition matroid) are new.

### 10b-R16 (L) -- literature numbers and quotations cannot be checked from the repository
10b:506-511 (Yadav et al. 2025: AUC 0.879, 0.860, 0.820, 0.769; "two to three times slower"), 10b:757-759 (Waldmann 2025: mate-allocation
under 0.01 s), 10b:949-951 (Ahadi et al. 2024: the quoted phrase), 10b:501-504 (De Beukelaer et al. 2018). All four keys exist in
`references.bib`; the numbers and the quotation are hand-typed from sources not in the repo (`reference/` is gitignored). Not verified in
this audit; the writer should confirm against the papers before the render.

### 10b-R17 (L) -- gap column for capped rows, 10b:434-435 and 440-443
The `gap to bound %` of `greedy_cap` ... `ocs_round_cap` (28.4-28.9%) is against an uncapped Lagrangian bound (10b:857-859 says the bound
"goes loose" under a cap). The caption says "the gap is against the certified Lagrangian bound" and the prose calls the gap "the only
column that says whether the leader is near optimal". Add "(capped rows: the bound carries no cap, so the gap includes the price of the
cap)". Likewise 10b:1176 "leaves the optimiser nothing to find that a capped greedy sweep does not already reach" is an agreement of
five routes, not a bound; it is worded as a finding.

### 10b-R18 (L) -- 10b:1206-1222 NSGA-II paragraph
"at worse quality per point", "which the sweep currently throws away" are unmeasured assertions (no NSGA-II run, no `start =` in
`stage2_select()`'s `sel_de()` call, `R/11_stage2.R:115`). Mark as a design opinion or drop "worse quality per point". `sel_local_search(start = )`
exists, so the warm-start remark is true of `stage2_select()` only.

### 10b-R19 (L) -- 10b:1010-1021 and 10b:1015
"returns a plan in 157 ms at production scale" is read from the cached `secs` of `ocs_round` (mean of 3 identical deterministic runs)
and includes 10 line-space QPs, the largest-remainder rounding and `alpha_loss()` against the 0.745 GiB `f`; the sentence "That number
is the rounding and nothing else" is not correct (the matrix-based `alpha_loss` per lambda dominates plausibly) and it is not measured
which part dominates. Reword to "157 ms including the 10 frontier evaluations".

---

## Owed items from THREAD / chapter 10 and part reviews

| owed item | status in the worktree text |
|---|---|
| 10b:1245 "one diversity lens" pointer (06-C13; 09 item 5) | still the old sentence at 10b:1241-1243; R13 |
| 10b:641-643 "same diversity" wording (09-M12b) | still the old sentence at 10b:644-647, no other "same diversity" phrase in the chapter (grep: only 10b:647); R2 |
| 10b:744-752 re-pointed | done (10b:746-749 says 09/@sec-relaxation was rewritten); it states "shows the order relaxation point < feasible plan < bound at the 1% budget" -- check against 09 after R2 |
| 10b:1273 `sel_de_fast()` "the only route that accepts them" (metrics-C20, owner 07) | 10b is consistent with 10:874 and with `R/12`; but see R6 (it does not satisfy a binding floor; pool balance is vacuous) |
| 10b:519-521 "5.7x" | done: 10b:520-526 has no ratio; consistent with 10 (the cached run is N = 3,600, L = 120, `10:126-127`); CLAUDE.md prohibition respected |
| 10b:42-50 scale disclaimer (10-C10) | done and true: "package production scale" 71 + 71, N = 5041; the two benchmark scales quoted by 10; cached run N = 3,600 from 120 lines is `de_constraints.csv` dim 3600 / line weights dim 120 |
| keep-true: @sec-bound (10b:635) valid at book scale, not converging at N = 10,000 (10b:1187-1189); `sel_exact()` not converging at book scale (10b:949) | true (cert table: book TRUE, production FALSE; exact rows "time limit"); the production-scale prediction in 10b:946 is the unmeasured part (R11b) |
| keep-true: 09's pointers to @sec-advanced (closing the greedy-to-bound gap) and @sec-bound (iteration count not converging at 10,000) | true; 10's 1.7% book-scale gap equals the cached `gap_pct` (R8) |
| keep-true: "candidate pool" at 10b:209, 1184, 1233 (00 entry) | the phrase now occurs at 10b:210, 1181, 1230 ("candidate set" at 764, 1329); all uses mean the A x B candidate set; no conflict |
| chapter 10 OPEN after 3 iterations (10-D19, 10:489-493) | treated as nearly final; no 10b statement contradicts the 10 text apart from the shared `sel_de_fast` recommendation (R6) and the DE budget (R4) |

## Checks that came back clean

- Criterion 2 (seeds): `ls-modes` sets the seed through `seed =` (set immediately before the draws), `de-fast-four` `set.seed(7)` before each
  call, `de-fast-vs-local`, the bound chunk (`seed = 1`) and `f-free-routes` (`simulate_pools(seed = 1)`, `set.seed(1)` before `wts`,
  `null_distribution` seed 7, `set.seed(7)` before `gd_free`) are all seeded; no AlphaSimR/MaCS here. The unseeded
  `sel_de_fast(... NP = 20)` inside `runs()` only yields "runs".
- Criterion 4: the chapter reads `book/data` and `book/figs` only (`search_*.csv`, `search_anytime.png`, `search_scaling.png`).
- Criterion 5: exported functions used exist and run (`sel_local_search`, `sel_de_fast`, `ocs_bound`, `ocs_round`, `sel_exact` (args only),
  `ctx_from_pools`, `simulate_pools`, `fast_theta`, `decode_lines`, `theta_swap`, `line_counts`, ...); the installed `hybdiv` is 0.1.0; install
  before render as always.
- Criterion 6: both figures are static `include_graphics()`; no chunk generates a figure, `book/_freeze/10b-advanced-selection/` holds
  only `execute-results/{html,typ}.json`, `docs/10b-advanced-selection_files/` does not exist; no orphan `unnamed-chunk-*` files today.
  Any chunk added later has no such risk either unless it plots. `book/downloads/10b-advanced-selection.R` is already regenerated (uncommitted
  modification, contains the 10-review text); regenerate again after R1-R20. `docs/` and `_freeze/` of 10b are stale (the render
  batch re-executes it; 4.5 min here).
- Criterion 7/8 rerun: tempering below hill and anneal in 20/20 seeds at 20,000 moves (holds); hill vs anneal: noise (R3); capped-arm
  equality is exact in the cache (R5).
- Numerical: swap identity, zero-weight decode == `sel_truncation_cap`, `gd_free == gdk` hold; the book-scale `ocs_round` index
  (1.486876) is identical here and in the cache, bounds differ 1.55324 vs 1.55432 (B = 400 vs 500 draws of `gd_ref`; the difference is in
  the third decimal, 10b:808-810 says fourth -- trivial); the production certificate is FALSE in the cache.
- Design decisions agree with CLAUDE.md: the line encoding does not make an evaluation cheaper (10b:256-272, numbers from `search_scaling.csv`);
  `ocs_bound()` Lagrangian, not "best relaxation point" (10b:685-706); `max_use` default NULL (10b:855-858 states the uncapped call);
  `sel_exact()` oracle, outer approximation, `mip_dual_bound` (10b:871-912, 960-968); NULL never means cold start
  (10b:281-289, 561-565).

## Cost declared (for the render batch)

Chapter knit: 4.5 min on this machine (one core), dominated by `ocs_bound()` at book scale (25 multipliers, up to 8000 iterations), the three
`sel_de_fast` calls and the nine 20,000-move local searches. `regenerate.R search` about 15 min, `search_exact` up to 12 min. No new
computation is requested by this audit beyond the fixes above (the hand-sweep rerun in R10 adds about 1 min; the 20-seed hill/anneal
check in R3, 20 x 2 x 0.3 s).
