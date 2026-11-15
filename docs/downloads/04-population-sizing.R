#' # Sizing a segregating population, F1 to F4 {#sec-sizing}
#' 
# 04-population-sizing -- standalone script of the chapter 04-population-sizing.qmd
# Book: https://ederdbs.github.io/QG/04-population-sizing.html
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
f2 <- read.csv(book_data("f2_results.csv"))
ml <- read.csv(book_data("f2_multilocus.csv"))
# captions below hard-code these values; a change must break the render
stopifnot(f2_opt$seed == 20260828, f2_opt$beta_bulk == 6,
          f2_opt$attrition == 0.15, length(unique(f2$N)) == 20,
          all(range(f2$N) == c(10, 390)),
          all(f2$n_rep[f2$N <= 50] == 40), all(f2$n_rep[f2$N >= 210] == 10))

#' 
#' @sec-simulating-crosses draws its parent lines "inbred by fiat" (every locus 0
#' or 2) and does not model the selfing path that produces inbred lines. This
#' chapter models that path for one biparental cross, carried F1 -> F2 -> F3 -> F4
#' by selfing, and asks the question every programme has to answer before it
#' plants anything -- **how many plants?** What is sized is the panel of F4 *lines*
#' the cross yields, a line-level object; it is not the hybrid candidate set, which
#' is formed from lines afterwards (@sec-simulating-crosses).
#' 
#' **Where the cross sits in the programme.** In the terms of @tbl-hp-stages,
#' selfing to fixation is the alternative to doubled-haploid induction that A2
#' allows for deriving lines from a within-pool cross (S2); the simulation stops at
#' F4, not at fixation, so the route is the one A2 licenses and the F4 panel is not
#' yet A2's product (its lines carry $H = 0.125$, @sec-sizing-connects). The cross simulated
#' here has its two inbred parents fixed for different alleles at every locus
#' (SA2 below). If the two parents belong to different heterotic groups, the panel
#' is a derived population of the kind A3 excludes from the programme's recycling
#' loop (@sec-hp-cycle, @sec-era-programme): a pre-breeding or donor cross, outside
#' A1--A8 (@sec-backcross treats introgression from a donor on its own terms). Against the
#' labels A1--A8 (listed in @sec-hybrid-programme; @sec-backcross maps all eight),
#' this chapter uses A2 for the parents (SA2), meets A3 only if the cross is
#' within a pool, and departs from A5 (linked markers, SA4) and A8 (own scale); A1,
#' A4, A6 and A7 are not used (no heterotic groups, cycles, frozen base or
#' dominance in the simulator). Which of the two
#' cases applies does not enter any number below, because the simulator labels
#' ancestry (parent 1 or parent 2) and carries no heterotic-group identity; it
#' decides only whether a panel of this kind belongs to the programme's cycle.
#' 
#' In the grid of this chapter the objectives saturate at very different $N$
#' (@tbl-sizing-saturation), so for this simulated cross there is no single optimal
#' $N$: it depends on what is sized *for*, and an $N$ chosen for the objective that
#' saturates earliest leaves the later ones unmet.
#' 
#' ## The simulated space is ancestry, not alleles {#sec-sizing-ancestry}
#' 
#' Each genome position is coded 0 (from parent P1) or 1 (from parent P2). The
#' simulator carries only loci at which the two inbred parents are fixed for
#' different alleles, one allele each, so ancestry identifies the allele.
#' Loci at which the parents share an allele, and multiallelic loci, are not
#' simulated. Throughout this chapter, "allele frequency" means "frequency of P1
#' ancestry". The parents are written P1 and P2; the assumptions of the chapter are
#' labelled SA1 to SA9 ("sizing assumption") so that the two are not confused.
#' 
#' ## The assumptions, one at a time {#sec-sizing-assumptions}
#' 
#' These are the assumptions the numbers rest on. Read them before trusting any of
#' the numbers.
#' 
#' **SA1. Ancestry, not alleles.** As in @sec-sizing-ancestry: loci fixed for different alleles in the two parents, biallelic, coded by ancestry.
#' 
#' **SA2. Parents fully homozygous and fixed for alternative alleles.** Consequently
#' every F1 plant is genetically identical, so the F1 carries one genotype
#' whatever the number of plants.
#' Sizing the F1 is a **logistical** decision, not a genetic one -- unless the
#' parents carry residual heterozygosity, which @sec-sizing-f1 handles.
#' 
#' **SA3. The genetic map.** Ten chromosomes whose lengths (`maize_chr_len`) total
#' `r sum(maize_chr_len)` cM, i.e. $L$ = `r sum(maize_chr_len) / 100` Morgans. The
#' lengths are a model input chosen to approximate a composite maize map built
#' without intermating; they are not taken from a single published map. Do **not**
#' use map lengths estimated in intermated recombinant inbred lines (RILs) such as
#' the intermated B73 x Mo17 (IBM) population:
#' five generations of intermating B73 x Mo17 produced "nearly a four-fold
#' increase in the genetic map distance" [@lee2002, abstract]. The junction
#' recursion of SA7, which is this chapter's own, gives for $g$
#' random-mating generations after the F2, followed by selfing to fixation,
#' $(2 + g/2)L$ junctions per haplotype, i.e. $4L$ at $g = 4$ and $4.5L$ at
#' $g = 5$, against $L$ for an F2 haplotype and $2L$ for selfing to fixation
#' without intermating. A "four-fold increase" is therefore baseline dependent:
#' against $L$ the recursion gives 4 and 4.5, against $2L$ it gives 2 and 2.25.
#' Which baseline @lee2002 use, and whether the generation that produced the F2 is
#' counted as an intermating, was not checked against the full text (UNVERIFIED);
#' this chapter does not settle it. @winkler2003 treat the expected recombination
#' fraction and the map expansion in intermated recombinant inbred populations
#' (abstract only read); the formula $(2 + g/2)L$ is not taken from them. A map expanded
#' in this way overstates the recombination the sized population actually
#' undergoes.
#' 
## -----------------------------------------------------------------------------
#| output: false
map <- build_map(maize_chr_len, spacing_cM = 2)

#' 
#' The 2 cM map built from these lengths has `r length(map[["chr_len"]])`
#' chromosomes, `r map[["m"]]` markers and a total length of
#' `r map[["total_cM"]]` cM (`r map[["total_cM"]] / 100` Morgans).
#' 
#' **SA4. Haldane recombination, no interference,** identical in male and female.
#' The probability of a haplotype switch between adjacent markers $d$ cM apart is
#' $r = 0.5(1 - e^{-2d/100})$ [@haldane1919]; the first marker of each chromosome
#' gets $r = 0.5$, which produces independent segregation between chromosomes
#' automatically.
#' 
#' *Limitation:* without interference the variance in crossover number is inflated
#' (Poisson). Maize crossovers show positive interference: @falque2009 estimate
#' that about 15% of crossovers (6% to 23% depending on the chromosome) come from a
#' non-interfering pathway and the rest from an interfering one. The simulated
#' block-length distribution may therefore have a longer tail than under
#' interference. The map length fixes the mean number of crossovers per meiosis,
#' hence the expected junction count of the recursion in SA7 when every crossover
#' is observed. What interference would change is the joint distribution of
#' crossovers: the junctions lost to double events inside one marker interval (the
#' bias of SA9) and the extent of the region dragged around a distorter (SA5). The
#' size of these effects was not measured here, so the statement that mean block
#' length is unaffected holds for the expected crossover number, not for the
#' marker-observed count or for the drag.
#' 
#' **SA5. Segregation distortion by rejection sampling,** therefore exact rather
#' than approximate. Two mechanisms: *gametophytic* (of the Ga1 type, a
#' unilateral cross-incompatibility system whose Ga1 gene acts through male
#' function [@zhang2018]) acting only on the male gamete, and *zygotic* (hybrid
#' lethality or subvitality) as genotype fitnesses. Because rejection acts on the
#' **whole gamete**, the region linked to the distorter is dragged along -- which
#' is exactly the phenomenon of interest. Distortion is common in maize mapping
#' populations: 17% of 1,820 markers across four populations, and 36% in B73/Mo17,
#' with three known gametophytic factors as possible causes [@lu2002]. The three
#' distorters of @tbl-sizing-distorters, their positions and their strengths are model inputs. All
#' three act against P2 ancestry (P1 transmission above 0.5 at the two gametic
#' loci, a reduced P2P2 fitness at the zygotic one). The bin numbers in `label`
#' are placeholders, not mapped positions of the named loci.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-distorters
#| tbl-cap: "The three distorters of `f2_distorters`, the model input of SA5: type, chromosome, position in cM, transmission of the P1 allele through the male gamete (column `k` of `f2_distorters`; gametic distorters only; it is not the number of loci $k$ of @eq-sizing-n95), genotype fitnesses $w_{00}$ (P1P1), $w_{01}$ (heterozygote) and $w_{11}$ (P2P2) (zygotic distorter only), and label. The bin numbers in the label are placeholders, not mapped positions of the named loci."
g <- f2_distorters$type == "gametic"
stopifnot(all(f2_distorters$k[g] > 0.5),
          all(f2_distorters$w11[!g] < f2_distorters$w00[!g]))
knitr::kable(f2_distorters[c("type", "chr", "pos_cM", "k", "w00", "w01", "w11",
                             "label")],
             col.names = c("type", "chromosome", "position (cM)", "P1 transmission (`k`)",
                           "$w_{00}$", "$w_{01}$", "$w_{11}$", "label"),
             row.names = FALSE)

