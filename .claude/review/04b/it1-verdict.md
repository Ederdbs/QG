# 04b-backcross-introgression -- verdict, iteration 1

VERDICT: REJECTED

DISQUALIFYING FAILURES

- 04b-D1 [criterion 6, 5] book/04b-backcross-introgression.qmd:10-11, 30-31, 255-302, 356-373, 442-444, 478-479, 499-502 -- Provenance (04b-R1). The headline section (fig-bc-index, the index table, the inline 0.987 / 400 / 0.767 numbers) and the allocation re-run table are read from `mabc_index_comparison.csv` and `mabc_allocation_recheck.csv`. Nothing in the repository writes either file: `grep` finds them only in the chapter, and `main()` in inst/scripts/run_mabc.R writes uniform, allocation, bcnf2 and sizing only. Their cells lie off the driver's grids. N = 150 is not in `n_grid`. Four of the five schedules use per-generation sizes that `alloc_grid` (bc2 in {20,60,150,300}, bc3 in {20,60,150}) does not contain; only 300/40/20 is in fact off-grid in its bc2 alone. The index labels are `script`/`drag`, which are not strategy keys of R/08. The chapter nevertheless states three things that are false for these two tables: "It ships with the package ... the engine and the selection index are R/08_mabc.R" (30-31), "Everything above is reproducible from the package ... the experiment driver that produced the cached tables" (442-444), and that the cached tables are the four driver outputs (499-502). It also asserts that the `script` index is the `rec_bg` of R/08 (250, 475-476 compare `rec_bg` against `rec_drag` as if they were the two arms of fig-bc-index), and that cannot be checked because the predecessor script is not in the repo. Per the audit, all six `mabc_*.csv` were committed before R/08 and run_mabc.R existed (e302107 against 016c71a), so even the four driver-shaped tables are regenerable in shape only and have never been diffed against a run of current code. The limitation is material (it concerns the chapter's central result) and is undeclared.

- 04b-D2 [criterion 3; violates the rule declared at 573-578] book/04b-backcross-introgression.qmd:295-298 -- Headline "four genes reach 0.987 at 400" (04b-R2). The value is picked by `which.max` on the point estimate, which is the selection the chapter's own callout calls a winner's curse and says it abandoned. The same cell (rec_drag, k = 4, s = 0.60, N = 400, BC3) is also estimated independently in `mabc_uniform.csv`, which the chapter reads. There it is 0.967, CP [0.906, 0.993], on 90 replicates, and it is non-monotone: N = 320 gives 0.989, lo 0.940. Under the declared rule (select on the Clopper-Pearson lower bound against 0.95), four genes are not certified anywhere in the uniform scan (max lo = 0.940). They are certified only in the uncommitted-provenance table of D1 (lo 0.966). The chapter reports the favourable estimate and never shows the other. Note on scope: this is not a reopening of the retraction. The settled point stands that the "unreachable" wall came from the wrong index. What fails is the positive replacement claim, as quantified.

- 04b-D3 [criterion 4] book/04b-backcross-introgression.qmd:314-319, 369-373 -- Mechanism contradicted by the chapter's own table (04b-R3). The chapter says "BC3 is the generation where a plant buys the most drag reduction" and that a BC3 plant "converts into drag reduction far more efficiently". Both imply that back-loading the budget wins. The recheck table under the drag index shows the opposite: 20/150/190 gives 0.876 [0.829, 0.914] and 40/120/200 gives 0.940 [0.903, 0.966], and both lose to 120/120/120 at 0.988 [0.965, 0.998]. The 1/g scaling of expected segment length (expected_drag() = 200/g) is correct, but it does not entail the claimed efficiency: a shorter segment carries proportionally fewer crossovers to select on. The interpretation is presented as the explanation of a result it does not predict.

