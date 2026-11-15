# 04b-backcross-introgression: response to editor.md and it2-verdict.md (quant-writer / quant-Rwrite)

No render run; `make_downloads.R` re-run; the purl'd chapter script was sourced end to end (all `stopifnot` pass).
Renamed or removed chunk labels: none. New labels: tbl-bc-psame, tbl-bc-traj, tbl-bc-dragcmp, tbl-bc-sizing-live. Chunk labels tbl-bc-foreground, tbl-bc-fixation, tbl-bc-recheck, fig-bc-f2 unchanged.

| ID | Status | What was done / reason |
|---|---|---|
| 04b-E1 | fixed | fig-bc-f2 legend moved from "topleft" to "bottomright"; checked on a scratch PNG of the chunk code: the legend clears the 1-gene curve and all points. |
| 04b-E2 | fixed | The four console outputs are now labelled kable tables with `tbl-cap` and cited before the chunk: tbl-bc-psame (eq-bc-psame, 3 distances), tbl-bc-traj (`pr$traj`), tbl-bc-dragcmp (rec_bg vs rec_drag drag at BC3), tbl-bc-sizing-live (`sizing_table()`). Code and seeds unchanged; the captions state they are one replicate, illustrative. |
| 04b-E3 | fixed | tbl-bc-recheck is one long table (7 columns: index, schedule, drag, P(lost), P(both), lo, hi; 5 schedules x 2 indices) instead of two 5-column blocks side by side. Label kept; text citing it never referred to the blocks. Values identical to the CSV (index renamed script -> rec_bg, drag -> rec_drag for display). |
| 04b-E4 | contested | mabc_sizing.png / mabc_policies.png are written by `inst/scripts/run_mabc.R` at production scale; fixing the font size means editing the driver and regenerating the PNGs, which is not mechanical here and cannot be checked without a render. Left for a figure pass. |
| 04b-E5 | fixed | `n_keep` added to the Backcrossing table of book/90-notation.qmd (after N, with `sizing_table(n_keep =)`). |
| 04b-E6 | fixed (partly) | tbl-bc-foreground, tbl-bc-fixation and tbl-bc-recheck use `#| tbl-cap: !expr` (captions defined in the setup chunk as cap_fg, cap_fix, cap_recheck, same pattern as cap_f2). tbl-bc-ibd, tbl-bc-s0, tbl-bc-index and tbl-bc-conversion-cost keep `kable(caption = sprintf(...))`: their captions use variables computed inside the chunk (d, miss, bg_miss, s0, lg, cost), so moving them would need a restructure, not a mechanical edit. They number and render correctly (editor.md section 1). |
| 04b-E7 | contested | Judgement item. The callout-important is a scope limit, not a trap that produced a wrong number; the reviewer verdicts (it1, it2) accepted it as written. Not changed. |
| 04b-E8 | contested | Palette choice, not mechanical: fig-bc-flow colours encode role (elite, donor), not pool; swapping them for book_pal needs a visual check that needs a render. Not changed. |
| 04b-M9 | fixed | qmd "Where this connects": "it is not satisfied, and the objective that binds is a different one" replaced by: IBD criterion binds as well; linkage drag does not stop binding at s = 0; the table measures IBD alone under rec_drag and the joint criterion at s = 0 was not run, so IBD is added, not substituted. No new number. |
| 04b-M11 | fixed | Pointer corrected: `max_use` of @sec-choosing and @sec-combinatorial (grep: 07 has 3 occurrences, 10 has 7, 09 has 0); @sec-ocs named as having the continuous `upper` cap, its analogue. |
| 04b-M10 | not assigned | Note only, declared limit already in the text; untouched. |