#' 
#' ::: {.callout-warning}
#' ## The distorters are plausible, not measured
#' 
#' In the grid of @sec-sizing-results this is the input whose effect on diversity
#' more plants barely reduce inside the range tested (the distortion gap of @fig-sizing-diversity). No
#' sensitivity to the strengths, positions or number of the distorters was run:
#' every statement below about distortion -- the gap, "more plants buy little
#' distortion protection", the recovery numbers -- is a statement about this one
#' configuration. Replace `f2_distorters` with
#' your own F2 genotyping data before using any number here to decide field area.
#' :::
#' 
#' **SA6. Five schemes,** all ending with $H = 0.125$ so they are directly
#' comparable: `ssd` (single-seed descent, SSD: one seed per plant per generation -- the neutral reference,
#' no selection, no drift beyond the meiotic), `ssd_attr` (SSD with a random loss
#' of `r 100 * f2_opt$attrition`% of plants per generation, standing for vigour,
#' partial sterility or flowering asynchrony; the rate is a scenario parameter,
#' `f2_opt$attrition`, not an empirical estimate), `bulk` (differential seed
#' contribution, a Wright-Fisher model with weights $w_i = e^{\beta(z_i - \bar z)}$
#' where $z_i$ is the share of plant $i$'s genome from P1, which the model takes
#' as the adapted parent, and $\beta$ = `r f2_opt$beta_bulk` (`f2_opt$beta_bulk`)
#' is a model input not estimated from data -- a *phenomenological* model of
#' polygenic natural selection, not a model of adaptation loci; because $w_i$
#' increases with $z_i$, the bulk selects against P2 ancestry by construction),
#' and `syn1`/`syn2` (Syn1, Syn2: one or two random intercrossing cycles in the
#' F2 before the two selfings).
#' 
#' **SA7. The F4 panel is not a RIL panel.** Residual heterozygosity is
#' $H = 0.125$, and that changes every theoretical expectation
#' (@tbl-sizing-f4-identities). Here $H$ is the observed heterozygosity $H_o$ of
#' @sec-hp-popgen -- the fraction of loci at which a plant is heterozygous --
#' averaged over the plants of the panel and over loci; it is not the expected heterozygosity
#' $H_T$, $H_S$ of @sec-subdivided, which is computed from allele frequencies. The last row of @tbl-sizing-f4-identities counts junctions in the sense of @fisher1954: $A_t$ junctions per haplotype in
#' generation $t$, $L$ the map length in Morgans, $h_t$ the heterozygosity of the
#' parent whose meiosis produces generation $t + 1$ (the $H_t$ of @eq-hp-drift is a
#' different quantity, the expected heterozygosity of a set at generation $t$).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-f4-identities
#| tbl-cap: "Theoretical identities for an F4 panel ($H$ = 0.125), $N$ lines per panel, no distortion. Column $c$: the F4 coefficient; column Value in F4: the quantity written with that $c$. The form $0.5/\\sqrt{N}$ for SE($\\hat p$) is the case $H$ = 0 (fully inbred lines, F$_\\infty$). Junction coefficient from `expected_junctions()` on the 2 cM map of SA3, in units of $L$ (Morgans)."
#| echo: false
H <- 0.125
A_F4 <- expected_junctions("ssd", map)[["junctions"]] / (map$total_cM / 100)
knitr::kable(data.frame(
  Quantity = c("Var(dosage per line)", "SE(p_hat)", "Diversity retained D",
               "P(P2 homozygote per locus)", "Junctions per haplotype"),
  Formula = c("(1 - H) / 4", "0.5 sqrt((1 - H) / N)", "1 - (1 - H) / N",
              "(1 - H) / 2", "A_2 = L; A_(t+1) = A_t + L h_t"),
  c = fmt(c((1 - H) / 4, 0.5 * sqrt(1 - H), 1 - H, (1 - H) / 2, A_F4), 5),
  `Value in F4` = c("c", "c / sqrt(N)", "1 - c / N", "c", "c L"),
  check.names = FALSE))

#' 
#' The diversity row of @tbl-sizing-f4-identities is the identity used
#' throughout the chapter. Let $p_j \in [0, 1]$ be the frequency of P1 ancestry at
#' marker $j = 1, \dots, m$ in a panel of $N$ F4 lines, one per F2 plant, and
#' $D = m^{-1} \sum_j 2 p_j (1 - p_j) / 0.5 \in [0, 1]$ the diversity retained
#' (`diversity_retained()`), with the frequency base the panel itself. Without
#' distortion and without selection (`ssd`),
#' $$
#' \mathrm{E}[D] = 1 - \frac{1 - H}{N},
#' $$ {#eq-sizing-div}
#' with $H$ = 0.125 the F4 heterozygosity of SA7 and the expectation taken over
#' replicate populations. @sec-sizing-verify checks it by simulation; it was not
#' derived in full here, only by the following argument at $p_0 = 1/2$. There
#' $\mathrm{E}[D] = 1 - 4\,\mathrm{Var}(\hat p)$ and, for $N$ independent F4 lines,
#' $\mathrm{Var}(\hat p) = (1 - H)/(4N)$ (first row of @tbl-sizing-f4-identities).
#' At $H = 0$ this is the $1/n$ loss of @eq-hp-drift for a pool of $n$ = $N$ doubled
#' haploid lines, each passing one gamete (@sec-hp-popgen), and the same sampling
#' factor as the finite-set bias of @sec-baseline. What the factor $(1 - H)$ adds is
#' that the one-step loss $1/n_{gam}$ of @eq-hp-drift equals $(1 - H)/N$ when
#' $n_{gam} = N/(1 - H)$: a heterozygous line carries both ancestries at a locus, so
#' $n_{gam}$ rises from $N$ at $H = 0$ to $2N$ at $H = 1/2$. This is an equivalence of
#' the sampling variance of $\hat p$, not a Wright effective size.
#' 
#' **SA8. The standard error is estimated between replicates,** not between markers.
#' This is essential: linked markers are strongly autocorrelated, so the spread
#' across markers within one replicate is not an estimator of sampling error.
#' 
#' **SA9. What is not modelled,** and therefore cannot be answered here: deliberate
#' artificial selection, quantitative trait locus (QTL) architecture, phenotypic inbreeding depression,
#' mutation (irrelevant on this timescale), and structural variation. If you know
#' there is a large inversion between your parents, zero the recombination rate
#' over that interval in `build_map()`.
#' 
#' *Known bias:* a junction is counted only as a change of ancestry between
#' adjacent markers, so two junctions inside the same marker interval cancel and
#' the simulated count is biased downward. Its size at the grid's spacing and at
#' 1 cM is measured in @sec-sizing-verify.
#' 
#' ## Verifying the identities live {#sec-sizing-verify}
#' 
#' The theory of @sec-sizing-assumptions is not decoration -- it is checkable, and the simulator is only
#' trustworthy if it reproduces it. The heterozygosity and diversity checks
#' (@tbl-sizing-verify-het, @tbl-sizing-verify-diversity) run on a 10 cM map with
#' distortion switched off, so the neutral expectations apply exactly. The
#' junction checks do not share that setup: @tbl-sizing-verify-junctions uses the
#' cached grid (2 cM map, distortion active), and @tbl-sizing-verify-spacing uses
#' live neutral panels on 2 cM and 1 cM maps; each caption states its setup.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-verify-het
#| tbl-cap: "Mean per-plant heterozygosity, F1 to F4, in one live lineage of 400 plants (10 cM map, distortion off, seed 4); s.e. is the standard error between plants; H_expected is $(1/2)^{t-1}$ for generation F$_t$."
map10 <- build_map(maize_chr_len, spacing_cM = 10)
neutral <- make_distortion(map10, NULL, active = FALSE)

set.seed(4)  # one draw: a single F1 -> F4 lineage of 400 plants
F1 <- make_F1(map10, 400)
F2 <- cross_indices(F1, 1:400, 1:400, map10, neutral)
F3 <- cross_indices(F2, 1:400, 1:400, map10, neutral)
F4 <- cross_indices(F3, 1:400, 1:400, map10, neutral)

stopifnot(ncol(F4$H1) == 400)  # "400 plants" in the caption
het_chk <- do.call(rbind, lapply(list(F1, F2, F3, F4), function(P) {
  h <- colMeans(P$H1 != P$H2)          # per-plant heterozygosity
  c(H_observed = mean(h), se = stats::sd(h) / sqrt(length(h)))
}))
het_chk <- data.frame(generation = c("F1", "F2", "F3", "F4"), het_chk,
                      H_expected = c(1, 0.5, 0.25, 0.125))
# tolerance: 4 standard errors between plants (the F1 has none)
stopifnot(all(abs(het_chk$H_observed - het_chk$H_expected) <=
              pmax(4 * het_chk$se, 1e-12)))
knitr::kable(fmt(het_chk, 4),
             col.names = c("generation", "H_observed", "s.e.", "H_expected"))

#' 
#' Heterozygosity halves (@tbl-sizing-verify-het) at every selfing, within four between-plant standard
#' errors. The diversity identity is an expectation over replicate populations,
#' so @tbl-sizing-verify-diversity checks @eq-sizing-div on the replicate mean,
#' again against four standard errors:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-verify-diversity
#| tbl-cap: "Diversity retained $D$ in neutral SSD panels (10 cM map, distortion off), 100 live replicate populations per $N$ (seed 5 + $N$). D_mean and D_sd: mean and s.d. between replicates; D_expected: @eq-sizing-div; z: (D_mean - D_expected) / (D_sd / 10)."
n_rep_chk <- 100
stopifnot(n_rep_chk == 100)  # "100 replicate populations" and "D_sd / 10" in the caption
check <- do.call(rbind, lapply(c(20, 50, 100, 200), function(N) {
  set.seed(5 + N)
  D <- replicate(n_rep_chk,
                 diversity_retained(panel_freq(run_scheme("ssd", N, map10,
                                                          neutral, f2_opt))))
  data.frame(N = N, D_mean = mean(D), D_sd = stats::sd(D),
             D_expected = 1 - (1 - 0.125) / N)
}))
check$z <- (check$D_mean - check$D_expected) / (check$D_sd / sqrt(n_rep_chk))
stopifnot(all(abs(check$z) < 4))
knitr::kable(fmt(check, 4))

#' 
#' With `r n_rep_chk` replicate populations per $N$ the largest standardised
#' deviation of the mean from @eq-sizing-div is `r fmt(max(abs(check$z)), 2)`
#' standard errors.
#' 
#' Map expansion is an algebraic prediction (@tbl-sizing-expected-junctions):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-expected-junctions
#| tbl-cap: "Expected junctions per haplotype and the corresponding mean block length after SSD, Syn1 and Syn2, from the recursion of @tbl-sizing-f4-identities (`expected_junctions()`, 2 cM map of SA3, no distortion)."
Lm <- map$total_cM / 100
ej <- rbind(SSD  = expected_junctions("ssd",  map),
            Syn1 = expected_junctions("syn1", map),
            Syn2 = expected_junctions("syn2", map))
knitr::kable(fmt(ej, 2))

