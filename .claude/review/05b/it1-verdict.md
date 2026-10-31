# 05b verdict, iteration 1 (book/05b-heterosis-dominance.qmd)

VERDICT: REJECTED

## Disposition of the audit (05b-R*) and refcheck (05b-B*) findings

| ID | Required for approval | Reason |
|---|---|---|
| 05b-R1 | YES [crit 1, 5] | Marker coding in the protocol contradicts itself: :1215 `pool_freqs(GL, pool)`, :1221 `pool_freqs(GL / 2, pool)` (same step), :1353 `s1_monitor(GL / 2, ...)`, :1203 `diag(molecular_coancestry(GL))`. R/05_pipeline_metrics.R:25,59 document GL as 0/1, so `GL / 2` halves the frequencies; on 0/2 data step 1's check reports self-coancestry ~3. This is the coding-scale confusion criterion 1 names. |
| 05b-R2 | YES [crit 1, 4] | :1515-1516 "related but carry no linkage disequilibrium" and :1561-1563 "isolates relatedness only -- there is no LD in it". Lines from six founders carry founder-sampling LD (audit: mean r^2 0.0676 against the 0.0417 floor). The cross-locus covariance that the closed forms omit, and that the GCA deviations pick up, is that LD. What the construction leaves out is physical linkage. So the text mislabels what its own measurement measures, and the "relatedness half / linkage half" split at :1513 rests on the mislabel. |
| 05b-R3 | no | Each identity is displayed with its residual printed, and the audit reproduced all of them (0 to 7e-12). Turning them into assertions is a project convention, not a failure of evidence. |
| 05b-R4 | no | :852-865 gives the derivation in full (s = DC(H), H = dm(1 - f^L), DC annihilates constants). The audit confirms it numerically (1.07e-12). |
| 05b-R5 | YES [crit 2, 5] | :1359 step 5's Check compares `mean_sq_delta_p / 2` with `gd_partition()`'s GD_BS and gives no weighting condition. Step 4 (:1314-1349) shows that comparison off by tens of per cent on any selected subset. The assumption is declared in step 4 and then dropped silently in the next step's check. |
| 05b-R6 | no | Every hand-typed number is true at the current seed (5.29, 0.30, 1.55, k = 5 at 0.8518). The k = 5 margin is 0.2 SE (see WHAT WAS VERIFIED). :1481-1482 frames it as specific to this ratio and asks for recomputation, so it does not reject. |
| 05b-R7 | YES [crit 5] | :325-328 says "A subset chosen by an optimiser ... measured on four such subsets". 05-genomic-era.qmd:217-220 has one random draw, two greedy runs and one truncation. The chapter misdescribes the evidence it points to. |
| 05b-R8 | no | Divisor mismatch, about 4 % on the GCA rows. No conclusion changes. I checked that it does not explain the step 6 residuals either (see WHAT WAS VERIFIED). |
| 05b-R9 | YES [crit 1] | :1095-1096 "zero only at the degenerate limit where one pool is fixed at every locus" is a false "only if". sigma^2_SCA = 4 sum d^2 pAqA pBqB (:877) is zero iff, at every locus, at least one pool is fixed. One pool fixed everywhere is a special case. |
| 05b-R10 | no | :1353 "three divergence columns" undercounts: `s1_monitor()` also returns Fst_Wright and Gst_Nei. Minor. |
| 05b-R11 | no | Optional. The tension it raises (the formula locates the expected peak, the grid does not locate the realised one) is defensible as written. |
| 05b-R12 | no | Style. |
| 05b-B1 | no | Technow et al. (2014) GBLUP is built on the two GCA relationship matrices. That is an additive (GCA-only) hybrid model, and it reached 0.75-0.92. The sentence at :1058-1061 does not claim that every model they fitted was additive. The SCA-share figures the refcheck quotes would be stronger support, but the current attribution is not false. |
| 05b-B2 | no (for 05b) | references.bib metadata (Powell missing from the mackay2020 author list). Bibliographic, owned by refcheck/bib. Fix it in the bib. It does not affect what 05b attributes. |
| 05b-B3 | no (for 05b) | Same as B2 (white2020 issue and pages). |
| 05b-B4 | no | :86 "[@falconer1996, Eq. 7.2]". The formula and the chapter are right; the equation number is unconfirmed, possibly 7.1. Recorded as unsupported, not false. Check it against the physical copy. |
| 05b-B5 | YES [crit 7] | :113-116 "Fisher's statistical dominance deviation" names an author and a result with no reference. |
| 05b-B6 | YES [crit 7] | :749-763 "the classical decomposition falls out" and the GCA/SCA concepts are invoked as classical with no source. @comstock1949 (:793) is cited for RRS, not for the decomposition. |

