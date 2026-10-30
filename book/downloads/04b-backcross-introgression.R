#' # Introgressing several genes by backcrossing {#sec-backcross}
#' 
# 04b-backcross-introgression -- standalone script of the chapter 04b-backcross-introgression.qmd
# Book: https://ederdbs.github.io/QG/04b-backcross-introgression.html
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
mb_sz    <- read.csv(book_data("mabc_analytical_sizing.csv"))
mb_uni   <- read.csv(book_data("mabc_uniform.csv"))
mb_alloc <- read.csv(book_data("mabc_allocation.csv"))
mb_f2    <- read.csv(book_data("mabc_bcnf2.csv"))
mb_idx   <- read.csv(book_data("mabc_index_comparison.csv"))
mb_re    <- read.csv(book_data("mabc_allocation_recheck.csv"))

# The run these tables come from. Results in the prose are computed from the
# tables or from package functions -- see the note on hard-coded numbers at the end.
MB <- list(n_bc = 3, s = 0.60, P = 0.95, ibd_target = 0.90,
           drag_per_gene = 30, flank_cM = 5, n_keep = 3)
# mabc_allocation.csv has no replicate or s column: these are the driver's
# alloc_rep and alloc_s (inst/scripts/run_mabc.R, DEFAULT_OPT)
MB_alloc <- list(n_rep = 40, s = 0.60)
# mabc_bcnf2.csv has no replicate column either: run_f2_scan() in
# inst/scripts/run_mabc.R draws 250 replicates per point, 80 above 500 plants.
# The CSV cannot identify the count, only check it: every p_ok must be a
# multiple of 1/n_rep for the count assigned to its row.
MB_f2 <- list(n_rep = 250, n_rep_large = 80, n_large = 500)
f2_rep <- ifelse(mb_f2$n_f2 > MB_f2$n_large, MB_f2$n_rep_large, MB_f2$n_rep)
stopifnot(all(abs(f2_rep * mb_f2$p_ok - round(f2_rep * mb_f2$p_ok)) < 1e-9))

# rec_drag, four genes, BC3, s = 0.60 in the uniform scan (used in several places)
u4 <- mb_uni[mb_uni$strategy == mabc_opt$main_strategy & mb_uni$s == MB$s &
               mb_uni$gen == MB$n_bc & mb_uni$genes == 4, ]

# Figure captions (computed; a YAML scalar cannot hold them inline)
cap_idx <- sprintf("Paired comparison (common random numbers, %d replicates per cell, s = %.2f, uniform schedule of N plants per backcross) of the background-priority index (rec_bg) against the drag-priority index (rec_drag). Points are the proportion of replicates meeting the criterion; bars are Clopper-Pearson 95%% intervals. The criterion is drag <= %d cM per gene AND IBD >= %.2f at BC%d. Dotted line: %.2f.", unique(mb_idx$n_rep), unique(mb_idx$s), MB$drag_per_gene, MB$ibd_target, MB$n_bc, MB$P)
cap_alloc <- sprintf("Background-priority index (rec_bg), s = %.2f, %d replicates per schedule. P(criterion met) against the share of the total budget spent on BC1 + BC2, for 1 and 3 genes. Faint points: individual schedules (a binomial proportion over %d replicates, s.e. up to %.3f); lines: mean over schedules within a total-budget bin and a 0.1-wide share bin. Not evidence under the drag-priority index; the schedules are compared under it in @tbl-bc-recheck.", MB_alloc$s, MB_alloc$n_rep, MB_alloc$n_rep, sqrt(0.25 / MB_alloc$n_rep))
cap_f2 <- sprintf("Fixation by selfing: probability of at least %d BC3F2 plants homozygous for the donor allele at all k targets, against the number of BC3F2 plants genotyped (log scale), k = 1 to 4. Points: simulation (mabc_bcnf2.csv), each a proportion over %d replicates (%d above %d plants; the defaults of run_f2_scan() in inst/scripts/run_mabc.R, which the CSV does not record but every value is consistent with), s.e. at most %.3f; no interval is drawn. The success criterion involves the targets only, so it does not depend on the selection index (rec_bg or rec_drag). Dashed: the cumulative binomial with q = (1/4)^k. Dotted line: P = %.2f. Each extra gene multiplies the BC3F2 requirement in the legend by %s.", MB$n_keep, MB_f2$n_rep, MB_f2$n_rep_large, MB_f2$n_large, sqrt(0.25 / MB_f2$n_rep_large), MB$P, paste(fmt(exp(diff(log(mb_sz$n_F2_3plants))), 2), collapse = ", "))
cap_pol <- local({u <- mb_uni[mb_uni$s == MB$s & mb_uni$gen == MB$n_bc & mb_uni$genes %in% c(1, 3), ]; sprintf("Mean total linkage drag at BC%d (left, cM) and the proportion of replicates with drag at or below the ceiling of %d cM per gene (right; drag only, not the joint drag-and-IBD criterion) under the four policies of @tbl-bc-policies, including the background-priority (rec_bg) and drag-priority (rec_drag) indices, against plants per generation in a uniform schedule, s = %.2f. Solid lines: 1 gene; dashed: 3 genes. %d-%d replicates per point (mabc_uniform.csv); no dispersion is shown. Dotted line: %.2f. Extending recombinant selection into BC3 costs no extra plants, only the flanking markers on plants that are being genotyped anyway.", MB$n_bc, MB$drag_per_gene, MB$s, min(u$n_rep), max(u$n_rep), MB$P)})
cap_siz <- sprintf("Analytical sizing by stage and number of target genes k, log scale, P = %.2f: exact cumulative binomial (mabc_analytical_sizing.csv), no simulation and no selection index involved. Light blue: backcross plants for one foreground-positive plant, q = (1/2)^k. Dark blue: backcross plants for one foreground-positive plant that is also recombinant in a %d cM flanking interval. Red: BC3F2 plants for %d homozygotes at all k targets by selfing, q = (1/4)^k. Green: DH lines for %d such lines, q = (1/2)^k. Bar labels give the counts.", MB$P, MB$flank_cM, MB$n_keep, MB$n_keep)

#' 
#' @sec-sizing sized a segregating population for *diversity*: the objective was to
#' sample as much of the cross as possible. This chapter is the mirror image.
#' A donor line carries $k$ genes worth having and an elite line carries everything
#' else worth having, and the job is to move the $k$ genes across while
#' **throwing the rest of the donor away**. Here donor genome is contamination, and
#' the only diversity that is wanted is the $k$ target loci themselves.
#' 
#' The operation is marker-assisted backcrossing (MABC). The numbers below come
#' from a simulator of it: a marker grid at 5 cM on ten maize chromosomes
#' (`r sum(maize_chr_len)` cM), one selected plant advanced per generation, $k = 1$ to $4$ recessive
#' targets from a single donor, on four different chromosomes, carried to the third backcross generation, BC`r MB$n_bc`.
#' The engine and the selection index are `R/08_mabc.R`; the experiment driver
#' `inst/scripts/run_mabc.R` writes tables of the shape of the six cached
#' `mabc_*.csv` files, but not every cached copy was written by its current
#' version; @sec-bc-running states which run produced each one and how to re-run it.
#' 
#' ## The operation, in one diagram
#' 
#' Before any sizing question can be asked, the crossing operations have to be
#' unambiguous -- which plant is pollinated by which, and what is genotyped at each
#' step (@fig-bc-flow).
#' 
## -----------------------------------------------------------------------------
#| label: fig-bc-flow
#| echo: false
#| fig-width: 6.5
#| fig-height: 7.2
#| fig-cap: "The marker-assisted backcrossing (MABC) operation for k target genes from one donor, schematic (no data). Left column: the cross made in each generation. Right column: what is genotyped and selected on, and the population size that criterion demands. The recurrent parent E re-enters at every backcross; the fork at the bottom is the fixation step, where doubled haploids and selfing differ by more than an order of magnitude in plants required at four genes. Selection at BC3 is shown as under the drag-priority index (rec_drag); the expected IBD annotation is for s = 0.60."
#| fig-alt: "Flow diagram of marker-assisted backcrossing: donor D crossed to elite E gives the F1, which is backcrossed to E three times (BC1 to BC3) with the selection criterion noted at each step, then forks into selfing (BC3F2, BC3F3) or doubled haploids, both ending in a converted elite line"
# Drawn at fig-width 6.5 in = the Typst text width, so cex * 12 pt is the printed size.
box <- function(x, y, w, h, lab, fill = "white", border = "grey25", cex = 0.72,
                font = 1) {
  rect(x - w/2, y - h/2, x + w/2, y + h/2, col = fill, border = border, lwd = 1.4)
  text(x, y, lab, cex = cex, font = font)
}
arr <- function(x0, y0, x1, y1, lty = 1, col = "grey25")
  arrows(x0, y0, x1, y1, length = 0.07, lwd = 1.5, lty = lty, col = col)
