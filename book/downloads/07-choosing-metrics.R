#' # Choosing metrics: collapse, cost, redundancy {#sec-choosing}
#' 
# 07-choosing-metrics -- standalone script of the chapter 07-choosing-metrics.qmd
# Book: https://ederdbs.github.io/QG/07-choosing-metrics.html
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
cp <- read.csv(book_data("cost_per_eval.csv"))
ic <- read.csv(book_data("theta_identity_check.csv"))
de <- read.csv(book_data("de_constraints.csv"))
red <- read.csv(book_data("metric_redundancy.csv"))
bench <- read.csv(book_data("search_benchmark.csv"))
# Cost at the benchmark scale (L = 300, N = 22,500, m = 10,000, n = 1,000)
cb  <- cp[cp$n_sel == 1000 & cp$L == 300, ]
cus <- setNames(cb$us, cb$metric)            # microseconds per evaluation
# search_benchmark.csv: mean and sd over its 3 seeds per method and scale
bm <- function(sc, m) { x <- bench$index[bench$scale == sc & bench$method == m]
  c(m = mean(x), s = sd(x), n = length(x)) }
# difference of two methods' means and its standard error (independent arms)
bd_diff <- function(sc, m1, m2) { a <- bm(sc, m1); b <- bm(sc, m2)
  c(d = a[["m"]] - b[["m"]], se = sqrt(a[["s"]]^2 / a[["n"]] + b[["s"]]^2 / b[["n"]])) }
max_cap_sd <- max(unlist(lapply(c("book", "production"), function(sc)
  lapply(c("de_hybrid_cap", "de_lines_cap"), function(m) bm(sc, m)[["s"]]))))

#' 
#' @sec-catalogue built a catalogue. This chapter asks which of it to keep, and
#' answers with two questions the catalogue could not: **what does each metric cost
#' per evaluation**, and **how much of what it reports is already in $\theta$**.
#' 
#' The recommendation (@tbl-choosing-recommendation) is **two** metrics inside the
#' optimiser (differential evolution, DE)
#' and **three** at validation, plus one monitoring item that lies outside the
#' analysis behind the other five (the table's last row and Finding 3).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-choosing-recommendation
#| echo: false
#| tbl-cap: "The recommendation, inside the homozygosity lens. Cost per evaluation at L = 300 lines, N = 22,500 hybrids, m = 10,000 markers, n = 1,000 selected (cached; provenance in the paragraph headed 'Provenance of what is cached'). Metrics not listed are redundant with theta in the cached analysis of Finding 3, too expensive for an inner loop, or both; E-NE and A-NE (the nearest-entry distances of @eq-catalogue-ene-ane) are not redundant and are discussed under 'Not recommended'. F_drift and F_hom are not part of that analysis."
knitr::kable(data.frame(
  Role = c("**Constraint**", "**Second constraint**", "Validation", "Validation", "Validation",
           "Monitoring"),
  Metric = c("Group coancestry theta of the selected set, as proportional loss of gene diversity against a same-size resampling baseline",
             "Effective number of parent lines",
             "Marker alleles retained (allelic richness)",
             "Within/between heterotic-pool decomposition of theta",
             "Status number Ns = 1/(2 theta), a rescaling of theta",
             "F_drift and F_hom against the random-subset null (item 6 of @sec-choosing-recommendation)"),
  `Where it runs` = c("inside DE, every evaluation", "inside DE, every evaluation",
                      "on the returned plan only", "on the returned plan only", "free, algebraic",
                      "on the returned plan only"),
  `Cost per evaluation` = c(
    sprintf("**%.0f us** (incremental swap) / %.0f us (full line route)",
            cus[["theta: incremental swap"]], cus[["theta: LINE route"]]),
    sprintf("**%.0f us**, not ordered against the swap (@sec-choosing-cost); computed from the same count vector inside `make_fitness_fast()`",
            cus[["Ne_parents"]]),
    sprintf("%.1f ms (bitset)", cus[["allelic richness: bitset"]] / 1000),
    sprintf("%.0f us", cus[["pool decomposition"]]),
    "0",
    "not timed here (post hoc, O(nm))"),
  check.names = FALSE))

#' 
#' Five findings drive this. Finding 1 is an algebraic identity, derived in @sec-collapse and
#' checked numerically live. Findings 2, 3 and 4 rest on **cached external
#' results** (declared in the paragraph headed 'Provenance of what is cached' of @sec-choosing), which this repository does not
#' regenerate. Finding 5 is a live simulation.
#' 
#' **Provenance of what is cached.** `cost_per_eval.csv` and `cost_scaling.png`,
#' `theta_identity_check.csv`, `metric_redundancy.csv` and `metric_redundancy.png`,
#' `de_constraints.csv` and `de_convergence.png` come from runs whose code is not in
#' this repository (the provenance list of the book's front page says so). No script here
#' regenerates them; the scripts that write other cost and identity tables write to
#' `report/` and different schemas. What this chapter does with them is arithmetic on
#' the stored values; the numbers are not reproducible from this repository. The
#' hardware, R version and timer of the cost benchmark are not recorded. What the
#' files themselves record: the cost table, $L$, $N$, $m$ and $n$ in its columns; the
#' identity table, $L$, $N$, $m$, $F_{BN}$, seed and $n$; the redundancy table, 621
#' rows and no setting at all (not $N$, $L$, $m$, $n$ or $F_{BN}$, the Balding-Nichols divergence of @sec-notation); the DE table,
#' `dim`, `seed` and the outcomes, not $n$, `NP` or the iteration count.
#' 
#' ## Finding 1: the hybrid coancestry matrix is never needed {#sec-collapse}
#' 
#' ### Derivation
#' 
#' **Assumptions.** (i) Every parent is a homozygous (inbred or doubled-haploid)
#' line, as in A2 of @sec-era-programme, so a hybrid carries exactly one genome from
#' each of its two parents. (ii) Each hybrid is one cross $A_a \times B_b$ between a
#' pool-A and a pool-B line, and the $n$ selected hybrids are distinct crosses.
#' (iii) $\mathbf{f}^L$ is the $L \times L$ molecular coancestry matrix of the lines
#' (@eq-f-molecular): entry $f^L_{ac} \in [0, 1]$ is the probability that an allele
#' drawn at random from line $a$ and one from line $c$ are identical in state, with
#' no base population. (iv) Group coancestry $\theta_S$ is the mean of $f$ over all
#' $n^2$ ordered pairs of the selection, diagonal included (@eq-catalogue-theta;
#' @caballero2002). (v) $\mathbf{G}^L$ is the $L \times m$ line genotype matrix coded
#' 0/1 (@sec-notation); hybrid markers are coded 0/0.5/1.
#' 
#' Drawing an allele at random from hybrid $(ab)$ draws it from parent $a$ or $b$
#' with probability $\tfrac12$ each, and likewise for $(cd)$, so
#' 
#' $$f_{(ab),(cd)} \;=\; \tfrac14\left(f^L_{ac} + f^L_{ad} + f^L_{bc} + f^L_{bd}\right).$$ {#eq-collapse-f}
#' 
#' Let the selection use line $a$ exactly $k_a$ times across its parental slots.
#' Then $\sum_a k_a = 2n$, and because each hybrid has one parent in each pool
#' $\sum_{a \in A} k_a = \sum_{b \in B} k_b = n$. Put $w_a = k_a/(2n)$, so that
#' $\sum_a w_a = 1$ and each pool's weights sum to $\tfrac12$. Averaging
#' @eq-collapse-f over the $n^2$ ordered pairs, each term $f^L_{ac}$ appears as many
#' times as $k_a k_c$ counts the pairs of slots $(a, c)$, so
#' 
#' $$\theta_S \;=\; \frac{1}{4n^2}\sum_{a,c} k_a k_c f^L_{ac}
#'   \;=\; \mathbf{w}^{\top}\, \mathbf{f}^L \,\mathbf{w},$$ {#eq-collapse-theta}
#' 
#' and the selection allele frequencies collapse the same way,
#' $\bar{\mathbf{p}} = \mathbf{w}^{\top}\mathbf{G}^L$ (a hybrid's marker row is the mean of its two parents' rows,
#' $\mathbf{X} = \tfrac12\mathbf{B}\mathbf{G}^L$ in the notation of
#' @sec-notation, and averaging over the $n$ hybrids gives $\mathbf{w}^\top\mathbf{G}^L$). The two
#' displayed equations are the chapter's own derivation under (i)-(iv); the
#' quadratic form in line usage is the identity @sec-hybrid-programme asserts
#' numerically.
#' 
#' ### Consequences, and where they stop
#' 
#' **The $N \times N$ hybrid matrix is not needed for the quantities that are
#' functions of $\mathbf{w}$ alone (those listed under '$\mathbf{w}$ is a sufficient statistic' in @sec-collapse).** Memory drops from $O(N^2)$ to $O(L^2)$. At $L = 300$ lines and
#' $N = 22{,}500$ hybrids that matrix would occupy
#' `r sprintf("%.2f", max(cp$f_matrix_GB))` GiB ($22{,}500^2 \times 8$ bytes
#' $/\,2^{30}$); in the benchmark below it was deliberately never formed, and every
#' metric that needs it simply has no timing entry at that scale.
#' 
#' **$\mathbf{w}$ is a sufficient statistic for the diversity quantities, and only
#' for them.** Group coancestry, gene diversity ($GD = 1 - \theta_S$), status number,
#' effective number of parents, selection allele frequencies and the heterotic-pool
#' decomposition by usage weights (@eq-catalogue-theta-pools) are functions of
#' $\mathbf{w}$ alone. One $O(L)$ tabulation per evaluation serves all of them.
#' Quantities that depend on *which* $A$ line is paired with *which* $B$ line are not
#' functions of $\mathbf{w}$: the hybrid-level $GD_{WI\text{-}hyb}$ and the realised
#' F1 heterozygosity of @sec-catalogue. Nor is the mean index, unless it is additive
#' in the parents ($u_i = u^L_a + u^L_b$, the index of @sec-simulating-crosses); under
#' dominance (@sec-heterosis) it is not.
#' 
#' **Swapping one hybrid changes at most four entries of $\mathbf{w}$.** Exchanging
#' hybrid $h$ for $h'$ removes two parental slots and adds two, and each changed
#' entry is a rank-1 update of $\mathbf{f}^L\mathbf{k}$ (`theta_swap()` performs
#' four rank-1 column updates), so $\theta$ updates in $O(L)$ rather than
#' $O(L^2)$.
#' 
#' **The diversity side of the discrete hybrid problem is optimal-contribution
#' selection on lines under three further restrictions.** The weights are integers
#' $k_a/(2n)$ (a lattice), each pool's weights sum to $\tfrac12$ (the margins), and
#' $\mathbf{k}$ must be realisable as the line degrees of $n$ distinct $A \times B$
#' pairs. This connects the problem to the literature on optimal-contribution selection (OCS, @sec-ocs), but only as
#' far as those three restrictions allow: continuous OCS drops all three, and the
#' lattice makes the discrete problem combinatorial rather than the quadratic
#' programme OCS usually solves. The equivalence is for the diversity objective and
#' for an index additive in the parents; it is not stated beyond them.
#' 
#' ### Verification
#' 
#' A **cached** sweep (`theta_identity_check.csv`, no producer in this repository)
#' compares each fast route with a slower route of the package. It has
#' `r nrow(ic)` rows (@tbl-choosing-identity): $F_{BN} \in \{`r paste(unique(ic$fst), collapse = ", ")`\}$,
#' seeds `r paste(unique(ic$seed), collapse = ", ")`,
#' $n \in \{`r paste(unique(ic$n_sel), collapse = ", ")`\}$, at
#' $L = `r unique(ic$L)`$, $N = `r unique(ic$N)`$ and $m = `r unique(ic$m)`$. Each entry is a maximum
#' absolute deviation over replicate selections (thirty per row, as the sweep was
#' described; the file does not record the count). The comparison targets are the
#' package's own slower routes (`theta_group()`, `theta_from_freq()`, `he_nei()`,
#' `ne_parents()`); only the pool decomposition and the bitset richness are checked
#' against the literal `ref_*` oracles. Two of the ten columns
#' (`max_pairwise_f`, `max_alleles_lost`) have no producer anywhere in the
#' repository; the `identity` target of `regenerate.R` writes the other eight, to
#' `report/`.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-choosing-identity
#| echo: false
#| tbl-cap: "Worst absolute deviation of each fast route from its comparison route, cached external data. All below the asserted tolerance of 1e-12; the largest is the effective number of parents, a sum of about 50 count ratios."
cols <- c(max_pairwise_f = "pairwise f: hybrid vs line formula",
          max_theta_sub_vs_line = "theta: line route vs f submatrix",
          max_theta_sub_vs_freq = "theta: line route vs allele-frequency route",
          max_pbar = "selection allele frequencies",
          max_He = "Nei He",
          max_Neparents = "effective number of parents",
          max_alleles_lost = "allele loss at a minor allele frequency (MAF) threshold",
          max_theta_pools = "pool decomposition",
          max_swap_update = "incremental swap vs full recompute",
          bitset_vs_literal = "bitset allelic richness vs literal count")
