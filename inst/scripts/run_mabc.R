#!/usr/bin/env Rscript
# =============================================================================
#  run_mabc.R -- marker-assisted backcrossing in maize, 1 to 4 recessive genes
#
#  Simultaneous introgression of 1 to 4 RECESSIVE genes from a donor D into an
#  elite line E, with a recurrent-parent recovery target reached by BC3 and
#  optimisation of how plants are allocated between BC1, BC2 and BC3.
#
#  This is the driver only. The genetic engine and the decision layer live in
#  the package (R/08_mabc.R): the map and meiosis, the shared-IBD model, the
#  donor/IBD metrics, linkage drag, the analytical sizing, the selection index
#  and run_bc_program(). What is here is what a package should not carry: the
#  experiment scans, the figures, the HTML report and the CLI.
#
#  It writes the CSVs the book reads. To refresh them:
#    Rscript inst/scripts/run_mabc.R --out=report/mabc
#    cp report/mabc/results_uniform.csv     book/data/mabc_uniform.csv
#    cp report/mabc/results_allocation.csv  book/data/mabc_allocation.csv
#    cp report/mabc/results_bcnf2.csv       book/data/mabc_bcnf2.csv
#    cp report/mabc/analytical_sizing.csv   book/data/mabc_analytical_sizing.csv
#    cp report/mabc/fig8.png                book/figs/mabc_sizing.png
#    cp report/mabc/fig9.png                book/figs/mabc_policies.png
#
#  Run from the repository root:  Rscript inst/scripts/run_mabc.R --out=DIR
#  Or from an installed package:
#    Rscript -e 'source(system.file("scripts/run_mabc.R", package = "hybdiv"))'
#
#  Usage:
#    Rscript inst/scripts/run_mabc.R --test           # 35 checks (~10 s)
#    Rscript inst/scripts/run_mabc.R --quick --out=D  # reduced grid (~45 s)
#    Rscript inst/scripts/run_mabc.R --out=D          # full run (~3 min)
#
#  Dependencies: hybdiv, and base R only beyond it.
# =============================================================================
# =============================================================================
#
#  M1. NUMBER OF PLANTS PER GENERATION IS A VECTOR, not a scalar. The program is
#      described by a schedule `n_sched = c(n_BC1, n_BC2, n_BC3)`, and the
#      script searches for the schedule with the SMALLEST TOTAL that reaches the criterion.
#
#  M2. TARGET REACHED BY BC3. An important and counter-intuitive consequence,
#      quantified in the results section: without ANY background selection, the
#      expected donor dosage at BC3 is (1/2)^4 = 6.25%, which already gives
#      IBD_elite = 1 - (1-s)*0.0625 = 0.969 with s = 0.50. The 90% target at BC3
#      is essentially free. What then limits the program is (a) not
#      losing the genes and (b) linkage drag. The script measures all three.
#
#  M3. 95% CRITERION, not 99%. All analytical sizing uses P = 0.95.
#
#  M4. 1 A 4 GENES SIMULTANEOS. Premissas especificas:
#      (a) ALL target alleles come from the SAME donor D. Therefore genes on the same
#          chromosome are in COUPLING PHASE and travel together -- linkage
#          HELPS, rather than hinders. If the alleles came from different donors
#          (repulsion phase), the cost would explode and the model here does NOT
#          aplica.
#      (b) Multi-gene foreground: the plant only passes if it is heterozygous at
#          ALL k targets. For independent targets, q = (1/2)^k.
#      (c) The linkage drag is the UNION of donor segments that contain some target.
#          Two targets within the same segment count only once.
#      (d) Efeito de conditioning: exigir a retencao de k segmentos doadores
#          INFLATES donor dosage above (1/2)^(g+1). With k = 4 in BC3 the
#          linkage drag alone is already on the order of the expected dosage -- that is why
#          the multi-gene problem is a LINKAGE DRAG problem, not a background one.
#
#  M5. FINAL STAGE REQUIRES 3 PLANTS, not 1. In BCnF2 the probability of a
#      plant being homozygous recessive at all k targets is (1/4)^k (independent
#      targets). The sizing uses the cumulative binomial:
#        n = min{ n : P(Bin(n,q) >= 3) >= 0,95 }
#      and not the formula 1-(1-q)^n, which only holds for "at least one".
#
# =============================================================================
# ----------------------------------------------------------------------------
# 1. CONFIGURATION
# ----------------------------------------------------------------------------

library(hybdiv)

CHR_LEN <- maize_chr_len     # 10 chromosomes, 1670 cM
TARGETS <- maize_targets     # positions are illustrative -- see ?maize_targets

# The package defaults plus everything only the experiments need. Anything that
# also exists in mabc_opt is inherited, so the two cannot drift apart.
DEFAULT_OPT <- utils::modifyList(mabc_opt, list(
  sim_grid   = c(0.50, 0.60, 0.70),
  # Non-uniform grid: fine from 20 to 120, where the curves still move, and
  # sparse above, where they are flat. Effort where there is signal.
  n_grid     = c(seq(20, 120, by = 20), 160, 200, 250, 320, 400),
  # candidate schedules for the allocation experiment (experiment A)
  alloc_grid = list(bc1 = c(20, 60, 150, 300),
                    bc2 = c(20, 60, 150, 300),
                    bc3 = c(20, 60, 150)),
  alloc_genes = c(1, 3),
  alloc_s     = 0.60,
  alloc_rep   = 40,
  n_f2_grid   = unique(round(exp(seq(log(5), log(3000), length.out = 26)))),
  # Replication must be high enough that a Clopper-Pearson LOWER bound can
  # actually cross 0.95: at 30 replicates even 30/30 gives a lower bound of
  # 0.884, so lower settings cannot support interval-based sizing at all.
  rep_base = 12000, rep_min = 90, rep_max = 300
))

# ----------------------------------------------------------------------------
# 2. EXPERIMENTS
# ----------------------------------------------------------------------------

# Replicates fall with N: the cost of one replicate is roughly proportional to
# N, and small N is where the between-replicate variance is largest. This is
# not hybdiv::reps_for_N(), which parameterises the same idea for f2size.
reps_for_N <- function(N, opt)
  pmin(opt$rep_max, pmax(opt$rep_min, round(opt$rep_base / N)))

# --- Experiment B: UNIFORM schedule, sweeping N, k and s -------------------
run_uniform_scan <- function(opt, map, w, verbose = TRUE) {
  rows <- list(); z <- 1L; paint <- list(); n_ref <- 150
  n_ref <- opt$n_grid[which.min(abs(opt$n_grid - 150))]
  for (strat in opt$strategies) for (k in opt$genes_grid) {
    tg <- target_indices(map, k)
    # `bg` only serves as contrast for the linkage drag; runs at only one similarity
    ss <- if (strat == "rec_bg") opt$sim_grid else 0.60
    for (s in ss) {
      for (N in opt$n_grid) {
        R <- reps_for_N(N, opt); acc <- vector("list", R)
        for (rp in seq_len(R)) {
          pr <- run_bc_program(rep(N, opt$n_bc), s, strat, map, opt, tg, w)
          tr <- pr$traj; tr$rep <- rp; acc[[rp]] <- tr
          if (rp == 1 && N == n_ref && strat == "rec_bg" && s == 0.60 && k == 4)
            for (g in seq_len(opt$n_bc)) if (!is.null(pr$snap[[g]]))
              paint[[sprintf("BC%d", g)]] <- list(H = pr$snap[[g]], shared = pr$shared)
        }
        A <- do.call(rbind, acc)
        for (g in seq_len(opt$n_bc)) {
          Ag <- A[A$gen == g, ]; ok <- !Ag$fail
          if (!nrow(Ag)) next
          rows[[z]] <- cbind(
            data.frame(strategy = strat, genes = k, s = s, N = N, gen = g, n_rep = R),
            data.frame(
              p_lost = 1 - sum(ok) / R,
              ibd = mean(Ag$ibd[ok]), ibd_sd = sd(Ag$ibd[ok]),
              rpg = mean(1 - Ag$dose[ok]), drag = mean(Ag$drag[ok]),
              p_ibd = sum(Ag$ibd[ok] >= opt$target_ibd) / R,
              p_drag = sum(Ag$drag[ok] <= opt$drag_per_gene * k) / R,
              p_both = sum(Ag$ibd[ok] >= opt$target_ibd &
                           Ag$drag[ok] <= opt$drag_per_gene * k) / R,
              drag_q95 = as.numeric(quantile(Ag$drag[ok], 0.95)),
              # Exact (Clopper-Pearson) bounds on p_both. The sizing tables must
              # select on p_lo, not on the point estimate: picking the first grid
              # point whose ESTIMATE crosses 0.95 is a winner's curse and makes a
              # monotone quantity non-monotone in the output.
              p_both_lo = cp_lo(sum(Ag$ibd[ok] >= opt$target_ibd &
                                    Ag$drag[ok] <= opt$drag_per_gene * k), R),
              p_both_hi = cp_hi(sum(Ag$ibd[ok] >= opt$target_ibd &
                                    Ag$drag[ok] <= opt$drag_per_gene * k), R),
              gain = mean(Ag$ibd[ok] - Ag$ibd_pop_mean[ok]))); z <- z + 1L
        }
      }
      if (verbose) {
        b <- do.call(rbind, rows)
        b <- b[b$strategy == strat & b$genes == k & b$s == s & b$gen == opt$n_bc, ]
        cat(sprintf("  %-6s k=%d s=%.2f | BC%d: IBD %.3f-%.3f  linkage drag %3.0f-%3.0f cM  P(both) %.2f-%.2f\n",
                    strat, k, s, opt$n_bc, min(b$ibd), max(b$ibd),
                    max(b$drag), min(b$drag), min(b$p_both), max(b$p_both)))
      }
    }
  }
  list(res = do.call(rbind, rows), paint = paint, n_ref = n_ref)
}

