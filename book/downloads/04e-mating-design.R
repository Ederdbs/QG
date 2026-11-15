#' # How few hybrids are enough? Mating designs for a two-pool programme {#sec-mating}
#' 
# 04e-mating-design -- standalone script of the chapter 04e-mating-design.qmd
# Book: https://ederdbs.github.io/QG/04e-mating-design.html
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
sm    <- read.csv(book_data("mating_scenarios_summary.csv"))
front <- read.csv(book_data("mating_optimizer_frontier.csv"))
val   <- read.csv(book_data("mating_validation.csv"))
core  <- read.csv(book_data("mating_core_sweep.csv"))
bl    <- subset(sm, model == "BLUP")
# Rank of a design on all-lines GCA accuracy at 2,000 plots under one model.
rk <- function(model, s) {
  d <- sm[sm$model == model & sm$budget_plots == 2000, ]
  rank(-d$acc_gca_all)[d$scenario == s]
}
# Result 2's wording: c = 3 in the top third, c = 2 in the middle third.
local({
  n <- sum(sm$model == "BLUP" & sm$budget_plots == 2000)
  stopifnot(rk("BLUP", "circulant c=3") <= n / 3,
            rk("BLUP", "circulant c=2") > n / 3, rk("BLUP", "circulant c=2") <= 2 * n / 3)
})
# Realised variance components of the cached run's complete 200 x 200 factorial
# (check V2 of the validation file), and the plot error implied by a
# single-plot heritability of 0.3.
v2  <- subset(val, grepl("^V2", check))
vc  <- list(A = v2$observed[v2$quantity == "Var(gcaA)"],
            B = v2$observed[v2$quantity == "Var(gcaB)"],
            S = v2$observed[v2$quantity == "Var(sca)"])
s2e <- (vc$A + vc$B + vc$S) * (1 - 0.3) / 0.3
s2g <- (vc$A + vc$B) / 2          # GCA variance used by the closed forms
ratio_ref <- vc$S / s2g           # reference SCA:GCA ratio of the cached run
n   <- 200
# Best tester against best sparse factorial at each budget (printed in @tbl-mating-h2h).
sparse_fam <- c("sparse_circulant", "sparse_random")
h2h <- do.call(rbind, lapply(split(bl, bl$budget_plots), function(d) {
  t <- subset(d, family == "tester");       t <- t[which.max(t$acc_gca_all), ]
  s <- subset(d, family %in% sparse_fam);   s <- s[which.max(s$acc_gca_all), ]
  data.frame(plots = d$budget_plots[1],
             best_tester = t$scenario, tester_hybrids = round(t$n_crosses),
             tester_acc = t$acc_gca_all,
             best_sparse = s$scenario, sparse_hybrids = round(s$n_crosses),
             sparse_acc = s$acc_gca_all,
             difference = s$acc_gca_all - t$acc_gca_all,
             z = (s$acc_gca_all - t$acc_gca_all) /
                 sqrt(s$se_acc_gca_all^2 + t$se_acc_gca_all^2))
}))
# Under least squares at 2,000 plots: each non-tester design against the best
# tester (printed in @tbl-mating-ls-vs-tester). Unpaired z, as in h2h.
ls2  <- subset(sm, model == "LS" & budget_plots == 2000 &
               family %in% c("tester", "sparse_circulant", "sparse_random", "nc2", "genomic_cross"))
ls_t <- subset(ls2, family == "tester"); ls_t <- ls_t[which.max(ls_t$acc_gca_all), ]
lsz  <- subset(ls2, family != "tester")
lsz$difference <- lsz$acc_gca_all - ls_t$acc_gca_all
lsz$z <- lsz$difference / sqrt(lsz$se_acc_gca_all^2 + ls_t$se_acc_gca_all^2)
core_ls <- subset(core, budget_plots == 2000 & method == "ls")
lsz$acc_core <- core_ls$acc_mean[match(lsz$scenario, core_ls$scenario)]
ls_t_core <- core_ls$acc_mean[core_ls$scenario == ls_t$scenario]
lz <- function(s) lsz[lsz$scenario == s, ]

#' 
#' The selection problems of the Optimisation part (@sec-ocs, @sec-combinatorial,
#' @sec-advanced) start from a list of hybrids with predicted values, and
#' @sec-simulating-crosses builds that list as the complete $A \times B$ factorial:
#' every cross formed once, every value known. Earlier chapters did ask where such
#' a list comes from, and each deferred the answer to this one:
#' @sec-hybrid-programme describes the evaluation of lines in cross, against
#' testers or in a sparse factorial; @sec-alphasimr ("How many testers, how many
#' locations") gives a tester-design accuracy for a simulated programme;
#' @sec-heterosis-step6 checks that a crossing layout identifies what one intends
#' to fit. None of them chooses the crossing plan. This chapter does, and it
#' therefore removes the assumption, made by the Optimisation part, that the
#' values of the whole factorial are known: what that part receives after a sparse
#' plan is a prediction, and this chapter measures how good it is.
#' 
#' The list comes from a crossing plan, and the crossing plan is the most constrained
#' decision a hybrid programme makes. Two pools of 200 candidate lines each define
#' a factorial of 40,000 single crosses. A field holds 1,000 to 3,000 plots. Every
#' hybrid programme is therefore choosing a **sample** of a factorial whose cells
#' are overwhelmingly empty, and the classical tester -- every candidate crossed to
#' one or two lines of the opposite pool -- is one sample among many. This chapter
#' treats the choice of sample as the design problem it is, and defends three
#' results:
#' 
#' 1. **At equal field size, a connected sparse factorial among the candidates
#'    estimates general combining ability better than a tester design**, at every
#'    budget studied, by `r fmt(min(h2h$difference), 3)` to
#'    `r fmt(max(h2h$difference), 3)` correlation points.
#' 2. **The analysis matters most for the sparsest designs.** Analysed by least
#'    squares, the sparsest factorials are the worst designs in the study; analysed
#'    by BLUP, they climb out of the bottom, $c = 3$ into the top third and $c = 2$ to
#'    mid-table (at 2,000 plots, circulant $c = 3$ moves from rank
#'    `r rk("LS", "circulant c=3")` to rank `r rk("BLUP", "circulant c=3")` of
#'    `r sum(sm$model == "BLUP" & sm$budget_plots == 2000)` designs, $c = 2$ from
#'    `r rk("LS", "circulant c=2")` to `r rk("BLUP", "circulant c=2")`). The cost of
#'    least squares is not general: under least squares at 2,000 plots, random sparse
#'    $c = 10$, NC II and circulant $c = 10$ still exceed the best tester
#'    (`r ls_t$scenario`) in the cached sweep, by
#'    `r fmt(lz("circulant c=10")$difference, 3)` to
#'    `r fmt(lz("random sparse c=10")$difference, 3)` correlation points; the
#'    in-repo sweep reproduces this for random $c = 10$ and NC II but not for
#'    circulant $c = 10$ (@tbl-mating-ls-vs-tester, @sec-mating-reproduce).
#' 3. **Genomic kernels did not raise GCA accuracy for lines that were crossed; they
#'    exceeded phenotypic BLUP only in two designs that field a quarter of the
#'    candidates.** Where every candidate is in the field, genomic kernels did not
#'    raise GCA accuracy. They exceeded phenotypic BLUP in two designs that field only
#'    a quarter of the candidates, chosen by CDmean -- one cached run, three distinct
#'    cells, one of them below this chapter's own threshold -- and in those the genomic
#'    accuracy was not distinguished from that of randomly chosen lines, while the
#'    phenotypic arm fell (@sec-mating-genomic). The *interpretation*, not a result,
#'    is that the value of genomic information lies in predicting lines that were
#'    never crossed, for which the phenotypic model gives no prediction at all; the
#'    sweep does not quantify a gain for them, only the hybrid-level accuracy of
#'    untested-parent hybrids (T0), reported in @sec-mating-genomic.
#' 
#' **One word, three objects.** In the Optimisation part a hybrid *is* a cross
#' between a pool-A and a pool-B line, and selection acts on its predicted value.
#' In this chapter, unqualified, a **cross** is a filled cell of the design: an
#' $A \times B$ single cross that is made and planted to be tested; the cells not
#' in the design are *untested hybrids*, which can only be predicted. A third
#' object, the **within-pool cross** made to produce the next generation of lines
#' (stage S2 of @tbl-hp-stages), is the subject of the literature reviewed in
#' @sec-mating-genomic and is not designed here.
#' 
#' The running example throughout is one simulated maize programme: two heterotic
#' pools, 200 doubled-haploid candidates per pool, a field of 1,000 to 3,000 hybrid
#' plots, and a winter nursery that must physically produce the seed of every cross
#' that enters the field.
#' 
#' ::: {.callout-note}
#' ## Where the numbers come from
#' 
#' Three sources, and the chapter keeps them apart. **Live** results are computed
#' at render time with the base-R design functions of `R/16_mating_design.R` --
#' design generators, the connectivity diagnostic, least-squares and BLUP
#' estimators with known variance components, and the cost model. **Cached
#' external** results come from a separate study (`sparsex`) that founded the pools
#' in AlphaSimR, estimated variance components by REML, fitted genomic kernels and
#' swept 24 designs x 3 plot budgets x 30 replicates x 3 models. That study is not
#' in this repository and **its results are not reproducible from it**: three data
#' files, `book/data/mating_scenarios_summary.csv`,
#' `mating_optimizer_frontier.csv` and `mating_validation.csv`, and five figures,
#' `book/figs/mating_*.png`. The repository does not record which engine drew the
#' founders; if it was `AlphaSimR::runMacs()`, that engine is not seeded by
#' `set.seed()` and would not regenerate them bit for bit. **Cached in-repo**:
#' `book/data/mating_core_sweep.csv`, the phenotypic core of the same sweep, is
#' regenerated by `Rscript book/scripts/regenerate.R mating` (the regenerated file
#' reproduced the tracked file byte for byte when it was last checked, November 2026); the two
#' sweeps are compared in @sec-mating-reproduce. (`mating_core_findings.csv` is a
#' literature extraction that no chapter reads.)
#' :::
#' 
#' ## Why the crossing plan is the binding decision {#sec-mating-binding}
#' 
#' The crossing plan, not the statistical model and not the marker platform, sets
#' the ceiling on what a hybrid programme can learn in a cycle. Which lines can be
#' ranked, whether specific combining ability is estimable at all, how many plots
#' each hybrid can occupy, whether untested combinations can be predicted -- every
#' one of these is fixed the moment the nursery plan is written. A mixed model fitted
#' afterwards can only extract what the plan put there.
#' 
#' The arithmetic is unforgiving. A 200 x 200 factorial against 1,000 to 3,000 plots
#' is a sampling fraction of 2.5 to 7.5 % at one plot per hybrid, and
#' `r fmt(100 * 1000 / 2 / 40000, 2)` to `r fmt(100 * 3000 / 2 / 40000, 2)` % at two plots per
#' hybrid, the minimum for replication. Three decisions are usually conflated inside "the
#' testing plan", and it pays to separate them:
#' 
#' - **which lines** enter the field at all -- every candidate, or a subset chosen
#'   by some criterion;
#' - **which crosses** among those lines are made -- to a common tester, to each
#'   other in a sparse pattern, or in complete blocks;
#' - **how many plots** each cross receives -- replicates and locations.
#' 
#' The organising question of the chapter follows: *for a fixed budget, which
#' sample of the factorial maximises the accuracy of combining-ability estimates
#' and the selection response they support?* And one constraint is stated now,
#' because it is the one most often forgotten: **a crossing plan is not a matrix,
#' it is a nursery.** Each filled cell is a pollination that must yield enough seed
#' for its plots.
#' 
#' The three canonical samples drawn over the same grid make the difference visible
#' before any statistics. The plans below are produced by the package's generators,
#' at 40 x 40 so that individual cells can be seen:
#' 
## -----------------------------------------------------------------------------
#| label: fig-mating-grids
#| echo: true
#| fig-width: 9
#| fig-height: 3.4
#| fig-cap: "Three samples of the same 40 x 40 factorial, drawn by the package's own generators. Rows are pool-A lines, columns pool-B lines, a filled cell is a cross that goes to the field. Left: two testers per pool (156 crosses). Centre: a circulant sparse factorial with four crosses per line (160 crosses). Right: North Carolina Design II as four disconnected 10 x 10 blocks (400 crosses)."
#| fig-alt: "Three samples of the same 40 x 40 factorial, drawn by the package's own generators"
set.seed(3)
grids <- list("Tester, k = 2"     = design_tester(40, 40, k = 2),
              "Circulant, c = 4"  = design_circulant(40, 40, c = 4),
              "NC II, 10 x 10 sets" = design_nc2(40, 40, 10, 10))
op <- par(mfrow = c(1, 3), mar = c(1, 1, 2.2, 1))
for (nm in names(grids)) {
  M <- matrix(0, 40, 40)
  M[cbind(grids[[nm]]$parent1, grids[[nm]]$parent2)] <- 1
  image(t(M[40:1, ]), col = c("grey96", "#1f5f8b"), axes = FALSE,
        main = sprintf("%s  (%d crosses)", nm, nrow(grids[[nm]])), cex.main = 0.9)
  box(col = "grey60")
}
par(op)

