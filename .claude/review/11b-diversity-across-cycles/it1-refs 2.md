# 11b-diversity-across-cycles: reference check, iteration 1

File: book/11b-diversity-across-cycles.qmd. Bib: book/references.bib.
Cited keys: gorjanc2018, allier2019, wientjes2022, doublet2019, rutkoski2019, muller2018 (all at lines 387-397).
All six keys exist in references.bib. All @sec- targets resolve (case-study, alphasimr, programme, heterosis, simulating-crosses, sizing, choosing, stages, genomic-era, combinatorial, ns, plant-literature, backcross, corpora, catalogue).
Comstock 1949 (comstock1949) is NOT cited in this chapter; nothing attributed to it here.
Metadata of all six resolved against Crossref + PubMed: year, first author, title, journal, volume, DOI all match, no retraction/correction.

## Findings

### 11b-B1  doublet2019, line 392-393  -- WRONG (overstated attribution)
Text: "@doublet2019 measure the diversity cost in three dairy cattle breeds where the cycles have actually been run."
Abstract (PMID 31547802, doi 10.1186/s12711-019-0495-1), EVIDENCE: ABSTRACT: genomic selection raised annual gain by 50/71/33 % (Montbeliarde/Normande/Holstein) with "no significant change in inbreeding rate for the two national breeds" and a significant increase only in Holstein (0.55 %/yr ROH). So a diversity cost was found in one breed of three, not in "three dairy cattle breeds". The study compares before/after genomic selection (bulls born 2005-2015), it does not run or measure a constrained-vs-unconstrained crossover. Suggest: "measure the change in inbreeding and gain after genomic selection in three dairy breeds, finding a significant loss only in Holstein".

### 11b-B2  rutkoski2019, line 394-395  -- WRONG (inverted description)
Text: "realised rates of gain are harder to estimate from an operating programme than a simulation makes them look."
Source (doi 10.2135/cropsci2018.09.0537), EVIDENCE: ABSTRACT (Crossref): the paper IS a simulation (80 rice programmes x 28 yr); it evaluates five estimators of realised gain against the simulated truth; best methods err by 15 % (all 28 yr) and 27 % (last 15 yr); best correlation with true gain 0.59; EqCg and expected gain are useful indicators of non-zero gain. It does not contrast operating programmes with simulations. The warning is valid (estimates are imprecise) but the sentence misdescribes the paper. Suggest: "estimating realised gain from a programme's own data is itself imprecise: in simulated rice programmes the best estimators erred by 15-27 % and correlated at most 0.59 with true gain". Full text not read; numbers are from the abstract and are correct as abstract numbers.

### 11b-B3  gorjanc2018, line 387-389  -- UNVERIFIED in part (overreach)
Text: "optimise cross selection explicitly for long-term gain in two-part programmes and report the same tension between per-cycle and multi-cycle optimality that the DE comparison above ran into."
EVIDENCE: FULL TEXT (PMC6096640). Supported: OCS in two-part programmes, long-term gain (20 yr wheat simulation); "increasing the number of cycles ... expectedly increased genetic gain in first years, but eventually led to a lower long-term genetic gain"; OCS 15-78 % more gain than truncation at 4 cycles/yr; best penalty rises (about 15 deg with 640 candidates to about 45 deg with 107). Not supported: the tension reported is truncation (no diversity control) vs diversity-penalised OCS, i.e. gain vs diversity. It is not the chapter's finding that a better per-cycle optimiser (DE) of the same constrained problem ends lower in cumulative index (lines 224-230). Different phenomenon; "the same tension" should be "a related tension" or dropped. Also note the paper says the OCS/truncation difference was "smaller than expected" and the horizon of 20 yr is "short to medium term" in their own words.

### 11b-B4  wientjes2022, line 390-392  -- UNVERIFIED (interpretive)
Text: "track what genomic selection does to additive variance over many generations, which is the mechanism behind the saturation seen here".
EVIDENCE: ABSTRACT (PMID 35255802): 50 generations, single trait, livestock-type population; genomic/pedigree selection lose much more genetic variance and segregating loci than phenotypic; short-term response greatest with GS, long-term greater with phenotypic when epistasis present. First half is faithful. "The mechanism behind the saturation seen here" is the chapter's own inference: the chapter never measures additive/genic variance, assumes unlinked loci (C1, no Bulmer effect) and fixed effects (C4), and its saturation is exhaustion of marker diversity of a hybrid pool (F_drift). Also the source is a livestock simulation with additive/dominance/epistasis; no hybrid-crop or cycle-by-cycle diversity-constraint result. Soften to "a related mechanism" or measure genic variance in run_cycles.

### 11b-B5  muller2018, line 396-397  -- UNVERIFIED (loose)
Text: "closest thing in the corpus to the selection criterion used here, chosen for its effect on later cycles rather than the current one."
EVIDENCE: ABSTRACT (PMID 29434032): EMBV vs GEBV in recurrent GS: GEBV maximises single-cycle but not necessarily long-term gain; EMBV outperformed GEBV after about 5 cycles, higher long-term gain, higher diversity retained. Second half is faithful. "Closest to the selection criterion used here" is questionable: EMBV is a gamete/haploid-value criterion without a diversity constraint; the chapter's criterion is an index under a theta budget. Allier 2019 or Gorjanc 2018 (OCS under a diversity constraint) fit that description better. Note the abstract's "about 5 cycles" crossover is a real, citable parallel to the chapter's crossover (cycle 5-12); consider quoting it.

