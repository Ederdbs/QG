#' # Diversity metrics in the genomic era {#sec-genomic-era}
#' 
# 05-genomic-era -- standalone script of the chapter 05-genomic-era.qmd
# Book: https://ederdbs.github.io/QG/05-genomic-era.html
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
ctx  <- simulate_data(book_cfg)
L    <- simulate_lines(book_cfg)
pool <- rep(c("A", "B"), c(book_cfg$n_pool_A, book_cfg$n_pool_B))
P0   <- pool_freqs(L / 2, pool)

#' 
#' The Simulation part produced populations whose true history is known; this part
#' measures them, because a diversity metric can only be judged against a
#' population whose drift and inbreeding are known independently of the metric.
#' 
#' In classical theory, inbreeding measured as **loss of heterozygosity** and
#' inbreeding measured as **drift of allele frequencies** are the same thing.
#' @meuwissen2020 show that inside genomic optimal-contribution schemes they stop
#' being the same thing, and can diverge badly, whenever diversity is controlled
#' through **identity by state** (IBS) on a marker panel. Only when control is through
#' **identity by descent** (IBD) is the classical equivalence restored.
#' 
#' The practical consequence is uncomfortable:
#' 
#' > You hit exactly the target you wrote into the optimiser's constraint, and you
#' > pay an unmonitored price in the metric you did not write.
#' 
#' If you constrain $\tfrac{1}{2}\mathbf{c}'\mathbf{G}\mathbf{c}$ using a VanRaden
#' $\mathbf{G}$ [@vanraden2008], you are constraining **drift**. The loss of heterozygosity in your
#' germplasm may be running at a different rate, in either direction, from the one
#' you believe you are controlling.
#' 
#' This chapter is written for one kind of programme, stated in full in
#' @sec-era-programme: an allogamous, maize-type hybrid programme running
#' reciprocal recurrent selection over two heterotic pools. The first half defines
#' the metrics; the second half is the sequence of steps that puts them into a
#' cycle report, with the check and the failure mode of each step.
#' 
#' ## The programme this chapter is written for {#sec-era-programme}
#' 
#' Every number below is computed under these assumptions. They are declared here
#' because several of the results are false outside them. @sec-hybrid-programme
#' describes the programme itself, stage by stage; this section states only what
#' every number below assumes about it.
#' 
#' **A1. The species is allogamous and the product is an F1 hybrid.** Maize-type:
#' two heterotic pools, A and B, crossed to produce single-cross hybrids. The
#' commercial product carries the heterozygosity; the parents do not. Nothing here
#' is addressed to a self-pollinated crop whose product is a line, and nothing here
#' is addressed to a programme whose commercial unit is a synthetic or a population
#' cross -- both change which quantity is the product and therefore which loss
#' matters.
#' 
#' **A2. Parent lines are fully inbred, by doubled-haploid (DH) induction or by selfing to fixation.**
#' This is a property of the *programme*, not of the mating system: an allogamous
#' crop bred for hybrids still delivers inbred parents. In this simulation the
#' lines are homozygous at every locus, which the coancestry kernel reports exactly:
#' 
## -----------------------------------------------------------------------------
#| label: era-inbred-check
inb <- c(het_fraction_lines   = mean(L / 2 == 0.5),
         self_coancestry_min  = min(diag(molecular_coancestry(L / 2))),
         het_fraction_F1      = mean(ctx$X == 0.5),
         twice_GD_WI_hyb      = 2 * gd_partition(seq_len(ctx$N), ctx)[["GD_WI_hyb"]])
stopifnot(inb[["het_fraction_lines"]] == 0, inb[["self_coancestry_min"]] == 1,
          isTRUE(all.equal(inb[["het_fraction_F1"]], inb[["twice_GD_WI_hyb"]])))
inb  # verification echo: every value is asserted by the stopifnot() above

#' 
#' Line heterozygosity is zero and every line's self-coancestry is 1, so
#' individual-level inbreeding coefficients are 1 by construction and carry no
#' management information. The F1s carry
#' `r fmt(mean(ctx$X == 0.5), 3)` of their loci heterozygous, and that fraction is
#' exactly twice `GD_WI_hyb` -- the identity @sec-heterosis derives. **The
#' manageable quantity is therefore an allele frequency in a pool, never a
#' homozygosity within an individual.** Everything below is computed on
#' frequencies.
#' 
#' **A3. Germplasm is recycled within pool; only information crosses the pool
#' boundary.** Lines are chosen on hybrid performance against the opposite pool
#' (@comstock1949) and recycled inside their own pool. A DH taken from an
#' $A \times B$ F1 would be a blend of both pools and would destroy the heterotic
#' pattern, so it never happens. `run_cycles()` in @sec-cycles implements exactly
#' this loop.
#' 
#' **A4. Cycles are discrete.** Pool sizes are constant across cycles and no
#' generation overlap is modelled. Real programmes overlap cycles and reuse the
#' same line for years, which biases any $\Delta F$ read off a cycle index; see
#' @sec-limits.
#' 
#' **A5. Markers are neutral, biallelic, coded $0/0.5/1$** as the frequency of the
#' reference allele within the individual, and are in linkage equilibrium within
#' pool because each line's genotype is drawn independently per locus
#' (`simulate_lines()`). Linkage equilibrium makes the audit step of
#' @sec-era-step5 a best case, and that is said again where the number is reported.
#' 
#' **A6. The frequency base $p_0$ is frozen at the founding cycle** and never
#' recomputed. This is `ctx$p0`, set once in `build_ctx()`. @sec-era-step1 is that
#' step and measures what happens without it.
#' 
#' **A7. No dominance enters any metric in this chapter.** $\theta$, gene diversity
#' $GD = 1 - \theta$ and $\alpha$ are functions of allele frequencies alone. The dominance side of the
#' same germplasm -- what the divergence between pools is worth in heterosis -- is
#' @sec-heterosis, and the two must not be mixed inside one constraint.
#' 
#' **A8. The scale is the book's teaching scale**: `r book_cfg$n_pool_A` +
#' `r book_cfg$n_pool_B` lines, `r book_cfg$m` markers, `r ctx$N` hybrids in the
#' full factorial. The production scale, a declared programme size that no chunk of
#' this chapter runs, is 71 + 71 lines and 25000 markers. Where a
#' result is scale-dependent, it says so.
#' 
#' ## Three lenses, not three synonyms
#' 
#' @tbl-era-lenses sets out what each lens sees, the inbreeding coefficient that
#' reads it and the relationship matrices built on it.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-lenses
#| tbl-cap: "The three lenses of the section title, plus the hybrid of two of them: G_ROH reads homozygosity and is interpreted as IBD, which is why it gets a row of its own and not a lens of its own. G_0.5 [@toro2014] = 4f - 2J, an affine function of the matrix this book calls f -- see @sec-coancestry."
#| echo: false
knitr::kable(data.frame(
  Lens = c("Drift", "Homozygosity", "IBD", "Hybrid"),
  `What the metric actually sees` = c(
    "squared allele-frequency change relative to a base",
    "proportion of heterozygosity remaining",
    "segments inherited by descent from a defined base",
    "haplotype homozygosity used as a proxy for IBD"),
  `Inbreeding metric` = c("F_drift", "F_hom", "F_IBD", "F_ROH"),
  `Relationship matrix` = c("G_VR2, G_VR1, G_i(p)", "G_0.5 (affine in molecular coancestry)",
                            "A, G_LA", "G_ROH"),
  check.names = FALSE))

#' 
#' ::: {.callout-warning}
#' ## Every inbreeding metric is a ratio to a reference population
#' 
#' Without explicitly declaring your base -- cycle 0 of the recurrent programme? a
#' landrace panel? the founding heterotic pool? -- none of the numbers below mean
#' anything. This is the commonest error in plant applications: using the *current*
#' generation's frequencies as the base, which zeroes the historical memory of
#' erosion. @sec-era-step1 measures the size of that mistake: it is not an
#' attenuation, it is an exact zero.
#' :::
#' 
#' ## The metrics, one at a time
#' 
#' ### Rate of inbreeding and effective size
#' 
#' What you manage is not $F$ but its rate of accumulation, @eq-era-rate. $F$ is a
#' stock; $\Delta F$ is a flow.
#' 
#' $$\Delta F = \frac{F_t - F_{t-1}}{1 - F_{t-1}}, \qquad N_e = \frac{1}{2\Delta F}$$ {#eq-era-rate}
#' 
#' with $F_t \in (-\infty, 1]$ the inbreeding coefficient of cycle $t$ against the
#' frozen base (negative values are possible for $F_{hom}$, see @sec-era-fhom),
#' $\Delta F$ the per-cycle rate and $N_e$ the effective size it implies
#' [@falconer1996, Ch. 3-4].
#' 
#' Since $1 - F_t = (1 - \Delta F)^t$, a regression of $\log(1 - F_t)$ on $t$ has
#' slope $\log(1 - \Delta F)$, so $\Delta F = 1 - e^{\text{slope}}$ and
#' $-\text{slope}$ is only its first-order approximation. **The linearity of that
#' regression is itself a diagnostic:** in @meuwissen2020, $\log(1 - F_{drift})$
#' was approximately linear under every scheme, while $\log(1 - F_{hom})$ showed
#' marked curvature under some, notably the one based on runs of homozygosity (ROH). Curvature means a
#' non-constant rate -- your $N_e$ target is not being met steadily.
#' 
#' A tropical maize recurrent programme targeting $N_e = 50$ per cycle needs
#' $\Delta F = 0.01$. Measuring $F$ only at cycle 8 and dividing by 8 hides the
#' possibility that cycles 1-3 were conservative and cycles 6-8 collapsed the base.
#' @sec-era-step4 fits the regression on a case where the answer is known in
#' advance, and then on one where the diagnostic has to fire.
#' 
#' ### `F_hom`, homozygosity-based {#sec-era-fhom}
#' 
#' @wright1922 defined the inbreeding coefficient $F$ as the correlation between
#' uniting gametes; under random drift in a closed population its consequence is
#' $H_t = H_0(1 - F_t)$, so $F$ is the proportional loss of heterozygosity relative
#' to the base [@falconer1996, Ch. 3]. The homozygosity lens takes that consequence
#' as its definition -- the fraction of heterozygosity already lost relative to the
#' base, @eq-era-fhom:
#' 
#' $$F_{hom} = 1 - \frac{1}{N_{SNP}}\sum_k \frac{2p_{t,k}(1 - p_{t,k})}{2p_{0,k}(1 - p_{0,k})}
#'           = 1 - \frac{1}{N_{SNP}}\sum_k \frac{H_{t,k}}{H_{0,k}}$$ {#eq-era-fhom}
#' 
#' with $p_{t,k} \in [0,1]$ the frequency of the reference allele at marker $k$ in
#' the population being scored, $p_{0,k} \in (0,1)$ the same frequency in the frozen
#' base, $H = 2p(1-p)$ the expected heterozygosity under random mating, and
#' $N_{SNP}$ the number of markers [@meuwissen2020, their Eq. 1A defines it as the
#' total marker count]. This book restricts the sum to markers polymorphic in the
#' base, because $H_{0,k} = 0$ makes the ratio undefined otherwise --
#' `freq_metrics()` does that with `keep <- ctx$p0 > eps & ctx$p0 < 1 - eps` -- and
#' the restriction changes nothing against their result, since their own panels
#' were random samples of loci already segregating in the base population.
#' 
#' **It can be negative.** If management pushes frequencies toward 0.5,
#' heterozygosity rises above the base and the "inbreeding coefficient" goes below
#' zero. That is not a numerical error: it is the expected behaviour of any scheme
#' that maximises heterozygosity on the monitored panel.
#' 
#' It protects against inbreeding depression and the expression of deleterious
#' recessives in homozygosis. It is the right lens when the dominant risk is
#' *vigour* -- in this programme, the vigour of the segregating crossing block and
#' not of the fixed lines, which is a narrower claim than it looks and is qualified
#' at the end of this section.
#' 
#' #### What this lens is computed on, and what it is not
#' 
#' $F_{hom}$ as `freq_metrics()` computes it takes $p_t$ from
#' `colMeans(X[idx, ])`: the reference-allele frequency of the **merged** hybrid
#' set. With inbred parents that merged frequency is
#' $\bar p = (\tilde p_A + \tilde p_B)/2$, with $\tilde p_A$ and $\tilde p_B$ the
#' two pools' frequencies weighted by the line usage the selection induces. So the
#' $He$ column of the same call is $\overline{2\bar p(1 - \bar p)}$, which is
#' $GD_T = 1 - \bar f$ of the Caballero & Toro partition [@caballero2002]
#' *identically*, not approximately: $\bar f = (\theta_A + 2\theta_{AB} +
#' \theta_B)/4 = \overline{\bar p^2 + (1 - \bar p)^2}$ under A2.
#' 
#' **That is gene diversity of the notional merged pool, and it is not the
#' heterozygosity of the product.** The realised F1 heterozygosity is
#' $2\,GD_{WI\text{-}hyb}$ -- exactly, by the self-coancestry identity of
#' assumption A2 -- and on the full factorial it equals $GD_T + GD_{BS}$, the
#' between-pool component counted twice (@sec-heterosis-identity). The difference
#' between the two quantities is therefore $GD_{BS}$, which the $F_{hom}$ lens does
#' not carry, and which moves with the selection (@tbl-era-hom-two-levels for the
#' merged-pool quantities, @tbl-era-hom-two-levels-het for the hybrid-level ones):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-hom-two-levels
#| tbl-cap: "Merged-pool level of diversity for four 60-hybrid selections from the teaching-scale candidate set (@sec-era-programme, A8): one random draw (seed 31), the max-diversity greedy (`w = 0`), the index-weighted greedy (`w = 1`) and truncation on the index. He_merged and F_hom: `freq_metrics()` on the merged hybrid frequencies against the frozen base; GD_T and GD_BS: `gd_partition()`. All dimensionless."
set.seed(31)
sels <- list(random     = sample.int(ctx$N, 60),
             max_div    = sel_greedy(ctx, 60, w = 0),
             balanced   = sel_greedy(ctx, 60, w = 1),
             truncation = sel_truncation(ctx, 60))
two_levels <- t(sapply(sels, function(i) {
  gp <- gd_partition(i, ctx)
  fm <- freq_metrics(i, ctx)
  c(He_merged = fm[["He"]], GD_T = gp[["GD_T"]], F_hom = fm[["F_hom"]],
    GD_BS = gp[["GD_BS"]], F1_het = mean(ctx$X[i, ] == 0.5),
    two_GD_WI_hyb = 2 * gp[["GD_WI_hyb"]],
    GD_T_plus_BS = gp[["GD_T"]] + gp[["GD_BS"]])
}))
stopifnot(isTRUE(all.equal(two_levels[, "He_merged"], two_levels[, "GD_T"])),
          isTRUE(all.equal(two_levels[, "F1_het"], two_levels[, "two_GD_WI_hyb"])))
fmt(as.data.frame(two_levels[, c("He_merged", "GD_T", "F_hom", "GD_BS")]), 4)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-hom-two-levels-het
#| tbl-cap: "Hybrid level of diversity for the four selections of @tbl-era-hom-two-levels. F1_het: fraction of heterozygous loci in the selected hybrids; two_GD_WI_hyb: twice the hybrid-level within-individual gene diversity (`gd_partition()`); GD_T_plus_BS: GD_T + GD_BS of @tbl-era-hom-two-levels. All dimensionless."
fmt(as.data.frame(two_levels[, c("F1_het", "two_GD_WI_hyb", "GD_T_plus_BS")]), 4)

