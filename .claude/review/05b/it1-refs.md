# 05b-heterosis-dominance.qmd -- reference check, iteration 1

Chapter: book/05b-heterosis-dominance.qmd. Bibliography: book/references.bib.
All 7 cited keys resolve in references.bib (labroo2021, falconer1996, mackay2020,
comstock1949, reif2007, technow2014, white2020). No `@` inside R code was cited.

## Findings

### 05b-B1 -- WRONG (attribution imprecise) -- book/05b-heterosis-dominance.qmd:1058-1061, key technow2014
Text: "@technow2014 report high accuracy for additive hybrid prediction in established,
clearly separated dent and flint pools".
Evidence (PMC4125404, https://doi.org/10.1534/genetics.114.165860): their BayesB model is
"model S2 of Technow et al. (2012)" and adds a dominance term D_i d_DF; GBLUP is built from
the GCA relationship matrices g_DD*, g_FF*. "GBLUP and BayesB achieved nearly identical
prediction accuracies" (0.75-0.92 grain yield). So the models were not all additive. What
the paper does say, and what supports the chapter better: "The variance component sigma_S^2
was always considerably smaller than either sigma_D^2 or sigma_F^2"; SCA share of genetic
variance 12.17% (grain yield) and 7.15% (grain moisture), Table 1.
Fix: "@technow2014 report a small SCA share of genetic variance (12% for grain yield, 7% for
moisture) and high accuracy of GCA-based genomic prediction (0.75-0.92), with a
dominance-including model doing no better, in established dent x flint pools -- ..."

### 05b-B2 -- WRONG (metadata) -- key mackay2020
Author list incomplete: the paper has four authors, Mackay IJ, Cockram J, Howell P,
**Powell W**. Bib lists three. Year 2021 / vol 19(1):26-34 are correct (online 2020-10-15,
hence the key). Evidence: Crossref and PubMed 32996672, https://doi.org/10.1111/pbi.13481.
Fix: author = {Mackay, Ian J. and Cockram, James and Howell, Phil and Powell, Wayne}.

### 05b-B3 -- WRONG (metadata incomplete) -- key white2020
Missing number and pages. Crossref: Crop Science 60(1):100-114, 2020.
https://doi.org/10.1002/csc2.20050. Fix: add number = {1}, pages = {100--114}.
(labroo2021 also lacks the article number: pages = {643761}; minor.)

### 05b-B4 -- UNVERIFIED -- book/05b-heterosis-dominance.qmd:86, key falconer1996
"[@falconer1996, Eq. 7.2]" for M = a(p - q) + 2pq d. The formula is Falconer's
(Ch. 7, single-locus population mean; p. 61 in the 1981 2nd ed. per a Genetical Research
note citing it). The book text was not reachable, so the equation number cannot be confirmed;
from recollection the single-locus mean and its multi-locus sum are Eqs 7.1/7.2 in the 4th
ed. and the number may be off by one. Check against the physical copy.
Ch. 14 (lines 243, 335: H_F1 = sum d y^2; M_F = M_0 - 2F sum d pq) and Ch. 7 (line 801:
alpha = a + d(q - p)) are the correct chapters of the 4th ed. ("Inbreeding and
crossbreeding: changes of mean value"; "Values and means"); content consistent with the
standard results, text not re-read.

### 05b-B5 -- MISSING SOURCE -- book/05b-heterosis-dominance.qmd:113
"Fisher's *statistical* dominance deviation ... the residual left after projecting genotypic
values onto the best additive model in a particular population" -- named, not cited.
Proposed: Fisher RA (1918) The correlation between relatives on the supposition of Mendelian
inheritance. Trans R Soc Edinb 52:399-433, https://doi.org/10.1017/S0080456800012163
(not in references.bib); or [@falconer1996, Ch. 7] which is already in the bib.

### 05b-B6 -- MISSING SOURCE -- book/05b-heterosis-dominance.qmd:750-762
"the classical decomposition falls out, H_ij = mu + g^A_i + g^B_j + s_ij ... general
combining ability ... specific combining ability" -- the GCA/SCA concepts are introduced
without a source.
Proposed: Sprague GF, Tatum LA (1942) General vs. specific combining ability in single
crosses of corn. Agron J 34:923-932, https://doi.org/10.2134/agronj1942.00021962003400100008x
(not in bib); and @griffing1956 (already in bib, https://doi.org/10.1071/bi9560463).

## Verified (no finding)
- labroo2021 (lines 65, 128, 132): metadata correct (PubMed 33719351,
  https://doi.org/10.3389/fgene.2021.643761). Full text (PMC7943638) discusses dominance,
  overdominance, pseudo-overdominance and epistasis ("biological epistasis may contribute to
  heterosis as interactions of multiple loci"). Pseudo-overdominance is treated mainly as a
  confound for detecting overdominance; "review the evidence for each" is acceptable.
- mackay2020 (line 342): abstract treats transgressive segregation, inbreeding depression and
  heterosis as unified (dispersion of favourable alleles). Attribution faithful.
- comstock1949 (lines 793, 823): Agron J 41(8):360-367, DOI resolves (Crossref). Title
  "...make maximum use of both general and specific combining ability" supports line 793;
  testcrossing against the opposite population is the RRS scheme. Full text not re-read.
- reif2007 (line 1027): Genetics 176(3):1931-1934, PubMed 17507673. Abstract: "theoretical
  proof that the ratio of the dominance vs. the additive variance decreases with increasing
  genetic divergence ... superior hybrids can be predicted on the basis of general combining
  ability effects." Faithful.
- white2020 (line 1662): title/authors correct; attribution matches title-level content.

Checked 7 keys / 12 citation instances: metadata via Crossref (doi.org CSL-JSON) and PubMed;
attributions via PubMed abstracts and PMC full text (Labroo, Technow); Falconer & Mackay not
reachable (UNVERIFIED).
