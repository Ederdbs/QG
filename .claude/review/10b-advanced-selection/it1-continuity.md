# 10b-advanced-selection -- continuity report, iteration 1 (chapter mode, read-only)

Chapter: `book/10b-advanced-selection.qmd` (1340 lines, worktree `SB_quanti_gen-review-04-06`). Read against: THREAD entries 00-09,
`part-*.md`, `book/10-combinatorial-selection.qmd` (OPEN after iteration 3; read as nearly final, with `it3-verdict.md` and `it2-response.md`),
`book/90-notation.qmd`, `R/12_search.R`, `book/data/search_*.csv`. Line numbers are those of the worktree files today. The Owed lines of
the task moved: `10b:1245` is now `10b:1242`, `10b:641-643` is `10b:644-647`, `10b:1273` is `10b:1270`.
Checks applied: 1, 2, 3, 4, 6, 8 (and 5 for the table). Owners: THIS = 10b; EARLIER-NOW = an earlier chapter to be fixed now; LATER = Owed to a later chapter.
Not run: a Quarto render; the chapter was not knitted (the iteration-1 audit `it1-audit.md` did that). Numbers below are from the cached CSVs
and from the chapters' own text. One computation was run (`ocs_bound()` on the default and on the 16-value grid, 10b-C13).

## Opening and promises (check 6)

- Opening (10b:29-33): says what 10 leaves undone (stops at a warm-started DE "if the problem is a black box"). That is why 10b follows 10. PASS.
  It does not carry 10's iteration-3 finding that what DE does depends on the evaluation budget (see 10b-C10).
- Promises made to 10b and kept: 10:1190 ("a method that beats both on index, at a fraction of the wall-clock, is in @sec-advanced": anneal
  1.5276 against fine greedy 1.4227, benchmark greedy 1.378, DE 1.3598; 0.23 s); 10:1356 (local search on the O(L) swap against the DE at equal
  wall-clock: 10b:412-496); 10:955 ("@sec-scaling measures both": the per-evaluation table at 10b:261-266 and 10b:972-996, rows N = 3600 and 10,000
  agree with `search_scaling.csv`: 39.9/83.0/76.6/3.28 and 132.2/168.8/159.1/4.19 us); 10:755 (zero weight = capped truncation, 10b:550-559, asserted);
  09:343-349 (closing the greedy-to-bound gap: kept in substance, anneal gap 1.72% to the B = 500 bound, but 10b never reconnects to 09's 0.13 index-unit
  gap at B = 400, see 10b-C8).
- Promises made to 10b and NOT kept or kept elsewhere: 10:962 "which of two viable encodings wins ... @sec-advanced measures it" (10b-C4, circular);
  10:1558 and 10:1602 "an N_e,par floor rules the cheap routes out rests on the argument of @sec-advanced" (10b-C11); 09:242 and 09:266 "does not converge at
  N = 10,000 (@sec-bound)" point to a section that does not say it (10b-C12).
