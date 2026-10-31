#' # Notation and glossary {#sec-notation}
#' 
# 90-notation -- standalone script of the chapter 90-notation.qmd
# Book: https://ederdbs.github.io/QG/90-notation.html
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

#' 
#' ## Symbols
#' 
#' The population-genetic quantities below are introduced together in
#' @sec-hp-popgen; the tables give each one's symbol and the function that
#' computes it.
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$N$", "$n$, $n_{sel}$", "$L$", "$m$", "$x_{ik}$",
             "$\\mathbf{X}$", "$\\mathbf{M}^H$", "$\\mathbf{M}^L$", "$\\mathbf{G}^L$",
             "$p_k$, $\\bar p_k$", "$p_{0,k}$"),
  Meaning = c("candidate hybrids in the pool",
              "hybrids selected",
              "parent lines",
              "markers",
              "within-individual reference-allele frequency of individual i at marker k, in 0/0.5/1",
              "hybrid marker matrix, N x m",
              "hybrid dosage matrix, N x m, 0/1/2; $\\mathbf{X} = \\mathbf{M}^H/2$",
              "line genotype matrix, L x m, reference-allele dosage coded 0/2",
              "line genotype matrix, L x m, coded 0/1; $\\mathbf{G}^L = \\mathbf{M}^L/2$",
              "allele frequency; the bar denotes a group mean",
              "**frozen** candidate-pool allele frequency: the base"),
  `In the code` = c("`ctx$N`", "`n_sel`", "`ctx$n_lines`", "`ctx$m`", "`ctx$X[i, k]`",
                    "`ctx$X`", "-", "`simulate_lines()`", "`ctx$GL`, `simulate_pools()$GL`", "-", "`ctx$p0`"),
  check.names = FALSE))

#' 
#' ### Matrices
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$\\mathbf{f}$", "$\\mathbf{f}^L$", "$\\mathbf{G}$", "$\\mathbf{A}$",
             "$\\mathbf{G}_{0.5}$", "$\\mathbf{Z}$", "$\\mathbf{Z}_h$", "$\\mathbf{J}$",
             "$\\mathbf{B}$"),
  Meaning = c("molecular coancestry of the **hybrids**, N x N, in [0, 1]",
              "molecular coancestry **between lines**, L x L",
              "VanRaden genomic relationship, centered -- prediction only",
              "pedigree relationship",
              "VanRaden with the centering frequency fixed at 0.5",
              "centered dosage $\\mathbf{M}^H - \\mathbf{1}\\,2\\mathbf{p}'$, N x m",
              "hybrid marker matrix centred at 0.5, $\\mathbf{X} - \\tfrac12\\mathbf{J}_{N \\times m}$, N x m",
              "matrix of ones $\\mathbf{1}\\mathbf{1}'$, N x N; $\\mathbf{J}_{r \\times c}$ when rectangular",
              "parent-usage incidence, N x L: a 1 in the two columns of each hybrid's parents; $\\mathbf{X} = \\tfrac12\\mathbf{B}\\mathbf{G}^L$"),
  Note = c("the diversity kernel; never centered",
           "the sufficient statistic in disguise -- see the collapse",
           "sum of all elements is exactly 0; unusable for diversity",
           "expectation of IBD, no markers",
           "$4\\mathbf{f} - 2\\mathbf{J}$: an affine function of f, not f; orders selections as f does only when $\\mathbf{1}'\\mathbf{c} = 1$",
           "builds $\\mathbf{G}$; also the marker design matrix of $\\mathbf{u} = \\mathbf{Z}\\boldsymbol\\beta$ (genomic prediction); not the subgroup indicator $\\mathbf{Z}$ of joint allocation",
           "$\\mathbf{G}_{0.5} = 8\\mathbf{Z}_h\\mathbf{Z}_h'/m$ (@sec-era-step7)",
           "-",
           "rank bounds that of $\\mathbf{f}$ (@eq-era-rank); not the field budget $B$"),
  check.names = FALSE))

#' 
#' ### Coancestry and diversity
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$\\theta_S$", "$GD$, $H_e$", "$N_s$", "$N_{e,\\text{par}}$",
             "$f_{ii}$", "$s_i$", "$\\tilde x$", "$\\bar x$",
             "$H_o$", "$n_{gam}$", "$\\Delta F$", "$N_e$",
             "$\\bar f_d$, $\\bar f_o$", "$F_{(ab)}$"),
  Definition = c("$n^{-2}\\sum_i\\sum_j f_{ij}$, diagonal **included**; the $\\bar f$ of the partition below, with census weights (@sec-subdivided)",
                 "$1 - \\theta$; these are the same quantity",
                 "$1/(2\\theta)$",
                 "$1/\\sum_i p_i^2$ over parent-line usage",
                 "coancestry within subpopulation i; $1 - f_{ii} = H_{e,i}$. For a single individual, the diagonal of $\\mathbf{f}$, which is $s_i$",
                 "self-coancestry; $F_i = 2s_i - 1$; for a single individual $s_i = f_{ii}$",
                 "weighted mean **within** subpopulations",
                 "mean over **all pairs**, between-subpopulation pairs included",
                 "observed heterozygosity: fraction of heterozygous loci, averaged over the individuals of the set; 0 for inbred lines, $GD_T + GD_{BS}$ over the full hybrid factorial (@sec-hp-popgen)",
                 "allele copies sampled per generation under drift (@eq-hp-drift)",
                 "per-generation rate of inbreeding, $1/n_{gam}$ (@eq-hp-drift)",
                 "effective size, $1/(2\\Delta F)$ (@eq-hp-drift); not the asymptotic metapopulation $N_e$ of the subdivided table below",
                 "mean of the diagonal (self-coancestries) and mean of the off-diagonal elements of $\\mathbf{f}$ over a set; $\\theta_S = \\bar f_d/n + (n-1)\\bar f_o/n$ (@sec-catalogue)",
                 "molecular inbreeding coefficient of the single cross $a \\times b$, the fraction of markers at which it is homozygous; equals $f^L_{ab}$ for inbred parents (@sec-hp-popgen)"),
  `Function` = c("`theta_group()`, `fast_theta()`", "`gene_diversity()`, `he_nei()`",
                 "`status_number()`", "`ne_parents()`", "`ct_partition()`",
                 "`ct_partition()`", "-", "-",
                 "-", "-", "-", "-", "-", "`rowMeans(ctx$X != 0.5)`"),
  check.names = FALSE))

