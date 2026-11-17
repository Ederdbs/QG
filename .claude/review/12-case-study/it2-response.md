# 12-case-study -- response to the iteration 2 verdict (it3 fix)

Files: `book/12-case-study.qmd`, `book/90-notation.qmd`, `.claude/review/THREAD.md`, `book/downloads/*.R` (`make_downloads.R`). No number changed; three new inline values are computed from existing objects and were evaluated by purling and running the chapter against this checkout: 5 DE runs, sqrt(1/80 + 1/500) = 0.12, truncation margin 0.0057-0.0102 over 20 pairs, 30-fold. No render.

| ID | Status | Where / what |
|---|---|---|
| 12-M12 | fixed | 12:95-99: the muffled advice is named as "raised once per DE run, `r ...` (5) times in this call"; the surfacing sentence names its referent, "the inoperative-budget one included". |
| 12-M13 | fixed | 12:92-94: above the ceiling `stage2_select()` warns and then still runs the DE and returns the plan under its `DE_alpha_*` label (R/11_stage2.R:99-102, 114-118). |
| 12-M14 | fixed | Result paragraph gains the margin, computed inline from `top`: 0.0057 to 0.0102 index units over the 20 (seed, budget) pairs. Interpretation scoped to "both budgets run ... not closed by the 30-fold increase in nominal evaluations (NP x itermax) between them; no larger budget was run" (30 from `np_it()`). |
| 12-M15 | fixed | 12:209-217: "near zero on average only"; `gd_ref` is the mean of the B_null = 500 draws, `z_GD` centred and scaled on the separate B_full = 80 draws; s.d. about sqrt(1/80 + 1/500) = 0.12 z units (inline), assumptions stated (independent draws, B_full s.d. taken as exact); the printed value is one draw of that error. "The same null" removed. |
| 12-M16 | fixed | 90:161-162: @sec-case-study dropped from the list of chapters that write the Balding-Nichols setting as $F_{ST}$. |
| 12-M17 | fixed | THREAD 12 entry: heading carries the it2 verdict; the 90 item marked done; code pass recorded as done (with what was optional and not done); the `case_study` target and the two untracked CSVs that must be committed and pushed; the orphan `unnamed-chunk-13-1` (freeze png/svg, docs png) listed for deletion at render; 90 added to the stale-freeze list. |
