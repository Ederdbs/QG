# 04d-breeding-programme -- references check, iteration 1

Chapter: book/04d-breeding-programme.qmd. Bib: book/references.bib.
Cited keys in the chapter: gaynor2017 (lines 21, 253, 334, 416), meuwissen2001 (line 253). No other bib key.
Comstock 1949 (comstock1949): NOT cited in 04d (grep count 0). Nothing to flag for 04d on it. Bib entry exists (references.bib:475) with exactly the
authors/title/journal given in the task; I did not and could not read the paper (existence and title only).
All 11 internal @sec- anchors resolve: sec-plant-literature (11-plant-literature), sec-alphasimr (04c), sec-response (02b), sec-genomic-prediction (08b),
sec-limits (11c), sec-baseline (06), sec-sizing (04), sec-combinatorial (10), sec-ocs (09), sec-cycles (11b), sec-genomic-era (05). "Seventh consequence"
(line 9) matches item 7 of "Consequences for the pipeline" in 11-plant-literature.qmd:677-700 ("Report the diversity cost per cycle explicitly when shortening cycles").
Ignored: `@pheno`, `@ebv`, `@gv` inside R chunks (AlphaSimR slots).

## Metadata (check 1)

- gaynor2017: OK. Full-text PDF on disk (reference/AlphaSimR_Course/"Crop Science - 2017 - Gaynor - A Two-Part Strategy ...pdf"): Crop Sci. 57(5):2372-2386, 2017,
  eight authors in the bib order, DOI 10.2135/cropsci2016.09.0742 (DOI resolves to Wiley/ACSESS record; abstract also matched via ANU repository and Consensus). No retraction/corrigendum seen.
- meuwissen2001: OK. PubMed PMID 11290733 / PMC1461589: Genetics 157(4):1819-29, Apr 2001, Meuwissen, Hayes, Goddard, DOI 10.1093/genetics/157.4.1819.

## Findings

### 04d-B1  line 334-336 -- WRONG attribution (gaynor2017)  [FULL TEXT]
Text: "Genomic selection raises the rate of gain by roughly half, and the paired t-statistic leaves no doubt about the sign. That is the result @gaynor2017 reports
and the reason two-part strategies were adopted."
- Gaynor et al. report no "roughly half" figure. Reported ratios (p. 2379, Results): Conv GS (GS with no cycle shortening) = 1.21x (95% CI 1.18-1.25, G x Y variance 0) and 1.39x
  (1.23-1.58, G x Y 10) the genetic gain of Conv; two-part (2Part+H) = 2.36x (2.08-2.67) [G x Y 10] and 2.47x (2.36-2.59) [G x Y 0] Conv, and 1.31x (1.20-1.43) / 1.46x (1.36-1.57) the best
  standard GS strategy (Head GS). The ratio for the strategy this chapter actually mimics (PYT GS: genomic selection in PYT, parents recycled from PYT) is shown only in Fig. 4, not in the text.
  What Gaynor does support: all GS programmes gained more than Conv, and ranking by cycle time = ranking by gain (perfect rank correlation, p. 2381-2382).
- "the reason two-part strategies were adopted": Gaynor proposes the two-part strategy; the paper says nothing about its adoption. The chapter's own arm is a PYT-recycling strategy, not a two-part programme
  (no separate population-improvement component, no two cycles per year). Historical claim with no source; delete or reword ("qualitatively the direction Gaynor et al. report").
- Also: "roughly half" is the chapter's own simulated number; the frozen output shows mean paired gain difference 0.0285/yr (t = 8.09) but the baseline rate is not printed, so the "half" figure
  itself is UNVERIFIED here (the ratio is not in the frozen markdown; I did not re-run the chapter).

### 04d-B2  line 252-254 -- UNVERIFIED / weak (gaynor2017; meuwissen2001)  [gaynor2017 FULL TEXT; meuwissen2001 ABSTRACT only]
Text: "Genomic selection ... buys two things, and the second [shorter generation interval] is normally the larger (@gaynor2017; @meuwissen2001)".
- gaynor2017: supports it for the two-part programmes only: "In the two-part programs, the shortening of breeding cycle time was the major driver of increased genetic gain" (p. 2381) and
  "perfect rank correlation between the cycle time of a breeding program and the genetic gain that it produced" (p. 2382), citing Heffner et al. (2009) for "the greatest benefit of genomic selection for genetic gain in crops
  will come from decreased cycle time". But it also says Conv GS (accuracy only) gained 1.21-1.39x, and that "improved selection accuracy and/or decreased cycle time underpinned the increased genetic gain" (p. 2381). "normally the larger"
  generalises one simulation; soften to "in Gaynor et al.'s simulations".
- meuwissen2001: abstract only says selection on marker-predicted values "could substantially increase the rate of genetic gain in animals and plants, especially if combined with reproductive techniques
  to shorten the generation interval". That is a one-clause conclusion, not a comparison of two levers. I could not reach the full text (PMC page returns abstract only; PDF endpoints at PMC, Europe PMC, OUP and genetics.org
  blocked; no local copy in reference/papers). UNVERIFIED beyond the abstract. Suggest dropping @meuwissen2001 here or adding "in the animal setting" and, if a primary source on generation interval is wanted, Heffner et al. (2009) Crop Sci 49:1-12 (cited by Gaynor; not checked by me, so not proposed as verified).