#' 
#' Always $\bar f \le \tilde f \le \tilde s$. The differences between those three
#' numbers *are* the partition of diversity.
#' 
#' ### The partition
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Component = c("$GD_T$", "$GD_{WI}$", "$GD_{BI}$", "$GD_{WS}$", "$GD_{BS}$"),
  Definition = c("$1 - \\bar f$", "$1 - \\tilde s$", "$\\tilde s - \\tilde f$",
                 "$1 - \\tilde f$", "$\\tilde f - \\bar f$"),
  Meaning = c("total", "within individuals", "between individuals, within subpopulation",
              "within subpopulations", "between subpopulations"),
  `In hybrid breeding` = c("the pool's diversity",
                           "0 for inbred lines; use `GD_WI_hyb` for the F1s",
                           "segregating variation available to selection",
                           "within-pool diversity; equals $GD_{BI}$ with inbred lines, the term recurrent selection erodes (@tbl-keystone)",
                           "the heterosis engine -- **maintain**, do not maximise (@sec-heterosis)"),
  check.names = FALSE))

#' 
#' with $GD_T = GD_{WI} + GD_{BI} + GD_{BS}$ and $F_{ST} = GD_{BS}/GD_T$.
#' 
## -----------------------------------------------------------------------------
#| label: notation-fst-parameter
#| include: false
fst_bn <- 0.15
sim_bn <- simulate_pools(n_A = book_cfg$n_pool_A, n_B = book_cfg$n_pool_B,
                         m = book_cfg$m, fst = fst_bn, seed = 1)
fst_stat <- ct_partition(2 * sim_bn$GL, sim_bn$pool)[["global"]][["F_ST"]]
# Unbounded pools: per-locus GD_BS = (pA - pB)^2 / 2 and GD_T = 2 pbar (1 - pbar)
set.seed(1)
pa <- runif(2e5, 0.05, 0.95)
sh <- (1 - fst_bn) / fst_bn
pA <- rbeta(2e5, pa * sh, (1 - pa) * sh)
pB <- rbeta(2e5, pa * sh, (1 - pa) * sh)
pm <- (pA + pB) / 2
fst_inf <- mean((pA - pB)^2 / 2) / mean(2 * pm * (1 - pm))
stopifnot(abs(fst_inf - fst_bn / (2 - fst_bn)) < 0.005)
# Same statistic with self-coancestry dropped: the finite-pool excess disappears
f_off <- sim_bn$fL; diag(f_off) <- NA
in_A  <- sim_bn$pool == "A"
f_til <- mean(in_A) * mean(f_off[in_A, in_A], na.rm = TRUE) +
         mean(!in_A) * mean(f_off[!in_A, !in_A], na.rm = TRUE)
f_bar <- mean(f_off, na.rm = TRUE)
fst_off <- (f_til - f_bar) / (1 - f_bar)
stopifnot(fst_stat > fst_inf, abs(fst_off - fst_bn / (2 - fst_bn)) < 0.005)

