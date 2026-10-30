# 04-population-sizing -- response, iteration 1

## quant-writer

| ID | Status | Note |
|---|---|---|
| 04-D1 | fixed | "-2.0%" and "1 cM faithful" removed. P9 now only states the mechanism and points to @sec-sizing-verify, where chunk `verify-junctions` sets `expected_junctions()` against the cached grid's `junc` (weighted by `n_rep`): SSD -3.8%, syn1 -5.1%, syn2 -6.4% inline, ordering asserted. Single-meiosis Haldane deficit (-2.0%) computed inline only as a contrast. Chunk `verify-spacing` (live, neutral SSD, 500 lines, `set.seed(11)`, ~0.5 s) measures 1 cM: -2.3% (s.e. 0.7%) vs -5.2% at 2 cM; text says 1 cM is not unbiased and the spacing that is was not measured. |
| 04-D2 | fixed | Threshold inline `n_f1 <- min(s$n_F1[s$expected_loci_lost < 1])`; values at n_f1 and n_f1 - 1 inline; printed rows include both; "already" removed; Working-numbers F1 row built from `n_f1`. Same edit as 04-R2, 04-B8. |
| 04-D3 | fixed (text); package side to quant-Rwrite | Prose states the both-parents count $2 h_{res} n_{loc}$ and $E = 2h_{res}n_{loc}\cdot 2(1/2)^n$. Chunk `f1-sizing` asserts `f1_sizing()` returns exactly that, so the chapter fails to render until 04-R3 is fixed (verified: errors now; with the both-parents function, n_f1 = 10). |
| 04-D4 | fixed | Working-numbers table computed from the grid: F2 = N90 for D (90), "+300 plants buy +0.0072 of D" (N90 -> 390, both grid points); no N outside 10-390 recommended; multilocus/panel-frequency row now says the target is not reached at N <= 390 for k >= 8 and gives P(390) and SE(p_hat) inline. |
| 04-D5 | fixed | "Saturates" defined: N90 = smallest grid N reaching 90% of the gain from smallest to largest N (grid-relative, stated); recovery uses P >= 0.95 with closed form @eq-sizing-n95 [@sedcole1977], checked against a neutral simulation (k = 5, N = 110: 0.825 vs 0.831, asserted within 0.05). Table states one population per N for recovery; text states non-monotonicity and that sim < closed form at 57/60 points for k >= 5 because all distorters act against P2 (asserted in the `f2_distorters` chunk). Step table now has an SE from `div_sd`/`n_rep`; 14 of 15 steps past N90 within 2 SE of zero, stated. Replication of the multilocus curve itself would need a regeneration (not done; claims restricted instead). |
| 04-D6 | fixed | Heading no longer names a limit; D(390) = 0.9886 with s.d. and n_rep inline, gain 110 -> 390 inline, gap range and slope inline; "no limit computed; grid stops at 390" stated. |
| 04-D7 | fixed | P6 declares P1 as the adapted parent, $\beta$ = `f2_opt$beta_bulk` inline as a model input, and that weights select against P2 by construction. Section heading and prose reframe "worst" as a consequence of that input; bulk-lowest count (20/20) inline; "holds at this $\beta$ only" stated. `s40` -> `s30`. |
| 04-D8 | fixed | Chunk `block-length` computes mean block length = total_cM/(junc + chromosomes) and the junc-on-N slope with s.e. from cached `junc`; SSD 43.2-44.4 cM, slope 0.000 (s.e. 0.07) inline. Ancestry-frequency figure moved to the diversity section, where its content (drift vs distortion) belongs. "Syn curves in the theory table" replaced by a pointer to the `expected_junctions()` output. |
| 04-D9 | fixed | `verify-het`: per-plant SE, asserted within 4 SE. `verify-diversity`: 100 replicates per N, seed per N, z asserted < 4 (max 1.83). Junction prediction compared with simulation (see D1). Live verification total ~1 s. |
| 04-D10 | fixed | "5-10x" removed; Lee 2002 quoted ("nearly a four-fold"), with the recursion's $(2+g/2)L$ and the g = 4 / g = 5 counting ambiguity stated. The same claim in the roxygen of `maize_chr_len` (R/06:26-27) is quant-Rwrite's. |
| 04-D11 | fixed | Map lengths declared a model input (no source claimed; B2); Haldane, Falque, Zhang, Lu, Fisher, Winkler, Sedcole, Lee cited; F ~ 0.95 removed and h_res declared a scenario value (B9); 15% declared a scenario parameter inline from `f2_opt$attrition` (B10); "ga1-like (4.05)" declared a placeholder in the text (label itself is in R/06, to quant-Rwrite). |
| 04-M1 | fixed | GD = D/2 stated with its derivation and asserted (`bridge` chunk). |
| 04-M2 | fixed | `Ns` column added; Ns = 1/(2 - D) asserted; range inline. |
| 04-M3 | fixed | 1670 cM and L in Morgans inline from `maize_chr_len`; "1.75 L" from `expected_junctions()`. |
| 04-M4 | fixed | `set.seed()` per N (`verify-diversity`), per panel (ancestry figure, seeds 6 and 7) and per n_F2 (`bridge`). :132 kept as one seed: F1 -> F4 there is one lineage, a single draw (commented). |
| 04-M5 | fixed | `"SSD"` -> `"ssd"`. `match.arg` in `run_scheme()` is quant-Rwrite's (04-R14). |
| 04-M6 | fixed | `s40` -> `s30`; bridge map renamed `map_br`/`dist_br`. |
| 04-M7 | fixed | $1 - h_{res}$ defined as the proportion of parent-polymorphic loci homozygous in a parent, "not an inbreeding coefficient relative to a base population". |
| 04-M8 | fixed | "share 87.5% of the genome" -> coancestry $(1 + F_{F3})/2$ computed inline, F1 as base. |
| 04-M9 | fixed | `book/scripts/regenerate.R:12` header corrected. |
| 04-B1 | fixed | = 04-D10; `lee2002`, `winkler2003` added (Crossref-verified; Lee abstract read on PubMed). |
| 04-B2 | fixed | Lengths declared a model input approximating a composite map; no map cited (Beavis & Grant total unverified, not used). |
| 04-B3 | fixed | `haldane1919` added, J Genet 8:299-309, no DOI. |
| 04-B4 | fixed | `falque2009` (abstract read: ~15%, 6-23% non-interfering); "strong" and "slightly" removed. |
| 04-B5 | fixed | `lu2002` (abstract read) and `zhang2018` (Crossref; title supports male function) cited; bin numbers declared placeholders in text. Label string in R/06:54 -> quant-Rwrite. |
| 04-B6 | fixed | `fisher1954` cited for junctions, `winkler2003` for intermating expansion. |
| 04-B7 | fixed | `sedcole1977` cited for @eq-sizing-n95. |
| 04-B8 | fixed | = 04-D2. |
| 04-B9 | fixed | Claim removed; h_res a declared scenario value. |
| 04-B10 | fixed | Claim removed; attrition a declared scenario parameter. |

