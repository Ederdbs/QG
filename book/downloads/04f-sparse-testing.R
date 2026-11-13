#' # Sparse testing: which hybrids go to which locations {#sec-sparse}
#' 
# 04f-sparse-testing -- standalone script of the chapter 04f-sparse-testing.qmd
# Book: https://ederdbs.github.io/QG/04f-sparse-testing.html
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
sc   <- read.csv(book_data("sparse_scenarios.csv"))
mn   <- read.csv(book_data("sparse_min_allocation.csv"))
ct   <- read.csv(book_data("sparse_contrasts.csv"))
ts   <- read.csv(book_data("sparse_two_stage.csv"))
gl   <- read.csv(book_data("sparse_genomic_layer.csv"))
val  <- read.csv(book_data("sparse_validation.csv"))
ps   <- read.csv(book_data("sparse_primary_studies.csv"))
lp   <- read.csv(book_data("sparse_literature_parameters.csv"))
core <- read.csv(book_data("sparse_core_sweep.csv"))

# The headline slice of the cached grid: 400 hybrids, low SCA.
s4  <- subset(sc, nHyb == 400 & sca_level == "low")
ref <- subset(s4, strategy == "complete" & nLoc == 10)
ref <- setNames(ref$acc_all_mean, ref$h2_plot)
r4  <- function(x) sprintf("%.3f", x)
pc  <- function(x, d = 1) sprintf(paste0("%.", d, "f %%"), 100 * x)
strat_col <- c(complete = "grey35", random = "#d95f02",
               optimised_blocks = "#7570b3", parentage = "#1b9e77")

#' 
## -----------------------------------------------------------------------------
#| label: headline-numbers
#| include: false
# Every number quoted in the list of results below is computed here, not typed.
r2  <- function(x) sprintf("%.2f", x)
r4s <- function(x) sprintf("%+.4f", x)
g   <- function(l, m, c, s = "all") ct[ct$layer == l & ct$metric == m &
                                       ct$contrast == c & ct$subset == s, ]
# The calibration at plot h2 = 0.4; the identities the text states are asserted.
vc_ex <- sparse_vc(0.4)
stopifnot(isTRUE(all.equal(vc_ex$Vg, vc_ex$s2f + vc_ex$s2m + vc_ex$s2s)),
          isTRUE(all.equal(vc_ex$VgxE, vc_ex$s2fl + vc_ex$s2ml + vc_ex$s2sl)),
          isTRUE(all.equal(vc_ex$Vg / (vc_ex$Vg + vc_ex$VgxE + vc_ex$s2e), 0.4)),
          isTRUE(all.equal(vc_ex$s2res, vc_ex$s2e + vc_ex$s2sl)),
          isTRUE(all.equal((vc_ex$s2f + vc_ex$s2m) / 2, 1)))
# Result 1: the cheapest cell within 5 % of the complete design, per heritability.
sel_cell <- function(h) {
  m <- subset(mn, nHyb == 400 & h2_plot == h & sca_level == "low" & nLoc == 10 & minimal_5)
  a <- subset(s4, strategy == m$strategy & nLoc == 10 & k == m$k & h2_plot == h)
  r <- subset(s4, strategy == "complete" & nLoc == 10 & h2_plot == h)
  stopifnot(nrow(m) == 1L, nrow(a) == 1L, nrow(r) == 1L)
  list(m = m, a = a, r = r,
       margin    = a$acc_all_mean - 0.95 * r$acc_all_mean,
       se_margin = sqrt(a$acc_all_se^2 + (0.95 * r$acc_all_se)^2),
       d_coinc   = a$coinc_t5_truth_mean - r$coinc_t5_truth_mean,
       se_coinc  = sqrt(a$coinc_t5_truth_se^2 + r$coinc_t5_truth_se^2),
       n_cand    = nrow(subset(s4, nLoc == 10 & h2_plot == h & strategy != "complete")))
}
c_hi <- sel_cell(0.4); c_lo <- sel_cell(0.2)
# Result 2: two plots per hybrid, ten locations against two.
spr_gain <- function(h) {
  a <- function(L) subset(s4, k == 2 & nLoc == L & h2_plot == h &
                            strategy %in% c("complete", "random"))$acc_all_mean
  a(10) - a(2)
}
# Result 3: the contrasts of the cached study (the family is all of them).
n_ct   <- nrow(ct)
p_all  <- g("fast", "acc_all", "parentage - random")
p_cv1  <- g("fast", "acc_cv1", "parentage - random")
p_cv2  <- g("fast", "acc_cv2", "parentage - random")
p_coi  <- g("fast", "coinc_t5_truth", "parentage - random")
o_coi  <- g("fast", "coinc_t5_truth", "optimised_blocks - random")
p_k2   <- g("fast", "acc_cv1", "parentage - random", "k<=2")
o_k2   <- g("fast", "acc_cv1", "optimised_blocks - random", "k<=2")
p_gen  <- g("genomic", "acc_all", "parentage - random")
# Result 4: the one cell the mechanism rests on.
c10 <- subset(s4, nLoc == 10 & k == 2 & h2_plot == 0.4)
cv  <- function(s, v) c10[c10$strategy == s, v]
z_pr <- (cv("parentage", "acc_all_mean") - cv("random", "acc_all_mean")) /
  sqrt(cv("parentage", "acc_all_se")^2 + cv("random", "acc_all_se")^2)
z_or <- (cv("optimised_blocks", "acc_all_mean") - cv("random", "acc_all_mean")) /
  sqrt(cv("optimised_blocks", "acc_all_se")^2 + cv("random", "acc_all_se")^2)
# CV1 against CV2 in the cached cells.
bo_cv <- sc[!is.na(sc$acc_cv1_mean) & !is.na(sc$acc_cv2_mean), ]
n_both_cv <- nrow(bo_cv); n_cv1_gt <- sum(bo_cv$acc_cv1_mean > bo_cv$acc_cv2_mean)
med_d_cv  <- median(bo_cv$acc_cv1_mean - bo_cv$acc_cv2_mean)
# Result 5: convergence and bias in the cached grid.
conv <- aggregate(cbind(n_conv, nrep) ~ k, sc, sum); conv$frac <- conv$n_conv / conv$nrep
fc   <- function(k) pc(conv$frac[conv$k == k])
med  <- aggregate(cbind(relbias_s2f_mean, relbias_s2fl_mean, relbias_s2s_mean,
                        relbias_h2_mean) ~ k, sc, median)
med_k <- function(v, k) 100 * med[[v]][med$k == k]
# Result 6: gain by N1 at the same total plots, paired by replicate (the mean
# over the strategies and stage-2 settings that share the budget).
mb <- aggregate(gain_sd_units ~ N1 + plots_total + rep, ts, mean)
mpair <- function(a, b) {
  bud <- sort(intersect(mb$plots_total[mb$N1 == a], mb$plots_total[mb$N1 == b]))
  do.call(rbind, lapply(bud, function(B) {
    x <- mb[mb$N1 == a & mb$plots_total == B, ]; y <- mb[mb$N1 == b & mb$plots_total == B, ]
    stopifnot(identical(sort(x$rep), sort(y$rep)))
    dd <- y$gain_sd_units[order(y$rep)] - x$gain_sd_units[order(x$rep)]
    data.frame(N1_from = a, N1_to = b, plots = B, reps = length(dd), diff = mean(dd),
               se = sd(dd) / sqrt(length(dd)), t = mean(dd) / (sd(dd) / sqrt(length(dd))))
  }))
}
mt <- rbind(mpair(100, 200), mpair(200, 400))
stopifnot(all(mt$reps == 4L))
mt$p <- 2 * pt(-abs(mt$t), df = mt$reps - 1)

#' 
#' A hybrid programme's first field stage concentrates most of its selection
#' pressure where it has the least information. It typically has thousands of
#' testcrosses, seed for one or two plots of each, a handful of locations, and
#' almost no replication. @sec-mating compared **which crosses** to make from two
#' pools -- connected sparse factorials against tester designs, analysed by BLUP, with
#' results that are conditional on the design and field size it states -- but held the
#' field fixed and folded genotype x location into plot error. This chapter takes the
#' crosses as given and asks the next question: **which locations should each one
#' be planted in?**
#' 
#' *Sparse testing* is the answer the literature has converged on. Not every hybrid
#' is grown at every location. Different subsets go to different environments, and
#' the missing hybrid x environment cells are *predicted*, not discarded, with a
#' relationship matrix connecting what the field left unconnected. In @sec-mating
#' the sparsity was in the female x male grid. Here it is in the hybrid x
#' environment grid. Real programmes face both at once, the joint problem
#' @sec-mating-open lists as its second gap.
#' 
#' The chapter covers the quantitative basis, the history and a taxonomy of the
#' designs, the validation schemes used to judge them, and the empirical record
#' across crops, including its main controversy. It then measures the question
#' with a simulation that the primary literature had not run. The results it
#' defends:
#' 
#' 1. **In the one cell examined, a sparse allocation reached within 5 % of the
#'    accuracy of the complete design at a fraction of its plots; the margin is
#'    thin.** At 400 hybrids, ten locations and $h^2 = 0.4$ the cheapest allocation
#'    within 5 % used `r pc(c_hi$m$cost_rel, 0)` of the plots. It passes the 95 %
#'    line by `r sprintf("%.4f", c_hi$margin)` accuracy units, which is
#'    `r sprintf("%.1f", c_hi$margin / c_hi$se_margin)` standard errors of the
#'    difference, and it is the cheapest passing cell among
#'    `r c_hi$n_cand` candidates, chosen on the same noisy means that are then
#'    reported. At $h^2 = 0.2$ the cheapest passing cell uses
#'    `r pc(c_lo$m$cost_rel, 0)` of the plots. "Wider at higher heritability" rests
#'    on these two cells.
#' 2. **At a fixed number of plots, spreading them over more locations raised
#'    accuracy.** Spreading two plots per hybrid over ten locations instead of two
#'    raised accuracy by `r r2(spr_gain(0.4))` at $h^2 = 0.4$ and `r r2(spr_gain(0.2))`
#'    at $h^2 = 0.2$, with no extra plots (cached REML study, one configuration:
#'    see Scope below).
#' 3. **Parentage allocation exceeded random allocation by a small margin that does
#'    not survive a multiplicity correction, and not on the operational metric.**
#'    Parentage minus random was `r r4s(p_all$diff)` on accuracy over all hybrids,
#'    `r r4s(p_cv1$diff)` on never-planted hybrids and `r r4s(p_cv2$diff)` on missing
#'    cells of planted hybrids, but `r r4s(p_coi$diff)` $\pm$ `r sprintf("%.4f", p_coi$se)`
#'    on the coincidence with the true top 5 %. The smallest of the
#'    `r n_ct` p-values of the family is `r sprintf("%.4f", min(ct$p))`, above the
#'    Bonferroni threshold `r sprintf("%.4f", 0.05 / n_ct)`. A subset ($k \le 2$) with
#'    a larger difference is exploratory.
#' 4. **Whether parent coverage, rather than shared hybrids, connects a sparse
#'    trial is a hypothesis that these data do not decide.** In the one cell
#'    examined, the parentage design (no hybrid shared between some location pairs,
#'    both pools in every location) exceeded random allocation by
#'    `r r4s(cv("parentage", "acc_all_mean") - cv("random", "acc_all_mean"))`
#'    ($z = `r sprintf("%.2f", z_pr)`$, unresolved), while the optimised blocks, with
#'    the highest hybrid overlap and nearly the same parent coverage, did not. No
#'    arm varies coverage with overlap fixed.
#' 5. **In the cached REML grid the dispersion slope of the BLUP stayed near 1
#'    where REML converged, while variance components were estimated less well.**
#'    Where every fit converged ($k \ge 2$) there was no systematic dispersion
#'    bias. At one location per hybrid REML converged in `r fc(1)` of fits, and the
#'    median relative bias was `r sprintf("%+.1f", med_k("relbias_h2_mean", 1))` % for plot $h^2$
#'    and `r sprintf("%+.0f", med_k("relbias_s2s_mean", 1))` % for the SCA variance. The
#'    SCA variance is also biased upward in the complete design.
#' 6. **In the cached two-stage scenario, covering more candidates in stage 1
#'    gave a larger realised gain at the same total plots, but with four replicates
#'    nothing survives a multiplicity correction.** The paired
#'    difference at matched budgets is `r r2(min(mt$diff[mt$N1_from == 100]))` to
#'    `r r2(max(mt$diff[mt$N1_from == 100]))` genetic SD ($t$ =
#'    `r sprintf("%.1f", min(mt$t[mt$N1_from == 100]))` to
#'    `r sprintf("%.1f", max(mt$t[mt$N1_from == 100]))`, 3 df) from 100 to 200, and
#'    `r r2(min(mt$diff[mt$N1_from == 200]))` to `r r2(max(mt$diff[mt$N1_from == 200]))`
#'    ($t$ = `r sprintf("%.1f", min(mt$t[mt$N1_from == 200]))` to
#'    `r sprintf("%.1f", max(mt$t[mt$N1_from == 200]))`, not resolved) from 200 to 400.
#' 
#' **Scope.** Every simulated result below refers to one configuration: a 20 x 20
#' female x male factorial of which 80 % of the hybrids are planted at random
#' (each line is a parent of about 16 planted crosses), 400 hybrids, at most ten
#' locations, one plot per cell, and the calibration of `sparse_vc()`. It is a
#' dense factorial, in which parents are shared by construction. The sparse
#' factorials of @sec-mating (a few crosses per line out of 200 candidates per pool)
#' and the 2,000-lines-per-pool pipeline of @fig-sparse-pipeline are different
#' regimes, and none of the results was measured there. The cached study is one
#' study, and the contrasts and bias figures quoted from it cannot be recomputed in
#' this repository.
#' 
#' The numbering is that of @sec-sparse-results, which the rest of the book cites.
#' 
#' ::: {.callout-note}
#' ## Where the numbers come from
#' 
#' There are three sources, kept apart throughout.
#' 
#' - **Live** results are computed at render time with `R/17_sparse_testing.R`:
#'   - allocation generators;
#'   - connectivity diagnostics;
#'   - a base-R mixed-model solve with **known** variance components, checked
#'     against a literal GLS oracle (`ref_sparse_blup()`).
#' - **Cached** results come from a separate study and are not reproducible from
#'   this repository. That study estimated components by REML with `sommer` on
#'   2,630 fits, ran a two-stage scenario, and added an AlphaSimR genomic layer.
#'   Its tables are in `book/data/sparse_*.csv`.
#' - **In-repo** results come from `Rscript book/scripts/regenerate.R sparse`,
#'   which reruns the phenotypic core with known components
#'   (`sparse_core_sweep.csv`). That sweep also adds an experiment the cached
#'   study did not run (@sec-sparse-overlap). The two are compared in
#'   @sec-sparse-reproduce.
#' 
#' The literature numbers are from six primary papers: @li2026, @atanda2022,
#' @werner2025, @lubanga2025, @gonzalezdieguez2026 and @hildaono2026. The numbers
#' attributed to @li2026 and to @werner2025 have been checked against their abstracts
#' only, not against their full texts; the others were checked in the book's
#' reference review against the full text, with exceptions noted where they occur.
#' **@werner2025 is a preprint that has not been peer reviewed.**
#' :::
#' 
#' ## The allocation problem of stage 1 {#sec-sparse-problem}
#' 
#' ### The economics of the first stage
#' 
#' Stage 1 is where a plot costs least and a decision is worth most. Early-stage
#' testing typically evaluates a large number of candidates at one or a few
#' experimental sites [@werner2025]. Two shifts are taken here as premises of the
#' chapter, not as results measured in it or taken from a cited source:
#' 
#' - **Genotyping is no longer the bottleneck. Phenotyping is.** The cost of a
#'   marker datum is taken to be small against the cost of a yield plot.
#' - **Doubled haploids reversed the constraint.** A programme can now make more
#'   candidates than it can evaluate. Allocating plots, not creating variation, is
#'   then the limiting factor.
#' 
#' What is left is the classical trade-off. More genotypes at fewer locations buys
#' selection intensity and costs accuracy. Fewer genotypes at more locations does
#' the opposite. At stage 1 the scarce resource is the plot, so the question is not
#' *how much to test* but *how to spread what can already be tested* [@li2026].
#' 
## -----------------------------------------------------------------------------
#| label: fig-sparse-pipeline
#| echo: false
#| fig-width: 9.5
#| fig-height: 3.4
#| fig-cap: "A two-pool hybrid pipeline. Population improvement (left) feeds product development (right). Candidate numbers fall by an order of magnitude per stage while plots per candidate rise. Sparse testing applies where the plots per candidate are fewest: the first testcross trial. The numbers are schematic; the simulation of this chapter has 400 hybrids."
#| fig-alt: "A two-pool hybrid pipeline"
op <- par(mar = c(0, 0, 0, 0)); plot.new(); plot.window(c(0, 100), c(0, 40))
bx <- function(x, y, w, h, lab, fill) {
  rect(x, y, x + w, y + h, col = fill, border = "grey40")
  text(x + w / 2, y + h / 2, lab, cex = 0.68)
}
ar <- function(x0, x1, y) arrows(x0, y, x1, y, length = 0.08, col = "grey30")
bx(1, 14, 15, 14, "DH lines\n2 pools\n~2,000 / pool", "grey92")
bx(21, 14, 19, 14, "Stage 1\ntestcross trial\n~1,000 hybrids\n1-2 plots each", "#c7e9c0")
bx(45, 14, 17, 14, "Stage 2\n~100 hybrids\n4-8 locations", "grey92")
bx(67, 14, 15, 14, "Stage 3\n~20 hybrids\n10-30 locations", "grey92")
bx(87, 14, 12, 14, "Release\n1-3\nhybrids", "grey92")
ar(16, 21, 21); ar(40, 45, 21); ar(62, 67, 21); ar(82, 87, 21)
arrows(30, 13, 8, 9, length = 0.08, lty = 2, col = "grey30")
text(19, 6, "recycle parents (GCA)", cex = 0.65, font = 3)
text(30.5, 34, "sparse testing\nlives here", cex = 0.75, font = 2, col = "#d98e04")
arrows(30.5, 31, 30.5, 28.5, length = 0.06, col = "#d98e04")
par(op)

