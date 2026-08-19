# Diversity metrics. All share the signature f(idx, ctx) -> scalar.
# All operate on the molecular coancestry `ctx$f`, never on centered G.

# --- Core --------------------------------------------------------------------

# Group coancestry (Cockerham): mean of ALL n^2 elements, diagonal included.
# The off-diagonal mean alone ignores each hybrid's own homozygosity.
theta_group <- function(idx, ctx) mean(ctx$f[idx, idx])

# Gene diversity. Exact identity: 1 - theta == Nei's He (see tests/).
gene_diversity <- function(idx, ctx) 1 - theta_group(idx, ctx)

# Status number (Lindgren & Mullin 1997): "equivalent unrelated hybrids".
# A static descriptor of the group, not a drift projection.
status_number <- function(idx, ctx) 1 / (2 * theta_group(idx, ctx))

# Same quantity via allele frequencies: O(n*m) instead of O(n^2).
# ~100x more expensive — used for validation, never inside the DE fitness.
theta_from_freq <- function(idx, ctx) {
  p <- colMeans(ctx$X[idx, , drop = FALSE])
  mean(p^2 + (1 - p)^2)
}

# Nei's He, computed independently.
he_nei <- function(idx, ctx) {
  p <- colMeans(ctx$X[idx, , drop = FALSE])
  mean(2 * p * (1 - p))
}

# Effective number of parents. Independent of f: catches the case "theta looks
# fine, but only 12 lines were actually used".
ne_parents <- function(idx, ctx) {
  cnt <- tabulate(c(ctx$ped$a[idx], ctx$ped$b[idx]), nbins = ctx$n_lines)
  p <- cnt / sum(cnt)
  1 / sum(p^2)
}

# Line contribution weights induced by a selection, one vector per pool.
line_weights <- function(idx, ctx) {
  wA <- tabulate(ctx$ped$a[idx], nbins = ctx$n_lines)
  wB <- tabulate(ctx$ped$b[idx], nbins = ctx$n_lines)
  list(A = wA / sum(wA), B = wB / sum(wB))
}

# Decomposition by heterotic group. Diversity BETWEEN pools is the engine of
# heterosis: global theta can look fine while one pool is being eroded.
theta_pools <- function(idx, ctx) {
  if (is.null(ctx$fL)) return(c(theta_A = NA, theta_B = NA, theta_AB = NA))
  w <- line_weights(idx, ctx)
  c(theta_A = drop(w$A %*% ctx$fL %*% w$A),
    theta_B = drop(w$B %*% ctx$fL %*% w$B),
    theta_AB = drop(w$A %*% ctx$fL %*% w$B))
}

# Caballero & Toro (2002) partition of total gene diversity, Eq. 8:
#   GD_T = GD_WI + GD_BI + GD_BS,  F_ST = GD_BS / GD_T
# Subpopulations are the two heterotic pools, weighted by the line usage the
# selection induces. GD_BS is the between-pool divergence -- the heterosis
# engine, the ONE component that must be preserved rather than minimised.
# With inbred parent lines GD_WI ~ 0 by construction (all diversity is BI + BS).
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

# Effective number of lines used in EACH pool. Unlike theta_pools, this needs
# no fL — only the pedigree. Catches erosion in a single pool.
ne_lines_pool <- function(idx, ctx) {
  ne <- function(v) { p <- tabulate(v) / length(v); 1 / sum(p^2) }
  c(Ne_lines_A = ne(ctx$ped$a[idx]), Ne_lines_B = ne(ctx$ped$b[idx]))
}

# Markers that were polymorphic in the population and became rare/fixed in the
# selection. The only metric genuinely independent of theta.
alleles_lost <- function(idx, ctx, maf = 0.05) {
  p <- colMeans(ctx$X[idx, , drop = FALSE])
  sum(pmin(p, 1 - p) < maf & ctx$maf_pop >= maf)
}