#' 
#' The tester fills two full columns and two full rows: every line meets the same
#' partners, so lines are compared on a common background but the background is
#' narrow. The circulant design spreads the same number of crosses as thin diagonals:
#' every line meets different partners, every line is crossed exactly four times,
#' and -- the property that the next section shows to matter -- every line is linked
#' to every other through a chain of shared partners. NC II fills more cells than
#' either and still cannot compare a line in the first block with a line in the
#' second.
#' 
#' ## Combining ability as an estimation problem {#sec-mating-estimation}
#' 
#' General and specific combining ability are properties of a *reference population
#' of crosses*, and a design estimates them only to the extent that it samples that
#' population. The concepts are classically attributed to @sprague1942; the distinction between fixed-effect
#' inference about a specific set of parents and random-effect inference about the
#' population they were drawn from is classically attributed to @griffing1956 (page-level
#' support not checked for this book). The North Carolina layouts, in which a
#' factorial between two sets of parents separates the components of variance, are
#' attributed to @comstock1948; that attribution, and the assignment of Design II
#' to this paper rather than to a later publication, was not verified
#' for this book. Reciprocal recurrent selection, the scheme that uses both
#' combining abilities, is the subject of @comstock1949, cited here for its title
#' and existence only.
#' 
#' ### The model
#' 
#' At the level of a cross mean the model is @eq-hp-gca-sca,
#' $\bar y_{ij} = \mu + g^A_i + g^B_j + s_{ij} + \bar e_{ij}$, with $\bar y_{ij}$
#' the mean of cross $i \times j$ over its $r_{ij}$ plots, $\mu$ the mean of the
#' reference set of crosses, $g^A_i$, $g^B_j$ the GCA of the pool-A and pool-B parent,
#' $s_{ij}$ the SCA of the pair and $\bar e_{ij}$ the plot error of the mean. This
#' chapter adds the error variance,
#' 
#' $$\mathrm{Var}(\bar e_{ij}) = \sigma^2_e / r_{ij},$$ {#eq-mating-error}
#' 
#' with $\sigma^2_e$ the plot-error variance (`s2e`, defined from a single-plot
#' heritability of 0.3) and $r_{ij} \ge 1$ the plots the cross received. The other
#' variances are $\sigma^2_{gA}$ and $\sigma^2_{gB}$, over the candidate lines of
#' each pool (`vc$A`, `vc$B`), and $\sigma^2_s$, that of $s_{ij}$ (`vc$S`; written
#' $\sigma^2_{SCA}$ in @sec-heterosis, where it is a closed form for the heterosis
#' part). Where one GCA variance is needed, as in every closed form below, it is
#' $\sigma^2_g = (\sigma^2_{gA} + \sigma^2_{gB})/2$, the mean of the two pools.
#' $n_A$ and $n_B$ are the candidate lines per pool, and $n_A'$, $n_B'$ those that
#' receive at least one cross. In @sec-sparse and @sec-joint the pool-A line is the
#' female and the pool-B line the male. Two ratios will be quoted and must not be
#' confused: the **SCA:GCA ratio** of this chapter is $\sigma^2_s/\sigma^2_g$, and
#' the **SCA share** is $\sigma^2_s/(\sigma^2_{gA} + \sigma^2_{gB} + \sigma^2_s)$,
#' the proportion of the genetic variance among cross means. In the cached run they
#' are `r fmt(ratio_ref, 3)` and `r fmt(vc$S / (vc$A + vc$B + vc$S), 3)`. Neither is
#' the SCA share of the heterosis variance of @sec-heterosis, which excludes the
#' additive variance and assumes neutral divergence.
#' 
#' @sec-heterosis-gca-sca derived this decomposition from allele frequencies for the
#' dominance part of the hybrid value, and showed that a pool-A line's GCA is an average
#' effect *evaluated at pool B's frequencies*. There $g^A_i$ is that dominance part
#' alone, which that chapter calls the GCA for heterosis; here $g^A_i$ is the whole
#' GCA of the cross mean. With an additive effect $a_k$ added to the dominance
#' effect $d_k$ at locus $k$, the general combining ability of pool-A line $i$ in the
#' factorial of the candidate lines is
#' 
#' $$g^A_i = \sum_k \bigl[a_k + d_k (1 - 2\bar v_k)\bigr]\,\delta u_{ik},
#'   \qquad \delta u_{ik} = u_{ik} - \bar u_k,$$ {#eq-mating-gca}
#' 
#' with $u_{ik}, v_{jk} \in \{0, 1\}$ the genotype of inbred pool-A line $i$ and pool-B
#' line $j$ at locus $k$, and $\bar u_k$, $\bar v_k$ their means **over the candidate
#' lines of the factorial**, not over the pool (the two converge as the number of lines
#' grows; the identity below holds for the former only). Genotypic value is
#' $a_k(u + v - 1) + d_k(u + v - 2uv)$ per locus, so the row effect of the product term
#' $-2d_k u_{ik}v_{jk}$ is $-2d_k\,\delta u_{ik}\bar v_k$ and the rest is linear. The structure --
#' an average effect of substitution against the other population -- is that of
#' @stuber1966 for a cross between two populations; the equation is checked here, not
#' taken from that paper. The additive part adds a term and changes nothing else,
#' which is quick to confirm: the row effects of a complete factorial of genotypic
#' values equal `cU %*% a` plus the `gca_A` of `heterosis_gca_sca()`, with no second
#' implementation. The same chunk shows what the identity does not cover: with the
#' frequencies of the *pool* that generated the lines in place of $\bar u_k$,
#' $\bar v_k$, the two sides differ.
#' 
## -----------------------------------------------------------------------------
#| label: mating-gca-identity
set.seed(7)
m  <- 300
pA <- runif(m, 0.1, 0.9); pB <- runif(m, 0.1, 0.9)
U  <- matrix(rbinom(30 * m, 1, rep(pA, each = 30)), 30)   # 30 inbred lines, pool A
V  <- matrix(rbinom(25 * m, 1, rep(pB, each = 25)), 25)   # 25 inbred lines, pool B
a  <- rnorm(m, 0, 0.3); d <- rnorm(m, 0.2, 0.2)
# Genotypic value of every single cross: a(u + v - 1) + d * heterozygosity
G  <- outer(seq_len(30), seq_len(25), Vectorize(function(i, j)
        sum(a * (U[i, ] + V[j, ] - 1) + d * (U[i, ] + V[j, ] - 2 * U[i, ] * V[j, ]))))
cs <- heterosis_gca_sca(U, V, d)
gcaA_formula <- drop(sweep(U, 2, colMeans(U)) %*% a) + cs$gca_A
row_eff <- rowMeans(G) - mean(G)
# @eq-mating-gca with candidate-set frequencies, and with the pool frequencies
gca_cand <- drop(sweep(U, 2, colMeans(U)) %*% (a + d * (1 - 2 * colMeans(V))))
gca_pool <- drop(sweep(U, 2, pA) %*% (a + d * (1 - 2 * pB)))
c(max_abs_diff_heterosis_gca_sca = max(abs(row_eff - gcaA_formula)),
  max_abs_diff_candidate_freq    = max(abs(row_eff - gca_cand)),
  max_abs_diff_pool_freq         = max(abs(row_eff - gca_pool)),
  sd_row_effect                  = sd(row_eff))
stopifnot(max(abs(row_eff - gcaA_formula)) < 1e-10,
          max(abs(row_eff - gca_cand)) < 1e-10,
          max(abs(row_eff - gca_pool)) > 1e-3)

#' 
#' Result. The row effects of the complete factorial equal @eq-mating-gca with the
#' candidate-set frequencies, and the `gca_A` of `heterosis_gca_sca()` plus the
#' additive term, to machine precision (asserted below $10^{-10}$); with the pool
#' frequencies the largest difference is
#' `r fmt(max(abs(row_eff - gca_pool)), 2)` against a standard deviation of the row effects of
#' `r fmt(sd(row_eff), 2)`, at 30 + 25 lines and 300 loci. Interpretation. "True GCA" in
#' this chapter is always the quantity on the left -- the row and column effects a
#' breeder would estimate by growing every hybrid of the candidate lines without
#' error -- and every accuracy reported is meant as a correlation with it, over **all**
#' candidates of a pool, crossed or not (for the cached sweep this is the estimand as the
#' study describes it; the repository holds only the realised factorial variances of check V2). The population GCA, at pool frequencies,
#' is a different object, which the finite panel approximates; this chapter does not
#' use it.
#' 
#' ### Four quantities that control a design
#' 
#' Table: The four quantities of a two-pool mating design, their closed forms and what controls them. Rows 3 and 4 hold for a **tester design** with $k$ testers per pool and $c = k$ crosses per line, every candidate crossed to the same $k$ partners; they are not written for a sparse factorial (see the text and @tbl-mating-formula-sparse). {#tbl-mating-quantities}
#' 
#' | Quantity | Closed form | Controlled by |
#' |---|---|---|
#' | Rank of the GCA design matrix $[\mathbf 1 \mid Z_A \mid Z_B]$ | $n_A' + n_B' - (\text{connected components})$ | which crosses are made: the bipartite graph |
#' | Residual df for SCA at cross-mean level | $n_{\text{crosses}} - \text{rank}$ | crosses per line; zero for one tester per pool |
#' | LS sampling error of a GCA estimate, $k$ testers, $c = k$ | $\sigma^2_{s}/k + \sigma^2_e/(k\,r)$ | $k$ buys down both terms, $r$ only the second |
#' | LS accuracy of a GCA estimate, $k$ testers | $\rho = \sqrt{\sigma^2_g / (\sigma^2_g + \sigma^2_s/k + \sigma^2_e/(k\,r))}$ | the same, as a correlation |
#' 
#' The third row is the quantitative form of the classical argument for using more
#' than one tester (attributed to @sprague1942; not checked at page level here), and the fourth is its square root as an accuracy: the
#' square root of the heritability, for GCA, of the mean of a line's $k$ cross means.
#' Both describe **least squares in a tester design**, and the derivation uses
#' that: the $k$ partners are the same for every candidate, so their GCA is a constant
#' that the within-pool centring removes, and the error of a line's estimate is
#' the mean of $k$ independent $s_{ij}$ and $\bar e_{ij}$. In a sparse factorial each
#' line has its own partners, which are themselves unknown candidates, and nothing in
#' the derivation covers that noise. `gca_accuracy_theory(c, r, ...)` can nevertheless
#' be evaluated at $c$ crosses per line, and it is useful to see what it then returns
#' against the cached accuracies of the two estimators, at 2,000 plots:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-formula-sparse
#| tbl-cap: "The closed form of @tbl-mating-quantities, evaluated at nominal crosses per line $c$ and the realised mean plots per cross $r$ with $\\sigma^2_g$, $\\sigma^2_s$, $\\sigma^2_e$ of the cached run, against the cached all-lines GCA accuracy of BLUP and of least squares, 2,000 plots (30 replicates per cell; cached external sweep). `lines` is the number of pool-A lines that received a cross."
fs <- subset(sm, budget_plots == 2000 & model %in% c("BLUP", "LS") &
               family %in% c("tester", "sparse_circulant", "sparse_random", "nc2"))
fs <- reshape(fs[, c("scenario", "family", "x_axis", "reps_per_cross", "n_linesA_tested",
                     "model", "acc_gca_all")],
              idvar = c("scenario", "family", "x_axis", "reps_per_cross", "n_linesA_tested"),
              timevar = "model", direction = "wide")
fs$formula <- gca_accuracy_theory(fs$x_axis, fs$reps_per_cross, s2g, vc$S, s2e)
fs$formula_minus_blup <- fs$formula - fs$acc_gca_all.BLUP
fs$formula_minus_ls   <- fs$formula - fs$acc_gca_all.LS
fs <- fs[order(fs$family != "tester", fs$family, fs$x_axis), ]
is_t <- fs$family == "tester"
fmt(data.frame(design = fs$scenario, c = fs$x_axis, r = fs$reps_per_cross,
               lines = round(fs$n_linesA_tested), formula = fs$formula,
               blup = fs$acc_gca_all.BLUP, ls = fs$acc_gca_all.LS,
               formula_minus_blup = fs$formula_minus_blup,
               formula_minus_ls = fs$formula_minus_ls), 3)

#' 
#' Result. For the four tester designs the closed form minus the cached accuracy is
#' `r fmt(min(fs$formula_minus_blup[is_t]), 3)` to
#' `r fmt(max(fs$formula_minus_blup[is_t]), 3)` under BLUP and
#' `r fmt(min(fs$formula_minus_ls[is_t]), 3)` to
#' `r fmt(max(fs$formula_minus_ls[is_t]), 3)` under least squares. In every
#' other design -- sparse factorials and NC II -- it lies **above** BLUP, by
#' `r fmt(min(fs$formula_minus_blup[!is_t]), 3)` to
#' `r fmt(max(fs$formula_minus_blup[!is_t]), 3)`, and above least squares by up to
#' `r fmt(max(fs$formula_minus_ls[!is_t]), 2)` (circulant $c = 2$). Interpretation. The
#' expression is a reliable description of least squares on a tester design and
#' **optimistic** for any sparse design, under BLUP as well as under least squares;
#' a shrinkage estimator on a connected sparse design recovers much of what least
#' squares loses, which is why @sec-mating-analysis exists, but not all of it, and
#' the table does not decompose the shortfall. What limits the inference: one
#' cached run, accuracies at nominal $c$ and mean realised $r$, and the closed form
#' taken at the mean of the two pools' GCA variances.
#' 
#' The cached run validated the third and fourth rows against simulation in the
#' complete 200 x 200 factorial, for $k = 1, 2, 4, 8$ testers and $r = 1, 2$ plots:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-v4
#| tbl-cap: "Least-squares GCA accuracy in a k-tester design: simulated against the closed form of @tbl-mating-quantities, with the pool-A GCA variance. Cached from the `sparsex` validation suite, check V4 (a tester design only; the file records the formula, not the number of replicates behind each simulated value)."
v4 <- subset(val, grepl("^V4", check))
fmt(data.frame(design = sub("cor\\(ghat_LS, GCA\\), ", "", v4$quantity),
               simulated = v4$observed, closed_form = v4$expected,
               rel_error_pct = 100 * v4$rel_error), 3)

#' 
#' The largest relative error is `r fmt(100 * max(abs(v4$rel_error)), 1)` %, and it
#' validates the expression **for tester designs only**. The cost optimiser of
#' @sec-mating-cost scores every design, sparse ones included, with this expression;
#' @tbl-mating-formula-sparse shows that for sparse designs the score is above the
#' accuracy that either estimator reached in the cached sweep, so the optimiser's
#' ordering of $c$ is not established by the optimiser (@sec-mating-cost).
#' 
#' ### Connectivity, in one paragraph {#sec-mating-connectivity}
#' 
#' ::: {.callout-important}
#' ## The rank rule
#' 
#' A mating design is a bipartite graph: pool-A lines on one side, pool-B lines on
#' the other, an edge for every cross. GCA contrasts are estimable **within** a
#' connected component of that graph and **not between** components, so the rank
#' of the GCA design matrix is $n_A' + n_B' - (\text{components})$, one lost
#' constraint per component. That is the formal content of what breeders call "ties
#' between sets", and it was settled long ago: @weeks1964 gave the criterion for an
#' $N$-way classification and @fernando1983 an algorithm for the connected subsets
#' of a two-way one.
#' :::
#' 
#' `design_diagnostics()` computes both sides of the rule independently -- the
#' numerical rank by QR, the components by union-find over the graph -- so a
#' disagreement would be a bug, not a modelling choice:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-connectivity
#| tbl-cap: "Connectivity and estimability of six designs on the 200 x 200 running example. `rank_gca` is the numerical rank of the GCA design matrix; `rank_expected` is the graph prediction; `df_sca` is what is left at cross-mean level to separate SCA from error."
set.seed(2026)
plans <- list("tester k=1"        = design_tester(n, n, 1),
              "tester k=2"        = design_tester(n, n, 2),
              "random sparse c=2" = design_random_sparse(n, n, 2),
              "circulant c=2"     = design_circulant(n, n, 2),
              "circulant c=5"     = design_circulant(n, n, 5),
              "NC II 10x10 sets"  = design_nc2(n, n, 10, 10))
diag_tab <- do.call(rbind, lapply(names(plans), function(nm) {
  d <- design_diagnostics(plans[[nm]], n, n)
  data.frame(design = nm, crosses = d$n_crosses,
             untested = 2 * n - d$lines_A - d$lines_B,
             components = d$components, rank_gca = d$rank_gca,
             rank_expected = d$rank_expected, df_sca = d$df_sca)
}))
stopifnot(all(diag_tab$rank_gca == diag_tab$rank_expected))
diag_tab

