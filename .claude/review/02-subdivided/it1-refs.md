# Reference check: book/02-subdivided.qmd (iteration 1)

Bibliography: book/references.bib. Date: 2026-11-07. Read-only on the book.

Scope: 9 distinct keys, 30 citation occurrences (caballero2002 x11, toro2005 x10, meuwissen1997 x2,
falconer1996 x2, cockerham1967, cockerham1969, nei1973, wright1951, lindgren1997 x1 each). All 9 keys
resolve in references.bib. All 14 cross-reference targets of the chapter (@sec-ocs, @sec-notation,
@sec-coancestry, @sec-heterosis-flat, @sec-choosing, @sec-response, @sec-limits, @sec-catalogue,
@sec-cycles, @sec-heterosis, @sec-stages, @tbl-keystone, @eq-alpha-g, @eq-response-genic) exist.
Chapter-internal labels (@eq-*, @tbl-*, @sec-ct-removal) resolve inside the chapter.

Bibliography metadata: DOIs of toro2005, cockerham1969, nei1973, meuwissen1997, wright1951, cockerham1967
checked on Crossref (authors, title, journal, volume, issue, pages, year): all match; `updated-by` empty
(no retraction or corrigendum). wright1951: Crossref dates the issue 1949 (known, see 00-B13). meuwissen1997:
Crossref gives page "934", PubMed "934-40": bib "934--940" is right. caballero2002, cockerham1967, lindgren1997,
falconer1996 were verified in 00/01 and not redone.

Evidence levels: FULL TEXT = read the source itself (local PDF via pdftotext, or the PMC page text). The PMC
page of Toro & Caballero 2005 (PMC1569508) was read through the fetch tool (a summarising model), which returns
short verbatim fragments and headings; PubMed's own full-text tool returns an empty body for that PMCID, and
Europe PMC / publisher PDFs are blocked. Items resting on that route are marked FULL TEXT (PMC, fragments).

Severity: HIGH = false statement of a source; MEDIUM = reader misled / wrong locator; LOW = wording, stale
note, uncited standard result, or primary source not reached.

## Findings

