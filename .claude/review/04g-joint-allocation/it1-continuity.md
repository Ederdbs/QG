# 04g-joint-allocation -- continuity, iteration 1 (chapter mode, read-only)

Chapter: `book/04g-joint-allocation.qmd` against 00, 02, 03, 05, 05b, 06, 08, 08b, 90 and the part's own 04e and 04f. Read: `CLAUDE.md`, `_quarto.yml`, `90-notation.qmd`, THREAD entries 00-10b, `04e-mating-design/it3-verdict.md` and `it2-response.md`, `04f-sparse-testing/it3-verdict.md` and `it2-response.md`, `04g-joint-allocation/it1-audit.md` (context only; its R-findings are cited, not re-judged), then the chapter in full.
No THREAD entry exists for 04e or 04f. 04f and `90-notation.qmd` have UNCOMMITTED edits in the worktree that changed while I read; the 04f line numbers below are those of the working tree at the end of the read (04f:879, 1277, 1819, 1958, 2088). 04e is OPEN after 3 iterations (D19/D20 concern cached figures; nothing in 04g quotes a cached 04e number).
Severity: H = contradiction (notation, definition, number, assumption) or broken promise; M; L. Owner: THIS = 04g; EARLIER = an earlier chapter, fix now; LATER = Owed to a later chapter or appendix.

## Opening, promises, Owed items

- Opening (04g:48-63) says why it follows 04f: 04e chose crosses, 04f chose locations, one budget decides both; names 04e's second gap (04e:1487-1488 says "@sec-joint takes this gap up") and the metric 04f asked for (04f:1958). KEPT.
- Promises INTO 04g, kept: 04e:249, 885, 1488, 1603; 04f:879 (necessary screen plus counter-example, metric left open: `tbl-joint-alias`, 04g:477-478); 04f:1251 and 04f:1819 (`@sec-joint-model` measures the structured SCAxL kernel: `tbl-joint-misspec`, nothing detectable); 04f:2088; 03:178; 00:750. NOT kept: 04f:1277 (C2).
- Owed "found the first better" (04g:129-134): settled and TRUE. It matches 04f result 6 (N1 = 100, 200, 400 of 400 candidates; four replicates; Bonferroni over 8 rows leaves nothing resolved) and 04f:2082-2086, which describes the same "smaller stage-1 factorial". KEEP.
- Owed dense-factorial limitation (04g:988-1001): the paragraph is right about 04f (k = 2, one plot per cell, 80 % planted held fixed, widened 2 to 10 locations; 04f:207-212, result 2). It is contradicted two sections earlier (C1).
- Owed sigma^2 symbols: the premise "90 has no variance rows" is stale. `90-notation.qmd` at HEAD already has rows for sigma^2_f/m/s, sigma^2_G, sigma^2_GE (90:552-554), sigma^2_fl/ml/sl (90:575) and the mapping to 04e's sigma^2_gA/gB/s. Settled in 90; residue in C5, C6.
- Owed 05/THREAD:69 `n_unc` (04g:526): NOT settled (C20).
- Owed CV1/T2/T1/T0: partly settled (C11). Owed parentage = coverage: NOT settled, worse (C2). Owed result 4 as hypothesis: wording half-done (C3).

## Findings

### 04g-C1 [H] -- THIS. The chapter says 04f varied k at the whole factorial; 04f used 80 % of it
- 04g:49-50 "@sec-sparse chose which locations each hybrid goes to, with the whole factorial taken as given"; 04g:127-128 "@sec-sparse varied $k$ and the layout at fixed $n_c = n_F n_M$".
- 04f:207-212 (Scope), 04f:1233-1235 (planted share) and limitation 7 (04f:1838): 20 x 20, "80 % of the hybrids are planted at random", each line a parent of about 16 planted crosses, 400 hybrids. So n_c = 320 there, not 400, and 04f itself calls it a dense factorial where parents are shared by construction. 04g:989-992 states this correctly ("the planted 80 % of the factorial held fixed"). The chapter contradicts itself and 04f. (R/18 header, line 3-5, repeats "taking the whole factorial as given".)
- Fix in 04g: 49-50 and 127-128 (and the comment in R/18).

