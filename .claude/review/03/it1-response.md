# 03-simulating-crosses -- response, iteration 1

## quant-writer

| ID | Status | Note |
|---|---|---|
| 03-D1 | fixed | Parameter written $F_{BN}$ (display, prose, axis `expression(F[BN])`); stated as each pool's divergence from $p^{*}_k$; $\mathrm{Var}(p_{Ak}-p_{Bk}) = 2F_{BN}p^*q^*$; statistic of @eq-f-stats ~ $F_{BN}/(2-F_{BN})$, value inline from `book_cfg$fst`. 90-notation:129 no longer lists @sec-simulating-crosses among chapters that write it $F_{ST}$. Same edit as 03-R1. |
| 03-D2 | fixed | (a) Sweep now returns $GD_{WS}$, $GD_{BS}$, $GD_T$; chunk `divergence-trade` computes the changes and both ratios inline (measured 1.12 and 1.89 against expectations 1 and 2, cited to @sec-subdivided); identity het fraction = $GD_T + GD_{BS}$ asserted with `stopifnot`; 05b's shared/divergence terms identified with $GD_T$/$GD_{BS}$, "in expectation". "Unit for unit" from within-pool removed; caption no longer claims a one-for-one trade. (b) Pointer now: @tbl-keystone in @sec-subdivided states it and defers the argument to @sec-heterosis. |
| 03-D3 | fixed | Sentence replaced: Cholesky fixes the covariance of effect rows, not realised correlations; max departure inline; rank of Z inline and asserted = $(n_A-1)+(n_B-1)$; expectation over draws declared not measured. "Weighted sum of independent noise / unrealistically easy" removed. |
| 03-D4 | fixed | Prose states the auto-detect assumption (>= 1 dosage-2 call; NA ignored), the ambiguity of {0,1}, the warning and the `coding` argument. Existing demo now asserts the matrix contains dosage-2 calls. New chunk `coding-ambiguous` shows auto vs `coding = "012"` against `molecular_coancestry(X/2)` with `stopifnot`. Depends on quant-Rwrite's `stage1_build(coding=)`; not run here. Package side = 03-R9. |
| 03-D5 | fixed | Superlative deleted. |
| 03-D6 | fixed | `balding1995` added to references.bib (Crossref-verified: Genetica 96(1-2):3-12, 1995, doi:10.1007/BF01441146) and cited; attribution of the exact parametrisation remains as refcheck left it (standard form, full text not read). |
| 03-B1 | fixed | As 03-D6. |
| 03-B2 | fixed | `[@vanraden2008]` cited at the sum(G) sentence. |
| 03-B3 | fixed | As 03-D5. |
| 03-M1 | fixed | Opening paragraph: transition from @sec-coancestry/@sec-subdivided/@sec-response; relation of `simulate_pools()` to `simulate_lines()`/`simulate_data()` (same BN frequencies, lines, factorial; different trait model and random stream). Also covers C11 (03 half) and C12. |
| 03-M2 | fixed | Ancestral frequency $p^{*}_k$; pool frequencies $p_{Ak}$, $p_{Bk}$; 90-notation:390 mapping updated. C8 (03 half). |
| 03-M3 | fixed | `within_pool_f` declared as the group coancestry $\tilde f$ with self-coancestry (02's definition), code comment added; the trade is now stated in $GD_{WS}=1-\tilde f$, $GD_{BS}$, $GD_T$, for which self-inclusion is the definition of @eq-gd-partition. Same edit as 03-R5. |
| 03-M4 | fixed | Caption rewritten (only what is plotted; dashed closed-form expectation added to the plot); prose gives the realised min/max and expectation inline and states the replicate spread was not measured. Same edit as 03-R6. |
| 03-M5 | fixed | `set.seed(cfg$seed + 3)` before the random-subset draw (03-R4). The figure and the printed apparent loss will change at the next render; no prose number depends on them. |
| 03-M6 | fixed | Reworded: the steps are `simulate_data()`; `stage1_simulate()` passes them to `stage1_build()`, whose source is printed. |
| 03-M7 | fixed | `stopifnot` added: only 0/2 in L; sum(G) ~ 0, f in [0,1]; het fraction of each hybrid = 1 - fL[a,b]; het fraction = GD_T + GD_BS; rank(Z); coding invariance; population GD > mean random-subset GD. Beta moments left as algebra (not asserted). |
| C4 (03 half) | fixed | = 03-D1. |
| C8 (03 half) | fixed | = 03-M2. |
| C11 (03 half) | fixed | = 03-M1. |
| C14 | fixed | = 03-D2. |

Also done in passing because it was the same sentence: 03-R7 for 25/625/5041 (inline; 71 stays typed as the declared production scale, since `sim_config` is currently the 50+50 dev config).

Notes for quant-Rwrite:
- `coding-ambiguous` needs `stage1_build(..., coding = NULL | "012" | "0-0.5-1")`, a warning on {0,1}-only auto-detection, and NA-ignoring detection. Install before render.
- Two chunks were added before the second figure (`divergence-trade`, `coding-ambiguous`, plus `coding-invariance` labelled): `unnamed-chunk-15-1.png` will be renumbered; orphans in docs/03-simulating-crosses_files/ and book/_freeze/03-simulating-crosses/ (03-R11). Figure labels left to quant-editor/R11 (a `fig-` label requires an `@fig-` citation).
- All other chunks were run via purl + load_all on the worktree: no error, all stopifnot pass.

## quant-Rwrite

| ID | Status | Note |
|---|---|---|
| 03-D4 / 03-R9 | fixed | `R/10_stage1.R` `stage1_build(..., coding = NULL)`: `"012"` / `"0-0.5-1"` via `match.arg`; NULL auto-detects with `max(X, na.rm = TRUE) > 1`; values only in {0, 1} (NA ignored) -> warning, read as 0/0.5/1; range [0, 1] asserted after rescaling. Roxygen updated, `man/stage1_build.Rd` regenerated. `alphasimr_to_stage1()` now passes `coding = "012"` (AlphaSimR dosage is always 0/1/2; identical whenever a 2 occurs). Bit-for-bit: `identical()` TRUE before vs after for `stage1_simulate(book_cfg)`, `stage1_build(d$X * 2, ...)` on book_cfg data, and a 10+10 dev config, all run with `options(warn = 2)`. Callers: `stage1_simulate` (0/0.5/1 hybrids, contain 0.5 -> no warning), `alphasimr_to_stage1` (declared), test-pipeline 0/0.5/1 and *2 (contain 0.5 / 2), book/03 (only `coding-ambiguous` warns, by design, muffled to a message); `run_all.R`, `12-case-study.qmd` are `eval: false`/commented. Tests added in `test-pipeline.R`: declared 012 gives diag(f) = (2/3, 2/3), f12 = 0.5, f == tcrossprod(cbind(X, 1 - X))/m; auto warns "ambiguous" and returns diag 1; bad `coding` and 0/1/2 declared as 0-0.5-1 error; NA ignored in detection (no warning, X/2 identical, NA propagates into f). |
| 03-R3 | fixed | Writer's stopifnots stand; added the defining identity `f == tcrossprod(cbind(X, 1 - X)) / m` to the ctx chunk's `stopifnot`. Beta moments and het fraction vs closed form left as prose/dashed line (algebra; replicate spread not measured). |
| 03-R2 | fixed | By quant-writer (03-D3). |
| 03-R7 | fixed | Random-subset size now `n_sub <- 60` in the chunk; panel title and prose (`r n_sub`) read it; caption no longer types it; printed name `GD_random_60` -> `GD_random`. "twentyfold" already inline (writer). 71 kept as declared production scale. |
| 03-R8 | fixed | By quant-writer (03-M6). |
| 03-R10 | fixed | Superlative deleted (writer, 03-D5); "zero out" kept, verdict confirms F_hom is also zero with p0 recomputed. |
| 03-R11 | open (editor) | Figure 2 moves from chunk 15 to chunk 17 -> `unnamed-chunk-17-1`. Orphaned at next render: `docs/03-simulating-crosses_files/figure-html/unnamed-chunk-15-1.png`, `book/_freeze/03-simulating-crosses/figure-html/unnamed-chunk-15-1.png`, `book/_freeze/03-simulating-crosses/figure-typst/unnamed-chunk-15-1.svg`. Figure 1 stays `unnamed-chunk-5-1`. |

Results: `devtools::test()` FAIL 0 / WARN 0 / PASS 483; `devtools::check()` 0 errors, 0 warnings, 1 note (worktree `.git`); installed. Chapter purled and sourced from `book/` with `_common.R`: all stopifnot pass, the only warning is the intended one in `coding-ambiguous` (auto 1 / 1 / 0.333 vs declared 0.667 / 0.667 / 0.5). `make_downloads.R` run. Not rendered. Note for writer: `90-notation.qmd:430` and `04c:107` still say "auto-detects" without the {0,1} caveat -- true, but could point to `coding`.

## quant-writer (editor findings)

| ID | Status | Note |
|---|---|---|
| 03-E1 | fixed | $p_{Ak}$, $p_{Bk}$ already in 90-notation (Response table); their row now points to @eq-balding-nichols. New row $p^{*}_k$: ancestral frequency, U[0.05, 0.95], expectation of $p_{Ak}$, $p_{Bk}$; code `p_anc` in `simulate_lines()`. |
| 03-E2 | fixed | Five console outputs -> `fmt()` tables, each cited before it: `tbl-divergence-trade`, `tbl-trait-cor` (target R beside realised), `tbl-ctx-check`, `tbl-coding-ambiguous` (adds the direct `X/2` row), `tbl-gd-baseline`. Computing chunks and every `stopifnot` unchanged; existing labels kept. Purled + sourced from book/: no error. |
| 03-E3 | fixed | `col = book_pal[["ink"]]` (dark neutral reference line, from `_common.R`); caption, fig-alt and prose "red" -> "dark vertical line". |
| 03-E4 | fixed | Caption: index = equally weighted sum of the standardised predicted traits (default `weights` of `build_ctx()`), re-standardised to mean 0, s.d. 1 (`R/00_data.R:171`). |
| 03-E5 | fixed | "The chunk above" -> "The `stopifnot()` in the code of @fig-divergence-het". |

No new figure; no new orphans beyond 03-R11/editor section 3. `make_downloads.R` run; not rendered.