#' 
#' Result. The rank equals the graph prediction in every row. The NC II layout --
#' twenty disconnected 10 x 10 blocks -- has rank `r diag_tab$rank_gca[6]`, not 399:
#' twenty components, twenty lost constraints. The random sparse design at two
#' crosses per line leaves `r diag_tab$untested[3]` candidates with no cross at all
#' and splits the rest into `r diag_tab$components[3]` components; the circulant
#' design with the same number of crosses is a single component with every line
#' crossed exactly twice. One tester per pool is connected and has **zero** residual
#' df: $n_A + n_B - 1$ crosses for $n_A + n_B - 1$ GCA parameters. The GCA model is
#' saturated and SCA is not merely imprecise, it is not identifiable.
#' 
#' What "not estimable" means is checked directly. A contrast between two lines of
#' the same NC II block lies in the row space of the design matrix; a contrast
#' between lines of different blocks does not:
#' 
## -----------------------------------------------------------------------------
#| label: mating-estimable
nc <- plans[["NC II 10x10 sets"]]
l_within  <- c(0, 1, -1, rep(0, 2 * n - 2))           # A1 - A2, same block
l_between <- c(0, 1, rep(0, 9), -1, rep(0, 2 * n - 11)) # A1 - A11, next block
rbind(within  = unlist(design_estimable(nc, n, n, l_within)),
      between = unlist(design_estimable(nc, n, n, l_between)))

#' 
#' The within-block residual is rounding error; the between-block residual is
#' `r fmt(design_estimable(nc, n, n, l_between)$rel_residual, 3)`, a contrast
#' nowhere near the row space. Any least-squares ranking that crosses block boundaries
#' in this design is a statement about the analyst's centring convention, not about
#' the lines.
#' 
#' BLUP does rank across blocks, and in the simulations below NC II scores well on
#' all-lines accuracy. It can, because a random-effects model supplies the missing
#' constraint from its prior: every block's lines are assumed drawn from the same pool
#' distribution, so every block mean is shrunk to the same value. That assumption is
#' exactly true in a simulation that assigns lines to blocks at random, and exactly
#' what fails when blocks are families, years or breeders' sub-programmes with real
#' mean differences. Disconnection is not repaired by the estimator; it is replaced by
#' an assumption, and the assumption should be stated.
#' 
#' ### SCA and the cross-level residual are the same thing in cross means
#' 
#' One more property of the model must be stated before any variance component is
#' reported. Each cross has its own SCA, so in cross-mean data $s_{ij}$ and
#' $\bar e_{ij}$ occupy exactly the same position: only their sum
#' $\sigma^2_s + \sigma^2_e / r$ is identified. The cached study separated them by
#' an external plot-error variance and estimating $\sigma^2_s$ (the validation file
#' does not record how $\sigma^2_e$ was fixed; this is as the study describes it); an independent REML
#' implementation (`sommer`) was compared with the in-house one (check V6), and the
#' validation file records that only the **sum** is identified there, which the two
#' agreed on to
#' `r format(abs(val$rel_error[grepl("^V6", val$check) & grepl("residual", val$quantity)]), digits = 1)` relative error. A reported
#' $\sigma^2_s$ from cross means is only as good as the external plot-error
#' estimate it was separated with. `fit_gca()` in this package sidesteps the question
#' by taking the components as known, and weights each cross mean by
#' $1/(\sigma^2_s + \sigma^2_e/r)$ for exactly this reason.
#' 
#' ## The classical tester approach {#sec-mating-tester}
#' 
#' The tester design answers the sampling problem by collapsing one margin of the
#' table. Each candidate is crossed to $k$ testers of the opposite pool, and in the
#' usual reciprocal arrangement each pool's candidates are tested against the other's
#' testers, giving $k(n_A + n_B) - k^2$ crosses. Evaluating inbred
#' lines in crossbred combinations is an old practice, and @jenkins1932 compared
#' methods for it; the argument for general versus specific combining ability is
#' classically attributed to @sprague1942 and @hull1945 (not checked at page level here), and the modern treatment of tester choice is
#' @hallauer2010.
#' 
#' ### What a tester is for, and what it trades
#' 
#' A tester is a **deliberate variance trade**. It buys cheap seed production and
#' perfect connectivity -- every line tied to every other through the common testers
#' -- at the price of confounding a line's GCA with its SCA *to the testers used*,
#' and of a training set that covers the relationship space of the opposite pool
#' very thinly. The testcross mean of line $i$ estimates $g^A_i$ plus the mean of $k$
#' SCA deviations, so its error variance carries $\sigma^2_s/k$ and
#' $\sigma^2_e/(k r)$. Adding testers buys down both terms; adding replicates buys
#' down only one. That is why the allocation literature treats tester number as a
#' decision variable jointly with lines, locations and stages [@longin2006c], and why
#' it is not interchangeable with replication.
#' 
#' The closed form and its least-squares simulation on the running example, with the
#' truth redrawn in every replicate so that tester SCA is resampled as the theory
#' assumes:
#' 
## -----------------------------------------------------------------------------
#| label: fig-mating-testers
#| fig-cap: "GCA accuracy of a k-tester design against the number of testers, at one and two plots per testcross. Lines: the closed form of @tbl-mating-quantities. Points: least-squares estimates from `fit_gca()` on the 200 x 200 running example, mean of 12 replicates with the truth redrawn each time; bars are two standard errors."
#| fig-alt: "GCA accuracy of a k-tester design against the number of testers, at one and two plots per testcross"
set.seed(42)
tester_mc <- do.call(rbind, lapply(c(1, 2, 3, 4, 8), function(k) {
  do.call(rbind, lapply(1:2, function(r) {
    acc <- replicate(12, {
      tr <- simulate_factorial(n, n, vc$A, vc$B, vc$S)
      p  <- design_tester(n, n, k)
      p$reps <- r
      p  <- simulate_cross_means(p, tr, s2e)
      f  <- fit_gca(p, n, n, vc$A, vc$B, vc$S, s2e, "ls")
      mean(c(cor(f$gA, tr$gA), cor(f$gB, tr$gB)))
    })
    data.frame(k = k, r = r, acc = mean(acc), se = sd(acc) / sqrt(length(acc)))
  }))
}))
tester_mc$theory <- gca_accuracy_theory(tester_mc$k, tester_mc$r, s2g, vc$S, s2e)
tester_mc$z <- (tester_mc$acc - tester_mc$theory) / tester_mc$se
stopifnot(max(abs(tester_mc$z)) < 2)
tm_gain <- function(k0, k1) gca_accuracy_theory(k1, 1, s2g, vc$S, s2e) -
                            gca_accuracy_theory(k0, 1, s2g, vc$S, s2e)
kk <- seq(1, 8, by = 0.1)
plot(NA, xlim = c(1, 8), ylim = c(0.3, 0.9), xlab = "testers per pool, k",
     ylab = "GCA accuracy (all 200 lines)", las = 1)
cols <- c("#1f5f8b", "#b2182b")
for (r in 1:2) {
  lines(kk, gca_accuracy_theory(kk, r, s2g, vc$S, s2e),
        col = cols[r], lwd = 2)
  d <- tester_mc[tester_mc$r == r, ]
  arrows(d$k, d$acc - 2 * d$se, d$k, d$acc + 2 * d$se, angle = 90,
         code = 3, length = 0.03, col = cols[r])
  points(d$k, d$acc, pch = 19, col = cols[r])
}
legend("bottomright", c("1 plot per testcross", "2 plots per testcross"),
       col = cols, lwd = 2, pch = 19, bty = "n")

#' 
#' Result. At this seed the simulated least-squares accuracies lie within
#' `r fmt(max(abs(tester_mc$z)), 2)` standard errors of the closed form at every $k$ and both
#' replication levels (asserted below 2), the in-repo counterpart of the cached check
#' V4. With 12 replicates the standard errors are `r fmt(min(tester_mc$se), 3)` to
#' `r fmt(max(tester_mc$se), 3)`, so the comparison resolves a bias of about $\pm 0.02$ and no
#' smaller. The gain per doubling of the testers is the same at one and at four: going
#' from one to two testers at one plot raises accuracy by
#' `r fmt(tm_gain(1, 2), 3)` (from `r fmt(gca_accuracy_theory(1, 1, s2g, vc$S, s2e), 2)`
#' to `r fmt(gca_accuracy_theory(2, 1, s2g, vc$S, s2e), 2)`), going from four to eight
#' by `r fmt(tm_gain(4, 8), 3)`: equal gains per doubling, one quarter of it per added tester in the second case.
#' Interpretation. Here the plot error, $\sigma^2_e \approx$ `r fmt(s2e, 1)` at a
#' single-plot heritability of 0.3, dwarfs $\sigma^2_s =$ `r fmt(vc$S, 2)`, so testers and
#' replicates are nearly interchangeable *in this simulation*. In material where SCA
#' is 20 to 30 % of the genetic variance [@giraud2017; @lorenzi2024] the $\sigma^2_s/k$
#' term is no longer negligible and testers buy strictly more than replicates.
#' @sec-heterosis-step6 gives the finite-population version of the same curve, with
#' $k$ testers drawn without replacement from the $n_B$ available.
#' 
#' ### Choice of tester
#' 
#' The long-standing debate is between broad-base testers, elite inbreds and elite
#' single crosses. The theoretical argument against a high-performing tester is
#' @smith1986's: for many loci with substantial dominance, favourable dominant alleles
#' carried by a good tester *mask* the candidate's alleles, reducing the variance
#' among testcrosses and with it the correlation between testcross and line value. A
#' good tester discriminates less. The counter-argument is operational: an elite
#' tester produces hybrids that are themselves candidate products, so the testcross
#' trial doubles as a product trial in the background where the line will actually
#' be sold. Programmes have resolved the tension by staging --
#' discriminating testers early, elite testers late, single-cross evaluation last --
#' and the number of testers per stage is one of the levers of the scheme. In a
#' deterministic budget model of one Zimbabwean maize programme -- not a simulation of
#' genotypes, and by its authors' own statement not extrapolable to other programmes --
#' replacing a 4-1-1 tester plan with a 2-2-1 plan raised gain per dollar by 8.2 % and
#' cut the cost of a unit of gain by 7.4 %; combined with doubled haploids and a higher
#' selection intensity at the first two stages, the figures were 43.1 % and 28.5 %
#' [@chaingeni2025].
#' 
#' ### What testers cannot deliver
#' 
#' Three limitations recur, and the simulation bears on two of them.
#' 
#' **No SCA in the reference population.** With $k = 1$ the GCA model is saturated
#' and $\sigma^2_s$ is not identifiable at all (`df_sca` = 0 in
#' @tbl-mating-connectivity). With $k \ge 2$ it is identified. The model gives a
#' reason to expect it to be estimated *with the testers*: the testcross mean of a
#' line contains the mean of the same $k$ SCA deviations for every line, so what the
#' design samples is the interaction of the candidates with those $k$ partners, not
#' with the population of crosses the programme will sell. Whether the cached REML
#' estimates show a tester-specific distortion is a separate, measurable question:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-sca-ratio
#| tbl-cap: "Error of the cached REML SCA:GCA ratio $\\sigma^2_s/\\sigma^2_g$ against the reference ratio of the cached run, in percent, 2,000 plots, phenotypic BLUP, designs with all or nearly all 200 lines crossed and at least one residual df. `ratio_of_means` is the ratio of the replicate-mean components; `mean_of_ratios` is the mean over replicates of each replicate's ratio (the file's `vc_ratio_obs`). The file holds no replicate-level dispersion."
sr <- subset(sm, model == "BLUP" & budget_plots == 2000 & df_sca >= 1 &
               n_linesA_tested >= 198 &
               family %in% c("tester", "sparse_circulant", "sparse_random", "nc2"))
sr <- data.frame(design = sr$scenario, df_sca = round(sr$df_sca),
                 ratio_of_means = 100 * ((sr$vc_sca / ((sr$vc_gcaA + sr$vc_gcaB) / 2)) / ratio_ref - 1),
                 mean_of_ratios = 100 * (sr$vc_ratio_obs / ratio_ref - 1))
sr <- sr[order(-sr$mean_of_ratios), ]
rownames(sr) <- NULL
stopifnot(sr$design[which.max(abs(sr$ratio_of_means))] == "circulant c=2",
          sr$design[which.max(abs(sr$mean_of_ratios))] == "circulant c=2")
fmt(sr, 1)

