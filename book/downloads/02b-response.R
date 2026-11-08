#' # Response to selection: the other half of the objective {#sec-response}
#' 
# 02b-response -- standalone script of the chapter 02b-response.qmd
# Book: https://ederdbs.github.io/QG/02b-response.html
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

# Every configuration number quoted in the prose and the captions comes from here.
cfg <- list(seed = 1, fst = 0.15, n_qtl = 300, h2 = 0.5, n_sel = 60,
            n_seeds = 30, n_mc = 4000, seed_mc = 11,
            seed_d = 7, d_mean = 0.3, d_sd = 0.1, seed_gain = 21)
N_hyb <- book_cfg$n_pool_A * book_cfg$n_pool_B        # complete A x B factorial
cfg_txt <- sprintf("%d + %d lines, %d markers, %d QTL, $h^2 = %g$, Balding-Nichols `fst` = %g",
                   book_cfg$n_pool_A, book_cfg$n_pool_B, book_cfg$m,
                   cfg$n_qtl, cfg$h2, cfg$fst)

# Exact algebraic identities are asserted to a relative deviation of 1e-12:
# double precision (2.2e-16) times the ~1e3 terms summed in the largest sums here.
# Deviation = max |x - y| / max(1, max |y|). The achieved value is printed next
# to each identity.
tol_exact <- 1e-12
n_blk     <- 200      # seeds of the disjoint block, n_seeds + 1 ... n_seeds + n_blk
dev_rel   <- function(x, y) max(abs(x - y)) / max(1, abs(y))

#' 
#' The preceding chapters define what a selection programme spends: coancestry
#' (@sec-coancestry) and its partition over the two heterotic pools
#' (@sec-subdivided), within the programme of @sec-hybrid-programme. None of them
#' writes down what selection *buys*. This chapter follows @sec-subdivided because
#' that chapter leaves two things to it: it names the component $GD_{BI}$ of gene
#' diversity ($GD$) as the raw material of
#' the next cycle's response without saying how response depends on it, and it
#' defers the genic-variance argument for a mixture base. @sec-response-genic
#' carries both, and item 3 of the Preface (the diversity that
#' protects response is the within-pool part) is what that section establishes.
#' 
#' The asymmetry is not cosmetic. @sec-cycles will report a constrained programme
#' overtaking an unconstrained one after several cycles, at a crossover cycle that
#' varies with the simulation seed. The book can report that because it simulated
#' it, not because anything in the preceding chapters predicts it, and this chapter
#' does not predict it either: a reader who wants to know when a crossover arrives
#' in *their* programme still has to re-run the simulation with their own
#' parameters. What this chapter installs are the pieces a prediction would be
#' built from: the variance selection acts on, the equation that turns that
#' variance into response, and the restricted selection index, which is set beside
#' the book's $\alpha$ constraint at the end of the chapter (as a comparison, not as
#' its proof).
#' 
#' The data come from `simulate_pools()`, the generator that @sec-simulating-crosses
#' sets beside its own `simulate_lines()` and `simulate_data()`: it uses the same
#' pool allele frequencies, drawn under the Balding-Nichols model [@balding1995]
#' with parameter `fst` from ancestral frequencies, the same homozygous lines `GL`
#' (0/1) and the same complete A $\times$ B factorial of hybrids `X` (0/0.5/1),
#' but a different trait. Its trait has `n_qtl` markers taken at
#' random as quantitative trait loci (QTL) with independent standard-normal effects
#' `beta` (zero elsewhere), and an `index` equal to the standardised true genetic
#' value plus independent normal noise of variance $1/h^2 - 1$, then standardised:
#' before that last step the genetic value has unit variance, so $h^2$ is the share
#' of the index variance it contributes in expectation. @tbl-response-data gives
#' the size of the draw used in the rest of the chapter.
#' 
## -----------------------------------------------------------------------------
#| label: sim
# @sec-simulating-crosses calls the generators with book_cfg's fst and seed
stopifnot(cfg$fst == book_cfg$fst, cfg$seed == book_cfg$seed)
sim <- simulate_pools(n_A = book_cfg$n_pool_A, n_B = book_cfg$n_pool_B,
                      m = book_cfg$m, fst = cfg$fst, n_qtl = cfg$n_qtl,
                      h2 = cfg$h2, seed = cfg$seed)
X  <- sim$X                       # N x m hybrids, 0/0.5/1
stopifnot(nrow(X) == N_hyb)
# the lines are those of @sec-simulating-crosses' simulate_lines() at this fst and seed
stopifnot(identical(2 * sim$GL, simulate_lines(utils::modifyList(
  book_cfg, list(fst = cfg$fst, seed = cfg$seed)))))
gv <- drop(X %*% sim$beta)        # true genetic value, known here by construction
I  <- sim$index                   # what the breeder actually sees

#' 
## -----------------------------------------------------------------------------
#| include: false
cap_data <- sprintf("Size of the simulated data set of this chapter: hybrids of the complete %d $\\times$ %d factorial of pools A and B, markers, and quantitative trait loci (markers with a non-zero effect) of the `simulate_pools()` draw with seed %d (`fst` = %g, $h^2 = %g$). Counts.", book_cfg$n_pool_A, book_cfg$n_pool_B, cfg$seed, cfg$fst, cfg$h2)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-response-data
#| tbl-cap: !expr cap_data
data.frame(quantity = c("hybrids", "markers", "QTL (markers with non-zero effect)"),
           count = c(nrow(X), ncol(X), sum(sim$beta != 0)))

#' 
#' ## The breeder's equation, and how well it does here
#' 
#' Response to one round of truncation selection is
#' 
#' $$R \;=\; i \, r \, \sigma_A$$ {#eq-response-breeders}
#' 
#' with $i$ the selection intensity (a property of the selected fraction alone),
#' $r$ the accuracy of the criterion as a predictor of genetic value, and
#' $\sigma_A$ the additive standard deviation [@falconer1996].^[No chapter locator is
#' given: the book was not available to check one.] The equation is used here
#' in the accuracy form $i\,r\,\sigma_A$, which for $r = h$ is the familiar
#' $i\,h\,\sigma_A$. Here the genetic value
#' of the hybrids is the vector $\mathbf{X}\boldsymbol\beta$ (`gv`), purely additive in the
#' marker coding by construction of `simulate_pools()` (no dominance, $d_k \equiv 0$),
#' so the genotypic value of a hybrid equals its additive value and $\sigma_A$ is
#' estimated by `sd(gv)`. `sel_intensity()` returns $i$; later chapters use it inside the
#' usefulness criterion (@sec-stages) and, in @sec-alphasimr, in a replicated check
#' of an equation of this form on a different object. @tbl-response-breeders sets
#' the predicted response of @eq-response-breeders beside the realised one for the
#' top `r cfg$n_sel` hybrids on the index.
#' 
#' **What "response" means in this chapter.** The realised response is the mean
#' genetic value of the selected hybrids minus the mean over all candidates: the
#' genetic selection differential on the hybrids that were selected, not the change
#' transmitted to a next generation. In the programme of @sec-hybrid-programme the
#' hybrids are not recycled, lines are (assumption A3 there), so what a cycle
#' transmits is a line's value against a tester pool, a different object from the
#' differential measured here. The comparison of @tbl-response-breeders therefore asks one thing: whether
#' @eq-response-breeders reproduces the genetic selection differential of
#' truncation selection on this generator. It is not a test of the response
#' transmitted across cycles.
#' 
## -----------------------------------------------------------------------------
#| include: false
cap_breeders <- sprintf("One round of truncation selection of the top %d of the %d hybrids on the index (`simulate_pools()`, %s, seed %d). $i$: normal-theory selection intensity of the selected fraction; $r$: correlation between index and true genetic value; $\\sigma_A$: standard deviation of the true genetic value; predicted: $i\\,r\\,\\sigma_A$ (@eq-response-breeders); realised: mean genetic value of the selected minus that of all hybrids. Genetic values in simulation units.", cfg$n_sel, N_hyb, cfg_txt, cfg$seed)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-response-breeders
#| tbl-cap: !expr cap_breeders
n_sel <- cfg$n_sel
N     <- nrow(X)
i_norm <- sel_intensity(n_sel / N)
r      <- cor(I, gv)
sel    <- order(I, decreasing = TRUE)[seq_len(n_sel)]

