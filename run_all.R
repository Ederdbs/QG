# Benchmark de métricas de diversidade para seleção de híbridos via DE.
# Rodar: Rscript run_all.R

for (f in list.files("R", full.names = TRUE)) source(f)
dir.create("report", showWarnings = FALSE)

t0 <- Sys.time()
ctx <- load_data()
n_sel <- round(0.04 * ctx$N)   # mesma proporção de 200/5000
cat(sprintf("N = %d híbridos, m = %d marcadores, selecionando %d (%.1f%%)\n",
            ctx$N, ctx$m, n_sel, 100 * n_sel / ctx$N))

# --- 1. Distribuição nula: a referência correta de "0%% de perda" -----------
cat("\n[1/5] distribuição nula...\n")
null <- null_distribution(ctx, n_sel)
gd_ref <- null$gd_ref
gd_pop <- gene_diversity(seq_len(ctx$N), ctx)
cat(sprintf("  GD população (N=%d) = %.5f\n", ctx$N, gd_pop))
cat(sprintf("  GD média de subconjuntos aleatórios (n=%d) = %.5f (sd %.5f)\n",
            n_sel, gd_ref, null$gd_sd))
cat(sprintf("  viés de amostragem se usasse a população como referência: %.2f%%\n",
            100 * (gd_pop - gd_ref) / gd_pop))

# --- 2. Estratégias baseline ------------------------------------------------
cat("\n[2/5] estratégias baseline...\n")
sels <- list(
  aleatorio       = sel_random(ctx, n_sel),
  truncamento     = sel_truncation(ctx, n_sel),
  trunc_cap       = sel_truncation_cap(ctx, n_sel),
  greedy_div      = sel_greedy(ctx, n_sel, w = 0),
  ocs_greedy      = sel_greedy(ctx, n_sel, w = 3e-4)
)
a_trunc <- alpha_loss(sels$truncamento, ctx, gd_ref)
cat(sprintf("  alpha do truncamento puro (pior caso) = %.2f%%\n", 100 * a_trunc))

# Fronteira do greedy: competidor barato do DE e, sobretudo, warm start.
# Sem isto o DE fica ABAIXO do greedy — não é que o problema seja difícil,
# é que 4.5e5 avaliações não bastam para 100 dimensões inteiras.
ws <- c(0, 1e-4, 2e-4, 3e-4, 5e-4, 1e-3, 3e-3)
greedy_pool <- lapply(ws, function(w) sel_greedy(ctx, n_sel, w = w))
greedy_front <- data.frame(
  w = ws,
  alpha = sapply(greedy_pool, alpha_loss, ctx = ctx, gd_ref = gd_ref),
  index = sapply(greedy_pool, mean_index, ctx = ctx))
write.csv(greedy_front, "report/fronteira_greedy.csv", row.names = FALSE)

# --- 3. DE com restrição, varredura de alpha --------------------------------
cat("\n[3/5] DE com restrição (isto demora)...\n")
alphas <- round(seq(0, a_trunc, length.out = 6), 5)
seeds <- c(greedy_pool, list(sels$trunc_cap))
de <- lapply(alphas, function(a) {
  s <- sel_de(ctx, n_sel, alpha_max = a, gd_ref = gd_ref, seeds = seeds)
  cat(sprintf("  alpha_max = %.3f%%  ->  índice %.3f, alpha obtido %.3f%%\n",
              100 * a, mean_index(s, ctx), 100 * alpha_loss(s, ctx, gd_ref)))
  s
})
names(de) <- sprintf("DE_alpha_%.2f%%", 100 * alphas)
sels <- c(sels, de)

# --- 4. Tabelas -------------------------------------------------------------
cat("\n[4/5] métricas e tabelas...\n")
tab <- evaluate(sels, ctx, gd_ref)
write.csv(round(tab, 5), "report/metricas_por_estrategia.csv")

zz <- discriminatory_power(tab, null)
write.csv(zz, "report/poder_discriminatorio.csv")

custo <- cost_per_eval(ctx, n_sel)
write.csv(custo, "report/custo_por_avaliacao.csv", row.names = FALSE)

front <- data.frame(alpha = sapply(de, alpha_loss, ctx = ctx, gd_ref = gd_ref),
                    index = sapply(de, mean_index, ctx = ctx),
                    alpha_max = alphas)
relax <- ocs_relaxation(ctx, n_sel, lambdas = c(0, 10, 20, 50, 100, 150, 200, 300, 1000))
write.csv(round(relax, 5), "report/ocs_relaxamento.csv", row.names = FALSE)

# Diagnóstico de convergência: melhor solução viável de cada método concorrente
# no mesmo alpha_max. Gap positivo = o DE está ganhando.
best_at <- function(a, alpha_vec, index_vec) {
  ok <- alpha_vec <= a + 1e-9
  if (any(ok)) max(index_vec[ok]) else NA_real_
}
front$gap_vs_greedy <- round(front$index -
  sapply(front$alpha_max, best_at, greedy_front$alpha, greedy_front$index), 4)
front$gap_vs_relaxamento <- round(front$index -
  sapply(front$alpha_max, best_at, (gd_ref - relax[, "GD"]) / gd_ref, relax[, "index"]), 4)
write.csv(front, "report/fronteira.csv", row.names = FALSE)

# --- 5. Gráficos e resumo ---------------------------------------------------
cat("[5/5] gráficos...\n")
plot_null(null, tab, "report/nula.png")
plot_correlation(null, "report/correlacao_metricas.png")
plot_frontier(front, greedy_front, relax, tab, gd_ref, "report/fronteira_ganho_diversidade.png")

cat("\n=== Resumo =================================================\n")
print(round(tab[, c("index", "alpha", "GD", "Ns", "Ne_parents", "max_line",
                    "ENE", "alleles_lost")], 4))
cat("\n--- Fronteira ganho x alpha ---\n"); print(round(front, 4))
cat("\n--- Custo por avaliação (us) ---\n"); print(custo)
cat("\n--- Poder discriminatório (desvios da nula) ---\n")
print(zz[, c("GD", "Ns", "offdiag", "Ne_parents", "ENE", "ANE", "eff_dim", "alleles_lost")])

keep <- apply(null$full, 2, sd) > 1e-10
C <- cor(null$full[, keep])
cat(sprintf("\ncor(GD, He) = %.10f   <- têm que ser 1: são a mesma quantidade\n",
            C["GD", "He"]))
cat(sprintf("cor(GD, offdiag) = %.4f   <- o quanto a métrica atual já captura\n",
            C["GD", "offdiag"]))
cat(sprintf("\nTempo total: %.1f min\n", as.numeric(difftime(Sys.time(), t0, units = "mins"))))
cat("Saídas em report/\n")
