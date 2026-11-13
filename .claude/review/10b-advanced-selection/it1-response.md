# 10b-advanced-selection -- response, iteration 1


## R/ docs-only rows (R/12_search.R roxygen; no behaviour change)

| ID | Status | Evidence |
|---|---|---|
| 10b-D11(vi) / R8 (`R/12_search.R` "about 5 microseconds") | fixed | `sel_local_search` roxygen now says the 4-5 us is the theta update alone (`theta_swap()` 5.0 us vs 84.9 us f-submatrix, N = 10000, n = 200, `book/data/cost_per_eval.csv`), not an objective evaluation; the fitness `sel_de_fast` calls is 132-169 us at N = 10000 (`book/data/search_scaling.csv`); one machine, one run. |
| 10b-D6 (a) pool balance | fixed | `sel_de_fast` and `sel_local_search` roxygen: the pool-A share of line uses is exactly 0.5 for any set of A x B crosses, so `pool_tol` cannot bind. |
| 10b-D6 (b) N_e,par floor | fixed | `sel_de_fast` roxygen: `ne_par_min` and `pool_tol` enter only as penalties; the chapter run (NP 100, itermax 300, cap 5, floors 20/25/30) returned one plan with N_e,par 25.7, violating 30; check `fast_ne_parents()` on the result. No code change. |
| 10b-D6 (c) swap cannot test N_e,par | fixed | `sel_local_search` roxygen: no `ne_par_min` argument; implementation gap, not structural (`theta_state()` carries the count vector, N_e,par = (2n)^2 / sum(cnt^2)). |
| 10b-D10 (a) "certified/certificate" | fixed | `ocs_bound` roxygen (`tol`, `@return`): `converged` is a stalling criterion on the relative change of the minimum when the iteration count doubles (`tol` 1e-3), not a certificate; `FALSE` means the value may be below the true bound. `ocs_round` roxygen: "certificate" replaced by "bound", valid when `converged` is TRUE. `sel_exact` wording ("certified interval", dual bound from HiGHS) left as is: a different mechanism. |

Checks: `devtools::document()` clean; `devtools::install()` done; `devtools::test()` FAIL 0, WARN 0, SKIP 0, PASS 515; R/ ASCII (grep for non-ASCII bytes empty).


## Chapter rows (book/10b-advanced-selection.qmd; quant-Rwrite appended nothing below this line)

Knit check: `knitr::knit` of the chapter at the worktree package (installed hybdiv, R/ edits of the parallel session included), 7.8 min, output in the scratchpad, every `stopifnot()` passes (new ones: Gram identity and PSD, submatrix sum, matroid counts, count-vector N_e,par identity after a swap, pool share 0.5 over five random subsets and A x B parents, penalised-index formula against `make_fitness_fast()`, bisected relaxation point at the budget >= feasible plan, anytime ordering, wall-clock ordering local search < DE at both scales, f-free messages, capped production s.d. 0, `I + f` eigenvalues >= 1, live benchmark-grid greedy = CSV greedy row). The two edits made after the knit (an inline `split()` expression, a `t_dp` variable) were run in isolation, not re-knitted. No `quarto render`.

