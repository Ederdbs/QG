# Response to iteration 1 -- 01-coancestry (quant-researcher)

Edited: `book/01-coancestry.qmd` (text only, no chunk touched). Earlier chapter touched: `book/00-hybrid-programme.qmd` (one cross-reference, below). Not rendered, not committed, `R/` untouched.

Checks run for this response (R, `simulate_data(book_cfg)`, N = 625, m = 2000, worktree code):
- `max|G %*% 1|` = 1.2e-13 (so `G1 = 0` and `G` is singular, as the new Gomez-Romano paragraph states).
- `G_0.5 - 4(f - J/2)` max abs diff 2.2e-16 (the new sentence "the constant removed is 1/2").
- `2(1 - mean(diag f))` = `1 - mean(fL[A, B])` = `1 - mean(F_i)` = 0.3616896 (the three-way identity now in the heterozygous-fraction paragraph).
- IBS floor `mean(p^2 + q^2)` = 0.67191, mean off-diagonal `f` = 0.67167; `status_number` over all N = 0.7442, in [1/2, 1].
- Quotations checked against the local PDFs (pdftotext): Gomez-Romano et al. 2016 pp. 12-13 ("range from -1 to x ...", "Practical experience has shown ... whole genome ...", minor-allele penalty, non-invertible centring, "natural" interpretation, "drive the gene frequency towards 0.5", "status quo"); Meuwissen et al. 2020 abstract and p. 2-3 ("proportional to homozygosity and molecular coancestry", "pressure to move allele-frequencies toward 0.5", base frequency p0 not sample frequency); Caballero & Toro 2002 p. 292 ("an infinite number of loci in the base population with all the alleles in each locus being different").

## Table

