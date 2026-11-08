# 05b-heterosis-dominance -- citation check, iteration 1

File: book/05b-heterosis-dominance.qmd (1821 lines). Bibliography: book/references.bib.
Scope: 11 distinct keys, 18 citation occurrences. All 11 `@keys` resolve in references.bib.
No `@key` is mistyped; no entry is retracted or carries a corrigendum (Crossref `updated-by` empty for all 10 DOIs).
Keys verified in earlier chapters and not redone beyond metadata: falconer1996 (00/01/02/02b), balding1995 (00). Their chapter-specific locators in 05b are checked below.
The name "Kadoumi" does not occur in 05b (nor any other bib key for it); nothing to check.

## Findings

### 05b-B1 -- MEDIUM -- 05b:1141 -- technow2014 mischaracterised ("additive hybrid prediction")
Claim: "@technow2014 report high accuracy for additive hybrid prediction in established, clearly separated dent and flint pools, which is the regime where this model puts the specific share at its lowest".
Evidence (FULL TEXT, PMC4125404, Methods): the two predictors in Technow et al. were not additive-only. GBLUP fitted GCA(Dent) + GCA(Flint) + SCA ("Z_S was the design matrix of the random specific combining ability (SCA) effects"). BayesB fitted "additive marker effects of the Dent parent lines ... and Flint parent lines ... and the dominance effects in d_DF". Accuracy 0.75-0.92 (grain yield), 0.59-0.95 (moisture) is from these models (abstract), so it is not accuracy of an additive hybrid model. What the paper does support: Discussion says "the contribution of SCA variance to total genetic variance was comparatively small in our data", and it cites Reif et al. 2007 for SCA/GCA falling with divergence. That is the claim the chapter wants.
Fix: say Technow et al. (Dent x Flint, 1254 hybrids) found a small SCA share of genetic variance and high prediction accuracy from GCA-dominated models; do not call the prediction "additive". "Established" is the chapter's word; the paper calls Dent and Flint "genetically distant pools ... heterotic groups".
Also the sentence's own hedge ("a single observational study in one crop cannot test it") is fine.
Source: https://doi.org/10.1534/genetics.114.165860 (PMID 24850820, PMC4125404).

### 05b-B2 -- UNVERIFIED (high importance) -- 05b:825 and 05b:855 -- comstock1949, the reciprocal recurrent scheme
Metadata checked and correct (Crossref): Comstock, Robinson, Harvey, "A breeding procedure designed to make maximum use of both general and specific combining ability", Agron. J. 41(8):360-367, 1949, doi 10.2134/agronj1949.00021962004100080006x. Authors of the bib entry: three names; the text writes "@comstock1949" (renders "Comstock et al."), fine.
What 05b attributes to it:
 (a) line 825: Comstock et al. "designed reciprocal recurrent selection around the distinction between these two components" (GCA and SCA).
 (b) line 855-863: "the exact sense in which @comstock1949's scheme is built on the decomposition. Reciprocal recurrent selection evaluates each pool-A candidate on its cross performance against a sample of the opposite pool, and symmetrically for pool B. Averaging over testers removes s_ij, so ... only g^A_i survives as a contrast between pool-A candidates."
Evidence: paper is Wiley/ASA paywalled (HTTP 403 on the Wiley page); no abstract is public; not in reference/. Not read, so (a) and (b) are UNVERIFIED. Only supports found: the title itself says "maximum use of both general and specific combining ability" (consistent with (a)); a secondary source seen only as a search snippet, Eberhart, Harrison & Ogada 1967, "A comprehensive breeding system", Der Zuchter, doi 10.1007/BF00329524, is quoted as saying that although the scheme was designed to use both GCA and SCA, "there is actually no utilization of specific combining ability, at least not in the earlier cycles when both populations are still heterogeneous" -- in line with 05b's "only g^A survives", but I could not open the page, so UNVERIFIED too.
Points for the author to settle against the paper (not assumed):
 - The 1949 scheme works on individual plants (heterozygous, from random-mating populations), each testcrossed to a sample of plants of the other population, with the selfed seed of selected plants recombined. 05b's decomposition (lines 770-790) is for fully inbred lines (u, v in {0,1}). So "candidate" in 855 maps to an inbred line only under the chapter's own premise 1; the sentence should not read as a description of Comstock's plant-based procedure. If the chapter wants to say "line-based", that is the book's adaptation, not Comstock's.
 - "Designed around the distinction" (825) vs the title ("make maximum use of both"): the paper's rationale was that the scheme exploits both; 05b argues the testcross mean selects only GCA (plus additive). Make clear this is the chapter's reading, not the authors' claim.
