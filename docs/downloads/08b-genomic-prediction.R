#' # Predicting breeding values: GBLUP, BayesA, BayesB {#sec-genomic-prediction}
#' 
# 08b-genomic-prediction -- standalone script of the chapter 08b-genomic-prediction.qmd
# Book: https://ederdbs.github.io/QG/08b-genomic-prediction.html
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
acc  <- read.csv(book_data("genomic_prediction_accuracy.csv"))
sens <- read.csv(book_data("genomic_prediction_pi_sensitivity.csv"))
f3 <- function(x) sprintf("%.3f", x)        # numbers quoted inline
f4 <- function(x) sprintf("%.4f", x)        # small differences
se <- function(x) sd(x) / sqrt(length(x))   # standard error of a mean

#' 
#' @sec-stages treats S4, hybrid mining, as a selection among hybrids whose values it does not
#' derive (its S4 section and @tbl-hp-stages), and nothing in it says where such values come from in a real programme.
#' @sec-hybrid-programme states that genomic prediction supplies the predicted values
#' that S4 selects on (its stage table, @tbl-hp-stages); this chapter supplies them for
#' the simulated hybrids and measures what the models reach on them.
#' 
#' Two earlier chapters flagged the same gap. @sec-simulating-crosses built
#' `ctx$traits` from *known* marker effects, so the traits carry no prediction error;
#' its closing callout limits what that licenses to a statement about the optimum on
#' known values and leaves the prediction gap to this chapter. @sec-choosing-error
#' (Finding 5) showed what happens once the index carries error, but manufactured that
#' error rather than fitting a model to produce it, and @sec-case-study will repeat the
#' caveat. This chapter fits actual prediction models to a training population with
#' phenotypic noise, and shows how their output enters the `stage1_build()` contract
#' every later chapter consumes -- for one trait, on a candidate subset, which changes
#' $N$ (@sec-genpred-handoff).
#' 
#' `vanraden_G()` builds the matrix that @sec-coancestry identifies as the one for
#' genomic best linear unbiased prediction (GBLUP), and its documentation limits it to
#' trait prediction. Nothing in the package has used it that way until now.
#' 
#' The chapter also has a second job, which only became apparent once the models
#' were fitted: an accuracy number means nothing until you say what was hidden from
#' the model. @sec-hybrid-cv shows that the obvious split -- hold out a random 40%
#' of the hybrids -- answers the easiest of the three questions a hybrid programme
#' actually asks, and that the fit itself says so, before the truth is consulted.
#' 
#' Every model fitted below follows the same two-step logic. **Step one, training:**
#' markers and phenotypes recorded on a historical population -- lines or hybrids
#' already evaluated in earlier trials -- are used to estimate a relationship between
#' genotype and phenotype, either as marker effects (BayesA/BayesB/ridge) or as a
#' variance structure over relatives (GBLUP). **Step two, prediction:** that same
#' relationship is applied to the markers of candidate hybrids that have never been
#' phenotyped, to rank them before any resource is committed to growing them out.
#' Whether step two can also score a line-by-line combination that has never been made
#' as a physical cross depends on the value being the mean of the two parental values,
#' which a model additive across markers can score from the parents' genotypes; for
#' `ctx$traits` it is, by construction (@sec-genpred-truth). For a real hybrid of inbred
#' lines the genotype is also fixed by the two parents, but the dominance part of the
#' value is not the mean of parental values, and an additive model does not score it
#' (@sec-heterosis-gca-sca).
#' 
#' **Assumptions of the whole chapter, declared once.** Inbred parent lines and a
#' complete $25 \times 25$ factorial of F1 hybrids ($N = 625$, $L = 50$ lines,
#' $m = 2000$ markers, `book_cfg`, seed 1). The trait is purely additive, with no
#' dominance and so no specific combining ability (SCA); it is generated from the same markers the models see, so
#' every causal locus is genotyped and there is no gap between markers and quantitative trait loci (QTL) and no linkage
#' disequilibrium (the accuracies are a best case in that respect). Genotypes are coded as dosages $0/1/2$ for
#' the models and the relationship matrix $\mathbf{G}$ is centred on the allele
#' frequencies of the $N$ hybrids themselves (@eq-vanraden-g). $h^2$ is supplied, not
#' estimated. Accuracy means the Pearson correlation, among candidates, of the predicted
#' value with the true genetic value `g`, unless a sentence says otherwise.
#' 
#' ## A training population with real noise
#' 
#' Everywhere else in this book, `ctx$index` *is* the truth. Here it plays a
#' different role: it is the value a real breeding programme does not get to see,
#' and can only estimate from phenotypes recorded on a subset of individuals.
#' Building that subset takes three steps: manufacture a phenotype by adding
#' noise to the true genetic value, split the population into the individuals
#' that will carry a phenotype and those that will not, then hand only the first
#' group's records to the models fitted below.
#' 
## -----------------------------------------------------------------------------
ctx <- simulate_data(book_cfg)
N   <- ctx$N
g   <- ctx$traits[, 1]         # the true genetic value -- known only to us
G   <- ctx$G                   # VanRaden G, centred on the hybrids' own frequencies
stopifnot(abs(var(g) - 1) < 1e-12)

#' 
#' A phenotype is the genetic value plus environmental noise, $y = g + e$, and
#' heritability is the fraction of phenotypic variance the genetic part accounts
#' for, $h^2 = \mathrm{Var}(g) / (\mathrm{Var}(g) + \mathrm{Var}(e))$. `traits`
#' is built by `scale()`, so the sample variance of $g$ over the $N$ hybrids is 1
#' exactly, and the noise variance that delivers a target $h^2$ is $(1-h^2)/h^2$:
#' 
## -----------------------------------------------------------------------------
h2 <- 0.5
set.seed(9)
e <- rnorm(N, 0, sqrt((1 - h2) / h2))
y <- g + e

#' 
#' Split the population into a training set, whose phenotypes the model gets to
#' see, and a candidate set -- the hybrids actually being selected among -- whose
#' phenotypes it does not. This mirrors the two roles a real programme's
#' germplasm plays at any one time: training stands in for hybrids already
#' phenotyped in earlier trials, and candidates stand in for this cycle's
#' untested combinations, ranked here purely from markers:
#' 
## -----------------------------------------------------------------------------
set.seed(9)
train <- sample.int(N, floor(0.6 * N))
cand  <- setdiff(seq_len(N), train)
c(train = length(train), candidates = length(cand))

#' 
#' ## The truth this chapter is predicting {#sec-genpred-truth}
#' 
#' Two properties of $g$ decide everything that follows, and both are consequences
#' of how @sec-simulating-crosses built it rather than choices made here. Both require
#' that the trait is generated from the markers the models are given and is purely
#' additive, as declared above.
#' 
#' ### The generative model is GBLUP's own assumption
#' 
#' `ctx$traits` is `scale(Z %*% B)` with the marker effects `B` drawn
#' independently; $\mathbf{Z}$ is the centred dosage matrix of `vanraden_G()`
#' ($N \times m$; the Matrices table of the notation appendix). For a single trait that is
#' $\mathbf{g} = \mathbf{Z}\boldsymbol\beta$ with
#' $\mathrm{Var}(\boldsymbol\beta) = \mathbf{I}\sigma^2_\beta$ over draws of
#' $\boldsymbol\beta$, so
#' 
#' $$\mathrm{Var}(\mathbf{g}) = \mathbf{Z}\mathbf{Z}'\sigma^2_\beta
#'   = \mathbf{G}\,\underbrace{2\textstyle\sum_k p_k(1-p_k)\,\sigma^2_\beta}_{\sigma^2_u},$$ {#eq-genpred-var-g}
#' 
#' because $\mathbf{G}$ is *defined* as $\mathbf{Z}\mathbf{Z}'$ over that same
#' divisor (@sec-coancestry). Two checks, both asserted: the package's `ctx$G` carries
#' that divisor, and $\mathbf{g}$ lies in the column space of $\mathbf{Z}$ (a
#' necessary condition for $\mathbf{g} = \mathbf{Z}\boldsymbol\beta$, informative
#' because that space has far fewer dimensions than $N$, see @sec-g-singular):
#' 
## -----------------------------------------------------------------------------
#| label: genpred-generative
vr <- vanraden_G(ctx$X * 2)
s2 <- 2 * sum(vr$p * (1 - vr$p))
dev_G <- max(abs(tcrossprod(vr$Z) / s2 - ctx$G))
dev_g <- max(abs(g - qr.fitted(qr(vr$Z), g)))
stopifnot(dev_G < 1e-10, dev_g < 1e-8)
c(G_vs_definition = dev_G, g_outside_span_Z = dev_g)

#' 
#' So the covariance GBLUP *assumes* for the breeding values (@eq-genpred-var-g) is, up to the scalar
#' $\sigma^2_u$, the covariance the breeding values are generated with. This
#' simulation is the infinitesimal model, and that single fact is most of the answer to
#' "which model wins" below. It is also the sense in which every accuracy in this
#' chapter is a best case: no model here is misspecified. The scalar is not a free
#' parameter anyone drew: `scale()` fixes the realised variance of $g$ at 1, and the
#' expected variance of $g_i$ is $G_{ii}\sigma^2_u$, so the standardisation implies
#' $\sigma^2_u \approx 1/\overline{G_{ii}} =$ `r f3(1 / mean(diag(G)))`, with
#' $\overline{G_{ii}} =$ `r f3(mean(diag(G)))`.
#' 
#' ### A hybrid's value is the mean of two parental values
#' 
#' The hybrids are F1s of homozygous lines, so a hybrid's marker row is the average
#' of its two parents' rows, and averaging is linear. For *any* additive effect
#' vector whatsoever, the hybrid's genetic value is therefore the mean of the two
#' parental line values -- general combining ability (GCA), with no SCA left over:
#' 
## -----------------------------------------------------------------------------
#| label: genpred-linear-identity
L  <- simulate_lines(book_cfg)
set.seed(21)
bb <- rnorm(ctx$m)                    # any effects at all; the identity is linear
vL <- as.numeric((L / 2) %*% bb)      # the parental line values they imply
dev_lin <- max(abs(as.numeric(ctx$X %*% bb) - (vL[ctx$ped$a] + vL[ctx$ped$b]) / 2))
stopifnot(dev_lin < 1e-10)
dev_lin

