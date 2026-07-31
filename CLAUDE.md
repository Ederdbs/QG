# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Hybrid selection under a diversity constraint (quantitative/population genetics). Given a
pool of hybrids (crosses between two heterotic groups), select `n_sel` of them that maximize
a multi-trait genomic index while constraining the loss of molecular diversity (gene diversity,
`GD = 1 - theta`) relative to a random-sampling baseline. Selection is solved via differential
evolution (DE) with a warm start from greedy heuristics, benchmarked against truncation, greedy,
and a continuous OCS relaxation (upper bound).

## Commands

```
Rscript tests/test_metrics.R   # sanity checks / test suite (~40 s) — run after any change to R/
Rscript run_all.R              # two-stage pipeline -> report/ (~4 min)
Rscript run_benchmark.R        # metrics benchmark + plots -> report/ (~6 min)
```

There is no test framework — `tests/test_metrics.R` is plain `stopifnot`/assert-style checks
sourced against all of `R/`. There's no way to run a single test in isolation; the whole file
runs top to bottom and each check depends on `ctx`/`st1` built earlier in the same script.

All three scripts do `for (f in list.files("R", full.names = TRUE)) source(f)` — there's no
package structure, no `library()` calls for the project's own code, no `NAMESPACE`. Sourcing
order is alphabetical by filename, which is why files are numbered (`00_`, `01_`, ...).

Outputs go to `report/` and `data/` (both gitignored, created on demand).

## Architecture: the two-stage contract

Everything downstream of stage 1 talks only through three objects — this is the seam meant for
swapping in real data:

```
$X        hybrid marker matrix, N x m, values in {0, 0.5, 1}
$f        Caballero & Toro molecular coancestry, N x N, values in [0, 1]
$hybrids  data.frame N x (3 + n_traits): hybrid id, line_A, line_B, predicted traits
$fL       (optional) coancestry BETWEEN LINES — only enables theta_A/theta_B/theta_AB
```

- **Stage 1** (`R/10_stage1.R`): `stage1_simulate()` for the simulation, or `stage1_build(X, ped,
  traits, fL)` for real data (accepts 0/1/2 or 0/0.5/1 marker coding, auto-detects and rescales).
- **Stage 2** (`R/11_stage2.R`): `stage2_select(X, f, hybrids, n_sel, alphas, weights, fL)` runs
  the full pipeline — null distribution, attainable alpha ceiling, DE per alpha scenario, metrics
  — and returns `$selection` (0/1 columns per scenario), `$metrics` (one row per scenario), `$ref`.
- Both stages rebuild an internal `ctx` list (`build_ctx` / `build_ctx_from_stage1`) that all
  metric and selection functions take as their second argument.

To point this at real data, only `load_data()` in `R/00_data.R` and the `stage1_build()` call
need to change — everything else operates on `ctx`/`X`/`f`/`hybrids` and is agnostic to origin.

## Key design decisions (don't relitigate these)

- **Diversity uses `f` (molecular coancestry), never VanRaden `G`.** `G` is centered on its own
  population by construction, so `sum(G) == 0` exactly and `Ns = 1/(2*theta)` over `G` blows up.
  `G` is only for trait/GEBV prediction. `tests/test_metrics.R` asserts this identity — if it
  fails, `f` was built wrong (centered, rescaled, or wrong marker coding).
- **`1 - theta` and Nei's `He` are the same quantity** (exact identity, checked in tests). Don't
  add a second "heterozygosity" metric — it's the one already there.
- **`alpha` (diversity loss) is a constraint, not a weighted-sum term.** It's computed against a
  random-subset reference (`gd_ref`), not the full population (which carries a sampling bias) —
  see `stage2_select` step 1. A violation becomes a proportional penalty inside `sel_de`'s fitness.
- **The DE needs a warm start.** Without seeding with greedy solutions (`ws` sweep in
  `03_de_select.R`), 4.5e5 evaluations aren't enough to beat greedy on ~100 integer dimensions.
  Never remove the seeding.
- **All diversity metrics share the signature `f(idx, ctx) -> scalar`** (`R/01_metrics.R`).
  `metrics_cheap()` is safe to call thousands of times (null distribution, DE fitness);
  `metrics_full()` adds expensive ones (eigendecomposition, full marker sweep) — post-hoc only,
  never inside the DE fitness loop.
- **DE encoding is continuous, not an N-key vector**: `n_sel` continuous values in `[1, N]`,
  decoded and repaired for duplicates (`decode()` in `R/03_de_select.R`). An N-dimensional
  0/1 encoding is infeasible for DE at this scale.
- `sim_config` in `R/00_data.R` controls simulation scale (`n_pool_A/B`, `m`, `fst`). Current
  default is a small dev config (50+50 lines, 5000 markers); the real scale is `n_pool_A/B = 71`,
  `m = 25000` — computations that are cheap at dev scale (e.g. `theta_from_freq`, `eff_dim`) get
  much more expensive there, which is why they're segregated into `metrics_full`.

## File map (role, not contents)

| File | Role |
|---|---|
| `R/00_data.R` | simulation, VanRaden `G` (prediction), molecular coancestry `f` (diversity), `ctx` builder |
| `R/01_metrics.R` | all diversity/selection metrics, `f(idx, ctx) -> scalar` |
| `R/02_benchmark.R` | null distribution, discriminatory power, cost-per-eval, plotting |
| `R/03_de_select.R` | selection strategies: truncation, parental cap, greedy, DE, OCS relaxation |
| `R/10_stage1.R` | stage 1 — line genotypes -> X / f / hybrids contract |
| `R/11_stage2.R` | stage 2 — per-scenario selection, metrics, 0/1 selection table |
| `doc/diversity_metrics.Rmd` | technical derivations behind the metrics |

`README.md` documents the numeric results from the current simulated dataset (which metrics
survive, the attainable alpha range, DE-vs-greedy gaps) — treat those numbers as reproducible
findings, not fixed constants; they change if `sim_config` or the DE seeds change.