| ID | Status | Evidence / change |
|---|---|---|
| 10b-D1 (R1, C18) f-free passage | fixed | Both passages rewritten from the package's current behaviour: four routes stop with `ctx[["f"]] (hybrid coancestry) is missing`, `sel_greedy()` with R's own error; table now a named object, hidden chunk asserts both facts. The `$` partial-match is stated as history, not measured. |
| 10b-D2 (R2, C2) @sec-bound | fixed | "A discrete plan can beat it, and does" replaced by 09 @eq-ocs-weak / @sec-relaxation statement 3. Table prints lambda and alpha of the point used: 2 distinct points for 4 rows (0.25% and 0.5% share one; 1% and 2% share one, alpha 0.82%, index 1.4879). New chunk bisects lambda onto the 1% budget (10 steps, 4000 it): alpha 0.992%, index 1.5373 >= feasible plan 1.5202 (asserted). `feasible_plan` = best of eight plans. Derivation replaced by citation of @eq-ocs-bound (M9, C16). Section title and callout kept; "frontier" wording in callout (C19) replaced. A 200-point grid (>5 min) was not put in the chapter; bisection shows the same point. |
| 10b-D3 (R3) hill vs anneal | fixed | 20 seeds at 20,000 and 30,000 moves: hill - anneal +0.93e-3 (s.e. 1.41, 10/20) and -0.91e-3 (s.e. 1.10, 8/20); tempering below both 20/20 at both. Sign-flip claims, "property of the move budget", "same draws" and protocol step 4 rewritten; seeds 1:3 give +6.2e-3 (reported). |
| 10b-D4 (R4, C10) neighbourhood claim | fixed | Causal sentence replaced: whole-algorithm comparison; DE budget NP 100 x itermax 300 = 30,000 (anytime 2,000-80,000) stated in the opening and at each DE number; 10's reversal at four times that budget and at the default cited by @sec-combinatorial-budget; ratios 11.7x/2.9x removed; local search not rerun against the DE at larger budgets (said). |
| 10b-D5 (R5, C9) replication / winner | fixed | Opening paragraph and captions state: unit = optimiser seed on one dataset, deterministic and capped rows s.d. 0. Capped production rows read as a tie (spread 0.0002, asserted s.d. 0); "tops", "winner", "nothing to find" removed; strategy row and protocol step 3 reworded; pointer to the wrong subsection (10b:1270) removed. Anytime caption says one run per arm. |
| 10b-D6 (R6, C11) sel_de_fast niche | fixed | Pool balance: asserted 0.5 for random subsets, A x B parents; "incomplete factorial" removed. Ne floor: four runs (floors 20/25/30 at itermax 300, floor 30 at 1500) all index 1.1056, N_e,par 25.71, same line usage; floor 30 missed by 4.29. Capped greedy (20-value grid) has 5 plans with alpha <= 1% and N_e,par >= 30, best 0.673; penalised 0.815 vs 0.391 (formula asserted against `make_fitness_fast()`). "Swap cannot test a floor" replaced by an implementation gap (asserted identity on `cnt`). Strategy row rewritten. 07:1049-1077 and 10:874 Owed. |
| 10b-D7 (R9, C4) de vs de_fast | fixed | Paired differences with s.e. computed from the CSV in the encoding subsection and in the summary: +0.3004 (0.0087), +0.1103 (0.0322, t 3.4 on 2 df, p 0.08), capped +0.0041 (0) and 0 (0); "small" removed; pointer to @tbl-combinatorial-de-lines. |
| 10b-D8 (B2, B3, B4, B5, B10, C1, R13) citations | fixed (B6, B8, B9 not verified) | (a) DPP: submodularity attributed to Chen 2018 as they state it; monotone/non-negative marked as the book's derivation (eigenvalues of I + beta f >= 1, asserted on the instance), 1 - 1/e to Nemhauser 1978. (b) De Beukelaer: GA beats random descent, not as effective as parallel tempering; "considerably more complex" dropped. (c) 06 rule replaced by @sec-ocs assumption 5 / @sec-combinatorial assumption 3. (d) Yadav: "for the OPV fitness function", "took longer to run", "comparably in final fitness"; Younis: MDP, crosses per generation, BREEDING GYM; "when to recycle" and "successors" removed. Bib: ahadi2024 113--125, number 2; minoux1978 DOI; deb2002 and kulesza2012 added, all four Crossref-verified today (titles, authors, volume, pages, DOI). Fisher 1978 (1/(p+1)) left as cited, full text unreachable. |
| 10b-D9 (C5, C6, C7) symbols | fixed | Objective written with omega (units coancestry per index s.d.) and as n^-2 times n omega sum u - sum f; omega in the strategy table and protocol; cap is k_max; no `c` for contributions left. |
| 10b-D10 (R10, C3) certified | fixed | "certified/certificate/provably/stop" replaced by converged (stalling criterion, 1e-3) throughout; column `bound_certified` named once. 2 x 2 decomposition printed: 12/2000 1.5355, 12/8000 1.5399, 25/2000 1.5468, 25/8000 (`ocs_bound`) 1.5532: iterations +0.28%, grid +0.74% (and the 25-point grid is 0.87% looser at equal iterations: it skips lambda 81.1 near the minimiser). B = 400 vs 500: third decimal. |
| 10b-D11 (R8, C8, C15, C19) numbers | fixed | (i) gap 1.7% / 2.6% inline; (ii) 3.8x per evaluation at the benchmark book scale, 12x and 32x hybrid/swap at N = 3,600 and 10,000, computed; (iii) caption without numbers, times 0.10/0.22/0.41 s inline, DE 1.448 at 2.0 s; (iv) production 0.221 vs 0.341 s (1.5x), greedy 17% below hill; (v) greedy 1.378 on the 20-value grid vs 1.4226 on the 60-value grid computed live (asserted equal to the CSV row), 9.8% vs 6.9%; (vi) swap 4.2 us vs fitness 132-169 us; memory figures inline. |
| 10b-D12 (R11, C19) exact oracle | fixed | Three budgets of one N = 36 instance, no run with a cap, none at N = 10,000; cuts 20-73 vs 4 not read as growth; oracle dual 1.6995 vs Lagrangian 1.5543 for the same plan (10.1% vs 1.7%), neither called certified; `exact-budget` chunk separates the uncapped (1) and capped (1 + L) row counts (M2). |
| 10b-M1 (R7) | fixed | stopifnot on Gram identity, PSD, submatrix sum, matroid counts; `with_f_start_NULL` vs `no_f_start_given`: difference printed, claim limited to one instance. |
| 10b-M2 (R12) | fixed | see D12. |
| 10b-M3 (R15) | fixed | Gram form attributed to @sec-sim-assumptions and @sec-era-step7. |
| 10b-M4 (R17) | fixed | Gap column qualified for capped rows (bound carries no cap) in caption and prose. |
| 10b-M5 (R18, B10) | fixed | NSGA-II "worse quality per point" withdrawn (not run); warm-start remark restricted to `stage2_select()`'s `sel_de()` call; epsilon-constraint name dropped; BO argued from measured costs, not run. |
| 10b-M6 (R19) | fixed | 157 ms stated as including ten QPs, rounding, mate allocation and ten `alpha_loss()` evaluations; which dominates not measured. |
| 10b-M7 (C6, C7) | fixed | omega and k_max (see D9). 90 row for k_max is Owed to 90. |
| 10b-M8 (C14) | fixed in 10b | Row "a budget the omega grid steps over" added, recommending `sel_local_search()`. 10's table is Owed. |
| 10b-M9 (C16) | fixed | @eq-ocs-bound cited; line merit points to @sec-ocs; `ocs_quadprog()` single margin stated. |
| 10b-M10 (C13, C17) | fixed | Default grid (25 multipliers, 0.1 to 1000) printed where the bound is quoted; opening paragraph defines book scale, benchmark book scale and benchmark production scale with 10's names. |
| 10b-M11 (R14) | fixed | Opening paragraph: files are output of `regenerate.R search` / `search_exact`, reproducible here, timings one machine; `highs`, `quadprog` are `Suggests`. |
| R16, B1, B7 | fixed / consistent | B1 bib corrected; B7 consistent; R16 covered by D8(d). |
| C12 (09 pointers) | fixed | 09 pointer (N = 10,000) now @sec-scaling; 09:242 "falsifies it" now "shows it falling below a feasible plan"; 03 sel_exact pointer adds @sec-oa; 90:303 parenthesis "(written w in @sec-combinatorial)" dropped. |