#' 
#' The ranking below is read against a **resampled** null
#' (@tbl-era-hom-two-levels-null), not against the single `random` row, for the reason @sec-era-step2 makes explicit. The null is the
#' package's `null_distribution()`: random 60-hybrid subsets, the same object
#' @sec-era-step2 reuses. Realised F1 heterozygosity is $2\,GD_{WI\text{-}hyb}$,
#' asserted above, so its null is read off the `GD_WI_hyb` column:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-hom-two-levels-null
#| tbl-cap: "Random-subset null for the selections of @tbl-era-hom-two-levels: mean and standard deviation of F_hom, GD_BS and realised F1 heterozygosity (twice GD_WI_hyb) over `B_full = 1000` random 60-hybrid subsets (`null_distribution()`, seed 7), then each selection's z-score against that null, in null standard deviations."
null60 <- null_distribution(ctx, 60, B = 2000, B_full = 1000, seed = 7)
nl <- cbind(F_hom  = null60$full[, "F_hom"],
            GD_BS  = null60$full[, "GD_BS"],
            F1_het = 2 * null60$full[, "GD_WI_hyb"])
z_two <- sapply(colnames(nl), function(k)
  (two_levels[, k] - mean(nl[, k])) / stats::sd(nl[, k]))
share_two <- sapply(colnames(nl), function(k)
  sapply(two_levels[, k], function(v) mean(nl[, k] >= v)))
dimnames(share_two) <- dimnames(z_two)
fmt(rbind(null_mean = colMeans(nl), null_sd = apply(nl, 2, stats::sd),
          as.data.frame(z_two)), 4)

#' 
#' Two identities hold to machine precision in @tbl-era-hom-two-levels and
#' @tbl-era-hom-two-levels-het, and the `stopifnot()`
#' enforces both on every render: $He = GD_T$, and the realised F1 heterozygosity
#' equals $2\,GD_{WI\text{-}hyb}$. The third comparison is *not* an identity on a
#' selected subset: $GD_T + GD_{BS}$ departs from the realised heterozygosity by at
#' most `r sprintf("%.4f", max(abs(two_levels[, "GD_T_plus_BS"] - two_levels[, "F1_het"])))`
#' across these four rows, because $GD_T$ and $GD_{BS}$ are computed from line-usage
#' weights -- what a random re-pairing of the selected parents would give -- while
#' $GD_{WI\text{-}hyb}$ scores the pairs actually chosen (@sec-heterosis states the
#' same limit from the other side).
#' 
#' Now read the ranking. The table has three distinct plans, not four: `balanced`
#' (`w = 1`) returns exactly the truncation set, as @sec-era-step2 shows, so the
#' two rows are identical in every column of both tables. Truncation has the **highest** $F_{hom}$
#' of the three, `r fmt(two_levels["truncation", "F_hom"], 4)`, which is
#' `r fmt(z_two["truncation", "F_hom"], 1)` null s.d. above the resampled mean of
#' `r fmt(mean(nl[, "F_hom"]), 4)` and on the usual reading is "most heterozygosity
#' lost". Yet its hybrids are *more* heterozygous than random subsets of the same
#' size: realised F1 heterozygosity
#' `r fmt(two_levels["truncation", "F1_het"], 4)` against a null mean of
#' `r fmt(mean(nl[, "F1_het"]), 4)`, z = `r fmt(z_two["truncation", "F1_het"], 2)`,
#' reached or exceeded by `r fmt(100 * share_two["truncation", "F1_het"], 1)`% of the
#' `r nrow(nl)` resampled subsets. The two readings are not in conflict because they
#' are two quantities: truncation concentrated usage inside the pools
#' (@sec-era-step6 measures that) and so lost merged-pool gene diversity, while the
#' $A \times B$ pairs it kept are more heterozygous than random pairs, which is what
#' the F1 heterozygosity column scores. $GD_{BS}$ is not evidence for the second
#' half: it is computed from line-usage weights, not from the pairs kept (see
#' above), and it ranks the plans in the opposite order to F1 heterozygosity --
#' truncation has $GD_{BS}$ at z = `r fmt(z_two["truncation", "GD_BS"], 1)` and F1
#' heterozygosity at z = `r fmt(z_two["truncation", "F1_het"], 2)`, the
#' max-diversity plan $GD_{BS}$ at z = `r fmt(z_two["max_div", "GD_BS"], 2)` and F1
#' heterozygosity at z = `r fmt(z_two["max_div", "F1_het"], 2)`. The rise of
#' $GD_{BS}$ under truncation is the usage-concentration effect that
#' @sec-era-step6 derives. The pair-level advantage of truncation is therefore
#' real against the null but smaller than that of the plan built for diversity.
#' Reported alone, $F_{hom}$ would have
#' called that plan the worst of the three for the very quantity -- product
#' heterozygosity -- on which it beats the random-subset null. The size of that
#' advantage is small (`r fmt(z_two["truncation", "F1_het"], 2)` null s.d.) and is
#' measured on one candidate set at the teaching scale. The `random` row, a single
#' draw, sits at z = `r fmt(z_two["random", "F1_het"], 2)` on the same column, so a
#' comparison against it alone would have overstated the advantage.
#' 
#' Within a heterotic pool under reciprocal recurrent selection, $F_{hom}$ on the
#' *pool's* own frequencies is still the right lens for one thing, and that one
#' thing is narrower than it is usually stated to be. It is the **segregating
#' crossing block**, which is not inbred and in which inbreeding depression is
#' therefore expressed:
#' $ID = 2F\sum_k d_k p_k q_k$ [@falconer1996, Ch. 14], with $d_k$ the dominance
#' deviation at locus $k$, $p_k$ and $q_k = 1 - p_k$ the pool's current
#' frequencies, and $F \in [0,1]$ the block's inbreeding coefficient relative to
#' random mating at those same *current* frequencies -- which is **not** the $F_t$
#' of this chapter's two lenses, measured against the frozen base $p_0$, and the
#' two must not be substituted for one another. @sec-heterosis-id verifies that
#' quantity against `heterosis_partition()`'s shared term. It is built from the
#' same per-locus product $p_k q_k$ that $F_{hom}$ aggregates -- but weighted by
#' $d_k$, which $F_{hom}$ does not carry, so $F_{hom}$ locates the erosion and
#' does not price it.
#' 
#' It does **not** anticipate the per-se value of the inbred lines themselves.
#' Under A2 a line has no heterozygous locus, so its dominance contribution is
#' exactly zero whatever the pool's frequencies are -- @sec-heterosis-id measures
#' that exact zero -- and a fully homozygous genotype's value is therefore the
#' additive sum $\sum_k a_k (2x_{ik} - 1)$ alone, the genotypic-value model of
#' @sec-heterosis with $x_{ik} \in \{0, 1\}$ at every locus and $a_k$ the per-locus
#' additive effect. Its pool mean moves with the frequencies in whichever direction
#' they move, so there is no directional decline there for $F_{hom}$ to anticipate. It also says nothing about between-pool
#' divergence (@sec-heterosis). Computed
#' instead on the homozygosity of individual inbred parents it is 1 by construction
#' -- assumption A2 -- and is **useless for management**. The mating system of the
#' species does not rescue that: an inbred maize line is as fixed as an inbred wheat
#' line. What distinguishes the hybrid programme is that the pool of lines can be
#' intermated, so the pool has a frequency vector worth managing even though none of
#' its members does.
#' 
#' ### `F_drift`, drift-based
#' 
#' $$F_{drift} = \frac{1}{N_{SNP}}\sum_k \frac{(p_{t,k} - p_{0,k})^2}{p_{0,k}(1 - p_{0,k})}$$ {#eq-era-fdrift}
#' 
#' with the same symbols as @eq-era-fhom [@meuwissen2020].
#' 
#' **Never negative.** It has the algebraic form of the standardised-variance
#' definition of $F_{ST}$ -- a variance of allele frequencies divided by
#' $p_0(1-p_0)$, the form @wright1951 introduced and @holsinger2009 separate from
#' the several other quantities that carry the same name -- but applied to *one
#' population through time* rather than to a set of populations in space. That is
#' an analogy of form, not an identity: nothing here is a between-subpopulation
#' variance, and the chapter's own $F_{ST}$ column (@sec-era-step6) is the Nei
#' $G_{ST}$ [@nei1973] of `gd_partition()`, a different statistic on a different partition.
#' $F_{drift}$ is exactly the quantity constrained when `G_VR2` goes into the
#' optimiser.
#' 
#' It protects against random change in phenotypic value for traits **outside** the
#' selection objective, against rare deleterious recessives rising to dangerous
#' frequencies, and against irreversible loss of rare alleles.
#' 
#' **It must not be read as a measure of *this programme's* selection intensity,
#' even though @meuwissen2020 offer exactly that reading for a locus under
#' directional selection.** They call $\delta p^2/[p_0(1-p_0)]$ "an approximation
#' to the squared total intensity ($i^2$) applied to the marker" (citing
#' @liu2010 for the underlying non-linearity), and where the only thing
#' moving frequencies is truncation selection on a trait, that reading is theirs
#' to make. But $F_{drift}$ is accumulated over **every** source of displacement a
#' scheme has -- selection, pure drift, and a diversity constraint that pushes
#' frequencies on its own -- and the three are not separable from the statistic
#' alone. @sec-era-step4 runs a crossing block with **no selection of any kind**
#' and $F_{drift}$ climbs across the cycles to a value the step reports, which
#' under an unconditional intensity reading would be a large intensity applied by
#' nothing; @sec-era-step2's `max_div` plan moves $F_{drift}$ by minimising
#' coancestry, not by selecting on any trait. Even where selection is the only
#' driver, the displacement is not a function of frequency alone: it depends on
#' the average effect of a gene substitution at that locus, $a + d\,(q - p)$
#' [@falconer1996, Ch. 7] -- classically written $\alpha$, which in this book is
#' the diversity-loss statistic instead (@sec-heterosis says the same) -- and on
#' the phenotypic standard deviation of the trait under selection, neither of
#' which appears anywhere in $F_{drift}$. So an intensity read off `F_drift` alone,
#' with no independent knowledge of what moved it, cannot be trusted, and this
#' chapter does not attempt one. What constraining `F_drift` does constrain is the
#' squared *displacement* of the genome from its base, whatever moved it.
#' 
#' A programme running six cycles of genomic selection with a VanRaden
#' $\mathbf{G}$ and reporting $\Delta F \approx 1\%$ has reported
#' $\Delta F_{drift}$ on the training panel. Quantitative disease-resistance loci
#' not yet prioritised may have hitch-hiked to extreme frequencies alongside yield
#' quantitative trait loci (QTL), and none of that appears in the reported metric.
#' 
#' ## The classical equivalence, and the covariance that destroys it
#' 
#' Under purely random drift, with $E[\delta p_t \mid p_0] = 0$ for every $p_0$,
#' 
#' $$\frac{\mathrm{var}(p_{t,k})}{p_0(1-p_0)} = 1 - \frac{H_t}{H_0}
#'   \;\;\Longrightarrow\;\; F_{drift} = F_{hom}.$$
#' 
#' The paper's central result, @eq-era-cov, quantifies the departure:
#' 
#' $$F_{hom} - F_{drift} \;=\; 2\,\mathrm{cov}\!\left(
#'   \frac{\delta p_{t,k}}{\sqrt{p_{0,k}(1-p_{0,k})}},\;
#'   \frac{p_{0,k} - 1/2}{\sqrt{p_{0,k}(1-p_{0,k})}}\right)$$ {#eq-era-cov}
#' 
#' [@meuwissen2020, their Eq. 3], where $\delta p_{t,k} = p_{t,k} - p_{0,k}$ and
#' the covariance is taken over markers with divisor $N_{SNP}$ -- which is why
#' `freq_metrics()` computes it as `2 * mean(x * y)` and not with `cov()`. The two
#' differ for two independent reasons: `stats::cov()` divides by $N_{SNP} - 1$,
#' and $\overline{xy} = \mathrm{cov}_{N}(x, y) + \bar x\,\bar y$, so the product
#' term vanishes only if *one of the two means* is zero -- either will do, and
#' neither is zero here.
#' 
#' In words: **if the direction of frequency change is correlated with the starting
#' frequency, the two measures diverge.** The non-obvious part is that this
#' covariance is induced by the *diversity management itself*, not by directional
#' selection -- @meuwissen2020 demonstrate this by running the scheme with random
#' genomic estimated breeding values (GEBVs), and the divergence persists.
#' 
#' ### Verifying the identity
#' 
#' `freq_metrics()` returns all three quantities -- @eq-era-fhom, @eq-era-fdrift and
#' @eq-era-cov -- in one marker sweep. The identity
#' is asserted in `tests/testthat/test-lenses.R`; here it is on live data
#' (@tbl-era-identity, @tbl-era-identity-residual):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-identity
#| tbl-cap: "F_hom, F_drift and cov_diag of one random 60-hybrid selection (seed 31) against the frozen base, from a single `freq_metrics()` call. Dimensionless."
set.seed(31)
idx <- sample.int(ctx$N, 60)
fm <- freq_metrics(idx, ctx)
fmt(as.data.frame(t(fm[c("F_hom", "F_drift", "cov_diag")])), 6)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-identity-residual
#| tbl-cap: "The identity of @eq-era-cov on the selection of @tbl-era-identity, over the markers polymorphic in the base. F_hom_minus_F_drift and cov_diag: the two sides; residual: their difference; mean_x, mean_y: marker-wise means of the two standardised vectors of @eq-era-cov; two_times_R_cov: `2 * cov(x, y)` with the n - 1 divisor of `stats::cov()`. Dimensionless, six significant digits."
stopifnot(isTRUE(all.equal(fm[["cov_diag"]], fm[["F_hom"]] - fm[["F_drift"]])))
# The two standardised marker vectors of Eq. 3, on the markers polymorphic in
# the base, so `2 * mean(x * y)` can be put next to `2 * cov(x, y)`.
keep <- ctx$p0 > 1e-6 & ctx$p0 < 1 - 1e-6
sdv  <- sqrt(ctx$p0[keep] * (1 - ctx$p0[keep]))
x    <- (colMeans(ctx$X[idx, keep, drop = FALSE]) - ctx$p0[keep]) / sdv
y    <- (ctx$p0[keep] - 0.5) / sdv
stopifnot(isTRUE(all.equal(2 * mean(x * y), unname(fm[["cov_diag"]]))))
data.frame(value = formatC(c(
  F_hom_minus_F_drift = unname(fm[["F_hom"]] - fm[["F_drift"]]),
  cov_diag            = unname(fm[["cov_diag"]]),
  residual            = unname(fm[["cov_diag"]] - (fm[["F_hom"]] - fm[["F_drift"]])),
  mean_x              = mean(x),
  mean_y              = mean(y),
  two_times_R_cov     = 2 * stats::cov(x, y)), digits = 6, format = "g"))

#' 
#' Exact to machine precision, and the two `stopifnot()`s mean this page cannot
#' render if it stops being. The last three rows of @tbl-era-identity-residual are the point of the previous
#' paragraph: neither marker-wise mean is zero, so `2 * cov(x, y)` returns
#' `r sprintf("%.6f", 2 * stats::cov(x, y))` where the quantity @eq-era-cov defines is
#' `r sprintf("%.6f", fm[["cov_diag"]])`. And when the selection *is* the base,
#' both lenses must read zero:
#' 
## -----------------------------------------------------------------------------
#| label: era-base-zero
base0 <- freq_metrics(seq_len(ctx$N), ctx)[c("F_hom", "F_drift", "cov_diag")]
stopifnot(all(abs(base0) < 1e-12))
fmt(base0, 12)  # verification echo: asserted zero by the stopifnot() above