- Promises 10b makes: 10b:1008 ("the figure @sec-notreach quotes": 200 integer dimensions at 10b:1234, kept); 10b:1020 ("the paragraph after the table is where
  that is measured": 10b:1184-1204, kept); 10b:1036 ("the next section is what happens on the context it returns": @sec-ffree, kept, but see 10b-C18).

## Findings

### 10b-C1 (H) -- owner THIS -- `10b:1242`: a rule attributed to @sec-catalogue that 06 does not state (Owed 06-C13, 09-M12b, still open)
`10b:1241-1243`: "@sec-catalogue's rule applies: one diversity lens, chosen deliberately, reported against a null." 06 (closed) states no such rule (06-C13).
Where the rule actually is: 09 assumption 5 (09:46-52: the constraint pins one lens, theta/GD/alpha; F_drift on `ctx$p0` is not pinned) and 10 assumption 3
(10:106-109, same statement). The sentence also says the DPP log-determinant "would quietly change the quantity the programme is constraining": that is
09/10's assumption 5 in other words. Not yet reworded. Change 10b: cite @sec-ocs (assumption 5) instead of @sec-catalogue and drop "reported against a null"
or point to @sec-baseline for the null.

### 10b-C2 (H) -- owner THIS -- `10b:644-647`: "at that diversity ... a discrete plan can beat it" is false by @eq-ocs-weak (Owed 09-M12b, still open)
`10b:644-647`: "Its optimum happens to land at some diversity, but nothing makes it the best index achievable *at* that diversity. A discrete plan can beat it, and does."
09 (@eq-ocs-weak, 09:223-243): a relaxation point bounds every plan at least as diverse as itself, and at exactly equal diversity a plan cannot beat it; what a plan can
do is spend the budget while the point lies strictly inside it. 10 now says this (10:1466-1471, "at least as diverse as itself ... statement 3"). 10b's own experiment
(`old_valid` FALSE at all four budgets, 10b:649-677) is sound and stays; only the wording at 10b:646-647 and the sentence at 10b:672-677 ("a contradiction and not a tight bound")
need to match. Re-read of 10b:636-750 for other "same diversity" phrases: 10b:644-647 is the only one; 10b:685-693 (the derivation V >= u_S - lambda theta_S >= u_S - lambda theta_max)
is correct and is @eq-ocs-bound re-derived (see 10b-C16, redundancy). 10b cites neither @eq-ocs-weak nor @eq-ocs-bound (both have 0 inbound citations).

### 10b-C3 (H) -- owner THIS -- "certified" / "certificate" / "provably" against 09 and 10, which call `converged` a stalling criterion, not a certificate
09:263-266 (and the THREAD 09 entry): `converged` is "a stalling criterion on the doubling, not a certificate". 10:1289-1293 repeats it. 10b says:
`10b:683` "The certified value comes from `ocs_bound()`"; `10b:716` chunk label `certified-bound`; `10b:733` "further optimiser effort is provably wasted";
`10b:807`/`10b:1184`/table caption `10b:1198` "Where the certificate holds" with column "certified"; `10b:1311-1314` protocol step 5 "Certified and the gap small: stop";
`10b:1017-1019`, `1204`. 09's own convergence table shows the stall criterion at 1e-3 leaves V off by 1.8e-6 relative after 4000 to 16000 iterations and says the gap is
an upper limit "only if `converged`". One word, two meanings: 10b's "certified" = `converged` TRUE; 09/10 reserve "certificate" for what that flag is not.
Decision for the part: either 09/10/10b all say "converged (stalling criterion)", or 10b defines "certified" once as `converged == TRUE` and says in the same place that this is the
stalling criterion of @sec-relaxation. "provably" at 10b:733 and "stop" at 10b:1311 are stronger than the criterion supports and go with the choice.
The `bound_certified` column of `search_benchmark.csv` and CLAUDE.md use "certified"; the file name is not at issue, the prose is.

### 10b-C4 (H) -- owner THIS (and 10, by a pointer) -- the two-encoding head-to-head: 10b states a direction and a size that 10 and 07 scope or contradict, and each chapter delegates the measurement to the other
- `10b:523-526`: "the head-to-head between the two encodings the package actually ships is in this chapter's own benchmark below, and it goes the other way."
- `10b:1324-1329`: "`sel_de()` at n_sel = 200 and `sel_de_fast()` at L = 200 search boxes of the same width, and the measured difference between them is small and runs the other way."
- 10:906-962 computes the paired comparison itself (`tbl-combinatorial-de-lines`) and says: uncapped, sel_de ahead resolved at the benchmark book scale only; at the benchmark production
  scale 2.x s.e. on 2 df, not resolved; capped, differences identical at book scale and 0 at production; and 10:962 closes "which of two viable encodings wins ... @sec-advanced measures it".
  07:617 and 07:961 repeat the scoping ("only without a cap and at one of two scales").
- 10b never pairs the two methods. Its tables (10b:424-436, 10b:1138-1146) list `de_hybrid` and `de_lines` as rows with a 3-seed mean and no difference or s.e.
  From `search_benchmark.csv` (3-seed means): book uncapped 1.3598 against 1.0594 (difference 0.300), production uncapped 1.4460 against 1.3357 (0.110), book capped 1.1097
  against 1.1056 (0.004), production capped 1.122328 against 1.122328 (0). "Small" at 10b:1327 is true only of the capped rows; the uncapped difference at book scale is twenty times the
  schedule spread 10b:476-478 calls large against the move. "Runs the other way" is the direction of the uncapped rows only.
- Also 11:306 and 12:222 (LATER, Owed) say the encoding "decides" / "the search is encoded on line weights, not hybrid keys"; 10b's measurement points the other way for the two shipped
  encodings, and 10 says the N-key verdict is at one budget. 10b-C4 is the cross-chapter reason those two need a pointer once 10b states its scope.
Change 10b: carry the scope (uncapped / capped, book / production, 3 seeds, 30,000 evaluations) or cite @tbl-combinatorial-de-lines instead of asserting the direction; change 10:962 so
the measurement is owned in one place (10, by its table) and 10b cross-references it.

### 10b-C5 (H) -- owner THIS -- `lambda` reused for the reciprocal quantity at `10b:125`
`10b:125`: "the objective is $\lambda \sum_{i \in S} u_i - \sum_{i,j \in S} f_{ij}$" -- here lambda weights the index. Everywhere else in 10b (`10b:644`, `689`, `699`, `701`, `779-782`), in 09 (@eq-ocs-V),
in 10 (10:418-421, 1284-1286) and in 90 (90:290, 90:307) lambda multiplies c'fc, theta in the penalised objective; the quantity that weights the index is omega (90:303, 10:413-421:
omega = Delta theta / Delta u, lambda reciprocal). The 10-D18 correction fixed the unit of the same pair in 10; 10b:125 is the same defect one chapter on. Change 10b: write the objective
with omega (or as a maximisation of u - lambda theta with the right normalisation).

