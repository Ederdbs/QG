#' # Diversity in a subdivided population {#sec-subdivided}
#' 
# 02-subdivided -- standalone script of the chapter 02-subdivided.qmd
# Book: https://ederdbs.github.io/QG/02-subdivided.html
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

#' 
#' A breeding programme is never one population. It is heterotic groups, or
#' accessions, or landraces, or cycles -- and the diversity of the whole is not the
#' average of the diversity of the parts. @caballero2002 give the partition that
#' makes this precise, and it is the analytical backbone of everything that
#' follows: the diversity-loss constraint $\alpha$ (@eq-catalogue-alpha, used in
#' @sec-ocs) bounds its total (@tbl-keystone), and the
#' within/between asymmetry that makes plant hybrid breeding different from animal
#' breeding is a statement about which term of it you are allowed to minimise
#' (the second of the three departures of @sec-hp-not-animal).
#' 
#' This chapter follows @sec-coancestry. There the molecular coancestry
#' $\mathbf{f}$ is defined between single individuals; here the same quantity is
#' averaged over the individuals of subpopulations, and the partition of
#' @caballero2002 is stated in those terms. @sec-hybrid-programme states the
#' partition for a set of hybrids (@eq-hp-gd); the step from subpopulations of
#' individuals to hybrids partitioned over their parent lines is made in
#' @sec-keystone below.
#' 
#' The paper's central claim is uncomfortable and worth stating first: **a method
#' that ranks accessions by distance alone can invert the correct conclusion.** In
#' the paper's own imaginary example, an accession can be the most distant while
#' having so high an internal coancestry that removing it *raises* the diversity of
#' the pool. @sec-ct-removal reproduces that result numerically.
#' 
#' ## Notation {#sec-ct-notation}
#' 
#' - A metapopulation of $n$ subpopulations; subpopulation $i$ has $N_i$
#'   individuals, $N_T = \sum_i N_i$. In this chapter $n$ and $N$ count
#'   subpopulations and individuals, not the selected and candidate hybrids of
#'   @sec-notation.
#' - A tilde, $\tilde{x}$, is a weighted mean **within** subpopulations:
#'   $\tilde{f} = \sum_i f_{ii} N_i / N_T$, $\tilde{F} = \sum_i F_i N_i / N_T$,
#'   $\tilde{s} = \sum_i s_i N_i / N_T$. On an allele frequency, $\tilde{p}_{k,i}$
#'   is the frequency of allele $k$ in subpopulation $i$ (the mean over its
#'   individuals).
#' - A bar, $\bar{x}$, is a mean over **all pairs** in the metapopulation,
#'   between-subpopulation pairs included:
#'   $\bar{f} = \sum_{i,j} f_{ij} N_i N_j / N_T^2$.
#' - Always $\bar{f} \le \tilde{f} \le \tilde{s}$. The differences between those
#'   three numbers *are* the partition of diversity. $\bar{D} = \sum_{i,j} D_{ij} N_i N_j / N_T^2$,
#'   the mean over all pairs of the Nei distance $D_{ij}$ of @eq-nei-distance
#'   [@caballero2002, Eq. 4], equals $\tilde f - \bar f$ and enters @eq-f-stats.
#' - Sums and means ($f_{ij}$, $s_i$, $\bar f$, $\tilde f$, $\tilde s$, the gene
#'   diversity ($GD$) terms) are computed per locus and then averaged over loci; never average
#'   frequencies first. The ratios ($\alpha_i$, $G_i$, $G$, $F_{IS}$, $F_{ST}$,
#'   $F_{IT}$) are formed **from those locus-averaged numerators and denominators**
#'   (a ratio of means), not averaged locus by locus; the identities of
#'   @eq-ratio-identities hold in that form and not for the mean of per-locus
#'   ratios.
#' - Quantities with the subscript $i$ or $ij$ ($f_{ii}$, $f_{ij}$, $s_i$, $F_i$)
#'   refer to **subpopulations**: $f_{ij}$ is the mean of the individual
#'   coancestry matrix of @sec-coancestry over the block of an individual of $i$
#'   with an individual of $j$, and $s_i$ the mean self-coancestry of the
#'   individuals of $i$. A single individual is the case $N_i = 1$, which is the
#'   meaning these symbols have in @sec-coancestry and @sec-hp-ibd. $\mathbf{f}$
#'   in bold is, in the worked example, the $n \times n$ matrix of subpopulations.
#' - $k$ indexes the alleles of one locus in the formulas below (they are written
#'   for a multiallelic locus; at a biallelic locus the sum has two terms). The
#'   first bullet of @sec-ct-oc uses $k$ for a biallelic locus instead,
#'   as @sec-coancestry does for a marker.
#' 
#' ::: {.callout-warning}
#' ## The subtle point, and the one most often got wrong
#' 
#' Every coancestry here includes the pairs of an individual with **itself** --
#' group coancestry in the sense of @cockerham1967. That is what makes $1 - f_{ii}$
#' exactly Nei's gene diversity $1 - \sum_k \tilde p_{k,i}^2$ [@nei1973] -- the
#' plug-in form, without the small-sample correction $2N_i/(2N_i - 1)$ (the factor
#' that removes the bias derived under @eq-alpha-g) -- and it is
#' what makes the algebra close. The identity $1 - f_{ii} = H_e$ for a set is
#' @eq-hp-gd, derived in @sec-identity.
#' Drop the diagonal and none of the identities of this chapter hold.
#' :::
#' 
#' ## The three coancestry blocks
#' 
#' ### $f_{ij}$, between subpopulations {#sec-ct-fij}
#' 
#' The probability that two alleles, one sampled at random in subpopulation $i$ and
#' one in $j$, are identical. From markers, $f_{ij} = \sum_k \tilde p_{k,i}
#' \tilde p_{k,j}$.
#' 
#' Read it as **redundancy** between two materials. If you cross plants of $i$ with
#' plants of $j$, the progeny has expected inbreeding $F = f_{ij}$. It answers:
#' what do I gain by recombining these two accessions?
#' 
#' On this molecular scale no fixed level of $f_{ij}$ marks two materials as
#' redundant. $f_{ij}$ is identity in state, and it equals the pedigree coancestry
#' only if the base population has all its alleles different [@caballero2002,
#' p. 292], which a biallelic panel cannot satisfy: for unrelated lines the
#' expected $f_{ij}$ is the base-population floor of the panel,
#' $m^{-1}\sum_k (p_{b,k}^2 + q_{b,k}^2) \ge 1/2$, and the observed level of a
#' set is the panel floor of its own frequencies, which moves with the markers
#' retained (@sec-f-molecular, @tbl-panel-floor). The book's simulated pools
#' (`book_cfg`, @sec-coancestry) show a level well above zero for lines of
#' different pools:
#' 
## -----------------------------------------------------------------------------
#| label: fl-ranges
ctx <- simulate_data(book_cfg)
fL  <- ctx[["fL"]]
inA <- ctx[["pool"]] == "A"
fAB <- fL[inA, !inA]
fWI <- c(fL[inA, inA][upper.tri(fL[inA, inA])],
         fL[!inA, !inA][upper.tri(fL[!inA, !inA])])
fl_rng <- c(between_min = min(fAB), between_max = max(fAB),
            between_mean = mean(fAB), within_min = min(fWI),
            within_max = max(fWI), within_mean = mean(fWI))

