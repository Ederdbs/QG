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

# The teaching scale. Every live example in the book runs at this size: small
# enough that a full render takes minutes, large enough that none of the
# identities hold by accident. The production scale is n_pool_A = n_pool_B = 71
# and m = 25000; see the note in each chapter where the difference matters.
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
#' The previous chapters took the candidate pool as given. This one asks where it
#' comes from: a wide cross between two divergent parents, carried F1 -> F2 -> F3
#' -> F4, and the question every programme has to answer before it plants anything
#' -- **how many plants?**
#' 
#' The answer turns out to depend entirely on what you are sizing *for*. There is
#' no single optimal $N$, and the most common failure is to size for the objective
#' that saturates earliest and then be surprised when a different objective was
#' never met.
#' 
#' ## The simulated space is ancestry, not alleles {#sec-sizing-ancestry}
#' 
#' Each genome position is coded 0 (from parent P1) or 1 (from parent P2). For a
#' wide biparental cross between two divergent heterotic groups this is the correct
#' abstraction: essentially every locus polymorphic between the parents is
#' biallelic, so ancestry is a sufficient statistic. Throughout this chapter,
#' "allele frequency" means "frequency of P1 ancestry".
#' 
#' ## The assumptions, one at a time {#sec-sizing-assumptions}
#' 
#' These are the assumptions the numbers rest on. Read them before trusting any of
#' the numbers.
#' 
#' **P1. Ancestry, not alleles.** As in @sec-sizing-ancestry.
#' 
#' **P2. Parents fully homozygous and fixed for alternative alleles.** Consequently
#' every F1 plant is genetically identical and the genetic $N_e$ of the F1 is 1.
#' Sizing the F1 is a **logistical** decision, not a genetic one -- unless the
#' parents carry residual heterozygosity, which @sec-sizing-f1 handles.
#' 
#' **P3. The genetic map.** Ten chromosomes whose lengths (`maize_chr_len`) total
#' `r sum(maize_chr_len)` cM, i.e. $L$ = `r sum(maize_chr_len) / 100` Morgans. The
#' lengths are a model input chosen to approximate a composite maize map built
#' without intermating; they are not taken from a single published map. Do **not**
#' use map lengths estimated in intermated recombinant inbred lines (RILs) such as
#' the intermated B73 x Mo17 (IBM) population:
#' five generations of intermating B73 x Mo17 produced "nearly a four-fold
#' increase in the genetic map distance" [@lee2002, abstract]. The junction
#' recursion of P7 predicts expansion of that order [@winkler2003]: $g$
#' random-mating generations after the F2, followed by selfing to fixation, give
#' $(2 + g/2)L$ junctions per haplotype, i.e. $4L$ at $g = 4$ and $4.5L$ at
#' $g = 5$. Which of the two matches the IBM count depends on whether the
#' generation that produced the F2 is counted as an intermating; this chapter
#' does not settle it. A map expanded in this way overstates the recombination
#' the sized population actually undergoes.
#' 
## -----------------------------------------------------------------------------
map <- build_map(maize_chr_len, spacing_cM = 2)
c(chromosomes = length(map$chr_len), markers = map$m,
  total_cM = map$total_cM, morgans = map$total_cM / 100)

#' 
#' **P4. Haldane recombination, no interference,** identical in male and female.
#' The probability of a haplotype switch between adjacent markers $d$ cM apart is
#' $r = 0.5(1 - e^{-2d/100})$ [@haldane1919]; the first marker of each chromosome
#' gets $r = 0.5$, which produces independent segregation between chromosomes
#' automatically.
#' 
#' *Limitation:* without interference the variance in crossover number is inflated
#' (Poisson). Maize crossovers show positive interference: @falque2009 estimate
#' that about 15% of crossovers (6% to 23% depending on the chromosome) come from a
#' non-interfering pathway and the rest from an interfering one. The simulated
#' block-length distribution therefore has a longer tail than under interference;
#' the size of that difference was not measured here. Mean block lengths and
#' allele frequencies are unaffected, because the map length fixes the mean
#' number of crossovers.
#' 
#' **P5. Segregation distortion by rejection sampling,** therefore exact rather
#' than approximate. Two mechanisms: *gametophytic* (of the Ga1 type, a
#' unilateral cross-incompatibility system whose Ga1 gene acts through male
#' function [@zhang2018]) acting only on the male gamete, and *zygotic* (hybrid
#' lethality or subvitality) as genotype fitnesses. Because rejection acts on the
#' **whole gamete**, the region linked to the distorter is dragged along -- which
#' is exactly the phenomenon of interest. Distortion is common in maize mapping
#' populations: 17% of 1,820 markers across four populations, and 36% in B73/Mo17,
#' with three known gametophytic factors as possible causes [@lu2002]. The three
#' distorters below, their positions and their strengths are model inputs. All
#' three act against P2 ancestry (P1 transmission above 0.5 at the two gametic
#' loci, a reduced P2P2 fitness at the zygotic one). The bin numbers in `label`
#' are placeholders, not mapped positions of the named loci.
#' 
## -----------------------------------------------------------------------------
f2_distorters
g <- f2_distorters$type == "gametic"
stopifnot(all(f2_distorters$k[g] > 0.5),
          all(f2_distorters$w11[!g] < f2_distorters$w00[!g]))

