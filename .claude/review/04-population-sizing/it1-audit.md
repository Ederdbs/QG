# Audit: book/04-population-sizing.qmd (iteration 1, chapter audit mode, read-only)

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-04-06 (branch review-04-06). Lines are of `book/04-population-sizing.qmd` as it stands (868 lines, md5 db56562b..., equal to the freeze hash, so `book/_freeze/04-population-sizing/execute-results/html.json` is current).

Counts: H 0, M 4, L 10, Info 5. No edits to book/ or R/ were made.

## Method and what ran

- Purled the chapter and ran it against `pkgload::load_all()` of the worktree (the installed package was bypassed): 1.1 s, no error, every `stopifnot()` passed. All inline values below were printed from that run.
- Re-ran the producer of the cached data: `f2_run_experiment(f2_opt)` (the `regenerate.R f2size` target) took 43 s. `all.equal(E$res, f2_results.csv)` and `all.equal(E$ml, f2_multilocus.csv)` are both TRUE; max |div diff| = 5.6e-16. Criterion 9 is met: both files have a producer and it is bit-reproducible at the stated seed 20260828.
- Criteria: (1) every number in the prose is inline `r ...` or a `book/data` read; no hand-typed result found except those listed in 04-R10/04-R11. (2) every draw is preceded by `set.seed()` (lines 191, 219, 301, 440, 442, 583, 818; the cached grid seeds inside `f2_run_experiment`); no AlphaSimR/MaCS here. (4) the chapter reads only `book_data("f2_results.csv")` and `book_data("f2_multilocus.csv")` (both tracked); no `report/`, `data/`, `reference/`. (5) every function called exists in `R/06_f2size.R`/`R/00_data.R` (`build_map`, `make_distortion`, `make_F1`, `cross_indices`, `run_scheme`, `panel_freq`, `diversity_retained`, `junctions_per_hap`, `expected_junctions`, `multilocus_recovery`, `f1_sizing`, `skew_fraction`, `molecular_coancestry`, `marker_index`). (6) all three figure chunks carry labels (`fig-sizing-diversity`, `fig-sizing-ancestry`, `fig-sizing-multilocus`); `docs/04-population-sizing_files/figure-html` and `book/_freeze/04-population-sizing/figure-html` hold exactly these three PNGs, no orphans. The unlabelled chunks (setup, map summary, `f2_distorters` print, and the computation-only chunks) draw no figure, so they orphan nothing.
- `R/06_f2size.R` and the rest of `R/` are pure ASCII (grep for non-ASCII returns nothing). The chapter has no non-ASCII either. `ctx[["f"]]` is not relevant: the chapter builds no `ctx`. No `ctx$f`.
- `fmt_sci()` is used by 00, 02, 02b, 03, 05b and is not used in 04; see 04-R9.

