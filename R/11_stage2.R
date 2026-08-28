# STAGE 2 -- optimized selection via differential evolution under a diversity constraint.
#
# Consumes the three objects from stage 1 and returns:
#   $selection  data.frame N x (hybrids + one 0/1 column per scenario)
#   $metrics    data.frame one scenario per row, with metrics and alpha loss
#   $z_scores   data.frame one scenario per row: each metric in s.d. from the
#               random-subset null (a metric without a baseline says nothing)
#   $ref        gd_ref, attainable alpha_max, n_sel

#' Rebuild the evaluation context from the stage-1 contract
#'
#' Delegates to [build_ctx] so the two constructors cannot drift apart.
#'
#' @param X Hybrid marker matrix from [stage1_build].
#' @param f Hybrid molecular coancestry matrix from [stage1_build].
#' @param hybrids Hybrid table from [stage1_build].
#' @param fL Optional line coancestry matrix.
#' @param weights Trait weights, or `NULL` for equal weights.
#' @return A `ctx` list, see [build_ctx].
#' @export
build_ctx_from_stage1 <- function(X, f, hybrids, fL = NULL, weights = NULL) {
  traits <- as.matrix(hybrids[, setdiff(names(hybrids),
                      c("hybrid", "line_A", "line_B")), drop = FALSE])
  if (is.null(weights)) weights <- rep(1, ncol(traits))
  stopifnot(length(weights) == ncol(traits))

  ped <- data.frame(a = hybrids$line_A, b = hybrids$line_B)
  build_ctx(X = X, f = f, G = NULL, traits = traits, ped = ped,
            n_lines = max(ped$a, ped$b), pool = NULL, fL = fL, cfg = NULL,
            weights = weights)
}