note <- function(y, txt, col = "grey20")
  text(7.65, y, txt, pos = 4, cex = 0.7, col = col, xpd = NA)

op <- par(mar = c(0.2, 0.2, 0.2, 0.2))
plot(NA, xlim = c(0, 13.2), ylim = c(0, 10.4), axes = FALSE, xlab = "", ylab = "")

elite <- "#1f5f8b"; donor <- "#c0392b"; dh <- "#2e7d32"

# --- parents ---------------------------------------------------------------
box(2.0, 9.65, 3.6, 0.9, "Donor D\nk target alleles,\ncoupling phase",
    fill = "#fdecea", border = donor)
box(6.0, 9.65, 3.0, 0.9, "Elite E (recurrent)\nfully inbred", fill = "#e8f1f8",
    border = elite)

# --- the recurrent-parent recycle line -------------------------------------
segments(6.0, 9.2, 6.0, 8.85, col = elite, lwd = 1.5)
segments(6.0, 8.85, 6.75, 8.85, col = elite, lwd = 1.5)
segments(6.75, 8.85, 6.75, 4.4, col = elite, lwd = 1.5, lty = 2)

# --- the backcross column --------------------------------------------------
ys <- c(F1 = 8.3, BC1 = 7.0, BC2 = 5.7, BC3 = 4.4)
labs <- c(F1 = "F1\n100% heterozygous\nat targets",
          BC1 = "BC1", BC2 = "BC2", BC3 = "BC3")
arr(2.2, 9.2, 3.6, 8.75)
arr(6.0, 9.2, 4.6, 8.75)
for (i in seq_along(ys)) {
  box(4.1, ys[i], 3.4, 0.8, labs[i], fill = "grey97",
      font = if (i == 1) 1 else 2)
  if (i > 1) {
    arr(4.1, ys[i-1] - 0.4, 4.1, ys[i] + 0.4)
    segments(6.75, ys[i], 6.0, ys[i], col = elite, lwd = 1.5, lty = 2)
    arrows(6.0, ys[i], 5.8, ys[i], length = 0.06, lwd = 1.5, col = elite)
    text(6.3, ys[i] + 0.22, "x E", cex = 0.7, col = elite)
  }
}

# --- the fixation fork -----------------------------------------------------
arr(4.1, 4.0, 2.6, 3.4); arr(4.1, 4.0, 5.6, 3.4)
box(2.0, 3.0, 3.6, 0.8, "BC3F1 selfed\n-> BC3F2", fill = "grey97")
box(5.8, 3.0, 3.4, 0.8, "BC3F1 gametes\n-> doubled\nhaploids", fill = "#eaf3ea",
    border = dh)
arr(2.0, 2.6, 2.0, 2.0); arr(5.8, 2.6, 5.8, 2.0)
box(2.0, 1.6, 3.6, 0.8, "BC3F3\nphenotypic\nconfirmation", fill = "white")
box(5.8, 1.6, 3.4, 0.8, "DH lines\nhomozygous\neverywhere", fill = "white",
    border = dh)
arr(2.0, 1.2, 3.4, 0.75); arr(5.8, 1.2, 4.8, 0.75)
box(4.1, 0.42, 6.2, 0.62, "Converted elite line: k targets fixed",
    fill = "#eef4ea", border = dh, cex = 0.78, font = 2)

# --- the annotation column -------------------------------------------------
segments(7.55, 0.1, 7.55, 10.1, col = "grey85", lwd = 1)
note(8.4, "Every target heterozygous.\nNothing to select yet.")
note(7.15, paste0("Foreground: keep plants heterozygous\nat all k targets, q = (1/2)^k.",
                  "\nRecombinant: genotype the flanking\nmarkers at +/- ", MB$flank_cM,
                  " cM and keep\nthe crossovers."))
note(5.65, "Same two criteria. Background donor\ncontent is already halving on its\nown -- do not spend the index on it.")
note(4.05, paste0("Foreground, then MINIMUM LINKAGE\nDRAG, background only as a tie-break.\nExpected IBD with E, before\nconditioning on the targets, is ~",
                  round(1 - (1 - MB$s) * 0.5^(MB$n_bc + 1), 2),
                  "\nwith no background selection at all."))
note(2.75, "Fixation. Selfing needs a homozygote\nat all k targets: q = (1/4)^k.")
note(2.15, "DH: one gamete, q = (1/2)^k.", col = dh)
note(1.2, "Recessive endosperm phenotypes appear\none generation after the genotype, and\nonly on a selfed ear (xenia).")
par(op)

#' 
#' Two features of that diagram do all the work in the rest of the chapter. The
#' recurrent parent re-enters at every backcross, so donor content halves every
#' generation *whether or not anyone selects for it*; and the fork at the bottom is
#' where the plant numbers explode, because fixation asks for a homozygote and
#' backcrossing never does.
#' 
#' ## The model
#' 
#' **Two states, one haplotype.** The recurrent parent is a fully homozygous
#' inbred, so the gamete it contributes is invariant and only the donor-derived
#' haplotype has to be tracked: a binary vector over
#' `r build_map(maize_chr_len, spacing_cM = 5)$m` markers. Meiosis is a
#' per-interval Bernoulli switch with the map function of @haldane1919,
#' 
#' $$
#' r = \tfrac{1}{2}\bigl(1 - e^{-2d/100}\bigr),
#' $$ {#eq-bc-haldane}
#' 
#' where $d$ is the interval length in cM and $r$ its recombination fraction,
#' which is exact for this chain precisely because Haldane is memoryless (see the
#' limitation in @sec-bc-assumptions).
#' 
#' **Donor dosage and identity by descent (IBD) are different quantities.** Donor and elite already share
#' a fraction $s$ of the genome by descent -- they are both maize, and often both
#' from the same heterotic group. Donor genome inside a shared tract costs nothing.
#' So with $D$ the donor dosage,
#' 
#' $$
#' \text{IBD}_E = 1 - (1 - s)\,D, \qquad \text{IBD}_E + \text{donor-specific} = 1 .
#' $$ {#eq-bc-ibd}
#' 
#' The second identity of @eq-bc-ibd holds exactly in the simulator for every plant. The first
#' holds in expectation only: the shared fraction is a realised draw of windows,
#' not a per-plant rate, and the target windows are forced to be non-shared, so a
#' plant's realised IBD scatters around $1 - (1-s)D$. The test battery asserts the
#' second with exact equality and the first with tolerance 0.02
#' (`tests/testthat/test-mabc.R`). Everything below uses $s = `r MB$s`$.
#' 
#' **Coupling phase.** All $k$ targets come from one donor, on the same haplotype.
#' Two consequences, and the second is easy to get wrong. Linked targets travel
#' *together*, so linkage drag is the **union** of the donor segments, not their
#' sum. And conditional on both flanking targets being donor-derived, an *even*
#' number of crossovers is forced in the interval between them, so the probability
#' that they sit in one continuous donor segment is not $e^{-L}$ but
#' 
#' $$
#' P_{\text{same}} = \frac{e^{-L}}{\bigl(1 + e^{-2L}\bigr)/2},
#' \qquad L = d/100 \text{ Morgans}.
#' $$ {#eq-bc-psame}
#' 
## -----------------------------------------------------------------------------
L <- c(20, 60, 400) / 100
stopifnot(isTRUE(all.equal(p_same_segment(100 * L),
                           exp(-L) / ((1 + exp(-2 * L)) / 2))))
