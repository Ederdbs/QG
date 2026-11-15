VERDICT: APPROVED

PREVIOUS IDS (re-review, narrow: 04c-D9 only)
- 04c-D9 -- CLOSED -- book/04c-alphasimr-pipeline.qmd:1481-1485 now defines f-bar as the census-weighted mean molecular coancestry over all pairs of the founder individuals of the two pools, computed by ct_partition() from pullSegSiteGeno(); "no hybrid enters". Matches split_draw() (l.1515-1521: ct_partition(pullSegSiteGeno(c(pop_A, pop_B)), pool); pop_A/pop_B are founder Pop slices, R/13_alphasimr_bridge.R:89-90) and R/07_caballero_toro.R:48-56,73,79 (pool block of the individual coancestry = mean(p_i p_j + q_i q_j), census weights N_i/N_T default, f_bar = w'fw, GD_T = 1 - f_bar). Self pairs included, as sec-ct-notation says.

DISQUALIFYING FAILURES
None (within the scope of this iteration).

NON-DISQUALIFYING OBSERVATIONS
None.

WHAT WAS VERIFIED
- Sentence vs code: read split_draw() and ct_partition(); f_bar, weights and input object agree with the text.
- "GD_WI = half the observed heterozygosity of a plant": ct_partition l.60-63 gives s = mean(P^2 + (1-P)^2), GD_WI = 1 - s_til; for P in {0, 0.5, 1} this is 0 or 0.5, i.e. H_obs/2. Consistent with founders and with the same paragraph (no hybrid involved).
- @sec-ct-notation exists (book/02-subdivided.qmd:32); its bullet defines the bar as the mean over all pairs, f_bar = sum f_ij N_i N_j / N_T^2, self pairs included (callout l.~72), and the tilde/bar partition. This is what the sentence needs.
- Surrounding paragraph (l.1475-1500) read: the F_ST = GD_BS/GD_T, @eq-gd-partition, @eq-ratio-identities, @eq-f-stats references are unchanged from iteration 3 (resolve per it3 E4 check); nothing else in the paragraph altered.

NOT VERIFIED
- No chapter rerun; not needed, the edit is prose only.
