#' # Advanced selection: structure, bounds and scale {#sec-advanced}
#' 
# 10b-advanced-selection -- standalone script of the chapter 10b-advanced-selection.qmd
# Book: https://ederdbs.github.io/QG/10b-advanced-selection.html
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
ctx   <- fast_ctx(simulate_data(book_cfg))
n_sel <- 60
null  <- null_distribution(ctx, n_sel, B = 400, B_full = 60)
gd    <- null$gd_ref
am    <- 0.01
bench <- read.csv(book_data("search_benchmark.csv"))
scal  <- read.csv(book_data("search_scaling.csv"))
exg   <- read.csv(book_data("search_exact_gap.csv"))
anyt  <- read.csv(book_data("search_anytime.csv"))
bs    <- unique(bench[, c("scale", "N", "L", "n_sel", "cap")])
rownames(bs) <- bs$scale
# One column of one method at one scale, ordered by seed, so that two methods can
# be differenced seed by seed. The unit of replication in the file is the
# optimiser seed (1 to 3) on ONE simulated dataset per scale.
bv <- function(scale, method, col = "index") {
  x <- bench[bench$scale == scale & bench$method == method, ]
  x[[col]][order(x$seed)]
}
bpair <- function(scale, m1, m2) {            # paired difference over seeds
  d <- bv(scale, m1) - bv(scale, m2)
  c(d = mean(d), se = sd(d) / sqrt(length(d)))
}
bmean <- function(scale, method)
  mean(bench$index[bench$scale == scale & bench$method == method])
bsec <- function(scale, method)
  mean(bench$secs[bench$scale == scale & bench$method == method])
# Rank by mean index WITHIN its own group. Capped rows solve a strictly harder
# problem and are never ranked against uncapped ones.
# A named vector as a two-column table: integer-valued entries without decimals,
# the others at a common number of decimals.
kv <- function(x, digits = 4)
  data.frame(quantity = names(x),
             value = ifelse(x == round(x), sprintf("%d", as.integer(round(x))),
                            formatC(x, format = "f", digits = digits)),
             row.names = NULL)
brank <- function(scale, method) {
  grp <- unique(bench$method[bench$scale == scale])
  grp <- grp[grepl("_cap$", grp) == grepl("_cap$", method)]
  v <- vapply(grp, bmean, numeric(1), scale = scale)
  c(rank = unname(which(names(sort(v, decreasing = TRUE)) == method)),
    n = length(grp))
}

#' 
#' @sec-combinatorial stops at a warm-started differential evolution (DE). That is a
#' reasonable place to stop if the problem is a black box. It is not one. This
#' chapter names the structure, and then spends it: on cheaper moves, on genuine
#' approximation guarantees, on a bound that is actually a bound, and on an oracle
#' that says how far from optimal the heuristics really are.
#' 
#' The target throughout is the scale the method has to survive: **200 hybrids
#' chosen from 10,000**, a full factorial of 100 by 100 lines. That is an ordinary
#' size for a hybrid maize programme at the end of a cycle: two heterotic pools of
#' a hundred inbred or doubled-haploid lines each, every cross between them a
#' legitimate candidate, and a few hundred of them going into the next round of
#' multi-location testing.
#' 
#' That is a different -- and deliberately larger -- "production scale" from the
#' "package production scale" @sec-combinatorial uses to count dimensions: the
#' real dataset this package was written for, 71 + 71 lines and $N = 5041$
#' candidates. (@sec-combinatorial also quotes this chapter's two benchmark scales,
#' by name, and the cached run at $N = 3{,}600$ from 120 lines, which is where its
#' encoding measurement was made.) Here it is the 100 + 100 factorial the
#' scaling study and the head-to-head benchmark are run at, because a cost curve
#' needs a span of $N$ wider than one point provides. They are not
#' interchangeable: every per-evaluation cost and every memory figure in
#' this chapter is at $N = 10{,}000$.
#' 
#' **Scales, replication and provenance.** The names are those of @sec-combinatorial.
#' "Book scale" is the live instance of this chapter: 25 + 25 lines, 2000 markers,
#' simulation seed 1, $N =$ `r ctx$N`, $n =$ `r n_sel` (the teaching scale of
#' @sec-ocs). The rows `book` and `production` of `search_benchmark.csv` are the
#' *benchmark book scale* -- the same $N$, $L$, $n$ and dataset, with the reference
#' `gd_ref` resampled $B = 500$ times against $B = 400$ here, and a per-line cap of
#' `r bs["book", "cap"]` -- and the *benchmark production scale*: $N =$
#' `r format(bs["production", "N"], big.mark = ",")`, $L =$ `r bs["production", "L"]`,
#' $n =$ `r bs["production", "n_sel"]`, cap `r bs["production", "cap"]`. The unit of
#' replication in that file is the optimiser seed (1 to 3) on **one** simulated
#' dataset per scale: the deterministic methods (`greedy`, `greedy_cap`,
#' `ocs_round`, `ocs_round_cap`) return three identical rows, and every capped row
#' has a seed standard deviation of 0 at the benchmark production scale. "Mean of 3
#' seeds" below means that, and a standard error over three seeds is a statement
#' about the optimiser, not about the dataset.
#' 
#' The files read here -- `search_benchmark.csv`, `search_scaling.csv`,
#' `search_anytime.csv`, `search_exact_gap.csv`, `search_anytime.png` and
#' `search_scaling.png` -- are written by `book/scripts/regenerate.R search` (about
#' 15 minutes; the exact oracle by `search_exact`), which `quarto render` never
#' calls. They are reproducible in this repository, unlike the cached external
#' files of @sec-mating; the indices of the deterministic methods reproduce to the
#' digits printed, the timings (`secs`, `us_*`) come from one machine and do not.
#' `sel_exact()` needs the `highs` package and `ocs_quadprog()` the `quadprog`
#' package, both `Suggests` of `hybdiv`.
#' 
#' **The evaluation budget of the differential evolutions.** In the benchmark
#' `sel_de()` and `sel_de_fast()` run `NP` = 100 and `itermax` = 300, that is
#' `r format(unique(bench$evals[bench$method %in% c("de_hybrid", "de_lines")]), big.mark = ",")`
#' nominal evaluations (the `evals` column), against
#' `r format(unique(bench$evals[bench$method == "hill"]), big.mark = ",")` proposed
#' moves for each local search; the anytime curve of @sec-localsearch runs the DE
#' from `r format(min(anyt$evals[anyt$method == "de_hybrid"]), big.mark = ",")` to
#' `r format(max(anyt$evals[anyt$method == "de_hybrid"]), big.mark = ",")`
#' evaluations. Every statement about the DE in this chapter is about those budgets.
#' @sec-combinatorial-budget runs `sel_de()` at four times the first of them and at
#' the printed default of `r format(eval(formals(sel_de)[["NP"]]) * eval(formals(sel_de)[["itermax"]]), big.mark = ",")`
#' evaluations, and finds its mean index above the best fine greedy plan there at the
#' 1% budget, below it at 30,000; this chapter's "DE below greedy" is the 30,000
#' reading and not a property of the method.
#' 
#' **What has to be in hand**, beyond @sec-combinatorial's three objects, is the
#' line-level route: `fast_ctx()` adds `ctx$parents`, the $N \times 2$ matrix of
#' parent indices, to a context that already carries `ctx$fL`, the $L \times L$
#' coancestry *between lines*. Everything in this chapter that scales is a
#' function of those two and of nothing else.
#' 
## -----------------------------------------------------------------------------
#| label: contract
c(candidates_N = ctx$N,
  lines_L      = ctx$n_lines,
  hybrids_kept = n_sel,
  budget_pct   = 100 * am,
  gd_ref       = gd,
  f_MiB        = as.numeric(object.size(ctx[["f"]])) / 2^20,
  fL_MiB       = as.numeric(object.size(ctx$fL)) / 2^20)

#' 
#' The assumptions are @sec-combinatorial's, unchanged and worth restating because
#' two of them are load-bearing here: parent lines are homozygous, which is what
#' makes $f_{ij}$ a function of the four parental coancestries and hence collapses
#' the problem to $L$ dimensions (@sec-collapse); and `f` is molecular coancestry
#' in $[0, 1]$, not a centred relationship matrix, which is what makes it a Gram
#' matrix with the properties @sec-advanced-facts needs.
#' 
#' ## Three facts about this problem {#sec-advanced-facts}
#' 
#' Everything below follows from three properties of the problem, each of which takes
#' three lines to check. The first, the Gram form of `f`, is stated in
#' @sec-sim-assumptions and checked there numerically (and @sec-era-step7 asserts the
#' related form $\mathbf{f} = \tfrac12 + 2\mathbf{Z}\mathbf{Z}^\top/m$, $\mathbf{Z} = \mathbf{X} - \tfrac12$); here it is
#' used for convexity. The second and third, the submatrix sum and the matroid, are
#' stated here for the first time.
#' 
#' ### `f` is a Gram matrix {#sec-advanced-gram}
#' 
#' Molecular coancestry is
#' $f_{ij} = \frac{1}{m}\sum_k [x_{ik}x_{jk} + (1-x_{ik})(1-x_{jk})]$, which is an
#' inner product of the stacked vectors $[\mathbf{x}_i;\, \mathbf{1}-\mathbf{x}_i]$.
#' So `f` is not merely symmetric, it is a **Gram matrix**, exactly:
#' 
## -----------------------------------------------------------------------------
#| label: gram-check
V  <- cbind(ctx[["X"]], 1 - ctx[["X"]])
ev <- eigen(ctx[["f"]], symmetric = TRUE, only.values = TRUE)$values
stopifnot(isTRUE(all.equal(ctx[["f"]], tcrossprod(V) / ctx$m, tolerance = 1e-12)),
          min(ev) > -1e-10 * max(ev))     # positive semi-definite up to rounding
c(max_abs_difference = max(abs(ctx[["f"]] - tcrossprod(V) / ctx$m)),
  min_eigenvalue     = min(ev),
  min_over_max_eig   = min(ev) / max(ev))

#' 
#' The check is the whole argument, and the chunk asserts it: the difference is
#' zero to rounding, and the smallest eigenvalue is zero to the eigensolver's own
#' rounding -- its sign is arbitrary, `r round(-log10(abs(min(ev) / max(ev))))`
#' orders of magnitude below the largest eigenvalue. A negative eigenvalue large enough to see on that scale
#' would mean `f` had been centred, rescaled, or built on the wrong marker
#' coding -- and every method in this chapter would silently lose its
#' justification.
#' 
#' Two consequences carry the rest of the chapter. First, $\mathbf{c}'\mathbf{f}\mathbf{c}$
#' is a **convex** quadratic, so the diversity budget is a convex constraint --
#' which is what makes the exact method of @sec-oa possible at all. Second,
#' $\psi_{ij} = f_{ii} + f_{jj} - 2f_{ij}$ (not the distance $1 - f_{ij}$ of E-NE and A-NE,
#' @sec-notation) is a squared Euclidean distance, hence a
#' distance of **negative type**, which is the precise hypothesis the strongest
#' approximation results require.
#' 
#' ### Maximising diversity is minimising the submatrix sum
#' 
#' $\theta_S = \frac{1}{n^2}\sum_{i,j \in S} f_{ij}$ (@eq-catalogue-theta;
#' @cockerham1967), and at fixed $n$ the normaliser is a constant:
#' 
## -----------------------------------------------------------------------------
#| label: submatrix-sum
s <- sel_greedy(ctx, n_sel, w = 1)
stopifnot(isTRUE(all.equal(theta_group(s, ctx) * n_sel^2, sum(ctx[["f"]][s, s]),
                           tolerance = 1e-12)))
# the max-sum identity of @eq-advanced-maxsum, below
fS  <- ctx[["f"]][s, s]
psi <- outer(diag(fS), diag(fS), "+") - 2 * fS
stopifnot(isTRUE(all.equal(sum(psi[upper.tri(psi)]),
                           n_sel * sum(diag(fS)) - n_sel^2 * theta_group(s, ctx),
                           tolerance = 1e-12)))
c(theta_times_n2 = theta_group(s, ctx) * n_sel^2,
  submatrix_sum  = sum(ctx[["f"]][s, s]),
  difference     = theta_group(s, ctx) * n_sel^2 - sum(ctx[["f"]][s, s]))

#' 
#' So the objective of the greedy score of @sec-combinatorial, $\omega\,\bar u_S - \theta_S$,
#' is, up to the positive constant $n^{-2}$, $n\omega \sum_{i \in S} u_i -
#' \sum_{i,j \in S} f_{ij}$. Here $u_i$ is the index of hybrid $i$ (index
#' standard deviations), $S$ a set of $n$ hybrids, $\bar u_S$ its mean, and
#' $\omega \ge 0$ the index weight of @sec-notation, in units of group coancestry
#' per index standard deviation. The first term is **modular**; the second is
#' **submodular**, because $f_{ij} \ge 0$ makes the marginal cost of adding a
#' hybrid, $f_{ii} + 2\sum_{j \in S} f_{ij}$, grow with the set. Writing the same thing through $\psi_{ij}$,
#' 
#' $$\sum_{i<j \in S} \psi_{ij} \;=\; n\,\mathrm{tr}(\mathbf{f}_S) - n^2\theta_S,$$ {#eq-advanced-maxsum}
#' 
#' with $\mathbf{f}_S$ the $n \times n$ submatrix of $\mathbf{f}$ on $S$ and
#' $\mathrm{tr}(\mathbf{f}_S) = \sum_{i \in S} f_{ii}$ (an identity of the definitions,
#' asserted in the chunk above), identifies it as the
#' **max-sum diversification** problem of @borodin2017. I have not found it named
#' that way in the plant-breeding literature, and this book makes no claim about
#' what a systematic screen would find -- no such screen was run. The structural
#' identity is the load-bearing part, and it holds whether or not anyone has
#' written it down before.
#' 
#' The practical content of "fixed $n$" is worth spelling out: it is *only* at a
#' fixed set size that maximising gene diversity and minimising the submatrix sum
#' are the same instruction. Comparing $\theta$ across selections of different
#' sizes compares two different things, which is the same reason `gd_ref` has to
#' be resampled at the size actually being used (@sec-baseline).
#' 
#' ### The per-line cap is a partition matroid
#' 
#' "No line may parent more than `max_use` of the selected hybrids" is one
#' partition matroid per heterotic pool. Together with the cardinality constraint
#' that is an intersection of matroids -- not an arbitrary combinatorial
#' restriction, but the single best-understood constraint class in discrete
#' optimisation.
#' 
#' The structure comes from the mating design, not from the mathematics. Every
#' candidate is a cross between one pool-A line and one pool-B line, so each
#' selected hybrid contributes exactly one use to a pool-A line and one to a
#' pool-B line, and the counts within each pool sum to $n$ by construction:
#' 
## -----------------------------------------------------------------------------
#| label: matroid-check
cnt <- line_counts(s, ctx)
stopifnot(sum(cnt[ctx$pool == "A"]) == n_sel, sum(cnt[ctx$pool == "B"]) == n_sel)
c(uses_pool_A     = sum(cnt[ctx$pool == "A"]),
  uses_pool_B     = sum(cnt[ctx$pool == "B"]),
  n_sel           = n_sel,
  distinct_A_used = sum(cnt[ctx$pool == "A"] > 0),
  distinct_B_used = sum(cnt[ctx$pool == "B"] > 0))

