#' # Simulating lines, pools and crosses {#sec-simulating-crosses}
#' 
# 03-simulating-crosses -- standalone script of the chapter 03-simulating-crosses.qmd
# Book: https://ederdbs.github.io/QG/03-simulating-crosses.html
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
#' The Foundations part defined the quantities the book manages -- coancestry
#' (@sec-coancestry) and its partition over two pools (@sec-subdivided) -- the
#' response they are traded against (@sec-response), and the heterosis that pool
#' divergence is maintained for (@sec-heterosis). @sec-response drew its data
#' from `simulate_pools()` and @sec-heterosis from `simulate_lines()` and
#' `simulate_data()`, both without deriving them. This chapter builds the generator
#' step by step, with `simulate_lines()` and `simulate_data()`. `simulate_pools()`
#' uses the same Balding-Nichols pool frequencies, homozygous lines and A x B
#' factorial, but a different trait: `n_qtl` loci with independent effects plus
#' noise, where the traits built here have correlated effects at every marker and
#' no noise. Up to the lines the two generators consume R's random stream in the
#' same order, so with the arguments of @sec-response (`r book_cfg$n_pool_A` +
#' `r book_cfg$n_pool_B` lines, $m$ = `r book_cfg$m`, `fst` = 0.15, seed 1) they
#' return the same lines and the same hybrid marker matrix `X` (asserted below);
#' only the traits differ.
#' 
#' Everything downstream of this chapter consumes three objects and knows nothing
#' about where they came from. That is deliberate: it is the seam at which a
#' simulation is swapped for real data, and it is the only place that has to change
#' when it is.
#' 
#' This chapter builds those objects. It also builds the candidate pool the rest of
#' the book selects from, so the choices made here -- how divergent the pools are,
#' how the index is constructed -- determine what the later chapters have to work
#' with.
#' 
#' ## What has to be produced
#' 
#' @tbl-stage1-contract lists the three objects, and the optional fourth.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-stage1-contract
#| tbl-cap: "The stage-1 contract: the objects stage 1 hands to stage 2, with their shape (N hybrids, m markers, L lines) and the computations that need them. Stage 2 runs without `fL`; it loses only the pool decomposition."
#| echo: false
knitr::kable(data.frame(
  Object = c("`X`", "`f`", "`hybrids`", "`fL`"),
  Shape = c("N x m", "N x N", "N x (3 + n_traits)", "L x L, optional"),
  Content = c("hybrid marker matrix, values in 0/0.5/1",
              "molecular coancestry of the hybrids",
              "hybrid id, the two parent lines, predicted traits",
              "coancestry BETWEEN LINES"),
  `Needed for` = c("every frequency-based metric",
                   "every coancestry-based metric",
                   "the index, and the line-usage vector",
                   "only the heterotic-group decomposition"),
  check.names = FALSE))

#' 
#' ## Simulating the lines
#' 
#' Two heterotic pools are generated with the Balding-Nichols model
#' [@balding1995]. Ancestral allele frequencies $p^{*}_k$ are drawn uniform on
#' $[0.05, 0.95]$, then pool A's frequency at marker $k$ is drawn as
#' 
#' $$p_{Ak} \sim \text{Beta}\!\left(p^{*}_k \frac{1 - F_{BN}}{F_{BN}},\;
#'                                 (1 - p^{*}_k) \frac{1 - F_{BN}}{F_{BN}}\right),$$ {#eq-balding-nichols}
#' 
#' and independently for pool B ($p_{Bk}$), where $k = 1, \dots, m$ indexes
#' markers, $p^{*}_k \in [0.05, 0.95]$ is the ancestral frequency of the allele
#' coded 1, $p_{Ak}, p_{Bk} \in (0, 1)$ are the pool frequencies of that allele,
#' and $F_{BN} \in (0, 1)$ is the parameter `fst` of the configuration
#' (@sec-notation). The Beta of @eq-balding-nichols has mean $p^{*}_k$ and variance
#' $F_{BN}\, p^{*}_k (1 - p^{*}_k)$: $F_{BN}$ is the expected divergence of *each*
#' pool from the ancestral frequency, not between the two pools. Between them,
#' $\mathrm{Var}(p_{Ak} - p_{Bk}) = 2 F_{BN}\, p^{*}_k (1 - p^{*}_k)$, and the
#' $F_{ST}$ statistic of @eq-f-stats computed on two pools of unbounded size
#' estimates approximately $F_{BN}/(2 - F_{BN})$ (@sec-notation): at the book's
#' $F_{BN}$ = `r book_cfg$fst` that is `r fmt(book_cfg$fst / (2 - book_cfg$fst), 3)`,
#' not `r book_cfg$fst`.
#' 
#' Genotypes are then drawn as $2 \times \text{Bernoulli}(p)$, which makes every
#' line fully homozygous, as an inbred line should be.
#' 
## -----------------------------------------------------------------------------
simulate_lines

