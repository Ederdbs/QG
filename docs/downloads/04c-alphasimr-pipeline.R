#' # Simulating a hybrid breeding programme: AlphaSimR from the ground up {#sec-alphasimr}
#' 
# 04c-alphasimr-pipeline -- standalone script of the chapter 04c-alphasimr-pipeline.qmd
# Book: https://ederdbs.github.io/QG/04c-alphasimr-pipeline.html
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
library(AlphaSimR)
rrs_cfg <- utils::modifyList(rrs_config,
  list(n_pool_A = 12, n_pool_B = 12, n_dh = 3, n_sel = 6, n_testers = 2,
       n_cycles = 4, seg_sites = 150, n_chr = 5, n_traits = 2, seed = 1))
# Step 8 design constants, defined once so that the captions and the text read them
n_rep         <- 48   # paired founder draws
n_split_draws <- 20   # founder draws per split time
n_dh_gca      <- 10   # DH lines per founder for the GCA measurement
n_hyb_sel     <- 8    # hybrids kept by stage2_select()
# the statistics tested in tbl-alphasimr-paired: their number is the multiplicity
metrics <- c("mean_tc_A", "mean_tc_B", "hybrid_meanG", "gd_A", "gd_B",
             "gd_elite_mean", "gd_pool_A", "gd_pool_B", "gd_pool_mean",
             "GD_BS", "F_ST")
n_tests <- length(metrics)
founder_note  <- paste0("Founders from `runMacs2()`; whether they are reproducible ",
                        "from the seed was not established (Step 1).")
cfg_note <- paste0(rrs_cfg[["n_pool_A"]], " + ", rrs_cfg[["n_pool_B"]], " founders, ",
                   rrs_cfg[["n_chr"]], " chromosomes x ", rrs_cfg[["seg_sites"]],
                   " sites, every site a QTL")
cap_split <- paste0("Founder pools from `runMacs2()` at four split times (`split`, coalescent generations since the two demes stopped exchanging migrants), ",
  n_split_draws, " independent founder draws per split time; ", cfg_note, " (outbred founders); row `split_<s>` is split time s. ",
  founder_note, " (a) `F_ST`, `GD_T`, `GD_BS` of the partition of @caballero2002, and the divergence share of expected heterosis. (b) Between-draw s.d. of the columns of (a). (c) Fraction of sites monomorphic in pool A (`mono_A`) and pool B (`mono_B`) and fixed for opposite alleles (`fixed_diff`); the parts of `GD_T` (in (a)) carried by the fixed sites (`GD_T_fixed`) and by all others (`GD_T_other`); pooled minor-allele frequency (`maf_pooled`). (d) Variance of the exact GCA of ",
  n_dh_gca, " pool-A DH lines per founder against the pool-B DH lines, its additive part, its dominance part and twice their covariance (squared trait units); `GCA_dominance_share`: dominance part over total; `cor_perse_GCA`: correlation of a line's own genetic value with its GCA. (e) Between-draw s.d. of the columns of (d).")
cap_contrast <- paste0("Contrast of two statistics of @tbl-alphasimr-split-4 between the largest (`split` = 1000) and the smallest (`split` = 0) split time: mean over the ",
  n_split_draws, " draws at each, their difference, the unpaired standard error of the difference, and $t$ = difference / s.e. (draws independent between split times).")
cap_cycle1 <- paste0("Summary of one reciprocal recurrent selection cycle (`alphasimr_rrs_cycle()`, seed 11) on the founder pools of Step 8: ",
  cfg_note, ", ", rrs_cfg[["n_dh"]], " DH lines per founder, ", rrs_cfg[["n_testers"]], " testers, ", rrs_cfg[["n_sel"]],
  " elites kept per pool. `mean_tc_A`, `mean_tc_B`: mean testcross phenotype (trait 1, trait units) of all DH lines tested, pool-A lines on pool-B testers and the reverse; `gd_A`, `gd_B`: gene diversity (1 - mean molecular coancestry) of the elite lines kept. ", founder_note)
cap_rep1 <- paste0("The selected arm of the first of the ", n_rep, " founder draws, cycle 0 (founders) to cycle ", rrs_cfg[["n_cycles"]], ". ",
  founder_note, " (a) `mean_tc_A`, `mean_tc_B`, `gd_A`, `gd_B` as in @tbl-alphasimr-cycle1; `hybrid_meanG`: mean genetic value (trait 1, trait units) of the ",
  rrs_cfg[["n_sel"]], " x ", rrs_cfg[["n_sel"]], " elite factorial. (b) `gd_pool_A`, `gd_pool_B`: gene diversity of the recombined pools; `GD_BS`, `F_ST`: between-pool components of those pools.")
cap_paired <- paste0("Selected arm against the paired no-selection control at the last cycle (cycle ", rrs_cfg[["n_cycles"]], "), over ", n_rep,
  " founder draws, each branched into both arms. ", founder_note, " ", n_tests, " statistics are listed and each is tested; see the text for the multiplicity. (a) Per statistic (as in @tbl-alphasimr-rep1; `gd_elite_mean`, `gd_pool_mean`: mean of the pool-A and pool-B values): mean of each arm, mean and s.d. of the paired difference (selected minus control), and paired $t$ on ",
  n_rep - 1, " d.f. (b) Correlation across draws of the pool-A and pool-B paired differences, their s.d., the s.d. of their mean (`sd_pooled`), and that s.d. if the two were independent.")
cap_loss <- paste0("Relative loss of gene diversity of the recombined pools from cycle 0 to cycle ", rrs_cfg[["n_cycles"]],
  ", (cycle 0 - cycle ", rrs_cfg[["n_cycles"]], ") / cycle 0, mean and s.d. over the ", n_rep, " founder draws, per pool and arm. ", founder_note)
cap_pipeline <- paste0("`alphasimr_pipeline(rrs_cfg)` on one founder draw (that call uses the same seed as replicate 1; whether it returns the same founders was not established, Step 1), and `stage2_select()` on the stage-1 contract it returns. ",
  founder_note, " (a) Columns as in @tbl-alphasimr-cycle1. (b) `stage2_select()` with `n_sel` = ", n_hyb_sel, " of the ",
  rrs_cfg[["n_sel"]]^2, " elite hybrids, one row per scenario: `alpha`, the diversity-loss budget; `GD`, `GD_BS`, `F_ST` of the selected set; `index`, the mean selection index of the selected set.")

#' 
#' @sec-simulating-crosses built the `{X, f, hybrids, fL}` contract with a
#' deliberately fast simulator: Balding-Nichols allele frequencies, independent
#' markers, no recombination, no dominance. That is enough to exercise the
#' diversity and selection machinery, but it is not how a hybrid breeding
#' programme is actually run, and it is not how anyone would build one from
#' scratch. The two chapters between that one and this (@sec-sizing, the size of a
#' segregating population from F1 to F4, and @sec-backcross, introgression by
#' backcrossing) run on the package's own map-and-meiosis simulators, not on
#' AlphaSimR, and are not prerequisites for what follows; this chapter returns
#' to the contract of @sec-simulating-crosses and replaces its generator.
#' 
#' This chapter builds one. The crop in mind is maize, the canonical allogamous
#' hybrid crop: two heterotic pools, inbred lines (doubled haploids, DH) drawn from
#' each, lines judged by their testcrosses onto the other pool rather than by
#' themselves, pools improved by reciprocal recurrent selection (RRS; the paper
#' the book cites for the name is @comstock1949, and its content is not reported
#' here beyond its title, as in @sec-heterosis), and a commercial product that is a single cross between one
#' line from each pool -- the programme described in @sec-hybrid-programme. Steps 1 to 7 are a **step-by-step construction** with
#' AlphaSimR [@gaynor2021], written out in the primitive calls -- `runMacs()`,
#' `SimParam`, `addTraitAD()`, `makeCross()`, `hybridCross()`, `makeDH()`,
#' `setPheno()`, `selectInd()` -- with a plant breeder's reading of each argument
#' and a measurement at each step. Step 8 assembles those primitives into RRS,
#' replicates it against a paired no-selection control, and shows that the same
#' stage-1 contract comes out the other end, so `stage2_select()` runs on it
#' exactly as it does on the book's own simulated data.
#' 
#' **Why this machinery, and why it has no counterpart in a self-pollinated
#' programme.** In an autogamous (self-pollinated) crop -- wheat, rice, soybean,
#' common bean -- recombination happens once, in the F1, and the programme then
#' narrows a segregating population toward homozygosity by selfing or
#' single-seed descent, selecting throughout on a line's own (per se) phenotype,
#' because a self-pollinated genotype breeds true and its own performance *is*
#' what a farmer will grow: the released variety is very often the same
#' homozygous line the breeder selected. @sec-programme, later in the Evidence and
#' practice part, builds exactly that programme with the same AlphaSimR
#' primitives -- `makeDH()`, `setPheno()`, `selectInd()` -- and can be read
#' against this one, step by step.
#' None of Steps 2, 4 and
#' 6 below would have a job there: there is no dominance for per se selection to
#' be blind to (an inbred line's value is its additive merit alone -- Step 3
#' makes this an identity, `varD = 0` on a homozygous panel, to rounding in the numbers), no tester
#' to cross a candidate onto, no general or specific combining ability to
#' estimate [@sprague1942], and no second, deliberately divergent population to
#' keep apart, because there is only one gene pool, not two heterotic ones held
#' apart on purpose. What follows instead is specific to an allogamous,
#' hybrid-product crop: the inbred line is not the product, the F1 is (Step 5);
#' a line's breeding value depends on which pool it will be crossed to, not on
#' itself alone (Step 6's tester dependence); and the trait improvement a
#' programme has made is realised only in a cross remade every season, never in
#' either parental line by itself.
#' 
#' The pedagogical source is the AlphaSimR course of Gorjanc and colleagues
#' [@gorjanc2022]: its vignettes on simulating DNA, simulating traits, the DNA
#' lottery, single- and multi-trait selection, and a plant breeding programme.
#' The course has no hybrid programme of its own; the wheat programme it does build is the
#' subject of @sec-programme. This chapter takes the course's primitives and
#' assembles them into the hybrid case.
#' 
#' The order matters. Everything in Step 8 is a wrapper in
#' `R/13_alphasimr_bridge.R` -- `rrs_config`, `alphasimr_founder_pools()`,
#' `alphasimr_rrs_cycle()`, `alphasimr_make_hybrids()`, `alphasimr_to_stage1()`,
#' `alphasimr_pipeline()` -- and a wrapper is only readable once you know what it
#' is wrapping. AlphaSimR is a `Suggests` dependency, guarded exactly like
#' `quadprog` and `highs` elsewhere in the package; this chapter and
#' @sec-programme are the only ones that need it.
#' 
#' ## Step 1 -- Founder genomes: what a founder is, and which engine to use
#' 
#' Every AlphaSimR simulation starts with founder haplotypes. Before choosing an
#' engine, it is worth seeing what one produces, at a size small enough to read.
#' `inbred = TRUE` makes every founder fully homozygous, which is what a panel of
#' inbred lines is.
#' 
## -----------------------------------------------------------------------------
#| label: alphasimr-tiny-haplo
set.seed(1)
tiny <- quickHaplo(nInd = 3, nChr = 2, segSites = 4, inbred = TRUE)
SPt  <- SimParam$new(tiny)
tiny_pop <- newPop(tiny, simParam = SPt)
pullSegSiteHaplo(tiny_pop, simParam = SPt)

#' 
#' One row per haplotype, two per diploid individual (`1_1` and `1_2` are the two
#' chromosome copies of individual 1), one column per segregating site across both
#' chromosomes (`1_3` is chromosome 1, site 3). Alleles are coded 0 and 1 --
#' ancestral and derived under a coalescent engine, arbitrary labels under
#' `quickHaplo()`. Because the founders are inbred, the two rows of each
#' individual are identical. `pullSegSiteGeno()` sums the two
#' rows into an allele dosage in `{0, 1, 2}`:
#' 
## -----------------------------------------------------------------------------
#| label: alphasimr-tiny-geno
tiny_geno <- pullSegSiteGeno(tiny_pop, simParam = SPt)
tiny_geno
stopifnot(all(tiny_geno %in% c(0, 2)))
stopifnot(isTRUE(all.equal(diag(molecular_coancestry(tiny_geno / 2)),
                           rep(1, 3))))

#' 
#' The two assertions fix the coding for the rest of the book. AlphaSimR's dosage
#' is 0/1/2; the contract of @sec-simulating-crosses codes the same information as
#' 0/0.5/1, the within-individual frequency of the reference allele (AlphaSimR's
#' derived allele plays that role), and every bridge function divides by two on
#' the way across (`stage1_build()` also detects
#' and rescales 0/1/2 on its own). On an inbred individual the molecular
#' self-coancestry of @sec-coancestry is exactly 1, which is the second assertion.
#' 
#' There are two engines, and the choice is not cosmetic. `runMacs()` runs a
#' backward-in-time coalescent, the MaCS program [@chen2009], under a species-specific demography --
#' `species = "MAIZE"`, `"WHEAT"`, `"CATTLE"` -- so the founders carry a realistic
#' allele-frequency spectrum and realistic linkage disequilibrium (LD). `quickHaplo()`
#' samples 0s and 1s directly: instant, and with no history behind it.
#' @tbl-alphasimr-engines compares the two.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-engines
#| tbl-cap: "The two founder engines on one founder set of 20 inbred individuals, 10 chromosomes and 50 segregating sites per chromosome (`species = \"MAIZE\"` for `runMacs()`). `seconds_per_call`: wall-clock seconds per call, machine-dependent (`quickHaplo()` averaged over 100 calls); `same_twice`: identical haplotypes from two calls after the same `set.seed(7)` (one pair of calls per engine, one render); `R_stream_same_after`: identical `.Random.seed` after those two calls."
tm <- function(expr) as.numeric(system.time(expr)["elapsed"])

# reproducibility: two calls from the same seed, and R's own stream after each
set.seed(7); qa <- quickHaplo(nInd = 20, nChr = 10, segSites = 50, inbred = TRUE)
rs_qa <- .Random.seed
set.seed(7); qb <- quickHaplo(nInd = 20, nChr = 10, segSites = 50, inbred = TRUE)
rs_qb <- .Random.seed
set.seed(7); ma <- runMacs(nInd = 20, nChr = 10, segSites = 50, inbred = TRUE,
                           species = "MAIZE")
rs_ma <- .Random.seed
set.seed(7); mb <- runMacs(nInd = 20, nChr = 10, segSites = 50, inbred = TRUE,
                           species = "MAIZE")
rs_mb <- .Random.seed
stopifnot(identical(rs_qa, rs_qb), identical(rs_ma, rs_mb),
          identical(qa@geno, qb@geno))
# no assertion on ma vs mb: whether two runMacs() draws differ is what the
# table reports (same_twice), not something a render may require

# timing: one runMacs() call; quickHaplo() over n_rep_q calls, because a
# single call is below the clock's resolution
n_rep_q <- 100
t_m <- tm(runMacs(nInd = 20, nChr = 10, segSites = 50, inbred = TRUE,
                  species = "MAIZE"))
t_q <- tm(for (k in seq_len(n_rep_q))
            quickHaplo(nInd = 20, nChr = 10, segSites = 50, inbred = TRUE)) / n_rep_q

fmt(data.frame(engine              = c("quickHaplo", "runMacs"),
               seconds_per_call    = c(t_q, t_m),
               same_twice          = c(identical(qa@geno, qb@geno),
                                       identical(ma@geno, mb@geno)),
               R_stream_same_after = c(identical(rs_qa, rs_qb),
                                       identical(rs_ma, rs_mb))), 4)

#' 
#' Read the last two columns of @tbl-alphasimr-engines together. What was
#' measured is one pair of calls per engine, each pair after the same
#' `set.seed(7)`, in this render. For `quickHaplo()` the two outputs are
#' identical, as expected of pure R sampling. For `runMacs()`
#' (`species = "MAIZE"`, default threading) the two outputs
#' `r if (identical(ma@geno, mb@geno)) "were identical" else "differed"`, while
#' R's `.Random.seed` after the two calls was identical (asserted in the chunk).
#' Because R's stream is identical after both calls, every draw R makes afterwards
#' is the same in both runs; what can differ between two calls is the haplotypes
#' MaCS returns. What one pair does not show:
#' how often `runMacs()` returns different haplotypes from the same seed (a pair
#' is a count of one, and whether it repeats on another render is not recorded
#' here); whether `runMacs2()` does, which this chunk never calls and Step 8
#' uses; and why. A hypothesis, untested in this chapter, is that the output of
#' the multithreaded coalescent depends on thread scheduling (the `nThreads`
#' argument of `runMacs()`); nothing below depends on it.
#' 
#' (The `seconds_per_call` column is wall clock and will differ on your machine
#' and between renders. `runMacs()` takes seconds; `quickHaplo()`, timed over
#' `r n_rep_q` calls because one call is below the clock's resolution, takes
#' about `r fmt(1000 * t_q, 2)` ms per call.)
#' 
#' ::: {.callout-warning}
#' ## Founders from MaCS: what is established here and what is not
#' 
#' Reproducibility from `set.seed()` is the first property to check in a
#' simulation, because its failure is silent: the code looks reproducible, runs
#' without complaint, and returns different numbers. Established in this chapter:
#' one pair of `runMacs()` calls after the same seed
#' `r if (identical(ma@geno, mb@geno)) "returned identical" else "returned different"`
#' haplotypes in this render, with R's stream identical after both calls (asserted in the chunk).
#' Not established: a rate for `runMacs()`, anything for `runMacs2()` (the
#' engine of Step 8, whose founders the help page of `alphasimr_founder_pools()`,
#' @sec-limits and @sec-programme treat as not reproducible from `cfg$seed`; this
#' chapter did not test that), and a mechanism. The chapter therefore assumes
#' neither answer, and follows three rules that hold whichever is true:
#' 
#' 1. **Found once, then branch.** Any experiment comparing two schemes must draw
#'    the founders a single time and start both arms from that one object. Draw
#'    them twice and, if founders can differ between calls, the two arms start
#'    from different founders and the comparison measures the founders as much as
#'    the schemes. @sec-limits' linked arm is built this way, and so is Step 8's
#'    paired control below.
#' 2. **Seed immediately before each founder draw**, not once at the top, so that
#'    a founder draw does not inherit the stream of whatever ran before it.
#' 3. **Save what you cannot reseed.** `saveRDS(founderGenomes, ...)` is the only
#'    way to get the same coalescent history back in a later session if a
#'    re-call does not return it.
#' 
#' The consequence for this book: the HTML and the PDF are produced by separate
#' executions of the chapter (Quarto's `_freeze` keeps `html.json` and `typ.json`
#' apart), and each execution calls the founder draw again. Whether two such draws
#' coincide is not established here for `runMacs2()`: the chapter measures one
#' `runMacs()` pair per render and does not measure `runMacs2()`. If they do not
#' coincide, every number that depends on the founders (the pooled gene-diversity
#' $t$ of Step 8, the $GD_{BS}$ and $F_{ST}$ $t$, the sign of the stage-2
#' attainable-$\alpha$ ceiling, the covariance term at each split of the sweep) may
#' differ between the two formats, and no conclusion should rest on a statistic
#' close to a critical value. The covariance term at one split time of the sweep is
#' such a case (see the multiplicity paragraph there).
#' 
#' Everything after the founders -- the crosses, the doubled haploids, the
#' phenotyping error, the recombination -- is drawn from R's stream and is
#' controlled by `set.seed()`, given the same founder object.
#' :::
#' 
#' So what does `quickHaplo()` give up? Linkage disequilibrium among the founders.
#' The honest way to measure that is against the sampling floor: with `n`
#' individuals, two completely independent loci still show `r^2` of about
#' `1 / (n - 1)` by chance alone. @tbl-alphasimr-ld sets each engine against that floor.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-ld
#| tbl-cap: "Mean linkage disequilibrium ($r^2$ between allele dosages) among 100 inbred founders, 5 chromosomes and 200 segregating sites per chromosome, one draw per engine (seed 3). `adjacent`: neighbouring sites on the same chromosome; `overall`: all pairs of polymorphic sites; `noise`: $1/(n - 1)$, the $r^2$ expected between independent loci in a sample of $n$ individuals. The `runMacs` row is one draw; its repeatability from the seed was not tested (@tbl-alphasimr-engines)."
ldstat <- function(fg) {
  SPx <- SimParam$new(fg)
  g <- pullSegSiteGeno(newPop(fg, simParam = SPx), simParam = SPx)
  g <- g[, apply(g, 2, stats::sd) > 0, drop = FALSE]
  chr <- sub("_.*$", "", colnames(g))           # "chr_site" column names
  r <- stats::cor(g)
  adj <- diag(r[-nrow(r), -1])                  # consecutive columns ...
  adj <- adj[chr[-length(chr)] == chr[-1]]      # ... on the same chromosome
  c(adjacent = mean(adj^2),                     # neighbouring sites, same chromosome
    overall  = mean(r[upper.tri(r)]^2),         # all pairs, mostly distant
    noise    = 1 / (nrow(g) - 1))               # what pure chance gives
}
set.seed(3); lq <- ldstat(quickHaplo(nInd = 100, nChr = 5, segSites = 200,
                                     inbred = TRUE))