### 04g-C2 [H] -- THIS and EARLIER (04f). `parentage` and `coverage` are declared the same allocation; they are not
- 04g:79-80 "the `coverage` rule here, `parentage` in @sec-sparse"; 04g:1021 "the `parentage` allocation of @sec-sparse under another name"; 04f:1277 "(the rule that @sec-joint calls `coverage`)".
- R/17 `sparse_alloc("parentage")` cuts the complete factorial into nM cyclic groups and exchange-optimises location concurrence; R/18 `coverage` is a greedy parent-presence rule on any plan with no concurrence term (R/18:12-18). Audit R6 measured on the complete 20 x 20 factorial, 8 locations, k = 2: both reach female and male coverage 1 and equal loads, but the allocations differ; `frac_disconn` 0 (coverage) against 0.286 (parentage). 04f result 4 (04f:1541-1600 (result 4)) is precisely about the parentage layout sharing NO hybrid between some location pairs (04f:1565-1566), and says the cached parentage arm came from a search with a defective criterion (04f:1588-1589, limitation 8 at 04f:1845). "Plays the same role" is defensible; "under another name" and "the rule that ... calls coverage" are not.
- 04g also needs `coverage` to work on sparse plans, where "every location receives both whole pools" (04f:1277) is impossible (the tester plan's coverage ceiling is 0.55, 04g:1041-1044).
- Fix: 04g:1021 (and 79-80 if read as identity) and 04f:1277 (one clause: "the closest analogue, not the same rule").

### 04g-C3 [M] -- THIS. "turned into an allocation rule and tested here" overstates against 04f result 4
- 04g:1298-1300 vs 04f:1541-1600 (result 4) and 04f result 4 headline: 04f says the data "do not decide" coverage against shared hybrids and that "no arm varies coverage with overlap fixed". 04g's contrast `coverage - random` (+0.0057, z 1.7, 04g:1025-1028) is at fixed plan, k and loads and also changes concurrence, so it cannot test the 04f hypothesis. 04g:1222 ("accuracy gain was not detected") is fine; "tested here" is not. Audit R7 agrees.

### 04g-C4 [M] -- THIS. A mechanism 04f labels a hypothesis is stated as fact in the checklist
- 04g:1215-1219 "REML has little to work with at one plot per cross". 04f's REML box (04f:1711-1735, "a hypothesis, not a measurement") gives that mechanism as untested and says what 04f measured: convergence 42.6 % at k = 1 and no data on cause. The rest of 04g:1217-1219 ("under half of the cached fits ... cause is not tested there") is right, so the clause contradicts its own parenthesis.
- Also 04g:1215 "one plot per cross" vs 04f "one location per hybrid" (same design at r = 1; say once).

### 04g-C5 [L] -- THIS. sigma^2 mapping is in 04f and 90, not pointed to from 04g
- 04g:165-178 maps the EFFECTS (g^f, g^m, s to 04f and to 04e's g^A, g^B, s) but not the VARIANCES. 04f:398-402 (the paragraph after @eq-sparse-kernels) and 90:552 give it: sigma^2_f, sigma^2_m = 04e's sigma^2_gA, sigma^2_gB; sigma^2_g = their mean; sigma^2_s = 04e's sigma^2_s (= sigma^2_SCA of 05b/04f). 04g never writes sigma^2_G or sigma^2_g (checked), so the 08b-C19 clash (sigma^2_G / sigma^2_u / sigma^2_g) does not reach 04g. One sentence at 04g:176-178 closes it. The 90 rows remain correct.

### 04g-C6 [M] -- THIS. "plot h^2" and sigma^2_e are 04f's, not 04e's, and 04g never defines them
- 04g:866-868, 893, 1080 ("two plot heritabilities", "plot $h^2$ = 0.2 / 0.4") with no formula and no pointer. 04f Box 2 and the calibration paragraph (04f:1240-1262) define plot h^2 = sigma^2_G/(sigma^2_G + sigma^2_GE + sigma^2_e) and warn that 04e folds the location interaction into the plot error (single-plant h^2 0.3) and that 08b means "in a single environment", "not on one scale". 04g:158 "The model is @sec-sparse's, unchanged" is true, but a reader coming from 04e meets sigma^2_e (04e:241) and h^2 = 0.2/0.4 with different content. 90:554 gives the formula. One clause plus pointer at 04g:866-870.

### 04g-C7 [M] -- THIS and LATER (90). n_c is reused
- 04g:115-117 and 90:569-577: n_c = distinct crosses made, B = n_c k r. 08:337, 08:341, 08:394 and 90:346, 90:353: n_c = DH lines per cross (C = number of crosses). 90:353 tries to disclose it, but says "n_c is not the field budget of the mating-design table", which is neither table's content (the mating table has no n_c; the joint table has n_c = crosses, B = budget). 04g does not mention the clash.
- Fix: 04g one clause where n_c is introduced; 90:353 reword to "not the crosses made of the joint-allocation table". Also see C9 for r, C10 for L.

### 04g-C8 [L] -- THIS. Pointer for N_SNP is wrong
- 04g:569-571 "N_SNP ... (the symbol of @sec-era-fhom, since m marks the male pool)". 05:230-236 (sec-era-fhom) writes m and says "N_SNP in @meuwissen2020 ... the book's m is used throughout". N_SNP is Meuwissen's symbol, adopted here as a second symbol for markers. 90:24 and 90:573 say so correctly. Reword 04g to cite @meuwissen2020 and 90.

### 04g-C9 [L] -- THIS. r means plots per cross per location here, plots per cross in 04e
- 04g:115-119 "r for plots per cross per location", B = n_c k r. 04e:241 r_ij = plots the cross received (total), 90:521, 90:531 "r here is plots per cross". Same letter, differ by the factor k unless k = 1. 04f Box 2 uses r reps per location, like 04g. The joint row of 90 (90:569-577) has no r row. Say it once and add the row.

### 04g-C10 [L] -- LATER (90) / EARLIER (04f). L is locations here and in 04f, parent lines in 90:344 and 08b
- 04g:115, 168-175, 793-795 and 04f Box 2 use L = locations; 90:344 (selection table) and 08b (L = 50) use L = lines, L = L_A + L_B. Disclosed for k only (04g:117-119, 90:562). Add an L note to 90's sparse/joint block.

### 04g-C11 [L] -- THIS. CV1 / T-level: still a third meaning, and `acc_unmade` is not labelled
- 04g:246-250 scopes "CV1" (never-planted hybrids; T2 if both parents are in made crosses, T1/T0 otherwise) with a pointer to 04f:563-575. Correct for 04f. But 08b:467-488 and 90:381-385 call the T2 case CV2, 04f's CV1 is a third meaning (04f's own collision note says so). 04g does not say which T-level the "Not made" column of `tbl-joint-made` (04g:977-987, circulant plans only) occupies: circulant plans cross every line, so all unmade crosses are T2; the random sparse c = 4 plans have uncrossed lines (34.8 %, 04g:526-529) and so also T1/T0. State it once, and use T-labels, not CV1, in this chapter.

### 04g-C12 [L] -- THIS. "resolved" has three meanings in the part
- 04e:752, 957, 1576: resolved = unpaired z > 3. 04f:1285, 1423, 1467: resolved = survives Bonferroni; "beyond two standard errors" for results 2 and 6. 04g:883-885: "detected" past 2 s.e., "resolved" past 3 (04e's bar), and 04g:1061-1065 reads 04f's "not resolved after multiplicity correction" as agreeing with a z < 3 non-detection. Declare in 04g:883 that 04f's bar is a Bonferroni one and not the same threshold; no number is wrong.

### 04g-C13 [M] -- THIS. Two PEV criteria in two chapters, not cross-referenced
- 04g:439-449 (`joint_pev`: mean PEV of the n_F + n_M GCA effects) and 04g:1113-1131, checklist 04g:1212. 04f Box 4 (04f:903-975) already builds the pre-planting criterion: mean PEV of the hybrid target values, per-genotype reliability 1 - PEV/sigma^2_G, with its own rank correlation against acc_all and the warning "rank designs at fixed components, not predict the correlation" (04f:985-987). 90:540 defines PEV as "of a hybrid's target value". 04g never mentions Box 4, never says why it uses the GCA block, and never says how its rank result (rho -1.00 to -0.89 over six configurations) relates to Box 4's. The recipe is developed twice with different targets and the same name. 04g owns the GCA version (it needs the plan); it should point to Box 4 and state the difference. 04g:1306 cites @sec-genomic-prediction (08b) for the same machinery; 08b's PEV (@eq-genpred-reliability) is the G-based one and 08b says it does not fit these kernels (08b-C5), so the pointer should go to 04f Box 4 first.

### 04g-C14 [M] -- THIS. The tester-versus-sparse comparison is read against a different regime from 04e's
- 04g:950-955 (tester k = 2 below circulant c = 4 in every cell) and 04g:365-367 (literature: sparse "at least as well as tester designs"). 04e's sweep: unrelated DH lines (04e:1188), 200 x 200 pools, phenotypic BLUP without a relationship matrix, one location, 1,000 to 3,000 plots, GCA accuracy over lines (`acc_gca_all`, 04e's rho). 04g: half-sib A_f, A_m (relationship 0.25), 20 x 20, 8 locations at k = 2, 160 plots, known components, accuracy of the hybrid target g^f + g^m + s over all 400 hybrids (04f's `acc_all`; 04f:1205-1210 already warns it is not 04e's `acc_gca_all`). 04g:1195 lists "half-sib relationships" among limits but 04g:950-955 never says whether it agrees with 04e's result, nor that relatedness (which links lines across families and could help a tester plan more than a sparse one) is the difference. Also the 04g marker panel of `tbl-joint-freq` (04g:672-681: family-founder mixture, independent q ~ U(0.1, 0.9) per pool, no divergence control) is not the generator of @sec-simulating-crosses (03) and is not said to differ.
- Fix: one sentence at 04g:950 (regime differences, "consistent in direction with 04e under BLUP, not a replication"); one clause at 04g:672.

### 04g-C15 [L] -- THIS. The literature sentence on sparse factorials is unconditional
- 04g:365-367 "Sparse factorials train hybrid prediction at least as well as tester designs, and fewer crosses per line favours the lines never crossed". 04e (after it2) conditions the same claim on c, layout and estimator (avoid c <= 3 under LS; circulant c = 5 below the best LS tester; 04e it3 verdict D17 closed). Scope it ("under BLUP, in the cited studies").

### 04g-C16 [L] -- THIS. 04e names a different "closest joint treatment"
- 04g:56-61 "nearest treatments" are Heslot/Kadam (crosses) and Cullis/Montesinos-Lopez (environments); 04e:1487 calls @thomsen2026 "the closest to a joint treatment, and it is observational". 04g meets Thomsen only at 04g:371-374 (as a sparse observational study) and never connects it to 04e's gap statement.

### 04g-C17 [M] -- THIS. The diversity argument loses the label 04e gave it, and cites chapters that do not show it
- 04g:1301-1305 "distinct crosses would also keep more lines in the data, the diversity argument of @sec-mating-connects: a line never crossed is one the next cycle will in practice not use (@sec-stages; @sec-cycles)". 04e:1619-1630 titles this "A hypothesis, not a result", computes no diversity metric of a design, says "may in practice come from them", and 04e:1642-1644 says @sec-cycles has no crossing design and does not test it. 08 and 11b measure diversity loss from selection, not from lines never crossed. Restore the hypothesis wording; drop or re-scope the two citations. (04g's own `tbl-joint-freq` does compute a plan-level drift term, F_drift = 0.0x for one random sparse plan, 04g:815-823, and could cite that as the only measured piece.)

### 04g-C18 [M] -- THIS and LATER (11, 04d). The closing transition promises what 11 does not do
- 04g:1311-1314 "the Evidence and practice part ... sets these tools against what the applied literature establishes, starting with @sec-plant-literature". 11:11-19 opens from @sec-choosing (a metrics chapter), is about which diversity metrics plant practice reports, and cites none of 04e, 04f, 04g (grep: no @sec-mating, @sec-sparse, @sec-joint in 11, 11b, 11c, 12, 04d). The Evidence part uses nothing of this part. The one real echo is 04d:27 (entries at one location against fewer at eight is "the same budget spent two ways"; 04f:2095-2100 already cites 04d as an analogy), which 04g does not cite.
- Owner: 04g reword (what the part hands on: the budget-split result, the screens, the open frequency question); 11 opening has no link to the part (LATER, one sentence); 04d could cite @sec-joint-split (LATER, optional).

### 04g-C19 [L] -- EARLIER/PACKAGE. R/18 roxygen states what 04f left open and a guarantee the code breaks
- R/18:20-25: `coverage` "is what carries connectivity once a relationship matrix is in the model (Chapter 4f, finding 4)" -- 04f finding 4 is a hypothesis; and "no location may exceed ceiling(n k / nLoc)" (audit R1: violated in 22 of 600 draws). Package text, needs `devtools::document()`; it is not a chapter finding.

### 04g-C20 [L] -- THIS. Owed `n_unc` formatting still open
- 04g:526 prints `r n_unc` (2e4 with the x10 dropped; THREAD:69, audit R14). Format as a count.

### 04g-C21 [L] -- THIS. Two derivations restated where an earlier chapter owns them
- 04g:523-537 recomputes by Monte Carlo that random sparse plans leave lines uncrossed; 04e's `tbl-mating-matched-c` (04e:826-880, `lines_random`, `comp_random`) already reports it at 200 x 200 and c = 2 to 10. Cite it. 04g:767-768 and 04g:640-648 use "a plan that uses every line equally often has pbar = p0, drift term zero"; 05's `tbl-era-p0-identity` (05:848-860, balanced incomplete factorial row) asserts exactly that. Cite it. 04g:604-626 (GD_BS = D-bar, weights N_i/N_T) matches 02:39-49, 351, 433-443 exactly (checked: GD_WS = 1 - f~, GD_BS = f~ - f-bar, F_ST = D-bar / (1 - f-bar)); no inconsistency.
- 03:178 says @sec-mating and @sec-joint "choose which crosses are made"; 04g enumerates plan families and optimises only the placement (04g:1239-1241). LATER/EARLIER wording: "compare crossing plans".

### 04g-C22 [L] -- THIS. Provenance wording
- 04g:96 "Everything here is reproducible from this repository" sits next to 04g:98-104 ("about 30 minutes of CPU in one unrecorded timing", 04g:1155 "cause ... not recorded") and the literature search of 04g:263-275, which is not reproducible from the repository. 04e and 04f scoped their provenance carefully. Say "the numbers of this chapter". The audit's rerun of `regenerate.R joint` had not finished (audit section 0).

### 04g-C23 [L] -- LATER (91, 92, index). The appendices do not know the chapter's files
- 91:38-42 file map ends at `R/17_sparse_testing.R`; no `R/18_joint_allocation.R`. 92:289-291 lists `mating_core_sweep.csv`, `sparse_core_sweep.csv` but no `joint_core_sweep.csv`, `joint_contrasts.csv`, `joint_optimiser.csv`, though index:184-186 says 92 "tabulates most of these files". 92:~260 (the "runs live" row for @sec-joint) omits `tbl-joint-misspec` and `tbl-joint-alias`, which 04g runs live (04g:1273-1275).

## Settled / checked without finding

- Notation consistent with 04f and 90: GCA^f/GCA^m/SCA, g^f/g^m/s, sigma^2_f/m/s, sigma^2_{fl,ml,sl}, A_f/A_m, n_F/n_M (= n_A/n_B), B, N_P, n_l, X_P, SS_B, GD_l, GD_P, Z/w: all in 90:569-577; female = pool A (04e:249). k = locations per cross, with the 04e tester collision stated at 04g:117-119 and 90:562. `connected` in 04g:532 matches R/16 `design_diagnostics` (one component and every line used).
- 04g result 2 of 04f ("2 to 10 locations") and result 5 (REML converged in under half at k = 1, 42.6 %) are quoted as 04f states them; the exploratory k <= 2 subset and "not resolved after multiplicity correction" (04g:1062-1065) match 04f result 3.
- 04g:1150-1151 "optimised-block design ... absence of gain on untested hybrids": 04f `sparse_contrasts.csv` has optimised_blocks - random on acc_cv1 +0.0018 +- 0.0043 (all) and -0.0012 +- 0.0079 (k <= 2); true. (On acc_cv2 it is +0.006, p 0.010 uncorrected; not claimed.)
- Part progression 04e (which crosses) -> 04f (which locations) -> 04g (both): sound; 04g is the only chapter of the part that runs 04e's plan families through 04f's field model, so it closes 04f's limitation 7 only in part (it never says so).

## Inbound `@sec-` citations (self-citations discarded; grep over `book/*.qmd`)

| Label (owner) | Inbound | From |
|---|---|---|
| sec-joint (04g) | 10 | 00:750; 03:178; 04e:249, 885, 1488, 1603; 04f:1277, 2088; 90:518; 92:239 |
| sec-joint-criteria | 2 | 04f:879, 1958 |
| sec-joint-model | 2 | 04f:1251, 1819 |
| sec-joint-why, -literature, -freq, -results, -split, -strategy, -criterion, -recommendations, -open, -reproduce, -connects | 0 each | cited only inside 04g |

04g total: 14 inbound citations in 6 files (00, 03, 04e, 04f, 90, 92); none from 09 to 12 or from the Evidence and practice part. Broken `@sec-` targets in 04g: none (35 labels, all resolve; `sec-notation` -> 90, `sec-plant-literature` -> 11, `sec-cycles` -> 11b).
For context, the part's other two chapters (inbound from other files): 04e `sec-mating` 47 (04f 20, 04g 12, rest 00, 03 x2, 04c, 09, 10b, 90, ...), `-tester` 6, `-genomic` 5, `-connectivity` 5, `-sparse` 4, `-estimation` 4, `-open` 3, `-cost` 2, `-connects` 2 (both from 04g), `-reproduce` 1; 04f `sec-sparse` 27 (04g 12, 04e 4, 92 4, 00 2, 90 2, index 2, 91 1), `-results` 7, `-validation` 3, `-limits` 2, the rest 1 each, all from 04g or 92. Neither 04e nor 04f nor 04g is cited by 04d, 11, 11b, 11c or 12 (C18).

## Summary by owner

- THIS (04g): C1 H, C2 H (with 04f), C3 M, C4 M, C6 M, C7 M, C13 M, C14 M, C17 M, C18 M; L: C5, C8, C9, C11, C12, C15, C16, C20, C21, C22.
- EARLIER, fix now: 04f:1277 (C2, one clause).
- LATER (Owed): 90:353 (C7), 90 L note and joint r row (C9, C10), 91 file map and 92 table (C23), 11 opening and optional 04d cross-reference (C18), 03:178 wording (C21), R/18 roxygen (C19).
