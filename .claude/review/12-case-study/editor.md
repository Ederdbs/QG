# 12-case-study -- editor (form pass, after it3 APPROVED)

File: `book/12-case-study.qmd` (checkout, branch `review-pending-chapters`). No render, no knit of the chapter: no chunk code was touched, only `#|` lines, prose, and two heading ids. The six new `tbl-cap` strings were parsed with `yaml::yaml.load` and rendered (HTML and Typst) in a scratch document against dummy tables: no error; the only warning was the expected unresolved `@sec-catalogue` outside the book. A scratch test confirmed that a `tbl-` chunk that also prints a console vector (the frontier chunk prints `trunc_wins`) gives a clean table float: with `collapse: true` the console text goes into the code block. `Rscript book/scripts/make_downloads.R` was re-run; only `book/downloads/12-case-study.R` changed. No number changed.

## 1. Edits applied

### Figures
- `fig-case-study-frontier`: already labelled, captioned (with `!expr`), with fig-alt, and cited before the chunk (`@fig-case-study-frontier draws ...`). No change. See E3 and E4.

### Tables
All six results tables were bare data-frame prints (`df-print: kable`, so they rendered as tables, but unnumbered). Each now has `#| label:` and `#| tbl-cap:` and is cited with `@tbl-` before the chunk:

| chunk (line now) | label |
|---|---|
| `fmt(res$metrics[...], 4)` (108) | `tbl-case-study-metrics` |
| `fmt(data.frame(scenario, Ns, Ne_parents, ...), 3)` (130) | `tbl-case-study-ns` |
| `fmt(res$metrics[, F_hom, F_drift, ...], 4)` (172) | `tbl-case-study-lenses` |
| `fmt(res$z_scores[...], 2)` (212) | `tbl-case-study-z` |
| `head(res$selection[...], 8)` (253) | `tbl-case-study-selection` |
| `fmt(front_tab, 3)` (342) | `tbl-case-study-frontier` |

These chunks had no label before and produce no figure, so the labels orphan no file.

### Equations
- No display equation. The inline equations used (@eq-catalogue-alpha, @eq-f-stats, @eq-era-cov, @eq-catalogue-ene-ane, @eq-balding-nichols, @eq-g-sum-zero) are all cited by label. Every `@sec-/@tbl-/@eq-/@fig-` target in the chapter resolves (grep over `book/*.qmd`). See E5 for notation.

### Callouts
- One callout (`callout-note`, "The same functions as a script"): a clarification, titled. Conforms. No `callout-caution`, no footnotes.

### Text
- Heading ids added: `{#sec-case-study-lenses}` ("Both lenses, and the pool partition") and `{#sec-case-study-limits}` ("What this simulation cannot tell you"), to replace relative references. Headings already in sentence case.
- Acronyms expanded at first use: DH, gene diversity (GD_S), A-NE, E-NE, MAF, VCF. DE was already expanded at line 43.
- Relative references replaced: "the next section", "the chunk above", "see below", "the table" (x2), "the table above", "(above)". See W list.
- Citations: no hand-typed "(Author, Year)"; `@meuwissen2020` and `[@sanchez2023]` resolve in `references.bib`.