#' Stage 2: constrained selection across a grid of diversity budgets
#'
#' Runs the full selection pipeline: the random-subset null distribution, the
#' attainable `alpha` ceiling implied by truncation, a greedy warm start and
#' differential evolution for each `alpha` scenario, then the full metric panel
#' and its z-scores against the null.
#'
#' Every metric is reported against the random null, because a metric without a
#' baseline says nothing.
#'
#' @param X Hybrid marker matrix from [stage1_build].
#' @param f Hybrid molecular coancestry matrix from [stage1_build].
#' @param hybrids Hybrid table from [stage1_build].
#' @param n_sel Number of hybrids to select.
#' @param alphas Numeric vector of diversity-loss budgets, or `NULL` for an
#'   automatic grid up to the attainable ceiling.
#' @param weights Trait weights for the index, or `NULL` for equal weights.
#' @param fL Optional line coancestry matrix; enables the heterotic-group
#'   decomposition.
#' @param include_references Also evaluate random, truncation and
#'   maximum-diversity references.
#' @param B_null,B_full Replicates for the cheap and full null panels.
#' @param NP,itermax Differential-evolution population size and generations.
#' @param seed Random seed.
#' @param verbose Print progress.
#' @return A list with `selection` (0/1 columns per scenario), `metrics` (one
#'   row per scenario), `z_scores` (each metric in standard deviations from the
#'   random null) and `ref` (`gd_ref`, its Monte Carlo standard error,
#'   `alpha_max`, `n_sel`).
#' @seealso [stage1_build] for the previous stage.
#' @export
stage2_select <- function(X, f, hybrids, n_sel,
                          alphas = NULL, weights = NULL, fL = NULL,
                          include_references = TRUE,
                          B_null = 2000, B_full = 200, NP = 300, itermax = 2000,
                          seed = 1, verbose = TRUE) {
  set.seed(seed)
  ctx <- build_ctx_from_stage1(X, f, hybrids, fL, weights)
  say <- function(...) if (verbose) cat(...)

  # 1. Correct "0% loss" reference: RANDOM subsets of size n_sel, not the full
  #    population (which carries a sampling bias).
  say(sprintf("[1/4] null distribution by resampling (B = %d cheap, %d full)...\n",
              B_null, B_full))
  null <- null_distribution(ctx, n_sel, B = B_null, B_full = B_full, seed = seed)
  gd_ref <- null$gd_ref
  se <- null$gd_sd / sqrt(B_null)
  bias <- (gene_diversity(seq_len(ctx$N), ctx) - gd_ref) / gd_ref
  say(sprintf("      GD reference = %.5f (sd %.5f)\n", gd_ref, null$gd_sd))
  say(sprintf("      Monte-Carlo s.e. %.2g -> alpha differences below %.3f%% are noise\n",
              se, 100 * se / gd_ref))
  say(sprintf("      bias if using the population as reference: %.2f%%\n", 100 * bias))

  # 2. Attainable loss ceiling. Above it the constraint is inoperative.
  sel_trunc <- sel_truncation(ctx, n_sel)
  alpha_max <- alpha_loss(sel_trunc, ctx, gd_ref)
  say(sprintf("[2/4] maximum attainable alpha (pure truncation) = %.2f%%\n", 100 * alpha_max))

  if (is.null(alphas)) alphas <- seq(0, alpha_max, length.out = 5)
  inop <- alphas > alpha_max + 1e-9
  if (any(inop)) warning(sprintf(
    "inoperative alphas (above the %.2f%% ceiling): %s -- the constraint doesn't restrict anything in these scenarios",
    100 * alpha_max, paste0(round(100 * alphas[inop], 2), "%", collapse = ", ")))

  # 3. Warm start. Without this the DE ends up BELOW a plain greedy.
  say("[3/4] warm start (greedy) and DE per scenario...\n")
  ws <- c(0, 1e-4, 2e-4, 3e-4, 5e-4, 1e-3, 3e-3)
  seeds <- c(lapply(ws, function(w) sel_greedy(ctx, n_sel, w = w)),
             list(sel_truncation_cap(ctx, n_sel)))

  scenarios <- list()
  for (a in alphas) {
    idx <- sel_de(ctx, n_sel, alpha_max = a, gd_ref = gd_ref,
                  NP = NP, itermax = itermax, seeds = seeds)
    name <- sprintf("DE_alpha_%.2f", 100 * a)
    scenarios[[name]] <- idx
    say(sprintf("      %-16s index %.3f | alpha achieved %.3f%% | Ns %.4f | Ne_par %.1f\n",
                name, mean_index(idx, ctx), 100 * alpha_loss(idx, ctx, gd_ref),
                status_number(idx, ctx), ne_parents(idx, ctx)))
  }

  if (include_references) {
    scenarios <- c(scenarios, list(
      ref_truncation  = sel_trunc,
      ref_trunc_cap   = sel_truncation_cap(ctx, n_sel),
      ref_max_div     = sel_greedy(ctx, n_sel, w = 0),
      ref_random      = sample.int(ctx$N, n_sel)))
  }

  # 4. Metrics per scenario and the selection table.
  say("[4/4] metrics per scenario...\n")
  met <- t(sapply(scenarios, metrics_full, ctx = ctx))
  metrics <- data.frame(
    scenario = names(scenarios),
    alpha_max = c(alphas, rep(NA, length(scenarios) - length(alphas))),
    alpha = (gd_ref - met[, "GD"]) / gd_ref,
    met, row.names = NULL, check.names = FALSE)

  # Every metric in s.d. from the random-subset null. Ne_parents = 19 is
  # meaningless until you know random gives 69.
  z <- discriminatory_power(met, null)
  z_scores <- data.frame(scenario = names(scenarios), z,
                         row.names = NULL, check.names = FALSE)
  names(z_scores)[-1] <- paste0("z_", colnames(z))

  # The two-lens read (Meuwissen et al. 2020): the alpha constraint pins F_hom
  # and leaves F_drift free. A large gap is the bill you are not being shown.
  num <- function(v, fmt) ifelse(is.na(v), "     NA", sprintf(fmt, v))
  say("      F_hom is what the constraint pins; F_drift is what it does not:\n")
  for (i in seq_len(nrow(met)))
    say(sprintf("      %-16s F_hom %s | F_drift %s | gap %s | GD_BS %s\n",
                rownames(met)[i],
                num(met[i, "F_hom"], "%+.4f"), num(met[i, "F_drift"], "%.4f"),
                num(met[i, "cov_diag"], "%+.4f"), num(met[i, "GD_BS"], "%.4f")))

  selection <- hybrids
  for (nm in names(scenarios)) selection[[nm]] <- as.integer(seq_len(ctx$N) %in% scenarios[[nm]])

  # How many scenarios picked each hybrid: the robust ones show up in all of them.
  selection$n_scenarios <- rowSums(selection[, names(scenarios), drop = FALSE])

  list(selection = selection, metrics = metrics, z_scores = z_scores,
       ref = list(gd_ref = gd_ref, gd_se = se, alpha_max = alpha_max, n_sel = n_sel,
                  population_bias = bias))
}
