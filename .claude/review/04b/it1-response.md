# 04b -- iteration 1 response

## quant-writer

Files: book/04b-backcross-introgression.qmd, book/92-verification.qmd (MABC row only),
book/references.bib (+hospital2001, rodgersmelnick2015, holding2008; Crossref and PubMed checked),
book/downloads/ (make_downloads.R). Chapter purled and sourced from book/ with every inline
expression evaluated; no render.

| ID | Status | Note |
|---|---|---|
| 04b-D1 | fixed | Intro and @sec-bc-running now give per-table provenance: index_comparison and allocation_recheck from `--only=index_comparison,allocation_recheck` (1000 reps, per-cell `seed`); analytical_sizing reproduced exactly (`stopifnot(all.equal(sizing_table(...), mb_sz))` in chunk); uniform/allocation/bcnf2 and the two PNGs declared as predecessor output, not rewritten or diffed by the current driver. Reps per table inline. `script`/`drag` mapped to rec_bg/rec_drag via the `strategy` column. (R1) |
| 04b-D2 | fixed | `which.max` dropped. Certification on CP lower bound: N_cert = min N with lo >= 0.95 (400, lo 0.978); N = 250 not certified (lo 0.901); the grid does not locate the minimum. The uniform scan's independent estimate of the same cell (0.967 [0.906, 0.993], 90 reps) is shown. (R2) |
| 04b-D3 | fixed | 1/g mechanism removed from both places. Recheck paragraph rewritten from the new table: balanced and 40/120/200 not separated (intervals inline); the two 20-plant schedules are the two lowest under both indices (asserted); p_lost vs (7/8)^20 and (7/8)^40 inline; P(both given kept) shows 20/150/190 loses mostly to gene loss and 300/40/20 mostly after conditioning (both asserted). Credits @hospital2001. (R3) |
| 04b-D4 | fixed | fig-bc-alloc text and caption state rec_bg, 40 reps (granularity asserted), s; per-schedule points added as dispersion with binomial s.e.; comparative caption claim removed; equal-size schedules shown closer to rec_bg than rec_drag uniform cells (asserted). (R4) |
| 04b-D5 | fixed | IBD table now uses `mabc_opt$main_strategy` (rec_drag), labelled tbl-bc-ibd; closed form declared unconditional, with foreground conditioning and the simulated rec_drag range 0.946-0.964 inline; diagram note says "before conditioning on the targets". (R5, R7) |
| 04b-D6 | fixed | Sum identity exact; proportionality in expectation only, with the test tolerance cited. (R6) |
| 04b-D7 | fixed | Chunk uses `1 - expected_donor(3)`; unlinked, inbred, 0/1 coding, unrelated donor declared; ratio 0.125 inline with expectation 2D(1-D) = 0.117 derived; "order of magnitude" removed. (R8) |
| 04b-D8 | fixed | Class stated (pre-specified pair homozygous, other pair heterozygous, q = 1/64); 401 and 99 by `n_for_count` inline. (R10) |
| 04b-D9 | fixed | `build_map(...)$m` inline (344). (R9) |
| 04b-D10 | fixed | "Every number interpolated" replaced by a true statement naming the typed design inputs; rep counts inline (90-300, 1000, 40); grid description computed from the CSV; shell block without timings/check count, plus the `--only` line; 92-verification row computed from the CSVs. (R12) |
| 04b-D11 | fixed | P(IBD) column added to tbl-bc-index; min p_ibd under rec_drag (0.976 at k = 4, N = 80) shown to equal 1 - p_lost; "every replicate" removed. tbl-bc-ibd caption reports the kept-genes IBD miss rate (max 0.003) instead of the false "every cell" identity. (R14) |
| 04b-D12 | fixed | 4.90e-4, 4.6x, "nu near 3" removed; @falque2009 with 4.2 < nu < 6.2 and non-interfering fraction; Haldane r^2 computed; magnitude declared not computed. (R11) |
| 04b-D13 | fixed | Sentence deleted. |
| 04b-D14 | fixed | "Classical practice" and 1/g removed; policy paragraph now cites inline drag from mabc_uniform.csv (rec12 71.7, rec_bg 70.2, rec_drag 43.3 cM, k = 3, N = 200, 90 reps; ordering asserted); @hospital2001 credited. |
| 04b-D15 | fixed | @rodgersmelnick2015, >1000-fold local rate, scale stated; uncited pericentromeric clause removed; @lee2002 added for IBM. |
| 04b-D16 | fixed | @haldane1919 cited; (1/2)^{t+1}, (1/2)^k, (1/4)^k, (1/2)^k (DH) derived from Mendelian segregation with unlinked targets declared (four different chromosomes); "DH is routine", "3-10" and sh2/bt2 enzyme claim removed; o2 modifiers cite @holding2008. |
| 04b-M1 | fixed | fig-bc-index, fig-bc-alloc, fig-bc-f2 captions computed (`!expr` from setup chunk); recheck caption from CSV columns; "by four" -> 4.3, 4.05, 4.01 computed; timings/35 checks removed; historical 0.97/0.97/0.93 replaced by the live non-monotonicity in mabc_uniform.csv (0.989 at 320, 0.967 at 400). |
| 04b-M2 | fixed | `set.seed(5)` before `make_shared_ibd()`, `set.seed(6)` before `run_bc_program()` in the interactive chunk. Driver half is quant-Rwrite's (already per-cell for D/E). |
| 04b-M3 | fixed | Exponent interpolated; value from `expected_ibd()`. |
| 04b-M4 | contested (scope) | R/08_mabc.R:413 docstring and run_mabc.R fig1 caption are outside book/; passed to quant-Rwrite. Evidence: new mabc_index_comparison.csv gives IBD cost 0.26-1.19 pp (mean 0.92), not "1.5-2"; `expected_ibd(3, 0.6)` = 0.975, not 0.980. |
| 04b-B1 | fixed | @haldane1919. |
| 04b-B2 | fixed | Sentence deleted (same edit as D13). |
| 04b-B3 | fixed | Derivations given in text instead of citations (same edit as D16). |
| 04b-B4 | fixed | Both claims removed (same edit as D14); Hanson/Frisch not added since nothing now rests on them. |
| 04b-B5 | fixed | @hospital2001 credited (same edit as D3). Herzog & Frisch 2011 not added: full text not read. |
| 04b-B6 | fixed | "DH is routine" removed (same edit as D16). |
| 04b-B7 | fixed | Same edit as D12. |
| 04b-B8 | fixed | Same edit as D15. |
| 04b-B9 | fixed | "3-10" removed (same edit as D16). |
| 04b-B10 | fixed | sh2/bt2 claim removed; o2 via @holding2008 (abstract: "multiple, unlinked o2 modifiers"). |

