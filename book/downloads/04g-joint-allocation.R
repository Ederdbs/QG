#' # Which crosses, at which locations? Joint sparse allocation {#sec-joint}
#' 
# 04g-joint-allocation -- standalone script of the chapter 04g-joint-allocation.qmd
# Book: https://ederdbs.github.io/QG/04g-joint-allocation.html
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
js <- read.csv(book_data("joint_core_sweep.csv"))
jc <- read.csv(book_data("joint_contrasts.csv"))
jo <- read.csv(book_data("joint_optimiser.csv"))
r3 <- function(x) sprintf("%.3f", x)
strat_col <- c(random = "#d95f02", coverage = "#1b9e77", optimised = "#7570b3")
# Pooled paired contrast: mean of the cell differences, SE of that mean.
pooled <- function(ct, m = "acc_all", by = NULL) {
  x <- jc[jc$contrast == ct & jc$metric == m, ]
  g <- if (is.null(by)) list(all = x) else split(x, x[[by]])
  do.call(rbind, lapply(names(g), function(n) {
    y <- g[[n]]
    data.frame(group = n, cells = nrow(y), diff = mean(y$diff),
               se = sqrt(sum(y$se^2)) / nrow(y), positive = sum(y$diff > 0))
  }))
}
js$config <- with(js, ifelse(plan == "tester", "tester k=2",
                             paste0(plan, " c=", c)))
js$label <- paste0(js$config, ", ", js$k, " loc")
cell <- function(cfg, k, s, h, sca = "low", v = "acc_all")
  js[js$config == cfg & js$k == k & js$strategy == s & js$h2_plot == h &
       js$sca == sca, v]

#' 
#' @sec-mating chose **which crosses** to make from two pools, with the field
#' design held fixed. @sec-sparse chose **which locations** each hybrid goes to,
#' with the whole factorial taken as given. A programme makes both decisions out
#' of one budget, in the same season, and each changes what the other can do: a
#' cross that is not made cannot be planted anywhere, and a cross planted in one
#' location says nothing about the others except through its parents. This
#' chapter treats the two as one decision.
#' 
#' Within the search reported in @sec-joint-literature, the literature has not.
#' It finds strong methods for each half -- model-based
#' designs that place entries in environments using genetic relatedness, and
#' training-set criteria that choose which single crosses to phenotype -- but no
#' method that chooses the crosses and their locations together for a two-pool
#' hybrid programme. That is an absence of evidence from one search, not a proof
#' of absence. The nearest treatments either optimise the crosses
#' and leave the environments to the trial manager [@heslot2020; @kadam2021], or
#' optimise the environments for a fixed entry list [@cullis2020;
#' @montesinoslopez2022ibd]. @sec-mating-open listed this as its second gap and
#' @sec-sparse-limits asked for the female x male x location connectivity metric
#' that it needs; both are taken up here.
#' 
#' The results this chapter defends:
#' 
#' 1. **At a fixed budget, distinct crosses beat locations per cross for
#'    predicting all hybrids.** Spending 160 plots as 160 crosses at one location
#'    each beat 80 at two, which beat 40 at four, in the direction of every
#'    scenario simulated; not every single step is resolved by 30 replicates, and
#'    the margin grows with SCA. For the crosses that were made the comparison
#'    reverses: 40 crosses at four locations estimate those better than 160 at
#'    one. The split of the
#'    budget is therefore a statement about what will be selected.
#' 2. **Allocation strategy is a second-order decision.** With the plan and the
#'    locations per cross fixed, a placement that keeps as much of both pools as
#'    possible in each location raises parent coverage substantially, but its
#'    accuracy gain over random placement of the same plan is not detected: half
#'    a point at most on the point estimate, at 1.7 standard errors, and none in
#'    the tester design.
#' 3. **The PEV criterion ranks plans, not placements.** The mean PEV of GCA,
#'    computable before planting, orders the budget splits much as accuracy does.
#'    An exchange search on it, run for 600 proposals, lowered PEV below its own
#'    greedy start by a fraction of a percent and bought no accuracy overall (the
#'    tester design is a tentative exception). The search had not converged, so
#'    this bounds what 600 proposals buy, not what placement optimisation can.
#' 
#' ::: {.callout-note}
#' ## Where the numbers come from
#' 
#' Everything here is reproducible from this repository.
#' 
#' - **Live** results run at render time with `R/18_joint_allocation.R`, which
#'   builds the allocation matrix of `R/17_sparse_testing.R` with zero rows for
#'   crosses that are not made, so the R/17 simulator, mixed-model solve and
#'   connectivity diagnostics take it unchanged.
#' - **In-repo** results come from `Rscript book/scripts/regenerate.R joint`
#'   (`joint_core_sweep.csv`, `joint_contrasts.csv`, `joint_optimiser.csv`;
#'   about 30 minutes of CPU): 20 x 20 pools in half-sib families of four, eight
#'   locations, **known** variance components, 30 replicates per cell. Strategy
#'   comparisons are **paired**: within a replicate the designs share the plan
#'   and the true values.
#' 
#' There is no cached external study behind this chapter, unlike @sec-mating and
#' @sec-sparse.
#' :::
#' 
#' ## Why the two decisions are one {#sec-joint-why}
#' 
#' Write $n_c$ for the number of distinct crosses made, $k$ for the number of
#' locations each cross is planted in, and $r$ for plots per cross per location.
#' The field budget is
#' 
#' $$
#' B = n_c \, k \, r .
#' $$
#' 
#' @sec-mating varied $n_c$ (through the crosses per line $c$, $n_c = c\,n_F$ for
#' a circulant plan) at fixed $k$; @sec-sparse varied $k$ and the layout at fixed
#' $n_c = n_F n_M$. At $r = 1$, which is the stage-1 norm, fixing $B$ ties the two
#' together: halving the crosses doubles the locations each one can see. Neither
#' chapter could ask which way to spend the budget, because each held the other
#' term fixed.
#' 
#' The two terms buy different things. More crosses put more lines into data and
#' sample more of the factorial, which is what predicts the crosses never made
#' (@sec-mating-genomic; @melchinger2023). More locations per cross sample more of
#' the target population of environments, which is what shrinks the
#' genotype x location noise around each GCA (@sec-sparse-results, result 2;
#' @werner2025). Which matters more depends on the ratio of SCA to GCA variance,
#' on the share of genotype x location in the genetic variance, and on how well
#' the relationship matrix links lines across families -- precisely the
#' quantities a programme knows least about at stage 1.
#' 
#' ## The joint model {#sec-joint-model}
#' 
#' The model is @sec-sparse's, unchanged:
#' 
#' $$
#' y_{ijl} = \mu + \ell_l + g^F_i + g^M_j + s_{ij}
#'         + (g^F\ell)_{il} + (g^M\ell)_{jl} + (s\ell)_{ijl} + e_{ijl},
#' $$
#' 
#' with $g^F \sim N(0, A_F\sigma^2_F)$, $g^M \sim N(0, A_M\sigma^2_M)$,
#' $s \sim N(0, (A_F \otimes A_M)\sigma^2_S)$ and the interactions with location
#' carrying the same kernels crossed with an identity over locations. The target
#' is the value in the target population of environments, $g^F_i + g^M_j + s_{ij}$.
#' 
#' One simplification is inherited from @sec-sparse and must be declared. With
#' one plot per cross per location, $(s\ell)_{ijl}$ and $e_{ijl}$ have the same
#' incidence, so the analysis model cannot separate them and carries their sum as
#' an i.i.d. residual of variance $\sigma^2_{S\ell} + \sigma^2_e$. The
#' simulator draws $(s\ell)$ with the kernel $(A_F \otimes A_M)$, so the analysis
#' model is misspecified, by an amount this chapter does not quantify: the BLUP and every PEV below are exact for the
#' *analysis* model, not for the model that generated the data.
#' 
#' What is new is only the incidence. A crossing plan $P \subset \{1..n_F\} \times
#' \{1..n_M\}$ and an allocation give a 0/1 matrix $M$ of size
#' $n_F n_M \times L$ in which a row is zero whenever $(i, j) \notin P$. Every row
#' in $P$ sums to $k$. The R/17 functions accept such an $M$ directly; the unmade
#' crosses are predicted through $A_F$, $A_M$ and the GCA they share with made
#' crosses -- the CV1 prediction of @sec-sparse-validation, now produced by the
#' crossing plan rather than by a mask.
#' 
## -----------------------------------------------------------------------------
#| label: joint-incidence
p <- design_circulant(6, 6, c = 2)            # 12 of 36 possible crosses
M <- joint_alloc(p, 6, 6, nLoc = 3, k = 1, strategy = "coverage")
c(crosses_made = sum(rowSums(M) > 0), plots = sum(M), per_location = colSums(M))

