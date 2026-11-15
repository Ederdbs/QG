# 04-population-sizing -- reference check, iteration 1

Chapter: book/04-population-sizing.qmd. Bib: book/references.bib.
Cited keys (9): lee2002, winkler2003, haldane1919, falque2009, zhang2018, lu2002, fisher1954, sedcole1977, caballero2002.
All 9 resolve in references.bib. No Comstock et al. 1949 citation in this chapter. No `@` outside the citations that is a bib key.
Metadata (authors, year, title, journal, vol, issue, pages, DOI) of all 9 checked against Crossref/PubMed: all correct (haldane1919 has no DOI in the bib; see B1).

## Findings

04-B1  haldane1919 (references.bib:1807; qmd:69)  -- UNVERIFIED (full text), metadata OK
 Claim: r = 0.5(1 - exp(-2d/100)) [@haldane1919]. Metadata J. Genet. 8:299-309 confirmed by secondary sources (Cambridge "Genetic mapping in experimental populations" and a bibliography listing; Crossref only has the 2022 Routledge reprint, pp. 385-395, so the bib is right to cite the original). The paper itself was not reachable. The formula is the standard Haldane map function (d in Morgans -> r = 0.5(1 - e^{-2d})), correct. Looked: Crossref, web search. Not read: original paper. Evidence level: none (secondary). No change needed.

04-B2  winkler2003 (qmd:53-56)  -- UNVERIFIED (attribution too strong / not checkable)
 Text: "The junction recursion of P7 predicts expansion of that order [@winkler2003]: g random-mating generations after the F2, followed by selfing to fixation, give (2 + g/2)L junctions per haplotype, i.e. 4L at g = 4 and 4.5L at g = 5."
 Evidence: ABSTRACT only (PubMed 12807793, PMC1462606). The abstract says Winkler et al. derive the expected recombination fraction in IRI populations from the crossover rate per meiosis, for selfing or full-sib inbreeding, and discuss "expansion of genetic maps in IRI populations". It does not give a junction count or the formula (2 + g/2)L. Full text not reachable: PMC page returned abstract + references only (WebFetch), genetics.org returned "Loading...". A further attempt to fetch the PDF was blocked by the sandbox classifier and I did not pursue it.
 Consequence: the citation [@winkler2003] after the sentence about the P7 recursion cannot be confirmed to support the (2 + g/2)L formula or the "4L / 4.5L" numbers. The formula is the chapter's own derivation from the recursion A_{t+1} = A_t + L H_t (Fisher); it is plausible (2L at selfing to fixation + g/2 L from intermating, as in Darvasi & Soller-type expansion) but I did not find it in Winkler. Suggest: either move the citation to "expansion of map length in IRI populations" only, or verify against the full text (Genetics 164:741-745) and quote the equation and page.
 Also note (logic, not source): "nearly four-fold increase" in Lee et al. compares post-intermating vs pre-intermating progeny of the same cross; the chapter's 4L/4.5L are absolute junction counts per haplotype. The comparison "of that order" is valid only if the baseline of the four-fold is L (F2), not 2L (selfed RILs, as in the pre-intermating B73xMo17 RILs); against 2L the prediction at g = 5 is 2.25-fold. The chapter hedges ("does not settle it") but does not state this baseline dependence.

