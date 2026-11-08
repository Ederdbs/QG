# Response to it2-verdict (book/03-simulating-crosses.qmd)

No number and no chunk code changed. Prose and one code comment only.

| ID | Status | What changed |
|---|---|---|
| 03-M6 | fixed | Callout "What this simulation deliberately does not model": keeps "no selection on estimates has a higher mean true index than the optimum on the known values", now justified by maximality over every feasible selection. States that the book's gains come from greedy, DE and local search, which are not certified optima at book scale (@sec-bound; `ocs_bound()` is the valid bound, `sel_exact()` does not converge there), that a feasible selection is not a bound, and that therefore a gain in `ctx$index` does NOT bound the gain a selection on estimates could achieve. The sentence "a gain in ctx$index bounds ..." is removed. |
| 03-M15 | fixed | Opening of "What the generator assumes": the numbers reported (grid, replicates, expectations) are conditional on the assumptions; the exact identities (per-hybrid heterozygous fraction = 1 - f^L_ab for any inbred parents; f == tcrossprod(cbind(X, 1 - X))/m for any 0/0.5/1 matrix; sum(G) = 0 for any sample-centred panel) do not need them all; locus independence enters replicate dispersion, not expectations. "and not beyond them" is gone. |
| 03-M7 (prose side) | fixed | Intro (lines 29-36) and the code comment at the `sim_02b` chunk now say the values coincide with @sec-response's arguments, that no chunk of either chapter asserts the coincidence, and (comment) that a tying assertion is to be added there. The claim that 02b's chunk "asserts that it uses book_cfg's fst and seed" is removed. The assertion itself is owed -> quant-Rwrite on 02b (not claimed to exist). |

Owed (unchanged from the verdict): 90 Terms entry and 90:20/30; 04-population-sizing:15; 04e:35-37; 08b:9-13 misquote; 11b:102 and 12:170 "optimistic ceiling" (same footing as M6, to be re-judged in their own reviews).

Checks: `make_downloads.R` ran (29 ok; downloads/03 regenerated and contains the new @sec-bound reference only in prose, not code); `knitr::knit` of 03 against the installed/loaded package into a scratch dir completed without error (every stopifnot passes). `@sec-bound` exists (10b:635). Stray book/figure/ removed; no book/Rplots.pdf.

## Code-side fixes (quant-Rwrite, iteration 2)

| ID | Status | What changed |
|---|---|---|
| 03-M7 | fixed | 02b chunk `sim`: `stopifnot(cfg$fst == book_cfg$fst, cfg$seed == book_cfg$seed)` before `simulate_pools()`. 03 intro sentence and the `sim_02b` comment now say 02b's chunk asserts that its `fst` and seed equal `book_cfg`'s (no longer "no chunk asserts"). |
| 05b-M28 | fixed | Comment at the `tab_disp7$p_F` line: "a p that underflows" -> "a p below machine epsilon" prints as the floor. Comment only. |
