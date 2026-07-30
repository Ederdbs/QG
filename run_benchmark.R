# Benchmark of diversity metrics for hybrid selection via DE.
# Run with: Rscript run_benchmark.R

for (f in list.files("R", full.names = TRUE)) source(f)
dir.create("report", showWarnings = FALSE)

t0 <- Sys.time()
ctx <- load_data()
n_sel <- round(0.04 * ctx$N)   # same proportion as 200/5000
cat(sprintf("N = %d hybrids, m = %d markers, selecting %d (%.1f%%)\n",
            ctx$N, ctx$m, n_sel, 100 * n_sel / ctx$N))

# --- 1. Null distribution: the correct "0% loss" reference -------------------
cat("\n[1/5] null distribution...\n")
null <- null_distribution(ctx, n_sel)
gd_ref <- null$gd_ref
gd_pop <- gene_diversity(seq_len(ctx$N), ctx)
cat(sprintf("  GD population (N=%d) = %.5f\n", ctx$N, gd_pop))
cat(sprintf("  GD mean of random subsets (n=%d) = %.5f (sd %.5f)\n",
            n_sel, gd_ref, null$gd_sd))
cat(sprintf("  sampling bias if the population were used as reference: %.2f%%\n",
            100 * (gd_pop - gd_ref) / gd_pop))

# --- 2. Baseline strategies ----------------------------------------------------
cat("\n[2/5] baseline strategies...\n")
sels <- list(
  random          = sel_random(ctx, n_sel),
  truncation      = sel_truncation(ctx, n_sel),
  trunc_cap       = sel_truncation_cap(ctx, n_sel),
  greedy_div      = sel_greedy(ctx, n_sel, w = 0),
  ocs_greedy      = sel_greedy(ctx, n_sel, w = 3e-4)
)
a_trunc <- alpha_loss(sels$truncation, ctx, gd_ref)
cat(sprintf("  alpha of pure truncation (worst case) = %.2f%%\n", 100 * a_trunc))

# Greedy frontier: a cheap DE competitor and, more importantly, the warm start.
# Without this the DE ends up BELOW the greedy — not because the problem is
# hard, but because 4.5e5 evaluations aren't enough for 100 integer dimensions.
ws <- c(0, 1e-4, 2e-4, 3e-4, 5e-4, 1e-3, 3e-3)
greedy_pool <- lapply(ws, function(w) sel_greedy(ctx, n_sel, w = w))
greedy_front <- data.frame(
  w = ws,
  alpha = sapply(greedy_pool, alpha_loss, ctx = ctx, gd_ref = gd_ref),
  index = sapply(greedy_pool, mean_index, ctx = ctx))
write.csv(greedy_front, "report/greedy_frontier.csv", row.names = FALSE)

# --- 3. Constrained DE, alpha sweep ---------------------------------------------
cat("\n[3/5] constrained DE (this takes a while)...\n")
alphas <- round(seq(0, a_trunc, length.out = 6), 5)
seeds <- c(greedy_pool, list(sels$trunc_cap))
de <- lapply(alphas, function(a) {
  s <- sel_de(ctx, n_sel, alpha_max = a, gd_ref = gd_ref, seeds = seeds)
  cat(sprintf("  alpha_max = %.3f%%  ->  index %.3f, alpha achieved %.3f%%\n",
              100 * a, mean_index(s, ctx), 100 * alpha_loss(s, ctx, gd_ref)))
  s
})
names(de) <- sprintf("DE_alpha_%.2f%%", 100 * alphas)
sels <- c(sels, de)

# --- 4. Tables --------------------------------------------------------------------
cat("\n[4/5] metrics and tables...\n")
tab <- evaluate(sels, ctx, gd_ref)
write.csv(round(tab, 5), "report/metrics_by_strategy.csv")

zz <- discriminatory_power(tab, null)
write.csv(zz, "report/discriminatory_power.csv")

cost <- cost_per_eval(ctx, n_sel)
write.csv(cost, "report/cost_per_eval.csv", row.names = FALSE)

front <- data.frame(alpha = sapply(de, alpha_loss, ctx = ctx, gd_ref = gd_ref),
                    index = sapply(de, mean_index, ctx = ctx),
                    alpha_max = alphas)
relax <- ocs_relaxation(ctx, n_sel, lambdas = c(0, 10, 20, 50, 100, 150, 200, 300, 1000))
write.csv(round(relax, 5), "report/ocs_relaxation.csv", row.names = FALSE)

# Convergence diagnostic: best feasible solution of each competing method at
# the same alpha_max. A positive gap means the DE is winning.
best_at <- function(a, alpha_vec, index_vec) {
  ok <- alpha_vec <= a + 1e-9
  if (any(ok)) max(index_vec[ok]) else NA_real_
}
front$gap_vs_greedy <- round(front$index -
  sapply(front$alpha_max, best_at, greedy_front$alpha, greedy_front$index), 4)
front$gap_vs_relaxation <- round(front$index -
  sapply(front$alpha_max, best_at, (gd_ref - relax[, "GD"]) / gd_ref, relax[, "index"]), 4)
write.csv(front, "report/frontier.csv", row.names = FALSE)

# --- 5. Plots and summary -----------------------------------------------------
cat("[5/5] plots...\n")
plot_null(null, tab, "report/null.png")
plot_correlation(null, "report/metric_correlation.png")
plot_frontier(front, greedy_front, relax, tab, gd_ref, "report/gain_diversity_frontier.png")

cat("\n=== Summary =================================================\n")
print(round(tab[, c("index", "alpha", "GD", "Ns", "Ne_parents", "max_line",
                    "ENE", "alleles_lost")], 4))
cat("\n--- Gain vs. alpha frontier ---\n"); print(round(front, 4))
cat("\n--- Cost per evaluation (us) ---\n"); print(cost)
cat("\n--- Discriminatory power (standard deviations from the null) ---\n")
print(zz[, c("GD", "Ns", "offdiag", "Ne_parents", "ENE", "ANE", "eff_dim", "alleles_lost")])

keep <- apply(null$full, 2, sd) > 1e-10
C <- cor(null$full[, keep])
cat(sprintf("\ncor(GD, He) = %.10f   <- must equal 1: they are the same quantity\n",
            C["GD", "He"]))
cat(sprintf("cor(GD, offdiag) = %.4f   <- how much the current metric already captures\n",
            C["GD", "offdiag"]))
cat(sprintf("\nTotal time: %.1f min\n", as.numeric(difftime(Sys.time(), t0, units = "mins"))))
cat("Outputs in report/\n")
