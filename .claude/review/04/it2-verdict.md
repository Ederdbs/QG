# 04-population-sizing -- verdict, iteration 2

VERDICT: REJECTED

PREVIOUS IDS
- 04-D1 -- CLOSED -- "-2.0%" is no longer presented as the bias. tbl-sizing-verify-junctions measures the deficit on the grid (SSD -3.78%, syn1 -5.14%, syn2 -6.36%, 340 replicates each), and the 1 cM claim is now measured (-2.28%, s.e. 0.75%). Both are consistent with the two-state argument (-3.4% at 2 cM, -1.7% at 1 cM). The unreconciled second 2 cM figure is M11.
- 04-D2 -- CLOSED -- the threshold is computed inline (n_f1) and "already" is gone. The table, the prose and Working numbers now agree. The new problem with the quantity itself is D13.
- 04-D3 -- CLOSED -- f1_sizing() returns 2 h_res n_loc 2(1/2)^n, and the chapter asserts it (qmd:634-635). The test and roxygen are updated.
- 04-D4 -- CLOSED -- the Working-numbers values are computed from the grid: +300 plants buy +0.0072 (0.98863 - 0.98145, both grid points). No N outside 10-390 is recommended. The new problem in the same table is D12.
- 04-D5 -- CLOSED -- N90 is defined (qmd:494-498), the recovery criterion P >= 0.95 is absolute and has a closed form, one population per N is stated, and so are the non-monotonicity and the sim < closed comparison (57/60). The new problem with the min(p, 1-p) crossing is D14.
- 04-D6 -- CLOSED -- D(390) = 0.9886 (s.d. 0.0017, 10 replicates) is reported as a finite-N value, and "no limit computed" is stated.
- 04-D7 -- CLOSED -- P1 is declared the adapted parent and beta = 6 a model input. The loss is attributed to the input, and "holds at this beta only" is stated (qmd:116-122, 443-449).
- 04-D8 -- CLOSED -- block length is computed from the cached junc. SSD runs 43.2-44.4 cM with a slope of -0.002 (s.e. 0.069) per 100 plants. The broken pointer to the theory table is gone.
- 04-D9 -- CLOSED -- the het check carries 4 s.e. The diversity check uses 100 replicates per N (max |z| = 1.83), and junctions are set against simulation.
- 04-D10 -- CLOSED -- Lee 2002 is quoted ("nearly a four-fold"). (2 + g/2)L checks out: L at the F2, +0.5L per random-mating generation, +L over selfing to fixation, which gives 4L at g = 4. The g = 4/5 ambiguity is declared.
- 04-D11 -- CLOSED -- the sources are now named (haldane1919, falque2009, lu2002, zhang2018, fisher1954, winkler2003, sedcole1977, lee2002). Map lengths, attrition, h_res and the distorter bins are declared model inputs. No refcheck report was supplied for iteration 2: the specific figures attributed to lu2002 (17% of 1,820 markers, 36% in B73/Mo17) and falque2009 (about 15%, 6-23%) are unverified here, not judged false.
- 04-M1 -- CLOSED -- GD = D/2 is stated with its derivation and asserted (bridge: 0.4824 / 0.9648, and so on).
- 04-M2 -- CLOSED -- the Ns column is present and Ns = 1/(2 - D) is asserted (0.966-0.988).
- 04-M3 -- CLOSED -- the values are inline from maize_chr_len and expected_junctions().
- 04-M4 -- CLOSED -- there is now a seed per panel and per N, and the single-lineage seed is commented.
- 04-M5 -- CLOSED -- the chapter uses "ssd", and run_scheme() has match.arg (tested).
- 04-M6 -- CLOSED -- s30 and map_br/dist_br. map4 and map10 are each bound once.
- 04-M7 -- CLOSED -- 1 - h_res is defined, and it is explicitly not an inbreeding coefficient.
- 04-M8 -- CLOSED -- the text now gives the coancestry (1 + F_F3)/2 = 0.875 with the F1 as base.
- 04-M9 -- CLOSED -- the regenerate.R header is corrected.

DISQUALIFYING FAILURES

