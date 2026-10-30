# 04-population-sizing -- references, iteration 1

Chapter: book/04-population-sizing.qmd. The chapter cites no bib key. Every `@` in it is an internal cross-reference (sec-coancestry, sec-choosing, sec-ocs, sec-combinatorial, sec-ns, sec-stages, sec-limits). That leaves checks 1-3 with nothing to check, and every finding below comes from check 4. The bib has no entry for Haldane, Kosambi, Sedcole, Fisher (junctions), Broman, Winkler, Lee (IBM), Lu (SDR) or Falque.
The chapter does not use Kosambi, DH or Bernardo's sizing formulas, so those priorities do not apply.

### 04-B1 -- 04-population-sizing.qmd:41-43 -- WRONG (uncited, contradicted)
The text says IBM-type map lengths "are inflated 5-10x by construction". The primary source reports less: Lee et al. (2002) measured "nearly a four-fold increase in the genetic map distance" after five generations of intermating B73 x Mo17 (Plant Mol Biol 48:453-461, doi:10.1023/A:1014893521186, PubMed 11999829, abstract read).
The chapter's own junction recursion (l.99, l.169) predicts the same thing. An F2 plus 4 random-mating cycles plus selfing to fixation gives 2L + 4 x 0.5L = 4L.
Fix: write "about 4x (@lee2002)" and add the entry. Theory for intermated RILs: Winkler et al. (2003) Genetics 164:741-745, doi:10.1093/genetics/164.2.741 (resolved through Crossref, full text not read).

### 04-B2 -- 04-population-sizing.qmd:40-41 -- MISSING SOURCE
"lengths from a classical composite maize map, about 1670 cM". The arithmetic holds: `maize_chr_len` in R/06_f2size.R:32 sums to 1670. No map is named, though.
Candidate: Beavis & Grant (1991) "A linkage map based on information from four F2 populations of maize", Theor Appl Genet 82:636-644, doi:10.1007/BF00226803. Crossref resolved it. A secondary snippet gives that composite as 275 loci over 1765 cM. I could not reach the abstract (Springer login), so the figure is UNVERIFIED.
Either cite the map the per-chromosome lengths were actually taken from, or say "of the order of 1,700 cM" and cite Beavis & Grant.

### 04-B3 -- 04-population-sizing.qmd:51-53 -- MISSING SOURCE
The Haldane map function r = 0.5(1 - e^{-2d}) has no citation. The formula as written is correct.
Primary source: Haldane, J. B. S. (1919). The combination of linkage values, and the calculation of distances between the loci of linked factors. J Genet 8:299-309. I found no DOI. Crossref lists J Genet vol. 8 only up to p. 297 (doi:10.1007/BF02983270 is the neighbouring Haldane paper, pp. 291-297, and is not this one). Put the bib entry in without a DOI rather than with a guessed one.

### 04-B4 -- 04-population-sizing.qmd:56-57 -- MISSING SOURCE
"Maize has strong positive interference" has no citation. Falque et al. (2009) "Two types of meiotic crossovers coexist in maize", Plant Cell 21:3915-3925, doi:10.1105/tpc.109.071514 (PubMed 20040539, abstract read), supports it. They find that about 85% of crossovers come from the interfering pathway and estimate the 6-23% non-interfering share per chromosome.
Note that the non-interfering share also slightly weakens the word "strong".

### 04-B5 -- 04-population-sizing.qmd:61-63 and the printed `f2_distorters` (R/06_f2size.R:54) -- MISSING SOURCE, plus UNVERIFIED bin
Neither gametophytic distortion in maize nor ga1/Ga1-s as a pollen-incompatibility system is cited. Two sources:
- Lu, Romero-Severson & Bernardo (2002) "Chromosomal regions associated with segregation distortion in maize", Theor Appl Genet 105:622-628, doi:10.1007/s00122-002-0970-9 (PubMed 12582513, abstract read). Of 1,820 markers, 17% are distorted, in 18 SDRs. Three known gametophytic factors are the possible causes. In one population (B73/Mo17) 36% of markers are distorted. This is the right anchor for the callout's claim that distortion "is the parameter that moves the results most".
- Zhang et al. (2018) "A PECTIN METHYLESTERASE gene at the maize Ga1 locus confers male function in unilateral cross-incompatibility", Nat Commun 9:3678, doi:10.1038/s41467-018-06139-8 (PubMed 30202064, abstract read). It confirms that the mechanism is male (pollen-tube) function.
The printed label "ga1-like (4.05)" is UNVERIFIED and probably misplaced. Classical mapping puts Ga1 on 4S, about 23 cM distal of su1 (Mangelsdorf & Jones 1926, as quoted secondarily), and su1 sits in bin 4.05. A thesis that I saw only as a search snippet gives bin 4.02. I found no primary source for 4.05. Since the locus is declared "plausible, not measured", use "ga1-like (chr 4S)" or cite a source for the bin.

