## R/fast_metrics.R ----------------------------------------------------------
## Drop-in fast routes for the diversity metrics used inside the DE inner loop.
##
## Central identity (proved in report/metric_selection.Rmd, verified to machine
## precision by R/01_verify_identity.R):
##
##   For F1 hybrids of homozygous lines, hybrid i = (a,b) and j = (c,d),
##
##       f_ij = ( fL_ac + fL_ad + fL_bc + fL_bd ) / 4                      (exact)
##
##   hence for any selected set S of n hybrids, with line-usage frequencies
##   w_a = (#times line a is a parent in S) / (2n),   sum_a w_a = 1,
##
##       theta_S = w' fL w          and       pbar_k = (w' GL)_k           (exact)
##
##   The N x N hybrid coancestry matrix f is therefore NEVER needed: every
##   frequency-based diversity metric of a hybrid set is a function of the
##   line-usage vector w and the L x L line coancestry matrix fL.
##
## Contract: `ctx` must carry
##   ctx$fL       L x L molecular coancestry BETWEEN LINES
##   ctx$parents  N x 2 integer matrix of parent line indices per hybrid
##   ctx$n_lines  L
##   ctx$GL       L x m line genotype matrix in {0,1}  (only for allelic metrics)
##   ctx$maf_pop  length-m population MAF              (only for allelic metrics)

## ---------------------------------------------------------------------------
## 1. Line-usage vector: the single sufficient statistic
## ---------------------------------------------------------------------------

## Integer parent counts over the L lines. O(n).
line_counts <- function(idx, ctx) {
  tabulate(ctx$parents[idx, , drop = FALSE], nbins = ctx$n_lines)
}

## Usage frequencies w (sum to 1). O(n + L).
line_weights <- function(idx, ctx) {
  cnt <- line_counts(idx, ctx)
  cnt / sum(cnt)
}

## ---------------------------------------------------------------------------
## 2. Group coancestry / gene diversity  -- THE inner-loop metric
## ---------------------------------------------------------------------------

## theta via the line route. Cost O(n + Lu^2) with Lu = #lines actually used,
## and INDEPENDENT of N (no N x N matrix) and of m.
fast_theta <- function(idx, ctx) {
  cnt <- line_counts(idx, ctx)
  u   <- which(cnt > 0L)                       # restrict to used lines
  cu  <- cnt[u]
  s   <- sum(cu)
  as.numeric(crossprod(cu, ctx$fL[u, u, drop = FALSE] %*% cu)) / (s * s)
}

fast_gene_div   <- function(idx, ctx) 1 - fast_theta(idx, ctx)
fast_status_num <- function(idx, ctx) 1 / (2 * fast_theta(idx, ctx))

## Precomputable variant: when the same ctx is reused across ~1e6 evaluations,
## hoist the L x L matrix out and work on raw counts.
make_theta_fun <- function(ctx) {
  fL <- ctx$fL; par <- ctx$parents; L <- ctx$n_lines
  function(idx) {
    cnt <- tabulate(par[idx, , drop = FALSE], nbins = L)
    u <- which(cnt > 0L); cu <- cnt[u]; s <- sum(cu)
    as.numeric(crossprod(cu, fL[u, u, drop = FALSE] %*% cu)) / (s * s)
  }
}

## ---------------------------------------------------------------------------
## 3. Incremental swap update -- O(L) per single-hybrid swap
## ---------------------------------------------------------------------------
## State: integer count vector `cnt` and the vector v = fL %*% cnt.
## Swapping hybrid `out` for hybrid `inn` changes at most 4 entries of cnt.
theta_state <- function(idx, ctx) {
  cnt <- line_counts(idx, ctx)
  v   <- as.vector(ctx$fL %*% cnt)
  list(cnt = cnt, v = v, s = sum(cnt),
       theta = sum(cnt * v) / sum(cnt)^2)
}

## Apply a swap; returns updated state. O(L) (four rank-1 column updates).
theta_swap <- function(st, out_h, in_h, ctx) {
  cnt <- st$cnt; v <- st$v
  po <- ctx$parents[out_h, ]; pi_ <- ctx$parents[in_h, ]
  for (a in po) { cnt[a] <- cnt[a] - 1L; v <- v - ctx$fL[, a] }
  for (a in pi_) { cnt[a] <- cnt[a] + 1L; v <- v + ctx$fL[, a] }
  s <- st$s                                     # n unchanged => s unchanged
  list(cnt = cnt, v = v, s = s, theta = sum(cnt * v) / (s * s))
}

## ---------------------------------------------------------------------------
## 4. Effective number of parents -- free, shares `cnt` with theta
## ---------------------------------------------------------------------------
fast_ne_parents <- function(idx, ctx) {
  cnt <- line_counts(idx, ctx)
  s <- sum(cnt)
  (s * s) / sum(cnt * cnt)
}

## From an existing count vector (zero extra cost inside the loop).
ne_parents_from_counts <- function(cnt) { s <- sum(cnt); (s * s) / sum(cnt * cnt) }

