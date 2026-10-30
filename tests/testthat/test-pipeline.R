# The two-stage contract, end to end.

test_that("stage 1 returns consistent X, f and hybrids", {
  st1 <- stage1_simulate(cfg)
  expect_true(all(c("X", "f", "hybrids") %in% names(st1)))
  expect_lte(max(st1$X), 1)
  expect_gte(min(st1$f), 0)
  expect_lte(max(st1$f), 1)
  expect_true(all(c("hybrid", "line_A", "line_B") %in% names(st1$hybrids)))
  expect_equal(nrow(st1$hybrids), nrow(st1$X))
})

test_that("stage 2 returns one 0/1 column per scenario, each selecting n_sel", {
  st1 <- stage1_simulate(cfg)
  # NP is deliberately tiny here: this asserts the output contract, not
  # convergence. DEoptim's "NP should be 10x the parameter vector" advice is
  # correct and irrelevant to that.
  r <- suppressWarnings(
    stage2_select(st1$X, st1$f, st1$hybrids, n_sel = 20, alphas = c(0, 0.02),
                  fL = st1$fL, B_null = 50, B_full = 20, NP = 40, itermax = 30,
                  verbose = FALSE))
  scn <- setdiff(names(r$selection), c(names(st1$hybrids), "n_scenarios"))
  expect_equal(nrow(r$selection), nrow(st1$X))
  expect_true(all(vapply(r$selection[scn], sum, numeric(1)) == 20))
  expect_true(all(unlist(r$selection[scn]) %in% 0:1))
  expect_equal(nrow(r$metrics), length(scn))

  # Both lenses, the partition and the z-scores are all exported.
  new_cols <- c("F_hom", "F_drift", "cov_diag", "rare_retained",
                "GD_WI_hyb", "GD_T", "GD_WI", "GD_BI", "GD_BS", "F_ST")
  expect_true(all(new_cols %in% names(r$metrics)))
  expect_equal(nrow(r$z_scores), nrow(r$metrics))
  expect_true("z_Ne_parents" %in% names(r$z_scores))
  expect_false(anyNA(r$metrics$F_drift))
})

test_that("stage 2 runs without fL, losing only the pool decomposition", {
  st1 <- stage1_simulate(cfg)
  r2 <- suppressWarnings(
    stage2_select(st1$X, st1$f, st1$hybrids, n_sel = 20, alphas = 0,
                  B_null = 50, B_full = 20, NP = 40, itermax = 30,
                  verbose = FALSE))
  expect_true(is.na(r2$metrics$theta_A[1]))
  expect_false(is.na(r2$metrics$Ne_lines_A[1]))
  expect_true(is.na(r2$metrics$GD_BS[1]))
  expect_false(is.na(r2$metrics$GD_WI_hyb[1]))
})

test_that("stage1_build accepts both 0/1/2 and 0/0.5/1 marker coding", {
  st1 <- stage1_simulate(cfg)
  ped <- data.frame(a = st1$hybrids$line_A, b = st1$hybrids$line_B)
  traits <- st1$hybrids[, grep("^trait", names(st1$hybrids))]
  a <- stage1_build(st1$X, ped, traits)
  b <- stage1_build(st1$X * 2, ped, traits)
  expect_equal(a$X, b$X)
  expect_equal(a$f, b$f)
})

test_that("stage1_build coding: declared 012, ambiguous auto warns, NA ignored", {
  X <- rbind(c(0, 1, 1),
             c(1, 0, 1))                       # 0/1/2 dosages, no dosage 2
  ped <- data.frame(a = 1:2, b = 3:4)
  tr <- data.frame(trait1 = c(0, 0))
  f012 <- stage1_build(X, ped, tr, coding = "012")$f
  # every locus heterozygous or 0: self-coancestry = mean over loci of 1 or 1/2
  expect_equal(diag(f012), c(mean(c(1, 0.5, 0.5)), mean(c(0.5, 1, 0.5))))
  expect_equal(f012[1, 2], 0.5)                 # each locus: x1 x2 + (1-x1)(1-x2) = 0.5
  expect_equal(f012, tcrossprod(cbind(X / 2, 1 - X / 2)) / ncol(X))
  expect_warning(fa <- stage1_build(X, ped, tr)$f, "ambiguous")
  expect_equal(diag(fa), c(1, 1))
  expect_identical(stage1_build(X, ped, tr, coding = "0-0.5-1")$f, fa)
  expect_error(stage1_build(X, ped, tr, coding = "dosage"))
  expect_error(stage1_build(X * 2, ped, tr, coding = "0-0.5-1"))
  # NA ignored in detection: a 2 elsewhere still means 0/1/2, no warning
  Xna <- rbind(c(0, NA, 2), c(1, 0, 1))
  expect_no_warning(b <- stage1_build(Xna, ped, tr))
  expect_identical(b$X, Xna / 2)
  expect_true(is.na(b$f[1, 2]))
  # NA with only 0/0.5/1 present: unambiguous, no warning, unchanged
  Xh <- rbind(c(0, NA, 0.5), c(1, 0, 0.5))
  expect_no_warning(h <- stage1_build(Xh, ped, tr))
  expect_identical(h$X, Xh)
})
