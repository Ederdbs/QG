# 04c-alphasimr-pipeline -- iteration 1 verdict (head of department)

Chapter: book/04c-alphasimr-pipeline.qmd (2086 lines, read in full). Read also: THREAD.md, it1-audit.md (R1-R11),
it1-refs.md (B1-B13), it1-continuity.md (C1-C16), 02b:628-790, 11b, 11c:171-235, 04d:360-370, R/13 roxygen,
docs/04c-alphasimr-pipeline.html (committed render). CLAUDE.md was not edited.

VERDICT: REJECTED

## Handling of the two standing instructions
- Comstock et al. (1949) is a user-declared PENDING item. It is recorded as an open owed item (04c-B1/R2) and is NOT
  by itself grounds to hold the chapter. The only part counted against the chapter is the sentence that attributes
  content the book has not read (04c:915-917, "is built on using the opposite pool as the tester so that selection
  captures both"), which is a requirement that the chapter not attribute unread content (D2). The bare citation at
  04c:22-23 (RRS "[@comstock1949]") is not counted.
- CLAUDE.md is not edited. Where the chapter's MaCS statement conflicts with CLAUDE.md, the chapter is judged only on
  whether it says what it evidences; the conflict is reported to the user (section "For the user").

## DISQUALIFYING FAILURES

- 04c-D1 [3, 4, 6] 04c:154-165, 172-179, 234-252, 262-264, 1316-1320, 1562-1563, 2036-2037 (endorses R1, HIGH) -- The
  claim "runMacs() is not reproducible from set.seed()" and its extension to runMacs2 and to all of Step 8 rests on ONE
  pair of runMacs(species = "MAIZE") calls (125-136), one replicate, no count. Line 178 says the table "shows it is not
  runMacs2-specific but true of MaCS generally": the table never calls runMacs2; the inference runs the wrong way. The
  sentence at 162-163 ("What was measured, then, is that MaCS's output is not a deterministic function of the seed")
  presents a mechanism as a result: the chapter measured one differing pair, not a property of MaCS. Omitted limits (c.6):
  the behaviour is intermittent and depends on the call (threading, `nThreads`) -- see my probes below. The chunk also
  carries `stopifnot(!identical(ma@geno, mb@geno))`, an assertion that the render will fail if MaCS happens to return
  identical output, which my probes show it sometimes does (1 of 6 fresh sessions: all three calls identical).
  Consequence: the Step 8 "no number reproducible from the seed" status (tbl-alphasimr-founders, cycle1, rep1, paired,
  loss, pipeline captions; 1978 "one further founder draw") is asserted, not established; whether `res` is "a further
  draw" is unknown (arms[[1]], tbl-alphasimr-founders, cycle1 and res all use seed 1).
- 04c-D2 [7] 04c:915-917 (endorses R2/B1 only for this sentence) -- "The reciprocal recurrent selection of @comstock1949 is
  built on using the opposite pool as the tester so that selection captures both" goes beyond the title; 05b settled the
  same paper as existence and title only and states it reports nothing else of it. The paper remains PENDING; the sentence
  attributes unread content. (04c:22-23 is not counted, see above. The R/13 roxygen repeats it; that is a code item.)
- 04c-D3 [7, 1] 04c:1239-1243 (endorses R3 = C2, HIGH) -- (i) "That is the construction of @kempthorne1959 and, as @sec-response
  argues, the classical ancestor of this book's alpha constraint": 02b:754-790 states the paper was NOT read, that the matrix
  form is the book's own, that the lineage of constraining a group coancestry is Meuwissen (1997/2020), and that the
  restricted direction is not the book's contribution; 02b never says "ancestor". The chapter attributes to 02b and to
  Kempthorne & Nordskog (1959) what neither supports. (ii) "holds trait 2 at exactly zero": the chunk computes the EXPECTED
  gain G b / sqrt(b'Pb) from sample matrices and asserts < 1e-10 * max|dG|; it is a model expectation, not a response
  (the caption, 1182, says "zero expected gain"; the prose says "exactly zero").
- 04c-D4 [5, 2] 04c:1143, 1176-1178, 1180-1226 (endorses C1 = R4, HIGH) -- Step 7 is presented as examining the pipeline's
  `weights = NULL` default. 02b:636-656 (approved) states the criteria of `stage2_select()` are predicted values, standardised,
  so the default is economic weights 1/sd(g-hat), "an economic statement", and the Smith-Hazel gap is a property of an
  index on phenotypes. 04c uses `a2 = c(1, 1)` on raw trait units of traits with genetic variances 1 and 4 and the phenotypic
  covariance P, so (1,1) is not the default, the 4.1x and 0.2 % comparisons are about phenotype indices, and the inference
  "what equal weighting assumes" (heading) does not apply to the default. The bridge feeds `stage2_select()` phenotypes
  (R/13 `traits = as.data.frame(hybrid_pop@pheno)`), a case the chapter does not state. 02b-C10 is not settled.
- 04c-D5 [7, 5] 04c:1928-1932, 2067-2070 (endorses C4, HIGH; verified) -- (a) "the control isolates that component from the drift
  part, which is the distinction @sec-cycles draws ... over a longer trajectory and a grid of selection intensities, and
  @sec-programme draws a third time": 11b has no random-selection control and no grid of selection intensities (grep of 11b:
  budgets, max_use caps, injection, selector; `n_sel` a fixed value); 04d:366-370 says its loss is measured against the
  programme's own start "rather than against a random-selection baseline of the same size ... a same-size random baseline would
  attribute part of this loss to drift" -- 04d explicitly does not draw the distinction. (b) "this chapter is [11b's] cross-check
  against an engine with real meiosis behind it, and @sec-limits uses this chapter's linked arm": Step 8 has no diversity
  constraint (unconstrained RRS against random elites), so it cross-checks nothing of 11b's alpha result; 04c has no arm called
  linked (11c builds it on the Step 8 wrapper, 11c:171-232, which supports only the weaker statement that 11c uses the bridge).
- 04c-D6 [3] 04c:1746-1761, 1854-1942 (new) -- Multiplicity. Eleven paired t statistics (`metrics`, 1746-1748) are each compared with
  the same two-sided 5 % point (t_crit = 2.01, 47 d.f.) and the "What is inferred" paragraph rests on the two borderline ones:
  elite-line and recombined-pool gene diversity, t = -2.9 and -2.8 in the committed render (diff -0.008, paired s.d. 0.02). The
  number of things compared is not declared in the text and not accounted for; the Bonferroni point for 11 comparisons is
  2.98 (computed: qt(1 - 0.05/22, 47) = 2.9805), which neither value reaches, and the two statistics are not independent (they
  share the same elites). The sentence "it [RRS] spends within-pool diversity faster than the same bottleneck under drift alone"
  is conditioned on the render, which is honest about render dependence, but not on multiplicity or on the metrics chosen
  after the fact (the pooled means `gd_elite_mean`, `gd_pool_mean` are post-hoc constructions, not declared exploratory). The
  response claim (t = 19.6) is not affected.
- 04c-D7 [5] 04c:333 (endorses C3 = R6) -- d_k is "the dominance deviation". The book (05b:145-166, applied in 00, 01, 02, 02b) reserves
  "dominance deviation" for Fisher's statistical object and calls d_k the dominance effect. In 04c the clash is live: the same chapter
  reports `varD`/`genicVarD` and states `varD` of the inbred founders is zero "whatever d is", which with "dominance deviation = d_k"
  reads as d_k = 0. A renamed object within the book's own notation.
- 04c-D8 [2] 04c:1988-1991, 1932-1937 (endorses C8 in part) -- "GD_BS, the between-pool divergence that carries the heterosis signal" and "RRS is
  moving the pools apart faster than drift does, which is what a scheme selecting on the cross is expected to do". 02/05b make GD_BS the
  divergence term of expected heterosis only for flat d, inbred parents, complete factorial and equal weights; with varying d_k
  (here d_k = delta_k|a_k|) it holds for the d-weighted term only, and Step 8's pools are outbred. The conditions are used and not
  declared, and the "expected" is supported by neither chapter. 05b's forward inference (cov(d, y^2), divergence share across
  cycles) is untested in 04c and 04c does not say it is untested.

## NON-DISQUALIFYING OBSERVATIONS (each endorsed with severity; four or more accumulated would reject on their own)

- 04c-M1 (R5 + C6, MED) 04c:848-852, 981-984 -- 02b-C8 half-settled: the r against bv() is defined but the chapter does not say it is not
  the r of @eq-response-breeders unless d = 0, nor that R_observed (change in progeny mean after random mating) is a different object from
  02b's genetic differential. r also names locations (981-984, 990-1012) in the same chapter; the 90 AlphaSimR table does not give the accuracy r.
- 04c-M2 (R7, MED) 04c:1152, 1171-1182 -- Captions state h^2 = 0.6 and 0.1 (requested); the realised values are about 0.47 and 0.072; no reason is given
  (setVarE on founder variance; three rounds of mating roughly halve varA, Step 3).
- 04c-M3 (R8, LOW-MED) 04c:675-677, 970-973, 1113, 1129, 1171, 1286, 1344, 1427, 1596, 1715, 1734, 1780, 1964, 484-486 -- hand-typed verdicts and
  configuration numbers in captions; "exactly zero" for 9.6e-33.
- 04c-M4 (R9, LOW) 04c:884, 1251 -- fmt(10) prints 0.0000000000 for 1.1e-15, hiding a residual.
- 04c-M5 (R10, LOW) 04c:1327-1328 -- GD_T = GD_WI + GD_BI + GD_BS stated, not asserted in the chunk.
- 04c-M6 (C5, MED) 04c:11-17 -- opening does not say why 04c follows 04 and 04b.
- 04c-M7 (C7, MED) 04c:458-460 -- "genic variance" is two quantities (observed-variance `genic_var()` versus HW `genicVarA`); stated as the same.
- 04c-M8 (C9, MED) 04c:1596, 1607, 1790, 2032 -- "book scale" is a third scale, not book_cfg (A8).
- 04c-M9 (C10 + C11, MED) 04c:990-1012, 1210-1226 -- tester-accuracy formula and the Smith-Hazel eigenvector paragraph re-derived where 05b/04e/02b own them; relations not cross-referenced.
- 04c-M10 (B2, B3, B4, B6, MED) citations unverified by refcheck: Sprague & Tatum 1942 (GCA definition, 49, 914), Falconer & Mackay chapter locators (330, 497, 508, 649, 712; 02b gives none), Hallauer et al. 2010 (355, 1140), Smith 1936 / Hazel 1943 (1213). None is decisive alone (standard material; the chapter's own derivations carry the argument). Falconer & Mackay locators are the only items I would treat as risk of inventing a source.
- 04c-M11 (C12-C15, LOW) 0/1/2 versus 0/0.5/1 symbol residue; unflagged forward dependences (@sec-combinatorial); no citation of 00; outbred-tester GCA identified with Step 6's inbred GCA without saying so; two sigma^2_SCA definitions not linked in 90.
Count: more than three accumulated; recorded, not the ground of rejection.

Endorsement summary: R1 H, R2 H (partially; see D2), R3 H, R4 M-H (D4), R5 M, R6 L (raised to D7 because the clash with varD is live), R7 M, R8 L-M, R9 L, R10 L, R11 info. B1 pending (open owed, not a ground), B2-B6 unverified non-decisive, B7-B13 OK. C1 H, C2 H, C3 H (D7), C4 H (D5), C5 M, C6 M, C7 M, C8 M-H (D8, partly), C9 M, C10 M, C11 M, C12-C15 L, C16 reported to the user (below).

## WHAT WAS VERIFIED
- R1, MaCS (AlphaSimR 2.1.0, same machine; scripts in the session scratchpad .../scratchpad/v/macs.R, pair.R):
  `runMacs(nInd=20,nChr=10,segSites=50,inbred=TRUE,species="MAIZE")`, `set.seed(7)` before each call, count of 8 repeat calls whose @geno differ from the first call: default threads 8/8 in each of the 3 full runs of the script; `nThreads = 1`: 0/8 in each of the 3 runs.
  `runMacs2(nInd=24,nChr=5,segSites=150,inbred=TRUE,Ne=100,split=100)`: default threads 0/8 in each of the 3 runs (with R's `set.seed(7)` each call); `nThreads = 1`: 8/8 differ in run 1, 0/8 in runs 2 and 3 (unexplained; machine was running other work during run 1). So runMacs2 shows intermittent, not systematic, non-determinism, and `nThreads = 1` did not remove it in one run.
  The chapter's own pair (three calls, fresh session each, the chapter's exact arguments): FALSE/FALSE/FALSE; FALSE/TRUE/FALSE x3; TRUE/TRUE/TRUE (all identical); FALSE/FALSE/FALSE (a-b, b-c, a-c, over 6 sessions): the first pair differed in 5 of 6 sessions and was identical in 1 -- the `stopifnot(!identical(ma@geno, mb@geno))` can fail on a render.
  `.Random.seed` after two runMacs calls from one seed: identical (TRUE), geno identical in that session. Source of AlphaSimR::runMacs: one `sample.int(1e8, 1)` per chromosome, then `MaCS(..., nThreads, seed)`; `nThreads` defaults to `getNumThreads()` capped at nChr. The chapter's statement "one sample.int() per chromosome" (157) and "R's stream advances by the same amount" are therefore confirmed; the statement that the output "is not a deterministic function of the seed" is, at best, true intermittently.
  Conclusion: R1 is confirmed as a HIGH finding; the audit's thread-dependence is partly confirmed (runMacs yes, runMacs2 no) and the mechanism remains undetermined.
- C1: 02b:636-656 read; 04c:1164-1189 uses P (phenotypic), a2 = c(1,1), raw units. Confirmed.
- C2 / R3: 02b:754-790 read (paper not read; matrix form the book's own; Meuwissen lineage); 04c:1239-1243 read. Confirmed.
- C4: 04d:366-370 read (does not draw the distinction); 11b grep: no random-selection control, no selection-intensity grid; 11c:232 "supplies the linked arm" read. Confirmed (a) in full, (b) in part.
- Committed render (docs html): t = 19.6 (hybrid_meanG), t = -2.9 (gd_elite_mean), -2.8 (gd_pool_mean), 7.3 (GD_BS), 4.4 (F_ST); t_crit = 2.01. Rscript: qt(1 - 0.05/22, 47) = 2.9805, qt(1 - 0.05/10, 47) = 2.6846, 2*pt(-2.9, 47) = 0.0057, 2*pt(-2.8, 47) = 0.0074.
- From the audit (consumed, not re-run by me): the chapter's code purled and run end to end (every inline number agrees with the committed render); identities asserted OK; the 48-draw paired design uses the founder draw as the unit with both arms branched off one founder object.

## NOT VERIFIED
- Falconer & Mackay chapter locators, Sprague & Tatum 1942, Hallauer et al. 2010, Kempthorne & Nordskog 1959, Smith 1936, Hazel 1943: no local copy; the GCA and Smith-Hazel material is standard and the chapter derives what it uses, but the attributions are unconfirmed. Comstock et al. 1949: PENDING by the user.
- Why runMacs2 with `nThreads = 1` differed 8/8 in one run and 0/8 in two others: not established; would need a run on an idle machine over >= 20 seeds including seed 1, default and `nThreads = 1`, counting differing calls k/n.
- Whether a Step 8 draw is the same founder object across `rrs_cfg$seed = 1` uses (tbl-alphasimr-founders, cycle1, arms[[1]], res): depends on the above.

## For the user (conflict with CLAUDE.md, not acted on)
CLAUDE.md says an AlphaSimR::runMacs()/runMacs2() call "consumes an unpredictable amount of R's own random stream, so every later draw in the same session inherits an unpredictable seed". My probes and the chapter agree that `.Random.seed` after two runMacs calls from one seed is identical (the call draws one sample.int(1e8, 1) per chromosome), and that only the haplotypes can differ; the chapter is right on this point and CLAUDE.md is not supported by the measurement. CLAUDE.md also says "two calls with the same seed return different founders (measured in 04c)" without qualification, and 11c:193-205 and the R/13 roxygen repeat it; the evidence I have is: intermittent, in default-threaded runMacs reliably, in runMacs2 not reliably. The chapter should say only what it evidences; the repository notes and 11c should be reconciled by you.