## ---------------------------------------------------------------------------
## 5. Selection allele frequencies from the LINE matrix
## ---------------------------------------------------------------------------
## pbar = w' GL exactly. Cost O(Lu * m) instead of O(n * m): a win whenever
## the number of distinct parent lines used is smaller than the number of
## hybrids selected, which is the normal case in a factorial hybrid design.
fast_pbar <- function(idx, ctx) {
  cnt <- line_counts(idx, ctx)
  u <- which(cnt > 0L)
  as.vector(crossprod(cnt[u], ctx$GL[u, , drop = FALSE])) / sum(cnt)
}

fast_he_nei <- function(idx, ctx) { p <- fast_pbar(idx, ctx); mean(2 * p * (1 - p)) }

fast_alleles_lost <- function(idx, ctx, thr = 0.05) {
  p <- fast_pbar(idx, ctx); maf <- pmin(p, 1 - p)
  sum(maf < thr & ctx$maf_pop >= thr)
}

## ---------------------------------------------------------------------------
## 6. Allelic richness by bitset -- presence/absence, no floating point
## ---------------------------------------------------------------------------
## An allele is RETAINED iff at least one used line carries it. That is a
## bitwise OR across the used lines' packed genotype rows. Packing 32 markers
## per integer makes this ~32x less work than a numeric colMeans.
## NOTE: R integers are SIGNED 32-bit. bitwShiftL(1L, 31L) is NA, and the
## classic multiply-based popcount overflows. We therefore pack 31 bits per
## word and count bits with a 16-bit lookup table.
BITS_PER_WORD <- 31L
.POPCNT16 <- local({
  tb <- integer(65536L)
  for (i in 1:15) tb[(bitwShiftL(1L, i) + 1L):min(bitwShiftL(1L, i + 1L), 65536L)] <-
    tb[1L:min(bitwShiftL(1L, i), 65536L - bitwShiftL(1L, i))] + 1L
  tb <- sapply(0:65535, function(z) sum(bitwAnd(bitwShiftR(z, 0:15), 1L)))
  as.integer(tb)
})

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

## popcount for non-negative 31-bit integers, via two 16-bit table lookups
popcount32 <- function(x) {
  .POPCNT16[bitwAnd(x, 65535L) + 1L] + .POPCNT16[bitwShiftR(x, 16L) + 1L]
}

## Number of marker alleles (out of 2m) still segregating in the selection.
fast_alleles_retained <- function(idx, ctx, bits = ctx$bits) {
  cnt <- line_counts(idx, ctx); u <- which(cnt > 0L)
  orR <- Reduce(bitwOr, split(bits$ref[u, , drop = FALSE], col(bits$ref[u, , drop = FALSE])))
  orA <- Reduce(bitwOr, split(bits$alt[u, , drop = FALSE], col(bits$alt[u, , drop = FALSE])))
  sum(popcount32(orR)) + sum(popcount32(orA))
}

## Faster form: column-wise OR without split(), for use in the loop.
alleles_retained_fast <- function(idx, ctx, bits = ctx$bits) {
  cnt <- line_counts(idx, ctx); u <- which(cnt > 0L)
  R <- bits$ref[u, , drop = FALSE]; A <- bits$alt[u, , drop = FALSE]
  oR <- R[1, ]; oA <- A[1, ]
  if (nrow(R) > 1L) for (i in 2:nrow(R)) { oR <- bitwOr(oR, R[i, ]); oA <- bitwOr(oA, A[i, ]) }
  sum(popcount32(oR)) + sum(popcount32(oA))
}

## ---------------------------------------------------------------------------
## 7. Pool decomposition from the same count vector
## ---------------------------------------------------------------------------
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

## ---------------------------------------------------------------------------
## 8. Decoders
## ---------------------------------------------------------------------------
## decode_rank()  : classical random-key encoding, one gene per HYBRID (dim N).
## decode_lines() : recommended encoding, one weight per LINE (dim L). The line
##   weight shifts each hybrid's score by the weights of its two parents, and
##   hybrids are taken greedily subject to the per-line usage cap, so the cap is
##   satisfied by construction rather than by penalty. Benchmarked in
##   report/metric_selection.Rmd: at an equal 60,000-evaluation budget under four
##   simultaneous restrictions this reached index 1.988 against 0.351 for
##   decode_rank(), because it cuts the DE search dimension from N to L.

decode_rank <- function(p, ctx, n_sel) order(p)[seq_len(n_sel)]

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

## 9. Ready-to-paste DE fitness function
## ---------------------------------------------------------------------------
## Replaces make_fitness() in the existing pipeline. Uses ONLY ctx$fL and
## ctx$parents in the inner loop: no N x N matrix is ever formed or indexed.
##
## encoding = "lines"  -> DEoptim lower/upper have length ctx$n_lines  (recommended)
## encoding = "hybrid" -> DEoptim lower/upper have length ctx$N
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
