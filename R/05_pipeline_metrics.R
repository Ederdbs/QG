# Diversity metrics for the four stages of a hybrid maize pipeline.
#
#   S1  heterotic-group conservation      (pool level)
#   S2  parent/cross selection for DH     (cross level)
#   S3  line-per-se selection             (line level)
#   S4  hybrid mining                     (cross level, F1 of fixed lines)
#
# Genotype convention: inbred lines are coded {0, 1} at m biallelic markers
# (L x m matrix GL). A line is homozygous, so its within-individual
# reference-allele frequency equals the genotype code. Hybrids take {0, 0.5, 1}.
#
# The kernel is the same molecular coancestry used everywhere else in the
# package, see molecular_coancestry(). Every identity implemented here is
# verified numerically against the oracles in R/09_reference.R.

# --- S0. The kernel, seen as a distance ---------------------------------------

#' Modified Rogers distance
#'
#' For inbred lines `MRD_ij = sqrt(mean((x_i - x_j)^2))`. This is not a
#' different statistic from molecular coancestry: `f_ij = 1 - MRD_ij^2`
#' exactly, so a programme reporting MRD and a programme reporting coancestry
#' are reporting the same thing on different scales.
#'
#' @param GL `L x m` line genotype matrix coded 0/1.
#' @return An `L x L` distance matrix.
#' @seealso [coancestry_from_mrd] for the inverse.
#' @export
mrd_matrix <- function(GL) {
  f <- molecular_coancestry(GL)
  # pmax() drops dim(), so restore it explicitly: this must stay a matrix.
  matrix(sqrt(pmax(0, 1 - f)), nrow(f), ncol(f))
}

#' Molecular coancestry from modified Rogers distance
#'
#' @param D A modified Rogers distance matrix, see [mrd_matrix].
#' @return The corresponding coancestry matrix, `1 - D^2`.
#' @export
coancestry_from_mrd <- function(D) 1 - D^2

# --- S1. Heterotic-group conservation -----------------------------------------

#' Decompose group coancestry over subpopulations
#'
#' Diversity in a hybrid programme is **two** objects moving in opposite
#' directions: within-pool diversity, which erodes under selection, and
#' between-pool divergence, which inflates. A single pool-wide statistic cannot
#' express both. The decomposition is exact for any partition:
#' `theta_T = sum_p w_p^2 theta_pp + sum over p != q of w_p w_q theta_pq`.
#'
#' Two incompatible `F_ST` definitions are both in common use and can differ by
#' roughly twofold on identical data. Wright/Nei-style takes between-pool
#' coancestry as the reference, `(theta_w - theta_B) / (1 - theta_B)`; Nei's
#' `G_ST` takes the pooled-frequency total, `(theta_w - theta_T) / (1 - theta_T)`.
#' Because `theta_T > theta_B` whenever the pools differ, `G_ST` is always the
#' smaller. Both are returned; report which one you used.
#'
#' @param GL `L x m` line genotype matrix coded 0/1.
#' @param pool Vector of pool labels, one per line.
#' @param f Optional precomputed coancestry matrix.
#' @return A list with the pool coancestry matrix `theta`, weights `w`,
#'   `theta_T`, `theta_w`, `theta_B`, `GD_T`, `GD_within`, `Fst_Wright`,
#'   `Gst_Nei`, `Ns_T` and `Ns_within`.
#' @export
theta_decompose <- function(GL, pool, f = NULL) {
  if (is.null(f)) f <- molecular_coancestry(GL)
  pool <- as.factor(pool); lv <- levels(pool)
  w <- as.vector(table(pool)) / length(pool); names(w) <- lv
  th <- outer(lv, lv, Vectorize(function(a, b) mean(f[pool == a, pool == b])))
  dimnames(th) <- list(lv, lv)
  theta_T <- sum(outer(w, w) * th)
  theta_w <- sum(w * diag(th))                       # within-pool, diagonal incl.
  theta_B <- if (length(lv) < 2) NA_real_ else
    sum(outer(w, w) * th * (1 - diag(length(lv)))) / (1 - sum(w^2))
  list(theta = th, w = w, theta_T = theta_T, theta_w = theta_w, theta_B = theta_B,
       GD_T = 1 - theta_T, GD_within = 1 - theta_w,
       Fst_Wright = (theta_w - theta_B) / (1 - theta_B),
       Gst_Nei    = (theta_w - theta_T) / (1 - theta_T),
       Ns_T = 1 / (2 * theta_T),
       Ns_within = setNames(1 / (2 * diag(th)), lv))
}

