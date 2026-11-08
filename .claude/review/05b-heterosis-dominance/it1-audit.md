# 05b-heterosis-dominance -- audit, iteration 1

Scope: `book/05b-heterosis-dominance.qmd` (1821 lines), `R/13_dominance.R`, THREAD entries 00, 01, 02, 02b.
Method: the chapter was knit end to end (`knitr::knit`, installed `hybdiv` == worktree `R/`, exported function bodies identical by `deparse`) and every printed value and inline `r` value was compared with the prose. The freeze was compared with the fresh run: `html.json` and `typ.json` hash == md5 of the current `.qmd`, and all 187 decimals with >= 2 digits are identical between the freeze and the fresh knit. Stochastic claims were rerun over seeds outside the chapter (scripts in the scratchpad, not in the repo).

Counts: H 1, M 7, L 6, Info 5.

## What was verified (and passed)

- Every `@sec-`, `@eq-`, `@tbl-`, `@fig-` reference in the chapter resolves to a label somewhere in `book/*.qmd`; all 12 citation keys exist in `references.bib`.
- The chapter reads no `book/data` or `book/figs` file at all, and never `report/`, `data/` or `reference/`. Nothing in `regenerate.R` is needed (no cached external data).
- Exports used exist with matching arguments: `heterosis_value`, `heterosis_expected`, `heterosis_partition`, `inbreeding_depression`, `heterosis_gca_sca`, `ref_heterosis`, `ref_inbreeding_depression`, `pool_freqs`, `pool_complementarity`, `gd_partition`, `theta_pools`, `line_weights`, `max_line_use`, `mrd_matrix`, `molecular_coancestry`, `sel_truncation`, `simulate_lines`, `simulate_data`. `ctx$m`, `ctx$N`, `ctx$X`, `ctx$ped` are exact names of `ctx` (no partial matching); `ctx[["fL"]]` used where it matters.
- Seeding: every random draw is preceded by `set.seed()` (4, 9, 55+1000k+i, 101/102, 200+r, 500+r); `simulate_lines()` seeds itself from `cfg$seed`; no MaCS/AlphaSimR in the chapter. Caption seeds match the code.
- Algebra re-derived and numerically confirmed: eq-het-split; the Falconer ch.14 reconciliation (F1 total minus random-mating mid-parent == sum d y^2 == 2 x divergence; shared = mid-parent + sum d y^2 / 2: 289.78 + 32.945 = 322.72); eq-het-theta-ab from the definitions in `R/01_metrics.R:147-160`; eq-het-bn-halves; eq-het-var-bn; the GCA turnover eq-het-gca-peak and its weighted-mean maximum; the sampling offset `Ep (1-F)/(2n)`; eq-het-rho-k derivation. The F_eff correction of the GCA peak is correct in expectation: 60 pool seeds on a 0.025 grid give a quadratic-fit peak 0.358 against the stated 0.357 (se of the mean curve ~0.27 on a plateau of ~80).
- Neutral-divergence claim over 20 pool seeds (d seed 4): ratio (shared lost)/(divergence gained) 1.0 [0.9, 1.1]; per-seed range of the total never above 0.005.
- `docs/05b-heterosis-dominance_files/figure-html/*.png` agree with the knitted figures (sweep, relocation, alignment looked at).
- Package-side checks the prose cites: `test-dominance.R` uses 12 + 12 lines, 800 markers, `idx` = 40 random hybrids (setup.R), tolerance 1e-12 on the factorial and 5e-3 on the subset -- as the chapter says. Gap measured on that subset: -7.5e-4 on a value 0.373 (relative 2.0e-3).
- Mackay & Cockram et al. (PDF in `reference/`): "Heterosis and inbreeding depression are, to a considerable extent, opposite sides of the same coin" -- supports `05b:348-350`.
- 05b -> 01 promises: `@eq-het-value` and `@sec-heterosis-flat` (05b:467) still say what 01:46 and 01:377-378 claim. 05b -> 02 keystone: the identity is stated for d == 1, inbred parents, complete factorial; the sweep shows shared falling by as much as divergence rises. 05b -> 02b: the GCA-at-opposite-pool-frequencies statement matches 02b:518-626.