## Part-level inputs

- part-mating-and-testing-design C6 (Step 6 duplicates 04e) and C4 (r_k vs rho/"r = plots"): taken up as 05b-M3. Note that the C6 owner argument ("04e comes first") is wrong about reading order. 05b is in Foundations (book/_quarto.yml:30) and 04e is in Mating and testing design (:51), so 05b comes first. The redundancy is real, but resolving it means a forward pointer from 05b and a back-reference from 04e. It does not mean 05b citing 04e as prior.
- part-mating-and-testing-design C1/C3, sigma^2_GCA_A at 05b:1400 (now :1407): 05b's symbol is declared at :875 and matches 90-notation's heterosis table. The cross-part clash belongs to 04e/04f. Within 05b the same symbol family is inconsistent, raised as 05b-D2.
- part-foundations (+ verdict): nothing still open names 05b. C1 is closed, and C4/F-M1 closed with the 90 mapping, which lists @sec-heterosis.

VERDICT: REJECTED

DISQUALIFYING FAILURES
- Required from the reports: 05b-R1, 05b-R2, 05b-R5, 05b-R7, 05b-R9, 05b-B5, 05b-B6 (see table).
- 05b-D1 [criterion 3/4] book/05b-heterosis-dominance.qmd:1606-1611, "What this does not change" -- "Two plans with the same alpha and the same GD_BS can differ in expected heterosis by half again, if one of them concentrated its divergence on the dominance loci -- that is the scenario table of @sec-heterosis-alignment". The scenario table (:640-650) holds one pool pair's frequencies fixed and re-sorts d against y^2 to the two extremes of perfect alignment and anti-alignment. It compares genetic architectures, not plans. A selection plan cannot move d. It can only change the selected set's frequencies, under the constraints of the candidate pool and of alpha. Nothing in the chapter shows that two attainable plans at equal alpha and GD_BS can be that far apart, and the 1.55 is the extreme of a permutation, not a measured difference between plans. A construction-level bound is presented as a property of plans. (:1659-1662 and the fig-cap at :654 describe scenarios and are not affected.)
- 05b-D2 [criterion 5] book/05b-heterosis-dominance.qmd:1036 vs :1465/:1481 -- sigma^2_GCA means two things. At :1036 the share is "sigma^2_SCA over sigma^2_GCA + sigma^2_SCA", with sigma^2_GCA = var_GCA = va + vb, both pools (:972-973). At :1481 the threshold is stated "at this sigma^2_SCA/sigma^2_GCA ratio", and that ratio is the one at :1465, sigma^2_SCA/sigma^2_GCA_A = v_sca / var(gca_A), one pool (:1419-1420). The values differ by about a factor of two. A reader who carries the :1036 definition into the step 6 threshold uses the wrong ratio.