worst <- vapply(names(cols), function(k) max(abs(ic[[k]])), numeric(1))
tol <- 1e-12   # several orders above double-precision rounding (2.2e-16), far below any rank change
stopifnot(all(worst < tol))
knitr::kable(data.frame(
  Identity = unname(cols),
  `Worst deviation` = ifelse(worst == 0, "0 (exact)", sprintf("%.1e", worst)),
  check.names = FALSE))

#' 
#' The same identity, live, on the book's own data (@tbl-choosing-live-identity):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-choosing-live-identity
#| tbl-cap: "Group coancestry theta of one random selection of n = 60 of the N = 625 hybrids of the teaching scale (seed 51), by the hybrid-matrix route (theta_group()) and by the line route (fast_theta()); the identity is asserted to 1e-12 in the chunk. Dimensionless, a mean of coancestries in [0, 1]; the difference is in scientific notation."
ctx  <- fast_ctx(simulate_data(book_cfg))
set.seed(51)
idx  <- sample.int(ctx$N, 60)
via_matrix <- theta_group(idx, ctx)
via_line   <- fast_theta(idx, ctx)
stopifnot(abs(via_matrix - via_line) < 1e-12)
data.frame(Route = c("hybrid matrix", "line route", "difference"),
           theta = c(sprintf("%.6f", via_matrix), sprintf("%.6f", via_line),
                     sprintf("%.1e", via_matrix - via_line)))

#' 
#' And the incremental swap, which is what makes a local search affordable (@tbl-choosing-live-swap):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-choosing-live-swap
#| tbl-cap: "Group coancestry theta after exchanging the first selected hybrid of the selection of @tbl-choosing-live-identity for the first unselected one, by the incremental update (theta_swap()) and by recomputation (theta_group()); asserted equal to 1e-12 in the chunk. Dimensionless; the difference is in scientific notation."
st  <- theta_state(idx, ctx)
out <- idx[1]; inn <- setdiff(seq_len(ctx$N), idx)[1]
st2 <- theta_swap(st, out, inn, ctx)
recomputed <- theta_group(c(idx[-1], inn), ctx)
stopifnot(abs(st2$theta - recomputed) < 1e-12)
data.frame(Route = c("incremental swap", "full recomputation", "difference"),
           theta = c(sprintf("%.6f", st2$theta), sprintf("%.6f", recomputed),
                     sprintf("%.1e", st2$theta - recomputed)))

#' 
#' ::: {.callout-warning}
#' ## Two implementation traps found while building this
#' 
#' R's `$` performs **partial matching** on lists, so `ctx$f` silently returns
#' `ctx$fL` when the hybrid matrix is absent -- a wrong answer with no error. Every
#' accessor in the package uses `ctx[["f"]]`. Any pipeline carrying both matrices
#' in one list is exposed to this.
#' 
#' R integers are signed 32-bit, so `bitwShiftL(1L, 31L)` is `NA` and the usual
#' multiply-based popcount overflows. The bitset in `pack_lines()` packs 31 bits
#' per word, and `popcount32()` counts them with a branch-free SWAR (SIMD within a register) routine.
#' :::
#' 
#' ## Finding 2: what each metric costs {#sec-choosing-cost}
#' 
#' @fig-choosing-cost-scaling shows how the cost of each route scales and
#' @tbl-choosing-cost gives its values at the benchmark scale.
#' 
## -----------------------------------------------------------------------------
#| label: fig-choosing-cost-scaling
#| echo: false
#| fig-cap: "Cost per fitness evaluation, cached external figure (no producer in this repository). Panel A: scaling in the number of candidate hybrids. Panel B: hours to complete one million evaluations at the benchmark scale (L = 300, N = 22,500, m = 10,000, n = 1,000), which the cached figure's own titles call 'production scale'."
#| fig-alt: "Two panels. A: microseconds per evaluation on a log scale against the number of candidate hybrids, for n = 200 and n = 1000 selected, one line per route; the genotype-scan routes and the hybrid-matrix distances sit highest, the line-usage routes lowest. B: hours for one million evaluations at the benchmark scale, from 14.2 hours for the genotype-scan theta down to 0.001 hours for the incremental swap."
knitr::include_graphics(book_fig("cost_scaling.png"))

#' 
#' Throughout this chapter the **benchmark scale** is $L = 300$ lines,
#' $N = 22{,}500$ hybrids, $m = 10{,}000$ markers and $n = 1{,}000$ selected. It is
#' not the 71 + 71 lines and 25,000 markers of the programme of
#' @sec-era-programme, nor the **teaching scale** (25 + 25 lines, 2,000 markers)
#' that the live chunks run. Timings are one machine's, undeclared.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-choosing-cost
#| echo: false
#| tbl-cap: "Median cost per evaluation at the benchmark scale, cached external data. E-NE, A-NE and effective dimensionality are absent because they require the hybrid matrix, which was never formed. The cached timer resolves about 1 us, so differences of one or two microseconds between the cheapest routes are not an ordering."
b <- cp[cp$n_sel == 1000 & cp$L == 300, c("metric", "us")]
b$`hours per 1e6 evals` <- fmt(b$us * 1e6 / 3.6e9, 4)
b$us <- fmt(b$us, 1)
names(b)[2] <- "us per evaluation"
knitr::kable(b[order(b$`hours per 1e6 evals`), ], row.names = FALSE)

