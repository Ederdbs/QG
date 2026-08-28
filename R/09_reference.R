# Reference ("oracle") implementations.
#
# These are deliberately slow and literal: each transcribes a definition
# directly, with no algebraic shortcut. Every fast route in the package must
# match them to machine precision, and the test suite asserts exactly that.
#
# Keeping the oracle in the package rather than in the tests is deliberate -- a
# derivation the reader cannot re-run against a naive implementation is a claim,
# not a verification.

#' Simulate two divergent heterotic pools, with lines and all crosses
#'
#' A lighter-weight simulator than [simulate_data], returning the raw pieces
#' rather than a context: the line genotype matrix, the hybrid marker matrix,
#' the pedigree, and a noisy selection index. Used by the verification chapter
#' and by the S1-S4 pipeline examples, which need `GL` in 0/1 line coding.
#'
#' @param n_A,n_B Lines per pool.
#' @param m Markers.
#' @param fst Divergence between pools.
#' @param n_qtl Markers with a non-zero effect.
#' @param h2 Heritability used to add noise to the selection index.
#' @param seed Random seed.
#' @return A list with `GL`, `X`, `ped`, `pool`, `L`, `m`, `N`, `n_A`, `n_B`,
#'   `index` and `fL`.
#' @export
simulate_pools <- function(n_A = 25, n_B = 25, m = 1500, fst = 0.15,
                           n_qtl = 300, h2 = 0.5, seed = 1) {
  set.seed(seed)
  pa <- stats::runif(m, 0.05, 0.95)                # ancestral allele frequency
  aa <- pa * (1 - fst) / fst; bb <- (1 - pa) * (1 - fst) / fst
  pA <- pmin(pmax(stats::rbeta(m, aa, bb), 1e-6), 1 - 1e-6)   # Balding-Nichols
  pB <- pmin(pmax(stats::rbeta(m, aa, bb), 1e-6), 1 - 1e-6)
  gA <- matrix(stats::rbinom(n_A * m, 1, rep(pA, each = n_A)), n_A, m)
  gB <- matrix(stats::rbinom(n_B * m, 1, rep(pB, each = n_B)), n_B, m)
  GL <- rbind(gA, gB)                              # L x m, homozygous lines, {0,1}
  L  <- n_A + n_B
  pool <- c(rep("A", n_A), rep("B", n_B))

  ped <- expand.grid(a = seq_len(n_A), b = n_A + seq_len(n_B))
  X   <- (GL[ped$a, , drop = FALSE] + GL[ped$b, , drop = FALSE]) / 2   # N x m

  qtl  <- sample.int(m, n_qtl)
  beta <- rep(0, m); beta[qtl] <- stats::rnorm(n_qtl)
  gv   <- as.vector(X %*% beta)
  gv   <- (gv - mean(gv)) / stats::sd(gv)
  idxv <- gv + stats::rnorm(length(gv), 0, sqrt(1 / h2 - 1))   # noisy index

  list(GL = GL, X = X, ped = ped, pool = pool, L = L, m = m,
       N = nrow(X), n_A = n_A, n_B = n_B, beta = beta,
       index = as.vector(scale(idxv)),
       fL = molecular_coancestry(GL))
}

#' Build a context from a [simulate_pools] result
#'
#' @param sim Output of [simulate_pools].
#' @param with_f Also form the `N x N` hybrid coancestry matrix. Set `FALSE` at
#'   scales where that matrix does not fit in memory -- the fast routes in
#'   `R/04_fast_metrics.R` never need it.
#' @return A `ctx` list carrying `parents` and `GL`, ready for both the standard
#'   and the fast metrics.
#' @export
ctx_from_pools <- function(sim, with_f = TRUE) {
  ctx <- list(X = sim$X, GL = sim$GL, fL = sim$fL, ped = sim$ped, pool = sim$pool,
              N = sim$N, m = sim$m, n_lines = sim$L, index = sim$index,
              parents = cbind(sim$ped$a, sim$ped$b))
  if (with_f) ctx$f <- molecular_coancestry(sim$X)
  p <- colMeans(sim$X)
  ctx$p0 <- p
  ctx$maf_pop <- pmin(p, 1 - p)
  ctx
}

