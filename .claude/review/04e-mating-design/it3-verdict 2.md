# 04e-mating-design -- verdict, iteration 3 (last allowed; goes to the user if REJECTED)

Chapter: `book/04e-mating-design.qmd` (1,653 lines). Knitted here with `knitr::knit` from `book/` against the worktree: about 45 s, no error, every `stopifnot()` passes (including the new ones for the LS comparison and the frontier reading). `tests/testthat/test-mating.R`: 30 pass, 0 fail.
Read against `it2-verdict.md` and `it2-response.md`. Comstock and Robinson (1948) remains UNVERIFIED; Comstock et al. (1949): title and existence only.

VERDICT: REJECTED

One new disqualifying finding (04e-D19) and one undeclared-assumption finding (04e-D20), both about the cached figures embedded in the chapter. The author's three text fixes (D16, D17, D18) hold. D19 and D20 are narrow. Both author and user should read "Evidence on each side" below.

## PREVIOUS IDS

- 04e-D16 -- CLOSED -- the "about 1 to 3 % and 5 to 10 %" figures are now attributed to DS1 at N_TS = 96. Checked against the Europe PMC full text of PMC10397156 (`it3/mel.xml`): that sentence, "H1 and H2 always smallest for c = 1", and "GCA of I0 and I1 lines resembling H0 and H2" are in the DS1 paragraph. DS2: "essentially the same picture ... some trends amplified"; for N_TS = 96 the H0 difference between c = 1 and c = 4 is larger than in DS1 in all six scenarios; maximum r_a at c = 1 is 0.50-0.65 (low h2) and 0.70-0.85 (high h2); H1 "hardly differed between c = 1, 2, 4". The chapter says exactly that and quotes no DS2 percentage. The crosscheck row carries none of the numbers.
- 04e-D17 -- CLOSED -- see the verification below. "Entirely conditional", "unconditional" and "the only design robust to least squares" no longer occur (grep). Intro result 2, the practical consequence, decision step 1 and the text of node 1 are rewritten from @tbl-mating-ls-vs-tester. All numbers are live and reproduce.
- 04e-D18 -- CLOSED for the chapter text -- the "next unit of money belongs in a larger candidate set" sentence is gone. The reading now matches the CSV (verified below). The same claim survives in the embedded figure; this is filed separately as 04e-D19 and does not reopen the text fix.
- 04e-M16 -- CLOSED for the text -- headline 3 is now a result, and the never-crossed-lines value is labelled "The interpretation, not a result". The same sentence appears as the title of the embedded figure; see 04e-D19.
- 04e-M17 -- CLOSED -- "not distinguished". The s.e. of the genomic CDmean-minus-random difference is 0.0070, 0.0081, 0.0076, 0.0079 over the four configurations (recomputed), so 0.007 to 0.008, and 2 s.e. is 0.014 to 0.016, which supports "up to about 0.016".
- 04e-M18 -- CLOSED -- the typed "one standard error" is removed; the caption says the size is not estimated.
- 04e-M19 -- CLOSED -- `00:104-105` ("attributed to @comstock1948 -- an attribution not verified for this book"), `00:211-213` (1949: title and existence only), `05b:968-974` (same qualifier) and `05b:1036` (title only) read; 04e:224-228 gives the same status. The chapter still words it as unverified, which is the accepted state.
- 04e-M20 -- CLOSED -- "the validation file does not record how sigma^2_e was fixed; this is as the study describes it" (04e:489); V6 reported as it is.
- 04e-M21 -- CLOSED -- the negative claims are restricted to the papers cited in the chapter; "no systematic search" is stated.
- 04e-M22 -- CLOSED -- 1,000 plots / 2 / 40,000 = 1.25 % and 3,000 / 2 / 40,000 = 3.75 %; the chapter prints "1.25 to 3.75 %" (knit output).
- 04e-M23 -- CLOSED -- Sprague, Hull and Griffing are "classically attributed ... not checked at page level" (04e:219-222, 336, 507).
- 04e-M13 -- OPEN -- `_freeze` and `docs/` are stale. Owed to the render batch by instruction.
- Response correction "140 -> 64 matched configurations" -- CONFIRMED -- the knit prints "all 64 such pairs ... largest difference 0".

## DISQUALIFYING FAILURES