#' 
#' ## What the literature offers {#sec-joint-literature}
#' 
#' The search was run in October 2026 over three sources: the Consensus index
#' of peer-reviewed papers (Semantic Scholar, OpenAlex and PubMed), Crossref,
#' and a general web search, with the bioRxiv and Crop Science / Plant Genome
#' literature reached through them. Queries combined *sparse testing*,
#' *multi-environment trial*, *allocation of genotypes / hybrids to
#' environments*, *incomplete factorial*, *mating design*, *training set
#' optimisation*, *CDmean*, *A-optimality* and *genetic relatedness*, with and
#' without *hybrid* and *maize*. It looked for methods that allocate entries to
#' environments, choose crosses or training hybrids, or both. Six families of
#' approach emerge. None was built for the joint problem, but each supplies a
#' piece. The training-set optimisation line of @akdemir2021,
#' @isidroysanchez2021 and @fernandezgonzalez2023 is the nearest neighbour not
#' in the table: its tools select genotypes for a training set, and could in
#' principle be pointed at genotype-environment pairs, but none of the papers
#' found does so for a crossing plan.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-joint-literature
#| tbl-cap: "Current approaches, what each optimises, and what each holds fixed. The last column is the piece the joint problem borrows."
lit <- data.frame(
  Approach = c("Model-based design with relatedness",
               "CD / PEV criteria for multi-environment trials",
               "Choosing hybrids to create and phenotype",
               "Allocation by incomplete-block principle",
               "Environment structure in allocation",
               "Sparse factorials and sparse testcrossing"),
  Optimises = c("Entry placement in plots and environments (A-optimality on the mixed-model equations)",
                "Multi-environment design, forecast under a G x E model",
                "Which single crosses to make and phenotype",
                "Which lines go to which environment",
                "Replication and sparsity across mega-environments",
                "Crosses per line, testers per family"),
  `Held fixed` = c("The entry list", "The entry list", "The environments",
                   "The entry list", "The entry list", "The environments"),
  Borrowed = c("The criterion (PEV of GCA)", "Reliability forecast before planting",
               "Exchange search over a binary design", "Balance of location loads",
               "Locations are not exchangeable", "Parent coverage, connectivity"),
  Refs = c("butler2014; cullis2020; lisle2021", "rio2022",
           "heslot2020; kadam2021", "montesinoslopez2022ibd; montesinoslopez2023; lell2021; mothukuri2025",
           "gonzalezbarrios2019; hoefler2026",
           "seye2020; lorenzi2022; melchinger2023; gonzalezdieguez2026"),
  check.names = FALSE)
