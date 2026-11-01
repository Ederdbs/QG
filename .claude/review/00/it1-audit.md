# 00-hybrid-programme -- iteration 1 audit (quant-audit)

Worktree `SB_quanti_gen-review`, branch `review`, HEAD 7952700. Read-only.

Method: `knitr::purl()` of the chapter, run twice from `book/` -- once with
`pkgload::load_all("..")` (worktree R/), once with the installed `hybdiv` 0.1.0
as `quarto render` would. Both give identical numbers. Scripts: `/tmp/aud00/run.R`,
`/tmp/aud00/refs.R`.

Live output (both routes):

```
lines_A 25  lines_B 25  hybrids 625  markers 2000
F_6 = 0.9844
gca_cor 0.8587374  top5_shared 3  sum(half) 12  sum(!half) 13
max|g1 - rowEffect(H1)| = 3.703704e-13
Ho_lines 0  He_pool_A 0.2953  Ho_hybrid 0.3617  He_hybrid 0.3281  GD_hybrid 0.3281
gd_partition: GD_T 0.3280928  GD_WI -4.4e-16  GD_BI 0.2944960  GD_BS 0.0335968  F_ST 0.1024
ibs: full_sib 0.7264 (se 0.0004) exp 0.7264; unrelated 0.6351 (se 0.0004) exp 0.6352
F_hyb vs fL[a,b]: max_abs_diff 0
drift: crossing_block 0.5997 (se 0.0026) exp 0.5987; DH_pool 0.3496 (se 0.0029) exp 0.3487
```

## Checklist

1. Hand-typed numbers: R6 (low).
2. Seeds: pass. `set.seed(4)` before `rgamma` (:110), `set.seed(21)` before the IBS loop (:322),
   `set.seed(11)`/`set.seed(12)` before each drift arm (:431-432); `hp-data` is seeded through
   `book_cfg$seed = 1` (fresh run reproduces the frozen numbers exactly). No AlphaSimR/MaCS.
3. Identities: every one the prose asserts is under `stopifnot()` -- `fL == molecular_coancestry(GL)`
   (:40), GCA = factorial row effect (:117), `He_A = 1 - theta_AA`, `GD == He`, `He == GD_T`,
   `Ho = GD_T + GD_BS` (:266-270), IBS-IBD expectation within 3 s.e. (:338), `F_(ab) = fL_ab` (:375),
   drift decay within 3 s.e. (:437). `F_ST = GD_BS/GD_T` (:390) is not asserted here but
   `gd_partition()` returns it as exactly that ratio (0.0335968/0.3280928 = 0.1024).
4. Reads nothing from disk except `_common.R`: pass.
5. Exported functions (`simulate_data`, `simulate_lines`, `molecular_coancestry`,
   `heterosis_gca_sca`, `gd_partition`, `he_nei`, `gene_diversity`) exist in the installed package
   and give the same numbers: pass, no `devtools::install()` needed.
6. No chunk change proposed that relabels a figure; the only figure chunk is labelled
   (`fig-hp-cycle`). Freeze `hash` in `html.json` and `typ.json` = `md5(00-hybrid-programme.qmd)`
   = 25d87f63...; both freeze files and `docs/00-hybrid-programme.html` carry the current numbers.

Cross-references: all 46 `@sec-/@eq-/@fig-` targets and all 13 citation keys resolve.
Cross-chapter claims checked against their targets: 04e:178 GCA formula, 05b:756 dominance part,
05b:16 `rgamma(m, 2, 4)`, 05b:207 identity section, 08:167 "largest share ... at S2",
90-notation:136-146 F_BN vs F_ST, 05:891ff DH `n_gam = n`, R/01_metrics.R:224-225
`F_hom` can be negative / `F_drift` never negative -- all consistent.

## Findings