### 10b-C6 (M) -- owner THIS, with 90 -- the greedy index weight is `w` in 10b, omega in 09/10/90
`10b:1256` "`sel_greedy()` swept over w", `10b:1293` "`sel_greedy()` over a $w$ grid spanning your data's crossover" ($w$ in math mode). 90:303 gives omega as the symbol and says "(written $w$ in
@sec-combinatorial)"; after the 10 review 10 writes omega (10:413, 10:444, 10:1555) and keeps `w` only as the code argument (90:313). 10b also uses $\mathbf{w}$ for the line-usage weights
(10b:220, 537), so $w$ means two things within 10b. Two changes: 10b prose to omega (code `w =` stays); 90:303 "(written w in @sec-combinatorial)" is stale (owner 90, Owed from 10, EARLIER-NOW: strike the parenthesis).

### 10b-C7 (M) -- owner THIS -- the per-line cap has two symbols, one of them the contributions vector
`10b:165-166`: "any cap $c$ ... $n \le L_A c$". 10:136-137 defines the cap once as $k_{\max}$ (with $k_a$ the uses of line a, 90:290) and 10:766 uses it; 09 uses `max_use` as a count. 10b writes $c$ and, within
200 lines, $\mathbf{c}$ for the contributions (10b:644, 689). 90 has no row for $k_{\max}$ (it has $k_a$, $\mathbf{k}$): owner 90 (add) and 10b (use $k_{\max}$).

