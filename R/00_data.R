# Data: line simulation -> hybrids -> G (prediction) + f (diversity).
#
# load_data() is the ONLY point to swap once real data arrives.
# The rest of the code only ever sees the `ctx` object.

sim_config <- list(
  n_pool_A = 50,     # lines in heterotic group A
  n_pool_B = 50,     # lines in heterotic group B
  m        = 5000,   # markers (real dataset: 25000)
  n_traits = 3,
  fst      = 0.15,   # divergence between pools
  seed     = 1
)

# Line genotypes, 0/2 (inbred = homozygous), with two divergent pools via a
# Balding-Nichols model.
simulate_lines <- function(cfg) {
  set.seed(cfg$seed)
  p_anc <- runif(cfg$m, 0.05, 0.95)
  bn <- function(p, fst) rbeta(length(p), p * (1 - fst) / fst, (1 - p) * (1 - fst) / fst)
  pA <- bn(p_anc, cfg$fst)
  pB <- bn(p_anc, cfg$fst)

  draw <- function(n, p) matrix(2L * rbinom(n * length(p), 1, rep(p, each = n)), nrow = n)
  L <- rbind(draw(cfg$n_pool_A, pA), draw(cfg$n_pool_B, pB))
  storage.mode(L) <- "double"
  L
}

# Molecular coancestry (Caballero & Toro): f_ij = P(two alleles identical by state).
# x = frequency of the reference allele WITHIN the individual (0, 0.5, 1).
#   Sum_k [x_i x_j + (1-x_i)(1-x_j)] = 2 Sum_k x_i x_j - Sum x_i - Sum x_j + m
# A single tcrossprod. Never center: f must stay in [0,1].
molecular_coancestry <- function(X) {
  m <- ncol(X)
  s <- rowSums(X)
  f <- (2 * tcrossprod(X) - outer(s, rep(1, nrow(X))) - outer(rep(1, nrow(X)), s) + m) / m
  dimnames(f) <- NULL
  f
}

# VanRaden. Only for trait prediction — do NOT use for diversity:
# with Z centered on its own population, sum(G) == 0 by construction.
vanraden_G <- function(M) {
  p <- colMeans(M) / 2
  Z <- sweep(M, 2, 2 * p, "-")
  list(G = tcrossprod(Z) / (2 * sum(p * (1 - p))), Z = Z, p = p)
}

simulate_data <- function(cfg = sim_config) {
  L <- simulate_lines(cfg)
  n_lines <- nrow(L)
  a_ids <- seq_len(cfg$n_pool_A)
  b_ids <- cfg$n_pool_A + seq_len(cfg$n_pool_B)

  # All A x B combinations.
  ped <- expand.grid(a = a_ids, b = b_ids)
  M <- (L[ped$a, , drop = FALSE] + L[ped$b, , drop = FALSE]) / 2  # 0/1/2

  vr <- vanraden_G(M)

  # Marker effects correlated across traits -> predicted GEBVs.
  set.seed(cfg$seed + 99)
  R <- matrix(c(1, 0.3, -0.3, 0.3, 1, 0.1, -0.3, 0.1, 1), 3, 3)[seq_len(cfg$n_traits),
                                                                seq_len(cfg$n_traits), drop = FALSE]
  B <- matrix(rnorm(cfg$m * cfg$n_traits), cfg$m) %*% chol(R)
  traits <- scale(vr$Z %*% B)
  colnames(traits) <- paste0("trait", seq_len(cfg$n_traits))

  X <- M / 2
  build_ctx(X = X, f = molecular_coancestry(X), G = vr$G, traits = traits,
            ped = ped, n_lines = n_lines, pool = rep(c("A", "B"), c(cfg$n_pool_A, cfg$n_pool_B)),
            fL = molecular_coancestry(L / 2), cfg = cfg)
}

# Builds the context and precomputes what stays constant across evaluations.
build_ctx <- function(X, f, G, traits, ped, n_lines, pool, fL, cfg,
                      weights = rep(1, ncol(traits))) {
  p_pop <- colMeans(X)
  list(
    X = X, f = f, G = G, traits = traits, ped = ped,
    n_lines = n_lines, pool = pool, fL = fL, cfg = cfg,
    N = nrow(X), m = ncol(X),
    index = as.numeric(scale(traits %*% weights)),   # multi-trait index, in deviations
    maf_pop = pmin(p_pop, 1 - p_pop)
  )
}

# Swap the body of this function for your real data files.
load_data <- function(path = "data") {
  fx <- file.path(path, "ctx.rds")
  if (file.exists(fx)) return(readRDS(fx))
  simulate_data()
}
