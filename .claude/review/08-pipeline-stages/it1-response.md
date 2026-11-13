# 08-pipeline-stages -- response to iteration 1 (content pass; quant-Rwrite follows)

Chapter: book/08-pipeline-stages.qmd (rewritten in place, sections and trap order kept).
Also touched (earlier chapters, minimal): book/05-genomic-era.qmd (05:1777), book/00-hybrid-programme.qmd
(00:579-582), book/90-notation.qmd (the "write that parameter as F_ST" list at 90:154, the G_ST row at 90:270).
Regenerated: book/downloads/*.R (make_downloads.R; 00, 02, 05, 06, 07, 08, 90 changed). R/ untouched.
Whole chapter knitted end to end with knitr into the scratchpad (rc 0, every stopifnot passes); book/figure scratch
removed. No Quarto render, no freeze update: 08 (and 00, 05, 90) are stale in docs/ and book/_freeze/ until the render
batch. The figure chunk is now labelled `fig-theta-by-size`, so the old `unnamed-chunk-15-1` files in docs/ and
_freeze/ are orphaned at the batch render.

## What changed in the code of the chapter (so quant-Rwrite does not redo it, and can check it)

Made because the prose depends on it; R/ itself is untouched.
- `stopifnot()` added to: Trap 1 (now against `dist(GL)/sqrt(m)`, not through `mrd_matrix()`, which is built from `f`, so the old check was circular), the partition, F_ST == `gst_nei()`, ratio == 2 - F_ST_btw (live and all 7 cached rows), S4 usage vs `ref_theta`, He from frequencies == 1 - theta, and the new identity `mean_sq_delta_p == 2 F_ST GD_T`.
- DH identities: (c) against a literal pair-by-pair expectation matrix; (a), (b) by gene dropping (tolerance 2e-3); sigma2_DH against gene dropping at free recombination (3 %, observed 0.5 %). New seeds 89, 90 immediately before each draw.
- Trap 3 sweep replicated: 4 levels x seeds 1..20 (was one draw, seed 3). Ledger and end-point tables computed from `led` (were hand-typed). Trap 5: incremental greedy now actually run (returns size 0, asserted); 20-world count chunk added; figure chunk seeded (`set.seed(5)`), labelled, and asserted.
- NOT done (R IDs for quant-Rwrite): the fix of `select_lines_constrained()` in R/05 (2-cycle, no warning, no swap count) with a test on `simulate_pools(30,30,3000,0.15,seed=12)`, alpha 0.005; after it, the chunks `trap5-repair` and `trap5-worlds` will print new numbers and the sentences "Result, as the function is shipped", "as shipped, the repair is not guaranteed ... cannot be presented as the working route", "The loop exits after max_swap swaps with no warning", the "swaps not returned" cell of the cost table and checklist item 5 must be rewritten to the fixed behaviour (the counts are inline and recompute by themselves; the verdict sentences do not). No `stopifnot(met)` was added, because it would break the render today.

## Verdict IDs

| ID | Status | What was done / evidence |
|---|---|---|
| 08-D1 | fixed in prose, code owed | The route is no longer called "the working route". Chapter reports its own output: theta 0.67554 vs ceiling 0.67464, `met` 0, `same_as_top` 1 (inline, conditional on the output); `met` printed 0/1 with a legend; 20-world chunk (seeds 1..20): top violates 10, repair meets 13 (3 of the 10 violating), returns the truncation set in 15 -- identical to the verdict's rerun. Greedy "returns empty" now run (size 0). "swaps typically under 20" removed. R/05 fix: Owed to quant-Rwrite. |
| 08-D2 | fixed | "Decouple from F_ST" withdrawn. Sweep replicated (20 seeds x 4 levels): `mean_sq_delta_p == 2 F_ST GD_T` to 5e-15 (asserted); r(F_ST, mean_sq_delta_p) = 0.9984 (0.9997 against F_ST_btw, the verdict's figure; the chapter now uses the book's F_ST). What decouples is expected heterosis (05b), said to be outside the chunk. Causal "buying oppositely-fixed loci costs a great deal" replaced by what was varied (F_BN) and a statement that fixed-opposite loci were not isolated; d = 1 condition stated; "real dent-versus-flint pair" claim removed; frac_opposite_fixed reported with its range; dispersion (s.d. over seeds) in the table. |
| 08-D3 | fixed | Claims "the diversity benefit is not [real]" and "neither improves" removed. Table of four outcomes with paired difference, 95 % CI and pools-higher count, from `led`: merit -3.69 (-4.96, -2.42), 8/8 lower, p 0.00024; GD of final set +0.0078 (0.0021, 0.0136), 7/8, p 0.0147; Ne +1.13 (-0.97, 3.22) = -4 % to +13 %; alleles +41 (-101, 182) = -0.9 % to +1.6 %. GD_final declared post hoc, unadjusted; stated that at a Bonferroni level of 0.0125 only merit survives. "Reconverges / partly reclaimed" reworded to the observed signs (S2 loss lower 8/8, S3 and S4 higher 8/8) with the mechanism marked untested; "carry the constraint through all four stages" marked untested. The old blockquote is removed. |
| 08-D4 | fixed (declared) | Opening paragraph and a "Provenance" paragraph before the ledger name the five artefacts as cached, external, no producer, never reproducible, listing what the file does and does not record (markers, F_BN, crosses/DH per cross, S2 baseline, form/weight of the diversity term, the set Ne and alleles were computed on); the study's design numbers are marked as quoted and unverifiable. End-of-pipeline table computed from `led`. Trap 4: 300 crosses per stratum sharing parents, A x A only, said in the caption. Scales named (C21). Captions of both cached figures say so and translate the figures' own old names. |
| 08-D5 | fixed | 77 % no longer unconditional anywhere (lead, caption, checklist 8 reworded). Table by arm with share mean and pool range: UC only 77.5 / 2.5 / 20.0 (S2 range 63.0-81.4), UC + div 35.5 / 29.0 / 35.5; stated as a share of a SUM of re-based proportional losses; 2/48 negative rows reported; end-to-end change of GD (13.1 % / 10.7 %) given beside it and labelled as including the baseline-sampling effect. "Merit only" replaced by the file's `UC only` (usefulness criterion) with the definition. "Structural reason" (20 of 1770) removed and replaced by a hypothesis paragraph (usage of parents, not fraction of combinations; not varied); "cheapest stage to constrain" withdrawn. |
| 08-D6 | fixed | Book naming: the chapter's G_ST is now F_ST = GD_BS/GD_T (= Nei's G_ST, code `Gst_Nei`, @nei1973, @caballero2002, @eq-f-stats); the between-referenced statistic is F^btw_ST (code `Fst_Wright`, "Wright" stated to be the code's label, no source, not used by 02). "Both in routine use" and "published threshold" removed; the cached figure's own wording is flagged in its caption. `fst` is F_BN throughout (including "target F_ST = 0.15"). Ratio identity 2 - F^btw stated with the equal-weight derivation and asserted (live, and 7/7 cached rows). theta_B -> theta_AB (with the package clash named); theta_w, theta_T, w_p, theta_pq defined; "GD_within" = GD_WS (census-weighted); checklist/prose per-pool wording now refers to `GD_A`, `GD_B`. |
| 08-D7 | fixed | u -> k (count vector), w = k/(2n) (the 90 symbols); theta_hyb, theta_pool -> theta_S; `Ne` -> N_{e,par} (`ne_parents_from_counts()`, printed as `N_e_par`, ledger `Ne` read as this and said to be of unrecorded set); w_p kept only as the census weight in the partition and distinguished from the usage weights w in S2; `GD_within` = GD_WS. |
| 08-D8 | fixed | Metric set per 07 (N_e,par second constraint, N_s a rescaling in [1/2, 1], not a head count, richness one of several; what the chapter actually uses is listed). N_s defined with the range; `Ns_total` printed value explained. Cost claims: "O(n^2) -> O(L^2) ... microseconds" removed; memory saving unqualified, per-evaluation time cited to @sec-choosing-cost (line route slower at N = 2,500, n = 50); cost table is orders only, "this chapter times none", `theta_decompose` split into O(L^2) with `f` and O(L^2 m) without. |
| 08-D9 | fixed | `@kadoumi2025` as a key, abstract-level reading, "decades" -> forty years of one programme, the details and limits delegated to @sec-hp-cycle (F_ST up while Hamming fell, one group merged others, selection speculative); "exactly the two opposite trends" removed. S1 "erodes under selection" reworded to 00's drift-only statement. Nei 1973 and Caballero & Toro 2002 cited with keys; Falconer "textbook 2.063" removed (see B3). |
| 08-D10 | fixed | "Every formula verified" replaced by the identity rule stated in the chapter (asserted or not claimed) and satisfied by the chunks above. (a)-(c) assumptions: per-locus marginal 1/2, hold with linkage; sigma2_DH assumptions declared (additive, 0/1, free recombination) and checked by gene dropping; `h` defined (accuracy, the r of @eq-response-breeders; 0.6 an illustrative value); S3 "within each pool" labelled an argument, demonstration labelled pooled with the 6 A / 14 B split shown; He computed from frequencies and qualified as the merged-set H_e, not the F1 heterozygosity; crosses chunk described (20 draws, 19 rows kept, 18 distinct unordered pairs, pool A only, n_c = 40 equal). |
| 08-M1 | fixed | Caption restricted to random sets; says optimised sets could cross at a smaller size (not examined); figure chunk seeded, labelled `fig-theta-by-size`, asserted (`th[sizes < 20] > ceiling`); incremental greedy now run, not argued. |
| 08-M2 | fixed (form) | Ledger tables built long, with readable headers, arms named as in the file, dispersion (sd, share range) added; quant-editor to check the Typst widths of the two new tables. |
| 08-M3 | fixed (partly) | S1-S4 listed in one sentence with @tbl-hp-stages instead of a restated table; S4 derivation cited to @sec-collapse with its assumptions; `sel_intensity` shortened to a pointer to @sec-response. |
| 08-M4 | fixed | The "time series" promise is reworded: 11b runs fifteen cycles but logs other columns. |
| 08-M5 | fixed | Typed numbers now inline from chunks: ledger shares, losses, merit cost, CIs, p-values, sel_intensity, n_in/n_out. Typed remaining: design numbers quoted from the external study (marked as such), 20 draws, n = 8. |
| 08-M6 | fixed | `@kadoumi2025` / `[@kadoumi2025]` form. |
| 08-M7 | fixed | Figure chunk labelled; `met` printed with a legend; downloads regenerated. |

## R findings (audit)

| ID | Status | What was done |
|---|---|---|
| 08-R1 | prose fixed, code owed | See D1. |
| 08-R2 | fixed | See D2. |
| 08-R3 | fixed | See D3. |
| 08-R4 | fixed | See D4. |
| 08-R5 | fixed | `UC only` / `UC + div` named as in the csv; table headers are now built by hand. |
| 08-R6 | fixed | See D5. |
| 08-R7 | fixed | See M1. |
| 08-R8 | fixed (scoped) | The within-pool demonstration is not implemented (no pool argument in the function); the text says the demo is pooled, shows 6/14, and gives the within-pool rule as an argument from the partition. A per-pool run is not added (it would depend on the R/05 fix). |
| 08-R9 | fixed | See D10 and "What changed in the code". The `sel_intensity` value 2.0627 is inline and unasserted against a typed constant (the typed "textbook 2.063" is gone). |
| 08-R10 | fixed | See D6, D7, D9. |
| 08-R11 | fixed | See D8. |
| 08-R12 | fixed (prose) | See D8; no timings in the chapter. |
| 08-R13 | fixed | Crosses chunk described; the audit's "18 distinct" is the unordered count (the ordered count is 19). |
| 08-R14 | fixed | See M5. |
| 08-R15 | fixed | Seeds: 88, 89, 90, 91 immediately before each draw; figure `set.seed(5)`; sweep and worlds pass seeds 1..20 to `simulate_pools()`. |
| 08-R16 | fixed (stated, not computed) | Strata design in the caption; the rank consequence for a breeder said not to be computed; `cor_MRD_nseg` column shows the count claim (0.9999 within strata). |
| 08-R17 | fixed | Label added; downloads regenerated; orphan files listed above (render batch). |

## B findings (refs)

| ID | Status | What was done |
|---|---|---|
| 08-B1 | fixed | `@kadoumi2025`, abstract-level, scoped. |
| 08-B2 | fixed | Nei's G_ST: `[@nei1973]`; coancestry form: `@caballero2002`; Wright label: withdrawn (not cited, stated to be the code's label); "routine use" and "published threshold" removed rather than sourced. 05b's Eq.-8 attribution (00) not re-checked here. |
| 08-B3 | fixed (removed) | The typed "textbook 2.063" removed; the intensity is computed, and `@sec-response` (which cites `@falconer1996` for the breeder's equation) is pointed to for the check. No page-level attribution is claimed. |
| 08-B4 | fixed (scoped) | Usefulness criterion: `@lehermeier2017` cited for the criterion with marker-predicted progeny variance; Schnell & Utz (1975) mentioned only as the package documentation's attribution, said to be not in the bibliography and not checked (no bib entry invented). sigma2_DH is now derived under declared assumptions, so it needs no source. |
| 08-B5 | fixed (removed) | "Routine use", "common practice", "where optimisation effort conventionally goes" deleted; no source cited for any. |
| 08-B6 | no action | Numbers now computed from the csv. |
| Comstock 1949 | no action | Not cited in 08 (existence/title only, per instruction). |

## C findings (continuity)

| ID | Status | What was done |
|---|---|---|
| 08-C1 | fixed | See D8 (07's wording). |
| 08-C2 | fixed | See D6. Earlier chapters: 00:579 reworded to say 08 writes F_ST for GD_BS/GD_T and F^btw_ST for the other; 90:270 G_ST row now says "the same quantity as F_ST, not a second one" and names F^btw_ST; 90:154 list no longer includes @sec-stages (08 now writes F_BN). |
| 08-C3 | fixed | See D6; 05:1777 `theta_B` -> `theta_AB` with the package clash named. |
| 08-C4 | fixed | See D6 (F_BN for `fst`; F_ST only for the statistic). |
| 08-C5 | fixed | See D7. |
| 08-C6 | fixed | See D7. |
| 08-C7 | fixed | See D7. |
| 08-C8 | fixed | See D5. |
| 08-C9 | fixed (as far as the file allows) | Stage losses stated to be against each stage's own re-based baseline; the S2 baseline stated unrecorded; share defined as a share of a sum. |
| 08-C10 | fixed | See D4. |
| 08-C11 | fixed | See D10. |
| 08-C12 | prose fixed, code owed | See D1. |
| 08-C13 | fixed | See R8. |
| 08-C14 | fixed | See D8. |
| 08-C15 | fixed | He qualified (merged-set H_e, @sec-hp-popgen, @sec-catalogue). |
| 08-C16 | fixed | See D9. |
| 08-C17 | fixed | See D2; the two conditions of 05b (d = 1; exact only for it) stated; 05b sections cited by label. |
| 08-C18 | fixed | See D5. |
| 08-C19 | fixed | The tested arm is called "a diversity term on parental coancestry at S2", not a constraint; one weight, 8 pools stated; "partly reclaimed" and "carry through all four stages" marked untested. 12:187 (Owed). |
| 08-C20 | fixed | @sec-baseline, @eq-gd-partition, @sec-ns, @sec-response, @eq-response-breeders cited; `h = 0.6` defined; MRD defined by its formula in Trap 1. 02b-C14: @sec-response is now cited from 08 for i and the accuracy form. |
| 08-C21 | fixed | Scales named in the opening and at the ledger. |
| 08-C22 | fixed | Stage list now cites @tbl-hp-stages; S4 section points to it for the chapters that treat S4. |
| 08-C23 | fixed | S4 identity shortened and cited to @sec-collapse; `sel_intensity` check pointed to 02b. |
| 08-C24 | owed (later chapters) | See Owed. |
| 08-C25 | fixed | See M4. |
| 08-C26 | fixed | See D2, D5, M5; "swaps typically under 20" removed. |

## Owed (later chapters and next pass)

- quant-Rwrite: R/05 `select_lines_constrained()` (see top); then rewrite of the sentences listed there and of checklist 5; consider `warning()` and a swap-count attribute; a test on the chapter's world.
- 10:36 "the three-object contract of @sec-stages": 08 holds no such contract (owner @tbl-stage1-contract, 03:56-59; 91:74).
- 08b:43 "the saving @sec-stages calls hybrid mining (S4)": 08 does not discuss a genotyping saving.
- 12:187 cites 08 for "a constraint": 08 tests a diversity term at S2.
- 11:135-143 (already owed): "within both groups declined", "decades".
- 11b:12-13: if 08's "time series" promise is to be kept by 11b, 11b must log the S1 panel columns; 08 now says it does not.
- 05b:1426 and 05b Step 8 cite "@sec-stages Trap 3 ... hold F_ST in a band": consistent with 08 now (the book's F_ST); no edit made.
- 92:57, 92:397, index: F_ST for the parameter F_BN (00-C18), still open.
- 05: the 05:1786-1790 sentence "@sec-stages Trap 2 ... three quantities" still holds; no edit.
- Render batch: docs/ and book/_freeze for 00, 05, 08, 90 are stale; orphaned `unnamed-chunk-15-1` files of 08 in docs/08-pipeline-stages_files and book/_freeze/08-pipeline-stages.
- quant-editor: Typst width of the two new computed tables (@tbl-ledger, 9 columns; @tbl-endpoints, 8 columns); the cached figure files carry titles that the captions now qualify but cannot change (the figures have no producer).
- Not run, and said so in the text: any within-pool S3 constraint; ranking consequence of Trap 4; selection-driven divergence for Trap 3; any variation of crosses or DH per cross; the S2 baseline of the ledger.
- Unverified sources: Kadoumi 2025 beyond the abstract (as in refs); Caballero & Toro Eq. 8 form (as cited by 00, not re-read); Schnell & Utz 1975 (not cited as a key).

---

# quant-Rwrite, iteration 1 (code fix and Trap 5 prose)

Files: R/05_pipeline_metrics.R (`select_lines_constrained()`), man/select_lines_constrained.Rd (document()),
tests/testthat/test-stage-metrics.R, book/08-pipeline-stages.qmd, book/downloads/*.R (make_downloads.R).
`devtools::test()`: FAIL 0, WARN 0, SKIP 0, PASS 513 (was 494 expected minimum). `devtools::install()` done. R/05 ASCII.
No quarto render; chapter knitted with knitr into the scratchpad (rc 0, all stopifnot pass); book/figure scratch removed.

## The fix

Old loop: drop by `contrib - w*mz`, add by `colMeans - w*mz`, each chosen separately, so theta was not monotone (2-cycle) and the
loop left at `max_swap` silently. New loop: every candidate swap (out, in) scored exactly with
`Q' = Q - 2 r_out + f_oo + 2 (c_in - f_in,out) + f_ii`; only swaps with strictly positive theta gain are admissible; among them the
best of `gain/max(gain) + merit_weight * (mz_in - mz_out)`. Theta strictly decreases, so no cycle; stops at the ceiling or at a
single-swap local minimum of theta. If not met: `warning()` and attributes `theta`, `met`, `n_swap` on the returned (sorted) vector.
Cost per swap O(n L); not timed (n = 20, L = 60 here).

Measured: seeds 1..20 of `simulate_pools(30,30,3000,0.15)`, alpha 0.005: truncation violates 10/20 (same as the verdict), repair
meets 20/20 (old: 13/20), unchanged in 10/20 (exactly the non-violating worlds), max 4 swaps, mean merit cost 0.041 sd where it swapped
(max 0.148). Seed 12: theta 0.67226 vs ceiling 0.67464 (truncation 0.67554), 1 swap, mean merit 1.009 vs 1.072. Both new tests fail on the
old code (seed 12: 0.67554 > ceiling; adversarial merit = rowMeans(fL): 0.67876 > ceiling).

Tests added (test-stage-metrics.R): chapter world seed 12 alpha 0.005 (met, no duplicates, attr theta == literal `s3_theta`, swaps > 0);
adversarial merit (mean coancestry; weights 0, 0.25, 5 all meet); unattainable ceiling warns, `met` FALSE, stops < max_swap, no worse than
truncation; one swap with `merit_weight = 0` equals the literal best single swap over all (out, in) pairs (oracle, 1e-12).
Existing random-merit test kept and passes. Other tests unchanged.

## Chapter edits (Trap 5, from measured output only)

- Repair intro rewritten (exact swap score, monotone, warns); `trap5-repair` adds `n_swap`, `stopifnot(met)` and attr-theta check;
  "Result, as the function is shipped" -> "Result", all values inline (theta, swaps, merit vs truncation).
- `trap5-worlds` adds `n_swap`, `merit_cost`, a `stopifnot(repair_equals_top == (n_swap == 0))`; the paragraph ("cannot be presented as the working route",
  "exits after max_swap", "revised separately") replaced by the counts (inline) with "this is what these 20 worlds show; it is not a guarantee",
  and the warning/flag behaviour for an unattainable ceiling. Attainability claim stated only as "the repair reached it in every world above".
- Cost table: "swaps not returned" -> count returned (`n_swap`); "number of swaps unknown" -> warns and flags. Checklist 5 -> test `attr(sel, "met")`.
- R8 (within pool): new chunk `trap5-within-pool` calls the function once per pool (10 per pool, own ceiling): both pools meet (n_swap 1 and 0;
  truncation exceeds in pool A only). S3 text now says the within-pool call is run at the end of Trap 5; no claim that it preserves more
  between-pool structure (stated not measured). Pooled call takes 7 A / 13 B in the new code (was 6 / 14 in the verdict; inline).

## ID -> fixed | contested

| ID | Status | Evidence |
|---|---|---|
| 08-D1 / 08-R1 / 08-C12 | fixed | code, 3 tests (+1 oracle), 20-world chunk: meets 20/20, previously 13/20, silent. |
| 08-R8 / 08-C13 | fixed | per-pool chunk run; limits of what it shows stated. |
| 08-R5 | fixed | writer pass; unchanged. |
| 08-R12 | fixed | cost cells for S3 now match the function (O(n L), count returned); no timings claimed. |
| other R/D/B/C | as in the writer's table | not re-opened; not touched this pass. |
| Owed to later chapters | unchanged | 10:36, 08b:43, 12:187, 11:135-143, 11b:12-13, 92:57/397, render batch (orphans of 08 `unnamed-chunk-15-1`; `trap5-within-pool` and the other new chunks are labelled). |

Left out: no timing of the new loop (not claimed in the chapter); `book/data` untouched; a mention of `select_lines_constrained` in
book/91-package.qmd:235 still reads "truncate-then-repair; the incremental greedy fails" (still true, not edited). Other chapters using
the function: none (grep over R/, inst/, book/).