#' 
## -----------------------------------------------------------------------------
L <- simulate_lines(book_cfg)
stopifnot(all(L %in% c(0, 2)))
# same lines and X as the simulate_pools() call of @sec-response
sim_02b <- simulate_pools(n_A = book_cfg$n_pool_A, n_B = book_cfg$n_pool_B,
                          m = book_cfg$m, fst = 0.15, seed = 1)
stopifnot(identical(2 * sim_02b[["GL"]], L),
          identical(sim_02b[["X"]], simulate_data(book_cfg)[["X"]]))
dim(L)
table(as.vector(L[1:5, 1:200]))

#' 
#' Only 0 and 2 appear: no residual heterozygotes. With real data those must be
#' imputed or dropped before this point, because the hybrid-genotype identity in
#' @sec-coancestry assumes homozygous parents.
#' 
#' ### The divergence knob
#' 
#' `fst` is the single most consequential parameter in the simulation, because it
#' sets how much of the pools' diversity sits *between* them rather than within.
#' What that buys is less obvious than it looks: @fig-divergence-het plots the
#' heterozygous fraction of the F1 over a grid of $F_{BN}$,
#' @tbl-divergence-grid gives the coancestries and diversity components behind it,
#' and @tbl-divergence-trade the changes between the two ends of the grid.
#' 
## -----------------------------------------------------------------------------
#| label: fig-divergence-het
#| fig-cap: "Heterozygous fraction of the A x B F1 (fraction of markers at which the two inbred parent lines differ, averaged over every A x B hybrid) against the Balding-Nichols parameter, one simulated pair of pools per point at the book scale with m = 1500 markers, the same ancestral frequencies at every point. Dashed line: its expectation, 2 E[p*(1 - p*)] for p* uniform on [0.05, 0.95], which does not depend on the parameter."
#| fig-alt: "Line plot of the heterozygous fraction of the F1, on a 0 to 1 axis, against the Balding-Nichols parameter from 0.02 to 0.40; the points stay flat along a dashed horizontal line at the expectation"
fst_grid <- c(0.02, 0.05, 0.10, 0.15, 0.25, 0.40)
div <- vapply(fst_grid, function(fst) {
  cfg <- modifyList(book_cfg, list(fst = fst, m = 1500))
  Lx  <- simulate_lines(cfg)
  fL  <- molecular_coancestry(Lx / 2)
  A   <- seq_len(cfg$n_pool_A); B <- cfg$n_pool_A + seq_len(cfg$n_pool_B)
  f_til <- mean(c(fL[A, A], fL[B, B]))   # group coancestry, self included
  f_bar <- mean(fL)
  # a hybrid A x B is heterozygous wherever its parents differ
  c(between_pool_f = mean(fL[A, B]),
    within_pool_f  = f_til,
    het_fraction   = 1 - mean(fL[A, B]),
    GD_WS = 1 - f_til, GD_BS = f_til - f_bar, GD_T = 1 - f_bar)
}, numeric(6))