knitr::kable(lit, row.names = FALSE)

#' 
#' **Model-based design with relatedness.** @butler2014 and @cullis2020 generate
#' field designs by optimising a criterion -- the A-optimality of the predicted
#' genetic effects -- computed from the linear mixed model that will analyse the
#' trial, with the relationship matrix inside it. Their in-silico studies show
#' that designs built this way are more accurate than designs built for
#' unrelated entries. @lisle2021 add an information-based diagnostic for whether a
#' multi-environment design can estimate its genetic variance parameters at all.
#' This is the most principled framework available, and the criterion this
#' chapter uses is its restriction to the GCA effects. What it does not do is
#' choose the entries: the list of varieties is an input.
#' 
#' **CD and PEV criteria for multi-environment trials.** @rio2022 extend the
#' coefficient of determination, the CDmean of @rincent2012, to G x E models, so
#' that the reliability of a multi-environment design can be forecast before it is
#' planted and the design optimised on it, for a given set of genotypes.
#' 
#' **Choosing which hybrids to create.** @kadam2021 apply PEV and CDmean to single
#' crosses and show that optimising over *all possible* crosses, not only the
#' ones already made, gives a better training set -- the crossing half of the
#' joint problem, with the environment design held fixed. @heslot2020 are the
#' closest methodological precedent. They optimise which maize hybrids to create and phenotype, to best
#' predict the unobserved combinations, with a mixed binary-integer differential
#' evolution, and extend the method to designing a connected population before
#' the crosses are made. The environments are again outside the optimisation.
#' 
#' **Allocation by incomplete-block principle.** @montesinoslopez2022ibd allocate
#' lines to locations with an incomplete block design and beat random allocation
#' by 1.4 to 26.5 % in mean squared error; @montesinoslopez2023 find balanced
#' incomplete blocks and random allocation close. @lell2021, on 1,604 wheat
#' hybrids, find the best design splits the hybrids into equal subgroups each
#' tested in an overlapping subset of environments. @mothukuri2025 use the
#' relationship between fully and sparsely tested maize lines to guide the split,
#' with a weak positive correlation (0.20 to 0.31) between the relationship
#' measures and accuracy. All four take the entries as given.
#' 
#' **Environment structure.** The mega-environmental design of
#' @gonzalezbarrios2019 allocates entries so that each mega-environment is
#' sampled, and reports a 40 % gain in response for the same resources;
#' @hoefler2026 optimise its replication and sparsity by simulation. Both are
#' reminders that the locations here are treated as exchangeable, which a real
#' target population of environments is not.
#' 
#' **Sparse factorials and sparse testcrossing.** @seye2020, @lorenzi2022 and
#' @melchinger2023 establish that sparse factorials train hybrid prediction at
#' least as well as tester designs, and that fewer crosses per line favours the
#' lines never crossed; @gonzalezdieguez2026 spread three to five testers among
#' full-sibs. @thomsen2026 analyse oilseed-rape hybrids under sparse
#' multi-environment testing, observationally. @schoemaker2024 trade testers
#' against environments in maize and find three to five well-chosen environments
#' match ten random ones -- the closest empirical look at one corner of the joint
#' budget.
#' 
#' The gap is therefore precise. The criteria exist (PEV and CD with
#' relatedness), the search methods exist (exchange algorithms, differential
#' evolution), and both halves have been optimised separately. What is missing is
#' the object that holds the crossing plan and the allocation together under one
#' budget, and evidence on how the budget should be split.
#' 
#' ## Design criteria computable before planting {#sec-joint-criteria}
#' 
#' Two quantities can be read off $M$ before a seed is sown.
#' 
#' **The mean PEV of GCA.** The left-hand side of the mixed-model equations
#' depends on the design alone, so its inverse, and with it the prediction error
#' variance of every GCA effect, is known before any phenotype exists.
#' `joint_pev()` returns the mean over the $n_F + n_M$ GCA effects. It is the
#' A-optimality criterion of @butler2014 restricted to the effects parents are
#' selected on; with known components it is exact for the analysis model of
#' @sec-joint-model, and @tbl-joint-live shows it ranking allocations of the same
#' plan. It is blind to two things a programme may care about: SCA, and the
#' difference between predicting crosses that were made and crosses that were
#' not.
#' 
#' **Two component counts.** A single graph with females, males and locations
#' as nodes is the obvious female x male x location metric, and it is wrong: a
#' location node joins every parent planted there, so at one location it reports
#' one component for any crossing plan, including two disconnected NC II blocks.
#' A shared location links only *sums* of GCA. `joint_connectivity()` therefore
#' returns two counts alongside the R/17 diagnostics:
#' 
#' - `n_comp_cross`, the components of the female x male graph of the crosses
#'   that receive a plot, pooled over locations. GCA is a main effect shared by
#'   every location, so this is what links GCA contrasts by data, and at one
#'   location it is exactly the bipartite count of @sec-mating-connectivity.
#' - `n_comp_loc`, the components of the location graph in which two locations
#'   are joined when they share a parent. Location contrasts are linked by data
#'   only when it is 1.
#' 
#' Both equal to 1 is *necessary*, not sufficient: a relationship matrix can link
#' families the data do not, and shared parents link locations only through those
#' parents' GCA. This pair is the female x male x location metric
#' @sec-sparse-limits asked for.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-joint-live
#| tbl-cap: "One crossing plan (circulant, 3 crosses per line, 10 x 10), three allocations over 4 locations at 2 locations per cross. Mean PEV of GCA (lower is better), share of each pool present per location, and the two component counts. Live."
set.seed(11)
vc <- sparse_vc(0.3); A <- relmat_halfsib(10, 2)
p <- design_circulant(10, 10, c = 3)
live <- do.call(rbind, lapply(names(strat_col), function(s) {
  M <- joint_alloc(p, 10, 10, nLoc = 4, k = 2, strategy = s, vc = vc,
                   Af = A, Am = A, n_iter = 100)
  cn <- joint_connectivity(M, 10, 10)
  data.frame(strategy = s, plots = sum(M), pev_gca = joint_pev(M, 10, 10, vc, A, A),
             fem_cover = cn$fem_cover, male_cover = cn$male_cover,
             n_comp_cross = cn$n_comp_cross, n_comp_loc = cn$n_comp_loc)
}))
knitr::kable(fmt(live, 4), row.names = FALSE)