data.frame(d_cM = 100 * L, naive = exp(-L), conditional = p_same_segment(100 * L))

#' 
#' At 20 cM @eq-bc-psame gives `r fmt(p_same_segment(20), 2)` against a naive
#' `r fmt(exp(-20 / 100), 2)`.
#' 
#' ::: {.callout-important}
#' ## If the alleles come from different donors, none of this applies
#' 
#' Coupling phase is an assumption, not a convenience. Two linked targets in
#' repulsion, from two donors, cannot both be recovered without a recombinant in
#' the interval, and the cost explodes. That programme needs an intercross between
#' the donors before any backcrossing starts, and this model does not describe it.
#' :::
#' 
#' ## Three criteria, and only one of them binds
#' 
#' A conversion programme is usually written with three success conditions at BC3:
#' do not lose the genes, recover the recurrent parent, and do not drag a chunk of
#' donor chromosome along with each target. They are not remotely equal in cost.
#' 
#' **Not losing the genes** is exact and cheap. A backcross plant receives the
#' donor allele at each target from its heterozygous parent with probability 1/2
#' (Mendelian segregation), independently across targets because the $k$ targets
#' sit on different chromosomes, so it is foreground-positive with probability
#' $q = (1/2)^k$ and $n$ plants fail with probability $(1-q)^n$ (@tbl-bc-foreground):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-bc-foreground
n_fg <- vapply(mb_sz$q_foreground, n_for_count, integer(1))
# smallest n with P(no foreground-positive plant) = (1 - q)^n <= 1 - 0.95
stopifnot(isTRUE(all.equal(mb_sz$q_foreground, 0.5^mb_sz$genes)),
          (1 - mb_sz$q_foreground)^n_fg <= 0.05,
          (1 - mb_sz$q_foreground)^(n_fg - 1) > 0.05)
knitr::kable(data.frame(genes = mb_sz$genes, q = mb_sz$q_foreground, n_BC_per_gen = n_fg),
  row.names = FALSE,
  caption = sprintf("Foreground sizing: per-plant probability q = (1/2)^k that a backcross plant carries the donor allele at all k unlinked targets, and the smallest number of plants per backcross generation (n_BC_per_gen) giving at least one such plant with probability %.2f. Exact, from n_for_count(); no simulation and no selection index involved.", MB$P))

#' 
#' At most `r max(vapply(mb_sz$q_foreground, n_for_count, integer(1)))` plants per
#' generation at four genes, and that is the whole foreground problem.
#' 
#' **Recovering the elite is free by BC3.** The F1 carries donor dosage 1/2, and
#' each backcross to the recurrent parent halves the expected donor content of an
#' unselected plant, so with no background selection at all the expected donor
#' dosage after `r MB$n_bc` backcrosses is $(1/2)^{`r MB$n_bc + 1`}
#' = `r fmt(0.5^(MB$n_bc + 1), 4)`$, and
#' 
#' $$
#' \text{IBD}_E = 1 - (1 - s)\,(1/2)^{`r MB$n_bc + 1`} = `r fmt(expected_ibd(MB$n_bc, MB$s), 3)`
#' $$
#' 
#' at $s = `r MB$s`$. This is the expectation for a plant on which no selection has
#' acted. Foreground selection conditions on the $k$ targets being donor-derived,
#' so the donor segments attached to them are retained and the realised dosage is
#' higher: under the drag-priority index (`rec_drag`, defined in @sec-bc-index) the simulated
#' IBD at BC`r MB$n_bc` with four genes ranges from
#' `r fmt(min(u4$ibd), 3)` to `r fmt(max(u4$ibd), 3)`
#' across the population sizes of the scan (@tbl-bc-ibd). It is still above a 90%
#' target before a single background marker is scored.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-bc-ibd
#| echo: false
d <- mb_uni[mb_uni$strategy == mabc_opt$main_strategy & mb_uni$s == MB$s &
              mb_uni$gen == MB$n_bc, c("genes", "N", "n_rep", "ibd", "p_ibd", "p_lost")]
miss <- d$p_ibd < MB$P
# replicates that kept the genes and still missed the IBD target, worst cell
bg_miss <- max(1 - d$p_lost[miss] - d$p_ibd[miss])
knitr::kable(
  reshape(d[d$N %in% c(20, 80, 200, 400), c("genes", "N", "ibd")],
          idvar = "genes", timevar = "N", direction = "wide"),
  row.names = FALSE, digits = 3,
  col.names = c("genes", paste("N =", c(20, 80, 200, 400))),
  caption = sprintf(
    "Mean IBD with the elite at BC%d under the drag-priority index (%s), s = %.2f, uniform schedule of N plants per generation, %d-%d replicates per cell (mabc_uniform.csv); means only, no dispersion shown. P(IBD >= %.2f) reached %.2f in %d of %d cells of the whole grid (all four gene numbers, all %d sizes); in the cells where it did not, the failure was losing the genes: the proportion of replicates that kept the genes and missed the IBD target is at most %.3f.",
    MB$n_bc, mabc_opt$main_strategy, MB$s, min(d$n_rep), max(d$n_rep),
    MB$ibd_target, MB$P, sum(!miss), nrow(d), length(unique(d$N)), bg_miss))

#' 
#' That leaves **linkage drag** -- the donor chromosome still attached to each
#' target -- as the only criterion that a large population can buy. It is the
#' criterion the rest of the chapter is about.
#' 
#' ::: {.callout-note}
#' ## The reframing
#' 
#' An index that spends its decisive stage on background recovery is spending it on
#' the criterion that was already satisfied. This is not a hypothetical: it was the
#' defect the technical review found in the first version of this simulator, and
#' correcting it reverses the headline conclusion. @sec-bc-index is that
#' correction.
#' :::
#' 
#' ## Which selection index {#sec-bc-index}
#' 
#' Four policies (@tbl-bc-policies), all applied to foreground-positive plants only:
#' 
#' | Key | Rule |
#' |---|---|
#' | `bg` | minimise background donor content |
#' | `rec12` | recombinant selection in BC1-BC2 only, then background |
#' | `rec_bg` | recombinant selection throughout, **background** decides among survivors |
#' | `rec_drag` | recombinant selection throughout, **linkage drag** decides, background breaks ties |
#' 
#' : The four selection policies, by the key used in `mabc_uniform.csv` and in `run_bc_program(strategy =)`. All are applied to foreground-positive plants only. {#tbl-bc-policies}
#' 
#' `rec_bg` is the natural-looking two-stage rule: truncate on drag, then pick the
#' cleanest background among the survivors. Stage 2 discards stage 1. The plant
#' with the least drag survives the truncation and then loses to a sibling that
#' happens to carry less donor genome somewhere irrelevant.
#' 
#' @fig-bc-index and @tbl-bc-index compare the two on common random numbers:
#' `mabc_index_comparison.csv`, in which the label `script` is `rec_bg` and `drag`
#' is `rec_drag` (the `strategy` column), uniform schedules of $N$ plants in each
#' of the three backcrosses.
#' 
## -----------------------------------------------------------------------------
#| label: fig-bc-index
#| echo: false
#| fig-width: 9
#| fig-height: 4.4
#| fig-cap: !expr cap_idx
#| fig-alt: "Paired comparison of the background-priority index against the drag-priority index, probability of meeting the criterion against plants per generation, for three and four genes"
op <- par(mfrow = c(1, 2), mar = c(4.3, 4.4, 2.6, 0.8))
cols <- c(script = "#c0392b", drag = "#2e7d32")
for (k in c(3, 4)) {
  d <- mb_idx[mb_idx$k == k, ]
  plot(NA, xlim = range(d$N), ylim = c(0, 1), xlab = "Plants per generation",
       ylab = "P( drag ceiling AND IBD target )",
       main = sprintf("%d genes", k))
  grid(col = "grey92", lty = 1); abline(h = 0.95, lty = 3, col = "grey30", lwd = 2)
  for (ix in names(cols)) {
    dd <- d[d$index == ix, ]
    arrows(dd$N, dd$lo, dd$N, dd$hi, length = 0.03, angle = 90, code = 3,
           col = cols[ix], lwd = 1.6)
    lines(dd$N, dd$p_both, col = cols[ix], lwd = 2.4, type = "b", pch = 19)
  }
  if (k == 3) legend("bottomright", c("background-priority", "drag-priority"),
                     col = cols, lwd = 2.4, pch = 19, bty = "n", cex = 0.85)
}
par(op)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-bc-index
#| echo: false
wi <- reshape(mb_idx[, c("k", "N", "index", "drag", "ibd", "p_ibd", "p_both", "lo")],
             idvar = c("k", "N"), timevar = "index", direction = "wide")
