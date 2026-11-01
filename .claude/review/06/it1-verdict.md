# Verdict -- book/06-metric-catalogue.qmd -- iteration 1

VERDICT: REJECTED

Inputs consumed: it1-audit.md (06-R1..R16), it1-refs.md (06-B1..B7), part-foundations-2.md C6/C9,
part-foundations.md C15 (:117). Outputs read from book/_freeze/06-metric-catalogue/execute-results/html.json.

## Disposition of audit (R) and reference (B) items

| ID | Required for approval | Criterion | Note |
|---|---|---|---|
| 06-R1 | YES | 3, 7 | "near 3.6%" at full scale (:399) has no source in the repo; the chunk above prints 0.0412 (book scale), which the prose ignores. |
| 06-R2 | YES | 3, 5 | Closing claim (:414-416) contradicted by the chapter's own z table: truncation Ne_parents z (-11.4) is LESS extreme than GD (-17.9). |
| 06-R3 | YES | 1 | Ns read as a head count of unrelated individuals (:115-116). On molecular f, theta = mean(p^2+q^2) >= 0.5, so Ns <= 1 always; the chapter's own edge case prints Ns = 1 for 5 "unrelated" individuals. Lindgren's count reading needs coancestry relative to a base (unrelated = 0). |
| 06-R4 | YES | 5 | "collapses the parent base far more than it moves theta" (:166) holds in relative units only; on the z scale the chapter declares as its reporting standard (:405-406) it is reversed. |
| 06-R5 | YES | 3 | greedy_w1 == truncation (identical rows in every table); the "rank almost identically" claim (:40-41, :56) rests on a Spearman of 1 over 4 distinct points. |
| 06-R6 | YES | 3 | "only metric genuinely non-redundant with theta" (:184-185) -- F_drift separates truncation at z = 30.1 in the chapter's own table and was never in the redundancy analysis it defers to. |
| 06-R7 | YES | 3 | Timing (:98-104) is clock-quantised (reruns give ratio 7, Inf, 4); the printed ratio supports the claim at :106. |
| 06-R8 | no (-> 06-M3) | -- | Printed identities without assertions. |
| 06-R9 | YES | 1 | "n if spread evenly" (:234): after double-centring the rank is <= n-1. |
| 06-R10 | YES | 1 | "leading eigenvalue is just n theta" (:241): it is >= n theta (Rayleigh quotient at 1/sqrt(n)), only approximately equal. |
| 06-R11 | YES | 2 | A-NE formula (:210) with d = 1 - f gives d_ii = 1 - f_ii > 0 for heterozygous hybrids; the departure from the cited definition (self-distance 0) is undeclared. |
| 06-R12 | no | -- | Seed placement; robustness, not content. |
| 06-R13 | no | -- | B_full = 60; the qualitative claims survive at B_full = 1000. |
| 06-R14 | YES | 3 | Callout "erodes one pool while global theta looks fine" (:278): the only eroded case shown has GD z = -17.9; the claim is not demonstrated. |
| 06-R15 | YES | 1 | Bias equation (:329-330) written for a set S; it holds for E[theta_S] over random S. For a given S, the f_d, f_o of Eq. (1) are the set's own, and the inequality can fail (greedy_div). |
| 06-R16 | no | -- | Illustrative arithmetic, correct. |
| 06-B1 | YES | 7 | toro2020 DOI resolves to a different paper. |
| 06-B2 | YES | 7 | lopezcortegano2019 managed five subpopulations, not "two heterotic-like pools"; the lambda-weighted forms are López-Cortegano's, not Caballero & Rodríguez-Ramilo's. |
| 06-B3 | YES | 7 | E-NE / A-NE credited to Core Hunter 3; CH3 credits Odong et al. 2013. |
| 06-B4 | no (-> 06-M4) | -- | Omitted qualifier (lambda -> infinity case); abstract supports the sentence as written. |
| 06-B5 | no | -- | Unverified (secondary sources consistent); flagged as unsupported, not false. |
| 06-B6 | no (-> 06-M4) | -- | Inverse Simpson naming uncited; definitional. |
| 06-B7 | no (-> 06-M4) | -- | Participation ratio naming uncited; definitional. |

Part-level: C6 (owner 05b) and C9 (owner 00) require no change in 06. C15 (part-foundations.md:117):
06:264 already attributes the partition to @sec-subdivided, consistent with "02 derives, 06 reports";
no change in 06. But see 06-D1: 05b:1754-1756 repeats the 06 lambda claim, so fixing D1 forces 05b.

## DISQUALIFYING FAILURES

(All R/B items marked YES above, plus:)

