# Strategies for selecting n_sel hybrids among N candidates.
# All return an index vector.

# --- Baselines -----------------------------------------------------------------


#' Random selection
#'
#' The null strategy. Every other strategy is judged against the distribution
#' this one generates, see [null_distribution].
#'
#' @param ctx Evaluation context, see [build_ctx].
#' @param n_sel Number of hybrids to select.
#' @return An integer vector of selected row indices.
#' @family selection strategies
#' @export
sel_random <- function(ctx, n_sel) sample.int(ctx$N, n_sel)

# Ceiling on gain, floor on diversity.

#' Truncation selection on the index
#'
#' The ceiling on gain and the floor on diversity: take the top `n_sel` hybrids
#' by index and ignore relatedness entirely.
#'
#' @inheritParams sel_random
#' @return An integer vector of selected row indices.
#' @family selection strategies
#' @export
sel_truncation <- function(ctx, n_sel) order(ctx$index, decreasing = TRUE)[seq_len(n_sel)]

# Truncation with a per-line usage cap. The cheap baseline: no matrix at all,
# just counting, and it usually captures most of the benefit.

#' Truncation with a per-line usage cap
#'
#' The cheap baseline: no coancestry matrix at all, just counting how often each
#' parent line has been used. It usually captures most of the benefit.
#'
#' @inheritParams sel_random
#' @param cap Maximum number of times any parent line may be used.
#' @return An integer vector of selected row indices.
#' @family selection strategies
#' @export
sel_truncation_cap <- function(ctx, n_sel, cap = ceiling(2 * n_sel / ctx$n_lines) + 1) {
  ord <- order(ctx$index, decreasing = TRUE)
  used <- integer(ctx$n_lines)
  out <- integer(0)
  for (i in ord) {
    a <- ctx$ped$a[i]; b <- ctx$ped$b[i]
    if (used[a] < cap && used[b] < cap) {
      out <- c(out, i); used[a] <- used[a] + 1L; used[b] <- used[b] + 1L
      if (length(out) == n_sel) break
    }
  }
  out
}

# Greedy with incremental updates: adding j changes the submatrix total by
# 2*s_j + f_jj, where s_j = sum of f[i,j] over the already-chosen. O(N) per step.
# Score = w*index - theta.  w = 0 -> pure diversity (ceiling on diversity,
# ~0 gain). w > 0 -> discrete OCS heuristic. w -> Inf converges to truncation.

#' Greedy selection with incremental coancestry updates
#'
#' Adding hybrid `j` changes the submatrix total by `2 s_j + f_jj`, where `s_j`
#' is the sum of `f[i, j]` over the already-chosen set -- so each step is `O(N)`
#' rather than `O(n^2)`.
#'
#' The score is `w * index - theta`. With `w = 0` this is pure diversity (the
#' ceiling on diversity, near-zero gain); `w > 0` makes it a discrete
#' optimal-contribution heuristic; `w -> Inf` converges to [sel_truncation].
#'
#' Greedy solutions are also what warm-starts [sel_de]; without them the
#' differential evolution does not beat greedy at any affordable budget.
#'
#' @inheritParams sel_random
#' @param w Weight on the index relative to coancestry.
#' @return An integer vector of selected row indices.
#' @family selection strategies
#' @export
sel_greedy <- function(ctx, n_sel, w = 0) {
  f <- ctx$f
  d <- diag(f)
  s <- numeric(ctx$N)
  avail <- rep(TRUE, ctx$N)
  out <- integer(n_sel)
  total <- 0

  for (k in seq_len(n_sel)) {
    theta_new <- (total + 2 * s + d) / k^2
    score <- w * ctx$index - theta_new
    score[!avail] <- -Inf
    j <- which.max(score)
    out[k] <- j; avail[j] <- FALSE
    total <- total + 2 * s[j] + d[j]
    s <- s + f[, j]
  }
  out
}

# --- Differential evolution -----------------------------------------------------

# Encoding: n_sel continuous values in [1, N], not an N-key vector -- 5000
# dimensions is infeasible for DE. Duplicates are repaired deterministically
# (a noisy fitness would keep the DE from converging).
# ponytail: the repair fills in the lowest free indices, which introduces a
# slight bias; switch to "nearest free" if the DE stalls.

#' Decode a continuous DE parameter vector into hybrid indices
#'
#' The encoding is `n_sel` continuous values in `[1, N]`, not an `N`-key
#' vector: an `N`-dimensional 0/1 encoding is infeasible for differential
#' evolution at this scale. Duplicates are repaired deterministically, because
#' a noisy fitness would stop the DE converging.
#'
#' @param par Numeric vector of length `n_sel`, values in `[1, N]`.
#' @param N Number of candidates.
#' @param n_sel Number of hybrids to select.
#' @return An integer vector of `n_sel` unique indices.
#' @export
decode <- function(par, N, n_sel) {
  k <- as.integer(par)
  k[k < 1L] <- 1L; k[k > N] <- N
  dup <- duplicated(k)
  if (any(dup)) k[dup] <- setdiff(seq_len(N), k[!dup])[seq_len(sum(dup))]
  k
}

# Constraint, not a weighted sum: alpha = relative loss of gene diversity
# against the random reference. A violation becomes a proportional penalty, so
# "alpha_max = 0.05" still means "I accept losing 5%".

