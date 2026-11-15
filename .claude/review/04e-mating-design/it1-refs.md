# 04e-mating-design -- reference check, iteration 1

Chapter: `book/04e-mating-design.qmd`; bib: `book/references.bib`. Checked 2026-11-12.
Sources used: Crossref (all 51 DOIs resolved), Europe PMC / PMC full text, PubMed abstracts, publisher
pages (OUP, PMC via WebFetch). `reference/papers/` holds only five diversity papers, none cited by this
chapter, so there were no local PDFs to read. PubMed data are cited as "according to PubMed" with DOIs.

Check 2 (every `@key` resolves): all 51 citation keys of the chapter exist in `references.bib`. None unresolved.
No retraction found. One corrigendum touches an entry (04e-B1).

## Findings

### 04e-B1  bib key `fritscheneto2018`  -- WRONG (metadata, minor)
The bib author is `Fristche-Neto`. The paper is by Fritsche-Neto. The published Correction (doi:10.1007/s00122-018-3118-2,
"Correction to: Accuracy of genomic selection to predict maize single-crosses...", 2018-05-23) repairs exactly this
surname. PubMed lists it as Fritsche-Neto R, Akdemir D, Jannink JL (doi:10.1007/s00122-018-3068-8). Crossref's record
for the main DOI still carries the typo, which is the likely origin. Fix: `Fritsche-Neto`, and add volume 131, pages 1153--1162.
(Melchinger 2023 repeats the typo in its own text: copying a citation from another paper propagates it.)

### 04e-B2  line 516-519  (@melchinger2023)  -- WRONG (direction of effect reversed)
Chapter: for hybrids with both parents untested at c = 1, accuracies 0.50--0.65 (h2 = 0.4) and 0.70--0.85 (h2 = 0.8),
"the low end belonging to the high-SCA scenario, and found raising c from 1 to 4 helped most exactly there."
FULL TEXT (PMC10397156, Results, data set DS2): "The maximum r_a for c = 1 referring to tau_SCA = 22 % and 1 %
ranged for low h2 between 0.50 and 0.65 and for high h2 between 0.70 and 0.85" -- the numbers are right (and are for
DS2, N_TS = 96, H0 hybrids). But: "For H0 hybrids, r_a was maximum for c = 1, exceeding r_a values for c = 2 and c = 4
by ~1-3 % and ~5-10 %", and the abstract: "r_a of H0 hybrids and GCA of I0 lines was highest for c = 1. Conversely,
for GCA of I1 lines and H1 and H2 hybrids, c = 1 yielded lowest r_a". Raising c from 1 to 4 LOWERS accuracy for
hybrids with both parents untested (the DS2 gap between c = 1 and c = 4 is larger than in DS1, but c = 1 is on top).
The sentence says the opposite. Suggested: "c = 1 maximised accuracy for such hybrids; the cost was lower accuracy
for hybrids with one or both parents in the training set."

### 04e-B3  line 855 (tbl-mating-crosscheck row 2, @melchinger2023)  -- WRONG (attribution)
Table row "Spend on parents, c = 2 to 4 [@melchinger2023]". The paper does not recommend c = 2 to 4. FULL TEXT: key
message "Training sets produced by maximizing the number of parent lines, each involved in one cross, had the highest
prediction accuracy for H0 hybrids, but lowest for H1 and H2 hybrids"; abstract: "the optimum choice of c for
maximizing selection response across all types of hybrids depends on the size and resources of the breeding program";
"the prediction accuracy across all hybrids in set H had its maximum for c = 1 in all scenarios" (N_TS = 96, 144).
The published expectation is "maximise parents (c = 1) for new lines; c is a trade-off between H0 and H1/H2", not
"c = 2 to 4". The verdict column ("Supported for ranking; ... Refines") then compares against a claim the source
does not make. Rewrite the expectation, or cite the paper for what it says.

### 04e-B4  line 827  (@fritscheneto2021)  -- WRONG (trait mix-up in a numeric claim)
Chapter: "A genomics-guided pre-selection that discarded 70 % of candidate single crosses retained 85 to 95 % of the
top 5 % in a tropical maize programme."
FULL TEXT (PMC, Roadmap Review, section on non-additive effects): "selecting 30% of the best single-crosses during the
pre-selection phase in the field, based on GP with additive and non-additive effects, leads to a subset of hybrids that
contained 85-95, 70-80, and 75-85 of the 5% higher hybrids for ear height, plant height, and GY (Figure 5)". 85--95 is
ear height; grain yield is 75--85, plant height 70--80. Say the trait, or give 70--95 %. (Also: this is a
cross-validation result on one Brazilian data set reviewed in a roadmap paper.)

