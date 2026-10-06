# Mating designs: which cells of the two-pool factorial to grow.
#
# Every other file in this package takes the hybrids as given and asks which to
# keep. This one asks the question that comes first: of the nA x nB crosses a
# two-pool programme could make, which few hundred go to the field, and what
# can be estimated from them. A plan is a data.frame of (parent1, parent2)
# pairs -- parent1 indexes pool A, parent2 pool B -- optionally with a `reps`
# column of plots per cross.
#
# The model is the classical cross-mean model
#   ybar_ij = mu + gA_i + gB_j + s_ij + e_ij,  Var(e_ij) = s2e / r_ij,
# with i.i.d. effects. Genomic kernels, REML and CDmean live in the book's
# cached sweep, not here: this file is the part a reader can rerun.

# Union-find over the bipartite design graph. Pool-A line i is node i, pool-B
# line j is node nA + j. Returns the component label of every node, NA for a
# line that appears in no cross.
design_components <- function(plan, nA, nB) {
  parent <- seq_len(nA + nB)
  find <- function(x) {
    while (parent[x] != x) {
      parent[x] <<- parent[parent[x]]
      x <- parent[x]
    }
    x
  }
  for (k in seq_len(nrow(plan))) {
    a <- find(plan$parent1[k])
    b <- find(nA + plan$parent2[k])
    if (a != b) parent[b] <- a
  }
  lab <- vapply(seq_len(nA + nB), find, integer(1))
  used <- c(tabulate(plan$parent1, nA), tabulate(plan$parent2, nB)) > 0
  lab[!used] <- NA_integer_
  as.integer(factor(lab))
}

#' Tester design: every candidate crossed to k testers of the opposite pool
#'
#' Pool-A candidates are crossed to `k` pool-B testers and pool-B candidates to
#' `k` pool-A testers, the usual reciprocal arrangement. Tester-by-tester
#' crosses occur in both halves and are kept once, so the plan has
#' `k (nA + nB) - k^2` crosses.
#'
#' @param nA,nB Number of candidate lines in pool A and pool B.
#' @param k Testers per pool.
#' @param testers_A,testers_B Indices of the testers. Default: a random draw.
#' @return A data.frame with integer columns `parent1` (pool A) and `parent2`
#'   (pool B), one row per distinct cross.
#' @seealso [design_diagnostics] to check what the plan can estimate.
#' @export
#' @examples
#' nrow(design_tester(20, 20, k = 2))   # 2 * 40 - 4 = 76
design_tester <- function(nA, nB, k = 2L,
                          testers_A = sample.int(nA, k),
                          testers_B = sample.int(nB, k)) {
  g <- rbind(expand.grid(parent1 = seq_len(nA), parent2 = testers_B),
             expand.grid(parent1 = testers_A, parent2 = seq_len(nB)))
  plan_clean(g)
}

#' Random sparse factorial
#'
#' `round(c * nA)` crosses drawn without replacement from the complete
#' factorial, so lines receive a Binomial number of crosses and some may
#' receive none. That is reported by [design_diagnostics], not repaired.
#'
#' @inheritParams design_tester
#' @param c Mean number of crosses per pool-A line.
#' @inherit design_tester return
#' @export
design_random_sparse <- function(nA, nB, c) {
  idx <- sample.int(nA * nB, round(c * nA))
  plan_clean(data.frame(parent1 = (idx - 1L) %% nA + 1L,
                        parent2 = (idx - 1L) %/% nA + 1L))
}

#' Circulant (round-robin) sparse factorial
#'
#' Pool-A line `i` is crossed to pool-B lines `(i - 1 + o) mod nB + 1` for `c`
#' offsets `o` spread over `0..nB-1`. With `nA == nB` every line in both pools
#' has exactly `c` crosses. The bipartite graph is connected when
#' `gcd(nB, differences of the offsets) == 1`; the last offset is nudged until
#' that holds. The bipartite analogue of the circulant partial diallel of
#' Kempthorne and Curnow (1961).
#'
#' @inheritParams design_tester
#' @param c Crosses per line.
#' @inherit design_tester return
#' @export
#' @examples
#' p <- design_circulant(20, 20, c = 3)
#' table(tabulate(p$parent2, 20))   # every pool-B line used exactly 3 times
design_circulant <- function(nA, nB, c) {
  stopifnot(c >= 1, c <= nB)
  off <- unique(round(seq(0, nB, length.out = c + 1))[seq_len(c)])
  gcd <- function(a, b) if (b == 0) abs(a) else gcd(b, a %% b)
  if (c >= 2) {
    tries <- 0
    while (Reduce(gcd, c(nB, diff(sort(off)))) != 1 && tries < nB) {
      repeat {
        off[c] <- (off[c] + 1) %% nB
        if (!anyDuplicated(off)) break
      }
      tries <- tries + 1
    }
  }
  i <- rep(seq_len(nA), times = c)
  plan_clean(data.frame(parent1 = i,
                        parent2 = (i - 1L + rep(off, each = nA)) %% nB + 1L))
}

