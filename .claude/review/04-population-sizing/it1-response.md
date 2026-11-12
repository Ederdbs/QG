# 04-population-sizing -- response to iteration 1

Chapter: book/04-population-sizing.qmd (lines are of the revised file). The purled chapter runs end to end against `pkgload::load_all` (~35 s, was ~1 s: the replicated recovery grid is live now), every `stopifnot()` passes, no warnings. Not rendered with Quarto and `_freeze` not refreshed; `make_downloads.R` was run.

## Runs made (all reported, none dropped)
- Recovery replicated: 20 populations x 20 grid N x k in {3,5,8,10}, SSD, 2 cM, distortion active, seeds 20261108 + N. One earlier timing run with identical seeds/settings (same output); design not changed after results. First crossing of 0.95: k=3 N=50 (bracket 30-50), k=5 N=270 (230-290), k=8,10 not reached (mean at 390: 0.293, 0.057).
- Distortion arm, k=5, N=110, 10 cM, 20 populations, set.seed(9): 0.752 (s.e. 0.013) against neutral 0.825 and closed form 0.831. Reviewer seed 81 gave 0.708 (0.011), audit 0.747 (0.014): arm-to-arm seed spread is about 0.04, larger than the within-arm s.e.; the chapter reports its own arm only, and says nothing of the others.
- Neutral twin at 2 cM, 20 populations: N=110 gap 5.3e-4 (s.e. 4.7e-4), N=390 gap 1.2e-4 (1.1e-4), against 1.0e-2 and 9.1e-3 with distortion.
- Spacing deficit, 20 neutral panels of 500 lines per spacing (seeds 1100+i, 1200+i): 2 cM -4.24% (s.e. 0.19), 1 cM -2.18% (0.16); 20 of 20 negative. (Prototype run with seeds 1100+i for both spacings gave 1 cM -2.04%.)
- Bridge: greedy 10-line subset GD 0.479-0.488 against panel GD 0.482-0.494 (did not exceed panel in 3 panels); one subset size, one heuristic.

