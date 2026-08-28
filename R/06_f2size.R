# Sizing a segregating population from a wide biparental cross, F1 -> F4.
#
# The simulated space is ANCESTRY, not alleles: each genome position is coded
# 0 (from parent P1) or 1 (from parent P2). For a wide biparental cross between
# two divergent heterotic groups this is the right abstraction -- essentially
# every locus polymorphic between the parents is biallelic, so ancestry is a
# sufficient statistic. "Allele frequency" here always means "frequency of P1
# ancestry".
#
# Assumptions, and their limits, are documented on each function. The two that
# most often surprise people:
#
#   * With fully homozygous parents every F1 plant is genetically identical and
#     the genetic Ne of the F1 is 1. Sizing the F1 is therefore a logistical
#     decision, not a genetic one -- unless the parents carry residual
#     heterozygosity, which is what f1_sizing() addresses.
#   * Recombination follows Haldane with no interference. Real maize has strong
#     positive interference, so the simulated block-length distribution has a
#     slightly longer tail than reality. Mean block lengths and allele
#     frequencies are unaffected.

# --- 1. Default configuration --------------------------------------------------

#' Composite maize map: chromosome lengths in cM
#'
#' Approximate lengths from a classical composite maize map, about 1670 cM in
#' total. Do **not** substitute IBM-type lengths (from intermated RILs): those
#' are inflated 5-10x by construction and will make every sizing answer wrong.
#'
#' @format A numeric vector of 10 chromosome lengths in cM.
#' @export
maize_chr_len <- c(240, 200, 190, 180, 175, 150, 145, 140, 130, 120)  # cM

#' Default segregation distorters
#'
#' Two gametophytic distorters (pollen-incompatibility type, acting only on the
#' male gamete) and one zygotic distorter (partial hybrid lethality). The loci
#' are **plausible, not measured** -- bin 4.05 (ga1-like), bin 1.10 and bin 5.03.
#' Replace them with your own if you have F2 genotyping data.
#'
#' @format A data frame with columns `chr`, `pos_cM`, `type`
#'   (`"gametic"`/`"zygotic"`), `k` (transmission of the P1 allele through a
#'   heterozygous male; 0.5 is neutral), `w00`, `w01`, `w11` (genotype
#'   fitnesses) and `label`.
#' @export
f2_distorters <- data.frame(
  chr    = c(4,          1,         5),
  pos_cM = c(75,         160,       60),
  type   = c("gametic",  "zygotic", "gametic"),
  k      = c(0.80,       NA,        0.68),   # transmission of the P1 allele (male)
  w00    = c(NA,         1.00,      NA),     # fitness P1P1
  w01    = c(NA,         1.00,      NA),     # fitness heterozygote
  w11    = c(NA,         0.45,      NA),     # fitness P2P2 (subvital)
  label  = c("ga1-like (4.05)", "partial lethal (1.10)", "weak gametic (5.03)"),
  stringsAsFactors = FALSE
)

#' Default experiment options
#'
#' @format A list controlling the sizing experiment: marker `spacing_cM`, the
#'   population-size grid `n_grid`, the `schemes` to compare, the adaptive
#'   replication parameters (`n_rep`, `rep_max_mult`, `rep_pivot`), the bulk and
#'   attrition parameters, and the reference sizes used for block and graphical
#'   genotype output.
#' @export
f2_opt <- list(
  spacing_cM   = 2,
  n_grid       = seq(10, 400, by = 20),
  schemes      = c("ssd", "ssd_attr", "bulk", "syn1", "syn2"),
  n_rep        = 10,     # reference replicates (at large N)
  rep_max_mult = 4,      # replicate ceiling = n_rep * rep_max_mult
  rep_pivot    = 200,    # N at which reps == n_rep
  attrition    = 0.15,   # used only by ssd_attr
  beta_bulk    = 6,      # intensity of natural selection in the bulk
  k_multilocus = c(3, 5, 8, 10),
  n_ref_block  = 300,    # N used for blocks / graphical genotype
  n_ref_small  = 20,     # small reference N, for contrast
  n_block_lines = 40,
  seed         = 20260828
)

# --- 2. Genetic map -------------------------------------------------------------

