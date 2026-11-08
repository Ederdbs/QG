# Reference check: book/01-coancestry.qmd (iteration 1)

Bibliography: book/references.bib. Date: 2026-11-07. Read-only on the book.

Scope: 11 distinct keys, 15 citation occurrences, all 11 keys resolve in references.bib
(falconer1996, vanraden2008, cockerham1967, lindgren1997, malecot1948, caballero2002,
eding2001, nejatijavaremi1997, gomezromano2016, meuwissen2020, toro2014). All 7 `@eq-`,
`@tbl-` and `@sec-` targets exist (sec-hp-cycle, sec-heterosis, sec-genomic-era,
sec-heterosis-flat, sec-simulating-crosses, sec-subdivided are in other chapters; all present).
The 8 DOIs in the bib (vanraden, cockerham, caballero, eding, nejati, gomezromano, meuwissen,
toro) were checked on Crossref: authors, title, journal, volume, issue, pages, year all match;
`updated-by` empty (no retraction or corrigendum). lindgren1997, malecot1948, falconer1996 have
no DOI; Lindgren is confirmed on AGRIS as Forest Genetics 4(2):69-76, 1997, Lindgren, Gea and
Jefferson. Local full text read: caballero2002, gomezromano2016, meuwissen2020
(/Users/ederdbs/Documents/SB_quanti_gen/reference/papers/, via pdftotext). PubMed-derived items
are given with DOI links.