- 04b-D4 [criteria 2, 3] book/04b-backcross-introgression.qmd:326-354 (fig-bc-alloc and the caption claim "Front-loading BC1 is the worst use of a fixed budget") -- 04b-R4. `mabc_allocation.csv` was produced with `strategy = "rec_bg"` (run_mabc.R:179) and 40 replicates per schedule (`alloc_rep = 40`, run_mabc.R:94). Neither the text nor the caption declares either fact. The figure follows directly on the section that calls rec_bg the wrong index, so the reader takes it as evidence under the recommended index. It plots bin means of p_both with no dispersion, at 40 replicates, where one success moves the estimate by 0.025. The comparative claim in the caption rests on that.

- 04b-D5 [criteria 2, 4] book/04b-backcross-introgression.qmd:200-223, 112-114 -- 04b-R5 and 04b-R7. The claim is "recovering the elite is free by BC3 ... before a single background marker is scored", and the diagram says "~0.97 with no background selection at all". It is supported by a table filtered on `strategy == "rec_bg"` (213), which is the policy in which background is the decisive stage-2 criterion. The evidence offered for "background selection is unnecessary" therefore comes from a programme that selects on background, and the text does not say so. The displayed closed form 1 - (1 - s)(1/2)^4 = 0.975 is also the unconditional expectation. With k targets held heterozygous by foreground selection, the dosage is inflated by the attached drag segments, which the driver's own header acknowledges (run_mabc.R:56-59). Under rec_drag the simulated IBD at k = 4 is 0.946-0.964 (`mabc_uniform.csv`, verified). The conclusion (above 0.90) survives. But the assumption that the formula ignores foreground conditioning is used without being declared, and the table shown is for the wrong index.

- 04b-D6 [criterion 1] book/04b-backcross-introgression.qmd:146-151 -- "Both identities hold exactly in the simulator and are asserted in its test battery" (04b-R6). Only IBD_E + donor-specific = 1 is exact. The relation IBD_E = 1 - (1 - s)D holds in expectation only, because `make_shared_ibd()` draws a realised sharing mask and forces targets into non-shared windows (R/08_mabc.R:164-167). The test the chapter invokes states this itself: tests/testthat/test-mabc.R:109, "exact only in expectation: sharing is a realised draw, not a per-plant rate", asserted with `tolerance = 0.02`.

- 04b-D7 [criterion 1] book/04b-backcross-introgression.qmd:609-633 -- Conversion cost computed with donor-elite sharing counted twice (04b-R8). `expected_ibd(3, 0.5) = 0.969` already credits s = 0.5. The chunk then fills the remaining 3.1% from an unrelated random line, which matches the recurrent parent by state at about half of those markers, so donor-specific content enters at roughly half its intended rate. The probability that a marker carries the recurrent allele by descent is 1 - D = 0.9375, not 0.969. Reproduced with set.seed(11): GD ratio 0.0652 as written against 0.1250 with 0.9375. The prose built on it fails twice. "Not a marginal erosion but a different order of magnitude" does not hold at about 8x. "It follows directly from expected_ibd(3, 0.5) = 0.969" names the erroneous step as its justification. The chunk also draws each marker independently (no linkage), and that is not declared.

- 04b-D8 [criterion 1] book/04b-backcross-introgression.qmd:434-437 -- Staggered fixation, "roughly 330 plants" (04b-R10). This is typed, and it matches no reading of the genotype class described. A specific pair homozygous with the other pair heterozygous has q = (1/4)^2 (1/2)^2 = 1/64, and n_for_count(1/64, 3) = 401. Any two of four homozygous with the rest heterozygous has q = 6/64, giving 65. The class is not stated precisely enough to decide which one was meant. "Roughly 100" at BC3F3 (n_for_count(1/16, 3) = 99) is correct.

- 04b-D9 [criterion 5] book/04b-backcross-introgression.qmd:131 -- "a binary vector over 334 markers". The map the chapter itself builds (`build_map(maize_chr_len, spacing_cM = 5)`, line 450) has m = 344 (verified).