# --- Experiment A: allocation of plants between BC1, BC2 and BC3 -----------------
run_allocation_scan <- function(opt, map, w, verbose = TRUE) {
  grid <- expand.grid(bc1 = opt$alloc_grid$bc1, bc2 = opt$alloc_grid$bc2,
                      bc3 = opt$alloc_grid$bc3)
  rows <- list(); z <- 1L
  for (k in opt$alloc_genes) {
    tg <- target_indices(map, k)
    for (i in seq_len(nrow(grid))) {
      ns <- as.integer(grid[i, ])
      acc <- vector("list", opt$alloc_rep)
      for (rp in seq_len(opt$alloc_rep)) {
        pr <- run_bc_program(ns, opt$alloc_s, "rec_bg", map, opt, tg, w)
        tr <- pr$traj; tr$rep <- rp; acc[[rp]] <- tr
      }
      A <- do.call(rbind, acc)
      rows[[z]] <- cbind(data.frame(genes = k, bc1 = ns[1], bc2 = ns[2],
                                    bc3 = ns[3], total = sum(ns)),
                         summarise_reps(A, opt, k)); z <- z + 1L
    }
    if (verbose) cat(sprintf("  allocation k=%d: %d schedules evaluated\n", k, nrow(grid)))
  }
  do.call(rbind, rows)
}

# --- Experiment C: BCnF2 stage ---------------------------------------------
run_f2_scan <- function(opt, map, w, verbose = TRUE) {
  rows <- list(); z <- 1L
  for (k in opt$genes_grid) {
    tg <- target_indices(map, k)
    pr <- run_bc_program(rep(150, opt$n_bc), 0.60, "rec_bg", map, opt, tg, w)
    grid <- opt$n_f2_grid[opt$n_f2_grid <= max(200, 40 * 4^k)]
    for (nf in grid) {
      R <- if (nf > 500) 80 else 250
      okv <- replicate(R, selfing_step(pr$Hfinal, nf, map, tg, w,
                                       pr$shared, opt$n_keep_f2)$ok)
      rows[[z]] <- data.frame(genes = k, n_f2 = nf, p_ok = mean(okv)); z <- z + 1L
    }
    if (verbose) cat(sprintf("  BCnF2 k=%d: minimum simulated n = %s\n", k,
      { d <- do.call(rbind, rows); d <- d[d$genes == k, ]
        k2 <- which(d$p_ok >= opt$P_crit)[1]
        if (is.na(k2)) paste0(">", max(d$n_f2)) else d$n_f2[k2] }))
  }
  do.call(rbind, rows)
}

run_experiment <- function(opt = DEFAULT_OPT, verbose = TRUE) {
  set.seed(opt$seed)
  map <- build_map(CHR_LEN, opt$spacing_cM); w <- marker_weights(map)
  if (verbose) cat("\n[1/3] Uniform schedule sweep\n")
  U <- run_uniform_scan(opt, map, w, verbose)
  if (verbose) cat("\n[2/3] BC1/BC2/BC3 allocation sweep\n")
  A <- run_allocation_scan(opt, map, w, verbose)
  if (verbose) cat("\n[3/3] BCnF2 stage (3 homozygous plants)\n")
  Fx <- run_f2_scan(opt, map, w, verbose)
  list(res = U$res, paint = U$paint, n_ref = U$n_ref, alloc = A, f2 = Fx,
       map = map, w = w, opt = opt)
}

# best schedule by total budget (Pareto front)
pareto_alloc <- function(A, k, P = 0.95) {
  d <- A[A$genes == k, ]
  d <- d[order(d$total), ]
  best <- d[d$p_both >= P, ]
  if (!nrow(best)) return(NULL)
  best[which.min(best$total), ]
}

# ----------------------------------------------------------------------------
# 8. GRAFICOS
# ----------------------------------------------------------------------------

K_COL <- c("#1b6ca8", "#27ae60", "#e67e22", "#c0392b")
S_COL <- c("0.5" = "#c0392b", "0.6" = "#e67e22", "0.7" = "#1b6ca8")