#' Nei's Gst from allele frequencies
#'
#' Computed the classical way, so the identity
#' `G_ST == (theta_w - theta_T) / (1 - theta_T)` can be confirmed against
#' [theta_decompose].
#'
#' @inheritParams theta_decompose
#' @return A named numeric vector `Hs`, `Ht`, `Gst`.
#' @export
gst_nei <- function(GL, pool) {
  pool <- as.factor(pool)
  P  <- do.call(rbind, lapply(levels(pool),
                              function(l) colMeans(GL[pool == l, , drop = FALSE])))
  w  <- as.vector(table(pool)) / length(pool)
  Hs <- sum(w * rowMeans(2 * P * (1 - P)))
  pT <- as.vector(w %*% P); Ht <- mean(2 * pT * (1 - pT))
  c(Hs = Hs, Ht = Ht, Gst = (Ht - Hs) / Ht)
}

#' Between-pool complementarity at the allele level
#'
#' The fraction of markers at which the two pools are near-fixed for opposite
#' alleles. This is the quantity that actually generates heterosis under a
#' dominance model, and unlike `F_ST` it does not keep rising as the pools drift
#' further apart at loci that were already divergent -- which is why `F_ST` is
#' the wrong thing to maximise.
#'
#' @inheritParams theta_decompose
#' @param thr Frequency above which a pool counts as fixed.
#' @return A named numeric vector `frac_opposite_fixed`, `frac_fixed_same`,
#'   `mean_abs_delta_p`.
#' @export
pool_complementarity <- function(GL, pool, thr = 0.9) {
  pool <- as.factor(pool); lv <- levels(pool)
  stopifnot(length(lv) == 2)
  p1 <- colMeans(GL[pool == lv[1], , drop = FALSE])
  p2 <- colMeans(GL[pool == lv[2], , drop = FALSE])
  c(frac_opposite_fixed = mean((p1 > thr & p2 < 1 - thr) | (p1 < 1 - thr & p2 > thr)),
    frac_fixed_same     = mean((p1 > thr & p2 > thr) | (p1 < 1 - thr & p2 < 1 - thr)),
    mean_abs_delta_p    = mean(abs(p1 - p2)))
}

#' Stage 1 monitoring panel
#'
#' The numbers to log every cycle and plot as a time series. Within-pool gene
#' diversity should be defended; `F_ST` should be held inside a band, not
#' maximised.
#'
#' @inheritParams theta_decompose
#' @param cycle Cycle label, carried through to the output.
#' @return A one-row data frame.
#' @export
s1_monitor <- function(GL, pool, cycle = NA) {
  d <- theta_decompose(GL, pool); cm <- pool_complementarity(GL, pool)
  data.frame(cycle = cycle,
             GD_within = d$GD_within, GD_total = d$GD_T,
             Fst_Wright = d$Fst_Wright, Gst_Nei = d$Gst_Nei,
             Ns_total = d$Ns_T,
             t(setNames(1 - diag(d$theta), paste0("GD_", names(d$w)))),
             frac_opposite_fixed = cm[["frac_opposite_fixed"]],
             mean_abs_delta_p = cm[["mean_abs_delta_p"]],
             row.names = NULL)
}

# --- S2. Choosing parents and crosses for DH induction ------------------------

#' Coancestry between two doubled-haploid sibs
#'
#' Each DH inherits each locus from either parent with probability 1/2, then
#' doubles, giving `E[f] = (1 + f_ij) / 2` for two sibs of the same family.
#'
#' @param f_ij Coancestry of the two parent lines.
#' @return A scalar.
#' @family DH identities
#' @export
dh_sib_coancestry <- function(f_ij) (1 + f_ij) / 2