d <- data.frame(fst = fst_grid, t(div))
# equal pool sizes: 1 - f_AB = GD_T + GD_BS exactly
stopifnot(isTRUE(all.equal(d$het_fraction, d$GD_T + d$GD_BS)))
het_exp <- 2 * (0.5 - (0.9^2 / 12 + 0.25))   # 2 E[p(1-p)], p ~ U(0.05, 0.95)
plot(d$fst, d$het_fraction, type = "b", pch = 19, ylim = c(0, 1),
     xlab = expression(F[BN]),
     ylab = "heterozygous fraction of the F1")
abline(h = het_exp, lty = 2)
grid()

#' 
## -----------------------------------------------------------------------------
#| label: tbl-divergence-grid
#| tbl-cap: "Divergence grid behind @fig-divergence-het, one simulated pair of pools per row (book scale, m = 1500 markers). `fst`: the Balding-Nichols parameter $F_{BN}$; `between_pool_f`: mean line coancestry between pools; `within_pool_f`: group coancestry within a pool, self-coancestry included ($\\tilde f$); `het_fraction`: heterozygous fraction of the A x B F1; `GD_WS`, `GD_BS`, `GD_T`: the gene-diversity components of @sec-subdivided."
fmt(d)

#' 
## -----------------------------------------------------------------------------
#| label: divergence-trade
n_g <- nrow(d)
dWS <- d$GD_WS[n_g] - d$GD_WS[1]
dBS <- d$GD_BS[n_g] - d$GD_BS[1]
dT  <- d$GD_T[n_g]  - d$GD_T[1]

#' 
## -----------------------------------------------------------------------------
#| label: divergence-trade-replicates
# the two trade ratios over replicate grids; simulate_lines() seeds from cfg$seed
gd_ends <- function(fst, seed) {
  cfg <- modifyList(book_cfg, list(fst = fst, m = 1500, seed = seed))
  fL  <- molecular_coancestry(simulate_lines(cfg) / 2)
  A <- seq_len(cfg$n_pool_A); B <- cfg$n_pool_A + seq_len(cfg$n_pool_B)
  f_til <- mean(c(fL[A, A], fL[B, B])); f_bar <- mean(fL)
  c(GD_WS = 1 - f_til, GD_BS = f_til - f_bar, GD_T = 1 - f_bar)
}
n_rep <- 200
rep_ratio <- vapply(seq_len(n_rep), function(s) {
  x <- gd_ends(max(fst_grid), s) - gd_ends(min(fst_grid), s)
  c(-x[["GD_BS"]] / x[["GD_T"]], -x[["GD_WS"]] / x[["GD_BS"]])
}, numeric(2))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-divergence-trade
#| tbl-cap: "Change in each gene-diversity component of @tbl-divergence-grid from the smallest to the largest $F_{BN}$ of the grid (largest minus smallest), and the two ratios between those changes. Same single draw per grid point as @tbl-divergence-grid."
fmt(data.frame(
  quantity = c("change in GD_WS", "change in GD_BS", "change in GD_T",
               "GD_BS gain / GD_T loss", "GD_WS loss / GD_BS gain"),
  value = c(dWS, dBS, dT, -dBS / dT, -dWS / dBS)))

