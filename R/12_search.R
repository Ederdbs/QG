# Advanced search: the methods that exploit the structure of the problem.
#
# Three facts, all checkable and all verified in the book's "Advanced
# selection" chapter, are what these functions are built on:
#
#   1. f == tcrossprod(cbind(X, 1 - X)) / m  exactly, so f is a Gram matrix and
#      therefore positive semi-definite. c' f c is a convex quadratic and
#      d_ij = f_ii + f_jj - 2 f_ij is a squared Euclidean distance.
#   2. At fixed n, theta_S * n^2 == sum(f[S, S]) exactly, so maximising gene
#      diversity is minimising the submatrix sum. That objective is submodular
#      and the index term is modular, so the sum stays submodular.
#   3. theta_S = w' fL w with w the line-usage vector (see 04_fast_metrics.R),
#      so the whole problem lives in L dimensions, not N. At N = 10000 the
#      hybrid matrix is 0.745 GiB; the line matrix is 0.3 MiB.
#
# The per-line usage cap is a partition matroid, one per heterotic pool. Every
# function here enforces it as a hard feasibility predicate on the move, never
# as a penalty -- a feasible move is cheaper to test than an infeasible one is
# to punish.

# --- Internal helpers ---------------------------------------------------------

# Objective shared by every search in this file: mean index minus a
# proportional penalty on the diversity budget, matching make_fitness_fast().
# alpha_max = 0 is a legitimate request, so the normaliser is floored rather
# than the threshold.
ls_objective <- function(n_sel, alpha_max, gd_ref, penalty) {
  scale_a <- max(alpha_max, 1e-6)
  function(isum, theta) {
    viol <- max(0, (gd_ref - (1 - theta)) / gd_ref - alpha_max) / scale_a
    isum / n_sel - penalty * viol
  }
}

# Top a short selection up to n_sel with the best unused candidates.
ls_top_up <- function(sel, ctx, n_sel) {
  if (length(sel) >= n_sel) return(sel[seq_len(n_sel)])
  rest <- setdiff(order(ctx$index, decreasing = TRUE), sel)
  c(sel, rest[seq_len(n_sel - length(sel))])
}

# Warm start. As with sel_de(seeds = NULL), NULL means "build the sweep",
# never "start cold". The greedy sweep needs the N x N matrix, so at
# production scale we fall back on the counting-only capped truncation.
ls_warm_start <- function(ctx, n_sel, alpha_max, gd_ref, max_use) {
  cap <- if (is.null(max_use)) ceiling(2 * n_sel / ctx$n_lines) + 1 else max_use
  cand <- list(ls_top_up(sel_truncation_cap(ctx, n_sel, cap = cap), ctx, n_sel))
  fmat <- ctx[["f"]]
  if (!is.null(fmat) && is.matrix(fmat) && nrow(fmat) == ctx$N)
    cand <- c(cand, lapply(c(0, 0.25, 0.5, 1, 2, 4, 8, 16), function(w)
      ls_top_up(sel_greedy(ctx, n_sel, w = w, max_use = max_use), ctx, n_sel)))
  a <- vapply(cand, function(s) alpha_loss(s, ctx, gd_ref), numeric(1))
  u <- vapply(cand, function(s) mean(ctx$index[s]), numeric(1))
  ok <- a <= alpha_max
  if (any(ok)) cand[[which(ok)[which.max(u[ok])]]] else cand[[which.min(a)]]
}