- 04-D12 [criteria 4, 5] book/04-population-sizing.qmd:652-681, tbl-sizing-working-numbers, F2 row (qmd:662), with the caption (qmd:654), qmd:20-23 and qmd:497-498 -- the decision table gives "**90** (N90 for D)" in bold as the F2 plant number. Three statements in the chapter work against that row:
  1. Its own caption says "Size for the objective that binds, not for D".
  2. The introduction names sizing for the objective that saturates earliest as "the most common failure". D (together with min(p, 1-p), both N90 = 90) is exactly the earliest-saturating objective in tbl-sizing-saturation.
  3. qmd:497-498 says N90 is "relative to the grid's upper end ... a longer grid would move it". It is a 90%-of-gain point between the arbitrary grid ends 10 and 390, not a property of the cross.

  A grid artefact is presented as a planting recommendation, and the table's headline number contradicts its own caption. The next row ("not reached ... set by the precision required") does not say whether 90 is a minimum, a default or a recommendation.

- 04-D13 [criteria 1, 2, 5] qmd:618-628, :641-645, :669-670 (tbl-sizing-f1 and the F1 row), against qmd:27-31 (P1) and the roxygen at R/06_f2size.R:574-587 -- the chapter calls 2 h_res n_loc 2(1/2)^n "the expected number of lost loci". The function's own documentation now says, correctly, that it counts "(parent, locus) pairs that lose an allele". These are different quantities under the chapter's declared biallelic assumption. P1 states that "essentially every locus polymorphic between the parents is biallelic".

  Take a locus polymorphic between the parents at which P1 is residually heterozygous (Aa, against aa in P2). If every F1 receives P1's a, nothing is lost, because P2 supplies a. Only the event in which every F1 receives a (probability (1/2)^n, not 2(1/2)^n) makes the locus monomorphic.

  The expected number of lost loci is therefore about 2 h_res n_loc (1/2)^n, less a term of order h_res^2 for loci heterozygous in both parents. At the scenario values that is 500 x 2^-n: 0.977 at n = 9, against the chapter's threshold of 10. The factor 2(1/2)^n per (parent, locus) pair counts a loss of either allele as a lost locus, which holds only if neither allele of the heterozygous parent occurs in the other parent (multiallelic loci). That assumption is not declared, and it contradicts P1.

  "The two parents then segregate at 2 h_res n_loc loci" (qmd:624) also counts loci that are heterozygous in both parents twice. tests/testthat/test-f2size.R:74 hard-codes the threshold 10. The iteration-1 verification ("the 2(1/2)^n per-locus loss is correct") checked the allele-loss probability but not its labelling as loci lost. It is corrected here.

- 04-D14 [criterion 3] qmd:494-498 and :540, tbl-sizing-saturation, row "Worst region of the genome, min(p, 1-p)" -- N90 = 90 is reported as a single grid value with no dispersion, although the cached grid carries pmin_sd. The threshold is 0.0688 + 0.9(0.2424 - 0.0688) = 0.2251. Its own s.e. is about 0.006, from the endpoint mean with sd 0.0202 over 10 replicates. The replicate means are 0.2214 at N = 70 (s.e. 0.0081, 0.45 s.e. below the threshold) and 0.2326 at N = 90 (s.e. 0.0078, 1 s.e. above). The grid therefore does not separate N90 = 70 from 90 for this metric, and arguably not from 110.

  By contrast, D's N90 = 90 is resolved: 3 s.e. below the threshold at 70 and 2 s.e. above it at 90. The table states both crossing points with the same definiteness, and the section heading "The metrics saturate at different N" partly rests on them.

- 04-D15 [criterion 5] qmd:177-179, opening of @sec-sizing-verify -- "The checks below run on a 10 cM map with distortion switched off, so the neutral expectations apply exactly." Two of the four checks in that section contradict this:
  - tbl-sizing-verify-junctions (qmd:251-258) uses the cached grid at 2 cM with distortion active. Its caption says so, and the bulk row is explicitly not a test of the recursion.
  - tbl-sizing-verify-spacing (qmd:287-305) uses 2 cM and 1 cM maps.

  The section statement contradicts the captions of the tables it introduces. The junction comparison in particular is not a neutral-expectation check, because distortion is active. It is presented under a heading that says the neutral expectations apply exactly.

NON-DISQUALIFYING OBSERVATIONS

