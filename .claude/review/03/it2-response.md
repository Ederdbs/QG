# Response: 03-simulating-crosses, iteration 2

## quant-writer

| ID | Status | Change / evidence |
|---|---|---|
| 03-D7 | fixed | :16-20 now states that, with @sec-response's arguments, both generators return the same lines and the same `X`; only the traits differ. Asserted in the `simulate_lines` chunk: `stopifnot(identical(2 * sim_02b[["GL"]], L), identical(sim_02b[["X"]], simulate_data(book_cfg)[["X"]]))` (both TRUE, ~0.2 s). |
| 03-D8 | fixed | The @sec-heterosis-flat expectation is now qualified "for pools of unbounded size"; the finite-pool form is written out: E[GD_BS] = F_BN p*q* + (1 - F_BN) p*q*/n per marker, loss of GD_T = gain of GD_BS = F_BN p*q*(1 - 1/n), and the (1 - 1/n) factor is stated to cancel in the ratios 1 and 2. Inline numbers: 0.0666 (n = 25) against 0.0694 (unbounded), matching the verifier's 0.0666 / 0.0694. |
| 03-M8 | fixed | New chunk `divergence-trade-replicates` (200 replicate grids, seeds 1-200, grid ends only, 0.6 s). Prose says both ratios are single draws and gives mean 1.002 / 2.008, SD 0.104 / 0.102 inline, then the inference in a separate sentence. |

Checks: `Rscript book/scripts/make_downloads.R` ok; purled chapter sourced from `book/` with `_common.R` in 2.8 s, all `stopifnot()` pass. Not rendered.
