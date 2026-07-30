# ETAPA 1 — dos genótipos das linhagens aos híbridos.
#
# Devolve os três objetos que a etapa 2 consome:
#   $X         matriz de marcadores dos híbridos, N x m, valores {0, 0.5, 1}
#   $f         coancestria molecular de Caballero & Toro, N x N, valores em [0,1]
#   $hibridos  data.frame N x (3 + n_traits): id, linhagens parentais, traits preditos
# Mais um quarto objeto opcional:
#   $fL        coancestria molecular ENTRE LINHAGENS, usada só na decomposição
#              por grupo heterótico. A etapa 2 roda sem ele.

etapa1_simular <- function(cfg = sim_config) {
  d <- simulate_data(cfg)
  etapa1_montar(X = d$X, ped = d$ped, traits = d$traits, fL = d$fL)
}

# Mesmo contrato, mas a partir de dados reais: use esta função quando tiver a
# matriz de marcadores dos híbridos (0/1/2) e a tabela de traits preditos.
etapa1_montar <- function(X, ped, traits, fL = NULL) {
  if (max(X) > 1) X <- X / 2          # aceita codificação 0/1/2 ou 0/0.5/1
  stopifnot(nrow(X) == nrow(ped), nrow(X) == nrow(traits))

  hibridos <- data.frame(
    hibrido = seq_len(nrow(X)),
    linhagem_A = as.integer(ped$a),
    linhagem_B = as.integer(ped$b),
    traits
  )

  list(X = X, f = molecular_coancestry(X), hibridos = hibridos, fL = fL)
}