#' Build a marker map on a regular grid
#'
#' Markers are placed on a regular cM grid along each chromosome. Recombination
#' between adjacent markers `d` cM apart follows Haldane with no interference,
#' `r = 0.5 (1 - exp(-2 d / 100))`. The first marker of each chromosome gets
#' `r = 0.5`, which produces independent segregation between chromosomes
#' automatically.
#'
#' @param chr_len_cM Chromosome lengths in cM, see [maize_chr_len].
#' @param spacing_cM Marker spacing in cM.
#' @return A list with `chr`, `pos`, `r`, `m`, `first`, `chr_len`, `total_cM`,
#'   `edges` (interval boundaries, for converting marker runs to cM) and
#'   `spacing`.
#' @export
build_map <- function(chr_len_cM = maize_chr_len, spacing_cM = 2) {
  chr <- integer(0); pos <- numeric(0)
  for (i in seq_along(chr_len_cM)) {
    p <- seq(0, chr_len_cM[i], by = spacing_cM)
    if (p[length(p)] < chr_len_cM[i] - 1e-9) p <- c(p, chr_len_cM[i])
    chr <- c(chr, rep.int(i, length(p)))
    pos <- c(pos, p)
  }
  m <- length(pos)
  first <- c(TRUE, chr[-1] != chr[-m])
  d <- c(0, diff(pos))
  r <- ifelse(first, 0.5, 0.5 * (1 - exp(-2 * d / 100)))

  # midpoint boundaries, to convert runs of markers into cM
  edges <- vector("list", length(chr_len_cM))
  for (i in seq_along(chr_len_cM)) {
    p <- pos[chr == i]
    edges[[i]] <- c(0, (p[-1] + p[-length(p)]) / 2, chr_len_cM[i])
  }

  list(chr = chr, pos = pos, r = r, m = m, first = first,
       chr_len = chr_len_cM, total_cM = sum(chr_len_cM), edges = edges,
       spacing = spacing_cM)
}

#' Index of the marker nearest a map position
#'
#' @param map A map from [build_map].
#' @param chr Chromosome number.
#' @param pos_cM Position in cM.
#' @return An integer marker index.
#' @export
marker_index <- function(map, chr, pos_cM) {
  w <- which(map$chr == chr)
  w[which.min(abs(map$pos[w] - pos_cM))]
}

# --- 3. Meiosis engine (vectorised) --------------------------------------------

#' Column-wise cumulative sum
#'
#' Avoids `apply`, which is the bottleneck in the meiosis inner loop.
#'
#' @param M A numeric matrix.
#' @return A matrix of the same shape with column-wise cumulative sums.
#' @export
col_cumsum <- function(M) {
  m <- nrow(M); n <- ncol(M)
  cv <- cumsum(M); dim(cv) <- c(m, n)
  if (n > 1) cv <- cv - rep(c(0, cv[m, 1:(n - 1)]), each = m)
  cv
}

#' One meiosis per individual
#'
#' The ancestry path along the markers is a Markov chain: the parental haplotype
#' switches with probability `r[j]` at interval `j`.
#'
#' @param H1,H2 `m x n` haplotype matrices, one column per individual.
#' @param r Recombination fractions per interval, length `m`.
#' @return An `m x n` matrix of gametes.
#' @export
meiosis <- function(H1, H2, r) {
  m <- nrow(H1); n <- ncol(H1)
  if (n == 0) return(H1)
  sw <- stats::runif(m * n) < r    # r has length m, recycled down each column
  dim(sw) <- c(m, n)
  path <- col_cumsum(sw) %% 2      # 0 -> take H1, 1 -> take H2
  H1 * (1 - path) + H2 * path
}

