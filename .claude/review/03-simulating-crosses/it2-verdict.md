# Verdict: book/03-simulating-crosses.qmd (iteration 2)

VERDICT: REJECTED

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05, branch review-01-05. Lines are of the 645-line qmd as it stands. Read in full: the chapter, it1-verdict.md, it1-response.md (both parts), it1-refs.md and it1-continuity.md (titles and the C2 finding), the changed passages of 01 (370-380), 05b (about a dozen places) and 02b (the new chunk), and the owed passages 90:18-32, 90:511-515, 90:585-592, 04-population-sizing:15, 04e:33-37 and 08b:9-13. No disqualifying criterion fails now. The rejection is by accumulation: three non-disqualifying failures are open (03-M6, 03-M7, 03-M15), and the rule rejects at three. All three are small and local.

## PREVIOUS IDS

- 03-D1 -- CLOSED -- 03:320-333 says the data carry no dominance. It says the heterozygous fraction is the F1 heterosis per locus only at d_k = 1 (@eq-het-value, checked: H_i = sum d_k 1{x_ik = 0.5}). It says the GD_T + GD_BS identification needs inbred parents, the complete factorial and equal pool weights, which are the GD_BS row of @tbl-keystone (02:1039, matched). "nonetheless" is gone, and preservation is not drawn from the flat line (consistent with 02:1085-1097 and 00:72-74). Nothing in the chapter is read off the flat line outside those conditions.
- 03-D2 -- CLOSED -- grep finds no "candidate pool" or "whole pool" in 03. The row label, headings, captions and alt text say candidate set. 90:20/30 and 04:15 are owed and named (see Owed rows).
- 03-D3 -- CLOSED -- grid and replicate chunks use `book_cfg$m`. I re-ran the chapter (knit, 3.2 s, every `stopifnot` passes). The 0.15 row prints 0.3617 / GD_BS 0.0336 / GD_T 0.3281. 01's tbl-diagonal re-run prints `heterozygous_fraction` 0.3617 and `one_minus_fL_AB` 0.3617. A new assertion ties the 0.15 row to the chapter's own `L`. No "1500" or "book scale" remains in 03.
- 03-D4 -- CLOSED -- the subsection "What the generator assumes" (03:128-158) is checked against `simulate_lines()`, `simulate_data()` and the R/00_data.R code. See ruling 1.
- 03-D5 -- CLOSED -- the per-hybrid identity is 1 - f^L_ab (asserted, deviation 5.6e-17). The factorial mean is 1 - \bar f^L_AB. The three names of the quantity are reconciled once (03:300-303; 05b:351-353 and 90:205/252 agree), and the code comment now reads `1 - mean f^L_AB`.
- 03-D6 -- CLOSED -- 03:463-470 carries the sample-frequency centring condition, gives sum(G) = -4.18e-11 (relative 1.5e-15, not exactly 0), points to @eq-g-sum-zero, and uses [@vanraden2008] only for the matrix of @eq-vanraden-g. I confirmed `vanraden_G()` centres on `colMeans(M)/2` (R/00_data.R:97-101).
- 03-D7 -- CLOSED for 03, 01 and 05b; the 90 share is owed and named. See ruling 3. 03:93-97 and 03:490-499 state that p*_k is a parameter of the draw, never observed, and is neither p_Ak, p_Bk nor `ctx$p0`. `ctx$p0` is `colMeans(X)` of the hybrids. The assertion `rel_dev(ctx$p0, (colMeans(L[A,]) + colMeans(L[B,]))/4)` exists, and ran at 1.1e-16.
- 03-M1 -- CLOSED (residue in NOT VERIFIED) -- 03:72-78 takes only the model's name and the one-parameter idea from balding1995, and calls the Beta densities and the reading of F_BN the book's own specification. The mean and variance carry their derivation.
- 03-M2 -- CLOSED -- "stores three objects" and each is explained.
- 03-M3 -- CLOSED -- element-wise comparison with `simulate_data(book_cfg)` is asserted (03:437-445) and ran.
- 03-M4 -- CLOSED -- tolerances are relative at 1e-12. sum(G) prints as -4.18e-11. N, m and n_lines print as integers (625, 2000, 50).
- 03-M5 -- CLOSED -- `num()` keeps trailing zeros ("0.3617 and 0.3663") and uses a true minus.
- 03-M6 -- OPEN -- the "maximises on known values" half is now correct; the step to "so a gain in ctx$index bounds ..." is not. See 03-M6 below.
- 03-M7 -- OPEN -- the assertion now reads book_cfg and 02b has its own; the comment claims an assertion 02b does not make. See 03-M7 below.
- 03-M8 -- CLOSED -- the pointer to @sec-heterosis-flat is present (seed 5, m = `book_cfg$m`, matches 05b's caption). The redundancy is declared and the numbers are stated to be a different draw.
- 03-M9 -- CLOSED -- pointers to @sec-mating, @sec-joint, @sec-alphasimr, @sec-genomic-prediction, @sec-heterosis-gca-sca and @sec-case-study are in place, and every target label exists.
- 03-M10 -- CLOSED -- Monte Carlo s.e. 3.8e-5 and gap/s.e. 59 are in tbl-gd-baseline. Apparent loss 0.681 % against 06's 0.69 % differs by about one s.e. of the loss, consistent with "the draw of the subsets".
- 03-M11 -- CLOSED -- the names R, B, L, n_A, n_B are declared local to the chapter.
- 03-M12 -- CLOSED -- f as identity in state, and the weakness of `min(f) >= 0`, are stated.
- 03-M13 -- CLOSED -- 200 seeds at both ends of the grid, mean and s.d. of the heterozygous fraction, paired change with s.e. See WHAT WAS VERIFIED.
- 03-M14 -- CLOSED -- captions and alt text are built by `sprintf` from the objects. Typed constants left (0.05, 0.95 and 0.9^2/12 mirroring the generator; 71 as a documented production constant) are acceptable.

## Rulings

1. "What the generator assumes" (03:128-158). Every assumption is true of the code.
   - `simulate_lines()` draws p* ~ U(0.05, 0.95), then pA and pB by independent Beta draws, then 2 x Bernoulli per line and locus, with no map, no recombination and no pedigree. Lines are at fixation (0 or 2).
   - `simulate_data()` forms the complete factorial with `expand.grid`, uses all m markers as effects, and builds traits from the known B. `n_A = n_B = 25` in `book_cfg`.
   - The pointers are correct. 04c:1993-2002 lists exactly the relaxations 03 names (linkage and map, directional dominance, outbred founders, multi-generation). @sec-hp-cycle (00:77-87) treats the DH and selfing routes. 04e and 04g choose the crosses. 05b covers dominance. 08b covers prediction error.
   - "Equal pool sizes" has no chapter that relaxes it; the sentence points to @sec-mating and @sec-joint only for the factorial, which is correct.
   - One overstatement remains: "hold ... and not beyond them" (03-M15).
2. The conditions at 03:296-333 (D1): no remaining reading off the flat line without the conditions. "creates no expected heterosis" is limited to those conditions. "Outside them this chapter says nothing about heterosis" is accurate.
3. p*_k versus `ctx$p0`. 03 is correct and asserted. 01:374-378 now uses p*_k and says it is not the frozen base p_{0,k}. 01:420-446 keeps p_{0,k} for the base. All 05b edits are consistent (see WHAT WAS VERIFIED).
   - The 90 Terms entry ("mean p ... ancestral frequency p") is still plain p. It contradicts 90:513 (p*_k), not 03. I accept it as owed to 90, because 03 is true today without it and is the symbol 90:513 already uses.
4. The sum(G) wording is correct as written and supports the stated condition. The balding1995 attribution is limited to name and idea. Both remain UNVERIFIED in the primary (full text unread) and are non-decisive.
5. The new assertions in 03 and 02b ran. 02b's: `identical(2 * sim$GL, simulate_lines(modifyList(book_cfg, list(fst = cfg$fst, seed = cfg$seed))))`.

## DISQUALIFYING FAILURES

None.

## NON-DISQUALIFYING OBSERVATIONS

- 03-M6 (reopened, medium) 03:406-411 -- callout "What this simulation deliberately does not model". It says no selection on estimated values can have a higher mean true index than "the optimum computed on the known values", "so a gain in ctx$index bounds the gain in true additive value". The first clause is true by maximality. The "so" is not. The book's reported gains come from greedy, DE and local search, which at book scale are not certified optima (`sel_exact()` does not converge there; the valid bound is `ocs_bound()`). A feasible point is not a bound: an estimate-based selection could exceed a heuristic's index on known values. The sentence conflates the optimum's gain with "a gain in ctx$index". 11b:102 and 12:170 repeat "optimistic ceiling" on this footing, but they are not re-judged here.
- 03-M7 (reopened, low) 03:114-115 and 03:29-32 -- the code comment says @sec-response's chunk "asserts that it uses book_cfg's fst and seed". It does not. 02b's new assertion compares its lines with `simulate_lines()` at 02b's own `cfg$fst` and `cfg$seed` (hard-coded 0.15 and 1, 02b:8). No chunk in either chapter asserts `cfg$fst == book_cfg$fst` and `cfg$seed == book_cfg$seed`. 03's own assertion calls `simulate_pools()` with book_cfg's values, so it does not couple the two. The prose "the arguments of @sec-response (... book_cfg values)" is true today by coincidence of values. This is the unmet part of it1-M7.
- 03-M15 (new, low) 03:130-134 -- "The identities ... hold for objects generated under the following assumptions and not beyond them." The "not beyond" is false for the chapter's own exact identities. The per-hybrid heterozygous fraction = 1 - f^L_ab holds for any inbred parents. `f == tcrossprod(cbind(X, 1 - X))/m` holds for any 0/0.5/1 matrix. sum(G) = 0 holds for any sample-centred panel. Independence across loci enters only the dispersion of the replicates, not the expectations (linear in loci). The sentence states a necessity the chapter does not show and its own derivations contradict.
- Info (not counted): 03:275-279, "a single draw per point scatters by about 0.006". That is the larger of the two replicate s.d. at the grid ends (0.0033 and 0.0059). Across the six points of one seed the figure's scatter is smaller, because p* is shared. I measured the within-seed s.d. across the six points as 0.0030 (mean over 200 seeds) and the mean within-seed range as 0.0081. The observed range 0.0046 is of that order, and the conclusion (the figure alone cannot separate flat from a small trend) stands.
- Info: R12 (realised trait-correlation departure over draws) is stated as not measured, which is an honest limit (criterion 6 met).

## Owed rows

| Row | Names its chapter? | 03 true today without it? |
|---|---|---|
| 90 Terms entry, plain p for the ancestral frequency (90:587-590) | yes, 90 (it1-response, THREAD) | yes. 90:513 already uses p*_k, which is 03's symbol. |
| 90:20 "candidate hybrids in the pool", 90:30 "candidate-pool allele frequency" | yes, 90 | yes. 03 says candidate set and `ctx$p0` is described correctly. |
| 04-population-sizing:15 "The previous chapters took the candidate pool as given" | yes, 04 | yes. 03:43-46 says it builds the candidate set; the contradiction is 04's. |
| 04e:35-37 says 03 "derived populations from crosses already chosen" | yes, 04e | yes. 03 derives none. |
| 08b:9-13 quotes "an optimistic ceiling" as 03's words | yes, 08b | yes. 03 no longer says that and 08b misquotes it; the misquote is 08b's. See 03-M6 for the related ceiling claim. |

None of these is decisive for 03.

## WHAT WAS VERIFIED

- Chapter knit in scratch, `knitr::knit` against the worktree (/private/tmp/claude-501/scr/run3.R, 3.2 s). Every `stopifnot` passes, including the grid-row assertion, the `identical` checks against `simulate_pools()`, the `ctx` equality, the p0 identity (1.1e-16) and `nrow(R) == n_traits`.
- Printed numbers equal the response: grid row 0.15 = 0.3617 / 0.0336 / 0.3281 / GD_WS 0.2945; heterozygous range 0.3617-0.3663; expectation 0.3650; dWS -0.1323, dBS 0.0674, dT -0.0649; ratios 1.0387 and 1.9627, printed as 1.04 and 1.96.
- Replicate numbers (200 seeds): het mean 0.3651 (s.d. 0.0033) at F_BN 0.02, 0.3651 (0.0059) at 0.40; paired change 2.2e-6 (s.e. 4.0e-4); ratios mean 1.005 and 2.003, s.d. 0.086 both. This draw is 0.4 and 0.5 s.d. from them, so "within ordinary sampling variation" holds.
- My own 200-seed x 6-point run (scratch sc.R, m = 2000, n = 25 + 25): mean het by F_BN 0.3651, 0.3651, 0.3650, 0.3652, 0.3649, 0.3651; s.d. by F_BN 0.0033, 0.0034, 0.0038, 0.0041, 0.0049, 0.0059; per-seed slope on F_BN mean -1.2e-4, s.e. 1.1e-3. This supports the flat claim, within the replicate count. The s.d. rises with F_BN, so the 0.006 is the larger end.
- Algebra by hand: E[GD_BS] = F p*q* + (1-F) p*q*/n; the loss of GD_T and the gain of GD_BS are both F p*q*(1-1/n); expected change 0.38 x 0.365/2 x 0.96 = 0.0666 agrees with the observed 0.0674 and 0.0649 and with the replicates' ratios. F_ST ~ F/(2-F) = 0.0811 at 0.15.
- 05b equations after p -> p*: E[pA + pB - 2 pA pB] = 2p*q*; Var(p-bar) = F p*q*/2; E[2 p-bar q-bar] = 2p*q*(1 - F/2); E[y^2/2] = F p*q*; E[pA qA] = p*q*(1-F); E[(1-2pB)^2] = (1-2p*)^2 + 4F p*q*; the GCA F^2 coefficient is -4 d^2 p*^2 q*^2; the peak F* = (8c-1)/(8c) with c = p*q*, rises from 0 iff p*q* > 1/8 (interval 1/2(1 -/+ 1/sqrt2)); the (p*q*)^2-weighted vertex; (p*q*)^2 F* = p*q*(8p*q* - 1)/8; F_eff = F + (1-F)/n and the axis conversion (F-bar* - 1/n)/(1 - 1/n). All hold. q* = 1 - p* is declared once at 05b:620. The hybrid-set frequencies p_k q_k at 05b:480 and 501 were correctly left alone. grep shows no ancestral p left plain in 05b.
- 01 and 02b knit in scratch (run1.R, run2b.R), each passing. 01's tbl-diagonal prints 0.3617.
- `simulate_pools()` clamps pool frequencies to [1e-6, 1 - 1e-6] (R/09_reference.R:32-33); `simulate_lines()` does not (R/00_data.R:37-46). `ctx$p0 <- colMeans(X)` (R/00_data.R:164). `vanraden_G` centres on `colMeans(M)/2`.
- Cleanup: the scratch knit created book/figure/ (two untracked PNGs); deleted. No book/Rplots.pdf exists. No tracked file was edited.

## NOT VERIFIED

- balding1995: name and one-parameter idea only. Full text was not reached; it1-refs says the abstract does not support the Beta form, which 03 no longer attributes to the paper. Non-decisive.
- vanraden2008: the matrix of @eq-vanraden-g is taken by name. I checked the code and the algebra, not the paper. Non-decisive.
- `quarto render` of the chapter in HTML or Typst, and whether `docs/` and `_freeze/` are consistent after the batch render. Only knitr runs in scratch.
- The prose of 90, 04, 04e and 08b beyond the quoted lines; they are owed to their own reviews.
