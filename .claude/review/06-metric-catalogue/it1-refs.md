# 06-metric-catalogue -- references, iteration 1

Files: book/06-metric-catalogue.qmd, book/references.bib. Comstock et al. 1949 is not cited in this chapter (no PENDING item here).
All 12 `@key` in the chapter resolve in references.bib (cockerham1967, nei1973, lindgren1997, toro2020, simpson1949, lacy1989, lopezcortegano2019, odong2013, debeukelaer2018, belldean1970, caballero2002, caballerorodriguezramilo2010).
Metadata (authors, year, title, journal, volume, pages, DOI) checked against Crossref for the 11 DOIs and AGRIS for lindgren1997 (no DOI). No error, no retraction or corrigendum found.
Only note: toro2020 and odong2013 are "issued" 2019 and 2012 in Crossref (online-first); the bib uses the volume/issue year (137(4) = 2020; 126(2) = 2013). Correct, no change.

## Findings

**06-B1 -- qmd:260-264 (lopezcortegano2019) -- WRONG (mechanism not in the source, partly contradicted)**
Text: "heterozygosity-maximising management pushes allele frequencies toward 0.5, which favours rare alleles in the short run but does not stop them drifting to loss once they are no longer the rarest".
FULL TEXT of Lopez-Cortegano et al. 2019 (reference/papers/Optimal Management...pdf, p. 2 and p. 7-8): the "pushes frequencies toward intermediate values, so rare alleles are less likely to be lost" mechanism is stated for an UNDIVIDED population, from Fernandez et al. (2004). For SUBDIVIDED populations the paper says "maximization of global heterozygosity is made at the cost of an increase of homozygosity (and thus inbreeding) in each subpopulation, at least in the short term, and a substantial loss of alleles". The "once they are no longer the rarest" step appears nowhere. The empirical result in lines 254-259 is faithful; the explanatory sentence is the book's own and reads as the paper's. Fix: attribute the intermediate-frequency mechanism to Fernandez et al. 2004 as reported there, say that for subdivided populations the paper reports more homozygosity and allele loss under max-H_T, or mark the mechanism as the book's conjecture.

**06-B2 -- qmd:497 (lopezcortegano2019) -- WRONG (nuance)**
Text: "@lopezcortegano2019 choose lambda for conservation, where no such derivation applies."
FULL TEXT p. 3: they run lambda = 1 mainly, but also lambda = 0, 1000 and "lambda = 0.5, a value suggested to maximize the total genetic variance of a hypothetical quantitative trait (Bennewitz and Meuwissen, 2006)". So a derivation-based value (0.5) is in the paper, taken from Bennewitz & Meuwissen; it also matches the book's lambda_d = 1/2 for d_k = 1. Fix: say lambda is varied (0, 0.5, 1, 1000), with 0.5 taken from the quantitative-genetic argument, not derived for heterosis. I did not open Bennewitz & Meuwissen 2006 (not in reference/); do not add it to the bib without checking.

**06-B3 -- qmd:331-332 (belldean1970) -- UNVERIFIED**
Claim: participation ratio "a term introduced for the localisation of vibrational modes [@belldean1970]". The paper exists (Crossref: Discuss. Faraday Soc. 50, 55, 1970, DOI ok), computed vibrational modes of vitreous silica random networks. No reachable full text; web search did not return the participation-ratio definition. The usual attribution may rather be to the companion paper Bell, Dean & Hibbins-Butler, J. Phys. C 3, 2111 (1970) "Localization of normal modes in vitreous silica, germania and beryllium fluoride" -- not checked. Looked in: Crossref, RSC landing page via search, web search; reference/ has no copy.

**06-B4 -- qmd:206-207 (lacy1989) -- UNVERIFIED (formula)**
Claim: founder equivalents have "the same form" 1/sum p_i^2 over founder contributions. Entry correct (Crossref). Only the concept is confirmed (number of equally contributing founders giving the same diversity; PMC3036146 and czaw.org summary). The 1/sum(q_k^2) formula is an image in the secondary source and the 1989 text is not reachable. Looked in: Crossref, PMC3036146, czaw.org, web search; no local copy.

**06-B5 -- qmd:23 (cockerham1967) -- UNVERIFIED (full text)**
Claim: group coancestry is the mean of all n^2 elements, diagonal included. Entry correct (Crossref; PMC1211496, scanned, text not returned by PMC tool or PDF endpoints). Indirect support, FULL TEXT of a different paper: Caballero & Toro 2002, p. 290: average coancestry between subpopulations "including all Ni x Nj pairs (Cockerham 1967)" (for i = j this includes the self pairs).