### 04e-B5  lines 424-430  (@chaingeni2025)  -- WRONG (overattribution)
Chapter: the number of testers per stage "turns out to be among the highest-leverage parameters of the whole scheme:
replacing a 4-1-1 tester plan with a 2-2-1 plan, with doubled haploids and higher selection intensity, raised gain per
dollar by 43.1 % and cut the cost of a unit of gain by 28.5 %".
FULL TEXT (PMC, Frontiers Plant Sci 2025): 43.1 % and 28.5 % are right but they belong to the COMBINATION DH + 2-2-1 +
increased selection intensity at Stages 1-2 (Table 9). The 2-2-1 change on its own (Table 7) gave +10.1 % gain per
cycle, +8.2 % gain per dollar and -7.4 % cost per unit of gain ("2-2-1 scheme increased total gain per cycle by an
average of 10.1%, gain per year by 38.7%, gain per dollar by 8.2%, and reduced cost of one unit of genetic gain by
7.4%"). Its benefit comes largely from the larger Stage-1 population the saved budget buys. The paper does not
call tester number a high-leverage parameter, and the cited headline is not a tester effect. Also: it is a
deterministic budget model for the Zimbabwean national programme, not a simulation, and the paper itself says results
"cannot be extrapolated to other breeding programs". Suggested: quote the 8.2 % / 7.4 % for tester alone and the 43.1 % / 28.5 %
for the bundle.

### 04e-B6  lines 156-157  (@comstock1949; PENDING source)  -- FLAG: attribution to unread content
"@comstock1949 built reciprocal recurrent selection on them -- the direct ancestor of the two-pool programme."
Existence and title are confirmed (Crossref: Comstock, Robinson, Harvey, "A breeding procedure designed to make maximum
use of both general and specific combining ability", Agron. J. 41(8):360--367, doi:10.2134/agronj1949.00021962004100080006x;
bib matches). The clause attributes content (that the paper introduced reciprocal recurrent selection, and that it was
built on the NC layouts of @comstock1948). The rule for this iteration forbids that. Note the second part is
especially doubtful: RRS rests on GCA/SCA and testcross ideas, not on the NC designs. Suggested wording limited to
existence/title: "reciprocal recurrent selection is the subject of @comstock1949" or drop the claim until a copy is read.
Status: UNVERIFIED (no copy, full text not reachable; abstract not on Crossref/PubMed).

### 04e-B7  line 838  (@kinghorn2011)  -- UNVERIFIED / overreach
"Constrained mate allocation with a mating permission matrix [@kinghorn2011] is what makes optimising a crossing list
over a 200 x 200 candidate space, subject to nursery constraints, computationally routine."
ABSTRACT/FULL TEXT (PMC, GSE 43:4): Kinghorn describes a mate-selection algorithm "that makes it possible to apply
constraints on certain matings, as dictated through a group mating permission matrix", "several hundred times faster
than the previous strategy of penalising solutions" for "the scenario tested" (livestock-style groups). It says nothing
about a 200 x 200 plant crossing space or nursery constraints. The first half (permission matrix) is supported; the
"200 x 200 ... routine" part is the chapter's own inference and should not carry the citation.

### 04e-B8  line 730  (@massman2012 in the group [@technow2012; @massman2012; @technow2014])  -- UNVERIFIED (weak fit)
Cited for "pool-specific additive kernels for GCA plus a dominance or product kernel for SCA". ABSTRACT (PubMed
22886355): Massman et al. compare a BLUP approach with marker-based relatedness to RR-BLUP marker effects on 479 BSSS x
non-BSSS single crosses (r = 0.87 yield); no dominance/SCA kernel or pool-specific effects are mentioned.
Technow 2012 (dominance + population-specific marker effects) fits the description; Massman fits "predicting single
crosses from marker relatedness". Full text not reached for Massman. Consider moving it next to @bernardo1994.

### 04e-B9  lines 181, 222, 345, 424, 860  (@stuber1966, @hallauer2010)  -- UNVERIFIED
- @stuber1966 (l.181), "the classical structure ... for a cross between two populations": metadata verified
  (Genetics 54:1279--1286, Crossref). Full text not reachable (PMC1211293 PDF blocked, OUP 403, abstract absent); the
  claim that GCA = sum[a + d(1 - 2 p_other)] du matches the standard average-effect result but was not read in the source.
- @hallauer2010 (book, no copy on disk, not reachable online): "sqrt of the heritability of a testcross mean" (l.222), tester-choice
  treatment (l.345), "elite tester produces hybrids that are themselves candidate products" (l.424), "testers lose SCA
  information" (l.860). Nothing verified at page level. Chapter/pages are not given in the chapter; add them.
- @jenkins1932 (l.343): "The topcross method goes back to @jenkins1932". Metadata OK (Agron. J. 24:523--530). The AGRIS
  record shows the paper tests inbred lines in crosses with open-pollinated varieties; the topcross is usually credited to
  Davis (1927) earlier, with Jenkins & Brunson (1932) as the evaluation of testing methods. I could not confirm either
  from an accessible source: UNVERIFIED. Soften to "the testcross tradition ... @jenkins1932".

### 04e-B10  line 156  (@comstock1948; and l.492 "NC II in sets ... [@comstock1948]")  -- UNVERIFIED
Metadata verified (Biometrics 4(4):254--266; PubMed 18108899, abstract "not available"). Title is about components of
variance of biparental progenies and average degree of dominance. Claim "designed the North Carolina layouts to separate
their variances" and that NC Design II is in this paper: full text not reached. Secondary sources attribute Design I to
Comstock & Robinson (1948, 1952) and cite Design II (and III) to 1952 in at least one comparison (Kearsey); the 1948/1952
split of Designs I/II/III was not resolved. Check before attributing NC II to the 1948 paper alone.

### 04e-B11  line 755  (@technow2019)  -- minor imprecision
Chapter: "the advantage of a better training-set composition shrank from 0.15 correlation points for well-connected
hybrids to 0.06 for T0 under a divergent heterotic structure." FULL TEXT (PMC6505161): "The difference between the two
[F1 vs F1:2 training sets] was largest for the divergent heterotic group structure, where it reached from 0.15 points
for T3 hybrids to 0.06 points for T0 hybrids" under constant residual variation. The numbers are right; the two training
sets differ in type (F1 hybrids vs F1:2 bulks), not "composition", and the value holds for constant residual variation only
(with constant heritability the gap closes). T3 = hybrids used in the training set.

### 04e-B12  bib completeness (minor)
Entries with DOI right but without volume/pages (Crossref values): bernardo1994 34:20--25; bernardo1996 36:50--56;
burdo2021 61:3425--3435; chaingeni2025 16:1553272; fernando1983 66:1399--1402; fritscheneto2018 131:1153--1162;
fritscheneto2021 12:658267; giraud2017 207:1167--1180; gonzalezdieguez2021 218:iyab026; jenkins1932 24:523--530;
kadam2016b 6:3443--3453; kempthorne1961 17:229--(2); kinghorn2011 43:4; lehermeier2017 207:1651--1661;
lian2015 55:1181--1188; longin2006b 112:903--912; longin2006c 114:393--402; longin2015 128:1297--1306; lorenz2013
3:481--491; lorenzi2024 137:75; marulanda2016 129:1901--1913; massman2012 126:13--22; melchinger2023b 136:203;
mi2014 54:1413--1418; riedelsheimer2013 126:2835--2848; smith1986 26:540--543; stuber1966 54:1279--1286;
technow2012 125:1181--1194; technow2019 9:1557--1569; weeks1964 6:319--324. Cosmetic: hallauer2010 author order in
Crossref is Carena, Hallauer, Miranda Filho; the bib order (Hallauer, Carena, Miranda Filho) is the correct cover order.

## Verified without finding (selected; evidence level)

FULL TEXT (quote/number seen in the paper)
- @thomsen2026 (PMC13469503): 4,000 hybrids, 61 METs "alpha lattice design without replications", "1.67% of all possible combinations",
  50 % omission, GCA + SCA, P2: accuracies 0.63, 0.84, 0.80 (YSD, OIL, PRM). Chapter l.446-505 correct.
- @technow2014 (PMC4125404 via WebFetch): Table 2, N_H = 300, GY, BayesB T2 0.91, T1 0.85, T0 0.77 (GBLUP T0 0.78).
- @gonzalezdieguez2021 (PMC): Table 5, GCA models T2 0.92, T1 0.88, T0 0.80 (Hohenheim data of Technow 2014). (The paper's own
  sentence lists the three values in reverse order; the table is the authority.) Crosscheck "T0 penalty 0.1 to 0.15" consistent (0.14, 0.12).
- @kadam2016b: "ranged from 0.28 to 0.77 for grain yield"; T1F > T1M explicit; T2 > T1 > T0 consistent.
- @gonzalezdieguez2026: "using 3-5 testers, sparsely distributed among full-sibs".
- @gorjanc2018: "With four cycles per year optimal cross selection had 15-78% higher genetic gain ... than truncation selection".
- @allier2019: UCPC-based OCS "more efficient to convert the genetic diversity into short- and long-term genetic gains".
- @lehermeier2017 (abstract; OUP page): "When 1% of progenies per cross were selected ... increased by 0.14 genetic standard deviation".
- @rincent2012 (PMC): CDmean higher reliabilities than random samples and PEVmean; inbred panels (hybrids only phenotyped as testcrosses).
- @atanda2021: genetic correlation 0.37 between managements WW and WS (CV1).
- @lorenz2013: "n = 500: r = 1 ... only 4% more accurate than n = 125: r = 4" (RR-BLUP, C = 0); r 1 -> 2 raises r_A by 0.09 (h2plot = 0.20).
- @lorenzi2024: %SCA by trait and cycle ranges 0 to 30 (G0S up to 30 for MFU, G1 0 to 10); chapter l.409/844 fine, trait-dependent.
- @giraud2017: "small percentage of hybrid variance due to SCA ... (~20% for the different traits)"; l.409 "20 to 30 %" needs the lorenzi2024 upper end.
- @melchinger2023: the 0.50--0.65 / 0.70--0.85 numbers themselves (see 04e-B2 for the misreading).
ABSTRACT (only; no equation/table/quote relied on)
- @lorenzi2022 (363-hybrid factorial, 951-hybrid validation, factorial as efficient as tester designs), @seye2020 (factorial = tester
  when additive, better with SCA), @fritscheneto2018 (testcross worst, NC II best for full diallel), @guo2019 (2%-13% training sets;
  clustering/network/mating-scheme designs beat random sampling, PEVmean, CDmean), @burdo2021 (48 %, 11 %, 56 % coincidence of top-25 lines;
  paper says "Iodent"), @bernardo1994 (54 single crosses = 6 SSS x 9 non-SSS, n = 10 to 30 random predictors), @bernardo1996 (>100 crosses: r 0.426--0.762 yield),
  @lian2015 ("-28 to -60%" bias, genomewide selection model), @smith1986 (masking by favourable dominant alleles in a good tester, lower variance among
  testcrosses), @riedelsheimer2013, @longin2006b/c, @marulanda2016, @longin2015, @mi2014, @endelman2014, @jarquin2020, @atanda2022,
  @montesinoslopez2023 (existence and topic only, as the chapter uses them), @griffing1956 (fixed vs random sampling assumptions), @kempthorne1961
  (partial diallel, each line crossed with s others; abstract-level), @fernando1983 (finding all connected subsets in a two-way classification;
  abstract-level), @weeks1964 (title: connectedness in an N-way cross classification; metadata only).
METADATA ONLY (title/year/journal/DOI resolve; content not read)
- @sprague1942 (definition of GCA/SCA; widely known), @hull1945, @jenkins1932, @weeks1964, @technow2012, @comstock1948, @comstock1949, @hallauer2010, @stuber1966.

## Whole-chapter summary line
Citations checked: 51 keys; metadata checked against Crossref for 51/51 (one typo, 04e-B1). Attribution: FULL TEXT 14 keys
(thomsen2026, melchinger2023, chaingeni2025, fritscheneto2021, technow2014, gonzalezdieguez2021, kadam2016b, gonzalezdieguez2026,
gorjanc2018, allier2019, kinghorn2011, rincent2012, lorenz2013, atanda2021 -- plus technow2019, lorenzi2024, giraud2017, lehermeier2017
partly); ABSTRACT 22 keys; UNVERIFIED 8 (hallauer2010, stuber1966, comstock1948, comstock1949 [pending], jenkins1932, weeks1964 and
sprague1942/hull1945 at content level, massman2012). Findings: 5 WRONG (B1-B5), 1 flag on pending Comstock 1949 (B6), 4 UNVERIFIED (B7-B10), 2 minor (B11-B12).
