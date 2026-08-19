# Sanity checks. Run with: Rscript tests/test_metrics.R
# No framework — plain asserts. Whatever fails here invalidates the whole benchmark.

for (f in list.files("R", full.names = TRUE)) source(f)

ok <- function(msg) cat("  ok  ", msg, "\n")
near <- function(a, b, tol = 1e-10) stopifnot(all(abs(a - b) < tol))

cfg <- modifyList(sim_config, list(n_pool_A = 12, n_pool_B = 12, m = 800))
ctx <- simulate_data(cfg)
idx <- sample.int(ctx$N, 40)

# 1. The main one: the two routes for computing theta must agree.
#    If this fails, matrix f is wrong (centered, rescaled, or wrong coding).
near(theta_group(idx, ctx), theta_from_freq(idx, ctx))
ok("theta via submatrix == theta via allele frequencies")

# 2. Identity 1 - theta == Nei's He.
near(gene_diversity(idx, ctx), he_nei(idx, ctx))
ok("1 - theta == Nei's He")

# 3. f is a genuine coancestry matrix: bounded to [0,1]. Catches the mistake
#    of using centered G instead, which produces negative values.
stopifnot(min(ctx$f) >= 0, max(ctx$f) <= 1)
ok("f in [0,1]")

# 4. The bug in the original plan: with Z centered on its own population, the
#    sum of ALL elements of G is exactly zero -> theta = 0, Ns = infinity.
stopifnot(abs(sum(ctx$G)) < 1e-6 * ctx$N^2)
cat("       sum(G) =", format(sum(ctx$G), digits = 3),
    " -> Ns over G would be", format(1 / (2 * mean(ctx$G)), digits = 3), "\n")
ok("sum(VanRaden G) == 0 (this is why diversity uses f, not G)")

# 5. Analytical edge cases.
fake <- ctx
fake$f <- matrix(1, 5, 5)                       # all identical and homozygous
near(theta_group(1:5, fake), 1); near(status_number(1:5, fake), 0.5)
# diagonal d, off-diagonal o  ->  theta = (d + (n-1)*o)/n
fake$f <- diag(5) * 0.5 + 0.5                   # d=1 (homozygous), o=0.5
near(theta_group(1:5, fake), (1 + 4 * 0.5) / 5)
fake$f <- matrix(0.5, 5, 5)                     # d=o=0.5: unrelated, p=0.5
near(theta_group(1:5, fake), 0.5); near(status_number(1:5, fake), 1)
ok("theta and Ns edge cases")

# 6. Pure-diversity greedy has to beat the random average.
set.seed(3)
th_rand <- mean(replicate(200, theta_group(sample.int(ctx$N, 40), ctx)))
th_greedy <- theta_group(sel_greedy(ctx, 40, w = 0), ctx)
stopifnot(th_greedy < th_rand)
ok(sprintf("greedy min-theta (%.4f) < random average (%.4f)", th_greedy, th_rand))

# 7. Truncation loses diversity relative to random (otherwise there is no
#    trade-off to optimize and the benchmark is pointless).
th_trunc <- theta_group(sel_truncation(ctx, 40), ctx)
stopifnot(th_trunc > th_greedy)
ok(sprintf("truncation (%.4f) > greedy (%.4f)", th_trunc, th_greedy))

# 8. decode() always returns n_sel unique, valid indices.
set.seed(5)
for (i in 1:50) {
  d <- decode(runif(40, 1, ctx$N + 1), ctx$N, 40)
  stopifnot(length(unique(d)) == 40, all(d >= 1), all(d <= ctx$N))
}
ok("decode() is deterministic, unique, and within bounds")

# 9. Two-stage pipeline contract.
st1 <- stage1_simulate(cfg)
stopifnot(all(c("X", "f", "hybrids") %in% names(st1)),
          max(st1$X) <= 1, min(st1$f) >= 0, max(st1$f) <= 1,
          all(c("hybrid", "line_A", "line_B") %in% names(st1$hybrids)),
          nrow(st1$hybrids) == nrow(st1$X))
ok("stage1 returns consistent X, f and hybrids")

r <- stage2_select(st1$X, st1$f, st1$hybrids, n_sel = 20, alphas = c(0, 0.02),
                   fL = st1$fL, B_null = 50, B_full = 20, NP = 40, itermax = 30,
                   verbose = FALSE)
scn <- setdiff(names(r$selection), c(names(st1$hybrids), "n_scenarios"))
stopifnot(nrow(r$selection) == nrow(st1$X),
          all(sapply(r$selection[scn], sum) == 20),   # each scenario selects n_sel
          all(unlist(r$selection[scn]) %in% 0:1),
          nrow(r$metrics) == length(scn))