#' 
#' That $F_{ST}$ is a statistic computed on a set of genotypes. The Balding-Nichols
#' parameter of the simulations, `fst` in the code and written $F_{BN}$ here, is a
#' different quantity: it is the variance of a pool's allele frequency around the
#' ancestral one, in units of $p(1-p)$ (see Terms). @sec-heterosis, @sec-choosing, @sec-stages, @sec-plant-literature,
#' @sec-case-study and @sec-verification write that
#' parameter as $F_{ST}$ wherever it is a simulation setting or a Balding-Nichols
#' expectation; read it there as $F_{BN}$. With two pools of unbounded size the expected
#' $GD_{BS}$ per locus is $F_{BN}\,p(1-p)$ and the expected $GD_T$ is
#' $(2 - F_{BN})\,p(1-p)$, so the statistic estimates approximately
#' $F_{BN}/(2 - F_{BN})$ (a ratio of expectations), not $F_{BN}$: at
#' $F_{BN}$ = `r fst_bn` that is `r fmt(fst_bn / (2 - fst_bn), 3)`, against
#' `r fmt(fst_inf, 3)` computed from simulated frequencies. On finite pools the
#' statistic is larger again, because $\tilde f$ includes each line's
#' self-coancestry: on the `r book_cfg$n_pool_A` + `r book_cfg$n_pool_B` lines that
#' `simulate_pools()` draws at `fst` = `r fst_bn` (seed 1), the $F_{ST}$ of
#' @sec-subdivided is `r fmt(fst_stat, 3)`, and `r fmt(fst_off, 3)` once the
#' diagonal is dropped from both $\tilde f$ and $\bar f$.
#' 
#' ### Subdivided population
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$n$, $N_i$, $N_T$", "$p_{k,l,i}$", "$F_i$", "$H_{o,i}$",
             "$\\alpha_i$", "$G_i$, $G$", "$D_{ij}$, $\\bar D$", "$\\bar d_{ij}$",
             "$N_e$", "$V_W$, $V_B$"),
  Meaning = c("subpopulations; size of subpopulation i; $\\sum_i N_i$ -- **not** the hybrids selected and candidates above",
              "frequency of allele k within individual l of subpopulation i; for the reference allele of a biallelic marker, the within-individual frequency $x$ above (whose second index is a marker, not an allele)",
              "molecular inbreeding, $2s_i - 1$, against a base with all alleles distinct",
              "observed heterozygosity of subpopulation i; $2(1 - s_i)$",
              "$(F_i - f_{ii})/(1 - f_{ii})$, the $F_{IS}$ analogue -- **not** the diversity-loss constraint $\\alpha$",
              "$(s_i - f_{ii})/(1 - f_{ii}) = (1 + \\alpha_i)/2$; $G$ the same with $\\tilde s$, $\\tilde f$ -- **not** a relationship matrix $\\mathbf{G}$",
              "Nei's minimum distance $(f_{ii} + f_{jj})/2 - f_{ij}$, an element of $\\mathbf{D}$; $\\bar D = \\tilde f - \\bar f$",
              "mean distance between individuals of i and j, $(s_i + s_j)/2 - f_{ij}$; $\\bar d_{ii} \\neq 0$",
              "asymptotic effective size of the metapopulation",
              "variances of long-term contributions within / between subpopulations"),
  `Function` = c("`ct_partition()$by_subpop$N`", "inside `ct_partition()`",
                 "`ct_partition()$by_subpop$F_i`", "-",
                 "`ct_partition()$by_subpop$alpha_i`", "`ct_partition()$by_subpop$G_i`",
                 "`ct_partition()$D_nei`", "-", "-", "-"),
  check.names = FALSE))

#' 
#' These are the symbols of @sec-subdivided, which follow @caballero2002.
#' 
#' ### Heterosis and cycles
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$d_k$", "$a_k$", "$\\delta u_{ik}$, $\\delta v_{jk}$", "$H_i$", "$\\bar p_k$", "$y_k$",
             "$g^A_i$, $g^B_j$", "$s_{ij}$", "$\\sigma^2_{SCA}$",
             "$\\lambda$", "$t$", "$p_0^{(0)}$",
             "$M$", "$G(\\mathbf{x})$", "$h_i$", "$GD_{WI\\text{-}hyb}$",
             "$\\theta_A$, $\\theta_B$, $\\theta_{AB}$", "$p_{A,w}$",
             "$\\mathrm{MRD}_{ij}$", "$\\mu$", "$\\mathrm{DC}(\\cdot)$",
             "$\\sigma^2_{GCA_A}$, $\\sigma^2_{GCA_B}$", "$F^\\star_k$", "$\\rho_k$"),
  Meaning = c("dominance deviation at locus $k$",
              "additive effect at locus $k$; enters the GCA, not the SCA (@sec-mating-estimation)",
              "centred 0/1 genotype of pool-A line $i$ / pool-B line $j$ at locus $k$: $u_{ik} - p_{Ak}$, $v_{jk} - p_{Bk}$",
              "mid-parent heterosis of hybrid $i$; $\\sum_k d_k$ over its heterozygous loci",
              "$(p_{Ak} + p_{Bk})/2$, the merged-pool frequency",
              "$p_{Ak} - p_{Bk}$, the divergence at locus $k$",
              "general combining ability for heterosis; weighted by the **opposite** pool's frequencies",
              "specific combining ability; $-2\\sum_k d_k\\,\\delta u_{ik}\\,\\delta v_{jk}$",
              "$4\\sum_k d_k^2 p_{Ak}q_{Ak}p_{Bk}q_{Bk}$; its Balding-Nichols expectation falls as $(1 - F_{BN})^2$",
              "weight on within- against between-pool diversity -- **not** the OCS penalty $\\lambda$ of the selection table",
              "cycle index",
              "base frequencies, frozen at the founding cycle",
              "one-locus population mean under random mating, $a(p - q) + 2pqd$",
              "genotypic value of an individual with marker row $\\mathbf{x}$ (0/0.5/1); not the VanRaden $\\mathbf{G}$",
              "heterozygous fraction of hybrid $i$; its self-coancestry is $1 - h_i/2$",
              "within-individual gene diversity of the F1s, half their mean heterozygosity",
              "coancestry within pool A, within pool B, and between them, $\\mathbf{w}_A'\\mathbf{f}^L\\mathbf{w}_B$ with $\\mathbf{w}_A$ the pool-A block of $\\mathbf{w}$ rescaled to sum to 1 within pool A (and $\\mathbf{w}_B$ likewise), as `line_weights()` returns; the unrescaled block gives $\\theta_{AB}/4$",
              "pool-A allele frequency at the within-pool weights $\\mathbf{w}_A$ (summing to 1 over pool A), $\\sum_i w_{A,i} u_{ik}$",
              "modified Rogers distance between lines $i$ and $j$; $\\mathrm{MRD}_{ij}^2 = 1 - f^L_{ij}$ for inbred lines",
              "grand mean of $H_{ij}$ over the complete factorial (in the UC of the selection table, a population mean)",
              "double centring over the $A \\times B$ block: minus row and column means, plus the grand mean",
              "variance of $g^A_i$, $g^B_j$ over the factorial; $\\sum_k d_k^2 (1 - 2p_{Bk})^2 p_{Ak}q_{Ak}$ and symmetrically",
              "divergence $F_{ST}$ (Balding-Nichols expectation) at which locus $k$'s GCA variance turns over; $\\bar F^\\star$ is their $d_k^2(p_kq_k)^2$-weighted mean, where the summed GCA variance turns over",
              "the $\\rho$ of the mating-design table with $k$ random testers from a finite pool"),
  `Function` = c("argument to `heterosis_value()`", "-", "inside `heterosis_gca_sca()`", "`heterosis_value()`",
                 "inside `heterosis_partition()`", "`pool_complementarity()$mean_sq_delta_p` is $\\overline{y^2}$",
                 "`heterosis_gca_sca()$gca_A`", "`heterosis_gca_sca()$sca`",
                 "closed form; see @sec-heterosis-relocation",
                 "not implemented; see @sec-catalogue", "`run_cycles()`",
                 "`ctx$p0`, set once",
                 "-", "-", "`rowMeans(ctx$X == 0.5)`", "`gd_partition()$GD_WI_hyb`",
                 "`theta_pools()`", "-", "`mrd_matrix()`", "`heterosis_gca_sca()$mu`", "-",
                 "closed form; see @sec-heterosis-relocation", "-", "see @sec-heterosis-step6"),
  check.names = FALSE))

