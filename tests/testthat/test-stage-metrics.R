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

test_that("constrained line selection meets an attainable ceiling (chapter 08 world)", {
  sim <- simulate_pools(30, 30, 3000, 0.15, seed = 12)
  fL <- sim$fL
  merit <- as.vector(sim$GL %*% sim$beta); merit <- (merit - mean(merit)) / sd(merit)
  ceil <- theta_ceiling(fL, n_sel = 20, alpha = 0.005)
  top <- order(merit, decreasing = TRUE)[1:20]
  expect_gt(s3_theta(top, fL), ceil)                 # truncation violates here
  sel <- select_lines_constrained(merit, fL, n_sel = 20, theta_max = ceil)
  expect_length(sel, 20); expect_false(anyDuplicated(sel) > 0)
  expect_lte(s3_theta(sel, fL), ceil)
  expect_true(attr(sel, "met"))
  expect_equal(attr(sel, "theta"), s3_theta(sel, fL), tolerance = 1e-12)
  expect_gt(attr(sel, "n_swap"), 0)
})

test_that("constrained line selection meets the ceiling with adversarial merit", {
  # merit = mean coancestry to the pool: the top-n are the MOST related lines,
  # the worst start for a repair that lets merit enter the swap score.
  sim <- simulate_pools(30, 30, 3000, 0.15, seed = 12)
  fL <- sim$fL
  merit <- rowMeans(fL)
  ceil <- theta_ceiling(fL, n_sel = 20, alpha = 0.005)
  expect_gt(s3_theta(order(merit, decreasing = TRUE)[1:20], fL), ceil)
  for (w in c(0, 0.25, 5)) {
    sel <- select_lines_constrained(merit, fL, 20, theta_max = ceil, merit_weight = w)
    expect_lte(s3_theta(sel, fL), ceil)
    expect_true(attr(sel, "met"))
  }
})

test_that("a ceiling the swap cannot reach warns and flags, and no swap cycles", {
  sim <- simulate_pools(n_A = 15, n_B = 15, m = 500, seed = 6)
  fL <- sim$fL; merit <- rowMeans(fL)
  expect_warning(sel <- select_lines_constrained(merit, fL, 10, theta_max = 0.01),
                 "not met")
  expect_false(attr(sel, "met"))
  expect_lt(attr(sel, "n_swap"), 5000)               # stopped at a local minimum
  # every accepted swap lowers theta: the result is no worse than the top-n
  expect_lte(s3_theta(sel, fL), s3_theta(order(merit, decreasing = TRUE)[1:10], fL))
})

test_that("one repair swap with merit_weight = 0 is the best single swap (oracle)", {
  sim <- simulate_pools(n_A = 12, n_B = 12, m = 400, seed = 3)
  fL <- sim$fL; merit <- stats::rnorm(nrow(fL))
  top <- order(merit, decreasing = TRUE)[1:8]
  sel <- select_lines_constrained(merit, fL, 8, theta_max = 0, max_swap = 1,
                                  merit_weight = 0) |> suppressWarnings()
  best <- Inf
  for (i in top) for (j in setdiff(seq_len(nrow(fL)), top))
    best <- min(best, s3_theta(c(setdiff(top, i), j), fL))
  expect_equal(s3_theta(sel, fL), best, tolerance = 1e-12)
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

test_that("dh_pool_theta weights the self-coancestry correction by n_c / D", {
  sim <- simulate_pools(30, 30, 3000, 0.15, seed = 12)
  fL <- sim$fL
  set.seed(88)
  crosses <- cbind(sample(1:30, 6), sample(1:30, 6))
  crosses <- crosses[crosses[, 1] != crosses[, 2], , drop = FALSE]
  oracle <- function(crosses, n_per) {   # literal pair-by-pair expectation
    C <- nrow(crosses)
    fam <- rep(seq_len(C), times = n_per)
    Fcc <- outer(seq_len(C), seq_len(C),
                 Vectorize(function(a, b) mean(fL[crosses[a, ], crosses[b, ]])))
    E <- Fcc[fam, fam]; diag(E) <- 1
    mean(E)
  }
  n_unequal <- c(5, 40, 10, 80, 20, 60)[seq_len(nrow(crosses))]
  expect_equal(dh_pool_theta(crosses, n_unequal, fL), oracle(crosses, n_unequal),
               tolerance = 1e-12)
  expect_equal(dh_pool_theta(crosses, 40, fL),
               oracle(crosses, rep(40, nrow(crosses))), tolerance = 1e-12)
})
