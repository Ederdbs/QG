# Reference check: book/02b-response.qmd (iteration 1)

Bibliography: book/references.bib. Date: 2026-11-07. Read-only on the book.

Scope: 6 distinct keys, 9 citation occurrences: falconer1996 x2 (lines 52, 106), bulmer1971 (177),
sprague1942 (263), smith1936 + hazel1943 (344, one citation group), kempthorne1959 x2 (403, 446).
All 6 keys resolve in references.bib. All 15 cross-reference targets of the chapter (@sec-cycles,
-simulating-crosses, -stages, -alphasimr, -heterosis-gca-sca, -subdivided, -case-study, -ocs, -baseline,
-limits, -genomic-era, -catalogue, -genomic-prediction, -choosing, -heterosis) exist, each with one
`{#...}` definition. Finding 5 of @sec-choosing exists (07-choosing-metrics.qmd:315). Chapter-internal
@eq-/@tbl- labels resolve. The chapter has no `@` outside citations and cross-references that needs ignoring.

## Metadata (Crossref, checked 2026-11-07; `update-to`/`updated-by` empty for all: no retraction or corrigendum)

| key | bib | Crossref | verdict |
|---|---|---|---|
| smith1936 | Smith HF, Ann Eugen 7(3):240-250, 1936, doi 10.1111/j.1469-1809.1936.tb02143.x | same | ok |
| hazel1943 | Hazel LN, Genetics 28(6):476-490, 1943, doi 10.1093/genetics/28.6.476 | same (PubMed 17247099, PMC1209225) | ok |
| bulmer1971 | Bulmer MG, Am Nat 105(943):201-211, 1971, doi 10.1086/282718 | same | ok |
| kempthorne1959 | Kempthorne O, Nordskog AW, Biometrics 15(1):10-19, 1959, doi 10.2307/2527598 | Crossref page "10" only; end page 19 confirmed by citing literature | ok |
| sprague1942 | Sprague GF, Tatum LA, J Am Soc Agron 34(10):923-932, 1942, doi 10.2134/agronj1942...008x | same (journal now Agronomy Journal) | ok |
| falconer1996 | Falconer DS, Mackay TFC, Introduction to Quantitative Genetics, 4th ed, Longman, Harlow, 1996 | book; edition/publisher/year confirmed by library records | ok |

## Findings

Severity: HIGH = false statement of a source; MEDIUM = reader misled, wrong locator or overclaim;
LOW = wording, uncited standard result, or primary source not reached. Counts: HIGH 0, MEDIUM 2, LOW 7.

### 02b-B1 -- book/02b-response.qmd:403-405 (and :446) -- OVERCLAIM -- MEDIUM
Key: `kempthorne1959`. Text: "@kempthorne1959 posed exactly the same problem -- maximise aggregate gain subject
to **zero expected change** in a specified direction -- and solved it." The chapter itself says, 20 lines
later (line 436-440), that alpha is an inequality (alpha <= alpha_max) against a random-subset reference, not
an equality on a trait's expected gain, and the callout (line 446) says Kempthorne & Nordskog restricted a
*trait*, whereas "a specified direction" in line 404 suggests a general direction. "Exactly the same problem"
is therefore stronger than what the chapter later grants; "the same problem with an equality restriction on
trait gains" is what is supported. (The same wording sits in 09-optimal-contributions.qmd:48 "identical
problem"; fix both together.)
Evidence level: ABSTRACT-free. The 1959 paper is JSTOR-only (doi 10.2307/2527598), no PubMed record, no open
copy; the only full-text copy found is a third-party scan (gwern.net), which the brief forbids using. The
description "zero restriction on the expected genetic gain of chosen traits" rests on secondary snippets only.
Not checked against the source: UNVERIFIED.

### 02b-B2 -- book/02b-response.qmd:405-420 (@eq-response-restricted) -- UNVERIFIED -- MEDIUM
Key: `kempthorne1959`. The equation b = P^-1[G a - C (C' P^-1 C)^-1 C' P^-1 G a], C = G R, is attributed to
Kempthorne & Nordskog as "algebraically equivalent; not necessarily their notation". The hedge is correct and
keeps this from being a false attribution. Independent check (algebra, not the source): the formula is the
standard restricted-index solution; C'b = C'P^-1 G a - C'P^-1 C (C'P^-1 C)^-1 C'P^-1 G a = 0, so the stated
"exactly zero" property holds, and `index_restricted()` (R/15_response.R) implements exactly this expression
and asserts R'Gb = 0 in the chapter chunk. What is NOT verified is that the 1959 paper solves this problem
(rather than, e.g., a version with restriction written on index-trait covariances in its own notation) and the
"it is 1959, a theorem from 1959" priority claim in the callout (lines 450-455). Source unreachable (see B1).
No 1959-specific equation or page number is quoted by the chapter, so nothing is falsified. A reader-facing
fix: add a page or section pointer once a copy is in hand, or cite a textbook derivation (Lynch & Walsh 1998,
index selection chapter) for the matrix form.