#' Meiosis with gametophytic selection
#'
#' Rejection sampling on the **whole gamete**, so it is exact rather than an
#' approximation -- and the region linked to the distorter is dragged along,
#' which is exactly the phenomenon of interest.
#'
#' @param H1,H2 `m x n` haplotype matrices.
#' @param map A map from [build_map].
#' @param dist Distortion specification from [make_distortion].
#' @param max_try Rejection attempts before falling back to unselected meiosis.
#' @return An `m x n` matrix of gametes.
#' @export
meiosis_sel <- function(H1, H2, map, dist, max_try = 60) {
  n <- ncol(H1)
  if (n == 0) return(H1)
  if (length(dist$gam_idx) == 0) return(meiosis(H1, H2, map$r))
  out  <- matrix(NA_real_, nrow(H1), n)
  need <- seq_len(n); tries <- 0
  while (length(need) > 0 && tries < max_try) {
    G  <- meiosis(H1[, need, drop = FALSE], H2[, need, drop = FALSE], map$r)
    wt <- rep(1, length(need))
    for (j in seq_along(dist$gam_idx)) {
      a  <- G[dist$gam_idx[j], ]
      wt <- wt * ((1 - a) * dist$gam_w0[j] + a * dist$gam_w1[j])
    }
    acc <- stats::runif(length(need)) < wt
    if (any(acc)) {
      out[, need[acc]] <- G[, acc, drop = FALSE]
      need <- need[!acc]
    }
    tries <- tries + 1
  }
  if (length(need) > 0)  # fallback: accept without selection, avoids an infinite loop
    out[, need] <- meiosis(H1[, need, drop = FALSE], H2[, need, drop = FALSE], map$r)
  out
}

#' Zygotic fitness of proposed offspring
#'
#' @param Gf,Gm Female and male gamete matrices.
#' @param dist Distortion specification from [make_distortion].
#' @return A numeric vector of relative fitnesses.
#' @export
zyg_fitness <- function(Gf, Gm, dist) {
  n <- ncol(Gf)
  w <- rep(1, n)
  if (length(dist$zyg_idx) == 0) return(w)
  for (j in seq_along(dist$zyg_idx)) {
    g <- Gf[dist$zyg_idx[j], ] + Gm[dist$zyg_idx[j], ]   # 0, 1, 2 doses of P2
    w <- w * ifelse(g == 0, dist$zyg_w[j, 1],
             ifelse(g == 1, dist$zyg_w[j, 2], dist$zyg_w[j, 3]))
  }
  w
}

#' Generic cross between indexed individuals
#'
#' @param pop A population, a list of `H1` and `H2` haplotype matrices.
#' @param mo,fa Integer vectors of column indices. `mo == fa` is selfing.
#' @param map A map from [build_map].
#' @param dist Distortion specification from [make_distortion].
#' @param max_try Rejection attempts before accepting without zygotic selection.
#' @return A new population.
#' @export
cross_indices <- function(pop, mo, fa, map, dist, max_try = 60) {
  n <- length(mo); m <- map$m
  H1 <- matrix(NA_real_, m, n); H2 <- matrix(NA_real_, m, n)
  need <- seq_len(n); tries <- 0
  while (length(need) > 0 && tries < max_try) {
    i  <- need
    gf <- meiosis(pop$H1[, mo[i], drop = FALSE], pop$H2[, mo[i], drop = FALSE], map$r)
    gm <- meiosis_sel(pop$H1[, fa[i], drop = FALSE], pop$H2[, fa[i], drop = FALSE], map, dist)
    acc <- stats::runif(length(i)) < zyg_fitness(gf, gm, dist)
    if (any(acc)) {
      H1[, i[acc]] <- gf[, acc, drop = FALSE]
      H2[, i[acc]] <- gm[, acc, drop = FALSE]
      need <- need[!acc]
    }
    tries <- tries + 1
  }
  if (length(need) > 0) {
    gf <- meiosis(pop$H1[, mo[need], drop = FALSE], pop$H2[, mo[need], drop = FALSE], map$r)
    gm <- meiosis_sel(pop$H1[, fa[need], drop = FALSE], pop$H2[, fa[need], drop = FALSE], map, dist)
    H1[, need] <- gf; H2[, need] <- gm
  }
  list(H1 = H1, H2 = H2)
}

#' Make an F1 population from two fully homozygous parents
#'
#' Every F1 plant is genetically identical: `H1` is all P1 ancestry, `H2` all
#' P2. This is why the genetic `Ne` of the F1 is 1.
#'
#' @param map A map from [build_map].
#' @param n Number of plants.
#' @return A population.
#' @export
make_F1 <- function(map, n) {
  list(H1 = matrix(0, map$m, n), H2 = matrix(1, map$m, n))
}

# --- 4. Segregation distortion --------------------------------------------------

