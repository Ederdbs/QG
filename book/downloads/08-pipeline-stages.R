#' # Metrics at each pipeline stage, and five traps {#sec-stages}
#' 
# 08-pipeline-stages -- standalone script of the chapter 08-pipeline-stages.qmd
# Book: https://ederdbs.github.io/QG/08-pipeline-stages.html
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
fstd <- read.csv(book_data("fst_definitions.csv"))
dvv  <- read.csv(book_data("dist_vs_variance.csv"))
led  <- read.csv(book_data("pipeline_loss_ledger.csv"))
ff   <- function(x, d = 2) sprintf("%.*f", d, x)   # scalar for inline prose
# named vector -> two-column table; each value formatted on its own (no common
# scientific format, so that a deviation of 1e-16 is not shown as 0)
vtab <- function(v, digits = 6)
  knitr::kable(data.frame(quantity = names(v),
                          value = vapply(v, format, "", digits = digits)),
               row.names = FALSE)

#' 
#' The previous chapters established *which* metrics to use. This one places them
#' at the four stages S1-S4 of a hybrid maize programme (@tbl-hp-stages of
#' @sec-hp-cycle: S1 conserving the heterotic groups, S2 choosing parents and
#' crosses for doubled-haploid (DH) induction, S3 selecting lines per se, S4 hybrid mining), and names
#' five traps -- each one a thing that looks correct, returns a number, and is
#' wrong.
#' 
#' Three rules govern everything below.
#' 
#' - **Identities.** An exact algebraic identity is asserted with `stopifnot()` in
#'   the chunk that shows it, to the tolerance stated there, so that the render
#'   stops if it stops being true. An identity shown without such an assertion is
#'   not claimed as verified.
#' - **The metric set** is the recommendation of @sec-choosing: molecular
#'   coancestry as the kernel, gene diversity $GD = 1 - \theta$ as the scale, proportional loss
#'   $\alpha$ against a same-size resampling baseline and the effective number of
#'   parents $N_{e,\text{par}}$ as the second constraint inside the optimiser; $N_s$ only as a rescaling of $\theta$
#'   (a value in $[1/2, 1]$ on molecular coancestry, not a head count,
#'   @sec-ns); allelic richness as one of several metrics that vary at fixed
#'   $\theta$, to be read on the returned plan. This chapter uses $\theta$, $GD$ and
#'   the same-size baseline at every stage, $N_{e,\text{par}}$ at S4 and in the
#'   ledger, and allelic richness only as the ledger's `alleles` column.
#' - **Assumptions**, declared once. Parents are inbred or doubled-haploid lines
#'   coded 0/1 at biallelic markers (A2 of @sec-era-programme), so $\mathbf{f}$ is
#'   identity in state with no base population. The simulated merit is additive in
#'   the marker effects (no dominance). The simulation parameter `fst` is the
#'   Balding-Nichols parameter [@balding1995], written $F_{BN}$ throughout (@sec-notation), a
#'   neutral divergence of each pool from one ancestral population; $F_{ST}$ is
#'   reserved for the statistic of Trap 2 (@sec-stages-trap2). No frozen base population is used: every
#'   loss is measured against a random subset of the same size drawn from the set
#'   being selected from (@sec-baseline).
#' 
#' Scales differ between the chunks, and the text names them. The live chunks of S1
#' (except the Trap 3 sweep), S3 and S4 use one simulated world of 30 + 30 lines,
#' 3,000 markers and 900 hybrids; the Trap 3 sweep uses the teaching scale
#' (25 + 25 lines, 2,000 markers, @sec-era-programme). Five artefacts are **cached
#' results of an external study whose code is not in this repository**:
#' `fst_definitions.csv`, `dist_vs_variance.csv`, `pipeline_loss_ledger.csv`,
#' `metric_pitfalls.png` and `pipeline_loss.png`. They cannot be regenerated here
#' and are never called reproducible (@sec-verification lists them); what is computed
#' from the three csv files is a re-analysis of the cached file, not a
#' reproduction of the study. The scale of the Trap 2 table and the Trap 4 data is
#' unrecorded; the ledger's is given where it is used.
#' 
## -----------------------------------------------------------------------------
sim <- simulate_pools(n_A = 30, n_B = 30, m = 3000, fst = 0.15, seed = 12)
ctx <- ctx_from_pools(sim)
GL  <- sim$GL; pool <- sim$pool; fL <- sim$fL
c(lines = sim$L, markers = sim$m, hybrids = sim$N)

#' 
#' ## The kernel: one matrix, all four stages
#' 
#' Molecular coancestry $f_{ij}$ is the probability that an allele drawn at random
#' from individual $i$ is identical in state to one drawn from $j$. For inbred
#' lines coded 0/1 at $m$ biallelic markers,
#' 
#' $$f_{ij} \;=\; 1 - \frac{1}{m}\sum_{k=1}^{m}(x_{ik} - x_{jk})^2 ,$$ {#eq-stages-fij}
#' 
#' with $x_{ik} \in \{0, 1\}$ the allele of line $i$ at marker $k$ ($\mathbf{G}^L$ of
#' @sec-notation). Group coancestry of a set of $n$ lines is the mean of the full
#' submatrix **including the diagonal**, $\theta = n^{-2}\sum_i\sum_j f_{ij}$
#' (@eq-catalogue-theta), with $GD = 1 - \theta$ and $N_s = 1/(2\theta)$; on
#' molecular coancestry $\theta \in [1/2, 1]$ for a set, so $N_s$ is a monotone
#' rescaling of $\theta$ and not a number of lines (@sec-ns).
#' 
#' The diagonal is not a technicality. It is why a small set always looks highly
#' coancestral, and it is the reason the naive greedy constraint in S3 fails.
#' 
#' ### Trap 1: modified Rogers distance is the same statistic
#' 
#' Reporting both the modified Rogers distance (MRD) and coancestry as separate
#' evidence is reporting one number twice. For inbred lines coded 0/1 the distance
#' between lines is
#' $\text{MRD}_{ij} = \bigl[m^{-1}\sum_k (x_{ik} - x_{jk})^2\bigr]^{1/2}$, so
#' $f_{ij} = 1 - \text{MRD}_{ij}^2$ by definition of both (@eq-stages-fij). The check below computes
#' the distance directly from the genotypes (`dist()`), not through the package's
#' own `mrd_matrix()`:
#' 
## -----------------------------------------------------------------------------
D_direct <- as.matrix(dist(GL)) / sqrt(ncol(GL))
trap1_dev <- max(abs((1 - D_direct^2) - fL))
stopifnot(trap1_dev < 1e-12)

#' 
#' The largest absolute deviation over the $L^2$ entries is `r sprintf("%.0e", trap1_dev)`
#' (asserted below $10^{-12}$).
#' 
#' If a diversity report shows a distance tree and a coancestry table as mutual
#' corroboration, they are the same analysis in two coordinate systems. The
#' identity holds for homozygous 0/1 lines; it is not claimed for heterozygous
#' hybrids, which this chapter does not test.
#' 
#' ## S1: conserving the heterotic groups
#' 
#' Two quantities can move in opposite directions: within-pool diversity falls
#' and between-pool divergence rises. @sec-hp-cycle derives that opposition for
#' drift in two closed pools of equal weight and says that the argument does not
#' cover selection; the rise of $GD_{BS}$ under `run_cycles()` is a simulation
#' result there, with drift and selection acting together. A single pool-wide
#' statistic sees only the sum, so a programme monitoring only total diversity can
#' look stable while the two terms move apart. That is the reason to monitor them
#' separately, and it holds whatever the cause of the movement.
#' 
#' The partition is exact for any grouping of the lines into pools $p$ (here two,
#' A and B) with census weights $\varpi_p = n_p/L$, $\theta_{pq}$ the mean of $f_{ij}$
#' over $i$ in pool $p$ and $j$ in pool $q$ (@eq-gd-partition of @sec-subdivided,
#' after @caballero2002):
#' 
#' $$\theta_T \;=\; \sum_{p}\sum_{q} \varpi_p \varpi_q\,\theta_{pq}
#'  \;=\; \sum_p \varpi_p^2\,\theta_{pp} \;+\; \sum_{p \ne q} \varpi_p \varpi_q\,\theta_{pq}.$$ {#eq-stages-partition}
#' 
#' In @eq-stages-partition $\theta_T$ is the coancestry of the whole set; $\theta_w = \sum_p \varpi_p\theta_{pp}$ is
#' the census-weighted mean coancestry within pools, so $GD_{WS} = 1 - \theta_w$ (the
#' column `GD_within` of the code, $GD_{BI}$ for inbred lines); $\theta_{AB}$ is the
#' mean coancestry between the pools (called `theta_B` in `theta_decompose()`, but
#' `theta_pools()` uses that name for within-pool B; this chapter writes
#' $\theta_{AB}$). The between-pool share of gene diversity is
#' $GD_{BS} = \theta_w - \theta_T$.
#' In the symbols of @sec-subdivided, $\theta_T$ is $\bar f$ and $\theta_w$ is $\tilde f$ (@sec-notation). Here $\theta_{AB}$ is
#' census-weighted (the mean of $f_{ij}$ over the $A \times B$ line pairs), not the usage-weighted
#' $\theta_{AB}$ of @eq-catalogue-theta-pools.
#' 
## -----------------------------------------------------------------------------
d <- theta_decompose(GL, pool)
part_dev <- d[["theta_T"]] - mean(fL)
stopifnot(abs(part_dev) < 1e-12)
c(theta_T_from_partition = d[["theta_T"]],
  theta_T_direct         = mean(fL),
  deviation              = part_dev)

