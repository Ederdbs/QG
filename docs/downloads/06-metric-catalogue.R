#' # A catalogue of metrics on `f` {#sec-catalogue}
#' 
# 06-metric-catalogue -- standalone script of the chapter 06-metric-catalogue.qmd
# Book: https://ederdbs.github.io/QG/06-metric-catalogue.html
#
# Reproduces every analysis of the chapter, in order; the chapter text is kept
# as comments (#') so the script reads as the chapter does.
#
# Requirements: R >= 4.1 and the 'hybdiv' package (this repository's root):
#   install.packages('remotes'); remotes::install_github('Ederdbs/QG')
# Run it top to bottom in an empty working directory.

library(hybdiv)
set.seed(2026)

# The teaching scale, the default of the live examples: small enough that a
# full render takes minutes, large enough that none of the identities hold by
# accident. Chapters that need another scale set it in their own chunks. The
# production scale is n_pool_A = n_pool_B = 71 and m = 25000; see the note in
# each chapter where the difference matters.
book_cfg <- utils::modifyList(
  hybdiv::sim_config,
  list(n_pool_A = 25, n_pool_B = 25, m = 2000, seed = 1)
)

# Paths to the cached artefacts, so chapters never guess.

# Rounded table helper, used wherever a metric panel is printed.
fmt <- function(x, digits = 4) {
  # A matrix must become a data frame first: `x[num] <- lapply(...)` on a
  # matrix recycles the logical over the flattened array and assigns a list
  # back, silently turning the matrix into a list.
  if (is.matrix(x)) x <- as.data.frame(x)
  if (is.data.frame(x)) {
    num <- vapply(x, is.numeric, logical(1))
    x[num] <- lapply(x[num], round, digits)
    x
  } else round(x, digits)
}

# A value in scientific notation for inline prose, as a complete math span. A
# numeric inline value that small or large leaves knitr as bare TeX,
# `4\times 10^{-13}`, from which Pandoc drops `\times 10` (the book printed
# 4^{-13}); a string passes through untouched. Not for use inside $...$.
fmt_sci <- function(x, digits = 2) {
  s <- sprintf("%.*e", digits - 1, x)
  sprintf("$%s \\times 10^{%d}$", sub("e.*", "", s), as.integer(sub(".*e", "", s)))
}
stopifnot(identical(fmt_sci(c(3.7e-13, 9.96e-5)),
                    c("$3.7 \\times 10^{-13}$", "$1.0 \\times 10^{-4}$")))

# One palette for every live figure: the two heterotic pools get fixed colours
# (A blue, B amber, a colour-blind-safe pair); red marks the constraint or the
# loss; greys carry everything else. Chapters pass these instead of hex codes.
book_pal <- c(A = "#1f5f8b", B = "#d98e04", loss = "#b2182b",
              ink = "#14202b", mid = "grey45", light = "grey85")

# Cached artefacts (expensive sweeps) are fetched from the repository on first use.
.book_get <- function(dir, ...) {
  f <- file.path(dir, ...)
  if (!file.exists(f)) {
    dir.create(dirname(f), showWarnings = FALSE, recursive = TRUE)
    utils::download.file(paste0('https://raw.githubusercontent.com/Ederdbs/QG/main/book/', f), f, quiet = TRUE, mode = 'wb')
  }
  f
}
book_data <- function(...) .book_get('data', ...)
book_fig  <- function(...) .book_get('figs', ...)
ctx <- simulate_data(book_cfg)
n_sel <- 60
set.seed(41)
idx <- sample.int(ctx$N, n_sel)

#' 
#' Every metric in this chapter has the same signature, `f(idx, ctx) -> scalar`,
#' and every one operates on the molecular coancestry matrix from
#' @sec-coancestry. That uniformity is not tidiness: it is what makes metrics
#' interchangeable inside an optimiser, and it is what lets @sec-choosing benchmark
#' them against each other on equal terms.
#' 
#' The chapter also settles the question of what "no loss" means, which turns out
#' to be less obvious than it sounds.
#' 
#' ## Group coancestry, and the off-diagonal problem
#' 
#' The group coancestry [@cockerham1967] of a set $S$ of $n$ individuals is the
#' mean of **all** $n^2$ elements, diagonal included:
#' 
#' $$\theta_S \;=\; \frac{1}{n^2}\sum_{i \in S}\sum_{j \in S} f_{ij}
#'             \;=\; \frac{1}{n^2}\,\mathbf{1}'\mathbf{f}_S\mathbf{1}.$$ {#eq-catalogue-theta}
#' 
#' It is the probability that two alleles sampled at random *from the whole set*
#' are identical -- including the possibility that both come from the same
#' individual. That is why the diagonal enters: it is the chance of sampling the
#' same individual twice, which is entirely real when the set is used as a crossing
#' pool.
#' 
#' Splitting the diagonal mean $\bar f_d$ from the off-diagonal mean $\bar f_o$ of
#' @eq-catalogue-theta,
#' 
#' $$\theta_S \;=\; \frac{\bar f_d}{n} \;+\; \frac{n-1}{n}\,\bar f_o .$$ {#eq-catalogue-split}
#' 
#' So the off-diagonal mean -- the metric many programmes already report -- is one
#' of two terms. When $\bar f_d$ varies little across individuals, which is the
#' case in an all-F1 population, the two rank almost identically
#' (@tbl-catalogue-offdiag).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-catalogue-offdiag
#| tbl-cap: "Group coancestry $\\theta_S$ (@eq-catalogue-theta, `theta_group()`) and the off-diagonal mean $\\bar f_o$ (`mean_offdiag()`). Five selections of $n$ = 60 from the $N$ = 625 hybrids of the teaching scale (25 + 25 lines, 2000 markers, simulation seed 1): random, a random subset (seed 42); trunc_cap, truncation on the index with each line used at most 4 times; greedy_w, greedy on index and coancestry with index weight $\\omega$ = 0.001 (argument `w` of `sel_greedy()`); greedy_div, greedy on coancestry alone ($\\omega$ = 0); truncation, the top 60 on the index. The chunk asserts @eq-catalogue-split on every selection with `all.equal()`. Dimensionless, five decimals."
# w = 0.001: the index is in s.d. units and a theta step is ~1e-5, so w = 1
# already reproduces truncation; 0.001 is a genuine trade-off point.
set.seed(42)
sels <- list(random     = sel_random(ctx, n_sel),
             trunc_cap  = sel_truncation_cap(ctx, n_sel),
             greedy_w   = sel_greedy(ctx, n_sel, w = 0.001),
             greedy_div = sel_greedy(ctx, n_sel, w = 0),
             truncation = sel_truncation(ctx, n_sel))