#' 
#' Result. Read as a ratio of replicate-mean components, the ratio is
#' `r fmt(sr$ratio_of_means[sr$design == "tester k=2"], 1)` % off the reference at $k = 2$ and
#' `r fmt(sr$ratio_of_means[sr$design == "tester k=4"], 1)` % at $k = 4$; read as the mean of
#' the per-replicate ratios, `r fmt(sr$mean_of_ratios[sr$design == "tester k=2"], 1)` % and
#' `r fmt(sr$mean_of_ratios[sr$design == "tester k=4"], 1)` %. For sparse designs the same
#' two statistics give `r fmt(sr$ratio_of_means[sr$design == "circulant c=3"], 1)` and
#' `r fmt(sr$mean_of_ratios[sr$design == "circulant c=3"], 1)` % at circulant $c = 3$ and
#' `r fmt(sr$ratio_of_means[sr$design == "circulant c=5"], 1)` and
#' `r fmt(sr$mean_of_ratios[sr$design == "circulant c=5"], 1)` % at $c = 5$; the
#' errors across the table run from `r fmt(min(sr$ratio_of_means), 1)` to
#' `r fmt(max(sr$ratio_of_means), 1)` % (ratio of means). Interpretation. The two
#' statistics disagree by up to `r fmt(max(abs(sr$mean_of_ratios - sr$ratio_of_means)), 0)`
#' points, as they must: the mean of a ratio is not the ratio of the means, and
#' the former is the Jensen-biased one. Under either, circulant $c = 5$ is at least as far from
#' the reference as the tester designs, and the sign changes across the sparse
#' designs, so the cached file does not show an inflation specific to testers. It
#' also cannot show that there is none: with no replicate-level dispersion in the
#' file, differences of a few percent cannot be called resolved. The mechanism above
#' stays a statement about the model, not a measured effect.
#' 
#' **Testcross ranking is not single-cross ranking.** Comparing testcross progeny
#' tests with randomly paired single-cross tests, @burdo2021 found that the top 25
#' lines on testcross yield and on single-cross yield coincided for only 48 % of
#' lines in the Stiff Stalk pool and 11 % in the Iowa Dent pool -- almost disjoint
#' selections -- rising to 56 % in both with genomic prediction.
#' 
#' **A thin training set.** All hybrids of a candidate share one or two partners, so
#' the design explores a narrow slice of the hybrid relationship space. Testcross
#' was the worst of the designs compared as a training set for predicting the
#' single crosses of a full diallel [@fritscheneto2018], and simulation agrees that
#' the deficit grows with the SCA share [@seye2020].
#' 
#' ### When the tester is still right
#' 
#' None of this makes testers obsolete. They remain the right answer when seed
#' production rather than plot capacity binds -- a tester cross is made in bulk in an
#' isolation block or on a male-sterile female, a sparse factorial needs many small
#' hand pollinations (@sec-mating-cost) -- when the candidate set is so large that
#' the first screen must be cheap per line, in programmes that cannot fit a mixed
#' model and whose field holds only two or three crosses per line
#' (@sec-mating-analysis), and in the first cycle of a new pool, where there is
#' no relationship information to exploit. @gonzalezdieguez2026 make the case for a
#' hybrid of the two logics: three to five testers allocated *sparsely* across
#' families rather than every tester crossed to every line.
#' 
#' ## Sparse and incomplete factorials {#sec-mating-sparse}
#' 
#' Once candidates are crossed to *each other* rather than to a common tester, the
#' design becomes a sparse bipartite graph, and two things matter: how many crosses
#' each line gets, $c$, and whether the graph is connected. Which particular partners
#' are drawn matters much less.
#' 
#' ### The design family
#' 
#' The classical theory is the partial diallel of @kempthorne1961: each parent
#' crossed to a fixed number $s$ of others, with the sampling variances of the
#' genetic components derived as functions of $s$. Its two-pool analogue is the
#' incomplete factorial, each pool-A line crossed to $c$ of the $n_B$ pool-B lines.
#' The members studied here:
#' 
#' - **random sparse** -- $c \cdot n_A$ cells drawn at random. Lines receive a
#'   Binomial number of crosses, some none; the graph may be disconnected.
#' - **circulant (round-robin)** -- pool-A line $i$ crossed to pool-B lines
#'   $(i - 1 + o) \bmod n_B + 1$ for $c$ offsets $o$. With $n_A = n_B$ every line in
#'   both pools has exactly $c$ crosses, and choosing offsets with
#'   $\gcd(n_B, \Delta o) = 1$ guarantees one component. `design_circulant()` nudges
#'   the last offset until that holds.
#' - **NC II in sets** -- complete $a \times b$ factorials on disjoint line sets
#'   (the layout attributed to @comstock1948); deliberately disconnected.
#' - **criterion-optimised** -- greedy exchange towards A-optimality, D-optimality or
#'   CDmean [@rincent2012]; **relationship-guided** -- partners chosen to minimise
#'   genomic similarity between parents. Both appear in the cached sweep only.
#' 
#' ### How sparse is sparse enough -- the published evidence
#' 
#' Remarkably sparse, provided the design is structured and analysed well. The most
#' informative single data point is operational rather than simulated: a commercial
#' winter oilseed rape programme ran 4,000 hybrids over 61 unreplicated trials
#' covering **1.67 % of all mother x father combinations**, and a GCA + SCA model
#' still reached accuracies of 0.63, 0.84 and 0.80 for yield, oil and protein after a
#' further 50 % of the observations were artificially removed [@thomsen2026]. Across
#' maize, wheat and rice, training sets of 2 to 13 % of the hybrid set sufficed for
#' genomic prediction [@guo2019]. A 363-hybrid dent x flint factorial predicted an
#' independent 951-hybrid factorial as well as or better than tester designs at
#' equal numbers of hybrids and lines [@lorenzi2022]; NC II was the best and
#' testcross the worst training set for predicting a full diallel
#' [@fritscheneto2018]; and in simulation the factorial's advantage grew with the
#' SCA share [@seye2020].
#' 
#' The design principle that this chapter's own sweep supports is to **spend the hybrid
#' budget on parents, not on depth per parent** -- up to the point where $c$ is so
#' small that connectivity and within-line precision fail -- and the published
#' evidence says that the point depends on what is to be predicted. @melchinger2023
#' found, in their first data set (DS1) at a training-set size of 96 hybrids, for hybrids with both
#' parents untested (H0), the accuracy maximal at $c = 1$, each parent in a single
#' cross, exceeding $c = 2$ and $c = 4$ by about 1 to 3 % and 5 to 10 % (largest
#' differences at high heritability); for hybrids with one or both parents in the
#' training set (H1, H2), and for the GCA of lines that are in it, $c = 1$ gave the
#' lowest accuracy in DS1, and the optimum $c$ across hybrid types depends on the
#' size and resources of the programme. Their second data set (DS2) is described
#' as showing essentially the same picture with some trends amplified: at 96
#' training hybrids the difference between $c = 1$ and $c = 4$ for H0 hybrids was
#' larger than in DS1 in all six scenarios, with an attainable accuracy at $c = 1$ of
#' 0.50 to 0.65 at low and 0.70 to 0.85 at high heritability, while the accuracy of
#' H1 hybrids hardly differed between $c = 1$, 2 and 4. The percentages above are
#' DS1 figures; no DS2 percentage is quoted here. That is a trade between
#' predicting new lines and estimating the ones already crossed, at a fixed number of
#' hybrids; the sweep below fixes plots, not hybrids, and scores GCA of lines in the
#' field, so it is not a test of that paper (@tbl-mating-crosscheck).
#' 
#' ### Sparse versus tester, at equal plot budget
#' 
#' The cached sweep puts every design at the same three plot budgets and scores GCA
#' accuracy over all 200 candidates per pool, analysed by phenotypic BLUP:
#' 
#' ![GCA accuracy against the number of distinct hybrids in the field, one line per design family, panelled by plot budget. Cached from the `sparsex` sweep: 30 replicates per cell, phenotypic BLUP, accuracy over all 200 candidates per pool.](figs/mating_acc_vs_hybrids.png){fig-alt="GCA accuracy against the number of distinct hybrids in the field, one line per design family, panelled by plot budget" #fig-mating-acc-hybrids width=100%}
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-h2h
#| tbl-cap: "Best tester against best sparse factorial (circulant or random) at each plot budget, phenotypic BLUP. Each arm is the best of 4 tester or 8 sparse cells, chosen on the same means that are then compared (a winner's-curse bias in favour of the difference, whose size is not estimated here). `z` is the difference over $\\sqrt{se_a^2 + se_b^2}$, unpaired; this chapter calls a difference resolved when $z > 3$."
rg <- subset(bl, budget_plots == 1000 & scenario == "relationship-guided c=5")
rg_z <- (rg$acc_gca_all - h2h$sparse_acc[1]) /
        sqrt(rg$se_acc_gca_all^2 + subset(bl, budget_plots == 1000 &
             scenario == h2h$best_sparse[1])$se_acc_gca_all^2)
fmt(h2h, 3)

#' 
#' Result. The sparse factorial wins at every budget, by
#' `r fmt(h2h$difference[1], 3)`, `r fmt(h2h$difference[2], 3)` and
#' `r fmt(h2h$difference[3], 3)`, each more than `r floor(min(h2h$z))` standard errors.
#' At 1,000 plots the relationship-guided design with five crosses per line is
#' marginally ahead of the best sparse one
#' (`r fmt(subset(bl, budget_plots == 1000 & scenario == "relationship-guided c=5")$acc_gca_all, 3)`
#' against `r fmt(h2h$sparse_acc[1], 3)`, $z =$ `r fmt(rg_z, 1)`); it is excluded from
#' the table only so that the comparison is between designs that need no markers.
#' The z-scores are unpaired, and the cached files do not record whether the arms
#' share founders within a replicate: if they do, the z-scores are conservative.
#' Interpretation. Two
#' features of the table are mechanical and worth naming. The best tester never uses
#' more than 1,584 crosses because $k = 4$ is the largest tester set swept, and at
#' 3,000 plots it can only add replication, which buys down $\sigma^2_e$ but not
#' $\sigma^2_s$. And the sparse winner at 3,000 plots is random rather than circulant
#' because at $c = 10$ connectivity is no longer in question and the layouts converge.
#' 
#' The smallest fields that reach a given accuracy. Two candidate sets are shown,
#' because the first admits designs that use markers (relationship-guided, A-optimal,
#' and the CDmean line subsets) and the second restricts the search to the families of
#' @tbl-mating-h2h, which need none:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-fewest
#| tbl-cap: "Fewest distinct field hybrids whose phenotypic-BLUP GCA accuracy reaches each target. `candidates` is `all designs` (marker-using ones included) or `tester and sparse` (the families of @tbl-mating-h2h). Costs use the placeholder levels of @sec-mating-cost."
fewest_of <- function(dat, label) do.call(rbind, lapply(c(0.60, 0.65, 0.70, 0.75, 0.80), function(tg) {
  d <- subset(dat, acc_gca_all >= tg)
  d <- d[order(d$n_crosses, d$budget_plots), ][1, ]   # ties: the smaller field
  data.frame(candidates = label, target = tg, design = d$scenario, plots = d$budget_plots,
             hybrids = round(d$n_crosses), pct_factorial = 100 * d$n_crosses / n^2,
             accuracy = d$acc_gca_all, se = d$se_acc_gca_all,
             cost = round(d$cost_total))
}))
fewest_all <- fewest_of(bl, "all designs")
fewest_nm  <- fewest_of(subset(bl, family %in% c("tester", sparse_fam)),
                        "tester and sparse")
fmt(rbind(fewest_all, fewest_nm), 3)

#' 
#' Result. Over all designs, `r fewest_all$hybrids[1]` hybrids -- `r fmt(fewest_all$pct_factorial[1], 1)` % of the
#' factorial -- reach `r fmt(fewest_all$accuracy[1], 3)`; `r fewest_all$hybrids[3]`
#' (`r fmt(fewest_all$pct_factorial[3], 1)` %) reach `r fmt(fewest_all$accuracy[3], 3)`; and
#' `r fewest_all$hybrids[5]` (`r fmt(fewest_all$pct_factorial[5], 1)` %) reach
#' `r fmt(fewest_all$accuracy[5], 3)`. Among the families that need no markers the same
#' targets cost `r paste(fewest_nm$hybrids, collapse = ", ")` hybrids (targets 0.60 to
#' 0.80). The designs that win the higher targets over all designs are
#' `r paste(unique(fewest_all$design[fewest_all$target >= 0.65]), collapse = " and ")`, which use
#' markers. Interpretation. This is consistent in order of magnitude with the
#' operational and published sampling fractions [@thomsen2026; @guo2019] and
#' adds the part they leave implicit: the fraction is set by the accuracy target, not
#' by a universal threshold. What limits it: each number is the smallest cell of a
#' 24-design, 3-budget grid, so it is a bound on the grid, not an optimum over
#' designs.
#' 
#' ### Crosses per line, and structure versus randomness
#' 
#' ![GCA accuracy against crosses per line $c$, separating circulant (structured) from random sparse layouts. Cached from the `sparsex` sweep.](figs/mating_acc_vs_c.png){fig-alt="GCA accuracy against crosses per line , separating circulant (structured) from random sparse layouts" #fig-mating-acc-c width=100%}
#' 
#' The literature leaves one comparison open: structured against random layouts at
#' matched $c$ [@weeks1964 and @fernando1983 supply the tools; none of the design papers cited in
#' this chapter was found to report the connectivity of the layout it used, which is a
#' statement about those papers, not about the literature as a whole]. The sweep addresses it at
#' 2,000 plots:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-matched-c
#| tbl-cap: "Circulant against random sparse at matched crosses per line, 2,000 plots, phenotypic BLUP. `z` is unpaired, over $\\sqrt{se_a^2 + se_b^2}$. `comp_random` and `lines_random` are the mean number of connected components and of pool-A lines crossed in the random layout; the circulant layout has one component and every line crossed."
mc <- subset(bl, budget_plots == 2000 & family %in% sparse_fam)
cols <- c("x_axis", "acc_gca_all", "se_acc_gca_all", "n_components", "n_linesA_tested")
mc <- merge(subset(mc, family == "sparse_circulant")[, cols],
            subset(mc, family == "sparse_random")[, cols],
            by = "x_axis", suffixes = c("_circ", "_rand"))
mc <- data.frame(c = mc$x_axis, circulant = mc$acc_gca_all_circ,
                 random = mc$acc_gca_all_rand,
                 difference = mc$acc_gca_all_circ - mc$acc_gca_all_rand,
                 z = (mc$acc_gca_all_circ - mc$acc_gca_all_rand) /
                     sqrt(mc$se_acc_gca_all_circ^2 + mc$se_acc_gca_all_rand^2),
                 comp_random = mc$n_components_rand,
                 lines_random = mc$n_linesA_tested_rand)
fmt(mc, 3)

