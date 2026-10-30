## quant-writer

| ID | Status | Evidence / change |
|---|---|---|
| 02-M8 | fixed | 02-subdivided.qmd:572 "Under controlled pollination it is an inexpensive intervention in germplasm management" -> "It is an intervention in germplasm management": cost claim removed; the controlled-pollination condition is already stated in the callout above (02-D14). No new claim. make_downloads.R run; not rendered. |

## quant-writer (04c)

| ID | Status | Evidence / change |
|---|---|---|
| 04c-D1 | fixed | 04c-alphasimr-pipeline.qmd, prose-helper chunk after the contrast table (unlabelled, `echo: false`, no label changed): added `cov_t_crit <- qt(0.975, n_split_draws - 1)`, `cov_sig` (splits with `cov_se > cov_t_crit`), `cov_dom_0 = abs(2cov)/var(dom)` at split 0, `share_cov_0` / `share_nocov_0` (ratio of split-0 means with and without 2cov). Measured paragraph (~1388): "within X standard errors" -> largest abs(mean)/s.e. `r fmt(cov_se_max, 2)` against $t_{0.975,19}$ `r fmt(cov_t_crit, 2)`, both inline. Inferred paragraph (~1410): hard-coded "here that term is within ... at every split" replaced by an inline `if (length(cov_sig) == 0) "within the two-sided 5% point at every split" else "beyond ... at split = ..."`; adds that non-significance with 20 draws is not a bound on size; states abs(2cov) as a computed multiple of GCA_var_dom at split 0 and the split-0 ratio with/without the term (computed); states the verdict is render-dependent because runMacs2 is not seeded by set.seed. make_downloads.R run; not rendered. |
