# 05-genomic-era -- iteration 1 response (quant-advice / quant-Rwrite split)

File edited: `book/05-genomic-era.qmd` (line numbers are those of the file AFTER the edit). Earlier chapters touched, minimal wording only: `book/04c-alphasimr-pipeline.qmd:435`, `book/04d-breeding-programme.qmd:426-429` (diffs at the end). `Rscript book/scripts/make_downloads.R` run; no Quarto render. The chapter was knitted with `knitr::knit` to a scratch file to check every new chunk (39 s, no error, every `stopifnot()` passed); the scratch `figure/` was moved out of the tree.

New chunks (all seeded, all live, ~35 s extra at render): `tbl-era-seeds-z` (20 data seeds x null `B_full = 300`, seed 7), `era-maxdiv-pull`, `tbl-era-audit-null` (20 data seeds x 300 random subsets, seed 7); `kappa_anc` added to `tbl-era-maf-weight`; one `stopifnot` added to `tbl-era-s1-identity`. No existing label renamed or removed.

## D

| ID | Status | Where / evidence |
|---|---|---|
| D1 | fixed | 05:336-420 (chunk `tbl-era-seeds-z` at 352). Seed-1 claim withdrawn. `tbl-era-seeds-z` reports the 20-draw distribution: z(trunc F1_het) -4.47 to 3.90, 7 of 20 negative, 4 above 2, 2 below -2 (reproduces the verdict exactly); max_div F1_het z > 0 on 20/20 (min 5.8); trunc F_hom z > 0 on 20/20 (min 3.7). Text keeps only (i) F_hom and F1 heterozygosity are different quantities and (ii) the sign for truncation is not consistent; the "more heterozygous than random" claim and the "pairs kept" mechanism are stated as NOT claimed. Result and interpretation in separate paragraphs; limits (20 draws, one scale, one subset size) named. |
| D2 | fixed | 05:1422-1578 (new chunk `tbl-era-audit-null` at 1480). `index` row no longer called a noise reference; stated (before the tables and in the interpretation) to be a selection response on the audit loci. New `tbl-era-audit-null`: audit-half F_drift of the index plan is z = 33.4 (seed 1), 23.0 to 34.3 over 20 draws (my null construction, 300 random subsets scored on the audit half; the verdict's 24.3-36.7 uses a different null draw, both >> 20). Replacement noise reference: s.d. of the audit-minus-management F_hom gap over random subsets (0.0098, seed 1); the max_div gap is 5.4 of those s.d. (2.3 to 6.4 over 20 draws). Sign reversal: managed F_hom < 0 on 20/20, audit F_hom > 0 on 16/20 (strict; count printed by the chunk). New finding reported against the chapter's tidy story: on a half panel the max_div plan's F_drift is z = 3.5 / 3.9 above the random null on the managed / audit halves (z in -0.8..5.2 over draws), unlike the full-panel z = -0.67 of Step 2; stated as not explained. Threshold paragraph rewritten. The `What not to do` bullet (05:1985-1990) re-worded to "far less ... 16 of 20". The suggestion to rebuild the index from management-half effects was not taken: `ctx$traits` carry no per-marker effects, so that needs a change to `simulate_data()` (out of scope; owed if wanted). |
| D3 | fixed | A5 rewritten (05:107-138): three cases (frequency toys neutral by construction; `simulate_data()` rows: effects at every marker, truncation/balanced/capped/index rows select on them, `w = 0` plan does not read the index; `run_cycles()` uses `simulate_pools()`, `n_qtl = 300` default, R/14_cycles.R:107, R/09_reference.R:27); LD claim scoped to the founding draw (C13). 00:37-44 not edited (already says it). |
| D4 | fixed | 05:448-470 and Step 6 (05:1699-1715, captions of `tbl-era-s1-monitor`, `tbl-era-s1-identity`). The book's F_ST = GD_BS/GD_T = Nei G_ST = standardised-variance form (asserted numerically in the chunk: `gd_partition()$F_ST == s1$Gst_Nei == mean((pA-pB)^2/4)/mean(pbar*(1-pbar))`; 0.1024003 at teaching scale; `Fst_Wright` 0.1858, ratio 1.81 printed inline). Difference from F_drift stated as space vs time, not form. `Fst_Wright` renamed "the between-referenced statistic (the code's name)" with 02's statement that no source is cited. F_BN named as the third object. "The form @wright1951 introduced" dropped, not softened: the attribution is not claimed and `wright1951` is no longer cited anywhere in the book; Meuwissen's own sentence (text after their Eq. 1B) and Holsinger & Weir are cited instead. `references.bib` untouched (entry `wright1951` is now orphaned; `number = {1}` vs PubMed issue 4 and the 1949-DOI artefact per B2 stay as notes for the bib pass). |
| D5 | fixed | A3 (05:87-99): "in reduced form ... no trials and no S3, index known without error (C7, C8 of @sec-cycles; also @sec-hp-cycle)", per 00:216-219. |
| D6 | fixed (limit stated in 05) + minimal fix in 04c/04d | The marker = QTL collapse is declared in A5 and in Step 5 (Step 5 interpretation, 05:1540-1560) as a limit; Meuwissen's four panels are reported, not reproduced. The promise text lives in 04c:435 and 04d:426-429 and is false as written, so minimal wording fixes there (diffs below). Nothing else in 04c/04d touched. |
| D7 | fixed | (i) "the cycle-by-cycle version of the same audit is @sec-cycles" deleted; Step 5 now says no cycle-by-cycle audit is run anywhere in this book. (ii) A4 "see @sec-limits" deleted; says the book neither models nor measures overlap and no later chapter treats it. Owed to 11b: a half-panel audit across cycles, if wanted. Owed to 11c: overlap/line reuse, if wanted. Neither is promised from 05 any more. |