#' Coancestry between doubled haploids from two different families
#'
#' `E[f] = (f_ik + f_il + f_jk + f_jl) / 4`.
#'
#' @param fL Line coancestry matrix.
#' @param i,j Parent lines of the first cross.
#' @param k,l Parent lines of the second cross.
#' @return A scalar.
#' @family DH identities
#' @export
dh_cross_coancestry <- function(fL, i, j, k, l) mean(fL[c(i, j), c(k, l)])

#' Group coancestry of a planned doubled-haploid pool
#'
#' From the crossing plan alone:
#' `theta_pool = w' fL w + (1 / D) (1 - mean_c[(1 + f_c) / 2])`,
#' where `w` is the parent-usage weight vector and `f_c` the coancestry of the
#' two parents of cross `c`. The second term is the self-coancestry correction;
#' dropping it biases `theta` downward by `O(1 / D)`.
#'
#' The consequence is that the diversity of the DH pool is a quadratic form in
#' parent usage -- the DH lines never need to be genotyped, or even to exist, to
#' optimise which crosses to make.
#'
#' @param crosses `C x 2` matrix of parent line indices.
#' @param n_per Lines produced per cross, recycled to `C`.
#' @param fL Line coancestry matrix.
#' @param self_term Include the self-coancestry correction.
#' @return A scalar.
#' @family DH identities
#' @export
dh_pool_theta <- function(crosses, n_per, fL, self_term = TRUE) {
  L <- nrow(fL)
  n_per <- rep_len(n_per, nrow(crosses))
  cnt <- numeric(L)
  for (r in seq_len(nrow(crosses)))
    cnt[crosses[r, ]] <- cnt[crosses[r, ]] + n_per[r]
  w <- cnt / sum(cnt)
  D <- sum(n_per)
  th <- as.numeric(crossprod(w, fL %*% w))
  if (self_term) {
    f_c <- fL[cbind(crosses[, 1], crosses[, 2])]
    th <- th + (1 - mean((1 + f_c) / 2)) / D
  }
  th
}

#' Expected genetic variance among doubled haploids from one cross
#'
#' Only loci segregating in the cross contribute, each at a quarter of its
#' squared effect: `sigma^2 = 0.25 sum over k with x_ik != x_jk of beta_k^2`.
#'
#' @param i,j Parent line indices.
#' @param GL Line genotype matrix coded 0/1.
#' @param beta Marker effects.
#' @return A scalar variance.
#' @family DH identities
#' @export
sigma2_dh <- function(i, j, GL, beta) {
  seg <- which(GL[i, ] != GL[j, ])
  0.25 * sum(beta[seg]^2)
}

#' Progeny standard deviation for a set of candidate crosses
#'
#' Vectorised form of [sigma2_dh]. Costs `O(C m)`.
#'
#' @param crosses `C x 2` matrix of parent line indices.
#' @param GL Line genotype matrix coded 0/1.
#' @param beta Marker effects.
#' @return A numeric vector of length `C`.
#' @family DH identities
#' @export
sigma_dh_crosses <- function(crosses, GL, beta) {
  b2 <- beta^2
  vapply(seq_len(nrow(crosses)), function(r)
    sqrt(0.25 * sum(b2[GL[crosses[r, 1], ] != GL[crosses[r, 2], ]])), numeric(1))
}

#' Usefulness criterion
#'
#' `UC = mu + i h sigma` (Schnell & Utz 1975). This applies at the DH stage,
#' where the cross is still segregating. It does **not** apply to hybrid mining:
#' the F1 of two fixed inbreds has zero progeny variance, so the variance term
#' vanishes and only the mean and inter-hybrid complementarity remain.
#'
#' @param mu_cross Expected cross mean.
#' @param sigma_dh Progeny standard deviation, see [sigma_dh_crosses].
#' @param i Selection intensity, see [sel_intensity].
#' @param h Square root of heritability on the unit selected.
#' @return A numeric vector.
#' @export
usefulness_criterion <- function(mu_cross, sigma_dh, i = 1.755, h = 0.6) {
  mu_cross + i * h * sigma_dh
}

#' Selection intensity for a top fraction
#'
#' `i = phi(z) / q` under normality.
#'
#' @param q Selected fraction.
#' @return A scalar.
#' @export
sel_intensity <- function(q) stats::dnorm(stats::qnorm(1 - q)) / q

