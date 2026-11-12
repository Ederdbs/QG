# 04c -- re-check of hand-written claims against the NEW render

Sources compared: docs/04c-alphasimr-pipeline.html (05:02), book/_freeze/04c-alphasimr-pipeline/execute-results/html.json (04:55),
.../typ.json (04:57), docs/Genetic-Diversity-in-Hybrid-Breeding.pdf (pdftotext, line 16358). Chapter source not edited.

## 0. Headline

- No hand-written claim in the HTML render is false.
- The HTML and the Typst/PDF render of the SAME chapter are two independent executions (04:55 vs 04:57; MaCS/runMacs2
  founders are not seeded). They disagree in numbers AND in three verdict branches (section 3). Each is internally
  consistent (the verdict branches are inline R), but the two published artefacts say different things.
  Quarto executes once per format here, so "render the book" always yields this divergence for 04c.
- Almost every verdict is inline R (safe). The typed claims at risk are few and listed in section 2.

## 1. Inline-computed (re-evaluated at render, cannot go stale)

Branch/verdict text driven by R in the chunk text (all self-consistent in both formats):
- runMacs pair "were identical / differed" (+ callout "returned identical / different")  -> HTML: differed (same_twice FALSE, stream TRUE)
- r^2 "runMacs adjacent = N x floor" -> 13x (HTML), 0.1267/0.0101 = 12.5 -> "12-13x" (PDF)
- accuracy grid: max|z| vs t crit "within both points" -> 1.63 (<2.09, <3.07): within
- all F_ST/GD_T/GD_BS/maf/ascertainment numbers; "additive vs dominance accounts for more" branch; cov "beyond at split = X / within at every split";
  GCA_var_dom contrast verdict; ratio-contrast "beyond/within"
- sweep multiplicity: n_tests_sweep = 7, Bonferroni 3.01, "k of 7 beyond", "m beyond unadjusted"
- paired table: n_tests = 11, t_crit 2.01, Bonferroni 2.98, every verdict() word, "exceeds / does not exceed", "supported reading" branch,
  "at least one ... Bonferroni", ratio diff/sd 0.7
- Step 7 text numbers, Step 6 percentages, dominance weights, Jensen 0.8 percent

## 2. Typed (hand-written) claims, checked against the HTML render

| # | claim (qmd line) | rendered value (HTML) | holds? | risk on re-execution |
|---|---|---|---|---|
| T1 | "runMacs() takes seconds" (217) | 3.77 s | yes | low (machine-dependent) |
| T2 | quickHaplo adjacent r^2 "sits on the noise floor" (283) | 0.0103 vs 0.0101 | yes | none (deterministic) |
| T3 | runMacs "overall r^2 barely above" floor (286) | 0.0119 vs 0.0101 | yes | low |
| T4 | callout: "with R's stream unchanged by the difference" (229) | stream TRUE, geno differed | yes | NOTE: if a render returns identical haplotypes the phrase "unchanged by the difference" is incoherent (branch "returned identical" + "unchanged by the difference") |
| T5 | F_ST, GD_BS, heterosis share steps "many standard deviations wide" (1642) | F_ST .020/.046/.261/.564, s.d. .002/.004/.011/.017; GD_BS .006/.014/.078/.188, s.d. .001/.001/.004/.009 | yes | none (PDF: same) |
| T6 | "GD_T does not stay flat" (1645) | .309/.307/.298/.333; 100->1000 = +0.035, 16 SE | yes | low |
| T7 | "rise in GD_T comes entirely from sites fixed for opposite alleles ... diversity at every other site falls" (1671-1674) | GD_T_fixed 0->.092, GD_T_other .309/.307/.293/.241 | yes for 100->1000; the 0->10 step (-.002) has no s.d. shown or test | declared exploratory; minor |
| T8 | "an additive part that falls with divergence" (1740) | GCA_var_add .465/.494/.366/.233 (non-monotone: split 10 > split 0) | holds 0->1000 only | PDF: .513/.489/.368/.213 |
| T9 | "so the ratio can rise without the dominance part growing at all" (1742) | var_dom .051->.049, t = -0.2 | yes | PDF also (t = -0.9) |
| T10 | "Both correlations are below the 0.997 of Step 6" (1709) | .950, .906 < .997 | yes | inline numbers |
| T11 | "Accuracy rises with both [testers, locations]" (1233) | observed monotone in both (.371 .521 .620 .752 / .622 .733 .843 .922) | yes | deterministic |
| T12 | Step 8 in "low-accuracy corner" (1257) | t=2,r=1: predicted .513 | yes | deterministic |
| T13 | Step 7: "phenotypic one ... much weaker", "realised ratio is lower", "both indices put most aggregate into trait 2", "G nowhere near a multiple of P" (1291-1369) | -0.08 vs -0.42; h2 .47/.072 < .6/.1; .361/.372, .329/.373 | yes | deterministic |
| T14 | pooling "does what it should" for gd; "does not reduce that noise" for mean_tc (2108-2114) | gd: r .20, pooled .020 vs .018 indep; mean_tc: r .85, pooled 1.008 vs sd_A 1.073 / sd_B 1.024 | yes (the claim "does not reduce" is right: pooled s.d. ~ per-pool s.d.) | PDF same direction |
| T15 | "6 elites recombined into 12 individuals is a bottleneck ... the control loses gene diversity too" (2124) | control loss .504/.508 | yes | |
| T16 | "so a single draw does not settle its sign" (2149) | 0.014/0.020 = 0.7 | yes | |
| T17 | stage2 passage "Depending on the draw ... every DE_alpha row coincides with ref_truncation" (2218-2223) | HTML: ceiling POSITIVE (ref_truncation alpha +0.0088), DE_alpha_0.00/0.22/0.44 = -0.0043, 0.66 = +0.0048, only 0.88 = ref_truncation; no rows coincide except the top budget | not false (conditional, "may") but the case described is NOT realised in HTML; it IS realised in PDF (all five DE_alpha rows = ref_truncation = -0.0051; labels DE_alpha_-0.13...-0.51) | the two formats show different regimes under one caption |

