# Two-stage pipeline. Run with: Rscript run_all.R
#
#   STAGE 1  line genotypes -> X, f, hybrids
#   STAGE 2  X, f, hybrids  -> DE selection across several alpha scenarios
#
# The metrics benchmark (null distribution, discriminatory power, plots) lives
# in run_benchmark.R and is independent of this pipeline.

for (f in list.files("R", full.names = TRUE)) source(f)
dir.create("report", showWarnings = FALSE)
t0 <- Sys.time()

# --- STAGE 1 ------------------------------------------------------------------
cat("=== STAGE 1: hybrid simulation ===\n")
st1 <- stage1_simulate()
cat(sprintf("  X: %d hybrids x %d markers  |  f: %d x %d, values in [%.3f, %.3f]\n",
            nrow(st1$X), ncol(st1$X), nrow(st1$f), ncol(st1$f),
            min(st1$f), max(st1$f)))
cat("  hybrids:", paste(names(st1$hybrids), collapse = ", "), "\n\n")

# With real data, replace the line above with:
#   st1 <- stage1_build(X = my_hybrid_matrix, ped = my_pedigree,
#                       traits = my_predicted_traits)

# --- STAGE 2 ------------------------------------------------------------------
cat("=== STAGE 2: DE-optimized selection ===\n")
n_sel <- round(0.04 * nrow(st1$X))   # same proportion as 200/5000

res <- stage2_select(
  X = st1$X, f = st1$f, hybrids = st1$hybrids,
  n_sel = n_sel,
  alphas = NULL,        # NULL = automatic grid from 0 to the attainable ceiling
  weights = NULL,       # NULL = equal weight across traits
  fL = st1$fL           # optional: enables theta_A / theta_B / theta_AB
)

write.csv(res$selection, "report/selection_by_scenario.csv", row.names = FALSE)
write.csv(res$metrics, "report/metrics_by_scenario.csv", row.names = FALSE)

# --- Summary --------------------------------------------------------------------
cat("\n=== Metrics per scenario ===\n")
print(res$metrics[, c("scenario", "alpha", "index", "Ns", "Ne_parents",
                      "Ne_lines_A", "Ne_lines_B", "max_line", "alleles_lost")],
      digits = 4, row.names = FALSE)

scenarios <- setdiff(names(res$selection),
                     c(names(st1$hybrids), "n_scenarios"))
cat("\n=== Selection table (first rows) ===\n")
print(head(res$selection[order(-res$selection$n_scenarios), c("hybrid", "line_A",
      "line_B", scenarios, "n_scenarios")], 8), row.names = FALSE)

cat(sprintf("\nHybrids chosen in ALL %d DE scenarios: %d\n",
            sum(grepl("^DE_", scenarios)),
            sum(rowSums(res$selection[, grep("^DE_", scenarios, value = TRUE)]) ==
                  sum(grepl("^DE_", scenarios)))))
cat(sprintf("Hybrids never chosen: %d of %d\n",
            sum(res$selection$n_scenarios == 0), nrow(res$selection)))
cat(sprintf("\nTotal time: %.1f min | outputs in report/\n",
            as.numeric(difftime(Sys.time(), t0, units = "mins"))))
