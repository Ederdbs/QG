# 04e-mating-design -- verdict, iteration 1

Chapter: `book/04e-mating-design.qmd` (1162 lines). Read against it1-audit.md (R), it1-refs.md (B), it1-continuity.md (C) and THREAD.md.
The numbers marked "recomputed" were rerun here from `book/data/mating_scenarios_summary.csv` and the package at the worktree
(`pkgload::load_all("..")`); the rest rests on the audit and is listed under NOT VERIFIED. Comstock 1949: PENDING, existence and title only;
any attribution of content is a finding (rule applied in 04e-D5).

VERDICT: REJECTED

## DISQUALIFYING FAILURES

- **04e-D1 [criteria 1, 3, 6] 04e:216-218, 223-225, 239-242, 942-943 (= R1) -- the "conservative" claim for the least-squares closed form is false against the chapter's own cached rows, and the table rows are stated outside their validity.**
  Recomputed (`gca_accuracy_theory(c, r_realised, (A+B)/2, S, s2e)` at 2,000 plots, cached accuracy over all candidates):
  tester k=2 formula 0.660 / BLUP 0.657 / LS 0.653; circulant c=2 (r=3) 0.688 / 0.633 / 0.134; c=3 0.758 / 0.727 / 0.255; c=5 (r=2) 0.783 / 0.759 / 0.541;
  random sparse c=5 0.783 / 0.740 / 0.689; circulant c=10 0.792 / 0.784 / 0.707; NC II 0.792 / 0.768 / 0.737.
  The formula lies above BLUP in every sparse design (by 0.008 to 0.055) and 0.55 above LS at circulant c=2. It is exact only for a fixed tester set (partner GCA is a constant), which is what V4 validates; in a sparse factorial the partners are themselves unknown candidates and the formula ignores that noise.
  Consequences: (a) rows 3-4 of @tbl-mating-quantities are written for "c crosses per line" with no tester restriction, and V4's validation is presented as validating them; (b) 04e:223-225 ("a shrinkage estimator ... exceeds them") is true of LS in the same design, not of the formula; (c) 04e:242 and 04e:943 ("conservative for sparse designs") are the opposite of the data, so the optimiser's ordering of c in @tbl-mating-frontier, which the decision step 3 ("c = 3 to 5 is where the optimiser sits") cites, is not established. The chapter's own LS/BLUP rows contradict a statement the chapter makes twice.

- **04e-D2 [criteria 1, 3, 4, 5] 04e:439-441, 626, 855, 860 (= R2) -- SCA:GCA inflation figures are typed, carry no dispersion, and the statistic is not the ratio of the estimated components.**
  Recomputed from the file: `100*(vc_ratio_obs/0.3779 - 1)` reproduces the typed values (tester k=2 +14.8, k=4 +12.8, circulant c=3 +0.4, c=2 +34.4), but `vc_ratio_obs` is a mean of per-replicate ratios. The ratio of mean components (`vc_sca / mean(vc_gcaA, vc_gcaB)` against the same 0.3779) gives tester k=2 **+0.8 %**, k=4 **+5.2 %**, circulant c=3 **-3.1 %**, c=2 +23.9 %; circulant c=5 +15.6 (mean of ratios) / +12.1 (ratio of means), A-optimal c=3 +14.4 / +8.3. Circulant c=5 is as inflated as the testers, so the tester-versus-circulant contrast (+14.8 / +12.8 against +0.3) is an artefact of the statistic (Jensen bias of a ratio), and "a tester design estimates SCA with the testers" (04e:441-443), "Confirms and quantifies" (04e:860, +15 %, +13 %) and the "+34 %" in the table do not survive the change of statistic. No replicate sd of the ratio is reported, and the three figures at 439-441 are typed, not computed. Interpretation (confounding with the testers) is presented as the explanation of a number that the data do not show.