#' 
#' Four readings of that table, each from the cached values:
#' 
#' - **The genotype-scan route is disqualified.** Computing $\theta$ from selection
#'   allele frequencies costs
#'   `r sprintf("%.1f", cus[["theta: allele-freq route"]] * 1e6 / 3.6e9)` hours per
#'   million evaluations. The line route costs
#'   `r sprintf("%.0f", cus[["theta: LINE route"]])` us -- a
#'   **`r sprintf("%.0f", cus[["theta: allele-freq route"]] / cus[["theta: LINE route"]])`x
#'   reduction** for an algebraically identical number.
#' - **The incremental swap is effectively free** at
#'   `r sprintf("%.0f", cus[["theta: incremental swap"]])` us, which is
#'   about `r sprintf("%.0f", cus[["theta: incremental swap"]])` seconds per million
#'   evaluations (the cached timings are multiples of about 1 us, so one significant
#'   figure is all they carry). $N_{e,\text{par}}$ at
#'   `r sprintf("%.0f", cus[["Ne_parents"]])` us is of the same order. At $n = 200$ the
#'   same file gives `r sprintf("%.0f", cp$us[cp$L == 300 & cp$n_sel == 200 & cp$metric == "theta: incremental swap"])` us for the swap and
#'   `r sprintf("%.0f", cp$us[cp$L == 300 & cp$n_sel == 200 & cp$metric == "Ne_parents"])` us for
#'   $N_{e,\text{par}}$, so the two are not ordered. Inside `make_fitness_fast()` the
#'   count vector is tabulated once and serves both; `fast_ne_parents()` called alone
#'   tabulates it again.
#' - **Allelic richness cannot go inside the loop, and need not.** The bitset
#'   implementation is
#'   `r sprintf("%.1f", cus[["allelic richness: float"]] / cus[["allelic richness: bitset"]])`x
#'   faster than the floating-point version
#'   (`r sprintf("%.1f", cus[["allelic richness: float"]] / 1000)` ms), at
#'   `r sprintf("%.0f", cus[["allelic richness: bitset"]])` us. That is
#'   `r sprintf("%.1f", cus[["allelic richness: bitset"]] / cus[["theta: LINE route"]])`x
#'   the cost of the line-route $\theta$ and
#'   `r sprintf("%.0f", cus[["allelic richness: bitset"]] / cus[["theta: incremental swap"]])`x
#'   that of the incremental swap, the evaluation a local search actually pays. It
#'   belongs at validation because adding it would make every evaluation several
#'   times dearer than the line route alone, not because it is infeasible.
#' - **The line route is cheaper than the matrix route only when $n$ is large.**
#'   @sec-catalogue priced the matrix route and this chapter's collapse was
#'   expected to make it cheaper still. The cached values say so for large $n$ and
#'   not for small: at $N = 2{,}500$, $n = 50$ the matrix route takes
#'   `r sprintf("%.1f", cp$us[cp$N == 2500 & cp$n_sel == 50 & cp$m == 5000 & cp$metric == "theta: f submatrix (NxN)"])` us
#'   and the line route
#'   `r sprintf("%.1f", cp$us[cp$N == 2500 & cp$n_sel == 50 & cp$m == 5000 & cp$metric == "theta: LINE route"])` us
#'   (the line route is slower); at $N = 10{,}000$, $n = 1{,}000$ they take
#'   `r sprintf("%.0f", cp$us[cp$N == 10000 & cp$n_sel == 1000 & cp$metric == "theta: f submatrix (NxN)"])` us and
#'   `r sprintf("%.0f", cp$us[cp$N == 10000 & cp$n_sel == 1000 & cp$metric == "theta: LINE route"])` us. At $N = 22{,}500$
#'   only the line route exists.
#' 
#' At the teaching scale every route is affordable, so the comparison there is about
#' ratios, not feasibility. The live table below (@tbl-choosing-live-cost) times the package's own functions
#' with `cost_per_eval()`: a seeded selection, and repetitions multiplied by 4 until
#' the timed block lasts 0.2 s, so a few-microsecond call is not quantised by the
#' clock. It has no line-route, swap or bitset row (those functions are not in
#' `cost_per_eval()`), and its values are wall-clock times of this machine at this
#' render, not the cached production values. It shows that every listed route is
#' cheap at this scale.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-choosing-live-cost
#| tbl-cap: "Wall-clock time per call, in microseconds, of the package's metric functions on one seeded selection of n = 60 of the N = 625 hybrids of the teaching scale (25 + 25 lines, 2,000 markers), from cost_per_eval(): repetitions are multiplied by 4 until the timed block lasts 0.2 s. One run at render, not replicated, machine-dependent; one decimal."
fmt(cost_per_eval(ctx, n_sel = 60, reps = 40), 1)

#' 
#' ## Finding 3: within one lens, the metric space is nearly one-dimensional {#sec-choosing-redundancy}
#' 
## -----------------------------------------------------------------------------
#| label: redundancy-stats
#| echo: false
fam  <- sub(" w=.*", "", red$strategy)
mets <- setdiff(names(red), c("strategy", "mean_index"))   # 16 diversity columns
rk   <- sapply(red[mets], rank)
pc_share <- function(cols) {
  p <- prcomp(rk[, cols], scale. = TRUE); (p$sdev^2 / sum(p$sdev^2))[1:2]
}
copies <- c("gene_diversity", "He_Nei", "loss_pct", "status_number")  # theta rescaled
pc16 <- pc_share(mets)
pc12 <- pc_share(setdiff(mets, copies))
others <- setdiff(mets, "theta")
rho_th <- vapply(others, function(k) cor(red$theta, red[[k]], method = "spearman"), numeric(1))
stopifnot(all(abs(rho_th[copies]) > 1 - 1e-9),          # exact monotone functions of theta
          all(red$alleles_retained + red$alleles_fixed == 12000))
rt <- rank(red$theta)
resid_frac <- vapply(others, function(k) {
  r <- rank(red[[k]]); sd(resid(lm(r ~ rt + I(rt^2)))) / sd(r)
}, numeric(1))
rho_by <- sapply(c("Ne_parents", "alleles_retained"), function(k)
  vapply(c("random", "truncation", "restricted line pool"), function(f)
    cor(red$theta[fam == f], red[[k]][fam == f], method = "spearman"), numeric(1)))
bd <- red[abs(red$theta - median(red$theta)) < 0.002, ]

#' 
#' **Assumptions and scope of this analysis.** It reads `metric_redundancy.csv` (@fig-choosing-redundancy), a
#' **cached external result** with no producer here and no recorded setting (the
#' number of lines, hybrids, markers, $n$ and $F_{BN}$ are not in the file; the
#' previous version of this chapter gave $F_{BN} = 0.15$ and 12,000 markers, and I
#' cannot check either against the file). Every row has alleles retained plus alleles
#' fixed equal to 12,000, so I read 12,000 as $2m$ alleles of $m = 6{,}000$
#' biallelic markers, an inference. For the same reason the column `alleles_retained` is identified
#' with @eq-catalogue-alleles-retained by inference: it is consistent with it (values within $[m, 2m]$
#' for that $m$), but the producer is not available to confirm the definition or the set of lines
#' it was computed on. Three things bound what it can say.
#' 
#' 1. **One lens.** All columns are homozygosity-lens quantities, functions of
#'    $\mathbf{f}$, the pedigree or the line usage. $F_{drift}$ and $F_{hom}$
#'    (@sec-genomic-era) are not among them, so "redundant with $\theta$" means
#'    redundant *inside that lens*, and nothing is said about the drift lens.
#' 2. **A mix of strategies.** The `r nrow(red)` selections are
#'    `r paste(sprintf("%d %s", as.integer(table(fam)[c("random", "truncation", "restricted line pool", "greedy")]), c("random", "truncation", "restricted-line-pool", "greedy")), collapse = ", ")`
#'    (the greedy ones are `r length(unique(red$strategy[fam == "greedy"]))` index
#'    weights `w` from 0 to 1, eight selections each). Rank correlations, retained
#'    fractions and principal-component analysis (PCA) shares are properties of this mix, not of any one strategy:
#'    $\rho(\theta, N_{e,\text{par}})$ is
#'    `r fmt(rho_by[["random", "Ne_parents"]], 2)` within the random selections and
#'    `r fmt(rho_by[["truncation", "Ne_parents"]], 2)` within truncation, against
#'    `r fmt(rho_th[["Ne_parents"]], 3)` over all of them.
#' 3. **The `eff_dim` column is not the package's `eff_dim()`.** Its mean is
#'    `r fmt(mean(red$eff_dim), 3)` (range `r fmt(min(red$eff_dim), 3)` to
#'    `r fmt(max(red$eff_dim), 3)`), of the order of the *uncentred* participation
#'    ratio of @sec-catalogue (1.47 on that chapter's subset) and nowhere near the
#'    double-centred value the package computes (26.19 there). The file does not say
#'    which form it holds; I read it as the uncentred ratio. An uncentred ratio
#'    re-measures $\theta$ by construction (Rayleigh bound, @sec-catalogue), so the
#'    redundancy of `eff_dim` below is a statement about that form and is not
#'    evidence about the package's `eff_dim()`, which is the one timed in Finding 2.
#'    The same file does not record which definition of A-NE it used (@sec-catalogue
#'    keeps a nonzero self-distance).
#' 
## -----------------------------------------------------------------------------
#| label: fig-choosing-redundancy
#| echo: false
#| fig-cap: "Metric redundancy, cached external figure (no producer in this repository). A: Spearman correlations across the 621 selections. B: PCA of rank-transformed metrics. C: the discriminating case, inside a narrow coancestry band. The panel B title in the cached figure ('allelic richness the one real second axis') is withdrawn by the text of @sec-choosing-redundancy: several metrics keep as much rank variation as allelic richness."
#| fig-alt: "Three panels. A: a heat map of Spearman correlations among 17 metrics, almost all strongly positive or negative with group coancestry. B: a principal-component plot in which the first axis carries most of the rank variance and the second axis separates the between-pool coancestry and allele counts. C: a scatter, inside a narrow band of group coancestry, of marker alleles retained against the effective number of parent lines, rising together over several tens of alleles."
knitr::include_graphics(book_fig("metric_redundancy.png"))

