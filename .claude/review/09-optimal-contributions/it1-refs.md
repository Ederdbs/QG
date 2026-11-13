# 09-optimal-contributions -- reference check, iteration 1

Chapter: book/09-optimal-contributions.qmd (393 lines). Bib: book/references.bib.
Keys cited in the chapter (excluding @sec-/@fig-/@tbl-): kempthorne1959 (l.48), gomezromano2016 (l.82, l.322). All resolve in references.bib.
Local copy used: /Users/ederdbs/Documents/SB_quanti_gen/reference/papers/ (Gomez-Romano 2016 PDF, pdftotext). Kempthorne & Nordskog: scanned PDF from gwern.net, pdftotext.

## Metadata (Crossref, DOI resolved)
- kempthorne1959: Kempthorne & Nordskog, Restricted selection indices, Biometrics 15(1):10-19, March 1959, 10.2307/2527598. OK.
- gomezromano2016: Gomez-Romano, Villanueva, Fernandez, Woolliams, Pong-Wong, Genet Sel Evol 48:2, 2016, 10.1186/s12711-015-0172-y. OK. No retraction/correction found in Crossref (no update-to).
- comstock1949 (PENDING, existence/title only; not cited in chapter 09): Comstock, Robinson, Harvey, "A breeding procedure designed to make maximum use of both general and specific combining ability", Agron. J. 41(8):360-367, Aug 1949, 10.2134/agronj1949.00021962004100080006x. Crossref confirms title, authors, volume, issue, pages, year. Existence/title OK; content not read.

## Findings

### 09-B1  qmd:322-326 (gomezromano2016)  UNVERIFIED / imprecise  [FULL TEXT]
Chapter: predicted E(Delta f_{t+1}) is biased downward "by roughly a factor of two in their simulations with small candidate pools, shrinking as the pool grows".
Source supports: direction and N-dependence. p.11 (Discussion): "the expected value predicted with the equation was consistently biased downward and the magnitude of this bias depended on the population size (the smaller is N, the greater is the bias)". Formula E(Delta f_{t+1}) = (c'_t G_x,t c_t - f_t)/(1 - f_t) is quoted on p.7, matches the chapter.
Source does NOT give a single factor of two:
- p.8 (Fig. 2 analysis, N = 20, strategy CHR_ove, restriction 0.1 %): "the observed rate of coancestry was approximately double the intended rate" (1000 resampled offspring generations from fixed contributions).
- p.7 (Fig. 1): realised rate about 1.4 %, 0.3 %, 0.2 % for N = 20, 100, 200 against a restriction of 0.1 %, i.e. ratios of about 14, 3, 2.
So "factor of two" is true for one analysis at N = 20 and understates the Fig. 1 ratios at N = 20. Also: the paper compares realised rate against the restriction/expected, for regional (partial) genomic coancestry matrices under CHR_ove; the chapter generalises to c'Gc with a genomic G. Fix: say "up to roughly double in the resampling test at N = 20 (their Fig. 2), larger relative to the target in Fig. 1, and shrinking with N" or drop the number. Also p.11 notes the bias matters little for medium-to-large populations, which supports the chapter's "shrinking as the pool grows".

### 09-B2  qmd:327-331 (gomezromano2016)  OK with a caveat  [FULL TEXT]
Chapter's explanation (c'Gc is an expectation over Mendelian segregation; realised draw carries its own sampling variance). Paper p.8 tests exactly this (1000 offspring sets; realised coancestry always above expected), and p.11 says the equation was derived from the infinitesimal model with pedigree coancestry and that "some additional terms are arising from the Mendelian" sampling. The authors state the cause as a suggestion, not a derivation; the chapter's "The bias arises because" is slightly stronger than the source. Optional softening to "is attributed to".

### 09-B3  qmd:82-90 (gomezromano2016)  OK  [FULL TEXT]
Problem (1a)-(1d) on p.3: Minimise c'Gc subject to c's = 0.5, c'd = 0.5, c_i >= 0. Chapter reproduces it correctly, with G as the coancestry matrix. Note: paper has c_i in [0, 0.5] (contribution of a candidate to the gene pool, each sex halves) and G = A/2; the chapter's later "c_i in {0, 1/n}" is the chapter's own restriction, not the paper's. Consistent as written.

### 09-B4  qmd:48-52 (kempthorne1959)  OK  [FULL TEXT]
"posed the identical problem for selection indices -- maximise aggregate gain subject to zero expected change in a specified direction -- and solved it in closed form". p.12: breeder "wishes to maximize progress in H ... but he wishes no change in r (< m) quantities V_i = sum c_ij G_j"; index I = sum b_i P_i chosen to maximise correlation with H subject to Cov(I, V_i) = 0. Faithful. The words "identical problem" are the chapter's own framing (the callout then correctly says what is different). The closed-form is not quoted by me beyond the problem statement (pp.12-13 not read in full); page range 10-19 matches the bib.

### 09-B5  qmd:109-114 (callout "The sex constraint, in plants")  MISSING SOURCE
Claim: in hybrid maize the natural problem is optimal cross selection, c = weight per cross, with the between-pool covariance entering explicitly, plus a field limit on the number of crosses making it mixed-integer. No citation. Candidate already in bib: gorjanc2018 (Gorjanc, Gaynor, Hickey, Optimal cross selection for long-term genetic gain in two-part programs with rapid recurrent genomic selection, Theor Appl Genet 131:1953-1966, DOI 10.1007/s00122-018-3125-3, Crossref-checked). I did not read its full text, so whether it covers the "number of crosses executable in a field" restriction is UNVERIFIED. Note gorjanc2018 in bib has no `pages` field (cosmetic).

### 09-B6  qmd:120-130, 300+ (valid bound, Lagrangian, convex relaxation)  not a citation issue
Chapter states these as its own derivation (CLAUDE.md: ocs_bound is the Lagrangian bound). No literature attribution is made, so no check applies. If the author wants the standard OCS solution methods cited, gomezromano2016 p.11 lists Lagrange multipliers [Meuwissen 1997; Grundy et al.], genetic algorithms and semidefinite programming as the three families; meuwissen1997 is already in the bib (not read).

## Not checked
- Whole-book mode (uncited bib entries): not requested.
- Kempthorne closed-form solution (pp.13-14) and the book's `index_restricted()` equivalence belong to the @sec-response review, not this chapter.

## Counts
Citations checked: 2 keys, 4 attributing sentences. FULL TEXT: 4 (Gomez-Romano x3, Kempthorne x1). ABSTRACT only: 0. UNVERIFIED: 1 (B5 candidate source unread) plus B1 numeric claim not confirmable as stated. Comstock 1949: existence/title only (pending, not cited here).