Everything else typed is a design constant (n=60, 1000 QTL, 400 lineages, 20 draws, 4000 MC replicates, seeds) and matches the output.
Counts: "11" paired tests = length(metrics) = 11 rows in table; "7" sweep tests = 2 contrasts + dom contrast + 4 covariance terms.

## 3. HTML vs PDF: same chapter, two executions

| quantity | HTML (docs .html, html.json) | PDF (typ.json, pdftotext) |
|---|---|---|
| sweep: tests beyond Bonferroni 3.01 | 2 of 7 (ratio t=3.8, cor t=-3.7) | 2 of 7 (t=5.4, -5.3) |
| sweep: beyond unadjusted 2.09 | 3 (adds cov at split 10, 2.23) | 2 |
| cov(add,dom) text | "beyond the 5% point at split = 10" | "within ... at every split" (max 1.65) |
| GCA_cov2 split 0 -> 1000 | -0.009 -> -0.023 (sign flips across splits: -,-,+,-) | -0.012 -> +0.003 |
| gca_only add / dom | .184 / .096 | .207 / .082 |
| pooled gd_elite t / gd_pool t | -5.0 / -5.0 | -3.7 / -3.5 |
| gd_A, gd_B paired t | -3.6, -4.0 (all beyond 2.98) | -2.5, -3.1 (gd_A not beyond Bonferroni; pooled are) |
| hybrid_meanG diff (t) | +3.20 (17.7) | +3.33 (17.1) |
| GD_BS diff (t) / F_ST diff (t) | +0.014 (6.7) / +0.059 (5.8) | +0.011 (6.3) / +0.042 (4.8) |
| mean_tc pool correlation | 0.85 | 0.89 |
| stage2 alpha ceiling | positive (+0.0088) | negative (-0.0051), all DE rows = truncation |
| runMacs LD adjacent r^2 | 0.1322 (13x) | 0.1267 |

Verdict words ("beyond", "exceeds", "supported reading ... with the correction") coincide in both formats; only the cov-term sentence,
the "3 vs 2 beyond unadjusted" count and the stage2 regime differ. No qualitative conclusion reverses, but a reader of the PDF and a
reader of the HTML are shown different tables, different t values and a different cov-term sentence for one and the same chapter.
The chapter does disclose non-repeatability from the seed (callout, Scale paragraph), but not that its own two published formats
come from two different executions.

## 4. Claims now false

None in either format. Claims that are conditional and whose condition is NOT met in HTML: T17 (ceiling at or below zero).
Claims that depend on the covariance term: in HTML the term is beyond the unadjusted 5 percent point at split = 10 (|t|=2.23, not beyond
Bonferroni 3.01), which the chapter states; the following sentence "a term within that point is not shown to differ from zero" is then
silent about the one split where it is not within; no verdict relies on it.

## 5. Not verified

- PDF page text beyond the multiplicity sentence (only line 16358 grepped); PDF numbers taken from typ.json.
- Whether a third execution would flip the cov-term branch (split 10 |t| = 2.23 vs 2.09 is a thin margin; the PDF run shows "within at every split").
- Figure content (fig-alphasimr-cycles) not inspected visually.