# --- Reference metrics: slow, literal ------------------------------------------

#' Reference implementations of the diversity metrics
#'
#' Literal transcriptions of the definitions, used as correctness oracles. Each
#' has a fast counterpart that must match it to machine precision:
#' `ref_theta` against [theta_group] and [fast_theta], `ref_he_nei` against
#' [he_nei], `ref_ne_parents` against [ne_parents], and so on.
#'
#' @param idx Integer vector of selected row indices.
#' @param ctx Context from [ctx_from_pools].
#' @param thr Minor allele frequency threshold, `ref_alleles_lost` only.
#' @return A scalar, or a named vector for `ref_theta_pools`.
#' @name reference-metrics
NULL

#' @rdname reference-metrics
#' @export
ref_theta <- function(idx, ctx) mean(ctx[["f"]][idx, idx])

#' @rdname reference-metrics
#' @export
ref_gene_div <- function(idx, ctx) 1 - ref_theta(idx, ctx)

#' @rdname reference-metrics
#' @export
ref_theta_freq <- function(idx, ctx) {
  p <- colMeans(ctx$X[idx, , drop = FALSE]); mean(p^2 + (1 - p)^2)
}

#' @rdname reference-metrics
#' @export
ref_he_nei <- function(idx, ctx) {
  p <- colMeans(ctx$X[idx, , drop = FALSE]); mean(2 * p * (1 - p))
}

#' @rdname reference-metrics
#' @export
ref_status_num <- function(idx, ctx) 1 / (2 * ref_theta(idx, ctx))

#' @rdname reference-metrics
#' @export
ref_ne_parents <- function(idx, ctx) {
  cnt <- tabulate(as.vector(ctx$parents[idx, ]), nbins = ctx$n_lines)
  p <- cnt / sum(cnt)
  1 / sum(p^2)
}

#' @rdname reference-metrics
#' @export
ref_alleles_lost <- function(idx, ctx, thr = 0.05) {
  p <- colMeans(ctx$X[idx, , drop = FALSE]); maf <- pmin(p, 1 - p)
  sum(maf < thr & ctx$maf_pop >= thr)
}

#' @rdname reference-metrics
#' @export
ref_alleles_fixed <- function(idx, ctx) {         # strict loss: allele absent
  p <- colMeans(ctx$X[idx, , drop = FALSE])
  sum((p == 0 | p == 1) & ctx$maf_pop > 0)
}

#' @rdname reference-metrics
#' @export
ref_ene <- function(idx, ctx) {
  d <- 1 - ctx[["f"]][idx, idx]; diag(d) <- Inf
  mean(apply(d, 1, min))
}

#' @rdname reference-metrics
#' @export
ref_ane <- function(idx, ctx) {
  d <- 1 - ctx[["f"]][, idx, drop = FALSE]
  mean(apply(d, 1, min))
}

#' @rdname reference-metrics
#' @export
ref_eff_dim <- function(idx, ctx) {               # participation ratio via eigen
  lam <- eigen(ctx[["f"]][idx, idx], symmetric = TRUE, only.values = TRUE)$values
  sum(lam)^2 / sum(lam^2)
}

#' @rdname reference-metrics
#' @export
ref_theta_pools <- function(idx, ctx) {
  cnt <- tabulate(as.vector(ctx$parents[idx, ]), nbins = ctx$n_lines)
  w <- cnt / sum(cnt)
  A <- ctx$pool == "A"; B <- !A
  wA <- w; wA[B] <- 0; wB <- w; wB[A] <- 0
  sA <- sum(wA); sB <- sum(wB)
  c(theta_A  = if (sA > 0) as.numeric(t(wA / sA) %*% ctx$fL %*% (wA / sA)) else NA,
    theta_B  = if (sB > 0) as.numeric(t(wB / sB) %*% ctx$fL %*% (wB / sB)) else NA,
    theta_AB = if (sA > 0 && sB > 0) as.numeric(t(wA / sA) %*% ctx$fL %*% (wB / sB)) else NA)
}
