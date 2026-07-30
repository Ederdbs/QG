# Hybrid Selection Under a Diversity Constraint

```
Rscript tests/test_metrics.R   # sanity checks (~40 s)
Rscript run_all.R              # 2-stage pipeline -> report/ (~4 min)
Rscript run_benchmark.R        # metrics benchmark + plots (~6 min)
```

Technical document with the derivations: `doc/diversity_metrics.Rmd`.

Current configuration: 50+50 lines → 2500 hybrids, 5000 markers, selecting 100 (4%).
For the real scale, edit `sim_config` in `R/00_data.R` (`n_pool_A/B = 71`, `m = 25000`).

## Two-Stage Pipeline

```r
# STAGE 1 — line genotypes -> X, f, hybrids
st1 <- stage1_simulate()
#   or, with real data:
#   st1 <- stage1_build(X = hybrid_markers, ped = pedigree, traits = predicted_traits)

# STAGE 2 — the three objects above -> DE selection across several alpha scenarios
res <- stage2_select(st1$X, st1$f, st1$hybrids, n_sel = 200,
                     alphas = NULL,    # NULL = automatic grid up to the attainable ceiling
                     weights = NULL,   # NULL = equal weight across traits
                     fL = st1$fL)      # optional: enables theta_A/theta_B/theta_AB

res$selection   # N rows x (hybrids + one 0/1 column per scenario + n_scenarios)
res$metrics     # one scenario per row: alpha, index, Ns, Ne_parents, ...
res$ref         # gd_ref, attainable alpha_max, bias from using the population as reference
```

`stage1_build()` accepts the marker matrix in 0/1/2 or 0/0.5/1 coding.
Stage 2 runs without `fL`; it only loses the heterotic-group decomposition.

| File | Role |
|---|---|
| `R/00_data.R` | simulation, VanRaden `G` (prediction), molecular coancestry `f` (diversity) |
| `R/01_metrics.R` | the metrics, all `f(idx, ctx) -> scalar` |
| `R/02_benchmark.R` | null distribution, discriminatory power, cost, plots |
| `R/03_de_select.R` | strategies: truncation, parental cap, greedy, DE, OCS relaxation |
| `R/10_stage1.R` | stage 1 — X / f / hybrids output contract |
| `R/11_stage2.R` | stage 2 — per-scenario selection, metrics, 0/1 table |

## Results (Simulated Data)

**1. Use `f` (molecular coancestry), not VanRaden `G`, for diversity.**
With `Z` centered on its own population, `sum(G) == 0` exactly — measured:
`-3.2e-12`. `Ns = 1/(2θ)` over `G` would give `-3.3e+15`. `G` still handles
trait prediction.

**2. `1 − θ` and Nei's `He` are the same quantity.** `cor = 1.0000000000` in
the null distribution, and an exact identity to `1e-10` in the test. One
fewer metric to justify, and "losing 5% of diversity" gains an exact meaning:
5% of expected heterozygosity.

**3. Your current metric is nearly right.** `cor(GD, off-diagonal) = −1.0000`.
In an all-F1 population the diagonal of `f` varies little, so the
off-diagonal mean ranks identically. What was missing wasn't the diagonal —
it was **the baseline and the scale**.

**4. The baseline matters more than the metric.** Population `GD` (N=2500)
= 0.32744; mean of random subsets of 100 = 0.32603. Comparing directly
against the 5000×5000 matrix registers **0.43% "loss" that is pure sampling
effect**, not selection.

**5. Your 5% limit doesn't constrain anything.** Pure truncation — the
greediest possible selection — loses only **3.63%**. No selection of 100 out
of 2500 reaches 5%. Useful α range in this dataset: **0 to 3.6%**. The knee
of the curve sits near **α ≈ 1.5%**, where the DE delivers 1.86 of
truncation's 2.30 deviations (81% of the gain) at 40% of the diversity loss.
Recompute this on your real matrix before fixing the number.

**6. Metrics that survive** (standard deviations from the null,
truncation vs. random):

| Metric | z | Verdict |
|---|---|---|
| `GD` / `Ns` / off-diagonal | ±30 | Core. Goes in the fitness (33 µs) |
| `eff_dim` | −35 | Best discriminator, but 366 µs and redundant with `GD` |
| `ANE` (representativeness) | +42 | Independent. Post-hoc, 2300 µs |
| `alleles_lost` | +26 | Independent of θ. Post-hoc |
| `Ne_parents` | −16 | Independent and free (0 µs). **Goes in the fitness** |
| `ENE` (non-redundancy) | −3 | Weak here: no clones in the set |

`Ne_parents` drops from 69 (random) to 19 (truncation) while `Ns` drops only
from 0.742 to 0.729. It's the metric that sees what coancestry blurs — and it
costs nothing.

**7. The DE needs a warm start.** Without seeding the population with the
greedy solutions, the DE ends up *below* the greedy (450k evaluations aren't
enough for 100 integer dimensions). With a warm start it lands 0.03–1.19
above the greedy and hugs the continuous OCS relaxation (gap ~0 at the
extreme). The DE saturates the constraint exactly (α achieved ≈ α_max),
which is the sign that the constraint formulation is working.

## Caveats

- `Ns = 1/(2θ)` is a static descriptor of the group, not a drift projection.
  Do not use `Ne = 1/(2ΔF)` under molecular management (Toro et al. 2020).
- Additive VanRaden G does not capture heterosis/SCA. It affects trait
  prediction, not the diversity metrics.
- `theta_A/B/AB` (heterotic-group decomposition) is implemented and in the
  CSV, but in the simulation the pools are symmetric by construction — on
  your real matrix that's the first place worth looking.