lg <- mb_idx[order(mb_idx$k, mb_idx$N, mb_idx$strategy),
             c("k", "N", "strategy", "drag", "ibd", "p_ibd", "p_both", "lo")]
knitr::kable(lg, row.names = FALSE, digits = 3,
  col.names = c("genes", "N (plants/gen)", "index", "drag cM", "IBD", "P(IBD)",
                "P(both)", "lo"),
  caption = sprintf("Background-priority (rec_bg) against drag-priority (rec_drag) index, one row per index and cell. %d replicates per cell, s = %.2f, same seeds and same shared-IBD backbone for both indices. drag: mean linkage drag at BC%d; IBD: mean IBD with the elite; P(IBD): proportion of replicates with IBD >= %.2f; P(both): proportion meeting drag and IBD criteria; lo: its Clopper-Pearson 95%% lower bound.",
    unique(mb_idx$n_rep), unique(mb_idx$s), MB$n_bc, MB$ibd_target))

#' 
## -----------------------------------------------------------------------------
#| include: false
dg <- mb_idx[mb_idx$index == "drag", ]
dg4 <- dg[dg$k == 4, ]
N_cert <- min(dg4$N[dg4$lo >= MB$P])
N_prev <- max(dg4$N[dg4$N < N_cert])

#' 
#' Averaged over the `r nrow(wi)` cells, the drag-priority index gives up
#' `r fmt(100 * mean(wi$ibd.script - wi$ibd.drag), 1)` percentage points of IBD and
#' removes `r fmt(mean(wi$drag.script - wi$drag.drag), 1)` cM of drag. Under it the
#' proportion of replicates meeting the IBD target is at least
#' `r fmt(min(dg$p_ibd), 3)`; the lowest value, at four genes and
#' `r dg$N[which.min(dg$p_ibd)]` plants, equals one minus the proportion of
#' replicates that lost a gene (`r fmt(dg$p_lost[which.min(dg$p_ibd)], 3)`), so
#' that shortfall is foreground failure, not background. The IBD cost of the index
#' therefore does not bind at these cells.
#' 
#' Four genes are certified -- Clopper-Pearson lower bound at or above `r MB$P` --
#' at `r N_cert` plants per generation, where P(both) is
#' `r fmt(dg4$p_both[dg4$N == N_cert], 3)` with lower bound
#' `r fmt(dg4$lo[dg4$N == N_cert], 3)`. At `r N_prev` plants, the next size tested,
#' the lower bound is `r fmt(dg4$lo[dg4$N == N_prev], 3)` and the cell is not
#' certified; the grid does not locate the smallest certifying $N$ between the two.
#' The uniform scan of @tbl-bc-ibd estimates the same cell at `r N_cert` plants
#' independently, on `r u4$n_rep[u4$N == N_cert]` replicates instead of
#' `r unique(mb_idx$n_rep)`: `r fmt(u4$p_both[u4$N == N_cert], 3)`, interval
#' [`r fmt(u4$p_both_lo[u4$N == N_cert], 3)`, `r fmt(u4$p_both_hi[u4$N == N_cert], 3)`],
#' which overlaps the paired estimate and does not certify on its own lower bound;
#' the paired table is the more precise of the two. Under the background-priority
#' index the same cell reaches
#' `r fmt(mb_idx$p_both[mb_idx$k == 4 & mb_idx$index == "script" & mb_idx$N == N_cert], 3)`,
#' which is what produced the original -- and wrong -- conclusion that the ceiling
#' is unreachable at four genes and the programme must be extended to BC4-BC5 or
#' split in two. **The wall was a property of the index, not of maize.**
#' 
#' ## How long to keep selecting recombinants
#' 
#' @fig-bc-policies shows the four policies of @tbl-bc-policies over the uniform scan.
#' Its right panel is the drag ceiling alone, not the joint drag-and-IBD criterion of
#' @fig-bc-index and @tbl-bc-ibd, so its proportions are not comparable with
#' those.
#' 
## -----------------------------------------------------------------------------
#| label: fig-bc-policies
#| echo: false
#| fig-cap: !expr cap_pol
#| fig-alt: "Two panels against plants per generation: mean linkage drag at BC3 falls with population size and is lowest under rec_drag; the proportion of replicates within the drag ceiling rises with population size and is highest under rec_drag, for one and three genes"
knitr::include_graphics(book_fig("mabc_policies.png"))

#' 
## -----------------------------------------------------------------------------
#| include: false
pol <- mb_uni[mb_uni$s == MB$s & mb_uni$gen == MB$n_bc & mb_uni$genes == 3 &
                mb_uni$N == 200, ]
pd <- setNames(pol$drag, pol$strategy)
stopifnot(pd[["rec_bg"]] - pd[["rec_drag"]] > pd[["rec12"]] - pd[["rec_bg"]])

#' 
#' `rec12` stops recombinant selection after BC2 and spends the BC3 choice on
#' background, which by BC3 needs no clean-up (@tbl-bc-ibd). In the uniform scan,
#' three genes, `r unique(pol$N)` plants per generation, $s = `r MB$s`$
#' (`r unique(pol$n_rep)` replicates), mean drag at BC`r MB$n_bc` is
#' `r fmt(pd[["rec12"]], 1)` cM under `rec12`, `r fmt(pd[["rec_bg"]], 1)` cM when
#' recombinant selection continues into BC3 (`rec_bg`), and
#' `r fmt(pd[["rec_drag"]], 1)` cM when drag also decides among the survivors
#' (`rec_drag`). In that cell the point estimate of the second step
#' (`rec_bg` to `rec_drag`) is larger than that of the first (`rec12` to `rec_bg`).
#' These are three unpaired estimates, one per policy, from a scan seeded once
#' for the whole grid, and `mabc_uniform.csv` records no standard deviation of
#' drag, so no dispersion can be attached to either step; whether the first step
#' differs from zero is not resolved by these data. Both changes are
#' free in plants: they use the flanking markers on plants that are being
#' genotyped anyway.
#' 
#' ## Allocating a fixed budget across BC1, BC2 and BC3
#' 
#' Given a total number of plants to grow, how should they be split between the
#' three backcrosses? @fig-bc-alloc is the coarse scan of `mabc_allocation.csv`. It
#' was run under the background-priority index `rec_bg`, before the index
#' correction of @sec-bc-index (the driver passes `"rec_bg"` to this experiment); its
#' equal-size schedules are closer in mean drag to the `rec_bg` cells of the
#' uniform scan than to the `rec_drag` ones (asserted in the figure's chunk). It is shown as a description of how the success probability
#' varies with the schedule under that index; the comparison of schedules under the
#' drag-priority index is the paired re-run of @tbl-bc-recheck.
#' 
## -----------------------------------------------------------------------------
#| label: fig-bc-alloc
#| echo: false
#| fig-width: 9
#| fig-height: 4.4
#| fig-cap: !expr cap_alloc
#| fig-alt: "P(criterion met) against the share of a fixed budget spent on BC1 and BC2, for 1 and 3 genes, binned by total plants, under the background-priority index"
# every proportion is a multiple of 1/n_rep
stopifnot(all(abs(MB_alloc$n_rep * mb_alloc$p_both -
                  round(MB_alloc$n_rep * mb_alloc$p_both)) < 1e-9))
