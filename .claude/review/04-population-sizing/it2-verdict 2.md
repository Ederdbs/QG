# 04-population-sizing -- verdict, iteration 2

VERDICT: APPROVED

(Chapter: book/04-population-sizing.qmd, 1161 lines. Read in full, with it1-verdict.md, it1-response.md (quant-writer and quant-Rwrite sections), THREAD.md, and `git diff origin/main` for the chapter, 03:165, 05b:524, 90-notation rows and the roxygen of `R/06_f2size.R`/`man/f1_sizing.Rd`. Lines are of the chapter as it stands.)

PREVIOUS IDS (re-review only)
- 04-D1 -- CLOSED -- qmd:15-21 now says 03 draws lines inbred by fiat (03:160 has the phrase) and does not model the selfing path (03:163-166), and that what is sized is the F4 line panel, not the hybrid candidate set; 03:166 now points to @sec-sizing. "candidate pool" no longer occurs in the chapter (grep). Owed items 00/05b/03 for `04:15` resolved.
- 04-D2 -- CLOSED -- qmd:23-33 declares the A3 exception (A3 at 00:26-27 and 05-genomic-era:79-83 says a DH/line from an A x B F1 never happens), places the selfing route under A2/S2, and says the numbers do not depend on it because the simulator carries ancestry only. Owed 00-C2 resolved.
- 04-D3 -- CLOSED -- callout qmd:1135-1147: N_s = 1/(2 - D) in [1/2, 1] for every set, monotone rescaling of theta, no pooling would change it; "single diploid" and "only once crosses are pooled" gone; 06 paraphrase gone. Bridge chunk run: N_s 0.966, 0.985, 0.988; assertions pass.
- 04-D4 -- CLOSED -- recovery rows are now replicate means (20 populations per grid N, 20 N, k in 3/5/8/10, seeds 20261108 + N) with 2-s.e. brackets, computed live in the chapter and labelled as such; distortion arm added; "57 of 60" replaced by a count with the non-independence stated; cached one-population crossing demoted and not used in the working table. I re-ran the purled chapter (33 s, all stopifnot pass) and an independent re-measure with a different seed (777, k = 5, 2 cM, distortion active, 20 populations): N = 250 mean P 0.943 (s.e. 0.0031), N = 270 mean P 0.952 (0.0035), against the chapter's 0.947 (0.0034) and 0.955 (0.0034): the crossing at 270 and the bracket 230-290 reproduce. Distortion arm in chapter: 0.752 (0.013) against neutral 0.8245 (0.0079) and closed form 0.831 (6.1 s.e. below). Scope (one distorter configuration, random loci on distinct chromosomes) is stated at qmd:132-142 and 850-851.
- 04-D5 -- CLOSED -- tbl-sizing-bulk-vs-ssd carries n_rep, s.d., lowest other scheme and margin; recomputed margin 6.65 to 20.88 s.e. over 20 of 20 N; bulk(390) vs SSD(30) 2.19 s.e., declared exploratory and "not offered as a finding" (qmd:614-622).
- 04-D6 -- CLOSED -- qmd:1056-1154: lead-in no longer claims a ceiling is measured; scope paragraph declares the departures from A2, A5, A8 and from a frozen base; the "sets it once / spend the rest of the book budgeting" sentences are gone; the measured statement (greedy 10-line subset GD 0.479-0.488 against panel 0.482-0.494, random 0.451-0.454, three panels) is scoped as such; only the conditional "no selection restores an allele the panel lacks" is asserted; bound (1 - fixed)/2 is correct and asserted in the chunk.
- 04-M1 -- CLOSED -- GD cited to @eq-hp-gd and @sec-identity.
- 04-M2 -- CLOSED -- h_t replaces H_t (qmd:164-167, 90 row); H declared as H_o averaged over plants and loci; F^(2) = 0.75 per 00 convention (00:537 ff.); "one genotype" replaces "N_e of the F1 is 1".
- 04-M3 -- CLOSED -- qmd:194-205: derivation at p0 = 1/2 (E[D] = 1 - 4 Var(p_hat), Var(p_hat) = (1 - H)/(4N)), tie to @eq-hp-drift (matches 00:590-606: n_gam, Delta F = 1/n_gam) and @sec-baseline; (1 - H) factor explained; "not a Wright effective size". Algebra checked by hand.
- 04-M4 -- CLOSED -- "cheapest insurance" removed; qmd:1149-1154 says 08 does not vary plants per cross and no cost is measured. (11c half belongs to 11c.)
- 04-M5 -- CLOSED -- ylim = c(min(f2$div), 1); caption and alt text consistent; stopifnot passes (0.74 at N = 10 bulk).
- 04-M6 -- CLOSED -- all five slopes reported: z = -0.04, -0.17, 1.11, 0.86, 1.99 (syn2); at most 1.3% of the mean junction count over the grid; conclusion scoped "for this grid".
- 04-M7 -- CLOSED -- spacing chunk replicated: 2 cM -4.24% (s.e. 0.19), 1 cM -2.18% (0.16), 20/20 panels negative; difference 2.05 pp, s.e. 0.24; "reduced but not removed" scoped.
- 04-M8 -- CLOSED -- neutral 2 cM twin at N = 110 and 390: gaps 5.3e-4 (s.e. 4.7e-4) and 1.2e-4 (1.1e-4) against 1.0e-2 and 9.1e-3; attribution limited to those two sizes.
- 04-M9 -- CLOSED (non-decisive, carried in NOT VERIFIED) -- winkler2003 no longer attached to the formula; baseline dependence of Lee et al.'s four-fold stated; which baseline Lee et al. use is explicitly marked UNVERIFIED in the text. No claim rests on it.
- 04-M10 -- CLOSED -- grep for "commonly / most common / many programmes / literature": none left.
- 04-M11 -- CLOSED -- SA1-SA9 renamed; 05b:524 "its SA9" and the SA9 text (phenotypic inbreeding depression not modelled) agree, so 05b's keep-true callout stays true.
- 04-M12 -- CLOSED -- enumeration oracle `p_mono()` asserted against the closed form; roxygen of `f1_sizing()` rewritten; I recomputed 0.9278 (formula) against 0.9766 (half of alleles lost) at n = 9, h = 0.05, 5000 loci; chapter and R docs now agree. R/06_f2size.R is ASCII (grep clean).
- 04-M13 -- CLOSED -- stopifnot guards beside the chunks for the caption literals; all pass in the run.
- 04-M14 -- CLOSED -- fmt_sci() and formatC(digits = 3) used for small values.
- 04-M15 -- CLOSED -- ssd_attr 70-75% of lines stated; eq-sizing-div at n_final accounts for 103% (0.0790 against 0.0770, recomputed).
- 04-M16 -- CLOSED -- the interference paragraph (qmd:97-109) now restricts "unaffected" to the expected crossover number and says the observed count and drag were not measured.
- 04-M17 -- CLOSED (scoped, limitation carried) -- not run; callout qmd:132-142 and the inference lines name SA5 and scope every distortion statement to this one configuration. The N_95 contrast between objectives also follows from the distortion-free closed form (34, 185, 2230, 11659 for k = 3, 5, 8, 10), so the "no single N" statement does not depend on the distorter inputs.
- 04-R1..R19, 04-B1..B12, 04-C1..C10 -- CLOSED as folded into the IDs above (C6 03 pointer present at 03:166; C7 90 rows edited; C9 cross-reference to @eq-hp-drift/@sec-baseline present; C10 first half done). B2/B7/B8 and B1 remain UNVERIFIED (non-decisive, see below). R16: n90_bracket returns NA and the chunk asserts finite brackets (ran).
- Contested items: none contested by the author. The only item the author declined (cache the replicated recovery grid in `regenerate.R`) is accepted: the chapter computes it live from the repository, and the caption says "computed in this chapter, not cached".

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 04-M18 qmd:1129-1131 -- "The book's own results show that, on hybrids against a random-subset reference, a selection can have alpha < 0 (@sec-baseline)". 06:574 defines alpha < 0 as "more diverse than chance"; it does not show a selection with alpha < 0. The statement is true by the definition of alpha (and for diversity-maximising selections), but "show" attributes to the book a result the cited section does not display. Peripheral to the bridge argument (the measured comparison is with the panel's own GD).
- 04-M19 qmd:831-836 and 801-806 -- the distortion arm (set.seed(9), 20 populations, 0.752, s.e. 0.013) is the only seed reported. Two other 20-population arms made in review gave 0.708 (0.011) and 0.747 (0.014); the arm-to-arm spread (sd 0.024) is somewhat larger than the within-arm s.e. The direction and size of the departure from the closed form (0.831) hold in all three (3 to 11 s.e.), so no conclusion moves, but the single "6.1 s.e." is a one-seed figure and the chapter does not say the arm-to-arm variation is wider than its s.e. suggests.
- 04-M20 outside the chapter, owed to other reviews, not a failure of 04: THREAD.md lines 211 and 242 still say "04's P9" (now SA9); `04d-breeding-programme.qmd:376-379` ("same arithmetic @sec-sizing explains") no longer matches what 04 says about N_s (monotone rescaling in [1/2, 1], not the diagonal argument); `index.qmd:116-118` ("a panel cannot be selected back up to variation it never sampled (@sec-sizing)") is true only in the conditional sense 04 now states. The chapter itself is consistent.
- 04-M21 process -- Quarto render and `_freeze` not refreshed (author says so); the chapter now costs ~33 s to re-execute. Not a content failure.

Count: 4 non-disqualifying observations (M18 and M19 are the only ones about the chapter's content; M20-M21 are owed elsewhere); fewer than three accumulated failures within the chapter. Does not reject.

WHAT WAS VERIFIED
- Purled chapter run end to end against the worktree's installed `hybdiv` (knitr::purl, source from `book/`): 33 s, no error, every `stopifnot()` passes (grid seed/n_rep guards, het and diversity checks, spacing, twin, ssd_attr, bridge GD = D/2, N_s = 1/(2 - D), GD_greedy <= bound, `p_mono()` enumeration against the closed form).
- Recovery table (run output): D N90 = 90, bracket 70 to 110; min(p, 1-p) N90 = 90, bracket 30 to 350; k = 3 first crossing 50 (bracket 30 to 50), k = 5 270 (230 to 290), k = 8, 10 not reached (mean at 390: 0.293 (0.008), 0.057 (0.004)); closed form 34, 185, 2230, 11659. Bracket logic re-derived by hand from the printed means and s.e. at k = 5 (N = 230, 250, 270, 290).
- Independent re-measure, seed 777, k = 5, 2 cM, distortion active, 20 populations: N = 250 0.943 (0.0031), N = 270 0.952 (0.0035) -- consistent with the chapter's means (0.947, 0.955).
- 59 of 60 (grid N, k >= 5) points more than 2 s.e. below the closed form; none of the 59 has se = 0 (no vacuous counts); the one exception is k = 10 at one N.
- Closed form (1 - H)/2 per-locus P2P2 probability and N_95 formula: algebra by hand; neutral arm 0.8245 (0.0079) vs closed 0.8309 passes the 4-s.e. assertion.
- Identities by hand: Var(dosage) = (1 - H)/4 for an F4 line; E[D] = 1 - 4 Var(p_hat) at p0 = 1/2; GD = D/2 and theta = mean(p^2 + (1-p)^2) with 0/0.5/1 coding; bound GD(subset) <= (1 - fixed)/2; F3 plant F^(2) = 0.75, coancestry (1 + F)/2 = 0.875.
- Bulk-vs-SSD: margins 6.65 to 20.88 s.e. over 20 of 20 N; bulk(390) vs SSD(30) 2.19 s.e. (exploratory, declared).
- Block-length slopes and z (-0.04 to 1.99), twin gaps, spacing deficits, junction deficits (-3.78, -3.35, -5.61, -5.14, -6.36%), het table (F2 0.497, F3 0.254, F4 0.127, all within 4 s.e.), gain steps past N90 (all within 2 s.e. where the text says so): printed from the run.
- f1_sizing roxygen: 0.9278 vs 0.9766 at n = 9 (Rscript); R/06_f2size.R has no non-ASCII characters.
- A3, A2, S2 and eq-hp-drift wording read against 00:18-42, 05-genomic-era:79-83 and 00:590-625; 03:160-166, 05b:521-524 and 90-notation row edits read in `git diff`.
- Provenance labels: `regenerate.R f2size` writes f2_results.csv and f2_multilocus.csv (book/scripts/regenerate.R:65-69); chapter captions label them "cached", and the replicated recovery grid "computed in this chapter, not cached".

NOT VERIFIED
- [@winkler2003], [@fisher1954], [@sedcole1977], [@haldane1919] (it1 refcheck: UNVERIFIED at full text; formulas verified algebraically by me and by the it1 reviewer; the chapter no longer attaches winkler2003 to the recursion and flags the Lee et al. baseline as UNVERIFIED). Non-decisive: no number of the argument rests on the attribution.
- Interference effect on observed junction count and drag (SA4): not measured, stated as such in the chapter.
- Sensitivity to distorter strengths, positions, number, beta = 6, attrition, h_res, n_loc: not run, declared in the chapter and the conclusions scoped to the single configuration.
- The cached grid `f2_results.csv`/`f2_multilocus.csv` were not regenerated in this iteration (it1 audit: bit-for-bit reproducible, seed 20260828); the replicated recovery grid, the twin, spacing and bridge chunks were re-executed.
- Rendered HTML/PDF and `_freeze`: not checked.