#' 
#' ::: {.callout-warning}
#' ## The distorters are plausible, not measured
#' 
#' In the grid of @sec-sizing-results this is the input whose effect on diversity
#' more plants barely reduce inside the range tested (the distortion gap of @fig-sizing-diversity). Replace `f2_distorters` with
#' your own F2 genotyping data before using any number here to decide field area.
#' :::
#' 
#' **P6. Five schemes,** all ending with $H = 0.125$ so they are directly
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
#' **P7. The F4 panel is not a RIL panel.** Residual heterozygosity is
#' $H = 0.125$, and that changes every theoretical expectation
#' (@tbl-sizing-f4-identities). The last row of the table counts junctions in the sense of @fisher1954: $A_t$ junctions per haplotype in
#' generation $t$, $L$ the map length in Morgans, $H_t$ the heterozygosity of the
#' parent whose meiosis produces generation $t + 1$.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-f4-identities
#| tbl-cap: "Theoretical identities for an F4 panel ($H$ = 0.125), $N$ lines per panel, no distortion. Column $c$: the F4 coefficient; column Value in F4: the quantity written with that $c$. The commonly quoted $0.5/\\sqrt{N}$ for SE($\\hat p$) holds only at F$_\\infty$ ($H$ = 0). Junction coefficient from `expected_junctions()` on the 2 cM map of P3, in units of $L$ (Morgans)."
#| echo: false
H <- 0.125
A_F4 <- expected_junctions("ssd", map)[["junctions"]] / (map$total_cM / 100)
knitr::kable(data.frame(
  Quantity = c("Var(dosage per line)", "SE(p_hat)", "Diversity retained D",
               "P(P2 homozygote per locus)", "Junctions per haplotype"),
  Formula = c("(1 - H) / 4", "0.5 sqrt((1 - H) / N)", "1 - (1 - H) / N",
              "(1 - H) / 2", "A_2 = L; A_(t+1) = A_t + L H_t"),
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
#' with $H$ = 0.125 the F4 heterozygosity of P7 and the expectation taken over
#' replicate populations. @sec-sizing-verify checks it by simulation.
#' 
#' **P8. The standard error is estimated between replicates,** not between markers.
#' This is essential: linked markers are strongly autocorrelated, so the spread
#' across markers within one replicate is not an estimator of sampling error.
#' 
#' **P9. What is not modelled,** and therefore cannot be answered here: deliberate
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
#| tbl-cap: "Mean per-plant heterozygosity, F1 to F4, in one live lineage of 400 plants (10 cM map, distortion off, seed 4); se is the standard error between plants; H_expected is $(1/2)^{t-1}$ for generation F$_t$."
map10 <- build_map(maize_chr_len, spacing_cM = 10)
neutral <- make_distortion(map10, NULL, active = FALSE)

set.seed(4)  # one draw: a single F1 -> F4 lineage of 400 plants
F1 <- make_F1(map10, 400)
F2 <- cross_indices(F1, 1:400, 1:400, map10, neutral)
F3 <- cross_indices(F2, 1:400, 1:400, map10, neutral)
F4 <- cross_indices(F3, 1:400, 1:400, map10, neutral)

het_chk <- do.call(rbind, lapply(list(F1, F2, F3, F4), function(P) {
  h <- colMeans(P$H1 != P$H2)          # per-plant heterozygosity
  c(H_observed = mean(h), se = stats::sd(h) / sqrt(length(h)))
}))
het_chk <- data.frame(generation = c("F1", "F2", "F3", "F4"), het_chk,
                      H_expected = c(1, 0.5, 0.25, 0.125))
# tolerance: 4 standard errors between plants (the F1 has none)
stopifnot(all(abs(het_chk$H_observed - het_chk$H_expected) <=
              pmax(4 * het_chk$se, 1e-12)))
knitr::kable(fmt(het_chk, 4))

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
#' Map expansion is an algebraic prediction, and the payoff is a result many
#' programmes get wrong (@tbl-sizing-expected-junctions):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-expected-junctions
#| tbl-cap: "Expected junctions per haplotype and the corresponding mean block length after SSD, Syn1 and Syn2, from the recursion of @tbl-sizing-f4-identities (`expected_junctions()`, 2 cM map of P3, no distortion)."
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
#| tbl-cap: "Junctions per haplotype, recursion against the cached grid (`regenerate.R f2size`, 2 cM map, distortion active). replicates: populations pooled over all grid $N$; expected: `expected_junctions()` (SSD recursion for ssd, ssd_attr and bulk); simulated: replicate-weighted mean of `junctions_per_hap()`; deficit_pct: 100 (simulated / expected - 1), in %."
jd <- do.call(rbind, lapply(unique(f2$scheme), function(s) {
  d <- f2[f2$scheme == s, ]
  e <- expected_junctions(if (s %in% c("syn1", "syn2")) s else "ssd",
                          map)[["junctions"]]
  o <- stats::weighted.mean(d$junc, d$n_rep)
  data.frame(scheme = s, replicates = sum(d$n_rep), expected = e,
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
#' cycles. This is the known bias of P9, and it is larger than the single-meiosis
#' Haldane deficit at 2 cM, $r/d - 1$ =
#' `r fmt(100 * (0.5 * (1 - exp(-0.04)) / 0.02 - 1), 1)`%. The inference is that
#' the deficit grows with the number of junctions accumulated before the count,
#' because junctions laid down by different meioses inside one interval also
#' cancel; the cached grid supports it only through the ordering SSD, Syn1, Syn2,
#' not through a separate test. The bulk departs further than SSD, and the
#' recursion does not model selection on ancestry, so its row is not a test of the
#' recursion.
#' 
#' A finer map reduces the deficit but does not remove it at 1 cM. The chunk below
#' measures it on neutral SSD panels of 500 lines, all lines counted
#' (@tbl-sizing-verify-spacing):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-verify-spacing
#| tbl-cap: "Junction-count deficit against `expected_junctions()` at 2 cM and 1 cM marker spacing, one live neutral SSD panel of 500 lines per spacing (seed 11). deficit_pct and se_pct in %; se_pct is the standard error between lines, scaled by the expected count."
spacing_chk <- do.call(rbind, lapply(c(2, 1), function(sp) {
  m  <- build_map(maize_chr_len, spacing_cM = sp)
  nn <- make_distortion(m, NULL, active = FALSE)
  set.seed(11)
  pop <- run_scheme("ssd", 500, m, nn, f2_opt)
  per_line <- vapply(seq_len(ncol(pop$H1)), function(i)
    junctions_per_hap(list(H1 = pop$H1[, i, drop = FALSE],
                           H2 = pop$H2[, i, drop = FALSE]), m), numeric(1))
  e <- expected_junctions("ssd", m)[["junctions"]]
  data.frame(spacing_cM = sp, deficit_pct = 100 * (mean(per_line) / e - 1),
             se_pct = 100 * stats::sd(per_line) / sqrt(length(per_line)) / e)
}))
knitr::kable(fmt(spacing_chk, 2))

#' 
#' At 1 cM the deficit is
#' `r fmt(spacing_chk$deficit_pct[spacing_chk$spacing_cM == 1], 1)`%
#' (standard error `r fmt(spacing_chk$se_pct[spacing_chk$spacing_cM == 1], 1)`%,
#' between lines, one panel), against
#' `r fmt(spacing_chk$deficit_pct[spacing_chk$spacing_cM == 2], 1)`% at 2 cM on the
#' same design. A count unbiased to within that standard error needs a spacing
#' finer than 1 cM; which spacing achieves it was not measured.
#' 
## -----------------------------------------------------------------------------
#| include: false
sp2 <- spacing_chk[spacing_chk$spacing_cM == 2, ]
sp1 <- spacing_chk[spacing_chk$spacing_cM == 1, ]
z_sp2_grid <- (sp2$deficit_pct - jd$deficit_pct[jd$scheme == "ssd"]) / sp2$se_pct
se_sp_diff <- sqrt(sp2$se_pct^2 + sp1$se_pct^2)

#' 
#' The two 2 cM estimates of the SSD deficit do not coincide: the live panel gives
#' `r fmt(sp2$deficit_pct, 1)`% and the grid row of @tbl-sizing-verify-junctions
#' `r fmt(jd$deficit_pct[jd$scheme == "ssd"], 1)`%, a difference of
#' `r fmt(z_sp2_grid, 1)` panel standard errors. The grid pools
#' `r jd$replicates[jd$scheme == "ssd"]` replicates of 20 lines, but with
#' distortion active; the panel is neutral but a single draw of 500 lines. These
#' data do not separate panel sampling error from an effect of distortion on the
#' count. The inference is that the 2 cM against 1 cM contrast from two single
#' panels,
#' `r fmt(sp1$deficit_pct - sp2$deficit_pct, 1)` percentage points (s.e.
#' `r fmt(se_sp_diff, 1)`), is imprecise; neither panel was replicated, and the
#' effect of distortion on the grid count was not measured separately.
#' 
#' ## The results {#sec-sizing-results}
#' 
#' The full grid -- five schemes, `r length(unique(f2$N))` population sizes,
#' adaptive replication -- takes several minutes and is shipped precomputed.
#' @tbl-sizing-ssd-grid gives its SSD rows at ten of those sizes.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-ssd-grid
#| tbl-cap: "SSD, the reference scheme without selection, at ten of the twenty grid sizes $N$ (F2 plants); cached grid (`regenerate.R f2size`, 2 cM map, distortion active, seed 20260828). Column replicates: independent F1-to-F4 populations per $N$ (40 at $N \\leq$ 50, falling to 10 from $N$ = 210). Every other column is a mean over those replicates; s.d.($D$) is between replicates; skewed genome is the percentage of markers with $\\lvert p - 0.5 \\rvert > 0.15$ (`skew_fraction()`); $p$ is the P1 ancestry frequency."
#| echo: false
ssd <- f2[f2$scheme == "ssd", ]
sel <- ssd[ssd$N %in% c(10, 30, 50, 70, 90, 110, 150, 190, 290, 390), ]
knitr::kable(data.frame(
  N = sel$N,
  replicates = sel$n_rep,
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
#| fig-cap: "Diversity retained $D$ (dimensionless, 1 = no loss) in the F4 panel against the number of F2 plants $N$, for the five schemes of P6 (bulk at $\\beta$ = 6, attrition 15%). Each point is the mean over 10 to 40 replicate populations (more at small $N$; counts per $N$ for SSD in @tbl-sizing-ssd-grid); no error bars are drawn. Cached grid (`regenerate.R f2size`, 2 cM map, distortion active, seed 20260828). Dashed: the distortion-free expectation @eq-sizing-div, $H$ = 0.125."
#| fig-alt: "Line chart of diversity retained, from about 0.9 to 1, against number of F2 plants from 10 to 390, one line per scheme (ssd, ssd_attr, bulk, syn1, syn2) and a dashed distortion-free curve lying above them; the bulk line is lowest."
schemes <- unique(f2$scheme)
# scheme colours: neutral, distinct from the pool A/B colours of book_pal
cols <- c(ssd = book_pal[["ink"]], ssd_attr = book_pal[["mid"]],
          bulk = "#762a83", syn1 = "#1b7837", syn2 = "#7fbf7b")
plot(NA, xlim = range(f2$N), ylim = c(0.88, 1.0),
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
#' `r sprintf("%.5f", 100 * gap_slope)` per 100 plants (unweighted). Weighted by
#' the inverse sampling variance of each replicate mean ($n_{rep}/s^2$, with $s$
#' the between-replicate s.d. of $D$), the slope is
#' `r sprintf("%.5f", 100 * gap_b)` per 100 plants, s.e.
#' `r sprintf("%.5f", 100 * gap_bse)` (from those variances), so
#' `r fmt(gap_b / gap_bse, 1)` standard errors from zero. Over the whole grid
#' that slope amounts to `r fmt(gap_b * (Nmax - min(ssd$N)), 4)` against a mean
#' gap of `r fmt(mean(gap), 4)`. No limit of $D$ as
#' $N \to \infty$ was computed; the grid stops at `r Nmax`.
#' 
#' The interpretation is that the gap is **segregation distortion**, the only
#' departure from the neutral model in SSD, and that it is a bias which more
#' plants barely reduce inside the range tested: the weighted slope is at the
#' margin of detection and, taken at face value, removes a small fraction of the
#' gap across the whole grid. Adding plants buys drift protection, and little
#' distortion protection. How the gap behaves beyond $N$ = `r Nmax` was not
#' measured.
#' 
#' @fig-sizing-ancestry shows the same separation along the genome, on two live
#' panels (4 cM map, distortion active, one population each).
#' 
## -----------------------------------------------------------------------------
#| label: fig-sizing-ancestry
#| fig-cap: "Frequency of P1 ancestry at each marker, ordered along chromosomes 1 to 10 (grey verticals: chromosome boundaries), in one SSD F4 panel from $N$ = 20 F2 plants and one from $N$ = 300; a single population each, simulated live (4 cM map, distortion active, seeds 6 and 7), so no error band. Dashed: 0.5, the neutral expectation. At $N$ = 20 the whole curve is noisy: that is drift, and more plants reduce it. At $N$ = 300 the departures from 0.5 that remain sit at the three distorters (dotted red lines): the deterministic bias."
#| fig-alt: "P1 ancestry frequency along the ten chromosomes, at N = 20 and N = 300, with the three distorter positions marked"
map4 <- build_map(maize_chr_len, spacing_cM = 4)
dist <- make_distortion(map4, f2_distorters)
set.seed(6)
small <- panel_freq(run_scheme("ssd", 20,  map4, dist, f2_opt))
set.seed(7)
large <- panel_freq(run_scheme("ssd", 300, map4, dist, f2_opt))

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
#' @tbl-sizing-bulk-vs-ssd sets the bulk at the largest $N$ against SSD at 30
#' plants.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-bulk-vs-ssd
#| tbl-cap: "Diversity retained $D$, mean over replicate populations of the cached grid (`regenerate.R f2size`, 2 cM map, distortion active): the bulk ($\\beta$ = 6) at the largest grid $N$ against SSD at $N$ = 30 F2 plants."
#| echo: false
b_max <- f2$div[f2$scheme == "bulk" & f2$N == max(f2$N)]
s30   <- f2$div[f2$scheme == "ssd"  & f2$N == 30]
lowest <- tapply(seq_len(nrow(f2)), f2$N,
                 function(i) f2$scheme[i][which.min(f2$div[i])])
bulk_lowest_all <- all(lowest == "bulk")
knitr::kable(data.frame(comparison = c("bulk, largest N", "SSD, N = 30"),
                        N = c(max(f2$N), 30),
                        D = fmt(c(b_max, s30), 3)))

#' 
#' The bulk has the lowest mean $D$ of the five schemes at
#' `r sum(lowest == "bulk")` of the `r length(lowest)` grid values of $N$, and at
#' the largest $N$ it retains less diversity than SSD at 30 plants. Both results
#' follow from a model input: `bulk_weights()` raises the seed contribution of
#' plants with more P1 ancestry, with $\beta$ = `r f2_opt$beta_bulk`, so the loss
#' of P2 ancestry is built into the scheme, and its size depends on $\beta$, which
#' was not varied here. The comparison with SSD at $N$ = 30 holds at this $\beta$
#' only. If P2 is the donor whose germplasm the cross was made to introduce, and
#' natural selection in the bulk favours P1 ancestry as this model assumes, the
#' bulk is not a cheaper SSD -- it is a different experiment.
#' 
#' ### Block length does not depend on N in the grid
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
#' `r sprintf("%.3f", blk$junc_slope_per_100[blk$scheme == "ssd"])` junctions per 100 plants
#' (s.e. `r sprintf("%.3f", blk$slope_se_per_100[blk$scheme == "ssd"])`). One and two
#' intercrossing cycles shorten the blocks to about
#' `r fmt(mean(c(blk$block_min_cM[blk$scheme == "syn1"], blk$block_max_cM[blk$scheme == "syn1"])), 1)`
#' and
#' `r fmt(mean(c(blk$block_min_cM[blk$scheme == "syn2"], blk$block_max_cM[blk$scheme == "syn2"])), 1)`
#' cM. The counts carry the junction deficit measured in @sec-sizing-verify, so
#' the absolute lengths are too long by about the size of that deficit; the comparison across $N$ and
#' across schemes is what the table supports.
#' 
#' Within this grid, block length is set by the number of meioses, not by $N$.
#' Against linkage drag the instrument is therefore an **intercrossing cycle, not
#' field area** -- which is what the Syn rows of @tbl-sizing-expected-junctions quantify.
#' 
#' ### The metrics saturate at different N
#' 
#' This is the central practical result, and the reason the question "what is the
#' optimal $N$?" has no single answer (@tbl-sizing-saturation). To make "saturates" checkable it is defined
#' on the grid: for $D$ and for the worst region $\min(p, 1-p)$, $N_{90}$ is the
#' smallest grid $N$ whose replicate mean has reached 90% of the gain from the
#' smallest to the largest $N$ tested. The definition is relative to the grid's
#' upper end (`r max(f2$N)`), so a longer grid would move it. The replicate means
#' carry sampling error, and so does the threshold, which is built from the two
#' end means; the table therefore also gives a two-standard-error bracket: the
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
#' with $(1 - H)/2$ the probability that an F4 line is P2P2 at one locus (P7) and
#' the $k$ loci on different chromosomes.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-saturation
#| tbl-cap: "Different objectives, different answers. $D$, $\\min(p, 1-p)$ and SE($\\hat p$): SSD replicate means of the cached grid (`regenerate.R f2size`, 2 cM map, distortion active, $N$ = 10 to 390 F2 plants). $N_{90}$: smallest grid $N$ whose replicate mean reaches 90% of the gain from the smallest to the largest grid $N$. 2-s.e. bracket: last grid $N$ with (mean - threshold) below -2 s.e. and first with it above +2 s.e., s.e. combining the standard error of the mean at that $N$ (between-replicate s.d. / $\\sqrt{n_{rep}}$) and that of the threshold. Recovery of $k$ loci: one simulated population per $N$ (replicate 1 of the grid), 300 random locus sets, criterion $P \\geq$ 0.95; the closed form is @eq-sizing-n95."
n90 <- function(N, y) {
  thr <- y[1] + 0.9 * (y[length(y)] - y[1])
  N[which(y >= thr)[1]]
}
# 2-s.e. bracket of the crossing; se = between-replicate sd / sqrt(n_rep)
n90_bracket <- function(N, y, se) {
  n   <- length(y)
  thr <- y[1] + 0.9 * (y[n] - y[1])
  z   <- (y - thr) / sqrt(se^2 + 0.01 * se[1]^2 + 0.81 * se[n]^2)
  lo  <- N[max(which(z < -2 & N < n90(N, y)))]
  hi  <- N[min(which(z > 2 & N >= n90(N, y)))]
  c(lo = lo, hi = hi)
}
br_D    <- n90_bracket(ssd$N, ssd$div,  ssd$div_sd  / sqrt(ssd$n_rep))
br_pmin <- n90_bracket(ssd$N, ssd$pmin, ssd$pmin_sd / sqrt(ssd$n_rep))
pmin_prev <- ssd$N[which(ssd$N == n90(ssd$N, ssd$pmin)) - 1]  # grid N before the crossing
Ngrid <- sort(unique(ml$N))
n95_grid_k3 <- min(Ngrid[1 - (1 - (0.875 / 2)^3)^Ngrid >= 0.95])
n95_closed <- function(k, H = 0.125) log(0.05) / log(1 - ((1 - H) / 2)^k)
kk <- sort(unique(ml$k))
ml_first95 <- vapply(kk, function(k) {
  d <- ml[ml$k == k, ]; d <- d[order(d$N), ]
  if (any(d$P >= 0.95)) d$N[which(d$P >= 0.95)[1]] else NA_real_
}, numeric(1))
ml_Pmax <- vapply(kk, function(k) ml$P[ml$k == k & ml$N == max(ml$N)], numeric(1))

# closed form against a neutral simulation, k = 5, N = 110 (10 cM map)
set.seed(8)
P_pops <- replicate(20, multilocus_recovery(
  run_scheme("ssd", 110, map10, neutral, f2_opt), map10, 5))
P_neutral <- mean(P_pops)
P_se      <- stats::sd(P_pops) / sqrt(length(P_pops))
P_closed  <- 1 - (1 - (0.875 / 2)^5)^110
stopifnot(abs(P_neutral - P_closed) < 4 * P_se)  # 4 s.e. between populations
ml_below <- ml$P < 1 - (1 - (0.875 / 2)^ml$k)^ml$N

sat <- data.frame(
  Objective = c("Diversity retained (D)",
                "Worst region of the genome, min(p, 1-p)",
                "Precision of the panel's p_hat",
                paste0("Recovery of ", kk, " loci")),
  Criterion = c("N90", "N90", "none: SE falls as N^(-1/2)",
                rep("P >= 0.95", length(kk))),
  `Grid N reaching it` = c(n90(ssd$N, ssd$div), n90(ssd$N, ssd$pmin), "--",
                           ifelse(is.na(ml_first95), "not reached",
                                  ml_first95)),
  `2-s.e. bracket` = c(paste(br_D, collapse = " to "),
                       paste(br_pmin, collapse = " to "), "--",
                       rep("--", length(kk))),
  `Value at largest N` = c(fmt(ssd$div[ssd$N == Nmax], 4),
                           fmt(ssd$pmin[ssd$N == Nmax], 3),
                           fmt(ssd$se_p[ssd$N == Nmax], 4),
                           fmt(ml_Pmax, 3)),
  `Closed form N95, no distortion` = c("--", "--", "--",
                                       round(n95_closed(kk))),
  check.names = FALSE)
knitr::kable(sat)

#' 
#' The closed form @eq-sizing-n95 was checked against a neutral simulation at $k$ = 5, $N$ = 110:
#' `r fmt(P_neutral, 3)` (s.e. `r fmt(P_se, 3)` between the 20 populations)
#' against `r fmt(P_closed, 3)`; the chunk asserts agreement within four such
#' standard errors. With
#' distortion, the simulated recovery for $k \geq 5$ lies below the closed form at
#' `r sum(ml_below[ml$k >= 5])` of `r sum(ml$k >= 5)` grid points. For $k = 3$, at
#' $N$ = `r min(ml$N)` the simulated value is `r fmt(ml$P[ml$k == 3 & ml$N == min(ml$N)], 3)`
#' and the closed form `r fmt(1 - (1 - (0.875 / 2)^3)^min(ml$N), 3)`; the simulated
#' curve first reaches 0.95 at grid $N$ = `r ml_first95[kk == 3]`, the closed form at
#' grid $N$ = `r n95_grid_k3`.
#' 
#' The inference is that distortion against P2,
#' which all three distorters exert, lowers the per-locus probability of a P2P2
#' line, so the closed-form $N_{95}$ is expected to understate what the simulated
#' cross needs; this was not shown beyond the grid. For $k \geq 8$ the closed form
#' already lies far outside the grid, and no grid $N$ reaches the target. The recovery rows rest on one population per
#' $N$, so their crossing points carry the between-population variance that the
#' replicated rows average out; the curves in @fig-sizing-multilocus are visibly
#' non-monotone for that reason.
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
#| fig-cap: "Multilocus recovery: probability that at least one F4 line is homozygous for P2 at $k$ unlinked loci ($k$ = 3, 5, 8, 10), against the number of F2 plants $N$; SSD, distortion active, 2 cM map. **One** simulated population per $N$ (replicate 1 of the cached grid, `regenerate.R f2size`, seed 20260828), so there are no replicates and no error bars: each point is a proportion over 300 random locus sets drawn in that one population, and the point-to-point wiggle is between-population variance, not signal."
#| fig-alt: "Line chart of the probability of recovering a P2 homozygote at k loci against number of F2 plants from 10 to 390, one line for each of k = 3, 5, 8 and 10; k = 3 rises from about 0.7 to 1, k = 5 approaches 1, k = 8 stays below 0.4 and k = 10 below 0.1, and the lines are not monotone."
stopifnot(isTRUE(all.equal(kk, c(3, 5, 8, 10))))  # k values hard-coded in the caption
# k colours: neutral grey ramp, distinct from the pool A/B colours of book_pal
cols_k <- grey(seq(0, 0.6, length.out = length(kk)))
plot(NA, xlim = range(ml$N), ylim = c(0, 1), xlab = expression(N[F2]~"plants"),
     ylab = "P(at least one line P2P2 at all k loci)")
grid()
for (i in seq_along(kk)) {
  d <- ml[ml$k == kk[i], ]
  lines(d$N, d$P, type = "b", pch = 14 + i, cex = 0.6, col = cols_k[i], lwd = 1.8)
}
legend("topright", paste("k =", kk), col = cols_k, lwd = 1.8,
       pch = 14 + seq_along(kk), bty = "n")

#' 
#' The marginal gain in $D$ tells the same story from the other side. The standard
#' error of each step combines the two replicate means (@tbl-sizing-steps):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-steps
#| tbl-cap: "Gain in mean $D$ between consecutive grid sizes, SSD, cached grid (`regenerate.R f2size`, 2 cM map, distortion active). se: standard error of the difference of the two replicate means, $\\sqrt{s_1^2/n_1 + s_2^2/n_2}$ with $s$ the between-replicate s.d. of $D$ and $n$ the replicate count at each size."
#| echo: false
steps <- data.frame(
  step = paste0(utils::head(ssd$N, -1), " -> ", ssd$N[-1]),
  gain_in_D = diff(ssd$div),
  se = sqrt(utils::head(ssd$div_sd^2 / ssd$n_rep, -1) +
            ssd$div_sd[-1]^2 / ssd$n_rep[-1]))
N90_D <- n90(ssd$N, ssd$div)
past  <- steps[ssd$N[-nrow(ssd)] >= N90_D, ]
knitr::kable(fmt(steps, 4))

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
#' That is not the number of loci lost. Under the biallelic assumption of P1, a
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
#| tbl-cap: "Expected parental alleles lost (`f1_sizing()`: heterozygous (parent, locus) pairs at which one allele reaches no F1 plant) and expected loci made monomorphic (biallelic loci, computed in the chunk), against the number $n$ of selfed F1 plants, at the scenario values $h_{res}$ = 0.05 and $n_{loc}$ = 5000 independent loci; rows shown at selected $n$, including both thresholds and the sizes below them."
s <- f1_sizing(n_F1 = 1:20, h_res = h_res, n_loci_eff = n_loc)
lost_col <- grep("lost", names(s), value = TRUE)   # alleles lost, per f1_sizing()
stopifnot(length(lost_col) == 1,
          isTRUE(all.equal(s[[lost_col]], 2 * h_res * n_loc * 2 * 0.5^s$n_F1)))
s$expected_loci_monomorphic <- n_loc * (2 * h_res * (1 - h_res) * 0.5^s$n_F1 +
                                        h_res^2 * 2 * 0.25^s$n_F1)
n_f1     <- min(s$n_F1[s[[lost_col]] < 1])
n_f1_loc <- min(s$n_F1[s$expected_loci_monomorphic < 1])
knitr::kable(fmt(s[s$n_F1 %in% sort(unique(c(4, n_f1_loc - 1, n_f1_loc, n_f1,
                                             12, 16, 20))), ], 4),
             row.names = FALSE)

#' 
#' `r n_f1` selfed F1 plants is the smallest number that puts the expected number
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
#| tbl-cap: "Working numbers for a wide cross, read off the SSD rows of the cached grid ($N$ = 10 to 390 F2 plants, 2 cM map, distortion active) and `f1_sizing()` at the scenario values $h_{res}$ = 0.05, $n_{loc}$ = 5000. Size for the objective that binds, not for $D$: $N_{90}$ for $D$ is a grid-relative reference point, not a recommended F2 size. P(recovery) values come from one simulated population per $N$ (replicate 1 of the grid), with no replicate error."
#| echo: false
stopifnot(h_res == 0.05, n_loc == 5000)  # values hard-coded in the caption
F_F3 <- 1 - 0.25                     # inbreeding of an F3 plant, F1 as base
P_k  <- setNames(ml_Pmax, kk)
k_hit <- max(kk[!is.na(ml_first95)])  # largest k reaching P >= 0.95 on the grid
knitr::kable(data.frame(
  Generation = c("F1", "F2", "", "", "F3", "F4"),
  Plants = c(paste0(n_f1, " selfed, minimum"),
             paste0(ml_first95[kk == k_hit], " if the binding objective is recovery at k = ",
                    k_hit),
             paste0("not reached at N <= ", Nmax,
                    " for recovery at k >= 8; set by the precision required for p_hat"),
             paste0("N90 for D = ", N90_D, ": a reference point, not a size"),
             "same N (SSD, one seed per plant)",
             "lines x plants per line set by seed need"),
  Rationale = c(
    paste0("Ne = 1 with homozygous parents, a logistical call. With h_res = ",
           h_res, " in both parents, ", n_f1,
           " plants put expected parental alleles lost below 1 (",
           n_f1_loc, " put expected loci made monomorphic below 1)"),
    paste0("First grid N with P(recovery) >= 0.95 at k = ", k_hit,
           ", one population per N; the curve is not monotone"),
    paste0("At N = ", Nmax, ", one population: P(recovery) = ",
           fmt(P_k[["8"]], 3), " (k = 8), ",
           fmt(P_k[["10"]], 3), " (k = 10); SE(p_hat) = ",
           fmt(ssd$se_p[ssd$N == Nmax], 4), ", still falling as N^(-1/2)"),
    paste0("Grid-relative (2-s.e. bracket ", br_D[["lo"]], " to ", br_D[["hi"]],
           "). From N90 to N = ", Nmax, ", +", Nmax - N90_D, " plants buy +",
           fmt(ssd$div[ssd$N == Nmax] - ssd$div[ssd$N == N90_D], 4), " of D"),
    "Does not create diversity, only avoids losing it",
    paste0("Seed multiplication. Plants of the same line are not independent ",
           "replicates: their coancestry is (1 + F_F3)/2 = ",
           (1 + F_F3) / 2, " with the F1 as base")),
  check.names = FALSE))

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
#' ## Where this connects
#' 
#' The panel this chapter sizes is the raw material for everything else, and the
#' claim that its diversity is a *ceiling* should be measured rather than asserted.
#' The rest of the book works on one kernel -- molecular coancestry $f$ and
#' gene diversity $GD = 1 - \theta$ (@sec-coancestry). The F4 panel can be pushed straight into it (@tbl-sizing-bridge):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sizing-bridge
#| tbl-cap: "One live SSD F4 panel per $N$ F2 plants (column n_F2; 10 cM map, distortion active, seed 3 + $N$): diversity retained $D$, mean molecular coancestry $\\theta$ over all pairs of lines with self included, $GD = 1 - \\theta$ and $N_s = 1/(2\\theta)$, frequency base the panel itself."
map_br  <- build_map(spacing_cM = 10)
dist_br <- make_distortion(map_br, active = TRUE)

bridge <- do.call(rbind, lapply(c(30, 120, 480), function(n) {
  set.seed(3 + n)
  pop <- run_scheme("ssd", n, map_br, dist_br, opt = f2_opt)
  X   <- t((pop$H1 + pop$H2) / 2)          # lines x markers, 0/0.5/1
  th  <- mean(molecular_coancestry(X))     # all pairs, self included
  data.frame(n_F2 = n, D = diversity_retained(panel_freq(pop)),
             theta = th, GD = 1 - th, Ns = 1 / (2 * th))
}))
stopifnot(isTRUE(all.equal(bridge$GD, bridge$D / 2)),
          isTRUE(all.equal(bridge$Ns, 1 / (2 - bridge$D))))
knitr::kable(fmt(bridge, 4))

#' 
#' $D$, the chapter's own diversity-retained statistic, and $GD$, the quantity
#' every later chapter constrains, are the same quantity up to a factor:
#' $GD = D/2$ exactly, asserted in the chunk. With the 0/0.5/1 coding and
#' $\theta$ the mean of the molecular coancestry over all pairs of lines, self
#' included [@caballero2002], $\theta$ averages $p^2 + (1-p)^2$ over markers, so
#' $GD = 1 - \theta$ is the mean of $2p(1-p)$, which is $D/2$ because $D$ divides
#' the same mean by its maximum 0.5. The frequency base is the F4 panel itself.
#' The sizing decision made here therefore sets the $GD$ that
#' @sec-choosing, @sec-ocs and @sec-combinatorial spend the rest of the book
#' budgeting, and it sets it *once*. An optimiser cannot select back up to variation
#' the panel never sampled; the best it can do is spend what is left more slowly.
#' 
#' ::: {.callout-note}
#' ## $N_s$ is not informative inside a biparental cross
#' 
#' The status number on these panels is $N_s = 1/(2\theta) = 1/(2 - D)$, between
#' `r fmt(min(bridge$Ns), 3)` and `r fmt(max(bridge$Ns), 3)` in @tbl-sizing-bridge
#' whatever the sizing, and bounded above by 1 because $D \leq 1$. That is correct
#' rather than broken. Every line descends from two
#' parents, so the panel has the genetic base of a single diploid individual, which
#' is exactly what $N_s = 1/(2\theta)$ reports. @sec-ns warns that $N_s$ describes a
#' base rather than projecting drift; here the base is genuinely one cross.
#' 
#' Use $D$ and $GD$ to compare sizing scenarios within a cross, and $N_s$ only once
#' material from several crosses has been pooled.
#' :::
#' 
#' @sec-stages puts a number on how the loss is distributed across the whole
#' pipeline, and this stage is where the cheapest insurance is available -- more
#' plants, once, at the start. @sec-limits is where the same argument is made about
#' the *variance* rather than the frequencies, and reaches a different conclusion
#' about what is recoverable.
