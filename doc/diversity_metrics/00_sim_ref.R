## R/00_sim_ref.R -----------------------------------------------------------
## Simulation of a two-pool maize hybrid population + REFERENCE (slow, literal)
## implementations of every diversity metric, transcribed from diversity_metrics.Rmd.
## These are the correctness oracles: fast routes in R/fast_metrics.R must match
## them to machine precision.

## ---- molecular coancestry (Caballero & Toro 2002; Nejati-Javaremi 1997) -----
## X: n x m matrix of within-individual reference-allele frequency, in {0,0.5,1}
molecular_coancestry <- function(X) {
  m <- ncol(X); n <- nrow(X); s <- rowSums(X)
  (2 * tcrossprod(X) - outer(s, rep(1, n)) - outer(rep(1, n), s) + m) / m
}

## ---- simulate two divergent heterotic pools --------------------------------
simulate_pools <- function(n_A = 25, n_B = 25, m = 1500, fst = 0.15,
                           n_qtl = 300, h2 = 0.5, seed = 1) {
  set.seed(seed)
  pa <- runif(m, 0.05, 0.95)                       # ancestral allele frequency
  aa <- pa * (1 - fst) / fst; bb <- (1 - pa) * (1 - fst) / fst
  pA <- pmin(pmax(rbeta(m, aa, bb), 1e-6), 1 - 1e-6)   # Balding-Nichols
  pB <- pmin(pmax(rbeta(m, aa, bb), 1e-6), 1 - 1e-6)
  gA <- matrix(rbinom(n_A * m, 1, rep(pA, each = n_A)), n_A, m)
  gB <- matrix(rbinom(n_B * m, 1, rep(pB, each = n_B)), n_B, m)
  GL <- rbind(gA, gB)                              # L x m, homozygous lines, {0,1}
  L  <- n_A + n_B
  pool <- c(rep("A", n_A), rep("B", n_B))

  ped <- expand.grid(a = seq_len(n_A), b = n_A + seq_len(n_B))
  X   <- (GL[ped$a, , drop = FALSE] + GL[ped$b, , drop = FALSE]) / 2   # N x m

  qtl  <- sample.int(m, n_qtl)
  beta <- rep(0, m); beta[qtl] <- rnorm(n_qtl)
  gv   <- as.vector(X %*% beta)
  gv   <- (gv - mean(gv)) / sd(gv)
  idxv <- gv + rnorm(length(gv), 0, sqrt(1 / h2 - 1))   # noisy selection index

  list(GL = GL, X = X, ped = ped, pool = pool, L = L, m = m,
       N = nrow(X), n_A = n_A, n_B = n_B, index = as.vector(scale(idxv)),
       fL = molecular_coancestry(GL))
}

## Build the pipeline context (mirrors build_ctx_from_stage1 in the Rmd)
build_ctx <- function(sim, with_f = TRUE) {
  ctx <- list(X = sim$X, GL = sim$GL, fL = sim$fL, ped = sim$ped, pool = sim$pool,
              N = sim$N, m = sim$m, n_lines = sim$L, index = sim$index,
              parents = cbind(sim$ped$a, sim$ped$b))
  if (with_f) ctx$f <- molecular_coancestry(sim$X)
  ctx$maf_pop <- { p <- colMeans(sim$X); pmin(p, 1 - p) }
  ctx
}

## ---- REFERENCE metrics (slow, literal) -------------------------------------
ref_theta        <- function(idx, ctx) mean(ctx[["f"]][idx, idx])
ref_gene_div     <- function(idx, ctx) 1 - ref_theta(idx, ctx)
ref_theta_freq   <- function(idx, ctx) { p <- colMeans(ctx$X[idx, , drop = FALSE]); mean(p^2 + (1 - p)^2) }
ref_he_nei       <- function(idx, ctx) { p <- colMeans(ctx$X[idx, , drop = FALSE]); mean(2 * p * (1 - p)) }
ref_status_num   <- function(idx, ctx) 1 / (2 * ref_theta(idx, ctx))

ref_ne_parents <- function(idx, ctx) {
  cnt <- tabulate(as.vector(ctx$parents[idx, ]), nbins = ctx$n_lines)
  p <- cnt / sum(cnt)
  1 / sum(p^2)
}

ref_alleles_lost <- function(idx, ctx, thr = 0.05) {
  p <- colMeans(ctx$X[idx, , drop = FALSE]); maf <- pmin(p, 1 - p)
  sum(maf < thr & ctx$maf_pop >= thr)
}

ref_alleles_fixed <- function(idx, ctx) {         # strict loss: allele absent
  p <- colMeans(ctx$X[idx, , drop = FALSE])
  sum((p == 0 | p == 1) & ctx$maf_pop > 0)
}

ref_ene <- function(idx, ctx) {
  d <- 1 - ctx[["f"]][idx, idx]; diag(d) <- Inf
  mean(apply(d, 1, min))
}

ref_ane <- function(idx, ctx) {
  d <- 1 - ctx[["f"]][, idx, drop = FALSE]
  mean(apply(d, 1, min))
}

ref_eff_dim <- function(idx, ctx) {               # participation ratio via eigen
  lam <- eigen(ctx[["f"]][idx, idx], symmetric = TRUE, only.values = TRUE)$values
  sum(lam)^2 / sum(lam^2)
}

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