- **04e-D3 [criterion 7] 04e:516-519, 855 (= B2, B3) -- Melchinger et al. 2023 is reported with the direction of effect reversed and a recommendation the paper does not make.**
  refcheck (full text, PMC10397156): for H0 hybrids r_a was maximal at c = 1, exceeding c = 2 and c = 4 by ~1-3 % and ~5-10 %; c = 1 gave the lowest r_a for H1, H2 hybrids and I1 GCA; the paper's recommendation is that the optimum c depends on programme size. The chapter says that raising c from 1 to 4 "helped most exactly there" (the opposite) and builds a row of @tbl-mating-crosscheck on "Spend on parents, c = 2 to 4 [@melchinger2023]", whose verdict ("Refines: c = 2 to rank, c >= 3 to estimate variances") is therefore measured against a claim the source does not make. Not independently re-read here; consumed from refcheck under criterion 7.

- **04e-D4 [criterion 7] 04e:424-430, 827, 838 (= B4, B5, B7) -- three numbers or claims attributed beyond what the source says.**
  (a) Chaingeni 2025: 43.1 % and 28.5 % belong to the bundle DH + 2-2-1 + higher selection intensity; the 2-2-1 plan alone gave +8.2 % gain per dollar and -7.4 % cost per unit of gain; the paper does not call tester number "among the highest-leverage parameters", and the model is a deterministic budget model, not a simulation. (b) Fritsche-Neto 2021: 85-95 % is ear height; grain yield is 75-85 %. The chapter prints 85 to 95 % for an unnamed trait in a sentence about single crosses. (c) Kinghorn 2011 is cited for making optimisation of a crossing list over a 200 x 200 space "computationally routine"; the source supports the permission-matrix mate-selection algorithm in a livestock scenario, the rest is the chapter's inference carrying the citation. All from refcheck full text; not re-read here.

- **04e-D5 [criterion 7, rule of this iteration] 04e:156-158 (= B6, C11) -- content attributed to Comstock et al. (1949).**
  "@comstock1949 built reciprocal recurrent selection on them [the North Carolina layouts] -- the direct ancestor of the two-pool programme." Existence and title are confirmed; the paper is unread. The clause attributes content (that the paper built RRS on the NC layouts of @comstock1948, and the ancestry). Under the stated rule this is a finding, not a pending item. The same clause also depends on the unverified attribution of the NC layouts to @comstock1948 (see NOT VERIFIED).

- **04e-D6 [criteria 5, 7] 04e:35-39 (= C3, carries 03-C10) -- the opening misdescribes earlier chapters.**
  "Every chapter before this one took the hybrids as given ... @sec-simulating-crosses derived populations from crosses already chosen ... None of them asks where that list came from." Per continuity (read, not re-read here): 03 forms every A x B cross once and derives no population (@sec-sizing does); and 00:97-132, 04c:1091-1139 ("How many testers, how many locations"), 05b Step 6 (1745-1760, 1789-1799), 03:176-178 and 09:190-199 each ask the question and defer to this chapter. The statement is false as written and has stood unchanged since 03-C10 was recorded. Open H finding of the continuity report: rejects.

- **04e-D7 [criteria 2, 5] 04e:829-840, 1150-1153 (= C1) -- the promise of chapter 09 is not kept, and "cross" is used for three objects.**
  09:190-199 assigns to the mating-design part the problem of attributing contributions to crosses under a field limit, and cites Gorjanc 2018 "for the name only". 04e treats it in one literature paragraph with no model, and asserts that @sec-ocs applied to crosses "becomes" Gorjanc's method. The word "cross" denotes (i) a hybrid A x B in 09/10/10b, (ii) a within-pool cross made to produce the next generation of lines (Lehermeier, Lian, Gorjanc, Allier, as cited at 829-840), (iii) an A x B cross made to be tested (the design sections); never separated. An assumption used and not declared (and an owed item from an approved chapter that is not discharged). Open H finding of the continuity report: rejects.