#' 
#' Each Syn cycle adds only
#' `r (expected_junctions("syn1", map)[["junctions"]] - expected_junctions("ssd", map)[["junctions"]]) / Lm`$L$
#' junctions, not $1.0L$. The extra meiosis creates a junction only where the
#' parent is heterozygous, and $H = 0.5$ at the F2/Syn stage. Budgeting an
#' intercrossing cycle as "one more map length of recombination" overstates what
#' it buys by a factor of two.
#' 
#' The prediction is checked against the simulated junction counts of the cached
#' grid (2 cM markers, distortion active; mean of `junctions_per_hap()` over 20
#' lines per replicate, pooled over the replicates of all `r length(unique(f2$N))`
#' values of $N$; @tbl-sizing-verify-junctions):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-verify-junctions
#| tbl-cap: "Junctions per haplotype, recursion against the cached grid (`regenerate.R f2size`, 2 cM map, distortion active). n_rep: replicate populations pooled over all grid $N$; expected: `expected_junctions()` (SSD recursion for ssd, ssd_attr and bulk); simulated: replicate-weighted mean of `junctions_per_hap()`; deficit_pct: 100 (simulated / expected - 1), in %."
jd <- do.call(rbind, lapply(unique(f2$scheme), function(s) {
  d <- f2[f2$scheme == s, ]
  e <- expected_junctions(if (s %in% c("syn1", "syn2")) s else "ssd",
                          map)[["junctions"]]
  o <- stats::weighted.mean(d$junc, d$n_rep)
  data.frame(scheme = s, n_rep = sum(d$n_rep), expected = e,
             simulated = o, deficit_pct = 100 * (o / e - 1))
}))
stopifnot(all(jd$deficit_pct < 0),
          all(diff(jd$deficit_pct[match(c("ssd", "syn1", "syn2"),
                                        jd$scheme)]) < 0))
knitr::kable(fmt(jd, 2))

#' 
#' Every scheme counts fewer junctions than predicted:
#' `r fmt(jd$deficit_pct[jd$scheme == "ssd"], 1)`% for SSD,
#' `r fmt(jd$deficit_pct[jd$scheme == "syn1"], 1)`% and
#' `r fmt(jd$deficit_pct[jd$scheme == "syn2"], 1)`% for one and two intercrossing
#' cycles. This is the known bias of SA9, and it is larger than the single-meiosis
#' Haldane deficit at 2 cM, $r/d - 1$ =
#' `r fmt(100 * (0.5 * (1 - exp(-0.04)) / 0.02 - 1), 1)`%. The inference is that
#' the deficit grows with the number of junctions accumulated before the count,
#' because junctions laid down by different meioses inside one interval also
#' cancel; the cached grid supports it only through the ordering SSD, Syn1, Syn2,
#' not through a separate test. The bulk departs further than SSD, and the
#' recursion does not model selection on ancestry, so its row is not a test of the
#' recursion.
#' 
#' A finer map shortens the junction-count deficit, but it was not shown to remove
#' it at 1 cM. The chunk below measures the deficit on 20 independent
#' neutral SSD panels of 500 lines per spacing, all lines counted
#' (@tbl-sizing-verify-spacing):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-verify-spacing
#| tbl-cap: "Junction-count deficit against `expected_junctions()` at 2 cM and 1 cM marker spacing: 20 independent neutral SSD panels of 500 lines per spacing (seeds 1100 + panel index at 2 cM, 1200 + panel index at 1 cM). mean_pct, sd_pct and se_pct: mean, standard deviation between panels and standard error of the mean over the 20 panels, of the deficit 100 (simulated / expected - 1), in %; panels_below_0: panels with a negative deficit."
n_pan <- 20
stopifnot(n_pan == 20)  # "20 independent ... panels" in the caption
spacing_chk <- do.call(rbind, lapply(c(2, 1), function(sp) {
  m  <- build_map(maize_chr_len, spacing_cM = sp)
  nn <- make_distortion(m, NULL, active = FALSE)
  e  <- expected_junctions("ssd", m)[["junctions"]]
  d  <- vapply(seq_len(n_pan), function(i) {
    set.seed(if (sp == 2) 1100 + i else 1200 + i)
    pop <- run_scheme("ssd", 500, m, nn, f2_opt)
    100 * (junctions_per_hap(pop, m, n_lines = 500) / e - 1)
  }, numeric(1))
  data.frame(spacing_cM = sp, mean_pct = mean(d), sd_pct = stats::sd(d),
             se_pct = stats::sd(d) / sqrt(n_pan), panels_below_0 = sum(d < 0))
}))
knitr::kable(fmt(spacing_chk, 2))

#' 
## -----------------------------------------------------------------------------
#| include: false
sp2 <- spacing_chk[spacing_chk$spacing_cM == 2, ]
sp1 <- spacing_chk[spacing_chk$spacing_cM == 1, ]
se_sp_diff <- sqrt(sp2$se_pct^2 + sp1$se_pct^2)
stopifnot(sp1$mean_pct < 0, sp1$mean_pct > sp2$mean_pct)  # "reduced but not removed"

#' 
#' At 1 cM the mean deficit is
#' `r fmt(sp1$mean_pct, 1)`% (standard error `r fmt(sp1$se_pct, 1)`% over
#' `r n_pan` panels; `r sp1$panels_below_0` of the `r n_pan` panels are below zero),
#' against `r fmt(sp2$mean_pct, 1)`% at 2 cM (standard error
#' `r fmt(sp2$se_pct, 1)`%). The difference is
#' `r fmt(sp1$mean_pct - sp2$mean_pct, 1)` percentage points (s.e.
#' `r fmt(se_sp_diff, 1)`). The deficit is reduced but not removed by the finer
#' map in these panels; a spacing at which the count is unbiased within the
#' between-panel s.d. was not looked for. The 2 cM mean of these neutral panels
#' (`r fmt(sp2$mean_pct, 1)`%) lies within
#' `r fmt(abs(sp2$mean_pct - jd$deficit_pct[jd$scheme == "ssd"]), 1)` percentage
#' points of the distortion-active grid row of @tbl-sizing-verify-junctions
#' (`r fmt(jd$deficit_pct[jd$scheme == "ssd"], 1)`%), against a between-panel s.d.
#' of `r fmt(sp2$sd_pct, 1)`; this shows no effect of distortion on the count that
#' the replication can resolve, and is not a test of one (the grid pools 20-line
#' samples from many sizes of $N$, the panels are 500 lines at one).
#' 
#' ## The results {#sec-sizing-results}
#' 
#' The full grid -- five schemes, `r length(unique(f2$N))` population sizes,
#' adaptive replication -- takes several minutes and is shipped precomputed.
#' @tbl-sizing-ssd-grid gives its SSD rows at ten of those sizes.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-ssd-grid
#| tbl-cap: "SSD, the reference scheme without selection, at ten of the twenty grid sizes $N$ (F2 plants); cached grid (`regenerate.R f2size`, 2 cM map, distortion active, seed 20260828). Column n_rep: independent F1-to-F4 populations per $N$ (40 at $N \\leq$ 50, falling to 10 from $N$ = 210). Every other column is a mean over those replicates; s.d.($D$) is between replicates; skewed genome is the percentage of markers with $\\lvert p - 0.5 \\rvert > 0.15$ (`skew_fraction()`); $p$ is the P1 ancestry frequency."
#| echo: false
ssd <- f2[f2$scheme == "ssd", ]
sel <- ssd[ssd$N %in% c(10, 30, 50, 70, 90, 110, 150, 190, 290, 390), ]
knitr::kable(data.frame(
  N = sel$N,
  n_rep = sel$n_rep,
  D = fmt(sel$div, 3),
  `s.d.(D)` = fmt(sel$div_sd, 4),
  `SE(p_hat)` = fmt(sel$se_p, 3),
  `skewed genome (%)` = fmt(100 * sel$skew, 1),
  `min(p, 1-p)` = fmt(sel$pmin, 3),
  `N equivalent` = fmt(sel$n_eq, 0),
  check.names = FALSE))

#' 
#' ### Diversity stays below the distortion-free curve at every N tested
#' 
#' @fig-sizing-diversity plots $D$ for the five schemes against the
#' distortion-free expectation.
#' 
## -----------------------------------------------------------------------------
#| label: fig-sizing-diversity
#| fig-cap: "Diversity retained $D$ (dimensionless, 1 = no loss) in the F4 panel against the number of F2 plants $N$, for the five schemes of SA6 (bulk at $\\beta$ = 6, attrition 15%). Each point is the mean over 10 to 40 replicate populations (more at small $N$; counts per $N$ for SSD in @tbl-sizing-ssd-grid); no error bars are drawn. The vertical axis spans the whole range of the data. Cached grid (`regenerate.R f2size`, 2 cM map, distortion active, seed 20260828). Dashed: the distortion-free expectation @eq-sizing-div, $H$ = 0.125."
#| fig-alt: "Line chart of diversity retained, from about 0.74 to 1, against number of F2 plants from 10 to 390, one line per scheme (ssd, ssd_attr, bulk, syn1, syn2) and a dashed distortion-free curve lying above them; the bulk line is lowest, 0.74 at 10 plants."
schemes <- unique(f2$scheme)
stopifnot(round(min(f2$div), 2) == 0.74, round(min(f2$div[f2$N == 10]), 2) == 0.74,
          f2$scheme[which.min(f2$div)] == "bulk")  # values in the alt text
# scheme colours: neutral, distinct from the pool A/B colours of book_pal
cols <- c(ssd = book_pal[["ink"]], ssd_attr = book_pal[["mid"]],
          bulk = "#762a83", syn1 = "#1b7837", syn2 = "#7fbf7b")
plot(NA, xlim = range(f2$N), ylim = c(min(f2$div), 1.0),
     xlab = expression(N[F2]~"plants"), ylab = "diversity retained, D")
grid()
for (s in schemes) {
  d <- f2[f2$scheme == s, ]
  lines(d$N, d$div, type = "b", pch = 19, cex = 0.6, col = cols[s], lwd = 1.8)
}
curve(1 - 0.875 / x, add = TRUE, lty = 2, col = "grey30", lwd = 1.5)
legend("bottomright", c(schemes, "theory, no distortion"),
       col = c(cols[schemes], "grey30"), lwd = c(rep(1.8, length(schemes)), 1.5),
       lty = c(rep(1, length(schemes)), 2), pch = c(rep(19, length(schemes)), NA),
       bty = "n", cex = 0.8)

