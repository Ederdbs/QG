#' # Combinatorial selection {#sec-combinatorial}
#' 
# 10-combinatorial-selection -- standalone script of the chapter 10-combinatorial-selection.qmd
# Book: https://ederdbs.github.io/QG/10-combinatorial-selection.html
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
ctx <- simulate_data(book_cfg)
n_sel <- 60
null <- null_distribution(ctx, n_sel, B = 400, B_full = 60)
de <- read.csv(book_data("de_constraints.csv"))
bench <- read.csv(book_data("search_benchmark.csv"))
# The two scales of the benchmark of @sec-advanced, as the file records them.
bs <- unique(bench[, c("scale", "N", "L", "n_sel", "cap")])
rownames(bs) <- bs$scale
# One column of one method at one scale, ordered by seed, so that two methods can
# be differenced seed by seed.
bv <- function(scale, method, col = "index") {
  x <- bench[bench$scale == scale & bench$method == method, ]
  x[[col]][order(x$seed)]
}
bmean <- function(scale, method, col = "index") mean(bv(scale, method, col))
bpair <- function(scale, m1, m2) {          # paired difference over seeds
  d <- bv(scale, m1) - bv(scale, m2)
  c(d = mean(d), se = sd(d) / sqrt(length(d)), n = length(d))
}
# Limits of the cached run of de_constraints.csv, as @sec-choosing-search states
# them: the file records outcomes (loss_pct, Ne_parents, max_use, pool_imbalance),
# not the limits.
lim <- list(loss_pct = 0.5, ne_par = 50, k_max = 6, pool = 0.05)
# The three (NP, itermax) configurations of sel_de() run in @sec-combinatorial-budget:
# the chapter's own, one with itermax four times larger, and the printed defaults of
# sel_de() (read from its formals). The evaluation budget is nominal: NP x itermax.
# The five-budget frontier runs NP = 100, itermax = 180.
de_cfg <- data.frame(label = c("chapter", "4x chapter", "default"),
                     NP = c(120, 120, eval(formals(sel_de)[["NP"]])),
                     itermax = c(250, 1000, eval(formals(sel_de)[["itermax"]])))
de_cfg[["evaluations"]] <- de_cfg$NP * de_cfg$itermax
ev_front <- 100 * 180
ev <- function(x) format(x, big.mark = ",", scientific = FALSE)

#' 
#' @sec-ocs posed the problem -- choose $n$ of $N$ hybrids to maximise the mean index
#' $\bar u_S$ subject to $\alpha(S) \le \alpha_{\max}$ (@eq-ocs-problem) -- and
#' bounded it from above (@eq-ocs-bound). It left to this chapter the discrete side:
#' the decoder that turns a real-valued optimiser vector into $n$ distinct hybrids,
#' the per-line cap `max_use`, and the order in which to try methods. The chapter
#' builds the strategies from the two that need no optimiser (truncation, and
#' truncation under a per-line cap), through a greedy swept over an index weight, to
#' differential evolution (DE), and measures each at the book scale.
#' 
#' What it finds depends on the evaluation budget of the DE, and the introduction
#' says so rather than promise otherwise. Evaluations are counted nominally as
#' `NP` $\times$ `itermax`. The chapter runs `sel_de()` at
#' `r ev(de_cfg$evaluations[1])` evaluations (`NP` = `r de_cfg$NP[1]`, `itermax` =
#' `r de_cfg$itermax[1]`) and, for its five-budget frontier, at `r ev(ev_front)`
#' (`NP` = 100, `itermax` = 180); the printed defaults of `sel_de()` are
#' `NP` = `r de_cfg$NP[3]`, `itermax` = `r de_cfg$itermax[3]`, that is
#' `r ev(de_cfg$evaluations[3])`. At the chapter's budgets, and with the default
#' warm start, the mean of the DE's index over repeated seeds is below the best
#' feasible greedy plan at each of the five diversity budgets tried
#' (@sec-combinatorial-frontier). At the 1% diversity budget, the only one run at a
#' larger evaluation budget, that order reverses at `r ev(de_cfg$evaluations[2])` and at
#' `r ev(de_cfg$evaluations[3])` evaluations (@sec-combinatorial-budget); the other
#' four diversity budgets were not run above `r ev(ev_front)`. The warm start is
#' worth a measured amount over a cold start at `r ev(de_cfg$evaluations[1])`
#' evaluations, the only budget at which a cold start was run, and the DE does
#' improve on a greedy plan when that plan is among its seeds
#' (@sec-combinatorial-warm; 1% budget, `r ev(de_cfg$evaluations[1])` evaluations).
#' What the DE offers at the chapter's budgets is a budget as its interface; the last
#' section states what the three budgets do and do not support, within the limits of
#' these measurements, which are one simulated dataset at the book scale.
#' 
#' The decision is a concrete one, and it is the last of a cycle in a
#' cross-pollinated crop. Two heterotic pools, A and B, hold $L_A$ and $L_B$
#' inbred (or doubled-haploid) lines. Every candidate is one cross
#' $A_a \times B_b$, so the candidate set is the factorial $N = L_A \times L_B$ --
#' in maize, the set of single crosses that could be made from the current elite
#' lines without introducing anything new. The $n$ you keep are the crosses that
#' go forward: into multi-location testing, into seed increase, and -- through
#' their parents -- into the next recycling cycle. Keeping too few distinct
#' parents is not a statistical inconvenience, it is a decision to narrow the pool
#' that the programme will breed from next.
#' 
#' **What has to be in hand before any line of this chapter runs** is the
#' three-object contract of @sec-simulating-crosses:
#' 
#' - `X`, the $N \times m$ hybrid marker matrix, coded $\{0, 0.5, 1\}$ as the
#'   average of the two homozygous parents;
#' - `f`, the $N \times N$ molecular coancestry of @caballero2002, values in
#'   $[0, 1]$, built from `X` and never from a centred genomic relationship matrix
#'   (@sec-why-not-g);
#' - `hybrids`, carrying each cross's parents and its predicted traits, from which
#'   `build_ctx()` forms the single index `ctx$index`, standardised to mean 0 and
#'   unit variance over the candidate set (@sec-simulating-crosses).
#' 
#' **Assumptions, declared once and not violated afterwards.** They are those of
#' @sec-ocs, restated for the claims made here.
#' 
#' 1. Parent lines are homozygous, so a hybrid's genotype is the mean of its parents
#'    and `X` takes only the three values above. Markers are treated as neutral.
#' 2. **The index is the truth.** Every index value below is `ctx$index`, computed
#'    from known marker effects, not a prediction. Nothing is re-predicted inside an
#'    optimiser, so the plans of this chapter are not evaluated against the error
#'    that a real index carries. @sec-choosing-error simulates one scenario of such
#'    error, correlated with relatedness; that scenario is not used here and is not
#'    a property the chapter relies on.
#' 3. **The constraint pins one lens.** $\theta$, $GD$ and $\alpha$ are the
#'    homozygosity lens; $F_{\text{drift}}$, anchored on the frozen frequencies
#'    `ctx$p0`, is not pinned by $\alpha$ (@sec-genomic-era). `ctx$p0` is the
#'    allele-frequency base of the candidate set, set once in `build_ctx()`.
#' 4. Diversity loss $\alpha$ is always measured against a random subset of *the
#'    same size* `n_sel` (@sec-baseline), never against the whole candidate set.
#' 5. Dominance appears nowhere in the objective: it is already inside the
#'    predicted hybrid performance, and the between-pool divergence that generates
#'    heterosis is a quantity to *preserve*, not to minimise (@sec-heterosis).
#' 
#' **Scale.** "Book scale" is 25 + 25 lines, 2000 markers, simulation seed 1,
#' $N =$ `r ctx$N`, $n =$ `r n_sel`, and is what every number below refers to unless
#' a sentence names another scale. Four other scales are named where they occur,
#' because the word "production" has been used for more than one of them: the
#' *benchmark book scale* and the *benchmark production scale* of
#' `search_benchmark.csv` (@sec-advanced; regenerated in this repository by
#' `book/scripts/regenerate.R search`), which the file records as
#' $N =$ `r bs["book", "N"]`, $L =$ `r bs["book", "L"]`, $n =$ `r bs["book", "n_sel"]`,
#' cap `r bs["book", "cap"]` and $N =$ `r format(bs["production", "N"], big.mark = ",")`,
#' $L =$ `r bs["production", "L"]`, $n =$ `r bs["production", "n_sel"]`,
#' cap `r bs["production", "cap"]`; the *cached-run scale* of `de_constraints.csv`,
#' $N =$ `r format(max(de$dim), big.mark = ",")` hybrids with $L = 120$ lines
#' (an external file, below); and the *package production scale*,
#' 71 + 71 lines and $N =$ `r format(71^2, big.mark = ",")`, used only to count
#' dimensions. The benchmark book scale has this chapter's $N$, $L$ and $n$ but a
#' cap of `r bs["book", "cap"]`, where this chapter's capped truncation uses
#' `r ceiling(2 * n_sel / ctx$n_lines) + 1`.
#' 
#' **The per-line usage cap, defined once.** A line $a$ is *used* once by each
#' selected hybrid it parents, so the number of uses is $k_a$, with
#' $\sum_a k_a = 2n$ (@sec-notation). The cap, $k_{\max}$, is the largest $k_a$ a
#' plan may have: at most $k_{\max}$ of the $n$ selected hybrids may share a line as
#' a parent. It is a count of crosses, not of seeds or plants. The argument that
#' carries it is called `cap` in `sel_truncation_cap()` and `max_use` in
#' `sel_greedy()`, `make_fitness()`, `sel_de()` and `stage2_select()` (and in
#' `decode_lines()`, `make_fitness_fast()`, `sel_de_fast()`, `sel_local_search()`
#' and `ocs_round()` of @sec-advanced); it is one quantity under two argument names.
#' `max_use = NULL` is the default everywhere and means no cap; it reproduces the
#' behaviour before the cap existed bit for bit. `sel_truncation_cap()` has no
#' `NULL` and defaults to `ceiling(2 * n_sel / n_lines) + 1`, one above even use.
#' The realised value of a plan is `max_line_use()`, printed as `max_line`. In
#' `make_fitness()` the cap enters as the number of parent slots above $k_{\max}$,
#' summed over lines and divided by $2n$, added to the violation of $\alpha$ and
#' charged at the same penalty (`R/03_de_select.R`); in the greedy it is a
#' feasibility test on the move.
#' 
#' The instance this chapter runs on:
#' 
## -----------------------------------------------------------------------------
#| label: instance
fmt(c(candidates_N      = ctx$N,
      lines_A           = sum(ctx$pool == "A"),
      lines_B           = sum(ctx$pool == "B"),
      markers_m         = ctx$m,
      hybrids_kept      = n_sel,
      uses_per_line     = 2 * n_sel / ctx$n_lines,
      gd_ref            = null$gd_ref,
      gd_ref_sd         = null$gd_sd,
      alpha_trunc_pct   = 100 * alpha_loss(sel_truncation(ctx, n_sel), ctx, null$gd_ref)), 5)

#' 
#' Read it as a breeder would. `r n_sel` crosses are kept out of `r ctx$N`, which
#' is `r round(100 * n_sel / ctx$N, 1)`% of the factorial. The `r n_sel` crosses
#' consume $2n =$ `r 2 * n_sel` parent slots spread over `r ctx$n_lines` lines, so
#' a perfectly even plan would use each line `r 2 * n_sel / ctx$n_lines` times --
#' the scale against which any per-line cap has to be set. `gd_ref` is the gene
#' diversity of a random subset of exactly this size, with its resampling standard
#' deviation next to it. The last row is $\alpha_{\text{trunc}}$ (@sec-ocs), the
#' loss of the truncation plan: pure truncation loses
#' `r fmt(100 * alpha_loss(sel_truncation(ctx, n_sel), ctx, null$gd_ref), 2)`%
#' of `gd_ref`. A budget $\alpha_{\max} \ge \alpha_{\text{trunc}}$ constrains
#' nothing, because truncation, which maximises the index, already meets it; that
#' is the first thing to check and the subject of @sec-ocs.
#' 
#' ## Four baselines before any optimiser
#' 
#' Four families -- random, truncation, truncation under a per-line cap, and
#' greedy -- in six rows, because greedy is shown at three index weights.
#' 
## -----------------------------------------------------------------------------
#| label: baselines
set.seed(1)
sels <- list(
  random     = sel_random(ctx, n_sel),
  truncation = sel_truncation(ctx, n_sel),
  trunc_cap  = sel_truncation_cap(ctx, n_sel),
  greedy_div = sel_greedy(ctx, n_sel, w = 0),
  greedy_w1  = sel_greedy(ctx, n_sel, w = 1),
  greedy_w3  = sel_greedy(ctx, n_sel, w = 3)
)
fmt(t(sapply(sels, function(s) c(
  index      = mean_index(s, ctx),
  alpha_pct  = 100 * alpha_loss(s, ctx, null$gd_ref),
  Ns         = status_number(s, ctx),
  Ne_parents = ne_parents(s, ctx),
  max_line   = max_line_use(s, ctx)))), 3)

#' 
## -----------------------------------------------------------------------------
#| label: greedy-collapses
w_is_trunc <- c(w1 = setequal(sels[["greedy_w1"]], sels[["truncation"]]),
                w3 = setequal(sels[["greedy_w3"]], sels[["truncation"]]))
stopifnot(all(w_is_trunc))
w_is_trunc

