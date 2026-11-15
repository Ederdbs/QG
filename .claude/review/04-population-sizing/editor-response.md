
## Editor findings assigned to quant-writer (form only, no number or claim changed; not rendered)

| ID | Status | Note |
|---|---|---|
| 04-E1 | fixed | SA3 chunk now `output: false`; chromosomes, markers, total cM and Morgans are inline `r` in the prose. |
| 04-E2 | fixed | `f2_distorters` printed via `knitr::kable()`, label `tbl-sizing-distorters`, caption, cited in SA5. |
| 04-E3 | fixed | `fig-sizing-multilocus` legend moved `topright` -> `bottomright` (the k curves are at P near 1 for large N). Not seen in a rendered PNG (no render). |
| 04-E4 | not assigned | Not in the task list; unchanged. Still to be checked in the rendered PNG. |
| 04-E5 | fixed | `tbl-sizing-bridge` split: identities (n_F2, D, theta, GD, Ns, fixed, bound) and new `tbl-sizing-bridge-subsets` (n_F2, GD_random (s.d.), GD_greedy, GD, bound); cited in the caption and in the "What the panel's GD limits" paragraph. Same values, same `fmt(., 4)`. |
| 04-E6 | not assigned | Needs the Typst PDF; unchanged. |
| 04-E7 | fixed | Replicate-count column is `n_rep` in `tbl-sizing-verify-junctions`, `tbl-sizing-ssd-grid`, `tbl-sizing-bulk-vs-ssd` (captions updated); s.e. column/caption labelled "s.e." in `tbl-sizing-verify-het` and `tbl-sizing-steps` via `col.names`. `SE(p_hat)` kept: it names the standard error of the estimator, a different quantity. |
| 04-E8 | fixed (part) | `n_{rep}` added to the "Population sizing" table of `90-notation.qmd`. `n_{final}` appears only in code and inline `r` expressions, never as a symbol in prose, so not added; `c` is a column header of `tbl-sizing-f4-identities` defined in its caption; `m` left as is. |
| 04-E9 | contested | Left as `callout-warning`, as the editor did: it warns of a trap that yields a wrong field-area number. |
| 04-E10 | contested | `tbl-sizing-saturation` already uses `fmt()` (via `fmt_ms`); the remaining differing digits (4/3/4) are per-quantity precisions, changing them changes displayed numbers. `tbl-sizing-f1`: `fmt()` rounds to decimals, so n = 20 rows (1000 * 0.5^20 = 0.00095) would show 0.001 and 0, losing the three-significant-digit rule its caption states; `formatC(digits = 3, format = "g")` kept. |

Renamed/removed labels: none. New labels: `tbl-sizing-distorters`, `tbl-sizing-bridge-subsets` (tables, no figure files). Downloads regenerated.