#' 
## -----------------------------------------------------------------------------
#| echo: false
ssd  <- ssd[order(ssd$N), ]
Nmax <- max(ssd$N)
gap  <- (1 - 0.875 / ssd$N) - ssd$div
gap_slope <- stats::coef(stats::lm(gap ~ ssd$N))[[2]]
# weighted least squares, weights = inverse sampling variance of each mean;
# s.e. from those known variances, not rescaled by the residual variance
w_gap   <- ssd$n_rep / ssd$div_sd^2
gap_b   <- stats::coef(stats::lm(gap ~ ssd$N, weights = w_gap))[[2]]
gap_bse <- 1 / sqrt(sum(w_gap * (ssd$N - stats::weighted.mean(ssd$N, w_gap))^2))

#' 
#' At the largest $N$ tested (`r Nmax`), SSD retains $D$ =
#' `r fmt(ssd$div[ssd$N == Nmax], 4)` (s.d. `r fmt(ssd$div_sd[ssd$N == Nmax], 4)`
#' over `r ssd$n_rep[ssd$N == Nmax]` replicates), and the curve is still rising:
#' $D$ gains `r fmt(ssd$div[ssd$N == Nmax] - ssd$div[ssd$N == 110], 4)` from
#' $N$ = 110 to $N$ = `r Nmax`. Across the `r nrow(ssd)` grid points the gap
#' between the distortion-free expectation and the SSD mean lies between
#' `r fmt(min(gap), 4)` and `r fmt(max(gap), 4)`, with a least-squares slope of
#' `r fmt_sci(100 * gap_slope)` per 100 plants (unweighted). Weighted by
#' the inverse sampling variance of each replicate mean ($n_{rep}/s^2$, with $s$
#' the between-replicate s.d. of $D$), the slope is
#' `r fmt_sci(100 * gap_b)` per 100 plants, s.e.
#' `r fmt_sci(100 * gap_bse)` (from those variances), so
#' `r fmt(gap_b / gap_bse, 1)` standard errors from zero. Over the whole grid
#' that slope amounts to `r fmt_sci(gap_b * (Nmax - min(ssd$N)))` against a mean
#' gap of `r fmt(mean(gap), 4)`. No limit of $D$ as
#' $N \to \infty$ was computed; the grid stops at `r Nmax`.
#' 
#' The gap is attributed to distortion by a neutral twin on the same 2 cM map:
#' 20 live populations of SSD with distortion switched off, at two grid
#' sizes (@tbl-sizing-twin).
#' 
## -----------------------------------------------------------------------------
#| include: false
a_rows <- f2[f2$scheme == "ssd_attr", ]
attr <- data.frame(N = a_rows$N, div = a_rows$div,
                   div_ssd = ssd$div[match(a_rows$N, ssd$N)],
                   pred = 0.875 / a_rows$n_final - 0.875 / a_rows$N)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-twin
#| tbl-cap: "Neutral twin of the SSD grid rows: diversity retained $D$ at $N$ = 110 and 390 F2 plants, 2 cM map, 20 live replicate populations per $N$ with distortion off (seed 2100 + $N$), against the distortion-active cached grid rows. D_neutral and se_neutral: mean and standard error between the 20 populations; D_expected: @eq-sizing-div; gap_neutral = D_expected - D_neutral; D_grid and gap_grid: the cached SSD row (distortion active) and D_expected - D_grid."
n_twin <- 20
stopifnot(n_twin == 20)  # "20 live replicate populations" in the caption
map2 <- build_map(maize_chr_len, spacing_cM = 2)
neutral2 <- make_distortion(map2, NULL, active = FALSE)
twin <- do.call(rbind, lapply(c(110, 390), function(N) {
  set.seed(2100 + N)
  D <- replicate(n_twin, diversity_retained(panel_freq(
    run_scheme("ssd", N, map2, neutral2, f2_opt))))
  Dx <- 1 - 0.875 / N
  Dg <- ssd$div[ssd$N == N]
  data.frame(N = N, D_neutral = mean(D), se_neutral = stats::sd(D) / sqrt(n_twin),
             D_expected = Dx, gap_neutral = Dx - mean(D),
             D_grid = Dg, gap_grid = Dx - Dg)
}))
knitr::kable(fmt(twin, 5))

#' 
#' At $N$ = 110 and 390 the neutral gap is
#' `r fmt_sci(twin$gap_neutral[1])` and `r fmt_sci(twin$gap_neutral[2])`
#' (standard errors of the mean `r fmt_sci(twin$se_neutral[1])` and
#' `r fmt_sci(twin$se_neutral[2])`), against
#' `r fmt_sci(twin$gap_grid[1])` and `r fmt_sci(twin$gap_grid[2])` with distortion
#' active, i.e. `r fmt(100 * twin$gap_neutral[1] / twin$gap_grid[1], 0)`% and
#' `r fmt(100 * twin$gap_neutral[2] / twin$gap_grid[2], 0)`% of it. The
#' interpretation is that, at these two sizes, the gap is the
#' **segregation distortion**: the departure from @eq-sizing-div without it is
#' small against the gap and, at $N$ = 110, within
#' `r fmt(twin$gap_neutral[1] / twin$se_neutral[1], 1)` standard errors of zero; the
#' other grid sizes were not run neutral. It is a bias which more plants barely
#' reduce inside the range tested: the weighted slope is at the margin of detection
#' and, taken at face value, removes a small fraction of the gap across the whole
#' grid. Adding plants buys drift protection, and little distortion protection,
#' for this one distorter configuration (SA5). How the gap behaves beyond $N$ =
#' `r Nmax` was not measured.
#' 
#' `ssd_attr` is plotted against $N$ F2 plants, but its F4 panel holds only
#' `r fmt(100 * min(f2$n_final[f2$scheme == "ssd_attr"] / f2$N[f2$scheme == "ssd_attr"]), 0)`%
#' to
#' `r fmt(100 * max(f2$n_final[f2$scheme == "ssd_attr"] / f2$N[f2$scheme == "ssd_attr"]), 0)`%
#' of $N$ lines after two attrition losses of `r 100 * f2_opt$attrition`%. Summed
#' over the grid, the difference in $D$ between SSD and `ssd_attr` at equal $N$ is
#' `r fmt(sum(attr$div_ssd - attr$div), 4)`, and @eq-sizing-div evaluated at the
#' smaller number of lines (`r fmt(sum(attr$pred), 4)`) accounts for
#' `r fmt(100 * sum(attr$pred) / sum(attr$div_ssd - attr$div), 0)`% of it. The
#' interpretation is that the deficit of `ssd_attr` in @fig-sizing-diversity is its smaller
#' panel, not a different process; the grid-point differences are noisy (the
#' per-point ratio ranges widely) and no test of the residual was made.
#' 
#' @fig-sizing-ancestry shows the same separation along the genome, on two live
#' panels (4 cM map, distortion active, one population each).
#' 
## -----------------------------------------------------------------------------
#| label: fig-sizing-ancestry
#| fig-cap: "Frequency of P1 ancestry at each marker, ordered along chromosomes 1 to 10 (grey verticals: chromosome boundaries), in one SSD F4 panel from $N$ = 20 F2 plants and one from $N$ = 300; a single population each, simulated live (4 cM map, distortion active, seeds 6 and 7), so no error band. Dashed: 0.5, the neutral expectation. At $N$ = 20 the whole curve is noisy: that is drift, and more plants reduce it. At $N$ = 300 the departures from 0.5 that remain sit at the three distorters (dotted red lines): the deterministic bias."
#| fig-alt: "Line chart of P1 ancestry frequency (0 to 1) at each marker along chromosomes 1 to 10, for one panel from 20 F2 plants and one from 300. The N = 20 curve wanders widely around the dashed 0.5 line; the N = 300 curve stays near 0.5 except at three dotted red lines marking the distorters, where it departs."
map4 <- build_map(maize_chr_len, spacing_cM = 4)
dist <- make_distortion(map4, f2_distorters)
n_small <- 20; n_large <- 300
stopifnot(n_small == 20, n_large == 300)  # N = 20 and N = 300 in caption and legend
set.seed(6)
small <- panel_freq(run_scheme("ssd", n_small, map4, dist, f2_opt))
set.seed(7)
large <- panel_freq(run_scheme("ssd", n_large, map4, dist, f2_opt))

plot(small, type = "l", col = book_pal[["mid"]], ylim = c(0, 1),
     xlab = "genome (chromosomes 1-10)", ylab = "P1 ancestry frequency", xaxt = "n")
lines(large, col = book_pal[["ink"]], lwd = 1.6)
abline(h = 0.5, lty = 2, col = "grey50")
# chromosome boundaries and distorter positions
bnd <- which(map4$first)
axis(1, at = (c(bnd, map4$m + 1)[-1] + bnd) / 2, labels = seq_along(map4$chr_len))
abline(v = bnd[-1] - 0.5, col = book_pal[["light"]])
for (i in seq_len(nrow(f2_distorters)))
  abline(v = marker_index(map4, f2_distorters$chr[i], f2_distorters$pos_cM[i]),
         col = book_pal[["loss"]], lty = 3)
legend("topleft", c("N = 20", "N = 300", "distorter"), col = book_pal[c("mid", "ink", "loss")],
       lty = c(1, 1, 3), lwd = c(1, 1.6, 1), bty = "n", cex = 0.8, horiz = TRUE)

#' 
#' ### Under selection for P1 ancestry, the bulk retains the least diversity
#' 
#' @tbl-sizing-bulk-vs-ssd sets the bulk against the lowest of the other four
#' schemes at ten of the grid sizes (the same ten as @tbl-sizing-ssd-grid), with the
#' between-replicate dispersion of both.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-bulk-vs-ssd
#| tbl-cap: "Diversity retained $D$ of the bulk ($\\beta$ = 6) against the lowest-$D$ of the other four schemes, at ten of the twenty grid sizes $N$ (cached grid, `regenerate.R f2size`, 2 cM map, distortion active). Means over $n_{rep}$ replicate populations with the between-replicate s.d. in parentheses; margin: (other - bulk) / s.e., with s.e. = $\\sqrt{s_b^2/n_{rep} + s_o^2/n_{rep}}$."
#| echo: false
bk <- do.call(rbind, lapply(sort(unique(f2$N)), function(N) {
  d <- f2[f2$N == N, ]
  b <- d[d$scheme == "bulk", ]
  o <- d[d$scheme != "bulk", ]
  o <- o[which.min(o$div), ]
  data.frame(N = N, n_rep = b$n_rep, D_bulk = b$div, sd_bulk = b$div_sd,
             lowest_other = o$scheme, D_other = o$div, sd_other = o$div_sd,
             margin = (o$div - b$div) / sqrt(b$div_sd^2 / b$n_rep +
                                              o$div_sd^2 / o$n_rep))
}))
bulk_lowest_all <- all(bk$margin > 0)
show <- bk[bk$N %in% c(10, 30, 50, 70, 90, 110, 150, 190, 290, 390), ]
knitr::kable(data.frame(
  N = show$N, n_rep = show$n_rep,
  `D bulk (s.d.)` = paste0(fmt(show$D_bulk, 3), " (", fmt(show$sd_bulk, 4), ")"),
  `lowest other` = show$lowest_other,
  `D other (s.d.)` = paste0(fmt(show$D_other, 3), " (", fmt(show$sd_other, 4), ")"),
  margin = fmt(show$margin, 1), check.names = FALSE))