#' 
#' That is exactly the ground-set partition a partition matroid needs. It also
#' gives the feasibility condition for any cap $k_{\max}$ (the per-line cap of
#' @sec-combinatorial, `max_use` in the code) directly: a plan of $n$ crosses
#' exists under the cap only if $n \le L_A k_{\max}$ and $n \le L_B k_{\max}$, with $L_A$
#' and $L_B$ the numbers of lines in the two pools. In a programme the
#' cap is rarely chosen for theoretical reasons -- it is set by how many
#' seed-production fields a female line can support -- and the point of naming the
#' structure is that a constraint arriving from the field turns out to be the one
#' class of constraint discrete optimisation handles best.
#' 
#' ::: {.callout-note}
#' ## Why naming the structure is worth a section
#' 
#' Three named properties buy three concrete things (@tbl-advanced-structure), and it is
#' worth being blunt about which is which.
#' 
#' | Property | What it buys | Worth in practice |
#' |---|---|---|
#' | `f` positive semi-definite | a convex constraint, hence valid gradient cuts and a valid Lagrangian bound | **large** -- @sec-bound is a correction, not an ornament |
#' | submodular plus modular objective | $1 - 1/e$ under cardinality [@nemhauser1978], $1/(p+1)$ under $p$ matroids [@fisher1978]; a polynomial-time approximation scheme (PTAS) for negative-type distances under a matroid [@cevallos2016] | **small** -- worst-case bounds, and the measured gap to the bound is `r fmt(mean(bench$gap_pct[bench$scale == "book" & bench$method %in% c("hill", "anneal")]), 1)`% for the hill climber and the annealing at the benchmark book scale (`r fmt(mean(bench$gap_pct[bench$scale == "book" & bench$method == "tempering"]), 1)`% for tempering) |
#' | line collapse $\theta = \mathbf{w}'\mathbf{f}^L\mathbf{w}$ | memory $O(N^2) \to O(L^2)$, an $O(L)$ swap, and an $L$-dimensional contributions programme in place of an $N$-dimensional one | **large** -- `r fmt(scal$f_GB[scal$N == 10000], 3)` GiB against `r fmt(8 * bs["production", "L"]^2 / 2^20, 1)` MiB, and the swap is what makes local search affordable |
#' 
#' : What each named property of the problem buys and what it is worth in practice. {#tbl-advanced-structure}
#' :::
#' 
#' ## What lazy greedy would not buy
#' 
#' The obvious first move on a submodular objective is the accelerated, or "lazy",
#' greedy of @minoux1978: keep stale marginal gains in a priority queue and
#' re-evaluate only the top one, which is valid precisely because submodularity
#' makes a stale gain an upper bound on the current one. Two distinct results are
#' easy to conflate here, so name them apart: the acceleration is Minoux's, while
#' the worst-case guarantee for the plain greedy it accelerates is @nemhauser1978's
#' and is quoted separately below. It is the standard accelerator for this
#' objective class, and here it is **worthless**.
#' 
#' `sel_greedy()` already carries the running vector `s` of coancestry sums
#' against the chosen set, so every candidate's marginal gain is $O(1)$ and the
#' whole step is one vectorised pass. Lazy evaluation optimises precisely the cost
#' that is already free. Reaching for it would add a heap, add bugs, and save
#' nothing.
#' 
#' The guarantee is worth stating even so, because it settles a question rather
#' than improving a number: greedy under our constraints cannot do worse than
#' $1/(p+1)$ of optimal, with $p$ the number of matroids intersected -- here the
#' cardinality constraint plus one partition matroid per pool.
#' 
#' State it with its hypotheses, though, because they are not all met. The
#' $1 - 1/e$ and $1/(p+1)$ results of @nemhauser1978 and @fisher1978 are proved
#' for **monotone, non-negative** submodular functions. Our objective is neither
#' in general: the index is standardised to mean zero over the candidate pool, so
#' $\bar u_S$ can be negative, and adding a hybrid increases the coancestry term,
#' so the objective is monotone only where the merit term dominates. The guarantee
#' therefore belongs in this chapter as a statement about the *constraint class* --
#' the cap is not an arbitrary restriction -- and not as a guarantee for any
#' particular run. The bound this chapter actually uses is the Lagrangian
#' bound of @sec-bound, and @sec-oa measures what the local search does in fact achieve.
#' 
#' ## The move that was already paid for {#sec-localsearch}
#' 
#' @sec-collapse established $\theta_S = \mathbf{w}'\mathbf{f}^L\mathbf{w}$ (@eq-collapse-theta), and
#' `theta_state()`/`theta_swap()` have been in the package ever since, maintaining
#' group coancestry in $O(L)$ per swap. Nothing consumed them. @sec-combinatorial
#' even ends with a callout recommending local search, citing @debeukelaer2018 --
#' and then does not run one.
#' 
## -----------------------------------------------------------------------------
theta_swap

#' 
#' Four rank-one column updates. No `N x N` matrix is touched, and the cost
#' depends on neither $N$ nor $m$. The state it maintains is three objects: the
#' line-count vector `cnt`, the product `v = fL %*% cnt`, and their inner product
#' divided by $s^2$, which is $\theta$. Removing a hybrid subtracts the two
#' columns of `fL` belonging to its parents; adding one adds the two columns of
#' the entrant's parents. Because a swap keeps the set size fixed, the normaliser
#' $s = 2n$ never changes.
#' 
#' It is an exact update, not an approximation, and that is checkable in three
#' lines:
#' 
## -----------------------------------------------------------------------------
#| label: swap-identity
st    <- theta_state(s, ctx)
out_h <- s[1]
in_h  <- setdiff(seq_len(ctx$N), s)[1]
st2   <- theta_swap(st, out_h, in_h, ctx)
after <- c(setdiff(s, out_h), in_h)
stopifnot(isTRUE(all.equal(st2$theta, theta_group(after, ctx))),
          isTRUE(all.equal((2 * n_sel)^2 / sum(st2$cnt^2), ne_parents(after, ctx))))
c(incremental = st2$theta, recomputed = theta_group(after, ctx))

#' 
#' If that identity ever fails, the state and the selection have drifted apart --
#' the usual cause being a move that was accepted in the selection vector but not
#' applied to the state, or the reverse.
#' 
#' That last property is the one that matters, and it is worth being precise about
#' where the saving actually comes from, because the obvious answer is wrong. The
#' line *encoding* does not make an evaluation cheaper. Taking two rows of
#' @tbl-advanced-scaling, in @tbl-advanced-eval-cost:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-eval-cost
#| echo: false
#| tbl-cap: "Cost of one objective evaluation, in microseconds, by route at two sizes of the candidate set (rows of @tbl-advanced-scaling; one machine)."
cols_ec <- c("us_hybrid", "us_lines", "us_decode", "us_swap")
ec <- rbind(`N = 3,600` = unlist(scal[scal$N == 3600, cols_ec]),
            `N = 10,000` = unlist(scal[scal$N == 10000, cols_ec]))
# the values the prose of this section and of the closing summary quote
stopifnot(identical(unname(round(ec[1, ])), c(40, 83, 77, 3)),
          identical(unname(round(ec[2, ])), c(132, 169, 159, 4)),
          round(ec[1, "us_swap"], 1) == 3.3, round(ec[2, "us_swap"], 1) == 4.2)
knitr::kable(fmt(data.frame(
  route = c("hybrid encoding, `mean(f[idx, idx])`", "line encoding, full fitness",
            "of which `decode_lines()`, which sorts all $N$ candidates",
            "incremental swap, no decode at all"),
  `N = 3,600` = unname(ec[1, ]), `N = 10,000` = unname(ec[2, ]),
  check.names = FALSE), 1), row.names = FALSE)

#' 
#' The line encoding is *slower* per evaluation, because decoding a weight vector
#' into a selection has to rank every candidate. What it buys is a smaller search
#' space, not a cheaper objective. The order-of-magnitude saving belongs to the
#' swap -- and the swap is available only to a method that moves in the space of
#' selections rather than decoding one from scratch each time.
#' 
## -----------------------------------------------------------------------------
args(sel_local_search)

#' 
#' Three modes, one driver, differing only in the temperature schedule. The driver
#' does the following, and each step is a decision a breeder can inspect:
#' 
#' 1. **Start from a plan, never from noise.** `start = NULL` builds a warm start:
#'    capped truncation, plus the greedy sweep whenever an $N \times N$ `f` is
#'    present (the test is that `ctx[["f"]]` is a matrix with $N$ rows), and it is worth
#'    being accurate about which branch produced the numbers in this chapter: the
#'    production benchmark of @sec-scaling deliberately forms the `r fmt(scal$f_GB[scal$N == 10000], 3)` GiB matrix
#'    so that the routes needing it can be timed at all, so **its rows took the
#'    greedy branch**. Among the candidates it takes the highest-index one that
#'    *meets the budget*, and if none does, the one with the smallest loss. As in
#'    `sel_de()`, `NULL` never means "start cold".
#' 
#'    The greedy branch is guarded, but the ranking that follows it is not: the
#'    warm start scores every candidate with `alpha_loss()`, which reads
#'    `ctx[["f"]]`. So `start = NULL` needs the $N \times N$ matrix whichever branch
#'    it takes, and on a context built without one it stops with the message
#'    `ctx[["f"]] (hybrid coancestry) is missing`, as @tbl-advanced-ffree
#'    shows. Supplying an explicit `start =` skips the whole
#'    function, and from there the search is `fL`-only; that is the call to make
#'    if `f` does not fit in memory, and @sec-ffree is where the two are run side
#'    by side.
#' 2. **Build the state.** `theta_state()` on the starting selection, plus the
#'    running index sum and a logical membership vector, so that every later
#'    question is $O(1)$ or $O(L)$.
#' 3. **Calibrate the temperature.** With `t0 = NULL` and a stochastic mode, the
#'    driver proposes up to 200 random swaps, records the median absolute change
#'    in the objective, and uses that as the starting temperature. Nothing about
#'    the scale of the index is assumed, so the same call transfers between
#'    datasets. `mode = "hill"` skips this entirely, since it never accepts a
#'    worsening move.
#' 4. **Propose a feasible move.** Pick one of the $n$ selected crosses at random
#'    to leave; draw entrants at random until one is found whose parents stay
#'    under `max_use` once the leaving cross is removed, giving up after 20
#'    attempts. The cap is tested, never punished.
#' 5. **Score it in $O(L)$.** `theta_swap()` for the new $\theta$, one addition
#'    and one subtraction for the new index sum, and the objective is
#'    $\bar u_S$ minus `penalty` times the budget violation *expressed in units of
#'    the budget itself* -- the violation is divided by `alpha_max`, so a 5
#'    becomes an effective slope of 500 index standard deviations per unit of
#'    relative loss at a 1% budget, and 5000 at 0.1%. The tighter the budget, the
#'    harder a violation is punished, which is the behaviour you want and is not
#'    what `make_fitness()`'s fixed multiplier of 1000 on the *absolute* violation
#'    does.
#' 6. **Accept or reject.** Improving moves are always accepted; worsening ones
#'    with probability $\exp(\Delta / t_k)$ at the current temperature. The
#'    best-ever selection is tracked separately from the current one and is what
#'    is returned -- so a chain that wanders away at high temperature loses
#'    nothing.
#' 
#' Two design points are worth stopping on.
#' 
#' **The cap is tested, not punished.** Whether a swap keeps every line under
#' `max_use` is an $O(1)$ question given the count vector, so infeasible moves are
#' never proposed. Penalising them instead spends the evaluation budget on being
#' rejected -- with a tight cap that was the difference between the search
#' improving on its warm start and not moving at all.
#' 
#' **The temperature calibrates itself.** A constant would not transfer between
#' datasets, so `t0 = NULL` samples the median absolute objective change over a
#' short burn-in and uses that.
#' 
#' One run of each is not a comparison. Twenty seeds (1 to 20) of each mode, at
#' 20,000 and at 30,000 proposed moves -- 30,000 is the budget of the benchmark of @tbl-advanced-benchmark-book.
#' The seeds are the same at both budgets but the draws are not, because the number
#' of moves differs; `sel_local_search()` sets the seed itself, immediately before its
#' own draws. @tbl-advanced-ls-modes gives the indices and the paired differences, and
#' @tbl-advanced-ls-realised the realised loss, $N_{e,\text{par}}$ and largest line use
#' of each mode at 20,000 moves.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-ls-modes
#| tbl-cap: "Twenty seeds (1 to 20) of each local-search mode on the live book-scale instance of this chapter, 1% budget, at 20,000 and 30,000 proposed moves. Rows hill, anneal, tempering: mean index (standard deviations of the candidate pool); sd_hill, sd_anneal, sd_tempering: their seed standard deviations; hill_minus_anneal_e3 and se_e3: mean and standard error of the paired difference hill minus anneal, in thousandths of an index unit; hill_ahead: seeds out of 20 in which hill exceeds anneal; tempering_below_both: seeds out of 20 in which tempering is below both other modes; first3_hill_minus_anneal_e3: the paired difference over seeds 1 to 3 only."
modes <- c("hill", "anneal", "tempering")
ls_run <- function(iters)
  do.call(rbind, lapply(1:20, function(sd_) do.call(rbind, lapply(modes, function(m) {
    s <- sel_local_search(ctx, n_sel, am, gd, mode = m, iters = iters, seed = sd_)
    data.frame(seed = sd_, mode = m, index = mean_index(s, ctx),
               alpha_pct = 100 * alpha_loss(s, ctx, gd),
               Ne_par = ne_parents(s, ctx), max_line = max_line_use(s, ctx))
  }))))
ls_raw <- lapply(c(`20000` = 20000, `30000` = 30000), ls_run)
ix <- function(d, m) d[["index"]][d[["mode"]] == m]          # ordered by seed
ls_tab <- do.call(rbind, lapply(names(ls_raw), function(k) {
  d  <- ls_raw[[k]]
  dh <- ix(d, "hill") - ix(d, "anneal")                      # paired over seeds
  data.frame(moves = as.integer(k),
             hill = mean(ix(d, "hill")), anneal = mean(ix(d, "anneal")),
             tempering = mean(ix(d, "tempering")),
             sd_hill = sd(ix(d, "hill")), sd_anneal = sd(ix(d, "anneal")),
             sd_tempering = sd(ix(d, "tempering")),
             hill_minus_anneal_e3 = 1000 * mean(dh),
             se_e3 = 1000 * sd(dh) / sqrt(length(dh)),
             hill_ahead = sum(dh > 0),
             tempering_below_both =
               sum(ix(d, "tempering") < pmin(ix(d, "hill"), ix(d, "anneal"))),
             first3_hill_minus_anneal_e3 = 1000 * mean(dh[1:3]))
}))
lt <- t(ls_tab[-1])                       # quantities in rows, budgets in columns
lt <- data.frame(quantity = rownames(lt), apply(lt, 2, function(v) kv(v)[["value"]]),
                 check.names = FALSE)
names(lt)[-1] <- paste(ls_tab[["moves"]], "moves")
knitr::kable(lt, row.names = FALSE, align = "lrr")

#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-ls-realised
#| tbl-cap: "Realised diversity loss (alpha_pct, percent; the budget is 1%), N_e,par and largest line use by local-search mode at 20,000 proposed moves: mean over seeds 1 to 20 for the first two, maximum over the seeds for max_line."
d20 <- ls_raw[["20000"]]
knitr::kable(fmt(do.call(rbind, lapply(modes, function(m) {
  d <- d20[d20[["mode"]] == m, ]
  data.frame(mode = m, alpha_pct = mean(d[["alpha_pct"]]),
             Ne_par = mean(d[["Ne_par"]]), max_line = max(d[["max_line"]]))
})), 3), row.names = FALSE)