set.seed(3); lm_ <- ldstat(runMacs(nInd = 100, nChr = 5, segSites = 200,
                                   inbred = TRUE, species = "MAIZE"))
fmt(rbind(quickHaplo = lq, runMacs = lm_))

#' 
#' `adjacent` is the mean `r^2` between neighbouring sites on the same
#' chromosome (pairs that straddle a chromosome boundary are excluded);
#' `overall` is over all pairs, most of them on different chromosomes.
#' `quickHaplo()`'s adjacent-site `r^2` sits on the noise floor: there is no
#' founder LD at all, as designed. `runMacs()`'s is
#' `r fmt(lm_[["adjacent"]] / lm_[["noise"]], 0)` times the floor in this render,
#' and its *overall* `r^2` is barely above it -- so the LD it creates is local,
#' decaying with map distance, which is what real LD does.
#' 
#' The `runMacs` row of @tbl-alphasimr-ld is one draw (seed 3); whether a second
#' call from that seed returns the same row was not tested (@tbl-alphasimr-engines
#' reports the one pair that was). The `quickHaplo` row is reproducible to the last digit.
#' 
#' What that does and does not imply for the rest of the chapter. In the pair
#' measured, R's random-number state was identical after the two MaCS calls
#' (asserted in the chunk), so any step that draws its own `quickHaplo()`
#' founders from a fresh `set.seed()` is exactly reproducible, and so would be a
#' step that did not reseed. What may move between executions is anything
#' computed *from* MaCS founders -- the `runMacs` rows of
#' @tbl-alphasimr-engines and @tbl-alphasimr-ld, and all of Step 8, whose
#' engine `runMacs2()` was not measured. The chapter still calls
#' `set.seed()` immediately before each step's own founder draw rather than once
#' at the top, so that each step's founders do not depend on what earlier steps
#' drew. The draws that follow a founder draw are not all reseeded: in Steps 3
#' and 4 the phenotyping, the three rounds of random mating and the crosses of
#' the DNA lottery take R's stream from Step 2's `set.seed()` through chunk
#' order, so they are reproducible as part of this chapter's execution order,
#' not on their own. With that in place, two independent executions agree on
#' every number in Steps 1 to 7 except the wall-clock seconds and the `runMacs`
#' rows, whose repeatability is the open question above.
#' 
#' The policy this chapter follows does not need that question answered:
#' 
#' - **`quickHaplo(inbred = TRUE)` for Steps 2--7 and all of @sec-programme.** They
#'   teach the arithmetic of dominance, heterosis and response, where founder LD
#'   is not the point, and in exchange every number printed is reproducible from
#'   a clean clone. AlphaSimR still applies a real genetic map and real meiosis to
#'   every descendant, so linkage and the Bulmer effect of @sec-limits still
#'   operate -- only the founders' *history* is stylised.
#' - **`runMacs2(split = )` in Step 8.** There the divergence between two heterotic
#'   pools *is* the object of study, and no amount of speed compensates for not
#'   having it. Every Step 8 result is therefore replicated over founder draws,
#'   each drawn once and branched into both arms, and the verdicts that rest on a
#'   `t` near its critical value are written as conditional on the render.
#' 
#' Founder LD does matter where the association between markers and quantitative
#' trait loci (QTL) is the mechanism, which is genomic prediction. @sec-genomic-prediction does not model it: its traits are
#' built on the markers themselves, so every causal locus is genotyped, there is
#' no marker-QTL gap for founder LD to bridge, and its accuracies are a best case
#' in that respect.
#' 
#' ## Step 2 -- `SimParam`, and defining a trait with dominance
#' 
#' `SimParam` holds everything global: the genetic map, which sites are quantitative trait loci (QTL), the
#' trait effects, the error variances. It is an R6 object, so its methods are
#' called with `$`, and a variable named `SP` is picked up automatically by every
#' AlphaSimR function that needs it.
#' 
#' A hybrid programme exists because of dominance: without it a line's cross
#' performance is its own breeding value and there is nothing a testcross can see
#' that the line per se could not (@sec-heterosis). So the trait defined here, and
#' used through Step 6, carries a dominance term from the start. This is exactly
#' the reason an autogamous programme has no equivalent of this step: there,
#' dominance is invisible by construction (a released, self-pollinated variety is
#' homozygous, so no heterozygote is ever evaluated or sold) and `SP$addTraitA()`
#' -- additive effects only -- is the whole model, the case @sec-programme starts from, before adding genotype-by-environment
#' with `SP$addTraitAG()`.
#' 
## -----------------------------------------------------------------------------
# Seeded here, not once at the top of the chapter: Step 1 draws from R's random
# stream (each runMacs() call consumes a fixed amount of it), so everything
# downstream would move with any edit of Step 1 unless the seed
# is reset immediately before the draw that matters.
set.seed(101)
founders <- quickHaplo(nInd = 60, nChr = 10, segSites = 100, inbred = TRUE)
SP <- SimParam$new(founders)
SP$addTraitAD(nQtlPerChr = 100, mean = 10, var = 1,
              meanDD = rrs_cfg[["mean_dd"]], varDD = rrs_cfg[["var_dd"]])
SP$setVarE(h2 = 0.4)

#' 
#' AlphaSimR `r as.character(packageVersion("AlphaSimR"))` has
#' `r length(grep("^addTrait", ls(SimParam[["public_methods"]])))` trait
#' constructors (`r paste0("\x60", grep("^addTrait", ls(SimParam[["public_methods"]]), value = TRUE), "()\x60", collapse = ", ")`):
#' one per combination of additive effects with dominance (`D`), epistasis (`E`)
#' and genotype-by-environment (`G`). Choosing between them is choosing a model of
#' gene action; the four that bear on a plant programme are:
#' 
#' | Method | Adds | When a plant programme needs it |
#' |---|---|---|
#' | `SP$addTraitA()` | additive only | line per se performance; the course's teaching case [@gorjanc2022], and Step 7 here |
#' | `SP$addTraitAD()` | + dominance | testcross and hybrid value. This is what Steps 2--6 and Step 8 use |
#' | `SP$addTraitAG()` | + genotype-by-environment | multi-location yield trials, where the same genotype is scored in several places. @sec-programme uses it |
#' | `SP$addTraitADE()` | + epistasis | available; used nowhere in this book |
#' 
#' ### The dominance model, as AlphaSimR writes it
#' 
#' For a diploid with QTL $k = 1, \dots, m$, let $x_{ik} \in \{0, 1, 2\}$ be the
#' dosage of the derived allele of individual $i$ at QTL $k$ (the column of
#' `pullQtlGeno()`). AlphaSimR's `TraitAD` genetic value is
#' 
#' $$G_i \;=\; \mu_0 + \sum_{k=1}^{m} a_k\,(x_{ik} - 1) + \sum_{k=1}^{m} d_k\,\mathbb{1}[x_{ik} = 1]$$ {#eq-alphasimr-gv}
#' 
#' with $G_i$ the genetic value of individual $i$ (the $G(\mathbf{x})$ of
#' @sec-notation, written here on the 0/1/2 dosage rather than on the 0/0.5/1
#' row; not the Caballero-Toro statistic $G_i$ of @sec-subdivided), $x_{ik}$ in
#' this chapter always the 0/1/2 dosage (an entry of $\mathbf{M}^H$, not of
#' $\mathbf{X}$), $\mu_0$ an intercept, $a_k \in \mathbb{R}$ the additive effect (half the
#' difference between the two homozygotes, on the classical scale of
#' @falconer1996 [ch. 7; the chapter locators given for this book in this chapter
#' are not checked against a copy], which puts the origin at the midpoint of the two
#' homozygotes and assigns them $+a$ and $-a$ and the heterozygote $d$; no
#' equation number is attributed here, the scale is stated in full) and $d_k \in
#' \mathbb{R}$ the dominance effect, the departure of the heterozygote from that
#' midpoint (a property of the locus, as in @sec-heterosis-dk-meaning; not
#' Fisher's statistical dominance deviation, a property of a population, which is
#' what `varD` and `genicVarD` below measure). @eq-alphasimr-gv is the model of @sec-heterosis with AlphaSimR's coding, and the
#' chunk checks it rather than trusts it:
#' 
## -----------------------------------------------------------------------------
tr <- SP$traits[[1]]
a  <- tr@addEff
d  <- tr@domEff
pop0 <- newPop(founders, simParam = SP)
x0   <- pullQtlGeno(pop0, simParam = SP)
gv_by_hand <- as.numeric(tr@intercept + (x0 - 1) %*% a + (x0 == 1) %*% d)
stopifnot(isTRUE(all.equal(gv_by_hand, as.numeric(gv(pop0)))))

#' 
#' `meanDD` and `varDD` parameterise the **dominance degree**
#' $\delta_k = d_k / |a_k|$: AlphaSimR draws $\delta_k \sim N(\texttt{meanDD},
#' \texttt{varDD})$ and sets $d_k = \delta_k\,|a_k|$, so $\delta_k = 0$ is
#' additivity, $\delta_k = 1$ complete dominance, $\delta_k > 1$ overdominance,
#' and a *positive mean* is directional dominance: on average the heterozygote
#' sits above the homozygote midpoint, whichever allele is favourable. Directional
#' dominance is what makes heterosis positive and inbreeding depression a loss on
#' the trait scale; the presence of inbreeding depression is itself the evidence
#' for it [@mackay2020], and maize grain yield is generally reported to show large inbreeding
#' depression (@hallauer2010 is the maize reference; no page is cited, as the
#' book was not available to check one). @tbl-alphasimr-dd compares the requested and the realised
#' dominance degrees.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-dd
#| tbl-cap: "Dominance degree $\\delta_k = d_k / |a_k|$ of the trait of Step 2 over its 1000 QTL (seed 101): the `meanDD` and `varDD` passed to `addTraitAD()` (`requested`) against the mean and variance of $\\delta_k$ in the draw (`realised`)."
dd_k <- d / abs(a)
fmt(data.frame(statistic = c("mean", "variance"),
               requested = c(rrs_cfg[["mean_dd"]], rrs_cfg[["var_dd"]]),
               realised  = c(mean(dd_k), stats::var(dd_k))), 3)

#' 
#' `nQtlPerChr` sets how polygenic the trait is. Setting it equal to `segSites`
#' makes *every* segregating site a QTL, which is what this chapter does
#' throughout -- convenient, because then the marker matrix and the causal loci
#' are the same set and there is no marker-versus-QTL gap to reason about. Real
#' programmes have that gap; this book does not measure it, and @sec-genomic-era
#' (assumption A5) states the same collapse as a limit.
#' 
#' `mean` fixes the mean genetic value of the *founders*. `var` fixes their
#' **additive** variance (`useVarA = TRUE`, the default), not their total genetic
#' variance -- with inbred founders the two coincide, for a reason Step 3 shows.
#' `corA` (Step 7) sets the genetic correlation between traits.
#' 
#' The environmental variance has two routes, and plant breeders use the second:
#' 
#' - `SP$setVarE(h2 = 0.4)` fixes an error variance once, from the founders'
#'   genetic variance (here `r fmt(SP$varE, 2)`), and every later `setPheno()`
#'   reuses it.
#' - `setPheno(varE = , reps = )` sets it per call. **`reps` is the plant idiom for
#'   locations**: `varE` is the plot-level error, and a genotype scored in `reps`
#'   plots has its error variance divided by `reps`, so the phenotype is an
#'   entry mean. That is how a staged programme raises selection accuracy from
#'   one stage to the next without ever changing the trait's heritability -- the
#'   mechanism @sec-programme is built on, and the one Step 6 uses for testers.
#' 
#' ## Step 3 -- The base population, and where the variance components live
#' 
#' `newPop()` turns founder haplotypes into individuals and, because a trait is
#' now defined, computes their genetic values immediately (@tbl-alphasimr-base).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-base
#| tbl-cap: "The 60 inbred founders of Step 2 as a population (`newPop()`, one `setPheno()` draw after `setVarE(h2 = 0.4)`). `n`: individuals; `meanG`: mean genetic value (trait units); `varG`, `varP`: genetic and phenotypic variance (squared trait units); `h2_realised`: `varG`/`varP`."
pop <- setPheno(newPop(founders, simParam = SP), simParam = SP)
fmt(data.frame(n = pop@nInd, meanG = as.numeric(meanG(pop)),
               varG = as.numeric(varG(pop)), varP = as.numeric(varP(pop)),
               h2_realised = as.numeric(varG(pop) / varP(pop))), 3)

#' 
#' The realised heritability is near but not equal to the requested 0.4:
#' `setVarE()` fixes a variance, and the ratio it produces in any finite sample is
#' itself a random variable. This is a general and useful habit -- **check what the
#' simulation realised, do not assume what you requested.**
#' 
#' `genParam()` returns the full decomposition. Four of its fields are the ones a
#' hybrid programme cares about, and they read differently on a panel of inbred
#' lines and on a random-mating population made from them (@tbl-alphasimr-varcomp):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-varcomp
#| tbl-cap: "Genetic mean and variance components (`genParam()`) of the 60 inbred founders of Step 2 (`quickHaplo()`, seed 101; 10 chromosomes x 100 sites, every site a QTL; dominance degree drawn with `meanDD` = 0.4, `varDD` = 0.1) and of the population after three rounds of random mating (1000 crosses each). `varA`: realised additive variance; `genicVarA`: additive genic variance; `ratio`: `varA`/`genicVarA`; `varD`, `genicVarD`: realised and genic dominance variance. Means in trait units, variances in squared trait units."
mixed <- pop
for (k in 1:3) mixed <- randCross(mixed, nCrosses = 1000, simParam = SP)

vrow <- function(p, lab) {
  g <- genParam(p, simParam = SP)
  data.frame(population = lab,
             meanG     = as.numeric(g[["mu"]]),
             varA      = as.numeric(g[["varA"]]),
             genicVarA = as.numeric(g[["genicVarA"]]),
             ratio     = as.numeric(g[["varA"]] / g[["genicVarA"]]),
             varD      = as.numeric(g[["varD"]]),
             genicVarD = as.numeric(g[["genicVarD"]]))
}
vtab <- rbind(vrow(pop,   "founders (fully inbred)"),
              vrow(mixed, "after 3 random matings"))
fmt(vtab)
stopifnot(vtab[["varD"]][1] < 1e-10)

#' 
## -----------------------------------------------------------------------------
#| label: alphasimr-varA-LE
# Among fully homozygous lines the locus value is a (x - 1), so at linkage
# equilibrium varA = sum 4 p q a^2, while genicVarA = sum 2 p q alpha^2 with
# alpha = a + d (q - p): under dominance the LE ratio is close to, not
# exactly, 2. What varA carries above varA_LE is disequilibrium.
p_f      <- colMeans(x0) / 2                        # founder allele frequencies
varA_f   <- vtab[["varA"]][1]
genic_f  <- vtab[["genicVarA"]][1]
varA_LE  <- sum(4 * p_f * (1 - p_f) * a^2)
ratio_LE <- varA_LE / genic_f
varA_LD  <- varA_f - varA_LE
ratio_LD <- varA_LD / genic_f
stopifnot(isTRUE(all.equal(as.numeric(bv(pop, simParam = SP)[, 1]),
                           as.numeric(sweep(x0, 2, 2 * p_f) %*% a))))
# Verification echo, not a table: every value is cited in the text below.
c(varA = varA_f, varA_LE = varA_LE, ratio_LE = ratio_LE,
  varA_LD = varA_LD, ratio_LD = ratio_LD) |> fmt(4)

#' 
#' `varA` is the realised additive variance; `genicVarA` is what it would be if the
#' loci were independent and in Hardy-Weinberg proportions. Their ratio is the
#' whole subject of @sec-limits. "Genic variance" has two definitions in the book,
#' and they are not interchangeable. The package's `genic_var()`
#' (@eq-response-genic, @sec-response-genic) is $\sum_k \beta_k^2 \operatorname{Var}(x_k)$
#' with the *observed* per-locus variance of the genotype matrix it is given, so a
#' ratio of the realised variance to it isolates the covariance between loci.
#' AlphaSimR's `genicVarA` is $\sum_k 2 p_k q_k \alpha_k^2$ (below), the
#' Hardy-Weinberg expectation with the average effect $\alpha_k$, so a ratio to it
#' carries the homozygosity of the population as well. The two coincide only for
#' an additive trait in Hardy-Weinberg proportions; on the inbred panel below
#' they differ by about the factor the next paragraph separates. This chapter
#' uses AlphaSimR's.
#' 
#' The founders' ratio of `r fmt(vtab[["ratio"]][1], 2)` has two parts, and the
#' chunk separates them. Among fully homozygous lines the value at QTL $k$ is
#' $a_k (x_{ik} - 1)$ with $x_{ik} \in \{0, 2\}$, and AlphaSimR's `bv()` on these
#' founders is exactly $\sum_k a_k (x_{ik} - 2 p_k)$ (asserted in the chunk). At
#' linkage equilibrium its variance is `varA_LE`
#' $= \sum_k 4 p_k q_k a_k^2 =$ `r fmt(varA_LE, 4)`, against a genic value of
#' `r fmt(genic_f, 4)`: a ratio of `r fmt(ratio_LE, 2)`, exact given the effects
#' and the frequencies. That part is **inbreeding** -- a homozygous population
#' has per-locus variance `4pq` where a Hardy-Weinberg one has `2pq`. It is close
#' to 2 and not exactly 2 because `genicVarA` is written with the Hardy-Weinberg
#' average effect $\alpha_k = a_k + d_k (q_k - p_k)$ defined below, whereas the
#' homozygous lines carry $a_k$; twice the genic value equals `varA_LE` only
#' where $d_k (q_k - p_k) = 0$ at every locus. The remainder,
#' `varA_LD = varA - varA_LE` $=$ `r fmt(varA_LD, 4)`, or `r fmt(ratio_LD, 2)`
#' in ratio units, is sampling (gametic-phase) disequilibrium among only 60
#' founders' worth of gametes. Three rounds of random mating restore
#' Hardy-Weinberg and pull the ratio to `r fmt(vtab[["ratio"]][2], 2)`; what
#' remains is that same disequilibrium. A ratio away from 1 in an *outbred*
#' population is the gametic-phase disequilibrium @sec-response defines and
#' @sec-limits measures; a ratio away from 1 in an inbred one is mostly the
#' homozygosity.
#' 
#' The dominance columns carry the hybrid lesson. **`varD` among the inbred
#' founders is zero to rounding** (`r fmt_sci(vtab[["varD"]][1])`, asserted
#' below `1e-10` in the chunk above): a homozygous line has no heterozygous locus, so its dominance
#' contribution is zero whatever $d_k$ is, and no amount of per se evaluation of inbred lines can see dominance. This
#' single identity is the operational reason an autogamous programme stops at
#' per se selection and never needs a testcross: its released lines are exactly
#' this "founders" row, `varD = 0` for the whole life of the programme, so a
#' line's genetic value equals its breeding value up to a constant common to all
#' lines (the `bv()` assertion above: $G_i - \sum_k a_k (x_{ik} - 2p_k) = \mu_0 +
#' \sum_k a_k (2p_k - 1)$), and its per se phenotype is that value plus error.
#' After random mating `varD` appears. Two identities make that quantitative. With
#' $p_k$ the founders' frequency of the derived allele at QTL $k$ and
#' $q_k = 1 - p_k$, the population mean under Hardy-Weinberg proportions is the
#' single-locus mean of @falconer1996 [ch. 7], summed over loci (no equation number
#' is attributed)
#' 
#' $$M_{HW} \;=\; \mu_0 + \sum_k \big[a_k\,(p_k - q_k) + 2\,p_k q_k\,d_k\big]$$ {#eq-alphasimr-mhw}
#' 
#' while the inbred panel at the same frequencies has only the first term of
#' @eq-alphasimr-mhw. The
#' difference, $2\sum_k d_k p_k q_k$, is the inbreeding depression of
#' @sec-heterosis at $F = 1$, which the package computes as
#' `inbreeding_depression(p, d, F_coef = 1)`. And the genic additive variance is
#' $\sum_k 2 p_k q_k \alpha_k^2$ with $\alpha_k = a_k + d_k\,(q_k - p_k)$ the
#' average effect of a gene substitution. @falconer1996 define $\alpha$ in
#' Ch. 7 and the single-locus additive variance $2pq\alpha^2$ in Ch. 8; the
#' equation numbers are not attributed here, so both identities are stated in
#' this chapter's notation: $\alpha_k = a_k + d_k\,(q_k - p_k)$ and, summed over
#' independent loci, $\sum_k 2 p_k q_k \alpha_k^2$, which is the genic variance.
#' ($\alpha_k$ is the average effect throughout this chapter, not the
#' diversity-loss budget $\alpha$ of the rest of the book.) The chunk asserts
#' both identities; @tbl-alphasimr-hw gives the two means.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-hw
#| tbl-cap: "Mean genetic value (trait units) of the 60 inbred founders of Step 2 (`mean_inbred`, `genParam()$mu`) and of a Hardy-Weinberg population at their allele frequencies (`mean_HW`, `genParam()$mu_HW`, @eq-alphasimr-mhw), and their difference, the inbreeding depression at $F = 1$ (`inbreeding_depression(p, d, F_coef = 1)`)."
gp  <- genParam(pop, simParam = SP)
alpha_f <- a + d * (1 - 2 * p_f)
stopifnot(isTRUE(all.equal(as.numeric(gp[["mu_HW"]] - gp[["mu"]]),
                           inbreeding_depression(p_f, d, F_coef = 1))))