#' 
#' Expected heterosis splits as $\sum_k d_k[\,2\bar p_k(1-\bar p_k) + y_k^2/2\,]$,
#' whose two halves are $GD_T$ and $GD_{BS}$ when $d_k \equiv 1$, and whose sum is
#' $1 - \theta_{AB}$ (@sec-heterosis). Over a complete factorial the realised values
#' split orthogonally as $H_{ij} = \mu + g^A_i + g^B_j + s_{ij}$.
#' 
#' ### Inbreeding, the three lenses
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$F_{hom}$", "$F_{drift}$", "$F_{IBD}$", "$F_{ROH}$", "$\\text{cov}$", "$\\kappa$"),
  Lens = c("homozygosity", "drift", "identity by descent", "hybrid", "-", "-"),
  Definition = c("$1 - \\overline{H_t/H_0}$; **can be negative**",
                 "$\\overline{\\delta p^2 / [p_0(1-p_0)]}$; never negative",
                 "segments inherited from a defined base",
                 "genome fraction in runs of homozygosity",
                 "$2\\,\\text{cov}(\\delta p/s,\\,(p_0 - \\tfrac12)/s) = F_{hom} - F_{drift}$",
                 "panel statistic $\\overline{(p_0 - \\tfrac12)^2/[p_0(1-p_0)]}$ (@sec-genomic-era); not the aggregate genotype $W$"),
  `Function` = c("`freq_metrics()`", "`freq_metrics()`", "requires pedigree + linkage",
                 "not implemented", "`freq_metrics()$cov_diag`", "-"),
  check.names = FALSE))

#' 
#' ### Selection and optimisation
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$u_i$", "$\\alpha$", "$\\alpha_{\\max}$", "$\\mathbf{c}$",
             "$\\mathbf{w}$", "$k_a$", "$\\lambda$", "$\\sigma^2_{DH}$", "UC"),
  Meaning = c("multi-trait index of hybrid i",
              "$(GD_{\\text{ref}} - GD_S)/GD_{\\text{ref}}$; negative means more diverse than chance",
              "the diversity budget -- a policy decision",
              "continuous contributions, summing to 1",
              "line-usage weights, $w_a = k_a/(2n)$",
              "times line a is used as a parent",
              "weight on the coancestry penalty in continuous OCS -- **not** the within/between weight of the heterosis table",
              "progeny variance of a DH family",
              "usefulness criterion, $\\mu + i h \\sigma$"),
  `Function` = c("`ctx$index`", "`alpha_loss()`", "argument to `stage2_select()`",
                 "`ocs_quadprog()`", "`line_weights()`, `line_usage_freq()`",
                 "`line_counts()`", "`ocs_relaxation()`", "`sigma2_dh()`",
                 "`usefulness_criterion()`"),
  check.names = FALSE))

