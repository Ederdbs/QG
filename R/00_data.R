# Data: line simulation -> hybrids -> G (prediction) + f (diversity).
#
# load_data() is the ONLY point to swap once real data arrives.
# The rest of the code only ever sees the `ctx` object.

#' Simulation configuration
#'
#' Controls the scale of the simulated dataset. The shipped default is a small
#' development configuration; the production scale is `n_pool_A = n_pool_B = 71`
#' and `m = 25000`.
#'
#' @format A list with components `n_pool_A`, `n_pool_B` (lines per heterotic
#'   group), `m` (markers), `n_traits`, `fst` (divergence between pools) and
#'   `seed`.
#' @export
sim_config <- list(
  n_pool_A = 50,     # lines in heterotic group A
  n_pool_B = 50,     # lines in heterotic group B
  m        = 5000,   # markers (real dataset: 25000)
  n_traits = 3,
  fst      = 0.15,   # divergence between pools
  seed     = 1
)

#' Simulate inbred line genotypes in two divergent heterotic pools
#'
#' Draws ancestral allele frequencies, splits them into two pool-specific
#' frequency vectors with a Balding-Nichols model at divergence `fst`, then
#' samples fully homozygous (inbred) line genotypes.
#'
#' @param cfg A configuration list, see [sim_config].
#' @return A numeric matrix of `n_pool_A + n_pool_B` rows by `cfg$m` columns,
#'   coded 0/2 (lines are homozygous), pool A stacked above pool B.
#' @export
#' @examples
#' L <- simulate_lines(modifyList(sim_config, list(n_pool_A = 5, n_pool_B = 5, m = 20)))
#' dim(L)
simulate_lines <- function(cfg) {
  set.seed(cfg$seed)
  p_anc <- stats::runif(cfg$m, 0.05, 0.95)
  bn <- function(p, fst) {
    stats::rbeta(length(p), p * (1 - fst) / fst, (1 - p) * (1 - fst) / fst)
  }
  pA <- bn(p_anc, cfg$fst)
  pB <- bn(p_anc, cfg$fst)

  draw <- function(n, p) {
    matrix(2L * stats::rbinom(n * length(p), 1, rep(p, each = n)), nrow = n)
  }
  L <- rbind(draw(cfg$n_pool_A, pA), draw(cfg$n_pool_B, pB))
  storage.mode(L) <- "double"
  L
}

#' Molecular coancestry matrix
#'
#' Caballero & Toro (2002) molecular coancestry: `f_ij` is the probability that
#' an allele drawn at random from individual `i` is identical in state to one
#' drawn from `j`. Computed with a single `tcrossprod` from the identity
#' `sum_k [x_i x_j + (1 - x_i)(1 - x_j)] = 2 sum_k x_i x_j - sum x_i - sum x_j + m`.
#'
#' The matrix is never centered: `f` must stay in `[0, 1]`. This is the matrix
#' every diversity metric in this package operates on. For trait prediction use
#' [vanraden_G] instead.
#'
#' @param X Marker matrix, individuals in rows, values in 0/0.5/1 giving
#'   the frequency of the reference allele *within* the individual.
#' @return A symmetric numeric matrix with entries in `[0, 1]`.
#' @seealso [vanraden_G] for the prediction counterpart.
#' @export
#' @examples
#' X <- matrix(c(0, 0.5, 1, 1, 0.5, 0), nrow = 2)
#' molecular_coancestry(X)
molecular_coancestry <- function(X) {
  m <- ncol(X)
  s <- rowSums(X)
  f <- (2 * tcrossprod(X) - outer(s, rep(1, nrow(X))) -
          outer(rep(1, nrow(X)), s) + m) / m
  dimnames(f) <- NULL
  f
}