#' 
#' The residual is at machine precision because the statement is an identity
#' (asserted to be below $10^{-10}$). Two consequences run through the rest of the
#' chapter. The mild one is that a "hybrid-specific" prediction has nothing to
#' predict here: the dominance effects $d_k$ of @sec-heterosis are absent from
#' `ctx$traits` by construction, so SCA (@sec-heterosis-gca-sca) is not merely
#' unmodelled, it is not in the data. The sharp one is @sec-g-singular.
#' 
#' There is a third consequence, the operational payoff, and it holds under the
#' additive condition declared above. Because a hybrid's value is a fixed linear
#' function of its two parents' marker genotypes, once marker effects are estimated
#' from a training population of phenotyped hybrids, that same estimate scores *any*
#' line A x line B combination, including one never crossed: its score needs only the
#' two lines' genotype rows (checked on fitted effects in @sec-genpred-bayes
#' below). What this saves is the phenotyping of that hybrid; what it costs is
#' genotyping its two lines, which the simulation has for all $L = 50$. Whether the
#' lines are genotyped anyway in a real programme, and what a crossing and evaluation
#' cycle costs, are not quantified in this book. The saving in memory that
#' @sec-stages attributes to S4 belongs to the diversity computation and is a
#' different one. In a real hybrid the identity covers only the additive part: the
#' dominance part of GCA is an average effect at the *opposite* pool's frequencies
#' (@sec-hybrid-programme) and SCA is a property of the pair, so a model additive
#' across markers scores the sum of the parents' additive parts and nothing else.
#' 
#' ## GBLUP: prediction from the relationship matrix
#' 
#' GBLUP treats the breeding value as a random effect $\mathbf{u}$ with covariance
#' proportional to the genomic relationship matrix, $\mathrm{Var}(\mathbf{u}) =
#' \mathbf{G}\,\sigma_u^2$, and solves the mixed model equations. Fitting and
#' using it is three operational steps, in this order: first write down the
#' mixed model equations linking phenotypes, a relationship matrix and a variance
#' ratio; second, solve that linear system once, for every individual in the
#' population at the same time, training and candidates alike; third, convert the
#' same solve's by-product -- the inverse of its coefficient matrix -- into a
#' reliability for each prediction, which is the only part of the output a
#' programme can trust without knowing the truth.
#' 
#' ### Where the mixed model equations come from {#sec-genpred-mme}
#' 
#' The model is $\mathbf{y} = \mathbf{1}\mu + \mathbf{W}\mathbf{u} + \mathbf{e}$
#' with $\mathbf{u} \sim (\mathbf{0}, \mathbf{G}\sigma^2_u)$ and $\mathbf{e} \sim
#' (\mathbf{0}, \mathbf{I}\sigma^2_e)$ independent, where $\mathbf{W}$ is the
#' incidence matrix mapping training records to individuals ($n_t \times N$; the
#' symbol $\mathbf{Z}$ is kept for the centred marker matrix, as in the notation
#' appendix). Treating $\mathbf{u}$ as a random variable rather than a parameter to be
#' estimated, the standard derivation of the mixed model equations maximises the *joint*
#' density of what is observed and what is not (@henderson1975 is this book's reference
#' for best linear unbiased prediction, BLUP; that the joint-density derivation is in that paper was not verified),
#' 
#' $$-2\log p(\mathbf{y}, \mathbf{u}) \;\propto\;
#'   \frac{(\mathbf{y} - \mathbf{1}\mu - \mathbf{W}\mathbf{u})'
#'         (\mathbf{y} - \mathbf{1}\mu - \mathbf{W}\mathbf{u})}{\sigma^2_e}
#'   \;+\; \frac{\mathbf{u}'\mathbf{G}^{-1}\mathbf{u}}{\sigma^2_u},$$
#' 
#' and the two stationarity conditions, multiplied through by $\sigma^2_e$, *are*
#' 
#' $$\begin{bmatrix}\mathbf{1}'\mathbf{1} & \mathbf{1}'\mathbf{W} \\
#'                   \mathbf{W}'\mathbf{1} & \mathbf{W}'\mathbf{W} + \mathbf{G}^{-1}\lambda
#'     \end{bmatrix}
#'     \begin{bmatrix}\hat\mu \\ \hat{\mathbf{u}}\end{bmatrix} =
#'     \begin{bmatrix}\mathbf{1}'\mathbf{y} \\ \mathbf{W}'\mathbf{y}\end{bmatrix},
#' \qquad \lambda = \sigma_e^2/\sigma_u^2,$$ {#eq-genpred-mme}
#' 
#' with $\mathbf{1}$ a vector of ones of length $n_t$ and $\hat\mu$ the
#' generalised-least-squares (GLS) intercept. As written, the equations need
#' $\mathbf{G}^{-1}$, which does not exist for the $\mathbf{G}$ of this chapter
#' (@sec-g-singular); every solve below uses
#' $\mathbf{G}^{*} = w_G\,\mathbf{G} + (1-w_G)\,\mathbf{I}$ with $w_G = 0.95$ (`w` in the code) in its
#' place, unless a sentence varies $w_G$ ($0 < w_G \le 1$). In this chapter $\mathbf{u}$
#' and the simulation's $\mathbf{g}$ denote the same quantity, the additive genetic
#' value of the hybrids, $\hat{\mathbf{u}}$ is its BLUP and $g$ the truth the accuracy
#' is measured against. @sec-choosing-error gives the same roles to different letters: $u$
#' is the true index there (the truth, $g$ here) and $\hat u$ a simulated prediction (a fitted
#' BLUP here), so what differs is the name of the truth and the origin of the prediction. Three things fall out of that
#' derivation that the equations alone do not say.
#' 
#' $\mathbf{u}$ is defined over *all* $N$ individuals, training and candidates
#' together -- it enters through the prior, not through the data -- so one solve
#' produces predictions for both, and a candidate with no record of its own is
#' predicted entirely by its $\mathbf{G}$ entries against individuals that do have
#' one. Everything @sec-hybrid-cv finds is a consequence of that sentence.
#' 
#' $\lambda$ is a variance *ratio*, not a tuning parameter. The code takes
#' $\lambda = (1-h^2)/h^2$, which is $\sigma^2_e/\sigma^2_u$ only if $\sigma^2_u = 1$.
#' It is not: the standardisation of `traits` implies $\sigma^2_u \approx$
#' `r f3(1 / mean(diag(G)))` (@sec-genpred-truth), so the ratio matching the generating model
#' is $\lambda\,\overline{G_{ii}}$, `r f3(mean(diag(G)))` rather than 1 at $h^2 = 0.5$: the
#' supplied $\lambda$ is about `r round(100 * (1 / mean(diag(G)) - 1))`% too large (its effect on accuracy is measured right
#' after the fit). Nothing in this chapter estimates it; a real programme would, by restricted maximum likelihood (REML).
#' 
#' And under normality the joint maximiser is the conditional mean,
#' $\hat{\mathbf{u}} = \mathbb{E}[\mathbf{u} \mid \mathbf{y}]$, which is why BLUP
#' minimises mean squared error rather than merely being a sensible shrinkage rule.
#' Dropping normality it remains best among *linear* predictors, which is what the
#' acronym claims.
#' 
#' ### Why the ridge blend is not optional {#sec-g-singular}
#' 
#' @eq-g-sum-zero, $\mathbf{1}'\mathbf{G}\mathbf{1} = 0$, is what @sec-why-not-g reads as
#' the reason $\mathbf{G}$ cannot measure diversity. It has a second consequence, for
#' prediction. $\mathbf{G}$ is positive semi-definite, and a quadratic form of a PSD
#' matrix vanishes only on its null space, so $\mathbf{1}'\mathbf{G}\mathbf{1} = 0$
#' forces
#' 
#' $$\mathbf{G}\mathbf{1} = \mathbf{0}.$$
#' 
#' For the $\mathbf{G}$ of @eq-vanraden-g, centred on the frequencies of the same
#' individuals, $\mathbf{G}$ is therefore singular whatever $N$ and $m$ are; the blend
#' is not insurance against an awkward case, and without it `solve()` has nothing to
#' invert. (A $\mathbf{G}$ centred on a fixed base, such as $\mathbf{G}_{0.5}$, need
#' not satisfy @eq-g-sum-zero, and the argument of this paragraph does not apply to it;
#' the factorial bound below still does.)
#' 
#' Here it is much worse than one lost dimension. By the identity of
#' @sec-genpred-truth every hybrid row is an average of two line rows, so the whole
#' $N \times m$ matrix lives in the span of the $L$ line genotypes. This is the
#' argument of @eq-era-rank ($\mathrm{rank}(\mathbf{f}) \le \mathrm{rank}(\mathbf{B})$,
#' with $\mathbf{B}$ the $N \times L$ parent-usage incidence matrix), which
#' @sec-genomic-era proves for $\mathbf{f}$ and measures at one scale; it carries over to the
#' centred $\mathbf{G}$ with one more step. Each hybrid uses exactly one line from each
#' pool, which makes the pool-A indicator columns of $\mathbf{B}$ sum to the pool-B
#' ones, so $\mathrm{rank}(\mathbf{B}) = L - 1$ for the complete factorial, and the
#' columns of $\mathbf{Z}$ are centred, which removes the constant vector (itself in
#' the span of $\mathbf{B}$). Hence
#' 
#' $$\mathrm{rank}(\mathbf{G}) \le \min(L - 2,\; m),$$ {#eq-genpred-rank}
#' 
#' a bound (a theorem under the stated factorial design), not an equality. The
#' number of markers enters only through $m$, which is not binding here. Whether the
#' bound is attained depends on the line genotypes; it is measured below (@tbl-genpred-rank) at three
#' values of $L$, one simulated population each, with $m = 2000$ fixed:
#' 
## -----------------------------------------------------------------------------
#| label: genpred-rank
c(max_abs_G_times_one = max(abs(ctx$G %*% rep(1, N))))

rank_G <- function(n_per_pool) {
  cfg <- utils::modifyList(book_cfg, list(n_pool_A = n_per_pool, n_pool_B = n_per_pool))
  G   <- simulate_data(cfg)$G
  c(lines = 2 * n_per_pool, hybrids = nrow(G),
    rank = sum(eigen(G, only.values = TRUE)$values > 1e-8))
}
rk <- t(sapply(c(10, 20, 25), rank_G))
stopifnot(all(rk[, "rank"] == rk[, "lines"] - 2))   # the bound is attained at all three

#' 
## -----------------------------------------------------------------------------
#| label: tbl-genpred-rank
#| tbl-cap: "Rank of the hybrid $\\mathbf{G}$ (eigenvalues above $10^{-8}$) against the number of parent lines, at $m = 2000$, one simulated population per row. In every row it equals the number of lines minus two, the bound of @eq-genpred-rank."
#| echo: false
knitr::kable(as.data.frame(rk))

#' 
#' At the book's scale (@tbl-genpred-rank) that is
#' `r rk[rk[, "lines"] == 50, "rank"]` dimensions carrying `r N` hybrids:
#' `r N - rk[rk[, "lines"] == 50, "rank"]` of the eigenvalues are zero, and
#' `0.95 * G + 0.05 * I` is what makes the equations solvable at all. Fifty lines were
#' genotyped and crossed into 625 combinations, but there were only ever
#' `r rk[rk[, "lines"] == 50, "rank"]` independent dimensions to measure; no amount of
#' phenotyping the 625 adds one more.
#' 
## -----------------------------------------------------------------------------
#| label: genpred-gblup
lambda <- (1 - h2) / h2
gblup <- function(y, train, h2, w = 0.95, lambda = (1 - h2) / h2) {
  Gs  <- w * G + (1 - w) * diag(N)                  # G*: the blend of the text
  n_t <- length(train)
  W   <- matrix(0, n_t, N); W[cbind(seq_len(n_t), train)] <- 1   # incidence
  X1  <- matrix(1, n_t, 1)
  LHS <- rbind(cbind(crossprod(X1), crossprod(X1, W)),
               cbind(crossprod(W, X1), crossprod(W) + solve(Gs) * lambda))
  RHS <- rbind(crossprod(X1, y[train]), crossprod(W, y[train]))
  C   <- solve(LHS)                                  # kept: it carries the PEVs
  sol <- C %*% RHS
  list(mu  = sol[1], u = sol[-1],
       rel = 1 - diag(C)[-1] * lambda / diag(Gs))
}
fit   <- gblup(y, train, h2)
u_hat <- fit$u
cat("GBLUP accuracy (candidates):", cor(u_hat[cand], g[cand]), "\n")

