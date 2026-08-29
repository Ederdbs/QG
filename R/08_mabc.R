# Marker-assisted backcrossing: introgressing 1-4 donor genes into an elite
# line. The engine is deliberately narrow: because the recurrent parent is a
# fully homozygous inbred, the gamete it contributes is invariant and only the
# donor-derived haplotype has to be tracked -- one binary vector per plant.
#
# The map, meiosis and marker-index machinery is shared with 06_f2size.R
# (build_map, meiosis, col_cumsum, marker_index); only what is specific to
# backcrossing lives here.
#
# The experiment drivers (the N x k x s scans, the allocation grid, the
# figures and the HTML report) are NOT here -- they are in
# inst/scripts/run_mabc.R, which is what regenerates book/data/mabc_*.csv.

# --- 1. Targets and options ---------------------------------------------------

#' Illustrative recessive target genes in maize
#'
#' Four recessive grain-quality genes used as the introgression targets.
#'
#' **The positions are illustrative and the stack is not a breeding
#' recommendation.** `sh2` and `bt2` encode the two subunits of the same enzyme
#' (endosperm ADP-glucose pyrophosphorylase), so stacking both is largely
#' redundant; `o2` alone gives opaque endosperm, not QPM, because the endosperm
#' hardness modifiers are polygenic, unlinked and not modelled here. Positions
#' are not pinned to a named consensus map. Replace this table with your own.
#'
#' @format A data.frame with columns `gene`, `chr`, `pos_cM` and `label`.
#' @export
maize_targets <- data.frame(
  gene   = c("sh2", "o2", "wx1", "bt2"),
  chr    = c(3, 7, 9, 4),
  pos_cM = c(150, 30, 60, 120),
  label  = c("sh2 (super sweet, 3L)", "o2 (QPM, 7S)",
             "wx1 (waxy, 9S)", "bt2 (brittle2, 4L)"),
  stringsAsFactors = FALSE
)

#' Default options for the MABC simulator
#'
#' `drag_per_gene` is a ceiling in cM **per gene**, `target_ibd` the recurrent
#' parent recovery target, and `P_crit` the probability at which a population
#' size is declared sufficient. `rec_keep` is the truncation fraction used by
#' the two-stage strategies; it is ignored by `rec_drag`.
#'
#' @format A named list.
#' @seealso [select_parent] for what `strategies` mean.
#' @export
mabc_opt <- list(
  spacing_cM    = 5,
  n_bc          = 3,
  genes_grid    = 1:4,
  strategies    = c("bg", "rec12", "rec_bg", "rec_drag"),
  main_strategy = "rec_drag",
  rec_until     = 2,      # used only by "rec12"
  rec_keep      = 0.25,
  ibd_block_cM  = 25,
  flank_cM      = 5,
  target_ibd    = 0.90,
  drag_per_gene = 30,
  P_crit        = 0.95,
  n_keep_f2     = 3,
  seed          = 20260829
)

# --- 2. Map helpers -----------------------------------------------------------

#' Marker indices of the first `k` targets
#'
#' @param map A map from [build_map].
#' @param k Number of targets to use, from the top of `targets`.
#' @param targets A target table, see [maize_targets].
#' @return An integer vector of `k` marker indices.
#' @examples
#' map <- build_map(maize_chr_len, spacing_cM = 5)
#' target_indices(map, 2)
#' @export
target_indices <- function(map, k, targets = maize_targets) {
  vapply(seq_len(k), function(i)
    marker_index(map, targets$chr[i], targets$pos_cM[i]), integer(1))
}

#' Map weight of each marker
#'
#' The share of the genome each marker stands for, so that a dosage computed
#' over markers is a genome fraction rather than a marker count. Weights are the
#' midpoint intervals from [build_map] and sum to 1.
#'
#' @param map A map from [build_map].
#' @return A numeric vector of length `map$m` summing to 1.
#' @export
marker_weights <- function(map) {
  w <- numeric(map$m)
  for (i in seq_along(map$chr_len)) {
    k <- which(map$chr == i)
    e <- map$edges[[i]]
    w[k] <- e[-1] - e[-length(e)]
  }
  w / sum(w)
}