# the scale stated in this chapter's table captions
stopifnot(n_sel == 60, ctx$N == 625, ctx$n_lines == 50, ctx$m == 2000)

# @eq-catalogue-split on every selection
stopifnot(all(vapply(sels, function(s) {
  fS <- ctx[["f"]][s, s, drop = FALSE]; n <- length(s)
  isTRUE(all.equal(theta_group(s, ctx),
                   mean(diag(fS)) / n + (n - 1) / n * mean(fS[upper.tri(fS)])))
}, logical(1))))

cmp <- t(sapply(sels, function(s)
  c(theta = theta_group(s, ctx), offdiag = mean_offdiag(s, ctx))))
rank_cor <- cor(cmp[, "theta"], cmp[, "offdiag"], method = "spearman")
fmt(as.data.frame(cmp), 5)

#' 
#' Over the five selections the Spearman rank correlation between $\theta_S$ and
#' $\bar f_o$ is `r fmt(rank_cor, 3)`; five points are a check of the ordering,
#' not an estimate of the correlation.
#' 
#' The off-diagonal metric ranks correctly. What it does not give you is an
#' interpretable scale or a defensible baseline -- which is what the rest of this
#' chapter supplies.
#' 
#' ## Gene diversity: $\theta$ and $H_e$ are the same quantity {#sec-identity}
#' 
#' This is the result that simplifies everything downstream. Write $x_{ik} \in \{0, 0.5, 1\}$
#' for the marker value of individual $i$ at marker $k$, one of $m$ markers.
#' Starting from @eq-catalogue-theta and swapping the order of summation, the double
#' sum factors:
#' 
#' $$\frac{1}{n^2}\sum_i\sum_j x_{ik}x_{jk}
#'   = \Big(\frac{1}{n}\sum_i x_{ik}\Big)^2 = \bar p_k^2,$$
#' 
#' with $\bar p_k$ the **group's** allele frequency. Hence
#' 
#' $$\theta_S = \frac{1}{m}\sum_k \big(\bar p_k^2 + \bar q_k^2\big),
#'   \qquad
#'   GD_S = 1 - \theta_S = \frac{1}{m}\sum_k 2\,\bar p_k \bar q_k \;\equiv\; H_e,$$ {#eq-catalogue-gd-he}
#' 
#' which is exactly Nei's gene diversity [@nei1973]. **Group coancestry and
#' expected heterozygosity are not two independent checks. They are one quantity
#' written two ways.**
#' 
## -----------------------------------------------------------------------------
stopifnot(isTRUE(all.equal(theta_group(idx, ctx), theta_from_freq(idx, ctx))),
          isTRUE(all.equal(gene_diversity(idx, ctx), he_nei(idx, ctx))))
c(via_submatrix = theta_group(idx, ctx),
  via_frequency = theta_from_freq(idx, ctx),
  difference    = theta_group(idx, ctx) - theta_from_freq(idx, ctx))

c(GD = gene_diversity(idx, ctx), He_Nei = he_nei(idx, ctx))

#' 
#' The chunk asserts both equalities with `all.equal()` at its default relative
#' tolerance, $1.5 \times 10^{-8}$; the printed difference is
#' `r signif(theta_group(idx, ctx) - theta_from_freq(idx, ctx), 2)`.
#' This equality is the implementation's strongest sanity check.
#' If it fails, `f` is centered, rescaled, or built on the wrong marker coding.
#' 
#' Three practical consequences:
#' 
#' 1. One fewer metric to justify to a technical committee.
#' 2. "Losing 5 % of diversity" acquires an exact meaning: 5 % of the set's expected
#'    heterozygosity.
#' 3. Two computation routes with the same answer and very different costs. The
#'    matrix route is $O(n^2)$; the frequency route is $O(nm)$. For $n = 200$ and
#'    $m = 25000$ that is forty thousand operations against five million.
#' 
## -----------------------------------------------------------------------------
# adaptive repetitions: a fixed count is quantised by the clock (cf. bench_us()
# in book/scripts/regenerate.R)
bench_us <- function(f, target = 0.4) {
  r <- 50L
  repeat {
    t <- system.time(for (i in seq_len(r)) f())[["elapsed"]]
    if (t > target || r > 2e6) return(1e6 * t / r)
    r <- r * 4L
  }
}
us_matrix    <- bench_us(function() theta_group(idx, ctx))
us_frequency <- bench_us(function() theta_from_freq(idx, ctx))
c(us_matrix = us_matrix, us_frequency = us_frequency,
  ratio = us_frequency / us_matrix)

#' 
#' The matrix route is the one that belongs in an optimiser's inner loop.
#' @sec-collapse makes it cheaper still.
#' 
#' ## Status number $N_s$ {#sec-ns}
#' 
#' @lindgren1997 express group coancestry on the scale of individual counts:
#' 
#' $$N_s = \frac{1}{2\theta_S}.$$ {#eq-catalogue-ns}
#' 
#' $N_s$ reads as a head count only on coancestry measured against a base
#' population, in which unrelated non-inbred individuals have coancestry 0 with each
#' other and $1/2$ with themselves: a set of $n$ of them has $\theta_S = 1/(2n)$ and
#' $N_s = n$. Molecular $\mathbf{f}$ has no base. By @eq-catalogue-gd-he,
#' $\theta_S = m^{-1}\sum_k(\bar p_k^2 + \bar q_k^2)$, and
#' $\bar p_k^2 + \bar q_k^2 \ge 1/2$ at every biallelic locus, so on $\mathbf{f}$
#' $\theta_S \in [1/2, 1]$ and $N_s \in [1/2, 1]$ for every set. Here $N_s$ is a
#' monotone decreasing rescaling of $\theta_S$, not a number of individuals. The
#' two edge cases are the two bounds:
#' 
## -----------------------------------------------------------------------------
fake <- ctx
fake$f <- matrix(0.5, 5, 5)      # every group frequency 0.5: theta at its lower bound
c(theta = theta_group(1:5, fake), Ns = status_number(1:5, fake))

