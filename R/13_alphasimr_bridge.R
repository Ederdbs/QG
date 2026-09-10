# AlphaSimR bridge -- reciprocal recurrent selection across two heterotic
# pools, reproduced with AlphaSimR's founder-haplotype/meiosis/dominance
# engine instead of the package's own Balding-Nichols simulate_lines().
#
# AlphaSimR is Suggests-only (see DESCRIPTION); every function below is
# guarded by requireNamespace(), following the quadprog/highs pattern in
# R/07_caballero_toro.R and R/12_search.R.
#
# Everything downstream of alphasimr_to_stage1() is unchanged: it calls
# stage1_build() and hands back the same {X, f, hybrids, fL} contract as
# stage1_simulate(), so stage2_select() runs on it without modification.

#' Reciprocal-recurrent-selection configuration
#'
#' Controls the scale of the AlphaSimR pipeline. The shipped default is a
#' small teaching scale, matching the spirit of [sim_config].
#'
#' @format A list: `n_pool_A`, `n_pool_B` (founder pool sizes), `n_chr`,
#'   `seg_sites` (per chromosome), `split_gen` (generations since the two
#'   pools diverged), `n_dh` (doubled-haploid lines per parent per cycle),
#'   `n_testers` (individuals from the opposite pool used as the reciprocal
#'   tester), `n_sel` (lines retained per pool per cycle), `n_cycles`,
#'   `n_traits`, `h2`, `mean_dd`/`var_dd` (dominance degree, the heterosis
#'   engine) and `seed`.
#' @export
rrs_config <- list(
  n_pool_A  = 20,
  n_pool_B  = 20,
  n_chr     = 5,
  seg_sites = 100,
  split_gen = 100,
  n_dh      = 3,
  n_testers = 2,
  n_sel     = 8,
  n_cycles  = 4,
  n_traits  = 1,
  h2        = 0.4,
  mean_dd   = 0.4,
  var_dd    = 0.1,
  seed      = 1
)

#' Found two heterotic pools with AlphaSimR
#'
#' Draws founder haplotypes from a coalescent history with a population split
#' `cfg$split_gen` generations ago (`AlphaSimR::runMacs2(..., split = )`), the
#' realistic analogue of [simulate_lines]'s Balding-Nichols draw, and attaches
#' an additive + dominance trait per `cfg$n_traits`. Dominance is what makes
#' testcross selection meaningful -- see `05b-heterosis-dominance`.
#'
#' `cfg$seed` does **not** make this function reproducible, and the `set.seed()`
#' below is easy to misread as a promise that it does. `AlphaSimR::runMacs2()`
#' hands the coalescent off to MaCS, which seeds itself outside R's RNG, so two
#' calls with the same `cfg` return different founder haplotypes. Everything
#' downstream of the founders -- the doubled haploids, the testcrosses, the
#' recycling -- *is* controlled by `set.seed()`; the founders are not.
#'
#' The consequence for any experiment comparing two schemes: found the pools
#' once and branch both arms off that single result. Calling this twice with the
#' same seed gives two different populations, and the comparison then measures
#' the founders as much as the schemes.
#'
#' @param cfg A configuration list, see [rrs_config].
#' @return A list with `pop_A`, `pop_B` (AlphaSimR `Pop-class`) and `SP`
#'   (the `SimParam`).
#' @export
alphasimr_founder_pools <- function(cfg = rrs_config) {
  if (!requireNamespace("AlphaSimR", quietly = TRUE))
    stop("Package 'AlphaSimR' is required for alphasimr_founder_pools().")
  set.seed(cfg$seed)
  founders <- AlphaSimR::runMacs2(nInd = cfg$n_pool_A + cfg$n_pool_B,
                                   nChr = cfg$n_chr, segSites = cfg$seg_sites,
                                   split = cfg$split_gen)
  SP <- AlphaSimR::SimParam$new(founders)
  for (i in seq_len(cfg$n_traits))
    SP$addTraitAD(nQtlPerChr = cfg$seg_sites, mean = 0, var = 1,
                   meanDD = cfg$mean_dd, varDD = cfg$var_dd)
  SP$setVarE(h2 = rep(cfg$h2, cfg$n_traits))
  pop <- AlphaSimR::newPop(founders, simParam = SP)
  list(pop_A = pop[seq_len(cfg$n_pool_A)],
       pop_B = pop[cfg$n_pool_A + seq_len(cfg$n_pool_B)], SP = SP)
}

