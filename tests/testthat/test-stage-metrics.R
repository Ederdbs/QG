# The S1-S4 pipeline metrics, and the identities each stage rests on.

test_that("molecular coancestry and modified Rogers distance are one statistic", {
  sim <- simulate_pools(n_A = 10, n_B = 10, m = 400, seed = 2)
  D <- mrd_matrix(sim$GL)
  expect_equal(coancestry_from_mrd(D), sim$fL, tolerance = 1e-10)
})

test_that("the two F_ST definitions differ, with Gst always the smaller", {
  sim <- simulate_pools(n_A = 15, n_B = 15, m = 600, seed = 3)
  d <- theta_decompose(sim$GL, sim$pool)
  expect_lt(d$Gst_Nei, d$Fst_Wright)
  # Nei's Gst computed the classical way must match the decomposition.
  expect_equal(unname(gst_nei(sim$GL, sim$pool)[["Gst"]]), d$Gst_Nei,
               tolerance = 1e-10)
})

test_that("the DH identities hold against a direct computation", {
  sim <- simulate_pools(n_A = 10, n_B = 10, m = 400, seed = 4)
  fL <- sim$fL
  expect_equal(dh_sib_coancestry(fL[1, 12]), (1 + fL[1, 12]) / 2)
  expect_equal(dh_cross_coancestry(fL, 1, 12, 3, 15),
               mean(fL[c(1, 12), c(3, 15)]))
})

test_that("hybrid theta from line usage matches the hybrid matrix", {
  sim <- simulate_pools(n_A = 10, n_B = 10, m = 400, seed = 5)
  ctxp <- ctx_from_pools(sim)
  set.seed(9); sel <- sample.int(ctxp$N, 30)
  u <- line_usage(sel, ctxp$parents, ctxp$n_lines)
  expect_equal(hybrid_theta_from_usage(u, sim$fL), ref_theta(sel, ctxp),
               tolerance = 1e-10)
})

test_that("the constrained line selection actually meets its ceiling", {
  sim <- simulate_pools(n_A = 30, n_B = 30, m = 500, seed = 6)
  fL <- sim$fL
  merit <- stats::rnorm(nrow(fL))
  ceil <- theta_ceiling(fL, n_sel = 20, alpha = 0.002)
  sel <- select_lines_constrained(merit, fL, n_sel = 20, theta_max = ceil)
  expect_length(sel, 20)
  expect_lte(s3_theta(sel, fL), ceil + 1e-9)
})

test_that("the reference oracles agree with the packaged metrics", {
  sim <- simulate_pools(n_A = 10, n_B = 10, m = 400, seed = 8)
  ctxp <- ctx_from_pools(sim)
  set.seed(10); sel <- sample.int(ctxp$N, 25)
  expect_equal(ref_theta(sel, ctxp), theta_group(sel, ctxp), tolerance = 1e-12)
  expect_equal(ref_theta_freq(sel, ctxp), theta_from_freq(sel, ctxp), tolerance = 1e-12)
  expect_equal(ref_he_nei(sel, ctxp), he_nei(sel, ctxp), tolerance = 1e-12)
  expect_equal(ref_ene(sel, ctxp), ene(sel, ctxp), tolerance = 1e-12)
  expect_equal(ref_ane(sel, ctxp), ane(sel, ctxp), tolerance = 1e-12)
  expect_equal(unname(ref_theta_pools(sel, ctxp)),
               unname(fast_theta_pools(sel, ctxp)), tolerance = 1e-10)
})

test_that("pool_freqs is the frequency matrix its callers used to rebuild", {
  sim <- simulate_pools(n_A = 12, n_B = 12, m = 500, seed = 9)
  P <- pool_freqs(sim$GL, sim$pool)
  expect_equal(dim(P), c(2L, 500L))
  expect_equal(rownames(P), levels(as.factor(sim$pool)))
  expect_equal(P[1, ], colMeans(sim$GL[sim$pool == rownames(P)[1], , drop = FALSE]))

  # mean_sq_delta_p is the statistic that enters the divergence half of
  # expected heterosis; mean_abs_delta_p is only a proxy for it.
  cm <- pool_complementarity(sim$GL, sim$pool)
  expect_equal(unname(cm[["mean_sq_delta_p"]]), mean((P[1, ] - P[2, ])^2))
  expect_equal(2 * heterosis_partition(P[1, ], P[2, ], rep(1, 500))[["divergence"]] / 500,
               unname(cm[["mean_sq_delta_p"]]))
  expect_true("mean_sq_delta_p" %in% names(s1_monitor(sim$GL, sim$pool, cycle = 3)))
})
