# 08-pipeline-stages -- response to editor.md (08-E1 to 08-E11), quant-writer, form pass

Files touched: book/08-pipeline-stages.qmd, book/90-notation.qmd, book/05b-heterosis-dominance.qmd (one word, M12).
R/ not touched. No number, assertion or seed changed. Knit-check (knitr::knit, no Quarto render) of 08 and 90
run into the scratchpad before and after: the only differences in the output are the ones listed below; every
inline number is identical. book/figure and book/Rplots.pdf not created. `make_downloads.R` re-run.

## ID -> status

| ID | Status | What was done |
|---|---|---|
| 08-E1 | owed (render batch) | Width of tbl-ledger (9 columns), tbl-endpoints (8), tbl-trap3-sweep (9) and tbl-s1-panel (11) at Typst A4 cannot be seen without a render. Headers not shortened: the prose looks columns up by name (`pick(..., "loss % (mean)")`), and renaming them is chunk logic for a change nobody has seen to be needed. Check in the PDF after the render batch. |
| 08-E2 | fixed | `s3-loss` split into `tbl-s3-loss` (the `loss_vs_resampling()` vector as a one-row table) and `tbl-s3-pools` (`table(pool[top])` as a table), both labelled, captioned and cited before the chunk's output is discussed. `sigma-uc`: the printed two-element vector is dropped (both values were already inline, `sel_intensity(0.05)` and `sig_rel_err`), and the head table is now `tbl-sigma-uc`, labelled, captioned, cited before the chunk, wrapped in `knitr::kable()`. No claim added. |
| 08-E3 | fixed | Named vectors printed raw in `dh-identities`, `s4-usage`, `s4-he`, `trap5-greedy`, `trap5-repair`, `trap5-worlds` are now two-column tables through a local helper `vtab()` (setup chunk: one `knitr::kable(data.frame(quantity, value))`, each value formatted on its own so that a deviation is not shown as 0 by a shared format). Labels `tbl-dh-identities`, `tbl-s4-usage`, `tbl-s4-he`, `tbl-trap5-greedy`, `tbl-trap5-repair`, `tbl-trap5-worlds`; captions written from the code; each cited in the sentence that introduces the chunk. `trap1`: the vector was a single scalar, now quoted inline after the chunk (`r sprintf("%.0e", trap1_dev)`, 2e-16, asserted below 1e-12 as before). The `stopifnot()` lines and all values are unchanged. The tbl-s4-he caption names the columns as the code returns them (`pool_balance1`, `pool_balance2`: `pool_balance()` returns an unnamed vector, so `c()` numbers it; order of first appearance in `pool`). |
| 08-E4 | fixed | fig-theta-by-size: `xlab = "set size (number of lines)"`, `ylab = expression("mean group coancestry " * theta)`, legend entry now `"mean " * theta * " of a random set"` as a plotmath symbol. Rendered in the scratchpad and looked at: legible, no overlap. Caption unchanged (it already says "number of lines"). |
| 08-E5 | fixed | New table "Pipeline stages (@sec-stages)" in book/90-notation.qmd (before "Genomic prediction"): $\varpi_p$, $\theta_{pq}$, $\theta_T$ (= the $\bar f$ of the partition), $\theta_w$ (= the $\tilde f$), $F^{btw}_{ST}$, $C$, $n_c$, $f_c$, $n_{DH}$, $\bar F_{cc'}$, $a$, $b$, $i$, $h$, $q$, $\mu_{ab}$, $UC_{ab}$, each with its collision named. Renamed in the chapter, being the chapter's own symbols: $w_p \to \varpi_p$ (collided with the line-usage weights $\mathbf{w}$ of the same section; used nowhere else in the book, grep), $D \to n_{DH}$ (collided with $D_{ij}$, $\mathbf{D}$, $D_G$, $D_A$ and with `n` of $\mathbf{w}$ in the notation). The index clash of $i$: the intensity $i$ is the book's (response table), so the line indices of the cross in eq-stages-sigma-dh and in $UC$ became $a$, $b$ ($\sigma^2_{DH(a,b)}$, $x_{ak}$, $\mu_{ab}$, $UC_{ab}$) and the text says so; identities (a) to (c) keep $(i,j)$, $(k,l)$, which are line indices and do not meet the intensity. $h$ and $q$ kept (the code argument is `h`; `sel_intensity(q)`) and declared in the notation with the clash named. $n_c$ and $C$ kept: they meet only symbols of other parts (mating-design budget, response-table matrix $\mathbf{C}$), declared as such. |
| 08-E6 | no action | As in the editor's note. |
| 08-E7 | fixed (unchanged on purpose) | "Schnell and Utz (1975)" stays hand-typed; the chapter already says it is not in the book's bibliography and was not checked. No bib entry invented. |
| 08-E8 | owed (render batch) | Axes, panel labels and font sizes of the cached `metric_pitfalls.png` and `pipeline_loss.png` at Typst width: needs the PDF. |
| 08-E9 | fixed | "optimal contribution selection (OCS)" at its single use (S4, @tbl-hp-stages sentence). |
| 08-E10 | fixed | tbl-trap4 builds `strat`/`pooled` unrounded and prints through `fmt(., 4)`. The inline percentages computed from `strat[["R2"]]` and `pooled[["R2"]]` are identical to the previous render (checked in the diff of the knit output: 1.1 %, 4.8 %, 33.2 %). Display only: `cor` and `R2` now show 4 decimals instead of 3. |
| 08-E11 / M12 | fixed | book/05b-heterosis-dominance.qmd: "That section shows that" -> "That section states that". Nothing else touched in that paragraph (the closing sentence "@tbl-het-sweep and @fig-heterosis-sweep are that evidence" is left as it was; M12 asked for the verb only). |

## Prose / caption wording changes made in this pass (for the quant-advice diff check)

book/08-pipeline-stages.qmd
- W1 (Trap 1, after chunk): the printed `c(max_deviation = ...)` replaced by the sentence "The largest absolute deviation over the $L^2$ entries is `r sprintf("%.0e", trap1_dev)` (asserted below $10^{-12}$)."
- W2 (S1, partition and Trap 2): $w_p$, $w_A = w_B$ -> $\varpi_p$, $\varpi_A = \varpi_B$ (5 places, incl. eq-stages-partition).
- W3 (identity (c) and its derivation): $D$ -> $n_{DH}$ (6 places, incl. eq-stages-dh-theta); added "The chunk below checks (a) to (c) numerically (@tbl-dh-identities)."
- W4 (progeny variance): eq-stages-sigma-dh indices $(i,j)$, $x_{ik}$, $x_{jk}$ -> $(a,b)$, $x_{ak}$, $x_{bk}$; the usefulness-criterion sentence now reads "of the cross of lines $a$ and $b$ is $UC_{ab} = \mu_{ab} + i\,h\,\sigma_{DH(a,b)}$: $\mu_{ab}$ the mean ..., $i$ the selection intensity of the selected fraction $q$ (@eq-response-breeders of @sec-response; $i$ is not a line index, the lines of a cross are indexed $a$, $b$ here)".
- W5 added before the sigma-uc chunk: "The chunk below computes $\sigma_{DH}$ and $UC$ for the crosses of the previous chunk and checks $\sigma_{DH}$ against gene dropping (@tbl-sigma-uc)."
- W6 (S3): "(one world, one set of 300 resamples)" -> "(one world, one set of 300 resamples; @tbl-s3-loss and @tbl-s3-pools)".
- W7 (Trap 5): "The chunk runs that rule:" -> "... (@tbl-trap5-greedy):"; "...and in that case it warns." + "The chunk runs it once (@tbl-trap5-repair):"; "...standardised additive index):" -> "...; @tbl-trap5-worlds):".
- W8 (S4): "(@eq-collapse-theta)." + "The chunk checks it on 100 hybrids (@tbl-s4-usage):"; "coancestry route:" -> "coancestry route (@tbl-s4-he):"; "the collapse, OCS, combinatorial" -> "the collapse, optimal contribution selection (OCS), combinatorial".
- Captions new (from code only): tbl-dh-identities, tbl-sigma-uc, tbl-s3-loss, tbl-s3-pools, tbl-trap5-greedy, tbl-trap5-repair, tbl-trap5-worlds, tbl-s4-usage, tbl-s4-he. Figure: axis labels and legend (E4), caption untouched.

book/90-notation.qmd: new subsection and table "Pipeline stages (@sec-stages)", 11 rows (E5).

book/05b-heterosis-dominance.qmd: "shows" -> "states" (one word).

## Owed for the render batch
- 08-E1 and 08-E8 (Typst widths of the four wide tables and of the two cached figures).
- New table labels (`tbl-dh-identities`, `tbl-sigma-uc`, `tbl-s3-loss`, `tbl-s3-pools`, `tbl-trap5-greedy`, `tbl-trap5-repair`, `tbl-trap5-worlds`, `tbl-s4-usage`, `tbl-s4-he`) and the 90-notation table: Quarto cross-reference resolution is not checked by knitr; confirm no "?@tbl-" in the rendered HTML.
- The labelled chunks `tbl-trap3-sweep`, `tbl-s1-panel`, `tbl-trap5-within-pool` (previous pass) still rely on `df-print: kable`; the nine new ones call `knitr::kable()` explicitly. Not changed here.
- Orphaned freeze/docs figures: the unlabelled figure chunk numbering of 08 is unchanged (no figure chunk added or removed); stale `_freeze` and `docs/` for 08, 90 and 05b await the batch, as before (08-M11).