#' 
#' **PC1 absorbs `r fmt(100 * pc16[1], 1)`% of the rank variance of the 16
#' diversity columns, PC2 `r fmt(100 * pc16[2], 1)`%.** (The 17th column of the file,
#' `mean_index`, is the objective and is left out. The 16 include four exact
#' rescalings of $\theta$: gene diversity, Nei's $H_e$, `loss_pct` and status number
#' all have $|\rho| = 1$. Without those four copies the shares are
#' `r fmt(100 * pc12[1], 1)`% and `r fmt(100 * pc12[2], 1)`%.) Rank correlations with
#' $\theta$ over the whole mix are
#' `r fmt(abs(rho_th[["eff_dim"]]), 3)` for `eff_dim` (uncentred form, item 3 of the scope paragraph above),
#' `r fmt(abs(rho_th[["alleles_lost_MAF"]]), 3)` for allele loss at a minor allele frequency (MAF) threshold and
#' `r fmt(abs(rho_th[["Ne_parents"]]), 3)` for $N_{e,\text{par}}$.
#' 
#' But the marginal correlation is the wrong test. The question is whether a metric
#' varies **at fixed $\theta$** -- because $\theta$ is the constraint, and any
#' metric that is a deterministic function of it cannot discriminate among plans
#' the optimiser treats as equivalent. The residual test: regress the ranks of each
#' metric on the rank of $\theta$ and its square, and report the standard deviation
#' of the residual as a fraction of the standard deviation of the ranks
#' (@tbl-redundancy-residual; a fraction of 0.52 corresponds to $R^2 \approx 0.73$).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-redundancy-residual
#| echo: false
#| tbl-cap: "Residual rank standard deviation after a quadratic regression of the metric's ranks on the ranks of theta, as a fraction of the standard deviation of its ranks; Spearman correlation with theta; 621 selections of the cached redundancy analysis (strategy mix as stated in the scope paragraph of @sec-choosing-redundancy). Alleles fixed is 12,000 minus alleles retained and is omitted. The fraction is dimensionless, it is zero for an exact monotone function of theta, and it also counts ties and sampling noise in integer-valued metrics."
tr <- data.frame(metric = names(resid_frac), `residual fraction` = resid_frac,
                 `Spearman rho` = rho_th, check.names = FALSE)
tr <- tr[!(tr$metric %in% c(copies, "alleles_fixed")), ]
tr <- tr[order(-tr$`residual fraction`), ]
rownames(tr) <- NULL
fmt(tr, 3)

#' 
#' - `r sum(tr[["residual fraction"]] >= 0.35)` of the `r nrow(tr)` metrics in the table
#'   keep at least 0.35 of their rank standard deviation after $\theta$: between-pool coancestry `theta_between`
#'   (`r fmt(resid_frac[["theta_between"]], 2)`), **A-NE**
#'   (`r fmt(resid_frac[["A_NE"]], 2)`), **E-NE**
#'   (`r fmt(resid_frac[["E_NE"]], 2)`), **alleles retained**
#'   (`r fmt(resid_frac[["alleles_retained"]], 2)`), the number of lines used
#'   (`r fmt(resid_frac[["n_lines_used"]], 2)`), and then the two within-pool
#'   coancestries (`r fmt(resid_frac[["theta_within_A"]], 2)`,
#'   `r fmt(resid_frac[["theta_within_B"]], 2)`), $N_{e,\text{par}}$
#'   (`r fmt(resid_frac[["Ne_parents"]], 2)`) and MAF-threshold allele loss
#'   (`r fmt(resid_frac[["alleles_lost_MAF"]], 2)`). Allelic richness is therefore
#'   **one of several** metrics that vary at fixed $\theta$, not the only one, and
#'   $N_{e,\text{par}}$ and MAF allele loss retain about the same amount. The
#'   uncentred `eff_dim` retains `r fmt(resid_frac[["eff_dim"]], 2)`.
#' - Inside the band $|\theta - \text{median}(\theta)| < 0.002$ (that is
#'   $\theta \in [`r fmt(min(bd$theta), 4)`, `r fmt(max(bd$theta), 4)`]$), which holds
#'   `r nrow(bd)` selections of which `r sum(bd$strategy == "random")` are random,
#'   **alleles retained spans `r diff(range(bd$alleles_retained))` alleles**
#'   (`r min(bd$alleles_retained)` to `r max(bd$alleles_retained)` of 12,000) and
#'   $N_{e,\text{par}}$ spans **`r fmt(min(bd$Ne_parents), 1)` to
#'   `r fmt(max(bd$Ne_parents), 1)`**.
#' 
#' Plans the constraint cannot distinguish differ in how many alleles they carry
#' forward and in how concentrated their parentage is. That is the empirical case for
#' tracking something beside $\theta$. It does not choose among the metrics that keep
#' variation: the residual fraction measures departure from a smooth function of
#' $\theta$ in this sample, not relevance to a breeding objective, so it is a
#' necessary condition for a validation metric and not a sufficient one. Within the
#' random selections alone, $\rho(\theta, \text{alleles retained})$ is
#' `r fmt(rho_by[["random", "alleles_retained"]], 2)`, so a good part of the
#' correlation over the whole mix comes from the strategies differing from one
#' another.
#' 
#' ### Reproducing the argument at the teaching scale
#' 
#' The chunk below (@fig-ne-par-at-fixed-theta) does the Ne_par half of the argument
#' live, at the teaching scale and with the same band rule. It does not compute allelic richness.
#' 
## -----------------------------------------------------------------------------
#| label: fig-ne-par-at-fixed-theta
#| fig-cap: "Effective number of parent lines against theta for the distinct greedy selections returned by an index-weight grid of 30 values (w = 0 and 1e-5 to 1e-2, log spaced; red; the number of distinct selections is in the text) and 60 random selections (grey), teaching scale, seed 77. Selections of similar theta differ in N_e,par; the range inside the band is computed in the chunk `ne-par-band`."
#| fig-alt: "Scatter of the effective number of parent lines against group coancestry theta. Random selections form a cloud; greedy selections run from low theta and high effective number of parents to high theta and low effective number of parents. Where the two overlap in theta, the greedy selections have the smaller effective number of parents."
set.seed(77)
# index weights on a log grid: the greedy score w * u - theta switches from pure
# diversity to near-truncation between w = 1e-5 and w = 1e-2 at this scale (a
# linear grid on 0 to 4 returns only two distinct selections)
gsel <- lapply(c(0, 10^seq(-5, -2, length.out = 29)), function(w) sort(sel_greedy(ctx, 60, w = w)))
gw   <- c(0, 10^seq(-5, -2, length.out = 29))
keep <- !duplicated(gsel)    # different weights can return the same selection
n_distinct_greedy <- sum(keep)
grid <- do.call(rbind, lapply(which(keep), function(i)
  data.frame(w = gw[i], theta = theta_group(gsel[[i]], ctx), Ne_par = ne_parents(gsel[[i]], ctx))))
rnd <- do.call(rbind, lapply(1:60, function(i) {
  s <- sample.int(ctx$N, 60)
  data.frame(w = NA, theta = theta_group(s, ctx), Ne_par = ne_parents(s, ctx))
}))
pts <- rbind(grid, rnd)

plot(pts$theta, pts$Ne_par, pch = 19, col = ifelse(is.na(pts$w), book_pal[["mid"]], book_pal[["loss"]]),
     xlab = expression(theta), ylab = expression(N[e]~"parents"))
legend("topright", c("greedy sweep", "random"), pch = 19,
       col = c(book_pal[["loss"]], book_pal[["mid"]]), bty = "n")
grid()

#' 
#' Here `w` is the *index* weight of the greedy score $w\,u_i - \theta$ (the
#' $\omega$ of @sec-notation, written `w` in @sec-combinatorial), not the line-usage
#' vector $\mathbf{w}$ of Finding 1: `w = 0` is pure diversity and larger values
#' weigh the index more.
#' 
#' @tbl-choosing-ne-band gives the band.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-choosing-ne-band
#| tbl-cap: "Selections of @fig-ne-par-at-fixed-theta (distinct greedy and random together) inside the band |theta - median(theta)| < 0.002: their number, the span of theta (dimensionless), the smallest and largest effective number of parent lines N_e,par (a count of lines) and the ratio of the two. One seed (77), teaching scale."
band <- pts[abs(pts$theta - median(pts$theta)) < 0.002, ]
fmt(data.frame(n_in_band = nrow(band),
  theta_span = diff(range(band$theta)),
  Ne_par_min = min(band$Ne_par), Ne_par_max = max(band$Ne_par),
  Ne_par_ratio = max(band$Ne_par) / min(band$Ne_par)), 4)