stopifnot(isTRUE(all.equal(as.numeric(gp[["genicVarA"]]),
                           sum(2 * p_f * (1 - p_f) * alpha_f^2))))
fmt(data.frame(mean_inbred = as.numeric(gp[["mu"]]),
               mean_HW = as.numeric(gp[["mu_HW"]]),
               inbreeding_depression = inbreeding_depression(p_f, d, F_coef = 1)), 3)

#' 
#' Both hold to machine precision against AlphaSimR's own `genParam()`. The gap
#' between the two means is the amount a random-mating population built from these
#' lines would sit *above* the lines themselves -- and, read in the other
#' direction, the amount an open-pollinated population loses on being driven to
#' homozygosity. It is the same $d$ that Step 4 turns into heterosis.
#' 
#' ## Step 4 -- The DNA lottery, heterosis, and why an F1 is not a family
#' 
#' The course [@gorjanc2022] demonstrates Mendelian sampling by crossing outbred
#' founders and showing that full sibs vary. With **inbred** parents the result is different
#' (@tbl-alphasimr-lottery), and it is the fact hybrid breeding is organised around.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-lottery
#| tbl-cap: "The DNA lottery for the three crosses among founders 1, 2 and 3 of Step 2: 200 F1 plants per cross and 200 DH lines from one F1 plant. Genetic values in trait units. (a) `parent_mean`, `better_parent`: mid-parent and better-parent value; `f1_mean`, `f1_sd`: mean and s.d. over the F1 plants. (b) `dh_sd`, `dh_best`: s.d. and maximum over the DH lines; `transgressive`: fraction of DH lines above the better parent; `gap_in_dh_sd`: better parent minus mid-parent, in DH s.d."
#| tbl-subcap:
#|   - "Parents and F1"
#|   - "DH lines"
crosses <- list(c(1, 2), c(1, 3), c(2, 3))
n_lot   <- 200   # F1 plants and DH lines per cross
lottery <- do.call(rbind, lapply(crosses, function(ij) {
  plan <- matrix(ij, ncol = 2)
  f1 <- makeCross(pop, plan, nProgeny = n_lot, simParam = SP)
  dh <- makeDH(makeCross(pop, plan, nProgeny = 1, simParam = SP),
               nDH = n_lot, simParam = SP)
  better <- max(gv(pop)[ij])
  data.frame(cross         = paste(ij, collapse = " x "),
             parent_mean   = mean(gv(pop)[ij]),
             better_parent = better,
             f1_mean       = as.numeric(meanG(f1)),
             f1_sd         = as.numeric(sqrt(varG(f1))),
             dh_sd         = as.numeric(sqrt(varG(dh))),
             dh_best       = max(gv(dh)),
             transgressive = mean(gv(dh) > better),
             # how far the better parent sits above the DH mean, in DH s.d.
             gap_in_dh_sd  = (better - mean(gv(pop)[ij])) / as.numeric(sqrt(varG(dh))))
}))
fmt(lottery[, c("cross", "parent_mean", "better_parent", "f1_mean", "f1_sd")], 3)
fmt(lottery[, c("cross", "dh_sd", "dh_best", "transgressive", "gap_in_dh_sd")], 3)
stopifnot(all(lottery[["f1_sd"]] < 1e-8))
stopifnot(which.max(lottery[["transgressive"]]) == which.min(lottery[["gap_in_dh_sd"]]))

#' 
#' `f1_sd` is **zero**, asserted to machine precision. Two fully inbred parents
#' are homozygous everywhere, so every gamete each one makes is identical, and
#' every F1 is the same heterozygote. The `r n_lot` F1 plants from a cross of two inbred lines are
#' `r n_lot` copies of one genotype. There is no lottery yet -- and this
#' uniformity is the first reason a single-cross hybrid is a saleable variety.
#' 
#' `f1_mean` sits well above `better_parent`. That is heterosis, and under the
#' model of @eq-alphasimr-gv it has an exact value: for inbred parents $i$ and $j$ with
#' allele indicators $u_{ik}, u_{jk} \in \{0, 1\}$ (their dosage halved), the F1
#' is heterozygous exactly where they differ, so
#' 
#' $$H_{ij} \;=\; G_{ij} - \tfrac{1}{2}(G_i + G_j) \;=\; \sum_k d_k\,\mathbb{1}[u_{ik} \neq u_{jk}]$$ {#eq-alphasimr-hij}
#' 
#' with $G_{ij}$ the genetic value of the F1 between $i$ and $j$ (@eq-alphasimr-gv
#' applied to its dosages). The additive terms cancel from the mid-parent
#' difference because an inbred parent's additive contribution is exactly half
#' the F1's. `heterosis_value(X, d)` is this sum, with `X` the F1's 0/0.5/1
#' genotype; the chunk asserts it against AlphaSimR's genetic values and
#' @tbl-alphasimr-heterosis lists it per cross:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-heterosis
#| tbl-cap: "Mid-parent heterosis $H_{ij}$ (@eq-alphasimr-hij, trait units) of the three crosses of @tbl-alphasimr-lottery: `heterosis_value()` on one F1 plant per cross, asserted equal to the F1's genetic value minus the mid-parent."
H <- vapply(seq_along(crosses), function(s) {
  ij <- crosses[[s]]
  f1 <- makeCross(pop, matrix(ij, ncol = 2), nProgeny = 1, simParam = SP)
  hv <- as.numeric(heterosis_value(pullQtlGeno(f1, simParam = SP) / 2, d))
  stopifnot(isTRUE(all.equal(as.numeric(gv(f1)) - mean(gv(pop)[ij]), hv)))
  hv
}, numeric(1))
names(H) <- lottery[["cross"]]
fmt(data.frame(cross = names(H), heterosis = unname(H)), 3)

#' 
#' Over a *set* of crosses the same identity has a closed form in the allele
#' frequencies. Take the `r pop@nInd` founders as two arbitrary halves, "pool A" (lines
#' 1--`r pop@nInd / 2`) and "pool B" (lines `r pop@nInd / 2 + 1`--`r pop@nInd`) -- arbitrary because `quickHaplo()` gave
#' them a common history and no divergence, which Step 8 will add -- and cross
#' every A line to every B line. `hybridCross(crossPlan = "testcross")` is the
#' full factorial. With $p_{Ak}$ and $p_{Bk}$ the derived-allele frequencies of
#' the two pools at QTL $k$, the mean of $H_{ij}$ over the factorial is
#' `heterosis_expected(pA, pB, d)`, the identity of @sec-heterosis:
#' 
#' $$\bar H \;=\; \sum_k d_k\,\big(p_{Ak} + p_{Bk} - 2\,p_{Ak}\,p_{Bk}\big)$$ {#eq-alphasimr-hbar}
#' 
#' with $\bar H$ the mean mid-parent heterosis over the factorial (the $\mu$ of
#' @sec-notation, renamed because $\mu_0$ is the intercept here;
#' @tbl-alphasimr-factorial).
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-factorial
#| tbl-cap: "The full factorial between the two halves of the 60 founders of Step 2 (pool A: lines 1 to 30, pool B: lines 31 to 60). `n_hybrids`: number of A x B hybrids; `mean_A`, `mean_B`, `mean_hybrids`: mean genetic value of each pool and of the hybrids (trait units); `heterosis_observed`: hybrid mean minus mid-parent of the pool means; `heterosis_expected`: @eq-alphasimr-hbar; `pct_of_midparent`: observed heterosis as percent of the mid-parent."
n_half <- pop@nInd / 2
A <- pop[seq_len(n_half)]
B <- pop[n_half + seq_len(n_half)]
fact <- hybridCross(A, B, crossPlan = "testcross", simParam = SP)
U  <- pullQtlGeno(A, simParam = SP) / 2
V  <- pullQtlGeno(B, simParam = SP) / 2
pA <- colMeans(U)
pB <- colMeans(V)
H_bar_obs <- as.numeric(meanG(fact)) - (as.numeric(meanG(A)) + as.numeric(meanG(B))) / 2
H_bar_exp <- heterosis_expected(pA, pB, d)
stopifnot(isTRUE(all.equal(H_bar_obs, H_bar_exp)))
fact_tab <- c(n_hybrids = fact@nInd, mean_A = as.numeric(meanG(A)),
  mean_B = as.numeric(meanG(B)), mean_hybrids = as.numeric(meanG(fact)),
  heterosis_observed = H_bar_obs, heterosis_expected = H_bar_exp,
  pct_of_midparent = 100 * H_bar_obs / ((as.numeric(meanG(A)) + as.numeric(meanG(B))) / 2))
# one row per statistic: seven columns would not fit the page
fmt(data.frame(statistic = names(fact_tab), value = unname(fact_tab)), 3)

#' 
#' Exact, on the full factorial, because every A x B pairing is present once.
#' The size -- `r fmt(100 * H_bar_obs / ((as.numeric(meanG(A)) + as.numeric(meanG(B))) / 2), 1)`
#' percent of the mid-parent -- follows from `meanDD` and from `quickHaplo()`'s
#' frequencies near one half, where $p_A + p_B - 2 p_A p_B$ is near its
#' maximum; it is not calibrated to a crop. @falconer1996 [ch. 14] derive the
#' heterosis of the F1 between two *random-mating* populations as
#' $H_{F1} = \sum_k d_k y_k^2$ with $y_k = p_{Ak} - p_{Bk}$ (stated here in this
#' chapter's notation rather than by their equation number; it is twice the
#' `divergence` term of `heterosis_partition()`). The two do not conflict; they
#' use different mid-parents. Theirs carries each population's own
#' random-mating heterozygosity; an inbred line carries none, so the whole F1
#' heterozygosity is heterosis and @eq-alphasimr-hbar keeps the `shared` term
#' as well -- @sec-heterosis works the reconciliation through.
#' 
#' The lottery starts one meiosis later. `dh_sd` is the standard deviation among
#' doubled haploids drawn from that F1, and it is substantial -- this is the
#' segregation that F2, DH and recombinant inbred line (RIL) populations exist to sample. The number of
#' DH lines you pull from a cross is the number of tickets you buy, and no
#' downstream selection stage can recover a combination that was never sampled;
#' @sec-sizing sizes that number for selfing-derived F4 lines, not for DH lines.
#' 
#' `transgressive` is the fraction of DH lines exceeding the *better* parent per
#' se: `r fmt(lottery[["transgressive"]][1], 3)`,
#' `r fmt(lottery[["transgressive"]][2], 3)` and
#' `r fmt(lottery[["transgressive"]][3], 3)` for the three crosses. It depends
#' strongly on the cross, and `gap_in_dh_sd` says why: the DH lines are centred
#' on the mid-parent, so what matters is how far the better parent sits above it
#' in units of the DH standard deviation -- `r fmt(lottery[["gap_in_dh_sd"]][1], 2)`,
#' `r fmt(lottery[["gap_in_dh_sd"]][2], 2)` and
#' `r fmt(lottery[["gap_in_dh_sd"]][3], 2)`. The cross with the smallest gap is
#' the one with the most transgressive lines (asserted),
#' `r fmt(100 * max(lottery[["transgressive"]]), 0)` percent of them; the other two,
#' whose better parent is
#' `r paste(fmt(sort(lottery[["gap_in_dh_sd"]], decreasing = TRUE)[1:2], 2), collapse = " and ")`
#' DH standard deviations above the mid-parent, give
#' `r paste(fmt(100 * sort(lottery[["transgressive"]])[1:2], 1), collapse = " and ")`
#' percent. These are the values of this draw of 200 DH lines per cross; the
#' ordering is asserted, the percentages are not a constant of the model. Crossing two parents whose favourable alleles
#' sit at different loci produces progeny beyond either of them -- transgressive
#' segregation, which @mackay2020 treat, with heterosis and inbreeding
#' depression, as consequences of one mechanism: favourable alleles dispersed
#' between the parents, plus directional dominance -- and how often depends on
#' the gap between the parents relative to the segregation variance, not on a
#' constant.
#' 
#' ## Step 5 -- Selfing, doubled haploids, and why hybrid seed is remade every year
#' 
#' A plant breeder has to get from a heterozygous F1 to a homozygous line. There
#' are two routes, and AlphaSimR implements both. Following the same cross through
#' selfing generations also answers a question every hybrid grower has asked:
#' what happens if the F1 seed is saved and sown again.
#' 
#' This is the one step where the allogamous, hybrid case and the autogamous
#' case use literally the same primitive -- `makeDH()` is exactly what
#' @sec-programme calls to take its wheat F1s straight to a homozygous line, one
#' generation instead of the six or seven selfing generations traced in @tbl-alphasimr-selfing --
#' and where they diverge again in what the resulting inbred line is *for*. In
#' an autogamous programme that homozygous line is commonly the release: it
#' breeds true, so what leaves the DH pipeline is what a farmer eventually
#' grows. In this chapter's programme the homozygous DH line is a parent, held
#' inside a heterotic pool, testcrossed and recycled (Step 6, Step 8), and never
#' sold on its own; the object a grower plants is the F1 these lines make
#' together, which is the reason it cannot be saved.
#' 
#' Under selfing without selection, the fraction of the F1's heterozygous loci
#' still heterozygous in generation $F_t$ is $(1/2)^{t-1}$ in expectation, so the
#' expected mean of the selfed generation is
#' 
#' $$\mathbb{E}[M_{F_t}] \;=\; \tfrac{1}{2}(G_i + G_j) + H_{ij}\,(1/2)^{t-1}$$ {#eq-alphasimr-selfing}
#' 
#' with $H_{ij}$ the F1 heterosis of @eq-alphasimr-hij. The index $t$ counts
#' generations from the F1 ($t = 1$), so this is the halving of heterozygosity per selfing of
#' @sec-hp-inbreeding with its index shifted by one, and @sec-sizing-verify checks
#' the per-plant heterozygosity against it by simulation. At $t = 2$ this is the classical
#' result that the F2 retains half the F1 heterosis, $H_{F2} = \tfrac{1}{2} H_{F1}$,
#' which @falconer1996 derive in Ch. 14 for the F2 of a cross between two
#' populations (stated here in this chapter's notation rather than by their
#' equation number); @eq-alphasimr-selfing extends it to later selfed generations by
#' the same argument, since the expected heterozygosity at every locus is halved
#' each generation. @tbl-alphasimr-selfing follows one cross through seven
#' generations.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-selfing
#| tbl-cap: "Selfing trajectory of the cross 1 x 2 of @tbl-alphasimr-lottery (seed 55): 400 F1 plants, each the root of one single-seed selfing lineage carried to F7, and one DH line per F1 plant. `homozygosity`: fraction of homozygous segregating sites; `meanG`, `sdG`: mean and s.d. of genetic value over the 400 plants, in trait units; `expected`: @eq-alphasimr-selfing; `z`: (`meanG` - `expected`) over `sdG`/$\\sqrt{400}$, set to 0 for the F1, which has no variance. Rows follow the same lineages and are not independent."
homozygosity <- function(p)
  mean(pullSegSiteGeno(p, simParam = SP) %in% c(0, 2))

# Seeded here so that the |z| < 4 check below does not inherit the RNG state
# of Step 4: this z-statistic is not exactly Gaussian at this sample size, so
# an unrelated upstream edit that reseeded Step 4 could otherwise flip the
# check and break the render even though it passes for the seed used here.
set.seed(55)
n_f1 <- 400   # F1 plants, each the root of one selfing lineage
ij <- c(1, 2)
midparent <- mean(gv(pop)[ij])
f1  <- makeCross(pop, matrix(ij, ncol = 2), nProgeny = n_f1, simParam = SP)
gen <- f1
traj <- data.frame(generation = "F1", homozygosity = homozygosity(f1),
                   meanG = as.numeric(meanG(f1)), sdG = as.numeric(sqrt(varG(f1))),
                   expected = midparent + H[["1 x 2"]])
for (t in 2:7) {
  gen  <- self(gen, nProgeny = 1, simParam = SP)
  traj <- rbind(traj, data.frame(generation = paste0("F", t),
                                 homozygosity = homozygosity(gen),
                                 meanG = as.numeric(meanG(gen)),
                                 sdG = as.numeric(sqrt(varG(gen))),
                                 expected = midparent + H[["1 x 2"]] * (1 / 2)^(t - 1)))
}
dh1 <- makeDH(f1, nDH = 1, simParam = SP)
traj <- rbind(traj, data.frame(generation = "DH", homozygosity = homozygosity(dh1),
                               meanG = as.numeric(meanG(dh1)),
                               sdG = as.numeric(sqrt(varG(dh1))),
                               expected = midparent))
traj[["z"]] <- (traj[["meanG"]] - traj[["expected"]]) / (traj[["sdG"]] / sqrt(n_f1))
traj[["z"]][1] <- 0   # F1: no variance, and the identity of Step 4 is exact
fmt(traj, 3)
stopifnot(all(abs(traj[["z"]]) < 4),
          traj[traj[["generation"]] == "DH", "homozygosity"] == 1)

#' 
#' Three columns, three lessons.
#' 
#' `homozygosity`: `self()` halves the remaining heterozygosity every generation
#' -- the familiar `1 - (1/2)^(t-1)` approach to fixation, which never quite
#' arrives. `makeDH()` gets there in one step, at 1.0 exactly, by doubling a
#' haploid gamete.
#' 
#' `meanG` against `expected`: the F2 mean falls by half the heterosis, the F3 by
#' three quarters, and the DH lines land on the mid-parent. Each row is `r n_f1`
#' plants, one per F1 plant: `self(nProgeny = 1)` carries `r n_f1` parallel,
#' independent selfing lineages forward, so within a row the `r n_f1` values are
#' independent and `sdG / sqrt(n_f1)` is the standard error of the row's mean.
#' The check is statistical: `z` is the observed minus expected mean in units of
#' that standard error, and the chunk asserts every `|z| < 4`. Across rows the
#' same `r n_f1` lineages are followed -- each $F_t$ plant is the selfed progeny of
#' one $F_{t-1}$ plant -- so successive rows are correlated, and the table is
#' `r n_f1` lineages checked at seven generations, not seven independent samples.
#' Nothing about the parents changed; the loss is the heterozygosity
#' being halved, times $d$. This is why hybrid seed is remade from the two inbred
#' parents every season and why a maize F2 crop yields visibly less than the F1
#' it was saved from.
#' 
#' `sdG`: the F1 has none and the F2 has plenty. The F2 is not a variety; it is a
#' segregating population, and a uniform, high-yielding one cannot be recovered
#' from it by anything but selection and re-fixation -- which is the line
#' development a breeding programme does, not something a grower can do.
#' 
#' The saving DH buys is seasons, and seasons are the currency of a breeding
#' programme: six or seven selfing generations against one DH cycle. Step 8's
#' scheme uses `makeDH()` for precisely this reason, and the cost that never
#' shows up in the simulation is that DH production is a laboratory operation
#' with its own failure rate and its own genotype-dependent response.
#' 
#' The other operations a scheme needs are all one call each: `randCross()` for
#' random mating within a pool, `makeCross()` for a specified crossing plan,
#' `hybridCross()` for a full factorial or a testcross between two groups, and
#' `mergePops()` or `c()` to combine populations.
#' 
#' ## Step 6 -- Phenotyping and selection: per se, then on the testcross
#' 
#' Selection needs a criterion. `setPheno()` supplies the noisy one; `selectInd()`
#' acts on it. This step does it twice: first on a line's own phenotype, as the
#' course does [@gorjanc2022], to check the breeder's equation; then on the testcross, which is
#' how a hybrid programme actually ranks lines.
#' 
#' ### Per se selection and the breeder's equation
#' 
#' @tbl-alphasimr-breeders checks the breeder's equation on per se selection.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-breeders
#| tbl-cap: "The breeder's equation under per se truncation selection of the random-mated population of @tbl-alphasimr-varcomp, at three selected fractions `q`, each averaged over 20 independent draws of phenotypes, selection and 1000 progeny (seeds 501 to 520). Responses in trait units. (a) `i_normal`: normal-theory intensity; `i_empirical`: standardised selection differential; `R_S_h2`: $S h^2$ with narrow-sense $h^2$; `R_i_r_sdA`: $i r \\sigma_A$. (b) `R_observed`: realised change in genetic mean, `R_observed_sd` its s.d. over draws; `gap_mean`, `gap_sd`: mean and s.d. of `R_observed` - `R_S_h2`."
#| tbl-subcap:
#|   - "Intensity and predicted response"
#|   - "Observed response"
n_prog <- 1000   # progeny of the selected parents, per draw
be_draw <- function(q, r) {
  set.seed(500 + r)
  mx    <- setPheno(mixed, simParam = SP)
  sel   <- selectInd(mx, nInd = round(q * mx@nInd), use = "pheno", simParam = SP)
  prog  <- randCross(sel, nCrosses = n_prog, simParam = SP)
  S     <- as.numeric(meanP(sel) - meanP(mx))
  vA    <- as.numeric(varA(mx, simParam = SP))
  i_emp <- S / sqrt(as.numeric(varP(mx)))
  r_emp <- stats::cor(bv(mx, simParam = SP)[, 1], pheno(mx)[, 1])
  c(i_empirical = i_emp,
    R_S_h2      = S * vA / as.numeric(varP(mx)),
    R_i_r_sdA   = i_emp * r_emp * sqrt(vA),
    R_observed  = as.numeric(meanG(prog) - meanG(mixed)))
}
n_be <- 20
sweep_q <- do.call(rbind, lapply(c(0.05, 0.10, 0.20), function(q) {
  draws <- t(sapply(seq_len(n_be), function(r) be_draw(q, r)))
  gap   <- draws[, "R_observed"] - draws[, "R_S_h2"]
  data.frame(q = q, i_normal = sel_intensity(q),
             t(colMeans(draws)),
             R_observed_sd = stats::sd(draws[, "R_observed"]),
             gap_mean = mean(gap), gap_sd = stats::sd(gap))
}))
fmt(sweep_q[, c("q", "i_normal", "i_empirical", "R_S_h2", "R_i_r_sdA")], 3)
fmt(sweep_q[, c("q", "R_observed", "R_observed_sd", "gap_mean", "gap_sd")], 3)

