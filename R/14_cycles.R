# Recurrent selection across cycles.
#
# Everything else in this package answers "which hybrids should I plant this
# year". This file answers "and what has that done to the programme by year
# ten", which is the only question that can justify paying an index cost for
# diversity in the first place.
#
# The loop is reciprocal recurrent selection, and the direction of the arrows
# matters. Hybrids are selected at the hybrid level, but lines are recycled
# WITHIN pool: a doubled haploid taken from an A x B F1 is a blend of both
# pools and would destroy the heterotic pattern the whole book is trying to
# protect. What crosses the pool boundary is information -- which lines proved
# themselves in hybrid combination -- and never germplasm.

#' Next generation of one pool, by weighted intermating and DH derivation
#'
#' Parents are drawn from `GL_pool` with probability proportional to `w`, paired
#' at random, and one doubled haploid is derived per pair. The lines are inbred,
#' so `(GL[i, ] + GL[j, ]) / 2` is 0, 0.5 or 1, and a single Bernoulli draw
#' per locus is an exact DH gamete under free recombination. A pair that draws
#' the same line twice returns that line, which is correct: selfing an inbred
#' reproduces it.
#'
#' @param GL_pool Line matrix for one pool, `n x m`, coded 0/1.
#' @param w Usage weights, length `nrow(GL_pool)`, need not sum to 1.
#' @param n_out Number of lines to produce.
#' @return A matrix `n_out x m`, coded 0/1.
#' @seealso [run_cycles], which calls this once per pool per cycle.
#' @export
next_pool <- function(GL_pool, w, n_out) {
  # ponytail: loci are unlinked, so no LD builds up and there is no Bulmer
  # effect on the genic side. Use build_map()/meiosis() from R/06_f2size.R if
  # linkage ever has to matter.
  n <- nrow(GL_pool)
  m <- ncol(GL_pool)
  if (all(w == 0)) w <- rep(1, n)
  mo <- sample.int(n, n_out, replace = TRUE, prob = w)
  fa <- sample.int(n, n_out, replace = TRUE, prob = w)
  out <- matrix(0L, n_out, m)
  for (i in seq_len(n_out)) {
    out[i, ] <- stats::rbinom(m, 1, (GL_pool[mo[i], ] + GL_pool[fa[i], ]) / 2)
  }
  out
}

# Build the per-cycle ctx from the current lines, with p0 supplied rather than
# recomputed. build_ctx() sets p0 <- colMeans(X) on every call, which would
# re-anchor the drift lens each cycle and report no loss forever.
cycle_ctx <- function(GL, pool, beta, p0, centre, scale_) {
  n_A <- sum(pool == "A")
  n_B <- sum(pool == "B")
  ped <- expand.grid(a = seq_len(n_A), b = n_A + seq_len(n_B))
  X   <- (GL[ped$a, , drop = FALSE] + GL[ped$b, , drop = FALSE]) / 2
  gv  <- as.vector(X %*% beta)
  ctx <- build_ctx(X = X, f = molecular_coancestry(X), G = NULL,
                   traits = matrix(gv, ncol = 1), ped = ped,
                   n_lines = nrow(GL), pool = pool,
                   fL = molecular_coancestry(GL), cfg = NULL)
  ctx$GL <- GL
  ctx$gv <- gv
  # The index is the true genetic value on the founding cycle's scale, so that
  # gain accumulates instead of being standardised away each cycle.
  ctx$index   <- (gv - centre) / scale_
  ctx$p0      <- p0
  ctx$maf_pop <- pmin(p0, 1 - p0)
  ctx
}