#' 
#' Three of those six rows are the same plan. `greedy_w1` and `greedy_w3` return
#' *exactly* the truncation set (the chunk asserts it) -- same index, same
#' $\alpha$, same `max_line` -- because both index weights sit far above the
#' crossover measured in the `w-units` chunk below, where the merit term swamps the
#' coancestry term and the greedy argmax degenerates to the index ranking. Read them
#' as one row until that measurement has been made; it is the reason an
#' $\omega$ grid of round numbers is a trap.
#' 
#' Read the columns in this order, because each answers a different question and
#' three of them are routinely skipped:
#' 
#' 1. `index`, in standard deviations of the candidate set -- what the plan is
#'    worth.
#' 2. `alpha_pct`, the loss of gene diversity relative to a random subset of the
#'    same size -- what it costs, on the lens the constraint will pin. Negative
#'    means *more* diverse than random.
#' 3. `Ns`, the status number $N_s = 1/(2\theta)$ (@sec-ns). On the molecular
#'    coancestry $\mathbf{f}$ it lies in $[1/2, 1]$ and is a monotone rescaling of
#'    $\theta$, not a head count; unlike $\alpha$ it carries no reference to a
#'    random subset of the same size.
#' 4. `Ne_parents`, the effective number of parent lines, which is computed from
#'    counts alone and is the metric that catches "$\theta$ looks fine but twelve
#'    lines did all the work".
#' 5. `max_line`, the largest number of selected crosses sharing one parent, the
#'    realised $k_{\max}$ -- the operational number, because that line is a seed
#'    parent and has to be increased, maintained and, in a CMS system, converted.
#' 
#' **Truncation** is the plan of maximum mean index: the optimum with no
#' constraint, and the reference for the budget ($\alpha_{\text{trunc}}$). It is what
#' every programme does by default, and the interesting question is not whether it
#' loses diversity but how *little* index a constrained plan has to give up
#' relative to it. It is not the $n$-subset of lowest diversity (@sec-ocs): a plan
#' confined to fewer lines loses more.
#' 
## -----------------------------------------------------------------------------
#| label: truncation-not-floor
# The top n crosses among those of the first three A lines (3 x 25 = 75 crosses).
a3 <- which(ctx$ped$a %in% 1:3)
s3 <- a3[order(ctx$index[a3], decreasing = TRUE)][seq_len(n_sel)]
a_trunc <- alpha_loss(sels[["truncation"]], ctx, null$gd_ref)
a_three <- alpha_loss(s3, ctx, null$gd_ref)
stopifnot(a_three > a_trunc)
fmt(100 * c(alpha_trunc_pct = a_trunc, alpha_three_A_lines_pct = a_three), 3)

#' 
#' Truncation's `max_line` here is `r max_line_use(sels$truncation, ctx)`:
#' one line parents that many of the `r n_sel` selected crosses, against
#' `r 2 * n_sel / ctx$n_lines` under even use. That is the concentration a cap is
#' meant to remove, and it is visible without any coancestry matrix. The plan
#' confined to three A lines loses `r fmt(100 * a_three, 2)`% against truncation's
#' `r fmt(100 * a_trunc, 2)`%, so truncation is not the floor on diversity; it is
#' the reference that a gain-maximising plan never needs to go beyond.
#' 
#' **Truncation with a per-line cap** is the cheap baseline that deserves more
#' attention than it gets. It needs no coancestry matrix at all -- only counting:
#' 
## -----------------------------------------------------------------------------
sel_truncation_cap

#' 
#' The procedure, stated as a breeder would run it:
#' 
#' 1. Rank all `r ctx$N` candidate crosses by index, best first.
#' 2. Walk down the ranking. Admit a cross only if *both* its parents are still
#'    below the cap.
#' 3. Stop when `n_sel` crosses have been admitted, or when the ranking is
#'    exhausted -- in which case the returned vector is **shorter than `n_sel`**
#'    and the cap was infeasible for this set size.
#' 4. A cap $k_{\max}$ admits at most $L_A k_{\max}$ crosses through pool A and at
#'    most $L_B k_{\max}$ through pool B, so $n \le k_{\max}\min(L_A, L_B)$ is
#'    **necessary** for the walk to reach $n$: here `r n_sel` against
#'    `r min(sum(ctx$pool == "A"), sum(ctx$pool == "B")) * (ceiling(2 * n_sel / ctx$n_lines) + 1)`.
#'    It is not sufficient, because the walk is greedy and can exhaust the ranking
#'    while admissible slots remain on lines that no remaining cross uses together:
#' 
## -----------------------------------------------------------------------------
#| label: cap-feasibility
# Random complete factorials with L_A, L_B in 2..6 and cap in 1..4, at the
# boundary n = cap * min(L_A, L_B), where the necessary condition holds with
# equality; random index values; the package's own sel_truncation_cap().
set.seed(1)
n_draw <- 20000
short <- replicate(n_draw, {
  LA <- sample(2:6, 1); LB <- sample(2:6, 1); k <- sample(1:4, 1)
  fc <- list(index = rnorm(LA * LB), N = LA * LB, n_lines = LA + LB,
             ped = data.frame(a = rep(1:LA, LB), b = LA + rep(1:LB, each = LA)))
  length(sel_truncation_cap(fc, k * min(LA, LB), cap = k)) < k * min(LA, LB)
})
data.frame(draws = n_draw, walk_short = sum(short), share_short = round(mean(short), 4))

#' 
#' At the boundary the walk returned fewer than $n$ crosses in
#' `r fmt(100 * mean(short), 1)`% of `r format(n_draw, big.mark = ",")` random small
#' factorials, so the condition is not a guarantee. At this chapter's $n$ the
#' margin is wide (the `cap-diagnostics` chunk below reaches `n_sel`), which is why the walk succeeds
#' here; the check that works at any size is to `length()` the returned vector.
#' 
## -----------------------------------------------------------------------------
c(index_truncation = mean_index(sels$truncation, ctx),
  index_capped     = mean_index(sels$trunc_cap, ctx),
  index_retained_pct = 100 * mean_index(sels$trunc_cap, ctx) /
                             mean_index(sels$truncation, ctx),
  Ne_par_truncation = ne_parents(sels$truncation, ctx),
  Ne_par_capped     = ne_parents(sels$trunc_cap, ctx))

#' 
## -----------------------------------------------------------------------------
#| label: cap-diagnostics
cap <- ceiling(2 * n_sel / ctx$n_lines) + 1          # the function's default
ord <- order(ctx$index, decreasing = TRUE)
lines_used <- function(s) sum(tabulate(c(ctx$ped$a[s], ctx$ped$b[s]),
                                       ctx$n_lines) > 0)
c(cap                    = cap,
  reached_n_sel          = length(sels[["trunc_cap"]]) == n_sel,
  candidates_scanned     = max(match(sels[["trunc_cap"]], ord)),
  shared_with_truncation = length(intersect(sels[["truncation"]],
                                            sels[["trunc_cap"]])),
  lines_used_truncation  = lines_used(sels[["truncation"]]),
  lines_used_capped      = lines_used(sels[["trunc_cap"]]))

#' 
#' The default cap is `ceiling(2 * n_sel / ctx$n_lines) + 1`, one above even use,
#' which is `r ceiling(2 * n_sel / ctx$n_lines) + 1` here. Filling `r n_sel` slots
#' under it required scanning
#' `r max(match(sels[["trunc_cap"]], order(ctx$index, decreasing = TRUE)))` of the
#' `r ctx$N` ranked candidates, and only
#' `r length(intersect(sels[["truncation"]], sels[["trunc_cap"]]))` of the
#' resulting crosses are also in the truncation set: the cap does not trim the
#' top of the ranking, it reshuffles most of it. The last two rows count the same
#' reshuffling in lines rather than in crosses, and they are the reason
#' $N_{e,\text{par}}$ is not a line count: the capped plan touches
#' `r lines_used(sels[["trunc_cap"]])` distinct parent lines against truncation's
#' `r lines_used(sels[["truncation"]])`, out of `r ctx$n_lines` available -- to
#' within one line, the same set size -- while its effective number of parents is
#' `r fmt(ne_parents(sels[["trunc_cap"]], ctx), 1)` against
#' `r fmt(ne_parents(sels[["truncation"]], ctx), 1)`. What the cap changes is how
#' evenly the `r 2 * n_sel` parent slots are spread over the lines that are used,
#' not how many lines are used at all.
#' 
#' What that buys and what it costs, separately. The cap cuts the diversity loss
#' from `r fmt(100 * alpha_loss(sels$truncation, ctx, null$gd_ref), 2)`% to
#' `r fmt(100 * alpha_loss(sels$trunc_cap, ctx, null$gd_ref), 2)`% and raises the
#' effective number of parents from `r fmt(ne_parents(sels$truncation, ctx), 1)`
#' to `r fmt(ne_parents(sels$trunc_cap, ctx), 1)`, at
#' `r fmt(100 * mean_index(sels$trunc_cap, ctx) / mean_index(sels$truncation, ctx), 0)`%
#' of truncation's index. Whether that is a good trade is a programme decision,
#' not a statistical one -- but note that the capped plan is *feasible* at a 1%
#' budget while truncation is not, and it was found by counting alone.
#' 
#' Before reaching for an optimiser, run this. If a per-line cap already meets your
#' constraint at an acceptable index, you are done. The failure mode at this step
#' is silent: a returned vector shorter than `n_sel`, which every downstream
#' metric will happily evaluate on the wrong set size -- `length()` it.
#' 
#' ## Greedy, with incremental updates
#' 
#' Adding hybrid $j$ to an existing set changes the submatrix total by
#' $2 s_j + f_{jj}$, where $s_j$ is the sum of $f_{ij}$ over the already-chosen.
#' That makes each step $O(N)$ instead of $O(n^2)$, and the whole construction
#' affordable.
#' 
## -----------------------------------------------------------------------------
#| label: greedy-increment
S <- sel_greedy(ctx, n_sel = 10, w = 1)
j <- setdiff(seq_len(ctx$N), S)[1]
f <- ctx[["f"]]
recomputed  <- sum(f[c(S, j), c(S, j)])                 # O(n^2), from scratch
incremental <- sum(f[S, S]) + 2 * sum(f[S, j]) + f[j, j] # O(n), the update
stopifnot(isTRUE(all.equal(recomputed, incremental)))
c(recomputed = recomputed, incremental = incremental)

#' 
## -----------------------------------------------------------------------------
sel_greedy

#' 
#' One step $k$, in the order the code performs it:
#' 
#' 1. `theta_new <- (total + 2 * s + d) / k^2` is the group coancestry the set
#'    *would* have, for every candidate at once, with `total` the current
#'    submatrix sum, `s` the running vector of coancestry sums against the chosen
#'    set and `d = diag(f)`. The normaliser is $k^2$, the size after the addition.
#' 2. `score <- w * ctx$index - theta_new` -- merit against relatedness.
#' 3. Candidates already chosen are set to `-Inf`; with `max_use` set, so is every
#'    hybrid of a line that has reached its cap. The cap is therefore a
#'    **feasibility test on the move**, never a penalty on the result -- the
#'    partition-matroid treatment of @sec-advanced.
#' 4. The argmax is taken, `total` and `s` are updated in $O(N)$, and the parent
#'    counts incremented.
#' 5. If no finite score remains, the loop exits early and the returned vector is
#'    short -- the same check as for the capped truncation.
#' 
#' The score is $\omega\,u_i - \theta_{\text{new}}$, where $\omega \ge 0$ is the
#' index weight of @sec-notation and `w` is its argument name in the code (it is not
#' the line-usage vector $\mathbf{w}$ of @sec-collapse). At $\omega = 0$ the greedy
#' returns the most diverse plan it can build -- a heuristic, with no certificate
#' that it is the minimum of $\theta$ over all $n$-subsets -- at near-zero gain. As
#' $\omega \to \infty$ it converges to truncation. Sweeping $\omega$ traces a
#' frontier -- but **only if the grid is in the right units**, and that is the trap
#' at this step.
#' 
#' $\omega$ is an exchange rate. Under the score $\omega\,u_i - \theta_{\text{new}}$
#' two candidates are indifferent when $\omega\,\Delta u = \Delta\theta$, so
#' $\omega = \Delta\theta / \Delta u$, in units of group coancestry per index
#' standard deviation: the greedy argmax accepts, for one standard deviation of
#' index, a rise of $\theta$ of up to $\omega$. The multiplier $\lambda$ of
#' @eq-ocs-bound, in $V(\lambda) = \max\,\mathbf{c}'\mathbf{u} -
#' \lambda\,\mathbf{c}'\mathbf{f}\mathbf{c}$, has the reciprocal dimension, index
#' units per unit of $\theta$; how the numerical values of the two relate is not
#' examined here. The two quantities $\omega$ converts between differ by four
#' orders of magnitude, and that ratio is measurable before any sweep is run:
#' 
## -----------------------------------------------------------------------------
#| label: w-units
S30 <- sel_greedy(ctx, 30, w = 0)
theta_if_added <- (sum(f[S30, S30]) + 2 * colSums(f[S30, ]) + diag(f)) / 31^2
w_crossover <- diff(range(theta_if_added)) / diff(range(ctx$index))
c(index_spread = diff(range(ctx$index)),
  theta_spread = diff(range(theta_if_added)),
  w_crossover  = w_crossover)