#' 
#' ### The breeder's equation as the decision criterion
#' 
#' The gain per unit time,
#' 
#' $$
#' \Delta G_t = \frac{i \, \rho \, \sigma_A}{t},
#' $$
#' 
#' has four terms. $\rho$ is the accuracy of the selection criterion -- the $r$ of
#' @sec-response; this Part keeps $r$ for plots,
#' as @sec-mating does. $\sigma_A$ is the additive standard deviation of @sec-response
#' (written $\sigma_g$ in @sec-mating). The accuracy reported by the simulation below is a
#' correlation with the value of a *hybrid*, defined in @sec-sparse-results; it is not
#' the GCA accuracy of @sec-mating, which is a correlation over lines. A trial design
#' moves at least three of the terms together:
#' 
#' - **intensity $i$**, through the number of candidates;
#' - **accuracy $\rho$**, through plots, locations, and how well the locations sample
#'   the target population of environments (TPE);
#' - **cycle length $t$**, when parents can be recycled from stage 1.
#' 
#' What a gain measured on a research station is worth depends on the genetic
#' correlation between the selection environment and the TPE [@atlin2000;
#' @atlin2001]. No design is better in the abstract. A design is better according
#' to whichever term limits that programme [@werner2025trends;
#' @riedelsheimer2013].
#' 
#' ::: {.callout-tip}
#' ## Box 1 -- Where each term of the breeder's equation meets the trial design
#' 
#' | Term | Design decision that moves it |
#' |---|---|
#' | $i$ (intensity) | number of candidates tested at a fixed plot budget |
#' | $\rho$ (accuracy) | plots per candidate, locations per candidate, use of a relationship matrix |
#' | $\rho$ (relevance) | how well the chosen locations sample the TPE |
#' | $\sigma_A$ | indirectly: which parents are recycled, and how related they are (@sec-ocs) |
#' | $t$ | whether stage-1 GCA predictions are good enough to recycle parents immediately |
#' :::
#' 
#' ## Foundations {#sec-sparse-foundations}
#' 
#' ### The hybrid model: GCA, SCA, and what sparsity threatens
#' 
#' The value of the single cross between female $i$ and male $j$ -- a pool-A and
#' a pool-B line in the notation of @sec-mating -- splits as
#' 
#' $$
#' g_{ij} = \mathrm{GCA}^f_i + \mathrm{GCA}^m_j + \mathrm{SCA}_{ij}
#' $$
#' 
#' This split is classically attributed to @sprague1942 (not checked at page level
#' here). @sec-heterosis-gca-sca derives it from allele
#' frequencies. Its consequence for this chapter is that a line's GCA includes
#' dominance effects weighted by the *opposite* pool's frequencies. A GCA is
#' therefore specific to the tester pool, not a property of the line alone
#' [@gonzalezdieguez2021; @legarra2023]. The ratio $\sigma^2_s/\sigma^2_g$ of
#' @sec-mating (symbols defined below) is a design parameter of the simulation. In the
#' dominance-only model of @sec-heterosis-gca-sca the corresponding quantity grows
#' with the mean degree of dominance and with how close the pools are; @sec-mating
#' notes that this is a different statistic from its own ratio, under narrower
#' assumptions, so the statement is not transferred to the ratio used here. In
#' simulated maize the ratio of @gonzalezdieguez2026, in that paper's own definition,
#' was 0.05, 0.23 and 0.50 at cycle 1 for mean dominance degrees of 0.1, 0.5 and 0.9.
#' 
#' GCA is *expected* to survive sparsity better than SCA, because it is mostly
#' additive and is averaged over many crosses. This is an expectation, not a result
#' of this chapter. The one supporting number is from @li2026, who recovered GCA from
#' a prediction-completed 50 % trial with correlations of 0.94 to 0.97 against the
#' complete data, while phenotypic prediction accuracy over the same scenarios was
#' 0.43 to 0.59. The chapter has no SCA comparator for that correlation, and its own
#' simulation measures the bias of the SCA *variance*, not the robustness of SCA
#' *prediction* (see its limitations). If stage 1 is used to recycle parents, GCA is
#' what it has to estimate; whether GCA is the part of the model most robust to
#' missing cells, and therefore the reason sparse testing works in hybrids, is not
#' tested here.
#' 
#' ::: {.callout-tip}
#' ## Quick glossary
#' 
#' - **GCA**: a line's average performance in crosses with the opposite pool.
#' - **SCA**: the deviation of a particular cross from the sum of its parents' GCAs.
#' - **Mid-parent heterosis**: the hybrid's advantage over the mean of its parents
#'   (@sec-heterosis).
#' - **Heterotic pool**: a group of lines bred to cross well with another group.
#' - **Tester**: a line of the opposite pool used to evaluate candidates.
#' - **TPE**: the target population of environments the product is sold into.
#' :::
#' 
#' ### Hybrid relationship matrices
#' 
#' With female and male relationship matrices $\mathbf{A}_f$ and $\mathbf{A}_m$,
#' the three hybrid terms are distributed as
#' 
#' $$
#' \mathrm{GCA}^f \sim N(\mathbf 0, \mathbf A_f\sigma^2_{f}), \quad
#' \mathrm{GCA}^m \sim N(\mathbf 0, \mathbf A_m\sigma^2_{m}), \quad
#' \mathrm{SCA}   \sim N(\mathbf 0, (\mathbf A_f\otimes\mathbf A_m)\sigma^2_{s})
#' $$
#' 
#' [@bernardo1994; @bernardo1996; @technow2012]. Here $\sigma^2_f$ and
#' $\sigma^2_m$ are the GCA variances of the female (pool-A) and male (pool-B)
#' lines. They are the $\sigma^2_{gA}$ and $\sigma^2_{gB}$ of @sec-mating, whose
#' $\sigma^2_g$ is their mean, $\sigma^2_g = (\sigma^2_f + \sigma^2_m)/2$;
#' $\sigma^2_s$ is the SCA variance of @sec-mating, also written $\sigma^2_{SCA}$ in
#' this chapter. The effects $\mathrm{GCA}^f_i$, $\mathrm{GCA}^m_j$ and
#' $\mathrm{SCA}_{ij}$ are the $g^A_i$, $g^B_j$ and $s_{ij}$ of @sec-mating. Two sums
#' are used below and each is defined here once. The genetic variance of a hybrid's
#' value in the target population of environments is
#' $\sigma^2_G = \sigma^2_f + \sigma^2_m + \sigma^2_s$
#' (`r vc_ex$Vg` in `sparse_vc()`, where it is `Vg`); it is **not** the
#' $\sigma^2_g$ of @sec-mating. Each of the three terms interacts with location, with
#' variances $\sigma^2_{f\ell}$, $\sigma^2_{m\ell}$ and $\sigma^2_{s\ell}$
#' (`s2fl`, `s2ml`, `s2sl`; the last is also written $\sigma^2_{SCA\times L}$ below),
#' and $\sigma^2_{GE} = \sigma^2_{f\ell} + \sigma^2_{m\ell} + \sigma^2_{s\ell}$
#' (`r vc_ex$VgxE` in `sparse_vc()`, where it is `VgxE`). $\sigma^2_e$ is the plot
#' error.
#' 
#' The practical point is that
#' **the hybrid itself never needs genotyping**: its covariance is a Kronecker
#' product of the parental matrices. Replacing pedigree $\mathbf A$ by marker $\mathbf G$
#' [@vanraden2008] gives the genomic version. @sec-genomic-prediction fits a single
#' additive GBLUP over all hybrids, with no pool split, no SCA kernel and no Kronecker
#' product, so the kernels of this section are not fitted there. The live code of this
#' chapter uses the pedigree matrices of `relmat_halfsib()`, and the cached genomic layer
#' comes from the external study. There are
#' two ways to write the additive and dominance effects: the "biological" form and
#' the "statistical" form, which is orthogonal at the population's frequencies.
#' Pool-specific marker effects are a third option [@vitezica2013;
#' @gonzalezdieguez2021]. All of them lead to the same covariance structure.
#' 
#' **The relationship matrix is what makes a sparse design analysable.** It is the
#' only link between cells that the field did not link. A hybrid with no plot gets
#' a BLUP only because its parents are related to parents that do have plots.
#' Without it, a sparse design yields comparisons that are not fair.
#' 
#' ### Multi-environment trials and mixed models
#' 
#' How many parameters the between-environment covariance spends ranges widely:
#' 
#' - identity, diagonal, or compound symmetry;
#' - heterogeneous AR(1);
#' - unstructured;
#' - factor-analytic [@smith2001; @smith2005; @kelly2007; @smith2018].
#' 
#' Factor-analytic models carry most of the information of the unstructured matrix
#' at a fraction of its parameters, and extend directly to genomic relationships
#' [@oakey2016; @tolhurst2019; @burgueno2012]. Reaction-norm and marker x
#' environment models are cheaper alternatives [@jarquin2013; @lopezcruz2015].
#' Only *crossover* G x E changes selection decisions. A scale effect does not.
#' 
#' **In a sparse design the between-environment covariance stops being a
#' statistical detail and becomes part of the design.** It decides how much one
#' environment can tell us about another. Two-stage analyses that carry the
#' first-stage error forward are now as efficient as one-stage ones
#' [@piepho2012; @endelman2023]. Unreplicated trials still need spatial correction
#' and checks [@robbins2012; @cullis2006].
#' 
#' ::: {.callout-tip}
#' ## Box 2 -- Which heritability to report in a sparse trial
#' 
#' | Quantity | Formula | What it answers | Behaviour under sparsity |
#' |---|---|---|---|
#' | Plot-level $h^2$ | $\sigma^2_G / (\sigma^2_G + \sigma^2_{GE} + \sigma^2_e)$ | how informative one plot is | design-independent; it is what the simulations below fix |
#' | Entry-mean $H^2$ | $\sigma^2_G / (\sigma^2_G + \sigma^2_{GE}/L + \sigma^2_e/(rL))$ | how informative an entry mean is, if every entry had $L$ locations and $r$ reps | undefined when entries have different $L$, i.e. in every sparse design |
#' | Per-genotype reliability | $1 - \overline{\mathrm{PEV}} / \sigma^2_G$, with $\overline{\mathrm{PEV}}$ the mean prediction error variance of the target values | the squared correlation of the BLUP with the true value of one genotype, in expectation over repeated draws, if the components are right; the realised correlation over a finite set of hybrids differs (Box 4) | the quantity Box 4 computes; it uses the actual PEVs |
#' | Generalised (Cullis) $H^2$ | $1 - \bar v_\Delta / (2\sigma^2_G)$, with $\bar v_\Delta$ the mean variance of the difference between two BLUPs [@cullis2006; @piepho2007] | how well the analysed design ranks entries | also uses the actual variances; not computed in this chapter. In an unbalanced design $\bar v_\Delta$ is not twice the mean PEV, so it is a different number from the reliability above |
#' 
#' The entry-mean formula silently assumes balance. In a sparse trial, report a
#' quantity that uses the actual PEVs: Cullis' $H^2$ or the per-genotype reliability.
#' The two are different numbers, and this chapter computes only the second.
#' :::
#' 
#' ## What sparse testing is, and where it came from {#sec-sparse-what}
#' 
#' ### Definition and genealogy
#' 
#' **Definition.** A trial is sparse when not every genotype is evaluated in every
#' environment *and* the missing cells are predicted rather than discarded. The
#' literature's *environment* is a location in a year; the simulations of this
#' Part have one season, so their environments are *locations*, and the two
#' words are used in those two senses. The idea
#' developed in four steps:
#' 
#' 1. **Incomplete blocks and lattices.** These already accepted partial
#'    evaluation *within* a location.
#' 2. **Partially replicated designs (p-rep) and augmented p-rep.** These replaced
#'    replication of each entry with replicated checks and partial replication
#'    [@cullis2006; @williams2011].
#' 3. **The genomic relationship replacing replication** [@endelman2014]. With
#'    markers, the replicated unit is no longer the genotype but the haplotype,
#'    shared among relatives.
#' 4. **Genomic sparse testing across environments, formalised** [@jarquin2020].
#'    The design was later framed explicitly as a balanced incomplete block design
#'    in which the block is the environment [@montesinoslopez2023].
#' 
#' **Farm-as-incomplete-block** is the limiting case. Each farmer's field is an
#' incomplete block holding a handful of entries, and the TPE is sampled through
#' hundreds of them [@werner2025trends; @werner2025; @atlin2001].
#' 
#' Sparse testing is not a new method. It is incomplete-block design applied at
#' the scale of many environments, made workable by genomic relationships acting as
#' the connecting mechanism. The classical theory of incomplete blocks therefore
#' carries over.
#' 
## -----------------------------------------------------------------------------
#| label: fig-sparse-genealogy
#| echo: false
#| fig-width: 9.5
#| fig-height: 2.9
#| fig-cap: "The genealogy of sparse testing, drawn as genotype (rows) x environment (columns) matrices; dark = observed. From the complete trial, to incomplete blocks within locations, to p-rep (a few entries and checks replicated), to genomic sparse testing (each entry in a subset of environments, connected through relationships), to farm-as-incomplete-block (many environments, very few entries each)."
#| fig-alt: "The genealogy of sparse testing, drawn as genotype (rows) x environment (columns) matrices; dark = observed"
set.seed(11)
mats <- list(
  "Complete"            = matrix(1, 12, 4),
  "Incomplete blocks"   = { M <- matrix(0, 12, 4); for (l in 1:4) M[((l - 1) * 3 + 1:6 - 1) %% 12 + 1, l] <- 1; M },
  "p-rep + checks"      = { M <- matrix(0, 12, 4); M[cbind(1:12, rep(1:4, 3))] <- 1; M[1:2, ] <- 1; M[3:5, 2] <- 1; M },
  "Genomic sparse"      = sparse_alloc(4, 3, 4, 2, "random"),
  "Farm-as-inc.-block"  = { M <- matrix(0, 12, 12); M[cbind(1:12, 1:12)] <- 1; M[cbind(1:12, c(2:12, 1))] <- 1; M })