### Caption and prose wording changed (for the quant-advice diff)
New captions (all read off the code; nothing claimed beyond it):
- C1 `tbl-case-study-metrics`: "Metrics of the selected set for each scenario of this run, as returned in `$metrics` by `stage2_select()` (the metrics are defined in @sec-catalogue). Five DE rows, one per requested budget, the name carrying $\alpha_{\max}$ in percent; four reference selections (`ref_*`). `alpha` is the achieved gene diversity loss against the same-size random baseline (a fraction); `index` is the mean index of the selected hybrids in standard deviations. Teaching scale (25 + 25 lines, 2000 markers), $n$ = 62 of $N$ = 625 candidates, DE and null seed 1." (62 = `round(0.10 * 625)`, hard-coded in the caption; 625 is already hard-coded in the prose.)
- C2 `tbl-case-study-ns`: "$N_s$ (`Ns`) and `Ne_parents` for each scenario of @tbl-case-study-metrics, and each divided by its maximum over the nine scenarios (`Ns_relative`, `Ne_par_relative`)."
- C3 `tbl-case-study-lenses`: "The two lenses and the pool partition for each scenario of @tbl-case-study-metrics: achieved loss `alpha` (a fraction), `F_hom` and `F_drift` on the frozen base $p_0$, their gap `cov_diag`, `rare_retained` (the fraction of the candidate pool's rare alleles still present in the selected set), the within-hybrid gene diversity `GD_WI_hyb`, the between-pool component `GD_BS` and the statistic `F_ST` $= GD_{BS}/GD_T$." (`rare_retained` from R/01_metrics.R:236; `GD_WI_hyb` = 1 - mean diag f, R/01_metrics.R:150.)
- C4 `tbl-case-study-z`: "Six metrics for each scenario of @tbl-case-study-metrics, in standard deviations from the random-subset null (`B_full` = 80 random subsets of the same size). Less diverse than chance is negative for `z_GD`, `z_Ne_parents` and `z_rare_retained`, and positive for `z_F_drift` and `z_ANE`; `z_GD_BS` has no worse direction." (restates the prose that follows.)
- C5 `tbl-case-study-selection`: "The first eight rows of the selection table `$selection`, ordered by `n_scenarios`: each hybrid with its two parent lines, 1 in a scenario's column if that scenario selects it and 0 otherwise, and `n_scenarios`, the number of the nine scenarios of @tbl-case-study-metrics that select it."
- C6 `tbl-case-study-frontier`: "The DE frontier over DE/null seeds, by grid point `k` (position in the automatic grid). `alpha_req_pct`: mean requested budget $\alpha_{\max}$ (%). `index_ch`, `sd_ch`: mean and standard deviation of the index over seeds at the chapter's DE budget (`NP` = 100, `itermax` = 200). `index_def`, `sd_def`: the same at the package default (`NP` = 300, `itermax` = 2000). `gain`: mean paired gain of the default budget over the chapter budget, seed by seed; `se_gain`: its standard error; `gain_pos`: the number of seeds in which it is positive. Index in standard deviations. Cached by `regenerate.R case_study`." (NP/itermax are hard-coded from the CSV, as checked in the it3 verdict; the figure caption computes them with `np_it()`.)

Prose (old -> new):
- W1 l.12: "DH crosses" -> "doubled-haploid (DH) crosses".
- W2 l.103 (new sentence before the table): "@tbl-case-study-metrics gives the metrics of the nine scenarios of this run."
- W3 l.121: "(the next section does)" -> "(@sec-case-study-lenses does)".
- W4 l.124: "not a constraint:" -> "not a constraint (@tbl-case-study-ns):".
- W5 l.155: "with $GD_S = 1 - \theta_S$" -> "with gene diversity $GD_S = 1 - \theta_S$".
- W6 l.158: "(all three asserted in the chunk above)" -> "(all three asserted in the code of @tbl-case-study-ns)".
- W7 l.166 (new sentence): "@tbl-case-study-lenses gives both lenses and the pool partition for each scenario."
- W8 l.204: "the model has no dominance (see below)" -> "(@sec-case-study-limits)".
- W9 l.207 (new sentence): "@tbl-case-study-z places six of the metrics against the random null."
- W10 l.219: "`ANE` is A-NE, the mean distance" -> "`ANE` is A-NE (accession-to-nearest-entry), the mean distance" (expansion from 06-metric-catalogue.qmd:387).
- W11 l.242-243: "not shown in the table" -> "not shown in @tbl-case-study-z".
- W12 l.247 (new sentence): "@tbl-case-study-selection shows the hybrids selected under the most scenarios."
- W13 l.313: "The table gives the mean ..." -> "@tbl-case-study-frontier gives the mean ...".
- W14 l.493: "in the table above" -> "in @tbl-case-study-metrics".
- W15 l.545: "MAF spectrum" -> "minor allele frequency (MAF) spectrum".
- W16 l.594-596: "`F_drift` is another (above), and ... A-NE and E-NE keeping" -> "(@sec-case-study-lenses), and ... A-NE and E-NE (entry-to-nearest-entry) keeping".
- W17 l.638: "from a VCF to" -> "from a variant call format (VCF) file to".
Left as is: "printed below" (l.182) and "the value printed at this seed" (l.232), which point at the next chunk inside the same paragraph (but see E1).

## 2. Findings passed on