#' 
#' ### Trap 2: two statistics written $F_{ST}$ differ by up to a factor of two {#sec-stages-trap2}
#' 
#' Two statistics computed from the same coancestry matrix carry the symbol
#' $F_{ST}$ in different places, and they are **not interchangeable**. The $F_{ST}$
#' of this book (@sec-subdivided, @eq-f-stats; @sec-hp-inbreeding) is referenced to
#' the coancestry of the whole set:
#' 
#' $$F_{ST} \;=\; \frac{GD_{BS}}{GD_T} \;=\; \frac{\theta_w - \theta_T}{1 - \theta_T}
#'   \;=\; \frac{H_T - H_S}{H_T},$$ {#eq-stages-fst}
#' 
#' the last form being Nei's $G_{ST}$ [@nei1973] with plug-in gene diversities
#' (code column `Gst_Nei`); @caballero2002 give the partition in coancestry form.
#' The other statistic is referenced to the coancestry *between* pools:
#' 
#' $$F^{\text{btw}}_{ST} \;=\; \frac{\theta_w - \theta_{AB}}{1 - \theta_{AB}}$$ {#eq-stages-fst-btw}
#' 
#' (code column `Fst_Wright`; "Wright" is the code's label, not a claim about a
#' paper, @sec-genomic-era). @sec-subdivided cites no external source for the use of
#' this form as $F_{ST}$ and does not use it, and this chapter does not establish
#' that any published value was computed this way. It is carried here only because
#' the package's `s1_monitor()` logs it and a reader who compares two $F_{ST}$
#' values must know which one each is.
#' 
## -----------------------------------------------------------------------------
trap2 <- c(F_ST      = d[["Gst_Nei"]],
           F_ST_btw  = d[["Fst_Wright"]],
           F_ST_classical = unname(gst_nei(GL, pool)[["Gst"]]),
           ratio     = d[["Fst_Wright"]] / d[["Gst_Nei"]])
stopifnot(isTRUE(all.equal(trap2[["F_ST"]], trap2[["F_ST_classical"]],
                           tolerance = 1e-12)),
          isTRUE(all.equal(trap2[["ratio"]], 2 - trap2[["F_ST_btw"]],
                           tolerance = 1e-12)))
trap2

#' 
#' With two pools of equal weight $\varpi_A = \varpi_B = 1/2$, $\theta_T = (\theta_w +
#' \theta_{AB})/2$, which gives $F_{ST} = (\theta_w - \theta_{AB})/(2 - \theta_w -
#' \theta_{AB})$ (from @eq-stages-fst and @eq-stages-fst-btw) and therefore
#' 
#' $$\frac{F^{\text{btw}}_{ST}}{F_{ST}} \;=\; 2 - F^{\text{btw}}_{ST}
#'   \;\in\; [1, 2],$$ {#eq-stages-fst-ratio}
#' 
#' @eq-stages-fst-ratio is asserted in the chunk above. The ratio is 2 only as $F^{\text{btw}}_{ST} \to 0$ and
#' falls as divergence grows; it is exact for equal pool weights, which both the
#' live pools and (inferred from the identity holding to 4e-15 in all rows) the
#' cached table have. Across simulated divergence the two never converge (@tbl-fst-definitions):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-fst-definitions
#| echo: false
#| tbl-cap: "The two statistics across a range of the Balding-Nichols parameter $F_{BN}$ (cached `fst_definitions.csv`, external study, no generating code here; one row per setting, pool sizes, marker number and replication unrecorded). $F_{ST} = GD_{BS}/GD_T$ is the column `Gst_Nei`, $F^{\\text{btw}}_{ST}$ is `Fst_Wright`; the ratio equals $2 - F^{\\text{btw}}_{ST}$ in every row (asserted), so it falls from 1.96 to 1.59 as divergence rises."
stopifnot(max(abs(fstd[["ratio"]] - (2 - fstd[["Fst_Wright"]]))) < 1e-12)
knitr::kable(fmt(data.frame(`F_BN` = fstd[["fst_target"]],
                            `F_ST` = fstd[["Gst_Nei"]],
                            `F_ST_btw` = fstd[["Fst_Wright"]],
                            ratio = fstd[["ratio"]]), 4))

#' 
#' State which reference you used, and never compare a value against another
#' report's without knowing which reference that report used.
#' 
#' ### Trap 3: $F_{ST}$ is the wrong target to maximise
#' 
#' @sec-heterosis (@sec-heterosis-flat) shows, in expectation over Balding-Nichols
#' draws and at $d_k \equiv 1$, that expected heterosis does not depend on
#' $F_{BN}$: every unit gained in the divergence term is paid for out of the shared
#' term. What moves it is divergence landing on the dominance loci. The question
#' here is which of the frequency-side statistics of the S1 panel carry something
#' that $F_{ST}$ does not. The sweep below redraws both pools at four values of
#' $F_{BN}$, 20 seeds each (seeds 1 to 20 at every level, fixed in advance), at the
#' teaching scale (@tbl-trap3-sweep):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-trap3-sweep
#| tbl-cap: "Trap 3 sweep: mean over 20 seeds (seeds 1 to 20 at every level) of $F_{ST}$, $F^{\\text{btw}}_{ST}$ (`F_ST_btw`), $GD_{WS}$, `frac_opposite_fixed` and `mean_sq_delta_p` at four values of the Balding-Nichols parameter $F_{BN}$, with the standard deviation over seeds (`sd_` columns) of $F_{ST}$, $GD_{WS}$ and `mean_sq_delta_p`. Simulated pools of 25 + 25 lines and 2,000 markers, redrawn for every seed."
sweep_fst <- do.call(rbind, lapply(c(0.05, 0.15, 0.25, 0.40), function(fbn)
  do.call(rbind, lapply(1:20, function(sd) {
    s  <- simulate_pools(n_A = 25, n_B = 25, m = 2000, fst = fbn, seed = sd)
    dd <- theta_decompose(s[["GL"]], s[["pool"]])
    cm <- pool_complementarity(s[["GL"]], s[["pool"]])
    data.frame(F_BN = fbn, seed = sd, F_ST = dd[["Gst_Nei"]],
               F_ST_btw = dd[["Fst_Wright"]], GD_T = dd[["GD_T"]],
               GD_WS = dd[["GD_within"]],
               frac_opposite_fixed = cm[["frac_opposite_fixed"]],
               mean_sq_delta_p = cm[["mean_sq_delta_p"]])
  }))))
# identity (equal pool sizes): mean_sq_delta_p = 2 GD_BS = 2 F_ST GD_T
msdp_dev <- max(abs(sweep_fst[["mean_sq_delta_p"]] /
                      (2 * sweep_fst[["F_ST"]] * sweep_fst[["GD_T"]]) - 1))
stopifnot(msdp_dev < 1e-10)
sw_mean <- aggregate(cbind(F_ST, F_ST_btw, GD_WS, frac_opposite_fixed,
                           mean_sq_delta_p) ~ F_BN, sweep_fst, mean)
sw_sd   <- aggregate(cbind(F_ST, GD_WS, mean_sq_delta_p) ~ F_BN, sweep_fst, sd)
sw_cor  <- cor(sweep_fst[["F_ST"]], sweep_fst[["mean_sq_delta_p"]])
fmt(cbind(sw_mean, sd_F_ST = sw_sd[["F_ST"]], sd_GD_WS = sw_sd[["GD_WS"]],
          sd_msdp = sw_sd[["mean_sq_delta_p"]]), 4)