#' One backcross to the recurrent parent
#'
#' The recurrent parent is a fully homozygous inbred, so its gamete is the
#' all-elite haplotype and only the donor-derived haplotype segregates.
#'
#' @param Hpar One-column matrix, the donor-derived haplotype of the parent.
#' @param n Number of progeny.
#' @param map A map from [build_map].
#' @return An `map$m` x `n` 0/1 matrix, one donor haplotype per progeny.
#' @export
backcross <- function(Hpar, n, map)
  meiosis(Hpar[, rep(1, n), drop = FALSE], matrix(0, map$m, n), map$r)

#' Genome shared by descent between donor and elite
#'
#' Donor and elite are both maize and often both from the same heterotic group,
#' so a fraction `s` of the genome is already identical by descent. Donor genome
#' inside a shared tract costs nothing, which is why `s` has to be modelled
#' explicitly. Sharing is drawn as a two-state Markov process in blocks and
#' then rejection-sampled so the realised fraction matches `s`.
#'
#' Every target is forced into a **non**-shared region: a target that were
#' already shared would not need introgressing.
#'
#' *Limitation:* real donor-elite sharing is structured by heterotic group, with
#' long tracts between related lines and near-zero sharing for exotic donors.
#' Forcing `s` to be exact also removes legitimate pair-to-pair variance.
#'
#' @param map A map from [build_map].
#' @param s Target shared fraction, in [0, 1).
#' @param mw Marker weights, see [marker_weights].
#' @param block_cM Mean block length in cM.
#' @param target_idx Marker indices of the targets, see [target_indices].
#' @param clear_cM Half-width in cM of the non-shared window around each target.
#' @param tol Tolerance on the realised fraction.
#' @param max_try Rejection-sampling attempts; the best draw is returned.
#' @return A logical vector of length `map$m`, TRUE where the genome is shared.
#' @export
make_shared_ibd <- function(map, s, mw, block_cM = 25, target_idx = NULL,
                            clear_cM = 10, tol = 0.01, max_try = 300) {
  if (s <= 0) return(rep(FALSE, map$m))
  L1 <- block_cM
  L0 <- L1 * (1 - s) / s
  best <- NULL
  bestd <- Inf
  for (tr in seq_len(max_try)) {
    st <- logical(map$m)
    for (i in seq_along(map$chr_len)) {
      k <- which(map$chr == i)
      p <- map$pos[k]
      Lc <- map$chr_len[i]
      cur <- stats::runif(1) < s
      x <- 0
      cuts <- numeric(0)
      sts <- logical(0)
      while (x < Lc) {
        cuts <- c(cuts, x)
        sts <- c(sts, cur)
        x <- x + stats::rexp(1, rate = 1 / if (cur) L1 else L0)
        cur <- !cur
      }
      st[k] <- sts[findInterval(p, cuts)]
    }
    for (ti in target_idx) {
      kk <- map$chr == map$chr[ti] & abs(map$pos - map$pos[ti]) <= clear_cM
      st[kk] <- FALSE
    }
    d <- abs(sum(mw[st]) - s)
    if (d < bestd) { bestd <- d; best <- st }
    if (d <= tol) break
  }
  best
}

# --- 3. Metrics ---------------------------------------------------------------

#' Donor dosage, donor-specific content and IBD with the elite
#'
#' Three views of the same haplotype. `donor_dosage()` is the genome fraction
#' physically inherited from the donor; `donor_specific()` counts only the part
#' outside the shared tracts, which is the part that actually costs elite
#' performance; `ibd_elite()` is its complement. Two identities hold exactly:
#'
#' \deqn{\mathrm{IBD} + \mathrm{donor\ specific} = 1, \qquad
#'       \mathrm{donor\ specific} = (1 - s)\,\mathrm{dosage}.}
#'
#' @param H An `m` x `n` 0/1 matrix of donor haplotypes.
#' @param w Marker weights, see [marker_weights].
#' @param sh Logical shared-genome mask, see [make_shared_ibd].
#' @param nh Ploidy divisor: 2 for one donor haplotype out of two.
#' @return A numeric vector of length `ncol(H)`.
#' @name donor_content
NULL

#' @rdname donor_content
#' @export
donor_dosage <- function(H, w, nh = 2) as.vector(crossprod(H, w)) / nh

#' @rdname donor_content
#' @export
donor_specific <- function(H, w, sh, nh = 2)
  as.vector(crossprod(H, w * !sh)) / nh

#' @rdname donor_content
#' @export
ibd_elite <- function(H, w, sh, nh = 2) 1 - donor_specific(H, w, sh, nh)

