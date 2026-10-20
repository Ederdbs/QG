# Joint allocation (R/18_joint_allocation.R): crosses x locations.

test_that("every made cross gets k plots and unmade crosses none", {
  set.seed(1)
  p <- design_circulant(8, 8, c = 3)
  made <- (p$parent1 - 1L) * 8 + p$parent2
  for (s in c("random", "coverage", "optimised")) for (k in 1:2) {
    M <- joint_alloc(p, 8, 8, nLoc = 4, k = k, strategy = s, n_iter = 30)
    expect_true(all(rowSums(M)[made] == k))
    expect_equal(sum(M[-made, ]), 0)
  }
})

test_that("coverage balances loads and spreads both pools", {
  set.seed(2)
  p <- design_circulant(12, 12, c = 4)
  Mc <- joint_alloc(p, 12, 12, 4, 1, "coverage")
  expect_lte(diff(range(colSums(Mc))), 1)
  cr <- mean(replicate(20, sparse_connectivity(
    joint_alloc(p, 12, 12, 4, 1, "random"), 12, 12)$fem_cover))
  expect_gt(sparse_connectivity(Mc, 12, 12)$fem_cover, cr)
})

test_that("joint_pev is the GCA block of the full inverse", {
  set.seed(3)
  vc <- sparse_vc(0.3); A <- relmat_halfsib(6, 2)
  M <- joint_alloc(design_circulant(6, 6, 2), 6, 6, 3, 1, "coverage")
  cells <- which(M == 1L, arr.ind = TRUE)
  d <- sparse_terms(data.frame(hyb = cells[, 1], loc = cells[, 2]), 6, 6, 3, vc, A, A)
  W <- cbind(d$X, do.call(cbind, lapply(d$terms, `[[`, "Z")))
  Ci <- solve(sparse_coef(W, d, vc))
  ix <- ncol(d$X) + 1:12
  expect_equal(joint_pev(M, 6, 6, vc, A, A), mean(diag(Ci)[ix]) * vc$s2res)
})

test_that("the optimised allocation never scores worse than its coverage start", {
  vc <- sparse_vc(0.3); A <- relmat_halfsib(10, 2)
  p <- design_circulant(10, 10, c = 3)
  set.seed(4); Mc <- joint_alloc(p, 10, 10, 4, 2, "coverage")
  set.seed(4); Mo <- joint_alloc(p, 10, 10, 4, 2, "optimised", vc, A, A, n_iter = 60)
  expect_lte(joint_pev(Mo, 10, 10, vc, A, A), joint_pev(Mc, 10, 10, vc, A, A))
})

test_that("the component counts see disconnected blocks and locations", {
  # Two 3 x 3 NC II blocks at ONE location: the crosses are two components
  # even though every parent shares the location.
  p <- design_nc2(6, 6, a = 3, b = 3)
  h <- (p$parent1 - 1L) * 6 + p$parent2
  M1 <- matrix(0L, 36, 1); M1[h, 1] <- 1L
  cn <- joint_connectivity(M1, 6, 6)
  expect_equal(cn$n_comp_cross, max(design_components(p, 6, 6), na.rm = TRUE))
  expect_equal(cn$n_comp_cross, 2)
  expect_equal(cn$n_comp_loc, 1)
  # Each block in its own location: locations share no parent.
  M <- matrix(0L, 36, 2)
  M[h, 1] <- as.integer(p$parent1 <= 3); M[h, 2] <- as.integer(p$parent1 > 3)
  cn <- joint_connectivity(M, 6, 6)
  expect_equal(c(cn$n_comp_cross, cn$n_comp_loc), c(2, 2))
  # Both blocks in both locations: locations joined, blocks still apart.
  M[h, ] <- 1L
  cn <- joint_connectivity(M, 6, 6)
  expect_equal(c(cn$n_comp_cross, cn$n_comp_loc), c(2, 1))
  # A connected circulant plan over 3 locations: one and one.
  cn <- joint_connectivity(joint_alloc(design_circulant(6, 6, 2), 6, 6, 3, 1, "coverage"), 6, 6)
  expect_equal(c(cn$n_comp_cross, cn$n_comp_loc), c(1, 1))
})

test_that("optimised from an explicit start never ends above it", {
  vc <- sparse_vc(0.3); A <- relmat_halfsib(10, 2)
  p <- design_circulant(10, 10, c = 3)
  set.seed(5); M0 <- joint_alloc(p, 10, 10, 4, 2, "coverage")
  Mo <- joint_alloc(p, 10, 10, 4, 2, "optimised", vc, A, A, n_iter = 40, start = M0)
  expect_lte(joint_pev(Mo, 10, 10, vc, A, A), joint_pev(M0, 10, 10, vc, A, A))
  expect_true(all(rowSums(Mo) == rowSums(M0)))
})