# One Metropolis chain over the swap neighbourhood. Returns the final and the
# best-ever state. `temps` of length 1 with value 0 is steepest-ascent hill
# climbing; a decreasing schedule is simulated annealing.
ls_chain <- function(st, sel, in_set, isum, ctx, n_sel, max_use, obj, temps,
                     iters, trace_every, t0_secs, trace) {
  N <- ctx$N; par <- ctx$parents; ix <- ctx$index
  cur <- obj(isum, st$theta)
  best <- cur; best_sel <- sel
  tr <- if (trace) matrix(NA_real_, ceiling(iters / trace_every) + 1L, 3L) else NULL
  ti <- 0L; acc <- 0L
  for (k in seq_len(iters)) {
    pos <- sample.int(n_sel, 1L)
    out_h <- sel[pos]
    oa <- par[out_h, 1L]; ob <- par[out_h, 2L]

    # Propose an entering hybrid that is already matroid-feasible. The test is
    # O(1) from the count vector, so a tight cap costs proposals, not
    # evaluations -- without this the budget is spent being rejected.
    in_h <- NA_integer_
    for (try in 1:20) {
      cand <- sample.int(N, 1L)
      if (in_set[cand]) next
      if (is.null(max_use)) { in_h <- cand; break }
      ca <- par[cand, 1L]; cb <- par[cand, 2L]
      if (st$cnt[ca] + 1L - (ca == oa) - (ca == ob) <= max_use &&
          st$cnt[cb] + 1L - (cb == oa) - (cb == ob) <= max_use) { in_h <- cand; break }
    }
    if (is.na(in_h)) next

    st2 <- theta_swap(st, out_h, in_h, ctx)
    isum2 <- isum - ix[out_h] + ix[in_h]
    new <- obj(isum2, st2$theta)

    d <- new - cur
    tk <- temps[[min(k, length(temps))]]
    if (d > 0 || (tk > 0 && stats::runif(1) < exp(d / tk))) {
      st <- st2; isum <- isum2; cur <- new; acc <- acc + 1L
      in_set[out_h] <- FALSE; in_set[in_h] <- TRUE; sel[pos] <- in_h
      if (cur > best) { best <- cur; best_sel <- sel }
    }
    if (trace && k %% trace_every == 0L) {
      ti <- ti + 1L
      tr[ti, ] <- c(k, proc.time()[["elapsed"]] - t0_secs, best)
    }
  }
  list(st = st, sel = sel, in_set = in_set, isum = isum, cur = cur,
       best = best, best_sel = best_sel, accepted = acc,
       trace = if (trace) tr[seq_len(ti), , drop = FALSE] else NULL)
}

# --- 1. Local search ----------------------------------------------------------

