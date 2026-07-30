# Dados: simulação de linhagens -> híbridos -> G (predição) + f (diversidade).
#
# load_data() é o ÚNICO ponto a trocar quando os dados reais chegarem.
# O resto do código só enxerga o objeto `ctx`.

sim_config <- list(
  n_pool_A = 50,     # linhagens no grupo heterótico A
  n_pool_B = 50,     # linhagens no grupo heterótico B
  m        = 5000,   # marcadores (real: 25000)
  n_traits = 3,
  fst      = 0.15,   # divergência entre pools
  seed     = 1
)

# Genótipos das linhagens, 0/2 (endogâmicas = homozigotas), com dois pools
# divergentes via modelo Balding-Nichols.
simulate_lines <- function(cfg) {
  set.seed(cfg$seed)
  p_anc <- runif(cfg$m, 0.05, 0.95)
  bn <- function(p, fst) rbeta(length(p), p * (1 - fst) / fst, (1 - p) * (1 - fst) / fst)
  pA <- bn(p_anc, cfg$fst)
  pB <- bn(p_anc, cfg$fst)

  draw <- function(n, p) matrix(2L * rbinom(n * length(p), 1, rep(p, each = n)), nrow = n)
  L <- rbind(draw(cfg$n_pool_A, pA), draw(cfg$n_pool_B, pB))
  storage.mode(L) <- "double"
  L
}

# Coancestria molecular (Caballero & Toro): f_ij = P(dois alelos idênticos por estado).
# x = frequência do alelo de referência DENTRO do indivíduo (0, 0.5, 1).
#   Sum_k [x_i x_j + (1-x_i)(1-x_j)] = 2 Sum_k x_i x_j - Sum x_i - Sum x_j + m
# Um único tcrossprod. Nunca centrar: f tem que ficar em [0,1].
molecular_coancestry <- function(X) {
  m <- ncol(X)
  s <- rowSums(X)
  f <- (2 * tcrossprod(X) - outer(s, rep(1, nrow(X))) - outer(rep(1, nrow(X)), s) + m) / m
  dimnames(f) <- NULL
  f
}

# VanRaden. Só para a predição dos traits — NÃO usar para diversidade:
# com Z centrada na própria população, sum(G) == 0 por construção.
vanraden_G <- function(M) {
  p <- colMeans(M) / 2
  Z <- sweep(M, 2, 2 * p, "-")
  list(G = tcrossprod(Z) / (2 * sum(p * (1 - p))), Z = Z, p = p)
}

simulate_data <- function(cfg = sim_config) {
  L <- simulate_lines(cfg)
  n_lines <- nrow(L)
  a_ids <- seq_len(cfg$n_pool_A)
  b_ids <- cfg$n_pool_A + seq_len(cfg$n_pool_B)

  # Todas as combinações A x B.
  ped <- expand.grid(a = a_ids, b = b_ids)
  M <- (L[ped$a, , drop = FALSE] + L[ped$b, , drop = FALSE]) / 2  # 0/1/2

  vr <- vanraden_G(M)

  # Efeitos de marcador correlacionados entre traits -> GEBVs preditos.
  set.seed(cfg$seed + 99)
  R <- matrix(c(1, 0.3, -0.3, 0.3, 1, 0.1, -0.3, 0.1, 1), 3, 3)[seq_len(cfg$n_traits),
                                                                seq_len(cfg$n_traits), drop = FALSE]
  B <- matrix(rnorm(cfg$m * cfg$n_traits), cfg$m) %*% chol(R)
  traits <- scale(vr$Z %*% B)
  colnames(traits) <- paste0("trait", seq_len(cfg$n_traits))

  X <- M / 2
  build_ctx(X = X, f = molecular_coancestry(X), G = vr$G, traits = traits,
            ped = ped, n_lines = n_lines, pool = rep(c("A", "B"), c(cfg$n_pool_A, cfg$n_pool_B)),
            fL = molecular_coancestry(L / 2), cfg = cfg)
}

# Monta o contexto e pré-calcula o que é constante entre avaliações.
build_ctx <- function(X, f, G, traits, ped, n_lines, pool, fL, cfg,
                      weights = rep(1, ncol(traits))) {
  p_pop <- colMeans(X)
  list(
    X = X, f = f, G = G, traits = traits, ped = ped,
    n_lines = n_lines, pool = pool, fL = fL, cfg = cfg,
    N = nrow(X), m = ncol(X),
    index = as.numeric(scale(traits %*% weights)),   # índice multi-trait, em desvios
    maf_pop = pmin(p_pop, 1 - p_pop)
  )
}

# Troque o corpo desta função pelos seus arquivos reais.
load_data <- function(path = "data") {
  fx <- file.path(path, "ctx.rds")
  if (file.exists(fx)) return(readRDS(fx))
  simulate_data()
}