op <- par(mfrow = c(1, 5), mar = c(1, 0.6, 2, 0.6))
for (nm in names(mats)) {
  M <- mats[[nm]]
  image(t(M[nrow(M):1, , drop = FALSE]), col = c("grey95", "#1f5f8b"), zlim = c(0, 1), axes = FALSE,
        main = nm, cex.main = 0.85)
  box(col = "grey60")
}
par(op)

#' 
#' ### A taxonomy of sparse designs
#' 
#' The designs can be classified along three independent axes.
#' 
#' **Axis of sparsity.**
#' 
#' - *Environments*: the classical case.
#' - *Testers*: sparse testcrossing (@sec-sparse-testcross).
#' - *Female x male combinations*: the incomplete factorials of @sec-mating-sparse.
#' - Any combination of these.
#' 
#' **Overlap structure.**
#' 
#' - full overlap, with a common core in every environment;
#' - no overlap;
#' - partial overlap, with a fixed core plus entries unique to each environment;
#' - unrestricted random allocation;
#' - restricted random allocation, for example keeping full-sibs out of the same
#'   location [@werner2025];
#' - allocation optimised against a formal criterion [@isidroysanchez2021;
#'   @fernandezgonzalez2023].
#' 
#' **Replicated unit.** Genotype, family, or haplotype.
#' 
## -----------------------------------------------------------------------------
#| label: fig-sparse-taxonomy
#| echo: true
#| fig-width: 9.5
#| fig-height: 3.2
#| fig-cap: "Six allocations of the same 8 x 4 factorial (32 hybrids, rows; male index fastest) to six locations (columns). The number of plots differs between panels and is printed above each. Panels 2 to 4 are written out in the chunk; panels 1, 5 and 6 are generated by the package's `sparse_alloc()`. 'Parentage' puts every female and every male in every location."
#| fig-alt: "Six allocations of the same 8 x 4 factorial (32 hybrids, rows; male index fastest) to six locations (columns), with the number of plots printed above each panel; panels 1, 5 and 6 are generated by sparse_alloc()"
set.seed(5)
core6 <- function(n_core) {               # a common core + unique entries
  M <- matrix(0L, 32, 6); M[seq_len(n_core), ] <- 1L
  rest <- setdiff(1:32, seq_len(n_core))
  M[cbind(rest, rep_len(1:6, length(rest)))] <- 1L; M
}
tax <- list("Complete"          = sparse_alloc(8, 4, 6, strategy = "complete"),
            "Full overlap core" = { M <- matrix(0L, 32, 6); M[1:10, ] <- 1L; M },
            "Core + unique"     = core6(5),
            "No overlap"        = core6(0),
            "Random, k = 2"     = sparse_alloc(8, 4, 6, 2, "random"),
            "Parentage, k = 2"  = sparse_alloc(8, 4, 6, 2, "parentage"))
op <- par(mfrow = c(1, 6), mar = c(1, 0.5, 2.2, 0.5))
for (nm in names(tax)) {
  image(t(tax[[nm]][32:1, ]), col = c("grey95", "#1f5f8b"), zlim = c(0, 1), axes = FALSE,
        main = sprintf("%s\n(%d plots)", nm, sum(tax[[nm]])), cex.main = 0.8)
  box(col = "grey60")
}
par(op)

#' 
#' | Design | Sparsity axis | Overlap | Example | Reference |
#' |---|---|---|---|---|
#' | Full overlap (common core only) | environments | full | Li et al. "CV1" allocation | @li2026 |
#' | Random cells, $\ge 1$ per genotype | environments | random | Li et al. "CV2"; Jarquin's allocation schemes | @li2026; @jarquin2020 |
#' | Balanced by genotype (one environment each) | environments | none | Li et al. "CV3"; Lubanga NOL | @li2026; @lubanga2025 |
#' | Core + unique entries | environments | partial | Li et al. "CV5"; Atanda overlap series | @li2026; @atanda2022 |
#' | Restricted random, full-sibs apart | environments | random | farm-as-incomplete-block | @werner2025 |
#' | One tester per line, sibs across testers | testers | none at line level | sparse testcrossing | @gonzalezdieguez2026 |
#' | Incomplete factorial | female x male | partial | sparse factorials | @seye2020; @lorenzi2022 |
#' 
#' : The taxonomy mapped onto the designs in the literature. Different names often describe the same structure. {#tbl-sparse-taxonomy}
#' 
#' ::: {.callout-warning}
#' ## A naming collision to watch for
#' 
#' @li2026 use **"CV1" to "CV5" as names of allocation strategies**, not of the
#' classical validation schemes of @sec-sparse-validation. Their "CV1" is the
#' full-overlap *design*. Whether the prediction task that design poses coincides
#' with the "new genotype" *validation* of @burgueno2012 is not settled here, because
#' the Methods of @li2026 were not reread for this chapter; the two should not be
#' equated. Reading the two literatures together without noticing this
#' produces wrong comparisons.
#' 
#' A second collision is inside this book, and it has three parts. @sec-hybrid-cv uses
#' CV2 / CV1 / CV0 for hybrids with both / one / neither parent seen in training --
#' the T2 / T1 / T0 of @sec-mating-genomic. Here, as in @burgueno2012, the labels
#' classify genotype x environment cells. A hybrid that is CV1 here (never planted)
#' is **CV2** in @sec-hybrid-cv when both its parents are planted in other crosses,
#' CV1 there when one parent is not, and CV0 there when neither is. @sec-hybrid-cv's
#' CV1 (one parent unseen) therefore has no counterpart label in this chapter, and
#' this chapter's CV0 (a new environment) shares only the label with that chapter's CV0.
#' In this chapter's simulation every parent is planted (a 20 x 20 factorial with
#' 20 % of the hybrids dropped at random), so every CV1 hybrid here is a T2 / CV2
#' hybrid in those terms. That is a property of the simulated design, not of the
#' definition, which also admits T1 and T0 hybrids.
#' :::
#' 
#' ## Validation schemes: what each one answers {#sec-sparse-validation}
#' 
#' The classical schemes are defined by two questions. Has the genotype been
#' observed anywhere? Has the environment been observed for anyone?
#' [@burgueno2012; @jarquin2020]
#' 
#' - **CV2**: the genotype is observed in some environments and missing in others.
#'   The task is to *complete the table*.
#' - **CV1**: the genotype is new, never observed anywhere. The task is to *predict
#'   an unseen candidate*.
#' - **CV0**: the environment is new (next year, say) and the genotypes are known.
#'   The task is to *extrapolate to an untested environment*.
#' - **CV00**: both the genotype and the environment are new. This is the hardest
#'   case, and the most realistic for long-run decisions.
#' 
#' The schemes pose different prediction tasks, so accuracies obtained under
#' different schemes are not comparable like for like. In the cached cells of this
#' chapter `acc_cv1` exceeds `acc_cv2` in `r n_cv1_gt` of the `r n_both_cv` scenario cells
#' where both exist (median difference `r sprintf("%+.3f", med_d_cv)`): neither is above
#' the other in general, and the two also differ in target (see the estimands in
#' @sec-sparse-results). The correlation is not the only metric:
#' 
#' - top-$x$ % coincidence: top 20 % by a Smith-Hazel index in @atanda2022, top 50
#'   % in @li2026;
#' - mean squared error [@lubanga2025];
#' - Kendall's $\tau$ [@hildaono2026];
#' - PEV and reliability, and the dispersion slope $b_1$ of truth on prediction.
#' 
#' At stage 1 the operationally relevant number is the **rate of wrongly discarded
#' superior candidates**. The correlation is only a proxy for it.
#' 
## -----------------------------------------------------------------------------
#| label: fig-sparse-cv
#| echo: false
#| fig-width: 7.5
#| fig-height: 4.6
#| fig-cap: "The four validation schemes as a 2 x 2 by whether the genotype (rows) and the environment (columns) were observed. Blue: training cells. Orange: the cells to be predicted."
#| fig-alt: "The four validation schemes as a 2 x 2 by whether the genotype (rows) and the environment (columns) were observed"
op <- par(mfrow = c(2, 2), mar = c(1, 1, 2.4, 1))
draw <- function(main, rows, cols) {
  M <- matrix(1, 8, 5); M[rows, cols] <- 2
  if (identical(main, "CV2: complete the table")) { M[] <- 1; M[cbind(1:8, c(2, 3, 1, 5, 4, 2, 3, 1))] <- 2 }
  image(t(M[8:1, ]), col = c("#9ecae1", "#fdae6b"), zlim = c(1, 2), axes = FALSE, main = main, cex.main = 0.85)
  box(col = "grey50")
}
draw("CV2: complete the table", NULL, NULL)
draw("CV1: new genotype", 7:8, 1:5)
draw("CV0: new environment", 1:8, 5)
draw("CV00: new genotype, new environment", 7:8, 5)
par(op)

#' 
#' ::: {.callout-tip}
#' ## Box 3 -- CV0, CV1, CV2 and CV00
#' 
#' |  | Environment observed | Environment new |
#' |---|---|---|
#' | **Genotype observed** | **CV2**: fill a missing cell. *"How does hybrid H do at location L, where it was not planted?"* | **CV0**: *"How will the known hybrids do next year?"* |
#' | **Genotype new** | **CV1**: *"How good is a hybrid that was never planted?"* In this chapter's simulation, 20 % of hybrids per replicate | **CV00**: *"How good will an untested hybrid be next year?"* |
#' 
#' In the simulation below, `acc_cv1` is measured in this sense, for the hybrids with no
#' plot. `acc_cv2` is measured on the missing cells of planted hybrids, against the
#' location-specific value of the cell (see the estimands in @sec-sparse-results).
#' :::
#' 
#' ## The empirical record across crops {#sec-sparse-evidence}
#' 
#' @tbl-sparse-primary puts the six primary studies side by side. There are two
#' maize studies, one of which is a simulation of reciprocal recurrent selection.
#' The others cover wheat, cassava and potato, and one simulates a self-pollinated
#' crop. Supporting studies cover wheat [@crespoherrera2021; @sukumaran2018],
#' sugarcane [@garciaabadillo2024], soybean [@persa2023], tropical maize
#' [@atanda2021] and potato [@proma2026].
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sparse-primary
#| tbl-cap: "The six primary studies. 'Observed' is the share of genotype x environment cells (or the equivalent) with data."
knitr::kable(ps[, c("study", "crop", "genotypes", "environments", "observed",
                    "model", "accuracy", "conclusion")],
             col.names = c("Study", "Crop", "Genotypes", "Environments", "Observed",
                           "Model", "Accuracy", "Conclusion"))

#' 
#' The anchor numbers are as follows.
#' 
#' - **Maize** [@li2026]. Mean accuracy was 0.418 under full overlap and 0.479 to
#'   0.504 under every other allocation. Returns diminish beyond about 50 %
#'   coverage: going from 50 % to 67 % cost 33 % more phenotyping and returned 3.5
#'   to 5.4 % accuracy. Top-50 % coincidence was above 61.9 % in all 25 strategies.
#' - **Wheat** [@atanda2022]. Going from 0 to 50 % common lines raised predictive
#'   ability by 42 % to 989 %, depending on the environment. Plot $h^2$ was 0.18 in
#'   the worst environment. Genetic correlations between environments in the same
#'   year ranged from $-0.04$ to $0.67$.
#' - **Cassava** [@lubanga2025]. With 20 % of records per environment, predictive
#'   ability was moderate (maxima of 0.53 for dry matter and 0.47 for fresh root
#'   yield). Phenotyping cost could be cut by up to 80 %.
#' - **Potato** [@hildaono2026]. For pairs of environments at 50 % completeness,
#'   $r^2$ was 0.995 to 0.997 with an image-derived environment kernel, against
#'   0.612 to 0.798 with the genomic kernel. Section @sec-sparse-phenomics covers
#'   the caveat.
#' 
#' The common denominator is the **genetic correlation between environments, and
#' the size and diversity of the training set**. Together they explain most of the
#' spread. In @atanda2022, the environment with low heritability and weak
#' correlations stayed poorly predicted under every design. In @li2026, plant
#' height was the trait with the strongest between-environment correlations
#' (0.36 to 0.67) and the best predicted. Grain yield had no strong correlations
#' and was predicted worst. Modelling G x E explicitly helped in every study that
#' tested it [@lubanga2025; @li2026]. **Cutting phenotyping by 50 to 80 % without
#' losing accuracy is feasible. The exact cut depends on the programme's own
#' between-environment correlations, and does not transfer between programmes.**
#' 
#' ## The minimum-overlap controversy {#sec-sparse-overlap}
#' 
#' The literature disagrees openly on how much overlap is needed:
#' 
#' - @atanda2022 conclude that "a substantial overlap between lines across
#'   environments should be used to achieve optimal prediction accuracy".
#' - @crespoherrera2021 suggest 30 to 50 common lines.
#' - @persa2023 report a gain with as few as 10.
#' - @lubanga2025 find that **more overlap made prediction worse**: predictive
#'   ability fell and MSE rose monotonically with the number of overlapping
#'   genotypes, and the fully non-overlapping design was the best.
#' - @li2026 sit in between. Full overlap was the worst design, and the four
#'   partial or non-overlapping designs tied.
#' - @werner2025 and @gonzalezdieguez2026 do without overlap altogether. All of
#'   their connectivity comes from relationships.
#' 
#' **A proposed reconciliation, offered here as a hypothesis.** The designs are not
#' comparable because they confound overlap with the size and diversity of the
#' training set:
#' 
#' - In @lubanga2025 the training set per environment is fixed in size. More
#'   overlap therefore means *fewer distinct genotypes observed*.
#' - In @atanda2022 more overlap means a *larger* calibration set per environment,
#'   growing from 46-47 lines to as many as 165.
#' 
#' A second factor is family structure. Families of 1 to 9 individuals
#' [@atanda2022] give the relationship matrix little to work with, so physical
#' overlap has to carry the connection. Families of 20 to 50 [@werner2025;
#' @gonzalezdieguez2026] let the relationship matrix carry all of it.
#' 
#' The first half of the hypothesis can be examined with the package, but only in
#' part (see below). The experiment uses four locations and a training set **fixed at 80 hybrids per
#' location** out of 400. A fraction of the 80 is a core common to all four
#' locations, and the rest are unique to each location. Family size runs from
#' unrelated lines to half-sib families of 10 (`regenerate.R sparse`, part c; 30
#' replicates per point; known components; plot $h^2 = 0.4$).
#' 
## -----------------------------------------------------------------------------
#| label: fig-sparse-overlap
#| fig-width: 7.5
#| fig-height: 4.2
#| fig-cap: "Accuracy over all 400 hybrids against the fraction of each location's 80 plots taken by a core common to all four locations, by half-sib family size. The training size is held fixed, so more overlap means fewer distinct hybrids observed (top axis). Bars are two standard errors over 30 replicates. In-repo sweep, known variance components."
#| fig-alt: "Accuracy over all 400 hybrids against the fraction of each location's 80 plots taken by a core common to all four locations, by half-sib family size"
ov <- subset(core, part == "overlap")
fs <- sort(unique(ov$family_size))
cols <- c("grey40", "#1b9e77", "#d95f02")[seq_along(fs)]
op <- par(mar = c(4.2, 4.2, 3.2, 1))
plot(NA, xlim = c(0, 1), ylim = range(ov$acc_all - 2 * ov$acc_all_se, ov$acc_all + 2 * ov$acc_all_se),
     xlab = "Overlap: fraction of each location's plots in the common core",
     ylab = "Accuracy, all hybrids")
