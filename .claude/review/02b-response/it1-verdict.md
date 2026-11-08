# Verdict: book/02b-response.qmd (iteration 1)

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05, branch review-01-05. `file:line` are lines of `book/02b-response.qmd` unless a path is given. Read in full: the chapter, it1-audit.md (R), it1-refs.md (B), it1-continuity.md (C), THREAD.md (00, 01, 02 and the Owed items naming 02b); read in 11c (:1-30, :95-235) and 09 (:40-130); Meuwissen et al. 2020 (local PDF); `R/09_reference.R` (`simulate_pools`) and `R/15_response.R`.

VERDICT: REJECTED

Counts: disqualifying 7 (D1-D7); non-disqualifying 14 (M1-M14), well above the threshold of three. Severity inside the disqualifying set: D1-D4 are the ones that block on their own for continuity or attribution reasons; D5-D7 are errors of content in the chapter's own equations and tables.

## PREVIOUS IDS (re-review only)
Not applicable (iteration 1). Disposition of every audit, refs and continuity ID is in the table at the end.

## DISQUALIFYING FAILURES

- **02b-D1 [criterion 7, 4, 1] :18-22, :403-404, :436-453 (lineage and novelty).** The chapter says the classical index theory is "the direct ancestor of this book's alpha constraint" (:20-22), that Kempthorne & Nordskog "posed exactly the same problem" (:403-404), that "what is new is the restricted direction" because "this book restricts the loss of molecular gene diversity, which is not a trait" (:445-449), and that "a theorem from 1959 stands behind the move" (:451-452). Four defects.
  (a) The prior art that constrains exactly this object is not cited. Meuwissen et al. 2020 (reference/papers/Management of genetic diversity in the era of genomics.pdf, Methods, "Optimum Contribution Selection": "the rate of inbreeding is constrained by constraining the increase of the group coancestry of the selected parents, K = 1/2 c'Gc", with the genetic level c'g-hat "maximized" and G a molecular kinship, G_0.5 or VanRaden matrix) maximises gain subject to a bound on a molecular group coancestry. Meuwissen 1997 is cited in the paper's reference list for the same quadratic bound on a coancestry. The book names both papers at 00:712-713 and CLAUDE.md says theta/GD/alpha "is Meuwissen et al. (2020)'s G_0.5 scheme". The "genuinely new in this book" callout (:442-453) is therefore contradicted by a source the book itself holds and cites elsewhere; the chapter cites neither paper (both keys exist in references.bib). What could be new (budget relative to a random-subset reference, hybrids, two pools) is not what the callout claims.
  (b) "Exactly the same problem" is contradicted by the chapter itself at :436-440 (inequality on a diversity loss versus equality on a trait gain; a restriction linear in the index weights versus a quadratic form c'fc in the contributions of a discrete selection). The proof that "the algebra of restriction carries over" (:449-450) is not given: the closed form of @eq-response-restricted is a linear projection under normality and known (P, G); nothing in the chapter links it to the quadratic, discrete, budget-relative alpha problem. "A theorem from 1959 stands behind the move" is interpretation presented as established.
  (c) Kempthorne & Nordskog 1959 is decisive here and UNVERIFIED (refs B1, B2: JSTOR only, no copy read). A decisive attribution that quant-refcheck left unverified blocks approval.
  (d) :434-436, "moves the restricted trait by exactly zero -- not approximately, not on average": R' Sigma_G b = 0 is the **expected** gain being zero (known parameters, linear regression of g on the index); a realised response in a finite sample is not zero. The sentence says the opposite of what the identity states, and it is what the chapter uses to separate a "restriction" from a "penalty" and to say what alpha "inherits". The alpha constraint holds exactly on the realised set (a deterministic function of the selected set); the K&N restriction holds in expectation. The chapter conflates the two.
  Accepted from the reports and raised: R2 (M -> D1), B1 (MEDIUM -> D1), B2 (UNVERIFIED, decisive -> D1), C11 (wording; 09 owes its half), C19 (the quantity the budget constrains is GD_T, which includes the between-pool term the chapter has just shown does not feed genic variance; the restricted direction is not the direction that carries response). Not accepted as a defect of 02b: the part of C9/C11 that lies in 09:48-78.

- **02b-D2 [criterion 2, 4] :174-197 (@eq-response-ld, @tbl-response-genic): the disequilibrium term of the seed-1 draw is sampling covariance of 25 + 25 founder lines, zero in expectation, and the chapter presents it as Bulmer's.** :176-178 says the difference is "exactly the gametic-phase disequilibrium term [@bulmer1971], which @tbl-response-genic evaluates for the seed-1 draw". In `simulate_pools()` (`R/09_reference.R:30-37`) the 2000 loci are drawn independently per pool and no selection precedes the evaluation; over the complete factorial Cov(x_k, x_l) is the sum of the two within-pool sample covariances divided by 4. Recomputed by me (seeds 1-30, then 31-230): over seeds 1-30 the term has mean -0.14 and s.e. 0.83; its share of the genic variance over 200 further seeds has mean -0.009 and s.d. 0.205 (the audit, 600 seeds: mean -0.0008, s.d. 0.20). The seed-1 value (-2.72, -10.8 percent of V_genic) is a draw of either sign with expectation zero. Assumptions used and not declared: independent loci in the generator, no selection, finite founders. The reader is led to read -10.8 percent as a selection-induced loss; 11c:106-110 states that the gap "is not on its own a measure of the Bulmer effect" and uses a random-selection control for that reason. R/15_response.R:18-21 ties the negative sign to directional selection. The identity itself is exact and is not in question. Ruling: R1 and C5 accepted, raised from M to disqualifying (criterion 2 for the undeclared generator assumptions, criterion 4 for interpretation presented as a measured result). B5 (the citation does not carry the table's term) is the same finding. Owed to 11c, not a 02b defect: 11c:114-115 "two divergent pools add more" is false for a complete factorial (R1 note).

- **02b-D3 [criterion 5, 6; continuity C1, open H] :252-254, :461-463 (promise to @sec-limits).** :461-463: "@sec-limits is where the disequilibrium term this chapter isolated turns out to matter more than @eq-response-breeders suggests"; :254: "@sec-limits measures how far apart the two can travel". I read 11c:95-235. It does not compare a gene-diversity trajectory with an additive-variance trajectory (it measures the selected-minus-random difference of Var - V_genic, 11c:128-150, and the AlphaSimR linked arm); it finds the term significant against the control but "largely self-correcting", with recombination repaying it, and concludes that "the justification for constraining the second [frequency cost] and ignoring the first" holds because the frequency cost is the permanent one (11c:207-226). "Matters more than the breeder's equation suggests" is a ranking 11c does not make and its closing section argues the other way round. Ruling on C1: accepted as H. 02b must be made true of 11c as it stands: the promise cannot stay as worded, and it cannot be fixed by editing 11c in this pass. Either withdraw the forward claim or restate it as what 11c measures (a selection-induced term, significant against a random-selection control, decaying, not a trajectory comparison of gene diversity against variance). C6 is accepted as part of this finding: the callout attributes the whole error of reading a flat gene-diversity trajectory as flat additive variance to the disequilibrium term (:252-253), against the chapter's own result at :229-236 that a flat GD_T can hide a falling within-pool term, which is the only part V_genic contains.

- **02b-D4 [criterion 5; continuity C2, open H] :436-440 (promise to @sec-ocs).** "@sec-ocs works out what changes when the equality restriction becomes an inequality." I read 09:40-130 and its heading list (via C2): 09 has no such passage. The only relevant text is "bounded relative to a resampling baseline rather than held at zero" (09:72-74) and the calibration section. Ruling on C2: accepted as H; since 09 is a later chapter and not edited in this pass, 02b must withdraw the promise or reword it into a claim true of 09 today. What the inequality changes is a content question the chapter leaves open and 09 does not answer; the sentence at :434-436 that alpha "inherits the restriction, not the zero" stands in the chapter without that treatment (see D1(d)). Related, owed to 09 (not 02b): 09:50 "@sec-response derives their solution" (02b states the formula and asserts R'Gb = 0; it does not derive it, C11).

- **02b-D5 [criterion 1] :419, :428-429 (@tbl-response-restricted).** The column "expected gain in moisture (trait units)" and the caption's "expected gain in the restricted trait, R' Sigma_G b, in trait units" name the wrong quantity. R' Sigma_G b = Cov(b'y, moisture) depends on the arbitrary scale of b; the expected gain per round is i R' Sigma_G b / sqrt(b' P b) (Falconer & Mackay: R = i sigma_A r form for an index). With P, G of the chunk the Smith-Hazel entry 0.143 is a covariance (audit: sigma_I = 1.1555, gain about 0.124 i). The value 0 for the restricted index is right and is the point; the unit and the word "gain" are not. Accepted: R4, raised from M to D (criterion 1: "whether the quantity described is in fact the one the formula computes").

- **02b-D6 [criterion 1, 2, 5] :259-266 (GCA stated as pool-dependent additive part).** "In a two-pool hybrid population the average effect of an allele substitution depends on which pool it is substituted into ... each line's GCA is its average effect against the opposite pool, i.e. the additive part *relative to that tester pool*, never a property of the line alone." Without dominance (d_k = 0) the average effect of a substitution is beta_k whatever the tester, and a line's GCA does not depend on the tester set (00:126-129, 00:158-165; the opposite-pool frequency enters only through the dominance part, as CLAUDE.md records for `heterosis_gca_sca()`). The chapter's own trait `gv` is additive by declaration (:53-54), so for the sigma_A of @eq-response-breeders the sentence is false; it holds only for the dominance-only H that the chunk uses next. The dominance assumption on which the statement rests is not declared at the place it is made, and the section heading "Combining ability as the additive part" promises a link to sigma_A that the section never makes (audit R3 measured it: for `gv` SCA = 1.1e-14 and var(gv) = var(gca_A) + var(gca_B), so the whole sigma_A^2 is GCA variance, which would have been the statement tying the section to the chapter). Accepted: C7 and R3. The heading/redundancy part (05b owns the derivation) is M2.

- **02b-D7 [criterion 2, 3, 4] :44-58, :156-161 (what "realised response" is, and what the replicated check licenses).** The "realised response" is the mean genetic value of the 60 selected hybrids minus the mean over 625 candidates (caption :62): the genetic selection differential on the selected hybrids themselves, with sigma_A = sd(gv) and r = cor(index, gv). The chapter is motivated by cycle-by-cycle gain (:11-22) and 11c:21 and 04d:260 read it as the response to one cycle, but in the book's programme the hybrids are not recycled, lines are (A3, 00:199-211), so what is transmitted is a line breeding value against a tester pool. The chapter never states that its test concerns the differential in genetic value and not a transmitted response; 04c (04c:850-856) defines r against the breeding value and measures progeny change, a different object, yet :158-159 says 04c "reaches the same reading". Together with the resolving power of the check (30 seeds: mean relative gap 0.0063, s.e. 0.0161; I recomputed 0.00631, s.e. 0.0161 over seeds 1-30, and 0.0101, s.e. 0.0067 over seeds 31-230), "the equation shows no detectable bias" (:157-158) is only a statement that a gap below roughly 3 percent (two s.e.) cannot be excluded; the chapter does not say what size of bias 30 seeds could detect, and the stated limit (:159-161) covers scale only. A conclusion of no effect needs its resolvable effect size (criterion 3, "the number of replicates must be able to resolve the effect claimed"); the undeclared object (selected hybrids as parents) is criterion 2. Accepted: C8 and R8, R12, R9 together, raised from M/Info to disqualifying because the "no bias" reading is the chapter's headline empirical result and travels to 04c and 11c as "the equation works". If the author contests: the caption's definition of "realised" is correct; the defect is the missing statement of scope and detectable size, not the arithmetic.

## NON-DISQUALIFYING OBSERVATIONS

- **02b-M1 :24-26, :464-467 (C15).** "A lighter form of the generator that @sec-simulating-crosses builds": 03:11-19 says 03 builds with `simulate_lines()`/`simulate_data()` and that `simulate_pools()` shares frequencies, lines and factorial but differs in the trait. "Lighter" mislocates the difference.
- **02b-M2 :257-309 (R3, C7 heading part).** Heading and the 05b-owned derivation repeated on a different draw (seed 7, N(0.3, 0.1^2)) from 05b (seed 4, gamma) with no reason; 05b owns the decomposition.
- **02b-M3 :8-22 (C3).** The opening does not say why the chapter follows 02 and cites none of 00, 01, 02; the handover at 02:1100-1103 and 02:806 is kept without being named. Also the opening promises the quantitative genetics "that answers such questions" (the crossover cycle) and the chapter predicts no crossover.
- **02b-M4 :199-236 (R10, C4, Owed 02-M9).** The genic-variance derivation for the intermated-mixture base (02:788-809, pA = pB limit, equal-effects m beta^2 GD_T/4) is not carried by 02b; 02 still says it belongs here. Consistency between the two holds (checked by the audit and by me against :208-209); ownership is unsettled. Owed item 02-M9 stays OPEN.
- **02b-M5 :98-101, :195-196, :211-223, :272-293, :375-382 (R5, C16).** The preface promise (index:73-77) that exact identities print their deviation next to them is kept only for `genic_var()`, and that row prints 0.0000 through `fmt(, 4)` (actual 1.07e-14); the GCA/SCA reconstruction and the hybrid-variance identity run under `results: hide`; tolerances (all.equal default 1.5e-8, 1e-10, 1e-12) are not stated.
- **02b-M6 :93-96 (R6).** "Two identities can be read off it": one is stated and asserted.
- **02b-M7 :58, :62, :111, :115, :150, :160, :185, :300, :355 (R7).** Configuration numbers hand-typed in prose and captions (60, 625, 25 + 25, 2000, 300, 0.5, 0.15, 4000, 30, matrix entries); correct today.
- **02b-M8 :229-233, :245-246 (R11, C12).** Bare theta, GD, N_s, `F_hom`, `F_drift` in code font against theta_S, GD_S/GD_T, F_hom, F_drift of 00-02; the quantity at :229 is GD_T (@eq-hp-gd) and the between-pool part is GD_BS, named only in words; q-bar is not a row of 90.
- **02b-M9 :457-460 (C13).** "@sec-genomic-era and @sec-catalogue measure the allele frequencies from which, through @eq-response-hybrid-var, the genic variance defined here is built" (neither mentions genic variance, V_genic or eq-response-*); "@sec-genomic-prediction measures the r this chapter took as given" (the chapter constructs r = cor(index, gv) from h^2 = 0.5, it does not take it as given; 08b:284 measures a GBLUP accuracy of another object).
- **02b-M10 :93-100 vs :208-209 (R13, C17).** Two variance scales (population in @eq-response-hybrid-var; n - 1 in `genic_var()` and `var(gv)`, 625/624) never reconciled numerically; @eq-response-genic states neither.
- **02b-M11 :399-400 (C18).** "I accept losing five percent" is in quotation marks and is not in 09 (09:25-27 reads "I accept losing at most alpha_max of diversity").
- **02b-M12 :52, :106; :26 (B4, B7, B8, B9).** Falconer & Mackay "ch. 11" for the accuracy form R = i r sigma_A is UNVERIFIED and the refs report suspects a different chapter (the accuracy form being Rendel & Robertson 1950 / Falconer ch. 12); I could not confirm either locator. Balding-Nichols carries no citation (balding1995 is in references.bib). The genic/realised split and the Smith-Hazel and BLUP statements (:314-340) carry no source for the framework.
- **02b-M13 :130 (R8).** The render asserts the chapter's own statistical claim (|mean| < 2 s.e.). With fixed seeds it is deterministic; the audit shows 19 of 20 disjoint 30-seed blocks pass, so a changed seed set breaks the render about once in twenty. The assertion is a check of the chapter's claim, not of the equation.
- **02b-M14 :263 (B6).** Sprague & Tatum is cited for the "exact orthogonal split", which is the book's own derivation in 05b; the citation supports the concepts.

## DISPOSITION OF EVERY REPORT ID

| ID | Ruling | Where |
|---|---|---|
| R1 | accepted, raised M -> D | 02b-D2 |
| R2 | accepted, raised M -> D | 02b-D1 |
| R3 | accepted | 02b-D6 (content), 02b-M2 (heading, redundancy) |
| R4 | accepted, raised M -> D | 02b-D5 |
| R5 | accepted | 02b-M5 |
| R6 | accepted | 02b-M6 |
| R7 | accepted | 02b-M7 |
| R8 | accepted, raised | 02b-D7 (resolving power), 02b-M13 (assertion) |
| R9 | accepted (04c numbers read from published HTML only) | 02b-D7 |
| R10 | accepted | 02b-M4 |
| R11 | accepted | 02b-M8 |
| R12 | accepted, raised | 02b-D7 |
| R13 | accepted | 02b-M10 |
| R14 | owed to 09, 11c | not 02b defects; 09:50 "derives", 09:48 "identical", 11c:114-115 |
| B1 | accepted, raised MEDIUM -> D | 02b-D1 |
| B2 | accepted, decisive and UNVERIFIED | 02b-D1(c); NOT VERIFIED |
| B3 | accepted, non-decisive | NOT VERIFIED |
| B4 | accepted | 02b-M12 |
| B5 | accepted | 02b-D2 |
| B6 | accepted | 02b-M14 |
| B7 | accepted | 02b-M12 |
| B8, B9 | accepted | 02b-M12 |
| C1 | accepted (H) | 02b-D3 |
| C2 | accepted (H) | 02b-D4 |
| C3 | accepted | 02b-M3 |
| C4 | accepted; Owed 02-M9 stays OPEN | 02b-M4 |
| C5 | accepted, raised M -> D | 02b-D2 |
| C6 | accepted | 02b-D3 |
| C7 | accepted, raised M -> D | 02b-D6 |
| C8 | accepted, raised M -> D | 02b-D7 |
| C9, C10 | owed to 09, 04c; not 02b defects | the redundancy says 02b owns the theory, which holds only once D1-D6 are settled |
| C11 | accepted for 02b's half (its formula is stated, not derived; "exactly the same" overclaim) | 02b-D1; 09 owes its half |
| C12 | accepted | 02b-M8 |
| C13 | accepted | 02b-M9 |
| C14 | information; not a 02b defect | next reviews of 11b, 08, 08b |
| C15 | accepted | 02b-M1 |
| C16 | accepted | 02b-M5 |
| C17 | accepted | 02b-M10 |
| C18 | accepted | 02b-M11 |
| C19 | accepted | 02b-D1 |

## RULINGS ASKED FOR

1. **C1 (11c concludes the opposite).** Reword or withdraw now; leaving the promise in place is not acceptable, since 11c is not edited in this pass and 02b is read as it stands today (02b-D3). The fix belongs to 02b; 11c's conclusion is the book's result.
2. **C2 (09 has no equality-to-inequality passage).** Withdraw the promise now, or reword it to a claim true of 09 today; 09 is not edited in this pass (02b-D4).
3. **R1/C5.** Accepted and disqualifying (02b-D2): the term of @tbl-response-genic is sampling covariance of the 25 + 25 founders, zero in expectation (recomputed: share mean -0.009, s.d. 0.205 over 200 seeds), not the Bulmer effect; the identity is exact and no claim about selection can rest on this table.
4. **"Directly anticipates / genuinely new".** Not supportable as written (02b-D1). Meuwissen 1997/2020 constrain a coancestry (molecular in 2020) while maximising gain; the book's own 00:712-713 and CLAUDE.md say so. The K&N attribution itself (exactly the same problem; a theorem from 1959 "stands behind the move") is unverified and overclaimed.

## OPEN ITEMS WITHOUT WHICH THE CHAPTER CANNOT BE APPROVED
D1, D2, D3, D4, D5, D6, D7 (all of the above); the K&N 1959 attribution must be either read and quoted or reduced to a reported, hedged description; Owed 02-M9 settled or reassigned; the three or more non-disqualifying failures (M1-M14) also reject on their own.

## WHAT WAS VERIFIED
- Gap, intensity and replication (my own run, `pkgload::load_all` of the worktree, scratchpad script chk.R, seeds 1-30): mean relative gap 0.00631 (s.e. 0.0161), mean realised intensity 1.7764 (s.e. 0.0097), `sel_intensity(60/625)` = 1.77423, mean cor(index, gv) 0.7114. Seeds 31-230 (200 further seeds): mean gap 0.0101, s.e. 0.0067. All agree with the chapter's inline values (0.006, s.e. 0.016) and with the audit.
- Disequilibrium term as noise (same run): seeds 1-30 mean -0.138, s.e. 0.835; share of V_genic over seeds 31-230 mean -0.0092, s.d. 0.205. The simulator draws loci independently (`R/09_reference.R:30-37`, read).
- Finite-N intensity (set.seed(11), 4000 samples of 625): mean 1.7713, s.d. 0.0443; consistent with the chapter's finite-N claim and negligible against 1.7742.
- `simulate_pools()` scales the true genetic value to unit variance before adding noise of variance 1/h^2 - 1 (read, `R/09_reference.R:46-47`), so the "h^2 share in expectation" sentence (:31-33) holds.
- Algebra by hand: 2 pbar qbar = pA qA + pB qB + (pA - pB)^2/2 (:231); Var(x_k) = (pA qA + pB qB)/4 = pbar qbar/2 - (pA - pB)^2/8 (@eq-response-hybrid-var); restricted index C'b = 0 (@eq-response-restricted); expected response of trait j to index b'y is i (Sigma_G b)_j / sqrt(b'Pb) (D5); P - G = [[2, 0.9], [0.9, 0.7]] positive definite (det 0.59), G det 0.51 (:359-360).
- Meuwissen et al. 2020: the Methods and Optimum Contribution Selection paragraph (local PDF, "maximize g-bar = c'g-hat ... K = 1/2 c'Gc", rate of inbreeding constrained through the group coancestry) read directly.
- 11c:95-235 and 09:40-130 read: C1 and C2 reproduced as described.
- Audit and refs reports consumed under criteria 2, 5, 7 (their own verification: chapter knits, all stopifnot pass; frozen output matches; 600-seed check of the replicated claim; Crossref metadata correct for all six keys).

## NOT VERIFIED
- Kempthorne & Nordskog 1959 content (what problem, what restriction, whether the matrix form is theirs): JSTOR only, no copy read by refcheck or by me. Decisive for the section; blocks approval (D1(c)).
- Smith 1936, Hazel 1943, Bulmer 1971, Sprague & Tatum 1942, Falconer & Mackay chapter locators ("ch. 11" twice): primary text not read (B2-B6); the Smith-Hazel formula is checked by algebra, not against the sources. Non-decisive except Falconer's locator for the accuracy form, which refcheck suspects is mis-located.
- Meuwissen 1997: not reread by me; I rely on the paper's own citation of it in the 2020 reference list and on 00:712-713 for what it is credited with.
- 04c replicated numbers (-0.5 and 2.5 percent, largest 1.1 s.e.): read from the published HTML by the audit, not rerun (needs AlphaSimR and MaCS).
- Quarto cross-reference resolution, the Typst PDF and `docs/02b-response.html` freshness: render pending.
- 11c's absence of a gene-diversity versus variance trajectory comparison (D3): read 11c:95-235, relied on C6 for the whole of 11c.