#' 
#' ## What the simulation finds {#sec-joint-results}
#' 
#' The sweep crosses six configurations that all spend 160 plots (the tester design
#' 152) -- circulant plans with 8, 4 and 2 crosses per line at 1, 2 and 4
#' locations per cross, random sparse plans with 8 and 4, and a two-tester design
#' at two locations -- with the allocation strategies, two plot heritabilities
#' and two SCA levels (`sparse_vc()`: SCA a quarter of, or equal to, a GCA
#' variance; genotype x location half of each main effect, so a genetic
#' correlation of 2/3 between locations). Pools are 20 x 20 in half-sib families
#' of four; eight locations; 30 replicates per cell.
#' 
#' The comparisons are paired. In each replicate one plan is drawn; `random` and
#' `coverage` allocate that same plan; and every design is simulated from the
#' same seed, so they share the true genetic values (`sparse_simulate()` draws
#' every effect before it looks at the allocation). The exchange search is too
#' slow to repeat per replicate, so per cell one plan gets a coverage allocation
#' (`start`) and a search from it; those two fixed designs are then simulated in
#' every replicate with the same seed, which pairs `optimised` with its own start.
#' 
#' ### 1. The budget split: crosses against locations
#' 
## -----------------------------------------------------------------------------
#| label: fig-joint-budget
#| fig-width: 9
#| fig-height: 5.2
#| fig-cap: "Accuracy over all 400 possible hybrids at 160 plots (tester 152), by configuration (crosses per line, locations per cross) and allocation strategy, in the four variance scenarios. Bars are two standard errors of the cell mean. `optimised` is one fixed design per cell. In-repo sweep, known components, 30 replicates."
#| fig-alt: "Accuracy over all hybrids at a fixed plot budget, by crossing plan, locations per cross and allocation strategy"
lev <- c("circulant c=8, 1 loc", "circulant c=4, 2 loc", "circulant c=2, 4 loc",
         "random c=8, 1 loc", "random c=4, 2 loc", "tester k=2, 2 loc")
op <- par(mfrow = c(2, 2), mar = c(7.5, 4, 2, 0.5), mgp = c(2.4, 0.7, 0))
for (sc in c("low", "high")) for (h in c(0.2, 0.4)) {
  d <- js[js$sca == sc & js$h2_plot == h, ]
  plot(NA, xlim = c(0.5, length(lev) + 0.5), ylim = range(js$acc_all) + c(-0.04, 0.04),
       xaxt = "n", xlab = "", ylab = "Accuracy, all hybrids",
       main = sprintf("h2 = %.1f, SCA %s", h, sc), cex.main = 0.95, font.main = 1)
  axis(1, at = seq_along(lev), labels = lev, las = 2, cex.axis = 0.75)
  for (j in seq_along(strat_col)) {
    e <- d[d$strategy == names(strat_col)[j], ]
    x <- match(e$label, lev) + (j - 2) * 0.2
    arrows(x, e$acc_all - 2 * e$acc_all_se, x, e$acc_all + 2 * e$acc_all_se,
           angle = 90, code = 3, length = 0.02, col = strat_col[j])
    points(x, e$acc_all, pch = 19, col = strat_col[j])
  }
  if (sc == "high" && h == 0.2)
    legend("topright", legend = names(strat_col), col = strat_col, pch = 19,
           bty = "n", cex = 0.8)
}
par(op)