# equal-size schedules sit nearer the rec_bg than the rec_drag uniform cells
eq <- mb_alloc[mb_alloc$bc1 == mb_alloc$bc2 & mb_alloc$bc2 == mb_alloc$bc3 &
                 mb_alloc$bc1 %in% mb_uni$N, ]
gap <- function(st) sum(abs(eq$drag - vapply(seq_len(nrow(eq)), function(i)
  mb_uni$drag[mb_uni$strategy == st & mb_uni$s == MB_alloc$s &
                mb_uni$gen == MB$n_bc & mb_uni$genes == eq$genes[i] &
                mb_uni$N == eq$bc1[i]], numeric(1))))
stopifnot(gap("rec_bg") < gap("rec_drag"))
op <- par(mfrow = c(1, 2), mar = c(4.3, 4.4, 2.6, 0.8))
brk <- c(0, 150, 300, 500, Inf); lab <- c("< 150", "150-300", "300-500", "> 500")
cols <- c("#c0392b", "#e67e22", "#27ae60", "#1f5f8b")
for (k in sort(unique(mb_alloc$genes))) {
  d <- mb_alloc[mb_alloc$genes == k, ]
  d$frac <- (d$bc1 + d$bc2) / d$total
  d$bin <- cut(d$total, brk, labels = lab)
  plot(NA, xlim = c(0.3, 1), ylim = c(0, 1),
       xlab = "Share of budget spent on BC1 + BC2",
       ylab = "P( IBD target AND drag ceiling )", main = sprintf("%d gene(s)", k))
  grid(col = "grey92", lty = 1); abline(h = 0.95, lty = 3, col = "grey30", lwd = 2)
  for (i in seq_along(lab)) {
    dd <- d[d$bin == lab[i], ]
    if (!nrow(dd)) next
    points(dd$frac, dd$p_both, col = adjustcolor(cols[i], 0.35), pch = 16, cex = 0.8)
    ag <- aggregate(p_both ~ round(frac, 1), dd, mean)
    lines(ag[[1]], ag[[2]], col = cols[i], lwd = 2.4, type = "b", pch = 19)
  }
  if (k == 1) legend("bottomleft", paste("total", lab), col = cols, lwd = 2,
                     lty = 1, bty = "n", cex = 0.8)
}
par(op)

#' 
#' @tbl-bc-recheck re-runs five schedules at a fixed budget of
#' `r unique(mb_re$total)` plants, `r unique(mb_re$k)` genes, under both indices on
#' common random numbers (`mabc_allocation_recheck.csv`). The two indices are
#' paired within a schedule; the schedules are not paired with each other, so a
#' comparison between schedules is between independent binomial proportions.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-bc-recheck
#| echo: false
knitr::kable(reshape(mb_re[, c("sched", "index", "drag", "p_lost", "p_both", "lo", "hi")],
                     idvar = "sched", timevar = "index", direction = "wide"),
  row.names = FALSE, digits = 3,
  col.names = c("BC1/BC2/BC3 (plants)", "drag cM", "P(lost)", "P(both)", "lo", "hi",
                "drag cM", "P(lost)", "P(both)", "lo", "hi"),
  caption = sprintf("%d plants, %d genes, s = %.2f, %d replicates per schedule. Left block: background-priority index (rec_bg). Right block: drag-priority index (rec_drag). drag: mean linkage drag at BC%d; P(lost): proportion of replicates in which a target was lost; P(both): proportion meeting drag and IBD criteria, with Clopper-Pearson 95%% interval [lo, hi].",
    unique(mb_re$total), unique(mb_re$k), unique(mb_re$s), unique(mb_re$n_rep), MB$n_bc))

#' 
## -----------------------------------------------------------------------------
#| include: false
rd <- mb_re[mb_re$index == "drag", ]
rd <- rd[order(-rd$p_both), ]
q3 <- 0.5^unique(mb_re$k)               # foreground probability per plant
small <- rd[pmin(rd$bc1, rd$bc2, rd$bc3) == 20, ]
# unpaired z between two schedules; separated means |z| >= 2
n_re <- unique(mb_re$n_rep)
zf <- function(p1, p2) (p1 - p2) / sqrt((p1 * (1 - p1) + p2 * (1 - p2)) / n_re)
z_top <- zf(rd$p_both[1], rd$p_both[2])
# per index, ascending P(both): the two 20-plant schedules are the two lowest
# point estimates; z of the third lowest against the second lowest
asc <- lapply(split(mb_re, mb_re$index), function(r) r[order(r$p_both), ])
for (r in asc) stopifnot(setequal(r$sched[1:2], small$sched))
z_low <- vapply(asc, function(r) zf(r$p_both[3], r$p_both[2]), numeric(1))
stopifnot(abs(z_top) < 2, z_low[["drag"]] >= 2, z_low[["script"]] < 2)
# P(both | targets kept); a replicate that lost a target fails the criterion
rd$p_kept <- rd$p_both / (1 - rd$p_lost)
ck <- setNames(rd$p_kept, rd$sched)
best <- rd$p_both[1]
pb <- setNames(rd$p_both, rd$sched); pl <- setNames(rd$p_lost, rd$sched)
# back-loaded: gene loss is most of the deficit; front-loaded: it is not
stopifnot(pl[["20/150/190"]] > (best - pb[["20/150/190"]]) / 2,
          best - ck[["300/40/20"]] > (best - pb[["300/40/20"]]) / 2)