# Note, verified in the book: modified Rogers distance is a poor proxy for the
# progeny standard deviation once the heterotic pattern is fixed. Within a
# stratum MRD explains only 1-5 percent of the variance in sigma_DH; a pooled
# R^2 near 0.33 is a stratification artefact. Compute sigma_DH from marker
# effects; do not substitute distance for it.

# --- S3. Selecting lines per se ------------------------------------------------

#' Group coancestry of a set of lines
#'
#' The line-level counterpart of [theta_group], taking the coancestry matrix
#' directly rather than a context. The constraint should be applied **within**
#' each pool separately: a pooled constraint lets the optimiser satisfy it by
#' keeping the pools apart while both erode internally.
#'
#' @param idx Integer vector of selected line indices.
#' @param fL Line coancestry matrix.
#' @return A scalar.
#' @export
s3_theta <- function(idx, fL) mean(fL[idx, idx])

#' @rdname s3_theta
#' @export
s3_status_num <- function(idx, fL) 1 / (2 * mean(fL[idx, idx]))

#' Marker alleles retained by a set of lines
#'
#' Counts, out of `2m`, how many marker alleles at least one selected line still
#' carries. See [alleles_retained_fast] for the packed-bitset route.
#'
#' @param idx Integer vector of selected line indices.
#' @param GL Line genotype matrix coded 0/1.
#' @return An integer count.
#' @export
alleles_retained <- function(idx, GL) {
  sub <- GL[idx, , drop = FALSE]
  cs <- colSums(sub); n <- length(idx)
  sum(cs > 0) + sum(cs < n)          # allele 1 present + allele 0 present
}

#' Proportional diversity loss against a same-size resampling baseline
#'
#' Comparing a selected set of `n` against a pool of `L` confounds selection
#' with sample size. The baseline must be a random sample of the same size.
#'
#' @param idx Integer vector of selected line indices.
#' @param fL Line coancestry matrix.
#' @param B Resampling replicates.
#' @param seed Random seed.
#' @return A named numeric vector `GD_selected`, `GD_random_mean`, `loss_pct`,
#'   `percentile`.
#' @export
loss_vs_resampling <- function(idx, fL, B = 200, seed = 1) {
  set.seed(seed); n <- length(idx); L <- nrow(fL)
  gd_sel <- 1 - mean(fL[idx, idx])
  gd_ran <- replicate(B, { s <- sample.int(L, n); 1 - mean(fL[s, s]) })
  c(GD_selected = gd_sel, GD_random_mean = mean(gd_ran),
    loss_pct = 100 * (mean(gd_ran) - gd_sel) / mean(gd_ran),
    percentile = mean(gd_ran < gd_sel))
}

#' Truncate-then-repair line selection under a coancestry ceiling
#'
#' A purely incremental greedy ("add while theta stays below the ceiling")
#' **cannot** be used here and silently returns the empty set. Group coancestry
#' includes the diagonal, so a single line has `theta = 1` and any two lines
#' have `theta = (1 + f_ij) / 2`; a ceiling calibrated on a large pool is
#' unreachable at small set sizes. `theta` falls monotonically as the set grows,
#' so the constraint is only meaningful **at** the target size.
#'
#' This takes the top `n_sel` by merit, then while `theta` exceeds the ceiling
#' swaps out the selected line with the highest mean coancestry to the rest and
#' swaps in the unselected line that most reduces `theta`, breaking ties on
#' merit. Each swap is `O(n_sel)`.
#'
#' @param merit Numeric vector of line merit.
#' @param fL Line coancestry matrix.
#' @param n_sel Number of lines to select.
#' @param theta_max Coancestry ceiling, see [theta_ceiling].
#' @param max_swap Maximum repair swaps.
#' @param merit_weight Weight on merit when breaking ties in the swap.
#' @return A sorted integer vector of selected line indices.
#' @export
select_lines_constrained <- function(merit, fL, n_sel, theta_max = Inf,
                                     max_swap = 5000, merit_weight = 0.25) {
  L <- length(merit)
  stopifnot(n_sel <= L)
  chosen <- order(merit, decreasing = TRUE)[seq_len(n_sel)]
  if (!is.finite(theta_max)) return(chosen)
  mz <- (merit - mean(merit)) / (stats::sd(merit) + 1e-12)
  for (s in seq_len(max_swap)) {
    sub <- fL[chosen, chosen, drop = FALSE]
    if (mean(sub) <= theta_max) break
    contrib <- rowMeans(sub)                       # mean coancestry to the set
    drop_i  <- which.max(contrib - merit_weight * mz[chosen])
    out     <- chosen[drop_i]; keep <- chosen[-drop_i]
    pool_out <- setdiff(seq_len(L), chosen)
    if (!length(pool_out)) break
    gain <- colMeans(fL[keep, pool_out, drop = FALSE]) - merit_weight * mz[pool_out]
    add  <- pool_out[which.min(gain)]
    if (add == out) break
    chosen <- c(keep, add)
  }
  sort(chosen)
}