Audit items closed by the same edits: R1-R12, R14, R16 (chapter half); R13 except the typed design inputs; R17 is quant-Rwrite's.
New table labels: tbl-bc-ibd, tbl-bc-index, tbl-bc-recheck (no figure label changed, so no orphaned PNGs).

## quant-Rwrite

Files: R/08_mabc.R (select_parent docstring), man/select_parent.Rd (document()),
inst/scripts/run_mabc.R (fig1), tests/testthat/test-mabc.R (+1 test),
book/04b-backcross-introgression.qmd (chunk code only), book/downloads/ (make_downloads.R).
Checks: devtools::test() FAIL 0 | WARN 0 | SKIP 0 | PASS 492; run_mabc.R --test 36/36;
devtools::install() ok; chapter purled and sourced from book/ with _common.R, 96/96 inline
expressions evaluate, conversion GD ratio 0.1250. No data regenerated, no render.

| ID | Status | Note |
|---|---|---|
| 04b-M4 (R14 code half) | fixed | select_parent docstring: "300 replicates / 0.813 vs 0.997 / 1.5-2 points / met in every replicate" replaced by a pointer to `book/data/mabc_index_comparison.csv` (`run_mabc.R --only=index_comparison`): rec_drag beats rec_bg at every cell, IBD cost 0.26-1.19 pp (mean 0.92), IBD misses are gene loss bar 1/1000 (k = 3, N = 80). New test in test-mabc.R recomputes all four statements from the CSV (skip_if_not file exists: book/ is .Rbuildignore'd). |
| 04b-M4 (R17) | fixed | run_mabc.R fig1 caption: 0.980 -> `sprintf("%.3f", expected_ibd(opt$n_bc, 0.60))` = 0.975, exponent from `opt$n_bc + 1`, "before conditioning on the targets" added, garbled "not and of IBD" fixed. The panel also plotted `rec_bg` while the caption named `opt$main_strategy`; the filter now uses `opt$main_strategy` (rec_drag present at s = 0.60 in mabc_uniform.csv, 44 cells), matching the chapter's D5 fix. Driver HTML only; book does not read it. |
| 04b-R16 / M2 (driver half) | fixed (writer + regen) | Interactive chunk seeded by the writer (set.seed(5)/(6)); driver per-cell seeds for D/E in the regen pass. Uniform/allocation/bcnf2 scans still seeded once per scan: not touched, those tables are not regenerated (not authorised). |
| 04b-R6 / check 3 | fixed | New chunk after the interactive programme: 200 unselected BC1 plants, `set.seed(8)`; asserts IBD_E + donor-specific = 1 exactly (all.equal default) and mean donor-specific = (1 - s) mean dosage and mean dosage = expected_donor(1), both `tolerance = 0.06` (max relative error over seeds 1-200: 0.048, 0.044; measured, commented in chunk). |
| 04b-R15 / check 3 | fixed | p_same_segment chunk asserts the displayed closed form e^-L / ((1 + e^-2L)/2). Foreground chunk asserts q = (1/2)^k and minimality of n_for_count: (1-q)^n <= 0.05 < (1-q)^(n-1). |
| 04b-R8 / D7 (check) | fixed | Conversion chunk asserts realised GD ratio against 2D(1-D) = 0.117, `tolerance = 0.15` (max relative error over seeds 1-200: 0.141; realised 0.125 at seed 11). |
| MB_alloc typed n_rep = 40, s = 0.60 | kept | Already commented by the writer as run_mabc.R DEFAULT_OPT alloc_rep / alloc_s; granularity assert at the fig-bc-alloc chunk ties n_rep to the data. Not regenerated (not authorised). |

Chunk numbering: one new chunk, no figure; all figure chunks are labelled, so no `unnamed-chunk-*` orphaned.
Open, prose (writer): line 832 still types `1 - (1/2)^{4}` in the conversion paragraph.

## quant-writer (editor findings)

Files: book/04b-backcross-introgression.qmd, book/90-notation.qmd, book/downloads/ (make_downloads.R).
Both chapters purled and sourced from book/ with _common.R; 102/102 (04b) and 8/8 (90) inline expressions evaluate; no render. No computed number changed, no stopifnot removed (one added).

| ID | Status | Note |
|---|---|---|
| 04b-E1 | fixed | Both exponents (conversion paragraph and $D = (1/2)^{...}$) now `` `r MB$n_bc + 1` `` (= 4). |
| 04b-E2 | fixed | Count cannot be derived from the CSV (divisibility by 1/250 does not identify 250), so it is declared: `MB_f2 <- list(n_rep = 250, n_rep_large = 80, n_large = 500)` with a comment pointing at run_f2_scan() in run_mabc.R, and `stopifnot` that every p_ok is a multiple of 1/n_rep for its row (passes). cap_f2 interpolates MB_f2 and says the counts are driver defaults the CSV does not record. The "typed values" callout now names both MB_alloc and MB_f2 as checked-not-derived. |
| 04b-E3 | fixed | New "### Backcrossing" block in 90-notation (k, s, D, IBD_E, d, r, L, P_same, q, n, N, P, nu, with functions) plus a local-scope note: s unsubscripted vs s_i / s_ij; D donor dosage vs sizing D; N/n plants; L inter-target interval vs total map length; nu gamma shape vs chi^-2 df in genomic prediction. No symbol renamed in any chapter. |
| 04b-E4 | deferred to quant-Rwrite | "Fig 8." baked into book/figs/mabc_sizing.png. |
| 04b-E5 | fixed | Foreground chunk -> `tbl-bc-foreground` (kable, caption, cited before); conversion chunk -> `tbl-bc-conversion-cost` (kable digits = 4, caption computed from MB$n_bc and m_c, cited before). Stopifnots untouched; displayed values identical. |
| 04b-E6 | fixed | tbl-bc-index transposed to long format: one row per (genes, N, index), 8 columns with self-describing headers (index column = rec_bg / rec_drag from `strategy`). `wi` still computed in the chunk for the inline means. Label unchanged. |
| 04b-E7 | deferred to quant-Rwrite | Needs a visual check of the coordinate-drawn diagram (no render allowed). Estimate: fig-bc-flow annotation text at 12 pt x 0.78 x 6.5/10 = 6.1 pt in Typst; fig-bc-index/alloc at width 9 give 8.7 pt axis text and 7.4 pt legend, acceptable. Reducing fig-width requires re-placing every text() coordinate. |
| 04b-E8 | fixed | `r nrow(wi)` (= 8). |
| 04b-E9 | fixed | Names where it is asserted: item 5 of the Preface's chain of argument (index.qmd:104-107, which has no @sec- label) and the preceding paragraph. |
| 04b-E10 | fixed (caption + prose) | Panel left as is: the cached PNG is not regenerable here and book/figs is out of scope. Caption already says drag only; one sentence added after the citation stating the right panel is not the joint criterion and is not comparable with @fig-bc-index / @tbl-bc-ibd. |
| 04b-E11 | fixed | Diagram annotation contains no "order of magnitude" (checked). Fixation paragraph's "move by an order of magnitude" replaced by the computed ratio n_F2_3plants / n_BC_1plant: 4.6 at one gene, 34.3 at four. Flow caption's "more than an order of magnitude ... at four genes" (16.3x DH vs selfing) left as qualified by the editor. |

## quant-Rwrite (figures)

Files: inst/scripts/run_mabc.R, book/figs/mabc_sizing.png, book/04b-backcross-introgression.qmd, book/downloads/ (make_downloads.R). No simulation re-run, no book/data touched, no render.

| ID | Status | Note |
|---|---|---|
| 04b-E4 | fixed (script + PNG) | render_figures() no longer calls title() on the image (`draw <- g$f`); the HTML figcaption and the book caption carry the number. fig8 top margin 3.4 -> 1.2. fig8 is analytical (sizing_table() only, no `E$res`), so the PNG was redrawn from the script's own `build_figures(list(opt = DEFAULT_OPT))$fig8` at the original 1208 x 736 / res 115, after asserting sizing_table(DEFAULT_OPT) == book/data/mabc_analytical_sizing.csv (all.equal). Bar labels unchanged (5 ... 1610 / 99). No plot-only CLI flag added. |
| 04b-E7 | fixed | fig-bc-flow redrawn at fig-width 6.5 (= Typst width, scale 1) x fig-height 7.2: text cex 0.70-0.78 -> 8.4-9.4 pt printed (was ~6.1). Box labels and notes rewrapped to fit (box widths 3.0 -> 3.4-3.6, three-line boxes), fork/final boxes and arrows re-placed; unused `lab` arg of arr() dropped. Label unchanged. Checked visually: chunk extracted from the .qmd and drawn at 6.5 x 7.2 in, md5-identical to the scratch draw, no overlap or overflow. Labelled chunk: no unnamed-chunk orphans; its freeze figure regenerates on render. |
