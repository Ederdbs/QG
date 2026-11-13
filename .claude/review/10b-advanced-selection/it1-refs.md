# Reference check, chapter 10b-advanced-selection (iteration 1)

Chapter: book/10b-advanced-selection.qmd. Bib: book/references.bib.
Sources read: PubMed/PMC full text (Ahadi, Waldmann, Yadav, Fernandez-Gonzalez, Akdemir), local PDF
(De Beukelaer 2018, reference/papers/), arXiv PDFs (Cevallos, Chen, Younis), Crossref/DataCite/PubMed metadata.

Check 2: all 14 keys cited in the chapter resolve in references.bib (ahadi2024, akdemir2021, borodin2017, cevallos2016,
chen2018, debeukelaer2018, duran1986, fernandezgonzalez2026, fisher1978, minoux1978, nemhauser1978, waldmann2025,
yadav2025, younis2024). All 17 `@sec-` targets exist (none missing). The chapter does not cite @comstock1949.

## Findings

### 10b-B1  ahadi2024 -- WRONG (bib pages)
references.bib: `pages = {80--90}`. Crossref and PubMed give Heredity 133(2):113-125 (DOI 10.1038/s41437-024-00697-y;
PMID 38956397). Fix: `pages = {113--125}`, add `number = {2}`. Authors, year (2024), title, journal, volume correct.

### 10b-B2  chen2018, line 1239 -- WRONG attribution
Sentence: "log det(I + beta f_S) is genuinely submodular and monotone, so its greedy carries a 1 - 1/e guarantee [@chen2018]".
FULL TEXT of Chen, Zhang, Zhou (arXiv 1709.05135v2, Introduction, p. 1): they say only that the DPP log-probability is
submodular and that greedy has "relatively weak theoretical guarantees [13]" (Civril & Magdon-Ismail). Neither "monotone"
nor 1 - 1/e appears in the paper. The statement is mathematically defensible (L = I + beta f has all eigenvalues >= 1, so
log det(L_S) is monotone submodular and Nemhauser 1978 gives 1 - 1/e under cardinality), but that is the book's own
derivation, not Chen's result. Fix: cite @nemhauser1978 for 1 - 1/e and state the monotonicity argument (eigenvalues of
I + beta f at least 1); use @chen2018 only for "greedy MAP inference for DPPs" (the algorithm). Optional primary source for
log det(I + K_S) as monotone submodular information gain: Srinivas, Krause, Kakade, Seeger, IEEE Trans Inf Theory 2012,
DOI 10.1109/TIT.2011.2182033 (record found; text not read by me, so UNVERIFIED for the exact lemma).
Bib metadata (NeurIPS 31, pp. 5622-5633, 2018) not checked against the proceedings page; no DOI in entry (none exists for NeurIPS).