- 06-D1 [criterion 1] book/06-metric-catalogue.qmd:313-319, "lambda need not stay a matter of taste" --
  the ratio of the divergence term sum_k d_k y_k^2/2 to the shared term sum_k d_k 2 pbar_k(1 - pbar_k) is
  identified as "what lambda is trying to express". It is not. The shared term 2 pbar qbar is H_T of the
  pooled pools (= H_S + D_G), not H_S, and per locus the hybrid heterozygosity is
  pA qB + qA pB = H_S + 2 D_G = 2 (D_G + H_S/2) (verified numerically to 2e-16). Under the
  López-Cortegano form D_G + lambda H_S, uniform d therefore implies a fixed lambda = 1/2, and a
  d-weighted version is a ratio of d-weighted H_S to d-weighted D_G sums -- not the ratio the text
  names, which is a property of current frequencies (0.20 in the check) rather than a weight. The same
  misidentification is carried into 05b:1754-1756 ("observes that the ratio of the two heterosis terms is
  what lambda is trying to express").
- 06-D2 [criteria 4, 2] book/06-metric-catalogue.qmd:273-275 -- "GD_BS rises under truncation: selection
  concentrates on the most complementary line pairs, which pushes the pools further apart". The
  rise (0.0350 -> 0.0524) is measured; the mechanism is asserted, not measured, and is inconsistent with
  the undeclared trait model: the simulated index is additive in the hybrid genotype
  (R/00_data.R:129-130, traits = scale(Z %*% B); no dominance, no SCA), so no pair is "complementary" beyond
  the sum of its parents' values. The chapter's own Ne_lines_pool output (truncation: 4.49 lines in pool A
  vs 18.6 random) points to concentration on few lines per pool, which inflates between-pool frequency
  differences without any complementarity. Interpretation presented as a reading of the table, and the
  additive-model assumption under which it should be read is never stated.

## NON-DISQUALIFYING OBSERVATIONS

- 06-M1 book/06-metric-catalogue.qmd:387-389 -- "Pure truncation ... defines the maximum attainable alpha":
  the maximum alpha over all subsets is reached by a minimum-diversity selection, not by truncation.
  Truncation gives the alpha of the unconstrained gain optimum, which is the quantity the constraint-activity
  argument actually needs; the label misnames it.
- 06-M2 book/06-metric-catalogue.qmd:351-352 -- "not comparable across sample sizes on the Ns scale" is
  unexplained; the reader cannot tell what comparison fails or why.
- 06-M3 (from R8) book/06-metric-catalogue.qmd:79-86, :270, :344-347 -- identities and the bias check are
  printed, not asserted; "equality to machine precision" and "the formula is exact; the residual is Monte
  Carlo error" have no stated tolerance or MC standard error.
- 06-M4 (from B4, B6, B7) book/06-metric-catalogue.qmd:156-158, :187-190, :229-231 -- uncited naming of the
  inverse Simpson index and participation ratio; López-Cortegano's result reported without its own
  qualifier.

Four non-disqualifying failures: by accumulation alone the text would also be rejected.

## WHAT WAS VERIFIED

- Eq. (1) theta_S = f_d/n + (n-1)/n f_o -- algebra; correct.
- theta_S = mean_k(pbar^2 + qbar^2), GD = mean 2 pbar qbar = Nei 1973 H -- algebra with
  f = tcrossprod(cbind(X, 1-X))/m; correct; frozen output difference 0.
- f_d > f_o unless clones -- Cauchy-Schwarz on the Gram matrix (f_ij <= sqrt(f_ii f_jj) <= (f_ii+f_jj)/2);
  correct.
- E[theta_S] - theta_N = (1/n - 1/N)(f_d - f_o) -- algebra; correct in expectation only (R15). Frozen
  predicted 0.002222 vs observed 0.002277.
- Off-diagonal mean of a random subset unbiased for the population off-diagonal mean -- correct
  (sampling of pairs without replacement).
- Ns <= 1 on molecular f -- per-locus p^2 + q^2 >= 1/2; frozen edge case prints Ns = 1 for 5 "unrelated"
  individuals (R3 confirmed).
- Heterosis split: hybrid heterozygosity = 2 pbar qbar + y^2/2 = H_S + 2 D_G, GD_BS = y^2/2 with equal
  pool weights -- numerical check in R, max error 2e-16. The "divergence half" sentence at :249-251 is
  correct; the lambda identification at :313-319 is not (D1).
- Simulated trait model -- R/00_data.R:125-131: additive marker regression on hybrid genotypes; basis of D2.
- greedy_w1 == truncation, z values, Ne_parents/alpha values -- read from the frozen output; consistent
  with R2, R4, R5.
- Part-level C6, C9, C15 -- read; no 06 change required beyond D1's knock-on to 05b.