- 04b-D10 [criteria 5, 6] book/04b-backcross-introgression.qmd:478-479, 488-490, 580-585; book/92-verification.qmd:275, 301 -- The chapter's statements about its own numbers are false (04b-R12).
  - "Every number in this chapter is interpolated from the cached tables at render time" (583-584) is contradicted by D8, D9, D11 and M1.
  - "@sec-verification says which table each one comes from": the appendix lists only the glob `data/mabc_*.csv`, with the description "4 policies x 4 gene numbers x 11 sizes x 3 s, 300 reps".
  - That description is wrong, and the chapter repeats it at 488-490. Only rec_bg runs at three values of s (`table(strategy, s)`: bg/rec12/rec_drag only at 0.6). Replicates are 90-300 by N, not 300. The glob also covers the two D1 files, which are not that grid.
  - "The tables above are 300 of these per cell" (478) is false for `mabc_uniform.csv`; the k = 4, N = 400 cell of D2 has 90.

- 04b-D11 [criteria 3, 4] book/04b-backcross-introgression.qmd:292-295 -- "since the IBD constraint was met in every replicate with margin, it is free" (04b-R14). The table this sentence summarises (`mb_idx`) has no p_ibd column, so the claim is asserted, not measured from the cited source. The uniform scan has the shared cell N = 80, k = 4, rec_drag, and there p_ibd = 0.993, so "every replicate" is false at that cell.

- 04b-D12 [criterion 7; 04b-B7, 04b-R11] book/04b-backcross-introgression.qmd:531-543 -- Several parts of the interference paragraph fail on sourcing.
  - "A coincidence model" giving 4.90e-4 is unnamed and unsourced. It implies a coincidence of c = 0.216, and nothing in R/08 or the driver computes it.
  - The "4.6x over-production" conclusion that the chapter makes material ("every population size ... is a lower bound") rests on that unnamed model.
  - "Maize estimates put nu near 3" has no source. The one primary maize estimate refcheck found (Falque et al. 2009, full text) reports 4.2 < nu < 6.2 for the interfering pathway, so the figure is unsupported and in conflict with it.
  - "Maize has strong positive interference" is uncited.

- 04b-D13 [criterion 7; 04b-B2] book/04b-backcross-introgression.qmd:171-172 -- "Published stacking simulations get this wrong often enough ..." attributes an error to unnamed published work. No source is given and refcheck found none.

- 04b-D14 [criterion 7; 04b-B4, 04b-B5] book/04b-backcross-introgression.qmd:246, 314-317, 356-373 -- Three statements lack sources.
  - "Classical practice stops recombinant selection after BC2" has no source.
  - The 1/g scaling of segment length is uncited.
  - The allocation conclusion (balanced beats front-loading recombinant selection in BC1) is presented as the chapter's finding. It is not credited to the prior result that states it (Hospital 2001, Genetics 158:1363, abstract checked by refcheck).

- 04b-D15 [criterion 7; 04b-B8] book/04b-backcross-introgression.qmd:550-552 -- "Maize has 5-10x rate variation" is uncited and states no scale. The source refcheck found (Rodgers-Melnick et al. 2015) reports more than 1000-fold variation at fine scale. The magnitude is therefore unsupported as stated.

- 04b-D16 [criterion 7; 04b-B1, 04b-B3, 04b-B6, 04b-B9, 04b-B10] book/04b-backcross-introgression.qmd:132-138, 189-190, 200-209, 379-381, 431-432, 545, 563-568 -- Results and empirical claims are cited without naming a source; the chapter carries no bibliography key at all:
  - the Haldane map function (`haldane1919` is already in the bib);
  - the expected donor dosage (1/2)^{t+1} and the foreground and fixation probabilities;
  - "DH is routine" in maize;
  - "real programmes advance 3-10";
  - sh2/bt2 as the two subunits of one enzyme;
  - the o2 modifiers being polygenic and unlinked.

NON-DISQUALIFYING OBSERVATIONS