#' 
#' The coancestry between two inbred lines from *opposite* heterotic pools ranges
#' from `r fmt(fl_rng[["between_min"]], 3)` to `r fmt(fl_rng[["between_max"]], 3)`
#' (mean `r fmt(fl_rng[["between_mean"]], 3)`), and between two lines of the
#' *same* pool from `r fmt(fl_rng[["within_min"]], 3)` to
#' `r fmt(fl_rng[["within_max"]], 3)` (mean `r fmt(fl_rng[["within_mean"]], 3)`).
#' What separates complementary from redundant material is therefore the contrast
#' between the two distributions, measured on one panel, and not a threshold
#' carried over from another panel. The ranges above come from one simulated
#' draw at the teaching scale and are not a property of maize pools.
#' 
#' ### $f_{ii}$, within a subpopulation
#' 
#' The case $i = j$. From markers $f_{ii} = \sum_k \tilde p_{k,i}^2$, the expected
#' homozygosity, so
#' 
#' $$1 - f_{ii} \;=\; H_{e,i} \;=\; \text{Nei's gene diversity of accession } i.$$ {#eq-fii-he}
#' 
#' A landrace accession regenerated twenty times with forty ears per cycle
#' accumulates coancestry and watches $f_{ii}$ rise silently. It is the cheapest
#' alarm for genetic erosion *inside* a genebank -- and it is precisely what a
#' distance tree cannot see.
#' 
#' ### $s_i$ and $F_i$, self-coancestry and molecular inbreeding
#' 
#' $$s_i = \sum_k \sum_l \frac{p_{k,l,i}^2}{N_i}, \qquad
#'   F_i = 2 s_i - 1, \qquad 2(1 - s_i) = 1 - F_i = H_{o,i}$$ {#eq-self-coancestry}
#' 
#' with $p_{k,l,i}$ the frequency of allele $k$ *within* individual $l$ of
#' subpopulation $i$: 0, 0.5 or 1 for a diploid, that is, the 0/1/2 dosage divided
#' by 2 (`ct_partition()` does exactly this). For a biallelic marker and the
#' reference allele, $p_{k,l,i}$ is the within-individual frequency that
#' @sec-notation writes $x$; there $x_{ik}$ indexes an individual and a marker,
#' here $k$ indexes an allele. On the 0/1/2 scale itself $s_i$
#' would leave $[0.5, 1]$ and $F_i$ would leave $[0, 1]$. $H_{o,i}$ is the
#' observed heterozygosity, the mean over individuals of the fraction of loci at
#' which the individual is heterozygous. A heterozygote has self-coancestry 0.5 at
#' the locus, so $1 - s_i$ is *half* the observed heterozygosity, not all of it.
#' 
#' ::: {.callout-warning}
#' ## $F_i$ here is molecular, and is not $F_{IS}$
#' 
#' By @eq-self-coancestry $F_i = 1 - H_{o,i}$ is the observed fraction of
#' homozygous loci of the individuals of $i$, a function of their genotypes alone;
#' it is not measured against a base. It is therefore not an inbreeding coefficient
#' relative to a pedigree base, which would need the base to have all its alleles
#' different (@sec-ct-fij), and its level depends on the allele frequencies of the
#' marker panel (the $H_o$ of an outbred individual does), so it is **not**
#' comparable across studies using different marker panels. For the question "is
#' this population mating at random?", use $\alpha_i$ of @eq-alpha-g, read against
#' its baseline (@eq-alpha-baseline).
#' :::
#' 
#' In soybean, rice and wheat, pure lines have $s_i \to 1$, so $F_i \to 1$ and
#' $H_o \to 0$. That is expected, not a symptom. It changes only *where* the
#' diversity resides.
#' 
#' ## Two per-subpopulation metrics
#' 
#' $$\alpha_i = \frac{F_i - f_{ii}}{1 - f_{ii}}, \qquad
#'   G_i = \frac{s_i - f_{ii}}{1 - f_{ii}} = \frac{1 + \alpha_i}{2}$$ {#eq-alpha-g}
#' 
#' $\alpha_i$ is the subpopulation's analogue of $F_{IS}$, not the diversity-loss
#' constraint $\alpha$ of @sec-ocs, and $G_i$ is not a genomic relationship
#' matrix $\mathbf{G}$. A positive $\alpha_i$ means an excess
#' of homozygotes (selfing, mating among relatives, a Wahlund effect from internal
#' substructure, null alleles); negative means an excess of heterozygotes
#' (dioecy, self-incompatibility, selection, or a freshly formed F1 or synthetic) --
#' but both are read against the baseline of the plug-in form, which is not zero.
#' 
#' **The baseline under random mating.** Take $N_i$ diploid individuals whose
#' genotypes are drawn independently at Hardy-Weinberg proportions from a
#' population with allele frequencies $p_k$ at a locus, and let $\tilde p_k$ be the
#' sample frequency, over the $2N_i$ alleles. Then $\mathbb{E}[F_i] = \sum_k p_k^2$
#' (the Hardy-Weinberg homozygosity) and
#' $\mathbb{E}[f_{ii}] = \mathbb{E}\sum_k \tilde p_k^2 = \sum_k p_k^2 +
#' (1 - \sum_k p_k^2)/(2N_i)$, because $\mathrm{Var}(\tilde p_k) = p_k(1 - p_k)/(2N_i)$.
#' So $\mathbb{E}[F_i - f_{ii}] = -(1 - \sum_k p_k^2)/(2N_i)$,
#' $\mathbb{E}[1 - f_{ii}] = (1 - \sum_k p_k^2)(2N_i - 1)/(2N_i)$, and the ratio
#' of these locus-averaged expectations (the form in which the chapter computes
#' $\alpha_i$, @sec-ct-notation) is
#' $$\mathbb{E}[F_i - f_{ii}] \,/\, \mathbb{E}[1 - f_{ii}] \;=\; -\frac{1}{2N_i - 1},
#' \qquad\text{so}\quad G_i = \frac{1 + \alpha_i}{2} \;\to\; \frac{N_i - 1}{2N_i - 1} < \tfrac12 .$$ {#eq-alpha-baseline}
#' This is exact for the ratio of expectations and a first-order statement for
#' the expectation of the ratio. Under exact random mating a negative $\alpha_i$
#' and a $G_i$ below $1/2$ are therefore the null for a small accession, not
#' evidence of an excess of heterozygotes: $\alpha_i = -1/7$ for $N_i = 4$ plants
#' and $-1/23$ for $N_i = 12$, vanishing only as $N_i$ grows. The same $2N_i/(2N_i - 1)$
#' that multiplies $1 - f_{ii}$ in the unbiased gene diversity removes this bias.
#' Only the departure of $\alpha_i$ from $-1/(2N_i - 1)$ is read in the mating
#' column of @tbl-mating-meter. Two limits of the derivation: it assumes
#' independent sampling of individuals from a Hardy-Weinberg population (no
#' subdivision inside the sample, no linkage effect on the expectation). It is
#' algebra, so the chunk `alpha-baseline-check` checks it twice: by exact enumeration of the
#' Hardy-Weinberg samples, and by simulating random-mating samples and passing
#' them through `ct_partition()`.
#' 
## -----------------------------------------------------------------------------
#| label: alpha-baseline-check
# (1) Exact. One biallelic locus, N diploids at Hardy-Weinberg: enumerate every
#     genotype count (n0, n1, n2) with its multinomial probability. Per count,
#     F = homozygous fraction and f_ii = pt^2 + (1 - pt)^2, pt = (n1 + 2 n2)/(2N).
enum_alpha <- function(N, p) {
  n <- as.matrix(expand.grid(n0 = 0:N, n1 = 0:N))
  n <- cbind(n, n2 = N - rowSums(n))
  n <- n[n[, "n2"] >= 0, , drop = FALSE]
  pr <- exp(lfactorial(N) - rowSums(lfactorial(n)) +
            drop(n %*% log(c((1 - p)^2, 2 * p * (1 - p), p^2))))
  pt <- (n[, "n1"] + 2 * n[, "n2"]) / (2 * N)
  c(total = sum(pr), EF = sum(pr * (n[, "n0"] + n[, "n2"]) / N),
    Ef = sum(pr * (pt^2 + (1 - pt)^2)))
}
N_chk  <- c(4, 12, 50)
p_grid <- c(0.05, 0.2, 0.5, 0.7, 0.95)
enum_dev <- vapply(N_chk, function(N) {
  e <- vapply(p_grid, function(p) enum_alpha(N, p), numeric(3))
  stopifnot(all.equal(e["total", ], rep(1, length(p_grid)), tolerance = 1e-12))
  a_loc <- (e["EF", ] - e["Ef", ]) / (1 - e["Ef", ])         # every locus
  a_avg <- mean(e["EF", ] - e["Ef", ]) / mean(1 - e["Ef", ]) # ratio of locus means
  c(max(abs(a_loc + 1 / (2 * N - 1))), abs(a_avg + 1 / (2 * N - 1)),
    abs((1 + a_avg) / 2 - (N - 1) / (2 * N - 1)))
}, numeric(3))
stopifnot(all(enum_dev < 1e-12))

# (2) Simulation: 60 random-mating samples of N = 4, 12, 50 plants at 3000 loci
#     through ct_partition(); mean over samples against the baseline, with the
#     Monte Carlo s.e. (samples are independent). Tolerance: 4 s.e.
m_sim <- 3000; R_sim <- 60
pop_sim <- rep(sprintf("N%02d", N_chk), N_chk)
set.seed(5)
p_sim <- stats::runif(m_sim, 0.05, 0.95)
sim <- vapply(seq_len(R_sim), function(r) {
  g <- do.call(rbind, lapply(N_chk, function(N)
         matrix(stats::rbinom(N * m_sim, 2, rep(p_sim, each = N)), N)))
  bs <- ct_partition(g, pop_sim)[["by_subpop"]]
  c(bs[["alpha_i"]], bs[["G_i"]])
}, numeric(6))
sim_mean <- rowMeans(sim); sim_se <- apply(sim, 1, stats::sd) / sqrt(R_sim)
sim_th   <- c(-1 / (2 * N_chk - 1), (N_chk - 1) / (2 * N_chk - 1))
sim_z    <- (sim_mean - sim_th) / sim_se
stopifnot(all(abs(sim_z) < 4))

#' 
#' The enumeration reproduces $-1/(2N_i - 1)$ and $(N_i - 1)/(2N_i - 1)$ to
#' `r fmt_sci(max(enum_dev), 1)` (machine precision), at every locus and for the locus-averaged
#' ratio. The simulation gives a mean $\alpha_i$ of
#' `r fmt(sim_mean[1], 3)`, `r fmt(sim_mean[2], 3)` and `r fmt(sim_mean[3], 3)` for
#' $N_i = 4, 12, 50$ (baseline `r fmt(sim_th[1], 3)`, `r fmt(sim_th[2], 3)`,
#' `r fmt(sim_th[3], 3)`; largest deviation `r sprintf("%.1f", max(abs(sim_z)))` Monte Carlo
#' standard errors) and a mean $G_i$ of `r fmt(sim_mean[4], 3)`,
#' `r fmt(sim_mean[5], 3)`, `r fmt(sim_mean[6], 3)`, which is the baseline
#' $(N_i - 1)/(2N_i - 1)$ and not $0.5$.
#' 
#' $G_i$ is the proportion of the accession's diversity that sits **between**
#' individuals rather than inside them, and it is probably the most underused
#' quantity in the paper. It is a mating-system meter (@tbl-mating-meter):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-meter
#| tbl-cap: "$G_i$ (@eq-alpha-g), the share of an accession's gene diversity that lies between individuals rather than within them, read as a mating-system meter: its value under each mating situation and the material in which that situation is typical. $G_i$ tends to 0.5 under random mating only as $N_i$ grows (@eq-alpha-baseline); $N_i$ is the number of plants sampled."
#| echo: false
knitr::kable(data.frame(
  `G_i` = c("$\\approx (N_i - 1)/(2N_i - 1)$, below 0.5", "below that baseline", "$\\to 1$"),
  Situation = c("random mating (plug-in baseline)", "excess of heterozygotes", "all homozygous"),
  `Typical material` = c("maize, sunflower, open populations",
                         "F1 synthetics, heterozygous clones, self-incompatibles",
                         "inbred lines, doubled haploids, selfing species"),
  check.names = FALSE),
  col.names = c("$G_i$", "Situation", "Typical material"))

