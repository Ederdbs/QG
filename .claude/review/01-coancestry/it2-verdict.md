# Verdict -- 01-coancestry, iteration 2

VERDICT: APPROVED

Chapter: `book/01-coancestry.qmd` (506 lines now). Read in full, with it1-verdict.md, it1-response.md, the git diff of `book/01-coancestry.qmd`, `book/00-hybrid-programme.qmd`, `R/00_data.R`, `man/molecular_coancestry.Rd`. `docs/` and `_freeze/` not judged. Source PDFs read by pdftotext: Gomez-Romano et al. 2016, Meuwissen et al. 2020, Caballero & Toro 2002 (all under reference/papers).

Counts: iteration-1 IDs closed 16 (D1, D2, D3, M1-M13), reopened 0; new: disqualifying 0, non-disqualifying 2 (both Low: M14, M15). Two non-disqualifying failures are below the three-failure threshold.

## PREVIOUS IDS
- 01-D1 -- CLOSED -- the table row and the closing paragraph now separate the coancestry-based metrics (`theta_group()`, `gene_diversity()`, `status_number()`, read from `ctx[["f"]]`) from the frequency-based ones (`theta_from_freq()`, `he_nei()`, `He`, `alleles_lost`, `F_hom`, `F_drift` of `freq_metrics()`, read from `colMeans(ctx[["X"]][idx, ])` and `ctx[["p0"]]`). Checked against `R/01_metrics.R:18-22, 46, 58-75, 212-226`. The test paragraph matches `tests/testthat/test-metrics.R:11-40` and now says that metrics reading `f` without `theta_group()` are not covered. The roxygen half in `R/00_data.R:62-65` and `man/molecular_coancestry.Rd` is corrected and consistent. One residue of the same wording elsewhere is recorded as 01-M15.
- 01-D2 -- CLOSED -- "absolute scale" and "no arbitrary base population" are gone (grep: the only "absolute" left says f "is not an absolute coancestry"). The new paragraph "What the scale of f is" states that f is IBS, gives E[f_ij] = A_ij/2 + (1 - A_ij/2) * floor with the assumptions of @eq-hp-ibs-ibd, floor >= 1/2, level set by the panel, f read as a comparison between sets on the same markers: this agrees with 00:449-524. The G_0.5 section now says the removed 1/2 is the floor of @eq-hp-ibs-ibd for a base at p_b = 0.5, a fixed convention and not the panel's floor. I recomputed the algebra and the panel dependence (below).
- 01-D3 -- CLOSED -- (a) Gomez-Romano 2016: every quotation matches the text of p. 12-13 ("range from -1 to x, where x can be substantially larger than 1"; "estimates of the average coancestry across the whole genome tend to be within the valid range" with the small-region qualification; minor-allele penalisation; centring makes the matrix non-invertible; "natural" interpretation; positive definiteness "should hold"; "drive the gene frequency towards 0.5" versus "favour the status quo"; choice depends on the objective). The guarantee of [0, 1] is now labelled the book's own inference. The zero total is no longer called a range violation; G1 = 0 gives a singular G, which is the non-invertibility the authors name (I confirmed G1 = Z(Z'1)/den = 0). (b) Meuwissen 2020: "proportional to homozygosity and molecular coancestry" verbatim, p. 3, citing Toro et al. 2014, base-generation frequency p0 as the contrast; abstract quotation verbatim; "there will be pressure to move allele-frequencies toward 0.5" verbatim, Methods, with Supplementary Information 1 giving cov(dp; p0) < 0, F_hom < 0, F_drift > 0. The limit is now stated and bounded ("measured where those metrics are reported, not here"; 05-genomic-era does report the F_hom/F_drift gap on the book's own selections, 05:892-930). "Not a coincidence" is gone.
- 01-M1 -- CLOSED -- the opening paragraph says what 00 already defined and what 01 supplies, and declares A2 and biallelic markers. Closes introduction-C2 for this chapter.
- 01-M2 -- CLOSED -- group coancestry, Malecot coancestry, s_i/F_i and F_hom now cross-reference @sec-hp-ibd and @sec-hp-inbreeding (both labels exist in 00); the forward pointer for F_hom is gone. Closes 00-C25 for this chapter.
- 01-M3 -- CLOSED -- the referent is the printed `heterozygous_fraction`; the identity 2(1 - mean diag f) = 1 - mean(F_i) = 1 - mean(fL[A,B]) is now asserted in a chunk (all three 0.3616896 in my run); the neutral Balding-Nichols condition and the one-line derivation (P(het) = 2 p0 q0 whatever F_BN, given independent pools) are correct; "identity of the realised factorial, not an expectation" is right; the pointer to @sec-simulating-crosses matches its caption (one simulated pair of pools per point, flat).
- 01-M4 -- CLOSED -- "not a function of n/N alone"; chunk `S_sum` asserts the Monte Carlo (seed 11, 20000 draws: 75.7129 against 75.5192, s.e. 0.1065, 1.8 s.e., bound 4 s.e.) and the exact closed form (tolerance 1e-12). The formula is exact, I re-derived it.
- 01-M5 -- CLOSED -- rulings below (contested hand-off item 2). The prose states 0/1/2 input and the list return, and `R/00_data.R:98-102` confirms both (`p <- colMeans(M)/2`, returns `list(G, Z, p)`).
- 01-M6 -- CLOSED -- chunk `G05` now asserts `min(f) > 0.5` and `all(abs(G05) <= 2)`; min f 0.6448, range(G05) 0.579-1.327.
- 01-M7 -- CLOSED -- "most consequential mistake" and "meaningless" are gone (grep); the subset sum is described as a well-defined distance from the population centroid that is not a coancestry, consistent with the algebra.
- 01-M8 -- CLOSED -- N_s in [1/2, 1] on f stated with @sec-ns; chunk `ns-on-f` (seed 3, 1000 random subsets) asserts it: whole population 0.7442, subsets 0.6943-0.7445. The bound is algebraic (per marker x-bar^2 + (1 - x-bar)^2 in [1/2, 1]), so the sample is an illustration, not the evidence.
- 01-M9 -- CLOSED -- GD_BS, GD_T used, with pointers.
- 01-M10 -- CLOSED -- theta_S in prose, `theta_S_on_G` in chunk and prose and in the downloadable script (grep: no `theta_on_G` left).
- 01-M11 -- CLOSED -- "base-generation frequency p_{0,k}" matches Meuwissen p. 2-3.
- 01-M12 -- CLOSED -- the IBS-not-IBD caveat and the pointer to @eq-hp-ibs-ibd are in place; Caballero & Toro 2002 p. 292 sentence checked (see M-level remark under Info, not counted).
- 01-M13 -- CLOSED -- ruling below.
- 01-R9 -- CLOSED (Info) -- tolerance 1e-12 on the exact identities.
- 01-R10, 01-B5 -- remain under NOT VERIFIED, not decisive.
- 01-R11, 01-R12 -- out of scope, unchanged.

## RULINGS ON THE CONTESTED ITEMS
- 01-M13 (terminology "dominance deviation"): the writer's position is accepted for this chapter. 05b:108-110 defines d_k as "the departure of the heterozygote from the homozygote midpoint" and 05b separates it explicitly from Fisher's statistical dominance deviation; 01 now carries the same definition at first use and points to @eq-het-value. The sum-of-d_k statement (F1 minus mid-parent over the loci where the inbred parents differ, no epistasis) is correct. The word "deviation" for the functional d is idiosyncratic against Falconer & Mackay, but it is book-wide, defined, and not used here in the statistical sense; its fate belongs to the 05b and 90-notation reviews. The Falconer chapter number (ch. 14) stays UNVERIFIED and non-decisive. Closed.
- Hand-off item 2 (print `names(vanraden_G(...))`, marked optional, contested as unnecessary by Rwrite): accepted. The defect in 01-M5 was an unstated coding and return type; both are now stated before the chunk and are true. `args(vanraden_G)` printing `function (M) NULL` no longer hides anything the text does not say. Closed.

## DISQUALIFYING FAILURES
None.

## NON-DISQUALIFYING OBSERVATIONS
- 01-M14 `book/01-coancestry.qmd:234, 288-292, 419-420` -- "the floor" / "panel floor" names two different quantities. In "What the scale of f is" it is m^-1 sum_k (p_b,k^2 + q_b,k^2) with the base-population frequencies of @eq-hp-ibs-ibd (as in 00). After the `f` summary chunk and in the G_0.5 paragraph it is m^-1 sum_k (p_k^2 + q_k^2) with p_k the frequency in the N hybrids, defined in the sentence but under the same name. The second is an exact identity of any set (mean(f) = floor_p, asserted at 1e-12; it is the `theta_from_freq()` identity that 06 uses), not a measurement of the base floor; the hybrids share parents and have no declared pedigree base. Each use is defined where it occurs, so no number is wrong, but the symbol is redefined without a new name. Low.
- 01-M15 `R/01_metrics.R:2` (code comment, file header) -- "All operate on the molecular coancestry `ctx[["f"]]`, never on centered G" is the D1 sentence again, in the file that holds `freq_metrics()`, `theta_from_freq()` and `he_nei()`, which do not read `f`. The roxygen of `R/00_data.R` was corrected; this header comment was not. Chapter 01 is true without it. Low.

Info (not counted, nothing required for the verdict):
- `:225-228` -- "give the same result only if" is one word stronger than Caballero & Toro 2002 p. 292, which states the infinite-distinct-alleles condition as sufficient ("will give exactly the same results ... if"); the same paragraph continues "In other cases" with 1 - f_m = (1 - sum p_k^2)(1 - f), which implies the converse and is the relation behind @eq-hp-ibs-ibd. The substance is right and the quotation is accurate.
- `:186-192` (callout) -- "the reference moves with the set" holds when G is built on the set measured (the whole-population case, and G recomputed per set); for a subset of a pool-level G the reference is the fixed pool centroid, which the chapter states correctly at `:152-156`. Read together the two passages agree.
- Cross-chapter: `index.qmd:32` still says every diversity quantity computed from G "is meaningless" and "@sec-coancestry shows this happening"; 01 removed "meaningless" (01-M7) and says the number is not a coancestry. Owner: index/introduction review.

## OWED ROWS (hand-off from the response; each checked against the cited lines)
| Row | Names its chapter and line | Chapter 01 true without it |
|---|---|---|
| 01-C7 -> 06 | yes: `06:13-14` "every one operates on the molecular coancestry matrix"; `06:157-158` "Molecular f has no base" (against the base-frequency floor of 00 and the new 01 paragraph; its [1/2, 1] statement agrees with 01) | yes |
| 01-C8 -> 04 | yes: `04:808-809` cites @sec-coancestry for GD = 1 - theta; 01 names GD_S in its opening only, defines it nowhere | yes |
| 01-C11 -> 08b | yes: `08b:19` quotes "is the right matrix for GBLUP." which is neither in 01 nor in the roxygen | yes (01:80-81 says it in other words, with VanRaden 2008) |
| 01-C12 -> 02 | yes: `02:5-14` does not cite 01 | yes (01's hand-over sentence is true of 02) |
| 01-C13 -> 04c (and 90) | yes: `04c:318-322` x_ik in {0,1,2}; `90:547-550` already says "not the 0/0.5/1 entry of X", so the 90 half may be moot | yes |
| new: index | `index.qmd:32` "meaningless" (see Info) | yes |

## WHAT WAS VERIFIED
- All chunks of the chapter, purled and sourced against the worktree package (`pkgload::load_all`, `simulate_data(book_cfg)`, N = 625, m = 2000): every `stopifnot` passes, "ALL OK"; no `book/Rplots.pdf` created.
- `sum(G)` = -4.178879e-11; `Ns_on_G` = -9.35e15 (reciprocal of round-off, as the text says); min G = -0.139.
- `status_number` on f: whole population 0.7441504; 1000 random subsets (seed 3) 0.6943-0.7445, all in [1/2, 1].
- Subset-sum expectation, n = 100, 20000 draws, seed 11: 75.7129 against 75.5192, s.e. 0.1065; the exact form asserted.
- Panel dependence: floor 0.6719, off-diagonal mean 0.6717, MAF > 0.3 subset 0.5271, MAF < 0.15 subset 0.8710 (chunk `panel-floor`; matches my iteration-1 figures); identity mean(f) = mean(p^2 + q^2) asserted at 1e-12 and derived by hand (sum over N^2 pairs at marker k = (N p)^2 + (N q)^2).
- `G05 = tcrossprod(2X - 1)/(m/2)` equals `4f - 2` (tolerance 1e-12, chunk `G05`); algebra of @eq-g05 redone line by line: (2X - J)(2X - J)' / (m/2) = (8XX' - 4X11' - 4 11'X' + 2mJ)/m = 4f - 2J; c'G_0.5 c = 4c'fc - 2 under 1'c = 1; range(G05) 0.579-1.327.
- Heterozygous fraction 2(1 - mean diag f) = 1 - mean(F_i) = 1 - mean(fL[A,B]) = 0.3616896 (chunk, 1e-12).
- Quotations against the local PDFs: Gomez-Romano 2016 p. 12-13 (all listed under D3); Meuwissen 2020 abstract, p. 3 ("proportional to homozygosity and molecular coancestry", base-generation contrast), Methods ("pressure to move allele-frequencies toward 0.5", SI 1: cov < 0, F_hom < 0, F_drift > 0); Caballero & Toro 2002 p. 292 ("an infinite number of loci in the base population with all the alleles in each locus being different").
- Nejati-Javaremi formula as reproduced by Gomez-Romano p. 3: (1/4) sum_k sum_l delta_kl equals x_i x_j + (1 - x_i)(1 - x_j) at a biallelic locus (checked for the het x het case: 0.5).
- `devtools::test(filter = "metrics|lenses")` on the worktree: FAIL 0, WARN 0, SKIP 0, PASS 158. Test file assertions cited by the chapter exist at `test-metrics.R:11-40`.
- `R/00_data.R` roxygen diff and `man/molecular_coancestry.Rd` diff identical in content; ASCII; `grep` for "every diversity metric" in R/ and man/ leaves `R/15_response.R:29` (a different, true claim).
- Chapter 00 one-line change (`00:524`, adds `@sec-f-molecular`): the label exists, and the new 01 text states what 00 now points to (f not centred, its floor). No other statement of 00 depends on removed 01 wording; inbound `@sec-coancestry`, `@sec-why-not-g`, `@sec-f-molecular` references in 00, 02, 03, 04, 04b, 04c, 04g, 05, 05b, 06, 08b, 10, 92 were read; none relies on "absolute", "no arbitrary base" or "not a coincidence" (05:1560-1565 and 10:42 agree with the new text).
- All `@sec-` / `@eq-` targets added by the author (sec-hp-popgen, sec-hp-ibd, sec-hp-inbreeding, sec-ns, sec-heterosis, sec-heterosis-identity, sec-heterosis-flat, sec-simulating-crosses, sec-genomic-era, sec-subdivided, eq-hp-ibs-ibd, eq-het-value) exist in the book source.

## NOT VERIFIED
- Falconer & Mackay chapter numbers (ch. 14 at `:44`) -- no copy available. Not decisive: the algebra attached is correct.
- Eding & Meuwissen (2001): the sentence that its abstract reports a bias from alleles alike in state in the founder population rests on the iteration-1 refcheck (Crossref abstract); I did not reread it. Not decisive: Caballero & Toro 2002 p. 292, which I read, carries the same point alone.
- Primary text of Malecot (1948), Lindgren et al. (1997), VanRaden (2008), Toro et al. (2014): not reached. Definitions and formulas attributed to them (coancestry, N_s = 1/(2 theta), @eq-vanraden-g, the G_0.5 relation) are re-derived here or confirmed through Gomez-Romano and Meuwissen. Toro et al. is cited only "as cited by Meuwissen", as Meuwissen p. 3 does. None is decisive.
- Rendered output (`docs/`, `_freeze/`): stale until close, not judged; cross-reference resolution was checked on the source labels only.