#' 
#' Result. Over the 80 draws, `mean_sq_delta_p` equals $2\,F_{ST}\,GD_T$ to
#' `r sprintf("%.0e", msdp_dev)` (asserted), and its correlation with $F_{ST}$ is
#' `r ff(sw_cor, 4)`. The means per level of $F_{ST}$ run from
#' `r ff(sw_mean[["F_ST"]][1], 3)` to `r ff(sw_mean[["F_ST"]][4], 3)` and those of
#' `mean_sq_delta_p` from `r ff(sw_mean[["mean_sq_delta_p"]][1], 3)` to
#' `r ff(sw_mean[["mean_sq_delta_p"]][4], 3)`; $GD_{WS}$ falls from
#' `r ff(sw_mean[["GD_WS"]][1], 3)` to `r ff(sw_mean[["GD_WS"]][4], 3)` along the
#' same sweep (the s.d. over seeds are in the table), while `frac_opposite_fixed`
#' stays between `r ff(min(sw_mean[["frac_opposite_fixed"]]), 4)` and
#' `r ff(max(sw_mean[["frac_opposite_fixed"]]), 3)`.
#' 
#' Interpretation. In this neutral simulation `mean_sq_delta_p` is $F_{ST}$
#' rescaled by $2\,GD_T$ and carries nothing that $F_{ST}$ and $GD_T$ do not; the
#' frequency-side statistics do **not** decouple from $F_{ST}$ here. The identity is
#' algebra for equal pool sizes, so it does not depend on neutrality, but the
#' chapter has not examined pools whose divergence was produced by selection toward
#' different targets. What decouples from $F_{ST}$ is expected heterosis, which is
#' not in this chunk (@tbl-het-sweep of @sec-heterosis). `mean_sq_delta_p` is worth
#' logging as the unweighted ($d_k \equiv 1$) divergence term of expected heterosis
#' in the units of that chapter (@sec-heterosis, "Reading the S1 panel": half of it
#' is $GD_{BS}$ and it cannot carry the weighting by $d$), not as an independent
#' signal. `frac_opposite_fixed` is near zero over most of this sweep (largest
#' level mean `r ff(max(sw_mean[["frac_opposite_fixed"]]), 3)` at $F_{BN}$ = 0.40),
#' so in these simulations it cannot discriminate between levels except at the
#' top; no value for a real dent-versus-flint pair is sourced here.
#' 
#' The sweep varies $F_{BN}$ and not the number of oppositely fixed loci, so the
#' fall of $GD_{WS}$ is a cost of divergence of the pools as a whole in these
#' simulations, and the cost of fixed opposite loci specifically was not isolated.
#' **Hold $F_{ST}$ in a band, not at a maximum:** the reasons are the two of
#' @sec-heterosis (a diversity-side one, the fall of within-pool gene diversity
#' shown above, and a prediction-side one); this chapter does not establish the
#' width of the band, which is a decision about how much within-pool diversity the
#' programme will spend.
#' 
#' ### The S1 monitoring panel
#' 
#' @tbl-s1-panel is the output of `s1_monitor()` on the simulated world of this chapter:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-s1-panel
#| tbl-cap: "S1 monitoring panel from `s1_monitor()` on one simulated world of 30 + 30 lines and 3,000 markers (seed 12; `cycle = 12` is a label, not a time point). `GD_within`, `GD_total`, `GD_A`, `GD_B`: gene diversity within pools, of the whole set and of each pool; `Gst_Nei`, `Fst_Wright`: the two differentiation statistics of Trap 2; `Ns_total`: status number of the whole set; `frac_opposite_fixed`, `mean_abs_delta_p`, `mean_sq_delta_p`: divergence of pool allele frequencies."
fmt(s1_monitor(GL, pool, cycle = 12), 4)

#' 
#' `GD_within` is $GD_{WS}$, the census-weighted mean over pools, `GD_total` is
#' $GD_T$, `Gst_Nei` the book's $F_{ST}$ and `Fst_Wright` $F^{\text{btw}}_{ST}$;
#' `GD_A` and `GD_B` are the per-pool values; `Ns_total` is $1/(2\theta_T)$ and, as
#' above, a rescaling of $\theta_T$ in $[1/2, 1]$, not a number of lines (a value of
#' about 0.76 is not three quarters of a line). `cycle = 12` is a label passed to
#' the function; the chunk is one draw, not a time series.
#' 
#' Log this every cycle and plot it as a time series. Defend `GD_A` and `GD_B`
#' per pool; watch `mean_sq_delta_p` as the divergence term of heterosis at
#' $d_k \equiv 1$; treat $F_{ST}$ as a descriptor, not an objective. @sec-cycles
#' runs fifteen cycles, but logs a different set of columns (`index`, `GD`,
#' `GD_BS`, `F_hom`, `F_drift`, `max_line`), so it does not show this panel as a
#' time series.
#' 
#' The empirical anchor is @kadoumi2025, who report for forty years of one
#' commercial European dent maize programme that differentiation between heterotic
#' groups increased while intragroup diversity decreased (abstract-level reading;
#' @sec-hp-cycle gives the numbers and their limits: the between-group Hamming
#' distance fell slightly while $F_{ST}$ rose, the within-group decline sits in one
#' group that merged others, and the authors can only speculate about selection as
#' the cause). That is one programme observed with both movements, not a test of
#' this panel. See @sec-plant-literature.
#' 
#' ## S2: choosing crosses for DH induction
#' 
#' The diversity of a DH pool can be written exactly from the parents and how often
#' they are used, without genotyping the DH lines, which makes S2 the stage where
#' the cheapest exact algebra is available. How much diversity S2 costs in a
#' simulated pipeline is measured in @sec-stages-ledger, from a cached file,
#' and the answer depends on how the crosses are chosen.
#' 
#' ### Three identities
#' 
#' For a DH family from cross $(i,j)$ of two inbreds, each locus is inherited from
#' $i$ or $j$ with probability 1/2 and then doubled; the expectations below need
#' only this per-locus marginal, so they hold with or without linkage.
#' 
#' **(a)** Coancestry between two DH sibs of the same family:
#' $\mathbb{E}[f] = (1 + f_{ij})/2$.
#' 
#' **(b)** Coancestry between a DH of family $(i,j)$ and one of $(k,l)$:
#' $\mathbb{E}[f] = (f_{ik} + f_{il} + f_{jk} + f_{jl})/4$.
#' 
#' **(c)** Group coancestry of a DH pool from crosses $c = 1 \dots C$, each
#' contributing $n_c$ lines, $n_{DH} = \sum_c n_c$, with $f_c = f^L_{i_c j_c}$ the
#' coancestry of the parents of cross $c$:
#' 
#' $$\theta_S \;=\; \mathbf{w}^{\top}\mathbf{f}^L\mathbf{w}
#'   \;+\; \frac{1}{n_{DH}}\left(1 - \sum_{c} \frac{n_c}{n_{DH}}\,\frac{1 + f_c}{2}\right),$$ {#eq-stages-dh-theta}
#' 
#' with $\mathbf{w}$ the parent-usage weights, $w_a = k_a/(2n_{DH})$, $k_a$ the number of
#' DH lines whose cross has $a$ as a parent (the same construction as @sec-collapse
#' for hybrids). The first term treats every pair of DH lines, a line with itself
#' included, as a pair of sibs of one family; the second corrects the $n_{DH}$ diagonal
#' pairs, whose coancestry is 1, not $(1 + f_c)/2$. It is $O(1/n_{DH})$ and worth keeping.
#' Derivation: by (a) and (b) the expected coancestry of the pair (line of $c$, line
#' of $c'$) is $\bar F_{cc'}$, the mean of $\mathbf{f}^L$ over the four parent
#' pairs, and $n_{DH}^{-2}\sum_{c,c'} n_c n_{c'}\bar F_{cc'} = \mathbf{w}^\top\mathbf{f}^L\mathbf{w}$.
#' The chunk below checks (a) to (c) numerically (@tbl-dh-identities).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-dh-identities
#| tbl-cap: "Identities (a) to (c) of S2 on the simulated world of 30 + 30 lines and 3,000 markers (seed 88 for the crosses, 89 for gene dropping). `crosses_drawn`, `rows_kept`, `distinct_unordered`: number of crosses drawn, kept after the self-pairs are dropped, and distinct as unordered pairs. `with_self_term`, `without_self_term`: $\\theta_S$ of @eq-stages-dh-theta with and without its second term; `oracle`: the literal pair-by-pair average. `mc_a`, `formula_a` and `mc_b`, `formula_b`: gene-dropping estimate and formula of (a) and (b)."
set.seed(88)
A <- 1:30
crosses <- cbind(sample(A, 20, replace = TRUE), sample(A, 20, replace = TRUE))
crosses <- crosses[crosses[, 1] != crosses[, 2], , drop = FALSE]
n_per <- 40

# oracle literal, pair by pair: expected coancestry of every pair of DH lines
fam <- rep(seq_len(nrow(crosses)), each = n_per)
Fcc <- outer(seq_len(nrow(crosses)), seq_len(nrow(crosses)),
             Vectorize(function(a, b) mean(fL[crosses[a, ], crosses[b, ]])))