**06-B6 -- qmd:177-179 (toro2020) -- UNVERIFIED (formula), ABSTRACT otherwise**
ABSTRACT (PubMed 31713272, DOI 10.1111/jbg.12455) supports: with optimal molecular management diversity increases in early generations, so Ne takes negative values; in the long term it does not reach an asymptote and behaves unpredictably. The expression N_e = 1/(2 Delta F) is not in the abstract; full text not open access (Europe PMC: not in PMC). Looked in: PubMed, Europe PMC, Crossref; no local copy.

**06-B7 -- qmd:231-233 -- MISSING SOURCE (low)**
"theta and H_e ... are dominated by intermediate-frequency alleles. A lost rare allele barely moves them, yet the loss is irreversible." No citation. Support found (FULL TEXT, p. 1-2): Lopez-Cortegano et al. 2019, DOI 10.3389/fgene.2019.00843 -- expected heterozygosity relates to short-term response, allelic diversity "is more sensitive to population bottlenecks ... and relates more strongly to the long-term response". Second option: Caballero & Rodriguez-Ramilo 2010, DOI 10.1007/s10592-010-0107-7 (abstract only checked), for the contrast between allelic and gene diversity.

**06-B8 -- qmd:96, 443 (nei1973) -- UNVERIFIED (full text), ABSTRACT supports**
ABSTRACT (PMC427228): gene diversity of a subdivided population analysed into within- and between-subpopulation components. H_T = H_S + D_ST is the standard form; Lopez-Cortegano 2019 (p. 3, FULL TEXT) writes "H_T partitioned, following Nei (1973)". Note: the chapter writes D_G, which is the Caballero/Lopez-Cortegano notation for Nei's minimum distance, not Nei's own D_ST. Not wrong, but state the notation. Full text of the 1973 paper not retrieved by the PMC tool.

## Confirmed attributions

- caballero2002 (FULL TEXT, reference/papers/Analysis_of_genetic_diversity...pdf): Eq. 7 on p. 290: (1 - fbar) = (1 - s~) + (s~ - f~) + (f~ - fbar), i.e. GD_T = GD_WI + GD_BI + GD_BS, with GD_BS = f~ - fbar = Dbar (Eq. 4-5); Eq. 9 gives GD_T with contributions c_i. This supports the chapter's identification H_T = GD_T, D_G = GD_BS, H_S = GD_T - GD_BS (qmd:498) and "weight by usage" (qmd:367-368). theta_A, theta_B, theta_AB (Eq. catalogue-theta-pools) are the book's own application; "Following" is fair.
- lopezcortegano2019 (FULL TEXT): five subpopulations (p. 2); objective H_T = D_G + lambda H_S and A_T = D_A + lambda A_S (p. 3); A_T = A_S + D_A following Caballero & Rodriguez-Ramilo 2010; max-A_T retains more alleles and restrains inbreeding better than max-H_T, except lambda = 1000 where max-H_T gives the lowest inbreeding but fewer alleles (p. 6-8); recommends max-A_T for structured populations (abstract). Lines 254-259, 266-270, 444-455 faithful.
- odong2013 (FULL TEXT, PMC3555244): E-NE (average distance entry to nearest neighbouring entry, over entries only) and A-NE (accession to nearest entry, averaged over the whole collection; "for the selected accessions these distances are taken as zero"), "Two new criteria based on genetic distance are introduced". The departure of `ane()` in qmd:315-318 is described correctly.
- debeukelaer2018 (FULL TEXT, reference/papers/Core Hunter 3...pdf, p. 2-3): E-NE and A-NE "proposed by Odong et al. [4]"; A-NE includes the accession itself when selected; distances are Modified Rogers (qmd:274-278 "on its own marker distances" faithful).
- simpson1949 (FULL TEXT, one-page reprint, Nature 163:688): "Lambda defined as sum x^2 is a measure of the concentration", interpreted as the probability that two individuals drawn at random belong to the same group. qmd:205 faithful.
- lindgren1997 (ABSTRACT via AGRIS): status number is half the inverse of average coancestry, equal to the census number for unrelated non-inbred individuals, never below 0.5. Matches Eq. catalogue-ns and the [1/2, 1] range on f.
- caballerorodriguezramilo2010 (ABSTRACT, Europe PMC): partition of total allelic diversity into within- and between-subpopulation components, analogous to gene diversity. Matches qmd:444.

## Evidence summary
12 citations: FULL TEXT 5 (caballero2002, lopezcortegano2019, odong2013, debeukelaer2018, simpson1949); ABSTRACT 4 (nei1973, toro2020, lindgren1997, caballerorodriguezramilo2010; the last also FULL TEXT through lopezcortegano2019); UNVERIFIED 3 (cockerham1967, lacy1989, belldean1970). Findings: 2 WRONG (B1, B2), 4 UNVERIFIED (B3-B6) plus B8, 1 MISSING SOURCE (B7). Metadata: 12/12 correct.