#' Multi-gene foreground test
#'
#' A plant passes only if it carries the donor allele at **all** targets. For
#' independent targets the frequency is `(1/2)^k`.
#'
#' @param H An `m` x `n` 0/1 matrix of donor haplotypes.
#' @param tg Target marker indices, see [target_indices].
#' @return A logical vector of length `ncol(H)`.
#' @export
foreground_ok <- function(H, tg) colSums(H[tg, , drop = FALSE]) == length(tg)

#' Total linkage drag
#'
#' The **union** of the donor segments containing a target, in cM. Two targets
#' inside one segment count once -- which is why linked targets in coupling
#' phase are cheaper than unlinked ones, not more expensive. This function is
#' therefore only correct under coupling phase: all targets from a single donor,
#' on the same haplotype.
#'
#' @param H An `m` x `n` 0/1 matrix of donor haplotypes.
#' @param map A map from [build_map].
#' @param tg Target marker indices, see [target_indices].
#' @return A numeric vector of drag in cM, length `ncol(H)`.
#' @export
drag_total <- function(H, map, tg) {
  res <- numeric(ncol(H))
  for (cc in unique(map$chr[tg])) {
    k <- which(map$chr == cc)
    e <- map$edges[[cc]]
    tl <- match(tg[map$chr[tg] == cc], k)
    sub <- H[k, , drop = FALSE]
    res <- res + apply(sub, 2, function(h) {
      tot <- 0
      seen <- logical(length(h))
      for (t in tl) {
        if (h[t] == 0 || seen[t]) next
        a <- t; while (a > 1 && h[a - 1] == 1) a <- a - 1
        b <- t; while (b < length(h) && h[b + 1] == 1) b <- b + 1
        seen[a:b] <- TRUE
        tot <- tot + e[b + 1] - e[a]
      }
      tot
    })
  }
  res
}

# --- 4. Analytical sizing -----------------------------------------------------

#' Smallest population giving `count` individuals of frequency `q`
#'
#' The cumulative binomial \eqn{P(\mathrm{Bin}(n, q) \ge \mathrm{count}) \ge P},
#' **not** \eqn{1 - (1-q)^n}, which only answers "at least one". Asking for 3
#' individuals instead of 1 costs about 2.1x, not 3x.
#'
#' @param q Genotype frequency.
#' @param count Individuals required.
#' @param P Probability at which the size is declared sufficient.
#' @param nmax Search ceiling; `NA` is returned above it.
#' @return An integer population size.
#' @examples
#' n_for_count(0.5^4, count = 1)   # foreground, four genes
#' n_for_count(0.25^4, count = 3)  # three quadruple homozygotes by selfing
#' n_for_count(0.5^4, count = 3)   # the same, by doubled haploids
#' @export
n_for_count <- function(q, count = 1, P = 0.95, nmax = 5e6) {
  if (q <= 0) return(NA_integer_)
  n <- count
  while (1 - stats::pbinom(count - 1, n, q) < P) {
    n <- n + max(1L, as.integer(n * 0.25))
    if (n > nmax) return(NA_integer_)
  }
  while (n > count && 1 - stats::pbinom(count - 1, n - 1, q) >= P) n <- n - 1L
  as.integer(n)
}

#' Haldane recombination fraction
#'
#' @param d_cM Map distance in cM.
#' @return The recombination fraction.
#' @export
haldane_r <- function(d_cM) 0.5 * (1 - exp(-2 * d_cM / 100))

#' Analytical sizing by stage
#'
#' Population sizes for each stage of a conversion programme, for 1 to `k_max`
#' genes: the backcross foreground, the backcross foreground plus one
#' recombinant in a flanking interval, fixation by selfing, and fixation by
#' doubled haploids.
#'
#' The DH column is the one that matters in maize. A DH line derived from a
#' BCnF1 gamete is homozygous at every locus, so it carries all `k` targets with
#' probability `(1/2)^k` rather than `(1/4)^k` -- 99 lines against 1610 plants
#' at four genes.
#'
#' @param k_max Largest number of genes.
#' @param flank_cM Flanking-marker distance for the recombinant column.
#' @param P Probability at which a size is declared sufficient.
#' @param n_keep Individuals required at the fixation stage.
#' @return A data.frame, one row per number of genes.
#' @examples
#' sizing_table()
#' @export
sizing_table <- function(k_max = 4, flank_cM = 5, P = 0.95, n_keep = 3) {
  r <- haldane_r(flank_cM)
  do.call(rbind, lapply(seq_len(k_max), function(k) data.frame(
    genes        = k,
    q_foreground = 0.5^k,
    n_BC_1plant  = n_for_count(0.5^k, 1, P),
    n_BC_1rec    = n_for_count(0.5^k * r, 1, P),
    q_F2         = 0.25^k,
    n_F2_1plant  = n_for_count(0.25^k, 1, P),
    n_F2_3plants = n_for_count(0.25^k, n_keep, P),
    q_DH         = 0.5^k,
    n_DH_3lines  = n_for_count(0.5^k, n_keep, P))))
}