#' 
#' Note that `iters` is the total number of proposed moves *summed over chains*, so
#' the three modes cost about the same wall-clock at equal `iters`: at the benchmark
#' book scale their mean times are
#' `r fmt(min(tapply(bench$secs[bench$scale == "book" & bench$method %in% modes], bench$method[bench$scale == "book" & bench$method %in% modes], mean)), 3)`
#' to
#' `r fmt(max(tapply(bench$secs[bench$scale == "book" & bench$method %in% modes], bench$method[bench$scale == "book" & bench$method %in% modes], mean)), 3)`
#' seconds for 30,000 moves. In tempering mode those moves are split across
#' `n_chains` replicas on a geometric temperature ladder spanning three decades,
#' exchanging adjacent rungs every `swap_every` moves.
#' 
#' The realised `alpha` of @tbl-advanced-ls-realised sits against the 1% budget in every
#' mode: the constraint is binding, and the search is spending the diversity it was
#' allowed.
#' 
#' Three checks before a plan from this function is used, in this order: realised
#' $\alpha$ against the budget (a plan far inside it means the search never
#' reached the boundary, or the penalty was too steep); `max_line` against the cap
#' you set; and $N_{e,\text{par}}$, which is free and catches the case where
#' $\theta$ is satisfied by a handful of lines used many times each.
#' 
#' Result. At 20,000 moves the mean indices are
#' `r fmt(ls_tab[["hill"]][1], 4)` (hill), `r fmt(ls_tab[["anneal"]][1], 4)` (anneal)
#' and `r fmt(ls_tab[["tempering"]][1], 4)` (tempering), with seed standard
#' deviations of `r fmt(ls_tab[["sd_hill"]][1], 4)`, `r fmt(ls_tab[["sd_anneal"]][1], 4)`
#' and `r fmt(ls_tab[["sd_tempering"]][1], 4)`; at 30,000 moves
#' `r fmt(ls_tab[["hill"]][2], 4)`, `r fmt(ls_tab[["anneal"]][2], 4)` and
#' `r fmt(ls_tab[["tempering"]][2], 4)`. Hill minus anneal, paired over the 20 seeds,
#' is `r fmt(ls_tab[["hill_minus_anneal_e3"]][1], 2)` thousandths of an index unit
#' (standard error, s.e. `r fmt(ls_tab[["se_e3"]][1], 2)`; hill ahead in `r ls_tab[["hill_ahead"]][1]` of 20
#' seeds) at 20,000 moves and `r fmt(ls_tab[["hill_minus_anneal_e3"]][2], 2)`
#' (s.e. `r fmt(ls_tab[["se_e3"]][2], 2)`; hill ahead in `r ls_tab[["hill_ahead"]][2]` of 20) at 30,000.
#' Tempering is below both in `r ls_tab[["tempering_below_both"]][1]` of 20 seeds at
#' 20,000 moves and in `r ls_tab[["tempering_below_both"]][2]` of 20 at 30,000. Seeds 1 to 3 alone,
#' the three-seed comparison an earlier version of this chapter read, give
#' `r fmt(ls_tab[["first3_hill_minus_anneal_e3"]][1], 1)` thousandths at 20,000 moves; the other
#' seeds do not repeat it.
#' 
#' Interpretation, and what limits it. Neither paired difference between hill and
#' anneal is as large as two standard errors, and the two have opposite signs, so
#' this run does not separate the two schedules at either budget; it also does not
#' show that they are equal -- a standard error of about one thousandth bounds what
#' 20 seeds on one dataset can resolve. A change of sign between the budgets is
#' therefore not evidence of an ordering that depends on the budget. Tempering's
#' shortfall is resolved at both budgets (below both in every seed). A candidate
#' cause is the splitting of a fixed move budget across the replicas; that was not
#' tested (no run at a larger budget, and `n_chains` and the ladder were not varied),
#' so the shortfall is a measurement of this implementation at its default settings, on
#' `r ctx$N` candidates, and not of parallel tempering. What this panel supports is
#' that at a fixed move budget the schedule is a second-order choice (the three modes
#' differ by at most
#' `r fmt(100 * max(apply(ls_tab[, c("hill", "anneal", "tempering")], 1, function(v) diff(range(v))) / apply(ls_tab[, c("hill", "anneal", "tempering")], 1, max)), 1)`%
#' of the index, and the spread is tempering's). One dataset, one simulation seed:
#' a different dataset is not measured.
#' 
#' ### Against the differential evolution, at equal wall-clock {#sec-advanced-lsvsde}
#' 
## -----------------------------------------------------------------------------
#| label: cost-per-move
#| include: false
us_de <- 1e6 * mean(bench$secs[bench$scale == "book" & bench$method == "de_hybrid"] /
                    bench$evals[bench$scale == "book" & bench$method == "de_hybrid"])
us_ls <- 1e6 * mean(bench$secs[bench$scale == "book" & bench$method == "hill"] /
                    bench$evals[bench$scale == "book" & bench$method == "hill"])

#' 
#' Equal *evaluations* is the wrong comparison when one evaluation costs several
#' times what another does. At the benchmark book scale a nominal DE evaluation costs
#' `r fmt(us_de, 0)` microseconds (seconds divided by evaluations, `de_hybrid`, which
#' includes `DEoptim`'s own overhead) and a local-search move `r fmt(us_ls, 1)`
#' (`hill`, which includes the driver's), a ratio of `r fmt(us_de / us_ls, 1)`; and
#' the hybrid-encoding fitness costs
#' `r fmt(scal$us_hybrid[scal$N == 3600] / scal$us_swap[scal$N == 3600], 0)` and
#' `r fmt(scal$us_hybrid[scal$N == 10000] / scal$us_swap[scal$N == 10000], 0)` times the
#' swap at $N = 3{,}600$ and $10{,}000$ (@sec-scaling). The honest axis is seconds (@fig-advanced-anytime).
#' 
## -----------------------------------------------------------------------------
#| label: fig-advanced-anytime
#| echo: false
#| fig-cap: "Best index reached (in standard deviations of the candidate pool) against wall-clock seconds on a log axis, at the benchmark book scale (N = 625, n = 60) under a 1% diversity budget. Coloured curves: the best-so-far index along one run of each local-search mode (seed 1, 60,000 moves). Grey circles: independent differential-evolution runs of 100 members and 20 to 800 generations (2,000 to 80,000 evaluations), one per budget and joined by a line; they are drawn as the running maximum over increasing budgets, so a run that ended below a cheaper one is drawn at the cheaper run's value. Dashed line: the Lagrangian bound of @sec-bound. One run per arm: no dispersion is shown. The vertical axis of the image is labelled 'mean index (s.d.)': it is the index in standard deviations of the candidate pool, not a dispersion."
#| fig-alt: "Line chart, log time axis from 0.002 to 2 seconds, index from 0.9 to 1.55. Three local-search curves (hill, anneal, tempering) rise steeply and flatten near 1.52 within half a second; hill starts highest, near 1.32. Six grey differential-evolution points run from about 1.14 at 0.07 seconds to about 1.45 at 2 seconds, below the local-search curves at the same times. A dashed horizontal line, the Lagrangian bound, lies near 1.55 above everything."
knitr::include_graphics(book_fig("search_anytime.png"))

#' 
## -----------------------------------------------------------------------------
#| label: anytime-numbers
#| include: false
first_at <- function(m, thr = 1.52) min(anyt$secs[anyt$method == m & anyt$best >= thr])
de_any <- anyt[anyt$method == "de_hybrid", ]
de_last <- de_any[which.max(de_any$evals), ]
# Best index of a local-search mode by the time of each DE point (the claim below).
ls_at <- function(m, s) max(anyt$best[anyt$method == m & anyt$secs <= s])
stopifnot(all(vapply(modes, function(m)
  all(vapply(de_any$secs, function(s) ls_at(m, s), numeric(1)) > de_any$best),
  logical(1))))

#' 
#' Result. In that single run per mode the local searches first reach an index of
#' 1.52 after `r fmt(first_at("hill"), 2)` s (hill), `r fmt(first_at("anneal"), 2)` s
#' (anneal) and `r fmt(first_at("tempering"), 2)` s (tempering); the best DE point
#' is `r fmt(max(de_any$best), 3)` after `r fmt(de_last$secs, 1)` s and
#' `r format(de_last$evals, big.mark = ",")` evaluations. Interpretation, and what limits
#' it: at the evaluation budgets of the figure each local-search mode is ahead of the DE
#' at the wall-clock time of each of the six DE points (asserted in the chunk). The figure has one run per arm, so
#' it carries no dispersion; the dispersion is in @tbl-advanced-benchmark-book.
#' 
## -----------------------------------------------------------------------------
#| label: greedy-grids-here
#| include: false
# The best feasible greedy plan on the benchmark grid (20 values, the greedy row
# of the table below) and on the 60-value grid of @sec-combinatorial, both against
# this chapter's gd_ref (B = 400).
best_greedy <- function(ws) {
  pl <- lapply(ws, function(w) sel_greedy(ctx, n_sel, w = w))
  a  <- vapply(pl, alpha_loss, numeric(1), ctx = ctx, gd_ref = gd)
  max(vapply(pl[a <= am], mean_index, numeric(1), ctx = ctx))
}
g_bench <- best_greedy(c(0, 10^seq(-5, 1, length.out = 19)))
g_fine  <- best_greedy(10^seq(-6, -1, length.out = 60))
stopifnot(isTRUE(all.equal(g_bench, bmean("book", "greedy"))))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-benchmark-book
#| echo: false
#| tbl-cap: "Benchmark book scale, 1% diversity budget: mean over the optimiser seeds 1 to 3 on one simulated dataset (`index sd` is their standard deviation; the deterministic rows greedy, greedy_cap, ocs_round and ocs_round_cap are three identical runs, so their standard deviation is 0 by construction). The gap is against the Lagrangian bound of @sec-bound, which converged by its stalling criterion at this scale; for the capped rows the bound carries no cap, so their gap includes the price of the cap."
b <- bench[bench$scale == "book", ]
agg <- aggregate(cbind(index, alpha, Ne_parents, max_line, secs, gap_pct) ~ method,
                 b, mean)
agg$index_sd <- aggregate(index ~ method, b, sd)[["index"]][
  match(agg$method, aggregate(index ~ method, b, sd)[["method"]])]
agg$alpha <- 100 * agg$alpha
agg <- agg[, c("method", "index", "index_sd", "alpha", "Ne_parents", "max_line",
               "secs", "gap_pct")]
names(agg) <- c("method", "index", "index sd", "loss %", "Ne parents", "max uses",
                "seconds", "gap to bound %")
g_row   <- agg[agg[["method"]] == "greedy", ]
top_row <- agg[which.max(agg[["index"]]), ]
knitr::kable(agg[order(-agg$index), ], digits = 3, row.names = FALSE)

#' 
#' Read @tbl-advanced-benchmark-book by columns rather than by rank. `index` orders the methods;
#' `loss %` says which of them actually spent the budget; `max uses` says which
#' were capped, since the capped variants are solving a strictly harder problem
#' and must not be compared with the uncapped ones on index alone; `seconds` is
#' the axis the ranking is conditional on; and, among the uncapped rows, `gap to
#' bound %` is the only column that says whether the leader is near optimal or merely
#' ahead of the others. The greedy row is the one to keep in view. On the benchmark
#' grid of 20 values of the index weight $\omega$ (`c(0, 10^seq(-5, 1, length.out = 19))`) it
#' reaches index `r fmt(g_row[["index"]], 3)` in `r round(1000 * g_row[["seconds"]])` ms,
#' which is `r fmt(100 * (1 - g_row[["index"]] / top_row[["index"]]), 1)`% below the
#' leading method (`r top_row[["method"]]`) at about
#' `r round(top_row[["seconds"]] / g_row[["seconds"]])`x less wall-clock. On the finer
#' 60-value grid of @sec-combinatorial (`10^seq(-6, -1, length.out = 60)`) the best
#' feasible greedy plan against the same `gd_ref` reaches `r fmt(g_fine, 4)`, which is
#' `r fmt(100 * (1 - g_fine / top_row[["index"]]), 1)`% below the leader: the two
#' greedy numbers of this book at one budget and scale differ by the grid, and the
#' percentage depends on which is used. Whether the remaining shortfall is worth
#' `r fmt(top_row[["seconds"]], 2)` seconds is a question about the programme, not
#' about the algorithm. At the benchmark production scale the cost ratio is not the
#' book-scale one: the mean times are
#' `r fmt(bsec("production", "greedy"), 3)` s for the greedy sweep and
#' `r fmt(bsec("production", "hill"), 3)` s for `hill`, a ratio of
#' `r fmt(bsec("production", "hill") / bsec("production", "greedy"), 1)`, while the
#' greedy index is
#' `r fmt(100 * (1 - bmean("production", "greedy") / bmean("production", "hill")), 0)`%
#' below `hill`'s (`r fmt(bmean("production", "greedy"), 3)` against
#' `r fmt(bmean("production", "hill"), 3)`) there, so the economy of the greedy sweep
#' is a book-scale property of this file and not a production one.
#' 
#' The same file lets the local searches be set against the two differential
#' evolutions, with the replication it has: three optimiser seeds on one dataset per
#' scale, so a standard error below is over seeds and says nothing about the dataset
#' (@tbl-advanced-ls-vs-de).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-ls-vs-de
#| tbl-cap: "Local searches against the two differential evolutions, at the two benchmark scales, from the cached benchmark (optimiser seeds 1 to 3, one dataset per scale). schedule_spread: range of the mean index over the three local-search schedules; max_seed_sd: largest within-schedule seed standard deviation; hill_minus_de_hybrid and hill_minus_de_lines: mean paired difference in index (standard deviations of the pool) between hill and sel_de() or sel_de_fast(), with standard errors se_* over the three seeds."
sp <- do.call(rbind, lapply(c("book", "production"), function(sc) {
  d  <- bench[bench$scale == sc & bench$method %in% modes, ]
  pa <- bpair(sc, "hill", "de_hybrid"); pb <- bpair(sc, "hill", "de_lines")
  data.frame(scale = sc,
             schedule_spread = diff(range(tapply(d$index, d$method, mean))),
             max_seed_sd = max(tapply(d$index, d$method, sd)),
             hill_minus_de_hybrid = pa[["d"]], se_hybrid = pa[["se"]],
             hill_minus_de_lines = pb[["d"]], se_lines = pb[["se"]])
}))
stopifnot(all(vapply(c("book", "production"), function(sc)         # the wall-clock claim
  max(vapply(modes, bsec, numeric(1), scale = sc)) <
    min(vapply(c("de_hybrid", "de_lines"), bsec, numeric(1), scale = sc)), logical(1))))
knitr::kable(fmt(sp, 4), row.names = FALSE)

#' 
#' Result. Both differential evolutions are run at
#' `r format(unique(bench$evals[bench$method == "de_hybrid"]), big.mark = ",")`
#' nominal evaluations (`NP` = 100, `itermax` = 300), the local searches at the same
#' number of proposed moves. `hill` is ahead of `sel_de()` by
#' `r fmt(sp[["hill_minus_de_hybrid"]][1], 3)` index units (s.e.
#' `r fmt(sp[["se_hybrid"]][1], 3)`) at the benchmark book scale and by
#' `r fmt(sp[["hill_minus_de_hybrid"]][2], 3)` (s.e. `r fmt(sp[["se_hybrid"]][2], 3)`) at the
#' benchmark production scale, and ahead of the line-encoded `sel_de_fast()` by
#' `r fmt(sp[["hill_minus_de_lines"]][1], 3)` and `r fmt(sp[["hill_minus_de_lines"]][2], 3)`.
#' The three local-search schedules span `r fmt(sp[["schedule_spread"]][1], 3)` and
#' `r fmt(sp[["schedule_spread"]][2], 3)` at the two scales, with a within-mode seed
#' standard deviation of at most `r fmt(max(sp[["max_seed_sd"]]), 4)`. Each local
#' search also takes less wall-clock than either DE at both scales (asserted in the
#' chunk; the `seconds` columns of @tbl-advanced-benchmark-book and
#' @tbl-advanced-benchmark-production give the seconds).
#' 
#' Interpretation, and what limits it. At these budgets the swap-based local search
#' reaches a higher index than both DE in less time, by a margin larger than the
#' spread among its own schedules. That is a comparison of whole algorithms: a swap
#' neighbourhood with an annealing or hill-climbing acceptance rule and a warm start
#' from the greedy sweep against `DEoptim`'s operators on a decoded vector, with a
#' different warm start. No arm runs the same search on the other neighbourhood, so
#' the comparison does not isolate the neighbourhood from the rest of the algorithm;
#' what the cost argument above supports is the mechanism for *time* (a swap is
#' $O(L)$, a decode sorts $N$ candidates), not for index. Two further limits. The DE
#' arms are at 30,000 evaluations, where @sec-combinatorial-budget finds `sel_de()`
#' below the best fine greedy plan (`r fmt(g_fine, 3)` here) and above it at four
#' times that budget and at its printed default: the DE results of this chapter are not
#' results about `sel_de()` at its default. And the local search was not rerun against
#' the DE at those larger budgets, so whether the ordering of the figure persists
#' there is not measured here; the wall-clock of the DE rises with the budget
#' (@tbl-combinatorial-budget).
#' 
#' ::: {.callout-note}
#' ## What the literature says about picking a metaheuristic
#' 
#' @debeukelaer2018, on core-collection subsets, report that a basic stochastic
#' hill-climber (random descent) already yields high-quality cores and that their
#' genetic algorithm gave no further advantage over it as a global optimiser; the
#' genetic algorithm did outperform random descent, but "is not as effective as
#' parallel tempering", which they prefer and which runs several cooperating local
#' searches in parallel. Parallel tempering therefore beat both there. The
#' twenty-seed run above does not reproduce that ordering: tempering is below both
#' simpler modes. It is not a test of their result, because the move budget is split
#' across the replicas and `n_chains` and the ladder are left at the package's
#' defaults, untuned.
#' 
#' @yadav2025 compared a genetic algorithm (GA), DE, particle swarm optimisation (PSO) and simulated
#' annealing (SA) on parent selection in wheat and, for the
#' selection function the source names OPV (its acronym, not expanded here), ranked them by convergence area under the curve (AUC) at 0.879, 0.860, 0.820 and
#' 0.769; DE took longer to run than GA and performed comparably in final fitness.
#' TrainSel [@akdemir2021] uses a genetic algorithm in conjunction with
#' simulated-annealing steps, and MateR [@fernandezgonzalez2026] is optimised with
#' it.
#' 
#' None of these compares a swap-based local search with a differential evolution
#' on this objective, so they do not decide the question of
#' @sec-advanced-lsvsde. They are consistent with its result, that a simple local search is a
#' serious competitor of the population methods; the warm start and the cheap move
#' are this chapter's explanation, not theirs.
#' :::
#' 
#' ### The encoding, wired up at last
#' 
#' @sec-combinatorial measures the line encoding against a fully $N$-dimensional
#' one -- one random key per hybrid -- and finds the line
#' encoding far ahead at an equal budget, with every restriction slack in the
#' $N$-key arm. That is a verdict on the $N$-key encoding at that budget, not a verdict on `sel_de()`, whose search space is $n_{sel}$
#' coordinates wide. The paired comparison of the two encodings the package ships,
#' `sel_de()` and the line-encoded `sel_de_fast()`, is given in @tbl-advanced-de-pair from this
#' chapter's benchmark (and per seed in @tbl-combinatorial-de-lines); uncapped, it
#' goes the other way. What is true regardless is that `decode_lines()` and `make_fitness_fast()`
#' have been exported since the line route was written with nothing driving them.
#' `sel_de_fast()` closes that:
#' 
## -----------------------------------------------------------------------------
sel_de_fast