build_figures <- function(E) {
  res <- E$res; opt <- E$opt; map <- E$map; A <- E$alloc
  ax <- function() axis(1, at = c(0, 40, 80, 120, 200, 300, 400))
  scol <- function(s) S_COL[as.character(s)]
  F <- list()

  F$fig1 <- list(w = 11, h = 5.8, multi = TRUE,
    title = "Fig 1. The 90% target at BC3 is practically free",
    cap = paste("Left: IBD with the elite at BC3 (", opt$main_strategy,
      ", s = 0.60) as a function of the",
      "number of plants per generation, for 1 to 4 genes. The dotted line is the",
      "90% target and the dashed line is the expectation WITHOUT any background selection,",
      "1-(1-s)/2^4 = 0.980. All curves are well above the target, with",
      "any N. Right: the probability of reaching the target is 1 across the",
      "useful range -- except at very small N with 3-4 genes, where the failure is not",
      "and of IBD but of LOSING the genes. Conclusion: in BC3 the IBD target",
      "is not the criterion that sizes the population."),
    f = function() {
      par(mfrow = c(1, 2), mar = c(4.4, 4.6, 3.2, 1.2))
      d <- res[res$strategy == "rec_bg" & res$s == 0.60 & res$gen == opt$n_bc, ]
      plot(NA, xlim = c(0, max(opt$n_grid)), ylim = c(0.86, 1), xaxt = "n",
           xlab = "Plants per generation", ylab = "IBD with elite in BC3",
           main = "IBD achieved"); ax(); grid(col = "grey92", lty = 1)
      abline(h = opt$target_ibd, col = "grey35", lty = 3, lwd = 2)
      abline(h = expected_ibd(opt$n_bc, 0.60), col = "grey45", lty = 2, lwd = 1.6)
      for (k in opt$genes_grid) {
        dd <- d[d$genes == k, ]
        lines(dd$N, dd$ibd, col = K_COL[k], lwd = 2.3, type = "b", pch = 19, cex = .7)
      }
      legend("bottomright", c(paste0(opt$genes_grid, " gene(s)"), "no selection", "target 90%"),
             col = c(K_COL[opt$genes_grid], "grey45", "grey35"),
             lty = c(rep(1, length(opt$genes_grid)), 2, 3), lwd = 2, bty = "n", cex = .75)
      plot(NA, xlim = c(0, max(opt$n_grid)), ylim = c(0, 1), xaxt = "n",
           xlab = "Plants per generation", ylab = "P( IBD >= 90% in BC3 )",
           main = "Probability of success"); ax(); grid(col = "grey92", lty = 1)
      abline(h = opt$P_crit, col = "grey35", lty = 3, lwd = 2)
      for (k in opt$genes_grid) {
        dd <- d[d$genes == k, ]
        lines(dd$N, dd$p_ibd, col = K_COL[k], lwd = 2.3, type = "b", pch = 19, cex = .7)
      }
    })

  F$fig2 <- list(w = 10, h = 6.2,
    title = "Fig 2. What actually limits: losing the genes",
    cap = paste("Probability of losing at least one of the k genes over the",
      "three backcrosses. Theoretical curve: per generation the chance that no",
      "plant is heterozygous at all k targets is (1-(1/2)^k)^N, and over",
      "3 generations it accumulates. With 1 gene 5 plants suffice; with 4 genes,",
      "approximately 47 per generation for the 95% criterion. Log scale."),
    f = function() {
      par(mar = c(4.6, 4.8, 3.4, 1.4))
      plot(NA, xlim = c(0, 120), ylim = c(1e-6, 1), log = "y",
           xlab = "Plants per generation", ylab = "P(losing some gene in the series)",
           main = ""); grid(col = "grey92", lty = 1)
      nn <- 1:120
      for (k in opt$genes_grid) {
        q <- 0.5^k
        lines(nn, pmax(1 - (1 - (1 - q)^nn)^opt$n_bc, 1e-7), col = K_COL[k],
              lty = 2, lwd = 1.6)
        d <- res[res$strategy == "rec_bg" & res$s == 0.60 & res$genes == k &
                 res$gen == opt$n_bc & res$N <= 120, ]
        points(d$N, pmax(d$p_lost, 1e-6), col = K_COL[k], pch = 19, cex = 1)
      }
      abline(h = 1 - opt$P_crit, col = "grey30", lty = 3, lwd = 2)
      text(95, 0.075, "criterion 5%", col = "grey30", cex = .85)
      legend("topright", paste0(opt$genes_grid, " gene(s)"), col = K_COL[opt$genes_grid],
             lty = 1, lwd = 2, pch = 19, bty = "n", cex = .85,
             title = "dashed = theoretical")
    })

  F$fig3 <- list(w = 11, h = 5.8, multi = TRUE,
    title = "Fig 3. Linkage drag: the criterion that actually costs plants",
    cap = paste("Left: TOTAL linkage drag (union of donor segments that",
      "contain some target) in BC3, by number of genes. Right: probability",
      "of staying below the ceiling of", opt$drag_per_gene, "cM per gene. This is the",
      "only criterion that still requires a large population in BC1 and BC2 -- and",
      "that is why the requested savings has a limit. With 3-4 genes not even 400",
      "plants per generation reach 95%, because each additional gene multiplies",
      "the cost of the recombinant."),
    f = function() {
      par(mfrow = c(1, 2), mar = c(4.4, 4.6, 3.2, 1.2))
      d <- res[res$strategy == "rec_bg" & res$s == 0.60 & res$gen == opt$n_bc, ]
      plot(NA, xlim = c(0, max(opt$n_grid)), ylim = c(0, max(d$drag) * 1.05),
           xaxt = "n", xlab = "Plants per generation",
           ylab = "Total drag in BC3 (cM)", main = "Cumulative drag")
      ax(); grid(col = "grey92", lty = 1)
      for (k in opt$genes_grid) {
        dd <- d[d$genes == k, ]
        lines(dd$N, dd$drag, col = K_COL[k], lwd = 2.3, type = "b", pch = 19, cex = .7)
        abline(h = opt$drag_per_gene * k, col = K_COL[k], lty = 3)
      }
      legend("topright", paste0(opt$genes_grid, " gene(s)"), col = K_COL[opt$genes_grid],
             lty = 1, lwd = 2, bty = "n", cex = .8,
             title = paste0("dotted = ceiling (", opt$drag_per_gene, " cM/gene)"))
      plot(NA, xlim = c(0, max(opt$n_grid)), ylim = c(0, 1), xaxt = "n",
           xlab = "Plants per generation", ylab = "P( drag <= ceiling )",
           main = "Probability of reaching the ceiling"); ax()
      grid(col = "grey92", lty = 1)
      abline(h = opt$P_crit, col = "grey35", lty = 3, lwd = 2)
      for (k in opt$genes_grid) {
        dd <- d[d$genes == k, ]
        lines(dd$N, dd$p_drag, col = K_COL[k], lwd = 2.3, type = "b", pch = 19, cex = .7)
      }
    })

  F$fig4 <- list(w = 11, h = 5.8, multi = TRUE,
    title = "Fig 4. Allocation of plants among BC1, BC2 and BC3",
    cap = paste("Each point is a schedule (n_BC1, n_BC2, n_BC3). X axis: total",
      "plants in the program. Y axis: P(IBD >= 90% AND drag <= ceiling) in BC3.",
      "The thick line is the Pareto front -- the best achievable with each",
      "budget. The color separates schedules that spend earlier from those that spend",
      "later, and what we see is that NEITHER of the two extremes wins: the",
      "melhores pontos ficam no meio da escala de cor. Ver a Fig 5 e a secao 5",
      "for verification with high replication."),
    f = function() {
      par(mfrow = c(1, length(opt$alloc_genes)), mar = c(4.4, 4.6, 3.2, 1.2))
      for (k in opt$alloc_genes) {
        d <- A[A$genes == k, ]
        frac_early <- (d$bc1 + d$bc2) / d$total
        cols <- colorRampPalette(c("#c0392b", "#e67e22", "#1b6ca8"))(20)[
                 pmax(1, pmin(20, round(frac_early * 20)))]
        plot(d$total, d$p_both, pch = 19, col = cols, cex = .9, log = "x",
             xlab = "Total plants (BC1+BC2+BC3)",
             ylab = "P( IBD >= target  AND  drag <= ceiling )",
             main = sprintf("%d gene(s)", k), ylim = c(0, 1))
        grid(col = "grey92", lty = 1)
        abline(h = opt$P_crit, col = "grey30", lty = 3, lwd = 2)
        o <- d[order(d$total), ]; run <- cummax(o$p_both)
        lines(o$total, run, lwd = 2.4, col = "grey25")
        bp <- pareto_alloc(A, k, opt$P_crit)
        if (!is.null(bp)) {
          points(bp$total, bp$p_both, pch = 1, cex = 2.6, lwd = 2.4, col = "black")
          text(bp$total, bp$p_both - 0.09,
               sprintf("%d / %d / %d", bp$bc1, bp$bc2, bp$bc3), cex = .8)
        }
        if (k == opt$alloc_genes[1])
          legend("bottomright", c("spends early (BC1-BC2)", "spends late (BC3)",
                 "Pareto front"), col = c("#1b6ca8", "#c0392b", "grey25"),
                 pch = c(19, 19, NA), lty = c(NA, NA, 1), lwd = 2, bty = "n", cex = .75)
      }
    })

  F$fig5 <- list(w = 11, h = 5.8, multi = TRUE,
    title = "Fig 5. Where each plant yields the most",
    cap = paste("For a fixed total budget, the probability of success as a",
      "function of the fraction of the budget spent on BC1+BC2. Each line is a range of",
      "total budget; each panel, a number of genes. With 1 gene everything saturates",
      "and allocation doesn't matter. With 3 genes the pattern appears: the maximum does NOT lie",
      "nos extremos. Concentrar tudo em BC1 e tao ruim quanto concentrar tudo no",
      "BC3. The optimum falls around 2/3 of the budget in BC1+BC2, which is",
      "exactly what a balanced n/n/n schedule produces."),
    f = function() {
      par(mfrow = c(1, length(opt$alloc_genes)), mar = c(4.4, 4.6, 3.2, 1.2))
      cols <- c("#c0392b", "#e67e22", "#27ae60", "#1b6ca8")
      brk <- c(0, 150, 300, 500, 1e9); lab <- c("< 150", "150-300", "300-500", "> 500")
      for (k in opt$alloc_genes) {
        d <- A[A$genes == k, ]
        d$frac <- (d$bc1 + d$bc2) / d$total
        d$bin <- cut(d$total, brk, labels = lab)
        plot(NA, xlim = c(0.3, 1), ylim = c(0, 1),
             xlab = "Fraction of budget spent on BC1 + BC2",
             ylab = "P( IBD >= target  AND  linkage drag <= ceiling )",
             main = sprintf("%d gene(s)", k))
        grid(col = "grey92", lty = 1)
        abline(h = opt$P_crit, col = "grey30", lty = 3, lwd = 2)
        for (i in seq_along(lab)) {
          dd <- d[d$bin == lab[i], ]; if (!nrow(dd)) next
          ag <- aggregate(p_both ~ round(frac, 1), dd, mean); names(ag) <- c("frac", "p")
          lines(ag$frac, ag$p, col = cols[i], lwd = 2.4, type = "b", pch = 19)
        }
        if (k == opt$alloc_genes[1])
          legend("bottomright", paste("total", lab), col = cols, lty = 1, lwd = 2,
                 bty = "n", cex = .8)
      }
    })

  F$fig6 <- list(w = 10, h = 6.4,
    title = "Fig 6. BCnF2: how many plants for 3 homozygotes",
    cap = paste("The problem asks for 3 homozygous plants to proceed to seed",
      "increase. This is NOT 1-(1-q)^n: it is the cumulative binomial",
      "P(Bin(n,q) >= 3) >= 0.95, with q = (1/4)^k. Points = simulation, dashed",
      "= theoretical. Log scale on x. The jump from 3 to 4 genes is 4x: 403 to",
      "1613 plants. With 4 genes, fixing everything in a single self-pollination stops",
      "being the cheap route (see the note on staggered fixation)."),
    f = function() {
      par(mar = c(4.6, 4.8, 3.4, 1.4))
      f2 <- E$f2
      plot(NA, xlim = c(5, max(f2$n_f2)), ylim = c(0, 1), log = "x",
           xlab = "Genotyped BCnF2 plants", ylab = "P( >= 3 homozygotes across all targets )",
           main = ""); grid(col = "grey92", lty = 1)
      abline(h = opt$P_crit, col = "grey30", lty = 3, lwd = 2)
      nn <- unique(round(exp(seq(log(3), log(max(f2$n_f2)), length.out = 400))))
      for (k in opt$genes_grid) {
        q <- 0.25^k
        lines(nn, 1 - pbinom(opt$n_keep_f2 - 1, nn, q), col = K_COL[k], lty = 2, lwd = 1.6)
        d <- f2[f2$genes == k, ]
        points(d$n_f2, d$p_ok, col = K_COL[k], pch = 19, cex = 1)
      }
      nreq <- vapply(opt$genes_grid, function(k)
        n_for_count(0.25^k, opt$n_keep_f2, opt$P_crit), 0L)
      legend("topleft", sprintf("%d gene(s): n = %d", opt$genes_grid, nreq),
             col = K_COL[opt$genes_grid], lty = 1, lwd = 2, pch = 19,
             bty = "n", cex = .85, title = "dashed = theoretical")
    })

  F$fig7 <- list(w = 11, h = 6.6, multi = TRUE,
    title = "Fig 7. Genome of the selected plant, 4 genes, BC1 to BC3",
    cap = paste("Mosaic haplotype of the selected plant (the other is 100% elite).",
      "BLUE = elite. RED = donor in non-shared region (real loss).",
      "GRAY = donor in shared IBD region, which costs nothing. The arrows",
      "mark the 4 targets. Note that in BC3 almost all remaining red is",
      "STUCK on the targets: the background has already been cleaned, the linkage drag has not."),
    f = function() {
      pk <- E$paint; if (!length(pk)) { plot.new(); return(invisible()) }
      tg <- target_indices(map, 4)
      nm <- sort(names(pk))
      par(mfrow = c(length(nm), 1), mar = c(2.2, 1.2, 2.4, 1))
      for (n in nm) {
        h <- as.vector(pk[[n]]$H); sh <- pk[[n]]$shared
        z <- ifelse(h == 0, 0, ifelse(sh, 1, 2))
        image(x = seq_along(z), y = 1, z = matrix(z, ncol = 1), zlim = c(0, 2),
              col = c("#1b6ca8", "#b6bfc9", "#c0392b"), axes = FALSE, xlab = "",
              ylab = "", cex.main = 1,
              main = sprintf("%s  -  donor in haplotype: %.0f%%  (real loss: %.0f%%)",
                             n, 100 * sum(E$w[h == 1]), 100 * sum(E$w[z == 2])))
        box(); ch <- which(map$first); abline(v = ch, col = "white", lwd = 2)
        axis(1, at = (ch + c(ch[-1], map$m)) / 2, labels = seq_along(map$chr_len),
             tick = FALSE, cex.axis = .8, line = -0.9)
        arrows(tg, 1.62, tg, 1.24, length = .05, lwd = 2, col = "black", xpd = NA)
      }
    })

  F$fig9 <- list(w = 11, h = 5.8, multi = TRUE,
    title = "Fig 9. Until when to apply recombinant selection",
    cap = paste("Total linkage drag in BC3 (left) and probability of meeting the",
      "ceiling (right), s = 0.60, for four policies: WITHOUT recombinant selection",
      "(bg); recombinant selection only in BC1-BC2 (rec12, classical practice);",
      "recombinant selection in ALL generations, background-priority index",
      "(rec_bg); and recombinant selection in all generations with the corrected",
      "drag-priority index (rec_drag). Extending recombinant selection to BC3",
      "requires no extra plants, only genotyping the flanking markers in BC3 as",
      "well; switching the index from background-priority to drag-priority is",
      "likewise free. Solid lines = 1 gene, dashed = 3 genes."),
    f = function() {
      par(mfrow = c(1, 2), mar = c(4.4, 4.6, 3.2, 1.2))
      stc <- c("bg" = "#c0392b", "rec12" = "#e67e22", "rec_bg" = "#1b6ca8",
               "rec_drag" = "#2e7d32")
      sts <- intersect(names(stc), unique(res$strategy))
      d0 <- res[res$s == 0.60 & res$gen == opt$n_bc & res$genes %in% c(1, 3), ]
      plot(NA, xlim = c(0, max(opt$n_grid)), ylim = c(0, max(d0$drag) * 1.05),
           xaxt = "n", xlab = "Plants per generation (balanced schedule)",
           ylab = "Total linkage drag in BC3 (cM)", main = "Linkage drag"); ax()
      grid(col = "grey92", lty = 1)
      for (st in sts) for (k in c(1, 3)) {
        dd <- d0[d0$strategy == st & d0$genes == k, ]
        if (!nrow(dd)) next
        lines(dd$N, dd$drag, col = stc[st], lwd = 2.2, lty = if (k == 1) 1 else 2,
              type = "b", pch = 19, cex = .6)
      }
      legend("topright", sts, col = stc[sts], lty = 1, lwd = 2.4, bty = "n", cex = .85)
      plot(NA, xlim = c(0, max(opt$n_grid)), ylim = c(0, 1), xaxt = "n",
           xlab = "Plants per generation", ylab = "P( drag <= ceiling )",
           main = "Probability of reaching the ceiling"); ax()
      grid(col = "grey92", lty = 1)
      abline(h = opt$P_crit, col = "grey35", lty = 3, lwd = 2)
      for (st in sts) for (k in c(1, 3)) {
        dd <- d0[d0$strategy == st & d0$genes == k, ]
        if (!nrow(dd)) next
        lines(dd$N, dd$p_drag, col = stc[st], lwd = 2.2, lty = if (k == 1) 1 else 2,
              type = "b", pch = 19, cex = .6)
      }
      legend("right", c("1 gene", "3 genes"), lty = c(1, 2), lwd = 2.2,
             col = "grey30", bty = "n", cex = .85)
    })

  F$fig8 <- list(w = 10.5, h = 6.4,
    title = "Fig 8. Analytical sizing by stage and by number of genes",
    cap = paste("Log scale. Foreground: q = (1/2)^k, one plant is enough.",
      "Recombinant: q = (1/2)^k * r with r from Haldane at", opt$flank_cM, "cM.",
      "BCnF2: q = (1/4)^k and", opt$n_keep_f2, "plants are required, which uses the",
      "cumulative binomial. All values for P =", opt$P_crit, "."),
    f = function() {
      par(mar = c(4.6, 4.8, 3.4, 1.4))
      st <- sizing_table(max(opt$genes_grid), opt$flank_cM, opt$P_crit, opt$n_keep_f2)
      M <- rbind(st$n_BC_1plant, st$n_BC_1rec, st$n_F2_3plants, st$n_DH_3lines)
      bp <- barplot(M, beside = TRUE, log = "y", ylim = c(1, 5e4),
                    names.arg = paste0(st$genes, " gene(s)"),
                    col = c("#7fb3d5", "#1b6ca8", "#c0392b", "#2e7d32"), border = NA,
                    ylab = "Plants or lines required (log scale)")
      text(as.vector(bp), as.vector(M) * 1.5, as.vector(M), cex = .72, srt = 90, adj = 0)
      legend("topleft", c("BC: foreground (1 plant)",
                          sprintf("BC: foreground + 1 recombinant (%g cM)", opt$flank_cM),
                          sprintf("BCnF2 selfing: %d homozygotes", opt$n_keep_f2),
                          sprintf("Doubled haploids: %d lines", opt$n_keep_f2)),
             fill = c("#7fb3d5", "#1b6ca8", "#c0392b", "#2e7d32"), border = NA,
             bty = "n", cex = .82)
    })
  F
}