#' 
#' `w_crossover` is the weight at which the two terms of the score have equal
#' range, measured at the 31st pick of the $\omega = 0$ plan (`S30`), not at the
#' $n = 60$ problem: it is a scale for the sweep and not a threshold, and the sweep
#' below measures where the plans actually change relative to it. Two grids appear
#' in this book, and the best feasible greedy plan depends on which is used.
#' 
## -----------------------------------------------------------------------------
#| label: greedy-grids
alphas    <- c(0, 0.0025, 0.005, 0.01, 0.02)    # the five budgets of the frontier
alpha_max <- 0.01
grid_bench <- c(0, 10^seq(-5, 1, length.out = 19))  # book/scripts/regenerate.R, @sec-advanced
grid_fine  <- 10^seq(-6, -1, length.out = 60)       # the grid of @sec-ocs
sweep <- function(ws) {
  plans <- lapply(ws, function(w) sel_greedy(ctx, n_sel, w = w))
  list(w = ws, plans = plans,
       alpha = vapply(plans, alpha_loss, numeric(1), ctx = ctx, gd_ref = null$gd_ref),
       index = vapply(plans, mean_index, numeric(1), ctx = ctx))
}
gb <- sweep(grid_bench)
gf <- sweep(grid_fine)
# the best plan of a sweep whose own alpha is within a budget
best_within <- function(g, a) {
  ok <- which(g$alpha <= a)
  ok[which.max(g$index[ok])]
}
summ <- function(g) {
  is_tr <- vapply(g$plans, setequal, logical(1), sels[["truncation"]])
  a_in  <- sort(unique(c(0, g$alpha[g$alpha > 0 & g$alpha < a_trunc], a_trunc)))
  c(values = length(g$w),
    distinct_plans = sum(!duplicated(round(cbind(g$alpha, g$index), 8))),
    return_truncation = sum(is_tr),
    flat_from = min(g$w[is_tr]),
    from_x_crossover = min(g$w[g$w > 0]) / w_crossover,
    to_x_crossover = max(g$w) / w_crossover,
    largest_alpha_interval_pct = 100 * max(diff(a_in)))
}
grid_summary <- rbind(benchmark_20 = summ(gb), fine_60 = summ(gf))
fmt(grid_summary, 4)
stopifnot(all(0.25 > grid_summary[, "flat_from"]))   # a round-number grid: all truncation

#' 
#' The benchmark grid is 0 and 19 values log-spaced from $10^{-5}$ to 10; it is the
#' grid of the benchmark of @sec-advanced and of @sec-choosing, so those chapters
#' report this greedy. It runs from `r fmt(grid_summary["benchmark_20", "from_x_crossover"], 2)`
#' to `r format(round(grid_summary["benchmark_20", "to_x_crossover"]), big.mark = ",")` times
#' `w_crossover`: it starts *below* the crossover, by a factor of
#' `r fmt(1 / grid_summary["benchmark_20", "from_x_crossover"], 1)`, and lies almost wholly above it. The grid of @sec-ocs is 60 values log-spaced from
#' $10^{-6}$ to $10^{-1}$, which runs from
#' `r fmt(grid_summary["fine_60", "from_x_crossover"], 3)` to
#' `r format(round(grid_summary["fine_60", "to_x_crossover"]), big.mark = ",")` times the crossover. The
#' plan is the truncation plan from
#' $\omega =$ `r fmt(grid_summary["benchmark_20", "flat_from"], 4)` upward on the
#' benchmark grid and from `r fmt(grid_summary["fine_60", "flat_from"], 4)` upward on
#' the fine one; on the benchmark grid that is
#' `r fmt(log10(grid_summary["benchmark_20", "flat_from"] / w_crossover), 1)` decades
#' above `w_crossover`. A grid of round numbers such as
#' $\{0.25, 0.5, \dots, 30\}$ -- the one this chapter used before it was measured,
#' and the one `sel_de()` hard-codes for its warm start -- lies entirely above the
#' weight from which the plan is truncation and returns the *same* selection at every
#' value, which makes greedy look an order of magnitude worse than it is.
#' 
## -----------------------------------------------------------------------------
#| label: greedy-frontier
#| fig-cap: "The greedy frontier at book scale (25 + 25 lines, 2000 markers, n = 60, N = 625, simulation seed 1): mean index against gene diversity loss alpha. Triangles: the 20 plans of the benchmark grid of omega; dots: the 60 plans of the finer grid of the optimal-contributions chapter. omega = 0 is the most diverse plan the greedy builds; large omega converges to truncation (cross). Dotted vertical line: alpha = 0. The points are not joined, because no plan exists between two grid values."
#| fig-alt: "Mean index against diversity loss: two clouds of greedy plans from two omega grids, rising from the maximum-diversity plan at the left to truncation at the right."
plot(NA, xlim = 100 * range(c(gb$alpha, gf$alpha)),
     ylim = range(c(gb$index, gf$index)),
     xlab = "gene diversity loss, alpha (%)", ylab = "mean index (s.d.)")
points(gf$alpha * 100, gf$index, pch = 19, cex = 0.6, col = "#1f5f8b")
points(gb$alpha * 100, gb$index, pch = 2, cex = 1.1, col = "#d98e04")
points(a_trunc * 100, mean_index(sels$truncation, ctx), pch = 4, cex = 1.5, col = "#b2182b")
text(a_trunc * 100, mean_index(sels$truncation, ctx), "truncation", pos = 2, cex = 0.75)
legend("bottomright", c("benchmark grid (20)", "fine grid (60)"),
       pch = c(2, 19), col = c("#d98e04", "#1f5f8b"), bty = "n", cex = 0.8)
abline(v = 0, lty = 3); grid()

#' 
## -----------------------------------------------------------------------------
#| label: window-ends
# Where the sweep leaves the omega = 0 plan and where it reaches truncation, in units
# of w_crossover. "Same as omega = 0" means the same index and alpha to 1e-9; the sets
# of hybrids may still differ, and usage_same checks that the line usage then agrees.
usage <- function(s) tabulate(c(ctx$ped$a[s], ctx$ped$b[s]), ctx$n_lines)
w0 <- sels[["greedy_div"]]
a0 <- alpha_loss(w0, ctx, null$gd_ref); i0 <- mean_index(w0, ctx)
ends <- function(g) {
  lo   <- which(g$w < w_crossover)
  at0  <- abs(g$index - i0) < 1e-9 & abs(g$alpha - a0) < 1e-9
  set0 <- vapply(g$plans, setequal, logical(1), w0)
  use0 <- vapply(g$plans, function(s) all(usage(s) == usage(w0)), logical(1))
  tr   <- vapply(g$plans, setequal, logical(1), sels[["truncation"]])
  c(below_crossover = length(lo),
    distinct_below = length(unique(lapply(g$plans[lo], sort))),
    same_set_as_w0 = sum(set0[lo]),
    same_index_alpha_as_w0 = sum(at0[lo]),
    same_usage_as_w0 = sum(use0[lo]),
    index_below_min = min(g$index[lo]), index_below_max = max(g$index[lo]),
    first_rise_x_crossover = min(g$w[g$w > 0 & !at0]) / w_crossover,
    index_at_first_rise = g$index[which(g$w == min(g$w[g$w > 0 & !at0]))],
    truncation_from_x_crossover = min(g$w[tr]) / w_crossover,
    neither_w0_nor_truncation = sum(!at0 & !tr))
}
window_ends <- rbind(benchmark_20 = ends(gb), fine_60 = ends(gf))
fmt(t(window_ends), 4)
# the claims of the text that follows
stopifnot(all(window_ends[, "same_index_alpha_as_w0"] ==
                window_ends[, "same_usage_as_w0"]),
          window_ends["benchmark_20", "distinct_below"] == window_ends["benchmark_20", "below_crossover"],
          window_ends["benchmark_20", "same_index_alpha_as_w0"] == 1,
          window_ends["fine_60", "same_set_as_w0"] == 0,
          window_ends["fine_60", "first_rise_x_crossover"] < 0.1,       # > 1 decade below
          window_ends["fine_60", "truncation_from_x_crossover"] > 10,   # > 1 decade above
          window_ends["benchmark_20", "truncation_from_x_crossover"] > 10,
          window_ends["fine_60", "same_index_alpha_as_w0"] < window_ends["fine_60", "below_crossover"])

#' 
#' Two readings, and the second is the argument for everything that follows.
#' First, the plan is not constant below the crossover and the frontier does not
#' begin at it. *Result* (the `window-ends` chunk). On the benchmark grid
#' `r window_ends["benchmark_20", "below_crossover"]` of the
#' `r grid_summary["benchmark_20", "values"]` values lie below `w_crossover`
#' ($\omega = 0$ and `r window_ends["benchmark_20", "below_crossover"] - 1` positive values, up to
#' `r fmt(max(gb$w[gb$w < w_crossover]) / w_crossover, 2)` times it); they return
#' `r window_ends["benchmark_20", "distinct_below"]` distinct plans, with mean index
#' from `r fmt(window_ends["benchmark_20", "index_below_min"], 3)` to
#' `r fmt(window_ends["benchmark_20", "index_below_max"], 3)`, so only the
#' $\omega = 0$ value returns the $\omega = 0$ plan. On the fine grid
#' `r window_ends["fine_60", "below_crossover"]` of the
#' `r grid_summary["fine_60", "values"]` values lie below it, from
#' `r fmt(grid_summary["fine_60", "from_x_crossover"], 3)` times `w_crossover`; the
#' lowest `r window_ends["fine_60", "same_index_alpha_as_w0"]` return plans with the
#' index and $\alpha$ of the $\omega = 0$ plan, to $10^{-9}$ (they are not the same
#' set of hybrids -- none of the `r window_ends["fine_60", "below_crossover"]` is -- but
#' they have the same line usage), and from
#' `r fmt(window_ends["fine_60", "first_rise_x_crossover"], 3)` times `w_crossover`
#' the index rises (`r fmt(window_ends["fine_60", "index_at_first_rise"], 3)` there,
#' `r fmt(max(gf$index[gf$w < w_crossover]), 3)` at the highest value below the
#' crossover). At the upper end the plan is truncation from
#' $\omega =$ `r fmt(grid_summary["benchmark_20", "flat_from"], 4)` on the benchmark grid
#' and from `r fmt(grid_summary["fine_60", "flat_from"], 4)` on the fine one:
#' `r fmt(window_ends["benchmark_20", "truncation_from_x_crossover"], 0)` and
#' `r fmt(window_ends["fine_60", "truncation_from_x_crossover"], 0)` times
#' `w_crossover`. `r grid_summary["benchmark_20", "return_truncation"]` of the
#' `r grid_summary["benchmark_20", "values"]` benchmark values and
#' `r grid_summary["fine_60", "return_truncation"]` of the
#' `r grid_summary["fine_60", "values"]` fine values return truncation; the benchmark
#' grid has `r grid_summary["benchmark_20", "distinct_plans"]` distinct plans, and
#' `r window_ends["benchmark_20", "neither_w0_nor_truncation"]` of its values return
#' neither the $\omega = 0$ plan nor truncation: these are the plans of the
#' frontier. *Interpretation, and what limits it.* The transition from the
#' $\omega = 0$ plan to truncation spans about
#' `r fmt(log10(window_ends["fine_60", "truncation_from_x_crossover"] / window_ends["fine_60", "first_rise_x_crossover"]), 1)`
#' decades on the fine grid, from
#' `r fmt(window_ends["fine_60", "first_rise_x_crossover"], 3)` to
#' `r fmt(window_ends["fine_60", "truncation_from_x_crossover"], 0)` times `w_crossover`:
#' neither end is within an order of magnitude of it, so `w_crossover` is a scale
#' inside the range and not a locator of either edge (it is measured at one pick of
#' one plan, above). The lowest end is resolved only to the spacing of the fine grid,
#' and the benchmark grid, which has no value between $\omega = 0$ and
#' `r fmt(min(gb$w[gb$w > 0]) / w_crossover, 2)` times `w_crossover`, does not
#' resolve it at all. Second, the sweep is parameterised by
#' $\omega$ and *the breeder's constraint is not*. Within $[0, \alpha_{\text{trunc}}]$
#' the largest interval of $\alpha$ with no plan of the sweep in it is
#' `r fmt(grid_summary["benchmark_20", "largest_alpha_interval_pct"], 2)` percentage
#' points on the benchmark grid and
#' `r fmt(grid_summary["fine_60", "largest_alpha_interval_pct"], 2)` on the fine one; a
#' budget falling inside such an interval cannot be requested of a greedy sweep at
#' all, only stumbled upon, and the best feasible plan for it is the one at the
#' interval's lower end. A finer grid shrinks the intervals, it does not remove them.
#' An optimiser parameterised by $\alpha_{\max}$ can be asked for the budget
#' directly.
#' 
#' Greedy plans also seed the initial population of the differential evolution;
#' what that is worth is measured in @sec-combinatorial-warm.
#' 
#' ## The encoding problem
#' 
#' Differential evolution searches a box of real numbers, and an encoding turns a
#' point of the box into a set of $n$ distinct hybrids. Three encodings appear in
#' this book, and they differ in dimension and in what a coordinate means:
#' 
#' 1. **$n$ keys** (`decode()`): $n$ coordinates, each naming a candidate by its
#'    integer part. This is what `sel_de()` searches; the dimension is $n =$
#'    `r n_sel` here.
#' 2. **$N$ keys** (`decode_rank()`): one random key per candidate, the $n$ smallest
#'    keys selected; the dimension is $N$, which is `r ctx$N` here, `r format(max(de$dim), big.mark = ",")`
#'    in the cached run below and `r format(71^2, big.mark = ",")` at the package
#'    production scale. A 0/1 vector of length $N$ has the same dimension; the
#'    package implements the key form and I did not test the 0/1 form.
#' 3. **$L$ line weights** (`decode_lines()`): one weight per line, dimension $L$.
#' 
#' The package searches $n$ coordinates, not $N$, because the dimension of the
#' $N$-key search grows with the candidate set. Whether that makes the $N$-key
#' search *infeasible*, or only under-powered at a given budget, is not settled by
#' anything in the book: the only measurement of the $N$-key encoding is the cached
#' external run below, at one budget, and its limits are stated with it.
#' 
## -----------------------------------------------------------------------------
decode

