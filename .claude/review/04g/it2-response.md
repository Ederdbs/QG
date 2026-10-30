# 04g iteration 2 -- response

## quant-writer

| ID | Status | Evidence |
|---|---|---|
| 04g-D9 | fixed | :137-138 now restricts "every line in the data at every split" to the circulant plans and points to @sec-joint-criteria for the random family. New chunk `joint-uncrossed` (after tbl-joint-alias): share of random sparse 20 x 20 plans with >= 1 uncrossed line, computed live (`set.seed(21)`/`(22)` before each draw, 20000 plans): 0.348 at c = 4, 0.001 at c = 8 (hypergeometric check 1 - exp(-40 C(380,80)/C(400,80)) = 0.335). A c = 4 plan with an uncrossed line (`set.seed(23)`), coverage-allocated to 8 locations at k = 2, returns n_comp_cross = 1, n_comp_loc = 1, and `design_diagnostics()$connected` FALSE (lines_A = lines_B = 19); all three asserted by `stopifnot`. Prose states the counts are blind to an uncrossed line and that the two random configurations confound the split with the number of lines in the data; consistent with :1291-1295 (circulant only). |
| 04g-M10 | fixed | 04f:653 "@sec-joint-criteria proposes one" -> "@sec-joint-criteria gives a necessary screen and a counter-example to sufficiency, and leaves the metric open." |

## quant-Rwrite

| ID | Status | Evidence |
|---|---|---|
| 04g-M11 | fixed | R/18_joint_allocation.R:102-104 roxygen now reads `s2res * trace(C^GCA) / (nF + nM)`, with `C = W'W + blockdiag(G_t^-1 * s2res / s2_t)` (sparse_coef, R/17:284-293) and `C^GCA` the GCA block of `C^-1` -- matches the return at :124. man/joint_pev.Rd regenerated. test(filter="joint") 24/0 fail; full test 466/0 fail; install OK. |