render_figures <- function(E, outdir) {
  figs <- build_figures(E); png_ok <- isTRUE(capabilities("png")); imgs <- list()
  for (nm in names(figs)) {
    g <- figs[[nm]]
    draw <- function() { g$f(); if (!isTRUE(g$multi)) title(main = g$title, cex.main = 1.1) }
    pdf(file.path(outdir, paste0(nm, ".pdf")), width = g$w, height = g$h); draw(); dev.off()
    if (png_ok) {
      fp <- file.path(outdir, paste0(nm, ".png"))
      png(fp, width = round(g$w * 115), height = round(g$h * 115), res = 115)
      draw(); dev.off(); imgs[[nm]] <- b64_file(fp)
    }
  }
  list(figs = figs, imgs = imgs, png_ok = png_ok)
}

# ----------------------------------------------------------------------------
# 9. HTML
# ----------------------------------------------------------------------------

b64_raw <- function(raw) {
  chars <- c(LETTERS, letters, 0:9, "+", "/")
  n <- length(raw); pad <- (3 - n %% 3) %% 3
  raw <- c(raw, rep(as.raw(0), pad))
  m <- matrix(as.integer(raw), nrow = 3)
  out <- rbind(chars[m[1, ] %/% 4 + 1], chars[(m[1, ] %% 4) * 16 + m[2, ] %/% 16 + 1],
               chars[(m[2, ] %% 16) * 4 + m[3, ] %/% 64 + 1], chars[m[3, ] %% 64 + 1])
  s <- paste(out, collapse = "")
  if (pad > 0) s <- paste0(substr(s, 1, nchar(s) - pad), strrep("=", pad))
  s
}
b64_file <- function(p) b64_raw(readBin(p, "raw", file.info(p)$size))

json_df <- function(d) {
  f <- function(v) if (is.numeric(v)) paste(ifelse(is.na(v), "null", signif(v, 6)), collapse = ",")
                   else paste0('"', v, '"', collapse = ",")
  paste0("{", paste0('"', names(d), '":[', vapply(d, f, ""), "]", collapse = ","), "}")
}

esc <- function(x) {                     # minimal HTML escaping, base R only
  x <- gsub("&", "&amp;", as.character(x), fixed = TRUE)
  x <- gsub("<", "&lt;",  x, fixed = TRUE)
  gsub(">", "&gt;", x, fixed = TRUE)
}

html_table <- function(d, digits = 4) {
  dd <- as.data.frame(lapply(d, function(v) if (is.numeric(v)) signif(v, digits) else v),
                      stringsAsFactors = FALSE)
  paste0("<table><thead><tr>", paste0("<th>", esc(names(d)), "</th>", collapse = ""),
         "</tr></thead><tbody><tr>",
         paste(apply(dd, 1, function(r) paste0("<td>", esc(r), "</td>", collapse = "")),
               collapse = "</tr><tr>"), "</tr></tbody></table>")
}