#' 
#' `gblup()` has no independent check in the usual sense, so the chunk below solves the
#' same model by a different route -- the kernel form $\hat{\mathbf{u}} =
#' \mathbf{G}^{*}_{\cdot t}(\mathbf{G}^{*}_{tt} + \mathbf{I}\lambda)^{-1}(\mathbf{y}_t -
#' \hat\mu\mathbf{1})$, with $\hat\mu$ the GLS intercept under
#' $\mathbf{V} = \mathbf{G}^{*}_{tt} + \mathbf{I}\lambda$, which needs no inverse of
#' $\mathbf{G}^{*}$ -- and asserts the two agree:
#' 
## -----------------------------------------------------------------------------
#| label: genpred-gblup-oracle
tr  <- train
Gs  <- 0.95 * G + 0.05 * diag(N)
V   <- Gs[tr, tr] + diag(lambda, length(tr))
Vi1 <- solve(V, rep(1, length(tr)))
mu_gls <- sum(Vi1 * y[tr]) / sum(Vi1)
u_oracle <- Gs[, tr] %*% solve(V, y[tr] - mu_gls)
dev_gblup <- max(abs(fit$u - as.numeric(u_oracle)))
stopifnot(dev_gblup < 1e-8, abs(fit$mu - mu_gls) < 1e-8)
c(max_abs_diff_u = dev_gblup, mu_hat_GLS = mu_gls, mean_y_train = mean(y[tr]))

#' 
#' The two routes agree to `r signif(dev_gblup, 2)`. The intercept $\hat\mu$ is the GLS
#' value `r f3(mu_gls)`, not the training mean `r f3(mean(y[tr]))`: the residual
#' vector that enters the equations is $\mathbf{y}_t - \hat\mu\mathbf{1}$ with
#' the former.
#' 
#' The supplied $\lambda$ assumed $\sigma^2_u = 1$ (@sec-genpred-mme). Setting it to the ratio
#' implied by the standardisation, $\lambda\,\overline{G_{ii}}$, moves the accuracy on
#' this split from `r f4(cor(u_hat[cand], g[cand]))` to
#' `r f4(cor(gblup(y, train, h2, lambda = lambda * mean(diag(G)))$u[cand], g[cand]))`, one split, one noise draw.
#' 
#' ### Reliability: the accuracy you can compute without the truth {#sec-genpred-reliability}
#' 
#' This is the third step promised above. Inverting the coefficient matrix rather
#' than just solving against it costs one more decomposition and returns
#' something a breeding programme can act on: a per-candidate confidence figure
#' computed the same day the genomic estimated breeding value (GEBV) is, with no field trial required to check it.
#' The $\mathbf{u}$ block of that inverse holds the prediction error variances,
#' $\mathrm{PEV}_i = \sigma^2_e\,[\mathbf{C}^{uu}]_{ii}$, and the reliability of an
#' individual's prediction (@eq-genpred-reliability) is the fraction of its prior variance the data removed:
#' 
#' $$r_i^2 \;=\; 1 - \frac{\mathrm{PEV}_i}{\sigma^2_u\,\mathbf{G}^{*}_{ii}}
#'   \;=\; 1 - \frac{\lambda\,[\mathbf{C}^{uu}]_{ii}}{\mathbf{G}^{*}_{ii}},$$ {#eq-genpred-reliability}
#' 
#' where $\mathbf{C}^{uu}$ is the $\mathbf{u}$ block of the inverse and the second form
#' is the one the code evaluates: $\sigma^2_u$ cancels, so only the supplied $\lambda$
#' enters, not a separate value of $\sigma^2_u$. This is the same $r$ as the accuracy
#' reported everywhere in this chapter, with one difference that is the entire point:
#' $g$ does not appear in it. A programme can compute it for candidates it has never
#' phenotyped and never will.
#' 
## -----------------------------------------------------------------------------
#| label: genpred-reliability
c(mean_reliability = mean(fit$rel[cand]),
  implied_accuracy = sqrt(mean(fit$rel[cand])),
  realised_accuracy = cor(u_hat[cand], g[cand]))

#' 
#' On this one split (seed 9) the model under-states itself by
#' `r f3(cor(u_hat[cand], g[cand]) - sqrt(mean(fit$rel[cand])))`. That is a single
#' draw of noise and split. The chunk below repeats the whole fit over 40 fresh draws,
#' noise seed $s$ and split seed $s + 1000$ for $s = 101, \dots, 140$, and also recomputes
#' the implied accuracy with the blend turned down to $w_G = 0.999$: the blend
#' $0.95\mathbf{G} + 0.05\mathbf{I}$ tells the equations that every candidate carries 5%
#' of variance no relative can explain, and each $r_i^2$ is computed against that
#' inflated prior. @tbl-genpred-seeds gives the mean and standard deviation of each
#' quantity over the 40 draws.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-genpred-seeds
#| tbl-cap: "Mean and standard deviation over the 40 draws ($s = 101, \\dots, 140$) of the realised accuracy, of the implied accuracy at $w_G = 0.95$ (`implied`) and at $w_G = 0.999$ (`implied_w999`), of the latter with the supplied $\\lambda$ replaced by the one implied by the standardisation (`implied_w999_lam`), and of `err_f`, the correlation between the products of candidate prediction errors and their coancestry $f$ (used in the last section)."
rep_seed <- function(s) {
  set.seed(s);        ys <- g + rnorm(N, 0, sqrt((1 - h2) / h2))   # noise draw
  set.seed(s + 1000); tr <- sample.int(N, floor(0.6 * N))          # split draw
  cd   <- setdiff(seq_len(N), tr)
  f95  <- gblup(ys, tr, h2)
  f999 <- gblup(ys, tr, h2, w = 0.999)
  fcor <- gblup(ys, tr, h2, w = 0.999, lambda = lambda * mean(diag(G)))   # sigma_u^2 as implied
  err  <- g[cd] - f95$u[cd]
  fc   <- ctx[["f"]][cd, cd]; ut <- upper.tri(fc)
  c(accuracy     = cor(f95$u[cd], g[cd]),
    implied      = sqrt(mean(f95$rel[cd])),
    implied_w999 = sqrt(mean(f999$rel[cd])),
    implied_w999_lam = sqrt(mean(fcor$rel[cd])),
    err_f        = cor(outer(err, err)[ut], fc[ut]))   # used in the last section
}
R40 <- t(sapply(101:140, rep_seed))
gap40   <- R40[, "accuracy"] - R40[, "implied"]
blend40 <- R40[, "implied_w999"] - R40[, "implied"]
lam40   <- R40[, "implied_w999_lam"] - R40[, "implied_w999"]
acc9    <- cor(u_hat[cand], g[cand])
knitr::kable(fmt(t(rbind(mean = colMeans(R40), sd = apply(R40, 2, sd))), 4))

#' 
#' Over the 40 draws the realised accuracy is `r f3(mean(R40[, "accuracy"]))`
#' (s.d. `r f3(sd(R40[, "accuracy"]))`) and the implied accuracy
#' `r f3(mean(R40[, "implied"]))` (s.d. `r f3(sd(R40[, "implied"]))`): the model
#' under-states itself by `r f3(mean(gap40))` (s.d. `r f3(sd(gap40))`). Lowering the blend
#' to $w_G = 0.999$ raises the implied accuracy by `r f3(mean(blend40))`, which is
#' `r round(100 * mean(blend40) / mean(gap40))`% of the mean gap. Also supplying the
#' $\lambda$ implied by the standardisation, $\lambda\,\overline{G_{ii}}$ (the supplied $\lambda$ is
#' `r round(100 * (1 / mean(diag(G)) - 1))`% too large, as stated in @sec-genpred-mme), moves it by a further `r f3(mean(lam40))`; what is left,
#' `r f3(mean(gap40) - mean(blend40) - mean(lam40))`, survives both changes and is not
#' attributed here. The
#' opening split is not typical of the 40: its accuracy `r f3(acc9)` lies
#' `r round((acc9 - mean(R40[, "accuracy"])) / sd(R40[, "accuracy"]), 1)` s.d. above their mean, so
#' numbers quoted for it alone (its gap of `r f3(acc9 - sqrt(mean(fit$rel[cand])))`) should not be read as
#' properties of the method. A mean reliability and a correlation taken across a *set* of
#' candidates are not the same quantity: the second is helped by the spread of true
#' values among the candidates, which the first knows nothing about, and this may
#' account for part of the remaining gap (not tested here). In the direction measured,
#' the implied accuracy is conservative. @tbl-genpred-cv gives the gap scheme by scheme.
#' 
#' ## What the random split was measuring {#sec-hybrid-cv}
#' 
#' The split at the top of this chapter took a random 60% of the *hybrids*. There
#' are 625 hybrids but only 50 lines, so a sample that size contains every line
#' several times over: each of the 250 candidates has **both of its parents**
#' sitting in the training set, in other hybrids with recorded phenotypes. Given
#' @sec-genpred-truth -- a hybrid's value is the mean of its two parental values --
#' that split asks the model to interpolate inside a factorial whose margins it has
#' already seen. It is not a hard question.
#' 
#' The partition of untested hybrids by how many of their parents appear in the
#' training set -- two, one or none -- is @technow2014's, applied to a factorial
#' between two heterotic pools; they call the three groups T2, T1 and T0. This
#' chapter uses the labels CV2, CV1 and CV0 for the same three groups, borrowing the
#' names from the genotype-by-environment literature, where @burgueno2012 define CV1
#' and CV2 for untested genotypes and for genotypes tested in some environments but not
#' others. The meaning here is therefore this book's, not theirs, and differs from the
#' one @sec-sparse-validation gives the same labels for genotype-by-environment cells
#' (the notation appendix lists both). Holding out *lines* rather than hybrids splits
#' the candidates three ways: both parents seen (the random split, CV2), one parent
#' unseen (CV1), neither parent seen (CV0). Removing 8 lines from each pool leaves
#' 289 training hybrids and gives 272 CV1 and 64 CV0 candidates; the CV2 row below
#' draws a random training set of the same 289, so the only thing that differs across
#' the three rows is *what* was hidden, not how much. Each of the 20 replicates draws
#' its own noise (seed $s$) and its own held-out lines (seed $s + 1000$), so the
#' dispersion reported includes noise as well as the choice of lines; the genetic
#' values $g$ are the single draw of `ctx$traits` throughout.
#' 
## -----------------------------------------------------------------------------
#| label: genpred-cv
cv_split <- function(seed, k = 8) {
  set.seed(seed)                                       # noise draw
  ys <- g + rnorm(N, 0, sqrt((1 - h2) / h2))
  set.seed(seed + 1000)                                # which lines / hybrids are held out
  hoA <- sample(unique(ctx$ped$a), k)
  hoB <- sample(unique(ctx$ped$b), k)
  seen_a <- !(ctx$ped$a %in% hoA)
  seen_b <- !(ctx$ped$b %in% hoB)
  lin <- gblup(ys, which(seen_a & seen_b), h2)         # lines held out
  rnd <- sample.int(N, sum(seen_a & seen_b))           # same size, random hybrids
  rd  <- gblup(ys, rnd, h2)
  i2  <- setdiff(seq_len(N), rnd)
  i1  <- which(xor(seen_a, seen_b))
  i0  <- which(!seen_a & !seen_b)
  c(CV2 = cor(rd$u[i2],  g[i2]),  imp2 = sqrt(mean(rd$rel[i2])),
    CV1 = cor(lin$u[i1], g[i1]),  imp1 = sqrt(mean(lin$rel[i1])),
    CV0 = cor(lin$u[i0], g[i0]),  imp0 = sqrt(mean(lin$rel[i0])),
    n_train = sum(seen_a & seen_b), n1 = length(i1), n0 = length(i0))
}
cv <- t(sapply(1:20, cv_split))
cvm  <- colMeans(cv)
cvsd <- apply(cv, 2, sd)
cvse <- cvsd / sqrt(nrow(cv))
gapcv <- cv[, c("imp2", "imp1", "imp0")] - cv[, c("CV2", "CV1", "CV0")]   # implied accuracy minus realised accuracy
stopifnot(all(cv[, "n_train"] == 289), all(cv[, "n1"] == 272), all(cv[, "n0"] == 64))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-genpred-cv
#| tbl-cap: "GBLUP over 20 replicates at $h^2 = 0.5$, training set fixed at 289 hybrids. Each replicate has its own noise draw and its own held-out lines (8 per pool). `accuracy` is the realised correlation with the truth, `sd` its standard deviation over replicates, `se` the standard error of the mean; `implied` is the model's own estimate of the accuracy, $\\sqrt{\\overline{r_i^2}}$ over the candidates of the scheme (square root of the mean reliability), computed without the truth; `gap` is implied minus realised accuracy, with its standard error."
#| echo: false
sc <- c("CV2", "CV1", "CV0")
knitr::kable(fmt(data.frame(
  scheme      = c("CV2 -- random hybrids held out",
                  "CV1 -- one parent unseen",
                  "CV0 -- both parents unseen"),
  accuracy    = cvm[sc], sd = cvsd[sc], se = cvse[sc],
  implied     = cvm[c("imp2", "imp1", "imp0")],
  gap         = colMeans(gapcv),
  `se of gap` = apply(gapcv, 2, se),
  row.names   = NULL, check.names = FALSE), 3))