#' Expectations under no background selection
#'
#' What a backcross programme delivers with no selection at all. This is the
#' reference the whole exercise turns on: `expected_ibd(3, 0.5)` is 0.969, so a
#' 90% recovery target at BC3 is already met before a single background marker
#' is scored, and an index that spends its decisive stage on background is
#' spending it on a criterion that does not bind.
#'
#' `expected_drag()` is `200/g` cM per gene, the infinite-chromosome
#' approximation; truncating at the telomeres gives a value about 15% lower.
#'
#' @param gen Backcross generation.
#' @param s Fraction of the genome shared by donor and elite.
#' @return A scalar.
#' @name mabc_expectations
#' @examples
#' expected_ibd(3, 0.5)
NULL

#' @rdname mabc_expectations
#' @export
expected_donor <- function(gen) 0.5^(gen + 1)

#' @rdname mabc_expectations
#' @export
expected_ibd <- function(gen, s) 1 - (1 - s) * expected_donor(gen)

#' @rdname mabc_expectations
#' @export
expected_drag <- function(gen) 200 / gen

#' Probability that two targets sit in the same donor segment
#'
#' Conditional on both targets being donor-derived. The conditioning is the
#' subtle part: requiring both to be donor forces an **even** number of
#' crossovers in the interval, so
#'
#' \deqn{P = e^{-L} / \left[(1 + e^{-2L})/2\right], \qquad L = d/100.}
#'
#' At 20 cM this is 0.980, not the 0.819 a naive \eqn{e^{-L}} gives. Getting
#' this wrong overstates the cost of stacking linked genes considerably.
#'
#' @param d_cM Distance between the two targets in cM.
#' @return A probability.
#' @examples
#' p_same_segment(c(20, 60, 400))
#' @export
p_same_segment <- function(d_cM) {
  L <- d_cM / 100
  exp(-L) / ((1 + exp(-2 * L)) / 2)
}

# --- 5. The decision layer ----------------------------------------------------

#' Last generation in which recombinant selection is applied
#'
#' @param strategy One of the keys in `mabc_opt$strategies`.
#' @param opt Options, see [mabc_opt].
#' @return An integer generation.
#' @export
strat_rec_until <- function(strategy, opt)
  switch(strategy,
         bg = 0L,
         rec12 = as.integer(opt$rec_until),
         rec_bg = as.integer(opt$n_bc),
         0L)