Action: obtain the paper through a library; until then label both sentences as the chapter's interpretation.

### 05b-B3 -- UNVERIFIED -- 05b:87, 114, 245, 341, 833 -- falconer1996 chapter locators
Entry exists, metadata correct (4th ed., Longman, Harlow, 1996; confirmed in earlier chapters). The book is not in reference/ and not open access, so none of the five locators could be read.
 - 87: M = a(p-q) + 2pq d, "Ch. 7".
 - 114: Fisher's dominance deviation as projection residual, "Ch. 7".
 - 833: average effect of gene substitution a + d(q-p), "Ch. 7".
 - 245: heterosis of a cross between two random-mating populations = sum d y^2, "Ch. 14".
 - 341: inbreeding depression 2F sum d p q, "Ch. 14".
Consistency check (my own algebra, not the source): F1 heterozygosity pA qB + pB qA minus the mid-parent pA qA + pB qB equals (pA-pB)^2, so d y^2 against random-mating parents is correct as stated, and the "twice the divergence term" sentence at 244-248 follows from the chapter's own @eq-het-split. Locator "Ch. 7 / Ch. 14" matches my recollection of the 4th-edition contents (Ch. 7 Values and means, Ch. 14 Inbreeding and crossbreeding) but I could not confirm from a catalogue page. No equation or page number is given, so there is nothing to mismatch.
Status: UNVERIFIED (no copy reachable). Low severity.

### 05b-B4 -- UNVERIFIED -- 05b:114 -- fisher1918
Entry exists. Crossref: Trans. R. Soc. Edinb. 52(2):399-433, DOI correct; Crossref issue date is 1919 while the bib (and the usual citation) says 1918 (the paper was read in 1918; volume 52 part 2 carries a 1918/1919 imprint). Cosmetic; keep 1918 or add a note. Full text not read (Cambridge returned 429/redirect; no local copy). The attribution (statistical dominance deviation = residual of the least-squares additive fit within a population) is the standard reading of Fisher 1918 but is UNVERIFIED here. Low.