#' 
#' The bulk has the lowest mean $D$ of the five schemes at
#' `r sum(bk$margin > 0)` of the `r nrow(bk)` grid values of $N$, with a margin to
#' the next-lowest scheme of `r fmt(min(bk$margin), 1)` to
#' `r fmt(max(bk$margin), 1)` standard errors. (The comparator is the minimum of
#' four means, which makes the margin conservative.) This follows from a model
#' input: `bulk_weights()` raises the seed contribution of plants with more P1
#' ancestry, with $\beta$ = `r f2_opt$beta_bulk`, so the loss of P2 ancestry is
#' built into the scheme, and its size depends on $\beta$, which was not varied
#' here.
#' 
## -----------------------------------------------------------------------------
#| include: false
b390 <- f2[f2$scheme == "bulk" & f2$N == max(f2$N), ]
s30  <- f2[f2$scheme == "ssd"  & f2$N == 30, ]
se_b_s <- sqrt(b390$div_sd^2 / b390$n_rep + s30$div_sd^2 / s30$n_rep)
z_b_s  <- (s30$div - b390$div) / se_b_s

#' 
#' One contrast across sizes was looked at after the grid had been seen, and is
#' therefore exploratory: the bulk at the largest $N$ (`r max(f2$N)`) against SSD
#' at $N$ = 30. The bulk retains $D$ = `r fmt(b390$div, 4)` (s.d.
#' `r fmt(b390$div_sd, 4)`, `r b390$n_rep` replicates) and SSD
#' `r fmt(s30$div, 4)` (s.d. `r fmt(s30$div_sd, 4)`, `r s30$n_rep` replicates); the
#' difference is `r fmt(s30$div - b390$div, 4)` with standard error
#' `r fmt(se_b_s, 4)`, `r fmt(z_b_s, 1)` standard errors. That is borderline, and
#' the comparator $N$ was not fixed beforehand, so it is not offered as a finding;
#' the ordering at equal $N$ in @tbl-sizing-bulk-vs-ssd is. If P2 is the donor whose germplasm the cross
#' was made to introduce, and natural selection in the bulk favours P1 ancestry as
#' this model assumes, the bulk is not a cheaper SSD -- it is a different
#' experiment.
#' 
#' ### Block length changes little with N in the grid
#' 
#' @tbl-sizing-block-length summarises block length and the junction-on-$N$
#' slope per scheme.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-block-length
#| tbl-cap: "Mean block length (cM) and the least-squares slope of junctions per haplotype on $N$, per scheme, from the cached grid's junction counts (`regenerate.R f2size`, 2 cM map, distortion active, one replicate mean per grid $N$, $N$ = 10 to 390). block_min_cM, block_max_cM: range over $N$ of total map length / (junctions + chromosomes); junc_slope_per_100 and slope_se_per_100: slope and its standard error, junctions per 100 plants."
nchr <- length(map$chr_len)
blk <- do.call(rbind, lapply(unique(f2$scheme), function(s) {
  d <- f2[f2$scheme == s, ]
  b <- map$total_cM / (d$junc + nchr)    # mean block length, cM
  fit <- summary(stats::lm(d$junc ~ d$N))$coefficients
  data.frame(scheme = s, block_min_cM = min(b), block_max_cM = max(b),
             junc_slope_per_100 = 100 * fit[2, 1],
             slope_se_per_100 = 100 * fit[2, 2])
}))
knitr::kable(fmt(blk, 2))

#' 
#' Mean block length is computed from the cached junction counts as total map
#' length over (junctions + chromosomes), the definition of
#' `expected_junctions()`. Under SSD it ranges from
#' `r fmt(blk$block_min_cM[blk$scheme == "ssd"], 1)` to
#' `r fmt(blk$block_max_cM[blk$scheme == "ssd"], 1)` cM across $N$ =
#' `r min(f2$N)` to `r max(f2$N)`, and the slope of junctions on $N$ is
#' `r fmt(blk$junc_slope_per_100[blk$scheme == "ssd"], 3)` junctions per 100 plants
#' (s.e. `r fmt(blk$slope_se_per_100[blk$scheme == "ssd"], 3)`). One and two
#' intercrossing cycles shorten the blocks to about
#' `r fmt(mean(c(blk$block_min_cM[blk$scheme == "syn1"], blk$block_max_cM[blk$scheme == "syn1"])), 1)`
#' and
#' `r fmt(mean(c(blk$block_min_cM[blk$scheme == "syn2"], blk$block_max_cM[blk$scheme == "syn2"])), 1)`
#' cM. The counts carry the junction deficit measured in @sec-sizing-verify, so
#' the absolute lengths are too long by about the size of that deficit; the comparison across $N$ and
#' across schemes is what @tbl-sizing-block-length supports.
#' 
## -----------------------------------------------------------------------------
#| include: false
blk$z <- blk$junc_slope_per_100 / blk$slope_se_per_100
junc_mean <- vapply(blk$scheme, function(s) mean(f2$junc[f2$scheme == s]), numeric(1))
blk$pct_range <- 100 * blk$junc_slope_per_100 * (max(f2$N) - min(f2$N)) / 100 / junc_mean
imax <- which.max(abs(blk$z))

#' 
#' The slope is not specific to SSD: over the five schemes the slopes are within
#' `r fmt(min(blk$z), 1)` to `r fmt(max(blk$z), 1)` standard errors of zero, the
#' largest in absolute value being `r blk$scheme[imax]` at
#' `r fmt(blk$junc_slope_per_100[imax], 2)` junctions per 100 plants. Over the
#' `r max(f2$N) - min(f2$N)` plants of the grid it amounts to at most
#' `r fmt(max(abs(blk$pct_range)), 1)`% of that scheme's mean junction count. Within
#' this grid, block length is therefore set mainly by the number of meioses and
#' changes by about that much, at most, with $N$. Against linkage drag the
#' instrument is an **intercrossing cycle, not field area**, for this grid, which is
#' what the Syn rows of @tbl-sizing-expected-junctions quantify.
#' 
#' ### The metrics saturate at different N
#' 
#' This is the central practical result of the chapter, for this simulated cross,
#' and the reason the question "what is the optimal $N$?" has no single answer
#' (@tbl-sizing-saturation). To make "saturates" checkable it is defined
#' on the grid: for $D$ and for the worst region $\min(p, 1-p)$, $N_{90}$ is the
#' smallest grid $N$ whose replicate mean has reached 90% of the gain from the
#' smallest to the largest $N$ tested. The definition is relative to the grid's
#' upper end (`r max(f2$N)`), so a longer grid would move it. The replicate means
#' carry sampling error, and so does the threshold, which is built from the two
#' end means; @tbl-sizing-saturation therefore also gives a two-standard-error bracket: the
#' last grid $N$ whose mean lies more than two standard errors below the
#' threshold, and the first that lies more than two above it. For recovery of a
#' P2 homozygote at $k$ unlinked loci the target is absolute,
#' $P \geq 0.95$. Its distortion-free closed form, the classical number of plants
#' needed to recover a genotype [@sedcole1977], is
#' 
#' $$
#' N_{95}(k) = \frac{\log 0.05}{\log\left[1 - \left(\frac{1-H}{2}\right)^k\right]},
#' $$ {#eq-sizing-n95}
#' 
#' with $(1 - H)/2$ the probability that an F4 line is P2P2 at one locus (SA7) and
#' the $k$ loci on different chromosomes. $P$ is the probability that at least one
#' of the $N$ F4 lines of a panel is P2P2 at all $k$ loci, for loci drawn at random
#' on distinct chromosomes (`multilocus_recovery()`, 300 locus sets per population).
#' The closed form takes the lines as independent and the loci as independent, which
#' holds for $N$ F2 plants of one uniform F1 and for loci on different chromosomes.
#' 
#' **Recovery is measured on replicate populations.** The cached grid holds
#' **one** population per $N$ for this objective, so its first-crossing $N$ cannot
#' be separated from between-population variance, and the first crossing of a noisy
#' curve is biased low. The chunk below therefore replaces it by 20 live
#' populations per grid $N$ (SSD, 2 cM map, distortion active, the 20 sizes of the
#' grid, seed 20261108 + $N$), with the same 300 locus sets per population
#' (@fig-sizing-multilocus plots the replicate means). The
#' design is the first one run, and was not changed after its results were seen
#' (one earlier timing run used the same seeds and settings): $N_{95}$ is the first
#' grid $N$ whose replicate mean reaches 0.95, reported with a two-standard-error
#' bracket (last $N$ whose mean + 2 s.e. is below 0.95, first $N$ whose mean - 2 s.e.
#' is at or above it), and the standard error is between populations, so it includes
#' the locus-set sampling.
#' 
## -----------------------------------------------------------------------------
#| label: ml-replicates
#| include: false
n_ml <- 20
stopifnot(n_ml == 20)  # "20 live populations" in the text and in the figure caption
map2 <- build_map(maize_chr_len, spacing_cM = 2)
dist2 <- make_distortion(map2, f2_distorters, active = TRUE)
Ngrid <- sort(unique(ml$N))
kk <- sort(unique(ml$k))
mlr <- do.call(rbind, lapply(Ngrid, function(N) {
  set.seed(20261108 + N)
  P <- t(replicate(n_ml, {
    pop <- run_scheme("ssd", N, map2, dist2, f2_opt)
    vapply(kk, function(k) multilocus_recovery(pop, map2, k), numeric(1))
  }))
  data.frame(N = N, k = kk, P = colMeans(P),
             se = apply(P, 2, stats::sd) / sqrt(n_ml))
}))
n95_closed <- function(k, H = 0.125) log(0.05) / log(1 - ((1 - H) / 2)^k)
P_closed_f <- function(k, N, H = 0.125) 1 - (1 - ((1 - H) / 2)^k)^N
mlr_first <- vapply(kk, function(k) {
  d <- mlr[mlr$k == k, ]
  if (any(d$P >= 0.95)) d$N[which(d$P >= 0.95)[1]] else NA_real_
}, numeric(1))
mlr_br <- t(vapply(kk, function(k) {
  d <- mlr[mlr$k == k, ]
  lo <- d$N[d$P + 2 * d$se < 0.95]
  hi <- d$N[d$P - 2 * d$se >= 0.95]
  c(lo = if (length(lo)) max(lo) else NA_real_,
    hi = if (length(hi)) min(hi) else NA_real_)
}, numeric(2)))
ml_first95 <- vapply(kk, function(k) {   # cached one-population grid
  d <- ml[ml$k == k, ]; d <- d[order(d$N), ]
  if (any(d$P >= 0.95)) d$N[which(d$P >= 0.95)[1]] else NA_real_
}, numeric(1))
mlr_end <- mlr[mlr$N == max(mlr$N), ]
mlr$closed <- P_closed_f(mlr$k, mlr$N)
mlr$below2 <- mlr$P + 2 * mlr$se < mlr$closed

