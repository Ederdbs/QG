# Verdict -- 01-coancestry, iteration 1

VERDICT: REJECTED

Chapter: `book/01-coancestry.qmd` (339 lines). Read in full, with the three reports, THREAD.md (entry 00 and its Owed items naming 01) and part-introduction.md.
Reports consumed: it1-audit.md (R), it1-refs.md (B), it1-continuity.md (C). Where a report says something I did not check myself it is marked as taken from the report.

Counts: disqualifying 3 (2 High, 1 Medium); non-disqualifying 13 (4 Medium, 9 Low). Three or more non-disqualifying failures also reject on their own.

## PREVIOUS IDS
Not applicable (iteration 1). Disposition of the incoming findings is in the next section.

## DISPOSITION OF THE INCOMING FINDINGS

| ID | Decision | Where it lands |
|---|---|---|
| 01-R1 | ACCEPT, raised M -> disqualifying | 01-D1 |
| 01-R2 | ACCEPT, raised M -> disqualifying | 01-D2 |
| 01-R3 | ACCEPT (L) | 01-M4 |
| 01-R4 | ACCEPT (L) | 01-M5 |
| 01-R5 | ACCEPT (L) | 01-M6 |
| 01-R6 | ACCEPT (L), same as 01-C4 | 01-M2 |
| 01-R7 | ACCEPT (L), same as 01-C3, raised to M | 01-M1 |
| 01-R8 | ACCEPT (L), (a)(b)(c) all stand; same as 01-C5 | 01-M3 |
| 01-R9 | ACCEPT as Info (tolerance 1.5e-8 for exact identities); I measured max abs diff 2.2e-16 (G05 vs 4f-2) and 0 (f vs literal sum) | recorded, no action required for the verdict |
| 01-R10 | NOT DECIDED: Falconer & Mackay chapter numbers, UNVERIFIED (I have no copy). Not decisive: the algebra cited is correct | NOT VERIFIED |
| 01-R11 | OUT OF SCOPE (form, book-wide 00-E1, Typst) | none |
| 01-R12 | OUT OF SCOPE (boilerplate footer from make_downloads.R) | none |
| 01-B1 | ACCEPT, raised MEDIUM -> disqualifying | 01-D3 |
| 01-B2 | ACCEPT (LOW) | 01-M11 |
| 01-B3 | ACCEPT (LOW to MEDIUM); the IBS-is-not-IBD caveat is carried by 00 (eq-hp-ibs-ibd) and 01 neither states it nor points to it; ties into 01-D2 | 01-M12 and 01-D2 |
| 01-B4 | ACCEPT (LOW), terminology "dominance deviation" vs "dominance effect"; sourcing UNVERIFIED | 01-M13 |
| 01-B5 | ACCEPT as UNVERIFIED primaries; none decisive for the argument (Cockerham, Malecot, Lindgren, Falconer carry definitions that 00 uses and that I re-derived; the Nejati-Javaremi formula is confirmed through Gomez-Romano p. 3, which I read) | NOT VERIFIED |
| 01-B6 | ACCEPT (LOW), and I add that the chapter's own subset-sum paragraph treats the G-based subset quantity as a well-defined distance from the centroid, so "the number is meaningless" (line 11-12) is rhetoric, not a result | 01-M7 |
| 01-C1 | ACCEPT (H) | 01-D1 |
| 01-C2 | ACCEPT (M), raised to disqualifying; this is introduction-C3 | 01-D2 |
| 01-C3 | ACCEPT (M); this is introduction-C2 | 01-M1 |
| 01-C4 | ACCEPT (M); this is 00-C25 | 01-M2 |
| 01-C5 | ACCEPT (M) | 01-M3 |
| 01-C6 | ACCEPT (L) | 01-M9 |
| 01-C7 | Owner 06, not 01; no action on this chapter | none |
| 01-C8 | Owner 04; no action on this chapter | none |
| 01-C9 | ACCEPT (L) | 01-M10 |
| 01-C10 | ACCEPT, raised L -> M | 01-M8 |
| 01-C11 | Owner 08b; no action on this chapter | none |
| 01-C12 | Owner 02; no action on this chapter | none |
| 01-C13 | Owner 04c; no action on this chapter | none |

## DISQUALIFYING FAILURES

- **01-D1 [criteria 1, 5; open H from continuity] `book/01-coancestry.qmd:320-321` and `:314` (table row "Use: every diversity quantity")** -- "every diversity metric takes `ctx[["f"]]`" and the table row for `f` are false. `freq_metrics()` (`R/01_metrics.R:212-226`) computes `He`, `alleles_lost`, `F_hom` and `F_drift` from `colMeans(ctx$X[idx, ])` and `ctx$p0`, with no `f`; `theta_from_freq()` and `he_nei()` do the same, and `tests/testthat/test-metrics.R:6` uses `theta_from_freq` as the independent oracle of `f`, which only works because it does not read `f`. Chapter 00 (approved, `00:463-465`) says the coancestry-based metrics are computed on `f` and "frequency-based metrics such as $F_{drift}$ are not". The chapter then concedes (`:328-329`) that there are metrics which do not read `f`, so it contradicts itself within one paragraph. This is 00-C26 and 01-R1/01-C1, still open, unchanged. The same wording sits in `R/00_data.R:65-66` (outside this chapter, same defect).

