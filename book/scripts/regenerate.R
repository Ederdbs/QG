#!/usr/bin/env Rscript
# Regenerate the cached artefacts the book reads from book/data and book/figs.
#
#   Rscript book/scripts/regenerate.R            # everything (hours)
#   Rscript book/scripts/regenerate.R f2size     # one target
#
# This is NEVER invoked by `quarto render`. The book reads the committed
# outputs; this script is how those outputs came to exist, and how to refresh
# them when the simulation configuration or a seed changes.
#
# Targets:
#   f2size       the F1->F4 sizing grid and its nine figures
#   benchmark    the metric benchmark: null, discriminatory power, frontier
#   identity     the line-collapse identity sweep
#   search       the advanced-selection benchmark of Chapter 10b
#   search_exact the outer-approximation oracle alone (slowest piece)
#
# Not regenerated here, because they are not this project's output:
#   bibliography_animal.csv, bibliography_plant.csv  (literature screens)
#   plant_metric_usage.csv                           (derived from those)

suppressMessages(pkgload::load_all(quiet = TRUE))

# Run from the repository root.
root <- getwd()
if (!dir.exists(file.path(root, "book")))
  stop("run this from the repository root: Rscript book/scripts/regenerate.R")
data_dir <- file.path(root, "book", "data")
fig_dir  <- file.path(root, "book", "figs")
# Targets the book actually reads go to book/data and book/figs. Diagnostics
# that only confirm a result go to report/, which is gitignored -- the
# committed tree stays exactly what the book needs.
out_dir <- file.path(root, "report")
dir.create(data_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(fig_dir,  showWarnings = FALSE, recursive = TRUE)
dir.create(out_dir,  showWarnings = FALSE, recursive = TRUE)

targets <- commandArgs(trailingOnly = TRUE)
if (!length(targets)) targets <- c("f2size", "benchmark", "identity", "search")
want <- function(x) x %in% targets

# --- f2size: the population-sizing grid ---------------------------------------
if (want("f2size")) {
  message("f2size: running the full grid, this takes several minutes")
  E <- f2_run_experiment(f2_opt, verbose = TRUE)
  write.csv(E$res, file.path(data_dir, "f2_results.csv"), row.names = FALSE)
  write.csv(E$ml,  file.path(data_dir, "f2_multilocus.csv"), row.names = FALSE)

  # The figures for this target are drawn live in the chapter (Chapter 4), so
  # nothing is written to book/figs here -- only the two tables it reads.

  message("f2size: done")
}

# --- benchmark: the metric benchmark ------------------------------------------
if (want("benchmark")) {
  message("benchmark: null distribution and strategy comparison")
  ctx   <- simulate_data(sim_config)
  n_sel <- round(0.04 * ctx$N)
  null  <- null_distribution(ctx, n_sel)

  sels <- list(random = sel_random(ctx, n_sel),
               truncation = sel_truncation(ctx, n_sel),
               trunc_cap = sel_truncation_cap(ctx, n_sel),
               greedy_div = sel_greedy(ctx, n_sel, w = 0),
               greedy_w1 = sel_greedy(ctx, n_sel, w = 1))
  tab <- evaluate(sels, ctx, null$gd_ref)

  write.csv(cost_per_eval(ctx, n_sel), file.path(out_dir, "cost_per_eval_book.csv"),
            row.names = FALSE)
  write.csv(discriminatory_power(tab, null),
            file.path(out_dir, "discriminatory_power.csv"))
  plot_null(null, tab, file.path(fig_dir, "null.png"))
  plot_correlation(null, file.path(fig_dir, "metric_correlation.png"))
  message("benchmark: done")
}

# --- identity: the line-collapse sweep ----------------------------------------
if (want("identity")) {
  message("identity: sweeping fst x seed x n_sel")
  out <- list(); z <- 1L
  for (fst in c(0.05, 0.15, 0.35)) for (seed in 1:2) for (n_sel in c(20, 100)) {
    sim  <- simulate_pools(n_A = 25, n_B = 25, m = 1500, fst = fst, seed = seed)
    ctxp <- fast_ctx(ctx_from_pools(sim), GL = sim$GL, pack = TRUE)
    dev <- replicate(30, {
      s <- sample.int(ctxp$N, n_sel)
      st <- theta_state(s, ctxp)
      o  <- s[1]; i <- setdiff(seq_len(ctxp$N), s)[1]
      c(sub_vs_line = abs(theta_group(s, ctxp) - fast_theta(s, ctxp)),
        sub_vs_freq = abs(theta_group(s, ctxp) - theta_from_freq(s, ctxp)),
        pbar        = max(abs(fast_pbar(s, ctxp) - colMeans(ctxp$X[s, , drop = FALSE]))),
        He          = abs(fast_he_nei(s, ctxp) - he_nei(s, ctxp)),
        Neparents   = abs(fast_ne_parents(s, ctxp) - ne_parents(s, ctxp)),
        pools       = max(abs(fast_theta_pools(s, ctxp) - ref_theta_pools(s, ctxp))),
        swap        = abs(theta_swap(st, o, i, ctxp)$theta -
                            theta_group(c(s[-1], i), ctxp)),
        bitset      = abs(alleles_retained_fast(s, ctxp) -
                            alleles_retained(unique(as.vector(
                              ctxp$parents[s, ])), sim$GL)))
    })
    out[[z]] <- data.frame(fst = fst, seed = seed, n_sel = n_sel,
                           t(apply(dev, 1, max))); z <- z + 1L
  }
  write.csv(do.call(rbind, out),
            file.path(out_dir, "identity_sweep_book.csv"), row.names = FALSE)
  message("identity: done")
}


# --- search: the advanced-selection benchmark ---------------------------------
# Backs Chapter 10b. Two scales: the book's teaching scale, and the production
# scale the chapter is about (N = 10000 from 100 + 100 lines). The large scale
# forms a 0.745 GiB hybrid coancestry matrix, which is the wall the line route
# exists to remove -- so it is formed once, deliberately, to time the methods
# that need it, and dropped before the ones that do not.
if (want("search")) {
  message("search: advanced-selection benchmark, this takes a while")

  # Adaptive timing: repeat until the total exceeds `target` seconds, or the
  # measurement is quantised by the clock. At 200 repetitions of a 3 us call the
  # resolution IS the answer, which is how a route can appear to cost zero.
  bench_us <- function(f, target = 0.4) {
    r <- 50L
    repeat {
      t <- system.time(for (i in seq_len(r)) f())[["elapsed"]]
      if (t > target || r > 2e6) return(1e6 * t / r)
      r <- r * 4L
    }
  }

  bench_scale <- function(cfg, n_sel, seeds, iters, de_iter, tag, lines = NULL,
                          blam = 10^seq(-1, 3, length.out = 25),
                          biters = 4000, bdoub = 6L) {
    ctx  <- fast_ctx(simulate_data(cfg))
    null <- null_distribution(ctx, n_sel, B = 500, B_full = 50)
    gd   <- null$gd_ref
    am   <- 0.01
    # Roughly twice the mean usage of 2 n_sel / L. The package default of
    # ceiling(2 n_sel / L) + 1 leaves almost no freedom at production scale,
    # where the mean usage is already 2.
    cap <- ceiling(4 * n_sel / ctx$n_lines)
    # The certificate does not scale, and that is a finding rather than a
    # defect: the projected-gradient step is 1 / (2 lambda * max row sum of f)
    # and that row sum grows with N, so the iteration count needed to converge
    # grows too. ocs_bound() doubles until the value stops moving and warns if
    # it never does; where it does not converge the bound is recorded as
    # uncertified and every gap against it is NA, rather than quietly reported
    # as if it meant something.
    bnd <- withCallingHandlers(
      ocs_bound(ctx, n_sel, am, gd, lines = lines, lambdas = blam,
                iters = biters, max_doublings = bdoub),
      warning = function(w) invokeRestart("muffleWarning"))
    ok <- isTRUE(attr(bnd, "converged"))
    message(sprintf("  %s: N = %d, L = %d, n_sel = %d, cap = %d, bound = %.4f (%s, %d iters)",
                    tag, ctx$N, ctx$n_lines, n_sel, cap, as.numeric(bnd),
                    if (ok) "certified" else "NOT certified", attr(bnd, "iters")))

    row <- function(seed, method, s, secs, evals) data.frame(
      scale = tag, N = ctx$N, L = ctx$n_lines, n_sel = n_sel, cap = cap,
      seed = seed, method = method,
      index = mean_index(s, ctx), alpha = alpha_loss(s, ctx, gd),
      Ne_parents = ne_parents(s, ctx), max_line = max_line_use(s, ctx),
      secs = secs, evals = evals, bound = as.numeric(bnd), bound_certified = ok,
      gap_pct = if (ok) 100 * (as.numeric(bnd) - mean_index(s, ctx)) /
                        abs(as.numeric(bnd)) else NA_real_)
    timed <- function(expr) {
      t0 <- proc.time()[["elapsed"]]
      v <- force(expr)
      list(s = v, secs = proc.time()[["elapsed"]] - t0)
    }
    # The merit weight has to be swept finely: at these scales the useful range
    # sits below w = 0.01, and a coarse grid steps straight over it, which makes
    # greedy look far worse than it is.
    ws <- c(0, 10^seq(-5, 1, length.out = 19))
    best_feasible <- function(cand) {
      cand <- Filter(function(s) length(s) == n_sel, cand)
      a <- vapply(cand, alpha_loss, numeric(1), ctx = ctx, gd_ref = gd)
      ok <- a <= am
      if (any(ok)) cand[ok][[which.max(vapply(cand[ok], mean_index, numeric(1),
                                              ctx = ctx))]]
      else cand[[which.min(a)]]
    }

    out <- list()
    for (sd in seeds) {
      set.seed(sd)
      g <- timed(best_feasible(lapply(ws, function(w) sel_greedy(ctx, n_sel, w = w))))
      out[[length(out) + 1]] <- row(sd, "greedy", g$s, g$secs, length(ws) * n_sel)

      gc_ <- timed(best_feasible(lapply(ws, function(w)
        sel_greedy(ctx, n_sel, w = w, max_use = cap))))
      out[[length(out) + 1]] <- row(sd, "greedy_cap", gc_$s, gc_$secs,
                                    length(ws) * n_sel)

      for (m in c("hill", "anneal", "tempering")) {
        r <- timed(sel_local_search(ctx, n_sel, am, gd, mode = m, iters = iters,
                                    seed = sd))
        out[[length(out) + 1]] <- row(sd, m, r$s, r$secs, iters)
      }
      r <- timed(sel_local_search(ctx, n_sel, am, gd, mode = "tempering",
                                  iters = iters, max_use = cap, seed = sd))
      out[[length(out) + 1]] <- row(sd, "tempering_cap", r$s, r$secs, iters)

      # The encoding comparison, with and without the cap. The book's 5.7x
      # result was measured under four simultaneous restrictions, where the
      # line decoder satisfies the cap by construction; without a cap there is
      # nothing for it to satisfy, so both settings are reported.
      for (mu in list(NULL, cap)) {
        sfx <- if (is.null(mu)) "" else "_cap"
        d1 <- timed(suppressWarnings(
          sel_de(ctx, n_sel, am, gd, NP = 100, itermax = de_iter, max_use = mu)))
        out[[length(out) + 1]] <- row(sd, paste0("de_hybrid", sfx), d1$s, d1$secs,
                                      100 * de_iter)
        d2 <- timed(suppressWarnings(
          sel_de_fast(ctx, n_sel, gd, am, max_use = mu, NP = 100,
                      itermax = de_iter)))
        out[[length(out) + 1]] <- row(sd, paste0("de_lines", sfx), d2$s, d2$secs,
                                      100 * de_iter)
      }

      o <- timed(ocs_round(ctx, n_sel, am, gd, bound = bnd)$idx)
      out[[length(out) + 1]] <- row(sd, "ocs_round", o$s, o$secs, NA_integer_)
      o <- timed(ocs_round(ctx, n_sel, am, gd, max_use = cap, bound = bnd)$idx)
      out[[length(out) + 1]] <- row(sd, "ocs_round_cap", o$s, o$secs, NA_integer_)
    }
    list(res = do.call(rbind, out), ctx = ctx, null = null, bound = bnd, am = am)
  }

  gc()
  small <- bench_scale(modifyList(sim_config,
                                  list(n_pool_A = 25, n_pool_B = 25, m = 2000)),
                       n_sel = 60, seeds = 1:3, iters = 30000, de_iter = 300,
                       tag = "book")
  big <- bench_scale(modifyList(sim_config,
                                list(n_pool_A = 100, n_pool_B = 100, m = 5000)),
                     n_sel = 200, seeds = 1:3, iters = 30000, de_iter = 300,
                     tag = "production", lines = TRUE,
                     # a coarser, cheaper attempt: every lambda gives a valid
                     # bound, so this costs tightness, not validity -- and it is
                     # the convergence, not the grid, that fails at this scale
                     blam = 10^seq(-1, 3, length.out = 9),
                     biters = 4000, bdoub = 1L)
  bench <- rbind(small$res, big$res)
  big$ctx <- NULL; gc()
  write.csv(bench, file.path(data_dir, "search_benchmark.csv"), row.names = FALSE)

  # --- anytime curves, at book scale, at equal wall-clock ---------------------
  ctx <- small$ctx; gd <- small$null$gd_ref; am <- small$am; n_sel <- 60
  set.seed(1)
  tr <- lapply(c("hill", "anneal", "tempering"), function(m) {
    s <- sel_local_search(ctx, n_sel, am, gd, mode = m, iters = 60000,
                          seed = 1, trace = TRUE)
    d <- as.data.frame(attr(s, "trace")); d$method <- m; d
  })
  de_pts <- do.call(rbind, lapply(c(20, 50, 100, 200, 400, 800), function(it) {
    t0 <- proc.time()[["elapsed"]]
    s <- suppressWarnings(sel_de(ctx, n_sel, am, gd, NP = 100, itermax = it))
    data.frame(evals = 100 * it, secs = proc.time()[["elapsed"]] - t0,
               best = mean_index(s, ctx), method = "de_hybrid")
  }))
  anytime <- rbind(do.call(rbind, tr), de_pts)
  write.csv(anytime, file.path(data_dir, "search_anytime.csv"), row.names = FALSE)

  png(file.path(fig_dir, "search_anytime.png"), width = 1050, height = 680, res = 150)
  cols <- c(hill = "#2166ac", anneal = "#b2182b", tempering = "#1b7837",
            de_hybrid = "grey45")
  ok <- is.finite(anytime$secs) & anytime$secs > 0 & is.finite(anytime$best)
  yl <- range(c(anytime$best[ok], as.numeric(small$bound)))
  plot(range(anytime$secs[ok]), yl, type = "n", log = "x",
       xlab = "wall-clock seconds", ylab = "mean index (s.d.)")
  for (m in names(cols)) {
    d <- anytime[ok & anytime$method == m, ]
    d <- d[order(d$secs), ]
    lines(d$secs, cummax(d$best), col = cols[[m]], lwd = 2,
          type = if (m == "de_hybrid") "b" else "l",
          pch = if (m == "de_hybrid") 1 else NA)
  }
  abline(h = as.numeric(small$bound), lty = 2, col = "grey55")
  legend("bottomright", c(names(cols), "Lagrangian bound"),
         col = c(unlist(cols), "grey55"), lwd = c(2, 2, 2, 2, 1),
         lty = c(1, 1, 1, 1, 2), bty = "n", cex = 0.75)
  grid()
  dev.off()

  # --- what actually costs what ----------------------------------------------
  scal <- do.call(rbind, lapply(c(20, 40, 60, 80, 100), function(Lh) {
    cfg <- modifyList(sim_config, list(n_pool_A = Lh, n_pool_B = Lh, m = 1500))
    cx  <- fast_ctx(simulate_data(cfg))
    ns  <- max(20, round(0.02 * cx$N))
    nl  <- null_distribution(cx, ns, B = 100, B_full = 10)
    fh  <- make_fitness(cx, ns, 0.01, nl$gd_ref)
    ff  <- make_fitness_fast(cx, ns, nl$gd_ref, 0.01)
    ph  <- runif(ns, 1, cx$N + 1); pl <- runif(cx$n_lines)
    st  <- theta_state(seq_len(ns), cx)
    d <- data.frame(N = cx$N, L = cx$n_lines, n_sel = ns,
                    f_GB       = cx$N^2 * 8 / 2^30,
                    us_hybrid  = bench_us(function() fh(ph)),
                    us_lines   = bench_us(function() ff(pl)),
                    us_decode  = bench_us(function() decode_lines(pl, cx, ns)),
                    us_swap    = bench_us(function() theta_swap(st, ns + 1L, ns + 2L, cx)))
    rm(cx, fh, ff); gc()
    d
  }))
  # N = 22500 is where the benchmark of the metrics chapter refuses to form f at
  # all, so the hybrid route has no timing there by construction, not omission.
  scal <- rbind(scal, data.frame(N = 22500, L = 300, n_sel = 450,
                                 f_GB = 22500^2 * 8 / 2^30,
                                 us_hybrid = NA_real_, us_lines = NA_real_,
                                 us_decode = NA_real_, us_swap = NA_real_))
  write.csv(scal, file.path(data_dir, "search_scaling.csv"), row.names = FALSE)

  png(file.path(fig_dir, "search_scaling.png"), width = 1050, height = 680, res = 150)
  sc <- scal[is.finite(scal$us_hybrid), ]
  series <- list(us_hybrid = "#b2182b", us_lines = "#2166ac",
                 us_decode = "grey45", us_swap = "#1b7837")
  plot(range(sc$N), range(unlist(sc[names(series)])), type = "n", log = "xy",
       xlab = "number of candidate hybrids, N",
       ylab = "microseconds per objective evaluation")
  pchs <- c(19, 17, 4, 15)
  for (i in seq_along(series))
    lines(sc$N, sc[[names(series)[i]]], type = "b", pch = pchs[i],
          col = series[[i]], lwd = 2)
  legend("topleft",
         c("hybrid encoding, f submatrix", "line encoding, full fitness",
           "  of which: decode_lines (sorts N)", "incremental swap (no decode)"),
         col = unlist(series), pch = pchs, bty = "n", cex = 0.75)
  grid()
  dev.off()

  message("search: benchmark, scaling and anytime done")
}

# --- search_exact: the outer-approximation oracle -----------------------------
# Split out because it is the slowest piece and the one most likely to be re-run
# on its own. It rebuilds its own contexts so it does not depend on the
# benchmark target having run.
if (want("search") || want("search_exact")) {
  message("search_exact: outer-approximation oracle")
  ex <- list()
  set.seed(5)
  cfg <- modifyList(sim_config, list(n_pool_A = 6, n_pool_B = 6, m = 800))
  cx <- fast_ctx(simulate_data(cfg))
  nl <- null_distribution(cx, 8, B = 2000, B_full = 50)
  # Seed the oracle's incumbent with the heuristic under test. Without that the
  # incumbent is only the warm start, and a timed-out run reports a certified
  # interval far wider than what is actually known.
  for (am in c(0.005, 0.01, 0.02)) {
    t0 <- proc.time()[["elapsed"]]
    h <- sel_local_search(cx, 8, am, nl$gd_ref, mode = "tempering",
                          iters = 20000, seed = 1)
    e <- sel_exact(cx, 8, am, nl$gd_ref, start = h, time_limit = 120)
    ex[[length(ex) + 1]] <- data.frame(
      scale = "tiny", N = cx$N, n_sel = 8, alpha_max = am,
      heuristic = mean_index(h, cx),
      incumbent = e$incumbent, dual = e$dual_bound, status = e$status,
      cuts = e$n_cuts, secs = proc.time()[["elapsed"]] - t0,
      gap_pct = 100 * (e$dual_bound - mean_index(h, cx)) / abs(e$dual_bound))
  }
  ctx <- fast_ctx(simulate_data(modifyList(sim_config,
    list(n_pool_A = 25, n_pool_B = 25, m = 2000))))
  gd <- null_distribution(ctx, 60, B = 500, B_full = 50)$gd_ref
  for (am in c(0.005, 0.01)) {
    t0 <- proc.time()[["elapsed"]]
    h <- sel_local_search(ctx, 60, am, gd, mode = "anneal", iters = 60000,
                          seed = 1)
    e <- sel_exact(ctx, 60, am, gd, start = h, time_limit = 300)
    ex[[length(ex) + 1]] <- data.frame(
      scale = "book", N = ctx$N, n_sel = 60, alpha_max = am,
      heuristic = mean_index(h, ctx),
      incumbent = e$incumbent, dual = e$dual_bound, status = e$status,
      cuts = e$n_cuts, secs = proc.time()[["elapsed"]] - t0,
      gap_pct = 100 * (e$dual_bound - mean_index(h, ctx)) / abs(e$dual_bound))
  }
  write.csv(do.call(rbind, ex), file.path(data_dir, "search_exact_gap.csv"),
            row.names = FALSE)

  message("search_exact: done")
}

message("regenerate: complete")