#' 
#' The decode of the first encoding, step by step:
#' 
#' 1. `as.integer(par)` truncates each coordinate toward zero, so the real
#'    interval $[i, i+1)$ maps to candidate $i$. `sel_de()` searches the box
#'    $[1,\, N + 0.999]$, so candidates $1$ to $N-1$ each own a full unit
#'    interval and candidate $N$ owns $[N,\, N + 0.999]$ -- narrower by one part
#'    in a thousand, because the upper bound stops just short of $N + 1$ instead
#'    of reaching it.
#' 2. Coordinates outside the box are clamped to the ends.
#' 3. `duplicated()` marks every coordinate after the first that lands on an
#'    already-used candidate.
#' 4. Each duplicate is replaced by the lowest index not otherwise in use, so the
#'    result always has exactly `n_sel` distinct candidates.
#' 
#' A worked case, small enough to check by hand:
#' 
## -----------------------------------------------------------------------------
#| label: decode-example
d <- decode(c(3.9, 3.2, 1.1, 7.5), N = 10, n_sel = 4)
stopifnot(all(d == c(3, 2, 1, 7)))
d

#' 
#' Truncation gives $(3, 3, 1, 7)$; the second coordinate is the duplicate; the
#' lowest index not in $\{3, 1, 7\}$ is 2; the repair returns $(3, 2, 1, 7)$. The
#' same mechanism is what lets a warm start be injected exactly: a seed is written
#' into the population as `index + 0.5`, the middle of its own interval, and
#' decodes back to itself.
#' 
## -----------------------------------------------------------------------------
#| label: decode-roundtrip
s0 <- sel_greedy(ctx, n_sel, w = 1)
seed_roundtrip <- all(decode(s0 + 0.5, ctx$N, n_sel) == s0)
stopifnot(seed_roundtrip)
c(box_lower      = 1,
  box_upper      = ctx$N + 0.999,
  width_typical  = 2 - 1,                       # candidate 1 owns [1, 2)
  width_last     = (ctx$N + 0.999) - ctx$N,     # candidate N owns [N, N+0.999]
  seed_roundtrip = seed_roundtrip)

#' 
#' Duplicates are repaired **deterministically**. A stochastic repair would make
#' the fitness noisy, and a noisy fitness stops DE converging -- the same parameter
#' vector must always score the same.
#' 
## -----------------------------------------------------------------------------
#| label: decode-determinism
set.seed(3)
p1 <- runif(n_sel, 1, ctx$N + 1)
p2 <- runif(n_sel, 1, ctx$N + 1)
d1 <- decode(p1, ctx$N, n_sel)
d2 <- decode(p2, ctx$N, n_sel)
stopifnot(length(unique(d1)) == n_sel, length(unique(d2)) == n_sel,
          all(c(d1, d2) >= 1 & c(d1, d2) <= ctx$N),
          identical(d1, decode(p1, ctx$N, n_sel)))
c(unique_1 = length(unique(d1)), unique_2 = length(unique(d2)),
  collisions_repaired = sum(duplicated(as.integer(p1))))

#' 
#' ::: {.callout-note}
#' ## A bias in the repair, measured
#' 
#' The repair fills in the lowest free indices. It is marked in the source with a
#' `ponytail:` comment naming the limit and the upgrade path -- switch to
#' "nearest free" if the DE ever stalls. What the bias is can be measured on random
#' vectors:
#' 
## -----------------------------------------------------------------------------
#| label: repair-bias
set.seed(3)
rb <- t(replicate(2000, {
  p   <- runif(n_sel, 1, ctx$N + 1)
  dup <- duplicated(as.integer(p))
  fill <- decode(p, ctx$N, n_sel)[dup]                 # the repaired members
  c(n_dup = sum(dup), same_B_line = sum(ctx$ped$b[fill] == min(ctx$ped$b)))
}))
c(vectors = nrow(rb), duplicates_per_vector = mean(rb[, "n_dup"]),
  share_repaired_on_one_B_line = sum(rb[, "same_B_line"]) / sum(rb[, "n_dup"]))

#' 
#' Over 2,000 random vectors there are `r fmt(mean(rb[, "n_dup"]), 2)` duplicates per
#' vector, and `r fmt(100 * sum(rb[, "same_B_line"]) / sum(rb[, "n_dup"]), 0)`% of the
#' repaired members are crosses with the same B parent (line `r min(ctx$ped$b)`),
#' because candidates $1, \dots, L_A$ are the crosses of that line with each A line.
#' So the bias is not a diffuse tilt toward low-numbered candidates: it adds about
#' `r fmt(mean(rb[, "n_dup"]), 1)` uses of one B line to each random vector, which
#' interacts with the cap. Whether it changes the plans the DE returns is **not
#' measured** here; the line usage of the returned plans was not examined.
#' :::
#' 
#' ### A third encoding: one weight per line
#' 
#' @sec-collapse showed that $\theta$ depends only on the line-usage vector. That
#' makes the third encoding available, and one that changes what the coordinates
#' *mean*: one weight per **line**, dimension $L$. Against the $N$-key vector that
#' is a collapse from `r format(max(de$dim), big.mark = ",")` coordinates to
#' `r min(de$dim)` in the cached run below. Against the $n$ coordinates `sel_de()`
#' actually searches it is a different trade, which the cached run does not record
#' ($n$ is not in the file), and the numbers below say which of the two comparisons
#' is which.
#' 
## -----------------------------------------------------------------------------
decode_lines

#' 
#' The line weight shifts each hybrid's score by the weights of its two parents,
#' and hybrids are taken greedily subject to the per-line usage cap -- so the cap is
#' satisfied **by construction** rather than by penalty. In detail:
#' 
#' 1. Each candidate scores `ctx$index + w_div * (p[a] + p[b])`, with `p` the
#'    line-weight vector being searched and `w_div = 3` by default. A line's
#'    weight therefore moves every cross it parents, which is what makes the
#'    decision a *line* decision.
#' 2. Candidates are taken in decreasing score, skipping any whose parents have
#'    reached `max_use`.
#' 3. If the cap makes `n_sel` unreachable, the selection is topped up ignoring
#'    it, and the fitness function's penalty term then sees the violation -- so
#'    an infeasible cap degrades gracefully instead of returning a short vector.
#' 
#' At `p = 0` the decoder is exactly capped truncation, which is the natural zero
#' of the encoding; @sec-advanced verifies that identity numerically where the
#' encoding is actually driven.
#' 
#' ### The four restrictions {#sec-combinatorial-restrictions}
#' 
#' The only measurement of the $N$-key encoding in this book is a cached run
#' (@sec-choosing-search previews it) under four simultaneous restrictions on the
#' plan. They are defined here once; @sec-choosing-search points to this
#' section. With $k_a$ the number of uses of line $a$ (above), $\sum_a k_a = 2n$:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-combinatorial-restrictions
#| tbl-cap: "The four restrictions of the cached run of `de_constraints.csv`. Columns: the restriction; the quantity it limits ($k_a$: uses of line $a$, $\\sum_a k_a = 2n$; $\\mathcal{A}$: the lines of pool A); the limit of the cached run as @sec-choosing-search states it (the file records outcomes, not limits); the argument of `make_fitness_fast()` that carries it. In `make_fitness_fast()` (`R/04_fast_metrics.R`) the first, second and fourth enter the fitness as a violation divided by its own limit, and the cap as the number of parent slots above $k_{\\max}$, summed over lines, divided by the total number of uses $2n$ (not by $k_{\\max}$); all are charged at one penalty multiplier, and the multiplier of the cached run is not recorded."
knitr::kable(data.frame(
  Restriction = c("Diversity loss", "Effective number of parents",
                  "Per-line usage cap", "Pool balance"),
  Quantity = c("$\\alpha$ of @eq-ocs-alpha",
               "$N_{e,\\text{par}} = (\\sum_a k_a)^2 / \\sum_a k_a^2$",
               "$\\max_a k_a$, the cap $k_{\\max}$",
               "$\\lvert \\sum_{a \\in \\mathcal{A}} k_a / (2n) - 1/2 \\rvert$"),
  Limit = c(sprintf("$\\alpha \\le$ %s%%", lim[["loss_pct"]]),
            sprintf("$N_{e,\\text{par}} \\ge$ %s", lim[["ne_par"]]),
            sprintf("$k_{\\max} =$ %s", lim[["k_max"]]),
            sprintf("$\\le$ %s", lim[["pool"]])),
  Argument = c("`alpha_max`", "`ne_par_min`", "`max_use`", "`pool_tol`")),
  escape = FALSE)

#' 
#' The fourth restriction cannot bind in a factorial of $A \times B$ crosses: every
#' selected hybrid has one parent in pool A and one in pool B, so the $2n$ slots
#' are split exactly $n$ and $n$ for *every* plan, and the quantity in the last row
#' is 0 identically.
#' 
## -----------------------------------------------------------------------------
#| label: pool-balance-identity
set.seed(5)
share_A <- replicate(500, {
  s <- sel_random(ctx, n_sel)
  k <- tabulate(c(ctx$ped$a[s], ctx$ped$b[s]), ctx$n_lines)
  sum(k[ctx$pool == "A"]) / sum(k)
})
stopifnot(all(share_A == 0.5))
c(plans = length(share_A), min_share_A = min(share_A), max_share_A = max(share_A))

#' 
#' The cached column `pool_imbalance` is 0 in `r sum(de$pool_imbalance == 0)` of
#' `r nrow(de)` rows, which the identity requires; I infer that the cached run's
#' candidate set was such a factorial ($N =$ `r format(max(de$dim), big.mark = ",")`
#' $= 60^2$ is consistent with 60 + 60 lines, but the file does not record it).
#' The restriction therefore carries no information in this setting, and the "four
#' simultaneous restrictions" are at most three.
#' 
#' ### What the cached run compares, and what it does not
#' 
#' The claim that an $N$-key search is *infeasible* at this scale would be a claim
#' about every budget; the cached run measures one. It is an external file:
#' `book/data/de_constraints.csv` (9 rows: three configurations, three seeds) has
#' **no producer in this repository** -- no target of `book/scripts/regenerate.R`
#' writes it, and its code is not available here -- so it cannot be regenerated or
#' re-run, and nothing below is reproducible from this repository beyond arithmetic
#' on the stored values (@sec-choosing lists the files of this kind). It is worth
#' being exact about what it compares, because **neither arm of it is `sel_de()`**.
#' Both are driven through `make_fitness_fast()`, at the cached-run scale, under the
#' four restrictions above. One arm is `decode_rank()` -- one random key per
#' *hybrid*, dimension `r format(max(de$dim), big.mark = ",")`. The other is
#' `decode_lines()`, dimension `r min(de$dim)`. Neither is warm-started. The file
#' does not record the number selected $n$, the DE population size `NP`, the
#' iteration count or the penalty multiplier.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-combinatorial-de-cached
#| echo: false
#| tbl-cap: "Cached external run, `de_constraints.csv`: equal evaluation budget per run, three seeds per configuration, cached-run scale. Columns: configuration (search encoding / constraint handler); dimension; mean index; minimum and maximum over the three seeds (the range, not a confidence interval); loss of gene diversity $\\alpha$ in percent; effective number of parents $N_{e,\\text{par}}$; maximum uses of one line; pool imbalance; seconds. Limits as in @tbl-combinatorial-restrictions. Every row is feasible (the chunk asserts it)."
agg <- do.call(rbind, lapply(split(de, de$encoding), function(d) data.frame(
  encoding     = d$encoding[1],
  dim          = d$dim[1],
  index        = mean(d$index),
  index_min    = min(d$index),
  index_max    = max(d$index),
  `loss %`     = mean(d$loss_pct),
  `Ne parents` = mean(d$Ne_parents),
  `max uses`   = mean(d$max_use),
  `pool imbalance` = mean(d$pool_imbalance),
  seconds      = mean(d$secs),
  check.names  = FALSE)))
stopifnot(all(de$feasible))
knitr::kable(fmt(agg, 3), digits = 3, row.names = FALSE)

#' 
## -----------------------------------------------------------------------------
#| label: encoding-spread
#| echo: false
hk <- de[de$encoding == "hybrid keys / penalty", ]
hr <- de[de$encoding == "hybrid keys / repair", ]
lw <- de[de$encoding == "line weights / repair", ]
stopifnot(isTRUE(all.equal(hk$index, hr$index)),
          isTRUE(all.equal(hk$Ne_parents, hr$Ne_parents)))

