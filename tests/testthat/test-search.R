# The selection layer had no tests at all before this file. These cover the
# three claims the advanced-selection methods rest on: the swap chain does not
# drift, the matroid cap is respected, and the bounds are bounds.

fctx <- fast_ctx(ctx)
nl   <- null_distribution(fctx, 20, B = 200, B_full = 20)

test_that("f is a Gram matrix, hence PSD, hence theta is a convex quadratic", {
  V <- cbind(ctx$X, 1 - ctx$X)
  expect_equal(ctx$f, tcrossprod(V) / ctx$m, tolerance = 1e-12)
  ev <- eigen(ctx$f, symmetric = TRUE, only.values = TRUE)$values
  expect_gt(min(ev), -1e-8)
  # and therefore d_ij = f_ii + f_jj - 2 f_ij is a squared Euclidean distance
  d2 <- outer(diag(ctx$f), diag(ctx$f), "+") - 2 * ctx$f
  expect_gte(min(d2), -1e-10)
})

test_that("at fixed n, maximising GD is minimising the submatrix sum", {
  s <- idx
  expect_equal(theta_group(s, ctx) * length(s)^2, sum(ctx$f[s, s]))
})

test_that("theta_swap does not drift over a long chain", {
  set.seed(4)
  n <- 20
  sel <- sample.int(fctx$N, n)
  st <- theta_state(sel, fctx)
  ins <- logical(fctx$N); ins[sel] <- TRUE
  for (k in 1:3000) {
    p <- sample.int(n, 1)
    repeat { h <- sample.int(fctx$N, 1); if (!ins[h]) break }
    st <- theta_swap(st, sel[p], h, fctx)
    ins[sel[p]] <- FALSE; ins[h] <- TRUE; sel[p] <- h
  }
  expect_equal(st$theta, theta_group(sel, fctx), tolerance = 1e-10)
})

test_that("sel_local_search returns a valid selection in all three modes", {
  for (m in c("hill", "anneal", "tempering")) {
    s <- sel_local_search(fctx, 20, 0.01, nl$gd_ref, mode = m, iters = 1500,
                          seed = 5)
    expect_length(s, 20)
    expect_false(anyDuplicated(s) > 0)
    expect_true(all(s >= 1 & s <= fctx$N))
    expect_equal(theta_state(s, fctx)$theta, theta_group(s, fctx),
                 tolerance = 1e-10)
  }
})

test_that("hill climbing never leaves the objective worse than its warm start", {
  ws <- sel_local_search(fctx, 20, 0.01, nl$gd_ref, mode = "hill", iters = 1,
                         seed = 5)
  s  <- sel_local_search(fctx, 20, 0.01, nl$gd_ref, mode = "hill", iters = 2000,
                         seed = 5)
  expect_gte(attr(s, "objective"), attr(ws, "objective") - 1e-12)
})

test_that("the per-line cap is a hard constraint, not a penalty", {
  cap <- 3
  expect_lte(max_line_use(sel_greedy(fctx, 20, w = 1, max_use = cap), fctx), cap)
  expect_lte(max_line_use(
    sel_local_search(fctx, 20, 0.02, nl$gd_ref, max_use = cap, iters = 1500,
                     seed = 2), fctx), cap)
  r <- ocs_round(fctx, 20, 0.02, nl$gd_ref, max_use = cap,
                 lambdas = c(1, 10), bound = 1)
  expect_lte(max_line_use(r$idx, fctx), cap)
  expect_length(r$idx, 20)
})

test_that("sel_greedy is unchanged when max_use is NULL", {
  expect_identical(sel_greedy(ctx, 20, w = 1), sel_greedy(ctx, 20, w = 1,
                                                          max_use = NULL))
  expect_length(sel_greedy(ctx, 20, w = 1, max_use = NULL), 20L)
})