Also done because it was the same edit: 04-R1, R2, R4, R5 (text side), R6, R8, R9, R10, R11, R12, R13, R15, R16; three figures now carry `fig-sizing-*` labels and are cited before they appear (R17 partly; the old `unnamed-chunk-*` PNGs in docs/ and _freeze/ will be orphaned at the next render).

Notes for quant-Rwrite:
- 04-R3: `f1_sizing()` must return `2 * h_res * n_loci_eff * 2 * 0.5^n_F1`; the chapter asserts it. Fix the roxygen too ("F around 0.95 is common" has no source).
- `maize_chr_len` roxygen "5-10x" (R/06:26-27) and the `bulk_weights()` roxygen ("worst scheme ... removes precisely the germplasm") restate claims removed from the chapter; `f2_distorters` label "ga1-like (4.05)" is unsourced (04-B5).
- 04-R14 `match.arg` in `run_scheme()`.

Needs regeneration (not done): replicated multilocus recovery (more than one population per N) would be needed to state crossing points with a dispersion; the chapter now states it rests on one population per N.

## quant-Rwrite

| ID | Status | Note |
|---|---|---|
| 04-R3 / 04-D3 | fixed | `f1_sizing()` now returns `2 * h_res * n_loci_eff * 2 * 0.5^n_F1`. Writer's formula verified from first principles: a parent heterozygous at a locus loses an allele iff all n gametes carry the same one, P = 2(1/2)^n (= 1 at n = 1); each parent segregates at h_res * n_loci_eff loci, so by linearity of expectation over 2 * h_res * n_loci_eff (parent, locus) pairs E = 2 h_res n_loci_eff * 2(1/2)^n (a locus segregating in both parents counts twice, as two independent loss events; roxygen says "(parent, locus) pairs"). New test: closed form at n = 1 (= 2 h_res n_loc), threshold n = 10 at defaults, and a literal Monte Carlo oracle (set.seed(31), 200 reps, |mean - E| < 4 SE). Callers: R/ none besides definition; book/04 (asserts the new form), 91/92 list it by name only; inst/scripts and regenerate.R do not call it. No file in book/data depends on it. |
| 04-D10 (roxygen) | fixed | `maize_chr_len`: "5-10x" -> "close to four-fold in Lee et al. 2002". |
| 04-M7 / 04-B9 (roxygen) | fixed | `f1_sizing`: "F around 0.95 is common" removed; h_res declared a scenario parameter, default illustrative. |
| 04-D7 (roxygen) | fixed | `bulk_weights`: "worst scheme ... removes precisely the germplasm" replaced by the weight formula and "a consequence of these declared weights". |
| 04-B5 (label) | fixed | `f2_distorters$label[1]` "ga1-like (4.05)" -> "distorter chr4 (illustrative)"; roxygen says bins are placeholders. No CSV in book/data, test or script uses the string (only rendered docs/ HTML, refreshed at next render). |
| 04-B4 (header comment) | fixed | R/06 header: "strong positive interference" -> "positive crossover interference (Falque et al. 2009)"; "slightly" dropped. |
| 04-R14 / 04-M5 | fixed | `run_scheme()` validates with `match.arg(scheme, c("ssd","ssd_attr","bulk","syn1","syn2"))`; valid names unchanged (full suite + cached-grid callers untouched); "SSD" now errors (tested). |
| 04-R8..R13 | already fixed by writer | Seeds per draw (:170 single lineage, :196, :272, :373/:375, :489, :657) and stopifnot for H, D, GD = D/2, Ns present; nothing further. |

