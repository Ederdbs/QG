# 05-genomic-era -- iteration 1 audit (read-only)

Scope: `book/05-genomic-era.qmd` (1864 lines) against `R/`, `book/_common.R`, the Meuwissen et al. (2020) PDF in
`reference/papers/`, and the 05 items Owed in `THREAD.md`. Method: the chapter was knitted (`knitr::knit`, installed
`hybdiv` 0.1.0, `freq_metrics` identical to the worktree) to a scratch file, with every `stopifnot()` passing on the
shipped seeds; then stochastic claims were rerun over 20 data seeds (`simulate_data(seed = 1..20)`) and 20 `pool_traj`
seed families (`seed = 11 + 100 k`). Nothing under `book/` or `R/` was edited. No chunk added, removed or relabelled, so
no `unnamed-chunk-*` figure is orphaned (the only figure chunk, `fig-era-lens-divergence`, is labelled; `docs/` and
`_freeze/` carry only its `-1.png`/`.svg`). `book/downloads/05-genomic-era.R` is in sync with the qmd (spot check of
`z_bonf`, `seeds_traj`, `cap_div`, `rk20`, `kappa_book`). Chapter is pure ASCII; no `ctx$f`/`ctx$G` (uses `ctx[["f"]]`,
`ctx[["G"]]`); reads no `report/`, `data/`, `reference/`; reads no `book/data` (nothing to regenerate). All `@sec-`,
`@eq-`, `@tbl-` targets resolve (only `sec-era-protocol` is defined and never cited -- harmless).

Severity: H = a claim the evidence does not support; M = wrong or misleading wording/attribution; L = hygiene.

## Findings