#' 
#' ### Why each matrix generates a sign
#' 
#' @tbl-era-matrix-signs gives the sign of the covariance in @eq-era-cov that each
#' relationship matrix generates when it is the constraint, and the mechanism.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-matrix-signs
#| tbl-cap: "The sign of the bias is a property of the matrix, not of the data: sign of the covariance of @eq-era-cov generated by each matrix used as the optimiser's constraint. Mechanisms as set out by @meuwissen2020, their Discussion and Supplementary Information 1; the di/dp expression in the last row is theirs, after @liu2010."
#| echo: false
knitr::kable(data.frame(
  Matrix = c("G_VR2", "G_0.5", "G_VR1", "G_i(p)"),
  Covariance = c("positive", "negative", "positive, attenuated", "negative"),
  Mechanism = c(
    "the constraint penalises delta-p^2, so moving an allele to the *far* extreme costs more than to the near one; the optimiser pushes rare alleles to 0 and common ones to 1",
    "frequencies are measured as deviations from 0.5, so the optimiser buys 'diversity' by pushing everything to intermediate frequencies",
    "G_VR2 reweighted by 2p0(1-p0), giving more weight to already-intermediate loci and less room at the extremes",
    "uses accumulated intensity instead of delta-p^2; since di/dp = [p(1-p)]^-1/2, moves toward the extremes get more expensive"),
  check.names = FALSE))

#' 
#' ::: {.callout-warning}
#' ## Your minor-allele-frequency (MAF) spectrum decides how bad this is
#' 
#' @meuwissen2020 state this as an expectation rather than as a measured
#' comparison: "the covariance generated is expected to be larger for WGS data
#' where allele frequencies are extreme with typical MAF close to 0, than for SNP
#' (chip) panels where allele frequencies are generally closer to 1/2" (their
#' second Conclusion bullet), having observed that the strength of the covariance
#' "depends on the distribution of $(p_0 - \tfrac12)$" (their Discussion). Their own
#' simulation used four panels, all random samples of the same whole-genome
#' sequence (WGS) data (a single-nucleotide polymorphism (SNP) panel for best linear
#' unbiased prediction (SNP-BLUP), a neutral panel, a QTL panel and a second
#' management panel) -- none a SNP chip -- so the comparison across a WGS panel
#' and a chip panel is an inference from the algebra of @eq-era-cov and not a result of
#' their experiment either.
#' 
#' The algebra can be made a number, which is worth doing because it decides whether
#' `G_VR2` is usable. Apply one deterministic management rule -- move every frequency
#' 5% of the way toward 0.5, the caricature of a heterozygosity-maximising
#' constraint used again in @sec-era-step4 -- to a sequence-like panel whose folded
#' site-frequency spectrum has density proportional to $1/[p(1-p)]$, and then to
#' MAF-filtered subsets of the *same* draw (@tbl-era-maf-weight):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-maf-weight
#| tbl-cap: "One deterministic management rule, every frequency moved 5% of the way toward 0.5, applied to a simulated sequence-like panel (200000 sites, folded spectrum with density proportional to 1/[p(1-p)] on [0.001, 0.999], seed 21) and to MAF-filtered subsets of the same draw. maf_floor: smallest minor-allele frequency kept; markers: sites retained; kappa: the panel statistic, mean of (p0 - 0.5)^2/[p0(1-p0)]; F_hom, F_drift, cov_diag: the three lenses after one application of the rule. Dimensionless."
set.seed(21)
# Folded site-frequency spectrum with density proportional to 1/[p(1-p)] on
# [1e-3, 1 - 1e-3]: the logit of p is uniform. One draw, filtered four ways.
p_seq <- plogis(runif(2e5, qlogis(1e-3), qlogis(1 - 1e-3)))
maf_row <- function(floor, pull = 0.05) {
  p0 <- p_seq[pmin(p_seq, 1 - p_seq) >= floor]
  p1 <- p0 + pull * (0.5 - p0)                 # the rule, applied exactly
  s2 <- p0 * (1 - p0)
  c(maf_floor = floor, markers = length(p0),
    kappa = mean((p0 - 0.5)^2 / s2),           # the panel's own weight
    F_hom = 1 - mean(p1 * (1 - p1) / s2),
    F_drift = mean((p1 - p0)^2 / s2),
    cov_diag = 2 * mean((p0 - 0.5) * (p1 - p0) / s2))
}
mafw <- as.data.frame(t(sapply(c(0.001, 0.01, 0.05, 0.20), maf_row)))
# Under this rule all three lenses are multiples of one panel statistic, kappa.
stopifnot(isTRUE(all.equal(mafw$F_drift, 0.05^2 * mafw$kappa)),
          isTRUE(all.equal(mafw$cov_diag, -2 * 0.05 * mafw$kappa)))
keep0  <- ctx$p0 > 1e-6 & ctx$p0 < 1 - 1e-6        # as freq_metrics() drops them
kappa_book <- mean((ctx$p0[keep0] - 0.5)^2 / (ctx$p0[keep0] * (1 - ctx$p0[keep0])))
fmt(mafw, 4)

#' 
#' Under a rule of this form $\delta p = c\,(0.5 - p_0)$ the algebra is exact:
#' $F_{drift} = c^2 \kappa$ and `cov_diag` $= -2c\kappa$ with
#' $\kappa = \overline{(p_0 - 0.5)^2 / [p_0(1-p_0)]}$, the panel statistic the
#' `stopifnot()` above verifies. Everything about the panel enters through $\kappa$, and
#' $\kappa$ is `r fmt(mafw$kappa[1] / mafw$kappa[3], 1)` times larger at a MAF floor of 0.001
#' than at 0.05 on the same draw: `cov_diag` moves from
#' `r fmt(mafw$cov_diag[1], 3)` to `r fmt(mafw$cov_diag[3], 3)` for the same 5%
#' pull. For reference, this book's own hybrid panel has $\kappa =$ `r fmt(kappa_book, 2)`
#' over the `r sum(keep0)` markers polymorphic in the base, which sits at the
#' chip-like end of that table -- a consequence of the $U(0.05, 0.95)$ ancestral
#' draw of `simulate_lines()`, not of anything biological.
#' 
#' **Translated to plants, as a stated expectation and not as a measurement on real
#' germplasm:** genotyping-by-sequencing (GBS) or skim-seq retaining the full spectrum puts a programme at the
#' high-$\kappa$ end; a 20-50k chip filtered to MAF > 0.05 puts it at the low-$\kappa$ end. The
#' rule above is a caricature, not an optimiser, so the *ratio* between panels is
#' the transferable part and the absolute values are not.
#' :::
#' 
#' ## The other matrices, briefly
#' 
#' **`F_IBD` via `G_LA`.** Instead of assuming a 50/50 transmission probability for
#' each parental allele (as the pedigree matrix $\mathbf{A}$ does), linkage
#' analysis over the markers infers which parental haplotype was actually
#' transmitted along the chromosome. It requires pedigree **and** markers. It
#' measures IBD relative to a base explicitly defined as unrelated and
#' non-inbred, so frequency change is determined by the base population rather
#' than by linkage disequilibrium generated during selection -- and the
#' problematic covariance disappears. It was the **only scheme tested that met
#' both the $\Delta F_{hom}$ and $\Delta F_{drift}$ targets**, on the managed panel
#' and at unmonitored neutral loci. On gain it was not the highest in absolute
#' terms; what @meuwissen2020 report is that at the *same* averaged inbreeding --
#' interpolating each scheme's gain to the mean of $F_{hom}$ and $F_{drift}$ --
#' `G_LA` beat $\mathbf{A}$ in 65 of 100 replicates and `G_ROH` in 62 of 100
#' (their Genetic Gain section).
#' 
#' For a hybrid programme this is the point of greatest friction, and also the one
#' where the news is best. In biparental populations and backcross families
#' `G_LA` is natural and cheap -- phase is known and the number of meioses since
#' the base is small. In a maize recurrent-selection population with a complete
#' recycling pedigree -- which a programme that records the F1 parents of every DH
#' line has -- it is feasible. In a germplasm panel *without*
#' pedigree it is inapplicable, and the honest alternative is segment-based IBD.
#' 
#' **`F_ROH`.** A run of homozygosity is an uninterrupted stretch of homozygous
#' markers; the logic is that many consecutive markers are unlikely to be IBS by
#' chance, so the stretch is probably IBD. The fundamental ambiguity is that
#' `F_ROH` is IBD when runs are **long** (recent inbreeding) and homozygosity when
#' they are **short** (ancient inbreeding, accumulated IBS). The minimum-length
#' threshold is therefore a knob that selects the *age* of inbreeding you are
#' measuring, and there is no well-defined reference base.
#' 
#' Empirically, `G_ROH` behaved more like `G_0.5` than like an IBD measure. It also
#' is **not guaranteed positive semi-definite** -- its elements are computed
#' pairwise -- and required substantial diagonal additions for inversion, which
#' made it diagonally dominant and artificially inflated the number of parents
#' selected.
#' 
#' In an inbred parent line the entire genome is one ROH and $F_{ROH} \approx 1$:
#' the metric saturates for exactly the reason assumption A2 makes every
#' individual-level coefficient useless. Applied instead to the *hybrids*, or to
#' the segregating crossing block from which DH lines are induced, it is useful for
#' diagnosing erosion of an elite pool. For *management* inside an optimiser, check
#' positive definiteness carefully -- @sec-era-step7 shows the check.
#' 
#' ### Side by side
#' 
#' @tbl-era-side-by-side summarises how each of the seven matrices behaved in the
#' optimiser of @meuwissen2020.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-side-by-side
#| tbl-cap: "Seven matrices in the same optimiser [@meuwissen2020, their Tables 2 and 3, Figure 5 and Discussion]. The Behaviour column is qualitative and no number from either panel is transcribed in this table; where a rate is invoked (@tbl-era-reference-results), it is always the *unmonitored neutral* panel N. The one exception is G_VR2's 'only on the managed panel', a paraphrase of their Discussion that reports a Panel M outcome without a Panel M number appearing anywhere in this chapter. Class is the lens the matrix is *computed* from, which is why G_ROH sits with homozygosity -- the Hybrid row of @tbl-era-lenses is the same matrix labelled by its intended *interpretation*."
#| echo: false
knitr::kable(data.frame(
  Matrix = c("A", "G_VR2", "G_VR1", "G_0.5", "G_i(p)", "G_LA", "G_ROH"),
  Class = c("IBD (expectation)", "drift", "drift", "homozygosity", "drift",
            "IBD", "homozygosity, read as IBD"),
  `Behaviour in the optimiser` = c(
    "high gain, but exceeded both rate targets, the drift one by more, by not accounting for within-family linkage disequilibrium",
    "meets the drift target *only on the managed panel*; F_hom runs away",
    "reweighted version; smaller bias, smaller gain",
    "misses the drift target by the widest margin of the nine schemes they ran; loses genetic variance early",
    "inverts the sign of the bias; constraint only indirectly tied to F",
    "the only one meeting both targets; highest gain at equal averaged inbreeding",
    "high gain, uncontrolled drift, numerical problems"),
  check.names = FALSE))

#' 
#' ## Reference results
#' 
#' Target $\Delta F = 0.005$ per generation ($N_e = 100$). Values at the
#' **unmonitored neutral loci** (their Panel N), generation 20, as reported by
#' @meuwissen2020. @tbl-era-reference-results transcribes four columns and derives
#' one:
#' 
#' - `dF_hom`, `dF_drift` and `gap` are the three Panel N columns of their Table 2.
#'   `gap` is the *level* $F_{hom} - F_{drift}$ reached in generation 20, not a
#'   rate and not a difference of the two rate columns; it is `cov_diag` of @eq-era-cov
#'   accumulated over the 20 generations. Their reported standard errors are
#'   $< 2.5 \times 10^{-5}$ on the rates and $< 2.2 \times 10^{-4}$ on `gap`.
#' - `gain` is their Table 3: cumulative genetic gain after 20 generations,
#'   expressed in units of the **initial genetic standard deviation**, standard
#'   errors $\le 0.004$.
#' - `gain_per_dF` is computed here, not transcribed, and is **not** the device
#'   @meuwissen2020 use: their own interpolation (Genetic Gain section, their
#'   Figure 5) compares gains at a common generation-20 *level* of averaged
#'   inbreeding, $(F_{hom} + F_{drift})/2$ from their Table 3 -- a stock -- not at
#'   a common mean of the two *rate* columns used here. `gain_per_dF` is offered
#'   only as a same-chapter summary of @tbl-era-reference-results, and reading 1
#'   below states explicitly which ordering it does and does not support.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-reference-results
#| tbl-cap: "Eight schemes of @meuwissen2020 at the unmonitored neutral loci (Panel N), generation 20. dF_hom and dF_drift: rates of inbreeding per generation on the two lenses; gap: level of F_hom - F_drift reached in generation 20; gain: cumulative genetic gain after 20 generations, in initial genetic standard deviations (their Tables 2 and 3). gain_per_dF: gain divided by the mean of the two rate columns, derived in this chunk. Both rate targets are 0.005 per generation; only G_LA meets both."
#| echo: false
ref_res <- data.frame(
  Scheme = c("G_VR2(M,M)", "G_VR2(M,D)", "G_VR1(M,M)", "G_i(p)(M,M)",
             "G_0.5(M,M)", "G_ROH(M,M)", "G_LA(M,M)", "A(M,~)"),
  Class = c("drift", "drift", "drift", "drift", "homozygosity",
            "homozygosity", "IBD", "IBD"),
  dF_hom = c(0.0103, 0.0101, 0.0080, 0.0065, 0.0073, 0.0054, 0.0043, 0.0070),
  dF_drift = c(0.0068, 0.0068, 0.0069, 0.0077, 0.0176, 0.0088, 0.0049, 0.0084),
  gap = c(0.054, 0.050, 0.021, -0.031, -0.170, -0.070, -0.010, -0.021),
  gain = c(7.124, 7.107, 6.680, 7.111, 6.734, 9.099, 7.188, 9.890),
  check.names = FALSE)
ref_res$gain_per_dF <- round(ref_res$gain /
                               ((ref_res$dF_hom + ref_res$dF_drift) / 2))
# The qualitative claims the previous table makes about a rate: G_0.5 is the
# scheme furthest from the 0.005 drift target of the eight transcribed here (the
# ninth they ran, G_VR2(~,M) with random GEBVs, has dF_drift = 0.0059 in their
# Table 2, Panel N, below G_0.5's), A exceeds both targets and the drift one by more,
# and G_LA is the only scheme within both.
stopifnot(ref_res$Scheme[which.max(ref_res$dF_drift)] == "G_0.5(M,M)",
          0.0059 < max(ref_res$dF_drift))
a_row  <- ref_res$Scheme == "A(M,~)"
la_row <- ref_res$Scheme == "G_LA(M,M)"
stopifnot(ref_res$dF_drift[a_row] > ref_res$dF_hom[a_row],
          ref_res$dF_hom[a_row] > 0.005,
          ref_res$Scheme[ref_res$dF_hom <= 0.005 & ref_res$dF_drift <= 0.005] == "G_LA(M,M)")
knitr::kable(ref_res)