#' 
#' What the call does, in order:
#' 
#' 1. Builds the fast fitness: decode the line weights into a selection, tabulate
#'    the parent counts, evaluate $\theta = \mathbf{w}'\mathbf{f}^L\mathbf{w}$ on
#'    the used lines only, and add one proportional penalty per active
#'    restriction -- diversity budget, minimum $N_{e,\text{par}}$, per-line cap,
#'    pool balance. No $N \times N$ matrix is formed or indexed anywhere.
#' 2. Builds the seeds. They sweep a **line-diversity direction**, not a merit
#'    weight: `p` proportional to the negated mean coancestry of each line, at
#'    eight increasing strengths from zero to one.
#' 3. Searches the box $[0, 1]^L$ with `DEoptim`, and decodes the best member.
#' 
#' The zero-strength seed is worth isolating, because it is the natural origin of
#' the encoding: with every line weight at zero the decoder ranks on index alone
#' and takes crosses greedily under the cap, which is capped truncation exactly.
#' 
## -----------------------------------------------------------------------------
#| label: zero-weight-decode
cap <- ceiling(2 * n_sel / ctx$n_lines) + 1
zero_w <- decode_lines(rep(0, ctx$n_lines), ctx, n_sel, max_use = cap)
stopifnot(identical(as.integer(zero_w),
                    as.integer(sel_truncation_cap(ctx, n_sel, cap = cap))))
c(cap = cap, index = mean_index(zero_w, ctx),
  alpha_pct = 100 * alpha_loss(zero_w, ctx, gd),
  max_line = max_line_use(zero_w, ctx))

#' 
#' The seeds sweep a line-diversity direction rather than a merit weight, but the
#' principle is @sec-combinatorial's unchanged: `seeds = NULL` builds the sweep and
#' never means "start cold". The practical consequence of the identity above is
#' that the population always contains at least one plan that respects the cap by
#' construction, whatever the diversity penalty later does.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-de-pair
#| tbl-cap: "Paired difference in mean index, sel_de() minus sel_de_fast(), over optimiser seeds 1 to 3 on one dataset per scale, both at 30,000 nominal evaluations; se is over the three seeds and is 0 where the three per-seed differences are equal. cap is the per-line cap (NA where there is none)."
dp <- do.call(rbind, lapply(
  list(c("book", "de_hybrid", "de_lines"), c("production", "de_hybrid", "de_lines"),
       c("book", "de_hybrid_cap", "de_lines_cap"),
       c("production", "de_hybrid_cap", "de_lines_cap")),
  function(a) {
    p <- bpair(a[[1]], a[[2]], a[[3]])
    data.frame(scale = a[[1]], cap = if (grepl("_cap$", a[[2]])) bs[a[[1]], "cap"] else NA,
               difference = p[["d"]], se = p[["se"]])
  }))
t_dp <- dp[["difference"]][2] / dp[["se"]][2]      # production, uncapped; 2 df
knitr::kable(fmt(dp, 4), row.names = FALSE)

#' 
#' Result. The paired difference `sel_de()` minus `sel_de_fast()` in mean index,
#' over the optimiser seeds 1 to 3, both at 30,000 nominal evaluations, is
#' `r fmt(dp[["difference"]][1], 3)` (s.e. `r fmt(dp[["se"]][1], 3)`) uncapped at the
#' benchmark book scale and `r fmt(dp[["difference"]][2], 3)`
#' (s.e. `r fmt(dp[["se"]][2], 3)`; $t =$ `r fmt(t_dp, 1)` on 2 degrees of
#' freedom, two-sided $p =$ `r fmt(2 * pt(-abs(t_dp), 2), 2)`) at the
#' benchmark production scale; capped it is `r fmt(dp[["difference"]][3], 4)`
#' (s.e. `r fmt(dp[["se"]][3], 4)`) at the book scale and
#' `r fmt(dp[["difference"]][4], 4)` (s.e. `r fmt(dp[["se"]][4], 4)`) at the production
#' scale. A standard error of 0 means that the three per-seed differences are equal,
#' not that the difference is known. Interpretation, and what limits it: without a cap
#' `sel_de()` is ahead of the line-encoded DE at both scales, by more at the book
#' scale than the gap between local search and the better DE
#' (`r fmt(sp[["hill_minus_de_hybrid"]][1], 3)`) that @sec-advanced-lsvsde reads as
#' large; the production difference is not resolved by three seeds. With a cap the
#' two have the same mean index at the production scale and differ by a few thousandths
#' at the book scale, where the decoder satisfies the cap by construction, so the capped
#' rows are not a test of the search. This is one dataset per scale, three seeds and
#' one evaluation budget; and it is the encoding as `sel_de_fast()` implements it
#' (eight seeds along a line-diversity direction, decoder ranking on index), not
#' the line encoding in general.
#' 
#' #### What it is actually for {#sec-defast-restrictions}
#' 
#' `sel_de_fast()` is the only route in this package that accepts more than a
#' budget and a cap: it also takes an $N_{e,\text{par}}$ floor and a pool-balance
#' tolerance. The case for it therefore has to be made where those extra
#' restrictions are active. The first of them cannot be:
#' 
## -----------------------------------------------------------------------------
#| label: pool-balance
pool_share <- function(s) mean(ctx$pool[as.vector(ctx$parents[s, ])] == "A")
# Every candidate is one A x B cross, so any n-subset uses n slots in each pool.
stopifnot(all(ctx$pool[ctx$parents[, 1]] == "A"), all(ctx$pool[ctx$parents[, 2]] == "B"))
set.seed(3)
pool_random <- vapply(1:5, function(i) pool_share(sample.int(ctx$N, n_sel)), numeric(1))
stopifnot(all(pool_random == 0.5))
pool_random

#' 
#' **Pool balance cannot bind.** `make_fitness_fast()` measures the share of line uses
#' that fall in pool A, and every candidate hybrid has one pool-A and one pool-B parent
#' (asserted above), so the share is 0.5 for *any* set of $A \times B$ crosses, a
#' complete factorial or not: five random subsets of the $n$ = `r n_sel` crosses give
#' `r paste(pool_random, collapse = ", ")`. `pool_tol` is vacuous for every
#' candidate set this package builds. The other three restrictions are the budget, the
#' cap and the floor, run next, all four set at once (@tbl-advanced-de-fast-four),
#' followed by an annealed local search at the same cap and no floor
#' (@tbl-advanced-de-fast-vs-local):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-de-fast-four
#| tbl-cap: "sel_de_fast() with the budget, the per-line cap, a floor on N_e,par and pool balance all set, one run per row (seed 7, NP = 100; the floor and itermax are those of the row). alpha_pct: realised diversity loss in percent; Ne_par: realised N_e,par; max_line: largest line use; pool_A: share of parent slots in pool A."
cap4  <- ceiling(4 * n_sel / ctx$n_lines)     # the benchmark's cap, not the default
runs4 <- list(c(20, 300), c(25, 300), c(30, 300), c(30, 1500))   # (floor, itermax)
de_plans <- lapply(runs4, function(a) {
  set.seed(7)
  suppressWarnings(
    sel_de_fast(ctx, n_sel, gd, am, ne_par_min = a[[1]], max_use = cap4,
                pool_tol = 0.05, NP = 100, itermax = a[[2]]))
})
de_fast <- do.call(rbind, Map(function(a, s)
  data.frame(Ne_floor = a[[1]], itermax = a[[2]], index = mean_index(s, ctx),
             alpha_pct = 100 * alpha_loss(s, ctx, gd),
             Ne_par = ne_parents(s, ctx), max_line = max_line_use(s, ctx),
             pool_A = pool_share(s)), runs4, de_plans))
same_usage <- all(vapply(de_plans[-1], function(s)
  identical(line_counts(s, ctx), line_counts(de_plans[[1]], ctx)), logical(1)))
# the prose below: one index and one line usage in all four runs
stopifnot(length(unique(round(de_fast[["index"]], 12))) == 1, same_usage)
knitr::kable(fmt(de_fast, 4), row.names = FALSE)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-de-fast-vs-local
#| tbl-cap: "Annealed local search at the cap of the runs of @tbl-advanced-de-fast-four, no floor argument (seed 7, 20,000 proposed moves), against the sel_de_fast() run with a floor of 25. Index in standard deviations of the candidate pool; local_search_alpha_pct in percent."
set.seed(7)
ls_capped <- sel_local_search(ctx, n_sel, am, gd, mode = "anneal",
                              iters = 20000, max_use = cap4, seed = 7)
dl <- fmt(c(de_fast_index          = de_fast[["index"]][de_fast[["Ne_floor"]] == 25],
            local_search_index     = mean_index(ls_capped, ctx),
            local_search_alpha_pct = 100 * alpha_loss(ls_capped, ctx, gd),
            local_search_Ne        = ne_parents(ls_capped, ctx),
            local_search_max_line  = max_line_use(ls_capped, ctx)), 4)
knitr::kable(kv(dl, 4), row.names = FALSE, align = "lr")

#' 
#' Four runs, seed 7 before each, `NP` = 100: the three floors at `itermax` = 300
#' (30,000 evaluations) and the floor of 30 again at `itermax` = 1,500.
#' 
#' Three readings.
#' 
#' **The cap is satisfied by construction.** `max_line` equals the cap in every row,
#' because the decoder never proposes a plan that breaks it, and `pool_A` is 0.5 in
#' every row for the reason above. The restriction that is deciding the plan is the
#' cap: `r 2 * n_sel` parent slots over `r ctx$n_lines` lines is a mean usage of
#' `r fmt(2 * n_sel / ctx$n_lines, 2)`, against a cap of `r cap4`. That is the
#' diagnosis of @sec-scaling arriving early: compare $2n/L$ with the cap before
#' crediting any other restriction with the shape of a plan.
#' 
#' **The floor of 30 binds, and the run did not meet it.** All four runs return one
#' index, `r fmt(de_fast[["index"]][1], 4)`, with the same line usage
#' (`r same_usage`) and $N_{e,\text{par}} =$ `r fmt(de_fast[["Ne_par"]][1], 2)`. That
#' meets the floors of 20 and 25 and misses the floor of 30 by
#' `r fmt(30 - de_fast[["Ne_par"]][3], 2)`, also at five times the iterations; the
#' penalty did not move the search off a plan that violates it
#' (@tbl-advanced-ne-floor-greedy compares it with the greedy sweep).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-ne-floor-greedy
#| tbl-cap: "The capped greedy sweep over the 20-value grid of the index weight against the sel_de_fast() plan of floor 30 (third row of @tbl-advanced-de-fast-four), on the penalised objective of make_fitness_fast() (penalty 5, floor 30). greedy_plans_meeting_budget_and_floor: number of the 20 plans with alpha at most 1% and N_e,par at least 30; best_index_among_them: their best index; penalised_best_greedy and penalised_de_plan: the penalised objective of the best greedy plan and of the DE plan; index_lost_to_the_floor: index of the DE plan minus best_index_among_them."
# The penalised index of make_fitness_fast() for a plan that meets the cap and
# has pool share 0.5 (the cap and pool terms are then 0), checked against the
# function itself on a random weight vector.
pen <- function(s, fl, penalty = 5)
  mean_index(s, ctx) - penalty * (max(0, (alpha_loss(s, ctx, gd) - am) / am) +
                                   max(0, (fl - ne_parents(s, ctx)) / fl))
ff <- make_fitness_fast(ctx, n_sel, gd, am, ne_par_min = 30, max_use = cap4)
set.seed(11); p_test <- runif(ctx$n_lines)
stopifnot(isTRUE(all.equal(-ff(p_test), pen(decode_lines(p_test, ctx, n_sel, cap4), 30))))
ws <- c(0, 10^seq(-5, 1, length.out = 19))            # the benchmark grid of omega
gp <- lapply(ws, function(w) sel_greedy(ctx, n_sel, w = w, max_use = cap4))
gt <- data.frame(index = vapply(gp, mean_index, numeric(1), ctx = ctx),
                 alpha = vapply(gp, alpha_loss, numeric(1), ctx = ctx, gd_ref = gd),
                 Ne = vapply(gp, ne_parents, numeric(1), ctx = ctx))
meets <- gt$alpha <= am & gt$Ne >= 30
fl <- fmt(c(greedy_plans_meeting_budget_and_floor = sum(meets),
            best_index_among_them = max(gt$index[meets]),
            penalised_best_greedy = max(vapply(gp, pen, numeric(1), fl = 30)),
            penalised_de_plan = pen(de_plans[[3]], 30),
            index_lost_to_the_floor = de_fast[["index"]][3] - max(gt$index[meets])), 4)
knitr::kable(kv(fl, 4), row.names = FALSE, align = "lr")

#' 
#' A plan that meets the floor exists and is cheap to find. The capped greedy sweep
#' over the 20-value benchmark grid of $\omega$ contains `r sum(meets)` plans with
#' $\alpha \le 1$% and $N_{e,\text{par}} \ge 30$; the best has index
#' `r fmt(max(gt$index[meets]), 3)`, and on `make_fitness_fast()`'s own penalised
#' objective (penalty 5, floor 30, asserted against the function above) it scores
#' `r fmt(max(vapply(gp, pen, numeric(1), fl = 30)), 3)` against
#' `r fmt(pen(de_plans[[3]], 30), 3)` for the DE plan. The DE returned a plan that is
#' worse on its own objective than a one-line greedy plan: the route *accepts* a
#' floor, it did not *satisfy* one here. The greedy plan that meets the floor has an
#' index `r fmt(de_fast[["index"]][3] - max(gt$index[meets]), 3)` units below the DE plan
#' that violates it; how much better a search that honoured the floor could do than that
#' greedy plan is not measured.
#' 
#' **And it does not lead on index where a floor is slack.** Under the same budget
#' and cap, with no floor argument, a plain annealed local search reaches
#' `r fmt(mean_index(ls_capped, ctx), 3)` at $N_{e,\text{par}} =$
#' `r fmt(ne_parents(ls_capped, ctx), 1)`, against `sel_de_fast()`'s
#' `r fmt(de_fast[["index"]][de_fast[["Ne_floor"]] == 25], 3)` at the floor of 25.
#' 
#' The recommendation therefore narrows. `sel_de_fast()` is the one route whose
#' signature accepts an $N_{e,\text{par}}$ floor; in the single instance run here it
#' did not satisfy a floor that binds, and a capped greedy sweep filtered on
#' $N_{e,\text{par}}$ did. Check `ne_parents()` on whatever it returns. That the
#' swap neighbourhood "cannot test" a floor is not a structural limit. With $k_a$ the
#' number of times line $a$ is used as a parent in the selection ($\sum_a k_a = 2n$; the
#' count vector `cnt` of `theta_state()`), so that $p_a = k_a/2n$ in @eq-catalogue-ne-par,
#' 
#' $$N_{e,\text{par}} = \frac{(2n)^2}{\sum_a k_a^2}$$ {#eq-advanced-ne-par-counts}
#' 
#' is a function of `cnt`, which `theta_state()` already carries, and it can be updated
#' in $O(1)$ per swap because four counts change (asserted in the `swap-identity` chunk above, against
#' `ne_parents()`). What `sel_local_search()` lacks is an `ne_par_min` argument -- an
#' implementation gap, not a property of the move. This is one instance, one seed per
#' floor, 30,000 and 150,000 evaluations; it is a measurement of this run, not of the
#' route in general.
#' 
#' ## The bound was not a bound {#sec-bound}
#' 
#' @sec-relaxation introduces the continuous relaxation and its two statements,
#' @eq-ocs-weak (weak duality) and @eq-ocs-bound (the Lagrangian bound). The
#' convergence check of @sec-combinatorial was originally written to take, as an
#' upper bound, the best relaxation point whose own $\alpha$ falls inside the budget.
#' As used, that construction is **not valid**, and this section shows it with the
#' experiment that found it -- and says what the experiment does and does not show.
#' 
#' The relaxation at a given $\lambda$ maximises
#' $\mathbf{c}'\mathbf{u} - \lambda\,\mathbf{c}'\mathbf{f}\mathbf{c}$ (@eq-ocs-V),
#' a penalised objective, not the index. By @eq-ocs-weak a relaxation point bounds
#' every plan *at least as diverse as itself*, and at exactly equal diversity a plan
#' cannot beat it. What @eq-ocs-weak does not give is a bound for a plan that spends the
#' whole budget when the point lies strictly inside it: that plan is less diverse than
#' the point, and the bound it satisfies is the tangent of slope $\lambda$ at the point,
#' which lies above the point's height (@sec-relaxation, statement 3). A grid of $\lambda$
#' values makes "strictly inside" the rule: the last grid point inside the budget is
#' the one the construction uses. @tbl-advanced-old-construction gives the experiment.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-old-construction
#| tbl-cap: "The old construction against the best of eight feasible plans, at four budgets, on a 12-value grid of the multiplier lambda with 2,000 projected-gradient iterations. alpha_max: budget; feasible_plan: best index among the eight plans of the chunk; old_bound: index of the last relaxation point inside the budget; point_lambda and point_alpha_pct: its multiplier and its realised loss in percent; old_valid and lagrangian_valid: whether the bound is at least feasible_plan; lagrangian_2000: the Lagrangian form at the same cheap setting, not converged."
lam   <- 10^seq(-1, 3, length.out = 12)
rel   <- ocs_relaxation(ctx, n_sel, lam, iters = 2000)
a_rel <- (gd - rel[, "GD"]) / gd
V     <- rel[, "index"] - lam * rel[, "theta"]     # the relaxation's dual value

