## R/pipeline_metrics.R --------------------------------------------------------
## Diversity metrics for the four stages of a maize hybrid pipeline.
##
##   S1  heterotic-group conservation      (pool-level monitoring)
##   S2  parent selection for DH induction (cross-level)
##   S3  line-per-se selection             (line-level)
##   S4  hybrid mining                     (cross-level, F1 of fixed lines)
##
## Genotype convention throughout: inbred lines are coded {0,1} at m biallelic
## markers (L x m matrix GL); a line is homozygous, so the within-individual
## reference-allele frequency equals the genotype code. Hybrids are the F1 of
## two lines and take code {0, 0.5, 1}.
##
## Companion: R/fast_metrics.R (inner-loop routes) and R/00_sim_ref.R (oracles).
## Every identity implemented here is verified numerically in the report.

## =============================================================================
## 0. Core kernel: molecular (IBS) coancestry
## =============================================================================
## f_ij = probability that an allele drawn at random from i is identical in
## state to one drawn at random from j (Nejati-Javaremi et al. 1997;
## Caballero & Toro 2002). For {0,1} inbred coding this reduces to
##   f_ij = 1 - (1/m) * sum_k (x_ik - x_jk)^2 = 1 - MRD_ij^2
## i.e. molecular coancestry and squared modified Rogers distance are the same
## statistic. See coancestry_from_mrd() below.
coancestry_ibs <- function(X) {
  m <- ncol(X); n <- nrow(X); s <- rowSums(X)
  (2 * tcrossprod(X) - outer(s, rep(1, n)) - outer(rep(1, n), s) + m) / m
}

## Modified Rogers distance (Wright 1978; Goodman & Stuber 1983 usage in maize).
## For inbred lines MRD_ij = sqrt(mean((x_i - x_j)^2)).
mrd_matrix <- function(GL) {
  sqrt(pmax(0, 1 - coancestry_ibs(GL)))
}
coancestry_from_mrd <- function(D) 1 - D^2

## Group coancestry of a set (Cockerham 1967; Caballero & Toro 2000):
## theta = mean of the full f submatrix INCLUDING the diagonal. Gene diversity
## GD = 1 - theta; status number Ns = 1/(2 theta).
group_coancestry <- function(f_sub) mean(f_sub)
gene_diversity   <- function(f_sub) 1 - mean(f_sub)
status_number    <- function(f_sub) 1 / (2 * mean(f_sub))