NON-DISQUALIFYING OBSERVATIONS
- 05b-M1 book/05b-heterosis-dominance.qmd:366-367 -- the premise of the "tempting" argument writes gene diversity as sum_k p_k q_k. The book's GD (Nei's He) is the mean over loci of 2 p_k q_k. The argument is refuted on other grounds, but its premise misstates the quantity by a factor of 2 and confuses a sum with a mean.
- 05b-M2 book/05b-heterosis-dominance.qmd:511-519, 912-957 vs :628-631, :665, :1570-1573 -- F_ST is the Balding-Nichols parameter in every expectation and the frequency statistic in the alignment and step 8 text ("a function of the frequencies only"). 90-notation.qmd:139-145 declares this book-wide convention, but 05b never states it locally. Its only pointer is "@sec-notation" at :465. Under BN the two differ (statistic about F_BN/(2 - F_BN)). No conclusion here depends on the difference.
- 05b-M3 book/05b-heterosis-dominance.qmd:1373-1482 (Step 6) -- duplicates 04e's layout-rank argument and k-tester accuracy curve (04e @sec-mating-connectivity, @sec-mating-tester; part review C6), in different symbols (r_k, sigma^2_GCA_A against 04e's rho, sigma^2_g). 05b has no forward pointer to 04e. 04e calls the two "the same curve" (04e:411). Redundancy and notation only.

Three non-disqualifying observations meet the accumulation threshold. The verdict is already REJECTED on the disqualifying items.

WHAT WAS VERIFIED
- pA + pB - 2pApB = 2 pbar(1 - pbar) + y^2/2 -- expanded by hand, exact.
- Falconer & Mackay Ch. 14, H_F1 = sum d y^2 for a cross of two random-mating populations; the factor-of-two reconciliation at :236-249 -- algebra checked, and the chunk at :255-261 asserts it.
- GD_T + GD_BS = 1 - theta_AB and 2 GD_WI_hyb = GD_T + GD_BS -- from gd_partition's definitions, and a hybrid's self-coancestry 1 - h/2. Correct on the full factorial.
- ID = 2F sum d pq, and at F = 1 it equals the shared term at pA = pB -- correct (F&M Ch. 14, M_F = M_0 - 2F sum d pq).
- BN halves: E[2 pbar qbar] = 2pq(1 - F/2), E[y^2/2] = F pq; Ep = 2(0.5 - (0.81/12 + 0.25)) for U(0.05, 0.95) -- derived; matches :525-527.
- Sample-frequency offset (VA + VB)/2, with expectation Ep(1 - F)(1/nA + 1/nB)/4 -- derived; matches :562.
- GCA/SCA expansion u + v - 2uv -- expanded by hand, exact. Opposite-pool weight (1 - 2pB) = qB - pB is the average-effect frequency factor.
- Variance closed forms under independent Bernoulli lines; BN expectations E[pAqA] = pq(1 - F), E[(1 - 2pB)^2] = (1 - 2p)^2 + 4F pq -- derived.
- GCA concavity: the F^2 coefficient is -4 d^2 (pq)^2; the derivative at 0 is positive iff 8pq > 1, i.e. p in 1/2(1 -+ 1/sqrt 2); F*_k = (8pq - 1)/(8pq); the peak of the sum is the d^2 (pq)^2-weighted mean of F*_k -- derived. The SCA/GCA_A ratio is monotone decreasing.
- r_k with finite-population correction (n_B - k)/(k(n_B - 1)), using zero row sums of s -- derived.
- Step 6 residuals vs divisor (R8): re-ran the tester scan (book_cfg, seeds as in the chapter). Ratio var() 2.199 against population divisor 2.287. z vs SE at k = 1/3/5/10 is -2.36/+2.61/-0.40/+0.69 with var() and -2.09/+3.23/+0.10/+1.28 with population divisors. The divisor does not account for the residuals the text discusses. At k = 5 the mean is 0.8518 with SE 0.0091, so the "r > 0.85" threshold sits 0.2 SE above the boundary.
- 05-genomic-era.qmd:217-220 read for R7. R/05_pipeline_metrics.R:25,59,94,159 read for R1/R10. book/_quarto.yml:30,51 read for chapter order.
- Not redone: the audit's freeze/inline-number recomputation and its LD measurement for R2. Both were consumed as reported.