### 05-R1 (H) -- headline claim "truncation hybrids are MORE heterozygous than random subsets" holds on data seed 1 only
- `05:287-318` (also `05:1845` checklist row, `05:299-311`). Prose: truncation F1 heterozygosity 0.3646 vs null 0.3617,
  z = 2.51, "real against the null". Rerun over 20 data seeds (`simulate_data(modifyList(book_cfg, list(seed = s)))`,
  null `B_full = 300`, seed 7): z(F1_het, truncation) = 2.51 (s=1), -0.37, 0.49, -0.66, -0.29, 0.55, -0.07, 0.51, 0.85, -0.86,
  -2.72, -4.79, 3.26, 0.15, 0.43, 0.47, 1.15, 3.32, 3.81, 1.43. Range -4.79..3.81; 8 of 20 negative, 4 of 20 above +2,
  2 of 20 below -2. The sign is not a property of the method; it is seed 1. The chapter hedges the size ("measured on one
  candidate set") but asserts the direction ("real", "beats the random-subset null") and builds the F_hom-vs-product
  argument on it. (The unit of replication is the simulated founder set; 1 replicate reported.)
- The robust parts (not weakened): `w = 1` returns the truncation set (20/20 seeds), `He = GD_T`, F1_het = 2 GD_WI_hyb (asserted).
- Fix: either report the across-seed distribution of z (cheap: ~2 s/seed) and say "no consistent sign", or drop the
  directional claim and keep only "F_hom and F1 heterozygosity are different quantities and can disagree" (max_div,
  F_hom z = -4.8 vs F1_het z = +7.8 on seed 1, also to be checked across seeds before being kept).

### 05-R2 (H) -- Step 5 audit: the `index` row is not off-panel; its audit half is selected on
- `05:1306-1339`, `05:1350`, `05:1352-1355`, `05:1370-1372`. `simulate_data()` builds the traits from effects at EVERY
  marker (`R/00_data.R:140-144`, `B <- rnorm(m * n_traits)`), and the chunk itself asserts
  `c_mgmt$index == ctx$index` (`05:1321`). So `sel_greedy(c_mgmt, 60, w = 1)` is truncation on an index that
  loads on the audit half as much as on the management half. Measured: truncation's F_drift on the audit half is 0.0536
  against an audit-half null of 0.0068 +/- 0.0014 (about 34 null s.d.; the chapter's own table shows index_audit F_drift
  0.0536 vs index_managed 0.0580). "Loci that did not enter the management" (`05:1301`) and "a cheap empirical reference:
  the index row ... had no heterozygosity objective" (`05:1370-1372`) are therefore wrong for that row: it is a
  directional-selection row, not a sampling-noise reference. Its F_hom gap (-0.0051) being small says nothing about
  the audit design.
- The `max_div` row is clean (w = 0 never reads `ctx$index`).
- Robustness of the "sign reverses" statement (`05:1343-1344`): managed F_hom < 0 on 20/20 data seeds; audit F_hom > 0 on 17/20
  (seeds 7, 13, 17 stay at -0.004, -0.001, -0.004). Say "the sign reverses on 17 of 20 seeds" or "audit F_hom is near zero".
- Fix: build the index of the audit scenario from the management-half effects only (or drop the `index` row and state the
  neutral reference differently), and report the seed count.

### 05-R3 (M) -- A5 "markers are neutral" must say which simulator; it is false for the rows that select on the index (Owed 00-C6)
- `05:91-95`. The chapter's `ctx` is `simulate_data()` (effects at every marker, `R/00_data.R:140-144`); every
  `truncation`, `balanced` (`w = 1`), `capped` and `index` row selects on `ctx$index`, so those markers are under selection.
  `00:18-42` tells the reader neutrality holds in "this chapter's diversity examples because nothing in them selects on a
  trait"; that is true of `pool_traj()` and of the `w = 0` plans, not of the truncation / index / capped rows. The
  `run_cycles()` the chapter points to uses `simulate_pools(n_qtl = 300)` (`R/14_cycles.R:107-108`): a different simulator, 300 QTL.
- Fix: A5 states the three cases (pool_traj/maf-weight: neutral by construction; `w = 0` plans: index not read; index-based
  rows and `simulate_data()`: effects at every marker; `run_cycles()`: `simulate_pools()`, 300 QTL).

### 05-R4 (M) -- A3 "`run_cycles()` ... implements exactly this loop" (Owed 00-C6)
- `05:83-84`. `R/14_cycles.R:101-166`: founding population from `simulate_pools()`; marker effects `beta` fixed at cycle 0
  and never re-estimated; the index is the true genetic value (`cycle_ctx`, `ctx$index <- (gv - centre)/scale_`); selection
  is of hybrids under a budget (`sel_greedy_budget`), not of lines on testcross performance; recycling is usage-proportional
  intermating plus one DH draw (`next_pool`). `00:216-219` already says "in reduced form ... no trials and no S3, index known
  without error (C7, C8)". 05 contradicts 00.
- Fix: "implements this loop in reduced form (`00:216-219`; assumptions C7, C8 of @sec-cycles)".

### 05-R5 (M) -- F_ST naming and the Wright (1951) attribution (Owed 02/00 reconciliation)
- `05:358-365`, `05:1466`, `05:1477`, `05:1490-1491`, `references.bib:705` (`wright1951`, the only citation in the book).
  1. The source (Meuwissen 2020, p.4, after Eq. 1B) says only "F_drift is similar to the definition of F_ST (Holsinger and
     Weir, 2009)". "The form @wright1951 introduced" is the book's addition; Wright (1951) was not read, and its bib entry has a
     1949 DOI (`10.1111/j.1469-1809.1949.tb02451.x`) against `year = {1951}`.
  2. The chapter says its own `F_ST` is "the Nei G_ST of gd_partition(), a different statistic" from the standardised-variance form.
     Computed: `gd_partition(all hybrids)$F_ST = 0.1024003` and the standardised variance
     `mean((pA-pB)^2/4) / mean(pbar*(1-pbar)) = 0.1024003` -- the same number (02:397-401 proves it per locus,
     `dp^2/(4 pbar qbar)`). The book's F_ST has the variance form; what differs from F_drift is the partition (space vs time), not
     the form.
  3. `05:1466`/`1477`/`1490` call `s1_monitor()$Fst_Wright` "Wright's F_ST". That is the between-referenced
     `(theta_w - theta_B)/(1 - theta_B)` (`R/05_pipeline_metrics.R:78`), for which 02:408-426 says the book cites no source and
     08 Trap 2 writes `F_ST^(W)`. So 05 uses "Wright" for the variance form at :360 and for the between-referenced form at
     :1490 -- opposite objects.
