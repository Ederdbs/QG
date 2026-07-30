# ETAPA 2 — seleção otimizada por evolução diferencial sob restrição de diversidade.
#
# Consome os três objetos da etapa 1 e devolve:
#   $selecao   data.frame N x (híbridos + uma coluna 0/1 por cenário)
#   $metricas  data.frame um cenário por linha, com métricas e perda alpha
#   $ref       gd_ref, alpha_max atingível, n_sel

# Reconstrói o ctx que as funções de métrica esperam.
montar_ctx <- function(X, f, hibridos, fL = NULL, pesos = NULL) {
  traits <- as.matrix(hibridos[, setdiff(names(hibridos),
                      c("hibrido", "linhagem_A", "linhagem_B")), drop = FALSE])
  if (is.null(pesos)) pesos <- rep(1, ncol(traits))
  stopifnot(length(pesos) == ncol(traits))

  ped <- data.frame(a = hibridos$linhagem_A, b = hibridos$linhagem_B)
  n_lines <- max(ped$a, ped$b)
  p_pop <- colMeans(X)

  list(X = X, f = f, traits = traits, ped = ped, fL = fL,
       n_lines = n_lines, N = nrow(X), m = ncol(X),
       index = as.numeric(scale(scale(traits) %*% pesos)),
       maf_pop = pmin(p_pop, 1 - p_pop))
}

etapa2_selecionar <- function(X, f, hibridos, n_sel,
                              alphas = NULL, pesos = NULL, fL = NULL,
                              incluir_referencias = TRUE,
                              B_nula = 2000, NP = 300, itermax = 2000,
                              seed = 1, verbose = TRUE) {
  set.seed(seed)
  ctx <- montar_ctx(X, f, hibridos, fL, pesos)
  say <- function(...) if (verbose) cat(...)

  # 1. Referência correta de "0% de perda": subconjuntos ALEATÓRIOS de tamanho
  #    n_sel, não a população completa (que carrega viés de amostragem).
  say(sprintf("[1/4] nula por reamostragem (B = %d)...\n", B_nula))
  gd_rand <- replicate(B_nula, gene_diversity(sample.int(ctx$N, n_sel), ctx))
  gd_ref <- mean(gd_rand)
  vies <- (gene_diversity(seq_len(ctx$N), ctx) - gd_ref) / gd_ref
  say(sprintf("      GD referência = %.5f (sd %.5f); viés se usasse a população: %.2f%%\n",
              gd_ref, sd(gd_rand), 100 * vies))

  # 2. Teto de perda atingível. Acima dele a restrição é inoperante.
  sel_trunc <- sel_truncation(ctx, n_sel)
  alpha_max <- alpha_loss(sel_trunc, ctx, gd_ref)
  say(sprintf("[2/4] alpha máximo atingível (truncamento puro) = %.2f%%\n", 100 * alpha_max))

  if (is.null(alphas)) alphas <- seq(0, alpha_max, length.out = 5)
  inop <- alphas > alpha_max + 1e-9
  if (any(inop)) warning(sprintf(
    "alphas inoperantes (acima do teto de %.2f%%): %s — nesses cenários a restrição não restringe nada",
    100 * alpha_max, paste0(round(100 * alphas[inop], 2), "%", collapse = ", ")))

  # 3. Warm start. Sem isto o DE termina ABAIXO de um greedy simples.
  say("[3/4] warm start (greedy) e DE por cenário...\n")
  ws <- c(0, 1e-4, 2e-4, 3e-4, 5e-4, 1e-3, 3e-3)
  seeds <- c(lapply(ws, function(w) sel_greedy(ctx, n_sel, w = w)),
             list(sel_truncation_cap(ctx, n_sel)))

  cenarios <- list()
  for (a in alphas) {
    idx <- sel_de(ctx, n_sel, alpha_max = a, gd_ref = gd_ref,
                  NP = NP, itermax = itermax, seeds = seeds)
    nome <- sprintf("DE_alpha_%.2f", 100 * a)
    cenarios[[nome]] <- idx
    say(sprintf("      %-16s índice %.3f | alpha obtido %.3f%% | Ns %.4f | Ne_par %.1f\n",
                nome, mean_index(idx, ctx), 100 * alpha_loss(idx, ctx, gd_ref),
                status_number(idx, ctx), ne_parents(idx, ctx)))
  }

  if (incluir_referencias) {
    cenarios <- c(cenarios, list(
      ref_truncamento = sel_trunc,
      ref_trunc_cap   = sel_truncation_cap(ctx, n_sel),
      ref_max_div     = sel_greedy(ctx, n_sel, w = 0),
      ref_aleatorio   = sample.int(ctx$N, n_sel)))
  }

  # 4. Métricas por cenário e tabela de seleção.
  say("[4/4] métricas por cenário...\n")
  met <- t(sapply(cenarios, metrics_full, ctx = ctx))
  metricas <- data.frame(
    cenario = names(cenarios),
    alpha_max = c(alphas, rep(NA, length(cenarios) - length(alphas))),
    alpha = (gd_ref - met[, "GD"]) / gd_ref,
    met, row.names = NULL, check.names = FALSE)

  selecao <- hibridos
  for (nm in names(cenarios)) selecao[[nm]] <- as.integer(seq_len(ctx$N) %in% cenarios[[nm]])

  # Quantos cenários escolheram cada híbrido: os robustos aparecem em todos.
  selecao$n_cenarios <- rowSums(selecao[, names(cenarios), drop = FALSE])

  list(selecao = selecao, metricas = metricas,
       ref = list(gd_ref = gd_ref, alpha_max = alpha_max, n_sel = n_sel,
                  vies_populacao = vies))
}