#' Build the constrained fitness function for differential evolution
#'
#' `alpha` is a **constraint**, not a weighted-sum term: a violation becomes a
#' proportional penalty, so `alpha_max = 0.05` still means "I accept losing 5
#' percent" rather than "diversity is worth this much index".
#'
#' @param ctx Evaluation context, see [build_ctx].
#' @param n_sel Number of hybrids to select.
#' @param alpha_max Maximum acceptable relative loss of gene diversity.
#' @param gd_ref Reference gene diversity from [null_distribution].
#' @param penalty Penalty multiplier on the constraint violation.
#' @return A function of the DE parameter vector returning a value to minimise.
#' @export
make_fitness <- function(ctx, n_sel, alpha_max, gd_ref, penalty = 1000) {
  N <- ctx$N
  f <- ctx$f
  ix <- ctx$index
  function(par) {
    idx <- decode(par, N, n_sel)
    gd <- 1 - mean(f[idx, idx])
    viol <- max(0, (gd_ref - gd) / gd_ref - alpha_max)
    -(mean(ix[idx]) - penalty * viol)   # DEoptim minimizes
  }
}


#' Differential-evolution selection under a diversity constraint
#'
#' Runs `DEoptim` on the continuous encoding of [decode], with the fitness from
#' [make_fitness].
#'
#' The population **must** be seeded with greedy solutions. Without that warm
#' start, 4.5e5 evaluations are not enough to beat greedy on roughly 100
#' integer dimensions.
#'
#' @inheritParams make_fitness
#' @param NP Population size.
#' @param itermax Maximum generations.
#' @param seeds A list of index vectors to seed the initial population.
#'   `NULL` (the default) builds a greedy sweep automatically. Passing a single
#'   random vector is how the book demonstrates what a cold start costs; do not
#'   do it in production.
#' @param trace Passed to `DEoptim` for progress reporting.
#' @return An integer vector of selected hybrid indices.
#' @family selection strategies
#' @export
sel_de <- function(ctx, n_sel, alpha_max, gd_ref, NP = 300, itermax = 2000,
                   seeds = NULL, trace = FALSE) {
  fit <- make_fitness(ctx, n_sel, alpha_max, gd_ref)
  # Warm start with heuristic solutions: the DE starts from something already
  # feasible. Without this it finishes BELOW a plain greedy at any affordable
  # budget, so NULL means "build the sweep", never "start cold".
  if (is.null(seeds))
    seeds <- lapply(c(0, 0.25, 0.5, 1, 2, 4, 8, 16), function(w)
      sel_greedy(ctx, n_sel, w = w))
  initial <- matrix(runif(NP * n_sel, 1, ctx$N + 1), NP, n_sel)
  for (i in seq_len(min(length(seeds), NP))) initial[i, ] <- seeds[[i]] + 0.5

  ctrl <- DEoptim::DEoptim.control(NP = NP, itermax = itermax, trace = trace,
                                   initialpop = initial)
  res <- DEoptim::DEoptim(fit, lower = rep(1, n_sel), upper = rep(ctx$N + 0.999, n_sel),
                          control = ctrl)
  decode(res$optim$bestmem, ctx$N, n_sel)
}

# --- Continuous OCS relaxation (upper bound) -------------------------------------

# max c'u - lambda*c'f c  s.t.  sum(c)=1, 0 <= c <= 1/n_sel.
# The cap c_i <= 1/n_sel is what makes this a valid upper bound for the equal-
# weight 0/1 problem. A large gap against the DE means the DE hasn't converged.

#' Project onto the capped simplex
#'
#' Projects `v` onto the set where `sum(c) = 1` and `0 <= c <= cap` by bisection on the
#' shift.
#'
#' @param v Numeric vector to project.
#' @param cap Upper bound on each element.
#' @return A numeric vector of the same length.
#' @export
project_capped_simplex <- function(v, cap) {
  lo <- min(v) - 1; hi <- max(v)
  for (i in 1:60) {
    tau <- (lo + hi) / 2
    if (sum(pmin(pmax(v - tau, 0), cap)) > 1) lo <- tau else hi <- tau
  }
  pmin(pmax(v - (lo + hi) / 2, 0), cap)
}

# Too few iters yields an "upper bound" SMALLER than the discrete optimum --
# useless. 4000 is the minimum that converges in testing; re-check whenever
# the dataset changes.

#' Continuous optimal-contribution relaxation
#'
#' Maximises `c'u - lambda c'f c` subject to `sum(c) = 1` and
#' `0 <= c <= 1 / n_sel`. The cap is what makes this a valid **upper bound**
#' for the equal-weight 0/1 problem: a large gap against [sel_de] means the DE
#' has not converged.
#'
#' Too few iterations yield an "upper bound" smaller than the discrete optimum,
#' which is useless. The default is the minimum that converged in testing;
#' re-check it whenever the dataset changes.
#'
#' @param ctx Evaluation context, see [build_ctx].
#' @param n_sel Number of hybrids, which sets the contribution cap.
#' @param lambdas Numeric vector of diversity weights to sweep.
#' @param iters Projected-gradient iterations per lambda.
#' @return A matrix with one row per lambda.
#' @export
ocs_relaxation <- function(ctx, n_sel, lambdas, iters = 4000) {
  cap <- 1 / n_sel
  L <- max(rowSums(abs(ctx$f)))   # Gershgorin bound on the largest eigenvalue
  do.call(rbind, lapply(lambdas, function(lam) {
    step <- 1 / (2 * max(lam, 1e-6) * L)
    c_ <- rep(1 / ctx$N, ctx$N)
    for (i in seq_len(iters)) {
      g <- ctx$index - 2 * lam * (ctx$f %*% c_)
      c_ <- project_capped_simplex(c_ + step * as.numeric(g), cap)
    }
    th <- drop(t(c_) %*% ctx$f %*% c_)
    c(lambda = lam, index = sum(c_ * ctx$index), theta = th, GD = 1 - th)
  }))
}