#' Local search over the swap neighbourhood
#'
#' The search this package's own primitives were written for.
#' [theta_state]/[theta_swap] maintain group coancestry in `O(L)` per move, so
#' a swap costs about 5 microseconds at production scale against 85 for the
#' `f`-submatrix route -- and no `N x N` matrix is formed at all.
#'
#' Three modes, one driver, differing only in the temperature schedule:
#' `"hill"` accepts improving moves only, `"anneal"` runs one geometrically
#' cooled Metropolis chain, and `"tempering"` runs `n_chains` chains on a
#' temperature ladder with periodic replica exchange. De Beukelaer et al. (2018) found
#' parallel tempering to win on this class of problem not by being individually
#' cleverer but by combining many simple local searches.
#'
#' The per-line cap is a **partition matroid** and is enforced as a hard
#' feasibility test on each move. The diversity budget is a proportional
#' penalty, matching [make_fitness_fast].
#'
#' @param ctx Context augmented by [fast_ctx].
#' @param n_sel Number of hybrids to select.
#' @param alpha_max Maximum acceptable relative loss of gene diversity.
#' @param gd_ref Reference gene diversity from [null_distribution].
#' @param start Integer vector to start from. `NULL` (the default) builds a
#'   warm start, exactly as `sel_de(seeds = NULL)` does; it never means "start
#'   cold".
#' @param max_use Maximum times any line may be used, or `NULL` for no cap.
#' @param mode `"hill"`, `"anneal"` or `"tempering"`.
#' @param iters Total proposed moves, summed over chains, so the wall-clock
#'   cost of the three modes is comparable at equal `iters`.
#' @param n_chains Number of replicas when `mode = "tempering"`.
#' @param penalty Penalty multiplier on the diversity violation.
#' @param t0 Starting temperature. `NULL` calibrates it from the median
#'   absolute objective change over a short burn-in of random moves, which
#'   avoids a magic constant that would not transfer between datasets.
#' @param swap_every Replica-exchange interval, in moves per chain.
#' @param seed Optional integer for reproducibility.
#' @param trace Record an anytime trace of `(evals, seconds, best)`.
#' @return An integer vector of selected hybrid indices, carrying attributes
#'   `objective` and, when `trace = TRUE`, `trace`.
#' @seealso [sel_de] for the population alternative, [ocs_round] for a bound.
#' @family selection strategies
#' @export
#' @examples
#' cfg <- modifyList(sim_config, list(n_pool_A = 8, n_pool_B = 8, m = 200))
#' ctx <- fast_ctx(simulate_data(cfg))
#' nl <- null_distribution(ctx, 12, B = 50, B_full = 10)
#' s <- sel_local_search(ctx, 12, 0.01, nl$gd_ref, iters = 500, seed = 1)
#' length(s)
sel_local_search <- function(ctx, n_sel, alpha_max, gd_ref,
                             start = NULL, max_use = NULL,
                             mode = c("hill", "anneal", "tempering"),
                             iters = 2e4, n_chains = 8, penalty = 5,
                             t0 = NULL, swap_every = 50L,
                             seed = NULL, trace = FALSE) {
  mode <- match.arg(mode)
  if (!is.null(seed)) set.seed(seed)
  if (is.null(ctx$parents)) ctx <- fast_ctx(ctx)
  stopifnot(!is.null(ctx$fL))

  obj <- ls_objective(n_sel, alpha_max, gd_ref, penalty)
  sel <- if (is.null(start)) ls_warm_start(ctx, n_sel, alpha_max, gd_ref, max_use)
         else as.integer(start)
  stopifnot(length(sel) == n_sel, !anyDuplicated(sel))

  st <- theta_state(sel, ctx)
  isum <- sum(ctx$index[sel])
  in_set <- logical(ctx$N); in_set[sel] <- TRUE

  # Self-calibrating temperature: the median absolute objective change over a
  # sample of random moves. Nothing about the scale of `index` is assumed.
  if (is.null(t0) && mode != "hill") {
    nb <- min(200L, ctx$N)
    d <- vapply(seq_len(nb), function(i) {
      pos <- sample.int(n_sel, 1L); out_h <- sel[pos]
      repeat { in_h <- sample.int(ctx$N, 1L); if (!in_set[in_h]) break }
      s2 <- theta_swap(st, out_h, in_h, ctx)
      abs(obj(isum - ctx$index[out_h] + ctx$index[in_h], s2$theta) - obj(isum, st$theta))
    }, numeric(1))
    t0 <- max(stats::median(d), 1e-9)
  }

  t_start <- proc.time()[["elapsed"]]
  trace_every <- max(1L, as.integer(iters %/% 200L))

  if (mode == "tempering") {
    per <- max(1L, as.integer(iters %/% n_chains))
    ladder <- t0 * (1e-3)^((seq_len(n_chains) - 1) / max(n_chains - 1, 1))
    reps <- lapply(seq_len(n_chains), function(j)
      list(st = st, sel = sel, in_set = in_set, isum = isum,
           cur = obj(isum, st$theta), best = obj(isum, st$theta), best_sel = sel))
    tr <- NULL
    nblk <- max(1L, per %/% swap_every)
    for (blk in seq_len(nblk)) {
      for (j in seq_len(n_chains)) {
        r <- reps[[j]]
        o <- ls_chain(r$st, r$sel, r$in_set, r$isum, ctx, n_sel, max_use, obj,
                      list(ladder[j]), swap_every, swap_every + 1L, t_start,
                      FALSE)
        if (r$best > o$best) { o$best <- r$best; o$best_sel <- r$best_sel }
        reps[[j]] <- o
      }
      # One trace point per block. A chain runs only `swap_every` moves before
      # the next exchange, so an inner counter would never reach the global
      # trace interval and the run would report no trace at all.
      if (trace)
        tr <- rbind(tr, c(blk * swap_every * n_chains,
                          proc.time()[["elapsed"]] - t_start,
                          max(vapply(reps, function(z) z$best, numeric(1)))))
      # replica exchange between adjacent rungs
      for (j in seq_len(n_chains - 1L)) {
        a <- reps[[j]]; b <- reps[[j + 1L]]
        lg <- (1 / ladder[j] - 1 / ladder[j + 1L]) * (b$cur - a$cur)
        if (log(stats::runif(1)) < lg) { reps[[j]] <- b; reps[[j + 1L]] <- a }
      }
    }
    bi <- which.max(vapply(reps, function(r) r$best, numeric(1)))
    out <- reps[[bi]]$best_sel; bestv <- reps[[bi]]$best
  } else {
    temps <- if (mode == "hill") list(0) else
      as.list(t0 * (1e-3)^(seq_len(iters) / iters))
    o <- ls_chain(st, sel, in_set, isum, ctx, n_sel, max_use, obj, temps,
                  iters, trace_every, t_start, trace)
    out <- o$best_sel; bestv <- o$best; tr <- o$trace
  }

  attr(out, "objective") <- bestv
  if (trace && !is.null(tr)) {
    colnames(tr) <- c("evals", "secs", "best")
    attr(out, "trace") <- tr[order(tr[, "evals"]), , drop = FALSE]
  }
  out
}