#' 
#' Result. The circulant layout is ahead at every $c$; the gap is
#' `r fmt(mc$difference[1], 3)` at $c = 2$, largest at $c = 3$
#' (`r fmt(mc$difference[2], 3)`) and `r fmt(mc$difference[4], 3)` at $c = 10$. The
#' z-scores are `r paste(fmt(mc$z, 1), collapse = ", ")` at $c = 2, 3, 5, 10$, so the
#' margin at $c = 10$ is a single cached run, `r fmt(mc$z[4], 2)` standard errors
#' unpaired, a little above this chapter's threshold of 3. The random layout has
#' `r fmt(mc$comp_random[1], 1)` and `r fmt(mc$comp_random[2], 1)` components at
#' $c = 2$ and $c = 3$ and `r fmt(mc$comp_random[3], 1)` at $c = 5$ and 10.
#' 
#' Interpretation. At $c = 2$ and $c = 3$ the random layout leaves lines uncrossed
#' and splits the rest into several components, which @tbl-mating-connectivity shows
#' costs estimability; that is the likely source of the gap there, though the table does
#' not isolate it. At $c = 5$ and $c = 10$ both layouts are a single component and the
#' circulant one is still ahead, so connectivity does not explain those gaps; what
#' differs is the regularity of the degree (exactly $c$ crosses per line against a
#' Binomial number), which this chapter did not test. **A sparse factorial should be
#' built, not sampled**, at least at low $c$.
#' 
#' ### What is lost
#' 
#' SCA is weakly estimated at low $c$. The circulant design with $c = 2$ has exactly
#' `r diag_tab$df_sca[4]` residual degree of freedom at cross-mean level
#' (@tbl-mating-connectivity) -- enough to fit a model and not enough to estimate a
#' variance component -- and the cached REML SCA:GCA ratio there is off the reference
#' by `r fmt(sr$ratio_of_means[sr$design == "circulant c=2"], 1)` % as a ratio of
#' replicate-mean components (`r fmt(sr$mean_of_ratios[sr$design == "circulant c=2"], 1)` %
#' as a mean of ratios), the largest error in @tbl-mating-sca-ratio under either statistic.
#' The same table shows errors of `r fmt(sr$ratio_of_means[sr$design == "circulant c=5"], 1)` % at
#' $c = 5$, so the cached REML evidence does not by itself separate $c = 2$ from higher
#' $c$; the structural fact, one residual df at $c = 2$ against
#' `r diag_tab$df_sca[5]` at $c = 5$ (@tbl-mating-connectivity), does. The
#' recommendation therefore splits by objective: $c = 2$ to rank lines, $c \ge 3$ before
#' any statement about SCA variance.
#' 
#' Sparsity in crosses also interacts with sparsity in environments. A parallel
#' literature, mostly from CIMMYT, allocates entries to subsets of environments and
#' predicts the unobserved line-by-environment cells [@jarquin2020; @atanda2021;
#' @atanda2022; @montesinoslopez2023]. When the genetic correlation between
#' managements is as low as 0.37 [@atanda2021], a line observed only in one is weakly
#' informative about the other. A design observing 2 % of the hybrid factorial and
#' 30 % of the environment cells within that observes well under 1 % of the
#' information space, and the two sparsities have not been studied together for
#' hybrids (@sec-mating-open). @sec-sparse takes the environment axis on its own and
#' @sec-joint the two together.
#' 
#' ## The analysis is part of the design {#sec-mating-analysis}
#' 
#' The sparsest factorials ($c \le 3$ per line) are good designs only if analysed
#' with a shrinkage estimator. This section exists because, for them, the estimator
#' changes the accuracy by more than the best sparse design gains over the best
#' tester under BLUP (@tbl-mating-h2h); the comparison is made below.
#' 
#' The demonstration is live: one replicate of the running example at 2,000 plots,
#' the same data analysed both ways.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-ls-blup
#| tbl-cap: "One replicate of the 200 x 200 running example at 2,000 plots: the same phenotypes analysed by least squares and by BLUP with known variance components."
set.seed(99)
ls_blup <- do.call(rbind, lapply(c("tester k=2", "circulant c=2", "circulant c=5"),
  function(nm) {
    tr <- simulate_factorial(n, n, vc$A, vc$B, vc$S)
    p  <- simulate_cross_means(design_reps(plans[[nm]], 2000), tr, s2e)
    acc <- sapply(c("ls", "blup"), function(meth) {
      f <- fit_gca(p, n, n, vc$A, vc$B, vc$S, s2e, meth)
      mean(c(cor(f$gA, tr$gA), cor(f$gB, tr$gB)))
    })
    data.frame(design = nm, crosses = nrow(p), plots_per_cross = mean(p$reps),
               least_squares = acc[["ls"]], blup = acc[["blup"]],
               blup_advantage = acc[["blup"]] - acc[["ls"]])
  }))
fmt(ls_blup, 3)

#' 
#' Result. On the tester design the two estimators agree to within
#' `r fmt(abs(ls_blup$blup_advantage[1]), 3)`. On the circulant design with two
#' crosses per line, least squares collapses to
#' `r fmt(ls_blup$least_squares[2], 2)` while BLUP reaches
#' `r fmt(ls_blup$blup[2], 2)` on the same data. The cached sweep, averaged over 30
#' replicates, reproduces the pattern across all 24 designs:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-ls-sweep
#| tbl-cap: "BLUP advantage over least squares by design, 2,000 plots, ordered by size. Cached `sparsex` sweep, 30 replicates per cell."
lsb <- merge(subset(sm, model == "LS"   & budget_plots == 2000)[, c("scenario", "n_crosses", "acc_gca_all")],
             subset(sm, model == "BLUP" & budget_plots == 2000)[, c("scenario", "acc_gca_all")],
             by = "scenario", suffixes = c("_ls", "_blup"))
lsb$advantage <- lsb$acc_gca_all_blup - lsb$acc_gca_all_ls
lsb <- lsb[order(-lsb$advantage), ]
names(lsb) <- c("design", "hybrids", "least_squares", "blup", "advantage")
lsb$hybrids <- round(lsb$hybrids)
rownames(lsb) <- NULL
fmt(lsb, 3)

#' 
#' Result. The penalty for least squares is
#' `r fmt(lsb$advantage[1], 3)` correlation points at circulant $c = 2$ and
#' `r fmt(lsb$advantage[2], 3)` at $c = 3$, against `r fmt(max(h2h$difference), 3)` at
#' most for the best sparse design over the best tester under BLUP (@tbl-mating-h2h);
#' for the four tester designs it is
#' `r fmt(min(lsb$advantage[grepl("tester", lsb$design)]), 3)` to
#' `r fmt(max(lsb$advantage[grepl("tester", lsb$design)]), 3)`.
#' 
## -----------------------------------------------------------------------------
#| include: false
stopifnot(min(lsb$advantage[1:2]) > max(h2h$difference))

#' 
#' Testers lose little to
#' least squares; the sparsest factorials lose much. Whether that makes a tester the
#' better design when only least squares is available is a different comparison, at
#' equal plots, against the best least-squares tester:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-ls-vs-tester
#| tbl-cap: "Least-squares GCA accuracy of every non-tester design at 2,000 plots (sparse, NC II and genomic-cross families; the subset designs, which field fewer lines, are left out), against the best least-squares tester. `difference` and `z` (unpaired; this chapter calls a difference resolved when z > 3) are from the cached sweep; `in_repo` is the in-repo core sweep (@sec-mating-reproduce), where the design is present."
o <- lsz[order(-lsz$acc_gca_all), ]
fmt(data.frame(design = o$scenario, hybrids = round(o$n_crosses),
               least_squares = o$acc_gca_all, difference = o$difference, z = o$z,
               in_repo = o$acc_core), 3)

#' 
#' Result. Under least squares at 2,000 plots, `r sum(lsz$z > 3)` of the
#' `r nrow(lsz)` designs exceed the best tester with z > 3: random sparse $c = 10$
#' (`r fmt(lz("random sparse c=10")$difference, 3)`, z =
#' `r fmt(lz("random sparse c=10")$z, 1)`), NC II
#' (`r fmt(lz("NC II 10x10 sets")$difference, 3)`, z =
#' `r fmt(lz("NC II 10x10 sets")$z, 1)`), the relationship-guided $c = 5$ design
#' (`r fmt(lz("relationship-guided c=5")$difference, 3)`, z =
#' `r fmt(lz("relationship-guided c=5")$z, 1)`), circulant $c = 10$
#' (`r fmt(lz("circulant c=10")$difference, 3)`, z =
#' `r fmt(lz("circulant c=10")$z, 1)`) and random sparse $c = 5$
#' (`r fmt(lz("random sparse c=5")$difference, 3)`, z =
#' `r fmt(lz("random sparse c=5")$z, 1)`, at the chapter's threshold). The other
#' `r sum(lsz$z < -3)` designs lie below the best tester with z < -3 (circulant $c = 2$,
#' 3 and 5, random sparse $c = 2$ and 3, and the two genomic $c = 3$ designs), by
#' `r fmt(-max(lsz$difference[lsz$z < -3]), 3)` to
#' `r fmt(-min(lsz$difference[lsz$z < -3]), 3)`. The in-repo core
#' sweep agrees for random sparse $c = 10$
#' (`r fmt(lz("random sparse c=10")$acc_core, 3)`) and NC II
#' (`r fmt(lz("NC II 10x10 sets")$acc_core, 3)`) against a tester at
#' `r fmt(ls_t_core, 3)`, but not for circulant $c = 10$, which is
#' `r fmt(lz("circulant c=10")$acc_core, 3)` in-repo against
#' `r fmt(lz("circulant c=10")$acc_gca_all, 3)` in the cached sweep, below the
#' in-repo tester; that disagreement is the one left unexplained in
#' @sec-mating-reproduce. Interpretation. The least-squares penalty makes a tester the
#' better design only against the sparsest layouts ($c \le 3$ per line, and circulant
#' $c = 5$); with $c = 10$ random crosses per line, or NC II sets, an unshrunken
#' estimate is already better than the best tester's at equal plots, in both sweeps, and
#' so is circulant $c = 10$ in the cached sweep only. What limits this: one
#' budget (2,000 plots), unpaired z from a cached external sweep whose replicate unit
#' is not known, a circulant $c = 10$ row the in-repo sweep does not reproduce, and
#' "best tester" and the sparse arms chosen on the same means (the winner's-curse
#' caveat of @tbl-mating-h2h applies).
#' 
#' Interpretation of the estimator contrast. At low $c$ each GCA estimate rests on two or
#' three cross means, each carrying a full $\sigma^2_s + \sigma^2_e/r$ of noise, and the
#' unshrunken estimate is dominated by it. BLUP borrows strength across the connected
#' graph: a line's partners are themselves estimated from *their* partners, and the
#' shrinkage towards zero is proportional to how little each line was observed. That
#' the circulant design loses more to least squares than the random one at the same
#' $c$ is not a contradiction of the previous section. The circulant design's partners
#' are each other's partners in long chains, which is what BLUP can exploit and least
#' squares cannot; this is a mechanism proposed here, not one the sweep isolates.
#' 
#' The practical consequence is conditional on $c$ and on the layout: **a programme
#' that cannot or will not fit a mixed model should avoid the sparsest layouts**
#' ($c \le 3$ per line, circulant $c = 5$) -- under least squares they are worse than a
#' tester -- while a design with $c = 10$ or an NC II layout retains an advantage over
#' the best tester in this sweep (@tbl-mating-ls-vs-tester). The literature that
#' motivated BLUP of single crosses [@bernardo1994; @bernardo1996] and the allocation
#' tools that assume it [@endelman2014; @mi2014] are cited here for that context; this
#' chapter has not checked, page by page, what they state about the estimator.
#' 
#' ## Genomic information for deciding which crosses to make {#sec-mating-genomic}
#' 
#' Genomic information changes the question from *how well can I estimate the lines I
#' crossed?* to *which crosses should I make, and what can I say about the ones I
#' did not?* Its value is in extrapolation and in the choice of what to field, not in
#' improving estimates for lines that are already there.
#' 
#' ### From relatedness to hybrid prediction
#' 
#' The idea that untested single crosses can be predicted from tested ones through
#' marker relatedness is @bernardo1994's: random subsets of 10 to 30 hybrids from a
#' 54-hybrid factorial, and RFLP relationships recovering single-cross performance.
#' @bernardo1996 scaled it to operational data, with correlations of 0.43 to 0.76 for
#' yield in heterotic patterns with more than 100 tested crosses. @massman2012 compared
#' marker-relatedness BLUP with ridge-regression marker effects on 479 single crosses.
#' The modern version models hybrid value as pool-specific additive kernels for GCA plus
#' a dominance or product kernel for SCA [@technow2012; @technow2014]. This book does not fit
#' those models: @sec-genomic-prediction fits one additive GBLUP kernel over all hybrids, with
#' no pool split, on a trait with no SCA, and @sec-hybrid-cv validates that fit by masking
#' hybrids.
#' 
#' The kernel the cached sweep used for SCA follows from the algebra of
#' @sec-mating-estimation: $s_{ij} = -2\sum_k d_k\,\delta u_{ik}\,\delta v_{jk}$ is linear
#' in the *elementwise product* of the two parents' centred genotypes, so the natural
#' SCA kernel is the linear kernel on that product. It is **not** the Hadamard
#' product of the two pool kernels, which adds cross-locus terms the model does not
#' contain.
#' 
#' ### The T0 / T1 / T2 hierarchy
#' 
#' The standard currency for comparing designs is the split of untested hybrids by how
#' many of their parents appear in the training set: both (T2), one (T1), neither (T0).
#' Grain-yield accuracies of 0.91, 0.85 and 0.77 with 300 training hybrids
#' [@technow2014], 0.92, 0.88 and 0.80 under a GCA model on the Hohenheim series
#' [@gonzalezdieguez2021], and 0.28 to 0.77 with the ordering
#' T2 > T1-female > T1-male > T0 [@kadam2016b]. The hierarchy also explains why a
#' tester is a poor training set: it generates only T1-type information for new
#' lines, because the tester is always a tested parent and the candidate never is.
#' 
#' These figures share a property that must be stated: they come from material with
#' strong family structure, where an untested line has close relatives in the
#' training set. @technow2019 found that the difference in accuracy between two training-set types,
#' F1 hybrids and F1:2 bulks, was largest under a divergent heterotic structure and ranged
#' from 0.15 correlation points for hybrids that are themselves in the training set (T3) to 0.06
#' for T0, at constant residual variation. **Published T0 accuracies are not
#' programme-independent**, and the simulated counter-example below makes the point
#' concrete.
#' 
#' ### The negative result
#' 
#' ![Genomic against phenotypic BLUP by design (left) and the genomic accuracy for hybrids whose parents were never crossed (right). Cached from the `sparsex` sweep, 2,000 plots.](figs/mating_genomic_tlevel.png){fig-alt="Genomic against phenotypic BLUP by design (left) and the genomic accuracy for hybrids whose parents were never crossed (right)" #fig-mating-genomic width=100%}
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-gblup
#| tbl-cap: "Genomic (GBLUP) against phenotypic BLUP on all-lines GCA accuracy, 2,000 plots, the six largest differences. `z` in standard errors of the difference, unpaired. `T2` and `T0` are the genomic accuracies for **hybrids** whose two parents, or neither parent, were crossed, as on the vertical axis of the figure; they are accuracies for hybrid value, not GCA accuracies, and `T0` is defined only where some lines were left out."
gb <- merge(subset(sm, model == "GBLUP" & budget_plots == 2000)[, c("scenario", "n_linesA_tested", "acc_gca_all", "se_acc_gca_all", "acc_T2", "acc_T0")],
            subset(sm, model == "BLUP"  & budget_plots == 2000)[, c("scenario", "acc_gca_all", "se_acc_gca_all")],
            by = "scenario", suffixes = c("_g", "_p"))
gb <- data.frame(design = gb$scenario, lines_tested = gb$n_linesA_tested,
                 phenotypic = gb$acc_gca_all_p, genomic = gb$acc_gca_all_g,
                 difference = gb$acc_gca_all_g - gb$acc_gca_all_p,
                 z = (gb$acc_gca_all_g - gb$acc_gca_all_p) /
                     sqrt(gb$se_acc_gca_all_g^2 + gb$se_acc_gca_all_p^2),
                 T2 = gb$acc_T2, T0 = gb$acc_T0)
gb <- gb[order(-gb$difference), ]
rownames(gb) <- NULL
gb_oth <- gb[gb$difference < 0, ]      # the designs where genomics did not gain
fmt(head(gb, 6), 3)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-gblup-cells
#| tbl-cap: "Every cell, over the three plot budgets, in which GBLUP exceeded phenotypic BLUP on all-lines GCA accuracy. `plots` is the number of plots actually fielded (replication is capped at three per cross, so a reduced design fields the same plots at several budgets). `same_data` marks a cell identical, to full precision, to one at a smaller budget."
gc <- merge(subset(sm, model == "GBLUP")[, c("budget_plots", "scenario", "n_plots", "acc_gca_all", "se_acc_gca_all")],
            subset(sm, model == "BLUP")[, c("budget_plots", "scenario", "acc_gca_all", "se_acc_gca_all")],
            by = c("budget_plots", "scenario"), suffixes = c("_g", "_p"))
