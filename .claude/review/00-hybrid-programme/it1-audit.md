# 00-hybrid-programme -- iteration 1 audit (quant-Rwrite, chapter audit mode)

Chapter: `book/00-hybrid-programme.qmd` (590 lines; 8 chunks plus setup). Read-only on the book and on `R/`.
Method: chunks extracted with `knitr::purl`, sourced from `book/` against `pkgload::load_all()` of the worktree;
every inline expression evaluated in the resulting environment and compared with the frozen markdown, `docs/` and the PDF.
Scratch scripts live outside the worktree. Severity: H (a wrong thing is published), M (a claim the evidence does not carry),
L (scope, citation or assertion gap), Info (hygiene).

## Findings

### 00-R1 -- H -- three printed values are garbled in the published HTML and PDF
`book/00-hybrid-programme.qmd:132` (`signif(gca_err, 1)`), `:254` (`fmt(sub_gd[["random_se"]], 4)`), `:419` (`fmt(ibs[["full_sib_se"]], 4)`).

knitr's inline hook writes small numbers as `4\times 10^{-13}` with no `$` around them, so Pandoc treats `\times 10` as raw TeX and drops it. Reproduced with `quarto pandoc`: the bare form gives `4^{-13}`, and the same string inside `$...$` renders correctly.

| Line | True value | Frozen markdown | `docs/00-hybrid-programme.html` | PDF (pdftotext) |
|---|---|---|---|---|
| 132 | 3.70e-13 | `4\times 10^{-13}` | `4^{-13}` (html:747) | `4^{-13}` (txt:1436) |
| 254 | 1.32e-4 (rounded to 1e-04) | `10^{-4}` | `10^{-4}` (html:876) | `10^{-4}` (txt:1600) |
| 419 | 3.87e-4 (rounded to 4e-04) | `4\times 10^{-4}` | `4^{-4}` (html:956) | `4^{-4}` (txt:1793) |

Read as written, `4^{-4}` = 0.0039 is ten times the real s.e. of 0.0004, and `4^{-13}` = 1.5e-8 is about 40000 times the real error.
The code and the values are right; the printed form is wrong. Fix at the source: put these inline values inside `$...$`, or pass them as a string.

Same defect outside this chapter, for the chapters that own them, found by scanning every `_freeze/*/html.json` outside math and code: `05-genomic-era` (two values), `06-metric-catalogue` (one), `04g-joint-allocation` (one, a positive exponent). The PDF text shows `-4.3^{-13}`, `4^{-13}` and `6.7^{-16}`.

### 00-R2 -- M -- "the case shown is the one that maximises the disagreement" is false for a realised additive part
`book/00-hybrid-programme.qmd:141-144`.

The claim holds in expectation over `a_k` only. On 25 lines the realised additive part is not orthogonal to the dominance difference, so adding it can lower the correlation.
Measured on the chapter's own `g1`, `g2` (dominance-only correlation 0.8587, seed 4), adding `A = cU %*% a`, `a_k ~ N(0, s^2)`, 2000 draws per row:

| s | sd(A)/sd(g1) | mean cor | share of draws below 0.8587 | min cor | share with top-5 overlap < 3 |
|---|---|---|---|---|---|
| 0.01 | 0.03 | 0.859 | 0.465 | 0.853 | 0.000 |
| 0.05 | 0.15 | 0.861 | 0.361 | 0.830 | 0.024 |
| 0.10 | 0.30 | 0.869 | 0.220 | 0.801 | 0.059 |
| 0.25 | 0.74 | 0.906 | 0.033 | 0.778 | 0.068 |
| 0.50 | 1.48 | 0.954 | 0.000 | 0.871 | 0.015 |
| 1.00 | 2.95 | 0.985 | 0.000 | 0.958 | 0.001 |

The mean rises monotonically, so "pulls towards 1" is correct as an expectation. "Maximises" is not. The algebra also needs `Var(g1) ~ Var(g2)`: here sd 5.90 vs 5.84, ratio 0.78-1.21 over 200 `d` draws.
A chunk asserts none of this.

### 00-R3 -- M -- "@sec-cycles measures that" points to a measurement that chapter does not make
`book/00-hybrid-programme.qmd:530-532`: "Selection makes the realised rate larger, because selected parents contribute unequally; @sec-cycles measures that across cycles".