### 10b-B3  debeukelaer2018, lines 501-504 -- WRONG (misstated result)
Chapter: "found a plain stochastic hill-climber already competitive with a considerably more complex genetic algorithm".
FULL TEXT (BMC Bioinformatics 19:203, Results p. 6 and Table 1, Discussion p. 10): "Although the genetic algorithm also
outperforms random descent, it is not as effective as parallel tempering"; all pairwise differences (random descent, PT, GA)
significant (Holm-adjusted p 0.00013-0.00049). Table 1 E-NE, rice/coconut/maize/pea: random descent 0.1500/0.5748/0.4332/0.3337,
GA 0.1506/0.5755/0.4346/0.3386, PT 0.1508/0.5759/0.4359/0.3412. What the authors conclude (p. 10): a basic hill-climber
"already yields high-quality cores and a global optimization engine (genetic algorithm) did not provide any further advantage"
-- the comparison there is GA against parallel tempering. Also the GA uses random descent as its mutation operator, so
"considerably more complex" is the book's gloss. Fix: say the hill-climber (random descent) already gave high-quality cores with
low variability, the GA improved on it slightly but not as much as parallel tempering, so the authors prefer PT.
The clause "parallel tempering winning by combining many simple local searches" is supported (p. 4: "multiple cooperating local
searches executed in parallel", 10 replicas). Bib entry correct (DOI resolves, 3 authors, BMC Bioinf 19(1):203, 2018).

### 10b-B4  yadav2025, lines 506-509 -- UNVERIFIED (partly) and imprecise
FULL TEXT (PMC12414015, Results "Computational efficiency and convergence comparison"): AUC GA 0.879, DE 0.860, PSO 0.820,
SA 0.769 -- values match, ranking matches, wheat (583 lines) matches. But those AUCs are reported for the OPV fitness function
only ("confirmed visual observations for OPV (Fig.)"); the chapter states them without that qualifier (for OHS, PSO did best).
"DE running two to three times slower than GA": the text says only "longer runtime", "greater computational cost", "took longer
to run due to higher computational cost per iteration". No factor is stated in the text; any ratio would sit in figures/tables that
the PMC XML does not expose. UNVERIFIED (I could not read the figures; Springer page blocks automated fetch).
"for a marginally worse result": text says DE "performed comparably in final fitness"; acceptable.
Fix: add "for the OPV objective"; either give a figure/page for the 2-3x or write "took longer to run". Bib: Crossref/PubMed confirm
TAG 138(9):242, 2025, first author Yadav; `author = {Yadav, S. and others}` is acceptable but the full list is
Yadav, Dillon, McNeil, Dinglasan, Mago, Dodds, Hickey, Hayes.

### 10b-B5  younis2024, lines 1226-1229 -- UNVERIFIED (partly)
FULL TEXT (arXiv 2406.03932v1, Sections 2 and 4): the paper does model a breeding programme as an MDP, with action = number
of crosses made each generation, and names a "BREEDING GYM" base environment (so "BreedGym" is supported). Not found in the
paper: "how to allocate resources across cycles", "when to recycle", and "its successors" (other environments in the same
suite are SIMPLIFIED BREEDING GYM, SELECTION SCORES, PAIR SCORE; no later work cited). The paper's experiment is a selection-score
policy over T = 10 generations. Fix: describe it as crosses/selection decisions per generation with delayed reward and drop
"when to recycle" and "successors" or cite them. Bib: the entry is an arXiv preprint (arXiv:2406.03932, June 2024); the work was
first presented at the NeurIPS 2023 Workshop on Tackling Climate Change with ML (web search result, not read); not an error.

### 10b-B6  fisher1978, lines 181, 208 -- UNVERIFIED (full text not reachable)
Claim: "1/(p+1) under p matroids [@fisher1978]", proved for monotone non-negative submodular functions. Looked in: Springer
(blocked), UCLouvain DIAL record (its abstract text is the cardinality bound 1 - [(K-1)/K]^K, which is the abstract of Paper I, so
the record appears mislabelled), a secondary source (Wang et al., J Comb Optim) attributing the 1/(1+p) result to Fisher et al.
1978. Bib metadata verified (Crossref: Fisher, Nemhauser, Wolsey; Math Programming Studies 8:73-87; DOI 10.1007/BFb0121195).
Status: attribution plausible and consistent with the literature; not read in full text.
Note on the chapter's own use (line 213-216): cardinality + one partition matroid per pool = p = 3 matroids, i.e. 1/4, not a
number the chapter states; fine as written.

### 10b-B7  nemhauser1978 -- ABSTRACT only
Claim "1 - 1/e under cardinality" and the greedy attribution (lines 181, 192, 208). ABSTRACT (found via UCLouvain DIAL, text for
Paper I): greedy attains at least 1 - [(K-1)/K]^K for nondecreasing z with z(0) = 0, limit (e-1)/e. Bib verified by Crossref
(Nemhauser, Wolsey, Fisher; Math Programming 14(1):265-294, 1978, DOI 10.1007/BF01588971). The hypotheses the chapter lists
(monotone, non-negative) agree with the abstract's "nondecreasing, z(0) = 0".

### 10b-B8  minoux1978 -- ABSTRACT/metadata only
Lazy-greedy attribution (lines 188-191). Crossref: Minoux, "Accelerated greedy algorithms for maximizing submodular set functions",
LNCIS 7 (Optimization Techniques), pp. 234-243, DOI 10.1007/BFb0006528. Bib pages and series correct; DOI missing from the entry
(add `doi = {10.1007/BFb0006528}`). The stale-gain-as-upper-bound statement is the standard lazy-greedy argument; Minoux full text
not read: UNVERIFIED at full-text level. Nemhauser 1978 correctly kept separate as the guarantee.

### 10b-B9  duran1986, lines 885-886 -- ABSTRACT/metadata only
Bib verified (Crossref: Duran & Grossmann, Math Programming 36(3):307-339, 1986, DOI 10.1007/BF02592064). Claims "needs only a
MILP solver" and "each cut strictly removes the infeasible point that generated it" not checked against full text (paywalled):
UNVERIFIED. Note the original algorithm alternates NLP subproblems and a MILP master; the chapter's version (cuts at the
violating point, no NLP subproblem) is a simplification, reasonable but not literally Duran & Grossmann.

