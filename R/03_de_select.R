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

# Ceiling on gain: the maximum-index plan. Its diversity loss (alpha_trunc) is
# the loss at the unconstrained optimum, not a floor on diversity: a budget at or
# above it is slack, and other subsets can lose more.

#' Truncation selection on the index
#'
#' The ceiling on gain: take the top `n_sel` hybrids by index and ignore
#' relatedness entirely. It is the plan of maximum index; its diversity loss
#' is the loss at that unconstrained optimum, so a budget `alpha_max` at or
#' above it is slack. It is not the largest loss over all subsets, hence not a
#' floor on diversity.
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
# Score = w*index - theta.  w = 0 -> pure diversity (the most diverse plan the
# greedy builds, ~0 gain; no certificate that it is the most diverse subset). w > 0 -> discrete OCS heuristic. w -> Inf converges to truncation.

#' Greedy selection with incremental coancestry updates
#'
#' Adding hybrid `j` changes the submatrix total by `2 s_j + f_jj`, where `s_j`
#' is the sum of `f[i, j]` over the already-chosen set -- so each step is `O(N)`
#' rather than `O(n^2)`.
#'
#' The score is `w * index - theta`. With `w = 0` this is pure diversity (the
#' most diverse plan the greedy builds, near-zero gain; no certificate that it
#' is the most diverse subset); `w > 0` makes it a discrete
#' optimal-contribution heuristic; `w -> Inf` converges to [sel_truncation].
#'
#' Greedy solutions are also what warm-starts [sel_de]. In the book's 20-seed
#' comparison at book scale, the default warm start was worth +0.139 index
#' units over a cold start (a measured location effect, mechanism not
#' identified); at that budget (NP 120, itermax 250, 30,000 evaluations) the DE
#' still finished below the best feasible greedy plan. That is a statement about
#' the budget, not about the DE: at 120,000 evaluations (NP 120, itermax 1000)
#' it finished above that plan in 10 of 10 seeds, and at the default 600,000 in
#' 10 of 10.
#'
#' @inheritParams sel_random
#' @param w Weight on the index relative to coancestry.
#' @param max_use Maximum times any line may be used, or `NULL` for no cap.
#'   The cap is a partition matroid, so it is enforced by making the hybrids of
#'   an exhausted line unavailable -- a hard feasibility test on the move,
#'   never a penalty.
#' @return An integer vector of selected row indices. Shorter than `n_sel` only
#'   when the cap makes `n_sel` unreachable.
#' @family selection strategies
#' @export
sel_greedy <- function(ctx, n_sel, w = 0, max_use = NULL) {
  f <- ctx[["f"]]
  d <- diag(f)
  s <- numeric(ctx$N)
  avail <- rep(TRUE, ctx$N)
  out <- integer(n_sel)
  total <- 0
  if (!is.null(max_use)) {
    pa <- as.integer(ctx$ped$a); pb <- as.integer(ctx$ped$b)
    cnt <- integer(ctx$n_lines)
  }

  for (k in seq_len(n_sel)) {
    theta_new <- (total + 2 * s + d) / k^2
    score <- w * ctx$index - theta_new
    score[!avail] <- -Inf
    j <- which.max(score)
    if (!is.finite(score[j])) { out <- out[seq_len(k - 1L)]; break }
    out[k] <- j; avail[j] <- FALSE
    total <- total + 2 * s[j] + d[j]
    s <- s + f[, j]
    if (!is.null(max_use)) {
      for (a in c(pa[j], pb[j])) {
        cnt[a] <- cnt[a] + 1L
        if (cnt[a] >= max_use) avail[pa == a | pb == a] <- FALSE
      }
    }
  }
  out
}

# --- Differential evolution -----------------------------------------------------

# Encoding: n_sel continuous values in [1, N], not an N-key vector. A cached
# external run (3 seeds, 60,000 evaluations, NP unrecorded; under 2
# generations at NP = 10 x dimension for 3,600 keys) had the N-key arm far
# behind; that is a budget-limited result, not a proof that an N-dimensional
# encoding cannot work. Duplicates are repaired deterministically (a noisy
# fitness would keep the DE from converging).
# decode_rank() (the N-key decoder, R/04) takes no max_use, so for
# encoding = "hybrid" a penalty and a repair of the per-line cap coincide;
# this is an inference from the code, not a tested explanation.
# ponytail: the repair fills in the lowest free indices, which introduces a
# slight bias; switch to "nearest free" if the DE stalls.

#' Decode a continuous DE parameter vector into hybrid indices
#'
#' The encoding is `n_sel` continuous values in `[1, N]`, not an `N`-key
#' vector. The one comparison recorded (cached, external: 3 seeds, 60,000
#' evaluations, population size unrecorded, under two generations at 10 x
#' dimension for an N-key arm) found the N-key arm far behind; that is a
#' result at a small budget, not a proof that an `N`-dimensional encoding is
#' infeasible. Duplicates are repaired deterministically, because a noisy
#' fitness would stop the DE converging.
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
# against the random reference. A violation is charged as `penalty` times the
# absolute excess of alpha over alpha_max (alpha units, not a ratio), so
# "alpha_max = 0.05" still means "I accept losing 5%" and an overshoot is
# priced, not refused.