`11b-diversity-across-cycles.qmd` has no neutral arm: a search for `neutral`, `unmanaged`, `no selection`, `random` returns nothing. Its rate table (11b:236-252) compares three budgets with each other and calls the unconstrained fit "exactly backwards". It never compares a selected rate with an unselected one, and it does not measure contribution inequality as a cause.

The direction of the claim does hold in the package. I added the missing arm with `run_cycles(selector = random)`, same settings as `regenerate.R cycles` (15 cycles, seeds 1:5, `n_sel = 60`), same regression on `F_drift`:

| Arm | dF per cycle | s.e. (n = 5 founder seeds) |
|---|---|---|
| random | 0.0201 | 0.0006 |
| alpha 0.005 | 0.0265 | 0.0009 |
| unconstrained | 0.0291 | 0.0008 |
| alpha 0.020 | 0.0358 | 0.0010 |

These are not the rate of a DH pool: `F_drift` here is on merged hybrid frequencies, and the random arm's 0.0201 is consistent with `1/(2n) = 0.02` for two merged pools, not `1/n = 0.04`. The "because ... unequally" clause is not tested: the random arm also has unequal usage.
Either the pointer changes or 11b gains the arm.

### 00-R4 -- M -- "the largest share of the loss falls at S2" holds under one of the two strategies simulated
`book/00-hybrid-programme.qmd:270-273`.

From `book/data/pipeline_loss_ledger.csv`, the file behind the table in `08-pipeline-stages.qmd`, paired by founder seed (n = 8):

| Strategy | share S2 | share S4 | paired S2 - S4 | s.e. | S2 > S4 in | t-test p |
|---|---|---|---|---|---|---|
| merit only (`UC only`) | 77.46 | 19.99 | 57.48 | 3.66 | 8/8 | 1e-06 |
| merit + diversity (`UC + div`) | 35.51 | 35.49 | 0.02 | 4.12 | 4/8 | 1.0 |

The sentence defers to @sec-stages for "its conditions", but the condition that decides the claim is the cross-selection strategy, and the sentence leaves it out.

### 00-R5 -- L -- the citation for the between-pool trend covers drift only
`book/00-hybrid-programme.qmd:274-276`: "within-pool selection and drift push the two pools' frequencies apart ... (@sec-subdivided)".

`02-subdivided.qmd:354-359` derives the drift case and ends "Selection is not covered by this argument". The selection evidence is in @sec-cycles (`11b:409`). Measured there: `GD_BS` at cycle 15 exceeds cycle 0 in 5/5 seeds in each budget (0.0483 to 0.1755 unconstrained, 0.0400 to 0.1479 at alpha 0.005), and also in my random arm (0.0356 to 0.1195, 5/5). Mean `theta_A`, `theta_B` also rise at cycles 0, 5 and 10 in each budget. The claim stands; the pointer is incomplete.

### 00-R6 -- L -- `hp-drift` iterates the equation's own binomial, not a crossing block or a DH pool
`book/00-hybrid-programme.qmd:498-502, 507-511`.

`rbinom(m_dr, n_gam, p) / n_gam` is the sampling model behind @eq-hp-drift, so the check confirms the algebra, not that the two schemes pass `2n` and `n` copies. I ran an individual-level oracle (n = 10, 10 generations after a sampled base, 400 loci, 100 pedigrees; closed form `(1 - 1/n_gam)^11`):

| Scheme | H_10 / 0.5 | s.e. | Closed form |
|---|---|---|---|
| crossing block, selfing allowed | 0.5688 | 0.0037 | 0.5688 |
| crossing block, selfing excluded | 0.5827 | 0.0033 | 0.5688 (4.2 s.e. above) |
| DH pool (one gamete per line) | 0.3136 | 0.0039 | 0.3138 |

The DH factor is confirmed. The `N_e = n` statement needs random union with selfing allowed; a block without selfing retains about 2.4% more at t = 10 (`N_e ~ n + 1/2`). The chapter says "intermated at random" and does not state this.

### 00-R7 -- L -- identities the prose asserts with no `stopifnot()`
All hold when I check them; none is asserted in the chapter.