#' Compile a distortion specification onto a map
#'
#' @param map A map from [build_map].
#' @param spec A distorter table, see [f2_distorters], or `NULL`.
#' @param active Set `FALSE` for the neutral scenario.
#' @return A list with gametic indices and weights, zygotic indices and the
#'   genotype fitness matrix, plus the `spec` used.
#' @export
make_distortion <- function(map, spec = f2_distorters, active = TRUE) {
  out <- list(gam_idx = integer(0), gam_w0 = numeric(0), gam_w1 = numeric(0),
              zyg_idx = integer(0), zyg_w = matrix(numeric(0), 0, 3),
              spec = if (active) spec else spec[0, , drop = FALSE])
  if (!active || is.null(spec) || nrow(spec) == 0) return(out)
  for (i in seq_len(nrow(spec))) {
    idx <- marker_index(map, spec$chr[i], spec$pos_cM[i])
    if (spec$type[i] == "gametic") {
      k  <- spec$k[i]
      w  <- c(k, 1 - k); w <- w / max(w)   # rescale so the maximum is 1
      out$gam_idx <- c(out$gam_idx, idx)
      out$gam_w0  <- c(out$gam_w0, w[1])   # gamete carrying P1 ancestry (= 0)
      out$gam_w1  <- c(out$gam_w1, w[2])
    } else {
      w <- c(spec$w00[i], spec$w01[i], spec$w11[i]); w <- w / max(w)
      out$zyg_idx <- c(out$zyg_idx, idx)
      out$zyg_w   <- rbind(out$zyg_w, w)
    }
  }
  out
}

# --- 5. Breeding schemes --------------------------------------------------------

#' Adaptive replication per grid point
#'
#' The cost of one replicate is roughly proportional to `N`, so spending more
#' replicates at small `N` is nearly free -- and small `N` is exactly where the
#' between-replicate variance is largest. This gives smooth curves in the small
#' range without multiplying total runtime.
#'
#' @param N Population size.
#' @param opt Options, see [f2_opt].
#' @return An integer number of replicates.
#' @export
reps_for_N <- function(N, opt) {
  pmin(opt$n_rep * opt$rep_max_mult,
       pmax(opt$n_rep, round(opt$n_rep * opt$rep_pivot / N)))
}

#' Natural-selection weights for the bulk scheme
#'
#' Plants carrying more P1 (adapted-parent) genome contribute more seed. This
#' is what makes bulk the worst scheme across the whole range: natural selection
#' removes precisely the germplasm the wide cross was made to introduce.
#'
#' @param pop A population.
#' @param beta Intensity of natural selection.
#' @return A numeric vector of sampling probabilities.
#' @export
bulk_weights <- function(pop, beta) {
  z <- 1 - colMeans((pop$H1 + pop$H2) / 2)  # share of genome coming from P1
  w <- exp(beta * (z - mean(z)))
  w / sum(w)
}

#' Run one breeding scheme from F1 to F4
#'
#' Schemes: `"ssd"` (single seed descent, the neutral reference -- no selection,
#' no drift beyond the meiotic), `"ssd_attr"` (SSD with per-generation
#' attrition), `"bulk"` (natural selection on whole-genome ancestry), and
#' `"syn1"` / `"syn2"` (one or two random-intercrossing cycles before selfing).
#'
#' All schemes end after two selfing generations, so panel heterozygosity is
#' 0.125.
#'
#' @param scheme One of the scheme names above.
#' @param n_F2 Number of F2 plants.
#' @param map A map from [build_map].
#' @param dist Distortion specification from [make_distortion].
#' @param opt Options, see [f2_opt].
#' @return The final population.
#' @export
run_scheme <- function(scheme, n_F2, map, dist, opt = f2_opt) {
  F1  <- make_F1(map, n_F2)
  pop <- cross_indices(F1, seq_len(n_F2), seq_len(n_F2), map, dist)  # F2

  if (scheme %in% c("syn1", "syn2")) {
    n_syn <- as.integer(sub("syn", "", scheme))
    for (cy in seq_len(n_syn)) {
      n  <- ncol(pop$H1)
      mo <- sample.int(n); fa <- sample.int(n)
      bad <- mo == fa
      if (any(bad)) fa[bad] <- (fa[bad] %% n) + 1L      # avoid selfing
      pop <- cross_indices(pop, mo, fa, map, dist)
    }
  }

  for (g in 1:2) {                      # two selfings -> H = 0.125
    n <- ncol(pop$H1)
    if (scheme == "bulk") {
      idx <- sample.int(n, n, replace = TRUE, prob = bulk_weights(pop, opt$beta_bulk))
    } else {
      idx <- seq_len(n)
    }
    pop <- cross_indices(pop, idx, idx, map, dist)
    if (scheme == "ssd_attr") {
      keep <- which(stats::runif(ncol(pop$H1)) > opt$attrition)
      if (length(keep) < 2) keep <- 1:2
      pop <- list(H1 = pop$H1[, keep, drop = FALSE],
                  H2 = pop$H2[, keep, drop = FALSE])
    }
  }
  pop
}