#' 
#' The mean accuracy of the first row is `r f3(cvm[["CV2"]])` (@tbl-genpred-cv); the
#' second, one unseen parent, is `r f3(cvm[["CV1"]])`, a drop of
#' `r round(100 * (1 - cvm[["CV1"]] / cvm[["CV2"]]))`%; the third, two unseen parents,
#' is `r f3(cvm[["CV0"]])` with a spread across replicates (s.d. `r f3(cvsd[["CV0"]])`)
#' larger than the mean. The standard error of the CV0 mean is `r f3(cvse[["CV0"]])`, so
#' the mean is `r round(cvm[["CV0"]] / cvse[["CV0"]], 1)` standard errors from zero over these 20
#' replicates, while `r round(100 * mean(cv[, "CV0"] <= 0))`% of the individual replicates
#' returned an accuracy of zero or less (range `r f3(min(cv[, "CV0"]))` to
#' `r f3(max(cv[, "CV0"]))`). The mean is distinguishable from nothing; a single holdout of
#' the size used here (64 candidates) is not reliably so. A programme has one holdout,
#' not twenty.
#' 
#' @habier2007 show that the accuracy of marker-based predictions can come from
#' relationships among individuals captured by the markers, as well as from marker
#' effects estimated in their own right. In this simulation the markers are the causal
#' set and there is no linkage disequilibrium, so the three rows differ in how much
#' relationship to the training set is available: the first row is almost entirely
#' relatedness through shared parents. The third row is what remains when no parent is
#' shared, and relationship through the other lines of the pool is still available
#' to it; it is therefore not a measure of "markers alone", but it is the closest the
#' design comes to one.
#' 
#' That the third row collapses is not a defect of the fit. The explanation proposed here is
#' the rank bound of @eq-genpred-rank, tested only weakly below: the 289 training rows of $\mathbf{G}$ are built from
#' `r 2 * (book_cfg$n_pool_A - 8)` training lines, and their rank is bounded by that
#' number minus one, which is what is measured on one draw of held-out lines (that is a statement about
#' the training matrix, not yet about the collapse of accuracy):
#' 
## -----------------------------------------------------------------------------
#| label: genpred-rank-train
set.seed(1001)
ho <- sample(unique(ctx$ped$a), 8); hb <- sample(unique(ctx$ped$b), 8)
tr_cv <- which(!(ctx$ped$a %in% ho) & !(ctx$ped$b %in% hb))
rank_train <- sum(eigen(G[tr_cv, tr_cv], only.values = TRUE)$values > 1e-8)
stopifnot(rank_train == 2 * (book_cfg$n_pool_A - 8) - 1)
c(training_hybrids = length(tr_cv), rank_of_G_tt = rank_train)

#' 
#' So `r length(tr_cv)` records carry `r rank_train` independent dimensions, and asking them to
#' pin down 2000 marker effects well enough to score a genotype no relative shares is
#' asking for something that was never in the data. @daetwyler2008 give a deterministic
#' accuracy as a function of the product of the heritability and the ratio of the number
#' of phenotypes to the number of loci or independent segments; the form used below,
#' $r = \sqrt{n h^2 / (n h^2 + M_e)}$ with $n$ the number of independent training units
#' and $M_e$ the effective number of independent chromosome segments, is this chapter's own
#' algebraic statement of that dependence (a function of $n h^2 / M_e$ alone), and is used
#' here as the statement being tested. That it is the paper's Eq. 1, and the symbol $M_e$
#' (the paper writes $n_G$ for the number of independent chromosome segments), were not seen
#' in the printed equation; the paper's text, which states the dependence on that product,
#' was read.
#' The units are a choice, and the choice matters. With the units the simulation has --
#' $n$ the independent *lines* and $M_e$ the marker count, because the markers are drawn
#' independently and carry no linkage to bundle them into segments -- the formula gives
#' the value in the first column below; taking $n$ as the number of training *records*
#' gives the last. Measured CV0 accuracy over 30 draws at each of three numbers of
#' held-out lines $k$ per pool (@tbl-genpred-daetwyler):
#' 
## -----------------------------------------------------------------------------
#| label: genpred-daetwyler
daet <- function(n, M_e = book_cfg$m) sqrt(n * h2 / (n * h2 + M_e))
dz <- t(sapply(c(4, 8, 12), function(k) {
  r <- sapply(100 + 1:30, function(s) cv_split(s, k)[["CV0"]])
  c(k = k, measured = mean(r), se = sd(r) / sqrt(30),
    formula_lines   = daet(2 * (book_cfg$n_pool_A - k)),
    formula_records = daet((book_cfg$n_pool_A - k)^2))
}))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-genpred-daetwyler
#| tbl-cap: "Measured CV0 accuracy of GBLUP (mean and standard error over 30 draws of noise and held-out lines, $h^2 = 0.5$) against $\\sqrt{n h^2 / (n h^2 + M_e)}$ with $M_e = 2000$ markers, for $n$ = training lines or $n$ = training records, at $k$ = 4, 8, 12 held-out lines per pool."
#| echo: false
knitr::kable(fmt(as.data.frame(dz), 3),
             col.names = c("k", "measured", "se", "formula, n = lines", "formula, n = records"))