#' VanRaden genomic relationship matrix
#'
#' `G = ZZ' / (2 sum p(1 - p))` with `Z` centered on the population's own allele
#' frequencies.
#'
#' Use this for trait prediction only. It cannot measure diversity: because `Z`
#' is centered on its own population, `sum(G) == 0` exactly, so group coancestry
#' and any status number derived from it are meaningless.
#'
#' @param M Marker matrix, individuals in rows, dosage coded 0/1/2.
#' @return A list with `G` (the relationship matrix), `Z` (the centered marker
#'   matrix) and `p` (the allele frequencies used for centering).
#' @seealso [molecular_coancestry] for the diversity counterpart.
#' @export
vanraden_G <- function(M) {
  p <- colMeans(M) / 2
  Z <- sweep(M, 2, 2 * p, "-")
  list(G = tcrossprod(Z) / (2 * sum(p * (1 - p))), Z = Z, p = p)
}

#' Simulate a full hybrid dataset
#'
#' Simulates lines in two heterotic pools, forms every A x B cross, computes the
#' VanRaden matrix for prediction and the molecular coancestry matrix for
#' diversity, and draws correlated marker effects to produce predicted
#' multi-trait values.
#'
#' @param cfg A configuration list, see [sim_config].
#' @return A `ctx` list, see [build_ctx].
#' @export
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
  R <- matrix(c(1, 0.3, -0.3, 0.3, 1, 0.1, -0.3, 0.1, 1), 3, 3)[
    seq_len(cfg$n_traits), seq_len(cfg$n_traits), drop = FALSE]
  B <- matrix(stats::rnorm(cfg$m * cfg$n_traits), cfg$m) %*% chol(R)
  traits <- scale(vr$Z %*% B)
  colnames(traits) <- paste0("trait", seq_len(cfg$n_traits))

  X <- M / 2
  build_ctx(X = X, f = molecular_coancestry(X), G = vr$G, traits = traits,
            ped = ped, n_lines = n_lines,
            pool = rep(c("A", "B"), c(cfg$n_pool_A, cfg$n_pool_B)),
            fL = molecular_coancestry(L / 2), cfg = cfg)
}

#' Build the evaluation context
#'
#' Assembles the `ctx` object that every metric and selection function takes as
#' its second argument, and precomputes what stays constant across evaluations:
#' the multi-trait index, the frozen candidate-pool allele frequencies `p0` that
#' anchor `F_hom` and `F_drift`, and the population minor allele frequencies.
#'
#' @param X Hybrid marker matrix, values in 0/0.5/1.
#' @param f Molecular coancestry matrix of the hybrids.
#' @param G VanRaden matrix, or `NULL`. Used for prediction only.
#' @param traits Numeric matrix of predicted trait values, one column per trait.
#' @param ped Data frame with columns `a` and `b`, the parent line ids.
#' @param n_lines Total number of parent lines.
#' @param pool Character vector of pool labels per line, or `NULL`.
#' @param fL Coancestry matrix *between lines*, or `NULL`. Only needed for the
#'   heterotic-group decomposition.
#' @param cfg The configuration list used, or `NULL`.
#' @param weights Trait weights for the index. Defaults to equal weights.
#' @return A list with the arguments above plus `N`, `m`, `index`, `p0` and
#'   `maf_pop`.
#' @export
build_ctx <- function(X, f, G, traits, ped, n_lines, pool, fL, cfg,
                      weights = rep(1, ncol(traits))) {
  p_pop <- colMeans(X)
  list(
    X = X, f = f, G = G, traits = traits, ped = ped,
    n_lines = n_lines, pool = pool, fL = fL, cfg = cfg,
    N = nrow(X), m = ncol(X),
    # Multi-trait index, in deviations. Traits are standardised before
    # weighting so that `weights` means the same thing whatever scale the
    # traits arrive on. Idempotent when they are already standardised.
    index = as.numeric(scale(scale(traits) %*% weights)),
    p0 = p_pop,                                      # frozen base for F_hom/F_drift
    maf_pop = pmin(p_pop, 1 - p_pop)
  )
}

#' Load the dataset
#'
#' Reads `ctx.rds` from `path` if it exists, otherwise simulates. This is the
#' single swap point for real data: replace the body to read your own files and
#' hand the result to [build_ctx].
#'
#' @param path Directory to look in.
#' @return A `ctx` list.
#' @export
load_data <- function(path = "data") {
  fx <- file.path(path, "ctx.rds")
  if (file.exists(fx)) return(readRDS(fx))
  simulate_data()
}