## =============================================================================
## S1. Heterotic-group conservation
## =============================================================================
## Diversity in a hybrid programme is TWO objects that move in opposite
## directions: within-pool diversity (erodes under selection) and between-pool
## divergence (inflates). A single pool-wide statistic cannot express both.
##
## Decomposition, exact for any partition (verified to 0 error):
##   theta_T = sum_p w_p^2 theta_pp + sum_{p != q} w_p w_q theta_pq
##
## WARNING -- two incompatible F_ST definitions are both in common use and can
## differ by ~2x on identical data:
##   Wright/Nei-style, reference = between-pool coancestry:
##       F_ST^(W) = (theta_w - theta_B) / (1 - theta_B)
##   Nei's G_ST, reference = total (pooled-frequency) coancestry:
##       G_ST     = (theta_w - theta_T) / (1 - theta_T)   == (H_T - H_S)/H_T
## Because theta_T > theta_B whenever pools differ, G_ST < F_ST^(W) always.
## Report which one you used. Both are returned here.
theta_decompose <- function(GL, pool, f = NULL) {
  if (is.null(f)) f <- coancestry_ibs(GL)
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

## Nei's G_ST computed the classical way, from allele frequencies. Included so a
## user can confirm the identity G_ST == (theta_w - theta_T)/(1 - theta_T).
gst_nei <- function(GL, pool) {
  pool <- as.factor(pool)
  P  <- do.call(rbind, lapply(levels(pool), function(l) colMeans(GL[pool == l, , drop = FALSE])))
  w  <- as.vector(table(pool)) / length(pool)
  Hs <- sum(w * rowMeans(2 * P * (1 - P)))
  pT <- as.vector(w %*% P); Ht <- mean(2 * pT * (1 - pT))
  c(Hs = Hs, Ht = Ht, Gst = (Ht - Hs) / Ht)
}

## Between-pool complementarity at the ALLELE level: the fraction of markers at
## which the pools are near-fixed for opposite alleles. This is the quantity
## that actually generates heterosis under a dominance model, and unlike F_ST it
## does not keep rising as the pools drift apart at already-divergent loci.
pool_complementarity <- function(GL, pool, thr = 0.9) {
  pool <- as.factor(pool); lv <- levels(pool)
  stopifnot(length(lv) == 2)
  p1 <- colMeans(GL[pool == lv[1], , drop = FALSE])
  p2 <- colMeans(GL[pool == lv[2], , drop = FALSE])
  c(frac_opposite_fixed = mean((p1 > thr & p2 < 1 - thr) | (p1 < 1 - thr & p2 > thr)),
    frac_fixed_same     = mean((p1 > thr & p2 > thr) | (p1 < 1 - thr & p2 < 1 - thr)),
    mean_abs_delta_p    = mean(abs(p1 - p2)))
}

## Monitoring panel for one cycle: the numbers to log every cycle and plot as a
## time series. Within-pool GD should be defended; F_ST should be held in a BAND.
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

## =============================================================================
## S2. Choosing parents / crosses for DH induction
## =============================================================================
## Three exact identities for a DH family from cross (i, j) of two inbreds.
## Each DH inherits each locus from i or j with probability 1/2, then doubles.
##
##  (a) coancestry between two DH sibs of the same family:
##          E[f] = (1 + f_ij) / 2
##  (b) coancestry between DH from family (i,j) and DH from family (k,l):
##          E[f] = (f_ik + f_il + f_jk + f_jl) / 4
##  (c) group coancestry of a DH pool built from crosses c = 1..C, each
##      contributing n_c lines (D = sum n_c in total):
##          theta_pool = w' F_L w + (1/D) * (1 - mean_c[(1 + f_c)/2])
##      where w is the PARENT-USAGE weight vector over the L candidate lines
##      (each cross donates half its lines' alleles to each parent) and f_c is
##      the coancestry of the two parents of cross c. The second term is the
##      self-coancestry correction; dropping it biases theta downward by O(1/D).
##
## Consequence: the diversity of the DH pool is a QUADRATIC FORM IN PARENT USAGE.
## The DH lines never need to be genotyped -- or even to exist -- to optimise
## which crosses to make.
dh_sib_coancestry   <- function(f_ij) (1 + f_ij) / 2
dh_cross_coancestry <- function(fL, i, j, k, l) mean(fL[c(i, j), c(k, l)])

## theta of a planned DH pool, from the crossing plan only.
## crosses: C x 2 matrix of line indices; n_per: lines produced per cross.
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

## Expected genetic variance among DH from cross (i,j) under an additive model.
## Only loci SEGREGATING in the cross contribute, each at 1/4 of its squared
## effect (the DH doubling gives a variance of 1 per unit effect at a segregating
## locus, halved twice by the 1/2 inheritance probability):
##      sigma^2_DH(i,j) = (1/4) * sum_{k : x_ik != x_jk} beta_k^2
## Verified against 3000 simulated DH per family (ratios 0.96-1.01).
sigma2_dh <- function(i, j, GL, beta) {
  seg <- which(GL[i, ] != GL[j, ])
  0.25 * sum(beta[seg]^2)
}
## Vectorised over a set of candidate crosses. O(C*m); the loop is the cost.
sigma_dh_crosses <- function(crosses, GL, beta) {
  b2 <- beta^2
  vapply(seq_len(nrow(crosses)), function(r)
    sqrt(0.25 * sum(b2[GL[crosses[r, 1], ] != GL[crosses[r, 2], ]])), numeric(1))
}

## Usefulness criterion (Schnell & Utz 1975): UC = mu + i * h * sigma_DH.
## This is the stage where UC APPLIES -- the cross is still segregating. It does
## NOT apply at S4, where the F1 of two fixed inbreds has zero progeny variance.
## i = selection intensity, h = square root of heritability on the unit selected.
usefulness_criterion <- function(mu_cross, sigma_dh, i = 1.755, h = 0.6) {
  mu_cross + i * h * sigma_dh
}
## i for the top q fraction under normality (i = phi(z)/q).
sel_intensity <- function(q) dnorm(qnorm(1 - q)) / q

## WARNING, verified in the report: modified Rogers distance is a POOR proxy for
## sigma_DH once the heterotic pattern is fixed. Within a stratum, MRD explained
## 1-5% of the variance in sigma_DH here; the apparent R^2 = 0.33 in a pooled
## analysis is a stratification artifact. Compute sigma_DH from marker effects;
## do not substitute distance for it.

## =============================================================================
## S3. Selecting lines per se
## =============================================================================
## Here the unit is the line, the metric set is the one benchmarked in the
## companion report, and the constraint is applied WITHIN each pool separately
## (a pooled constraint would let the optimiser satisfy it by keeping the pools
## apart while both erode internally).
s3_theta      <- function(idx, fL) mean(fL[idx, idx])
s3_status_num <- function(idx, fL) 1 / (2 * mean(fL[idx, idx]))

## Effective number of founders/parents behind a selected set, from a usage
## vector: Ne = (sum c)^2 / sum c^2. Free once counts are formed.
effective_number <- function(cnt) { s <- sum(cnt); s * s / sum(cnt * cnt) }

## Allelic richness of a selected line set: number of marker alleles still
## present. Bitset route; see R/fast_metrics.R for the packed version.
alleles_retained <- function(idx, GL) {
  sub <- GL[idx, , drop = FALSE]
  cs <- colSums(sub); n <- length(idx)
  sum(cs > 0) + sum(cs < n)          # allele 1 present + allele 0 present
}

## Proportional diversity loss against the correct baseline: a SAME-SIZE random
## sample of the candidate pool, not the whole pool. Comparing a selected set of
## n against a pool of L confounds selection with sample size.
loss_vs_resampling <- function(idx, fL, B = 200, seed = 1) {
  set.seed(seed); n <- length(idx); L <- nrow(fL)
  gd_sel <- 1 - mean(fL[idx, idx])
  gd_ran <- replicate(B, { s <- sample.int(L, n); 1 - mean(fL[s, s]) })
  c(GD_selected = gd_sel, GD_random_mean = mean(gd_ran),
    loss_pct = 100 * (mean(gd_ran) - gd_sel) / mean(gd_ran),
    percentile = mean(gd_ran < gd_sel))
}

## Truncate-then-repair selection under a group-coancestry ceiling.
##
## NOTE -- a purely incremental greedy ("add while theta <= ceiling") CANNOT be
## used here and silently returns the empty set. Group coancestry includes the
## diagonal, so a single line has theta = 1 and any two lines have theta =
## (1 + f_ij)/2; a ceiling calibrated on a large pool is unreachable at small
## set sizes. theta falls monotonically as the set grows, so the constraint is
## only meaningful AT the target size n_sel.
##
## Algorithm: take the top n_sel by merit, then while theta exceeds the ceiling,
## swap out the selected line with the highest mean coancestry to the rest and
## swap in the unselected line that most reduces theta, breaking ties on merit.
## Each swap is O(n_sel); the loop is bounded by max_swap.
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

## Calibrate the ceiling against a same-size resampling baseline: allow at most
## `alpha` proportional loss of gene diversity relative to a random set of the
## same size. Returns the theta ceiling to pass to select_lines_constrained().
theta_ceiling <- function(fL, n_sel, alpha = 0.005, B = 200, seed = 1) {
  set.seed(seed)
  gd_ran <- mean(replicate(B, { s <- sample.int(nrow(fL), n_sel); 1 - mean(fL[s, s]) }))
  1 - gd_ran * (1 - alpha)
}

## =============================================================================
## S4. Hybrid mining
## =============================================================================
## For F1 hybrids of homozygous lines the hybrid-by-hybrid coancestry matrix is
## never needed. With u the line-usage COUNT vector over the n selected hybrids
## (u_k = number of selected hybrids using line k, sum u = 2n):
##      theta_hyb = (u' F_L u) / (2n)^2
## This is the collapse derived and verified in the companion report: cost drops
## from O(n^2) with an N x N matrix to O(L^2) with no hybrid matrix at all.
hybrid_theta_from_usage <- function(u, fL) {
  s <- sum(u); as.numeric(crossprod(u, fL %*% u)) / (s * s)
}
line_usage <- function(idx, parents, L) tabulate(as.vector(parents[idx, , drop = FALSE]), nbins = L)

## Pool balance of a hybrid set: share of parent slots drawn from each pool.
## Held near 0.5 so one pool cannot be mined while the other stagnates.
pool_balance <- function(idx, parents, pool) {
  pr <- pool[as.vector(parents[idx, , drop = FALSE])]
  tb <- table(factor(pr, levels = unique(pool)))
  as.vector(tb) / sum(tb)
}

## Expected heterozygosity of the hybrid set == its gene diversity, and for
## hybrids of fixed lines it is exactly 1 - theta_hyb. No separate computation.
hybrid_He <- function(u, fL) 1 - hybrid_theta_from_usage(u, fL)

## =============================================================================
## Cross-stage: the loss ledger
## =============================================================================
## Diversity lost per stage, all on the same scale (proportional loss of gene
## diversity relative to the stage's own same-size resampling baseline), so the
## stages can be compared and a budget allocated across them.
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
