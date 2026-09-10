# The objective side: genic variance and the disequilibrium term it excludes,
# inbreeding depression as the mirror of heterosis, and the two selection
# indices. Every claim the new chapters make in prose is asserted here.

set.seed(9)
beta_eff <- rnorm(ctx$m, 0, 1)

test_that("genic_var matches the literal oracle", {
  expect_equal(genic_var(ctx$X, beta_eff),
               ref_genic_var(ctx$X, beta_eff),
               tolerance = 1e-10)
})

test_that("realised variance minus genic variance is the disequilibrium term", {
  # var(X b) = sum_k sum_l b_k b_l Cov(x_k, x_l). genic_var is the diagonal, so
  # the difference must be exactly twice the upper triangle.
  gv <- drop(ctx$X %*% beta_eff)
  S  <- stats::cov(ctx$X)
  off <- sum(outer(beta_eff, beta_eff) * S) - sum(beta_eff^2 * diag(S))
  expect_equal(stats::var(gv) - genic_var(ctx$X, beta_eff), off, tolerance = 1e-8)
})

test_that("perfect negative disequilibrium hides the genic variance entirely", {
  X <- cbind(c(0, 0.5, 1, 0.5), c(1, 0.5, 0, 0.5))
  expect_gt(genic_var(X, c(1, 1)), 0)
  expect_equal(stats::var(drop(X %*% c(1, 1))), 0)
})

test_that("inbreeding depression equals the shared term of the heterosis partition", {
  # Falconer's identity: depression on inbreeding a pool to homozygosity and
  # heterosis on crossing within that same pool are one quantity.
  p <- colMeans(ctx$X)
  d <- rnorm(ctx$m, 0.3, 0.1)
  expect_equal(inbreeding_depression(p, d),
               heterosis_partition(p, p, d)[["shared"]],
               tolerance = 1e-10)
})

test_that("inbreeding depression is linear in F and zero without dominance", {
  p <- colMeans(ctx$X)
  d <- rnorm(ctx$m, 0.3, 0.1)
  expect_equal(inbreeding_depression(p, d, 0.5),
               inbreeding_depression(p, d, 1) / 2, tolerance = 1e-12)
  expect_equal(inbreeding_depression(p, rep(0, ctx$m)), 0)
})

test_that("the closed form agrees with simulated genotypes", {
  # Monte Carlo, so this is sampling agreement, not machine precision.
  p <- c(0.5, 0.2, 0.8, 0.35)
  d <- c(1, 2, 3, 1.5)
  expect_equal(inbreeding_depression(p, d, 0.6),
               ref_inbreeding_depression(p, d, 0.6, n = 40000, seed = 3),
               tolerance = 0.05)
})

test_that("the restricted index moves the restricted trait exactly zero", {
  set.seed(21)
  A <- matrix(rnorm(9), 3); P <- crossprod(A) + diag(3)
  B <- matrix(rnorm(9), 3); G <- crossprod(B) * 0.4
  a <- c(1, 0.5, 2)
  R <- cbind(c(0, 1, 0))
  b <- index_restricted(P, G, a, R)
  expect_equal(drop(crossprod(R, G %*% b)), 0, tolerance = 1e-10)
  # ... and the unrestricted index does not, or the restriction is vacuous.
  expect_gt(abs(drop(crossprod(R, G %*% index_smith_hazel(P, G, a)))), 1e-6)
})

test_that("the restricted index is the best index meeting its restriction", {
  # Any other weight vector satisfying the restriction, scaled to the same
  # index variance, achieves no more aggregate gain.
  set.seed(22)
  A <- matrix(rnorm(9), 3); P <- crossprod(A) + diag(3)
  B <- matrix(rnorm(9), 3); G <- crossprod(B) * 0.4
  a <- c(1, 0.5, 2); R <- cbind(c(0, 1, 0))
  b <- index_restricted(P, G, a, R)
  gain <- function(v) drop(crossprod(v, G %*% a)) / sqrt(drop(crossprod(v, P %*% v)))
  # Project an arbitrary vector onto the subspace the restriction allows,
  # {v : M v = 0} with M = R'G, then check none of them beats b.
  M <- crossprod(R, G)
  proj <- function(u) drop(u - crossprod(M, solve(tcrossprod(M), M %*% u)))
  for (s in 1:20) {
    set.seed(100 + s)
    alt <- proj(rnorm(3))
    expect_equal(drop(M %*% alt), 0, tolerance = 1e-8)
    expect_lte(gain(alt), gain(b) + 1e-9)
  }
})

test_that("with no restriction the restricted index is Smith-Hazel", {
  set.seed(23)
  A <- matrix(rnorm(4), 2); P <- crossprod(A) + diag(2)
  G <- diag(c(2, 0.5)); a <- c(1, 1)
  expect_equal(index_restricted(P, G, a, R = matrix(0, 2, 0)),
               index_smith_hazel(P, G, a), tolerance = 1e-10)
})

test_that("run_cycles reports both variances and they are ordered sanely", {
  cy <- run_cycles(n_A = 8, n_B = 8, m = 300, n_cycles = 2, n_sel = 12,
                   alpha_max = 0.02, n_qtl = 60, B_null = 30, seed = 5)
  expect_true(all(c("var_g", "var_genic") %in% names(cy)))
  expect_true(all(cy$var_genic > 0))
  expect_true(all(is.finite(cy$var_g)))
})
