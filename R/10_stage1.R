# STAGE 1 -- from line genotypes to hybrids.
#
# Returns the three objects stage 2 consumes:
#   $X        marker matrix of the hybrids, N x m, values {0, 0.5, 1}
#   $f        Caballero & Toro molecular coancestry, N x N, values in [0,1]
#   $hybrids  data.frame N x (3 + n_traits): id, parent lines, predicted traits
# Plus an optional fourth object:
#   $fL       molecular coancestry BETWEEN LINES, used only for the heterotic
#             group decomposition. Stage 2 runs fine without it.


#' Stage 1 from simulated data
#'
#' Simulates lines and crosses, then hands back the stage-1 contract.
#'
#' @param cfg A configuration list, see [sim_config].
#' @return The stage-1 contract, see [stage1_build].
#' @export
#' @examples
#' st1 <- stage1_simulate(modifyList(sim_config,
#'                                   list(n_pool_A = 5, n_pool_B = 5, m = 200)))
#' names(st1)
stage1_simulate <- function(cfg = sim_config) {
  d <- simulate_data(cfg)
  stage1_build(X = d$X, ped = d$ped, traits = d$traits, fL = d$fL)
}

# Same contract, but from real data: use this function once you have the
# hybrid marker matrix (0/1/2) and the predicted-trait table.

#' Stage 1: from line genotypes to the hybrid contract
#'
#' The seam between the simulation and the rest of the pipeline. Everything
#' downstream talks only through the objects returned here, which is what makes
#' swapping in real data a single-function change.
#'
#' @param X Hybrid marker matrix, `N x m`. Accepts 0/1/2 or 0/0.5/1 coding; the
#'   coding is auto-detected and rescaled.
#' @param ped Data frame with columns `a` and `b`, the parent line ids, one row
#'   per hybrid.
#' @param traits Data frame or matrix of predicted trait values, one row per
#'   hybrid.
#' @param fL Optional coancestry matrix *between lines*. Stage 2 runs without
#'   it; it only enables the heterotic-group decomposition
#'   ([theta_pools], [gd_partition]).
#' @return A list with `X` (markers in 0/0.5/1), `f` (hybrid molecular
#'   coancestry), `hybrids` (id, parent lines, traits) and `fL`.
#' @seealso [stage2_select] for the next stage.
#' @export
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
