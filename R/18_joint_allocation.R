# Joint allocation: which crosses, at which locations.
#
# R/16 decides which cells of the female x male factorial are made; R/17
# decides which hybrid goes to which location, taking the whole factorial as
# given. Here the two are one object. A crossing plan (a data.frame of
# `parent1`, `parent2` from the design_* generators, parent1 = female) times a
# location allocation is just the `nF*nM x nLoc` 0/1 matrix of R/17 with ZERO
# rows for the crosses not made, so sparse_simulate(), sparse_blup() and
# sparse_connectivity() take it unchanged. Nothing in this file simulates or
# fits; it builds M and scores it before planting.

#' Allocate the crosses of a crossing plan to locations
#'
#' Every cross of `plan` goes to exactly `k` locations; crosses not in `plan`
#' get no plot. The result is the allocation matrix of [sparse_alloc], with
#' zero rows where no seed exists.
#'
#' * `"random"` -- each cross in `k` locations drawn independently.
#' * `"coverage"` -- crosses are placed one at a time, in random order, in the
#'   `k` locations where their female and male are still absent, ties broken by
#'   the lightest load; no location may exceed `ceiling(n * k / nLoc)` plots.
#'   It puts as much of both pools as possible in every location, which is what
#'   carries connectivity once a relationship matrix is in the model (Chapter
#'   4f, finding 4).
#' * `"optimised"` -- an exchange search from `start` (default: a fresh
#'   `"coverage"` allocation) that
#'   accepts a move of one cross from one location to another (paired with a
#'   reverse move when loads would drift) only if it lowers [joint_pev]. The
#'   A-optimality criterion of model-based design (Butler, Smith and Cullis
#'   2014), with the variance components known. First-improvement acceptance,
#'   `n_iter` proposals, no convergence test.
#'
#' @param plan Crossing plan: integer columns `parent1` (female, `1..nF`) and
#'   `parent2` (male, `1..nM`).
#' @param nF,nM Females and males.
#' @param nLoc Number of locations.
#' @param k Locations per cross, `1 <= k <= nLoc`.
#' @param strategy One of `"random"`, `"coverage"`, `"optimised"`.
#' @param vc,Af,Am Model for `"optimised"`: components from [sparse_vc] and the
#'   relationship matrices of the two pools.
#' @param n_iter Exchange proposals for `"optimised"`.
#' @param start Optional starting allocation for `"optimised"`, e.g. a
#'   `"coverage"` result, so the search can be compared with its own start.
#' @return An integer `nF*nM x nLoc` 0/1 matrix, male fastest.
#' @seealso [joint_pev], [joint_connectivity].
#' @export
#' @examples
#' p <- design_circulant(6, 6, c = 2)
#' M <- joint_alloc(p, 6, 6, nLoc = 3, k = 1, strategy = "coverage")
#' colSums(M)
joint_alloc <- function(plan, nF, nM, nLoc, k = 1L,
                        strategy = c("random", "coverage", "optimised"),
                        vc = sparse_vc(0.3), Af = diag(nF), Am = diag(nM),
                        n_iter = 200L, start = NULL) {
  strategy <- match.arg(strategy)
  stopifnot(k >= 1, k <= nLoc)
  h <- (plan$parent1 - 1L) * nM + plan$parent2
  n <- length(h)
  M <- matrix(0L, nF * nM, nLoc)
  if (strategy == "random") {
    for (x in h) M[x, sample.int(nLoc, k)] <- 1L
    return(M)
  }
  cap <- ceiling(n * k / nLoc)
  hasF <- matrix(FALSE, nF, nLoc); hasM <- matrix(FALSE, nM, nLoc)
  load <- numeric(nLoc)
  for (r in sample.int(n)) {
    f <- plan$parent1[r]; m <- plan$parent2[r]
    gain <- (!hasF[f, ]) + (!hasM[m, ])
    gain[load >= cap] <- -Inf
    pick <- order(-gain, load, stats::runif(nLoc))[seq_len(k)]
    M[h[r], pick] <- 1L
    hasF[f, pick] <- TRUE; hasM[m, pick] <- TRUE
    load[pick] <- load[pick] + 1
  }
  if (strategy == "coverage" || k == nLoc) return(M)
  if (!is.null(start)) M <- start
  best <- joint_pev(M, nF, nM, vc, Af, Am)
  for (it in seq_len(n_iter)) {
    x <- h[sample.int(n, 1L)]
    a <- which(M[x, ] == 1L); b <- which(M[x, ] == 0L)
    a <- a[sample.int(length(a), 1L)]; b <- b[sample.int(length(b), 1L)]
    M2 <- M; M2[x, a] <- 0L; M2[x, b] <- 1L
    if (max(colSums(M2)) > cap) {
      y <- h[M2[h, b] == 1L & M2[h, a] == 0L]
      if (!length(y)) next
      y <- y[sample.int(length(y), 1L)]
      M2[y, b] <- 0L; M2[y, a] <- 1L
    }
    v <- joint_pev(M2, nF, nM, vc, Af, Am)
    if (v < best) { M <- M2; best <- v }
  }
  M
}

