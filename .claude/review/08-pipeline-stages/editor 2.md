# 08-pipeline-stages -- production editor, form pass

File: book/08-pipeline-stages.qmd (content approved at it3). No render run. book/figure and
book/Rplots.pdf were not present (nothing to remove). book/scripts/make_downloads.R re-run
(book/downloads/08-pipeline-stages.R regenerated, 28 `tbl-` mentions).

## 1. Edits applied

### Prose or caption wording changed (quant-advice: check this list against the diff)
- P1 (l.14) "for DH induction" -> "for doubled-haploid (DH) induction" (acronym at first use).
- P2 (l.26-29) "$GD = 1 - \theta$ as the scale" -> "gene diversity $GD = 1 - \theta$ as the scale";
  "$N_{e,par}$ as the second constraint" -> "the effective number of parents $N_{e,par}$ as the second constraint".
- P3 (l.38) added citation `[@balding1995]` after "Balding-Nichols parameter" (key exists in references.bib, cited in 00, 02b, 03).
- P4 (l.39) "reserved for the statistic of Trap 2" -> "... Trap 2 (@sec-stages-trap2)".
- P5 (l.52) "from the three csv files below is" -> "from the three csv files is" ("below" removed).
- P6 (Trap 1) "Reporting both MRD and coancestry ..." -> "Reporting both the modified Rogers distance (MRD) and coancestry ..."; "the modified Rogers distance between lines is" -> "the distance between lines is" (the full name now sits in the first sentence); "by definition of both" -> "by definition of both (@eq-stages-fij)".
- P7 (S1) "$\theta_T$ is the coancestry of the whole set;" -> "In @eq-stages-partition $\theta_T$ is ...".
- P8 (Trap 2) "which gives $F_{ST} = ...$" -> inserted "(from @eq-stages-fst and @eq-stages-fst-btw)"; the paragraph that began "asserted in the chunk above. The ratio is 2" now begins "@eq-stages-fst-ratio is asserted in the chunk above. The ratio is 2" (the comma that followed the displayed ratio equation moved out so the equation carries its label).
- P9 (Trap 2 table lead) "the two never converge:" -> "the two never converge (@tbl-fst-definitions):".
- P10 (Trap 3) "at the teaching scale:" -> "at the teaching scale (@tbl-trap3-sweep):".
- P11 (S1 panel) new lead sentence before the chunk: "@tbl-s1-panel is the output of `s1_monitor()` on the simulated world of this chapter:".
- P12 (S2) "(c) is asserted against the literal ..." -> "(c), @eq-stages-dh-theta, is asserted against ..."; "The formula agrees with gene dropping" -> "@eq-stages-sigma-dh agrees with gene dropping".
- P13 (S2 intro) "is measured at the end of the chapter, from a cached file" -> "is measured in @sec-stages-ledger, from a cached file".
- P14 (Trap 4) "show that this explains little:" -> "show that this explains little (@tbl-trap4 and @fig-metric-pitfalls):".
- P15 (Trap 5) "run at the end of Trap 5." -> "run at the end of Trap 5 (@sec-stages-trap5)."; "is only meaningful at the target size**:" -> "... (@fig-theta-by-size):"; within-pool lead "(...the merit of this world):" -> "(...the merit of this world; @tbl-trap5-within-pool):".
- P16 (S4) "(see the cost section)" -> "(@sec-stages-cost)"; "the `Ne` column of the ledger below" -> "the `Ne` column of the ledger of @sec-stages-ledger"; (ledger provenance) "nothing below is a reproduction" -> "nothing in this section is a reproduction".
- P17 (ledger) appended to the paragraph before the ledger chunk: "@tbl-ledger gives the means over the 8 founder pools and @fig-pipeline-loss plots them."
- P18 (endpoints) "...normality of the 8 differences not checked). Hybrid" -> "...not checked; @tbl-endpoints). Hybrid".
- P19 (cost) "Orders of magnitude only; this chapter..." -> "Orders of magnitude only (@tbl-stage-cost); this chapter...".
- C1 fig-theta-by-size caption: "Mean group coancestry of random sets (...) falls with set size." -> "Mean group coancestry $\theta$ of random sets (50 random sets per size, seed 5, drawn from the simulated world of 30 + 30 lines and 3,000 markers) falls with set size (number of lines)."; "ceiling calibrated for n = 20 (dashed)" -> "ceiling calibrated for n = 20 at a permitted loss of 0.5 % (dashed)" (0.5 % = alpha 0.005 in chunk trap5-greedy; the rest of the caption unchanged).
- C2 new captions written from code and text only: tbl-trap3-sweep, tbl-s1-panel, tbl-trap5-within-pool, tbl-stage-cost (columns read off the code and roxygen of `s1_monitor()`/`pool_complementarity()`; no claim added).
- C3 col.names of tbl-endpoints: "95% CI low/high" -> "95 % CI low/high" (space before %).

### Figures
- All three figures already had `fig-` label, `fig-cap` and `fig-alt`. They were never cited by `@fig-`: citations added (P14, P15, P17).
- fig-theta-by-size: caption now states the simulated world and what the dashed line is (C1).

### Tables
- Five existing kable tables had the caption inside `kable(caption=)`: moved verbatim to `#| tbl-cap:` (tbl-fst-definitions, tbl-trap4, tbl-ledger, tbl-endpoints) and tbl-cap added to the unlabelled cost table (now `tbl-stage-cost`, which had no label and no caption).
- Tables that printed through `df-print: kable` with no label or caption now labelled and captioned: `trap3-sweep` chunk renamed `tbl-trap3-sweep`, `tbl-s1-panel` (the S1 panel), `trap5-within-pool` renamed `tbl-trap5-within-pool`. No chunk code touched.
- None of the six tables was cited before its appearance (tbl-trap4 only after); all are now cited before.