#' Select the plant to advance
#'
#' Four policies, all applied to foreground-positive plants only:
#'
#' \describe{
#'   \item{`bg`}{minimise background donor content.}
#'   \item{`rec12`}{recombinant selection in BC1-BC2 only (classical
#'     practice), then background.}
#'   \item{`rec_bg`}{recombinant selection throughout; truncate on drag, then
#'     **background** decides among the survivors.}
#'   \item{`rec_drag`}{recombinant selection throughout; **drag** decides,
#'     background breaks ties.}
#' }
#'
#' `rec_bg` is the natural-looking two-stage rule and it is wrong for the stated
#' objective: stage 2 discards stage 1, so the minimum-drag plant is retained
#' only by coincidence. Since donor dosage at BC3 is already 6.25% without any
#' selection, background is not the binding constraint. Paired re-runs (300
#' replicates, common random numbers, s = 0.60) of
#' P(drag <= 30 cM/gene AND IBD >= 0.90) at BC3 give
#' 0.813 against 0.997 at k = 3, N = 150, and 0.767 against 0.987 at k = 4,
#' N = 400. The cost is 1.5-2 points of IBD, on a constraint that was met in
#' every replicate with margin -- a free trade.
#'
#' @param H An `m` x `n` 0/1 matrix of donor haplotypes.
#' @param map A map from [build_map].
#' @param tg Target marker indices, see [target_indices].
#' @param w Marker weights, see [marker_weights].
#' @param sh Shared-genome mask, see [make_shared_ibd].
#' @param strategy One of `bg`, `rec12`, `rec_bg`, `rec_drag`.
#' @param gen Current backcross generation.
#' @param opt Options, see [mabc_opt].
#' @return A list with `idx` (the selected column, `NA` if the targets were
#'   lost) and `n_fg` (how many plants were foreground-positive).
#' @export
select_parent <- function(H, map, tg, w, sh, strategy, gen, opt) {
  fg <- which(foreground_ok(H, tg))
  if (length(fg) == 0) return(list(idx = NA_integer_, n_fg = 0))
  cand <- fg
  if (strategy == "rec_drag") {
    dl <- drag_total(H[, cand, drop = FALSE], map, tg)
    bg <- donor_specific(H[, cand, drop = FALSE], w, sh, 2)
    return(list(idx = cand[order(dl, bg)[1L]], n_fg = length(fg)))
  }
  if (gen <= strat_rec_until(strategy, opt) && length(cand) > 1) {
    dl <- drag_total(H[, cand, drop = FALSE], map, tg)
    cand <- cand[order(dl)[seq_len(max(1L, round(opt$rec_keep * length(cand))))]]
  }
  idx <- cand[which.min(donor_specific(H[, cand, drop = FALSE], w, sh, 2))]
  list(idx = idx, n_fg = length(fg))
}

#' Run one backcross programme
#'
#' One selected plant is advanced per generation, so every probability derived
#' from this function is a **single-lineage** probability. Real programmes
#' advance 3-10 plants, which both understates achievable progress and removes
#' lineage-level variance.
#'
#' @param n_sched Plants per backcross generation, e.g. `c(120, 120, 120)`.
#'   Its length is the number of backcrosses.
#' @param s Fraction of the genome shared by donor and elite.
#' @param strategy Selection policy, see [select_parent].
#' @param map A map from [build_map].
#' @param opt Options, see [mabc_opt].
#' @param tg Target marker indices, see [target_indices].
#' @param w Marker weights, see [marker_weights].
#' @param shared Optional shared-genome mask. Pass the same mask across
#'   strategies to compare them on common random numbers.
#' @return A list with `traj` (one row per generation), `Hfinal`, `shared` and
#'   `snap` (the selected haplotype of each generation).
#' @export
run_bc_program <- function(n_sched, s, strategy, map, opt, tg, w,
                           shared = NULL) {
  if (is.null(shared)) shared <- make_shared_ibd(map, s, w, opt$ibd_block_cM, tg)
  Hpar <- matrix(1, map$m, 1)
  ng <- length(n_sched)
  snap <- vector("list", ng)
  out <- data.frame(gen = integer(0), ibd = numeric(0), dose = numeric(0),
                    drag = numeric(0), n_fg = integer(0),
                    ibd_pop_mean = numeric(0), fail = logical(0))
  for (g in seq_len(ng)) {
    H <- backcross(Hpar, n_sched[g], map)
    sel <- select_parent(H, map, tg, w, shared, strategy, g, opt)
    if (is.na(sel$idx)) {
      out <- rbind(out, data.frame(gen = g, ibd = NA, dose = NA, drag = NA,
                                   n_fg = 0, ibd_pop_mean = NA, fail = TRUE))
      break
    }
    fg <- which(foreground_ok(H, tg))
    Hpar <- H[, sel$idx, drop = FALSE]
    snap[[g]] <- Hpar
    out <- rbind(out, data.frame(
      gen = g,
      ibd = ibd_elite(Hpar, w, shared, 2),
      dose = donor_dosage(Hpar, w, 2),
      drag = drag_total(Hpar, map, tg),
      n_fg = sel$n_fg,
      ibd_pop_mean = mean(ibd_elite(H[, fg, drop = FALSE], w, shared, 2)),
      fail = FALSE))
  }
  list(traj = out, Hfinal = Hpar, shared = shared, snap = snap)
}