### 02b-B3 -- book/02b-response.qmd:344 -- UNVERIFIED -- LOW
Keys: `smith1936`, `hazel1943`. "the Smith-Hazel index [@smith1936; @hazel1943]: b = Sigma_P^-1 Sigma_G a".
Metadata correct. Attribution to the pair is the standard textbook one, and the algebra is correct
(maximising Cor(b'y, a'g) gives b proportional to P^-1 G a; the chunk checks it against the BLUP route).
Primary text not read: Smith 1936 is Wiley-paywalled; Hazel 1943 has PMC1209225 but PubMed's full-text tool
returns an empty body (scanned PDF) and pmc.ncbi.nlm.nih.gov served only a bot-check page. So the claim that
the matrix expression b = P^-1 G a with aggregate genotype H = a'g appears in these papers is not confirmed
from the sources. Note also that the chapter's matrix notation is modern (Smith's is the discriminant-function
form, Hazel's is a normal-equation form); no equation number is claimed, so no error.

### 02b-B4 -- book/02b-response.qmd:50-52 and :104-106 -- UNVERIFIED (locator) -- LOW
Key: `falconer1996`. Two chapter-level locators "ch. 11": (a) R = i r sigma_A with i "a property of the
selected fraction alone", r "accuracy", sigma_A the additive s.d.; (b) i = phi(z)/(n/N), the intensity of an
infinitely large normal population. Book not available locally or open access; page/chapter not confirmed.
From memory (not evidence) ch. 11 of the 4th edition is the selection-response chapter and gives
R = h^2 S, S = i sigma_P, hence R = i h sigma_A; the general accuracy form R = i r sigma_A (r = correlation of
criterion with breeding value) is, to my recollection, developed for selection on information from relatives
(ch. 12) and goes back to Rendel & Robertson (1950, J Genet 50:1-8, doi 10.1007/bf02986789; found on Crossref,
content not read). So part (a) may be mis-located by one chapter. The truncation-normal formula (b) is in
Falconer ch. 11 and its Appendix table of i by my recollection. Suggest checking the print copy, or adding
Rendel & Robertson for the accuracy form. The two ch. 11 pointers earlier verified in chapters 00/01/02 were
ch. 1, 3-4, 5, 8, 14 -- none of them ch. 11, so there is no earlier verification to inherit.

### 02b-B5 -- book/02b-response.qmd:176-177 -- UNVERIFIED / PRECISION -- LOW
Key: `bulmer1971`. "The difference is exactly the gametic-phase disequilibrium term [@bulmer1971]". The
identity Var(X beta) - V_genic = 2 sum_{k<l} beta_k beta_l Cov(x_k, x_l) is pure algebra (and is asserted in the
chunk, `stopifnot(... ld)`); it does not need a source. What Bulmer 1971 contributes is that selection
generates negative gametic-phase disequilibrium among trait loci and thereby reduces the additive variance
below the genic value (confirmed by secondary snippets from later papers, including Bulmer's own 1974
follow-up: the reduction is temporary and reversed when selection stops). In this chapter there is no
selection: the covariance in the factorial arises from within-pool LD of the sampled lines, not from the
Bulmer mechanism. The citation is correct for the concept, but a reader could take "[@bulmer1971]" as saying
the term in the table is a Bulmer effect. Suggest "(the quantity Bulmer 1971 showed selection to alter)" or a
note that the table's term is sampling LD, not selection-induced. Original (Univ. Chicago Press, paywalled;
no PubMed record) not read. The term "genic variance" is not credited to anyone in the chapter; Bulmer is its
usual origin (Bulmer 1980 book, not checked), see B8.

