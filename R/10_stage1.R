# STAGE 1 — from line genotypes to hybrids.
#
# Returns the three objects stage 2 consumes:
#   $X        marker matrix of the hybrids, N x m, values {0, 0.5, 1}
#   $f        Caballero & Toro molecular coancestry, N x N, values in [0,1]
#   $hybrids  data.frame N x (3 + n_traits): id, parent lines, predicted traits
# Plus an optional fourth object:
#   $fL       molecular coancestry BETWEEN LINES, used only for the heterotic
#             group decomposition. Stage 2 runs fine without it.

stage1_simulate <- function(cfg = sim_config) {
  d <- simulate_data(cfg)
  stage1_build(X = d$X, ped = d$ped, traits = d$traits, fL = d$fL)
}

# Same contract, but from real data: use this function once you have the
# hybrid marker matrix (0/1/2) and the predicted-trait table.
stage1_build <- function(X, ped, traits, fL = NULL) {
  if (max(X) > 1) X <- X / 2          # accepts 0/1/2 or 0/0.5/1 coding
  stopifnot(nrow(X) == nrow(ped), nrow(X) == nrow(traits))

  hybrids <- data.frame(
    hybrid = seq_len(nrow(X)),
    line_A = as.integer(ped$a),
    line_B = as.integer(ped$b),
    traits
  )

  list(X = X, f = molecular_coancestry(X), hybrids = hybrids, fL = fL)
}