#' 
#' Operationally, $1 - G_i$ is the fraction of the diversity of the sample stored
#' *inside* each plant. This is a qualitative guide to the sampling design, not a
#' sample-size calculation (none is made here). With $G_i \to 1$ (selfers), the
#' diversity lies between plants, one plant carries almost none of it and many
#' plants per accession are needed. With $G_i$ near its random-mating baseline
#' (maize), about half of the sample's diversity lies inside each plant, so fewer
#' plants are needed.
#' 
#' ## Distances, and what they actually are
#' 
#' Nei's minimum distance between subpopulations [@toro2005, §3a] is
#' 
#' $$D_{ij} = \frac{f_{ii} + f_{jj}}{2} - f_{ij}
#'                   = \sum_k \tfrac{1}{2}(\tilde p_{k,i} - \tilde p_{k,j})^2 .$$ {#eq-nei-distance}
#' 
#' Note what that is: **half the sum of squared allele-frequency differences** -- a
#' variance component, not an evolutionary distance calibrated in time. It is the
#' piece that enters $F_{ST}$, and it is legitimate. The error in a
#' distance-only method is not using $D_{ij}$; it is using *only*
#' $D_{ij}$.
#' 
#' ::: {.callout-tip}
#' ## No double sum over individuals is needed
#' 
#' Between individuals $l$ and $l'$ the distance is
#' $d_{ll'} = (s_l + s_{l'})/2 - f_{ll'}$, with $s_l$ and $f_{ll'}$ the
#' self-coancestry and coancestry of single individuals (@eq-self-coancestry with
#' $N_i = 1$); at a biallelic locus it equals $(p_l - p_{l'})^2$, $p_l$ the
#' within-individual frequency, and over loci it is averaged. The mean of
#' $d_{ll'}$ over all pairs of an individual of $i$ and an individual of $j$,
#' $\bar d_{ij}$, computed literally as a double sum over all pairs of
#' individuals, costs $O(N_i N_j m)$. The identity
#' $\bar d_{ij} = (s_i + s_j)/2 - f_{ij}$ is exact and needs only the
#' subpopulation frequencies and self-coancestries, at cost $O(N_T m + n^2 m)$.
#' $\bar d_{ij}$ is not the $D_{ij}$ of @eq-nei-distance: its diagonal $\bar d_{ii} = s_i - f_{ii}$
#' is not zero, and Nei's distance is recovered as
#' $D_{ij} = \bar d_{ij} - (\bar d_{ii} + \bar d_{jj})/2$. Both
#' identities follow by substituting the definitions of $d_{ll'}$, $s_i$
#' (@eq-self-coancestry) and $f_{ij}$. No
#' timing at genebank scale was run for this chapter.
#' :::
#' 
#' ## The equation that matters most in practice
#' 
#' $$\bar{f} = \sum_{i} \frac{N_i}{N_T}
#'   \Big[\, \underbrace{f_{ii}}_{\text{internal coancestry}}
#'         - \underbrace{\textstyle\sum_j D_{ij} N_j / N_T}_{\text{mean distance to the others}} \Big]$$ {#eq-fbar-decomp}
#' 
#' In @eq-fbar-decomp, each accession's contribution to global coancestry -- that is, to the *loss* of
#' diversity in the pool -- has **two terms of opposite sign**:
#' 
#' - **Term 1 (+).** The more internally fixed an accession is, the more it
#'   *raises* global coancestry: it dilutes the pool with copies of the same
#'   allele.
#' - **Term 2 (−).** The more distant it is from the others, the more it *reduces*
#'   global coancestry.
#' 
#' A distance-only method sees term 2 alone. That is the whole mechanism of the
#' inverted conclusions.
#' 
#' ## F statistics and the partition
#' 
#' $$F_{IS} = \frac{\tilde F - \tilde f}{1 - \tilde f}, \qquad
#'   F_{ST} = \frac{\tilde f - \bar f}{1 - \bar f} = \frac{\bar D}{1 - \bar f}, \qquad
#'   F_{IT} = \frac{\tilde F - \bar f}{1 - \bar f}$$ {#eq-f-stats}
#' 
#' with $(1 - F_{IT}) = (1 - F_{IS})(1 - F_{ST})$. $\tilde F$ is the $N_i$-weighted
#' mean of the $F_i$ of @eq-self-coancestry; the subscripts follow the usual
#' reading, I for individual, S for subpopulation, T for the whole
#' metapopulation. Eq. 6 of @caballero2002 writes these formulas, which they call
#' Wright's [-@wright1969] F-statistics (*Evolution and the Genetics of
#' Populations*, vol. 2, as cited there); @toro2005 [§3a] credit the form
#' $F_{ST} = \bar D/(1 - \bar f)$ to @cockerham1969. Those are the attributions
#' this chapter reports; the original papers were not read for it.
#' 
#' **What this $F_{ST}$ is, in heterozygosity terms.** With the plug-in form of
#' @sec-ct-notation, $1 - \bar f = H_T$ ($= GD_T$, @eq-gd-partition below) is the gene diversity of the pooled sample's
#' frequencies $\bar p_k$, $1 - \tilde f = H_S$ ($= GD_{WS}$) is the $N_i$-weighted mean of the
#' $H_{e,i}$ of @eq-fii-he, and $\tilde F = 1 - H_o$ with $H_o$ the $N_i$-weighted
#' observed heterozygosity. Hence
#' $$F_{ST} = \frac{H_T - H_S}{H_T}, \qquad F_{IS} = 1 - \frac{H_o}{H_S},
#'   \qquad F_{IT} = 1 - \frac{H_o}{H_T},$$ {#eq-f-stats-het}
#' each $H$ averaged over loci first, so that $F_{ST}$ is a ratio of locus-averaged
#' numerator and denominator (@sec-ct-notation). It is also $GD_{BS}/GD_T$
#' (@eq-ratio-identities).
#' 
## -----------------------------------------------------------------------------
#| label: fst-two-forms
# The same 30 random hybrids as `tbl-keystone-check` (same seed, same draw).
set.seed(7)
idx_f <- sample(ctx[["N"]], 30)
tp    <- theta_pools(idx_f, ctx)
ft    <- (tp[["theta_A"]] + tp[["theta_B"]]) / 2                 # f-tilde
fb    <- (tp[["theta_A"]] + 2 * tp[["theta_AB"]] + tp[["theta_B"]]) / 4  # f-bar
fst_this    <- (ft - fb) / (1 - fb)                              # @eq-f-stats
fst_between <- (ft - tp[["theta_AB"]]) / (1 - tp[["theta_AB"]])  # between-referenced
stopifnot(all.equal(gd_partition(idx_f, ctx, tp)[["F_ST"]], fst_this, tolerance = 1e-12))
fst_cmp <- c(this = fst_this, between = fst_between, ratio = fst_between / fst_this)

# One biallelic locus, two populations of equal weight, from the coancestries:
# the closed forms of the prose, over 200 random (p_A, p_B), and the worked case.
one_locus <- function(pA, pB) {
  f1  <- function(p) p^2 + (1 - p)^2                    # f_ii at a biallelic locus
  fAB <- pA * pB + (1 - pA) * (1 - pB)
  tw  <- (f1(pA) + f1(pB)) / 2
  fb1 <- (f1(pA) + f1(pB) + 2 * fAB) / 4
  pb  <- (pA + pB) / 2; dp <- pA - pB
  this <- (tw - fb1) / (1 - fb1); btw <- (tw - fAB) / (1 - fAB)
  stopifnot(all.equal(this, dp^2 / (4 * pb * (1 - pb)), tolerance = 1e-12),
            all.equal(btw, dp^2 / (2 * pb * (1 - pb) + dp^2 / 2), tolerance = 1e-12),
            all.equal(btw / this, 4 * pb * (1 - pb) / (2 * pb * (1 - pb) + dp^2 / 2),
                      tolerance = 1e-12),
            all(btw / this >= 1 - 1e-12), all(btw / this <= 2))
  rbind(this = this, between = btw)
}
set.seed(11)
invisible(one_locus(stats::runif(200), stats::runif(200)))
stopifnot(all.equal(unname(one_locus(0.2, 0.6)[, 1]), c(1 / 6, 2 / 7), tolerance = 1e-12))

