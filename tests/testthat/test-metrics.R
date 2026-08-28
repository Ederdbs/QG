# Sanity checks. Whatever fails here invalidates the whole benchmark.

test_that("theta via the submatrix equals theta via allele frequencies", {
  # The main one. If this fails, f was built wrong: centered, rescaled, or on
  # the wrong marker coding.
  expect_equal(theta_group(idx, ctx), theta_from_freq(idx, ctx), tolerance = 1e-10)
})

test_that("1 - theta is exactly Nei's He", {
  expect_equal(gene_diversity(idx, ctx), he_nei(idx, ctx), tolerance = 1e-10)
})

test_that("f is a genuine coancestry matrix, bounded to [0, 1]", {
  # Catches the mistake of using centered G instead, which goes negative.
  expect_gte(min(ctx$f), 0)
  expect_lte(max(ctx$f), 1)
})

test_that("the VanRaden G sums to zero, which is why diversity uses f", {
  # With Z centered on its own population, the sum of ALL elements of G is
  # exactly zero -> theta = 0 and Ns = infinity.
  expect_lt(abs(sum(ctx$G)), 1e-6 * ctx$N^2)
})

test_that("theta and Ns hit their analytical edge cases", {
  fake <- ctx
  fake$f <- matrix(1, 5, 5)                     # all identical and homozygous
  expect_equal(theta_group(1:5, fake), 1)
  expect_equal(status_number(1:5, fake), 0.5)

  # diagonal d, off-diagonal o  ->  theta = (d + (n - 1) o) / n
  fake$f <- diag(5) * 0.5 + 0.5                 # d = 1 (homozygous), o = 0.5
  expect_equal(theta_group(1:5, fake), (1 + 4 * 0.5) / 5)

  fake$f <- matrix(0.5, 5, 5)                   # d = o = 0.5: unrelated, p = 0.5
  expect_equal(theta_group(1:5, fake), 0.5)
  expect_equal(status_number(1:5, fake), 1)
})

test_that("greedy beats random and truncation loses diversity", {
  # Without this ordering there is no trade-off to optimise.
  set.seed(3)
  th_rand   <- mean(replicate(200, theta_group(sample.int(ctx$N, 40), ctx)))
  th_greedy <- theta_group(sel_greedy(ctx, 40, w = 0), ctx)
  th_trunc  <- theta_group(sel_truncation(ctx, 40), ctx)
  expect_lt(th_greedy, th_rand)
  expect_gt(th_trunc, th_greedy)
})

test_that("decode() is deterministic, unique and within bounds", {
  set.seed(5)
  for (i in 1:50) {
    d <- decode(runif(40, 1, ctx$N + 1), ctx$N, 40)
    expect_length(unique(d), 40)
    expect_true(all(d >= 1 & d <= ctx$N))
  }
})

test_that("the fast line route reproduces the hybrid-matrix route", {
  # theta_S = w' fL w exactly, so the N x N hybrid matrix is never needed.
  fctx <- fast_ctx(ctx)
  expect_equal(fast_theta(idx, fctx), theta_group(idx, ctx), tolerance = 1e-10)
  expect_equal(fast_ne_parents(idx, fctx), ne_parents(idx, ctx), tolerance = 1e-10)
  expect_equal(make_theta_fun(fctx)(idx), theta_group(idx, ctx), tolerance = 1e-10)
})

test_that("the incremental swap update matches a full recomputation", {
  fctx <- fast_ctx(ctx)
  st <- theta_state(idx, fctx)
  expect_equal(st$theta, theta_group(idx, ctx), tolerance = 1e-10)
  out_h <- idx[1]
  in_h  <- setdiff(seq_len(ctx$N), idx)[1]
  st2 <- theta_swap(st, out_h, in_h, fctx)
  expect_equal(st2$theta, theta_group(c(idx[-1], in_h), ctx), tolerance = 1e-10)
})

test_that("popcount32 matches a naive bit count", {
  set.seed(7)
  x <- as.integer(sample(0:2147483646, 500))
  naive <- vapply(x, function(z) sum(bitwAnd(bitwShiftR(z, 0:30), 1L)), integer(1))
  expect_identical(as.integer(popcount32(x)), naive)
})