### 05b-B5 -- UNVERIFIED -- 05b:782 -- sprague1942 and griffing1956 for "the classical decomposition into GCA and SCA"
Metadata correct for both (Crossref): Sprague & Tatum, J. Am. Soc. Agron. 34(10):923-932, 1942 (journal now Agronomy Journal; the bib's older name is the one in print at the time; fine); Griffing, Aust. J. Biol. Sci. 9(4):463-493, 1956. Full texts not read (Wiley paywall; CSIRO PDF link 404). Attribution is of the concept, not an equation, so the risk is low. Note: Griffing 1956 is a diallel analysis; 05b's model is a two-pool (female x male) factorial, where the closer classical precedent is Comstock & Robinson 1948 (North Carolina Design II), "The components of genetic variance in populations of biparental progenies and their use in estimating the average degree of dominance", Biometrics 4(4):254-266, doi 10.2307/3001412 (existence checked in Crossref, not read). Suggest adding it; not required.
Low.

### 05b-B6 -- LOW -- 05b:1801 -- white2020, "describe heterotic patterns and diversity separately"
Metadata correct. Evidence ABSTRACT only (University of Illinois record; Crop Sci 60:100-114): eight admixture subgroups (B14, B37, B73, Oh43, Iodent, Iodent-Lancaster, Lancaster, Flint) that "track heterotic patterns and company of origin", and five diallels giving yield heterotic patterns. The abstract does not say the authors treat the two "separately"; that is the chapter's gloss ("this chapter says why the two need describing separately"). Rephrase to "describe both the diversity structure and the heterotic patterns of ... germplasm". Full text not read -> UNVERIFIED for "separately".

### 05b-B7 -- MISSING SOURCE -- 05b:19-27 (and 5-7 of the "Three premises") -- what the book calls the "usual reading"
Claims with no citation: "the divergence between the heterotic pools is the engine of heterosis", and "the usual reading of the identity -- push the pools apart and you will get more heterosis". Also 54: "the crop here is allogamous -- maize-type, two heterotic pools under reciprocal recurrent selection" (no source for the maize heterotic-group system), and 632 "why do heterotic groups work?".
Sources found (Crossref existence only, not read, so offered as leads):
 - Moll, Salhuana & Robinson (1962), "Heterosis and genetic diversity in variety crosses of maize", Crop Science 2(3):197-198, doi 10.2135/cropsci1962.0011183x000200030005x -- the classic empirical study of heterosis against divergence (heterosis rising then falling with divergence).
 - Melchinger & Gumber (1998), "Overview of heterosis and heterotic groups in agronomic crops", in Concepts and Breeding of Heterosis in Crop Plants, CSSA Special Publication 25, doi 10.2135/cssaspecpub25.c3 -- the standard overview of the heterotic-group concept.
Medium-low: these are framing sentences, not numbers, but 05b is the chapter that corrects the claim, so the claim being corrected deserves a source.

### 05b-B8 -- LOW -- 05b:1110-1123 -- reif2007 attribution
Entry correct (Genetics 176(3):1931-1934, 2007; PMID 17507673, PMC1931541; note PubMed shows epub 16 May 2007, issue July 2007; year OK).
Text: Reif et al. "prove that the ratio of dominance to additive variance in a hybrid population falls as its two parent populations diverge, and conclude that superior hybrids then become predictable from general combining ability effects".
Evidence ABSTRACT: "We present a theoretical proof that the ratio of the dominance vs. the additive variance decreases with increasing genetic divergence between two populations ... we conclude that interpopulation improvement becomes more efficient with divergent ... heterotic groups, because performance of superior hybrids can be predicted on the basis of general combining ability effects." The sentence matches. The chapter's further statement that the ratio is sigma^2_D / sigma^2_A over the hybrid population and that its denominator includes parental additive variance is consistent with the abstract (additive = main component of sigma^2_GCA; dominance = main component of sigma^2_SCA) but the exact definition sits in the formula, which the PMC page renders as images and I could not read -> that detail UNVERIFIED. Note the abstract says "major component", not "all", which is the very point 05b makes.

## Entries that checked out (metadata + attribution at stated level)
| line | key | metadata (Crossref/PubMed) | attribution | level |
|---|---|---|---|---|
| 66, 129, 133 | labroo2021 | ok (Front. Genet. 12:643761, 2021) | review treats dominance, overdominance, pseudo-overdominance and epistasis as candidate mechanisms of heterosis; matches. "review the evidence for each" fair | PARTIAL FULL TEXT (journal page, first 100k characters) |
| 348 | mackay2020 | ok (PBJ 19(1):26-34; online Oct 2020, issue Jan 2021; bib year 2021 correct; key says 2020, cosmetic) | heterosis and inbreeding depression "largely two faces of the same underlying process"; transgressive segregation also covered; matches | ABSTRACT / PMC snippets |
| 475 | balding1995 | ok (Genetica 96:3-12) | cited for the beta drawing of pool frequencies; R/00_data.R:42 uses rbeta(p(1-F)/F, (1-p)(1-F)/F), the Balding-Nichols form. Beta form not confirmed from the 1995 full text (same caveat as 00-B on that key) | ABSTRACT (inherited) |
| 1110 | reif2007 | ok | see B8 | ABSTRACT |
| 1141 | technow2014 | ok (Genetics 197(4):1343-1355) | see B1 | FULL TEXT (Methods, Discussion) |

## Unsupported-claim scan (no citation near the claim)
 - 05b:19-27, 54, 632: see B7.
 - Quantitative maize heterosis magnitudes: none stated in the chapter (all numbers are inline R results from the simulation); nothing to source.
 - Balding-Nichols model: cited (475) but the F_ST ~ F_BN/(2 - F_BN) relation (lines ~484-486, via @sec-notation) is internal and not sourced in this chapter; it belongs to the notation chapter's check.
 - Sprague & Tatum / Griffing / Comstock: see B2, B5.

## Counts
Citation occurrences 18 over 11 keys; metadata checked for all 11 (Crossref for 10 DOIs, library record for the book): all correct except cosmetic items (fisher1918 Crossref year 1919; mackay2020 key vs year).
Attribution evidence level: FULL TEXT 1 occurrence (technow2014); PARTIAL FULL TEXT 3 (labroo2021); ABSTRACT 3 (reif2007, mackay2020, balding1995 inherited) plus 1 (white2020, with one detail unverifiable); UNVERIFIED 10 occurrences (falconer1996 x5, fisher1918, sprague1942, griffing1956, comstock1949 x2).
Findings by severity: MEDIUM 2 (B1 confirmed; B7 missing source), HIGH-importance UNVERIFIED 1 (B2 Comstock), LOW 5 (B3, B4, B5, B6, B8).
Where I looked for unverified items: reference/ (no copies of Falconer, Fisher, Sprague, Griffing, Comstock), PubMed/PMC (none indexed), Crossref, Wiley/ASA (403), CSIRO (404), Cambridge (429). No third-party copies of paywalled papers were fetched.