#' Group coancestry of an AlphaSimR population
#'
#' `1 - mean(f)`, the same definition as [gene_diversity], computed directly
#' from the population's marker genotypes rather than through a `ctx`.
#'
#' @param pop An AlphaSimR `Pop-class` object.
#' @param SP The `SimParam`.
#' @return A scalar in `[0, 1]`.
#' @export
alphasimr_gd <- function(pop, SP) {
  if (!requireNamespace("AlphaSimR", quietly = TRUE))
    stop("Package 'AlphaSimR' is required for alphasimr_gd().")
  geno <- AlphaSimR::pullSegSiteGeno(pop, simParam = SP) / 2
  1 - mean(molecular_coancestry(geno))
}

#' One cycle of reciprocal recurrent selection
#'
#' Doubled-haploid lines are drawn from each pool, reciprocally testcrossed to
#' a tester subset of the *other* pool, phenotyped, and the lines with the
#' best mean testcross performance (a GCA proxy) are recombined to found the
#' next cycle's pool -- Comstock, Robinson & Harvey (1949).
#'
#' @param pop_A,pop_B This cycle's pools (AlphaSimR `Pop-class`).
#' @param SP The `SimParam`.
#' @param cfg A configuration list, see [rrs_config].
#' @param random_elite Draw the elite lines at random instead of by testcross
#'   rank. `FALSE`, the default, is the real scheme and reproduces the previous
#'   behaviour exactly. `TRUE` is the no-selection control: everything else
#'   about the cycle -- the doubled haploids, the testcrosses, the recombination
#'   -- is identical, so any difference between the two arms is attributable to
#'   selection and not to drift, the mating design or the map.
#' @return A list with `pop_A`, `pop_B` (next cycle's pools), `elite_A`,
#'   `elite_B` (the selected doubled-haploid lines, for [alphasimr_make_hybrids])
#'   and `summary` (one-row data frame: mean testcross phenotype and gene
#'   diversity of the elite lines in each pool).
#' @export
alphasimr_rrs_cycle <- function(pop_A, pop_B, SP, cfg = rrs_config,
                                random_elite = FALSE) {
  if (!requireNamespace("AlphaSimR", quietly = TRUE))
    stop("Package 'AlphaSimR' is required for alphasimr_rrs_cycle().")

  dh_A <- AlphaSimR::makeDH(pop_A, nDH = cfg$n_dh, simParam = SP)
  dh_B <- AlphaSimR::makeDH(pop_B, nDH = cfg$n_dh, simParam = SP)
  tester_A <- pop_A[seq_len(min(cfg$n_testers, pop_A@nInd))]
  tester_B <- pop_B[seq_len(min(cfg$n_testers, pop_B@nInd))]

  tc_A <- AlphaSimR::setPheno(AlphaSimR::hybridCross(dh_A, tester_B, simParam = SP), simParam = SP)
  tc_B <- AlphaSimR::setPheno(AlphaSimR::hybridCross(dh_B, tester_A, simParam = SP), simParam = SP)

  gca_A <- sort(tapply(tc_A@pheno[, 1], tc_A@mother, mean), decreasing = TRUE)
  gca_B <- sort(tapply(tc_B@pheno[, 1], tc_B@mother, mean), decreasing = TRUE)
  pick <- function(g) if (random_elite) sample(names(g), cfg$n_sel)
                      else names(g)[seq_len(cfg$n_sel)]
  elite_A <- dh_A[dh_A@id %in% pick(gca_A)]
  elite_B <- dh_B[dh_B@id %in% pick(gca_B)]

  list(pop_A = AlphaSimR::randCross(elite_A, nCrosses = cfg$n_pool_A, simParam = SP),
       pop_B = AlphaSimR::randCross(elite_B, nCrosses = cfg$n_pool_B, simParam = SP),
       elite_A = elite_A, elite_B = elite_B,
       summary = data.frame(mean_tc_A = mean(gca_A), mean_tc_B = mean(gca_B),
                            gd_A = alphasimr_gd(elite_A, SP),
                            gd_B = alphasimr_gd(elite_B, SP)))
}

