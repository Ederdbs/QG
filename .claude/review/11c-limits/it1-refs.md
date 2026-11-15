# 11c-limits -- reference check, iteration 1

File: book/11c-limits.qmd. Bib: book/references.bib. Cited keys: robertson1960, bulmer1971 (both resolve). Comstock 1949 is not cited in this chapter.

## Bib metadata (checked against Crossref, DOIs resolve)
- robertson1960: Robertson A., "A theory of limits in artificial selection", Proc R Soc Lond B 153(951):234-249, Nov 1960, doi 10.1098/rspb.1960.0099. Matches the bib entry. No retraction or correction.
- bulmer1971: Bulmer M.G., "The effect of selection on genetic variability", Am Nat 105(943):201-211, May 1971, doi 10.1086/282718. Matches. No retraction or correction.

## Findings

**11c-B1 | 11c-limits.qmd:24-28 | WRONG (overstated attribution: scope condition dropped)**
The chapter states "R_total ~ 2 N_e R_1 with a half-life of about 1.4 N_e" as Robertson's result, unconditionally. FULL TEXT (Robertson 1960, summary p.234 items 3-4; text p.237 after Eq. 5; p.241 on the quantitative case) says something narrower:
- Summary (3): "For low values of Ni, the total advance by selection is, for additive genes, 2N times the gain in the first generation but may be much greater than this for recessives". Here N is the effective size, i the selection intensity. Equation (5) and the text derive it for small Ns, and for the quantitative case "the total advance is 2N times the response in the first generation (to q_1) as Dempster (1955) has pointed out".
- Text after Eq. 5: "For larger values of Ns, the total advance may be larger than this ... approaches 4N times the change in the first generation."
- Summary (4): "The half-life of any selection process will, for additive genes, not be greater than 1.4N generations". Eq. (9) and the text give t = 1.4N for low Ns; p.241 calls it an "upper limit". The chapter says "about".
So 2 N_e R_1 is the low-N*i (additive) value and the half-life 1.4 N_e is an upper bound. The chapter should add the condition (N_e i small, additive) and say "at most about 1.4 N_e". The prediction code (`predicted_15 = 2 Ne R1 (1-(1-1/(2Ne))^15)`) follows the form of Eq. 9, (1 - (1-1/2N)^t), so it is consistent with the source in form.
Dempster (1955) is credited by Robertson for the 2N result in the quantitative case; the bib has no such entry. Consider a mention.

**11c-B2 | 11c-limits.qmd:28-30 | MISSING SOURCE (unsupported claim)**
"The result is the theoretical ancestor of every optimal-contribution scheme in this book: it is why N_e is the thing to manage ..." Robertson 1960 (full text read) says nothing about optimal contributions or managing N_e. It does conclude that selecting half the population per generation gives the furthest limit (summary 7), and that using family information sacrifices the eventual limit (summary 8). The claim is the author's interpretation. Soften it, or support it with primary sources found:
- Robertson A. (1961) "Inbreeding in artificial selection programmes", Genet Res 2:189-194, doi 10.1017/s0016672300000690 (selection reduces N_e; the Crossref record was found, content not read).
- Meuwissen T.H.E. (1997), J Anim Sci 75:934-940, doi 10.2527/1997.754934x (already in references.bib as meuwissen1997; the content was not re-read for this check).
UNVERIFIED as a historical-lineage claim.

**11c-B3 | 11c-limits.qmd:58-60 | WRONG (loose wording)**
"Robertson's theory, published in 1960 and derived for a single locus under idealised drift". Robertson's abstract: "developed primarily in terms of single genes" and then summed over loci for additive genes. The wording is acceptable, but the source also makes the constant-N assumption explicit (heterozygosity declines by 1/2N per generation: text near Eq. 5, "q(1-q) will decline by a fraction 1/2N each generation"). Link: 11c-B1, the theory is a low-Ni result, so "predicts to better than one percent" is a property of this simulation, not of the theory. Wording only. Not a numeric attribution.

