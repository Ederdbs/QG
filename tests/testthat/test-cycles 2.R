# Recurrent selection across cycles. The two things that can silently break
# here are the DH draw (a biased gamete would fabricate or destroy diversity)
# and the frozen base frequencies (re-anchoring p0 makes both inbreeding lenses
# report no loss forever, which is the trap chapter 12 warns about).

test_that("the DH draw is an unbiased gamete of its two parents", {
  set.seed(3)
  m <- 400
  GL <- rbind(rbinom(m, 1, 0.5), rbinom(m, 1, 0.5), rbinom(m, 1, 0.5))
  # Equal weights, many draws: the expected frequency of the offspring pool is
  # the mean parental frequency.
  reps <- replicate(400, colMeans(next_pool(GL, rep(1, 3), 3)))
  expect_equal(mean(rowMeans(reps)), mean(GL), tolerance = 0.01)

  # A pair that draws the same inbred line twice must return that line exactly:
  # selfing an inbred reproduces it, so the draw must be degenerate.
  one <- next_pool(GL[1, , drop = FALSE], 1, 5)
  expect_true(all(apply(one, 1, function(r) identical(as.integer(r),
                                                      as.integer(GL[1, ])))))
})

test_that("next_pool returns valid inbred lines", {
  set.seed(4)
  GL <- matrix(rbinom(10 * 200, 1, 0.4), 10, 200)
  out <- next_pool(GL, runif(10), 7)
  expect_equal(dim(out), c(7L, 200L))
  expect_true(all(out %in% c(0L, 1L)))
})

test_that("p0 is frozen at the founding cycle, not re-anchored", {
  set.seed(5)
  sim <- simulate_pools(n_A = 8, n_B = 8, m = 300, seed = 5)
  p0  <- colMeans(sim$X)
  gv  <- as.vector(sim$X %*% sim$beta)
  # A deliberately different set of lines, carrying the ORIGINAL p0.
  GL2 <- next_pool(sim$GL[1:8, ], rep(1, 8), 8)
  ctx2 <- cycle_ctx(rbind(GL2, sim$GL[9:16, ]), sim$pool, sim$beta,
                    p0, mean(gv), stats::sd(gv))
  expect_equal(ctx2$p0, p0)
  expect_false(isTRUE(all.equal(ctx2$p0, colMeans(ctx2$X))))
  expect_equal(ctx2$maf_pop, pmin(p0, 1 - p0))
})

test_that("a closed programme loses diversity and gains index", {
  r <- run_cycles(n_A = 12, n_B = 12, m = 600, n_cycles = 4, n_sel = 25,
                  alpha_max = 0.02, B_null = 60, seed = 2)
  expect_equal(nrow(r), 5L)
  expect_equal(r$cycle, 0:4)

  # Diversity erodes, index accumulates.
  expect_lt(r$GD[5], r$GD[1])
  expect_gt(r$index[5], r$index[1])

  # Both lenses measure against the frozen base, so both must move away from
  # zero. If p0 were re-anchored each cycle, F_drift would stay at ~0.
  expect_gt(r$F_drift[5], r$F_drift[1])
  expect_true(all(diff(r$F_drift) > 0))
})

test_that("the budget is respected, and Inf reduces to truncation", {
  r <- run_cycles(n_A = 12, n_B = 12, m = 600, n_cycles = 3, n_sel = 25,
                  alpha_max = 0.01, B_null = 60, seed = 6)
  # The greedy sweep is a grid, so it lands at or under the budget, never over.
  expect_true(all(r$alpha <= 0.01 + 1e-8))

  sim <- simulate_pools(n_A = 12, n_B = 12, m = 600, seed = 6)
  gv  <- as.vector(sim$X %*% sim$beta)
  ctx <- cycle_ctx(sim$GL, sim$pool, sim$beta, colMeans(sim$X),
                   mean(gv), stats::sd(gv))
  nl  <- null_distribution(ctx, 25, B = 60, B_full = 5)
  expect_equal(sort(sel_greedy_budget(ctx, 25, Inf, nl$gd_ref, NULL)),
               sort(sel_truncation(ctx, 25)))
})

test_that("an unconstrained programme erodes diversity faster", {
  a <- run_cycles(n_A = 12, n_B = 12, m = 600, n_cycles = 5, n_sel = 25,
                  alpha_max = 0.005, B_null = 60, seed = 8)
  b <- run_cycles(n_A = 12, n_B = 12, m = 600, n_cycles = 5, n_sel = 25,
                  alpha_max = Inf, B_null = 60, seed = 8)
  expect_gt(a$GD[6], b$GD[6])
  expect_gt(b$F_drift[6], a$F_drift[6])
})

test_that("injection restores diversity relative to a closed run", {
  closed <- run_cycles(n_A = 12, n_B = 12, m = 600, n_cycles = 5, n_sel = 25,
                       alpha_max = 0.02, B_null = 60, seed = 9)
  opened <- run_cycles(n_A = 12, n_B = 12, m = 600, n_cycles = 5, n_sel = 25,
                       alpha_max = 0.02, B_null = 60, seed = 9,
                       inject = list(cycle = 3, n = 4))
  expect_equal(closed$GD[1:3], opened$GD[1:3])   # identical before the event
  expect_gt(opened$GD[6], closed$GD[6])
})
