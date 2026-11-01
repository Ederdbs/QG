# Verdict 05-genomic-era -- iteration 1

Inputs consumed: it1-audit.md (05-R1..R16), it1-refs.md (05-B1..B11), part reports
(grep for "05-genomic" / "@sec-genomic-era" / "05:"). Chapter re-run read-only (purl + source) to
confirm the decisive numbers.

```
VERDICT: REJECTED

PART-LEVEL INPUTS
- part-mating-and-testing-design C14 (04g -> 05 transition) -- CLOSED, not applicable: the book order
  in book/_quarto.yml now puts 05 directly after 04c (Simulation part), and 05:12-14 opens on exactly
  that bridge. The stale "the Metrics part" hand-off is 04g's to fix, not 05's.
- part-foundations-2 promises naming 05 (00 -> @sec-era-programme, @sec-era-step4; 05b -> @sec-era-fhom)
  -- all reported kept; no open item.

DISQUALIFYING FAILURES
- 05-D1 [criterion 1] book/05-genomic-era.qmd:1376-1379 and :1429-1432, Step 7 rank argument -- The
  text bounds rank(f) by min(rank(B), m) + 1 and calls rank_f == rank_incidence "a measurement ... not
  a theorem -- the extra dimension the bound allows is not attained". That extra dimension is
  unattainable: every row of B has two 1s, so B 1_L = 2 1_N and the constant vector is already in
  col(B); with X = B M_L / 2, col(f) is inside col(B) and rank(f) <= rank(B) is a theorem. Only the
  equality (generic M_L) is empirical. The text presents an impossibility as an empirical non-event.
  (= 05-R1)
- 05-D2 [criteria 5 and 2] :1060-1063, :1076, :827-828, fig-cap :1034 -- The managed-arm drift rate
  (dF = 0.0228, N_e = 22.0, "2.26 times the unmanaged rate", "more than twice the neutral rate") is
  read off a log(1 - F_drift) fit with R^2 = 0.9924, which fails the chapter's own threshold at
  :1089 ("treat R^2 < 0.995 ... as a non-constant rate"). The increments are visibly non-constant
  (0.0122 -> 0.0221 per cycle). A declared criterion silently violated on the number the chapter
  carries forward. (= 05-R2)
- 05-D3 [criterion 5] :553 and :624-626 -- "exceeded targets by ~40%" / "overshot by ~40%" for A is
  contradicted by the chapter's own transcription at :594-595: dF_hom 0.0070 (+40%) but dF_drift
  0.0084 (+68%). "Targets" plural is false for the drift lens. The source text rounding both to 40%
  does not license repeating it next to a table that shows otherwise. (= 05-R4, 05-B1)
- 05-D4 [criterion 5] :610-613 vs :506-507, :558, :605 -- Reading 1 says "No IBS scheme met both
  targets. G_LA came closest ... but 14% below target on dF_hom", treating 0.005 as a point target
  that G_LA misses; :506, :558 and the table caption :605 state that G_LA is the only scheme that
  meets both (the target is a ceiling, per the source's Conclusion). Two incompatible readings of the
  same result on one page. (= 05-B3)
- 05-D5 [criteria 5 and 7] :1504-1505 vs :367-369 and :1072-1073 -- "Their simulations all carry
  selection, so no conservation scheme was run" contradicts the chapter's own use of the source's
  random-GEBV arm as a run "with no selection whatsoever, which is the point @meuwissen2020 make with
  random GEBVs" (:1072-1073). Either the random-GEBV arm is selection-free or it is not; the chapter
  asserts both, and the first is an overstatement of the source's design. (= 05-B4)
- 05-D6 [criterion 3] :246-259 (chunk :216-234) -- Three comparative claims (truncation has the
  highest F_hom; its hybrids are more heterozygous; its GD_BS is larger) are made against the single
  `random` draw, which the chapter itself rules out at :808-815 ("no single draw can serve as a
  control"). No dispersion is shown. The audit's 1000-subset null shows the conclusion survives
  (F1_het z = +2.45, 0.7% of null), but the text does not carry that evidence. (= 05-R5)
- 05-D7 [criterion 7] :168-170 -- "Wright defined an inbreeding coefficient to run from 0 to 1 as
  heterozygosity ... falls" is a historical attribution with no reference, and it misstates the
  definition: Wright defined F as the correlation between uniting gametes; proportional loss of
  heterozygosity is a consequence (Falconer & Mackay, Ch. 3). (= 05-B6)
- 05-D8 [criterion 5] :1335-1336 vs :121 and :124 -- The caption of the lens table defines
  G_0.5 = 4f - 2J, an affine function of f; Step 7 states "G_0.5, which is the molecular coancestry
  this book calls f", and then checks f, not G_0.5. A symbol identified two ways in one chapter. The
  rank conclusion transfers (rank(4f - 2J) = 49 = rank(f) here) but the text does not establish it.
  (= 05-R12)
- 05-D9 [criterion 3] :1421 -- "A subset of 20 hybrids drawn from 50 lines is full rank" generalises
  one draw (31 lines used). Full rank is generic, not guaranteed: rank(B) < 20 is possible for a draw
  using few lines. (= 05-R13)

NON-DISQUALIFYING OBSERVATIONS (11; three or more would reject on their own)
- 05-M1 :246, :258 -- "highest F_hom" and "worst of the four": truncation is tied with `balanced`,
  which is the identical set (:835); the table has three distinct plans. (= 05-R6)
- 05-M2 :986-990, :995-996 -- a deviation of a 20-replicate mean is compared with the between-replicate
  s.d. of a single replicate (and the max over cycles with the s.d. at the last cycle); the scale for
  a mean is the s.e. (max dev / s.e. = 1.56 block, 2.06 DH). The "within the sampling noise"
  conclusion rests on the wrong yardstick. (= 05-R7)
- 05-M3 :1527, :992, :612-613, :628, :823, :1438, :105, :771 -- hand-typed derived numbers (39.3/13.0,
  R^2 >= 0.999, 2%, 14%, 0.3%, 0.0176, "four orders of magnitude", 1000 subsets, 71 + 71) that are
  correct today and will not follow a re-execution. (= 05-R3, R8, R9, R15)
- 05-M4 :407-411, :721, :1345-1351, :673-676, :61-65 -- identities stated in prose ("must read zero",
  "identically zero", f = 0.5 + 2 Zh Zh'/m, sum(G) = 0, rank_G = rank_f - 1, the incomplete/unequal
  p0 identities, F1_het = 2 GD_WI_hyb) are printed, not asserted. All hold numerically. (= 05-R10)
- 05-M5 :1390-1397 -- one set.seed(31) for two draws that matter; random_20 inherits the stream after
  random_60. (= 05-R11)
- 05-M6 :1034, :1043 -- caption hand-types run parameters and ylim is hard-coded to current data; both
  desync silently on a parameter change. Form belongs to quant-editor. (= 05-R14)
- 05-M7 :1081-1083 -- "@sec-cycles does this on run_cycles() output" right after defining
  dF = 1 - e^slope, while 11b:241-242 uses -slope, the approximation this chapter's checklist (:1552)
  says not to use. Fix belongs in 11b. (= 05-R16)
- 05-M8 :556 -- "the widest margin of the eight schemes": the source ran nine (G_VR2(~,M) is in their
  Table 2). The claim holds over nine. (= 05-B2)
- 05-M9 :28, :306, :1201, :1269, :1332, :1359, :121/124, :317, :428, :1478 -- VanRaden G, Nei's He/G_ST,
  G_0.5 (Toro et al. 2014), Liu & Woolliams 2010, Wood et al. 2014 named in prose without a reference
  key; the source is named, so not a criterion-7 failure, but nothing is resolvable. (= 05-B7..B10)
- 05-M10 :517-519 -- "which commercial programmes generally have because every DH line records its F1
  parents": an industry-practice generalisation with no support. (= 05-B11)
- 05-M11 :1325-1338 -- the chapter departs from the source (which attributes the zero eigenvalue of
  all four matrices to centring) without saying it departs. (= 05-B5)

AUDIT / REFCHECK FINDINGS: MUST THEY BE FIXED FOR APPROVAL
- 05-R1 yes (05-D1)   05-R2 yes (05-D2)   05-R3 no (05-M3)    05-R4 yes (05-D3)
- 05-R5 yes (05-D6)   05-R6 no (05-M1)    05-R7 no (05-M2)    05-R8 no (05-M3)
- 05-R9 no (05-M3)    05-R10 no (05-M4)   05-R11 no (05-M5)   05-R12 yes (05-D8)
- 05-R13 yes (05-D9)  05-R14 no (05-M6)   05-R15 no (05-M3)   05-R16 no here (05-M7; fix in 11b)
- 05-B1 yes (05-D3)   05-B2 no (05-M8)    05-B3 yes (05-D4)   05-B4 yes (05-D5)
- 05-B5 no (05-M11)   05-B6 yes (05-D7)   05-B7..B10 no (05-M9)  05-B11 no (05-M10)
"no" means not individually blocking; the M set as a whole is 11 items, so it must shrink below three
for approval even once every D is closed.

WHAT WAS VERIFIED
- F_hom - F_drift = 2 mean(x y) (Eq. 3, divisor N_SNP) -- by expanding p_t(1 - p_t) with p_t = p0 + d:
  1 - H_t/H_0 = d^2/(p0 q0) + 2 d (p0 - 1/2)/(p0 q0). Correct, and the cov()/mean distinction at
  :358-363 is correct.
- dF = (F_t - F_{t-1})/(1 - F_{t-1}), N_e = 1/(2 dF), N_e = 50 -> dF = 0.01, dF = 1 - e^slope -- correct
  (Falconer & Mackay Ch. 3-4).
- ID = 2F sum d p q (:266) -- matches Falconer & Mackay Ch. 14.
- Matrix-sign table vs transcribed gaps -- signs consistent (G_VR2 +0.054, G_VR1 +0.021, G_0.5 -0.170,
  G_i(p) -0.031).
- gain_per_dF (:614-621) -- recomputed by hand: G_LA 1563, A 1284, G_ROH 1282; dF_hom-only G_ROH 1685
  vs G_LA 1672. Correct.
- Rank theorem (05-D1) -- B 1_L = 2 1_N on the full factorial (range 2, 2), re-run.
- Managed arm (05-D2) -- re-run: R^2(F_drift) = 0.99243, R^2(F_hom) = 0.96037; rate ratio 2.26, stock
  ratio at cycle 12 = 2.02; increments 0.0122 -> 0.0221. Neutral fits R^2 >= 0.99935.
- A overshoot (05-D3) -- 0.0070/0.005 = 1.40, 0.0084/0.005 = 1.68.
- era-hom-two-levels (05-D6, 05-M1) -- re-run: balanced and truncation rows identical in every column.
- G_0.5 = 4f - 2J (05-D8) -- with Z = 2X - 1 and sum 2pq = m/2 at p = 0.5, G_0.5 = 8 Zh Zh'/m =
  4(f - 0.5 J). Correct as stated in the caption; therefore not f.
- 11b's rate fit (05-M7) -- 11b:241-242 uses -coef(f) and 1/(-2 slope); its "diagnostic fires on the
  unconstrained run" claim (:1090-1092 here) does exist at 11b:247.
- Book order -- book/_quarto.yml: 04c precedes 05; C14's premise no longer holds.
```
