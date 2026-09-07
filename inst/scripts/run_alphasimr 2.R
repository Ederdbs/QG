#!/usr/bin/env Rscript
# =============================================================================
#  run_alphasimr.R -- reciprocal recurrent selection, two heterotic pools
#
#  Runs the AlphaSimR bridge (R/13_alphasimr_bridge.R) at a heavier scale than
#  the book, then feeds the resulting hybrid pool through the package's own
#  stage2_select() unchanged. Writes the CSVs the book reads.
#
#  The engine is in the package (rrs_config, alphasimr_pipeline() and the
#  functions it calls); this is the driver only -- the production-scale run
#  and the CLI, same split as inst/scripts/run_mabc.R.
#
#  To refresh the cached tables:
#    Rscript inst/scripts/run_alphasimr.R --out=report/alphasimr
#    cp report/alphasimr/cycles.csv   book/data/alphasimr_cycles.csv
#    cp report/alphasimr/metrics.csv book/data/alphasimr_metrics.csv
#
#  Usage:
#    Rscript inst/scripts/run_alphasimr.R --test          # smoke run, ~10 s
#    Rscript inst/scripts/run_alphasimr.R --out=DIR        # full run, ~2 min
#
#  Dependencies: hybdiv, AlphaSimR.
# =============================================================================

suppressPackageStartupMessages(library(hybdiv))
if (!requireNamespace("AlphaSimR", quietly = TRUE))
  stop("Package 'AlphaSimR' is required. Install it with install.packages('AlphaSimR').")

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  outdir <- sub("^--out=", "", grep("^--out=", args, value = TRUE))
  if (length(outdir) == 0) outdir <- "alphasimr_out"

  cfg <- if ("--test" %in% args) {
    modifyList(rrs_config, list(n_pool_A = 6, n_pool_B = 6, n_dh = 2, n_sel = 3,
                                n_testers = 2, n_cycles = 2, seg_sites = 30,
                                n_chr = 2, n_traits = 1))
  } else {
    modifyList(rrs_config, list(n_pool_A = 40, n_pool_B = 40, n_dh = 4, n_sel = 12,
                                n_testers = 3, n_cycles = 6, seg_sites = 400,
                                n_chr = 10, n_traits = 3))
  }

  cat(sprintf("=== Reciprocal recurrent selection: %d cycles, pools of %d/%d ===\n",
              cfg$n_cycles, cfg$n_pool_A, cfg$n_pool_B))
  t0 <- Sys.time()
  res <- alphasimr_pipeline(cfg)
  cat(sprintf("Elapsed: %.1f s\n", as.numeric(difftime(Sys.time(), t0, units = "secs"))))

  st1 <- res$stage1
  sel <- stage2_select(st1$X, st1$f, st1$hybrids, n_sel = min(20, nrow(st1$X)),
                       fL = st1$fL)

  dir.create(outdir, showWarnings = FALSE, recursive = TRUE)
  write.csv(res$cycles, file.path(outdir, "cycles.csv"), row.names = FALSE)
  write.csv(sel$metrics, file.path(outdir, "metrics.csv"), row.names = FALSE)

  cat("\n--- CYCLE TRAJECTORY ---\n")
  print(res$cycles, row.names = FALSE)
  cat("\n--- FINAL HYBRID POOL: stage2_select() metrics ---\n")
  print(sel$metrics, row.names = FALSE)
}

if (identical(environment(), globalenv())) main()
