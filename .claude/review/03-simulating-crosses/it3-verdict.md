# Verdict: book/03-simulating-crosses.qmd (iteration 3)

VERDICT: APPROVED

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05, branch review-01-05. Scope as instructed: 03-M6, 03-M7, 03-M15; what the iteration-2 fixes changed (callout 03:406-420, opening of "What the generator assumes" 03:128-139, the 03/02b statements on the cfg/book_cfg tie, the new `stopifnot` at 02b:64); and 05b-M28/M29/M30. Read in full: it2-verdict.md, it2-response.md, the changed passages of 03 (20-60, 105-175, 395-430), 02b (55-80), the 05b passages named below, and 10b (the @sec-bound section and the certificate paragraph). No disqualifying criterion fails. No non-disqualifying item is open.

## PREVIOUS IDS

- 03-M6 -- CLOSED -- 03:406-420 now claims only what maximality gives: no selection on estimates has a higher mean true index than the optimum on the known values, because the optimum maximises that index over every feasible selection (the diversity constraint does not depend on the traits, so a selection on estimates is feasible for the same problem). It then says the book's gains come from greedy, DE and local search, which are not certified optima at book scale, that a feasible selection is not a bound, and that a gain in `ctx$index` therefore does not bound the gain of a selection on estimates. The old "so a gain in ctx$index bounds ..." is gone. No new overstatement found. The pointer is right: @sec-bound exists (10b:635); 10b:1187-1189 says `ocs_bound()` converges at book scale and does not at N = 10,000; 10b:949 says the exact loop does not converge at book scale; `ocs_bound()` carries `converged` and warns otherwise (R/12_search.R:343-356). "gives a valid upper bound" is scoped to book scale by the sentence it sits in ("there"), which 10b supports.
- 03-M7 -- CLOSED -- 02b:63-64 now asserts `cfg$fst == book_cfg$fst, cfg$seed == book_cfg$seed` before `simulate_pools()`; 02b:70-71 ties its lines to `simulate_lines()` at those values. I re-ran 02b (knit, 3.1 s): every `stopifnot` passes. 03:29-32 and the `sim_02b` comment (03:114-116) say 02b's chunk asserts that its fst and seed equal book_cfg's; that is now true. The coupling is asserted on the 02b side, which is where it can fail.
- 03-M15 -- CLOSED -- the opening of "What the generator assumes" (03:128-139) says the reported numbers are conditional on the assumptions and that the exact identities do not need them all; "and not beyond them" is gone. Each identity named holds as claimed (WHAT WAS VERIFIED). "Independence across loci enters the dispersion of the replicates, not the expectations, which are sums over loci" holds: expectations are linear in loci. The sentence does not say that the other assumptions (unrelated lines, equal weights) are unneeded for the expectations, and it should not; it does not.

## 05b rulings (previous step, not yet re-checked)

- 05b-M28 -- CLOSED. 05b:1967 (tbl-cap of tbl-het-step7-spread): the mechanism stated is the true one. Run: `pf(1.654^2, 999, 999, lower.tail = FALSE)` = 4.751259e-55 (representable, "about 5e-55" holds); `pf(1.654^2, 999, 999) == 1` is TRUE; `var.test` on a variance-ratio 1.654^2 sample returns p = 0 exactly; `format.pval(0, digits = 2, eps = .Machine$double.eps)` prints `<2e-16` (the caption's `< 2e-16` differs by a space only). The code comment at 05b:1998 now reads "a p below machine epsilon prints as the floor", which is correct (the tiny p is not an underflow, and the floor is what prints).
- 05b-M29 -- CLOSED. 05b:708 fig-alt: "falls by nearly the same amount (the two changes differ by a few per cent in this draw), and their total stays nearly flat". I recomputed the sweep (seed 5, book_cfg, six fst): divergence gain 0.0739, shared loss 0.0756, differing by 2.24 %; totals 0.3620-0.3664. "A few per cent" holds and agrees with the body text at 05b:652-661.
- 05b-M30 -- CLOSED. 05b:595 and 1597 name the premise (marker panel = dominance loci), 1068 names it (fully inbred candidates, "the first premise"), 1471 names it (parents fully inbred), 178 names it (dominance within loci, additivity between), and each points to @sec-heterosis-premises (05b:73). The positional wording at 1068 ("the first premise") agrees with the order of the section (inbred, then genotypic model, then marker panel) and is accompanied by the content. Harmless; not a failure.

## DISQUALIFYING FAILURES

None.

## NON-DISQUALIFYING OBSERVATIONS

None new, none open. Counts: closed 03-M6, 03-M7, 03-M15; reopened none; new none (disqualifying 0, non-disqualifying 0).

## Owed rows (not 03 defects; each names its chapter; 03 is true without them)

| Row | Chapter |
|---|---|
| Terms entry: plain p for the ancestral frequency (90:587-590); "candidate hybrids in the pool" 90:20 and "candidate-pool allele frequency" 90:30 | 90 |
| "The previous chapters took the candidate pool as given" (04:15) | 04 |
| 04e:35-37, says 03 "derived populations from crosses already chosen" | 04e |
| 08b:9-13, quotes "an optimistic ceiling" as 03's words (03 no longer says it) | 08b |
| "optimistic ceiling" at 11b:102 and 12:170 (03's callout no longer supports a ceiling reading; they are judged in their own reviews) | 11b, 12 |

## WHAT WAS VERIFIED

- 02b and 03 knit in scratch against the worktree package (pkgload::load_all), scratchpad k.R: 02b OK 3.1 s, 03 OK 3.1 s; every `stopifnot` passes, including the new 02b one (cfg$fst = 0.15 = book_cfg$fst, cfg$seed = 1 = book_cfg$seed) and the `identical(2 * sim$GL, simulate_lines(...))`.
- Per-hybrid heterozygous fraction = 1 - f^L_ab for arbitrary, related, locus-correlated inbred parents (12 lines, m = 300, set.seed(11), not from the generator): max abs deviation 1.1e-16.
- `f == tcrossprod(cbind(X, 1 - X))/m` for a random 0/0.5/1 matrix (20 x 300, no relation to the generator): max abs deviation 2.2e-16 against the literal mean(x_i x_j + (1-x_i)(1-x_j)).
- sum(G) = 0 for a sample-centred panel: `vanraden_G(2 * X)$G`, 20 x 300 random, sum = 1.2e-14, relative 2.1e-16 (zero up to rounding).
- 05b-M28 numbers above (pf upper tail 4.751259e-55; pf lower == 1 TRUE; var.test p = 0; format.pval output). 05b-M29 sweep recomputation above (2.24 %).
- @sec-bound at 10b:635; convergence statements at 10b:949 and 10b:1187-1189; `converged` attribute and warning at R/12_search.R:343-356.
- Cleanup: my knit created book/figure/ (five untracked PNGs); deleted. No book/Rplots.pdf. No tracked file edited. Untracked remaining are only .claude/review directories.

## NOT VERIFIED

- balding1995 (name and one-parameter idea only) and vanraden2008 (matrix of @eq-vanraden-g by name; code and algebra checked, paper not): unchanged from iteration 2, non-decisive, attributions limited in 03 to what is verifiable.
- `quarto render` of 03 and 02b in HTML or Typst, and the consistency of `docs/` and `_freeze/` after a batch render: only knitr was run.
- The prose of 90, 04, 04e, 08b, 11b and 12 beyond the quoted lines: owed to their own reviews.
