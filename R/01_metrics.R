# Diversity metrics. All share the signature f(idx, ctx) -> scalar.
# All operate on the molecular coancestry `ctx$f`, never on centered G.

# --- Core --------------------------------------------------------------------

#' Group coancestry
#'
#' Cockerham (1967) group coancestry: the mean of **all** `n^2` elements of the
#' coancestry submatrix, diagonal included. The off-diagonal mean alone ignores
#' each hybrid's own homozygosity, which is precisely why a small set always
#' looks highly coancestral.
#'
#' @param idx Integer vector of selected row indices.
#' @param ctx Evaluation context, see [build_ctx].
#' @return A scalar in `[0, 1]`.
#' @family diversity metrics
#' @export
theta_group <- function(idx, ctx) mean(ctx$f[idx, idx])

#' Gene diversity
#'
#' `GD = 1 - theta`. This is exactly Nei's expected heterozygosity `He`; the
#' identity is asserted in the test suite. Do not add a second heterozygosity
#' metric -- this is it.
#'
#' @inheritParams theta_group
#' @return A scalar in `[0, 1]`.
#' @family diversity metrics
#' @export
gene_diversity <- function(idx, ctx) 1 - theta_group(idx, ctx)

#' Status number
#'
#' `Ns = 1 / (2 theta)` (Lindgren & Mullin 1997), read as the number of
#' equivalent unrelated hybrids. It is a static descriptor of the group, **not**
#' a drift projection, and must not be substituted for a rate-based `Ne`.
#'
#' @inheritParams theta_group
#' @return A positive scalar.
#' @family diversity metrics
#' @export
status_number <- function(idx, ctx) 1 / (2 * theta_group(idx, ctx))

#' Group coancestry from allele frequencies
#'
#' The same quantity as [theta_group], computed as `mean(p^2 + (1 - p)^2)`.
#' Costs `O(n m)` instead of `O(n^2)` and runs roughly 100x slower here: use it
#' for validation, never inside the differential-evolution fitness.
#'
#' @inheritParams theta_group
#' @return A scalar in `[0, 1]`.
#' @family diversity metrics
#' @export
theta_from_freq <- function(idx, ctx) {
  p <- colMeans(ctx$X[idx, , drop = FALSE])
  mean(p^2 + (1 - p)^2)
}

#' Nei's expected heterozygosity
#'
#' `He = mean(2 p (1 - p))`, computed independently of [gene_diversity] so the
#' two can be checked against each other.
#'
#' @inheritParams theta_group
#' @return A scalar in `[0, 1]`.
#' @family diversity metrics
#' @export
he_nei <- function(idx, ctx) {
  p <- colMeans(ctx$X[idx, , drop = FALSE])
  mean(2 * p * (1 - p))
}

#' Effective number of parent lines
#'
#' `1 / sum(p^2)` over the parent-line usage counts induced by the selection.
#' Independent of `f`, so it catches the case "theta looks fine, but only 12
#' lines were actually used".
#'
#' @inheritParams theta_group
#' @return A scalar between 1 and the number of lines.
#' @family diversity metrics
#' @export
ne_parents <- function(idx, ctx) {
  cnt <- tabulate(c(ctx$ped$a[idx], ctx$ped$b[idx]), nbins = ctx$n_lines)
  p <- cnt / sum(cnt)
  1 / sum(p^2)
}

#' Line contribution weights induced by a selection
#'
#' The sufficient statistic for every line-level metric: how much each parent
#' line contributes to the selected hybrid set, normalised within pool.
#'
#' @inheritParams theta_group
#' @return A list with numeric vectors `A` and `B`, each of length
#'   `ctx$n_lines` and summing to 1.
#' @export
line_weights <- function(idx, ctx) {
  wA <- tabulate(ctx$ped$a[idx], nbins = ctx$n_lines)
  wB <- tabulate(ctx$ped$b[idx], nbins = ctx$n_lines)
  list(A = wA / sum(wA), B = wB / sum(wB))
}

