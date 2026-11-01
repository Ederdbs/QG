# 05-genomic-era.qmd -- reference check, iteration 1

Source text used: Meuwissen et al. 2020 full text, Europe PMC PMC7438563
(https://www.ebi.ac.uk/europepmc/webservices/rest/PMC7438563/fullTextXML), DOI 10.3389/fgene.2020.00880.
DOIs resolved via api.crossref.org.

## Bib entries (all keys resolve; metadata correct)

| key | check | result |
|---|---|---|
| meuwissen2020 | Crossref 10.3389/fgene.2020.00880 | OK (Front Genet 11:880, 4 authors match) |
| comstock1949 | Crossref 10.2134/agronj1949.00021962004100080006x | OK (Agron J 41(8):360-367) |
| falconer1996 | book, 4th ed. Longman 1996 | OK; Ch. 3-4 (small populations / Ne), Ch. 7 (values and means, alpha = a + d(q-p)), Ch. 14 (ID = 2F sum dpq) correct |
| caballero2002 | Crossref 10.1023/A:1019956205473 | OK (Conserv Genet 3(3):289-299) |
| wright1951 | Crossref 10.1111/j.1469-1809.1949.tb02451.x | OK (Ann Eugen 15(1):323-354). Crossref dates the issue 1949; 1951 is the conventional citation year. No change needed |
| holsinger2009 | Crossref 10.1038/nrg2611 | OK (Nat Rev Genet 10(9):639-650) |

## Attributions to @meuwissen2020 verified against the full text (no finding)

- l.155-157 log(1-F_drift) linear, log(1-F_hom) curvilinear esp. G_ROH: Results, "Managing the Rates of Inbreeding". OK
- l.178 Eq. 1A = F_hom with N_SNP: OK. l.357 Eq. 3 (2 cov of standardised dp and (p0-1/2)): OK. Eq. 2 is the classical equivalence: OK.
- l.316-319 "an approximation to the squared total intensity (i^2) applied to the marker", citing Liu and Woolliams 2010: OK (Discussion).
- l.368, l.1073 random-GEBV arm, divergence persists: OK (G_VR2(~,M); Discussion "unaffected by whether random GEBVs were used").
- l.428 caption: di/dp = [p(1-p)]^-1/2 after Liu & Woolliams 2010: OK. Signs of the four drift/homozygosity matrices match Table 2.
- l.434-439 both quotes verbatim; "second Conclusion bullet": OK; "depends on the distribution of (p0 - 1/2)": Discussion, OK.
- l.440-444 panels M, D, N, Q all random samples of WGS: OK (Methods).
- l.506-512 G_LA only scheme meeting both targets; 65/100 vs A, 62/100 vs G_ROH, interpolation at averaged inbreeding (Genetic Gain section): OK.
- l.530-534 G_ROH "more similar to G_0.5", not PSD, alpha additions (avg 8.7), diagonally dominant, artificially many parents: OK.
- l.570-577 Table 2 Panel N columns, all 24 values transcribed correctly; SE < 2.5e-5 (rates), < 2.2e-4 (gap): OK. Table 3 gains, all 8 correct; SE <= 0.004: OK.
- l.579-582 Figure 5 / Genetic Gain section: OK.
- l.627-628 "< 0.3%" gain difference G_VR2(M,M) vs (M,D): OK ("within 0.3%").
- l.1296 IBD schemes many parents, VanRaden-style few: OK (Number of Parents; G_ROH also many).
- l.1327 alpha = 0.01, Methods: OK.
- l.1470, 1478-1481, 1491, 1503 quotes all verbatim and all in Discussion > "Management of Diversity": OK. Wood et al. 2014 and MHC mention: OK.
- l.78 @comstock1949 for RRS (selection on performance against the opposite pool): OK.
- l.204, 1223 @caballero2002 GD_T = 1 - fbar, GD_BS = ftilde - fbar: OK.
- l.301 @wright1951 standardised-variance F_ST, @holsinger2009 on the several F_ST definitions: OK (Holsinger & Weir attribute F-statistics to Wright 1951).

## Findings

### 05-B1 -- WRONG -- l.624-626 and l.553 (side-by-side table, A row)
"Pedigree A ... overshot by ~40%" / "exceeded targets by ~40%".
Evidence: the paper's Results text says "both dF_hom and dF_drift exceeded the target rates by 40% in both panels", but its own Table 2 (Panel N) gives A(M,~) dF_hom 0.0070 (+40%) and dF_drift 0.0084 (+68%); Panel M 0.0072 (+44%) and 0.0083 (+66%). The chapter transcribes 0.0084 two screens earlier (l.595), so the page contradicts itself.
Fix: "overshot the 0.005 target by ~40% on dF_hom and ~70% on dF_drift (their Table 2, Panel N; their text rounds both to 40%)".

### 05-B2 -- WRONG (minor) -- l.556 ("the eight schemes"), l.602 comment
Evidence: Methods, "a total of 9 schemes contribute to the results presented"; the ninth is G_VR2(~,M) (random GEBV), in Table 2 but not Table 3. The chapter transcribes eight. The G_0.5 claim still holds over nine (G_VR2(~,M) dF_drift = 0.0059, Panel N).
Fix: "of the nine schemes" in l.556, or "of the eight transcribed here".

### 05-B3 -- WRONG (phrasing vs. source) -- l.610-613, reading 1
"No IBS scheme met both targets. G_LA came closest: ... but 14% below target on dF_hom". 
Evidence: the paper's Conclusion: "The OC scheme using G_LA ... was the only scheme investigated here that managed homozygosity and drift based inbreeding within the target rate of 0.5%". The target is a ceiling, so 0.0043 is *within* it, not a miss; the chapter's own caption (l.605) and l.506 say G_LA meets both. "came closest" reads as if it did not.
Fix: "No IBS scheme met both targets; the IBD scheme G_LA met both: dF_drift within 2% of 0.005 on panels M and N, dF_hom 14% under it."

### 05-B4 -- WRONG (minor) -- l.1503-1505
"Their simulations all carry selection, so no conservation scheme was run to test it."
Evidence: Methods: the "~" EBV panel "implements a scheme without directional selection" (G_VR2(~,M), random GEBV). It is not a pure conservation scheme (it still maximises a random index under the constraint), but "all carry selection" overstates.
Fix: "Their only arm without directional selection (G_VR2(~,M), random GEBVs) still maximises an index, so no pure conservation scheme was run to test it."

### 05-B5 -- NOTE (departure from source not flagged) -- l.1323-1336
The chapter says the deficiency mechanism differs for G_0.5 (not centring). The paper's Methods says all four semi-definite matrices have "one eigenvalue of zero due to the centring of the genotypes". The chapter's derivation is its own and is checked live, but it should say it departs from the source.
Fix: add "(@meuwissen2020 attribute the zero eigenvalue of all four to centring; for G_0.5 the chunk below shows otherwise)".

### 05-B6 -- MISSING SOURCE -- l.168-170
"Wright defined an inbreeding coefficient to run from 0 to 1 as heterozygosity under random mating falls..." -- historical claim, no citation. Also imprecise: Wright defined F as the correlation between uniting gametes (Meuwissen 2020 Background says the same); H_t = H_0(1 - F) is the consequence.
Sources (in bib already): @wright1922, Wright S. 1922 Am Nat 56:330-338, doi:10.1086/279872; @falconer1996 Ch. 3 (F as proportional loss of heterozygosity).
Fix: "Wright (@wright1922) defined F as the correlation between uniting gametes; under random drift it is the fraction of heterozygosity lost [@falconer1996, Ch. 3]".

### 05-B7 -- MISSING SOURCE -- l.306, l.1201, l.1269
Nei's He / G_ST named without citation. @nei1973 is in the bib: Nei M. 1973 PNAS 70:3321-3323, doi:10.1073/pnas.70.12.3321 (Crossref checked).

### 05-B8 -- MISSING SOURCE -- l.28, l.1332, l.1359
"VanRaden G" / "VanRaden's G" with no citation. @vanraden2008 is in the bib: J Dairy Sci 91:4414-4423, doi:10.3168/jds.2007-0980. G_VR1/G_VR2 are VanRaden's Models 1 and 2 (Meuwissen 2020 Methods).

### 05-B9 -- MISSING SOURCE (low) -- l.124 caption, l.121
G_0.5 as homozygosity-based relationship: Meuwissen 2020 credits it to Toro et al. 2014. @toro2014 is in the bib: Livest Sci 166:48-53, doi:10.1016/j.livsci.2014.04.020.

### 05-B10 -- MISSING SOURCE (low) -- l.317, l.428, l.1478
Liu & Woolliams 2010 and Wood et al. 2014 are named in prose only, not in references.bib. Acceptable as "cited by Meuwissen et al.", but if kept by name, add:
- Liu A. Y., Woolliams J. A. 2010. Continuous approximations for optimizing allele trajectories. Genet Res 92(2):157-166, doi:10.1017/S0016672310000145 (Crossref checked).
- Wood A. R. et al. 2014. Defining the role of common variation in the genomic and biological architecture of adult human height. Nat Genet 46:1173-1186, doi:10.1038/ng.3097 (Crossref checked).

### 05-B11 -- MISSING SOURCE (low) -- l.517-519
"which commercial programmes generally have because every DH line records its F1 parents" -- an industry-practice generalisation with no source. No primary source searched or proposed; suggest softening to "which a programme that records the F1 parents of every DH line has".

## Count
8 distinct @keys (6 bib entries) checked: 6 DOIs resolved via Crossref; 25 attributions to @meuwissen2020 checked word for word against the Europe PMC full text (PMC7438563), including all 48 transcribed table values; Falconer & Mackay chapter numbers checked from the 4th-edition table of contents (not opened). Nothing UNVERIFIED.