test_that("make_fitness with max_use = NULL is the pre-change function", {
  set.seed(8)
  par <- runif(20, 1, ctx$N + 1)
  f_new <- make_fitness(ctx, 20, 0.01, nl$gd_ref)
  # the pre-change body, inlined
  f_old <- function(p) {
    i <- decode(p, ctx$N, 20)
    gd <- 1 - mean(ctx$f[i, i])
    -(mean(ctx$index[i]) - 1000 * max(0, (nl$gd_ref - gd) / nl$gd_ref - 0.01))
  }
  expect_equal(f_new(par), f_old(par))
})

test_that("make_fitness penalises a cap violation", {
  set.seed(8)
  par <- runif(20, 1, ctx$N + 1)
  free <- make_fitness(ctx, 20, 0.01, nl$gd_ref)
  capped <- make_fitness(ctx, 20, 0.01, nl$gd_ref, max_use = 1)
  expect_gt(capped(par), free(par))          # both are minimised, so worse = larger
})

test_that("the line route through ocs_relaxation is exact", {
  lam <- c(1, 10)
  a <- ocs_relaxation(fctx, 20, lam, iters = 300, lines = FALSE)
  b <- ocs_relaxation(fctx, 20, lam, iters = 300, lines = TRUE)
  expect_equal(a, b, tolerance = 1e-8)
})

test_that("ocs_bound converges and is a genuine upper bound", {
  b <- ocs_bound(fctx, 20, 0.02, nl$gd_ref, lambdas = 10^seq(-1, 3, length.out = 8),
                 iters = 500)
  expect_true(attr(b, "converged"))
  best <- max(vapply(
    Filter(function(s) alpha_loss(s, fctx, nl$gd_ref) <= 0.02,
           c(list(sel_local_search(fctx, 20, 0.02, nl$gd_ref, mode = "anneal",
                                   iters = 4000, seed = 2)),
             lapply(c(0, 1e-3, 1e-2, 0.1, 1, 10), function(w)
               sel_greedy(fctx, 20, w = w)))),
    mean_index, numeric(1), ctx = fctx))
  expect_gte(as.numeric(b) + 1e-8, best)
})

test_that("ocs_bound warns rather than returning an unconverged bound", {
  expect_warning(ocs_bound(fctx, 20, 0.02, nl$gd_ref, lambdas = c(1, 100),
                           iters = 1, max_doublings = 1L),
                 "did not converge")
})

test_that("ocs_round returns a valid plan and a valid bound", {
  r <- ocs_round(fctx, 20, 0.02, nl$gd_ref, lambdas = 10^seq(-1, 2, length.out = 5))
  expect_length(r$idx, 20)
  expect_false(anyDuplicated(r$idx) > 0)
  # the relaxation bounds every discrete plan meeting the same budget
  for (s in list(sel_greedy(fctx, 20, w = 1), r$idx,
                 sel_local_search(fctx, 20, 0.02, nl$gd_ref, iters = 1000, seed = 3)))
    if (alpha_loss(s, fctx, nl$gd_ref) <= 0.02)
      expect_gte(r$bound + 1e-8, mean_index(s, fctx))
})

test_that("sel_exact matches exhaustive enumeration on a tiny instance", {
  skip_if_not_installed("highs")
  set.seed(12)
  sub <- sort(sample.int(ctx$N, 18))
  s_ctx <- ctx
  s_ctx$f <- ctx$f[sub, sub]
  s_ctx$index <- ctx$index[sub]
  s_ctx$ped <- ctx$ped[sub, ]
  s_ctx$N <- 18
  gd_ref <- mean(replicate(400, {
    z <- sample.int(18, 4); 1 - mean(s_ctx$f[z, z])
  }))
  am <- 0.01
  budget_gd <- gd_ref * (1 - am)

  all_s <- combn(18, 4)
  feas <- apply(all_s, 2, function(s) (1 - mean(s_ctx$f[s, s])) >= budget_gd)
  best <- max(apply(all_s[, feas, drop = FALSE], 2,
                    function(s) mean(s_ctx$index[s])))

  e <- sel_exact(s_ctx, 4, am, gd_ref, time_limit = 30)
  expect_identical(e$status, "optimal")
  expect_equal(e$incumbent, best, tolerance = 1e-8)
})
