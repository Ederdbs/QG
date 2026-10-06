# Sparse testing: which hybrid goes to which location.
#
# A multi-environment trial of single crosses from a female x male factorial,
# one plot per observed hybrid x location cell. The phenotype is
#
#   y = mu + loc + gf + gm + sca + gf:loc + gm:loc + sca:loc + e
#
# and the target is the value in the target population of environments,
# gf + gm + sca. With one plot per cell sca:loc and e have the same incidence,
# so the analysis model carries their SUM as its residual; that aliasing is
# declared once here and assumed everywhere below.
#
# This is the phenotypic core of an external study (AlphaSimR founders, REML by
# `sommer`) whose cached results Chapter 4f reads. Here the variance components
# are KNOWN, so the mixed-model equations are solved directly and in base R --
# no REML, no Matrix. Dense equations are fine at the chapter's scale (20 x 20
# hybrids, 10 locations: about 850 equations).
#
# Hybrid index convention, used by every function in this file: the male varies
# fastest, h = (i - 1) * nM + j for female i and male j, which is the row order
# of kronecker(Af, Am).

# Female and male index of every hybrid, in the convention above.
sparse_parent_index <- function(nF, nM) {
  list(f = rep(seq_len(nF), each = nM), m = rep(seq_len(nM), times = nF))
}

#' Relationship matrix of inbred lines in half-sib families
#'
#' `n` inbred lines in `nfam` equal families. Lines are fully inbred, so the
#' diagonal is 1; half-sibs within a family share 0.25; families are unrelated.
#'
#' @param n Number of lines; must be a multiple of `nfam`.
#' @param nfam Number of families.
#' @return An `n x n` matrix.
#' @export
#' @examples
#' relmat_halfsib(6, 2)
relmat_halfsib <- function(n, nfam) {
  stopifnot(n %% nfam == 0)
  fam <- rep(seq_len(nfam), each = n / nfam)
  A <- 0.25 * outer(fam, fam, "==")
  diag(A) <- 1
  A
}

#' Variance components of the sparse-testing model
#'
#' The calibration of the external study: `s2f = s2m = 1`, SCA a quarter of a
#' GCA variance (`"low"`) or equal to it (`"high"`), every interaction with
#' location half of its main effect, and the plot error solved so that the
#' plot-level heritability `Vg / (Vg + VgxE + s2e)` equals `h2_plot`. These
#' proportions imply a genetic correlation between locations of
#' `Vg / (Vg + VgxE) = 2/3`.
#'
#' @param h2_plot Target plot-level heritability.
#' @param sca `"low"` or `"high"`.
#' @return A list of components, plus `s2res = s2e + s2sl` (the residual the
#'   analysis model estimates under one plot per cell), `Vg`, `VgxE`, `h2_plot`.
#' @export
#' @examples
#' sparse_vc(0.4)$s2e
sparse_vc <- function(h2_plot, sca = c("low", "high")) {
  sca <- match.arg(sca)
  s2f <- 1; s2m <- 1
  s2s <- if (sca == "low") 0.25 else 1
  s2fl <- s2f / 2; s2ml <- s2m / 2; s2sl <- s2s / 2
  Vg <- s2f + s2m + s2s
  VgxE <- s2fl + s2ml + s2sl
  s2e <- Vg / h2_plot - Vg - VgxE
  if (s2e <= 0) stop("sparse_vc: h2_plot too high for these proportions")
  list(s2f = s2f, s2m = s2m, s2s = s2s, s2fl = s2fl, s2ml = s2ml, s2sl = s2sl,
       s2e = s2e, s2res = s2e + s2sl, Vg = Vg, VgxE = VgxE, h2_plot = h2_plot)
}