#' Mean prediction error variance of GCA, before planting
#'
#' Builds the mixed-model coefficient matrix of [sparse_blup] for the cells of
#' `M` (no phenotype is needed: the equations' left-hand side depends on the
#' design alone) and returns the mean PEV of the `nF + nM` GCA effects. Lower is
#' better; it is the A-optimality criterion restricted to the effects a
#' programme selects parents on.
#'
#' @param M Allocation matrix (`nF*nM x nLoc`), zero rows allowed.
#' @inheritParams joint_alloc
#' @return A scalar.
#' @export
#' @examples
#' M <- joint_alloc(design_circulant(6, 6, 2), 6, 6, 3, 1, "coverage")
#' joint_pev(M, 6, 6, sparse_vc(0.3))
joint_pev <- function(M, nF, nM, vc, Af = diag(nF), Am = diag(nM)) {
  cells <- which(M == 1L, arr.ind = TRUE)
  d <- sparse_terms(data.frame(hyb = cells[, 1], loc = cells[, 2]),
                    nF, nM, ncol(M), vc, Af, Am)
  W <- cbind(d$X, do.call(cbind, lapply(d$terms, `[[`, "Z")))
  R <- chol(sparse_coef(W, d, vc))
  # diag of C^-1 on the GCA rows: e_i' (R'R)^-1 e_i = ||R^-T e_i||^2.
  ix <- ncol(d$X) + seq_len(nF + nM)
  E <- matrix(0, ncol(W), length(ix)); E[cbind(ix, seq_along(ix))] <- 1
  mean(colSums(backsolve(R, E, transpose = TRUE)^2)) * vc$s2res
}

#' Connectivity of a joint allocation, female x male x location
#'
#' [sparse_connectivity] plus two component counts, both computable before
#' planting.
#'
#' * `n_comp_cross` -- components of the female x male graph of the crosses that
#'   receive at least one plot, pooled over locations. Because GCA is a main
#'   effect shared by every location, this is what links GCA contrasts by data;
#'   at one location it is exactly the bipartite count of
#'   [design_diagnostics]. Two NC II blocks stay two components however they
#'   are spread over locations.
#' * `n_comp_loc` -- components of the location graph in which two locations
#'   are joined when they share a parent. Location contrasts are linked by data
#'   only when it is 1.
#'
#' Both equal to 1 is necessary, not sufficient: a relationship matrix can
#' link what the data do not, and shared parents link locations only through
#' the GCA of those parents.
#'
#' @inheritParams joint_pev
#' @return The list of [sparse_connectivity] with `n_comp_cross` and
#'   `n_comp_loc` appended.
#' @export
#' @examples
#' M <- joint_alloc(design_circulant(6, 6, 2), 6, 6, 3, 1, "coverage")
#' unlist(joint_connectivity(M, 6, 6)[c("n_comp_cross", "n_comp_loc")])
joint_connectivity <- function(M, nF, nM) {
  pix <- sparse_parent_index(nF, nM)
  planted <- which(rowSums(M) > 0)
  cx <- design_components(plan_clean(data.frame(parent1 = pix$f[planted],
                                                parent2 = pix$m[planted])), nF, nM)
  # Locations as one pool, parents (females then males) as the other: two
  # locations fall in one component exactly when a chain of shared parents
  # joins them. Only the location labels are read.
  cells <- which(M == 1L, arr.ind = TRUE)
  lp <- plan_clean(data.frame(parent1 = rep(cells[, 2], 2),
                              parent2 = c(pix$f[cells[, 1]], nF + pix$m[cells[, 1]])))
  lc <- design_components(lp, ncol(M), nF + nM)[seq_len(ncol(M))]
  c(sparse_connectivity(M, nF, nM),
    n_comp_cross = max(cx, na.rm = TRUE),
    n_comp_loc = length(unique(lc[!is.na(lc)])))
}