- Fix: delete the Wright 1951 attribution; cite Holsinger & Weir (2009) as Meuwissen does; say the book's F_ST is eq-f-stats of 02
  (= GD_BS/GD_T = Nei's G_ST form, 00:577-580), of variance form, applied across pools; call `Fst_Wright` "the between-referenced
  F_ST (`Fst_Wright` in the code)". Remove the orphaned bib entry or correct its year.

### 05-R6 (M) -- Bonferroni check at `05:1099-1113`, `05:1143-1150`: "conservative" is false and the assertion is seed-fragile
- `dev_se(...) < qnorm(1 - 0.025/24) = 3.078` uses a normal bound with a s.e. estimated from 20 replicates, and asserts it with
  `stopifnot`. Over 20 seed families (`pool_traj(seed = 11, 111, ..., 1911)`): dev_se = 3.46 (block, 811), 4.40 (DH, 911),
  3.17 (block, 1611), 3.45 (block, 1811) exceed 3.078 -- 4 of 20 families break the `stopifnot`. With `qt(1 - 0.025/24, 19) = 3.56`
  one family still fails (4.40, DH), i.e. ~5% by design. The prose "The bound is conservative here" (`05:1148-1149`) is not supported; the
  render passes on seed family 11 only (dev_se 2.13 / 2.06).
- The other assertions are stable over the 20 families: min R2 of the four neutral fits >= 0.999 (min 0.9990 at family 1911, margin ~1e-4);
  managed R2(F_drift) < 0.995 in 20/20 (0.9921-0.9947, margin as little as 0.0003); stock ratio 1.96-2.06 (chapter 2.02).
  The two R2 thresholds (0.999, 0.995) sit within 1e-4 / 3e-4 of the observed extremes; state that they are calibrated to this scale and
  these seeds (the chapter does say "at this scale only").
- Fix (no seed or tolerance change): use the t bound with `n_rep - 1` df and report the per-family failure rate, or report dev_se
  without asserting it.

### 05-R7 (M) -- Reading 2 (`05:711-715`) "their Results text rounds both to 40%"
- Table 2 Panel N gives dF_hom 0.0070 and dF_drift 0.0084 for A, i.e. +40% and +68% (the chunk prints both). The paper's text
  (p. 9, "rates by 40% in both panels") is not a rounding of 68%; Panel M is +44% / +66%.
- Fix: "their text says 40% for both; their Table 2 gives 40% and 68% (Panel N)". All other transcribed Table 2/3 values (8 schemes x 4
  columns), the "65 / 62 of 100", "within 2%" and the quoted sentences (Discussion x4, Conclusion bullet 2) match the PDF.

### 05-R8 (L) -- kappa of the book's panel attributed to the wrong cause (`05:556-559`)
- "a consequence of the U(0.05, 0.95) ancestral draw of `simulate_lines()`": kappa of an ancestral U(0.05, 0.95) draw is 0.64-0.66
  (integral 0.636; 2000 draws 0.658); the chapter's `kappa_book` = 1.270 over 1934 markers (66 of 2000 fixed in the candidate set).
  About half comes from the Balding-Nichols divergence at `fst = 0.15` and the 25-line sampling per pool.
- Fix: "of the U(0.05, 0.95) ancestral draw followed by Balding-Nichols divergence (`fst = 0.15`) and finite sampling of lines".

### 05-R9 (M) -- 01 promise: delivered for one cycle; the multi-cycle claim at `05:925-930` points at the wrong arm
- THREAD 01 promise (`01:496-497`: the consequence of the F_hom/F_drift gap "for this book's selections is measured where those metrics
  are reported"). 05 measures it for the four selections at one cycle (tbl-era-signature: cov_diag of max_div -0.0174, z = -4.9; F_drift z = -0.67,
  no drift excess; 20/20-seed |z| < 1.6) -- KEPT. But `05:925-930` says "the honest way to run it here is the multi-cycle arm of Step 4,
  where the same pull toward 0.5 does produce a drift stock larger than the neutral one". The Step-4 arm is `pool_traj(pull = 0.05)`, a
  stipulated caricature with no selection. The implied linear pull of the `max_div` plan (slope of `p - p0` on `0.5 - p0`) is 0.013,
  not 0.05 (random draw: -0.003). The book's selections across cycles are `run_cycles()` in `@sec-cycles` (F_hom, F_drift columns, 11b:12-13, 186-194).
- Fix: "a pull of the same sign, about four times larger" and point to `@sec-cycles` as the place the book's selection is run across cycles.

### 05-R10 (M) -- inline scientific values (Owed 00-C22/00 `fmt_sci`)
- `05:1704` `` `r signif(ev_min, 2)` `` and `05:1743` `` `r signif(abs(ev_min), 1)` `` leave knitr as bare TeX (`-4.3 \times 10^{-13}`), the case
  `_common.R:44-52` documents (Pandoc drops `\times 10`). Use `` `r fmt_sci(ev_min)` `` / `` `r fmt_sci(abs(ev_min), 1)` ``.
- Also `05:783`, `05:784`, `05:944` use `sprintf("%.1e"/"%.2e")` (print as plain `1.1e-16`, `7.58e-04`; not broken, but not `fmt_sci`).
  The printed `ev_min` (-4.28e-13) and the "4.4 orders of magnitude" at `05:1730` are BLAS-dependent rounding noise; say "about 1e-13, platform dependent".

### 05-R11 (M) -- "production scale" has two values (Owed 00-C22)
- `05:106-110`: "The production scale, a declared programme size that no chunk of this chapter runs, is 71 + 71 lines and 25000 markers".
  `R/00_data.R:8-10` and `_common.R:20` use the same two numbers, but `sim_config` itself is 50 + 50 / 5000 (`R/00_data.R:16-23`) and
  `inst/scripts/run_all.R:1` / `06:620` / `12:34-36` call THAT "the production scale of `sim_config`".
- Fix: in A8 name both: "the programme size the package declares (71 + 71, 25000, `R/00_data.R`), which is not the `sim_config` default
  (50 + 50, 5000) that `inst/scripts/` run"; 06 and 12 follow.

### 05-R12 (L) -- "candidate pool" (Owed 00-M14)
- `05:735` ("the candidate-pool allele frequencies"), `05:829` ("fixed in the candidate pool"), `05:876` (caption "rare in the candidate pool").
  "pool" means a heterotic group here; the settled term in 03, 04, 05b is "candidate set". Replace the three occurrences
  (`R/00_data.R` roxygen and `R/14_cycles.R:94` carry the same phrase; outside this chapter).

### 05-R13 (L) -- `d_k` wording (Owed 05b)
- `05:325-326` "with $d_k$ the dominance\ndeviation at locus $k$" (line break inside the phrase). 00:125, 01:44, 02b, 05b:148 write "dominance effect" because
  "dominance deviation" is Fisher's statistical quantity (04c:393-395). Replace with "dominance effect" (Falconer's d). The Falconer & Mackay
  chapter locators (`Ch. 3-4`, `3`, `14`, `7`; `05:157`, `178`, `325`, `389`) are plausible but were not checked against the book (UNVERIFIED, as in 05b).