- **04e-D8 [criterion 5] 04e:1153-1155 (= C2) -- forward promise to @sec-cycles is not kept.**
  "@sec-cycles is where the consequence of holding a design fixed while the pools drift is played out over many cycles." Continuity: 11b has no crossing design (it evaluates every A x B hybrid), no grep hit for tester / factorial / mating design / crossing plan, and cites 04e zero times. The chapter claims a result that another chapter does not contain. Open H finding of the continuity report: rejects.

- **04e-D9 [criterion 3] 04e:783-789, 858, 63-64, 1107-1110 (= R4) -- the genomic result (headline result 3) is one run, partly confounded, and one cell is under the chapter's own rule.**
  Recomputed (GBLUP minus BLUP, all-lines GCA accuracy): at 2,000 plots 2 of 24 designs gain (50 lines/pool c=10 cdmean +0.0117, z 4.25; c=5 cdmean +0.0174, z 4.52); the same two at 3,000 plots with **identical** values (0.0117 / 0.0174, z 4.25 / 4.52 -- the cells are the same data because the reduced designs are capped at reps = 3); at 1,000 plots c=5 again identical (+0.0174, z 4.52) and c=10 +0.0084, **z = 2.46**, below the chapter's own three-s.e. rule (1107-1110, "every comparison quoted above clears three standard errors ... unless it says otherwise"; this one does not say otherwise, and 04e:787-789 / 858 count it as a gain). "Gained at 1,000 and 3,000 plots" is therefore not replication of the 2,000-plot result: budgets inside one cached run are not replicates, and two of the three are the same numbers. Further, the two winning designs are the only ones with 750-1,500 plots versus 2,000 for the 200-line designs, so "genomics gained where the field holds a fraction of the candidates" is confounded with fewer plots per pool and with the CDmean line choice (the random-subset arms with the same line count do not gain, but they are not paired with the CDmean arms in the text). The unit of replication is one cached founder set; result 3 is generalised from two designs.

- **04e-D10 [criteria 1, 2] 04e:178-185, 203-207 (= R11) -- the identity is stated for pool frequencies and holds for candidate-set frequencies.**
  The text defines delta u_ik = u_ik - p_Ak, "p_Ak, p_Bk the pool frequencies". Recomputed (seed 7 chunk, 30 + 25 lines, 300 loci): with `colMeans(U)`, `colMeans(V)` (as `heterosis_gca_sca()` does, R/13_dominance.R:181-182) the max abs difference is 2.04e-14; with the pool frequencies pA, pB that generated the lines it is **0.949** (cor 0.987). The 2e-14 certifies the identity for the frequencies of the lines in the factorial, which is not the quantity written in the equation, and "the row and column effects a breeder would estimate" (203-207) is exact only there. The population-GCA formula (expectation) is a different object. The assumption (frequencies of the lines in the factorial, not of the pool) is used and not declared. Also unasserted: the chunk prints, it does not `stopifnot()`.

- **04e-D11 [criteria 1, 5] 04e:225-229, 742-750, 808-811, 857 (= R12) -- the T0 comparison sets a level against a difference, and "an order of magnitude" is 5 to 8.**
  Recomputed: genomic T0 for the eight designs with <= 100 lines at 2,000 plots is 0.099 to 0.146; T2 0.705 to 0.807; T2/T0 = 5.19 to 7.51, so 808 "an order of magnitude below" is overstated. Row 857 sets the published "T0 penalty 0.1 to 0.15 below T2" (a difference, 0.14 and 0.12 in Technow and Gonzalez-Dieguez) against "genomic T0 accuracy 0.10 to 0.15 in absolute terms" (a simulated level); the simulated T2 - T0 gap in the same rows is about 0.6 (audit R12, consistent with the ranges above), against 0.12-0.14 published. The "tension" verdict stands but the numbers presented are the wrong way round, and T0 (hybrid-level, figure axis) sits beside GCA accuracies in @tbl-mating-gblup without a note. A metric is renamed between the figure, the table and the crosscheck row.