### Equations (central or referenced; label `eq-stages-*`)
fij (@eq-stages-fij), partition (-partition), F_ST (-fst), F^btw_ST (-fst-btw), ratio (-fst-ratio), DH group coancestry (c) (-dh-theta), sigma^2_DH (-sigma-dh). Each is cited in the prose (P6-P8, P12).

### Callouts
- "The key structural result of S2": `callout-important` -> `callout-note` (it clarifies what the identity implies; it is not a design decision of the book). Title kept.

### Section ids added for cross-references
{#sec-stages-trap2}, {#sec-stages-trap5}, {#sec-stages-ledger}, {#sec-stages-cost}.

### Text checks with no change
Headings are in sentence case; no `callout-caution`, no footnotes, no hand-typed "(Author, Year)" except Schnell and Utz (08-E7); N_s, OCS, MABC not used. "OCS" appears once ("chapters on the collapse, OCS, combinatorial and advanced selection", sentence with @tbl-hp-stages): left as is, because it is the name of a chapter's subject in a list; expand if you prefer (08-E9).

## 2. Findings passed on

- 08-E1 book/08-pipeline-stages.qmd:~820 and 880 (tbl-ledger, 9 columns; tbl-endpoints, 8 columns): width at Typst A4 (text width about 15 cm at 8.8 pt) cannot be verified without a render. Both are likely to wrap or crowd the headers (`share % (mean)`, `share % (min)`, `share % (max)`, `pools higher (of 8)`, `paired t p`). Two other wide tables I labelled: tbl-trap3-sweep (9 columns) and tbl-s1-panel (11 columns, one row: wide even at 8.8 pt). Suggested for quant-writer: split `lg` into a loss table and a share table, transpose the S1 panel and the endpoint table (`t()`), or shorten the headers. Check in the PDF after the render batch.
- 08-E2 chunks s3-loss (`fmt(lv, 4)` then `table(pool[top])`) and sigma-uc (named vector, then `fmt(head(...), 6 rows)`): two outputs per chunk, so a data frame is shown as an unnumbered table and a console vector as raw R output. A label cannot be given to a chunk with two outputs. Split into two chunks (the table in its own `tbl-` chunk) or move the vector to inline text; chunk code, so quant-writer.
- 08-E3 chunks trap1, dh-identities, s4-usage, s4-he, trap5-greedy, trap5-repair, trap5-worlds: results are printed as named vectors in raw console output (identity checks and run summaries). Not labelled; acceptable as identity checks, but the figures quoted in the prose from `trap5-worlds` and `rep1` would be easier to audit as a table. Judgment for quant-writer.
- 08-E4 fig-theta-by-size: x-axis label is "set size" (chunk code, `xlab`); the unit is lines. Suggest `xlab = "set size (number of lines)"`. The legend text uses "theta" in plain text rather than the symbol. Chunk code, so quant-writer / quant-Rwrite.
- 08-E5 symbols not in book/90-notation.qmd (to add there or to rename here): $F^{\text{btw}}_{ST}$; $\theta_w$ (the notation has $\tilde f$ for the same quantity); $w_p$ (census weight of pool p) collides with $\mathbf{w}$ (line-usage weights, which this chapter also uses in the same section); $D$, $n_c$, $f_c$, $C$ of identity (c) ($D$ is the DH-line total where the notation's $\mathbf{w}$ uses $n$); $\bar F_{cc'}$; $i$ (selection intensity, which clashes with the index $i$ of the same formula $UC_{ij}$), $h$ and $q$ of the usefulness criterion. `Ns_total`, `GD_WS` are listed or derivable.
- 08-E6 book/08-pipeline-stages.qmd:~237 ("Result." paragraph of Trap 3) states that the chunk table has the s.d. over seeds; correct, but the reader is not told which of the nine columns are means: the caption now says so (C2). No action.
- 08-E7 Interpretation of the usefulness criterion: "Schnell and Utz (1975)" is hand-typed and not in references.bib (the chapter says so). Not converted to Quarto syntax because there is no key; add the entry to references.bib or drop the attribution. Quant-writer.
- 08-E8 fig-metric-pitfalls and fig-pipeline-loss (cached PNGs): axes, panel labels and font sizes at Typst width (6.5 in) were not inspected; the captions themselves state that the figure's own labels use withdrawn names. Needs a look at the PDF after the render.
- 08-E9 Optional: the first mention of OCS (S4 section, "@tbl-hp-stages assigns S4 to the chapters on the collapse, OCS, combinatorial and advanced selection") is not expanded.
- 08-E10 tbl-trap4 builds its numbers with `round()` and not `fmt()` (chunk code, same result); tbl-trap4 and the sweep use two rounding conventions (3 and 4 digits). Cosmetic; quant-Rwrite.
- 08-E11 Non-blocking from the verdict, for quant-writer: 05b-heterosis-dominance.qmd:786-791 "That section shows that ..." over-credits Trap 3 (M12).

## 3. Orphaned files created by the edits
- Chunk `trap3-sweep` -> `tbl-trap3-sweep`, `trap5-within-pool` -> `tbl-trap5-within-pool`: neither produces a figure; no PNG orphaned.
- New unlabelled-to-labelled chunks (`tbl-s1-panel`, `tbl-stage-cost`) produce no figure; but the chapter's `unnamed-chunk-N-1.png` numbering is unchanged (no figure chunk added or removed).
- The stale `book/_freeze/08-pipeline-stages/` and `docs/08-pipeline-stages_files/` already await the render batch (08-M11); nothing new orphaned by this pass.
