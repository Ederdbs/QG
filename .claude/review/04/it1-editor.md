# 04-population-sizing -- iteration 1, production editor (form pass)

File edited: book/04-population-sizing.qmd (chunk options, captions, cross-refs, callout type, acronyms only).
`Rscript book/scripts/make_downloads.R` run: book/downloads/04-population-sizing.R regenerated. Not rendered.

## 1. Edits applied

### Figures
- fig-sizing-diversity (l. 324): caption rewritten to stand alone -- D dimensionless, x = F2 plants, the five P6 schemes with beta = 6 and 15% attrition, 10 to 40 replicates per N (pointer to @tbl-sizing-ssd-grid for counts), "no error bars are drawn", cached grid source (`regenerate.R f2size`, 2 cM map, distortion active, seed 20260828), dashed curve defined. fig-alt rewritten to describe the content, not repeat the title.
- fig-sizing-ancestry (l. 372): caption now states axes, chromosome boundaries, that each curve is ONE live population (seeds 6, 7) with no error band, the 0.5 reference line, the dotted red distorter lines.
- fig-sizing-multilocus (l. 534): caption states k = 3, 5, 8, 10, 2 cM map, and that the grid has ONE population per N (replicate 1, seed 20260828): no replicates, no error bars, each point a proportion over 300 locus sets, wiggle = between-population variance. fig-alt rewritten from the data (k = 3: 0.72 -> 1; k = 5 -> 0.997; k = 8 <= 0.37; k = 10 <= 0.07).
- All three figures were already cited before they appear; P5 callout now also cites @fig-sizing-diversity.

### Tables
- Theory table (l. 127): new `#| label: tbl-sizing-f4-identities` + `tbl-cap` (H = 0.125, no distortion, F-infinity caveat, junction value in units of L from the P3 map); kable `caption =` removed (moved into tbl-cap). Cited in P7 before it appears.
- SSD grid table (l. 300): new `#| label: tbl-sizing-ssd-grid` + standalone `tbl-cap` (ten of twenty grid N, cached grid source and seed, replicates 40 at N <= 50 down to 10 from N = 210, means vs between-replicate s.d., definition of "skewed genome" as |p - 0.5| > 0.15 from `skew_fraction()`); kable `caption =` removed. Cited at the head of "The results".
- Working-numbers table (l. 612): new `#| label: tbl-sizing-working-numbers` + `tbl-cap` (adds 2 cM map, distortion, scenario h_res = 0.05, n_loc = 5000); kable `caption =` removed; one citing sentence added under the heading.

### Equations
- @eq-sizing-n95 now cited in prose ("The closed form @eq-sizing-n95 was checked ..."), not only in a table caption.

### Callouts
- "On the equivalent N": `callout-caution` -> `callout-warning` (misuse yields a wrong Ne).

### Text
- Acronyms expanded at first use: RILs, IBM (intermated B73 x Mo17), SSD (single-seed descent, at P6), Syn1/Syn2 (at P6), QTL, gene diversity GD.
- Section labels added: sec-sizing-ancestry, sec-sizing-assumptions, sec-sizing-results, sec-sizing-f1. Vague references replaced: "As above" -> @sec-sizing-ancestry; "handled separately below" -> @sec-sizing-f1; "In the grid below" -> @sec-sizing-results; "The theory above" -> @sec-sizing-assumptions.
- Headings already sentence case; citation syntax and bib keys all valid.

## 2. Findings passed on (quant-writer / quant-Rwrite)