#' 
#' **It is not the only statistic written $F_{ST}$.** A statistic referenced to the
#' coancestry *between* populations, $(\theta_w - \theta_{AB})/(1 - \theta_{AB})$ with
#' $\theta_w$ the mean coancestry within populations and $\theta_{AB}$ between
#' populations, is also written $F_{ST}$; @sec-hp-inbreeding records that the book
#' computes both and that they differ. This chapter cites no external source for
#' that usage and does not use the statistic. The two take different values on the
#' same data. At one biallelic locus with allele frequency $p_A$ in one population and
#' $p_B$ in the other, equal weights, $\bar p = (p_A + p_B)/2$ and
#' $\Delta p = p_A - p_B$, the statistic of @eq-f-stats is
#' $\Delta p^2 / (4\bar p \bar q)$ and the between-referenced one is
#' $\Delta p^2 / (2\bar p \bar q + \Delta p^2/2)$; their ratio,
#' $4\bar p \bar q / (2\bar p \bar q + \Delta p^2/2)$, lies in $[1, 2]$ and tends to
#' 2 as $\Delta p \to 0$. For $p_A = 0.2$, $p_B = 0.6$ the two are $1/6$ and $2/7$.
#' On the 30 random hybrids of the book's simulated pools used in
#' @sec-keystone, the between-referenced statistic, computed from locus-averaged
#' coancestries, is
#' `r fmt(fst_cmp[["between"]], 3)` against `r fmt(fst_cmp[["this"]], 3)` for the
#' statistic of @eq-f-stats, a ratio of `r fmt(fst_cmp[["ratio"]], 2)` (one draw, seed 7). A value
#' of $F_{ST}$ must therefore be read with its reference stated; in this chapter it
#' is always @eq-f-stats.
#' 
#' The partition itself, of gene diversity ($GD$) into the terms named in
#' @tbl-gd-partition, is the heart of @caballero2002:
#' 
#' $$(1 - \bar f) = \underbrace{(1 - \tilde s)}_{GD_{WI}}
#'               + \underbrace{(\tilde s - \tilde f)}_{GD_{BI}}
#'               + \underbrace{(\tilde f - \bar f)}_{GD_{BS}}$$ {#eq-gd-partition}
#' 
## -----------------------------------------------------------------------------
#| label: tbl-gd-partition
#| tbl-cap: "The partition of gene diversity of @caballero2002 (@eq-gd-partition): each component, its definition in coancestries and its biological reading. $\\bar f$: mean coancestry over all pairs; $\\tilde f$, $\\tilde s$: within-subpopulation weighted means of coancestry and self-coancestry; $H_e$, $H_o$: expected and observed heterozygosity."
#| echo: false
knitr::kable(data.frame(
  Component = c("$GD_T = 1 - \\bar f$", "$GD_{WI} = 1 - \\tilde s$",
                "$GD_{BI} = \\tilde s - \\tilde f$", "$GD_{WS} = 1 - \\tilde f$",
                "$GD_{BS} = \\tilde f - \\bar f$"),
  Definition = c("total diversity", "within individuals",
                 "between individuals, within accession",
                 "within subpopulations", "between subpopulations"),
  Biologically = c("$H_e$ of the whole pool if everything were recombined",
                   "half the observed heterozygosity inside each plant, $H_o/2$",
                   "segregating variation available to within-population selection",
                   "$GD_{WI} + GD_{BI}$",
                   "divergence; the only component a distance method sees"),
  check.names = FALSE),
  col.names = c("Component, defined in coancestries", "Name", "Biological reading"))

#' 
#' The four components satisfy the identities
#' 
#' $$\frac{GD_{WI}}{GD_T} = (1-G)(1-F_{ST}), \quad
#'   \frac{GD_{BI}}{GD_T} = G(1-F_{ST}), \quad
#'   \frac{GD_{WS}}{GD_T} = 1-F_{ST}, \quad
#'   \frac{GD_{BS}}{GD_T} = F_{ST},$$ {#eq-ratio-identities}
#' 
#' where $G = (\tilde s - \tilde f)/(1 - \tilde f)$ is the metapopulation
#' analogue of $G_i$ (@eq-alpha-g). Since $s_i - f_{ii} = G_i (1 - f_{ii})$,
#' $G = \sum_i N_i (1 - f_{ii}) G_i / \sum_i N_i (1 - f_{ii})$: a mean of the
#' $G_i$ weighted by $N_i (1 - f_{ii})$, not the census mean
#' $\sum_i (N_i/N_T)\, G_i$. The two coincide when all $G_i$ are equal or all
#' $f_{ii}$ are equal, and the first two identities then hold with either; when
#' both the $G_i$ and the $f_{ii}$ differ the two means generally differ, and the
#' first two identities fail with the census mean (the chunk of @tbl-toy-partition exhibits one
#' such case). They follow from $1 - F_{ST} = (1 - \tilde f)/(1 - \bar f)$.
#' 
#' Every identity of this chapter so far needs individual genotypes, so the chunk
#' below draws a toy metapopulation -- two random-mating subpopulations and one of
#' inbred lines, 400 biallelic loci -- runs `ct_partition()` on it, and asserts
#' each identity, the distance identities against a literal double sum over pairs
#' of individuals; the resulting partition is printed in @tbl-toy-partition:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-toy-partition
#| tbl-cap: "Toy metapopulation of the chunk (two random-mating subpopulations of 10 and 6 plants and one of 8 inbred lines, 400 biallelic loci, one draw, seed 1): the metapopulation $G$ of @eq-ratio-identities, weighted by $N_i(1 - f_{ii})$, and the census mean $\\sum_i (N_i/N_T)\\,G_i$, which does not satisfy the identities; and the components of the gene-diversity partition (@eq-gd-partition, @tbl-gd-partition). Dimensionless."
tol   <- 1e-12                                        # exact identities: machine precision
m_toy <- 400
N_toy <- c(10, 6, 8)
pop   <- rep(c("a_out", "b_out", "c_inbred"), N_toy)
set.seed(1)
p_toy <- matrix(stats::runif(3 * m_toy), 3)          # subpopulation frequencies
geno  <- rbind(                                       # 0/1/2 dosage
  matrix(stats::rbinom(N_toy[1] * m_toy, 2, rep(p_toy[1, ], each = N_toy[1])), N_toy[1]),
  matrix(stats::rbinom(N_toy[2] * m_toy, 2, rep(p_toy[2, ], each = N_toy[2])), N_toy[2]),
  matrix(2 * stats::rbinom(N_toy[3] * m_toy, 1, rep(p_toy[3, ], each = N_toy[3])), N_toy[3]))

ct  <- ct_partition(geno, pop)
gl  <- ct[["global"]]; GD <- ct[["diversity"]]; bs <- ct[["by_subpop"]]
s_i <- bs[["s_i"]]; f_ct <- unname(ct[["f"]])

# 2(1 - s_i) = 1 - F_i = H_o, with H_o counted from the genotypes
H_o <- as.vector(tapply(rowMeans(geno == 1), factor(pop), mean))
stopifnot(all.equal(2 * (1 - s_i), H_o, tolerance = tol),
          all.equal(1 - bs[["F_i"]], H_o, tolerance = tol),
          identical(s_i[3], 1))                       # inbred lines: 1 - s_i = 0
stopifnot(mean(geno^2 + (1 - geno)^2) > 1)            # 0/1/2 used as p: s leaves [0.5, 1]
stopifnot(all.equal(bs[["G_i"]], (1 + bs[["alpha_i"]]) / 2, tolerance = tol))

# f_bar <= f_til <= s_til, and f_bar = sum_i w_i [f_ii - sum_j D_ij w_j]
stopifnot(gl[["f_bar"]] <= gl[["f_til"]], gl[["f_til"]] <= gl[["s_til"]],
          all.equal(sum(bs[["contrib_fbar"]]), gl[["f_bar"]], tolerance = tol))

# census weights: f_bar is the mean of the individual coancestry matrix over all
# pairs, diagonal included (the group coancestry of the whole set)
stopifnot(all.equal(mean(molecular_coancestry(geno / 2)), gl[["f_bar"]], tolerance = tol))

# F statistics
stopifnot(all.equal(gl[["F_ST"]], (gl[["f_til"]] - gl[["f_bar"]]) / (1 - gl[["f_bar"]]),
                    tolerance = tol),
          all.equal(1 - gl[["F_IT"]], (1 - gl[["F_IS"]]) * (1 - gl[["F_ST"]]), tolerance = tol))

# @eq-f-stats-het: the same statistics from heterozygosities. Pooled frequencies
# (census weights) give H_T; H_S is the N_i-weighted mean of 2 p_i q_i; H_o is
# counted from the genotypes. Everything averaged over loci first.
p_i   <- t(vapply(split(seq_len(nrow(geno)), factor(pop)),
                  function(ix) colMeans(geno[ix, , drop = FALSE]) / 2, numeric(m_toy)))
p_all <- colMeans(geno) / 2
H_T_l <- 2 * p_all * (1 - p_all)                      # per locus
H_S_l <- colSums(ct[["w"]] * 2 * p_i * (1 - p_i))
H_T   <- mean(H_T_l); H_S <- mean(H_S_l); H_o_all <- mean(rowMeans(geno == 1))
stopifnot(all.equal(1 - gl[["f_bar"]], H_T, tolerance = tol),
          all.equal(1 - gl[["f_til"]], H_S, tolerance = tol),
          all.equal(gl[["F_ST"]], (H_T - H_S) / H_T, tolerance = tol),
          all.equal(gl[["F_IS"]], 1 - H_o_all / H_S, tolerance = tol),
          all.equal(gl[["F_IT"]], 1 - H_o_all / H_T, tolerance = tol))

# ratio of locus means (the chapter's F_ST) against the mean of per-locus ratios
stopifnot(all(H_T_l > 0))
fst_means <- c(ratio_of_means = (H_T - H_S) / H_T,
               mean_of_ratios = mean((H_T_l - H_S_l) / H_T_l))
stopifnot(!isTRUE(all.equal(fst_means[["ratio_of_means"]], fst_means[["mean_of_ratios"]])))

# the partition and the ratio identities, with the metapopulation G
stopifnot(all.equal(GD[["GD_T"]], GD[["GD_WI"]] + GD[["GD_BI"]] + GD[["GD_BS"]], tolerance = tol),
          all.equal(GD[["GD_WS"]], GD[["GD_WI"]] + GD[["GD_BI"]], tolerance = tol))
G_meta  <- (gl[["s_til"]] - gl[["f_til"]]) / (1 - gl[["f_til"]])
G_wmean <- sum(ct[["w"]] * bs[["G_i"]])
w_he    <- ct[["w"]] * (1 - diag(f_ct))                # G is the (1 - f_ii)-weighted mean
stopifnot(all.equal(G_meta, sum(w_he * bs[["G_i"]]) / sum(w_he), tolerance = tol))
F_ST    <- gl[["F_ST"]]
stopifnot(all.equal(GD[["GD_WI"]] / GD[["GD_T"]], (1 - G_meta) * (1 - F_ST), tolerance = tol),
          all.equal(GD[["GD_BI"]] / GD[["GD_T"]], G_meta * (1 - F_ST), tolerance = tol),
          all.equal(GD[["GD_WS"]] / GD[["GD_T"]], 1 - F_ST, tolerance = tol),
          all.equal(GD[["GD_BS"]] / GD[["GD_T"]], F_ST, tolerance = tol),
          # negative control, at the default tolerance 1.5e-8: the census mean fails
          !isTRUE(all.equal(GD[["GD_WI"]] / GD[["GD_T"]], (1 - G_wmean) * (1 - F_ST))))

