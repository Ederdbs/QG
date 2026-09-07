# Heterosis under a pure dominance model, and its exact relation to the
# Caballero & Toro partition the rest of the package already computes.

set.seed(4)
d_eff <- rnorm(ctx$m, 0.3, 0.1)
L_lines <- simulate_lines(cfg)

test_that("the fast heterosis route matches the literal oracle", {
  small <- head(ctx$ped, 25)
  expect_equal(
    heterosis_value(ctx$X[seq_len(25), , drop = FALSE], d_eff),
    ref_heterosis(L_lines, small, d_eff),
    tolerance = 1e-10
  )
})

test_that("additive effects cancel from mid-parent heterosis", {
  # Inbred parents are homozygous, so their additive values average to the F1's
  # own. Whatever `a` is, the mid-parent difference is the dominance term.
  a_eff <- rnorm(ctx$m, 0, 2)
  Lh <- L_lines / 2
  val <- function(x) sum(a_eff * (2 * x - 1)) + sum(d_eff * (x == 0.5))
  i <- 7L
  mp <- (val(Lh[ctx$ped$a[i], ]) + val(Lh[ctx$ped$b[i], ])) / 2
  expect_equal(val(ctx$X[i, ]) - mp, heterosis_value(ctx$X[i, , drop = FALSE], d_eff),
               tolerance = 1e-8)
})

test_that("the closed form is the mean of the realised values over all crosses", {
  nA <- cfg$n_pool_A
  pA <- colMeans(L_lines[seq_len(nA), , drop = FALSE] / 2)
  pB <- colMeans(L_lines[nA + seq_len(cfg$n_pool_B), , drop = FALSE] / 2)
  # ctx holds every A x B cross, so the mean over rows is the expectation.
  expect_equal(heterosis_expected(pA, pB, d_eff),
               mean(heterosis_value(ctx$X, d_eff)), tolerance = 1e-10)
  expect_equal(heterosis_partition(pA, pB, d_eff)[["total"]],
               heterosis_expected(pA, pB, d_eff), tolerance = 1e-10)
})

test_that("the two heterosis components are GD_T and GD_BS", {
  nA <- cfg$n_pool_A
  pA <- colMeans(L_lines[seq_len(nA), , drop = FALSE] / 2)
  pB <- colMeans(L_lines[nA + seq_len(cfg$n_pool_B), , drop = FALSE] / 2)
  hp <- heterosis_partition(pA, pB, rep(1, ctx$m)) / ctx$m
  gp <- gd_partition(seq_len(ctx$N), ctx)
  expect_equal(hp[["shared"]], gp[["GD_T"]], tolerance = 1e-10)
  expect_equal(hp[["divergence"]], gp[["GD_BS"]], tolerance = 1e-10)
})

test_that("2 * GD_WI_hyb == GD_T + GD_BS over the full factorial", {
  # The identity the chapter turns on. Exact on the complete A x B set, where
  # the marginal line weights reproduce the actual pairing; on a selected
  # subset the gap is the pairing structure, and is small but not zero.
  gp <- gd_partition(seq_len(ctx$N), ctx)
  expect_equal(2 * gp[["GD_WI_hyb"]], gp[["GD_T"]] + gp[["GD_BS"]], tolerance = 1e-12)

  gs <- gd_partition(idx, ctx)
  expect_equal(2 * gs[["GD_WI_hyb"]], gs[["GD_T"]] + gs[["GD_BS"]], tolerance = 5e-3)
})

test_that("neutral divergence buys no heterosis: the two terms trade off exactly", {
  # pA and pB are independent Balding-Nichols draws around the same ancestral
  # p, so E[pA pB] = E[pA] E[pB] = p^2 and the expected F1 heterozygosity is
  # 2 p (1 - p) whatever fst is. The divergence term the pools gain is paid for,
  # one for one, out of the shared term. Drift apart buys nothing on average.
  het_at <- function(fst) {
    cf <- modifyList(cfg, list(fst = fst, m = 4000, seed = 5))
    Lf <- simulate_lines(cf)
    nA <- cf$n_pool_A
    pA <- colMeans(Lf[seq_len(nA), , drop = FALSE] / 2)
    pB <- colMeans(Lf[nA + seq_len(cf$n_pool_B), , drop = FALSE] / 2)
    heterosis_partition(pA, pB, rep(1, cf$m)) / cf$m
  }
  hp <- vapply(c(0.02, 0.10, 0.25, 0.45), het_at, numeric(3))

  # The divergence term moves a great deal ...
  expect_gt(diff(range(hp["divergence", ])), 0.05)
  # ... the shared term moves the other way by as much ...
  expect_lt(diff(hp["shared", c(1, 4)]), -0.05)
  # ... and the total does not move. p0 ~ U(0.05, 0.95) gives mean 2p(1-p) = 0.365.
  expect_lt(diff(range(hp["total", ])), 0.02)
  expect_equal(mean(hp["total", ]), 0.365, tolerance = 0.02)
})

test_that("GCA and SCA reconstruct heterosis exactly and are mean-zero", {
  nA <- cfg$n_pool_A
  U <- L_lines[seq_len(nA), , drop = FALSE] / 2
  V <- L_lines[nA + seq_len(cfg$n_pool_B), , drop = FALSE] / 2
  cs <- heterosis_gca_sca(U, V, d_eff)

  H  <- heterosis_value(ctx$X, d_eff)
  ia <- ctx$ped$a
  ib <- ctx$ped$b - nA
  expect_equal(H, cs$mu + cs$gca_A[ia] + cs$gca_B[ib] + cs$sca[cbind(ia, ib)],
               tolerance = 1e-10)
  expect_equal(cs$mu, mean(H), tolerance = 1e-10)
  expect_equal(mean(cs$gca_A), 0, tolerance = 1e-10)
  expect_equal(mean(cs$gca_B), 0, tolerance = 1e-10)
  expect_equal(mean(cs$sca), 0, tolerance = 1e-10)
})

