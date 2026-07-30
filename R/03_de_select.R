# Strategies for selecting n_sel hybrids among N candidates.
# All return an index vector.

# --- Baselines -----------------------------------------------------------------

sel_random <- function(ctx, n_sel) sample.int(ctx$N, n_sel)

# Ceiling on gain, floor on diversity.
sel_truncation <- function(ctx, n_sel) order(ctx$index, decreasing = TRUE)[seq_len(n_sel)]

# Truncation with a per-line usage cap. The cheap baseline: no matrix at all,
# just counting, and it usually captures most of the benefit.
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

# Encoding: n_sel continuous values in [1, N], not an N-key vector — 5000
# dimensions is infeasible for DE. Duplicates are repaired deterministically
# (a noisy fitness would keep the DE from converging).
# ponytail: the repair fills in the lowest free indices, which introduces a
# slight bias; switch to "nearest free" if the DE stalls.
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

sel_de <- function(ctx, n_sel, alpha_max, gd_ref, NP = 300, itermax = 2000,
                   seeds = NULL, trace = FALSE) {
  fit <- make_fitness(ctx, n_sel, alpha_max, gd_ref)
  # Warm start with heuristic solutions: the DE starts from something already feasible.
  initial <- matrix(runif(NP * n_sel, 1, ctx$N + 1), NP, n_sel)
  if (!is.null(seeds)) for (i in seq_along(seeds)) initial[i, ] <- seeds[[i]] + 0.5

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
project_capped_simplex <- function(v, cap) {
  lo <- min(v) - 1; hi <- max(v)
  for (i in 1:60) {
    tau <- (lo + hi) / 2
    if (sum(pmin(pmax(v - tau, 0), cap)) > 1) lo <- tau else hi <- tau
  }
  pmin(pmax(v - (lo + hi) / 2, 0), cap)
}

# Too few iters yields an "upper bound" SMALLER than the discrete optimum —
# useless. 4000 is the minimum that converges in testing; re-check whenever
# the dataset changes.
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
