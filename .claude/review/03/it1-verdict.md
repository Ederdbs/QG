# Verdict: 03-simulating-crosses, iteration 1

Scope: book/03-simulating-crosses.qmd (259 lines), R/00_data.R (simulate_lines,
molecular_coancestry), R/10_stage1.R (stage1_simulate, stage1_build). Consumed: it1-audit.md
(03-R*), it1-refs.md (03-B*), and the deferred Foundations findings C4, C8, C11, C14
(part-foundations.md, -response.md, -verdict.md). Paths are relative to the worktree.

VERDICT: REJECTED

DISQUALIFYING FAILURES
- 03-D1 [criteria 1, 5] book/03-simulating-crosses.qmd:43-48 (display and "the parameter `fst`
  *is* the expected between-pool divergence -- it is not a proxy for it"), :90 (axis
  `F[ST]~"between pools"`). This is C4's deferred half together with 03-R1. The Beta moments
  are right: mean p_k, variance F p_k(1 - p_k). But that variance is the divergence of EACH
  pool from the ancestral frequency, not divergence between the pools. Between the pools,
  Var(p_A - p_B) = 2F pq, and the F_ST statistic the book defines (GD_BS/GD_T,
  book/02-subdivided.qmd:218-220; book/90-notation.qmd:98) has expectation about F/(2 - F):
  0.081 at fst = 0.15, and 0.102 measured on book_cfg (90-notation chunk
  `notation-fst-parameter`). The settled book-wide symbol for the parameter is F_BN
  (90-notation.qmd:126-133). That appendix's "read it there as F_BN" mapping covers the
  symbol, but it cannot rescue the sentence. Read as F_BN, "is the expected between-pool
  divergence, not a proxy" is false. Read as F_ST, it contradicts the book's definition.
- 03-D2 [criteria 1, 5] book/03-simulating-crosses.qmd:99-101 ("the divergence is being paid
  for out of within-pool diversity, unit for unit"), :74 (caption: "@sec-heterosis-flat
  derives why the two terms must trade one for one"), :106-108. This is C14, unresolved.
  (a) In the book's own between-pool measure, GD_BS, within-pool loss and between-pool gain
  trade 2:1, not 1:1. 02:354-358 states it (GD_WS falls by Delta, GD_BS rises by Delta/2),
  and so does 05b:507-515: the shared term 2 pbar qbar loses F pq, and that equals the
  divergence gain. Within-pool GD loses 2F pq. On the chapter's own grid (fst 0.02 -> 0.40,
  m = 1500), within-pool GD falls by 0.133 and GD_BS rises by 0.0705. GD_T falls by 0.063,
  which is the 1:1 partner. "Unit for unit" holds only for f_within - f_between (Nei's
  minimum distance, +0.141), which the chapter never names. So the 1:1 trade that :101
  attributes to within-pool diversity is the trade that :105 (and 05b) attribute to the
  shared term. The two statements in the same section concern different quantities and
  cannot both be the "one for one" the caption sends to @sec-heterosis-flat.
  (b) :107: "@sec-subdivided is why GD_BS is nonetheless held rather than minimised". 02
  asserts this and gives the reason elsewhere: tbl-keystone, 02:629, defers it to
  @sec-heterosis. So the chapter credits 02 with an argument 02 does not make.
