# 06-metric-catalogue -- iteration 1 response (quant-writer)

Files touched: `book/06-metric-catalogue.qmd`, `book/90-notation.qmd` (one row, diff below), `book/downloads/*` via `make_downloads.R`. No Quarto render. No `R/`, `CLAUDE.md`, `10b` edit. Line numbers are of the edited qmd.
Check run: whole chapter knitted (inline R included) to a scratch file, 0 errors; 29 s.

## Runs made (all reported)
- Chapter knit: 2 runs (one before and one after the last prose edits); no seed, parameter or tolerance changed between them.
- `tbl-catalogue-seeds-z` (new): data seeds 1-20, `B = 200, B_full = 300, seed = 7` (same design as 05's `tbl-era-seeds-z`), one run. GD z of `trunc_cap`: -4.16 to -0.35, median -2.08, |z| > 2 on 12/20 (reproduces the review's -4.16/-0.35/12 of 20). ANE z 14.0-18.8, > 2 on 20/20. |z F_drift| > |z GD| for truncation on 20/20; |z Ne_parents| < |z GD| on 18/20.
- `gdbs-concentration` (new): `set.seed(5)` before each of two `replicate(300, ...)`, one run. kA, kB = `ceiling()` of truncation's effective numbers of lines = 5, 12 (the 10 and 23 DISTINCT lines of truncation were looked at and not used; matching on effective number is the rule fixed before the draw). GD_BS: random 0.0358, concentration 0.0492 (s.e. 6.9e-5), truncation 0.0524, share 81 %.
- Null B changed 400 -> 2000 (D8); first run gives GD z -17.06, F_drift 35.08, F_hom 9.41, gd_ref 0.3258629, alpha(truncation) 4.129 %: all equal to 05's `tbl-era-signature-z`. The 400-draw version was not kept.
- `red-cache` (new): reads `book/data/metric_redundancy.csv`; Spearman(theta, .) 0.932, -0.925, -0.967 for `alleles_lost_MAF`, `Ne_parents`, `eff_dim`; csv `eff_dim` mean 1.49 (range 1.44-1.51); package `eff_dim` on the chapter's random subset 26.19, uncentered ratio 1.47.

## Diff of the earlier chapter (90-notation.qmd, 00-C28 / 06-C7)
```
-             "$GD_{\\text{random}(n)}$", "$\\omega$"),
+             "$GD_{\\text{ref}}$", "$\\omega$"),
-              "mean $GD$ of random subsets of size $n$, the reference of $\\alpha$; the same quantity as $GD_{\\text{ref}}$ (@eq-catalogue-alpha)",
+              "mean $GD$ of random subsets of size $n$, the reference of $\\alpha$ (@eq-catalogue-alpha); `gd_ref` in the code",
```
One symbol, `GD_ref`, in 06 (eq, caption, chunk label, prose) and 90.

## Disqualifying (D)
| ID | Status | Where / what |
|---|---|---|
| D1 (C2) | fixed | 217-237: GD/N_s are expected H_e of the merged set (@eq-hp-gd); F1 expected het = GD_T + GD_BS (complete factorial, usage weights), pairs kept = 2 GD_WI_hyb; chapter's own numbers inline (GD 0.3259 -> 0.3124 while GD_WI_hyb 0.1814 -> 0.1823, one draw); 05 finds no consistent sign over 20 draws (@tbl-era-seeds-z); "not a measure of next season's hybrid vigour". |
| D2 (C1, R1) | fixed | title 1 ("diversity metrics"), 12-37: four inputs named (f; marker frequencies + p0; pedigree; fL with usage); common signature kept; only first group reads hybrid f. |
| D3 (B1) | fixed | 327-346: mechanism attributed to Fernandez et al. (2004) for undivided populations as reported by the paper; subdivided: more homozygosity, allele loss (as the paper reports); "no longer the rarest" dropped; sentence "defends every segregating allele directly" dropped; says explicitly the step is not in the paper and not tested. Added: paper's markers are multiallelic haplotypes, not the biallelic MAF count (transfer limit). Checked against pdftotext of the paper (p. 2, 7-8). |
| D4 (B2) | fixed | 648-657: lambda = 1 mainly, also 0, 0.5, 1000 (p. 3); 0.5 from Bennewitz & Meuwissen (2006) as reported there (not read, no bib entry added); coincidence with lambda_d = 1/2 stated, with different arguments, relation not examined. |
| D5 (R12) | fixed | 291-320: "the one genuinely non-redundant" removed; says cached external, no producer; Spearman values computed from the csv in chunk `red-cache`; 07's two metrics (allelic richness, N_e,par) named without typed numbers; "most strongly" scoped to the table's metrics and "on this draw". |
| D6 (R13) | fixed (with a 07 finding) | 402-405 (A-NE paragraph): false provenance sentence removed, now "external data without a producer, cannot say which definition". 449-460: eff_dim csv 1.49 vs package 26.19 vs uncentered 1.47 on the chapter's random subset, computed in chunk; says the cached column looks uncentered, reading of numbers across scales (12000 vs 2000 markers), not verified, needs the producer. Never called reproducible. |
| D7 (R14) | fixed | 840-890: new `tbl-catalogue-seeds-z` (20 draws) and text: 12/20 with |z| > 2, range -4.16 to -0.35; "would not flag it" now holds on the draw and 8/20; robust statement is the GD/ANE contrast; limits named (unit = founder draw, one n, one scale, null 300). 18/20 reversal for N_e,par stated in the chunk output; 267-269 reworded to "on this founder draw", pointing to the table. |
| D8 (C4) | fixed | aligned B: `null_distribution(ctx, n_sel, B = 2000, B_full = 1000)` (759-760, caption of the z and alpha tables state B, seed, and that full draws depend on B); z now equals 05's (-17.06, 35.08); Monte Carlo error stated in text (relative s.e. of an s.d. = 1/sqrt(2(B_full-1)) = 2.2 %, z -17.1 +- 0.4, 35.1 +- 0.8, normal null NOT checked, mean error 0.03). gd_ref/alpha now equal 05's. |

