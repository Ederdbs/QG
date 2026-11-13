# 04-population-sizing -- verdict, iteration 1

VERDICT: REJECTED

(Chapter: book/04-population-sizing.qmd, 868 lines. Read in full, with THREAD.md and the three iteration-1 reports. Lines below are of the chapter as it stands.)

PREVIOUS IDS (re-review only)
- None (iteration 1). Owed items from THREAD.md naming `04` are judged below: `04:15` "candidate pool" -> 04-D1; `04:28` against A3 -> 04-D2; `04:808` GD citation -> 04-M1; P9 kept-true (04-R4) -> confirmed, no finding.

DISQUALIFYING FAILURES

- 04-D1 [criterion 5; endorses 04-C1 (H) and 04-R1] qmd:15-18 -- "The previous chapters took the candidate pool as given. This one asks where it comes from." 03 builds the candidate set (03:43-47, 03:376-384); it does not take it as given. And what this chapter produces is a panel of F4 lines from one cross, not a hybrid set, so "where it comes from" is not what is sized. "Candidate pool" is the name the book has retired (candidate set; "pool" = heterotic group), and it is an open Owed item since 00, 05b and 03. The reason 04 follows 03 (03:165-167: 03 does not model the selfing path to inbred lines) is not stated. An open H continuity finding rejects.

- 04-D2 [criterion 2; endorses 04-C2 (H) and 04-R2] qmd:16, 27-31, 486-488 -- The chapter's cross is "between two divergent heterotic groups" and P2 is later "the donor whose germplasm the cross was made to introduce". A3 (00:26-27, 00:199-205; 05:79-83) excludes exactly this: an F2-F4 derived from an A x B cross is the operation the programme never performs. The chapter neither declares the exception (pre-breeding / introgression outside A1-A8) nor says which row of @tbl-hp-stages it belongs to. Assumption violated without being declared. Owed 00-C2; unchanged. The numbers do not depend on it (ancestry-only simulator); the omission is in the framing and the declaration.

- 04-D3 [criterion 1 and 5; endorses 04-C3 (H)] qmd:842-855, callout "N_s is not informative inside a biparental cross" -- It reads N_s on molecular f as a head count: "the panel has the genetic base of a single diploid individual, which is exactly what N_s = 1/(2 theta) reports", and advises using N_s "only once material from several crosses has been pooled". On molecular f at biallelic loci theta lies in [1/2, 1], so N_s lies in [1/2, 1] for EVERY set, one cross or many (01:114-118; 06 @sec-ns; 90:627-631). Pooling several crosses does not make N_s informative; the advice is false in the book's own terms, and the reading is the one this standard names as rejecting. Also "@sec-ns warns that N_s describes a base rather than projecting drift" misstates 06, which denies the base reading for f. I recomputed the bridge chunk: N_s = 0.966, 0.985, 0.988 at n_F2 = 30, 120, 480; the identity N_s = 1/(2 - D) and the bound N_s <= 1 are correct as algebra; the interpretation is what fails.

- 04-D4 [criterion 3; folds 04-R6, adds own] qmd:553-633, 750-792 (@tbl-sizing-saturation, recovery rows; @tbl-sizing-working-numbers; @fig-sizing-multilocus) -- The "central practical result" and the working-numbers table give "Grid N reaching it" = 50 (k = 3) and 270 (k = 5), and "not reached" for k >= 8, from ONE simulated population per N, taking the FIRST grid N at which a noisy non-monotone curve reaches 0.95. The 300 locus sets are drawn inside that one population and are not replicates. A first-crossing statistic on a single noisy curve is biased low and unreplicated; the chapter says the curves are non-monotone and carry no replicate error (disclosure meets criterion 6, it does not supply the replication criterion 3 requires). The one replicated check (k = 5, N = 110, 20 populations) is on the NEUTRAL map, not on the distortion-active setting the table is about; the text then states, as an inference, that distortion makes the closed form understate "this was not shown beyond the grid". I ran the missing arm (seed 81, 10 cM, distortion active, k = 5, N = 110, 20 populations): P = 0.708 (s.e. 0.011) against neutral 0.8245 (s.e. 0.008) and closed form 0.831. So the closed-form number (185 at k = 5) and the grid number (270) differ for a reason that costs about a minute to establish, and the 57 of 60 "below the closed form" grid points are not independent (same locus-set sampling, one population per N, points of one curve). Recovery numbers are not sized to the claim made on them, and "270" appears in a table titled "working numbers".