#' 
#' ### Genomic prediction
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$\\mathbf{u}$, $\\hat{\\mathbf{u}}$", "$\\boldsymbol\\beta$",
             "$\\sigma^2_u$, $\\sigma^2_e$", "$\\lambda$", "$h^2$",
             "$r$", "$r_i^2$", "$\\mathrm{PEV}_i$", "$\\pi$", "$\\nu$, $S$",
             "$M_e$"),
  Meaning = c("breeding values; the BLUP of them",
              "marker effects; $\\mathbf{u} = \\mathbf{Z}\\boldsymbol\\beta$",
              "genetic and residual variance",
              "$\\sigma^2_e/\\sigma^2_u$ -- **not** the OCS penalty above",
              "$\\sigma^2_u/(\\sigma^2_u + \\sigma^2_e)$",
              "accuracy: $\\mathrm{cor}(\\hat u, g)$, needs the truth",
              "reliability: $1 - \\mathrm{PEV}_i/(\\sigma^2_u \\mathbf{G}^*_{ii})$, does not",
              "prediction error variance, from the inverse of the MME",
              "prior probability a marker has no effect (BayesB)",
              "degrees of freedom and scale of the $\\chi^{-2}$ prior; `df`, `R2`",
              "effective number of independent chromosome segments"),
  Note = c("defined over **all** individuals, not just the phenotyped ones",
           "the same fit, two parametrisations -- exactly (@sec-genomic-prediction)",
           "supplied here, never estimated; REML in practice",
           "a variance ratio, not a tuning knob",
           "the one number the whole fit is conditioned on",
           "meaningless without its CV scheme (@sec-hybrid-cv)",
           "the early warning: it collapses before the accuracy does",
           "$\\sigma^2_e[\\mathbf{C}^{uu}]_{ii}$",
           "BayesC$\\pi$ estimates it; at book scale, badly",
           "hyperparameters, not fitted",
           "unlinked markers here, so $M_e$ is the marker count"),
  check.names = FALSE))

#' 
#' **CV0, CV1, CV2** name what the training set had already seen of a candidate
#' hybrid's *parents*: neither, one, or both. In a factorial between two pools these
#' are three different questions, and only CV2 is easy -- see @sec-hybrid-cv.
#' 
#' ### Population sizing
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$N$", "$n$", "$p$", "$H$", "$H_t$", "$D$", "$N_{eq}$",
             "$L$ (Morgans)", "$A_t$", "$d$", "$r$", "$g$", "$z_i$", "$w_i$",
             "$\\beta$", "$N_{90}$", "$k$", "$P$", "$N_{95}(k)$",
             "$h_{res}$", "$n_{loc}$"),
  Meaning = c("F2 plants, equal to the number of F4 lines under SSD",
              "selfed F1 plants",
              "frequency of P1 ancestry at a marker in the panel",
              "panel heterozygosity; 0.125 in an F4",
              "heterozygosity of the parent whose meiosis produces generation t + 1",
              "diversity retained, $\\overline{2p(1-p)}/0.5$; $\\mathrm{E}[D] = 1 - (1-H)/N$ without distortion (@eq-sizing-div)",
              "$(1-H)/(1-D)$ -- a communication device, **not** a Wright Ne",
              "total map length",
              "junctions per haplotype at generation t",
              "distance between adjacent markers, cM",
              "recombination fraction, Haldane",
              "random-mating generations after the F2 (map expansion)",
              "share of plant i's genome from P1",
              "seed contribution of plant i in the bulk, $e^{\\beta(z_i - \\bar z)}$",
              "bulk selection intensity on P1 ancestry (scalar)",
              "smallest grid N reaching 90% of the gain from the smallest to the largest grid N",
              "unlinked loci at which a P2 homozygote is to be recovered",
              "probability that at least one F4 line is P2P2 at all k loci",
              "plants giving $P \\geq 0.95$ without distortion (@eq-sizing-n95)",
              "fraction of loci still heterozygous in each parent",
              "independent loci polymorphic between the parents"),
  `Function` = c("`run_scheme(n_F2 =)`", "`f1_sizing(n_F1 =)`", "`panel_freq()`",
                 "`panel_het()`", "-", "`diversity_retained()`", "`n_equivalent()`",
                 "`map$total_cM / 100`", "`expected_junctions()`",
                 "`build_map(spacing_cM =)`", "`build_map()`", "-", "-",
                 "`bulk_weights()`", "`f2_opt$beta_bulk`", "-",
                 "`multilocus_recovery(k =)`", "`multilocus_recovery()`", "-",
                 "`f1_sizing(h_res =)`", "`f1_sizing(n_loci_eff =)`"),
  check.names = FALSE))