fmt(data.frame(
  quantity = c("intensity i", "accuracy r", "additive s.d. (sim. units)",
               "predicted response (sim. units)", "realised response (sim. units)"),
  value    = c(i_norm, r, sd(gv), i_norm * r * sd(gv), mean(gv[sel]) - mean(gv))), 3)

#' 
#' In this single draw (seed `r cfg$seed`) the equation overpredicts, by about `r round(100 * (1 - (mean(gv[sel]) - mean(gv)) / (i_norm * r * sd(gv))))` percent. @tbl-response-gap splits that gap into the intensity and the regression
#' parts.
#' 
## -----------------------------------------------------------------------------
#| include: false
cap_gap <- sprintf("The gap of @tbl-response-breeders split into intensity and regression parts (same draw, seed %d). Intensities: normal-theory value of the selected fraction and realised standardised selection differential on the index. Responses: @eq-response-breeders with the realised intensity; the regression of genetic value on the index times the selection differential; the realised response. Last row: skewness of the standardised index. Responses in simulation units.", cfg$seed)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-response-gap
#| tbl-cap: !expr cap_gap
i_real <- (mean(I[sel]) - mean(I)) / sd(I)
b      <- cov(gv, I) / var(I)                 # regression of value on criterion
fmt(data.frame(
  quantity = c("intensity, normal theory", "intensity, realised",
               "response with realised intensity (sim. units)",
               "response from regression (sim. units)",
               "realised response (sim. units)", "index skewness"),
  value    = c(i_norm, i_real, i_real * r * sd(gv),
               b * (mean(I[sel]) - mean(I)), mean(gv[sel]) - mean(gv),
               mean(scale(I)^3))), 3)

#' 
#' Two identities can be read off it. (1) The response from regression and the
#' response with realised intensity are the same quantity written twice, since
#' $b\,S_I = i_{\text{real}}\,r\,\sigma_A$ identically (with $b = \operatorname{Cov}(\mathrm{gv}, I)/\operatorname{Var}(I)$,
#' $S_I$ the selection differential on the index, $i_{\text{real}} = S_I/\operatorname{sd}(I)$,
#' $r = \operatorname{Cov}(\mathrm{gv}, I)/(\operatorname{sd}(\mathrm{gv})\operatorname{sd}(I))$ and
#' $\sigma_A = \operatorname{sd}(\mathrm{gv})$, all on the $N - 1$ scale, which cancels).
#' (2) The regression residual $e = \mathrm{gv} - \overline{\mathrm{gv}} - b\,(I - \bar I)$
#' has mean zero over the candidates, so the realised response minus the response
#' from regression is exactly the mean residual over the selected set,
#' $\bar e_{\text{sel}}$: the part of the gap that is not an intensity effect is
#' the selected hybrids' average departure from the linear regression of
#' genetic value on the index. The chunk below asserts both, to the relative
#' tolerance `r fmt_sci(tol_exact, 1)` of the setup.
#' 
## -----------------------------------------------------------------------------
#| label: response-identity
S_I  <- mean(I[sel]) - mean(I)
e    <- (gv - mean(gv)) - b * (I - mean(I))
dev1 <- dev_rel(b * S_I, i_real * r * sd(gv))
dev2 <- dev_rel((mean(gv[sel]) - mean(gv)) - b * S_I, mean(e[sel]))
stopifnot(dev1 < tol_exact, dev2 < tol_exact, abs(mean(e)) < tol_exact)

#' 
#' Deviations: identity (1) `r if (dev1 == 0) "exactly 0" else fmt_sci(dev1)`, identity (2) `r fmt_sci(dev2)`; the
#' mean residual over the selected hybrids is `r fmt(mean(e[sel]), 3)` simulation
#' units.
#' 
#' With $N =$ `r N` candidates and $n =$ `r n_sel` selected,
#' $i = \varphi(z)/(n/N)$, with $z$ the standard-normal truncation point that
#' leaves a fraction $n/N$ above it and $\varphi$ the standard-normal density, is
#' the intensity of an infinitely large normal population [@falconer1996].
#' At this finite $N$ the expected standardised
#' mean of the top $n$ of $N$ independent normal draws is smaller. A single draw
#' cannot tell whether the remaining gap is structural or sampling, so
#' @tbl-response-replicated repeats the same `simulate_pools()` call over `r cfg$n_seeds` seeds,
#' and the finite-$N$ intensity is estimated from `r cfg$n_mc` normal samples.
#' 
## -----------------------------------------------------------------------------
#| include: false
cap_rep <- sprintf("The single draw of @tbl-response-breeders repeated over seeds 1 to %d of the same `simulate_pools()` call (%s; top %d of %d hybrids on the index). Per quantity: mean over seeds, standard error of that mean (s.d./$\\sqrt{%d}$), minimum and maximum. Relative gap: $1 -$ realised/predicted response (@eq-response-breeders), dimensionless; realised intensity: standardised selection differential on the index; skewness of the standardised index.", cfg$n_seeds, cfg_txt, cfg$n_sel, N_hyb, cfg$n_seeds)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-response-replicated
#| tbl-cap: !expr cap_rep
one_seed <- function(s) {
  sm <- simulate_pools(n_A = book_cfg$n_pool_A, n_B = book_cfg$n_pool_B,
                       m = book_cfg$m, fst = cfg$fst, n_qtl = cfg$n_qtl,
                       h2 = cfg$h2, seed = s)
  g  <- drop(sm$X %*% sm$beta)
  Ix <- sm$index
  top <- order(Ix, decreasing = TRUE)[seq_len(n_sel)]
  pred <- sel_intensity(n_sel / length(Ix)) * cor(Ix, g) * sd(g)
  c(rel_gap = 1 - (mean(g[top]) - mean(g)) / pred,
    i_real  = (mean(Ix[top]) - mean(Ix)) / sd(Ix),
    skew    = mean(scale(Ix)^3))
}
rep_seeds <- t(vapply(seq_len(cfg$n_seeds), one_seed, numeric(3)))
n_rep  <- nrow(rep_seeds)
gap_se <- sd(rep_seeds[, "rel_gap"]) / sqrt(n_rep)
stopifnot(abs(mean(rep_seeds[, "rel_gap"])) < 2 * gap_se)   # the claim below

set.seed(cfg$seed_mc)
i_finite <- replicate(cfg$n_mc, {
  z <- rnorm(N)
  (mean(sort(z, decreasing = TRUE)[seq_len(n_sel)]) - mean(z)) / sd(z)
})

fmt(data.frame(
  quantity = c("relative gap 1 - realised/predicted", "realised intensity",
               "index skewness"),
  `mean over seeds` = colMeans(rep_seeds),
  `s.e.`            = apply(rep_seeds, 2, sd) / sqrt(n_rep),
  minimum           = apply(rep_seeds, 2, min),
  maximum           = apply(rep_seeds, 2, max),
  row.names = NULL, check.names = FALSE), 3)

#' 
#' The `stopifnot()` in that chunk asserts the chapter's own claim, not an identity,
#' so its error rates are computed, not assumed. The rule is $|\bar g| < 2\,\mathrm{s.e.}$
#' with the s.e. estimated from the same $n =$ `r n_rep` seeds. If the true mean gap is zero and
#' the per-seed gaps are normal, $\bar g/\mathrm{s.e.}$ follows a $t$ distribution with
#' $n - 1$ degrees of freedom, and the rule fails to hold (a false alarm that stops
#' the render under a different seed set) with probability $P(|t_{n-1}| > 2)$.
#' Against a true bias $\delta$ the ratio is non-central $t$ with parameter
#' $\delta\sqrt{n}/s$, $s$ the per-seed s.d. of the gap.
#' 
## -----------------------------------------------------------------------------
#| label: response-gap-error-rates
s_gap    <- sd(rep_seeds[, "rel_gap"])
p_accept <- function(delta) {          # P(rule holds) at a true mean gap delta
  ncp <- delta * sqrt(n_rep) / s_gap
  pt(2, n_rep - 1, ncp = ncp) - pt(-2, n_rep - 1, ncp = ncp)
}
false_alarm <- 1 - p_accept(0)
delta80     <- uniroot(function(d) (1 - p_accept(d)) - 0.8, c(0, 10 * s_gap))$root
stopifnot(isTRUE(all.equal(false_alarm, 2 * pt(-2, n_rep - 1))))