# Everything that needs a sweep over the markers, in ONE pass over X[idx, ].
# Replaces four independent colMeans() calls and pays for the drift lens below.
#
# The two lenses of Meuwissen et al. (2020): F_hom sees heterozygosity lost,
# F_drift sees allele-frequency change. Constraining theta (= their G_0.5) pins
# F_hom and leaves F_drift free -- that is the unmonitored bill. Both are
# anchored on ctx$p0, the FROZEN candidate-pool frequencies; never recompute a
# base per scenario.
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
    # agree only when mean(y) == 0, and this identity is what tests/ asserts.
    cov_diag = 2 * mean(x * y),
    cor_dp_p0 = if (sd(y) > 0) cor(x, y) else NA_real_,
    # Allelic richness: rare pool markers still segregating. More sensitive to
    # bottlenecks than He (Caballero & Toro 2002, sec. 11).
    rare_retained = if (any(rare)) mean(pmin(p[rare], 1 - p[rare]) > 0) else NA_real_)
}

# --- Diagnostic ---------------------------------------------------------------

# Distance = 1 - molecular coancestry.

# Entry-to-nearest-entry (Core Hunter 3): non-redundancy WITHIN the selection.
# Tells apart "200 spread out" from "100 near-identical pairs".
ene <- function(idx, ctx) {
  d <- 1 - ctx$f[idx, idx]
  diag(d) <- Inf
  mean(apply(d, 1, min))
}

# Accession-to-nearest-entry: representativeness of the whole population.
ane <- function(idx, ctx) mean(1 - apply(ctx$f[, idx, drop = FALSE], 1, max))

# How many independent directions of variation remain. Double-centered first:
# on a raw all-positive f the leading eigenvalue is just n*theta, so the
# un-centered version only re-measured theta.
eff_dim <- function(idx, ctx) {
  K <- ctx$f[idx, idx]
  K <- K - rowMeans(K) - rep(colMeans(K), each = length(idx)) + mean(K)
  l <- eigen(K, symmetric = TRUE, only.values = TRUE)$values
  sum(l)^2 / sum(l^2)
}

# Nei's Gst between selected and non-selected.
gst <- function(idx, ctx) {
  ps <- colMeans(ctx$X[idx, , drop = FALSE])
  pn <- colMeans(ctx$X[-idx, , drop = FALSE])
  hs <- mean(p_het(ps) + p_het(pn)) / 2
  ht <- mean(p_het((ps + pn) / 2))
  (ht - hs) / ht
}
p_het <- function(p) 2 * p * (1 - p)

max_line_use <- function(idx, ctx) {
  max(tabulate(c(ctx$ped$a[idx], ctx$ped$b[idx]), nbins = ctx$n_lines))
}

mean_index <- function(idx, ctx) mean(ctx$index[idx])

# The metric the user has in production today, kept for comparison.
mean_offdiag <- function(idx, ctx) {
  s <- ctx$f[idx, idx]
  n <- length(idx)
  (sum(s) - sum(diag(s))) / (n * (n - 1))
}

# --- Aggregators ---------------------------------------------------------------

# Cheap: safe to run thousands of times (null distribution, DE fitness).
metrics_cheap <- function(idx, ctx) {
  th <- theta_group(idx, ctx)
  c(index = mean_index(idx, ctx), theta = th, GD = 1 - th, Ns = 1 / (2 * th),
    offdiag = mean_offdiag(idx, ctx), Ne_parents = ne_parents(idx, ctx),
    max_line = max_line_use(idx, ctx), theta_pools(idx, ctx))
}

# Expensive (sweep all 25k markers, or eigendecompose): post-hoc only.
# metrics_cheap stays single-lens by design -- it is the DE fitness path.
metrics_full <- function(idx, ctx) {
  mc <- metrics_cheap(idx, ctx)
  c(mc, ne_lines_pool(idx, ctx), freq_metrics(idx, ctx),
    gd_partition(idx, ctx, tp = mc[c("theta_A", "theta_B", "theta_AB")]),
    ENE = ene(idx, ctx), ANE = ane(idx, ctx),
    eff_dim = eff_dim(idx, ctx), Gst = gst(idx, ctx))
}