for (i in seq_along(fs)) {
  d <- ov[ov$family_size == fs[i], ]; d <- d[order(d$overlap), ]
  lines(d$overlap, d$acc_all, type = "b", pch = 19, col = cols[i])
  arrows(d$overlap, d$acc_all - 2 * d$acc_all_se, d$overlap, d$acc_all + 2 * d$acc_all_se,
         angle = 90, code = 3, length = 0.03, col = cols[i])
}
d0 <- ov[ov$family_size == fs[1], ]; d0 <- d0[order(d0$overlap), ]
axis(3, at = d0$overlap, labels = d0$n_distinct, cex.axis = 0.8)
mtext("distinct hybrids observed", 3, line = 2, cex = 0.8)
legend("bottomleft", bty = "n", lwd = 2, col = cols,
       legend = ifelse(fs == 1, "unrelated lines", paste("half-sib families of", fs)))
par(op)

#' 
## -----------------------------------------------------------------------------
#| include: false
ovs <- split(ov, ov$family_size)
drop_ov <- sapply(ovs, function(d) d$acc_all[d$overlap == 0] - d$acc_all[d$overlap == 1])
z_ov <- sapply(ovs, function(d) {
  a <- d[d$overlap == 0, ]; b <- d[d$overlap == 1, ]
  (a$acc_all - b$acc_all) / sqrt(a$acc_all_se^2 + b$acc_all_se^2)
})
# Every pair of family sizes at the same overlap, in SE of the difference.
zs_fs <- unlist(lapply(split(ov, ov$overlap), function(d) {
  ij <- combn(nrow(d), 2)
  abs(d$acc_all[ij[1, ]] - d$acc_all[ij[2, ]]) /
    sqrt(d$acc_all_se[ij[1, ]]^2 + d$acc_all_se[ij[2, ]]^2)
}))
z_fs <- max(zs_fs)
res_fs   <- names(z_ov)[z_ov > 2]       # family sizes whose drop exceeds 2 s.e.
unres_fs <- names(z_ov)[z_ov <= 2]

#' 
#' With the training size held fixed, accuracy falls as overlap rises: it is
#' `r r4(min(drop_ov))` to `r r4(max(drop_ov))` lower under full overlap than under
#' none, `r sprintf("%.1f", min(z_ov))` to `r sprintf("%.1f", max(z_ov))` standard
#' errors of the difference depending on family size. The drop exceeds two standard
#' errors for family size `r paste(res_fs, collapse = " and ")` (1 is unrelated lines) and
#' not for family size `r paste(unres_fs, collapse = " and ")`
#' (`r sprintf("%.1f", z_ov[unres_fs[1]])` standard errors), whose curve has the same
#' direction. Every hybrid moved into the common core is one fewer distinct hybrid
#' observed (top axis), so in this design overlap and the number of distinct hybrids
#' move together by construction, and no arm varies one with the other fixed. The
#' fall in accuracy is the pattern @lubanga2025 reported and the one the confound
#' hypothesis predicts, but this experiment cannot attribute it to the fall in
#' distinct hybrids rather than to overlap as such.
#' 
#' The second half of the hypothesis is **not** supported at this scale. The
#' family-size curves cross, and they differ by at most
#' `r sprintf("%.1f", z_fs)` standard errors at any one overlap: of the
#' `r length(zs_fs)` pairs compared (every pair of family sizes at every overlap,
#' with no correction for multiple comparisons), `r sum(zs_fs > 2)` exceeded two
#' standard errors and `r sum(zs_fs > 3)` exceeded three.
#' A possible reason, not tested here, is structural. In this factorial every line
#' is a parent of 20 hybrids, of which on average 16 (no overlap) to 4 (full overlap)
#' are observed, so the factorial may carry much of the connectivity before any relationship *among lines* is added,
#' and half-sib families would add relatively little on top of that. In a
#' line-breeding programme like
#' @atanda2022, each entry is its own genotype and no parent links them, so
#' family structure should matter far more. This experiment cannot test that
#' case. The experiment also holds the training size fixed, so it does not reproduce
#' @atanda2022's design, in which more overlap also meant a larger calibration set
#' and the two effects pull in opposite directions.
#' 
#' **What to do with this.** The right question is not "how many common
#' genotypes?". It is "how much *effective* connectivity does the design have,
#' counting both physical overlap and relationships?". The experiment above
#' did not resolve an effect of relationships between lines at this scale, so it
#' does not show that physical overlap and relationships substitute for each other.
#' @atanda2022 found both the genetic correlation between environments and the
#' genomic relationship of lines across them among the drivers of sparse-testing
#' accuracy. In a factorial as dense as the simulated one, shared parents may already
#' supply much of the relationship side (a hypothesis, not tested here).
#' 
#' ## Connectivity and checks {#sec-sparse-connectivity}
#' 
#' Connectivity is not the same as overlap. Two designs with the same number of
#' common genotypes can be connected very differently, depending on *how* those
#' genotypes are distributed. Hybrids add a dimension. There is female x male
#' connectivity, the subject of @sec-mating-connectivity. There is genotype x
#' location connectivity. And there is **female x male x location**, for which no
#' metric is agreed (@sec-sparse-limits); @sec-joint-criteria gives a necessary screen and a
#' counter-example to sufficiency, and leaves the metric open. The available tools
#' are:
#' 
#' - the rank of the incidence matrix;
#' - the PEV of pairwise contrasts, and the reliability derived from it;
#' - the connected components of the genotype-environment graph.
#' 
#' **Checks** do three jobs:
#' 
#' - anchor connectivity;
#' - estimate within-environment error in unreplicated trials, as in the augmented
#'   design of @li2026;
#' - control spatial trend [@cullis2006; @williams2011].
#' 
#' Restricted randomisation is a cheap connectivity tool. @werner2025 kept
#' full-sibs apart within a location, but did not measure the restriction against
#' unrestricted randomisation. @sec-sparse-results does measure a structured
#' layout against unrestricted randomisation.
#' 
#' **Connectivity can be checked before planting.** Compute it at the planning
#' stage, rather than finding out from a model that does not converge.
#' 
#' ::: {.callout-tip}
#' ## Box 4 -- Computing the connectivity of a design before planting it
#' 
#' 1. Build the genotype x environment incidence matrix.
#' 2. Check the connected components of the bipartite graph. Every location should
#'    share hybrids, or at least parents, with every other.
#' 3. Compute the mean PEV of the target values under the intended model, with
#'    provisional variance components.
#' 4. Convert it to the per-genotype reliability $1 - \overline{\mathrm{PEV}}/\sigma^2_G$,
#'    with $\overline{\mathrm{PEV}}$ the mean over hybrids of the prediction error
#'    variance of the target value and $\sigma^2_G$ the genetic variance of
#'    @sec-sparse-foundations. This is not Cullis' $H^2$ (Box 2), which uses the
#'    variance of differences.
#' 5. Compare candidate designs on the same metric.
#' 
## -----------------------------------------------------------------------------
#| label: sparse-connectivity-recipe
#| echo: true
set.seed(8)
nF <- 20; nM <- 20; L <- 6
Af <- relmat_halfsib(nF, 5); Am <- relmat_halfsib(nM, 5)
vc <- sparse_vc(0.3)
pev_of <- function(M, y = 0) {
  cells <- which(M == 1L, arr.ind = TRUE)
  ph <- data.frame(y = y, hyb = cells[, 1], loc = cells[, 2])
  sparse_blup(ph, nF, nM, L, vc, Af, Am)$pev
}
recipe <- function(M) {
  cn <- sparse_connectivity(M, nF, nM)                        # steps 1-2
  c(plots = sum(M), fem_cover = cn$fem_cover, disconnected_pairs = cn$frac_disconn,
    reliability = 1 - mean(pev_of(M)) / vc$Vg)                # steps 3-4
}
rec <- rbind(complete_2loc = recipe(sparse_alloc(nF, nM, 2, strategy = "complete")),
             random_k2     = recipe(sparse_alloc(nF, nM, L, 2, "random")),
             parentage_k2  = recipe(sparse_alloc(nF, nM, L, 2, "parentage")))
fmt(rec, 3)
# The PEV does not depend on y: asserted, not assumed.
set.seed(9)
M0 <- sparse_alloc(nF, nM, L, 2, "random")
stopifnot(isTRUE(all.equal(pev_of(M0), pev_of(M0, y = rnorm(sum(M0))))))
# Dispersion over allocations: ten further layouts of each sparse strategy.
rel10 <- sapply(c("random", "parentage"), function(s) sapply(1:10, function(r) {
  set.seed(100 + r); recipe(sparse_alloc(nF, nM, L, 2, s))[["reliability"]] }))

#' 
## -----------------------------------------------------------------------------
#| include: false
# The level of the reliability against the realised squared accuracy, on the
# in-repo sweep (known components; 26 spread / k = 1 cells, 30 replicates each).
cr_b <- subset(core, part %in% c("spread", "k1"))
cr_b$gap <- cr_b$acc_all^2 - (1 - cr_b$pev / sparse_vc(0.4)$Vg)
gap_h <- tapply(cr_b$gap, cr_b$h2_plot, mean)
rho_b <- cor(1 - cr_b$pev / sparse_vc(0.4)$Vg, cr_b$acc_all, method = "spearman")

#' 
#' All three designs cost `r rec[1, "plots"]` plots. In the one draw above the
#' reliability is `r r4(rec["random_k2", "reliability"])` for random allocation and
#' `r r4(rec["parentage_k2", "reliability"])` for parentage, against
#' `r r4(rec["complete_2loc", "reliability"])` for the complete design in two
#' locations. Over ten further layouts of each strategy (seeds 101 to 110) the
#' reliability is `r sprintf("%.4f", mean(rel10[, "random"]))` (s.d.
#' `r sprintf("%.4f", sd(rel10[, "random"]))`) for random allocation and
#' `r sprintf("%.4f", mean(rel10[, "parentage"]))` (s.d.
#' `r sprintf("%.4f", sd(rel10[, "parentage"]))`) for parentage. The PEV depends only on the
#' design and the components, not on the data (the `stopifnot()` above), which makes
#' it a design tool and not only an evaluation metric.
#' 
#' The level is not the squared accuracy. In the in-repo sweep, the realised
#' `acc_all`$^2$ exceeds this reliability by a mean of `r sprintf("%+.3f", gap_h[["0.2"]])`
#' at $h^2 = 0.2$ and `r sprintf("%+.3f", gap_h[["0.4"]])` at $h^2 = 0.4$
#' (range `r sprintf("%+.4f", min(cr_b$gap))` to `r sprintf("%+.3f", max(cr_b$gap))`),
#' and the cause of the offset is not investigated here. The rank correlation of the
#' reliability with `acc_all` over the `r nrow(cr_b)` cells is
#' `r r2(rho_b)`. Use it to rank designs at fixed components, not to
#' predict the correlation.
#' :::
#' 
#' ## Sparse testcrossing and the number of testers {#sec-sparse-testcross}
#' 
#' The central idea of @gonzalezdieguez2026 is to treat the tester as an
#' "environment". Each line is crossed to **one** tester, but full-sibs go to
#' *different* testers. What gets evaluated against several testers is therefore
#' the haplotype, not the genotype. This removes a real logistical constraint. The
#' more accurate alternative, an incomplete factorial among candidates
#' (@sec-mating-sparse), needs hand pollination at scale and synchronised
#' flowering between pools.
#' 
## -----------------------------------------------------------------------------
#| label: fig-sparse-testcross
#| echo: false
#| fig-width: 8.5
#| fig-height: 3.2
#| fig-cap: "Sparse testcrossing. A biparental cross yields 20 DH lines; each line is crossed to one of four testers, so the family -- not the line -- meets every tester. The relationship matrix connects the full-sibs, and through them the four testers."
#| fig-alt: "Sparse testcrossing"
op <- par(mar = c(0, 0, 0, 0)); plot.new(); plot.window(c(0, 100), c(0, 40))
rect(2, 16, 16, 24, col = "grey90", border = "grey40"); text(9, 20, "P1 x P2\nbiparental", cex = 0.7)
xs <- seq(24, 66, length.out = 20)
tcol <- rep(c("#1b9e77", "#d95f02", "#7570b3", "#e7298a"), 5)
segments(16, 20, xs, 20, col = "grey75")
points(xs, rep(20, 20), pch = 21, bg = tcol, cex = 1.6)
text(45, 16.5, "20 DH full-sibs", cex = 0.75)
ty <- c(34, 26, 14, 6)
for (t in 1:4) {
  rect(84, ty[t] - 2.5, 98, ty[t] + 2.5, col = c("#1b9e77", "#d95f02", "#7570b3", "#e7298a")[t], border = NA)
  text(91, ty[t], paste("tester", t), cex = 0.7, col = "white", font = 2)
  segments(xs[tcol == tcol[t]], 20, 84, ty[t], col = adjustcolor(tcol[t], 0.4))
}
text(45, 9, "one testcross per line; the family meets all four testers", cex = 0.7, font = 3)
par(op)