#' 
#' The measured value lies within `r round(max(abs(dz[, "measured"] - dz[, "formula_lines"]) / dz[, "se"]), 1)`
#' standard errors of the lines-unit formula at every $k$, and
#' `r round(min(abs(dz[, "measured"] - dz[, "formula_records"]) / dz[, "se"]), 1)` or more
#' standard errors from the records-unit one (@tbl-genpred-daetwyler). That is consistent
#' with the lines unit; it does not confirm the formula, because the standard errors
#' are large (they are of the size of the differences between $k$), the unit was chosen
#' with the measured collapse already in view, and three values of $k$ on one simulated
#' population is the whole test.
#' 
#' The most useful column of @tbl-genpred-cv is the implied accuracy. It is the square root
#' of the mean reliability $r_i^2$ of @sec-genpred-reliability over the candidates of a
#' scheme (the mean reliabilities themselves are
#' `r f3(mean(cv[, "imp2"]^2))`, `r f3(mean(cv[, "imp1"]^2))` and
#' `r f3(mean(cv[, "imp0"]^2))` for CV2, CV1 and CV0, the means over replicates of the
#' squares of the column), taken on the scale of a correlation so that it can be set
#' against the realised accuracy. Computed from the mixed model equations, with no access to
#' $g$, the implied accuracies are `r f3(cvm[["imp1"]])` against `r f3(cvm[["CV1"]])` for CV1
#' and `r f3(cvm[["imp0"]])` against `r f3(cvm[["CV0"]])` for CV0, in the mean, so they follow
#' the realised accuracies down the collapse. The gap is clear only in the easy scheme: the
#' implied accuracy under-states the realised one by `r f3(-mean(gapcv[, "imp2"]))` for CV2
#' (`r round(-mean(gapcv[, "imp2"]) / se(gapcv[, "imp2"]), 1)` s.e.), by
#' `r f3(-mean(gapcv[, "imp1"]))` for CV1 (`r round(-mean(gapcv[, "imp1"]) / se(gapcv[, "imp1"]), 1)` s.e.)
#' and by `r f3(-mean(gapcv[, "imp0"]))` for CV0 (`r round(-mean(gapcv[, "imp0"]) / se(gapcv[, "imp0"]), 1)` s.e.),
#' so for the hard schemes the model's own figure is not distinguishable from exact on
#' these replicates, and for CV2 it is conservative. The implied accuracies hardly vary
#' between replicates (s.d. `r f3(cvsd[["imp2"]])`, `r f3(cvsd[["imp1"]])`, `r f3(cvsd[["imp0"]])`)
#' while the realised accuracies do (`r f3(cvsd[["CV2"]])`, `r f3(cvsd[["CV1"]])`,
#' `r f3(cvsd[["CV0"]])`): the model knows the mean accuracy of a scheme, not what any one
#' holdout will return. A programme that reports reliability alongside every GEBV does
#' not need to discover the collapse the way this chapter did; the warning is in the same
#' solve that produced the prediction.
#' 
#' ::: {.callout-warning}
#' ## Report which parents the training set had seen
#' 
#' An accuracy figure without its cross-validation scheme is not interpretable.
#' The same fit, the same data and the same trait give a mean accuracy of
#' `r f3(cvm[["CV2"]])`, `r f3(cvm[["CV1"]])` or `r f3(cvm[["CV0"]])` here depending only
#' on which hybrids were withheld. In a hybrid programme this is not
#' a technicality: CV2 is the accuracy for filling in a partly-observed factorial,
#' CV1 for a cross onto a new line from one pool, CV0 for a cross between two new
#' lines. They are different questions, and only the first one is easy.
#' :::
#' 
#' ## BayesA and BayesB: prediction from marker effects {#sec-genpred-bayes}
#' 
#' GBLUP assumes every marker contributes an equal, infinitesimal share of the
#' genetic variance. The Bayesian alphabet [@meuwissen2001; @delcampos2013]
#' relaxes that one assumption at a time. **BayesA** gives every marker its own
#' variance, drawn from a scaled-inverse-$\chi^2$ prior -- effects are shrunk
#' individually rather than uniformly, which matters when a few markers carry
#' much more signal than the rest. **BayesB** adds a point mass at zero: each
#' marker has prior probability $\pi$ of being excluded entirely, so the model
#' performs variable selection as it fits. Both reduce to GBLUP's ridge-regression
#' solution as a special case; they differ only in how much of the genetic
#' architecture they let the data shape.
#' 
#' Fitting either is a different computational route to the same train-then-predict
#' logic as GBLUP, in four steps rather than one linear solve: (1) declare a prior
#' distribution for each marker effect $\beta_k$, the thing that separates the
#' three models; (2) run a Gibbs sampler that alternates between drawing each
#' $\beta_k$ given the current residuals and every other parameter, and drawing
#' the variance components given the current effects, on the training records
#' only; (3) average the post-burn-in draws into a single point estimate
#' $\hat{\boldsymbol\beta}$; (4) predict any candidate, phenotyped or not, by
#' multiplying its marker dosages by $\hat{\boldsymbol\beta}$ -- exactly the same
#' last step as scoring a hybrid from GBLUP's $\hat{\mathbf{u}}$, just reached
#' through markers instead of a relationship matrix.
#' 
#' ### The priors, explicitly
#' 
#' All three models write $\mathbf{g} = \mathbf{Z}\boldsymbol\beta$, with $\mathbf{Z}$ the centred
#' dosage matrix. The Gibbs samplers are passed the uncentred dosages $\mathbf{M}^H$
#' ($0/1/2$, `M` in the code, the hybrid dosage matrix of the notation appendix), for which
#' $\mathbf{M}^H\boldsymbol\beta = \mathbf{Z}\boldsymbol\beta + \mathbf{1}\,(2\mathbf{p}'\boldsymbol\beta)$:
#' the two differ by a constant that the intercept absorbs. The models differ only
#' in what they assume about $\beta_k$. Ridge regression, and therefore GBLUP, uses
#' one variance for every marker; BayesA gives each marker its own, drawn from a
#' scaled inverse chi-square; BayesB puts a spike at zero in front of it:
#' 
#' $$\text{ridge, and so GBLUP:}\quad \beta_k \sim N(0, \sigma^2_\beta)
#'   \qquad\qquad
#'   \text{BayesA:}\quad \beta_k \sim N(0, \sigma^2_k), \;\; \sigma^2_k \sim \chi^{-2}(\nu, S)$$
#' 
#' $$\text{BayesB:}\quad \beta_k \sim
#'   \begin{cases} 0 & \text{with probability } \pi \\[2pt]
#'                 N(0, \sigma^2_k) & \text{otherwise.}\end{cases}$$
#' 
#' The scaled inverse chi-square is the conjugate prior for a normal variance, which
#' is the whole reason it appears: it keeps the Gibbs sampler in closed form. Its
#' two hyperparameters are the arguments the fits below pass. $\nu$ is `df = 5`, the
#' prior weight in pseudo-observations -- small, so the prior stays vague, but not
#' zero, because the posterior is improper at $\nu = 0$. $S$ is set from
#' `R2 = 0.5`, the share of phenotypic variance the prior expects the markers to
#' explain, spread over the markers by their observed variation. Neither is fitted;
#' both are choices, and `R2` in particular is a statement about heritability made
#' before seeing the data.
#' 
#' This book fits both with `bWGR::BayesA()`/`bWGR::BayesB()`
#' [@xavier2019bwgr] rather than by hand -- unlike GBLUP, a Gibbs sampler over
#' marker effects is not the few lines the mixed-model solve above was. In
#' `BayesB()` the argument `pi` is a fixed input and the returned object has no `pi`
#' (the arguments are `y, X, it, bi, pi, df, R2`); the call below fixes
#' $\pi = 0.95$, a choice, and nothing in the fit estimates it. `set.seed()` precedes
#' each fit because the sampler draws from R's generator:
#' 
## -----------------------------------------------------------------------------
#| label: genpred-bayes-fit
if (!requireNamespace("bWGR", quietly = TRUE))
  stop("this chapter needs the bWGR package (listed under Suggests): install.packages('bWGR')")
library(bWGR)
M <- ctx$X * 2   # dosage 0/1/2, what bWGR expects
set.seed(11)
fitA <- BayesA(y[train], M[train, ], it = 1500, bi = 500, df = 5, R2 = 0.5)
set.seed(12)
fitB <- BayesB(y[train], M[train, ], it = 1500, bi = 500, pi = 0.95, df = 5, R2 = 0.5)
predA <- as.numeric(M[cand, ] %*% fitA$b)
predB <- as.numeric(M[cand, ] %*% fitB$b)
c(BayesA = cor(predA, g[cand]), BayesB = cor(predB, g[cand]))

#' 
#' Both fits produce a marker-effect vector `$b`; a candidate's GEBV is just its
#' genotypes dotted with those effects. GBLUP produced the same quantity from the
#' relationship matrix instead of the markers directly -- two routes to the same
#' thing, checked next. Because a hybrid's dosage row is the sum of its two parents'
#' $0/1$ rows (@sec-genpred-truth), the fitted effects score a hybrid from
#' the two lines' genotype rows alone, which is what lets a model trained on made hybrids
#' score a combination that was not made. For the fitted `fitB$b`, asserted:
#' 
## -----------------------------------------------------------------------------
#| label: genpred-parent-score
vLb <- as.numeric((L / 2) %*% fitB$b)          # parental line values under the fitted effects
dev_par <- max(abs(as.numeric(M[cand, ] %*% fitB$b) -
                   (vLb[ctx$ped$a[cand]] + vLb[ctx$ped$b[cand]])))
stopifnot(dev_par < 1e-10)
dev_par

#' 
#' In this complete factorial every combination exists in `ctx$X`, so the check shows
#' that the score depends on the two parent rows only; a pair absent from the factorial
#' would be scored by the same two rows.
#' 
#' ### What the sampler actually selects
#' 
#' Both fits also return the quantities the priors above are about -- BayesA's
#' per-marker variances in `$vb`, BayesB's posterior inclusion probabilities in
#' `$d` (plotted in @fig-genpred-selection) -- and on the polygenic trait there is nothing in them to look at. Rebuild
#' the oligogenic architecture the cached sweep below uses (the same draw: seed
#' `book_cfg$seed + 42`), three markers of `r book_cfg$m` given effects and everything
#' else exactly zero, and there is:
#' 
## -----------------------------------------------------------------------------
#| label: genpred-oligo
set.seed(book_cfg$seed + 42)
qtl  <- sample.int(book_cfg$m, 3)
Bq   <- rep(0, book_cfg$m); Bq[qtl] <- rnorm(3)
g_ol <- as.numeric(scale(vr$Z %*% Bq))
set.seed(31)
y_ol <- g_ol + rnorm(N, 0, sqrt((1 - h2) / h2))
share <- apply(vr$Z[, qtl], 2, var) * Bq[qtl]^2 /
         sum(apply(vr$Z[, qtl], 2, var) * Bq[qtl]^2)
round(share, 3)                                  # share of genetic variance each

#' 
#' Worth knowing before reading anything into the sweep: the three effects were
#' drawn from `rnorm(3)`, and this draw put `r round(100 * max(share))`% of the genetic
#' variance on one of them. "Three causal markers" describes the construction; the
#' trait is effectively monogenic, so the nominal true $\pi = 1 - 3/2000 = 0.9985$
#' understates its sparsity. It is also **one** draw of an architecture: every
#' oligogenic result in this chapter, the cached sweep included, has one architecture,
#' and the replication is over training splits and noise.
#' 
## -----------------------------------------------------------------------------
#| label: genpred-oligo-fit
set.seed(13)
oA <- BayesA(y_ol[train], M[train, ], it = 1500, bi = 500, df = 5, R2 = 0.5)
set.seed(14)
oB <- BayesB(y_ol[train], M[train, ], it = 1500, bi = 500, pi = 0.95, df = 5, R2 = 0.5)
big <- qtl[which.max(abs(Bq[qtl]))]
c(BayesB_d_at_QTL   = oB$d[big],  BayesB_d_median  = median(oB$d),
  BayesB_d_sum      = sum(oB$d),
  BayesA_vb_at_QTL  = oA$vb[big], BayesA_vb_median = median(oA$vb))

#' 
## -----------------------------------------------------------------------------
#| label: fig-genpred-selection
#| fig-cap: "The two priors on the same oligogenic trait (one fit each, $h^2 = 0.5$, 375 training hybrids, 2000 markers), with the marker carrying most of the genetic variance circled. Left, BayesB posterior inclusion probability (prior inclusion probability $1 - \\pi = 0.05$): close to 1 at the circled marker and at a low but non-zero level at the others. Right, BayesA per-marker variance: raised at the circled marker, by an amount that changes from chain to chain (@sec-genpred-bayes)."
#| fig-alt: "Two panels on the same oligogenic trait. Left, BayesB posterior inclusion probability by marker; right, BayesA per-marker variance by marker; the marker carrying most of the genetic variance is circled in both"
par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
for (v in list(list(oB$d, "BayesB: posterior inclusion", "posterior inclusion probability"),
               list(oA$vb, "BayesA: marker variance", "per-marker variance"))) {
  plot(v[[1]], pch = 16, cex = 0.3, col = "grey60", xlab = "marker index",
       ylab = v[[3]], main = v[[2]], cex.main = 0.95)
  points(big, v[[1]][big], pch = 1, cex = 2, lwd = 2)
}

#' 
#' @fig-genpred-selection shows one fit of each. How much of it is the chain rather
#' than the data is measured by refitting on the same data with eight different seeds (@tbl-genpred-bayes-seeds):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-genpred-bayes-seeds
#| tbl-cap: "Minimum, median and maximum over eight chains on the same oligogenic data (BayesA seeds $500 + s$, BayesB seeds $600 + s$, $s = 1, \\dots, 8$). `vb_ratio`: BayesA variance at the circled marker over its median across markers. `d_qtl`, `d_median`, `d_sum`: BayesB posterior inclusion probability at the circled marker, its median across markers and its sum across markers."
chains <- t(sapply(1:8, function(s) {
  set.seed(500 + s)
  a <- BayesA(y_ol[train], M[train, ], it = 1500, bi = 500, df = 5, R2 = 0.5)
  set.seed(600 + s)
  b <- BayesB(y_ol[train], M[train, ], it = 1500, bi = 500, pi = 0.95, df = 5, R2 = 0.5)
  c(vb_ratio = a$vb[big] / median(a$vb), d_qtl = b$d[big],
    d_median = median(b$d), d_sum = sum(b$d))
}))
knitr::kable(fmt(t(rbind(min = apply(chains, 2, min), median = apply(chains, 2, median),
                         max = apply(chains, 2, max))), 3))

