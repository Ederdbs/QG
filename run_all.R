# Pipeline em duas etapas. Rodar: Rscript run_all.R
#
#   ETAPA 1  genótipos das linhagens -> X, f, hibridos
#   ETAPA 2  X, f, hibridos          -> seleção por DE em vários cenários de alpha
#
# O benchmark de métricas (nula, poder discriminatório, gráficos) está em
# run_benchmark.R e é independente deste pipeline.

for (f in list.files("R", full.names = TRUE)) source(f)
dir.create("report", showWarnings = FALSE)
t0 <- Sys.time()

# --- ETAPA 1 ----------------------------------------------------------------
cat("=== ETAPA 1: simulação dos híbridos ===\n")
st1 <- etapa1_simular()
cat(sprintf("  X: %d híbridos x %d marcadores  |  f: %d x %d, valores em [%.3f, %.3f]\n",
            nrow(st1$X), ncol(st1$X), nrow(st1$f), ncol(st1$f),
            min(st1$f), max(st1$f)))
cat("  hibridos:", paste(names(st1$hibridos), collapse = ", "), "\n\n")

# Com dados reais, troque a linha acima por:
#   st1 <- etapa1_montar(X = minha_matriz_hibridos, ped = meu_pedigree,
#                        traits = meus_traits_preditos)

# --- ETAPA 2 ----------------------------------------------------------------
cat("=== ETAPA 2: seleção otimizada por DE ===\n")
n_sel <- round(0.04 * nrow(st1$X))   # mesma proporção de 200/5000

res <- etapa2_selecionar(
  X = st1$X, f = st1$f, hibridos = st1$hibridos,
  n_sel = n_sel,
  alphas = NULL,        # NULL = grade automática de 0 até o teto atingível
  pesos = NULL,         # NULL = peso igual entre traits
  fL = st1$fL           # opcional: habilita theta_A / theta_B / theta_AB
)

write.csv(res$selecao, "report/selecao_por_cenario.csv", row.names = FALSE)
write.csv(res$metricas, "report/metricas_por_cenario.csv", row.names = FALSE)

# --- Resumo -----------------------------------------------------------------
cat("\n=== Métricas por cenário ===\n")
print(res$metricas[, c("cenario", "alpha", "index", "Ns", "Ne_parents",
                       "Ne_linhas_A", "Ne_linhas_B", "max_line", "alleles_lost")],
      digits = 4, row.names = FALSE)

cenarios <- setdiff(names(res$selecao),
                    c(names(st1$hibridos), "n_cenarios"))
cat("\n=== Tabela de seleção (primeiras linhas) ===\n")
print(head(res$selecao[order(-res$selecao$n_cenarios), c("hibrido", "linhagem_A",
      "linhagem_B", cenarios, "n_cenarios")], 8), row.names = FALSE)

cat(sprintf("\nHíbridos escolhidos em TODOS os %d cenários de DE: %d\n",
            sum(grepl("^DE_", cenarios)),
            sum(rowSums(res$selecao[, grep("^DE_", cenarios, value = TRUE)]) ==
                  sum(grepl("^DE_", cenarios)))))
cat(sprintf("Híbridos nunca escolhidos: %d de %d\n",
            sum(res$selecao$n_cenarios == 0), nrow(res$selecao)))
cat(sprintf("\nTempo total: %.1f min | saídas em report/\n",
            as.numeric(difftime(Sys.time(), t0, units = "mins"))))