#' 
## -----------------------------------------------------------------------------
#| include: false
# The circulant trade-off, coverage allocation (redrawn per replicate). Cells
# for different c are independent, so z uses both standard errors.
cc <- js[js$plan == "circulant" & js$strategy == "coverage", ]
cv <- function(c, h, sc, v = "acc_all")
  cc[cc$c == c & cc$h2_plot == h & cc$sca == sc, v]
zc <- function(c1, c2, h, sc, v = "acc_all")
  (cv(c1, h, sc, v) - cv(c2, h, sc, v)) /
    sqrt(cv(c1, h, sc, paste0(v, "_se"))^2 + cv(c2, h, sc, paste0(v, "_se"))^2)
z84 <- mapply(zc, 8, 4, c(0.2, 0.4, 0.2, 0.4), c("low", "low", "high", "high"))
z42 <- mapply(zc, 4, 2, c(0.2, 0.4, 0.2, 0.4), c("low", "low", "high", "high"))
zm <- mapply(zc, 2, 8, c(0.2, 0.4, 0.2, 0.4), c("low", "low", "high", "high"),
             MoreArgs = list(v = "acc_made"))
tst <- js[js$plan == "tester" & js$strategy == "coverage", ]

#' 
#' @fig-joint-budget reads left to right along the budget identity. Within the
#' circulant family, with the coverage allocation, 160 crosses at one location
#' each reach `r r3(cv(8, 0.4, "low"))` at $h^2 = 0.4$ and low SCA, 80 crosses
#' at two locations `r r3(cv(4, 0.4, "low"))`, and 40 at four
#' `r r3(cv(2, 0.4, "low"))`. With high SCA the steps are larger --
#' `r r3(cv(8, 0.4, "high"))`, `r r3(cv(4, 0.4, "high"))`,
#' `r r3(cv(2, 0.4, "high"))` -- because a cross that is not made has an SCA no
#' replication of other crosses can reveal. The order holds in all four
#' scenarios. Its size is uneven: the step from 80 to 160 crosses is
#' `r sprintf("%.1f", min(z84))` to `r sprintf("%.1f", max(z84))` standard errors
#' of the difference across scenarios, the step from 40 to 80
#' `r sprintf("%.1f", min(z42))` to `r sprintf("%.1f", max(z42))`. The 160-versus-80
#' step at low SCA and the 80-versus-40 step at $h^2 = 0.2$ with high SCA are
#' not resolved by 30 replicates; only their direction agrees with the rest. The two-tester design, with 76 crosses at two locations, sits
#' below the circulant plan with 80 crosses at two locations in every scenario,
#' at nearly the same budget (152 against 160 plots).
#' 
#' For the crosses that were made the comparison reverses (@tbl-joint-made),
#' though not step by step: at $h^2 = 0.2$ and high SCA, 80 crosses at two
#' locations are no better than 160 at one. Forty
#' crosses at four locations estimate *those* crosses at
#' `r r3(cv(2, 0.4, "low", "acc_made"))`, against
#' `r r3(cv(8, 0.4, "low", "acc_made"))` for 160 crosses at one location
#' ($h^2 = 0.4$, low SCA; `r sprintf("%.1f", min(zm))` to
#' `r sprintf("%.1f", max(zm))` standard errors across scenarios), because each
#' is seen in four environments rather than one. A programme that picks parents
#' on GCA, or will choose among all possible single crosses with a prediction
#' model, should spend the budget on distinct crosses. A programme that will
#' advance only crosses it has made gets better estimates of those crosses from
#' more locations -- but it then chooses among 40 candidates instead of 160, and
#' the response to selection depends on that intensity as well as on accuracy.
#' This chapter measures accuracy only; it does not settle that trade.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-joint-made
#| tbl-cap: "The circulant trade-off at 160 plots, coverage allocation: accuracy over all hybrids, over the crosses made, and over those not made, with standard errors of the cell means."
tb <- cc[order(cc$sca, cc$h2_plot, -cc$c), ]
tb$crosses <- tb$c * 20
knitr::kable(fmt(tb[, c("sca", "h2_plot", "crosses", "k", "acc_all", "acc_all_se",
                        "acc_made", "acc_made_se", "acc_unmade")], 3),
             row.names = FALSE,
             col.names = c("SCA", "Plot h2", "Crosses", "Loc./cross", "All", "SE",
                           "Made", "SE", "Not made"))

#' 
#' The result of @sec-sparse that spreading a fixed number of plots per hybrid
#' over more locations raises accuracy (@sec-sparse-results, result 2) is not
#' contradicted. There each hybrid kept two plots and the factorial was complete;
#' here every extra location per cross is paid for with a cross. Spreading wins
#' when it is free and loses, on all-hybrid accuracy, when it costs crosses. That
#' was measured at one genetic correlation between locations, 2/3. A lower
#' correlation makes each location carry less information about the others, which
#' would be expected to move the optimum toward more locations per cross; this
#' sweep did not test it.
#' 
#' ### 2. Allocation strategy, with the plan fixed
#' 
## -----------------------------------------------------------------------------
#| include: false
pc_all  <- pooled("coverage - random")
pc_plan <- pooled("coverage - random", by = "plan")
po_all  <- pooled("optimised - start")
cov_r <- mean(js$fem_cover[js$strategy == "random" & js$plan != "tester"])
cov_c <- mean(js$fem_cover[js$strategy == "coverage" & js$plan != "tester"])
cov_t <- c(mean(js$fem_cover[js$strategy == "random" & js$plan == "tester"]),
           mean(js$fem_cover[js$strategy == "coverage" & js$plan == "tester"]))