- **04e-D12 [criterion 5] 04e:856 vs 04e:579-580 (= R3) -- typed 0.82 against the table's 0.815.**
  Recomputed `fewest` at target 0.80: relationship-guided c=5, 3,000 plots, 999 hybrids, accuracy 0.8148 (rounds to 0.81); the prose at 579-580 prints 0.815 from the table, and the crosscheck row (856) types "2.5 % gives 0.82". Same chapter, two numbers. The other typed values (1 % gives 0.61: 0.6084; 1.5 % gives 0.72: 0.7221) match. Further, targets 0.65, 0.70 (relationship-guided c=3) and 0.75, 0.80 (relationship-guided c=5) are won by marker-using designs, while 04e:550-554 excludes that family from @tbl-mating-h2h "so that the comparison is between designs that need no markers"; @tbl-mating-fewest has no such restriction and its caption does not say so. That is an unannounced change of the candidate set between two tables of one section.

- **04e-D13 [criteria 3, 6] 04e:1097-1103 (= R5) -- the in-repo versus cached comparison has no tolerance and omits its one resolved gap.**
  Audit (not rerun here): in-repo against cached at 2,000 plots, BLUP rows within |z| < 2.6; LS rows agree except circulant c=10 (0.615 vs 0.707, z = -5.2) and NC II LS (z +3.8). At c=10 with r=1 the cross weights are constant, so LS does not depend on the variance components: the chapter's stated reasons ("REML components", coalescent, finite QTL) cannot explain it and are untested. "Agree on every qualitative claim" holds; "not expected to agree to the third decimal" understates a 0.09 gap and names no exception. A known disagreement of the two reproductions is omitted (criterion 6), and the comparison carries neither a z nor a tolerance (criterion 3). The statement that the external run had linkage, finite QTL and 100 generations of divergence (809-810, 1100-1101, 1111) rests on no repo evidence; founder engine and MaCS non-reproducibility (CLAUDE.md) are not recorded next to "not reproducible".

- **04e-D14 [criterion 3] 04e:530-549, 594-618, 1107-1110 (= R7) -- unit of replication undefined, comparisons unpaired, rule stated as a width.**
  "30 replicates" is never defined (new founders, or new phenotypes on one founder set); @tbl-mating-h2h, -matched-c and -gblup compute z with `se_a^2 + se_b^2` (unpaired) though arms evidently share the replicate's truth; if they do, the z is conservative, and the text does not say. @tbl-mating-h2h takes the maximum over 4 tester and 8 sparse cells per budget (best-of-many; the number compared is not declared; harmless for z of 17-22 but not stated). Recomputed: matched-c margins at c=10 are 0.7838 - 0.7726 = 0.0113 with s.e.'s 0.00267 and 0.00237, z = 3.17, a single cached run and one s.e. above the rule. 04e:614-617 ("its advantage is pure connectivity") is not tested at c=2 (the gap is largest at c=3, for which no component count is shown, and degree regularity also differs, exactly c against Binomial). The rule "differences below about 0.018 are inside the noise" (3 x sqrt(2) x median s.e.) is contradicted by the chapter's own resolved differences 0.011 and 0.012, because cell s.e.'s range 0.002 to 0.007.

- **04e-D15 [criteria 1, 3, 5] 04e:919-922, 960-961 (= R8) -- cost narrative contradicts the package's cost model and states a conditional result as unconditional.**
  (a) "seed per cross caps replication, so a plan at one ear per cross has no seed for a second plot": `cross_cost_par()` has 250 seeds per ear and 60 per plot, i.e. 4.2 plots per ear, and the two-ear minimum gives 8 (the chapter says so at 909-910 for two plots); no seed column is printed, so the claim is neither computed nor true at the placeholder levels. (b) "no tester configuration is optimal anywhere in the grid" follows from the optimiser scoring rho with the LS closed form (the same rho at tester k and sparse c = k, see D1) and from a reciprocal tester plan needing about 2x the crosses of a circulant of equal c at placeholder prices; the chapter says at 913-917 that the cost model cannot credit bulk tester seed. The result is conditional on both and is stated unconditionally. (c) "within 10 %" (9.7 %) includes about 30,000 of common cost (fixed + genotyping of 400 lines), per audit.

