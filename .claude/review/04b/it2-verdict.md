# 04b-backcross-introgression -- verdict, iteration 2

VERDICT: REJECTED

PREVIOUS IDS
- 04b-D1 -- CLOSED -- The two paired tables are now written by `run_mabc.R --only=...` (`paired_cell()`, per-cell `seed` column, `strategy` column mapping script/drag to rec_bg/rec_drag). The other three tables are declared at 718-728 as predecessor output that has not been re-run or diffed.
- 04b-D2 -- CLOSED -- `which.max` is gone. Certification is now made on the CP lower bound: N = 400, lo 0.978 (binom.test 987/1000 gives [0.9779, 0.9931]). N = 250 has lo 0.901 and is not certified. The 90-rep uniform estimate is shown, 0.967 [0.906, 0.993] (371-382).
- 04b-D3 -- CLOSED -- The 1/g mechanism is removed. The recheck paragraph separates result (516-535) from inference (537-545) and states its scope.
- 04b-D4 -- CLOSED -- rec_bg and the 40 replicates are declared in the text and caption, with a granularity stopifnot. Per-schedule points carry their s.e., and the comparative caption claim is removed.
- 04b-D5 -- CLOSED -- tbl-bc-ibd now uses `mabc_opt$main_strategy`. The closed form is declared unconditional, with foreground conditioning and the simulated 0.946-0.964 range given (247-254).
- 04b-D6 -- CLOSED -- 172-176: the sum is exact and proportionality holds in expectation, with test tolerance 0.02 (test-mabc.R:111).
- 04b-D7 -- CLOSED -- The chunk uses 1 - expected_donor(3). The assumptions are declared (853-861). The ratio 0.1250 (reproduced, seed 11) is compared against the expectation 2D(1-D) = 0.1172, and the derivation at 891-898 is correct.
- 04b-D8 -- CLOSED -- The class is now stated as a pre-specified pair, q = 1/64. n_for_count gives 401 and 99.
- 04b-D9 -- CLOSED -- m is interpolated (344, verified).
- 04b-D10 -- CLOSED -- The "every number interpolated" claim is replaced. Rep counts are inline, and the 92-verification row is computed from the CSVs. (See D17 for a different self-description that the new captions now contradict.)
- 04b-D11 -- CLOSED -- P(IBD) is in tbl-bc-index. The minimum, 0.976 at k = 4, N = 80, equals 1 - p_lost (verified), and "every replicate" is removed.
- 04b-D12 -- CLOSED -- 4.90e-4, 4.6x and nu ~ 3 are removed. @falque2009 is cited with 4.2 < nu < 6.2. The magnitude is declared not computed.
- 04b-D13 -- CLOSED -- Sentence deleted.
- 04b-D14 -- CLOSED -- "Classical practice" and 1/g are removed, and @hospital2001 is credited. The abstract wording matches refcheck. The replacement paragraph has its own defect (D18).
- 04b-D15 -- CLOSED -- @rodgersmelnick2015, >1000-fold at the scale stated.
- 04b-D16 -- CLOSED -- @haldane1919 is cited, the Mendelian derivations are given in the text with unlinked targets declared, the unsupported claims are removed, and o2 is cited to @holding2008.
- 04b-M1 -- CLOSED -- Captions and counts are computed. The "by four" factors are computed (4.3, 4.05, 4.01).
- 04b-M2 -- CLOSED -- set.seed(5) and set.seed(6) are in place. The full-scan single seed is declared at 724-726.
- 04b-M3 -- CLOSED -- The exponent is interpolated.
- 04b-M4 -- CLOSED -- The R/08_mabc.R:409-415 docstring now matches the CSV (0.26-1.19 pp, mean 0.92, one kept-miss at k = 3, N = 80), and a new test asserts this. The run_mabc.R:326 caption computes 0.975.

DISQUALIFYING FAILURES
- 04b-D17 [criterion 5] book/04b-backcross-introgression.qmd:817, callout "Two statistical habits". The callout says "intervals are reported everywhere", and three captions added in this iteration contradict it:
  - tbl-bc-ibd says "means only, no dispersion shown" (:270).
  - fig-bc-policies says "no dispersion is shown" (:36).
  - fig-bc-f2 says "no interval is drawn" (:35).
  The chapter's description of its own reporting is false for three of its displays.
- 04b-D18 [criterion 3] book/04b-backcross-introgression.qmd:404-422, the paragraph replacing D14. It claims "Most of the reduction in that cell comes from letting drag decide, not from extending recombinant selection by one generation", and this is a comparative claim. It decomposes a drag reduction into two parts (rec12 -> rec_bg = 1.5 cM; rec_bg -> rec_drag = 26.9 cM). The parts come from three means of the uniform scan, 90 replicates each:
  - no dispersion is given (the CSV carries no drag s.d., only drag_q95);
  - the three policies are not paired (the scan is seeded once per scan, as 724-726 itself states);
  - the supporting stopifnot (:409) compares point estimates only.
  The 1.5 cM component is the one that carries "not from extending", and nothing shown says whether it differs from zero.