#' 
#' That is a false-alarm rate of `r fmt(100 * false_alarm, 1)` percent, about one
#' seed set in `r round(1 / false_alarm)`. The assertion fails (flags a bias) with
#' probability 0.8 only when the true mean gap is `r fmt(delta80, 3)` in relative
#' gap (`r fmt(100 * delta80, 1)` percent of the predicted response), using this
#' sample's per-seed s.d. of `r fmt(s_gap, 3)`; smaller true biases are flagged
#' less often. A passing assertion therefore excludes biases of about that size
#' and above, not smaller ones.
#' 
#' Over the `r n_rep` seeds the mean relative gap is `r fmt(mean(rep_seeds[, "rel_gap"]), 3)`
#' (standard error `r fmt(gap_se, 3)`), the
#' prediction exceeds the realised response in `r sum(rep_seeds[, "rel_gap"] > 0)`
#' of `r n_rep` seeds, and the mean realised intensity is
#' `r fmt(mean(rep_seeds[, "i_real"]), 3)` against a finite-$N$ normal expectation
#' of `r fmt(mean(i_finite), 3)` (s.d. `r fmt(sd(i_finite), 3)`) and the
#' infinite-population value `r fmt(i_norm, 3)`.
#' 
#' The replicated mean gap is within two standard errors of zero, so at this scale
#' the seed-`r cfg$seed` overprediction is consistent with sampling variation. What `r n_rep` seeds
#' can resolve is limited: two standard errors of the mean gap are
#' `r fmt(2 * gap_se, 3)`, so a mean relative gap smaller than about that cannot be
#' excluded, and the result is the absence of a detectable gap above that size, not
#' a proof that the gap is zero. The two sizes, `r fmt(delta80, 3)` and
#' `r fmt(2 * gap_se, 3)`, answer different questions and are not two estimates of
#' one bound: the first is the true mean gap that the rule above flags with
#' probability 0.8 (its power, at this sample's per-seed s.d.), the second is two
#' standard errors of the observed mean gap, the threshold of the rule itself.
#' In a normal approximation the first is the threshold plus
#' `r fmt(qnorm(0.8), 2)` standard errors, that is `r fmt((2 + qnorm(0.8)) / 2, 2)`
#' times the second; the non-central $t$ computation above gives
#' `r fmt(delta80 / (2 * gap_se), 2)` times. (The seed-`r cfg$seed` draw is one of the `r n_rep` seeds, not an
#' independent replicate.) Limits of scope: only the teaching scale
#' (`r cfg_txt`) was measured, so nothing here
#' says how the gap behaves at production scale or under selection across cycles;
#' the object is the genetic selection differential of the selected hybrids on an
#' additive trait (see the definition of response before @tbl-response-breeders), not a transmitted response.
#' The replicated sweep of @sec-alphasimr tests the equation on a different object,
#' the change in the progeny mean, with $r$ taken against the breeding value
#' because that trait has dominance, so it is not a replication of this check and
#' its numbers are not reproduced here.
#' 
#' ## Genic variance, and what it has to do with gene diversity {#sec-response-genic}
#' 
#' The additive variance in @eq-response-breeders is not a fixed property of the
#' population. Split it in two.
#' 
#' **Genic variance** is what the loci would contribute if they were independent:
#' 
#' $$V_{\text{genic}} \;=\; \sum_k \beta_k^2 \operatorname{Var}(x_k)$$ {#eq-response-genic}
#' 
#' with $\beta_k$ the effect of marker $k$ and $x_k$ its hybrid genotype. This is a
#' definition of the chapter, not a result attributed to a source.
#' 
#' **Realised variance** is what the population actually has, $\operatorname{Var}
#' (\mathbf{X}\boldsymbol\beta)$, which is the sum of the *whole* covariance matrix
#' rather than only its diagonal. The difference is exactly the covariance term
#' of @eq-response-ld, an identity of the covariance matrix that needs no source:
#' 
#' $$\operatorname{Var}(\mathbf{X}\boldsymbol\beta) - V_{\text{genic}}
#' \;=\; 2\sum_{k<l}\beta_k\beta_l \operatorname{Cov}(x_k, x_l)$$ {#eq-response-ld}
#' 
#' @bulmer1971 is the reference for the mechanism by which *selection* makes this
#' term negative (negative gametic-phase disequilibrium among trait loci, which
#' lowers the additive variance below its genic value); the primary text was not
#' read for this book, and the statement is reported, not checked. The term that
#' @tbl-response-genic evaluates for the seed-`r cfg$seed` draw is a different thing, and
#' three assumptions decide what it is. (i) In `simulate_pools()` the genotypes of
#' the lines are drawn independently across loci given the pool frequencies. (ii)
#' No selection precedes the evaluation. (iii) Each pool has finitely many lines
#' (`r book_cfg$n_pool_A` + `r book_cfg$n_pool_B` here). Over the complete A $\times$ B factorial, an identity of the
#' design, $\operatorname{Cov}(x_k, x_l) = [\operatorname{Cov}_A(u_k, u_l) +
#' \operatorname{Cov}_B(v_k, v_l)]/4$, with $\operatorname{Cov}_A$ and
#' $\operatorname{Cov}_B$ the covariances across the lines of each pool (up to the
#' $N$ against $N - 1$ divisor), so no between-pool term enters. Under (i) and (ii)
#' each of the two pool covariances has expectation zero, so the term of the table
#' is the sampling covariance among loci of `r book_cfg$n_pool_A` + `r book_cfg$n_pool_B` founder lines, with expectation
#' zero; by (iii) it is not zero in a draw, and its sign and size change with the
#' seed. The seed-`r cfg$seed` value therefore cannot be read as the size or the sign of a
#' Bulmer effect. Measuring a selection-induced term needs a control in which the
#' same founders are selected at random, which is what @sec-limits does.
#' 
## -----------------------------------------------------------------------------
#| include: false
cap_genic <- sprintf("Realised variance $\\operatorname{Var}(\\mathbf{X}\\boldsymbol\\beta)$, genic variance (@eq-response-genic, `genic_var()`) and their difference, the covariance term of @eq-response-ld (here the sampling covariance among loci of the %d + %d founder lines, expectation zero), over the %d hybrids of the seed-%d draw (%d + %d lines, %d markers, %d QTL). Variances in squared simulation units.", book_cfg$n_pool_A, book_cfg$n_pool_B, N_hyb, cfg$seed, book_cfg$n_pool_A, book_cfg$n_pool_B, book_cfg$m, cfg$n_qtl)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-response-genic
#| tbl-cap: !expr cap_genic
Cx  <- cov(X)
ld  <- sum(outer(sim$beta, sim$beta) * Cx) - sum(sim$beta^2 * diag(Cx))
V_genic <- genic_var(X, sim$beta)
dev_ld     <- dev_rel(var(gv) - V_genic, ld)
dev_oracle <- dev_rel(V_genic, ref_genic_var(X, sim$beta))
stopifnot(dev_ld < tol_exact, dev_oracle < tol_exact)
fmt(data.frame(
  quantity = c("realised variance", "genic variance", "covariance term"),
  `value (sim. units squared)` = c(var(gv), V_genic, var(gv) - V_genic),
  check.names = FALSE), 4)

#' 
#' Deviations, relative to the larger of 1 and the quantity (tolerance
#' `r fmt_sci(tol_exact, 1)`): of the covariance term from the sum of the
#' off-diagonal covariance matrix (@eq-response-ld) `r fmt_sci(dev_ld)`; of
#' `genic_var()` from the literal oracle `ref_genic_var()` `r fmt_sci(dev_oracle)`.
#' 
#' The design identity for $\operatorname{Cov}(x_k, x_l)$ is asserted next in
#' population-divisor form on the seed-`r cfg$seed` draw, and the distribution of the term is
#' computed over the `r cfg$n_seeds` seeds of @tbl-response-replicated and over a
#' disjoint block of `r n_blk` seeds, so that the reading of the seed-`r cfg$seed` value does
#' not rest on a block that contains it.
#' 
## -----------------------------------------------------------------------------
#| label: response-cov-term
U <- sim$GL[sim$pool == "A", ]
V <- sim$GL[sim$pool == "B", ]
pop_cov <- function(M) cov(M) * (nrow(M) - 1) / nrow(M)       # divisor n
dev_fact <- dev_rel(Cx * (N - 1) / N, (pop_cov(U) + pop_cov(V)) / 4)
stopifnot(dev_fact < tol_exact)