# The eight plans of every row: one annealed local search and seven greedy weights.
cmp <- do.call(rbind, lapply(c(0.0025, 0.005, 0.01, 0.02), function(a) {
  ok  <- a_rel <= a
  j   <- if (any(ok)) which(ok)[which.max(rel[ok, "index"])] else NA_integer_
  old <- if (is.na(j)) NA_real_ else rel[j, "index"]
  new <- min(V + lam * (1 - gd * (1 - a)))  # the Lagrangian form, under-converged
  best <- max(vapply(
    Filter(function(s) alpha_loss(s, ctx, gd) <= a + 1e-12,
           c(list(sel_local_search(ctx, n_sel, a, gd, mode = "anneal",
                                   iters = 8000, seed = 1)),
             lapply(c(0, .5, 1, 2, 4, 8, 16), function(w) sel_greedy(ctx, n_sel, w = w)))),
    mean_index, numeric(1), ctx = ctx))
  data.frame(alpha_max = a, feasible_plan = best, old_bound = old,
             point_lambda = lam[j], point_alpha_pct = 100 * a_rel[j],
             old_valid = old >= best - 1e-9, lagrangian_2000 = new,
             lagrangian_valid = new >= best - 1e-9)
}))
knitr::kable(fmt(cmp, 4), row.names = FALSE)

#' 
#' Result. `old_bound` is below `feasible_plan` at all four budgets
#' (`old_valid` is FALSE in every row). The four rows are not four independent
#' refutations: they use `r length(unique(cmp[["point_lambda"]]))` distinct relaxation
#' points, shared by the budgets
#' `r paste(vapply(split(100 * cmp[["alpha_max"]], cmp[["point_lambda"]], drop = TRUE), function(a) paste0(paste(a, collapse = "% and "), "%"), character(1)), collapse = " and by ")`. At the 1% budget the point the construction uses has
#' $\alpha =$ `r fmt(cmp[["point_alpha_pct"]][3], 3)`%, strictly inside the budget. Each
#' `feasible_plan` is the best of the eight plans of the chunk, not the best plan any
#' method could find. @tbl-advanced-point-at-budget moves the relaxation point onto the
#' 1% budget.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-point-at-budget
#| tbl-cap: "The relaxation point on the 1% budget (lambda bisected, 10 steps, 4,000 iterations) against the grid point used by the old construction and the feasible plan of the 1% row of @tbl-advanced-old-construction. lambda: multiplier; alpha_pct: realised loss in percent; index: index of the relaxation point (first two rows) or of the plan (third row)."
# Move the relaxation point onto the budget: bisect lambda so that alpha(lambda) is
# at the 1% budget (alpha falls as lambda rises), 4000 iterations per point.
at_lambda <- function(l) {
  r <- rbind(ocs_relaxation(ctx, n_sel, l, iters = 4000))
  c(lambda = l, alpha_pct = unname(100 * (gd - r[1, "GD"]) / gd),
    index = unname(r[1, "index"]))
}
lo <- 10; hi <- 158
for (i in 1:10) {
  mid <- sqrt(lo * hi)
  if (at_lambda(mid)[["alpha_pct"]] > 100 * am) lo <- mid else hi <- mid
}
pt_budget <- at_lambda(hi)
plan_1pct <- cmp[["feasible_plan"]][cmp[["alpha_max"]] == am]
pb <- fmt(rbind(grid_point_inside_budget = c(lambda = cmp[["point_lambda"]][3],
                                             alpha_pct = cmp[["point_alpha_pct"]][3],
                                             index = cmp[["old_bound"]][3]),
                point_on_the_budget      = pt_budget,
                feasible_plan            = c(NA, NA, plan_1pct)), 4)
stopifnot(pt_budget[["alpha_pct"]] <= 100 * am, pt_budget[["alpha_pct"]] > 0.99,
          pt_budget[["index"]] >= plan_1pct)       # @eq-ocs-weak at equal diversity
knitr::kable(cbind(point = rownames(pb), pb), row.names = FALSE)

#' 
#' Interpretation, and what limits it. What the experiment shows is a statement about
#' finite grids: on a grid of 12 values of $\lambda$ the last relaxation point inside
#' the budget lies below a plan that spends the budget. It does not show that a
#' relaxation point at the budget fails to bound a plan, and the second chunk is
#' consistent with @eq-ocs-weak: the same relaxation at the $\lambda$ for which the point sits on the 1%
#' budget ($\alpha =$ `r fmt(pt_budget[["alpha_pct"]], 3)`%, bisected, 10 steps) has index
#' `r fmt(pt_budget[["index"]], 4)`, above the feasible plan
#' (`r fmt(plan_1pct, 4)`); that is one point against one plan, and @eq-ocs-weak
#' allows it for a point that is on the budget to within the
#' `r fmt(100 * am - pt_budget[["alpha_pct"]], 3)` percentage points by which it lies
#' inside. It does not show that a point at the budget bounds every plan. The
#' construction is therefore a bound only if its grid is fine enough to put a point at
#' the budget -- a property nobody checked -- and that is why the Lagrangian form,
#' which does not ask where a point lies, replaces it. One dataset, one budget for the
#' bisection, a 4000-iteration relaxation that is not tested for convergence here.
#' 
#' `lagrangian_2000` is the Lagrangian form evaluated at a deliberately cheap
#' setting -- 12 multipliers, 2,000 projected-gradient iterations -- and it is
#' here only to show that the form survives where the construction does not. Its
#' validity needs $V(\lambda)$ to be computed to convergence, which this setting
#' does not guarantee, so **nothing downstream of this chunk quotes it**; the value
#' quoted as the bound comes from `ocs_bound()` below.
#' 
#' The correct statement is @eq-ocs-bound, derived from @eq-ocs-weak in
#' @sec-relaxation and not re-derived here: for every $\lambda \ge 0$ and every plan
#' $S$ of $n$ hybrids with $\theta_S \le \theta_{\max}$,
#' $\bar u_S \le V(\lambda) + \lambda\,\theta_{\max}$, with $V(\lambda)$ the optimum of the
#' relaxation. The tightest such statement is the minimum over $\lambda$, and a coarse
#' grid costs tightness, not validity -- unlike the old construction, where a coarse
#' grid could silently produce a "bound" below the achievable.
#' 
## -----------------------------------------------------------------------------
ocs_bound

#' 
#' To use it: translate the budget into
#' $\theta_{\max} = 1 - \text{gd\_ref}(1 - \alpha_{\max})$ (@eq-ocs-theta-max); solve the relaxation
#' at each $\lambda$ to get $V(\lambda)$; take the minimum of
#' $V(\lambda) + \lambda\,\theta_{\max}$; and **read the `converged` attribute
#' before quoting anything**. The function doubles its iteration count until the
#' value stops moving by more than a relative `tol` = 0.001, because the value rises
#' monotonically with iterations, so an under-converged run reports the bound too
#' small -- the one failure mode that turns a bound into a wrong number rather than a
#' loose one. `converged` is a stalling criterion of that doubling, as in
#' @sec-relaxation, and not a certificate: a value that has stopped moving by 0.1%
#' on doubling has not been proved to be at its limit. Its default grid is
#' `r length(eval(formals(ocs_bound)[["lambdas"]]))` multipliers, log-spaced from
#' `r fmt(min(eval(formals(ocs_bound)[["lambdas"]])), 1)` to
#' `r fmt(max(eval(formals(ocs_bound)[["lambdas"]])), 0)`, and every bound quoted in
#' this chapter is on that grid unless stated. @tbl-advanced-bound-grids compares it with
#' the cheap setting of the experiment above.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-bound-grids
#| tbl-cap: "The Lagrangian bound, min over lambda of V(lambda) + lambda theta_max, at the 1% budget of the live book-scale instance, for two grids of the multiplier (12 and 25 values) and two iteration counts (2,000 and the count ocs_bound() reached by doubling). value: the bound; lambda: the minimising multiplier. Only the fourth row is ocs_bound() itself."
bound  <- ocs_bound(ctx, n_sel, am, gd)
th_max <- 1 - gd * (1 - am)
lam25  <- eval(formals(ocs_bound)[["lambdas"]])
hand   <- function(lams, it) {                 # the same formula, a chosen grid and count
  r <- ocs_relaxation(ctx, n_sel, lams, iters = it)
  b <- r[, "index"] - lams * r[, "theta"] + lams * th_max
  c(value = min(b), lambda = lams[which.min(b)])
}
h12_2000 <- hand(lam, 2000); h12_8000 <- hand(lam, attr(bound, "iters"))
h25_2000 <- hand(lam25, 2000)
stopifnot(isTRUE(all.equal(h12_2000[["value"]], min(V + lam * th_max))))
bg <- fmt(rbind(`12 multipliers, 2000 iterations`   = h12_2000,
                `12 multipliers, ocs_bound iterations` = h12_8000,
                `25 multipliers, 2000 iterations`   = h25_2000,
                `25 multipliers = ocs_bound()`      = c(as.numeric(bound), attr(bound, "lambda"))), 4)
knitr::kable(cbind(grid_and_iterations = rownames(bg), bg), row.names = FALSE)

#' 
#' Result. At $\theta_{\max} =$ `r fmt(th_max, 4)`, the first row of @tbl-advanced-bound-grids is the cheap sweep of
#' @tbl-advanced-old-construction (`r fmt(h12_2000[["value"]], 4)`); the fourth is `bound`, `r fmt(as.numeric(bound), 4)`,
#' `r fmt(100 * (as.numeric(bound) / h12_2000[["value"]] - 1), 2)`% higher, with
#' `converged` `r attr(bound, "converged")` after `r attr(bound, "iters")` iterations. The two
#' differ in the grid (12 against 25 multipliers) and in the iteration count (2,000
#' against `r attr(bound, "iters")`), and the second and third rows separate them: raising the
#' iterations on the 12-multiplier grid moves the value by
#' `r fmt(100 * (h12_8000[["value"]] / h12_2000[["value"]] - 1), 2)`%, changing the grid at
#' 2,000 iterations by `r fmt(100 * (h25_2000[["value"]] / h12_2000[["value"]] - 1), 2)`%.
#' Interpretation, and what limits it. Under-convergence does lower the value, in the
#' direction the paragraph above gives, but it is the smaller part of the difference
#' here; the larger part is the grid, and its effect is not a one-way correction: the
#' 12-multiplier grid contains a multiplier near the minimiser
#' (`r fmt(h12_8000[["lambda"]], 1)`) that the 25-multiplier grid skips
#' (`r fmt(attr(bound, "lambda"), 1)`), so at equal iterations the 25-point bound is the
#' looser one by `r fmt(100 * (as.numeric(bound) / h12_8000[["value"]] - 1), 2)`%. Both are
#' valid bounds if their relaxations are converged; the second is looser. One
#' dataset and one budget: how the two effects trade at other budgets is not measured.
#' Everything this chapter quotes as a bound from here on is `bound`, the converged
#' object of the fourth row of @tbl-advanced-bound-grids.
#' 
#' Two practical consequences. Every $\lambda$ gives a valid bound, so a coarse grid
#' costs tightness and never validity. And the bound can be used as a stopping rule
#' within what it supports: when the converged bound exceeds the best plan found by
#' a small margin, the margin is the most that further search can gain on this
#' dataset and budget -- an upper limit, conditional on the stalling criterion having
#' signalled convergence.
#' 
#' ::: {.callout-warning}
#' ## This changes a number in @sec-combinatorial
#' 
#' The convergence check in @sec-combinatorial once used the invalid
#' construction, and the gap it reported was not a gap. That chapter now calls
#' `ocs_bound()`, and the number there is the Lagrangian one; its qualitative
#' conclusion survived the correction -- the bound lies above the best feasible greedy
#' plan and above the warm-started DE at its chapter budgets, and the size of that
#' shortfall is what @sec-localsearch closes. The
#' lesson is the one that generalises: a quantity is only a bound if a feasible
#' solution can never exceed it, and that is a property to test, not to assume.
#' 
#' @sec-relaxation has been rewritten to match: it states the relaxation as a
#' penalised optimum at each $\lambda$, shows the order relaxation point $<$
#' feasible plan $<$ bound at the 1% budget, and takes its bound from
#' `ocs_bound()`.
#' :::
#' 
#' ## Rounding the relaxation into a plan
#' 
#' With a bound in hand, the relaxation stops being only a diagnostic. Solve the
#' optimal-contribution programme in **line** space, where `quadprog` returns
#' instantly because the dimension is $L$, round the contributions to integer line
#' usage, and assign concrete crosses under both pools' caps. That two-stage shape
#' -- contributions first, mate allocation second -- is exactly @waldmann2025's,
#' whose mate-allocation stage solves in under 0.01 seconds.
#' 
#' The five steps inside `ocs_round()`, in the order they run:
#' 
#' 1. **Line merit.** Each line is scored by the mean index of the hybrids it
#'    parents in the candidate set, the `line_merit` of @sec-ocs. That quantity is a general combining ability:
#'    a property of the line *against the opposite pool as represented in this
#'    factorial*, never a property of the line alone (@sec-heterosis-gca-sca).
#'    Change the tester pool and the score changes.
#' 2. **Contributions.** `ocs_quadprog()` on `ctx$fL` with those merits, at a
#'    given $\lambda$, with each line's contribution capped at
#'    $\texttt{max\_use} / 2n$ -- the cap expressed as a share of the $2n$ parent
#'    slots, as in @sec-ocs. As there, the quadratic programme has a single margin
#'    (the contributions of all $L$ lines sum to one) and no per-pool sum; the two
#'    pools' totals are equalised only in step 4, because every cross spends one slot
#'    of each pool.
#' 3. **Rounding.** Contributions times $2n$, floored, and the shortfall handed to
#'    the largest remainders; then clipped at `max_use` again.
#' 4. **Mate allocation.** Walk the candidates in decreasing index and take each
#'    cross whose two parents still have quota and are under the cap -- a greedy
#'    b-matching. If quota runs out before $n$ crosses are found, top up on the
#'    cap alone, because the quota is a rounding artefact and the cap is the real
#'    restriction.
#' 5. **Choose $\lambda$ by budget, not by preference.** The whole sweep is
#'    evaluated and the plan returned is the best-index one whose realised
#'    $\alpha$ respects `alpha_max`. The exchange rate stays an internal detail;
#'    the budget remains the interface.
#' 
#' @tbl-advanced-round-plan gives the plan returned on the live instance, and
#' @tbl-advanced-round-reconcile sets it against the cached benchmark row of the same
#' method.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-round-plan
#| tbl-cap: "ocs_round() on the live book-scale instance at the 1% budget, with the converged bound of the preceding section as `bound`. index: mean index of the plan (standard deviations of the pool); alpha_pct: realised loss in percent; lambda: the multiplier returned; bound and gap_pct: the bound and the plan's gap to it in percent."
r <- ocs_round(ctx, n_sel, am, gd, bound = as.numeric(bound))
rp <- fmt(c(index = r[["index"]], alpha_pct = 100 * r[["alpha"]],
            lambda = r[["lambda"]], bound = r[["bound"]],
            gap_pct = 100 * r[["gap"]]), 4)