| ID | Status | What changed or evidence |
|---|---|---|
| 01-D1 | fixed | Table row `Use` for `f` now reads "coancestry-based diversity metrics". The closing paragraph says the coancestry-based metrics (`theta_group()`, `gene_diversity()`, `status_number()`) take `ctx[["f"]]`, and that the frequency-based ones (`theta_from_freq()`, `he_nei()`, `He`, `alleles_lost`, `F_hom`, `F_drift` of `freq_metrics()`) read `colMeans(ctx[["X"]][idx, ])` and `ctx[["p0"]]` and cannot be reached by an f/G switch; it points to @sec-hp-ibd (00's scope sentence). The last sentence now says metrics reading `ctx[["f"]]` without going through `theta_group()` are not covered by the test. The same false sentence in `R/00_data.R:65-66` is in the hand-off. |
| 01-D2 | fixed | "Absolute scale" removed from the callout, from the bullet and from the closing paragraph. Callout now says the reference of `G` moves with the set (centring constant estimated from it). The bullet says "no constant is estimated from the set being measured", not "no base". New paragraph "What the scale of f is" (under @sec-f-molecular): `f` is IBS, not an unbiased IBD estimate; Caballero & Toro 2002 p. 292 and Eding & Meuwissen 2001 (abstract) for the bias; under the assumptions of @eq-hp-ibs-ibd (neutral, unlinked, no mutation, base `p_b`) `E[f]` = `A/2 + (1 - A/2) * floor`, floor >= 1/2; level set by the marker panel; `f` is read as a comparison between sets on the same markers, in agreement with 00. After @eq-g05: `G_0.5 = 4(f - J/2)`, the removed 1/2 is the floor of @eq-hp-ibs-ibd at `p_b = 0.5` at every marker, a convention fixed in advance and not the panel's floor; this is why `1'G_0.5 1` does not vanish. The closing paragraph no longer calls it "the one with an absolute scale". Numbers behind the panel dependence (0.527 / 0.871 for MAF subsets, measured by the reviewer) are not typed into the text; see the hand-off for the chunk. introduction-C3 is closed by this. |
| 01-D3 | fixed | (a) Gomez-Romano rewritten as a report: range statement with its whole-genome qualification quoted, the minor-allele and non-invertibility objections, "natural" interpretation, "should hold", and the closing remark that allelic similarity "would favour solutions that tend to drive the gene frequency towards 0.5" while cross-product "will favour the status quo" and the choice depends on the objective. "Guaranteed by construction" is now labelled the book's own inference from @eq-f-molecular. "Current allele frequencies" removed. The zero total is no longer presented as the paper's range violation: the chapter derives `G1 = Z(Z'1)/den = 0`, so `G` is singular, which is the non-invertibility the authors name. (b) Meuwissen: "base-generation frequency p0,k" replaces "sample frequency"; the paper gives no formula, the affine map is the chapter's own; new paragraph "A limit of constraining this matrix" quotes the abstract and Methods on the pull toward 0.5, says the constraint on `theta_S` pins the homozygosity lens only and not `F_drift`, and points to @sec-hp-ibd and @sec-genomic-era; it says the consequence for the book's selections is measured elsewhere, not here. "Not a coincidence" deleted; the closing claim is "consistency between two published treatments and this chapter's algebra, not a proof that f is the right matrix to constrain". |
| 01-M1 | fixed | New opening paragraph: @sec-hp-popgen has defined IBD/IBS, coancestry, `s_i`, `F_i`, `GD_S = 1 - theta_S`; it points here for @eq-x-freq, @eq-hybrid-dosage, @eq-f-molecular; this chapter supplies the computation and the contrast; A2 and biallelic markers declared. Closes introduction-C2. |
| 01-M2 | fixed | Group coancestry now points to @sec-hp-ibd (Cockerham citation left to 00); Malecot sentence now says "identical by descent relative to a base population (@sec-hp-ibd)"; the `s_i`/`F_i` bullet cross-references @sec-hp-ibd and @sec-hp-inbreeding and keeps only what this chapter adds (homozygous fraction, checked in the chunk); `F_hom` now points to @sec-hp-inbreeding, not forward to @sec-genomic-era. Closes 00-C25 for this chapter. |
| 01-M3 | fixed | (a) referent: the paragraph now begins from the printed `heterozygous_fraction`, `2(1 - s_bar) = 1 - F_bar`; (b) the neutral Balding-Nichols condition is in the same sentence as the claim; (c) "expectation" replaced by "identity of the realised factorial" with `F_(ab) = f^L_ab` (@sec-hp-inbreeding), `f^L` pointed to, not introduced; (d) the one-line derivation is given: given `p_0k`, the pools' frequencies are independent with mean `p_0k`, so P(het) = `2 p_0k q_0k` whatever `F_BN`; sources cited as consistent, nothing claimed for non-neutral divergence. The 0.3616896 equality was checked by me; the assertion in the chunk is in the hand-off. |
| 01-M4 | fixed (prose), code -> quant-Rwrite | "Depends on n/N" replaced by "n(N-n)/(N-1) is not a function of n/N alone". The `stopifnot` is in the hand-off. |
| 01-M5 | fixed (prose), code -> quant-Rwrite | The sentence before the chunk now says `vanraden_G()` takes the 0/1/2 matrix `M^H`, not the 0/0.5/1 `X` of `molecular_coancestry()`, and returns a list `G, Z, p`. Chunk change in the hand-off. |
| 01-M6 | prose unchanged (true), assertion -> quant-Rwrite | The prose says "above 0.5 for the book data" for the minimum of `f` and "every f_ij exceeds 0.5"; both hold (min f 0.64475). The `stopifnot` is in the hand-off. |
| 01-M7 | fixed | "Most consequential mistake" and "the number is meaningless" removed. Replacement: the failure is silent, and for the whole population the number is not a coancestry. The subset-sum paragraph now says it is a well-defined distance (n^2 times the scaled squared distance of the subset mean of centred genotypes from the population centroid) that is not a coancestry of the subset, consistent with the chapter's own subset-sum argument. |
| 01-M8 | fixed | After the `theta_on_G` chunk text: on `f`, `theta_S` in [1/2, 1] at biallelic loci, so `N_s` in [1/2, 1] for every set, a monotone rescaling, not a head count (@sec-ns). No number typed (0.7442 is in the hand-off as a chunk to add). |
| 01-M9 | fixed | "Between-pool term" and "shared term" replaced by `GD_BS` and `GD_T`, with @sec-hp-popgen and @sec-heterosis-identity. |
| 01-M10 | fixed (prose), chunk names -> quant-Rwrite | Prose now uses `theta_S`, `N_s = 1/(2 theta_S)`. The chunk vector names `theta_on_G`, `Ns_on_G` still print the bare symbol; renaming is in the hand-off. |
| 01-M11 | fixed | "Instead of the base-generation frequency p0,k" (Meuwissen et al. 2020, p. 3). |
| 01-M12 | fixed | Paragraph "What the scale of f is" (see D2): IBS not IBD, Caballero & Toro 2002 p. 292, Eding & Meuwissen 2001 abstract, pointer to @eq-hp-ibs-ibd. The Eding & Meuwissen citation is moved there from the definition sentence, where it was cited for the raw IBS formula it does not give (01-B3). |
| 01-M13 | contested (terminology) / fixed (rest) | Terminology: the book names `d_k` "dominance deviation" in `90-notation.qmd:210,515`, `05b-heterosis-dominance.qmd:141,235,1181`, and defines it at `05b:108-110` as "the departure of the heterozygote from the homozygote midpoint"; changing 01 alone would split the book from its own notation table. 01 now carries that definition and points to @eq-het-value, so `d_k` is defined at first use. "Is not a coincidence" deleted (see D3). Falconer & Mackay chapter number (ch. 14) stays as cited and remains UNVERIFIED, as does ch. 5 (now dropped from this chapter; 00 carries it). |
| 01-R9 | Info -> quant-Rwrite | tolerance 1e-12; see hand-off. |
| 01-R10, 01-B5 | not verified | No copy of Falconer & Mackay; primaries of Cockerham, Malecot, Lindgren, Nejati-Javaremi, VanRaden, Toro, Eding & Meuwissen not reached. In this chapter the Cockerham and Falconer ch. 5 citations were removed (definitions live in 00); Nejati-Javaremi's formula is attributed through Gomez-Romano p. 3 ("as reproduced by"). |
| 01-R11, 01-R12 | out of scope | per verdict |
| 01-C7 | owed -> 06 | `06:13-14` "every one operates on the molecular coancestry matrix" (same overstatement as D1; 00:463-465, `R/01_metrics.R:212-226`) and `06:157-158` "Molecular f has no base" (against the base-frequency floor, 00:465-475, and 01's new paragraph). The wording of 01 is true without it. |
| 01-C8 | owed -> 04 | `04:808-809` cites @sec-coancestry for `GD = 1 - theta`; 01 does not write `GD`; cite @eq-hp-gd / @sec-identity. (01 now names `GD_S = 1 - theta_S` in its opening, as 00's, so the citation is closer to true, but the definition is not in 01.) |
| 01-C11 | owed -> 08b | `08b:19` quotation "is the right matrix for GBLUP." is not in 01 or in the roxygen; reword as paraphrase. 01 still says "the right matrix for genomic best linear unbiased prediction (GBLUP)". |
| 01-C12 | owed -> 02 | `02:5-14` does not cite 01 or say it follows from it. 01's hand-over sentence ("takes f and asks ... several") is true of 02's content. |
| 01-C13 | owed -> 04c (and 90 row) | `x_ik` in {0,1,2} at `04c:318-322` and `90:547-550` against {0, 0.5, 1} of @eq-x-freq. 01 is unaffected. |

Counts: fixed 11 (D1, D2, D3, M1, M2, M3, M7, M8, M9, M11, M12); fixed in prose with code handed to quant-Rwrite 4 (M4, M5, M6 [assertion only], M10); contested 1 (M13, terminology only); owed 5 (C7 -> 06, C8 -> 04, C11 -> 08b, C12 -> 02, C13 -> 04c); not verified 2 (R10, B5); out of scope 2 (R11, R12); Info handed off 1 (R9).

## Earlier chapter changed

`book/00-hybrid-programme.qmd`, one line (the tail of the paragraph ending the IBS/IBD result, former line 523-524):

```
-centred to make that floor vanish (@sec-why-not-g). The agreement is a Monte
+centred to make that floor vanish (@sec-why-not-g, @sec-f-molecular). The agreement is a Monte
```

Reason: @sec-why-not-g only shows that centring on the sample frequencies fails; the statement that `f` itself is not centred, and what its floor is, now sits in @sec-f-molecular (introduction-C3, continuity 01-C2(c)). `index.qmd` not touched.

## Hand-off to quant-Rwrite (chunks and R/; I changed none)

Prose now depends on these; each is a claim the text makes that no chunk yet asserts.

1. 01-M4/R3, chunk `S_sum` (line ~140): add for fixed n = 100, 20000 draws, `set.seed(11)`: `stopifnot(abs(mean(S100) - n * (N - n) / (N - 1) * mean(diag(G))) < 4 * sd(S100) / sqrt(length(S100)))` (reviewer's run: 75.713, s.e. 0.107, formula 75.519), or assert the exact algebraic form.
2. 01-M5/R4, chunk `args(vanraden_G)`: optionally print `names(vanraden_G(2 * ctx[["X"]]))` after `ctx` is defined (the chunk currently sits before `ctx` is used for G; the prose now states coding and return type, so this is optional).
3. 01-M6/R5, chunk `G05`: `stopifnot(min(f) > 0.5, all(abs(G05) <= 2))`.
4. 01-R9: `tolerance = 1e-12` on the exact identities (measured 7.8e-16, 0, 2.2e-16, 1.1e-16).
5. 01-M3/R8c, chunk after `fd`: `stopifnot(isTRUE(all.equal(2 * (1 - fd), 1 - mean(ctx[["fL"]][ctx[["pool"]] == "A", ctx[["pool"]] == "B"]), tolerance = 1e-12)), isTRUE(all.equal(2 * (1 - fd), 1 - mean(F_i), tolerance = 1e-12)))` (checked by me: 0.3616896 for the three).
6. New claim in "What the scale of f is" (level set by the panel, floor >= 1/2): add a short chunk after the `f` summary chunk: `p <- colMeans(X); floor_p <- mean(p^2 + (1 - p)^2); stopifnot(floor_p >= 0.5, min(f) > 0.5)`, and print `c(floor = floor_p, offdiag_mean = mean(f[upper.tri(f)]))` (mine: 0.67191 and 0.67167), and `molecular_coancestry(X[, maf > 0.3])` and `X[, maf < 0.15]` offdiagonal means (reviewer's: 0.527, 0.871; I did not rerun those two). Needs a `set.seed` only if a subset is drawn; none is.
7. 01-M8: chunk printing `status_number(seq_len(N), ctx)` with `stopifnot(Ns >= 0.5, Ns <= 1)` (mine 0.7442).
8. 01-M10: rename chunk vector names `theta_on_G` -> `theta_S_on_G`; the prose still mentions `theta_on_G` ("`theta_on_G` below"), change both together.
9. `R/00_data.R:65-66` roxygen: replace "the matrix every diversity metric in this package operates on" by "the matrix the coancestry-based diversity metrics (`theta_group()` and those built on it) operate on; the frequency-based metrics read `colMeans(X[idx, ])` and `p0`"; then `devtools::document()` (regenerates `man/molecular_coancestry.Rd`), `devtools::install()` before any render. Also `R/01_metrics.R` docs: check that no other roxygen says "every diversity metric".
10. After any chunk edit: `Rscript book/scripts/make_downloads.R`. The chapter has no cached data or figures; `_freeze/01-coancestry` will be invalidated by the prose edits and must be regenerated by a render (HTML and Typst), which I did not run.

## Left open

- Falconer & Mackay chapter numbers (ch. 14 at the heterosis sentence) and the primaries listed under 01-B5 remain unverified; cited as before, no new claim rests on them.
- The panel-dependence numbers of D2 (0.527 / 0.871) are the reviewer's, not reproduced by me; the text does not state them.
- The consequence of the pull toward 0.5 for this book's selections is stated as measured elsewhere (@sec-genomic-era); I did not check that those chapters measure it for the DE selections, only that @sec-genomic-era treats the pull (`05-genomic-era.qmd:195, 518-556, 927`).

## quant-Rwrite rows (code and chunks; hand-off items 1-10)

R/ changed: `R/00_data.R:62-65` roxygen only (`man/molecular_coancestry.Rd` regenerated). Verified after the edit: `devtools::document()` clean, `devtools::test()` FAIL 0 | WARN 0 | SKIP 0 | PASS 492, `devtools::install()` done. All chapter chunks purled and sourced from `book/` against the installed worktree package: every `stopifnot` holds, no Error, no `book/Rplots.pdf`. Numbers printed equal the numbers in the prose (no number is typed in the prose; `range(G05)` 0.579-1.327 is positive as stated, `min f` 0.64475 > 0.5). No new chunk reads a cached file; no inline scientific-notation value exists (no `fmt_sci()` case). New chunks carry explicit labels (`ns-on-f`, `panel-floor`).

| ID | Status | What changed or evidence |
|---|---|---|
| H1 (01-M4/R3) subset-sum | fixed | Chunk `S_sum`: n = 100, 20000 draws, `set.seed(11)`: MC 75.7129, formula 75.5192, s.e. 0.1065 (1.8 s.e., asserted `< 4 * se`); over 20 seeds x 5000 draws z in [-1.26, 2.36], all |z| < 4. Plus the exact form `n*mean(diag G) + n(n-1)(sum(G) - tr G)/(N(N-1))` asserted `all.equal(..., tolerance = 1e-12)`: measured relative deviation 1.4e-14. |
| H2 (01-M5/R4) `vanraden_G` | contested as unnecessary | Item was marked optional. The prose before `args(vanraden_G)` now states 0/1/2 input and list return; the chunk is unchanged. |
| H3 (01-M6/R5) | fixed | Chunk `G05`: `stopifnot(min(f) > 0.5, all(abs(G05) <= 2), ...)`. Measured min f 0.64475, max abs(G05) 1.327. |
| H4 (01-R9) tolerances | fixed | `tolerance = 1e-12` on the five exact `all.equal` calls (f vs literal 5 x 5, f vs `tcrossprod(cbind(X, 1 - X))/m`, `diag(f)` vs `(1 + F_i)/2`, `G05` vs `4f - 2`, quadratic form). Measured deviations: 4.4e-16, 0, 1.1e-16, 2.2e-16 (absolute). |
| H5 (01-M3/R8c) heterozygous fraction | fixed | Chunk after `F_i`: `2(1 - fd)` equals `1 - mean(F_i)` (deviation 0) and `1 - mean(fL[A, B])` (0), both `tolerance = 1e-12`; both print 0.3616896. |
| H6 (01-D2) panel floor | fixed | New chunk `panel-floor` plus a short lead-in paragraph with no typed number. Found an exact identity: the sum of `f` over all N^2 pairs at marker k is N^2 (p_k^2 + q_k^2), so `mean(f) == mean(p^2 + q^2)` (measured 1.1e-16, asserted at 1e-12) and offdiag mean = (N^2 floor - N diag mean)/(N(N-1)) (1.1e-16). Printed: floor 0.6719, off-diagonal 0.6717, MAF > 0.3 subset 0.5271, MAF < 0.15 subset 0.8710 (the reviewer's 0.527 / 0.871 reproduced). Asserts floor >= 0.5, min f > 0.5. |
| H7 (01-M8) N_s | fixed | Chunk `ns-on-f` (`set.seed(3)`): whole population 0.7442, 1000 random subsets of size 2..N in [0.6943, 0.7445]; asserted in [1/2, 1]. |
| H8 (01-M10) rename | fixed | Chunk vector name and the prose mention both now `theta_S_on_G`; `Ns_on_G` and the downloaded script updated; no remaining `theta_on_G` in `book/`. |
| H9 roxygen `R/00_data.R` | fixed | Now: "the matrix the coancestry-based diversity metrics (`theta_group()` and those built on it) operate on; the frequency-based metrics read `colMeans(X[idx, ])` and `p0` instead." ASCII. `grep` for "every diversity metric" leaves only `R/15_response.R:29`, which is a different claim (linkage disequilibrium) and is true; not changed. |
| H10 downloads | fixed | `Rscript book/scripts/make_downloads.R` rerun (`book/downloads/01-coancestry.R` and, from the earlier edit, `00-hybrid-programme.R` changed). The render and `_freeze` regeneration are not done, as instructed. |
| 01-D1 (R side) | fixed | The `R/00_data.R` half of the same false claim is now corrected (H9). |
