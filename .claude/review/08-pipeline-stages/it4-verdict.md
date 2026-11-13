# 08-pipeline-stages -- verdict, iteration 4 (form pass)

Chapter: book/08-pipeline-stages.qmd (content APPROVED at it3). Read: editor.md, editor-response.md (P1-P19, C1-C3, W1-W8), the whole chapter, the diff of book/90-notation.qmd and book/05b-heterosis-dominance.qmd, R/05_pipeline_metrics.R (dh_pool_theta, sigma_dh_crosses, theta_ceiling, loss_vs_resampling), book/03 and book/00 (Balding-Nichols passages), book/02b (eq-response-breeders). No it3 snapshot of the chapter exists (file untracked-modified against HEAD), so changes were judged by reading the whole text, not by a diff against it3. No refcheck or continuity report supplied.

VERDICT: APPROVED

## PREVIOUS IDS
- 08-M12 -- CLOSED -- 05b:786-791 now says "That section states that ..."; the three things attributed (mean_sq_delta_p = 2 F_ST GD_T for equal pool sizes, expected heterosis is what decouples, hold F_ST in a band) are what 08:245-278 states. Only the verb moved; the rest of the paragraph is the it3 text.
- 08-M11 -- carried, process only (docs/ and _freeze/ stale until the render batch); not one of the non-disqualifying criteria (prose, notation, redundancy), not counted.
- All content IDs of it1-it3: not reopened; no number, assertion, seed or code line changed (chapter re-run end to end, see below).

## DISQUALIFYING FAILURES
None.

