# STAGE 2 — optimized selection via differential evolution under a diversity constraint.
#
# Consumes the three objects from stage 1 and returns:
#   $selection  data.frame N x (hybrids + one 0/1 column per scenario)
#   $metrics    data.frame one scenario per row, with metrics and alpha loss
#   $ref        gd_ref, attainable alpha_max, n_sel

# Rebuilds the ctx object the metric functions expect.
build_ctx_from_stage1 <- function(X, f, hybrids, fL = NULL, weights = NULL) {
  traits <- as.matrix(hybrids[, setdiff(names(hybrids),
                      c("hybrid", "line_A", "line_B")), drop = FALSE])
  if (is.null(weights)) weights <- rep(1, ncol(traits))
  stopifnot(length(weights) == ncol(traits))

  ped <- data.frame(a = hybrids$line_A, b = hybrids$line_B)
  n_lines <- max(ped$a, ped$b)
  p_pop <- colMeans(X)

  list(X = X, f = f, traits = traits, ped = ped, fL = fL,
       n_lines = n_lines, N = nrow(X), m = ncol(X),
       index = as.numeric(scale(scale(traits) %*% weights)),
       maf_pop = pmin(p_pop, 1 - p_pop))
}

stage2_select <- function(X, f, hybrids, n_sel,
                          alphas = NULL, weights = NULL, fL = NULL,
                          include_references = TRUE,
                          B_null = 2000, NP = 300, itermax = 2000,
                          seed = 1, verbose = TRUE) {
  set.seed(seed)
  ctx <- build_ctx_from_stage1(X, f, hybrids, fL, weights)
  say <- function(...) if (verbose) cat(...)

  # 1. Correct "0% loss" reference: RANDOM subsets of size n_sel, not the full
  #    population (which carries a sampling bias).
  say(sprintf("[1/4] null distribution by resampling (B = %d)...\n", B_null))
  gd_rand <- replicate(B_null, gene_diversity(sample.int(ctx$N, n_sel), ctx))
  gd_ref <- mean(gd_rand)
  bias <- (gene_diversity(seq_len(ctx$N), ctx) - gd_ref) / gd_ref
  say(sprintf("      GD reference = %.5f (sd %.5f); bias if using the population: %.2f%%\n",
              gd_ref, sd(gd_rand), 100 * bias))

  # 2. Attainable loss ceiling. Above it the constraint is inoperative.
  sel_trunc <- sel_truncation(ctx, n_sel)
  alpha_max <- alpha_loss(sel_trunc, ctx, gd_ref)
  say(sprintf("[2/4] maximum attainable alpha (pure truncation) = %.2f%%\n", 100 * alpha_max))

  if (is.null(alphas)) alphas <- seq(0, alpha_max, length.out = 5)
  inop <- alphas > alpha_max + 1e-9
  if (any(inop)) warning(sprintf(
    "inoperative alphas (above the %.2f%% ceiling): %s — the constraint doesn't restrict anything in these scenarios",
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

  selection <- hybrids
  for (nm in names(scenarios)) selection[[nm]] <- as.integer(seq_len(ctx$N) %in% scenarios[[nm]])

  # How many scenarios picked each hybrid: the robust ones show up in all of them.
  selection$n_scenarios <- rowSums(selection[, names(scenarios), drop = FALSE])

  list(selection = selection, metrics = metrics,
       ref = list(gd_ref = gd_ref, alpha_max = alpha_max, n_sel = n_sel,
                  population_bias = bias))
}