ld_seeds <- seq_len(cfg$n_seeds + n_blk)
ld_by_seed <- t(vapply(ld_seeds, function(s) {
  sm <- simulate_pools(n_A = book_cfg$n_pool_A, n_B = book_cfg$n_pool_B,
                       m = book_cfg$m, fst = cfg$fst, n_qtl = cfg$n_qtl,
                       h2 = cfg$h2, seed = s)
  g  <- drop(sm$X %*% sm$beta)
  vg <- genic_var(sm$X, sm$beta)
  c(term = var(g) - vg, share = (var(g) - vg) / vg)
}, numeric(2)))
blk1 <- ld_by_seed[seq_len(cfg$n_seeds), , drop = FALSE]
blk2 <- ld_by_seed[cfg$n_seeds + seq_len(n_blk), , drop = FALSE]
term_se  <- sd(blk2[, "term"]) / sqrt(n_blk)
z_term   <- mean(blk2[, "term"]) / term_se
# Claim "expectation zero": |z| < 3, false alarm P(|z| > 3) ~ 0.003 per seed set.
stopifnot(abs(z_term) < 3)
stopifnot(dev_rel(ld_by_seed[cfg$seed, "term"], var(gv) - V_genic) < tol_exact)

#' 
#' On the pool covariances, the factorial identity holds to a relative deviation of
#' `r fmt_sci(dev_fact)` (tolerance `r fmt_sci(tol_exact, 1)`). Over seeds 1 to
#' `r cfg$n_seeds` the term has mean `r fmt(mean(blk1[, "term"]), 3)` (s.e.
#' `r fmt(sd(blk1[, "term"]) / sqrt(cfg$n_seeds), 3)`) and is negative in
#' `r sum(blk1[, "term"] < 0)` of them. Over the disjoint seeds
#' `r cfg$n_seeds + 1` to `r cfg$n_seeds + n_blk` its mean is
#' `r fmt(mean(blk2[, "term"]), 3)` (s.e. `r fmt(term_se, 3)`, so
#' $z =$ `r fmt(z_term, 2)`, inside the $\pm 3$ the chunk asserts; false alarm
#' `r fmt(100 * 2 * pt(-3, n_blk - 1), 1)` percent per seed set), and its share of the genic variance has mean
#' `r fmt(mean(blk2[, "share"]), 3)` and s.d. `r fmt(sd(blk2[, "share"]), 3)`. The
#' seed-`r cfg$seed` value, a share of `r fmt(ld_by_seed[cfg$seed, "share"], 3)`, lies
#' `r fmt(abs(ld_by_seed[cfg$seed, "share"]) / sd(blk2[, "share"]), 2)` s.d. from
#' zero: it is the spread of the sampling covariance among loci, not an effect.
#' 
#' How does $V_{\text{genic}}$ relate to gene diversity? Let $p_{Ak}$ and
#' $p_{Bk}$ be the frequencies of the allele coded 1 at locus $k$ among the inbred
#' lines of pools A and B, $q = 1 - p$ (so $\bar q_k = 1 - \bar p_k$), and $\bar p_k = (p_{Ak} + p_{Bk})/2$ the
#' hybrid-pool frequency. A hybrid of the complete A $\times$ B factorial carries
#' $x_k = (u_k + v_k)/2$, with $u_k \in \{0, 1\}$ the allele of its pool-A parent
#' and $v_k \in \{0, 1\}$ that of its pool-B parent (the $u_{ik}$, $v_{jk}$ of
#' @sec-heterosis-gca-sca without the line index), drawn independently from the
#' two pools, so over the factorial (population-variance scale)
#' 
#' $$\operatorname{Var}(x_k) \;=\; \frac{p_{Ak}q_{Ak} + p_{Bk}q_{Bk}}{4}
#' \;=\; \frac{\bar p_k \bar q_k}{2} - \frac{(p_{Ak} - p_{Bk})^2}{8}.$$ {#eq-response-hybrid-var}
#' 
## -----------------------------------------------------------------------------
#| label: response-hybrid-var
pA <- colMeans(U)
pB <- colMeans(V)
pH <- (pA + pB) / 2
v_pop <- colMeans(X^2) - colMeans(X)^2                    # population scale (divisor N)
dev_var1 <- dev_rel(v_pop, (pA * (1 - pA) + pB * (1 - pB)) / 4)
dev_var2 <- dev_rel(v_pop, pH * (1 - pH) / 2 - (pA - pB)^2 / 8)
# scale: genic_var() and var(gv) use the divisor N - 1
dev_scale <- dev_rel(V_genic, N / (N - 1) * sum(sim$beta^2 * v_pop))
# equal effects (beta = 1 at all m loci): sum(v_pop) = m * GD_WS / 4, GD_T = GD_WS + GD_BS
m_loc <- ncol(X)
GD_WS <- mean(pA * (1 - pA) + pB * (1 - pB))
GD_BS <- mean((pA - pB)^2 / 2)
GD_T  <- mean(2 * pH * (1 - pH))
dev_eq1 <- dev_rel(sum(v_pop), m_loc * GD_WS / 4)
dev_eq2 <- dev_rel(GD_T, GD_WS + GD_BS)
stopifnot(c(dev_var1, dev_var2, dev_scale, dev_eq1, dev_eq2) < tol_exact)
# special case (a), pA = pB = pbar: Var(x_k) = pbar qbar / 2, equal effects m GD_T / 4
dev_mix <- dev_rel(sum(pH * (1 - pH) / 2), m_loc * GD_T / 4)
stopifnot(dev_mix < tol_exact)
ok <- pH > 0 & pH < 1
ratio <- v_pop[ok] / (pH * (1 - pH))[ok]