- 04b-D19 [criterion 3] book/04b-backcross-introgression.qmd:500-505, 521-523. The text says "The schedules with a 20-plant generation ... are the two lowest under both indices", and asserts it on point estimates. Under rec_bg the claim is not resolved:
  - 20/150/190 is 0.632 [0.601, 0.662] and 200/120/40 is 0.662 [0.632, 0.691]. The intervals overlap, the unpaired z is about 1.4, and the chapter itself says (480-481) that schedules are unpaired.
  - Two sentences earlier the chapter calls balanced and 40/120/200 under rec_drag "not separated" (z about 1.6).
  The ranking is therefore asserted at a lower standard of evidence than the one the same paragraph applies. It holds under rec_drag (0.872 [0.850, 0.892] against 0.924 [0.906, 0.940]), not "under both".

NON-DISQUALIFYING OBSERVATIONS
- 04b-M5 book/04b-backcross-introgression.qmd:650-651, 880-881 -- The code comments give typed "measured" maxima over seeds 1-200 (0.048, 0.044, 0.141), and these do not reproduce.
  - With the mask fixed (seed 5) and seeds varying for H1, the maxima are 0.031 and 0.056.
  - With the mask reseeded too, they are 0.051 and 0.042.
  - The GD ratio's relative error against 2D(1-D) reaches 0.148.
  The 0.06 and 0.15 tolerances hold at the seeds used, but the margin claimed for them is not the margin observed.
- 04b-M6 book/04b-backcross-introgression.qmd:51-52 -- The intro says run_mabc.R "is the writer of the six cached mabc_*.csv tables". 718-723 says three of them were produced by its predecessor and never rewritten. The intro is literally defensible (the script writes files of that shape) but reads as provenance, which is the point D1 was about.

WHAT WAS VERIFIED
- The certification at four genes was checked from mabc_index_comparison.csv (drag, k = 4):
  - N = 400: p_both 0.987, lo 0.9779, which reproduces exactly as binom.test(987, 1000).
  - N = 250: lo 0.9014, so the cell is not certified.
  - N_cert = 400 and N_prev = 250, matching the chunk logic.
- The uniform scan at the same cell gives 0.967 [0.906, 0.993] on 90 reps, and N = 320 gives 0.989 on 90 reps. "90 replicates each" holds.
- Balanced against 40/120/200 under rec_drag: 0.969 [0.956, 0.979] against 0.955 [0.940, 0.967], unpaired z = 1.64. "Not separated" holds.
- Under rec_bg, 20/150/190 against 200/120/40: 0.632 against 0.662, overlapping intervals, z about 1.4 (D19).
- (7/8)^20 = 0.0692 and (7/8)^40 = 0.0048. The observed p_lost is 0.063 (20/150/190) and 0.057 (300/40/20); the 40-plant schedules give 0.004 and 0.005.
- P(both | kept) under rec_drag is 0.969, 0.931 and 0.722. Both stopifnot inequalities at :512-513 hold.
- GD ratio: 0.12503 at set.seed(11), against the expectation 2D(1-D) = 0.11719 with D = 1/16. The algebra was checked: with the diagonal included, GD = ((n-1)/n)(1 - mean off-diagonal), so the diagonal factor cancels in the ratio.
- New stopifnot tolerances, swept over seeds 1-200:
  - proportionality maximum 0.031 (mask fixed) or 0.051 (mask reseeded), tolerance 0.06;
  - dosage against expected_donor(1) maximum 0.056 or 0.042, tolerance 0.06;
  - GD ratio maximum 0.148, tolerance 0.15, 0 failures.
  The sum identity is exact (maximum deviation 0).
- tbl-bc-ibd caption: 41 of 44 rec_drag cells have P(IBD >= 0.90) >= 0.95. The maximum kept-and-missed rate is 0.0033 (k = 4, N = 40, 1 in 300 reps).
- Index table: the minimum drag p_ibd is 0.976 at k = 4, N = 80, which equals 1 - p_lost (0.024). The IBD cost is 0.26-1.19 pp with mean 0.92, matching the R/08 docstring and the new test.
- Policy cell (k = 3, N = 200, s = 0.6, 90 reps): rec12 71.7, rec_bg 70.2, rec_drag 43.3 cM. No drag s.d. column exists in mabc_uniform.csv.
- build_map(maize_chr_len, 5)$m = 344 and expected_ibd(3, 0.6) = 0.975.
- Hospital 2001: the quoted conclusion matches the abstract wording recorded by refcheck (it1-refs.md:39). The bib entries hospital2001, rodgersmelnick2015, holding2008, haldane1919, falque2009 and lee2002 are present.
- Driver: paired_cell() reseeds rs[rp] before make_shared_ibd and before each arm (run_mabc.R:232-242), which is common random numbers within a cell. Schedule seeds are distinct per cell, so the schedules are unpaired, as the chapter states.