#' 
#' ### What the two priors do on this trait
#' 
#' On the same data, BayesB's posterior inclusion probability at the marker with
#' `r round(100 * max(share))`% of the variance is at least
#' `r f3(min(chains[, "d_qtl"]))` in every one of the eight refits. BayesA's variance at
#' that marker, relative to its median over markers, ranges from
#' `r round(min(chains[, "vb_ratio"]), 1)` to `r round(max(chains[, "vb_ratio"]), 1)`
#' across the eight chains (median `r round(median(chains[, "vb_ratio"]), 1)`; the fit in
#' the figure has `r round(oA$vb[big] / median(oA$vb), 1)`). So BayesB flags the marker in
#' every chain, while how far BayesA's variance stands above the background depends on
#' the chain as much as on the data. BayesA's variance at that marker is above the median in
#' all eight chains, by a factor that is unstable.
#' 
#' BayesA estimates a private variance $\sigma^2_k$ for every marker, and the only
#' data bearing on $\sigma^2_k$ is the single effect $\beta_k$ drawn from it. One
#' observation never overwhelms a prior, so each $\sigma^2_k$ stays near the
#' $\chi^{-2}(\nu, S)$ it started from however many individuals are phenotyped;
#' @gianola2009 make this the central objection to reading these posteriors as learning
#' about the genetic architecture. What follows for the other 1999 markers is that they
#' keep a variance they have not earned, which may let them absorb some signal that
#' belongs to the one marker that has it; this chapter did not measure that absorption.
#' 
#' BayesB's output is different in kind: `d` is a posterior inclusion probability. The
#' call fixes $\pi = 0.95$, so the prior inclusion probability is $1 - \pi = 0.05$, and
#' the median marker's posterior inclusion is `r f3(median(oB$d))`; the sum of `d`, the
#' expected number of markers in the model at an iteration, is `r round(sum(oB$d))` of
#' `r book_cfg$m`, and over the eight refits the median of `d` ranges only from
#' `r f3(min(chains[, "d_median"]))` to `r f3(max(chains[, "d_median"]))`. The other markers
#' are therefore not removed; each is in the model about once in
#' `r round(1 / median(oB$d), 1)` iterations, which is above the prior rate. What differs from
#' BayesA is that an excluded marker contributes exactly zero in that iteration,
#' instead of a draw from a variance it has not earned. Whether that, or the sparser
#' prior alone, is what gives BayesB its accuracy advantage was not isolated here (a
#' BayesB with a private $\sigma^2_k$ for every included marker is still what is
#' fitted); the $\pi$ sweep below is consistent with the sparsity of the prior doing
#' part of the work.
#' 
#' So the advantage is bounded, and shows up in accuracy rather than in the figure: on
#' this architecture at $h^2 = 0.5$ @tbl-genpred-paired below gives BayesB
#' `r f3(with(subset(acc, arch == "oligogenic" & h2 == 0.5), mean(BayesB)))` against
#' BayesA's `r f3(with(subset(acc, arch == "oligogenic" & h2 == 0.5), mean(BayesA)))` and
#' GBLUP's `r f3(with(subset(acc, arch == "oligogenic" & h2 == 0.5), mean(GBLUP)))`. BayesA
#' sits with GBLUP, not with BayesB, on this cell.
#' 
#' ## Verification: two routes agree
#' 
#' GBLUP with a flat prior on every marker's variance and the un-selected member
#' of the Bayesian alphabet, Bayesian ridge regression (`iv = FALSE, pi = 0` in
#' `bWGR::wgr()`), are the same model solved two different ways -- one through
#' the $N \times N$ relationship matrix, the other through the $N \times m$
#' marker matrix. The check below has three steps: substitute the marker-space
#' model into the mixed model equations algebraically, read off the penalty each
#' route implies, and then confirm numerically that the two solutions coincide to
#' machine precision -- not merely correlate.
#' 
#' They are the same model in a stronger sense than "they should agree". Substitute
#' $\mathbf{u} = \mathbf{Z}\boldsymbol\beta$ and $\mathbf{G} = \mathbf{Z}\mathbf{Z}'
#' / 2\sum_k p_k(1-p_k)$ into the mixed model equations (@eq-genpred-mme), with $\mathbf{G}$ in place of
#' $\mathbf{G}^{*}$ (the blend has no marker-space equivalent) and the same
#' intercept $\hat\mu$ in both routes. With $t$ the training rows,
#' 
#' $$\hat{\mathbf{u}} = \mathbf{G}_{\cdot t}
#'     \left(\mathbf{G}_{tt} + \mathbf{I}\lambda\right)^{-1}(\mathbf{y}_t - \hat\mu\mathbf{1})
#'   \;=\; \mathbf{Z}\hat{\boldsymbol\beta},
#'   \qquad
#'   \hat{\boldsymbol\beta} = \mathbf{Z}_t'
#'     \left(\mathbf{Z}_t\mathbf{Z}_t' + \mathbf{I}\lambda_\beta\right)^{-1}
#'     (\mathbf{y}_t - \hat\mu\mathbf{1}),$$ {#eq-genpred-identity}
#' 
#' with the two penalties differing by exactly the divisor that defines
#' $\mathbf{G}$: $\lambda_\beta = \lambda \cdot 2\sum_k p_k(1-p_k)$. With a different
#' scalar the two routes give different shrinkage and do not agree; with this one the
#' equivalence is exact. The chunk uses the GLS intercept of the kernel route (the one
#' that enters the equations), not the training mean, and asserts the identity:
#' 
## -----------------------------------------------------------------------------
#| label: genpred-identity
V_G  <- G[train, train] + diag(lambda, length(train))
v1   <- solve(V_G, rep(1, length(train)))
mu_G <- sum(v1 * y[train]) / sum(v1)                  # GLS intercept, not mean(y)
yc   <- y[train] - mu_G
u_G <- G[, train] %*% solve(V_G, yc)
u_M <- vr$Z %*% crossprod(vr$Z[train, ],
         solve(tcrossprod(vr$Z[train, ]) + diag(lambda * s2, length(train)), yc))
dev_GM <- max(abs(u_G - u_M))
stopifnot(dev_GM < 1e-10)
c(max_abs_diff = dev_GM, mu_GLS = mu_G, mean_y_train = mean(y[train]))

#' 
#' Machine precision (below $10^{-10}$, asserted), over all `r N` individuals. Note this
#' route uses the raw $\mathbf{G}$: it needs no inverse of it, so @sec-g-singular's blend
#' never enters, which is also why it is the cleaner statement of the identity. The
#' identity holds for any fixed intercept; the GLS one is used because it is the one
#' the equations define.
#' 
#' The Gibbs sampler should land close to the same place, and does, though only to
#' sampling error -- it is estimating $\lambda$ from the data rather than being told
#' it, and the blend used in `gblup()` has no exact marker-space equivalent:
#' 
## -----------------------------------------------------------------------------
#| label: genpred-gibbs-ridge
yobs <- rep(NA_real_, N); yobs[train] <- y[train]
set.seed(15)
fit_brr <- wgr(yobs, M, iv = FALSE, pi = 0, it = 1500, bi = 500)
c(gblup_vs_gibbs = cor(u_hat, fit_brr$hat - mean(fit_brr$hat)))

#' 
#' That correlation, `r f3(cor(u_hat, fit_brr$hat - mean(fit_brr$hat)))`, over all $N$ individuals
#' (training included) and for one chain, is the weaker of the two checks and is included
#' because it exercises the code path the Bayesian fits above actually use; no tolerance
#' is claimed for it. The identity (@eq-genpred-identity) is what proves the two routes are one model.
#' 
#' ## Which model wins, and when
#' 
#' `ctx$traits` is built from thousands of markers with independent, similarly
#' sized effects -- the textbook case GBLUP's infinitesimal-model assumption was
#' designed for. A trait controlled by a handful of large-effect loci is a
#' different regime, and it is the one BayesB's point-mass prior exists for.
#' `book/scripts/regenerate.R genpred` reruns the fits above 15 times each, at
#' two heritabilities, under both `ctx$traits`'s polygenic architecture and a
#' book-local variant with genetic variance concentrated on three markers out of
#' `r book_cfg$m` (the single draw of @sec-genpred-bayes). The two CSV files it
#' writes, `genomic_prediction_accuracy.csv` and `genomic_prediction_pi_sensitivity.csv`,
#' are produced in this repository by that script (the run reproduces both exactly) and the
#' chapter reads them as cached results: the accuracy sweep uses seed $1000 + i$ for
#' row $i$ of its grid and the $\pi$ sweep uses seed $2000 + $ replicate, set before
#' the noise and the split are drawn. Within a replicate all methods see the same noise
#' and the same split, so the comparisons below are paired (@tbl-genpred-paired, @fig-genpred-accuracy;
#' the paired $t$ statistics and $p$-values of the eight contrasts are in @tbl-genpred-paired-values).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-genpred-paired
#| tbl-cap: "Prediction accuracy (correlation, candidates only) over 15 paired training/candidate splits per cell: the mean accuracy of GBLUP, and the paired difference of BayesA and BayesB from GBLUP with its standard error over the 15 splits. The 15 splits of an architecture share one $g$ (one QTL draw for the oligogenic arm, most of its variance on one marker), so the standard errors do not include variation between architectures."
#| echo: false
cells <- unique(acc[, c("arch", "h2")])
pt <- do.call(rbind, lapply(seq_len(nrow(cells)), function(i) {
  d <- merge(cells[i, ], acc, by = c("arch", "h2"))
  data.frame(arch = d$arch[1], h2 = d$h2[1], n = nrow(d), GBLUP = mean(d$GBLUP),
             `BayesA - GBLUP` = mean(d$BayesA - d$GBLUP), `se A` = se(d$BayesA - d$GBLUP),
             `BayesB - GBLUP` = mean(d$BayesB - d$GBLUP), `se B` = se(d$BayesB - d$GBLUP),
             check.names = FALSE)
}))
knitr::kable(fmt(pt, 4))

#' 
## -----------------------------------------------------------------------------
#| label: fig-genpred-accuracy
#| fig-cap: "Prediction accuracy by architecture and heritability, 15 replicate splits each (cached sweep). Boxes: median and quartiles over splits; whiskers 1.5 times the interquartile range; shades: GBLUP, BayesA, BayesB in that order within each group (legend in the panel)."
#| fig-alt: "Box plots of prediction accuracy for GBLUP, BayesA and BayesB, by architecture and heritability, 15 splits each"
sub <- reshape(acc, direction = "long", varying = c("GBLUP", "BayesA", "BayesB"),
               v.names = "accuracy", timevar = "method",
               times = c("GBLUP", "BayesA", "BayesB"))
sub$grp <- interaction(sub$arch, sub$h2, sep = "\nh2=")
sub$method <- factor(sub$method, levels = c("GBLUP", "BayesA", "BayesB"))  # shade order = legend order
shade <- c("grey85", "grey65", "grey45")
bp <- boxplot(accuracy ~ method + grp, sub, plot = FALSE)
ng <- length(unique(sub$grp))
par(mar = c(4, 4, 1, 1))
bxp(bp, xaxt = "n", boxfill = rep(shade, ng), ylab = "accuracy (candidates)")
axis(1, at = 2 + 3 * (seq_len(ng) - 1), labels = levels(sub$grp), tick = FALSE, cex.axis = 0.8)
legend("bottomright", legend = c("GBLUP", "BayesA", "BayesB"), fill = shade, bty = "n",
       cex = 0.8, horiz = TRUE)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-genpred-paired-values