#' 
#' Four readings:
#' 
#' 1. **No IBS scheme met both targets; the IBD scheme `G_LA` met both**, the
#'    targets being ceilings [@meuwissen2020, Conclusion]. On Panel N its
#'    `dF_drift` is `r fmt(100 * (1 - ref_res$dF_drift[la_row] / 0.005), 0)`% under
#'    0.005 (their Table 2 gives the same 0.0049 for Panel M, not transcribed here,
#'    and their text states "within 2% of the target for both Panels M and N")
#'    and its `dF_hom` `r fmt(100 * (1 - ref_res$dF_hom[la_row] / 0.005), 0)`% under
#'    it (`r ref_res$dF_hom[la_row]` against 0.005). It also has
#'    the largest `gain_per_dF`, `r max(ref_res$gain_per_dF)` against
#'    `r ref_res$gain_per_dF[ref_res$Scheme == "A(M,~)"]` for $\mathbf{A}$ and
#'    `r ref_res$gain_per_dF[ref_res$Scheme == "G_ROH(M,M)"]` for `G_ROH` -- but
#'    that ordering is not robust to the denominator: against `dF_hom` alone
#'    `G_ROH` is marginally ahead
#'    (`r round(ref_res$gain[ref_res$Scheme == "G_ROH(M,M)"] / ref_res$dF_hom[ref_res$Scheme == "G_ROH(M,M)"])`
#'    against
#'    `r round(ref_res$gain[ref_res$Scheme == "G_LA(M,M)"] / ref_res$dF_hom[ref_res$Scheme == "G_LA(M,M)"])`).
#'    The claim that survives is the replicate-level one in reading 4, not a ratio
#'    of table means.
#' 2. Pedigree $\mathbf{A}$ gave the highest absolute gain but overshot the 0.005
#'    target by `r fmt(100 * (ref_res$dF_hom[a_row] / 0.005 - 1), 0)`% on `dF_hom`
#'    and by `r fmt(100 * (ref_res$dF_drift[a_row] / 0.005 - 1), 0)`% on `dF_drift`
#'    (Panel N; their Results text rounds both to 40%) -- neutral loci hitch-hiking with QTL through within-family linkage disequilibrium, which the
#'    pedigree expectation of IBD cannot capture.
#' 3. Using a separate panel for management instead of the GEBV panel changed gain
#'    by `r fmt(100 * abs(1 - ref_res$gain[ref_res$Scheme == "G_VR2(M,D)"] / ref_res$gain[ref_res$Scheme == "G_VR2(M,M)"]), 2)`%
#'    (`G_VR2(M,D)` against `G_VR2(M,M)`). Not worth the complexity as a *gain* measure; it is
#'    still worth it as an *audit* measure, which is a different use and is the
#'    subject of @sec-era-step5 below.
#' 4. At equal mean inbreeding, `G_LA` beat $\mathbf{A}$ in 65 of 100 replicates
#'    and `G_ROH` in 62 of 100.
#' 
#' Those are animal-breeding numbers under the assumptions of
#' @sec-era-transposition, and none of them is reproduced here. What follows is.
#' 
#' ## The monitoring protocol {#sec-era-protocol}
#' 
#' Seven steps, in the order a cycle report is assembled. Each one names the
#' function to call, the quantity to check, and what a failure looks like.
#' 
#' ### Step 1 -- Freeze $p_0$ at the founding cycle {#sec-era-step1}
#' 
#' Both lenses are ratios to a base, so the base is the first thing a cycle report
#' has to pin down. In this book it is `ctx$p0`, the candidate-pool allele
#' frequencies, set once in `build_ctx()` and carried forward unchanged by
#' `run_cycles()`.
#' 
#' At the hybrid level the base is not a free choice: on the full factorial it is
#' the average of the two pool bases, exactly (@tbl-era-p0-identity).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-p0-identity
#| tbl-cap: "Largest marker-wise absolute difference between the hybrid-level base (column means of the hybrid set) and the average of the two pool bases (p_A + p_B)/2, in allele-frequency units, for four hybrid sets: the full factorial of the teaching scale (A8), a complete factorial with unequal pool sizes, a balanced incomplete factorial with every line in the same number of hybrids (sizes in the text below) and the 60-hybrid truncation selection. The first three are asserted equal to zero to numerical tolerance."
stopifnot(isTRUE(all.equal(ctx$p0, as.vector((P0["A", ] + P0["B", ]) / 2))))
# Unequal pool sizes, still a complete factorial: each pool-A line appears in
# n_pool_B hybrids and each pool-B line in n_pool_A, so the internal weight
# stays uniform within each pool and the identity is untouched.
cfg_u <- utils::modifyList(book_cfg, list(n_pool_A = 10, n_pool_B = 40))
ctx_u <- simulate_data(cfg_u)
Pu    <- pool_freqs(simulate_lines(cfg_u) / 2,
                    rep(c("A", "B"), c(cfg_u$n_pool_A, cfg_u$n_pool_B)))
# A balanced INCOMPLETE factorial -- not the full n_A*n_B hybrids, but each
# line still used equally often within its own pool (a cyclic 1-to-3 design,
# the shape of a real NCII): the identity does not need completeness.
k <- 3
idx_bal <- unlist(lapply(seq_len(book_cfg$n_pool_A), function(a) {
  bpart <- ((a - 1 + 0:(k - 1)) %% book_cfg$n_pool_B) + 1
  which(ctx$ped$a == a & ctx$ped$b %in% (bpart + book_cfg$n_pool_A))
}))
p_bal <- colMeans(ctx$X[idx_bal, , drop = FALSE])
# An UNbalanced candidate set with concentrated line usage: it is not.
p_sub <- colMeans(ctx$X[sel_truncation(ctx, 60), , drop = FALSE])
stopifnot(isTRUE(all.equal(ctx_u$p0, as.vector((Pu["A", ] + Pu["B", ]) / 2))),
          isTRUE(all.equal(p_bal, as.vector((P0["A", ] + P0["B", ]) / 2))))
data.frame(max_abs_deviation = formatC(c(
  complete_balanced      = max(abs(ctx$p0 - (P0["A", ] + P0["B", ]) / 2)),
  complete_unequal_pools = max(abs(ctx_u$p0 - (Pu["A", ] + Pu["B", ]) / 2)),
  incomplete_balanced    = max(abs(p_bal - (P0["A", ] + P0["B", ]) / 2)),
  truncation_subset      = max(abs(p_sub - (P0["A", ] + P0["B", ]) / 2))), digits = 3, format = "g"))

#' 
#' Each pool-A line appears in `r book_cfg$n_pool_B` hybrids and each pool-B line
#' in `r book_cfg$n_pool_A`, so a column mean over the factorial is
#' $(p_A + p_B)/2$ with no weighting left over. Two consequences a breeder should
#' read off this identity. First, freezing $p_0$ at the hybrid level freezes both
#' pool bases *jointly*, so the hybrid-level lenses cannot attribute erosion to one
#' pool -- that is @sec-era-step6's job. Second -- and this is the part that is
#' easy to state wrongly -- what the identity requires is **uniform line usage
#' within each pool**, not completeness of the factorial as such. With
#' `r cfg_u$n_pool_A` lines in one pool against `r cfg_u$n_pool_B` in the other,
#' still complete, the identity holds to
#' `r sprintf("%.1e", max(abs(ctx_u$p0 - (Pu["A", ] + Pu["B", ]) / 2)))`. It holds
#' just as exactly (`r sprintf("%.1e", max(abs(p_bal - (P0["A", ] + P0["B", ]) / 2)))`)
#' on a **balanced but incomplete** factorial -- `r length(idx_bal)` of the
#' `r book_cfg$n_pool_A * book_cfg$n_pool_B` possible hybrids, each line used
#' exactly `r k` times, the shape of a real North Carolina Design II (NCII) -- because each pool's
#' lines are still used equally often *within* that pool. What re-weights the two
#' pools inside the base is unequal **line usage**, which a balanced partial
#' factorial does not have and a selected subset typically does: the column means
#' of the 60-hybrid truncation set depart from $(p_A + p_B)/2$ by up to
#' `r fmt(max(abs(p_sub - (P0["A", ] + P0["B", ]) / 2)), 3)` on a single marker,
#' because truncation concentrates hybrids on a few high-value lines in each pool.
#' A base computed on a set with unequal line usage is therefore a different
#' base -- which is the failure mode below, and not a property of the design
#' being a factorial or not.
#' 
#' Now the failure mode. `build_ctx()` recomputes `p0 <- colMeans(X)` on every
#' call, so rebuilding the context from the *selected* hybrids each cycle -- which
#' is what re-running a `G`-construction function per cycle amounts to -- re-anchors
#' the base on the population you were about to measure (@tbl-era-rebase):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-rebase
#| tbl-cap: "F_hom, F_drift and cov_diag of the 60-hybrid max-diversity greedy selection (`w = 0`) scored against the frozen base `ctx$p0` (frozen_base) and against a base recomputed from the selected hybrids themselves (rebased). Dimensionless."
i_md   <- sel_greedy(ctx, 60, w = 0)
Xs     <- ctx$X[i_md, , drop = FALSE]
rebase <- build_ctx(X = Xs, f = molecular_coancestry(Xs), G = NULL,
                    traits = ctx$traits[i_md, , drop = FALSE],
                    ped = ctx$ped[i_md, ], n_lines = ctx$n_lines,
                    pool = ctx$pool, fL = ctx$fL, cfg = NULL)
rb <- rbind(frozen_base = freq_metrics(i_md, ctx)[c("F_hom", "F_drift", "cov_diag")],
            rebased     = freq_metrics(seq_along(i_md), rebase)[c("F_hom", "F_drift", "cov_diag")])
stopifnot(all(abs(rb["rebased", ]) < 1e-12))
fmt(rb, 6)

#' 
#' Not attenuated -- **identically zero, both lenses**. A rebased report is not a
#' conservative report or a noisy one; it is a report that cannot detect erosion at
#' all, and it will look clean for as many cycles as you run it.
#' 
#' The check has to be on the base itself, and it has to be the right check. If the
#' base is stored per cycle, comparing each cycle's vector with cycle 0's catches
#' the failure; collapsing the whole history into a `range()` does not, because
#' `range()` discards the cycle dimension and returns the marker-wise spread of
#' $p_0$, the same number whether the base moved or not -- here
#' `r fmt(diff(range(ctx$p0)), 2)`, the whole unit interval, because
#' `r sum(ctx$p0 <= 1e-6 | ctx$p0 >= 1 - 1e-6)` of the `r ctx$m` markers are fixed
#' in the candidate pool (@tbl-era-p0-frozen-check):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-p0-frozen-check
#| tbl-cap: "Three checks on a stored three-cycle history of the base: every cycle carrying cycle 0's p0 (frozen), and the last cycle carrying the rebased p0 of @tbl-era-rebase (rebased). all_identical_to_cycle0: every stored vector identical to cycle 0's; max_abs_deviation: largest marker-wise absolute difference from cycle 0, in allele-frequency units; collapsed_range: range of the flattened history."
chk <- function(h) {
  data.frame(
    all_identical_to_cycle0 = all(vapply(h, identical, logical(1), h[[1]])),
    max_abs_deviation       = max(vapply(h, function(p) max(abs(p - h[[1]])), 0)),
    collapsed_range         = diff(range(unlist(h))))
}
fmt(rbind(frozen  = chk(list(ctx$p0, ctx$p0, ctx$p0)),
          rebased = chk(list(ctx$p0, ctx$p0, rebase$p0))), 4)

#' 
#' The first two columns separate the two histories; the third is the same number
#' in both rows, which is the whole point.
#' 
#' **Call.** `build_ctx()` once at cycle 0; pass `p0` forward (`run_cycles()` does
#' this through its internal `cycle_ctx()`).
#' **Check.** `identical(ctx$p0, p0_cycle0)` at every cycle -- one `TRUE`, with no
#' tolerance. With a stored history,
#' `max(vapply(p0_history, function(p) max(abs(p - p0_history[[1]])), 0))`, which
#' must be exactly 0. Never a `range()` over the flattened history.
#' **Warning sign.** $F_{drift}$ near zero in a cycle where line usage was visibly
#' concentrated, or an $F_{drift}$ series that does not accumulate across cycles.
#' **Threshold.** There is none to tune: the correct value of the base drift is
#' exactly zero.
#' 
#' ### Step 2 -- Compute both lenses in one marker sweep {#sec-era-step2}
#' 
#' `freq_metrics()` is the single sweep: it computes $He$, `alleles_lost`,
#' $F_{hom}$, $F_{drift}$, `cov_diag`, `cor_dp_p0` and `rare_retained` from one
#' `colMeans(X[idx, ])`. Anything else needing the selected frequencies belongs
#' inside it, not in a second function with its own sweep.
#' 
#' The pure max-diversity greedy is the `G_0.5` scheme in miniature: it constrains
#' molecular coancestry and nothing else. Its signature has to be read against a
#' **resampled** baseline rather than against one random draw, for the reason the
#' numbers below make explicit. The baseline is the package's own
#' `null_distribution()` (built in @sec-era-fhom, `r nrow(null60$full)` resampled
#' subsets of the same size), and the z-scores
#' come from `discriminatory_power()`, so the comparison is the same machinery
#' every scenario in @sec-case-study is reported through (@tbl-era-signature, @tbl-era-signature-z):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-signature
#| tbl-cap: "Both lenses and their covariance for the four 60-hybrid selections of @tbl-era-hom-two-levels: mean (null_mean) and standard deviation (null_sd) over the random-subset null of @tbl-era-hom-two-levels-null, then each selection's value. He: merged-pool gene diversity; rare_retained: share of the markers rare in the candidate pool that still segregate in the selection (`freq_metrics()`). Dimensionless."
# `sels` and the random-subset null `null60` are built in @sec-era-fhom.
cols   <- c("He", "F_hom", "F_drift", "cov_diag", "rare_retained")
panel  <- t(sapply(sels, freq_metrics, ctx = ctx))[, cols]
fmt(rbind(null_mean = colMeans(null60$full[, cols]),
          null_sd   = apply(null60$full[, cols], 2, stats::sd),
          panel), 4)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-signature-z
#| tbl-cap: "z-scores of the selections of @tbl-era-signature against the same random-subset null, from `discriminatory_power()`, in null standard deviations."
z <- discriminatory_power(evaluate(sels, ctx, null60$gd_ref), null60)[, cols]
fmt(as.data.frame(z), 2)

#' 
#' Result. The max-diversity plan drives $F_{hom}$ negative,
#' `r fmt(panel["max_div", "F_hom"], 4)`, which is
#' `r fmt(abs(z["max_div", "F_hom"]), 1)` s.d. below a null mean of
#' `r fmt(mean(null60$full[, "F_hom"]), 4)`: the selection is more heterozygous on
#' the monitored panel than the frozen base. Its `cov_diag` is
#' `r fmt(panel["max_div", "cov_diag"], 4)`, `r fmt(abs(z["max_div", "cov_diag"]), 1)`
#' s.d. below a null centred on
#' `r sprintf("%.4f", mean(null60$full[, "cov_diag"]))`. Its $F_{drift}$, however,
#' is `r fmt(panel["max_div", "F_drift"], 4)` against a null mean of
#' `r fmt(mean(null60$full[, "F_drift"]), 4)`: a z of
#' `r fmt(z["max_div", "F_drift"], 2)`, and
#' `r fmt(100 * mean(null60$full[, "F_drift"] > panel["max_div", "F_drift"]), 0)`%
#' of the `r nrow(null60$full)` resampled subsets pay **more** drift than it does. Truncation is the
#' row with the drift bill: $F_{drift}$ = `r fmt(panel["truncation", "F_drift"], 4)`,
#' z = `r fmt(z["truncation", "F_drift"], 1)`.
#' 
#' This is where one draw would have misled. The `random` row is a single subset,
#' and its $F_{drift}$ sits `r fmt(abs(z["random", "F_drift"]), 1)` s.d. below the
#' resampled mean -- *further* below it than `max_div` is -- so a two-row
#' `random`-versus-`max_div` comparison reports max-diversity as paying more drift
#' than random, which the `r nrow(null60$full)`-subset null says it does not. The failure is not the
#' metric, it is the baseline: with a null s.d. of
#' `r sprintf("%.4f", sd(null60$full[, "F_drift"]))` on a quantity whose value is
#' `r fmt(panel["max_div", "F_drift"], 4)`, no single draw can serve as a control.
#' 
#' Interpretation, and what it does not license. At this scale, on a single
#' selection from a fixed candidate set, **minimising** molecular coancestry (the
#' `max_div` plan, `w = 0`, which maximises gene diversity `GD = 1 - theta`) buys a
#' measurable divergence between the two lenses -- the negative covariance that the
#' `G_0.5` row of @tbl-era-matrix-signs predicts -- and **no** measurable drift
#' excess over random sampling. The drift excess @meuwissen2020 report for `G_0.5`
#' ($\Delta F_{drift} =$ `r ref_res$dF_drift[ref_res$Scheme == "G_0.5(M,M)"]` against a 0.005 target) is a 20-generation
#' *cumulative* result under recurrent optimal contributions, where each cycle's
#' frequency change compounds on the last; one subset drawn once from one candidate
#' pool is not that experiment, and the honest way to run it here is the
#' multi-cycle arm of @sec-era-step4, where the same pull toward 0.5 does produce
#' a drift stock larger than the neutral one, accumulated at a rate that is not
#' constant (both measured there). What survives at one cycle is the
#' covariance, and a report carrying only $F_{hom}$ would not show it.
#' 
#' One thing @tbl-era-signature quietly says about the *weight* rather than the metric:
#' 
## -----------------------------------------------------------------------------
#| label: era-w1-equals-truncation
# The balanced greedy (w = 1) and truncation return the same 60 hybrids.
stopifnot(identical(sort(sel_greedy(ctx, 60, w = 1)), sort(sel_truncation(ctx, 60))))