# --- 2. Differential evolution on the line encoding ---------------------------

#' Differential evolution on the line encoding
#'
#' Drives `DEoptim` on [decode_lines] and [make_fitness_fast], the pair the
#' package has exported since the line route was written but never had a driver
#' for. The search dimension is `L` rather than `N` -- 200 instead of 10000 at
#' production scale -- and no `N x N` matrix is formed. At an equal
#' 60,000-evaluation budget under four simultaneous restrictions this reaches
#' index 1.988 against 0.351 for the hybrid encoding of [sel_de].
#'
#' Warm start seeds sweep a line-diversity direction: `p` proportional to the
#' negated mean coancestry of each line, at increasing strength. At strength
#' zero the decode is capped truncation, which is the same starting point
#' [sel_de]'s `w = 0` greedy seed provides.
#'
#' @inheritParams make_fitness_fast
#' @param NP Population size.
#' @param itermax Maximum generations.
#' @param seeds A list of line-weight vectors to seed the population. `NULL`
#'   builds the diversity sweep; it never means "start cold".
#' @param trace Passed to `DEoptim`.
#' @return An integer vector of selected hybrid indices.
#' @family selection strategies
#' @export
sel_de_fast <- function(ctx, n_sel, gd_ref, alpha_max, ne_par_min = NULL,
                        max_use = NULL, pool_tol = NULL, NP = 300,
                        itermax = 2000, seeds = NULL, trace = FALSE) {
  if (is.null(ctx$parents)) ctx <- fast_ctx(ctx)
  L <- ctx$n_lines
  fit <- make_fitness_fast(ctx, n_sel, gd_ref, alpha_max, ne_par_min = ne_par_min,
                           max_use = max_use, pool_tol = pool_tol)
  if (is.null(seeds)) {
    v <- -rowMeans(ctx$fL)
    v <- (v - min(v)) / max(max(v) - min(v), 1e-12)     # into [0, 1]
    seeds <- lapply(seq(0, 1, length.out = 8), function(s) s * v)
  }
  initial <- matrix(stats::runif(NP * L), NP, L)
  for (i in seq_len(min(length(seeds), NP))) initial[i, ] <- seeds[[i]]

  ctrl <- DEoptim::DEoptim.control(NP = NP, itermax = itermax, trace = trace,
                                   initialpop = initial)
  res <- DEoptim::DEoptim(fit, lower = rep(0, L), upper = rep(1, L), control = ctrl)
  decode_lines(as.numeric(res$optim$bestmem), ctx, n_sel, max_use)
}

# --- 3. Relaxation, rounded ---------------------------------------------------

