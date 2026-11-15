# 04b-backcross-introgression -- response to iteration 1

Files: `book/04b-backcross-introgression.qmd` (line refs below are to the edited file), `book/index.qmd` (earlier-chapter fix, diff at the end), `book/downloads/04b-backcross-introgression.R` (regenerated). No `R/` change. No Quarto render. Chunks run end to end via `knitr::purl` + `pkgload::load_all` (all `stopifnot` pass).

| ID | Disposition | Where / evidence |
|---|---|---|
| D1 = C1 | fixed | qmd:1073-1175. Donor now shared by descent with probability s per marker (`donor <- ifelse(rbinom(m_c,1,s)==1, rec, elite[40,])`); "already in the draw" removed; state vs descent stated. Table has s = 0.60 (chapter's s), s = 0 (comparison) and unrelated rows. Numbers: seed-11 draw GD ratio 0.053 (s = 0.6), 0.125 (s = 0); 200 seeds: mean 0.0470, s.d. 0.0037 at s = 0.6 (expected 2D(1-D)(1-s) = 0.0469); mean 0.1172, s.d. 0.0057 at s = 0 (expected 0.1172); asserted at 4 s.e. The headline 0.117 is now the s = 0 value only. |
| D2 = R1 | fixed | qmd:~300-318. Per-generation 47 stated as per-generation; lineage survival (1-(15/16)^47)^3 = 0.862; 64 plants/generation for 0.95 over three generations; scan `p_lost` 0.193 (N=40, 300 reps), 0.050 (N=60, 200 reps), all computed in a chunk with asserts. "whole foreground problem" dropped. |
| D3 | fixed (scoped and measured) | Section title and the three statements scoped to s = 0.60 (qmd:264, 319, 432-440, 540-544, "Where this connects" 1050-1062). New `tbl-bc-s0` (qmd:375-): rec_drag, k = 4, N = 60/200/400, s = 0 and 0.6, 500 replicates per row, explicit per-replicate seeds, Clopper-Pearson, unpaired. Result: s = 0 P(IBD>=0.90) = 0.532 / 0.782 / 0.822, upper limits 0.576 / 0.817 / 0.855, all below 0.95; s = 0.6: 0.932 / 1.000 / 1.000. The IBD criterion binds at s = 0 in this range of N. Against the chapter's thesis; in the text. Not measured (stated): N > 400 at s = 0, a background-priority stage, joint drag-and-IBD at s = 0, other k, ceiling, target, grid. "Not of maize" replaced by "not of the cross simulated"; index comparison stated as run at s = 0.60 only. One-value-of-each-criterion limit paragraph added (qmd:964). |
| D4 = B1 | fixed | qmd:980-985. 1000-fold stated as the authors' background statement; their measurement: ~136 000 breakpoints, hotspots threefold to over 100-fold (per it1-refs full-text finding; paper not re-read here). |
| M1 = R2 | fixed | qmd:319-330 prose and `tbl-bc-ibd` caption: mean is over replicates that kept all targets; `p_lost` at the smallest N printed. |
| M2 = C4 | fixed | qmd:~1170: usage cap is `max_use` in @sec-choosing, @sec-ocs, @sec-combinatorial; not tested for near-copies. |
| M3 = C5 | fixed | qmd:~1181: re-pointed to @sec-hp-ibd, @sec-coancestry. |
| M4 = C6 | fixed | qmd:61-76: where the chapter stands against A1-A8 and S1-S4 (A2 kept, A3 not met, A5 dropped then restored, others unused; not a stage). "re-enter the pool" replaced by "candidates for the set" (1062). |
| M5 = C7 + R6 | fixed | qmd:187-205 (model section): "exact for the marker chain", cancelled double crossovers within an interval (pointer to @sec-sizing-verify; not measured at 5 cM, direction for drag not shown), drag floor 5 cM per target and 5 cM lattice, ceiling = 6 cells (computed). Assumptions section points back (qmd:~964). |
| M6 = C8 | fixed | qmd:745-752 and `tbl-bc-fixation` caption: cross-reference to @eq-sizing-n95, what differs, "no segregation distortion", 04's k = 5 understatement named; also in qmd:990-995. |
| M7 = C10 | fixed | qmd:~1164-1170: alpha is against a same-candidate-set random reference; "cannot distinguish" replaced by the measured ratio vs 0 for eight copies of one line. |
| M8 = C3 | fixed (index edit) | qmd:1073-1078 says the measurement is a ratio, not an optimiser result; index item 5 reworded (diff below). Hospital (2001) at qmd:722: context only, different problem (one gene, number of generations). |
| B2 | fixed | qmd:986-989, [@lu2002] (abstract level, as in 04); consequence ($q$ not exact at a distorted locus) stated as the model's. |
| B3 | fixed (deduction, marked unsourced) | qmd:1001-1009 and fig-bc-flow note (qmd:~138). Rewritten as a deduction from triploid Mendelian segregation under complete recessivity; "xenia" removed (the old sentence "does not appear on the ear of a heterozygous plant" was too broad: it holds for an ear pollinated by the recurrent parent). Marked "no source was checked". |
| B4 | fixed (marked unverified) | qmd:189-193: standard Haldane function asserted against `haldane_r()` in a chunk (qmd:206); page-level attribution to J. Genet. 8:299-309 stated as not verified. |
| C2 | fixed | qmd:49-58: names the four objectives of 04 and which one 04b's fixation section resembles; "Where this connects" (1052-1056) no longer says 04's lesson was only gene diversity. |
| C9 | owed -> 11b | `11b:344-346` (conversion adds k loci, not a line; 0.047 of unrelated lines at s = 0.6, 0.117 at s = 0). Not touched. |
| C11 | fixed | qmd:~994-998: no "exactly as"; says 04 gives no rescaling procedure and leaves lee2002 UNVERIFIED. |
| C12 | fixed here, 90 owed | qmd:~228-234: $d$ = interval at eq-bc-haldane, distance between targets at eq-bc-psame; all runs have targets on different chromosomes so P_same is unused. Owed -> `90`: second meaning of $d$ (90:392-399). |
| C13 | owed -> 90 | local-symbol note (90:414-420) lacks $q$, $d$, $r$, $P$; $\theta$, $GD$ unsubscripted at 04b qmd:1101-. Not touched. |
| C14 | fixed | fig-bc-flow annotation now `fmt(expected_ibd(MB$n_bc, MB$s), 3)` (qmd:~133). |
| C15 | no action | per verdict. |
| R3 | fixed | qmd:22-26: `stopifnot` of `MB` against `mabc_opt` (n_bc, target_ibd, drag_per_gene, flank_cM, P_crit, n_keep_f2, spacing_cM). |
| R4 | fixed | qmd:39, 792: `fig-alt: !expr alt_siz`, built from `mb_sz` (not rendered here; if `!expr` for `fig-alt` fails at render, fall back to a literal). |
| R5 | fixed | qmd:953: `fmt_sci()`. |
| R6 | fixed | see M5. |
| R7, R8 | no finding | Info. Optional sentence on unchanged scan code not added (unverifiable beyond the audit). |

## Diff to an earlier-chapter file (`book/index.qmd`, Preface item 5)

```
-   (@sec-sizing), and a set of near-copies cannot be rescued by any optimiser
-   (@sec-backcross). @sec-simulating-crosses and ...
+   (@sec-sizing), and a set of near-copies carries a small fraction of the gene
+   diversity of unrelated lines (@sec-backcross measures that ratio for BC3
+   conversions; it does not run or bound an optimiser). @sec-simulating-crosses and ...
```

## Owed (later chapters)
- `11b`: C9 (and the "linkage modelled properly" attribution at 11b:76-79).
- `90`: C12 (second meaning of $d$), C13 (local-symbol note: $q$, $d$, $r$, $P$; $\theta$, $GD$ for a set of lines).

## Contested for Rwrite
None (no R/ edit needed).

## Not verified here
Rodgers-Melnick 2015 attribution (relies on it1-refs full-text finding); Haldane 1919 pages; Lu et al. 2002 beyond abstract. s = 0 result is one seed scheme, 500 replicates per row, three N values.