| Line | Identity | Measured |
|---|---|---|
| `:547-548` | `GD_WI = 0` "exactly" | `gp[["GD_WI"]]` = -4.4e-16; `gp` is already in scope at `:330` |
| `:437` | `s_i = (1 + F_i)/2` | max deviation 1.1e-16 over 625 hybrids |
| `:315` | @eq-hp-gd for a proper subset `S` (asserted only for all hybrids and for pool A, `:337-338`) | deviation 0 on a random subset of 37 |
| `:555-556` | quadratic form in line usage (pointer to @sec-collapse) | deviation 1.1e-16 on a random subset of 40 |

### 00-R8 -- L -- `fmt()` drops trailing zeros, so paired values print at different precision
`book/00-hybrid-programme.qmd:525-528`: "retains 0.6 ... (expected 0.599)" and "0.35 (expected 0.349)", from 0.5997 vs 0.5987 and 0.3496 vs 0.3487. The first pair reads as a one-digit value against a three-digit one.
`:254-255`: "expected 0.321" beside "0.3209". `:254` also rounds the s.e. 0.000132 to one significant digit at the precision of the mean.

### 00-R9 -- Info -- scale sentence is wider than the chunks
`book/00-hybrid-programme.qmd:30-33`: "The live examples run at the teaching scale". `hp-ibs-ibd` (2000 loci, 200 pedigrees) and `hp-drift` (20,000 loci) do not use `book_cfg`; both state their own parameters in the text.

### 00-R10 -- Info -- code hygiene
- `:328` `pB` is assigned and never used.
- `:114, :118-121, :328`: matrix subsets without `drop = FALSE`. They cannot collapse at 25 + 25 lines.
- `:41, :337-340, :456`: `all.equal()` at its default 1.5e-8 on exact identities. Observed deviations are 0 to 5.6e-17; it does catch a planted single-cell error of 1e-5. `:123` uses 1e-10 against 3.7e-13.
- `:512-513`: comments hand-type "10 plants"; the value is `n_plants`.
- `:590`: "cached results are fetched on first use" is footer boilerplate; this chapter reads no cached file.

## Verified

**Execution.** All chunks run clean against the worktree `R/`, about 0.3 s in total; all `stopifnot()` pass. The installed `hybdiv` has body-identical code to the worktree for the 14 functions on the chapter's call path, so frozen output and `load_all` agree.

**Names and arguments.** `simulate_data`, `simulate_lines`, `molecular_coancestry`, `heterosis_gca_sca(U, V, d)`, `gene_diversity(idx, ctx)`, `sel_greedy(ctx, n_sel, w)`, `he_nei`, `gd_partition` match `R/`. `run_cycles` is exported and rebuilds each pool within itself (`R/14_cycles.R`).

**Numbers: live run = frozen markdown = docs (apart from 00-R1).**

| Line | Quantity | Value |
|---|---|---|
| 31-32, 44 | lines, markers, hybrids | 25 + 25, 2000, 625 |
| 64 | F_6 | 0.9844 |
| 130-134 | halves, cor, top-5 | 12 / 13, 0.859, 3 |
| 252-257 | pool, random mean, expected, max, greedy | 0.3281, 0.3209, 0.3210, 0.3251, 0.3296 |
| 347-351 | He_A, Ho, He, GD_BS | 0.295, 0.362, 0.328, 0.0336 |
| 419-428 | full sib, expected, unrelated, expected, gap | 0.7264, 0.7264, 0.6351, 0.6352, 0.0912 |
| 458 | max abs diff F vs fL | 0 |
| 525-528 | retained | 0.5997 / 0.5987, 0.3496 / 0.3487 |

**Stochastic assertions over seeds (criterion 7).** Nominal false-alarm rate is 0.27% per assertion.

| Chunk | Book-seed z | Seeds | Failure rate | z mean, sd |
|---|---|---|---|---|
| `hp-subset-gd` | -0.67 | 1000 | 0.2% | -0.02, 1.01 |
| `hp-ibs-ibd` (2 assertions) | 0.11, -0.18 | 300 | 0.33% any | -0.09, 1.06; -0.08, 0.99 |
| `hp-drift` (2 assertions) | 0.37, 0.32 | 300 pairs | 0.33% any | -0.08, 0.98; 0.05, 0.99 |

