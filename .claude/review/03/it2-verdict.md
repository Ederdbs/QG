# Verdict: 03-simulating-crosses, iteration 2

Scope: the diff from main of book/03-simulating-crosses.qmd, book/90-notation.qmd,
book/references.bib, R/10_stage1.R, R/13_alphasimr_bridge.R and tests/testthat/test-pipeline.R.
Consumed: it1-verdict.md, it1-response.md, it1-audit.md, it1-refs.md and it1-editor.md.
Paths are relative to the worktree. Numbers come from pkgload::load_all on the worktree, with
book_cfg = sim_config modified to 25 + 25 lines, m = 2000, seed = 1.

VERDICT: REJECTED

PREVIOUS IDS
- 03-D1 -- CLOSED -- :57-71. The parameter is now F_BN, defined as each pool's divergence
  from p*. The text gives Var(p_A - p_B) = 2 F_BN p*q*, and states that the F_ST of
  @eq-f-stats is about F_BN/(2 - F_BN) for unbounded pools (0.081 at 0.15). The axis reads
  F[BN], and 90-notation:129 no longer lists this chapter.
- 03-D2 -- CLOSED -- (a) "Unit for unit" is gone. The trade is now stated in GD_WS, GD_BS and
  GD_T, with expectations 1 and 2, which match the drift argument of 02:354-358 (verified,
  see below). (b) The pointer now goes to @tbl-keystone, which states the claim and defers it
  to @sec-heterosis (02:646). The replacement text carries a new defect, 03-D8.
- 03-D3 -- CLOSED -- :218-238. The realised correlations sit beside the target, and the
  maximum departure is given inline. rank(Z) = 48 is asserted. The text states that it was
  not measured how close the realised correlations come to the target on average over draws.
  The "independent noise" sentence is gone.
- 03-D4 -- CLOSED -- :321-369 and R/10_stage1.R:55-70. The detection assumption (at least one
  dosage-2 call, NA ignored), the {0,1} ambiguity, the warning and the `coding` argument are
  all stated. The code does exactly what the prose says (reproduced below). The invariance
  demonstration is now restricted to a matrix that is asserted to contain 2s.
- 03-D5 -- CLOSED -- The superlative is deleted (:288-290).
- 03-D6 -- CLOSED -- balding1995 is in the bib and cited at :54. The entry (Genetica
  96:3-12, 1995, doi 10.1007/BF01441146) is consistent with it1-refs. Whether this exact
  parametrisation is the paper's own remains, as refcheck left it, unconfirmed but not
  contradicted.
- 03-M1 -- CLOSED -- A transition from Foundations and the relation between the two
  generators are now present (:8-17). One sentence of that new text is false: 03-D7.
- 03-M2 -- CLOSED -- p*_k for the ancestral frequency, p_Ak and p_Bk for the pools. The
  90-notation row has been added.
- 03-M3 -- CLOSED -- within_pool_f is declared to be the group coancestry f~, self included
  (:110, :132, :158-160).
- 03-M4 -- CLOSED -- The caption describes only what is plotted, and the dashed expectation
  has been added. The min/max and the "replicate spread not measured" statement are at
  :153-158.
- 03-M5 -- CLOSED -- set.seed(cfg$seed + 3) is called before the subset draw (:384).
- 03-M6 -- CLOSED -- :294-296 reworded.
- 03-M7 -- CLOSED -- stopifnot() calls now cover: the 0/2 lines, the het fraction =
  GD_T + GD_BS, rank(Z), sum(G), range(f), f = tcrossprod(cbind(X, 1 - X))/m, het =
  1 - fL[a,b], the dosage-2 precondition, the coding-ambiguous outcome, and population GD >
  the subset mean.

DISQUALIFYING FAILURES
- 03-D7 [criteria 1, 5] book/03-simulating-crosses.qmd:16-17, "The two generators draw from
  different random streams, so they do not produce the same dataset." This is false for the
  call the sentence refers to. simulate_pools() (R/09_reference.R:27-41) and simulate_lines()
  (R/00_data.R:38-52) consume R's stream in the same order: set.seed(seed),
  runif(m, 0.05, 0.95), two rbeta(m, .) draws, then rbinom for pool A and then pool B. The
  pmin/pmax clamp of simulate_pools changes nothing at fst = 0.15. With the arguments of
  02b:36 (25 + 25 lines, m = book_cfg$m = 2000, fst = 0.15, seed = 1), simulate_pools()$GL is
  identical to simulate_lines(book_cfg) / 2 (identical() TRUE). Its $X is equal to
  simulate_data(book_cfg)$X (all.equal TRUE). The lines, the hybrids and the marker matrix of
  @sec-response are therefore the same dataset as this chapter's. Only the trait model and
  the index differ, which is the half of the sentence before it that is correct. The new
  opening tells the reader the opposite of what the code does, about exactly the relation it
  was written to explain (C11/C12).