# --- 6. Metrics ------------------------------------------------------------------

#' Panel ancestry frequency
#'
#' The internal coding is 0 = P1, 1 = P2, so this returns the frequency of
#' **P1** ancestry: one minus the mean dosage.
#'
#' @param pop A population.
#' @return A numeric vector of length `m`.
#' @family F2 sizing metrics
#' @export
panel_freq <- function(pop) 1 - rowMeans((pop$H1 + pop$H2) / 2)

#' Panel heterozygosity
#'
#' @param pop A population.
#' @return A scalar.
#' @family F2 sizing metrics
#' @export
panel_het <- function(pop) mean(pop$H1 != pop$H2)

#' Diversity retained
#'
#' Mean ancestry heterozygosity relative to its maximum of 0.5, so `D = 1` means
#' every marker is still at 50:50 ancestry.
#'
#' @param p Ancestry frequencies from [panel_freq].
#' @return A scalar in `[0, 1]`.
#' @family F2 sizing metrics
#' @export
diversity_retained <- function(p) mean(2 * p * (1 - p)) / 0.5

#' Fraction of the genome near-fixed for one parent
#'
#' @param p Ancestry frequencies from [panel_freq].
#' @param thr Frequency threshold.
#' @return A scalar.
#' @family F2 sizing metrics
#' @export
fixed_fraction <- function(p, thr = 0.10) mean(p < thr | p > 1 - thr)

#' Fraction of the genome substantially skewed from 0.5
#'
#' @param p Ancestry frequencies from [panel_freq].
#' @param thr Absolute deviation threshold.
#' @return A scalar.
#' @family F2 sizing metrics
#' @export
skew_fraction <- function(p, thr = 0.15) mean(abs(p - 0.5) > thr)

#' Minimum minor ancestry frequency across the genome
#'
#' How close the panel came to losing a region entirely. The key metric at small
#' `N`, and it saturates earlier than diversity retained.
#'
#' @param p Ancestry frequencies from [panel_freq].
#' @return A scalar.
#' @family F2 sizing metrics
#' @export
min_minor_freq <- function(p) min(pmin(p, 1 - p))

#' Equivalent panel size
#'
#' From `D = 1 - (1 - H) / N`, so `N_eq = (1 - H) / (1 - D)`. Reads as "how many
#' F4 lines without distortion would give the diversity actually observed".
#'
#' This is a **communication device, not a Wright effective size**: it converts
#' a deterministic bias (segregation distortion) into a drift equivalent. Use it
#' to compare scenarios; never substitute it into an `Ne` formula.
#'
#' @param D Diversity retained, see [diversity_retained].
#' @param H Panel heterozygosity, 0.125 after two selfings.
#' @return A scalar.
#' @family F2 sizing metrics
#' @export
n_equivalent <- function(D, H = 0.125) (1 - H) / pmax(1 - D, 1e-9)

#' Lengths of parental ancestry blocks
#'
#' Block length depends only on the number of meioses, not on `N`. The
#' instrument against linkage drag is therefore an intercrossing cycle, not more
#' field area.
#'
#' @param pop A population.
#' @param map A map from [build_map].
#' @param n_lines Lines to sample.
#' @return A numeric vector of block lengths in cM.
#' @family F2 sizing metrics
#' @export
block_lengths <- function(pop, map, n_lines = 40) {
  n   <- ncol(pop$H1)
  sel <- if (n <= n_lines) seq_len(n) else sample.int(n, n_lines)
  res <- list(); z <- 1L
  for (i in sel) for (h in 1:2) {
    hap <- if (h == 1) pop$H1[, i] else pop$H2[, i]
    for (cc in seq_along(map$chr_len)) {
      k  <- which(map$chr == cc)
      rr <- rle(hap[k])
      en <- cumsum(rr$lengths)
      st <- c(1L, utils::head(en, -1) + 1L)
      e  <- map$edges[[cc]]
      res[[z]] <- e[en + 1] - e[st]; z <- z + 1L
    }
  }
  unlist(res)
}

