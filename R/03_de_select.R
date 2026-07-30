# Estratégias de seleção de n_sel híbridos entre N candidatos.
# Todas retornam um vetor de índices.

# --- Baselines --------------------------------------------------------------

sel_random <- function(ctx, n_sel) sample.int(ctx$N, n_sel)

# Teto de ganho, piso de diversidade.
sel_truncation <- function(ctx, n_sel) order(ctx$index, decreasing = TRUE)[seq_len(n_sel)]

# Truncamento com teto de uso por linhagem. O baseline barato: nenhuma matriz,
# só contagem, e costuma capturar boa parte do benefício.
sel_truncation_cap <- function(ctx, n_sel, cap = ceiling(2 * n_sel / ctx$n_lines) + 1) {
  ord <- order(ctx$index, decreasing = TRUE)
  used <- integer(ctx$n_lines)
  out <- integer(0)
  for (i in ord) {
    a <- ctx$ped$a[i]; b <- ctx$ped$b[i]
    if (used[a] < cap && used[b] < cap) {
      out <- c(out, i); used[a] <- used[a] + 1L; used[b] <- used[b] + 1L
      if (length(out) == n_sel) break
    }
  }
  out
}

# Greedy com atualização incremental: adicionar j muda a soma total da submatriz
# em 2*s_j + f_jj, onde s_j = soma de f[i,j] sobre os já escolhidos. O(N) por passo.
# Score = w*índice - theta.  w = 0 -> diversidade pura (teto de diversidade,
# ganho ~0). w > 0 -> heurística OCS discreta. w -> Inf converge ao truncamento.
sel_greedy <- function(ctx, n_sel, w = 0) {
  f <- ctx$f
  d <- diag(f)
  s <- numeric(ctx$N)
  avail <- rep(TRUE, ctx$N)
  out <- integer(n_sel)
  total <- 0

  for (k in seq_len(n_sel)) {
    theta_new <- (total + 2 * s + d) / k^2
    score <- w * ctx$index - theta_new
    score[!avail] <- -Inf
    j <- which.max(score)
    out[k] <- j; avail[j] <- FALSE
    total <- total + 2 * s[j] + d[j]
    s <- s + f[, j]
  }
  out
}

# --- Differential evolution -------------------------------------------------

# Codificação: 200 valores contínuos em [1, N], não um vetor de N chaves —
# 5000 dimensões é inviável para DE. Duplicatas reparadas de forma determinística
# (fitness ruidoso impede o DE de convergir).
# ponytail: reparo preenche com os índices livres mais baixos, o que enviesa
# levemente; trocar por "livre mais próximo" se o DE estagnar.
decode <- function(par, N, n_sel) {
  k <- as.integer(par)
  k[k < 1L] <- 1L; k[k > N] <- N
  dup <- duplicated(k)
  if (any(dup)) k[dup] <- setdiff(seq_len(N), k[!dup])[seq_len(sum(dup))]
  k
}

# Restrição, não soma ponderada: alpha = perda relativa de diversidade gênica
# contra a referência aleatória. Violação vira penalidade proporcional, então
# "alpha_max = 0.05" continua significando "aceito perder 5%".
make_fitness <- function(ctx, n_sel, alpha_max, gd_ref, penalty = 1000) {
  N <- ctx$N
  f <- ctx$f
  ix <- ctx$index
  function(par) {
    idx <- decode(par, N, n_sel)
    gd <- 1 - mean(f[idx, idx])
    viol <- max(0, (gd_ref - gd) / gd_ref - alpha_max)
    -(mean(ix[idx]) - penalty * viol)   # DEoptim minimiza
  }
}

sel_de <- function(ctx, n_sel, alpha_max, gd_ref, NP = 300, itermax = 2000,
                   seeds = NULL, trace = FALSE) {
  fit <- make_fitness(ctx, n_sel, alpha_max, gd_ref)
  # Warm start com as soluções heurísticas: o DE parte de algo já viável.
  initial <- matrix(runif(NP * n_sel, 1, ctx$N + 1), NP, n_sel)
  if (!is.null(seeds)) for (i in seq_along(seeds)) initial[i, ] <- seeds[[i]] + 0.5

  ctrl <- DEoptim::DEoptim.control(NP = NP, itermax = itermax, trace = trace,
                                   initialpop = initial)
  res <- DEoptim::DEoptim(fit, lower = rep(1, n_sel), upper = rep(ctx$N + 0.999, n_sel),
                          control = ctrl)
  decode(res$optim$bestmem, ctx$N, n_sel)
}

# --- Relaxamento contínuo de OCS (limite superior) --------------------------

# max c'u - lambda*c'f c  s.a.  sum(c)=1, 0 <= c <= 1/n_sel.
# O teto c_i <= 1/n_sel é o que torna isto um limite superior válido para o
# problema 0/1 de peso igual. Gap grande contra o DE = DE não convergiu.
project_capped_simplex <- function(v, cap) {
  lo <- min(v) - 1; hi <- max(v)
  for (i in 1:60) {
    tau <- (lo + hi) / 2
    if (sum(pmin(pmax(v - tau, 0), cap)) > 1) lo <- tau else hi <- tau
  }
  pmin(pmax(v - (lo + hi) / 2, 0), cap)
}

# iters baixo dá um "limite superior" MENOR que o ótimo discreto — inútil.
# 4000 é o mínimo que converge nos testes; conferir sempre que mudar de dataset.
ocs_relaxation <- function(ctx, n_sel, lambdas, iters = 4000) {
  cap <- 1 / n_sel
  L <- max(rowSums(abs(ctx$f)))   # cota de Gershgorin para o maior autovalor
  do.call(rbind, lapply(lambdas, function(lam) {
    step <- 1 / (2 * max(lam, 1e-6) * L)
    c_ <- rep(1 / ctx$N, ctx$N)
    for (i in seq_len(iters)) {
      g <- ctx$index - 2 * lam * (ctx$f %*% c_)
      c_ <- project_capped_simplex(c_ + step * as.numeric(g), cap)
    }
    th <- drop(t(c_) %*% ctx$f %*% c_)
    c(lambda = lam, index = sum(c_ * ctx$index), theta = th, GD = 1 - th)
  }))
}