#| tbl-cap: "Paired $t$ statistic and two-sided $p$-value ($n - 1$ degrees of freedom, $n$ the number of splits per cell) of each of the eight differences of @tbl-genpred-paired, from the cached sweep. Contrast: method, architecture, $h^2$; each is the method minus GBLUP."
cellv <- function(a, h) pt[pt$arch == a & pt$h2 == h, ]
oB5 <- cellv("oligogenic", 0.5); oB2 <- cellv("oligogenic", 0.2)
pA2 <- cellv("polygenic", 0.2);  pP5 <- cellv("polygenic", 0.5)
# the eight paired contrasts of the table: 4 cells x {BayesA, BayesB} - GBLUP
n_contr <- 2 * nrow(pt)
tt <- c(pt[["BayesA - GBLUP"]] / pt[["se A"]], pt[["BayesB - GBLUP"]] / pt[["se B"]])
pv <- 2 * pt(-abs(tt), df = pt[["n"]][1] - 1)           # two-sided, paired t, n - 1 df
names(pv) <- c(paste("A", pt$arch, pt$h2), paste("B", pt$arch, pt$h2))
names(tt) <- names(pv)
alpha_bonf <- 0.05 / n_contr
stopifnot(n_contr == 8, all(pt[["n"]] == 15))
# p below the printed precision is shown as an inequality, not as 0.0000
p_txt <- ifelse(pv < 1e-4, "< 0.0001", sprintf("%.4f", pv))
knitr::kable(fmt(data.frame(contrast = names(tt), t = tt, p = p_txt, row.names = NULL), 4))

#' 
#' @tbl-genpred-paired and @fig-genpred-accuracy give the result. At $h^2 = 0.5$ under the
#' oligogenic architecture, BayesB's mean accuracy is `r f4(oB5[["BayesB - GBLUP"]])`
#' (s.e. `r f4(oB5[["se B"]])`) above GBLUP's -- the gap the model was built to close -- and
#' BayesA's is `r f4(oB5[["BayesA - GBLUP"]])` (s.e. `r f4(oB5[["se A"]])`). For BayesB in
#' this cell the paired $t$ statistic is `r sprintf("%.3f", tt[["B oligogenic 0.5"]])` and the
#' two-sided $p$-value is `r fmt_sci(pv[["B oligogenic 0.5"]])`, which @tbl-genpred-paired-values
#' prints as $< 0.0001$. At $h^2 = 0.2$
#' under the same architecture BayesB's difference is `r f4(oB2[["BayesB - GBLUP"]])`
#' (s.e. `r f4(oB2[["se B"]])`), i.e. a difference inside its standard error, and BayesA's is
#' `r f4(oB2[["BayesA - GBLUP"]])` (s.e. `r f4(oB2[["se A"]])`). Under the
#' polygenic architecture BayesB's differences are `r f4(pP5[["BayesB - GBLUP"]])` at
#' $h^2 = 0.5$ and `r f4(pA2[["BayesB - GBLUP"]])` at $h^2 = 0.2$, at
#' `r round(abs(pP5[["BayesB - GBLUP"]] / pP5[["se B"]]), 1)` and
#' `r round(abs(pA2[["BayesB - GBLUP"]] / pA2[["se B"]]), 1)` standard errors from zero; BayesA's at $h^2 = 0.2$ is `r f4(pA2[["BayesA - GBLUP"]])`
#' (s.e. `r f4(pA2[["se A"]])`).
#' 
#' The table holds `r n_contr` paired contrasts (2 methods against GBLUP in each of 4 cells),
#' each a two-sided paired $t$ test on 15 splits (14 d.f.). The Bonferroni threshold for the
#' family of `r n_contr` is $0.05/`r n_contr` =$ `r f4(alpha_bonf)`; the contrasts with
#' $p$ below it are `r paste(names(pv)[pv < alpha_bonf], collapse = "; ")` (labels: method,
#' architecture, $h^2$; $p$ in the chunk above). BayesB at the oligogenic architecture
#' and $h^2 = 0.5$ is the contrast the opening of this section singles out on general grounds (the regime
#' the point-mass prior exists for), not a registered one; every other contrast was read off the table afterwards,
#' and the statements about them here are exploratory. The two BayesA
#' differences at $h^2 = 0.2$ are negative in both architectures
#' (`r f4(pA2[["BayesA - GBLUP"]])` polygenic, `r f4(oB2[["BayesA - GBLUP"]])` oligogenic;
#' $p$ = `r round(pv[["A polygenic 0.2"]], 3)` and `r round(pv[["A oligogenic 0.2"]], 3)`,
#' unadjusted). Against the Bonferroni threshold the polygenic one
#' `r if (pv[["A polygenic 0.2"]] < alpha_bonf) "passes" else "does not pass"` and the oligogenic one
#' `r if (pv[["A oligogenic 0.2"]] < alpha_bonf) "passes" else "does not pass"`; the sweep
#' cannot say whether BayesA loses at $h^2 = 0.2$, only that the sign is the same in both
#' architectures.
#' 
#' The polygenic result is not evidence that the alphabet rarely helps. It is
#' @sec-genpred-truth restated: on the polygenic arm the trait was *generated* from
#' one shared marker variance, so GBLUP's prior is the true one and no competitor can
#' do better than match it. What the cells support is the narrower statement that
#' BayesB's difference from GBLUP is within
#' `r round(max(abs(tt[c("B polygenic 0.2", "B polygenic 0.5", "B oligogenic 0.2")])), 1)`
#' standard errors of zero in every cell except the oligogenic one at $h^2 = 0.5$, where it
#' is positive. One oligogenic
#' architecture and two heritabilities do not establish how either method behaves for other
#' architectures.
#' 
#' ### `pi` was fixed, not tuned {#sec-genpred-pi}
#' 
#' A real analyst does not know the true sparsity in advance. `genpred`'s second
#' sweep holds the oligogenic architecture and $h^2 = 0.5$ fixed and only moves
#' `pi`, on `r length(unique(sens$rep))` replicate splits per value of `pi`, the same
#' `r length(unique(sens$rep))` (noise, split) draws for every value, so differences between
#' rows are paired (@tbl-genpred-pi):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-genpred-pi
#| tbl-cap: "BayesB accuracy as `pi` moves from far too lenient toward the true sparsity (3 causal markers of 2000, nominal $\\pi = 0.9985$; the sweep stops at 0.995). Mean, standard deviation and standard error over 8 paired splits at $h^2 = 0.5$, oligogenic architecture."
#| echo: false
pit <- aggregate(BayesB ~ pi, sens, function(x) c(n = length(x), mean = mean(x), sd = sd(x), se = se(x)))
knitr::kable(fmt(data.frame(pi = pit$pi, pit$BayesB), 4))

#' 
## -----------------------------------------------------------------------------
#| label: genpred-pi-paired
wide <- reshape(sens, idvar = "rep", timevar = "pi", direction = "wide")
d_top <- wide[["BayesB.0.995"]] - wide[["BayesB.0.5"]]
d_95  <- wide[["BayesB.0.995"]] - wide[["BayesB.0.95"]]

#' 
#' Over the sweep the mean accuracy rises with `pi` at each step (@tbl-genpred-pi). The
#' paired difference between `pi` = 0.995 and 0.5 is `r f4(mean(d_top))`
#' (s.e. `r f4(se(d_top))`), and between 0.995 and 0.95 `r f4(mean(d_95))`
#' (s.e. `r f4(se(d_95))`), against a split-to-split s.d. of about
#' `r f3(mean(pit$BayesB[, "sd"]))` within a value of `pi`. The sweep never reaches the
#' nominal truth, so it shows that a sparser prior helped up to 0.995, not what happens at
#' 0.9985. The entry for `pi` = 0.95 (`r f3(pit$BayesB[pit$pi == 0.95, "mean"])`) is not the
#' `r f3(mean(subset(acc, arch == "oligogenic" & h2 == 0.5)$BayesB))` of @tbl-genpred-paired for the same
#' architecture, heritability and `pi`: the two sweeps use different seeds and 8 against 15
#' splits, and a difference of that size is within what two such means differ by (split-to-split
#' s.d. about `r f3(mean(pit$BayesB[, "sd"]))`). Accuracy improves as `pi` approaches the
#' sparsity, but the degradation from being off is gradual in this sweep: the loss from
#' `pi` = 0.5, a prior that expects half the markers to matter, is
#' `r f4(mean(d_top))` against 0.995. That reads as `pi` being worth cross-validating
#' rather than agonising over, on this one architecture and heritability.
#' 
#' The obvious alternative is to stop choosing it. BayesC$\pi$ [@habier2011] keeps
#' BayesB's spike-and-slab prior but treats $\pi$ as unknown and estimates it from the
#' data; `bWGR::BayesCpi()` has no `pi` argument and returns an estimate. The bWGR paper
#' [@xavier2019bwgr] lists Metropolis-Hastings among the samplers of the package for
#' BayesC$\pi$ and BayesD$\pi$ without saying which parameter that step updates, so
#' the sampling scheme is not described here. The returned `pi` is the *exclusion*
#' probability (asserted below: the mean of the returned inclusion probabilities `d`
#' plus `pi` is 1). Fit it to both architectures, five seeds each, beside BayesB at the fixed
#' $\pi = 0.95$ on the oligogenic trait (@tbl-genpred-cpi):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-genpred-cpi
#| tbl-cap: "Mean and standard deviation over five seeds (BayesC$\\pi$ seeds $200 + s$ and $300 + s$, BayesB seeds $400 + s$) of the estimated exclusion probability $\\hat\\pi$ on the polygenic and the oligogenic trait, and of the candidate accuracy of BayesC$\\pi$ and of BayesB at $\\pi = 0.95$ on the oligogenic trait."
cpi <- t(sapply(1:5, function(s) {
  set.seed(200 + s); cp <- BayesCpi(y[train],    M[train, ], it = 1500, bi = 500, df = 5, R2 = 0.5)
  set.seed(300 + s); co <- BayesCpi(y_ol[train], M[train, ], it = 1500, bi = 500, df = 5, R2 = 0.5)
  set.seed(400 + s); ob <- BayesB(y_ol[train], M[train, ], it = 1500, bi = 500,
                                  pi = 0.95, df = 5, R2 = 0.5)
  stopifnot(abs(mean(co$d) + co$pi - 1) < 1e-6)
  c(pi_hat_polygenic  = cp$pi,    # nominal truth: 0 (all 2000 markers carry an effect)
    pi_hat_oligogenic = co$pi,    # nominal truth: 0.9985
    acc_BayesCpi_oligogenic = cor(as.numeric(M[cand, ] %*% co$b), g_ol[cand]),
    acc_BayesB_pi0.95_oligogenic = cor(as.numeric(M[cand, ] %*% ob$b), g_ol[cand]))
}))
knitr::kable(fmt(t(rbind(mean = colMeans(cpi), sd = apply(cpi, 2, sd))), 4))

