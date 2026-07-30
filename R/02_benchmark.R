# Benchmark: null distribution, strategy comparison, gain-vs-alpha frontier.

# The "0% loss" reference is the distribution of RANDOM subsets of size n_sel —
# not the population of 5000. Comparing directly against the full matrix
# confounds a sampling effect with a selection effect.
null_distribution <- function(ctx, n_sel, B = 2000, B_full = 200, seed = 7) {
  set.seed(seed)
  cheap <- t(replicate(B, metrics_cheap(sample.int(ctx$N, n_sel), ctx)))
  full <- t(replicate(B_full, metrics_full(sample.int(ctx$N, n_sel), ctx)))
  list(cheap = cheap, full = full,
       gd_ref = mean(cheap[, "GD"]), gd_sd = sd(cheap[, "GD"]))
}

# alpha = relative loss of gene diversity against the random reference.
# Negative = more diverse than a random sample.
alpha_loss <- function(idx, ctx, gd_ref) (gd_ref - gene_diversity(idx, ctx)) / gd_ref

evaluate <- function(sels, ctx, gd_ref) {
  out <- t(sapply(sels, metrics_full, ctx = ctx))
  cbind(out, alpha = (gd_ref - out[, "GD"]) / gd_ref)
}

# How many standard deviations from the null each metric places each strategy.
# A metric that doesn't separate truncation from random is useless as a constraint.
discriminatory_power <- function(tab, null) {
  mu <- colMeans(null$full); sdv <- apply(null$full, 2, sd)
  cols <- intersect(colnames(tab), names(mu))
  z <- sweep(sweep(tab[, cols, drop = FALSE], 2, mu[cols]), 2, pmax(sdv[cols], 1e-12), "/")
  round(z, 2)
}

# Cost per evaluation: decides what can go inside the DE fitness (~1e5 calls).
cost_per_eval <- function(ctx, n_sel, reps = 30) {
  fns <- list(theta_group = theta_group, theta_from_freq = theta_from_freq,
              ne_parents = ne_parents, alleles_lost = alleles_lost,
              ENE = ene, ANE = ane, eff_dim = eff_dim, Gst = gst)
  idx <- sample.int(ctx$N, n_sel)
  data.frame(
    metric = names(fns),
    us_per_eval = round(sapply(fns, function(f)
      1e6 * system.time(for (i in seq_len(reps)) f(idx, ctx))[["elapsed"]] / reps), 1),
    row.names = NULL
  )
}

# --- Plots (base R, no dependencies) -----------------------------------------

plot_null <- function(null, tab, file) {
  vars <- c("GD", "Ns", "Ne_parents", "ENE")
  png(file, width = 1100, height = 850, res = 110)
  op <- par(mfrow = c(2, 2), mar = c(4, 4, 3, 1))
  cols <- rainbow(nrow(tab), v = 0.8)
  for (v in vars) {
    hist(null$full[, v], breaks = 25, col = "grey85", border = "white",
         main = v, xlab = v,
         xlim = range(c(null$full[, v], tab[, v]), finite = TRUE))
    abline(v = tab[, v], col = cols, lwd = 2)
  }
  plot.new(); legend("center", rownames(tab), col = cols, lwd = 2, bty = "n", cex = 0.8)
  par(op); dev.off()
}

plot_correlation <- function(null, file) {
  keep <- apply(null$full, 2, sd) > 1e-10
  C <- cor(null$full[, keep])
  png(file, width = 950, height = 900, res = 110)
  op <- par(mar = c(8, 8, 2, 2))
  image(seq_len(ncol(C)), seq_len(ncol(C)), t(C[ncol(C):1, ]), axes = FALSE,
        xlab = "", ylab = "", zlim = c(-1, 1),
        col = colorRampPalette(c("#2166ac", "white", "#b2182b"))(64))
  axis(1, seq_len(ncol(C)), colnames(C), las = 2, cex.axis = 0.75)
  axis(2, seq_len(ncol(C)), rev(colnames(C)), las = 2, cex.axis = 0.75)
  for (i in seq_len(ncol(C))) for (j in seq_len(ncol(C)))
    text(i, ncol(C) - j + 1, sprintf("%.2f", C[j, i]), cex = 0.55)
  par(op); dev.off()
}

plot_frontier <- function(front, greedy_front, relax, tab, gd_ref, file) {
  a_relax <- (gd_ref - relax[, "GD"]) / gd_ref
  png(file, width = 1000, height = 750, res = 110)
  op <- par(mar = c(4.5, 4.5, 3, 1))
  plot(front$alpha * 100, front$index, type = "b", pch = 19, lwd = 2, col = "#b2182b",
       xlab = "gene diversity loss, alpha (%)",
       ylab = "mean index of selected (deviations)",
       main = "Gain vs. diversity frontier",
       xlim = range(c(front$alpha, greedy_front$alpha, a_relax) * 100),
       ylim = range(c(front$index, greedy_front$index, relax[, "index"], tab[, "index"])))
  lines(greedy_front$alpha * 100, greedy_front$index, type = "b", pch = 17, col = "#2166ac")
  lines(sort(a_relax) * 100, relax[order(a_relax), "index"], type = "b", pch = 1,
        col = "grey55", lty = 2)
  points(tab[, "alpha"] * 100, tab[, "index"], pch = 4, col = "grey40")
  text(tab[, "alpha"] * 100, tab[, "index"], rownames(tab), pos = 4, cex = 0.6, col = "grey30")
  abline(v = 0, lty = 3)
  legend("bottomright",
         c("constrained DE", "greedy (w)", "continuous OCS relaxation", "other"),
         col = c("#b2182b", "#2166ac", "grey55", "grey40"), pch = c(19, 17, 1, 4),
         lwd = c(2, 1, 1, NA), lty = c(1, 1, 2, NA), bty = "n", cex = 0.75)
  par(op); dev.off()
}