#' North Carolina Design II in disconnected sets
#'
#' `s = min(nA %/% a, nB %/% b)` complete `a x b` factorials on disjoint sets of
#' lines (Comstock and Robinson 1948). Deliberately disconnected: GCA contrasts
#' between sets are not estimable, which is the point of including it.
#'
#' @inheritParams design_tester
#' @param a,b Females and males per set.
#' @inherit design_tester return
#' @export
design_nc2 <- function(nA, nB, a = 10L, b = 10L) {
  s <- min(nA %/% a, nB %/% b)
  stopifnot(s >= 1)
  g <- do.call(rbind, lapply(seq_len(s), function(k)
    expand.grid(parent1 = (k - 1L) * a + seq_len(a),
                parent2 = (k - 1L) * b + seq_len(b))))
  plan_clean(g)
}

plan_clean <- function(g) {
  g <- data.frame(parent1 = as.integer(g$parent1),
                  parent2 = as.integer(g$parent2))
  g <- g[!duplicated(g), , drop = FALSE]
  rownames(g) <- NULL
  g
}

#' Spread a plot budget over the crosses of a plan
#'
#' Every cross gets `floor(n_plots / n_crosses)` plots, capped at `reps_max` and
#' floored at 1; while below the cap, the remainder goes one extra plot to a
#' random subset of crosses, so the plan uses the budget it was given. A plan
#' with more crosses than plots still gets one plot per cross -- it is
#' infeasible, and `sum(reps) > n_plots` says so.
#'
#' @param plan A plan as returned by the `design_*` generators.
#' @param n_plots Field plot budget.
#' @param reps_max Most plots any one cross may receive.
#' @return `plan` with an integer column `reps`.
#' @export
design_reps <- function(plan, n_plots, reps_max = 3L) {
  n <- nrow(plan)
  base <- max(1L, min(reps_max, n_plots %/% n))
  reps <- rep(as.integer(base), n)
  extra <- n_plots - base * n
  if (base < reps_max && extra > 0) {
    hit <- sample.int(n, min(extra, n))
    reps[hit] <- reps[hit] + 1L
  }
  plan$reps <- reps
  plan
}

#' What a mating design can estimate
#'
#' Treats the plan as a bipartite graph between the two pools. The numerical
#' rank of the GCA design matrix `[1 | Z_A | Z_B]` must equal
#' `nA' + nB' - components`, with `nA'`, `nB'` the lines actually crossed: one
#' constraint per connected component, because GCA contrasts between components
#' are not estimable. `df_sca` is what is left at cross-mean level to separate
#' SCA from error; it is zero for a one-tester-per-pool design.
#'
#' @inheritParams design_tester
#' @param plan A plan as returned by the `design_*` generators.
#' @return A named list: `n_crosses`, `lines_A`, `lines_B` (lines used),
#'   `deg_min`, `deg_mean`, `deg_max` (crosses per used line, both pools),
#'   `components`, `connected` (one component and every line used),
#'   `rank_gca`, `rank_expected`, `df_sca`, `frac_factorial`.
#' @export
#' @examples
#' design_diagnostics(design_nc2(40, 40, 10, 10), 40, 40)$components   # 4
design_diagnostics <- function(plan, nA, nB) {
  degA <- tabulate(plan$parent1, nA)
  degB <- tabulate(plan$parent2, nB)
  deg <- c(degA[degA > 0], degB[degB > 0])
  comp <- design_components(plan, nA, nB)
  n_comp <- max(comp, na.rm = TRUE)
  rk <- qr(gca_matrix(plan, nA, nB)[, c(TRUE, degA > 0, degB > 0)])$rank
  rk_exp <- sum(degA > 0) + sum(degB > 0) - n_comp
  list(n_crosses = nrow(plan),
       lines_A = sum(degA > 0), lines_B = sum(degB > 0),
       deg_min = min(deg), deg_mean = mean(deg), deg_max = max(deg),
       components = n_comp,
       connected = n_comp == 1 && all(degA > 0) && all(degB > 0),
       rank_gca = rk, rank_expected = rk_exp,
       df_sca = nrow(plan) - rk,
       frac_factorial = nrow(plan) / (nA * nB))
}

gca_matrix <- function(plan, nA, nB) {
  n <- nrow(plan)
  ZA <- matrix(0, n, nA)
  ZB <- matrix(0, n, nB)
  ZA[cbind(seq_len(n), plan$parent1)] <- 1
  ZB[cbind(seq_len(n), plan$parent2)] <- 1
  cbind(1, ZA, ZB)
}

