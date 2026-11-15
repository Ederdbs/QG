# 08b-genomic-prediction -- response to editor.md (08b-E1..E8)

Files touched: `book/08b-genomic-prediction.qmd`, `book/90-notation.qmd` (Genomic prediction table, five rows). No number in the text changed; knit-checked (chunks run clean, all inline values as before). Not rendered to `docs/`; `book/_freeze/08b-genomic-prediction/` is stale until the render batch. `make_downloads.R` re-run; scratch removed.

| ID | status | what was done |
|---|---|---|
| 08b-E1 | fixed | `fig-genpred-selection`: `xlab = "marker index"`; `ylab` = "posterior inclusion probability" (left), "per-marker variance" (right), passed as a third element of the panel list. Knit-checked: left label does not clip at 6.5 x 4 in, `mar = c(4,4,2,1)`. |
| 08b-E2 | fixed | `fig-genpred-accuracy`: legend (GBLUP, BayesA, BayesB, three greys) added in the panel; the 12 two-line `method.arch\nh2=` tick labels replaced by four group labels (`arch\nh2=..`) centred under each triple (`boxplot(plot = FALSE)` + `bxp()` + `axis()`), `mar = c(4,4,1,1)`. Caption: "(legend in the panel)" appended. **Defect found and fixed**: the original `boxplot(accuracy ~ method + grp)` ordered `method` alphabetically (BayesA, BayesB, GBLUP), so the shades `grey85/65/45` were BayesA/BayesB/GBLUP, contradicting the caption's "GBLUP, BayesA, BayesB in that order". `sub$method` is now a factor with levels GBLUP, BayesA, BayesB, so the figure matches the caption. The boxes now sit in a different order within each group than in the shipped figure; the data plotted are unchanged. |
| 08b-E3 | fixed | The five raw-console chunks print as tables, same values, no new claim: `tbl-genpred-seeds` (was `genpred-seeds`), `tbl-genpred-bayes-seeds`, `tbl-genpred-paired-values`, `tbl-genpred-cpi`, `tbl-genpred-errstructure`; each has `#| label: tbl-`, `#| tbl-cap:`, `knitr::kable(fmt(...))` and a forward `@tbl-` citation. Matrices transposed (quantities as rows, mean/sd or min/median/max as columns) so they fit the page. |
| 08b-E4 | owed (render batch) | Typst widths of `tbl-genpred-paired` (8 columns) and `tbl-genpred-cv` (7 columns) to be checked at render. Headers not shortened (the prose looks `BayesA - GBLUP`, `se A`, etc. up by name). |
| 08b-E5 | fixed (no change) | grep of `book/*.qmd`: limitation boxes use `callout-note` (02-subdivided "What this does and does not license", 02b-response "What the lineage does and does not show", 07-choosing-metrics "A caveat on transfer"); 03-simulating-crosses uses `callout-important` for the same function, the one outlier. `callout-note` kept for "What this chapter still does not model". |
| 08b-E6 | fixed | `book/90-notation.qmd`, Genomic prediction table: added rows $\sigma^2_\beta$, $\sigma^2_k$, $\lambda_\beta$, $\mu$/$\hat\mu$, $\mathbf{V}$ (meaning and note; relations to @eq-genpred-var-g, @eq-genpred-identity). $\mathbf{C}$/$\mathbf{C}^{uu}$ left as in the PEV row. |
| 08b-E7 | no action | Render owed. |
| 08b-E8 | no action | Book-wide decision. |

## Prose / caption wording changes (08b)

| # | location | before | after |
|---|---|---|---|
| V1 | fig-genpred-accuracy caption | "... in that order within each group." | "... within each group (legend in the panel)." |
| V2 | text before `tbl-genpred-seeds` | (none) | added sentence: "@tbl-genpred-seeds gives the mean and standard deviation of each quantity over the 40 draws." |
| V3 | before `tbl-genpred-bayes-seeds` | "... with eight different seeds:" | "... with eight different seeds (@tbl-genpred-bayes-seeds):" |
| V4 | before the accuracy sweep chunk | "... so the comparisons below are paired (@tbl-genpred-paired, @fig-genpred-accuracy)." | "... (@tbl-genpred-paired, @fig-genpred-accuracy; the paired $t$ statistics and $p$-values of the eight contrasts are in @tbl-genpred-paired-values)." |
| V5 | before `tbl-genpred-cpi` | "... on the oligogenic trait:" | "... on the oligogenic trait (@tbl-genpred-cpi):" |
| V6 | before `tbl-genpred-errstructure` | "... keeps the dependence among pairs):" | "... keeps the dependence among pairs; @tbl-genpred-errstructure):" |
| V7 | five new `tbl-cap:` strings | -- | new captions describing, from the chunk code, what each table contains (seeds, statistic definitions, "$n - 1$ degrees of freedom" for the paired $t$ test, not a typed 14). |
| V8 | `90-notation.qmd` | -- | five rows (E6). |

## Iteration 4 (it4-verdict: 08b-M14..M17)

Files touched: `book/08b-genomic-prediction.qmd`, `book/90-notation.qmd`. No number changed; knit-checked into the scratchpad (chunks run clean; `book/_freeze/08b-genomic-prediction/` restored to HEAD, still stale until the render batch). `make_downloads.R` re-run; no scratch left (`book/figure`, `Rplots.pdf` absent).

| ID | status | what was done |
|---|---|---|
| 08b-M14 | fixed | `90-notation.qmd`, row $\mathbf{V}$: note "code only; the prose writes the sum out" replaced by "defined in the prose where the kernel form of @sec-genomic-prediction is checked, and `V` in that chunk" (08b defines $\mathbf{V} = \mathbf{G}^*_{tt} + \mathbf{I}\lambda$ in prose and the chunk `genpred-gblup-oracle` has `V`). |
| 08b-M15 | fixed | `90-notation.qmd`, row $\mu$, $\hat\mu$: note now "the `mu` of `gblup()`; **not** the grand mean $\mu$ of $H_{ij}$ (heterosis table), the population mean $\mu$ of the usefulness criterion (selection table) or $\mu_{ab}$ (DH-family mean)". |
| 08b-M16 | fixed | `tbl-genpred-paired-values`: column p is now text, `< 0.0001` when `pv < 1e-4`, else 4 decimals (BayesB, oligogenic, 0.5 prints `< 0.0001`; the other seven unchanged). Prose after `tbl-genpred-paired` gains one sentence with inline values from the chunk: paired $t$ = 12.857 (`sprintf("%.3f", tt[[...]])`), $p = 3.8 \times 10^{-9}$ (`fmt_sci(pv[[...]])`); confirmed in the rendered HTML. |
| 08b-M17 | fixed | First use (assumptions paragraph) now "no specific combining ability (SCA)"; the later expansion before `genpred-linear-identity` reduced to "no SCA left over". |
