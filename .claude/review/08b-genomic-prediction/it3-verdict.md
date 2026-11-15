# 08b-genomic-prediction -- iteration 3, verdict

VERDICT: APPROVED

Text: `book/08b-genomic-prediction.qmd` (1267 lines), `book/90-notation.qmd` (rows Z, G*, W, u/u-hat, r, r_i^2, M_e, CV note).
The chapter was re-executed end to end (purl of every chunk, `pkgload::load_all` of the worktree, wd `book/`); every `stopifnot` passed.
Scratch: `/private/tmp/claude-501/-Users-ederdbs-Documents-SB-quanti-gen/b21c3252-fade-4466-9e3d-6022a32fa781/scratchpad/it3/` (`ch.R`, `run.R`, `run.out`, `ch40.R`).

## PREVIOUS IDS

- 08b-D9 -- CLOSED -- the CV table column is `implied`, defined in the caption as sqrt(mean r_i^2); code columns `imp2/imp1/imp0`; recomputed implied 0.8734 / 0.6442 / 0.1268, mean reliabilities (`colMeans(cv[, imp*]^2)`) 0.7629 / 0.4149 / 0.0161, s.d. of the implied accuracies 0.0014 / 0.0021 / 0.0034 (the 0.001-0.003 of the text), gaps -0.0315 / -0.0213 / -0.0171 (s.e. 0.0050 / 0.0152 / 0.0346). The text states the square-vs-root relation and prints the 0.763 / 0.415 / 0.016. A one-word residue ("the reliability is conservative") is logged as 08b-M12; it does not re-open the ID.
- 08b-D10 -- CLOSED -- grep of the chapter for "usual", "common", "literature", "well known", "textbook", "classical", "reported": the "usual telling" sentence and "commonly written" are gone; the BayesA paragraph now states only the measured fact (variance ratio above 1 in all 8 chains, 1.38 to 31.67 in the it2 run); the Daetwyler form is declared the chapter's own statement of the dependence on n h^2 / M_e, with Eq. 1 and the symbol M_e declared unseen. The remaining "literature" hit (08b:480) names Burgueno et al. 2012; "textbook case" (08b:943) is a description, not an attribution.
- 08b-D5 (sub-point a) -- CLOSED -- recomputed from `book/data/genomic_prediction_accuracy.csv` (15 paired splits per cell, paired t, 14 d.f.): BayesA-GBLUP polygenic 0.2 -0.0039 (s.e. 0.0019, p = 0.0598), oligogenic 0.2 -0.0069 (0.0022, p = 0.0068), polygenic 0.5 -0.0003 (0.0004, p = 0.435), oligogenic 0.5 +0.0014 (0.0005, p = 0.0137); BayesB-GBLUP polygenic 0.2 -0.0014 (0.0016, p = 0.396), oligogenic 0.2 -0.0009 (0.0018, p = 0.631), polygenic 0.5 -0.0003 (0.0004, p = 0.423), oligogenic 0.5 +0.0224 (0.0017, p = 3.8e-9). Family of 8 declared and asserted (`n_contr == 8`); Bonferroni 0.05/8 = 0.00625 (the 0.0063 of the text); only BayesB oligogenic h2 = 0.5 passes; the BayesA oligogenic h2 = 0.2 contrast (p = 0.0068) does not, and the text says it does not; the other contrasts are labelled exploratory; "a small loss" and "BayesA lost ..." are gone; the max |t| over the three BayesB null cells is 0.88 (text "0.9"). The family is the table's own, declared; the chapter's other tests are not folded in, and it says so in the response, not the text (non-decisive: those tests are not selected winners).
- 08b-D7 (sub-point a) -- CLOSED -- `08b:685-690`: the Bayesian fits are passed the uncentred M^H (code `M = ctx$X * 2`), Z stays the centred matrix, and M^H beta = Z beta + 1 (2 p' beta) is correct from Z = M^H - 1 (2p)' (90-notation, Z row). M^H is the notation appendix's existing symbol (hybrid dosage matrix, N x m, 0/1/2, X = M^H/2); 04c:397 and 90:592 use it for the same matrix. The other `M` hits in the book (`M_r` in 04g:769-851, `M_HW`, `M_F_t` in 04c) are code objects or genotypic values, not this matrix; `M_e` (08b, 90:344/366) is the effective segment number and is in the notation table. No clash. Every `Z` occurrence in 08b (121-133, 217, 296, 685-688, 884-894) is the centred matrix.
- 08b-M2 -- CLOSED -- see M7.
- 08b-M7 -- CLOSED -- `08b:241-247` now says the roles (truth, prediction) are the same and what differs is the letter of the truth (g here, u in 07) and the origin of the prediction (fitted BLUP here, simulated there); matches `07-choosing-metrics.qmd:677-684` (u the true index, u-hat = scale(r u + sqrt(1-r^2) e), nominal r) and the 90 rows for u/u-hat, r, e/z/T.
- 08b-M8 -- CLOSED -- "The explanation proposed here is the rank bound ... tested only weakly below"; the rank chunk is called a statement on the training matrix (rank 33 = 2 x 17 - 1 asserted).
- 08b-M9 -- CLOSED -- the opening states that for an F1 of inbred lines the genotype is fixed by the parents but the dominance part is not the mean of parental values; agrees with 08b:191-194.
- 08b-M10 -- CLOSED -- the "usual way ... reported as approximate" wording is replaced by the plain statement that a different scalar gives different shrinkage and the routes disagree.
- 08b-M11 -- CLOSED -- the new `implied_w999_lam` column (w = 0.999, lambda x mean(diag G)): 40 draws (noise 101-140, split s + 1000), accuracy 0.9392, implied 0.8952 / w999 0.9271 / w999+lambda 0.9337; blend +0.0319 (72% of the gap 0.0441), lambda a further +0.0066, 0.0055 left. Per-draw s.d. of the two increments is 5.7e-5 and 8.0e-5 (s.e. 9e-6 and 1.3e-5), so the decomposition is not within Monte Carlo error. "Supplied lambda 11% too large": 1/mean(diag G) = 1.114, i.e. 11.4%, consistent with the text's `round(100 * (...))`.

## DISQUALIFYING FAILURES

None.

## NON-DISQUALIFYING OBSERVATIONS

- 08b-M12 `08b:463` ("In the direction measured, the reliability is conservative") -- after the D9 relabelling the sentence still names the reliability for what is the implied accuracy sqrt(mean r_i^2) set against the realised correlation (the sentence that precedes it distinguishes a mean reliability from a correlation). One residual use of the old name; the response said it had been reworded.
- 08b-M13 `08b:1006, 1019-1021` -- "no gap where the model is right" for BayesB at oligogenic h2 = 0.2 (-0.0009, s.e. 0.0018, 15 splits) reads a difference inside its error as absence of a difference, and "right" is an interpretation (BayesB is fitted at pi = 0.95, not at the nominal 0.9985); and the contrast "the opening of this section names beforehand" is a general statement about the regime the point-mass prior exists for, written after the sweep existed, not a registered contrast. Both are scoped by the s.e. given and by the exploratory label; wording only.
- Two non-disqualifying items; below the threshold of three.

## WHAT WAS VERIFIED

- Full chapter execution: all chunks, all `stopifnot` pass; `GBLUP accuracy (candidates)` 0.9596; opening split mean reliability 0.8017, implied 0.8954, realised 0.9596.
- CV table (20 replicates, noise 1-20, holdout 1001-1020): accuracy 0.9049 / 0.6654 / 0.1439, s.d. 0.0233 / 0.0682 / 0.1549; implied 0.8734 / 0.6442 / 0.1268; mean reliabilities 0.7629 / 0.4149 / 0.0161 (equal to the it2 values and to the writer's); gaps and s.e. as listed under D9.
- 8-contrast family: `Rscript` t.test on the cached CSV (independent of the chapter chunk) and the chapter's own `pv` agree to 3 significant figures on all eight (t = -2.05, -3.17, -0.80, +2.82, -0.88, -0.49, -0.83, +12.86); Bonferroni 0.00625; `pv < alpha_bonf` is TRUE only for B oligogenic 0.5.
- 40-draw decomposition (R40 and `ch40.R`): see M11. Share 0.724.
- sigma_u^2 = 1/mean(diag G) = 1.114; supplied lambda 11.4% too large.
- M^H / Z relation and the notation appendix rows: read in 90-notation (lines 18-65, 330-370, 590-592) and grepped in all chapters; u/u-hat/g wording against 07:665-700.
- Chapter claim that p-values are not reported in the prose for the +0.0014 BayesA cell: the p (0.0137) is printed by the chunk `genpred-paired-values`, not in the sentence; the text gives the effect and s.e. and does not claim significance for it.

## NOT VERIFIED

- Daetwyler et al. 2008 Eq. 1 as typeset and the symbol M_e (paper's n_G): declared unseen in the chapter, reported as "consistent with, not confirming"; non-decisive.
- Henderson 1975 as the source of the joint-density derivation: declared unverified in the text (refcheck it1: the paper is on BLUP under a selection model; the derivation is credited to earlier work); the chapter derives the equations itself and attributes nothing further to the paper. Burgueno et al. 2012 beyond the abstract; Habier et al. 2007 beyond the abstract; Metropolis-Hastings for BayesCpi in the bWGR paper. Non-decisive.
- Rendered HTML/Typst: `book/_freeze/08b-genomic-prediction/` was not re-rendered and is stale relative to the source; the numbers above are those of the re-execution of the source chapter.
- No `quant-refcheck` or `quant-continuity` report for iteration 3 was supplied; cross-chapter checks were made by grep and reading (90-notation, 04c, 04g, 07), not by that reviewer.