- 04b-M1 book/04b-backcross-introgression.qmd:197, 260, 366, 401, 494-496, 575-577 -- Typed numbers (04b-R13).
  - fig-bc-index caption: "300 replicates, s = 0.60, 30 cM, 0.90".
  - Recheck table caption: "s = 0.60". The CSV has no k, s or replicate column, and its replicate count (about 250, judging from the CI widths) is stated nowhere.
  - "multiplies ... by four": the data give 4.3, 4.05 and 4.01.
  - "35 checks, ~10 s / ~30 s / ~3 min": 3.3 s measured, and it conflicts with the driver header's "--quick ~45 s".
  - "30-150 replicates ... (0.97, 0.97, then 0.93)" is historical and not computed.
- 04b-M2 book/04b-backcross-introgression.qmd:449-458; inst/scripts/run_mabc.R:214 -- The interactive programme chunk draws without its own `set.seed()`, so its output depends on `_common.R` plus earlier consumption. The driver seeds once before the whole scan, so no single cell can be regenerated in isolation (04b-R16).
- 04b-M3 book/04b-backcross-introgression.qmd:205 -- The exponent `(1/2)^{4}` is a literal, while 201-202 interpolate `MB$n_bc + 1` for the same quantity.
- 04b-M4 R/08_mabc.R:413; inst/scripts/run_mabc.R:250-257 -- The code says things that contradict its data (04b-R14, 04b-R17).
  - The docstring "cost is 1.5-2 points of IBD" disagrees with the data, which give a mean of 1.09 and a range of 0.32-1.58.
  - The driver's figure caption gives 1-(1-s)/2^4 = 0.980 at s = 0.60; the correct value is 0.975.

WHAT WAS VERIFIED

- Writers of index_comparison and allocation_recheck: `grep` on the worktree and a read of run_mabc.R `main()`. There is no writer. The cells are off `n_grid` and `alloc_grid` (run_mabc.R:87-94) as described in D1, and the labels are `script`/`drag`.
- The two estimates of the rec_drag k=4 N=400 cell. `mabc_index_comparison.csv`: 0.987 [0.966, 0.996]. `mabc_uniform.csv`: 0.967 [0.906, 0.993], n_rep = 90. Uniform N=320: 0.989 [0.940, 1.000]. The maximum uniform lower bound for k=4 is 0.940, so four genes are not certified at 0.95.
- Recheck table under the drag index: 120/120/120 = 0.988 [0.965, 0.998], 40/120/200 = 0.940, 20/150/190 = 0.876, 300/40/20 = 0.656. Read from the CSV.
- fig-bc-alloc index and replication: run_mabc.R:179 `run_bc_program(ns, opt$alloc_s, "rec_bg", ...)`, `alloc_rep = 40` (line 94).
- `table(strategy, s)` in `mabc_uniform.csv`: rec_bg at 0.5/0.6/0.7; bg, rec12 and rec_drag at 0.6 only. n_rep ranges 90-300.
- Simulated BC3 IBD under rec_drag at k=4, s=0.6 is 0.946-0.964. p_ibd at N=80 is 0.993.
- Identity test: tests/testthat/test-mabc.R:102-112. The sum identity is asserted with exact equality; the proportionality with `tolerance = 0.02` and the comment "exact only in expectation".
- `build_map(maize_chr_len, 5)$m` = 344.
- `n_for_count` gives 401 for q = 1/64, 65 for q = 6/64 and 99 for q = 1/16.
- `expected_ibd(3, 0.5)` = 0.96875. The conversion GD ratio with set.seed(11) is 0.0652 at p = 0.969 and 0.1250 at p = 0.9375 (rerun of the chapter chunk).
- Consumed without redoing: the audit (04b-R1 to R17) and refcheck (04b-B1 to B10). Refcheck checked the closed forms P_same(20 cM) = 0.980 against 0.819, the Haldane double recombinant at 2.264e-3, and IBD_E = 0.975 at s = 0.6. The audit found that `mabc_analytical_sizing.csv` reproduces exactly from `sizing_table()`.