#' 
#' Both forms of the breeder's equation are here, each averaged over `r n_be`
#' independent draws of the phenotypes, the selection and the progeny (the
#' population selected from is the same `mixed` every time, so `varA` is fixed
#' and only `S`, the accuracy and the Mendelian sampling vary). `R = S * h2` uses
#' the selection differential directly, with `h2` the *narrow-sense* heritability
#' `varA / varP` of the population selected from; `R = i * r * sigma_A`
#' decomposes it into intensity, accuracy and available variation -- the form
#' @sec-response builds the book's objective side on. Because the trait has
#' dominance, the accuracy `r` is the correlation of the phenotype with the
#' **breeding value** (`bv()`), not with the total genetic value: only the
#' additive part is transmitted. This is not the $r$ of @eq-response-breeders in
#' @sec-response, which is the accuracy as a predictor of genetic value for a
#' purely additive trait ($d_k \equiv 0$, $\sigma_A$ estimated by `sd(gv)`); the
#' two coincide only if $d = 0$. And `R_observed` is not the object @sec-response
#' checks: there the response is the genetic selection differential of the selected
#' hybrids, not a transmitted change, whereas here `R_observed` is the realised
#' change in *genetic* mean between the selected parents' random-mated progeny and
#' the starting population, which is what the prediction is a prediction of. The
#' letter $r$ also names the number of locations in the next subsection; it is
#' the accuracy only in this subsection.
#' 
#' `gap_mean` is the paired difference between the observed response and
#' `R_S_h2`, with `gap_sd` its standard deviation over the draws. The mean gap is
#' `r fmt(100 * sweep_q[["gap_mean"]][1] / sweep_q[["R_S_h2"]][1], 1)` percent of
#' the prediction at `q = 0.05` and
#' `r fmt(100 * sweep_q[["gap_mean"]][3] / sweep_q[["R_S_h2"]][3], 1)` percent at
#' `q = 0.20`; its standard error over the `r n_be` draws is
#' `gap_sd / sqrt(`r n_be`)`, and the largest gap in units of that standard
#' error is `r fmt(max(abs(sweep_q[["gap_mean"]] / (sweep_q[["gap_sd"]] / sqrt(n_be)))), 1)`.
#' A single draw is another matter: `R_observed_sd` says that
#' one realisation of the response scatters by around
#' `r fmt(100 * sweep_q[["R_observed_sd"]][1] / sweep_q[["R_S_h2"]][1], 0)` percent
#' of the prediction at `q = 0.05`, which is why the course's one-off comparison
#' [@gorjanc2022] "did not match perfectly" and why this one is replicated. The equation
#' predicts the additive response to first order in the allele-frequency change;
#' what it leaves out is second order in that change and the dominance
#' contribution of the progeny's departure from Hardy-Weinberg proportions, both
#' small with `r n_prog` progeny from `r round(0.05 * mixed@nInd)` or more parents.
#' The empirical intensity agrees with the normal-theory value to within
#' `r fmt(100 * max(abs(sweep_q[["i_empirical"]] / sweep_q[["i_normal"]] - 1)), 1)`
#' percent: with `r mixed@nInd` candidates and a criterion that is a sum over
#' `r length(a)` loci plus normal error, the two assumptions of `sel_intensity()`
#' -- an infinite population and a normal criterion -- are nearly met.
#' 
#' The book exports its own selection intensity, and AlphaSimR exports one too.
#' They are independent implementations of `phi(z) / q`:
#' 
## -----------------------------------------------------------------------------
#| label: alphasimr-selint-check
q <- 0.05
d_int <- abs(sel_intensity(q) - selInt(q))
stopifnot(d_int < 1e-10)          # two implementations of phi(z) / q
c(hybdiv = sel_intensity(q), AlphaSimR = selInt(q)) |> fmt(10)
cat("absolute difference:", format(d_int, digits = 2), "(asserted < 1e-10)\n")

#' 
#' `selectInd()` takes `use = "pheno"`, `"gv"` or `"ebv"`. Selecting on `"gv"` is
#' selecting with perfect accuracy -- impossible in a real programme, and the
#' correct way to compute the ceiling a scheme is being measured against.
#' `use = "ebv"` selects on whatever has been written into the population's `ebv`
#' slot, which is how genomic selection enters a simulation (@sec-programme).
#' `selectTop = FALSE` selects downwards, for traits where less is better.
#' 
#' `selectWithinFam()` is the plant-specific one. A programme that truncates
#' globally on a set of families concentrates its selections in the best
#' crosses, by an amount that depends on the number and size of the families and
#' on the heritability (none of which is measured here); capping the number retained per family holds the
#' programme's genetic base open at some cost in immediate gain. It is the same
#' trade-off as the `max_use` parental cap of @sec-combinatorial, applied one stage earlier.
#' 
#' ### Selection on the testcross: general combining ability
#' 
#' A maize breeder does not rank inbred lines on their own yield. A line is
#' crossed to a **tester** from the opposite pool, the testcross hybrids are grown
#' in yield trials, and the line is ranked on the mean of its testcrosses. This
#' subsection is the one with no autogamous counterpart at all: a self-pollinated
#' variety is judged, released and grown as itself, so selection there stops at
#' the per se phenotype of Step 6's first half. A hybrid parent is judged by a
#' cross it will never be sold as, which is the entire reason general and
#' specific combining ability exist as concepts. The
#' quantity being estimated is the line's **general combining ability** (GCA), the
#' average performance of its crosses expressed as a deviation from the mean of
#' all crosses (the concept is that of @sprague1942, whose paper the book does not
#' quote; the wording and @eq-alphasimr-gca below are this chapter's); what a particular cross does beyond the sum of its
#' two parents' GCAs is the specific combining ability (SCA). Reciprocal
#' recurrent selection, as this chapter uses the term, ranks the lines of each pool
#' on their testcrosses to the other pool: a line's score is its GCA against that
#' tester pool plus whatever SCA it has with the testers actually sampled. That
#' is the book's own description of the scheme (@sec-heterosis-gca-average works out what a
#' tester-based mean carries); it is not a statement of what @comstock1949
#' report, which the book cites for the name and does not report beyond the title.
#' 
#' On the full factorial of Step 4 the GCA of every A line against pool B can be
#' computed exactly, and under the model of Step 2 it has a closed form. With
#' $u_{ik}$ the line's allele indicator, $\bar G$ the factorial mean and $g^A_i$
#' the GCA of pool-A line $i$ against pool B (the notation of @sec-notation),
#' 
#' $$g^A_i \;=\; \frac{1}{n_B}\sum_{j} G_{ij} - \bar G \;=\; \sum_k \alpha^{(B)}_k\,(u_{ik} - p_{Ak}),
#' \qquad \alpha^{(B)}_k = a_k + d_k\,(1 - 2\,p_{Bk})$$ {#eq-alphasimr-gca}
#' 
#' $\alpha^{(B)}_k$ is the average effect of substituting the line's allele into a
#' *pool-B* background -- the same $\alpha = a + d(q - p)$ of Step 3, with the
#' frequency of the tester pool, not the line's own pool. That is the algebraic
#' content of the sentence "combining ability is a property of a line against a
#' tester": change the tester pool and the weights change. Its dominance part,
#' $\sum_k d_k (1 - 2 p_{Bk})(u_{ik} - p_{Ak})$, is the `gca_A` of
#' `heterosis_gca_sca()` (@sec-heterosis-gca-sca), and the interaction residual
#' of the factorial is that function's `sca`. Relative to
#' @sec-heterosis, @eq-alphasimr-hij, @eq-alphasimr-hbar and @eq-alphasimr-gca
#' are @eq-het-value, @eq-het-expected and @eq-het-gca-sca-terms written on
#' AlphaSimR's coding; but the $g^A_i$ of @eq-alphasimr-gca is the *whole* GCA of
#' line $i$ (additive plus dominance), whereas the $g^A_i$ of
#' @eq-het-gca-sca-terms is the dominance part alone, which is what `gca_A`
#' returns. The chunk asserts all three
#' identities; @tbl-alphasimr-gca gives the two variances and the correlation
#' between a line's own genetic value and its GCA.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-gca
#| tbl-cap: "GCA and SCA on the full factorial of @tbl-alphasimr-factorial. `var_GCA_A`: mean square of the exact GCA $g^A_i$ of the 30 pool-A lines against pool B; `var_SCA`: mean square of the SCA $s_{ij}$ over the 30 x 30 crosses, the $\\sigma^2_{SCA}$ of @eq-alphasimr-accuracy (both squared trait units); `cor_perse_gv_vs_GCA`: correlation over the pool-A lines of their own genetic value with $g^A_i$."
gca_true <- tapply(gv(fact)[, 1], fact@mother, mean)[A@id] - as.numeric(meanG(fact))
gca_formula <- drop(sweep(U, 2, pA) %*% (a + d * (1 - 2 * pB)))
stopifnot(isTRUE(all.equal(as.numeric(gca_true), as.numeric(gca_formula))))

hg <- heterosis_gca_sca(U, V, d)
stopifnot(isTRUE(all.equal(as.numeric(gca_true) - as.numeric(sweep(U, 2, pA) %*% a),
                           as.numeric(hg[["gca_A"]]))))

G_ij <- tapply(gv(fact)[, 1], list(fact@mother, fact@father), mean)[A@id, B@id]
sca  <- sweep(sweep(G_ij, 1, rowMeans(G_ij)), 2, colMeans(G_ij)) + mean(G_ij)
stopifnot(isTRUE(all.equal(unname(sca), unname(hg[["sca"]]))))

var_gca <- mean(gca_true^2)
var_sca <- mean(sca^2)
fmt(data.frame(var_GCA_A = var_gca, var_SCA = var_sca,
               cor_perse_gv_vs_GCA = stats::cor(gv(A)[, 1], gca_true)), 4)

#' 
#' The correlation `cor_perse_gv_vs_GCA` of @tbl-alphasimr-gca is the one to hold on to. Under @eq-alphasimr-gca, the
#' part of $g^A_i$ that the line's own genetic value does not carry is
#' the dominance part, weighted at QTL $k$ by $d_k (1 - 2 p_{Bk})$, so what sets
#' its size is how far the tester pool's frequencies sit from one half.
#' `quickHaplo()` samples every allele at frequency one half (Step 4), and here
#' the mean of $|1 - 2 p_{Bk}|$ over the `r length(pB)` QTL is
#' `r fmt(mean(abs(1 - 2 * pB)), 3)`, against a maximum of 1. The dominance part
#' of the GCA has a variance that is
#' `r fmt(100 * stats::var(as.numeric(hg[["gca_A"]])) / stats::var(as.numeric(gca_true)), 1)`
#' percent of the variance of the GCA, and a line's own genetic value correlates
#' with its GCA at `r fmt(stats::cor(gv(A)[, 1], gca_true), 3)`. In this draw, then,
#' the dominance weights are small and per se value ranks combining ability closely. That is a property of the
#' founder frequencies, not of the two halves being undifferentiated: pools with
#' no divergence but an allele-frequency spectrum away from one half have weights
#' away from zero as well. Anything that moves $p_{Bk}$ away from one half -- the
#' founders' frequency spectrum, drift in the tester pool after a split,
#' selection -- gives the testcross information the line per se does not carry.
#' Step 8 separates the two routes: its `split = 0` row has a coalescent
#' frequency spectrum and no divergence, and the sweep measures what divergence
#' adds to that.
#' 
#' ### How many testers, how many locations
#' 
#' A programme cannot cross every candidate to every line of the other pool. It
#' uses $t$ testers and $r$ locations ($t$ is the $k$ of the mating-design
#' notation of @sec-notation, renamed because $k$ indexes QTL here; it is not the
#' selfing generation of @eq-alphasimr-selfing nor a Student $t$), and the estimate of $g^A_i$ is the
#' mean phenotype of the line's $t$ testcrosses, each an entry mean over $r$
#' plots. Writing the testcross phenotype as $\bar G + g^A_i +
#' g^B_j + s_{ij} + e_{ij}$ with $e_{ij}$ the entry-mean error
#' of variance $\sigma^2_e / r$, and averaging over the $t$ testers (whose own
#' GCAs are common to every candidate and drop out of the ranking), the estimate
#' is $\hat g^A_i = g^A_i + \bar s_i + \bar e_i$, with
#' $\bar s_i$ the mean of the line's SCA with its $t$ testers and $\bar e_i$ the
#' mean error. The statistic the chunk computes is a *sample* correlation
#' between $\hat g^A_i$ and $g^A_i$ over the
#' $n_A =$ `r A@nInd` fixed candidate lines, with the $t$ testers drawn without
#' replacement from the $n_B =$ `r B@nInd` lines of pool B. To first order its
#' expectation is
#' 
#' $$\rho(t, r) \;=\; \sqrt{\frac{v_g}{v_g + v_s + v_e}}, \qquad
#' v_g = \frac{1}{n_A - 1}\sum_{i=1}^{n_A} (g^A_i)^2, \quad
#' v_s = \frac{\sigma^2_{SCA}}{t}\cdot\frac{n_A}{n_A - 1}\cdot\frac{n_B - t}{n_B - 1}, \quad
#' v_e = \frac{\sigma^2_e}{t\,r}$$ {#eq-alphasimr-accuracy}
#' 
#' where $v_g$ is the sample variance ($n_A - 1$ divisor) of the candidates'
#' true GCA, because the correlation is taken over exactly those $n_A$ points;
#' $\sigma^2_{SCA} = \frac{1}{n_A n_B}\sum_{ij} s_{ij}^2$ is the SCA
#' variance realised on this factorial (computed above; not the closed form of
#' @sec-notation for independent lines), $(n_B - t)/(n_B - 1)$ is the
#' finite-population correction for $t$ testers drawn without replacement from
#' $n_B$, $n_A/(n_A - 1)$ turns the mean of the per-candidate variances of
#' $\bar s_i$ into the expected sample variance, and $\sigma^2_e$ is `SP$varE`,
#' the plot error of Step 2. The textbook form of @eq-alphasimr-accuracy replaces $v_g$
#' by the population variance of GCA and $v_s$ by $\sigma^2_{SCA}/t$: it assumes
#' an infinite tester pool and population variances. It is kept in @tbl-alphasimr-accuracy as
#' `predicted_infinite`, so the two can be compared. Neither corrects the
#' second-order term of a sample correlation (the Jensen term); it is measured
#' directly, not assumed away, in @tbl-alphasimr-jensen,
#' and left uncorrected because it is small at this $n_A$. The simulation
#' measures the thing itself: repeated draws of the tester set and of the field
#' error, at every combination.
#' 
#' @sec-heterosis and @sec-mating hold the same expression and it is not repeated here. With
#' no plot error ($\sigma^2_e = 0$) and the population variances, @eq-alphasimr-accuracy
#' is the $\rho_k$ of @eq-het-rho-k (@sec-heterosis-step6) for heterosis, with that
#' chapter's $k$ called $t$ here, and as $n_B \to \infty$ it is the
#' least-squares $\rho$ of @tbl-mating-quantities (@sec-mating-tester), where
#' $c$ crosses per line and $r$ plots per cross play the roles of $t$ and $r$. What
#' this chapter adds is the finite-pool and sample-variance factors in $v_s$, the
#' plot error through locations, and the measured Jensen term below.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-accuracy
#| tbl-cap: "Accuracy of the testcross GCA estimate of the 30 pool-A lines of Step 4: correlation with their exact GCA against pool B (@eq-alphasimr-gca), for `testers` testers drawn without replacement from the 30 pool-B lines and `reps` locations, over 20 draws of the tester set and of the field error per cell (seeds 301 to 320). `predicted`: @eq-alphasimr-accuracy; `predicted_infinite`: the textbook form (population variances, infinite tester pool); `observed_mean`, `observed_sd`: mean and s.d. of the correlation over the draws; `z`: (`observed_mean` - `predicted`) over `observed_sd`/$\\sqrt{20}$."
grid  <- expand.grid(testers = c(1, 2, 4, 8), reps = c(1, 4))
n_acc <- 20
acc   <- sapply(seq_len(n_acc), function(rep) {
  set.seed(300 + rep)
  testers <- B[sample(B@nInd, max(grid[["testers"]]))]
  tc <- hybridCross(A, testers, crossPlan = "testcross", simParam = SP)
  apply(grid, 1, function(g) {
    ph  <- setPheno(tc, reps = g[["reps"]], simParam = SP)@pheno[, 1]
    use <- tc@father %in% testers@id[seq_len(g[["testers"]])]
    est <- tapply(ph[use], tc@mother[use], mean)[A@id]
    stats::cor(est, gca_true)
  })
})
# The prediction, for the statistic actually computed above: a sample
# correlation over the n_A FIXED candidates, with t testers drawn WITHOUT
# replacement from the n_B lines of pool B.
#   est_i = GCA_i + sbar_i + ebar_i
#   v_g : the candidates' sample variance of GCA (n_A - 1 divisor), because
#         the correlation is taken over exactly these n_A points;
#   v_s : sbar_i is the mean of t values from row i of sca, whose n_B entries
#         average zero, so Var(sbar_i) = (s2_i / t) (n_B - t) / (n_B - 1) with
#         s2_i = mean_j sca_ij^2; the column means of sca are zero too, so the
#         sample mean of sbar over candidates is exactly zero and the expected
#         sample variance is mean_i Var(sbar_i) n_A / (n_A - 1)
#         = var_sca n_A / (n_A - 1) (n_B - t) / (n_B - 1) / t;
#   v_e : varE / (t r), independent of everything else.
# To first order E[cor] = sqrt(v_g / (v_g + v_s + v_e)). The second-order
# (Jensen) term of the sample correlation is not corrected here; it is
# measured by Gaussian Monte Carlo in the chunk below the accuracy grid and
# reported there (`jensen_max`) rather than asserted in advance.
# `predicted_infinite` is the textbook form -- population variances, infinite
# tester pool -- kept so the two can be compared at this replication.
n_A <- A@nInd; n_B <- B@nInd
var_gca_n1 <- stats::var(gca_true)
fpc <- (n_B - grid[["testers"]]) / (n_B - 1)
v_s <- var_sca * (n_A / (n_A - 1)) * fpc / grid[["testers"]]
v_e <- SP$varE / (grid[["testers"]] * grid[["reps"]])
grid[["predicted"]] <- sqrt(var_gca_n1 / (var_gca_n1 + v_s + v_e))
grid[["predicted_infinite"]] <- sqrt(var_gca / (var_gca + var_sca / grid[["testers"]] + v_e))
grid[["observed_mean"]] <- rowMeans(acc)
grid[["observed_sd"]]   <- apply(acc, 1, stats::sd)
grid[["z"]] <- (grid[["observed_mean"]] - grid[["predicted"]]) /
  (grid[["observed_sd"]] / sqrt(n_acc))
fmt(grid, 3)