| ID | Sev | Where | Finding | Evidence | Proposed fix |
|---|---|---|---|---|---|
| 00-R1 | med | book/00-hybrid-programme.qmd:347-351 | "Molecular coancestry is pedigree coancestry plus a floor" misstates @eq-hp-ibs-ibd, which the chunk just verified: E[f] = floor + (1 - floor) A/2, not A/2 + floor. The pedigree part is shrunk by (1 - floor). | full_sib - unrelated = 0.7264 - 0.6352 = 0.0912, not A/2 = 0.25; 0.25 x (1 - 0.6352) = 0.0912. | "Molecular coancestry is a floor set by the base frequencies plus pedigree coancestry scaled by one minus that floor"; optionally print `ibs[["full_sib"]] - ibs[["unrelated_expected"]]` inline. |
| 00-R2 | low | :314-317 vs :332 | Prose says full sibs and unrelated individuals are "both bred from parents drawn in Hardy-Weinberg proportions"; the unrelated pair is the parents themselves (`rbind(mo, fa)`), drawn directly from the base, and each unrelated pair is the parent pair of a full-sib pair. | code :329-332. | "full sibs bred from two parents drawn in HW proportions from a base ..., and those two parents as the unrelated pair". |
| 00-R3 | low | :104-105, :112, :129-130 | "two disjoint halves of pool B" / "testers of `r sum(half)` lines": the halves are 12 and 13 lines, the inline value reports only the first. | `sum(half)` = 12, `sum(!half)` = 13. | "testers of `r sum(half)` and `r sum(!half)` lines". |
| 00-R4 | low | :123-124 vs :117 | "equals the row effect of the factorial to machine precision": the assertion is `all.equal` (tolerance 1.5e-8), so the claim is not what is checked. True value is 3.7e-13. | `max(abs(g1 - (rowMeans(H1) - mean(H1))))` = 3.703704e-13. | Either "to within `r signif(max(abs(...)), 1)`" inline, or drop "machine precision" for "exactly, up to rounding". |
| 00-R5 | low | :261, :266, :274 | `Ho_lines == 0` cannot fail: `GL = simulate_lines(book_cfg) / 2` is 0/1 by construction (`table(GL)`: 0 = 50416, 1 = 49584; no 0.5). The prose presents it as a result ("The lines are heterozygous at no locus"). | `table(GL)`. | Say "by construction (A2)"; keep the stopifnot as a coding guard, labelled as such. |
| 00-R6 | low | :30-31, :104, :316-317, :420 | Typed parameters: "25 lines per pool, 2000 markers", "the same 25 pool-A lines", "U(0.05, 0.95), 200 pairs ... 2000 unlinked loci", "20,000 independent loci". All currently match the code; they will drift if `book_cfg` or the chunk constants change. | `book_cfg` n_pool_A 25, m 2000; `n_pair` 200, `m_ibs` 2000, `m_dr` 20000. | :30-31 and :104 -> `` `r book_cfg$n_pool_A` ``, `` `r book_cfg$m` ``, `` `r nrow(U)` `` (after the chunk) or `book_cfg`; :316-317 and :420 precede the chunks that define the constants -> move `m_ibs`, `n_pair`, `m_dr` into a small chunk before the paragraph, or rephrase as "the sizes set in the chunk". |
| 00-R7 | nit | :119 | `order(-g1)[1:5]` -- house rule is `seq_len(5)`. | -- | `seq_len(5)`. |

## Summary

The chapter runs cleanly under both the worktree and the installed package, every number in
the prose is inline `r` and matches a fresh execution and the committed freeze (both formats,
hash current), seeds sit before every draw that matters, and every identity the prose asserts
is guarded by a `stopifnot()` that passes. All 46 cross-references and 13 citation keys
resolve, and the claims made about other chapters (04e/05b GCA formulas, the 05b gamma draw,
the S2 loss result of 08, F_BN vs F_ST in 90) agree with their targets. One substantive
wording error: 00-R1 states the IBS-IBD relation as "pedigree coancestry plus a floor", which
contradicts the equation the chunk verifies (the pedigree term is scaled by one minus the
floor; 0.091 not 0.25 for full sibs). The rest are low/nit: an inaccurate description of the
unrelated sample (R2), the 12/13 "halves" (R3), "machine precision" vs an `all.equal` check
(R4), a by-construction `Ho_lines == 0` presented as a result (R5), and typed parameter
values that should be inline (R6). No cached data or figures; nothing to regenerate; no
orphaned figures.