fake$f <- matrix(1, 5, 5)        # all identical and homozygous: theta at its upper bound
c(theta = theta_group(1:5, fake), Ns = status_number(1:5, fake))

#' 
#' Five individuals give $N_s = 1$, not 5. The five selections of this chapter fall
#' between `r fmt(min(sapply(sels, status_number, ctx = ctx)), 3)` and
#' `r fmt(max(sapply(sels, status_number, ctx = ctx)), 3)`.
#' 
#' ::: {.callout-warning}
#' ## $N_s$ is a descriptor, not a drift projection
#' 
#' @toro2020 show that the **rate-based** effective size $N_e = 1/(2\Delta F)$
#' loses meaning under molecular diversity management: optimisation increases
#' diversity in early generations, producing a negative $\Delta F$ and therefore a
#' negative $N_e$, with no long-term asymptote.
#' 
#' This does not invalidate $N_s$. $N_s$ is a monotonic reparametrisation of
#' $\theta$ -- a *static descriptor of a set* -- while $N_e$ is a *rate between
#' generations*. Use $N_s$ to compare sets; do not extrapolate it to project future
#' drift. For the same reason, do not substitute the linkage-disequilibrium $N_e$
#' here: that estimates population history, not the composition of a selected
#' sample.
#' :::
#' 
#' And, from @sec-genomic-era: $\theta$ tracks homozygosity, not drift. $GD$ and
#' $N_s$ answer "how much heterozygosity does this selection preserve", which is
#' the right question for next season's hybrid vigour. They do not certify that
#' allele frequencies are moving as unmanaged drift would have moved them, which
#' matters more across multiple recurrent cycles than for a single round of hybrid
#' selection.
#' 
#' ## Effective number of parents
#' 
#' A metric independent of $\mathbf{f}$, computed purely from the pedigree. With
#' $p_i$ the frequency with which line $i$ appears as a parent among the selected
#' hybrids,
#' 
#' $$N_{e,\text{par}} = \frac{1}{\sum_i p_i^2},$$ {#eq-catalogue-ne-par}
#' 
#' the reciprocal of Simpson's concentration index $\sum_i p_i^2$ [@simpson1949];
#' in pedigree analysis the same form, over founder contributions, gives the founder
#' equivalents of @lacy1989. It captures precisely what coancestry blurs: a set of
#' 200 hybrids can have an acceptable $\theta$ while drawing on only 12 lines, if
#' those 12 happen to be genetically distant from each other.
#' @tbl-catalogue-ne-par gives it for the five selections. It is bounded above by
#' the number of lines, `r ctx$n_lines`, a bound reached only if every line is used
#' equally often.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-catalogue-ne-par
#| tbl-cap: "Effective number of parents $N_{e,\\text{par}}$ (@eq-catalogue-ne-par), from `ne_parents()`, over the usage of the 50 parent lines among the selected hybrids. Five selections of $n$ = 60 from the $N$ = 625 hybrids of the teaching scale (25 + 25 lines, 2000 markers, simulation seed 1): random, a random subset (seed 42); trunc_cap, truncation on the index with each line used at most 4 times; greedy_w, greedy on index and coancestry with index weight $\\omega$ = 0.001 (argument `w` of `sel_greedy()`); greedy_div, greedy on coancestry alone ($\\omega$ = 0); truncation, the top 60 on the index. Number of lines, two decimals."
fmt(data.frame(Ne_parents = sapply(sels, ne_parents, ctx = ctx)), 2)

#' 
#' In relative terms, truncation reduces $N_{e,\text{par}}$ by
#' `r fmt(100 * (1 - ne_parents(sels[["truncation"]], ctx) / ne_parents(sels[["random"]], ctx)), 1)` %
#' of the random set's value and raises $\theta$ by
#' `r fmt(100 * (theta_group(sels[["truncation"]], ctx) / theta_group(sels[["random"]], ctx) - 1), 2)` %.
#' On the z scale of @tbl-catalogue-z the order reverses, because $\theta$ varies
#' far less among random subsets than $N_{e,\text{par}}$ does. The cost of
#' $N_{e,\text{par}}$ is a `tabulate` call, which makes it a natural candidate to enter the objective
#' function alongside $\theta$ -- and in @sec-choosing it does.
#' 
#' ## Allelic richness {#sec-richness}
#' 
#' $\theta$ and $H_e$ are averages across markers and are dominated by
#' intermediate-frequency alleles. A lost rare allele barely moves them, yet the
#' loss is irreversible. So count markers that were polymorphic in the population
#' and became rare or fixed in the selection, with MAF the minor allele frequency
#' in the selection $(S)$ or in the whole population (pop):
#' 
#' $$A_{\text{lost}} = \#\{k : \text{MAF}^{(S)}_k < 0.05 \;\wedge\;
#'                             \text{MAF}^{(\text{pop})}_k \ge 0.05\}.$$ {#eq-catalogue-alleles-lost}
#' 
#' @tbl-catalogue-alleles-lost counts $A_{\text{lost}}$ for the five selections.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-catalogue-alleles-lost
#| tbl-cap: "Markers lost, $A_{\\text{lost}}$ (@eq-catalogue-alleles-lost), from `alleles_lost()` with MAF threshold 0.05, out of 2000 markers. Five selections of $n$ = 60 from the $N$ = 625 hybrids of the teaching scale (25 + 25 lines, 2000 markers, simulation seed 1): random, a random subset (seed 42); trunc_cap, truncation on the index with each line used at most 4 times; greedy_w, greedy on index and coancestry with index weight $\\omega$ = 0.001 (argument `w` of `sel_greedy()`); greedy_div, greedy on coancestry alone ($\\omega$ = 0); truncation, the top 60 on the index. Count of markers."
data.frame(alleles_lost = sapply(sels, alleles_lost, ctx = ctx))