#' Calibrate a coancestry ceiling against a resampling baseline
#'
#' Allows at most `alpha` proportional loss of gene diversity relative to a
#' random set of the same size. Returns the ceiling to pass to
#' [select_lines_constrained].
#'
#' @param fL Line coancestry matrix.
#' @param n_sel Number of lines to select.
#' @param alpha Acceptable proportional loss.
#' @param B Resampling replicates.
#' @param seed Random seed.
#' @return A scalar coancestry ceiling.
#' @export
theta_ceiling <- function(fL, n_sel, alpha = 0.005, B = 200, seed = 1) {
  set.seed(seed)
  gd_ran <- mean(replicate(B, { s <- sample.int(nrow(fL), n_sel); 1 - mean(fL[s, s]) }))
  1 - gd_ran * (1 - alpha)
}

# --- S4. Hybrid mining ---------------------------------------------------------

#' Hybrid group coancestry from the line-usage vector
#'
#' `theta_hyb = (u' fL u) / (2n)^2` with `u` the count of selected hybrids using
#' each line. The hybrid-by-hybrid matrix is never needed: cost drops from
#' `O(n^2)` with an `N x N` matrix to `O(L^2)` with no hybrid matrix at all.
#'
#' @param u Integer line-usage count vector, see [line_usage].
#' @param fL Line coancestry matrix.
#' @return A scalar.
#' @export
hybrid_theta_from_usage <- function(u, fL) {
  s <- sum(u); as.numeric(crossprod(u, fL %*% u)) / (s * s)
}

#' Line usage counts from a hybrid selection
#'
#' @param idx Integer vector of selected hybrid indices.
#' @param parents `N x 2` integer matrix of parent line indices.
#' @param L Number of lines.
#' @return An integer vector of length `L`.
#' @export
line_usage <- function(idx, parents, L) {
  tabulate(as.vector(parents[idx, , drop = FALSE]), nbins = L)
}

#' Pool balance of a hybrid set
#'
#' The share of parent slots drawn from each pool. Held near 0.5 so one pool
#' cannot be mined while the other stagnates.
#'
#' @param idx Integer vector of selected hybrid indices.
#' @param parents `N x 2` integer matrix of parent line indices.
#' @param pool Vector of pool labels, one per line.
#' @return A numeric vector of shares.
#' @export
pool_balance <- function(idx, parents, pool) {
  pr <- pool[as.vector(parents[idx, , drop = FALSE])]
  tb <- table(factor(pr, levels = unique(pool)))
  as.vector(tb) / sum(tb)
}

# --- Cross-stage: the loss ledger ---------------------------------------------

#' Diversity loss ledger across stages
#'
#' Loss per stage on one common scale -- proportional loss of gene diversity
#' relative to that stage's own same-size resampling baseline -- so the stages
#' can be compared and a budget allocated across them.
#'
#' @param entries A named list; each element a list with `n_in`, `n_out`,
#'   `gd_before`, `gd_after`.
#' @return A data frame with `loss_pct` and `share_of_total` per stage.
#' @export
loss_ledger <- function(entries) {
  out <- do.call(rbind, lapply(names(entries), function(nm) {
    e <- entries[[nm]]
    data.frame(stage = nm, n_in = e$n_in, n_out = e$n_out,
               GD_before = e$gd_before, GD_after = e$gd_after,
               loss_pct = 100 * (e$gd_before - e$gd_after) / e$gd_before)
  }))
  out$share_of_total <- 100 * out$loss_pct / sum(out$loss_pct)
  out
}
