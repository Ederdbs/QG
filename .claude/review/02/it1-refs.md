# 02-subdivided -- references, iteration 1

Citation keys in the chapter: **one**, `@caballero2002` (:10). It resolves in book/references.bib.
Metadata matches Crossref: Caballero A. & Toro M.A., Conserv. Genet. 3(3):289-299, 2002, doi:10.1023/A:1019956205473 (same result as 01-B8 and 04g-B5).
The chapter makes about a dozen further attributions to "the paper" (equation numbers, tables, published values, errata). None of them carries a key.
The full text of Caballero & Toro 2002 was **not reachable**: Springer redirects to a login, and the CSIC repository (digital.csic.es/handle/10261/294880) sits behind a bot wall.
Where possible I cross-checked against the same authors' open-access restatement: Toro & Caballero 2005, Phil. Trans. R. Soc. B 360:1367-1378, doi:10.1098/rstb.2005.1680 (PMC1569508, full text read).
The local notes in reference/caballero_toro/ are a secondary summary, not the paper. They were used only to tell where the book contradicts its own provenance.

## Findings

**02-B1 -- UNVERIFIED (plus a cross-book inconsistency)** -- `02-subdivided.qmd:193` ("Caballero & Toro 2002, Eq. 7")
The partition GD_T = GD_WI + GD_BI + GD_BS is attributed to Eq. 7. The same number appears at 05-genomic-era.qmd:198,1225 and R/07_caballero_toro.R:15,91.
Three places say **Eq. 8** for the same partition: 91-package.qmd:144 ("Caballero & Toro Eq. 8 over the heterotic pools"), CLAUDE.md, and by extension the `gd_partition()` doc.
The local reading notes assign Eq. 7 to the partition and Eq. 8 to the ratio identities (chapter :198-201). That suggests 91-package/CLAUDE.md are the ones that are off.
The equation number cannot be confirmed without the full text. Toro & Caballero 2005 §3a restates the partition (f_bar = f~ - D_bar, GD_B = f~ - f_bar, F_ST = D_bar/(1 - f_bar)) without equation numbers.
Action: check against the PDF, then make the whole book use one number.
Evidence: https://doi.org/10.1023/A:1019956205473 ; https://pmc.ncbi.nlm.nih.gov/articles/PMC1569508/

**02-B2 -- WRONG (internal) / UNVERIFIED (source)** -- `:140-142` ("The paper's Eq. 13 computes D_ij ... the identity D_ij = (s_i + s_j)/2 - f_ij is exact")
At :128 the chapter defines Nei's minimum distance as D_ij = (f_ii + f_jj)/2 - f_ij. The callout then calls (s_i + s_j)/2 - f_ij "exact" for the same D_ij. Both cannot hold unless s_i = f_ii, which is the panmixia-free special case G_i = 1.
Under HWE, s_i = (1 + f_ii)/2 != f_ii. The two expressions differ by [(s_i - f_ii) + (s_j - f_jj)]/2, which is (G_i(1 - f_ii) + G_j(1 - f_jj))/2.
(s_i + s_j)/2 - f_ij is the mean distance between *individuals* of i and j, not Nei's D_m between subpopulations.
Either Eq. 13 computes the between-individual distance, in which case the callout should name a different symbol, or the identity is wrong. Which one Eq. 13 is cannot be checked without the full text.

**02-B3 -- UNVERIFIED (equation number and F index)** -- `:318-322` ("The paper's Eq. 14 ... equal contributions (S_W^2 = S_B^2 = 0), N_e ≈ 2Nn/(1 - F_IT) -- roughly double ... random (Poisson)")
Toro & Caballero 2005 restate the Caballero & Toro 2002 expression "assuming random mating within populations" as N_e ≈ 2Nn / [(V_W + V_B + 1)(1 - F_ST)]. V_W = 0 gives 2Nn/(1 - F_ST), "a doubling", against the Poisson case V_W = 1, V_B = 0 → Nn/(1 - F_ST) (Wright 1943).
The doubling claim is **supported**. The restatement uses **F_ST**, not F_IT, and calls the variances V_W/V_B, not S_W^2/S_B^2.
F_IT = F_ST only when F_IS = 0, so the chapter's form may be the 2002 general version, but I cannot confirm that. The "Eq. 14" number is UNVERIFIED.
The chapter is also internally inconsistent: :366 cites **Eq. 15** for the same conclusion (equal contributions maximise N_e). Check whether both numbers are right.
Evidence: PMC1569508, §4a.

**02-B4 -- UNVERIFIED** -- `:362-363` (erratum "Table 2b lists F_2 = 0.8383")
Table 2b is not reachable. The arithmetic holds only if s_2 is the exact 11/12: 2(0.9167) - 1 = 0.8334 as printed, and 2(11/12) - 1 = 0.8333. Suggest writing s_2 = 11/12.
Also missing: Toro & Caballero 2005, Table 4, footnote a, is the authors' own published correction to Caballero & Toro 2002 (pig reanalysis, DESH row: "This corrects a mistake in Caballero & Toro (2002)"). A section titled "Two errata, found while verifying" should mention it.

**02-B5 -- UNVERIFIED (high priority)** -- `:364-368` (conceptual erratum, quoting the Discussion: equal contributions required "to minimise effective size" and "maximise mean coancestry")
These are direct quotations attributed to the source, presented as an error *in* the source. They must be checked word for word against the PDF before publication. The full text was not reachable.
The 2005 restatement says the opposite (equalisation "gives a doubling of effective size"), so the authors' intended meaning matches the chapter's correction. Whether the 2002 Discussion actually contains the inverted wording is unconfirmed.

