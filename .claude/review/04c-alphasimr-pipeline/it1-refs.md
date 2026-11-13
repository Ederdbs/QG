# 04c-alphasimr-pipeline -- references, iteration 1

Chapter: book/04c-alphasimr-pipeline.qmd. Bib: book/references.bib.
Local copies sought in /Users/ederdbs/Documents/SB_quanti_gen/reference (the worktree has none).

## Findings

- 04c-B1 | 04c:23, 04c:916 and bib `comstock1949` | PENDING (known item, no copy; its content was not searched).
  Bib metadata checked against Crossref and correct: Comstock, Robinson, Harvey, Agron. J. 41(8):360-367, 1949,
  DOI 10.2134/agronj1949.00021962004100080006x resolves to that paper.
  Attributions awaiting a copy: (a) RRS is the scheme that improves the two pools (l.23);
  (b) "built on using the opposite pool as the tester so that selection captures both" GCA and SCA (l.916).
  Both are UNVERIFIED.

- 04c-B2 | 04c:49, 04c:914 and bib `sprague1942` | UNVERIFIED (attribution).
  Metadata correct (Crossref): Sprague & Tatum, J. Am. Soc. Agron. 34(10):923-932, 1942, DOI resolves.
  Text attributes the GCA definition ("average performance of its crosses expressed as a deviation from the mean of all crosses")
  and SCA to this paper. Wiley full text returned 403 (doi.org -> acsess.onlinelibrary.wiley.com), no local copy, no PMC.
  Only the 1942 reference to the GCA/SCA concept is in doubt; it is the standard origin, but not read.

- 04c-B3 | 04c:330, 497, 508, 649, 712 and bib `falconer1996` | UNVERIFIED (chapter numbers).
  Book entry is correct (Falconer & Mackay, Introduction to Quantitative Genetics, 4th ed., Longman, 1996).
  The text cites ch. 7 (additive effect a, d, midpoint scale; single-locus mean; alpha), ch. 8 (2pq alpha^2) and
  ch. 14 (F1 heterosis = sum d y^2; F2 keeps half the F1 heterosis). No copy in reference/; a web search did not return
  the table of contents. The chapter numbers rest on my memory of the 4th edition (7 Values and Means, 8 Variance,
  14 Inbreeding and Crossbreeding) and are NOT VERIFIED. The text already says explicitly that no equation number is attributed, which is the correct caution.

- 04c-B4 | 04c:355-356, 1140 and bib `hallauer2010` | UNVERIFIED (attribution).
  Metadata OK (Springer, Handbook of Plant Breeding vol. 6, 3rd ed., 2010, DOI 10.1007/978-1-4419-0766-0 resolves to
  "Quantitative Genetics in Maize Breeding"; Crossref lists Carena first, the bib order Hallauer, Carena, Miranda Filho follows the title page: no finding).
  Claims: "maize grain yield shows large inbreeding depression" and "[Hallauer] is the reference on the choice of tester". No copy. Not read.
  The first claim is generic and the book is a suitable primary source; propose adding a page or chapter to make it checkable.

- 04c-B5 | 04c:1242 and bib `kempthorne1959` | UNVERIFIED (attribution), metadata OK.
  Crossref: Kempthorne & Nordskog, "Restricted Selection Indices", Biometrics 15(1):10-19, March 1959, DOI 10.2307/2527598 correct.
  Text: the restricted index "holds trait 2 at exactly zero" is "the construction of" this paper. No local copy and JSTOR paywalled; not read.

- 04c-B6 | 04c:1213 and bib `smith1936`, `hazel1943` | metadata OK; attribution UNVERIFIED (no full text).
  Smith: Ann. Eugen. 7(3):240-250, 1936, DOI 10.1111/j.1469-1809.1936.tb02143.x OK (Crossref).
  Hazel: Genetics 28(6):476-490, 1943, DOI 10.1093/genetics/28.6.476 OK (Crossref).
  "b = P^-1 G a" is the standard Smith-Hazel solution; not read in the originals (Hazel 1943 is in PMC; not fetched).

- 04c-B7 | 04c:1255 and bib `michel2019` | OK. FULL TEXT (local PDF s00122-019-03386-1.pdf, p. 2767).
  Theor. Appl. Genet. 132(10):2767-2780, 2019, DOI 10.1007/s00122-019-03386-1 (Crossref and PDF agree).
  "Multi-trait genomic selection ... balancing yield against protein content and quality ... in wheat" matches the paper's title and abstract
  (480 lines; grain yield, protein content, dough rheological traits; "integrated genomic selection indices").