- 04-D5 [criterion 3] qmd:462-488 (@tbl-sizing-bulk-vs-ssd and text) -- "at the largest N it retains less diversity than SSD at 30 plants" is reported from two bare means (0.954 and 0.961, 3 decimals) with no dispersion. Recomputed from `f2_results.csv`: bulk N = 390: D 0.95400, s.d. 0.00989, 10 replicates; SSD N = 30: D 0.96139, s.d. 0.00804, 40 replicates; difference 0.0074 = 2.19 standard errors. A borderline contrast, presented flatly, with the comparator N = 30 chosen after seeing the grid and no declaration that it is exploratory. (The companion claim "bulk is lowest at 20 of 20 grid values" is robust: against the second-lowest scheme (syn2) the margin is 6.7 to 20.9 s.e. at every N; that part stands, but the table that supports it also shows no dispersion.)

- 04-D6 [criterion 2 and 4; endorses 04-C5 and 04-C6, folds 04-R14] qmd:804-809, 830-840 -- The section opens "the claim that its diversity is a *ceiling* should be measured rather than asserted" and the table measures only the identity GD = D/2, N_s = 1/(2 - D). The text then concludes "The sizing decision made here therefore sets the GD that @sec-choosing, @sec-ocs and @sec-combinatorial spend the rest of the book budgeting ... and it sets it once. An optimiser cannot select back up to variation the panel never sampled", which is asserted, not measured (the "therefore" does not follow from the identity), and is repeated by index.qmd:116-118 on the authority of this chapter. It also conflates levels: the later chapters budget GD of hybrids against a frozen p0 and a random-subset reference under A2 (inbred parents, GD_WI = 0), A5 (independent loci) and A8 (teaching scale), whereas this panel has H = 0.125 (so GD_WI > 0), linked markers and itself as frequency base, and D divides by the cross's own maximum 0.5. None of these departures is declared at the bridge. The book's own results (06:574 alpha < 0 means more diverse than chance; 09:188) show subset GD can exceed the random-subset baseline by rebalancing, so the "cannot" is true only of alleles absent from the panel and the sentence does not say that.

NON-DISQUALIFYING OBSERVATIONS