- 03-D3 [criteria 3, 4] book/03-simulating-crosses.qmd:148-151. "The realised trait
  correlations recover the target `R`" is contradicted by the chapter's own output: realised
  0.259 / -0.440 / 0.049 against target 0.3 / -0.3 / 0.1. r13 is off by 0.14, and r23 is half
  its target. Per 03-R2, Z has rank 48, the per-entry SD over effect draws is ~0.145, and the
  target is recovered only in expectation over draws. That is not what the sentence claims.
  The sentence after it ("would be a weighted sum of independent noise ... unrealistically
  easy") is an interpretation stated as fact with no support. Independent traits are not
  noise, and nothing in the book measures the effect of trait correlation on the
  diversity trade-off.
- 03-D4 [criteria 2, 3] book/03-simulating-crosses.qmd:217-225; R/10_stage1.R:51. This is
  03-R9, judged beyond the chapter as requested. The claim is "detects the marker coding and
  rescales, so both conventions give an identical result". The rule `max(X) > 1` silently
  reads a 0/1/2 matrix that has no dosage-2 call as 0/0.5/1. Reproduced: rbind(c(0,1,1),
  c(1,0,1)) in 0/1/2 coding returns diag(f) = 1 and f12 = 0.333, against the correct 0.667 /
  0.5. There is no error and no warning. Any NA makes `if (max(X) > 1)` fail with an error. So
  the claim is FALSE AS STATED as a universal. It holds only under an undeclared assumption:
  at least one dosage-2 call and no missing values. The input {0, 1} is inherently ambiguous,
  and no detection rule can resolve it. At realistic m the no-2 case is improbable, but the
  chapter states the invariance unconditionally. Its demonstration cannot fail either:
  `st1$X * 2` contains a 2 wherever st1$X contains a 1, and /2 undoes *2 exactly in floating
  point. So the TRUE printed at :223-224 is evidence of nothing beyond the case it was built
  for.
- 03-D5 [criterion 3] book/03-simulating-crosses.qmd:188-189. "the single most common error in
  applying these metrics" is a frequency claim with no data and no source. 03-B3 found none.
  (The rest of the sentence is correct, see VERIFIED.)
- 03-D6 [criterion 7] book/03-simulating-crosses.qmd:39-45. 03-B1: the model and its Beta
  parametrisation are attributed to Balding and Nichols with no reference, and
  book/references.bib has no entry for them. Per refcheck, the attribution of this exact
  parametrisation is UNVERIFIED, not false.

NON-DISQUALIFYING OBSERVATIONS
- 03-M1 book/03-simulating-crosses.qmd:8-16 -- C11, the 03 half. The opening starts on the
  stage-1 contract with no transition from Foundations: it does not say why simulation
  follows the response equation, and it does not acknowledge @sec-response or the
  `simulate_pools()` generator that 02b introduces (02b:24-33). A reader arriving from 02b's
  closing pointer meets two generators and is told nothing about how they relate.
- 03-M2 book/03-simulating-crosses.qmd:41-47 -- C8, the 03 half. p_k is the ancestral
  frequency here, the merged-pool frequency is pbar_k elsewhere, and 01:63 uses p_k for the
  population frequency. Also p_{A,k} here against p_{Ak} in 02b/90/05b. 90-notation:390
  documents both, so this is not a contradiction. It is idiosyncratic notation that the
  reader has to map.
- 03-M3 book/03-simulating-crosses.qmd:84, :100 -- 03-R5. `within_pool_f` includes the
  diagonal (self-coancestry 1), so it is a group coancestry, not the between-line within-pool
  coancestry the prose compares with `between_pool_f`. It is biased up by ~0.013. This bears
  on 03-D2, which is about which quantity trades with which.
- 03-M4 book/03-simulating-crosses.qmd:74, :99 -- 03-R6. "Does not move" and "flat": the
  realised column ranges 0.3630-0.3726 around the expectation 0.364. This is flat in
  expectation, with no statement of the sampling dispersion. The caption also describes a
  series (within-pool coancestry) that the plot does not draw. That is not a contradiction.
- 03-M5 book/03-simulating-crosses.qmd:235, :248-251 -- 03-R4. The random-subset draw is
  unseeded. The figure and the apparent_loss_pct output depend on the stream that
  stage1_simulate() leaves behind. No prose number depends on it.
- 03-M6 book/03-simulating-crosses.qmd:193-197 -- 03-R8. "All of the above is
  `stage1_simulate()`" is followed by the source of `stage1_build`, which shows none of the
  above. The claim is true (audit: the chapter's ctx is identical to stage1_simulate's), but
  the printed code does not show it.
- 03-M7 whole chapter -- 03-R3. Every identity the chapter states is printed, not asserted:
  only 0/2 genotypes, het_fraction = 1 - theta_AB, sum(G) = 0, f in [0, 1], coding
  invariance, and population GD above the subsets.

Seven non-disqualifying observations: on their own they would also reject.

WHAT WAS VERIFIED
- Beta(p(1-F)/F, q(1-F)/F) has mean p and variance F pq: algebra (a + b = (1 - F)/F), and the
  audit's 1e6 draws. Correct as a statement about each pool against the ancestor.
- Within-pool vs between-pool trade on the chapter grid: worktree pkgload, fst 0.02 and 0.40,
  m = 1500. GD_within 0.3436 -> 0.2102 (-0.133). GD_BS 0.0107 -> 0.0812 (+0.0705). GD_T
  0.3543 -> 0.2914 (-0.063). f_within - f_between +0.141. Het fraction 0.3651 -> 0.3726.
  Basis of 03-D2.
- Het fraction of A x B hybrids of 0/1 lines = 1 - f_ij exactly, and E = 2pq independent of F
  (05b:497-499). So :104 "exactly 1 - theta_AB" and "does not create heterosis" hold with the
  inbred parents declared at :50-51. (Heterosis is measured over the inbred mid-parent, so the
  population-cross d y^2 term of Falconer & Mackay does not apply.)
- stage1_build coding detection: reproduced the misread on a 2 x 3 0/1/2 matrix without 2s,
  and the NA error. Basis of 03-D4.
- Trait correlations: simulate_data(book_cfg) gives 0.259 / -0.440 / 0.049, identical to the
  frozen chapter output. Basis of 03-D3.
- :186-189 "would silently zero out": with p0 recomputed on the selected set, F_drift = 0 by
  construction, and so is F_hom = 1 - mean(pk qk / (p0 q0)) (R/01_metrics.R:224). So 03-R10's
  narrowing to F_drift is unnecessary; only the superlative fails (03-D5).
- 25 x 25 = 625, 71 x 71 = 5041, 0.40/0.02 = 20: correct (audit, refs).
- simulate_lines (R/00_data.R:38-53) matches :39-51: runif(0.05, 0.95) ancestral draw, BN
  Beta, 2 x Bernoulli.