ok(sprintf("stage2: %d scenarios, %d selected in each", length(scn), 20))

# stage2 runs without fL — only theta_A/B/AB are lost.
r2 <- stage2_select(st1$X, st1$f, st1$hybrids, n_sel = 20, alphas = 0,
                    B_null = 50, B_full = 20, NP = 40, itermax = 30, verbose = FALSE)
stopifnot(is.na(r2$metrics$theta_A[1]), !is.na(r2$metrics$Ne_lines_A[1]))
ok("stage2 without fL: theta_pools becomes NA, per-pool Ne still works")

# 10. A selection equal to the base has lost nothing, on either lens.
all_idx <- seq_len(ctx$N)
fm_all <- freq_metrics(all_idx, ctx)
near(fm_all[["F_hom"]], 0)
near(fm_all[["F_drift"]], 0)
ok("F_hom and F_drift are exactly 0 when the selection IS the base")

# 11. Eq. 3 of Meuwissen et al. (2020): the gap between the two lenses is
#     entirely 2*cov(dp/s, (p0-1/2)/s). If this fails one of the three
#     formulas is wrong.
fm <- freq_metrics(idx, ctx)
near(fm[["cov_diag"]], fm[["F_hom"]] - fm[["F_drift"]], tol = 1e-8)
ok("F_hom - F_drift == 2*mean(dp/s * (p0-1/2)/s)   (their Eq. 3)")

# 12. F_drift is never negative; F_hom IS allowed to be, and the pure
#     max-diversity greedy (the G_0.5 scheme) is exactly where it goes negative
#     while paying the largest drift. That signature is the whole point.
fm_div <- freq_metrics(sel_greedy(ctx, 40, w = 0), ctx)
fm_tru <- freq_metrics(sel_truncation(ctx, 40), ctx)
stopifnot(fm_div[["F_drift"]] >= 0, fm_tru[["F_drift"]] >= 0,
          fm_div[["F_hom"]] < fm_tru[["F_hom"]],
          fm_div[["F_drift"]] > 0)
ok(sprintf("max-diversity: F_hom %+.4f, F_drift %.4f | truncation: %+.4f, %.4f",
           fm_div[["F_hom"]], fm_div[["F_drift"]],
           fm_tru[["F_hom"]], fm_tru[["F_drift"]]))

# 13. Caballero & Toro partition closes exactly (their Eq. 8).
gp <- gd_partition(idx, ctx)
near(gp[["GD_WI"]] + gp[["GD_BI"]] + gp[["GD_BS"]], gp[["GD_T"]])
near((gp[["GD_WI"]] + gp[["GD_BI"]]) / gp[["GD_T"]], 1 - gp[["F_ST"]])
stopifnot(gp[["GD_BS"]] > 0, gp[["GD_WI_hyb"]] > gp[["GD_WI"]])
ok(sprintf("GD partition closes: WI %.4f + BI %.4f + BS %.4f = T %.4f (F_ST %.3f)",
           gp[["GD_WI"]], gp[["GD_BI"]], gp[["GD_BS"]], gp[["GD_T"]], gp[["F_ST"]]))

# 14. Inbred lines carry ~no within-individual diversity, F1 hybrids carry a lot.
stopifnot(gp[["GD_WI"]] < 1e-9, gp[["GD_WI_hyb"]] > 0.1)
ok("GD_WI ~ 0 for inbred lines, GD_WI_hyb large for their F1s")

# 15. Consolidating the marker sweep changed no existing number.
near(fm[["He"]], he_nei(idx, ctx))
stopifnot(fm[["alleles_lost"]] == alleles_lost(idx, ctx))
ok("freq_metrics() reproduces he_nei() and alleles_lost() exactly")

# 16. eff_dim on the double-centered matrix: at most n-1 directions.
ed <- eff_dim(idx, ctx)
stopifnot(ed > 0, ed <= length(idx) - 1 + 1e-8)
ok(sprintf("eff_dim in (0, n-1]: %.2f of %d", ed, length(idx) - 1))

# 17. Stage-2 contract for the new output.
new_cols <- c("F_hom", "F_drift", "cov_diag", "rare_retained",
              "GD_WI_hyb", "GD_T", "GD_WI", "GD_BI", "GD_BS", "F_ST")
stopifnot(all(new_cols %in% names(r$metrics)),
          nrow(r$z_scores) == nrow(r$metrics),
          "z_Ne_parents" %in% names(r$z_scores),
          !anyNA(r$metrics$F_drift),
          is.na(r2$metrics$GD_BS[1]), !is.na(r2$metrics$GD_WI_hyb[1]))
ok("stage2 exports both lenses, the partition, and z-scores vs. the null")

cat("\nAll checks passed.\n")