- The closed form at `:224` is exact: literal enumeration of all 495 subsets (N = 12, n = 4) gives difference 0. One separate 2e5-subset run gave z = -2.19; the 1000-seed sweep pools the same number of subsets at z = -0.6, so I read that as chance.
- Greedy above pool: 30/30 founder draws, minimum margin 0.0008; greedy above the largest random subset 30/30, minimum 0.0022.
- GCA: `cor(g1, g2)` = 0.867 +- 0.048 over 200 `d` seeds (range 0.708-0.959); 0.832 +- 0.046 over 200 random splits; 0.847 +- 0.058 over 30 founder draws. Below 1 in every case, so "different GCA against a different tester set" holds beyond one seed. Top-5 overlap at seed 4 is 3; over 200 `d` seeds: 1 (2), 2 (17), 3 (80), 4 (87), 5 (14). The chapter's values are typical, and it labels them one seed.
- `hp-drift` treats loci as replicates, which is valid here: each locus is an independent chain, and the text says so.

**Identities.** Maximum deviations at book scale: `GD = He`, `He = GD_T`, `Ho = GD_T + GD_BS` 5.6e-17; `He_A = 1 - theta_A` 0; `fL` vs `molecular_coancestry(GL)` 0; `GD_T = GD_WI + GD_BI + GD_BS` 0.

**Algebra checked by hand.** @eq-hp-gd; @eq-hp-ibs-ibd, including its `i = j` case (`p^2 + q^2 + pq`); @eq-hp-drift; the GCA weight `a + d(1 - 2 p_B)`, matching `04e:178` and `R/13_dominance.R`; the `(1 - b)/4` full-sib gap.

**Definitions against code.** `F_drift` and `F_hom` (`R/01_metrics.R:224-225`); `F_ST = GD_BS / GD_T` (`gd_partition`), live 0.1024 vs `fst` 0.15, consistent with `90-notation:151-165`; alpha and `gd_ref` (`06:568-572`, mean of random subsets of size n); `rgamma(m, 2, 4)` with `set.seed(4)` as in `05b:15-16`; A1, A2, A3, A5 exist as cited at `05:46-91`.

**Seeds (criterion 2).** `set.seed()` sits immediately before each draw that matters (`:115, :238, :394, :512, :513`); `simulate_*` seed themselves. No AlphaSimR or MaCS.

**Data (criteria 1, 4, 9).** The chapter reads no `book/data` or `book/figs` file and nothing from `report/`, `data/` or `reference/`. No hand-typed result in the prose; remaining literals are definitional (`1/4`, `0.5`, `1`) or tied to a constant in a chunk ("five", "three standard errors").

**Artefacts.**
- Both freeze hashes equal the md5 of the `.qmd`.
- `book/downloads/00-hybrid-programme.R` is identical to a fresh `make_downloads.R` output (run in a temp copy) and to `docs/downloads/`. It runs standalone in an empty directory and reproduces the values.
- All 50 `@sec/eq/fig/tbl` references resolve to a chapter listed in `_quarto.yml`.
- `fig-hp-cycle` (frozen PNG, viewed): boxes, dashed returns and triangles match the caption and `fig-alt`. Its label is explicit, and no chunk change is proposed, so nothing is orphaned (criterion 6).

## UNVERIFIED

- Citations and what they are said to establish (`:63, :82-84, :169, :277-281, :369-373, :385, :440, :445-446, :473`): `quant-refcheck`'s remit.
- No `quarto render` was run. Inline values were evaluated from purl'd chunks; the printed form comes from the committed freeze, `docs/` and PDF.
- `figure-typst/fig-hp-cycle-1.svg` not viewed.
- `gca_err` (3.7e-13) is a rounding residual and may differ on another BLAS; not tested.
- `devtools::test()` not run: nothing under `R/` changed.
- Forward-pointer content beyond what is listed above: anchors for `@sec-mating-tester`, `@sec-mating-sparse`, `@sec-era-transposition` resolve, but their text was not compared with this chapter.
- Out of scope, for the chapter 08 audit: `book/data/pipeline_loss_ledger.csv`, behind `:271`, is named nowhere in `R/`, `inst/` or `book/scripts/`; only `08-pipeline-stages.qmd` and `92-verification.qmd` mention it, so I found no producer.