#' 
#' These symbols are local to @sec-sizing. There $N$ and $n$ count F2 and F1
#' plants, not candidate and selected hybrids; $L$ is a map length in Morgans, not
#' a number of parent lines; $k$ counts loci, not a marker index or testers;
#' $\beta$ is a scalar selection intensity, not the marker-effect vector
#' $\boldsymbol\beta$; $p$ is P1-ancestry frequency within one cross, not a
#' reference-allele frequency on the frozen base $p_0$.
#' 
#' ### Backcrossing
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$k$", "$s$", "$D$", "$\\text{IBD}_E$", "$d$", "$r$", "$L$",
             "$P_{\\text{same}}$", "$q$", "$n$", "$N$", "$P$", "$\\nu$"),
  Meaning = c("target genes introgressed from one donor, coupling phase, unlinked to each other",
              "fraction of the genome donor and elite share by descent",
              "donor dosage of a plant; $(1/2)^{t+1}$ in expectation after t backcrosses without selection",
              "identity by descent with the elite, $1 - (1-s)D$ in expectation (@eq-bc-ibd)",
              "interval length, cM",
              "recombination fraction, Haldane (@eq-bc-haldane)",
              "distance between two targets in Morgans, $d/100$ -- not a total map length",
              "probability that two donor-derived targets sit in one donor segment (@eq-bc-psame)",
              "per-plant probability of the wanted genotype at all k targets",
              "plants genotyped in one generation or step",
              "plants per backcross generation in a uniform schedule",
              "probability required of a sizing criterion (0.95)",
              "shape of the gamma renewal model of crossover interference; not modelled"),
  `Function` = c("`target_indices(k =)`", "`make_shared_ibd(s =)`, `run_bc_program(s =)`",
                 "`expected_donor()`", "`expected_ibd()`", "`build_map(spacing_cM =)`",
                 "`haldane_r()`", "-", "`p_same_segment()`", "`sizing_table()`",
                 "`n_for_count()`", "`run_bc_program(n_sched =)`", "`n_for_count(P =)`", "-"),
  check.names = FALSE))

#' 
#' These symbols are local to @sec-backcross. $s$ carries no subscript there and is
#' not the self-coancestry $s_i$ or the specific combining ability $s_{ij}$; $D$ is
#' donor dosage, not the diversity retained $D$ of @sec-sizing; $N$ and $n$ count
#' plants, not candidate and selected hybrids; $L$ is an interval between two
#' targets, not the total map length of @sec-sizing; $\nu$ is a gamma shape, not
#' the degrees of freedom of the $\chi^{-2}$ prior in the genomic-prediction block; $k$ counts target
#' genes as it counts loci in @sec-sizing.
#' 
#' ### Mating design
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$g^A_i$, $g^B_j$", "$s_{ij}$", "$k$", "$c$", "$r$",
             "$\\rho$", "T0 / T1 / T2"),
  Meaning = c("general combining ability of a pool-A / pool-B line",
              "specific combining ability of the cross",
              "testers per pool",
              "crosses per line in a sparse factorial",
              "plots per cross",
              "least-squares GCA accuracy, $\\sqrt{\\sigma^2_g / (\\sigma^2_g + \\sigma^2_s/c + \\sigma^2_e/(c r))}$",
              "untested hybrids with neither / one / both parents in the training set"),
  `In the code` = c("`fit_gca()$gA`, `$gB`", "`simulate_factorial()$S`",
                    "`design_tester(k =)`", "`design_circulant(c =)`",
                    "`design_reps()`", "`gca_accuracy_theory()`", "-"),
  check.names = FALSE))

#' 
#' $r$ here is plots per cross; in the genomic-prediction table above and the
#' response table below it is the accuracy of a selection criterion. @sec-mating keeps $\rho$ for accuracy to avoid the clash.
#' 
#' ### Sparse testing
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$L$", "$k$", "$p$", "CV1 / CV2 / CV0 / CV00",
             "PEV", "$b_1$", "$\\sigma^2_{res}$"),
  Meaning = c("locations in the trial",
              "locations per hybrid (plots per hybrid, one plot per cell)",
              "share of hybrid x location cells observed, $k / L$",
              "new genotype / missing cell of a tested genotype / new environment / both new",
              "prediction error variance of a hybrid's target value",
              "slope of truth on prediction; 1 = no dispersion bias",
              "residual of the analysis model, $\\sigma^2_{SCA \\times L} + \\sigma^2_e$ under one plot per cell"),
  `In the code` = c("`nLoc`", "`sparse_alloc(k =)`", "`p_real`", "`acc_cv1`, `acc_cv2`",
                    "`sparse_blup()$pev`", "`b1`", "`sparse_vc()$s2res`"),
  check.names = FALSE))

#' 
#' Here $k$ counts locations per hybrid; in @sec-mating it counts testers per pool.
#' 
#' ### Joint allocation
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$g^f_i$, $g^m_j$", "$n_F$, $n_M$", "$n_c$", "$B$", "$N_P$", "$N_{SNP}$",
             "$n_l$", "$\\mathbf{X}_P$", "$SS_B$", "$GD_l$, $GD_P$", "$\\mathbf{Z}$, $w$",
             "$\\mathbf{A}_f$, $\\mathbf{A}_m$",
             "$\\sigma^2_{f\\ell}$, $\\sigma^2_{m\\ell}$, $\\sigma^2_{s\\ell}$"),
  Meaning = c("GCA of a female (pool-A) / male (pool-B) line: the $g^A_i$, $g^B_j$ above",
              "female / male lines (the $n_A$, $n_B$ of @sec-mating)",
              "distinct crosses made",
              "field budget in plots, $n_c k r$",
              "planted plots, $n_c k r$ (rows of $\\mathbf{X}_P$)",
              "markers; replaces $m$, which marks the male pool",
              "plots at location $l$",
              "hybrid marker matrix of the planted plots, one row per plot, 0/0.5/1",
              "between-location sum of squares of $\\mathbf{X}_P$, summed over markers",
              "gene diversity $1 - \\theta$ of location $l$'s plots / of all planted plots",
              "0/1 subgroup indicators per plot / weight equating their total SS to the markers'",
              "relationship matrices of the female / male lines",
              "variances of GCA x location (female, male) and SCA x location"),
  `In the code` = c("-", "`nF`, `nM`", "`nrow(plan)`", "-", "`sum(M)`", "`n_snp`",
                    "`colSums(M)`", "-", "-", "-", "`wZ * Zh`", "`A`",
                    "`sparse_vc()$s2fl`, `$s2ml`, `$s2sl`"),
  check.names = FALSE))