**02-B6 -- UNVERIFIED (values) / internally reproduced** -- `:222-300` (worked example: f matrix, N = 12/4/8/6, three loci with 5/3/3 alleles, s~ = 0.7056, published column, c = (0.522, 0, 0.270, 0.208), "Weitzman 65.5%")
I could not check the published tables. I re-ran the chunk's arithmetic: f_bar 0.3256, f~ 0.4535, GD_T 0.6744, GD_WI 0.2944, GD_BI 0.2521, GD_BS 0.1279, F_ST 0.1897.
The QP (quadprog) gives c = (0.522, 0.000, 0.270, 0.208) and GD_max = 0.6874. Removing Sub2 gives +1.84% (census weights) and +6.47% (equal weights). GD_BS/GD_T = 18.97%.
All of this matches the prose. The "published" numbers themselves and the 65.5% Weitzman loss need a check against the PDF tables.

**02-B7 -- MISSING SOURCE** -- `:310-314` ("max c'g - λ c'Fc ... Meuwissen's framework")
No key, though `meuwissen1997` is in the bib (Crossref: J. Anim. Sci. 75:934-940, doi:10.2527/1997.754934x).
Nuance: Meuwissen (1997) maximises c'g subject to a *constraint* on c'Ac/2 (a predefined ΔF). The penalised objective is its Lagrangian form, not the paper's stated formulation.
Suggest: "the Lagrangian form of @meuwissen1997".

**02-B8 -- MISSING SOURCE** -- `:39-41` ("group coancestry in the sense of Cockerham")
Add `@cockerham1967` (in the bib; Crossref: Genetics 56:89-104, doi:10.1093/genetics/56.1.89).

**02-B9 -- MISSING SOURCE** -- `:67`, `:126-129` (Nei's gene diversity; Nei's minimum distance)
For gene diversity, add `@nei1973` (in the bib; PNAS 70:3321-3323, doi:10.1073/pnas.70.12.3321).
I did not confirm a primary source for the *minimum* distance D_m. It is usually credited to Nei (1987, Molecular Evolutionary Genetics, a book with no DOI). That attribution is unverified, so I propose no DOI.

**02-B10 -- MISSING SOURCE** -- `:165-171` (F_IS, F_ST, F_IT; (1 - F_IT) = (1 - F_IS)(1 - F_ST); F_ST = D_bar/(1 - f_bar))
Add `@wright1951` (in the bib; Ann. Eugen. 15:323-354, doi:10.1111/j.1469-1809.1949.tb02451.x; Crossref issue date is 1949 but print is 1951, so the key is fine).
Toro & Caballero 2005 credit F_ST = D_bar/(1 - f_bar) to Cockerham 1969, Evolution 23:72-84, doi:10.1111/j.1558-5646.1969.tb03496.x (Crossref-checked; not in the bib).

**02-B11 -- MISSING SOURCE** -- `:57-60` (SS x NSS f_ij "typically low"; same-family elite lines "can exceed 0.6")
This is a quantitative claim with no citation. Candidate: Van Inghelandt et al. 2010, Theor. Appl. Genet. 120:1289-1299, doi:10.1007/s00122-009-1256-2 (Crossref-checked). It covers heterotic-group structure and pedigree coancestry in 1,537 elite maize inbreds.
I did **not** confirm that it reports a value above 0.6. Soften the number or verify it.

**02-B12 -- MISSING SOURCE / UNVERIFIED** -- `:318` ("N_s = 1/(2 f_bar)")
No citation. A likely source is `@caballero2000` (in the bib; Genet. Res. 75:331-343, doi:10.1017/S0016672399004449), but I did not confirm that this definition appears there.

**02-B13 -- UNVERIFIED** -- `:335-352` ("The paper makes these [caveats]": within-population criteria favour larger populations; the effective number of alleles is the inverse of mean coancestry)
Toro & Caballero 2005 discuss the within/between weighting debate, which partly supports the caveats. Their attribution to the 2002 paper itself is not confirmed.
The "effective number of alleles = inverse of mean coancestry" argument goes back to Crow & Kimura (1970, a book with no DOI) and is uncited.

## Confirmed
- `:270-274` (eleven European pig breeds; the breed a distance method ranks most valuable raises diversity by 0.67% when removed): **supported**. Toro & Caballero 2005, Table 4 (data of Laval et al. 2000): FRBA, Weitzman loss -15.2, ΔGD_T = +2.62 - 1.95 = **+0.67**. The 2005 footnote shows the table comes from Caballero & Toro 2002. Optional: also cite Toro & Caballero 2005 or Laval et al. 2000 for the data.
- `:10` `@caballero2002` resolves, and its metadata is correct.

## Coverage
1 citation key and 13 uncited attributions/claims checked. Metadata via the Crossref API (caballero2002, meuwissen1997, cockerham1967, nei1973, wright1951, caballero2000, Toro & Caballero 2005, Cockerham 1969, Van Inghelandt 2010). Attributions via the full text of Toro & Caballero 2005 (PMC1569508). The worked example was recomputed in R/quadprog. The Caballero & Toro 2002 full text was unreachable, so all its equation and table numbers stay UNVERIFIED.
