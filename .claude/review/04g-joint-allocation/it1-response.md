## Package and test rows (R/18 roxygen, test-joint.R) -- written by the R/tests agent

| ID | Status | Evidence |
|---|---|---|
| 04g-D1 (package side), audit R6 | fixed | `joint_alloc` roxygen no longer says coverage is `parentage` "under another name". Recomputed: complete 20 x 20 factorial, 8 locations, k = 2, seeds 1..20: `all(Mc == Mp)` FALSE in 20/20; frac_disconn 0 (coverage) vs 0.286 (parentage) in 20/20. Roxygen states both facts and says both put both pools in every location. |
| 04g-M1, audit R1 | fixed (wording) + test | Roxygen now says the cap is a penalty, not a constraint (`gain = -Inf` ranks a full location last; with < k open locations it is still picked). Reproduced: seeds 1..100, 20 x 20, 8 locations: circulant c = 2, k = 4 exceeds ceiling(n k / nLoc) in 20/100, c = 4, k = 2 in 2/100, max excess 1. Code comment added at the `gain` line. Behaviour unchanged (rule not made a hard cap). New test asserts max excess <= 1 over seeds 1..40 at c = 2, k = 4 (does not assert 0). |
| audit R3 | fixed (test added) | New test `joint_connectivity agrees with a union-find oracle`: 150 random 8 x 8, 5-location allocations (k in 1:2, random plan density, every fifth draw has a blank location); `n_comp_cross` and `n_comp_loc` equal the literal union-find count in all 150 (300 expectations, 0 failures). |
| audit R2 | not touched here | Chapter test-list wording (04g:1277-1279) is in book/, outside this task. The test it describes (`coverage balances loads and spreads both pools`) is unchanged and still checks k = 1, female coverage only. |
| 04g-C19 | fixed | "what carries connectivity ... (Chapter 4f, finding 4)" replaced by "the property Chapter 4f (finding 4, a hypothesis there, not a result) suggests matters"; the false cap guarantee corrected as above. |

Verification: `devtools::document()` (only man/joint_alloc.Rd changed), `devtools::test()` [ FAIL 0 | WARN 0 | SKIP 0 | PASS 816 ] = 515 existing + 301 new (300 oracle + 1 cap); `devtools::install()` done.

## Chapter rows -- written by the chapter agent (book/04g-joint-allocation.qmd; one clause in book/04f-sparse-testing.qmd)

No result changed; every new number is computed in a chunk or inline. R/ and CLAUDE.md not touched.

| ID | Status | What was done |
|---|---|---|
| D1 | fixed | "under another name" removed (opening result 2, @sec-joint-strategy). New chunk `joint-parentage`: complete 20 x 20, 8 locations, k = 2, seeds 1..20; `stopifnot` asserts allocations differ in 20/20, coverage 1 and equal loads in both, frac_disconn 0 (coverage) vs 8/28 (parentage) in 20/20, and 20 groups x one pair < 28 pairs; conc_hmean printed (about 13.4 vs 0). 04f bullet rewritten: "closest analogue, not the same allocation". |
| D2 | fixed | Opening and budget paragraph say 80 % of the hybrids were planted in 04f (n_c = 320), consistent with the limitations paragraph. |
| D3 | fixed | "tested here" removed from "Where this connects": non-detection (z printed from `pc_all`); the contrast moves parent coverage and concurrence together; not a test of 04f result 4. |
| D4 | fixed | Result 1 rewritten with live difference of differences (z 0.86 at h2 0.2, 1.98 at 0.4; 80-vs-40 step at h2 0.2 smaller with high SCA); "margin grows with SCA" removed. |
| D5 | fixed | @seye2020 removed from the "favours lines never crossed" clause; Melchinger 2023 symmetric cost added; scoped to abstracts. |
| M1 | fixed | New live `tbl-joint-cap` (seeds 1..100, 101..200, six sweep configurations) and a paragraph where the coverage rule is described; test list says what test-joint.R checks (including the two tests the R agent added). |
| M2 | fixed | z range of the 16 tester-vs-circulant c = 4 pairs printed live, unpaired; plans differ in crosses and structure. |
| M3 | fixed | "because each is seen in four locations" is now a hypothesis; different made subsets (160, 80, 40) stated. |
| M4 | fixed | Circulant-only spread printed; plan variation mixed into random sparse and tester clusters stated. |
| M5 | fixed | 65 % cut-off labelled post hoc, descriptive. |
| M6 | fixed | Callout and reproduce section: numbers reproducible, literature search not; "30 minutes" removed; recorded optimiser minutes printed as a lower bound; byte identity not claimed. |
| M7 | fixed | REML mechanism labelled 04f's hypothesis. |
| M8 | fixed | Diversity argument restored as 04e's hypothesis; @sec-stages and @sec-cycles dropped as support; only measured piece (drift term, @sec-joint-freq) cited. |
| M9 | fixed | Closing states what the Part hands on and that the Evidence part starts from @sec-choosing and does not use it. |
| M10 | fixed | 04e's regime named; agreement in direction only; marker panel of tbl-joint-freq said not to be 03's generator. |
| M11 | fixed | sigma^2 mapping pointer; plot h2 / sigma^2_e by pointer; n_c, L, r reuse disclosed; N_SNP is Meuwissen's; joint_pev vs Box 4 of @sec-sparse-connectivity stated; n_unc via `format(big.mark)`; T-level of `acc_unmade` stated, CV2 of 08b noted. |
| M12 | fixed | B2 (Heslot, published abstract only), B3 (Butler/Lisle/Cullis softened), B5 (Guo: 276 maize, wheat and rice "validated"), B6 (Nei abstract level), B7 (Comstock 1948 "attributed to, not verified"), B8 ("stage-1 norm" removed; Thomsen alpha lattice without replications cited as one example). B4 (Montesinos-Lopez 2023 Genes) unchanged: the claim is as the abstract says; full text not reached. |
| M13 | fixed / owed | n_unc, timings (millisecond now measured in-chunk), "resolved" bars distinguished, CV labelling. Appendix 91/92 rows: Owed. |

### Owed

- 90:353 wording of n_c; a joint-allocation r row and an L note in 90 (pointers added in 04g, rows not).
- 91 file map (R/18) and 92 table (three joint_*.csv; live tbl-joint-misspec, tbl-joint-alias).
- 11 opening has no link to the Mating and testing design part; optional 04d citation of @sec-joint-split.
- `regenerate.R` prints "regenerate: complete" before the `joint` block (cosmetic).
- Byte identity of `regenerate.R joint` with the tracked CSVs was not checked. Sweep results were generated with the coverage rule as it stood (cap not a hard constraint); R/18 behaviour was not changed.
- docs/ and book/_freeze/ for 04g (and 04f) are stale until a render; no render was run.