#' 
#' Two schedules are called separated here when $|z| \ge 2$, with
#' $z = (\hat p_1 - \hat p_2) / \sqrt{[\hat p_1(1 - \hat p_1) + \hat p_2(1 - \hat p_2)]/n}$,
#' where $\hat p_1, \hat p_2 \in [0, 1]$ are the two P(both) estimates and
#' $n = `r n_re`$ the replicates per schedule (independent binomial proportions,
#' normal approximation). Under the drag-priority index the balanced schedule
#' `r rd$sched[1]` has the highest point estimate, `r fmt(rd$p_both[1], 3)`
#' [`r fmt(rd$lo[1], 3)`, `r fmt(rd$hi[1], 3)`], against
#' `r rd$sched[2]`, `r fmt(rd$p_both[2], 3)`
#' [`r fmt(rd$lo[2], 3)`, `r fmt(rd$hi[2], 3)`], $z = `r fmt(z_top, 2)`$: the two
#' are not separated. The schedules with a 20-plant generation,
#' `r paste(small$sched, collapse = " and ")`, have the two lowest point estimates
#' under both indices. Under the drag-priority index the higher of the two,
#' `r asc[["drag"]]$sched[2]`, is separated from the next schedule,
#' `r asc[["drag"]]$sched[3]` ($z = `r fmt(z_low[["drag"]], 2)`$); under the
#' background-priority index the higher of the two, `r asc[["script"]]$sched[2]`
#' (`r fmt(asc[["script"]]$p_both[2], 3)`), is not separated from
#' `r asc[["script"]]$sched[3]` (`r fmt(asc[["script"]]$p_both[3], 3)`,
#' $z = `r fmt(z_low[["script"]], 2)`$), so under that index the ranking rests on
#' point estimates only. In the two 20-plant schedules a target was lost in `r fmt(small$p_lost[1], 3)` and
#' `r fmt(small$p_lost[2], 3)` of replicates, against
#' $(1 - (1/2)^{`r unique(mb_re$k)`})^{20} = `r fmt((1 - q3)^20, 3)`$ for one
#' generation of 20 plants with no other cause of loss; the schedules whose
#' smallest generation has 40 plants lose a target in at most
#' `r fmt(max(rd$p_lost[pmin(rd$bc1, rd$bc2, rd$bc3) == 40]), 3)` of replicates
#' ($(1 - (1/2)^{`r unique(mb_re$k)`})^{40} = `r fmt((1 - q3)^40, 3)`$).
#' 
#' Conditioning on the targets being kept (a replicate that lost one counts as a
#' failure, so $P(\text{both} \mid \text{kept}) = P(\text{both}) / (1 - P(\text{lost}))$),
#' the drag-priority success rate is `r fmt(ck[[rd$sched[1]]], 3)` for
#' `r rd$sched[1]`, `r fmt(ck[["20/150/190"]], 3)` for 20/150/190 and
#' `r fmt(ck[["300/40/20"]], 3)` for 300/40/20.
#' 
#' The inference is that the two extreme schedules fail for different reasons.
#' The back-loaded 20/150/190 loses most of its deficit to foreground failure in
#' its 20-plant BC1; the front-loaded 300/40/20 also loses targets, but most of its
#' deficit remains after conditioning on keeping them, which is consistent with
#' having only 20 BC3 plants among which to select on drag at the last meiosis.
#' Neither pattern requires a difference in how efficiently a BC1 or a BC3 plant
#' reduces drag. The comparison is limited to five schedules at one budget, one gene
#' number and one value of $s$, and it does not order the three schedules without
#' a 20-plant generation beyond the intervals shown. The
#' direction agrees with the analytical result of @hospital2001, that it is
#' generally more profitable to allow three or more backcross generations than to
#' favour recombination in early generations.
#' 
#' ## Fixing the stack: selfing against doubled haploids
#' 
#' Backcrossing only ever asks for a heterozygote. Fixation asks for a homozygote
#' at all $k$ targets, and that is where the plant numbers move: the BC3F2 plants
#' needed for `r MB$n_keep` homozygotes are
#' `r fmt((mb_sz$n_F2_3plants / mb_sz$n_BC_1plant)[mb_sz$genes == 1], 1)` times the backcross
#' plants needed for one foreground-positive plant at one gene and
#' `r fmt((mb_sz$n_F2_3plants / mb_sz$n_BC_1plant)[mb_sz$genes == 4], 1)` times at four
#' (@fig-bc-sizing). Selfing a BC3F1 heterozygous at $k$ unlinked targets gives the
#' recessive homozygote at each with probability 1/4, so $q = (1/4)^k$; a doubled
#' haploid (DH) derived from a BC3F1 gamete is homozygous everywhere, and the gamete
#' carries the donor allele at each target with probability 1/2, so $q = (1/2)^k$.
#' 
#' And the requirement is not one plant but `r MB$n_keep`, which is a *cumulative
#' binomial* $P(\text{Bin}(n, q) \ge `r MB$n_keep`) \ge `r MB$P`$, not
#' $1 - (1-q)^n$ (@tbl-bc-fixation; @fig-bc-f2 sets the binomial against simulation):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-bc-fixation
#| echo: false
knitr::kable(mb_sz[, c("genes", "q_F2", "n_F2_3plants", "q_DH", "n_DH_3lines")],
  row.names = FALSE, digits = c(0, 5, 0, 4, 0),
  col.names = c("genes", "q (selfing)", "BC3F2 plants", "q (DH)", "DH lines"),
  caption = sprintf("Fixation: per-plant probability q of being homozygous for the donor allele at all k targets, and the number of BC3F2 plants (selfing) or DH lines needed for at least %d such individuals with probability P = %.2f. Exact cumulative binomial (mabc_analytical_sizing.csv); no simulation, no replicates, and no dependence on the selection index.",
                    MB$n_keep, MB$P))

#' 
## -----------------------------------------------------------------------------
#| label: fig-bc-f2
#| echo: false
#| fig-width: 8
#| fig-height: 4.6
#| fig-cap: !expr cap_f2
#| fig-alt: "Probability of obtaining at least three BC3F2 plants homozygous at all targets against the number genotyped on a log axis: simulated points follow the dashed binomial curves for one to four genes, each curve shifted right by roughly a factor of four per extra gene"
op <- par(mar = c(4.4, 4.6, 1.2, 0.8))
kcol <- c("#1f5f8b", "#27ae60", "#e67e22", "#c0392b")
plot(NA, xlim = range(mb_f2$n_f2), ylim = c(0, 1), log = "x",
     xlab = "Genotyped BC3F2 plants",
     ylab = sprintf("P( >= %d homozygotes at all targets )", MB$n_keep))
grid(col = "grey92", lty = 1); abline(h = MB$P, lty = 3, col = "grey30", lwd = 2)
nn <- unique(round(exp(seq(log(3), log(max(mb_f2$n_f2)), length.out = 400))))
for (k in sort(unique(mb_f2$genes))) {
  lines(nn, 1 - pbinom(MB$n_keep - 1, nn, 0.25^k), col = kcol[k], lty = 2, lwd = 1.6)
  d <- mb_f2[mb_f2$genes == k, ]
  points(d$n_f2, d$p_ok, col = kcol[k], pch = 19)
}
legend("topleft", sprintf("%d gene(s): n = %d", mb_sz$genes, mb_sz$n_F2_3plants),
       col = kcol[mb_sz$genes], lwd = 2, pch = 19, bty = "n", cex = 0.85)
par(op)

#' 
## -----------------------------------------------------------------------------
#| label: fig-bc-sizing
#| echo: false
#| fig-cap: !expr cap_siz
#| fig-alt: "Grouped bar chart on a log scale of plants or lines required for one to four target genes, four bars per group: backcross foreground, backcross foreground plus recombinant, BC3F2 selfing and doubled haploids; selfing reaches 1610 plants at four genes against 99 doubled-haploid lines"
knitr::include_graphics(book_fig("mabc_sizing.png"))

#' 
#' At four genes that is
#' `r mb_sz$n_F2_3plants[4]` BC3F2 plants against `r mb_sz$n_DH_3lines[4]` DH lines,
#' a factor of
#' `r fmt(mb_sz$n_F2_3plants[4] / mb_sz$n_DH_3lines[4], 1)`. Where DH production
#' is available, the BC3F2 number is not the bottleneck.
#' 
#' **Without DH there is a staggered alternative.** Do not ask one generation to
#' fix everything. Select BC3F2 plants homozygous at a pre-specified pair of the
#' four targets and heterozygous at the other two, $q = (1/4)^2 (1/2)^2 = 1/64$:
#' `r n_for_count(1/64, MB$n_keep, MB$P)` plants for `r MB$n_keep` such plants at
#' $P = `r MB$P`$. Then self them and close out the remaining two at BC3F3,
#' $q = (1/4)^2$: `r n_for_count(1/16, MB$n_keep, MB$P)` plants. Two stages of
#' hundreds instead of one of `r mb_sz$n_F2_3plants[4]`, at the cost of one
#' generation.
#' 
#' ## Running the simulation {#sec-bc-running}
#' 
#' The engine and the decision layer are in `R/08_mabc.R`; the experiment driver
#' is `inst/scripts/run_mabc.R`. The provenance of each cached table is stated at
#' the end of this section.
#' 
#' **One programme, interactively.** Build a map, place the targets, draw the
#' donor-elite sharing, and run the three backcrosses:
#' 
## -----------------------------------------------------------------------------
map <- build_map(maize_chr_len, spacing_cM = 5)
w   <- marker_weights(map)
tg  <- target_indices(map, k = 3)              # the first three of maize_targets
set.seed(5)                                    # the donor-elite sharing draw
sh  <- make_shared_ibd(map, s = 0.60, mw = w, target_idx = tg)
set.seed(6)                                    # the three backcross meioses

pr <- run_bc_program(n_sched = c(120, 120, 120), s = 0.60,
                     strategy = "rec_drag", map = map, opt = mabc_opt,
                     tg = tg, w = w, shared = sh)
fmt(pr$traj, 3)