- 04-E1 book/04-population-sizing.qmd:479 -- `saturation` is the chapter's central table and is unnumbered (kable with caption but no `tbl-` label). Needs rename to `tbl-sizing-saturation` + `tbl-cap` (renaming forbidden in this pass), then cite @tbl-sizing-saturation in "The metrics saturate at different N" before l. 478.
- 04-E2 l. 187, 207, 249, 283, 435, 674 -- `verify-het`, `verify-diversity`, `verify-junctions`, `verify-spacing`, `block-length`, `bridge` print `fmt(df)` as console output in place of tables; results quoted in prose (z, deficit_pct, block lengths, GD = D/2) live in unnumbered output. Either `knitr::kable()` + rename to `tbl-sizing-*` with captions, or declare them code demonstrations. Code change, not applied.
- 04-E3 l. 399-409 -- unlabelled echo:false chunk prints a raw `data.frame(comparison ...)` (bulk at largest N vs SSD at N = 30); l. 551-560 prints raw `fmt(steps[1:6, ])` and only the first six steps although the prose (l. 563) discusses the steps PAST N90; l. 598 `f1-sizing` prints a raw subset of `s`. Raw console output standing in for results tables.
- 04-E4 l. 307-315 -- SSD table bypasses `fmt()` (round()/sprintf()); `skewed genome` carries "%" inside the cells -- unit belongs in the header ("skewed genome (%)"). Same for the identities table (l. 139-143, sprintf) and the working-numbers table (prose-in-cells columns).
- 04-E5 l. 328 -- palette: `cols` gives SSD the pool-A blue `#1f5f8b`; l. 382-393 the ancestry figure uses `#e08214` and pool-A blue for N = 20 / N = 300; l. 542 multilocus uses base `col = i + 1`. Pool colours are reserved for heterotic pools (`book_pal` in _common.R); no pools are plotted in this chapter. Use `book_pal` greys/loss or a neutral sequential set; distorters already use `book_pal["loss"]` hex -- pass `book_pal[...]` rather than hex.
- 04-E6 l. 537 -- multilocus y-label "P(at least one line)" omits "homozygous P2 at k loci"; x-label `N[F2]` lacks "plants" (inconsistent with fig-sizing-diversity's "N[F2] plants").
- 04-E7 notation (book/90-notation.qmd "Population sizing" table) -- symbols used here and absent: $N_{90}$, $N_{95}(k)$, $k$ (loci to recover; clashes with marker index k / locations k elsewhere), $h_{res}$, $n_{loc}$, $\beta$ (bulk intensity; clashes with marker-effect vector $\boldsymbol\beta$), $w_i$, $z_i$, $g$ (intermating generations), $d$ (cM), $H_t$, $P$, $p$ as P1-ancestry frequency. Also $N$ here = F2 plants and $n$ = F1 plants, while the notation table defines $N$ = candidate hybrids and $n$ = hybrids selected; needs a scope note in the sizing table. $L$ is listed there as Morgans, consistent with this chapter.
- 04-E8 l. 167-210 and caption of fig-sizing-diversity -- the diversity expectation $D = 1 - (1-H)/N$ is used five times (figure, verify, gap, N_eq) but exists only as a table row; candidate for a labelled display equation `{#eq-sizing-div}` with a symbol definition. New content, so writer's call.
- 04-E9 l. 345-350 -- unlabelled echo:false compute chunk is fine; but captions now hard-code seed 20260828, beta = 6, attrition 15%, twenty grid sizes and h_res/n_loc. If `f2_opt` or the chunk scenario values change, captions drift. Inline `r` is not usable in `#|` captions; acceptable, flagged for maintenance.

## 3. Orphaned figure files

No unnamed figure chunk remains (all three figures carry `fig-sizing-*` labels), so every unnamed-chunk figure for this chapter is orphaned at the next render. All are tracked; remove with `git rm` after the render produces the `fig-sizing-*` files.

docs/04-population-sizing_files/figure-html/ (21):
unnamed-chunk-9-1.png, unnamed-chunk-9-1 2.png ... unnamed-chunk-9-1 8.png (8 files);
unnamed-chunk-11-1.png, unnamed-chunk-11-1 2.png ... unnamed-chunk-11-1 7.png (7 files);
unnamed-chunk-13-1.png, unnamed-chunk-13-1 2.png ... unnamed-chunk-13-1 6.png (6 files).

book/_freeze/04-population-sizing/figure-html/ (6):
unnamed-chunk-9-1.png, unnamed-chunk-9-1 2.png, unnamed-chunk-11-1.png, unnamed-chunk-11-1 2.png, unnamed-chunk-13-1.png, unnamed-chunk-13-1 2.png.

book/_freeze/04-population-sizing/figure-typst/ (3):
unnamed-chunk-9-1.svg, unnamed-chunk-11-1.svg, unnamed-chunk-13-1.svg.
