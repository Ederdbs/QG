#' # End to end, and the operational checklist {#sec-case-study}
#' 
# 12-case-study -- standalone script of the chapter 12-case-study.qmd
# Book: https://ederdbs.github.io/QG/12-case-study.html
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
#' The package's two stages, run once, on one simulated dataset:
#' `stage1_simulate()` builds the three-object contract of @sec-simulating-crosses,
#' and `stage2_select()` selects hybrids from it under a grid of diversity budgets.
#' That is the hybrid-selection side of a programme only. The stages S1 to S3 of
#' @sec-stages (pool conservation, doubled-haploid (DH) crosses, line selection) and the crossing and
#' testing design of @sec-mating, @sec-sparse and @sec-joint are not run here. Then
#' the checklist, which draws on the whole book.
#' 
#' ## The two stages in one script
#' 
## -----------------------------------------------------------------------------
st1 <- stage1_simulate(book_cfg)
c(hybrids = nrow(st1$X), markers = ncol(st1$X),
  f_min = min(st1$f), f_max = max(st1$f))

#' 
## -----------------------------------------------------------------------------
#| results: hide
n_sel <- round(0.10 * nrow(st1$X))
res <- withCallingHandlers(stage2_select(
  X = st1$X, f = st1$f, hybrids = st1$hybrids,
  n_sel   = n_sel,
  alphas  = NULL,     # NULL = automatic grid, 0 to the attainable ceiling
  weights = NULL,     # NULL = equal weight across traits
  fL      = st1$fL,   # optional: enables theta_A / theta_B / theta_AB
  B_null = 500, B_full = 80, NP = 100, itermax = 200, verbose = FALSE),
  # muffle only DEoptim's advice that NP be >= 10 x the number of parameters
  warning = function(w) if (grepl("'NP'", conditionMessage(w), fixed = TRUE))
    invokeRestart("muffleWarning"))

#' 
#' The run's settings, which every number below depends on. It selects
#' $n$ = `r n_sel` hybrids, 10 % of the $N$ = `r nrow(st1[["X"]])` candidates, where
#' @sec-ocs, @sec-choosing and @sec-cycles select 60. The random-subset reference
#' `gd_ref` comes from `B_null` = 500 subsets and the z-scores below from
#' `B_full` = 80. The differential evolution (DE) runs with `NP` = 100 and
#' `itermax` = 200, a nominal $2 \times 10^4$ evaluations per budget, against
#' $6 \times 10^5$ at the package defaults (`NP` = 300, `itermax` = 2000). Every
#' scenario is one run, with `seed = 1` for both the null and the DE;
#' @sec-case-study-frontier repeats the call over further seeds and at the default
#' DE budget, from a cache. The ceiling
#' and the frontier below are therefore not comparable number for number with those
#' of @sec-ocs or @sec-choosing, which use other $n$ and other $B$.
#' 
#' ::: {.callout-note}
#' ## The same functions as a script
#' 
#' This chapter runs at the book's teaching scale (25 + 25 lines, 2000 markers).
#' `inst/scripts/run_all.R` calls the same two functions at the `sim_config`
#' default (50 + 50 lines, 5000 markers), which is not the package's declared
#' production scale of 71 + 71 lines and 25000 markers (A8 of @sec-era-programme).
#' It also uses other settings: $n$ at 4 % of the candidates, and the package
#' defaults of `B_null`, `B_full`, `NP` and `itermax`. Its tables go to `report/`.
#' `run_benchmark.R` produces the numbers quoted in `README.md`. Neither script is
#' run by this chapter, and their run times are not measured here.
#' 
#' ```sh
#' Rscript inst/scripts/run_all.R
#' Rscript inst/scripts/run_benchmark.R
#' ```
#' :::
#' 
#' With real data only the first line changes:
#' 
## -----------------------------------------------------------------------------
#| eval: false
# st1 <- stage1_build(X = my_hybrid_matrix, ped = my_pedigree,
#                     traits = my_predicted_traits, fL = my_line_coancestry)

#' 
#' ### The reference values
#' 
## -----------------------------------------------------------------------------
unlist(res$ref)
# the ceiling is the achieved loss of the truncation plan
stopifnot(isTRUE(all.equal(
  res$metrics$alpha[res$metrics$scenario == "ref_truncation"], res$ref$alpha_max)))

#' 
#' `alpha_max` in `res$ref` is the code name of the attainable ceiling
#' $\alpha_{\text{trunc}}$ of @sec-ocs: the loss that pure truncation incurs,
#' measured against the same-size baseline of @sec-baseline. It is not the budget
#' $\alpha_{\max}$, which in this chapter, as in @sec-ocs, is the policy value a
#' scenario requests. A requested budget at or above $\alpha_{\text{trunc}}$
#' constrains nothing. For a budget above it `stage2_select()` raises a warning that
#' the constraint is inoperative, and then still runs the DE for that scenario and
#' returns its plan under the `DE_alpha_*` label like any other. The automatic grid
#' (`alphas = NULL`) ends at $\alpha_{\text{trunc}}$, so no such warning arises in
#' this run. The call above muffles one warning only: the `DEoptim` advice that `NP`
#' be at least ten times the number of parameters, which is raised once per DE run,
#' `r sum(startsWith(res[["metrics"]][["scenario"]], "DE_"))` times in this call.
#' Every other warning, the inoperative-budget one included, would surface.
#' 
#' ### Metrics per scenario
#' 
#' @tbl-case-study-metrics gives the metrics of the nine scenarios of this run.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-case-study-metrics
#| tbl-cap: "Metrics of the selected set for each scenario of this run, as returned in `$metrics` by `stage2_select()` (the metrics are defined in @sec-catalogue). Five DE rows, one per requested budget, the name carrying $\\alpha_{\\max}$ in percent; four reference selections (`ref_*`). `alpha` is the achieved gene diversity loss against the same-size random baseline (a fraction); `index` is the mean index of the selected hybrids in standard deviations. Teaching scale (25 + 25 lines, 2000 markers), $n$ = 62 of $N$ = 625 candidates, DE and null seed 1."
fmt(res$metrics[, c("scenario", "alpha", "index", "Ns", "Ne_parents",
                    "Ne_lines_A", "Ne_lines_B", "max_line", "alleles_lost")], 4)