#' 
## -----------------------------------------------------------------------------
#| label: alphasimr-accuracy-check
# Verification echo, not a table: every value is cited in the text below.
acc_max_z <- max(abs(grid[["z"]]))
acc_max_z_infinite <- max(abs(grid[["observed_mean"]] - grid[["predicted_infinite"]]) /
                            (grid[["observed_sd"]] / sqrt(n_acc)))
acc_max_gap <- max(abs(grid[["predicted"]] - grid[["predicted_infinite"]]))
c(max_abs_z = acc_max_z, max_abs_z_infinite = acc_max_z_infinite,
  max_gap_between_predictions = acc_max_gap) |> fmt(3)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-jensen
#| tbl-cap: "Second-order (Jensen) bias of the sample correlation in each cell of @tbl-alphasimr-accuracy (row `t<testers>_r<reps>`): mean simulated correlation minus the first-order value of @eq-alphasimr-accuracy, by Gaussian Monte Carlo with 4000 replicates per cell (seed 600). `fixed_candidates`: true GCA held at the 30 candidates' values, the design of @tbl-alphasimr-accuracy; `random_x`: true GCA redrawn from $N(0, v_g)$, the textbook small-sample bias. `max_abs`: largest absolute value in the column."
# The second-order term the first-order prediction leaves out: the bias of a
# sample correlation over n_A points, by Gaussian Monte Carlo per cell,
# y = x + N(0, v_s + v_e), E[cor(x, y)] minus the first-order value. In the
# table above the candidates are the SAME 30 lines in every draw, so `jensen`
# holds x fixed at gca_true and draws only the noise -- the design actually
# measured. `jensen_random_x` redraws x ~ N(0, v_g) as well, the textbook
# small-sample bias of a correlation between two random variables, which is
# a different (larger) quantity and not the one the table is exposed to.
set.seed(600)
n_mc <- 4000
cor_cols <- function(x, y) {
  xc <- sweep(x, 2, colMeans(x)); yc <- sweep(y, 2, colMeans(y))
  colSums(xc * yc) / sqrt(colSums(xc^2) * colSums(yc^2))
}
jensen_mc <- function(x_of) vapply(seq_len(nrow(grid)), function(i) {
  x <- x_of()
  y <- x + matrix(stats::rnorm(n_A * n_mc, 0, sqrt(v_s[i] + v_e[i])), n_A)
  mean(cor_cols(x, y)) - grid[["predicted"]][i]
}, numeric(1))
jensen <- jensen_mc(function() matrix(gca_true, n_A, n_mc))
jensen_random_x <- jensen_mc(function()
  matrix(stats::rnorm(n_A * n_mc, 0, sqrt(var_gca_n1)), n_A))
names(jensen) <- names(jensen_random_x) <- paste0("t", grid[["testers"]], "_r", grid[["reps"]])
jensen_max <- max(abs(jensen))
# cells as rows: eight cells as columns would not fit the page
fmt(cbind(fixed_candidates = c(jensen, max_abs = jensen_max),
          random_x = c(jensen_random_x, max_abs = max(abs(jensen_random_x)))), 4)

#' 
#' The Jensen term for the design actually run (`fixed_candidates`, `gca_true`
#' held fixed at the `r n_A` candidates) is at most `r fmt(jensen_max, 3)` in
#' absolute value across the eight cells, i.e.
#' `r fmt(100 * jensen_max / min(grid[["predicted"]]), 1)` percent of the smallest
#' accuracy (accuracies run from `r fmt(min(grid[["predicted"]]), 2)` to
#' `r fmt(max(grid[["predicted"]]), 2)`), which is what "left uncorrected" means quantitatively; `random_x` is the
#' larger, textbook small-sample bias of a correlation between two random
#' variables, shown only for contrast and not the quantity this chapter's
#' statistic carries.
#' 
#' Accuracy rises with both, and the two arguments buy different things. More
#' locations shrink only the error term; more testers shrink the error term *and*
#' the SCA term, because a line's specific interactions with its testers average
#' out. @tbl-alphasimr-accuracy is `r n_acc` draws of the tester set and of the field error
#' per cell; the corrected and the textbook predictions differ by at most
#' `r fmt(acc_max_gap, 3)` here. `z` is the observed mean minus the corrected
#' prediction in units of the standard error of that mean over the `r n_acc`
#' draws; the largest `|z|` over the eight cells is `r fmt(acc_max_z, 2)` (it
#' would be `r fmt(acc_max_z_infinite, 2)` against the textbook form). The
#' two-sided 5 percent point of `t` with `r n_acc - 1` degrees of freedom is
#' `r fmt(stats::qt(0.975, n_acc - 1), 2)` unadjusted and
#' `r fmt(stats::qt(1 - 0.05 / (2 * nrow(grid)), n_acc - 1), 2)` for the
#' `r nrow(grid)` cells (Bonferroni, conservative: the cells share the same
#' tester draws), so at this replication the largest `|z|` is
#' `r if (acc_max_z < stats::qt(1 - 0.05 / (2 * nrow(grid)), n_acc - 1)) "within both points, and no cell is shown to differ from the prediction" else "beyond at least one of them, and at least one cell differs from the prediction"`. Each
#' `observed_sd` is across tester sets and error draws, on a fixed set of
#' candidates: what a single testcross trial's ranking is worth depends on which
#' testers were drawn, not only on how many; with one tester at one location the
#' spread across tester sets is
#' `r fmt(grid[["observed_sd"]][1] / grid[["observed_mean"]][1], 2)` of the
#' accuracy itself.
#' 
#' In the scheme of Step 8 the testers are `r rrs_cfg[["n_testers"]]` individuals
#' of the opposite pool and the trials have one location, which puts it in the
#' low-accuracy corner of @tbl-alphasimr-accuracy. A real maize programme would use elite
#' inbred testers and several locations; @hallauer2010 is the maize reference on
#' the choice of tester (cited here without a page, the book not being available
#' to check one).
#' 
#' ## Step 7 -- Two traits, and an index on phenotypes
#' 
#' `corA` makes the traits genetically correlated, which is where selection stops
#' being one-dimensional. This step uses an additive trait pair on its own founder
#' draw: index theory is written on breeding values, and the point being made
#' does not need dominance. @tbl-alphasimr-traits2 gives what the draw realised.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-traits2
#| tbl-cap: "The two additive traits of Step 7 after three rounds of random mating of 80 inbred founders (seed 202; requested genetic correlation -0.4, additive variances 1 and 4, requested $h^2$ = 0.6 and 0.1, realised values in the table). `cor_genetic`, `cor_pheno`: realised genetic and phenotypic correlation; `h2_trait1`, `h2_trait2`: realised `varG`/`varP` per trait. `G` and `P` in the code are the genetic and phenotypic covariance matrices of the traits, the $\\boldsymbol\\Sigma_G$, $\\boldsymbol\\Sigma_P$ of @sec-notation, not the relationship matrix $\\mathbf{G}$."
set.seed(202)
f2 <- quickHaplo(nInd = 80, nChr = 10, segSites = 100, inbred = TRUE)
SP2 <- SimParam$new(f2)
SP2$addTraitA(nQtlPerChr = 100, mean = c(10, 10), var = c(1, 4),
              corA = matrix(c(1, -0.4, -0.4, 1), 2, 2))
SP2$setVarE(h2 = c(0.6, 0.1))

mt <- newPop(f2, simParam = SP2)
varG_f2 <- diag(varG(mt))   # genetic variances of the founders, for the text
for (k in 1:3) mt <- randCross(mt, nCrosses = 1000, simParam = SP2)
mt <- setPheno(mt, simParam = SP2)

G <- varG(mt); P <- varP(mt); a2 <- c(1, 1)
fmt(data.frame(cor_genetic = stats::cov2cor(G)[2, 1],
               cor_pheno   = stats::cov2cor(P)[2, 1],
               h2_trait1   = as.numeric(diag(G)[1] / diag(P)[1]),
               h2_trait2   = as.numeric(diag(G)[2] / diag(P)[2])), 3)

#' 
#' The realised genetic correlation is `r fmt(stats::cov2cor(G)[2, 1], 2)` against
#' the requested `-0.4`; the phenotypic one is `r fmt(stats::cov2cor(P)[2, 1], 2)`,
#' much weaker, because the environmental components were left uncorrelated
#' (`SP$setCorE()` is where that would change). The realised heritabilities are
#' `r fmt(diag(G)[1] / diag(P)[1], 2)` and `r fmt(diag(G)[2] / diag(P)[2], 2)`, not
#' the requested 0.6 and 0.1: `setVarE(h2 = )` sets the error variance from the
#' founders' genetic variance (`r fmt(varG_f2[1], 2)` and `r fmt(varG_f2[2], 2)`
#' for the two traits), and after three rounds of random mating the genetic
#' variances of the population measured are `r fmt(diag(G)[1], 2)` and
#' `r fmt(diag(G)[2], 2)`, so the realised ratio is lower (the same loss as the
#' `varA` of Step 3). The two traits
#' differ in variance and, sharply, in heritability -- the ordinary situation.
#' 
#' **What the pipeline default is, and what this step is not.** `stage2_select()`
#' defaults to `weights = NULL`, equal weight on every trait *after* `build_ctx()`
#' standardises each criterion, so the default is the economic weights
#' $a_j = 1/\operatorname{sd}(\text{criterion}_j)$. @sec-response (section "What
#' `weights = NULL` is assuming") shows that when the criteria are multi-trait best linear unbiased prediction (BLUP)
#' predictions of the genetic values that index is the optimum, so the Smith-Hazel
#' gap is a property of an index on phenotypic records and not a defect of the
#' default. Step 7 is the phenotypic case, and it is not the default: `P` is the
#' phenotypic covariance matrix, and the weights `a2 = c(1, 1)` are on the raw trait
#' units of two traits whose genetic variances are 1 and 4, which are not
#' $1/\operatorname{sd}$ weights. The comparisons below (the trait-1 gain and the
#' loss of attainable correlation) are therefore statements about indices on
#' phenotypes, not about `weights = NULL`. Two reasons the step still belongs
#' here. First, the AlphaSimR bridge hands `stage2_select()` phenotypes:
#' `alphasimr_to_stage1()` passes `hybrid_pop@pheno`, one plot per hybrid, as the
#' trait columns, so the final subsection of Step 8 runs the default on standardised
#' testcross phenotypes -- the phenotypic-criteria case that @sec-response does not
#' treat, and whose gap to the Smith-Hazel index is not measured here. Second, the
#' step adds to @sec-response a covariance pair realised from a simulated
#' population (`corA`, `setVarE()`) rather than an invented one, and a numerical
#' check that Smith-Hazel is the maximiser, which @sec-response does not give. The
#' index functions are those of @sec-response (@tbl-alphasimr-index):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-index
#| tbl-cap: "Three two-trait indices on the population of Step 7 (two additive traits, 80 inbred founders after three rounds of random mating, seed 202; requested genetic correlation -0.4, requested $h^2$ = 0.6 and 0.1) with economic weights (1, 1) on the raw trait units. `Trait1`, `Trait2`: index weights; `gain_trait1`, `gain_trait2`: expected genetic change per unit selection intensity on the index, in trait units; `aggregate`: their sum; `cor_with_H`: correlation of the index with the aggregate genotype. `restricted`: the index holding trait 2 at zero expected gain."
cor_with_H <- function(w)
  drop(crossprod(w, G %*% a2)) /
    sqrt(drop(crossprod(w, P %*% w)) * drop(crossprod(a2, G %*% a2)))

Bw <- rbind(equal       = a2,
            smith_hazel = index_smith_hazel(P, G, a2),
            restricted  = index_restricted(P, G, a2, R = cbind(c(0, 1))))
# expected response per unit selection intensity on the index I = b'x:
# the vector of phenotypic differentials is S = i P b / sqrt(b'Pb), and the
# multi-trait breeder's equation R = G P^-1 S gives R = i G b / sqrt(b'Pb)
dG <- t(apply(Bw, 1, function(w) drop(G %*% w) / sqrt(drop(crossprod(w, P %*% w)))))
colnames(dG) <- c("gain_trait1", "gain_trait2")
idx_tab <- cbind(Bw, dG, aggregate = rowSums(dG),
                 cor_with_H = apply(Bw, 1, cor_with_H))
fmt(idx_tab)
stopifnot(isTRUE(all.equal(idx_tab[, "aggregate"],
                           idx_tab[, "cor_with_H"] * sqrt(drop(crossprod(a2, G %*% a2))),
                           check.attributes = FALSE)),
          abs(idx_tab["restricted", "gain_trait2"]) < 1e-10 * max(abs(dG)))

#' 
#' `gain_trait1` and `gain_trait2` are the expected genetic change in each trait
#' per unit of selection intensity on the index, `G b / sqrt(b' P b)`, and
#' `aggregate` is their `a`-weighted sum -- which equals `cor_with_H` times the
#' standard deviation of the aggregate genotype, asserted. Three readings, in the
#' order they matter:
#' 
#' 1. **Equal weights are not the Smith-Hazel solution.** Smith-Hazel puts
#'    `r fmt(idx_tab["smith_hazel", 2] / idx_tab["smith_hazel", 1], 2)` units of
#'    weight on trait 2 for every unit on trait 1, not 1.00. The index is
#'    $\mathbf{b} = \boldsymbol\Sigma_P^{-1}\boldsymbol\Sigma_G\mathbf{a}$
#'    (@eq-response-smith-hazel, with its conditions for $\mathbf{b} \propto \mathbf{a}$,
#'    in @sec-response; `b = P^-1 G a` here), attributed there to @smith1936 and
#'    @hazel1943, whose papers neither that chapter nor this one read. Here the
#'    heritabilities are
#'    `r fmt(diag(G)[1] / diag(P)[1], 2)` and `r fmt(diag(G)[2] / diag(P)[2], 2)`
#'    and the genetic and phenotypic correlations
#'    `r fmt(stats::cov2cor(G)[2, 1], 2)` and `r fmt(stats::cov2cor(P)[2, 1], 2)`,
#'    so `G` is nowhere near a multiple of `P`, and the table shows that `(1, 1)`
#'    is not an eigenvector of `P^-1 G`.
#' 2. **The cost on the objective is modest here; the composition of the gain is
#'    not.** Equal weighting loses
#'    `r fmt(100 * (1 - idx_tab["equal", "cor_with_H"] / idx_tab["smith_hazel", "cor_with_H"]), 1)`
#'    percent of the attainable correlation with the aggregate genotype. But it
#'    moves trait 1 by `r fmt(idx_tab["equal", "gain_trait1"], 3)` per unit
#'    intensity where Smith-Hazel moves it by
#'    `r fmt(idx_tab["smith_hazel", "gain_trait1"], 3)`,
#'    `r fmt(idx_tab["smith_hazel", "gain_trait1"] / idx_tab["equal", "gain_trait1"], 1)`
#'    times as much; both indices put most of the aggregate into trait 2, whose
#'    genetic variance is `r fmt(G[2, 2] / G[1, 1], 1)` times larger, and the weights decide how much trait 1
#'    moves at all. An index that is nearly as good on the objective can still
#'    land the gain somewhere else.
#' 3. **The restricted index holds the expected gain in trait 2 at zero**: it is
#'    `r fmt_sci(idx_tab["restricted", "gain_trait2"])` in the table, zero to
#'    rounding, at a cost of
#'    `r fmt(100 * (1 - idx_tab["restricted", "aggregate"] / idx_tab["smith_hazel", "aggregate"]), 0)`
#'    percent of the aggregate. This is a model expectation, `G b / sqrt(b' P b)`
#'    computed from this population's sample matrices (@eq-response-restricted),
#'    not a realised change in a selected sample. The form is the restricted index
#'    that @sec-response reports from @kempthorne1959, a paper that chapter did not
#'    read and whose matrix form it gives as the book's own; this chapter adds no
#'    reading of it. @sec-response also lists the four ways an equality
#'    restriction on a trait differs from the `alpha` inequality on diversity, and
#'    that restricting a group coancestry while maximising gain is the lineage of
#'    @meuwissen2020, not of this index.
#' 
#' Smith-Hazel is defined as the weight vector maximising that correlation, so the
#' claim is checkable against a numerical optimum rather than taken on faith (this
#' check is this chapter's own addition to @sec-response):
#' 
## -----------------------------------------------------------------------------
#| label: alphasimr-optim-check
opt <- stats::optim(c(1, 1), function(w) -cor_with_H(w), method = "BFGS")
d_opt <- abs(-opt$value - cor_with_H(Bw["smith_hazel", ]))
stopifnot(d_opt < 1e-6)           # BFGS tolerance, not machine precision
c(numerical = -opt$value, smith_hazel = cor_with_H(Bw["smith_hazel", ])) |> fmt(10)
cat("absolute difference:", format(d_opt, digits = 2), "(asserted < 1e-6)\n")

#' 
#' Multi-trait genomic selection in wheat, balancing yield against protein content
#' and quality, is the standing plant example [@michel2019]. In the hybrid scheme
#' below only trait 1 enters the ranking; the second trait rides along in the
#' contract so that `stage2_select()` has an index to build.
#' 
#' ## Step 8 -- The parts assembled: reciprocal recurrent selection
#' 
#' Everything above was one operation at a time. A breeding scheme is those
#' operations in a loop, and the loop for two heterotic pools is reciprocal
#' recurrent selection: each pool is improved using the *other* pool as tester.
#' Doubled-haploid lines are drawn from pool A, testcrossed to pool B (and vice
#' versa), the testcross hybrids are phenotyped, and the lines with the best mean
#' testcross performance -- the testcross-mean estimate of Step 6 -- are recombined to found
#' the next cycle's pool. Elite lines from both pools, at the end, are crossed
#' directly to produce the commercial hybrids. It is exactly the asymmetry
#' @sec-cycles argues for: selection happens on the hybrid, recycling happens
#' within pool.
#' 
#' ### Founding two pools with a real coalescent history
#' 
#' This is the one place the chapter pays for `runMacs2()` rather than
#' `quickHaplo()`. `AlphaSimR::runMacs2(..., split = )` draws founder haplotypes
#' from a population-split coalescent history: one ancestral population, then two
#' demes of equal size that stopped exchanging migrants `split` generations ago,
#' with the first half of the sampled individuals from one deme and the second
#' half from the other. That is the realistic analogue of `simulate_lines()`'s
#' Balding-Nichols draw in @sec-simulating-crosses, and between-pool divergence
#' is the entire subject of @sec-subdivided, so a stylised substitute would not do.
#' @tbl-alphasimr-founders summarises one draw at the bridge's default settings.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-founders
#| tbl-cap: "One founder draw of `alphasimr_founder_pools(rrs_cfg)` (`runMacs2()` with a population split). `pool_A`, `pool_B`: founders per pool; `markers`: segregating sites pulled by `pullSegSiteGeno()`; `heterozygous_fraction`: fraction of heterozygous genotype calls over both pools; `gd_A`, `gd_B`: gene diversity (1 - mean molecular coancestry) of each pool. Founders from `runMacs2()`; whether they are reproducible from the seed was not established (Step 1)."
fp <- alphasimr_founder_pools(rrs_cfg)
founder_geno <- pullSegSiteGeno(c(fp[["pop_A"]], fp[["pop_B"]]), simParam = fp[["SP"]])
fmt(data.frame(pool_A = fp[["pop_A"]]@nInd, pool_B = fp[["pop_B"]]@nInd,
               markers = ncol(founder_geno),
               heterozygous_fraction = mean(founder_geno == 1),
               gd_A = alphasimr_gd(fp[["pop_A"]], fp[["SP"]]),
               gd_B = alphasimr_gd(fp[["pop_B"]], fp[["SP"]])), 3)

