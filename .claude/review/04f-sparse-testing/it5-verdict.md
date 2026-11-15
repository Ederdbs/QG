# 04f-sparse-testing -- verdict, iteration 5 (narrow check of it4 findings)

Scope: 04f-D16, D17, M18-M21 only (book/04f-sparse-testing.qmd, book/90-notation.qmd T row). Knit by me (knitr::knit, fig.path in scratchpad it5, whole chapter, exit 0, no error, new stopifnot() passes); the four knitted figures were viewed as images. No quant-refcheck or quant-continuity report supplied.

VERDICT: APPROVED

PREVIOUS IDS
- 04f-D16 -- CLOSED -- caption and alt of fig-sparse-estimates now match the image and the data (below); the sentences at 04f:1651 and :1729 ("median slope at k = 1 ... with outliers") say nothing about outliers being confined to k = 1 and remain true.
- 04f-D17 -- CLOSED -- caption now counts five panels, four by hand and the fourth of the five a draw of sparse_alloc(); chunk agrees.
- 04f-M18 -- CLOSED -- alt matches the drawn arrow.
- 04f-M19 -- CLOSED -- alt matches data and image.
- 04f-M20 -- CLOSED -- T row lists T2/T1/T0 with valid cross-references.
- 04f-M21 -- CLOSED -- closing sentence reordered, content and inline z unchanged.
- Earlier IDs (D1-D15, M1-M17) -- remain CLOSED; text untouched in this pass.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
None.

WHAT WAS VERIFIED
- D16 numbers -- Rscript on book/data/sparse_scenarios.csv (183 scenarios, all layer "rapida"): non-converged (frac_conv < 1) by k: 39 / 27 / 9 at k = 1 / 2 / 3, none at k >= 4; all(nc[k == 1]) TRUE; k = 1 has 39 scenarios in total; at k >= 2 slopes of converged scenarios 0.8452-1.0759 (rounded 0.85-1.08), non-converged 0.7865-1.4803 (rounded 0.79-1.48). These equal the caption, the alt and the new stopifnot() in the chunk (which passed in the knit).
- D16 image (f-fig-sparse-estimates-1.png) -- orange points at k = 1, 2 and 3 only; every k = 1 point orange; grey points at k >= 2 within about 0.85-1.08; orange at k = 2 spread 0.79-1.32 and one at k = 3 near 1.48; axis clipped at 0.5-1.5 (two k = 1 scenarios exceed 1.5 and are clipped; none below 0.5). Alt and caption agree with the picture.
- D16 body -- k = 1 slope: median 0.968, max 16,560, so "with outliers" at k = 1 is true; text at 04f:1645-1651 ("every REML fit converged -- all with k >= 2"; "At k = 1 no scenario had every fit converge") agrees with the counts.
- D17 -- chunk fig-sparse-genealogy: mats has five entries (Complete, Incomplete blocks, p-rep + checks, Genomic sparse, Farm-as-inc.-block); only the fourth calls sparse_alloc(4, 3, 4, 2, "random") = 12 hybrids, 4 locations, 2 per hybrid (set.seed(11)); the others are deterministic matrices. Image: five grids, fourth has two dark cells per row. Caption and alt agree.
- M18 -- code arrows(30, 13, 8, 9) starts just under the stage 1 box (x 21-40, y 14-28) and ends at (8, 9), below the DH box (x 1-16, y 14-28); image shows the dashed arrow leaving beneath stage 1, pointing down-left and ending below the DH box without touching it; label "recycle parents (GCA)" below; stage 1 annotation with arrow above. Alt matches.
- M19 -- sparse_genomic_layer.csv aggregated as in the chunk: random, optimised_blocks, parentage have shares 0.25 and 0.5 at 4 and 8 locations; complete has one point (share 1.0) at each (0.839 at 4, 0.940 at 8). Image: solid/circle = 4, dashed/triangle = 8; complete = two isolated points at share 1. Alt and caption agree.
- M20 -- labels sec-heterosis-gca-sca (05b:942) and sec-mating-genomic (04e:1016) exist; 04e:1044-1051 defines the T0/T1/T2 hierarchy, so the row's exclusions are supported.
- M21 -- knit output (out.md:1904-1908): "The result least in doubt is that, at a fixed number of plots, more locations raised accuracy up to about six (result 2): ... beyond two standard errors at both heritabilities, and the four-location step has z = 2.3 at h2 = 0.4 and 1.2 at h2 = 0.2"; same values as verified in it4.

NOT VERIFIED
- Typst/HTML rendering by quarto (figure sizes, table placement; 04f-E8/E9 owed to the render batch) -- not run; form items, not decisive for the content verdict.
- The cached REML study itself -- external, as before.
