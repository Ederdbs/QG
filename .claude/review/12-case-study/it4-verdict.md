# 12-case-study -- iteration 4 verdict (form-pass diff only)

Text judged: the form-pass changes to `book/12-case-study.qmd` (working tree, branch `review-pending-chapters`) listed in `.claude/review/12-case-study/editor.md`:
- the six `tbl-cap` strings C1-C6;
- prose edits W1-W17;
- the two heading ids.

The diff was taken against the it3 knitted copy of the chapter (scratch `v12c/knit/ch12.Rmd`). Every hunk is one of C1-C6 or W1-W17, plus the two whitespace changes recorded as 12-M19. Text outside the diff was approved at it3 and is not reopened.

VERDICT: APPROVED

PREVIOUS IDS
- 12-M18 -- CLOSED -- 09:444-446 now reads "warns that the constraint is inoperative ... and then still runs the DE for that scenario and returns its plan under the `DE_alpha_*` label like any other". That matches 12:92-94 and R/11_stage2.R:99-118. THREAD:682 records it as done.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 12-M19 12:252, 12:320 -- The form pass changed two chunk lines. `scn <- setdiff(` became `scn <-setdiff(`, and `fr <- read.csv(` became `fr <-read.csv(`. The space after `<-` was lost when the `#|` lines were inserted. Both lines parse identically, so no number moves. But editor.md's statement that "no chunk code was touched" is not exact, and the two lines propagate into `book/downloads/12-case-study.R`.

Count of open non-disqualifying failures: 1 (12-M19), below the threshold of three.

E FINDINGS OF editor.md -- what is owed now
None of E1-E9 is a defect of content under criteria 1-7. None is a condition of this verdict, and none needs action from quant-writer before the chapter closes.
- 12-E2 (units/percent) -- optional. Two units are in use:
  - The tables, and the prose at 12:424-426, give `alpha` as a fraction. The scenario names, `alpha_req_pct` and the figure use percent.
  - C1, C3 and C6 now state the unit of each column. 12:112-115 states that the name carries the requested budget in percent and the column the achieved loss.
  No number contradicts another.
- 12-E3 (colour) -- optional and book-wide (palette semantics, quant-editor). The figure caption "Blue lines: ... package default" matches the code: `book_pal[["A"]]` = #1f5f8b, which is blue. The caption does not contradict the figure.
- 12-E5 ($B_{full}$ in 90-notation) -- optional and book-wide.
  - 12:241 is the only math instance in 12, and the same notation was present and approved at it3. 06:973 and 06:979 use the same form.
  - The quantity is the same `B_full` = 80 named at 12:42, 217, 228-229 and in C4. This is two typesettings of one quantity, not a redefinition.
  - If it is fixed, it is fixed in 06 and 12 together.
- 12-E6 (table width) -- form, for quant-editor at the batch render. The current PDF predates the labels and renders the same 13-column table as `tbl-case-study-selection` (printed page 557, A4). In that render all 13 columns and 8 rows are present, so no data is lost. Legibility suffers:
  - the `hybrid` header is hyphenated;
  - `line_Aline_B` runs together;
  - the data-frame row names duplicate the hybrid id.
- 12-E1 (console output inside folded code), 12-E4 (legend overlap, needs a render), 12-E7 (decimals), 12-E9 (letter x) -- optional. E1 is a book-wide `collapse` + `code-fold` interaction. The seed-robustness numbers that `kept_tab` carries are all stated inline in 12:291-299, so no result exists only in folded output.
- 12-E8 (tracked duplicates) -- not a text matter and not for quant-writer, but owed under CLAUDE.md by whichever session commits.
  - Six tracked duplicates belong to this chapter: `.claude/review/12-case-study/it1-{audit,continuity,refs} 2.md`, `book/_freeze/12-case-study/execute-results/{html,typ} 2.json` and `docs/downloads/12-case-study 2.R`.
  - Book-wide, `git ls-files | grep -cE ' [0-9]+(\.[A-Za-z0-9]+)?$'` returns 288.
  - These need an explicit `git rm`.

WHAT WAS VERIFIED
- The diff is confined to the declared edits: `diff v12c/knit/ch12.Rmd book/12-case-study.qmd`. Every hunk is C1-C6, W1-W17, the two `{#sec-}` ids or the two whitespace changes of 12-M19. The removed `audit-extra` chunk was my it3 scratch addition, not chapter text.
- C1 hard-coded values. `stage1_simulate(book_cfg)` (`book/_common.R`, `pkgload::load_all` of the checkout) gives:
  - N = 625 and `round(0.1 * 625)` = 62. `res$ref$n_sel` from the it3 knit (`audit.rds`) is 62.
  - `book_cfg`: 25 + 25 lines, m = 2000, seed 1.
  - The `stage2_select()` default is `seed = 1` (R/11_stage2.R:75-76, 84).
  - The it3 knit has five `DE_` scenarios and four `ref_` scenarios.
  - `index` is in s.d.: `build_ctx()` sets `index = scale(scale(traits) %*% weights)` (R/00_data.R:172).