# d_bar_ij = (s_i + s_j)/2 - f_ij against the literal double sum; per locus the
# distance between individuals l, l' is (s_l + s_l')/2 - f_ll' = (p_l - p_l')^2
P     <- geno / 2
idv   <- split(seq_len(nrow(P)), factor(pop))
d_lit <- matrix(0, 3, 3)
for (i in seq_along(idv)) for (j in seq_along(idv)) {
  for (l in idv[[i]]) for (l2 in idv[[j]])
    d_lit[i, j] <- d_lit[i, j] + mean((P[l, ] - P[l2, ])^2)
  d_lit[i, j] <- d_lit[i, j] / (length(idv[[i]]) * length(idv[[j]]))
}
d_bar <- outer(s_i, s_i, "+") / 2 - f_ct
stopifnot(all.equal(d_lit, d_bar, tolerance = tol),
          all.equal(unname(ct[["D_nei"]]),
                    d_bar - outer(diag(d_bar), diag(d_bar), "+") / 2, tolerance = tol))

toy_tab <- fmt(c(G_meta = G_meta, G_wmean = G_wmean, GD))
toy_lab <- c(G_meta = "$G$, weighted by $N_i(1 - f_{ii})$", G_wmean = "$G$, census mean",
             GD_T = "$GD_T$", GD_WI = "$GD_{WI}$", GD_BI = "$GD_{BI}$",
             GD_WS = "$GD_{WS}$", GD_BS = "$GD_{BS}$")
knitr::kable(data.frame(Quantity = unname(toy_lab[names(toy_tab)]),
                        Value = unname(toy_tab)), row.names = FALSE, align = "lr")

#' 
#' The identities of @eq-f-stats-het and the mean of the individual coancestry matrix
#' hold to machine precision in the chunk. The ratio of locus means and the mean of
#' the per-locus ratios are not the same number: for $F_{ST}$ on this toy they are
#' `r fmt(fst_means[["ratio_of_means"]], 4)` and `r fmt(fst_means[["mean_of_ratios"]], 4)`,
#' and only the first obeys @eq-ratio-identities.
#' 
#' ### Why the partition changes the strategy by species {#sec-ct-species}
#' 
#' The three bullets below are this book's reading of what the partition implies
#' for different reproductive systems, not results of @caballero2002, whose
#' examples are livestock breeds and a diploid, randomly mating setting. The first
#' two follow from the definitions ($\tilde s = 1$ for inbred lines gives
#' $GD_{WI} = 0$, which the chunk of @tbl-toy-partition exhibits); the third and the regeneration
#' advice are judgement.
#' 
#' - **Outcrossers** (maize, sunflower, forages, forest trees): $GD_{WI}$ is large.
#'   The diversity is literally *inside* the plants. Conserving means maintaining
#'   heterozygosity -- regenerate with many individuals and balanced contributions.
#' - **Selfers** (soybean, wheat, rice, beans) **and doubled-haploid or line collections**:
#'   $GD_{WI} \approx 0$. All diversity is $GD_{BI} + GD_{BS}$. Conserving means
#'   maintaining the *number of distinct lines*; heterozygosity is not a target.
#'   Regenerating with few plants per line is acceptable; losing lines is not.
#' - **Clonal crops** (potato, sugarcane, fruit trees): $GD_{WI}$ is high and
#'   **frozen** -- it does not decay by drift while the clone exists. The $N_e$
#'   algebra does not apply without adaptation.
#' 
#' This is the reason a hybrid maize programme cannot manage diversity with a
#' single pool-wide number: it needs $GD_{WS}$ and $GD_{BS}$ reported separately.
#' Under drift alone in two closed pools of equal weight ($f_{AA}$, $f_{BB}$,
#' $f_{AB}$ in the notation of this chapter, $\theta_A$, $\theta_B$, $\theta_{AB}$
#' in the code (`theta_pools()`, chunk `fst-two-forms`) and in @sec-notation, equal
#' when the usage weights equal the census weights), $f_{AB}$ is unchanged
#' in expectation while $f_{AA}$ and $f_{BB}$ rise, so an expected rise $\Delta$
#' in $\tilde f$ raises $\bar f$ by $\Delta/2$: $GD_{WS}$ falls by $\Delta$,
#' $GD_{BS}$ rises by $\Delta/2$, and $GD_T$ falls by only $\Delta/2$. A single
#' total understates the within-pool loss; @sec-heterosis-flat shows what the
#' between-pool gain is worth. The argument is for neutral drift in closed
#' pools; selection is not covered by it, and the pools are closed, so it is not
#' the asymptotic regime of @eq-ne-meta.
#' 
#' ## The worked example, reproduced
#' 
#' The metapopulation of @caballero2002 [p. 292, Tables 1 and 2]: four
#' subpopulations of $N$ = 12, 4, 8, 6, three loci with 5, 3 and 3 alleles. The
#' authors describe it as "an imaginary example based on allele frequencies of
#' neutral genetic markers that could resemble allozyme data"; it is a teaching
#' matrix, not a measured population, and the multiallelic loci put it outside the
#' biallelic setting of the rest of the book. Its coancestry matrix, typed from
#' Table 2a of the paper (the ten distinct entries compared with the printed table;
#' the genotypes of its Table 1 are not reproduced here, so nothing below
#' recomputes $\mathbf{f}$ from genotypes):
#' 
## -----------------------------------------------------------------------------
#| label: ct-example-f
f <- matrix(c(0.3391, 0.3021, 0.2535, 0.3229,
              0.3021, 0.8750, 0.3073, 0.3889,
              0.2535, 0.3073, 0.4766, 0.2483,
              0.3229, 0.3889, 0.2483, 0.3704), 4, 4, byrow = TRUE,
            dimnames = list(paste0("Sub", 1:4), paste0("Sub", 1:4)))
N <- c(12, 4, 8, 6)
w <- N / sum(N)

#' 
#' Note subpopulation 2: $f_{22} = `r f[2, 2]`$, so $H_e = `r 1 - f[2, 2]`$. It is
#' nearly fixed internally. Now the global quantities, with the paper's published
#' values beside them (@tbl-ct-example-global):
#' 
## -----------------------------------------------------------------------------
#| label: ct-example-global
f_bar <- drop(w %*% f %*% w)
f_til <- sum(w * diag(f))
s_til <- 0.7056                       # published; needs individual genotypes

computed  <- c(f_bar = f_bar, f_til = f_til, GD_T = 1 - f_bar,
               GD_WI = 1 - s_til, GD_BI = s_til - f_til, GD_BS = f_til - f_bar,
               F_ST = (f_til - f_bar) / (1 - f_bar))
published <- c(f_bar = 0.3256, f_til = 0.4535, GD_T = 0.6744, GD_WI = 0.2944,
               GD_BI = 0.2521, GD_BS = 0.1279, F_ST = 0.1897)
# rows computed from f alone must match to half a unit of the 4th decimal
from_f <- c("f_bar", "f_til", "GD_T", "GD_BS", "F_ST")
stopifnot(max(abs(computed[from_f] - published[from_f])) < 5e-5)
# the published partition must close: three 4-dp roundings, at most 1.5e-4
stopifnot(abs(sum(published[c("GD_WI", "GD_BI", "GD_BS")]) -
              published[["GD_T"]]) < 1.5e-4)
# the prose: GD_BS is less than a fifth of the total (F_ST = GD_BS / GD_T)
stopifnot(computed[["F_ST"]] < 0.2)
ct_glob <- data.frame(quantity = names(computed),
                      computed = round(unname(computed), 4),
                      published = unname(published))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-ct-example-global
#| tbl-cap: "Global quantities of the worked example of @caballero2002 (four subpopulations, $N$ = 12, 4, 8, 6), computed from the published coancestry matrix $\\mathbf{f}$ and census weights $N_i/N_T$, beside the published values. $\\bar f$: mean coancestry over all pairs; $\\tilde f$: within-subpopulation weighted mean coancestry; $GD_T$, $GD_{WI}$, $GD_{BI}$, $GD_{BS}$: the components of @eq-gd-partition; $F_{ST}$: @eq-f-stats. Computed $GD_{WI}$ and $GD_{BI}$ use the published $\\tilde s$, which needs individual genotypes, and therefore agree with the published values by construction."
#| echo: false
knitr::kable(data.frame(
  Quantity = c("$\\bar f$", "$\\tilde f$", "$GD_T$", "$GD_{WI}$", "$GD_{BI}$",
               "$GD_{BS}$", "$F_{ST}$"),
  Computed = ct_glob[["computed"]], Published = ct_glob[["published"]]),
  digits = 4)

#' 
#' The five values computed from $\mathbf{f}$ alone ($\bar f$, $\tilde f$, $GD_T$,
#' $GD_{BS}$, $F_{ST}$) reproduce the published ones within half a unit of the
#' fourth decimal, and the chunk asserts it. The chunk also asserts that the
#' published $GD_{WI}$, $GD_{BI}$ and $GD_{BS}$ sum to the published $GD_T$, a
#' check of the paper's internal consistency. The computed $GD_{WI}$ and
#' $GD_{BI}$ are not a check: they are derived
#' from the published $\tilde s$, which needs individual genotypes this chapter
#' does not have, so they agree by construction. Note that $GD_{BS}$ is only
#' `r round(100 * computed[["F_ST"]])` % of the total:
#' the between-subpopulation divergence -- the only thing a distance method
#' measures -- accounts for less than a fifth of the diversity in this
#' metapopulation.
#' 
#' ### Removing an accession can *increase* diversity {#sec-ct-removal}
#' 
#' @tbl-ct-loss gives the effect on $GD_T$ of removing each subpopulation in turn.
#' 
## -----------------------------------------------------------------------------
#| label: ct-example-loss
res <- list(f = f, by_subpop = data.frame(N = N))
lg  <- cbind(ct_loss_gain(res),
             delta_pct_equal = ct_loss_gain(res, "equal")$delta_pct)
