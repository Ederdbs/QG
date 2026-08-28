# Caballero & Toro (2002), Conservation Genetics 3:289-299 -- the partition of
# genetic diversity in a subdivided population, and the optimal-contribution
# machinery that follows from it.
#
# These functions take a metapopulation view: individuals are grouped into
# subpopulations (accessions, landraces, heterotic pools), and every quantity is
# computed on the between-subpopulation coancestry matrix. This is the general
# form; gd_partition() in R/01_metrics.R is the specialisation to two heterotic
# pools weighted by the line usage a hybrid selection induces.

#' Partition genetic diversity in a subdivided population
#'
#' Implements the core of Caballero & Toro (2002): subpopulation coancestries,
#' Nei's minimum distance, the F-statistics, and the partition
#' `GD_T = GD_WI + GD_BI + GD_BS` (their Eq. 7), together with each
#' subpopulation's decomposed contribution to global coancestry.
#'
#' The partition is what changes the conservation strategy by species. When most
#' diversity is *between* subpopulations, the collection is the unit to protect;
#' when most is *within*, it is the population size.
#'
#' @param G `n_ind x n_loci` matrix of reference-allele dosage, coded 0/1/2.
#'   `NA` is allowed.
#' @param pop Vector of subpopulation labels, one per individual.
#' @param weights `"census"` to weight subpopulations by size, `"equal"` for
#'   equal weights.
#' @return A list with the subpopulation coancestry matrix `f`, Nei's minimum
#'   distance `D_nei`, the weights `w`, a per-subpopulation data frame
#'   `by_subpop`, a vector `global` of `f_til`, `F_til`, `s_til`, `D_bar`,
#'   `f_bar`, `F_IS`, `F_ST`, `F_IT`, and the diversity partition `diversity`.
#' @references Caballero A, Toro MA (2002). Analysis of genetic diversity for
#'   the management of conserved subdivided populations. *Conservation
#'   Genetics* 3:289-299.
#' @seealso [ct_loss_gain], [optimal_contributions], [gd_partition]
#' @export
ct_partition <- function(G, pop, weights = c("census", "equal")) {

  weights <- match.arg(weights)
  stopifnot(nrow(G) == length(pop))
  pop  <- as.factor(pop)
  pops <- levels(pop)
  n    <- length(pops)
  m    <- ncol(G)

  P <- G / 2                                   # reference-allele dosage per individual

  ## --- allele frequencies per subpopulation (Eq. 10) -------------------
  Pbar <- t(vapply(pops, function(k)
              colMeans(P[pop == k, , drop = FALSE], na.rm = TRUE),
              numeric(m)))
  rownames(Pbar) <- pops

  ## --- coancestry between subpopulations (Eq. 11) ----------------------
  ## biallelic: f_ij = mean_loci( p_i p_j + q_i q_j )
  Q <- 1 - Pbar
  f <- (tcrossprod(Pbar) + tcrossprod(Q)) / m
  dimnames(f) <- list(pops, pops)

  ## --- self-coancestry (Eq. 12) and molecular inbreeding ---------------
  s <- vapply(pops, function(k) {
         Pk <- P[pop == k, , drop = FALSE]
         mean(rowMeans(Pk^2 + (1 - Pk)^2, na.rm = TRUE))
       }, numeric(1))
  Fi <- 2 * s - 1

  ## --- Nei's minimum distance (Eq. 3) ----------------------------------
  fii <- diag(f)
  D   <- outer(fii, fii, "+") / 2 - f
  dimnames(D) <- list(pops, pops)

  ## --- weights ----------------------------------------------------------
  Ni <- as.numeric(table(pop)[pops])
  w  <- if (weights == "census") Ni / sum(Ni) else rep(1 / n, n)

  ## --- metapopulation means (Eq. 1, 4, 5) -------------------------------
  f_til <- sum(w * fii)                     # mean coancestry WITHIN
  s_til <- sum(w * s)
  F_til <- sum(w * Fi)
  f_bar <- as.numeric(t(w) %*% f %*% w)     # GLOBAL coancestry
  D_bar <- as.numeric(t(w) %*% D %*% w)

  ## --- HW deviation and the between-individual share (Eq. 2) -----------
  alpha <- (Fi - fii) / (1 - fii)
  Gi    <- (s  - fii) / (1 - fii)

  ## --- F statistics (Eq. 6) ---------------------------------------------
  F_IS <- (F_til - f_til) / (1 - f_til)
  F_ST <- D_bar / (1 - f_bar)
  F_IT <- (F_til - f_bar) / (1 - f_bar)

  ## --- the diversity partition (Eq. 7) ----------------------------------
  GD <- c(GD_T  = 1 - f_bar,
          GD_WI = 1 - s_til,
          GD_BI = s_til - f_til,
          GD_WS = 1 - f_til,
          GD_BS = f_til - f_bar)

  ## --- each subpopulation's contribution to f_bar (Eq. 5, decomposed) ---
  contrib <- data.frame(
    pop         = pops,
    N           = Ni,
    f_ii        = fii,
    He          = 1 - fii,
    s_i         = s,
    F_i         = Fi,
    alpha_i     = alpha,
    G_i         = Gi,
    term_coanc  = w * fii,
    term_dist   = w * as.numeric(D %*% w),
    row.names   = NULL
  )
  contrib$contrib_fbar <- contrib$term_coanc - contrib$term_dist

  list(f = f, D_nei = D, w = w,
       by_subpop = contrib,
       global = c(f_til = f_til, F_til = F_til, s_til = s_til,
                  D_bar = D_bar, f_bar = f_bar,
                  F_IS = F_IS, F_ST = F_ST, F_IT = F_IT),
       diversity = GD)
}