#' 
#' Among the metrics of the redundancy analysis in @sec-choosing, it is the one
#' **genuinely non-redundant** with $\theta$ -- a claim that chapter tests rather
#' than asserts. That analysis does not include `F_drift` or `F_hom`, so it says
#' nothing about them; in @tbl-catalogue-z, `F_drift` separates
#' truncation from random subsets more strongly than any other metric.
#' 
#' @lopezcortegano2019 compared, in a subdivided simulated population, strategies
#' maximising *expected heterozygosity* ($H_T$, the same family as $GD$) against
#' strategies maximising *allelic diversity* ($A_T$). Maximising $A_T$ retained
#' more alleles **and** controlled molecular inbreeding better than maximising
#' $H_T$, except when all the weight of the optimisation is placed on the
#' within-subpopulation component, where maximising $H_T$ controlled molecular
#' inbreeding best while still retaining fewer alleles. The mechanism connects directly to @sec-genomic-era:
#' heterozygosity-maximising management pushes allele frequencies toward 0.5, which
#' favours rare alleles in the short run but does not stop them drifting to loss
#' once they are no longer the rarest; allele-count management defends every
#' segregating allele directly.
#' 
#' Their recommendation for structured conservation programmes was to make $A_T$,
#' not $H_T$, the primary target. In this pipeline's terms: `alleles_lost` deserves
#' a place next to $\theta$ as a *tracked outcome*, not only as a post-hoc sanity
#' check, whenever the selection feeds several future cycles rather than a single
#' hybrid release.
#' 
#' ## Distances: E-NE and A-NE
#' 
#' @odong2013 proposed, and Core Hunter 3 [@debeukelaer2018] implements, two
#' measures, entry-to-nearest-entry (E-NE) and accession-to-nearest-entry (A-NE)
#' distances, capturing opposite aspects that $\theta$ alone cannot separate. Core
#' Hunter 3 computes them on its own marker distances; this book uses
#' $\eta_{ij} = 1 - f_{ij}$:
#' 
#' $$\text{E-NE} = \frac{1}{n}\sum_{i \in S} \min_{j \in S,\, j \ne i} \eta_{ij},
#'   \qquad
#'   \text{A-NE} = \frac{1}{N}\sum_{i=1}^{N} \min_{j \in S} \eta_{ij},$$ {#eq-catalogue-ene-ane}
#' 
#' with $N$ the number of candidates in the population.
#' 
#' - **E-NE** measures **non-redundancy within the
#'   selection**. It distinguishes "200 individuals spread out" from "100
#'   near-identical pairs spread out" -- configurations that can share the same
#'   $\theta$.
#' - **A-NE** measures **representativeness of the
#'   population**. It detects a selection that optimises $\theta$ by concentrating
#'   in one region of genetic space and ignoring the rest.
#' 
#' @tbl-catalogue-ene-ane gives both for the five selections of this chapter.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-catalogue-ene-ane
#| tbl-cap: "E-NE and A-NE (@eq-catalogue-ene-ane) with $\\eta_{ij} = 1 - f_{ij}$, as computed by `ene()` and `ane()`. Five selections of $n$ = 60 from the $N$ = 625 hybrids of the teaching scale (25 + 25 lines, 2000 markers, simulation seed 1): random, a random subset (seed 42); trunc_cap, truncation on the index with each line used at most 4 times; greedy_w, greedy on index and coancestry with index weight $\\omega$ = 0.001 (argument `w` of `sel_greedy()`); greedy_div, greedy on coancestry alone ($\\omega$ = 0); truncation, the top 60 on the index. E-NE: higher means less redundancy within the selection; A-NE: lower means better representation of the 625 candidates. Distances are dimensionless, four decimals."
fmt(t(sapply(sels, function(s) c(ENE = ene(s, ctx), ANE = ane(s, ctx)))), 4)

# A-NE with the self-distance set to 0 (Odong et al. 2013), for comparison
ane_odong <- vapply(sels, function(s) {
  d <- 1 - ctx[["f"]][, s, drop = FALSE]
  d[cbind(s, seq_along(s))] <- 0
  mean(apply(d, 1, min))
}, numeric(1))
ane_pkg <- vapply(sels, ane, numeric(1), ctx = ctx)
ane_gap <- ane_pkg - ane_odong
stopifnot(all(ane_gap >= 0))

#' 
#' Note the direction: A-NE is a distance to the *nearest selected entry*, so
#' **lower is better** for representativeness.
#' 
#' `ane()` departs from @odong2013 in one term of @eq-catalogue-ene-ane. There an accession that is itself in
#' the selection is its own nearest entry at distance 0; here
#' $\eta_{ii} = 1 - f_{ii} > 0$ for every heterozygous hybrid, so each selected
#' individual contributes its own self-distance instead of 0. Over these five
#' selections the self-distance-zero version is lower by
#' `r fmt(min(ane_gap), 4)` to `r fmt(max(ane_gap), 4)`, and the ranking of the five selections is
#' `r if (identical(rank(ane_pkg), rank(ane_odong))) "unchanged" else "changed"`.
#' The package keeps its definition because the cached redundancy analysis of
#' @sec-choosing and the case-study z-scores were computed with it.
#' 
#' ## Effective dimensionality
#' 
#' Over the eigenvalues $\gamma_i$ of the double-centered submatrix,
#' 
#' $$D_{\text{eff}} = \frac{(\sum_i \gamma_i)^2}{\sum_i \gamma_i^2}$$ {#eq-catalogue-deff}
#' 
#' has the form of the participation ratio, a term introduced for the localisation
#' of vibrational modes [@belldean1970] and applied here to eigenvalues. It counts
#' how many independent directions of genetic variation remain: 1 if all
#' variation lies on a single axis, $n - 1$ if spread evenly over the $n - 1$
#' dimensions that double-centering leaves. @tbl-catalogue-deff gives it for the
#' five selections.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-catalogue-deff
#| tbl-cap: "Effective dimensionality $D_{\\text{eff}}$ (@eq-catalogue-deff), from `eff_dim()`, on the double-centered $60 \\times 60$ submatrix of $\\mathbf{f}$, so at most 59. Five selections of $n$ = 60 from the $N$ = 625 hybrids of the teaching scale (25 + 25 lines, 2000 markers, simulation seed 1): random, a random subset (seed 42); trunc_cap, truncation on the index with each line used at most 4 times; greedy_w, greedy on index and coancestry with index weight $\\omega$ = 0.001 (argument `w` of `sel_greedy()`); greedy_div, greedy on coancestry alone ($\\omega$ = 0); truncation, the top 60 on the index. The chunk also asserts the Rayleigh bound on the uncentered submatrix discussed below. Number of dimensions, two decimals."
fmt(data.frame(D_eff = sapply(sels, eff_dim, ctx = ctx)), 2)