knitr::kable(kv(rp, 4), row.names = FALSE, align = "lr")

#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-round-reconcile
#| echo: false
#| tbl-cap: "The live ocs_round() plan against the cached benchmark row of the same method at the benchmark book scale. The gd_ref differs (B = 400 resamples here, 500 in the benchmark), hence the bound and the gap; the plan is the same."
br <- bench[bench$scale == "book" & bench$method == "ocs_round", ][1, ]
rr <- fmt(c(here_index     = r[["index"]],
            benchmark_index = br[["index"]],
            here_gd_ref    = gd,
            here_bound     = as.numeric(bound),
            benchmark_bound = br[["bound"]],
            here_gap_pct   = 100 * r[["gap"]],
            benchmark_gap_pct = br[["gap_pct"]]), 5)
knitr::kable(kv(rr, 5), row.names = FALSE, align = "lr")

#' 
#' @tbl-advanced-round-reconcile exists because @tbl-advanced-benchmark-book
#' reports this same method and does not report exactly this gap. The plan is
#' identical -- both reach index `r fmt(r[["index"]], 6)` -- and the whole
#' difference is in `gd_ref`: this chapter resamples the random reference at
#' $B = 400$ and the cached benchmark at $B = 500$, so
#' $\theta_{\max} = 1 - \text{gd\_ref}(1 - \alpha_{\max})$ differs and the bound with it,
#' in the third decimal: `r fmt(as.numeric(bound), 4)` here and
#' `r fmt(br[["bound"]], 4)` in the benchmark. Two draws of the same reference, not
#' two results. A gap computed against
#' a bound that has not converged is a different matter: the cheap sweep of
#' @sec-bound would have reported
#' `r fmt(100 * (min(V + lam * (1 - gd * (1 - am))) - r[["index"]]) / min(V + lam * (1 - gd * (1 - am))), 2)`%
#' here, against `r fmt(100 * r[["gap"]], 2)`% for `bound`, because the quantity it
#' divides by is a different, lower number (the two differ in grid and in iterations,
#' as the rows of @tbl-advanced-bound-grids show).
#' 
#' @tbl-advanced-round-frontier is the step-5 diagnostic: at small $\lambda$ the programme
#' puts everything on the best lines and the realised loss exceeds the budget; at
#' large $\lambda$ it spreads contributions and the loss goes negative -- more
#' diverse than a random subset. The plan returned is the highest-index row that
#' respects the budget, which because index falls monotonically with $\lambda$ is
#' the smallest feasible $\lambda$ on the grid. If *no* row is feasible the
#' function falls back to the least-loss one, which is a result to notice rather
#' than to use -- the returned `alpha` is then above `alpha_max` and nothing in
#' the call will say so.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-round-frontier
#| tbl-cap: "The frontier of ocs_round() on the live book-scale instance at the 1% budget: one row per multiplier of the sweep, with the plan the rounding returns for it (frontier element of the returned list; columns as the function names them)."
knitr::kable(fmt(r[["frontier"]], 4), row.names = FALSE)

#' 
#' The rounding is visible in the plan itself. Line usage should track combining
#' ability, and it does:
#' 
## -----------------------------------------------------------------------------
#| label: merit-vs-usage
merit <- tapply(rep(ctx$index, 2),
                factor(c(ctx$parents[, 1], ctx$parents[, 2]),
                       levels = seq_len(ctx$n_lines)), mean)
used  <- line_counts(r[["idx"]], ctx)
isA   <- ctx$pool == "A"
c(cor_merit_usage_A = cor(merit[isA], used[isA]),
  cor_merit_usage_B = cor(merit[!isA], used[!isA]),
  lines_used_A      = sum(used[isA] > 0),
  lines_used_B      = sum(used[!isA] > 0),
  max_line          = max(used))

#' 
#' Result: usage correlates with line merit at `r fmt(cor(merit[isA], used[isA]), 2)`
#' in pool A and `r fmt(cor(merit[!isA], used[!isA]), 2)` in pool B, over
#' `r sum(used > 0)` lines of `r ctx$n_lines` actually used.
#' Interpretation: the quadratic programme is doing what an
#' optimal-contribution scheme is supposed to do -- allocate more crosses to
#' better general combiners and stop where relatedness makes the next cross
#' expensive. Note that this call passes no `max_use`, so the plan's
#' `max_line` is whatever the coancestry term alone permits; with a cap set, the
#' bound stays valid but goes loose, because the relaxation it comes from carries
#' no cap and therefore bounds an easier problem.
#' 
#' It is not the best method here, and it is not meant to be. What it gives is a
#' plan and a bound in one call, at a cost that does not grow with $N$ in
#' the part that matters -- and a sanity check on everything else.
#' 
#' ## Exact, and how far the heuristics really are {#sec-oa}
#' 
#' Everything so far is a heuristic with a bound. The remaining question is what
#' the true optimum is, and the honest answer requires solving the problem exactly
#' at a scale where that is possible.
#' 
#' The obvious route is closed. Maximising a linear index subject to a **quadratic**
#' diversity constraint over binary variables is a mixed-integer quadratically
#' constrained programme, and HiGHS -- like most open solvers -- does not accept a
#' quadratic term together with integer variables at all.
#' 
#' Convexity opens a different one. Because `f` is positive semi-definite,
#' $\mathbf{x}'\mathbf{f}\mathbf{x}$ is convex, so its tangent at any point is a
#' valid linear *under*-estimate. Write $\mathbf{x}$ for the 0/1 indicator vector of the
#' selection ($N$ binary variables) and $b = n^2\,\theta_{\max}$ for the budget in
#' submatrix-sum units (step 1 below); at any point $\bar{\mathbf{x}}$ the tangent gives the cut
#' 
#' $$\bar{\mathbf{x}}'\mathbf{f}\bar{\mathbf{x}} + 2(\mathbf{f}\bar{\mathbf{x}})'(\mathbf{x} - \bar{\mathbf{x}}) \;\le\; b$$ {#eq-advanced-oa-cut}
#' 
#' and @eq-advanced-oa-cut is a linear relaxation of $\mathbf{x}'\mathbf{f}\mathbf{x} \le b$. Solve the
#' resulting mixed-integer **linear** programme (MILP), add a cut wherever the solution
#' violates the true constraint, re-solve. This is outer approximation
#' [@duran1986], it needs only a MILP solver, and it terminates: each cut strictly
#' removes the infeasible point that generated it.
#' 
## -----------------------------------------------------------------------------
args(sel_exact)

#' 
#' The loop, step by step:
#' 
#' 1. **Translate the budget.** The diversity constraint becomes
#'    $\mathbf{x}'\mathbf{f}\mathbf{x} \le n^2\,\theta_{\max}$ with
#'    $\theta_{\max} = 1 - \text{gd\_ref}(1 - \alpha_{\max})$ -- the same quantity
#'    as in the Lagrangian bound, expressed in submatrix-sum units because that is
#'    what the solver sees.
#' 2. **Write the structural rows.** One cardinality row summing to $n$, and one
#'    row per line for the partition matroid when `max_use` is set. Those are
#'    linear and exact; only the quadratic needs approximating.
#' 3. **Carry an incumbent from the start.** The warm start is the same
#'    `sel_local_search()` warm start; if it satisfies the budget it becomes the
#'    incumbent and is handed to the solver as a starting point, so that a run
#'    stopped by the clock still reports a real interval.
#' 4. **Solve, cut, repeat.** If the MILP solution satisfies the true quadratic
#'    constraint, it is optimal for the current relaxation and the loop can stop;
#'    otherwise a gradient cut at that point is added and the MILP re-solved.
#' 5. **Read the dual bound from the right field.** `objective_value` is an upper
#'    bound only for a MILP solved to optimality; the moment the solver hits its
#'    own time limit the bound must come from `mip_dual_bound`. Cuts only tighten
#'    the relaxation, so the running minimum over iterations stays valid.
#' 
## -----------------------------------------------------------------------------
#| label: exact-budget
# The model at the benchmark book scale (N = 625), with and without a per-line cap.
# The runs of the table below carry no max_use: one structural row.
c(theta_max                    = 1 - gd * (1 - am),
  budget_xfx                   = n_sel^2 * (1 - gd * (1 - am)),
  binary_vars                  = ctx$N,
  structural_rows_no_cap       = 1,
  structural_rows_with_max_use = 1 + ctx$n_lines)

#' 
#' It also returns more than a black-box call would. The MILP objective is a valid
#' upper bound at every iteration and the warm start supplies a feasible
#' incumbent, so a run stopped by the clock still hands back an interval, from the
#' incumbent to the dual bound, that contains the true optimum (@tbl-advanced-oracle).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-oracle
#| echo: false
#| tbl-cap: "The oracle, seeded with the local-search solution so that a timed-out run still reports a real interval. `tiny` is one instance of 6 + 6 lines and 800 markers (simulation seed 5; local search: one tempering run of 20,000 moves, seed 1); `book` is the benchmark book scale (N = 625; one annealing run of 60,000 moves, seed 1; time limit 300 s). No run carries a per-line cap. `status` is \"optimal\" only where the loop proved it. `gap %` is (dual bound - local search) / dual bound."
e <- exg
e$alpha_pct <- 100 * e$alpha_max
knitr::kable(e[, c("scale", "N", "n_sel", "alpha_pct", "heuristic", "incumbent",
                   "dual", "status", "cuts", "secs", "gap_pct")],
  digits = 4, row.names = FALSE,
  col.names = c("scale", "N", "n", "budget %", "local search", "incumbent",
                "dual bound", "status", "cuts", "seconds", "gap %"))

#' 
## -----------------------------------------------------------------------------
#| label: oracle-numbers
#| include: false
tiny <- exg[exg$scale == "tiny", ]
bk   <- exg[exg$scale == "book" & abs(exg$alpha_max - am) < 1e-12, ]
lag_bound <- unique(bench$bound[bench$scale == "book"])       # Lagrangian, B = 500
stopifnot(length(lag_bound) == 1, all(tiny$status == "optimal"),
          all(exg$status[exg$scale == "book"] == "time limit"),
          # numbers quoted in the text and in the caption of the oracle table
          min(tiny$cuts) == 20, max(tiny$cuts) == 73, unique(tiny$N) == 36,
          all(exg$cuts[exg$scale == "book"] == 4),
          all(abs(exg$secs[exg$scale == "book"] - 300) < 1))   # the 300 s limit, overrun by < 1 s

#' 
#' Result. On the tiny instance ($N =$ `r unique(tiny$N)`, $n =$ `r unique(tiny$n_sel)`) the
#' loop proved optimality at all three budgets, in
#' `r min(tiny$cuts)` to `r max(tiny$cuts)` cuts, and the local search equals the proven
#' optimum to the largest gap in @tbl-advanced-oracle (`r sprintf("%.0e", max(tiny$gap_pct))`%).
#' At the benchmark book scale ($N =$ `r unique(bk$N)`, $n =$ `r unique(bk$n_sel)`) the loop
#' stopped at the time limit after `r paste(unique(exg$cuts[exg$scale == "book"]), collapse = " and ")`
#' cuts at both budgets. At the 1% budget the interval is
#' [`r fmt(bk$incumbent, 4)`, `r fmt(bk$dual, 4)`], a gap of `r fmt(bk$gap_pct, 1)`% for
#' the local-search plan. Two valid bounds are therefore on the table for the same
#' budget and scale: the oracle's dual bound, `r fmt(bk$dual, 4)`, and the Lagrangian
#' bound of @sec-bound, `r fmt(lag_bound, 4)` (the benchmark's, $B = 500$). The same plan
#' has a gap of `r fmt(100 * (lag_bound - bk$heuristic) / lag_bound, 1)`% against the second.
#' Neither is called a certificate here: the Lagrangian bound's `converged` is a
#' stalling criterion (@sec-bound), and the oracle's dual bound is that of a
#' relaxation with four cuts.
#' 
#' Interpretation, and what limits it. On this one tiny instance, at three budgets
#' and with no cap, the local search is not leaving anything on the table, which is
#' evidence that the move and the objective are right at that size. It is not
#' evidence about another instance, about a plan under a cap (no oracle run carries
#' `max_use`), or about 625 or 10,000 candidates, where the true optimum is unknown.
#' At 625 the tighter valid interval is the one against the Lagrangian bound, and the
#' `r fmt(bk$gap_pct, 1)`% against the oracle's dual reads as the looseness of a
#' four-cut relaxation, not as the heuristic's distance from optimal. Why the loop
#' stalls at 625 was not diagnosed: `r min(tiny$cuts)` to `r max(tiny$cuts)` cuts were enough at
#' $N =$ `r unique(tiny$N)` and `r unique(exg$cuts[exg$scale == "book"])` fit in
#' 300 s at $N =$ `r unique(bk$N)`, which does not say how the number of cuts needed grows; and the
#' oracle was not run at $N = 10{,}000$, where the matrix alone is
#' `r fmt(scal$f_GB[scal$N == 10000], 3)` GiB, so nothing here says what it does there. At
#' that scale neither bound converged in this file (@sec-scaling), so no interval is
#' reportable. @ahadi2024, solving an integer programme for mate selection with a
#' commercial solver, write that massive datasets could make optimal solutions
#' unrealistic, that they may consider decomposition techniques, and that they would
#' likely settle for "sub-optimal (but good quality) feasible solutions"; that is a
#' statement of the same kind, about another problem, not a measurement of this one.
#' 
#' ::: {.callout-important}
#' ## What the oracle is for
#' 
#' Not production. `sel_exact()` forms the `N x N` matrix and scales like the
#' mixed-integer programme it is. It belongs with the `ref_*` functions of
#' @sec-verification: deliberately slow, deliberately literal, and the only way to
#' know whether the fast route is right. Run it once, small, when the data
#' changes; do not put it in a pipeline.
#' :::
#' 
#' ## Scaling to 200 of 10,000 {#sec-scaling}
#' 
#' @tbl-advanced-scaling and @fig-advanced-scaling give the cost of one objective
#' evaluation, by route and by $N$.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-scaling
#| echo: false
#| tbl-cap: "Cost of one objective evaluation, by route. n_sel is 2 percent of N by construction in this sweep, so the hybrid route's column mixes growth in N with growth in the size of the selection; the line route's is dominated by the decode, which sorts all N candidates; the swap never decodes. The matrix-size column is GiB (bytes / 2^30) throughout, despite being named f_GB in the cached CSV."
knitr::kable(scal, digits = c(0, 0, 0, 3, 1, 1, 1, 1), row.names = FALSE,
  col.names = c("N", "L", "n_sel", "f size (GiB)", "hybrid (us)", "line (us)",
                "of which decode (us)", "swap (us)"))

#' 
## -----------------------------------------------------------------------------
#| label: scaling-growth
#| echo: false
sc <- scal[is.finite(scal$us_hybrid), ]
gr <- function(v) v[nrow(sc)] / v[1]
# the numbers typed in the caption and the alt text of @fig-advanced-scaling
stopifnot(round(gr(sc$us_lines), 1) == 9.4, round(gr(sc$us_hybrid)) == 20,
          sc$n_sel[1] == 20, sc$n_sel[nrow(sc)] == 200,
          sc$N[1] == 400, sc$N[nrow(sc)] == 10000,
          round(sc$us_lines[1]) == 18, round(sc$us_lines[nrow(sc)]) == 169,
          round(sc$us_hybrid[1]) == 7, round(sc$us_hybrid[nrow(sc)]) == 132,
          round(sc$us_swap[1], 1) == 2.7, round(sc$us_swap[nrow(sc)], 1) == 4.2,
          sc$us_hybrid[sc$N == 3600] / sc$us_hybrid[sc$N == 1600] > 4)  # the jump
fmt(c(N_from = sc$N[1], N_to = sc$N[nrow(sc)],
      n_sel_from = sc$n_sel[1], n_sel_to = sc$n_sel[nrow(sc)],
      growth_hybrid = gr(sc$us_hybrid), growth_lines = gr(sc$us_lines),
      growth_decode = gr(sc$us_decode), growth_swap = gr(sc$us_swap)), 2)

#' 
## -----------------------------------------------------------------------------
#| label: fig-advanced-scaling
#| echo: false
#| fig-cap: "Cost per objective evaluation (microseconds, log-log axes) against the number of candidate hybrids, one timing per N on one machine; N = 22,500 has no timing because the matrix is not formed there. Only the incremental swap is flat. Both encodings grow: the line route by 9.4x, dominated by decode_lines()'s O(N log N) sort over all candidates, and the hybrid route by 20x -- but that arm is confounded, because the sweep sets n_sel to 2 percent of N (20 crosses at N = 400, 200 at N = 10,000) and mean(f[idx, idx]) is quadratic in the selection, not in N."
#| fig-alt: "Log-log line chart of microseconds per objective evaluation against the number of candidate hybrids, 400 to 10,000. The line-encoded full fitness rises from about 18 to about 169 microseconds, with its decode_lines() component just below it. The hybrid-encoding fitness rises from about 7 to about 132 microseconds, with a jump between 1,600 and 3,600 candidates. The incremental swap stays nearly flat, from about 2.7 to about 4.2 microseconds."
knitr::include_graphics(book_fig("search_scaling.png"))