#' 
#' Deviations (tolerance `r fmt_sci(tol_exact, 1)`, relative to the larger of 1 and
#' the quantity): the two forms of @eq-response-hybrid-var against the empirical
#' population variance of the hybrids, `r fmt_sci(dev_var1)` and
#' `r fmt_sci(dev_var2)`; the scale factor below, `r fmt_sci(dev_scale)`; the two
#' equal-effect statements below, `r fmt_sci(dev_eq1)` and `r fmt_sci(dev_eq2)`; and
#' the mixture-base limit, `r fmt_sci(dev_mix)`.
#' 
#' The formula is on the population-variance scale (divisor $N$);
#' `genic_var()` and `var(gv)` use the divisor $N - 1$, so for this factorial
#' `genic_var(X, beta)` equals $N/(N-1)\sum_k \beta_k^2\,(p_{Ak}q_{Ak} +
#' p_{Bk}q_{Bk})/4$ exactly (the factor $N/(N-1)$ on the population-scale genic variance): here
#' `r fmt(sum(sim$beta^2 * v_pop), 4)` on the population scale and `r fmt(V_genic, 4)` from `genic_var()`, a ratio of
#' `r fmt(V_genic / sum(sim$beta^2 * v_pop), 5)` against $N/(N-1) =$ `r fmt(N / (N - 1), 5)`. The
#' per-locus variance entering $V_{\text{genic}}$ (@eq-response-genic) is therefore not
#' proportional to $\bar p_k \bar q_k$: the ratio $\operatorname{Var}(x_k)/(\bar p_k \bar q_k)$ ranges
#' from `r fmt(min(ratio), 3)` to
#' `r fmt(max(ratio), 3)` across these loci. Gene diversity
#' of the hybrid pool, $\frac{1}{m}\sum_k 2 \bar p_k \bar q_k$, is $GD_T$ of
#' @eq-hp-gd for the complete factorial of inbred lines with equal pool weights
#' (@sec-subdivided, @tbl-keystone). It contains the between-pool term $GD_{BS} =
#' \frac{1}{m}\sum_k (p_{Ak} - p_{Bk})^2/2$ that @eq-response-hybrid-var removes
#' (since $2\bar p_k\bar q_k = p_{Ak}q_{Ak} + p_{Bk}q_{Bk} + (p_{Ak} - p_{Bk})^2/2$),
#' while $V_{\text{genic}}$ among hybrids sees only the within-pool part
#' $GD_{WS} = \frac{1}{m}\sum_k (p_{Ak}q_{Ak} + p_{Bk}q_{Bk})$, weighted by squared
#' effect. $GD_{WS} = GD_{WI} + GD_{BI}$ (@eq-gd-partition), so with inbred parents
#' ($GD_{WI} = 0$) it is the $GD_{BI}$ that @sec-subdivided names: the two symbols
#' are one number here, and this chapter writes $GD_{WS}$ because the sum
#' over the two pools is what enters $V_{\text{genic}}$. The inference is that gene diversity is a proxy for genic variance only
#' through $GD_{WS}$, and only if effect sizes are unrelated to which loci lose
#' diversity; this chapter does not test the second condition.
#' 
#' Two special cases of the same formula fix the scope, each under stated
#' conditions. (a) A mixture base: with $p_{Ak} = p_{Bk} = \bar p_k$ (equivalently,
#' a mixture of sources intermated to Hardy-Weinberg proportions, $x_k$ the mean of
#' two independent alleles each Bernoulli($\bar p_k$)), $\operatorname{Var}(x_k) =
#' \bar p_k\bar q_k/2$ and $V_{\text{genic}} = \sum_k \beta_k^2 \bar p_k\bar q_k/2$.
#' With effects of equal size $\beta$ at all $m$ loci, and markers whose
#' frequencies represent those of the trait loci, that is $m\beta^2 GD_T/4$, so
#' maximising $GD_T$ then maximises $V_{\text{genic}}$; with unequal effects the two
#' differ by the squared-effect weighting. This is the statement that
#' @sec-subdivided uses for a base population and defers here. (b) Hybrids of two
#' pools never intermated, equal effects: $V_{\text{genic}} = m\beta^2 GD_{WS}/4$,
#' which equals $m\beta^2 GD_T/4$ only when $GD_{BS} = 0$, the case (a). The trait
#' of this chapter (`r cfg$n_qtl` loci, $N(0,1)$ effects) satisfies neither equal-effects
#' condition, so (a) and (b) are statements about the proxy, not about the
#' `gv` above. Neither $GD_T$ nor $V_{\text{genic}}$, being functions of allele
#' frequencies and not of haplotypes, sees linkage disequilibrium.
#' 
#' The proxy is incomplete in two further ways. Gene diversity
#' weights every locus equally, so it cannot distinguish a marker carrying half the
#' genetic variance from one carrying none. And -- more seriously -- no frequency-based metric sees the covariance term, as
#' the next box sets out.
#' 
#' ::: {.callout-warning}
#' ## The frequency-based metrics cannot see the covariance term
#' 
#' $\theta_S$, $GD_S$ (and $GD_T$), $N_s$, allelic richness, $F_{hom}$ and
#' $F_{drift}$ -- including $\theta_S$, the only metric the differential evolution
#' (DE) selector constrains -- are all functions of allele
#' frequencies **one locus at a time**. The covariance term of @eq-response-ld does not move a
#' single allele frequency. `eff_dim()` is the exception: it is computed from the
#' spectrum of the double-centred $f$, a multilocus quantity, so it does respond to
#' disequilibrium, but it weights loci by nothing, not by effect. A flat gene
#' diversity trajectory therefore does not imply flat additive variance, for two
#' separate reasons. First, $GD_T = GD_{WS} + GD_{BS}$ and only $GD_{WS}$ enters
#' $V_{\text{genic}}$ among hybrids, so a flat $GD_T$ can accompany a falling
#' $GD_{WS}$ whenever $GD_{BS}$ rises (@sec-subdivided gives the drift case).
#' Second, the covariance term of @eq-response-ld is invisible to every one-locus
#' metric, and enters $\sigma_A^2$ and from there the predicted $R$ of
#' @eq-response-breeders. @sec-limits tests the second reason only: it measures,
#' against a random-selection control, whether selection builds this term and how
#' quickly it decays, and does not compare a gene-diversity trajectory with a
#' variance trajectory.
#' :::
#' 
#' ## Combining ability against a tester pool
#' 
#' Additive variance is the variance of *breeding values*, not of genotypic values.
#' Two statements about combining ability separate the chapter's additive trait
#' from the dominance case, and the dominance assumption is declared where each is
#' made. The model of @eq-hp-gca-sca splits a hybrid value into general
#' combining ability (GCA) of the two parent lines and specific combining ability
#' (SCA) of the pair; the concepts are those of @sprague1942, and the exact
#' orthogonal split used here is the book's own, derived in
#' @sec-heterosis-gca-sca.
#' 
#' *Without dominance* ($d_k \equiv 0$, the case of `gv`): the effect on the hybrid
#' value of substituting one allele at locus $k$ is $\beta_k/2$ whatever the pool it
#' is substituted into (a parental allele fixes one half of the hybrid coding
#' $x_k \in \{0, 1/2, 1\}$, so one substitution moves $x_k$ by $1/2$ and $\mathrm{gv}$ by
#' $\beta_k/2$; this is the additive effect $a_k$ of @sec-hybrid-programme and
#' @sec-heterosis for $d_k \equiv 0$, since the two homozygotes, worth $\pm a_k$ there, differ by
#' $2a_k = \beta_k$ here), a line's GCA does not depend on the tester set
#' (@sec-hybrid-programme), the value of a hybrid is $\mathrm{gv}_{ij} = a_i + b_j$
#' with $a_i = \sum_k \beta_k u_{ik}/2$ and $b_j = \sum_k \beta_k v_{jk}/2$; the GCAs
#' are $a_i$ and $b_j$ centred on their means and the SCA is zero up to rounding.
#' Over the complete factorial $a_i$ and $b_j$ are uncorrelated, so $\operatorname{Var}(\mathrm{gv}) = \operatorname{Var}(\mathrm{GCA}_A) +
#' \operatorname{Var}(\mathrm{GCA}_B)$: the whole $\sigma_A^2$ of
#' @eq-response-breeders is GCA variance, with no interaction part. The chunk
#' below computes the split from the factorial table of `gv` itself (row and column
#' means, the interaction as the residual), asserts these statements, and also
#' estimates the GCA of the pool-A lines against only five of the pool-B lines as
#' testers.
#' 
## -----------------------------------------------------------------------------
#| label: response-gca-additive
nA <- nrow(U); nB <- nrow(V)
GV <- matrix(gv, nA, nB)                       # ped varies pool A fastest
a_i <- drop(U %*% sim$beta) / 2                # a_i = sum_k beta_k u_ik / 2
b_j <- drop(V %*% sim$beta) / 2
gca_A_add <- rowMeans(GV) - mean(GV)           # GCA of A lines against all of pool B
gca_B_add <- colMeans(GV) - mean(GV)
sca_add   <- GV - mean(GV) - outer(gca_A_add, gca_B_add, "+")
tester    <- seq_len(5)                        # a five-line tester set from pool B
gca_A_sub <- rowMeans(GV[, tester]) - mean(GV[, tester])
dev_a_b   <- dev_rel(GV, outer(a_i, b_j, "+"))
dev_gca   <- dev_rel(c(gca_A_add, gca_B_add), c(a_i - mean(a_i), b_j - mean(b_j)))
dev_sca0  <- dev_rel(sca_add, 0)
dev_vadd  <- dev_rel(var(gv), var(rep(gca_A_add, times = nB)) +
                              var(rep(gca_B_add, each  = nA)))
dev_tstr  <- dev_rel(gca_A_sub, gca_A_add)
stopifnot(c(dev_a_b, dev_gca, dev_sca0, dev_vadd, dev_tstr) < tol_exact)