#' 
#' Reading `alphasimr_founder_pools()` against Steps 1 and 2, it is
#' `runMacs2(nInd = , nChr = , segSites = , split = )` followed by
#' `SP$addTraitAD(nQtlPerChr = seg_sites, meanDD = `r rrs_cfg[["mean_dd"]]`,
#' varDD = `r rrs_cfg[["var_dd"]]`)` -- the same dominance model as Step 2 -- and
#' `SP$setVarE(h2 = `r rrs_cfg[["h2"]]`)`. Two things about it must be said
#' before any number is read. **The founders are outbred**: `runMacs2()` is called
#' without `inbred = TRUE`, so each pool is a sample of a random-mating
#' population, heterozygous at the fraction of sites given in @tbl-alphasimr-founders
#' (`heterozygous_fraction`), as an
#' open-pollinated maize population would be; the inbred lines of the scheme are
#' made from them by `makeDH()` inside each cycle. And there is no separate
#' marker panel: every one of the `r rrs_cfg[["seg_sites"]]` segregating sites per
#' chromosome is a QTL, so the sites that carry the trait are the ones
#' `pullSegSiteGeno()` reads for `X`, `f` and `fL` throughout. `alphasimr_gd()`
#' is `1 - mean(f)`, the exact definition `gene_diversity()` uses, computed from
#' that pull, so the two pools are already on the same scale as every diversity
#' number in the rest of the book.
#' 
#' These founders come from `runMacs2()`, and Step 1 did not establish whether
#' they repeat from the seed (it measured one pair of `runMacs()` calls and never
#' called `runMacs2()`). Everything below is computed from them, so the chapter
#' does not rely on the founders repeating: it replicates every Step 8
#' measurement over independent founder draws, reports the spread, and writes any
#' verdict that rests on a `t` near its critical value as the render's.
#' 
#' **What `split` does.** The bridge's default is `split_gen = `r rrs_cfg[["split_gen"]]``.
#' The sweep of @tbl-alphasimr-split draws `r n_split_draws` independent founder sets at each of four split
#' times and measures three things on each: the partition of @caballero2002
#' over the two pools (`ct_partition()`, the general form of `gd_partition()`).
#' The partition is the one defined in @eq-gd-partition of @sec-subdivided and is
#' not re-derived here: with the two pools as the subpopulations,
#' $GD_T = 1 - \bar f$ is the total gene diversity ($\bar f$ the census-weighted mean molecular
#' coancestry over all pairs of the founder individuals of the two pools, the
#' notation of @sec-ct-notation, computed by `ct_partition()` from the
#' individual genotypes pulled by `pullSegSiteGeno()`; no hybrid enters) and
#' $GD_T = GD_{WI} + GD_{BI} + GD_{BS}$, where $GD_{WI}$ is the component within
#' individuals (half the observed heterozygosity of a plant), $GD_{BI}$ the
#' component between individuals within a pool, and $GD_{BS}$ the component
#' between the two pools (@tbl-gd-partition). $F_{ST} = GD_{BS} / GD_T$ is the
#' identity of @eq-ratio-identities, with $F_{ST}$ the statistic of
#' @eq-f-stats and not the one referenced to the between-population coancestry
#' that @sec-subdivided also records. The share of expected heterosis that the divergence
#' term carries (`heterosis_partition()`, @sec-heterosis), and -- the Step 6
#' question with divergence -- how much of a DH line's exact GCA against the
#' other pool's DH lines its own genetic value can see. For that last one,
#' `r n_dh_gca` DH lines are drawn from every founder, the full factorial between
#' the two DH sets is made, and the GCA of each pool-A line is split into its
#' additive and dominance parts with `heterosis_gca_sca()`; the identity behind
#' that split was asserted in Step 6. The chunk also records, per draw, an
#' ascertainment bookkeeping that the reading of `GD_T` will need: the fraction
#' of sites monomorphic within each pool, the fraction fixed for opposite
#' alleles in the two pools, and the part of `GD_T` those sites carry.
#' @tbl-alphasimr-contrast then tests the two GCA statistics between the
#' extreme split times.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-split
#| tbl-cap: !expr cap_split
#| tbl-subcap:
#|   - "Divergence, mean over draws"
#|   - "Divergence, between-draw s.d."
#|   - "Ascertainment, mean over draws"
#|   - "Combining ability, mean over draws"
#|   - "Combining ability, between-draw s.d."
split_draw <- function(split, seed) {
  cfg <- utils::modifyList(rrs_cfg, list(split_gen = split, seed = seed))
  fp_s <- alphasimr_founder_pools(cfg)
  SP_s <- fp_s[["SP"]]
  pool <- rep(c("A", "B"), c(cfg[["n_pool_A"]], cfg[["n_pool_B"]]))
  geno <- pullSegSiteGeno(c(fp_s[["pop_A"]], fp_s[["pop_B"]]), simParam = SP_s)
  ct   <- ct_partition(geno, pool)
  pA_s <- colMeans(geno[pool == "A", ]) / 2
  pB_s <- colMeans(geno[pool == "B", ]) / 2
  d_s  <- SP_s$traits[[1]]@domEff
  a_s  <- SP_s$traits[[1]]@addEff
  hp   <- heterosis_partition(pA_s, pB_s, d_s)
  # Ascertainment: runMacs2() returns sites that segregate in the POOLED
  # sample, so a site fixed for different alleles in the two pools is kept
  # and, with equal pool sizes, sits at pooled frequency 1/2 -- the maximum
  # of 2 p q. GD_T = mean 2 pbar qbar exactly (census weights, equal sizes),
  # so it splits into the part those fixed differences carry and the rest.
  mono_A <- pA_s %in% c(0, 1)
  mono_B <- pB_s %in% c(0, 1)
  fixed  <- mono_A & mono_B & (pA_s != pB_s)
  pbar_s <- (pA_s + pB_s) / 2
  h_s    <- 2 * pbar_s * (1 - pbar_s)
  stopifnot(isTRUE(all.equal(ct[["diversity"]][["GD_T"]],
                             ct[["diversity"]][["GD_WI"]] + ct[["diversity"]][["GD_BI"]] +
                               ct[["diversity"]][["GD_BS"]])),
            isTRUE(all.equal(ct[["diversity"]][["GD_T"]], mean(h_s))),
            isTRUE(all.equal(ct[["global"]][["F_ST"]],
                             ct[["diversity"]][["GD_BS"]] / ct[["diversity"]][["GD_T"]])))
  set.seed(seed)
  dh_A <- makeDH(fp_s[["pop_A"]], nDH = n_dh_gca, simParam = SP_s)
  dh_B <- makeDH(fp_s[["pop_B"]], nDH = n_dh_gca, simParam = SP_s)
  hyb  <- hybridCross(dh_A, dh_B, crossPlan = "testcross", simParam = SP_s)
  gca  <- tapply(gv(hyb)[, 1], hyb@mother, mean)[dh_A@id] - as.numeric(meanG(hyb))[1]
  U_s  <- pullQtlGeno(dh_A, simParam = SP_s) / 2
  hg   <- heterosis_gca_sca(U_s, pullQtlGeno(dh_B, simParam = SP_s) / 2, d_s)
  # GCA = additive part + dominance part (the Step 6 identity), so its
  # variance is var(add) + var(dom) + 2 cov(add, dom): three terms, not two.
  gca_add <- as.numeric(sweep(U_s, 2, colMeans(U_s)) %*% a_s)
  gca_dom <- as.numeric(hg[["gca_A"]])
  stopifnot(isTRUE(all.equal(as.numeric(gca), gca_add + gca_dom)))
  data.frame(split = split, seed = seed,
             F_ST  = ct[["global"]][["F_ST"]],
             GD_T  = ct[["diversity"]][["GD_T"]],
             GD_BS = ct[["diversity"]][["GD_BS"]],
             mono_A = mean(mono_A), mono_B = mean(mono_B),
             fixed_diff = mean(fixed),
             GD_T_fixed = sum(h_s[fixed]) / length(h_s),
             GD_T_other = sum(h_s[!fixed]) / length(h_s),
             maf_pooled = mean(pmin(pbar_s, 1 - pbar_s)),
             heterosis_divergence_share = hp[["divergence"]] / hp[["total"]],
             GCA_var = stats::var(gca),
             GCA_var_add = stats::var(gca_add),
             GCA_var_dom = stats::var(gca_dom),
             GCA_cov2 = 2 * stats::cov(gca_add, gca_dom),
             GCA_dominance_share = stats::var(gca_dom) / stats::var(gca),
             cor_perse_GCA = stats::cor(gv(dh_A)[, 1], gca))
}
splits <- c(0, 10, 100, 1000)
sw <- do.call(rbind, lapply(splits, function(s)
  do.call(rbind, lapply(seq_len(n_split_draws), function(r)
    split_draw(s, seed = 100 * s + r)))))
sw_mean <- aggregate(sw[, -(1:2)], by = list(split = sw[["split"]]), FUN = mean)
sw_sd   <- aggregate(sw[, -(1:2)], by = list(split = sw[["split"]]), FUN = stats::sd)
rownames(sw_mean) <- rownames(sw_sd) <- paste0("split_", sw_mean[["split"]])
# the split time is carried by the row names
cols_div <- c("F_ST", "GD_T", "GD_BS", "heterosis_divergence_share")
cols_asc <- c("mono_A", "mono_B", "fixed_diff", "GD_T_fixed",
              "GD_T_other", "maf_pooled")
cols_gca <- c("GCA_var", "GCA_var_add", "GCA_var_dom", "GCA_cov2",
              "GCA_dominance_share", "cor_perse_GCA")
fmt(sw_mean[, cols_div], 3)
fmt(sw_sd[, cols_div], 3)
fmt(sw_mean[, cols_asc], 3)
fmt(sw_mean[, cols_gca], 3)
fmt(sw_sd[, cols_gca], 3)

#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-contrast
#| tbl-cap: !expr cap_contrast
# the contrast between the two extreme split times, for the two GCA columns
contrast <- function(m) {
  x <- sw[[m]][sw[["split"]] == max(splits)]
  y <- sw[[m]][sw[["split"]] == min(splits)]
  se <- sqrt(stats::var(x) / length(x) + stats::var(y) / length(y))
  c(at_split_max = mean(x), at_split_0 = mean(y), difference = mean(x) - mean(y),
    se = se, t = (mean(x) - mean(y)) / se)
}
ctr <- rbind(GCA_dominance_share = contrast("GCA_dominance_share"),
             cor_perse_GCA       = contrast("cor_perse_GCA"))
fmt(ctr, 3)

#' 
## -----------------------------------------------------------------------------
#| echo: false
# prose helpers: the ratio var(dom)/var(GCA) with only one part moved from
# its split-0 to its split-1000 value (covariance held at split 0), and the
# covariance term in standard errors of zero
gca_only <- function(move) {
  g0 <- sw_mean["split_0", ]; g1 <- sw_mean["split_1000", ]
  add <- if (move == "add") g1[["GCA_var_add"]] else g0[["GCA_var_add"]]
  dom <- if (move == "dom") g1[["GCA_var_dom"]] else g0[["GCA_var_dom"]]
  dom / (add + dom + g0[["GCA_cov2"]])
}
cov_frac <- abs(sw_mean[["GCA_cov2"]]) / sw_mean[["GCA_var"]]      # |2 cov| as a share of var(GCA)
cov_se   <- abs(sw_mean[["GCA_cov2"]]) / (sw_sd[["GCA_cov2"]] / sqrt(n_split_draws))
names(cov_frac) <- names(cov_se) <- rownames(sw_mean)
cov_se_max   <- max(cov_se)
cov_t_crit   <- stats::qt(0.975, df = n_split_draws - 1)   # two-sided 5% point
cov_sig      <- names(cov_se)[cov_se > cov_t_crit]          # splits where 2 cov differs from 0
# multiplicity of the sweep: the two contrasts of tbl-alphasimr-contrast, the
# GCA_var_dom contrast and the covariance term at each split are the tested statistics
t_sweep <- c(ctr[, "t"], GCA_var_dom = contrast("GCA_var_dom")[["t"]], cov_se)
n_tests_sweep <- length(t_sweep)
t_bonf_sweep  <- stats::qt(1 - 0.05 / (2 * n_tests_sweep), df = n_split_draws - 1)
g0 <- sw_mean["split_0", ]
cov_dom_0    <- abs(g0[["GCA_cov2"]]) / g0[["GCA_var_dom"]] # |2 cov| relative to var(dom), split 0
share_cov_0   <- g0[["GCA_var_dom"]] / g0[["GCA_var"]]       # ratio of the split-0 means
share_nocov_0 <- g0[["GCA_var_dom"]] / (g0[["GCA_var_add"]] + g0[["GCA_var_dom"]])
dom_change   <- sw_mean["split_1000", "GCA_var_dom"] - sw_mean["split_0", "GCA_var_dom"]

#' 
#' Read @tbl-alphasimr-split-1 and @tbl-alphasimr-split-2 together: the first is the mean over the
#' `r n_split_draws` draws, the second their standard deviation. What was
#' measured: `F_ST` rises from `r fmt(sw_mean["split_0", "F_ST"], 3)` at
#' `split = 0` to `r fmt(sw_mean["split_1000", "F_ST"], 3)` at `split = 1000`,
#' and `GD_BS` from `r fmt(sw_mean["split_0", "GD_BS"], 3)` to
#' `r fmt(sw_mean["split_1000", "GD_BS"], 3)`, each step many standard
#' deviations wide; the divergence share of expected heterosis rises from
#' `r fmt(sw_mean["split_0", "heterosis_divergence_share"], 3)` to
#' `r fmt(sw_mean["split_1000", "heterosis_divergence_share"], 3)`. `GD_T` does
#' not stay flat: it is `r fmt(sw_mean["split_0", "GD_T"], 3)` at `split = 0`,
#' `r fmt(sw_mean["split_100", "GD_T"], 3)` at `split = 100` and
#' `r fmt(sw_mean["split_1000", "GD_T"], 3)` at `split = 1000`, and the rise
#' from `split = 100` to `split = 1000`,
#' `r fmt(sw_mean["split_1000", "GD_T"] - sw_mean["split_100", "GD_T"], 3)`, is
#' `r fmt((sw_mean["split_1000", "GD_T"] - sw_mean["split_100", "GD_T"]) / sqrt((sw_sd["split_1000", "GD_T"]^2 + sw_sd["split_100", "GD_T"]^2) / n_split_draws), 0)`
#' standard errors at this replication. @tbl-alphasimr-split-3 is the bookkeeping
#' behind that rise. Across the same range the fraction of sites monomorphic
#' within pool A goes from `r fmt(sw_mean["split_0", "mono_A"], 3)` to
#' `r fmt(sw_mean["split_1000", "mono_A"], 3)` (pool B:
#' `r fmt(sw_mean["split_0", "mono_B"], 3)` to
#' `r fmt(sw_mean["split_1000", "mono_B"], 3)`), the fraction of sites fixed for
#' opposite alleles in the two pools from
#' `r fmt(sw_mean["split_0", "fixed_diff"], 3)` to
#' `r fmt(sw_mean["split_1000", "fixed_diff"], 3)`, the part of `GD_T` those
#' sites carry (`GD_T_fixed`) from `r fmt(sw_mean["split_0", "GD_T_fixed"], 3)`
#' to `r fmt(sw_mean["split_1000", "GD_T_fixed"], 3)`, and the part carried by
#' every other site (`GD_T_other`) falls from
#' `r fmt(sw_mean["split_0", "GD_T_other"], 3)` to
#' `r fmt(sw_mean["split_1000", "GD_T_other"], 3)`.
#' 
#' What is inferred from @tbl-alphasimr-split-1 to @tbl-alphasimr-split-3: `runMacs2()` returns the sites that
#' segregate in the *pooled* sample of the two demes, so a site fixed for
#' opposite alleles in the two pools is kept and, with equal pool sizes, sits at
#' pooled frequency one half -- the maximum of $2\bar p \bar q$, which is exactly
#' what `GD_T` averages over sites (asserted in the chunk). The rise in `GD_T`
#' therefore comes entirely from sites fixed for opposite alleles, an
#' ascertainment effect of how the founder sites are sampled, while diversity at
#' every other site falls with divergence. At those other sites the direction is
#' the one @sec-heterosis gives for drift: diversity within pools falls, the
#' between-pool component rises, and the total does not rise (`GD_T_other` falls
#' in @tbl-alphasimr-split-3). How much of `GD_T`
#' a marker panel shows under divergence therefore depends on how its sites were
#' ascertained, which is a property of the panel and not of the pools.
#' 
#' @tbl-alphasimr-split-4 and @tbl-alphasimr-split-5 are the combining-ability side, mean and standard
#' deviation, and @tbl-alphasimr-contrast is the contrast between the two extreme split times,
#' unpaired because the draws are independent. GCA is the sum of its additive and
#' dominance parts (asserted in the chunk), so its variance is
#' $\mathrm{var}(\mathrm{add}) + \mathrm{var}(\mathrm{dom}) + 2\,\mathrm{cov}(\mathrm{add}, \mathrm{dom})$,
#' three terms. What was measured, from `split = 0` to `split = 1000`: `GCA_var`
#' goes from `r fmt(sw_mean["split_0", "GCA_var"], 3)` to
#' `r fmt(sw_mean["split_1000", "GCA_var"], 3)`, `GCA_var_add` from
#' `r fmt(sw_mean["split_0", "GCA_var_add"], 3)` to
#' `r fmt(sw_mean["split_1000", "GCA_var_add"], 3)`, `GCA_var_dom` from
#' `r fmt(sw_mean["split_0", "GCA_var_dom"], 3)` to
#' `r fmt(sw_mean["split_1000", "GCA_var_dom"], 3)`, and `GCA_cov2`
#' ($2\,\mathrm{cov}$) from `r fmt(sw_mean["split_0", "GCA_cov2"], 3)` to
#' `r fmt(sw_mean["split_1000", "GCA_cov2"], 3)`, the last with between-draw
#' standard deviations of `r fmt(sw_sd["split_0", "GCA_cov2"], 3)` and
#' `r fmt(sw_sd["split_1000", "GCA_cov2"], 3)`; its largest $|\text{mean}|/\text{s.e.}$
#' across splits is `r fmt(cov_se_max, 2)`, against the two-sided 5 percent point
#' $t_{0.975,\,`r n_split_draws - 1`} =$ `r fmt(cov_t_crit, 2)`. The ratio
#' `GCA_dominance_share` $= \mathrm{var}(\mathrm{dom}) / \mathrm{var}(\mathrm{GCA})$
#' rises from `r fmt(ctr["GCA_dominance_share", "at_split_0"], 3)` to
#' `r fmt(ctr["GCA_dominance_share", "at_split_max"], 3)`
#' (`t = `r fmt(ctr["GCA_dominance_share", "t"], 1)``). Which part drives it:
#' holding the dominance part at its `split = 0` value and moving only the
#' additive part to its `split = 1000` value gives a ratio of
#' `r fmt(gca_only("add"), 3)`; holding the additive part and moving only the
#' dominance part gives `r fmt(gca_only("dom"), 3)`. And the per
#' se-versus-GCA correlation falls from `r fmt(ctr["cor_perse_GCA", "at_split_0"], 3)`
#' to `r fmt(ctr["cor_perse_GCA", "at_split_max"], 3)`
#' (`t = `r fmt(ctr["cor_perse_GCA", "t"], 1)``). Both correlations are below the
#' `r fmt(stats::cor(gv(A)[, 1], gca_true), 3)` of Step 6's undifferentiated
#' halves, but that comparison crosses a change of founders, trait draw and
#' line number, so the within-sweep contrast is the one that isolates `split`.
#' The `split = 0` row is the frequency-spectrum route of Step 6 without
#' divergence: its pooled minor-allele frequency is
#' `r fmt(sw_mean["split_0", "maf_pooled"], 3)`, so the mean of
#' $|1 - 2\bar p_k|$ over sites, which equals $1 - 2\,$`maf_pooled` exactly, is
#' `r fmt(1 - 2 * sw_mean["split_0", "maf_pooled"], 3)`, against
#' `r fmt(mean(abs(1 - pA - pB)), 3)` for Step 6's two halves.
#' 
#' **Multiplicity of the sweep.** The statistics decided against a critical value in this
#' section are the two contrasts of @tbl-alphasimr-contrast, the `GCA_var_dom` contrast
#' and the covariance term at each of the `r length(cov_se)` split times:
#' `r n_tests_sweep` tests, a number fixed by this paragraph and not by the data. The
#' point $t_{0.975,\,`r n_split_draws - 1`} =$ `r fmt(cov_t_crit, 2)` used above is
#' unadjusted for them: it is the permissive end for a verdict of *a difference*
#' (it ignores the number of tests) and the strict end for a verdict of "not
#' distinguishable from zero". The Bonferroni point for
#' `r n_tests_sweep` tests is `r fmt(t_bonf_sweep, 2)`. Against it, in this render,
#' `r sum(abs(t_sweep) > t_bonf_sweep)` of the `r n_tests_sweep` statistics are beyond it
#' (`r sum(abs(t_sweep) > cov_t_crit)` are beyond the unadjusted point); the tests
#' are not independent (the statistics are computed on the same draws and the
#' covariance term enters the ratio); Bonferroni holds the family-wise level at or
#' below 5 percent whatever the dependence, and is not its exact value. The `F_ST`, `GD_BS` and
#' `GD_T` movements, the ascertainment bookkeeping of @tbl-alphasimr-split-3 and the
#' one-part-at-a-time decomposition (`gca_only()`) are descriptive: no test is
#' attached to them and none is adjusted, and they are exploratory.
#' 
#' What is inferred: in this render the
#' `r if (gca_only("add") >= gca_only("dom")) "fall of the *additive* part of the GCA variance accounts for more of the rise in the ratio than the growth of the dominance part" else "growth of the dominance part of the GCA variance accounts for more of the rise in the ratio than the fall of the additive part"`;
#' an additive part that falls with divergence does so because the sites that fix
#' within a pool stop contributing to it (at linkage equilibrium its variance
#' over DH lines is $\sum_k a_k^2\, p_{Ak} q_{Ak}$), so the ratio can rise without
#' the dominance part growing at all. The ratio is a partition of $\mathrm{var}(\mathrm{GCA})$
#' only insofar as the covariance term is negligible. In this render that term
#' is `r if (length(cov_sig) == 0) "within the two-sided 5 percent point at every split" else paste0("beyond the two-sided 5 percent point at ", paste(sub("split_", "split = ", cov_sig), collapse = ", "))`;
#' with `r n_split_draws` draws, a term within that point is not shown to differ
#' from zero, which is not a bound on its size. If the founders differ between the executions that
#' produce the HTML and the PDF (see "Founders from MaCS"), a term whose $|t|$ lies
#' near the unadjusted point (`r fmt(cov_t_crit, 2)`) and below the Bonferroni
#' point (`r fmt(t_bonf_sweep, 2)`) could fall on either side in the two formats;
#' no inference drawn in this paragraph depends on which side it falls, but the
#' render's own wording above and the counts in it do. In magnitude, at `split = 0`
#' $|2\,\mathrm{cov}|$ is `r fmt(cov_dom_0, 2)` times `GCA_var_dom`, and
#' dropping it changes the ratio of the `split = 0` means from
#' `r fmt(share_cov_0, 3)` to
#' $\mathrm{var}(\mathrm{dom}) / [\mathrm{var}(\mathrm{add}) + \mathrm{var}(\mathrm{dom})] =$
#' `r fmt(share_nocov_0, 3)`. "Share" is used only in that qualified sense, and
#' each founder draw calls `runMacs2()`, whose repeatability from `set.seed()` was
#' not established (Step 1), so that verdict is this render's and may change with
#' the next.
#' Whether the dominance part itself grows with divergence is a separate
#' question, and the algebra does not fix its sign: at linkage equilibrium its
#' variance over DH lines is $\sum_k d_k^2 (1 - 2 p_{Bk})^2\, p_{Ak} q_{Ak}$, and
#' divergence pushes the weight $(1 - 2 p_{Bk})^2$ up at the same loci where it
#' pushes $p_{Ak} q_{Ak}$ down. Measured, `GCA_var_dom` changes by
#' `r fmt(dom_change, 3)` from `split = 0` to `split = 1000`
#' (`t = `r fmt(contrast("GCA_var_dom")[["t"]], 1)``, against the unadjusted
#' point $t_{0.975,\,`r n_split_draws - 1`} =$ `r fmt(cov_t_crit, 2)`), so in this
#' render that change
#' `r if (abs(contrast("GCA_var_dom")[["t"]]) > cov_t_crit) "is beyond that point" else "is not distinguishable from zero"`;
#' being computed from `runMacs2()` founders over `r n_split_draws` draws, it is this
#' render's verdict and not a property of the scheme. The ratio's own contrast is
#' `r if (abs(ctr["GCA_dominance_share", "t"]) > cov_t_crit) "beyond" else "within"`
#' the same point in this render; where it is beyond it and positive, what it
#' supports is that a larger share, in the qualified sense above, of
#' $\mathrm{var}(\mathrm{GCA})$ is invisible to a line's own genetic value after
#' the split, through whichever part the decomposition above identifies, and
#' nothing here separates how much of the between-draw spread is
#' the trait drawn with each founder set and how much is the DH sampling. The
#' limit of the inference is the scale: `r rrs_cfg[["n_pool_A"]]` individuals per
#' pool, `r rrs_cfg[["n_chr"]] * rrs_cfg[["seg_sites"]]` sites,
#' `r n_split_draws` draws per split, and a `split` in coalescent generations that
#' is not calibrated to any named heterotic-pool pair. No other scale was
#' simulated, so whether any of these directions holds at another one is not
#' claimed.
#' 
#' ### One cycle
#' 
#' @tbl-alphasimr-cycle1 is one cycle run on the founder pools above.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-cycle1
#| tbl-cap: !expr cap_cycle1
set.seed(11)
cy1 <- alphasimr_rrs_cycle(fp[["pop_A"]], fp[["pop_B"]], fp[["SP"]], rrs_cfg)
fmt(cy1[["summary"]], 4)