## Findings

### 05b-R1 -- H -- Step 7 treats a one-sigma band as a tolerance; the recycled-pool contrast is not there
`05b:1645-1696` (table), `1674-1681` (Result), `1683-1690` (interpretation), `1626-1635`.
The chapter counts components outside the "sqrt(2/n) = 28 %" band: 5 of 15 for the recycled pairs (reproduced exactly: -57.5, 40.3, ...), against "within 12.3 %" for the independent lines, and concludes that the GCA components are "the ones exposed" to linkage disequilibrium and that the tolerance does not transfer. sqrt(2/n) is one relative s.d., so about a third of independent draws fall outside it by construction, and the control is a single draw (12.3 %, 10.2 %).
Measured, 60 seeds each (recycle(U,6), recycle(V,6), as in the chapter, seeds 7001-7060; independent = 25 fresh Bernoulli lines per pool at the pool frequencies, seeds 8001-8060):

| column | s.d. of deviation, recycled | s.d., independent | F-test p | share outside 28 %, recycled | independent |
|---|---|---|---|---|---|
| GCA_A | 28.9 % | 29.4 % | 0.90 | 0.40 | 0.30 |
| GCA_B | 30.0 % | 28.3 % | 0.66 | 0.42 | 0.33 |
| SCA | 10.6 % | 5.8 % | 1e-5 | 0.03 | 0.00 |

The GCA dispersion under recycling equals the independent one (and equals sqrt(2/24) = 28.9 %); what founder-sampling LD changes is the SCA column, by a factor ~1.8 in s.d., the opposite of "the two GCA columns carry almost all of it; SCA stays within 10.5 %". "The size of the failure can be measured" is not delivered. The conclusion that no threshold transfers to a recycled pool can stand as an argument from A3, but the table does not measure it. Fix: replace the band count by the dispersion of the deviation against an independent-lines distribution over many seeds (same cost, ~1 s per draw), and say that SCA, not GCA, is what moves.

### 05b-R2 -- M -- the prose says a chunk asserts the reconstruction and the `lm()` equivalence; both chunks only print
`05b:1611-1614` ("the chunk in @sec-heterosis-gca-sca asserts that together with the `lm()` interaction equivalence"); chunks at `805-814` and `821-823` have no `stopifnot()`. Same pattern (identity stated, value only printed, rounded): `164-166` (oracle, prints `[1] 0`), `200-202`, `223-233` (table rounded to 12 digits, prose "exactly"; the tolerance claimed at 1358-1359 "twelve digits" is never enforced), `289-293` (eq-het-theta-ab), `313-316` (eq-het-wi-hyb), `352-357` (ID identity), `432-438` (eq-het-distance: "both residuals at machine precision"). The package tests assert them, the book does not; a chapter regenerated against a changed `R/13_dominance.R` would print a wrong number silently. Measured residuals for the tolerances: 1.1e-13, 1e-16, 4.4e-16, 7.96e-13, 6.97e-12, 1.1e-13, 2.3e-13 on values of order 3e2, so `all.equal` (1.5e-8 relative) or 1e-9 relative is declarable from theory. Add `stopifnot(isTRUE(all.equal(...)))` to each.

### 05b-R3 -- M -- Step 6: "the closed form is not exact at small k" is inferred from two 20-replicate residuals; a converged run says k = 1 is exact
`05b:1560-1577`; `1563-1571` ("larger than the noise (-2.1 and 3.2 standard errors)"), `1552`.
Rerun with 4000 tester sets per k on the same Htab: k = 1 mean cor 0.5516 (se 0.0020) against rho_k 0.5516; k = 2 0.6913 vs 0.6907; k = 3 0.7713 (se 0.0011) vs 0.7672 (a real but small bias, 0.004); k = 5 0.8534 vs 0.8509; k = 10 0.9372 vs 0.9354. The chapter's 20-set means (0.4931 at k = 1, 0.7996 at k = 3) sit -2.1 and +1.9 s.e. (against the converged mean) from the truth: ordinary noise across six comparisons. The 20-set s.d. at k = 3 (0.045) also underestimates the true 0.067. The jensen/covariance explanation is plausible for k = 3 (size 0.4 percentage points) but is offered for k = 1 where there is nothing to explain. The "threshold" conclusion (first k above 0.85 is 5) holds on the converged means too. Fix: raise `reps` (cost ~0.1 s per rep) or drop the "not exact" sentence and report the converged bias at k = 3.