## NON-DISQUALIFYING OBSERVATIONS

(Fifteen or more accumulate; alone they would reject.)

- **04e-M1 (R6, C17) 04e:82-83, 30-34, 1074-1076** -- "its tables are in `book/data/mating_*.csv`" captures `mating_core_sweep.csv` (in-repo, audit reproduced it byte-identically) and `mating_core_findings.csv` (literature extraction, read by no chapter); name the three external files. The typed 8.185 / 7.158 / 2.899 are in the file (V2 rows). Validation figures: "in-house REML against `sommer` to 1e-5" while observed errors reach 1.4e-5; "expressions to 1.5 %" is the observed maximum, the file's tolerances are 6-10 %. @tbl-mating-v4's caption ("30-replicate mean, testers resampled") is not in the file; V4's `expected` uses pool-A variance, not the (A+B)/2 of the live curve (0.391 vs 0.380 at k=1, r=1).
- **04e-M2 (R9) 04e:400-405** -- "returns diminish fast": 1 to 2 testers +0.122, 4 to 8 +0.123; equal gains per doubling, presented as a contrast.
- **04e-M3 (R10, C13) 04e:187-201, 298-311** -- identities printed, not asserted (2e-14; residuals 3.8e-16 and 0.2236 = 1/sqrt(20)); the audit's 20-seed rerun of fig-mating-testers gives max |z| 2.54, consistent with no bias at 12 replicates, but the power is about +-0.02, so "sit on the closed form" overstates.
- **04e-M4 (R13) 04e:844, 755-756, 518-519** -- Lorenzi 2024 "move between 0 and 30 % from one selection cycle to the next" is a range across traits and cycles in the file; "for well-connected hybrids" where the source says T3 (not defined in the chapter); Technow 2019's two training sets differ in type (F1 vs F1:2), under constant residual variation only (B11).
- **04e-M5 (R14, C8) 04e:176** -- "dominance deviation d_k" still stands; the book's term is dominance effect (05b, 90).
- **04e-M6 (C4, C5) 04e:35-39, 1150-1151** -- no link from 10b's close to this chapter's question; the hand-off "take the hybrids a crossing plan produced" conflicts with the complete-factorial candidate set of 03/09/10/10b (a sparse plan fields 1 to 7.5 %; the chapter never says what values the optimiser receives for the rest). Assumption across chapters ("known values for the whole factorial").
- **04e-M7 (C6) 04e:162-170** -- restates @eq-hp-gca-sca (00:106-121) instead of citing it; mu and ybar_ij undefined in 90.
- **04e-M8 (C7) 04e:164-190** -- g^A_i here is the whole GCA, in 05b (962-983) the dominance part; one row in 90 for two meanings; the chapter should state the distinction from its side.
- **04e-M9 (C9, C10) passim** -- sigma^2_s / sigma^2_SCA, sigma^2_g / sigma_GCA / vc$A; sigma^2_g is "within the pool" but the live code uses (A+B)/2. "SCA:GCA ratio" (sigma^2_s / mean GCA variance, 0.378; share 0.159 in the running example) versus 05b's frac_SCA (heterosis-only, neutral divergence): 04e:1143-1148 lets 05b's result stand for 04e's quantity.
- **04e-M10 (C12) 04e:1135-1141** -- the diversity claim of the closing section ("the loss of gene diversity ... starts in the nursery plan") is interpretation with no GD, theta or alleles-retained computed for any design, and the stage is not named (line selection, S3, is already measured in 08); presented in the text as fact.
- **04e-M11 (C14, C15, C16) 04e:170-172, 216-218, 1148-1150** -- n_A, n_B disclaimed in 03:423 but equal to the female/male lines here; c versus k in @tbl-mating-quantities (c = k for a tester not stated; c also the contribution vector elsewhere); "this chapter's estimates are those of @sec-mating-estimation" names the section that defines the model, not the cached study that produced the genomic numbers.
- **04e-M12 (B1, B12) references.bib** -- `fritscheneto2018` author misspelt ("Fristche-Neto", repaired by the published Correction); volume/pages missing in about 30 entries (Crossref values in it1-refs.md).
- **04e-M13 (R15) housekeeping** -- `book/_freeze/04e-mating-design` and `docs/04e-mating-design.html` are stale against the two part-review edits (730-733, 1148-1150); re-execution about 45 s.
- **04e-M14 (B9, B10) citations at level "unverified"** -- Hallauer et al. 2010 (page-level references absent for the tester-choice and "testcross heritability" statements), Stuber 1966 (structure of GCA), Jenkins 1932 ("the topcross method goes back to"), Comstock & Robinson 1948 as the source of the NC layouts (and of Design II specifically). Non-decisive individually; see NOT VERIFIED.
- **04e-M15 (B8, B11) 04e:730, 755** -- Massman 2012 is cited for pool-specific additive plus dominance kernels (its abstract describes relatedness BLUP versus RR-BLUP on 479 single crosses); the Technow 2019 wording as above.

