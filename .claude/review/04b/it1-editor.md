# 04b-backcross-introgression -- production editor, iteration 1

File edited: book/04b-backcross-introgression.qmd (worktree SB_quanti_gen-review). No chunk code changed beyond `#|` options, caption strings and `col.names`. `Rscript book/scripts/make_downloads.R` run (book/downloads/04b-backcross-introgression.R regenerated). Not rendered.

## 1. Edits applied

### Figures
- fig-bc-flow: cited in prose before the figure (@fig-bc-flow). Caption expands MABC, says schematic/no data, states that BC3 selection is drawn as under rec_drag and the IBD annotation is for s = 0.60, and qualifies "more than an order of magnitude" as "at four genes" (1610/99 = 16.3; at k = 3 it is 401/49 = 8.2). fig-alt rewritten (was "The MABC operation").
- fig-bc-policies: citation moved before the figure (now also points to @tbl-bc-policies). Caption now computed (`cap_pol` in the setup chunk): states mean total drag (cM), that the right panel is P(drag <= 30 cM per gene) only, NOT the joint drag-and-IBD criterion (the PNG's y axis is `P( drag <= ceiling )`), that the four policies include rec_bg and rec_drag, s = 0.60, 90-300 replicates per point computed from mabc_uniform.csv, no dispersion shown, dotted line 0.95. fig-alt rewritten.
- fig-bc-alloc: "the paired re-run table" in `cap_alloc` -> @tbl-bc-recheck.
- fig-bc-f2: was never cited; now cited before (@fig-bc-f2) in the fixation paragraph. `cap_f2` rewritten: replicates (250 per point, 80 above 500 plants; checked: every p_ok is a multiple of 1/250 or, above 500 plants, 1/80), s.e. bound, no interval drawn, criterion is target-only so index-independent, dotted line P = 0.95. fig-alt was "Points: simulation"; rewritten.
- fig-bc-sizing: was never cited; now cited in the opening paragraph of the fixation section. Caption now computed (`cap_siz`): analytical, P = 0.95, no simulation/index; colours corrected against the PNG (light blue = 1 foreground plant, dark blue = foreground + recombinant in a 5 cM flank; the old caption called both "backcross generations"). fig-alt rewritten.

### Tables
- Pipe table of the four policies: caption + label `{#tbl-bc-policies}`, cited at first mention.
- Fixation kable (unlabelled): `#| label: tbl-bc-fixation`, cited before; caption states q, P = 0.95, exact binomial, source CSV, no replicates, index-independent.
- tbl-bc-ibd caption: "means only, no dispersion shown".
- tbl-bc-index col.names: "N/gen" -> "N (plants/gen)". tbl-bc-recheck: "BC1/BC2/BC3" -> "BC1/BC2/BC3 (plants)".
- Existing labels tbl-bc-ibd, tbl-bc-index, tbl-bc-recheck and all fig- labels unchanged.

### Equations
- Labelled @eq-bc-haldane (map function), @eq-bc-ibd (the two IBD identities), @eq-bc-psame (P_same). Cited: "The second identity of @eq-bc-ibd", "At 20 cM @eq-bc-psame gives", "Meiosis is Haldane (@eq-bc-haldane)".

### Cross-references
- Heading "Which selection index" given `{#sec-bc-index}`. "defined below" -> "defined in @sec-bc-index"; "The next section is that correction" -> "@sec-bc-index is that correction"; "the index correction above" -> "of @sec-bc-index"; "the two allocations compared above" -> "two of the allocations compared in @tbl-bc-recheck"; "the cells of the tables above" -> @tbl-bc-ibd / @tbl-bc-index / @tbl-bc-recheck.

### Acronyms
- IBD (identity by descent) at first prose use; DH at first use; QTL; IBM (intermated B73 x Mo17, per the lee2002 title); "BC3" introduced as "the third backcross generation, BC3".

### Callouts
- Four callouts, all titled, types consistent with function (important = model scope, note = clarification, warning x2 = traps). No change.

## 2. Findings passed on

- 04b-E1 book/04b-backcross-introgression.qmd:838 -- `$1 - (1/2)^{4}$` is a formula but its exponent 4 is a hand-typed `MB$n_bc + 1`; same at :871 `$D = (1/2)^4$`. Should be `` `r MB$n_bc + 1` `` as at :232-236 (quant-writer).
- 04b-E2 :28 -- `cap_f2` now types "250 replicates (80 above 500 plants)" because mabc_bcnf2.csv has no n_rep column (verified by divisibility; matches run_f2_scan() in run_mabc.R:203-215). Either add the replicate counts to `MB`/the CSV, or extend the callout at ~:808 that lists the allowed typed values (it names only the allocation-scan count) (quant-writer / quant-Rwrite).
- 04b-E3 notation -- book/90-notation.qmd has no MABC section. Symbols used here and absent or in conflict: $s$ (shared IBD fraction; notation has $s_i$ self-coancestry and $s_{ij}$ SCA), $D$ (donor dosage; notation's sizing $D$ is diversity retained), $\text{IBD}_E$, $q$, $P_{\text{same}}$, $N$ (plants per backcross generation), $\nu$ (gamma shape, :744/:757; notation uses $\nu$ in genomic prediction), $P$ (criterion probability). $L$, $d$, $r$, $k$ agree with the population-sizing block. Needs a "Backcrossing" block with a local-scope note, as the sizing block has (quant-writer).
- 04b-E4 book/figs/mabc_sizing.png -- title "Fig 8. Analytical sizing by stage and by number of genes" is baked into the PNG, so the book shows two figure numbers. The cached image cannot be cropped here; needs regeneration without `title()` (run_mabc.R render_figures adds it for non-multi figures) (quant-Rwrite).
- 04b-E5 :190, :223, :627, :658, :671, :864 -- raw `data.frame`/`fmt()` console output used as results tables. :190, :627, :658, :671 are teaching echo chunks and acceptable; :223 (foreground sizing, quoted in prose) and :864 (the converted-panel GD comparison, the argument of "Where this connects") are results and should be labelled tables (`tbl-bc-foreground`, `tbl-bc-conversion-cost`) via kable -- a code change (quant-Rwrite).
- 04b-E6 :336 -- tbl-bc-index has 12 columns (two 5-column blocks with identical headers distinguished only by the caption). Likely too wide for A4 Typst and the block headers are not self-describing. Split into two tables or transpose; decision for quant-writer.
- 04b-E7 :57-58, :307, :425 -- fig-bc-flow is drawn at fig-width 10 (text cex 0.78-0.8), fig-bc-index and fig-bc-alloc at 9; at the Typst width of 6.5 in the annotation text of fig-bc-flow shrinks to about half size. Check legibility in the PDF; reduce to 6.5-7 with re-tuned cex if unreadable (quant-Rwrite).
- 04b-E8 :351 -- "Averaged over the eight cells" types the cell count; `nrow(wi)` (quant-writer).
- 04b-E9 :830 -- "That has been asserted for a chapter and a half" is a vague back-reference; name the section(s) where the near-copy claim is made (@sec-...) (quant-writer).
- 04b-E10 fig-bc-policies / mabc_policies.png -- the right panel plots P(drag <= ceiling), not the joint criterion used everywhere else in the chapter (fig-bc-index, tbl-bc-ibd). Caption now says so; the prose at ~:399-410 calls it nothing specific, but readers will compare it with fig-bc-index. Consider whether the policies comparison should use p_both (quant-writer).
- 04b-E11 :59 -- the "order of magnitude" in the fig-bc-flow caption is true only at k = 4 (16.3x; 8.2x at k = 3, 2.1x at k = 1). Qualified in the caption; the figure annotation and the sentence at ~:540 ("move by an order of magnitude") should be checked for the same scope (quant-writer).

## 3. Orphaned figure files
None: no fig- label was added, renamed or removed. (Untracked " N" duplicates already present under docs/04b-backcross-introgression_files/figure-html/ and book/_freeze/04b-backcross-introgression/ are render artefacts for the post-render sweep, not caused by these edits.)