- **12-E1** (quant-Rwrite / book-level) 12:20-21, 81, 189, 259-263, 288, 348. Console output stands in for results: the setup vector (`c(hybrids, markers, f_min, f_max)`), `unlist(res$ref)`, `c(max_deviation_from_Eq3 = ...)`, the selection counts vector, the `kept_tab` matrix (its five columns carry the seed-robustness result of l.291-302) and `trunc_wins`. Because `_quarto.yml` sets `collapse: true` together with `code-fold: true`, this output is merged into the folded code block: in the HTML it is hidden until the reader opens "Show code" (checked in `docs/12-case-study.html`: `f_min` and `max_deviation_from_Eq3` sit inside `<details>`). The prose "printed below" (l.182) therefore points at something the HTML reader does not see. `kept_tab` and the counts vector should become small `kable` tables with `tbl-` labels (chunk code, not done). The `collapse`+`code-fold` interaction is book-wide and goes to the author.
- **12-E2** (quant-writer) units in headers. The six tables use code column names (`alpha`, `index`, `Ns`, `alpha_req_pct`, ...); units (alpha a fraction, index in s.d., `alpha_req_pct` in %) are stated in the captions, not the headers. `alpha` is a fraction in tables 1-3 while the prose and figure use percent. Renaming headers needs `col.names` in a `kable` call these chunks do not have (code change).
- **12-E3** (quant-Rwrite) palette, 12:400, 414. The package-default seed lines are drawn in `book_pal[["A"]]` (#1f5f8b, the pool-A colour) with a non-pool meaning ("package default budget"). Elsewhere in the book that colour means pool A. Suggest `book_pal[["mid"]]` dashed, or another non-pool colour; chunk code, not changed.
- **12-E4** (Typst check, not verified; no render) `fig-case-study-frontier`: a seven-entry legend at `cex = 0.8` placed `bottomright` (l.407). Check in the PDF that it does not overlap the seed lines near alpha 3-4 % at index 1.6-2.0 or the `ref_random` mark. The only existing image (`unnamed-chunk-13-1.png`, the pre-label version) cannot show this.
- **12-E5** (quant-writer) notation. `$B_{full}$` (l.241, also 06:973, 979) is not in `90-notation.qmd`; it is the code argument `B_full` typeset as math. Add it to 90 or write it as code (`B_full`) as the rest of the chapter does. `$\mathbf f$` (l.151, 491) vs `$\mathbf{f}$` in 90: same rendering, no change needed.
- **12-E6** (Typst check) `tbl-case-study-selection` has 13 columns (`hybrid`, `line_A`, `line_B`, nine scenario columns with 13-14-character names such as `DE_alpha_0.98`, `ref_trunc_cap`, and `n_scenarios`). It probably overflows 6.5 in at 10.5 pt. Remedy: transpose, or abbreviate the scenario columns. That is a layout change and a code change, reported only. `tbl-case-study-frontier` (9 columns) and `tbl-case-study-metrics` (9 columns, 4 decimals) should also be checked.
- **12-E7** (quant-writer) decimals. `tbl-case-study-metrics` and `-lenses` round every column to 4 decimals, including counts (`max_line`, `alleles_lost`) and `Ne_*` (prose quotes these to 1-2 decimals); `fmt()` rounds and does not pad, so a column can show mixed decimal widths. Not changed (code).
- **12-E8** (housekeeping, not from this pass) tracked macOS duplicates: `book/_freeze/12-case-study/execute-results/html 2.json`, `.../typ 2.json`, `docs/downloads/12-case-study 2.R`, and `.claude/review/12-case-study/it1-{audit,continuity,refs} 2.md`. CLAUDE.md requires `git ls-files | grep -E ' [0-9]+(\.[A-Za-z0-9]+)?$'` to stay empty; they need an explicit `git rm`.
- **12-E9** (minor, quant-writer) 12:508 "25 x 25 crosses" uses a letter x; the book uses $\times$ in math elsewhere (l.44). Left as is: the same plain "x" appears in 04f and 11b.

## 3. Orphaned figure files

None created by this pass: the only figure chunk already carried `fig-case-study-frontier`, and the new `tbl-` labels sit on chunks that draw nothing. Already orphaned before this pass (from the earlier label addition, recorded in THREAD for deletion at render):
- `book/_freeze/12-case-study/figure-html/unnamed-chunk-13-1.png`
- `book/_freeze/12-case-study/figure-typst/unnamed-chunk-13-1.svg`
- `docs/12-case-study_files/figure-html/unnamed-chunk-13-1.png`
- `docs/12-case-study_files/figure-typst/unnamed-chunk-13-1.svg` (untracked)

`book/_freeze/12-case-study/execute-results/*.json` and `docs/12-case-study.html` are stale until the batch render. Because the `.qmd` changed, the chapter re-executes under `freeze: auto` (about one live `stage2_select()` run).

## 4. Scratch
Tests were run in the session scratchpad only (`tt/`). Nothing was written under `book/` except the chapter and its purled script. `book/figure/` (untracked: `fig-joint-*` from an earlier session) was not touched.
