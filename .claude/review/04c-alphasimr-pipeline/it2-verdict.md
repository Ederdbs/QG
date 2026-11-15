# 04c-alphasimr-pipeline -- iteration 2 verdict (head of department)

Chapter: book/04c-alphasimr-pipeline.qmd (2303 lines, read in full). Read also: it1-verdict.md, it1-response.md (quant-writer and
quant-Rwrite sections), THREAD.md, `git diff origin/main` for 04c and 90-notation, 02b:636-700 and 754-790, 05b:792-850 and 2165-2190,
04d:244 and 366-370, 11c:171-232, R/13 (`alphasimr_to_stage1`, `alphasimr_make_hybrids`), _quarto.yml order. CLAUDE.md was not edited.
Reference library (papers/) holds no Falconer & Mackay, Sprague & Tatum, Hallauer or Comstock.

VERDICT: APPROVED

## Standing instructions
- Comstock et al. (1949): user-declared PENDING. The chapter now carries the title only (04c:61-63, 1007-1009), says the content is not
  reported, and the book's own description of RRS is labelled "not a statement of what Comstock et al. report". Nothing of the paper's
  content is attributed. Open owed item for the user, not a ground. (R/13 roxygen at :114 still attributes; code item, outside this text.)
- CLAUDE.md not edited. Conflicts with the chapter reported under "For the user".

## PREVIOUS IDS
- 04c-D1 -- CLOSED -- 04c:196-249, 287-307, 1466-1471, captions via `founder_note` (line 20-21). The claim is cut to what the chapter
  measures: one runMacs() pair per render, read inline (`differed`/`identical`), R stream asserted identical; a rate, anything on
  runMacs2() and a mechanism are stated as NOT established; `nThreads` is a labelled untested hypothesis. "MaCS output is not a
  deterministic function of the seed" and "true of MaCS generally" are gone. The `stopifnot(!identical(ma@geno, mb@geno))` is removed
  (175-178), so a render cannot fail on a coincident pair. Consistent with my it1 probes (runMacs default threads: pair differs in 5 of 6
  fresh sessions, identical in 1; runMacs2 0/8 differ; R stream identical after two calls). CONTESTED item (k/n table over >= 20 seeds,
  incl. runMacs2 and nThreads = 1, not added): ACCEPTED. The table was a remedy for an over-claim; with the claim reduced to a single
  declared pair, no rate is asserted and none is required. Whoever wants the rate must run it; the chapter says it is not measured.
- 04c-D2 -- CLOSED -- the "built on using the opposite pool as the tester" sentence is gone; replaced by the book's own description,
  explicitly "not a statement of what Comstock report" (1003-1009). Title only (61-63).
- 04c-D3 -- CLOSED -- "classical ancestor" removed; Kempthorne & Nordskog reported through 02b as unread with the matrix form the
  book's own (1386-1392, matches 02b:754-762); Meuwissen lineage matches 02b:775-790. The "exactly zero" is now "expected gain ... at
  zero", value printed (6.6e-17), labelled a model expectation G b / sqrt(b'Pb), not a realised change (1380-1386).
- 04c-D4 -- CLOSED -- Step 7 now states that the pipeline default is a_j = 1/sd(criterion_j) on predicted values (02b:640-651), that with
  multi-trait BLUP criteria b = a (02b:665-668), that Step 7 is the phenotypic case with a2 = c(1,1) on raw units and is NOT the
  default, so the 4.1x / 0.2 % comparisons concern indices on phenotypes (1302-1323). It also states that the bridge passes
  `hybrid_pop@pheno` (R/13:198, one plot: setPheno default reps = 1) so Step 8's last subsection is the phenotypic case 02b does not
  cover and whose gap is not measured. Heading is "an index on phenotypes". Recomputed: 4.1x = 0.0437/0.0108 (4.05); 0.2 % = 1 - 0.2434/0.2438.
- 04c-D5 -- CLOSED -- 2117-2121 and 2280-2287 now say what 11b/04d actually say (04d:366-370 quoted verbatim; 11b has no random arm); Step 8
  is stated to cross-check nothing of 11b's alpha result; 11c's use of `alphasimr_founder_pools()` (11c:171-232) is stated, no "linked arm of
  this chapter".
