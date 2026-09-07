testthat::skip_if_not_installed("AlphaSimR")

test_that("alphasimr_pipeline produces a contract-compliant stage-1 output", {
  cfg <- modifyList(rrs_config, list(n_pool_A = 6, n_pool_B = 6, n_dh = 2,
                                     n_sel = 3, n_testers = 2, n_cycles = 2,
                                     seg_sites = 30, n_chr = 2, n_traits = 2))
  res <- alphasimr_pipeline(cfg)
  st1 <- res$stage1

  expect_named(st1, c("X", "f", "hybrids", "fL"))
  expect_true(all(st1$X >= 0 & st1$X <= 1))
  expect_true(all(st1$f >= 0 & st1$f <= 1))
  expect_equal(st1$f, t(st1$f))
  expect_equal(nrow(st1$X), nrow(st1$hybrids))
  expect_equal(nrow(st1$fL), ncol(st1$fL))
  expect_true(all(c("hybrid", "line_A", "line_B") %in% names(st1$hybrids)))

  ctx <- build_ctx_from_stage1(st1$X, st1$f, st1$hybrids, st1$fL)
  expect_true(all(is.finite(ctx$p0)))
  expect_true(all(is.finite(ctx$maf_pop)))

  tp <- theta_pools(seq_len(ctx$N), ctx)
  expect_false(anyNA(tp))

  expect_equal(nrow(res$cycles), cfg$n_cycles)
  expect_true(all(res$cycles$gd_A >= 0 & res$cycles$gd_A <= 1))
  expect_true(all(res$cycles$gd_B >= 0 & res$cycles$gd_B <= 1))
})

test_that("alphasimr_gd matches molecular_coancestry on the same genotypes", {
  cfg <- modifyList(rrs_config, list(n_pool_A = 5, n_pool_B = 5, seg_sites = 20,
                                     n_chr = 1))
  fp <- alphasimr_founder_pools(cfg)
  geno <- AlphaSimR::pullSegSiteGeno(fp$pop_A, simParam = fp$SP) / 2
  expect_equal(alphasimr_gd(fp$pop_A, fp$SP), 1 - mean(molecular_coancestry(geno)))
})
