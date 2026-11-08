# 02-subdivided -- iteration 1 response (quant-writer, content fix)

File edited: `book/02-subdivided.qmd` only. No earlier chapter changed (no C finding had an earlier-chapter owner). Nothing rendered, nothing committed, `make_downloads.R` not run (the chunks are still to be changed by quant-Rwrite; run it after).

**The chapter does not render until quant-Rwrite adds the chunk `fst-two-forms`** (see hand-off 1): the F_ST paragraph reads `fst_cmp` inline. That is deliberate: a missing chunk breaks loudly, a hand-typed 1.78 would not.

## Disqualifying (D)

| ID | Status | What changed / evidence |
|---|---|---|
| 02-D1 | fixed | Reference of f_ij (:61-64) restated as in 01: f is identity in state; equals pedigree coancestry only for a base with all alleles different (Caballero & Toro 2002, p. 292, text read in the PDF), which a biallelic panel cannot meet; expected unrelated level = base-population floor m^-1 sum(p_b^2+q_b^2) >= 1/2, observed level = panel floor, pointer to @sec-f-molecular and @tbl-panel-floor. Callout on F_i: F_i = 1 - H_o (the chapter's own eq.), no base; not a pedigree inbreeding coefficient; level depends on panel frequencies. The false "so" is gone. |
| 02-D2 | fixed | Five constraints: (1) F_ST kept as formula and GD_BS/GD_T, plus new @eq-f-stats-het: F_ST = (H_T-H_S)/H_T, F_IS = 1-H_o/H_S, F_IT = 1-H_o/H_T, plug-in H, locus-averaged numerator and denominator (derived from 1-f-bar = H_T, 1-f-tilde = H_S, F-tilde = 1-H_o; no citation needed). (2) New paragraph: a statistic referenced to between-population coancestry is also written F_ST, differs on the same data; per-locus result ratio = 4 pq/(2 pq + dp^2/2) in [1,2] (derived by hand; p = 0.2/0.6 gives 1/6 vs 2/7); the book's 30-hybrid ratio is read inline from `fst_cmp` (hand-off 1; my reading of the verdict: 0.126 vs 0.224, ratio 1.78, seed 7 -- to be reproduced by the chunk, not typed). No external source claimed for that usage, said so. (3) "Wright's fixation indices [@wright1951]" withdrawn; text now reports only: Eq. 6 of C&T 2002 writes the formulas and credits Wright (1969) (plain-text cite, no bib entry added); Toro & Caballero 2005 sect. 3a credit the D-bar form to Cockerham 1969; says the originals were not read. (4) No "Nei's G_ST" and no nei1973 for it; the symbol G_ST does not occur. (5) No 08 label or 08 section cited; the only cross-reference is @sec-hp-inbreeding (00:575-581), as the ruling allows. |
| 02-D3 | fixed | :363 now: example is "imaginary" (authors' words, p. 292), multiallelic, matrix typed from Table 2a (ten distinct entries compared with the printed table), Table 1 genotypes not reproduced so nothing recomputes f from genotypes. The :630-633 sentence is replaced by a "what was compared with what" paragraph: the 2002 paper read in full and compared on matrix, s-tilde, f-tilde, f-bar, D-bar, F statistics, GD components, Table 3, Eq. 6-8 and 14, Table 5; the 2005 review consulted in excerpts only; the sources not read are listed. I did NOT write "rebuilt the matrix from Table 1": that was the judge's script, not in the repo. The open 0.1-point difference in the equal-weights column (-6.92/-6.94 vs the paper's -6.8/-7.0, Table 3 col. 4) is stated as unexplained. |
| 02-D4 | fixed | Keystone row 3 now carries the conditions (flat dominance d_k = 1, inbred parents, complete AxB factorial, [equal pool weights in the closing paragraph]) and points to @eq-het-split and @tbl-het-partition-identity; "outside those conditions it is not an identity". Closing paragraph (:676-679) rewritten: "shared" term defined as 2 pbar qbar = GD_T, divergence y^2/2 = GD_BS; neutral redraws from the same ancestral frequencies (Balding-Nichols, @sec-heterosis-flat) leave the expectation of the sum unchanged, so GD_BS gained is paid unit for unit by GD_T (consistent with the :354-359 accounting, GD_T -Delta/2, GD_BS +Delta/2); GD_WS falls twice what GD_BS gains; not valid for non-flat dominance or divergence aligned with dominance (@sec-heterosis-alignment). |
| 02-D5 | fixed | "It is distant because it is fixed ... result of drift" removed. Result: D_2j contains f_22/2 (@eq-nei-distance), f_22 inline; interpretation: cause of the near-fixation cannot be inferred from a coancestry matrix and the example is imaginary; no cause claimed. Pig breeds: FRBA +0.67 % cited to C&T 2002 Table 5 col. 3 (and 2005 Table 4), with the effective-size-weighted column (col. 6, FRBA -0.0) and the authors' argument for weighting (p. 295). Intro sentence (:16-20) reworded to "in the paper's own imaginary example". The callout "does not mean discard it" and the caveat on fixed accessions stay and are now consistent. |
| 02-D6 | fixed (prose); chunk -> Rwrite | New paragraph and @eq-alpha-baseline after @eq-alpha-g: for N_i diploids drawn at HWE, E[F_i] = sum p^2, E[f_ii] = sum p^2 + (1-sum p^2)/(2N_i), so ratio of locus-averaged expectations = -1/(2N_i - 1), G_i = (N_i-1)/(2N_i-1) < 1/2; alpha_i = -1/7 (N=4), -1/23 (N=12) are the null. Stated as exact for the ratio of expectations, first order for the expectation of the ratio; assumptions stated. @tbl-mating-meter first row changed from 0.5 to the baseline; sampling-design sentence (:159-162) reworded as a qualitative guide, not a sample-size calculation. The simulation check (judge: seed 5, 3000 loci, 60 replicates: alpha = -0.1404, -0.0436, -0.0104; G = 0.430, 0.478, 0.495) is NOT quoted; hand-off 3. |

## Non-disqualifying (M)

| ID | Status | What changed / evidence |
|---|---|---|
| 02-M1 | fixed (prose); chunk -> Rwrite | Notation bullet replaced: sums/means per locus then averaged; ratios (alpha_i, G_i, G, F_IS, F_ST, F_IT) from locus-averaged numerator and denominator; @eq-ratio-identities hold in that form only. Demonstration (judge: 0.043205 vs 0.041508, seed 2) not quoted; hand-off 4. |
| 02-M2 | fixed | (a) 0.67 % scoped (see D5): column, no effective-size weighting, col. 6 = -0.0. (b) The ranking is stated as the book's own, by mean Nei distance; the paper's Weitzman analysis uses Reynolds' distance, subpopulation 2 -65.5 %, subpopulation 3 -63.3 % (Table 3 col. 5), Nei distances "very similar, not shown". |
| 02-M3 | (a) owed -> quant-Rwrite; (b),(c) fixed | (b) after @eq-ne-meta: states Eq. 14 has (1-F_IT) and the chapter's form is F_IS = 0; the model (constant N, "any constant degree of migration", asymptote); F_ST is the metapopulation's asymptotic value, depends on contribution variances and migration, tends to 1 for closed pools so the formula has no meaning for the drift paragraph (which now says it is not the regime of @eq-ne-meta); "double" is at the same F_ST. (c) Stated that it does not apply as written to pools of inbred/DH lines (F_IS != 0, sampling unit one copy per line, @sec-hp-popgen). (a) the tautological chunk is untouched; hand-off 5. |
| 02-M4 | fixed | theta -> theta_S in the N_s paragraph and in the @tbl-keystone caption/rows; "1/(2 theta_S) of that chapter" kept with the warning: [1/2,1] is a property of biallelic markers, the multiallelic example has N_s = 1/(2 f-bar) = inline `fmt(1/(2*f_bar), 2)` (1.54) for 30 individuals, and in neither case a head count. Code variable `theta` in keystone-check left (chunk). |
| 02-M5 | fixed | Row 2 reworded: eroded by drift (the :354-359 argument); within-pool diversity also falls in the simulated cycles of @sec-cycles, where drift and selection act together and are not separated. "the one" removed. "Shared term" defined (D4). |
| 02-M6 | owed -> quant-Rwrite | Chunk assertions only (hand-off 6). The prose "the chunk asserts it" becomes true once the assertion is tightened; I did not weaken the prose. |
| 02-M7 | fixed, with two limits | B1: toro2005 sect. 4a -> 5a (both places), Eq. 14 of C&T 2002 added. B3: the small-sample factor is now derived in the D6 paragraph (E[1-f_ii] = H(2N-1)/(2N)), so it needs no source; no external source added (Nei 1978, Nei & Chesser 1983 formulas unverified). B4: lead-in marking the three bullets as the book's reading. B5: allelic diversity / bottlenecks cited to C&T 2002 p. 297. Falconer ch. 8 removed (the 0/0.5/1 variance is derived in the bullet). **Still unverified:** Falconer & Mackay "ch. 4" for N_e = 4N/(2+V_k) (kept, no one has read the book) and the toro2005 locators (PMC fragments). |
| 02-M8 | fixed | C3, C6-C8, C13-C18 individually below. |

## Continuity (C)

| ID | Status | What changed / evidence |
|---|---|---|
| 02-C1 | fixed (-> D1); owed -> 90 | `90-notation.qmd:179` carries the same "all alleles distinct" phrase: owed -> 90, not edited. |
| 02-C2 | fixed (02 side, -> D2); owed -> 08, 90, 00 | 08 Trap 2 (`08:86-106`): must adopt 02's name for GD_BS/GD_T or state it renames it, and attach no unverified historical label. 90: no row for the second F_ST-named statistic or for the one-sentence distinction (also 00 owed). 00:575-581 describes 08's labels as 08 stands: re-read when 08 changes. 02 is true today without any of them. |
| 02-C3 | fixed | Opening says the chapter follows @sec-coancestry, cites @sec-hybrid-programme/@eq-hp-gd and the departures of @sec-hp-not-animal; alpha defined by @eq-catalogue-alpha at first use. |
| 02-C4 | fixed (02); owed -> index, 90 | theta_S in 02. Bare theta also at `index:101`, `90:569`, `90:627`: other owners, not edited. |
| 02-C5 | fixed | See M4. |
| 02-C6 | fixed | Paragraph before `keystone-check`: individuals = parent-line slots, subpopulations = the two pools, usage weights equal across pools, GD_WI vs GD_WI-hyb same expression over different individuals, F_(ab) = f^L_ab of @sec-hp-inbreeding, @eq-hp-gd; teaching-scale census = usage weights so the check cannot distinguish them. (A check with unequal usage is optional, hand-off 7.) |
| 02-C7 | fixed | Notation bullet: i, ij subscripts are subpopulation quantities; N_i = 1 gives the meaning of 01/00; f in bold = n x n matrix of subpopulations. |
| 02-C8 | fixed | Notation: k = allele of one locus in the formulas, k = biallelic locus in the first bullet of @sec-ct-oc (stated at both places); tilde p_{k,i} defined. |
| 02-C9 | fixed (02); owed -> 11b, 90 | See M5. 11b: no GD_BI column and no arm without selection; `90:118` repeats "the one recurrent selection erodes". |
| 02-C10 | fixed | See D4. |
| 02-C11 | fixed | See M3(b),(c). |
| 02-C12 | fixed | See D3. |
| 02-C13 | fixed | Correspondence f_AA/f_BB/f_AB = theta_A/theta_B/theta_AB stated at the drift paragraph. |
| 02-C14 | fixed (02); owed -> 90 | F-tilde, s-tilde, D-bar (with its definition and Eq. 4) in Notation; I, S, T subscripts explained. 90 needs rows for F_IS, F_IT, D-bar. |
| 02-C15 | fixed | "frequency-based" removed; now "neither GD_T nor the genic variance, being functions of allele frequencies and not of haplotypes". |
| 02-C16 | fixed | @eq-hp-gd / @sec-identity cited at the plug-in remark; the genic-variance bullet says the derivation belongs to @sec-response. The derivation itself stays in 02 (deleting it is a rewrite of a section with no false claim; 02b keeps ownership). |
| 02-C17 | fixed | @tbl-hp-stages cited with S1. |
| 02-C18 | fixed | The OCS bullet states that c, f change object (N candidates, N x N). |

## Audit (R) and refs (B)

| ID | Status | What changed / evidence |
|---|---|---|
| 02-R1 | fixed (-> D3) | |
| 02-R2 | fixed (-> D2) | |
| 02-R3 | fixed (-> D4, M5) | The audit's "two units lost per unit gained" is the GD_WS accounting and is now stated as such; the D4 sentence is the GD_T one. |
| 02-R4 | owed -> quant-Rwrite | hand-off 6. |
| 02-R5 | (a) owed -> quant-Rwrite; scope part fixed (-> M3) | |
| 02-R6 | fixed (-> C3, C4) | |
| 02-R7 | no change | Info; the typed external values are labelled "quoted from the tables, not recomputed" and now cite table and column. |
| 02-R8 | owed -> quant-Rwrite | hand-off 8. |
| 02-R9 | not addressed | Out of scope (typst-style); (a) is an inline print precision, left. |
| 02-B1 | fixed | §4a -> §5a, Eq. 14 added. |
| 02-B2 | fixed (-> D3) | |
| 02-B3 | fixed | Derived, not sourced (see M7). |
| 02-B4 | fixed | |
| 02-B5 | fixed | |
| 02-B6 | fixed | wright1951 withdrawn from the chapter; the bib entry is left in `references.bib` (still cited by `05-genomic-era.qmd`; not touched). Cockerham 1969 kept as "credited by Toro & Caballero 2005". |

Counts (47 IDs): fixed 40 (D1-D6; M1, M2, M4, M5, M7, M8; C1-C18; R1, R2, R3, R6; B1-B6; the chunk halves of D6 and M1 are in the hand-off), partly fixed 1 (M3: (b),(c) fixed, (a) owed), owed -> quant-Rwrite 4 (M6, R4, R5 (a), R8), no change 2 (R7 Info, R9 out of scope), contested 0. Earlier chapters changed: none. Owed to later chapters: 08, 90, 11b, 00 (below).

## Owed to other chapters (not edited)

- -> 08: Trap 2 (`08:86-106`) names and "Wright" label, as in C2.
- -> 90: `90:179` ("all alleles distinct" phrase); `90:118` (GD_BI erosion by selection); `90:569`, `90:627` and `index:101` bare theta; rows for F_IS, F_IT, D-bar and for the second F_ST-named statistic.
- -> 11b: no GD_BI column, no arm without selection (what @sec-cycles can claim for row 2 of @tbl-keystone).
- -> 00: re-read 00:575-581 when 08 changes.

## Hand-off to quant-Rwrite (chunks and assertions)

1. **New chunk `fst-two-forms`, before the paragraph "It is not the only statistic written F_ST"** (F statistics section). Defines `fst_cmp`, a named numeric with elements `this`, `between`, `ratio`. `set.seed(7); idx <- sample(ctx[["N"]], 30)` (same draw as `keystone-check`); `tp <- theta_pools(idx, ctx)`; `f_til <- (tp[["theta_A"]] + tp[["theta_B"]]) / 2`; `f_bar <- (tp[["theta_A"]] + 2 * tp[["theta_AB"]] + tp[["theta_B"]]) / 4` (as in `R/01_metrics.R:156`); `this = gd_partition(idx, ctx)[["F_ST"]]` asserted equal to `(f_til - f_bar)/(1 - f_bar)`; `between = (f_til - tp[["theta_AB"]])/(1 - tp[["theta_AB"]])`; `ratio = between/this`. In the same chunk assert the one-locus claims: for random `pA, pB` the ratio equals `4*pb*qb/(2*pb*qb + dp^2/2)` and lies in [1, 2]; the p = 0.2/0.6 case gives 1/6 and 2/7. (The verdict's run gave 0.126279 and 0.224241, ratio 1.78; the chunk, not that run, is the source of the printed numbers.)
2. **@eq-f-stats-het**: in `ct-identities` assert `F_ST == (H_T - H_S)/H_T`, `F_IS == 1 - H_o/H_S`, `F_IT == 1 - H_o/H_T`, with H_T = 1 - f_bar from pooled allele frequencies and H_o the N_i-weighted observed heterozygosity.
3. **@eq-alpha-baseline**: exact check, enumeration over the allele count Binomial(2N, p) for N = 4, 12, 50 and several p (sample frequency p~, `f = p~^2 + q~^2`, `F` expectation p^2 + q^2), asserting `E[F - f]/E[1 - f] == -1/(2N - 1)` and `(1 + that)/2 == (N-1)/(2N-1)`; optionally the verdict's seed-5 simulation as a second line (60 replicates, 3000 loci, report mean and s.d.).
4. **M1 demonstration**: ratio of means = GD_BS/GD_T versus mean of per-locus ratios on a multi-locus two-pool draw (`set.seed` before the draw); print both and the difference.
5. **M3(a)**: replace `ne-equal-seed`'s tautology by a literal gene-dropping oracle (N = 100 monoecious, unlinked biallelic loci at p = 0.5, >= 20 generations, several independent pedigrees per scheme, slope of log H_t; random, mothers once/father random, both once), with s.e., seeds set before each draw; expect ~100, ~133, ~200. Drop "Falconer & Mackay, ch. 4" from the comment or keep it consistent with the text (text keeps "ch. 4", unverified).
6. **M6 / R4**: `identical(unname(round(oc[["c_i"]], 3)), c(0.522, 0, 0.270, 0.208))`, `oc[["c_i"]][2] == 0`; `stopifnot(lg$delta_pct[2] > 0, all(lg$delta_pct[-2] < 0))`; `stopifnot(computed[["F_ST"]] < 0.2)`; `f_bar == mean(molecular_coancestry(geno/2))` equal to `ct_partition(...)$global[["f_bar"]]` on the toy. Prose already says "the chunk asserts it".
7. Optional (C6): a `gd_partition` check with unequal line usage, to show census and usage weights differ.
8. **R8**: declare `tolerance = 1e-12` for the exact identities; keep the negative control.
9. Optional (M4): rename the code variable `theta` in `keystone-check` to `theta_S`.
10. After the chunks: `Rscript book/scripts/make_downloads.R`; render is yours.

---

# Part 2 -- quant-Rwrite (code fix after REJECTED, iteration 1)

Files edited: `book/02-subdivided.qmd` (chunks, assertions, and the inline sentences that read the new values), `book/downloads/02-subdivided.R` (regenerated by `make_downloads.R`). `R/` not touched by this step (the diffs in `R/00_data.R`, `R/01_metrics.R`, `man/` predate it, from chapter 01), so `document()`/`install()` not run. `devtools::test()`: FAIL 0, WARN 0, SKIP 0, PASS 492. Chapter knitted against `load_all` (purl + `knitr::knit`): every chunk runs, 4.3 s total, every inline value resolved; no chunk reads a cached file; no `book/Rplots.pdf`. Nothing rendered, nothing committed. New labels: `alpha-baseline-check`, `fst-two-forms`, `ne-gene-dropping` (`ne-equal-seed` kept, tautology demoted to a labelled algebra line); no existing chunk relabelled or removed, so no `unnamed-chunk-*` orphans.

| ID | Status | Evidence (measured) |
|---|---|---|
| hand-off 1 / 02-D2 (chunk half) | fixed | `fst-two-forms`: same draw as `keystone-check` (`set.seed(7)`, `sample(ctx[["N"]], 30)`; `keystone-check` now asserts `identical(idx_h, idx_f)`). `gd_partition()$F_ST` equals `(f_til - f_bar)/(1 - f_bar)`, deviation 0 (assert 1e-12). `fst_cmp`: this 0.1263, between 0.2242, ratio 1.776 (prints 1.78): the prose matches the verdict's 0.126 / 0.224 / 1.78. One-locus closed forms (200 random pairs, seed 11) asserted at 1e-12: this = dp^2/(4 pb qb); between = dp^2/(2 pb qb + dp^2/2); ratio = 4 pb qb/(2 pb qb + dp^2/2), in [1, 2]; (p_A, p_B) = (0.2, 0.6) gives 1/6, 2/7. |
| hand-off 2 (@eq-f-stats-het) | fixed | `ct-identities`: H_T from pooled frequencies, H_S N_i-weighted mean of 2pq, H_o from genotypes; asserted at 1e-12: `1 - f_bar == H_T`, `1 - f_til == H_S`, `F_ST == (H_T-H_S)/H_T`, `F_IS == 1 - H_o/H_S`, `F_IT == 1 - H_o/H_T`. Deviations: 0, 0, 3.3e-16, 5.0e-16, 5.6e-17. Over toy seeds 1-20: max 7.2e-16 (F_ST), 1.1e-15 (F_IS), 3.9e-16 (F_IT). |
| hand-off 3 / 02-D6 (chunk half) | fixed; the derivation holds | `alpha-baseline-check`. (1) Exact enumeration of all genotype-count outcomes (multinomial, HWE), N = 4, 12, 50, p in {0.05, 0.2, 0.5, 0.7, 0.95}: E[F - f]/E[1 - f] = -1/(2N-1) at every locus and for the locus-averaged ratio; G = (N-1)/(2N-1); max deviation 4.0e-15, asserted < 1e-12. (2) Simulation (`set.seed(5)`, 60 samples, 3000 loci, through `ct_partition()`): mean alpha_i = -0.1421, -0.0433, -0.0105 against -0.1429, -0.0435, -0.0101; mean G_i = 0.4289, 0.4784, 0.4948 against 0.4286, 0.4783, 0.4949; max |z| = 1.04 Monte Carlo s.e., asserted < 4 s.e. Over 20 other seeds the max |z| is 2.44 (never above 2.5). The derivation does not fail. The "algebra, not a measurement" sentence is replaced by the two checks. |
| hand-off 4 / 02-M1 (chunk half) | fixed | In `ct-identities`: ratio of locus means (= `gl[["F_ST"]]`, via the F_ST assertion above) 0.2836 against mean of per-locus ratios 0.2715, asserted different at the default tolerance, `all(H_T_l > 0)` asserted. Read inline after the chunk. (Judge's two-pool case: 0.0432 vs 0.0415; this toy is more differentiated.) On toy seeds 1-20 some seed has a monomorphic locus (NaN in the per-locus ratio): seed 1, the one used, has none, and the assertion `all(H_T_l > 0)` would stop the chapter if that changed. |
| hand-off 5 / 02-M3(a), 02-R5 | fixed; holds | `ne-gene-dropping`: literal gene dropping, N = 100 monoecious, L = 500 unlinked loci at p = 1/2, T = 25, R = 30 independent pedigrees per scheme, seeds 101-103 set before each scheme, slope of log H_t per pedigree, N_e from the exact inversion 1/(2(1 - e^slope)). Comparison on the slope against its Monte Carlo s.e. over the 30 pedigrees, tolerance 3 s.e. (no other slack). Result N_e = 98.2 (s.e. 1.6), 133.9 (1.7), 199.0 (2.5) against 100, 133.3, 200; z = -1.13, 0.33, -0.38. 20 other seed sets: |z| max 2.09, 1.90, 2.32, sd(z) 1.08, 0.97, 0.82, mean z -0.03, 0.07, -0.40, no |z| > 3. Cost O(R x T x N x L) per scheme, 3.5 s for all three. The algebraic equivalence of the two forms stays as one labelled line (not evidence). The "ch. 4" Falconer citation is untouched. |
| hand-off 6 / 02-M6, 02-R4(a)(b)(c)(d) | fixed | `identical(unname(round(oc[["c_i"]], 3)), c(0.522, 0, 0.270, 0.208))` holds (c = 0.522398, 0, 0.269890, 0.207711); `oc[["c_i"]][2] == 0` holds exactly. `lg$delta_pct[2] > 0, all(lg$delta_pct[-2] < 0)` and the same for the equal-weight column hold (census -6.65, +1.84, -3.91, -0.81; equal -6.92, +6.47, -6.94, -3.56); also asserted `which.max(diag(f)) == 2` (prose "far above the other diagonal entries"). `computed[["F_ST"]] < 0.2` holds (0.1897, margin 0.0103). `mean(molecular_coancestry(geno/2)) == gl[["f_bar"]]` holds, deviation 0 (20 toy seeds: max 2.2e-16). |
| hand-off 7 / 02-C6 (optional) | fixed, with a correction | Writing the check showed the writer's sentence "at the 25 + 25 lines census and usage weights coincide" is false: in the 30-hybrid sample the usage of pool-A lines is unequal (usage counts 1, 2, 3, 5 on the lines drawn). Sentence replaced: within a pool the weights are the usage of each line, so the individuals are the 30 line slots per pool, not its 25 lines; `keystone-check` asserts the unequal usage. |
| hand-off 8 / 02-R8 | fixed | `tolerance = 1e-12` on every exact identity of `ct-identities` and `keystone-check`; the negative control keeps the default 1.5e-8 on purpose (a gap of 1e-3 to 8.6e-3 per the audit). `abs(GD_WI) < 1e-12` unchanged. |
| hand-off 9 | fixed | `theta` -> `theta_S` in `keystone-check`. |
| hand-off 10 | done | `make_downloads.R` run (download script now contains the new chunks). |
| 02-D2, 02-D6, 02-M1, 02-M3, 02-M6, 02-R4, 02-R5, 02-R8 | fixed | with the rows above; their prose halves are quant-writer's. |
| 02-R9 | contested (out of scope) | `typst-style.typ`, not this chapter; (a) print precision of `fl-ranges` untouched. |

Open and not mine: Falconer & Mackay ch. 4 and the `toro2005` locators remain unverified (writer's note); 08, 90, 11b, 00 hand-overs unchanged.