#' A valid upper bound on the mean index at a diversity budget
#'
#' The Lagrangian bound, and the reason it is worth its own function: the
#' construction the book used before -- the best relaxation point whose own
#' `alpha` happens to fall inside the budget -- is **not** an upper bound. The
#' relaxation at a given `lambda` maximises a penalised objective, not the
#' index, so a discrete plan at the same diversity can and does beat it.
#'
#' The correct statement is a one-line consequence of feasibility. Any
#' selection `S` of size `n` has an equal-weight contribution vector that is
#' feasible for [ocs_relaxation], so with
#' `V(lambda) = max_c (c'u - lambda c'f c)`,
#'
#' \deqn{V(\lambda) \ge \bar u_S - \lambda \theta_S \ge \bar u_S - \lambda \theta_{\max}}
#'
#' for every selection meeting the budget, hence
#' `mean index <= V(lambda) + lambda * theta_max` for **every** non-negative
#' `lambda`. The tightest such statement is the minimum over `lambda`, which is
#' what this returns.
#'
#' @param ctx Evaluation context, see [build_ctx].
#' @param n_sel Number of hybrids to select.
#' @param alpha_max Maximum acceptable relative loss of gene diversity.
#' @param gd_ref Reference gene diversity from [null_distribution].
#' @param lambdas Grid of multipliers to minimise over. A coarse grid still
#'   gives a valid bound -- every `lambda` gives one -- only a looser one.
#' @param iters Projected-gradient iterations passed to [ocs_relaxation].
#' @param lines Passed to [ocs_relaxation]. At production scale the dense route
#'   costs `O(N^2)` per gradient step and the line route `O(N L)`, so pass
#'   `TRUE` there even when the hybrid matrix happens to be in memory.
#' @param tol Relative change below which the doubling stops.
#' @param max_doublings Give up after this many doublings, with a warning.
#' @return The bound, carrying `lambda`, `relaxation`, `iters` and `converged`
#'   as attributes.
#' @seealso [ocs_relaxation], [ocs_round], [sel_exact]
#' @export
ocs_bound <- function(ctx, n_sel, alpha_max, gd_ref,
                      lambdas = 10^seq(-1, 3, length.out = 25), iters = 4000,
                      lines = NULL, tol = 1e-3, max_doublings = 6L) {
  theta_max <- 1 - gd_ref * (1 - alpha_max)
  at <- function(it) {
    rel <- ocs_relaxation(ctx, n_sel, lambdas, iters = it, lines = lines)
    b <- rel[, "index"] - lambdas * rel[, "theta"] + lambdas * theta_max
    j <- which.min(b)
    list(v = b[j], lam = lambdas[j], rel = rel, iters = it)
  }
  # The projected-gradient step is 1 / (2 lambda * max row sum of f), and that
  # row sum grows with N -- so a fixed iteration count that converges at book
  # scale does not at production scale. An under-converged relaxation reports
  # V(lambda) too SMALL, which makes the "bound" too small, and it stops being
  # a bound at all. The value increases monotonically with iterations, so
  # double until it stops moving rather than trusting a fixed count.
  cur <- at(iters); converged <- FALSE
  for (k in seq_len(max_doublings)) {
    nxt <- at(2L * cur$iters)
    done <- abs(nxt$v - cur$v) <= tol * max(abs(cur$v), 1e-12)
    cur <- nxt
    if (done) { converged <- TRUE; break }
  }
  if (!converged)
    warning("ocs_bound() did not converge in ", max_doublings,
            " doublings (last ", cur$iters, " iterations). An under-converged ",
            "relaxation understates V(lambda), so this may not be a valid ",
            "bound. Raise `iters`, `max_doublings`, or pass `lines = TRUE`.")
  structure(cur$v, lambda = cur$lam, relaxation = cur$rel, iters = cur$iters,
            converged = converged, names = NULL)
}

