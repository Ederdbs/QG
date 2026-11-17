# 11b-diversity-across-cycles -- verdict, iteration 5 (re-review)

VERDICT: APPROVED

Chapter: `book/11b-diversity-across-cycles.qmd` (1043 lines), checkout `/Users/ederdbs/Documents/SB_quanti_gen`, branch `review-pending-chapters`, uncommitted changes against HEAD f5ac861. Judged: closure of 11b-D1 and 11b-M19, the diff against HEAD (diagram chunk lines 76 and 100, prose lines 482-485, the mirrored lines of `book/downloads/11b-diversity-across-cycles.R`) and what depends on it. Content approved at it3/it4 is not re-judged.

## PREVIOUS IDS

- 11b-D1 -- CLOSED -- the note is now `text(70, 30.5, "diversity budget\napplies here")` (line 100), centred on the "select n_sel" box (x 62-78, centre 70) and above it; the standalone redraw (viewed) puts it over the select box, clear of the hybrid box and of the arrows. The fig-alt (line 76) now says "A note above the select n_sel box says the diversity budget applies here, at the selection step", which is what the picture shows; the fig-cap (line 75, unchanged) says "`n_sel` of them are selected (the diversity budget applies at this step)". Figure, caption, alt, prose line 60 and code now agree. In `R/14_cycles.R` `alpha_max` is consumed only by the selector call (line 131, default selector lines 105-108 -> `sel_greedy_budget()`, lines 185-209, where it is compared with the realised loss at line 201); `null_distribution()` (gd_ref), `line_weights()`, `next_pool()` and the injection step never see it. The budget enters at selection only.
- 11b-M19 -- CLOSED -- lines 483-485 now label the windowed reading as exploratory where it is used ("the three windows were drawn after the data were seen, and each window value is a single correlation over pooled run-cycles with no spread attached"). Both halves are true of the computation verified at it4 (windows 2-6 / 7-11 / 12-15 over 75 / 75 / 60 pooled run-cycles, no resampling). The reading "concentrated late in the horizon" / "cycles 2 to 6" occurs nowhere else in the chapter, in `book/*.qmd` or in README (grep), so no unlabelled restatement remains.

## DISQUALIFYING FAILURES

None.

## NON-DISQUALIFYING OBSERVATIONS

None.

## WHAT WAS VERIFIED

- Diff against HEAD (`git diff`): the chapter changes only at line 76 (fig-alt), line 100 (note coordinates and line break) and lines 482-485 (one sentence added, ";" -> "."); no number, inline R expression or label changed. `book/downloads/11b-diversity-across-cycles.R` carries the same three changes and nothing else.
- Diagram: lines 77-101 extracted and drawn standalone at 6.5 x 3.05 in (`scratchpad/it5/run.R`, `book_pal` A `#1f5f8b`, B `#d98e04` as in `book/_common.R:58`); output `scratchpad/it5/diag.png` viewed: note "diversity budget / applies here" directly above "select n_sel", no overlap with the box (box top y = 27, note at y = 30.5) or with the red return arrows.
- Budget placement in code: `grep -n alpha_max R/14_cycles.R` -> lines 81, 84, 102, 106-107, 131, 178, 181, 185-186, 201; the only use inside the cycle loop is line 131.
- Dependents of the M19 sentence: `grep -n "late in the horizon|concentrated|cycles 2 to 6|window"` over the chapter -> lines 470-472 (where the windows are defined and already declared post hoc) and 482-484 only; no other chapter or README quotes them. The exploratory labels at lines 301 and 771 are untouched.

## NOT VERIFIED

- The committed render: `book/_freeze/11b-diversity-across-cycles/` and `docs/` are unchanged in `git status`, so the published diagram still shows the old note position and the old alt until the chapter is re-rendered (`freeze: auto` will re-execute it because the source changed). This concerns the build, not the text judged; not decisive.
- Full knit of the chapter: not re-run, since no executable value outside the diagram changed; the it4 knit (all `stopifnot()` passing) stands for the unchanged chunks.