## Non-disqualifying (M)
| ID | Status | Where |
|---|---|---|
| M1 (R7, C5) | fixed | 462-471: slogan replaced by the conditions (inbred, complete factorial, flat d => GD_BS itself; varying d => d-weighted version); data have no dominance, GD_BS here is a partition component. |
| M2 (R10, C5) | fixed | 507-565: additivity asserted (R^2 = 1); 05's algebra cited (@sec-era-step6); new concentration comparison (81 % of rise); isolated vs not stated (remainder: selection on index or unequal usage); one draw. The earlier "sampling variance of usage-weighted frequencies" mechanism dropped in favour of 05's algebra. |
| M3 (R2, C9) | fixed | 177-181: f is identity in state, floor set by marker frequencies, not 0 (@sec-coancestry, @eq-hp-ibs-ibd). Conclusion theta in [1/2, 1] unchanged. |
| M4 (R17) | fixed | 142-144: 5 % below a random subset of the same size (@sec-baseline). |
| M5 (C6) | fixed | column renamed `one_minus_theta_AB`; added `F1_realised` = 2 GD_WI_hyb; condition (complete factorial at usage weights) stated; max difference 0.0043 inline; 05b owns the identity, table says it checks @eq-het-theta-ab on selections, not an independent measurement; per-locus algebra now asserted on 10^4 random frequency pairs (seed 3). 651-695. |
| M6 (R11) | fixed | 759-775: apparent loss printed in percent, s.e. of GD_ref printed (`gap_se`), pointer to @tbl-gd-baseline (03) with no typed number. |
| M7 (R4, C7) | fixed | one symbol GD_ref (eq 750, tables, chunk element, 90). |
| M8 (R5, C8) | fixed | 108-123: derivation shows both terms (x x and (1-x)(1-x), @eq-f-molecular); result cited as @eq-hp-gd; label `eq-catalogue-gd-he` removed (only 06 used it), `eq-catalogue-theta-freq` added. |
| M9 (R6, C10) | fixed | "dominance effects" at both places (632 and the 462 rewrite); 90 already says "dominance effect". 04e, 08b, 12 still owed (not mine). |
| M10 (R8, C14) | fixed | per-locus means defined (H_S = m^-1 sum H_S,k, D_G likewise), "averaged over loci" in the d = 1 and the d_k identity; H_S = GD_WS = GD_WI + GD_BI stated (651-662). |
| M11 (R9) | owed to quant-Rwrite | stopifnot for @eq-catalogue-lambda-d and the varying-d identity: pure-code item, not done. |
| M12 (B7) | fixed | 277-281: closed-population condition for "irreversible"; source Lopez-Cortegano 2019 pp. 1-2 (short-term vs long-term response, bottlenecks), read in the pdf. |
| M13 (B8) | fixed | 591-593: D_G is the symbol of Lopez-Cortegano 2019 (who follow Nei 1973); Nei's own symbol not checked, abstract only. |
| M14 (R3, C12) | fixed | 498: `fmt_sci()`; 135: "exactly 0" else `fmt_sci(abs(.))`. |
| M15 (R15, C15) | owed to quant-Rwrite | `ctx$f` / `fake$f` left untouched (pure code). |
| M16 (R16, C15, C18) | partly | caption numbers under stopifnot: owed to quant-Rwrite (I changed B to 2000 in captions; the asserts `nrow(null$cheap) == 2000`, `nrow(null$full) == 1000` are part of that item). `theta_N` now defined at 708. 70-word caption block repeated: contested, `.claude/agents/quant-editor.md:31` requires a caption that stands alone; not changed. |
| M17 (C3, C11, R18, C16, C17) | fixed except R18 | opening says why 06 follows 05 (12-17); "production scale" now names 71 + 71 / 25000 and 50 + 50 / 5000 (806-808); frontier pointer to @sec-ocs (frontier, 09:202) and @sec-combinatorial (recipe, 10:884-889) (809-811); sec-richness inbound 0: not a defect. R18 (logical printed as 0): owed to quant-Rwrite. |
| M18 (R12 second half) | fixed | "of the metrics in @tbl-catalogue-z ... on this draw" (318-319). |
| M19 (C13) | owed (10b) | `10b:1245` cites a "rule" of @sec-catalogue that 06 does not state; 10b not edited. |