#' Allocate the hybrids of a factorial to locations
#'
#' Returns which hybrid x location cells receive a plot, with every hybrid in
#' exactly `k` locations (all of them for `"complete"`).
#'
#' * `"complete"` -- every cell.
#' * `"random"` -- each hybrid in `k` locations drawn independently. Location
#'   sizes then fluctuate binomially.
#' * `"parentage"` -- the factorial is cut into `nM` cyclic groups,
#'   `g(i, j) = ((j - i) mod nM) + 1`; each group holds every female once and
#'   every male `nF / nM` times, so any location that receives one group already
#'   has both pools complete. Groups go to `k` locations each with balanced
#'   location loads, and for `k > 1` a short exchange search first minimises
#'   the number of location pairs sharing no group, then maximises the harmonic
#'   mean of the pairwise concurrences. With `nM * k < nLoc * (nLoc - 1) / 2`
#'   groups cannot touch every pair and some pairs stay disconnected.
#'
#' The optimised-incomplete-block design of the external study (an exchange
#' algorithm on the mixed-model coefficient matrix, with replicated checks) is
#' not ported: it gave no advantage on untested hybrids, and Chapter 4f reads
#' its numbers from cache.
#'
#' @param nF,nM Females and males; `"parentage"` needs `nF` a multiple of `nM`.
#' @param nLoc Number of locations.
#' @param k Locations per hybrid, `1 <= k <= nLoc`. Ignored by `"complete"`.
#' @param strategy One of `"complete"`, `"random"`, `"parentage"`.
#' @param n_iter Exchange proposals for `"parentage"`.
#' @return An integer `nF*nM x nLoc` 0/1 matrix, hybrids in the file's index
#'   convention (male fastest).
#' @export
#' @examples
#' M <- sparse_alloc(4, 4, 4, k = 1, strategy = "parentage")
#' colSums(M)
sparse_alloc <- function(nF, nM, nLoc, k = nLoc,
                         strategy = c("complete", "random", "parentage"),
                         n_iter = 400L) {
  strategy <- match.arg(strategy)
  nHyb <- nF * nM
  if (strategy == "complete") return(matrix(1L, nHyb, nLoc))
  stopifnot(k >= 1, k <= nLoc)
  M <- matrix(0L, nHyb, nLoc)
  if (strategy == "random") {
    for (h in seq_len(nHyb)) M[h, sample.int(nLoc, k)] <- 1L
    return(M)
  }
  if (nF %% nM != 0) stop("sparse_alloc: 'parentage' needs nF a multiple of nM")
  pix <- sparse_parent_index(nF, nM)
  grp <- ((pix$m - pix$f) %% nM) + 1L
  B <- sparse_assign_groups(nM, nLoc, k, n_iter)
  for (g in seq_len(nM)) M[grp == g, B[g, ]] <- 1L
  M
}

# Group x location incidence with k locations per group, loads balanced to
# +-1, and pairwise concurrence made as even as an exchange search can manage.
# The criterion is lexicographic: first the number of location pairs sharing no
# group, then sum(1 / concurrence) -- the harmonic-mean criterion of the
# external study. (That study returned -Inf for any disconnected assignment,
# which leaves the search no gradient to climb out of one.) With k = 1 no
# assignment can connect locations through hybrids; only the parents do.
sparse_assign_groups <- function(nG, nLoc, k, n_iter) {
  B <- matrix(FALSE, nG, nLoc)
  load <- numeric(nLoc)
  for (g in sample.int(nG)) {
    pick <- order(load + stats::runif(nLoc, 0, 1e-6))[seq_len(k)]
    B[g, pick] <- TRUE
    load[pick] <- load[pick] + 1
  }
  if (k == 1 || nLoc < 2) return(B)
  crit <- function(B) {
    off <- crossprod(B * 1)[upper.tri(diag(nLoc))]
    -(1e6 * sum(off == 0) + sum(1 / pmax(off, 1)))
  }
  best <- crit(B)
  # Move one group from location a to b; when that would unbalance the loads
  # (always, if nG * k is a multiple of nLoc), pair it with a second group
  # moving b -> a so the loads are unchanged.
  for (it in seq_len(n_iter)) {
    g <- sample.int(nG, 1L)
    on <- which(B[g, ]); off <- which(!B[g, ])
    if (!length(off)) next
    a <- on[sample.int(length(on), 1L)]; b <- off[sample.int(length(off), 1L)]
    B2 <- B; B2[g, a] <- FALSE; B2[g, b] <- TRUE
    ld <- colSums(B2)
    if (max(ld) - min(ld) > 1) {
      g2 <- which(B2[, b] & !B2[, a] & seq_len(nG) != g)
      if (!length(g2)) next
      g2 <- g2[sample.int(length(g2), 1L)]
      B2[g2, b] <- FALSE; B2[g2, a] <- TRUE
    }
    c2 <- crit(B2)
    if (c2 > best) { B <- B2; best <- c2 }
  }
  B
}