#' 
#' Read the `index` column against `alpha`. The scenario name carries the
#' *requested* budget in percent (`DE_alpha_3.94` requests
#' $\alpha_{\max} = \alpha_{\text{trunc}}$); the `alpha` column is the loss the plan
#' *achieved*. The five `DE_` rows are the index each budget bought, on this dataset,
#' at this selection intensity and at the evaluation budget stated above;
#' @sec-case-study-frontier reads them as a frontier and states what limits that
#' reading. The four `ref_` rows are reference selections, not budgets.
#' 
#' Now read `Ne_parents` against `Ns` in the same rows. @sec-genomic-era calls for
#' $F_{hom}$ and $F_{drift}$ to be computed separately (@sec-case-study-lenses does), and
#' names `ne_parents()` as this book's implementation of the parent-count side of
#' that diagnostic. `stage2_select()` has no argument that bounds `Ne_parents`, so in
#' this run it is a report line, not a constraint (@tbl-case-study-ns):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-case-study-ns
#| tbl-cap: "$N_s$ (`Ns`) and `Ne_parents` for each scenario of @tbl-case-study-metrics, and each divided by its maximum over the nine scenarios (`Ns_relative`, `Ne_par_relative`)."
d <- res$metrics
fmt(data.frame(scenario = d$scenario,
               Ns = d$Ns,
               Ne_parents = d$Ne_parents,
               Ns_relative = d$Ns / max(d$Ns),
               Ne_par_relative = d$Ne_parents / max(d$Ne_parents)), 3)
# GD = 1 - theta, Ns = 1/(2 theta), hence Ns is a function of the achieved alpha
stopifnot(isTRUE(all.equal(d$GD, 1 - d$theta)),
          isTRUE(all.equal(d$Ns, 1 / (2 * d$theta))),
          isTRUE(all.equal(d$Ns, 1 / (2 * (1 - res$ref$gd_ref * (1 - d$alpha))))))

#' 
#' Result. $N_s$ goes from `r fmt(d[["Ns"]][d[["scenario"]] == "DE_alpha_0.00"], 4)`
#' at $\alpha_{\max} = 0$ to `r fmt(d[["Ns"]][d[["scenario"]] == "ref_truncation"], 4)`
#' under truncation; `Ne_parents` goes from
#' `r fmt(d[["Ne_parents"]][d[["scenario"]] == "DE_alpha_0.00"], 1)` to
#' `r fmt(d[["Ne_parents"]][d[["scenario"]] == "ref_truncation"], 1)`, against
#' `r fmt(d[["Ne_parents"]][d[["scenario"]] == "ref_random"], 1)` for the random
#' subset. The two columns are not on one scale. On molecular $\mathbf f$,
#' $N_s = 1/(2\theta_S)$ lies in $[1/2, 1]$ at biallelic loci and is not a number of
#' individuals (@sec-ns), so its ratio to its own maximum (`Ns_relative`) says
#' nothing about the size of a pool. In this run $N_s$ is also fixed by the achieved
#' loss: with gene diversity $GD_S = 1 - \theta_S$ and
#' $\alpha = (GD_{\text{ref}} - GD_S)/GD_{\text{ref}}$ (@eq-catalogue-alpha),
#' $N_s = 1/\{2[1 - GD_{\text{ref}}(1 - \alpha)]\}$ (all three asserted in the code of
#' @tbl-case-study-ns), so the `Ns` column restates the constraint and adds nothing to the
#' `alpha` column.
#' 
#' Interpretation, and what limits it. The contrast that carries information is
#' between the lens the budget pins ($\theta_S$, $GD_S$, $\alpha$, and therefore
#' $N_s$) and a parent-count quantity it does not pin. A report limited to the
#' first would not show the fall of `Ne_parents`. This is one dataset; the
#' dispersion of `Ne_parents` over the optimiser's seed is given in
#' @sec-case-study-frontier.
#' 
#' ### Both lenses, and the pool partition {#sec-case-study-lenses}
#' 
#' @tbl-case-study-lenses gives both lenses and the pool partition for each
#' scenario.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-case-study-lenses
#| tbl-cap: "The two lenses and the pool partition for each scenario of @tbl-case-study-metrics: achieved loss `alpha` (a fraction), `F_hom` and `F_drift` on the frozen base $p_0$, their gap `cov_diag`, `rare_retained` (the fraction of the candidate pool's rare alleles still present in the selected set), the within-hybrid gene diversity `GD_WI_hyb`, the between-pool component `GD_BS` and the statistic `F_ST` $= GD_{BS}/GD_T$."
fmt(res$metrics[, c("scenario", "alpha", "F_hom", "F_drift", "cov_diag",
                    "rare_retained", "GD_WI_hyb", "GD_BS", "F_ST")], 4)

