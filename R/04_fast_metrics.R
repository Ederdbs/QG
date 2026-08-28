# Fast routes for the metrics that run inside the differential-evolution loop.
#
# Central identity (derived and verified to machine precision in the book's
# "Choosing metrics" chapter): for F1 hybrids of homozygous lines, with
# hybrid i = (a, b) and hybrid j = (c, d),
#
#     f_ij = (fL_ac + fL_ad + fL_bc + fL_bd) / 4                      (exact)
#
# so for any selected set S of n hybrids, with line-usage frequencies
# w_a = (times line a is a parent in S) / (2n),
#
#     theta_S = w' fL w        and        pbar_k = (w' GL)_k          (exact)
#
# The N x N hybrid coancestry matrix is therefore NEVER needed: every
# frequency-based diversity metric of a hybrid set is a function of the
# line-usage vector w and the L x L line coancestry matrix fL. That removes an
# O(N^2) memory wall and is what makes production scale feasible.

#' Augment a context with the line-level fast route
#'
#' The fast metrics need the pedigree as an `N x 2` integer matrix and,
#' optionally, the line genotype matrix. This adds them to an existing `ctx`.
#'
#' @param ctx Evaluation context, see [build_ctx].
#' @param GL Optional `L x m` line genotype matrix coded 0/1, needed only
#'   for the allelic metrics.
#' @param pack Also build the packed bitset used by [alleles_retained_fast].
#'   Requires `GL`.
#' @return The context with `parents`, and optionally `GL` and `bits`, added.
#' @export
fast_ctx <- function(ctx, GL = NULL, pack = FALSE) {
  ctx$parents <- cbind(as.integer(ctx$ped$a), as.integer(ctx$ped$b))
  if (!is.null(GL)) {
    ctx$GL <- GL
    if (pack) ctx$bits <- pack_lines(GL)
  }
  ctx
}

# --- 1. Line-usage vector: the single sufficient statistic --------------------

#' Parent line counts induced by a selection
#'
#' `O(n)`. This integer vector is the sufficient statistic every fast metric
#' below is built on.
#'
#' @param idx Integer vector of selected hybrid indices.
#' @param ctx Context augmented by [fast_ctx].
#' @return An integer vector of length `ctx$n_lines`.
#' @family fast metrics
#' @export
line_counts <- function(idx, ctx) {
  tabulate(ctx$parents[idx, , drop = FALSE], nbins = ctx$n_lines)
}

#' Line usage frequencies
#'
#' [line_counts] normalised to sum to 1, pooling both parents. Contrast with
#' [line_weights], which keeps the two heterotic pools separate.
#'
#' @inheritParams line_counts
#' @return A numeric vector of length `ctx$n_lines` summing to 1.
#' @family fast metrics
#' @export
line_usage_freq <- function(idx, ctx) {
  cnt <- line_counts(idx, ctx)
  cnt / sum(cnt)
}

# --- 2. Group coancestry: the inner-loop metric -------------------------------

#' Group coancestry by the line route
#'
#' `theta = w' fL w`, restricted to the lines actually used. Costs
#' `O(n + Lu^2)` with `Lu` the number of distinct lines used -- independent of
#' both `N` and `m`. Identical to [theta_group] to machine precision.
#'
#' @inheritParams line_counts
#' @return A scalar in `[0, 1]`.
#' @family fast metrics
#' @export
fast_theta <- function(idx, ctx) {
  cnt <- line_counts(idx, ctx)
  u   <- which(cnt > 0L)                       # restrict to used lines
  cu  <- cnt[u]
  s   <- sum(cu)
  as.numeric(crossprod(cu, ctx$fL[u, u, drop = FALSE] %*% cu)) / (s * s)
}

#' @rdname fast_theta
#' @export
fast_gene_div <- function(idx, ctx) 1 - fast_theta(idx, ctx)

#' @rdname fast_theta
#' @export
fast_status_num <- function(idx, ctx) 1 / (2 * fast_theta(idx, ctx))

#' Precompiled group-coancestry function
#'
#' Hoists `fL` and the pedigree out of the closure, for when the same context
#' is reused across roughly 1e6 evaluations.
#'
#' @param ctx Context augmented by [fast_ctx].
#' @return A function of `idx` returning group coancestry.
#' @family fast metrics
#' @export
make_theta_fun <- function(ctx) {
  fL <- ctx$fL; par <- ctx$parents; L <- ctx$n_lines
  function(idx) {
    cnt <- tabulate(par[idx, , drop = FALSE], nbins = L)
    u <- which(cnt > 0L); cu <- cnt[u]; s <- sum(cu)
    as.numeric(crossprod(cu, fL[u, u, drop = FALSE] %*% cu)) / (s * s)
  }
}