#' 
## -----------------------------------------------------------------------------
# The two identities of IBD_E on the same mask, over 200 unselected BC1 plants:
# the sum is exact per plant; the proportionality holds in expectation only.
# Tolerances are checked at this seed only; the relative error varies with
# the seed of both H1 and the mask.
set.seed(8)
H1 <- backcross(matrix(1, map$m, 1), 200, map)
stopifnot(
  isTRUE(all.equal(ibd_elite(H1, w, sh) + donor_specific(H1, w, sh), rep(1, 200))),
  isTRUE(all.equal(mean(donor_specific(H1, w, sh)),
                   (1 - 0.60) * mean(donor_dosage(H1, w)), tolerance = 0.06)),
  isTRUE(all.equal(mean(donor_dosage(H1, w)), expected_donor(1), tolerance = 0.06)))

#' 
#' `n_sched` is the schedule, one entry per backcross, so `c(300, 40, 20)` and
#' `c(120, 120, 120)` are two of the allocations compared in @tbl-bc-recheck. Passing the same
#' `shared` mask to two calls is what makes a comparison between selection indices
#' paired rather than confounded with the donor-elite pair.
#' 
#' **Comparing indices on common random numbers.** Reset the seed before each
#' strategy so the two programmes see the same meioses:
#' 
## -----------------------------------------------------------------------------
drag_of <- function(strategy) {
  set.seed(7)
  run_bc_program(c(120, 120, 120), 0.60, strategy, map, mabc_opt, tg, w,
                 shared = sh)$traj$drag[mabc_opt$n_bc]
}
c(rec_bg = drag_of("rec_bg"), rec_drag = drag_of("rec_drag"))

#' 
#' A single replicate is noise; the cells of @tbl-bc-ibd are
#' `r min(mb_uni$n_rep)`-`r max(mb_uni$n_rep)` of these (uniform scan, by $N$) and those of
#' @tbl-bc-index and @tbl-bc-recheck `r unique(mb_idx$n_rep)` (the two paired tables), which is the driver's job.
#' 
#' **The analytical sizing needs no simulation at all.** It is a cumulative
#' binomial, so it is exact and instant:
#' 
## -----------------------------------------------------------------------------
st <- sizing_table(k_max = 4, flank_cM = 5, P = 0.95, n_keep = 3)
stopifnot(isTRUE(all.equal(st, mb_sz)))   # the cached table, reproduced exactly
st

#' 
#' **The full scans, from the shell.** The driver's full run covers the uniform
#' scan -- `rec_bg` at $s$ = `r paste(sort(unique(mb_uni$s[mb_uni$strategy == "rec_bg"])), collapse = ", ")`
#' and the other three policies at $s = `r MB$s`$, by
#' `r length(unique(mb_uni$genes))` gene numbers by `r length(unique(mb_uni$N))`
#' population sizes, `r min(mb_uni$n_rep)`-`r max(mb_uni$n_rep)` replicates per cell
#' depending on $N$ -- plus the allocation grid and the BCnF2 stage, and writes the
#' CSVs, the figures and a self-contained HTML report. Two further targets write
#' the paired index tables:
#' 
#' ```sh
#' Rscript inst/scripts/run_mabc.R --test              # the driver's self-checks
#' Rscript inst/scripts/run_mabc.R --quick --out=DIR   # reduced grid
#' Rscript inst/scripts/run_mabc.R --out=report/mabc   # the full run
#' Rscript inst/scripts/run_mabc.R --out=book/data \
#'   --only=index_comparison,allocation_recheck        # the two paired tables
#' ```
#' 
#' Provenance of the six cached tables, all written by this driver or its direct
#' predecessor:
#' 
#' - `mabc_index_comparison.csv` and `mabc_allocation_recheck.csv` are written
#'   directly into `book/data` by the `--only=index_comparison,allocation_recheck`
#'   run of the current driver, `r unique(mb_idx$n_rep)` replicates per cell, with
#'   a seed per cell recorded in the `seed` column, so each cell can be re-run in
#'   isolation.
#' - `mabc_analytical_sizing.csv` is the full run's `analytical_sizing.csv`; it has
#'   no random component, and the chunk above reproduces it exactly.
#' - `mabc_uniform.csv`, `mabc_allocation.csv` and `mabc_bcnf2.csv` (and the two
#'   figures `mabc_policies.png` and `mabc_sizing.png`) are the full run's
#'   `results_uniform.csv`, `results_allocation.csv`, `results_bcnf2.csv` and
#'   figures, copied into `book/data` and `book/figs`, but the cached copies were
#'   produced by the predecessor of the current driver and have not been rewritten
#'   by it. The current driver writes files of the same shape; a bit-for-bit match
#'   is not expected because the full run sets its seed once before the whole scan,
#'   so no single cell can be regenerated in isolation, and no full re-run has been
#'   diffed against them. Replicates: `r min(mb_uni$n_rep)`-`r max(mb_uni$n_rep)`
#'   per cell in the uniform scan, `r MB_alloc$n_rep` per schedule in the
#'   allocation scan.
#' 
#' **Pointing it at your own programme.** Three things change and nothing else:
#' 
## -----------------------------------------------------------------------------
#| eval: false
# # 1. your map
# map <- build_map(my_chr_len_cM, spacing_cM = 5)
# 
# # 2. your targets -- same columns as maize_targets
# my_targets <- data.frame(gene = c("A", "B"), chr = c(1, 5),
#                          pos_cM = c(40, 110), label = c("A", "B"))
# tg <- target_indices(map, k = 2, targets = my_targets)
# 
# # 3. your criteria
# opt <- utils::modifyList(mabc_opt,
#                          list(n_bc = 4, drag_per_gene = 20, target_ibd = 0.95))

