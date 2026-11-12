# 04c-alphasimr-pipeline -- editor report (form checklist)

File: book/04c-alphasimr-pipeline.qmd. No content or number changed. Not rendered.

## 1. Edits applied
Acronyms (checklist 5)
- 04c-E1 APPLIED, ~l.323: first prose use of QTL expanded ("association between markers and quantitative trait loci (QTL)").
- 04c-E2 APPLIED, ~l.1308: BLUP expanded at first use ("best linear unbiased prediction (BLUP)").
Labelled chunks (checklist 1/6)
- 04c-E3 APPLIED: labels added to the unlabelled chunks that print console output or hold the long computation:
  alphasimr-tiny-haplo, alphasimr-tiny-geno, alphasimr-selint-check, alphasimr-optim-check, alphasimr-run-rrs.
  The run_rrs/arms chunk produces no output (assignments + stopifnot); labelled for stability only.
  Left unlabelled (no output, no figure): setup chunk l.3, SP setup l.346, gv check l.397, two `echo: false` helper chunks.
  None of these makes a figure, so no PNG is renamed.

## 2. Checked, no change needed
- Figure fig-alphasimr-cycles: label, !expr fig-cap (stands alone: what, units, 48 draws, bars = +/- 1 s.d. across draws, scale, data source), fig-alt, 6.5 x 5, pool colours from book_pal, axis labels, cited at l.1803 before the chunk.
- All 21 table chunks have tbl- label + tbl-cap (literal or !expr); every table and subtable (-1..-5, paired-1/-2, pipeline) is cited before it appears; numbers go through fmt(); no bare kable.
- 8 equations all labelled eq-alphasimr-*, all cited; symbols match 90-notation rows 550-567 (local table declared).
- One callout (callout-warning, l.219, titled); no callout-caution; no footnotes.
- Headings sentence case; no hand-typed (Author, Year); no "see below"/"the equation above"; cross-refs use @sec/@fig/@tbl/@eq.

## 3. Findings for quant-writer (not applied)
- 04c-E4 l.1478-1479 (and caption l.27): GD_T, GD_WI, GD_BI, GD_BS and F_ST appear in an inline equation with no inline definition of the three components, only pointers to @sec-subdivided and @caballero2002. Checklist 3: every symbol defined at/after first use. Suggest one clause defining WI/BI/BS, or a labelled equation (eq-alphasimr-gdpartition) since it is cited repeatedly through Step 8 (l.1619-1700, 2131).
- 04c-E5 mixed "percent" (l.746, 942-950, 1224, 1371, 1384) and "%" with space ("5 %", l.1240, 1679, 2032, 2046). Pick one; I did not touch because the inline R spans are prose-wired.
- 04c-E6 table column headers are code names (snake_case) with units only in captions; acceptable under the book's convention here, but tables 4/5 (tbl-alphasimr-lottery, -dd) carry "trait units" only in captions, not headers. No action unless the book wants units in headers.
- 04c-E7 l.986, 1120, 2184: "a later chapter" / "Two earlier chapters" with the @sec- ref beside them; the vague descriptor is redundant and goes stale on reordering. Drop it.

## 4. Orphaned figure files
None. Label fig-alphasimr-cycles unchanged; existing files fig-alphasimr-cycles-1.png (docs/04c-alphasimr-pipeline_files/figure-html, book/_freeze/.../figure-html) and .svg (_freeze figure-typst) remain valid. Known book-wide Typst items 00-E1, 00-E2, 00-E8 skipped as instructed.