# --- 3. Incremental swap update ------------------------------------------------

#' Coancestry state for incremental swap updates
#'
#' Carries the count vector `cnt` and `v = fL %*% cnt`, so that swapping one
#' hybrid costs `O(L)` instead of a full recomputation.
#'
#' @inheritParams line_counts
#' @return A list with `cnt`, `v`, `s` and `theta`.
#' @seealso [theta_swap]
#' @family fast metrics
#' @export
theta_state <- function(idx, ctx) {
  cnt <- line_counts(idx, ctx)
  v   <- as.vector(ctx$fL %*% cnt)
  list(cnt = cnt, v = v, s = sum(cnt),
       theta = sum(cnt * v) / sum(cnt)^2)
}

#' Swap one hybrid and update the coancestry state
#'
#' A swap changes at most four entries of the count vector, so this is four
#' rank-1 column updates: `O(L)`.
#'
#' @param st State from [theta_state].
#' @param out_h Index of the hybrid leaving the selection.
#' @param in_h Index of the hybrid entering the selection.
#' @param ctx Context augmented by [fast_ctx].
#' @return The updated state.
#' @family fast metrics
#' @export
theta_swap <- function(st, out_h, in_h, ctx) {
  cnt <- st$cnt; v <- st$v
  po <- ctx$parents[out_h, ]; pi_ <- ctx$parents[in_h, ]
  for (a in po) { cnt[a] <- cnt[a] - 1L; v <- v - ctx$fL[, a] }
  for (a in pi_) { cnt[a] <- cnt[a] + 1L; v <- v + ctx$fL[, a] }
  s <- st$s                                     # n unchanged => s unchanged
  list(cnt = cnt, v = v, s = s, theta = sum(cnt * v) / (s * s))
}

# --- 4. Effective number of parents -------------------------------------------

#' Effective number of parent lines, fast route
#'
#' Free inside the loop: it shares the count vector with [fast_theta].
#'
#' @inheritParams line_counts
#' @return A scalar.
#' @family fast metrics
#' @export
fast_ne_parents <- function(idx, ctx) {
  cnt <- line_counts(idx, ctx)
  s <- sum(cnt)
  (s * s) / sum(cnt * cnt)
}

#' Effective number of parents from a count vector
#'
#' @param cnt Integer vector of line counts, see [line_counts].
#' @return A scalar.
#' @family fast metrics
#' @export
ne_parents_from_counts <- function(cnt) { s <- sum(cnt); (s * s) / sum(cnt * cnt) }

# --- 5. Selection allele frequencies from the line matrix ----------------------

#' Selection allele frequencies from the line genotype matrix
#'
#' `pbar = w' GL`, exactly. Costs `O(Lu m)` instead of `O(n m)`: a win whenever
#' fewer distinct lines are used than hybrids selected, which is the normal
#' case in a factorial hybrid design.
#'
#' @inheritParams line_counts
#' @return A numeric vector of length `m`.
#' @family fast metrics
#' @export
fast_pbar <- function(idx, ctx) {
  cnt <- line_counts(idx, ctx)
  u <- which(cnt > 0L)
  as.vector(crossprod(cnt[u], ctx$GL[u, , drop = FALSE])) / sum(cnt)
}

#' @rdname fast_pbar
#' @export
fast_he_nei <- function(idx, ctx) { p <- fast_pbar(idx, ctx); mean(2 * p * (1 - p)) }

#' @rdname fast_pbar
#' @param thr Minor allele frequency threshold below which a marker counts as
#'   lost.
#' @export
fast_alleles_lost <- function(idx, ctx, thr = 0.05) {
  p <- fast_pbar(idx, ctx); maf <- pmin(p, 1 - p)
  sum(maf < thr & ctx$maf_pop >= thr)
}

# --- 6. Allelic richness by bitset --------------------------------------------
#
# An allele is RETAINED iff at least one used line carries it. That is a
# bitwise OR across the used lines' packed genotype rows. Packing markers into
# integers makes this far less work than a numeric colMeans.
#
# NOTE: R integers are SIGNED 32-bit. bitwShiftL(1L, 31L) is NA, so we pack 31
# bits per word.

#' Bits packed per word by [pack_lines]
#' @export
BITS_PER_WORD <- 31L