#' Group coancestry within and between heterotic pools
#'
#' Diversity *between* pools is the engine of heterosis: global theta can look
#' healthy while one pool is being eroded. Requires `ctx$fL`, the coancestry
#' matrix between lines; returns `NA` without it.
#'
#' @inheritParams theta_group
#' @return A named numeric vector `theta_A`, `theta_B`, `theta_AB`.
#' @family diversity metrics
#' @export
theta_pools <- function(idx, ctx) {
  if (is.null(ctx$fL)) return(c(theta_A = NA, theta_B = NA, theta_AB = NA))
  w <- line_weights(idx, ctx)
  c(theta_A = drop(w$A %*% ctx$fL %*% w$A),
    theta_B = drop(w$B %*% ctx$fL %*% w$B),
    theta_AB = drop(w$A %*% ctx$fL %*% w$B))
}

#' Caballero & Toro partition of gene diversity
#'
#' Equation 8 of Caballero & Toro (2002):
#' `GD_T = GD_WI + GD_BI + GD_BS`, with `F_ST = GD_BS / GD_T`.
#'
#' Subpopulations are the two heterotic pools, weighted by the line usage the
#' selection induces. `GD_BS` is the between-pool divergence -- the heterosis
#' engine, the one component that must be *preserved* rather than minimised.
#' With inbred parent lines `GD_WI` is 0 by construction (all diversity is
#' `BI + BS`); the hybrid-level `GD_WI_hyb` is the component that carries signal
#' and it needs no `fL`, so it is always returned.
#'
#' @inheritParams theta_group
#' @param tp Pool coancestries, see [theta_pools]. Passed in to avoid
#'   recomputing them.
#' @return A named numeric vector `GD_WI_hyb`, `GD_T`, `GD_WI`, `GD_BI`,
#'   `GD_BS`, `F_ST`.
#' @family diversity metrics
#' @export
gd_partition <- function(idx, ctx, tp = theta_pools(idx, ctx)) {
  # Hybrid-level within-individual diversity: the heterozygosity actually
  # carried inside the F1s. Needs no fL, so it always runs.
  hyb <- c(GD_WI_hyb = 1 - mean(diag(ctx$f)[idx]))
  if (is.null(ctx$fL))
    return(c(hyb, GD_T = NA, GD_WI = NA, GD_BI = NA, GD_BS = NA, F_ST = NA))

  w <- line_weights(idx, ctx)
  s_til <- sum((w$A + w$B) / 2 * diag(ctx$fL))         # mean self-coancestry
  f_bar <- (tp[["theta_A"]] + 2 * tp[["theta_AB"]] + tp[["theta_B"]]) / 4
  f_til <- (tp[["theta_A"]] + tp[["theta_B"]]) / 2
  c(hyb, GD_T = 1 - f_bar, GD_WI = 1 - s_til, GD_BI = s_til - f_til,
    GD_BS = f_til - f_bar, F_ST = (f_til - f_bar) / (1 - f_bar))
}

#' Effective number of lines used in each pool
#'
#' Unlike [theta_pools] this needs no `fL`, only the pedigree. Catches erosion
#' confined to a single pool.
#'
#' @inheritParams theta_group
#' @return A named numeric vector `Ne_lines_A`, `Ne_lines_B`.
#' @family diversity metrics
#' @export
ne_lines_pool <- function(idx, ctx) {
  ne <- function(v) { p <- tabulate(v) / length(v); 1 / sum(p^2) }
  c(Ne_lines_A = ne(ctx$ped$a[idx]), Ne_lines_B = ne(ctx$ped$b[idx]))
}

#' Alleles lost
#'
#' Count of markers that were polymorphic in the candidate pool and fell below
#' `maf` in the selection. The only metric in this catalogue that is genuinely
#' independent of theta.
#'
#' @inheritParams theta_group
#' @param maf Minor allele frequency threshold below which a marker counts as
#'   lost.
#' @return An integer count.
#' @family diversity metrics
#' @export
alleles_lost <- function(idx, ctx, maf = 0.05) {
  p <- colMeans(ctx$X[idx, , drop = FALSE])
  sum(pmin(p, 1 - p) < maf & ctx$maf_pop >= maf)
}

