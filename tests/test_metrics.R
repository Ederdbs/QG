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
                   B_null = 50, NP = 40, itermax = 30, verbose = FALSE)
scn <- setdiff(names(r$selection), c(names(st1$hybrids), "n_scenarios"))
stopifnot(nrow(r$selection) == nrow(st1$X),
          all(sapply(r$selection[scn], sum) == 20),   # each scenario selects n_sel
          all(unlist(r$selection[scn]) %in% 0:1),
          nrow(r$metrics) == length(scn))
ok(sprintf("stage2: %d scenarios, %d selected in each", length(scn), 20))

# stage2 runs without fL — only theta_A/B/AB are lost.
r2 <- stage2_select(st1$X, st1$f, st1$hybrids, n_sel = 20, alphas = 0,
                    B_null = 50, NP = 40, itermax = 30, verbose = FALSE)
stopifnot(is.na(r2$metrics$theta_A[1]), !is.na(r2$metrics$Ne_lines_A[1]))
ok("stage2 without fL: theta_pools becomes NA, per-pool Ne still works")

cat("\nAll checks passed.\n")
