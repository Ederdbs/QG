# 04b-backcross-introgression -- references check, iteration 1

Chapter: book/04b-backcross-introgression.qmd. Six keys cited, all resolve in book/references.bib
(haldane1919, hospital2001, falque2009, rodgersmelnick2015, lee2002, holding2008). Comstock 1949 is not cited here.
Local copies: none of the six is in reference/papers; checked PubMed/PMC (metadata, abstracts), PMC page via WebFetch, web search.

## Findings

**04b-B1 -- line 805-807 -- rodgersmelnick2015 -- WRONG (overstated attribution)**
Text: "the local meiotic recombination rate varies more than 1000-fold across the maize genome, measured from breakpoints
mapped at high resolution in nested association mapping populations [@rodgersmelnick2015]".
The paper (PMC4378432, full text via WebFetch) states the 1,000-fold figure as established background in the Significance
statement and Abstract ("Varying over 1,000-fold across the maize genome ..."), not as a result measured from its breakpoints.
Its own measured result: 136,000 breakpoints, hotspots with crossover rates "from threefold to over 100-fold" the uniform
expectation. Fix: drop "measured from ..." or split into "varies over 1000-fold [@rodgersmelnick2015]; that paper maps
136,000 breakpoints in NAM populations". Also "more than" vs "over" is fine. DOI 10.1073/pnas.1413864112 resolves correctly.

**04b-B2 -- line 808 -- "Gametophyte factors shift the foreground frequency away from 1/2" -- MISSING SOURCE**
Specific biological claim, no citation. Candidate found: lu2002 (already in references.bib, cited in 04-population-sizing.qmd):
Lu, Romero-Severson & Bernardo, Theor Appl Genet 105:622-628 (2002), doi:10.1007/s00122-002-0970-9 (PubMed 12582513;
17% of 1,820 markers distorted, 18 segregation distortion regions, three known gametophytic factors as possible causes).
ABSTRACT level only. Second source: not searched (Mangelsdorf & Jones 1926 is the classical origin; not verified here).

**04b-B3 -- lines 814-817 -- triploid endosperm / xenia statement -- MISSING SOURCE (low priority)**
"2 maternal : 1 paternal ... a recessive kernel phenotype does not appear on the ear of a heterozygous plant ... xenia means
it requires a self-pollination". Textbook genetics, uncited; I did not search a source. Content correctness was not assessed
(also repeated in the figure note at line 138).

**04b-B4 -- line 154, 779 -- haldane1919 -- UNVERIFIED (full text)**
Entry metadata correct (Haldane, J. Genet. 8:299-309, 1919; confirmed by web search, which also warns of the neighbouring
paper J. Genet. 8:291-297 -- not the one cited). No DOI in the bib (none exists in Crossref for the original). The paper is
not reachable here, so Eq. bc-haldane (r = (1 - exp(-2d/100))/2, d in cM) was not checked against p. 299-309. The formula is
the standard Haldane map function; the attribution is plausible, evidence level: none (bibliographic only).

## Checked, no finding

- hospital2001 (line 567): metadata and DOI 10.1093/genetics/158.3.1363 correct (PMID 11454782). Text says Hospital's analytical
  result is that "it is generally more profitable to allow three or more backcross generations than to favour recombination in
  early generations". Abstract (ABSTRACT): "it is generally more profitable to allow for three or more successive backcross
  generations rather than to favor recombinations in early generations". Faithful. Note the paper treats one introgressed gene
  with flanking double recombinants; the chapter applies the statement to k genes ("direction agrees") -- worded cautiously, OK.
- falque2009 (lines 780, 795): metadata and DOI 10.1105/tpc.109.071514 correct (PMID 20040539). FULL TEXT (PMC2814511 via WebFetch):
  "we found 4.2 < nu < 6.2 for the estimated values, except for the outlier chromosome 8 for which nu = 9.6" -- matches "on most
  chromosomes". Noninterfering fraction 6-23% per chromosome (abstract; ~15% cell average) -- text says only "a minority": faithful.
  Minor: "most crossovers follow a gamma renewal process" fits the gamma (GS) model; the paper also fits a beam-film model.
- lee2002 (line 810): metadata and DOI 10.1023/A:1014893521186 correct (PMID 11999829). Abstract (ABSTRACT): five generations of
  intermating gave a nearly four-fold increase in genetic map distance, supporting "IBM-type maps must be rescaled". Faithful.
- holding2008 (line 823): metadata and DOI 10.1007/s00122-008-0762-y correct (PMID 18427771). Abstract (ABSTRACT): "QPM was
  created by selecting genetic modifiers ... multiple, unlinked o2 modifiers (Opm)". Faithful.
- All @sec-/@fig-/@tbl-/@eq- cross-references are chapter-internal and out of scope of this check.

## Uncited entries
Not whole-book mode; not assessed.

## Evidence levels
6 citations checked: FULL TEXT 2 (falque2009 nu range; rodgersmelnick2015 1000-fold statement), ABSTRACT 3 (hospital2001,
lee2002, holding2008), bibliographic only / UNVERIFIED 1 (haldane1919). Uncited claims flagged: 2 (B2, B3).