E <- Fcc[fam, fam]; diag(E) <- 1
theta_oracle <- mean(E)
theta_c <- dh_pool_theta(crosses, n_per = n_per, fL, self_term = TRUE)
stopifnot(isTRUE(all.equal(theta_c, theta_oracle, tolerance = 1e-12)))

# (a) and (b) by gene dropping at free recombination (independent loci)
dh_draw <- function(i, j, n) {
  pick <- matrix(runif(n * ncol(GL)) < 0.5, n)
  pick * rep(GL[i, ], each = n) + (!pick) * rep(GL[j, ], each = n)
}
set.seed(89)
ia <- crosses[1, 1]; ja <- crosses[1, 2]; kb <- crosses[2, 1]; lb <- crosses[2, 2]
mc_a <- mean(dh_draw(ia, ja, 2000) == dh_draw(ia, ja, 2000))
mc_b <- mean(dh_draw(ia, ja, 2000) == dh_draw(kb, lb, 2000))
stopifnot(abs(mc_a - dh_sib_coancestry(fL[ia, ja])) < 2e-3,
          abs(mc_b - mean(fL[c(ia, ja), c(kb, lb)])) < 2e-3)

vtab(c(crosses_drawn = 20, rows_kept = nrow(crosses),
  distinct_unordered = nrow(unique(t(apply(crosses, 1, sort)))),
  with_self_term = theta_c,
  without_self_term = dh_pool_theta(crosses, n_per = n_per, fL, self_term = FALSE),
  oracle = theta_oracle, mc_a = mc_a, formula_a = dh_sib_coancestry(fL[ia, ja]),
  mc_b = mc_b, formula_b = mean(fL[c(ia, ja), c(kb, lb)])))

#' 
#' The 20 draws of two pool-A parents with replacement leave
#' `r nrow(crosses)` crosses after the self-pairs are dropped, of which
#' `r nrow(unique(t(apply(crosses, 1, sort))))` are distinct as unordered pairs, all
#' within pool A; the weights $n_c = 40$ are equal. (c), @eq-stages-dh-theta, is asserted
#' against the literal pair-by-pair average; (a) and (b) are asserted against gene
#' dropping with 2,000 pairs (tolerance 0.002; the Monte Carlo s.e. is of the order
#' of $10^{-4}$ on 3,000 markers).
#' 
#' ::: {.callout-note}
#' ## The key structural result of S2
#' 
#' The diversity of the DH pool is a quadratic form in *which parents you use and
#' how often*. **The DH lines never need to be genotyped -- or to exist -- for their
#' pool diversity to be optimised.** You can evaluate a crossing plan before making
#' a single cross.
#' :::
#' 
#' ### Progeny variance, and the usefulness criterion
#' 
#' Assume an additive model with marker effects $\beta_k$ (the effect of the allele
#' coded 1 against 0), inbred parents coded 0/1, and **free recombination between
#' loci**, so that the segregation indicators at distinct loci are independent.
#' Then only loci segregating in the cross contribute, each with
#' $\text{Var}(x_k) = 1/4$, and
#' 
#' $$\sigma^2_{DH(a,b)} = \frac{1}{4}\sum_{k \,:\, x_{ak} \ne x_{bk}} \beta_k^2 .$$ {#eq-stages-sigma-dh}
#' 
#' With linkage the covariances between loci enter and this is not the variance
#' (the simulations of @sec-sizing and @sec-simulating-crosses carry genetic maps;
#' this chapter's formula is the free-recombination case). The usefulness criterion
#' of the cross of lines $a$ and $b$ is $UC_{ab} = \mu_{ab} + i\,h\,\sigma_{DH(a,b)}$:
#' $\mu_{ab}$ the mean of the DH family (the mid-parent value under additivity), $i$
#' the selection intensity of the selected fraction $q$ (@eq-response-breeders of
#' @sec-response; $i$ is not a line index, the lines of a cross are indexed $a$, $b$ here),
#' $h$ the accuracy with which the criterion predicts the value of a DH line (the
#' $r$ of that equation); `h = 0.6` below is a value chosen for the illustration,
#' not an estimate. @lehermeier2017 give the criterion with a progeny variance
#' predicted from markers; the package documentation attributes it to Schnell and
#' Utz (1975), which is not in this book's bibliography and was not checked here.
#' The chunk below computes $\sigma_{DH}$ and $UC$ for the crosses of the previous
#' chunk and checks $\sigma_{DH}$ against gene dropping (@tbl-sigma-uc).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sigma-uc
#| tbl-cap: "First six crosses of the S2 example (parents `p1` and `p2`, line indices in the simulated world of 30 + 30 lines and 3,000 markers): `mu`, mean of the DH family (mid-parent value of the additive merit); `sigma_dh`, progeny standard deviation from @eq-stages-sigma-dh; `UC`, usefulness criterion with $i$ = `sel_intensity(0.05)` and $h$ = 0.6."
sig <- sigma_dh_crosses(crosses, GL, sim[["beta"]])
mu  <- rowMeans(cbind(GL[crosses[, 1], ] %*% sim[["beta"]],
                      GL[crosses[, 2], ] %*% sim[["beta"]]))
uc  <- usefulness_criterion(mu, sig, i = sel_intensity(0.05), h = 0.6)

# gene dropping at free recombination for the first cross
set.seed(90)
dh1 <- dh_draw(crosses[1, 1], crosses[1, 2], 20000) %*% sim[["beta"]]
sig_rel_err <- abs(sd(dh1) / sig[1] - 1)
stopifnot(sig_rel_err < 0.03)
knitr::kable(fmt(head(data.frame(p1 = crosses[, 1], p2 = crosses[, 2],
                                 mu = mu, sigma_dh = sig, UC = uc), 6), 3))

#' 
#' @eq-stages-sigma-dh agrees with gene dropping on the first cross to
#' `r ff(100 * sig_rel_err, 1)` % of $\sigma_{DH}$ (20,000 DH lines; the
#' s.e. of an s.d. from that many draws is 0.5 %; asserted below 3 %).
#' `sel_intensity(0.05)` is `r ff(sel_intensity(0.05), 4)`, the normal-theory
#' intensity $\varphi(z_{1-q})/q$; @sec-response already checks that function.
#' 
#' ### Trap 4: genetic distance is not a proxy for progeny variance
#' 
#' Ranking crosses by marker distance has the argument that more distant parents
#' segregate for more loci. Once the heterotic pattern is fixed, the cached data
#' show that this explains little (@tbl-trap4 and @fig-metric-pitfalls):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-trap4
#| echo: false
#| tbl-cap: "Distance against progeny standard deviation, within stratum and pooled (cached `dist_vs_variance.csv`, external study, no generating code here). 300 crosses per stratum, drawn from one set of founder lines, so the crosses share parents and are not independent replicates; the within-pool stratum is A x A only. `cor_MRD_nseg`: correlation of the distance with the number of segregating loci."
strat <- do.call(rbind, lapply(split(dvv, dvv[["set"]]), function(g)
  data.frame(stratum = g[["set"]][1], crosses = nrow(g),
             cor = cor(g[["sigma_DH"]], g[["MRD"]]),
             R2 = cor(g[["sigma_DH"]], g[["MRD"]])^2,
             cor_MRD_nseg = cor(g[["MRD"]], g[["n_seg"]]))))
pooled <- data.frame(stratum = "pooled", crosses = nrow(dvv),
                     cor = cor(dvv[["sigma_DH"]], dvv[["MRD"]]),
                     R2 = cor(dvv[["sigma_DH"]], dvv[["MRD"]])^2,
                     cor_MRD_nseg = cor(dvv[["MRD"]], dvv[["n_seg"]]))
knitr::kable(fmt(rbind(strat, pooled), 4), row.names = FALSE)

#' 
## -----------------------------------------------------------------------------
#| label: fig-metric-pitfalls
#| echo: false
#| fig-cap: "Cached figure `metric_pitfalls.png` (external study, no generating code here; scale unrecorded). Panel A: progeny standard deviation against modified Rogers distance -- the pooled correlation only re-separates inter- from within-pool crosses and explains little within either stratum. Panel B: the two statistics of Trap 2 on identical data. The figure's own labels use the names this chapter withdrew: its \"F_ST (reference = between-pool coancestry)\" is $F^{\\text{btw}}_{ST}$ here, its \"G_ST, Nei\" is the book's $F_{ST}$, and its title phrases \"both in common use\" and \"published threshold\" are not claims of this chapter."
#| fig-alt: "Scatter of progeny standard deviation against distance in two strata, and two differentiation statistics against simulated divergence"
knitr::include_graphics(book_fig("metric_pitfalls.png"))

