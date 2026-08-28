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
if (!length(targets)) targets <- c("f2size", "benchmark", "identity")
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

message("regenerate: complete")
