# Verdict: book/03-simulating-crosses.qmd (iteration 4, form-diff check)

VERDICT: APPROVED

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05, branch review-01-05. Scope: what the form pass changed after my iteration-3 APPROVED (editor.md mechanical fixes, E1/E2/E3/E6, E7-E9). Read: it3-verdict.md, editor.md, editor-response.md, the whole current chapter (728 lines), it1/it2 responses and verdicts for the earlier printed numbers. Note: there is no committed snapshot of the iteration-3 text (the worktree is uncommitted; _freeze/html.json is a pre-review render), so "unchanged" was checked against the numbers quoted in it1/it2/it3 verdicts and responses, not against a text diff.

## DISQUALIFYING FAILURES

None.

## NON-DISQUALIFYING OBSERVATIONS

- 03-M16 03:164 (alt_het) vs 03:312-316 -- fig-alt says "the single-draw points stay flat along a dashed horizontal line". On the zoomed axis the six points scatter visibly (0.3617 to 0.3663, rendered PNG), and the body says the figure by itself cannot separate a flat line from a small trend. The alt text states a reading ("stay flat") that the body withholds from the figure. The zoom and the replicate bars are declared, so the figure is not dishonest; the alt wording is stronger than the body.
- 03-M17 03:314 -- "the range of the figure (0.0046)": after the zoom, the vertical range of the figure is about 0.0125 (axis of the draws plus 25 % margin each side); 0.0046 is the range of the six single draws. The phrase was correct before the zoom and is now ambiguous. The number itself is right (range of d$het_fraction).

Counts: disqualifying 0, non-disqualifying 2 (below the three that reject).

## Judgement of the specific points asked

- E3, balding1995: "From @balding1995 this chapter takes the name of the model and the idea of expressing the divergence ... in a single parameter; the Beta densities and the reading of F_BN are this book's own specification ... not quoted from that paper; the book attributes to @balding1995 no particular parameterisation." Consistent with the limited attribution: the single-parameter idea and the name are attributed, the parameterisation is not, and the two statements do not contradict each other. The removed "(its own parameterisation was not read for this chapter)" was a disclosure about the author's reading; what remains states exactly what is and is not attributed, which is what criterion 7 needs. No failure.
- E6, callout: four bullets plus lead-in. Nothing strengthened. Every element of the M6 closure is present: maximality over every feasible selection ("for a given candidate set and a given constraint on diversity"); the book's gains are greedy, DE and local search, not certified optima at book scale (@sec-bound; `ocs_bound()` valid bound; `sel_exact()` does not converge there); a feasible selection is not a bound; a gain in `ctx$index` does not bound the gain of a selection on estimates; scope limited to the index; additive only. The parenthetical of my it3 summary (the diversity constraint does not depend on the traits, hence an estimate-based selection is feasible for the same problem) is no longer attached to the optimum bullet; the same fact survives in the Scope bullet ("diversity metrics, which do not depend on the traits"). The justification is slightly thinner, the claim is not stronger. I cannot confirm what the exact iteration-3 sentence was (no snapshot); the editor says "moved verbatim". Not a failure.
- E7-E9, figure honesty (rendered fig-divergence-het-1.png from the knit, looked at it): the vertical axis is zoomed (tick labels 0.360 to 0.370), declared in the caption ("zoomed to the range of the draws, not 0 to 1") and in the alt. The replicate mean +/- s.d. squares at both ends, the bars (s.d. 0.003 and 0.006) and the dashed expectation are visible; the single-draw scatter is not hidden, it is the same size as the bars, and the line is not made to look like a trend (it zigzags inside the bars). The zoom makes a flat line look jagged, but the bars on the same axis give the scale of that jaggedness, which is what the body text argues. Legend matches caption (single draw, mean +/- s.d. 200 draws, expectation). Caption and alt numbers come from code: n_rep 200, seeds 1 to 200, het_exp 0.365, means 0.365/0.365, s.d. 0.003/0.006 (0.0033/0.0059 in the text). Honest; see 03-M16 and 03-M17 for the two wording residues.
- tbl-divergence-grid col.names: F_BN, mean line coancestry, tilde f, het. fraction, GD_WS, GD_BS, GD_T agree with the caption and the body (tilde f = group coancestry within a pool, self-coancestry included; the 0.15 row 0.6383 / 0.7055 / 0.3617 / 0.2945 / 0.0336 / 0.3281 matches het = 1 - mean f_AB = GD_T + GD_BS to the printed digits).
- tbl-line-genotypes caption: "No element of the whole matrix takes another value (asserted in the chunk)" is true (`stopifnot(all(L %in% c(0, 2)))`).

