# 03-simulating-crosses -- editor, iteration 1

## 1. Edits applied (book/03-simulating-crosses.qmd)
Figures
- `fig-divergence-het` (F1 heterozygous fraction vs F_BN): label added; cited before it with @fig-divergence-het; fig-alt expanded (axes, range, dashed expectation). Caption kept (already self-contained).
- `fig-candidate-pool`: label added; new intro sentence citing @fig-candidate-pool; caption rewritten to stand alone (book scale 25+25 lines, 625 hybrids, 2000 markers; 400 random subsets of 60; s.d. units; red line = whole-pool GD); fig-alt rewritten.
Tables
- Contract table: `#| label: tbl-stage1-contract` + `tbl-cap` (caption moved out of the kable call, N/m/L defined); cited with @tbl-stage1-contract before it.
- `fmt(d)`: `#| label: tbl-divergence-grid` + `tbl-cap` defining every column; cited before it alongside @fig-divergence-het.
Equations
- Balding-Nichols Beta draw labelled `{#eq-balding-nichols}`, cited in "The Beta of @eq-balding-nichols has mean".
Callouts
- "What this simulation deliberately does not model": callout-note -> callout-important (design decision: index treated as given).
Text
- GEBV expanded at first use; GD_WS introduced as "the within-subpopulation gene diversity".
- `Rscript book/scripts/make_downloads.R` run (book/downloads/03-simulating-crosses.R regenerated).

## 2. Findings passed on
- 03-E1 book/03-simulating-crosses.qmd:54-60 -- $p^{*}_k$, $p_{Ak}$, $p_{Bk}$ are not in book/90-notation.qmd (F_BN and F_ST are, and are used correctly here). Add to notation or confirm.
- 03-E2 book/03-simulating-crosses.qmd (`divergence-trade`, `coding-ambiguous`, the `c(N=..., sum_G=...)` chunk, the final `c(GD_population=...)` chunk, `round(cor(traits),3)`) -- raw console vectors/matrices stand in for result tables; the numbers the prose quotes come from them. Convert to labelled `tbl-` tables via fmt() or echo them inline (code change: quant-Rwrite).
- 03-E3 book/03-simulating-crosses.qmd (fig-candidate-pool chunk, `abline(..., col = "#b2182b")`) -- red is outside the book palette; the prose ("The red line") depends on it. Decide palette colour and update prose together (code change).
- 03-E4 book/03-simulating-crosses.qmd (fig-candidate-pool, left panel) -- index histogram has no reference mark and the caption cannot say how the index is weighted across the 3 traits from the chunk alone; quant-writer to state the weighting (or cite where it is defined) in the caption.
- 03-E5 book/03-simulating-crosses.qmd:~158 ("The chunk above asserts the identity") -- reference to code by position; acceptable for code but would be firmer naming the assertion; optional rewording for quant-writer.

## 3. Orphaned figure files (delete after render)
book/_freeze/03-simulating-crosses/figure-html/unnamed-chunk-5-1.png
book/_freeze/03-simulating-crosses/figure-html/unnamed-chunk-5-1 2.png
book/_freeze/03-simulating-crosses/figure-html/unnamed-chunk-15-1.png
book/_freeze/03-simulating-crosses/figure-typst/unnamed-chunk-5-1.svg
book/_freeze/03-simulating-crosses/figure-typst/unnamed-chunk-15-1.svg
docs/03-simulating-crosses_files/figure-html/unnamed-chunk-5-1.png
docs/03-simulating-crosses_files/figure-html/unnamed-chunk-5-1 2.png ... unnamed-chunk-5-1 12.png (11 duplicates)
docs/03-simulating-crosses_files/figure-html/unnamed-chunk-15-1.png
(No unnamed figure chunk remains in the chapter, so every unnamed-chunk-* file in these two directories is orphaned.)