#' Is a linear function of the GCA effects estimable from a plan?
#'
#' `l' beta` over `beta = (mu, gA, gB)` is estimable exactly when `l` lies in
#' the row space of the design matrix. Tested by projection.
#'
#' @inheritParams design_diagnostics
#' @param l Numeric vector of length `1 + nA + nB`.
#' @param tol Relative residual below which `l` counts as in the row space.
#' @return A list: `estimable` (logical) and `rel_residual`.
#' @export
design_estimable <- function(plan, nA, nB, l, tol = 1e-8) {
  X <- gca_matrix(plan, nA, nB)
  q <- qr(t(X))
  Q <- qr.Q(q)[, seq_len(q$rank), drop = FALSE]
  rel <- sqrt(sum((l - Q %*% crossprod(Q, l))^2)) / sqrt(sum(l^2))
  list(estimable = rel < tol, rel_residual = rel)
}

#' Least-squares accuracy of a GCA estimate, in closed form
#'
#' A line evaluated in `c` crosses with `r` plots each has a cross mean whose
#' error around its GCA is `s2s / c + s2e / (c r)`, so the correlation between
#' the true and estimated GCA is the square root of the heritability of that
#' mean. The SCA term is the Sprague and Tatum (1942) argument for more
#' testers. It describes least squares; BLUP on a connected design exceeds it.
#'
#' @param c Crosses (testers) per line.
#' @param r Plots per cross.
#' @param s2g,s2s,s2e GCA, SCA and plot-error variances.
#' @return The accuracy, vectorised over all arguments.
#' @export
#' @examples
#' gca_accuracy_theory(c = 1:4, r = 1, s2g = 8, s2s = 3, s2e = 42)
gca_accuracy_theory <- function(c, r, s2g, s2s, s2e) {
  sqrt(s2g / (s2g + s2s / c + s2e / (c * r)))
}

#' Simulate the true combining abilities of a complete factorial
#'
#' i.i.d. normal GCA in each pool and SCA for every cell; the SCA matrix is
#' double-centred so that the GCA are exactly the row and column effects of the
#' factorial, which is the quantity a breeder growing every hybrid without
#' error would estimate.
#'
#' @inheritParams design_tester
#' @param s2A,s2B,s2S GCA variances of the two pools and the SCA variance.
#' @return A list: `gA` (length `nA`), `gB` (length `nB`), `S` (`nA x nB`).
#' @export
simulate_factorial <- function(nA, nB, s2A, s2B, s2S) {
  S <- matrix(stats::rnorm(nA * nB, sd = sqrt(s2S)), nA, nB)
  S <- S - outer(rowMeans(S), colMeans(S), "+") + mean(S)
  list(gA = stats::rnorm(nA, sd = sqrt(s2A)),
       gB = stats::rnorm(nB, sd = sqrt(s2B)), S = S)
}

#' Simulate the cross means a plan would produce
#'
#' @param plan A plan with a `reps` column (see [design_reps]); without one,
#'   one plot per cross.
#' @param truth A list as returned by [simulate_factorial].
#' @param s2e Plot-error variance.
#' @return `plan` with a column `y`, the observed cross mean.
#' @export
simulate_cross_means <- function(plan, truth, s2e) {
  r <- if (is.null(plan$reps)) rep(1L, nrow(plan)) else plan$reps
  ij <- cbind(plan$parent1, plan$parent2)
  plan$y <- truth$gA[plan$parent1] + truth$gB[plan$parent2] + truth$S[ij] +
    stats::rnorm(nrow(plan), sd = sqrt(s2e / r))
  plan
}

