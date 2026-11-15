# 11-plant-literature -- editor (form pass)

Files: book/11-plant-literature.qmd, book/93-corpora.qmd. Checked against CLAUDE.md, _quarto.yml, _common.R, _rules.scss, 90-notation.qmd. No quarto render. knitr::knit of both chapters into scratch: no error, every stopifnot in 11 passes. The knitted fig-plant-landscape was viewed. make_downloads.R re-run (11 and 93 scripts regenerated). Scratch removed (book/Rplots.pdf, my two PNGs in book/figure; the two fig-joint-* files from other sessions left).

## 1. Edits applied

### 1.1 Wording changes to prose or captions (for quant-advice to check; none changes a claim)
All in book/11-plant-literature.qmd unless noted. Old -> new.

Cross-references (relative -> @sec-/@tbl-)
- 48 heading: "## The corpus, and what it can support" -> adds `{#sec-plant-corpus}`.
- 87 heading: "## The headline qualification" -> adds `{#sec-plant-qualification}`.
- 101: "On the screen's own table, the quantities" -> "On the screen's own table (@tbl-plant-usage), the quantities" (first citation of tbl-plant-usage now precedes the table).
- 118: "the merged category of the opening terms" -> "the merged category of @sec-plant-corpus".
- 196: "The statements below that rest on the usage table" -> "The statements in this chapter that rest on the usage table".
- 231: "Under the mapping above, then," -> "Under the mapping of @sec-plant-qualification, then,".
- 341: "In the 376-line panel above," -> "In the 376-line panel of @mukiti2025,".
- 570: "fourth sense of allelic richness above and not" -> "fourth sense of allelic richness (@sec-plant-corpus) and not".
- 635: "Yadav et al.'s ranking is of algorithms on one problem." -> "The ranking in @yadav2025 is of algorithms on one problem." (hand-typed narrative citation -> Quarto key).