#' 
#' `F_ST` is the statistic $GD_{BS}/GD_T$ of @eq-f-stats computed on each selected
#' set. It is not the Balding-Nichols parameter $F_{BN}$ of the simulation.
#' 
#' `alpha` constrains the first lens only. `F_drift` is the lens it does not pin,
#' and `cov_diag` is exactly the gap between them, $F_{hom} - F_{drift}$
#' (@eq-era-cov; Eq. 3 of @meuwissen2020). The largest absolute deviation over the
#' nine rows is printed below and asserted to lie within 100 machine epsilons, the
#' tolerance of an exact identity; the package's test suite asserts it too
#' (`tests/testthat/test-lenses.R`):
#' 
## -----------------------------------------------------------------------------
dev_eq3 <- max(abs(d$cov_diag - (d$F_hom - d$F_drift)))
stopifnot(dev_eq3 < 100 * .Machine$double.eps)
c(max_deviation_from_Eq3 = dev_eq3)

#' 
#' Result. `GD_BS` rises with the budget, from
#' `r fmt(d[["GD_BS"]][d[["scenario"]] == "DE_alpha_0.00"], 4)` at
#' $\alpha_{\max} = 0$ to `r fmt(d[["GD_BS"]][d[["scenario"]] == "ref_truncation"], 4)`
#' under truncation, against `r fmt(d[["GD_BS"]][d[["scenario"]] == "ref_random"], 4)`
#' for the random subset. Its cause is not identified here: concentrating the use of
#' a few lines inside a pool raises $GD_{BS}$ with no change in the lines
#' (@tbl-catalogue-gdbs-conc), and this run has no arm that separates that effect
#' from selection. The index is additive and the model has no dominance (@sec-case-study-limits),
#' so the rise is not evidence about heterosis; $GD_{BS}$ stands for the divergence
#' heterosis rests on only under the conditions of @tbl-keystone (flat dominance,
#' inbred parents, a complete factorial). @sec-stages is the reason to watch it
#' rather than celebrate it.
#' 
#' ### Distance from the random null
#' 
#' @tbl-case-study-z places six of the metrics against the random null.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-case-study-z
#| tbl-cap: "Six metrics for each scenario of @tbl-case-study-metrics, in standard deviations from the random-subset null (`B_full` = 80 random subsets of the same size). Less diverse than chance is negative for `z_GD`, `z_Ne_parents` and `z_rare_retained`, and positive for `z_F_drift` and `z_ANE`; `z_GD_BS` has no worse direction."
fmt(res$z_scores[, c("scenario", "z_GD", "z_Ne_parents", "z_F_drift",
                     "z_rare_retained", "z_GD_BS", "z_ANE")], 2)

#' 
#' Every metric in standard deviations from random selections of the same size
#' (`B_full` = 80 subsets). The direction of "less diverse than chance" differs by
#' column: negative for `z_GD`, `z_Ne_parents` and `z_rare_retained`, positive for
#' `z_F_drift` and `z_ANE`. `ANE` is A-NE (accession-to-nearest-entry), the mean distance from each candidate to
#' its nearest selected hybrid (@eq-catalogue-ene-ane), where lower means better
#' representation. `z_GD_BS` has no "worse" direction.
#' 
#' A z near zero says that a metric does not separate the plan from chance. It does
#' not say that the metric is not acting as a constraint. `z_GD` is
#' `r fmt(res[["z_scores"]][["z_GD"]][res[["z_scores"]][["scenario"]] == "DE_alpha_0.00"], 2)`
#' at `DE_alpha_0.00`, the scenario in which $GD$ is the binding constraint, and it
#' is near zero on average only. That scenario holds $\alpha$ at 0, so its $GD$ sits
#' at `gd_ref`, the mean of the `B_null` = 500 draws; `z_GD` is centred and scaled on
#' the separate `B_full` = 80 draws. The difference between the two Monte Carlo means
#' gives `z_GD` at $\alpha = 0$ a standard deviation of about
#' $\sqrt{1/80 + 1/500}$ = `r fmt(sqrt(1/80 + 1/500), 2)` z units (independent draws,
#' and the `B_full` standard deviation taken as exact); the value printed at this seed
#' is one draw of that error. A constrained metric is read against
#' its budget. The metrics the constraint does not pin are the ones that move under
#' it: at the same scenario `z_Ne_parents` is
#' `r fmt(res[["z_scores"]][["z_Ne_parents"]][res[["z_scores"]][["scenario"]] == "DE_alpha_0.00"], 1)`
#' and `z_F_drift` is
#' `r fmt(res[["z_scores"]][["z_F_drift"]][res[["z_scores"]][["scenario"]] == "DE_alpha_0.00"], 1)`.
#' Each z divides by a standard deviation estimated from 80 subsets; if the null is
#' close to normal, which is not checked here, that standard deviation carries a
#' relative standard error of $1/\sqrt{2(B_{full} - 1)}$ =
#' `r fmt(100 / sqrt(2 * (80 - 1)), 0)` % (@sec-catalogue-null), not shown in
#' @tbl-case-study-z.
#' 
#' ### The selection table
#' 
#' @tbl-case-study-selection shows the hybrids selected under the most scenarios.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-case-study-selection
#| tbl-cap: "The first eight rows of the selection table `$selection`, ordered by `n_scenarios`: each hybrid with its two parent lines, 1 in a scenario's column if that scenario selects it and 0 otherwise, and `n_scenarios`, the number of the nine scenarios of @tbl-case-study-metrics that select it."
scn <-setdiff(names(res$selection), c(names(st1$hybrids), "n_scenarios"))
head(res$selection[order(-res$selection$n_scenarios),
                   c("hybrid", "line_A", "line_B", scn, "n_scenarios")], 8)