#' Observed junctions per haplotype
#'
#' Used to check map expansion against [expected_junctions].
#'
#' @param pop A population.
#' @param map A map from [build_map].
#' @param n_lines Lines to sample.
#' @return A scalar.
#' @family F2 sizing metrics
#' @export
junctions_per_hap <- function(pop, map, n_lines = 40) {
  n   <- ncol(pop$H1)
  sel <- if (n <= n_lines) seq_len(n) else sample.int(n, n_lines)
  tot <- 0; cnt <- 0
  for (i in sel) for (h in 1:2) {
    hap <- if (h == 1) pop$H1[, i] else pop$H2[, i]
    ch  <- sum(hap[-1] != hap[-length(hap)] & !map$first[-1])
    tot <- tot + ch; cnt <- cnt + 1
  }
  tot / cnt
}

#' Expected junctions per haplotype, and mean block length
#'
#' Junction theory gives the recursion `A_(t+1) = A_t + L H_t`, with `L` the map
#' length in Morgans and `H_t` the parental heterozygosity. Selfing halves `H`;
#' random intercrossing leaves it unchanged.
#'
#' The consequence matters: each Syn cycle adds only `0.5 L` junctions, not
#' `1.0 L`, because the extra meiosis creates a junction only where the parent
#' is heterozygous, and `H = 0.5` at the F2/Syn stage.
#'
#' @param scheme Scheme name, see [run_scheme].
#' @param map A map from [build_map].
#' @return A named numeric vector `junctions`, `mean_block_cM`.
#' @family F2 sizing metrics
#' @export
expected_junctions <- function(scheme, map) {
  L <- map$total_cM / 100
  A <- L; H <- 0.5                       # an F2 individual
  n_syn <- if (grepl("^syn", scheme)) as.integer(sub("syn", "", scheme)) else 0
  for (i in seq_len(n_syn)) A <- A + L * H          # H unchanged
  for (i in 1:2) { A <- A + L * H; H <- H / 2 }     # two selfings
  c(junctions = A, mean_block_cM = map$total_cM / (A + length(map$chr_len)))
}

#' Probability of recovering a multilocus P2 homozygote
#'
#' Probability that at least one line in the panel is homozygous for P2 ancestry
#' at `k` loci, one per chromosome. This is the objective that keeps gaining
#' from larger `N` long after diversity retained has saturated.
#'
#' @param pop A population.
#' @param map A map from [build_map].
#' @param k Number of loci required.
#' @param n_draw Random locus sets to average over.
#' @return A probability.
#' @family F2 sizing metrics
#' @export
multilocus_recovery <- function(pop, map, k, n_draw = 300) {
  chrs_all <- seq_along(map$chr_len)
  hit <- 0
  for (d in seq_len(n_draw)) {
    cs  <- sample(chrs_all, k, replace = k > length(chrs_all))
    idx <- vapply(cs, function(cc) {
      w <- which(map$chr == cc); w[sample.int(length(w), 1)]
    }, integer(1))
    ok <- colSums(pop$H1[idx, , drop = FALSE] == 1 &
                  pop$H2[idx, , drop = FALSE] == 1) == k
    hit <- hit + any(ok)
  }
  hit / n_draw
}

# --- 7. Sizing the F1 (analytical, separate from the simulation) ---------------

#' Size the F1 given residual heterozygosity in the parents
#'
#' With fully homozygous parents the F1 is genetically uniform and its size is a
#' logistical decision. If the parents are not fully homozygous -- `F` around
#' 0.95 is common in programme lines -- each parent segregates at a fraction
#' `h_res` of loci. Each F1 plant receives one random gamete from each parent,
#' so at a segregating locus the chance of losing one of the two parental
#' alleles with `n` F1 plants is `2 (1/2)^n`.
#'
#' @param n_F1 Numbers of F1 plants to evaluate.
#' @param h_res Fraction of loci still segregating in a parent.
#' @param n_loci_eff Effective number of independent loci.
#' @return A data frame with the per-locus loss probability and the expected
#'   number of segregating loci lost.
#' @export
f1_sizing <- function(n_F1 = 1:30, h_res = 0.05, n_loci_eff = 5000) {
  data.frame(
    n_F1 = n_F1,
    p_loss_per_locus = 2 * 0.5^n_F1,
    expected_loci_lost = h_res * n_loci_eff * 2 * 0.5^n_F1
  )
}

