# Reference check: book/00-hybrid-programme.qmd (iteration 1)

Bibliography: book/references.bib. Date: 2026-11-07. Read-only on the book.

Scope: 17 distinct keys, 23 citation occurrences. All 17 keys resolve in references.bib.
All 15 DOIs resolve to the cited paper by Crossref (authors, title, journal, volume, issue,
pages, year); no retraction or update was recorded by Crossref (`updated-by` empty).
The 50 `@sec-/@eq-/@tbl-/@fig-` targets of the chapter all exist.
PubMed-derived items are cited with their DOI links below, as PubMed's terms require.

Severity: HIGH = false statement of a source; MEDIUM = the reader is misled about what a
source shows, or a load-bearing identity is unconfirmed; LOW = metadata, wording, or a
standard statement with secondary corroboration whose primary source was not reached.

## Findings

### 00-B1 -- book/00-hybrid-programme.qmd:274-281 -- WRONG (selective attribution) -- MEDIUM
Key: `kadoumi2025` (FULL TEXT), `vanheerwaarden2012` (ABSTRACT).

Claim: after "within-pool selection and drift push the two pools' frequencies apart, so
between-pool divergence tends to grow while within-pool diversity falls", the text says
"Both trends are reported from genotyped germplasm: between Stiff Stalk and Non-Stiff Stalk
lines over forty years ... with within-group diversity declining [@kadoumi2025]". The caveat
on selection is given for van Heerwaarden only.