#' 
#' At this scale `w = 1` is not a compromise between index and coancestry -- it
#' returns the truncation set exactly, because the index is standardised to unit
#' variance (`sd(ctx$index)` = `r fmt(sd(ctx$index), 3)`) while the spread of
#' $\theta$ across candidate subsets of the same size is
#' `r sprintf("%.2e", sd(null60$cheap[, "theta"]))`, the standard deviation of the
#' `theta` column over the `r nrow(null60$cheap)` cheap-metric resamples of the
#' same null. That is a ratio of
#' `r fmt(sd(ctx$index) / sd(null60$cheap[, "theta"]), 0)`: three orders of
#' magnitude, not two. A linear weight has to be calibrated to that ratio, which
#' is why `sel_greedy_budget()` sweeps a *logarithmic* grid of `w` instead of
#' trusting any single value.
#' 
#' **Call.** `freq_metrics(idx, ctx)` per cycle; `metrics_cheap()` if you also need
#' the coancestry block, `metrics_full()` post-hoc for the expensive ones.
#' **Check.** Both lenses present in the report, side by side, with the sign of
#' $F_{hom}$ preserved (never take an absolute value or clamp at zero).
#' **Warning sign.** A single "inbreeding" column in the cycle report. If you
#' cannot tell which lens it is, it is the one your constraint used, and the other
#' one is unmeasured.
#' **Threshold.** Not the $\Delta F$ target. Both columns here are *stocks*
#' accumulated against the frozen base, and a stock cannot be compared with a rate
#' -- @sec-era-step4 opens on exactly that point. Within one cycle the reference is
#' the resampled null of @tbl-era-signature, i.e. the z-scores of @tbl-era-signature-z, read on **both**
#' lenses separately and never on their average. The comparison with the
#' programme's $\Delta F$ budget requires a trajectory and happens only through the
#' regression of @sec-era-step4.
#' 
#' ### Step 3 -- Report the covariance, not just the two lenses {#sec-era-step3}
#' 
#' `cov_diag` is the gap between the two lenses, and by @eq-era-cov it is not an
#' approximation of the gap -- it *is* the gap, which the `stopifnot()` above
#' enforces on every render. The operational point is that `cov_diag` is the only
#' column that tells you *why* the two lenses disagree, and its sign identifies the
#' mechanism from @tbl-era-matrix-signs: negative means the management pushed
#' frequencies toward 0.5, positive means it pushed them to the extremes.
#' 
#' **Call.** `freq_metrics(idx, ctx)[["cov_diag"]]`, already computed by step 2 at
#' no extra cost; `cor_dp_p0` from the same call is the scale-free version.
#' **Check.** `cov_diag == F_hom - F_drift` to machine precision. If it does not,
#' the base and the frequencies were computed on different marker sets.
#' **Warning sign.** $|$`cov_diag`$|$ of the same order as the stock it is meant to
#' explain. In the panel of @sec-era-step2 the max-diversity plan reports
#' `cov_diag` = `r fmt(panel["max_div", "cov_diag"], 4)` against an
#' $F_{drift}$ of `r fmt(panel["max_div", "F_drift"], 4)`: the discrepancy between
#' the two lenses is `r fmt(abs(panel["max_div", "cov_diag"] / panel["max_div", "F_drift"]), 1)`
#' times the quantity being reported.
#' **Threshold.** No absolute one, and not the $\Delta F$ budget -- `cov_diag` is a
#' stock like the two lenses it separates. Compare it with $F_{drift}$ in the same
#' row, as just done, and with the resampled null: the `null_sd` row of
#' @tbl-era-signature puts the max-diversity plan
#' `r fmt(abs(z["max_div", "cov_diag"]), 1)` s.d. out, which is the statement that
#' the covariance was induced by the management rather than by the sampling.
#' 
#' ### Step 4 -- Regress $\log(1 - F)$ on cycle, and read $R^2$ {#sec-era-step4}
#' 
#' A single cycle's $F$ is a stock and cannot be compared to a rate target. The
#' rate comes from the trajectory. Before trusting the regression on a real
#' programme, calibrate it on a case whose answer is known.
#' 
#' The known case is the drift model of @eq-hp-drift: with $n_{gam}$ allele copies
#' sampled per cycle, $\Delta F = 1/n_{gam}$ and $N_e = n_{gam}/2$, so a
#' **crossing block** of $n$ plants ($n_{gam} = 2n$, $N_e = n$) and a pool
#' **re-derived as $n$ doubled-haploid lines** ($n_{gam} = n$, $N_e = n/2$) differ
#' by a factor of two. The DH regime is literally what `next_pool()` does in
#' @sec-cycles: one Bernoulli draw per locus per new line. What this step adds is
#' the calibration of the $\log(1 - F)$ regression against those two known rates;
#' @tbl-era-traj-block gives the crossing-block trajectory.
#' 
## -----------------------------------------------------------------------------
#| label: era-traj-setup
# One heterotic pool, n_gam allele copies sampled per cycle, n_cyc cycles,
# `reps` independent replicates. `pull` first moves every frequency a fixed
# fraction toward 0.5: a caricature of a heterozygosity-maximising constraint,
# not an optimiser.
pool_traj <- function(n_gam, m, n_cyc, pull = 0, reps = 20, seed = 11) {
  out <- vector("list", reps)
  for (r in seq_len(reps)) {
    set.seed(seed + r)
    p0 <- runif(m, 0.05, 0.95)
    s2 <- p0 * (1 - p0)
    p  <- p0
    rows <- vector("list", n_cyc + 1L)
    for (t in 0:n_cyc) {
      rows[[t + 1L]] <- data.frame(
        rep = r, cycle = t,
        F_hom    = 1 - mean(p * (1 - p) / s2),
        F_drift  = mean((p - p0)^2 / s2),
        cov_diag = 2 * mean((p0 - 0.5) * (p - p0) / s2))
      p <- rbinom(m, n_gam, p + pull * (0.5 - p)) / n_gam
    }
    out[[r]] <- do.call(rbind, rows)
  }
  do.call(rbind, out)
}

per_cycle <- function(tr, n_gam) {
  a <- aggregate(cbind(F_hom, F_drift, cov_diag) ~ cycle, tr, mean)
  a$expected <- 1 - (1 - 1 / n_gam)^a$cycle
  # One s.d. per lens: the two lenses are not equally noisy across replicates,
  # so a deviation has to be compared with the s.d. of the lens it came from.
  a$sd_hom   <- aggregate(F_hom ~ cycle, tr, sd)$F_hom
  a$sd_drift <- aggregate(F_drift ~ cycle, tr, sd)$F_drift
  a
}

# dF from the slope, not from its first-order approximation.
dF_fit <- function(a, col) {
  d <- a[a$cycle > 0, ]                 # cycle 0 is identically zero by construction
  f <- lm(log(1 - d[[col]]) ~ cycle, d)
  b <- coef(f)[["cycle"]]
  c(dF = 1 - exp(b), Ne = 1 / (2 * (1 - exp(b))), R2 = summary(f)$r.squared)
}

n_line <- 50
n_cyc  <- 12
n_rep  <- 20
pull_m <- 0.05                          # the caricature pull of the managed arm
# Table captions of this step, built from the run parameters above.
seeds_traj <- formals(pool_traj)[["seed"]] + c(1, n_rep)
cap_block <- sprintf(paste(
  "Unmanaged crossing block of %d plants (%d allele copies sampled per cycle)",
  "over %d cycles: per-cycle means over %d replicates of %d loci (`pool_traj()`,",
  "seeds %d to %d) of F_hom, F_drift and cov_diag against the base frozen at",
  "cycle 0. expected: the closed form 1 - (1 - 1/n_gam)^t; sd_hom, sd_drift:",
  "between-replicate standard deviations of the two lenses. Dimensionless."),
  n_line, 2 * n_line, n_cyc, n_rep, book_cfg$m, seeds_traj[1], seeds_traj[2])
cap_nfit <- sprintf(paste(
  "Constant-rate fits of log(1 - F) on cycle (cycles 1 to %d) for both lenses",
  "of the two unmanaged arms: the crossing block of @tbl-era-traj-block (block)",
  "and the same %d lines re-derived as doubled haploids (dh). dF = 1 - exp(slope)",
  "per cycle, the implied Ne = 1/(2 dF), and R2."), n_cyc, n_line)
cap_managed <- sprintf(paste(
  "The crossing block of @tbl-era-traj-block with every frequency moved %g%% of",
  "the way toward 0.5 before each drift step: per-cycle means over the same %d",
  "replicates of F_hom, F_drift and cov_diag against the frozen base, and the",
  "between-replicate standard deviation of F_drift (sd_drift). Dimensionless."),
  100 * pull_m, n_rep)
cap_mfit <- sprintf(paste(
  "Constant-rate fits of log(1 - F) on cycle (cycles 1 to %d) for the two lenses",
  "of the managed arm (@tbl-era-traj-managed): dF = 1 - exp(slope) per cycle, the",
  "implied Ne = 1/(2 dF), and R2. Both R2 values are below the 0.995 threshold of",
  "@sec-era-step4, so neither dF is read as a constant rate."), n_cyc)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-traj-block
#| tbl-cap: !expr cap_block
block  <- per_cycle(pool_traj(2 * n_line, book_cfg$m, n_cyc, reps = n_rep), 2 * n_line)
dh     <- per_cycle(pool_traj(n_line, book_cfg$m, n_cyc, reps = n_rep), n_line)
fmt(block, 5)

#' 
#' The `expected` column is the closed form, not a fit. Both lenses agree with it
#' and with each other, in both regimes (@tbl-era-traj-targets,
#' @tbl-era-traj-drift-fit):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-traj-targets
#| tbl-cap: "Calibration of the two unmanaged arms against the closed form. target_dF, target_Ne: the known rate and effective size (crossing block of n plants: 1/(2n) and n; pool of n doubled-haploid lines: 1/n and n/2); max_deviation: largest absolute deviation of either lens's replicate mean from the closed form over all cycles; sd_hom_final, sd_drift_final: between-replicate standard deviations of the two lenses at the last cycle. Dimensionless except target_Ne, in individuals."
dev <- function(a) max(abs(c(a$F_hom, a$F_drift) - rep(a$expected, 2)))
# The deviation of a mean over n_rep replicates is scaled by the standard error
# of that mean, cycle by cycle and lens by lens (cycle 0 is exactly zero).
dev_se <- function(a) {
  d <- a[a$cycle > 0, ]
  max(abs(d$F_hom - d$expected) / (d$sd_hom / sqrt(n_rep)),
      abs(d$F_drift - d$expected) / (d$sd_drift / sqrt(n_rep)))
}
n_cmp  <- 2 * n_cyc                                  # 2 lenses x n_cyc cycles
z_bonf <- stats::qnorm(1 - 0.025 / n_cmp)            # two-sided 5%, Bonferroni
fit_n <- rbind(block_F_hom   = dF_fit(block, "F_hom"),
               block_F_drift = dF_fit(block, "F_drift"),
               dh_F_hom      = dF_fit(dh, "F_hom"),
               dh_F_drift    = dF_fit(dh, "F_drift"))
stopifnot(all(fit_n[, "R2"] >= 0.999), dev_se(block) < z_bonf, dev_se(dh) < z_bonf)
fmt(rbind(crossing_block = c(target_dF = 1 / (2 * n_line), target_Ne = n_line,
                             max_deviation = dev(block),
                             sd_hom_final = block$sd_hom[nrow(block)],
                             sd_drift_final = block$sd_drift[nrow(block)]),
          dh_pool        = c(1 / n_line, n_line / 2, dev(dh),
                             dh$sd_hom[nrow(dh)], dh$sd_drift[nrow(dh)])), 5)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-traj-drift-fit
#| tbl-cap: !expr cap_nfit
fmt(fit_n, 5)

#' 
#' For the crossing block the fitted rates are `r fmt(fit_n["block_F_hom", "dF"], 5)`
#' and `r fmt(fit_n["block_F_drift", "dF"], 5)` against a target of
#' `r fmt(1 / (2 * n_line), 5)`, giving $N_e$ of
#' `r fmt(fit_n["block_F_hom", "Ne"], 1)` and
#' `r fmt(fit_n["block_F_drift", "Ne"], 1)` against the true `r n_line`. For the
#' DH-derived pool of the same `r n_line` lines they are
#' `r fmt(fit_n["dh_F_hom", "dF"], 5)` and `r fmt(fit_n["dh_F_drift", "dF"], 5)`
#' against a target of `r fmt(1 / n_line, 5)`, giving
#' $N_e \approx$ `r fmt(fit_n["dh_F_drift", "Ne"], 0)` against the true
#' `r n_line / 2`. In both regimes the largest deviation of either lens from the
#' closed form (`r fmt(dev(block), 4)` and `r fmt(dev(dh), 4)`) falls on the
#' homozygosity lens; the drift lens deviates by at most
#' `r sprintf("%.4f", max(abs(block$F_drift - block$expected)))` and
#' `r sprintf("%.4f", max(abs(dh$F_drift - dh$expected)))`. The yardstick for a
#' deviation of a mean over `r n_rep` replicates is the standard error of that mean,
#' the between-replicate s.d. divided by $\sqrt{`r n_rep`}$, taken per cycle and per
#' lens: scaled that way the largest deviation over the `r n_cmp` comparisons
#' (`r n_cyc` cycles, two lenses) is `r fmt(dev_se(block), 2)` standard errors for
#' the crossing block and `r fmt(dev_se(dh), 2)` for the DH pool, both below the
#' two-sided 5% Bonferroni bound for `r n_cmp` comparisons,
#' $z =$ `r fmt(z_bonf, 2)`. The bound is conservative here because the comparisons
#' are positively correlated (one trajectory per replicate feeds all cycles). The
#' smallest $R^2$ of the four fits is `r fmt(min(fit_n[, "R2"]), 4)`, and the chunk
#' asserts $R^2 \ge 0.999$ on all four.
#' 
#' Two things to carry out of that. The regression recovers $N_e$ to within the
#' sampling noise of `r n_rep` replicates of `r book_cfg$m` loci, which is what licenses
#' the $R^2$ threshold used below -- *at this scale only*: `r n_rep` replicates,
#' `r book_cfg$m` loci, `r n_cyc` cycles, one pool, one seed family. And a pool maintained
#' as doubled-haploid lines drifts at twice the rate of a crossing block of the same
#' count, so a programme that recycles `r n_line` DH lines per pool per cycle is
#' running at $N_e \approx$ `r n_line / 2`, not `r n_line`. That factor of two is
#' structural, not a simulation artefact: it is the homozygosity of the DH itself.
#' 
#' A third thing, which is what the $F_{drift}$ section above needed and could not
#' compute at that point in the chapter. At cycle `r n_cyc` the unmanaged crossing
#' block stands at $F_{drift} =$ `r fmt(block$F_drift[nrow(block)], 4)` and the DH
#' pool at `r fmt(dh$F_drift[nrow(dh)], 4)`, with **no selection applied in any
#' cycle of either arm**: `pool_traj(pull = 0)` is a binomial resampling of the
#' previous cycle's frequencies and nothing else. A statistic that reaches those
#' values under pure drift is not an accumulated selection intensity, and reading
#' it as one would attribute an intensity to a process that has none.
#' 
#' Now the crossing block again with the caricature constraint switched on (right
#' panel of @fig-era-lens-divergence): every
#' frequency moved `r 100 * pull_m`% of the way toward 0.5 before each drift step, which is what a
#' heterozygosity-maximising objective does to the frequencies without needing an
#' optimiser to do it. @tbl-era-traj-managed gives the trajectory and
#' @tbl-era-traj-managed-fit the two constant-rate fits.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-traj-managed
#| tbl-cap: !expr cap_managed
managed <- per_cycle(pool_traj(2 * n_line, book_cfg$m, n_cyc, pull = pull_m,
                               reps = n_rep), 2 * n_line)