cell_z <- with(jc[jc$contrast == "coverage - random" & jc$metric == "acc_all", ], diff / se)

#' 
#' With the plan and $k$ fixed, the strategies are close (@fig-joint-budget). The
#' paired contrasts (@tbl-joint-strategy) resolve what the cell means cannot.
#' Coverage does what it is built to do: in the factorial plans the share of
#' females present per location rises from `r r3(cov_r)` under random placement
#' to `r r3(cov_c)`. Paired against random placement of the same plan, the
#' accuracy difference over all hybrids, averaged over the 24 cells, is
#' `r sprintf("%+.4f", pc_all$diff)` $\pm$ `r sprintf("%.4f", pc_all$se)`
#' (z = `r sprintf("%.1f", pc_all$diff / pc_all$se)`; `r pc_all$positive` of 24
#' cells positive). That is below the two-standard-error bar this chapter uses,
#' so the gain is **not detected**; only `r sum(abs(cell_z) > 2)` of the 24 cells
#' differ by more than two standard errors on their own, about what chance
#' gives. The tester design is the exception in the other direction:
#' there coverage moves the share of each pool present per location only from
#' `r r3(cov_t[1])` to `r r3(cov_t[2])` -- each tester already sits in most
#' locations -- and the paired difference is
#' `r sprintf("%+.3f", pc_plan$diff[pc_plan$group == "tester"])` $\pm$
#' `r sprintf("%.3f", pc_plan$se[pc_plan$group == "tester"])`. An earlier,
#' unpaired version of this sweep had suggested the opposite for the tester
#' design; with the plan and the truth held fixed, the suggestion does not
#' survive.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-joint-strategy
#| tbl-cap: "Paired contrasts in accuracy over all hybrids, pooled over the four variance scenarios within each plan family (and over everything in the last row of each block). `diff` is the mean paired difference, `SE` its standard error, `positive` the number of cells with a positive difference."
st <- rbind(cbind(contrast = "coverage - random",
                  rbind(pc_plan, pc_all)),
            cbind(contrast = "optimised - start",
                  rbind(pooled("optimised - start", by = "plan"), po_all)))
knitr::kable(fmt(st, 4), row.names = FALSE,
             col.names = c("Contrast", "Plan family", "Cells", "diff", "SE", "Positive"))

#' 
#' This replicates, with the plan now variable, the finding of @sec-sparse that
#' structured layouts matter little except at extreme sparsity, and it sits with
#' the mixed record of the literature: @montesinoslopez2022ibd found incomplete
#' blocks better than random, @montesinoslopez2023 found them close. When every
#' line appears in several crosses spread over eight locations, random placement
#' already puts most parents in most locations; whatever coverage adds -- at
#' most about half a point on the point estimate -- is small next to the budget
#' split.
#' 
#' ### 3. What the criterion can and cannot see
#' 
## -----------------------------------------------------------------------------
#| label: fig-joint-pev
#| fig-width: 6.5
#| fig-height: 4.3
#| fig-cap: "Mean PEV of GCA, computed before planting, against realised accuracy over all hybrids. One point per configuration x strategy x scenario; colour is the strategy. In-repo sweep."
#| fig-alt: "Mean prediction error variance of GCA against realised accuracy, one point per design cell"
jp <- js[js$strategy %in% names(strat_col), ]
op <- par(mar = c(4.2, 4.2, 1, 1))
plot(jp$pev_gca, jp$acc_all, pch = 19, col = strat_col[jp$strategy],
     xlab = "Mean PEV of GCA (before planting)", ylab = "Accuracy, all hybrids")
legend("topright", legend = names(strat_col), col = strat_col, pch = 19, bty = "n", cex = 0.8)
par(op)
r_pev <- cor(jp$pev_gca, jp$acc_all)
# Rank agreement between PEV and accuracy over the six configurations, per scenario.
cvr <- js[js$strategy == "coverage", ]
rho <- sapply(split(cvr, paste(cvr$h2_plot, cvr$sca)),
              function(d) cor(d$pev_gca, d$acc_all, method = "spearman"))
rho_made <- sapply(split(cvr, paste(cvr$h2_plot, cvr$sca)),
                   function(d) cor(d$pev_gca, d$acc_made, method = "spearman"))
g300 <- median(1 - jo$pev_300 / jo$pev_start)
g600 <- median(1 - jo$pev_600 / jo$pev_start)
spread <- sapply(split(jp, paste(jp$label, jp$h2_plot, jp$sca)),
                 function(d) diff(range(d$pev_gca)) / min(d$pev_gca))
second <- (jo$pev_300 - jo$pev_600) / (jo$pev_start - jo$pev_300)
pot <- pooled("optimised - start", by = "plan")
pot <- pot[pot$group == "tester", ]