Contested: none.

## Owed (not edited here)

- 07:1049-1077 (drop-in code recommends `sel_de_fast()` with `pool_tol` and an N_e,par floor) and 10:874, 10:1548-1565: the pool-balance restriction is vacuous and the floor of 30 was not met; 10:1558/1602 "rests on the argument of @sec-advanced" now points at a measured failure.
- 10:962 "which of two viable encodings wins ... @sec-advanced measures it": the paired numbers are in 10b's encoding subsection and in 10's @tbl-combinatorial-de-lines; one owner.
- 10's strategy table (10:1540-1565) has no pointer to @sec-localsearch for "a budget the omega grid steps over"; 10:1586-1602 likewise.
- 11:306 and 12:222 ("the encoding, not the algorithm, decides"), 11b:201, 07 restrictions table (07:617, 961): rest on one budget and one encoding pair; 10b now states both.
- 90: add a row for k_max.
- CLAUDE.md (user): "a discrete plan at the same diversity can beat it" in the `ocs_bound()` bullet; "4.5e5 evaluations aren't enough to beat greedy" without budget; "proportional penalty".
- `R/12_search.R` roxygen: done by quant-Rwrite (rows above).
- Render batch: `docs/` and `book/_freeze/10b-advanced-selection/` are stale; the render re-executes the chapter (about 8 min; the 12/8000 and 25/2000 sweeps and the bisection are new). `book/data/ocs_panel_sweep.csv` is untracked (09's owed). Comstock 1949: not cited here.
- Not verified: Fisher et al. 1978 (full text), Minoux 1978 and Duran & Grossmann 1986 beyond metadata; larger-budget local-search-versus-DE comparison (not run); behaviour at N = 10,000 beyond the cached rows.