Acronym definitions at first use (wording insertions only)
- 174: "`n` ROH records and" -> "`n` records with runs of homozygosity (ROH) and" (ROH was used at 174 before the definition at 181).
- 203: "PIC = 0.39" -> "polymorphic information content (PIC) = 0.39" (wording of the usage table's own label); "MAF = 0.29" -> "minor allele frequency (MAF) = 0.29"; 207 "the IBS distance" -> "the identical-by-state (IBS) distance".
- 324: "ex-PVP dent inbreds" -> "ex-PVP (expired Plant Variety Protection) dent inbreds"; 327 "525,141 SNPs" -> "525,141 single-nucleotide polymorphisms (SNPs)".
- 338: "SSR markers" -> "simple sequence repeat (SSR) markers".
- 393: "dominance QTL effects" -> "dominance quantitative trait locus (QTL) effects".
- 443: "on their GEBV" -> "on their genomic estimated breeding value (GEBV)".
- 451: "simulates OCS" -> "simulates optimal-contribution selection (OCS, @sec-ocs)" (see 11-E7: the definition is the book's, @gorjanc2018 names its problem differently).
- 482: "the specific-combining-ability part" -> "the specific combining ability (SCA) part"; 489 "a general combining ability against" -> "a general combining ability (GCA) against".
- 521: "doubled haploids found" -> "doubled haploids (DH) found".
- 540: "IBD-based inbreeding" -> "identity-by-descent (IBD)-based inbreeding".
- 548: "the most accurate $\Delta F$" -> "the most accurate rate of inbreeding $\Delta F$".
- 608: "Optimal Population Value," -> "Optimal Population Value (OPV),".
- 636: "convergence area under the curve for" -> "convergence area under the curve (AUC) for".

Numbers
- table row 670: hard-typed "22 records ... 5 in maize" -> inline `r chk[5, 2]` and `r chk[5, 3]` (same values, 22 and 5).

book/93-corpora.qmd
- New sentences, each a pointer to a table or figure that now has a label: "@tbl-corpora-files lists the two corpora." (13); "The columns that carry the screening annotation are described in @tbl-corpora-columns; the full list of columns of the plant file is printed first." (Structure); "Maize dominates (@tbl-corpora-crops, @fig-plant-landscape), which is ..." (inserted citations only); "The publication years of both files are in @fig-corpora-years."; "@tbl-corpora-classical lists them." (Classical references).
- fig-plant-landscape fig-alt: "Two bar panels: ... with maize in green, ..." -> a description of what is drawn (maize is blue, not green; bars and values; red outlines; right panel). Numbers in it (303, 17, 197, 42, 39, 33) read from the viewed image and the CSV.
- Year figure (was unlabelled, unnumbered): label `fig-corpora-years`; caption "Publication year of the screened records. Both corpora are deliberately post-2017." -> "Number of screened records per publication year in the plant file (left, `bibliography_plant.csv`) and the animal file (right, `bibliography_animal.csv`); each bar is a count of records, with no uncertainty. Both corpora are deliberately post-2017." (last sentence kept verbatim, see 11-E5); fig-alt was "Publication year of the screened records" (a title, not a description), now a description (counts rise from a handful or fewer in the earliest year to the largest counts in 2025 and 2026; verified on the viewed image: plant 1 in 2017, 180 and 179 in 2025 and 2026; animal 4 in 2018, 82 in 2025, largest in 2026).
- Four tables were bare kable (unnumbered): now `tbl-corpora-files`, `tbl-corpora-columns`, `tbl-corpora-crops` (its `caption=` argument moved to `tbl-cap`, text extended to "(relevance 3): the ten most frequent crop labels and their number of records"), `tbl-corpora-classical`, each with a `tbl-cap`.

### 1.2 Chunk options only
- 93: `#| label:`/`#| tbl-cap:` on four tables; `#| label: fig-corpora-years`, `#| fig-cap:`, `#| fig-alt:` on the year figure. No code touched.

## 2. Checked, no change needed
- 11: no figure chunk; fig-plant-landscape is cited at 134 before it appears (it lives in 93). tbl-plant-usage, tbl-plant-usage-check, tbl-plant-unestablished have label and caption; each is cited before it appears (tbl-plant-usage-check in the caption of tbl-plant-usage, tbl-plant-unestablished at 654). Table numbers are integers or one-decimal percentages from the shipped CSV, consistent within columns.
- Equations: no `$$` display equation in 11; cited @eq-catalogue-alleles-retained and @eq-collapse-f exist (06:323, 07:98). No `callout-caution`; the one callout (note, titled) is a clarification. No footnotes. Headings are sentence case. All @sec-/@tbl- targets exist.
- fig-plant-landscape: label, caption, fig-cap standalone (what, units, denominator, outline, ranks), book_pal used for every colour (light/A/loss/mid), axis labels present; width 9 x 4.8, see 11-E9.

## 3. Findings passed on

### To quant-writer
- 11-E1 (= it3 M15) 11:231-233. "what is rarely reported is the baseline-relative loss, the effective number of parents and (as far as the merged category allows) A_ret": for the first two the evidence is the absence of a category, which the following sentences concede a screen of abstracts cannot show; A_ret maps to the merged category at rank 6 of 12 (6.7 %), which the same paragraph calls "in the middle". Not edited: it is a claim.
- 11-E2 (= M16a) 11:177-179. "The effective-size pattern in the previous version also matched the bare token 'Ne' ..." is a revision-history remark in the chapter text; state the pattern's definition without "previous version", or move it to the chunk comment (160-166 already says it).
- 11-E3 (= M16b) 11:184-189. The sentence "The ROH query printed in @sec-corpora returns one record only when 'ROH' is matched case-insensitively inside a word ..." describes a variant that is not the printed query; the printed, anchored query (93, Querying them) returns 0.
- 11-E4 11: lines use "below"/"above" in 11 for neighbouring text (lines 43, 53, 64-65, 69, 76, 104, 187 "as above", 625 "The tasks above"); I changed only the ones that point at an identifiable object. Left as is, decide if the style guide should reach them.
- 11-E5 (= M16c) 93:73 (now the fig-corpora-years caption) and 93 "Classical references": "deliberately post-2017" while the plant file holds one 2017 record (animal starts 2018). Caption wording kept verbatim; the caption could state "2017-2026 (plant), 2018-2026 (animal)".
- 11-E6 11:574. Symbol $N_C$ (census size, line 574) is not in 90-notation.qmd. $F_{\text{drift}}$ / $F_{\text{hom}}$ are written with `\text{}` in 10, 11 and elsewhere, but `F_{drift}` in 90-notation.qmd (and 05, 00, 01): pick one.
- 11-E7 11:413-421 vs 451. 413 says "Optimal cross selection ... simulated ... by @gorjanc2018" and 451 says "simulates OCS"; the book's OCS is optimal-contribution selection (09:14, 09:199 says gorjanc's title names optimal cross selection and was not read). I defined OCS at 451 in the book's sense; confirm that this is what the sentence means or reword 413/451.
- 11-E8 93 "Classical references": the Source column is hand-typed "(Author, Year)". Keys exist for cockerham1967, nejatijavaremi1997, nei1973, caballero2000/2002, lindgren1997/1998, meuwissen1997, vanraden2008, storn1997. No key for Wright (1978) or Schnell & Utz (1975) in references.bib; add them, then the column can be [@key].

### To quant-Rwrite (chunk code, not mine to change)
- 11-E9 93 fig-plant-landscape. Width 9 in is scaled to 6.5 in in Typst (factor 0.72, tick text roughly 6 pt at cex 0.75). Tested width 7.5: the left x axis then drops ticks (0, 50, 150, 250, 350), so I kept 9. A cex of 0.85 at width 9, or a shorter x range, would help. Also: maize is drawn in book_pal[["A"]], the colour reserved for pool A; use a neutral colour so a reader does not read maize as pool A.
- 11-E10 93 fig-corpora-years. The y axis has no label ("records" missing), the two panels do not share a y scale, tick labels on the x axis are every other year only. Needs `ylab` and a legible `las`; the figure uses the HTML default 7 x 4.5 and the Typst default 6.5 x 4.
- 11-E11 93, three console outputs stand in for tables: `names(pl)`, `table(plant = ...)`/`table(animal = ...)` (Relevance and coverage), `sort(table(th))` (Themes in the animal corpus). The first is demonstration of the data, the other two are results; consider kable with a tbl label.

### Typst check (do not render here)
- tbl-plant-usage-check (11:139): 5 columns, headers "metric_used: records" / "metric_used: maize" are long; wrap risk.
- tbl-plant-unestablished (11:661): 2 columns, 11 rows of long text, probably 1.5 pages and a long second column; check page break and column widths.
- tbl-plant-usage (11:123): 4 columns, metric names up to 45 characters; probably fine.
- 93 tbl-corpora-files: the Focus column is a long sentence; check wrap.

## 4. Orphaned files (created by the edits)
Chunk 7 of 93 had no label (unnamed-chunk-7-1); now fig-corpora-years. After the next render the old files are orphaned:
- docs/93-corpora_files/figure-html/unnamed-chunk-7-1.png
- book/_freeze/93-corpora/figure-html/unnamed-chunk-7-1.png
- book/_freeze/93-corpora/figure-typst/unnamed-chunk-7-1.svg
The tracked book/_freeze/93-corpora and docs/93-corpora_files still hold the render from before the redraw of fig-plant-landscape too; the render of both chapters regenerates them (11 re-executes because its source changed).