Each stated fact is in the source. What is omitted changes what it shows. Text retrieved
from PubMed Central (PMC12397178, [DOI](https://doi.org/10.1007/s00122-025-05008-5); the
article has no page numbers in that text):

- Rise in differentiation is F_ST only: "The value rose from 0.178 ... in era 0 to 0.223 in
  era 4". The between-group distance did not rise: "calculation of pairwise between-group
  Hamming distance for the SS-NSS genotypes was not in accordance with the F[ST] results and
  sustained a small decrease between era 0 and era 4, with a change of - 2.33%".
  This matters for this book: the Hamming distance between inbred parents is the
  heterozygosity of their hybrid, the H_o of chapter lines 349-357. The result is not a
  contradiction of "frequencies apart" (within-group distances fell about 15%, so a Nei
  minimum distance can still grow), but the sentence reads as if divergence simply grew.
- The within-group decline is concentrated in one group: "Individual heterotic groups
  revealed contrasting trends, with He reducing from 0.371 to 0.279 and He remaining stable";
  Hamming loss 16.1% in NSS against 1.4% in SS. (The retrieved text strips the He subscripts;
  NSS falling and SS stable is inferred from the sentences that follow, and from the Hamming
  figures, which are labelled.) The abstract does say "within both groups declined", so the
  book's wording is defensible, but not without this qualification.
- The cause is not the one the preceding sentence gives. Abstract: "The main cause of
  diversity loss germplasm-wide was the merging and genetic homogenization of the ancestral
  Iodent and Lancaster groups into the modern Non-Stiff Stalk heterotic group"; discussion:
  "founder effects within groups, ... gene flow between groups, and ... unrestrained
  admixture". On the divergence itself: "we can only speculate that observed increased
  divergence between heterotic groups ... could originate from the effects of selection".
  The pools of this programme were therefore not closed, which is the condition of A1/A3.

`vanheerwaarden2012` (PubMed abstract, [DOI](https://doi.org/10.1073/pnas.1209275109)):
"increasing genetic separation of breeding pools" and "selection has had limited impact on
genome-wide patterns of diversity and ancestry" support the text. It supports only one of
the "both trends": the abstract reports no within-pool decline, and says "allele frequencies
in the total population have remained relatively constant". The sentence's phrasing is
accurate on this; "Both trends" slightly over-reads it.

Fix suggested: say the rise is in F_ST; add that between-group Hamming distance fell slightly,
that the decline is mainly in NSS, and that the authors attribute it chiefly to the merging
of Iodent and Lancaster and only speculate on selection.
Same claim also at book/11-plant-literature.qmd:135-137 ("single most load-bearing empirical
result"), out of scope here.

### 00-B2 -- book/00-hybrid-programme.qmd:169 -- UNVERIFIED -- MEDIUM
Key: `comstock1949`. Claim: the scheme just described (lines tested in cross, intercrossed
within pool, new DH lines derived) "is reciprocal recurrent selection [@comstock1949]".
Metadata correct. Primary not reached (ACSESS/Wiley 403, Unpaywall: not open access).
Secondary evidence raises a doubt about the identity: Kadoumi et al. (full text, Introduction)
describe the inbred-based form as "tester-based reciprocal recurrent selection (RSS), which
had been conceptualized by Hull", "also named modified reciprocal recurrent selection (MRRS)";
`hull1945` is already in references.bib. Whether the 1949 procedure works on source populations
rather than inbred lines must be read in the original. Until then "a line-based form of
reciprocal recurrent selection" is the safe wording.
Evidence: https://doi.org/10.2134/agronj1949.00021962004100080006x

### 00-B3 -- references.bib `comstock1948` -- WRONG (incomplete) -- LOW
No volume, number or pages; author ends "H. F" without a stop. Should be volume 4, number 4,
pages 254--266 (PubMed PMID 18108899: "4(4):254-66"; Crossref confirms 4(4), first page 254).
Evidence: https://doi.org/10.2307/3001412

### 00-B4 -- references.bib `griffing1956` -- WRONG (incomplete) -- LOW
No volume, number or pages. Should be volume 9, number 4, pages 463--493 (Crossref).
Evidence: https://doi.org/10.1071/bi9560463

### 00-B5 -- book/00-hybrid-programme.qmd:371-373 -- WRONG (overstatement) -- LOW
Claim: f is "the matrix f every diversity metric in the book is computed on [@caballero2002]".
Caballero & Toro support the definition (see table) but not the book-wide scope, and it is
false in this chapter: F_drift (lines 466-468) is computed from allele frequencies against
p_0, not from f. Fix: "the matrix the coancestry-based metrics are computed on", citation
moved to the definition.

### 00-B6 -- book/00-hybrid-programme.qmd:530-531 -- MISSING SOURCE -- LOW
Claim: "Selection makes the realised rate larger, because selected parents contribute
unequally". General causal claim, no citation; @sec-cycles only measures it. Sources found:
- Santiago & Caballero (1995), Genetics 139:1013-1030,
  [DOI](https://doi.org/10.1093/genetics/139.2.1013). PubMed abstract read: N_e under selection
  depends on "the variance of selective advantages among families".
- Robertson (1961), Genetical Research 2:189-194, https://doi.org/10.1017/S0016672300000690.
  Existence and metadata checked on Crossref only; content not read.

### 00-B7 -- book/00-hybrid-programme.qmd:63, 300, 370, 497 -- UNVERIFIED -- LOW
Key: `falconer1996` (4 occurrences, each pinned to a chapter: ch. 5 selfing and coancestry,
ch. 1 Hardy-Weinberg, ch. 3--4 drift and N_e). Bibliographic entry corroborated by a library
record (Longman, 4th ed., 1996); full text not reached, so the chapter pins are not confirmed.
Corroboration is partial: Meuwissen et al. (2020) p. 2 gives "Ne = 1/(2DF) (Falconer and
Mackay, 1996)"; Meuwissen (1997) abstract gives "The average coancestry of the selected parents
equals the inbreeding level in the next generation". Retailer listings seen through a search
summary show ch. 1 "Genetic constitution of a population" and "Small populations: I/II" next.
Ch. 5 title not confirmed. A public archive.org upload of the 4th edition exists; the fetch was
denied by the permission system ("Walled Content from a Copy") and was not retried or worked
around. To close this item, put a copy in reference/ or check the four pins by hand.

### 00-B8 -- book/00-hybrid-programme.qmd:369, 445 -- UNVERIFIED -- LOW
Key: `malecot1948` (book; no online full text found; archive.org title search empty).
Secondary support, FULL TEXT: Caballero & Toro (2002) p. 290, "average pairwise coancestry
(kinship) (Malecot 1948)"; p. 291, "Malecot's (1948) definition". The second occurrence attributes
the definition of F itself to Malecot; no source read says that directly.

### 00-B9 -- book/00-hybrid-programme.qmd:440 -- UNVERIFIED -- LOW
Key: `cockerham1967`. Claim: group coancestry is the mean over pairs, "the diagonal included".
Primary not reached: PMC record has scanned PDF only, `get_full_text_article` returned empty
(PMC1211496, [DOI](https://doi.org/10.1093/genetics/56.1.89)), pmc.ncbi.nlm.nih.gov answered
reCAPTCHA, europepmc.org a Cloudflare challenge, OUP is paywalled, the scispace copy was empty.
Secondary support, FULL TEXT: Caballero & Toro (2002) p. 290, "including all Ni x Nj pairs
(Cockerham 1967)", which for i = j includes self-pairs. The claim that makes @eq-hp-gd exact
is thus corroborated, not confirmed.

### 00-B10 -- book/00-hybrid-programme.qmd:82 -- UNVERIFIED -- LOW
Key: `sprague1942`. "partition into general and specific combining ability defined by".
Metadata correct. Primary not reached (403, not open access). A search snippet of a later
Griffing paper says the terms "were originally defined by Sprague and Tatum (1942)".

### 00-B11 -- book/00-hybrid-programme.qmd:83 -- UNVERIFIED -- LOW
Key: `comstock1948`. "the North Carolina Design II of @comstock1948". Primary not reached
(JSTOR did not load; PubMed has no abstract). Search snippets attribute the design to Comstock
and Robinson 1948, some to 1948 and 1952 jointly. Whether Design II is in the 1948 paper is
not confirmed.

### 00-B12 -- book/00-hybrid-programme.qmd:84 -- UNVERIFIED -- LOW
Key: `griffing1956`. "the notation g, s is that of @griffing1956". Primary not reached (CSIRO
timed out; Unpaywall: not open access; shadow-style copies not used). Search snippet of a
secondary source gives v_ij = g_i + g_j + s_ij. Consistent, not confirmed.

### 00-B13 -- book/00-hybrid-programme.qmd:473 -- UNVERIFIED -- LOW
Key: `wright1951` ("after @wright1951 and @nei1973"). Primary not reached (Wiley 403). Crossref
dates the issue 1949, the DOI carries 1949, the bib says 1951; 1951 is the conventional citation
year for this volume and is not treated as an error, but neither is it confirmed from the paper.
Secondary, FULL TEXT: Caballero & Toro (2002) p. 291 Eq. 8, "GD_BS/GD_T = F_ST", attributing
F-statistics to Wright (1969), not 1951. That identity is the one the sentence states; consider
citing @caballero2002 there as well.

### 00-B14 -- book/00-hybrid-programme.qmd:22-23 -- WRONG (cross-reference wording) -- LOW
Not a citation. The list says it restates A1 as "maintained as closed breeding units". A1 at
book/05-genomic-era.qmd:46 says allogamous, two pools, F1 product; "closed" is not in it, and
recycling within pool is A3. Either drop "closed breeding units" here or point to A1 and A3.

## Citations checked

| Line | Key | Bib | Attribution | Level | Evidence |
|---|---|---|---|---|---|
| 63 | falconer1996, ch. 5 | ok | not confirmed | SECONDARY | 00-B7 |
| 82 | sprague1942 | ok | not confirmed | SECONDARY | 00-B10 |
| 83 | comstock1948 | incomplete | not confirmed | SECONDARY | 00-B3, 00-B11 |
| 84 | griffing1956 | incomplete | not confirmed | SECONDARY | 00-B4, 00-B12 |
| 169 | comstock1949 | ok | doubt | SECONDARY | 00-B2 |
| 279 | kadoumi2025 | ok | selective | FULL TEXT | 00-B1 |
| 280 | vanheerwaarden2012 | ok | faithful | ABSTRACT | 00-B1; PMC tool returned abstract only, PNAS 403 |
| 300 | falconer1996, ch. 1 | ok | not confirmed | SECONDARY | 00-B7 |
| 319 | nei1973 | ok | faithful on "gene diversity (heterozygosity)" | ABSTRACT | PMC427228, [DOI](https://doi.org/10.1073/pnas.70.12.3321) |
| 369 | malecot1948 | ok | not confirmed | SECONDARY | 00-B8 |
| 370 | falconer1996, ch. 5 | ok | not confirmed | SECONDARY | 00-B7 |
| 373 | caballero2002 | ok | faithful | FULL TEXT | p. 291: "obtained by applying Malecot's (1948) definition but referring to identity in state instead of identity by descent"; scope: 00-B5 |
| 385 | eding2001 | ok | faithful | FULL TEXT | Reprint as ch. 2 of Eding's WUR thesis (https://edepot.wur.nl/196514), headed JABG 118:141-159. Eq. 2: E(S_ij,l) = f_ij + (1 - f_ij) s_l; "s = S_ff = sum q_k^2", thesis pp. 10-11. Averaged over loci this is @eq-hp-ibs-ibd. Eding credits the form to Lynch (1988) |
| 440 | cockerham1967 | ok | not confirmed | SECONDARY | 00-B9 |
| 445 | malecot1948 | ok | not confirmed | SECONDARY | 00-B8 |
| 446 | wright1922 | ok | faithful | FULL TEXT | p. 334: "The formula for the correlation between uniting gametes, which is also the required coefficient of inbreeding" (JSTOR Early Journal Content, archive.org jstor-2456273) |
| 468 | meuwissen2020 | ok | faithful | FULL TEXT | p. 4, Eqs. 1A, 1B: F_drift the squared change scaled by p0(1-p0) averaged over loci, "which is never negative"; "Fhom can be negative" |
| 473 | wright1951 | ok (year note) | not confirmed | SECONDARY | 00-B13 |
| 473 | nei1973 | ok | "relative magnitudes of gene differentiation" | ABSTRACT | as line 319; Caballero & Toro Eq. 8 for the ratio |
| 475 | balding1995 | ok | faithful at the level stated ("a single parameter") | ABSTRACT | PMID 7607457, [DOI](https://doi.org/10.1007/BF01441146). The beta form of @eq-balding-nichols (ch. 03) needs full text when that chapter is reviewed |
| 497 | falconer1996, ch. 3--4 | ok | not confirmed | SECONDARY | 00-B7 |
| 541 | meuwissen1997 | ok | faithful | ABSTRACT | PMID 9110204, [DOI](https://doi.org/10.2527/1997.754934x) |
| 542 | meuwissen2020 | ok | faithful | FULL TEXT | p. 2 OC selection and rate of inbreeding; p. 3 "compare alternative genomic- and pedigree-based" tools; p. 3 "unrelated and non-inbred base"; p. 4 "assuming random mating" |

Checked and not flagged as unsourced: the DH definition (line 65), the heterotic-pool definition
(lines 49-52), and the IBD/IBS definitions (lines 361-365), which are definitions, not specific
results; the subset formula (line 224), which is derived in @sec-baseline and whose algebra was
rechecked here. The GCA formula attributed to @sec-mating-estimation (line 100) matches
book/04e-mating-design.qmd:178, and its dominance part book/05b-heterosis-dominance.qmd:788.

## Where primary sources were sought

reference/ (main checkout): Caballero & Toro 2002 and Meuwissen et al. 2020 present, none of the
others. PubMed/PMC tools: full text only for Kadoumi; abstract only for van Heerwaarden, Nei;
empty for Cockerham. Web: Crossref, Unpaywall, publisher pages (ACSESS, Wiley, OUP, PNAS, JSTOR,
CSIRO: 403, paywall or timeout), pmc.ncbi.nlm.nih.gov (reCAPTCHA), europepmc.org (Cloudflare
challenge), WUR repository (Eding thesis obtained), archive.org (Wright 1922 obtained; Falconer &
Mackay denied, see 00-B7). Copies of paywalled papers on third-party sites were not fetched.

Evidence levels, 23 occurrences: FULL TEXT 6, ABSTRACT 5, SECONDARY only (UNVERIFIED) 12.