#' 
#' Across a `r fmt(max(fst_grid) / min(fst_grid), 1)`-fold range of $F_{BN}$ the
#' heterozygous fraction stays between `r fmt(min(d$het_fraction), 4)` and
#' `r fmt(max(d$het_fraction), 4)`, against an expectation of
#' `r fmt(het_exp, 4)` that contains no $F_{BN}$. Each point is one draw of a
#' finite pair of pools, and the spread over replicate draws was not measured
#' here. Over the same range, in the terms of @sec-subdivided with $\tilde f$ the
#' group coancestry within a pool (self-coancestry included, `within_pool_f`),
#' the within-subpopulation gene diversity $GD_{WS} = 1 - \tilde f = GD_{WI} + GD_{BI}$ of @eq-gd-partition changes by `r fmt(dWS, 4)`, $GD_{BS}$ by
#' `r fmt(dBS, 4)` and $GD_T$ by `r fmt(dT, 4)`. The $GD_{BS}$ gain is
#' `r fmt(-dBS / dT, 2)` times the $GD_T$ loss and the within-pool loss is
#' `r fmt(-dWS / dBS, 2)` times the $GD_{BS}$ gain; the expectations under drift
#' in two equal pools are 1 and 2 (@sec-subdivided). Both ratios are single draws.
#' Over `r n_rep` replicate grids (seeds 1 to `r n_rep`, the two ends of the grid
#' only) they have mean `r fmt(mean(rep_ratio[1, ]), 3)` and
#' `r fmt(mean(rep_ratio[2, ]), 3)` with standard deviation
#' `r fmt(sd(rep_ratio[1, ]), 3)` and `r fmt(sd(rep_ratio[2, ]), 3)`, so the
#' departure of this draw from 1 and 2 is within ordinary sampling variation. The `stopifnot()` in the code of @fig-divergence-het
#' asserts the identity that ties the first trade to the flat line: with equal pool sizes the
#' heterozygous fraction is exactly $GD_T + GD_{BS}$, so a constant heterozygous
#' fraction means that what $GD_{BS}$ gains, $GD_T$ loses.
#' 
#' That is not an artefact of this grid. The heterozygous fraction of an A x B
#' hybrid of inbred parents is exactly `1 - theta_AB`, and @sec-heterosis-flat
#' derives the expectations for pools of unbounded size: the shared term
#' $2\bar p(1 - \bar p)$, which is $GD_T$ here, loses $F_{BN}\,p^{*}(1-p^{*})$
#' and the divergence term, which is $GD_{BS}$, gains the same amount. Here
#' $GD_T$ and $GD_{BS}$ are computed from the sample frequencies of $n$ lines per
#' pool, which add binomial variance $p_{Ak}(1 - p_{Ak})/n$ to each pool frequency;
#' then $E[GD_{BS}] = F_{BN}\,p^{*}q^{*} + (1 - F_{BN})\,p^{*}q^{*}/n$ per marker,
#' with $q^{*} = 1 - p^{*}$, and the loss of $GD_T$ and the gain of $GD_{BS}$
#' are both $F_{BN}\,p^{*}q^{*}(1 - 1/n)$ in expectation. The factor $(1 - 1/n)$
#' cancels in the ratios 1 and 2. With $n$ = `r book_cfg$n_pool_A` and the
#' $F_{BN}$ range of the grid, the expected change is
#' `r fmt(diff(range(fst_grid)) * het_exp / 2 * (1 - 1 / book_cfg$n_pool_A), 4)`,
#' against `r fmt(diff(range(fst_grid)) * het_exp / 2, 4)` for unbounded pools. Neutral divergence relocates diversity; it
#' does not create heterosis. @tbl-keystone in @sec-subdivided states that
#' `GD_BS` is nonetheless to be preserved rather than minimised, and defers
#' the argument to @sec-heterosis; @sec-heterosis-alignment is what has to be true of
#' the divergence for it to be worth anything.
#' 
#' ## From lines to hybrids
#' 
#' Every A x B combination is formed. With `r book_cfg$n_pool_A` lines per pool
#' that is `r book_cfg$n_pool_A * book_cfg$n_pool_B` candidates; at the production
#' scale of 71 lines per pool it is `r 71^2`.
#' 
## -----------------------------------------------------------------------------
cfg <- book_cfg
a_ids <- seq_len(cfg$n_pool_A)
b_ids <- cfg$n_pool_A + seq_len(cfg$n_pool_B)
ped <- expand.grid(a = a_ids, b = b_ids)
M   <- (L[ped$a, , drop = FALSE] + L[ped$b, , drop = FALSE]) / 2   # 0/1/2
dim(M)
head(ped, 3)

