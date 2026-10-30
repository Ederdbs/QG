# 04b -- iteration 2 response

## quant-writer

Files: book/04b-backcross-introgression.qmd, book/downloads/ (make_downloads.R). Chapter purled
and sourced from book/ with _common.R; all 111 inline expressions evaluated; no render.

| ID | Status | Note |
|---|---|---|
| 04b-D17 | fixed | Callout now says where intervals are and are not shown: CP intervals in @fig-bc-index and @tbl-bc-recheck, CP lower bound in @tbl-bc-index, binomial s.e. in the @fig-bc-alloc caption; @tbl-bc-ibd, @fig-bc-policies, @fig-bc-f2 point estimates only, as their captions state. |
| 04b-D18 | fixed | mabc_uniform.csv has no drag s.d. (columns checked; only drag_q95), so no s.e. can be computed. "Most of the reduction comes from letting drag decide" replaced by the point-estimate ordering only, stated as three unpaired single estimates from a once-seeded scan with no dispersion, and the first step not resolved from zero. The stopifnot (point estimates) now matches the weakened claim. |
| 04b-D19 | fixed | Criterion stated once and used throughout: separated iff abs(z) >= 2, unpaired Wald z with symbols defined. All z inline: balanced vs 40/120/200 (rec_drag) z = 1.64, not separated; two 20-plant schedules have the two lowest point estimates under both indices; under rec_drag 20/150/190 vs 200/120/40 z = 3.86, separated; under rec_bg z = 1.40, not separated, ranking stated as point-estimate only. All three z conditions asserted by stopifnot. |
| 04b-M5 | fixed | Typed seed-sweep maxima removed from both chunk comments; comments now say the tolerance is checked at the chunk's seed only. |
| 04b-M6 | fixed | Intro: run_mabc.R writes tables of the shape of the six cached files, but not every cached copy was written by its current version; provenance deferred to @sec-bc-running. |