# leading eigenvalue of the raw submatrix against n * theta (Rayleigh bound)
lead_ratio <- sapply(sels, function(s)
  eigen(ctx[["f"]][s, s], symmetric = TRUE, only.values = TRUE)$values[1] /
    (length(s) * theta_group(s, ctx)))
stopifnot(all(lead_ratio >= 1 - 1e-12))

#' 
#' The submatrix is **double-centered** before the eigendecomposition. On a raw
#' all-positive `f` the leading eigenvalue is at least $n\theta$, because the
#' Rayleigh quotient of $\mathbf{f}_S$ at $\mathbf{1}/\sqrt{n}$ is
#' $\mathbf{1}'\mathbf{f}_S\mathbf{1}/n = n\theta_S$, and for the five selections
#' here it exceeds $n\theta_S$ by at most
#' `r signif(100 * (max(lead_ratio) - 1), 2)` %. An uncentered
#' version of @eq-catalogue-deff would only re-measure $\theta$ under a more expensive name -- a mistake
#' worth naming because it is easy to make and produces a plausible-looking number.
#' 
#' ## Decomposition by heterotic group
#' 
#' In hybrid maize the diversity **between** pools is the engine of heterosis and
#' cannot be spent; the diversity **within** each pool is the fuel for future
#' progress. @sec-heterosis derives the first half of that sentence -- `GD_BS`
#' weighted by dominance deviations *is* the divergence half of expected heterosis --
#' and qualifies it: divergence is worth having where it lands on the dominance loci,
#' and worth nothing where it does not. @sec-cycles demonstrates the second half.
#' Following @caballero2002, compute molecular coancestry between lines
#' and weight it by each line's usage among the selected hybrids:
#' 
#' $$\theta_A = \mathbf{w}_A' \mathbf{f}^{L} \mathbf{w}_A, \qquad
#'   \theta_B = \mathbf{w}_B' \mathbf{f}^{L} \mathbf{w}_B, \qquad
#'   \theta_{AB} = \mathbf{w}_A' \mathbf{f}^{L} \mathbf{w}_B.$$ {#eq-catalogue-theta-pools}
#' 
#' @tbl-catalogue-theta-pools gives the three for the five selections.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-catalogue-theta-pools
#| tbl-cap: "Group coancestry within pool A ($\\theta_A$), within pool B ($\\theta_B$) and between the pools ($\\theta_{AB}$), @eq-catalogue-theta-pools, from `theta_pools()` on the line coancestry $\\mathbf{f}^L$ weighted by each line's usage among the selected hybrids. Five selections of $n$ = 60 from the $N$ = 625 hybrids of the teaching scale (25 + 25 lines, 2000 markers, simulation seed 1): random, a random subset (seed 42); trunc_cap, truncation on the index with each line used at most 4 times; greedy_w, greedy on index and coancestry with index weight $\\omega$ = 0.001 (argument `w` of `sel_greedy()`); greedy_div, greedy on coancestry alone ($\\omega$ = 0); truncation, the top 60 on the index. Dimensionless, four decimals."
fmt(t(sapply(sels, theta_pools, ctx = ctx)), 4)

#' 
#' Feeding those into the partition of @caballero2002 (@sec-subdivided) gives
#' @tbl-catalogue-gd-partition:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-catalogue-gd-partition
#| tbl-cap: "Partition of gene diversity over the two heterotic pools (@sec-subdivided), from `gd_partition()`, pools weighted by the line usage of each selection: $GD_T = GD_{WI} + GD_{BI} + GD_{BS}$, $F_{ST} = GD_{BS}/GD_T$; `GD_WI_hyb`, half the mean heterozygosity of the selected hybrids. Five selections of $n$ = 60 from the $N$ = 625 hybrids of the teaching scale (25 + 25 lines, 2000 markers, simulation seed 1): random, a random subset (seed 42); trunc_cap, truncation on the index with each line used at most 4 times; greedy_w, greedy on index and coancestry with index weight $\\omega$ = 0.001 (argument `w` of `sel_greedy()`); greedy_div, greedy on coancestry alone ($\\omega$ = 0); truncation, the top 60 on the index. The chunk asserts $|GD_{WI}| < 10^{-12}$. Dimensionless, four decimals."
gdp <- t(sapply(sels, gd_partition, ctx = ctx))
stopifnot(all(abs(gdp[, "GD_WI"]) < 1e-12))
fmt(gdp, 4)