gc <- gc[order(gc$budget_plots, gc$scenario), ]
gc$difference <- gc$acc_gca_all_g - gc$acc_gca_all_p
gc$z <- gc$difference / sqrt(gc$se_acc_gca_all_g^2 + gc$se_acc_gca_all_p^2)
gc$same_data <- duplicated(gc[, c("scenario", "n_plots", "acc_gca_all_g", "acc_gca_all_p")])
gw <- gc[gc$difference > 0, ]
gw_tab <- data.frame(budget = gw$budget_plots, design = gw$scenario, plots = gw$n_plots,
                     difference = gw$difference, z = gw$z, same_data = gw$same_data)
rownames(gw_tab) <- NULL
fmt(gw_tab, 3)
n_win_cells <- sum(!gw$same_data)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-cdmean
#| tbl-cap: "Reduced line sets at 2,000 plots: CDmean against random choice of the lines, under each model. `z_genomic` and `z_phenotypic` are the unpaired z of the cdmean-minus-random difference in all-lines GCA accuracy under GBLUP and under BLUP."
cm <- subset(sm, budget_plots == 2000 & grepl("lines/pool", scenario) & model %in% c("BLUP", "GBLUP"))
cm$set <- ifelse(grepl("cdmean", cm$scenario), "cdmean", "random")
cm$cfg <- sub(" \\((cdmean|random)\\)", "", cm$scenario)
cm$key <- paste(cm$set, cm$model, sep = ".")
cmw <- reshape(cm[, c("cfg", "key", "n_plots", "acc_gca_all", "se_acc_gca_all")],
               idvar = c("cfg", "n_plots"), timevar = "key", direction = "wide")
zdiff <- function(m) (cmw[[paste0("acc_gca_all.cdmean.", m)]] - cmw[[paste0("acc_gca_all.random.", m)]]) /
  sqrt(cmw[[paste0("se_acc_gca_all.cdmean.", m)]]^2 + cmw[[paste0("se_acc_gca_all.random.", m)]]^2)
cm_tab <- data.frame(design = cmw$cfg, plots = cmw$n_plots,
                     blup_random = cmw$acc_gca_all.random.BLUP, blup_cdmean = cmw$acc_gca_all.cdmean.BLUP,
                     gblup_random = cmw$acc_gca_all.random.GBLUP, gblup_cdmean = cmw$acc_gca_all.cdmean.GBLUP,
                     z_genomic = zdiff("GBLUP"), z_phenotypic = zdiff("BLUP"))
cm_tab <- cm_tab[order(cm_tab$design), ]
rownames(cm_tab) <- NULL
stopifnot(all(cm_tab$z_phenotypic < 0), all(abs(cm_tab$z_genomic) < 2))
# Standard error of the genomic CDmean-minus-random difference, per configuration.
cm_se_g <- sqrt(cmw[["se_acc_gca_all.cdmean.GBLUP"]]^2 + cmw[["se_acc_gca_all.random.GBLUP"]]^2)
fmt(cm_tab, 3)

#' 
#' Result. At 2,000 plots genomic kernels raised all-lines GCA accuracy in
#' `r sum(gb$difference > 0)` of `r nrow(gb)` designs, both of them reduced line sets of
#' 50 per pool chosen by CDmean (+`r fmt(gb$difference[1], 3)` and
#' +`r fmt(gb$difference[2], 3)`, z = `r fmt(gb$z[1], 1)` and `r fmt(gb$z[2], 1)`). Over the three
#' budgets @tbl-mating-gblup-cells lists `r nrow(gw)` winning rows, but only
#' `r n_win_cells` distinct cells: the rows at 2,000 and 3,000 plots of the two designs are
#' the same data for the 50-line, $c = 10$ design (replication is capped at three, so it
#' fields 1,500 plots at both budgets), and the 50-line, $c = 5$ design fields 750 plots at
#' every budget, so its three rows are one cell. The
#' three distinct cells have z = `r paste(fmt(gw$z[!gw$same_data], 2), collapse = ", ")`;
#' the smallest is below this chapter's threshold of 3, and the budgets are not
#' replicates of one another. In every other design at 2,000 plots -- all 200
#' candidates fielded, 50 per pool drawn at random, or 100 per pool by either rule --
#' the genomic model was level with or below the phenotypic one, by
#' `r fmt(-max(gb_oth$difference), 3)` to `r fmt(-min(gb_oth$difference), 3)`:
#' below by more than three standard errors in `r sum(gb_oth$z < -3)` of
#' `r nrow(gb_oth)`, between two and three in `r sum(gb_oth$z >= -3 & gb_oth$z <= -2)`
#' (`r paste(gb_oth$design[gb_oth$z >= -3 & gb_oth$z <= -2], collapse = ", ")`), which
#' this chapter's three-standard-error rule does not count as resolved, and within
#' two in `r sum(gb_oth$z > -2)`
#' (`r paste(gb_oth$design[gb_oth$z > -2], collapse = ", ")`), unresolved at 30
#' replicates. @tbl-mating-cdmean pairs the CDmean line sets with random ones of the
#' same size: the genomic accuracy is not distinguished between the two choices (z =
#' `r paste(fmt(cm_tab$z_genomic, 2), collapse = ", ")` across the four configurations;
#' an absolute z below 2 does not show equality: with a standard error of the difference of
#' `r fmt(min(cm_se_g), 3)` to `r fmt(max(cm_se_g), 3)`, differences up to about
#' `r fmt(2 * max(cm_se_g), 3)` are not excluded),
#' while the phenotypic accuracy is lower for CDmean in each (z =
#' `r paste(fmt(cm_tab$z_phenotypic, 1), collapse = ", ")`), resolved only in the two 50-line
#' configurations. Genomic T0 accuracy, where it
#' is defined on more than a handful of lines, was
#' `r fmt(min(gb$T0[gb$lines_tested <= 100], na.rm = TRUE), 2)` to
#' `r fmt(max(gb$T0[gb$lines_tested <= 100], na.rm = TRUE), 2)`, against genomic T2 of
#' `r fmt(min(gb$T2[gb$lines_tested <= 100], na.rm = TRUE), 2)` to
#' `r fmt(max(gb$T2[gb$lines_tested <= 100], na.rm = TRUE), 2)` in the same designs, a ratio of
#' `r fmt(min((gb$T2 / gb$T0)[gb$lines_tested <= 100 & gb$T0 > 0], na.rm = TRUE), 1)` to
#' `r fmt(max((gb$T2 / gb$T0)[gb$lines_tested <= 100 & gb$T0 > 0], na.rm = TRUE), 1)`; the negative value in
#' the random sparse rows is computed over the few lines the random draw happened to
#' leave uncrossed and means nothing.
#' 
#' Interpretation. Three separate statements. First, when every candidate is phenotyped
#' in a connected design, the marker kernel has little to add to what the crosses
#' already say, and a simplified SCA kernel (equal $d^2$ at every locus) may cost a
#' little (not tested separately here). Second, the two designs in which the genomic model beat the phenotypic one
#' are the two in which CDmean chose the lines, but the genomic accuracy did not rise
#' with CDmean: the gain over BLUP comes from the phenotypic arm falling, by
#' `r fmt(mean(cm_tab$blup_random[grepl("^50", cm_tab$design)] - cm_tab$blup_cdmean[grepl("^50", cm_tab$design)]), 3)` on average in
#' the 50-line designs, not from the genomic arm rising. This sweep therefore does
#' **not** show that CDmean picks better lines for a genomic model than random
#' choice does; why the phenotypic arm falls on CDmean sets was not investigated. It
#' is also confounded: the two designs are those with the fewest plots
#' (750 and 1,500, against 2,000 for the 200-line designs), and they are two designs
#' in one cached run, so "genomics gains where the field holds a fraction of the
#' candidates" is a description of these two cells, not a generalisation. Third, the
#' simulated T0 accuracies are `r fmt(min((gb$T2 / gb$T0)[gb$lines_tested <= 100 & gb$T0 > 0], na.rm = TRUE), 1)`
#' to `r fmt(max((gb$T2 / gb$T0)[gb$lines_tested <= 100 & gb$T0 > 0], na.rm = TRUE), 1)`
#' times below their own T2, a gap of
#' `r fmt(min((gb$T2 - gb$T0)[gb$lines_tested <= 100 & gb$T0 > 0], na.rm = TRUE), 2)` to
#' `r fmt(max((gb$T2 - gb$T0)[gb$lines_tested <= 100 & gb$T0 > 0], na.rm = TRUE), 2)` in
#' absolute terms, against the published gaps of 0.14 (0.91 to 0.77, @technow2014) and 0.12
#' (0.92 to 0.80, @gonzalezdieguez2021). A candidate explanation, not tested by
#' this sweep, is that the simulated candidates are unrelated doubled haploids from two
#' pools described by the sparsex study as diverged for 100 generations, with no
#' family structure to carry information from a tested line to an untested one
#' -- the condition under which genomics should transfer least, and the one of a programme
#' sampling new, unrelated material. The genomic model is the only route to a
#' prediction for lines outside the field, where the phenotypic model gives none.
#' 
#' ### Which hybrids to phenotype, and which crosses to make
#' 
#' Once prediction is in place the design question becomes which cells to observe to
#' calibrate it. CDmean [@rincent2012] beat random sampling and PEVmean for inbred
#' calibration sets because it accounts for the redundancy among related individuals;
#' for hybrids, sets built by clustering, network analysis and mating-scheme
#' considerations beat both [@guo2019], which suggests that the structure that matters
#' for a hybrid training set is bipartite. In a cross-validation on one Brazilian maize data set, reviewed in a roadmap paper,
#' pre-selecting the best 30 % of single crosses on genomic prediction with additive and
#' non-additive effects retained 85 to 95 % of the top 5 % hybrids for ear height, 75 to
#' 85 % for grain yield and 70 to 80 % for plant height [@fritscheneto2021].
#' 
#' A different question is which **within-pool crosses** to make to produce the next
#' generation of lines (not the $A \times B$ crosses of the design sections). The usefulness criterion adds the within-cross selection differential to the
#' predicted mean, and selecting on it added 0.14 genetic standard deviations of gain
#' at 1 % selected per cross [@lehermeier2017]; within-cross variance is usable for
#' ranking but the marker model's estimate was biased downward by 28 to 60 %
#' [@lian2015]. At the portfolio level, optimal cross selection chooses a *set* of
#' crosses under a constraint on diversity: 15 to 78 % more genetic gain than
#' truncation selection with four cycles per year in @gorjanc2018, and more again once within-family variance
#' enters the objective [@allier2019]. @kinghorn2011 gives an algorithm for mate
#' selection under a group mating permission matrix, reported several hundred times faster
#' than penalising solutions in the scenario he tested. Whether it, or any such
#' algorithm, makes optimising a crossing list over a 200 x 200 candidate space under
#' nursery constraints routine is this chapter's conjecture, not a result of that paper;
#' nothing in this book implements it. Nor does this book solve the assignment of
#' contributions to crosses that @gorjanc2018 call optimal cross selection (named in
#' @sec-ocs for the within-pool crosses): the contributions of @sec-ocs attach to
#' hybrids, one per $A \times B$ cross, and the design problem treated here is a
#' sampling problem for estimation, not an assignment of contributions.
#' 
#' The long-term caution is this book's own: cross selection controls inbreeding and
#' the divergence of the pools, and a design chosen once should not be held fixed
#' across cycles. @lorenzi2024 reported SCA shares that differ by trait and between two
#' selection cycles of one silage maize programme (up to 30 % in one cycle's data and up to
#' 10 % in the other, depending on the trait), so the variance structure that every design
#' calculation in this chapter takes as given may not be stationary.
#' 
#' ### What the simulation adds to the literature
#' 
#' Table: Where the simulated programme confirms, refines or contradicts the published expectation. {#tbl-mating-crosscheck}
#' 
#' | Published expectation | Simulated result | Verdict |
#' |---|---|---|
#' | Sparse factorials beat testers as training sets [@seye2020; @lorenzi2022; @fritscheneto2018] | Sparse beats tester on GCA accuracy over all candidates at every budget, by `r fmt(min(h2h$difference), 3)` to `r fmt(max(h2h$difference), 3)` (@tbl-mating-h2h) | Confirms, and extends beyond the training-set role |
#' | For hybrids of untested lines accuracy is highest at $c = 1$ (DS1 and DS2); in DS1 it is lowest at $c = 1$ for hybrids and lines already in the training set (in DS2 H1 hybrids hardly differ); the optimum $c$ depends on programme size [@melchinger2023] | Not the same experiment: the budget here is plots, the target GCA of lines in the field. Circulant GCA accuracy under BLUP rises from `r fmt(subset(bl, budget_plots == 2000 & scenario == "circulant c=2")$acc_gca_all, 2)` at $c = 2$ to `r fmt(subset(bl, budget_plots == 2000 & scenario == "circulant c=10")$acc_gca_all, 2)` at $c = 10$ at 2,000 plots; $c = 2$ leaves 1 residual df (@tbl-mating-connectivity) | Different question; not a test of the paper |
#' | Small sampling fractions suffice: 1.67 % of combinations operationally [@thomsen2026]; training sets of 2 to 13 % across maize, wheat and rice [@guo2019] | Over all designs, `r fmt(fewest_all$pct_factorial[1], 1)` % of the factorial gives `r fmt(fewest_all$accuracy[1], 2)`, `r fmt(fewest_all$pct_factorial[3], 1)` % gives `r fmt(fewest_all$accuracy[3], 2)`, `r fmt(fewest_all$pct_factorial[5], 1)` % gives `r fmt(fewest_all$accuracy[5], 2)` (@tbl-mating-fewest) | Consistent in order of magnitude; the fraction follows the accuracy target |
#' | T0 below T2 by 0.14 and 0.12 (0.91 to 0.77, @technow2014; 0.92 to 0.80, @gonzalezdieguez2021) | Genomic T2 minus T0 of `r fmt(min((gb$T2 - gb$T0)[gb$lines_tested <= 100 & gb$T0 > 0], na.rm = TRUE), 2)` to `r fmt(max((gb$T2 - gb$T0)[gb$lines_tested <= 100 & gb$T0 > 0], na.rm = TRUE), 2)` in the designs with at most 100 lines per pool (@tbl-mating-gblup) | Tension: a gap several times the published one; the cause is not tested here |
#' | Genomic kernels improve hybrid evaluation | Gain over BLUP in `r sum(gb$difference > 0)` of `r nrow(gb)` designs at 2,000 plots, both 50-line CDmean sets, and in `r n_win_cells` distinct cells over three budgets, one with z = `r fmt(min(gw$z), 2)`; genomic accuracy not distinguished between CDmean and random lines (@tbl-mating-gblup-cells, @tbl-mating-cdmean) | Weak: two designs, one run; the gain is the phenotypic arm falling |
#' | Structured vs random layouts at matched $c$ not compared | Circulant ahead at every $c$, z from `r fmt(min(mc$z), 1)` to `r fmt(max(mc$z), 1)` unpaired, the smallest at $c = 10$ (@tbl-mating-matched-c) | Addresses the gap, in one simulation |
#' | Testcross ranking differs from single-cross ranking [@burdo2021]; testers confound GCA with SCA to the testers | $k = 1$: SCA not identifiable. $k = 2, 4$: REML SCA:GCA ratio off by `r fmt(sr$ratio_of_means[sr$design == "tester k=2"], 1)` and `r fmt(sr$ratio_of_means[sr$design == "tester k=4"], 1)` % (ratio of means) or `r fmt(sr$mean_of_ratios[sr$design == "tester k=2"], 1)` and `r fmt(sr$mean_of_ratios[sr$design == "tester k=4"], 1)` % (mean of ratios); sparse designs are in the same range (@tbl-mating-sca-ratio) | Confirms the $k = 1$ limit; no tester-specific inflation is shown |
#' | No published counterpart was located by the author (no systematic search) | Least squares instead of BLUP costs `r fmt(lsb$advantage[1], 2)` at $c = 2$ and `r fmt(max(lsb$advantage[grepl("tester", lsb$design)]), 3)` at most for testers (@tbl-mating-ls-sweep); the penalty is confined to the sparsest layouts (@tbl-mating-ls-vs-tester) | The largest estimator effect in the sweep; not shown to be new |
#' 
#' ## Seed production and the cost of a crossing plan {#sec-mating-cost}
#' 
#' The crossing plan has to be made in a nursery. Treating hybrid seed production as
#' a scalar cost term -- as the published cost models do [@marulanda2016;
#' @longin2015] -- hides the constraint that actually binds sparse designs: the seed
#' quantity per cross limits how many plots and locations each hybrid can occupy.
#' 
#' ### Three cost centres
#' 
#' A mating design has three cost centres that scale differently. **Making** the
#' crosses -- pollinations, ears, nursery rows, isolation blocks -- scales with the
#' number of distinct crosses. **Testing** them scales with crosses x locations x
#' replicates. **Genotyping** scales with the number of lines, not crosses, which is
#' the structural reason genomics favours designs with many lines and few crosses
#' each. A tester design makes few crosses with much seed each; a sparse factorial
#' makes many crosses with little seed each. The two can occupy the same plots and
#' need completely different nurseries.
#' 
#' `cross_cost()` writes the accounting chain from plots back to the nursery: seed
#' needed per cross is plots x seed per plot; ears are that over seed per ear, never
#' fewer than an insurance minimum; pollinations are ears over pollination success;
#' female rows follow from the pollinations each pool-A parent carries, male rows from
#' the pollinations each pool-B parent serves, several per plant. Four designs at the
#' same 2,000 plots:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-cost
#| tbl-cap: "The cost vector of four designs at an equal budget of 2,000 plots. **Every monetary and biological level is an illustrative placeholder** (`cross_cost_par()`); the structure is the contribution, the numbers are not."
set.seed(8)
cost_plans <- list("tester k=4"       = design_tester(n, n, 4),
                   "circulant c=5"    = design_circulant(n, n, 5),
                   "circulant c=10"   = design_circulant(n, n, 10),
                   "NC II 10x10 sets" = design_nc2(n, n, 10, 10))