#' 
#' *Result.* At the same budget of `r format(unique(de$evaluations), big.mark = ",")`
#' evaluations the $N$-key search reaches a mean index of `r fmt(mean(hk$index), 3)`
#' (seed range `r fmt(min(hk$index), 3)` to `r fmt(max(hk$index), 3)`) and the
#' line-weight search `r fmt(mean(lw$index), 3)` (`r fmt(min(lw$index), 3)` to
#' `r fmt(max(lw$index), 3)`): a difference of `r fmt(mean(lw$index) - mean(hk$index), 2)`
#' index units, with non-overlapping seed ranges. (No ratio is quoted: the index has
#' no natural zero.) In the $N$-key arm every restriction is slack: $N_{e,\text{par}}$
#' is `r fmt(min(hk$Ne_parents), 1)` to `r fmt(max(hk$Ne_parents), 1)` against a floor
#' of `r lim[["ne_par"]]`, loss is `r fmt(min(hk$loss_pct), 2)` to
#' `r fmt(max(hk$loss_pct), 2)`% against `r lim[["loss_pct"]]`%, and the largest use
#' is `r paste(hk$max_use, collapse = ", ")` against a cap of `r lim[["k_max"]]`
#' (reached in `r sum(hk$max_use == lim[["k_max"]])` of 3 seeds). In the line-weight
#' arm $N_{e,\text{par}}$ is `r fmt(min(lw$Ne_parents), 2)` to
#' `r fmt(max(lw$Ne_parents), 2)` and loss `r fmt(min(lw$loss_pct), 2)` to
#' `r fmt(max(lw$loss_pct), 2)`%, at the $N_{e,\text{par}}$ floor and near the loss
#' limit, and the largest use is
#' `r lim[["k_max"]]` in every seed -- which the decoder guarantees by construction.
#' Penalty and repair returned numerically identical outcomes in the $N$-key arm for
#' all three seeds (the file stores outcomes, not plans); no line-weight arm with a penalty was run.
#' 
#' *Interpretation, and what limits it.* Feasible plans with index
#' `r fmt(mean(lw$index), 2)` exist for this problem (the line-arm plans), so the
#' $N$-key plans at `r fmt(mean(hk$index), 2)` with every restriction slack are not
#' constrained optima: a slack restriction at the end of a run is here the sign of
#' an unconverged search, not of a conservative plan (@sec-choosing-search reads
#' it the same way). That follows from the table; it is not a general rule. Four
#' limits apply.
#' 
#' (a) *Budget.* With `NP` at least ten times the number of parameters, the guidance
#' of the `DEoptim.control` help page (the package is described by @mullen2011),
#' `r format(max(de$dim), big.mark = ",")` parameters call for
#' `r format(10 * max(de$dim), big.mark = ",")` population members, so
#' `r format(unique(de$evaluations), big.mark = ",")` evaluations are
#' `r fmt(unique(de$evaluations) / (10 * max(de$dim)), 2)` generations; at
#' `r min(de$dim)` parameters they are about
#' `r fmt(unique(de$evaluations) / (10 * min(de$dim)), 0)`. The `NP` of the cached
#' run was not recorded, so I cannot say that either arm followed the guidance. The
#' $N$-key search is under-powered by construction at this budget; the result is a
#' statement about that budget, not about the encoding at any budget.
#' 
#' (b) *Handlers.* The comparison is between two encodings through the same fitness,
#' not between two constraint handlers. The identity of penalty and repair in the
#' $N$-key arm is not explained. One candidate, an inference from the package code
#' and not a test (the cached run's own code is not available): the $N$-key fitness
#' calls `decode_rank()`, which takes no `max_use` (`R/04_fast_metrics.R`), so
#' for that arm "penalty" and "repair" would be the same function. The line decoder
#' satisfies the cap by construction, so "uses = `r lim[["k_max"]]`" in the line arm
#' is not evidence that the search found the boundary, and nothing here says that
#' the constraint handler does or does not matter.
#' 
#' (c) *Replication.* Three seeds, one setup, no interval.
#' 
#' (d) *Not `sel_de()`.* The benchmark of @sec-advanced is the measurement closest
#' to the question of which encoding wins in the setting this chapter uses:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-combinatorial-de-lines
#| echo: false
#| tbl-cap: "`sel_de()` (the $n$-key encoding) against the line-encoded `sel_de_fast()`, from `search_benchmark.csv` (3 seeds per method and scale; regenerated in this repository by `regenerate.R search`). Columns: scale; cap (none, or `max_use` at that scale); mean index of each; the paired difference, `sel_de()` minus line-encoded, with its standard error over the 3 seeds; the three per-seed differences. A standard error of 0 means the three differences are equal, not that the difference is known."
cmp <- do.call(rbind, lapply(
  list(c("book", "de_hybrid", "de_lines"), c("production", "de_hybrid", "de_lines"),
       c("book", "de_hybrid_cap", "de_lines_cap"),
       c("production", "de_hybrid_cap", "de_lines_cap")),
  function(a) {
    p <- bpair(a[[1]], a[[2]], a[[3]])
    data.frame(scale = a[[1]],
               cap = if (grepl("_cap$", a[[2]])) as.character(bs[a[[1]], "cap"]) else "none",
               `sel_de()` = mean(bv(a[[1]], a[[2]])),
               `line-encoded` = mean(bv(a[[1]], a[[3]])),
               difference = p[["d"]], `s.e.` = p[["se"]],
               `per seed` = paste(fmt(bv(a[[1]], a[[2]]) - bv(a[[1]], a[[3]]), 4),
                                  collapse = ", "),
               check.names = FALSE)
  }))
knitr::kable(fmt(cmp, 4), row.names = FALSE)

#' 
## -----------------------------------------------------------------------------
#| label: de-lines-numbers
#| include: false
pb <- bpair("book", "de_hybrid", "de_lines")
pp <- bpair("production", "de_hybrid", "de_lines")
t_pp <- pp[["d"]] / pp[["se"]]

#' 
#' *Result.* Uncapped, `sel_de()` is ahead of the line-encoded DE by
#' `r fmt(pb[["d"]], 3)` (s.e. `r fmt(pb[["se"]], 3)`) at the benchmark book scale,
#' `r fmt(pb[["d"]] / pb[["se"]], 0)` standard errors with all three seed differences
#' positive, and by `r fmt(pp[["d"]], 3)` (s.e. `r fmt(pp[["se"]], 3)`) at the
#' benchmark production scale, `r fmt(t_pp, 1)` standard errors on 2 degrees of
#' freedom (two-sided $p =$ `r fmt(2 * pt(-abs(t_pp), 2), 2)`): not resolved by three
#' seeds. Capped, the three seed differences are identical at the book scale
#' (`r fmt(bpair("book", "de_hybrid_cap", "de_lines_cap")[["d"]], 4)`, standard
#' deviation 0) and 0 at the production scale; every capped cell has a seed standard
#' deviation of 0, and why the seeds agree exactly was not examined.
#' *Interpretation:* the benchmark supports "`sel_de()` ahead of the line-encoded DE"
#' only without a cap and resolved only at the benchmark book scale; with a cap it
#' shows an unjudged gap at the book scale and none at the production scale. The
#' cached run's verdict is on the $N$-key encoding at its budget, not on `sel_de()`.
#' 
#' Nor is the cached run a claim that one evaluation is cheaper. It is not, and
#' @sec-scaling measures both.
#' 
#' > The cached run shows that, at its budget, one random key per hybrid reaches far
#' > less than one weight per line under four restrictions, with every restriction
#' > slack in the former. It does not show that an $N$-dimensional encoding is
#' > infeasible at larger budgets, and it does not compare constraint handlers in the
#' > encoding that works. Which of two viable encodings wins in the setting of this
#' > chapter has to be measured, and @sec-advanced measures it.
#' 
#' ## Differential evolution
#' 
#' The run, as a procedure:
#' 
#' 1. Fix `n_sel` first, then obtain `gd_ref` from `null_distribution()` **at that
#'    same size**. A reference computed at another size is a different quantity
#'    and every $\alpha$ downstream is wrong by a fixed factor.
#' 2. Choose $\alpha_{\max}$ below $\alpha_{\text{trunc}}$, printed at the top of
#'    this chapter, by the procedure of @sec-ocs.
#' 3. Call `sel_de()`. It builds its warm start, injects it into the initial
#'    population, and hands `DEoptim` the fitness
#'    $-(\bar u_S - 1000 \cdot \text{viol})$ to minimise, with
#'    $\text{viol} = \max(0, \alpha - \alpha_{\max})$, an absolute excess in units of
#'    $\alpha$ -- plus, when `max_use` is set, the cap term defined above.
#' 4. Check the returned plan before using it: realised $\alpha$ against the
#'    budget, `max_line`, $N_{e,\text{par}}$, and the gap to the bound. The
#'    diversity constraint is a **penalty**, so a returned plan is not guaranteed
#'    feasible -- the violation is only made expensive.
#' 
## -----------------------------------------------------------------------------
sel_de

#' 
## -----------------------------------------------------------------------------
#| label: de-run
set.seed(9)
de_idx <- suppressWarnings(
  sel_de(ctx, n_sel, alpha_max = alpha_max, gd_ref = null$gd_ref,
         NP = 120, itermax = 250))

fmt(c(index      = mean_index(de_idx, ctx),
      alpha_pct  = 100 * alpha_loss(de_idx, ctx, null$gd_ref),
      budget_pct = 100 * alpha_max,
      Ns         = status_number(de_idx, ctx),
      Ne_parents = ne_parents(de_idx, ctx)), 3)

#' 
#' The realised loss sits just inside the budget, which is the sign that the
#' constraint is active and the penalty correctly scaled: with `penalty = 1000`
#' multiplying the *absolute* violation, one tenth of a percentage point of excess
#' loss costs a full index standard deviation. A plan that comes back well inside
#' the budget at a low index usually means the opposite -- that the penalty
#' dominated and the search never approached the boundary.
#' 
#' ### The warm start {#sec-combinatorial-warm}
#' 
#' `sel_de()` seeds its initial population with a greedy sweep, and the package
#' keeps that seeding as a design decision. An earlier version of its documentation
#' stated a stronger form -- that at roughly 100 integer dimensions
#' $4.5 \times 10^5$ evaluations are not enough to beat greedy without it; the
#' current documentation calls that a historical figure of which no run is recorded
#' in this repository. I did not rerun it and it is not used here. What is measured
#' below is the effect at book scale, 20 seeds per arm, with the chapter's own calls
#' (`NP` = `r de_cfg$NP[1]`, `itermax` = `r de_cfg$itermax[1]`, i.e.
#' `r ev(de_cfg$evaluations[1])` evaluations); that is the only evaluation budget at
#' which a cold start was run.
#' 
#' Five initial populations, each `NP = 120` rows with the first rows overwritten by
#' the seeds: `cold`, one random plan; `w = 0 only`, the maximum-diversity plan;
#' `truncation only`; `default`, the eight greedy plans `sel_de()` builds for
#' itself (`seeds = NULL`); and `default + best greedy`, those eight and the best
#' feasible plan of the fine $\omega$ grid. In every arm the rest of the population
#' is uniform random keys. The arms share the seed and `NP`; they do not share the
#' random part of the initial population (the cold arm draws its one plan before
#' the keys, the others do not), so pairing by seed removes no initial-population
#' variance, and the standard errors below are of differences by seed for
#' convenience only.
#' 
## -----------------------------------------------------------------------------
#| label: warm-ablation
best_fine <- gf$plans[[best_within(gf, alpha_max)]]       # best feasible greedy, 60-value grid
best_bench <- gb$plans[[best_within(gb, alpha_max)]]      # ... and on the benchmark grid
seed_w <- c(0, 0.25, 0.5, 1, 2, 4, 8, 16)                 # the grid sel_de() hard-codes
default_seeds <- lapply(seed_w, function(w) sel_greedy(ctx, n_sel, w = w))
arms <- list(`cold` = NULL,
             `w = 0 only` = list(default_seeds[[1]]),
             `truncation only` = list(sels[["truncation"]]),
             `default` = default_seeds,
             `default + best greedy` = c(default_seeds, list(best_fine)))
wa_runs <- lapply(1:20, function(sd_) vapply(names(arms), function(a) {
  set.seed(sd_)
  sd_arg <- if (a == "cold") list(sample.int(ctx$N, n_sel)) else arms[[a]]
  r <- suppressWarnings(
    sel_de(ctx, n_sel, alpha_max, null$gd_ref, NP = de_cfg$NP[1],
           itermax = de_cfg$itermax[1], seeds = sd_arg))
  c(index = mean_index(r, ctx), alpha = alpha_loss(r, ctx, null$gd_ref))
}, numeric(2)))
pick <- function(what) data.frame(seed = 1:20, t(vapply(wa_runs, function(m) m[what, ],
                                                         numeric(length(arms)))),
                                  check.names = FALSE)