#' 
#' Two things to read in @tbl-catalogue-gd-partition. `GD_WI` is zero to machine precision (largest absolute
#' value across the five selections
#' `r signif(max(abs(gdp[, "GD_WI"])), 2)`, asserted below $10^{-12}$):
#' the parent lines are
#' inbred, so there is no within-individual diversity at line level -- the algebra
#' of @sec-subdivided predicted this, and it is why `GD_WI_hyb`, the heterozygosity
#' actually carried inside the F1s, is reported separately. And `GD_BS` *rises*
#' under truncation, from
#' `r fmt(gd_partition(sels[["random"]], ctx)[["GD_BS"]], 4)` for the random set to
#' `r fmt(gd_partition(sels[["truncation"]], ctx)[["GD_BS"]], 4)`.
#' 
#' The rise is measured; its cause is not isolated here. The simulated index is
#' additive in the hybrid genotype, a linear combination of marker effects with no
#' dominance term (@sec-simulating-crosses), so no pair of lines is complementary
#' beyond the sum of its two parents' values, and complementarity between lines
#' cannot be the cause. The rise is consistent with concentration on few lines:
#' truncation's effective number of lines (`ne_lines_pool()`) is
#' `r fmt(ne_lines_pool(sels[["truncation"]], ctx)[["Ne_lines_A"]], 1)` in pool A and
#' `r fmt(ne_lines_pool(sels[["truncation"]], ctx)[["Ne_lines_B"]], 1)` in pool B,
#' against `r fmt(ne_lines_pool(sels[["random"]], ctx)[["Ne_lines_A"]], 1)` and
#' `r fmt(ne_lines_pool(sels[["random"]], ctx)[["Ne_lines_B"]], 1)` for the random
#' set, and usage-weighted pool frequencies built on fewer lines carry more
#' sampling variance, which enters $y_k^2$, the squared between-pool frequency
#' difference $p_{Ak} - p_{Bk}$ of @eq-het-split, and hence `GD_BS`. A plan with the same
#' line concentration but lines drawn at random, the comparison that would separate
#' this mechanism from selection on the index, is not evaluated in this chapter.
#' 
#' ::: {.callout-note}
#' ## Global $\theta$ does not say which pool was eroded
#' 
#' $\theta_S$ and $GD$ pool both heterotic groups into one number. Under truncation
#' the global loss is visible (the $z$ of `GD` in @tbl-catalogue-z), but only
#' the per-pool quantities show that it falls mostly on one pool. Whether a plan
#' exists that erodes one pool at an acceptable global $\alpha$ is not tested in
#' this chapter. `ne_lines_pool()` is the cheap version of the per-pool
#' diagnostic -- it needs no `fL`, only the pedigree. Its output for the five
#' selections is @tbl-catalogue-ne-lines.
#' :::
#' 
## -----------------------------------------------------------------------------
#| label: tbl-catalogue-ne-lines
#| tbl-cap: "Effective number of lines per pool, from `ne_lines_pool()`: $1/\\sum_i p_i^2$ as in @eq-catalogue-ne-par, with $p_i$ the frequency of line $i$ among the pool-A parents (Ne_lines_A) or the pool-B parents (Ne_lines_B) of the selected hybrids; at most 25 per pool. Five selections of $n$ = 60 from the $N$ = 625 hybrids of the teaching scale (25 + 25 lines, 2000 markers, simulation seed 1): random, a random subset (seed 42); trunc_cap, truncation on the index with each line used at most 4 times; greedy_w, greedy on index and coancestry with index weight $\\omega$ = 0.001 (argument `w` of `sel_greedy()`); greedy_div, greedy on coancestry alone ($\\omega$ = 0); truncation, the top 60 on the index. Number of lines, two decimals."
fmt(t(sapply(sels, ne_lines_pool, ctx = ctx)), 2)

#' 
#' ### Where this could go next
#' 
#' $\theta_A$, $\theta_B$ and $\theta_{AB}$ as computed here are **diagnostic**:
#' reported, not fed back into the objective. The subdivided-population literature
#' offers a ready-made way to promote them into a tunable target. Total gene
#' diversity partitions as $H_T = H_S + D_G$ [@nei1973], and
#' @caballerorodriguezramilo2010 give the allelic analogue $A_T = A_S + D_A$.
#' @lopezcortegano2019, managing a simulated population subdivided into five
#' subpopulations, maximise the weighted forms
#' 
#' $$H_\lambda = D_G + \lambda H_S, \qquad A_\lambda = D_A + \lambda A_S,$$ {#eq-catalogue-lambda}
#' 
#' where $H_S$ and $A_S$ are the within-subpopulation components, $D_G$ and $D_A$
#' the between-subpopulation components, and $\lambda \in [0, \infty)$ is a weight
#' chosen by the manager. The subscript $\lambda$ marks this as the **weighted
#' objective**, distinct from Nei's unweighted total $H_T = H_S + D_G$ stated
#' above: the two are equal only at $\lambda = 1$. Reading the two subpopulations
#' as the two heterotic pools is this book's analogy, not theirs. $\lambda = 0$ optimises only between-pool divergence -- protects
#' the divergence term of heterosis, ignores each pool's internal health. $\lambda \to \infty$ optimises
#' only within-pool diversity -- protects each pool's future options, ignores the
#' cross.
#' 
#' That maps directly onto the two constraints a maize breeder already has in mind
#' but applies only qualitatively: *don't blend the pools* versus *don't paint
#' either pool into a corner*. Turning $\lambda$ into a second explicit knob
#' alongside $\alpha_{\max}$ is the natural next step if pool erosion shows up in
#' practice. The current implementation reports the ingredients and leaves the
#' weighting to the analyst.
#' 
#' $\lambda$ need not stay a matter of taste when the objective is expected
#' heterosis. Take two pools with equal weight, which the A $\times$ B structure
#' imposes, and per locus $H_{S,k} = p_{Ak}q_{Ak} + p_{Bk}q_{Bk}$,
#' $H_{T,k} = 2\bar p_k(1 - \bar p_k)$ and $D_{G,k} = H_{T,k} - H_{S,k} = y_k^2/2$,
#' with $\bar p_k$ and $y_k$ as in @eq-het-split. The expected heterozygosity of the
#' A $\times$ B crosses at locus $k$ is then
#' 
#' $$p_{Ak} + p_{Bk} - 2p_{Ak}p_{Bk} \;=\; H_{T,k} + D_{G,k} \;=\; H_{S,k} + 2D_{G,k}.$$ {#eq-catalogue-het-hs-dg}
#' 
#' The shared term of @eq-het-split is $H_{T,k}$, not $H_{S,k}$: it already contains
#' one $D_{G,k}$. Summed over loci with $d_k \equiv 1$, expected heterosis is
#' $2(D_G + H_S/2)$, twice $H_\lambda$ of @eq-catalogue-lambda with $\lambda = 1/2$
#' fixed by the algebra. With dominance deviations $d_k$ (@sec-heterosis),
#' $\sum_k d_k(H_{S,k} + 2D_{G,k}) = 2\bar d_D\,(D_G + \lambda_d H_S)$, where
#' 
#' $$\lambda_d = \frac{\bar d_H}{2\,\bar d_D}, \qquad
#'   \bar d_H = \frac{\sum_k d_k H_{S,k}}{\sum_k H_{S,k}}, \qquad
#'   \bar d_D = \frac{\sum_k d_k D_{G,k}}{\sum_k D_{G,k}}$$ {#eq-catalogue-lambda-d}
#' 
#' are the $H_S$-weighted and $D_G$-weighted means of $d$. Reading $\lambda_d$ as a
#' maximisation weight, $\lambda_d \in [0, \infty)$, needs net directional dominance
#' on the two weighted loci, $\bar d_D > 0$ and $\bar d_H \ge 0$: if $\bar d_D \le 0$
#' the leading factor $2\bar d_D$ reverses the objective (maximising expected
#' heterosis would then minimise the bracket, or leave $\lambda_d$ undefined at
#' $\bar d_D = 0$), and $\bar d_H \ge 0$ is what keeps $\lambda_d$ non-negative.
#' $\lambda_d$ departs from $1/2$ only when dominance lines up differently with
#' within-pool heterozygosity than with between-pool divergence, and a
#' frequency-only partition cannot see that because $d$ does not appear in it. $\lambda_d$ is computed from a plan's own
#' frequencies, so it is a local weight rather than a constant of the population,
#' and it is the right weight only for expected heterosis as the objective:
#' @lopezcortegano2019 choose $\lambda$ for conservation, where no such derivation
#' applies. In the partition of @sec-subdivided, $H_T = GD_T$, $D_G = GD_{BS}$ and
#' $H_S = GD_T - GD_{BS}$; @eq-catalogue-het-hs-dg is then
#' $1 - \theta_{AB} = GD_T + GD_{BS}$, @eq-het-theta-ab, which the chunk asserts on
#' the five selections (@tbl-catalogue-het-identity):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-catalogue-het-identity
#| tbl-cap: "@eq-catalogue-het-hs-dg checked: hybrid_het, $1 - \\theta_{AB}$ from `theta_pools()`; HS_plus_2DG, $H_S + 2D_G = (GD_T - GD_{BS}) + 2\\,GD_{BS}$ from `gd_partition()`. Five selections of $n$ = 60 from the $N$ = 625 hybrids of the teaching scale (25 + 25 lines, 2000 markers, simulation seed 1): random, a random subset (seed 42); trunc_cap, truncation on the index with each line used at most 4 times; greedy_w, greedy on index and coancestry with index weight $\\omega$ = 0.001 (argument `w` of `sel_greedy()`); greedy_div, greedy on coancestry alone ($\\omega$ = 0); truncation, the top 60 on the index. The chunk asserts the two columns equal with `all.equal()`. Dimensionless, six decimals."

