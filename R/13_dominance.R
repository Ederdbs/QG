# Dominance and heterosis.
#
# The rest of the package is deliberately additive: `G` predicts trait means,
# `f` measures diversity, and neither needs a dominance term. This file exists
# for one reason -- the book asserts throughout that between-pool divergence is
# "the heterosis engine, to be maintained", and that assertion is only
# checkable with a dominance model.
#
# Nothing here is called by simulate_data(), stage1_simulate() or
# stage2_select(). Adding a dominance term must not move a single number in the
# existing pipeline, so the pipeline never sees one.

#' Realised mid-parent heterosis of each hybrid
#'
#' With fully inbred parent lines every parent is homozygous, so the additive
#' contributions of the two parents average exactly to the F1's own additive
#' value and cancel from the mid-parent difference. What survives is the
#' dominance deviation at the loci where the F1 is heterozygous:
#' `H_i` is the sum of `d_k` over the loci where `x_ik` equals 0.5.
#'
#' The additive effects therefore never appear as an argument. That is the
#' result, not an omission.
#'
#' @param X Hybrid marker matrix, values in 0/0.5/1. Heterozygous loci are the
#'   entries equal to 0.5, which is exact only because the parents are inbred.
#' @param d Numeric vector of `ncol(X)` dominance deviations, one per locus.
#' @return Numeric vector of length `nrow(X)`, the mid-parent heterosis of each
#'   hybrid on the trait scale.
#' @seealso [heterosis_expected] for the closed form over a pool pair,
#'   [ref_heterosis] for the literal oracle.
#' @export
#' @examples
#' X <- rbind(c(0, 0.5, 1), c(0.5, 0.5, 0))
#' heterosis_value(X, d = c(1, 2, 3))
heterosis_value <- function(X, d) {
  stopifnot(length(d) == ncol(X))
  drop((X == 0.5) %*% d)
}

#' Expected heterosis of a random cross between two pools
#'
#' The mean of [heterosis_value] over all pool-A x pool-B crosses, from the
#' pool allele frequencies alone: a locus is heterozygous in the F1 with
#' probability `pA (1 - pB) + (1 - pA) pB`, so the expectation is
#' `sum_k d_k [pA_k + pB_k - 2 pA_k pB_k]`.
#'
#' @param pA,pB Numeric vectors of reference-allele frequencies in pool A and
#'   pool B, one entry per locus.
#' @param d Numeric vector of dominance deviations, one per locus.
#' @return A single number.
#' @export
heterosis_expected <- function(pA, pB, d) {
  stopifnot(length(pA) == length(pB), length(pA) == length(d))
  sum(d * (pA + pB - 2 * pA * pB))
}

#' Split expected heterosis into its shared and divergence components
#'
#' Writing `pbar = (pA + pB) / 2` and `y = pA - pB`, the per-locus F1
#' heterozygosity splits exactly:
#' `pA + pB - 2 pA pB = 2 pbar (1 - pbar) + y^2 / 2`.
#'
#' The first term is the heterozygosity a single merged pool at frequency
#' `pbar` would have produced; the second is what keeping the pools apart adds
#' on top of it. Averaged over loci those two terms are `GD_T` and `GD_BS` of
#' [gd_partition], which is what makes "between-pool divergence is the
#' heterosis engine" an identity rather than a slogan.
#'
#' Read the second term as a *bonus* and you will draw the wrong conclusion.
#' `pA` and `pB` drifting apart from a common ancestral `p` are independent, so
#' `E[pA pB] = p^2` and the expected total is `2 p (1 - p)` -- **invariant to
#' fst**. Every unit of divergence gained is paid for, one for one, out of the
#' shared term. Neutral divergence buys no heterosis at all.
#'
#' What buys heterosis is divergence that lands *on the dominance loci*: the
#' total moves with the alignment between `d` and `(pA - pB)^2`, not with how
#' far apart the pools are. Both claims are asserted in `test-dominance.R`.
#'
#' @inheritParams heterosis_expected
#' @return A named numeric vector: `shared`, `divergence`, and their `total`.
#' @seealso [gd_partition], whose `GD_T` and `GD_BS` these two terms are.
#' @export
heterosis_partition <- function(pA, pB, d) {
  pbar <- (pA + pB) / 2
  shared <- sum(d * 2 * pbar * (1 - pbar))
  divergence <- sum(d * (pA - pB)^2 / 2)
  c(shared = shared, divergence = divergence, total = shared + divergence)
}
