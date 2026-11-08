# 05b iteration 4 -- response

| ID | Status | Change |
|---|---|---|
| 05b-M28 | fixed | Caption of `tbl-het-step7-spread`: "it underflows to 0 in the F distribution" replaced by the actual mechanism. Checked by running it: `pf(1.654^2, 999, 999, lower.tail = FALSE)` = 4.751259e-55 (representable); `pf(1.654^2, 999, 999) == 1` is TRUE and `1 - pf(...)` is 0, so `var.test`'s 2*min(P, 1-P) is exactly 0. The `< 2e-16` bound is unchanged. No code touched. Note: the code comment at ~qmd:1998 ("a p that underflows prints as the floor") carries the same loose wording; left because the instruction was not to change code. |
| 05b-M29 | fixed | fig-alt of `fig-heterosis-sweep`: "falls by the same amount" -> "falls by nearly the same amount (the two changes differ by a few per cent in this draw), and their total stays nearly flat". |
| 05b-M30 | fixed | The four positional references (qmd:595, 1068, 1471, 1597) now name the premise (marker panel = dominance loci; fully inbred parents) and point to @sec-heterosis-premises. No number or chunk changed. |

`Rscript book/scripts/make_downloads.R` run; `downloads/05b-heterosis-dominance.R` sourced under `pkgload::load_all` (pdf(NULL), temp dir): runs to the end, no error. No `book/Rplots.pdf` or `book/figure/`.
