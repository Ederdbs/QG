# 04b-backcross-introgression -- references, iteration 1

Chapter: book/04b-backcross-introgression.qmd. The chapter cites **no bib key**. Every `@` in it is an internal cross-reference (sec-sizing, sec-bc-running, sec-bc-assumptions, sec-verification, sec-coancestry, sec-ocs, sec-stages, sec-choosing, fig-bc-policies). Checks 1-3 therefore have nothing to check, and every finding below comes from check 4.

The bib already holds entries the chapter could use without adding anything: `haldane1919`, `falque2009` and `lee2002`, all added after the 04 review. Their metadata was verified in .claude/review/04/it1-refs.md and is reused here. The bib has no entry for Hanson, Naveira & Barbadilla, Stam & Zeven, Hospital, Frisch, Visscher, Herzog & Frisch, Tanksley or Young & Tanksley. The chapter attributes nothing to any of them, so none of their attributions can be wrong; the problem is that they are absent.

Sources were checked through PubMed (abstracts) and Crossref (DOI resolution). The only full text I read is Falque 2009 (PMC2814511).

## Findings

### 04b-B1 -- 04b-backcross-introgression.qmd:132-138 -- MISSING SOURCE
The Haldane map function has no citation. The formula is correct. Cite `@haldane1919`, which is already in the bib (J Genet 8:299-309; no DOI exists; see 04-B3).

### 04b-B2 -- :153-172 -- MISSING SOURCE (unsupported claim about the literature)
"Published stacking simulations get this wrong often enough that it is worth stating separately." This accuses unnamed published work and gives no citation. I found no paper that documents the error. Either name the papers or delete the sentence.
The formula P_same = e^{-L} / ((1+e^{-2L})/2) is correct for a single Poisson meiosis, and the value at 20 cM checks out (0.980 against a naive 0.819). Its classical background is the distribution of the intact donor segment:
- Hanson (1959) Genetics 44:833-837, doi:10.1093/genetics/44.5.833
- Naveira & Barbadilla (1992) Genetics 130:205-209, doi:10.1093/genetics/130.1.205
- Frisch & Melchinger (2001) Genetics 157:1343-1356, doi:10.1093/genetics/157.3.1343 (PubMed 11238419, abstract read)

### 04b-B3 -- :189-190, :200-209, :379-381 -- MISSING SOURCE (minor)
Three quantities are textbook results with no citation:
- foreground q = (1/2)^k
- expected donor dosage (1/2)^{t+1} after t backcrosses
- fixation probabilities (1/4)^k by selfing and (1/2)^k by DH

I checked the algebra and it holds: IBD_E = 1 - 0.4/16 = 0.975. For the donor-dosage expectation and its use in sizing, the primary MABC sources are Hospital & Charcosset (1997) Genetics 147:1469-1485, doi:10.1093/genetics/147.3.1469, and Visscher, Haley & Thompson (1996) Genetics 144:1923-1932, doi:10.1093/genetics/144.4.1923. Both DOIs were resolved through Crossref; I did not read the full texts, so the equation numbers are not given.

### 04b-B4 -- :246 and :314-319 -- MISSING SOURCE
Two claims have no citation:
- "Classical practice stops recombinant selection after BC2" (`rec12`, "classical practice").
- "the expected distance to the nearest crossover from a target shrinks as 1/g".