#' 
#' Deviations (tolerance `r fmt_sci(tol_exact, 1)`): $\mathrm{gv}_{ij} = a_i + b_j$,
#' `r fmt_sci(dev_a_b)`; GCAs equal to the centred $a_i$, $b_j$,
#' `r fmt_sci(dev_gca)`; largest SCA, `r fmt_sci(dev_sca0)`;
#' $\operatorname{Var}(\mathrm{gv}) = \operatorname{Var}(\mathrm{GCA}_A) +
#' \operatorname{Var}(\mathrm{GCA}_B)$, `r fmt_sci(dev_vadd)`, both sides being
#' `r fmt(var(gv), 4)`; GCA of the pool-A lines against `r length(tester)` testers
#' instead of all `r nB`, `r fmt_sci(dev_tstr)`.
#' 
#' *With dominance* ($d_k \not\equiv 0$): the dominance part of a line's GCA is an
#' average effect evaluated at the **opposite** pool's allele frequencies
#' (@sec-hybrid-programme), so combining ability is then a property of a line
#' against a tester pool, never of the line alone, and an SCA component appears.
#' The chunk below applies the split to an illustrative, dominance-only value
#' $H$ = `heterosis_value(X, d)`, with dominance effects $d_k \sim N(`r cfg$d_mean`, `r cfg$d_sd`^2)$ drawn here
#' and unrelated to $\boldsymbol\beta$. The draw is not the one of @sec-heterosis
#' (a gamma-distributed $d_k$, seed 4); that chapter owns the decomposition and its
#' tests, and the shares below depend on the draw of $d$. They are shares of that
#' illustrative heterosis, not of the genetic variance of `gv`. The GCA and SCA of
#' this half are those of $H$ (@eq-het-gca-sca), not those of the cross mean `gv`
#' of the paragraph above.
#' 
## -----------------------------------------------------------------------------
#| include: false
cap_gca <- sprintf("Variance of the illustrative dominance-only value $H$ = `heterosis_value(X, d)` (dominance effects $d_k \\sim N(%g, %g^2)$, seed %d; one draw, %d $\\times$ %d factorial of the seed-%d pools) split into the general combining ability of pool A and pool B lines and the specific combining ability of their crosses. Variance in squared simulation units; share: fraction of the summed variance. These are shares of the illustrative heterosis, not of the genetic variance of the selected trait.", cfg$d_mean, cfg$d_sd, cfg$seed_d, nA, nB, cfg$seed)

#' 
## -----------------------------------------------------------------------------
#| label: response-gca-sca
set.seed(cfg$seed_d)
d  <- rnorm(ncol(X), cfg$d_mean, cfg$d_sd)      # dominance effects
gs <- heterosis_gca_sca(U, V, d)
H  <- heterosis_value(X, d)

gA <- rep(gs$gca_A, times = nB)                 # ped varies pool A fastest
gB <- rep(gs$gca_B, each  = nA)
sc <- as.vector(gs$sca)

cc <- cor(cbind(gA, gB, sc))
dev_recon <- dev_rel(H, gs$mu + gA + gB + sc)
dev_vsum  <- dev_rel(var(H), var(gA) + var(gB) + var(sc))
dev_orth  <- max(abs(cc[upper.tri(cc)]))        # correlations, scale free
stopifnot(c(dev_recon, dev_vsum, dev_orth) < tol_exact)

#' 
#' The three components are orthogonal, so their variances add exactly.
#' Deviations (tolerance `r fmt_sci(tol_exact, 1)`): reconstruction
#' $H = \mu + \mathrm{GCA}_A + \mathrm{GCA}_B + \mathrm{SCA}$, `r fmt_sci(dev_recon)`;
#' $\operatorname{Var}(H)$ against the sum of the three variances (both
#' `r fmt(var(H), 4)`), `r fmt_sci(dev_vsum)`; largest absolute correlation between
#' two components, `r fmt_sci(dev_orth)`. @tbl-response-gca-sca gives the shares.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-response-gca-sca
#| tbl-cap: !expr cap_gca
p <- c(gca_A = var(gA), gca_B = var(gB), sca = var(sc))
fmt(data.frame(component = names(p),
               `variance (sim. units squared)` = p,
               share = p / sum(p), row.names = NULL, check.names = FALSE), 3)

#' 
#' `gca_A` and `gca_B` are the part of $H$ that main effects of the parent lines,
#' each against the opposite pool, can express; `sca` is the line-by-line
#' interaction they cannot. How each share responds to recurrent selection across
#' cycles is not measured in this chapter.
#' 
#' ## What `weights = NULL` is assuming
#' 
#' `stage2_select()` defaults (`weights = NULL`) to equal weight on every trait, and
#' every chapter of this book including @sec-case-study takes that default. The
#' criteria it weights are not phenotypes but the *predicted* trait values
#' $\hat{\mathbf{g}}$ of the hybrids (`hybrids` columns, passed to `build_ctx()`
#' as `traits`). `build_ctx()` standardises each column before weighting, so the
#' default index is $\sum_j \hat g_j / \operatorname{sd}(\hat g_j)$, up to a
#' positive affine transformation that does not change the ranking. In trait units
#' that is the index $\mathbf{a}'\hat{\mathbf{g}}$ with economic weights
#' $a_j = 1/\operatorname{sd}(\hat g_j)$. What the default assumes is therefore an
#' economic statement: one standard deviation of predicted value is worth the same
#' in every trait. It is a choice, not a neutral one.
#' 
#' Whether $\mathbf{a}'\hat{\mathbf{g}}$ is the best index for those $\mathbf{a}$
#' is a separate question, and the answer depends on what $\hat{\mathbf{g}}$ is.
#' Let $W = \mathbf{a}'\mathbf{g}$ be the aggregate genotype (the breeding
#' objective), with $\mathbf{g}$ the vector of the traits' genetic values (one
#' entry per trait; not a vector over individuals). The weights $\mathbf{b}$ on a
#' vector of criteria $\boldsymbol\xi$ that maximise the correlation between
#' $\mathbf{b}'\boldsymbol\xi$ and $W$ are
#' $\operatorname{Var}(\boldsymbol\xi)^{-1}\operatorname{Cov}(\boldsymbol\xi, \mathbf{g}')\,\mathbf{a}$.
#' When $\boldsymbol\xi = \hat{\mathbf{g}}$ is the multi-trait best linear unbiased
#' predictor (BLUP) of $\mathbf{g}$, $\operatorname{Cov}(\hat{\mathbf{g}},
#' \mathbf{g}') = \operatorname{Var}(\hat{\mathbf{g}})$ (a standard property of
#' BLUP, used here without a citation and verified for the example below), so
#' $\mathbf{b} = \mathbf{a}$: weighting the predictions by the economic weights is then the
#' optimum, not a departure from it. The condition fails in general for
#' predictions that are not BLUP of
#' $\mathbf{g}$, single-trait BLUPs of genetically correlated traits included.
#' 
#' When $\boldsymbol\xi$ is instead the vector of phenotypic records $\mathbf{y} = \mathbf{g} + \mathbf{e}$, $\mathbf{e}$
#' independent of $\mathbf{g}$, with $\operatorname{Var}(\mathbf{y}) = \boldsymbol\Sigma_P$ and
#' $\operatorname{Cov}(\mathbf{y}, \mathbf{g}') = \boldsymbol\Sigma_G$, the same
#' expression is the Smith-Hazel index [@smith1936; @hazel1943] (the two papers
#' were not read for this book: the expression is checked here by algebra and by the
#' BLUP chunk below, not against them, and the matrix notation is modern, not
#' theirs), displayed in @eq-response-smith-hazel:
#' 
#' $$\mathbf{b} \;=\; \boldsymbol\Sigma_P^{-1}\boldsymbol\Sigma_G\mathbf{a},$$ {#eq-response-smith-hazel}
#' 
#' with $\boldsymbol\Sigma_P$ and $\boldsymbol\Sigma_G$ the phenotypic and genetic
#' covariance matrices of the traits (`P` and `G` in the code; $\boldsymbol\Sigma_G$ is
#' not the relationship matrix $\mathbf{G}$) and $\mathbf{a}$ the economic weights. @tbl-response-smith-hazel
#' evaluates @eq-response-smith-hazel for a two-trait example.
#' 
## -----------------------------------------------------------------------------
P <- matrix(c(4.0, 1.2, 1.2, 1.0), 2)      # phenotypic covariance
G <- matrix(c(2.0, 0.3, 0.3, 0.3), 2)      # genetic covariance
a <- c(1, 1)                               # equal economic weight
stopifnot(all(eigen(G, only.values = TRUE)$values > 0),      # G is a covariance
          all(eigen(P - G, only.values = TRUE)$values > 0))  # so is P - G

