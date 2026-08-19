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
res$metrics     # one scenario per row: alpha, index, Ns, Ne_parents, F_hom, F_drift, GD_BS, ...
res$z_scores    # the same metrics in s.d. from the random-subset null
res$ref         # gd_ref, its Monte-Carlo s.e., alpha_max, bias from using the population
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
| `F_drift` | **+57** | **The strongest discriminator in the set, and orthogonal to `GD`** — see result 8. Post-hoc, one marker sweep |
| `ANE` (representativeness) | +42 | Independent. Post-hoc, 2000 µs |
| `F_ST` / `GD_BS` (between-pool) | +40 / +36 | Between-pool divergence. Free once `fL` exists |
| `alleles_lost` | +26 | Independent of θ. Post-hoc |
| `eff_dim` | −21 | No longer redundant once double-centered: at `alpha = 0`, `GD` is z +0.2 while `eff_dim` is −8.8. 366 µs |
| `rare_retained` | −21 | Allelic richness. Independent of θ; shares the `F_drift` sweep |
| `Ne_parents` | −16 | Independent and free (0 µs). **Goes in the fitness** |
| `F_hom` | +13 | Same lens as `GD`, different anchor — keep it only for the `cov_diag` identity |
| `cov_diag` | −3.7 | Small by construction; it is a *sign* diagnostic, not a magnitude one (see result 9) |
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

**8. The constraint pins one lens and leaves the other free.** `theta` is
Meuwissen et al. (2020)'s `G_0.5` — the *homozygosity* lens. Constraining it
says nothing about **drift**, and drift is where the bill lands. Measured on
this dataset, in s.d. from the random null:

| Scenario | `alpha` | `z_GD` | `z_F_drift` | `z_rare_retained` |
|---|---|---|---|---|
| `DE_alpha_0.00` | −0.00% | **+0.1** | **+11.4** | **−6.9** |
| `DE_alpha_1.81` | 1.81% | −13.2 | +34.1 | −18.6 |
| `DE_alpha_3.62` | 3.56% | −26.0 | +53.6 | −19.4 |
| `ref_truncation` | 3.62% | −26.5 | +54.9 | −18.4 |

Read the first row. At **`alpha = 0`** — a gene diversity indistinguishable
from a random subset of 100 — the selection has already drifted **11 s.d.**
past random and dropped `rare_retained` from 0.970 to 0.874: **10% of the
rare alleles are gone at "zero diversity loss"**. Across the grid drift moves
roughly twice as fast, in s.d., as the quantity actually being constrained.
This is not a bug in `alpha`; it is what `alpha` was never measuring.

**9. The `cov_diag` diagnostic behaves exactly as the theory predicts.**
`cov_diag = 2·mean(δp/s · (p₀−½)/s)`, which is *exactly* `F_hom − F_drift`
(their Eq. 3, asserted to 1e-8 in `tests/`). `ref_random` gives **+0.0004 ≈ 0**
— the control. `ref_max_div` (pure `G_0.5` maximisation) gives the most
negative value, **−0.0186**, with `F_hom = −0.0133` — a *negative* inbreeding
coefficient. The paper predicts both the sign and the negativity for this
scheme; getting them out of an independent implementation is the validation.

**10. Between-pool divergence is not being eroded — it is being amplified.**
`GD_BS` (Caballero & Toro's between-subpopulation component, the heterosis
engine) rises monotonically with `alpha`: 0.0337 → 0.0424, `F_ST` 0.103 →
0.135, `z_GD_BS` +8.8 → +37.1. Index selection picks complementary parents,
which pushes the pools apart. That is the *good* direction, and until the
partition existed the question could not be asked at all. `GD_WI` is 0 by
construction (inbred lines); `GD_WI_hyb ≈ 0.18` is the number with signal.

**11. `Ne_parents` and drift are not the same alarm.** At `alpha = 0`,
`z_Ne_parents = −7.6` while `z_F_drift = +11.4`; at truncation, −15.1 vs
+54.9. `Ne_parents` saturates, drift does not. Report both.

## Caveats

- `Ns = 1/(2θ)` is a static descriptor of the group, not a drift projection.
  Do not use `Ne = 1/(2ΔF)` under molecular management (Toro et al. 2020).
- Additive VanRaden G does not capture heterosis/SCA. It affects trait
  prediction, not the diversity metrics.
- `theta_A/B/AB` and the `GD_WI/BI/BS` partition are in the CSV, but in the
  simulation the pools are symmetric by construction — on your real matrix
  that's the first place worth looking.
- **`F_hom`/`F_drift` are anchored on the candidate pool**, frozen in `ctx$p0`.
  That is the right base for a one-shot pick. If this ever feeds *recurrent*
  cycles, the base must be the founder cycle and must never be redefined per
  cycle — recomputing it each cycle is the exact error Meuwissen et al. call
  out (their sec. 5.1), and it lets the accumulated loss overrun the target
  while every single cycle reports as compliant.
- **The drift lens is diagnostic, not a constraint.** `F_drift` costs an
  `O(n·m)` marker sweep, which is unusable inside 4.5e5 DE fitness
  evaluations. The DE still optimises against `theta` alone; the drift number
  tells you what that cost, it does not yet control it.
- Do not read "max diversity has the largest drift" into result 8.
  `ref_max_div` has *low* `F_drift` (0.0053) because it barely selects. The
  comparison that means something is between scenarios at **equal `alpha`**,
  not across the whole table.
