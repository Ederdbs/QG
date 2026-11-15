# 05-genomic-era -- iteration 3 verdict (quant-head)

VERDICT: APPROVED

Scope: form pass (editor.md, editor-response.md) and it2 M13-M18 only. Git holds no it2 snapshot, so each edit was judged by reading it in book/05-genomic-era.qmd; the chapter code was purled and run end to end.

## PREVIOUS IDS
- 05-M13 -- CLOSED -- chunk `era-full-panel-20` (qmd:1044) exists and the Step 2 and Step 5 prose draw from it; counts reproduced (below).
- 05-M14 -- CLOSED -- Step 2 interpretation now scopes "no drift excess" to a plan optimised and read on the same full panel and points to @sec-era-step5 for the half-panel plan that does show an excess.
- 05-M15 -- CLOSED -- margins stated from chunk objects (neutral min R2 0.99935, margin 0.00035 over 0.999; managed max 0.99243, margin 0.00257 under 0.995), R2 not repeated over `fam_dev` families, thresholds set on the data they are read on; all three numbers reproduced.
- 05-M16 -- CLOSED -- "almost always" removed; Step 6 Warning sign says "by the algebra of this step", one selection on one draw, frequency across germplasm not measured.
- 05-M17 -- CLOSED -- the F_ST / Fst_Wright / F_BN distinction is stated in full once (Step 6, @tbl-era-s1-identity); the F_drift section keeps the time-versus-space contrast and points there. Redundancy only; stays below the three-failure threshold.
- 05-M18 -- CLOSED for 05 -- `wright1951` (references.bib:705) is cited by no chapter; the text says explicitly that no paper of Wright's is cited. Out of scope (bibliography); not a defect of the text. Author's "reported, not deleted" is accepted.

## EDITOR ITEMS (form pass)
- 05-E1..E7 -- accepted; each pointer checked in place (qmd:201, 407, 448-464, 980/988, 1341, 1472-1473, 1645/1651, 1798). Every @sec-/@tbl-/@eq- target of the chapter is defined (script over all book/*.qmd labels: undefined = none). New anchor `{#sec-era-fdrift}` at 448 resolves. "Calibrated above" -> @tbl-era-traj-drift-fit / @tbl-era-traj-managed-fit (1472) and "as above" -> @tbl-era-audit-null (1645) say what the sentence needs: the R2 values live in the first two, the z of the index row in the last. The truncation Ne_lines columns do live in @tbl-era-pools-usage (1798). The remaining "above/below" in the chapter are numeric comparisons or code comments (grep run), none positional.
- 05-E8 -- accepted (fixed). `tbl-era-inbred-check` and `tbl-era-base-zero` are one-row tables; the printed values equal the earlier console echoes of the chunks: 0 / 1 / 0.36169 / 0.36169 for the first (het_fraction_F1 == twice_GD_WI_hyb), 0 / 0 / 0 at twelve decimals for the second. The stopifnot()s are unchanged and pass. The caption of the second states that a 1e-17 value prints as 0.
- 05-E9 -- contested; RULING: accepted. A form matter owned by quant-editor. The reason given is substantive: with `fmt()` the 8.7e-18 residual of @tbl-era-identity-residual would print as 0 and the identity would no longer be visible. The captions state the digits. No rejection.
- 05-E10 -- accepted. Rows in 90-notation.qmd checked against the chapter: tilde-p_A, tilde-p_B, bar-p = (tilde-p_A + tilde-p_B)/2 under A2, equal to `colMeans(X[idx, ])` for hybrids coded 0/0.5/1 (matches qmd:255-263); G_ST = GD_BS/GD_T, Nei 1973, the F_ST of the chapter (asserted in-chunk: gd_partition F_ST == s1$Gst_Nei == fst_var); epsilon = ridge 0.01 in Meuwissen 2020, written alpha there (I read "a small value (alpha = 0.01) was added" in the PDF text), distinct from the `eps` of `freq_metrics()`; `m` row notes N_SNP. Accurate.
- 05-E11 -- accepted (see E1-E7 line).
- 05-E12 -- contested; RULING: accepted. The display equation is not cited by any @eq-, so an {#eq-} label has no consumer. Form; not a content defect.
- 05-E13 -- accepted ("Eq. 3" in the code comment is now @eq-era-cov).
- 05-E14 -- contested; RULING: accepted as a non-decisive pending render check. Legibility of three panels at 6.5 in cannot be judged without a render; no claim of the text depends on it. Carried to the batch render; not a rejection.

## DISQUALIFYING FAILURES
None.

## NON-DISQUALIFYING OBSERVATIONS
- 05-M17 residue -- inline hedging density in Steps 2, 4, 5 (author left it); clarity only, one observation.
- No new observations in the edits. Total non-disqualifying failures: below the threshold of three.

## WHAT WAS VERIFIED
- `knitr::purl("book/05-genomic-era.qmd", documentation = 0)` executed with Rscript from book/ (`source("_common.R")`): EXIT 0, 42 s, every stopifnot() passed (identities, R2 >= 0.999 neutral, R2 < 0.995 managed, F_ST triple identity, rank checks, `identical(r60, sels$random)`, fam_dev[,1] check, the new GD_WI_hyb identity on the full factorial).
- era-full-panel-20 (appended print to the purled script): z_full_drift range -1.606 to 1.491 (prose "-1.6 to 1.5"), above 0 on 11 of 20, above 2 on 0 of 20; z_full_hom -6.26 to -3.58; seed-1 z of Step 2 -0.67. All match the prose and my it2 values.
- aud20: managed half z above 0 on 19, above 2 on 16, min -0.77; audit half above 0 on 19, above 2 on 17, min -0.26. Matches the Step 5 prose ("19 of 20 (both halves), 16 and 17").
- tbl-era-seeds-z, tbl-era-audit-null, R2 fits: unchanged from it2 (-4.47/0.52/3.90/7/4/2; 5.37/2.28/4.10/6.38; 3.54, 3.86, 33.42 with 23.03-34.26; R2 0.99935 min neutral, 0.99243 managed). No number outside M13-M17 wording moved.
- Cross-reference script: no undefined @ target in the chapter.

## NOT VERIFIED
- fig-era-lens-divergence legibility (E14): needs the Typst render; non-decisive.
- No it2 snapshot, so "no change beyond M13-M17" rests on reproduction of every previously verified number plus reading the edited passages, not on a text diff.
- Whether book/_freeze, docs/ and book/downloads/05-genomic-era.R are current: not rendered or diffed here (batch render).