### 05b-R4 -- M -- "the GCA peak is interior" and its `stopifnot` hold for half of the seeds
`05b:1054-1055` (assertion), `1081-1087` (prose), `995-996`.
`which.max(rl$var_GCA)` over 20 pool seeds (d seed 4, same grid): peak at fst 0.20 in 1 seed, 0.30 in 10, 0.45 in 9. `F_peak_axis` (0.357) lies strictly between the neighbours of the peak in 10 of 20. When the peak is the last grid point `rl$fst[i_pk + 1]` is `NA` and the build stops; when it is the first, `rl$fst[0]` is `logical(0)` and `stopifnot` passes vacuously. The chapter hedges the single draw ("cannot resolve it further"), but the assertion makes the render depend on seed 5 and the grid (0.30 and 0.45 straddle a plateau 79.5-80.2 wide in the mean curve). The sound statement is the expectation-level one, which the rerun confirms (0.358). Fix: assert `F_peak_axis` against a finer grid or against `rl` only where `i_pk` is interior, and drop "interior" from the prose or say it is a property of this draw. Same draw-level numbers: SCA fall 70 % (20 seeds 68.1 [65.5, 70.0]), GCA gain 30 % (36.0 [26.8, 44.1]), recovery 28 % (32.5 [25.7, 37.8]), total decline 30 % (28.4 [25.8, 30.6]); the chapter already flags them as one realisation and they are inside the range.

### 05b-R5 -- M -- Comstock et al. (1949): unread primary, described as "built on the decomposition", while its title says it uses both components
`05b:825-827`, `855-866` (owed from 00, "read it or rewrite as a report").
`references.bib:447` gives the title "A breeding procedure designed to make maximum use of both general and specific combining ability". The chapter's argument -- averaging over testers removes s_ij, so only g^A survives as a contrast between candidates within a cycle -- is correct algebra (I checked it) but is presented as "the exact sense in which @comstock1949's scheme is built on the decomposition" and as a statement of what the scheme selects on, without saying that the source states the opposite aim and without the point that makes both true: over cycles the tester pool moves, so the GCA against it changes. No text of the paper is available in the repo or `reference/` (`it3-verdict` of 00 records it unread). Fix: rewrite as the book's own algebra about a tester-based scheme, cite Comstock only for "the procedure the title names", and add the cross-cycle caveat.