#' 
#' The 30 index weights return `r n_distinct_greedy` distinct greedy selections (the
#' rest repeat another weight's selection and are counted once). At the teaching scale,
#' among the `r nrow(band)` distinct selections in the band (greedy and random
#' together), $N_{e,\text{par}}$ varies by a factor of
#' `r fmt(max(band$Ne_par) / min(band$Ne_par), 2)`, against
#' `r fmt(max(bd$Ne_parents) / min(bd$Ne_parents), 2)` in the cached analysis. The two
#' factors are not comparable: the selections of the two analyses come from different
#' strategy mixes, different sizes and different numbers of selections. One seed, one
#' scale: the factor is not an estimate.
#' 
#' ::: {.callout-note}
#' ## A caveat on transfer
#' 
#' These numbers come from one simulation of two pools, setting undeclared in the
#' file, and the residual fractions are properties of the strategy mix above. The
#' direction of the conclusion -- several metrics vary at fixed $\theta$, allelic
#' richness among them -- is what the file supports; the exact fractions will shift
#' with pool divergence $F_{BN}$, marker density and the mix of strategies. Re-running the redundancy analysis on real
#' genotypes, with the package's own `eff_dim()`, is a half-hour job and worth doing
#' before treating the recommendation as final.
#' :::
#' 
#' ## Finding 4: searching on line weights, a preview of @sec-combinatorial {#sec-choosing-search}
#' 
#' This finding uses differential evolution (DE), a penalty or a repair step for
#' violated restrictions, the per-line usage cap `max_use` (the largest number of
#' times one line may be a parent) and a decoder that turns a weight vector into a
#' selection. They are introduced in @sec-combinatorial and @sec-advanced, which
#' come later; read this finding as a preview and take the full treatment, with its
#' qualifiers, from there.
#' 
#' **What was run (cached, external).** `de_constraints.csv` (@fig-choosing-de-convergence, @tbl-choosing-de) holds differential
#' evolution runs through `make_fitness_fast()` with no producer in this repository.
#' Its `dim` column is
#' `r paste(unique(de$dim), collapse = " and ")`: one random key per hybrid
#' ($N = 3{,}600$ hybrids, from $L = 120$ lines as @sec-combinatorial states) or one
#' weight per line. Four simultaneous restrictions, defined in
#' @sec-combinatorial-restrictions: diversity loss $\le 0.5\%$,
#' $N_{e,\text{par}} \ge 50$, at most 6 uses per line, and heterotic-pool balance
#' within 5%. Budget `r format(unique(de$evaluations), big.mark = ",")` evaluations
#' per run, three seeds per configuration. **Not recorded:** the number selected
#' $n$, the DE population size `NP`, the iteration count. **Neither arm is
#' `sel_de()`**, and neither is warm-started: in the cached convergence figure both
#' begin from random keys or weights (the line-weight curves start at about $-1$ and
#' the hybrid-key curves at about 0.27 on the penalised index).
#' 
## -----------------------------------------------------------------------------
#| label: fig-choosing-de-convergence
#| echo: false
#| fig-cap: "Differential evolution under four simultaneous restrictions at an equal budget of 60,000 evaluations, cached external figure. The panel titles in the cached figure say that only the line encoding pushes the constraints to their limits; @tbl-choosing-de and the text of @sec-choosing-search show that this is not so for the cap on uses per line."
#| fig-alt: "Two panels. A: best penalised index against fitness evaluations; three line-weight runs climb from about minus one to about two, while hybrid-key runs stay near 0.3. B: four small panels of the achieved index, diversity loss, effective parents and maximum uses per line for the three configurations."
knitr::include_graphics(book_fig("de_convergence.png"))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-choosing-de
#| echo: false
#| tbl-cap: "Mean over 3 seeds, cached external data. Limits: loss 0.5%, Ne parents 50, max uses 6, pool imbalance 5%. All configurations returned feasible plans."
agg <- aggregate(cbind(index, loss_pct, Ne_parents, max_use, pool_imbalance, secs) ~ encoding, de, mean)
names(agg) <- c("encoding", "index", "loss %", "Ne parents", "max uses", "pool imbalance", "seconds")
knitr::kable(fmt(agg, 3), digits = 3, row.names = FALSE)

#' 
## -----------------------------------------------------------------------------
#| echo: false
hk <- de[de$encoding == "hybrid keys / penalty", ]
hr <- de[de$encoding == "hybrid keys / repair", ]
lw <- de[de$encoding == "line weights / repair", ]
stopifnot(isTRUE(all.equal(hk$index, hr$index)), isTRUE(all.equal(hk$Ne_parents, hr$Ne_parents)))

#' 
#' **Result.** At the same evaluation budget the search with one key per hybrid
#' reaches a mean index of `r fmt(mean(hk$index), 3)` (seed range
#' `r fmt(min(hk$index), 3)` to `r fmt(max(hk$index), 3)`) and the search with one
#' weight per line `r fmt(mean(lw$index), 3)` (`r fmt(min(lw$index), 3)` to
#' `r fmt(max(lw$index), 3)`); the difference is `r fmt(mean(lw$index) - mean(hk$index), 2)`
#' index units, and the seed ranges do not overlap. (A ratio of the two is not
#' quoted: the index has no natural zero here, and the hybrid arm starts above the
#' line arm on the penalised scale.) In the hybrid arm $N_{e,\text{par}}$ is
#' `r fmt(min(hk$Ne_parents), 1)` to `r fmt(max(hk$Ne_parents), 1)` against a floor
#' of 50 and loss is `r fmt(min(hk$loss_pct), 2)` to `r fmt(max(hk$loss_pct), 2)`%
#' against a ceiling of 0.5%: both slack. The maximum number of uses is
#' `r paste(hk$max_use, collapse = ", ")` against a cap of 6, so the cap is reached
#' in `r sum(hk$max_use == 6)` of the 3 seeds. In the line arm $N_{e,\text{par}}$ is
#' `r fmt(min(lw$Ne_parents), 2)` to `r fmt(max(lw$Ne_parents), 2)`, the maximum
#' number of uses is 6 in every seed, and loss is `r fmt(min(lw$loss_pct), 2)` to
#' `r fmt(max(lw$loss_pct), 2)`%. Pool imbalance is
#' `r paste(unique(de$pool_imbalance), collapse = ", ")` in all
#' `r nrow(de)` rows: that restriction is slack in every configuration, so the
#' "four simultaneous restrictions" bind on two of four at most (the line arm's
#' $N_{e,\text{par}}$ and uses per line). Penalty and repair returned numerically
#' identical plans in the hybrid arm for all three seeds; no line-weight arm with a
#' penalty was run.
#' 
#' **Interpretation, and what limits it.** Feasible plans with index
#' `r fmt(mean(lw$index), 2)` exist for this problem (the line-arm plans), so the
#' hybrid-arm plans at `r fmt(mean(hk$index), 2)` with slack constraints are not
#' constrained optima: a slack constraint at the end of a run is here the sign of an
#' unconverged search, not of a conservative plan. This follows from the table; it is
#' not a general rule. Three limits apply. (a) The comparison is between two
#' encodings through the same fitness, not between two constraint handlers: the
#' handlers were compared only in the hybrid arm, where they returned the same plans,
#' and I do not know why (one reading is that the hybrid search stayed far from the
#' boundary; it was not tested). The line decoder satisfies the cap by construction
#' (@sec-combinatorial), so "uses per line = 6" in the line arm is not evidence that
#' the search found the boundary. (b) Neither arm is `sel_de()`, and the benchmark of @sec-advanced
#' (`search_benchmark.csv`, regenerated in this repository; $N = 625$, $L = 50$,
#' $n = 60$, cap 5 uses per line at its book scale; $N = 10{,}000$, $L = 200$,
#' $n = 200$, cap 4 at its production scale; Finding 4's cap is 6) does not settle
#' which of the two is ahead in this finding's setting. It has 3 seeds per method and
#' scale. On its *uncapped* rows `sel_de()` (`de_hybrid`) has a mean index of
#' `r fmt(bm("book", "de_hybrid")[["m"]], 3)` (sd `r fmt(bm("book", "de_hybrid")[["s"]], 3)`)
#' against `r fmt(bm("book", "de_lines")[["m"]], 3)`
#' (sd `r fmt(bm("book", "de_lines")[["s"]], 3)`) for line-encoded DE (`de_lines`) at the
#' book scale, a difference of `r fmt(bd_diff("book", "de_hybrid", "de_lines")[["d"]], 3)`
#' with standard error `r fmt(bd_diff("book", "de_hybrid", "de_lines")[["se"]], 3)`; at the
#' production scale `r fmt(bm("production", "de_hybrid")[["m"]], 3)`
#' (sd `r fmt(bm("production", "de_hybrid")[["s"]], 3)`) against
#' `r fmt(bm("production", "de_lines")[["m"]], 3)`
#' (sd `r fmt(bm("production", "de_lines")[["s"]], 3)`), a difference of
#' `r fmt(bd_diff("production", "de_hybrid", "de_lines")[["d"]], 3)` with standard error
#' `r fmt(bd_diff("production", "de_hybrid", "de_lines")[["se"]], 3)`, which three seeds
#' do not resolve. On its *capped* rows, the setting of this finding (a cap on uses per
#' line, a decoder that satisfies it by construction), the means are
#' `r fmt(bm("book", "de_hybrid_cap")[["m"]], 4)` (`de_hybrid_cap`) against
#' `r fmt(bm("book", "de_lines_cap")[["m"]], 4)` (`de_lines_cap`) at the book scale, a
#' difference of `r fmt(bd_diff("book", "de_hybrid_cap", "de_lines_cap")[["d"]], 4)`, and
#' `r fmt(bm("production", "de_hybrid_cap")[["m"]], 4)` against
#' `r fmt(bm("production", "de_lines_cap")[["m"]], 4)` at the production scale, a
#' difference of `r fmt(bd_diff("production", "de_hybrid_cap", "de_lines_cap")[["d"]], 4)`,
#' with a seed standard deviation of `r fmt(max_cap_sd, 3)` in every capped cell; why the
#' seeds agree exactly was not examined. At the book scale the gap is therefore the same
#' in every seed and no standard error exists to judge it by; at the production scale the
#' two arms are equal. The cached benchmark therefore supports
#' "`sel_de()` ahead of line-encoded DE" only without a cap, and resolved only at the
#' book scale; with a cap it shows an unjudged gap of
#' `r fmt(bd_diff("book", "de_hybrid_cap", "de_lines_cap")[["d"]], 4)` at the book scale and
#' none at the production scale. The result above is a verdict on the
#' $N$-dimensional key encoding, not on `sel_de()`. (c) Three seeds, one setup, no
#' interval. The search effort also differs in kind: with
#' `NP` at least ten times the number of parameters, the guidance of the
#' `DEoptim.control` help page (the package is described by @mullen2011), 3,600
#' parameters call for 36,000 population members, so 60,000 evaluations are fewer than
#' two generations; at 120 parameters 1,200 members give about 50 generations. The `NP`
#' of the cached run was not recorded, so I cannot say that either arm followed
#' that guidance. An earlier version of this finding quoted an unconstrained
#' truncation index, a diversity loss, an effective number of parents and a count of
#' uses for a comparison point, and a percentage of that index recovered; none is in
#' any file or script of this repository, the selection size of that run is unknown,
#' and an unconstrained plan is not the fair comparator for a capped search. They are
#' withdrawn.
#' 
#' ## Finding 5: the index is not the truth, and its error is not white {#sec-choosing-error}
#' 
#' Findings 1 to 4 are about the diversity side of the objective. This one is about
#' the other side, and it is the larger uncertainty of the two.
#' 
#' Everywhere in this book `ctx$index` is built from *known* marker effects
#' (@sec-simulating-crosses), so every result so far assumes the breeding values are
#' predicted without error. Real ones are not, and the error is not white noise:
#' predictions for close relatives are wrong in the same direction, because they lean
#' on the same training records and share the same haplotypes. The book already has a
#' matrix of exactly that structure -- the molecular coancestry $\mathbf{f}$ -- so
#' the error can be simulated without inventing anything. (@sec-genomic-prediction
#' fits an actual genomic BLUP (GBLUP) model later and reports, in one simulation, a positive correlation
#' of the products of its prediction errors with $\mathbf f$ against a permutation reference (not a formal
#' test, and not compared with this generator). Its realised accuracies are against one trait, not the
#' three-trait index used here, so the comparison is of orders of magnitude only: CV2 has a mean of
#' about 0.9, at the lower edge of the 0.9 to 1 values explored here (@tbl-genpred-cv), and CV1
#' between 0.5 and 0.7.)
#' 
#' **Assumptions.** Teaching scale (25 + 25 lines, 2,000 markers, $N = 625$ hybrids),
#' $n = 60$ selected, index $u_i$ the true additive index of the simulation. The
#' prediction is $\hat u = \text{scale}(r\,u + \sqrt{1 - r^2}\,e)$ with $e$ a
#' standardised error vector, either $\mathbf{T}\mathbf{z}$ with
#' $\mathbf{T}\mathbf{T}^\top = \mathbf{f} + 10^{-8}\mathbf{I}$, $\mathbf{T}$ the lower-triangular
#' Cholesky factor (error correlated with relatedness) or $\mathbf{z}$ (independent), $\mathbf{z} \sim N(0, \mathbf{I})$; both
#' kinds are run and every table says which it uses (`kind`, default `"correlated"` in
#' `predicted()`). The $r$ is a **nominal** accuracy: $e$ is not orthogonalised against
#' $u$, so the realised correlation of $\hat u$ with $u$ differs from $r$ in every seed
#' (its mean and spread by kind are reported below). Unit of replication: the seed of
#' $\mathbf{z}$, twenty seeds for the accuracy table and sixty for the comparison of the two kinds of error, each set inside `predicted()`. The diversity loss
#' $\alpha$ is measured against `gd_ref` of a resampling null with $B = 400$
#' (`null_distribution()`, its own seed 7).
#' 
## -----------------------------------------------------------------------------
n_sel <- 60
null  <- null_distribution(ctx, n_sel, B = 400, B_full = 60)
gd    <- null$gd_ref
u     <- ctx$index
Lc    <- t(chol(ctx[["f"]] + diag(1e-8, ctx$N)))