#' Build the constrained fitness function for differential evolution
#'
#' `alpha` is a **constraint**, not a weighted-sum term: a violation is charged
#' `penalty` times the absolute excess of `alpha` over `alpha_max` (in alpha
#' units; the fitness is the mean index minus that charge), so
#' `alpha_max = 0.05` still means "I accept losing 5 percent" rather than
#' "diversity is worth this much index". An overshoot is priced, not refused.
#'
#' @param ctx Evaluation context, see [build_ctx].
#' @param n_sel Number of hybrids to select.
#' @param alpha_max Maximum acceptable relative loss of gene diversity.
#' @param gd_ref Reference gene diversity from [null_distribution].
#' @param penalty Multiplier on the absolute constraint violation (alpha
#'   excess, plus the `max_use` excess below), in index units per unit of
#'   violation. Default 1000. Note the contrast with [make_fitness_fast],
#'   whose penalty (default 5) multiplies a violation already divided by its
#'   limit (proportional, dimensionless): 0.001 of alpha excess costs 1 index
#'   unit here, and 5 * 0.001 / alpha_max there.
#' @param max_use Maximum times any line may be used, or `NULL` for no cap.
#'   The default is `NULL`, which reproduces the behaviour this function had
#'   before the cap existed. Set it to make the per-line usage restriction --
#'   a partition matroid -- active on the production route; the violation is
#'   the number of line uses above `max_use`, summed over lines and divided by
#'   `2 * n_sel`, added to the alpha excess and charged at the same `penalty`.
#' @return A function of the DE parameter vector returning a value to minimise.
#' @export
make_fitness <- function(ctx, n_sel, alpha_max, gd_ref, penalty = 1000,
                         max_use = NULL) {
  N <- ctx$N
  f <- ctx[["f"]]
  ix <- ctx$index
  L <- ctx$n_lines
  pa <- as.integer(ctx$ped$a); pb <- as.integer(ctx$ped$b)
  function(par) {
    idx <- decode(par, N, n_sel)
    gd <- 1 - mean(f[idx, idx])
    viol <- max(0, (gd_ref - gd) / gd_ref - alpha_max)
    if (!is.null(max_use)) {
      cnt <- tabulate(c(pa[idx], pb[idx]), nbins = L)
      viol <- viol + sum(pmax(0, cnt - max_use)) / (2 * n_sel)
    }
    -(mean(ix[idx]) - penalty * viol)   # DEoptim minimizes
  }
}


#' Differential-evolution selection under a diversity constraint
#'
#' Runs `DEoptim` on the continuous encoding of [decode], with the fitness from
#' [make_fitness].
#'
#' The population is seeded with greedy solutions by default (`seeds = NULL`
#' never means a cold start). The earlier note that a cold start with 4.5e5
#' evaluations does not beat greedy on roughly 100 integer dimensions is a
#' historical figure: no run of it is recorded in this repository and it is not
#' reproduced here. What the book measured instead (book scale, 20 seeds, about
#' 30,000 evaluations): the default warm start finished +0.139 index units above
#' a cold start, and below the best feasible greedy plan. The second half
#' reverses with the budget: at the 1% budget, 10 seeds, the mean index was
#' 1.334 at 30,000 evaluations (NP 120, itermax 250; 0 of 10 above the best
#' feasible fine-grid greedy, 1.4226), 1.438 at 120,000 (NP 120, itermax 1000;
#' 10 of 10 above) and 1.481 at the default 600,000 (NP 300, itermax 2000;
#' 10 of 10 above). The cold-versus-warm effect was measured at 30,000
#' evaluations only.
#'
#' The default seed grid is hard-coded (`w` = 0, 0.25, 0.5, 1, 2, 4, 8, 16),
#' all but `w = 0` above the weight at which the greedy crosses over from
#' diversity to index, so it holds few distinct plans (at book scale, the
#' truncation plan seven times and the `w = 0` plan once). The best feasible
#' greedy plan at the given budget is not generally among them; pass it in
#' `seeds` to start from it.
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
                   seeds = NULL, trace = FALSE, max_use = NULL) {
  fit <- make_fitness(ctx, n_sel, alpha_max, gd_ref, max_use = max_use)
  # Warm start with heuristic solutions: the DE starts from something already
  # feasible. Without this it finishes below a plain greedy at small budgets
  # (about 30,000 evaluations; it passes the best greedy plan by 120,000, see
  # the sel_de roxygen), so NULL means "build the sweep", never "start cold".
  if (is.null(seeds))
    seeds <- lapply(c(0, 0.25, 0.5, 1, 2, 4, 8, 16), function(w)
      sel_greedy(ctx, n_sel, w = w, max_use = max_use))
  seeds <- Filter(function(s) length(s) == n_sel, seeds)   # a tight cap can
  initial <- matrix(runif(NP * n_sel, 1, ctx$N + 1), NP, n_sel)  # shorten a seed
  for (i in seq_len(min(length(seeds), NP))) initial[i, ] <- seeds[[i]] + 0.5

  ctrl <- DEoptim::DEoptim.control(NP = NP, itermax = itermax, trace = trace,
                                   initialpop = initial)
  res <- DEoptim::DEoptim(fit, lower = rep(1, n_sel), upper = rep(ctx$N + 0.999, n_sel),
                          control = ctrl)
  decode(res$optim$bestmem, ctx$N, n_sel)
}