het_check <- t(sapply(sels, function(s) {
  tp <- theta_pools(s, ctx); gp <- gd_partition(s, ctx)
  c(hybrid_het = 1 - tp[["theta_AB"]],
    HS_plus_2DG = (gp[["GD_T"]] - gp[["GD_BS"]]) + 2 * gp[["GD_BS"]])
}))
stopifnot(isTRUE(all.equal(het_check[, "hybrid_het"], het_check[, "HS_plus_2DG"])))
fmt(het_check, 6)

#' 
#' ## The correct baseline {#sec-baseline}
#' 
#' ### Why not compare against the whole population
#' 
#' The natural comparison -- coancestry of the selected set against that of the
#' whole population -- is **biased by construction**. Applying @eq-catalogue-split
#' to both:
#' 
#' $$\mathbb{E}[\theta_S] - \theta_N
#'   = \left(\frac{1}{n} - \frac{1}{N}\right)\left(\bar f_d - \bar f_o\right) > 0,$$ {#eq-catalogue-bias}
#' 
#' where the expectation is over random subsets $S$ of size $n$ drawn without
#' replacement, and $\bar f_d$, $\bar f_o$ are the population's diagonal and
#' off-diagonal means; the inequality holds since $\bar f_d > \bar f_o$ whenever
#' individuals are not clones. For a given, non-random $S$ the means of @eq-catalogue-split are
#' the set's own and the difference can take either sign: the max-diversity greedy
#' of this chapter has $\theta_S =$
#' `r fmt(theta_group(sels[["greedy_div"]], ctx), 5)` against
#' $\theta_N =$ `r fmt(theta_group(seq_len(ctx$N), ctx), 5)`. A **random**
#' sample already looks less diverse than the population it came from, with no
#' selection whatsoever. The bias is pure sampling and grows as the sample shrinks.
#' 
## -----------------------------------------------------------------------------
fd <- mean(diag(ctx$f)); fo <- mean(ctx$f[upper.tri(ctx$f)])
predicted_bias <- (1 / n_sel - 1 / ctx$N) * (fd - fo)

set.seed(11)
th <- replicate(400, theta_group(sample.int(ctx$N, n_sel), ctx))
observed_bias <- mean(th) - theta_group(seq_len(ctx$N), ctx)
mc_se <- sd(th) / sqrt(length(th))
stopifnot(abs(observed_bias - predicted_bias) < 4 * mc_se)

c(predicted = predicted_bias, observed = observed_bias, mc_se = mc_se)

#' 
#' @eq-catalogue-bias is exact in expectation. The observed residual is
#' `r fmt((observed_bias - predicted_bias) / mc_se, 2)` Monte Carlo standard errors
#' of the mean over 400 subsets, and the chunk asserts that it stays within 4.
#' 
#' Note also that the **off-diagonal** mean of a random subset *is* an unbiased
#' estimator of the population's off-diagonal mean. So the metric many programmes
#' already use is free of this particular bias -- but it is not $\theta_S$. By
#' @eq-catalogue-split it omits the term $\bar f_d/n$, the part of the set's coancestry that
#' depends on $n$ and is real when the set is used as a crossing pool, so
#' $1/(2\bar f_o)$ is not the $N_s$ of the set and the gap between the two grows as
#' $n$ shrinks.
#' 
#' ### Operational definition of loss
#' 
#' The "0 % loss" reference is the **distribution of random subsets of the same
#' size**:
#' 
#' $$\alpha \;=\; \frac{GD_{\text{random}(n)} - GD_S}{GD_{\text{random}(n)}}.$$ {#eq-catalogue-alpha}
#' 
#' Here $GD_{\text{ref}}$ is the mean $GD$ of random subsets of size $n$; the
#' $GD_{\text{random}(n)}$ of the equation, the printed `GD_reference` of the chunk
#' below, and the code's `gd_ref` are the same quantity.
#' $\alpha = 0$ means "as diverse as a random sample of the same size";
#' $\alpha < 0$ means more diverse than chance. Resampling also delivers the
#' standard deviation, and hence a z-score for any strategy.
#' 
## -----------------------------------------------------------------------------
null <- null_distribution(ctx, n_sel, B = 400, B_full = 1000)
c(GD_population = gene_diversity(seq_len(ctx$N), ctx),
  GD_reference  = null$gd_ref,
  sd            = null$gd_sd,
  apparent_loss_if_wrong_baseline =
    (gene_diversity(seq_len(ctx$N), ctx) - null$gd_ref) /
     gene_diversity(seq_len(ctx$N), ctx))