# A predicted index at nominal accuracy r. `kind` decides whether the error is
# correlated with relatedness or independent between hybrids.
predicted <- function(r, seed, kind = "correlated") {
  set.seed(seed)
  z <- rnorm(ctx$N)
  e <- if (kind == "correlated") as.numeric(Lc %*% z) else z
  e <- (e - mean(e)) / stats::sd(e)
  as.numeric(scale(r * u + sqrt(1 - r^2) * e))
}

#' 
#' Select on the prediction, then score the plan on the truth, over twenty seeds per
#' accuracy and per kind of error (@tbl-choosing-accuracy reports both kinds; the two coincide at
#' $r = 1$, where the prediction is the truth):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-choosing-accuracy
#| tbl-cap: "Truncation and greedy (index weight w = 3e-4) selecting n = 60 of the N = 625 hybrids of the teaching scale on a predicted index of nominal accuracy r, scored on the true index; mean over 20 seeds per method, kind of error and r, with the standard error over seeds (s.e.) for realised and alpha only (reported and r_real carry none). r_real: realised correlation of the prediction with the true index. reported: mean predicted index of the plan (the prediction is scaled to unit s.d.). realised: mean true index of the plan. alpha: proportional loss of gene diversity against gd_ref (B = 400), a dimensionless fraction. At r = 1 the prediction is the truth, so the two kinds of error coincide and the s.e. is zero."
run <- function(r, seed = 1, kind = "correlated") {
  ch <- ctx; ch$index <- predicted(r, seed, kind)
  sel <- list(truncation = sel_truncation(ch, n_sel),
              greedy     = sel_greedy(ch, n_sel, w = 3e-4))
  do.call(rbind, lapply(names(sel), function(nm) data.frame(
    method = nm, kind = kind, r = r, r_real = cor(ch$index, u),
    reported = mean(ch$index[sel[[nm]]]),
    realised = mean(u[sel[[nm]]]),
    alpha    = alpha_loss(sel[[nm]], ctx, gd))))
}
kinds <- c("correlated", "independent")
acc_all <- do.call(rbind, lapply(kinds, function(k)
  do.call(rbind, lapply(c(1, 0.9, 0.7, 0.5), function(r)
    do.call(rbind, lapply(1:20, function(s) cbind(seed = s, run(r, s, k))))))))
se <- function(x) sd(x) / sqrt(length(x))
acc    <- aggregate(cbind(r_real, reported, realised, alpha) ~ method + kind + r, acc_all, mean)
acc_se <- aggregate(cbind(reported, realised, alpha) ~ method + kind + r, acc_all, se)
acc$`s.e. realised` <- acc_se$realised
acc$`s.e. alpha`    <- acc_se$alpha
fmt(acc[order(acc$method, acc$kind, -acc$r), ], 4)

#' 
#' (Mean over twenty seeds, with the standard error over seeds. At $r = 1$ the
#' prediction is the truth and does not depend on the seed, so its standard error is
#' zero.)
#' 
## -----------------------------------------------------------------------------
#| label: f5-monotone
#| output: false
# in how many seeds is alpha non-decreasing in r, i.e. falls as accuracy falls?
mono <- sapply(kinds, function(k) vapply(c("truncation", "greedy"), function(m)
  sum(vapply(1:20, function(s) {
    a <- acc_all[acc_all$method == m & acc_all$kind == k & acc_all$seed == s, ]
    !is.unsorted(a$alpha[order(a$r)])
  }, logical(1))), numeric(1)))
mono
# paired contrast r = 1 vs r = 0.5 within seed, truncation: difference of alpha
# (r = 1 minus r = 0.5), its mean, standard error and the ratio of the two
pc <- t(sapply(kinds, function(k) {
  a <- acc_all[acc_all$method == "truncation" & acc_all$kind == k, ]
  d <- a$alpha[a$r == 1][match(1:20, a$seed[a$r == 1])] -
       a$alpha[a$r == 0.5][match(1:20, a$seed[a$r == 0.5])]
  c(mean = mean(d), se = se(d), ratio = mean(d) / se(d), n_positive = sum(d > 0))
}))
pc
acc_get <- function(k, r, v) acc[[v]][acc$method == "truncation" & acc$kind == k & acc$r == r]
acc_gr  <- function(k, r, v) acc[[v]][acc$method == "greedy" & acc$kind == k & acc$r == r]