04-B3  lee2002 (qmd:51-52)  -- OK, ABSTRACT
 Quote "nearly a four-fold increase in the genetic map distance" and "five generations of intermating" both verbatim in the abstract (PubMed 11999829, https://doi.org/10.1023/a:1014893521186). Full text not read, but a direct quotation from the abstract is exact. Citation tag "abstract" is accurate.

04-B4  falque2009 (qmd:74-76)  -- OK, ABSTRACT
 "about 15% of crossovers (6% to 23% depending on the chromosome) come from a non-interfering pathway" matches the abstract (Crossref abstract of 10.1105/tpc.109.071514: "6 to 23% depending on the chromosome, with a cell average of ~15%"; PMID 20040539, PMC not available). "Rest from an interfering one" follows from the two-pathway model in the abstract. Per the rules a specific numeric result is nominally FULL TEXT; here the numbers are verbatim in the abstract, so I record ABSTRACT-verbatim. Full text not read (no PMC copy).

04-B5  lu2002 (qmd:88-90)  -- OK, ABSTRACT
 "17% of 1,820 markers across four populations, and 36% in B73/Mo17, with three known gametophytic factors as possible causes": abstract (PMID 12582513, https://doi.org/10.1007/s00122-002-0970-9): "Among 1,820 codominant markers across the four mapping populations, 301 (17%) showed segregation distortion ... 36% in the B73/Mo17 ... Three known gametophytic factors are possible genetic causes". Verbatim match. Full text not read (no OA copy).

04-B6  zhang2018 (qmd:84-86)  -- OK, FULL TEXT
 PMC6131150 read. "Ga1 ... a unilateral cross-incompatibility system whose Ga1 gene acts through male function": the paper clones ZmGa1P, "a pollen/male determinant of the Ga1 locus", UCI "unidirectional ... reproductive barrier". Supported. (The "gametophytic" label is the chapter's own gloss; the paper calls the male determinant pollen-expressed, consistent.)

04-B7  fisher1954 (qmd:128-129; table row "A_2 = L; A_(t+1) = A_t + L H_t")  -- UNVERIFIED
 Text: junction counts "in the sense of @fisher1954: A_t junctions per haplotype in generation t ... H_t the heterozygosity of the parent whose meiosis produces generation t+1". Metadata confirmed (Crossref 10.1038/hdy.1954.17, Heredity 8(2):187-197). Full text not obtained (Nature PDF paywalled; Adelaide repository host unreachable). The recursion is checked only for internal consistency in the chapter (code compares simulation to it); whether it is Fisher's own equation, and the definition of H_t, could not be verified. Looked: Crossref, web search, adelaide repository handle 2440/15155 (unreachable). Evidence: none beyond metadata. Note the wording "in the sense of" is safe; do not upgrade to "Fisher's Eq. X".

04-B8  sedcole1977 (qmd:543-552, eq-sizing-n95)  -- UNVERIFIED (full text), formula checked independently
 Text: "classical number of plants needed to recover a genotype [@sedcole1977]" followed by N95(k) = log 0.05 / log[1 - ((1-H)/2)^k]. Metadata confirmed (Crossref). Abstract (Scilit) only says the note "presents four methods for calculating how many plants must be grown to recover a given number of plants carrying a trait with high probability when the trait occurs at a known frequency". Full text unavailable. The chapter's formula is the generic N = ln(1-P)/ln(1-p) with p = ((1-H)/2)^k, which I checked algebraically: the per-locus P2 homozygote probability in an F4 line with H = 0.125 is (1-H)/2 = 0.4375 (correct) and independent loci multiply. Attribution of the generic formula to Sedcole is reasonable (the note is the classic reference) but could not be confirmed to contain the case "k loci, residual heterozygosity". Wording "the classical number ... [@sedcole1977]" is acceptable; the H-adjusted p is the chapter's own.

04-B9  caballero2002 (qmd:833-836)  -- OK, FULL TEXT
 Text: "With the 0/0.5/1 coding and theta the mean of the molecular coancestry over all pairs of lines, self included [@caballero2002], theta averages p^2 + (1-p)^2 over markers". Local PDF reference/papers/Analysis_of_genetic_diversity_for_the_management_o.pdf (Conservation Genetics 3:289-299), p. 291: "pk,l,i ... = 1 if the individual is homozygote for allele k, 0.5 if heterozygote, and 0 if homozygote for another allele ... All the above measures are calculated for each marker locus, and averaged over loci"; p. 290: fij is the average pairwise coancestry "including all" pairs, and Eq. 5: "average diversity (heterozygosity = 1 - f-bar)". Metadata matches (vol 3, issue 3, pp 289-299, 2002-09, DOI 10.1023/A:1019956205473). The step "theta averages p^2+(1-p)^2" and "GD = mean 2p(1-p) = D/2" is the chapter's own algebra, correct for a single panel with the panel as frequency base.

## Claims without a source (no reference attached)

04-B10  qmd:134 (tbl-cap) "The commonly quoted 0.5/sqrt(N) for SE(p_hat) holds only at F_infinity (H = 0)" -- MISSING SOURCE (minor). It is a straightforward consequence of Var(dosage) = (1-H)/4 shown in the same table; if the "commonly quoted" form is to stay, a primary source would be needed (e.g. Falconer & Mackay, Introduction to Quantitative Genetics, 4th ed., 1996, sampling variance of an allele frequency). I did not find a specific publication using 0.5/sqrt(N) for F4 panels; suggest dropping "commonly quoted" or citing a textbook. 

04-B11  qmd:117, 289-290, 297 (P6 scheme definitions: "single-seed descent", "Wright-Fisher model", "Syn1/Syn2", "coancestry (1 + F_F3)/2") -- MISSING SOURCE (minor). SSD (Brim 1966, Crop Sci. 6:220, doi 10.2135/cropsci1966.0011183X000600030011x), the Wright-Fisher model (Fisher 1930; Wright 1931) and the coancestry between plants of the same line (Falconer & Mackay 1996, ch. 5) are textbook items cited by name only. I did not verify the Brim DOI against the record; propose before adding. No quantitative claim depends on them.

04-B12  qmd:46-48 "lengths ... approximate a composite maize map built without intermating" -- OK as hedged: the chapter states the lengths are a model input, not from a published map. No citation needed; flagged only so that nobody adds one.

## Evidence-level count
Citations checked: 9 keys / 9 text citations.
FULL TEXT: 2 (zhang2018, caballero2002).
ABSTRACT: 3 (lee2002, falque2009, lu2002; all quoted numbers verbatim in abstract).
UNVERIFIED: 4 (winkler2003 -- the (2+g/2)L attribution, fisher1954, sedcole1977, haldane1919).
Metadata correct for 9/9; wrong DOI/year/author: 0. No retractions or corrigenda found on Crossref for these records.
Comstock et al. 1949: not cited in this chapter.
