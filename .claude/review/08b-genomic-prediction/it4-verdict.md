# 08b-genomic-prediction -- iteration 4, verdict

Scope: form-diff after editor.md (08b-E1..E8). `book/08b-genomic-prediction.qmd`, `book/90-notation.qmd` (Genomic prediction table).

## Part 1 -- first it4 pass (recorded afterwards from the reviewer brief; not saved at the time)

VERDICT: REJECTED -- by the accumulation rule only (four non-disqualifying items, three or more reject). No disqualifying failure; figure data identical; 08b-M12 and 08b-M13 closed.

NON-DISQUALIFYING OBSERVATIONS
- 08b-M14 `90-notation.qmd`, row V -- the note was wrong (said the prose never writes the matrix out; it defines V = G*_tt + I lambda).
- 08b-M15 `90-notation.qmd`, row mu / mu-hat -- no "not X" note against the other uses of mu in the book.
- 08b-M16 `08b`, `tbl-genpred-paired-values` -- p printed as 0.0000 for 3.8e-9.
- 08b-M17 `08b` -- SCA used before its expansion.

## Part 2 -- fix diff (narrow check)

VERDICT: APPROVED

PREVIOUS IDS
- 08b-M14 -- CLOSED -- 90:377 now reads "defined in the prose where the kernel form of @sec-genomic-prediction is checked, and `V` in that chunk"; 08b:359 defines V = G*_tt + I lambda in prose, and chunk `genpred-gblup-oracle` (08b:363-372) has `V <- Gs[tr, tr] + diag(lambda, ...)`. The meaning column ("in units of sigma_u^2") agrees with it. The anchor sec-genomic-prediction exists (08b:1).
- 08b-M15 -- CLOSED -- 90:376 names three clashing uses, each present: grand mean mu of H_ij (heterosis table, 90:233, meaning "grand mean of H_ij over the complete factorial", also 90:257); population mean mu of the usefulness criterion (selection table, 90:298, UC row "mu + i h sigma"; the heterosis row 90:233 itself says "in the UC of the selection table, a population mean"); mu_ab (pipeline table, 90:317/328, DH-family mean). The mu of `gblup()` is `fit$mu`, asserted equal to the GLS intercept at 08b:372.
- 08b-M16 -- CLOSED -- p column is text, "< 0.0001" for pv < 1e-4 (08b:1010); only B oligogenic 0.5 qualifies. Recomputed from `book/data/genomic_prediction_accuracy.csv` (15 paired splits, 14 d.f.): paired t.test BayesB - GBLUP, oligogenic h2 = 0.5, t = 12.8566, p = 3.841e-9; the chapter's own construction (mean diff / se, pt, 14 d.f.), run on the same file, gives the same: sprintf("%.3f") = 12.857, fmt_sci = 3.8 x 10^-9 (matches the new sentence, 08b:1017-1020). The other seven p print at four decimals (0.0598, 0.0068, 0.4349, 0.0137, 0.3957, 0.6306, 0.4228) and agree with t.test. No "0.0000" remains in the chapter.
- 08b-M17 -- CLOSED -- first use of SCA is 08b:58 ("no specific combining ability (SCA)"); no earlier occurrence of SCA or "combining ability" in the chapter (grep); 08b:161 expands GCA and uses "no SCA" after the expansion; later uses (178, 194, 1247) follow it. GCA is first used at 161 where it is expanded.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
None.

WHAT WAS VERIFIED
- t = 12.8566, p = 3.841e-9, 14 d.f., BayesB - GBLUP, oligogenic 0.5: `Rscript` t.test on the CSV; the eight-row table reproduced with the chapter's own chunk code (`fmt()` accepts the character p column; output as above).
- Eight p-values all below 1e-4 only for that cell.
- Cross-references in 90 (mu uses, V row) and in 08b (V definition, oracle chunk, SCA/GCA first uses) by reading and grep.

NOT VERIFIED
- Rendered HTML/Typst: `book/_freeze/08b-genomic-prediction/` not re-rendered; the text of the fix diff was checked from the source and a re-run of the table chunk, not from the render. Non-decisive (form).