Independent checks (computed outside the chapter's own chunks):

| Claim | Check | Result |
|---|---|---|
| @tbl-sizing-f4-identities rows and @eq-sizing-div | algebra: Var(x) = 2(0.4375)(0.25) = (1-H)/4; E[D] = 1 - 4Var(p_hat) = 1 - (1-H)/N; A_4 = L + 0.5L + 0.25L = 1.75L | `expected_junctions("ssd")` = 29.225 = 1.75 x 16.7 |
| @tbl-sizing-verify-het/-diversity, tolerance 4 s.e. | 20 fresh seeds (101-120) of the F2/F3/F4 het check (400 plants) and of D at N = 50 (100 replicates) | max abs z: 2.13, 2.47, 2.57 (het F2-F4), 1.77 (D). Margin to 4 holds on every seed |
| closed form @eq-sizing-n95 vs neutral simulation (k = 5, N = 110, 10 cM) | 20 seeds x 20 populations | max abs z 2.23, mean z 0.30. Holds across seeds |
| 04:718-720 expected loci made monomorphic | Monte Carlo, 4e5 loci, h = 0.05, n = 3, parents' alleles random | 0.01226 (s.e. 1.7e-4) vs formula 0.01195: 1.8 s.e. Compatible |
| (1+F_F3)/2 = 0.875 coancestry of plants of one F3 line | derivation: two offspring of a selfed parent, IBD = 1/2 + F/2 | agrees |
| Syn cycle adds 0.5L (04:249) | recursion | (37.575 - 29.225)/16.7 = 0.5 |
| SE(p_hat) falls as N^(-1/2) (04:783) | se_p ratio N = 10 vs 390 | 6.59 vs sqrt(39) = 6.24 |
| Heading 04:366: D below the distortion-free curve "at every N tested" | min gap over the grid, all five schemes | positive for all: ssd 0.0087, ssd_attr 0.0094, bulk 0.042, syn1 0.012, syn2 0.017 |
| @tbl-sizing-bulk-vs-ssd | bulk lowest at N | 20 of 20 grid values |

## Owed items from THREAD.md (grep `-> \`04\``)

04-R1 (M) `04:15`, "The previous chapters took the candidate pool as given. This one asks where it comes from". Owed from 00 (00-M14), 05b, and 03-C9. Still unchanged. 03 builds the candidate set (the complete A x B factorial, 03:43-46, 03:376-384), so "took ... as given" and "where it comes from" are false of the previous chapter, and "pool" means a heterotic group in 00/03/05b (the settled name of the hybrid set is "candidate set"). Suggested fix: "The previous chapters worked on the candidate set of hybrids, formed from given parent lines. This one is about the lines: ..." (or drop the first sentence). Note 04 does not say where the hybrid set comes from either; it sizes the F1-F4 population that yields lines.

04-R2 (M) `04:28` (also `04:16`), "a wide biparental cross between two divergent heterotic groups". Owed from 00-C2: against A3 (00:26-27, 00:199-205: germplasm is recycled only within its own pool; a line derived from an A x B hybrid carries both pools' alleles and erodes divergence). The chapter's wide cross is between heterotic groups by its own words, which is the operation A3 excludes from the recycling loop; the chapter never says so, and the later text treats P2 as a "donor" (04:487), which is an introgression case, not an A3 case. Suggested fix: say explicitly that this cross is the exception to A3 (a pool-crossing donor cross used to create a base population or introduce a donor), or reword to "two divergent parents" and say which of the cases (within-pool, between-pool) the numbers address. The numbers do not depend on it: the simulator is ancestry-only (P1) and the parents are arbitrary inbred lines.

04-R3 (L) `04:808-809`, "gene diversity $GD = 1 - \theta$ (@sec-coancestry)". Owed from 01-C8: 01 does not define $GD$ (it names $GD_S$ in its opening, 01:11). Both candidates exist: `{#eq-hp-gd}` (00:395, $GD_S = 1 - \theta_S$) and `{#sec-identity}` (06:80, "$\theta$ and $H_e$ are the same quantity"). Suggested fix: cite @eq-hp-gd for the definition and @sec-coancestry only for the kernel $f$ and $\theta$ (it does define those). The bridge chunk's $\theta$ is the mean over all pairs of lines, self included, which is what 01 defines, so the identity at 04:830-836 is right as written.

04-R4 (Info, keep) `04:164-165` (P9) lists "phenotypic inbreeding depression" among what is not modelled and "cannot be answered here"; 05b:522-523 rests on it. Still true: no chunk models depression. Any edit that shifts these lines or models depression must update 05b:505-542.

## Findings

04-R5 (M) `04:371-390`, `04:373-374`. `fig-sizing-diversity` uses `ylim = c(0.88, 1.0)`, which clips data. Observed D: bulk 0.738 at N = 10 and 0.886 at N = 30 (range of the bulk series 0.738-0.955), syn2 min 0.847, ssd_attr min 0.8746, syn1 min 0.8786. The alt text says "from about 0.9 to 1" and "the bulk line is lowest": at the smallest N the lowest line is off the plot and the caption does not say the axis is truncated. Fix: `ylim = range(f2$div, curve(...))` or state the clipping in the caption and alt text; derive the alt-text range from the data.

04-R6 (M) `04:626-629`, `04:619-620`. "distortion against P2 ... lowers the per-locus probability of a P2P2 line, so the closed-form N95 is expected to understate ... this was not shown beyond the grid." The claim is cheap to test and holds. I ran k = 5, N = 110, 10 cM map, 20 populations each: distortion active 0.747 (s.e. 0.014); neutral 0.8245 (s.e. 0.008, the chapter's own `P_neutral`); closed form 0.831. Add a distortion-on arm to the chunk at 04:583-589 (same seed discipline) and report it, replacing "was not shown". This also explains the 57 of 60 grid points below the closed form (04:620) better than the one-population grid can.

04-R7 (L) `04:329-340` and `04:313-319`. The chapter says the 2 cM live panel (-5.15%) and the grid (-3.78%) "do not coincide" by 1.8 s.e. and that the data "do not separate" sampling from distortion. Cheap replication separates them. I reran the spacing chunk over 20 seeds (1001-1020, neutral SSD, 500 lines each): 2 cM mean -3.88% (sd 0.88), 1 cM mean -1.98% (sd 0.89); 1 cM deficit < 0 in 19 of 20 seeds; 1 cM less negative than 2 cM in 19 of 20. So (a) seed 11's -5.15% is a 1.4 sd draw, and the neutral 2 cM mean (-3.88) matches the distortion-active grid (-3.78): no sign of a distortion effect on the count; (b) "does not remove it at 1 cM" holds on 19 of 20 seeds, not all. Fix: replicate the panel (about 20) and report mean and s.e. per spacing; delete the `z_sp2_grid` paragraph or restate it from the replicated means. Cost: about a minute at 20 x 2 x 500 lines.

04-R8 (L) `04:490`, `04:526`, `04:495-524`. Heading and conclusion "Block length does not depend on N ... in the grid", prose cites only the SSD slope. The table has five slopes (junctions per 100 plants, s.e.): ssd -0.002 (0.069), ssd_attr -0.010 (0.058), bulk 0.078 (0.071), syn1 0.053 (0.061), syn2 0.150 (0.076). syn2 is 1.99 s.e. from zero. Its size is small (0.15 x 3.8 = 0.57 junctions of 45.9, 1.2%), but the heading generalises from one row. Fix: state the five slopes in the prose, name syn2 at 2 s.e., and give the 1.2% bound, or restrict the heading to SSD.

04-R9 (L) `04:416-417`, `04:733-735`. Scientific-scale inline values are printed with `sprintf("%.5f")` (slope -0.00025, s.e. 0.00013, per 100 plants: two significant digits) and the F1 table is rounded with `fmt(., 4)`: at n = 20, `p_loss_per_locus` 1.9e-06 prints 0 and `expected_loci_monomorphic` 4.5e-04 prints 0.0005. Convention: `fmt_sci()` (`_common.R:48`) for scientific inline values; for the table use `signif()` or `format(scientific = TRUE)`. Same for the line 407-421 values near 1e-4 (`fmt(gap_b * ..., 4)` = -0.001).

04-R10 (L) `04:718-730`, F1 section, and `R/06_f2size.R` roxygen of `f1_sizing`. The chapter asserts (stopifnot 727-728) only the alleles-lost column; the "loci made monomorphic" formula, which supplies `n_f1_loc` and the 9-plant claim, has no oracle in the chapter. I checked it by Monte Carlo (table above: 1.8 s.e.). Fix: add a small enumeration over the 3 x 3 parent genotypes in the chunk, or a Monte Carlo with a stated tolerance. Also: `R/06_f2size.R` documents the loci-monomorphic count as "about half of" alleles lost, `2 * h_res * n_loci_eff * (1/2)^n` (0.977 at n = 9), while the chapter's formula (with the (1 - h_res) factor and the both-heterozygous term) gives 0.928. The thresholds agree (9) but the two statements differ; the column named `expected_loci_lost` holds alleles lost, which is why the chapter finds it with `grep("lost", ...)`. Decide in it2 whether R/ docs or chapter is the reference (not edited here).

04-R11 (L) Hard-coded values in captions and alt text that nothing guards (the chapter's own convention, 04:8, says a change must break the render): `tbl-sizing-verify-diversity` ("100 live replicate", "D_sd / 10", "seed 5 + N") against `n_rep_chk` 3 lines above; `tbl-sizing-verify-het` ("400 plants", "seed 4"); `tbl-sizing-verify-spacing` ("500 lines", "seed 11"); `fig-sizing-ancestry` ("N = 20", "N = 300", "seeds 6 and 7", "4 cM"). The alt text of `fig-sizing-multilocus` (04:648) hard-codes "k = 3 rises from about 0.7", "k = 8 stays below 0.4", "k = 10 below 0.1": true now (k = 3 min 0.717, k = 8 max 0.373, k = 10 max 0.070) but k = 8 has a margin of 0.027 and no `stopifnot`. `h_res` and `n_loc` in the F1 caption are guarded only at 04:759, far from the chunk. Fix: tie each to the object (`stopifnot` or `paste0` in a `fig-alt` via an inline chunk option).

04-R12 (L) `04:423-428`. "The interpretation is that the gap is segregation distortion, the only departure from the neutral model in SSD" is asserted from the grid alone; the neutral verification (04:214-229) is at 10 cM, the grid at 2 cM. It holds. I ran neutral SSD on the 2 cM map, 20 replicates: N = 110: D 0.99173 (s.e. 0.00036), expected 0.99205, gap 0.0003; with distortion 0.98120, gap 0.0108. N = 390: neutral 0.99770 (s.e. 0.00010) vs 0.99776, gap 5e-5; with distortion 0.98795, gap 0.0098. So the whole gap is distortion, and it is flat (0.0108 to 0.0098) as the chapter reports. Add the neutral 2 cM twin at N = 110 and 390 to the chunk. Also the grid's `het` is 0.1254-0.1289 for SSD (not exactly 0.125); the effect on E[D] is at most 0.004/N, below the gap.

04-R13 (L) `04:111-124` P6 and `04:366-391`. `ssd_attr` is compared with the other schemes at the same F2 N, but its F4 panel has 70-75% of N lines (`n_final / N` = 0.701-0.753 over the grid; two 15% losses). Most of its D deficit against SSD is the smaller panel, which the chapter does not say. Add one sentence, or plot it against `n_final`.

04-R14 (L) `04:806-807`, `04:839-840`. "the claim that its diversity is a *ceiling* should be measured rather than asserted ... The F4 panel can be pushed straight into it": the chunk measures $GD = D/2$ and $N_s = 1/(2 - D)$, an identity, not a ceiling. "An optimiser cannot select back up to variation the panel never sampled" is asserted, not measured. Fix: reword the lead-in to what the chunk shows, or add the measurement (e.g. GD of a selected subset against the panel's GD under the same frozen base).

04-R15 (L) `04:51-59` citation. From the reference report (`it1-refs.md`, 04-B2): [@winkler2003] is attached to the (2 + g/2)L / 4L / 4.5L numbers, which the abstract does not give; the formula is the chapter's recursion (I verified it: L + gL/2 + L). Reword to "the recursion predicts ...; @winkler2003 discuss map expansion in intermated populations", and state the baseline of Lee et al.'s four-fold (L, F2, vs 2L, selfed RILs; 4L/2L = 2 at g = 4).

04-R16 (Info) `04:556-568`, `n90_bracket()`: no guard when no grid point satisfies `z < -2` (or `z > 2`): `max(which(...))` would return -Inf and the table would show a wrong N. It works on the current data (D 70-110, min(p,1-p) 30-350). At the two ends the variance of (y - threshold) double counts (se_n^2 + 0.81 se_n^2 at i = n). Neither moves a reported number. Add a `stopifnot(is.finite(...))`.

04-R17 (Info) `04:121-129`, `04:134`: the caption phrase "commonly quoted 0.5/sqrt(N)" has no source (04-B10 of the refs report); drop "commonly quoted" or cite a text.

04-R18 (Info) `04:20-23`: "the most common failure is to size for the objective that saturates earliest" is an unsupported statement about practice; hedge or cite.

04-R19 (Info) F1 wording `04:724`, `04:765`: "selfed F1 plants". The loss argument concerns the gametes the F1 plants receive from the parents, not their selfing; "F1 plants" suffices.

## What is verified and unchanged

- Criterion 1 values (all from code): junction deficits -3.8/-3.3/-5.6/-5.1/-6.4% (ssd/ssd_attr/bulk/syn1/syn2), orderings asserted; Haldane single-meiosis deficit -2.0%; gap range 0.0087-0.0108; weighted slope -0.00025 per 100 plants, s.e. 0.00013, 2.0 s.e.; N90 for D = 90 (bracket 70-110) and for min(p, 1-p) = 90 (bracket 30-350: the chapter already says the grid does not locate it); k = 3 reaches 0.95 at grid N = 50 and the closed form at grid N = 50 (continuous 34); k = 5 at 270 (closed form 185); n_f1 = 10, n_f1_loc = 9; Ns 0.966-0.988.
- Identities asserted by `stopifnot`: F4 het within 4 s.e.; D vs eq-sizing-div within 4 s.e.; deficits < 0 and ordered; closed form vs simulation within 4 s.e.; `GD == D/2` and `Ns == 1/(2 - D)` (exact); lost-alleles formula; distorter signs; k values.
- Stochastic assertions hold over 20 seeds (table above), with the largest abs z 2.57 against the tolerance of 4
- The one quantity that rests on a single draw per N (the multilocus rows, one population per N) is labelled as such in captions and prose.
- `book/downloads/04-population-sizing.R`: compared by non-comment code lines against a fresh `purl`; differences are only the setup block expansion at the top (not exhaustively diffed beyond it).

## Cost

All chapter chunks run in about 1.1 s live at the book's settings; the cached grid regenerates in 43 s. The extra checks above cost under 2 min in total.
