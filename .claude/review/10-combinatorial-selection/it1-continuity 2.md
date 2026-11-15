# Chapter 10 (book/10-combinatorial-selection.qmd) -- continuity review, iteration 1

Chapter mode, read-only except this file. Read: CLAUDE.md, `_quarto.yml`, `90-notation.qmd`, THREAD entries 00-09 (final) and part-*.md, 07 Finding 4 (07:534-660), 09 in full via its THREAD entry, 10b (opening, 517-535, 566-600, 635-680, 735-745, 936-962, 1250-1316). The chapter was knitted end to end into the scratchpad (all chunks run, `stopifnot()` pass); the numbers below that are not quoted from a file were recomputed from that run, from `book/data/search_benchmark.csv`, `book/data/de_constraints.csv`, and one extra run of the greedy over 09's grid (60 values, 1e-6 to 1e-1). Line numbers are those of the worktree.

Owner codes: **10** = this chapter changes; **earlier (now)** = an earlier chapter to fix in this pass; **later (Owed)** = a later chapter, goes to its Owed list.

## Verdict on the Owed items naming 10

| Owed item | Status in the chapter |
|---|---|
| 07: 10:455 / 10:464-475, circular definition of the four restrictions | NOT settled: 10:455 still "the four simultaneous restrictions of @sec-choosing", caption 10:475 "(@sec-choosing)". See 10-C4. |
| 08b-C4 / metrics-C14(b): 10:43-46 cites @sec-genomic-prediction for the unit-variance index | NOT settled (10:45). See 10-C7. |
| 00: "candidate pool" at 10:45, 10:125 | NOT settled (also 10:52-53). See 10-C8. |
| 09-M12: relaxation pointers 10:683, 10:826 | NOT settled, and 10:764 and 10:826-829 carry the same wrong reason as 10b:641-643. See 10-C1. |
| 04 / 07 / 09: `max_use`, 10's side | NOT settled: 10 never defines it. See 10-C5. |
| 07 (11): 11:306 repeats the overclaim | The overclaim is in 10:519-521 and 10:346-347/450-452; fix there first. See 10-C3. 11:306 and 12:222 stay Owed. |
| 06: "@sec-combinatorial gives the recipe" (06:941) | kept: 10:878-893. |
| 09: `decode()` and `max_use` enforcement live in 10 | `decode()` kept (10:350-406); enforcement kept (10:255, 433-448); definition missing (10-C5). |
| 04c:2240, 2274 (the ceiling and the same-size reference are 10's) | kept true: 10:81-84, 53-54 (4.12 %, gd_ref 0.32584 at n = 60). |

Numbers that agree with their source: ceiling 4.122 % (09 alpha_trunc 0.0412); `ocs_bound()` 1.5532, lambda* 68.13, 8000 iterations, converged TRUE (09); penalty 1000 on the absolute excess (09:92-122); hybrid-key arm 0.351 and line-weight arm 1.988 (07).

## Findings

### 10-C1 (H) -- the relaxation is called "not a bound at matched diversity", against 09's weak duality
- Locations: 10:764 (figure caption: "a relaxation, not a bound at matched diversity"); 10:822-829 ("It is not one ... because each point maximises a penalised objective rather than the index at its own diversity"); 10:683-685 and 10:703-713 (correct in substance); 09:223-243 (@eq-ocs-weak, THREAD 09 "The valid bound" items 2-3); 10b:641-643 (same wording, already owed, 09-M12b).
- 09 establishes that a relaxation point bounds every discrete plan at least as diverse as itself and that at exactly equal diversity a plan cannot beat it; what fails is the step from "a point inside the budget" to "the plan that spends the budget" (which is less diverse). Each relaxation point IS the index maximiser at its own diversity (it lies on the continuous frontier). 10 states the opposite reason at 10:826-829 and, at 10:822-825, denies that its height at a given alpha bounds a plan at that alpha, which weak duality grants. The experiment (best relaxation point inside 1% = 1.347 below DE and greedy) is right; only the explanation and the caption are wrong.
- The dashed curve is built by `ocs_relaxation()` at default iterations (10:690); 09's under-convergence callout says an under-converged V is too small, so "above the discrete points over most of the range" needs the 09 caveat or a converged run.
- Pointers: 10:683-684 "derived in @sec-bound" and 10:829 "@sec-bound ... gives the Lagrangian statement": 09 @sec-relaxation (@eq-ocs-bound, 09:204-266) now derives it; 10b @sec-bound falsifies the old construction. 10:683 "@sec-relaxation gives a relaxation" is fine.
- Owner: **10** (caption, 10:822-829, pointers). 10b:641-643 stays Owed (09-M12b).

### 10-C2 (H) -- "best feasible greedy" at the 1% budget is 1.378 here and 1.4227 in 09, and the "DE ahead at 4 of 5 budgets" reading reverses on 09's grid
- Locations: 10:586-590 and 10:673-675 ("best feasible greedy solution of the finely swept grid", 1.3782 in the run); 10:792-801 and 10:811-820 (DE ahead at 4 of 5 budgets, "the greedy grid simply has no point near that budget"); 10:284-289 ("the two chapters report the same greedy"); 09 THREAD "Numbers at the 1% budget": best greedy plan inside the budget 1.4227 at alpha 0.00685, from 60 values of omega, 1e-6 to 1e-1.
- Same `ctx`, `n_sel = 60`, same `gd_ref`: 10's grid is `c(0, 10^seq(-5, 1, length.out = 19))` (20 values, 8 of them duplicates of truncation); 09's finer grid finds a plan 0.045 higher. Recomputed over 09's grid, greedy at alpha_max = 0, 0.0025, 0.005, 0.01, 0.02 is 1.1765, 1.1765, 1.2856, 1.4227, 1.6841 against the chapter's DE 0.9553, 1.0812, 1.1833, 1.3184, 1.6310: greedy is ahead at all five budgets, not behind at one. The chapter's own sentence "the statement that DE dominates greedy ... was an artefact of a coarse w grid" is true of its 20-value grid too.
- The grid is the benchmark's (regenerate.R:278), so 10 = 10b = 07's benchmark; 09 is the odd one out. Both are defensible; what is wrong is that 10 calls its grid "fine", quotes the 1.378 as "the best feasible greedy" and reads the DE-versus-greedy count from it, without saying 09's finer sweep gives more.
- Owner: **10** (state the grid and its resolution; qualify the 4-of-5 reading; point to 09's 1.4227). Keep the benchmark's 1.378 (10b, 07) as it is; a sentence in 10b that its greedy is the 19-point grid is optional (later, Owed).

### 10-C3 (H) -- "infeasible ... measured rather than asserted" is stronger than the result, and 07 says so
- Locations: 10:346-347 ("An N-dimensional 0/1 encoding is infeasible"), 10:450-452 ("measured rather than asserted"), 10:492-495 (the penalty/repair identity "because ... the search never travels far enough"), 10:519-521 ("The constraint handler does not [decide]"); 07:607-646 limits (a), (c) and the interpretation paragraph.
- 07 (the chapter that owns the file's reading): (a) two encodings, not two handlers; no line-weight arm with a penalty exists, and the line decoder satisfies the cap by construction; the identity of penalty and repair in the hybrid arm is "I do not know why ... not tested". (c) 60,000 evaluations at 3,600 dimensions is fewer than two generations at the guidance NP = 10 x dimensions; NP, n and iterations unrecorded; the slack constraints in the hybrid arm (loss 0.05-0.07 % against 0.5 %, Ne 76-77 against 50) are "the sign of an unconverged search".
- 10 omits both, asserts the untested mechanism as fact at 10:492-495, and its closing blockquote says the handler "does not" decide although the one arm that works has no handler comparison. The measured arm has N = 3,600, not the 5,041 of 10:347, and is a random-key rank decode, not a 0/1 encoding (see 10-C17).
- Downstream: 11:306 ("the encoding, not the algorithm, is what decides") and 12:222 inherit it.
- Owner: **10** (replace "infeasible/measured" by "much worse at an equal budget of 60,000 evaluations, search effort unrecorded", drop the mechanism or mark it untested, say the handler is untested in the line arm). 11:306 and 12:222: **later (Owed)**.

### 10-C4 (H) -- the four restrictions are still defined by a citation back to 07, which defines them by a citation forward to 10
- Locations: 10:455 and 10:475 (@sec-choosing); 07:536-552 (declares itself a preview, restrictions "as @sec-combinatorial states"); response file metrics-C10 (owner 10).
- 10:455-457 does list the four (loss <= 0.5 %, Ne,par >= 50, 6 uses per line, pool balance within 5 %) but ascribes them to @sec-choosing and never says what "pool balance within 5 %" measures (the cached column is `pool_imbalance`), nor that it is 0 in all nine rows, so that the restrictions that can bind are two (07:590-600). The table at 10:463-475 drops `pool_imbalance` and `feasible`, so the reader of 10 cannot see that.
- Also the generic @sec-choosing is cited at 10:52, 455, 475, 899 where 07 now has anchors: @sec-choosing-search (the preview of this very section), @sec-choosing-error (10:52, "finding 5"), @sec-choosing-cost (10:899, "cost table").
- Owner: **10** (own the definition of the four restrictions, cite @sec-choosing-search as the preview, report pool imbalance and which restrictions bind, re-point 10:52 and 10:899 to the anchors).

### 10-C5 (M) -- `max_use` is never defined in 10, though 07, 09 and 04b send the reader here for the definition
- Locations: first use 10:255 ("with `max_use` set"), 10:433-441, 10:866-873; promises: 07:531-538, 09:96-106 and 09:727-729, 04b:1195 ("@sec-choosing and @sec-combinatorial"), 11b:308 ("@sec-combinatorial carries `max_use` through every selector, defaulting to `NULL` everywhere").
- 10 uses three names for one quantity and its read-out: `cap` (`sel_truncation_cap(cap = ...)`, 10:152-166, 192), "per-line usage cap" / `max_use` (10:255, 433, 441), and `max_line` (the realised maximum, 10:136, 143). It never says that `cap` and `max_use` are the same count, that it is the largest number of the n selected hybrids that may share one line as a parent, that it defaults to `NULL` (no cap, bit-for-bit the pre-cap behaviour), or which functions accept it. The 09 formula for the penalty term (parent slots beyond the cap divided by 2n) is absent from 10:533-538 as well, so the fitness printed there is not the one `make_fitness(max_use = cap)` evaluates.
- Owner: **10** (define once, with the default and the three names). Then 04b:1195 (cite 10 for the definition) and 11b:308 stay Owed to those chapters, kept true by the definition.

### 10-C6 (M) -- the capped benchmark row quotes a cap that is not the chapter's, without saying so
- Locations: 10:851-874 (table row "Production scale, a budget and a per-line cap": book 1.112 etc.); regenerate.R:245 (`cap <- ceiling(4 * n_sel / ctx$n_lines)` = 5 at book scale, 4 at N = 10,000); 10:179 (the chapter's default cap, `ceiling(2 * n_sel / n_lines) + 1` = 4); 10b:566-568 ("the benchmark's cap, not the default").
- The reader compares the chapter's capped truncation (cap 4, index 0.820 retained 41 %) with a "capped greedy" at 1.112 (cap 5) without a note that the caps differ. Owner: **10** (state the cap and the scale, N, L, n, of each quoted number).

### 10-C7 (L) -- the unit-variance index is attributed to the wrong chapter
- Location: 10:43-45 (@sec-genomic-prediction); 03:575 and 03:680 (index standardised once, re-standardised to mean 0, s.d. 1, in `build_ctx()`); 08b:1163-1168 (only points to 03). THREAD 08b-C4.
- Owner: **10** (re-point to @sec-simulating-crosses).

### 10-C8 (M) -- "candidate pool" for the N hybrids, in a chapter whose pools are the heterotic groups
- Locations: 10:45, 10:52-53, 10:125 against 10:25 ("Two heterotic pools, A and B"), 03 (settled name "candidate set"; "pool" means a heterotic group), 90:20 and 90:30 ("candidate hybrids in the pool", "candidate-pool allele frequency", themselves owed to 90).
- Owner: **10** ("candidate set"); 90 stays Owed from 00/03.

### 10-C9 (M) -- the opening does not say why 10 follows 09, restates a problem 09 already stated, and promises a result the body does not deliver
- Locations: 10:19-22; 09 entry ("opens the Optimisation part (09 -> 10 -> 10b)", 09:96-106, 727-729 forward pointers to 10); body 10:673-679, 811-820, 895-900.
- 10:19 introduces "The problem is: choose n of N hybrids ..." as if for the first time; 09 has stated it (@eq-ocs-problem), set the budget (@eq-ocs-theta-max), derived the bound and told the reader that 10 supplies the decoder, `max_use` and the recipe. The chapter cites 09 only for the ceiling (10:84), the budget procedure (10:531) and the relaxation (10:683). It also promises "the differential evolution that beats them -- and explains why the DE only beats them under one specific condition" (10:20-22): no condition is named, and the body shows the warm-started DE below the best feasible greedy at the 1 % budget (10:673-679), "an optimiser earns its place only in the last row" (10:895).
- Owner: **10** (a sentence from 09 to 10; replace the promise by what is delivered: a budget-parameterised optimiser, warm start needed, restrictions a swap cannot test).

### 10-C10 (M) -- "production scale" means three different things in this chapter
- Locations: 10:347 (71 + 71 lines, 5,041 candidates); 10:504-507 and 10:853-873 (the benchmark's production scale: N = 10,000, L = 200, n = 200, cap 4); 10:568 ("the package's own simulation scale", 50 + 50 lines, 2,500 candidates, n = 100, the README finding); 10b:42-50 (says 10's "production" is the 71 + 71 dataset only, and that its own is N = 10,000); 07:615-620 (names the two benchmark scales with N, L, n, cap); THREAD 05 A8.
- 10b's disclaimer is not true of 10:504-507 and 10:853-873, which quote 10b's production. Owner: **10** (give N, L, n for every "book" and "production" number, or rename). 10b:42-50 then keep true.

### 10-C11 (M) -- two ranking claims from the benchmark are read from means that 07 says are unresolved
- Locations: 10:502-507 ("sel_de() finishes ahead ... at both scales", uncapped means 1.360 against 1.059 and 1.446 against 1.336); 10:853-857 ("the highest index of any capped route at both scales"); 07:613-646 (limit (b)).
- 07: uncapped, `sel_de()` ahead resolved at the book scale only; at the production scale "three seeds do not resolve" (paired difference 0.110, standard error 0.032 by the file); capped rows: sd 0 in every cell, "no standard error exists", and at production four capped methods return 1.1223 and `greedy_cap` 1.1225. 10 gives means only. "Highest of any capped route" at production is a 0.0002 difference with no spread to judge it by; the chapter says elsewhere (10:859-863) that book-scale timings are not separable but does not extend the caution to the index.
- Owner: **10**.

### 10-C12 (M) -- one quantity, two symbols: the index weight is $\omega$ in 09, 07 and 90 and $w$ in 10
- Locations: 10:263, 268, 281-289, 887 ($w$); 09 (ω, grid 1e-6 to 1e-1; 09 THREAD "sweep is the greedy over the index weight ω"); 07:495-496; 90:302 ("written $w$ in @sec-combinatorial"). 07 @sec-collapse uses bold $\mathbf w$ for line usage, which 10:421 refers to by name.
- 90 registers the exception, but 10 is the later chapter and the quantity is the same object as 09's. Owner: **10** (ω in the mathematics, `w` for the code argument and the plot axis); then 90:302 drops its parenthesis (**later, Owed** to 90).

### 10-C13 (M) -- "truncation is the floor on diversity", and "ceiling" used for three things
- Locations: 10:140 (also 90:694, 91:178); 10:81-84 and 10:530 ("attainable ceiling" = alpha of truncation); 10:264 ("the ceiling on diversity" = w = 0); 10:822-831 ("not a ceiling", the Lagrangian bound); 09:433-445 and 06:915-925 (alpha_trunc is the ceiling of the budget, "not the largest alpha any n-subset reaches").
- Truncation is not the floor on diversity of n-subsets (a plan using fewer lines would lose more; 09 says exactly this), and the chapter's own table shows the capped plan and truncation differ only in how evenly lines are used. "Ceiling" is used for the budget at which the constraint stops binding, for maximum diversity and for the upper bound on index.
- Owner: **10** (10:140, 10:264, one meaning per word); 90:694 and 91:178: **later (Owed)**.

### 10-C14 (M) -- the bound is re-derived in four steps, "certifies" overstates `converged`, and the gap rule is stated without the relaxation's own gap
- Locations: 10:700-713 (steps 1-4 re-derive @eq-ocs-theta-max, @eq-ocs-V and @eq-ocs-bound), 10:719-729, 09:204-266 and the under-convergence callout (09:378-432), 10b:731-733 and 10b:1311-1312.
- (a) Redundancy: 09 owns the derivation; 10 should cite @eq-ocs-bound and keep the call and the reading. (b) 10:726-727 "a bound the function certifies as converged": 09 states that `converged` is a stalling criterion on the doubling (relative 1e-3), not a certificate. (c) 10:723-724 "A large gap means the optimiser has not converged, not that the problem is intrinsically hard. A small gap means further optimiser effort is wasted": the gap is to a continuous relaxation of a discrete problem, so a large gap can also be the relaxation's; 09 says the greedy-to-bound gap is "an upper limit on what a better search could gain" and only if `converged`; 10b:945 says the true optimum is unknown at book scale. The chapter's own evidence (10b closes most of the 14.4 % at the same budget) supports the reading here, not the rule.
- Owner: **10**.

### 10-C15 (M) -- a ratio of the two arms is computed and printed that 07 withdraws, and 10b quotes it
- Locations: 10:478-486 (chunk `encoding-spread`, `echo: false`, prints `ratio_of_means` = 5.667); 07:589-595 ("A ratio of the two is not quoted: the index has no natural zero here"); 10b:519-521 ("a 5.7x margin"); CLAUDE.md ("Do not restate the book's 5.7x ...").
- Owner: **10** (drop `ratio_of_means` from the printed output); 10b:519-521: **later (Owed)**.

### 10-C16 (L) -- the same table and reading developed in full in 07 and in 10
- Locations: 07:560-600 (table, convergence figure, result paragraph, three limits), 10:461-517 (table, spread paragraph, three non-claims). 07 declares itself the preview (07:531-538), 10 the full treatment, but 07's is the more complete (slack constraints, pool imbalance, cold start, handler arm) and 10 omits those (10-C3, 10-C4).
- Owner: **10** owns (it is later and the owner by 07's own declaration); the full treatment must carry what 07 says. If 07's table is then cut to a pointer: **earlier (now)** or later; not required for 10's approval.

### 10-C17 (L) -- three names for the encoding under test
- Locations: 10:346 ("N-dimensional 0/1 encoding"), 10:423 ("N-dimensional key vector"), 10:457-459 (`decode_rank()`, "one random key per hybrid"), 10:481 and the table ("hybrid keys / penalty"); `sel_de()`'s own n_sel coordinates are also keys. The opening claim is about a 0/1 vector, the measurement about a rank-key decode.
- Owner: **10**.

### 10-C18 (L) -- the declared assumptions omit two of 09's and state a model as a fact
- Locations: 10:47-58 against 09:30-55; 10:50-52 ("the index carries error that is correlated with relatedness (@sec-choosing, finding 5)").
- Missing: the index is treated as the truth (09 item 3; every "index" in 10 is `ctx$index`) and the constraint pins the homozygosity lens only (09 item 5, only touched at 10:892). 07 Finding 5 is a simulation at teaching scale with nominal accuracy and two kinds of error, so "the index carries error correlated with relatedness" is its scenario, not an established property. The citation should be @sec-choosing-error.
- Owner: **10**.

### 10-C19 (L) -- N_s printed without its reading; $L_A$, $L_B$ not in 90
- Locations: 10:130-132, 10:88-105 and 10:555 (N_s 0.727-0.747); 07 and 90:627-630 (on molecular f, N_s in [1/2, 1], a rescaling of theta, not a head count; "the same information as alpha on an absolute scale" is not quite it, alpha also carries gd_ref); 10:25 uses $L_A$, $L_B$ (also 10b:165), 90 has $L$ only.
- Owner: **10** (a clause) and **later (Owed)** 90 (rows for $L_A$, $L_B$ or write $L_A$ as "lines of pool A").

## Owed to later chapters (from this review)
- `11` (11:306) and `12` (12:222): "the encoding, not the algorithm, decides": 07 and 10 (after 10-C3) support only a verdict on the N-dimensional key encoding at 60,000 evaluations, not on `sel_de()`.
- `11b:201`: "@sec-combinatorial's differential evolution finds slightly better plans per cycle" than greedy: 10 shows the DE below the best feasible greedy at the book scale (1.330 against 1.378; against 1.4227 on 09's grid). Keep true. `11b:308`: needs the definition of 10-C5.
- `04b:1195`: cite 10 for the `max_use` definition once 10-C5 is done.
- `10b:519-521` (5.7x); `10b:641-643` (09-M12b, already owed); `10b:42-50` keep true after 10-C10.
- `90:302` (ω written $w$), `90:694`, `91:178` (truncation "floor on diversity"), `90:20`, `90:30` (candidate pool).
- Render batch: `book/_freeze/10-combinatorial-selection/` and `docs/` are stale once the chapter is edited (it re-executes: DE runs, about 3 min); `book/downloads/10-combinatorial-selection.R` to regenerate.

## Checks with no finding
- `@sec-` targets: all 14 distinct targets cited in 10 resolve (sec-simulating-crosses 03, sec-why-not-g 01, sec-genomic-prediction 08b, sec-choosing and sec-collapse 07, sec-baseline and sec-ns 06, sec-heterosis 05b, sec-ocs and sec-relaxation 09, sec-advanced, sec-bound, sec-scaling 10b, sec-case-study 12). No `@fig-`, `@tbl-` or `@eq-` is cited: 10 cites none of 09's labelled equations (see 10-C14).
- The promises 10 makes forward are kept in 10b: @sec-advanced closes most of the gap (10b book scale, anneal 1.5276 against bound 1.5532), verifies the capped-truncation identity of `decode_lines()` at p = 0, measures cost in @sec-scaling (10b:992-1022), and holds the local search at equal wall-clock.
- 10:366-381 (decode example), 10:560-563 (penalty 1000 on the absolute excess, 0.1 pp = 1 index unit), the 4.5e5-evaluation README finding (10:567-573), 10:508-509 ("not cheaper per evaluation", CLAUDE.md) agree with their sources.

## Inbound `@sec-` citations of 10 (self-citations discarded; grep over `book/*.qmd`)

10 owns one anchor: `sec-combinatorial` (no subsection anchors).

| Anchor | Inbound | Files (lines) |
|---|---|---|
| `sec-combinatorial` | 40 in 15 files | 00:185, 748; 04b:1195; 04c:1000, 2240, 2274; 04d:386; 04e:1150; 05b:2094; 06:941; 07:496, 534, 539, 547, 615, 959, 1065; 09:88, 105, 728; 10b:29, 43, 50, 52, 69, 221, 512, 519, 561, 639, 735, 737, 1008, 1255; 11b:201, 308; 90:302; 91:62; 92:238; index:126 |

Outbound from 10 (for reference): `sec-advanced` 12, `sec-bound` 3, `sec-choosing` 4, `sec-ocs` 2, `sec-scaling` 2, one each for `sec-relaxation`, `sec-simulating-crosses`, `sec-why-not-g`, `sec-genomic-prediction`, `sec-baseline`, `sec-heterosis`, `sec-ns`, `sec-collapse`, `sec-case-study`. The one-anchor design means every reference to the decoder, to `max_use`, to the recipe or to the ceiling lands on the whole chapter; not a finding, but 07, 09 and 04b already cite it for three different topics.