#' 
#' `alphasimr_rrs_cycle()` runs the same six steps for each pool, symmetrically
#' (pool A tested on B, pool B tested on A), and every one is a primitive from
#' above:
#' 
#' 1. **Double haploids** (Step 5). `makeDH()` draws `r rrs_cfg[["n_dh"]]` fully
#'    homozygous lines from *each* individual in the current pool -- at this
#'    chapter's Step 8 configuration, `r rrs_cfg[["n_pool_A"]]` parents x `r rrs_cfg[["n_dh"]]` DH each =
#'    `r rrs_cfg[["n_pool_A"]] * rrs_cfg[["n_dh"]]` DH lines per pool, per cycle.
#'    Because the pool is outbred, the DH lines from one parent differ from each
#'    other: this is the lottery of Step 4, drawn one generation earlier than in
#'    a line programme.
#' 2. **Pick reciprocal testers.** The first `r rrs_cfg[["n_testers"]]` individuals
#'    of the *current* opposite pool are used as testers -- an arbitrary slice by
#'    index, not a random or merit-based draw, outbred individuals rather than
#'    inbred lines, and a different set each cycle because step 6 recreates the
#'    pool. This is the RRS-defining move: a line's value is judged by its cross onto the other
#'    heterotic pool, not by itself.
#' 3. **Testcross and phenotype** (Step 6). `hybridCross()` forms the full
#'    factorial between every DH line and every tester --
#'    `r rrs_cfg[["n_pool_A"]] * rrs_cfg[["n_dh"]]` DH x `r rrs_cfg[["n_testers"]]`
#'    testers = `r rrs_cfg[["n_pool_A"]] * rrs_cfg[["n_dh"]] * rrs_cfg[["n_testers"]]`
#'    testcross hybrids per pool -- and `setPheno()` adds phenotyping error sized
#'    to the heritability set by `SP$setVarE(h2 = )`, at one location.
#' 4. **GCA estimate** (Step 6). Testcross phenotypes are grouped by DH-line
#'    parent (`tapply(pheno[, 1], mother, mean)`) and averaged across the
#'    `r rrs_cfg[["n_testers"]]` testers each line was crossed to. This is the
#'    estimator of Step 6, but the quantity it estimates is the line's value
#'    against outbred testers from the current pool, not the GCA of
#'    @eq-alphasimr-gca, which is defined against inbred pool-B lines. Only trait 1 is
#'    used for this ranking even though this chapter's config simulates
#'    `r rrs_cfg[["n_traits"]]` traits per line; the second trait rides along in
#'    `X`/`hybrids` but plays no role in selection here. Step 7 is what it would
#'    take to use both.
#' 5. **Keep the elites** (Step 6). The `r rrs_cfg[["n_sel"]]` DH lines per pool
#'    with the highest mean testcross phenotype are kept as `elite_A`/`elite_B`.
#' 6. **Recombine** (Step 5). `randCross()` random-mates the elites back up to
#'    `r rrs_cfg[["n_pool_A"]]` individuals, founding the next cycle's pool A
#'    (symmetrically for B).
#' 
#' `elite_A`/`elite_B` are what step 6 mates -- and, in the *last* cycle, what
#' the final commercial cross uses instead of being recombined again. The cycle's
#' `summary` mixes two different populations on purpose: `mean_tc_A`/`mean_tc_B`
#' average over *all* DH lines tested that cycle (the population's testcross
#' performance before selection), while `gd_A`/`gd_B` are gene diversity of only
#' the `r rrs_cfg[["n_sel"]]` surviving elites (the population after selection).
#' That asymmetry is exactly what @fig-alphasimr-cycles plots -- response measured
#' pre-selection, diversity measured post-selection.
#' 
#' ### The trajectory across cycles, replicated, against a paired control
#' 
#' `alphasimr_pipeline()` runs `alphasimr_rrs_cycle()` in a loop for
#' `r rrs_cfg[["n_cycles"]]` cycles, carrying `pop_A`/`pop_B` forward from one
#' cycle's output to the next's input. Only the *last* cycle's
#' `elite_A`/`elite_B` go on to found the commercial hybrid pool; every earlier
#' cycle's elites are spent entirely on `randCross()`ing the next cycle's pool.
#' 
#' One run of that loop is an anecdote, and it would be an anecdote about one
#' founder draw. The loop is written out here instead, so that three things can
#' be added to it: a **paired no-selection control** (`random_elite = TRUE`,
#' which draws the elites at random and leaves every other operation -- the DH
#' lines, the testcrosses, the recombination -- the same operations, so the two
#' arms differ by selection in expectation; because the random pick calls
#' `sample()` and the selected pick does not, the arms' random streams part at
#' the cycle-1 elite pick, and from there on their Mendelian sampling and
#' phenotyping errors are independent realisations, which the paired `t` below
#' counts as noise), the between-pool
#' partition of the *recombined* pools each cycle, and the genetic value of the
#' actual product, the elite factorial.
#' 
## -----------------------------------------------------------------------------
#| label: alphasimr-run-rrs
run_rrs <- function(fp, cfg, random_elite = FALSE, seed = 1) {
  set.seed(seed)
  SP_r  <- fp[["SP"]]
  pop_A <- fp[["pop_A"]]; pop_B <- fp[["pop_B"]]
  pool  <- rep(c("A", "B"), c(cfg[["n_pool_A"]], cfg[["n_pool_B"]]))
  pools_row <- function(pop_A, pop_B) {
    ct <- ct_partition(pullSegSiteGeno(c(pop_A, pop_B), simParam = SP_r), pool)
    data.frame(gd_pool_A = alphasimr_gd(pop_A, SP_r),
               gd_pool_B = alphasimr_gd(pop_B, SP_r),
               GD_BS = ct[["diversity"]][["GD_BS"]],
               F_ST  = ct[["global"]][["F_ST"]])
  }
  rows <- list(cbind(cycle = 0, mean_tc_A = NA, mean_tc_B = NA, gd_A = NA, gd_B = NA,
                     hybrid_meanG = NA, pools_row(pop_A, pop_B)))
  for (i in seq_len(cfg[["n_cycles"]])) {
    cy <- alphasimr_rrs_cycle(pop_A, pop_B, SP_r, cfg, random_elite = random_elite)
    pop_A <- cy[["pop_A"]]; pop_B <- cy[["pop_B"]]
    prod  <- hybridCross(cy[["elite_A"]], cy[["elite_B"]], crossPlan = "testcross",
                         simParam = SP_r)
    rows[[i + 1]] <- cbind(cycle = i, cy[["summary"]],
                           hybrid_meanG = as.numeric(meanG(prod))[1],   # trait 1
                           pools_row(pop_A, pop_B))
  }
  do.call(rbind, rows)
}

arms <- lapply(seq_len(n_rep), function(s) {
  fp_s <- alphasimr_founder_pools(utils::modifyList(rrs_cfg, list(seed = s)))
  list(sel = run_rrs(fp_s, rrs_cfg, random_elite = FALSE, seed = s),
       ctl = run_rrs(fp_s, rrs_cfg, random_elite = TRUE,  seed = s))
})
# pairing check: cycle 1 is identical between arms up to the elite pick
stopifnot(all(vapply(arms, function(a)
  isTRUE(all.equal(a[["sel"]][c("mean_tc_A", "mean_tc_B")][2, ],
                   a[["ctl"]][c("mean_tc_A", "mean_tc_B")][2, ])), logical(1))))

#' 
#' `r n_rep` founder draws; each drawn once and both arms branched off it, with
#' the same seed set before each arm so that cycle 1's DH lines and testcross
#' phenotypes are identical between arms (asserted) and the two first diverge at
#' the selection step. The first replicate's selected arm, cycle by cycle
#' (@tbl-alphasimr-rep1):
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-rep1
#| tbl-cap: !expr cap_rep1
#| tbl-subcap:
#|   - "Response and elite lines"
#|   - "Recombined pools"
fmt(arms[[1]][["sel"]][, c("cycle", "mean_tc_A", "mean_tc_B", "hybrid_meanG", "gd_A", "gd_B")], 3)
fmt(arms[[1]][["sel"]][, c("cycle", "gd_pool_A", "gd_pool_B", "GD_BS", "F_ST")], 3)

#' 
#' `gd_pool_A`/`gd_pool_B` are the gene diversity of the recombined pools that
#' enter the next cycle, on the same `1 - mean(f)` scale as the elites' `gd_A`/
#' `gd_B`; `GD_BS` and `F_ST` are the between-pool components of those two pools;
#' `hybrid_meanG` is the mean genetic value of the `r rrs_cfg[["n_sel"]]` x
#' `r rrs_cfg[["n_sel"]]` elite factorial, the product the cycle would sell. All
#' of them, over all replicates, at the last cycle, selected minus control, are in
#' @tbl-alphasimr-paired; @tbl-alphasimr-loss gives each pool's relative loss of
#' gene diversity:
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-paired
#| tbl-cap: !expr cap_paired
#| tbl-subcap:
#|   - "Paired contrast per statistic"
#|   - "What pooling the two pools buys"
last <- rrs_cfg[["n_cycles"]] + 1
# The two pools are exchangeable by design, so their mean is a legitimate
# pooled statistic; how much noise it removes is measured below (pool_tab).
arms <- lapply(arms, function(a) lapply(a, function(x) {
  x[["gd_elite_mean"]] <- (x[["gd_A"]] + x[["gd_B"]]) / 2
  x[["gd_pool_mean"]]  <- (x[["gd_pool_A"]] + x[["gd_pool_B"]]) / 2
  x
}))
arm_last <- function(arm, m) vapply(arms, function(a) a[[arm]][[m]][last], numeric(1))
diffs    <- function(m) arm_last("sel", m) - arm_last("ctl", m)   # one per founder draw
paired <- function(m) {
  dd <- diffs(m)
  c(selected = mean(arm_last("sel", m)), control = mean(arm_last("ctl", m)),
    diff_mean = mean(dd), diff_sd = stats::sd(dd),
    t = mean(dd) / (stats::sd(dd) / sqrt(length(dd))))
}
rep_tab  <- t(sapply(metrics, paired))
t_paired <- rep_tab[, "t"]                       # named: t_paired[["gd_elite_mean"]]
t_crit   <- stats::qt(0.975, df = n_rep - 1)
sig_paired <- abs(t_paired) > t_crit             # named logical, same names
# Bonferroni point for the n_tests statistics of this table (conservative: the
# statistics are not independent)
t_bonf   <- stats::qt(1 - 0.05 / (2 * n_tests), df = n_rep - 1)
sig_bonf <- abs(t_paired) > t_bonf
fmt(rep_tab, 3)
# Pooling the two pools halves the variance only if their paired differences
# are uncorrelated across founder draws: measured, not assumed.
pool_pair <- function(mA, mB) {
  dA <- diffs(mA); dB <- diffs(mB)
  c(cor_AB = stats::cor(dA, dB), sd_A = stats::sd(dA), sd_B = stats::sd(dB),
    sd_pooled = stats::sd((dA + dB) / 2),
    sd_if_independent = sqrt((stats::var(dA) + stats::var(dB)) / 4))
}
pool_tab <- rbind(gd_elite = pool_pair("gd_A", "gd_B"),
                  gd_pool  = pool_pair("gd_pool_A", "gd_pool_B"),
                  mean_tc  = pool_pair("mean_tc_A", "mean_tc_B"))
fmt(pool_tab, 3)
stopifnot(isTRUE(all.equal(pool_tab["gd_elite", "sd_pooled"],
                           rep_tab["gd_elite_mean", "diff_sd"])))

#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-loss
#| tbl-cap: !expr cap_loss
loss <- function(arm, m) vapply(arms, function(a)
  (a[[arm]][[m]][1] - a[[arm]][[m]][last]) / a[[arm]][[m]][1], numeric(1))
loss_tab <- rbind(
  `pool A, selected` = c(mean = mean(loss("sel", "gd_pool_A")), sd = stats::sd(loss("sel", "gd_pool_A"))),
  `pool A, control`  = c(mean = mean(loss("ctl", "gd_pool_A")), sd = stats::sd(loss("ctl", "gd_pool_A"))),
  `pool B, selected` = c(mean = mean(loss("sel", "gd_pool_B")), sd = stats::sd(loss("sel", "gd_pool_B"))),
  `pool B, control`  = c(mean = mean(loss("ctl", "gd_pool_B")), sd = stats::sd(loss("ctl", "gd_pool_B"))))
fmt(loss_tab, 3)
fig_cap <- paste0("Reciprocal recurrent selection over ", rrs_cfg[["n_cycles"]],
  " cycles, ", cfg_note, ", ", n_rep, " founder draws, selection (solid) against ",
  "the paired no-selection control (dashed); points are means over draws and ",
  "bars plus and minus one standard deviation across draws. Left: mean ",
  "testcross phenotype (trait 1, trait units) of all DH lines ",
  "tested that cycle, pool-A lines on pool-B testers ('A on B') and pool-B ",
  "lines on pool-A testers ('B on A'); both estimate the A x B hybrid level, so the two curves ",
  "are not separate per-pool responses. Right: gene diversity (1 - mean ",
  "molecular coancestry) of the elite lines retained each cycle. Founders ",
  "from runMacs2(); their reproducibility from the seed was not established.")

#' 
## -----------------------------------------------------------------------------
#| label: fig-alphasimr-cycles
#| echo: false
#| fig-width: 6.5
#| fig-height: 5
#| fig-cap: !expr fig_cap
#| fig-alt: "Two side-by-side line charts against breeding cycle 1 to 4. Left: mean testcross phenotype of pool-A lines on pool-B testers and of pool-B lines on pool-A testers, selected arm solid and paired control dashed, with standard-deviation bars. Right: gene diversity of the pool-A and pool-B elite lines, same arms."
arm_stat <- function(arm, m, f) sapply(seq_len(rrs_cfg[["n_cycles"]]), function(i)
  f(vapply(arms, function(a) a[[arm]][[m]][i + 1], numeric(1))))
cyc  <- seq_len(rrs_cfg[["n_cycles"]])
cols <- book_pal[c("A", "B")]
panel <- function(mA, mB, ylab, main, labs) {
  st <- lapply(c(sel = "sel", ctl = "ctl"), function(arm)
    list(A = arm_stat(arm, mA, mean), B = arm_stat(arm, mB, mean),
         sA = arm_stat(arm, mA, stats::sd), sB = arm_stat(arm, mB, stats::sd)))
  ylim <- range(unlist(lapply(st, function(s)
    c(s[["A"]] - s[["sA"]], s[["A"]] + s[["sA"]], s[["B"]] - s[["sB"]], s[["B"]] + s[["sB"]]))))
  plot(cyc, st[["sel"]][["A"]], type = "n", ylim = ylim, xlab = "Cycle", ylab = ylab,
       main = main, xaxt = "n")
  axis(1, at = cyc)
  for (arm in c("sel", "ctl")) {
    lty <- if (arm == "sel") 1 else 2
    off <- if (arm == "sel") -0.04 else 0.04
    for (p in c("A", "B")) {
      x <- cyc + off; y <- st[[arm]][[p]]; s <- st[[arm]][[paste0("s", p)]]
      lines(x, y, type = "b", pch = 19, lty = lty, col = cols[p])
      arrows(x, y - s, x, y + s, angle = 90, code = 3, length = 0.03, col = cols[p])
    }
  }
  # legend in the bottom margin, a fixed 0.8 in below the axis, under the
  # x-axis title: it cannot meet the data whatever range a founder draw gives
  usr <- par("usr")
  y_leg <- grconvertY(grconvertY(usr[3], "user", "inches") - 0.8, "inches", "user")
  legend(mean(usr[1:2]), y_leg, xjust = 0.5, yjust = 1, xpd = NA,
         paste0(rep(labs, 2), rep(c(", selected", ", control"), each = 2)),
         col = cols[c("A", "B", "A", "B")], lty = c(1, 1, 2, 2), pch = 19,
         bty = "n", cex = 0.8)
}
op <- par(mfrow = c(1, 2), mar = c(9, 4.3, 2.2, 0.8))
panel("mean_tc_A", "mean_tc_B", "Mean testcross phenotype (trait units)",
      "Selection response", c("A on B", "B on A"))
panel("gd_A", "gd_B", "Gene diversity of the elite lines", "Diversity erosion",
      c("pool A elites", "pool B elites"))
par(op)

#' 
## -----------------------------------------------------------------------------
#| echo: false
# prose helpers: every verdict below is decided by the render's own t
verdict <- function(m, yes = "is", no = "is not") if (sig_paired[[m]]) yes else no
sgn <- function(x, d = 3) sprintf(paste0("%+.", d, "f"), x)