**11c-B4 | 11c-limits.qmd:67-68 | OK (FULL TEXT)**
"Robertson assumes a constant rate of inbreeding". Supported: Robertson uses a fixed effective size N with heterozygosity decaying by 1/2N per generation (p.237, and "the time scale is proportional to N, the effective population size", p.239). Note that Robertson treats N as given and does not assume constant Delta F as a separate postulate; it follows from constant N. Acceptable.

**11c-B5 | 11c-limits.qmd:105-108 | OK on ABSTRACT, detail UNVERIFIED**
"Directional selection drives that covariance term negative (Bulmer 1971): it couples loci with like effects in repulsion". ABSTRACT (via Consensus; Am Nat full text not reachable: journals.uchicago.edu returned 403, JSTOR not tried): "the correlation is negative, leading to a reduction in the genetic variance under stabilizing or directional selection". That supports the sign and the direction. "Like effects in repulsion" is a standard reading but was not confirmed in the full text. UNVERIFIED (full text).

**11c-B6 | 11c-limits.qmd:112-116 and 157-160, 212 | UNVERIFIED (full text) -- three specific claims attributed to Bulmer 1971**
(a) "Bulmer's 1971 treatment covers unlinked loci explicitly": the ABSTRACT supports this ("An expression is derived for the predicted amount of change in the genetic variance due to disequilibrium in the absence of linkage"). Treated as OK.
(b) "free recombination halves the disequilibrium each generation, but selection regenerates it every generation, and the equilibrium is not zero": the abstract only says the correlation "rapidly disappears" when selection stops and that the change is "likely to be small" under natural selection intensities but "may be appreciable under intense artificial selection". The halving per generation and the non-zero equilibrium are not in the abstract. UNVERIFIED. The halving is textbook (Bulmer 1971; Lynch & Walsh ch. 24 sets it out), but no source was opened. If the author wants it attributed to Bulmer, a page and equation must be read.
(c) Caution on the abstract: Bulmer's result is for an effectively infinite number of loci, and under it "selection cannot cause any permanent change in the genetic variance". The chapter tests a finite-locus simulation, so the Bulmer 1971 reference supports the mechanism, not the size of the effect. The chapter does not claim otherwise; no change needed, but consider saying "in the infinitesimal limit".

**11c-B7 | 11c-limits.qmd:174-178 | UNVERIFIED against documentation (not a bibliographic item)**
"AlphaSimR reports varA (carries the disequilibrium) and genicVarA (does not)". Both functions exist in the installed AlphaSimR (`varA`, `genicVarA(pop, simParam)`); the claim about what each includes was not checked against the manual. Not cited in the bib.

**11c-B8 | 11c-limits.qmd:204-216 | MISSING SOURCE (minor)**
"Recombination repays [the covariance]; ... allele-frequency change ... nothing repays that short of mutation or migration" and the closing ranking of the two costs ("a consequence of the two decay rates"). This is the author's argument supported by the chapter's own simulation, plus Bulmer 1971 abstract ("when selection ceases ... the variance returns to its original value", "permanent change ... likely to be much less than the temporary change"). The abstract supports the self-correcting claim for the infinitesimal limit. For the quantitative claim "largely self-correcting" under linkage, the chapter relies on its own linked arm. No external source needed beyond Bulmer; the abstract sentence above could be cited. No new sources needed.

## Not found / not checked
- Comstock 1949: not cited in 11c-limits.qmd. Nothing to check.
- Full text of Bulmer 1971 not reached (journals.uchicago.edu 403; JSTOR not tried; no PMC). Looked in: local reference/papers (not present), PubMed (not indexed), Crossref, Consensus (abstract), Europe PMC not tried.
- Robertson 1960 full text was read from the gwern.net copy (16 pp, Royal Society scan, OCR text), reliable for the quoted passages.

## Counts
2 citations (robertson1960, bulmer1971). robertson1960: FULL TEXT (4 attributed claims checked: B1, B2, B3, B4). bulmer1971: ABSTRACT only (B5, B6, B8); all full-text-dependent details UNVERIFIED. Bib metadata verified by Crossref for both. Findings: 1 WRONG (B1), 1 MISSING SOURCE major (B2), 1 wording (B3), 2 UNVERIFIED (B6, B7), 1 minor (B8).