### 10b-C8 (M) -- owner THIS -- "swept finely" for a 20-value grid, and the 1% greedy number that differs from 09/10 without saying why
`10b:444`: "the greedy row ... swept finely over $w$ reaches index 1.378". The benchmark grid is `c(0, 10^seq(-5, 1, length.out = 19))` (`regenerate.R:278`; 10:444 calls it `grid_bench`), the grid 10
shows to leave budgets between its plans unreachable and distinguishes from the fine grid (`10^seq(-6,-1,length.out=60)`, best feasible plan 1.4227 at the 1% budget; 09 and 10 quote 1.4227).
The percentages at 10b:445-452 (greedy 9.8% below the leader, at about 29x less wall-clock) are against the coarse grid; against the fine grid the gap is 6.9% (1.4227 against 1.5276). 10b does
not say which grid the table's `greedy` row is on, nor that two greedy numbers at the same budget and scale exist in the book (1.378 here; 1.4227 in 09:288-296, 10). Also the bound differs: B = 500
in the benchmark (1.5543) against B = 400 in 09/10 (1.5532 per 09's THREAD entry); 10b:807-810 explains B = 400 against 500 for `ocs_round` only. Change 10b: name the grid and add the fine-grid
row or cross-reference 10's `tbl` of the two grids.

### 10b-C9 (M) -- owner THIS -- capped greedy "tops"/"winner" against 10's reading of the same rows as a tie
`10b:1157-1176`, `10b:1250-1269` (row "Production scale, a budget and a per-line cap": "highest index of any *capped* route at both scales"), `10b:1294-1296` ("at both scales measured here, the winner").
10:1498-1535 reads the same capped rows (`search_benchmark.csv`) as: production, spread 0.0002 across five routes with sd 0 in every route, "a tie, ... ranked by cost and memory and not by index"; book, "the
table does not rank them beyond reading it". Data: production greedy_cap 1.122523, tempering_cap = de_hybrid_cap = de_lines_cap 1.122328; book greedy_cap 1.1122, de_hybrid_cap 1.1097. 10b's strategy row
also states tempering as "N thousandths of an index unit short ... at production" (0.2 thousandths) with no dispersion. Same data, two verdicts. Change 10b to the wording of 10 ("ties on index at production; cheapest by cost").
Also `10b:1270` ("it trails the capped greedy on index (@sec-defast-restrictions)"): @sec-defast-restrictions compares `sel_de_fast()` with the capped annealed local search (10b:626-634), not with capped greedy; the
capped-greedy comparison (de_lines_cap 1.1056 against greedy_cap 1.1122 at book, tied at production) is in the benchmark rows. This is Owed metrics-C20 (10b:1273): the sentence is still true at book scale only,
the pointer is to the wrong section, and 07:1062-1079's drop-in code still recommends `sel_de_fast()` without it (07, LATER, Owed, L).

### 10b-C10 (M) -- owner THIS (carry to 11, 11b, 12 as LATER) -- every statement about the DE is at a stated evaluation budget in 10 and at an unstated one in 10b
10 iteration 3 (10-D17, closed) scopes every DE claim by NP x itermax: 30,000 (below the best fine greedy), 120,000 and 600,000 (above it, 1.4384 and 1.4814 against 1.4227). 10b: the benchmark DE is
NP = 100, itermax = 300 (`regenerate.R:315`, `de_iter = 300`, 30,000 evaluations; the `evals` column of the file); the anytime curve ends at 80,000 evaluations (1.448 at 2.0 s, `regenerate.R:361`); the
`de-fast-four` chunk is NP = 100, itermax = 300 (10b:579-583). 10b states none of these. Statements affected: the caption at `10b:419` ("the differential evolution reaches only 1.45 after two seconds"),
`10b:513-515` ("not the obvious choice, and never was"), `10b:626-634` ("on every number in this chapter it does not [optimise better]"), table `10b:424-436` (de_hybrid below greedy, true at 30,000 evaluations and reversed at
120,000 in 10). The conclusion that local search beats DE at equal wall-clock survives (the DE at 600,000 evaluations is 1.4814 at 18.8 s against 1.5276 at 0.23 s). What does not survive unqualified is
"DE below greedy". Change 10b: print the evaluations next to each DE number. LATER: 11b:201 ("@sec-combinatorial's differential evolution finds slightly better plans per cycle"), 11:306 / 12:222 ("the encoding, not the algorithm, decides"), and CLAUDE.md
("4.5e5 evaluations aren't enough to beat greedy") rest on this and have not been checked against it (10-M5 dependants); CLAUDE.md is the user's decision.

### 10b-C11 (M) -- owner THIS -- the case for `sel_de_fast()` on an N_e,par floor is delegated to 10b by 10, and 10b does not make it
10:1558 and 10:1602 say the claim that a restriction a greedy cannot test (an N_e,par floor) rules the cheap routes out "rests on the argument of @sec-advanced, not on a measurement". The argument at
`10b:630-634` and `10b:1252` is one sentence ("a restriction the swap neighbourhood cannot test"). The run behind it (10b:574-592) shows the floor not shaping the plan (the same selection at floors 20, 25, 30; met at 20 and 25
with room, missed at 30 with the penalty not recovering it), so no case where the floor binds is shown. N_e,par is a function of the line-count vector that `theta_state()` already carries (10b:232-236), so that the swap
"cannot test" it is a statement about `sel_local_search()`'s arguments (it has no `ne_par_min`, `R/12_search.R:162-167`), not about the neighbourhood. Change 10b: say it is the arguments, or add the argument that makes it a claim about
structure; and 10: keep "rests on the argument" only if 10b states one.

### 10b-C12 (M) -- owner EARLIER-NOW (09) -- two pointers land in the wrong section of 10b
09:242 and 09:266 (and the 09 Owed note "09's pointer to @sec-bound ... must be kept by 10b"): "the iteration count that converges at this scale does not at $N = 10{,}000$ (@sec-bound)". That sentence is in @sec-scaling
(10b:1184-1191 with the table at 10b:1193-1199), not in @sec-bound (10b:636-750, which treats book scale only). 10:1293 cites @sec-scaling for the same claim, correctly. 03:473 cites @sec-bound for "`ocs_bound()` gives a valid upper bound, and
`sel_exact()` does not converge there": the bound is in @sec-bound; `sel_exact()` non-convergence is in @sec-oa (10b:939-958), not cited by anyone (inbound 0). Change 09:242/266 to @sec-scaling; 03:473 to add @sec-oa (L).

### 10b-C13 (L) -- owner THIS -- `ocs_bound()` called with its default grid in 10b, with an explicit 16-value grid in 09 and 10 (checked: same number)
`10b:710`: `ocs_bound(ctx, n_sel, am, gd)` uses the default `lambdas = 10^seq(-1, 3, length.out = 25)` (`R/12_search.R:337`); 09's chunk and 10:1297 pass `10^seq(0, 2.5, by = 1/6)` (16 values). Run here (installed package, book ctx, B = 400,
gd_ref 0.3258386, 1% budget): both grids return 1.553244, lambda* 68.1292, 8000 iterations, `converged` TRUE, so the number printed by 10b equals the 1.5532 of 09 and 10 (the minimiser 10^(11/6) lies on both grids). No numeric discrepancy; what is left is that 10b does not
print its grid, that 09's "(16 values, 1 to 316)" describes the call and not the default, and that the cheap sweep at 10b:650 is a third grid (12 values, 0.1 to 1000, 2000 iterations; it is labelled as not quoted). State the grid where a bound is quoted.