## Owed rows (not 03 defects; each names its chapter)

| Row | Chapter |
|---|---|
| 03-E4: no row for the over-factorial mean line coancestry (bar f^L_AB, `between_pool_f`) and for q* = 1 - p*; p* Terms entry as in it3 | 90 |
| Remaining it3 rows (04:15, 04e:35-37, 08b:9-13 misquote, 11b:102 and 12:170 "optimistic ceiling") unchanged, owed to their own reviews | 04, 04e, 08b, 11b, 12 |

## WHAT WAS VERIFIED

- Whole chapter knitted against the worktree package in a scratch directory (scratchpad .../it4/k.R, pkgload::load_all("..") from book/, knitr::knit, fig.path in scratch): "KNIT OK 3.2 s". Every `stopifnot` in the chapter passes (grid identity, row-at-book_cfg$fst tied to L, rank_Z == 48, G sum, f identity, het identity, simulate_data equality, p0, coding invariance and ambiguous coding, L in {0, 2}, simulate_pools identical lines and X). Only message: the expected "ambiguous coding" warning.
- Numbers after the form pass equal the earlier iterations' values (it2-verdict.md:72-73, it1-response.md:89): grid row 0.15 = 0.6383 / 0.7055 / 0.3617 / GD_WS 0.2945 / GD_BS 0.0336 / GD_T 0.3281; heterozygous range 0.3617-0.3663 (0.0046); expectation 0.3650; changes -0.1323, 0.0674, -0.0649; single-draw ratios 1.0387 / 1.9627 (printed 1.04, 1.96); replicates (seeds 1 to 200) het mean 0.3651 with s.d. 0.0033 at 0.02 and 0.0059 at 0.40; paired change 2.2e-6, s.e. 4.0e-4; replicate ratio means 1.005 and 2.003, s.d. 0.086 and 0.086; tbl-gd-baseline apparent loss 0.681 %, s.e. 3.8e-5, gap 59 s.e. (as in it2-verdict.md:25). Trait correlations 0.259 / -0.440 / 0.049, max departure 0.140, rank 48: identical to the pre-review freeze render.
- Seed order: the moved chunk (`divergence-trade-replicates`) is RNG-independent of the others. `simulate_lines()` calls `set.seed(cfg$seed)` itself (R/00_data.R:39), `simulate_data()` sets `cfg$seed + 99` (R/00_data.R:127), and the chunks that draw outside the package seed explicitly (`set.seed(cfg$seed + 99)` in the traits chunk, `cfg$seed + 3` in fig-candidate-pool). Moving the chunk therefore cannot change any later number, and the printed values above confirm it.
- Cross-references: every @sec/@tbl/@fig/@eq target of the chapter resolves to a label in the book (script over the qmd files; no unresolved), every citation key resolves in references.bib, no remaining positional "above/below/next section" reference (only the code comment at 03:256 and the words "above 1", "sits above it").
- Rendered figure inspected (fig-divergence-het-1.png, scratch). No book/Rplots.pdf and no book/figure/ created or left; no tracked file edited; nothing committed. Scratch output only under the scratchpad directory.

## NOT VERIFIED

- Quarto render of 03 to HTML or Typst (kable tables with TeX in headers and cells, deparse listings, figure placement and size in the PDF): only knitr was run. The editor reports a scratch render of such tables to both formats; I did not repeat it. Form matter, non-decisive for content.
- Exact iteration-3 wording of the callout and of the Balding sentence (no snapshot); judged on the current text and on the statements in it2/it3.
- balding1995 and vanraden2008 remain attributions limited to what is verifiable (name and one-parameter idea; the matrix by name), as in it3; not decisive.
