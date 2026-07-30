# Métricas de diversidade. Todas com assinatura f(idx, ctx) -> escalar.
# Todas sobre a coancestria molecular `ctx$f`, nunca sobre a G centrada.

# --- Núcleo -----------------------------------------------------------------

# Coancestria de grupo (Cockerham): média de TODOS os n^2 elementos, diagonal
# incluída. A média off-diagonal sozinha ignora a homozigose de cada híbrido.
theta_group <- function(idx, ctx) mean(ctx$f[idx, idx])

# Diversidade gênica. Identidade exata: 1 - theta == He de Nei (ver tests/).
gene_diversity <- function(idx, ctx) 1 - theta_group(idx, ctx)

# Status number (Lindgren & Mullin 1997): "híbridos não-aparentados equivalentes".
# Descritor estático do grupo, não projeção de deriva.
status_number <- function(idx, ctx) 1 / (2 * theta_group(idx, ctx))

# Mesma quantidade pela rota das frequências alélicas: O(n*m) em vez de O(n^2).
# ~100x mais cara — serve de validação, não entra no fitness do DE.
theta_from_freq <- function(idx, ctx) {
  p <- colMeans(ctx$X[idx, , drop = FALSE])
  mean(p^2 + (1 - p)^2)
}

# He de Nei, calculada de forma independente.
he_nei <- function(idx, ctx) {
  p <- colMeans(ctx$X[idx, , drop = FALSE])
  mean(2 * p * (1 - p))
}

# Número efetivo de parentais. Independente de f: pega o caso "theta bom,
# mas só 12 linhagens usadas".
ne_parents <- function(idx, ctx) {
  cnt <- tabulate(c(ctx$ped$a[idx], ctx$ped$b[idx]), nbins = ctx$n_lines)
  p <- cnt / sum(cnt)
  1 / sum(p^2)
}

# Decomposição por grupo heterótico. A diversidade ENTRE pools é o motor da
# heterose: theta global pode estar bom com um dos pools erodido.
theta_pools <- function(idx, ctx) {
  wA <- tabulate(ctx$ped$a[idx], nbins = ctx$n_lines); wA <- wA / sum(wA)
  wB <- tabulate(ctx$ped$b[idx], nbins = ctx$n_lines); wB <- wB / sum(wB)
  c(theta_A = drop(wA %*% ctx$fL %*% wA),
    theta_B = drop(wB %*% ctx$fL %*% wB),
    theta_AB = drop(wA %*% ctx$fL %*% wB))
}

# Marcadores que eram polimórficos na população e ficaram raros/fixados na
# seleção. Única métrica genuinamente independente de theta.
alleles_lost <- function(idx, ctx, maf = 0.05) {
  p <- colMeans(ctx$X[idx, , drop = FALSE])
  sum(pmin(p, 1 - p) < maf & ctx$maf_pop >= maf)
}

# --- Diagnóstico ------------------------------------------------------------

# Distância = 1 - coancestria molecular.

# Entry-to-nearest-entry (Core Hunter 3): não-redundância DENTRO da seleção.
# Distingue "200 espalhados" de "100 pares quase idênticos".
ene <- function(idx, ctx) {
  d <- 1 - ctx$f[idx, idx]
  diag(d) <- Inf
  mean(apply(d, 1, min))
}

# Accession-to-nearest-entry: representatividade da população inteira.
ane <- function(idx, ctx) mean(1 - apply(ctx$f[, idx, drop = FALSE], 1, max))

# Quantas direções independentes de variação sobraram.
eff_dim <- function(idx, ctx) {
  l <- eigen(ctx$f[idx, idx], symmetric = TRUE, only.values = TRUE)$values
  sum(l)^2 / sum(l^2)
}

# Gst de Nei entre selecionados e não-selecionados.
gst <- function(idx, ctx) {
  ps <- colMeans(ctx$X[idx, , drop = FALSE])
  pn <- colMeans(ctx$X[-idx, , drop = FALSE])
  hs <- mean(p_het(ps) + p_het(pn)) / 2
  ht <- mean(p_het((ps + pn) / 2))
  (ht - hs) / ht
}
p_het <- function(p) 2 * p * (1 - p)

max_line_use <- function(idx, ctx) {
  max(tabulate(c(ctx$ped$a[idx], ctx$ped$b[idx]), nbins = ctx$n_lines))
}

mean_index <- function(idx, ctx) mean(ctx$index[idx])

# A métrica que o usuário tem hoje, para comparação.
mean_offdiag <- function(idx, ctx) {
  s <- ctx$f[idx, idx]
  n <- length(idx)
  (sum(s) - sum(diag(s))) / (n * (n - 1))
}

# --- Agregadores ------------------------------------------------------------

# Baratas: podem rodar milhares de vezes (nula, fitness do DE).
metrics_cheap <- function(idx, ctx) {
  th <- theta_group(idx, ctx)
  c(index = mean_index(idx, ctx), theta = th, GD = 1 - th, Ns = 1 / (2 * th),
    offdiag = mean_offdiag(idx, ctx), Ne_parents = ne_parents(idx, ctx),
    max_line = max_line_use(idx, ctx), theta_pools(idx, ctx))
}

# Caras (varrem os 25k marcadores ou fazem eigen): pós-hoc.
metrics_full <- function(idx, ctx) {
  c(metrics_cheap(idx, ctx),
    He = he_nei(idx, ctx), alleles_lost = alleles_lost(idx, ctx),
    ENE = ene(idx, ctx), ANE = ane(idx, ctx),
    eff_dim = eff_dim(idx, ctx), Gst = gst(idx, ctx))
}