#' Connectivity diagnostics of an allocation
#'
#' Everything here is computable before planting.
#'
#' @param M Allocation matrix from [sparse_alloc] (rows may be zeroed to leave
#'   hybrids untested).
#' @param nF,nM Females and males.
#' @return A named list: `n_plots`; `n_obs_hyb` (hybrids with at least one
#'   plot); `fem_cover`, `male_cover` (mean fraction of each pool present per
#'   location); `loc_size_cv`; and, for two or more locations, `conc_mean` and
#'   `conc_hmean` (mean and harmonic mean of the number of hybrids shared by a
#'   pair of locations -- the harmonic mean is 0 as soon as one pair shares
#'   none), `frac_disconn` (fraction of location pairs sharing no hybrid), and
#'   `fem_common`, `male_common` (mean number of parents a pair of locations
#'   shares).
#' @export
#' @examples
#' sparse_connectivity(sparse_alloc(10, 10, 6, 2, "parentage"), 10, 10)
sparse_connectivity <- function(M, nF, nM) {
  L <- ncol(M)
  pix <- sparse_parent_index(nF, nM)
  Fm <- (rowsum(M, pix$f) > 0) * 1
  Mm <- (rowsum(M, pix$m) > 0) * 1
  sz <- colSums(M)
  out <- list(n_plots = sum(M), n_obs_hyb = sum(rowSums(M) > 0),
              fem_cover = mean(colMeans(Fm)), male_cover = mean(colMeans(Mm)),
              loc_size_cv = if (L > 1) stats::sd(sz) / mean(sz) else 0)
  if (L < 2) return(out)
  ut <- upper.tri(diag(L))
  off <- crossprod(M)[ut]
  out$conc_mean <- mean(off)
  out$conc_hmean <- if (all(off > 0)) length(off) / sum(1 / off) else 0
  out$frac_disconn <- mean(off == 0)
  out$fem_common <- mean(crossprod(Fm)[ut])
  out$male_common <- mean(crossprod(Mm)[ut])
  out
}

#' Simulate true values and plot phenotypes for an allocation
#'
#' GCA, SCA and their interactions with location are drawn from the Kronecker
#' structures `Af`, `Am`, `Af %x% Am` (and the same crossed with an identity
#' over locations); location effects are fixed nuisance drawn once.
#'
#' @param M Allocation matrix (`nF*nM x nLoc`), from [sparse_alloc].
#' @param nF,nM Females and males.
#' @param vc Components from [sparse_vc].
#' @param Af,Am Relationship matrices of the two pools.
#' @return A list: `g_target` (true value of every hybrid in the target
#'   population of environments), `g_loc` (`nHyb x nLoc` true values per
#'   location), and `pheno`, a data frame with `y`, `hyb`, `loc` (integer
#'   indices) for the observed cells.
#' @export
sparse_simulate <- function(M, nF, nM, vc, Af = diag(nF), Am = diag(nM)) {
  L <- ncol(M)
  pix <- sparse_parent_index(nF, nM)
  tLf <- t(chol(Af)); Lm <- chol(Am)
  zm <- function(r, c) matrix(stats::rnorm(r * c), r, c)
  gf <- drop(tLf %*% stats::rnorm(nF)) * sqrt(vc$s2f)
  gm <- drop(t(Lm) %*% stats::rnorm(nM)) * sqrt(vc$s2m)
  # vec over (i, j) with j fastest of tLf Z Lm has covariance Af %x% Am.
  sca <- as.vector(t(tLf %*% zm(nF, nM) %*% Lm)) * sqrt(vc$s2s)
  FL <- tLf %*% zm(nF, L) * sqrt(vc$s2fl)
  ML <- t(Lm) %*% zm(nM, L) * sqrt(vc$s2ml)
  g_target <- gf[pix$f] + gm[pix$m] + sca
  g_loc <- g_target + FL[pix$f, , drop = FALSE] + ML[pix$m, , drop = FALSE] +
    vapply(seq_len(L), function(l)
      as.vector(t(tLf %*% zm(nF, nM) %*% Lm)) * sqrt(vc$s2sl), numeric(nF * nM))
  loc_eff <- stats::rnorm(L, 0, 2)
  cells <- which(M == 1L, arr.ind = TRUE)
  y <- 100 + loc_eff[cells[, 2]] + g_loc[cells] +
    stats::rnorm(nrow(cells), 0, sqrt(vc$s2e))
  list(g_target = g_target, g_loc = g_loc,
       pheno = data.frame(y = y, hyb = cells[, 1], loc = cells[, 2]))
}