#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-saturation
#| tbl-cap: "Different objectives, different answers. $D$, $\\min(p, 1-p)$ and SE($\\hat p$): SSD replicate means of the cached grid (`regenerate.R f2size`, 2 cM map, distortion active, $N$ = 10 to 390 F2 plants). $N_{90}$: smallest grid $N$ whose replicate mean reaches 90% of the gain from the smallest to the largest grid $N$. 2-s.e. bracket of $N_{90}$: last grid $N$ with (mean - threshold) below -2 s.e. and first with it above +2 s.e., s.e. combining the standard error of the mean at that $N$ (between-replicate s.d. / $\\sqrt{n_{rep}}$) and that of the threshold. Recovery of $k$ loci: 20 live populations per grid $N$ (SSD, 2 cM map, distortion active, seeds 20261108 + $N$; computed in this chapter, not cached), criterion mean $P \\geq$ 0.95; its bracket: last $N$ with mean + 2 s.e. below 0.95 and first with mean - 2 s.e. at or above it; value at largest $N$: mean (s.e.) over the 20 populations; closed form: @eq-sizing-n95, rounded."
n90 <- function(N, y) {
  thr <- y[1] + 0.9 * (y[length(y)] - y[1])
  N[which(y >= thr)[1]]
}
# 2-s.e. bracket of the crossing; se = between-replicate sd / sqrt(n_rep)
n90_bracket <- function(N, y, se) {
  n   <- length(y)
  thr <- y[1] + 0.9 * (y[n] - y[1])
  z   <- (y - thr) / sqrt(se^2 + 0.01 * se[1]^2 + 0.81 * se[n]^2)
  below <- which(z < -2 & N < n90(N, y))
  above <- which(z > 2 & N >= n90(N, y))
  c(lo = if (length(below)) N[max(below)] else NA_real_,
    hi = if (length(above)) N[min(above)] else NA_real_)
}
br_D    <- n90_bracket(ssd$N, ssd$div,  ssd$div_sd  / sqrt(ssd$n_rep))
br_pmin <- n90_bracket(ssd$N, ssd$pmin, ssd$pmin_sd / sqrt(ssd$n_rep))
stopifnot(!anyNA(br_D), !anyNA(br_pmin))  # both brackets exist on this grid
pmin_prev <- ssd$N[which(ssd$N == n90(ssd$N, ssd$pmin)) - 1]  # grid N before the crossing
n95_grid_k3 <- min(Ngrid[P_closed_f(3, Ngrid) >= 0.95])
br_txt <- function(i) {
  b <- mlr_br[i, ]
  if (all(is.na(b))) "--"
  else if (is.na(b[["hi"]])) paste0("> ", max(mlr$N))
  else paste(ifelse(is.na(b[["lo"]]), "< 10", b[["lo"]]), "to", b[["hi"]])
}

# closed form against a neutral simulation, k = 5, N = 110 (10 cM map), and the
# same design with the three distorters active (seed 9, declared before the run)
set.seed(8)
P_pops <- replicate(20, multilocus_recovery(
  run_scheme("ssd", 110, map10, neutral, f2_opt), map10, 5))
P_neutral <- mean(P_pops)
P_se      <- stats::sd(P_pops) / sqrt(length(P_pops))
P_closed  <- P_closed_f(5, 110)
stopifnot(abs(P_neutral - P_closed) < 4 * P_se)  # 4 s.e. between populations
dist10 <- make_distortion(map10, f2_distorters, active = TRUE)
set.seed(9)
P_dpops <- replicate(20, multilocus_recovery(
  run_scheme("ssd", 110, map10, dist10, f2_opt), map10, 5))
P_dist    <- mean(P_dpops)
P_dist_se <- stats::sd(P_dpops) / sqrt(length(P_dpops))

fmt_ms <- function(m, se, d = 3) paste0(fmt(m, d), " (", fmt(se, d), ")")
sat <- data.frame(
  Objective = c("Diversity retained (D)",
                "Worst region of the genome, min(p, 1-p)",
                "Precision of the panel's p_hat",
                paste0("Recovery of ", kk, " loci")),
  Criterion = c("N90", "N90", "none: SE falls as N^(-1/2)",
                rep("mean P >= 0.95", length(kk))),
  `Grid N reaching it` = c(n90(ssd$N, ssd$div), n90(ssd$N, ssd$pmin), "--",
                           ifelse(is.na(mlr_first), "not reached", mlr_first)),
  `2-s.e. bracket` = c(paste(br_D, collapse = " to "),
                       paste(br_pmin, collapse = " to "), "--",
                       vapply(seq_along(kk), br_txt, character(1))),
  `Value at largest N` = c(fmt(ssd$div[ssd$N == Nmax], 4),
                           fmt(ssd$pmin[ssd$N == Nmax], 3),
                           fmt(ssd$se_p[ssd$N == Nmax], 4),
                           fmt_ms(mlr_end$P, mlr_end$se)),
  `Closed form N95, no distortion` = c("--", "--", "--",
                                       round(n95_closed(kk))),
  check.names = FALSE)
knitr::kable(sat)

#' 
#' The closed form @eq-sizing-n95 was checked against a neutral simulation at $k$ = 5, $N$ = 110 on a 10 cM map:
#' `r fmt(P_neutral, 3)` (s.e. `r fmt(P_se, 3)` between the 20 populations)
#' against `r fmt(P_closed, 3)`; the chunk asserts agreement within four such
#' standard errors. The same design with the three distorters active
#' (`set.seed(9)`, 20 populations) gives `r fmt(P_dist, 3)` (s.e.
#' `r fmt(P_dist_se, 3)`), `r fmt((P_closed - P_dist) / P_dist_se, 1)` standard
#' errors below the closed form. On the 2 cM grid, the replicate mean of $P$ lies
#' more than two standard errors below the closed form at
#' `r sum(mlr$below2[mlr$k >= 5])` of `r sum(mlr$k >= 5)` (grid $N$, $k$) points with
#' $k \geq 5$ (the points of one curve share their locus-set sampling and are not
#' independent). For $k = 3$, at
#' $N$ = `r min(mlr$N)` the replicate mean is `r fmt(mlr$P[mlr$k == 3 & mlr$N == min(mlr$N)], 3)`
#' and the closed form `r fmt(P_closed_f(3, min(mlr$N)), 3)`; the replicate curve first reaches 0.95 at grid $N$ = `r mlr_first[kk == 3]`, the closed form at
#' grid $N$ = `r n95_grid_k3`.
#' 
#' The inference is that distortion against P2, which all three distorters exert,
#' lowers the per-locus probability of a P2P2 line, so that the closed-form
#' $N_{95}$ understates what this simulated cross needs: at $k$ = 5 the closed form
#' gives `r round(n95_closed(5))` plants and the replicated grid first reaches 0.95
#' at `r mlr_first[kk == 5]` (bracket `r br_txt(2)`). Both rest on one distorter
#' configuration (SA5) and on loci drawn at random on distinct chromosomes, whatever
#' their distance from a distorter. For $k \geq 8$ the closed form already lies far
#' outside the grid, and no grid $N$ reaches the target: the replicate means at
#' $N$ = `r max(mlr$N)` are `r fmt(mlr_end$P[kk == 8], 3)` (s.e. `r fmt(mlr_end$se[kk == 8], 3)`) at $k$ = 8 and
#' `r fmt(mlr_end$P[kk == 10], 3)` (s.e. `r fmt(mlr_end$se[kk == 10], 3)`) at $k$ = 10. The cached one-population grid
#' (`f2_multilocus.csv`) first crosses 0.95 at `r ml_first95[kk == 3]` for $k$ = 3 and
#' at `r ml_first95[kk == 5]` for $k$ = 5; it is not used for any number of the
#' working table.
#' 
#' For $D$ the two-standard-error bracket of $N_{90}$ runs from
#' `r br_D[["lo"]]` to `r br_D[["hi"]]`. For $\min(p, 1-p)$ the replicate means
#' cross the threshold between grid $N$ = `r pmin_prev`
#' and `r n90(ssd$N, ssd$pmin)`, but the bracket runs from `r br_pmin[["lo"]]` to
#' `r br_pmin[["hi"]]`. The inference is that the worst-region curve is flat
#' within its replicate error over that range, so the grid does not locate its
#' $N_{90}$; more replicates per $N$ would be needed to do so. The
#' contrast between objectives in @tbl-sizing-saturation rests on $D$ and on
#' recovery, not on $\min(p, 1-p)$.
#' 
## -----------------------------------------------------------------------------
#| label: fig-sizing-multilocus
#| fig-cap: "Multilocus recovery: probability that at least one F4 line is homozygous for P2 at $k$ unlinked loci ($k$ = 3, 5, 8, 10), against the number of F2 plants $N$; SSD, distortion active, 2 cM map. Each point is the mean over 20 live populations per $N$ (seeds 20261108 + $N$, computed in this chapter), each with 300 random locus sets; bars are $\\pm$ 2 standard errors between the populations. Dashed: the distortion-free closed form of @eq-sizing-n95."
#| fig-alt: "Line chart of the probability of recovering a P2 homozygote at k loci against number of F2 plants from 10 to 390, replicate means with error bars, one line for each of k = 3, 5, 8 and 10, and dashed distortion-free curves above them; k = 3 rises from about 0.5 to 1, k = 5 from about 0.1 to about 0.99, k = 8 reaches about 0.3 and k = 10 about 0.06 at 390 plants."
stopifnot(isTRUE(all.equal(kk, c(3, 5, 8, 10))))  # k values hard-coded in the caption
stopifnot(round(mlr$P[mlr$k == 3 & mlr$N == 10], 1) == 0.5,
          round(mlr_end$P[kk == 5], 1) == 1, round(mlr_end$P[kk == 8], 1) == 0.3,
          round(mlr_end$P[kk == 10], 2) == 0.06)  # values in the alt text