#' Pack a line genotype matrix into bitsets
#'
#' Produces one bitset per line for the reference allele and one for the
#' alternative allele, 31 markers per integer word.
#'
#' @param GL `L x m` line genotype matrix coded 0/1.
#' @return A list with integer matrices `ref` and `alt`, plus `nw` (words) and
#'   `m` (markers).
#' @family fast metrics
#' @export
pack_lines <- function(GL) {
  L <- nrow(GL); m <- ncol(GL); W <- BITS_PER_WORD
  nw <- as.integer(ceiling(m / W))
  ref <- matrix(0L, L, nw)     # bit set where line carries the reference allele
  alt <- matrix(0L, L, nw)     # bit set where line carries the alternative allele
  for (w in seq_len(nw)) {
    lo <- (w - 1L) * W + 1L; hi <- min(w * W, m)
    for (k in lo:hi) {
      bit <- bitwShiftL(1L, k - lo)
      g <- GL[, k]
      ref[g == 1L, w] <- bitwOr(ref[g == 1L, w], bit)
      alt[g == 0L, w] <- bitwOr(alt[g == 0L, w], bit)
    }
  }
  list(ref = ref, alt = alt, nw = nw, m = m)
}

#' Population count of set bits
#'
#' Branch-free SWAR popcount for non-negative 31-bit integers. No lookup table,
#' and vectorised over `x`.
#'
#' @param x Integer vector, non-negative, at most 31 significant bits.
#' @return An integer vector of set-bit counts.
#' @family fast metrics
#' @export
popcount32 <- function(x) {
  x <- x - bitwAnd(bitwShiftR(x, 1L), 1431655765L)          # 0x55555555
  x <- bitwAnd(x, 858993459L) + bitwAnd(bitwShiftR(x, 2L), 858993459L)  # 0x33333333
  x <- bitwAnd(x + bitwShiftR(x, 4L), 252645135L)           # 0x0F0F0F0F
  bitwAnd(x, 255L) + bitwAnd(bitwShiftR(x, 8L), 255L) +
    bitwAnd(bitwShiftR(x, 16L), 255L) + bitwAnd(bitwShiftR(x, 24L), 255L)
}

#' Marker alleles still segregating in a selection
#'
#' Counts, out of `2m`, how many marker alleles at least one selected line
#' still carries. Column-wise OR over the packed bitsets.
#'
#' @inheritParams line_counts
#' @param bits Packed bitsets from [pack_lines].
#' @return An integer count.
#' @family fast metrics
#' @export
alleles_retained_fast <- function(idx, ctx, bits = ctx$bits) {
  cnt <- line_counts(idx, ctx); u <- which(cnt > 0L)
  R <- bits$ref[u, , drop = FALSE]; A <- bits$alt[u, , drop = FALSE]
  oR <- R[1, ]; oA <- A[1, ]
  if (nrow(R) > 1L) for (i in 2:nrow(R)) { oR <- bitwOr(oR, R[i, ]); oA <- bitwOr(oA, A[i, ]) }
  sum(popcount32(oR)) + sum(popcount32(oA))
}

# --- 7. Pool decomposition from the same count vector -------------------------

#' Pool coancestries from the line count vector
#'
#' The fast-route counterpart of [theta_pools].
#'
#' @inheritParams line_counts
#' @return A named numeric vector `theta_A`, `theta_B`, `theta_AB`.
#' @family fast metrics
#' @export
fast_theta_pools <- function(idx, ctx) {
  cnt <- line_counts(idx, ctx)
  A <- ctx$pool == "A"
  cA <- cnt; cA[!A] <- 0L; cB <- cnt; cB[A] <- 0L
  sA <- sum(cA); sB <- sum(cB)
  qA <- if (sA > 0) as.vector(ctx$fL %*% cA) else NULL
  c(theta_A  = if (sA > 0) sum(cA * qA) / (sA * sA) else NA_real_,
    theta_B  = if (sB > 0) sum(cB * (ctx$fL %*% cB)) / (sB * sB) else NA_real_,
    theta_AB = if (sA > 0 && sB > 0) sum(cB * qA) / (sA * sB) else NA_real_)
}

# --- 8. Decoders ---------------------------------------------------------------

#' Decode a random-key vector into hybrid indices
#'
#' The classical encoding, one gene per hybrid, so the search dimension is `N`.
#'
#' @param p Numeric parameter vector of length `ctx$N`.
#' @param ctx Context augmented by [fast_ctx].
#' @param n_sel Number of hybrids to select.
#' @return An integer vector of selected hybrid indices.
#' @seealso [decode_lines], the recommended encoding.
#' @export
decode_rank <- function(p, ctx, n_sel) order(p)[seq_len(n_sel)]