D_nei   <- outer(diag(f), diag(f), "+") / 2 - f
lg$dist <- drop(D_nei %*% w)               # mean distance to the pool
# the prose: f_22 is the largest diagonal entry, subpopulation 2 is the most
# distant, and removing it raises GD_T (census and equal weights) while removing
# any other lowers it
stopifnot(which.max(diag(f)) == 2, which.max(lg$dist) == 2,
          lg$delta_pct[2] > 0, all(lg$delta_pct[-2] < 0),
          lg$delta_pct_equal[2] > 0, all(lg$delta_pct_equal[-2] < 0))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-ct-loss
#| tbl-cap: "Effect of removing each subpopulation of the worked example of @caballero2002 on pool gene diversity $GD_T = 1 - \\bar f$, computed from the published $\\mathbf{f}$. The change is relative to $GD_T$ of all four subpopulations, with census weights $N_i/N_T$ or equal weights; a positive change means removal raises diversity. The last column is the mean Nei minimum distance to the pool, $\\sum_j D_{ij} N_j/N_T$ (@eq-nei-distance)."
#| echo: false
knitr::kable(data.frame(
  Subpopulation = lg[["pop"]], GD_without = lg[["GD_without"]],
  delta_pct = lg[["delta_pct"]], delta_pct_equal = lg[["delta_pct_equal"]],
  dist = lg[["dist"]]),
  digits = c(0, 4, 2, 2, 4),
  col.names = c("Subpopulation", "$GD_T$ without it (census)",
                "Change, census (%)", "Change, equal (%)",
                "Mean distance to the pool"))

#' 
#' The number to look at is subpopulation 2. Its mean distance to the pool,
#' $\sum_j D_{2j} N_j/N_T$ (last column of @tbl-ct-loss), is the largest of the four,
#' so a method that ranks accessions by distance alone would rank it first. The
#' Weitzman approach discussed by @toro2005 [§3d] is such a method; the paper's own
#' Weitzman analysis uses Reynolds' distance, not the Nei distance of this table,
#' and gives subpopulation 2 the largest loss ($-65.5$ %) with subpopulation 3
#' close behind ($-63.3$ %) [@caballero2002, Table 3, column 5]; the authors report
#' that Nei's minimum and standard distances gave very similar results, not shown.
#' The ranking by mean Nei distance in @tbl-ct-loss is the book's. The coancestry
#' analysis says removing it **raises** pool diversity by
#' `r fmt(lg$delta_pct[2], 1)` % (census weights) or
#' `r fmt(lg$delta_pct_equal[2], 1)` % (equal weights).
#' 
#' The arithmetic is in @eq-nei-distance: $D_{2j}$ contains $f_{22}/2$, and
#' $f_{22} = `r f[2, 2]`$ is far above the other diagonal entries, so the
#' subpopulation is distant from the others in part because it is internally
#' nearly fixed, and the same $f_{22}$ is what raises global coancestry in the
#' first term of @eq-fbar-decomp. What produced the near-fixation (a small sample
#' of $N_2 = 4$ plants, a founder effect, drift in the source population,
#' selection) cannot be inferred from a coancestry matrix, and the example is
#' imaginary; the chapter does not claim a cause. The same pattern is reported for
#' the reanalysis of eleven European pig breeds of @laval2000 in
#' @caballero2002 [Table 5, column 3]: FRBA (Basque, France; the breed codes are defined in the footnote to
#' Table 4 of @caballero2002), the breed with the largest Weitzman
#' loss (-15.2 %), shows +0.67 % when removed, the value also given in the
#' corrected form of @toro2005 [Table 4]. These values are quoted from the tables,
#' not recomputed. In that column the subpopulations are not weighted by their
#' effective sizes; in the column that is (column 6), FRBA is $-0.0$ %, and the
#' authors argue that weighting by size is desirable [@caballero2002, p. 295]. The
#' +0.67 % is therefore the result without effective-size weighting, and not the
#' only one the paper reports.
#' 
#' ::: {.callout-note}
#' ## What this does and does not license
#' 
#' For a genebank: a rare accession with few plants and high homozygosity -- the
#' archetypal "unique" accession on a distance tree -- may be contributing
#' *negatively* to the pool. That does **not** mean discard it. It means the
#' correct priority may be to **regenerate it at larger $N$**, not to replicate it
#' into a core collection. Storing seed is cheap; extinction is irreversible.
#' :::
#' 
#' ### Optimal contributions {#sec-ct-oc}
#' 
#' Maximising $GD_T = 1 - \sum_{i,j} f_{ij} c_i c_j$ subject to $c_i \ge 0$ and
#' $\sum_i c_i = 1$ is a quadratic programme:
#' 
## -----------------------------------------------------------------------------
#| label: ct-example-oc
oc <- optimal_contributions(f)
stopifnot(identical(unname(round(oc[["c_i"]], 3)), c(0.522, 0, 0.270, 0.208)),
          oc[["c_i"]][2] == 0)

#' 
#' Subpopulation 2 receives weight **zero** (computed
#' $\mathbf{c} = (`r paste(formatC(oc[["c_i"]], format = "f", digits = 3), collapse = ",\\, ")`)$), and total
#' diversity rises from `r fmt(1 - f_bar, 4)` to `r fmt(oc[["GD_max"]], 4)`, a gain of
#' `r fmt(100 * (oc[["GD_max"]] - (1 - f_bar)) / (1 - f_bar), 1)` %. Rounded to three decimals the
#' solution equals the published $\mathbf{c} = (0.522,\, 0,\, 0.270,\, 0.208)$
#' of @caballero2002; the chunk asserts it.
#' 
#' Three direct uses in plant breeding:
#' 
#' - **Base population for recurrent selection.** $c_i$ gives the seed proportion
#'   from each source that maximises the neutral-marker $GD_T$ of the base. (In
#'   this bullet $k$ indexes biallelic loci.) With
#'   $f_{ij}$ built from population frequencies as above, $GD_T = 1 - \sum_{i,j}
#'   f_{ij} c_i c_j$ is the mean over loci of $2\bar p_k \bar q_k$, where $\bar p_k
#'   = \sum_i c_i p_{ik}$ is the frequency of the mixture and $\bar q_k = 1 - \bar
#'   p_k$; it keeps the between-source term in full. If the mixture is intermated
#'   to Hardy-Weinberg proportions, the variance of the 0/0.5/1 genotype at locus
#'   $k$ is $\bar p_k \bar q_k / 2$, so the genic variance of the base
#'   (@eq-response-genic, additive action; the variance is that of the mean of two
#'   alleles, each Bernoulli($\bar p_k$)) is
#'   $\sum_k \beta_k^2 \bar p_k \bar q_k / 2$. With effects of equal size
#'   $\beta$ at every one of the $m$ loci and markers whose frequencies represent
#'   those of the quantitative trait loci, that is $m \beta^2 GD_T / 4$:
#'   maximising $GD_T$ maximises genic variance; with unequal effects the two
#'   differ by the squared-effect weighting. The case is different when the
#'   candidates are A $\times$ B hybrids of two pools that are never intermated:
#'   @sec-response, which derives the hybrid case and restates the case above as
#'   its limit with equal pool frequencies, shows that their genic variance
#'   contains only the within-pool part of gene diversity, not the between-pool
#'   term. In both cases
#'   neither $GD_T$ nor the genic variance, being functions of allele frequencies
#'   and not of haplotypes, sees linkage disequilibrium.
#' - **Core collection.** Instead of clustering heuristics plus proportional
#'   sampling, solve the quadratic programme directly with operational constraints
#'   ($c_i \le$ multiplication capacity, $c_i \ge$ a policy minimum for accessions
#'   of cultural importance).
#' - **Optimal contribution selection.** Here $\mathbf{c}$ and $\mathbf{f}$ change
#'   object: $\mathbf{c}$ is the vector of contributions of the $N$ *candidates*
#'   and $\mathbf{f}$ their $N \times N$ coancestry matrix, not the contributions
#'   and the $n \times n$ matrix of subpopulations above. @meuwissen1997 maximises
#'   $\mathbf{c}'\mathbf{u}$ subject to a bound on the group coancestry
#'   $\mathbf{c}'\mathbf{f}\mathbf{c}$, with $\mathbf{u}$ the vector of the
#'   candidates' selection-criterion values (estimated breeding values in
#'   @meuwissen1997, the multi-trait index $u_i$ in @sec-ocs); its Lagrangian form is
#'   $\max \mathbf{c}'\mathbf{u} - \lambda\,\mathbf{c}'\mathbf{f}\mathbf{c}$,
#'   $\lambda \ge 0$. This chapter is
#'   the case $\lambda \to \infty$, pure diversity. A breeder operates in the middle
#'   of the curve -- which is @sec-ocs.
#' 
#' ## Equal contributions and effective size
#' 
#' Minimising $\bar f$ maximises the status number $N_s = 1/(2\bar f)$
#' [@lindgren1997] by definition. With census weights $N_i/N_T$, $\bar f$ is the
#' mean of the individual coancestry matrix over all pairs, diagonal included,
#' which is the group coancestry $\theta_S$ of the whole set $S$ (@sec-coancestry)
#' whatever the subdivision; this $N_s$ is then the $1/(2\theta_S)$ of that
#' chapter, and @tbl-keystone writes $GD_T = 1 - \bar f$ as $1 - \theta_S$
#' (asserted in `tbl-keystone-check`). That chapter's range $N_s \in [1/2, 1]$ is a
#' property of biallelic markers ($\theta_S \ge 1/2$); the multiallelic worked
#' example of this chapter is not on it: $N_s = 1/(2\bar f) =
#' `r fmt(1 / (2 * f_bar), 2)`$ for its 30 individuals, and in neither case is $N_s$ a
#' head count.
#' $N_s$ is a static function of the current
#' coancestry; the effective size $N_e$ is defined from the *rate* at which
#' inbreeding or coancestry rises across generations, so the two are not the same
#' quantity, and lowering $\bar f$ today does not by itself fix $N_e$.
#' 
#' What links contributions to $N_e$ is the asymptotic metapopulation effective
#' size of @caballero2002 [Eq. 14], in the form restated by @toro2005 [§5a]:
#' 
#' $$N_e \approx \frac{2Nn}{(V_W + V_B + 1)(1 - F_{ST})},$$ {#eq-ne-meta}
#' 
#' with $n$ subpopulations of equal size $N$, and $V_W$ and $V_B$ the variances of
#' the long-term contributions of individuals within and between subpopulations.
#' Eq. 14 of @caballero2002 has $(1 - F_{IT})$ in place of $(1 - F_{ST})$, and
#' $(1 - F_{IT}) = (1 - F_{IS})(1 - F_{ST})$: @eq-ne-meta is the case
#' $F_{IS} = 0$, random mating within subpopulations, which is its stated
#' assumption. The model is a metapopulation of $n$ subpopulations of constant size
#' $N$ with "any constant degree of migration" among them, discrete generations,
#' and the formula holds only after enough generations for $N_e$ and $F_{ST}$ to
#' reach their asymptotes. Two consequences. First, $F_{ST}$ here is the
#' asymptotic value of that metapopulation; it depends itself on the contribution
#' variances and on migration, and for closed pools (the drift paragraph of @sec-ct-species)
#' it tends to 1 and @eq-ne-meta has no meaning. Second, the statement below holds
#' the same $F_{ST}$ on both sides. It does not apply as written to pools of inbred
#' or doubled-haploid lines, where $F_{IS} \ne 0$ and where the sampling unit is
#' one allele copy per line rather than two per plant (@sec-hp-popgen). With random
#' (Poisson) contributions within
#' subpopulations and equal contributions of the subpopulations ($V_W = 1$,
#' $V_B = 0$) @eq-ne-meta gives $Nn/(1 - F_{ST})$; equalising contributions within
#' subpopulations ($V_W = 0$, $V_B = 0$) gives $2Nn/(1 - F_{ST})$, **double** at
#' the same $F_{ST}$.
#' 
## -----------------------------------------------------------------------------
#| label: ne-equal-seed
ne_fm  <- function(N, Vk) 4 * N / (2 + Vk)           # Falconer & Mackay, ch. 4
ne_ct  <- function(N, VW) 2 * N / (VW + 1)            # @eq-ne-meta, n = 1, F_ST = 0
N0     <- 100
V_k    <- c(random = 2, mother_once = 1, both_once = 0)  # variance of gametes per plant
ne_th  <- ne_ct(N0, V_k / 2)
# the two forms agree: algebra with V_W = V_k / 2, not evidence about N_e
stopifnot(all.equal(ne_fm(N0, V_k), ne_th, tolerance = 1e-12))
ne_gain <- c(seed_only = ne_th[["mother_once"]] / ne_th[["random"]],
             both      = ne_th[["both_once"]]   / ne_th[["random"]])