# --- 8. The experiment ----------------------------------------------------------

#' Run the full population-sizing experiment
#'
#' Sweeps every scheme across the population-size grid, with adaptive
#' replication, and returns the results table plus the by-products needed for
#' the figures: per-marker frequencies, block-length distributions, example
#' populations for graphical genotypes, and multilocus recovery.
#'
#' At the default settings this takes several minutes. The book ships the
#' results and regenerates them only on demand.
#'
#' @param opt Options, see [f2_opt].
#' @param verbose Print progress per grid point.
#' @return A list with `res` (the results data frame), `map`, `dist`, `n_ref`,
#'   `n_sml`, `pmat`, `blocks`, `example`, `ml` and `opt`.
#' @export
f2_run_experiment <- function(opt = f2_opt, verbose = TRUE) {
  set.seed(opt$seed)
  map  <- build_map(maize_chr_len, opt$spacing_cM)
  dist <- make_distortion(map, f2_distorters, active = TRUE)

  n_ref  <- opt$n_grid[which.min(abs(opt$n_grid - opt$n_ref_block))]
  n_sml  <- opt$n_grid[which.min(abs(opt$n_grid - opt$n_ref_small))]
  rows   <- list(); z <- 1L
  pmat   <- list()   # p per marker x replicate, for a correct standard error
  blocks <- list()   # block-length distribution at the reference N
  example <- list()  # example populations for the graphical genotype
  ml     <- list()

  for (sch in opt$schemes) {
    for (N in opt$n_grid) {
      nrep <- reps_for_N(N, opt)
      P <- matrix(NA_real_, map$m, nrep)
      acc <- list()
      for (rep in seq_len(nrep)) {
        pop <- run_scheme(sch, N, map, dist, opt)
        p   <- panel_freq(pop)
        P[, rep] <- p
        acc[[rep]] <- c(
          div     = diversity_retained(p),
          fixed   = fixed_fraction(p),
          skew    = skew_fraction(p),
          pmin    = min_minor_freq(p),
          het     = panel_het(pop),
          n_final = ncol(pop$H1),
          junc    = junctions_per_hap(pop, map, 20)
        )
        if (rep == 1 && N == n_ref) {
          blocks[[sch]] <- block_lengths(pop, map, opt$n_block_lines)
        }
        if (rep == 1 && N %in% c(n_ref, n_sml)) {
          kk <- 1:min(30, ncol(pop$H1))
          example[[paste(sch, N)]] <- list(H1 = pop$H1[, kk, drop = FALSE],
                                           H2 = pop$H2[, kk, drop = FALSE])
        }
        if (rep == 1 && sch == "ssd") {
          for (kk in opt$k_multilocus)
            ml[[paste(N, kk)]] <- data.frame(N = N, k = kk,
                                             P = multilocus_recovery(pop, map, kk))
        }
      }
      A <- do.call(rbind, acc)
      se_p <- mean(apply(P, 1, stats::sd))   # correct SE: between replicates
      rows[[z]] <- data.frame(
        scheme = sch, N = N, n_rep = nrep,
        div = mean(A[, "div"]),   div_sd = stats::sd(A[, "div"]),
        fixed = mean(A[, "fixed"]), skew = mean(A[, "skew"]),
        pmin = mean(A[, "pmin"]), pmin_sd = stats::sd(A[, "pmin"]),
        het = mean(A[, "het"]),
        n_final = mean(A[, "n_final"]),
        junc = mean(A[, "junc"]),
        se_p = se_p,
        n_eq = n_equivalent(mean(A[, "div"]))
      ); z <- z + 1L
      pmat[[paste(sch, N)]] <- rowMeans(P)
      if (verbose)
        cat(sprintf("  %-9s N=%-3d r=%-2d  D=%.4f  N_eq=%5.0f  SE(p)=%.4f  min(minor)=%.3f\n",
                    sch, N, nrep, mean(A[, "div"]), n_equivalent(mean(A[, "div"])),
                    se_p, mean(A[, "pmin"])))
    }
  }
  list(res = do.call(rbind, rows), map = map, dist = dist, n_ref = n_ref,
       n_sml = n_sml, pmat = pmat, blocks = blocks, example = example,
       ml = do.call(rbind, ml), opt = opt)
}