# --- Continuous OCS relaxation (penalised objective) -----------------------------

# max c'u - lambda*c'f c  s.t.  sum(c)=1, 0 <= c <= 1/n_sel.
# The cap c_i <= 1/n_sel makes every equal-weight 0/1 plan feasible here, so the
# value V(lambda) is >= the penalised value of any discrete plan. It is NOT an
# upper bound on the index at equal diversity (it maximises the penalised
# objective); the valid bound is ocs_bound() (Lagrangian, R/12_search.R).

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

# Too few iters leaves V(lambda) too small (below a discrete plan's penalised
# value), which is not a relaxation of anything. 4000 is a default, not a
# threshold: convergence is a tolerance on V (relative change on doubling, as
# ocs_bound() does), and the count that meets it grows with N.

#' Continuous optimal-contribution relaxation
#'
#' Maximises `c'u - lambda c'f c` subject to `sum(c) = 1` and
#' `0 <= c <= 1 / n_sel`. The cap makes every equal-weight 0/1 plan feasible,
#' so the maximum `V(lambda)` is at least the penalised value
#' `mean index - lambda * theta` of any discrete plan. This is a relaxation of
#' the **penalised** problem, not a bound on the index at a given diversity: a
#' plan that spends a diversity budget is less diverse than a relaxation point
#' inside it and can have a higher index. The valid upper bound at a budget is
#' [ocs_bound] (Lagrangian, `V(lambda) + lambda * theta_max`).
#'
#' Too few iterations leave `V(lambda)` below a discrete plan's penalised value,
#' which is the signature of non-convergence. The default `iters` is not a
#' threshold: judge convergence by the relative change of `V` when `iters`
#' doubles (the tolerance [ocs_bound] uses), and re-check it as `N` grows.
#'
#' @param ctx Evaluation context, see [build_ctx].
#' @param n_sel Number of hybrids, which sets the contribution cap.
#' @param lambdas Numeric vector of diversity weights to sweep.
#' @param iters Projected-gradient iterations per lambda.
#' @param lines Use the line route for the matrix-vector products, which is
#'   exact and costs O(N + L^2) instead of O(N^2). `NULL` auto-selects it when
#'   the hybrid matrix is absent, so results computed with an `N x N` `f`
#'   present are unchanged.
#' @return A matrix with one row per lambda.
#' @export
ocs_relaxation <- function(ctx, n_sel, lambdas, iters = 4000, lines = NULL) {
  cap <- 1 / n_sel
  # The line route computes f %*% c in O(N + L^2) instead of O(N^2), using the
  # same identity as fast_theta: with q_a the c-weighted parent count of line a,
  # (f c)_i = ((fL q)[a_i] + (fL q)[b_i]) / 4  and  c' f c = q' fL q / 4.
  # It is exact, so it changes nothing but the cost. Auto-selected only when the
  # hybrid matrix is absent, which is how a production-scale ctx is built.
  if (is.null(lines))
    lines <- !is.null(ctx$fL) && !is.null(ctx$parents) &&
             !(is.matrix(ctx[["f"]]) && nrow(ctx[["f"]]) == ctx$N)
  if (lines) {
    if (is.null(ctx$parents)) ctx <- fast_ctx(ctx)
    par <- ctx$parents; fL <- ctx$fL; nl <- ctx$n_lines
    # The N x L incidence matrix costs 16 MB at N = 10000 against 0.745 GiB for
    # f, and turns both products into BLAS calls: 2 N L flops instead of N^2.
    Minc <- matrix(0, ctx$N, nl)
    ii <- seq_len(ctx$N)
    Minc[cbind(ii, par[, 1])] <- Minc[cbind(ii, par[, 1])] + 1
    Minc[cbind(ii, par[, 2])] <- Minc[cbind(ii, par[, 2])] + 1
    fc <- function(cv) as.numeric(Minc %*% (fL %*% crossprod(Minc, cv))) / 4
  } else {
    fmat <- ctx[["f"]]
    fc <- function(cv) as.numeric(fmat %*% cv)
  }
  L <- max(fc(rep(1, ctx$N)))     # Gershgorin bound on the largest eigenvalue
  do.call(rbind, lapply(lambdas, function(lam) {
    step <- 1 / (2 * max(lam, 1e-6) * L)
    c_ <- rep(1 / ctx$N, ctx$N)
    for (i in seq_len(iters)) {
      g <- ctx$index - 2 * lam * fc(c_)
      c_ <- project_capped_simplex(c_ + step * as.numeric(g), cap)
    }
    th <- sum(c_ * fc(c_))
    c(lambda = lam, index = sum(c_ * ctx$index), theta = th, GD = 1 - th)
  }))
}