- 04c-D6 -- CLOSED -- `metrics` and `n_tests` = 11 declared in setup (16-19) and in the caption and text; Bonferroni point computed in the
  chunk (t_bonf = 2.98 in my runs, equal to my it1 value 2.9805); dependence stated; Bonferroni stated conservative under dependence;
  the two pooled gene-diversity means declared post hoc constructions and all diversity conclusions labelled exploratory (2059-2064);
  the inferred sentence picks its wording from the unadjusted AND the Bonferroni verdict (2101-2109). The prose flips with the render
  (it1 committed render t = -2.9 / -2.8 would read "an unadjusted suggestion ... which the correction does not support"; my two runs
  give t = -3.5 / -3.4, beyond 2.98). That is conditional wording, not a hidden threshold.
- 04c-D7 -- CLOSED -- "dominance effect" at 391-393 with the pointer to @sec-heterosis-dk-meaning and varD/genicVarD stated to be Fisher's
  statistical object; 90-notation rows 210, 518, 608 changed accordingly.
- 04c-D8 -- CLOSED -- GD_BS statement at 2190-2198 and 2121-2131 carries 05b's conditions (flat d, inbred parents, complete factorial, equal
  weights), says here d_k varies, pools outbred, factorial elite, "read as a divergence statistic, not as a measure of heterosis";
  "expected to do" removed; 05b's forward inference (05b:2175-2182, "an inference ... not a result shown in it") is stated untested and
  cov(d, y^2) / the cycle-wise divergence share stated not computed. (The condition "neutral redraws" of the 02 keystone row is not
  repeated; the sentence points to @sec-heterosis for the conditions. Not a failure.)
- 04c-M1 -- CLOSED -- r against bv() stated not the r of @eq-response-breeders unless d = 0, R_observed not the object 02b checks, r also
  names locations (929-938); 90 row added.
- 04c-M2 -- CLOSED -- requested vs realised h2 (0.6/0.1 vs 0.47/0.072) stated inline with the cause (1292-1299); captions say "requested".
- 04c-M3 -- CLOSED -- verdict words are computed inline; captions with configuration numbers are built from constants; typed settings of the
  Steps 2-7 captions checked by me against the code (60/30/80 founders, 1000 QTL, 200 F1 and DH, 400 lineages, seeds 501-520, 301-320, 202,
  600, 4000 replicates, n_rep_q = 100): all agree.
