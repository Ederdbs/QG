# Checagens de sanidade. Rodar: Rscript tests/test_metrics.R
# Sem framework — asserts. O que falha aqui invalida o benchmark inteiro.

for (f in list.files("R", full.names = TRUE)) source(f)

ok <- function(msg) cat("  ok  ", msg, "\n")
near <- function(a, b, tol = 1e-10) stopifnot(all(abs(a - b) < tol))

cfg <- modifyList(sim_config, list(n_pool_A = 12, n_pool_B = 12, m = 800))
ctx <- simulate_data(cfg)
idx <- sample.int(ctx$N, 40)

# 1. A principal: as duas rotas de cálculo de theta têm que bater.
#    Se falhar, a matriz f está errada (centrada, escalada, ou coding trocado).
near(theta_group(idx, ctx), theta_from_freq(idx, ctx))
ok("theta via submatriz == theta via frequências alélicas")

# 2. Identidade 1 - theta == He de Nei.
near(gene_diversity(idx, ctx), he_nei(idx, ctx))
ok("1 - theta == He de Nei")

# 3. f é coancestria de verdade: limitada a [0,1]. Pega o erro de usar a G
#    centrada por engano, que produz valores negativos.
stopifnot(min(ctx$f) >= 0, max(ctx$f) <= 1)
ok("f em [0,1]")

# 4. O bug do plano original: com Z centrada na própria população, a soma de
#    TODOS os elementos de G é exatamente zero -> theta = 0, Ns = infinito.
stopifnot(abs(sum(ctx$G)) < 1e-6 * ctx$N^2)
cat("       sum(G) =", format(sum(ctx$G), digits = 3),
    " -> Ns sobre G seria", format(1 / (2 * mean(ctx$G)), digits = 3), "\n")
ok("sum(G de VanRaden) == 0 (por isso a diversidade usa f, não G)")

# 5. Casos-limite analíticos.
fake <- ctx
fake$f <- matrix(1, 5, 5)                       # todos idênticos e homozigotos
near(theta_group(1:5, fake), 1); near(status_number(1:5, fake), 0.5)
# diagonal d, off-diagonal o  ->  theta = (d + (n-1)*o)/n
fake$f <- diag(5) * 0.5 + 0.5                   # d=1 (homozigotos), o=0.5
near(theta_group(1:5, fake), (1 + 4 * 0.5) / 5)
fake$f <- matrix(0.5, 5, 5)                     # d=o=0.5: não-aparentados, p=0.5
near(theta_group(1:5, fake), 0.5); near(status_number(1:5, fake), 1)
ok("casos-limite de theta e Ns")

# 6. Greedy de diversidade pura tem que bater a média aleatória.
set.seed(3)
th_rand <- mean(replicate(200, theta_group(sample.int(ctx$N, 40), ctx)))
th_greedy <- theta_group(sel_greedy(ctx, 40, w = 0), ctx)
stopifnot(th_greedy < th_rand)
ok(sprintf("greedy min-theta (%.4f) < aleatório médio (%.4f)", th_greedy, th_rand))

# 7. Truncamento perde diversidade em relação ao aleatório (senão não há
#    trade-off a otimizar e o benchmark não tem sentido).
th_trunc <- theta_group(sel_truncation(ctx, 40), ctx)
stopifnot(th_trunc > th_greedy)
ok(sprintf("truncamento (%.4f) > greedy (%.4f)", th_trunc, th_greedy))

# 8. decode() devolve sempre n_sel índices únicos e válidos.
set.seed(5)
for (i in 1:50) {
  d <- decode(runif(40, 1, ctx$N + 1), ctx$N, 40)
  stopifnot(length(unique(d)) == 40, all(d >= 1), all(d <= ctx$N))
}
ok("decode() é determinístico, único e dentro dos limites")

# 9. Contrato das duas etapas.
st1 <- etapa1_simular(cfg)
stopifnot(all(c("X", "f", "hibridos") %in% names(st1)),
          max(st1$X) <= 1, min(st1$f) >= 0, max(st1$f) <= 1,
          all(c("hibrido", "linhagem_A", "linhagem_B") %in% names(st1$hibridos)),
          nrow(st1$hibridos) == nrow(st1$X))
ok("etapa1 devolve X, f e hibridos coerentes")

r <- etapa2_selecionar(st1$X, st1$f, st1$hibridos, n_sel = 20, alphas = c(0, 0.02),
                       B_nula = 50, NP = 40, itermax = 30, verbose = FALSE)
cen <- setdiff(names(r$selecao), c(names(st1$hibridos), "n_cenarios"))
stopifnot(nrow(r$selecao) == nrow(st1$X),
          all(sapply(r$selecao[cen], sum) == 20),   # cada cenário seleciona n_sel
          all(unlist(r$selecao[cen]) %in% 0:1),
          nrow(r$metricas) == length(cen))
ok(sprintf("etapa2: %d cenários, %d selecionados em cada", length(cen), 20))

# A etapa 2 roda sem fL — só perde theta_A/B/AB.
r2 <- etapa2_selecionar(st1$X, st1$f, st1$hibridos, n_sel = 20, alphas = 0,
                        B_nula = 50, NP = 40, itermax = 30, verbose = FALSE)
stopifnot(is.na(r2$metricas$theta_A[1]), !is.na(r2$metricas$Ne_linhas_A[1]))
ok("etapa2 sem fL: theta_pools vira NA, Ne por pool continua")

cat("\nTodas as checagens passaram.\n")