#' Round the continuous optimal-contribution solution into a plan
#'
#' Chapter 9 uses the continuous relaxation only as a bound. This turns it into
#' an algorithm: for each `lambda`, solve the optimal-contribution quadratic
#' programme in **line** space (dimension `L`, so `quadprog` returns instantly
#' even at production scale), round the contributions to integer line usage by
#' largest remainder, and assign concrete crosses greedily subject to both
#' pools' caps. The two-stage shape -- contributions first, mate allocation
#' second -- is that of Waldmann (2025).
#'
#' `lambda` is swept rather than chosen, and the plan returned is the
#' best-index one that respects `alpha_max`. The exchange rate is an internal
#' detail; the budget is the interface, as everywhere else in this package.
#'
#' Its distinguishing feature is the certificate. `bound` is the Lagrangian
#' bound of [ocs_bound], so `gap` is a genuine upper bound on what any method
#' could still gain at this budget. Note that the relaxation carries no
#' per-line cap, so with `max_use` set the bound stays valid but goes loose: it
#' bounds a problem strictly easier than the one solved.
#'
#' @param ctx Context augmented by [fast_ctx].
#' @param n_sel Number of hybrids to select.
#' @param alpha_max Maximum acceptable relative loss of gene diversity.
#' @param gd_ref Reference gene diversity from [null_distribution].
#' @param max_use Maximum times any line may be used, or `NULL`.
#' @param lambdas Coancestry weights to sweep in the line-space programme.
#' @param bound Optional precomputed upper bound on the mean index, which
#'   skips the [ocs_relaxation] sweep -- worth passing when several budgets are
#'   evaluated on one dataset.
#' @return A list with `idx`, `index`, `alpha`, `lambda`, `bound`, `gap` and
#'   `frontier` (the per-lambda table).
#' @seealso [ocs_quadprog], [ocs_relaxation], [sel_exact]
#' @family selection strategies
#' @export
ocs_round <- function(ctx, n_sel, alpha_max, gd_ref, max_use = NULL,
                      lambdas = 10^seq(-1, 2.5, length.out = 10),
                      bound = NULL) {
  if (is.null(ctx$parents)) ctx <- fast_ctx(ctx)
  L <- ctx$n_lines
  par <- ctx$parents

  # Line merit: the mean index of the hybrids each line parents.
  tot <- numeric(L); num <- numeric(L)
  for (j in 1:2) {
    tot <- tot + as.vector(tapply(ctx$index, factor(par[, j], levels = seq_len(L)),
                                  sum, default = 0))
    num <- num + tabulate(par[, j], nbins = L)
  }
  merit <- ifelse(num > 0, tot / pmax(num, 1), min(ctx$index))
  cap <- if (is.null(max_use)) 1 else max_use / (2 * n_sel)
  ord <- order(ctx$index, decreasing = TRUE)

  plan_for <- function(lam) {
    o <- ocs_quadprog(ctx$fL, merit, lambda = lam, upper = cap)
    want <- o$c_i * 2 * n_sel                     # largest-remainder rounding
    k <- floor(want)
    short <- 2 * n_sel - sum(k)
    if (short > 0) {
      j <- order(want - k, decreasing = TRUE)[seq_len(short)]
      k[j] <- k[j] + 1
    }
    if (!is.null(max_use)) k <- pmin(k, max_use)

    quota <- k; used <- integer(L); sel <- integer(0)
    for (h in ord) {                              # b-matching, greedy
      a <- par[h, 1]; b <- par[h, 2]
      if (quota[a] > 0 && quota[b] > 0 &&
          (is.null(max_use) || (used[a] < max_use && used[b] < max_use))) {
        sel <- c(sel, h); quota[a] <- quota[a] - 1L; quota[b] <- quota[b] - 1L
        used[a] <- used[a] + 1L; used[b] <- used[b] + 1L
        if (length(sel) == n_sel) break
      }
    }
    # The quota is a rounding artefact; the cap is the real constraint, so top
    # up on the cap alone.
    if (length(sel) < n_sel) for (h in ord) {
      if (length(sel) == n_sel) break
      if (h %in% sel) next
      a <- par[h, 1]; b <- par[h, 2]
      if (is.null(max_use) || (used[a] < max_use && used[b] < max_use)) {
        sel <- c(sel, h); used[a] <- used[a] + 1L; used[b] <- used[b] + 1L
      }
    }
    if (length(sel) < n_sel)
      stop("cannot reach n_sel hybrids under max_use = ", max_use)
    sel
  }

  plans <- lapply(lambdas, plan_for)
  fr <- data.frame(lambda = lambdas,
                   index = vapply(plans, function(s) mean(ctx$index[s]), numeric(1)),
                   alpha = vapply(plans, function(s) alpha_loss(s, ctx, gd_ref),
                                  numeric(1)))
  ok <- fr$alpha <= alpha_max
  pick <- if (any(ok)) which(ok)[which.max(fr$index[ok])] else which.min(fr$alpha)

  if (is.null(bound)) bound <- ocs_bound(ctx, n_sel, alpha_max, gd_ref)
  idxv <- fr$index[pick]
  list(idx = plans[[pick]], index = idxv, alpha = fr$alpha[pick],
       lambda = lambdas[pick], bound = bound,
       gap = if (is.na(bound)) NA_real_ else (bound - idxv) / abs(bound),
       frontier = fr)
}

# --- 4. Exact, by outer approximation -----------------------------------------