wa <- pick("index")          # one row per seed, one column per initial population
wa_alpha <- pick("alpha")    # the alpha of the same plans, against `alpha_max`
# the `default` arm at seed 9 is the plan `de_idx` of the previous chunk: same call, same seed
stopifnot(isTRUE(all.equal(wa[["default"]][wa$seed == 9], mean_index(de_idx, ctx))))
arm_names <- names(arms)
wtab <- do.call(rbind, lapply(arm_names, function(a) {
  d <- wa[[a]] - wa[["cold"]]
  data.frame(arm = a, mean = mean(wa[[a]]), sd = sd(wa[[a]]),
             min = min(wa[[a]]), max = max(wa[[a]]),
             `minus cold` = mean(d), `s.e.` = sd(d) / sqrt(length(d)),
             `seeds above cold` = sum(d > 0),
             `over budget` = sum(wa_alpha[[a]] > alpha_max), check.names = FALSE)
}))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-combinatorial-warm
#| echo: false
#| tbl-cap: "Mean index of the DE plan at the 1% budget, book scale, 20 seeds (1 to 20) per initial population, `NP` = 120, `itermax` = 250 (30,000 evaluations). Columns: the initial population (@sec-combinatorial-warm); mean, standard deviation, minimum and maximum over seeds; the difference to the `cold` arm by seed, with its standard error ($n$ = 20), the number of seeds in which the arm is above `cold`, and the number of the 20 plans whose own $\\alpha$ exceeds the 1% budget."
knitr::kable(fmt(wtab, 4), row.names = FALSE)

#' 
## -----------------------------------------------------------------------------
#| label: warm-start
#| fig-cap: "Mean index of the DE plan at the 1% budget for five initial populations (@tbl-combinatorial-warm), book scale, 20 seeds each (points; horizontal jitter only), `NP` = 120, `itermax` = 250 (30,000 evaluations). Horizontal lines: the best feasible greedy plan of the 60-value omega grid (solid) and of the 20-value benchmark grid (dashed)."
#| fig-alt: "Five columns of 20 points each, one per initial population; the cold and w-equals-0-only columns lowest, the default column higher, and the default-plus-best-greedy column highest, above two horizontal lines that mark the best feasible greedy plans."
set.seed(11)
op <- par(mar = c(7, 4, 1, 1))
plot(NA, xlim = c(0.5, length(arm_names) + 0.5),
     ylim = range(c(unlist(wa[arm_names]), mean_index(best_fine, ctx))),
     xaxt = "n", xlab = "", ylab = "mean index (s.d.)")
axis(1, seq_along(arm_names), arm_names, las = 2, cex.axis = 0.8)
for (i in seq_along(arm_names))
  points(i + runif(nrow(wa), -0.12, 0.12), wa[[arm_names[i]]], pch = 19, cex = 0.7,
         col = "#1f5f8b")
abline(h = mean_index(best_fine, ctx), lty = 1, col = "#b2182b")
abline(h = mean_index(best_bench, ctx), lty = 2, col = "#b2182b")
grid(); par(op)

#' 
#' *Result.* The `default` arm averages `r fmt(wtab$mean[wtab$arm == "default"], 3)`
#' (standard deviation `r fmt(wtab$sd[wtab$arm == "default"], 4)`) and the `cold` arm
#' `r fmt(wtab$mean[wtab$arm == "cold"], 3)` (`r fmt(wtab$sd[wtab$arm == "cold"], 4)`);
#' the difference by seed is `r fmt(wtab[["minus cold"]][wtab$arm == "default"], 3)`
#' (s.e. `r fmt(wtab[["s.e."]][wtab$arm == "default"], 3)`), positive in
#' `r wtab[["seeds above cold"]][wtab$arm == "default"]` of `r nrow(wa)` seeds, about
#' `r fmt(100 * wtab[["minus cold"]][wtab$arm == "default"] / wtab$mean[wtab$arm == "cold"], 0)`%
#' of the cold mean. The ratio of the two standard deviations is
#' `r fmt(wtab$sd[wtab$arm == "cold"] / wtab$sd[wtab$arm == "default"], 2)`
#' (variance-ratio test $p =$
#' `r fmt(var.test(wa[["cold"]], wa[["default"]])$p.value, 2)`). The `default` plan is
#' below the best feasible greedy plan of the 60-value grid
#' (`r fmt(mean_index(best_fine, ctx), 4)`) in
#' `r sum(wa[["default"]] < mean_index(best_fine, ctx))` of `r nrow(wa)` seeds, and
#' below that of the benchmark grid (`r fmt(mean_index(best_bench, ctx), 4)`) in
#' `r sum(wa[["default"]] < mean_index(best_bench, ctx))`. The one-plan arms recover
#' `r fmt(100 * wtab[["minus cold"]][wtab$arm == "w = 0 only"] / wtab[["minus cold"]][wtab$arm == "default"], 0)`%
#' (`w = 0 only`, s.e. `r fmt(wtab[["s.e."]][wtab$arm == "w = 0 only"], 3)`) and
#' `r fmt(100 * wtab[["minus cold"]][wtab$arm == "truncation only"] / wtab[["minus cold"]][wtab$arm == "default"], 0)`%
#' (`truncation only`) of the `default` difference. Adding the best feasible greedy
#' plan to the `default` seeds raises the mean to
#' `r fmt(wtab$mean[wtab$arm == "default + best greedy"], 3)`, that is
#' `r fmt(mean(wa[["default + best greedy"]] - mean_index(best_fine, ctx)), 3)` above
#' that plan on average (range
#' `r fmt(min(wa[["default + best greedy"]] - mean_index(best_fine, ctx)), 3)` to
#' `r fmt(max(wa[["default + best greedy"]] - mean_index(best_fine, ctx)), 3)`).
#' The diversity constraint is soft, so the improvement has to be read together with
#' the feasibility of the plans: `r wtab[["over budget"]][wtab$arm == "default + best greedy"]`
#' of the `r nrow(wa)` `default + best greedy` plans exceed the 1% budget (their
#' $\alpha$ runs from
#' `r fmt(100 * min(wa_alpha[["default + best greedy"]]), 3)` to
#' `r fmt(100 * max(wa_alpha[["default + best greedy"]]), 3)`%), and the numbers of
#' plans over budget are
#' `r paste0(wtab$arm, " ", wtab[["over budget"]], collapse = ", ")`.
#' 
#' *Interpretation, with its limits.* The warm start is worth about the difference
#' above at this scale and budget, in the direction of the package's design
#' decision, and a single cold run is not reportable (the cold arm's range,
#' `r fmt(diff(range(wa[["cold"]])), 3)`, is
#' `r fmt(100 * diff(range(wa[["cold"]])) / wtab[["minus cold"]][wtab$arm == "default"], 0)`%
#' of the difference being measured). A smaller spread of the warm arm is not
#' established: a ratio of `r fmt(wtab$sd[wtab$arm == "cold"] / wtab$sd[wtab$arm == "default"], 1)`
#' is what these 20 seeds show. The DE can improve on a greedy plan when that plan
#' is among its seeds (a DE cannot return a worse plan than the best of its initial
#' population, so the informative number is the size of the improvement, which is
#' positive in every seed, with
#' `r wtab[["over budget"]][wtab$arm == "default + best greedy"]` of those plans over
#' the budget). The default seeds are not that: the grid `sel_de()` hard-codes lies
#' above the crossover except for $\omega = 0$, and the best feasible greedy plan is
#' not among them. Which feature of the seeds carries the effect is **not identified**
#' by these arms: the default seeds contain few distinct plans
#' (@tbl-combinatorial-seeds), `w = 0 only` is not distinguishable from `cold` at 20
#' seeds, and `truncation only` recovers part of the effect, so the number of copies
#' of the infeasible truncation plan in the population (several in the default, one in
#' `truncation only`) may matter; an arm that varies it was not run, and a
#' "dimensional" explanation of the effect was not tested. All of this is one
#' dataset at book scale and one evaluation budget, `r ev(de_cfg$evaluations[1])`: the
#' cold arm and the five-arm ablation were not run at another evaluation budget (the
#' next subsection runs the default warm start alone at two larger ones) and I did not
#' measure either at another scale. Widening the seed grid is a change to the package rather than to the call, and it
#' is not made here: every number in this book was produced with `sel_de()` as it
#' stands.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-combinatorial-seeds
#| tbl-cap: "The eight seeds `sel_de()` builds for itself (greedy plans at the listed index weights `w`), book scale, 1% budget. Columns: `w`; mean index; $\\alpha$ in percent; the fitness of `make_fitness()` on the penalised scale (minimised; a random plan scores near zero)."
fit <- make_fitness(ctx, n_sel, alpha_max, null$gd_ref)
seeds <- default_seeds
n_trunc_seeds <- sum(vapply(seeds, setequal, logical(1), sels[["truncation"]]))
n_distinct_seeds <- length(unique(lapply(seeds, sort)))
knitr::kable(fmt(data.frame(
  w         = seed_w,
  index     = vapply(seeds, mean_index, numeric(1), ctx = ctx),
  alpha_pct = 100 * vapply(seeds, alpha_loss, numeric(1), ctx = ctx,
                           gd_ref = null$gd_ref),
  fitness   = vapply(seeds, function(s) fit(s + 0.5), numeric(1))), 4),
  row.names = FALSE)

#' 
#' Of the eight seeds, `r n_trunc_seeds` are the truncation plan, so there are
#' `r n_distinct_seeds` distinct plans: the hard-coded grid lies above the
#' crossover measured earlier at every value but $\omega = 0$. At the 1% budget the truncation plan is infeasible,
#' which the penalty converts into a fitness of about
#' `r fmt(fit(seeds[[2]] + 0.5), 0)` on a scale where a random plan scores near
#' zero; the one feasible seed is the $\omega = 0$ plan at index
#' `r fmt(mean_index(seeds[[1]], ctx), 3)`.
#' 
#' The limitation, stated where the result is: at book scale and
#' `r ev(de_cfg$evaluations[1])` evaluations the warm-started DE
#' (`r fmt(mean_index(de_idx, ctx), 3)` at seed 9, `r fmt(wtab$mean[wtab$arm == "default"], 3)`
#' over 20 seeds) is still below the best feasible greedy plan of both grids
#' (`r fmt(mean_index(best_fine, ctx), 3)` and `r fmt(mean_index(best_bench, ctx), 3)`)
#' at the 1% budget. At that evaluation budget the DE's advantage is not raw index
#' but that it is parameterised by $\alpha_{\max}$, so it can be asked for a budget
#' the greedy grid does not happen to land on; whether it holds at a larger budget is
#' measured next, for the 1% budget only. A method that beats both on index, at a
#' fraction of the wall-clock, is in @sec-advanced.
#' 
#' ### The evaluation budget {#sec-combinatorial-budget}
#' 
#' Every `sel_de()` run above has `NP` $\times$ `itermax` =
#' `r ev(de_cfg$evaluations[1])` evaluations, and the frontier below has
#' `r ev(ev_front)`, against the printed default of `r ev(de_cfg$evaluations[3])`
#' (the `sel_de` listing above). The same function and the same call, changing only
#' `NP` and `itermax`, was run at three evaluation budgets at the 1% diversity budget, seeds 1 to 10, with
#' `set.seed()` immediately before each run and the default warm start (`seeds = NULL`)
#' in every one. Evaluations are nominal, `NP` $\times$ `itermax`; `DEoptim` also
#' evaluates the initial population. The first configuration repeats the `default`
#' arm of @tbl-combinatorial-warm for seeds 1 to 10, which the chunk asserts.
#' 
## -----------------------------------------------------------------------------
#| label: de-budget
bud <- do.call(rbind, lapply(seq_len(nrow(de_cfg)), function(i)
  do.call(rbind, lapply(1:10, function(sd_) {
    set.seed(sd_)
    t0 <- proc.time()[["elapsed"]]
    r <- suppressWarnings(sel_de(ctx, n_sel, alpha_max, null$gd_ref,
                                 NP = de_cfg$NP[i], itermax = de_cfg$itermax[i]))
    data.frame(config = de_cfg$label[i], seed = sd_, index = mean_index(r, ctx),
               alpha = alpha_loss(r, ctx, null$gd_ref),
               secs = proc.time()[["elapsed"]] - t0)
  }))))
stopifnot(isTRUE(all.equal(bud$index[bud$config == "chapter"],
                           wa[["default"]][wa$seed <= 10])))
gf_best <- mean_index(best_fine, ctx); gb_best <- mean_index(best_bench, ctx)
bud_tab <- do.call(rbind, lapply(seq_len(nrow(de_cfg)), function(i) {
  d <- bud[bud$config == de_cfg$label[i], ]
  data.frame(NP = de_cfg$NP[i], itermax = de_cfg$itermax[i],
             evaluations = de_cfg$evaluations[i],
             `mean index` = mean(d$index), sd = sd(d$index),
             min = min(d$index), max = max(d$index),
             `above fine greedy` = sum(d$index > gf_best),
             `above benchmark greedy` = sum(d$index > gb_best),
             `over budget` = sum(d$alpha > alpha_max),
             `above fine greedy, within budget` = sum(d$index > gf_best & d$alpha <= alpha_max),
             `max excess (pp)` = 100 * max(0, d$alpha - alpha_max),
             `mean alpha (%)` = 100 * mean(d$alpha), `mean seconds` = mean(d$secs),
             check.names = FALSE)
}))
# the reading below: no seed above the best feasible fine greedy at the chapter's budget, every seed above it at both larger ones
stopifnot(bud_tab[["above fine greedy"]] == c(0, 10, 10))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-combinatorial-budget
#| echo: false
#| tbl-cap: "`sel_de()` at three evaluation budgets, 1% budget, book scale, seeds 1 to 10 each, default warm start; only `NP` and `itermax` change. Columns: `NP`; `itermax`; nominal evaluations (`NP` times `itermax`); mean, standard deviation, minimum and maximum of the index over seeds; the number of the 10 plans above the best feasible greedy plan of the 60-value grid and of the 20-value benchmark grid; the number whose own $\\alpha$ exceeds the 1% budget; the number above the fine-grid greedy plan and within budget; the largest excess over the budget in percentage points; the mean $\\alpha$; mean wall-clock seconds per run on this machine."
knitr::kable(fmt(bud_tab, 5), row.names = FALSE)