#' 
#' What was measured (@fig-alphasimr-cycles, @tbl-alphasimr-paired and @tbl-alphasimr-loss): over `r n_rep`
#' paired replicates, the selected arm's mean testcross phenotype at cycle
#' `r rrs_cfg[["n_cycles"]]` differs from the control's by
#' `r sgn(rep_tab["mean_tc_A", "diff_mean"], 2)` (`mean_tc_A`, pool-A lines on
#' pool-B testers) and
#' `r sgn(rep_tab["mean_tc_B", "diff_mean"], 2)` (`mean_tc_B`, pool-B lines on
#' pool-A testers) trait units, with paired
#' standard deviations of `r fmt(rep_tab["mean_tc_A", "diff_sd"], 2)` and
#' `r fmt(rep_tab["mean_tc_B", "diff_sd"], 2)`; the elite factorial's genetic
#' value -- the product -- differs by `r sgn(rep_tab["hybrid_meanG", "diff_mean"], 2)`
#' (`t = `r fmt(t_paired[["hybrid_meanG"]], 1)``). Gene diversity of the elite
#' lines, averaged over the two pools, differs by
#' `r sgn(rep_tab["gd_elite_mean", "diff_mean"])` (paired s.d.
#' `r fmt(rep_tab["gd_elite_mean", "diff_sd"], 3)`, `t = `r fmt(t_paired[["gd_elite_mean"]], 1)``),
#' and that of the recombined pools by
#' `r sgn(rep_tab["gd_pool_mean", "diff_mean"])` (`t = `r fmt(t_paired[["gd_pool_mean"]], 1)``).
#' Between the pools, `GD_BS` differs by `r sgn(rep_tab["GD_BS", "diff_mean"])`
#' (`t = `r fmt(t_paired[["GD_BS"]], 1)``) and `F_ST` by
#' `r sgn(rep_tab["F_ST", "diff_mean"])` (`t = `r fmt(t_paired[["F_ST"]], 1)``).
#' The two-sided 5 percent point of `t` with `r n_rep - 1` degrees of freedom is
#' `r fmt(t_crit, 2)`. Against it, in this render, the response -- both
#' testcross means and the product --
#' `r if (all(sig_paired[c("mean_tc_A", "mean_tc_B", "hybrid_meanG")])) "is beyond it" else "is not beyond it"`;
#' the pooled elite-line gene-diversity difference
#' `r verdict("gd_elite_mean", "is beyond it", "is not beyond it")`; the pooled
#' recombined-pool difference
#' `r verdict("gd_pool_mean", "is beyond it", "is not beyond it")`; the `GD_BS`
#' difference `r verdict("GD_BS", "is beyond it", "is not beyond it")`; the
#' `F_ST` difference `r verdict("F_ST", "is beyond it", "is not beyond it")`.
#' 
#' **Multiplicity.** @tbl-alphasimr-paired-1 tests `r n_tests` statistics, each against
#' the unadjusted point just given. They are not independent: the pooled means are
#' averages of the per-pool rows, and the elite-line and recombined-pool gene
#' diversities are computed on the same elites. The Bonferroni two-sided 5 percent point
#' for `r n_tests` comparisons is `r fmt(t_bonf, 2)`, the correction reported here;
#' it is conservative given the dependence and is not the exact family-wise level.
#' Against it, in this render, the response statistics (both testcross means and
#' the product)
#' `r if (all(sig_bonf[c("mean_tc_A", "mean_tc_B", "hybrid_meanG")])) "are all beyond it" else "are not all beyond it"`
#' (smallest $|t|$ `r fmt(min(abs(t_paired[c("mean_tc_A", "mean_tc_B", "hybrid_meanG")])), 1)`);
#' the pooled elite-line gene-diversity difference
#' `r if (sig_bonf[["gd_elite_mean"]]) "is beyond it" else "is not beyond it"`
#' (`t = `r fmt(t_paired[["gd_elite_mean"]], 1)``); the pooled recombined-pool difference
#' `r if (sig_bonf[["gd_pool_mean"]]) "is beyond it" else "is not beyond it"`
#' (`t = `r fmt(t_paired[["gd_pool_mean"]], 1)``); `GD_BS`
#' `r if (sig_bonf[["GD_BS"]]) "is beyond it" else "is not beyond it"` and `F_ST`
#' `r if (sig_bonf[["F_ST"]]) "is beyond it" else "is not beyond it"`. The two pooled gene-diversity means
#' (`gd_elite_mean`, `gd_pool_mean`) are constructions made to reduce the noise of
#' the per-pool rows, not a test declared before the data were looked at, so every
#' conclusion about diversity in this section is **exploratory**. The response
#' statistics are what the scheme is built to move, and their correction is the one
#' stated above.
#' 
#' Pooling the two pools' differences is not free noise reduction, and
#' @tbl-alphasimr-paired-2 (`pool_tab`) measures what it buys. Averaging halves the variance only if the
#' two pools' paired differences are independent across founder draws. For the
#' elite-line gene diversity they are correlated at
#' `r fmt(pool_tab["gd_elite", "cor_AB"], 2)`, and the pooled standard deviation,
#' `r fmt(pool_tab["gd_elite", "sd_pooled"], 3)`, is close to the
#' `r fmt(pool_tab["gd_elite", "sd_if_independent"], 3)` it would be if they were
#' independent: pooling does what it should there. For the testcross mean they
#' are correlated at `r fmt(pool_tab["mean_tc", "cor_AB"], 2)`, and the pooled
#' standard deviation is `r fmt(pool_tab["mean_tc", "sd_pooled"], 2)` against
#' `r fmt(pool_tab["mean_tc", "sd_if_independent"], 2)` if independent: pooling
#' does not reduce that noise. The construction of the two statistics accounts
#' for the correlation without any appeal to the founder draw: `mean_tc_A` is
#' the mean of pool-A lines on testers from the current pool B and `mean_tc_B`
#' the mean of pool-B lines on testers from the current pool A, so both are
#' estimates of the same A x B hybrid level, and progress in either pool raises
#' both (better lines in one statistic, better testers in the other). How much
#' of the correlation is that and how much is the founder draw is not separated
#' here. The `gd_A`/`gd_B` and `gd_pool_A`/`gd_pool_B` rows are per pool and show
#' the asymmetry between two exchangeable pools that any one set of `r n_rep`
#' draws produces; the `mean_tc_A`/`mean_tc_B` rows are not per-pool responses,
#' for the reason just given. @tbl-alphasimr-loss says how much of the pools' loss is selection: the control loses gene
#' diversity too -- `r rrs_cfg[["n_sel"]]` elites recombined into
#' `r rrs_cfg[["n_pool_A"]]` individuals is a bottleneck whether or not the
#' elites were chosen -- and the selected arm's mean loss
#' `r if (rep_tab["gd_pool_mean", "diff_mean"] < 0) "exceeds" else "does not exceed"`
#' the control's, with the pooled `t` just stated as the evidence.
#' 
#' What is inferred: with real meiosis and a dominance trait behind it, the
#' A x B hybrid level responds to reciprocal recurrent selection -- both
#' testcross means and the elite factorial's genetic value measure it -- and at
#' this replication that response
#' `r if (all(sig_paired[c("mean_tc_A", "mean_tc_B", "hybrid_meanG")])) "is beyond" else "is not beyond"`
#' `t_crit`. How much of it each pool contributes is not identified by these
#' statistics: each testcross mean carries the progress of both pools, so a
#' response in pool A alone would raise `mean_tc_A` and `mean_tc_B` together. Whether it spends within-pool diversity faster than the same
#' bottleneck under drift alone is an exploratory question (multiplicity above).
#' In this render the pooled gene-diversity `t` is
#' `r verdict("gd_elite_mean", "beyond", "not beyond")` the unadjusted point for the
#' elite lines and `r verdict("gd_pool_mean", "beyond", "not beyond")` it for the
#' recombined pools, and
#' `r if (any(sig_bonf[c("gd_elite_mean", "gd_pool_mean")])) "at least one of them is also beyond" else "neither is beyond"`
#' the Bonferroni point; the supported reading is therefore
#' `r if (any(sig_bonf[c("gd_elite_mean", "gd_pool_mean")])) "that selection spends more within-pool diversity than the bottleneck alone, with the correction" else "an unadjusted suggestion that selection spends more within-pool diversity than the bottleneck alone, which the correction does not support"`.
#' Per founder draw, the ratio of the mean elite-line
#' selection component to its paired standard deviation is
#' `r fmt(abs(rep_tab["gd_elite_mean", "diff_mean"]) / rep_tab["gd_elite_mean", "diff_sd"], 1)`,
#' so a single draw does not settle its sign; the
#' `r n_rep`-draw `t` of `r fmt(t_paired[["gd_elite_mean"]], 1)` against
#' `t_crit` = `r fmt(t_crit, 2)` is what decides it. Where the sign holds, the control separates
#' the selection component of the loss from the bottleneck (drift) component,
#' within this design. It is not a replication of another chapter's control:
#' @sec-cycles follows diversity across cycles under a budget `alpha` against the
#' frozen founding base and has no random-selection arm, and @sec-programme
#' measures its loss against the programme's own starting point "rather than
#' against a random-selection baseline of the same size", as it says there. @sec-limits has
#' another paired no-selection design, built on the same founder wrapper and
#' measuring a different quantity, the gap between `varA` and
#' `genicVarA`. The between-pool rows: the `GD_BS` difference
#' `r verdict("GD_BS")` beyond `t_crit`; where it is, and positive, RRS has moved the
#' pools further apart than the control did. Whether that raises heterosis is not
#' tested here. @sec-heterosis infers, and says it has not shown, that selection on
#' cross performance is the only process considered there that can move
#' frequencies according to where the dominance is, and that the alignment of
#' divergence with dominance, $\operatorname{cov}(d, y^2)$ of
#' @sec-heterosis-alignment, is built or eroded cycle by cycle; this chapter
#' computes neither that alignment nor the divergence share of expected heterosis
#' across cycles (the share is computed only across founder split times, in
#' @tbl-alphasimr-split-1), so that inference stays untested. `F_ST` $= GD_{BS} / GD_T$ moves
#' with its denominator as well, and `GD_T` of the recombined pools is not
#' recorded in @tbl-alphasimr-paired-1, so `GD_BS` is the row read for divergence. What limits the inference is the scale
#' -- `r rrs_cfg[["n_pool_A"]]` founders per pool, `r rrs_cfg[["n_cycles"]]`
#' cycles, `r rrs_cfg[["n_testers"]]` testers at one location, `r n_rep` draws
#' -- and, if `runMacs2()` founders do not repeat from the seed (not established,
#' Step 1), the numbers in this paragraph and any verdict that rests on a `t`
#' near `t_crit` may differ between renders.
#' 
#' ### The final hybrid pool through `stage2_select()`, unchanged
#' 
#' `alphasimr_pipeline()` is the loop above without the instrumentation: founders,
#' `r rrs_cfg[["n_cycles"]]` cycles, then `alphasimr_make_hybrids()` testcrosses
#' the final cycle's elites directly against each other -- a full factorial
#' between the `r rrs_cfg[["n_sel"]]` pool-A elites and `r rrs_cfg[["n_sel"]]`
#' pool-B elites, so `r rrs_cfg[["n_sel"]] * rrs_cfg[["n_sel"]]` commercial
#' hybrids -- and phenotypes them the same way every testcross in this chapter
#' was phenotyped. `alphasimr_to_stage1()` then does the bookkeeping that makes
#' this look like any other stage-1 output: it remaps AlphaSimR's internal line
#' ids into the `1..n_A`, `n_A+1..n_A+n_B` convention `hybrids$line_A`/`line_B`
#' and `fL` use elsewhere in the book, and builds `fL` by stacking the elite lines
#' from *both* pools' genotypes into one matrix and computing a single joint
#' coancestry matrix over all of them -- not two separate per-pool matrices --
#' which is what lets `theta_pools()` and the rest of the pipeline index into pool
#' A and pool B lines with one consistent numbering. @tbl-alphasimr-pipeline
#' shows both stages.
#' 
## -----------------------------------------------------------------------------
#| label: tbl-alphasimr-pipeline
#| tbl-cap: !expr cap_pipeline
#| tbl-subcap:
#|   - "Cycle trajectory, cycles 1 to 4"
#|   - "Stage-2 selection on the elite hybrids"
res <- alphasimr_pipeline(rrs_cfg)
fmt(res[["cycles"]], 4)
st1 <- res[["stage1"]]
# the contract holds one row per elite A x B hybrid
stopifnot(nrow(st1[["X"]]) == rrs_cfg[["n_sel"]]^2)
sel <- stage2_select(st1[["X"]], st1[["f"]], st1[["hybrids"]], n_sel = n_hyb_sel, fL = st1[["fL"]],
                     verbose = FALSE)
fmt(sel[["metrics"]][, c("scenario", "alpha", "GD", "GD_BS", "F_ST", "index")], 4)

#' 
#' This call uses the same `seed = 1` as the first of the `r n_rep` replicates and
#' as @tbl-alphasimr-founders and @tbl-alphasimr-cycle1; whether it returns the same
#' founders as those calls was not established (Step 1), so it is read as one more
#' replicate in the sense of @fig-alphasimr-cycles, not as a rerun of the first and
#' not as one of the `r n_rep`. Depending on the draw, `stage2_select()` may
#' warn that the attainable `alpha` ceiling is at or below zero: with
#' `r rrs_cfg[["n_sel"]] * rrs_cfg[["n_sel"]]` hybrids over
#' `r 2 * rrs_cfg[["n_sel"]]` lines, truncation on the index can pick a set no
#' less diverse than a random one of the same size, and then the constraint has
#' nothing to restrict and every `DE_alpha` row coincides with `ref_truncation`.
#' That is the same ceiling @sec-combinatorial computes on the
#' book's own data, where the pool is large enough for it to be positive; the
#' `DE_alpha` and `ref_truncation` scenarios and the ceiling are defined there and
#' in @sec-baseline, and are used here only as outputs. Nothing here is
#' AlphaSimR-specific:
#' `stage2_select()` never sees where `X`, `f`, `hybrids` and `fL` came from, only
#' that they satisfy the contract stage 1 promises. `GD_BS`, the between-pool
#' component of the partition, is computed from `fL` exactly as it is everywhere
#' else in the book. It is the divergence term of expected heterosis only under the
#' conditions stated in @sec-heterosis -- flat dominance, inbred parents and the
#' complete factorial, with equal weights; with a $d_k$ that varies across loci it
#' is the unweighted version of a $d$-weighted term -- and here $d_k = \delta_k |a_k|$
#' varies, the parents of the final cross are inbred DH lines but the pools they
#' come from are outbred, and the factorial is the elite one. Read as a divergence
#' statistic, not as a measure of heterosis.
#' 
#' ## Assumptions, and what this adds over @sec-simulating-crosses
#' 
#' **What is more realistic here.** Actual recombination and linkage (a genetic
#' map per chromosome, not independent markers), a trait with directional
#' dominance so that testcross selection has something real to select on and
#' heterosis and inbreeding depression have a value, outbred founder pools with a
#' coalescent split behind them, and multi-generation recurrent selection with a
#' paired control rather than one static pool.
#' 
#' **What is declared, and where.** Steps 2--6 use inbred founders from
#' `quickHaplo()` with every site a QTL and dominance degrees drawn at
#' `meanDD = `r rrs_cfg[["mean_dd"]]``, `varDD = `r rrs_cfg[["var_dd"]]``; the
#' "pools" of Steps 4 and 6 are two undifferentiated halves of one founder set.
#' Step 7 uses a separate additive founder draw. Step 8 uses outbred founders
#' from `runMacs2(split = )`, again with every site a QTL; its DH lines are fully
#' inbred, its testers are outbred individuals, and every loss of diversity is
#' measured against the same run's founders (cycle 0) and against the paired
#' no-selection control -- not against a random-subset null of the same size,
#' which is the reference @sec-combinatorial's `alpha` uses.
#' Against the labels A1--A8 (listed in @sec-hybrid-programme; @sec-backcross maps
#' all eight), Step 8 keeps A1 (two heterotic pools), A3 (recycling within pool), A4
#' (discrete cycles) and, for the trajectory, A6 (measured against the founders of
#' cycle 0); it relaxes A2 for the founders (outbred; the DH lines are fully
#' inbred), A5 (linked sites, every site a QTL) and A7 (directional dominance); A8
#' does not apply, the chapter runs its own configuration.
#' 
#' **What is still simplified.** Testers are the first `r rrs_cfg[["n_testers"]]`
#' individuals of the *current* opposite pool, an arbitrary slice by index -- not
#' chosen at random or by merit, and not the elite inbred tester a real programme
#' would use; because `randCross()` recreates each pool every cycle, the testers
#' change from cycle to cycle, so successive cycles' testcross means are not on
#' a common tester and are comparable only through the pools' genetic level;
#' there is one phenotyping
#' environment (`setPheno()`'s error variance, no genotype-by-environment term --
#' @sec-programme adds one); the population-split coalescent history is a
#' stylised divergence process, not calibrated to a named heterotic-pool pair;
#' doubled-haploid production is instantaneous, skipping the field seasons Step 5
#' counted; and selection acts on trait 1 only -- the `r rrs_cfg[["n_traits"]]`
#' traits this chapter's config simulates are all carried through `X`/`hybrids`,
#' but only the first ever enters the GCA ranking. The accuracy prediction of
#' Step 6 is first order in the sample correlation -- its finite-tester-pool and
#' sample-variance corrections are applied, its second-order term is not -- and
#' the selfing trajectory of Step 5 follows `r n_f1` parallel lineages from one
#' cross, checked at seven generations.
#' 
#' **Scale.** Step 8 runs live at a scale of its own (`r rrs_cfg[["n_pool_A"]]` +
#' `r rrs_cfg[["n_pool_B"]]` founders, `r rrs_cfg[["n_chr"]] * rrs_cfg[["seg_sites"]]`
#' markers, `r rrs_cfg[["n_cycles"]]` cycles, `r n_rep` paired founder draws). It is
#' not the teaching scale `book_cfg` of the rest of the book
#' (`r book_cfg[["n_pool_A"]]` + `r book_cfg[["n_pool_B"]]` lines,
#' `r book_cfg[["m"]]` markers), nor the default of `rrs_config`
#' (`r rrs_config[["n_pool_A"]]` + `r rrs_config[["n_pool_B"]]` founders,
#' `r rrs_config[["n_chr"]] * rrs_config[["seg_sites"]]` sites); Steps 2 to 6 use `r pop@nInd` founders
#' and `r length(a)` QTL and Step 7 `r f2@nInd` founders. AlphaSimR is fast enough at this size that no
#' caching is needed, unlike the marker-assisted backcrossing (MABC) scans in
#' @sec-backcross. Step 8's numbers may change on re-execution if its founders do
#' (Step 1 does not establish whether `runMacs2()` founders repeat from the seed);
#' a mean over draws moves by the order of its standard error (the between-draw
#' standard deviation above over the square root of the number of draws), and so
#' may a conclusion that rests on a `t` near `t_crit`, which is why
#' the chapter writes each such inference conditionally on the render's own
#' `t`. A heavier, production-scale run is
#' `inst/scripts/run_alphasimr.R`:
#' 
#' ```sh
#' Rscript inst/scripts/run_alphasimr.R --test          # smoke run
#' Rscript inst/scripts/run_alphasimr.R --out=DIR        # full run
#' ```
#' 
#' It runs `alphasimr_pipeline()` at a larger configuration, feeds the resulting
#' hybrid pool through `stage2_select()`, and writes the cycle trajectory and
#' selection metrics as CSVs.
#' 
#' ## Where this connects
#' 
#' @sec-simulating-crosses and Step 8 build the same three-object contract
#' from two different generative models -- the fast one and the realistic one --
#' which is the point of drawing that seam where the book does: everything past
#' it, `build_ctx()` through `stage2_select()`, cannot tell which one it is
#' looking at. @sec-heterosis is the algebra Steps 3, 4 and 6 verify against
#' AlphaSimR: inbreeding depression against `genParam()`, expected heterosis
#' against a full factorial, and the GCA/SCA decomposition against the exact
#' combining abilities. @sec-response supplies the breeder's equation Step 6
#' checks and the index theory Step 7 uses; @sec-limits is where Step 3's
#' `varA`-against-`genicVarA` gap becomes the subject rather than a diagnostic.
#' @sec-subdivided supplies the partition Step 8 measures across `split` and
#' across cycles. @sec-cycles follows gene diversity across cycles under a diversity
#' budget `alpha` with the package's own faster simulator. Step 8 has no such
#' budget (its control is random elites, not a constraint), so it does not
#' cross-check that chapter's `alpha` result; it measures the same quantity,
#' gene diversity of the pools across cycles, under unconstrained selection on a
#' simulator with real meiosis. @sec-limits builds its linked arm on the
#' `alphasimr_founder_pools()` wrapper of this step, and takes the `varA` against
#' `genicVarA` gap of Step 3 as the quantity it then measures across cycles.
#' 
#' @sec-programme, in the Evidence and practice part, is the other half of the
#' method: the same primitives assembled into an inbred-line programme with staged
#' yield trials, where the question is not which hybrids to sell but how fast a
#' variety pipeline can run and what it spends to run faster.
#' 
#' This closes the Simulation part. The Metrics and prediction part that follows
#' turns from generating populations to measuring their diversity, starting with
#' @sec-genomic-era.