### 10b-C14 (M) -- owner THIS and 10 (Owed to 10, nearly final) -- two strategy tables recommend different optimisers for the same situation
10:1540-1565 (`tbl-combinatorial-strategy`, row "A budget the omega grid steps over, or an N_e,par floor") recommends `sel_de()` (with its evaluation budget) and, for a floor, `sel_de_fast()`. 10b's table (10b:1245-1274) has no row for
that situation, and its protocol (10b:1297-1310) recommends `sel_local_search()` as the optimiser, which 10:1190 and 10:1356 promise beats the DE at a fraction of the wall-clock. 10's summary (10:1586-1602) never points to the local-search
result. A reader following 10's table reaches `sel_de()`; 10b says not to. Change: one row in 10b for "a budget a grid steps over" (local search, 1.5276 against fine greedy 1.4227), and in 10 a pointer from that row to @sec-localsearch.

### 10b-C15 (L) -- owner THIS -- "seventeen times" has no source
`10b:414-415`: "when one evaluation costs seventeen times what another does". No table in 10 or 10b gives 17. Per-evaluation ratios in the book: 10b:261-266 (hybrid/swap 12 at N = 3600, 31 at 10,000; line/swap 25 and 40); benchmark DE against local search seconds per evaluation 3.6 at book scale (0.846 s against 0.232 s, both 30,000 evaluations) and 26 at production (8.86 s against 0.34 s). Neither is 17. Replace by a computed figure or drop the number.

