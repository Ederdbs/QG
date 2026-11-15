# 04c render re-check -- response

| ID | Item | Status | Where |
|---|---|---|---|
| RC-1 | HTML and PDF come from two executions with different MaCS founder draws (section 3, "not disclosed") | fixed | `book/04c-alphasimr-pipeline.qmd`, paragraph after the three rules of the callout "Founders from MaCS". States the mechanism only; no render-specific value is typed. |
| RC-2 | Covariance term at split 10 (|t| near the unadjusted point, below Bonferroni) can flip between renders; "a term within that point is not shown to differ from zero" silent about it (section 4) | fixed | multiplicity/inference paragraph: one sentence added after "which is not a bound on its size"; the bounds are inline R (`cov_t_crit`, `t_bonf_sweep`), so the sentence does not hard-code 2.2/2.09/3.01. |
| RC-3 | T4: "R's stream unchanged by the difference" incoherent if a render returns identical haplotypes | fixed | callout now reads "with R's stream identical after both calls (asserted in the chunk)", true in both branches (`stopifnot(identical(rs_ma, rs_mb))`). |
| RC-4 | T17 (stage-2 ceiling regime differs between formats) | covered by RC-1 | the new paragraph names the sign of the stage-2 ceiling among founder-dependent quantities; the conditional passage is unchanged. |
| RC-5 | Typst warning "Could not convert TeX math d_k / |a_k|" | fixed | `book/90-notation.qmd` line 561: `\lvert a_k \rvert`. grep of all chapters found no other `|` inside math in a pipe-table row or R-built table cell (other hits are cell separators between two math spans, or `\mid` already). Absolute values in prose/code untouched. |

Not done, by instruction: no Quarto render (the Typst warning fix is unverified until the next render); `CLAUDE.md` and `R/` untouched. `make_downloads.R` run. The worktree already carried uncommitted changes from earlier review iterations (visible in `git status`); this edit adds only the hunks above.

| ID | Item | Status | Where |
|---|---|---|---|
| 04c-D1 | Callout paragraph asserted "every number ... differs", "a re-execution of either differs" and "what was measured is that the two formats were produced by different draws" | fixed | `book/04c-alphasimr-pipeline.qmd`, last paragraph of "Founders from MaCS". Now states only the build mechanism (separate `html.json`/`typ.json` executions, each re-calling the founder draw), that coincidence of two draws is not established for `runMacs2()` (one `runMacs()` pair measured per render, `runMacs2()` unmeasured), that founder-dependent numbers therefore *may* differ between formats, and that no conclusion should rest on a value near a critical value. The three removed sentences are gone. |
| 04c-M1 | "not stable across executions" rests on one unstated pair; "no verdict above depends" lacks scope | fixed | covariance paragraph: now conditional ("If the founders differ ... could fall on either side"), and scoped to "no inference drawn in this paragraph"; the render's wording and counts are said to depend on it. |
| 04c-M2 | `runMacs()` "draws one seed per chromosome (`sample.int()`)" typed as fact, no source | fixed | mechanism sentence removed; the text keeps only what the chunk asserts (identical `.Random.seed` after both calls) and its consequence. |

No Quarto render; `make_downloads.R` run.