#' 
## -----------------------------------------------------------------------------
de_cols <- grep("^DE_", scn, value = TRUE)
c(scenarios          = length(scn),
  chosen_in_all_DE   = sum(rowSums(res$selection[, de_cols, drop = FALSE]) ==
                             length(de_cols)),
  never_chosen       = sum(res$selection$n_scenarios == 0),
  total_candidates   = nrow(res$selection))

#' 
#' `n_scenarios` counts, for each hybrid, the scenarios that select it, the four
#' reference rows included. `chosen_in_all_DE` counts the hybrids selected under all
#' five DE budgets of this run (DE and null seed 1). Whether the same hybrids recur
#' under another seed of the optimiser is read from the same call repeated over
#' DE/null seeds at the chapter's DE budget and at the package default, cached by
#' `regenerate.R case_study` (seed 1 at the chapter budget is asserted to be this
#' run):
#' 
## -----------------------------------------------------------------------------
kept <- read.csv(book_data("case_study_kept.csv"))
live_kept <- res$selection$hybrid[
  rowSums(res$selection[, de_cols, drop = FALSE]) == length(de_cols)]
stopifnot(setequal(kept$hybrid[kept$budget == "chapter" & kept$seed == 1],
                   live_kept))
kept_seeds <- sort(unique(kept$seed))
kept_tab <- t(vapply(c("chapter", "default"), function(b) {
  s <- split(kept$hybrid[kept$budget == b],
             factor(kept$seed[kept$budget == b], levels = kept_seeds))
  c(seeds = length(s), min_kept = min(lengths(s)), max_kept = max(lengths(s)),
    kept_in_every_seed = length(Reduce(intersect, s)),
    kept_in_any_seed = length(Reduce(union, s)))
}, numeric(5)))
kept_tab

#' 
#' Over `r length(kept_seeds)` seeds, the number of hybrids kept under every DE
#' budget ranges from `r kept_tab["chapter", "min_kept"]` to
#' `r kept_tab["chapter", "max_kept"]` at the chapter's DE budget and from
#' `r kept_tab["default", "min_kept"]` to `r kept_tab["default", "max_kept"]` at the
#' default. The sets do not coincide: the number kept under every budget in all
#' `r length(kept_seeds)` seeds is `r kept_tab["chapter", "kept_in_every_seed"]` at
#' the chapter budget and `r kept_tab["default", "kept_in_every_seed"]` at the
#' default, out of `r kept_tab["chapter", "kept_in_any_seed"]` and
#' `r kept_tab["default", "kept_in_any_seed"]` kept in at least one seed. Within a
#' run the plan keeps a core across budgets; which hybrids form it depends on the
#' optimiser's seed, so no set of hybrids is shown here to be robust to the choice
#' of $\alpha$.
#' 
#' ## Reading the frontier {#sec-case-study-frontier}
#' 
#' @fig-case-study-frontier draws the five DE rows of this run as a line and the
#' four reference rows as separate marks. Behind them is the same `stage2_select()`
#' call repeated over DE/null seeds at the chapter's DE budget and at the package
#' default, cached by `regenerate.R case_study`. `seed` drives both the null and the
#' DE, so the two budgets are paired by seed; seed 1 at the chapter budget is
#' asserted to reproduce this run. `k` is the position in the automatic grid,
#' because the requested $\alpha_{\max}$ moves with `gd_ref` and hence with the
#' seed. @tbl-case-study-frontier gives the mean and standard deviation of the index
#' over seeds at each budget, and the paired gain of the default budget with its
#' standard error and the number of seeds in which it is positive:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-case-study-frontier
#| tbl-cap: "The DE frontier over DE/null seeds, by grid point `k` (position in the automatic grid). `alpha_req_pct`: mean requested budget $\\alpha_{\\max}$ (%). `index_ch`, `sd_ch`: mean and standard deviation of the index over seeds at the chapter's DE budget (`NP` = 100, `itermax` = 200). `index_def`, `sd_def`: the same at the package default (`NP` = 300, `itermax` = 2000). `gain`: mean paired gain of the default budget over the chapter budget, seed by seed; `se_gain`: its standard error; `gain_pos`: the number of seeds in which it is positive. Index in standard deviations. Cached by `regenerate.R case_study`."
fr <-read.csv(book_data("case_study_frontier.csv"))
fr1 <- fr[fr$budget == "chapter" & fr$seed == 1, ]
m1 <- match(fr1$scenario, d$scenario)
stopifnot(!anyNA(m1), isTRUE(all.equal(fr1$index, d$index[m1])),
          isTRUE(all.equal(fr1$alpha, d$alpha[m1])))
n_seed <- length(unique(fr$seed))
de_fr <- fr[!is.na(fr$k), ]
fr_ch <- de_fr[de_fr$budget == "chapter", ]
fr_def <- de_fr[de_fr$budget == "default", ]
# the two budgets share null and DE seed: paired by (seed, k)
w <- merge(fr_ch[, c("seed", "k", "index")], fr_def[, c("seed", "k", "index")],
           by = c("seed", "k"), suffixes = c("_ch", "_def"))
