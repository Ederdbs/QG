# Sparse testing (R/17_sparse_testing.R): the allocations do what Chapter 4f
# says they do, and the mixed-model solve equals the literal GLS oracle.

test_that("every allocation puts each hybrid in exactly k locations", {
  set.seed(1)
  for (s in c("random", "parentage")) for (k in 1:3) {
    M <- sparse_alloc(6, 3, 4, k, s)
    expect_true(all(rowSums(M) == k))
  }
  expect_equal(sum(sparse_alloc(6, 3, 4, strategy = "complete")), 6 * 3 * 4)
})

test_that("the parentage design puts both whole pools in every location", {
  set.seed(2)
  for (k in 1:3) {
    cn <- sparse_connectivity(sparse_alloc(10, 10, 6, k, "parentage"), 10, 10)
    expect_equal(cn$fem_cover, 1)
    expect_equal(cn$male_cover, 1)
  }
  # k = 3 over 6 locations: 10 groups cover 30 location pairs, enough for all
  # 15, and the exchange search finds an assignment leaving none disconnected.
  # (At k = 2 they cover only 10 of the 15 and some pair must share nothing.)
  cn <- sparse_connectivity(sparse_alloc(10, 10, 6, 3, "parentage"), 10, 10)
  expect_equal(cn$frac_disconn, 0)
})

test_that("sparse_vc solves the plot heritability", {
  vc <- sparse_vc(0.3, "high")
  expect_equal(vc$Vg / (vc$Vg + vc$VgxE + vc$s2e), 0.3)
  expect_equal(vc$s2res, vc$s2e + vc$s2sl)
})

test_that("sparse_blup equals the literal GLS oracle, untested hybrids included", {
  set.seed(3)
  nF <- 4; nM <- 3; L <- 3
  Af <- relmat_halfsib(nF, 2); Am <- diag(nM) * 0.8 + 0.2
  vc <- sparse_vc(0.4)
  M <- sparse_alloc(nF, nM, L, 2, "random")
  M[c(2, 7), ] <- 0L                       # two hybrids never tested (CV1)
  sim <- sparse_simulate(M, nF, nM, vc, Af, Am)
  fast <- sparse_blup(sim$pheno, nF, nM, L, vc, Af, Am)
  ref  <- ref_sparse_blup(sim$pheno, nF, nM, L, vc, Af, Am)
  expect_equal(fast$blup, ref$blup, tolerance = 1e-8)
  expect_equal(fast$pev, ref$pev, tolerance = 1e-8)
})

test_that("the BLUP is not dispersed: slope of truth on prediction is near 1", {
  set.seed(4)
  nF <- 10; nM <- 10; L <- 4
  Af <- relmat_halfsib(nF, 5); Am <- relmat_halfsib(nM, 5)
  vc <- sparse_vc(0.4)
  b1 <- replicate(20, {
    M <- sparse_alloc(nF, nM, L, 2, "parentage")
    sim <- sparse_simulate(M, nF, nM, vc, Af, Am)
    fit <- sparse_blup(sim$pheno, nF, nM, L, vc, Af, Am)
    unname(stats::coef(stats::lm(sim$g_target ~ fit$blup))[2])
  })
  expect_lt(abs(mean(b1) - 1), 0.1)
})