#' 
#' ### Response to selection
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$R$", "$i$", "$z$, $\\varphi$", "$r$", "$b$", "$S_I$", "$\\sigma_A$",
             "$V_{\\text{genic}}$", "$\\beta_k$", "$p_{Ak}$, $p_{Bk}$; $q = 1 - p$", "$p^{*}_k$",
             "$u_k$, $v_k$", "$d_k$", "$ID$", "$W$", "$\\mathbf{g}$; $\\hat{\\mathbf{g}}$",
             "$\\boldsymbol\\Sigma_P$, $\\boldsymbol\\Sigma_G$", "$\\mathbf{b}$", "$\\boldsymbol\\xi$",
             "$\\mathbf{a}$", "$\\mathbf{R}$", "$n_t$, $n_r$", "$\\mathbf{C}$",
             "$2 N_e R_1$"),
  Meaning = c("response to one cycle of selection",
              "selection intensity, $\\varphi(z)/(n/N)$ for an infinite normal population",
              "standard-normal truncation point leaving a fraction $n/N$ above it; standard-normal density",
              "accuracy of the selection criterion",
              "regression of genetic value on the index (scalar)",
              "selection differential on the index",
              "additive standard deviation",
              "variance if the loci were independent; the realised variance minus this is the disequilibrium term",
              "marker effect at locus k",
              "frequency of the allele coded 1 at locus $k$ among pool-A / pool-B lines; their mean is $\\bar p_k$ of the heterosis table. In @sec-simulating-crosses, the Balding-Nichols draws of @eq-balding-nichols",
              "ancestral frequency of the allele coded 1 at locus $k$, drawn uniform on $[0.05, 0.95]$; the expectation of $p_{Ak}$ and of $p_{Bk}$ under @eq-balding-nichols (@sec-simulating-crosses)",
              "0/1 allele carried at locus $k$ by the pool-A / pool-B parent of a hybrid; the $u_{ik}$, $v_{jk}$ of @sec-heterosis-gca-sca without the line index",
              "dominance deviation at locus k",
              "inbreeding depression, $2F\\sum d_k p_k q_k$; a **constant** with fully inbred parents",
              "aggregate genotype (breeding objective), $\\mathbf{a}'\\mathbf{g}$",
              "vector of the traits' genetic values, one entry per trait (not over individuals); its predictor. Distinct from the GCA $g^A_i$, $g^B_j$",
              "phenotypic and genetic covariance matrices of the traits -- **not** the relationship matrix $\\mathbf{G}$",
              "selection index weights",
              "vector of selection criteria the index $\\mathbf{b}'\\boldsymbol\\xi$ is built on ($\\hat{\\mathbf{g}}$ or the records $\\mathbf{y}$) -- **not** the contributions $\\mathbf{c}$",
              "economic weights on the aggregate genotype",
              "restriction matrix ($n_t \\times n_r$): directions held at zero expected gain",
              "number of traits; number of restrictions",
              "$\\boldsymbol\\Sigma_G\\mathbf{R}$ in the restricted index -- **not** the MME inverse $\\mathbf{C}^{uu}$",
              "Robertson's limit; half-life $1.4 N_e$"),
  `In the code` = c("-", "`sel_intensity()`", "-", "-", "-", "-", "-", "`genic_var()`",
                    "`sim$beta`", "-", "inside `simulate_lines()` (`p_anc`)", "rows of `sim$GL` (`U`, `V`)", "`d`",
                    "`inbreeding_depression()`", "-", "-; `traits` of `build_ctx()`", "`P`, `G`",
                    "`index_smith_hazel()`", "-", "-", "`index_restricted()`", "-", "-", "-"),
  check.names = FALSE))

