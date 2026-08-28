#' hybdiv: Hybrid Selection Under a Molecular Diversity Constraint
#'
#' Select a subset of F1 hybrids that maximises a multi-trait genomic index
#' while constraining the loss of molecular gene diversity relative to a
#' same-size random-sampling baseline.
#'
#' The package is organised around three ideas:
#'
#' * **One kernel.** Every diversity quantity derives from the Caballero & Toro
#'   molecular coancestry matrix [molecular_coancestry], never from a centered
#'   VanRaden matrix. See [vanraden_G] for why.
#' * **One signature.** Every metric is `f(idx, ctx) -> scalar`, so metrics are
#'   interchangeable inside any optimiser. See [metrics_cheap] and
#'   [metrics_full].
#' * **One baseline.** Loss is always measured against the distribution of
#'   random subsets of the same size, never against the full candidate pool.
#'   See [null_distribution].
#'
#' The two-stage entry points are [stage1_simulate] / [stage1_build] and
#' [stage2_select].
#'
#' @keywords internal
#' @importFrom stats runif rbeta rbinom rnorm sd cor var quantile setNames
#' @importFrom graphics par hist abline legend image axis text lines points
#'   plot.new box mtext segments polygon rect matplot title
#' @importFrom grDevices png pdf dev.off rainbow colorRampPalette adjustcolor
#'   gray
#' @importFrom utils head tail write.csv read.csv modifyList combn
"_PACKAGE"