#' 
#' Three things scale badly, and they are worth separating because only one of the
#' three is fixed by the line encoding.
#' 
#' **Memory.** `f` is $8N^2$ bytes: `r fmt(scal$f_GB[scal$N == 10000], 3)` GiB at
#' $N = 10{,}000$ and `r fmt(scal$f_GB[scal$N == 22500], 1)` GiB at
#' $N = 22{,}500$, which is why @sec-choosing's benchmark refuses to form it there.
#' $\mathbf{f}^L$ is $200 \times 200$, or `r fmt(8 * bs["production", "L"]^2 / 2^20, 1)` MiB. **Fixed by the line route.**
#' 
#' **Search dimension.** Not what the line encoding fixes -- not for the two
#' differential evolutions, at any rate. `sel_de()` searches $n_{sel}$ continuous
#' coordinates and `sel_de_fast()` searches $L$; at this chapter's target both are
#' **200**, which is also the figure @sec-notreach quotes. The 10,000-dimensional
#' alternative is one key per hybrid, the encoding @sec-combinatorial rejects and
#' no route in this package uses. What the collapse genuinely moves to $L$ is the
#' *contributions* space: `ocs_quadprog()` inside `ocs_round()` solves a
#' 200-variable quadratic programme where `ocs_relaxation()` works on a
#' 10,000-variable contribution vector, which is why `ocs_round()` (uncapped, no
#' `max_use`) sweeps its ten $\lambda$ values and returns a *plan* in
#' `r round(1000 * bsec("production", "ocs_round"))`
#' ms at the benchmark production scale. That number includes the ten per-$\lambda$
#' quadratic programmes, the rounding, the mate allocation and the ten
#' `alpha_loss()` evaluations of the frontier against the
#' `r fmt(scal$f_GB[scal$N == 10000], 3)` GiB matrix; which of them dominates was not
#' measured. The benchmark passes `bound =` a value computed once, outside the timed
#' block, and at $N = 10{,}000$ that value did not converge, so the plan is what is
#' fast here and there is no converged bound at this scale to be fast about. @sec-advanced-headtohead is where that is measured.
#' **Fixed for the quadratic programme; already true for the DE.**
#' 
#' **Cost per evaluation.** `mean(f[idx, idx])` is $O(n^2)$ in the *selection*, so
#' it degrades exactly as the problem gets interesting -- but `decode_lines()` is
#' $O(N \log N)$, so the line encoding does not fix this and at these sizes is
#' slightly worse. **Fixed only by not decoding**, which is what the swap
#' neighbourhood does.
#' 
#' Scaling up is therefore not a matter of buying time. It is a matter of not
#' forming `f` at all: build `ctx$fL` and `ctx$parents`, and use the routes that
#' read only those. That last clause is a real restriction and not a formality,
#' because most of this package still reaches for the $N \times N$ matrix, and
#' `fast_ctx()` does not change that -- it *adds* `parents` to whatever context it
#' is handed and neither builds `f` nor drops it. The constructor with the switch
#' is `ctx_from_pools(sim, with_f = FALSE)`, and @sec-ffree is what actually
#' happens on the context it returns.
#' 
#' ### Which routes actually run without `f` {#sec-ffree}
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-ffree
#| tbl-cap: "Every route in this chapter, run on a context carrying fL and parents but no N x N f. The second column is the message the package returns today."
sim <- simulate_pools(n_A = 10, n_B = 10, m = 400, seed = 1)
cxF <- ctx_from_pools(sim, with_f = FALSE)   # fL + parents, no N x N matrix
cxT <- ctx_from_pools(sim, with_f = TRUE)    # the same data, f as well
k   <- 12
gdk <- null_distribution(cxT, k, B = 50, B_full = 10)$gd_ref
st  <- sel_truncation_cap(cxF, k, cap = 3)   # a valid starting selection
set.seed(1); wts <- runif(cxF$n_lines)
# Line merit as ocs_round() defines it: mean index of the hybrids a line parents.
merit <- vapply(seq_len(cxF$n_lines), function(l)
  mean(cxF$index[cxF$parents[, 1] == l | cxF$parents[, 2] == l]), numeric(1))

runs <- function(e) tryCatch({ force(e); "runs" },
                             error = function(err) paste0("ERROR: ", conditionMessage(err)))
tab_ffree_df <- data.frame(
  Route = c("`theta_state()` / `theta_swap()`", "`fast_theta()`",
            "`sel_truncation_cap()`", "`decode_lines()`", "`sel_de_fast()`",
            "`ocs_quadprog()`", "`ocs_bound()`",
            "`sel_local_search(start = st)`", "`sel_local_search(start = NULL)`",
            "`theta_group()` / `alpha_loss()`", "`null_distribution()`",
            "`sel_greedy()`", "`ocs_round()`"),
  `On a ctx with no f` = c(
    runs(theta_swap(theta_state(st, cxF), st[1], setdiff(seq_len(cxF$N), st)[1], cxF)),
    runs(fast_theta(st, cxF)),
    runs(sel_truncation_cap(cxF, k, cap = 3)),
    runs(decode_lines(wts, cxF, k)),
    runs(suppressWarnings(sel_de_fast(cxF, k, gdk, am, NP = 20, itermax = 10))),
    runs(ocs_quadprog(cxF$fL, merit, lambda = 1, upper = 1)),
    runs(suppressWarnings(ocs_bound(cxF, k, am, gdk, iters = 200, max_doublings = 1L))),
    runs(sel_local_search(cxF, k, am, gdk, start = st, iters = 500, seed = 1)),
    runs(sel_local_search(cxF, k, am, gdk, iters = 500, seed = 1)),
    runs(theta_group(st, cxF)),
    runs(null_distribution(cxF, k, B = 20, B_full = 5)),
    runs(sel_greedy(cxF, k, w = 1)),
    runs(ocs_round(cxF, k, am, gdk, bound = NA_real_))),
  check.names = FALSE)
knitr::kable(tab_ffree_df, row.names = FALSE)

# The f-free replacement for null_distribution(): the same resampling, scored
# with fast_theta() instead of theta_group(). Same seed, same draws, same gd_ref.
set.seed(7)
gd_free <- mean(replicate(50, 1 - fast_theta(sample.int(cxF$N, k), cxF)))
stopifnot(all.equal(gd_free, gdk))

# What the matrix was buying the local search: only the starting point.
objs <- c(
  with_f_start_NULL = attr(sel_local_search(cxT, k, am, gdk, iters = 500, seed = 1),
                           "objective"),
  no_f_start_given  = attr(sel_local_search(cxF, k, am, gdk, start = st, iters = 500,
                                            seed = 1), "objective"))

#' 
#' Read the second column of @tbl-advanced-ffree before designing a pipeline around the
#' scaling recipe of @sec-scaling. The incremental swap, the line decoder, the line-space quadratic programme
#' and the Lagrangian bound are genuinely `f`-free, and so is `sel_local_search()`
#' **once it is given an explicit `start =`**: on this instance it reaches
#' `r fmt(objs[["no_f_start_given"]], 4)` against
#' `r fmt(objs[["with_f_start_NULL"]], 4)` for the default warm start with `f`
#' present, a difference of
#' `r fmt(objs[["with_f_start_NULL"]] - objs[["no_f_start_given"]], 4)` in the
#' objective after 500 moves. On this instance the matrix bought a starting point and
#' little else. That is one instance, not a guarantee -- the greedy warm start is there
#' because at book and production scale it is worth having.
#' 
## -----------------------------------------------------------------------------
#| label: f-free-assert
#| include: false
# The prose below states what the table prints; the render breaks if it stops being true.
tab_ffree <- tab_ffree_df
msg <- setNames(tab_ffree[["On a ctx with no f"]], tab_ffree[["Route"]])
named <- c("`theta_group()` / `alpha_loss()`", "`null_distribution()`",
           "`sel_local_search(start = NULL)`", "`ocs_round()`")
stopifnot(all(grepl("ctx[[\"f\"]] (hybrid coancestry) is missing", msg[named], fixed = TRUE)),
          startsWith(msg[["`sel_greedy()`"]], "ERROR: "),
          !grepl("(hybrid coancestry) is missing", msg[["`sel_greedy()`"]], fixed = TRUE))

#' 
#' `sel_greedy()` is the one failure that is not a named message: it opens with
#' `f <- ctx[["f"]]` and dies on a `NULL`, with R's own error (`argument is of length
#' zero` at the time of writing; a chunk of this section asserts only that it is an error,
#' not the named one). The four others -- `theta_group()` and through it
#' `gene_diversity()` and `alpha_loss()`, which reach `null_distribution()`,
#' `ocs_round()`'s per-$\lambda$ frontier and `sel_local_search()` at its documented
#' default of `start = NULL` -- stop with `ctx[["f"]] (hybrid coancestry) is missing`,
#' a guard in `theta_group()` (`R/01_metrics.R`). `ls_warm_start()` guards the greedy
#' branch with a test that `ctx[["f"]]` is a matrix of $N$ rows, but the ranking that
#' follows scores every candidate with `alpha_loss()`, and that call stops. So the
#' table says what the package does today: a loud failure, with a name, wherever `f`
#' is needed. The package reads the matrix as `ctx[["f"]]` and not `ctx$f` for the
#' reason @sec-choosing gives in its callout on two implementation traps: R's `$` partial-matches, so `ctx$f` on a
#' context without `f` would have returned `ctx$fL`, an $L \times L$ matrix. That is
#' history, not a measurement of the current code, and it is the reason the guard
#' exists.
#' 
#' So the honest scaling recipe has two branches. If `f` fits, form it: the
#' benchmark of @sec-advanced-headtohead does, on purpose, and the whole chapter's numbers come from
#' that branch. If it does not fit, the `f`-free subset is the *whole* pipeline
#' you get -- `sel_truncation_cap()` for a starting plan, `fast_theta()` over
#' random subsets for `gd_ref` in place of `null_distribution()` (same seed, same
#' draws, the same `gd_ref` to machine precision, which the chunk above asserts),
#' `sel_local_search(start = ...)` and `sel_de_fast()` for the search,
#' `ocs_quadprog()` and `ocs_bound()` for the contributions and the bound -- and
#' the greedy sweep, the resampled null and the rounding route are simply not
#' available.
#' 
#' ### The head-to-head at production scale {#sec-advanced-headtohead}
#' 
#' Nothing broke at 10,000 and nothing here claims it did: the
#' benchmark of @tbl-advanced-benchmark-production forms the `r fmt(scal$f_GB[scal$N == 10000], 3)` GiB matrix on purpose, and the hybrid route
#' still evaluates in
#' `r fmt(scal$us_hybrid[scal$N == 10000], 0)` us. The wall is further out, and
#' it is documented rather than predicted -- at $N = 22{,}500$ the matrix is
#' `r fmt(scal$f_GB[scal$N == 22500], 1)` GiB and @sec-choosing's cost benchmark
#' declines to form it at all, so every metric that needs it has no timing entry
#' at that scale. The line route has one.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-benchmark-production
#| echo: false
#| tbl-cap: "Benchmark production scale: N = 10,000 from 100 + 100 lines, n_sel = 200, 1% budget, mean over the optimiser seeds 1 to 3 on one simulated dataset; deterministic rows (greedy, greedy_cap, ocs_round, ocs_round_cap) are identical runs and every capped row has a seed standard deviation of 0."
p <- bench[bench$scale == "production", ]
pa <- aggregate(cbind(index, alpha, Ne_parents, max_line, secs) ~ method, p, mean)
pa$alpha <- 100 * pa$alpha
names(pa) <- c("method", "index", "loss %", "Ne parents", "max uses", "seconds")
knitr::kable(pa[order(-pa$index), ], digits = 3, row.names = FALSE)

#' 
#' Two things in @tbl-advanced-benchmark-production are worth more than the ranking.
#' 
#' **The cap binds, the budget does not.** At the benchmark production scale every
#' capped method reaches essentially the same index (the spread is given below), at a
#' diversity loss far inside the 1% allowed. With
#' $n = 200$ over $L = 200$ lines the mean usage is already 2, so a cap of 4 leaves
#' very little to choose; the restriction that is actually deciding the plan is the
#' one nobody wrote a budget for. Check `max_line` and realised `alpha` together
#' before concluding that a diversity constraint is doing any work.
#' 
## -----------------------------------------------------------------------------
#| label: capped-tie
#| include: false
caps_m <- c("greedy_cap", "tempering_cap", "de_hybrid_cap", "de_lines_cap", "ocs_round_cap")
cp <- vapply(caps_m, bmean, numeric(1), scale = "production")
cb <- vapply(caps_m, bmean, numeric(1), scale = "book")
sd_cap <- vapply(caps_m, function(m) sd(bv("production", m)), numeric(1))
stopifnot(all(sd_cap == 0))     # no seed dispersion in any capped production row
sd_cap_b <- vapply(caps_m, function(m) sd(bv("book", m)), numeric(1))
stopifnot(all(sd_cap_b < 1e-12))   # nor in any capped book-scale row
# the margin that the word 'tie' means in the text below (a convention, not a test)
tie_margin <- 0.001
stopifnot(max(cp) - min(cp) < tie_margin,                  # production: within it
          cb[["greedy_cap"]] - cb[["tempering_cap"]] > tie_margin,  # book: not
          sprintf("%.4f", max(cp) - min(cp)) == "0.0002")  # the figure quoted at the end of the section
# the order printed in the text: greedy_cap > both capped DE-hybrid and tempering
# > line-encoded DE and ocs_round (the last two equal)
stopifnot(cb[["greedy_cap"]] > cb[["de_hybrid_cap"]],
          cb[["de_hybrid_cap"]] > cb[["de_lines_cap"]],
          isTRUE(all.equal(cb[["de_lines_cap"]], cb[["ocs_round_cap"]])),
          isTRUE(all.equal(cb[["de_hybrid_cap"]], cb[["tempering_cap"]])))

#' 
#' Read down the capped rows only, as the rule given for @tbl-advanced-benchmark-book requires.
#' At the benchmark production scale the five capped routes span
#' `r sprintf("%.4f", max(cp) - min(cp))` index units
#' (`greedy_cap` `r sprintf("%.4f", cp[["greedy_cap"]])`, the other four
#' `r sprintf("%.4f", min(cp))`), each with a seed standard deviation of 0
#' (asserted above), on one dataset. With no seed dispersion that difference is
#' deterministic on this dataset, `greedy_cap` ahead by
#' `r sprintf("%.4f", cp[["greedy_cap"]] - min(cp))`, exactly as the book-scale differences
#' below are. "Tie" in this chapter is therefore a statement about a margin and not about
#' dispersion: routes are called tied when their mean indices lie within
#' `r tie_margin` index units, about `r fmt(100 * tie_margin / cp[["greedy_cap"]], 2)`% of the
#' index of these rows. The margin is a convention named here, not derived from any
#' sampling distribution (there is none to derive it from), and the five production rows
#' satisfy it (asserted above) while the book-scale rows do not. They differ in cost, `greedy_cap` taking
#' `r fmt(bsec("production", "greedy_cap"), 3)` s and `tempering_cap`
#' `r fmt(bsec("production", "tempering_cap"), 3)` s. At the benchmark book scale the same five rows do not tie. They span
#' `r fmt(1000 * (max(cb) - min(cb)), 1)` thousandths: `greedy_cap`
#' `r sprintf("%.4f", cb[["greedy_cap"]])` in `r fmt(bsec("book", "greedy_cap"), 3)` s,
#' `de_hybrid_cap` `r sprintf("%.4f", cb[["de_hybrid_cap"]])` and `tempering_cap`
#' `r sprintf("%.4f", cb[["tempering_cap"]])` (`r fmt(bsec("book", "tempering_cap"), 3)` s for
#' the latter), and `de_lines_cap` `r sprintf("%.4f", cb[["de_lines_cap"]])` and
#' `ocs_round_cap` `r sprintf("%.4f", cb[["ocs_round_cap"]])`, the two lowest. Every
#' one of these rows has a seed standard deviation of 0 (asserted above), so the
#' differences are not seed noise; they are differences between routes on one
#' dataset. Interpretation, and what limits it: at the production scale no capped
#' route is distinguished from the others on index at that margin; at the book scale the capped greedy
#' sweep is highest, by
#' `r fmt(1000 * (cb[["greedy_cap"]] - cb[["tempering_cap"]]), 1)` thousandths over the
#' capped hybrid DE and the capped tempering and by
#' `r fmt(1000 * (cb[["greedy_cap"]] - cb[["ocs_round_cap"]]), 1)` over `ocs_round(max_use)`
#' and the line-encoded capped DE. A seed standard deviation of 0 measures nothing
#' about the dataset, and with one dataset per scale this file does not resolve whether
#' that order, or the agreement within the margin at production, holds on other datasets or for capped problems
#' in general.
#' 
#' The diagnosis is arithmetic and takes a minute: compare $2n/L$, the mean number
#' of uses per line, against the cap. If the cap is a small multiple of the mean,
#' it is the binding restriction and the diversity budget is decoration. Raising
#' the cap, or enlarging the candidate pool, changes the plan; tightening the
#' budget does not, until it starts to bind.
#' 
#' **The bound does not converge at this scale, and no gap is reported.**
#' `ocs_bound()` doubles its iteration count until the value stops moving by more than
#' a relative 0.001 (the stalling criterion of @sec-bound). At the benchmark book scale
#' it stops; at $N = 10{,}000$ it did not within the one doubling the benchmark allowed
#' (4,000 and 8,000 iterations, 9 multipliers; @tbl-advanced-bound-converged). The reason offered is the step size,
#' $1/(2\lambda \max_i \sum_j f_{ij})$, whose denominator grows with $N$, so that the same
#' iteration count that converges on 625 candidates is not enough on 10,000; this was
#' not tested by running more doublings at this scale. An under-converged relaxation
#' reports $V(\lambda)$ *too small*, which makes the "bound" too small, and it stops
#' bounding anything.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-bound-converged
#| echo: false
#| tbl-cap: "Where `ocs_bound()` converged by its stalling criterion (the file's column `bound_certified`). Where it is FALSE the benchmark writes NA for every gap against it."
cert <- unique(bench[, c("scale", "N", "bound", "bound_certified")])
knitr::kable(cert, digits = 4, row.names = FALSE,
  col.names = c("scale", "N", "bound", "converged"))