# Design pieces shared by sparse_blup() and its oracle: fixed-effect matrix
# (observed locations only), incidence of each random term, and the term's
# covariance matrix (unscaled) and variance.
sparse_terms <- function(pheno, nF, nM, nLoc, vc, Af, Am) {
  pix <- sparse_parent_index(nF, nM)
  f <- pix$f[pheno$hyb]; m <- pix$m[pheno$hyb]
  loc <- factor(pheno$loc)
  X <- if (nlevels(loc) > 1) stats::model.matrix(~ loc) else matrix(1, nrow(pheno), 1)
  inc <- function(idx, n) { Z <- matrix(0, length(idx), n); Z[cbind(seq_along(idx), idx)] <- 1; Z }
  IL <- diag(nLoc)
  list(X = X,
       terms = list(
         f  = list(Z = inc(f, nF), G = Af, s2 = vc$s2f),
         m  = list(Z = inc(m, nM), G = Am, s2 = vc$s2m),
         h  = list(Z = inc(pheno$hyb, nF * nM), G = kronecker(Af, Am), s2 = vc$s2s),
         fl = list(Z = inc((f - 1) * nLoc + pheno$loc, nF * nLoc),
                   G = kronecker(Af, IL), s2 = vc$s2fl),
         ml = list(Z = inc((m - 1) * nLoc + pheno$loc, nM * nLoc),
                   G = kronecker(Am, IL), s2 = vc$s2ml)),
       pix = pix)
}

# Rows map the random-effect vector (f, m, h, fl, ml stacked) to the target
# value gf_i + gm_j + sca_ij of every hybrid.
sparse_target_map <- function(nF, nM, nLoc, pix) {
  nH <- nF * nM
  K <- matrix(0, nH, nF + nM + nH + (nF + nM) * nLoc)
  K[cbind(seq_len(nH), pix$f)] <- 1
  K[cbind(seq_len(nH), nF + pix$m)] <- 1
  K[cbind(seq_len(nH), nF + nM + seq_len(nH))] <- 1
  K
}

#' BLUP of hybrid values from a sparse trial, with known components
#'
#' Solves Henderson's mixed-model equations for
#' `y = X b + Z_f u_f + Z_m u_m + Z_h u_h + Z_fl u_fl + Z_ml u_ml + e`, with
#' `u_f ~ N(0, Af s2f)`, `u_m ~ N(0, Am s2m)`, `u_h ~ N(0, (Af %x% Am) s2s)`,
#' `u_fl ~ N(0, (Af %x% I) s2fl)`, `u_ml ~ N(0, (Am %x% I) s2ml)` and residual
#' variance `vc$s2res` (`s2e + s2sl`: with one plot per cell the SCA x
#' location term is the residual). `X` holds the observed locations only.
#' Hybrids with no plot get their BLUP through the relationship matrices --
#' the CV1 prediction.
#'
#' @param pheno Data frame with `y`, `hyb`, `loc`, as in
#'   `sparse_simulate()$pheno`.
#' @param nF,nM,nLoc Factorial and trial dimensions.
#' @param vc Components from [sparse_vc]; `s2res` is the residual used.
#' @param Af,Am Relationship matrices of the two pools.
#' @return A list: `blup` (target value of every hybrid), `blup_loc`
#'   (`nHyb x nLoc`, target plus the location-specific GCA interactions), and
#'   `pev` (prediction error variance of each target value).
#' @seealso [ref_sparse_blup] for the literal GLS oracle.
#' @export
sparse_blup <- function(pheno, nF, nM, nLoc, vc, Af = diag(nF), Am = diag(nM)) {
  d <- sparse_terms(pheno, nF, nM, nLoc, vc, Af, Am)
  W <- cbind(d$X, do.call(cbind, lapply(d$terms, `[[`, "Z")))
  C <- crossprod(W)
  nb <- ncol(d$X); off <- nb
  for (t in d$terms) {
    ix <- off + seq_len(ncol(t$Z))
    C[ix, ix] <- C[ix, ix] + solve(t$G) * (vc$s2res / t$s2)
    off <- off + ncol(t$Z)
  }
  R <- chol(C)
  sol <- backsolve(R, backsolve(R, crossprod(W, pheno$y), transpose = TRUE))
  u <- sol[-seq_len(nb)]
  K <- sparse_target_map(nF, nM, nLoc, d$pix)
  Cuu <- chol2inv(R)[-seq_len(nb), -seq_len(nb)]
  blup <- drop(K %*% u)
  o <- nF + nM + nF * nM
  FL <- matrix(u[o + seq_len(nF * nLoc)], nF, nLoc, byrow = TRUE)
  ML <- matrix(u[o + nF * nLoc + seq_len(nM * nLoc)], nM, nLoc, byrow = TRUE)
  list(blup = blup,
       blup_loc = blup + FL[d$pix$f, , drop = FALSE] + ML[d$pix$m, , drop = FALSE],
       pev = rowSums((K %*% Cuu) * K) * vc$s2res)
}