#' Run recurrent hybrid selection for several cycles
#'
#' One cycle is: form every A x B hybrid, select `n_sel` of them under a gene
#' diversity budget, read off how much each parent line was used, and rebuild
#' each pool by intermating its own lines in proportion to that usage. Marker
#' effects, and the base frequencies `p0` that anchor `F_hom` and `F_drift`, are
#' fixed at cycle 0 and carried forward unchanged.
#'
#' @param n_A,n_B Lines per pool, held constant across cycles.
#' @param m Markers.
#' @param n_cycles Number of cycles to run after the founding one.
#' @param n_sel Hybrids selected per cycle.
#' @param alpha_max Diversity budget. `Inf` leaves the selection unconstrained.
#' @param n_qtl,fst,h2 Passed to [simulate_pools] for the founding population.
#' @param max_use Optional per-line usage cap, passed to the selector.
#' @param selector Selection function of `(ctx, n_sel, alpha_max, gd_ref,
#'   max_use)` returning indices. Defaults to a greedy sweep, which is cheap and
#'   enough to establish a trend; pass a `sel_de` wrapper to confirm one.
#' @param inject Optional `list(cycle =, n =)`: at that cycle, replace `n` lines
#'   of each pool with lines drawn from the founding generation.
#' @param B_null Resampling replicates for the per-cycle random baseline.
#' @param seed Seed for the founding population and the recycling draws.
#' @return A data frame, one row per cycle, with the realised index (on the
#'   founding cycle's scale), gene diversity, the realised `alpha`, both
#'   inbreeding lenses against the frozen `p0`, the pool partition, the maximum
#'   line usage, and the candidate pool's realised (`var_g`) and genic
#'   (`var_genic`) variance. The gap between the last two is the disequilibrium
#'   term of [genic_var]; see the note on assumption C1 in the book, which the
#'   two columns exist to test rather than to assume.
#' @seealso [next_pool] for the recycling step, [line_weights] for the usage
#'   vector that drives it.
#' @export
run_cycles <- function(n_A = 25, n_B = 25, m = 2000, n_cycles = 10, n_sel = 60,
                       alpha_max = 0.01, n_qtl = 300, fst = 0.15, h2 = 0.5,
                       max_use = NULL, selector = NULL, inject = NULL,
                       B_null = 200, seed = 1) {
  if (is.null(selector)) {
    selector <- function(ctx, n_sel, alpha_max, gd_ref, max_use) {
      sel_greedy_budget(ctx, n_sel, alpha_max, gd_ref, max_use)
    }
  }
  sim  <- simulate_pools(n_A = n_A, n_B = n_B, m = m, fst = fst,
                         n_qtl = n_qtl, h2 = h2, seed = seed)
  pool <- sim$pool
  beta <- sim$beta
  GL   <- sim$GL
  GL0  <- GL                                  # the founding lines, for injection
  p0   <- colMeans(sim$X)                     # frozen here, and never again
  gv0  <- as.vector(sim$X %*% beta)
  centre <- mean(gv0)
  scale_ <- stats::sd(gv0)

  set.seed(seed + 1000)
  out <- vector("list", n_cycles + 1L)
  for (t in 0:n_cycles) {
    ctx <- cycle_ctx(GL, pool, beta, p0, centre, scale_)
    nl  <- null_distribution(ctx, n_sel, B = B_null, B_full = 5)
    gd_ref <- nl$gd_ref
    # null_distribution() reseeds; restore a stream that advances with the cycle
    # so the recycling draws are not identical every time.
    set.seed(seed + 1000 + t)

    idx <- selector(ctx, n_sel, alpha_max, gd_ref, max_use)
    fm  <- freq_metrics(idx, ctx)
    gp  <- gd_partition(idx, ctx)
    tp  <- theta_pools(idx, ctx)

    out[[t + 1L]] <- data.frame(
      cycle = t,
      index = mean(ctx$index[idx]),
      GD = gene_diversity(idx, ctx),
      GD_pool = gene_diversity(seq_len(ctx$N), ctx),
      gd_ref = gd_ref,
      alpha = (gd_ref - gene_diversity(idx, ctx)) / gd_ref,
      theta = theta_group(idx, ctx),
      F_hom = fm[["F_hom"]], F_drift = fm[["F_drift"]],
      GD_BS = gp[["GD_BS"]], GD_T = gp[["GD_T"]],
      theta_A = tp[["theta_A"]], theta_B = tp[["theta_B"]],
      Ns = status_number(idx, ctx),
      max_line = max_line_use(idx, ctx),
      # Both on the index scale, so they are comparable to `index` above. Their
      # difference is the gametic-phase disequilibrium among the candidates,
      # which no allele-frequency metric in this data frame can see.
      var_g = stats::var(ctx$index),
      var_genic = genic_var(ctx$X, beta / scale_),
      row.names = NULL)

    if (t == n_cycles) break

    w  <- line_weights(idx, ctx)
    iA <- which(pool == "A")
    iB <- which(pool == "B")
    nA <- next_pool(GL[iA, , drop = FALSE], w$A[iA], length(iA))
    nB <- next_pool(GL[iB, , drop = FALSE], w$B[iB], length(iB))

    if (!is.null(inject) && identical(t + 1L, as.integer(inject$cycle))) {
      k <- seq_len(inject$n)
      nA[k, ] <- GL0[sample(iA, inject$n), , drop = FALSE]
      nB[k, ] <- GL0[sample(iB, inject$n), , drop = FALSE]
    }
    GL <- rbind(nA, nB)
  }
  do.call(rbind, out)
}

#' Greedy selection that meets a diversity budget
#'
#' [sel_greedy] trades index against coancestry through a weight `w`, not
#' against a budget. This sweeps `w` and returns the highest-index selection
#' whose realised loss is inside `alpha_max`, which is what a cycle loop needs.
#'
#' @inheritParams sel_greedy
#' @param alpha_max Diversity budget; `Inf` reduces this to plain truncation.
#' @param gd_ref Random-subset reference diversity.
#' @return Integer indices.
#' @export
sel_greedy_budget <- function(ctx, n_sel, alpha_max, gd_ref, max_use = NULL) {
  if (!is.finite(alpha_max)) {
    return(if (is.null(max_use)) sel_truncation(ctx, n_sel)
           else sel_greedy(ctx, n_sel, w = 1e6, max_use = max_use))
  }
  # A log grid, not a linear one. Where the frontier bends depends on the ratio
  # between the index scale and the (much smaller) spread of theta, which shifts
  # from cycle to cycle as diversity erodes. A coarse linear grid steps straight
  # over the interesting region and returns either truncation or w = 0.
  ws <- c(1e6, rev(10^seq(-5, 1, length.out = 40)), 0)
  best <- NULL
  best_index <- -Inf
  for (w in ws) {
    s <- sel_greedy(ctx, n_sel, w = w, max_use = max_use)
    if (length(s) < n_sel) next
    a <- (gd_ref - gene_diversity(s, ctx)) / gd_ref
    if (a <= alpha_max) {
      mi <- mean(ctx$index[s])
      if (mi > best_index) { best_index <- mi; best <- s }
    }
  }
  # Nothing met the budget: return the most diverse plan available.
  if (is.null(best)) best <- sel_greedy(ctx, n_sel, w = 0, max_use = max_use)
  best
}