#' Fixation by selfing: BCnF1 to BCnF2
#'
#' Backcrossing only ever asks for a heterozygote; fixation asks for a
#' homozygote at all `k` targets, frequency `(1/4)^k`. This is where the plant
#' numbers explode, and where doubled haploids -- frequency `(1/2)^k` -- collapse
#' the bottleneck. See [sizing_table].
#'
#' @param Hpar One-column matrix, the donor haplotype of the BCnF1 parent.
#' @param n_f2 Number of BCnF2 plants genotyped.
#' @param map A map from [build_map].
#' @param tg Target marker indices, see [target_indices].
#' @param w Marker weights, see [marker_weights].
#' @param sh Shared-genome mask, see [make_shared_ibd].
#' @param n_keep Homozygous plants required.
#' @return A list with `ok`, `n_hom` and `ibd` (mean over the best `n_keep`).
#' @export
selfing_step <- function(Hpar, n_f2, map, tg, w, sh, n_keep = 3) {
  G1 <- meiosis(Hpar[, rep(1, n_f2), drop = FALSE], matrix(0, map$m, n_f2), map$r)
  G2 <- meiosis(Hpar[, rep(1, n_f2), drop = FALSE], matrix(0, map$m, n_f2), map$r)
  hom <- which(colSums(G1[tg, , drop = FALSE] == 1 &
                         G2[tg, , drop = FALSE] == 1) == length(tg))
  if (length(hom) < n_keep)
    return(list(ok = FALSE, n_hom = length(hom), ibd = NA))
  D <- G1[, hom, drop = FALSE] + G2[, hom, drop = FALSE]
  ibd <- 1 - as.vector(crossprod(D, w * !sh)) / 2
  list(ok = TRUE, n_hom = length(hom),
       ibd = mean(sort(ibd, decreasing = TRUE)[seq_len(n_keep)]))
}

# --- 6. Summarising replicates ------------------------------------------------

#' Exact binomial confidence bounds
#'
#' Clopper-Pearson, base R only. Size a population on the **lower** bound, never
#' on the point estimate: with 30-150 replicates the standard error is 0.02-0.09,
#' so taking the first grid point whose estimate crosses the criterion is a
#' winner's curse and produces tables that are not monotone in `N`.
#'
#' @param x Number of successes.
#' @param n Number of trials.
#' @param conf Confidence level.
#' @return A probability.
#' @name clopper_pearson
#' @examples
#' cp_lo(30, 30)   # 30/30 still only bounds the rate below at 0.884
NULL

#' @rdname clopper_pearson
#' @export
cp_lo <- function(x, n, conf = 0.95)
  ifelse(x == 0, 0, stats::qbeta((1 - conf) / 2, pmax(x, 1e-9), n - x + 1))

#' @rdname clopper_pearson
#' @export
cp_hi <- function(x, n, conf = 0.95)
  ifelse(x == n, 1, stats::qbeta(1 - (1 - conf) / 2, x + 1, pmax(n - x, 1e-9)))

#' Summarise replicate backcross programmes
#'
#' Collapses the per-replicate trajectories of one cell (one `N`, one gene
#' number, one `s`) into a single row. Replicates that lost the targets count
#' as failures in every probability, which is why `p_ibd` and `p_drag` are
#' divided by the number of replicates and not by the number of survivors.
#'
#' @param A A data.frame of stacked `run_bc_program()$traj`, with a `rep` column.
#' @param opt Options, see [mabc_opt].
#' @param k Number of genes, used for the drag ceiling `drag_per_gene * k`.
#' @return A one-row data.frame.
#' @export
summarise_reps <- function(A, opt, k) {
  Ag <- A[A$gen == opt$n_bc, ]
  nrep <- length(unique(A$rep))
  ok <- Ag[!Ag$fail, ]
  dmax <- opt$drag_per_gene * k
  data.frame(
    p_lost = 1 - nrow(ok) / max(1, nrep),
    ibd    = if (nrow(ok)) mean(ok$ibd) else NA,
    ibd_sd = if (nrow(ok) > 1) stats::sd(ok$ibd) else NA,
    rpg    = if (nrow(ok)) mean(1 - ok$dose) else NA,
    drag   = if (nrow(ok)) mean(ok$drag) else NA,
    p_ibd  = if (nrow(ok)) sum(ok$ibd >= opt$target_ibd) / nrep else 0,
    p_drag = if (nrow(ok)) sum(ok$drag <= dmax) / nrep else 0,
    p_both = if (nrow(ok)) sum(ok$ibd >= opt$target_ibd &
                                 ok$drag <= dmax) / nrep else 0
  )
}
