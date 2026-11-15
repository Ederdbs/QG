# Editor report, 04d-breeding-programme (form pass, after content approval at it3)

File edited: book/04d-breeding-programme.qmd (plus book/downloads/04d-breeding-programme.R regenerated with make_downloads.R).
No chunk code was changed; only `#|` options, captions, fig-alt, headings ids, prose cross-references, one display equation.
Full knit (knitr, not quarto) done once in the scratchpad (5 min); both figures viewed; scratch files and book/Rplots.pdf removed (book/figure/fig-joint-* of other sessions left).
Tables could not be viewed as rendered tables (plain knit prints console output): width judgements below are estimates for the Typst check.

## 1. Edits applied

### Section ids (needed for @sec- cross-references; no numbering change)
- `## The scheme {#sec-programme-scheme}`, `### What reps does... {#sec-programme-reps}`, `## Genomic selection: two levers, separated {#sec-programme-levers}`, `## The comparison, replicated {#sec-programme-comparison}`, `## The diversity ledger {#sec-programme-ledger}`.

### Figures
- fig-programme-stages: fig-alt rewritten (old alt said "seven stages" and omitted Parents/Variety, the three arrows and the replicate counts); caption extended with the acronym key (DH, PYT, AYT, EYT).
- fig-programme-arms: fig-alt rewritten from the knitted image (old alt described the superseded two-arm single-run figure: it claimed "genomic arms" rise faster and "arms that recycle from the PYT" are lower; it did not mention lever 1, the control, the bands).
- @fig-programme-stages is now cited before the figure (it was cited only after); @fig-programme-arms had no prose citation at all, now cited before it.

### Tables
- The two raw console prints of results (`programme-seed1`, `programme-seed1-gs`, `fmt(ps1[...])` / `fmt(gs1[...])`) were unnumbered, uncaptioned tables. Now `tbl-programme-seed1-ps` and `tbl-programme-seed1-gs` with `#| tbl-cap:`, each introduced by a sentence that cites it. Chunk labels renamed (no figure files involved).
- "The first table ... the second" replaced by @tbl-programme-arms and @tbl-programme-contrasts.
- @tbl-programme-accuracy and @tbl-programme-neutral are now cited before their chunks (cited only after before).
- Caption of tbl-programme-arms: GD and theta defined (symbol used in captions before any definition).
- Captions of tbl-programme-ledger and tbl-programme-loss: "(see text)" replaced by cross-references.

### Equations
- The diagonal identity theta = 1/n + (1-1/n) theta_off and GD = (1-1/n) GD_off, cited three times ("the identity", "the factor of the diagonal"), is now a labelled display equation `{#eq-programme-gdoff}` and is cited as such. Content unchanged.

### Text / acronyms / references
- QTL, GxE and CI defined at first use; "see the start of the chapter", "the next section", "as described above", "the section on `reps`", "the section on genomic selection", "is stated below" replaced by @sec-programme-* references.

## 2. Wording changes (for the quant-advice diff check)

| # | Where | Before | After |
|---|---|---|---|
| W1 | intro, config paragraph | "...is stated below)" | "...is stated in @sec-programme-scheme)" |
| W2 | intro | "see the section on `reps`" | "see @sec-programme-reps" |
| W3 | The scheme | "The values below (`sch`) reduce it again." | adds "; @fig-programme-stages draws the stages." |
| W4 | The scheme | "50 causal sites per chromosome" | "50 causal sites (quantitative trait loci, QTL) per chromosome" |
| W5 | fig-programme-stages caption | "...of the section on genomic selection, from the preliminary trial as well (dashed)." | "...of @sec-programme-levers, ... (dashed). DH: doubled haploid; PYT, AYT, EYT: preliminary, advanced and elite yield trial." |
| W6 | What reps does | "The genotype-by-environment term" | "The genotype-by-environment (GxE) term" |
| W7 | What reps does | "measures the accuracy of an entry mean," | "... an entry mean (@tbl-programme-accuracy)," |
| W8 | Genomic selection | "(95 % CI 1.18-1.25)" | "(95 % confidence interval, CI, 1.18-1.25)" |
| W9 | after the seed-1 chunks | (none) | new sentences: "The phenotypic arm on seed 1 is the first run (@tbl-programme-seed1-ps)." and "The same seed with both levers on (@tbl-programme-seed1-gs):" |
| W10 | Genomic selection | "(asserted for every seed in the next section)" | "(... in @sec-programme-comparison)" |
| W11 | comparison, before tbl-arms | "The first table gives ...; the second gives" | "@tbl-programme-arms gives ...; @tbl-programme-contrasts gives" |
| W12 | after rate-of-gain paragraph | (none) | adds "@fig-programme-arms shows the genetic mean and the gene diversity of the PYT year by year." |
| W13 | tbl-programme-arms caption | "gene diversity (1 - theta, at the 600 QTL loci)" | "gene diversity (GD = 1 - theta, theta the mean of the molecular coancestry matrix f over the set, at the 600 QTL loci)" |
| W14 | ledger | "so that theta = ... and GD = ... (the identity is checked in the chunk above ...)" | display equation @eq-programme-gdoff; "(@eq-programme-gdoff is checked in the chunk above ...)" |
| W15 | ledger/alpha paragraph | "the factor (1 - 1/n) of the diagonal cancels exactly" | "... of the diagonal (@eq-programme-gdoff) cancels exactly" |
| W16 | neutral probe | "...at the QTL loci and at the neutral loci separately." | adds " (@tbl-programme-neutral)" |
| W17 | tbl-programme-ledger / -loss captions | "(see text)" ; "not the alpha of the catalogue chapter (see text)" | "(see @sec-programme-ledger)" ; "not the alpha of @sec-baseline (see @sec-programme-ledger)" |
| W18 | Assumptions | "as described above" | "as in @sec-programme-reps" |
| W19 | Scale | "(see the start of the chapter)" | "(see @sec-programme-scheme)" |
| W20 | new captions | tbl-programme-seed1-ps / -gs (new text, describes the run, columns, "One run, no replication") | |
| W21 | fig-alt x2 | see Section 1; fig-alt of arms quotes read-off levels (about 5.15, 4.86, 0.47, 0.34-0.37) from the knitted figure | |