Algebra in the chapter checked independently (no source needed): eq-g05 (2X-1)(2X-1)'/(m/2) = 4f - 2J
(expand: (2X-1)(2X-1)' = 2m f - m J); 2 sum p(1-p) = m/2 at p = 0.5; entries in [-2,2], negative
iff f < 0.5; c'Jc = 1; E[1_S'G1_S] = n(N-n)/(N-1) * mean diag(G) (offdiagonal mean = -mean diag/(N-1)
because 1'G1 = 0); 2(1 - fd) = 1 - F. All correct. The chapter's tests claims
(tests/testthat/test-metrics.R lines 13-17, 29-31, 33-40) match the text at lines 320-329.

Severity: HIGH = false statement of a source; MEDIUM = reader misled about what a source shows;
LOW = wording, terminology, or an item whose primary source was not reached.

## Findings

### 01-B1 -- book/01-coancestry.qmd:255-260 -- WRONG (selective attribution) -- MEDIUM
Key: `gomezromano2016` (FULL TEXT, local PDF).

Claim: "@gomezromano2016 contrast it directly against crossproduct-based matrices: the
allelic-similarity matrix is guaranteed to stay in [0, 1] by construction, while crossproduct
matrices normalised by *current* allele frequencies are not. Their failure is a range violation
(entries below 0 or above 1)."

The contrast is in the paper (p. 4 and p. 12-13 of 17), but three things differ:
- The paper says the range problem applies to "both (the normalised and the un-normalised)
  formulae": "the values for the relationship estimates range from -1 to x, where x can be
  substantially larger than 1 (depending on the allele frequency). This means that relationship
  estimates calculated with these methods can be clearly outside the valid range for a
  coefficient of coancestry (i.e., [0:1])". It then adds: "Practical experience has shown that
  estimates of the average coancestry across the whole genome tend to be within the valid range
  but this may not be the case when considering a smaller region with few genotyped SNPs."
  The chapter omits this qualification; read literally, it says whole-genome crossproduct
  matrices leave [0, 1], which the paper says is not typical. "Current" allele frequencies is
  also not in the paper (p is unspecified there).
- The paper names two further objections that the chapter's "Their failure is a range
  violation" drops: "pair of individuals that are homozygous for the minor allele [get] a higher
  relationship value than ... the most frequent allele" (rare alleles penalised), and "centering
  the genotype score makes the matrix non-invertible". The second is closer to the chapter's
  own point (centering) than range is.
- "Guaranteed ... by construction" is the chapter's inference; the paper says only that the
  allelic-similarity method "has a 'natural' interpretation in relation to the definition of
  the coefficient of coancestry" and that positive definiteness "should hold". The inference is
  mathematically sound (IBS probability), but it is not the paper's wording.
Fix: attribute the [0, 1] violation to the per-SNP formula and to small regions, quote the
whole-genome caveat, and add the minor-allele and non-invertibility points; or say "as
discussed by" rather than "contrast ... guaranteed".

### 01-B2 -- book/01-coancestry.qmd:263-266 -- WRONG (wording) -- LOW
Key: `meuwissen2020` (FULL TEXT, local PDF, Frontiers in Genetics 11:880, p. 3).

Source sentence: "When using 0.5 as the base frequency for all loci, as sometimes proposed, the
relationship matrix GVR0.5 is proportional to homozygosity and molecular coancestry (Toro et al.,
2014). Hence, GVR0.5 may be used to measure homozygosity-based inbreeding, F hom". The quoted
phrase in the chapter matches verbatim, and "citing Toro 2014" is right. But the chapter says
"fixing the VanRaden centering frequency at p_k = 0.5 ... instead of the sample frequency".
Meuwissen et al. contrast 0.5 with the *base-generation* frequency p0 (their GVR1 uses
Z_ij = -2p0j, 1 - 2p0j, 2 - 2p0j with p0 the base frequencies), not with the sample frequency.
Their name is G_VR0.5 (G_0.5 later); the chapter's "G_0.5" is acceptable. The paper gives no
formula or normalisation for G_0.5, so the affine map of eq-g05 (4f - 2J) is the chapter's own
derivation (verified above); "proportional" in the source is looser than "affine", and the chapter
rightly says affine. Fix: "instead of the base-population frequency".

### 01-B3 -- book/01-coancestry.qmd:149-153, 172 -- MISSING CAVEAT -- LOW to MEDIUM
Keys: `caballero2002` (FULL TEXT p. 292), `eding2001` (ABSTRACT).

Claim: replacing identity by descent with identity by state "yields molecular coancestry
[@caballero2002; @eding2001]"; bullet "No centering, no scaling, no arbitrary base population".

Caballero & Toro 2002 p. 292, "Molecular markers": "The molecular coancestry between all pairs of
individuals can be simply obtained by applying Malecot's (1948) definition but referring to
identity in state instead of identity by descent". This supports the definition and the 1 / 0.5 / 0
coding of eq-x-freq. The same paragraph continues: "The results from molecular coancestry will
give exactly the same results as the coancestry from pedigrees ... if there is an infinite number
of loci in the base population with all the alleles in each locus being different. In other cases
... 1 - f_m = (1 - sum p_k^2)(1 - f), where p_k is the allele k frequency in the base population",
and notes that this transformation "is not without problems". Eding & Meuwissen (abstract,
Crossref): "a bias will occur from alleles that are alike in state in the founder population".
So f is IBS coancestry and its relation to IBD coancestry depends on the base population's
allele frequencies; "no arbitrary base population" is true of the computation but the chapter
never says that f is not an unbiased IBD estimate. Not a false statement; a reader could take f as
IBD. Suggest one sentence with the CT2002 relation. Eding & Meuwissen's own definition
(they estimate kinship from markers with a base correction) was not read in full text, so what
exactly the chapter borrows from it is UNVERIFIED; the pair citation is acceptable for "markers
give kinship" but not as a source for the raw IBS formula.

### 01-B4 -- book/01-coancestry.qmd:34-36 -- UNVERIFIED / terminology -- LOW
Key: `falconer1996` ch. 14 (book not available locally or open access).
Claim: heterosis of an F1 between inbred lines = sum of "dominance deviations d_k" over loci where
the parents differ. The result (F1 minus mid-parent = sum of d over differing loci, with y = +-1)
is standard and consistent with Falconer's mean-value treatment of crossbreeding in ch. 14, but
the chapter and page could not be checked against the text. Terminology: in Falconer's notation d
is the *dominance effect* (heterozygote deviation from the homozygote mid-point), whereas
"dominance deviation" is a different term of the genetic-variance partition. Prefer "dominance
effect d_k" (check how chapter 05b names it, for consistency).

### 01-B5 -- UNVERIFIED primaries (no full text reached) -- LOW each
Looked at: PubMed abstracts and metadata, PMC (PMC1211496 has no extractable text), Europe PMC,
Crossref, AGRIS, Wiley and OUP (403 or paywall), WUR repository (no PDF). Third-party copies of
paywalled papers were not fetched, as instructed.
- `cockerham1967` (lines 93): "group coancestry = mean of all n^2 pairwise coancestries, diagonal
  included". Secondary support: Caballero & Toro 2002 p. 290 cite Cockerham 1967 for the mean
  over pairs. Primary page not read. Metadata verified.
- `malecot1948` (line 149): definition of coancestry as the probability that two alleles, one from
  each individual, are identical. Secondary: CT2002 p. 292 ("Malecot's (1948) definition"). The book
  itself was not seen. Metadata (Masson, Paris, 1948) consistent with common citation; not
  independently checked in a catalogue.
- `nejatijavaremi1997` (lines 251-253): the formula f_ij = (1/4) sum_k sum_l delta_kl. PubMed
  abstract (PMID 9222829, [DOI](https://doi.org/10.2527/1997.7571738x)) says only "Total allelic
  relationship ... measures the actual allelic identity between individuals". The formula is
  confirmed in Gomez-Romano et al. 2016 (p. 3: "allelic similarity method proposed by
  Nejati-Javaremi et al. [3]. For a given SNP, the allelic relationship between two individuals
  is (0.25) sum_{i=1}^{2} sum_{j=1}^{2} delta_ij", delta = 1 if allele i of the first equals
  allele j of the second). So the chapter's formula is right, but the attribution to the 1997
  paper rests on a secondary source.
- `lindgren1997` (line 98): N_s = 1/(2 theta). ABSTRACT (AGRIS record): "half the reciprocal of the
  average co-ancestry", which is 1/(2 theta). Full text not read.
- `vanraden2008` (lines 71-74, 266-): eq-vanraden-g and "first parametrisation". Not read in
  primary. Meuwissen et al. 2020 (FULL TEXT, Methods) give "GVR1 = ZZ'/sum_loci H0,k (VanRaden 2008;
  Model 1)", Z_ij = -2p0j, 1 - 2p0j, 2 - 2p0j, with H0,k = 2p0(1 - p0), which matches eq-vanraden-g
  (with sample p in place of base p0). Note this p0 versus sample-p difference is the
  chapter's point and is stated correctly there.
- `eding2001`: see 01-B3 (ABSTRACT only).
- `toro2014`: not claimed for anything beyond what Meuwissen 2020 cites it for; metadata verified,
  content not read (Livestock Science, not in PubMed).

### 01-B6 -- book/01-coancestry.qmd:8-12 -- MISSING SOURCE / opinion -- LOW
"Using the first for the second is the most consequential mistake available in this subject" is
rhetorical and uncited. If kept, support with the demonstrations in Meuwissen et al. 2020
(doi 10.3389/fgene.2020.00880: GVR1/GVR2 versus G_0.5 behaviour under management) and Gomez-Romano
et al. 2016 (doi 10.1186/s12711-015-0172-y), or soften to "a common mistake".

## Verified without findings (FULL TEXT)
- Line 149-153 / `caballero2002`: molecular coancestry as Malecot with IBS: p. 292 (above).
- Line 166-171: s_i = (1 + F_i)/2: Caballero & Toro 2002 p. 290, "The average coefficient of
  inbreeding of subpopulation i is F_i = 2 s_i - 1". The pointer to Falconer ch. 5 for the IBD form
  is not checked in the book itself (UNVERIFIED, standard result).
- Line 251-255: formula and the claim that it equals the IBS average of eq-f-molecular: for a
  biallelic locus (1/4) sum delta = x_i x_j + (1 - x_i)(1 - x_j); checked algebraically.
- Line 263-266: `meuwissen2020` quotation "proportional to homozygosity and molecular
  coancestry" and "citing Toro 2014": p. 3 of the Frontiers PDF, verbatim.
- Metadata of all eight DOI entries: Crossref.

## Tally
Keys checked: 11. Citation occurrences: 15.
Evidence level per key: FULL TEXT 3 (caballero2002, gomezromano2016, meuwissen2020);
ABSTRACT 3 (eding2001, nejatijavaremi1997, lindgren1997); metadata only, content UNVERIFIED 5
(cockerham1967, malecot1948, falconer1996, vanraden2008 [secondary full text via Meuwissen 2020],
toro2014).
Findings: HIGH 0; MEDIUM 1 (01-B1); LOW 5 (01-B2 to 01-B6, of which 01-B3 is LOW to MEDIUM and
01-B4/01-B5 are UNVERIFIED items). Metadata WRONG: 0. Uncited bib entries are not assessed
(chapter mode).
