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

# Decomposition by heterotic group. Diversity BETWEEN pools is the engine of
# heterosis: global theta can look fine while one pool is being eroded.
theta_pools <- function(idx, ctx) {
  if (is.null(ctx$fL)) return(c(theta_A = NA, theta_B = NA, theta_AB = NA))
  wA <- tabulate(ctx$ped$a[idx], nbins = ctx$n_lines); wA <- wA / sum(wA)
  wB <- tabulate(ctx$ped$b[idx], nbins = ctx$n_lines); wB <- wB / sum(wB)
  c(theta_A = drop(wA %*% ctx$fL %*% wA),
    theta_B = drop(wB %*% ctx$fL %*% wB),
    theta_AB = drop(wA %*% ctx$fL %*% wB))
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

# How many independent directions of variation remain.
eff_dim <- function(idx, ctx) {
  l <- eigen(ctx$f[idx, idx], symmetric = TRUE, only.values = TRUE)$values
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
metrics_full <- function(idx, ctx) {
  c(metrics_cheap(idx, ctx), ne_lines_pool(idx, ctx),
    He = he_nei(idx, ctx), alleles_lost = alleles_lost(idx, ctx),
    ENE = ene(idx, ctx), ANE = ane(idx, ctx),
    eff_dim = eff_dim(idx, ctx), Gst = gst(idx, ctx))
}