## M

| ID | Status | Where / evidence |
|---|---|---|
| M1 / R6 | partly left | Bonferroni `stopifnot`, R^2 thresholds: left to quant-Rwrite as instructed. The prose "The bound is conservative here" (05:1271) is NOT touched in this pass; it is unsupported per audit (4 of 20 seed families break the assertion) and goes with the R6 code change. |
| M2 / R7 | fixed | 05:816 "their Results text says 40% for both panels, while their Table 2, Panel N, gives the two values above, which are not both 40%"; the chunk prints +40% and +68%. |
| M3 / R9 | fixed | Step 2 (chunk 996, text ~1010-1030): new chunk `era-maxdiv-pull`; implied pull 0.013 (random draw -0.003) vs stipulated 0.05, "about 4 times smaller"; Step-4 arm called a stipulation with no selection; pointer to `run_cycles()` in @sec-cycles for the book's selections across cycles. |
| M4 / R8 | fixed | `kappa_anc` by `integrate()` = 0.64 of kappa_book 1.27; remainder attributed to Balding-Nichols divergence and finite sampling, not decomposed. |
| M5 / C7 | fixed | Opening (05:12-22): names what is used from the Simulation part, says 04/04b/04c populations are not measured, says A1-A8 are this chapter's list. |
| M6 / C8 | fixed | "dominance effect" (05:415). |
| M7 / C9 | fixed | `@sec-heterosis-hybrid-identity` / `@eq-het-wi-hyb` at 05:82 and 268. |
| M8 / C10 | fixed | N_SNP replaced by m (declared once, with Meuwissen's N_SNP noted, and "m counts the markers kept"); ridge renamed epsilon in Step 7 and the checklist, with the alpha of Meuwissen noted. |
| M9 / C11 | fixed | Step 6 alpha now against `null60$gd_ref` (4.1% vs the former single-draw figure); callout comparison marked as an order of magnitude against a single draw. |
| M10 / C12 | fixed | Cross-references added: `@sec-subdivided`, `@eq-gd-partition` at 05:~255 and 448-470 (the second restatement in Step 6 already carried C&T; Eq. 8 and `@eq-f-stats` added at the F_drift paragraph); `@sec-baseline`, `@sec-catalogue-null` (forward use declared) at the null. |
| M11 / R14 | left | Step 1 "Call" executability: quant-Rwrite. |
| M12 | see rows below | |
| R10 | fixed | `fmt_sci` at 05:886-887, 1067, 1932, 1971 and the pair of `%.1e` values; BLAS dependence of `ev_min` stated. |
| R11 | fixed | A8 names both scales (programme size 71+71/25000 of R/00_data.R; `sim_config` default 50+50/5000 that `inst/scripts/` run). Owed to 06, 12: they call the `sim_config` default "the production scale". |
| R12 / C16 | fixed | "candidate pool" -> "candidate set" at all four places (none remain). |
| R13 | fixed | = M6. |
| R15 | prose fixed, asserts left | "twice as fast" -> "about twice (exactly so at fixed theta_AB)"; "opposite order" now scoped to truncation vs max_div on seed 1. The three missing `stopifnot`s (R15) and the ridge claim: quant-Rwrite. |
| R16 / C14 | owed to 11b | 11b:238-243 uses the first-order dF; nothing in 05 to change. |
| C13 | fixed in 05; owed to 03, 04c | A5 scoped to the founding draw; opening says 03/04c use no A-labels. A sentence placing 04c against A1-A8 is owed to 04c; 03 likewise. |
| C15 | owed to 08b | 08b should cite @eq-era-rank. |
| C17 | fixed | = R10. |
| C18 | fixed | One paragraph before the checklist says which list owns what. |
| C19 | not a 05 defect | H and G_i(p) are defined at first use in 05; owed to 90 (rows for G_VR1, G_VR2, G_i(p), G_LA, G_ROH). |
| C20 | fixed | "No relationship matrix this book puts into an optimiser is IBD-based". |
| C21 | owed to 06, 12 | as R11. |
| C1-C6 | fixed | = D3, D5, D4, D6, D7(i), D7(ii). |

## B

| ID | Status | Where / evidence |
|---|---|---|
| B1 | fixed (attribution dropped) | see D4. UNVERIFIED stays recorded in the review: Wright (1951) not read. |
| B2 | not changed | bib metadata, harmless; `wright1951` now uncited (bib pass). |
| B3 / Comstock 1949 | fixed as instructed | A3 (05:87-99): cited for existence and title only, "as @sec-heterosis-gca-sca does"; no content attributed; not searched. Stays PENDING with the user. |
| B4 | UNVERIFIED, left | Falconer & Mackay chapter locators (Ch. 3-4, 3, 14, 7) kept; unverified as in 05b. |
| B5 | fixed | 05:~200: "classical definition ... not checked against @wright1922, which this book has not read: UNVERIFIED". |
| B6 | fixed | `tbl-era-lenses` caption: attribution is Meuwissen's; 4f - 2J is the book's algebra, asserted in `tbl-era-centering-vs-structure`. |
| B7 | fixed | Step 7 note: centring on the scored population's own frequencies is this book's construction (`vanraden_G()`), not claimed to be VanRaden's; VanRaden cited for the form of G only; abstract-level support only. |

## Not done / for the next iteration
- R6, R14, remaining R15 asserts, R16: quant-Rwrite / 11b as instructed. The unsupported "conservative" sentence in Step 4 goes with R6.
- Heterozygosity Result of D1 and the audit of D2 are at the teaching scale (25+25 lines, 2000 markers), subset size 60, 20 draws; not measured at production scale.
- `book/_freeze/05-genomic-era`, `docs/` not regenerated (no render requested).

## Diffs outside 05
- `book/04c-alphasimr-pipeline.qmd:434-436`: "Real programmes have that gap; @sec-genomic-era is where the book takes it seriously." -> "Real programmes have that gap; this book does not measure it, and @sec-genomic-era (assumption A5) states the same collapse as a limit."
- `book/04d-breeding-programme.qmd:426-429`: "... and @sec-genomic-era is where marker-versus-QTL, the reason that accuracy is finite, is taken seriously." -> "... and marker-versus-QTL is the reason that accuracy is finite; this book does not measure that gap, and @sec-genomic-era (assumption A5) states its collapse as a limit."
- Both files also carry other uncommitted edits from other sessions in this worktree; only the two hunks above are mine.

## quant-Rwrite (code pass after quant-writer)

File edited: `book/05-genomic-era.qmd` only (no `R/` change; nothing to document/install). Chapter knitted to scratch (`knitr::knit`, no error, all `stopifnot()` pass); `make_downloads.R` run; no render.

| ID | Status | Where / evidence |
|---|---|---|
| R6 / M1 | fixed | `era-traj` calibration chunk, `dev_se` assertion DROPPED (05:~1236-1247); `stopifnot` keeps only `R2 >= 0.999`. New `fam_dev`/`fam_fail`: the same two statistics over 20 seed families (seed 11 + 100 k), live, seeded by `pool_traj(seed=)`; `stopifnot` checks family 1 equals the reported `dev_se` (all.equal). Prose (05:~1283-1297): "conservative" removed; says the bound is a description of this seed family, normal on a 20-replicate s.e., not a test, and prints `fam_fail` = 4 of 20 (reproduces the audit's 4). R2 thresholds 0.999/0.995 stated as calibrated on this family and scale. |
| R14 / M11 | fixed | Step 1 "Call" (05:~956-961): `build_ctx()` has no `p0` argument; store `p0 <- colMeans(X)` at cycle 0, then overwrite `ctx$p0` and `ctx$maf_pop <- pmin(p0, 1 - p0)` each later cycle, as `cycle_ctx()` does. "Set once in `build_ctx()`" reworded at A6 (05:140) and Step 1 opening (05:~843). |
| R15 | fixed | New `stopifnot`s: full-factorial `2*GD_WI_hyb == GD_T + GD_BS` (chunk `tbl-era-hom-two-levels`, `gp_full`); every line of `idx_bal` used exactly `k` times; `identical(r60, sels$random)`. "twice as fast" / "opposite order" were fixed by quant-writer. Ridge claim "small enough not to move the optimum" replaced by "its effect on the optimum is not measured here" (not measured: would need `quadprog` in the chapter). |
| R16 | owed to 11b | not edited. |
| R7-R13 | closed by quant-writer | see rows above. |