## References (B)
| ID | Status | Where |
|---|---|---|
| B1 | fixed | = D3. |
| B2 | fixed | = D4. |
| B3 belldean1970 | marked UNVERIFIED | 415-416: origin attribution flagged; paper could not be opened. |
| B4 lacy1989 | marked UNVERIFIED | 248-251: form 1/sum p_i^2 attributed, flagged; hypothetical 200-hybrid/12-line example flagged as constructed. |
| B5 cockerham1967 | marked UNVERIFIED, indirect support | 41-45: Caballero & Toro 2002 p. 290 averages over all pairs and cites Cockerham; Cockerham's text not checked. |
| B6 toro2020 | marked, abstract only | 204-207: abstract-level claim (negative N_e, no asymptote); formula pointed to @eq-era-rate (05), not attributed to the paper. |
| B7 | fixed | = M12. |
| B8 nei1973 | marked | = M13. |

## Continuity (C)
| ID | Status |
|---|---|
| C1 | fixed (= D2) |
| C2 | fixed (= D1) |
| C3 | fixed (opening, 12-17) |
| C4 | fixed (= D8) |
| C5 | fixed (= M2, M1): cross-reference to 05 for the algebra; what is and is not isolated stated. |
| C6 | fixed (= M5) |
| C7 | fixed (= M7, with the 90 diff above) |
| C8 | fixed (= M8) |
| C9 | fixed (= M3) |
| C10 | fixed in 06 (= M9); 04e:176, 08b:135/767, 12:262 remain owed to those chapters |
| C11 | fixed (= M17) |
| C12 | fixed (= M14) |
| C13 | owed to 10b (not edited) |
| C14 | fixed (= M10, M5): @eq-het-split cited instead of re-derived; the per-locus identity kept only as the H_S + 2D_G form |
| C15 | `theta_N` defined in 06; `ctx$f` owed to quant-Rwrite |
| C16 | fixed (= M17) |
| C17 | no defect, none made |
| C18 | contested (quant-editor.md:31, caption must stand alone) |

## Left to quant-Rwrite
R9 (assert @eq-catalogue-lambda-d and the varying-d identity, `lambda_d == 1/2` at flat d), R15 (`ctx$f`, `fake$f`, `ctx$N`, also the `ctx$f` inside the bias chunk), R16 (caption numbers under stopifnot, including the new B = 2000 / 1000 and `R_conc`), R18 (logical coerced to 0 in the `attainable` chunk).

## Not verified, stated in the text
Bennewitz & Meuwissen (2006); Cockerham 1967; Lacy 1989; Bell & Dean 1970; Nei 1973 full text; Toro et al. 2020 full text; the normality of the null that the 2.2 % relative s.e. assumes; the cached csv's producer and its eff_dim form; any result at another scale or subset size.

## quant-Rwrite (code items left by quant-writer; chapter knit end to end, 0 errors, 24 s; no R/ edit)
| ID | Status | Where (book/06-metric-catalogue.qmd) |
|---|---|---|
| R9 | fixed | 698-733 chunk `lambda-d-check`: `stopifnot` on `sum_k d_k(H_S,k+2D_G,k)/m == 2 dbar_D (D_G + lambda_d H_S)` and `== heterosis_expected()/m` (tol 1e-12) for the five selections, flat d (lambda_d == 1/2 to 1e-12) and gamma(2,4) d (seed 8); also asserts dbar_D > 0, dbar_H >= 0. Pools from `line_weights()` x `simulate_lines(book_cfg)/2`. Result: lambda_d 0.505..0.512, relative error <= 4e-15 (printed inline via fmt_sci). |
| R15 | fixed | 189, 192 `fake[["f"]]`; 759 `ctx[["f"]]` (3 uses); every `ctx$N` -> `ctx[["N"]]` (incl. 9, 77, 716). `grep 'ctx\$f\|fake\$f\|ctx\$N'` empty. |
| R16 | fixed | 799-802 `stopifnot(book_cfg$seed == 1, n_pool_A == 25, n_pool_B == 25, nrow(null$cheap) == 2000, nrow(null$full) == 1000, max_line_use(sels$trunc_cap, ctx) == 4)`, right after `null_distribution(B = 2000, B_full = 1000)`. `R_conc` is an inline variable (not typed in a caption): no assert needed. |
| R18 | fixed | 840-842 `list(...)`: `constraint_is_active` prints TRUE/FALSE, not 0. |
Also: `book/downloads/*` regenerated (make_downloads.R); no stray `book/Rplots.pdf` or `book/figure/` present. No R/ change, so no document()/install/test run.
