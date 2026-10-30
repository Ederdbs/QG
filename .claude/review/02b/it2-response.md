# 02b-response -- response, iteration 2

## quant-writer

Chapter purled and sourced from book/ with _common.R: all stopifnot pass. `make_downloads.R` re-run. Not rendered.

| ID | Status | Note |
|---|---|---|
| 02b-D10 | fixed | Section "What `weights = NULL` is assuming" now states what the default does: criteria are predicted values ghat (`traits` of `build_ctx()`), standardised then equally weighted, i.e. a'ghat with implied economic weights a_j = 1/sd(ghat_j) (outer `scale()` is a positive affine map, ranking unchanged). General optimum b = Var(c)^-1 Cov(c, g') a stated; for multi-trait BLUP Cov(ghat, g') = Var(ghat) so b = a; fails in general for non-BLUP predictors (single-trait BLUPs of correlated traits). Smith-Hazel (@eq-response-smith-hazel) restricted to phenotypic records y = g + e, e independent of g. Chunk `response-sh-proportional` now asserts, with ghat = Sigma_G Sigma_P^-1 y: Var(ghat)^-1 Cov(ghat, g') a == a, and a'ghat == b_SH'y (t(K) a == index_smith_hazel(P, G, a)). "Not the index anyone intended" removed; closing paragraph says the b-vs-a gap is a property of a phenotypic index, and names what the default assumes and that the chapter tests neither. |
| 02b-M5 | fixed | Heading "The decomposition this book already had" -> "Combining ability as the additive part"; "@sec-heterosis-gca-sca already built" -> "is developed in @sec-heterosis-gca-sca, a later chapter; it is used here ahead of that derivation". |
| 02b-M6 | fixed | Shared-parent sentence removed; "Two limits apply" -> "One limit applies" (teaching scale only). |
| 02b-M7 | fixed | Pool-B allele: u_{Bk} -> v_k (pool-A u_k), declared as the u_{ik}, v_{jk} of @sec-heterosis-gca-sca without the line index; matches code `U`, `V`. Scalar g removed (:41 now "the genetic value of the hybrids is the vector X beta (`gv`)"), so only bold g remains, defined as the per-trait vector (not over individuals). 90-notation Response table: u_{Ak},u_{Bk} row -> u_k, v_k (code: rows of `sim$GL` (`U`, `V`)); new row g; ghat, distinguished from GCA g^A_i, g^B_j. |