#' 
#' The factorial structure matters more than it looks. Because every line appears
#' in many candidate hybrids, selecting hybrids is really selecting *line usage* --
#' and that observation, made precise in @sec-collapse, is what makes the whole
#' problem tractable at production scale.
#' 
#' ## Predicted traits
#' 
#' Marker effects are drawn correlated across traits, through a Cholesky factor of
#' a fixed correlation matrix, and the predicted values are the centered marker
#' matrix times those effects:
#' 
## -----------------------------------------------------------------------------
set.seed(cfg$seed + 99)
R <- matrix(c(1, 0.3, -0.3,
              0.3, 1,  0.1,
             -0.3, 0.1, 1), 3, 3)
vr <- vanraden_G(M)
B <- matrix(rnorm(cfg$m * cfg$n_traits), cfg$m) %*% chol(R)
traits <- scale(vr$Z %*% B)
rank_Z <- qr(vr$Z)$rank
stopifnot(rank_Z == cfg$n_pool_A + cfg$n_pool_B - 2)

#' 
#' @tbl-trait-cor sets the realised correlations of the predicted traits beside
#' the target `R`.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-trait-cor
#| tbl-cap: "Target correlation `R` of the marker effects and realised correlation of the predicted traits over the hybrids, for each pair of traits; one draw of marker effects at the book scale."
ij <- which(upper.tri(R), arr.ind = TRUE)
fmt(data.frame(traits = paste(ij[, 1], "x", ij[, 2]),
               target_R = R[ij], realised = cor(traits)[ij]), 3)

#' 
#' The Cholesky step gives each row of `B`, the effects of one marker on the
#' `r cfg$n_traits` traits, covariance `R`. It does not make the realised trait
#' correlations equal `R`: they depart from it by up to
#' `r fmt(max(abs(cor(traits) - R)), 3)` in absolute value. The hybrid values are
#' linear combinations of the columns of the centred matrix `Z`, whose rank is
#' `r rank_Z` $= (n_A - 1) + (n_B - 1)$ for an additive A x B factorial, so each
#' realised correlation rests on one draw of effects projected onto `r rank_Z`
#' dimensions. The target is a property of the effect distribution, not of this
#' draw; how closely the realised correlations approach it on average over draws
#' was not measured here.
#' 
#' ::: {.callout-important}
#' ## What this simulation deliberately does not model
#' 
#' These predicted values are constructed from *known* marker effects, so they
#' carry no prediction error. Real genomic estimated breeding values (GEBVs) do. The book therefore treats `ctx$index`
#' as given throughout, and the reader should read every gain figure as an upper
#' bound on what a real programme would realise. The additive model also carries no
#' dominance, so it cannot express specific combining ability -- see the caveats in
#' @sec-case-study.
#' :::
#' 
#' ## The two matrices, both built
#' 
## -----------------------------------------------------------------------------
X <- M / 2
ctx <- build_ctx(X = X, f = molecular_coancestry(X), G = vr$G, traits = traits,
                 ped = ped, n_lines = nrow(L),
                 pool = rep(c("A", "B"), c(cfg$n_pool_A, cfg$n_pool_B)),
                 fL = molecular_coancestry(L / 2), cfg = cfg)

# the heterozygous fraction of hybrid (a, b) is 1 - fL[a, b] (inbred parents)
stopifnot(abs(sum(ctx[["G"]])) < 1e-8,
          min(ctx[["f"]]) >= 0, max(ctx[["f"]]) <= 1,
          isTRUE(all.equal(ctx[["f"]],
                           tcrossprod(cbind(X, 1 - X)) / ncol(X))),
          isTRUE(all.equal(rowMeans(ctx[["X"]] == 0.5),
                           1 - ctx[["fL"]][cbind(ped$a, ped$b)])))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-ctx-check