### 04-B6 -- 04-population-sizing.qmd:89-106, 159-172 -- MISSING SOURCE (minor)
The junction recursion A_2 = L, A_{t+1} = A_t + L H_t, and the claim that each Syn cycle adds 0.5L, are uncited. I checked the algebra: F4 gives 1.75L, selfing to fixation gives 2L (the Haldane-Waddington RIL expansion), and each random-mating generation at H = 0.5 adds 0.5L. All consistent. Primary theory to cite:
- Fisher (1954) "A fuller theory of 'junctions' in inbreeding", Heredity 8:187-197, doi:10.1038/hdy.1954.17 (Crossref).
- Winkler et al. (2003), see 04-B1, for the intermating expansion. Martin & Hospital (2011) Genetics 189:645-654, doi:10.1534/genetics.111.129700 (Crossref) covers block lengths in RILs.
The other identities in the table (Var = (1-H)/4, SE = 0.5 sqrt((1-H)/N), D = 1-(1-H)/N, P(P2 homozygote) = (1-H)/2) are elementary. I checked them algebraically and they need no citation.

### 04-B7 -- 04-population-sizing.qmd:288-290 and table l.274-285 -- MISSING SOURCE
Multilocus recovery, P(at least one line homozygous P2 at k loci) = 1 - (1 - ((1-H)/2)^k)^N, is the classical "number of plants needed to recover a genotype" problem, and the chapter cites nothing for it. Primary source: Sedcole (1977) "Number of plants necessary to recover a trait", Crop Sci 17:667-668, doi:10.2135/cropsci1977.0011183X001700040052x (Crossref: Sedcole, vol. 17, pp. 667-668, July 1977; full text not read).

### 04-B8 -- 04-population-sizing.qmd:331 and table l.344 -- WRONG (internal arithmetic, not a reference)
"Twelve selfed F1 plants already put the expected number of lost loci below one." `f1_sizing()` (R/06_f2size.R:584-590) returns expected_loci_lost = h_res x n_loci_eff x 2 x 0.5^n = 500 x 0.5^n. That is 1.95 at n = 8, **0.98 at n = 9**, 0.49 at n = 10 and 0.12 at n = 12. So the threshold is 9 plants, not 12, which makes "already" misleading.
The function also counts the segregating loci of only one parent. If both parents carry 5% residual heterozygosity the count doubles and the threshold becomes n = 10. Fix the text, and the "12 plants" rationale in the Working-numbers table, to 9 (one parent) or 10 (both). The 2(1/2)^n per-locus probability itself is correct.

### 04-B9 -- 04-population-sizing.qmd:320 -- MISSING SOURCE
"F ~ 0.95 is common in programme lines" has no source, and I found no primary source that measures it. I propose no citation. Either present it as an assumed scenario value, or cite measured residual heterozygosity for your own germplasm.

### 04-B10 -- 04-population-sizing.qmd:81-83 -- MISSING SOURCE (minor)
"15% random loss per generation ... common in wide crosses with exotic material." This is presented as typical, but I found no source for it. Present it as a scenario parameter rather than an empirical rate.

### Checked, no finding
- l.53, l.119-121: the -2.0% junction bias at 2 cM spacing. 1 - (1 - e^{-0.04})/0.04 = 1.97%, so it is correct and always downward.
- l.106: 0.5/sqrt(N) is the H = 0 special case, which is correct.
- l.141: H halves per selfing (1, 0.5, 0.25, 0.125). Textbook.
- l.398: N_s = 1/(2 theta) defers to @sec-ns, where the Lindgren keys belong. Not checked here.

Citations checked: 0 bib keys (the chapter cites none) and 7 internal @sec- refs (not bib). 10 findings came from check 4: 2 WRONG and 8 MISSING SOURCE, plus 1 UNVERIFIED bin inside 04-B5. Sources were checked through Crossref (Haldane J Genet 8, Beavis & Grant, Sedcole, Fisher 1954, Winkler 2003, Martin & Hospital 2011) and through PubMed abstracts (Lee 2002, Falque 2009, Lu 2002, Zhang 2018). The identities, the F1 numbers and the junction bias were checked algebraically and against R/06_f2size.R.