- 04-M10 qmd:380-390 -- the claim that the distortion gap "does not shrink with more plants inside the range tested" rests on a least-squares slope (-0.00017 per 100 plants) reported with no standard error. The gaps at the 20 points carry very different replicate errors (40 against 10 replicates), and the fit is unweighted. The claim is labelled as interpretation, but the number offered for it has no dispersion.
- 04-M11 qmd:273-279 against :309-315 -- the chapter gives two estimates of the SSD junction deficit at 2 cM, -3.8% (grid, distortion active, 340 replicates x 20 lines) and -5.1% (live neutral panel, 500 lines, s.e. 0.76%), and does not reconcile them. A neutral re-simulation here (2 cM, N = 10 x 150 replicates and N = 200 x 8) gives -4.2% and -3.9% (s.e. about 0.45%). The -5.1% is therefore a low draw, and the 2 cM vs 1 cM contrast in the text (-5.1 against -2.3) overstates the effect of halving the spacing by roughly a factor of 2.
- 04-M12 qmd:663-675 -- the Working-numbers row prints P(recovery) at N = 390 to three decimals (0.373 for k = 8, 0.070 for k = 10). These come from one population. Neither that row nor the table caption ("read off the SSD rows of the cached grid") says so. The limitation is stated where the curve is presented (qmd:561-564, fig-sizing-multilocus caption) but not where the numbers are reused for decisions.
- 04-M13 qmd:526-530, :553-554 -- the neutral check of eq-sizing-n95 reports P_neutral = 0.825 over 20 populations against 0.831 with no dispersion. The assertion tolerance of 0.05 has no stated basis.
- 04-M14 qmd:556-557 -- "for k = 3 both are at or near 1 from small N": at N = 10 the simulated value is 0.717 and the closed form 0.583, and at N = 30 they are 0.870 and 0.927. Both reach 0.95 only from N = 50.

Count of non-disqualifying observations: 5. This would independently reject (>= 3).

WHAT WAS VERIFIED

- The chapter, purled and executed in full against the worktree package (load_all), runs clean in 1.0 s, and every stopifnot passes.
- f1_sizing: 3.906 / 1.953 / 0.977 / 0.488 / 0.244 at n = 8 to 12, so n_f1 = 10 with the function as written. The biallelic recount gives 500 x 2^-n, so the threshold would be 9 -> D13.
- Saturation: N90(D) = 90, with threshold 0.98004 against D(70) = 0.97806 (s.e. 0.00066) and D(90) = 0.98145 (s.e. 0.00072), so it is resolved. N90(pmin) = 90, with threshold 0.2251 against 0.2214 / 0.2326 (s.e. about 0.008), so it is not resolved -> D14.
- D(390) = 0.98863, s.d. 0.00174, 10 replicates. The gain from 110 to 390 is 0.00668 and from 90 to 390 is 0.00718. The gap ranges over 0.00867-0.01077, with a slope of -0.000165 per 100 plants. 14 of the 15 steps past N90 lie within 2 s.e. of zero (the exception is 250 -> 270).
- F4 junctions: expected_junctions = 29.225 = 1.75 x 16.7 for SSD, 37.575 for Syn1 and 45.925 for Syn2. The grid deficits are -3.78, -5.14 and -6.36% (bulk -5.61%). The single-meiosis Haldane deficit at 2 cM is 0.5(1 - e^-0.04)/0.02 - 1 = -1.97%. The two-state prediction is -3.4% (2 cM) and -1.7% (1 cM), against -2.28 +/- 0.75% measured at 1 cM.
- A suspicion that Syn junction counts depend on N through finite-population loss of H (the recursion assumes H unchanged) was tested by neutral simulation and rejected: syn2 deficit -6.25% (N = 10) against -6.32% (N = 200), s.e. about 0.15 junctions. run_scheme avoids selfing and gives each plant one maternal and one paternal use. No finding.
- IBM: (2 + g/2)L gives 4L at g = 4, consistent with Lee 2002's "nearly four-fold".
- Sedcole closed form: N95 = 34 / 185 / 2230 / 11659 for k = 3 / 5 / 8 / 10 at p = 0.4375. The neutral check gives 0.8245 against 0.8309. The grid first reaches 0.95 at k = 5 at N = 270, and after that stays >= 0.95. sim < closed at 57/60 points for k >= 5, on independent populations across N.
- multilocus_recovery samples one locus per chromosome for k <= 10, so the loci are unlinked as stated. junctions_per_hap uses 20 lines per replicate in the grid (R/06:643), as stated.
- Bridge: GD = D/2 and Ns = 1/(2 - D) hold exactly, with Ns at 0.966 / 0.985 / 0.988. Coancestry within an F4 line is (1 + 0.75)/2 = 0.875.
- Block length: 1670/(29.225 + 10) = 42.57 cM expected. The grid SSD range is 43.2-44.4 cM, and the slopes on N have |t| < 1.1 for every scheme except syn2 (t of about 2.0), which the simulation above shows to be noise.
- bulk has the lowest mean D at 20/20 grid N. Bulk at 390 is 0.9540 against SSD at 30, 0.9614.
- 90-notation: the new symbols agree with the chapter's definitions, and the scope note is accurate.
