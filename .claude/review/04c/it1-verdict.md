# 04c-alphasimr-pipeline -- verdict, iteration 1

VERDICT: REJECTED

Inputs consumed: `.claude/review/04c/it1-audit.md` (04c-R1..R11), `.claude/review/04c/it1-refs.md`
(04c-B1..B6), frozen render `book/_freeze/04c-alphasimr-pipeline/execute-results/html.json`
(hash current per the audit). Part reports grepped: `part-foundations*.md` and
`part-mating-and-testing-design.md` name 04c only as a citation source/target (05b -> 04c:258-294,
02b -> 04c:731-790, both marked "Kept"; 04e:35 opening, which is 04e's item). No open part-level
item is assigned to 04c.

## Disposition of audit and refcheck items

| ID | Required for approval | Reason |
|---|---|---|
| 04c-R1 | YES | crit. 4/5. 1423-1424 states as mechanism that the dominance weights grow and a growing part of GCA becomes invisible; the chapter's own `gca_only()` split (freeze: add 0.220 vs dom 0.102) and `GCA_var_dom` 0.054 -> 0.053 say the dominance part does not grow, and the audit shows its sign flipping across MaCS draws. Related to, but distinct from, 04c-D1. |
| 04c-R2 | YES | crit. 3. "seen both above and below `t_crit` at 24 pairs" (1826-1828) is an empirical claim no chunk produces and the audit's resampling contradicts (P ~ 0.03); 1720-1722 presents a 48-draw `t` of -7.5 (freeze) as threshold-dependent. |
| 04c-R3 | no | Claim currently true (4 executions + `nThreads = 1` in the audit; AlphaSimR source confirms the seed is `sample.int(1e8, 1)` per chromosome). Recorded only. |
| 04c-R4 | YES | crit. 2. A seeding policy is declared at 236-239 ("each step is reproducible on its own") and violated at 370, 386-387 and 498-503, which inherit the stream from line 280 through chunk order. |
| 04c-R5 | YES | crit. 5. The displayed comment at 276-279 says re-executing Step 1 moves the stream; Step 1 asserts (132) that it does not. |
| 04c-R6 | YES | crit. 1 (factual). "There are four trait constructors" (288) is false for AlphaSimR 2.1.0 (eight). |
| 04c-R7 | no | Hand-typed numbers all match the frozen tables (0.320, 1.95/2.19, 0.025/0.010, 60, 400); quickHaplo-based, reproducible. |
| 04c-R8 | no | Machine-dependent CLI timings; recorded. |
| 04c-R9 | no | Values printed and correct (6.6e-17, 1.0); F_ST = GD_BS/GD_T asserted in 02. |
| 04c-R10 | YES | crit. 4. "`F_ST` rises partly because `GD_T` falls" (1729-1730) is a causal decomposition with no measured `GD_T` in `rep_tab`. From the frozen means, GD_BS/F_ST is 0.238 (selected) vs 0.241 (control): whatever share exists is small and unmeasured. |
| 04c-R11 | no | Package code outside this chapter; no number affected. |
| 04c-B1 | YES | crit. 7. "Eq. 7.2" (459) is a specific attribution refcheck could not confirm, and it is the one place the chapter departs from its own stated practice of not attributing unverified equation numbers (309-310, 469-470, 585-586, 646-647). Unsupported, not shown false. |
| 04c-B2 | YES | crit. 7. "@mackay2020 argue is the same phenomenon" (613) drops the source's hedge ("two sides of the same coin", "to a considerable extent"). |
| 04c-B3 | YES | crit. 7. "the standing hypothesis for yield in maize" (331-332) cites nothing. |
| 04c-B4 | no | Standard practice statements; recorded. |
| 04c-B5 | no | Metadata only; attributions checked and hold. |
| 04c-B6 | no | Cosmetic bib metadata. |

DISQUALIFYING FAILURES
- 04c-D1 [criterion 4, also 5] book/04c-alphasimr-pipeline.qmd:872-878, Step 6 "The last number is the one to hold on to" -- The paragraph attributes the Step 6 correlation 0.997 to the pools having "no divergence" ("With pools that have no divergence, p_Bk sits near one half"), and concludes "Divergence is what makes the testcross informative beyond the line itself" from Step 8 being lower. Both links fail on the chapter's own numbers. p_Bk near one half comes from `quickHaplo()` sampling alleles at frequency one half (the chapter says so itself at 581-583). It is not a consequence of zero divergence. Step 8's `split = 0` row has no divergence (F_ST 0.021, GD_BS 0.007) and a pooled MAF of 0.229, so (1 - 2 p_B) is far from zero on average. That row already gives `cor_perse_GCA` = 0.948 and `GCA_dominance_share` = 0.105. Of the total fall from 0.997 to 0.889, about 0.049 occurs at zero divergence (allele-frequency spectrum, founders, trait draw) and 0.059 comes from the split. The sentence "Step 8 measures the same correlation on pools with a real split, and it is lower there" uses exactly the Step 6-vs-Step 8 comparison that 1402-1405 disowns as confounded ("crosses a change of founders, trait draw and line number"). Under the GCA closed form of 841-842 (verified), what drives the dominance part of GCA is |1 - 2 p_Bk| of the tester pool, whatever its source. Divergence is one route to it and not the only one. "It is the reason heterotic pools are kept apart" is a breeding-history claim with no source.
- 04c-D2 [criterion 3, also 6] book/04c-alphasimr-pipeline.qmd:1430-1432 -- "The direction transfers; the numbers do not." This generalises beyond the one scale simulated (12 + 12 founders, 750 sites, 20 draws per split, uncalibrated `split`) with no run at another scale. At this scale the dominance-part direction is not even stable between founder draws (04c-R1: `GCA_var_dom` split 0 -> 1000 goes down in three executions and up in one). A transfer claim needs evidence at a second scale, or it must be stated as an assumption. It cannot be asserted as a property.
- 04c-D3 [criterion 4] book/04c-alphasimr-pipeline.qmd:1702-1703 and 1712-1713 (also the per-pool framing at 1664-1668 and the left panel of fig-alphasimr-cycles) -- `mean_tc_A` is the mean testcross phenotype of pool-A DH lines on testers drawn from the *current* pool B, and `mean_tc_B` is the reverse (R/13_alphasimr_bridge.R:137-143). Each is therefore an estimate of the same A x B hybrid level, carrying both pools' progress. The frozen selected means are identical (4.579 and 4.579). Two consequences follow, and the text draws neither. (a) "reciprocal recurrent selection responds in both pools" (1712-1713) does not follow from both `t` exceeding `t_crit`. Improvement in pool A alone raises `mean_tc_A` (better A lines) and `mean_tc_B` (better A testers) together, so the per-pool response is not identified by these metrics. (b) The 0.934 correlation between the two pools' paired differences is attributed to "the founder draw moves both pools' response together" (1702-1703). The construction of the two statistics accounts for it with no appeal to the founder draw. The causal attribution is untested and has a structural alternative the chapter does not mention. 1802-1804 acknowledges that the testers change from cycle to cycle. It does not acknowledge that the two "per-pool" responses are not separable.
- 04c-R1, 04c-R2, 04c-R4, 04c-R5, 04c-R6, 04c-R10, 04c-B1, 04c-B2, 04c-B3 -- required, see table above.

NON-DISQUALIFYING OBSERVATIONS
- 04c-M1 book/04c-alphasimr-pipeline.qmd:150-152 -- "R's own random stream is untouched by that" is followed at once by "`runMacs()` draws a seed for MaCS from R's stream". The measured property, asserted at 132, is that the stream is consumed by a fixed amount. "Untouched" contradicts the next sentence. Note for the caller, not a chapter finding: CLAUDE.md ("MaCS ... consumes an unpredictable amount of R's own random stream") contradicts this chapter's own measurement and the `alphasimr_founder_pools()` help page (R/13:57).
- 04c-M2 book/04c-alphasimr-pipeline.qmd:254-256 -- "the accuracies there are computed on a different simulator for this reason" reads as if @sec-genomic-prediction's simulator handled founder LD. In 08b the traits are `Z %*% B` on the markers themselves (08b:96-113), so there is no LD and no marker-QTL gap at all. The cross-reference misdescribes why those accuracies are a best case.
- 04c-M3 book/04c-alphasimr-pipeline.qmd:1499-1500 -- "the difference between the two arms is selection and nothing else". The control arm calls `sample()` (R/13:145), so from the cycle-1 elite pick onward the two arms' RNG streams, and hence their Mendelian sampling and phenotyping draws, are different realisations. The arms differ by selection in expectation, plus independent sampling noise. The paired `t` is still valid. The sentence overstates the pairing.
- 04c-M4 book/04c-alphasimr-pipeline.qmd:452-456 -- "per se phenotype already is breeding value up to the additive/genic gap discussed below". The varA/genicVarA ratio is a variance ratio. It has no bearing on whether an inbred line's genetic value equals its breeding value, and the chunk at 415-416 shows that they are equal up to a constant. Phenotype also carries error. The qualifier is wrong.
- 04c-M5 book/04c-alphasimr-pipeline.qmd:813-815 -- "will take every entry from the two best crosses and nothing from the rest" is stated unconditionally, with no measurement and no source. How concentrated truncation becomes depends on family number, family size and heritability.
- 04c-M6 book/04c-alphasimr-pipeline.qmd:1833-1834 -- CLI timings (~10 s / ~2 min) disagree with the audit's measurement (40 s / 29 s, with the order inverted). Same item as 04c-R8.

Accumulated M: 6 (>= 3), which rejects on its own as well.

WHAT WAS VERIFIED
- Step 2 genetic-value model G = mu0 + sum a(x-1) + sum d 1[x=1]: asserted in-chunk against gv(); scale of a (half the homozygote difference) is consistent with F&M Ch. 7.
- Step 3 varA_LE = sum 4pq a^2 for homozygous lines (var of a(x-1), x in {0,2}); genicVarA = sum 2pq alpha^2, alpha = a + d(q-p); inbreeding depression at F=1 = 2 sum d p q (F&M M_F = M_0 - 2F sum dpq): all algebraically correct, and two are asserted against genParam(). Frozen ratios 2.34 = 1.99 (LE) + 0.35 (LD), 1.06 after mixing: consistent with prose.
- Step 4 H_ij = sum d 1[u_i != u_j] and H_bar = sum d (pA + pB - 2 pA pB): derived by hand, asserted in chunk. pA + pB - 2pApB = 2 pbar qbar + y^2/2, so with `heterosis_partition()`'s divergence = sum d y^2/2 (R/13_dominance.R:86), F&M's H_F1 = sum d y^2 is exactly twice it, as the text says.
- Step 4 frozen lottery: f1_mean 15.0/15.35/14.03 > better parent 12.19/12.19/9.63; transgressive 0.025/0.010/0.320 vs gap 1.95/2.19/0.45: prose ("about a third", "two DH s.d.", "a few percent") matches.
- Step 5 E[M_Ft] = midparent + H (1/2)^(t-1): correct for selfing from an inbred x inbred F1; H_F2 = H_F1/2 consistent with F&M Ch. 14 (F1 selfed = F1 x F1 when all F1 are identical).
- Step 6 GCA_i = sum (a + d(1-2pB))(u_i - pA): derived by averaging G_ij over the factorial; asserted in chunk. alpha^(B) = a + d(qB - pB) is the average effect of an allele substituted into a pool-B gamete background -- correct.
- Step 6 accuracy prediction: Var(sbar_i) = (s2_i/t)(nB-t)/(nB-1) (sampling without replacement, zero row mean), sum_i sbar_i = 0 exactly (zero column means), so E[sample var] = nA/(nA-1) mean_i Var(sbar_i); v_e = varE/(t r); tester GCAs common to all candidates drop out. Correct to first order. Frozen max |z| 1.63 over 8 cells; Jensen term <= 0.0032.
- Step 7 dG = G b / sqrt(b'Pb), aggregate = cor_with_H * sqrt(a'Ga) (asserted); b = P^-1 G a; b proportional to a iff a is an eigenvector of P^-1 G; G = cP sufficient; help-page example P = [[2,.5],[.5,2]], G = I: P(1,1)' = 2.5(1,1)', so equal weights are exact -- correct. Frozen SH weight ratio 0.0589/0.0789 = 0.75; equal-weight loss 0.16%.
- Step 1 mechanism: `deparse(AlphaSimR::runMacs)` shows the seed as `sample.int(1e+08, 1)` per chromosome, so identical .Random.seed after two calls from one seed implies the same seed handed to MaCS; the inference "MaCS output is not a deterministic function of its seed" is valid given the asserted stream equality.
- Step 8 bridge: runMacs2 called without inbred = TRUE (outbred founders), nQtlPerChr = seg_sites (every site a QTL), testers = first n_testers individuals of the current opposite pool, random_elite via sample() (R/13:80-145) -- matches the declared assumptions at 1183-1191, 1453-1457, 1799-1804.
- Step 8 ascertainment reading: frozen GD_T 0.300 -> 0.329 (split 100 -> 1000) with GD_T_fixed 0.005 -> 0.090 and GD_T_other 0.296 -> 0.238: "the rise comes entirely from sites fixed for opposite alleles" holds arithmetically; GD_T = mean 2 pbar qbar is asserted in the chunk.
- Step 8 paired table (freeze): gd_elite_mean t = -7.5, hybrid_meanG t = 14.0, GD_BS t = 11.0, mean_tc_A/B selected means both 4.579, cor_AB(mean_tc) = 0.934 -- the basis of 04c-D3.
- Step 6 vs Step 8 split-0 row (freeze): cor 0.997 vs 0.948, F_ST 0.021, maf_pooled 0.229 -- the basis of 04c-D1.