#' 
#' Within the strata the distance explains `r ff(100 * strat[["R2"]][1], 1)` %
#' and `r ff(100 * strat[["R2"]][2], 1)` % of the variance of
#' $\sigma_{DH}$, against `r ff(100 * pooled[["R2"]], 1)` % pooled
#' (@tbl-trap4). Within a stratum the distance is a near-linear function of the
#' number of segregating loci (`cor_MRD_nseg`), so a raw count of segregating loci
#' explains the same variance. Inference, limited by one dataset of unrecorded
#' scale and an additive simulated model: distance adds little beyond "are these
#' parents in different pools", which is already known. The consequence for a
#' ranking of crosses, for example how many of the top crosses on UC are also top on
#' distance, was not computed.
#' 
#' **Rank crosses on `sigma_dh_crosses()` computed from marker effects, not on
#' distance.**
#' 
#' ## S3: selecting lines per se
#' 
#' Two points of practice.
#' 
#' **Apply the constraint within each pool separately.** The partition shows why
#' this is the right unit: $\theta_T$ contains the between-pool terms, so a pooled
#' constraint can be satisfied by keeping the pools apart while both erode
#' internally, which is what S1 exists to prevent. This is an argument from the
#' algebra; the demonstration in this section is **pooled** (the 60 lines of both
#' pools); `select_lines_constrained()` has no pool argument, so the within-pool
#' version is one call per pool, run at the end of Trap 5 (@sec-stages-trap5).
#' 
#' **Measure loss against a same-size resampling baseline** (@sec-baseline).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-s3-loss
#| tbl-cap: "Gene diversity of the top 20 lines by merit against 300 random sets of 20 lines (`loss_vs_resampling()`, seed 1; one simulated world of 30 + 30 lines and 3,000 markers). `GD_selected`: $GD$ of the top 20; `GD_random_mean`: mean $GD$ of the random sets; `loss_pct`: $100\\,(GD_{\\text{random}} - GD_{\\text{selected}})/GD_{\\text{random}}$; `percentile`: fraction of random sets with $GD$ below that of the top 20."
merit <- as.vector(GL %*% sim[["beta"]])
merit <- (merit - mean(merit)) / sd(merit)
top   <- order(merit, decreasing = TRUE)[1:20]
lv    <- loss_vs_resampling(top, fL, B = 300)
knitr::kable(fmt(as.data.frame(as.list(lv)), 4))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-s3-pools
#| tbl-cap: "Pool of origin of the top 20 lines by merit (number of lines)."
knitr::kable(as.data.frame(table(pool = pool[top])))

#' 
#' The top 20 by merit take `r sum(pool[top] == "A")` lines from pool A and
#' `r sum(pool[top] == "B")` from pool B, and lose `r ff(lv[["loss_pct"]], 2)` %
#' of gene diversity against random sets of 20 (one world, one set of 300
#' resamples; @tbl-s3-loss and @tbl-s3-pools).
#' 
#' ### Trap 5: the incremental greedy constraint silently returns nothing {#sec-stages-trap5}
#' 
#' The natural implementation -- "add the next-best line while $\theta$ stays below
#' the ceiling" -- **cannot work**. Group coancestry includes the diagonal, so a
#' single line has $\theta = 1$ and any pair has $\theta = (1 + f_{ij})/2$. A
#' ceiling calibrated on a large pool is unreachable at small set sizes; the greedy
#' never gets past the first candidate and returns the empty set without a
#' warning. The chunk runs that rule (@tbl-trap5-greedy):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-trap5-greedy
#| tbl-cap: "The incremental greedy rule at the ceiling for $n$ = 20 and a permitted loss of 0.5 % (simulated world of 30 + 30 lines and 3,000 markers). `ceiling`: the ceiling on $\\theta$; `theta_single_line`: $\\theta$ of a single line, $f_{11}$; `theta_best_pair`: smallest $\\theta = (1 + f_{ij})/2$ over all pairs; `any_pair_admissible`: whether any pair is at or below the ceiling; `greedy_set_size`: size of the set the rule returns."
ceiling20 <- theta_ceiling(fL, n_sel = 20, alpha = 0.005)
pair_theta <- (1 + fL[upper.tri(fL)]) / 2
greedy <- integer(0)
for (cand in order(merit, decreasing = TRUE))
  if (s3_theta(c(greedy, cand), fL) <= ceiling20) greedy <- c(greedy, cand)
stopifnot(length(greedy) == 0)
vtab(c(ceiling             = ceiling20,
       theta_single_line   = fL[1, 1],
       theta_best_pair     = min(pair_theta),
       any_pair_admissible = any(pair_theta <= ceiling20),
       greedy_set_size     = length(greedy)))

#' 
#' No single line and no pair can satisfy the ceiling, and the rule returns a set
#' of size 0. $\theta$ of a random set falls as the set grows, so **the constraint
#' is only meaningful at the target size** (@fig-theta-by-size):
#' 
## -----------------------------------------------------------------------------
#| label: fig-theta-by-size
#| fig-cap: "Mean group coancestry $\\theta$ of random sets (50 random sets per size, seed 5, drawn from the simulated world of 30 + 30 lines and 3,000 markers) falls with set size (number of lines). The ceiling calibrated for n = 20 at a permitted loss of 0.5 % (dashed) lies below the mean of random sets of every size smaller than 20 in the plot, which is why an incremental greedy that must stay under it from the first addition never starts. The curve is for random sets: sets chosen to lower theta could cross the ceiling at a smaller size, which this figure does not examine."
#| fig-alt: "Mean group coancestry of random sets against set size, with the ceiling for n = 20"
sizes <- c(2, 3, 5, 8, 12, 20, 30, 45, 60)
set.seed(5)
th <- vapply(sizes, function(n) mean(replicate(50, {
  s <- sample.int(nrow(fL), n); mean(fL[s, s])})), numeric(1))
plot(sizes, th, type = "b", pch = 19, xlab = "set size (number of lines)",
     ylab = expression("mean group coancestry " * theta))
abline(h = ceiling20, col = "#b2182b", lty = 2, lwd = 2)
legend("topright", c(expression("mean " * theta * " of a random set"),
                     "ceiling for n = 20"),
       col = c("black", "#b2182b"), lty = c(1, 2), pch = c(19, NA), bty = "n")
grid()
stopifnot(all(th[sizes < 20] > ceiling20))

#' 
#' The route the package offers is **truncate-then-repair**: take the top `n_sel`
#' by merit, then, while the ceiling is exceeded, apply the single swap that
#' lowers $\theta$ (scored exactly, the best of them after a small weight on merit),
#' until the ceiling is met. Every accepted swap strictly lowers $\theta$, so the
#' loop cannot cycle; it stops at the ceiling or at a set where no single swap
#' lowers $\theta$, and in that case it warns. The chunk runs it once (@tbl-trap5-repair):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-trap5-repair
#| tbl-cap: "Truncate-then-repair (`select_lines_constrained()`, $n$ = 20, same ceiling as @tbl-trap5-greedy; simulated world of 30 + 30 lines and 3,000 markers). `n_selected`: size of the returned set; `theta`: its $\\theta$; `ceiling`: the ceiling; `met`: 1 if $\\theta \\le$ ceiling; `same_as_top`: 1 if the set is the truncation set; `n_swap`: swaps used; `mean_merit`, `merit_of_top`: mean standardised merit of the returned set and of the truncation set."
sel <- select_lines_constrained(merit, fL, n_sel = 20, theta_max = ceiling20)
rep1 <- c(n_selected   = length(sel),
          theta        = s3_theta(sel, fL),
          ceiling      = ceiling20,
          met          = as.numeric(s3_theta(sel, fL) <= ceiling20),
          same_as_top  = as.numeric(identical(sort(top), sort(sel))),
          n_swap       = attr(sel, "n_swap"),
          mean_merit   = mean(merit[sel]),
          merit_of_top = mean(merit[top]))
stopifnot(attr(sel, "met"), isTRUE(all.equal(attr(sel, "theta"), s3_theta(sel, fL))))
vtab(rep1)