fmt(managed[, c("cycle", "F_hom", "F_drift", "cov_diag", "sd_drift")], 5)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-traj-managed-fit
#| tbl-cap: !expr cap_mfit
stopifnot(isTRUE(all.equal(managed$cov_diag, managed$F_hom - managed$F_drift)))
fit_m <- rbind(F_hom = dF_fit(managed, "F_hom"), F_drift = dF_fit(managed, "F_drift"))
# The calibrated threshold of this step (R^2 < 0.995 = non-constant rate) fires
# on both lenses of the managed arm, so no constant-rate dF or Ne is read off it.
stopifnot(all(fit_m[, "R2"] < 0.995))
inc_m   <- diff(managed$F_drift)                    # per-cycle increments
stock_m <- managed$F_drift[nrow(managed)] / block$F_drift[nrow(block)]
# Caption and alt text of the next figure, built from the run parameters.
cap_div <- sprintf(paste(
  "The two lenses on one heterotic pool over %d cycles, averaged over %d",
  "replicates of %d loci, against a base frozen at cycle 0. Points are replicate",
  "means, filled circles F_drift and triangles F_hom; no dispersion is drawn,",
  "the between-replicate standard deviations are in @tbl-era-traj-block,",
  "@tbl-era-traj-managed and @tbl-era-traj-targets. Left: a crossing",
  "block of %d plants (%d allele copies per cycle). Centre: the same %d lines",
  "re-derived as doubled haploids (%d allele copies per cycle), which drifts at",
  "twice the rate. In both, the closed form 1 - (1 - 1/n_gam)^t is the dashed",
  "line and the two lenses sit on it. Right: the crossing block with every",
  "frequency moved %g%% toward 0.5 before each drift step, where the",
  "homozygosity lens reports a gain of heterozygosity against the frozen base",
  "while the drift lens ends at %.2f times the unmanaged block's value and",
  "rises at a non-constant rate; the dashed line is the same neutral closed",
  "form, here a reference both lenses leave. Nothing is selected in any panel;",
  "the divergence in the right-hand panel is produced by the management rule",
  "alone."),
  n_cyc, n_rep, book_cfg$m, n_line, 2 * n_line, n_line, n_line, 100 * pull_m,
  stock_m)
alt_div <- sprintf(paste(
  "Three panels of F against cycle (0 to %d) for F_drift, F_hom and the",
  "neutral closed form: a %d-plant crossing block, the same lines as doubled",
  "haploids, and the crossing block with a %g%% pull toward 0.5, where F_hom",
  "falls below zero and F_drift rises above the closed form."),
  n_cyc, n_line, 100 * pull_m)
fmt(fit_m, 5)

#' 
## -----------------------------------------------------------------------------
#| label: fig-era-lens-divergence
#| fig-cap: !expr cap_div
#| fig-alt: !expr alt_div
#| fig-width: 6.5
#| fig-height: 3.4
arms <- list(`crossing block` = block, `DH pool` = dh, `pull toward 0.5` = managed)
yl   <- range(unlist(lapply(arms, function(a) c(a$F_hom, a$F_drift, a$expected))))
op <- par(mfrow = c(1, 3), mar = c(4, 4, 2.5, 1))
for (nm in names(arms)) {
  a <- arms[[nm]]
  plot(a$cycle, a$F_drift, type = "o", pch = 19, col = book_pal[["loss"]],
       ylim = yl, xlab = "cycle", ylab = "F against frozen p0",
       main = nm)
  lines(a$cycle, a$F_hom, type = "o", pch = 17, col = book_pal[["ink"]])
  lines(a$cycle, a$expected, lty = 2, col = book_pal[["mid"]])
  abline(h = 0, col = book_pal[["light"]])
  legend("bottomleft", c("F_drift", "F_hom", "closed form"), bty = "n",
         cex = 0.75, pch = c(19, 17, NA), lty = c(1, 1, 2),
         col = book_pal[c("loss", "ink", "mid")])
}
par(op)

#' 
#' @fig-era-lens-divergence puts the three arms side by side. At cycle `r n_cyc` the
#' managed pool reports
#' $F_{hom} =$ `r fmt(managed$F_hom[nrow(managed)], 3)` and
#' $F_{drift} =$ `r fmt(managed$F_drift[nrow(managed)], 3)`, a gap of
#' `r fmt(managed$cov_diag[nrow(managed)], 3)` which is exactly `cov_diag`. The
#' calibrated diagnostic of this step fires on **both** lenses. On
#' $\log(1 - F_{drift})$, $R^2 =$ `r fmt(fit_m["F_drift", "R2"], 4)`, below the
#' 0.995 threshold set below, against `r fmt(fit_n["block_F_drift", "R2"], 5)` in
#' the unmanaged arm; the per-cycle increment of $F_{drift}$ rises from
#' `r fmt(inc_m[1], 4)` in the first cycle to `r fmt(inc_m[length(inc_m)], 4)` in
#' the last, because the deterministic displacement toward 0.5 compounds on the
#' drift. The rate is therefore not constant, and this chapter does not convert
#' the slope (`r fmt(fit_m["F_drift", "dF"], 4)` per cycle, an average over `r n_cyc` cycles and
#' nothing more) into an $N_e$. The comparison that needs no constant rate is the
#' stock: at cycle `r n_cyc` the managed pool's $F_{drift}$ is
#' `r fmt(stock_m, 2)` times the unmanaged crossing block's. The fit on
#' $\log(1 - F_{hom})$ returns a **negative** rate,
#' `r fmt(fit_m["F_hom", "dF"], 4)`, and therefore a negative $N_e$, which is the
#' arithmetic telling you the series it was handed is not an inbreeding trajectory
#' at all; $R^2$ falls to `r fmt(fit_m["F_hom", "R2"], 3)` on that lens against
#' `r fmt(fit_n["block_F_hom", "R2"], 5)` in the unmanaged arm.
#' 
#' The inference, and its limits: a rule that pushes frequencies toward 0.5
#' generates exactly the negative covariance that the `G_0.5` row of
#' @tbl-era-matrix-signs predicts, and it does so with no selection whatsoever.
#' @meuwissen2020 make the corresponding point with random GEBVs: their
#' `G_VR2(~,M)` arm has no directional selection, although it still maximises an
#' index (a random one), and the divergence persists. What this arm does **not**
#' establish is the magnitude -- `pull` = `r pull_m` is a stipulated caricature,
#' not a fitted optimiser, and the stock ratio of `r fmt(stock_m, 2)`
#' would move with `pull`, with $n_{gam}$ and with the ancestral frequency
#' distribution.
#' The direction is algebra; the size is this parameterisation.
#' 
#' **Call.** `lm(log(1 - F) ~ cycle)` on cycles $1..t$, separately for each lens;
#' $\Delta F = 1 - e^{\text{slope}}$, because $1 - F_t = (1 - \Delta F)^t (1 - F_0)$
#' makes the slope $\log(1 - \Delta F)$. The approximation
#' $\Delta F \approx -\text{slope}$ errs by $O(\text{slope}^2)$, a relative error of about $\Delta F / 2$
#' (`r sprintf("%.2f", 100 * (-log(1 - 0.02) / 0.02 - 1))`% at $\Delta F = 0.02$); @sec-cycles fits the same regression to `run_cycles()`
#' output.
#' **Check.** $R^2$ on both fits, and the sign of $\Delta F$.
#' **Warning sign.** A negative fitted $\Delta F$ (the series is not an inbreeding
#' series), or an $R^2$ that is high while the two lenses disagree in sign -- a
#' smooth curve through the wrong quantity.
#' **Threshold.** Calibrated above: a neutral trajectory at this scale gives
#' $R^2 \ge 0.999$, so treat $R^2 < 0.995$ on an averaged series as a non-constant
#' rate. $R^2$ says *that* the rate is not constant, not *why*: a decelerating,
#' saturating series depresses it too, and @sec-cycles shows that case -- there the
#' diagnostic fires on the **unconstrained** run.
#' 
#' ### Step 5 -- Audit on loci that did not enter the management {#sec-era-step5}
#' 
#' The constraint is met on the panel it is computed on. Whether it is met anywhere
#' else is a separate measurement, and it needs loci the optimiser never saw. Split
#' the marker panel in two, manage on one half, and read the report on the other (@tbl-era-audit,
#' @tbl-era-audit-gaps):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-audit
#| tbl-cap: "Split-panel audit. Two 60-hybrid selections made on the odd-numbered markers only (management half): the max-diversity greedy (`w = 0`) and the index-weighted greedy (`w = 1`). Each is scored on the management half (rows ending managed) and on the even-numbered markers it never saw (rows ending audit), against the corresponding slice of the frozen base. Dimensionless."
mgmt  <- seq(1, ctx$m, by = 2)
audit <- seq(2, ctx$m, by = 2)
sub_ctx <- function(k) {
  build_ctx(X = ctx$X[, k], f = molecular_coancestry(ctx$X[, k]), G = NULL,
            traits = ctx$traits, ped = ctx$ped, n_lines = ctx$n_lines,
            pool = ctx$pool, fL = ctx$fL, cfg = NULL)
}
c_mgmt <- sub_ctx(mgmt)
c_audit <- sub_ctx(audit)
# The base of each half is the corresponding slice of the full base, and the
# index is untouched: only the marker set differs.
stopifnot(isTRUE(all.equal(c_mgmt$p0, ctx$p0[mgmt])),
          isTRUE(all.equal(c_mgmt$index, ctx$index)))

i_div <- sel_greedy(c_mgmt, 60, w = 0)     # maximise diversity on the mgmt half
i_bal <- sel_greedy(c_mgmt, 60, w = 1)
cols <- c("He", "F_hom", "F_drift", "cov_diag")
aud <- rbind(max_div_managed = freq_metrics(i_div, c_mgmt)[cols],
             max_div_audit   = freq_metrics(i_div, c_audit)[cols],
             index_managed   = freq_metrics(i_bal, c_mgmt)[cols],
             index_audit     = freq_metrics(i_bal, c_audit)[cols])
fmt(as.data.frame(aud), 4)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-audit-gaps
#| tbl-cap: "Audit-half minus management-half value of F_hom and F_drift for the two selections of @tbl-era-audit."
gaps <- rbind(max_div = aud["max_div_audit", ] - aud["max_div_managed", ],
              index   = aud["index_audit", ]   - aud["index_managed", ])
fmt(as.data.frame(gaps[, c("F_hom", "F_drift")]), 4)

#' 
#' Result. The plan that maximises diversity on the management half reports
#' $F_{hom} =$ `r sprintf("%.4f", aud["max_div_managed", "F_hom"])` there and
#' $F_{hom} =$ `r sprintf("%.4f", aud["max_div_audit", "F_hom"])` on the half it never saw:
#' the sign reverses. Its drift readings are
#' `r fmt(aud["max_div_managed", "F_drift"], 4)` and
#' `r fmt(aud["max_div_audit", "F_drift"], 4)` -- practically the same number on
#' both halves, a gap of `r sprintf("%.4f", gaps["max_div", "F_drift"])` against
#' `r sprintf("%.4f", gaps["max_div", "F_hom"])` on the homozygosity lens. The
#' index-weighted plan, which optimises nothing about heterozygosity, has an
#' $F_{hom}$ gap of only `r sprintf("%.4f", gaps["index", "F_hom"])`.
#' 
#' Interpretation. The homozygosity lens does not generalise off the panel it was
#' maximised on, while the drift lens does; the gap is a property of having
#' maximised, not of the marker set, which is why it nearly vanishes in the
#' index-weighted row. Two limits on that inference. First, in this simulation loci
#' are in linkage equilibrium within pool (assumption A5), so the two halves are as
#' independent as a split panel can be. With real linkage disequilibrium the audit
#' half is correlated with the management half, the measured gap shrinks, and the
#' audit becomes *less* sensitive: the gap measured here is close to an upper bound
#' on what a real split panel would report, not a typical value. Second, this is a
#' one-cycle, single-seed measurement at the teaching scale; the cycle-by-cycle
#' version of the same audit is @sec-cycles.
#' 
#' **Call.** Two contexts over disjoint marker sets, both anchored on slices of the
#' same frozen $p_0$; `freq_metrics()` on each.
#' **Check.** The $F_{hom}$ and $F_{drift}$ gaps between managed and audit halves.
#' **Warning sign.** A sign reversal in $F_{hom}$, as above. Also a *large* gap in
#' $F_{drift}$, which would mean the management is not even controlling drift off
#' its own panel.
#' **Threshold.** The gap should be within the sampling noise of the split. A cheap
#' empirical reference: the `index` row of the same table, which had no
#' heterozygosity objective at all.
#' 
#' ### Step 6 -- Read the two pools separately, and never $F_{ST}$ alone {#sec-era-step6}
#' 
#' Everything so far is a single-population reading. A hybrid programme has two,
#' and they must be constrained in opposite directions: within pool, limit
#' $\Delta F$; between pools, *preserve* divergence, because that is the heterosis
#' engine (@sec-heterosis proves the identity, @sec-stages Trap 3 states the
#' prescription). A single global
#' $\tfrac{1}{2}\mathbf{c}'\mathbf{G}\mathbf{c}$ cannot express that. @tbl-era-pools reads the two pools
#' separately for four selections, and @tbl-era-pools-usage gives the line usage behind them.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-pools
#| tbl-cap: "Pool-level diversity for four 60-hybrid selections: one random draw (seed 31), truncation on the index, the max-diversity greedy (`w = 0`) and the index-weighted greedy with at most 4 hybrids per line (`max_use = 4`). GD: 1 - theta from f; index: mean index of the selected hybrids, in index standard deviations; theta_A, theta_B: within-pool coancestry; GD_T, GD_BS, F_ST: the partition of `gd_partition()`. Dimensionless except index."
pool_row <- function(i) {
  c(GD = gene_diversity(i, ctx), index = mean(ctx$index[i]),
    theta_pools(i, ctx)[c("theta_A", "theta_B")],
    gd_partition(i, ctx)[c("GD_T", "GD_BS", "F_ST")],
    ne_lines_pool(i, ctx), Ne_parents = ne_parents(i, ctx),
    max_line = max_line_use(i, ctx))
}
set.seed(31)
pr <- rbind(random     = pool_row(sample.int(ctx$N, 60)),
            truncation = pool_row(sel_truncation(ctx, 60)),
            max_div    = pool_row(sel_greedy(ctx, 60, w = 0)),
            capped     = pool_row(sel_greedy(ctx, 60, w = 1, max_use = 4)))
stopifnot(isTRUE(all.equal(unname(pr[, "GD"]), unname(pr[, "GD_T"]))))
fmt(as.data.frame(pr[, c("GD", "index", "theta_A", "theta_B", "GD_T", "GD_BS", "F_ST")]), 4)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-pools-usage
#| tbl-cap: "Line usage of the four selections of @tbl-era-pools. Ne_lines_A, Ne_lines_B: effective number of lines used per pool; Ne_parents: effective number of parent lines; max_line: largest number of selected hybrids sharing one line. Ne columns in lines, max_line in hybrids."
fmt(as.data.frame(pr[, c("Ne_lines_A", "Ne_lines_B", "Ne_parents", "max_line")]), 4)