## 3. Findings passed on

- 04d-E1 (figure layout, needs code; quant-writer / quant-Rwrite): fig-programme-stages, the EYT box (x 82-94) overlaps the Variety box (x 93-99), so the EYT-to-Variety arrow is a stub; the dashed PYT arrow ends in empty space left of the Parents box. fig-width 9.5 in, text cex 0.66: at Typst width (6.5 in text block) the labels fall to about 5.5 pt. Check in the PDF; making it legible means code changes (cex, box width), not options.
- 04d-E2 (figure, chunk options vs code): fig-programme-arms is 9 x 4.2 in, scaled by 0.72 in Typst; legends cex 0.7 ok at that scale, but narrowing to 6.5 in would make the 35-character legend entry collide with the lines. Y-axis labels "Genetic mean (PYT)" carry no unit ("trait units", mean 4 by design); "Gene diversity (PYT)" dimensionless. Left as is; unit wording is a content decision.
- 04d-E3 (notation, report only): this chapter uses L for the cycle length in years (also the column L of tbl-programme-arms), but 90-notation defines L as the number of parent lines and uses T for cycle length. theta_off and GD_off are not in 90-notation (it has the mean off-diagonal f_o). Either rename or add rows; also the notation row for T could cite this chapter.
- 04d-E4 (wide tables, flag for the Typst check): tbl-programme-loss (row label "control (phenotype-only truncation)" + four cells "0.123 (0.004)", about 85 characters), tbl-programme-contrasts (9 numeric columns + row name), tbl-programme-neutral (six columns, the last cell "QTL 1.2, neutral 3.4"), tbl-programme-arms (six columns, three of them "0.1234 (0.0012)"), tbl-programme-ledger (four cells of 15 characters). If they overflow: split or transpose is a quant-writer decision (not applied).
- 04d-E5 (table headers, code): ledger headers are raw identifiers (`gd_pyt_ps`, `gd_pyt_gs`, `gd_par_ps`, `gd_par_gs`); tbl-programme-seed1-* headers are column names of the run (`meanG`, `acc_pyt`...). Allowed to change `col.names` only in the table call, and here the table is the bare data frame, so the code would have to change. Cells are `sprintf` strings "mean (s.e.)" with a fixed number of decimals per table (consistent), not `fmt()`; acceptable because a pair is in one cell.
- 04d-E6 (callout choice, quant-writer decision): the callout "These numbers are reproducible" is a note, but its second paragraph states a design decision (a documented exception to the founders-once rule, @sec-alphasimr Step 1): candidate for callout-important. The diagonal trap (GD with the diagonal is not comparable between n = 60, 16 and 40) produces wrong numbers and is only in prose; candidate for a callout-warning next to @eq-programme-gdoff.
- 04d-E7 (minor format): "1500 headrows" next to "10,000 headrows" in the scheme paragraph (thousands separator inconsistent); left, quoted from the sources.
- Carried from the verdict, not touched, for quant-writer: M14 (MaCS wording near 04d:408, a user decision) and M15 (arm and ledger tables keep with-diagonal GD levels that are not comparable between PYT n = 60 and parents n = 16; the captions say so: cosmetic).

## 4. Orphaned figure files (created by the edits / label changes)

The stage diagram was already labelled (fig-programme-stages) in the working copy, so its new file name is `fig-programme-stages-1.png/.svg`; the old unnamed files are orphaned and not referenced by the new HTML:
- book/_freeze/04d-breeding-programme/figure-html/unnamed-chunk-2-1.png
- book/_freeze/04d-breeding-programme/figure-typst/unnamed-chunk-2-1.svg
- docs/04d-breeding-programme_files/figure-html/unnamed-chunk-2-1.png
(the Typst figure is embedded in the PDF; no docs/ svg.)
The edits of this pass add no further orphans (the two renamed chunks `programme-seed1`, `programme-seed1-gs` produce no figures). `fig-programme-arms-1` (freeze and docs) is stale content (old two-arm figure) and will be overwritten at the render.
Nothing in docs/ was edited by hand; no quarto render was run (the freeze for this chapter is therefore stale until the render).
