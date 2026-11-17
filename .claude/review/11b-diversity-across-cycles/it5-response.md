# 11b -- iteration 5 response

| ID | Status | Evidence |
|---|---|---|
| 11b-D1 | fixed | The note was moved in the diagram code, not the caption: `text(37, 30.5, ...)` -> `text(70, 30.5, "diversity budget\napplies here", ...)`, centred above the "select n_sel" box (x 62-78). This matches the code: in `run_cycles()` the budget enters only through `sel_greedy_budget(ctx, n_sel, alpha_max, gd_ref, max_use)` (R/14_cycles.R:107), i.e. the choice of `n_sel` of the evaluated hybrids. fig-cap unchanged ("`n_sel` of them are selected (the diversity budget applies at this step)"); fig-alt now "A note above the select n_sel box says the diversity budget applies here, at the selection step." Chunk redrawn standalone at 6.5 x 3.05 in and viewed: the note sits above the select box, clear of the arrows. |
| 11b-M19 | fixed | Lines 481-485: after "(weak in cycles 2 to 6, ...)" added "That last reading is exploratory: the three windows were drawn after the data were seen, and each window value is a single correlation over pooled run-cycles with no spread attached." No number changed. |