#' 
#' Across all cells the mean PEV of GCA correlates with accuracy over all hybrids
#' at `r sprintf("%.2f", r_pev)` (@fig-joint-pev; lower PEV, higher accuracy).
#' Almost all of that comes from the plan and the scenario: the clusters are
#' configurations, and within a cluster the strategies differ by
#' `r sprintf("%.1f", 100 * min(spread))` to `r sprintf("%.1f", 100 * max(spread))` %
#' in PEV (median `r sprintf("%.1f", 100 * median(spread))` %).
#' Over the six configurations of one scenario, the rank correlation between PEV
#' and all-hybrid accuracy is `r sprintf("%.2f", min(rho))` to
#' `r sprintf("%.2f", max(rho))`. The criterion is therefore a usable screen for
#' *which plan and how many locations per cross* -- it can be computed for every
#' split of a budget in seconds -- but only for that objective. Against accuracy
#' on the crosses that were made its rank correlation is
#' `r sprintf("%.2f", min(rho_made))` to `r sprintf("%.2f", max(rho_made))`:
#' mean PEV of GCA cannot see SCA or the made/unmade distinction, so it steers a
#' programme that selects only among made crosses the wrong way.
#' 
#' As a guide to fine placement it is weak, and the exchange search shows it from
#' the other side (@tbl-joint-optimiser). From the coverage start, 300 proposals
#' lowered PEV by a median `r sprintf("%.2f %%", 100 * g300)` and 600 by
#' `r sprintf("%.2f %%", 100 * g600)`, at about
#' `r sprintf("%.0f", median(jo$sec_600))` seconds per design against a
#' millisecond for the greedy start. Paired against its own start the optimised
#' design changed accuracy by `r sprintf("%+.4f", po_all$diff)` $\pm$
#' `r sprintf("%.4f", po_all$se)` overall. The one family that stands out is the
#' tester design, `r sprintf("%+.3f", pot$diff)` $\pm$ `r sprintf("%.3f", pot$se)`
#' with all four cells positive, where the search also found the largest PEV
#' reductions. It is tentative: each cell is one optimised design from one plan,
#' and it is one of three plan families, with no correction for that. The search is first-improvement with no
#' convergence test, and it had not converged: the second 300 proposals added a
#' median `r sprintf("%.0f", 100 * median(second))` % of what the first 300
#' achieved, and in `r sum(second > 0.65)` of 24 cells 65 % or more. PEV was still
#' falling. These results therefore say what 600 proposals buy -- a fraction of a
#' percent of PEV and no detected accuracy -- not what a converged placement
#' optimiser would buy. The
#' optimised-block design of the external study behind @sec-sparse showed the
#' same absence of gain on untested hybrids.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-joint-optimiser
#| tbl-cap: "The exchange search on mean PEV of GCA, one design per cell: PEV of the coverage start and after 300 and 600 proposals. Seconds are CPU-bound wall time (the last three cells ran across a machine sleep and are omitted)."
ot <- jo[order(jo$sca, jo$h2_plot, jo$plan, -jo$c), ]
ot$sec_600 <- ifelse(ot$sec_600 > 600, NA, round(ot$sec_600))
knitr::kable(fmt(ot[, c("plan", "c", "k", "h2_plot", "sca", "pev_start", "pev_300",
                        "pev_600", "sec_600")], 4), row.names = FALSE,
             col.names = c("Plan", "c", "Loc./cross", "Plot h2", "SCA", "PEV start",
                           "PEV 300", "PEV 600", "Seconds"))