- 03-D8 [criteria 1, 2] book/03-simulating-crosses.qmd:170-173, "the shared term
  2 p_bar(1 - p_bar), which is GD_T here, loses F_BN p*(1 - p*) and the divergence term,
  which is GD_BS, gains the same amount, both in expectation." @sec-heterosis-flat derives
  F p*q* treating the pool frequencies as the Balding-Nichols draws themselves, that is,
  pools of unbounded size. Here GD_T and GD_BS are computed from the sample frequencies of
  n = 25 lines per pool. With p_hat_A ~ p_A + binomial sampling:
    E[GD_BS] = F pq + (1 - F) pq / n,
    E[GD_T] = 2pq - F pq - (1 - F) pq / n,
  so over the grid each moves by F pq (1 - 1/n), not F pq.
  Measured over 200 seeds on the chapter's grid (m = 1500, Delta F_BN = 0.38):
    mean change in GD_T = -0.0668 (SE 0.0003),
    mean change in GD_BS = +0.0665 (SE 0.0002).
  Predictions:
    unbounded-pool formula of :172 = 0.0694, about 8-13 SE away from the measured means;
    finite-n formula 0.38 x 0.1825 x 24/25 = 0.0666, matching them.
  The chapter declares "two pools of unbounded size" for the F_ST expectation at :68. It then
  uses the same assumption silently at :172 for quantities it has just computed on 25-line
  pools. The ratios 1 and 2 at :163-164 are not affected (the (1 - 1/n) factor cancels). The
  absolute expectation stated at :172 is.

NON-DISQUALIFYING OBSERVATIONS
- 03-M8 book/03-simulating-crosses.qmd:153-164. :156-157 states that the replicate spread was
  not measured, but that statement is attached to the heterozygous fraction. The two trade
  ratios (1.12 and 1.89, against 1 and 2) are reported in the same paragraph with no word
  that they are single-draw values whose departure is uninterpreted. Over 200 replicate grids
  the ratios have mean 1.002 / 2.008 and SD 0.104 / 0.102. Each observed value falls in a
  13.5 % tail, so the departure is ordinary sampling. The prose does not over-interpret it,
  so this is not a criterion-4 failure. A reader is still left to guess whether 12 % is a
  discrepancy.

WHAT WAS VERIFIED
- Chapter grid (seed 1, m = 1500): Delta GD_WS -0.1334, Delta GD_BS +0.0705, Delta GD_T
  -0.0629, ratios 1.1201 and 1.8928, het fraction 0.3630-0.3726. These reproduce the
  response's 1.12/1.89.
- Ratio expectations 1 and 2. Algebra with finite-n sample frequencies: E[GD_WS] =
  2pq(1-F)(1-1/n) and E[GD_BS] = F pq + (1-F)pq/n. dE/dF ratios are exactly 2 and 1 for any
  n. 200 replicate grids: 1.002 +/- 0.104 and 2.008 +/- 0.102. Consistent with the
  02:354-358 drift argument (E[f_AB] = p^2 + q^2 does not depend on F under BN).
- Het fraction = GD_T + GD_BS with equal pool sizes: 1 + f~ - 2 f_bar = 1 - f_AB, by
  algebra. E[het] = 2pq exactly at finite n, so the dashed line 2 E[p*q*] = 0.365 is the
  exact expectation.
- F_BN/(2 - F_BN) at 0.15 = 0.0811, a ratio of expectations for unbounded pools. Correct as
  qualified at :68.
- GD_WS = 1 - f~ = GD_WI + GD_BI (02 definitions, @eq-gd-partition). GD_BS = (p_A - p_B)^2/2
  per locus = 05b's divergence term y^2/2. 2 p_bar q_bar = GD_T.
- coding-ambiguous: auto gives f11 = f22 = 1, f12 = 0.333, with the warning text as quoted at
  R/10_stage1.R:60-63. coding = "012" and molecular_coancestry(X/2) both give 0.667 / 0.667 /
  0.5. By hand: f11 = (0 + .25 + .25 + 1 + .25 + .25)/3 = 2/3, f12 = (.25 + .5 + .5 + .25)/3 =
  0.5. A {0, NA, 1} matrix warns, so NA is ignored in detection as stated at :322-323.
  test-pipeline.R covers declared, auto-warn, bad coding, the range error and the NA cases.
- R/13_alphasimr_bridge.R: coding = "012" for pullSegSiteGeno dosages. Correct (AlphaSimR
  dosages are 0/1/2).
- simulate_pools(25, 25, 2000, 0.15, seed = 1)$GL == simulate_lines(book_cfg)/2 element for
  element, and its X equals simulate_data(book_cfg)$X. Basis of 03-D7.
- @eq-f-stats, @eq-gd-partition and @tbl-keystone exist in 02 and say what :68, :160 and
  :174-176 attribute to them.