#' 
#' Result. In this world the truncation set has
#' $\theta$ = `r ff(s3_theta(top, fL), 5)` against the ceiling
#' `r ff(ceiling20, 5)`, and the set returned by `select_lines_constrained()`
#' has $\theta$ = `r ff(rep1[["theta"]], 5)` after `r rep1[["n_swap"]]` swap(s): the ceiling is
#' `r if (rep1[["met"]] == 1) "met" else "**not** met"`, the returned set
#' `r if (rep1[["same_as_top"]] == 1) "is identical to" else "differs from"` the
#' truncation set, and the mean merit of the selected lines is `r ff(rep1[["mean_merit"]], 3)`
#' against `r ff(rep1[["merit_of_top"]], 3)` for the truncation set (`met` and
#' `same_as_top` are 1 for TRUE and 0 for FALSE). The chunk asserts that the ceiling is met.
#' The next chunk repeats the call in 20
#' simulated worlds of the same size (seeds 1 to 20, alpha 0.005, merit the
#' standardised additive index; @tbl-trap5-worlds):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-trap5-worlds
#| tbl-cap: "Truncate-then-repair in 20 simulated worlds of 30 + 30 lines and 3,000 markers (seeds 1 to 20), $n$ = 20, permitted loss 0.5 %, merit the standardised additive index. `top_violates`: worlds where the truncation set exceeds the ceiling; `repair_meets`: worlds where the returned set meets it; `repair_equals_top`: worlds where the returned set is the truncation set; `violating_and_repaired`: worlds in both of the first two; `max_swap_used`: largest number of swaps; `merit_cost_mean_violating`: mean over the violating worlds of the merit of the truncation set minus that of the returned set; `merit_cost_max`: the same, largest over all 20 worlds."
t5 <- do.call(rbind, lapply(1:20, function(sd) {
  s  <- simulate_pools(30, 30, 3000, 0.15, seed = sd)
  mr <- as.vector(s[["GL"]] %*% s[["beta"]]); mr <- (mr - mean(mr)) / sd(mr)
  ce <- theta_ceiling(s[["fL"]], 20, alpha = 0.005)
  tp <- order(mr, decreasing = TRUE)[1:20]
  sl <- select_lines_constrained(mr, s[["fL"]], 20, theta_max = ce)
  data.frame(seed = sd, top_violates = s3_theta(tp, s[["fL"]]) > ce,
             repair_meets = s3_theta(sl, s[["fL"]]) <= ce,
             repair_equals_top = identical(sort(tp), sort(sl)),
             n_swap = attr(sl, "n_swap"),
             merit_cost = mean(mr[tp]) - mean(mr[sl]))
}))
stopifnot(identical(t5[["repair_equals_top"]], t5[["n_swap"]] == 0L))
vtab(c(worlds = nrow(t5), top_violates = sum(t5[["top_violates"]]),
       repair_meets = sum(t5[["repair_meets"]]),
       repair_equals_top = sum(t5[["repair_equals_top"]]),
       violating_and_repaired = sum(t5[["top_violates"]] & t5[["repair_meets"]]),
       max_swap_used = max(t5[["n_swap"]]),
       merit_cost_mean_violating = mean(t5[["merit_cost"]][t5[["top_violates"]]]),
       merit_cost_max = max(t5[["merit_cost"]])), digits = 4)

#' 
#' In `r sum(t5[["top_violates"]])` of 20 worlds the truncation set violates the
#' ceiling. The repair returns a set that meets it in `r sum(t5[["repair_meets"]])`
#' of 20, including `r sum(t5[["top_violates"]] & t5[["repair_meets"]])` of the
#' `r sum(t5[["top_violates"]])` where truncation violates it; it returns the truncation set
#' unchanged in `r sum(t5[["repair_equals_top"]])` (the worlds where no swap was needed),
#' using at most `r max(t5[["n_swap"]])` swaps. Where it swapped, the mean merit of the selected set
#' fell by `r ff(mean(t5[["merit_cost"]][t5[["top_violates"]]]), 3)` standardised units on average
#' (largest cost over all 20 worlds `r ff(max(t5[["merit_cost"]]), 3)`).
#' This is what these 20 worlds show; it is not a guarantee. Stopping at a set where no
#' single swap lowers $\theta$ is possible, and then the function warns and returns
#' `met = FALSE` as an attribute; a ceiling that is unattainable by swaps is not repaired
#' silently. The package test also runs a case in which merit is the mean coancestry itself,
#' so that truncation starts from the most related lines available, and one swap against the
#' best single swap enumerated literally. The ceiling is attainable at this size in
#' the sense that the repair reached it in every world above. Keep the check
#' `attr(sel, "met")` (or `s3_theta(sel, fL) <= theta_max`) after every call, as the
#' chunk does. The counts above are recomputed at every render, so they describe the
#' function as installed.
#' 
#' Within pool, the same function is called once per pool, each with its own
#' ceiling calibrated against random sets of the same size from that pool (10 lines
#' per pool, alpha 0.005, the merit of this world; @tbl-trap5-within-pool):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-trap5-within-pool
#| tbl-cap: "Within-pool constrained selection (`select_lines_constrained()` once per pool) in the simulated world of 30 + 30 lines and 3,000 markers, 10 lines selected per pool, ceiling for a proportional loss of 0.5 % against random sets of 10 lines from the same pool. `theta`: group coancestry of the returned set; `ceiling`: the ceiling; `met`: whether the ceiling was met; `n_swap`: swaps used; `theta_truncation`: group coancestry of the top 10 lines by merit."
within <- do.call(rbind, lapply(c("A", "B"), function(p) {
  ix <- which(pool == p); fp <- fL[ix, ix]
  ce <- theta_ceiling(fp, 10, alpha = 0.005)
  sl <- select_lines_constrained(merit[ix], fp, 10, theta_max = ce)
  data.frame(pool = p, n = length(sl), theta = s3_theta(sl, fp), ceiling = ce,
             met = attr(sl, "met"), n_swap = attr(sl, "n_swap"),
             theta_truncation = s3_theta(order(merit[ix], decreasing = TRUE)[1:10], fp))
}))
within

#' 
#' The pooled call above took `r sum(pool[sel] == "A")` lines from A and
#' `r sum(pool[sel] == "B")` from B; here each pool contributes 10 by construction
#' and the ceiling is met in `r sum(within[["met"]])` of 2 pools (truncation alone
#' exceeds it in `r sum(within[["theta_truncation"]] > within[["ceiling"]])`). One world, one
#' merit vector: this shows that the per-pool call runs and meets its ceilings, not that
#' it preserves more of the between-pool structure than the pooled call, which is not measured.
#' 
#' `theta_ceiling()` expresses the ceiling as a permitted **proportional loss**
#' against the same-size baseline, so the constraint means the same thing at every
#' set size.
#' 
#' ## S4: hybrid mining
#' 
#' Assumptions of @sec-collapse, which owns the derivation: homozygous parents,
#' each hybrid one $A \times B$ cross and the $n$ selected hybrids distinct crosses.
#' With $\mathbf{k}$ the line-usage count vector over the $n$ selected hybrids
#' ($k_a$ times line $a$ is a parent, $\sum_a k_a = 2n$) and $\mathbf{w} = \mathbf{k}/(2n)$,
#' the group coancestry of the hybrid set is $\theta_S = \mathbf{w}^{\top}\mathbf{f}^L\mathbf{w}
#' = \mathbf{k}^{\top}\mathbf{f}^L\mathbf{k}/(2n)^2$ (@eq-collapse-theta). The chunk checks it on 100 hybrids (@tbl-s4-usage):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-s4-usage
#| tbl-cap: "Hybrid-set coancestry from the line-usage collapse against the hybrid matrix, for 100 hybrids drawn at random (seed 91) from the 900 of the simulated world. `theta_from_usage`: $\\mathbf{k}^\\top\\mathbf{f}^L\\mathbf{k}/(2n)^2$; `theta_from_matrix`: `ref_theta()` on the hybrid matrix; `deviation`: their difference."
set.seed(91)
hyb <- sample.int(ctx[["N"]], 100)
k   <- line_usage(hyb, ctx[["parents"]], ctx[["n_lines"]])
s4_dev <- hybrid_theta_from_usage(k, fL) - ref_theta(hyb, ctx)
stopifnot(abs(s4_dev) < 1e-12)
vtab(c(theta_from_usage = hybrid_theta_from_usage(k, fL),
       theta_from_matrix = ref_theta(hyb, ctx),
       deviation = s4_dev))

#' 
#' The deviation is below $10^{-12}$ (asserted). The saving is in memory: the
#' collapse of @sec-collapse needs the $L \times L$ matrix and no $N \times N$ hybrid
#' matrix, $O(N^2) \to O(L^2)$. It is not a saving of time per evaluation unless $n$
#' is large (@sec-stages-cost). @tbl-hp-stages assigns S4 to the chapters on
#' the collapse, optimal contribution selection (OCS), combinatorial and advanced selection.
#' 
#' The expected heterozygosity of the merged frequencies of the hybrid set is
#' $1 - \theta_S$, computed here from the frequencies and compared with the
#' coancestry route (@tbl-s4-he):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-s4-he
#| tbl-cap: "Expected heterozygosity of the merged frequencies of the 100 hybrids of @tbl-s4-usage, and other S4 quantities. `theta`: $\\theta_S$ from the usage; `He_from_frequencies`: $\\overline{2\\hat p_k(1 - \\hat p_k)}$ over markers, $\\hat p_k$ the mean of the 0/0.5/1 coding over the selected hybrids; `N_e_par`: $N_{e,\\text{par}}$; `pool_balance1`, `pool_balance2`: share of the parent slots from the first and the second pool (`pool_balance()` returns them in the order of first appearance in `pool`, here A then B)."
p_hyb  <- colMeans(ctx[["X"]][hyb, ])
He_freq <- mean(2 * p_hyb * (1 - p_hyb))
stopifnot(abs(He_freq - (1 - hybrid_theta_from_usage(k, fL))) < 1e-12)
vtab(c(theta = hybrid_theta_from_usage(k, fL),
       He_from_frequencies = He_freq,
       N_e_par = ne_parents_from_counts(k),
       pool_balance = pool_balance(hyb, ctx[["parents"]], pool)))