#' 
#' Two things are read from this. First, the gap between `reported` and `realised`
#' opens up: at nominal $r = 0.5$ and correlated error truncation reports an index of
#' `r fmt(acc_get("correlated", 0.5, "reported"), 2)` and delivers
#' `r fmt(acc_get("correlated", 0.5, "realised"), 2)` (seed mean; realised accuracy
#' `r fmt(acc_get("correlated", 0.5, "r_real"), 2)`; with independent error
#' `r fmt(acc_get("independent", 0.5, "reported"), 2)`, `r fmt(acc_get("independent", 0.5, "realised"), 2)`
#' and `r fmt(acc_get("independent", 0.5, "r_real"), 2)`). Selection on a noisy value selects
#' partly on the noise, so the plan's own scorecard is biased upward; nothing in the
#' pipeline can detect this without the truth.
#' 
#' Second, the behaviour of $\alpha$ with accuracy depends on the kind of error, and the
#' sentence "$\alpha$ moves little with accuracy" holds for **correlated error only**.
#' For truncation under correlated error $\alpha$ is
#' `r fmt(100 * acc_get("correlated", 1, "alpha"), 2)`,
#' `r fmt(100 * acc_get("correlated", 0.9, "alpha"), 2)`,
#' `r fmt(100 * acc_get("correlated", 0.7, "alpha"), 2)` and
#' `r fmt(100 * acc_get("correlated", 0.5, "alpha"), 2)`% at $r = 1, 0.9, 0.7, 0.5$; under
#' independent error it is
#' `r fmt(100 * acc_get("independent", 1, "alpha"), 2)`,
#' `r fmt(100 * acc_get("independent", 0.9, "alpha"), 2)`,
#' `r fmt(100 * acc_get("independent", 0.7, "alpha"), 2)` and
#' `r fmt(100 * acc_get("independent", 0.5, "alpha"), 2)`%. The paired difference
#' $\alpha(r = 1) - \alpha(r = 0.5)$ within seed, truncation, has mean
#' `r fmt(100 * pc["correlated", "mean"], 2)` percentage points under correlated error
#' (standard error `r fmt(100 * pc["correlated", "se"], 2)`, about
#' `r fmt(pc["correlated", "ratio"], 1)` standard errors, positive in
#' `r pc["correlated", "n_positive"]` of 20 seeds) and
#' `r fmt(100 * pc["independent", "mean"], 2)` under independent error (standard error
#' `r fmt(100 * pc["independent", "se"], 2)`, about
#' `r fmt(pc["independent", "ratio"], 0)` standard errors, positive in
#' `r pc["independent", "n_positive"]` of 20). The yardstick for the difference is its
#' standard error, not the seed-to-seed standard deviation of a single $\alpha$. Under
#' correlated error the decline is small, `r fmt(100 * pc["correlated", "mean"] / acc_get("correlated", 1, "alpha"), 0)`%
#' of the loss at $r = 1$, but it is not indistinguishable from zero at this number of
#' seeds; the paired contrast has not been tested at other accuracies. The
#' count of seeds in which $\alpha$ is non-decreasing in $r$ is
#' `r mono[["truncation", "correlated"]]` of 20 for truncation and
#' `r mono[["greedy", "correlated"]]` of 20 for greedy under correlated error, and
#' `r mono[["truncation", "independent"]]` and `r mono[["greedy", "independent"]]` under
#' independent error. One reading of the independent-error fall is that noisy selection is
#' closer to random selection, which $GD_{\text{ref}}$ is defined against; that
#' mechanism was not tested here.
#' Greedy (index weight $3 \times 10^{-4}$) behaves differently under independent error:
#' $\alpha$ falls from `r fmt(100 * acc_gr("independent", 1, "alpha"), 2)`% at $r = 1$ to
#' `r fmt(100 * acc_gr("independent", 0.5, "alpha"), 2)`% at $r = 0.5$ (standard error over
#' seeds `r fmt(100 * acc_gr("independent", 0.5, "s.e. alpha"), 2)`), and this value is
#' negative, that is, the plan is more diverse than the random-subset baseline $GD_{\text{ref}}$
#' (sign convention of @sec-notation). The fall is monotone in $r$ in
#' `r mono[["greedy", "independent"]]` of 20 seeds, whereas under correlated error $\alpha$ stays
#' positive (`r fmt(100 * acc_gr("correlated", 0.5, "alpha"), 2)`% at $r = 0.5$). The
#' reading offered for truncation, noisy selection being closer to random selection, cannot
#' account for a value below random. A reading consistent with the data, not tested here
#' (for example by varying the index weight), is that greedy penalises $\theta$ directly, so
#' that when the error carries no information on relatedness the index term no longer pulls
#' the plan toward related hybrids and the penalty dominates. Selection at the
#' teaching scale on $n = 60$ of $N = 625$ is the only scale measured, and the diversity
#' loss of a plan on a noisy index therefore cannot be inferred from the accuracy alone:
#' it depends on how the error is distributed over relatives.
#' 
#' ### The correlation structure of the error matters
#' 
#' Hold the nominal accuracy at $r = 0.6$ and change only whether the error is
#' correlated with relatedness, over sixty seeds, comparing the two kinds *within*
#' each seed (@tbl-choosing-kinds; sixty rather than twenty because the realised-gain difference below was
#' unstable over blocks of twenty):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-choosing-kinds
#| tbl-cap: "Truncation of n = 60 of the N = 625 hybrids of the teaching scale on a prediction of nominal accuracy r = 0.6, error correlated with relatedness against independent error, compared within seed over 60 seeds. r_real: correlation of the prediction with the true index. alpha: proportional loss of gene diversity against gd_ref (B = 400), a dimensionless fraction. max_line: largest number of times one line is a parent of the plan, a count. realised: mean true index of the plan. paired_difference: correlated minus independent, with its standard error se over the 60 paired seeds; n_positive: seeds in which the difference is positive."
cmp <- do.call(rbind, lapply(c("correlated", "independent"), function(k)
  do.call(rbind, lapply(1:60, function(s) {
    ch <- ctx; ch$index <- predicted(0.6, s, k)
    tr <- sel_truncation(ch, n_sel)
    data.frame(kind = k, seed = s, r_real = cor(ch$index, u), realised = mean(u[tr]),
               alpha = alpha_loss(tr, ctx, gd), max_line = max_line_use(tr, ctx))
  }))))
wide <- reshape(cmp, idvar = "seed", timevar = "kind", direction = "wide")
paired <- function(v) {
  d <- wide[[paste0(v, ".correlated")]] - wide[[paste0(v, ".independent")]]
  c(mean_correlated   = mean(wide[[paste0(v, ".correlated")]]),
    mean_independent  = mean(wide[[paste0(v, ".independent")]]),
    paired_difference = mean(d), se = se(d), n_positive = sum(d > 0))
}
fmt(t(sapply(c("r_real", "alpha", "max_line", "realised"), paired)), 4)

#' 
#' (Columns: mean under each kind of error, the mean paired difference
#' correlated minus independent, its standard error over the 60 paired seeds, and the
#' number of seeds in which the difference is positive.) The same paired difference
#' of the realised index is computed by block of twenty seeds and quoted below:
#' 
## -----------------------------------------------------------------------------
#| label: f5-blocks
dr <- wide$realised.correlated - wide$realised.independent
blk <- tapply(dr, (wide$seed - 1) %/% 20 + 1, mean)