- **04e-D19 [criteria 4, 5] `book/figs/mating_frontier.png` (04e:1347, `fig-mating-frontier`) and `book/figs/mating_genomic_tlevel.png` (04e:1066, `fig-mating-genomic`) -- embedded figures restate, as annotations of the data, the two interpretations the text was rewritten to withdraw or demote.**
  (a) `mating_frontier.png` carries the footnote "The frontier flattens above ~150k because the optimum there already uses the full field capacity ... with all 200 lines tested: beyond it extra money should enlarge the candidate set or the field, not the plot count." This is the sentence of 04e-D18 in the figure. The chapter now says the opposite, in the interpretation paragraph: "Whether more money would then be worth a larger candidate set cannot be read from the table, because the grid stops at 200 lines." The grid has n_test in {50, 100, 150, 200} (recomputed). The figure also says "the frontier is sparse factorials throughout" while the chapter says the equality of tester and sparse response is by construction of the scorer.
  (b) `mating_genomic_tlevel.png` has the title "Genomic information pays on hybrids whose parents were never crossed, not on re-ranking tested lines." The chapter labels this "The interpretation, not a result" (headline 3, 04e:84-90 and 1330-1345) and says the sweep does not quantify a gain for never-crossed lines. The figure has no phenotypic T0 comparator (its footnote says that column is absent), so the title is not something the plotted data measure. This is the status confusion of 04e-M16, reintroduced by the figure.
  The chapter's captions neither repeat nor disown these annotations, so a reader sees both statements. The criterion-5 point is a figure contradicting the text, which is within my remit. The criterion-4 point is that interpretation appears as a result in a figure title and footnote.

- **04e-D20 [criterion 2] 04e:1337-1342, 1350-1384 -- the response R = i * rho * sigma_g is reported and interpreted without declaring the selection size that fixes i.**
  The text defines the optimiser's objective as R = i rho sigma_g and tabulates `resp`. The value of i, and therefore the selected fraction, is stated only inside the cached figures: "selecting 20 lines per pool on GCA" (`mating_frontier.png` subtitle) and "selecting the best 100 untested hybrids" (`mating_gain_per_cost.png` subtitle). The two are different estimands. Neither appears in the chapter's text, in @tbl-mating-frontier or in the assumptions list of @sec-mating-reproduce. The chapter itself says that raising c lowers the number of lines and so i, so the frontier ordering (c = 3 vs c = 5, 150 vs 200 lines) depends on this unstated number. An assumption that is used and not declared rejects under criterion 2.

### Evidence on each side (for arbitration)
- Against the author: the figures are embedded as `fig-mating-frontier` and `fig-mating-genomic` in the rendered chapter. The annotation texts are in the images (read here). The text and the figure contradict each other. R's definition is in the text; its parameter is not.
- For the author: the figures are cached external artefacts, marked as such in the "Where the numbers come from" callout, and the chapter's captions are neutral. The annotations are the external study's own wording. The interpretation paragraph, not the figure, is where this book makes its claim. The `sparsex` study cannot be re-run here, so the images cannot be regenerated.
- My reading: a figure shown in the book is part of the book's text. The remedy lies on the author's side, either by not showing the annotation or by stating in the text that it is not endorsed. I do not propose wording.

## NON-DISQUALIFYING OBSERVATIONS

- **04e-M24** 04e:1429 vs 1448-1450 -- node 1 of `fig-mating-decision` reads "Avoid c <= 3 layouts"; step 1 and the practical consequence add circulant c = 5, which is below the best LS tester (-0.129, z = -7.2). The node and the list differ.
- **04e-M25** 04e:224-228 -- "Reciprocal recurrent selection ... is the subject of @comstock1949, cited here for its title and existence only." The title quoted in 05b ("a breeding procedure designed to make maximum use of both general and specific combining ability") does not name reciprocal recurrent selection. The sentence gives a subject, which goes beyond title and existence. 00:211 words it through Kadoumi 2025. Also, the Melchinger 2023 abstract says that for GCA of I1 lines and for H1 and H2 hybrids "c = 1 yielded lowest r_a with concordant results ... for both data sets". The chapter restricts "lowest at c = 1" to DS1 and reports H1 as hardly differing in DS2, which follows the results paragraph. The two statements in the paper do not fully agree, and the chapter shows only one of them.
- **04e-M26** 04e:1345 -- `fig-mating-gain-cost` is never cited in the text (no callout in the chapter), and its caption says "Left ... Right ..." while the image has one panel. The image ranks designs by "gain from selecting the best 100 untested hybrids per 1000 currency units", an estimand different from R and not discussed. Form belongs to `quant-editor`; the unused estimand is flagged here.
- 04e-M13 (above) stays open.
Four non-disqualifying items are open (M13, M24, M25, M26). M13 is owed to the render batch by instruction, and M24-M26 are light. The count of three or more would reject on its own, and I record it. The verdict rests on D19 and D20 and does not need it.