Walk of the criteria on the changed text and its dependents:
1. Renames are identical in mathematics. eq-stages-partition, eq-stages-dh-theta and eq-stages-sigma-dh differ from it3 only in symbols (w_p -> varpi_p, D -> n_DH, (i,j) -> (a,b)); the DH formula agrees with dh_pool_theta() (sum(n_per/D*(1+f_c)/2)/D form), the sigma formula with sigma2_dh()/sigma_dh_crosses() (sum of beta^2/4 over loci with x_ak != x_bk). The ratio identity eq-stages-fst-ratio re-derived by hand (F_ST = (theta_w - theta_AB)/(2 - theta_w - theta_AB); ratio = 2 - F^btw) and asserted in the chunk.
2. No clash: grep of book/*.qmd outside 08 and 90 finds no varpi, no n_{DH}, no UC_{..}, mu_{ab}, sigma_{DH(..)} and no w_p. a, b already name the parent lines of a cross in 90 (F_(ab)); i is the intensity of eq-response-breeders (02b:93) and h the accuracy, "the r of that equation", as the chapter says; i, j in identities (a)-(c) are line indices that do not meet the intensity.
3. Captions agree with code and data (see verified list): fig-theta-by-size, tbl-trap3-sweep, tbl-s1-panel, tbl-trap5-within-pool, tbl-stage-cost, and the other new ones (tbl-dh-identities, tbl-sigma-uc, tbl-s3-loss, tbl-s3-pools, tbl-trap5-greedy/-repair/-worlds, tbl-s4-usage, tbl-s4-he, tbl-fst-definitions, tbl-ledger). The 0.5 % of fig-theta-by-size is alpha = 0.005 of theta_ceiling(), i.e. a proportional loss of gene diversity against the same-size baseline: ceiling = 1 - GD_ran (1 - alpha).
4. [@balding1995]: the chapter attributes to it only the name "Balding-Nichols parameter", the same use as 00:585, 02b:50, 05b:613; 03:79-84 states that the book takes the name and the idea of one divergence parameter and attributes no parameterisation to the paper. The descriptive clause ("neutral divergence of each pool from one ancestral population") is the book's own reading, not put in the paper's mouth. I could not read the paper (see NOT VERIFIED).
5. All @eq-, @tbl-, @fig-, @sec- targets of 08 and of the new 90 table (88 distinct refs) resolve to a label in book/*.qmd; no duplicated tbl/fig/eq label in the book.

## NON-DISQUALIFYING OBSERVATIONS
- 08-M13 book/90-notation.qmd (new "Pipeline stages" table, row n_DH) -- the Function column cites "`dh_pool_theta()`, argument `n_per`"; n_per is the lines per cross (n_c, recycled to the number of crosses), n_DH = sum of n_c is computed inside. The symbol-to-code mapping the table exists for is off by one object.
- 08-M14 R/05_pipeline_metrics.R:200-206 (roxygen of dh_pool_theta) and sigma2_dh -- still write `D = sum(n_c)` and `(i, j)`, `x_ik != x_jk` for what the chapter and 90 now call n_DH and (a, b). Different documents, same quantity, two symbols; the 90 row warns only against D_ij, D, D_G, D_A.
- Two observations in total: below the threshold of three. (Caption completeness of tbl-trap4 [`cor`, `R2`] and tbl-trap5-within-pool [`pool`, `n`] is form, left to quant-editor.)

## WHAT WAS VERIFIED
- Whole chapter -- purl of 08-pipeline-stages.qmd, run in book/ against pkgload::load_all of the worktree: no error, every stopifnot passes. trap1 deviation sprintf("%.0e") = 2e-16 (matches W1). tbl-trap4 now 4 decimals: cor 0.1029 / 0.2188 / 0.5760, R2 0.0106 / 0.0479 / 0.3317 -> prose 1.1 %, 4.8 %, 33.2 % unchanged.
- Trap 3 sweep (20 seeds x 4 F_BN): cor(F_ST, mean_sq_delta_p) = 0.9983938; means F_ST 0.0465 -> 0.2697, GD_WS 0.3325 -> 0.2108; the identity asserted to < 1e-10. Caption of tbl-trap3-sweep (5 means + 3 sd columns, 9 columns) matches.
- tbl-s1-panel: names(s1_monitor(GL, pool, cycle = 12)) = cycle, GD_within, GD_total, Fst_Wright, Gst_Nei, Ns_total, GD_A, GD_B, frac_opposite_fixed, mean_abs_delta_p, mean_sq_delta_p (11 columns, all described in the caption); Ns_total = 0.7559 ("about 0.76"); Fst_Wright/Gst_Nei = 0.1824/0.1004 = 1.817 = 2 - 0.1824.
- fig-theta-by-size: theta_ceiling(fL, 20, alpha = 0.005) = 0.6746; th over sizes 2..60 = 0.8284 ... 0.6733 (n = 20) ... 0.6614; stopifnot(th[sizes < 20] > ceiling) passes; function body read: ceiling = 1 - gd_ran (1 - alpha).
- tbl-trap5-within-pool: pool A theta 0.71545, ceiling 0.71766, 1 swap, met; pool B 0.71535, 0.71827, 0 swaps, met; columns pool, n, theta, ceiling, met, n_swap, theta_truncation as the caption says.
- tbl-fst-definitions: ratio 1.955 -> 1.589 ("1.96 to 1.59"); tbl-ledger: exactly 2 negative loss rows, both S3 / UC only (seeds 2 and 6); share UC only S2 77.46 %, 35.5 / 29.0 / 35.5 for UC + div; e2e 13.069 / 10.729.
- tbl-s3-loss: loss_vs_resampling() returns GD_selected, GD_random_mean, loss_pct, percentile = mean(gd_ran < gd_sel), seed default 1: caption matches. tbl-s4-he: theta 0.662085, He 0.337915 (sum 1), N_e,par 49.63, pool_balance 0.5/0.5. tbl-sigma-uc: first six crosses, sigma_dh 4.609 ... (a standard deviation, as captioned).
- 90 new table: 11 symbols, 11 meanings, 11 functions; theta_decompose() returns theta (2 x 2 matrix of theta_pq), theta_T, theta_w, theta_B, GD_T, GD_within, Fst_Wright, Gst_Nei; theta_T = f-bar and theta_w = f-tilde of the partition table above it (GD_WS = 1 - f-tilde, GD_BS = f-tilde - f-bar, agree with 08:130-136); F^btw row and the edited F_ST row of Terms agree with Trap 2; n_c "not the field budget" -> 90 line 511 "n_c k r" exists; C is the number of rows of the C x 2 crosses matrix in dh_pool_theta and sigma_dh_crosses, which is how the cost caption uses it.
- Cross-reference targets: Rscript scan of every @eq-/@tbl-/@fig-/@sec- in 08 and 90 against {#id} / label: id in book/*.qmd -- 88 refs, none missing; duplicate-label scan -- none.

## NOT VERIFIED
- That Balding and Nichols (1995) states what the chapter's single use of the name implies (a parameter of the divergence of a population from a common ancestral one) -- no source access here; quant-refcheck has not reported. Non-decisive: the chapter attributes only the name, and 03:79-84 bounds the attribution.
- Quarto resolution of the new labels and the Typst widths of the wide tables (08-E1, 08-E8) -- no render run; form and process, owed to the render batch.
- Whether the form pass changed anything not listed in editor-response.md -- no it3 snapshot to diff; compensated by reading and running the whole chapter, no failure found.
