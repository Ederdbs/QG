# 04g-joint-allocation -- verdict, iteration 3

VERDICT: APPROVED

PREVIOUS IDS
- 04g-D9 -- CLOSED -- book/04g-joint-allocation.qmd:137-139 now restricts "every line in the data at every split" to the circulant plans and says that in the random sparse plans of @sec-joint-results it does not hold. The new chunk `joint-uncrossed` (:496-519) and its prose (:521-535) quantify this, state that both counts are blind to an uncrossed line, and conclude that the two random configurations do not isolate the split. This agrees with :1294-1298 and with design_random_sparse()'s roxygen (R/16:62-64). Result 1 (:66-76, @sec-joint-split) rests on the circulant 160/80/40 plans only, so the confound does not reach any headline.
- 04g-M10 -- CLOSED -- 04f:653 now reads "gives a necessary screen and a counter-example to sufficiency, and leaves the metric open", which agrees with 04g:472-475. 04f:1404-1405 ("defines a pair of counts for it") is compatible.
- 04g-M11 -- CLOSED -- R/18:102-106 now documents s2res * trace(C^GCA) / (nF + nM) with C = W'W + blockdiag(G_t^-1 s2res / s2_t). That matches sparse_coef() (R/17:284-293) and the return at R/18:124 (`... * vc$s2res`). The roxygen also distinguishes the criterion from the mean PEV of pairwise differences.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
None new. (No new ID issued; the next free IDs remain 04g-D10 / 04g-M12.)

WHAT WAS VERIFIED
- Chunk `joint-uncrossed`: re-run against the worktree package with the same seeds. Share of plans with at least one uncrossed line: 0.34835 at c = 4 (set.seed(21)) and 0.001 at c = 8 (set.seed(22)), over 20000 plans each. The printed "0.348" and "0.001" match.
- The writer's remark that 0.348 sits about 2.5 SE above 0.335: 0.335 is the Poisson approximation 1 - exp(-40 C(380,80)/C(400,80)) = 0.3348, not the exact probability. It ignores the dependence between line events: a female and a male share one cell, so their uncrossed events are positively correlated. Exact inclusion-exclusion over the a females and b males left uncrossed, sum (-1)^(a+b+1) C(20,a) C(20,b) C(400-20a-20b+ab, 80) / C(400,80), gives 0.3439 at c = 4 and 0.00105 at c = 8. With binomial SE 0.00336 at n = 20000, the simulated 0.3484 is 1.3 SE above the exact value, which is consistent. The discrepancy came from the approximation, not from the simulation. The 0.335 does not appear in the chapter text (grep), so nothing printed is affected. Handled adequately.
- Counter-example plan (set.seed(23)): n_comp_cross = 1, n_comp_loc = 1 after coverage allocation to 8 locations at k = 2. design_diagnostics(): components = 1, connected = FALSE, lines_A = 19, lines_B = 19. These match the prose at :527-531 and the stopifnot.
- "design_components() labels it unused" -- R/16:33-34 sets unused lines to NA. "connected is FALSE because lines_A or lines_B falls short" -- R/16:196 requires all(degA > 0) && all(degB > 0). Both correct.
- Circulant claim at :138: design_circulant() with nA == nB gives every line exactly c crosses (R/16 roxygen), so every line is in the data at c = 8, 4 and 2. Correct.
- @sec-joint-split (:884 onward) draws no split conclusion from the random family. The random configurations appear only as figure categories.