The 1/g scaling is Hanson (1959) and Naveira & Barbadilla (1992), DOIs as in 04b-B2. I did not read either full text, so the exact form is UNVERIFIED (Hanson's expected segment length is of order 2/t Morgans).

For "classical practice", the candidate source is Frisch, Bohn & Melchinger (1999), "Comparison of selection strategies for marker-assisted backcrossing of a gene", Crop Sci 39:1295-1301, doi:10.2135/cropsci1999.3951295x. The DOI resolves, but the full text was not read, so it is UNVERIFIED that this paper describes the BC1-BC2 recombinant-selection convention.

### 04b-B5 -- :356-373 -- MISSING SOURCE (prior result not credited)
"The balanced schedule wins ... cast a wide net early ... is the worst" is presented as the chapter's own finding. Hospital (2001), Genetics 158:1363-1379, doi:10.1093/genetics/158.3.1363 (PubMed 11454782, abstract read), already concludes that "it is generally more profitable to allow for three or more successive backcross generations rather than to favor recombinations in early generations." That abstract also bears on the drag-reduction mechanism at :316. Cite it as the prior result that the simulation reproduces.
Related prior work for the index comparison at :239-302: Herzog & Frisch (2011), "Selection strategies for marker-assisted backcrossing with high-throughput marker systems", Theor Appl Genet 123:251-260, doi:10.1007/s00122-011-1581-0. The DOI was resolved; the full text was not read.

### 04b-B6 -- :431-432 -- MISSING SOURCE
"For maize, where DH is routine" has no citation. Prigge et al. (2012) Genetics 190:781-793, doi:10.1534/genetics.111.133066 (resolved through Crossref, full text not read) covers in vivo haploid induction in maize. I could not resolve a DOI for Geiger & Gordillo (2009, Maydica), so I do not propose it.

### 04b-B7 -- :531-543 -- MISSING SOURCE, plus a probable conflict with the only source found
- "Maize has strong positive interference": cite `@falque2009`, which is already in the bib. Note the 04-B4 caveat: 6-23% of crossovers are non-interfering (abstract, PubMed 20040539).
- "maize estimates put nu near 3": no source given. The one maize estimate I found is Falque 2009 (full text, PMC2814511, Results/Fig. 1). In the gamma-sprinkling model it reports "4.2 < nu < 6.2 ... except ... chromosome 8 for which nu = 9.6", with the others "compatible with nu = 5". The paper reports no single-pathway gamma nu. So the figure of 3 is unsupported, and it does not match the one primary estimate. Either cite a source for nu around 3 or write "nu around 5 for the interfering pathway (@falque2009)".
- The values 2.26e-3 against 4.90e-4 and the ratio of 4.6x: the Haldane number is correct (0.04758^2 = 2.264e-3), but "a coincidence model" is not named and has no source. I found nothing in R/08_mabc.R that computes 4.90e-4; inst/scripts/run_mabc.R:858-862 only repeats the prose. Name the model and its coincidence value (4.90e-4 / 2.264e-3 implies c = 0.216), or derive it from the gamma model and cite the parameter.

### 04b-B8 -- :550-552 -- MISSING SOURCE, and the magnitude conflicts with the source found
"Maize has 5-10x rate variation and strongly suppressed pericentromeric regions" has no citation. Rodgers-Melnick et al. (2015) PNAS 112:3823-3828, doi:10.1073/pnas.1413864112 (PubMed 25775595, abstract read) reports local recombination rate "varying over 1,000-fold across the maize genome", and finds that broad-scale crossover patterns follow gene density. The 5-10x figure may refer to a coarser scale, but no scale is stated, so it reads as an understatement. Cite this source and state the scale.
The IBM rescaling clause at :554-555 defers to @sec-sizing. It could cite `@lee2002` directly; per 04-B1 the inflation is about 4x.

### 04b-B9 -- :545 -- MISSING SOURCE
"Real programmes advance 3-10 [plants] and cross each to the recurrent parent." I found no source for it. Present it as a typical assumption, or cite programme data.

### 04b-B10 -- :563-568 -- MISSING SOURCE
Two gene-biology claims have no citation:
- "sh2 and bt2 encode the two subunits of the same enzyme". For Sh2 as an ADP-glucose pyrophosphorylase subunit: Bhave et al. (1990) Plant Cell 2:581-588, doi:10.1105/tpc.2.6.581 (PubMed 1967077, abstract read). I could not find a DOI-bearing primary source for Bt2 as the small subunit (Bae, Giroux & Hannah 1990, Maydica, unresolved). "Stacking both is largely redundant" is a breeding judgement and has no source.
- "o2 modifiers polygenic, unlinked": Holding et al. (2008) Theor Appl Genet 117:157-170, doi:10.1007/s00122-008-0762-y (PubMed 18427771, abstract read) supports it ("multiple, unlinked o2 modifiers"). That paper maps major Opm QTL to chromosomes 1, 7 and 9, and o2 itself is on chromosome 7, so "unlinked" holds for the modifiers as a set rather than for every QTL.

### Checked, no finding
- :161-171: P_same and the values 0.98 against 0.82 at 20 cM, checked algebraically.
- :201-208: (1/2)^4 = 0.0625 and IBD 0.975 at s = 0.6.
- :536-537: Haldane double-recombinant probability 2.26e-3. The 4.6x ratio is arithmetic on the unsourced 4.90e-4 (see 04b-B7).
- :574-576: SE 0.02-0.09 at 30-150 replicates (sqrt(.95*.05/150) = 0.018, sqrt(.25/30) = 0.091).
- :615/:632: expected_ibd(3, 0.5) = 1 - 0.5/16 = 0.969.
- :28: 1670 cM equals sum(maize_chr_len) in R/06_f2size.R:33. No source map is named; see 04-B2.

Citations checked: 0 bib keys (the chapter cites none) and 9 internal @sec-/@fig- refs (not bib). There are 10 findings from check 4: all MISSING SOURCE, with UNVERIFIED sub-items in B4, plus two magnitude conflicts with primary sources (nu in B7, rate variation in B8). Methods:
- 9 candidate DOIs resolved through Crossref.
- Abstracts read through PubMed: Hospital 2001, Frisch & Melchinger 2001 and 2005, Falque 2009, Rodgers-Melnick 2015, Holding 2008, Bhave 1990.
- One full text read: Falque 2009, PMC.
- Arithmetic checked by hand.