- C6 hard-coded values: `unique(fr[, c("budget","NP","itermax")])` on `book/data/case_study_frontier.csv` gives chapter 100/200 and default 300/2000. The values are pinned three ways:
  - they match `np_it()` in the it3 knit and the `stage2_select()` signature defaults NP = 300, itermax = 2000 (R/11_stage2.R:74);
  - the chunk call hard-codes NP = 100, itermax = 200 (12:33), and 12:45 already hard-codes 300/2000;
  - the `stopifnot` at 12:323-324 ties seed 1 of the chapter budget to the live run.
  The hard-coded caption values therefore agree with the code and the cache. They would not follow a change of `book_cfg` or of the cache automatically, as the figure caption does. That is a maintenance property, not a present inconsistency.
- C6 column definitions were checked against the `front_tab` code (12:334-341):
  - `alpha_req_pct` is the mean over seeds of the requested `alpha_max` of the DE rows;
  - `sd_*` is the s.d. over the 10 seeds;
  - `se_gain` = sd(gain)/sqrt(n_seed);
  - `gain_pos` = count of positive gains.
  The it3 `front_tab` values are consistent with these definitions (for example, `gain_pos` 10/10/10/9/7).
- C3 `rare_retained` described as "the fraction of the candidate pool's rare alleles still present in the selected set":
  - The code computes the share of markers with `maf_pop` in [0.01, 0.05) still segregating, with `maf_pop` taken over the 625 candidates (R/00_data.R:164,174; R/01_metrics.R:222,236).
  - The two descriptions differ only if a selection fixes the pool's minor allele. Recomputed for all nine scenarios of the it3 run (154 rare markers): "segregating" and "minor allele present" give identical shares, equal to the table values (0.8636 ... 0.9481), with 0 fixed minor alleles in every scenario.
- C3 other columns:
  - `GD_WI_hyb` = 1 - mean diag f (R/01_metrics.R:150), the within-individual term of Caballero & Toro;
  - `F_ST` = (f_til - f_bar)/(1 - f_bar) = GD_BS/GD_T (R/01_metrics.R:159).
- C4: z uses the `B_full` draws (R/02_benchmark.R:60-62, read at it3). The sign conventions match 12:217-221, and A-NE "lower means better representation" matches 06:394-402.
- C5 matches the code at 12:253-254: rows ordered by decreasing `n_scenarios`, first 8. The `n_scenarios` distribution in the it3 run is 3 hybrids at 8 and 11 at 7. The table shows the 3 hybrids at 8 and 5 of the 11 at 7, and the caption's "first eight rows" says so.
- Acronyms:
  - A-NE "accession-to-nearest-entry" and E-NE "entry-to-nearest-entry" match 06:387 and @eq-catalogue-ene-ane (06:392-394);
  - DH, MAF and VCF are standard expansions;
  - "gene diversity $GD_S = 1 - \theta_S$" matches @eq-hp-gd / 06.
- Ids and re-pointed references:
  - `{#sec-case-study-lenses}` and `{#sec-case-study-limits}` are unique in book/*.qmd, and no other chapter cites them;
  - W3 now points to the section that reports both lenses (12:164-190);
  - W8 points to the section opening "The model is additive" (12:482);
  - W6: the three identities are asserted in the chunk of @tbl-case-study-ns (12:136-138);
  - W14: `Ne_lines_A/B` are columns of @tbl-case-study-metrics (12:108-109);
  - W11: the relative s.e. is not in @tbl-case-study-z.
- No W edit changes a number, a scope or a claim. W4 places a table pointer after "not a constraint". The supporting reason ("no argument that bounds `Ne_parents`") stays in the sentence and is unchanged.
- 12-M18: 09:440-448 read.
- E6: `pdftotext -layout docs/Genetic-Diversity-in-Hybrid-Breeding.pdf`, lines 31395-31436 (printed page 557), and `pdfinfo` reporting A4 pages.
- E8: `git ls-files | grep -E ' [0-9]+(\.[A-Za-z0-9]+)?$'` lists the six chapter files; with `-c` it returns 288.

NOT VERIFIED
- The rendered HTML and Typst output of the six new captions inside the book: no render was run. editor.md reports a scratch render of the caption strings, and this verdict does not reproduce it. Not decisive for content. The batch render settles it, together with E4 and E6.