## ID table
| ID | Status | Where / how |
|---|---|---|
| 04-D1 | fixed | qmd:15-36. Opening says 03 draws lines inbred by fiat and does not model the selfing path (03:165 reason), what is sized is the F4 line panel not the hybrid candidate set; "candidate pool" gone (grep: 0). |
| 04-D2 | fixed | qmd:24-35, 46-52. Declares the A3 exception: selfing route = alternative to DH in S2 (A2); if parents are from different groups the panel is outside A1-A8 / A3; numbers independent because the simulator carries only ancestry. Heading "heterotic groups" removed from SA1 text; "donor" reading at the bulk paragraph kept as conditional. Closes Owed 00-C2. |
| 04-D3 | fixed | callout "N_s on these panels" (~qmd:1090). N_s in [1/2,1] for every set, monotone in D, no head count, pooling would not change it; advice "only once crosses pooled" and "single diploid" deleted; 06 paraphrase corrected. |
| 04-D4 | fixed (re-measured) | Recovery rows now replicate means (20 pops/N) with 2-s.e. brackets, live in the chapter (chunk `ml-replicates`, tbl-sizing-saturation, fig-sizing-multilocus with +-2 s.e., tbl-sizing-working-numbers). Distortion arm added (6.1 s.e. below closed form); "this was not shown beyond the grid" removed; "57 of 60" replaced by 59 of 60 points more than 2 s.e. below, with the non-independence stated. Cached one-population crossing (50, 270) reported once, not used. Limits stated: one distorter configuration, locus sets random on distinct chromosomes. Note: the replicated crossing for k=5 is 270 again (bracket 230-290); the closed form (185) understates it. |
| 04-D5 | fixed | tbl-sizing-bulk-vs-ssd now gives n_rep, s.d., lowest other scheme, margin in s.e. (6.7 to 20.9 over 20/20 N, conservative comparator). Bulk(390) vs SSD(30): 0.0074, s.e. 0.0034, 2.2 s.e., labelled exploratory, comparator chosen after the grid, "not offered as a finding". |
| 04-D6 | fixed (scoped + measured) | "Where this connects" rewritten: scope paragraph (A2, A5, A8 and base departures declared; line-level quantity of one panel, not the later hybrid budget); lead-in no longer claims a ceiling is measured; bound GD <= (1 - fixed)/2 asserted, greedy 10-line subset vs panel GD vs random subsets measured (does not exceed panel in 3 panels; not a ceiling); only the conditional "no selection restores an allele the panel lacks" kept; "sets it once / spend the rest of the book budgeting" removed. index.qmd:116-118 repeats the unmeasured form: Owed. |
| 04-M1 | fixed | GD cited to @eq-hp-gd and @sec-identity; @sec-coancestry only for f. |
| 04-M2 | fixed | H declared as H_o averaged over plants and loci (SA7), not H_T/H_S of 02; recursion symbol H_t -> h_t (qmd:164-167; 90 row edited); F_F3 -> F^(2) = 0.75 per 00 convention with citation; "genetic N_e of the F1 is 1" -> "one genotype". |
| 04-M3 | fixed | after @eq-sizing-div: derivation sketch at p0 = 1/2 (E[D] = 1 - 4 Var(p_hat)), tie to @eq-hp-drift (H=0 case) and @sec-baseline, and what (1-H) adds (n_gam = N/(1-H)); not a Wright N_e. |
| 04-M4 | fixed | closing paragraph: "cheapest insurance" removed; says 08 does not vary plants per cross and no cost is measured. 11c half stays for 11c's review. |
| 04-M5 | fixed | ylim = c(min(f2$div), 1); caption states the axis spans the data; alt text ("0.74 ... 0.74 at 10 plants") guarded by stopifnot. |
| 04-M6 | fixed | heading softened; all five slopes' z reported (-0.2 to 2.0, syn2 largest, at most 1.3% of mean junction count over the grid); conclusion scoped "for this grid". |
| 04-M7 | fixed | spacing chunk replicated (20 panels per spacing); sentence "A finer map reduces" rewritten; z_sp2_grid paragraph replaced by replicated means (neutral 2 cM -4.2% vs grid -3.8%, within 0.5 pp). |
| 04-M8 | fixed | neutral 2 cM twin at N = 110 and 390 (tbl-sizing-twin); the attribution is limited to those two sizes. |
| 04-M9 | fixed / UNVERIFIED | winkler2003 no longer attached to the formula (chapter's own recursion); baseline L vs 2L of Lee et al. four-fold stated (4, 4.5 vs 2, 2.25); which baseline Lee et al. use marked UNVERIFIED. |
| 04-M10 | fixed | "most common failure", "result many programmes get wrong", "commonly quoted" deleted or reworded as the chapter's own statement. |
| 04-M11 | fixed | assumptions renamed SA1-SA9 (parents keep P1, P2). Earlier-chapter diff: 05b "its P9" -> "its SA9" (05b:524). THREAD still says "04's P9" (not edited). |
| 04-M12 | fixed in chapter; R docs owed | enumeration oracle `p_mono()` over parental genotype classes asserted against the closed form for n = 1..20. R/06_f2size.R roxygen ("about half", 0.977 vs the chapter's 0.928 at 9 plants) NOT edited: owed to quant-Rwrite (chapter formula is the reference). |
| 04-M13 | fixed | stopifnot guards beside the chunks for caption literals (400 plants, 100 replicates, 20 panels, 20 populations, N = 20/300, subset 10, alt-text values of fig-sizing-diversity and fig-sizing-multilocus). Values typed in other captions' seeds are unchanged conventions. |
| 04-M14 | fixed | fmt_sci() for slope, gap-slope, twin gaps; F1 table printed with formatC(digits = 3, "g"), so 1.9e-06 no longer prints 0. |
| 04-M15 | fixed | ssd_attr: 70-75% of N lines stated; eq-sizing-div at n_final accounts for 103% of the summed difference to SSD (0.079 against 0.077); per-point noise and absence of residual test stated. |
| 04-M16 | fixed | interference paragraph: expected crossover number fixed; observed junction count and drag not; unmeasured. |
| 04-M17 | fixed (scoped) | not run; callout and statements scoped to this one distorter configuration, and the inference lines name SA5. No sensitivity sweep (UNMEASURED). |
| 04-R1..R3 | fixed (= D1, D2, M1) | |
| 04-R4 | kept true | SA9 text unchanged; 05b address updated. |
| 04-R5..R9, R11..R15, R17..R19 | fixed as the prose/chunk side of M5-M9, M13-M15, M10 | R11 only for captions tied to chunks edited here; R12 neutral twin; R19 "selfed F1 plants" -> "F1 plants" (also 90 row). |
| 04-R6 | fixed | = D4. |
| 04-R10 | partly: chapter side done; R/06_f2size.R docs owed | |
| 04-R16 | fixed | `n90_bracket()` returns NA instead of -Inf and the chunk asserts finite brackets. |
| 04-B2 | fixed / UNVERIFIED | = M9. |
| 04-B10 | fixed | = M10. |
| 04-B1, B3-B9, B11, B12 | no change | per verdict. |
| 04-C1 | fixed | = D1. |
| 04-C2 | fixed | = D2. |
| 04-C3 | fixed | = D3. |
| 04-C4 | fixed | = M1. |
| 04-C5 | fixed | = D6 scope paragraph. |
| 04-C6 | fixed in 04 and 03 | 03:165 now points to @sec-sizing (one clause). 04 claim: see D6. |
| 04-C7 | fixed in 04 and 90 | 90 rows "$H_t$" -> "$h_t$", "$H$" and "selfed F1 plants" reworded. |
| 04-C8 | fixed | = M11. |
| 04-C9 | fixed | = M3 (cross-reference to @eq-hp-drift and @sec-baseline only; 05b/03 not cited). |
| 04-C10 | first half fixed | = M4; 11c half owed to 11c. |

## Diffs in other files
- 03-simulating-crosses.qmd:165: appended "; @sec-sizing models the selfing path, F1 to F4, for one cross" after the @sec-hp-cycle pointer.
- 05b-heterosis-dominance.qmd:524: "its P9" -> "its SA9".
- 90-notation.qmd (Population sizing table): `$H_t$` -> `$h_t$`; meaning of `$H$` = observed heterozygosity H_o of @sec-hp-popgen averaged over plants and loci; `$h_t$` "not the H_t of @eq-hp-drift"; `$n$` "F1 plants".

## Owed (not fixed here)
- `index.qmd:116-118`: "a panel cannot be selected back up to variation it never sampled (@sec-sizing)" is true only of alleles the panel lacks (what 04 now says); restate or keep with that scope.
- `04d-breeding-programme.qmd:376-379`: "same arithmetic @sec-sizing explains for a biparental cross" -- 04 now explains N_s in [1/2, 1] for every set and as a monotone function of D, not the diagonal-dominance argument; align 04d.
- `R/06_f2size.R` roxygen of `f1_sizing()` ("about half", 0.977 vs 0.928) and `regenerate.R` (optionally cache the replicated recovery grid; the chapter computes it live, so it is reproducible from the repo without it). Pure code, for quant-Rwrite.
- THREAD.md: "04's P9" -> "04's SA9" in the 05b entry.
- Quarto render + `_freeze` + `docs/` refresh (live chapter cost now ~35 s on re-execution).
- 08 and 11c: first-half/second-half C10 claims (08 does not cite @sec-sizing; 11c's "same argument") belong to their reviews.

## quant-Rwrite
Code side only; chapter prose untouched. `devtools::document()` run (man/f1_sizing.Rd regenerated), `devtools::test(filter = "f2size")` 0 fail / 20 pass, `devtools::install(quick = TRUE)` done. R/ ASCII (grep clean). No Quarto render.

| ID | Status | Where / evidence |
|---|---|---|
| 04-R10 (R/ half) | fixed | R/06_f2size.R roxygen of `f1_sizing()` (lines ~590-606): "about half of alleles lost" removed; states the chapter's formula `n_loci_eff * (2 h (1-h) (1/2)^n + h^2 2 (1/4)^n)`, its derivation, and that it is not half of alleles lost. Numbers recomputed: 0.9278 (formula) vs 0.9766 (half approximation) at n = 9, h = 0.05, 5000 loci, as quoted in the roxygen. The chapter holds the enumeration oracle `p_mono()` (qmd:967-975); `f1_sizing()` itself is unchanged (returns alleles lost), existing test of it passes. |
| 04-R5 | already closed | quant-writer: `ylim = c(min(f2$div), 1)`, caption and stopifnot-guarded alt text; checked in the response, not reopened. |
| 04-R1..R4, R6..R9, R11..R19 | already closed by quant-writer | no R/ or code side left. |
| `regenerate.R` caching of the replicated recovery grid | contested (not done) | the chapter computes it live (~35 s), reproducible from the repo; a cached copy would add a second source of truth for no gain. |