### 05b-R6 -- M -- "dominance deviation" names both d_k and Fisher's statistical deviation (owed from 01-M13)
`05b:114`, `121` (Fisher's, the section whose purpose is to keep the two apart) against `141`, `235`, `670`, `684`, `1181`, `1766` (d_k, or ambiguous: `1181` "the dominance deviation does not [collapse]"), `R/13_dominance.R:18,26,49,125,166`, `01:44`, `90:210,515`. The section defines d_k as "functional dominance" and never names it "dominance deviation" at the definition, so the name that 01 and 90 copied is never introduced here. Fix: define d_k as the "dominance effect (heterozygote value on the a, d, -a scale)" at 05b:110, use that name in the chapter, in `90`, `01:44` and the roxygen, and keep "dominance deviation" for Fisher's. This closes the 01 owed item. Falconer & Mackay ch. 7 and ch. 14 locators UNVERIFIED (book not available).

### 05b-R7 -- M -- the S1 "monitor" and "S2 (defined there)" (owed from introduction-C4)
`05b:44` "`pool_complementarity()` is the S1 monitor that @sec-stages will define": the monitor is `s1_monitor()` (`R/05_pipeline_metrics.R:158`); `pool_complementarity()` is one of its three column groups. `05b:1171` "@sec-stages S2 (defined there)": S1-S4 are defined in 00 (@tbl-hp-stages, 00:181); 08 only builds on them. Fix both to point to @tbl-hp-stages and name `s1_monitor()`.

### 05b-R8 -- M -- F_BN written F_ST (owed from 00-C18)
46 lines of the chapter contain `F_{ST}`; `F_{BN}` appears on 8. The local declaration at `479-488` is clear, but the equations eq-het-bn-halves, eq-het-var-bn, eq-het-gca-peak, eq-het-sca-gca-ratio (`529-544`, `590`, `605-606`, `959-984`, `1030-1032`, `1100`) and the callout (`1147-1163`) use `F_{ST}` for the Balding-Nichols parameter, while `02` has `F_ST = GD_BS/GD_T` (which here is ~F_BN/(2 - F_BN), the chapter's own statement at 485-486) and `696-698`, `1473`, `1698-1712` use `F_ST` for that statistic. The same symbol means two things in the same section (eq-het-var-bn then `1698` "F_ST cannot inform it"). Rename the parameter to `F_{BN}` in the equations and in the prose that quantifies it.

### 05b-R9 -- L -- "candidate pool" for the hybrid set (owed from 00-M14, 00-C13)
`05b:195` ("The candidate pool here *is* the full factorial") and `05b:1750` ("what the candidate pool and the budget on alpha allow"). 00 uses "candidate set" / "candidate hybrids, not a heterotic pool" (00:271-313).

### 05b-R10 -- L -- "no marker is fixed for opposite alleles anywhere below fst = 0.20" is not established by the grid
`05b:507-509`: the sweep has no point between 0.10 and 0.20; the table shows exactly zero up to 0.10 (the `stopifnot` at 510 tests that) and 0.002 at 0.20. Step 5 (`1470-1472`, "the first non-zero entry is at fst = 0.2") has the same grid dependence; say "first non-zero grid point". (Note also `frac_opposite_fixed` is a near-fixed count at thr = 0.9; 757 says so.)

### 05b-R11 -- L -- test-bound sentence has typed numbers and an unprinted measurement
`05b:323-334`: `5e-3`, `2e-3`, `1e-12` are typed (checked true against `test-dominance.R`); "the gap the test actually sees is smaller again" is unprinted (measured -7.5e-4, relative 2.0e-3 of 0.373 -- passes at 5e-3 with a factor 2.5 margin). Compute the gap in a chunk on the setup configuration or drop the clause. `05-genomic-era.qmd` is cited for the four-subset gap: that chapter's `balanced` row is identical to `truncation` (05:286-288), so "four 60-hybrid subsets ... three heuristic selections" is three distinct sets; 05b:330-334 could say so.

### 05b-R12 -- L -- the oracle comparison uses only one pool-B parent
`05b:164-165`: `ctx$X[1:25, ]` and `head(ctx$ped, 25)` are the 25 crosses of B line 26 with A lines 1-25 (`ped$b == 26` for rows 1-25), so the oracle never exercises the pool-B indexing. The same restriction is in `test-dominance.R:12`. Sample 25 random hybrids with `set.seed()`, and assert. Also `ref_heterosis()` takes the 0/2 matrix `L` (`R/09_reference.R:179`) while the chapter's own rule at `1188-1191` is "line-level functions take 0/1"; add a one-line comment.

### 05b-R13 -- L -- tautological premise checks
`05b:379`, `1214-1216`, `1219-1220`: `heterosis_value(rbind(U, V), d) == 0` with `U, V` coded 0/1 holds for any 0/1 matrix (no entry equals 0.5), and `max(rowMeans(L/2 == 0.5))` is 0 by construction of `simulate_lines()`. They illustrate the Step 1 check, but "Zero, exactly" is not evidence about a pool that was inbred. Say that the check is vacuous on simulated lines and meaningful only on real data (where the genotype matrix can carry 0.5).

### 05b-R14 -- L -- loose phrase and one claim wider than its evidence
`05b:1153-1156` "even the predictable half shrinks": the GCA share is 0.74 at fst 0.45, not half. `05b:411-413` "under drift the shared term lost and the divergence term gained cancel exactly, so hybrid heterosis is invariant" is shown only for d == 1 (the sweep and its table); with the chapter's gamma d one draw gives totals 355.8, 352.7, 344.0 at fst 0.02, 0.10, 0.45 (-3.3 % over the sweep). The expectation argument (eq-het-bn-total with d_k weights) covers it, so say "in expectation, for any d independent of the draw".

### 05b-R15 -- Info -- tracked duplicates under `docs/`
`git ls-files` lists `docs/05b-heterosis-dominance_files/figure-html/fig-heterosis-relocation-1 2.png` and `fig-heterosis-sweep-1 2.png` (and 04-04e duplicates elsewhere). `git ls-files | grep -E ' [0-9]+(\.[A-Za-z0-9]+)?$'` is non-empty, against `CLAUDE.md`. Book-wide item (00-E, 38 duplicates); `git rm` at the batch render. No unnamed-chunk figures exist in this chapter (all figure chunks are labelled), so no orphans from a relabelling; if chunks are added the three named figures are immune.

### 05b-R16 -- Info -- package-side wording that contradicts the chapter (R/ read-only here)
`R/05_pipeline_metrics.R:117-119`: roxygen of `pool_complementarity()` calls the fraction of opposite-fixed markers "the quantity that actually generates heterosis" and says it "does not keep rising"; the chapter measures it to be exactly zero up to fst 0.10 while the divergence term has risen 2.3-fold, and prefers `mean_sq_delta_p`. `R/13_dominance.R:63-66`: "Averaged over loci those two terms are `GD_T` and `GD_BS`" omits the `d == 1` condition (true as the chapter states it). Defer to quant-Rwrite.

### 05b-R17 -- Info -- stratified permutation depends on the discrete frequencies
`05b:717-727`: `round(hz, 9)` yields 26 groups (30-94 loci each) only because pool frequencies from 25 lines are multiples of 1/25. With continuous frequencies each group would be a singleton and the construction would return the original d unchanged. Report the number of groups in the text.

### 05b-R18 -- Info -- constants duplicated from the generator
`05b:530`, `552`: `0.9^2/12 + 0.25` encodes `runif(0.05, 0.95)` of `simulate_lines()` (`R/00_data.R:40`). A change of the generator would silently invalidate the BN prediction. A `stopifnot` against `range(ctx$p0)` would catch it; low priority.

### 05b-R19 -- Info -- UNVERIFIED
No source text available for: Falconer & Mackay (1996) ch. 7 and ch. 14 (and the formulae attributed, which I re-derived: M = a(p-q) + 2pqd, H = d y^2, ID = 2Fdpq), Fisher (1918), Sprague & Tatum (1942), Griffing (1956), Reif et al. (2007, "prove" that sigma2_D/sigma2_A falls with divergence), Labroo et al. (2021), Technow et al. (2014), White et al. (2020), Balding & Nichols (1995), Comstock et al. (1949) (R5). Bib entries for falconer1996 (4th ed., Longman) and fisher1918 look right; `mackay2020` key carries year 2021 (rendered "Mackay et al. 2021"; PDF header says 2020 online).

## Not findings (checked and clean)

Inline scientific-notation: no inline `r` value prints in scientific form (`fmt_sci()` unnecessary here; `1e-12`, `5e-3`, `2e-3` are code spans). Hand-typed numbers in prose: none besides R11 and the design values 0.85, 20, 5, 6, 25 (each tied to code). `@sec-heterosis-step2/-step3` and three equation labels (`eq-het-bn-total`, `eq-het-sca-dc`, `eq-het-sca-gca-ratio`) are defined but never cited. Typst/PDF rendering of the chapter: UNVERIFIED (not rendered; freeze `typ.json` is current).
