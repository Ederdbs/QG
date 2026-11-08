# Editor response: book/03-simulating-crosses.qmd (form findings)

| ID | Status | Note |
|---|---|---|
| 03-E1 | fixed | Opening block split into three paragraphs: recap / differences from `simulate_pools()` (trait model, RNG stream, same `X`) / coincidence with @sec-response's chunk and the clamping. One word changed for the split: "These values coincide" -> "The `book_cfg` values coincide" (the antecedent was in the previous paragraph). No claim changed. |
| 03-E2 | fixed | Paragraph after tbl-divergence-trade split at "The $GD_{BS}$ gain is..." and at "The `stopifnot()` in the code...". Text unchanged. |
| 03-E3 | fixed | "(its own parameterisation was not read for this chapter)" replaced by "; the book attributes to @balding1995 no particular parameterisation." The statement is now about what the book specifies and attributes, consistent with the existing "this book's own specification ... not quoted from that paper". Also the vague sentence at l.45-48 now points to its sections: "how divergent the pools are (@sec-sim-divergence), how the index is constructed (@sec-sim-traits)". |
| 03-E4 | owed -> 90 | `\bar f^{L}_{AB}` (mean line coancestry between a pool-A and a pool-B line, written `between_pool_f` in code) and `q^{*}_k = 1 - p^{*}_k` are defined in chapter 03 but have no row in `book/90-notation.qmd`. Not edited here. |
| 03-E5 | fixed (no change) / owed -> quant-Rwrite | Captions left unchanged. If quant-Rwrite adds the replicate band to fig-divergence-het (E7), the `cap_het` text "one simulated pair of pools per point" must be changed to say what the band shows (replicate mean and s.d. over seeds 1 to 200 at the two ends). That caption edit is quant-Rwrite's, together with the chunk edit. |
| 03-E6 | fixed | Callout body: lead-in kept as a paragraph, then four bullets (*The optimum*, *The heuristics*, *Scope*, *Additive only*). Sentences moved verbatim; only the lead-in "GEBVs" expansion and the bullet labels are new. No claim changed. |
| 03-E7 | owed -> quant-Rwrite | Chunk untouched. |
| 03-E8 | owed -> quant-Rwrite | Chunk untouched. |
| 03-E9 | owed -> quant-Rwrite | Chunk untouched. |

Checks run: `Rscript book/scripts/make_downloads.R` (all chapters purl; `book/downloads/03-simulating-crosses.R` regenerated). Chapter 03 purled to a temp dir and sourced from `book/` against `pkgload::load_all("..")`: exit 0, every `stopifnot()` passes (the only message is the expected "ambiguous coding" warning of the coding-ambiguous demonstration). `book/Rplots.pdf` deleted; `book/figure/` did not exist. No render run. Not committed.

## Code-side form findings (quant-Rwrite)

| ID | Status | Note |
|---|---|---|
| 03-E5 (caption part) | fixed | `cap_het` and `alt_het` rewritten to say what is plotted: single draws (circles, line), mean and s.d. over `n_rep` replicate pairs of pools (seeds 1 to `n_rep`) at the two ends (squares, bars), the dashed expectation, and that the vertical axis is zoomed. All numbers (`n_rep`, seeds, `het_exp`, replicate means and s.d.) come from code. |
| 03-E7 | fixed | The replicate chunk `divergence-trade-replicates` moved, unchanged, before the figure chunk (its `rep_lo`/`rep_hi` are now available to the figure and its caption); the 200 draws are the same objects, not recomputed. The figure adds the replicate mean +/- s.d. at the two ends (open squares, bars) and a `legend()` with the single-draw line, the replicate summary and the dashed expectation. Vertical axis changed from 0-1 to the range of the draws (+25%): on 0-1 the bars (s.d. 0.003 to 0.006) are invisible; caption and fig-alt say so. `het_exp` definition moved to the caption chunk (same expression). Chunk labels unchanged. |
| 03-E8 | fixed | tbl-ctx-check and tbl-gd-baseline now go through `knitr::kable(..., align = c("l", "r"))`; the TeX span `$a \times 10^{b}$` stays in the cell. A scratch Quarto render of such a table to HTML (MathJax span) and Typst (PDF) gave the typeset number in both. Values unchanged. |
| 03-E9 | fixed | tbl-divergence-grid headers via `col.names`: $F_{BN}$, $\bar f^{L}_{AB}$, $\tilde f$, het. fraction, $GD_{WS}$, $GD_{BS}$, $GD_T$; `cap_grid` rewritten from code names to those symbols. Rendered in HTML and Typst in the same scratch test. Values unchanged. |

Checks: chapter knitted (knitr, cwd `book/`) before and after; every `stopifnot()` passes; the diff of the two knits shows no change in any printed value or inline number -- only the moved chunk, the new plotting lines, the three tables (console print -> kable, same numbers), caption and alt text. `make_downloads.R` rerun. Stray `book/Rplots.pdf` deleted; no `book/figure/`. No render of `docs/`; not committed.