#' 
#' *Result.* The mean index is `r fmt(bud_tab[["mean index"]][1], 3)` at
#' `r ev(bud_tab$evaluations[1])` evaluations, `r fmt(bud_tab[["mean index"]][2], 3)` at
#' `r ev(bud_tab$evaluations[2])` and `r fmt(bud_tab[["mean index"]][3], 3)` at
#' `r ev(bud_tab$evaluations[3])`; the best feasible greedy plan of the 60-value grid
#' is `r fmt(gf_best, 4)`. The number of the 10 plans above it is
#' `r paste(bud_tab[["above fine greedy"]], collapse = ", ")` in that order, and
#' `r paste(bud_tab[["over budget"]], collapse = ", ")` of the 10 plans exceed the
#' budget (largest excess `r format(max(bud_tab[["max excess (pp)"]]), scientific = FALSE, digits = 2)`
#' percentage points). Among the plans within budget, the numbers above the fine-grid greedy plan
#' are `r paste(bud_tab[["above fine greedy, within budget"]], "of", 10 - bud_tab[["over budget"]], collapse = ", ")`
#' in that order. The standard
#' deviation over seeds falls from `r fmt(bud_tab$sd[1], 4)` to
#' `r fmt(bud_tab$sd[3], 4)`, and the wall-clock per run rises from
#' `r fmt(bud_tab[["mean seconds"]][1], 1)` to `r fmt(bud_tab[["mean seconds"]][3], 1)`
#' seconds on this machine.
#' 
#' *Interpretation, and what limits it.* "The DE is below the best feasible greedy
#' plan" is a statement about `r ev(ev_front)` to `r ev(de_cfg$evaluations[1])`
#' evaluations at the 1% budget; at four times the chapter's budget and at the printed
#' default the DE is above that plan in all 10 seeds, so the sentence does not hold at
#' the budget of the printed defaults. The chapter applied the same
#' objection to the cached $N$-key run ("a statement about that budget"); it applies
#' here. What the table does not show: the other four diversity budgets of the frontier were run
#' at `r ev(ev_front)` evaluations only, so their position at a larger budget is not
#' known; the cold-versus-warm effect and the ablation were run at
#' `r ev(de_cfg$evaluations[1])` evaluations only, so whether the warm start is worth
#' anything at `r ev(de_cfg$evaluations[3])` is not known; whether the gain at the
#' larger budgets comes from the evaluations or from the seeds working together with
#' them was not separated; the wall-clock of a DE run was not compared here with that of
#' the greedy sweep; and it is one dataset, one simulation seed, one budget of
#' diversity, 10 optimiser seeds.
#' 
#' ### Checking convergence against the bound
#' 
#' @sec-relaxation derived the bound. For every plan $S$ with $\theta_S \le
#' \theta_{\max}$, where $\theta_{\max} = 1 - GD_{\text{ref}}(1 - \alpha_{\max})$
#' (@eq-ocs-theta-max) and $\bar u_S$ is the mean index (@eq-ocs-problem),
#' 
#' $$\bar u_S \;\le\; \min_{\lambda \ge 0}\,\bigl[\,V(\lambda) + \lambda\,\theta_{\max}\bigr]$$
#' 
#' (@eq-ocs-bound, with $V(\lambda)$ the optimum of the continuous relaxation,
#' @eq-ocs-V; $\lambda$ the multiplier on $\theta$, in index units per unit of
#' $\theta$). Every $\lambda$ gives a valid bound, so a coarse grid costs
#' tightness, not validity. `ocs_bound()` returns the minimum over a grid of
#' $\lambda$, doubles the number of projected-gradient iterations until the value
#' changes by less than a relative $10^{-3}$, and sets a `converged` attribute:
#' a *stalling* criterion on that doubling, not a certificate
#' (@sec-relaxation). An under-converged relaxation reports $V(\lambda)$ too
#' small, which makes the "bound" too small, so the attribute has to be read before
#' any gap is quoted (@sec-scaling).
#' 
## -----------------------------------------------------------------------------
#| label: ocs-bound
lam_grid <- 10^seq(0, 2.5, by = 1 / 6)            # 16 multipliers, as in @sec-relaxation
bound <- ocs_bound(ctx, n_sel, alpha_max, null$gd_ref, lambdas = lam_grid)
relax <- attr(bound, "relaxation")                # one row per lambda, converged
a_relax <- (null$gd_ref - relax[, "GD"]) / null$gd_ref
stopifnot(attr(bound, "converged"))
theta_max <- 1 - null$gd_ref * (1 - alpha_max)
stopifnot(isTRUE(all.equal(
  as.numeric(bound),
  min(relax[, "index"] - relax[, "lambda"] * relax[, "theta"] +
        relax[, "lambda"] * theta_max))))
c(upper_bound = as.numeric(bound), lambda_star = attr(bound, "lambda"),
  iterations = attr(bound, "iters"), converged = attr(bound, "converged"),
  theta_max = theta_max)

#' 
#' The gap of the DE plan (seed 9, `r ev(de_cfg$evaluations[1])` evaluations) to the bound is
#' `r fmt(100 * (as.numeric(bound) - mean_index(de_idx, ctx)) / as.numeric(bound), 1)`%,
#' and that of the best feasible greedy plan (fine grid)
#' `r fmt(100 * (as.numeric(bound) - mean_index(best_fine, ctx)) / as.numeric(bound), 1)`%.
#' Here the stalling flag is TRUE, at `r attr(bound, "iters")` iterations. A gap is the
#' sum of two shortfalls, that of the plan from the best discrete plan and that of
#' the best discrete plan from the bound (the bound is that of a continuous
#' relaxation of a discrete problem), and the gap alone does not separate them. At
#' the book scale the second is limited by the benchmark of @sec-advanced: its
#' simulated-annealing plan reaches `r fmt(bmean("book", "anneal"), 3)` against its own
#' bound `r fmt(bmean("book", "anneal", "bound"), 3)`, a gap of
#' `r fmt(bmean("book", "anneal", "gap_pct"), 1)`% (3 seeds; the benchmark computes
#' its reference from $B$ = 500 random subsets, this chapter from 400, hence the
#' slightly different bound). So at this scale and evaluation budget most of the DE's
#' gap is the optimiser's, not the relaxation's; that reading holds only where the bound is
#' certified and the relaxation is known to be tight. At the benchmark production
#' scale the flag is FALSE in
#' `r sum(!bench$bound_certified[bench$scale == "production"])` of
#' `r sum(bench$scale == "production")` rows, so no gap there is quoted, and "a large
#' gap means the optimiser has not converged" cannot be applied.
#' 
#' ::: {.callout-tip}
#' ## If the DE ever looks unconvincing on real data
#' 
#' @debeukelaer2018, optimising core-collection subsets with stochastic search
#' rather than DE, rank three search algorithms of the Core Hunter framework on the
#' same objective across four crop datasets -- rice, coconut, maize and pea -- in the
#' Results section "Optimizing E-NE and A-NE with local searches": parallel
#' tempering first, a genetic algorithm second, and random descent -- a plain
#' stochastic hill-climber -- third, with all twelve pairwise comparisons
#' significant under a Holm-adjusted Wilcoxon test. The objective of that comparison
#' is E-NE only, the average distance from each selected entry to its nearest other
#' selected entry (the authors state they ran these experiments only for E-NE): a
#' distance-based diversity measure, not allele coverage. The genetic algorithm
#' therefore *does* beat the hill-climber on raw score. What it does not do is win,
#' and the method that wins is the one assembled from many simple local searches run
#' in parallel, not the one with the more elaborate update rule.
#' 
#' The inference, stated separately from that result and limited by it: extra
#' sophistication inside a *single-solution* algorithm bought a rank there and not
#' the win, which is a weak reason to spend complexity on the optimiser and no
#' reason at all to expect a DE to be the right one. It is one application, on a
#' distance-based objective without an index or a coancestry budget, so it
#' transfers as a prior about where effort pays and not as a result. That
#' direction is taken up in @sec-advanced, which builds the local search on the
#' `O(L)` swap this package already had and measures it against the DE at equal
#' wall-clock.
#' :::
#' 
#' ## The full frontier {#sec-combinatorial-frontier}
#' 
#' One optimisation per budget, which is the $\varepsilon$-constraint method of
#' @haimes1971: maximise one objective (the index) subject to a bound on the other
#' ($\alpha \le \alpha_{\max}$). Each point is a plan that can be put in front of a
#' committee, described by the budget it respects rather than by an exchange rate
#' nobody can interpret. Each budget is run with 10 seeds, at `NP` = 100 and
#' `itermax` = 180: `r ev(ev_front)` evaluations, against the `r ev(de_cfg$evaluations[3])`
#' of the printed defaults of `sel_de()`.
#' 
## -----------------------------------------------------------------------------
#| label: full-frontier-runs
seeds_front <- 45:54
fr <- do.call(rbind, lapply(alphas, function(a) do.call(rbind, lapply(seeds_front, function(sd_) {
  set.seed(sd_)
  r <- suppressWarnings(sel_de(ctx, n_sel, a, null$gd_ref, NP = 100, itermax = 180))
  data.frame(alpha_max = a, seed = sd_, alpha = alpha_loss(r, ctx, null$gd_ref),
             index = mean_index(r, ctx), Ne_par = ne_parents(r, ctx))
}))))
front <- do.call(rbind, lapply(split(fr, fr$alpha_max), function(d) data.frame(
  alpha_max = d$alpha_max[1], DE_mean = mean(d$index), DE_sd = sd(d$index),
  DE_min = min(d$index), DE_max = max(d$index), alpha_mean = mean(d$alpha))))
rownames(front) <- NULL
front$greedy_fine  <- vapply(front$alpha_max, function(a) gf$index[best_within(gf, a)], numeric(1))
front$greedy_bench <- vapply(front$alpha_max, function(a) gb$index[best_within(gb, a)], numeric(1))
front$seeds_above_fine  <- vapply(seq_len(nrow(front)), function(i)
  sum(fr$index[fr$alpha_max == front$alpha_max[i]] > front$greedy_fine[i]), integer(1))
front$seeds_above_bench <- vapply(seq_len(nrow(front)), function(i)
  sum(fr$index[fr$alpha_max == front$alpha_max[i]] > front$greedy_bench[i]), integer(1))
over <- fr$alpha - fr$alpha_max                        # > 0: the soft constraint is violated
n_within <- sum(over <= 0)
# the claim of the introduction: the DE's mean is below the best feasible greedy of the fine grid
stopifnot(all(front$DE_mean < front$greedy_fine))

#' 
## -----------------------------------------------------------------------------
#| label: fig-combinatorial-frontier
#| fig-cap: "Everything together at book scale (n = 60, N = 625, simulation seed 1). Red: the constrained DE, one point per seed (10 seeds per budget, `NP` = 100, `itermax` = 180, 18,000 evaluations) and the mean per budget joined by a line. Blue dots: the 60 plans of the greedy sweep (not joined: no plan exists between them). Grey circles, dashed: the continuous relaxation of @sec-relaxation, one point per multiplier, joined by chords that lie below the continuous frontier. Triangle: the Lagrangian bound of @eq-ocs-bound at the 1% budget (dotted vertical line). The height of a relaxation point bounds only plans at least as diverse as that point; the triangle bounds every plan inside the budget."
#| fig-alt: "Mean index against diversity loss: red DE points near the greedy cloud but mostly below it, a grey dashed relaxation curve above both, and a triangle at the 1 percent budget above all."
plot(NA, xlab = "gene diversity loss, alpha (%)", ylab = "mean index (s.d.)",
     xlim = 100 * range(c(fr$alpha, gf$alpha, a_relax)),
     ylim = range(c(fr$index, gf$index, relax[, "index"], as.numeric(bound))))
lines(sort(a_relax) * 100, relax[order(a_relax), "index"], type = "b", pch = 1,
      lty = 2, col = "grey55", cex = 0.7)
points(gf$alpha * 100, gf$index, pch = 19, cex = 0.5, col = "#1f5f8b")
points(fr$alpha * 100, fr$index, pch = 19, cex = 0.5, col = "#b2182b66")
lines(front$alpha_mean * 100, front$DE_mean, type = "b", pch = 19, lwd = 2, col = "#b2182b")
points(alpha_max * 100, as.numeric(bound), pch = 2, cex = 1.4, lwd = 2)
abline(v = 0, lty = 3); abline(v = alpha_max * 100, lty = 3)
legend("bottomright",
       c("constrained DE (mean, and seeds)", "greedy sweep, 60 plans",
         "continuous relaxation", "Lagrangian bound at 1%"),
       col = c("#b2182b", "#1f5f8b", "grey55", "black"), pch = c(19, 19, 1, 2),
       lty = c(1, NA, 2, NA), lwd = c(2, 1, 1, 1), bty = "n", cex = 0.8)
grid()

#' 
## -----------------------------------------------------------------------------
#| label: tbl-combinatorial-frontier
#| echo: false
#| tbl-cap: "The DE (`NP` = 100, `itermax` = 180, 18,000 evaluations) against the best feasible greedy plan at five budgets, book scale (@fig-combinatorial-frontier). Columns: the budget $\\alpha_{\\max}$; the DE's mean index over 10 seeds, its standard deviation, minimum and maximum; the best greedy plan whose own $\\alpha \\le \\alpha_{\\max}$, on the 60-value grid and on the 20-value benchmark grid; the number of the 10 seeds whose DE plan is above each."
knitr::kable(fmt(front[, c("alpha_max", "DE_mean", "DE_sd", "DE_min", "DE_max",
                           "greedy_fine", "greedy_bench",
                           "seeds_above_fine", "seeds_above_bench")], 4),
             row.names = FALSE)

