# 08b-genomic-prediction -- iteration 2, response

Chapter re-executed end to end by `knitr::knit` (wd `book/`, output in the scratchpad, 1.9 min); every `stopifnot` passed. No seed, parameter or
tolerance was changed. Scratch (`book/figure`) removed; `make_downloads.R` re-run (download script carries the new chunk lines).

| ID | Status | What was done |
|---|---|---|
| 08b-D9 | fixed | The CV table column is relabelled `implied` and defined in the caption as sqrt(mean r_i^2) over the candidates of the scheme; the code columns `r2/r1/r0` are renamed `imp2/imp1/imp0` so they cannot be read as r^2. The reliability paragraph is rewritten on the implied accuracy (0.873 / 0.644 / 0.127), the s.d. (0.001-0.003) is called that of the implied accuracies, "gap" = implied minus realised. The true mean reliabilities are printed from the chunk (`mean(cv[, "imp*"]^2)`: 0.763 / 0.415 / 0.016, equal to the reviewer's), so the 0.802 (mean reliability) vs 0.895 (implied) distinction of the opening split is the same one used here. Two further mentions (carry-the-reliabilities paragraph, limitations) and "the reliability is conservative" (opening of the section) reworded to implied accuracy. |
| 08b-D10 | fixed | "usual telling ... implies BayesA does not find the marker" deleted; the sentence now states only the measured fact (BayesA variance above the median in all 8 chains, factor unstable). `08b:574` "commonly written" replaced by: the formula is this chapter's own algebraic statement of the dependence on n h^2 / M_e; what was read in the paper is its text (product of heritability and records per independent segment); Eq. 1 as typeset and the symbol M_e (paper: n_G) not seen. No new citation added. |
| 08b-D5a | fixed | The count (8 = 2 methods x 4 cells) is declared and computed; two-sided paired t (14 d.f.), Bonferroni 0.05/8 = 0.0063. Computed p: BayesB oligogenic h2 0.5 < 0.0001 (passes; the only contrast the section names beforehand); BayesA polygenic 0.2 p = 0.0598, BayesA oligogenic 0.2 p = 0.0068 -- neither passes (the second is 0.0005 above the threshold). All other contrasts are labelled exploratory; "a small loss" and "BayesA lost ..." removed; the text says the sweep cannot say whether BayesA loses at h2 = 0.2, only that the sign is the same in both architectures. The BayesB "lost nothing when wrong" sentence replaced by the maximum |t| of the three null cells (0.9). The BayesA +0.0014 cell is reported with its p (0.0137, not below the threshold). |
| 08b-D7a | fixed | Uncentred 0/1/2 matrix is named M^H (the notation appendix's existing symbol, line 18) with M in the code; Z stays the centred matrix; the relation M^H beta = Z beta + 1 (2 p' beta) is written, the constant absorbed by the intercept. 90: the Z row's note now says the Bayesian fits are passed M^H. I did not attribute M to VanRaden (2008): his M is coded -1/0/1, not 0/1/2. |
| 08b-M7 | fixed | The "reverse of this role" sentence replaced: the roles are the same (truth vs prediction); what differs is the letter for the truth (g here, u in 07) and the origin of the prediction (fitted BLUP here, simulated there). |
| 08b-M8 | fixed | "It is the rank bound ... again" replaced by "The explanation proposed here is the rank bound, tested only weakly below"; the rank chunk is described as a statement about the training matrix, not about the accuracy collapse. |
| 08b-M9 | fixed | Opening sentence rewritten: the value is the mean of the parental values (additive); for a real F1 of inbred lines the genotype is fixed by the parents but the dominance part is not the mean of parental values and an additive model does not score it. |
| 08b-M10 | fixed | "usual way ... reported as approximate" replaced by the plain statement that a different scalar gives different shrinkage and the routes disagree. |
| 08b-M11 | fixed | The 40-draw chunk gets one more column (`implied_w999_lam`: w = 0.999 and lambda x mean(diag G)). Result in text: blend 0.032 (72% of the 0.044 gap), lambda a further 0.007, 0.006 left and not attributed. The reviewer's 0.009 on seeds 101-120 is the same quantity on 20 seeds. |
| 08b-M2 | fixed (via M7) | |

## Not done / limits

- Daetwyler Eq. 1 and the symbol M_e remain unchecked against the printed equation (declared).
- The Bonferroni family is the 8 contrasts of the table only; the other tests of the chapter (CV, pi sweep) are not folded into it.
- The 90 row for u-hat vs 07 and the sigma_u^2 / sigma_G^2 naming across chapters stay owed (outside 08b).