#' 
#' That last number is what a programme would report as a diversity loss if it
#' compared against the full pool. It is entirely a sampling artefact.
#' @tbl-catalogue-alpha gives $\alpha$ for the five selections against the
#' correct reference.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-catalogue-alpha
#| tbl-cap: "Diversity loss $\\alpha$ (@eq-catalogue-alpha), from `alpha_loss()`, against $GD_{\\text{random}(n)}$ estimated by `null_distribution()` as the mean $GD$ of 400 random subsets of $n$ = 60 (seed 7). Five selections of $n$ = 60 from the $N$ = 625 hybrids of the teaching scale (25 + 25 lines, 2000 markers, simulation seed 1): random, a random subset (seed 42); trunc_cap, truncation on the index with each line used at most 4 times; greedy_w, greedy on index and coancestry with index weight $\\omega$ = 0.001 (argument `w` of `sel_greedy()`); greedy_div, greedy on coancestry alone ($\\omega$ = 0); truncation, the top 60 on the index. Negative values are more diverse than the random reference. Proportion, five decimals."
fmt(data.frame(alpha = sapply(sels, alpha_loss, ctx = ctx, gd_ref = null$gd_ref)), 5)

#' 
#' Negative values are selections *more* diverse than chance, which is exactly what
#' the max-diversity greedy is for.
#' 
#' ### How to set the $\alpha$ limit
#' 
#' The acceptable limit **should not be chosen a priori.** Pure truncation -- the
#' unconstrained optimum of the index -- gives the $\alpha$ (@eq-catalogue-alpha) at which the constraint
#' stops binding. This is not the largest $\alpha$ over all subsets, which a
#' minimum-diversity selection would reach; it is the largest $\alpha$ a
#' gain-maximising selection ever needs. If it is below your intended limit, the
#' constraint restricts nothing and you have bought a false sense of control.
#' 
## -----------------------------------------------------------------------------
attainable <- alpha_loss(sel_truncation(ctx, n_sel), ctx, null$gd_ref)
c(alpha_truncation     = attainable,
  intended_limit       = 0.05,
  constraint_is_active = attainable > 0.05)

#' 
#' At this book's teaching scale (25 + 25 lines, 2000 markers, $n =$ `r n_sel`)
#' truncation reaches $\alpha =$ `r fmt(100 * attainable, 2)` %, so a 5 % limit
#' would `r if (attainable < 0.05) "be inoperative" else "bind"`. The value at the
#' production scale of `sim_config` is not computed in this chapter, and this one
#' does not transfer to it. The correct procedure is to trace the $\alpha$-versus-gain
#' frontier and choose its knee, which is @sec-combinatorial.
#' 
#' ## Every metric against the null {#sec-catalogue-null}
#' 
#' A metric without a baseline says nothing. The z-score of each metric against the
#' random-subset null is how this book reports all of them (@tbl-catalogue-z).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-catalogue-z
#| tbl-cap: "z-score of each metric for each selection against the random-subset null of `null_distribution()`: (value $-$ mean over 1000 random subsets of the same size) / s.d. over those subsets (`B_full` = 1000, seed 7), from `discriminatory_power()`. Five selections of $n$ = 60 from the $N$ = 625 hybrids of the teaching scale (25 + 25 lines, 2000 markers, simulation seed 1): random, a random subset (seed 42); trunc_cap, truncation on the index with each line used at most 4 times; greedy_w, greedy on index and coancestry with index weight $\\omega$ = 0.001 (argument `w` of `sel_greedy()`); greedy_div, greedy on coancestry alone ($\\omega$ = 0); truncation, the top 60 on the index. GD: gene diversity (@eq-catalogue-gd-he); Ns: status number (@eq-catalogue-ns); Ne_parents: @eq-catalogue-ne-par; F_hom, F_drift: the homozygosity and drift lenses of @sec-genomic-era; alleles_lost: @eq-catalogue-alleles-lost; ENE, ANE: @eq-catalogue-ene-ane. One decimal; Monte Carlo error of the s.d. not shown."
tab <- evaluate(sels, ctx, null$gd_ref)
zt <- discriminatory_power(tab, null)
fmt(as.data.frame(zt[
  , c("GD", "Ns", "Ne_parents", "F_hom", "F_drift", "alleles_lost", "ENE", "ANE")]), 1)

#' 
#' Read the rows against each other. Truncation is at $z =$
#' `r fmt(zt["truncation", "F_drift"], 1)` on `F_drift` against
#' `r fmt(zt["truncation", "GD"], 1)` on `GD`: the lens the constraint does not pin
#' (@sec-genomic-era) separates it from random subsets more strongly than the lens
#' it does. The capped truncation shows the other pattern: $z =$
#' `r fmt(zt["trunc_cap", "GD"], 1)` on `GD`, close to the random subsets, while
#' `ANE` is at `r fmt(zt["trunc_cap", "ANE"], 1)` and `alleles_lost` at
#' `r fmt(zt["trunc_cap", "alleles_lost"], 1)`. A constraint on `GD` alone would not
#' flag it. Every $z$ in the table divides by a standard deviation estimated from
#' `r nrow(null[["full"]])` random subsets (`B_full`), so each carries a Monte Carlo
#' error that this chapter does not report. That observation is what @sec-choosing turns into a
#' recommendation.