### 10b-C16 (L) -- owner THIS -- redundancy with 09 (the Lagrangian bound derived a third time) and line merit defined twice
@eq-ocs-weak / @eq-ocs-bound are derived in 09 (09:223-243), restated in 10 (10:1276-1294) and derived again at `10b:685-693`. 09 owns it; 10b's section keeps the falsification experiment (new content) and should replace the derivation by a citation of
@eq-ocs-bound (zero inbound citations at the moment). The line merit of `ocs_round()` (10b:763-766: mean index of the hybrids a line parents) and `upper = max_use / 2n` (10b:770-771) are the same definitions as 09:687-738 (`line_merit`, `upper` = max_use/(2n)),
without a pointer to @sec-ocs; 10b also does not say that `ocs_quadprog()` has no per-pool margin (09) while `ocs_round()` runs on both pools (10b:773-778).

### 10b-C17 (L) -- owner 10, 10b (decision for the part) -- "book scale" against "teaching scale" (owed from part-foundations introduction-C10)
10b (10b:419, 10b:942ff, 10b:949, throughout) and 10 (the Scale paragraph, "Book scale") use "book scale"; 09 and 03 use "teaching scale" (A8, 00:35). 10's "benchmark book scale" (N = 625, L = 50, n = 60, cap 5) and 10b's "book scale" in the benchmark
sentences have the same N, L, n as the teaching scale. 10b:42-51 defines "production scale" (100 + 100, N = 10,000) against the package's 71 + 71 consistently with 10's four names; 10b does not use 10's names ("benchmark book scale", "benchmark production scale").

### 10b-C18 (L) -- owner THIS -- the partial-matching passage is out of date (iteration-1 audit 10b-R1, H there); not re-derived here
`10b:291-297` and `10b:1103-1114` say `theta_group()` "partial-matches `ctx$fL`" and "what surfaces is `subscript out of bounds`"; `R/01_metrics.R:21-22` now stops with a named message and there is no `ctx$f` left in `R/` (audit R1, commit 90e7966). CLAUDE.md's
`ctx[["f"]]` decision is the history. Listed so the continuity count does not lose it; the fix is in the audit.

### 10b-C19 (L) -- owner THIS -- small checks of numbers against the data
- `10b:419` caption: "Local search is at 1.52 within a tenth of a second": true of `hill` (1.518 at 0.1 s, `search_anytime.csv`), not of `anneal` (1.45) or `tempering` (1.49) at 0.1 s; "the differential evolution reaches only 1.45 after two seconds" is 1.448 at 80,000 evaluations.
- `10b:181` callout: "the measured gap is around 1%": the gap to the bound in the benchmark is 1.72% (anneal), 1.73% (hill), 2.64% (tempering).
- `10b:957`: "only the interval between the best plan and the certified bound is reportable": the book-scale table at `10b:927-937` has the MILP dual (1.6995 at the 1% budget, 300 s) and the Lagrangian bound is 1.554 -- two different bounds called "certified"; say which.
- `10b:741-742`: "the warm-started DE does sit below the frontier": at 120,000 and 600,000 evaluations the DE is above the best fine greedy plan (10:1195ff); "frontier" there needs the budget (10b-C10).
- `10b:1256` row 1 puts `sel_greedy()` before `sel_truncation_cap()`; 10:1569-1580 orders truncation, then the greedy sweep (L).

## Checks that came back clean

1. Per-evaluation cost rows, growth factors (9.4x line, 20x hybrid), 0.745 GiB and 3.8 GiB (22,500^2 x 8 / 2^30 = 3.77), `N = 5041` for 71 + 71: agree with `search_scaling.csv` and 10.
2. The four restrictions of 10b:536-540 are 10's four (10:758-790); the cap normaliser is not stated in 10b, so no conflict with the corrected caption (violation divided by its own limit; cap by 2n). `sel_local_search`'s penalty (10b:312-320, 5 on a violation divided by alpha_max; make_fitness 1000 on the absolute excess) agrees with 09:92-122.
3. The N = 10,000 production rows are uncertified in `search_benchmark.csv` (FALSE), matching 10:1326-1333 and 10b:1193-1199.
4. `cap4 = ceiling(4 n / L) = 5` is the benchmark cap; 10's capped truncation uses 4 (10:~136-150); 10b:552 and 10b:576 use the right one in the right place.
5. 10b:1005, 10b:1134-1136 (07's benchmark declining to form the 22,500^2 matrix) and 10b:219-222 (@sec-collapse: theta = w'f^L w) match 07.
6. Broken `@sec-` targets in 10b: none. Targets used (14 distinct to other files): `sec-combinatorial` (14 uses), `sec-ocs` 3, `sec-relaxation` 2, `sec-collapse` 2, `sec-choosing` 2, `sec-baseline`, `sec-catalogue`, `sec-case-study`, `sec-heterosis-gca-sca`, `sec-verification` 1 each.
7. 10b has no `{#eq-}`, `{#tbl-}` or `{#fig-}` label; its displayed equations (10b:689, 10b:880) are unlabelled, so they cannot be cited from 09/10 (use @eq-ocs-bound / @eq-ocs-weak instead).

