# 00-hybrid-programme -- iteration 1, production editor

File: book/00-hybrid-programme.qmd (worktree SB_quanti_gen-review). Line numbers are
after the edits below. Not rendered.

## 1. Edits applied

Tables (checklist 2)
- :147-155 stage table: added caption + label `{#tbl-hp-stages}`; cited before it at
  :145 ("The names, listed in @tbl-hp-stages, are used throughout the book.").
- :557-567 reading-map table: added caption + label `{#tbl-hp-reading-map}`; one
  citing sentence at :553 under the heading.

Figures (checklist 1)
- :172 `fig-hp-cycle` caption: "A x B" -> "A $\\times$ B" (YAML-escaped, same form as
  04-f2-sizing), "S1-S4" -> "S1--S4". Label unchanged; fig-alt left plain text.

Text (checklist 5)
- :19 "A1-A8" -> "A1--A8"; :486 `[@falconer1996, ch. 3-4]` -> `ch. 3--4` (ranges as
  en dash).

Checked, no change needed: all `@sec/@eq/@fig` targets resolve; all citation keys
exist in references.bib; 4 equations labelled and cited; figure labelled, captioned,
alt-texted, cited (:168) before it appears; palette via `book_pal`; no callouts; no
footnotes; headings in sentence case; DH, GCA, SCA, IBD, IBS defined at first use.
No chunk code touched.

## 2. Findings passed to quant-writer

- 00-E1 book/00-hybrid-programme.qmd:42, :125, :243, :333, :403, :447, :508 -- seven
  chunks print a named vector/matrix to the console (`c(...)`, `fmt(...)`) as their
  visible result; checklist 2 forbids raw console output standing in for a table. Either
  turn the ones that carry results (hp-subset-gd, hp-heterozygosity, hp-ibs-ibd,
  hp-drift) into `#| tbl-cap` + `knitr::kable()` tables cited with `@tbl-`, or declare
  them as verification echoes (prose already reports every number inline). Code change
  -> writer / quant-Rwrite.
- 00-E2 :246 and :217-222 -- the symbol $GD$ and the group coancestry ("expected group
  coancestry", $\bar f_d$) are used in "Where diversity is lost" before they are defined
  (@eq-hp-gd at :308, group coancestry at :428). Needs a forward pointer
  (@eq-hp-gd / @sec-hp-popgen) or a reorder; wording is the writer's.
- 00-E3 :256 -- $\alpha$ is used without definition in this chapter; the chapter
  elsewhere (:158) names only the budget $\alpha_{\max}$. Define it or point to where it
  is defined.
- 00-E4 notation -- symbols used here and absent from book/90-notation.qmd: $\bar f_d$,
  $\bar f_o$ (:220; also 06-metric-catalogue), $a_k$ additive effect (:99, :139),
  $\delta u_{ik}$ as a listed symbol (:99-103; appears only inside definitions there),
  $F_{(ab)}$ (:439). Add rows to 90-notation or report back.
- 00-E5 :203, :206 (figure `fig-hp-cycle`) -- the two recycling arrowheads are drawn
  with `lty = 2`, so the head itself is dashed and renders as a stray dot beside the
  arrow tip at both S1 boxes (visible in figure-html/fig-hp-cycle-1.png). Fix is code
  (draw the head with `lty = 1`); not applied per checklist 6.

## 3. Orphaned figure files

None. No chunk added, removed or relabelled by these edits; `fig-hp-cycle-1.{png,svg}`
keeps its name. The chapter re-executes on the next render (source changed); the
`typ.json` freeze is already stale from the writer's pass and needs the full render.