#' 
#' Two gene-diversity columns sit in @tbl-era-pools and they are the **same** quantity
#' reached by two routes, which the `stopifnot()` in the chunk enforces on every
#' render: `GD` is $1 - \theta$ from $\mathbf{f}$ over the selected hybrids
#' (@sec-catalogue), `GD_T` is $1 - \bar f$ from the line-usage weights of the
#' Caballero & Toro partition, and both reduce to
#' $\overline{\bar p_k^2 + (1 - \bar p_k)^2}$ with $\bar p$ the usage-weighted
#' merged frequency, because under A2 a hybrid's marker row is the average of its
#' two parents'. It is the same identity as $He = GD_T$ in @sec-era-fhom, and
#' `GD`, `GD_T` and Nei's $He$ [@nei1973] are one number on this germplasm. The columns that
#' *are* a different quantity are $GD_{BS}$ and $F_{ST}$: both are built from
#' $\tilde f = (\theta_A + \theta_B)/2$, which no hybrid-level average can
#' reproduce, and both are read below.
#' 
#' Result. Truncation on the index costs
#' `r fmt(100 * (1 - pr["truncation", "GD"] / pr["random", "GD"]), 1)`% of gene
#' diversity against the random baseline -- which is the $\alpha$ of
#' @sec-catalogue, computed here on a single random draw rather than on the
#' resampled `gd_ref` -- and `r fmt(100 * (1 - pr["truncation", "GD"] / pr["max_div", "GD"]), 1)`%
#' against the max-diversity ceiling. Meanwhile $\theta_A$ rises to
#' `r fmt(pr["truncation", "theta_A"], 4)` against
#' $\theta_B =$ `r fmt(pr["truncation", "theta_B"], 4)`, and the effective number
#' of lines used falls to `r fmt(pr["truncation", "Ne_lines_A"], 2)` in pool A
#' against `r fmt(pr["truncation", "Ne_lines_B"], 2)` in pool B. One line appears
#' in `r pr["truncation", "max_line"]` of the 60 hybrids.
#' 
#' The dangerous column is $F_{ST}$. It *rises* from
#' `r fmt(pr["max_div", "F_ST"], 4)` to
#' `r fmt(pr["truncation", "F_ST"], 4)` under truncation, and so does $GD_{BS}$.
#' Read as divergence, that looks like a gain in heterosis potential. It is not: by
#' the Caballero & Toro definitions `gd_partition()` implements
#' [@caballero2002], $GD_{BS} = \tilde f - \bar f$ with
#' $\tilde f = (\theta_A + \theta_B)/2$ and
#' $\bar f = (\theta_A + 2\theta_{AB} + \theta_B)/4$, so concentrating usage inside
#' *one* pool raises $\tilde f$ twice as fast as it raises $\bar f$ and therefore
#' raises the between-pool component -- even though the two pools' lines are
#' unchanged and their coancestry matrix $\mathbf{f}^L$ is fixed. All that moved is
#' the weight the selection puts on each line. $F_{ST}$ then divides by a $GD_T$
#' that fell at the same time -- the `GD_T` column of @tbl-era-pools, from
#' `r fmt(pr["max_div", "GD_T"], 4)` to `r fmt(pr["truncation", "GD_T"], 4)` -- which
#' amplifies the artefact: the numerator rises by
#' `r fmt(100 * (pr["truncation", "GD_BS"] / pr["max_div", "GD_BS"] - 1), 0)`% while
#' the denominator falls by
#' `r fmt(100 * (1 - pr["truncation", "GD_T"] / pr["max_div", "GD_T"]), 0)`%. A
#' within-pool collapse and a genuine divergence are indistinguishable in $F_{ST}$,
#' and only the separate $\theta_A$, $\theta_B$ columns tell them apart.
#' 
#' The limitation to state here rather than hide: `freq_metrics()` computes its two
#' lenses on `ctx$X` against `ctx$p0`, and @sec-era-step1 showed that hybrid base to
#' be $(p_A + p_B)/2$. So $F_{hom}$ and $F_{drift}$ as this package computes them
#' are **pooled over the two pools** and cannot, on their own, tell you which pool
#' eroded. The pool-level attribution comes from three other places: $\theta_A$ and
#' $\theta_B$ (`theta_pools()`), the effective number of lines used per pool
#' (`ne_lines_pool()`), and the pool-level panel `s1_monitor()` returns from the
#' line matrix (@tbl-era-s1-monitor):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-s1-monitor
#| tbl-cap: "The pool-level monitoring panel `s1_monitor()` returns for the founding line matrix (cycle 0, both pools): within-pool and total gene diversity, two definitions of F_ST (Wright, Nei's G_ST), status number, per-pool gene diversity and between-pool complementarity of allele frequencies, one row per quantity. Ns_total: status number of the two pools together."
s1 <- s1_monitor(L / 2, pool, cycle = 0)
fmt(data.frame(value = unlist(s1)), 4)  # transposed: one row per quantity

#' 
#' The two panels are the same quantities computed from the two ends of the
#' contract, and on the full factorial -- where line usage is uniform -- they agree
#' exactly (@tbl-era-s1-identity):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-s1-identity
#| tbl-cap: "The two ends of the contract on the full factorial: GD_T and F_ST from `gd_partition()` over all hybrids, against GD_total, Nei's G_ST and Wright's F_ST from `s1_monitor()` over the founding line matrix of @tbl-era-s1-monitor. Dimensionless."
gp_full <- gd_partition(seq_len(ctx$N), ctx)
stopifnot(isTRUE(all.equal(gp_full[["GD_T"]], s1$GD_total)),
          isTRUE(all.equal(gp_full[["F_ST"]], s1$Gst_Nei)))
fmt(data.frame(value = c(
  gd_partition_GD_T = gp_full[["GD_T"]], s1_GD_total = s1$GD_total,
  gd_partition_F_ST = gp_full[["F_ST"]], s1_Gst_Nei = s1$Gst_Nei,
  s1_Fst_Wright = s1$Fst_Wright)), 6)

#' 
#' Note which two agree. `gd_partition()`'s `F_ST` is $GD_{BS}/GD_T$, which is the
#' Nei $G_{ST}$ form, and it equals `s1_monitor()`'s `Gst_Nei` to machine
#' precision; `Fst_Wright` is the other definition and is
#' `r fmt(s1$Fst_Wright / s1$Gst_Nei, 2)` times larger on the same germplasm. That
#' is @sec-stages Trap 2, and it is the reason to name the definition in the report
#' rather than the symbol.
#' 
#' **Call.** `theta_pools()`, `gd_partition()`, `ne_lines_pool()`,
#' `max_line_use()`, `ne_parents()` on the selection; `s1_monitor()` on the line
#' matrix of each cycle.
#' **Check.** $\theta_A$ and $\theta_B$ separately; $GD_{BS}$ held in a band, not
#' maximised; the number of distinct lines used per pool.
#' **Warning sign.** $F_{ST}$ rising while $GD_T$ falls -- almost always a
#' one-pool collapse, not divergence. An `Ne_lines` asymmetry between pools of the
#' size in the `truncation` row above
#' (`r fmt(pr["truncation", "Ne_lines_A"], 1)` against
#' `r fmt(pr["truncation", "Ne_lines_B"], 1)`).
#' **Threshold.** A per-line usage cap is the direct instrument: the `capped` row
#' is `sel_greedy(ctx, 60, w = 1, max_use = 4)`, which holds
#' $|\theta_A - \theta_B|$ at
#' `r fmt(abs(pr["capped", "theta_A"] - pr["capped", "theta_B"]), 4)` and both
#' pools above `r fmt(min(pr["capped", c("Ne_lines_A", "Ne_lines_B")]), 1)`
#' effective lines, against an index of `r fmt(pr["capped", "index"], 2)` where
#' truncation reached `r fmt(pr["truncation", "index"], 2)`. That index difference
#' is the price, and @sec-cycles is where it is paid back or not. `max_use`
#' defaults to `NULL` everywhere in this package, so the cap is opt-in.
#' 
#' ::: {.callout-tip}
#' ## The diagnostic nobody runs
#' 
#' Schemes based on IBD selected many parents in
#' @meuwissen2020; VanRaden-style schemes selected few. If your
#' optimal-contribution run is delivering high gain with a suspiciously small
#' number of parents and $\Delta F$ on target, compute $F_{hom}$ and $F_{drift}$
#' separately on a panel **not used** in the management (@sec-era-step5). The
#' difference between them is your hidden bill. This book's
#' implementation is `ne_parents()`, which @sec-case-study reports alongside the
#' two lenses for every scenario. @tbl-era-pools and @tbl-era-pools-usage are the small
#' version of the same diagnostic: between the `random` and `truncation` rows
#' gene diversity falls by
#' `r sprintf("%.1f", 100 * (1 - pr["truncation", "GD"] / pr["random", "GD"]))`%
#' while the effective number of parents falls from
#' `r sprintf("%.1f", pr["random", "Ne_parents"])` to
#' `r sprintf("%.1f", pr["truncation", "Ne_parents"])`, which is
#' `r sprintf("%.0f", 100 * (1 - pr["truncation", "Ne_parents"] / pr["random", "Ne_parents"]))`%
#' -- the two relative drops differ by a factor of
#' `r sprintf("%.0f", (1 - pr["truncation", "Ne_parents"] / pr["random", "Ne_parents"]) / (1 - pr["truncation", "GD"] / pr["random", "GD"]))`.
#' A budget written on gene diversity alone is therefore a weak constraint on the
#' parent count, and the `capped` row -- the same greedy with `max_use = 4` -- is
#' what holding the parent count directly costs:
#' `r sprintf("%.1f", pr["capped", "Ne_parents"])` effective parents at an index
#' of `r fmt(pr["capped", "index"], 2)` where truncation reached
#' `r fmt(pr["truncation", "index"], 2)`. Measured on one candidate set at the
#' teaching scale, with a single random draw as the `random` row.
#' :::
#' 
#' ### Step 7 -- Check the matrix you are about to invert {#sec-era-step7}
#' 
#' ::: {.callout-note}
#' ## An implementation note that is routinely ignored
#' 
#' `G_VR1`, `G_VR2`, `G_0.5` and `G_i(p)` are all only **semi**-definite positive,
#' so every one of them needs $\alpha$ added to the diagonal ($\alpha = 0.01$ in
#' @meuwissen2020, their Methods) before it can be inverted and before
#' the optimal-contribution algorithm will run. $\mathbf{A}$ and `G_LA` are
#' positive definite by construction.
#' 
#' **The mechanism is not the same for all four, and the difference matters here.**
#' @meuwissen2020 (their Methods) attribute the zero eigenvalue of all four to the
#' centring of the genotypes; for `G_0.5` this chapter departs from that, and
#' @tbl-era-centering-vs-structure shows why. For the centred VanRaden forms [@vanraden2008] it is the
#' centring: $\mathbf{Z}$ is centred on the
#' *population's own* allele frequencies, so its columns sum to zero over
#' individuals, the constant vector lies in the null space and one degree of
#' freedom is gone by construction. For `G_0.5` $= 4\mathbf{f} - 2\mathbf{J}$ --
#' an affine map of the molecular coancestry this book calls $\mathbf{f}$, with
#' $\mathbf{J}$ the $N \times N$ matrix of ones -- it is **not** the centring:
#' $\mathbf{f}$ is not centred on anything and stays in $[0, 1]$ by design
#' (@sec-coancestry), and `G_0.5` inherits non-zero row sums from it. Their
#' deficiency has a different cause, derived below. Both statements are checkable:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-centering-vs-structure
#| tbl-cap: "Centring against structure on the full factorial. f_equals_half_plus_gram: largest absolute difference between f and 0.5 + 2 Z_h Z_h'/m; f_rowsum_min, f_rowsum_max, G05_rowsum_min: extreme row sums of f and of G_0.5; G_sum: sum of all elements of VanRaden's G; G_rowsum_max_abs: largest absolute row sum of G; rank_f, rank_G05, rank_G: numerical ranks (`qr()`); n_lines: parent lines L; N: hybrids. Four significant digits."
Zh  <- ctx$X - 0.5
G05 <- 4 * ctx[["f"]] - 2                       # G_0.5 = 4f - 2J
rkf <- qr(ctx[["f"]])$rank
rkG <- qr(ctx[["G"]])$rank
rk05 <- qr(G05)$rank
# Identities: f is half plus a Gram matrix; VanRaden G sums to zero (centring).
stopifnot(isTRUE(all.equal(ctx[["f"]], 2 * tcrossprod(Zh) / ctx$m + 0.5)),
          isTRUE(all.equal(G05, 8 * tcrossprod(Zh) / ctx$m)),
          abs(sum(ctx[["G"]])) < 1e-8,
          min(rowSums(G05)) > 0)
# Measured on this data set, not theorems: rank(G) = rank(f) - 1 and
# rank(G_0.5) = rank(f) (G_0.5 = 4 f - 2 J is affine in f, not equal to it).
stopifnot(rkG == rkf - 1, rk05 == rkf)
data.frame(value = formatC(c(
  f_equals_half_plus_gram = max(abs(ctx[["f"]] -
                                      (2 * tcrossprod(Zh) / ctx$m + 0.5))),
  f_rowsum_min            = min(rowSums(ctx[["f"]])),
  f_rowsum_max            = max(rowSums(ctx[["f"]])),
  G05_rowsum_min          = min(rowSums(G05)),
  G_sum                   = sum(ctx[["G"]]),
  G_rowsum_max_abs        = max(abs(rowSums(ctx[["G"]]))),
  rank_f = rkf, rank_G05 = rk05, rank_G = rkG, n_lines = ctx$n_lines, N = ctx$N), digits = 4, format = "g"))

