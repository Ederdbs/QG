# The two lenses of Meuwissen et al. (2020), and the covariance between them.

test_that("F_hom and F_drift are exactly zero when the selection is the base", {
  fm_all <- freq_metrics(seq_len(ctx$N), ctx)
  expect_equal(fm_all[["F_hom"]], 0, tolerance = 1e-10)
  expect_equal(fm_all[["F_drift"]], 0, tolerance = 1e-10)
})

test_that("Eq. 3 holds: the gap between the lenses is entirely the covariance", {
  fm <- freq_metrics(idx, ctx)
  expect_equal(fm[["cov_diag"]], fm[["F_hom"]] - fm[["F_drift"]], tolerance = 1e-8)
})

test_that("max-diversity drives F_hom negative while paying the largest drift", {
  # F_drift is never negative; F_hom is allowed to be, and the pure
  # max-diversity greedy (the G_0.5 scheme) is exactly where it goes negative.
  # That signature is the whole point of the two-lens argument.
  fm_div <- freq_metrics(sel_greedy(ctx, 40, w = 0), ctx)
  fm_tru <- freq_metrics(sel_truncation(ctx, 40), ctx)
  expect_gte(fm_div[["F_drift"]], 0)
  expect_gte(fm_tru[["F_drift"]], 0)
  expect_gt(fm_div[["F_drift"]], 0)
  expect_lt(fm_div[["F_hom"]], fm_tru[["F_hom"]])
})

test_that("consolidating the marker sweep changed no existing number", {
  fm <- freq_metrics(idx, ctx)
  expect_equal(fm[["He"]], he_nei(idx, ctx), tolerance = 1e-12)
  expect_equal(fm[["alleles_lost"]], alleles_lost(idx, ctx))
})

test_that("the Caballero & Toro partition closes exactly", {
  gp <- gd_partition(idx, ctx)
  expect_equal(gp[["GD_WI"]] + gp[["GD_BI"]] + gp[["GD_BS"]], gp[["GD_T"]],
               tolerance = 1e-10)
  expect_equal((gp[["GD_WI"]] + gp[["GD_BI"]]) / gp[["GD_T"]], 1 - gp[["F_ST"]],
               tolerance = 1e-10)
  expect_gt(gp[["GD_BS"]], 0)
})

test_that("inbred lines carry no within-individual diversity, their F1s do", {
  gp <- gd_partition(idx, ctx)
  expect_lt(gp[["GD_WI"]], 1e-9)
  expect_gt(gp[["GD_WI_hyb"]], 0.1)
})

test_that("eff_dim stays in (0, n - 1]", {
  ed <- eff_dim(idx, ctx)
  expect_gt(ed, 0)
  expect_lte(ed, length(idx) - 1 + 1e-8)
})