#' 
#' This $H_e$ is that of the merged set, not the heterozygosity the F1 hybrids
#' carry, which depends on how the lines are paired (@sec-hp-popgen; @sec-catalogue).
#' $N_{e,\text{par}} = (\sum_a k_a)^2/\sum_a k_a^2$ (`ne_parents_from_counts()`,
#' the `Ne` column of the ledger of @sec-stages-ledger, read as this quantity).
#' 
#' ## Where the diversity actually goes {#sec-stages-ledger}
#' 
#' **Provenance.** The ledger `pipeline_loss_ledger.csv` and the figure
#' `pipeline_loss.png` are cached results of an external simulation study; the code
#' that produced them is not in this repository, they cannot be regenerated here,
#' and nothing in this section is a reproduction of the study. The file records, per founder
#' pool (seeds 1 to 8) and stage, `n_in` and `n_out`
#' (`r paste(unique(led[["n_in"]]), collapse = ", ")` in and
#' `r paste(unique(led[["n_out"]]), collapse = ", ")` out: 120 lines give 800 DH
#' lines, 80 lines are kept, 200 hybrids are mined from 1,600 candidates),
#' `GD_before`, `GD_after`, the proportional loss and its share, and per pool and arm
#' `merit`, `Ne` and `alleles`. It does not record the number of markers, the
#' Balding-Nichols parameter, the number of crosses and DH lines per cross, the
#' baseline used at S2, the form and weight of the diversity term, or the set on
#' which `Ne` and `alleles` were computed (S3 lines or S4 hybrids). The study's
#' description (6,000 markers, $F_{BN}$ = 0.15, 20 crosses of 40 DH lines each) is
#' quoted from it and cannot be checked here. The two arms are named as in the file:
#' `UC only`, cross selection on the usefulness criterion alone (so including the
#' progeny standard deviation, not on merit alone), and `UC + div`, the criterion
#' plus a diversity term on parental coancestry.
#' 
#' Loss at each stage is the proportional loss of gene diversity,
#' $100\,(GD_{\text{before}} - GD_{\text{after}})/GD_{\text{before}}$ (asserted on
#' all 48 rows of the file), where the baseline `GD_before` is that stage's own
#' same-size resampling baseline. Because each stage is re-based, the `GD_after` of
#' one stage is not the `GD_before` of the next, and the stage losses are not parts
#' of one end-to-end loss. @tbl-ledger gives the means over the 8 founder pools and
#' @fig-pipeline-loss plots them.
#' 
## -----------------------------------------------------------------------------
#| label: ledger-stats
arms   <- c("UC only", "UC + div")
stages <- sort(unique(led[["stage"]]))
stopifnot(max(abs(led[["loss_pct"]] -
        100 * (led[["GD_before"]] - led[["GD_after"]]) / led[["GD_before"]])) < 1e-8)
lg <- do.call(rbind, lapply(arms, function(a) do.call(rbind, lapply(stages, function(s) {
  g <- led[led[["strategy"]] == a & led[["stage"]] == s, ]
  data.frame(Arm = a, Stage = s, GD_before = mean(g[["GD_before"]]),
             GD_after = mean(g[["GD_after"]]),
             `loss % (mean)` = mean(g[["loss_pct"]]),
             `loss % (sd)` = sd(g[["loss_pct"]]),
             `share % (mean)` = mean(g[["share_of_total"]]),
             `share % (min)` = min(g[["share_of_total"]]),
             `share % (max)` = max(g[["share_of_total"]]),
             check.names = FALSE)
}))))
pick <- function(a, s, col) lg[[col]][lg[["Arm"]] == a & lg[["Stage"]] == stages[s]]
neg_rows <- sum(led[["loss_pct"]] < 0)
stopifnot(neg_rows == 2)
# change of GD, S2 GD_before (a re-based same-size baseline) to final hybrids (S4 GD_after)
e2e <- sapply(arms, function(a) {
  x <- led[led[["strategy"]] == a, ]
  mean(100 * (x[["GD_before"]][x[["stage"]] == stages[1]] -
              x[["GD_after"]][x[["stage"]] == stages[3]]) /
       x[["GD_before"]][x[["stage"]] == stages[1]])
})
# paired contrasts by pool (seed): UC + div minus UC only
paired <- function(v, stage = stages[3]) {
  a <- led[led[["strategy"]] == "UC only" & led[["stage"]] == stage, ]
  b <- led[led[["strategy"]] == "UC + div" & led[["stage"]] == stage, ]
  a <- a[order(a[["seed"]]), ]; b <- b[order(b[["seed"]]), ]
  dd <- b[[v]] - a[[v]]; tt <- t.test(dd)
  data.frame(`UC only` = mean(a[[v]]), `UC + div` = mean(b[[v]]),
             diff = mean(dd), lo = tt[["conf.int"]][1], hi = tt[["conf.int"]][2],
             `pools higher` = sum(dd > 0), p = tt[["p.value"]], check.names = FALSE)
}
endp <- rbind(merit = paired("merit"), GD_final = paired("GD_after"),
              Ne = paired("Ne"), alleles = paired("alleles"))
s2_pair <- paired("loss_pct", stages[1]); s3_pair <- paired("loss_pct", stages[2])
s4_pair <- paired("loss_pct", stages[3])
merit_cost <- 100 * (1 - endp["merit", "UC + div"] / endp["merit", "UC only"])

#' 
## -----------------------------------------------------------------------------
#| label: tbl-ledger
#| echo: false
#| tbl-cap: "Diversity loss per stage and arm, mean over 8 founder pools (cached `pipeline_loss_ledger.csv`, external study). `share` is the stage's proportional loss as a percentage of the SUM of the three stage losses of the same pool and arm, each measured against its own re-based baseline; min and max are over the 8 pools. 2 of the 48 rows have a negative loss (S3, arm UC only)."
knitr::kable(fmt(lg, 3))

#' 
## -----------------------------------------------------------------------------
#| label: fig-pipeline-loss
#| echo: false
#| fig-cap: "Cached figure `pipeline_loss.png` (external study, no generating code here). Panel A: proportional loss per stage, mean and s.e. over 8 founder pools, for the two arms (the figure calls `UC only` \"merit only\"). Panel B: paired end-of-pipeline outcomes per pool. The figure's own subtitles state a 77 % share \"of total pipeline loss\" and that the diversity term \"buys stage-level diversity, not end-of-pipeline richness\"; this chapter qualifies the first (it holds for one arm, as a share of a sum of re-based losses) and withdraws the second (low power at 8 pools)."
#| fig-alt: "Loss of gene diversity at three stages for two cross-selection arms, and paired end-of-pipeline outcomes per founder pool"
knitr::include_graphics(book_fig("pipeline_loss.png"))