#' 
#' That is a finding, not a defect, and it is why the function warns and why the
#' benchmark records no gap at this scale. At the benchmark production scale you have
#' heuristics that agree with each other (in the capped case, to within 0.0002 index units on this dataset, inside the
#' 0.001 margin of the capped-routes paragraph above) and no
#' bound that has converged, so no statement of how close any of them is: the honest
#' position, and a better one than a gap column computed from a quantity that is not a
#' bound.
#' 
#' ## Multi-objective, and why not NSGA-II
#' 
#' `stage2_select()` traces the frontier by sweeping `alpha_max` and running a
#' full optimisation at each point: the budget is a constraint, not a weight
#' (@sec-ocs), so each point is a plan a committee can approve, expressed in a budget
#' rather than in an exchange rate.
#' 
#' A saving is available that is not a Pareto algorithm. Consecutive budgets have
#' nearly identical solutions -- an expectation, not measured here -- so the plan
#' found at $\alpha_k$ is the obvious warm start for $\alpha_{k+1}$, and
#' `stage2_select()` does not pass one: its call to `sel_de()` carries no `start`
#' argument (`R/11_stage2.R`). `sel_local_search()` already has a `start =` argument.
#' 
#' NSGA-II (non-dominated sorting genetic algorithm II) [@deb2002] returns an approximation of the whole front in one run. I have
#' not run it on this problem, so nothing in this book says it would give worse plans
#' per point than the sweep. The reason not to reach for it is narrower: it is built for
#' trade-offs with no interpretable scale for one objective, and here the trade-off is
#' already parameterised by a budget the breeder chooses, so a front is not what is
#' being asked for. That is a design argument, not a measurement.
#' 
#' ## What not to reach for {#sec-notreach}
#' 
#' **Reinforcement learning.** @younis2024 cast a breeding programme as a Markov
#' decision process, with the number of crosses made in each generation as the action
#' and a delayed reward, in an environment they name BREEDING GYM. Those are sequential
#' decisions with delayed reward. Choosing 200 hybrids from a fixed candidate pool,
#' once, with a closed-form objective, is not. The tool is aimed at a different
#' question.
#' 
#' **Bayesian optimisation.** Built for expensive black-box objectives with a handful
#' of continuous inputs. The swap that `sel_local_search()` uses costs
#' `r fmt(scal$us_swap[scal$N == 10000], 1)` microseconds at $N = 10{,}000$ (a
#' state update, not the objective); the fitness a surrogate-based method would call
#' costs `r fmt(scal$us_hybrid[scal$N == 10000], 0)` to
#' `r fmt(scal$us_lines[scal$N == 10000], 0)` microseconds (@tbl-advanced-eval-cost); and the problem has 200 integer dimensions at the target scale.
#' I did not run a Bayesian optimiser; this is an argument from cost and dimension.
#' 
#' **Sampling from a determinantal point process.** Determinantal point processes (DPPs)
#' [@kulesza2012] are the natural probabilistic model of a diverse subset, and
#' $\log\det(\mathbf{I} + \beta\mathbf{f}_S)$, with $\beta \ge 0$ a free scale, is submodular, as
#' @chen2018 state for the DPP log-probability. That it is also monotone and
#' non-negative is the book's own argument, not theirs: $\mathbf{f}$ is positive
#' semi-definite (the Gram form of @sec-advanced-gram), so every eigenvalue of
#' $\mathbf{I} + \beta\mathbf{f}$ is at least 1, and so is that of each of its
#' principal submatrices; the Schur complement of an added element is the reciprocal
#' of a diagonal entry of an inverse whose eigenvalues are at most 1, hence at least 1,
#' and each added element adds at least $\log 1 = 0$. Monotone, non-negative and
#' submodular, the greedy then carries the $1 - 1/e$ guarantee of @nemhauser1978 under
#' a cardinality constraint -- a guarantee for that objective, which is not the one the
#' programme constrains. *Sampling* from a DPP gives diversity in distribution when
#' what is wanted is a single best plan, and the log-determinant lens is not $\theta$:
#' adopting it would change the quantity the programme is constraining. The
#' assumption that the constraint pins one lens, $\theta$, chosen deliberately
#' (@sec-ocs, assumption 5; @sec-combinatorial, assumption 3), applies.
#' 
## -----------------------------------------------------------------------------
#| label: dpp-eigenvalues
# The eigenvalue half of the argument on this instance: I + beta f has all
# eigenvalues >= 1 (f is positive semi-definite), here for beta = 1.
ev_dpp <- eigen(diag(ctx$N) + ctx[["f"]], symmetric = TRUE, only.values = TRUE)$values
stopifnot(min(ev_dpp) >= 1 - 1e-10)
c(min_eigenvalue = min(ev_dpp))

#' 
#' ## Which method to use
#' 
#' @tbl-advanced-which gives the route for each situation; the protocol after it gives the
#' order in which to run them.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-advanced-which
#| echo: false
#| tbl-cap: "Which route to use in each situation, with the figures of this chapter's benchmarks behind each recommendation (one simulated dataset per scale; benchmark means over the optimiser seeds 1 to 3, live results at the book scale)."
knitr::kable(data.frame(
  Situation = c("Any scale, first thing to run",
                "A budget and a per-line cap, benchmark production scale",
                "A budget the $\\omega$ grid steps over (no cap)",
                "An $N_{e,\\text{par}}$ floor that binds",
                "You need to know whether to keep optimising",
                "You need to know the true optimum",
                "Contributions are genuinely continuous"),
  Use = c("`sel_truncation_cap()`, then `sel_greedy()` swept over $\\omega$ on a grid that starts well below the crossover (@sec-combinatorial)",
          sprintf(paste("`sel_greedy(max_use = cap)` swept over $\\omega$: at the benchmark production",
                        "scale it is within 0.001 index units of `sel_local_search(max_use = cap, mode = \"tempering\")`,",
                        "both capped DEs and `ocs_round(max_use = cap)` (spread %s index units, seed",
                        "standard deviation 0, one dataset; the margin is a convention, @sec-advanced-headtohead),",
                        "so there the routes differ in cost, not in index at that margin",
                        "(`ocs_round_cap` %s s against `greedy_cap` %s s, and both need the $N \\times N$",
                        "matrix); at the benchmark book scale the same rows span %s thousandths, `greedy_cap`",
                        "highest and `ocs_round_cap` and the line-encoded capped DE lowest, with no seed",
                        "dispersion, also on one dataset"),
                  sprintf("%.4f", max(cp) - min(cp)),
                  fmt(bsec("production", "ocs_round_cap"), 3),
                  fmt(bsec("production", "greedy_cap"), 3),
                  fmt(1000 * (max(cb) - min(cb)), 1)),
          sprintf(paste("`sel_local_search()`, with `start = NULL` when `f` exists: at 30,000 moves",
                        "the hill climber and the annealing reach %s and %s (benchmark book scale, mean of 3",
                        "seeds) against %s for the best feasible plan of the 60-value greedy grid (live,",
                        "one dataset). `sel_de()` needs a larger evaluation budget to pass the",
                        "greedy plan (@sec-combinatorial-budget); the local search was not compared with it there"),
                  fmt(bmean("book", "hill"), 3), fmt(bmean("book", "anneal"), 3), fmt(g_fine, 3)),
          sprintf(paste("`sel_de_fast()` is the only route that accepts an `ne_par_min` argument, but in the run",
                        "above it did not meet a floor of 30 (N_e,par %s), while a capped greedy sweep",
                        "filtered on `ne_parents()` did (index %s). `sel_local_search()` has no such argument",
                        "-- an implementation gap, not a limit of the swap. Pool balance cannot bind"),
                  fmt(de_fast[["Ne_par"]][3], 1), fmt(max(gt$index[meets]), 3)),
          "`ocs_bound()` -- an upper limit if `converged` (its stalling criterion) is TRUE; a small gap says little more can be gained on this dataset and budget",
          "`sel_exact()` on a small subsample -- an oracle, not a pipeline",
          "`ocs_quadprog()` -- @sec-ocs"),
  check.names = FALSE), escape = FALSE)

#' 
#' As a protocol at production scale:
#' 
#' 1. Build `ctx` through `fast_ctx()`, and decide up front whether the
#'    $N \times N$ matrix is going to exist, because that decision selects the
#'    rest of the protocol (@sec-ffree). `ctx$fL` and `ctx$parents` are required
#'    by every fast route; `f` is required by `null_distribution()`,
#'    `sel_greedy()`, `ocs_round()` and `sel_local_search()`'s automatic warm
#'    start. At $8N^2$ bytes it fits at $N = 10{,}000$ and the benchmark of
#'    @sec-advanced-headtohead forms it. If it does not fit, steps 2-4 change as noted, and the `f`-free
#'    subset is what you have.
#' 2. Get `gd_ref` from a resampling at the target `n_sel`, and set
#'    $\alpha_{\max}$ below the attainable ceiling (@sec-ocs). With no `f`,
#'    `null_distribution()` is unavailable and the resampling has to be
#'    `mean(replicate(B, 1 - fast_theta(sample.int(ctx$N, n_sel), ctx)))`, which
#'    is `fL`-only and returns the same `gd_ref` at the same seed (@sec-ffree).
#' 3. Run the sweeps that cost milliseconds -- `sel_truncation_cap()` and, when
#'    `f` exists, `sel_greedy()` over an $\omega$ grid spanning your data's crossover,
#'    passing `max_use` if a cap applies -- and record what they achieve. They are
#'    the baseline every later number is judged against. Under a cap, the capped
#'    greedy sweep is within 0.001 index units of the other capped routes at the benchmark
#'    production scale (the margin of @sec-advanced-headtohead) and is the highest of
#'    them at the benchmark book scale (@tbl-advanced-benchmark-book,
#'    @tbl-advanced-benchmark-production and the capped-routes paragraph of
#'    @sec-advanced-headtohead), on one dataset per scale.
#' 4. Run `sel_local_search()` for as many seconds as you are willing to spend,
#'    with the cap passed as `max_use` rather than enforced afterwards. With `f`
#'    present, leave `start = NULL` and let it build the warm start; with no `f`,
#'    pass `start = sel_truncation_cap(...)` explicitly, which is the only
#'    configuration of this route that runs without the matrix. The mode is the
#'    least consequential choice in this list: over 20 seeds `"hill"` and
#'    `"anneal"` are `r fmt(abs(ls_tab[["hill_minus_anneal_e3"]][1]), 1)` and
#'    `r fmt(abs(ls_tab[["hill_minus_anneal_e3"]][2]), 1)` thousandths of an index unit
#'    apart at 20,000 and 30,000 moves, with a standard error of about one thousandth
#'    and no resolved sign, while `"tempering"` is below both in every seed. Take the
#'    simplest one unless your own data says otherwise -- but those runs are
#'    *uncapped*, and the only mode benchmarked under a cap is `"tempering"`.
#' 5. Compute `ocs_bound()` and check its `converged` attribute. Converged and the
#'    gap small: the gap is the most further search can gain on this dataset and
#'    budget, if the stalling criterion is to be trusted; stopping is a decision for
#'    the programme. Converged and the gap large: keep going. Not converged: report no
#'    gap at all, and judge the plan by agreement between independent methods
#'    instead.
#' 6. Validate the returned plan on the lens the constraint does not pin --
#'    `F_drift` and allelic richness -- and on the pool decomposition, before it
#'    is used (@sec-case-study).
#' 
#' What the chapter measured, and what it did not. The problem is $L$-dimensional
#' in its *state*: $\theta$ is a function of the line-usage vector and of nothing
#' else. What was measured to follow from that is cost: an $O(L)$ swap
#' (`r fmt(scal$us_swap[scal$N == 10000], 1)` us at $N = 10{,}000$ against
#' `r fmt(scal$us_hybrid[scal$N == 10000], 0)` to `r fmt(scal$us_lines[scal$N == 10000], 0)` us
#' for a full fitness evaluation, @tbl-advanced-eval-cost), a
#' `r fmt(8 * bs["production", "L"]^2 / 2^20, 1)` MiB matrix and a 200-variable
#' contributions programme. What was not measured is how much of any difference in
#' index between routes is due to the state: the swap-based local search differs from
#' `sel_de()` in neighbourhood, acceptance rule and warm start together, so that
#' comparison is of whole algorithms (@sec-localsearch), and no experiment here ranks
#' the state collapse against the other changes. The comparison closest to isolating
#' the encoding, `sel_de()` at $n_{sel} = 200$ against `sel_de_fast()` at $L = 200$, at
#' 30,000 evaluations on boxes of the same width, still differs in the seeding and the
#' decoder of `sel_de_fast()` (@sec-defast-restrictions); it favours `sel_de()` uncapped, by
#' `r fmt(dp[["difference"]][1], 2)` (s.e. `r fmt(dp[["se"]][1], 3)`) at the benchmark book scale and
#' `r fmt(dp[["difference"]][2], 2)` (s.e. `r fmt(dp[["se"]][2], 3)`) at the benchmark production
#' scale (the production difference is not resolved by three seeds), on one dataset per scale (capped: `r fmt(dp[["difference"]][3], 3)` and
#' `r fmt(dp[["difference"]][4], 3)`). The guarantees, the Lagrangian bound
#' (converged at the benchmark book scale, not at production) and the oracle
#' ($N = 36$ only) bound how far a plan can be from the optimum where they apply, and
#' no further.
#' 
#' > Name the structure before choosing the algorithm: it changes what a move costs
#' > (`r fmt(scal$us_swap[scal$N == 10000], 1)` us for the swap, against
#' > `r fmt(scal$us_hybrid[scal$N == 10000], 0)` us for a hybrid-encoding evaluation at
#' > $N = 10{,}000$) and, in the line encoding, what an evaluation costs
#' > (`r fmt(scal$us_lines[scal$N == 10000], 0)` us: more, not less). Whether it also
#' > changes the index a method reaches is a separate claim that this chapter does not
#' > settle. The one comparison near it, `sel_de()` against `sel_de_fast()`, still differs
#' > in seeding and decoder as well as in encoding: uncapped, `sel_de()` is ahead by
#' > `r fmt(dp[["difference"]][1], 2)` (s.e. `r fmt(dp[["se"]][1], 3)`) at the benchmark book
#' > scale, which three seeds resolve, and by `r fmt(dp[["difference"]][2], 2)`
#' > (s.e. `r fmt(dp[["se"]][2], 3)`) at the benchmark production scale, which they do not;
#' > capped, the differences are `r fmt(dp[["difference"]][3], 3)` and
#' > `r fmt(dp[["difference"]][4], 3)`, and a standard error of 0 does not mean the
#' > difference is known. One dataset per scale throughout.