- 04-M1 qmd:808-809 -- GD = 1 - theta cited to @sec-coancestry, which does not define GD; definition is @eq-hp-gd (00:395), identity @sec-identity. Endorses 04-C4 / 04-R3 (M). The identity itself I recomputed from the code and it is right.
- 04-M2 qmd:129-130, 155, 760, 41, 774 -- Symbols doubled against 00/02/90: H_t (00: expected heterozygosity of a set at generation t; 04: heterozygosity of the parent whose meiosis produces t + 1); unsubscripted H = H_o of 00:406 while plain H is gene diversity in 02; F_F3 against the 00 convention F^(t); "genetic N_e of the F1 is 1" as a head count against N_e as rate-defined (00:701). Endorses 04-C7 (M).
- 04-M3 qmd:154-158 -- E[D] = 1 - (1 - H)/N is checked by simulation only and not tied to the same 1/n factor in 00 (@eq-hp-drift), 05b, 03, 06; says nothing of what the H correction adds. Endorses 04-C9 (M).
- 04-M4 qmd:857-859 -- "this stage is where the cheapest insurance is available -- more plants, once, at the start" is the chapter's own claim; 08 varies cross selection, not plants per cross (08:358, 08:387), and no cost is measured here. Endorses 04-C10 (M, first half only; the 11c half is for 11c's review).
- 04-M5 qmd:371-390, 373-374 -- Endorses 04-R5 (M). ylim = c(0.88, 1) clips the bulk at N = 10 (0.738) and N = 30 (0.886); the alt text ("from about 0.9 to 1") and caption do not say the axis is truncated, and the clipped points are those supporting "the bulk line is lowest". I confirmed bulk D(N = 10) = 0.738.
- 04-M6 qmd:490-526 -- Endorses 04-R8 (M). Heading "Block length does not depend on N" and the conclusion "the instrument is an intercrossing cycle, not field area" rest on the SSD slope in the prose; recomputed slopes per 100 plants: ssd -0.002 (0.069), ssd_attr -0.010 (0.058), bulk 0.078 (0.071), syn1 0.053 (0.061), syn2 0.150 (0.076) = 1.99 s.e. Small (about 1% of the count) but the prose should not generalise from one row.
- 04-M7 qmd:329-340, 291-319 -- Endorses 04-R7 (L, held at M here). 1 cM vs 2 cM deficit rests on two single panels (recomputed: -2.28% and -5.15%, s.e. 0.75 each, difference 2.87 pp, s.e. 1.07). The chapter is honest about it; the sentence "A finer map reduces the deficit" at 291 is stated before the caveat at 336-340, and the 2 cM panel is a 1.4 s.d. draw by the audit's 20-seed rerun. Replication is a minute of compute.
- 04-M8 qmd:423-428 -- Endorses 04-R12 (L). "The only departure from the neutral model in SSD" is labelled interpretation (good) but its neutral control is at 10 cM; the grid is at 2 cM. Audit shows it holds; the chapter does not show it.
- 04-M9 qmd:53-56 -- Endorses 04-B2 / 04-R15 (criterion 7, not decisive). [@winkler2003] is attached to (2 + g/2)L, 4L, 4.5L, which are the chapter's own recursion (I verified: L + gL/2 + L) and are not in the abstract; the baseline of Lee et al.'s four-fold (F2, L, vs selfed RIL, 2L) is not stated, so "of that order" is baseline-dependent. Peripheral to the sizing argument, so not decisive; listed under NOT VERIFIED.
- 04-M10 qmd:20-23, 235-236 -- Endorses 04-R18 and 04-R17/04-B10: "the most common failure is to size for the objective that saturates earliest", "a result many programmes get wrong", "commonly quoted 0.5/sqrt(N)" are claims about practice or the literature with no source.
- 04-M11 qmd:38-173 -- Endorses 04-C8 (L). P1..P9 label the assumptions and also the parents (P1, P2); 05b cites "its P9", so the label is a cross-book address.
- 04-M12 qmd:722-736 and `R/06_f2size.R` -- Endorses 04-R10 (L). "Loci made monomorphic" has no oracle in the chapter; R/ docs say "about half of alleles lost" (0.977 at n = 9) while the chapter formula gives 0.928 (recomputed from the chunk values: 10 and 9 plants). The thresholds agree; the two statements do not. Declared in R/ or chapter, one must be the reference.
- 04-M13 qmd:134, 187, 216, 297, 436, 647-648, 724, 757 -- Endorses 04-R11 (L): captions and alt text hard-code values that nothing guards (e.g. "k = 8 stays below 0.4", margin 0.027).
- 04-M14 qmd:416, 733-735 -- Endorses 04-R9 (L): scientific-scale inline values printed with sprintf/fmt(.,4) (F1 table prints 0 for 1.9e-06); `fmt_sci()` is the convention.
- 04-M15 qmd:111-124 -- Endorses 04-R13 (L): ssd_attr is compared at equal F2 N but its panel has 70-75% of the lines; not stated.
- 04-M16 own, qmd:73-80 -- "Mean block lengths and allele frequencies are unaffected [by interference], because the map length fixes the mean number of crossovers": the mean number of crossovers per meiosis is fixed, but the marker-observed junction count (the chapter's own measure, with a known downward bias from double events in one interval) and the dragged region around a distorter depend on the joint distribution of crossovers. Stated as a fact in a paragraph that also says the size of the difference was not measured. Not verified, not decisive.
- 04-M17 own -- No sensitivity run on the generating-model inputs that drive the headline numbers (distorter strengths and positions, beta = 6, attrition 15%, h_res, n_loc). Declared as model inputs (P5, P6, callout at 103-109), and the conclusions are scoped "inside the range tested", but the range tested is of N only; "more plants buy little distortion protection" and the working numbers are statements about this one distorter configuration.

Count: 17 non-disqualifying observations; 6 disqualifying failures.

R, B, C FINDINGS: ENDORSEMENT TABLE

| ID | Endorsed | Severity here |
|---|---|---|
| 04-R1 | yes | D (04-D1) |
| 04-R2 | yes | D (04-D2) |
| 04-R3 | yes | M (04-M1) |
| 04-R4 | yes, keep true | info |
| 04-R5 | yes | M (04-M5) |
| 04-R6 | yes, reproduced (0.708 s.e. 0.011) | folded into D (04-D4) |
| 04-R7 | yes | M (04-M7) |
| 04-R8 | yes | M (04-M6) |
| 04-R9 | yes | M (04-M14) |
| 04-R10 | yes | M (04-M12) |
| 04-R11 | yes | M (04-M13) |
| 04-R12 | yes | M (04-M8) |
| 04-R13 | yes | M (04-M15) |
| 04-R14 | yes | D (04-D6) |
| 04-R15 | yes | M, criterion 7, not decisive (04-M9) |
| 04-R16 | yes, info (guard against empty bracket) | info |
| 04-R17 | yes | M (04-M10) |
| 04-R18 | yes | M (04-M10) |
| 04-R19 | yes ("selfed F1 plants": the argument is about gametes received, not selfing) | info |
| 04-B1 | haldane1919 metadata OK, formula standard | no finding |
| 04-B2 | yes | M, not decisive (04-M9) |
| 04-B3, B4, B5, B6, B9 | OK | none |
| 04-B7 (fisher1954), B8 (sedcole1977) | wording "in the sense of" / "classical number" acceptable; formula verified algebraically | NOT VERIFIED, non-decisive |
| 04-B10 | yes | M (04-M10) |
| 04-B11 | textbook items by name; no quantitative claim depends | info |
| 04-B12 | OK as hedged | none |
| 04-C1 | yes | D (04-D1) |
| 04-C2 | yes | D (04-D2) |
| 04-C3 | yes | D (04-D3) |
| 04-C4 | yes | M (04-M1) |
| 04-C5 | yes | D (04-D6) |
| 04-C6 | yes (the 03 pointer is 03's business; the unmeasured "ceiling" claim is 04's) | D (04-D6) |
| 04-C7 | yes | M (04-M2) |
| 04-C8 | yes | M (04-M11) |
| 04-C9 | yes | M (04-M3) |
| 04-C10 | first half yes, second half belongs to 11c | M (04-M4) |

WHAT WAS VERIFIED

- Purled chapter run against `pkgload::load_all("..")` of the worktree: no error, all `stopifnot()` pass; inline values below were printed from that run.
- Table row identities and @eq-sizing-div: Var(dosage) = (1 - H)/4 for an F4 line, E[D] = 1 - 4 Var(p_hat) = 1 - (1 - H)/N at p0 = 0.5, F2 plants independent given a uniform F1 -- algebra by hand, correct. Junction recursion A_2 = L, A_(t+1) = A_t + L H_t gives A_4 = 1.75 L, Syn adds 0.5 L, selfing-to-fixation after g intercrossings gives (2 + g/2) L -- by hand, correct.
- N_95 closed form: per-line P2 homozygote probability (1 - H)/2 and independence of k loci on distinct chromosomes (`multilocus_recovery()` samples distinct chromosomes) and of lines (independent F2 plants of one uniform F1); form 1 - (1 - q^k)^N, correct. Chunk value P_closed 0.8309, neutral simulation 0.8245 (s.e. 0.0079), 57 of 60 grid points below closed form.
- Distortion arm (not in the chapter): seed 81, k = 5, N = 110, 10 cM, distortion active, 20 populations: 0.7083 (s.e. 0.0109), closed form 0.8309.
- Bridge identity: GD = D/2 and N_s = 1/(2 - D) by algebra (theta = mean over all pairs, self included, of the 0/0.5/1 molecular coancestry = mean of p^2 + (1-p)^2) and by the chunk assertions; N_s = 0.966, 0.985, 0.988.
- F1 section: expected alleles lost 2 h_res n_loc 2 (1/2)^n = 1000 (1/2)^n, 0.977 at n = 10; loci made monomorphic formula by hand (Aa x aa, both-heterozygous 2 (1/4)^n), 0.928 at n = 9. Matches the chunk.
- Junction deficits (-3.78, -3.35, -5.61, -5.14, -6.36%), 1 cM and 2 cM live panels (-2.28% and -5.15%, s.e. 0.75, 0.76; difference s.e. 1.07), gap range 0.00867 to 0.01077, weighted slope -2.5e-6 per plant (z = -1.998), N_90 brackets (D 70 to 110; min(p, 1-p) 30 to 350), block-length slopes, step gains: all reproduced from the chunk run.
- Bulk vs SSD at N = 30: from `book/data/f2_results.csv`, bulk lowest at all 20 N (margin to second lowest 6.7 to 20.9 s.e.); bulk N = 390 vs SSD N = 30: difference 0.0074, 2.19 s.e.
- Cached grid: audit reports `f2_run_experiment(f2_opt)` reproduces `f2_results.csv` and `f2_multilocus.csv` bit for bit (seed 20260828); I did not rerun it. I relied on it for provenance (criterion 3, provenance: the grid is a repository product, labelled as such in the captions).
- Reading `multilocus_recovery()` and the grid code in `R/06_f2size.R`: the multilocus P is one population per N (replicate 1), confirmed.

NOT VERIFIED

- [@winkler2003] as the source of (2 + g/2)L, 4L, 4.5L: abstract only per 04-B2; formula is the chapter's own recursion. Non-decisive.
- [@fisher1954] and [@sedcole1977] for the recursion and the N_95 form: full text not obtained; the formulas were verified algebraically, the attribution was not. Non-decisive.
- [@haldane1919]: formula standard, original not read. Non-decisive.
- Seed dependence of the chapter's single-draw tables (het, bridge, spacing): audit ran 20 other seeds for the het and D checks (max |z| 2.57 against 4); I did not repeat.
- 04-M16 (interference and block-length / drag): no run.
- Caption of @fig-sizing-ancestry ("the departures that remain sit at the three distorters"): not checked against the plotted panel.