#' Cross the final elite lines to form the commercial hybrid pool
#'
#' A full factorial (testcross diallel) of the elite doubled-haploid lines
#' from each pool, phenotyped.
#'
#' @param elite_A,elite_B Selected lines, see [alphasimr_rrs_cycle].
#' @param SP The `SimParam`.
#' @return An AlphaSimR `Pop-class` of hybrids, `elite_A@nInd * elite_B@nInd`
#'   individuals.
#' @export
alphasimr_make_hybrids <- function(elite_A, elite_B, SP) {
  if (!requireNamespace("AlphaSimR", quietly = TRUE))
    stop("Package 'AlphaSimR' is required for alphasimr_make_hybrids().")
  AlphaSimR::setPheno(AlphaSimR::hybridCross(elite_A, elite_B, simParam = SP), simParam = SP)
}

#' AlphaSimR hybrid pool to the stage-1 contract
#'
#' Pulls marker genotypes and phenotypes out of an AlphaSimR hybrid `Pop` and
#' hands them to [stage1_build], exactly as [stage1_simulate] does for the
#' package's own simulator. Parent line ids are renumbered 1..nA for pool A
#' and nA+1..nA+nB for pool B, matching the convention [simulate_data] uses
#' so that `fL` and `ped$a`/`ped$b` stay aligned (needed by [theta_pools]).
#'
#' @param hybrid_pop Output of [alphasimr_make_hybrids].
#' @param elite_A,elite_B The parent lines that produced it.
#' @param SP The `SimParam`.
#' @return The stage-1 contract, see [stage1_build].
#' @export
alphasimr_to_stage1 <- function(hybrid_pop, elite_A, elite_B, SP) {
  if (!requireNamespace("AlphaSimR", quietly = TRUE))
    stop("Package 'AlphaSimR' is required for alphasimr_to_stage1().")

  ped <- data.frame(a = match(hybrid_pop@mother, elite_A@id),
                    b = elite_A@nInd + match(hybrid_pop@father, elite_B@id))
  fL <- molecular_coancestry(rbind(
    AlphaSimR::pullSegSiteGeno(elite_A, simParam = SP),
    AlphaSimR::pullSegSiteGeno(elite_B, simParam = SP)) / 2)

  stage1_build(X = AlphaSimR::pullSegSiteGeno(hybrid_pop, simParam = SP),
               ped = ped, traits = as.data.frame(hybrid_pop@pheno), fL = fL)
}

#' Run the full reciprocal-recurrent-selection pipeline
#'
#' Founds two heterotic pools, runs `cfg$n_cycles` of reciprocal recurrent
#' selection, crosses the final elite lines into a commercial hybrid pool, and
#' returns it in the stage-1 contract alongside the per-cycle trajectory.
#'
#' @param cfg A configuration list, see [rrs_config].
#' @return A list with `stage1` (see [stage1_build]) and `cycles` (a data
#'   frame, one row per cycle, from [alphasimr_rrs_cycle]'s `summary`).
#' @export
#' @examples
#' \donttest{
#' if (requireNamespace("AlphaSimR", quietly = TRUE)) {
#'   res <- alphasimr_pipeline(modifyList(rrs_config,
#'            list(n_pool_A = 6, n_pool_B = 6, n_dh = 2, n_sel = 3,
#'                 n_cycles = 2, seg_sites = 30, n_chr = 2)))
#'   names(res$stage1)
#' }
#' }
alphasimr_pipeline <- function(cfg = rrs_config) {
  if (!requireNamespace("AlphaSimR", quietly = TRUE))
    stop("Package 'AlphaSimR' is required for alphasimr_pipeline().")

  fp <- alphasimr_founder_pools(cfg)
  pop_A <- fp$pop_A; pop_B <- fp$pop_B; SP <- fp$SP
  cycles <- vector("list", cfg$n_cycles)
  for (i in seq_len(cfg$n_cycles)) {
    cy <- alphasimr_rrs_cycle(pop_A, pop_B, SP, cfg)
    pop_A <- cy$pop_A; pop_B <- cy$pop_B
    cycles[[i]] <- cbind(cycle = i, cy$summary)
  }
  hybrids <- alphasimr_make_hybrids(cy$elite_A, cy$elite_B, SP)
  list(stage1 = alphasimr_to_stage1(hybrids, cy$elite_A, cy$elite_B, SP),
       cycles = do.call(rbind, cycles))
}
