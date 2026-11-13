# 04c-alphasimr-pipeline -- editor response (quant-writer, form pass 2)

| ID | Status | What changed |
|---|---|---|
| 04c-E4 | fixed | Step 8 "What `split` does": GD_T = 1 - fbar, GD_WI / GD_BI / GD_BS defined in words and tied to @eq-gd-partition, @tbl-gd-partition and @eq-ratio-identities of @sec-subdivided (not re-derived); F_ST = GD_BS / GD_T stated as the statistic of @eq-f-stats, not the between-referenced one. No second labelled equation added: @eq-gd-partition already is the labelled partition, a duplicate would give the book two. |
| 04c-E5 | fixed | Prose "5 %" -> "5 percent" (five places); the code comment `5%` left. Prose style is now "percent" throughout. |
| 04c-E6 | contested | Table headers are code names in the book's convention; adding units to headers of tbl-alphasimr-lottery / -dd would change the `fmt()` column names the chunks index by (label stability). Units stay in the captions (already "trait units"). |
| 04c-E7 | fixed | "a later chapter, Optimisation" (2x) dropped, plain @sec-combinatorial; "Two earlier chapters" -> "@sec-heterosis and @sec-mating". |
| 04c-M12 | fixed | Sweep multiplicity declared in a "Multiplicity of the sweep" paragraph: 7 tests (2 contrasts of tbl-alphasimr-contrast, GCA_var_dom contrast, covariance term at 4 splits; `n_tests_sweep`, `t_bonf_sweep` computed in the helper chunk). "Conservative" removed for the unadjusted 2.09 (permissive for a verdict of a difference, strict for "not distinguishable"). Bonferroni point 3.01 reported with the count beyond it computed inline (2 of 7 in my check knit, the same 2 as at 2.09). Ascertainment bookkeeping and `gca_only()` decomposition and F_ST/GD_BS/GD_T movements declared descriptive/exploratory, untested. Earlier verdict sentences unchanged. |
| 04c-M13 | fixed | cap_pipeline: "one further founder draw" -> "one founder draw (that call uses the same seed as replicate 1; whether it returns the same founders was not established, Step 1)". |

Check: `knitr::knit()` of the edited chapter ran to the end without error (about 2.5 min); no existing number was edited. The new inline numbers (7 tests, 3.01, 2 of 7) are render-dependent, the wording is conditional only in the counts. No Quarto render run; docs/ and _freeze stay stale (M17).

| ID | Status | What changed |
|---|---|---|
| 04c-D9 | fixed | Step 8 "What `split` does": $\bar f$ redefined as "the census-weighted mean molecular coancestry over all pairs of the founder individuals of the two pools" (`ct_partition(geno, pool)` on `pullSegSiteGeno(c(pop_A, pop_B))`, default `weights = "census"`, `f_bar = w' f w`), notation of @sec-ct-notation; "pooled hybrids" removed, "no hybrid enters" stated. Now consistent with GD_WI as half the observed heterozygosity of a plant (founders are outbred). No other text touched; no render. |
