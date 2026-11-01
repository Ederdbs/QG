# 04c (book/04c-alphasimr-pipeline.qmd) -- reference check, iteration 1

Scope: 12 citation keys (comstock1949, gaynor2021, sprague1942, gorjanc2022, chen2009,
falconer1996, mackay2020, hallauer2010, hazel1943, smith1936, kempthorne1959, michel2019),
20 citation sites. All 12 keys resolve in book/references.bib. `@addEff`, `@domEff`,
`@intercept`, `@nInd`, `@id`, `@mother`, `@father`, `@geno`, `@pheno` are AlphaSimR slots
in R code and were ignored.

## Findings

### 04c-B1 -- UNVERIFIED -- book/04c-alphasimr-pipeline.qmd:459
`[@falconer1996, Ch. 7, Eq. 7.2]` attached to the *multi-locus* mean
`M = mu0 + sum_k [a_k (p_k - q_k) + 2 p_k q_k d_k]`.
The formula itself is correct (Falconer & Mackay Ch. 7, "Values and Means"). The equation
number could not be checked: no full text of the 4th edition was reachable (searched
web; https://zjuwhw.github.io/notebook-qg/values-and-means.html reproduces Ch. 7 without
equation numbers). Note the risk: in F&M the single-locus mean and the summed-over-loci
mean are separate numbered equations, so a summed form may carry the next number.
Fix: check a printed copy; either confirm 7.2 refers to the form displayed (or say
"the single-locus form, Eq. 7.2, summed over loci"), or drop the equation number as the
chapter already does at lines 310, 469-470, 585-586, 646-647.

### 04c-B2 -- WRONG (mild over-statement) -- book/04c-alphasimr-pipeline.qmd:612-614
"transgressive segregation, which @mackay2020 argue is the same phenomenon as heterosis
and inbreeding depression viewed from a third angle".
Mackay et al. (2021, doi:10.1111/pbi.13481) frame them as *unifying concepts* explained
by dispersion of favourable alleles plus directional dominance: Fig. 1 caption "Two sides
of the same coin: transgressive segregation and heterosis"; text "Heterosis and
inbreeding depression are, to a considerable extent, opposite sides of the same coin."
"The same phenomenon" drops the hedge.
Fix: "which @mackay2020 treat, with heterosis and inbreeding depression, as consequences
of one mechanism -- favourable alleles dispersed between parents, plus directional
dominance".

### 04c-B3 -- MISSING SOURCE -- book/04c-alphasimr-pipeline.qmd:331-332
"Directional dominance ... is the standing hypothesis for yield in maize." Uncited.
Proposed sources (DOIs resolved on Crossref):
- @mackay2020 (already in bib): "Evidence for directional dominance is easy to find; it
  is the presence of inbreeding depression" -- doi:10.1111/pbi.13481
- Lariepe et al. 2012, Genetics 190:795-811, "The genetic basis of heterosis:
  multiparental QTL mapping reveals contrasted levels of apparent overdominance among
  traits of agronomical interest in maize" -- doi:10.1534/genetics.111.133447
- (general) Charlesworth & Willis 2009, Nat Rev Genet 10:783-796 -- doi:10.1038/nrg2664

### 04c-B4 -- MISSING SOURCE (minor) -- book/04c-alphasimr-pipeline.qmd:628, 714-717
"six or seven selfing generations against one DH cycle" and "DH production is a
laboratory operation with its own failure rate and its own genotype-dependent response".
Uncited practice claims. Proposed: @hallauer2010 (in bib, doi:10.1007/978-1-4419-0766-0)
for the selfing generations; Prigge et al. 2012, Genetics 190:781-793, "New insights
into the genetics of in vivo induction of maternal haploids, the backbone of doubled
haploid technology in maize" -- doi:10.1534/genetics.111.133066 -- for genotype-dependent
haploid induction.

### 04c-B5 -- metadata (minor) -- bib key gorjanc2022
@misc with no URL/howpublished. Authors (Gorjanc, Pocrnic, Obsteter, Ehsani, Lara,
Lubanga) and year match the vignette headers (e.g. Week_3_C "DNA lottery: trait",
date 2022-06-22). Every attribution checked against the local vignettes holds:
addTraitA is the teaching case (Week_2_C, 3_C, 4_A); DNA lottery shown with full sibs
from runMacs founders (Week_3_C l.66; default inbred = FALSE, so outbred); quote "did
not match perfectly" verbatim (Week_4_A l.241); no hybrid programme (no "hybrid" in any
.Rmd); the plant programme is wheat (Week_5_C, after Gaynor et al. 2017).
Fix: add a `howpublished`/`url` pointing to the public course location, if one exists;
otherwise leave as is. Not invented here.

### 04c-B6 -- metadata (cosmetic) -- bib keys mackay2020, gaynor2021
- mackay2020: entry has year = 2021 (correct per Crossref: PBJ 19(1):26-34, 2021); only
  the key says 2020 (online 2020). Renders correctly; no change needed.
- gaynor2021: no pages; the article number is jkaa017. Optional: `pages = {jkaa017}`.

## Checked and correct
- comstock1949: Agron. J. 41(8):360-367, 1949, doi resolves; RRS using opposite pool as
  tester to capture GCA and SCA matches the title/design (l.23, 834).
- sprague1942: J. Am. Soc. Agron. (Crossref: Agronomy Journal) 34(10):923-932; GCA/SCA
  concepts (l.49, 832).
- gaynor2021: G3 11(2), jkaa017 (l.25).
- chen2009: MaCS, Genome Res. 19(1):136-142 (l.113).
- falconer1996 Ch. 7 additive scale (l.308), alpha in Ch. 7 and 2pq alpha^2 in Ch. 8
  (l.468-469), H_F1 = sum d y^2 and H_F2 = H_F1/2 in Ch. 14 (l.583, 645): consistent with
  F&M 4th ed.; no equation numbers claimed there.
- hallauer2010: Springer 2010, doi resolves (l.1030).
- smith1936 (Ann. Eugen. 7:240-250), hazel1943 (Genetics 28:476-490): b = P^-1 G a (l.1098).
- kempthorne1959: Biometrics 15(1):10-19, restricted index (l.1126).
- michel2019: TAG 132:2767-2780, multi-trait GS yield/protein/quality in wheat (l.1139).

Checked: 12 keys / 20 citation sites; all 11 DOIs resolved via api.crossref.org;
gorjanc2022 and mackay2020 attributions checked against the local source files in
reference/AlphaSimR_Course; F&M equation number not reachable (UNVERIFIED).