#' 
#' $R = i\,r\,\sigma_A$ is the infinite-population, bivariate-normal result. In a
#' structured hybrid population at the teaching scale, @sec-response finds the
#' replicated mean gap between predicted and realised response within two standard
#' errors of zero; a single seed can over- or underpredict.
#' 
#' $H$ in @sec-response is the heterosis value $H_i$ of the heterosis table above,
#' not the aggregate genotype, which is $W$.
#' 
#' ### AlphaSimR pipeline
#' 
## -----------------------------------------------------------------------------
#| echo: false
knitr::kable(data.frame(
  Symbol = c("$x_{ik}$", "$G_i$, $G_{ij}$", "$\\mu_0$", "$\\delta_k$",
             "$M_{HW}$, $M_{F_t}$", "$\\bar H$", "$\\alpha_k$, $\\alpha^{(B)}_k$",
             "$\\hat g^A_i$", "$t$, $r$, $\\rho(t, r)$", "$v_g$, $v_s$, $v_e$", "$n_A$, $n_B$"),
  Meaning = c("0/1/2 dosage of individual $i$ at QTL $k$, an entry of $\\mathbf{M}^H$ -- **not** the 0/0.5/1 entry of $\\mathbf{X}$",
              "genetic value of individual $i$ under AlphaSimR's `TraitAD` (the $G(\\mathbf{x})$ above on the 0/1/2 dosage); of the F1 between inbred lines $i$ and $j$ -- **not** the Caballero-Toro $G_i$",
              "intercept of that genetic value",
              "dominance degree $d_k / |a_k|$, drawn from $N(\\texttt{meanDD}, \\texttt{varDD})$",
              "population mean under Hardy-Weinberg proportions; mean of selfed generation $F_t$",
              "mean of $H_{ij}$ over the A x B factorial: the $\\mu$ of the heterosis table, renamed because $\\mu_0$ is the intercept there",
              "average effect of a gene substitution, $a_k + d_k(q_k - p_k)$; the same at pool-B frequencies, $a_k + d_k(1 - 2p_{Bk})$ -- **not** the diversity-loss budget $\\alpha$ nor the Caballero-Toro $\\alpha_i$",
              "testcross estimate of the GCA $g^A_i$",
              "testers, locations, and the first-order accuracy of $\\hat g^A_i$: the $k$, $r$, $\\rho$ of the mating-design table, $k$ renamed because it indexes QTL there",
              "sample variance of $g^A_i$ over the candidates, and the SCA and error terms of $\\rho(t, r)$",
              "candidate pool-A lines; pool-B lines the testers are drawn from"),
  check.names = FALSE))

#' 
#' These symbols are local to @sec-alphasimr.
#' 
#' ## Conventions
#' 
#' **Coancestry always includes the diagonal.** Group coancestry in the sense of
#' Cockerham. That is what makes $1 - \theta$ exactly Nei's $H_e$ and makes the
#' algebra close. Drop the diagonal and none of the identities hold.
#' 
#' **Everything is computed per locus and then averaged over loci.** Never average
#' frequencies first.
#' 
#' **Marker coding.** Lines are 0/1 (or 0/2) because they are homozygous. Hybrids
#' are 0/1/2 as dosage, rescaled to 0/0.5/1 as within-individual frequency.
#' `stage1_build()` auto-detects and rescales.
#' 
#' **`f` is never centered, `G` always is.** A negative coancestry is a symptom of
#' the wrong matrix.
#' 
#' **Loss is always relative to a same-size random baseline.** Never to the full
#' pool.
#' 
#' ## Terms
#' 
#' **Balding-Nichols model.** A Beta distribution with mean $p$ and variance
#' $F_{BN}\,p(1-p)$, used to draw pool-specific allele frequencies from an
#' ancestral frequency $p$. $F_{BN}$ (`fst`) is the expected divergence of each
#' pool from the ancestral population; it is not the $F_{ST}$ statistic of
#' @sec-subdivided computed on the pools (see the partition above).
#' 
#' **Group coancestry.** The probability that two alleles sampled at random from a
#' whole set are identical in state, including the case of sampling the same
#' individual twice.
#' 
#' **Heterotic group / pool.** A set of lines maintained as a breeding unit,
#' crossed to lines of a complementary group to produce hybrids. Divergence between
#' groups is where heterosis comes from -- but only the divergence that coincides
#' with dominance. Divergence produced by drift alone generates none, because it is
#' paid for exactly out of the within-pool term. See @sec-heterosis.
#' 
#' **Mid-parent heterosis.** The F1's value minus the mean of its two parents. With
#' inbred parents the additive contributions cancel exactly, leaving only the
#' dominance deviations at the F1's heterozygous loci.
#' 
#' **General and specific combining ability (GCA, SCA).** The two halves of a
#' hybrid's value that a two-way layout separates: what a line contributes to every
#' cross it enters, and what depends on which two lines met. For heterosis both are
#' exact functions of $d$ and the pool frequencies, with GCA weighted by the
#' *opposite* pool's frequencies -- so combining ability is a property of a line
#' against a tester pool, never of the line alone. See @sec-heterosis-gca-sca.
#' 
#' **Reciprocal recurrent selection.** Selecting on performance *in cross* and
#' recycling the winners within their own pool. Selection information crosses the
#' pool boundary; germplasm does not. See @sec-cycles.
#' 
#' **Identity by state (IBS) vs by descent (IBD).** IBS is what markers observe:
#' two alleles are the same allele. IBD adds the requirement of common ancestry
#' from a defined base. The gap between them is where @sec-genomic-era's whole
#' argument lives.
#' 
#' **Line-level collapse.** The exact identity $\theta_S = \mathbf{w}'
#' \mathbf{f}^L \mathbf{w}$ for F1 hybrids of homozygous lines, which removes the
#' need for the $N \times N$ hybrid matrix. See @sec-collapse.
#' 
#' **Status number.** $N_s = 1/(2\theta)$, the number of unrelated non-inbred
#' individuals with the same gene diversity. A static descriptor.
#' 
#' **Truncation selection.** Take the top $n$ by index, ignore everything else. The
#' ceiling on gain and the floor on diversity.
#' 
#' **Warm start.** Seeding an optimiser's initial population with heuristic
#' solutions. Not optional here: without it the differential evolution finishes
#' below a plain greedy.
