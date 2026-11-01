# Chapter 06 (book/06-metric-catalogue.qmd) -- reference check, iteration 1

## Findings

### 06-B1 -- WRONG (bib metadata) -- `toro2020` (cited at book/06-metric-catalogue.qmd:130)
- Problem: DOI `10.1111/jbg.12457` resolves to a different paper (Pizarro Inostroza et al., "Non-parametric association analysis of additive and dominance effects of casein complex SNPs ... Murciano-Granadina goats", JABG 137(4):407-422).
- Evidence: Crossref `https://api.crossref.org/works/10.1111/jbg.12457`; correct record is `10.1111/jbg.12455` (Toro, Villanueva, Fernandez, JABG 137(4):345-355; PMID 31713272). Authors, title, volume, pages in the bib are otherwise right (online 2019-11-11, issue 2020; key year fine).
- Fix: `doi = {10.1111/jbg.12455}`.

### 06-B2 -- WRONG (attribution) -- book/06-metric-catalogue.qmd:294-297
- Problem 1: "@lopezcortegano2019 to manage two heterotic-like pools simultaneously". The paper simulates a conservation population of **five** subpopulations (one N = 2000, four N = 100); it never mentions heterotic groups, hybrids or two pools.
- Problem 2: the weighted forms `H_T = D_G + lambda H_S`, `A_T = D_A + lambda A_S` are attributed to @caballerorodriguezramilo2010. In López-Cortegano et al. (2019, Methods) the unweighted H_T partition is credited to Nei (1973), the unweighted A_T = A_S + D_A partition to Caballero & Rodríguez-Ramilo (2010), and the lambda-weighted objectives are the 2019 paper's own (implemented in Metapop2): "maximizing the functions HT = DG + λHS and AT = DA + λAS, respectively, where λ is the desired weight given to the within-subpopulation component." Lambda values tested: 0, 0.5, 1, 1000.
- Evidence: López-Cortegano et al. 2019, doi:10.3389/fgene.2019.00843 (full text, Methods paragraph on Metapop2).
- Fix: e.g. "@caballerorodriguezramilo2010 partition allelic diversity as A_T = A_S + D_A, the allelic analogue of Nei's H_T = H_S + D_G [@nei1973]; @lopezcortegano2019, managing a population subdivided into five subpopulations, maximise the weighted forms H_T = D_G + lambda H_S, A_T = D_A + lambda A_S ...". Drop "two heterotic-like pools", or say the hybrid-breeding two-pool case is this book's analogy.

### 06-B3 -- WRONG (attribution, minor) -- book/06-metric-catalogue.qmd:205-210
- Problem: "Core Hunter 3 [@debeukelaer2018] defines" E-NE and A-NE. Core Hunter 3 implements them but credits them to Odong et al.: "the two improved methods for summarizing distances, entry-to-nearest-entry (E-NE) and accession-to-nearest-entry (A-NE), proposed by Odong et al. [4]". Also the distance `d_ij = 1 - f_ij` is this book's choice; CH3 uses its own marker distances (e.g. Modified Rogers). The formulas themselves match CH3's definitions (A-NE over the whole collection, "including itself in case the accession has been selected"; E-NE maximised, A-NE minimised).
- Evidence: De Beukelaer et al. 2018, doi:10.1186/s12859-018-2209-z (full text read, Background and Methods). Original: Odong, Jansen, van Eeuwijk, van Hintum (2013) "Quality of core collections for effective utilisation of genetic resources review, discussion and interpretation", Theor Appl Genet 126:289-305, doi:10.1007/s00122-012-1971-y (verified on Crossref).
- Fix: "proposed by @odong2013 and implemented in Core Hunter 3 [@debeukelaer2018]; here with d_ij = 1 - f_ij". Add the `odong2013` bib entry.