#' Estimate GCA from cross means: least squares or BLUP
#'
#' Both solve the same weighted normal equations, with cross-mean weights
#' `1 / (s2S + s2e / r)` -- SCA is part of the cross-level residual, since each
#' cross has its own SCA. BLUP adds `1 / s2A` and `1 / s2B` to the GCA diagonal
#' (variances known, identity kernels); least squares adds nothing, is solved
#' by the Moore-Penrose inverse and centred within each connected component,
#' because contrasts across components are not estimable. A line in no cross
#' gets 0, the pool mean -- which BLUP does on its own.
#'
#' @inheritParams design_diagnostics
#' @param plan A plan with columns `y` and optionally `reps`.
#' @param s2A,s2B,s2S,s2e Variance components, treated as known.
#' @param method `"blup"` or `"ls"`.
#' @return A list: `gA`, `gB`, the estimates for every candidate line.
#' @export
fit_gca <- function(plan, nA, nB, s2A, s2B, s2S, s2e,
                    method = c("blup", "ls")) {
  method <- match.arg(method)
  r <- if (is.null(plan$reps)) rep(1, nrow(plan)) else plan$reps
  w <- 1 / (s2S + s2e / r)
  X <- gca_matrix(plan, nA, nB)
  C <- crossprod(X, X * w)
  rhs <- crossprod(X, plan$y * w)
  if (method == "blup") {
    diag(C) <- diag(C) + c(0, rep(1 / s2A, nA), rep(1 / s2B, nB))
    b <- solve(C, rhs)
  } else {
    s <- svd(C)
    keep <- s$d > max(s$d) * 1e-10
    b <- s$v[, keep, drop = FALSE] %*%
      (crossprod(s$u[, keep, drop = FALSE], rhs) / s$d[keep])
  }
  g <- drop(b)[-1]
  if (method == "ls") {
    comp <- design_components(plan, nA, nB)
    for (k in unique(stats::na.omit(comp))) {
      ia <- which(comp[seq_len(nA)] == k)
      ib <- which(comp[nA + seq_len(nB)] == k)
      g[ia] <- g[ia] - mean(g[ia])
      g[nA + ib] <- g[nA + ib] - mean(g[nA + ib])
    }
    g[is.na(comp)] <- 0
  }
  list(gA = g[seq_len(nA)], gB = g[nA + seq_len(nB)])
}

#' Seed-production and cost parameters of a crossing plan
#'
#' **Every default is an illustrative placeholder**, an order of magnitude for a
#' public maize programme, not a costed figure. The structure of
#' [cross_cost] is what is on offer; the levels must be replaced per programme.
#'
#' @param ... Named overrides of any default.
#' @return A named list.
#' @export
cross_cost_par <- function(...) {
  utils::modifyList(list(
    seed_per_plot = 60,          # kernels per two-row yield plot
    cost_per_plot = 30,
    seed_per_ear = 250,          # usable kernels per hand-pollinated ear
    pollination_success = 0.80,
    min_ears_per_cross = 2,
    plants_per_row = 20,
    pollen_uses_per_plant = 3,   # pollinations one male plant can serve
    cost_per_nursery_row = 12,
    cost_per_pollination = 2.5,
    cost_per_line_geno = 25,
    cost_fixed = 20000,
    max_nursery_rows = 1200,
    max_plots = 3000), list(...))
}

#' What a crossing plan costs to make and to test
#'
#' The accounting chain from plots back to the nursery:
#' seed per cross = `seed_per_plot * reps`; ears = `max(min_ears,
#' ceil(seed / seed_per_ear))`; pollinations = `ceil(ears /
#' pollination_success)`; female rows = per pool-A parent,
#' `ceil(pollinations / plants_per_row)`; male rows = per pool-B parent,
#' `ceil(pollinations / (plants_per_row * pollen_uses_per_plant))`, at least
#' one. A k-tester plan needs few male rows; a sparse factorial needs every
#' candidate of both pools in the nursery.
#'
#' @inheritParams design_diagnostics
#' @param plan A plan with a `reps` column.
#' @param par Parameters from [cross_cost_par].
#' @param genotyped Lines charged for genotyping. Default: every line in the
#'   plan.
#' @return A named numeric vector: crosses, plots, ears, pollinations,
#'   nursery rows, genotyped lines, the cost components and `total`, plus
#'   `feasible` (1 when nursery and field capacities hold).
#' @export
cross_cost <- function(plan, nA, nB, par = cross_cost_par(), genotyped = NULL) {
  ears <- pmax(par$min_ears_per_cross,
               ceiling(par$seed_per_plot * plan$reps / par$seed_per_ear))
  poll <- ceiling(ears / par$pollination_success)
  pA <- tapply(poll, plan$parent1, sum)
  pB <- tapply(poll, plan$parent2, sum)
  rows <- sum(ceiling(pA / par$plants_per_row)) +
    sum(pmax(1, ceiling(pB / (par$plants_per_row * par$pollen_uses_per_plant))))
  geno <- if (is.null(genotyped)) length(pA) + length(pB) else genotyped
  plots <- sum(plan$reps)
  out <- c(crosses = nrow(plan), plots = plots, ears = sum(ears),
           pollinations = sum(poll), nursery_rows = rows, genotyped = geno,
           cost_plots = plots * par$cost_per_plot,
           cost_pollination = sum(poll) * par$cost_per_pollination,
           cost_nursery = rows * par$cost_per_nursery_row,
           cost_genotyping = geno * par$cost_per_line_geno,
           cost_fixed = par$cost_fixed)
  c(out, total = sum(out[7:11]),
    feasible = as.numeric(rows <= par$max_nursery_rows && plots <= par$max_plots))
}