#' 
#' $\mathbf{f} = 0.5 + \tfrac{2}{m}\mathbf{Z}_h\mathbf{Z}_h'$ with
#' $\mathbf{Z}_h = \mathbf{X} - \tfrac12\mathbf{J}_{N \times m}$ (the hybrid marker matrix centred at 0.5, with $\mathbf{J}_{N \times m}$ the $N \times m$ matrix of ones), to machine precision -- a Gram matrix plus the
#' positive rank-one term $0.5\,\mathbf{1}\mathbf{1}'$, hence positive
#' semi-definite, and with row sums nowhere near zero (`f_rowsum_min` above), so
#' neither $\mathbf{1}$ nor any other constant vector is in its null space. The
#' same holds for `G_0.5` $= \tfrac{8}{m}\mathbf{Z}_h\mathbf{Z}_h'$ (the
#' $0.5\,\mathbf{J}$ term cancels in $4\mathbf{f} - 2\mathbf{J}$): its row sums
#' are positive (`G05_rowsum_min`), and its rank, `r rk05`, equals that of
#' $\mathbf{f}$ on this data set, so every rank statement below about
#' $\mathbf{f}$ applies to `G_0.5` as measured here.
#' VanRaden's
#' $\mathbf{G}$ on the same hybrids has `sum(G)` and every row sum at numerical
#' zero, which *is* the centring, and its rank comes out exactly one below
#' $\mathrm{rank}(\mathbf{f})$ on this data set: one dimension is what centring
#' costs, and it is the only part of either deficiency that centring explains. The
#' other `r ctx$N - rkf` missing dimensions have a different cause entirely, and the
#' rest of this step is that cause.
#' :::
#' 
#' In a hybrid programme the deficiency is far worse than one zero eigenvalue, and
#' it is structural rather than numerical. A hybrid's marker row is the average of
#' its two parents' rows, so $\mathbf{X} = \tfrac12 \mathbf{B}\mathbf{G}^L$ with
#' $\mathbf{B}$ the $N \times L$ parent-usage incidence matrix (a 1 in the two
#' columns of its parents) and $\mathbf{G}^L$ the $L \times m$ line genotype
#' matrix coded 0/1 of @sec-notation (the `L / 2` object of `simulate_lines()`; the
#' superscript keeps it apart from the $\mathbf{G}_\bullet$ relationship matrices
#' of this chapter). With $\mathbf{J}_{r \times c}$ the $r \times c$ matrix of
#' ones, the hybrid coancestry matrix is a Gram matrix,
#' $\mathbf{f} = [\mathbf{X}, \mathbf{J}_{N \times m} - \mathbf{X}]\,
#' [\mathbf{X}, \mathbf{J}_{N \times m} - \mathbf{X}]'/m$, so its
#' column space is that of $[\mathbf{X}, \mathbf{J}_{N \times m} - \mathbf{X}]$. Every row of $\mathbf{B}$ has exactly two
#' 1s, so $\mathbf{B}\mathbf{1}_L = 2\,\mathbf{1}_N$: the constant vector already
#' lies in the column space of $\mathbf{B}$. Hence
#' $\mathbf{X} = \mathbf{B}\mathbf{G}^L/2$ and
#' $\mathbf{J}_{N \times m} - \mathbf{X} = \mathbf{B}(\mathbf{J}_{L \times m} - \mathbf{G}^L)/2$
#' both have their columns in that space, and so does $\mathbf{f}$. That is a
#' theorem, @eq-era-rank, for any selection and any line genotypes:
#' $$\mathrm{rank}(\mathbf{f}) \le \mathrm{rank}(\mathbf{B})$$ {#eq-era-rank}
#' however many hybrids there are (and also $\le m + 1$, because every column of
#' $\mathbf{J} - \mathbf{X}$ is $\mathbf{1}_N$ minus a column of $\mathbf{X}$; that
#' second bound is not binding at this scale). The same argument covers `G_0.5`
#' $= \tfrac{8}{m}\mathbf{Z}_h\mathbf{Z}_h'$, since
#' $\mathbf{Z}_h = \mathbf{B}(\mathbf{G}^L - 0.5\,\mathbf{J}_{L \times m})/2$.
#' Whether the bound is attained depends on $\mathbf{G}^L$ and is a measurement.
#' Measured in @tbl-era-rank and @tbl-era-rank-check:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-rank
#| tbl-cap: "Rank of the hybrid coancestry matrix f and of the parent-usage incidence matrix B for five selections: the full factorial, one random 60-hybrid draw (seed 31), truncation, the max-diversity greedy (`w = 0`) and one random 20-hybrid draw (seed 32). lines_used: distinct parent lines in the selection; deficiency: n_sel - rank_f."
incidence <- function(idx, ctx) {
  B <- matrix(0, length(idx), ctx$n_lines)
  B[cbind(seq_along(idx), ctx$ped$a[idx])] <- 1
  B[cbind(seq_along(idx), ctx$ped$b[idx])] <- 1
  B
}
# A separate set from the `sels` of @sec-era-fhom: these vary n_sel, which is
# the axis the rank depends on. Named apart so neither chunk shadows the other.
# set.seed(31) reproduces `sels$random`; random_20 gets its own seed.
set.seed(31)
r60 <- sample.int(ctx$N, 60)
set.seed(32)
r20 <- sample.int(ctx$N, 20)
rk_sels <- list(full_factorial = seq_len(ctx$N),
                random_60      = r60,
                truncation_60  = sel_truncation(ctx, 60),
                max_div_60     = sel_greedy(ctx, 60, w = 0),
                random_20      = r20)
rk <- do.call(rbind, lapply(names(rk_sels), function(n) {
  i <- rk_sels[[n]]
  data.frame(selection = n, n_sel = length(i),
             lines_used = length(unique(c(ctx$ped$a[i], ctx$ped$b[i]))),
             rank_f = qr(ctx[["f"]][i, i])$rank,
             rank_incidence = qr(incidence(i, ctx))$rank)
}))
rk$deficiency <- rk$n_sel - rk$rank_f
fmt(rk)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-rank-check
#| tbl-cap: "Rank checks beyond the five selections of @tbl-era-rank. Over independent random 20-hybrid draws (seed 33; their number is given in the text): full_rank_share, share of draws with rank(f) = 20; equality_share, share with rank(f) = rank(B); min_rank_f, smallest rank(f). On the full factorial: rank_full_factorial, rank of f; n_lines, parent lines L; min_eigenvalue_f, smallest eigenvalue of f, a numerical zero. Three significant digits."
# The theorem (B 1 = 2 1, so col(f) lies in col(B)) and, separately, the equality,
# which is measured, not proved.
stopifnot(all(vapply(rk_sels, function(i) all(rowSums(incidence(i, ctx)) == 2), NA)),
          all(rk$rank_f <= rk$rank_incidence))
stopifnot(all(rk$rank_f == rk$rank_incidence))
# Full rank of a 20-hybrid subset is generic, not guaranteed: measured over
# n_draw independent random draws.
n_draw <- 1000
set.seed(33)
rk20 <- t(replicate(n_draw, {
  i <- sample.int(ctx$N, 20)
  c(rank_f = qr(ctx[["f"]][i, i])$rank, rank_B = qr(incidence(i, ctx))$rank)
}))
stopifnot(all(rk20[, "rank_f"] <= rk20[, "rank_B"]))
ev_min <- min(eigen(ctx[["f"]], symmetric = TRUE, only.values = TRUE)$values)
data.frame(value = formatC(c(
  full_rank_share     = mean(rk20[, "rank_f"] == 20),
  equality_share      = mean(rk20[, "rank_f"] == rk20[, "rank_B"]),
  min_rank_f          = min(rk20[, "rank_f"]),
  rank_full_factorial = rk$rank_f[1],
  n_lines             = ctx$n_lines,
  min_eigenvalue_f    = ev_min), digits = 3, format = "g"))

#' 
#' Result. In all five selections the rank of $\mathbf{f}$ equals the rank of the
#' parent-usage incidence matrix exactly. On the full factorial that is
#' `r rk$rank_f[1]` $= L - 1$ for `r ctx$n_lines` lines, against `r ctx$N` hybrids:
#' a deficiency of `r rk$deficiency[1]`, with a smallest eigenvalue at
#' `r signif(ev_min, 2)`. The `random_20` draw, which uses
#' `r rk$lines_used[rk$selection == "random_20"]` lines, is full rank. That is
#' generic, not guaranteed: over `r n_draw` independent random 20-hybrid draws
#' (seed 33) `r fmt(100 * mean(rk20[, "rank_f"] == 20), 1)`% are full rank, the
#' smallest rank is `r min(rk20[, "rank_f"])`, and
#' $\mathrm{rank}(\mathbf{f}) = \mathrm{rank}(\mathbf{B})$ in
#' `r fmt(100 * mean(rk20[, "rank_f"] == rk20[, "rank_B"]), 1)`% of them.
#' 
#' Interpretation. The deficiency is not a rounding artefact and does not shrink
#' with more markers; it is the factorial structure. $N$ hybrids built from $L$
#' lines live in an at most $L$-dimensional space, so any hybrid-level optimiser
#' that needs $\mathbf{f}^{-1}$ must regularise, and the amount of regularisation
#' required is predictable *before* any eigendecomposition: compute
#' $\mathrm{rank}(\mathbf{B})$, which costs one `qr()` on an $N \times L$ 0/1
#' matrix. Two statements are asserted in the chunk and they have different
#' standing. $\mathrm{rank}(\mathbf{f}) \le \mathrm{rank}(\mathbf{B})$ is the
#' theorem of @eq-era-rank, so $\mathrm{rank}(\mathbf{B})$ is a guaranteed upper bound on what
#' the inversion has to work with. The equality `rank_f == rank_incidence` is a
#' measurement -- five selections plus `r n_draw` random draws, at one scale and on
#' one draw of line genotypes -- and a set of lines whose genotypes are linearly
#' dependent would break it without breaking the theorem. The rank deficiency is also the
#' reason this book's selection machinery never inverts $\mathbf{f}$:
#' `metrics_cheap()` and the differential-evolution (DE) fitness only ever evaluate the quadratic form
#' $\mathbf{c}'\mathbf{f}\mathbf{c}$, which needs no inverse. The
#' quadratic-programming routes do need a definite matrix, and both
#' `optimal_contributions()` and `ocs_quadprog()` add `diag(1e-8, n)` for exactly
#' this reason -- `r fmt(log10(1e-8 / abs(ev_min)), 1)` orders of magnitude above the
#' numerical zero reported above,
#' and small enough not to move the optimum. See @sec-ocs and @sec-g-singular.
#' 
#' **Call.** `qr()` on the usage incidence matrix, or on $\mathbf{f}$ restricted to
#' the candidate set; `eigen(..., only.values = TRUE)` for the spectrum if you want
#' the size of the numerical zero.
#' **Check.** `rank(f) < n_sel`, and how far below.
#' **Warning sign.** A quadratic-programming solver that returns without error but
#' with contributions concentrated on a handful of hybrids: a singular matrix makes
#' the objective flat along $N - \mathrm{rank}$ directions, and the solver will pick
#' a vertex.
#' **Threshold.** The added diagonal $\alpha$ must exceed the largest magnitude of
#' the numerically-zero eigenvalues, here about `r signif(abs(ev_min), 1)`, by
#' several orders of magnitude; $\alpha = 0.01$ on a matrix whose diagonal averages
#' `r fmt(mean(diag(ctx[["f"]])), 2)` is a perturbation of about
#' `r fmt(100 * 0.01 / mean(diag(ctx[["f"]])), 1)`% and must be documented as such,
#' because it changes the optimum.
#' 
#' ## What not to do
#' 
#' Four recommendations that do not need their own step. Each one is labelled with
#' what backs it, because they are not backed equally: one is measured in this
#' chapter, three are positions taken by @meuwissen2020 and carried forward here as
#' *their* argument, and none of the three has been tested on plant germplasm
#' anywhere in this book.
#' 
#' **Do not maximise marker heterozygosity as an objective.** *Measured here:*
#' raising heterozygosity on the monitored panel does not raise it at unmonitored
#' loci -- @sec-era-step5 measures the sign reversal, under linkage equilibrium,
#' which makes it a best case. *Their argument, not measured here:* doing so also
#' raises IBD-based inbreeding, because "changes in allele frequency result from
#' multiple copies of a subset of base generation alleles, so increasing frequency
#' is promoting IBD based inbreeding" [@meuwissen2020, Discussion, Management of
#' Diversity]. This book has no IBD route at all -- every matrix in it is
#' identity-by-state -- so that half is a reason to distrust the objective, not a
#' result reproduced here.
#' 
#' **Region-specific diversity targets rarely earn their complexity.** *Their
#' argument.* @meuwissen2020 give two grounds in the same paragraph: that causative
#' alleles of quantitative traits are quite evenly distributed across the genome
#' (their Discussion, citing @wood2014 on human stature -- an observation
#' about one species and one trait, not about maize), and that "what happens in a
#' sample of loci does not necessarily predict what happens at loci outside that
#' subset", which is the claim @sec-era-step5 does test, at the marker level. They
#' name the major histocompatibility complex as the case that *does* earn a
#' constraint of its own; the plant analogue offered here is R-gene-type resistance
#' loci, where allelic diversity has direct and known value. That analogy is
#' offered as such, and nothing in this book measures it.
#' 
#' **Deleterious recessives are a load problem, not a diversity problem.** *Their
#' judgement:* for regions carrying known recessive defects, "direct inclusion of
#' the known defects in the breeding goal seems more effective in controlling their
#' frequencies" than prioritising the region for diversity management
#' [@meuwissen2020, Discussion]. Neither they nor this book compare the two
#' routes quantitatively, so read it as the expectation of the authors of the
#' scheme, not as a measured efficiency. In a hybrid programme there is a second
#' and independent reason, which follows from A1 and A2 rather than from anyone's
#' judgement: a recessive carried at low frequency in pool A is masked in every
#' $A \times B$ hybrid unless pool B carries it too, so the load is expressed in
#' the crossing block and in the DH induction, not in the product.
#' 
#' **In a pure conservation scheme the problem is expected to be *worse*, not
#' better.** *Their expectation, stated as one:* "the potential covariance between
#' the change in allele frequency and the initial frequency is expected to
#' increase, since the inbreeding management term is more important in pure
#' conservation schemes" [@meuwissen2020, Discussion], which is why they argue the
#' IBD recommendation is stronger there. Their only arm without directional
#' selection, `G_VR2(~,M)` with random GEBVs, still maximises an index, so no pure
#' conservation scheme was run to test it; the sign of the mechanism is
#' nevertheless the same algebra as everything above -- a constraint that is the
#' only thing moving frequencies is a constraint that generates the whole
#' covariance.
#' 
#' ## Limits of the animal-to-plant transposition {#sec-era-transposition}
#' 
#' @tbl-era-transposition sets each assumption of the simulation of @meuwissen2020
#' against the situation in a hybrid crop programme.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-era-transposition
#| tbl-cap: "Assumptions of the simulation of @meuwissen2020 (left) and the corresponding situation in a two-pool hybrid crop programme (right). The Ne_parents values in the fourth row are computed in @sec-era-step6 (@tbl-era-pools-usage) at the book's teaching scale."
#| echo: false
knitr::kable(data.frame(
  `Assumption in the paper` = c(
    "discrete generations, two sexes, one contribution per individual",
    "reliable, deep pedigree",
    "base = simulated founder population at mutation-drift equilibrium",
    "target Ne = 100 over 20 generations",
    "one population, one target",
    "heterozygosity is always desirable"),
  `Situation in a hybrid crop programme` = c(
    "same line reused for years, cloning of parents through DH maintenance, overlapping cycles, one line used in dozens of crosses",
    "recycling pedigree usually complete inside the programme, absent for introduced germplasm and genebank accessions",
    "base is an administrative choice (cycle 0) with pre-existing heterotic structure already in it",
    sprintf("shorter cycles with genomic selection; this book measures no commercial elite Ne, but @sec-era-step6's own teaching-scale example shows Ne_parents falling well below the pool size under plain truncation (%.1f to %.1f)", pr["random", "Ne_parents"], pr["truncation", "Ne_parents"]),
    "two heterotic pools with opposite-signed constraints, several target environments",
    "desirable in the product, undesirable in the parents, irrelevant at the individual level once lines are fixed -- and in none of the three cases is it what F_hom measures, which is merged-pool gene diversity (@sec-era-fhom)"),
  check.names = FALSE))

#' 
#' None of this invalidates the central conclusion. It is an **algebraic** property
#' of the optimiser, not a biological property of the species. What it changes is
#' *which matrix is practicable*, and -- for a two-pool programme -- that one global
#' constraint is never enough.
#' 
#' ## Operational checklist
#' 
#' The protocol above, in one column, with the step that implements each item.
#' 
#' | Check | Step |
#' |---|---|
#' | Is the base $p_0$ frozen at the founding cycle, and documented? | @sec-era-step1 |
#' | Is the hybrid-level base the balanced average of the two pool bases? | @sec-era-step1 |
#' | Are `F_hom` and `F_drift` computed **separately** and reported together? | @sec-era-step2 |
#' | Is it recorded that `F_hom` is merged-pool gene diversity and **not** F1 heterozygosity, with $GD_{BS}$ reported next to it? | @sec-era-fhom |
#' | Is every single-cycle value compared with a **resampled** null rather than with one random draw? | @sec-era-step2 |
#' | Is the sign of `F_hom` preserved rather than clamped? | @sec-era-step2 |
#' | Is `cov_diag` reported as a diagnostic, with its sign? | @sec-era-step3 |
#' | Is $\log(1 - F)$ regressed on cycle, with $R^2$ shown, for both lenses? | @sec-era-step4 |
#' | Is $\Delta F$ read as $1 - e^{\text{slope}}$ rather than $-\text{slope}$? | @sec-era-step4 |
#' | Is there a panel of loci **not used in management**, for audit? | @sec-era-step5 |
#' | Are $\theta_A$ and $\theta_B$ reported separately, never only $F_{ST}$? | @sec-era-step6 |
#' | Is the number of parent lines used per pool biologically plausible? | @sec-era-step6 |
#' | Is $GD_{BS}$ held in a band rather than maximised? | @sec-era-step6 |
#' | Is the matrix's rank checked before any inversion, and the added $\alpha$ documented? | @sec-era-step7 |
#' | Is true genetic variance (or the best estimate of it) being tracked? | @sec-response |
#' | Where possible, is an IBD alternative compared in parallel? | @sec-era-transposition |
