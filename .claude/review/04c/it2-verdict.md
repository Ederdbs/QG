# 04c-alphasimr-pipeline -- verdict, iteration 2

VERDICT: APPROVED

Inputs: it1-verdict.md, it1-response.md (writer, code-agent and editor-pass sections), it1-editor.md,
it1-audit.md, it1-refs.md; `git diff HEAD` of book/04c-alphasimr-pipeline.qmd, book/90-notation.qmd,
book/references.bib, R/13_alphasimr_bridge.R, inst/scripts/run_alphasimr.R. The chapter was purled and
executed twice, in independent processes, with `pkgload::load_all` (runs "a" 1.93 min, "b" 1.78 min).
Every `stopifnot()` passed and all 218 inline expressions evaluated with 0 errors in both runs.
Scratch: /Users/ederdbs/.claude/jobs/1f3dbb75/tmp/it2/ (inline_a/b.rds, env_a/b.RData, fig_a/b.png).

PREVIOUS IDS
- 04c-D1 -- CLOSED -- :959-977. The 0.997 is now attributed to the dominance weights d_k(1 - 2p_Bk) being small (inline mean |1 - 2p_Bk| = 0.144), which follows from quickHaplo frequencies. The text says explicitly that zero divergence is not the cause and that divergence is one route among several. The confounded Step 6 vs Step 8 comparison and the unsourced "kept apart" sentence are gone. :1540-1545 adds the split-0 identity mean|1 - 2pbar| = 1 - 2 maf_pooled, which is exact because maf_pooled = mean(pmin(pbar, 1 - pbar)) (:1396). The values are 0.538/0.541 against 0.098.
- 04c-D2 -- CLOSED -- :1586-1588. The transfer claim is replaced by an explicit statement that no other scale was simulated.
- 04c-D3 -- CLOSED -- :1852-1855, 1890-1902, 1907-1914, plus the fig caption and legend. Both statistics are labelled as testcross means of the A x B level. The text states that per-pool contributions are not identified. The cor_AB is explained by construction, with the founder-draw share declared unseparated.
- 04c-M1 -- CLOSED -- :155 "advances by the same amount" now agrees with the assertion at :135. (The caller note on CLAUDE.md's "unpredictable amount" wording still stands. It is outside this chapter.)
- 04c-M2 -- CLOSED -- :267-270.
- 04c-M3 -- CLOSED -- :1658-1664. Checked against R/13 (sample() only in the random pick).
- 04c-M4 -- CLOSED -- :490-494. G_i - sum a(x - 2p) = mu0 + sum a(2p - 1) follows from the bv() assertion at :450-451.
- 04c-M5 -- CLOSED -- :894-897.
- 04c-M6 -- CLOSED -- the timings are removed from the chapter and from run_alphasimr.R.
- 04c-R1 -- CLOSED -- :1547-1580. The unconditional mechanism sentence is replaced by the LE algebra for both parts, which is correct for 0/1 DH lines: var(add) = sum a^2 pA qA, var(dom) = sum d^2(1 - 2pB)^2 pA qA. The sign of the GCA_var_dom change is now verdict-conditional. It flipped between my two runs (+0.007, t = 0.6; -0.006, t = -0.6), and the text handles both. The add-vs-dom attribution held in both (0.154 vs 0.110; 0.211 vs 0.081).
- 04c-R2 -- CLOSED -- the "24 pairs" anecdote is gone. :1918-1923: the ratio of mean to paired s.d. is 0.9 (a) and 1.0 (b), and the 48-draw t is -6.8 and -7.1. Both runs support "a single draw does not settle its sign".
- 04c-R3 -- CLOSED -- :135-136 asserts identical quickHaplo genotypes and non-identical runMacs genotypes. It passed twice.
- 04c-R4 -- CLOSED -- :244-252 narrows the claim to execution-order reproducibility. Steps 1-7 objects (vtab, lottery, traj, sweep_q, grid, jensen, idx_tab, H, var_gca, var_sca, H_bar_obs, fact_tab) are `identical()` across the two runs, and every one of the 64 inline values that differ is a Step 8 value.
- 04c-R5 -- CLOSED -- :290-293.
- 04c-R6 -- CLOSED -- :302-307. Inline: AlphaSimR 2.1.0, 8 constructors (A, AD, ADE, ADEG, ADG, AE, AEG, AG = 2^3 combinations of D/E/G), which matches the prose.
- 04c-R7 -- CLOSED -- n_lot, n_f1, n_prog and the G ratio (4.6) are now inline.
- 04c-R8 -- CLOSED -- the run_alphasimr.R header no longer claims the book reads its CSVs. The chapter has no book_data()/read.csv call.
- 04c-R9 -- CLOSED -- the F_ST = GD_BS/GD_T, restricted-index and DH-homozygosity assertions are added and pass.
- 04c-R10 -- CLOSED -- :1930-1932. The causal clause is removed and the unrecorded GD_T is declared.
- 04c-R11 -- CLOSED -- R/13 diff is `$` -> `[[` only, with no behavioural change.
- 04c-B1 -- CLOSED -- :496-498. The equation number is dropped.
- 04c-B2 -- CLOSED -- :679-681. This is refcheck's own proposed wording.
- 04c-B3 -- CLOSED -- :354-356. Mackay quote verified by refcheck. The hallauer2010 attribution (maize yield inbreeding depression) is consistent with Hallauer, Carena & Miranda Filho. Not re-checked by refcheck this iteration.
- 04c-B4 -- OPEN (non-blocking, as in it1) -- :695 and :785-786 "six or seven selfing generations" are still uncited. Not required in it1.
- 04c-B5 -- OPEN (non-blocking, metadata) -- untouched.
- 04c-B6 -- CLOSED -- pages = {jkaa017} added.
- 04c-E1 -- CLOSED -- the nine named-vector outputs are now labelled data.frame tables. The two remaining echoes are marked as such and every value they print is cited inline.
- 04c-E2 -- CLOSED -- book_pal colours, per-panel legend labels ("A on B"/"B on A"), and a unit on the left axis.
- 04c-E3 -- CLOSED -- the figure was drawn at 6.5 x 4 in from both runs' `arms`. Neither legend overlaps data in either draw. The left legend sits above all bars at cycles 1-2. The right legend's top (~0.105) is below the lowest cycle 1-2 bar (~0.124), and its text ends before the cycle-3 bars. Legend text at cex 0.8 is legible at print size. The placement is fixed while ylim is data-driven, so clearance is per draw, but it held in both draws.
- 04c-E4 -- CLOSED -- the splits and transpositions are applied, and each chunk's number of sub-captions matches its outputs (lottery 2/2, breeders 2/2, split 5/5, rep1 2/2, paired 2/2, pipeline 2/2).
- 04c-E5 -- CLOSED -- the GCA/SCA symbols are renamed to g^A_i, s_ij, and the local clashes are declared. 90-notation's new table is consistent with the chapter ($\bar H$ = the $\mu$ "grand mean of H_ij over the complete factorial" of the heterosis table; $\alpha^{(B)}_k$ = a + d(1 - 2p_B)).
- 04c-E6 -- CLOSED -- the trailing console output is moved to its own chunks, and the dim() is replaced by an assertion.
- 04c-E7 -- OPEN (optional, editor's domain) -- not done. Non-blocking.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 04c-M7 book/04c-alphasimr-pipeline.qmd:1882-1886 -- "is close to the ... it would be if they were independent: pooling does what it should there" is a hand-written verdict on a draw-dependent number. Every other Step 8 verdict is render-conditional. Run a: cor_AB = -0.19, sd_pooled 0.017 vs 0.018. Run b: cor_AB = +0.21, sd_pooled 0.019 vs 0.017, i.e. above the independent value by about 10 %. "Close" still holds loosely in both runs, but the sign of the comparison flips and nothing in the text conditions on it.
- 04c-M8 book/04c-alphasimr-pipeline.qmd:1553-1556 -- when the covariance branch resolves to "beyond the two-sided 5 % point at split = 0" (run b: |mean|/s.e. = 2.34), the next clause ("a term within that point is not shown to differ from zero, which is not a bound on its size") speaks only to the other branch and reads as a non sequitur. The downstream inference at :1577-1580 then conditions only on the ratio's t, not on the covariance being negligible, which :1552-1553 itself makes the condition for reading the ratio as a partition. This is not disqualifying: the substantive claim (a larger part of var(GCA) is invisible to own genetic value after the split) is carried directly by the cor_perse_GCA contrast, t = -5.2 and -7.5 in the two runs. In run b, 1 - r^2 = 0.086 -> 0.188, against ratio values of 0.089 -> 0.201.

Accumulated M: 2 (< 3).

WHAT WAS VERIFIED
- Two independent executions, compared on every hand-written qualitative claim about Step 8:
  - F_ST and GD_BS rise, with each step many s.d. wide: split 0 -> 10 F_ST 0.021 -> 0.045, s.d. 0.002/0.005, in both runs.
  - The divergence share of heterosis rises: 0.020 -> 0.365 and 0.021 -> 0.358.
  - GD_T dips then rises from 100 to 1000: 16 and 15 s.e.
  - The rise comes entirely from fixed-difference sites: GD_T_other falls 0.312 -> 0.238 and 0.310 -> 0.239, and GD_T_fixed rises 0 -> 0.094/0.092.
  - The ratio rises (t 5.3, 7.5), cor_perse_GCA falls (t -5.2, -7.5), and both values stay below Step 6's 0.997.
  - The additive part falls (0.409 -> 0.238; 0.549 -> 0.224).
  - The control loses diversity too (relative loss 0.50-0.53 in both).
  - The mean_tc pooling buys little (cor 0.93/0.78; sd_pooled 1.20/0.93 vs per-pool 1.16-1.28/0.95-1.03).
  - The response is beyond t_crit (mean_tc_A t 15.0/18.7, mean_tc_B 15.9/16.2, hybrid 16.7/20.5).
  - The gd and GD_BS/F_ST verdicts resolve identically in both runs.
  - The stage-2 ceiling paragraph holds: run a's ceiling is -1.08 % and every DE row equals ref_truncation; run b's ceiling is positive.
  - All hold except M7's loose "close".
- Between-run movement of Step 8 means: |z| <= 1.6 for all but four of 44 (GCA_var/GCA_var_add/GCA_cov2 at split 0 at 2.3-3.0; GCA_cov2 at split 1000 at 2.3). This is consistent with :2033 "moves by the order of its standard error" for a skewed variance statistic.
- D1 algebra: own gv of an inbred line = mu0 + 2 sum a(u - pA) + const, so the additive part of g^A_i is an exact linear function of it, and only the dominance part sum d(1 - 2pB)(u - pA) can be invisible. mean|1 - 2p| = 1 - 2 mean(maf) holds per site and hence on averages.
- R1 LE variances for 0/1 DH lines: var(sum a(u - pA)) = sum a^2 pA qA; var(sum d(1 - 2pB)(u - pA)) = sum d^2 (1 - 2pB)^2 pA qA. Correct, and it matches 90-notation's existing row.
- M4: G_i - bv_i = mu0 + sum a(x - 1) - sum a(x - 2p) = mu0 + sum a(2p - 1); the bv() = (x - 2p)a assertion is in-chunk.
- Steps 1-7 reproducibility across processes (12 objects identical()); quickHaplo identical / runMacs non-identical asserted.
- R6 count: 8 addTrait* methods in AlphaSimR 2.1.0 = A x {D, E, G} power set.
- Figure at 6.5 x 4 in, both runs, inspected (fig_a.png, fig_b.png): the caption, legend labels and axis agree with the text and with the D3 reading.
