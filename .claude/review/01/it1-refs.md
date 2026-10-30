# Ch. 01 (01-coancestry.qmd) -- reference check, iteration 1

Keys cited: caballero2002, caballero2000, nejatijavaremi1997, gomezromano2016, toro2014, meuwissen2020. All six resolve in book/references.bib.

## Findings

### 01-B1 -- toro2014 (bib) -- WRONG
The bib entry has the wrong journal, title, pages and DOI. DOI 10.1111/age.12140 resolves to Doherty, Farrelly & Meade (2014), "Comparative epigenetics: relevance to the regulation of production and health traits in cattle", Anim. Genet. 45(s1):3-14 (Crossref).
The paper that the chapter means, which Meuwissen et al. 2020 also cite for G_0.5, is:
Toro, M. A., Villanueva, B., Fernandez, J. (2014). Genomics applied to management strategies in conservation programmes. *Livestock Science* 166:48-53. doi:10.1016/j.livsci.2014.04.020
Checked with Crossref and with the reference list of Meuwissen et al. 2020 (https://www.frontiersin.org/articles/10.3389/fgene.2020.00880/full).
Fix: replace title, journal, volume, pages and DOI. Drop `number`. No other chapter cites toro2014.

### 01-B2 -- 01-coancestry.qmd:120 (caballero2000) -- UNVERIFIED (attribution doubtful)
The chapter cites @caballero2000 for the IBS molecular coancestry. The Genet. Res. 75:331-343 abstract (Europe PMC) deals only with pedigree tools: effective number of founders, founder genome equivalents, Ne and genealogical coancestry. Molecular markers are not mentioned. I could not reach the full text.
The bib metadata is correct. Crossref gives the journal name as "Genetical Research", while the bib says "Genetics Research", which is the journal's later name. Change it to "Genetical Research" if you want the name used at publication.
Suggestion: cite only @caballero2002 here, and if you want a second primary source for marker-based kinship add Eding & Meuwissen (2001), J. Anim. Breed. Genet. 118:141-159, doi:10.1046/j.1439-0388.2001.00290.x (checked with Crossref; not in the bib).

### 01-B3 -- 01-coancestry.qmd:65 -- MISSING SOURCE
"This is VanRaden's first parametrisation" has no citation. Add @vanraden2008, which is already in the bib: J. Dairy Sci. 91:4414-4423, doi:10.3168/jds.2007-0980. Its metadata matches the reference list of Meuwissen et al. 2020.

### 01-B4 -- 01-coancestry.qmd:116 and 133 -- MISSING SOURCE
"Malecot's coancestry" and the identity f_ii = (1+F_i)/2 have no citation. @malecot1948 and @falconer1996 are both in the bib.
Side note on the bib (outside this chapter): malecot1948 is typed @article but holds a book (publisher, address). It should be @book. cockerham1967 is typed @incollection but is a journal article (Genetics 56:89-104) and has no DOI. Its DOI should be 10.1093/genetics/56.1.89, which I did not resolve.

### 01-B5 -- 01-coancestry.qmd:92 -- MISSING SOURCE
"the status number N_s = 1/(2 theta)" has no citation. @lindgren1997 is in the bib (Forest Genetics 4:69-76). I could not resolve it online because it has no DOI, so its metadata is UNVERIFIED.

### 01-B6 -- 01-coancestry.qmd:202-206 (meuwissen2020, toro2014) -- verified, with one wording point
Meuwissen et al. 2020 (full text, Frontiers) say: "the relationship matrix G_VR0.5 is proportional to homozygosity and molecular coancestry (Toro et al., 2014)". The chapter's claim is therefore faithful to Meuwissen 2020. The Toro 2014 paper itself (Elsevier) was not reachable, so its part of the claim is UNVERIFIED and rests on Meuwissen's citation.
Wording point: with 0/1/2 coding and p = 0.5, f = (J + G_0.5/2)/2. The relation is affine, not strictly proportional. "proportional" quotes the source, but "Structurally that is f" (line 206) would be more exact as "an affine function of f".

### 01-B7 -- 01-coancestry.qmd:193-200 (nejatijavaremi1997, gomezromano2016) -- verified
I read the Gomez-Romano et al. 2016 full text (Europe PMC, PMC5518098). It uses the Nejati-Javaremi allelic-similarity method 0.25 * sum_{i,j} delta_ij, calls it the "natural" interpretation of coancestry, and states that crossproduct matrices (x_i - 2p)(x_j - 2p)[/2p(1-p)] "range from -1 to x, where x can be substantially larger than 1 ... outside the valid range for a coefficient of coancestry (i.e., [0:1])". The chapter's claim is supported.
Two nuances:
- The paper argues this analytically in its Background and Discussion. It is not an empirical head-to-head comparison, so "contrast it directly" is acceptable.
- It does not use the word "current" frequencies.
The exact form of the Nejati-Javaremi 1997 formula (J. Anim. Sci. full text) was not reachable. The 1997 abstract defines "total allelic relationship" as actual allelic identity, so the formula's form and scaling are UNVERIFIED in the primary source, and are confirmed only through Gomez-Romano's restatement.

### 01-B8 -- 01-coancestry.qmd:120 (caballero2002) -- UNVERIFIED (full text unreachable)
The metadata matches Crossref: Conserv. Genet. 3(3):289-299, 2002, doi:10.1023/A:1019956205473. The Springer full text is paywalled. Secondary sources describe the paper as using marker-based molecular coancestry: Toro & Caballero 2005 (https://pmc.ncbi.nlm.nih.gov/articles/PMC1569508) and the UVigo record (https://portalcientifico.uvigo.gal/documentos/5fa081f0299952440aae98a0). The attribution is plausible but not confirmed against the original text.

## Metadata OK (Crossref)
- caballero2002: OK
- caballero2000: OK apart from the journal name in 01-B2
- nejatijavaremi1997: OK (75(7):1738-1745)
- gomezromano2016: OK (GSE 48:2)
- meuwissen2020: OK (Front. Genet. 11:880)

## Coverage
6 of 6 keys checked: DOIs resolved on Crossref, abstracts from Europe PMC, full texts read for Gomez-Romano 2016 and Meuwissen 2020. Toro 2014, Caballero & Toro 2002/2000 and Nejati-Javaremi 1997 full texts were not reachable, so those attributions are marked UNVERIFIED. 3 uncited claims (VanRaden, Malecot, status number) are matched to keys already in the bib.