### 11b-B6  allier2019, line 389-390  -- OK, with a stronger use available
Text: "separate the short-term and long-term components directly."
EVIDENCE: FULL TEXT (PMC6828944, Introduction, Results, Discussion): gain is reported separately at short term (5-10 yr) and long term (60 yr), plus a discounted cumulative gain weighting both; OCS under a diversity target "showed lower short-term genetic gain ... but significantly higher long-term genetic gains" than unconstrained cross selection (UC), "always maximized the long-term genetic gain, at the cost of a variable penalty for short-term gain". This is the best support in the list for the chapter's crossover (line 385-386) and is not used for it. Suggest citing it explicitly there. Metadata correct.

### 11b-B7  line 385-386 "is the standard finding in that literature"  -- partially supported
Cited support: gorjanc2018 (FULL TEXT: early gain larger with more cycles/less diversity, lower long-term), allier2019 (FULL TEXT: lower short-term, higher long-term when diversity is constrained), muller2018 (ABSTRACT: crossover after about 5 cycles). Adequate, but the sentence sits before the citations and covers "early advantage, saturation, then crossover"; none of the three has a closed-vs-budgeted trajectory crossing at a cycle number. Add Jannink 2010 (doi 10.1186/1297-9686-42-35, ABSTRACT checked: GS "strongly increased early selection gains but also caused the loss of many favorable QTL alleles, leading to loss of genetic variance, loss of GS accuracy, and a low selection plateau") for the plateau.

### 11b-B8  line 398-402 "nobody has published the crossover for a theta-constrained hybrid maize programme ..."  -- MISSING SOURCE / scope dropped
book/11-plant-literature.qmd (lines 543, 679) states the claim as "not established in the retrieved set". Chapter 11b states it as "nobody has published", which is an absence claim about the whole literature and cannot be verified from a bounded corpus (687 plant + 324 animal records). Restore the qualifier ("in the corpus retrieved for @sec-corpora") or replace it with a dated search statement. UNVERIFIED (not searched outside the corpus).

### 11b-B9  line 301-303 "the crossover arrives sooner the harder the selection is"  -- MISSING SOURCE (and untested here)
Quantitative-direction claim with no citation and no sweep over n_sel in the chapter (n_sel = 60 only). Support found: gorjanc2018 FULL TEXT (smaller populations per cycle with more cycles per year deplete diversity faster; optimal penalty rises from about 15 deg to about 45 deg as candidates fall from 640 to 107), doi 10.1007/s00122-018-3125-3. Also Jannink 2010, doi 10.1186/1297-9686-42-35 (ABSTRACT: shorter cycle time -> strongly increased early gain then low plateau). Either cite them or run a second n_sel.

### 11b-B10  line 346-347, 372-374 injection / genebank material  -- MISSING SOURCE (low)
"introgression is how new material enters an elite pool without dragging the rest of the genome" and "unadapted material from a genebank would cost considerably more" are uncited. Candidates in the book's own corpus (bibliography_plant.csv; metadata not re-verified here beyond the CSV): Sanchez et al. 2023 PNAS, doi 10.1073/pnas.2205780119; Allier et al. 2020 BMC Genomics, doi 10.1186/s12864-020-6756-0. UNVERIFIED: I did not open either paper. Allier 2019 (above, full text) also says "when the genetic diversity in a program is so low that long-term genetic gain is compromised, external genetic resources need to be introgressed by crosses with internal elite parents", which supports line 342-346 as is.

### 11b-B11  bib metadata, minor
- doublet2019: author list truncated; the paper has 8 authors (Doublet, Croiseau, Fritz, Michenet, Hoze, Danchin-Burge, Laloe, Restoux). bib has 6. Add `Laloe, D. and Restoux, G.`.
- allier2019 (article 1006), wientjes2022 (article 19), doublet2019 (article 52): no page/article number in the bib.
- rutkoski2019: pages 981--993 missing; muller2018: pages 1173--1181 missing (volume 8, issue 4).

### 11b-B12  C1 "no Bulmer effect" (line 78), "Ne = 1/(2 dF)" (line 242)  -- MISSING SOURCE (low)
Bulmer effect named without a citation (Bulmer 1971, not looked up); Ne = 1/(2 dF) is textbook (Falconer & Mackay) and also used in gorjanc2018 full text ("Ne = 1/(2 dC)"). Cite Falconer & Mackay at line 242 if desired.

## Not checked
Numbers computed by chunks from book/data/cycles_*.csv (reproducibility, not references). Comstock 1949: pending; not attributed anywhere in this chapter.

## Evidence level tally
6 citations checked: FULL TEXT 2 (gorjanc2018, allier2019), ABSTRACT 4 (wientjes2022, doublet2019, muller2018, rutkoski2019 via Crossref abstract; full text not read). Metadata (DOI resolution via Crossref + PubMed): 6/6.
Verdicts: faithful 1 (allier2019), wrong 2 (doublet2019, rutkoski2019), overreach/UNVERIFIED 3 (gorjanc2018 part, wientjes2022, muller2018).
Alternative sources checked, ABSTRACT only: Jannink 2010 (PMID 20712894), Goddard 2008 Genetica 136:245 (PMID 18704696, doi 10.1007/s10709-008-9308-0; not needed).
