
# 09-optimal-contributions -- response to editor.md (09-E1..E7) and it2-verdict M7-M12

Knit-check: chapter code knitted end to end (knitr, 2 min 44 s, no error, every `stopifnot` passed); scratch outside the repo; `book/figure`, `Rplots.pdf` absent; `book/scripts/make_downloads.R` re-run. Not rendered with Quarto: the two `row.names = FALSE` arguments added after the knit are the only code not executed. No number, assertion or seed changed; the figure colours are the same hex values via `book_pal` except the frontier line.

| ID | Status | Note |
|---|---|---|
| 09-E1 / 09-M9 | fixed | `book/90-notation.qmd`, "Selection and optimisation" table: four rows, $\alpha_{\text{trunc}}$ (link @sec-ocs, @sec-baseline), $\theta_{\max}$ (@eq-ocs-theta-max), $V(\lambda)$ (@eq-ocs-V), $\bar u_S$ (@eq-ocs-problem). |
| 09-E2 | fixed | "(see the warning below)" -> "(the callout on `null_distribution()` below)". No callout ids adopted. |
| 09-E3 | fixed | 8 tables (not 11: the chapter has 8 `tbl-ocs-*`) now `knitr::kable(fmt(...), col.names = ...)` with symbols; captions' raw-name keys rewritten to match; `row.names = FALSE` on tbl-ocs-frontier and tbl-ocs-thin (the knit showed a blank row-name column). |
| 09-E4 | fixed | fig-ocs-relaxation and fig-ocs-frontier use `book_pal` (`loss`, `mid`); greedy frontier line now `book_pal[["ink"]]`, not pool-A blue. |
| 09-E5 | owed | For the render batch (Typst): widths of tbl-ocs-relaxation (6 columns, now with math headers) and tbl-ocs-thin (7 columns, longer headers); fig-ocs-relaxation legend (`bottomright`, four entries) against the greedy points and the `random`/`trunc_cap`/`truncation` labels; fig-ocs-frontier "truncation" label; orphan `unnamed-chunk-*` files listed in editor.md section 4. Not verified: no render. |
| 09-E6 | fixed | "Quote alpha_trunc and the budget with the panel that produced them": `callout-tip` -> `callout-warning`; 27 `callout-warning` uses in 10 chapters are traps of the same kind (a wrong comparison), so this follows the book. |
| 09-E7 | contested (no action) | Style notes: plain "x" in code-adjacent text kept, consistent with the book. |
| 09-M7 | fixed (softened) | The unsupported "the same count is not enough at larger lambda" is removed; the text now says the chapter does not measure larger lambda or N and that `ocs_bound()` checks the change per grid rather than assuming. The reviewer's 4000 vs 64000 differences (4.1e-5 at lambda 30 down to 6.3e-8 at 1000) are not typed into the text (not produced by a chunk). |
| 09-M8 | fixed | Text: the 1e-3 is the same relative `tol` as in `ocs_bound()` but applied to V at lambda = 10, whereas `ocs_bound()` applies it to V + lambda theta_max; "converged" is a stalling criterion, not a certificate (also stated where `ocs_bound()` is introduced). Chunk comment changed to "the tol of ocs_bound(), applied here to V". |
| 09-M10 | fixed | "no bias detected, at a resolution of about 0.002 (two standard errors at 250 markers, against a mean full-panel alpha_trunc of 0.037), so a bias of a few percent of alpha_trunc is not excluded". 0.002 and 0.037 are inline chunk values. |
| 09-M11 | fixed | Assumption 3 rewritten: exact optimiser, true index of the plan found on truth >= that found on predictions; the chapter's plans are heuristics and the statement is not extended to them. |
| 09-M12 | listed, not touched | Other chapters: 07:1053-1054 (Gomez-Romano "factor of two" attributed to @sec-ocs), 10b:641-643 ("a discrete plan can beat it, and does"), 02b:745-756 ("not read for this book" vs 09), CLAUDE.md ("at the same diversity ... can beat it"), 10b:1245 pointer. |

## Every prose/caption wording change (this pass)

1. Assumption 3 (M11), as above.
2. Text before the relaxation chunk: "until the value changes by less than a relative `tol = 1e-3`, and carries a `converged` attribute" -> "until the bound value $V(\lambda)+\lambda\theta_{\max}$ changes by less than a relative `tol = 1e-3`, and carries a `converged` attribute (a stalling criterion on the doubling, not a certificate)".
3. Convergence paragraph: relative-change sentence, tolerance sentence, "Converged here means ..." sentence replaced (M7, M8).
4. Thinning paragraph: "(see the warning below)" (E2); final sentence "a thin panel does not bias the ceiling on average ..." replaced (M10).
5. Callout type tip -> warning (E6); title and body unchanged.
6. Captions: tbl-ocs-penalty ("overshoot:/price:" -> "columns: ... $\alpha_{\max}$ ... overshoot ... price"); tbl-ocs-relaxation, tbl-ocs-convergence, tbl-ocs-frontier ("index:/theta:/V:/w:/alpha:/Ne_par:" keys -> "columns:" with symbols); tbl-ocs-panel-seed1 (gd_ref, alpha_trunc -> symbols); tbl-ocs-thin ("rel_sd", "within_1sd", "se" keys -> "rel. s.d.", "draws within 1 s.d.", "s.e. of bias"); tbl-ocs-qp ("n_used", "share_A" -> "lines used", "share of pool A").
7. QP prose: "which `n_used` shows" -> "which the lines-used column shows"; "`share_A` shows what that permits" -> "the share of pool A shows what that permits".
8. `book/90-notation.qmd`: four rows (E1).
