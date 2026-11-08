# 03-simulating-crosses -- citation check, iteration 1

File: book/03-simulating-crosses.qmd (456 lines). Bibliography: book/references.bib.
Citation keys in the chapter: `balding1995` (line 59), `vanraden2008` (line 320). No others.
All `@sec-/@tbl-/@fig-/@eq-` targets used by the chapter resolve to a label in another chapter
(checked by grep: sec-notation, eq-f-stats, sec-heterosis-flat, sec-collapse, sec-baseline,
sec-genomic-era, sec-case-study, sec-heterosis-alignment, tbl-keystone, eq-gd-partition,
sec-response, sec-heterosis, sec-subdivided, sec-coancestry).

## Findings

### 03-B1 -- balding1995, qmd:58-63 (@eq-balding-nichols) -- UNVERIFIED (beta form not read in the primary)
Claim: "Two heterotic pools are generated with the Balding-Nichols model [@balding1995]",
followed by p_Ak ~ Beta(p*(1-F)/F, (1-p*)(1-F)/F), mean p*, variance F p*(1-p*).
Bib entry (checked, OK): Balding & Nichols (1995), Genetica 96(1-2):3-12, doi 10.1007/BF01441146;
PubMed 7607457 returns the same authors, year, title, journal, volume, pages and DOI.
Primary full text NOT reachable: Springer 303-redirects to an authentication endpoint (paywall); PMC has no
record; reference/ has no copy. Not fetched from third-party copies, as instructed.
Evidence level: ABSTRACT only (PubMed). The abstract says only that the probabilities are "expressed in terms of
a single parameter", forensic DNA-profile context. It says nothing about a Beta density.
What could be settled from secondary sources (NOT the paper): Wikipedia "Balding-Nichols model"
(https://en.wikipedia.org/wiki/Balding%E2%80%93Nichols_model), which cites this paper as ref. 1:
alpha = (1-F)p/F, beta = (1-F)(1-p)/F, "mean p and variance Fp(1-p)". The algebra is self-consistent
and matches the chapter's eq. and the code (R/00_data.R:38-45, `rbeta(p*(1-fst)/fst, (1-p)*(1-fst)/fst)`).
Caveats for the author:
 (a) The 1995 paper is multi-allelic and, to my recollection (not verified here), works with a Dirichlet; the
     Beta is the two-allele case. "Balding-Nichols model" as a Beta/F-model for pool drift is the usual modern
     usage, but the Beta form with these shapes is not demonstrated from the 1995 text.
 (b) Variance statement is correct for the stated Beta: Var = ab/((a+b)^2 (a+b+1)) with a+b = (1-F)/F gives
     p*q* F (checked analytically). "F_BN is the expected divergence of each pool from the ancestral frequency"
     (line 70) is the usual reading of F in this model but is again not read in the primary.
Suggested wording if it cannot be settled: "the Balding-Nichols model [@balding1995], in its two-allele (Beta)
form". Severity: low-medium (the model name and mean/variance are standard; the page-level attribution is open).

### 03-B2 -- vanraden2008, qmd:319-320 -- UNVERIFIED (full text not reached); minor precision issue
Claim: "`sum(G)` is zero to machine precision, as it must be for VanRaden's centred matrix [@vanraden2008]".
Bib entry (checked via web search/PubMed record 18946147): VanRaden, J. Dairy Sci. 91(11):4414-4423, 2008,
doi 10.3168/jds.2007-0980. Metadata OK.
Full text: the author's USDA PDF URL (aipl.arsusda.gov/publish/jds/2008/91_4414.pdf) returned a 404 page; not
retrieved. Previous chapters (see 01-coancestry it1) record the G = ZZ'/(2 sum p(1-p)) form as matching
Meuwissen et al. 2020's description of VanRaden Model 1 (full text of Meuwissen, secondary for VanRaden).
Issue: sum(G) = 0 holds only if Z is centred on the SAMPLE allele frequencies of the very panel (column sums
of Z = 0, so 1'ZZ'1 = 0). That is what `vanraden_G()` does (R/00_data.R:98-101, `p <- colMeans(M)/2`). VanRaden's G is
defined for any reference frequencies p; with base frequencies p0 (the book's own point in @sec-genomic-era) sum(G)
is generally not 0. So "as it must be for VanRaden's centred matrix" is true of the sample-centred version only.
Proposed fix: "as it must be when VanRaden's matrix is centred on the sample frequencies". Severity: low.

### 03-B3 -- MISSING SOURCE (low): qmd:236-239 factorial structure / production scale
"at the production scale of 71 lines per pool it is 71^2" (line 223-224): 71 is the repo's production config
(CLAUDE.md `n_pool_A/B = 71`), a design choice, not a literature claim. No citation needed; the real-programme
origin of 71 is not stated in the chapter. Informational only.

### 03-B4 -- MISSING SOURCE / scope (low): qmd:78-79
"Genotypes are then drawn as 2 x Bernoulli(p), which makes every line fully homozygous, as an inbred line should
be." This is a modelling shortcut (instant complete inbreeding, no DH/F2/selfing construction). No population-
construction claim (DH, F2) is made anywhere in the chapter, so nothing to source. The chapter does say it in
the "What this simulation deliberately does not model" callout for GEBV error and dominance. Suggest one clause
that the inbred lines are drawn directly at fixation, i.e. the generator does not model the DH/selfing path
that produces them in a real programme. Informational.

### 03-B5 -- Derivations without citation (checked analytically, all CORRECT; no source needed)
I re-derived each from the definitions; they hold.
 - Fst of two unbounded pools ~ F/(2-F) (lines 73-76): Hs = 2p*q*(1-F), Ht = 2p*q*(1-F/2), (Ht-Hs)/Ht =
   (F/2)/(1-F/2) = F/(2-F); ratio of expectations, as the text says. (0.15 -> 0.0811.)
 - Var(pA - pB) = 2F p*q* (line 72): correct.
 - GD_BS = (p^A - p^B)^2/2 per marker for 0/1 lines (exact, from the code definitions in lines 120-126), hence
   E[GD_BS] = F p*q* + (1-F) p*q*/n (line 208): correct. E[GD_T] loses F p*q*(1-1/n) per unit F, and
   E[GD_WS] loses 2 p*q*(1-1/n): correct, ratios 1 and 2 as stated (lines 209-211).
 - het_exp = 2(0.5 - (0.9^2/12 + 0.25)) = 2 E[p(1-p)] for p ~ U(0.05, 0.95) (line 132): correct.
 - Heterozygous fraction of A x B hybrid of inbred parents = 1 - theta_AB (line 202): exact for {0,1} lines.
Statement at 05b:579 attributes "F_ST = GD_BS/GD_T" to [@caballero2002, Eq. 8]; already covered in 02/05b reviews.

### Bibliography entries
Both entries exist and metadata is correct (balding1995, vanraden2008). No retraction/corrigendum found in the
PubMed record for either (not searched exhaustively: PubMed record only).

## Counts
Citations in chapter: 2 distinct keys, 2 occurrences.
 - Metadata verified: 2/2 (balding1995 via PubMed record; vanraden2008 via PubMed record 18946147 + web).
 - Attribution FULL TEXT: 0. ABSTRACT: 1 (balding1995, abstract does not support the Beta form). UNVERIFIED: 2
   (balding1995 Beta form; vanraden2008 sum(G)=0 statement).
Severities: WRONG 0; UNVERIFIED 2 (03-B1 low-medium, 03-B2 low); MISSING SOURCE 2 (both informational); UNCITED n/a (chapter mode).
Where looked: reference/ (no copy of either paper), PubMed metadata (7607457), Springer (paywall redirect),
USDA author PDF (404), Wikipedia (secondary, for the Beta parameters only).
Could not settle balding1995 beta form: only a PDF of Balding & Nichols (1995) or Balding (2003, Theor Popul Biol
63:221-230) / Nicholson et al. (2002, JRSSB 64:695-715) would; suggest the author checks one of them and, if the
Beta form is only in the latter two, cites them for the Beta parameterisation.