## WHAT WAS VERIFIED

- Knit -- `knitr::knit("04e-mating-design.qmd")` in the worktree `book/`: 44.8 s, no error, md at `it3/04e.md`. Test file `test-mating.R`: PASS 30, FAIL 0.
- Melchinger 2023 -- Europe PMC XML (curl, PMC10397156): sentences as in D16 above. "depends on the size and resources of the breeding program" is in the abstract. Chapter text 04e:725-739 and the crosscheck row 1240 agree with the paper for what they state. A reading as in M25.
- @tbl-mating-ls-vs-tester -- recomputed from `mating_scenarios_summary.csv` (LS, 2,000 plots) and `mating_core_sweep.csv`. Best LS tester k=4 0.6704 (core 0.6710). random c=10 0.7565 (+0.086, z 18.1; core 0.760); relationship-guided c=5 0.7404 (+0.070, z 11.5; 998.9 hybrids); NC II 0.7370 (+0.067, z 13.3; core 0.756); circulant c=10 0.7066 (+0.036, z 4.3; core 0.615, below the core tester 0.671); random c=5 0.6888 (+0.018, z 3.10; core 0.697). The 7 below: relationship-guided c=3 -0.035 (z -4.9), A-optimal c=3 -0.044, random c=3 -0.083, circulant c=5 -0.129, random c=2 -0.254, circulant c=3 -0.415, circulant c=2 -0.536. 5 + 7 = 12 designs. The three BLUP-side numbers in the text: penalty 0.498 (c=2), 0.472 (c=3), 0.125 maximum for the BLUP sparse-over-tester difference, testers 0.001-0.007. Ranks 23 to 7 and 24 to 14 of 24 appear in the knit.
- Frontier -- `mating_optimizer_frontier.csv`: grid n_test {50, 100, 150, 200}, c_or_k {1, 2, 3, 4, 5, 10}, reps {1..4}. Optima: 60,000 150/5/1 (resp 6.05); 80,000 200/3/2 (6.789); 100,000 200/3/3 (7.365); 125,000 200/3/4 (7.714); 150,000 and 200,000 200/5/3, 3,000 plots, cost 132,300, resp 8.0861 for both. 64 matched tester/sparse configurations, response identical (max difference 0). resp_per_1000 0.102 to 0.061. The chapter's `stopifnot()` reading of the table passes.
- Genomic cells -- 6 winning rows, 3 distinct cells (z 2.46, 4.52, 4.25); CDmean vs random z genomic 0.21, 0.17, 0.03, -0.02; phenotypic -1.2, -0.8, -3.8, -4.2 (knit output). s.e. of the difference as in M17.
- Figures read: `mating_frontier.png`, `mating_genomic_tlevel.png`, `mating_gain_per_cost.png` (annotation texts quoted in D19, D20, M26).
- M22 arithmetic: 1.25 % and 3.75 %.
- Edits to `00-hybrid-programme.qmd` and `05b-heterosis-dominance.qmd` read (lines near 104-105, 211-213, 968-974, 1036): consistent with 04e.

## NOT VERIFIED

- Comstock and Robinson (1948) as the origin of the NC layouts and of Design II. UNVERIFIED, and worded as such by the chapter. It is not decisive.
- Hallauer et al. (2010), Sprague 1942, Hull 1945 and Griffing 1956 at page level. The chapter says "not checked at page level".
- Provenance statements about the external `sparsex` study (founder engine, replicate unit, how sigma^2_e was fixed, the estimand of the accuracies, 1,000 markers). Not in the repository.
- Byte identity of `mating_core_sweep.csv` with `regenerate.R mating` (04e:140-ish, "reproduced byte for byte"). Not re-run (about 7 min and it rewrites a tracked file). It relies on the iteration-1 audit.
- Source-level re-reading of Chaingeni 2025, Fritsche-Neto 2021, Kinghorn 2011, Technow 2019, Lorenzi 2024, Thomsen 2026 and Burdo 2021. They are accepted from `it1-refs.md`.
- Whether the value of i behind the cached `resp` is 20 per pool: read from a figure subtitle only. The CSV carries no i.
