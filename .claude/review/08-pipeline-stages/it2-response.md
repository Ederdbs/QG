
## Content fixes (book/, iteration 2)

| ID | Status | What changed |
|---|---|---|
| 08-D11 | fixed | `book/05b-heterosis-dominance.qmd` (the "This is the reason behind @sec-stages Trap 3" paragraph): the invented quotation is removed. The paragraph now says what 08 Trap 3 states (`mean_sq_delta_p` = 2 F_ST GD_T for equal pool sizes, so the frequency-side statistic does not decouple from F_ST; expected heterosis is what decouples; hold F_ST in a band, not at a maximum) and that it points to 05b for expected heterosis. |
| 08-M9 | fixed | `book/08-pipeline-stages.qmd` (ledger result paragraph and the `e2e` chunk comment): the end-to-end change is now described as S2 `GD_before` (a same-size baseline whose set the file does not record, not the GD of the 120 founder lines) to the S4 `GD_after`. The values are unchanged (13.1 % / 10.7 %). |
| 08-M8 | R/ item, not touched here | The chapter prose says (c) is "asserted against the literal pair-by-pair average" for equal n_c (n_c = 40), which stays true. No printed value depends on the unequal-n_c case; no chapter change needed unless quant-Rwrite changes `dh_pool_theta()` output at equal n_c (it should not). |
| 08-M10 | R/ item, not touched here | Roxygen of `hybrid_theta_from_usage`; the chapter already states that the time saving is not claimed. No printed value changes. |

### Other attributions to @sec-stages / 08 Trap 3, checked across book/

Checked: every `@sec-stages`, "Trap N" and quotation attributed to the chapter in 00, 02, 02b, 04, 04e, 04g, 05, 05b, 08b, 10, 11, 11b, 12, 90, 91, 92, index.

| File:line | Attribution | Matches the rewritten 08? | Action |
|---|---|---|---|
| 05b:1426, 05b:2151 | Trap 3 recommends holding F_ST in a band | yes | none |
| 05:1658 | Trap 3 states the prescription (preserve divergence) | yes (band, not maximum) | none |
| 05:1786 | Trap 2: two F_ST definitions | yes | none |
| 05b:574, 11:98, 92:179 | Trap 1: MRD and coancestry, f = 1 - MRD^2 | yes | none |
| 11:151 | "That is Trap 3 of @sec-stages, with a mechanism attached" | yes (divergence not to be pushed further) | none |
| 05b:912 | 08 logs `frac_opposite_fixed`, `mean_abs_delta_p` every cycle | the panel (`s1_monitor()`) does contain both columns; 08 states the panel is logged every cycle | none |
| 05b:1435, 02b:105 | usefulness criterion set out in 08 | yes (08 "Progeny variance, and the usefulness criterion") | none |
| 12:187 | "@sec-stages showed that a constraint applied at one stage buys stage-level diversity, not end-of-pipeline richness" | NO: 08 withdraws that sentence (it is the cached figure's subtitle; 8 pools, N_e and alleles intervals contain no change, GD_final +0.0078 post hoc) | `book/12-case-study.qmd` reworded to what 08 reports: the term lowered S2 loss and raised S3 and S4 losses in 8 cached pools, and 08 could not say whether it improved N_e or alleles retained |
| 00:327 | "under merit-only cross selection it falls at S2, and with a diversity term added S2 and S4 carry shares that its founder pools do not separate" | NO: 08 says `UC only` is the usefulness criterion, not merit alone, and that the three stages carry similar shares (35.5/29.0/35.5) | `book/00-hybrid-programme.qmd` reworded to "cross selection on the usefulness criterion alone" and "the three stages carry similar shares" |
| 10:36 | "three-object contract of @sec-stages" | NO: 08 never states the contract; it is @sec-simulating-crosses (@tbl-stage1-contract); pre-existing wrong cross-reference | `book/10-combinatorial-selection.qmd` reference changed to `@sec-simulating-crosses` |
| 00:579, 90:270, 91:62, 92 list, 04:1178, 04e:1138, 04g:1297, 08b:43, 11b:106, 12:108, 02:1085, index:114/149 | generic pointers to the chapter (panel, stage losses, S4 hybrid mining, multi-stage) | yes | none |

`make_downloads.R` rerun. No quarto render. `book/figure` was absent.

## quant-Rwrite, iteration 2 (R/, man/, tests/)

| ID | Status | Evidence |
|---|---|---|
| 08-M8 | fixed | `dh_pool_theta()` (R/05_pipeline_metrics.R) now adds `(1 - sum(n_per / D * (1 + f_c) / 2)) / D`, i.e. formula (c) with weights n_c/D; roxygen formula updated. Equal n_c: identical (n_c/D = 1/C), asserted in the new test against the literal pair-by-pair oracle. Unequal n_c: new test `dh_pool_theta weights the self-coancestry correction by n_c / D` (test-stage-metrics.R), tolerance 1e-12; on its world (seed 12, seed-88 crosses, n_c = 5,40,10,80,20,60) the old unweighted form differs from the weighted one by 2.8e-6, so the test fails on the old code. The verdict's 0.7381905 refers to the chapter's own cross set, which I did not re-run (book/ not touched); the test uses its own crosses. The chapter's cross/n_per values are unchanged, so no number in 08 moves (n_per = 40 equal). |
| 08-M10 | fixed | roxygen of `hybrid_theta_from_usage` (R/05_pipeline_metrics.R:448-452; the claim was in R/05, not R/04) now says the cost is O(L^2) with no hybrid matrix against O(n^2) for the n x n submatrix route, as an asymptotic statement only; at small n (N = 2500, n = 50) the line route measured slower and pays off only for large n. man/ regenerated. |

devtools::document() clean (dh_pool_theta.Rd, hybrid_theta_from_usage.Rd rewritten); devtools::test(): FAIL 0, WARN 0, SKIP 0, PASS 515; R/05 ASCII; devtools::install() run.