#' 
#' The estimated exclusion probability is `r f3(mean(cpi[, "pi_hat_polygenic"]))` for the trait with
#' 2000 causal markers and `r f3(mean(cpi[, "pi_hat_oligogenic"]))` for the effectively monogenic one
#' (s.d. `r f3(sd(cpi[, "pi_hat_polygenic"]))` and `r f3(sd(cpi[, "pi_hat_oligogenic"]))` over five
#' seeds): the same value for both, far from either nominal truth. The accuracy on the oligogenic trait is
#' `r f3(mean(cpi[, "acc_BayesCpi_oligogenic"]))` for BayesC$\pi$ against
#' `r f3(mean(cpi[, "acc_BayesB_pi0.95_oligogenic"]))` for BayesB at the fixed $\pi = 0.95$, which
#' is a fixed guess rather than the nominal truth. With 375 records and
#' 2000 markers little in the data seems to speak to $\pi$ specifically -- the training
#' rows have only `r rank_train` independent dimensions (@eq-genpred-rank) -- but this chapter
#' did not decompose the estimate into prior and data. On this evidence estimating $\pi$ is
#' not a substitute for choosing it here, and the sweep above remains the route used.
#' 
#' ## From GEBVs to `stage1_build()` {#sec-genpred-handoff}
#' 
#' Everything above ends where @sec-simulating-crosses's contract begins. Training
#' happened once, on the historical population's markers and phenotypes; the
#' candidates below never contributed a phenotype to that fit, and their predicted
#' values are produced entirely from marker dosages. The contract
#' (@tbl-stage1-contract; `R/10_stage1.R`) takes `X`, `ped` and `traits` with one row per
#' hybrid and `traits` an $N \times$ `n_traits` matrix of standardised predicted values;
#' `stage1_build()` itself adds the id column. So the hand-off has to cut `X` and `ped` to
#' the candidates along with the predictions, pass one column per trait without an id
#' column, and accept that the result is a candidate pool of 250 hybrids with ids
#' renumbered $1, \dots, 250$ (the line ids are kept), not the 625: the 375 training hybrids
#' are not in it, and $N$ becomes 250 for any later chapter fed this object:
#' 
## -----------------------------------------------------------------------------
#| label: genpred-handoff
cand_X   <- ctx$X[cand, ]
cand_ped <- ctx$ped[cand, ]
traits_B <- data.frame(trait1 = as.numeric(scale(predB)))   # one trait, standardised
s1 <- stage1_build(cand_X, cand_ped, traits_B)
stopifnot(nrow(s1[["X"]]) == length(cand),
          dim(s1[["f"]]) == rep(length(cand), 2),
          identical(names(s1[["hybrids"]]), c("hybrid", "line_A", "line_B", "trait1")),
          identical(s1[["hybrids"]][["hybrid"]], seq_along(cand)),
          identical(s1[["hybrids"]][["line_A"]], as.integer(cand_ped$a)))
head(s1[["hybrids"]])

#' 
#' Two things the contract carries that this chunk does not do. First, it is one trait:
#' `ctx$index`, which every later chapter selects on, is a single index built by
#' `build_ctx()` from the standardised multi-trait matrix (@sec-simulating-crosses), and
#' the multi-trait fit that would give it -- one fit per trait, then the index step -- is not
#' run here. Second, passing all 625 rows (training hybrids included) would need their
#' predicted values, which are in-sample fits, not predictions.
#' 
#' The second consumer of predicted values is `ocs_quadprog(f, gebv, lambda, ...)` of
#' @sec-ocs, whose argument `gebv` is a merit vector with a coancestry matrix `f` of the same
#' dimension; `s1[["f"]]` and the 250 predictions have that shape, and this chapter does
#' not run it. Its `lambda` is the optimal contribution selection (OCS) penalty on coancestry, not the
#' $\lambda = \sigma^2_e/\sigma^2_u$ of the mixed model equations (@eq-genpred-mme).
#' 
#' Carry the reliabilities with them. @tbl-genpred-cv (the implied accuracy, the square root of the mean reliability) is the argument for
#' storing `fit$rel` next to every predicted value rather than discarding it: a
#' candidate whose GEBV is unreliable is not a bad candidate, it is an unmeasured
#' one, and the difference matters to a selection decision.
#' 
#' ## Back to Finding 5: a measured accuracy, not an assumed one
#' 
#' @sec-choosing-error's Finding 5 assumed a *nominal* prediction accuracy
#' $r \in \{0.5, 0.7, 0.9, 1\}$, the weight of the true index $u$ in a simulated
#' prediction (the realised correlation differs from $r$ in every seed, as that chapter
#' reports), with the error correlated with relatedness. The accuracies measured here are
#' *realised* correlations of a fitted GBLUP with the true value of one trait, `g` =
#' `ctx$traits[, 1]`, not with the three-trait standardised index of that chapter, so the
#' comparison below is of orders of magnitude only. The mean accuracies of
#' @tbl-genpred-cv, at 289 training records, are `r f3(cvm[["CV2"]])` for CV2,
#' `r f3(cvm[["CV1"]])` for CV1 and `r f3(cvm[["CV0"]])` for CV0, on one simulated population
#' and one trait. CV2 falls between 0.9 and 1 of Finding 5's grid and CV1 between 0.5 and 0.7;
#' CV0 falls below the grid. (The accuracy of the opening split, `r f3(acc9)`, is one draw
#' with 375 records and is not the CV2 figure.) Which of the three schemes a programme faces is
#' not in these data: it depends on how the programme builds its training set. Published
#' accuracies in the same design are higher for the hard schemes -- @sec-mating-genomic records
#' grain-yield accuracies of 0.91, 0.85 and 0.77 for T2, T1 and T0 [@technow2014] against
#' simulated T0 accuracies of 0.10 to 0.15 there, and attributes the gap to family structure that
#' the simulated generator lacks -- so the CV0 of this chapter is not a forecast for a real
#' programme, and nothing here says that the low end of Finding 5's grid is the realistic one.
#' 
#' The errors are structured by relatedness rather than white. The statistic is the Pearson
#' correlation, over the pairs of candidates, between the product of the two candidates'
#' prediction errors and their molecular coancestry $f$; it was computed for each of the 40
#' draws of @sec-genpred-reliability's chunk, and on the opening split it is compared with its
#' distribution under random relabelling of the candidates (500 permutations of the rows and
#' columns of $f$ together, which keeps the dependence among pairs; @tbl-genpred-errstructure):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-genpred-errstructure
#| tbl-cap: "Correlation between the product of two candidates' prediction errors and their coancestry $f$, over candidate pairs. `opening_split`: the opening split; `mean_40_draws`, `sd_40_draws`: over the 40 draws of @tbl-genpred-seeds; `null_mean`, `null_sd`, `null_max`: the opening split under 500 permutations of the candidate labels."
err   <- g[cand] - u_hat[cand]
fcand <- ctx[["f"]][cand, cand]
ut    <- upper.tri(fcand)
prod_err <- outer(err, err)[ut]
obs_err  <- cor(prod_err, fcand[ut])
set.seed(41)
null_err <- replicate(500, { p <- sample(length(cand)); cor(prod_err, fcand[p, p][ut]) })
es <- c(opening_split = obs_err, mean_40_draws = mean(R40[, "err_f"]), sd_40_draws = sd(R40[, "err_f"]),
        null_mean = mean(null_err), null_sd = sd(null_err), null_max = max(null_err))
knitr::kable(fmt(data.frame(statistic = names(es), value = es, row.names = NULL), 4))

#' 
#' On the opening split the statistic is `r f3(obs_err)`; over the 40 draws it is
#' `r f3(mean(R40[, "err_f"]))` (s.d. `r f3(sd(R40[, "err_f"]))`), and the permutation null has
#' mean `r f4(mean(null_err))`, s.d. `r f4(sd(null_err))` and maximum `r f4(max(null_err))`. Pairs of
#' candidates that are more related therefore have more correlated prediction errors, as
#' Finding 5 assumed, in this simulation. The pairs are not independent, so the permutation
#' distribution is a reference, not a sampling distribution for a formal test, and the
#' statistic was not compared with the value that the error generator of Finding 5 imposes, so
#' this chapter does not say whether the correlation here is smaller or larger than that. That a
#' less related or smaller training set would push it higher is a hypothesis, not measured
#' here.
#' 
#' ::: {.callout-note}
#' ## What this chapter still does not model
#' 
#' Closing the "traits are given" gap opens several more, named here so they are
#' not silently dropped:
#' 
#' - **Marker panel = causal set.** The trait is generated from the markers the
#'   models are given, so every causal locus is genotyped and there is no linkage
#'   disequilibrium between marker and QTL. Every accuracy in this chapter is a best
#'   case in that respect; the finite accuracy here comes from training size, noise and the
#'   rank bound of @eq-genpred-rank, not from a marker-QTL gap.
#' - **Specific combining ability.** @sec-genpred-truth showed there is none in
#'   `ctx$traits` to find: the trait is additive by construction, so a hybrid's
#'   value is exactly the mean of its parents'. SCA is not merely unmodelled here,
#'   it is absent from the data. A real hybrid programme has it -- the dominance
#'   effects of @sec-heterosis-gca-sca are where it comes from -- and would fit GCA and
#'   SCA jointly rather than one additive effect per marker; this chapter fits one
#'   additive kernel only.
#' - **One architecture, one noise stream per cell.** The oligogenic arm is one draw of
#'   three effects (effectively monogenic), the polygenic arm one draw of `ctx$traits`;
#'   replication in every table is over noise and splits, not over architectures. The
#'   `pi` sweep has 8 replicates per value and BayesC$\pi$ 5 seeds. Gibbs chains are
#'   seeded, but a different seed moves BayesA's marker variance by an order of magnitude
#'   (@sec-genpred-bayes).
#' - **Estimated variance components.** $h^2$ is supplied to `gblup()`, never
#'   estimated, and $\lambda$ takes $\sigma^2_u = 1$ where the standardisation implies
#'   about 1.11. A real fit gets $\lambda$ from REML on the training data, and the
#'   implied accuracies of @sec-hybrid-cv inherit that estimate's uncertainty.
#' - **Multivariate prediction.** `ctx$traits` has three correlated columns; this
#'   chapter predicted one. A multi-trait Bayesian model borrows information
#'   across traits and should out-predict fitting each one separately, especially
#'   for the traits with less training data.
#' - **Forward validation.** @sec-hybrid-cv splits by line, which is the right
#'   axis for a factorial, but every scheme in it still samples training and
#'   candidates from one generation. A programme selecting for the future
#'   validates forward in time, on a later cycle than it trained on.
#' - **Retraining across cycles.** @sec-cycles runs the *selection* side of a
#'   multi-cycle programme with a fixed, perfect index. A model trained once and
#'   never updated goes stale as the population it predicts drifts from the
#'   population it was trained on.
#' - **Genotyping cost and marker density.** Accuracy was measured here at a
#'   fixed `r book_cfg$m` markers; a real programme trades marker density against
#'   genotyping cost per individual, not just against training-set size.
#' :::
