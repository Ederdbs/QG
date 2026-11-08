# 00-hybrid-programme -- response to the form review (editor.md)

Scope: 00-E3 to 00-E7. 00-E1, 00-E2 and 00-E8 are book-wide production items, left
alone; `book/typst-style.typ` not touched. Line numbers are of the working tree.

| ID | Status | Detail |
|---|---|---|
| 00-E3 | fixed | `00:682` `fmt(dr, 4)` -> `round(dr, 4)`. `dr` stays a matrix, so `df-print: kable` no longer applies. The comment on `00:681` now holds. The printed values are unchanged (see Verification). |
| 00-E4 | fixed in 00; owed -> 08 | `00:578-579`: $\theta_B$ -> $\theta_{AB}$, the appendix's symbol for between-pool coancestry. Same quantity: on two pools `theta_decompose()$theta_B` equals `mean(f[A, B])`, 0.518287 both ways (12 + 18 lines, 200 loci, seed 1), which is `theta_pools()`'s `theta_AB` at uniform weights. Owed -> 08: rename at `08:91,93` and `08:105`. Until then 00 and 08 print different symbols for this quantity. Also for 08: the clash is in the package too, `theta_decompose()$theta_B` (between pools) against `theta_pools()[["theta_B"]]` (within pool B), and the first is a weighted mean over pool pairs when there are more than two pools. `book/90-notation.qmd:205,226` needs no change for this item. |
| 00-E5 | owed -> 90 | No edit in 00: every symbol is defined where used, and `00:364` declares chapter-local symbols. Decision for 90 on the symbols shared across chapters: $\theta_w$, $G_{ST}$ (00, 05, 08) and $\bar y_{ij}$, $\bar e_{ij}$ (00, 04e). Used only in 00, so covered by `00:364` with no row needed: $F^{(t)}$, $\bar F^{(t)}$, $p_{b,k}$, $q_{b,k}$, $\theta_t$. $H_t$ of `00` needs no row either: the $H_t$ at `90:343` is declared local to @sec-sizing (`90:378`). |
| 00-E6 | fixed | `00:356-357`: "the mechanism above" -> "drift in closed pools, alone or with selection, as the cause of the divergence it reports". This names the two things the preceding paragraph sets out: drift alone in closed pools (the argument) and drift with selection (`run_cycles()`). The scope of the claim is unchanged, but the reading is mine, so the reviewer should check it. |
| 00-E7 | fixed | `00:239` "-> DH lines" -> "to DH lines"; `00:245` "A x B" -> "A × B", which matches the caption and keeps the source ASCII. `→` was not used for the arrow: it is outside the Latin-1 set of the `pdf()` device, which the downloaded script opens under `Rscript`. Drawn to PNG and SVG in a UTF-8 locale; PNG inspected, no overlap, boxes unchanged; `pdf()` accepts the $\times$ with `options(warn = 2)`. The `fig-alt` keeps "A x B": it is plain text and was not reported. |

## Verification

- `Rscript book/scripts/make_downloads.R` run from the worktree root, all scripts `ok`; `git status --short` has the same entries before and after.
- Chapter knit with plain `knitr::knit` against `pkgload::load_all()` of the worktree (namespace path checked), output to the scratchpad: no error, all `stopifnot()` pass.
- The pre-edit text was knit the same way and the two outputs diffed. The only differences are the five edits (and the scratch figure path), so no chunk output or inline number moved. Retained heterozygosity 0.597, 0.612, 0.346.
- `book/Rplots.pdf` absent; nothing to delete.
- No `quarto render`. That `df-print: kable` leaves the matrix as a console echo follows from its applying to data frames; it was not observed in a render. Check `hp-drift` at the close.
- Figure file names unchanged (`fig-hp-cycle-1`, `hp-drift`), so nothing is orphaned. `fig-hp-cycle` must be re-rendered at the close: the freeze and `docs/` still hold the old labels.