#' 
#' Result. In the `UC only` arm the mean proportional loss is
#' `r ff(pick("UC only", 1, "loss % (mean)"), 2)` % at S2,
#' `r ff(pick("UC only", 2, "loss % (mean)"), 2)` % at S3 and
#' `r ff(pick("UC only", 3, "loss % (mean)"), 2)` % at S4, and S2's share of the sum
#' of the three is `r ff(pick("UC only", 1, "share % (mean)"), 1)` % (per-pool range
#' `r ff(pick("UC only", 1, "share % (min)"), 1)` to
#' `r ff(pick("UC only", 1, "share % (max)"), 1)` %), S3's
#' `r ff(pick("UC only", 2, "share % (mean)"), 1)` % and S4's
#' `r ff(pick("UC only", 3, "share % (mean)"), 1)` %. In the `UC + div` arm the
#' shares are `r ff(pick("UC + div", 1, "share % (mean)"), 1)`,
#' `r ff(pick("UC + div", 2, "share % (mean)"), 1)` and
#' `r ff(pick("UC + div", 3, "share % (mean)"), 1)` %. The mean change of $GD$ from
#' the S2 `GD_before` (a same-size baseline whose set the file does not record, not
#' the $GD$ of the 120 founder lines) to the `GD_after` of the final 200 hybrids is
#' `r ff(e2e[["UC only"]], 1)` % (`UC only`) and `r ff(e2e[["UC + div"]], 1)` %
#' (`UC + div`), a change in $GD$ that includes the baseline-sampling effect and is
#' not a loss against a random set. The term lowered the S2 loss in
#' `r 8 - s2_pair[["pools higher"]]` of 8 pools
#' (`r ff(s2_pair[["UC only"]], 2)` to `r ff(s2_pair[["UC + div"]], 2)` %) and raised the S3 and S4 losses in
#' `r s3_pair[["pools higher"]]` and `r s4_pair[["pools higher"]]` of 8 pools.
#' 
#' Interpretation. With cross selection on $UC$ alone, S2 carries the largest share
#' of the summed stage losses in this file, at this scale, with these 8 pools: that
#' is a statement about the first arm, not about DH induction in general, and the
#' share is a share of a sum of re-based proportional losses (which do not add), not
#' of an end-to-end loss. With the diversity term the three stages carry similar
#' shares. A structural reason is plausible -- a few crosses give a DH pool built from few
#' parents, and the diversity of that pool is the quadratic form of S2 in the parent
#' usage -- but this is a hypothesis: the file does not vary the number of crosses
#' or of DH lines per cross, the quantity that sets the S2 loss is the usage of
#' parents and not the fraction of possible combinations chosen, and the chapter
#' has no run in which it changes. That S2 is "the cheapest stage to constrain" is
#' not measured here: the term moved loss from S2 to S3 and S4 rather than
#' removing it.
#' 
#' ### What the diversity term buys, and what it does not
#' 
#' Four end-of-pipeline outcomes are compared, paired by founder pool (8 pools,
#' paired $t$ on the differences, normality of the 8 differences not checked; @tbl-endpoints). Hybrid
#' merit, $N_e$ and marker alleles retained are the three outcomes the cached figure
#' reports; the final-set $GD$ (`GD_after` of the S4 row) was added by this
#' re-analysis after seeing the data, so it is post hoc, and no outcome is adjusted for
#' multiplicity.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-endpoints
#| echo: false
#| tbl-cap: "End-of-pipeline outcomes by arm, mean over 8 founder pools (cached `pipeline_loss_ledger.csv`), difference `UC + div` minus `UC only` with its 95 % confidence interval from a paired t-test on the 8 pool differences, and the number of pools in which the diversity arm is higher. Four outcomes, none adjusted for multiplicity; `GD` of the final set is post hoc."
ep <- data.frame(Outcome = c("hybrid merit", "GD of the final hybrid set",
                             "`Ne` (set unrecorded)", "marker alleles retained"),
                 endp, check.names = FALSE, row.names = NULL)
names(ep) <- c("Outcome", "UC only", "UC + div", "paired difference", "95 % CI low",
               "95 % CI high", "pools higher (of 8)", "paired t p")
ep[["paired t p"]] <- sprintf("%.3g", ep[["paired t p"]])
knitr::kable(fmt(ep, 4))

#' 
#' Result. The merit cost of the term is
#' `r ff(merit_cost, 1)` % (ratio of means; lower under the term in
#' `r 8 - endp["merit", "pools higher"]` of 8 pools; paired $p$ =
#' `r sprintf("%.2g", endp["merit", "p"])`). The final-set $GD$ is higher under the
#' term by `r ff(endp["GD_final", "diff"], 4)` (95 % CI
#' `r ff(endp["GD_final", "lo"], 4)` to `r ff(endp["GD_final", "hi"], 4)`, higher
#' in `r endp["GD_final", "pools higher"]` of 8 pools, $p$ =
#' `r ff(endp["GD_final", "p"], 3)`); $N_e$ differs by
#' `r ff(endp["Ne", "diff"], 2)` (CI `r ff(endp["Ne", "lo"], 2)` to
#' `r ff(endp["Ne", "hi"], 2)`, i.e. `r ff(100 * endp["Ne", "lo"] / endp["Ne", "UC only"], 0)` %
#' to `r ff(100 * endp["Ne", "hi"] / endp["Ne", "UC only"], 0)` % of the `UC only`
#' mean) and the alleles retained by `r ff(endp["alleles", "diff"], 0)` (CI
#' `r ff(endp["alleles", "lo"], 0)` to `r ff(endp["alleles", "hi"], 0)`, i.e.
#' `r ff(100 * endp["alleles", "lo"] / endp["alleles", "UC only"], 1)` % to
#' `r ff(100 * endp["alleles", "hi"] / endp["alleles", "UC only"], 1)` %).
#' 
#' Interpretation. The merit cost is clear in these 8 pools. For the final-set $GD$
#' the data point to a small gain, but the interval has a lower end near zero, the
#' outcome is post hoc, and with four outcomes a Bonferroni level of 0.0125 would
#' leave only merit significant: it is a signal to test, not a finding. For $N_e$
#' and for alleles retained the intervals are wide enough to contain no change and
#' changes of the sizes shown, so 8 pools cannot say whether the term improves
#' them; "not significant" is not "no benefit". That stage losses at S3 and S4 rise
#' when S2 is constrained is an observed sign in 8 of 8 pools; that diversity spent
#' at S2 is "reclaimed" later is a mechanism the file does not test (the S3 and S4
#' baselines are re-based), as is whether carrying the term through all four stages
#' would hold the final diversity, since no arm does it.
#' 
#' ## Cost summary {#sec-stages-cost}
#' 
#' Orders of magnitude only (@tbl-stage-cost); this chapter times none of these functions. The
#' timings that the book does report are in @sec-choosing-cost (cached, benchmark
#' scale), where the line route is **slower** than the matrix route at
#' $N = 2{,}500$, $n = 50$ and cheaper only for large $n$, and where the saving per
#' evaluation belongs to the incremental swap, not to the quadratic form itself.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-stage-cost
#| echo: false
#| tbl-cap: "Order of the cost of the function used at each stage, with $L$ lines, $m$ markers, $C$ candidate crosses, $n$ lines selected and $N$ hybrids; orders only, none timed in this chapter."
knitr::kable(data.frame(
  Stage = c("S1", "S1", "S2", "S2", "S3", "S4"),
  `Function` = c("`theta_decompose` with `f` supplied", "`theta_decompose`, `f = NULL`",
                 "`dh_pool_theta`", "`sigma_dh_crosses`",
                 "`select_lines_constrained`", "`hybrid_theta_from_usage`"),
  Order = c("O(L^2)", "O(L^2 m)", "O(L^2) per plan", "O(C m)",
            "O(n L) per swap; count returned (`n_swap`)", "O(L^2) per evaluation"),
  Notes = c("monitoring, not an inner loop", "builds the L x L matrix first",
            "no DH genotypes needed", "touches the marker matrix",
            "warns and flags (`met`) if the ceiling is not reached", "no N x N matrix (memory O(N^2) -> O(L^2))"),
  check.names = FALSE))

#' 
#' The quadratic form is the recurring shape and its memory saving is unqualified.
#' Whether its time saving matters depends on $n$ and on the optimiser (@sec-choosing-cost).
#' At S2 `sigma_dh_crosses` is expected to dominate the per-plan cost because it
#' touches the $L \times m$ marker matrix; it was not timed here, but caching it per
#' candidate cross rather than recomputing inside an optimiser loop follows from
#' its $O(Cm)$ order.
#' 
#' ## Checklist
#' 
#' 1. Compute the coancestry matrix once per cycle; never report modified Rogers
#'    distance alongside it as separate evidence (Trap 1).
#' 2. Monitor `GD_A` and `GD_B` per pool, not pooled `GD`; state which $F_{ST}$ you
#'    use (the book's $GD_{BS}/GD_T$ or the between-referenced one) and hold it in a
#'    band whose width is a programme decision (Trap 2, Trap 3).
#' 3. Rank crosses on $\sigma_{DH}$ from marker effects rather than on parental
#'    distance (Trap 4: additive simulated model, one cached dataset).
#' 4. Evaluate the crossing plan's $\theta_S$ *before* making the crosses -- it is a
#'    quadratic form in parent usage.
#' 5. Calibrate every diversity ceiling against a same-size resampling baseline,
#'    apply it at the target set size, and after every call of the repair test that
#'    the ceiling was met (`attr(sel, "met")`; the function warns when it was not)
#'    (Trap 5).
#' 6. Constrain within pool at S3 (argued from the partition; not demonstrated
#'    here). A diversity term at S2 alone moved loss between stages in the cached
#'    ledger; whether a constraint carried through all four stages would hold the
#'    final diversity was not tested.
#' 7. At S4, use the line-usage collapse for the diversity quantities that are
#'    functions of $\mathbf{w}$ (@sec-collapse); the hybrid coancestry matrix is
#'    not needed for them.
#' 8. Keep the per-stage loss ledger. In the cached file, at its scale and for
#'    cross selection on $UC$ alone, S2 carries the largest stage loss; this is not
#'    shown for other programmes.