#' 
#' Three things to read, in this order.
#' 
#' **The constraint does its job, softly.** In `r n_within` of `r nrow(fr)` runs the DE
#' plan's $\alpha$ is within its budget; the other `r nrow(fr) - n_within` exceed it by
#' at most `r fmt(100 * max(over), 4)` percentage points, which the penalty prices at
#' `r fmt(1000 * max(over), 3)` index units at most -- the constraint is a penalty, as the
#' procedure above says, and the returned plan has to be checked. The mean realised
#' $\alpha$ is `r paste(fmt(100 * front$alpha_mean, 2), collapse = ", ")`% for budgets
#' `r paste(100 * front$alpha_max, collapse = ", ")`%: the optimiser spends nearly the
#' diversity it was allowed and no more. A plan that lands far inside its budget has
#' not been constrained by it, and whatever else is limiting it -- the cap, the
#' penalty scale, an unconverged search -- has to be identified before the frontier
#' is read as a price list.
#' 
#' **The comparison against greedy depends on the greedy grid.** Result: against
#' the best feasible plan of the 60-value grid the DE's mean is lower at all
#' `r nrow(front)` budgets, by
#' `r paste(fmt(front$greedy_fine - front$DE_mean, 3), collapse = ", ")` index units
#' from the smallest to the largest budget, and
#' `r sum(front$seeds_above_fine)` of the `r nrow(fr)` DE runs are above it. Against
#' the 20-value benchmark grid the DE's mean is above the greedy at
#' `r sum(front$DE_mean > front$greedy_bench)` of the `r nrow(front)` budgets, with
#' `r sum(front$seeds_above_bench)` of `r nrow(fr)` runs above it; there the greedy has no point
#' near the budget (between two consecutive values of $\omega$ the sweep steps over the whole interval, and
#' the best *feasible* plan is one from far inside it). Interpretation: the count of
#' budgets at which the DE is ahead is a property of the greedy grid, and it
#' reverses on a finer one. At this scale, on this dataset, with `sel_de()` and its
#' default warm start at `r ev(ev_front)` evaluations, the DE buys the ability to hit a
#' requested budget, not a better plan than a fine greedy sweep. That statement is
#' about that evaluation budget: at the 1% budget the mean DE index passes the fine
#' greedy plan at `r ev(de_cfg$evaluations[2])` evaluations
#' (@sec-combinatorial-budget), and the other four diversity budgets were not run above
#' `r ev(ev_front)`. The 10 seeds give the DE side a measured
#' spread (standard deviation `r paste(fmt(front$DE_sd, 3), collapse = ", ")` across the
#' five budgets); the greedy side has none because it is deterministic; the grid
#' resolution is a tuning choice that moves the verdict; and this is one dataset and
#' one simulation seed, not measured at another scale.
#' 
#' **The dashed curve is the relaxation; the triangle is the bound.**
#' Each grey point is the index maximiser of the continuous problem at its own
#' diversity, so by weak duality (@eq-ocs-weak) it bounds every discrete plan *at
#' least as diverse as itself*. What does not follow is a bound for a plan that
#' spends the whole budget when the point lies strictly inside it
#' (@sec-relaxation, statement 3): there the height of the point depends on the
#' grid of $\lambda$. In this run the highest relaxation point inside the 1% budget
#' is `r fmt(max(relax[a_relax <= alpha_max, "index"]), 3)`, below the best feasible
#' greedy plan (`r fmt(mean_index(best_fine, ctx), 3)`), and the bound
#' (`r fmt(as.numeric(bound), 3)`) lies above both; @sec-relaxation shows how this
#' height moves with the grid, and @sec-bound shows that the construction "best
#' relaxation point inside the budget" is not a bound. The vertical distance to the
#' bound at $\alpha_{\max}$ is what @sec-advanced spends its effort on.
#' 
#' ## Which strategy to use
#' 
#' Two of the strategies have a benchmark with a cap and a budget together, at two
#' scales, in the file of @sec-advanced. It is read here on its capped rows, with
#' the dispersion it carries.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-combinatorial-capped
#| echo: false
#| tbl-cap: "The capped rows of `search_benchmark.csv` (3 seeds per method and scale; regenerated by `regenerate.R search`), budget $\\alpha_{\\max}$ = 1%, at the benchmark book and production scales and caps named in the Scale paragraph of this chapter. Columns: scale; method; mean index; standard deviation over seeds; $\\alpha$ in percent; maximum uses of one line; mean seconds. `greedy_cap` needs the $N \\times N$ matrix `f`. A standard deviation of 0 means the three seeds returned the same plan value. The cap of the benchmark book scale is not the cap of this chapter's capped truncation."
caps <- c("greedy_cap", "ocs_round_cap", "tempering_cap", "de_hybrid_cap", "de_lines_cap")
tab <- do.call(rbind, lapply(c("book", "production"), function(sc)
  do.call(rbind, lapply(caps, function(m) data.frame(
    scale = sc, method = m, index = bmean(sc, m), `sd over seeds` = sd(bv(sc, m)),
    `alpha %` = 100 * bmean(sc, m, "alpha"), `max uses` = bmean(sc, m, "max_line"),
    seconds = bmean(sc, m, "secs"), check.names = FALSE)))))
knitr::kable(fmt(tab, 4), row.names = FALSE)

#' 
## -----------------------------------------------------------------------------
#| label: capped-numbers
#| include: false
idx_prod <- vapply(caps, bmean, numeric(1), scale = "production")
alpha_prod <- 100 * vapply(caps, bmean, numeric(1), scale = "production", col = "alpha")
sd_prod <- vapply(caps, function(m) sd(bv("production", m)), numeric(1))
sd_book <- vapply(caps, function(m) sd(bv("book", m)), numeric(1))
stopifnot(all(sd_prod == 0), all(sd_book == 0))   # sd 0 in every capped cell (the text says so)
same4 <- function(m1, m2, col) isTRUE(all.equal(round(bmean("book", m1, col), 4),
                                                 round(bmean("book", m2, col), 4)))
stopifnot(same4("de_hybrid_cap", "tempering_cap", "index"),
          same4("de_hybrid_cap", "tempering_cap", "alpha"),
          same4("de_lines_cap", "ocs_round_cap", "index"),
          same4("de_lines_cap", "ocs_round_cap", "alpha"))
f_gib <- bs["production", "N"]^2 * 8 / 2^30

#' 
#' *Result.* At the benchmark production scale the five capped routes return
#' `r fmt(min(idx_prod), 4)` to `r fmt(max(idx_prod), 4)`, a spread of
#' `r sprintf("%.4f", max(idx_prod) - min(idx_prod))` with a seed standard deviation of 0
#' in every route, and $\alpha$ of
#' `r fmt(min(alpha_prod), 2)` to `r fmt(max(alpha_prod), 2)`% against a budget of 1%.
#' The cap binds there (`max uses` equals the cap) and the budget does not. At the
#' benchmark book scale the capped routes reach `r fmt(min(tab$index[tab$scale == "book"]), 3)`
#' to `r fmt(max(tab$index[tab$scale == "book"]), 3)` with $\alpha$ near the budget
#' (`r fmt(min(tab[["alpha %"]][tab$scale == "book"]), 2)` to
#' `r fmt(max(tab[["alpha %"]][tab$scale == "book"]), 2)`%); `de_hybrid_cap` returns the
#' `tempering_cap` row and `de_lines_cap` the `ocs_round_cap` row to the four decimals of
#' the table, in index and in $\alpha$. `greedy_cap` needs the
#' $N \times N$ matrix, which at $N =$ `r format(bs["production", "N"], big.mark = ",")` is
#' `r fmt(f_gib, 3)` GiB in double precision.
#' *Interpretation:* at the production scale the difference between capped routes is
#' `r sprintf("%.4f", max(idx_prod) - min(idx_prod))` with no seed spread to judge it by, a
#' tie, and with the budget slack the capped problem there is a cap-only problem, so
#' the routes are ranked by cost and memory and not by index; at the book scale the
#' routes differ in index by more than that, and the table does not rank them beyond
#' reading it. Timings of a few milliseconds are means of 3 single calls and do not
#' separate `greedy_cap` from `ocs_round_cap` at the book scale. All of this is one
#' simulated dataset per scale and three seeds.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-combinatorial-strategy
#| echo: false
#| tbl-cap: "Which strategy for which situation. The rows run from cheapest to most expensive; the evidence for the last two rows is @tbl-combinatorial-capped, @tbl-combinatorial-frontier, @tbl-combinatorial-warm and @tbl-combinatorial-budget."
knitr::kable(data.frame(
  Situation = c("The constraint is inactive ($\\alpha_{\\max} \\ge \\alpha_{\\text{trunc}}$)",
                "A per-line cap already meets the constraint",
                "One-off analysis, small candidate set, any budget",
                "A cap and a budget, large candidate set",
                "A budget the $\\omega$ grid steps over, or an $N_{e,\\text{par}}$ floor"),
  Use = c("truncation -- nothing to optimise",
          "`sel_truncation_cap()` -- no matrix needed",
          "`sel_greedy()` swept over $\\omega$ on a grid that starts well below the crossover and ends above the weight from which the plan is truncation; the fine grid, not round numbers",
          "`sel_greedy(max_use = cap)` swept over $\\omega$; at the benchmark production scale the capped routes tie on index and differ in cost",
          paste0("an optimiser. `sel_de()` for a budget: at the 1% budget its mean index was below the best fine greedy plan at ",
                 ev(ev_front), " to ", ev(de_cfg$evaluations[1]), " evaluations and above it at ",
                 ev(de_cfg$evaluations[2]), " and at the default ", ev(de_cfg$evaluations[3]),
                 " (@tbl-combinatorial-budget); the other four diversity budgets were run at ", ev(ev_front),
                 " evaluations only (below it), so for them the table supports no recommendation of `sel_de()` over a fine greedy sweep. Seeding it with the best greedy plan improved on that plan at ",
                 ev(de_cfg$evaluations[1]), " evaluations, 1% budget only. `sel_de_fast()` for an $N_{e,\\text{par}}$ floor, the only route of @sec-advanced with an argument for it")),
  check.names = FALSE), escape = FALSE)

#' 
#' As an order of operations at the end of a cycle:
#' 
#' 1. Build the contract objects and print the instance panel at the top of this
#'    chapter. Confirm `gd_ref` was computed at the `n_sel` you will actually use.
#' 2. Compute $\alpha_{\text{trunc}}$ from truncation. If it is below your intended
#'    $\alpha_{\max}$, stop: the constraint is inactive and truncation is the
#'    answer.
#' 3. Run `sel_truncation_cap()`. It costs nothing and needs no matrix. If it
#'    meets the budget at an acceptable index, stop.
#' 4. Sweep `sel_greedy()` over an $\omega$ grid that begins well below the
#'    crossover measured from your own data (here the index starts rising about
#'    `r fmt(1 / window_ends["fine_60", "first_rise_x_crossover"], 0)` times below it) and
#'    ends above the point where the plan becomes truncation, not a grid of round
#'    numbers. Read the frontier and locate the knee.
#' 5. Only if a specific budget has to be hit, or an $N_{e,\text{par}}$ floor
#'    applies, run an optimiser, with an evaluation budget of the order of the printed
#'    default of `sel_de()` (at the 1% budget of this chapter's dataset
#'    `r ev(de_cfg$evaluations[1])` evaluations did not pass the best fine greedy plan
#'    and `r ev(de_cfg$evaluations[2])` did) -- and warm-start it, with the best
#'    feasible greedy plan among the seeds (measured at `r ev(de_cfg$evaluations[1])`
#'    evaluations only).
#' 6. Whatever returned the plan, validate it on the second lens and on allelic
#'    richness before it leaves the analysis (@sec-case-study).
#' 
#' The summary, within what was measured here, which is one simulated dataset at the
#' book scale. At the chapter's evaluation budgets (`r ev(ev_front)` to
#' `r ev(de_cfg$evaluations[1])`), a fine greedy sweep reaches a higher index than
#' `sel_de()` at each of five budgets, and at those budgets what the DE offers is a
#' budget as its interface. At the 1% diversity budget, the only one run at larger evaluation
#' budgets, the DE's mean index is above the best fine greedy plan at
#' `r ev(de_cfg$evaluations[2])` evaluations and at the printed default of
#' `r ev(de_cfg$evaluations[3])` (@tbl-combinatorial-budget), at a wall-clock cost
#' that rises with the budget; seeded with the best greedy plan it improved on that
#' plan at `r ev(de_cfg$evaluations[1])` evaluations (@tbl-combinatorial-warm). The
#' worth of the warm start at the larger budgets, and the five-budget comparison
#' there, were not measured, and nothing here is measured at another scale. For the
#' capped case at the benchmark production scale something simpler is as good on
#' index, and the cost table of @sec-choosing-cost is the reason to check which row
#' you are in before writing any optimisation code. The claim that a restriction a
#' greedy cannot test (an $N_{e,\text{par}}$ floor) rules the cheap routes out rests
#' on the argument of @sec-advanced, not on a measurement in this chapter.