- **01-D2 [criteria 1, 2, 5] `:141-144` (callout), `:172` (bullet), `:295-298` (closing paragraph of the G_0.5 section); introduction-C3 and 01-R2/01-C2** -- "Diversity requires an *absolute* scale", "no arbitrary base population" and "the one with an absolute scale" are wrong as written and mutually inconsistent. (i) `f` is an identity-in-state quantity whose level is set by the marker panel: it is Malecot coancestry with every non-IBD pair compared with independent draws at the panel frequencies. I recomputed it on the chapter's own hybrids (`simulate_data(book_cfg)`, N = 625, m = 2000): mean off-diagonal `f` is 0.67167 on all 2000 markers, equal to the IBS floor `mean(p^2 + q^2)` = 0.67191 and not 0; on the 771 markers with MAF > 0.3 it is 0.52706; on the 611 markers with MAF < 0.15 it is 0.87095. A scale that moves from 0.53 to 0.87 with the panel, for the same hybrids, is not absolute, and the implicit base (panel frequencies, no mutation, neutral unlinked loci) is an assumption in use that the chapter does not declare. Chapter 00 (`00:465-475`, `00:514-524`, @eq-hp-ibs-ibd) states exactly this and concludes that `f` is "read as a comparison between sets measured on the same markers"; 01 then says the opposite, and `00:522-524` cites `@sec-why-not-g` for a point that 01 does not establish (01 proves only that centring on the *sample* frequencies fails). (ii) Inside the chapter, `G_0.5 = 4f - 2J` (@eq-g05, `:272`) is centring at a fixed base p_k = 0.5, which the text itself calls "fixed-base" at `:296`, against "no arbitrary base population" at `:172` and "absolute" at `:296`. The link between the floor of 00 and the `2J` of @eq-g05 is never drawn. The valid statement (no centring constant estimated from the data being measured, hence no `1'G1 = 0` collapse) is never made in the place of the overclaim. Closes introduction-C3 only when the sense of "absolute" is stated and the chapter agrees with 00.

- **01-D3 [criteria 7, 6] `:251-260` (Gomez-Romano 2016) and `:262-266, 295-298` (Meuwissen 2020; the "not a coincidence" conclusion)** -- the two sources are marshalled to certify `f` as "not an ad hoc substitute" and "the one that does not break", and each source's reservation about exactly this matrix is dropped. I read both papers (pdftotext of the local PDFs).
  (a) Gomez-Romano et al. (2016), discussion, p. 12-13: the range problem is stated for relationships "calculated with these methods" ("range from -1 to x ... can be clearly outside the valid range for a coefficient of coancestry"), and the very next sentence reads "Practical experience has shown that estimates of the average coancestry across the whole genome tend to be within the valid range but this may not be the case when considering a smaller region with few genotyped SNPs". The chapter says "Their failure is a range violation (entries below 0 or above 1)", drops the whole-genome qualification (the chapter's own matrix is whole-genome) and adds "normalised by *current* allele frequencies", which is not in the paper. The paper's other two objections (rare-allele penalisation; non-invertibility from centring) are not mentioned, and the second is the one that bears on the chapter's own point. "Guaranteed ... by construction" is the author's inference, not the paper's wording (the paper says "natural interpretation" and that positive definiteness "should hold"). The same paper closes the comparison by saying that optimising with the allelic-similarity matrix "would favour solutions that tend to drive the gene frequency towards 0.5" whereas the cross-product matrix "will favour the status quo", and that the choice depends on the objective.
  (b) Meuwissen et al. (2020), p. 3: the quotation "proportional to homozygosity and molecular coancestry" is verbatim and Toro et al. (2014) is cited, as the chapter says. But the paper contrasts p = 0.5 with the *base-generation* frequency p0, not with "the sample frequency" (chapter, `:263-265`); and the same paper states (Methods, around Eq. 2-3 and Supplementary Information 1) that using G_0.5 in optimal contributions "will be pressure to move allele-frequencies toward 0.5", with covariance of the allele-frequency change and p0 negative, F_hom < 0 and F_drift > 0. That is the known limit of constraining the very matrix this chapter equates with `f` (the two lenses of `CLAUDE.md`; chapter 00 handles F_drift versus coancestry in `00:463-465`). Chapter 01 recommends `f` for the book, concludes that it "happens to be the one that does not break ... not a coincidence", and never mentions the limit or points to where it is treated.
  The affine algebra of @eq-g05 is correct (I verified it), and that is the part of the section that is the author's own; the attribution around it is what fails.

## NON-DISQUALIFYING OBSERVATIONS

Medium:
- **01-M1** `:8-15` -- the opening does not say why the chapter follows 00 or that 00 has already defined IBD/IBS, coancestry, $s_i$, $F_i$ and $GD_S$; the only link is `@sec-hp-cycle` at `:25`. `:14-15` ("derives the matrix used for the rest of the book") leaves out that 00 introduces it conceptually. (01-R7, 01-C3, introduction-C2.)
- **01-M2** `:92-94`, `:149-150`, `:166-171` -- group coancestry (Cockerham), Malecot coancestry, $s_i = (1+F_i)/2$ and molecular $F_i$ are restated from 00 (`00:457-460`, `00:527-545`) instead of cross-referenced; `:170-171` points forward to `@sec-genomic-era` for $F_{hom}$ that `@sec-hp-inbreeding` defines earlier. (01-R6, 01-C4, 00-C25.)
- **01-M3** `:236-243` -- (a) "This fraction" has two possible referents (the homozygous fraction of `:221-225`, whose expectation is the mean line coancestry and not one minus it, or the printed `heterozygous_fraction`, for which the sentence is true); (b) the first sentence is unconditional, the neutral-divergence condition arrives only in the second; (c) "expectation over the A x B factorial" is on a realised factorial an exact mean (`2*(1 - mean(diag(f)))` = 0.3616896 and `1 - mean(fL[A, B])` = 0.3616896, both recomputed by me), and `f^L` is not introduced here; (d) the support is only forward-cited (05b, 03), with no derivation (under Balding-Nichols the expectation is $2p_0 q_0$ per locus whatever $F_{BN}$) and no assertion in this chunk. (01-R8, 01-C5.)
- **01-M8** `:98-99` -- $N_s = 1/(2\theta)$ is introduced and shown to diverge on $\mathbf G$ but its value on the correct matrix is never given; on the chapter's data $\theta$ over the whole population is 0.6719 and $N_s$ = 0.744 (my run), and at biallelic loci $N_s \in [1/2, 1]$ on molecular `f` (06, `@sec-ns`; 00:701-707). No pointer to `@sec-ns`. The reader leaves with $N_s$ as a head count that "diverges" on the wrong matrix. (01-C10, raised.)

Low:
- **01-M4** `:121-125`, `:129-136` -- the subset-sum expectation $n\frac{N-n}{N-1}\overline{G}_{ii}$ is asserted in prose and the chunk checks only non-negativity (which cannot fail from round-off). The formula is correct (derivation: mean off-diagonal $= -\overline{G}_{ii}/(N-1)$ from $\mathbf 1'\mathbf G\mathbf 1 = 0$); my Monte Carlo, n = 100, 20000 draws, seed 11: 75.713 (s.e. 0.107) against 75.519. The sentence "depends on $n/N$" is also loose: $n(N-n)/(N-1)$ is not a function of $n/N$ alone. (01-R3.)
- **01-M5** `:76-78` -- `args(vanraden_G)` prints `function (M) NULL`; it hides that `vanraden_G()` takes the 0/1/2 matrix $\mathbf M^H$ (while `molecular_coancestry()` takes 0/0.5/1) and returns a list. The coding trap is the chapter's own subject and is never stated at the call. (01-R4.)
- **01-M6** `:277-278` -- "every $f_{ij}$ exceeds 0.5" and the printed range of `G05` are data-dependent and not asserted (true here: min f 0.64475; `range(G05)` 0.579-1.327). (01-R5.)
- **01-M7** `:8-12` -- "the most consequential mistake available in this subject" is uncited opinion; "the number is meaningless" is contradicted by the chapter's own reading of the subset sum as a distance from the population centroid. (01-B6.)
- **01-M9** `:239-241` -- "between-pool term of diversity" and "shared term" for what 00 writes $GD_{BS}$ and $GD_T$; neither symbol is used. (01-C6.)
- **01-M10** `:93-98`, chunk names `theta_on_G`, `Ns_on_G` -- bare $\theta$ where 00 and `90-notation` write $\theta_S$. (01-C9.)
- **01-M11** `:263-265` -- "instead of the sample frequency" should be the base-population frequency in the source. (01-B2.)
- **01-M12** `:149-153`, `:172` -- the chapter never says that $f$ is IBS and not an unbiased estimate of IBD coancestry (Caballero & Toro 2002, p. 292: equal to the pedigree value only with infinitely many equifrequent-distinct base alleles; Eding & Meuwissen 2001: bias from alleles alike in state in the founders), nor points to @eq-hp-ibs-ibd in 00. (01-B3; part of the remedy for 01-D2.)
- **01-M13** `:34-36` -- "dominance deviations $d_k$" for what Falconer calls the dominance effect; check against 05b's naming. Sourcing to Falconer ch. 14 UNVERIFIED. The statement itself (F1 minus mid-parent = $\sum d_k$ over loci where the parents differ, no epistasis) is correct. Also `:297-298` "is not a coincidence" is an interpretation stated as a finding (criterion 4, not rejecting alone). (01-B4.)

Info (no action required for the verdict): the `all.equal` default tolerance is used for identities that hold to 1e-16 (01-R9); Falconer chapter numbers differ across chapters (01-R10, unverified); PDF cross-reference full stop and footer wording are out of scope (01-R11, 01-R12).

## OWED ITEMS NAMING 01 (THREAD.md, part-introduction.md)

| Item | Status after this iteration |
|---|---|
| 00-C26 (`every diversity metric takes ctx[["f"]]`) | OPEN -> 01-D1 |
| 00-C25 (restated definitions) | OPEN -> 01-M2 |
| introduction-C2 (opening does not say why it follows 00) | OPEN -> 01-M1 |
| introduction-C3 ("absolute"/"no arbitrary base" vs the base-frequency floor) | OPEN -> 01-D2 |

## OPEN ITEMS WITHOUT WHICH THE CHAPTER CANNOT BE APPROVED
1. 01-D1 (scope of "every diversity metric" and the table row).
2. 01-D2 (sense of "absolute scale" and "no base"; agreement with 00's floor; the 4f - 2J centring named as a base).
3. 01-D3 (Gomez-Romano and Meuwissen attributions; the G_0.5 pull toward 0.5 omitted as a limit).
The Medium items 01-M1, 01-M2, 01-M3 and 01-M8 are owed items or definition-level and should be closed in the same pass; with 13 non-disqualifying observations the chapter would not pass on that count either.

## WHAT WAS VERIFIED
(all by me, `pkgload::load_all` on the worktree, `simulate_data(book_cfg)`, N = 625, m = 2000, script in the session scratchpad)
- `sum(G)` = -4.178879e-11 (round-off zero; $1'G1 = 0$ up to 1e-11).
- `G05 = tcrossprod(2X - 1)/(m/2)` against `4f - 2`: max abs difference 2.2e-16; range of off-diagonal `f` 0.64475-0.76025, so all $f_{ij} > 0.5$ here.
- `f` against the literal expression `(XX' + (1-X)(1-X)')/m` on all 625 x 625 entries: max abs difference 0.
- Subset-sum expectation: Monte Carlo n = 100, 20000 draws, seed 11: mean 75.71293, s.e. 0.10653, formula 75.51921 (1.8 s.e.); algebra derived (mean off-diagonal = -mean diagonal/(N-1)).
- Panel dependence of `f`: mean off-diagonal 0.67167 (2000 markers), 0.52706 (771 markers, MAF > 0.3), 0.87095 (611 markers, MAF < 0.15); IBS floor `mean(p^2 + q^2)` = 0.67191.
- `2*(1 - mean(diag(f)))` = 0.3616896 = `1 - mean(fL[A, B])`; whole-population $\theta$ = 0.6719, $N_s$ = 0.7442.
- `R/01_metrics.R:212-226`: `freq_metrics()` reads `colMeans(ctx$X[idx, ])` and `ctx$p0`, no `f`; `tests/testthat/test-metrics.R:3-40` contains the assertions the chapter describes at `:322-329`.
- Gomez-Romano et al. (2016) p. 12-13 and Meuwissen et al. (2020) p. 3 and Supplementary-Information passage (pdftotext of the local PDFs): the passages quoted in 01-D3.
- Algebra of @eq-hybrid-dosage, @eq-f-matrix, @eq-g05 (and the order-equivalence under $\mathbf 1'\mathbf c = 1$), @eq-g-sum-zero and the diagonal $s_i = (1 + F_i)/2$: correct as written.
- Taken from the reports, not rerun by me: the 12 chunks render on worktree code with every `stopifnot` passing and outputs equal to the frozen ones (audit); the 8 DOIs match Crossref (refcheck); cross-reference targets resolve (continuity, refcheck); inbound `@sec-` counts.

## NOT VERIFIED
- Falconer & Mackay chapter numbers (ch. 14 at `:36`, ch. 5 at `:168`) against `05:177-178` ("Ch. 3"): no copy available (01-R10). Not decisive.
- Primary text of Cockerham (1967), Malecot (1948), Lindgren et al. (1997), Nejati-Javaremi et al. (1997), VanRaden (2008), Toro et al. (2014), Eding & Meuwissen (2001): refcheck reached abstracts or secondary full text only; the definitions they carry are used by chapter 00 as well and I re-derived their algebra, so none is decisive here.