stopifnot(all.equal(ne_gain[["seed_only"]], 4 / 3, tolerance = 1e-12),
          all.equal(ne_gain[["both"]], 2, tolerance = 1e-12))

#' 
#' The chunk `ne-equal-seed` is the formula. The chunk `ne-gene-dropping` is the oracle: literal gene
#' dropping in $N = 100$ monoecious diploids with $L = 500$ unlinked biallelic loci
#' starting at $p = 1/2$, and $T = 25$ generations. In each generation every
#' offspring takes one gamete (a random one of the two alleles at each locus,
#' independently across loci) from its mother and one from its father; the schemes
#' differ only in how mothers and fathers are chosen (selfing is possible in all
#' three): independently at random ($V_k = 2$), every plant mother of exactly one offspring and the father
#' at random ($V_k = 1$), every plant mother of exactly one offspring and father
#' of exactly one ($V_k = 0$). The gene diversity $H_t$ (the mean of $2pq$ over loci)
#' decays as $(1 - 1/(2N_e))^t$, so $N_e$ is read from the slope of $\log H_t$,
#' one slope per independent pedigree ($R = 30$ per scheme), inverted exactly:
#' $N_e = 1/(2(1 - e^{\text{slope}}))$. The comparison is made on the slope, against its
#' Monte Carlo standard error over the 30 pedigrees, with tolerance 3 standard errors.
#' 
## -----------------------------------------------------------------------------
#| label: ne-gene-dropping
drop_genes <- function(N, L, T, scheme) {
  Z <- apply(matrix(rep(0:1, each = N), 2 * N, L), 2, sample)   # p = 1/2 at every locus
  A <- Z[seq_len(N), , drop = FALSE]; B <- Z[N + seq_len(N), , drop = FALSE]
  het    <- function() { p <- (colSums(A) + colSums(B)) / (2 * N); mean(2 * p * (1 - p)) }
  gamete <- function(par) {
    u <- matrix(stats::runif(N * L) < 0.5, N, L)
    ifelse(u, A[par, , drop = FALSE], B[par, , drop = FALSE])
  }
  H <- numeric(T + 1); H[1] <- het()
  for (t in seq_len(T)) {
    mo <- if (scheme == "random") sample.int(N, N, replace = TRUE) else sample.int(N)
    fa <- if (scheme == "both_once") sample.int(N) else sample.int(N, N, replace = TRUE)
    nA <- gamete(mo); nB <- gamete(fa); A <- nA; B <- nB
    H[t + 1] <- het()
  }
  H
}
R_ne <- 30; T_ne <- 25; L_ne <- 500
ne_of_slope <- function(s) 1 / (2 * (1 - exp(s)))
ne_obs <- vapply(names(V_k), function(sc) {
  set.seed(100 + match(sc, names(V_k)))                   # one seed per scheme
  slope <- vapply(seq_len(R_ne), function(r)
    stats::cov(0:T_ne, log(drop_genes(N0, L_ne, T_ne, sc))) / stats::var(0:T_ne), 0)
  s_hat <- mean(slope); s_se <- stats::sd(slope) / sqrt(R_ne)
  s_th  <- log(1 - 1 / (2 * ne_th[[sc]]))                 # slope implied by the formula
  c(Ne = ne_of_slope(s_hat),
    se = abs(ne_of_slope(s_hat - s_se) - ne_of_slope(s_hat + s_se)) / 2,
    z  = (s_hat - s_th) / s_se)
}, numeric(3))
stopifnot(all(abs(ne_obs["z", ]) < 3))