### 02b-B6 -- book/02b-response.qmd:261-263 -- UNVERIFIED -- LOW
Key: `sprague1942`. "The exact orthogonal split of a hybrid value into general and specific combining ability
(GCA, SCA) [@sprague1942] is developed in @sec-heterosis-gca-sca". Sprague & Tatum define GCA and SCA and give
the variance analysis of single crosses; the exact allele-frequency decomposition (the book's
`heterosis_gca_sca()`, GCA weights built on the opposite pool's frequencies) is the book's own derivation, as
the next clause "developed in @sec-heterosis-gca-sca" implies. The citation supports the concept, not the
"exact orthogonal" form; wording could be "the GCA/SCA concepts [@sprague1942], here split exactly...".
Primary not reached (J Am Soc Agron 1942 paywalled; same status as 00-B10). Not a false attribution.

### 02b-B7 -- book/02b-response.qmd:24-26 and :160 -- MISSING SOURCE -- LOW
"pool allele frequencies drawn under the Balding-Nichols model with parameter `fst`" carries no citation.
`balding1995` exists in references.bib (Balding & Nichols 1995, Genetica 96:3-12, doi 10.1007/BF01441146) and is
cited at 00-hybrid-programme.qmd:583. Add [@balding1995] at first mention in this chapter (line 26).

### 02b-B8 -- book/02b-response.qmd:166-174 (@eq-response-genic) -- MISSING SOURCE -- LOW
V_genic = sum beta_k^2 Var(x_k) and the genic / realised-variance split are presented without a source for the
framework (only the disequilibrium term is cited, to Bulmer). For hybrids in an inbred-line factorial the
formula is exact by construction here, so no number is at risk. Candidates for the textbook statement: Bulmer
1971 (above, cited) and Falconer & Mackay (ch. on variance; the 02-subdivided review already noted
falconer1996 ch. 8 for additive genic variance, 02-B* line 507 of that chapter, itself unconfirmed). I did not
open a source that states the exact definition used, so I propose none beyond the already cited ones.

### 02b-B9 -- book/02b-response.qmd:314-340 and :376-394 -- MISSING SOURCE -- LOW
Standard results used without citation: (i) the weights maximising Cor(b'xi, a'g) are Var(xi)^-1 Cov(xi,g')a;
(ii) for BLUP, Cov(g_hat, g') = Var(g_hat) so b = a; (iii) the statement that single-trait BLUPs of correlated
traits break the condition. All three are algebraically verified by the chapter's own chunk
(`response-sh-proportional`: K = G P^-1; KPK' = G P^-1 G = KG, so Var^-1 Cov a = a, and K'a = b) and are
textbook (Henderson's BLUP property; Lynch & Walsh 1998, index-selection chapters). No primary source was
opened. No factual risk; a one-line pointer would help a reader. Also: the claim at 391 that the default
`weights = NULL` index equals a'g_hat with a_j = 1/sd(g_hat_j) is a code statement (build_ctx standardises),
not a literature claim.

## Claims checked and found supported by the chapter's own code (no source needed)
- b * S_I = i r sigma_A identically (lines 90-96): b = Cov(gv,I)/Var(I), S_I = i_real sd(I), r = Cov/(sd sd):
  algebraic identity, asserted in the chunk.
- @eq-response-hybrid-var, both forms, and the identity 2 p_bar q_bar = pA qA + pB qB + (pA-pB)^2/2: algebra
  checked by hand and by `stopifnot` in chunk `response-hybrid-var`.
- Restricted-index zero-gain property: shown above (B2) and asserted in the chunk.

## Not cited, flagged only for the editor (not required to be sourced)
- Line 17-20: "@sec-cycles will show a constrained programme overtaking an unconstrained one" is a book-internal
  forward claim, not literature.
- Lines 431-440: "I accept losing five percent ... a sentence a breeding committee can sign" is rhetorical.
- The claim "that is 1959" (priority of constraint over price in selection indices) is a historical claim with
  one cited primary source; the first restricted/desired-gains index literature includes Tallis (1962,
  Biometrics 18:120, doi 10.2307/2527716, found on Crossref, content not read) as the next step (proportional
  gains). The chapter's "Not the idea of constraining rather than pricing: that is 1959" is not contradicted
  by anything found, but "1959" as the origin of constraining in the whole of breeding is wider than one paper
  on selection indices can support; suggest "in selection-index theory".

## Evidence levels
Citation occurrences: 9 (6 distinct keys).
- FULL TEXT of the source: 0.
- ABSTRACT only: 0 (Hazel 1943 PubMed record has "Abstract not available"; Kempthorne, Smith, Bulmer, Sprague, Falconer have no PubMed abstract).
- Metadata only (Crossref/PubMed record) plus the chapter's own algebra and code: 9; every attribution item is
  therefore UNVERIFIED against the source. Metadata correct for all 6 keys.
- Why: Falconer (book, absent from reference/); Smith, Bulmer, Kempthorne, Sprague (paywalled; only
  third-party scans surfaced, not used per the brief); Hazel (PMC scanned PDF, full_text empty, PMC served a
  bot-check page).
Where I looked: reference/ (papers/ holds only Caballero-Toro-era diversity papers; no selection-index source;
README of new_mating_design mentions Kempthorne & Curnow 1961, a different paper), PubMed/PMC (Hazel only),
Crossref (all six DOIs), web search for Kempthorne & Nordskog and Bulmer abstracts, PMC page fetch for Hazel.

## Counts
HIGH 0, MEDIUM 2 (B1 overclaim, B2 restricted-index equation unverified), LOW 7 (B3-B9).
Items: WRONG 0, UNVERIFIED 6 (B2-B6 plus the unquantified part of B1), MISSING SOURCE 3 (B7-B9),
OVERCLAIM 1 (B1). Whole-book mode items (UNCITED) not run.