## WHAT WAS VERIFIED

- Closed form against cached BLUP and LS (D1) -- `chk2.R` in scratchpad, `pkgload::load_all("..")` at the worktree, `s2e = (A+B+S)*0.7/0.3`, `gca_accuracy_theory(c, r, (A+B)/2, S, s2e)`: tester k=2 0.660 vs BLUP 0.657, circulant c=2 0.688 vs 0.633 (formula above by 0.055), c=3 0.758 vs 0.727, c=5 0.783 vs 0.759, random c=5 0.783 vs 0.740, circulant c=10 0.792 vs 0.784, NC II 0.792 vs 0.768; LS 0.134 at c=2.
- SCA:GCA inflation (D2) -- same script: mean-of-ratios +14.8 / +12.8 / +0.4 / +34.4 (k=2, k=4, c=3, c=2) reproduces the typed values; ratio-of-means +0.8 / +5.2 / -3.1 / +23.9; circulant c=5 +15.6 / +12.1.
- GCA identity (D10) -- seed 7 chunk: candidate-set frequencies 2.04e-14; pool frequencies 0.949 max abs difference (cor 0.987).
- `fewest` table (D12) -- 0.60: circulant c=2, 1,000 plots, 400 hybrids, 0.6084; 0.65 and 0.70: relationship-guided c=3, 600 hybrids, 0.7221; 0.75: relationship-guided c=5, 999 hybrids, 0.7638; 0.80: relationship-guided c=5, 3,000 plots, 999 hybrids, 0.8148.
- Genomic gains (D9) -- GBLUP minus BLUP, positive differences only: 1,000 plots c=10 cdmean +0.0084 (z 2.46), c=5 cdmean +0.0174 (z 4.52); 2,000 and 3,000 plots c=10 +0.0117 (z 4.25) and c=5 +0.0174 (z 4.52), identical across the two budgets.
- T0 (D11) -- eight designs <= 100 lines, 2,000 plots, GBLUP: T0 0.099 to 0.146, T2 / T0 = 5.19 to 7.51; BLUP all-lines accuracy range for 200-line designs 0.545 to 0.784.
- Matched-c (D14) -- circulant c=10 0.7838 (s.e. 0.00267) vs random 0.7726 (0.00237), z 3.17; c=2 0.6326 vs 0.6018.
- Source labelling in the chapter (read): cached files and figures are labelled as not reproducible in the callout (78-85) and in the cached paragraph (1072-1079); no chunk presents an external file as reproducible.