- 04c-B8 | 04c:352-355, 676-680 and bib `mackay2020` | OK on attribution (FULL TEXT, local PDF); minor bib note.
  Attribution: "the presence of inbreeding depression is itself the evidence for [directional dominance]" -- the paper says
  "Evidence for directional dominance is easy to find; it is the presence of inbreeding depression" (section on heterosis, 1st page text col. 1).
  "transgressive segregation, heterosis and inbreeding depression as consequences of one mechanism: favourable alleles dispersed
  between the parents, plus directional dominance" -- the paper: "Provided that favorable alleles are dispersed between the two parents,
  and that there is some directional dominance, the performance of the F1 will inevitably exceed the best parent" and
  "Heterosis and inbreeding depression are ... opposite sides of the same coin". Faithful.
  Metadata: Mackay, Cockram, Howell, Powell, Plant Biotechnol. J. 19(1):26-34, DOI 10.1111/pbi.13481 correct. Key is `mackay2020`
  and bib year is 2021 (the issue year; online 15 Oct 2020). Consistent, not an error; a reader seeing "mackay2020" with year 2021 may be puzzled.

- 04c-B9 | 04c:25 and bib `gaynor2021` | OK on metadata, ABSTRACT-level.
  G3 11(2):jkaa017, DOI 10.1093/g3journal/jkaa017, Gaynor, Gorjanc, Hickey; Crossref confirms (online 7 Dec 2020, issue Feb 2021).
  Used only as the reference for the package itself.

- 04c-B10 | 04c:113 and bib `chen2009` | OK on metadata; attribution ABSTRACT-level.
  Genome Res. 19(1):136-142, 2009, DOI 10.1101/gr.083634.108 (Crossref; PMID 19029539). "MaCS program" as a coalescent simulator
  matches the title ("fast and flexible simulation of DNA sequence data"). The sentence about species demographies
  ("MAIZE", "WHEAT", "CATTLE") is an AlphaSimR feature, not MaCS, and is correctly not attributed.

- 04c-B11 | 04c:59, 311, 539, 800, 867 and bib `gorjanc2022` | OK on attribution (FULL TEXT, local .Rmd); bib note.
  Checked in reference/AlphaSimR_Course: (a) vignettes Weeks 2-5 cover DNA, traits, DNA lottery, single- and multi-trait selection, animal and plant programmes;
  (b) Week_5_C_Plant_breeding_programme.Rmd builds a wheat programme (Parents, F1, HDRW, PYT, AYT, EYT, Variety), no hybrid programme (grep "hybrid" over Week_*.Rmd: none) -- "has no hybrid programme of its own" is true;
  (c) Week_2_C uses addTraitA (additive teaching case); (d) Week_3_A crosses three founders and discusses full-sibs -- "Mendelian sampling ... full sibs vary" correct;
  (e) Week_4_A_Selection_single_trait.Rmd line 241: "The expected and observed change in mean genetic value due to selection did not match perfectly" -- the quotation "did not match perfectly" is verbatim (04c:867).
  Authors: the Rmd lists Lara, Lubanga, Gorjanc (Week 4A) -- the bib adds Pocrnic, Obsteter, Ehsani; I did not check the other vignette headers. Bib type @misc without URL or institution. Not wrong, but not retrievable by a reader.

- 04c-B12 | 04c:1324 and bib `caballero2002` | OK (FULL TEXT, local PDF papers/Analysis_of_genetic_diversity...pdf).
  Conservation Genetics 3(3):289-299, DOI 10.1023/A:1019956205473 correct (Crossref). The paper partitions GD_T into GD_WI, GD_BI, GD_BS
  and gives F-statistics from Wright (1969); its worked example reads GD_T = 0.6744 = 0.2944 + 0.2521 + 0.1279 (GD_WI, GD_BI, GD_BS).
  F_ST = GD_BS/GD_T is correctly described in the chapter as "an identity derived in @sec-subdivided", not attributed to the paper.

- 04c-B13 | 04c:709-714 -- no further MISSING SOURCE findings that I would require.
  Quantitative claims in the text are either computed in the chapter or attributed above. Suggestion only: l.1139 "A real maize programme would use elite
  inbred testers and several locations" cites Hallauer (see B4).

## Cross-key check
All keys cited in the chapter resolve in references.bib: comstock1949, gaynor2021, sprague1942, gorjanc2022, chen2009, falconer1996, mackay2020, hallauer2010,
smith1936, hazel1943, kempthorne1959, michel2019, caballero2002 (13 keys). `@sec-`, `@fig-`, `@tbl-`, `@eq-` labels and AlphaSimR slots (`@pheno`, `@gv`, `@nInd`, `@mother`, `@addEff`...) were ignored.

## Tally
13 keys checked. Metadata: 13 checked via Crossref (12 plain match; 1 key/year mismatch noted: mackay2020 -> 2021). Attribution: FULL TEXT 4 (gorjanc2022, mackay2020, michel2019, caballero2002);
ABSTRACT/title level 2 (gaynor2021, chen2009); UNVERIFIED 6 (falconer1996 chapters, hallauer2010, sprague1942, smith1936, hazel1943, kempthorne1959); PENDING 1 (comstock1949).
Uncited bib entries: not checked (chapter mode).
Sources searched for the UNVERIFIED items: local reference/ (no copy), Wiley/ACSESS (403), Pearson/library catalogues (no table of contents).