# k colours: neutral grey ramp, distinct from the pool A/B colours of book_pal
cols_k <- grey(seq(0, 0.6, length.out = length(kk)))
plot(NA, xlim = range(mlr$N), ylim = c(0, 1), xlab = expression(N[F2]~"plants"),
     ylab = "P(at least one line P2P2 at all k loci)")
grid()
for (i in seq_along(kk)) {
  d <- mlr[mlr$k == kk[i], ]
  lines(d$N, d$P, type = "b", pch = 14 + i, cex = 0.6, col = cols_k[i], lwd = 1.8)
  w <- d$se > 0   # no bar where the 20 populations agree exactly
  arrows(d$N[w], d$P[w] - 2 * d$se[w], d$N[w], pmin(1, d$P[w] + 2 * d$se[w]),
         angle = 90, code = 3, length = 0.02, col = cols_k[i])
  lines(d$N, d$closed, lty = 2, col = cols_k[i])
}
legend("bottomright", paste("k =", kk), col = cols_k, lwd = 1.8,
       pch = 14 + seq_along(kk), bty = "n")

#' 
#' The marginal gain in $D$ tells the same story from the other side. The standard
#' error of each step combines the two replicate means (@tbl-sizing-steps):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-steps
#| tbl-cap: "Gain in mean $D$ between consecutive grid sizes, SSD, cached grid (`regenerate.R f2size`, 2 cM map, distortion active). s.e.: standard error of the difference of the two replicate means, $\\sqrt{s_1^2/n_1 + s_2^2/n_2}$ with $s$ the between-replicate s.d. of $D$ and $n$ the replicate count at each size."
#| echo: false
steps <- data.frame(
  step = paste0(utils::head(ssd$N, -1), " -> ", ssd$N[-1]),
  gain_in_D = diff(ssd$div),
  se = sqrt(utils::head(ssd$div_sd^2 / ssd$n_rep, -1) +
            ssd$div_sd[-1]^2 / ssd$n_rep[-1]))
N90_D <- n90(ssd$N, ssd$div)
past  <- steps[ssd$N[-nrow(ssd)] >= N90_D, ]
knitr::kable(fmt(steps, 4), col.names = c("step", "gain_in_D", "s.e."))

#' 
#' Past $N_{90}$ = `r N90_D` for $D$, the `r nrow(past)` steps of 20 plants gain
#' between `r fmt(min(past$gain_in_D), 4)` and `r fmt(max(past$gain_in_D), 4)`;
#' `r sum(abs(past$gain_in_D) < 2 * past$se)` of them are within two standard
#' errors of zero. The grid cannot resolve the marginal gain of a single step of
#' 20 plants there; it resolves only the cumulative gain to $N$ = `r Nmax`.
#' 
#' ## Sizing the F1 {#sec-sizing-f1}
#' 
#' With fully homozygous parents the F1 is genetically uniform and the decision is
#' logistical.
#' 
## -----------------------------------------------------------------------------
#| include: false
h_res <- 0.05   # fraction of loci still heterozygous in each parent (scenario)
n_loc <- 5000   # independent loci polymorphic between the parents (scenario)

#' 
#' Suppose instead that each parent is still heterozygous at a
#' fraction $h_{res}$ of the $n_{loc}$ loci that are polymorphic between the two
#' parents and segregate independently. Here $1 - h_{res}$ is the proportion of
#' those loci at which a parent is homozygous, not an inbreeding coefficient
#' relative to a base population, and $h_{res}$ = `r h_res`,
#' $n_{loc}$ = `r n_loc` are scenario values, not estimates for any
#' germplasm. Heterozygosity is assumed to arise independently in the two
#' parents, so there are $2 h_{res} n_{loc}$ heterozygous (parent, locus) pairs in
#' expectation. Each F1 plant receives one random gamete from each parent, so at a
#' heterozygous (parent, locus) pair one of the parent's two alleles is
#' transmitted to no F1 plant when all $n$ plants receive the same one, with
#' probability $2(1/2)^n$. The expected number of **parental alleles lost** is
#' therefore $2 h_{res} n_{loc} \cdot 2(1/2)^n$, the quantity `f1_sizing()`
#' returns.
#' 
#' That is not the number of loci lost. Under the biallelic assumption of SA1, a
#' parent heterozygous $Aa$ at a locus where the other parent is $aa$ loses
#' polymorphism at that locus only if every F1 plant receives $a$, with
#' probability $(1/2)^n$; losing $a$ leaves the other parent's $a$ in the F2. A
#' locus heterozygous in both parents (probability $h_{res}^2$) becomes
#' monomorphic only if all $n$ F1 plants are $AA$ or all are $aa$, with
#' probability $2(1/4)^n$. The expected number of **loci made monomorphic** is
#' $n_{loc}\left[2 h_{res}(1 - h_{res})(1/2)^n + h_{res}^2 \cdot 2(1/4)^n\right]$
#' (@tbl-sizing-f1).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-f1
#| tbl-cap: "Expected parental alleles lost (`f1_sizing()`: heterozygous (parent, locus) pairs at which one allele reaches no F1 plant) and expected loci made monomorphic (biallelic loci, computed in the chunk), against the number $n$ of F1 plants, at the scenario values $h_{res}$ = 0.05 and $n_{loc}$ = 5000 independent loci; rows shown at selected $n$, including both thresholds and the sizes below them; values to three significant digits. The monomorphic count is checked in the chunk against an enumeration of the parental genotype classes (`p_mono()`)."
s <- f1_sizing(n_F1 = 1:20, h_res = h_res, n_loci_eff = n_loc)
lost_col <- grep("lost", names(s), value = TRUE)   # alleles lost, per f1_sizing()
stopifnot(length(lost_col) == 1,
          isTRUE(all.equal(s[[lost_col]], 2 * h_res * n_loc * 2 * 0.5^s$n_F1)))
s$expected_loci_monomorphic <- n_loc * (2 * h_res * (1 - h_res) * 0.5^s$n_F1 +
                                        h_res^2 * 2 * 0.25^s$n_F1)
# oracle: enumeration of parental genotype classes. A gamete is allele 0 or 1;
# a heterozygous parent transmits (1/2, 1/2), a homozygous one allele 0, except
# in the homozygous x homozygous case, where the parents differ (SA1). The F2 is
# monomorphic iff all n F1 plants have the same dose and it is 0 or 2.
p_mono <- function(g1, g2, n) {
  d <- c(g1[1] * g2[1], g1[1] * g2[2] + g1[2] * g2[1], g1[2] * g2[2])
  d[1]^n + d[3]^n
}
het <- c(0.5, 0.5); hom0 <- c(1, 0); hom1 <- c(0, 1)
enum_mono <- n_loc * (h_res^2 * p_mono(het, het, s$n_F1) +
                      2 * h_res * (1 - h_res) * p_mono(het, hom0, s$n_F1) +
                      (1 - h_res)^2 * p_mono(hom0, hom1, s$n_F1))
stopifnot(isTRUE(all.equal(s$expected_loci_monomorphic, enum_mono)))
n_f1     <- min(s$n_F1[s[[lost_col]] < 1])
n_f1_loc <- min(s$n_F1[s$expected_loci_monomorphic < 1])
s_show <- s[s$n_F1 %in% sort(unique(c(4, n_f1_loc - 1, n_f1_loc, n_f1,
                                      12, 16, 20))), ]
s_show[-1] <- lapply(s_show[-1], formatC, digits = 3, format = "g")
knitr::kable(s_show, row.names = FALSE)

#' 
#' `r n_f1` F1 plants is the smallest number that puts the expected number
#' of parental alleles lost below one (`r fmt(s[[lost_col]][n_f1], 3)`, against
#' `r fmt(s[[lost_col]][n_f1 - 1], 3)` with `r n_f1 - 1` plants).
#' `r n_f1_loc` plants is the smallest number that puts the expected number of
#' loci made monomorphic below one
#' (`r fmt(s$expected_loci_monomorphic[n_f1_loc], 3)`, against
#' `r fmt(s$expected_loci_monomorphic[n_f1_loc - 1], 3)` with `r n_f1_loc - 1`
#' plants). The first criterion is the stricter: it also counts an allele lost
#' from one parent that the other parent still carries. Under these assumptions,
#' independent loci and independent heterozygosity in the two parents included,
#' that is the whole F1 sizing argument.
#' 
#' ## Working numbers
#' 
#' @tbl-sizing-working-numbers collects the sizing decisions generation by
#' generation.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-working-numbers
#| tbl-cap: "Working numbers for this simulated cross, read off the SSD rows of the cached grid ($N$ = 10 to 390 F2 plants, 2 cM map, distortion active, one distorter configuration) and `f1_sizing()` at the scenario values $h_{res}$ = 0.05, $n_{loc}$ = 5000. Size for the objective that binds, not for $D$: $N_{90}$ for $D$ is a grid-relative reference point, not a recommended F2 size. The recovery numbers are replicate means over 20 live populations per $N$ (@tbl-sizing-saturation), with their 2-s.e. brackets; no number is read from a single population."
#| echo: false
stopifnot(h_res == 0.05, n_loc == 5000)  # values hard-coded in the caption
F_F3 <- 1 - 0.25                     # F^(2) = 1 - (1/2)^2: inbreeding of an F3 plant, F1 as base
P_k  <- setNames(mlr_end$P, kk)
k_hit <- max(kk[!is.na(mlr_first)])  # largest k reaching mean P >= 0.95 on the grid
knitr::kable(data.frame(
  Generation = c("F1", "F2", "", "", "F3", "F4"),
  Plants = c(paste0(n_f1, " F1 plants, minimum"),
             paste0(mlr_first[kk == k_hit], " if the binding objective is recovery at k = ",
                    k_hit, " (bracket ", br_txt(which(kk == k_hit)), ")"),
             paste0("not reached at N <= ", Nmax,
                    " for recovery at k >= 8; set by the precision required for p_hat"),
             paste0("N90 for D = ", N90_D, ": a reference point, not a size"),
             "same N (SSD, one seed per plant)",
             "lines x plants per line set by seed need"),
  Rationale = c(
    paste0("One genotype in the F1 with homozygous parents, a logistical call. With h_res = ",
           h_res, " in both parents, ", n_f1,
           " plants put expected parental alleles lost below 1 (",
           n_f1_loc, " put expected loci made monomorphic below 1)"),
    paste0("First grid N with mean P(recovery) >= 0.95 at k = ", k_hit,
           ", 20 populations per N; closed form without distortion: ",
           round(n95_closed(k_hit))),
    paste0("At N = ", Nmax, ", mean P(recovery) = ",
           fmt(P_k[["8"]], 3), " (k = 8), ",
           fmt(P_k[["10"]], 3), " (k = 10); SE(p_hat) = ",
           fmt(ssd$se_p[ssd$N == Nmax], 4), ", still falling as N^(-1/2)"),
    paste0("Grid-relative (2-s.e. bracket ", br_D[["lo"]], " to ", br_D[["hi"]],
           "). From N90 to N = ", Nmax, ", +", Nmax - N90_D, " plants buy +",
           fmt(ssd$div[ssd$N == Nmax] - ssd$div[ssd$N == N90_D], 4), " of D"),
    "Does not create diversity, only avoids losing it",
    paste0("Seed multiplication. Plants of the same line are not independent ",
           "replicates: their coancestry is (1 + F)/2 = ",
           (1 + F_F3) / 2, " with F = F^(2) = ", F_F3,
           " (F1 as base)")),
  check.names = FALSE))

