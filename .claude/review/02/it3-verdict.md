# 02-subdivided -- verdict, iteration 3

VERDICT: APPROVED

PREVIOUS IDS
- 02-D13 -- CLOSED -- book/02-subdivided.qmd:260-268 now give G = sum_i N_i(1 - f_ii) G_i / sum_i N_i(1 - f_ii), which follows from s_i - f_ii = G_i(1 - f_ii). The text states that it coincides with the census mean when all G_i or all f_ii are equal, and that the census mean fails only when both differ ("generally", one case exhibited). Both sufficient conditions are correct. ct-identities:313 asserts the weighted-mean form, and :319 asserts that the census-mean version fails on the toy (re-run: G_meta 0.6441, G_wmean 0.6490).
- 02-D14 -- CLOSED -- the assumption is now declared (:551-552, controlled pollination, equalisation as both female and male parent). The open-pollination case is stated as 4N/3 with gain 4/3 (:556-560), citing @falconer1996 ch. 4 (key present in references.bib:506). The callout (:562-570) is conditioned. The mapping V_W = V_k/2 holds: Poisson gives V_k = 2 and V_W = 1. Chunk ne-equal-seed asserts the mapping at V_k = 2, 1, 0 and both gains.
- 02-M5 -- CLOSED -- the tip at :178-185 defines d_ll' = (s_l + s_l')/2 - f_ll' and its per-locus value (p_l - p_l')^2, and lists d_ll' among the substituted definitions.
- 02-M6 -- CLOSED -- the text at :110-112 and the p_{k,l,i} row in 90-notation.qmd:108 no longer equate the two symbols, and they state that the second index of x is a marker and that k here is an allele.
- 02-M7 -- CLOSED -- R/07_caballero_toro.R:161 and R/01_metrics.R:38 both read "Lindgren, Gea & Jefferson 1997", consistent with @lindgren1997 at :521. No "Lindgren & Mullin 1997" remains in R/, man/ or book/*.qmd (grep).

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 02-M8 book/02-subdivided.qmd:572 -- "Under controlled pollination it is an inexpensive intervention" has no support. In maize the cost of the scheme is the controlled pollination itself, which the sentence makes its precondition. The earlier "no cost" claim has been narrowed, but a cost statement remains with nothing behind it. This is the only non-disqualifying observation, below the threshold of three.

WHAT WAS VERIFIED
- Whole chapter purled and sourced against the worktree with _common.R. Every stopifnot passes, including the new :313, :319 and ne-equal-seed assertions.
- G as a (1 - f_ii)-weighted mean -- algebra. s_til - f_til = sum w_i G_i (1 - f_ii) and 1 - f_til = sum w_i (1 - f_ii). True. With equal f_ii the weights reduce to w_i, so the two means coincide. True.
- N_e = 4N/3 under equal maternal and random paternal contributions -- Monte Carlo with N = 200 and 200 replicates: each plant contributes 1 female gamete plus a multinomial number of male gametes. Mean V_k = 0.994, and 4N/(2 + 1) = 4N/3. The gains 4/3 and 2 were reproduced by the chunk.
- d_ll' per locus -- (p^2 + q^2 + p'^2 + q'^2)/2 - pp' - qq' = (p - p')^2. True.
- Changed text outside the fixes (the :536-538 doubling sentence, now read together with the conditioning at :551) -- consistent with V_W = V_k/2.