#' 
#' | Testers (1,200 testcrosses per pool) | Gain in GCA accuracy over 1 tester | Gain in hybrid genetic gain, cycle 15 |
#' |---|---|---|
#' | 2, medium dominance | -- | +5.3 % |
#' | 10, low / medium / high dominance | +3 % / +11 % / +23 % | +3 % / +6 % / +11 % |
#' | 2 to 10, medium dominance | -- | +0.7 % on top of the 2-tester gain |
#' 
#' : Sparse testcrossing in @gonzalezdieguez2026: accuracy and gain against a single tester at an equal number of testcrosses. A dash means that no figure of that kind is tabulated here; the 5.3 % and 0.7 % are genetic gain in the hybrid at cycle 15, not GCA accuracy. Every sparse layout beat the single tester, and gains plateau at 5 to 10 testers; 3 to 5 is the practical recommendation. {#tbl-sparse-testers}
#' 
#' The advantage is largest in early cycles, while the pools are still close. That
#' does **not** confine the method to emerging programmes. @gonzalezdieguez2026 report
#' a minimum Nei distance of 0.17 from the public maize programme of the University of
#' Hohenheim, a figure they attribute to @legarra2023, and place it in their simulated
#' cycles 3 to 4. The $F_{ST}$ of 0.223 of @kadoumi2025, from a private programme, is
#' placed by the same reading at about cycle 2. Both figures are second-hand here: the
#' original of @legarra2023 was not read for this chapter.
#' 
#' A useful side effect is that sparse testcrossing *slowed the erosion of
#' within-pool variance*. It stops selection from piling onto closely related lines
#' that happen to nick with one tester. The authors recommend combining it with
#' optimum contribution selection (@sec-ocs; @santantonio2020hoc).
#' 
#' The advocates of incomplete factorials [@seye2020; @lorenzi2022;
#' @lorenzi2024; @melchinger2023b] reach a different conclusion. In
#' @gonzalezdieguez2026, an approximate incomplete factorial matched 3 to 5
#' testers, with much heavier logistics. Two costs were not modelled. Five testers
#' need ten isolation blocks. And in many public programmes hand pollination is
#' already routine, which lowers the extra cost of the factorial.
#' 
#' ::: {.callout-tip}
#' ## Box 5 -- Choosing testers: theory against practice
#' 
#' The classical recommendation is a *low-performing* tester, or one carrying
#' recessive alleles at the loci of interest. Such a tester discriminates among
#' candidates best (a recommendation classically attributed to @hull1945 and
#' @rawlings1962, not checked at page level here). Commercial practice uses *elite*
#' testers, chosen for seed production and *per se* performance, because the
#' testcross may itself become a product. The consequence follows from
#' @sec-heterosis-gca-sca: GCA is measured *against the tester's allele
#' frequencies*. An elite tester carries the favourable allele at many loci and
#' shrinks the visible differences there, so a few elite testers sample the
#' opposite pool's frequencies poorly. Several testers spread across the pool,
#' the sparse-testcross recipe, sample them better [@longin2006c; @dejong2023].
#' :::
#' 
#' ## What sparsity does to variance components and to the BLUP {#sec-sparse-components}
#' 
#' Two questions are often merged in the literature, and they should be kept
#' separate:
#' 
#' 1. Do the predictions stay accurate?
#' 2. Do the variance-component estimates stay unbiased?
#' 
#' The second is barely covered. **None of the six primary studies reports bias in
#' the GCA, SCA or G x E variances ($\sigma^2_f$, $\sigma^2_m$, $\sigma^2_s$,
#' $\sigma^2_{GE}$) under sparsity.** The
#' indirect evidence is thin:
#' 
#' - In @hildaono2026 the G x E term *degraded* prediction under high sparsity,
#'   because there were too few individuals to estimate it. The authors recommend
#'   dropping it in that regime.
#' - In @li2026 propagating prediction uncertainty barely changed the GCA estimates
#'   (correlation 0.9974 to 0.9998 with the point estimates). That is a sensitivity
#'   of GCA, not of the variance components.
#' 
#' Two diagnostics separate the questions.
#' 
#' - **The dispersion slope $b_1$**, from regressing truth on prediction. $b_1 = 1$
#'   means no scale bias. $b_1 < 1$ means the predictions are too spread out, and
#'   $b_1 > 1$ means they are over-shrunk.
#' - **PEV and reliability.** These can be computed *before* any data exist
#'   (Box 4), so they serve as design tools.
#' 
#' Accuracy and estimation quality do not degrade at the same rate.
#' **A design can rank candidates well and still estimate the SCA and G x E
#' variances badly** [@cullis2006; @piepho2007; @smith2018; @tolhurst2019]. The
#' simulation of @sec-sparse-results measures this directly. That is the gap in
#' the primary literature it was designed to fill.
#' 
#' ## Sparse testing with phenomics {#sec-sparse-phenomics}
#' 
#' Phenomic data pose a specific problem. Markers can be read from a seedling
#' whatever happens in the field. Sensor data exist only for plots that were
#' actually grown, so they cannot serve as a covariate for an individual that was
#' never observed. There are three ways out:
#' 
#' - multi-trait models with image indices as secondary traits;
#' - kernel regression on the indices;
#' - the proposal of @hildaono2026: use the images to build an **environment**
#'   kernel.
#' 
#' The environment kernel is built in three steps. A PCA of the image traits is
#' run *within each environment*. The first-component eigenvector of each
#' environment is extracted. The kernel entries are the correlations between those
#' eigenvectors.
#' 
#' At 30 % data availability the comparison varied with the combination of
#' environments. Across all scenarios with at least 33 % complete data per
#' environment, the environment kernel matched or outperformed the genomic kernel,
#' reaching $r^2 = 0.997$ on pairs of environments. At 10 and 20 % no consistent
#' trend emerged [@hildaono2026]. **The authors warn of possible
#' information leakage**, because the kernel came from the same trial that supplied
#' training and validation. The result should be reported with that caveat.
#' 
## -----------------------------------------------------------------------------
#| label: fig-sparse-phenomics
#| echo: false
#| fig-width: 9
#| fig-height: 2.8
#| fig-cap: "Building an environment kernel from images, after Hild Aono and Chawade (2026). The dashed box marks where training and validation share information -- the leakage the authors flag."
#| fig-alt: "Building an environment kernel from images, after Hild Aono and Chawade (2026)"
op <- par(mar = c(0, 0, 0, 0)); plot.new(); plot.window(c(0, 100), c(0, 30))
labs <- c("UAV RGB images\nper environment", "6 indices,\narea under\ntime curve",
          "PCA within\neach\nenvironment", "PC1 eigenvectors,\ncorrelated\nacross envs", "kernel E\nin G + E model")
xs <- c(2, 22, 42, 62, 82)
for (i in 1:5) {
  rect(xs[i], 9, xs[i] + 16, 23, col = if (i == 5) "#c7e9c0" else "grey92", border = "grey40")
  text(xs[i] + 8, 16, labs[i], cex = 0.68)
  if (i < 5) arrows(xs[i] + 16, 16, xs[i + 1], 16, length = 0.07)
}
rect(0.5, 5, 81, 26, lty = 2, border = "#d95f02")
text(40, 2.5, "same trial supplies training and validation -> possible leakage", cex = 0.7, col = "#d95f02")
par(op)

#' 
#' The approach is attractive for programmes without routine genotyping. It is also
#' promising for maize, where sensor phenotyping exists but has not been tested in
#' this arrangement with hybrids. It connects to envirotyping. When locations are
#' close together, coarse-grid weather covariates discriminate poorly, and images
#' capture differences that the weather data miss [@costaneto2020; @crossa2021;
#' @rincent2017]. NIRS-based phenomic prediction in maize points the same way, in a
#' non-sparse setting [@desalvio2024].
#' 
#' **Sensor data enter sparse testing as descriptors of environments, not of
#' genotypes.** This inversion solves the availability problem. In programmes that
#' genotype little, it can partly replace the genomic matrix.
#' 
#' ## Simulation as a sizing tool {#sec-sparse-simulation}
#' 
#' ### Why simulate before designing
#' 
#' None of the published numbers transfers directly to another programme. Each one
#' depends on the between-environment correlations, the family structure, the
#' $\sigma^2_{SCA}/\sigma^2_{GCA}$ ratio and the heritability of the programme that
#' produced it, and the authors say so themselves [@werner2025;
#' @gonzalezdieguez2026]. A simulation can do three things an experiment cannot:
#' 
#' - it knows the true values;
#' - it can rerun the programme a hundred times;
#' - it can isolate one factor at a time.
#' 
#' The tools exist. AlphaSimR covers the genetics [@gaynor2021; @sec-alphasimr],
#' FieldSimR covers plots and G x E [@werner2024], and `sommer` or BGLR fit the
#' models [@covarrubiaspazaran2016]. Staged-allocation theory provides the
#' deterministic cross-check [@mi2014; @longin2006b]. **Simulation does not replace
#' the experiment. It replaces guessing at the design of the experiment.**
#' 
#' ### Realistic parameters: what the literature supplies
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sparse-parameters
#| tbl-cap: "Reference parameters from the six primary studies. 'Derived' marks a value computed from reported components rather than reported directly. The ranges of genotypes, environments and cells observed are taken from @tbl-sparse-primary; the 'environments' row mixes locations and location-years."
knitr::kable(lp[, c("parameter", "value", "source", "derived")],
             col.names = c("Parameter", "Value", "Source", "Derived"))

#' 
#' Two features of real data a simulation must respect:
#' 
#' 1. **Environmental variance exceeds genetic variance by an order of magnitude.**
#'    For maize grain yield, the ratio of environment to genotype variance is about
#'    8.1 (1.13 / 0.14, in the notation of @li2026; their genotype variance is
#'    not the $\sigma^2_g$ of @sec-mating) [@li2026].
#' 2. **Between-environment correlations for yield are often weak.** Scenarios
#'    should be anchored on measured parameters, not chosen for numerical
#'    convenience.
#' 
#' ### What the simulation finds {#sec-sparse-results}
#' 
#' **The model.** The study simulated a female x male factorial of single crosses,
#' tested with **one plot per hybrid x location cell**. The phenotype is
#' 
#' $$
#' y = \mu + \text{loc} + \mathrm{GCA}^f + \mathrm{GCA}^m + \mathrm{SCA}
#'   + \mathrm{GCA}^f{\times}\text{loc} + \mathrm{GCA}^m{\times}\text{loc}
#'   + \mathrm{SCA}{\times}\text{loc} + e .
#' $$
#' 
#' The target is the value in the TPE, $\mathrm{GCA}^f + \mathrm{GCA}^m +
#' \mathrm{SCA}$. In every replicate,
#' **`r pc(mean(sc$n_cv1_mean / sc$nHyb), 0)` of the hybrids get no plot at all.**
#' These are the CV1 hybrids, predicted only through relationships.
#' 
#' **The estimands.** Three accuracies are reported, and they are three different
#' correlations, computed within a replicate and then averaged over replicates.
#' `acc_all` is the Pearson correlation between a hybrid's BLUP and its true TPE value
#' $\mathrm{GCA}^f + \mathrm{GCA}^m + \mathrm{SCA}$, over all 400 hybrids of the
#' factorial, planted or not. `acc_cv1` is the same correlation over the hybrids with no
#' plot. `acc_cv2` is the correlation, over the missing cells of planted hybrids, between
#' the location-specific prediction and the location-specific true value (which
#' includes the interactions with location, among them $\mathrm{SCA}\times\text{loc}$,
#' which the analysis model cannot carry). None of the three is the `acc_gca_all` of
#' @sec-mating, a correlation of GCA estimates with true GCA over lines. For the in-repo
#' sweep these definitions are those of `one_fit()` in `regenerate.R`; for the cached
#' REML study they are assumed to be the same, and the code of that study is not in
#' this repository.
#' 
#' **The planted share.** In the in-repo sweep the 80 % of hybrids that are planted are
#' drawn at random from the 20 x 20 factorial (the cached study is described as leaving
#' 20 % untested, and its mechanism is assumed to be the same), so every line stays a
#' parent of about 16 planted crosses.
#' That makes the "CV1 is T2" correspondence of the callout above true here, and it
#' makes shared parents abundant. Both are properties of this configuration (see Scope).
#' 
#' **The calibration** is `sparse_vc()`:
#' 
#' - $\sigma^2_f = \sigma^2_m = 1$ and $\sigma^2_s = \sigma^2_{SCA} = 0.25$, so that
#'   $\sigma^2_G = `r vc_ex$Vg`$ and $\sigma^2_s/\sigma^2_g = 0.25$;
#' - every interaction with location is half its main effect, so that
#'   $\sigma^2_{GE} = `r vc_ex$VgxE`$;
#' - plot $h^2 = \sigma^2_G/(\sigma^2_G + \sigma^2_{GE} + \sigma^2_e)$ of 0.20 or 0.40,
#'   which fixes $\sigma^2_e$.
#' 
#' In `sparse_vc()` the components are `s2f`, `s2m`, `s2s` ($\sigma^2_{SCA}$),
#' `s2fl`, `s2ml` (the two GCA x location variances), `s2sl`
#' ($\sigma^2_{SCA\times L}$, written $\sigma^2_{s\ell}$ in @sec-joint-model) and
#' `s2e`; `s2res` is the residual of the analysis model,
#' $\sigma^2_{res} = \sigma^2_{SCA\times L} + \sigma^2_e$.
#' 
#' These choices imply a genetic correlation between locations of
#' $\sigma^2_G/(\sigma^2_G+\sigma^2_{GE}) = `r r4(vc_ex$Vg / (vc_ex$Vg + vc_ex$VgxE))`$.
#' That sits inside the 0.36 to 0.67 measured for plant height in maize [@li2026] and
#' close to the 0.60 of @werner2025. The ratio $\sigma^2_s/\sigma^2_g$ of 0.25 lies
#' among the values reported by @gonzalezdieguez2026 for their own ratio. The plot
#' heritabilities 0.2 and 0.4 lie above the 0.10 of @werner2025's founder population.
#' The 0.30 of @gonzalezdieguez2026 is a broad-sense $H^2$ over all hybrids, a different
#' quantity from the plot-level $h^2$ of Box 2, so it does not bracket the values here.
#' Plot heritability is also defined differently in the other chapters: in @sec-mating
#' the interaction with location is folded into the plot error, and in
#' @sec-genomic-prediction it is the heritability in a single environment. The three
#' values are not on one scale.
#' 
#' **The four strategies**, all at the same cost of $k$ locations per hybrid out
#' of $L$ in the trial ($k$ is not the testers per pool of @sec-mating):
#' 
#' - *complete*;
#' - *random*: each hybrid goes to $k$ locations drawn at random;
#' - *optimised blocks*: an exchange algorithm on the mixed-model coefficient
#'   matrix, with replicated checks;
#' - *parentage*: the factorial is cut into cyclic groups, each holding every
#'   female and every male, and groups are dealt to locations so that **every
#'   location receives both whole pools** (the rule that @sec-joint calls `coverage`).
#' 
#' The last is `sparse_alloc(strategy = "parentage")`.
#' 
#' **Validation of the estimator.** Before any comparison, the estimator was checked
#' on the complete design, where REML must recover the true components
#' (@tbl-sparse-validation).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sparse-validation
#| tbl-cap: "Component recovery by REML in the COMPLETE design (20 x 20 hybrids, 6 locations, 30 replicates per heritability as the study reports; cached, and the replicate-level values are not in the CSV). $t$ is the mean estimate minus the truth over its standard error. The residual target is $\\sigma^2_{res} = \\sigma^2_{SCA\\times L} + \\sigma^2_e$, because with one plot per cell the analysis model absorbs SCA x location into the residual."
v <- val; v$component <- sub("s2", "s2_", v$component)
knitr::kable(fmt(v[, c("h2_plot", "component", "true", "mean_est", "relbias_pct", "se_relbias_pct", "t")], 3),
             col.names = c("Plot h2", "Component", "True", "Mean estimate", "Rel. bias %", "SE %", "t"))

#' 
#' For every component except SCA, $|t| \le$ `r sprintf("%.1f", max(abs(val$t[val$component != "s2s"])))`.
#' For $\sigma^2_{SCA}$ the relative bias is
#' `r sprintf("%+.1f", val$relbias_pct[val$component == "s2s" & val$h2_plot == 0.2])` %
#' ($t$ = `r sprintf("%.2f", val$t[val$component == "s2s" & val$h2_plot == 0.2])`, two-sided
#' $p$ = `r sprintf("%.3f", 2 * pt(-abs(val$t[val$component == "s2s" & val$h2_plot == 0.2]), 29))`
#' on 29 degrees of freedom, taking the 30 replicates of the caption) at $h^2 = 0.2$ and
#' `r sprintf("%+.1f", val$relbias_pct[val$component == "s2s" & val$h2_plot == 0.4])` %
#' ($t$ = `r sprintf("%.2f", val$t[val$component == "s2s" & val$h2_plot == 0.4])`,
#' $p$ = `r sprintf("%.2f", 2 * pt(-abs(val$t[val$component == "s2s" & val$h2_plot == 0.4]), 29))`)
#' at $h^2 = 0.4$. It is positive in both, detectable at the uncorrected 5 % level at
#' one of the two heritabilities, and neither passes a Bonferroni threshold over the
#' `r nrow(val)` tests of the table (`r sprintf("%.4f", 0.05 / nrow(val))`). The SCA variance
#' is a small component (`r pc(vc_ex$s2s / vc_ex$Vg, 0)` of $\sigma^2_G$), and a procedure
#' bounded below at zero could produce an upward bias for a small component; that
#' explanation is not tested here. The bias exists in the complete design, where there is
#' no sparsity, so it is not an effect of sparsity. Every later SCA number has to be read
#' against it.
#' 
#' The grid has 2,630 fits:
#' 
#' - 100 and 400 hybrids;
#' - 2, 4, 6 and 10 locations;
#' - the share $p$ of hybrid x location cells observed, `p_real` in the cached grid
#'   (the realised share; the file has no nominal column), from
#'   `r pc(min(sc$p_real), 0)` to `r pc(max(sc$p_real), 0)`;
#' - two heritabilities;
#' - 15 replicates per cell at 400 hybrids, 9 to 15 at 100.
#' 
#' #### 1. A sparse allocation can come within 5 % of the complete design; the margin is thin
#' 
## -----------------------------------------------------------------------------
#| label: fig-sparse-frontier
#| fig-width: 9
#| fig-height: 4.2
#| fig-cap: "Left: accuracy against plots for 400 hybrids at plot h2 = 0.4, one curve per number of locations (parentage and complete designs; complete marked with an open circle). Right: accuracy at a FIXED cost of two plots per hybrid, spread over 2 to 10 locations, random allocation, both heritabilities. Cached study, REML components, 15 replicates."
#| fig-alt: "Left: accuracy against plots for 400 hybrids at plot h2 = 0.4, one curve per number of locations (parentage and complete designs; complete marked with an open circle)"
op <- par(mfrow = c(1, 2), mar = c(4.2, 4.2, 2, 1))
d <- subset(s4, h2_plot == 0.4 & strategy %in% c("parentage", "complete"))
Ls <- sort(unique(d$nLoc)); lc <- hcl.colors(length(Ls), "Dark 3")
plot(NA, xlim = range(d$n_plots_mean), ylim = range(d$acc_all_mean),
     xlab = "Plots", ylab = "Accuracy, all hybrids", main = "Cost-accuracy, h2 = 0.4", cex.main = 0.9)