#' 
#' The component counts were 1 in almost every replicate. The exception is
#' informative: in two of the 120 random sparse plans with 4 crosses per line
#' (one replicate in each of two scenarios, appearing under both strategies that
#' share the plan), the draw split the factorial into two components (`n_comp_cross = 2`) -- a defect of the plan
#' that no allocation can repair, visible before a seed is sown. Location
#' connectivity (`n_comp_loc`) was 1 throughout: with several crosses per line
#' over eight locations, locations always shared parents.
#' 
#' ### Limitations of the simulation
#' 
#' - **Known variance components.** The criterion and the BLUP use the true
#'   values; REML on a sparse trial is the weak point @sec-sparse-results found.
#' - **A misspecified analysis model**: SCA x location is absorbed into an i.i.d.
#'   residual (@sec-joint-model).
#' - **Exchangeable locations** with a genetic correlation of 2/3 between every
#'   pair. Mega-environment structure [@gonzalezbarrios2019; @hoefler2026] would
#'   favour allocations that sample each mega-environment, which the coverage
#'   rule does not see.
#' - **Half-sib relationships and one plot per cell.** No markers, no spatial
#'   trend, no replicated checks.
#' - **One budget, one scale**: 160 plots, 20 x 20 pools, eight locations.
#' - **Accuracy, not response.** Selection intensity differs between 40 and 160
#'   candidates and is not modelled.
#' - **The optimised strategy** was searched once per cell, from one plan, with
#'   600 first-improvement proposals.
#' 
#' ## Practical recommendations {#sec-joint-recommendations}
#' 
#' ::: {.callout-tip}
#' ## A checklist for a joint crossing and testing plan
#' 
#' 1. **Fix the budget in plots, $B = n_c k r$**, and the locations available.
#'    Everything below trades inside it.
#' 2. **Decide what will be selected.** If parents are chosen on GCA, or any single
#'    cross by prediction, favour distinct crosses: in this sweep 160 crosses at
#'    one location beat 80 at two, which beat 40 at four, in direction in every
#'    scenario, though not every step was resolved. If only crosses already
#'    made will be advanced, more locations estimate them better, but at the cost
#'    of selection intensity; weigh both.
#' 3. **Screen candidate splits with the mean PEV of GCA** (`joint_pev()`), with the
#'    relationship matrix and variance components of the previous cycle. It ranks
#'    splits for the GCA / all-hybrid objective; it is blind to SCA and should not
#'    be used for a made-crosses-only objective.
#' 4. **Treat one location per cross with caution.** It was best here, but with
#'    the variance components known. With one plot per cross each cross is
#'    confounded with its environment and REML has little to work with
#'    (@sec-sparse-results, result 5); two locations per cross is the safer floor
#'    when the components must be estimated.
#' 5. **Place crosses with the coverage rule** (`joint_alloc(strategy =
#'    "coverage")`). It costs nothing, balances loads and raises parent coverage;
#'    an accuracy gain over random placement was not detected (point estimate
#'    half a point), and in the tester design there was none.
#' 6. **Check `n_comp_cross == 1` and `n_comp_loc == 1`** before planting. A random
#'    sparse plan can come out disconnected; the fix is a new plan, not a new
#'    allocation.
#' 7. **Reserve exchange optimisation of the placement for tester designs**, and
#'    treat even that as provisional: overall it bought no accuracy, and the
#'    tester gain rests on four cells and a search that had not converged; run it
#'    well beyond 600 proposals. Whether it helps with unequal pools or
#'    strongly structured environments is untested.
#' :::
#' 
#' ## Open problems {#sec-joint-open}
#' 
#' - **A joint optimiser over the plan itself.** Here the plan family was
#'   enumerated and the placement optimised. Searching crosses and locations in
#'   one binary space is the problem @heslot2020 solved for crosses alone; the
#'   criterion is ready, the search at programme scale is not.
#' - **A criterion that sees SCA and the selection objective.** Mean PEV of GCA
#'   ranks plans for one objective only; a criterion on the target values of the
#'   candidates that will actually be selected among, with intensity, is the
#'   missing piece.
#' - **Non-exchangeable environments.** Combining the mega-environment structure
#'   of @gonzalezbarrios2019 with a crossing plan, and the genetic correlation
#'   between locations at which the optimum moves toward more locations.
#' - **Estimated components.** How much of the budget split survives REML on the
#'   sparse trial, and whether the PEV screen should use a prior or the previous
#'   cycle's estimates [@lisle2021].
#' - **Seed as a constraint.** A cross planted at $k$ locations needs $k$ plots of
#'   seed; the cost structure of `cross_cost()` (@sec-mating-cost) has not been
#'   joined to the allocation.
#' - **Prospective validation.** As for sparse testing generally, no trial has
#'   been designed jointly sparse from the start and compared against a
#'   conventional plan.
#' 
#' ## Reproducibility and assumptions {#sec-joint-reproduce}
#' 
#' `Rscript book/scripts/regenerate.R joint` writes `joint_core_sweep.csv` (cell
#' means and standard errors), `joint_contrasts.csv` (paired contrasts) and
#' `joint_optimiser.csv` (the exchange-search trace) to `book/data`, in about 30
#' minutes of CPU, almost two thirds of it in the exchange searches. It keeps the
#' per-replicate results in `report/joint_raw.rds` (gitignored). The live example
#' of @tbl-joint-live runs at render time. `tests/testthat/test-joint.R` checks
#' that:
#' 
#' - every made cross gets exactly $k$ plots and every unmade cross none;
#' - the coverage rule balances loads and covers more of each pool than random
#'   placement;
#' - `joint_pev()` equals the GCA block of the explicitly inverted coefficient
#'   matrix of `sparse_blup()`;
#' - the optimised allocation never scores worse than its start, whether the start
#'   is implicit or passed in;
#' - `n_comp_cross` is two for NC II blocks at one location, in separate
#'   locations and in shared locations, and equals the bipartite count of
#'   `design_components()`; `n_comp_loc` is two only when the blocks are grown
#'   apart.
#' 
#' The numbers are reproducible findings of this configuration, not constants:
#' they will move with the budget, the pool sizes, the genetic correlation between
#' locations and the SCA share.
#' 
#' ## Where this connects {#sec-joint-connects}
#' 
#' - @sec-mating chose the crosses with the field fixed and @sec-sparse the field
#'   with the crosses fixed; this chapter puts both under one budget and finds the
#'   crossing plan the larger lever.
#' - The coverage rule is result 4 of @sec-sparse-results -- parent coverage, not
#'   shared hybrids, carries connectivity -- turned into an allocation rule.
#' - Spending the budget on distinct crosses keeps more lines in the data, which
#'   is the diversity argument of @sec-mating-connects: a line never crossed is a
#'   line the next cycle will in practice not use (@sec-stages; @sec-cycles).
#' - The PEV screen is the same mixed-model machinery as the genomic prediction of
#'   @sec-genomic-prediction, read before planting instead of after harvest.
