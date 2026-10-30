# 04b-backcross-introgression -- verdict, iteration 3

VERDICT: APPROVED

PREVIOUS IDS
- 04b-D17 -- CLOSED -- The callout at :838-842 now lists where each kind of dispersion is shown: CP intervals in fig-bc-index and tbl-bc-recheck, the CP lower bound in tbl-bc-index, a binomial s.e. in the fig-bc-alloc caption (:34, verified), and point estimates only in tbl-bc-ibd, fig-bc-policies and fig-bc-f2. This matches the three captions (:271, :36, :35). No caption contradicts it.
- 04b-D18 -- CLOSED -- The paragraph at :413-427 now claims only an ordering of point estimates. It declares three unpaired single estimates from a once-seeded scan, says the CSV has no drag s.d. (confirmed: mabc_uniform.csv has ibd_sd and drag_q95 but no drag s.d.), and says the first step is not resolved from zero. The stopifnot at :409 tests the point-estimate ordering that the text states.
- 04b-D19 -- CLOSED -- The criterion |z| >= 2 is defined once at :526-530, with the unpaired Wald z and its symbols. It is applied to all three comparisons and asserted by stopifnot (:515). Under rec_bg the ranking is explicitly declared "point estimates only". The phrase "two lowest point estimates under both indices" (:536-537) is now a statement about point estimates, so it is not an inferential claim.
- 04b-M5 -- CLOSED -- The typed seed-sweep maxima are removed. The comments now restrict the tolerance claim to the chunk's seed.
- 04b-M6 -- CLOSED -- The intro (:51-54) no longer reads as provenance. It says that not every cached copy was written by the current version and defers to sec-bc-running.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
None.

WHAT WAS VERIFIED
- z values were computed from mabc_allocation_recheck.csv, n = 1000 per schedule, with the unpaired Wald z:
  - rec_bg ("script"), 200/120/40 (0.662) against 20/150/190 (0.632): z = 1.404, so 1.40 and not separated.
  - rec_drag, 200/120/40 (0.924) against 20/150/190 (0.872): z = 3.856, so 3.86 and separated.
  - rec_drag, 120/120/120 (0.969) against 40/120/200 (0.955): z = 1.638, so 1.64 and not separated.
  - The two 20-plant schedules (300/40/20 and 20/150/190) are the two lowest under both indices, so the setequal assertion holds.
  - All three stopifnot conditions at :515 hold.
- The criterion is applied consistently. A grep for separat/tied/beats/better/worse/lowest/highest/outperform found every inferential "separated"/"not separated" in the changed recheck paragraph, each carrying its z. The remaining "lowest"/"highest" uses are:
  - :366 is the minimum of a tabulated quantity;
  - :401 is the fig-alt of a figure declared as point estimates;
  - :531 and :536 are explicitly labelled point estimates.
  No "beats", "tied" or "outperforms" claim exists.
- The :566 phrase "does not order the three schedules without a 20-plant generation beyond the intervals shown" is consistent with z_top = 1.64 (not separated). It does not claim an order.
- The fig-bc-alloc caption contains s.e. up to sqrt(0.25/n_rep), which is consistent with the D17 callout.