for (i in seq_along(Ls)) {
  e <- d[d$nLoc == Ls[i], ]; e <- e[order(e$n_plots_mean), ]
  lines(e$n_plots_mean, e$acc_all_mean, type = "b", pch = ifelse(e$strategy == "complete", 1, 19), col = lc[i])
}
legend("bottomright", bty = "n", col = lc, lwd = 2, legend = paste(Ls, "locations"), cex = 0.8)
sp <- subset(s4, k == 2 & strategy %in% c("complete", "random"))
plot(NA, xlim = c(2, 10), ylim = range(sp$acc_all_mean), xlab = "Locations sharing the 2 plots per hybrid",
     ylab = "Accuracy, all hybrids", main = sprintf("Same %.0f plots, spread wider", mean(sp$n_plots_mean)), cex.main = 0.9)
for (h in c(0.2, 0.4)) {
  e <- sp[sp$h2_plot == h, ]; e <- e[order(e$nLoc), ]
  lines(e$nLoc, e$acc_all_mean, type = "b", pch = 19, lty = ifelse(h == 0.2, 2, 1))
}
legend("bottomright", bty = "n", lty = c(1, 2), pch = 19, legend = c("plot h2 = 0.4", "plot h2 = 0.2"), cex = 0.8)
par(op)

#' 
## -----------------------------------------------------------------------------
#| include: false
m5 <- subset(mn, nHyb == 400 & h2_plot == 0.4 & sca_level == "low" & nLoc == 10 & minimal_5)
coinc_ref <- subset(s4, strategy == "complete" & nLoc == 10 & h2_plot == 0.4)$coinc_t5_truth_mean
coinc_m5  <- subset(s4, strategy == m5$strategy & nLoc == 10 & k == m5$k & h2_plot == 0.4)$coinc_t5_truth_mean

#' 
#' Take 400 hybrids at $h^2 = 0.4$. The complete design over ten locations (3,200
#' plots) reaches an accuracy of `r r4(ref[["0.4"]])`. The **cheapest allocation
#' within 5 % of that** is the `r m5$strategy` design with `r m5$k` locations per
#' hybrid. It uses `r round(m5$n_plots_mean)` plots, `r pc(m5$cost_rel, 0)` of the
#' budget, and reaches `r r4(m5$acc_all_mean)`, which is `r pc(m5$acc_rel)` of the
#' reference. Coincidence with the true top 5 % falls from `r pc(coinc_ref, 1)`
#' to `r pc(coinc_m5, 1)`. At $h^2 = 0.2$ the cheapest cell within 5 % is the
#' `r c_lo$m$strategy` design with `r c_lo$m$k` locations per hybrid, `r round(c_lo$m$n_plots_mean)` plots,
#' `r pc(c_lo$m$cost_rel, 0)` of the budget. @tbl-sparse-minimal lists every scenario.
#' 
#' **How thin this is.** The margin of the 400-hybrid cell over the 95 % line is
#' `r sprintf("%.4f", c_hi$margin)` accuracy units, against a standard error of
#' `r sprintf("%.4f", c_hi$se_margin)` for that difference, so it passes by
#' `r sprintf("%.1f", c_hi$margin / c_hi$se_margin)` standard errors (the cell at
#' $h^2 = 0.2$ passes by `r sprintf("%.1f", c_lo$margin / c_lo$se_margin)`). Each is the
#' cheapest passing cell among `r c_hi$n_cand` candidates at ten locations, selected on
#' the same cached means that are then reported, so the relative accuracy of the
#' selected cell is optimistic by a winner's-curse amount that is not estimated here.
#' The fall in coincidence with the true top 5 % (20 of the 400 hybrids) is
#' `r sprintf("%.1f", 100 * c_hi$d_coinc)` $\pm$ `r sprintf("%.1f", 100 * c_hi$se_coinc)`
#' percentage points over 15 replicates. No interval is attached to the relative
#' accuracy or the relative cost of the table. The statement "wider at higher
#' heritability" compares one selected cell per heritability, at one number of locations,
#' without replicate-level dispersion for the comparison. The qualitative reading, that
#' a layout using about a fifth to a half of the plots comes close to the complete design,
#' rests on those two cells and is not a general margin.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sparse-minimal
#| tbl-cap: "Cheapest allocation within 5 % and within 10 % of the accuracy of the complete design at the largest number of locations in each scenario. The thresholds were chosen by the author; the cells are selected on the same means that are reported, and no interval is attached. Cached study."
m <- mn; m$within <- ifelse(m$minimal_5, "5 %", "10 %")
m <- m[order(m$nHyb, m$h2_plot, m$sca_level, m$nLoc, m$within), ]
knitr::kable(fmt(m[, c("nHyb", "h2_plot", "sca_level", "nLoc", "within", "strategy", "k",
                       "n_plots_mean", "acc_all_mean", "acc_rel", "cost_rel")], 3),
             row.names = FALSE,
             col.names = c("Hybrids", "Plot h2", "SCA", "Locations", "Within", "Strategy", "k",
                           "Plots", "Accuracy", "Rel. accuracy", "Rel. cost"))

#' 
#' #### 2. At fixed cost, spreading plots over locations beats concentrating them
#' 
## -----------------------------------------------------------------------------
#| include: false
spr <- function(h, L) subset(s4, k == 2 & nLoc == L & h2_plot == h &
                                 strategy %in% c("complete", "random"))$acc_all_mean
# The panel's claim: one plot count and one planted fraction in every cell.
stopifnot(length(unique(sp$n_plots_mean)) == 1L, all(sp$n_plots_se == 0),
          length(unique(sp$conn_n_obs_hyb_mean / sp$nHyb)) == 1L,
          isTRUE(all.equal(sp$n_plots_mean, 2 * sp$conn_n_obs_hyb_mean)),
          length(unique(sc$n_cv1_mean / sc$nHyb)) == 1L)

#' 
#' This is the most actionable result (@fig-sparse-frontier, right). Each planted
#' hybrid keeps **two plots** (the `r pc(mean(sp$conn_n_obs_hyb_mean / sp$nHyb), 0)`
#' of the factorial that is planted, so
#' `r sprintf("%.0f", mean(sp$n_plots_mean))` plots in every design of the panel),
#' the cost of a two-location trial of those hybrids. At
#' $h^2 = 0.4$, accuracy rises from `r r4(spr(0.4, 2))` with both plots in the same
#' two locations to `r r4(spr(0.4, 4))`, `r r4(spr(0.4, 6))` and
#' `r r4(spr(0.4, 10))` as those plots are spread across 4, 6 and 10 locations. At
#' $h^2 = 0.2$ it rises from `r r4(spr(0.2, 2))` to `r r4(spr(0.2, 10))`. Not one
#' extra plot is spent, and no planted hybrid gains a location: each is still in two.
#' What grows is the number of environments the trial samples, and with it the
#' number of locations over which each parent's crosses, and so its GCA, are
#' spread. The gain saturates between six and ten locations. This slice never
#' varied the locations per hybrid and never traded a location against a
#' replicate, so it measures only the value of sampling more trial sites at a
#' fixed number of plots -- the "broader sampling of trial sites" of
#' @werner2025 -- not a trade against replication.
#' 
#' #### 3. Parentage minus random allocation is small, and not resolved after correction
#' 
#' The cached study provides `r n_ct` contrasts against random allocation, and
#' @tbl-sparse-contrasts lists all of them: that is the family. The multiplicity rule is
#' Bonferroni over the family, a threshold of `r sprintf("%.4f", 0.05 / n_ct)` on $p$
#' (the column $p_{Bonf}$ is $p$ times `r n_ct`, capped at 1). The contrasts are not
#' independent (the metrics are correlated, and the same replicates enter every row), so
#' the rule is conservative. The rows for $k \le 2$ exist for `acc_cv1` only; they are
#' **exploratory**: the file does not record whether that subset was specified before the
#' data were seen, and it was not computed for the other metrics.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sparse-contrasts
#| tbl-cap: "Every contrast of the cached study against random allocation. Paired by replicate in the fast layer (791 pairs, which are replicate x cell and pool heterogeneous cells; 385 with k <= 2) and in the genomic layer (32 pairs). acc_cv1: hybrids never planted; acc_cv2: missing cells of planted hybrids; coinc_t5_truth: share of the true top 5 % that the BLUP also puts in its top 5 %. p_Bonf = min(1, p x number of rows). The k <= 2 rows are exploratory. Cached study; the replicate-level file is not in the repository."
cc <- ct
cc$p_Bonf <- pmin(1, nrow(ct) * cc$p)
knitr::kable(fmt(cc[, c("layer", "contrast", "metric", "subset", "n", "diff", "se", "p", "p_Bonf")], 4),
             row.names = FALSE,
             col.names = c("Layer", "Contrast", "Metric", "Subset", "n", "Difference", "SE", "p", "p_Bonf"))

#' 
#' In the fast layer, parentage minus random is `r r4s(p_all$diff)` $\pm$
#' `r sprintf("%.4f", p_all$se)` on `acc_all` ($p$ = `r sprintf("%.3f", p_all$p)`),
#' `r r4s(p_cv1$diff)` $\pm$ `r sprintf("%.4f", p_cv1$se)` on `acc_cv1`
#' ($p$ = `r sprintf("%.3f", p_cv1$p)`), `r r4s(p_cv2$diff)` $\pm$
#' `r sprintf("%.4f", p_cv2$se)` on `acc_cv2` ($p$ = `r sprintf("%.4f", p_cv2$p)`), and
#' `r r4s(p_coi$diff)` $\pm$ `r sprintf("%.4f", p_coi$se)` on `coinc_t5_truth`
#' ($p$ = `r sprintf("%.2f", p_coi$p)`). The coincidence is the operational metric of the
#' validation section, the rate at which the true top 5 % is not wrongly discarded; it
#' shows nothing, for parentage or for the optimised blocks (`r r4s(o_coi$diff)` $\pm$
#' `r sprintf("%.4f", o_coi$se)`, $p$ = `r sprintf("%.2f", o_coi$p)`). The smallest $p$ of
#' the family is `r sprintf("%.4f", min(ct$p))`, above the Bonferroni threshold, so no
#' contrast is resolved after correction. In the exploratory subset $k \le 2$,
#' parentage minus random on `acc_cv1` is `r r4s(p_k2$diff)` $\pm$
#' `r sprintf("%.4f", p_k2$se)` ($p$ = `r sprintf("%.3f", p_k2$p)`) and the optimised
#' blocks give `r r4s(o_k2$diff)` $\pm$ `r sprintf("%.4f", o_k2$se)`. In the genomic layer
#' (marker relationships, real dominance, 32 pairs) the parentage difference on `acc_all`
#' is `r sprintf("%+.3f", p_gen$diff)` $\pm$ `r sprintf("%.3f", p_gen$se)`
#' ($p$ = `r sprintf("%.3f", p_gen$p)`, $p_{Bonf}$ =
#' `r sprintf("%.2f", min(1, n_ct * p_gen$p))`).
#' 
#' Interpretation, with its limits. Parentage minus random is positive on all four fast-layer
#' metrics, by 0.005 to 0.009 in correlation units, and is resolved at the uncorrected 5 %
#' level on `acc_cv1` and `acc_cv2` only. Because `acc_cv2` (missing cells of *planted*
#' hybrids) shows a difference as resolved as `acc_cv1` (never-planted hybrids), the
#' advantage is not limited to hybrids the field never saw. The effect, if real, is small,
#' and the metric on which a breeder's decision rests does not show it. Three limits apply
#' to all of this. (i) The cached parentage arm comes from the search whose criterion
#' returned $-\infty$ for a disconnected start (@sec-sparse-reproduce), so these
#' contrasts concern that allocation and not `sparse_alloc("parentage")` of this
#' repository. (ii) The replicate-level file is not in the repository: the pairing, the
#' unit of replication and the standard errors cannot be rechecked, and the 791 pairs
#' pool heterogeneous cells. (iii) At $k = 1$ the in-repo sweep does not resolve the
#' difference either (@sec-sparse-reproduce).
#' 
#' None of the six primary studies compared a structured allocation with a random
#' one. @li2026 found their structured schemes tied with each other. @werner2025
#' used restricted randomisation without a random control. The comparison was made
#' here for the hybrid case, with the result above: a small advantage, not resolved
#' after multiplicity correction, in the one dense configuration simulated.
#' 
## -----------------------------------------------------------------------------
#| label: fig-sparse-genomic
#| fig-width: 7.5
#| fig-height: 4
#| fig-cap: "Genomic layer (AlphaSimR genomes, marker relationships, 8 replicates): accuracy against the share of cells observed, by strategy and number of locations. Cached study."
#| fig-alt: "Genomic layer (AlphaSimR genomes, marker relationships, 8 replicates): accuracy against the share of cells observed, by strategy and number of locations"
a <- aggregate(acc_all ~ strategy + nLoc + p_real, gl, mean)
op <- par(mar = c(4.2, 4.2, 1, 1))
plot(NA, xlim = range(a$p_real), ylim = range(a$acc_all), xlab = "Share of cells observed",
     ylab = "Accuracy, all hybrids")
for (s in names(strat_col)) for (L in unique(a$nLoc)) {
  e <- a[a$strategy == s & a$nLoc == L, ]; e <- e[order(e$p_real), ]
  if (nrow(e)) lines(e$p_real, e$acc_all, type = "b", pch = ifelse(L == 4, 19, 17),
                     lty = ifelse(L == 4, 1, 2), col = strat_col[s])
}
legend("bottomright", bty = "n", cex = 0.8, col = c(strat_col, "black", "black"),
       lty = c(1, 1, 1, 1, 1, 2), pch = c(NA, NA, NA, NA, 19, 17),
       legend = c(names(strat_col), "4 locations", "8 locations"))
par(op)

#' 
#' #### 4. Whether parent coverage, rather than shared hybrids, carries the connectivity is not decided
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sparse-coverage
#| tbl-cap: "The one cell on which the coverage account rests: 400 hybrids, low SCA, 10 locations, k = 2, plot h2 = 0.4, 15 replicates per strategy. Accuracy over all hybrids with its standard error; female coverage (mean fraction of females present per location); concurrence (hybrids shared by a pair of locations, harmonic mean, which is 0 as soon as one pair shares nothing, and arithmetic mean); fraction of location pairs sharing no hybrid; coincidence with the true top 5 %. Cached study."
tc <- c10[match(c("random", "parentage", "optimised_blocks"), c10$strategy), ]
knitr::kable(fmt(data.frame(
  Strategy = tc$strategy, Accuracy = tc$acc_all_mean, SE = tc$acc_all_se,
  `Female coverage` = tc$conn_fem_cover_mean, `Concurrence (harmonic)` = tc$conn_conc_hmean_mean,
  `Concurrence (mean)` = tc$conn_conc_mean_mean,
  `Disconnected pairs` = tc$conn_frac_disconn_mean,
  `Top-5 % coincidence` = tc$coinc_t5_truth_mean, check.names = FALSE), 3),
  row.names = FALSE)