### 10b-B10  MISSING SOURCE -- NSGA-II and DPP, lines 1209-1243
"Multi-objective, and why not NSGA-II" names NSGA-II with no citation; "Determinantal point process" is introduced with no
citation to the DPP primer. Sources found (Crossref-verified metadata): Deb, Pratap, Agarwal, Meyarivan (2002), "A fast and
elitist multiobjective genetic algorithm: NSGA-II", IEEE Trans Evol Comput, DOI 10.1109/4235.996017; Kulesza & Taskar (2012),
"Determinantal point processes for machine learning", Found Trends Mach Learn, DOI 10.1561/2200000044. The epsilon-constraint
method (line 1211) and the Bayesian-optimisation remark (line 1235) are also uncited; no source proposed.

## Confirmed (no finding)
- ahadi2024 attribution (lines 948-951), FULL TEXT: Discussion states ILP is NP-hard and "settle for sub-optimal (but good
  quality) feasible solutions" via "decomposition techniques"; solver is Gurobi (commercial). The quotation matches verbatim.
- waldmann2025 (lines 758-759), FULL TEXT: two-stage GOCSMA (OCS then mate allocation); Results 3.2: "The runtime of SCIP was <0.01
  seconds for all four ... MA evaluations". Matches. Bib: Bioinformatics Advances 5(1):vbaf259, published 22 Oct 2025 (PubMed),
  Crossref lists an earlier online date 26 Dec 2024; the bib year 2025 is acceptable. Note the study is an animal-style
  QTLMAS2010 pedigree, genomic G not molecular f; the chapter only borrows the two-stage shape, which is faithful.
- cevallos2016 (line 181, and the negative-type remark lines 108-111), FULL TEXT (arXiv 1511.07077, abstract p. 1): "we present a
  PTAS for the max-sum diversification problem under a matroid constraint for distances d of negative type"; negative type
  includes l2-metric-derived distances (squared Euclidean = Gram-derived d, as the chapter says). Bib verified by DataCite:
  LIPIcs vol. 51, SoCG 2016, art. 26, pp. 26:1-26:14, DOI 10.4230/LIPIcs.SoCG.2016.26.
- borodin2017 (line 129), metadata verified (Crossref: ACM Trans Algorithms 13(3), art. 41, pp. 1-25, 2017, DOI 10.1145/3086464);
  the chapter cites it only for the name "max-sum diversification" and the identity sum_{i<j} d_ij = n tr(f_S) - n^2 theta_S,
  which I checked algebraically (correct). Borodin's own guarantees need a metric d, which squared Euclidean distance is not; the
  chapter does not claim them.
- akdemir2021 and fernandezgonzalez2026 (lines 509-511), FULL TEXT: TrainSel "uses GA in conjunction with simulated annealing
  (SA) steps" (Akdemir, Introduction and Sec. 2.2); MateR is optimised "with TrainSel, a hybrid heuristic that blends a genetic
  algorithm with simulated annealing" (Fernandez-Gonzalez, Materials and methods). Bib metadata verified (Front Genet 12:655287;
  Genetics 232(4):iyag013, 2026, DOI 10.1093/genetics/iyag013).
- comstock1949 (PENDING, existence/title only): exists. Crossref: Comstock, Robinson, Harvey, "A Breeding Procedure Designed To
  Make Maximum Use of Both General and Specific Combining Ability", Agronomy Journal 41(8):360-367, Aug 1949,
  DOI 10.2134/agronj1949.00021962004100080006x. Matches the bib entry. Not cited by this chapter.

## Evidence summary
Citations checked: 14 keys cited in the chapter (plus comstock1949 as pending, not cited here).
- FULL TEXT: 7 (ahadi2024, waldmann2025, debeukelaer2018, yadav2025 [text only, figures not readable], fernandezgonzalez2026,
  akdemir2021, cevallos2016) + chen2018 and younis2024 read in arXiv full text = 9 in total.
- ABSTRACT or metadata only: 3 (nemhauser1978, minoux1978, duran1986) + borodin2017 (metadata plus algebra).
- UNVERIFIED: 1 (fisher1978, full text unreachable).
Findings: 1 bib error (B1), 2 wrong attributions (B2, B3), 2 partly unsupported (B4, B5), 1 unverified (B6), 3 abstract-level
notes (B7-B9), 1 missing-source group (B10).