test_that("SCA is the interaction residual of the two-way additive fit", {
  # An additive model of hybrid performance fits one effect per line. Whatever
  # it cannot express is SCA, by construction -- so the residual of that fit
  # must BE the sca matrix, not merely correlate with it.
  nA <- cfg$n_pool_A
  U <- L_lines[seq_len(nA), , drop = FALSE] / 2
  V <- L_lines[nA + seq_len(cfg$n_pool_B), , drop = FALSE] / 2
  cs <- heterosis_gca_sca(U, V, d_eff)

  H   <- heterosis_value(ctx$X, d_eff)
  ia  <- ctx$ped$a
  ib  <- ctx$ped$b - nA
  fit <- stats::lm(H ~ factor(ia) + factor(ib))
  expect_equal(as.numeric(stats::resid(fit)), cs$sca[cbind(ia, ib)],
               tolerance = 1e-8)
})

test_that("the closed-form variance components match", {
  # sigma2_GCA_A = sum d^2 (1 - 2 pB)^2 pA qA, sigma2_SCA = 4 sum d^2 pA qA pB qB.
  # These hold over lines drawn from the pool frequencies, so they are checked
  # at a line count large enough for the sampling error to be small: the
  # relative error of a variance estimate is sqrt(2 / n), about 5% here.
  set.seed(21)
  m  <- 1000
  n  <- 800
  pA <- stats::runif(m, 0.05, 0.95)
  pB <- stats::runif(m, 0.05, 0.95)
  dd <- stats::rgamma(m, 2, 4)
  U  <- matrix(stats::rbinom(n * m, 1, rep(pA, each = n)), n)
  V  <- matrix(stats::rbinom(n * m, 1, rep(pB, each = n)), n)
  cs <- heterosis_gca_sca(U, V, dd)

  expect_equal(stats::var(cs$gca_A), sum(dd^2 * (1 - 2 * pB)^2 * pA * (1 - pA)),
               tolerance = 0.1)
  expect_equal(stats::var(cs$gca_B), sum(dd^2 * (1 - 2 * pA)^2 * pB * (1 - pB)),
               tolerance = 0.1)
  expect_equal(stats::var(as.vector(cs$sca)),
               4 * sum(dd^2 * pA * (1 - pA) * pB * (1 - pB)), tolerance = 0.1)
})

test_that("uniform-d heterosis is the coancestry kernel, exactly", {
  # With d constant the count of heterozygous loci is m (1 - f_ab): the same
  # molecular coancestry the diversity side of the package runs on, and
  # m MRD^2. Genetic distance predicts heterosis exactly when d is flat.
  h1 <- heterosis_value(ctx$X, rep(1, ctx$m))
  fL <- molecular_coancestry(L_lines / 2)
  ab <- cbind(ctx$ped$a, ctx$ped$b)
  expect_equal(h1, ctx$m * (1 - fL[ab]), tolerance = 1e-10)
  expect_equal(h1, ctx$m * mrd_matrix(L_lines / 2)[ab]^2, tolerance = 1e-10)
})

test_that("GD_T + GD_BS is 1 - theta_AB", {
  gp <- gd_partition(seq_len(ctx$N), ctx)
  tp <- theta_pools(seq_len(ctx$N), ctx)
  expect_equal(gp[["GD_T"]] + gp[["GD_BS"]], 1 - tp[["theta_AB"]], tolerance = 1e-12)
})

test_that("what buys heterosis is divergence at the dominance loci, not F_ST", {
  # Same pools, same fst, same multiset of dominance deviations -- only their
  # placement across loci changes. F_ST is identical in all three cases.
  cf <- modifyList(cfg, list(fst = 0.25, m = 4000, seed = 3))
  Lf <- simulate_lines(cf)
  nA <- cf$n_pool_A
  pA <- colMeans(Lf[seq_len(nA), , drop = FALSE] / 2)
  pB <- colMeans(Lf[nA + seq_len(cf$n_pool_B), , drop = FALSE] / 2)
  y2 <- (pA - pB)^2

  set.seed(11)
  d <- rgamma(cf$m, 2, 4)
  aligned <- anti <- numeric(cf$m)
  aligned[order(y2)] <- sort(d)
  anti[order(y2)] <- sort(d, decreasing = TRUE)

  tot <- function(dv) heterosis_expected(pA, pB, dv) / cf$m
  expect_gt(tot(aligned), tot(d))
  expect_gt(tot(d), tot(anti))
  # The effect is large, not marginal.
  expect_gt(tot(aligned) / tot(anti), 1.5)

  # ... but that permutation moves BOTH terms, because y^2 is itself correlated
  # with the shared weight 2 pbar (1 - pbar). Permuting d only WITHIN groups of
  # loci that share a value of that weight isolates the divergence channel: the
  # shared term is then invariant by construction, exactly, and the divergence
  # term still moves several-fold.
  hz  <- 2 * ((pA + pB) / 2) * (1 - (pA + pB) / 2)
  grp <- split(seq_len(cf$m), round(hz, 9))
  strat <- function(dec) {
    v <- numeric(cf$m)
    for (i in grp) v[i[order(y2[i])]] <- sort(d[i], decreasing = dec)
    v
  }
  hi <- heterosis_partition(pA, pB, strat(FALSE))
  lo <- heterosis_partition(pA, pB, strat(TRUE))
  expect_equal(hi[["shared"]], lo[["shared"]], tolerance = 1e-9)
  expect_gt(hi[["divergence"]] / lo[["divergence"]], 2)
  expect_gt(hi[["total"]] / lo[["total"]], 1.05)
})