#' 
#' Result. At ten locations with two per hybrid and $h^2 = 0.4$, the accuracies are
#' `r r4(cv("parentage", "acc_all_mean"))` for parentage (s.e. `r r4(cv("parentage", "acc_all_se"))`),
#' `r r4(cv("random", "acc_all_mean"))` for random allocation (`r r4(cv("random", "acc_all_se"))`) and
#' `r r4(cv("optimised_blocks", "acc_all_mean"))` for the optimised blocks
#' (`r r4(cv("optimised_blocks", "acc_all_se"))`). Parentage minus random is
#' `r r4s(cv("parentage", "acc_all_mean") - cv("random", "acc_all_mean"))`, $z$ =
#' `r sprintf("%.2f", z_pr)` from the cached standard errors, unpaired: not resolved. The
#' parentage design shares no hybrid between `r pc(cv("parentage", "conn_frac_disconn_mean"), 1)`
#' of the location pairs, against a structural minimum of
#' `r pc((choose(10, 2) - 20) / choose(10, 2), 1)` (twenty groups at two locations each
#' touch at most 20 of the 45 pairs); its female coverage is
#' `r r4(cv("parentage", "conn_fem_cover_mean"))`, against
#' `r r4(cv("random", "conn_fem_cover_mean"))` for random allocation. The optimised blocks
#' have the highest concurrence (`r sprintf("%.1f", cv("optimised_blocks", "conn_conc_hmean_mean"))`
#' hybrids per pair of locations, against `r sprintf("%.1f", cv("random", "conn_conc_hmean_mean"))`
#' for random) and female coverage `r r4(cv("optimised_blocks", "conn_fem_cover_mean"))`,
#' and are not more accurate than random allocation
#' (`r r4s(cv("optimised_blocks", "acc_all_mean") - cv("random", "acc_all_mean"))`,
#' $z$ = `r sprintf("%.2f", z_or)`). The pooled paired contrast of result 3 for parentage
#' on `acc_all` is `r r4s(p_all$diff)` $\pm$ `r sprintf("%.4f", p_all$se)` ($p$ =
#' `r sprintf("%.3f", p_all$p)`).
#' 
#' Interpretation, with its limits. The account that fits parentage alone is that a
#' layout keeping both pools in every location connects the trial through shared
#' parents, and does not need shared hybrids. The optimised blocks, which have nearly the
#' same coverage and the most shared hybrids, gain nothing over random allocation, so
#' high coverage together with high overlap did not help in this cell. Across the three
#' arms coverage and concurrence are not varied independently: no arm varies one
#' with the other fixed, so these data cannot separate "parent coverage, not shared
#' hybrids" from the opposite reading, and the effect that parentage shows is itself not
#' resolved. The cached parentage arm is the one from the search with the defective
#' criterion (@sec-sparse-reproduce), so the fraction of disconnected pairs above is for
#' that layout and sits above the structural minimum. The in-repo overlap sweep
#' (@sec-sparse-overlap) has no coverage arm either. Finally, in this 80 % planted 20 x 20
#' factorial every line is a parent of about 16 planted crosses, so parents are shared by
#' construction; in the sparse factorials of @sec-mating (two to ten crosses per line out
#' of 200 candidates per pool) they are not, and a coverage rule does not come for free
#' there. Whether coverage accounts for the @atanda2022 versus @lubanga2025
#' disagreement remains a hypothesis (@sec-sparse-overlap).
#' 
#' #### 5. In the cached grid, dispersion is small where REML converged; the SCA variance is poorly recovered
#' 
## -----------------------------------------------------------------------------
#| label: fig-sparse-estimates
#| fig-width: 9
#| fig-height: 4.2
#| fig-cap: "Left: median relative bias of REML components and of plot h2 by locations per hybrid k, over all cached scenarios (the values are in the table below). Right: the dispersion slope b1 (truth on BLUP), one point per scenario; the dashed line is no dispersion bias. Scenarios with k = 1 and incomplete REML convergence produce the outliers (axis clipped at 0.5-1.5)."
#| fig-alt: "Left: median relative bias of REML components and of plot h2 by locations per hybrid k, over all cached scenarios"
med <- aggregate(cbind(relbias_s2f_mean, relbias_s2fl_mean, relbias_s2s_mean, relbias_h2_mean) ~ k, sc, median)
op <- par(mfrow = c(1, 2), mar = c(4.2, 4.2, 1, 1))
matplot(med$k, 100 * med[, -1], type = "b", pch = 19, lty = 1,
        col = c("#1b9e77", "#7570b3", "#d95f02", "grey30"),
        xlab = "Locations per hybrid, k", ylab = "Median relative bias (%)")
abline(h = 0, lty = 3)
legend("topright", bty = "n", cex = 0.8, pch = 19, col = c("#1b9e77", "#7570b3", "#d95f02", "grey30"),
       legend = c("GCA (female)", "GCA x location", "SCA", "plot h2"))
plot(jitter(sc$k, 0.4), pmin(pmax(sc$bias_all_mean, 0.5), 1.5), pch = 19, cex = 0.6,
     col = adjustcolor(ifelse(sc$frac_conv < 1, "#d95f02", "grey30"), 0.7),
     xlab = "Locations per hybrid, k", ylab = "Dispersion slope b1", ylim = c(0.5, 1.5))
abline(h = 1, lty = 2)
legend("topright", bty = "n", cex = 0.8, pch = 19, col = c("grey30", "#d95f02"),
       legend = c("all fits converged", "some fits did not"))
par(op)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-sparse-median-bias
#| tbl-cap: "Median over the cached scenarios of the relative bias (%) of the REML estimates and of plot h2, by locations per hybrid k (the left panel of the figure above)."
mtab <- med; mtab[-1] <- 100 * mtab[-1]
names(mtab) <- c("k", "GCA (female) variance", "GCA x location variance", "SCA variance", "Plot h2")
knitr::kable(fmt(mtab, 1), row.names = FALSE)

#' 
## -----------------------------------------------------------------------------
#| include: false
b1r <- function(sub) range(sub$bias_all_mean)
s2s_k <- function(k) median(sc$relbias_s2s_mean[sc$k == k])

#' 
#' **Where every REML fit converged, the dispersion slope is near 1.** In the scenarios
#' where every REML fit converged -- all with $k \ge 2$ -- the dispersion slope
#' lies between `r paste(r4(b1r(subset(sc, frac_conv == 1))), collapse = " and ")`,
#' on both sides of 1 (median
#' `r r4(median(subset(sc, frac_conv == 1)$bias_all_mean))`). With $k \ge 4$ it
#' lies between `r paste(r4(b1r(subset(sc, k >= 4))), collapse = " and ")`. At
#' $k = 1$ no scenario had every fit converge; the median slope there is
#' `r r4(median(sc$bias_all_mean[sc$k == 1]))`, with outliers far from 1
#' (@fig-sparse-estimates, right). In these data sparsity cost accuracy without a
#' *systematic* dispersion bias at $k \ge 2$, with individual scenarios off by up
#' to `r sprintf("%.0f", 100 * max(abs(b1r(subset(sc, frac_conv == 1)) - 1)))` %;
#' at $k = 1$ the REML evidence does not settle the question, and
#' the known-component sweep of @sec-sparse-reproduce, whose slopes sit near 1 at
#' $k = 1$, shows only that the estimator is undispersed when the components are
#' right. The median bias of the female GCA variance stays between
#' `r sprintf("%+.1f", min(100 * med$relbias_s2f_mean))` % and
#' `r sprintf("%+.1f", max(100 * med$relbias_s2f_mean))` % over all $k$
#' (@tbl-sparse-median-bias). It is not near zero for the other two: the GCA x location
#' variance has a median bias of
#' `r sprintf("%+.1f", med_k("relbias_s2fl_mean", 1))`,
#' `r sprintf("%+.1f", med_k("relbias_s2fl_mean", 2))` and
#' `r sprintf("%+.1f", med_k("relbias_s2fl_mean", 3))` % at $k$ = 1, 2 and 3, and plot $h^2$ has
#' `r sprintf("%+.1f", med_k("relbias_h2_mean", 1))` % at $k = 1$ and
#' `r sprintf("%+.1f", med_k("relbias_h2_mean", 2))` % at $k = 2$.
#' 
#' **$\sigma^2_{SCA}$ is the exception.** Its median relative bias is
#' `r sprintf("%+.0f", 100 * s2s_k(4))` % at $k = 4$,
#' `r sprintf("%+.0f", 100 * s2s_k(2))` % at $k = 2$, and
#' `r sprintf("%+.0f", 100 * s2s_k(1))` % at $k = 1$. Part of this is present in the
#' complete design too (@tbl-sparse-validation), which suggests that identifying a small
#' component is a problem in itself, and the larger values at small $k$ say that sparsity
#' adds to it. A programme that needs a reliable SCA is in product development, not
#' population improvement, and these data give no sign that adding coverage to a
#' stage-1 trial would fix the problem.
#' 
#' **The hidden cost is convergence.** REML converged in `r fc(4)` of fits with
#' four locations per hybrid, `r fc(3)` with three, `r fc(2)` with two, and only
#' **`r fc(1)` with one**. That is `r sum(conv$nrep - conv$n_conv)` non-convergences
#' in `r sum(conv$nrep)` fits.
#' 
#' ::: {.callout-important}
#' ## Box -- Why REML does not converge when each hybrid sees one location
#' 
#' With $k = 1$ each hybrid contributes a single plot in a single location. The
#' data then carry no within-hybrid information to separate a hybrid's GCA from its
#' GCA x location deviation. The likelihood is flat along that ridge. The algorithm
#' walks to the boundary of the parameter space and stops without meeting its
#' criterion. The BLUPs from those fits are still usable. They come from solving
#' the mixed-model equations at the current components, which is exactly what
#' `sparse_blup()` does with known ones. **The variance estimates are not usable,
#' and should not be reported.** Predicting well and estimating well are different
#' achievements. At $k = 1$ a trial can still do the first.
#' :::
#' 
#' #### 6. Two stages: covering more candidates sparsely gave more gain at the same budget (four replicates)
#' 
#' The two-stage scenario works as follows:
#' 
#' - A pool of 400 candidate hybrids is available.
#' - Stage 1 tests $N_1$ of them sparsely and keeps the top $q$ by BLUP.
#' - Stage 2 tests the survivors densely in new locations.
#' - The final analysis is joint.
#' 
#' The metric is the realised gain: the mean *true* value of the ten hybrids
#' finally chosen, in genetic standard deviations. The cached file has four replicates
#' at every setting. The three values of $N_1$ span different budgets
#' (`r paste(sprintf("%d to %s", sapply(split(ts$plots_total, ts$N1), min), prettyNum(sapply(split(ts$plots_total, ts$N1), max), big.mark = ",")), collapse = ", ")`
#' total plots for $N_1$ = 100, 200 and 400), so a mean over all the cells of each $N_1$
#' compares different budgets and is not reported. @tbl-sparse-twostage-matched compares
#' $N_1$ at the same total plots, paired by replicate; it averages over the strategies
#' (random, parentage, optimised blocks) and the stage-1 and stage-2 settings present at
#' that budget, and that mixture is not controlled.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sparse-twostage-matched
#| tbl-cap: "Realised gain (genetic SD) at the larger N1 minus the smaller, at the same total plots, paired by replicate. Four replicates, so 3 degrees of freedom; p is two-sided and uncorrected, p_Bonf multiplies it by the 8 rows. Mean over the strategies and settings present at that budget. Cached study."
mt$p_Bonf <- pmin(1, nrow(mt) * mt$p)
knitr::kable(fmt(mt, 3), row.names = FALSE,
             col.names = c("N1 from", "N1 to", "Plots", "Reps", "Difference", "SE", "t", "p", "p_Bonf"))

#' 
#' From 100 to 200 candidates the difference is `r r2(min(mt$diff[mt$N1_from == 100]))` to
#' `r r2(max(mt$diff[mt$N1_from == 100]))` genetic SD at the four budgets ($t$ =
#' `r sprintf("%.1f", min(mt$t[mt$N1_from == 100]))` to
#' `r sprintf("%.1f", max(mt$t[mt$N1_from == 100]))`, smallest uncorrected $p$ =
#' `r sprintf("%.3f", min(mt$p[mt$N1_from == 100]))`). From 200 to 400 it is
#' `r r2(min(mt$diff[mt$N1_from == 200]))` to `r r2(max(mt$diff[mt$N1_from == 200]))` with
#' standard errors of `r r2(min(mt$se[mt$N1_from == 200]))` to
#' `r r2(max(mt$se[mt$N1_from == 200]))` ($t$ =
#' `r sprintf("%.1f", min(mt$t[mt$N1_from == 200]))` to
#' `r sprintf("%.1f", max(mt$t[mt$N1_from == 200]))`): not resolved. After a Bonferroni
#' correction over the eight rows (threshold `r sprintf("%.4f", 0.05 / nrow(mt))`) no row is
#' resolved; the budgets share replicates, so the rows are not independent and the
#' correction is conservative.
#' 
## -----------------------------------------------------------------------------
#| label: fig-sparse-twostage
#| fig-width: 7.5
#| fig-height: 4.2
#| fig-cap: "Realised gain (true value of the 10 hybrids finally selected, genetic SD units) against total plots, by the number of candidates tested in stage 1; mean over replicates, strategies (random, parentage, optimised blocks) and stage settings at each budget, 4 replicates, no dispersion shown (see the table above). The grey line is the oracle that selects on the truth. Cached study."
#| fig-alt: "Realised gain (true value of the 10 hybrids finally selected, genetic SD units) against total plots, by the number of candidates tested in stage 1; mean over replicates and stage-2 settings at each bu"
a  <- aggregate(cbind(gain_sd_units, gain_max_sd_units) ~ N1 + plots_total, ts, mean)
cl <- c("100" = "#d95f02", "200" = "#7570b3", "400" = "#1b9e77")
op <- par(mar = c(4.2, 4.2, 1, 1))
plot(NA, xlim = range(a$plots_total), ylim = c(0, max(a$gain_max_sd_units)), log = "x",
     xlab = "Total plots (log scale)", ylab = "Realised gain (genetic SD)")
o <- aggregate(gain_max_sd_units ~ plots_total, a, mean); o <- o[order(o$plots_total), ]
lines(o$plots_total, o$gain_max_sd_units, col = "grey60", lwd = 3)
for (n in names(cl)) {
  e <- a[a$N1 == as.numeric(n), ]; e <- e[order(e$plots_total), ]
  lines(e$plots_total, e$gain_sd_units, type = "b", pch = 19, col = cl[n])
}
legend("bottomright", bty = "n", col = c(cl, "grey60"), lwd = c(1, 1, 1, 3), pch = c(19, 19, 19, NA),
       legend = c(paste("N1 =", names(cl)), "oracle"), cex = 0.85)
par(op)