stopifnot(nrow(w) == nrow(fr_ch), nrow(w) == nrow(fr_def))
gain <- w$index_def - w$index_ch
front_tab <- data.frame(
  k = sort(unique(fr_ch$k)),
  alpha_req_pct = 100 * tapply(fr_ch$alpha_max, fr_ch$k, mean),
  index_ch = tapply(fr_ch$index, fr_ch$k, mean), sd_ch = tapply(fr_ch$index, fr_ch$k, sd),
  index_def = tapply(fr_def$index, fr_def$k, mean), sd_def = tapply(fr_def$index, fr_def$k, sd),
  gain = tapply(gain, w$k, mean),
  se_gain = tapply(gain, w$k, sd) / sqrt(n_seed),
  gain_pos = tapply(gain > 0, w$k, sum))
fmt(front_tab, 3)
# the loosest DE budget against the truncation plan, seed by seed
top <- merge(de_fr[de_fr$k == max(de_fr$k), c("budget", "seed", "index")],
             fr[fr$scenario == "ref_truncation", c("budget", "seed", "index")],
             by = c("budget", "seed"), suffixes = c("_de", "_trunc"))
trunc_wins <- tapply(top$index_trunc > top$index_de, top$budget, sum)
trunc_wins
# what the prose below states: the default budget moves the tighter points by
# more than their seed-to-seed s.d., and truncation beats the loosest DE point
# in every seed at both budgets
stopifnot(all(front_tab$gain[-nrow(front_tab)] > front_tab$sd_ch[-nrow(front_tab)]),
          all(trunc_wins == n_seed))
np_it <- function(b) unlist(fr[fr$budget == b, c("NP", "itermax")][1, ])
cap_frontier <- sprintf(paste(
  "Mean index of the selected hybrids (standard deviations of the index) against",
  "the achieved gene diversity loss $\\alpha$ (%%). Red line: the five DE budgets",
  "of this chapter's run (requested $\\alpha_{\\max}$ from 0 to",
  "$\\alpha_{\\text{trunc}}$; DE/null seed 1, `NP` = %d, `itermax` = %d). Grey",
  "lines: the same call over DE/null seeds %d-%d at that budget. Blue lines: the",
  "same seeds at the package default (`NP` = %d, `itermax` = %d). Black marks: the",
  "four reference selections of this run, which are plans, not budgets. Teaching",
  "scale (%d + %d lines, %d markers), simulation seed %d, $n$ = %d of $N$ = %d.",
  "The seed lines are cached by `regenerate.R case_study`."),
  np_it("chapter")[[1]], np_it("chapter")[[2]], min(fr$seed), max(fr$seed),
  np_it("default")[[1]], np_it("default")[[2]],
  book_cfg$n_pool_A, book_cfg$n_pool_B, book_cfg$m, book_cfg$seed,
  n_sel, nrow(st1$X))
de_d <- d[!is.na(d$alpha_max), ]
tr_d <- d[d$scenario == "ref_truncation", ]
oth_d <- d[is.na(d$alpha_max) & d$scenario != "ref_truncation", ]
alt_frontier <- sprintf(paste(
  "Line chart of mean index against diversity loss in percent. The red DE line",
  "rises from %.2f at %.2f %% loss to %.2f at %.2f %%. Grey lines for the other",
  "seeds lie around it; blue lines for the default budget lie on average %.2f",
  "index units above the grey ones at the same seed. The truncation mark is at",
  "%.2f, %.2f %% loss; the other three reference marks lie between index %.2f",
  "and %.2f."),
  de_d$index[1], round(100 * de_d$alpha[1], 2) + 0, de_d$index[nrow(de_d)],
  100 * de_d$alpha[nrow(de_d)], mean(gain), tr_d$index, 100 * tr_d$alpha,
  min(oth_d$index), max(oth_d$index))

#' 
## -----------------------------------------------------------------------------
#| label: fig-case-study-frontier
#| fig-cap: !expr cap_frontier
#| fig-alt: !expr alt_frontier
de <- d[!is.na(d$alpha_max), ]
rf <- d[is.na(d$alpha_max), ]
rf_pch <- c(ref_truncation = 17, ref_trunc_cap = 15, ref_max_div = 18,
            ref_random = 4)[rf$scenario]
plot(100 * fr$alpha, fr$index, type = "n",
     xlim = range(100 * c(fr$alpha, rf$alpha)), ylim = range(c(fr$index, rf$index)),
     xlab = "achieved gene diversity loss, alpha (%)",
     ylab = "mean index of the selected hybrids (s.d.)")
grid()
abline(v = 0, lty = 3, col = book_pal[["mid"]])
for (s in unique(fr$seed)) {
  lines(100 * fr_def$alpha[fr_def$seed == s], fr_def$index[fr_def$seed == s],
        col = adjustcolor(book_pal[["A"]], 0.45))
  lines(100 * fr_ch$alpha[fr_ch$seed == s], fr_ch$index[fr_ch$seed == s],
        col = adjustcolor(book_pal[["mid"]], 0.5))
}
lines(100 * de$alpha, de$index, type = "b", pch = 19, lwd = 2,
      col = book_pal[["loss"]])