#' Loss or gain of diversity from removing each subpopulation
#'
#' The sign matters and is the point of the exercise: removing a subpopulation
#' can *raise* global gene diversity, when that subpopulation is redundant and
#' inflates mean coancestry more than it contributes distinct alleles.
#'
#' @param res Output of [ct_partition].
#' @param weights `"census"` or `"equal"`, as in [ct_partition].
#' @return A data frame with the diversity without each subpopulation and the
#'   percentage change.
#' @export
ct_loss_gain <- function(res, weights = c("census", "equal")) {
  weights <- match.arg(weights)
  f  <- res$f
  Ni <- res$by_subpop$N
  n  <- nrow(f)
  wf <- function(idx) {
    w <- if (weights == "census") Ni[idx] / sum(Ni[idx]) else rep(1 / length(idx), length(idx))
    as.numeric(t(w) %*% f[idx, idx, drop = FALSE] %*% w)
  }
  GD_full <- 1 - wf(seq_len(n))
  out <- vapply(seq_len(n), function(k) {
    idx <- setdiff(seq_len(n), k)
    GD_k <- 1 - wf(idx)
    c(GD_without = GD_k, delta_pct = 100 * (GD_k - GD_full) / GD_full)
  }, numeric(2))
  pops <- rownames(f)
  if (is.null(pops)) pops <- as.character(seq_len(n))
  data.frame(pop = pops, t(out), row.names = NULL)
}

#' Optimal contributions that maximise pool diversity
#'
#' Solves the quadratic programme `min c' f c` subject to `sum(c) = 1` and
#' `lower <= c <= upper` (Caballero & Toro 2002, Eq. 9). This is how a synthetic
#' or a core collection is composed: the `upper` bound is the operational cap on
#' any single accession.
#'
#' Minimising group coancestry is the same thing as maximising effective size,
#' since `Ns = 1 / (2 theta)`.
#'
#' @param f Coancestry matrix.
#' @param lower,upper Bounds on each contribution.
#' @param ridge Small ridge added to the diagonal to guarantee positive
#'   definiteness.
#' @return A list with `c_i` (the contributions) and `GD_max`.
#' @seealso [ocs_quadprog] to trade diversity against merit, and
#'   [ocs_relaxation] for the projected-gradient route used inside the pipeline.
#' @export
optimal_contributions <- function(f, lower = 0, upper = 1, ridge = 1e-8) {
  if (!requireNamespace("quadprog", quietly = TRUE))
    stop("Package 'quadprog' is required for optimal_contributions().")
  n    <- nrow(f)
  Dmat <- 2 * (f + diag(ridge, n))            # the ridge keeps Dmat definite
  dvec <- rep(0, n)
  Amat <- cbind(rep(1, n), diag(n), -diag(n)) # equality plus bounds
  bvec <- c(1, rep(lower, n), rep(-upper, n))
  sol  <- quadprog::solve.QP(Dmat, dvec, Amat, bvec, meq = 1)
  ci   <- pmax(sol$solution, 0); ci <- ci / sum(ci)
  list(c_i = setNames(round(ci, 6), rownames(f)),
       GD_max = as.numeric(1 - t(ci) %*% f %*% ci))
}

#' Optimal contribution selection by quadratic programming
#'
#' Maximises `c' g - lambda c' f c`: genetic merit against group coancestry.
#' Sweeping `lambda` traces the merit-versus-diversity frontier.
#'
#' @param f Coancestry matrix.
#' @param gebv Vector of genetic merit.
#' @param lambda Weight on the coancestry penalty.
#' @param lower,upper Bounds on each contribution.
#' @return A list with `c_i`, `merit` and `coancestry`.
#' @seealso [optimal_contributions], [ocs_relaxation]
#' @export
ocs_quadprog <- function(f, gebv, lambda = 1, lower = 0, upper = 1) {
  if (!requireNamespace("quadprog", quietly = TRUE))
    stop("Package 'quadprog' is required for ocs_quadprog().")
  n    <- nrow(f)
  Dmat <- 2 * lambda * (f + diag(1e-8, n))
  dvec <- as.numeric(gebv)
  Amat <- cbind(rep(1, n), diag(n), -diag(n))
  bvec <- c(1, rep(lower, n), rep(-upper, n))
  sol  <- quadprog::solve.QP(Dmat, dvec, Amat, bvec, meq = 1)
  ci   <- pmax(sol$solution, 0); ci <- ci / sum(ci)
  list(c_i       = setNames(round(ci, 6), rownames(f)),
       merit     = as.numeric(crossprod(ci, gebv)),
       coancestry = as.numeric(t(ci) %*% f %*% ci))
}