#' Decode a line-weight vector into hybrid indices
#'
#' The recommended encoding. One weight per **line**, so the search dimension
#' drops from `N` to `L`. Each line weight shifts the score of every hybrid it
#' parents, and hybrids are taken greedily subject to the per-line usage cap --
#' so the cap is satisfied by construction rather than by penalty.
#'
#' This reparameterisation, not the constraint handler, is what decides whether
#' the differential evolution works: at an equal 60,000-evaluation budget under
#' four simultaneous restrictions it reached index 1.988 against 0.351 for
#' [decode_rank].
#'
#' @param p Numeric parameter vector of length `ctx$n_lines`.
#' @param ctx Context augmented by [fast_ctx].
#' @param n_sel Number of hybrids to select.
#' @param max_use Maximum times any line may be used, or `NULL` for no cap.
#' @param w_div Weight on the line term relative to the index.
#' @return An integer vector of selected hybrid indices.
#' @export
decode_lines <- function(p, ctx, n_sel, max_use = NULL, w_div = 3) {
  par <- ctx$parents
  sc  <- ctx$index + w_div * (p[par[, 1]] + p[par[, 2]])
  ord <- order(-sc)
  if (is.null(max_use)) return(ord[seq_len(n_sel)])
  sel <- integer(n_sel); cnt <- integer(ctx$n_lines); k <- 0L
  for (h in ord) {
    a <- par[h, 1]; b <- par[h, 2]
    if (cnt[a] < max_use && cnt[b] < max_use) {
      k <- k + 1L; sel[k] <- h; cnt[a] <- cnt[a] + 1L; cnt[b] <- cnt[b] + 1L
      if (k == n_sel) break
    }
  }
  if (k < n_sel) {                      # infeasible cap: top up ignoring it,
    rest <- setdiff(ord, sel[seq_len(k)])   # the penalty term then sees it
    sel[(k + 1L):n_sel] <- rest[seq_len(n_sel - k)]
  }
  sel
}

# --- 9. DE fitness on the line route ------------------------------------------

#' Differential-evolution fitness on the line route
#'
#' The drop-in replacement for [make_fitness] at production scale. Uses only
#' `ctx$fL` and `ctx$parents` in the inner loop: no `N x N` matrix is ever
#' formed or indexed. Handles several simultaneous restrictions, each entering
#' as a proportional penalty.
#'
#' @param ctx Context augmented by [fast_ctx].
#' @param n_sel Number of hybrids to select.
#' @param gd_ref Reference gene diversity from [null_distribution].
#' @param alpha_max Maximum acceptable relative loss of gene diversity.
#' @param ne_par_min Minimum effective number of parents, or `NULL`.
#' @param max_use Maximum use of any single line, or `NULL`.
#' @param pool_tol Tolerance on the deviation of pool balance from 0.5, or
#'   `NULL`.
#' @param index The index to maximise.
#' @param penalty Penalty multiplier on the total constraint violation.
#' @param encoding `"lines"` (recommended, dimension `L`) or `"hybrid"`
#'   (dimension `N`).
#' @return A function of the DE parameter vector returning a value to minimise.
#' @export
make_fitness_fast <- function(ctx, n_sel, gd_ref, alpha_max,
                              ne_par_min = NULL, max_use = NULL,
                              pool_tol = NULL, index = ctx$index,
                              penalty = 5, encoding = c("lines", "hybrid")) {
  encoding <- match.arg(encoding)
  fL <- ctx$fL; par <- ctx$parents; L <- ctx$n_lines
  isA <- ctx$pool == "A"
  force(index); force(n_sel); force(alpha_max); force(gd_ref); force(max_use)
  function(p) {
    idx <- if (encoding == "lines") decode_lines(p, ctx, n_sel, max_use)
           else                     decode_rank(p, ctx, n_sel)
    cnt <- tabulate(par[idx, , drop = FALSE], nbins = L)
    u <- which(cnt > 0L); cu <- cnt[u]; s <- sum(cu)
    theta <- as.numeric(crossprod(cu, fL[u, u, drop = FALSE] %*% cu)) / (s * s)
    gd    <- 1 - theta
    viol  <- max(0, (gd_ref - gd) / gd_ref - alpha_max) / alpha_max
    if (!is.null(ne_par_min)) {
      nep  <- (s * s) / sum(cu * cu)
      viol <- viol + max(0, (ne_par_min - nep)) / ne_par_min
    }
    if (!is.null(max_use)) viol <- viol + sum(pmax(0, cu - max_use)) / s
    if (!is.null(pool_tol)) {
      bal  <- abs(sum(cu[isA[u]]) / s - 0.5)
      viol <- viol + max(0, bal - pool_tol) / pool_tol
    }
    -(mean(index[idx]) - penalty * viol)                  # DEoptim minimises
  }
}