### 05-R14 (M) -- Step 1 "Call" is not executable as written (`05:847-848`, `05:735-737`, `05:97-98`)
- "`build_ctx()` once at cycle 0; pass `p0` forward (`run_cycles()` does this through its internal `cycle_ctx()`)". `build_ctx()` has no `p0`
  argument and recomputes `colMeans(X)` on every call (`R/00_data.R:164,173`, as the chapter itself shows two paragraphs earlier);
  `cycle_ctx()` (`R/14_cycles.R:49-66`) overwrites BOTH `ctx$p0` and `ctx$maf_pop` after `build_ctx()`, and `run_cycles()` computes the frozen
  `p0 <- colMeans(sim$X)` itself (`R/14_cycles.R:112`). A reader following "pass `p0` forward" has no argument to pass it to, and
  `freq_metrics()` reads `ctx$maf_pop` (`alleles_lost`, `rare_retained`) as well as `ctx$p0`. A6 "set once in `build_ctx()`" is likewise only half right.
- Fix: "build the context, then overwrite `ctx$p0` and `ctx$maf_pop` with the stored cycle-0 values, as `cycle_ctx()` does".

### 05-R15 (L) -- identities / numbers stated in prose without an assertion in this chapter
- `05:220-222` "on the full factorial it equals GD_T + GD_BS": true (0.3616896 on both sides, computed here; asserted in 05b `tbl-het-wi-hyb`) but not
  asserted in 05; add one `stopifnot` next to `inb`.
- `05:786-788` "each line used exactly 3 times": implied by the asserted identity, not asserted; add
  `stopifnot(all(table(c(ctx$ped$a, ctx$ped$b)[...]) == 3))` for `idx_bal`.