#' Frequency-based metrics, in a single marker sweep
#'
#' Everything that needs a pass over the markers, in **one** pass over
#' `X[idx, ]`. Anything new that needs `colMeans(X[idx, ])` belongs here, not in
#' a new function with its own sweep.
#'
#' Returns the two lenses of Meuwissen et al. (2020): `F_hom` sees
#' heterozygosity lost, `F_drift` sees allele-frequency change. Constraining
#' theta (their `G_0.5` scheme) pins `F_hom` and leaves `F_drift` free -- that is
#' the unmonitored bill. `cov_diag` is exactly the gap between them (their
#' Eq. 3). Both are anchored on `ctx$p0`, the frozen candidate-pool
#' frequencies; never recompute a base per scenario.
#'
#' @inheritParams theta_group
#' @param maf Minor allele frequency threshold for `alleles_lost`.
#' @param rare_lo Lower bound defining the "rare in the pool" marker class.
#' @param eps Tolerance for dropping markers fixed in the base.
#' @return A named numeric vector `He`, `alleles_lost`, `F_hom`, `F_drift`,
#'   `cov_diag`, `cor_dp_p0`, `rare_retained`.
#' @family diversity metrics
#' @export
freq_metrics <- function(idx, ctx, maf = 0.05, rare_lo = 0.01, eps = 1e-6) {
  p <- colMeans(ctx$X[idx, , drop = FALSE])
  keep <- ctx$p0 > eps & ctx$p0 < 1 - eps
  p0 <- ctx$p0[keep]; pk <- p[keep]
  s <- sqrt(p0 * (1 - p0))
  dp <- pk - p0
  x <- (p0 - 0.5) / s                                  # standardised base
  y <- dp / s                                          # standardised change
  rare <- ctx$maf_pop >= rare_lo & ctx$maf_pop < maf

  c(He = mean(2 * p * (1 - p)),
    alleles_lost = sum(pmin(p, 1 - p) < maf & ctx$maf_pop >= maf),
    F_hom = 1 - mean((pk * (1 - pk)) / (p0 * (1 - p0))),   # CAN be negative
    F_drift = mean(dp^2 / (p0 * (1 - p0))),                # never negative
    # Exactly F_hom - F_drift (their Eq. 3). Note mean(), not cov(): the two
    # agree only when mean(y) == 0; test-lenses.R asserts this identity.
    cov_diag = 2 * mean(x * y),
    cor_dp_p0 = if (stats::sd(y) > 0) stats::cor(x, y) else NA_real_,
    # Allelic richness: rare pool markers still segregating. More sensitive to
    # bottlenecks than He (Caballero & Toro 2002, sec. 11).
    rare_retained = if (any(rare)) mean(pmin(p[rare], 1 - p[rare]) > 0) else NA_real_)
}

# --- Diagnostic ---------------------------------------------------------------

# Distance = 1 - molecular coancestry.

#' Entry-to-nearest-entry distance
#'
#' Core Hunter 3's E-NE: non-redundancy *within* the selection. Tells apart
#' "200 entries spread out" from "100 near-identical pairs".
#'
#' @inheritParams theta_group
#' @return A scalar.
#' @family diversity metrics
#' @export
ene <- function(idx, ctx) {
  d <- 1 - ctx$f[idx, idx]
  diag(d) <- Inf
  mean(apply(d, 1, min))
}

#' Accession-to-nearest-entry distance
#'
#' Core Hunter 3's A-NE: how well the selection represents the whole population.
#'
#' @inheritParams theta_group
#' @return A scalar.
#' @family diversity metrics
#' @export
ane <- function(idx, ctx) mean(1 - apply(ctx$f[, idx, drop = FALSE], 1, max))