### 02-B1 -- book/02-subdivided.qmd:546 and :630 -- WRONG (locator) -- MEDIUM
Key: `toro2005`. The chapter attributes the metapopulation effective-size equation (@eq-ne-meta) and the
statement "equalising contributions within subpopulations doubles N_e" to "[@toro2005, §4a]" (line 546
"in the form restated by @toro2005 [§4a]"; line 630 "[@toro2005, §4a]").
Evidence (FULL TEXT, PMC fragments, https://pmc.ncbi.nlm.nih.gov/articles/PMC1569508/): the section list is
3(a) Partition of gene diversity; 3(d) The Weitzman approach; 3(e) How important is within- versus
between-population genetic diversity?; 4. Relationship between molecular and quantitative measures;
4(a) Theoretical expectations (F_ST vs Q_ST); 5. Dynamic genetic management; 5(a) Genetic effects of
subdivision. The effective-size passage is in 5(a): "Let us consider a simple expression of the metapopulation
effective size assuming random mating within populations," Ne ~ 2Nn / ((V_W+V_B+1)(1-F_ST)); "the variances of
long-term contributions of individuals within- and between populations"; "this gives a doubling of effective
size, Ne ~ 2Nn/(1-F_ST)"; "they will reach an asymptotic value after a sufficient number of generations".
So the equation, its assumptions (random mating, asymptote) and the doubling are faithful, the section is not:
4(a) is Q_ST/F_ST theory. Fix: "§5a" in both places.
Related, from the local 2002 full text (FULL TEXT, p. 296, Eq. 14): the general form is
Ne ~ 2Nn / [(V_WS(0,inf) + V_BS(0,inf) + 1)(1 - F_IT)]; the chapter's (1 - F_ST) is the F_IS = 0 case, which the
chapter states ("random mating within subpopulations") but does not say is a special case of Eq. 14 of the 2002
paper. Eq. 15 (p. 296) gives the same in terms of S_W^2, S_B^2. Optional: cite "Eq. 14 of @caballero2002" and say
(1 - F_IT) = (1 - F_ST) under random mating. The 2002 paper's text also states the equal-contribution result
(p. 298: "equal contributions from each subpopulation (S_B^2 = 0 in Equation 15) and equal contributions from each
individual within subpopulations (S_W^2 = 0 in Equation 15)"; its sentence ends "to maximise the average
coancestry of the metapopulation" -- a slip in the source for effective size).

### 02-B2 -- book/02-subdivided.qmd:630-633 -- WRONG (stale statement) -- LOW (MEDIUM for the audit trail)
Claim: "Only the 2005 review was accessible when this chapter was checked; values attributed to the 2002 paper
without a 2005 counterpart (the worked example's matrix, s~ and contributions) are transcribed from it and were
not re-checked against its full text."
The 2002 full text is available (reference/papers/Analysis_of_genetic_diversity_..., Conservation Genetics 3:
289-299) and was read in full. The sentence is no longer true and should be replaced by the verification below.
Checked against Table 2 and Table 3 of the 2002 paper (FULL TEXT, pp. 293-294):
- N = 12, 4, 8, 6; three loci with 5, 3, 3 alleles (p. 292): match.
- Coancestry matrix of lines 369-372 = Table 2a, all 10 distinct entries: match (0.3391, 0.3021, 0.2535, 0.3229,
  0.8750, 0.3073, 0.3889, 0.4766, 0.2483, 0.3704).
- Published values f~ 0.4535, s~ 0.7056, D-bar 0.1279, f-bar 0.3256, F_ST 0.1897, GD_T 0.6744, GD_WI 0.2944,
  GD_BI 0.2521, GD_BS 0.1279 (Table 2b footer): match lines 391-392. 0.2944+0.2521+0.1279 = 0.6744: closes.
- Contributions for maximum GD (Table 3, last column): 0.522, 0.000, 0.270, 0.208: match line 487/494.
  Text p. 293: pool diversity "0.6874, i.e. an increment of 1.92%": consistent with the chapter's computed gain.
- Removal analysis recomputed independently here from the same matrix (census weights / equal weights): GD_T
  without subpop 1..4 = 0.6296, 0.6869, 0.6481, 0.6690 (Table 3 col. 2: identical); change -6.6, +1.8, -3.9, -0.8 %
  (census; Table 3 col. 3: identical) and -6.9, +6.5, -6.9, -3.6 % (equal; Table 3 col. 4: -6.8, +6.5, -7.0, -3.6).
  The two 0.1-point differences (subpops 1 and 3, equal weights) are rounding of the 4-decimal matrix; the value
  quoted in the chapter text (subpop 2: +1.8 % census, +6.5 % equal) matches exactly.
- Weitzman: subpop 2 has the largest loss (-65.5, Table 3 col. 5), as the chapter's `which.max(lg$dist) == 2` states.
- Pig breeds: 2002 Table 5, FRBA: Weitzman -15.2 (largest of the eleven), +2.62 - 1.95 = +0.67; DESH:
  -1.80 - 1.14 = -2.94. 2005 Table 4 (PMC fragments): FRBA identical (+0.67), DESH -1.80 - 0.14 = -1.94, footnote
  "This corrects a mistake in Caballero & Toro (2002)". So lines 464-467 (FRBA, 0.67 %) and 625-628 (DESH
  correction, "Table 4, footnote a") are faithful, and the 0.67 % is the same in both papers.
- Aside, not a chapter error: the 2002 text (p. 295) says "Removal of the FRBA breed will produce the largest
  increase in diversity", but its own Table 5 (and the 2005 Table 4) has FRLI at +0.68 > FRBA at +0.67. The chapter
  does not claim FRBA gives the largest increase, only the largest Weitzman loss.
Fix: replace lines 630-633 by "the worked example (matrix, s~, contributions) was checked against the 2002 full
text" and drop the "not re-checked" caveat; keep the DESH remark.

### 02-B3 -- book/02-subdivided.qmd:43-45 -- MISSING SOURCE -- LOW
Claim: "the plug-in form, without the small-sample correction 2N_i/(2N_i - 1)". The factor is standard but has no
citation, and nei1973 (cited) does not supply it. Primary sources found: Nei & Chesser (1983), Ann. Hum. Genet.
47: 253-259, https://doi.org/10.1111/j.1469-1809.1983.tb00993.x (the 2002 paper cites it, p. 292, for "corrections
... due to finite sample size"); Nei (1978), Genetics 89: 583-590, https://doi.org/10.1093/genetics/89.3.583
(PMID 17248844; abstract: "formulae for obtaining unbiased estimates of average heterozygosity"). Only the
abstract of Nei 1978 and the Crossref record of Nei & Chesser were seen; the exact factor 2n/(2n-1) was not
read in either, so the proposal is UNVERIFIED as to the formula. Neither is in references.bib.

### 02-B4 -- book/02-subdivided.qmd:339-350 -- MISSING SOURCE -- LOW
The three bullets (outcrossers: GD_WI large; selfers and DH/line collections: GD_WI ~ 0, "regenerating with few
plants per line is acceptable; losing lines is not"; clonal crops: GD_WI "frozen", "the N_e algebra does not
apply without adaptation") read as the content of the cited paper because the section sits inside the
@caballero2002 chapter. They are not in the 2002 paper (FULL TEXT: no mention of selfers, clones or
reproductive systems; its examples are livestock breeds) and the 2005 headings do not suggest them either. The
origin is the Portuguese working note (reference/caballero_toro/..., lines 152-153), i.e. the book's own
reading. The first two follow from the definitions (s = 1 for inbred lines gives GD_WI = 0; checked by the
chapter's own code), the clonal "frozen" claim and the regeneration advice are judgement. Fix: add one clause
("the following is the book's reading of the partition, not a result of the paper") or cite a source on
regeneration of inbred accessions.

### 02-B5 -- book/02-subdivided.qmd:608-611 -- MISSING SOURCE (attribution gap) -- LOW
"Allelic richness is more sensitive to bottlenecks than heterozygosity" has no citation at the sentence; the
following citation [@toro2005, §2] supports only the "effective number of alleles is the inverse of mean
coancestry" step (PMC fragment: "'the effective number of alleles' is, by definition, the inverse of the mean
coancestry"; the paper says "allelic diversity", not "allelic richness"). The bottleneck statement is in the
2002 paper, p. 297 (FULL TEXT): "As this latter [allelic diversity] is more sensitive to bottlenecks than average
heterozygosity ... minimisation of mean coancestry maximises the effective number of alleles. Therefore, it is
expected that maximisation of genetic diversity will lead to maximum allelic richness in long-term conservation
programmes" (citing Petit et al. 1998, Barker 2001, Crow & Kimura 1970). Fix: add @caballero2002 there. The
chapter's "does not protect rare alleles in the short term" is its own caveat, consistent with "long-term".

### 02-B6 -- UNVERIFIED (primary not reached) -- LOW
- `wright1951`, line 223: "Wright's fixation indices [@wright1951] written in coancestries". Wiley paywalled; not
  fetched from third-party copies. Secondary, FULL TEXT: the 2002 paper Eq. 6 (p. 291) writes F_IS, F_ST, F_IT in
  coancestries with (1-F_IT) = (1-F_IS)(1-F_ST), crediting Wright (1969) -- consistent with the chapter's
  @eq-f-stats, not a check of the 1951 paper. Year (1949 issue vs 1951): see 00-B13.
- `cockerham1969`, lines 224-225: "the form F_ST = D-bar/(1 - f-bar) is due to @cockerham1969, as restated by
  @toro2005 [§3a]". Cockerham 1969 not reached (PubMed: no abstract/full text; Wiley paywalled). The attribution
  is carried by Toro & Caballero 2005 §3a (FULL TEXT, PMC fragments): "Wright's fixation index ... F_ST = GD_B/GD_T
  = D-bar/(1 - f-bar), citing Cockerham (1969)". The chapter's wording ("as restated by") is thus faithful to the
  secondary source; the primary is UNVERIFIED.
- `cockerham1967`, line 42 ("group coancestry in the sense of"): PMC1211496 is image-only (no text through
  PubMed or the fetch tool). Secondary, FULL TEXT: 2002 paper p. 290, f_ij "including all Ni x Nj pairs (Cockerham
  1967)", so f_ii averages over all N_i x N_i pairs, self-pairs included -- consistent with the chapter's
  "includes the pairs of an individual with itself".
- `nei1973`, line 43: "exactly Nei's gene diversity 1 - sum p^2". Abstract only on PubMed/PMC
  (PMC427228; full text image-only). Secondary, FULL TEXT: 2002 paper p. 296, "expected heterozygosity, proposed
  by Nei (1973), ... defined as the probability that two alleles chosen at random from the population are
  different", and p. 291 "total diversity 1 - f-bar = 1 - sum p-bar_k^2".
- `meuwissen1997`, lines 521-529: ABSTRACT only (PMID 9110204,
  https://doi.org/10.2527/1997.754934x): "maximizes the genetic level of selected animals while constraining their
  average coancestry to a predefined value"; "only EBV of, and relationships between, the selection candidates":
  supports "maximises c'u subject to a bound on c'fc, u = EBV". That the method is posed in Lagrangian form
  (@meuwissen1997's own derivation vs the chapter's rewrite) was not seen.
- `falconer1996`, line 573 (ch. 4: N_e = 4N/(2 + V_k)) and line 507 (ch. 8, additive genic variance): book not
  reachable (denied, see 00-B7). The chapter's algebra for 4N/(2+V_k) = 2N/(1+V_k/2), the factors 4/3 and 2, and
  the variance p-bar q-bar / 2 of a 0/0.5/1 genotype at Hardy-Weinberg were rechecked and are correct.
  Chapter numbers (ch. 4 effective size and V_k; ch. 8 variance) agree with the contents of the 4th edition as
  remembered, not as read.
- `lindgren1997`, line 534 (N_s = 1/(2 f-bar), "by definition"): covered by 01-coancestry; not redone. Note the
  original definition paper is Lindgren, Gea & Jefferson (1996, Silvae Genetica 45: 52-59), not in the bib.

## Checked and found faithful

| Line | Key | Claim | Evidence | Level |
|---|---|---|---|---|
| 10, 227-232, 253-268 | caballero2002 | partition (1-f-bar) = (1-s~)+(s~-f~)+(f~-f-bar); GD_WI/GD_T = (1-G)(1-F_ST), GD_BI/GD_T = G(1-F_ST), GD_WS/GD_T = 1-F_ST, GD_BS/GD_T = F_ST | Eq. 7 and Eq. 8, p. 291 | FULL TEXT |
| 131-132 | caballero2002 | alpha_i = (F_i-f_ii)/(1-f_ii), G_i = (s_i-f_ii)/(1-f_ii), (1-alpha_i) = 2(1-G_i) | Eq. 2, p. 290 (Table 2b: G_1 0.4746 = (1-0.0508)/2) | FULL TEXT |
| 103-104 | caballero2002 | F_i = 2 s_i - 1; s_i = sum p_{k,l,i}^2/N_i, p in {0, 0.5, 1} | p. 290, Eq. 12, p. 291 | FULL TEXT |
| 168-169 | caballero2002/toro2005 | D_ij = (f_ii+f_jj)/2 - f_ij = sum (1/2)(p_ki - p_kj)^2; "Nei's minimum distance" | Eq. 3 p. 290; p. 291 text; Toro 2005 §3a names D_ij as Nei's minimum distance | FULL TEXT |
| 180-195 | caballero2002 | d-bar_ij = (s_i+s_j)/2 - f_ij for individuals; D_ij = d-bar_ij - (d-bar_ii+d-bar_jj)/2 | p. 290 ("average distance between individuals ... D_ij = (s_i+s_j)/2 - f_ij") and Eq. 3 | FULL TEXT |
| 200-202 | caballero2002 | f-bar = sum (N_i/N_T)[f_ii - sum_j D_ij N_j/N_T] | Eq. 5, p. 290 | FULL TEXT |
| 218-222 | caballero2002 | F_IS, F_ST = (f~-f-bar)/(1-f-bar) = D-bar/(1-f-bar), F_IT; (1-F_IT) = (1-F_IS)(1-F_ST) | Eq. 6, p. 291 | FULL TEXT |
| 456-457 | toro2005 | Weitzman approach is distance-only | §3d, "the Weitzman method only gives weight to the distance among populations" | FULL TEXT (PMC) |
| 465, 625-626 | toro2005 | Table 4 = corrected reanalysis of the Laval pig data; footnote on DESH | Table 4 caption "Reanalysis of genetic diversity using the data of Laval et al. (2000)"; footnote "This corrects a mistake in Caballero & Toro (2002)" | FULL TEXT (PMC) |
| 600-602 | toro2005 | within-population criteria favour the largest populations | §3e, "an over-emphasis on within-population variation will favour the largest breeds" | FULL TEXT (PMC) |
| 616-618 | toro2005 | minimum contributions, five Iberian strains, Table 5 | §3e: "set up a minimum for the contribution of any strain or variety"; Table 5 tests a 0.02 minimum | FULL TEXT (PMC) |
| 363-364, 494-495 | caballero2002 | worked example, published matrix, c = (0.522, 0, 0.270, 0.208) | see 02-B2 | FULL TEXT |
| 521-523 | meuwissen1997 | maximise genetic level subject to average-coancestry bound; EBVs | abstract | ABSTRACT |

Algebra in the chapter checked independently (no source needed): G = sum N_i(1-f_ii)G_i / sum N_i(1-f_ii) and
the census-mean failure (s~-f~ = sum w_i G_i (1-f_ii); 1-f~ = sum w_i (1-f_ii)); the drift paragraph (lines
354-359: Delta f~ gives Delta/2 in f-bar for two equal pools, GD_WS -Delta, GD_BS +Delta/2, GD_T -Delta/2);
D_ij = d-bar_ij - (d-bar_ii+d-bar_jj)/2 and d-bar_ii = s_i - f_ii; ne_fm/ne_ct equivalence (V_W = V_k/2); factors 4/3
and 2.

## Counts

30 citation occurrences, 9 keys. FULL TEXT: 21 (caballero2002 x11 local PDF; toro2005 x10 via PMC fragments, one
of them with the wrong section locator, 02-B1). ABSTRACT: 2 (meuwissen1997). Primary not reached, secondary
FULL TEXT only: 7 (wright1951, cockerham1969, cockerham1967, nei1973, falconer1996 x2, lindgren1997 [01 covered]).
Findings: HIGH 0, MEDIUM 1 (02-B1), LOW 5 (02-B2 to 02-B6). Uncited-claim findings: 02-B3, 02-B4, 02-B5.
UNVERIFIED: the items of 02-B6 and the exact formula in 02-B3.

## Where primary sources were sought

reference/ (main checkout, papers/): caballero2002 (pdftotext, full); not present: toro2005, nei1973, wright1951,
cockerham1967/1969, meuwissen1997, falconer1996. PubMed/PMC tools: abstract only for meuwissen1997, nei1973, nei1978;
empty body for cockerham1967 and for toro2005 (PMC1569508). Web: Crossref (six DOIs, Nei & Chesser 1983 located by
title), pmc.ncbi.nlm.nih.gov/articles/PMC1569508 via the fetch tool (full text of Toro & Caballero 2005 as
fragments), PMC427228 and PMC1211496 (abstract/metadata only, image PDFs), Europe PMC REST (HTTP 500), europepmc.org
(403), royalsocietypublishing.org PDF (blocked), PMC PDF endpoints (proof-of-work page), NCBI BioC (rate-limited),
efetch db=pmc (publisher disallows XML). No third-party copies of paywalled papers were fetched.