## NOT VERIFIED

- Byte-identity of `mating_core_sweep.csv` with `regenerate.R mating` -- relied on the audit (7.2 min rerun, md5 e31f767a...); not rerun here.
- Rank rule, estimability residuals (3.8e-16 and 0.2236), the `rk()` ranks, the h2h differences 0.125 / 0.107 / 0.082 and z 17-22, cost-table pollinations (3,000 vs 6,000, 4,752) -- relied on the audit; not recomputed.
- In-repo versus cached z-scores (D13) -- audit numbers (|z| < 2.6 BLUP; LS c=10 z -5.2, NC II z +3.8); not recomputed here.
- All attributions under D3, D4 (a)-(c) and the B-level items B8-B11 -- consumed from `it1-refs.md` (full text or abstract as stated there); not re-read. D3 and D4 reject on refcheck's full-text reading; B9, B10 (Hallauer 2010, Stuber 1966, Jenkins 1932, Comstock & Robinson 1948 as the origin of the NC layouts) stay UNVERIFIED and, because 04e:156 and 492 rest the definition of the NC designs on the last, that item would block approval of a text that was otherwise clean. Comstock 1949 content: unread (D5).
- Continuity claims C1-C3 (09, 11b, 03, 00, 04c, 05b contents) -- taken from `it1-continuity.md`; the 11b absence of a crossing design was not re-grepped here.
- The external study's linkage / finite-QTL / 100-generation divergence / 1,000 markers (04e:809-810, 1100-1101, 1111) -- no repo evidence; verifiable only from the `sparsex` repository.
- Whether the 30 replicates share a founder draw across arms (D14) -- not in the repo; verifiable from `sparsex`.

## OPEN FINDINGS FROM THE AUDIT, REFS AND CONTINUITY REPORTS (iteration 1; none was closed by an author response)

| Report ID | Severity (reporter) | Verdict here | Mapped to |
|---|---|---|---|
| R1 | H | open, disqualifying | D1 |
| R2 | H | open, disqualifying | D2 |
| R3 | M | open, disqualifying (criterion 5, same chapter) | D12 |
| R4 | M | open, disqualifying | D9 |
| R5 | M | open, disqualifying | D13 |
| R6 | M | open, non-disqualifying | M1 (provenance wildcard); D13 for the external-run claims |
| R7 | M | open, disqualifying | D14 |
| R8 | M | open, disqualifying | D15 |
| R9 | L | open | M2 |
| R10 | L | open | M3 |
| R11 | M | open, disqualifying | D10 |
| R12 | M | open, disqualifying | D11 |
| R13 | L | open | M4 (and D4 for the attributions that matter) |
| R14 | L | open (dominance deviation, 09's c_i, sigma symbols, Comstock, 03-C10); the 08b kernels item is settled | M5, M9, D5, D6, D7 |
| R15 | L | open | M13 |
| B1 | minor | open | M12 |
| B2, B3 | WRONG | open, disqualifying | D3 |
| B4, B5 | WRONG | open, disqualifying | D4 |
| B6 | FLAG (pending) | open, disqualifying under this iteration's rule | D5 |
| B7 | UNVERIFIED / overreach | open, disqualifying with D4(c) | D4 |
| B8, B9, B10, B11, B12 | UNVERIFIED / minor | open, non-disqualifying; B10 listed under NOT VERIFIED | M14, M15, M12 |
| C1, C2, C3 | H | open, disqualifying (open H finding) | D7, D8, D6 |
| C4, C5 | M | open | M6 |
| C6 | M | open | M7 |
| C7 | M | open | M8 |
| C8 | M | open | M5 |
| C9, C10 | M | open | M9 |
| C11 | M | open, disqualifying under this iteration's rule | D5 |
| C12 | M | open | M10 |
| C13 | M | open | M3 |
| C14, C15, C16 | M / L | open | M11 |
| C17 | L | open | M1 |