#' 
## -----------------------------------------------------------------------------
#| include: false
cap_sh <- sprintf("Smith-Hazel index weights (@eq-response-smith-hazel) for an illustrative two-trait example with equal economic weights. Phenotypic covariance $\\boldsymbol\\Sigma_P$: variances %.1f and %.1f, covariance %.1f; genetic covariance $\\boldsymbol\\Sigma_G$: variances %.1f and %.1f, covariance %.1f. Values are invented for illustration, not estimated.", P[1, 1], P[2, 2], P[1, 2], G[1, 1], G[2, 2], G[1, 2])

#' 
## -----------------------------------------------------------------------------
#| label: tbl-response-smith-hazel
#| tbl-cap: !expr cap_sh
fmt(data.frame(trait = c("yield", "moisture"),
               `economic weight` = a,
               `Smith-Hazel weight` = index_smith_hazel(P, G, a),
               check.names = FALSE), 3)

#' 
#' Equal economic weights do **not** give equal index weights on phenotypes here.
#' $\mathbf{b}$ is proportional to $\mathbf{a}$ if and only if $\mathbf{a}$ is an
#' eigenvector of $\boldsymbol\Sigma_P^{-1}\boldsymbol\Sigma_G$. A sufficient condition is
#' $\boldsymbol\Sigma_G = c\,\boldsymbol\Sigma_P$ -- every trait with heritability $c$ and genetic
#' correlations equal to the phenotypic ones -- which requires neither equal
#' variances nor uncorrelated traits.
#' 
## -----------------------------------------------------------------------------
#| label: response-sh-proportional
b_sh <- index_smith_hazel(P, G, a)
dev_prop <- dev_rel(index_smith_hazel(P, 0.5 * P, a), 0.5 * a)
# BLUP of g from one record per trait (known means): ghat = G P^-1 y.
K <- G %*% solve(P)
dev_blup1 <- dev_rel(drop(solve(K %*% P %*% t(K), K %*% G) %*% a), a)
dev_blup2 <- dev_rel(drop(t(K) %*% a), b_sh)
stopifnot(c(dev_prop, dev_blup1, dev_blup2) < tol_exact)

#' 
#' The first statement is the sufficient condition, checked for
#' $\boldsymbol\Sigma_G = 0.5\,\boldsymbol\Sigma_P$ (deviation of $\mathbf{b}$ from
#' $0.5\,\mathbf{a}$: `r fmt_sci(dev_prop)`; tolerance `r fmt_sci(tol_exact, 1)`).
#' The chunk also checks the two statements that tie the phenotypic and the
#' predicted index together, for the BLUP from one record per trait with known
#' means, $\hat{\mathbf{g}} = \boldsymbol\Sigma_G\boldsymbol\Sigma_P^{-1}\mathbf{y}$:
#' $\operatorname{Var}(\hat{\mathbf{g}})^{-1}\operatorname{Cov}(\hat{\mathbf{g}},
#' \mathbf{g}')\,\mathbf{a} = \mathbf{a}$, and $\mathbf{a}'\hat{\mathbf{g}}$ is the
#' Smith-Hazel index $\mathbf{b}'\mathbf{y}$ of @tbl-response-smith-hazel. So the
#' gap between $\mathbf{b}$ and $\mathbf{a}$ in that table is a property of an index
#' on phenotypes; it is not a defect of `weights = NULL`, whose criteria are
#' predictions. What the default does assume is the economic weighting
#' $a_j = 1/\operatorname{sd}(\hat g_j)$, and that the predictions behave as
#' multi-trait BLUP; this chapter tests neither against a real breeding objective.
#' The deviations of the two BLUP statements are `r fmt_sci(dev_blup1)` and
#' `r fmt_sci(dev_blup2)`.
#' 
#' ## The $\alpha$ constraint beside the restricted index
#' 
#' @sec-ocs argues that a diversity *budget* is approvable where a weighted sum is
#' not: a breeding committee can approve a statement that the loss of diversity
#' will be no more than a stated fraction, and cannot approve a price of $\lambda$
#' index units per unit of diversity.
#' 
#' That argument is usually presented as a point about human decision-making. The
#' constrained form has two earlier lineages, reported here with what was and was
#' not read.
#' 
#' **Restricted selection indices.** @kempthorne1959 is the reference the book
#' cites for the index that maximises aggregate gain subject to zero expected change
#' in specified traits. The paper is not open access and was not read for this
#' book, so what it contains, and whether it solves the problem in the form below,
#' is not verified here. The matrix form is the book's own statement, in the
#' $\mathbf{C} = \boldsymbol\Sigma_G\mathbf{R}$ form used by `index_restricted()`
#' (not claimed to be their notation), with $\mathbf{R}$ the $n_t \times n_r$ matrix
#' of restricted directions for $n_t$ traits and $n_r$ restrictions and
#' $\boldsymbol\Sigma_P$, $\boldsymbol\Sigma_G$, $\mathbf{a}$ as in
#' @eq-response-smith-hazel:
#' 
#' $$\mathbf{b} \;=\; \boldsymbol\Sigma_P^{-1}\left[\boldsymbol\Sigma_G\mathbf{a} - \mathbf{C}
#' (\mathbf{C}'\boldsymbol\Sigma_P^{-1}\mathbf{C})^{-1}\mathbf{C}'\boldsymbol\Sigma_P^{-1}
#' \boldsymbol\Sigma_G\mathbf{a}\right], \qquad \mathbf{C} = \boldsymbol\Sigma_G\mathbf{R}$$ {#eq-response-restricted}
#' 
#' By direct substitution $\mathbf{C}'\mathbf{b} = \mathbf{0}$, that is
#' $\mathbf{R}'\boldsymbol\Sigma_G\mathbf{b} = \mathbf{0}$. The chunk below checks
#' it for a two-trait example, and that is all that is checked: the derivation of
#' @eq-response-restricted as the maximiser is not given here.
#' 
#' **Constraining a group coancestry while maximising gain.** In optimum
#' contribution selection, as set out in the Methods of @meuwissen2020, the genetic
#' level of the selected parents $\bar g = \mathbf{c}'\hat{\mathbf{g}}$ is
#' maximised over the vector of contributions $\mathbf{c}$, with the rate of
#' inbreeding constrained through the group coancestry of the selected parents,
#' $K = \tfrac12\mathbf{c}'\mathbf{G}\mathbf{c}$, where $\mathbf{G}$ is the
#' relationship matrix chosen for managing diversity; that paper compares several,
#' among them molecular ones ($\mathbf{G}_{0.5}$ and VanRaden's). Its Introduction
#' credits @meuwissen1997 with optimum contribution selection that maximises gain
#' for a given rate of inbreeding; the 1997 paper itself was not read for this book.
#' The paper gives no formula for $\mathbf{G}_{0.5}$; @sec-coancestry derives one
#' (@eq-g05), from which, for contributions summing to one, the group coancestry of
#' the molecular matrix $\mathbf{f}$ behind $\theta_S$ is an affine function of the
#' $\mathbf{G}_{0.5}$ group coancestry, so the two order selections identically. So restricting a group coancestry while maximising gain
#' is not new to this book, and the restricted direction is not its contribution. What the book adds, as far as the sources read
#' here go, is stated in the text of @sec-baseline and @sec-ocs (a budget measured
#' against random subsets of the same size, applied to hybrids of two pools); this
#' chapter has not checked that against the wider literature.
#' 
#' @tbl-response-restricted compares the restricted index with the unrestricted
#' index of @tbl-response-smith-hazel when moisture is held at zero.
#' 
## -----------------------------------------------------------------------------
#| include: false
cap_restr <- sprintf("Unrestricted (Smith-Hazel, @eq-response-smith-hazel) and restricted (@eq-response-restricted) index weights for the two-trait example of @tbl-response-smith-hazel, with the restriction on moisture ($\\mathbf{R} = (0, 1)'$). Covariance row: $\\mathbf{R}'\\boldsymbol\\Sigma_G\\mathbf{b}$, the covariance of the index $\\mathbf{b}'\\mathbf{y}$ with moisture; it depends on the scale of $\\mathbf{b}$ and is not a gain. Last row: the expected gain in moisture per round, $i\\,\\mathbf{R}'\\boldsymbol\\Sigma_G\\mathbf{b}/\\sqrt{\\mathbf{b}'\\boldsymbol\\Sigma_P\\mathbf{b}}$, at the normal-theory intensity $i = %.3f$ of the top %d of %d (the selected fraction of @tbl-response-breeders), in trait units.", i_norm, cfg$n_sel, N_hyb)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-response-restricted
#| tbl-cap: !expr cap_restr
R  <- cbind(c(0, 1))                       # hold moisture at zero gain
b_r <- index_restricted(P, G, a, R)
b_u <- index_smith_hazel(P, G, a)
cov_m <- c(drop(crossprod(R, G %*% b_u)), drop(crossprod(R, G %*% b_r)))
sd_I  <- sqrt(c(drop(b_u %*% P %*% b_u), drop(b_r %*% P %*% b_r)))   # sd of b'y
gain_m <- i_norm * cov_m / sd_I           # expected gain in moisture per round
# restricted: zero in expectation, to the tolerance; Smith-Hazel: clearly not
stopifnot(abs(cov_m[2]) < tol_exact, abs(gain_m[2]) < tol_exact, gain_m[1] > 0)