### 06-B4 -- UNVERIFIED (minor) -- book/06-metric-catalogue.qmd:187-190
- Claim: "Maximising A_T retained more alleles **and** controlled molecular inbreeding better than maximising H_T."
- Evidence: matches the abstract ("the former maintains a larger number of alleles while making a better control of inbreeding"). But the Discussion qualifies it: "Only if all weight in the optimization is given to within-subpopulation variation, maxHT would make the best control of molecular inbreeding", though it still keeps fewer alleles. doi:10.3389/fgene.2019.00843.
- Fix (optional): add "except when all weight is on the within-subpopulation component (lambda -> infinity)". The recommendation at line 197 is faithful.

### 06-B5 -- UNVERIFIED -- `lindgren1997` (book/06-metric-catalogue.qmd:111)
- Metadata (Lindgren, Gea, Jefferson, Forest Genetics 4(2):69-76, 1997) is confirmed only by secondary references; there is no DOI and the full text was not reachable. The attribution N_s = 1/(2 theta) = 0.5/theta matches secondary descriptions ("half the inverse of average coancestry", Gea's PhD thesis).
- Evidence: reference list in Silvae Genetica 47(5-6):321 (1998), https://www.thuenen.de/media/institute/fg/PDF/Silvae_Genetica/1998/Vol._47_Heft_5-6/47_5-6_321.pdf; https://core.ac.uk/download/35468365.pdf.
- Note: the concept was introduced the year before in Lindgren, Gea & Jefferson (1996) "Loss of genetic diversity monitored by status number", Silvae Genetica 45:52-59 (no DOI found). Citing that paper too is optional.

### 06-B6 -- MISSING SOURCE -- book/06-metric-catalogue.qmd:156-158
- Claim: N_e(par) = 1/sum p_i^2, "the inverse Simpson index". There is no citation.
- Proposed sources: Simpson (1949) "Measurement of diversity", Nature 163:688, doi:10.1038/163688a0. For the pedigree use (founder equivalents, 1/sum p_i^2): Lacy (1989) Zoo Biology 8:111-123, doi:10.1002/zoo.1430080203.

### 06-B7 -- MISSING SOURCE (minor) -- book/06-metric-catalogue.qmd:229-231
- Claim: D_eff = (sum lambda)^2 / sum lambda^2 is "the participation ratio". There is no citation.
- Proposed source: Bell & Dean (1970) "Atomic vibrations in vitreous silica", Discuss. Faraday Soc. 50:55, doi:10.1039/df9705000055. This is the usual origin of the term; the paper was not read, only its Crossref record verified.

## Verified, no finding
- `cockerham1967` (line 23): metadata and DOI 10.1093/genetics/56.1.89 correct on Crossref. Group coancestry as the mean over all n^2 pairs, self included, is consistent with the source (full text not re-read).
- `nei1973` (line 74): metadata and DOI 10.1073/pnas.70.12.3321 correct. Gene diversity is 1 - sum p^2.
- `toro2020` (line 130), content: the abstract confirms negative Ne under molecular management and "does not attain an asymptotic value but it shows an unpredictable behaviour". Only the DOI is wrong (06-B1).
- `lopezcortegano2019`, metadata: correct (Front Genet 10:843, doi:10.3389/fgene.2019.00843). The recommendation at line 197 is faithful.
- `debeukelaer2018`, metadata: correct (BMC Bioinf 19:203).
- `caballero2002` (line 253): metadata correct (Conserv Genet 3(3):289-299, doi:10.1023/A:1019956205473). The full text has GD_T = GD_WI + GD_BI + GD_BS weighted by contributions c_i ("GDT = 1 - f̄ = 1 - sum f_ij c_i c_j").
- `caballerorodriguezramilo2010`: metadata correct (Conserv Genet 11(6):2219-2229, doi:10.1007/s10592-010-0107-7). The full text is paywalled; its role is checked only through López-Cortegano 2019's description (see 06-B2).

All 9 `@key` citations (8 distinct keys) resolve in book/references.bib.

Checked: 9 citations / 8 keys. Every DOI was resolved on Crossref. Full text was read for Caballero & Toro 2002, Core Hunter 3 and López-Cortegano 2019 (local PDFs and frontiersin.org). Toro 2020 was checked on its PubMed abstract (PMID 31713272) and Lindgren 1997 through secondary sources only.