- `05:1441-1443` "raises f-tilde twice as fast as f-bar": a derivation at fixed theta_AB; on the truncation vs random rows the measured ratio is 2.27
  (theta_AB also moves). Say "about twice".
- `05:304` "ranks the plans in the opposite order": true of the pair truncation/max_div only; `random` is lowest on both columns.
- `05:1652-1656`: comment "reproduces `sels$random`": add `stopifnot(identical(r60, sels$random))`.
- `05:1731` "small enough not to move the optimum" (ridge 1e-8): asserted, not measured.

### 05-R16 (L) -- cross-chapter inconsistency to hand to 11b
- `05:1850` checklist and `05:1283-1288` say `Delta F = 1 - exp(slope)`; `11b:241-242` computes `dF_per_cycle = -coef(f)` and `Ne = 1/(-2 coef)`, the first-order
  form 05 warns against. Forward claim `05:1287`/`1296-1297` ("@sec-cycles fits the same regression ... the diagnostic fires on the unconstrained run") is
  true (11b:236-252).

## Owed items from THREAD.md ('-> `05`') -- status

| Item | Status |
|---|---|
| A5 must say which simulator (00-C6) | OPEN -> 05-R3 |
| `05:83-84` "exactly this loop" (00-C6) | OPEN -> 05-R4 |
| two "production scale" values (00-C22) | OPEN -> 05-R11 |
| inline scientific values `05:1704`, `05:1743` (`fmt_sci`) | OPEN -> 05-R10 |
| "candidate pool" `05:829`, `05:876` (+ `05:735`) | OPEN -> 05-R12 |
| F_ST naming `05:360-364`, unverified `wright1951` | OPEN -> 05-R5 (source says Holsinger & Weir only) |
| `d_k` wording `05:325-326` | OPEN -> 05-R13 |
| 01 promise (F_hom/F_drift gap consequence) | KEPT for one cycle; multi-cycle pointer wrong -> 05-R9 |
| keep-true: A5 `simulate_lines()` independence (03:141-176); A6 `ctx$p0` = mean of pools' sampled line frequencies (03:558-567) | TRUE as coded (`R/00_data.R:164-176`), wording "set once in `build_ctx()`" refined in 05-R14 |
| Comstock et al. (1949) as attribution of A3 at `05:80-81` | PENDING by user declaration (no copy); RECORDED, not chased. 05b reports the title only (05b:1025-1031) |

## Verified OK (no finding)
- Every `stopifnot()` passes on the shipped seeds (inbred check, He = GD_T, F1_het = 2 GD_WI_hyb, cov_diag = F_hom - F_drift, `2*mean(xy)` form, base-zero,
  maf-weight algebra `F_drift = c^2 kappa`, `cov_diag = -2 c kappa`, p0 identity on balanced/unequal/incomplete designs, `GD = GD_T`, `gd_partition F_ST = s1 Gst_Nei`,
  `f = 0.5 + 2 Zh Zh'/m`, `G05 = 8 Zh Zh'/m`, sum(G) = 0, rank(G) = rank(f) - 1, rank(f) <= rank(B)).
- `w = 1` equals truncation on 20/20 data seeds; `max_div` F_drift z within +/-1.6 on 20/20 data seeds (the "no measurable drift excess" statement holds).
- Meuwissen et al. (2020) transcriptions: Table 2 Panel N (8 rows), Table 3 gains, `ninth scheme dF_drift = 0.0059`, "65, respectively 62 out of 100",
  "within 2% of the target", Eq. 1A / Eq. 3 forms, alpha = 0.01, the four Discussion/Conclusion quotes, "four panels of random WGS samples".
- `ocs_quadprog()`/`optimal_contributions()` add `diag(1e-8, n)` (`R/07_caballero_toro.R:178,203`).
- Seeds: every draw (`sample.int`, `runif`, `replicate`) is preceded by its own `set.seed()`; `null_distribution(seed = 7)`; `pool_traj` seeds per replicate; no AlphaSimR/MaCS.
- Seed 1 stock ratio (2.02), R2 gap (0.9924 vs 0.995) and neutral R2 (>= 0.9993) reproduce; stock ratio 1.96-2.06 over 20 families.

## Cost / scale
Full chapter knit ~1 min (625 hybrids, m = 2000, 50 lines); 20-seed reruns ~2 min each script; everything O(N^2 m) via `molecular_coancestry` at teaching scale.