#' Effective dimensionality
#'
#' How many independent directions of variation remain, as
#' `(sum lambda)^2 / sum lambda^2`. The submatrix is double-centered first: on a
#' raw all-positive `f` the leading eigenvalue is just `n * theta`, so the
#' uncentered version only re-measures theta.
#'
#' @inheritParams theta_group
#' @return A scalar in `(0, n - 1]`.
#' @family diversity metrics
#' @export
eff_dim <- function(idx, ctx) {
  K <- ctx$f[idx, idx]
  K <- K - rowMeans(K) - rep(colMeans(K), each = length(idx)) + mean(K)
  l <- eigen(K, symmetric = TRUE, only.values = TRUE)$values
  sum(l)^2 / sum(l^2)
}

#' Nei's Gst between selected and non-selected
#'
#' @inheritParams theta_group
#' @return A scalar.
#' @family diversity metrics
#' @export
gst <- function(idx, ctx) {
  ps <- colMeans(ctx$X[idx, , drop = FALSE])
  pn <- colMeans(ctx$X[-idx, , drop = FALSE])
  hs <- mean(p_het(ps) + p_het(pn)) / 2
  ht <- mean(p_het((ps + pn) / 2))
  (ht - hs) / ht
}

#' Heterozygosity from an allele frequency
#'
#' @param p Numeric vector of allele frequencies.
#' @return `2 p (1 - p)`.
#' @export
p_het <- function(p) 2 * p * (1 - p)

#' Maximum use of any single parent line
#'
#' @inheritParams theta_group
#' @return An integer count.
#' @family diversity metrics
#' @export
max_line_use <- function(idx, ctx) {
  max(tabulate(c(ctx$ped$a[idx], ctx$ped$b[idx]), nbins = ctx$n_lines))
}

#' Mean multi-trait index of a selection
#'
#' @inheritParams theta_group
#' @return A scalar, in standard deviations of the candidate pool.
#' @export
mean_index <- function(idx, ctx) mean(ctx$index[idx])

#' Mean off-diagonal coancestry
#'
#' The metric commonly used in production, kept for comparison. It ranks
#' selections identically to [gene_diversity] but has no absolute scale and
#' ignores each hybrid's own homozygosity.
#'
#' @inheritParams theta_group
#' @return A scalar.
#' @family diversity metrics
#' @export
mean_offdiag <- function(idx, ctx) {
  s <- ctx$f[idx, idx]
  n <- length(idx)
  (sum(s) - sum(diag(s))) / (n * (n - 1))
}

# --- Aggregators ---------------------------------------------------------------

#' Cheap metric panel
#'
#' Safe to call thousands of times: the null distribution and the
#' differential-evolution fitness both run through here. Single-lens by design.
#'
#' @inheritParams theta_group
#' @return A named numeric vector.
#' @seealso [metrics_full] for the post-hoc panel.
#' @export
metrics_cheap <- function(idx, ctx) {
  th <- theta_group(idx, ctx)
  c(index = mean_index(idx, ctx), theta = th, GD = 1 - th, Ns = 1 / (2 * th),
    offdiag = mean_offdiag(idx, ctx), Ne_parents = ne_parents(idx, ctx),
    max_line = max_line_use(idx, ctx), theta_pools(idx, ctx))
}

#' Full metric panel
#'
#' Adds everything that sweeps all markers or eigendecomposes. Post-hoc only --
#' never inside the differential-evolution fitness loop.
#'
#' @inheritParams theta_group
#' @return A named numeric vector.
#' @seealso [metrics_cheap] for the inner-loop panel.
#' @export
metrics_full <- function(idx, ctx) {
  mc <- metrics_cheap(idx, ctx)
  c(mc, ne_lines_pool(idx, ctx), freq_metrics(idx, ctx),
    gd_partition(idx, ctx, tp = mc[c("theta_A", "theta_B", "theta_AB")]),
    ENE = ene(idx, ctx), ANE = ane(idx, ctx),
    eff_dim = eff_dim(idx, ctx), Gst = gst(idx, ctx))
}