fmt(data.frame(
  quantity = c("weight on yield", "weight on moisture",
               "covariance of index with moisture",
               "expected gain in moisture per round"),
  `Smith-Hazel` = c(b_u, cov_m[1], gain_m[1]),
  restricted    = c(b_r, cov_m[2], gain_m[2]),
  check.names = FALSE), 4)

#' 
#' Zero here is exact to the tolerance of the setup: the restricted index has
#' covariance `r fmt_sci(abs(cov_m[2]))` and expected gain `r fmt_sci(abs(gain_m[2]))`
#' (tolerance `r fmt_sci(tol_exact, 1)`), against `r fmt(gain_m[1], 3)` for the
#' Smith-Hazel index. As an independent check of the formula, a literal
#' Monte Carlo selection on traits drawn from the two covariance matrices
#' ($\mathbf{g} \sim N(\mathbf{0}, \boldsymbol\Sigma_G)$,
#' $\mathbf{y} = \mathbf{g} + \mathbf{e}$,
#' $\mathbf{e} \sim N(\mathbf{0}, \boldsymbol\Sigma_P - \boldsymbol\Sigma_G)$) selects
#' the top fraction on each index.
#' 
## -----------------------------------------------------------------------------
#| label: response-gain-oracle
set.seed(cfg$seed_gain)
n_mc_gain <- 4e5
gm <- matrix(rnorm(2 * n_mc_gain), ncol = 2) %*% chol(G)
ym <- gm + matrix(rnorm(2 * n_mc_gain), ncol = 2) %*% chol(P - G)
mc_gain <- mc_se <- numeric(2)
for (k in 1:2) {
  Ik  <- drop(ym %*% list(b_u, b_r)[[k]])
  top <- Ik >= quantile(Ik, 1 - cfg$n_sel / N_hyb)
  mc_gain[k] <- mean(gm[top, 2])
  mc_se[k]   <- sd(gm[top, 2]) / sqrt(sum(top))
}
# 4 s.e.: false-alarm probability 6e-5 per index
stopifnot(abs(mc_gain - gain_m) < 4 * mc_se)

#' 
#' Monte Carlo against formula, in trait units (`r format(n_mc_gain, scientific = FALSE)`
#' draws; the Monte Carlo s.e. is the s.d. of the selected moisture values over the
#' square root of their count): Smith-Hazel `r fmt(mc_gain[1], 3)`
#' (s.e. `r fmt(mc_se[1], 3)`) against `r fmt(gain_m[1], 3)`; restricted
#' `r fmt(mc_gain[2], 3)` (s.e. `r fmt(mc_se[2], 3)`) against zero. Both lie
#' within the 4 s.e. the chunk asserts.
#' 
#' For the restricted index the covariance with moisture is zero, and for the
#' Smith-Hazel index it is not. The expected gain in moisture per round of
#' selection with intensity $i$ is $i\,\operatorname{Cov}(\mathbf{b}'\mathbf{y},
#' \text{moisture})/\sqrt{\mathbf{b}'\boldsymbol\Sigma_P\mathbf{b}}$ (the slope of the
#' regression of the genetic value on the index times the selection differential
#' $i\,\operatorname{sd}(\mathbf{b}'\mathbf{y})$), so it is zero exactly when the
#' covariance is. That is a statement about an **expectation**: it holds for known
#' $\boldsymbol\Sigma_P$ and $\boldsymbol\Sigma_G$ and a linear regression of
#' genetic value on the index, and the realised change of the restricted trait in a
#' finite selected sample, or with estimated covariance matrices, is not zero.
#' 
#' Four differences keep the restricted index from being the $\alpha$ constraint, or
#' a proof of it.
#' 
#' 1. *Form.* The restriction is an equality, linear in the index weights, with a
#'    closed form under the assumptions above. The $\alpha$ constraint is an
#'    inequality, $\alpha(S) \le \alpha_{\max}$, on the loss of gene diversity of a
#'    selected set $S$ relative to the mean over random subsets of the same size
#'    (@sec-baseline); $\theta_S$ is a quadratic form in the contributions of a
#'    discrete selection, which the book solves by search (@sec-ocs), not by a
#'    closed form.
#' 2. *Expectation against realisation.* The restricted index fixes an expected gain.
#'    $\alpha(S)$ is a deterministic function of the selected set, so the bound
#'    holds on the realised set itself, given the reference value it is measured
#'    against.
#' 3. *Which quantity is restricted.* The budget acts on $GD_T = 1 - \theta_S$, which
#'    contains the between-pool term $GD_{BS}$ that @sec-response-genic
#'    showed does not enter $V_{\text{genic}}$ among hybrids. The restricted
#'    direction is therefore not the one that carries response, as item 3 of the
#'    Preface also notes; it protects variance only through $GD_{WS}$.
#' 4. *Equality against inequality.* What changes when the equality becomes an
#'    inequality is not worked out in this chapter, and @sec-ocs does not work it out
#'    either: it states the constraint as $\alpha \le \alpha_{\max}$ (bounded
#'    relative to a resampling baseline, not held at zero) and notes that a budget
#'    above the attainable maximum restricts nothing.
#' 
#' ::: {.callout-note}
#' ## What the lineage does and does not show
#' 
#' Constraining rather than pricing is not specific to this book: the restricted
#' selection index (for a trait, reported from @kempthorne1959, not read) and optimum
#' contribution selection with a bound on a group coancestry (@meuwissen2020, whose
#' optimum-contribution paragraph and Introduction were read; @meuwissen1997
#' reported through it) both have that form. The
#' $\alpha$ constraint is closest to the second, and the four differences above are
#' why neither is a proof that it is the right constraint; whether to prefer a
#' budget to a price remains the argument of @sec-ocs.
#' :::
#' 
#' ## Where this connects
#' 
#' @sec-genomic-era and @sec-catalogue report the frequency-based metrics whose link
#' to variance this chapter limited to the within-pool part
#' (@eq-response-hybrid-var); neither computes $V_{\text{genic}}$.
#' @sec-genomic-prediction measures a prediction accuracy for a different object
#' from the $r$ here, which this chapter constructs as the correlation between the
#' index and the true genetic value, set by $h^2 =$ `r cfg$h2`; Finding 5 of
#' @sec-choosing shows what happens when accuracy is assumed rather than measured.
#' @sec-ocs states the $\alpha$ constraint as an inequality and sets the budget; it
#' does not derive the constraint from the restricted index, and nothing here does.
#' @sec-limits tests whether selection builds the covariance term of
#' @eq-response-ld, against a random-selection control: it finds a term that is
#' significant against that control, largest in early cycles and decaying with
#' recombination, and it argues from the decay that constraining allele frequencies
#' and ignoring this term is justified. It ranks that cost below the permanent cost of changed allele
#' frequencies, on the condition that the decay is fast.
#' @sec-heterosis completes the Foundations part with the
#' dominance side of the hybrid value; the Simulation part then opens with
#' @sec-simulating-crosses, which builds step by step the generators, one of which
#' (`simulate_pools()`) drew the data here in one call.