#' Exact selection by outer approximation
#'
#' The oracle. `x' f x` is convex (fact 1 at the top of this file), so a
#' gradient cut at any point `xb`,
#' `xb' f xb + 2 (f xb)' (x - xb) <= b`, is a valid linear outer approximation
#' of the diversity budget. Solving the resulting mixed-integer **linear**
#' programme, adding a cut wherever the solution violates the true quadratic
#' constraint and re-solving, converges to the exact optimum -- and the linear
#' relaxation's objective is a valid upper bound at every iteration.
#'
#' This matters because HiGHS, like most open solvers, does **not** support a
#' quadratic objective together with integer variables. Outer approximation
#' needs only a MILP solver, and it returns more than a black-box call would:
#' an incumbent and a dual bound, hence a certified interval containing the
#' true optimum even when the time limit stops it early.
#'
#' Intended as the correctness baseline for the heuristics, in the spirit of
#' the `ref_*` oracles of `R/09_reference.R` -- not as a production route. It
#' forms the `N x N` matrix and scales like the mixed-integer programme it is.
#'
#' @param ctx Evaluation context, see [build_ctx].
#' @param n_sel Number of hybrids to select.
#' @param alpha_max Maximum acceptable relative loss of gene diversity.
#' @param gd_ref Reference gene diversity from [null_distribution].
#' @param max_use Maximum times any line may be used, or `NULL`.
#' @param start Optional feasible solution to seed the incumbent with.
#' @param max_cuts Maximum outer-approximation rounds.
#' @param time_limit Seconds allowed to the whole loop.
#' @return A list with `idx`, `incumbent`, `dual_bound`, `gap`, `status` and
#'   `n_cuts`. `status` is `"optimal"` only when the loop proved it.
#' @family selection strategies
#' @export
sel_exact <- function(ctx, n_sel, alpha_max, gd_ref, max_use = NULL,
                      start = NULL, max_cuts = 200L, time_limit = 60) {
  if (!requireNamespace("highs", quietly = TRUE))
    stop("Package 'highs' is required for sel_exact().")
  f <- ctx[["f"]]
  N <- ctx$N
  u <- ctx$index
  budget <- n_sel^2 * (1 - gd_ref * (1 - alpha_max))   # x'f x <= budget

  # Structural rows: cardinality, plus one partition-matroid row per line.
  rows <- list(rep(1, N)); lhs <- n_sel; rhs <- n_sel
  if (!is.null(max_use)) {
    par <- if (is.null(ctx$parents)) cbind(ctx$ped$a, ctx$ped$b) else ctx$parents
    for (a in seq_len(ctx$n_lines)) {
      r <- as.numeric(par[, 1] == a) + as.numeric(par[, 2] == a)
      if (any(r > 0)) { rows <- c(rows, list(r)); lhs <- c(lhs, -Inf); rhs <- c(rhs, max_use) }
    }
  }
  n_struct <- length(rows)

  # Always carry an incumbent, so that a time-limited run still returns a
  # certified interval rather than an open-ended bound.
  if (is.null(start)) start <- ls_warm_start(ctx, n_sel, alpha_max, gd_ref, max_use)
  inc <- -Inf; inc_idx <- NULL; x0 <- NULL
  if (sum(f[start, start]) <= budget * (1 + 1e-9)) {
    inc <- mean(u[start]); inc_idx <- start
    x0 <- numeric(N); x0[start] <- 1
  }

  t_end <- proc.time()[["elapsed"]] + time_limit
  status <- "cut limit"; dual <- Inf; n_cuts <- 0L

  for (it in seq_len(max_cuts)) {
    left <- t_end - proc.time()[["elapsed"]]
    if (left <= 0) { status <- "time limit"; break }
    A <- do.call(rbind, rows)
    sol <- highs::highs_solve(
      L = u, lower = rep(0, N), upper = rep(1, N), A = A, lhs = lhs, rhs = rhs,
      types = rep("I", N), maximum = TRUE, start = x0,
      control = highs::highs_control(time_limit = max(1, left)))
    if (is.null(sol$primal_solution)) { status <- "solver failure"; break }

    # Only a MILP solved to optimality has its objective as a valid bound; a
    # timed-out solve returns an incumbent instead, and the dual bound must be
    # read from the solver's own field. Cuts only tighten the relaxation, so
    # the running minimum stays valid.
    solved <- isTRUE(sol$status_message == "Optimal")
    db <- if (solved) sol$objective_value else sol$info$mip_dual_bound
    if (is.finite(db)) dual <- min(dual, db / n_sel)

    xb <- round(sol$primal_solution)
    cand <- which(xb > 0.5)
    q <- if (length(cand)) sum(f[cand, cand]) else 0
    if (q <= budget * (1 + 1e-9) && length(cand) == n_sel) {
      if (mean(u[cand]) > inc) { inc <- mean(u[cand]); inc_idx <- cand }
      if (solved) { dual <- inc; status <- "optimal"; break }
      status <- "time limit"; break
    }
    if (!solved) { status <- "time limit"; break }

    g <- 2 * as.numeric(f %*% xb)                       # gradient of x'f x
    rows <- c(rows, list(g)); lhs <- c(lhs, -Inf); rhs <- c(rhs, budget + q)
    n_cuts <- n_cuts + 1L
  }

  list(idx = inc_idx, incumbent = inc, dual_bound = dual,
       gap = if (is.finite(inc) && is.finite(dual) && dual != 0)
               (dual - inc) / abs(dual) else NA_real_,
       status = status, n_cuts = n_cuts, n_rows = length(rows))
}