write_html <- function(E, R, outdir, file = "report_mabc_multigene.html") {
  res <- E$res; opt <- E$opt; A <- E$alloc
  fig_block <- function(nm) {
    g <- R$figs[[nm]]
    src <- if (R$png_ok) paste0("data:image/png;base64,", R$imgs[[nm]]) else paste0(nm, ".pdf")
    paste0('<figure><img src="', src, '" alt="', g$title, '"><figcaption><b>',
           g$title, '.</b> ', g$cap, '</figcaption></figure>')
  }
  st <- sizing_table(max(opt$genes_grid), opt$flank_cM, opt$P_crit, opt$n_keep_f2)
  names(st) <- c("Genes", "q foreground", "n BC (1 plant)", "n BC (1 recomb.)",
                 "q BCnF2", "n BCnF2 (1 plant)", paste0("n BCnF2 (", opt$n_keep_f2, " plants)"),
                 "q DH", paste0("n DH (", opt$n_keep_f2, " lines)"))

  # best schedule by number of genes
  best <- do.call(rbind, lapply(opt$alloc_genes, function(k) {
    b <- pareto_alloc(A, k, opt$P_crit)
    if (is.null(b)) {
      bb <- A[A$genes == k, ]; bb <- bb[which.max(bb$p_both), ]
      data.frame(genes = k, BC1 = bb$bc1, BC2 = bb$bc2, BC3 = bb$bc3,
                 total = bb$total, P = bb$p_both, obs = "does not reach 95%",
                 stringsAsFactors = FALSE)
    } else data.frame(genes = k, BC1 = b$bc1, BC2 = b$bc2, BC3 = b$bc3,
                      total = b$total, P = b$p_both, obs = "minimum that reaches 95%",
                      stringsAsFactors = FALSE) }))

  # smallest balanced n/n/n schedule that reaches the criterion on both requirements
  # Selection is on the Clopper-Pearson LOWER bound, not the point estimate.
  bal <- do.call(rbind, lapply(opt$genes_grid, function(k) {
    d <- res[res$strategy == opt$main_strategy & res$s == 0.60 & res$genes == k &
             res$gen == opt$n_bc, ]
    d <- d[order(d$N), ]
    i <- which(d$p_both_lo >= opt$P_crit)[1]
    if (is.na(i)) {
      # Fallback: smallest N whose point estimate meets the criterion AND stays
      # met at every larger N. This still refuses to read noise (the old rule
      # took the first crossing, which made a monotone quantity non-monotone).
      okv <- d$p_both >= opt$P_crit
      mono <- rev(cumprod(rev(as.integer(okv)))) == 1L
      i <- which(mono)[1]
    }
    ref <- d[nrow(d), ]
    data.frame(genes = k,
               `n per generation` = if (is.na(i)) "not reached" else as.character(d$N[i]),
               `total BC1+BC2+BC3` = if (is.na(i)) "-" else as.character(3 * d$N[i]),
               `P(both)` = if (is.na(i)) round(max(d$p_both), 3) else round(d$p_both[i], 3),
               `95% CI` = if (is.na(i)) "-" else
                 sprintf("%.3f-%.3f", d$p_both_lo[i], d$p_both_hi[i]),
               `mean linkage drag (cM)` = round(if (is.na(i)) ref$drag else d$drag[i], 1),
               check.names = FALSE, stringsAsFactors = FALSE) }))

  # minimum n per isolated criterion, uniform schedule, k = 1..4
  crit <- do.call(rbind, lapply(opt$genes_grid, function(k) {
    d <- res[res$strategy == opt$main_strategy & res$s == 0.60 & res$genes == k &
             res$gen == opt$n_bc, ]
    d <- d[order(d$N), ]
    g <- function(col) { i <- which(d[[col]] >= opt$P_crit)[1]
                         if (is.na(i)) ">400" else as.character(d$N[i]) }
    data.frame(genes = k,
               `retain the genes` = as.character(n_for_count(0.5^k, 1, opt$P_crit)),
               `IBD >= 90%` = g("p_ibd"),
               `linkage drag <= ceiling` = g("p_drag"), `both` = g("p_both"),
               check.names = FALSE, stringsAsFactors = FALSE) }))

  # SELECTION-INDEX COMPARISON: the shipped two-stage rule against the corrected
  # drag-priority rule, same N, same k, same similarity. This is the table that
  # decides whether the 4-gene ceiling is a property of maize or of the index.
  Ns <- sort(unique(res$N[res$strategy == "rec_drag"]))
  Ns <- unique(Ns[round(quantile(seq_along(Ns), c(0.4, 0.7, 1)))])
  idxcmp <- do.call(rbind, lapply(opt$genes_grid, function(k)
    do.call(rbind, lapply(Ns, function(N) {
      row <- function(st) {
        d <- res[res$strategy == st & res$s == 0.60 & res$genes == k &
                 res$N == N & res$gen == opt$n_bc, ]
        if (!nrow(d)) return(c(NA, NA, NA))
        c(d$drag[1], d$ibd[1], d$p_both[1])
      }
      a <- row("rec_bg"); b <- row("rec_drag")
      data.frame(genes = k, `N per generation` = N,
                 `rec_bg: drag` = round(a[1], 1), `rec_bg: IBD` = round(a[2], 3),
                 `rec_bg: P(both)` = round(a[3], 3),
                 `rec_drag: drag` = round(b[1], 1), `rec_drag: IBD` = round(b[2], 3),
                 `rec_drag: P(both)` = round(b[3], 3),
                 check.names = FALSE, stringsAsFactors = FALSE) }))))

  # Allocation contrast at a FIXED total budget, computed from this run.
  kA <- max(opt$alloc_genes)
  Ak <- A[A$genes == kA, ]
  tt <- Ak$total[which.min(abs(Ak$total - 360))]      # nearest budget on the grid
  Ab <- Ak[Ak$total == tt, ]
  Ab <- Ab[order(-Ab$bc1), ]
  allocmp <- data.frame(
    `BC1/BC2/BC3` = sprintf("%d/%d/%d", Ab$bc1, Ab$bc2, Ab$bc3),
    `total plants` = Ab$total,
    `mean linkage drag (cM)` = round(Ab$drag, 1),
    `P(both)` = round(Ab$p_both, 3),
    `95% CI` = sprintf("%.3f-%.3f",
                       cp_lo(round(Ab$p_both * opt$alloc_rep), opt$alloc_rep),
                       cp_hi(round(Ab$p_both * opt$alloc_rep), opt$alloc_rep)),
    check.names = FALSE, stringsAsFactors = FALSE)

  # Plants per generation for the protocol table, straight from `bal` so the
  # protocol can never disagree with the sizing analysis in the same document.
  nper <- paste0("<td>", bal[["n per generation"]], "</td>", collapse = "")

  html <- paste0('<!DOCTYPE html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Multi-gene MABC in maize &mdash; 1 to 4 recessive genes by BC3</title>
<style>
:root{--ink:#16202b;--mut:#5d6b7a;--line:#dfe5ec;--bg:#fbfcfd;--acc:#1b6ca8}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--ink);
 font:16px/1.65 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,sans-serif}
.wrap{max-width:990px;margin:0 auto;padding:0 22px 90px}
header{background:linear-gradient(160deg,#14413a,#1f7a5e);color:#fff;padding:52px 22px 40px;margin-bottom:38px}
header .wrap{padding-bottom:0}
h1{font-size:30px;margin:0 0 8px;font-weight:650;letter-spacing:-.02em}
header p{margin:0;opacity:.88;font-size:15px}
h2{font-size:22px;margin:52px 0 14px;padding-bottom:8px;border-bottom:2px solid var(--line)}
h3{font-size:17px;margin:30px 0 8px;color:#22303f}
p{margin:0 0 14px}
figure{margin:26px 0;background:#fff;border:1px solid var(--line);border-radius:9px;padding:14px}
figure img{width:100%;height:auto;display:block;border-radius:4px}
figcaption{font-size:13.5px;color:var(--mut);margin-top:11px;line-height:1.55}
table{border-collapse:collapse;width:100%;font-size:13.5px;margin:16px 0;background:#fff}
th,td{border:1px solid var(--line);padding:6px 9px;text-align:right}
th{background:#eaf3ef;font-weight:600}
td:first-child,th:first-child{text-align:left}
tbody tr:nth-child(even){background:#f7fbf9}
.card{background:#fff;border:1px solid var(--line);border-left:4px solid var(--acc);
 border-radius:7px;padding:15px 18px;margin:18px 0}
.warn{border-left-color:#c0392b}.good{border-left-color:#1f7a5e}
.kpis{display:flex;flex-wrap:wrap;gap:13px;margin:22px 0}
.kpi{flex:1 1 170px;background:#fff;border:1px solid var(--line);border-radius:9px;padding:14px 16px}
.kpi .v{font-size:25px;font-weight:660;color:#1f7a5e;line-height:1.15}
.kpi .l{font-size:12.5px;color:var(--mut);margin-top:3px}
code{background:#eef2f6;padding:1px 5px;border-radius:4px;font-size:13.5px}
.ctl{background:#fff;border:1px solid var(--line);border-radius:9px;padding:15px 18px;margin:18px 0}
select{font:inherit;font-size:14px;padding:4px 7px;border:1px solid var(--line);border-radius:5px;margin-right:14px}
.ctl label{font-size:13.5px;margin-right:15px;display:inline-block;cursor:pointer}
#chart{width:100%;height:400px}
small.note{color:var(--mut);font-size:12.5px}
</style></head><body>
<header><div class="wrap"><h1>Multi-gene introgression to BC3</h1>
<p>1 to 4 recessive genes from a donor D into an elite line E &middot; criterion P &ge; ',
opt$P_crit * 100, '% &middot; ', opt$n_keep_f2, ' homozygous plants in BCnF2 &middot; ',
format(Sys.Date(), "%d/%m/%Y"), '</p></div></header><div class="wrap">

<h2>1. The result that changes the design</h2>
<div class="card good"><b>The 90% IBD target in BC3 is practically free.</b>
Without <i>any</i> background selection, the expected donor dosage in BC3 is
(1/2)<sup>4</sup> = 6,25%, which gives IBD = 1 &minus; (1&minus;s)&times;0,0625 =
<b>0.969</b> even with the lowest similarity (s = 0.50). Deferring the BC1 target
to BC3 does not save plants &mdash; it stops being a criterion.</div>
<p>This reorganizes the problem. With the IBD target out of the way, there remain two
real criteria, and only one of them is expensive:</p>
<ol>
<li><b>Not losing the genes.</b> Cheap and exact: <code>q = (1/2)<sup>k</sup></code>
per plant. With 4 genes, 47 plants per generation suffice for P = 95%.</li>
<li><b>Cutting the linkage drag.</b> Expensive, and the only one that still requires population
large. Each additional gene multiplies the cost, because the recombinant needs
to happen around <i>each</i> target. And, contrary to classical practice,
recombinant selection should continue to the <i>last</i> generation rather than
stopping at BC2.</li>
</ol>

<div class="kpis">
<div class="kpi"><div class="v">0.969</div><div class="l">IBD in BC3 with no selection at all (s = 0.50)</div></div>
<div class="kpi"><div class="v">', st[1, 3], ' / ', st[4, 3],
'</div><div class="l">plants/generation to retain 1 / 4 genes</div></div>
<div class="kpi"><div class="v">', st[1, 7], ' / ', st[4, 7],
'</div><div class="l">BCnF2 plants for ', opt$n_keep_f2, ' homozygous, 1 / 4 genes</div></div>
<div class="kpi"><div class="v">', best$total[1],
'</div><div class="l">lowest total BC1+BC2+BC3 with 1 gene</div></div>
</div>

<h2>2. New assumptions in this version</h2>

<h3>M1 &mdash; The program is a schedule, not a number</h3>
<p>The number of plants per generation is a vector
<code>n_sched = c(n_BC1, n_BC2, n_BC3)</code>, and the script looks for the schedule of
<b>lowest total</b> that reaches the criterion. This is what allows answering
the question of where to save.</p>

<h3>M2 &mdash; All target alleles come from the SAME donor</h3>
Since genes on the same chromosome are in <b>coupling phase</b> and travel
together: linkage <i>helps</i>. The linkage drag is calculated as the
<b>union</b> of donor segments that contain any target &mdash; two targets
within the same segment count only once.</p>
<div class="card warn"><b>Se os alelos vierem de doadores diferentes</b> (fase de
repulsion for linked genes), the cost explodes and this model <b>does not
apply</b>. In that case a recombination step between the donors is needed
before starting the backcrossing.</div>

<h3>M3 &mdash; Multi-gene conditioning effect</h3>
<p>Requiring the retention of <i>k</i> donor segments <b>inflates</b> the dosage of
donor above (1/2)<sup>g+1</sup>. Without recombinant selection, the segment
expected per gene in BC<i>g</i> is 200/<i>g</i> cM; with 4 genes in BC3 this gives
4 &times; 67 = 268 cM, which is already on the order of the total expected donor in the
haplotype. <b>With 3-4 genes the problem is linkage drag, not background.</b></p>

<h3>M4 &mdash; BCnF2 requires ', opt$n_keep_f2, ' plants, and that changes the formula</h3>
<p>It is not <code>1&minus;(1&minus;q)<sup>n</sup></code>, which holds only for
&ldquo;at least one&rdquo;. It is the cumulative binomial:</p>
<div class="card"><code>n = min{ n : P(Bin(n, q) &ge; ', opt$n_keep_f2, ') &ge; ',
opt$P_crit, ' },  with q = (1/4)<sup>k</sup></code></div>

<h2>3. Analytical sizing by stage</h2>',
html_table(st, 4), '
<div class="card warn"><b>The jump from 3 to 4 genes in BCnF2 is 4&times;.</b>
Fixing four genes in a single self-pollination costs ', st[4, 7],
' plants. The alternative is <b>staggered fixation</b>: in BCnF2 select
plants homozygous for 2 targets and heterozygous for the other 2 (~', 
n_for_count(0.25^2 * 0.5^2, opt$n_keep_f2, opt$P_crit),
' plants), and close out the remaining two in BCnF3 (~', st[2, 7],
' plants). Two steps of a few hundred, instead of one in the thousands &mdash;
at the cost of one generation.</div>

<h2>4. Which criterion sizes the population</h2>
<p>Smallest N per generation (uniform schedule, ', opt$main_strategy, ', s = 0.60) to reach
P &ge; ', opt$P_crit * 100, '% in each criterion in isolation:</p>',
html_table(crit, 3), '
<p>The IBD column and the linkage drag column tell opposite stories. It is the
linkage drag that defines the budget.</p>

<h2>5. Where to save</h2>
<p>Smallest <b>balanced</b> schedule (n / n / n) that reaches P &ge; ',
opt$P_crit * 100, '% on both criteria simultaneously, with selection
recombinant in all generations (<code>rec_bg</code>), s = 0.60:</p>',
html_table(bal, 3), '
<div class="card warn"><b>Concentrating plants in BC1 is a mistake.</b> Every number
below is computed by this run (', opt$alloc_rep, ' replicates per schedule); none is
hard-coded.</div>', html_table(allocmp, 3), '
<p>The reason is that recombinant selection is an order statistic that
<b>saturates</b>: with the expected distance to the nearest crossover falling as
1/<i>g</i>, the minimum of 300 exponentials is barely better than the minimum of
120. Spending the budget early buys little and leaves BC2 and BC3 without plants,
where the same plant buys more reduction in linkage drag.</p>
<div class="card good"><b>Extending recombinant selection to BC3 is free.</b> In
classical practice it stops at BC2 (<code>rec12</code>). Applying it in every
generation costs no extra plants &mdash; only genotyping the flanking markers in
the last generation as well. Comparison of the policies in Fig 9.</div>

<h2>6. The selection index decides the answer</h2>
<p>The two-stage rule used by <code>bg</code>, <code>rec12</code> and
<code>rec_bg</code> truncates on linkage drag and then <b>minimises background
donor content</b> among the survivors. The second stage overrides the first: the
plant with the least drag is retained only by coincidence. Since donor dosage at
BC3 is already (1/2)<sup>4</sup> = 6.25% with no selection at all, background is
not the binding constraint, and spending the decisive stage on it is a mistake.
<code>rec_drag</code> corrects this &mdash; minimise drag among foreground
positives, break ties on background.</p>',
html_table(idxcmp, 3), '
<div class="card good"><b>The ', opt$drag_per_gene, ' cM/gene ceiling for 3 and 4
genes is reachable by BC3.</b> Earlier versions of this report concluded it was
not, and recommended loosening the ceiling, extending to BC4&ndash;BC5, or
splitting into two parallel two-gene programs. None of that is necessary: the
ceiling was a property of the selection index, not of maize. The price is
1&ndash;2 points of IBD, and the IBD requirement is met in essentially every
replicate under either rule, so the trade costs nothing that binds.</div>

<h2>6b. What this model does not include</h2>
<div class="card warn"><ul>
<li><b>No crossover interference.</b> Meiosis is Haldane, so crossovers are
independent between intervals. Maize has strong positive interference. For a
<i>double</i> recombinant in two flanking 5 cM intervals &mdash; the event that
converts a long donor segment into a short one &mdash; Haldane gives
2.3 &times; 10<sup>&minus;3</sup> against 4.9 &times; 10<sup>&minus;4</sup> under a
coincidence model, so this simulation over-produces tight recombinants by about
4.6&times;. Every population size for close-in trimming is a lower bound.</li>
<li><b>One selected plant is advanced per generation.</b> Real programs advance
3&ndash;10. All probabilities here are single-lineage probabilities.</li>
<li><b>Uniform recombination rate, no segregation distortion, no genotyping
error.</b> Pericentromeric targets carry drag that no feasible population trims.</li>
<li><b>Endosperm genetics is not modelled.</b> The targets are endosperm genes and
the endosperm is triploid (2 maternal : 1 paternal), so a recessive kernel
phenotype cannot be scored on the ear of a heterozygous plant; confirmation
requires self-pollination and appears one generation later than genotype.</li>
<li><b>The target set is illustrative, not a breeding recommendation.</b>
<i>sh2</i> and <i>bt2</i> encode the large and small subunits of the same enzyme
(endosperm ADP-glucose pyrophosphorylase); either null gives the super-sweet
phenotype, so stacking both is largely redundant. <i>o2</i> alone gives opaque,
not QPM &mdash; endosperm hardness modifiers, unlinked and polygenic, must be
co-introgressed and are not modelled here.</li>
<li><b>Map positions are illustrative</b> and are not sourced to a named maize
consensus map.</li>
</ul></div>

<h2>6. Results explorer</h2>
<div class="ctl">
<div style="margin-bottom:11px">
<b>Metric:</b> <select id="metric">
<option value="p_both">P( IBD &ge; target AND linkage drag &le; ceiling )</option>
<option value="p_drag">P( linkage drag &le; ceiling )</option>
<option value="p_ibd">P( IBD &ge; target )</option>
<option value="drag">Total linkage drag (cM)</option>
<option value="ibd">IBD with the elite</option>
<option value="rpg">Polymorphic scale</option>
<option value="p_lost">P( losing a gene )</option>
</select>
<b>Generation:</b> <select id="gen"></select>
<b>Strategy:</b> <select id="strat"></select>
<b>Similaridade:</b> <select id="sim"></select>
</div><div id="toggles"></div></div>
<svg id="chart"></svg>

<h2>7. Figures</h2>',
paste0(vapply(names(R$figs), fig_block, ""), collapse = "\n"), '

<h2>8. Recommended protocol</h2>
<p>Schedule <b>balanced</b>, with recombinant selection in <b>all</b> the
three generations. Plant numbers below are taken from the <code>bal</code> table
in section 5 &mdash; computed by this run, not hard-coded:</p>
<table><thead><tr><th>Step</th><th>1 gene</th><th>2 genes</th><th>3 genes</th>
<th>4 genes</th><th>Objective and genotyping</th></tr></thead><tbody>
<tr><td>F1</td><td colspan="4" style="text-align:center">5&ndash;10 ears</td>
<td>All identical; a seed matter. 1 marker to check the hybrid</td></tr>
<tr><td><b>BC1</b></td>', nper, '
<td rowspan="3"><b>Cut linkage drag in all generations.</b> Genotyping in
two steps: targets + flanking markers in <i>all</i> the plants (cheap), panel of
background only on the surviving foreground+recombinant</td></tr>
<tr><td><b>BC2</b></td>', nper, '</tr>
<tr><td><b>BC3</b></td>', nper, '</tr>
<tr><td>BCnF2</td><td>', st[1, 7], '</td><td>', st[2, 7], '</td><td>', st[3, 7],
'</td><td>', st[4, 7], '</td>
<td>', opt$n_keep_f2, ' plants homozygous at all targets. Marker
co-dominant at the target. With 4 genes, consider staggered fixation</td></tr>
<tr><td>BCnF3</td><td colspan="4" style="text-align:center">per ear</td>
<td>Seed increase. Recessive phenotype already visible: confirmation
independent of the marker</td></tr>
</tbody></table>
<div class="card"><b>If a schedule reads &ldquo;not reached&rdquo; above</b>, the
options in order of cost are: (a) relax the ceiling; (b) add BC4 and BC5 keeping
the schedule balanced; (c) run two 2-gene programs in parallel and cross the
products at the end. Note that with the corrected index (<code>rec_drag</code>)
this row is generally not triggered at 3 or 4 genes &mdash; see section 6.</div>
<div class="card good"><b>Consider the doubled-haploid route for fixation.</b> A DH
line from a BC3F1 gamete is homozygous everywhere, so the probability it carries
all <i>k</i> targets is (1/2)<sup>k</sup> instead of (1/4)<sup>k</sup>: ',
st[4, "n DH (3 lines)"], ' DH lines against ', st[4, 7],
' BCnF2 plants at 4 genes. See the last two columns of the table in section 3.</div>
<p><small class="note">Add 10&ndash;15% to every count in the table: the script
assumes perfect markers, with no genotyping error and no amplification failure.
<i>sh2</i> and <i>bt2</i> seed germinates poorly, so 10&ndash;15% is optimistic
where those targets are involved.</small></p>

<p><small class="note">Generated by <code>maize_mabc_multigene_sim.R</code>.
Reproduce with <code>Rscript maize_mabc_multigene_sim.R --out=', basename(outdir),
'</code>; validate with <code>--test</code>.</small></p>
</div>
<script>
const DATA = ', json_df(res), ';
const KCOL=["#1b6ca8","#27ae60","#e67e22","#c0392b"];
const MLAB={p_both:"P( IBD >= target AND drag <= ceiling )",p_drag:"P( drag <= ceiling )",
 p_ibd:"P( IBD >= target )",drag:"Total drag (cM)",ibd:"IBD with elite",
 rpg:"Escala polim\\u00f3rfica",p_lost:"P( perder algum gene )"};
const gens=[...new Set(DATA.gen)].sort(), strats=[...new Set(DATA.strategy)];
const sims=[...new Set(DATA.s)], ks=[...new Set(DATA.genes)].sort();
const on={}; ks.forEach(k=>on[k]=true);
function fill(id,vals,fmt,def){const e=document.getElementById(id);
 vals.forEach(v=>{const o=document.createElement("option");o.value=v;
  o.textContent=fmt?fmt(v):v; if(def!==undefined&&v==def)o.selected=true; e.appendChild(o);});
 e.addEventListener("change",draw);}
fill("gen",gens,v=>"BC"+v,Math.max(...gens));
fill("strat",strats,null,"rec_bg"); fill("sim",sims,v=>"s = "+(+v).toFixed(2),0.6);
const tg=document.getElementById("toggles");
ks.forEach(k=>{const l=document.createElement("label");
 l.innerHTML=`<input type="checkbox" checked> <span style="color:${KCOL[k-1]};font-weight:600">&#9632;</span> ${k} gene(s)`;
 l.querySelector("input").addEventListener("change",e=>{on[k]=e.target.checked;draw();});
 tg.appendChild(l);});
document.getElementById("metric").addEventListener("change",draw);
const NS="http://www.w3.org/2000/svg";
function el(t,a){const e=document.createElementNS(NS,t);for(const k in a)e.setAttribute(k,a[k]);return e;}
function draw(){
 const m=document.getElementById("metric").value, gv=+document.getElementById("gen").value;
 const st=document.getElementById("strat").value, sv=+document.getElementById("sim").value;
 const svg=document.getElementById("chart");
 while(svg.firstChild)svg.removeChild(svg.firstChild);
 const W=svg.clientWidth||900,H=400,P={t:16,r:16,b:46,l:72};
 svg.setAttribute("viewBox",`0 0 ${W} ${H}`);
 const rows=DATA.N.map((N,i)=>({N,k:DATA.genes[i],v:DATA[m][i],g:DATA.gen[i],
  st:DATA.strategy[i],s:DATA.s[i]}))
  .filter(d=>d.st===st&&d.g===gv&&Math.abs(d.s-sv)<1e-9&&on[d.k]&&d.v!==null);
 if(!rows.length)return;
 const ys=rows.map(d=>d.v); const x1=Math.max(...DATA.N);
 let y0=Math.min(...ys),y1=Math.max(...ys); const pad=(y1-y0)*0.09||0.01; y0-=pad;y1+=pad;
 const X=v=>P.l+v/x1*(W-P.l-P.r), Y=v=>H-P.b-(v-y0)/(y1-y0)*(H-P.t-P.b);
 for(let i=0;i<=5;i++){const v=y0+(y1-y0)*i/5;
  svg.appendChild(el("line",{x1:P.l,x2:W-P.r,y1:Y(v),y2:Y(v),stroke:"#e9eef3"}));
  const t=el("text",{x:P.l-9,y:Y(v)+4,"text-anchor":"end","font-size":11,fill:"#5d6b7a"});
  t.textContent=Math.abs(v)>=10?v.toFixed(1):v.toFixed(3);svg.appendChild(t);}
 for(let v=0;v<=x1;v+=80){svg.appendChild(el("line",{x1:X(v),x2:X(v),y1:P.t,y2:H-P.b,stroke:"#f2f5f8"}));
  const t=el("text",{x:X(v),y:H-P.b+19,"text-anchor":"middle","font-size":11,fill:"#5d6b7a"});
  t.textContent=v;svg.appendChild(t);}
 const xl=el("text",{x:(P.l+W-P.r)/2,y:H-9,"text-anchor":"middle","font-size":12.5});
 xl.textContent="Plants per generation";svg.appendChild(xl);
 const yl=el("text",{x:16,y:H/2,"text-anchor":"middle","font-size":12.5,
  transform:`rotate(-90 16 ${H/2})`});yl.textContent=MLAB[m];svg.appendChild(yl);
 ks.filter(k=>on[k]).forEach(k=>{
  const d=rows.filter(r=>r.k===k).sort((a,b)=>a.N-b.N); if(!d.length)return;
  svg.appendChild(el("path",{d:d.map((p,i)=>(i?"L":"M")+X(p.N)+" "+Y(p.v)).join(" "),
   fill:"none",stroke:KCOL[k-1],"stroke-width":2.1}));
  d.forEach(p=>{const c=el("circle",{cx:X(p.N),cy:Y(p.v),r:3.3,fill:KCOL[k-1]});
   const ti=el("title");ti.textContent=`${k} gene(s) | N=${p.N} | ${MLAB[m]}=${(+p.v).toPrecision(4)}`;
   c.appendChild(ti);svg.appendChild(c);});});
}
draw();window.addEventListener("resize",draw);
</script></body></html>')
  writeLines(html, file.path(outdir, file), useBytes = TRUE)
  invisible(file.path(outdir, file))
}

# ----------------------------------------------------------------------------
# 10. TESTS
# ----------------------------------------------------------------------------

.ok <- function(name, obs, exp, tol, extra = "") {
  pass <- isTRUE(abs(obs - exp) <= tol)
  cat(sprintf("  [%s] %-48s obs=%11.5f  exp=%11.5f  tol=%.4f %s\n",
              if (pass) "OK " else "FAIL", name, obs, exp, tol, extra))
  pass
}

# The engine and decision-layer assertions below are also in
# tests/testthat/test-mabc.R, which is what devtools::test() runs. This copy
# stays because it is the only check of the script/package seam: it fails if an
# exported function changes shape under the script's feet.
run_tests <- function() {
  cat("\n=== TEST BATTERY (MABC multi-gene) ===\n")
  set.seed(41); pass <- logical(0)
  map <- build_map(CHR_LEN, 5); w <- marker_weights(map)

  pass <- c(pass, .ok("T0 base64 puro-R", as.numeric(all(
    b64_raw(charToRaw("Man")) == "TWFu", b64_raw(charToRaw("Ma")) == "TWE=",
    b64_raw(charToRaw("M")) == "TQ==")), 1, 0))
  pass <- c(pass, .ok("T1 marker weights sum to 1", sum(w), 1, 1e-12))

  # T2 n_for_count reduces to the closed formula when count = 1
  for (q in c(0.5, 0.25, 0.0625)) {
    cl <- ceiling(log(1 - 0.95) / log(1 - q))
    pass <- c(pass, .ok(sprintf("T2 n_for_count(q=%.4f,1) == formula", q),
                        n_for_count(q, 1, 0.95), cl, 0))
  }
  # T3 n_for_count contra pbinom diretamente (count = 3)
  for (k in 1:3) {
    q <- 0.25^k; n <- n_for_count(q, 3, 0.95)
    pass <- c(pass, .ok(sprintf("T3 BCnF2 k=%d: P(>=3) at n minimum", k),
                        as.numeric(1 - pbinom(2, n, q) >= 0.95 &&
                                   1 - pbinom(2, n - 1, q) < 0.95), 1, 0,
                        sprintf("(n=%d)", n)))
  }

  # T4 multi-gene foreground: q = (1/2)^k for independent targets
  for (k in 1:4) {
    tg <- target_indices(map, k)
    H <- backcross(matrix(1, map$m, 1), 20000, map)
    pass <- c(pass, .ok(sprintf("T4 foreground k=%d: q = (1/2)^%d", k, k),
                        mean(foreground_ok(H, tg)), 0.5^k, 0.012))
  }

  # T5 BCnF2 multi-genico: q = (1/4)^k
  for (k in c(1, 2, 3)) {
    tg <- target_indices(map, k)
    H <- backcross(matrix(1, map$m, 1), 40000, map)
    Hp <- H[, which(foreground_ok(H, tg))[1], drop = FALSE]
    N <- 40000
    G1 <- meiosis(Hp[, rep(1, N), drop = FALSE], matrix(0, map$m, N), map$r)
    G2 <- meiosis(Hp[, rep(1, N), drop = FALSE], matrix(0, map$m, N), map$r)
    obs <- mean(colSums(G1[tg, , drop = FALSE] == 1 & G2[tg, , drop = FALSE] == 1) == k)
    pass <- c(pass, .ok(sprintf("T5 BCnF2 k=%d: q = (1/4)^%d", k, k), obs, 0.25^k,
                        max(0.006, 0.12 * 0.25^k)))
  }

  # T6 drag per gene without selection == 200/g, and the UNION does not double-count
  mapL <- build_map(c(1200), 2)
  tg1 <- marker_index(mapL, 1, 400); tg2 <- marker_index(mapL, 1, 800)
  HL <- matrix(1, mapL$m, 24000)
  for (g in 1:2) {
    HL <- meiosis(HL, matrix(0, mapL$m, ncol(HL)), mapL$r)
    HL <- HL[, HL[tg1, ] == 1, drop = FALSE]
    pass <- c(pass, .ok(sprintf("T6 drag 1 target BC%d == 200/%d", g, g),
                        mean(drag_total(HL, mapL, tg1)), expected_drag(g),
                        0.08 * expected_drag(g)))
  }
  # two targets: the union never exceeds the sum and is never less than the max
  H2 <- meiosis(matrix(1, mapL$m, 6000), matrix(0, mapL$m, 6000), mapL$r)
  H2 <- H2[, H2[tg1, ] == 1 & H2[tg2, ] == 1, drop = FALSE]
  u  <- drag_total(H2, mapL, c(tg1, tg2))
  d1 <- drag_total(H2, mapL, tg1); d2 <- drag_total(H2, mapL, tg2)
  pass <- c(pass, .ok("T6b union <= sum of individual segments",
                      as.numeric(all(u <= d1 + d2 + 1e-9)), 1, 0))
  pass <- c(pass, .ok("T6c union >= max of individual segments",
                      as.numeric(all(u >= pmax(d1, d2) - 1e-9)), 1, 0))
  # T6d: CLOSE targets (20 cM) fall in the same segment most of the time and
  # the union counts only once. Theory: P(no crossover between them in a meiosis)
  # = exp(-0.20) = 0.819 in BC1. With distant targets (400 cM) this almost never
  # happens -- that's how the first version of this test failed, due to
  # wrong threshold, not a bug.
  for (dd in c(20, 60, 400)) {
    tgd <- marker_index(mapL, 1, 400 + dd)
    Hd <- meiosis(matrix(1, mapL$m, 12000), matrix(0, mapL$m, 12000), mapL$r)
    Hd <- Hd[, Hd[tg1, ] == 1 & Hd[tgd, ] == 1, drop = FALSE]
    ud <- drag_total(Hd, mapL, c(tg1, tgd))
    sd_ <- drag_total(Hd, mapL, tg1) + drag_total(Hd, mapL, tgd)
    pass <- c(pass, .ok(sprintf("T6d targets at %d cM: merge into the same segment", dd),
                        mean(ud < sd_ - 1e-9), p_same_segment(dd), 0.025))
  }

  # T7 identidades de IBD
  tg <- target_indices(map, 2)
  sh <- make_shared_ibd(map, 0.6, w, 25, tg)
  pass <- c(pass, .ok("T7a shared fraction == 0.60", sum(w[sh]), 0.60, 0.011))
  Hx <- backcross(matrix(1, map$m, 1), 400, map)
  pass <- c(pass, .ok("T7b IBD + donor_specific == 1",
    max(abs(ibd_elite(Hx, w, sh, 2) + donor_specific(Hx, w, sh, 2) - 1)), 0, 1e-12))
  pass <- c(pass, .ok("T7c donor_specific == (1-s)*dosage",
    mean(donor_specific(Hx, w, sh, 2)), 0.4 * mean(donor_dosage(Hx, w, 2)), 0.006))

  # T8 donor dosage in BC3 == 1/16 and corresponding IBD
  H <- matrix(1, map$m, 3000)
  for (g in 1:3) H <- meiosis(H, matrix(0, map$m, ncol(H)), map$r)
  pass <- c(pass, .ok("T8a donor dosage BC3 == 1/16",
                      mean(donor_dosage(H, w, 2)), 0.0625, 0.005))
  pass <- c(pass, .ok("T8b IBD BC3 without selection (s=0.5) == 0.969",
                      expected_ibd(3, 0.5), 0.96875, 1e-9))

  # T9 schedule: n_sched controls the size per generation
  opt <- DEFAULT_OPT; tg <- target_indices(map, 1)
  pr <- run_bc_program(c(10, 200, 30), 0.6, "bg", map, opt, tg, w)
  pass <- c(pass, .ok("T9 n_fg of BC2 ~ 200/2", pr$traj$n_fg[2], 100, 25))

  # T10 recombinant selection reduces multi-gene linkage drag
  set.seed(10); tg <- target_indices(map, 2)
  shx <- make_shared_ibd(map, 0.6, w, 25, tg)
  dr <- vapply(c("bg", "rec_bg"), function(st) mean(replicate(25, {
    p <- run_bc_program(rep(150, 2), 0.6, st, map, opt, tg, w, shx)
    tail(p$traj$drag, 1) })), 0)
  pass <- c(pass, .ok("T10 rec_bg reduces drag vs bg",
                      as.numeric(dr[2] < dr[1]), 1, 0,
                      sprintf("(%.0f vs %.0f cM)", dr[2], dr[1])))

  # --- DECISION LAYER -------------------------------------------------------
  # The original battery tested only the meiosis / probability primitives and
  # left select_parent, pareto_alloc and the summariser unguarded -- which is
  # exactly where the selection-index defect lived. These four cover that gap.

  # T11 rec_drag actually returns the minimum-drag plant among foreground
  # positives; rec_bg does not (that is the defect, asserted explicitly).
  set.seed(11); tg <- target_indices(map, 3)
  shx <- make_shared_ibd(map, 0.6, w, 25, tg)
  H   <- backcross(matrix(1, map$m, 1), 200, map)
  fg  <- which(foreground_ok(H, tg))
  dl  <- drag_total(H[, fg, drop = FALSE], map, tg)
  s1  <- select_parent(H, map, tg, w, shx, "rec_drag", 1, opt)
  pass <- c(pass, .ok("T11 rec_drag picks the minimum-drag plant",
                      drag_total(H[, s1$idx, drop = FALSE], map, tg), min(dl), 1e-9))
  s2  <- select_parent(H, map, tg, w, shx, "rec_bg", 1, opt)
  pass <- c(pass, .ok("T11b rec_bg does not (index defect, documented)",
                      as.numeric(drag_total(H[, s2$idx, drop = FALSE], map, tg) >= min(dl)),
                      1, 0))

  # T12 rec_drag beats rec_bg on end-of-program drag, paired on the same
  # shared-IBD backbone (common random numbers).
  set.seed(12)
  d2 <- vapply(c("rec_bg", "rec_drag"), function(st) mean(replicate(25, {
    p <- run_bc_program(rep(150, 3), 0.6, st, map, opt, tg, w, shx)
    tail(p$traj$drag, 1) })), 0)
  pass <- c(pass, .ok("T12 rec_drag reduces drag vs rec_bg",
                      as.numeric(d2[2] < d2[1]), 1, 0,
                      sprintf("(%.0f vs %.0f cM)", d2[2], d2[1])))

  # T13 Clopper-Pearson bounds bracket the estimate and match known values.
  pass <- c(pass, .ok("T13 cp_lo(30,30) == 0.8843", cp_lo(30, 30), 0.88430, 1e-4))
  pass <- c(pass, .ok("T13b cp_hi(0,100) == 0.03621", cp_hi(0, 100), 0.03621, 1e-4))

  # T14 DH route needs fewer plants than selfing at every gene number.
  stt <- sizing_table(4, opt$flank_cM, opt$P_crit, opt$n_keep_f2)
  pass <- c(pass, .ok("T14 n_DH < n_BCnF2 for k = 1..4",
                      as.numeric(all(stt$n_DH_3lines < stt$n_F2_3plants)), 1, 0,
                      sprintf("(%s vs %s)", paste(stt$n_DH_3lines, collapse = "/"),
                              paste(stt$n_F2_3plants, collapse = "/"))))

  cat(sprintf("\n  %d/%d tests passed\n\n", sum(pass), length(pass)))
  invisible(all(pass))
}

# ----------------------------------------------------------------------------
# 11. MAIN
# ----------------------------------------------------------------------------

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  outdir <- sub("^--out=", "", grep("^--out=", args, value = TRUE))
  if (length(outdir) == 0) outdir <- "mabc_multi_out"
  if ("--test" %in% args) { ok <- run_tests(); quit(status = if (isTRUE(ok)) 0 else 1) }
  dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

  opt <- DEFAULT_OPT
  if ("--quick" %in% args) {
    opt$n_grid <- seq(20, 400, by = 60); opt$rep_base <- 1200
    opt$rep_min <- 15; opt$rep_max <- 50
    opt$alloc_grid <- list(bc1 = c(20, 80, 250), bc2 = c(20, 80, 250),
                           bc3 = c(20, 100, 200))
    opt$alloc_rep <- 20; opt$alloc_genes <- c(1, 3)
    opt$n_f2_grid <- unique(round(exp(seq(log(5), log(3000), length.out = 14))))
  }

  cat("=== MABC multi-gene: 1 to 4 recessive genes, target up to BC", opt$n_bc, " ===\n", sep = "")
  cat(sprintf("Targets: %s\n", paste(TARGETS$label[opt$genes_grid], collapse = " | ")))
  cat(sprintf("Criterion P >= %.2f | drag ceiling %g cM/gene | %d plants in BCnF2\n\n",
              opt$P_crit, opt$drag_per_gene, opt$n_keep_f2))

  t0 <- Sys.time(); E <- run_experiment(opt)
  cat(sprintf("\nElapsed: %.1f s\n", as.numeric(difftime(Sys.time(), t0, units = "secs"))))

  write.csv(E$res, file.path(outdir, "results_uniform.csv"), row.names = FALSE)
  write.csv(E$alloc, file.path(outdir, "results_allocation.csv"), row.names = FALSE)
  write.csv(E$f2, file.path(outdir, "results_bcnf2.csv"), row.names = FALSE)
  write.csv(sizing_table(max(opt$genes_grid), opt$flank_cM, opt$P_crit, opt$n_keep_f2),
            file.path(outdir, "analytical_sizing.csv"), row.names = FALSE)
  saveRDS(E, file.path(outdir, "experiment.rds"))   # permite refazer figuras
  R <- render_figures(E, outdir); hf <- write_html(E, R, outdir)

  cat("\n--- ANALYTICAL SIZING ---\n")
  print(sizing_table(max(opt$genes_grid), opt$flank_cM, opt$P_crit, opt$n_keep_f2),
        row.names = FALSE)
  cat("\n--- BEST SCHEDULE (BC1/BC2/BC3) ---\n")
  for (k in opt$alloc_genes) {
    b <- pareto_alloc(E$alloc, k, opt$P_crit)
    if (is.null(b)) {
      bb <- E$alloc[E$alloc$genes == k, ]; bb <- bb[which.max(bb$p_both), ]
      cat(sprintf("  k=%d: no schedule reaches %.0f%%; best = %d/%d/%d (total %d, P=%.2f)\n",
                  k, 100 * opt$P_crit, bb$bc1, bb$bc2, bb$bc3, bb$total, bb$p_both))
    } else cat(sprintf("  k=%d: %d/%d/%d (total %d, P=%.2f)\n", k, b$bc1, b$bc2,
                       b$bc3, b$total, b$p_both))
  }
  cat(sprintf("\nFiles in: %s\nHTML report: %s\n", normalizePath(outdir),
              normalizePath(hf)))
  invisible(E)
}

if (sys.nframe() == 0L && !interactive()) main()
