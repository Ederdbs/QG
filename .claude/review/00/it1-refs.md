# Chapter 00 (book/00-hybrid-programme.qmd), references review, iteration 1

Bibliography: book/references.bib (from `bibliography: references.bib` in book/_quarto.yml).
Read-only review. No chapter or bib file was modified.

## Findings

### 00-B1: WRONG (minor), the Sprague & Tatum attribution at line 79
- Location: book/00-hybrid-programme.qmd:79 ("The cross means are read through the two-way model of @sprague1942").
- Problem: Sprague & Tatum (1942) introduced the *concepts* of general and specific combining ability, and partitioned single-cross variance into GCA and SCA. The explicit two-pool linear model y_ij = mu + g^A_i + g^B_j + s_ij + e_ij (a North Carolina Design II / factorial between two sets) is the formalism of Comstock & Robinson (1948) and, for diallels, Griffing (1956). Both are already in references.bib (`comstock1948`, `griffing1956`). I did not read the full text of Sprague & Tatum, so the claim that the paper does not state the model in this form is UNVERIFIED.
- Evidence: Sprague & Tatum, https://doi.org/10.2134/agronj1942.00021962003400100008x; Comstock & Robinson 1948, Biometrics 4:254, https://doi.org/10.2307/3001412; Griffing 1956, Aust J Biol Sci 9:463-493, https://doi.org/10.1071/BI9560463.
- Fix: "... read through the GCA/SCA decomposition of @sprague1942, written for a factorial between two sets of lines as in @comstock1948 [see also @griffing1956],".

### 00-B2: WRONG (metadata, minor), `sprague1942` has no DOI
- Bib key: sprague1942.
- Problem: the DOI field is missing, while every other journal entry the chapter cites has one. The volume, pages and year are correct. Crossref gives the container as "Agronomy Journal", the journal's later name; "Journal of the American Society of Agronomy" is the 1942 title and is fine.
- Evidence: https://doi.org/10.2134/agronj1942.00021962003400100008x resolves to "General vs. Specific Combining Ability in Single Crosses of Corn", Sprague, Tatum, vol 34, pp 923-932, 1942-10.
- Fix: add `doi = {10.2134/agronj1942.00021962003400100008x}`.

### 00-B3: WRONG (metadata, minor), `wright1922` has no DOI
- Bib key: wright1922.
- Problem: the DOI field is missing. The other fields are correct.
- Evidence: https://doi.org/10.1086/279872 resolves to "Coefficients of Inbreeding and Relationship", Wright, Am Nat 56:330-338, 1922.
- Fix: add `doi = {10.1086/279872}`.

### 00-B4: Note (not an error), the year of `wright1951`
- Bib key: wright1951.
- Observation: Crossref dates Annals of Eugenics vol 15 to 1949 (DOI suffix `1949.tb02451.x`). The paper is conventionally cited as Wright (1951), its actual publication year. The bib entry, with year 1951 and the 1949 DOI, is consistent with standard usage. No change is needed.
- Evidence: https://doi.org/10.1111/j.1469-1809.1949.tb02451.x resolves to "The genetical structure of populations", Wright, Ann Eugen 15:323-354.

### 00-B5: Nuance, Wright (1922) at line 365
- Location: book/00-hybrid-programme.qmd:365 ("the probability that its two alleles at a locus are IBD [@wright1922; @malecot1948]").
- Observation: Wright (1922) defined F as a correlation between uniting gametes. The probability-of-IBD definition is Malécot's. Because the two are cited together the attribution is acceptable, but a precise wording would be "defined by @wright1922 as a correlation between uniting gametes and by @malecot1948 as a probability of identity by descent". Optional.

### 00-B6: UNVERIFIED, Cockerham (1967) at line 360
- Location: book/00-hybrid-programme.qmd:359-360 ("Group coancestry ... the diagonal included [@cockerham1967]").
- Status: the bib metadata is correct (DOI resolves: Genetics 56:89-104, 1967). The full text is paywalled at academic.oup.com, and I could not reach a PMC copy, so I could not check that Cockerham's group coancestry includes self-coancestries. This matches the standard reading of the paper, but it is not checked.

### 00-B7: MISSING SOURCE, growing between-pool divergence (lines 209-212)
- Location: book/00-hybrid-programme.qmd:209-212 ("within-pool selection and drift push the two pools' frequencies apart, so between-pool divergence tends to grow ... the commercial evidence collected in @sec-plant-literature").
- Problem: this is a specific empirical and historical claim. It points only to an internal section and cites no primary source here.
- Proposed primary source (verified, not yet in references.bib): van Heerwaarden, Hufford & Ross-Ibarra (2012), "Historical genomics of North American maize", PNAS 109:12420-12425, https://doi.org/10.1073/pnas.1209275109. The abstract (via PubMed, PMID 22802642) reads: "a steady increase in genetic differentiation ... associated with increasing genetic separation of breeding pools" and "modern heterotic groups are the product of ongoing divergence".
- Checked and NOT proposed: Reif et al. (2005), TAG 111:838-845, https://doi.org/10.1007/s00122-005-0004-5. Its abstract reports that dent and flint were "clearly separated already at the beginning" and that within-variety diversity decreased. It does not state that between-group divergence grew, so it does not support this sentence.

## Citations checked and found correct (no finding)
- falconer1996 (Longman, 4th ed., 1996). The chapter pointers ch. 1 (Hardy-Weinberg), ch. 3-4 (small populations, N_e) and ch. 5 (selfing, coancestry and inbreeding of the progeny) match the 4th-edition table of contents (from knowledge; book not opened).
- comstock1949: the DOI resolves to the RRS paper, Agron J 41:360-367, 1949. The attribution of reciprocal recurrent selection is correct.
- nei1973: the DOI resolves, PNAS 70:3321-3323. Gene diversity and the H_T/D_ST partition are correctly attributed.
- malecot1948 (Masson, Paris, 1948): the coancestry-as-probability-of-IBD attribution is standard. The book was not opened.
- caballero2002: the DOI resolves, Conserv Genet 3:289-299. Molecular coancestry and the GD partition are correctly attributed.
- eding2001: the DOI resolves, JABG 118:141-159. The similarity form f + (1 - f)s is the one they use.
- meuwissen2020: the DOI resolves, Front Genet 11:880. The full text confirms that F_drift is the sum over loci of (p_t,k - p_0,k)^2 / [p_0,k(1 - p_0,k)], averaged over loci, and "never negative", and that "F_hom can be negative". Line 386 is faithful.
- wright1951: F_ST attribution correct (see 00-B4).
- balding1995: the DOI resolves, Genetica 96:3-12. Correct for the Balding-Nichols F.
- meuwissen1997: the DOI resolves, J Anim Sci 75:934-940. Correct for optimal contributions.
- cockerham1967: the metadata is correct (attribution UNVERIFIED, see 00-B6).

Every @key in the chapter resolves in references.bib. The 13 distinct keys appear 19 times; none is missing.

Count: 13 distinct keys (19 uses) checked. I resolved 11 DOIs by Crossref content negotiation, plus 2 already-in-bib alternatives and 2 candidate DOIs. I fetched the full text of meuwissen2020 and got abstracts of the proposed sources via PubMed. Cockerham's full text was not reachable, and the books (Falconer & Mackay, Malécot) were not opened.