cost_tab <- do.call(rbind, lapply(names(cost_plans), function(nm) {
  cc <- cross_cost(design_reps(cost_plans[[nm]], 2000), n, n)
  data.frame(design = nm, t(cc[c("crosses", "plots", "pollinations",
                                 "nursery_rows", "genotyped", "total")]))
}))
cost_par <- cross_cost_par()
cost_common <- cost_par[["cost_fixed"]] + cost_par[["cost_per_line_geno"]] * cost_tab$genotyped[1]
cost_plan <- cost_tab$total - cost_common
cost_tab

#' 
#' Result. Under this accounting the four plans cost within
#' `r fmt(100 * (max(cost_tab$total) / min(cost_tab$total) - 1), 1)` % of each other in total,
#' and within `r fmt(100 * (max(cost_plan) / min(cost_plan) - 1), 1)` % once the cost common to
#' all four (the fixed cost and the genotyping of `r cost_tab$genotyped[1]` lines,
#' `r format(cost_common, big.mark = ",")`) is removed.
#' The cheapest is the circulant design with five crosses per line, because it makes
#' the fewest distinct crosses (`r cost_tab$crosses[2]`) and spends the rest of the
#' plots on replicates, which need more seed per cross but no more pollinations: the
#' two-ear insurance minimum already produces enough seed for two plots. The ten-cross
#' designs make twice as many crosses and need
#' `r cost_tab$pollinations[3]` pollinations against `r cost_tab$pollinations[2]`.
#' 
#' Interpretation. The tester is **not** cheaper here, and that is a property of the
#' model, not of testers. `cross_cost()` charges every cross as hand pollinations, so
#' it cannot credit the bulk production -- an isolation block, a male-sterile female
#' -- that makes a tester cross cheap in practice, and the tester's 1,584 crosses each
#' pay the insurance minimum. That missing term is gap 1 of @sec-mating-open, and it is
#' the term a real programme must add before comparing designs on cost. The other term
#' is seed per cross as a cap on replication. At the placeholder levels one ear gives
#' `r cost_par[["seed_per_ear"]]` kernels against `r cost_par[["seed_per_plot"]]` per plot, that is
#' `r fmt(cost_par[["seed_per_ear"]] / cost_par[["seed_per_plot"]], 1)` plots per ear, and the
#' two-ear minimum
#' `r fmt(cost_par[["min_ears_per_cross"]] * cost_par[["seed_per_ear"]] / cost_par[["seed_per_plot"]], 1)`;
#' so seed caps replication only above about 8 plots per cross, which no design here
#' approaches (the sweep caps replication at three). The constraint would bind where seed per
#' ear is small against seed per plot; at these levels it does not. Operational
#' sparse designs such as @thomsen2026 are unreplicated; the cost model does not
#' explain why.
#' 
#' ::: {.callout-warning}
#' ## The cost levels are placeholders
#' 
#' Every monetary and biological level in `cross_cost_par()` -- seed per plot, seed
#' per ear, pollination success, pollen uses per male plant, the price of a plot, a
#' row, a pollination and a genotype -- is an order of magnitude for a public maize
#' programme, not a costed figure. The *structure* -- which quantity multiplies which,
#' which capacity binds -- is what this section offers. Re-parameterise before any
#' number below means anything for a real programme.
#' :::
#' 
#' ### Budget-constrained optimisation
#' 
#' The cached optimiser searched over lines tested per pool, design family, $k$ or
#' $c$, plots per cross and whether to genotype every candidate, subject to field,
#' nursery and money constraints, and maximised expected response
#' $R = i\,\rho\,\sigma_g$ -- not accuracy. That distinction is the trade-off:
#' raising $c$ raises $\rho$ but, at fixed budget, lowers the number of lines tested
#' and with it the selection intensity $i$. It scores $\rho$ with the least-squares
#' closed form of @tbl-mating-quantities at the design's $c$, whatever the family.
#' @tbl-mating-formula-sparse shows that for sparse designs that score is above the
#' cached accuracy of both estimators, so it is **optimistic** for them, not
#' conservative.
#' 
#' ![Left: expected response per unit cost by design. Right: the best feasible configuration at each total budget. Cached from the `sparsex` optimiser; cost levels are placeholders.](figs/mating_gain_per_cost.png){fig-alt="Left: expected response per unit cost by design" #fig-mating-gain-cost width=100%}
#' 
#' ![The optimiser's budget frontier. Cached from the `sparsex` optimiser.](figs/mating_frontier.png){fig-alt="The optimiser's budget frontier" #fig-mating-frontier width=100%}
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-frontier
#| tbl-cap: "The best feasible configuration at each total budget. Response in genetic units of GCA, summed over the two pools. Placeholder cost levels."
ff <- subset(front, feasible)
# Tester and sparse configurations with the same lines per pool, c or k, plots per
# cross and genotyping: the optimiser's response must be the same function of them.
cfg <- c("n_test", "c_or_k", "reps", "genotype_all")
tt <- unique(subset(front, design == "tester")[, c(cfg, "resp", "n_crosses", "cost_total")])
ss <- unique(subset(front, design == "sparse")[, c(cfg, "resp", "n_crosses", "cost_total")])
mm <- merge(tt, ss, by = cfg, suffixes = c("_t", "_s"))
stopifnot(max(abs(mm$resp_t - mm$resp_s)) < 1e-9, all(mm$cost_total_t >= mm$cost_total_s))
best <- do.call(rbind, lapply(split(ff, ff$budget), function(d) d[which.max(d$resp), ]))
best <- best[, c("budget", "design", "n_test", "c_or_k", "reps", "n_crosses",
                 "n_plots", "cost_total", "resp", "resp_per_1000")]
rownames(best) <- NULL
# Reading of the table used in the text below.
stopifnot(nrow(best) == 6, max(front$n_test) == 200, all(best$n_test[-1] == 200),
          all(best$c_or_k[2:4] == 3), all(best$reps[2:4] == 2:4),
          all(best$n_plots[5:6] == 3000), isTRUE(all.equal(best$resp[5], best$resp[6])),
          best$n_test[1] < 200)
fmt(best, 3)

#' 
#' Result. A sparse factorial is on the frontier at every budget, and no tester
#' configuration is optimal anywhere in the grid. The response is, however, the same for a
#' tester and a sparse configuration with the same lines per pool, $c$ or $k$, plots per
#' cross and genotyping in all `r nrow(mm)` such pairs in the grid (largest difference
#' `r format(max(abs(mm$resp_t - mm$resp_s)), digits = 1)`), while the tester plan makes
#' `r fmt(median(mm$n_crosses_t / mm$n_crosses_s), 1)` times as many crosses (median) and
#' costs more. The optimum at
#' `r format(best$budget[1], big.mark = ",", scientific = FALSE)` is `r best$n_test[1]` lines per pool at $c = `r best$c_or_k[1]`$ and one plot
#' per cross. From `r format(best$budget[2], big.mark = ",", scientific = FALSE)` on it is 200 lines per pool, the largest value in the
#' grid (the grid searched 50, 100, 150 and 200). From `r format(best$budget[2], big.mark = ",", scientific = FALSE)` to
#' `r format(best$budget[4], big.mark = ",", scientific = FALSE)` the optimum keeps $c = 3$ and raises plots per cross from
#' `r best$reps[2]` to `r best$reps[3]` to `r best$reps[4]`; at `r format(best$budget[5], big.mark = ",", scientific = FALSE)` and
#' `r format(best$budget[6], big.mark = ",", scientific = FALSE)` the 3,000-plot field cap binds, the optimum is identical
#' ($c = `r best$c_or_k[5]`$, `r best$reps[5]` plots per cross, response
#' `r fmt(best$resp[5], 3)`, cost `r format(best$cost_total[5], big.mark = ",", scientific = FALSE)`), and the extra money buys nothing.
#' Response per 1,000 currency units falls from `r fmt(best$resp_per_1000[1], 3)` to
#' `r fmt(best$resp_per_1000[nrow(best)], 3)`. Interpretation. Within this grid, once the
#' candidate set is at its maximum of 200 lines, additional money is spent on plots per cross
#' until the field cap binds and then buys nothing. Whether more money would then be worth a
#' larger candidate set cannot be read from the table, because the grid stops at 200 lines,
#' the size of the running example's pools. The preference for sparse designs is a
#' statement about the cost model, in which a reciprocal tester plan needs about twice the
#' crosses of a sparse plan with the same $c$, and which cannot credit bulk tester seed
#' (above); the optimiser sees no accuracy difference between the families, because it
#' scores both with the same least-squares formula. "No tester is optimal" is therefore
#' conditional on that cost model and on that formula, not a result about accuracy, and the
#' ordering of $c$ along the frontier ($c = 3$ to 5) rests on a score that is optimistic
#' for sparse designs: the sweep, not the optimiser, is the evidence on $c$.
#' 
#' The published allocation results come from other designs and scales and are not tested by this grid; they are cited as context, not as confirmation. A training population of 500
#' at one replicate was only 4 % more accurate than 125 at four, and a second
#' replicate added 0.09 correlation points [@lorenz2013]; selection gain levels off
#' quickly with budget, so additional money is better spent on more populations than on
#' deeper testing [@riedelsheimer2013]; and the optimum number of testers, locations and
#' stages is a joint decision [@longin2006b; @longin2006c; @mi2014; @marulanda2016].
#' 
#' ## A decision framework {#sec-mating-decision}
#' 
#' The chapter collapses into a procedure a breeder can apply in a planning meeting.
#' 
## -----------------------------------------------------------------------------
#| label: fig-mating-decision
#| echo: false
#| fig-width: 9
#| fig-height: 5.2
#| fig-cap: "A decision procedure for the crossing plan of a two-pool programme. Each question is answered by a section of this chapter."
#| fig-alt: "A decision procedure for the crossing plan of a two-pool programme"
op <- par(mar = c(0, 0, 0, 0)); plot.new(); plot.window(c(0, 100), c(0, 62))
node <- function(x, y, lab, fill, w = 26, h = 8) {
  rect(x - w / 2, y - h / 2, x + w / 2, y + h / 2, col = fill, border = "grey40")
  text(x, y, lab, cex = 0.62)
}
arr <- function(x0, y0, x1, y1, lab = NULL) {
  arrows(x0, y0, x1, y1, length = 0.06, col = "grey30", lwd = 1.3)
  if (!is.null(lab)) text((x0 + x1) / 2 + 2, (y0 + y1) / 2, lab, cex = 0.55, col = "grey25")
}
q <- "#d1e5f0"; a <- "#b8e0b8"; w <- "#fddbc7"
node(30, 56, "1. Can you fit a mixed model?\n(BLUP, known or REML components)", q)
node(78, 56, "Avoid c <= 3 layouts; c = 10 or\nNC II still beat testers under LS", w)
arr(43, 56, 65, 56, "no")
node(30, 43, "2. Can the field hold c >= 2\ncrosses for every candidate?", q)
arr(30, 52, 30, 47, "yes")
node(78, 43, "4. Choose WHICH lines go in;\nGBLUP for the lines left out", a)
arr(43, 43, 65, 43, "no")
node(30, 30, "3. Choose c from the objective:\nc = 2 rank; c >= 3 estimate SCA", a)
arr(30, 39, 30, 34, "yes")
node(30, 17, "Build it connected: circulant,\nnot random. Check rank = n' - components", a)
arr(30, 26, 30, 21)
node(78, 17, "5. Check the nursery: ears, rows,\nisolation -- not just plots", w)
arr(43, 17, 65, 17)
arr(78, 39, 78, 21)
node(78, 4.5, "6. Re-optimise every cycle:\nthe SCA share may move", q, h = 6.5)
arr(78, 13, 78, 7.8)
par(op)