Verification: devtools::document() (4 Rd), devtools::test() 487 pass / 0 fail, devtools::check() 0 errors | 0 warnings | 1 note (hidden `.git` -- a worktree artefact: `.git` is a file here, which R CMD build only skips as a directory; not present in the main tree), devtools::install() done (installed f1_sizing(10) = 0.977). Chapter purled and sourced from book/ with _common.R: runs clean in 1.0 s, n_f1 = 10. make_downloads.R re-run. Not rendered.

## quant-writer (editor findings)

| ID | Status | Note |
|---|---|---|
| 04-E1 | fixed | `saturation` -> `tbl-sizing-saturation` with `tbl-cap` (kable `caption=` removed); cited in the first paragraph of "The metrics saturate at different N". No other chapter referenced the old label (grep). |
| 04-E2 | fixed | `verify-het`, `verify-diversity`, `verify-junctions`, `verify-spacing`, `block-length`, `bridge` -> `tbl-sizing-verify-het`, `-verify-diversity`, `-verify-junctions`, `-verify-spacing`, `-block-length`, `-bridge`, each `knitr::kable(fmt(...))` with a standalone `tbl-cap` (source, seed, replicates, units) and cited before it appears. The unlabelled `expected_junctions()` rbind is also now `tbl-sizing-expected-junctions`; the prose pointer "the `expected_junctions()` output in @sec-sizing-verify" now cites it. Every stopifnot kept; no computed number changed. |
| 04-E3 | fixed | Bulk-vs-SSD chunk -> `tbl-sizing-bulk-vs-ssd`; steps -> `tbl-sizing-steps`, now all 19 steps (the prose discusses those past N90); `f1-sizing` -> `tbl-sizing-f1`. All captioned and cited. |
| 04-E4 | fixed | SSD grid table goes through `fmt()` per column; header "skewed genome (%)", cells numeric. Identities table: numeric coefficient column `c` through `fmt()`, the expression ("c / sqrt(N)", "1 - c / N", "c L") in its own column. Working-numbers table left as is: it is a decision summary whose cells are text by design; its numbers already come from `fmt()` / inline values. |
| 04-E5 | fixed | Schemes: ssd = `book_pal["ink"]`, ssd_attr = `book_pal["mid"]`, bulk purple, syn1/syn2 greens (no pool colours). Ancestry figure: N = 20 `book_pal["mid"]`, N = 300 `book_pal["ink"]`, boundaries `book_pal["light"]`, distorters `book_pal["loss"]` (no hex). Multilocus: grey ramp plus distinct `pch`. |
| 04-E6 | fixed | Multilocus y-label "P(at least one line P2P2 at all k loci)", x-label `N[F2]~"plants"`. |
| 04-E7 | fixed | 90-notation "Population sizing" table gains $N$, $n$, $p$, $H_t$, $d$, $g$, $z_i$, $w_i$, $\beta$, $N_{90}$, $k$, $P$, $N_{95}(k)$, $h_{res}$, $n_{loc}$ with their functions, plus a scope note stating that $N$, $n$, $L$, $k$, $\beta$, $p$ are local to @sec-sizing and how each differs from its book-wide meaning. No symbol renamed in the chapter. |
| 04-E8 | fixed | New display equation `{#eq-sizing-div}` after the identities table: $D$ defined (markers $j = 1..m$, $p_j$ P1-ancestry frequency, base the panel), $\mathrm{E}[D] = 1 - (1-H)/N$ under no distortion/no selection; cited in `verify-diversity` prose and caption, in the inline z sentence, in fig-sizing-diversity's caption and in 90-notation. Checked by the existing `stopifnot(all(abs(check$z) < 4))` (max z 1.83). |
| 04-E9 | fixed | Caption constants are asserted: setup chunk `stopifnot(f2_opt$seed == 20260828, beta_bulk == 6, attrition == 0.15, 20 grid N, range 10-390, n_rep 40 at N <= 50 and 10 from N = 210)`; multilocus chunk asserts kk = 3, 5, 8, 10; working-numbers chunk asserts h_res = 0.05, n_loc = 5000. A change now breaks the render instead of drifting. |

make_downloads.R run; chapter and 90-notation purled and sourced from book/ with `load_all` (all stopifnot pass). Not rendered. Every relabelled chunk was a table (no PNG orphaned), but their `_freeze` entries change at the next render.