#| tbl-cap: "Size of the context built above (N hybrids, m markers, number of lines) and the two properties checked on its matrices: the sum of the elements of VanRaden's G and the range of the molecular coancestry f. Values rounded to 4 decimals; the code asserts |sum(G)| < 1e-8."
fmt(data.frame(
  quantity = c("N", "m", "n_lines", "sum(G)", "min(f)", "max(f)"),
  value = c(ctx[["N"]], ctx[["m"]], ctx[["n_lines"]], sum(ctx[["G"]]),
            min(ctx[["f"]]), max(ctx[["f"]]))))

#' 
#' @tbl-ctx-check shows the result: `sum(G)` is zero to machine precision, as it must be for VanRaden's centred
#' matrix [@vanraden2008], and `f` is inside $[0, 1]$: the two
#' properties from @sec-coancestry, on this dataset.
#' 
#' The context also freezes two things that must never be recomputed per scenario:
#' 
## -----------------------------------------------------------------------------
str(ctx[c("p0", "maf_pop", "index")], max.level = 1)

#' 
#' `p0` is the candidate-pool allele frequency vector. It is the **base** against
#' which `F_hom` and `F_drift` are measured in @sec-genomic-era, and recomputing it
#' per scenario would silently zero out the historical memory of erosion.
#' 
#' ## The stage-1 contract in one call
#' 
#' All of the above is `simulate_data()`, which builds the same `ctx` as this
#' chapter. `stage1_simulate()` passes its `X`, `ped`, `traits` and `fL` to
#' `stage1_build()`, the function real data enter through:
#' 
## -----------------------------------------------------------------------------
stage1_build

#' 
## -----------------------------------------------------------------------------
st1 <- stage1_simulate(book_cfg)
str(st1, max.level = 1)
head(st1$hybrids, 3)

#' 
#' For real data the same function is called with your own matrices:
#' 
## -----------------------------------------------------------------------------
#| eval: false
# st1 <- stage1_build(
#   X      = hybrid_markers,   # N x m, coded 0/1/2 or 0/0.5/1
#   ped    = pedigree,         # data.frame with columns a, b
#   traits = predicted_traits, # N x n_traits
#   fL     = line_coancestry,  # optional
#   coding = "012"             # or "0-0.5-1"; NULL (default) auto-detects
# )

#' 
#' `stage1_build()` rescales 0/1/2 dosages to 0/0.5/1 before computing `f`. With
#' `coding = NULL` it infers the coding from the values present, ignoring missing
#' calls: any value above 1 means 0/1/2. That rule assumes a 0/1/2 matrix contains
#' at least one dosage-2 call. A matrix holding only 0 and 1 is ambiguous -- inbred
#' lines coded 0/0.5/1, or 0/1/2 dosages with no homozygote for the allele coded
#' 2 -- and no rule applied to the values can resolve it; `stage1_build()` then
#' assumes 0/0.5/1 and warns. Declaring `coding` removes the assumption. On the
#' simulated hybrids, which contain dosage-2 calls, the two codings give the same
#' `f`:
#' 
## -----------------------------------------------------------------------------
#| label: coding-invariance
tr <- st1$hybrids[, grep("^trait", names(st1$hybrids))]
pd <- data.frame(a = st1$hybrids$line_A, b = st1$hybrids$line_B)
stopifnot(any(st1$X * 2 == 2),
          identical(stage1_build(st1$X, pd, tr)$f,
                    stage1_build(st1$X * 2, pd, tr)$f))

#' 
#' The ambiguous case: two hybrids at three markers, coded 0/1/2, with no
#' dosage-2 call. Auto-detection reads each 1 as a homozygote, so it returns the
#' coancestry of two inbred individuals that these hybrids are not; the declared coding returns the
#' coancestry computed directly from the 0/0.5/1 matrix (@tbl-coding-ambiguous).
#' 
## -----------------------------------------------------------------------------
#| label: coding-ambiguous
X_amb   <- rbind(c(0, 1, 1),
                 c(1, 0, 1))                 # 0/1/2 dosages, no dosage 2