#' 
#' The measured $N_e$ is `r sprintf("%.1f", ne_obs["Ne", "random"])`
#' ($\pm$ `r sprintf("%.1f", ne_obs["se", "random"])`) for random contributions,
#' `r sprintf("%.1f", ne_obs["Ne", "mother_once"])` ($\pm$ `r sprintf("%.1f", ne_obs["se", "mother_once"])`)
#' when each plant is mother once and `r sprintf("%.1f", ne_obs["Ne", "both_once"])`
#' ($\pm$ `r sprintf("%.1f", ne_obs["se", "both_once"])`) when it is mother once and father once,
#' against `r sprintf("%.1f", ne_th[["random"]])`, `r sprintf("%.1f", ne_th[["mother_once"]])` and
#' `r sprintf("%.1f", ne_th[["both_once"]])` from the formula; the largest deviation of the
#' slope is `r sprintf("%.1f", max(abs(ne_obs["z", ])))` standard errors. That is the
#' single-population case ($n = 1$, $F_{IS} = 0$) of @eq-ne-meta, and nothing more.
#' 
#' The doubling assumes that each individual's contribution is equalised as
#' both female and male parent, which needs controlled pollination. In the
#' single-population case @eq-ne-meta reduces to $2N/(V_W + 1)$, which is
#' $N_e = 4N/(2 + V_k)$ [@falconer1996] with $V_W = V_k/2$, $V_k$ the
#' variance of the number of gametes an individual contributes. Harvesting the
#' same number of seeds from every plant of an open-pollinated population
#' equalises only the maternal contribution; with a maternal variance of 0 and a
#' Poisson paternal variance of 1, $V_k = 1$ and $N_e = 4N/3$, a gain of
#' `r fmt(ne_gain[["seed_only"]], 3)` over Poisson contributions, not
#' `r fmt(ne_gain[["both"]], 0)`.
#' 
#' ::: {.callout-tip}
#' ## Equal contributions of both parents double $N_e$
#' 
#' Under controlled pollination, equal numbers of seeds from every plant as
#' female and as male parent, and the same number of plants from every family,
#' double the effective size ($V_W = 0$ against $V_W = 1$). Equal seed numbers
#' from open-pollinated plants alone give a factor of 4/3. Neither needs
#' genotyping.
#' :::
#' 
#' It is an intervention in germplasm
#' management. The opposite -- bulk harvest from a plot, which in practice samples
#' the most productive plants disproportionately -- inflates $V_W$ and collapses
#' $N_e$.
#' 
#' ## The honest caveats
#' 
#' A breeder should take these seriously.
#' 
#' Criteria based on within-population variation **favour the largest
#' populations**, which are often the commercial and least endangered ones
#' [@toro2005, §3e]. A $\bar f$ criterion can push a genebank toward abundant elite
#' material -- the opposite of the conservation objective. Beyond that:
#' 
#' - Neutral markers do not measure adaptive value, disease resistance, stress
#'   adaptation or cultural value. A fixed accession may carry the only resistance
#'   allele to an emerging rust.
#' - **Allelic richness** (which @caballero2002 [p. 297] call allelic diversity) is,
#'   they write, more sensitive to bottlenecks than average heterozygosity, and is
#'   often the more relevant criterion for pre-breeding. The argument that
#'   minimising $\bar f$ maximises allelic richness in the long run (via the
#'   effective number of alleles being, by definition, the inverse of mean
#'   coancestry; [@toro2005, §2]) is valid
#'   asymptotically but does **not** protect rare alleles in the short term. This
#'   is why allelic richness is carried into the recommendation of @sec-choosing as
#'   a validation metric: in the cached redundancy analysis it keeps more than half of
#'   its rank variation at fixed group coancestry, as do E-NE, A-NE and
#'   between-pool coancestry, so it is one axis independent of $\theta$ and not the
#'   only one.
#' - Weighting between-group variation more heavily is arbitrary. A more defensible
#'   fix is to optimise $\mathbf{c}$ with per-accession minimum constraints, as
#'   @toro2005 [§3e, Table 5] do for five Iberian pig strains.
#' 
#' **Rule of thumb:** use $\bar f$ to decide *proportions and regeneration effort*;
#' never use $\bar f$ alone to decide *discard*.
#' 
#' ## A correction published by the authors
#' 
#' @toro2005 [Table 4, footnote a] republish the pig-breed reanalysis of
#' @caballero2002 and mark one entry (breed DESH, Schwäbisch-Hällisches, Germany) as correcting a mistake in the
#' 2002 paper. Any value from that reanalysis should be read from the 2005 table;
#' the 0.67 % of FRBA quoted in @sec-ct-removal is the same in the 2002 paper
#' (Table 5, column 3) and in the 2005 table. The same review restates the
#' effective-size result of @eq-ne-meta: equalising contributions within
#' subpopulations doubles $N_e$ [@toro2005, §5a; @caballero2002, Eq. 14].
#' 
#' What was compared with what, for this chapter. The full text of
#' @caballero2002 was read: the matrix of Table 2a, $\tilde s$, $\tilde f$, $\bar f$,
#' $\bar D$, the $F$ statistics and the $GD$ components of Table 2b, the removal
#' analysis and the contributions of Table 3, Eq. 6, 7, 8 and 14, and the pig-breed
#' Table 5 were checked against the chapter, and the typed values agree. One
#' difference is open: the chapter's equal-weights column of @tbl-ct-loss gives
#' $-6.92$ and $-6.94$ % for subpopulations 1 and 3 where the paper's unweighted
#' column (Table 3, column 4) prints $-6.8$ and $-7.0$ %; the other two entries
#' agree to the printed digit, the cause of the difference was not established, and
#' the chapter does not rest on it. The 2005 review was consulted in excerpts (its
#' section headings, Table 4 and the passages cited), not in full. Not read for this
#' chapter, and therefore reported only as the secondary sources above attribute
#' them: @wright1969, @cockerham1969, @cockerham1967, @nei1973 beyond its
#' abstract, @lindgren1997, @falconer1996, and @meuwissen1997 beyond its abstract.
#' 
#' ## What manages this quantity, and where {#sec-keystone}
#' 
#' This chapter is the book's keystone, and it is easy to read it as a
#' self-contained treatment of @caballero2002. The partition it derives
#' (@eq-gd-partition) is not
#' background: it is the object every later chapter operates on. Stated once, so
#' the rest of the book can refer back rather than re-introduce it
#' (@tbl-keystone):
#' 
#' | Term | What it is | Where it is managed |
#' |------|----------------|------------------------------------|
#' | $GD_{WI}$ | diversity within individuals, $1 - \tilde s = \tilde H_o/2$ | exactly zero with inbred parents (@sec-catalogue); the hybrid-level $GD_{WI\text{-}hyb}$, half the mean heterozygosity of the selected hybrids, is what carries signal |
#' | $GD_{BI}$ | between individuals, within pool | eroded by drift (@sec-ct-species); within-pool diversity also falls in the simulated cycles of @sec-cycles, where drift and selection act together and are not separated; with inbred parents $\alpha$ (@sec-ocs) budgets $GD_T = 1 - \theta_S = GD_{BI} + GD_{BS}$, not $GD_{BI}$ alone |
#' | $GD_{BS}$ | between pools | with flat dominance ($d_k \equiv 1$), inbred parents and the complete A $\times$ B factorial, expected F1 heterozygosity per locus is exactly $GD_T + GD_{BS}$ (@eq-het-split, @tbl-het-partition-identity): there $GD_{BS}$ is the divergence term of heterosis, to be **preserved** not minimised; outside those conditions it is not an identity |
#' 
#' : The three terms of the gene-diversity partition (@eq-gd-partition), what each measures, and the chapter of this book in which each is managed. $\tilde s$, $\tilde H_o$: within-pool means of self-coancestry and observed heterozygosity; $\theta_S$: mean coancestry of the selected hybrids (the set $S$); $\alpha$: the diversity-loss constraint. {#tbl-keystone}
#' 
#' For a set of hybrids the partition is taken over their parent lines. The
#' "individuals" of @eq-gd-partition are then the parent-line slots of the hybrids
#' (one line of pool A and one of pool B per hybrid), the two pools are the
#' subpopulations, and the weights are the usage weights of the lines, equal across
#' the two pools by construction (@eq-hp-gd and the identity $F_{(ab)} = f^L_{ab}$
#' of @sec-hp-inbreeding; `gd_partition()` implements it). Within a pool the
#' weights are the usage of each line, which is unequal in a random sample of
#' hybrids (the chunk of @tbl-keystone-check asserts it for its sample): a line used twice counts
#' twice, so the individuals are the 30 line slots of each pool and not its 25
#' distinct lines. $GD_{WI}$ (lines) and $GD_{WI\text{-}hyb}$ (hybrids) are the
#' same expression, $1 - \tilde s$, over different individuals. The statements of the first
#' row, and the identity $GD_T = 1 - \theta_S = GD_{BI} + GD_{BS}$ of the second,
#' are checked on 30 random hybrids of the book's simulated pools with
#' `gd_partition()` (@tbl-keystone-check):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-keystone-check
#| tbl-cap: "Gene-diversity partition of 30 random hybrids of the book's simulated pools (`gd_partition()`, one draw, seed 7, 25 + 25 lines, 2000 markers). $GD_{WI\\text{-}hyb}$: within individuals, hybrids; $GD_T$, $GD_{WI}$ (parent lines; zero for inbred parents), $GD_{BI}$, $GD_{BS}$: the components of @eq-gd-partition; $F_{ST}$: @eq-f-stats. Dimensionless."
set.seed(7)
idx_h <- sample(ctx[["N"]], 30)
gp    <- gd_partition(idx_h, ctx)
theta_S <- mean(ctx[["f"]][idx_h, idx_h])
H_hyb <- mean(rowMeans(ctx[["X"]][idx_h, , drop = FALSE] == 0.5))
use_A <- tabulate(ctx[["ped"]][["a"]][idx_h], nbins = ctx[["n_lines"]])
stopifnot(identical(idx_h, idx_f),                    # the draw of `fst-two-forms`
          length(unique(use_A[use_A > 0])) > 1,        # usage of the lines drawn is unequal
          abs(gp[["GD_WI"]]) < 1e-12,                 # inbred parents
          all.equal(gp[["GD_WI_hyb"]], H_hyb / 2, tolerance = 1e-12),  # half the F1 heterozygosity
          all.equal(1 - theta_S, gp[["GD_T"]], tolerance = 1e-12),
          all.equal(gp[["GD_T"]], gp[["GD_BI"]] + gp[["GD_BS"]], tolerance = 1e-12))
kt <- fmt(gp)
kt_lab <- c(GD_WI_hyb = "$GD_{WI\\text{-}hyb}$", GD_T = "$GD_T$", GD_WI = "$GD_{WI}$",
            GD_BI = "$GD_{BI}$", GD_BS = "$GD_{BS}$", F_ST = "$F_{ST}$")
knitr::kable(data.frame(Quantity = unname(kt_lab[names(kt)]), Value = unname(kt)),
             row.names = FALSE, align = "lr")

#' 
#' Three consequences follow, and each is a chapter.
#' 
#' **A single pool-wide statistic cannot express "conserve within, hold between".**
#' That is why @sec-catalogue reports the partition rather than only $GD_T$, and why
#' @sec-stages makes stage S1 (conserving the heterotic groups, @tbl-hp-stages) a
#' separate monitoring stage instead of folding pool
#' conservation into the hybrid-selection constraint.
#' 
#' **The between term is not a bonus to be maximised.** Under the conditions of the
#' $GD_{BS}$ row (flat dominance, inbred parents, complete factorial, equal pool
#' weights) expected F1 heterozygosity per locus is $2\bar p\bar q + y^2/2$
#' (@eq-het-split), with $2\bar p \bar q$ the "shared" term, which is $GD_T$, and
#' $y^2/2$ the divergence term, which is $GD_{BS}$. When the pools are redrawn
#' further apart by neutral divergence from the same ancestral frequencies
#' (Balding-Nichols draws, @sec-heterosis-flat), the expectation of the sum does
#' not change, so in expectation every unit of $GD_{BS}$ gained is paid for, unit
#' for unit, by $GD_T$, and pushing the pools apart buys no heterosis. This is a
#' statement about $GD_T$ and $GD_{BS}$, not about $GD_{WS}$: by the drift
#' accounting of @sec-ct-species $GD_{WS}$ falls by twice what $GD_{BS}$ gains. It does not hold
#' for non-flat dominance or for divergence that is aligned with the dominance
#' effects, which @sec-heterosis-alignment treats. The partition tells you
#' where diversity *is*, not which direction to move it.
#' 
#' **The within term is the one with a future.** $GD_{BI}$ is the raw material of
#' next cycle's response, which @sec-response makes precise: among A $\times$ B
#' hybrids genic variance is a sum over loci of the within-pool part of gene
#' diversity, weighted by squared effect, while $GD_T$ also carries the
#' between-pool term that genic variance does not contain. Gene diversity is
#' therefore a proxy for genic variance only through its within-pool part, only if
#' effect sizes are unrelated to which loci lose diversity, and blind to
#' disequilibrium; @sec-limits is where the proxy is pushed until it breaks.