#' 
#' Result and reading. At the same total plots, a larger $N_1$ gave a larger realised
#' gain in every one of the eight comparisons, resolved at the uncorrected level from 100
#' to 200 candidates and not from 200 to 400 (the latter is the step to covering every
#' candidate of the pool). A reading is that stage 1 should cover more candidates with
#' fewer plots each rather than a subset with many; at four replicates, with an
#' uncontrolled mixture of strategies, this is a direction and not an established
#' margin. The cached grid also varies the stage-1 locations, the sparsity, the
#' stage-2 locations and the fraction kept. Picking its best cell is a post-hoc search
#' over many cells at four replicates, and no such cell is reported as a result.
#' 
#' #### Limitations of the simulation
#' 
#' The simulation has eight limitations.
#' 
#' 1. **One plot per cell.** SCA x location then has the same incidence as plot
#'    error, and the analysis model absorbs it into an i.i.d. residual that
#'    estimates $\sigma^2_{SCA\times L} + \sigma^2_e$. Equal incidence alone does
#'    not make the two inseparable: drawn with the kernel
#'    $\mathbf A_f \otimes \mathbf A_m$, as `sparse_simulate()` draws it, SCA x
#'    location is correlated between related crosses in one location and could be
#'    carried as a structured term; @sec-joint-model measures what that buys in
#'    one configuration. Within-location replication was not simulated.
#' 2. **G x E is full-rank and symmetric in the fast layer, and rank one in the
#'    genomic layer.** Neither layer has the factor-analytic structure of real
#'    trials or a crossover/non-crossover split [@burgueno2012; @werner2025].
#' 3. **The pools are symmetric and unselected.** There are no cycles of reciprocal
#'    recurrent selection, so the simulation says nothing about long-run pool
#'    trajectories (@sec-cycles) or about unbalanced pools.
#' 4. **Cost is counted in plots, not money.** Opening a location costs more than
#'    adding plots to an existing one. The advice to spread plots assumes the
#'    marginal location is moderately priced (@sec-mating-cost has the cost
#'    structure).
#' 5. **The grid is reduced.** It has at most 15 replicates per cell, no 200-hybrid level, and the
#'    high-SCA block run separately. The two-stage layer has 4 replicates and the
#'    genomic layer 8.
#' 6. **Components are checked by mean bias only.** No per-replicate confidence
#'    intervals were computed for them, and none for the contrasts of result 3, the
#'    two-stage comparison of result 6 or the minimal allocation of result 1 beyond the
#'    standard errors printed with each.
#' 7. **A dense factorial, planted at random.** The 20 x 20 factorial has 80 % of its
#'    hybrids planted, so every line is a parent of about 16 planted crosses. Parents
#'    are shared by construction. The sparse factorials of @sec-mating (a few crosses per
#'    line out of 200 candidates per pool, where connectivity binds) and the
#'    2,000-lines-per-pool pipeline of @fig-sparse-pipeline are different regimes.
#'    Results 2 to 4, and the "CV1 is T2" correspondence of the callout in
#'    @sec-sparse-what, depend on this density and were not measured at another.
#' 8. **The cached parentage arm comes from a defective search.** Its criterion
#'    returned $-\infty$ for any disconnected start (@sec-sparse-reproduce), so
#'    results 3 and 4 concern that layout, not `sparse_alloc("parentage")` of this
#'    repository.
#' 
#' ## Practical recommendations by stage {#sec-sparse-recommendations}
#' 
#' **Stage 1 (first agronomic testcross trial).**
#' 
#' - Give priority to the number of candidates and the number of locations in the
#'   trial. At fixed plots per hybrid, spread them over more locations, up to
#'   about six (result 2).
#' - Use 3 to 5 testers in sparse testcrossing, with full-sibs spread across
#'   testers.
#' - Use low partial replication (p-rep of 0.1 to 0.2), with checks replicated in
#'   every block.
#' - When plots per hybrid fall to one or two, a layout that puts both pools in
#'   every location is cheap to adopt and was not worse than random allocation in
#'   the cached grid; its advantage there was small and not resolved after
#'   multiplicity correction (results 3 and 4).
#' - The estimation target is GCA. The SCA variance was poorly recovered in the cached
#'   grid, so do not expect a reliable SCA at this stage (result 5).
#' 
#' **Stage 2 (pre-commercial hybrids).**
#' 
#' - Test fewer candidates, and raise replication and environmental coverage.
#' - Keep a common core large enough to estimate the between-environment genetic
#'   correlations.
#' - The estimation target is now specific performance and stability, so SCA and
#'   G x E matter.
#' 
#' **Decisions that span both stages.**
#' 
#' - Genotype the parents, not the hybrids.
#' - Check connectivity before planting (Box 4).
#' - Match the between-environment covariance to the amount of data. Do not force
#'   an unstructured matrix on a very sparse design.
#' - Advance on GBLUP rather than BLUE when heritability is low to moderate and
#'   locations are few [@atanda2022; @endelman2014].
#' 
#' **What not to do.**
#' 
#' - Put everything in one location, however many candidates that allows. It gave
#'   the most variable gain in @werner2025, with replicates of negative gain.
#' - Use one tester at stage 1 when there is infrastructure for three.
#' - Transfer a sparsity percentage from another crop or programme without your own
#'   simulation.
#' - Fit a G x E term under extreme sparsity [@hildaono2026].
#' 
#' **The right sparse design changes from stage to stage because the parameter of
#' interest changes**: GCA in stage 1, specific performance and stability in
#' stage 2.
#' 
#' ::: {.callout-tip}
#' ## Box 6 -- A checklist for designing a sparse trial
#' 
#' 1. Define the TPE and the market segment.
#' 2. Estimate the genetic correlations between candidate locations from historical
#'    data.
#' 3. Fix the budget in plots.
#' 4. Choose the axis of sparsity: environments, testers, or both.
#' 5. Fix the number of testers.
#' 6. Fix the partial-replication rate.
#' 7. Choose the checks and how often they appear.
#' 8. Generate the allocation by restricted randomisation or a formal criterion.
#'    Where plots per hybrid are fewest, consider keeping both pools in every location
#'     (results 3 and 4: a small advantage, not resolved after correction).
#' 9. Compute connectivity and the expected PEV before planting (Box 4).
#' 10. Simulate the design with the programme's own parameters (`sparse_vc()`,
#'     `sparse_simulate()`, `sparse_blup()`).
#' 11. Fix the analysis model and the covariance structure *a priori*.
#' 12. Fix the decision metric and the cut-off *a priori*.
#' :::
#' 
#' ## Limitations of the evidence, and perspectives {#sec-sparse-limits}
#' 
#' The authors of the primary studies declare their own limitations:
#' 
#' - @li2026: a narrow genetic base and a single year.
#' - @atanda2022: no way to identify the optimal overlap, and families of 1 to 9.
#' - @werner2025: no cost model, and no hybrid structure.
#' - @lubanga2025: a training set that was not optimised.
#' - @gonzalezdieguez2026: no G x E, no epistasis, no diversity management, and the
#'   logistic cost ignored.
#' - @hildaono2026: possible information leakage, and very similar environments.
#' 
#' As a research agenda, the open gaps are these.
#' 
#' - **SCA estimation, and prediction of specific hybrids, under sparsity.** This
#'   chapter's simulation shows the variance component is not recoverable at stage
#'   1. The accuracy of specific unseen crosses is still unmeasured.
#' - **A three-dimensional connectivity metric**, female x male x location. It
#'   would join @sec-mating-connectivity to Box 4. @sec-joint-criteria defines a
#'   pair of counts for it.
#' - **The long-run effect on pool divergence and within-pool variance**, in
#'   interaction with optimum contribution selection (@sec-cycles; @sec-ocs;
#'   @santantonio2020hoc).
#' - **Phenomics-assisted sparse testing in maize hybrids.**
#' - **Pools unequal in size and breeding level**, which is the usual commercial
#'   case.
#' - **Cost-accuracy frontiers in money**, including isolation blocks and hand
#'   pollination.
#' - **The rate of wrongly discarded candidates** as the evaluation metric, in
#'   place of the correlation.
#' - **Prospective empirical validation.** Almost all the evidence for sparse
#'   testing comes from resampling complete data or from simulation, not from
#'   trials designed sparse from the start [@alemu2024; @crossa2017].
#' 
#' Sparse testing changes the stage-1 question. It is no longer "which genotypes
#' can I evaluate well?". It becomes "which haplotypes can I evaluate well, and
#' against what sample of the opposite pool?". The evidence is sufficient to adopt
#' sparse designs at stage 1 with confidence. It is not sufficient to prescribe a
#' universal sparsity level. That decision remains specific to each programme, and
#' should be sized by the programme's own simulation.
#' 
#' ## Reproducibility and assumptions {#sec-sparse-reproduce}
#' 
#' `regenerate.R sparse` reruns the phenotypic core of the cached study with
#' `R/17_sparse_testing.R`. The scale and calibration are the same: 20 x 20
#' hybrids, half-sib families of four, and 20 % of hybrids untested. There are two
#' differences:
#' 
#' - the variance components are **known**, not estimated by REML;
#' - the parentage allocation's exchange search minimises the number of
#'   disconnected location pairs before the harmonic concurrence. The cached
#'   study's criterion returned $-\infty$ for any disconnected start, which left
#'   its search no gradient.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-sparse-reproduce
#| tbl-cap: "In-repo sweep (known components, 30 replicates) against the cached study (REML, 15 replicates), on overall accuracy for 400 hybrids. `z` is the difference in standard errors of the difference."
cr <- subset(core, part %in% c("spread", "k1"))
cr$cached <- mapply(function(L, k, s, h) {
  x <- s4$acc_all_mean[s4$nLoc == L & s4$k == k & s4$strategy == s & s4$h2_plot == h]
  if (length(x)) x[1] else NA
}, cr$nLoc, cr$k, cr$strategy, cr$h2_plot)
cr$cached_se <- mapply(function(L, k, s, h) {
  x <- s4$acc_all_se[s4$nLoc == L & s4$k == k & s4$strategy == s & s4$h2_plot == h]
  if (length(x)) x[1] else NA
}, cr$nLoc, cr$k, cr$strategy, cr$h2_plot)
cr$z <- (cr$acc_all - cr$cached) / sqrt(cr$acc_all_se^2 + cr$cached_se^2)
cr <- cr[order(cr$h2_plot, cr$k, cr$nLoc, cr$strategy), ]
knitr::kable(fmt(cr[, c("h2_plot", "nLoc", "k", "strategy", "acc_all", "cached", "z", "b1")], 3),
             row.names = FALSE,
             col.names = c("Plot h2", "Locations", "k", "Strategy", "In-repo acc.", "Cached acc.",
                           "z", "In-repo b1"))
dk <- tapply(cr$acc_all - cr$cached, cr$k, mean, na.rm = TRUE)

#' 
#' At $k = 2$ the mean difference is `r sprintf("%+.3f", dk[["2"]])`, and
#' `r sum(abs(cr$z[cr$k == 2]) > 2, na.rm = TRUE)` of the
#' `r sum(!is.na(cr$z[cr$k == 2]))` cells
#' `r if (sum(abs(cr$z[cr$k == 2]) > 2, na.rm = TRUE) == 1) "differs" else "differ"` by more than two standard errors
#' (the largest, `r sprintf("%.1f", max(abs(cr$z[cr$k == 2]), na.rm = TRUE))`); the gain from spreading the same plots over
#' more locations reproduces. At $k = 1$ the known-component values are higher by
#' `r sprintf("%+.3f", dk[["1"]])` on average over the `r sum(!is.na(cr$z[cr$k == 1]))`
#' comparable cells, with $z$ (in-repo minus cached) of
#' `r paste(sprintf("%.1f", cr$z[cr$k == 1 & !is.na(cr$z)]), collapse = ", ")`:
#' `r sum(cr$z[cr$k == 1] > 0, na.rm = TRUE)` positive and
#' `r sum(abs(cr$z[cr$k == 1]) > 2, na.rm = TRUE)` beyond two standard errors. The mean
#' difference was not tested. The cost of estimating the components, where REML mostly
#' fails to converge (result 5), is one possible reason; the two arms also differ in the
#' parentage search and in the number of replicates, so the difference is not attributed
#' here. The in-repo dispersion slopes all sit near 1. The in-repo sweep does **not** resolve the
#' parentage-versus-random difference at $k = 1$: its 30 unpaired replicates per
#' cell have standard errors near 0.01, the same size as the effect. The cached
#' paired contrasts of @tbl-sparse-contrasts, which pool 791 pairs (385 for the exploratory
#' $k \le 2$ subset), are the evidence for result 3.
#' 
## -----------------------------------------------------------------------------
#| label: sparse-oracle-check
set.seed(3)
nF2 <- 4; nM2 <- 3; L2 <- 3
Af2 <- relmat_halfsib(nF2, 2); Am2 <- diag(nM2) * 0.8 + 0.2
vc2 <- sparse_vc(0.4)
M2 <- sparse_alloc(nF2, nM2, L2, 2, "random"); M2[c(2, 7), ] <- 0L   # two hybrids never planted
sim2  <- sparse_simulate(M2, nF2, nM2, vc2, Af2, Am2)
fast2 <- sparse_blup(sim2$pheno, nF2, nM2, L2, vc2, Af2, Am2)
ref2  <- ref_sparse_blup(sim2$pheno, nF2, nM2, L2, vc2, Af2, Am2)
dev_blup <- max(abs(fast2$blup - ref2$blup)); dev_pev <- max(abs(fast2$pev - ref2$pev))
stopifnot(dev_blup < 1e-8, dev_pev < 1e-8)

#' 
#' One draw is checked in this chapter (a 4 x 3 factorial, three locations, two hybrids
#' never planted): the largest deviation of `sparse_blup()` from the literal GLS form of
#' `ref_sparse_blup()` is `r fmt_sci(dev_blup)` for the BLUP and `r fmt_sci(dev_pev)` for the
#' PEV. The other live functions are verified in `tests/testthat/test-sparse.R` (the
#' list of tests is in @sec-verification):
#' 
#' - `sparse_blup()` equals the literal GLS form of `ref_sparse_blup()` to
#'   $10^{-8}$, including untested hybrids, and so do its PEVs.
#' - Every allocation puts each hybrid in exactly $k$ locations.
#' - The parentage design covers both pools in every location.
#' - The dispersion slope of the known-component BLUP averages 1.
#' 
#' The cached numbers carry the assumptions listed in the limitations of the
#' simulation (@sec-sparse-results). Treat them as findings of that
#' configuration, not as constants; the cached ones cannot be reproduced from this
#' repository.
#' 
#' ## Where this connects {#sec-sparse-connects}
#' 
#' - @sec-mating compared designs of *which crosses* to make. This chapter asked
#'   *where to plant them*, mostly with the factorial taken as given (80 % of it planted
#'   at random). Result 6 traded
#'   locations per candidate against a smaller stage-1 factorial at equal plots;
#'   what it leaves is the version in which every line stays in the data and the
#'   unmade crosses are predicted, so that an extra location per hybrid costs a
#'   cross rather than a parent. Result 2 never varied the locations per hybrid;
#'   it held two plots per hybrid and widened the trial. The joint problem,
#'   @sec-mating-open's second gap, is @sec-joint.
#' - The GCA/SCA decomposition and the tester-frequency argument behind Box 5 are
#'   derived in @sec-heterosis-gca-sca.
#' - The relationship matrices that make sparse designs analysable are the pedigree
#'   matrices of `relmat_halfsib()` here, and marker matrices in the cached genomic
#'   layer. @sec-genomic-prediction fits one additive GBLUP and does not fit the
#'   pool-specific or SCA kernels of this chapter.
#' - The staged-trial trade-off of @sec-programme (a later chapter, in the Evidence
#'   and practice part) is an analogy to result 6, not a replication of it: that chapter
#'   models locations as independent draws, whereas result 6 uses a genetic
#'   correlation between locations of
#'   `r r4(vc_ex$Vg / (vc_ex$Vg + vc_ex$VgxE))`.
#' - Spreading testers and parents to slow within-pool erosion is the same concern
#'   as @sec-ocs and @sec-cycles. Sparse testcrossing does by design what a
#'   diversity constraint does by optimisation.