- 04c-M4 -- CLOSED -- `fmt(10)` residual replaced by `format(d, digits = 2)` plus `stopifnot` (968-971, 1400-1403); prints 1.1e-15.
- 04c-M5 -- CLOSED -- GD_T = GD_WI + GD_BI + GD_BS asserted for each of the 80 split draws (1524-1526).
- 04c-M6 -- CLOSED -- opening (49-57) says why 04c follows 04 and 04b and links 00.
- 04c-M7 -- CLOSED -- two definitions of "genic variance" stated (518-530).
- 04c-M8 -- CLOSED -- "book scale" gone; Scale paragraph lists the four scales from the objects (2239-2247).
- 04c-M9 -- CLOSED -- the accuracy formula is tied to @eq-het-rho-k and @tbl-mating-quantities with what 04c adds (1120-1127); Step 7 points to 02b.
- 04c-M10 -- OPEN (carried, non-disqualifying, not decisive) -- Sprague & Tatum, Falconer & Mackay locators, Hallauer et al., Smith 1936, Hazel 1943,
  Kempthorne & Nordskog remain unverified as sources; the chapter now scopes each ("whose paper the book does not quote", "chapter
  locators ... not checked against a copy", "no page cited", "neither that chapter nor this one read"). The algebra each is cited for
  is asserted in-chunk against AlphaSimR (mu_HW, alpha, genicVarA, GCA, H_ij, the F_t trajectory), so the argument does not rest on them.
- 04c-M11 -- CLOSED (C12 x_ik / M^H settled by declaration at both ends, 375-386 and the 90 AlphaSimR table).
- Contested/other: C16 (CLAUDE.md) reported to the user below. R11 (`run_rrs` unlabeled) not requested; no consequence.

## DISQUALIFYING FAILURES
None.

## NON-DISQUALIFYING OBSERVATIONS
- 04c-M12 04c:1619-1744 (+ 1583-1594) -- the sweep tests (two contrasts of tbl-alphasimr-contrast, the GCA_var_dom contrast, the
  covariance term at four splits) are each decided against the single unadjusted point t(19) = 2.09, their number is not declared, and
  line 1727 calls that unadjusted point "conservative". It is conservative for a verdict of "not distinguishable from zero", not for a
  verdict of a difference. The defect fixed in the paired table (D6) is not carried to the sweep. In my runs t = 5.3 and -4.9 pass any
  correction (qt(1 - 0.05/14, 19) = 3.01 for 7 tests), so nothing flips here; the exploratory status of the ascertainment bookkeeping and
  the one-at-a-time ratio decomposition (`gca_only`) is not stated either way.
- 04c-M13 04c:42-44 vs 2174-2178 -- the caption of tbl-alphasimr-pipeline says "one further founder draw"; the text says the call uses seed = 1 like
  replicate 1 and that whether the founders coincide is not established. The words do not contradict each other strictly, but a reader
  of the caption alone is told something the text withholds.
- 04c-M14 04c:1351, 1358-1359 -- `a`-weighted and `b = P^-1 G a` in code font: the code object `a` is the vector of 1000 additive effects
  (Steps 2-6); the economic weights are `a2`. The mathematical $\mathbf a$ / $a_k$ distinction is conventional and consistent with 02b and 90.
- 04c-M15 04c:1656-1659 -- "within pools falls, the between-pool component rises" at the sites other than fixed differences is attributed to 05b
  and the table supports only GD_T_other (total) falling and the within-pool monomorphic fraction rising; the between-pool component at those
  sites is not tabulated. The passage sits under "What is inferred", so not a result presented as measured.
- 04c-M16 -- redundancy: the "not established (Step 1)" formula is repeated in seven captions and six prose passages. It is the price of the scoping
  and each use is accurate; economy only.
- 04c-M17 -- docs/ and book/_freeze/ are stale (no Quarto render was run, as the response states): the committed HTML still shows the it1 values
  (t = -2.9 / -2.8) and the old wording. Process item before commit (CLAUDE.md), not a defect of the source text.
Count of non-disqualifying items I hold as failures: two (M12, M13); M10 is a disclosed, scoped limit; M14-M17 are below the line.
A third failure in this class would reject.

## WHAT WAS VERIFIED
- Chapter run end to end: `knitr::knit()` (inline R evaluated) of a copy of 04c-alphasimr-pipeline.qmd, package loaded with
  `pkgload::load_all("..")` from the worktree, AlphaSimR 2.1.0, from book/ (scratch: .../scratchpad/it2/run.R, out1.md, out2.md). Run 1: DONE
  2.50 min, no error; run 2: DONE 2.51 min, no error. knit stops at the first failing chunk, so every `stopifnot` passed twice: the Step 1
  assertions (identical .Random.seed after the runMacs pair; quickHaplo reproducible), varD < 1e-10, the gv/bv/mu_HW/genicVarA/GCA/SCA
  identities, f1_sd, |z| < 4 of the selfing trajectory, the accuracy and Smith-Hazel assertions (d_opt 1.1e-15 < 1e-6), the 80-draw
  GD_T partition identity, the cycle-1 pairing across 48 draws, and the pool_tab identity.
- `diff out1.md out2.md`: 6 differing lines, all wall-clock (seconds_per_call, ms per call). Every other number is identical between the two
  independent executions, including the runMacs row of the LD table and all of Step 8 (runMacs2 founders, 48 paired draws, 80 sweep draws).
  Hence the 04c:304-307 claim (two executions agree on Steps 1-7 except timing and the runMacs rows) holds, and holds a fortiori for Step 8
  on this machine in these two executions. The runMacs pair itself differed in both runs (`returned different`).
- Inline numbers of run 1: n_tests = 11, t_crit 2.01, t_bonf 2.98; paired t: mean_tc_A 17.1, mean_tc_B 16.7, hybrid_meanG 16.7, gd_elite_mean -3.5,
  gd_pool_mean -3.4, GD_BS 6.3, F_ST 4.7; pool_tab cor_AB 0.91 for mean_tc, ~0 for gd; contrast t = 5.3 (GCA_dominance_share), -4.9
  (cor_perse_GCA); GCA_var_dom t = 0.9; cov term max |t| 0.94; Step 7: h2 0.47 / 0.072, SH ratio 0.75, 4.1x, 0.2 %, restricted gain_trait2
  6.6e-17, 15 % cost. The text branches (beyond / not beyond; Bonferroni supported / not supported) select the branch that matches.
- 4.05 = 0.0437 / 0.0108 and 0.2 % = 1 - 0.2434/0.2438 from the printed table; Bonferroni point qt(1 - 0.05/22, 47) = 2.9805 (it1).
- Cross-references: every @sec-/@eq- label used in 04c exists in the book (loop over `{#label}`: none missing).
- 02b:636-700 (default = 1/sd weights on predicted values; BLUP gives b = a; Smith-Hazel for phenotypic records), 02b:754-790 (Kempthorne unread;
  Meuwissen lineage), 05b:2165-2182 (forward inference labelled "not a result shown in it"), 04d:366-370 (verbatim quote), 04d:244 and 11c:195
  (the "not reproducible" statements 04c attributes to those chapters), R/13:198 (`traits = as.data.frame(hybrid_pop@pheno)`), R/13:170
  (`setPheno` default reps = 1) read and agree with the text.
- 90-notation diff for 04c rows (210, 518, 561, 608): consistent with the chapter ("dominance effect"; r only equals @eq-response-breeders if d = 0).
  Other rows of that diff belong to the 04/04b reviews.
- book/downloads/04c-alphasimr-pipeline.R carries the new code (n_tests present); in sync with the .qmd.
- My knit created an untracked book/figure/ (one PNG, 0 tracked files); removed. Nothing tracked changed by me.

## NOT VERIFIED
- Falconer & Mackay chapter locators (ch. 7, 8, 14), Sprague & Tatum 1942, Hallauer et al. 2010, Smith 1936, Hazel 1943, Kempthorne & Nordskog 1959:
  no local copy; refcheck left them UNVERIFIED. Not decisive: scoped by the chapter, and the quantities are checked in-chunk or derived.
- Comstock et al. 1949: PENDING by the user; title only is attributed.
- Quarto render (HTML/Typst): not run; `!expr` captions containing cross-references and the subtable references (@tbl-alphasimr-paired-1,
  @tbl-alphasimr-split-1..5) were checked for label existence only, not for resolution. Form belongs to quant-editor.
- Whether runMacs() differs between calls at a rate that matters, and whether runMacs2() ever differs: not established by the chapter (it says
  so) and not by me; my two full executions found Step 8 identical.

## For the user (conflicts with CLAUDE.md, not acted on)
1. CLAUDE.md, "MaCS is not seeded by set.seed(), and it poisons everything downstream of it": says a runMacs()/runMacs2() call "consumes an
   unpredictable amount of R's own random stream, so every later draw in the same session inherits an unpredictable seed". The chapter's
   asserted `identical(.Random.seed)` after two calls passed in both of my runs, and AlphaSimR draws one sample.int(1e8, 1) per chromosome.
   The measurement supports the chapter, not CLAUDE.md, on the stream. The rules CLAUDE.md derives (seed immediately before each founder draw;
   found once and branch) hold under either reading and the chapter keeps them.
2. CLAUDE.md "two calls with the same seed return different founders (measured in 04c)": 04c now measures one default-threaded runMacs() pair and
   says so. For runMacs2() the evidence available to me is: 0/8 differing calls in each of three scripted probes (it1) and Step 8 identical in
   two whole executions here. Still owed to you: 11c:193-205 ("is not reproducible ... two calls ... return different founder haplotypes"),
   04d:244, index.qmd:188 and 216, and the R/13 roxygen at :47-64 and :114 (also the Comstock attribution) say it without qualification.
   Across executions the committed render (t = -2.9), the author's check run (-5.3) and my two runs (-3.5) did differ, so some
   non-reproducibility exists between machines or sessions; its cause is undetermined.
