test_that("rank of the GCA matrix equals the graph prediction for every family", {
  set.seed(11)
  plans <- list(design_tester(30, 30, 1), design_tester(30, 30, 3),
                design_random_sparse(30, 30, 2), design_circulant(30, 30, 3),
                design_nc2(30, 30, 5, 5))
  for (p in plans) {
    d <- design_diagnostics(p, 30, 30)
    expect_equal(d$rank_gca, d$rank_expected)
  }
})

test_that("tester design has k(nA+nB)-k^2 crosses and k = 1 leaves no df for SCA", {
  expect_equal(nrow(design_tester(30, 20, 2)), 2 * 50 - 4)
  d <- design_diagnostics(design_tester(30, 20, 1), 30, 20)
  expect_equal(d$df_sca, 0)
  expect_true(d$connected)
})

test_that("circulant design is connected and exactly c-regular", {
  for (c in c(2, 3, 5)) {
    p <- design_circulant(40, 40, c)
    expect_true(design_diagnostics(p, 40, 40)$connected)
    expect_true(all(tabulate(p$parent1, 40) == c))
    expect_true(all(tabulate(p$parent2, 40) == c))
  }
})

test_that("NC II sets: rank nA+nB-s, within-set contrast estimable, between-set not", {
  p <- design_nc2(40, 40, 10, 10)
  d <- design_diagnostics(p, 40, 40)
  expect_equal(d$components, 4)
  expect_equal(d$rank_gca, 80 - 4)
  within  <- c(0, 1, -1, rep(0, 78))                 # A1 - A2, same set
  between <- c(0, 1, rep(0, 9), -1, rep(0, 69))      # A1 - A11, different sets
  expect_true(design_estimable(p, 40, 40, within)$estimable)
  expect_false(design_estimable(p, 40, 40, between)$estimable)
})

test_that("design_reps spends the budget and caps replication", {
  p <- design_reps(design_circulant(20, 20, 2), n_plots = 100, reps_max = 3)
  expect_equal(sum(p$reps), 100)
  p <- design_reps(design_circulant(20, 20, 2), n_plots = 1000, reps_max = 3)
  expect_true(all(p$reps == 3))
})

test_that("least-squares GCA error matches s2s/k + s2e/(k r) in a tester design", {
  # Sprague-Tatum: one pool's candidates crossed to k testers. The truth is
  # redrawn each replicate, so the testers' SCA is resampled as in the theory.
  set.seed(5)
  nA <- 60; nB <- 40; k <- 2; r <- 2; s2s <- 3; s2e <- 6
  err <- replicate(300, {
    tr <- simulate_factorial(nA, nB, 4, 4, s2s)
    p <- expand.grid(parent1 = seq_len(nA), parent2 = 1:k)
    p$reps <- r
    p <- simulate_cross_means(p, tr, s2e)
    f <- fit_gca(p, nA, nB, 4, 4, s2s, s2e, "ls")
    g <- tr$gA - mean(tr$gA)
    mean((f$gA - g)^2)
  })
  # (1 - 1/nA): the estimates are centred on the sample of nA lines
  expected <- (s2s / k + s2e / (k * r)) * (1 - 1 / nA)
  expect_equal(mean(err), expected, tolerance = 0.08)
})

test_that("BLUP converges to least squares when the GCA variance is large", {
  set.seed(2)
  tr <- simulate_factorial(20, 20, 4, 4, 1)
  p <- simulate_cross_means(design_reps(design_circulant(20, 20, 3), 120), tr, 2)
  ls <- fit_gca(p, 20, 20, 4, 4, 1, 2, "ls")
  bl <- fit_gca(p, 20, 20, 1e8, 1e8, 1, 2, "blup")
  expect_equal(bl$gA - mean(bl$gA), ls$gA, tolerance = 1e-5)
})

test_that("gca_accuracy_theory is vectorised and monotone in k", {
  a <- gca_accuracy_theory(1:8, 1, 8, 3, 40)
  expect_length(a, 8)
  expect_true(all(diff(a) > 0))
})

test_that("cross_cost accounts the nursery from plots back", {
  p <- design_reps(design_tester(20, 20, 1), n_plots = 39)   # 39 crosses, 1 plot
  cc <- cross_cost(p, 20, 20)
  expect_equal(unname(cc["ears"]), 39 * 2)                   # min_ears binds
  expect_equal(unname(cc["pollinations"]), 39 * 3)           # ceil(2 / 0.8)
  expect_equal(unname(cc["total"]), sum(cc[7:11]))
})