### 04d-B3  line 21 and 416 -- scheme provenance / scale claim (gaynor2017)  [FULL TEXT for Gaynor; course .Rmd on disk]
- Line 21 "The scheme is the wheat programme of @gaynor2017, reduced in scale": the staged structure (DH -> headrows -> PYT -> AYT -> EYT -> variety, replication 1/4, 1, 4, 8 locations, h2 0.1/0.2/0.5/0.67) is Gaynor's (pp. 2375-2376).
  The actual numbers (20 crosses, 400 DH, 60/12/4 entries, 40 founders, 600 loci) come from the AlphaSimR course vignette Week_5_C ("simulate the wheat breeding programme described in Gaynor et al. (2017) ... we have here reduced the number of individuals").
  The chapter never cites the course (bib key gorjanc2022 exists, references.bib:722; 04c cites it). Add [@gorjanc2022] on line 21 or 52 ("the course this scheme comes from" is otherwise an unreferenced source).
  Also, Gaynor's conventional programme has parent recycling from PYT/AYT/crossing block and 4-yr cycle; the chapter's phenotypic arm recycles from EYT+AYT only. Fine as a simplification, but not "Gaynor's".
- Line 416 "@gaynor2017's programme is an order of magnitude larger in every dimension": WRONG as stated. Gaynor: 50 founders (chapter 40), 100 crosses/yr (20; 5x), 100 DH/cross (20), 10,000 headrows (400; 25x), 500 lines to PYT (60; ~8x),
  50 to AYT (12; ~4x), 10 EYT (4; 2.5x), 21,000 QTN + 21,000 SNP (600 loci; 35x), 40 simulated years (15). Reword to "larger in most dimensions (headrows 25x, loci 35x, crosses 5x, founders about the same)".

### 04d-B4  lines 28 (fig-cap) -- internal inconsistency, no source needed
Caption: "Entries fall by roughly an order of magnitude at each stage". Chapter's own numbers: 400 -> 60 -> 12 -> 4 = factors 6.7, 5, 3. Not an order of magnitude each. (Text line 48 says only "entries fall" -- fine.)

### 04d-B5  lines 338-345 -- MISSING SOURCE / unsupported mechanism
Text: diversity is lower under GS "for a reason that is structural rather than incidental: recycling parents from the preliminary trial means recycling them a year before the trial data could have distinguished full sibs,
so the parents chosen are more closely related...". Neither tested in the chapter nor cited. Gaynor's discussion (pp. 2382-2383) gives a different mechanism for genetic *variance* loss under GS: the initial drop "is mostly due to increased selection accuracy
in early stages... Bulmer effect" and further loss depends on cycle time/effective size; Gaynor also notes OCS as the remedy (p. 2382). Note this is variance, not molecular gene diversity, so it supports the direction (GS programmes lose variance, "rapid depletion of genetic variance")
but not the full-sib mechanism. Either test the mechanism (e.g. mean within-family coancestry of the parent set per arm) or mark it as a hypothesis. Candidate source for the direction: Gaynor et al. 2017, doi:10.2135/cropsci2016.09.0742, pp. 2379, 2382-2383 (FULL TEXT read).
The chapter's recommended-remedy sentence (lines 386-391) lines up with Gaynor's statement that OCS and introgression are the established solutions, and could cite it.

### 04d-B6  line 22-23 -- MISSING SOURCE (qualitative, low priority)
"it is the shape most public and many commercial line-breeding programmes actually have" -- no citation. I did not find a source in the time spent; propose Bernardo (2014) *Essentials of Plant Breeding* (cited by Gaynor as the reference for inbred-line programme design) only if the author has it; not verified by me.

### 04d-B7  line 253 -- gaynor2017 and the "genomic selection arm" (note)
Gaynor's GS programmes were run at equal operating cost (fewer DH lines per cross to pay for genotyping, Table 1, p. 2377); the chapter's GS arm adds accuracy and a shorter cycle at zero cost. So the chapter's gain ratio is not comparable to Gaynor's cost-matched ratios. Worth a sentence next to line 334.

### Comstock 1949
Not cited in this chapter. No attribution to check. (Elsewhere: 00-hybrid-programme.qmd:211, 04c:62, 04c:1021, 05-genomic-era.qmd:92 handle it as "the paper the book cites"; outside this task.)

## Where I looked
Local: reference/AlphaSimR_Course/ (Gaynor 2017 PDF, Week_5_C vignette .Rmd), reference/papers (no Meuwissen). PubMed/PMC: Meuwissen metadata + PMC1461589 (full_text empty; PMC HTML abstract only).
Web: doi.org -> Wiley (403), ANU repository, Consensus (Gaynor abstract), Europe PMC/OUP/genetics.org PDF endpoints (blocked/HTML challenge). Meuwissen full text UNVERIFIED.

## Evidence counts
Citation instances checked: 5 (gaynor2017 x4: lines 21, 253, 334, 416; meuwissen2001 x1: line 253). FULL TEXT: 4 (all gaynor2017). ABSTRACT only: 1 (meuwissen2001, UNVERIFIED beyond abstract). Metadata checked for 2 of 2 keys. Comstock 1949: 0 citations in 04d.