## Owed lines, status after this iteration

| Owed item | Status | Owner now |
|---|---|---|
| 10b:1245 "one diversity lens" pointer (06-C13) | OPEN, `10b:1242` unchanged | THIS (10b-C1) |
| 10b:641-643 "same diversity" (09-M12b) | OPEN, `10b:644-647` unchanged | THIS (10b-C2) |
| 10b:1273 `sel_de_fast` (metrics-C20) | OPEN; 10b's text is still true at book scale only and points to the wrong subsection | THIS (10b-C9) and 07 (LATER, L: 07:1062-1079 silent) |
| 09-M12a (07:1053-1056 "roughly a factor of two ... small candidate sets") | OPEN, text unchanged | 07 (LATER; not this chapter) |
| 09-M12c (02b "not read for this book") | not re-checked | 02b |
| 09-M12d CLAUDE.md "a discrete plan at the same diversity can beat it" and "proportional penalty"; and "4.5e5 evaluations" | OPEN | user decision |
| 09 keep-true: pointer to @sec-advanced (close the gap) | kept in substance (10b-C8) | -- |
| 09 keep-true: pointer to @sec-bound (N = 10,000) | the claim is in @sec-scaling, not @sec-bound | EARLIER-NOW 09 (10b-C12) |
| 10-M5 dependants: 11:306, 12:222, 11b:201, 07's own restrictions table, 90:303 | OPEN | 11, 12, 11b, 07, 90 (10b-C4, C6, C10) |

## Inbound `@sec-` count for the labels 10b owns (self-citations discarded; grep over `book/*.qmd` today, one count per line)

| Label | Inbound | Files |
|---|---|---|
| `sec-advanced` | 27 | 10: 16 (`11, 121, 142, 398, 444, 476, 755, 906, 962, 1190, 1320, 1356, 1478, 1483, 1558, 1602`); 07: 3 (`539, 617, 961`); 00: 2 (`185, 748`); one each from 04e (`1150`), 05b (`2094`), 09 (`348`), 91 (`65`), 92 (`238`), index (`126`) |
| `sec-bound` | 4 | 03 (`473`), 09 (`242`, `266`), 10 (`1476`) |
| `sec-scaling` | 2 | 10 (`955`, `1293`) |
| `sec-localsearch` | 0 | cited inside 10b only (`10b:804`, `10b:742`) |
| `sec-oa` | 0 | inside 10b only (`10b:216`, `10b:1270`) |
| `sec-ffree` | 0 | inside 10b only (four times) |
| `sec-defast-restrictions` | 0 | inside 10b only (`10b:1270`) |
| `sec-notreach` | 0 | inside 10b only (`10b:1008`) |

The 27 `sec-advanced` citations come from 9 files (10 alone 16, 59%). Chapters that depend on 10b's results and cite it 0 times: 11, 11b, 11c, 12, 04d, 04f, 04g.
10b has a job as a whole (27 inbound, 16 from its predecessor, 3 from 07); five of its eight section labels are cited from no other chapter. `sec-oa` (the only exact-solver result in the book) has 0 and `sec-scaling` (the evidence that 09 and 10 name for "does not
converge at N = 10,000", and that 09:242/266 mis-point to `sec-bound`) has 2, both from 10.