#' 
#' `s` -- how much of the genome your donor and your elite already share -- is the
#' parameter worth measuring rather than assuming. It scales the whole cost: at
#' $s = 0.7$ most of the donor genome that survives is free, at $s = 0$ none of it
#' is.
#' 
#' ## Assumptions, and what is not modelled {#sec-bc-assumptions}
#' 
#' These matter more than usual here, because unlike the diversity chapters this
#' one is used to decide field area.
#' 
#' **No crossover interference (material, and it cuts against the results above).**
#' Meiosis is Haldane (@eq-bc-haldane) [@haldane1919], so crossovers are independent between
#' intervals. Maize crossovers show positive interference: @falque2009 fit a
#' two-pathway model in which most crossovers follow a gamma renewal process with
#' shape $4.2 < \nu < 6.2$ on most chromosomes and a minority do not interfere.
#' For the event this simulation depends on most when both flanking crossovers
#' arise in the same meiosis -- a double recombinant in the two
#' `r MB$flank_cM` cM intervals flanking a target, which is what turns a long
#' donor segment into a short one -- Haldane gives
#' $r^2 = `r fmt(haldane_r(MB$flank_cM)^2 * 1e3, 2)` \times 10^{-3}$. Positive
#' interference makes a crossover in each of two adjacent short intervals rarer
#' than the product of their recombination fractions, so the model over-produces
#' tight recombinants, and every population size quoted for close-in trimming is
#' expected to be a lower bound. By how much was not computed here. Note the
#' direction: the index correction makes the problem easier, interference makes it
#' harder, and they do not cancel in any principled way. The fix is a
#' crossover-position sampler -- chiasmata as a stationary gamma renewal process
#' with shape $\nu$, plus a non-interfering fraction as in @falque2009 -- which
#' reduces to Haldane exactly at $\nu = 1$ and so is backward compatible.
#' 
#' **One plant advanced per generation.** A programme that advances several plants
#' per generation and crosses each to the recurrent parent is not modelled. Every
#' probability in this chapter is therefore a
#' **single-lineage** probability: it understates achievable progress and it
#' removes lineage-level variance from every distribution shown.
#' 
#' **Uniform recombination rate, no distortion, no genotyping error.** The local
#' meiotic recombination rate varies more than 1000-fold across the maize genome,
#' measured from breakpoints mapped at high resolution in nested association
#' mapping populations [@rodgersmelnick2015]; a target in a cold region carries
#' drag no feasible population will trim. Gametophyte factors shift the foreground
#' frequency away from $1/2$. Map positions here are illustrative and not pinned to
#' a named consensus map -- and maps of the intermated B73 x Mo17 (IBM) type [@lee2002] must be rescaled before
#' use, exactly as in @sec-sizing.
#' 
#' **Triploid endosperm genetics is not modelled.** The illustrative targets are
#' endosperm genes. The endosperm is 2 maternal : 1 paternal, so a recessive kernel
#' phenotype does not appear on the ear of a heterozygous plant: phenotypic
#' confirmation lags the genotype by one generation, and xenia means it requires a
#' self-pollination, not open pollination.
#' 
#' **The gene set is illustrative, not a breeding recommendation.** Whether all
#' four targets are worth stacking is a breeding decision outside this model;
#' dropping one turns the hard case ($k = 4$) into the comfortable one ($k = 3$).
#' `o2` alone gives opaque endosperm, not quality protein maize (QPM): QPM was
#' created by selecting multiple, unlinked `o2` modifier loci [@holding2008], which
#' are unmodelled here and change the problem class from "stack $k$ Mendelian
#' genes" to "stack $k$ genes plus a quantitative trait locus (QTL) background".
#' 
#' ::: {.callout-warning}
#' ## Two statistical habits this chapter had to be repaired for
#' 
#' **Select on the interval, not the point estimate.** The first version of the
#' sizing tables took the first grid point whose *point estimate* crossed 0.95.
#' With few replicates per cell that is a winner's curse: a success probability
#' that is monotone in $N$ reads as non-monotone through noise. The uniform scan
#' still shows it at four genes under `rec_drag`:
#' `r fmt(u4$p_both[u4$N == 320], 3)` at $N = 320$ and
#' `r fmt(u4$p_both[u4$N == 400], 3)` at $N = 400$, on
#' `r u4$n_rep[u4$N == 400]` replicates each. Selection is now on the
#' Clopper-Pearson lower bound. Clopper-Pearson intervals are drawn in
#' @fig-bc-index and @tbl-bc-recheck and the lower bound is tabulated in
#' @tbl-bc-index; @fig-bc-alloc gives a binomial standard error in its caption;
#' @tbl-bc-ibd, @fig-bc-policies and @fig-bc-f2 show point estimates only, as their
#' captions state.
#' 
#' **Never type a number into the prose.** Every figure in the original narrative
#' was a string constant written against an earlier configuration; re-runs put the
#' true values outside the reported confidence intervals, and the same document
#' contradicted itself in three places. Results in this chapter's prose and
#' captions are computed at render time from the cached tables or from package
#' functions; the only typed values are design inputs (the map spacing, the
#' schedules, $k$, $s$ and the criteria in `MB`) and the replicate counts of the
#' allocation scan and of the BC3F2 scan (`MB_alloc`, `MB_f2`), which their CSVs do
#' not record; both are checked against the CSVs for consistency, not derived from
#' them. @sec-bc-running states where
#' each table comes from.
#' :::
#' 
#' ## Where this connects
#' 
#' @sec-sizing sized a population to *keep* diversity; this chapter sized one to
#' discard it everywhere except at $k$ loci. The two share their machinery -- the
#' same map, the same Haldane meiosis, the same distinction between what is
#' segregating and what is fixed -- and they share the lesson that dominates both:
#' **size for the objective that binds.** In @sec-sizing that meant not sizing for
#' gene diversity, which saturates early. Here it means not sizing for background
#' recovery, which is already satisfied at BC3, and putting the plants into the one
#' criterion that a population can actually buy.
#' 
#' The converted lines this chapter produces re-enter the pool the rest of the book
#' optimises over. A conversion programme run for its own sake reduces diversity by
#' construction: it makes an elite line into a near-copy of itself. If several
#' conversions are run in parallel off the same recurrent parent, the resulting
#' lines are close to each other.
#' 
#' Up to here that is an assertion, made in item 5 of the Preface's chain of
#' argument and in the preceding paragraph, not a measurement. It is cheap to
#' measure, and the size of it is the argument. Eight BC3 conversions off one recurrent parent,
#' against eight unrelated elite lines, put through the kernel of @sec-coancestry (@tbl-bc-conversion-cost).
#' The lines are inbred, coded 0/1 at biallelic markers with allele frequency 1/2,
#' and drawn independently at each marker (no linkage). The donor is an unrelated
#' line, so it matches the recurrent parent by state at about half the markers;
#' donor-elite sharing is therefore already in the draw and is not added again
#' through $s$. A conversion carries the recurrent-parent allele by descent at a
#' marker with probability $1 - (1/2)^{`r MB$n_bc + 1`}$, the expected recurrent dosage at BC3
#' without selection, and the donor allele otherwise. Because $\theta$ is a mean of
#' per-marker identities, its expectation depends only on these per-marker
#' probabilities; linkage would change its dispersion, not its expectation.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-bc-conversion-cost
set.seed(11)
m_c  <- 2000
elite <- matrix(rbinom(40 * m_c, 1, 0.5), 40, m_c)   # unrelated elite lines
rec   <- elite[1, ]                                   # one recurrent parent
donor <- elite[40, ]
ibd   <- 1 - expected_donor(3)                        # recurrent genome by descent at BC3

conv <- t(sapply(1:8, function(i)
  ifelse(rbinom(m_c, 1, ibd) == 1, rec, donor)))

cost <- data.frame(
  panel = c("8 BC3 conversions, one recurrent parent", "8 unrelated elite lines"),
  theta = c(mean(molecular_coancestry(conv)),
            mean(molecular_coancestry(elite[1:8, ]))))
cost$GD <- 1 - cost$theta
# realised ratio against its expectation 2D(1 - D); the tolerance is checked
# at this seed only
D <- expected_donor(3)
stopifnot(isTRUE(all.equal(cost$GD[1] / cost$GD[2], 2 * D * (1 - D),
                           tolerance = 0.15)))
knitr::kable(cost, row.names = FALSE, digits = 4,
  caption = sprintf("Group coancestry theta (diagonal included) and gene diversity GD = 1 - theta of eight BC%d conversions off one recurrent parent and of eight unrelated elite lines: one draw (set.seed(11)) of %d unlinked markers, inbred lines coded 0/1, recurrent genome by descent with probability 1 - (1/2)^%d, no selection.", MB$n_bc, m_c, MB$n_bc + 1))

#' 
#' The converted panel carries
#' `r fmt(cost$GD[1] / cost$GD[2], 3)` times the gene diversity of the unrelated
#' one. In expectation, two conversions differ at a marker only when exactly one
#' carries the donor allele and the donor differs from the recurrent parent there,
#' probability $2D(1-D)\cdot\tfrac12$ with $D = (1/2)^{`r MB$n_bc + 1`}$, against $1/2$ for two
#' unrelated lines, so the off-diagonal ratio is $2D(1-D) =
#' `r fmt(2 * expected_donor(3) * (1 - expected_donor(3)), 3)`$. The diagonal of
#' $\theta$ is 1 in both panels and scales both gene diversities by the same
#' factor, so this is also the expected ratio of the two; the realised value above
#' is one draw of `r m_c` markers. Conversion is *designed* to make lines identical
#' everywhere except the target, and it succeeds.
#' 
#' Two consequences for the rest of the book. A conversion programme must be counted
#' against the diversity budget of @sec-ocs rather than run alongside it, because
#' $\theta$ cannot distinguish eight conversions from one line entered eight times.
#' And @sec-stages' per-line usage cap is the mechanism that already handles this:
#' capping how often a line is used caps how often its near-copies are, provided
#' the conversions are recognised as near-copies rather than entered as eight
#' independent parents.
#' 
#' ::: {.callout-warning}
#' ## Do not enter a converted panel as independent lines
#' 
#' The failure mode is administrative, not statistical. Conversions arrive with
#' distinct line codes and distinct pedigree entries, so a pipeline that trusts the
#' codes will treat them as eight parents. The coancestry matrix will not, and
#' @sec-choosing's recommendation to compute $\theta$ on markers rather than on
#' pedigree is what protects against exactly this.
#' :::