#' 
#' 1. **Can you fit a mixed model?** If not, avoid the sparsest layouts ($c \le 3$
#'    per line, circulant $c = 5$): under least squares at 2,000 plots they are
#'    worse than the best tester (@tbl-mating-ls-vs-tester). Designs with $c = 10$ or
#'    NC II sets exceeded that tester in the cached sweep (the circulant $c = 10$ row is
#'    not reproduced in-repo), and a tester loses little to least squares
#'    (@tbl-mating-ls-sweep); if the field holds only two or three crosses per line,
#'    a tester with $k$ from the curve of @fig-mating-testers is the safe choice.
#'    Markers are not needed at this step; they enter at step 4.
#' 2. **How many candidates must be ranked, and can the field hold a cross for each?**
#'    If it can hold $c \ge 2$ crosses per candidate, prefer a connected sparse
#'    factorial (@tbl-mating-h2h).
#' 3. **Choose $c$ from the objective.** $c = 2$ ranks lines; $c \ge 3$ is required
#'    before any statement about SCA variance. Do not take $c$ from the optimiser of
#'    @tbl-mating-frontier, whose score is optimistic for sparse designs
#'    (@tbl-mating-formula-sparse); read it from the accuracy of the sweep
#'    (@fig-mating-acc-c). Build the layout, do not sample it,
#'    and confirm with `design_diagnostics()` that it is one component.
#' 4. **Choose the line set, not just the crosses.** When the field cannot hold every
#'    candidate, GBLUP is the only route to the lines left out
#'    (@tbl-mating-gblup). Which lines to field is a separate choice; in this sweep
#'    CDmean sets did not raise the genomic accuracy above random sets
#'    (@tbl-mating-cdmean), so the decision rests on other grounds than the sweep.
#' 5. **Check the nursery before committing:** ears, rows and isolation blocks, not just
#'    plots (@tbl-mating-cost).
#' 6. **Re-estimate every cycle.** Published SCA shares differ between cycles
#'    [@lorenzi2024], and the pools drift (@sec-mating-connects).
#' 
#' ## Open problems {#sec-mating-open}
#' 
#' Five gaps remain, each defined by the evidence that would close it.
#' 
#' 1. **Seed production as an explicit constraint.** None of the cost studies cited
#'    here [@marulanda2016; @longin2015] models seed yield per pollination, isolation
#'    capacity or seed per plot inside the optimisation of a mating design; they carry
#'    hybrid-seed production as a scalar (no systematic search beyond them was made). `cross_cost()` gives the structure; the
#'    levels are missing.
#' 2. **Joint sparsity in crosses and environments.** The cross-sparsity literature
#'    [@lorenzi2022; @melchinger2023] holds the environment design fixed; the
#'    environment-sparsity literature [@jarquin2020; @atanda2022; @montesinoslopez2023]
#'    works with line or testcross entries. @thomsen2026 is the closest to a joint
#'    treatment, and it is observational. @sec-joint takes this gap up.
#' 3. **Connectivity reported, structured layouts compared.** The tools are seventy
#'    years old [@weeks1964; @fernando1983]; design papers rarely report the
#'    connectivity of the layouts they use. @tbl-mating-matched-c closes the matched-$c$
#'    comparison in simulation only.
#' 4. **Tropical maize.** Under-represented relative to its share of breeding effort;
#'    @fritscheneto2021 and @chaingeni2025 are the main exceptions.
#' 5. **Multi-cycle validation.** The long-term consequences of genomics-driven cross
#'    selection for pool divergence are modelled [@gorjanc2018; @allier2019;
#'    @melchinger2023b] but not validated over real cycles, and the SCA shares that differ
#'    between cycles in @lorenzi2024 are the warning case. The design of the crossing
#'    plan across cycles is also not treated in @sec-cycles, which evaluates every
#'    $A \times B$ hybrid in each cycle and has no crossing design.
#' 
#' ## Reproducibility and assumptions {#sec-mating-reproduce}
#' 
#' **What runs live.** Every table and figure above built from `design_*()`,
#' `design_diagnostics()`, `fit_gca()`, `cross_cost()` or `gca_accuracy_theory()` is
#' computed at render, from base R, at the full 200 x 200 scale. The package's tests
#' (`tests/testthat/test-mating.R`) assert the rank rule for every design family,
#' the NC II estimability result, the $k = 1$ saturation, the Sprague-Tatum error
#' variance by Monte Carlo, and that BLUP converges to least squares as the GCA
#' variance grows.
#' 
#' **What is cached.** The 24-design x 3-budget sweep, the REML variance components,
#' the genomic results and the optimiser frontier come from the external `sparsex`
#' study and are not reproducible from this repository. Its validation file records 37
#' checks, all marked PASS against the study's own tolerances. The observed maxima are:
#' closed form against AlphaSimR's genotypic values
#' `r format(max(val$observed[startsWith(val$check, "V1")]), digits = 2)` (absolute);
#' sampling-variance and accuracy expressions (V3, V4)
#' `r fmt(100 * max(abs(val$rel_error[grepl("^V(3|4)", val$check)]), na.rm = TRUE), 2)` % against tolerances of
#' `r paste(sort(unique(100 * val$tol[grepl("^V(3|4)", val$check)])), collapse = ", ")` %; REML
#' recovery of the variance components (V5)
#' `r fmt(100 * max(abs(val$rel_error[startsWith(val$check, "V5")])), 1)` % against 25 %; in-house
#' REML against `sommer` (V6) `r format(max(abs(val$rel_error[startsWith(val$check, "V6")])), digits = 2)`
#' relative error; and the rank rule for every family. The phenotypic core of that sweep
#' is re-run in-repo by `Rscript book/scripts/regenerate.R mating` (seed 4242, 30
#' replicates per cell, a new factorial and a new design draw in each replicate), with the
#' package's i.i.d. model and the variance components held at their true values (typed to
#' three decimals in the script; the chapter reads them from the validation file at full
#' precision, a difference far below the standard errors). Both are compared at 2,000
#' plots, on each cell's mean and standard error:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-mating-reproduce
#| tbl-cap: "The in-repo reproduction (`mating_core_sweep.csv`: i.i.d. model, known components, 30 replicates) against the cached `sparsex` sweep (AlphaSimR founders, REML components), at 2,000 plots. `z` is (in-repo minus cached) over $\\sqrt{se^2_{in} + se^2_{ca}}$; agreement is called $|z| < 3$."
cr <- subset(core, budget_plots == 2000)
ca <- subset(sm, budget_plots == 2000 & model %in% c("LS", "BLUP"))
ca$method <- tolower(ca$model)
cmp <- merge(cr, ca[, c("scenario", "method", "acc_gca_all", "se_acc_gca_all")],
             by = c("scenario", "method"))
cmp$z <- (cmp$acc_mean - cmp$acc_gca_all) / sqrt(cmp$acc_se^2 + cmp$se_acc_gca_all^2)
rep_tab <- reshape(data.frame(design = cmp$scenario, method = cmp$method,
                              inrepo = cmp$acc_mean, cached = cmp$acc_gca_all, z = cmp$z),
                   idvar = "design", timevar = "method", direction = "wide")
rep_tab <- rep_tab[order(rep_tab$inrepo.blup), ]
rownames(rep_tab) <- NULL
cmp_out <- cmp[abs(cmp$z) >= 3, ]
fmt(rep_tab, 3)

#' 
#' Result. Of the `r nrow(cmp)` in-repo against cached comparisons, `r sum(abs(cmp$z) < 3)` have
#' $|z| < 3$ and `r nrow(cmp_out)` do not:
#' `r paste0(cmp_out$scenario, " by ", cmp_out$method, " (", fmt(cmp_out$acc_mean, 3), " in-repo against ", fmt(cmp_out$acc_gca_all, 3), ", z = ", fmt(cmp_out$z, 1), ")", collapse = "; ")`.
#' All the BLUP comparisons are within $|z| =$
#' `r fmt(max(abs(cmp$z[cmp$method == "blup"])), 1)`. The qualitative claims of the chapter --
#' sparse ahead of tester at equal plots, circulant ahead of random at low $c$, a
#' least-squares penalty that is large at low $c$ and negligible for testers -- hold in both.
#' Interpretation. The two sweeps therefore do not agree to sampling error in every cell, and
#' the disagreement is largest in least squares at $c = 10$ (NC II, the other exception,
#' also has one plot per cross), where every cross has the same weight, so the least-squares estimate does not depend on
#' the variance components at all: a difference in how the components were estimated
#' (REML against known values) cannot explain it. The remaining differences between the two
#' runs -- the external study's coalescent founders, linkage and finite QTL (described
#' by the study; the validation file's V2 note mentions linkage disequilibrium among QTL),
#' and a realised factorial against an i.i.d. draw -- are candidate explanations, none
#' tested here, because the external run cannot be repeated from this repository.
#' 
#' **Assumptions, stated in the chapter rather than a footnote.**
#' 
#' - **Thirty replicates per cell.** Every row of the cached sweep has `n_rep` =
#'   `r unique(sm$n_rep)`. Whether a cached replicate is a new founder set or new
#'   phenotypes on one founder set is not recorded in this repository, and the z-scores of
#'   this chapter are unpaired (@tbl-mating-h2h, @tbl-mating-matched-c, @tbl-mating-gblup);
#'   they are conservative if arms share the replicate's truth. The standard error of a cell
#'   mean ranges from `r fmt(min(sm$se_acc_gca_all), 4)` to `r fmt(max(sm$se_acc_gca_all), 3)`
#'   (median `r fmt(median(sm$se_acc_gca_all), 4)`), so a fixed width in correlation points is not a
#'   threshold: this chapter calls a difference resolved when its unpaired z exceeds 3, and
#'   says where one does not. The single cached run is the unit; none of the cross-budget or
#'   cross-design results is replicated across founder sets.
#' - **One trait, one marker density** (1,000 markers, as described by the `sparsex`
#'   study; not checkable here), no epistasis, no selection during line development, no
#'   spatial trend, no missing plots.
#' - **Genotype x location is folded into plot error.** An extra location and an extra
#'   replicate are treated as equivalent, which is exact under that assumption and
#'   optimistic when G x L variance is large. @sec-sparse did not compare a location
#'   with a replicate. With G x L in the model, its result 2 (@sec-sparse-results)
#'   held two plots per hybrid fixed and found that spreading them over more trial
#'   locations, 2 to 10, raised accuracy: once G x L exists, the number of
#'   environments a trial samples matters, which this assumption cannot represent.
#' - **Unrelated candidate panel.** The DH lines come from two pools described by the
#'   `sparsex` study as diverged for 100 generations, with no family structure; this is a
#'   candidate reason for the low genomic T0 accuracy, not a tested one.
#' - **Placeholder costs.** Every level in `cross_cost_par()`.
#' - **Integer budgets.** Replication is `floor(plots / crosses)` capped at three, with
#'   the remainder spread at random, so "budget" is not a continuous axis: a one-tester
#'   design with 399 crosses stops at 1,197 plots.
#' 
#' ## Where this connects {#sec-mating-connects}
#' 
#' This chapter settled which crosses to make with the field held fixed: a
#' connected sparse factorial, analysed by BLUP, with $c$ chosen by the objective
#' (from the sweep, not from the optimiser, @sec-mating-cost). It left the field
#' itself -- how many locations each cross is planted in, and which -- to @sec-sparse,
#' and the trade between crosses and locations under one budget to @sec-joint.
#' 
#' **What the Optimisation part receives.** @sec-ocs, @sec-combinatorial and
#' @sec-advanced take the values of the whole $A \times B$ factorial as known. A sparse
#' plan fields `r fmt(100 * min(bl$n_crosses[bl$family %in% c("tester", sparse_fam, "nc2")]) / n^2, 1)` to
#' `r fmt(100 * max(bl$n_crosses[bl$family %in% c("tester", sparse_fam, "nc2")]) / n^2, 1)` % of it,
#' so the rest are predictions, with the accuracies measured here (all-lines GCA accuracy
#' from `r fmt(min(bl$acc_gca_all[bl$n_linesA_tested == 200]), 2)` to
#' `r fmt(max(bl$acc_gca_all[bl$n_linesA_tested == 200]), 2)` across the 200-line designs at the
#' three budgets; genomic accuracy for hybrids of untested lines, T0, about
#' `r fmt(mean(gb$T0[grepl("^50 lines.*cdmean", gb$design)]), 2)`). Which values a sparse plan
#' passes on for the unfielded cells -- the GCA sum without SCA, or a genomic prediction --
#' is a choice this chapter does not make, and none of the selection problems of that part
#' accounts for the prediction error; @sec-genomic-prediction and the Finding 5 of @sec-choosing-error
#' are where the two meet.
#' 
#' **A hypothesis, not a result: the diversity of the line set.** The crossing plan decides
#' which lines are seen. A design that fields 50 lines per pool selected by CDmean ranks
#' those 50, so the next cycle's parents may in practice come from them, and a loss of gene
#' diversity of the kind that @sec-stages tracks across the pipeline would then start at the
#' choice of lines (line selection, stage S3 of @tbl-hp-stages, which @sec-stages already
#' measures), not at the later selection of hybrids. No diversity metric of a design --
#' $GD$, $\theta$, alleles retained -- is computed in this chapter, so this is the book's
#' subject offered as a question about nursery plans, not a finding of the sweep. A
#' sparse factorial that crosses every candidate keeps every candidate line in the field,
#' which is a statement about which lines are tested, not about the diversity of the
#' hybrids fielded; the latter depends on which cells are filled, and the identities of
#' @sec-hp-popgen that tie it to $GD_T + GD_{BS}$ are stated for the complete factorial.
#' 
#' @sec-heterosis-gca-sca is where the dominance part of the GCA and SCA used here was
#' derived from allele frequencies, and @sec-heterosis-step6 is the finite-tester version of
#' @fig-mating-testers. @sec-heterosis reports, under neutral divergence and dominance only, a
#' share of SCA in the *heterosis* variance that falls as the pools diverge -- a
#' different statistic from the SCA:GCA ratio of this chapter, defined above, and under
#' narrower assumptions -- so the direction suggests that the number of testers and the
#' crosses per line a programme needs are not constants of the crop, without giving
#' their value. @sec-genomic-prediction fits an additive GBLUP on a trait with no SCA; it
#' does not fit the pool-specific or SCA kernels, and the genomic accuracies of this chapter
#' come from the cached `sparsex` study (@sec-mating-reproduce), not from that chapter.
#' @sec-cycles evaluates every $A \times B$ hybrid in each cycle and has no crossing
#' design: how a design chosen once behaves while the pools drift is not tested there, and
#' not in this book. The contributions of @sec-ocs attach to hybrids; the literature on
#' optimal cross selection [@gorjanc2018] concerns within-pool crosses, and nothing in this
#' book implements it.