#' 
#' $F$ in the last row is the inbreeding coefficient in the convention of
#' @sec-hp-inbreeding: $F^{(t)}$ after $t$ selfings, so an F3 plant has
#' $F^{(2)} = 1 - (1/2)^2$, with the F1 as the base generation.
#' 
#' ::: {.callout-warning}
#' ## On the "equivalent N"
#' 
#' $N_{eq} = (1 - H)/(1 - D)$ answers "how many F4 lines without distortion would
#' give the diversity actually observed". It is a **communication device, not a
#' Wright effective size**: it converts a deterministic bias into a drift
#' equivalent. Use it to compare scenarios; never substitute it into an $N_e$
#' formula.
#' :::
#' 
#' ## Where this connects {#sec-sizing-connects}
#' 
#' The rest of the book works on one kernel: molecular coancestry $f$
#' (@sec-coancestry) and gene diversity $GD = 1 - \theta$ (@eq-hp-gd, derived in
#' @sec-identity). An F4 panel can be put through it, and this section measures two
#' things about the result: the identity between $D$ and $GD$, and what a selection
#' of lines from the panel can and cannot do to $GD$ (@tbl-sizing-bridge).
#' 
#' **Scope of the bridge.** The later chapters budget the $GD$ of *hybrids* formed
#' from lines of two pools, against a frozen base $p_0$ and a random-subset
#' reference, under A2 (inbred parents, so $GD_{WI} = 0$), A5 (independent loci) and
#' A8 (the teaching scale), the assumptions declared in @sec-era-programme. The panel here departs from each: its lines carry
#' $H = 0.125$, so $GD_{WI} > 0$ at the line level; its markers are linked (SA4);
#' its frequency base is the panel itself and $D$ divides by the cross's own maximum
#' 0.5, not by a frozen base. What is established below is the line-level quantity
#' of one derived panel, not the quantity the later chapters budget.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-bridge
#| tbl-cap: "One live SSD F4 panel per $N$ F2 plants (column n_F2; 10 cM map, distortion active, seed 3 + $N$): diversity retained $D$, mean molecular coancestry $\\theta$ over all pairs of lines with self included, $GD = 1 - \\theta$ and $N_s = 1/(2\\theta)$, frequency base the panel itself. fixed: fraction of markers fixed in the panel; bound: $(1 - \\text{fixed})/2$. The subset comparison on the same panels is in @tbl-sizing-bridge-subsets."
map_br  <- build_map(spacing_cM = 10)
dist_br <- make_distortion(map_br, active = TRUE)
n_sub <- 10   # lines selected from each panel (scenario value)
stopifnot(n_sub == 10)  # "subsets of 10 lines" in the caption

bridge <- do.call(rbind, lapply(c(30, 120, 480), function(n) {
  set.seed(3 + n)
  pop <- run_scheme("ssd", n, map_br, dist_br, opt = f2_opt)
  X   <- t((pop$H1 + pop$H2) / 2)          # lines x markers, 0/0.5/1
  f   <- molecular_coancestry(X)
  th  <- mean(f)                           # all pairs, self included
  p   <- panel_freq(pop)
  gd_of <- function(i) 1 - mean(f[i, i, drop = FALSE])
  sel <- integer(0)                        # greedy: add the line that lowers theta most
  for (j in seq_len(n_sub)) {
    cand <- setdiff(seq_len(n), sel)
    th_c <- vapply(cand, function(i) mean(f[c(sel, i), c(sel, i)]), numeric(1))
    sel  <- c(sel, cand[which.min(th_c)])
  }
  set.seed(100 + n)
  rnd <- replicate(200, gd_of(sample.int(n, n_sub)))
  data.frame(n_F2 = n, D = diversity_retained(p), theta = th, GD = 1 - th,
             Ns = 1 / (2 * th), fixed = mean(p == 0 | p == 1),
             GD_random = mean(rnd), GD_random_sd = stats::sd(rnd),
             GD_greedy = gd_of(sel), bound = (1 - mean(p == 0 | p == 1)) / 2)
}))
stopifnot(isTRUE(all.equal(bridge$GD, bridge$D / 2)),
          isTRUE(all.equal(bridge$Ns, 1 / (2 - bridge$D))),
          all(bridge$GD_greedy <= bridge$bound + 1e-12))
knitr::kable(fmt(bridge[c("n_F2", "D", "theta", "GD", "Ns", "fixed", "bound")], 4))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-bridge-subsets
#| tbl-cap: "Subsets of 10 lines from the panels of @tbl-sizing-bridge (column n_F2). GD_random (s.d.): mean (s.d. in parentheses) of $GD$ over 200 random subsets of 10 lines (seed 100 + n_F2); GD_greedy: $GD$ of 10 lines chosen by greedy minimisation of $\\theta$ of the subset; GD: $GD$ of the whole panel; bound: $(1 - \\text{fixed})/2$."
knitr::kable(data.frame(
  n_F2 = bridge$n_F2,
  `GD_random (s.d.)` = paste0(fmt(bridge$GD_random, 4), " (",
                              fmt(bridge$GD_random_sd, 4), ")"),
  GD_greedy = fmt(bridge$GD_greedy, 4), GD = fmt(bridge$GD, 4),
  bound = fmt(bridge$bound, 4), check.names = FALSE))

#' 
#' $D$, the chapter's own diversity-retained statistic, and $GD$, the quantity the
#' later chapters constrain, are the same quantity up to a factor:
#' $GD = D/2$ exactly, asserted in the chunk. With the 0/0.5/1 coding and
#' $\theta$ the mean of the molecular coancestry over all pairs of lines, self
#' included [@caballero2002], $\theta$ averages $p^2 + (1-p)^2$ over markers, so
#' $GD = 1 - \theta$ is the mean of $2p(1-p)$, which is $D/2$ because $D$ divides
#' the same mean by its maximum 0.5. The frequency base is the F4 panel itself.
#' 
#' *What the panel's $GD$ limits.* A locus fixed in the panel is fixed in every
#' subset of its lines, so $GD$ of any subset is at most $(1 - \text{fixed})/2$
#' (the `bound` column of @tbl-sizing-bridge-subsets, asserted in the chunk that builds @tbl-sizing-bridge). The fraction of markers fixed is
#' `r fmt(max(bridge$fixed), 3)` at most in these three panels (10 cM map,
#' distortion active), so the bound is not the binding limit here. The measured
#' statement is narrower: on each of the three panels the greedy choice of
#' `r n_sub` lines reaches $GD$ = `r fmt(min(bridge$GD_greedy), 3)` to
#' `r fmt(max(bridge$GD_greedy), 3)`, against `r fmt(min(bridge$GD), 3)` to
#' `r fmt(max(bridge$GD), 3)` for the whole panel and
#' `r fmt(min(bridge$GD_random), 3)` to `r fmt(max(bridge$GD_random), 3)` for random
#' subsets of the same size. In these three panels the greedy subset did not exceed
#' the $GD$ of its panel. That is three panels, one subset size, one distorter
#' configuration and a heuristic that is not an exact optimum, so it does not
#' establish a ceiling. The book's own results show that, on hybrids against a
#' random-subset reference, a selection can have $\alpha < 0$ (@sec-baseline), so a
#' subset can be more diverse than a random one; here the comparison is with the
#' whole panel's own $GD$. What is certain is the conditional statement: no
#' selection of lines restores an allele that the panel does not carry.
#' 
#' ::: {.callout-note}
#' ## $N_s$ on these panels
#' 
#' The status number is $N_s = 1/(2\theta) = 1/(2 - D)$, between
#' `r fmt(min(bridge$Ns), 3)` and `r fmt(max(bridge$Ns), 3)` in @tbl-sizing-bridge
#' whatever the sizing, and bounded above by 1 because $D \leq 1$. On molecular
#' coancestry at biallelic loci $\theta \in [1/2, 1]$, so $N_s \in [1/2, 1]$ for
#' *every* set of lines, one cross or many (@sec-ns): $N_s$ is a monotone
#' rescaling of $\theta$, not a head count, and no pooling of crosses would make it
#' one. The values in @tbl-sizing-bridge are correct rather than broken; $N_s$ is a
#' monotone function of $D$ and carries no information that $D$ does not, compressed
#' into $[1/2, 1]$, so use $D$ and $GD$ to compare sizing scenarios.
#' :::
#' 
#' @sec-stages measures how the loss is distributed across stages S2 to S4
#' (@tbl-hp-stages); it does not vary the number of plants per cross, and this
#' chapter measures no cost, so what "more plants" would cost against what it buys
#' is not established here. @sec-limits is where the same question is asked about
#' the *variance* rather than the frequencies, and reaches a different conclusion
#' about what is recoverable.
