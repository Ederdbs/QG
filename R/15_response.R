# Response to selection: the objective side.
#
# The rest of the package measures and constrains diversity. Nothing in it ever
# writes down what selection is buying. That asymmetry is why the book could
# observe its own headline result -- a constrained programme overtaking an
# unconstrained one -- without being able to predict it.
#
# Three pieces close the gap. `genic_var()` is the variance the loci would
# carry if they were independent, so the difference between it and the realised
# variance is the gametic-phase disequilibrium that no single-locus diversity
# metric can see. The two index functions are the classical construction of the
# thing being maximised, and `index_restricted()` in particular is the sixty
# year old ancestor of this book's alpha constraint: maximise aggregate gain
# subject to zero expected change in a specified direction.

#' Genic variance: the variance if the loci were independent
#'
#' `sum_k beta_k^2 Var(x_k)`, the sum of the *diagonal* of the covariance matrix
#' of `X %*% beta`. The realised variance `var(X %*% beta)` is the sum of the
#' whole matrix, so
#'
#' `var(X beta) - genic_var(X, beta) = 2 * sum over k < l of beta_k beta_l Cov(x_k, x_l)`
#'
#' is exactly the contribution of gametic-phase disequilibrium. Directional
#' selection makes that term negative (Bulmer 1971): it builds up negative
#' covariance between loci with like effects and so hides part of the genic
#' variance from the next generation. Recombination repays it; drift does not.
#'
#' This is the quantity every diversity metric in the package is blind to. Gene
#' diversity, `theta`, allelic richness and both inbreeding lenses are functions
#' of allele frequencies one locus at a time, and the disequilibrium term does
#' not move a single allele frequency. A flat gene diversity trajectory
#' therefore does **not** imply flat additive variance.
#'
#' @param X Marker matrix, `n` individuals by `m` loci, on any consistent
#'   dosage scale. The book's hybrid coding is 0/0.5/1.
#' @param beta Numeric vector of `ncol(X)` marker effects, on the scale the
#'   answer is wanted in. Pass `beta / sd` to get an answer in index units.
#' @return A single number.
#' @seealso [ref_genic_var] for the literal oracle, [run_cycles] which reports
#'   this alongside the realised variance for every cycle.
#' @export
#' @examples
#' X <- cbind(c(0, 0.5, 1, 0.5), c(1, 0.5, 0, 0.5))
#' genic_var(X, beta = c(1, 1))          # loci in perfect negative disequilibrium
#' stats::var(drop(X %*% c(1, 1)))       # realised variance: zero
genic_var <- function(X, beta) {
  stopifnot(length(beta) == ncol(X))
  n  <- nrow(X)
  cm <- colMeans(X)
  v  <- (colSums(X^2) - n * cm^2) / (n - 1)
  sum(beta^2 * v)
}

#' Smith-Hazel selection index
#'
#' `b = P^-1 G a`, the weights on the measured traits that maximise the
#' correlation of the index with the aggregate genotype `H = a' g`
#' (Smith 1936; Hazel 1943).
#'
#' The book's pipeline defaults to `weights = NULL`, meaning equal weight on
#' every trait. That is a choice, not a neutral default: equal weights are the
#' Smith-Hazel solution only when `P^-1 G` is proportional to the identity,
#' which requires the traits to be equally variable, equally heritable and
#' mutually uncorrelated. Nothing guarantees that, and when it fails the index
#' being maximised is not the index anyone wanted.
#'
#' @param P Phenotypic covariance matrix of the measured traits, `t x t`.
#' @param G Genetic covariance matrix between measured traits and the traits in
#'   the aggregate genotype, `t x t`.
#' @param a Economic weights, length `t`.
#' @return Numeric vector of index weights, length `t`.
#' @seealso [index_restricted] for the constrained version.
#' @export
#' @examples
#' P <- diag(c(4, 1)); G <- diag(c(2, 0.5))
#' index_smith_hazel(P, G, a = c(1, 1))
index_smith_hazel <- function(P, G, a) {
  drop(solve(P, G %*% a))
}

#' Restricted selection index
#'
#' Maximum aggregate gain subject to **zero expected genetic change** in a
#' specified set of directions (Kempthorne & Nordskog 1959). With `C = G R`,
#' the solution is
#'
#' `b = P^-1 [ G a - C (C' P^-1 C)^-1 C' P^-1 G a ]`
#'
#' and it satisfies `R' G b = 0` exactly, which is the property that makes it a
#' restriction rather than a penalty.
#'
#' This is the classical ancestor of the `alpha` constraint. The book argues
#' that a budget ("I accept losing five percent") is approvable where a weighted
#' sum ("diversity is worth lambda index units") is not. That argument is not
#' merely rhetorical: it is the same distinction Kempthorne and Nordskog drew in
#' 1959 between restricting a direction and pricing it. The only novelty here is
#' that the restricted direction is not a trait.
#'
#' @references Kempthorne O, Nordskog AW (1959). Restricted selection indices.
#'   Biometrics 15(1), 10-19.
#'
#' @inheritParams index_smith_hazel
#' @param R Restriction matrix, `t x r`: each column names a linear combination
#'   of traits whose expected gain must be zero. `diag(t)[, j]` restricts trait
#'   `j`.
#' @return Numeric vector of index weights, length `t`.
#' @seealso [index_smith_hazel], which this reduces to when `R` has no columns.
#' @export
#' @examples
#' P <- diag(c(4, 1)); G <- diag(c(2, 0.5))
#' b <- index_restricted(P, G, a = c(1, 1), R = cbind(c(0, 1)))
#' drop(crossprod(cbind(c(0, 1)), G %*% b))   # zero: trait 2 does not move
index_restricted <- function(P, G, a, R) {
  if (ncol(R) == 0L) return(index_smith_hazel(P, G, a))
  b0 <- G %*% a
  C  <- G %*% R
  Pi <- solve(P, C)                                   # P^-1 C
  drop(solve(P, b0 - C %*% solve(crossprod(C, Pi), crossprod(Pi, b0))))
}