#' 
#' Same nominal accuracy, same method, same number selected. The mean realised
#' accuracy does not differ reliably between the kinds of error:
#' `r fmt(mean(wide$r_real.correlated), 2)` under correlated error against
#' `r fmt(mean(wide$r_real.independent), 2)` under independent error, a paired difference of
#' `r fmt(mean(wide$r_real.correlated - wide$r_real.independent), 3)` with standard error
#' `r fmt(se(wide$r_real.correlated - wide$r_real.independent), 4)` (positive in
#' `r sum(wide$r_real.correlated > wide$r_real.independent)` of 60 seeds). What differs is
#' the spread: the standard deviation over seeds is
#' `r fmt(sd(wide$r_real.correlated), 3)` (range `r fmt(min(wide$r_real.correlated), 2)` to
#' `r fmt(max(wide$r_real.correlated), 2)`) under correlated error and
#' `r fmt(sd(wide$r_real.independent), 3)` (range `r fmt(min(wide$r_real.independent), 2)` to
#' `r fmt(max(wide$r_real.independent), 2)`) under independent error, so "same accuracy"
#' holds on average and nominally, not seed by seed. Under correlated error truncation loses
#' `r fmt(100 * mean(wide$alpha.correlated), 2)`% of gene diversity against
#' `r fmt(100 * mean(wide$alpha.independent), 2)`% under independent error, a ratio of
#' means of `r fmt(mean(wide$alpha.correlated) / mean(wide$alpha.independent), 1)`; the
#' paired difference is positive in `r sum(wide$alpha.correlated > wide$alpha.independent)`
#' of 60 seeds. The most-used line is used
#' `r fmt(mean(wide$max_line.correlated) / mean(wide$max_line.independent), 1)` times as
#' often (positive in `r sum(wide$max_line.correlated > wide$max_line.independent)` of 60).
#' The realised index does **not** differ reliably between the kinds of error: the
#' paired difference is `r fmt(mean(wide$realised.correlated - wide$realised.independent), 3)`
#' with standard error `r fmt(se(wide$realised.correlated - wide$realised.independent), 3)`; its
#' mean by block of twenty seeds (seeds 1-20, 21-40, 41-60) is `r paste(fmt(blk, 3), collapse = ", ")`. The direction of the diversity
#' result is robust over seeds; the realised-gain difference is not a result.
#' 
#' One reading of the diversity result is direct. Independent error scatters the
#' mistakes, which accidentally diversifies the plan. Error correlated with
#' relatedness makes whole families look good together, so the plan takes families,
#' which is what the diversity constraint exists to stop it taking. The simulation
#' shows the outcome, not the families: that the families are the mechanism was not
#' tested (for example by counting selected hybrids per full-sib family).
#' 
#' :::: {.callout-warning}
#' ## The worst case is not the noisiest one
#' 
#' Truncation on a perfect index loses
#' `r fmt(100 * unique(acc$alpha[acc$method == "truncation" & acc$r == 1]), 2)`% of gene
#' diversity (with $B = 400$ here; the baseline of @sec-baseline, $B = 2000$, gives
#' 4.129%) and delivers every bit of the index it reports. Under error correlated with
#' relatedness at nominal $r = 0.6$ (sixty seeds) it loses
#' `r fmt(100 * mean(wide$alpha.correlated), 2)`%, nearly the same price, and delivers
#' `r fmt(mean(wide$realised.correlated), 2)` of the
#' `r fmt(unique(acc$realised[acc$method == "truncation" & acc$r == 1]), 2)` a perfect
#' index delivers. Independent error at the same nominal accuracy delivers a similar
#' `r fmt(mean(wide$realised.independent), 2)` for a diversity price of
#' `r fmt(100 * mean(wide$alpha.independent), 2)`%.
#' 
#' So the diversity price of aggressive selection can stay close to its full amount
#' while the gain falls well short of it, and the correlated kind of error keeps the
#' price. These seeds do not separate the two kinds of error on realised gain; the
#' design implication is to report $\alpha$ against the plan
#' actually planted and treat a reported index as an upper bound.
#' ::::
#' 
#' ### What this does to the recommendation
#' 
#' Nothing, for the metric set. Findings 1 to 3 are statements about $\mathbf{f}$ and
#' hold whatever the index is. But it changes what the numbers in @sec-case-study
#' mean, and it reorders the priorities: the choice between two diversity metrics is
#' worth a fraction of a percent of index, and prediction accuracy is worth tens of
#' percent. Report $\alpha$ against the plan you actually planted, validate accuracy
#' before tuning the constraint, and treat a reported index as an upper bound.
#' 
#' ## The recommendation, stated {#sec-choosing-recommendation}
#' 
#' The recommendation holds inside the homozygosity lens, for inbred parents and an
#' index additive in the parents (the assumptions of Finding 1), and on the cached
#' redundancy analysis, whose setting is not recorded (Finding 3).
#' 
#' ### Inside the optimiser
#' 
#' Use two metrics, both functions of the line-usage vector $\mathbf{w}$:
#' 
#' 1. **Proportional loss of gene diversity**,
#'    $\alpha = (GD_{\text{ref}} - GD_S)/GD_{\text{ref}}$ with
#'    $GD_S = 1 - \mathbf{w}^\top \mathbf{f}^L \mathbf{w}$ (@eq-collapse-theta) and
#'    $GD_{\text{ref}}$ the mean over same-size random subsets
#'    (@eq-catalogue-alpha). Compute it by the line route, never by scanning
#'    genotypes.
#' 2. **Effective number of parent lines**,
#'    $N_{e,\text{par}} = (\sum_a k_a)^2 / \sum_a k_a^2$. It costs
#'    `r sprintf("%.0f", cus[["Ne_parents"]])` us at the benchmark scale, is tabulated from the same count
#'    vector as $\theta$ inside `make_fitness_fast()`, and blocks concentration onto
#'    a few lines, a failure mode $\theta$ tolerates: in the cached analysis
#'    $N_{e,\text{par}}$ spans `r fmt(min(bd$Ne_parents), 1)` to
#'    `r fmt(max(bd$Ne_parents), 1)` inside one narrow $\theta$ band.
#' 
#' Represent the plan by line usage, so that every evaluation is the line route. If
#' the search is differential evolution on line weights, enforce the per-line usage
#' cap in the decoder rather than by penalty (it is then satisfied by construction).
#' Which search to run, line-encoded DE, `sel_de()` or a local search, is
#' @sec-combinatorial's question: Finding 4 beat a key-per-hybrid encoding in one
#' setup, and the benchmark of @sec-advanced has `sel_de()` ahead of line-encoded DE
#' only without a cap and at one of two scales (3 seeds); under a cap it is
#' `r fmt(bd_diff("book", "de_hybrid_cap", "de_lines_cap")[["d"]], 4)` above it at the book
#' scale and equal to it at the production scale (limit (b) of @sec-choosing-search).
#' 
#' ### At validation, on the returned plan only
#' 
#' 3. **Marker alleles retained**, via the bitset route
#'    (`r sprintf("%.1f", cus[["allelic richness: bitset"]] / 1000)` ms, once per
#'    plan). It is $A_{\text{ret}}$ of @eq-catalogue-alleles-retained, not the
#'    MAF-threshold count $A_{\text{lost}}$ of @sec-richness. The equation is defined on a set of
#'    inbred lines; applied to a plan of hybrids (`alleles_retained_fast(idx, ctx)` takes hybrid
#'    indices), the set $S_L$ is the lines used as parents of the plan, which under A2 gives the
#'    same count as the equation on the $\{0, 0.5, 1\}$ hybrid matrix (not computed in a chunk here). It is one of several metrics that keep rank variation at fixed
#'    $\theta$ (Finding 3), not the only one. It is chosen because it counts the
#'    alleles a plan carries forward, which is what the rare-allele argument of
#'    @sec-richness is about, and because it is cheap enough to run once.
#' 4. **Within/between heterotic-pool decomposition**, to confirm the plan has not
#'    preserved diversity by degrading pool separation (the decomposition of
#'    @caballero2002). Between-pool coancestry keeps
#'    the largest residual fraction of any metric in Finding 3
#'    (`r fmt(resid_frac[["theta_between"]], 2)`), which is the reason to look at it.
#' 5. **Status number** $N_s = 1/(2\theta)$, free from $\theta$. It adds no
#'    information: it is a monotone rescaling of $\theta$ and, on molecular
#'    $\mathbf{f}$, lies in $[1/2, 1]$ and is not a head count (@sec-ns). Do not
#'    report a rate-based $N_e$ under active management.
#' 6. **Monitoring, outside the analysis above: $F_{drift}$ and $F_{hom}$** against
#'    the random-subset null (@sec-genomic-era, @sec-catalogue). The constraint pins
#'    the homozygosity lens and not the drift lens, and the redundancy analysis
#'    contains no drift column, so nothing in this chapter says these two are
#'    redundant with $\theta$.
#' 
#' ### What the GD/ANE contrast of @sec-catalogue means for this recommendation {#sec-choosing-ane}
#' 
#' @sec-catalogue reads capped truncation against the random-subset null and finds
#' $GD$ close to the null and A-NE far from it; across twenty founder draws the
#' contrast in magnitude is the robust part, and a constraint on $GD$ alone fails to
#' flag capped truncation on some draws and not on others (@tbl-catalogue-z,
#' @tbl-catalogue-seeds-z). Finding 3 agrees from the other side: A-NE
#' (`r fmt(resid_frac[["A_NE"]], 2)`) and E-NE (`r fmt(resid_frac[["E_NE"]], 2)`) keep
#' as much rank variation at fixed $\theta$ as allelic richness does. A-NE measures
#' representativeness of the candidate set, so a plan can satisfy the constraint on
#' $\theta$ and $N_{e,\text{par}}$ while sitting in one region of genetic space, which
#' is what the A-NE reading detects. They are therefore **not** redundant, and the
#' caption of @tbl-choosing-recommendation does not say they are.
#' 
#' The reason they stay out of the optimiser is cost and form, not redundancy.
#' `ane()` reads the $N \times N$ hybrid matrix `ctx[["f"]]`, which was never formed
#' at the benchmark scale (`r sprintf("%.2f", max(cp$f_matrix_GB))` GiB), and A-NE
#' takes a minimum over $n$ selected hybrids for each of the $N$ candidates, an
#' $O(Nn)$ pass per evaluation by the formula of @sec-catalogue (not timed here). At
#' validation the cost is paid once, so A-NE is a reasonable additional item on the
#' returned plan, computed from the $N \times n$ block of $\mathbf{f}$ that
#' @eq-collapse-f lets one assemble from $\mathbf{f}^L$ without forming the full
#' matrix. That assembly is an inference from the identity; the package does not
#' implement or time it. @sec-ocs states the optimisation problem whose returned plan these would
#' validate; it computes none of the three.
#' 
#' ### Not recommended
#' 
#' - Nei's $H_e$ as a separate metric: it *is* $1 - \theta$ when computed on the
#'   group's own frequencies without the $2n/(2n-1)$ correction (@sec-catalogue; @nei1973).
#' - Effective dimensionality: it needs the hybrid matrix; the cached column is the
#'   uncentred form, which re-measures $\theta$
#'   ($|\rho| = `r fmt(abs(rho_th[["eff_dim"]]), 3)`$ over the whole mix) by
#'   construction; and the package's double-centred form was not part of the
#'   redundancy analysis, so nothing here says it is redundant.
#' - MAF-threshold allele loss, $A_{\text{lost}}$ (@eq-catalogue-alleles-lost): `r sprintf("%.0f", cus[["allele loss (MAF thr)"]])` us per
#'   evaluation, `r sprintf("%.2f", cus[["allele loss (MAF thr)"]] * 1e6 / 3.6e9)` hours per million,
#'   against `r sprintf("%.0f", cus[["allelic richness: bitset"]])` us for the bitset
#'   richness. By the residual criterion it is not redundant
#'   (`r fmt(resid_frac[["alleles_lost_MAF"]], 2)`, the same as $N_{e,\text{par}}$); it
#'   stays out on cost, and because allelic richness already stands for allele
#'   retention at validation. Whether the two carry the same information was not
#'   examined.
#' - Core Hunter's E-NE and A-NE as *optimiser* metrics (definitions in
#'   @debeukelaer2018, after @odong2013, which are distance measures for core-subset
#'   selection): they need the hybrid-level distances, as stated for `ane()` in @sec-choosing-ane.
#' 
#' ### Caveats
#' 
#' The choice of $\mathbf{f}^L$ remains open. @sec-plant-literature (later) collects
#' post-2018 studies that report matrix choice changing allele-frequency trajectories
#' and reports no consensus on a single preferred formulation; this chapter does not
#' rely on a ranking of matrices. The collapse of Finding 1 is algebra for any
#' symmetric line-level $\mathbf{f}^L$ **given** that the hybrid-level matrix is
#' defined by @eq-collapse-f, so the cost and identity results survive a change of
#' $\mathbf{f}^L$. Whether @eq-collapse-f is the right hybrid-level matrix for a
#' given choice, for a centred VanRaden matrix for example, is not established here.
#' 
#' Managing on molecular coancestry controls homozygosity, not drift; these
#' diverge, and a plan optimal on one is not optimal on the other
#' (@sec-genomic-era). A *predicted* rate of coancestry in the next generation is a
#' further matter: @gomezromano2016, as reported in @sec-ocs, find it biased
#' downward relative to the realised value, by roughly a factor of two in their
#' simulations with small candidate sets, and @sec-genomic-era shows that the sign of
#' the bias of a drift constraint is a property of the matrix. Report realised
#' $\theta$ on the chosen plan rather than a predicted rate.
#' 
#' ## Drop-in code
#' 
#' The code below is not run when the book is built. It uses `sel_de_fast()`, the
#' line-encoded DE of the package, which builds a warm start (a sweep of
#' diversity-directed line weights) and never starts cold; a direct call to
#' `DEoptim::DEoptim()` without an `initialpop` would start cold, which
#' @sec-combinatorial reports finishing below plain greedy at the package's simulation
#' scale. It carries all four
#' restrictions of Finding 4, and `NP` is ten times the number of lines, the guidance
#' of the `DEoptim.control` help page for the length of the parameter vector.
#' 
## -----------------------------------------------------------------------------
#| eval: false
# ctx <- fast_ctx(ctx, GL = line_genotypes, pack = TRUE)   # no N x N matrix needed
# 
# set.seed(1)
# gd_ref <- mean(replicate(500, fast_gene_div(sample.int(ctx$N, n_sel), ctx)))
# 
# set.seed(1)
# idx <- sel_de_fast(ctx, n_sel, gd_ref, alpha_max = 0.005,
#                    ne_par_min = 50, max_use = 6, pool_tol = 0.05,
#                    NP = 10 * ctx$n_lines, itermax = 300)
# 
# c(theta      = fast_theta(idx, ctx),
#   loss_pct   = 100 * (gd_ref - fast_gene_div(idx, ctx)) / gd_ref,
#   Ne_parents = fast_ne_parents(idx, ctx),
#   alleles    = alleles_retained_fast(idx, ctx),
#   fast_theta_pools(idx, ctx))