ped_amb <- data.frame(a = 1:2, b = 3:4)
tr_amb  <- data.frame(trait1 = c(0, 0))
f_auto <- withCallingHandlers(
  stage1_build(X_amb, ped_amb, tr_amb)$f,
  warning = function(w) { message("warning: ", conditionMessage(w))
                          invokeRestart("muffleWarning") })
f_012  <- stage1_build(X_amb, ped_amb, tr_amb, coding = "012")$f
f_true <- molecular_coancestry(X_amb / 2)
stopifnot(isTRUE(all.equal(f_012, f_true)),
          !isTRUE(all.equal(f_auto, f_true)))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-coding-ambiguous
#| tbl-cap: "Molecular coancestry of the two hybrids of the ambiguous example (`f11`, `f22`: self-coancestries; `f12`: between them) as returned by `stage1_build()` with the coding auto-detected and with `coding = \"012\"` declared, and as computed directly by `molecular_coancestry()` on the matrix divided by 2."
fmt(data.frame(
  coding = c("auto-detected", "declared 012", "direct, X / 2"),
  f11 = c(f_auto[1, 1], f_012[1, 1], f_true[1, 1]),
  f22 = c(f_auto[2, 2], f_012[2, 2], f_true[2, 2]),
  f12 = c(f_auto[1, 2], f_012[1, 2], f_true[1, 2])))

#' 
#' ## What the candidate pool looks like
#' 
#' @fig-candidate-pool shows the two quantities every later chapter trades: the
#' index of the candidates and the gene diversity of random subsets of them.
#' 
## -----------------------------------------------------------------------------
#| label: fig-candidate-pool
#| fig-cap: "The candidate pool at the book scale (25 + 25 lines, 625 A x B hybrids, 2000 markers). Left: histogram of the multi-trait selection index of the 625 hybrids: the equally weighted sum of the standardised predicted traits (default `weights` of `build_ctx()`), re-standardised to mean 0 and s.d. 1. Right: histogram of the gene diversity of 400 random subsets of 60 hybrids, the baseline every later chapter measures against; dark vertical line: gene diversity of the whole candidate pool."
#| fig-alt: "Two histograms. Left: the multi-trait index of the 625 candidate hybrids. Right: gene diversity of 400 random 60-hybrid subsets, with a dark vertical line for the whole pool lying to the right of the bulk of the distribution"
op <- par(mfrow = c(1, 2), mar = c(4.2, 4.2, 2.5, 1))
hist(ctx$index, breaks = 40, col = "grey85", border = "white",
     main = "multi-trait index", xlab = "index (s.d. units)")
n_sub <- 60                       # random-subset size, a typical n_sel
set.seed(cfg$seed + 3)
gd_random <- replicate(400, gene_diversity(sample.int(ctx$N, n_sub), ctx))
hist(gd_random, breaks = 30, col = "grey85", border = "white",
     main = paste("GD of random subsets of", n_sub), xlab = "gene diversity")
abline(v = gene_diversity(seq_len(ctx$N), ctx), col = book_pal[["ink"]], lwd = 2)
par(op)

#' 
#' The dark vertical line is the gene diversity of the *whole* pool. It does not sit at the
#' centre of the distribution of random subsets of `r n_sub` -- it sits above it. That gap
#' is pure sampling, it has nothing to do with selection, and mistaking it for a
#' loss is the subject of @sec-baseline. @tbl-gd-baseline gives the size of the
#' gap.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-gd-baseline
#| tbl-cap: "Gene diversity of the whole candidate pool, mean gene diversity of the random subsets of @fig-candidate-pool, and the apparent loss: their difference as a percentage of the whole-pool value."
stopifnot(gene_diversity(seq_len(ctx$N), ctx) > mean(gd_random))
fmt(data.frame(
  quantity = c("GD, whole pool", "GD, mean of random subsets",
               "apparent loss (%)"),
  value = c(gene_diversity(seq_len(ctx$N), ctx), mean(gd_random),
            100 * (gene_diversity(seq_len(ctx$N), ctx) - mean(gd_random)) /
              gene_diversity(seq_len(ctx$N), ctx))))

