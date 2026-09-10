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

#' Inbreeding depression of a pool
#'
#' Under the same dominance model as [heterosis_value], a locus at frequency `p`
#' in a population with inbreeding coefficient `F_coef` is heterozygous with
#' probability `2 p q (1 - F_coef)`, so the mean falls linearly in `F_coef`:
#'
#' `ID = 2 F_coef sum_k d_k p_k q_k`
#'
#' Note what this is identical to. `heterosis_partition(p, p, d)["shared"]` is
#' `sum_k d_k 2 p_k q_k`, so the depression of a pool driven to complete
#' homozygosity is *exactly* the expected heterosis of a cross made within that
#' same pool. Heterosis on crossing and depression on inbreeding are one
#' quantity seen from two sides, which is why this function takes the same `d`
#' the heterosis functions take and needs nothing new.
#'
#' Do **not** read this as the current-cycle price of the diversity budget. It
#' is tempting to, and the algebra says otherwise. A fully inbred line has no
#' heterozygous loci, so its dominance contribution is exactly zero whatever the
#' pool's allele frequencies are: `heterosis_value()` of a homozygous line
#' returns 0 by construction. In a programme whose parents are inbred lines the
#' depression is therefore a *constant*, paid in full the moment the lines were
#' made, and it does not vary with how much gene diversity the pool has since
#' lost. It is the same fact that makes `GD_WI` exactly zero in [gd_partition].
#'
#' Where `F_coef` between 0 and 1 is the live quantity is line *development* --
#' F2, F3, F4, where the population is partially inbred and the depression is
#' still accumulating -- and in any programme whose parents are not fully
#' inbred.
#'
#' Only loci with `d != 0` contribute. An additive trait shows no inbreeding
#' depression at all, however much diversity is lost, which is the same reason
#' the additive pipeline elsewhere in this package never needs a `d`.
#'
#' @param p Numeric vector of reference-allele frequencies in the pool, one
#'   entry per locus, taken at the base against which `F_coef` is measured.
#' @param d Numeric vector of dominance deviations, one per locus.
#' @param F_coef Inbreeding coefficient relative to that base. The default, 1,
#'   is complete homozygosity and gives the maximum depression.
#' @return A single number, the decline in the population mean on the trait
#'   scale. Positive when the `d` are predominantly positive.
#' @seealso [heterosis_partition], whose `shared` term this equals at
#'   `F_coef = 1`; [ref_inbreeding_depression] for the Monte Carlo oracle.
#' @export
#' @examples
#' p <- c(0.5, 0.2, 0.8); d <- c(1, 2, 3)
#' inbreeding_depression(p, d)
#' heterosis_partition(p, p, d)[["shared"]]   # the same number
inbreeding_depression <- function(p, d, F_coef = 1) {
  stopifnot(length(p) == length(d))
  2 * F_coef * sum(d * p * (1 - p))
}

#' General and specific combining ability for heterosis
#'
#' The exact orthogonal decomposition of [heterosis_value] over a complete
#' pool-A x pool-B factorial. Write a line's genotype as its pool frequency
#' plus a deviation, `u = pA + du` and `v = pB + dv`, and expand the per-locus
#' heterozygosity `u + v - 2 u v`. What is linear in one parent is general
#' combining ability; what is bilinear in both is specific combining ability:
#'
#' `H_ij = mu + gca_A[i] + gca_B[j] + sca[i, j]`
#'
#' with `gca_A = sum_k d_k (1 - 2 pB_k) du_ik`, symmetrically for `gca_B`, and
#' `sca = -2 sum_k d_k du_ik dv_jk`. Two consequences. A line's general
#' combining ability *for heterosis* is weighted by the **opposite** pool's
#' frequencies, so it is tester-pool specific and carries no information at
#' loci where that pool sits at 0.5. And specific combining ability is minus
#' twice a `d`-weighted covariance between the two parents' centred genotypes
#' -- the formal reason parental similarity predicts it.
#'
#' All three components have mean zero over the factorial, and `sca` is exactly
#' the interaction residual of the two-way additive fit. An additive model of
#' hybrid performance can express the two `gca` terms and nothing else.
#'
#' @param U,V Line genotype matrices for pool A and pool B, coded 0/1, one row
#'   per line and one column per locus. For homozygous lines these are `L / 2`.
#' @param d Numeric vector of `ncol(U)` dominance deviations, one per locus.
#' @return A list with `mu`, the factorial mean (see [heterosis_expected]),
#'   `gca_A` and `gca_B`, one entry per line of each pool, and `sca`, an
#'   `nrow(U)` x `nrow(V)` matrix.
#' @seealso [heterosis_value] for the realised values this decomposes,
#'   [heterosis_partition] for the frequency-level split.
#' @export
#' @examples
#' U <- rbind(c(1, 0, 1), c(0, 0, 1))
#' V <- rbind(c(0, 1, 1), c(1, 1, 0))
#' heterosis_gca_sca(U, V, d = c(1, 2, 3))
heterosis_gca_sca <- function(U, V, d) {
  stopifnot(ncol(U) == ncol(V), length(d) == ncol(U))
  pA <- colMeans(U)
  pB <- colMeans(V)
  cU <- sweep(U, 2, pA)
  cV <- sweep(V, 2, pB)
  list(mu    = heterosis_expected(pA, pB, d),
       gca_A = drop(cU %*% (d * (1 - 2 * pB))),
       gca_B = drop(cV %*% (d * (1 - 2 * pA))),
       sca   = -2 * (cU * rep(d, each = nrow(U))) %*% t(cV))
}