points(100 * rf$alpha, rf$index, pch = rf_pch, cex = 1.3, col = book_pal[["ink"]])
legend("bottomright", bty = "n", cex = 0.8,
       legend = c("DE, this run (seed 1, chapter budget)",
                  sprintf("DE, seeds %d-%d, chapter budget", min(fr$seed), max(fr$seed)),
                  sprintf("DE, seeds %d-%d, package default budget",
                          min(fr$seed), max(fr$seed)),
                  sub("^ref_", "reference: ", rf$scenario)),
       col = c(book_pal[["loss"]], adjustcolor(book_pal[["mid"]], 0.5),
               adjustcolor(book_pal[["A"]], 0.45), rep(book_pal[["ink"]], nrow(rf))),
       lty = c(1, 1, 1, rep(NA, nrow(rf))), lwd = c(2, 1, 1, rep(NA, nrow(rf))),
       pch = c(19, NA, NA, rf_pch))

#' 
#' Result. Between successive DE budgets the index rises by
#' `r paste(fmt(diff(d[["index"]][!is.na(d[["alpha_max"]])]) / diff(100 * d[["alpha"]][!is.na(d[["alpha_max"]])]), 2), collapse = ", ")`
#' index units per percentage point of achieved $\alpha$, from the tightest budget
#' to the loosest. At the loosest budget the DE plan scores
#' `r fmt(d[["index"]][which.max(d[["alpha_max"]])], 3)` at
#' $\alpha$ = `r fmt(d[["alpha"]][which.max(d[["alpha_max"]])], 4)`; the truncation
#' plan scores `r fmt(d[["index"]][d[["scenario"]] == "ref_truncation"], 3)` at
#' $\alpha$ = `r fmt(d[["alpha"]][d[["scenario"]] == "ref_truncation"], 4)`, a loss that
#' budget allows. The warm start of `stage2_select()` (greedy plans and the capped
#' truncation) does not include the truncation plan.
#' 
#' Over the `r n_seed` seeds, the standard deviation of the index at the chapter
#' budget is between `r fmt(min(front_tab[["sd_ch"]]), 3)` and
#' `r fmt(max(front_tab[["sd_ch"]]), 3)` across the five grid points. The default
#' budget raises the index at the four tighter points by
#' `r paste(fmt(front_tab[["gain"]][-nrow(front_tab)], 3), collapse = ", ")`
#' (standard errors at most `r fmt(max(front_tab[["se_gain"]][-nrow(front_tab)]), 3)`),
#' and at the loosest by `r fmt(front_tab[["gain"]][nrow(front_tab)], 3)`
#' (s.e. `r fmt(front_tab[["se_gain"]][nrow(front_tab)], 3)`, positive in
#' `r front_tab[["gain_pos"]][nrow(front_tab)]` of `r n_seed` seeds). Truncation
#' scores above the DE at the loosest budget in `r trunc_wins[["chapter"]]` of
#' `r n_seed` seeds at the chapter budget and in `r trunc_wins[["default"]]` at the
#' default, by `r fmt(min(top[["index_trunc"]] - top[["index_de"]]), 4)` to
#' `r fmt(max(top[["index_trunc"]] - top[["index_de"]]), 4)` index units over the
#' `r nrow(top)` (seed, budget) pairs. Secant slopes of the default-budget means are
#' `r paste(fmt(diff(front_tab[["index_def"]]) / diff(100 * tapply(fr_def[["alpha"]], fr_def[["k"]], mean)), 2), collapse = ", ")`
#' index units per percentage point. `Ne_parents` at $\alpha_{\max} = 0$ ranges from
#' `r fmt(min(fr_ch[["Ne_parents"]][fr_ch[["k"]] == 1]), 1)` to
#' `r fmt(max(fr_ch[["Ne_parents"]][fr_ch[["k"]] == 1]), 1)` over the seeds at the
#' chapter budget.
#' 
#' Interpretation, and what limits it. The DE curve is a price list of this run, not
#' the constrained optimum. At the chapter's evaluation budget part of each price
#' is the optimiser's shortfall: the default budget moves the tighter points by more
#' than their seed-to-seed spread. Its loosest point stays below a feasible plan at
#' both budgets run, so that shortfall is not closed by the
#' `r prod(np_it("default")) / prod(np_it("chapter"))`-fold increase in nominal
#' evaluations ($\texttt{NP} \times \texttt{itermax}$) between them; no larger
#' budget was run. The warm start
#' lacks the truncation plan; whether adding it closes the gap is not run here. How much of the default-budget price is still
#' shortfall is not separated, because no bound (`ocs_bound()`, @sec-bound) is
#' computed here, and all of it is one simulated dataset. The secant slopes show no
#' sharp knee at either budget, and none is located. As in
#' @sec-ocs, where along the frontier to set the budget is the programme's decision.
#' Nor is the trade a permanent loss against a one-off gain: in @sec-cycles the
#' index gain accumulates over cycles, and what the budgets leave for later cycles is
#' that chapter's subject, not this one's.
#' 
#' ## What this simulation cannot tell you {#sec-case-study-limits}
#' 
#' Stated plainly, because the numbers above are precise and precision invites more
#' confidence than the model supports.
#' 
#' **The index carries no prediction error.** The traits are built from *known*
#' marker effects (@sec-simulating-crosses). @sec-choosing (Finding 5) measures,
#' within one cycle at the teaching scale, what happens when they are predicted: the
#' plan's reported index is biased upward, and for truncation at nominal accuracy
#' $r$ = 0.6, error correlated with relatedness costs more gene diversity than
#' independent error of the same nominal accuracy. @sec-genomic-prediction fits the
#' accuracies that validation schemes actually give. The reported `index` of a plan
#' here should be read as an upper bound on what it would deliver in this one cycle;
#' across cycles no such bound is claimed (@sec-cycles, C7).
#' 
#' **The model is additive.** The index is a sum of additive marker effects. It
#' misses heterosis and specific combining ability, which is precisely what a hybrid
#' programme sells. The diversity constraint does not need a dominance model; the
#' *mean-performance ranking* does (@sec-heterosis). Do not conflate them, and do
#' not use these `index` values as performance predictions.
#' 
#' **The pools are symmetric by construction, and still erode unevenly.** Both are
#' drawn from the same ancestral frequencies at the same Balding-Nichols parameter,
#' $F_{BN}$ = `r book_cfg[["fst"]]` (`fst` in `sim_config`, @eq-balding-nichols).
#' Even so, truncation leaves
#' `Ne_lines_A` = `r fmt(d[["Ne_lines_A"]][d[["scenario"]] == "ref_truncation"], 2)`
#' and `Ne_lines_B` = `r fmt(d[["Ne_lines_B"]][d[["scenario"]] == "ref_truncation"], 2)`
#' in @tbl-case-study-metrics. Because the two pools are exchangeable by construction, which
#' of them erodes faster in a run is a property of that draw, not of pool A or B,
#' and this chapter runs one draw. Per-pool reporting (`ne_lines_pool()`) is
#' therefore needed even when the pools are alike. Real pools that differ in size,
#' history and internal structure would add a systematic difference on top, which
#' this simulation does not represent.
#' 
#' **$N_s$ is not a drift projection.** It is a static descriptor of a set, in
#' $[1/2, 1]$ on molecular $\mathbf f$ (@sec-ns). Do not extrapolate it forward.
#' 
#' **What the run assumes and does not test.** The parent lines are fully inbred
#' (A2 of @sec-era-programme). The markers are biallelic and drawn independently
#' (no linkage), and they are also the loci of the index: `simulate_data()` gives
#' every marker an effect on each trait (@sec-simulating-crosses), so the markers the
#' metrics read are themselves under selection. Every one of the 25 x 25 crosses is
#' made and evaluated, so the crossing plan and the testing design that would
#' produce the 625 values (@sec-mating, @sec-sparse, @sec-joint) are assumed away.
#' $n$ is 10 % of the candidates, no line has a usage cap (`max_use = NULL`), and
#' the selector is the hybrid-key DE of `stage2_select()`, not the routes compared in
#' @sec-advanced. Each of these is a choice of this run; none of the numbers above
#' is shown to hold without it.
#' 
#' **One cycle, not a trajectory.** Every result here is a single round of hybrid
#' selection. @sec-stages found, in 8 cached founder pools of one external study,
#' that a diversity term on cross choice at S2 lowered the S2 loss and raised the S3
#' and S4 losses, and could not say whether it changed the effective size of the
#' final set (a set the file does not record) or the marker alleles retained; the
#' gene diversity of the final set, the outcome that was higher with the term in
#' most pools, was added post hoc. The same question applies across cycles. A
#' one-cycle constraint is not a multi-cycle policy: @sec-cycles runs fifteen cycles
#' from five founder draws, and on the mean over draws the unconstrained programme
#' has the higher index in the early cycles and the $\alpha_{\max} = 0.02$ programme
#' in the later ones; the crossing is not resolved by five draws
#' (@sec-cycles-trajectory).
#' 
#' **$p_0$ must be frozen.** `build_ctx()` sets $p_0$ to the column means of the
#' `X` it is given, on every call. This chapter makes one call, so $p_0$ is the
#' frequency over the 625 candidates. In a multi-cycle programme it must be the
#' founder cycle's frequencies, held fixed (`run_cycles()` does so,
#' @sec-cycles-freezing) -- the single most common error in applying `F_hom` and
#' `F_drift` (@sec-genomic-era). @sec-cycles shows the failure directly: re-anchored
#' each generation and read on the set the base was built from, five generations of
#' real drift are reported as exactly none.
#' 
#' ## The operational checklist
#' 
#' ### Setting up
#' 
#' - The base $p_0$ is frozen at the founding cycle and documented.
#' - Diversity is computed on molecular coancestry `f`, never on a centred VanRaden
#'   `G`, whose elements sum to zero by construction (@eq-g-sum-zero,
#'   @sec-why-not-g).
#' - The marker panel's minor allele frequency (MAF) spectrum is known -- it decides how severely the two
#'   lenses diverge.
#' - Heterotic-group assignment is recorded, with the method that produced it, and
#'   treated as uncertain.
#' 
#' ### Choosing the budget
#' 
#' - The attainable ceiling $\alpha_{\text{trunc}}$ is computed *before* choosing
#'   $\alpha_{\max}$ (@sec-ocs). A budget at or above the ceiling constrains nothing.
#' - Loss is measured against a **same-size resampling baseline**, never against the
#'   full pool (@sec-baseline).
#' - The constraint is applied at the target set size, not incrementally.
#' - The frontier is traced and the budget is set on it by the programme, rather
#'   than as a round number fixed in advance. Neither @sec-ocs nor this chapter
#'   finds a sharp knee to locate.
#' 
#' ### Running the optimiser
#' 
#' - The route and its evaluation budget are stated. `stage2_select()`, the route
#'   this chapter runs, is `sel_de()` on $n$ hybrid keys (@sec-combinatorial); the
#'   line-weight encoding is `sel_de_fast()`. No experiment in the book isolates the
#'   encoding, and the closest comparison favours `sel_de()` uncapped
#'   (@sec-advanced).
#' - The differential evolution is **warm-started** from greedy solutions
#'   (@sec-combinatorial-warm).
#' - If a per-line usage cap applies, the way it is enforced is stated: `sel_de()`
#'   adds it to the fitness as a penalty, and `sel_de_fast()` satisfies it in the
#'   decoder by construction (@sec-defast-restrictions). This chapter's run has no
#'   cap.
#' - $N_{e,\text{par}}$ is a report line, read against the random null, unless the
#'   route accepts a floor on it. Among the package's routes only `sel_de_fast()`
#'   does, as a penalty that can bind but is not guaranteed met
#'   (@sec-defast-restrictions); the achieved $N_{e,\text{par}}$ is checked against
#'   the floor. In this chapter it is a report line.
#' - The plan is checked against the Lagrangian bound `ocs_bound()` (@sec-bound),
#'   not against a point of the continuous relaxation inside the budget, which is
#'   not a bound. Its `converged` attribute, a stalling criterion rather than a
#'   certificate, is read first: converged and the gap small, the gap is the most
#'   further search can gain if that criterion is trusted; converged and the gap large,
#'   keep going; not converged, no gap is reported (@sec-advanced). A gap is the sum
#'   of the optimiser's shortfall and the relaxation's, and does not separate them
#'   (@sec-combinatorial). This chapter computes no bound and no gap.
#' 
#' ### Validating the plan
#' 
#' - `F_hom` and `F_drift` are computed **separately** and reported together, with
#'   `cov_diag` as the diagnostic, on a panel not used in the management where one
#'   exists (@sec-era-step5).
#' - Allelic richness $A_{\text{ret}}$ (@sec-richness) is computed on the returned
#'   plan. It is not the only quantity $\theta$ leaves free: `F_drift` is another
#'   (@sec-case-study-lenses), and @sec-choosing (Finding 3) finds A-NE and E-NE
#'   (entry-to-nearest-entry) keeping as much rank
#'   variation at fixed $\theta$ as allelic richness does. This chapter reports
#'   $A_{\text{lost}}$ (`alleles_lost`) and `rare_retained`, not $A_{\text{ret}}$.
#' - The within/between pool decomposition confirms diversity was not preserved by
#'   degrading pool separation.
#' - The number of selected parent lines is biologically plausible.
#' - $N_s$ is reported as a static descriptor in $[1/2, 1]$ (@sec-ns), not as a
#'   head count; a rate-based $N_e$ is **not** reported under active management
#'   (@sec-choosing-recommendation).
#' - Every metric is reported against the random null, in standard deviations; a
#'   constrained metric is read against its budget, not against zero.
#' 
#' ### Across cycles
#' 
#' - The per-stage loss ledger of @sec-stages-ledger is kept (not the year-by-year
#'   diversity ledger of @sec-programme-ledger). In the one study the book has (8
#'   cached founder pools), S2, DH induction, carries the largest share of the
#'   summed stage losses under cross selection on merit alone, and with a diversity
#'   term the three stages carry similar shares (@sec-stages); where diversity goes
#'   in general is not established.
#' - The regression of $\log(1 - F)$ on cycle is checked for linearity
#'   (@sec-era-step4, @sec-cycles-rate). Curvature means a non-constant rate. The
#'   regression is read as that diagnostic and is not converted into a rate-based
#'   $N_e$; a high $R^2$ does not validate a projection from the fitted rate, and
#'   the covariance term is outside every one-locus metric (@sec-limits).
#' - Periodic germplasm injection is planned. The evidence is one simulation
#'   reviewed in @sec-plant-literature [@sanchez2023], in which a closed elite pool
#'   depletes under a within-pool constraint, and @sec-cycles, in which all three
#'   closed budgets are still losing diversity at cycle 15 (five founder draws).
#'   Injection has a cost: there one injection of the programme's own founder lines
#'   raised $GD_T$ and lowered $F_{drift}$ and the index, and the index had not
#'   recovered by cycle 15.
#' - The diversity cost per cycle is reported when cycle time is shortened. No
#'   chapter of this book measures it as a rate: @sec-programme reports the cost of
#'   shorter cycles as a 15-year stock because its cycles overlap, and @sec-cycles
#'   has discrete cycles of fixed length.
#' 
#' ## Where to go next
#' 
#' Three extensions the material here supports but does not cover, each needing new
#' work rather than new derivation:
#' 
#' **Real data ingestion.** `load_data()` is the single swap point and is currently
#' a stub. A worked path from a variant call format (VCF) file to the `X`/`f`/`hybrids` contract is what most
#' readers will need first, and it is the one extension here that is pure
#' engineering rather than new derivation.
#' 
#' **Estimating the dominance effects.** @sec-heterosis shows that expected
#' heterosis depends on the alignment between divergence and $d$, and that no
#' frequency-based statistic can see $d$. Ranking crosses on more than the mean needs
#' the dominance effects locus by locus, which the book does not estimate. Setting
#' the $\lambda$ of @sec-catalogue needs less: two covariances of $d$ with the
#' frequencies, not $d$ itself (@sec-heterosis-lambda). @sec-heterosis-protocol sets
#' out what a programme would run to obtain them.
#' 
#' **Prediction error compounded across cycles.** @sec-choosing Finding 5 measures it
#' within one cycle and @sec-cycles assumes it away (C7). The two have not been run
#' together. Correlated error concentrates the selection (@sec-choosing), and in
#' @sec-cycles the per-cycle gain is associated with the genic variance of the
#' parents, an association that chapter does not test as a mechanism; how the two
#' would combine across cycles is not known.
