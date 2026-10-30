# 02-subdivided -- verdict, iteration 2

VERDICT: REJECTED

PREVIOUS IDS
- 02-D1 -- CLOSED -- :104 and :111-113 state 2(1 - s_i) = 1 - F_i = H_o. Table :239 and keystone :589 say H_o/2. ct-identities asserts it against genotype counts, and keystone-check asserts GD_WI_hyb = H_hyb/2. R/01_metrics.R comment corrected.
- 02-D2 -- CLOSED -- :106-110 make p_{k,l,i} the within-individual frequency (0, 0.5, 1). The 0/1/2 failure is stated and asserted (:284).
- 02-D3 -- CLOSED -- the tip now uses d_bar_ij, distinct from D_ij, with D_ij = d_bar_ij - (d_bar_ii + d_bar_jj)/2. Algebra re-derived, and both identities are asserted against a literal double sum (:307-320).
- 02-D4 -- CLOSED as raised -- G is defined as the metapopulation quantity (:253) and the four identities are asserted with it. The accompanying failure condition is wrong; see new 02-D13.
- 02-D5 -- CLOSED -- no Caballero & Toro equation number remains in book/*.qmd or R/ (grep). 05:198/:1225, 04c:1205 and 91:144/:289 still read correctly and stay cited. CLAUDE.md:108 still says "Eq. 8". It is not book text and is noted only.
- 02-D6 -- CLOSED -- the uncited threshold has been removed. The fL ranges are computed live in chunk fl-ranges (re-run: between 0.608-0.664, within 0.668-0.719) and the single-draw scope is stated (:86-87).
- 02-D7 -- CLOSED -- keystone :590 says alpha budgets GD_T = GD_BI + GD_BS. keystone-check asserts it (re-run: 1 - theta = GD_T = 0.32145).
- 02-D8 -- CLOSED -- N_s is separated from N_e (:506-510), and @eq-ne-meta now matches the 2005 restatement (V_W, V_B, 1 - F_ST, symbols defined, assumptions declared). Refcheck it1 supports the form. The operational tip that follows it is a new failure; see 02-D14.
- 02-D9 -- CLOSED -- :486-490 declare the three conditions under which GD_T equals genic variance.
- 02-D10 -- CLOSED -- only the five f-derived rows are presented as a check, and they are asserted at a declared tolerance. GD_WI and GD_BI are stated as agreeing by construction. OC is asserted at 5e-4. The errata section and the 65.5 % figure have been removed.
- 02-D11 -- CLOSED -- the quotations have been removed. The 2005 Table 4 footnote-a correction is reported, and the scope of the check is stated (:566-576).
- 02-D12 -- CLOSED -- every attribution listed now carries a key: cockerham1967, nei1973, toro2005 §2/§3a/§3d/§3e/§4a, wright1951, cockerham1969, meuwissen1997 and lindgren1997. All the keys exist in references.bib.
- 02-M1 -- CLOSED -- no timing claim remains. The cost is now O(N_T m + n^2 m), and :187-188 state that no timing was run.
- 02-M2 -- CLOSED -- :340-345 give an explicit expected-drift derivation. It is algebraically correct for equal pool weights, and the selection limit is stated.
- 02-M3 -- CLOSED -- the numbers are now inline `r`, and the identities are asserted.
- 02-M4 -- CLOSED -- :43-44 name the plug-in form and the omitted 2N/(2N-1) correction.

DISQUALIFYING FAILURES
- 02-D13 [criterion 1] book/02-subdivided.qmd:254-256, gloss on @eq-ratio-identities -- "the first two identities fail with that mean whenever f_ii differs among subpopulations" is false as stated. G = sum_i w_i (1 - f_ii) G_i / sum_i w_i (1 - f_ii) is a (1 - f_ii)-weighted mean of the G_i. It coincides with the census mean sum_i w_i G_i whenever the G_i are all equal, however much f_ii varies. The chapter's own mating-meter row "G_i ≈ 0.5, maize" (:148-150) is such a case: every subpopulation in HWE gives G = sum w_i G_i = 1/2. Checked numerically: w = (.4, .2, .4), f_ii = (.3, .8, .5), G_i = .5 give G_meta = G_wmean = 0.5. The identities fail only when the G_i differ and the two weightings separate them. A differing f_ii is necessary but not sufficient. The chunk at :305 shows one instance of failure and does not support the "whenever".
- 02-D14 [criteria 1, 2] book/02-subdivided.qmd:526-531, callout "Equal seed contributions double N_e", read with :519-524 -- The callout attaches the V_W = 0 result (doubling) to "harvesting the same number of seeds from every plant". That operation equalises only the maternal gametic contribution. In an open-pollinated outcrosser (maize, the case :160 and :327 name) the pollen contribution stays random. With Ne = 4N/(2 + V_k) (Falconer & Mackay ch. 4), maternal variance 0 and Poisson paternal variance 1 give V_k = 1 and Ne = 4N/3, not 2N. On the scale of @eq-ne-meta this is V_W = 1/2, a gain of 4/3, not 2. The doubling requires both parental contributions to be equalised (controlled pollination). That assumption is neither declared nor met by the procedure described. The callout states the gain as unconditional ("No genotyping, no technology, no cost"), and the following paragraph (:534) calls it "probably the best cost-benefit intervention".

NON-DISQUALIFYING OBSERVATIONS
- 02-M5 book/02-subdivided.qmd:178-187 -- the prose calls the identity d_bar_ij = (s_i + s_j)/2 - f_ij "exact", but the per-individual distance it averages is never defined in the text. The definition, (s_l + s_l')/2 - f_ll' = (p_l - p_l')^2 per locus, appears only in a code comment at :307-308. "Follow by substituting the definitions of s_i and f_ij" leaves out the third definition the identity needs.
- 02-M6 book/02-subdivided.qmd:109 and book/90-notation.qmd (Subdivided population table, p_{k,l,i} row) -- "p_{k,l,i} is the x_{lk}" equates two symbols whose index k means different things: an allele in p_{k,l,i}, a marker in x_{lk}.
- 02-M7 R/07_caballero_toro.R, roxygen of optimal_contributions() -- N_s is attributed to "Lindgren & Mullin 1997". The book attributes the same definition to @lindgren1997 = Lindgren, Gea & Jefferson 1997 (02-subdivided.qmd:507; references.bib). The package and the book attribute it differently.

Three non-disqualifying observations: on their own they meet the threshold of three.

WHAT WAS VERIFIED
- Whole chapter purled and executed against the worktree (pkgload::load_all) -- every stopifnot passes. Re-run output: fL between 0.6075-0.6635 (mean 0.638), within 0.668-0.719. Keystone on 30 hybrids: GD_T 0.32145 = GD_BI 0.28086 + GD_BS 0.04059, GD_WI 0, GD_WI_hyb 0.18063. OC c = (0.522, 0, 0.270, 0.208). Removing Sub2: +1.84 % census, +6.47 % equal. Sub2 has the largest mean distance (0.267).
- Weitzman claim at :440-443 ("ranks it first") -- recursive Weitzman diversity computed on D_nei from the published f gives the loss on removal Sub1 5.5 %, Sub2 64.0 %, Sub3 41.5 %, Sub4 9.2 %. Sub2 is ranked first, so the claim holds.
- d_bar / D_nei identities -- algebra: d_bar_ij - (d_bar_ii + d_bar_jj)/2 = (f_ii + f_jj)/2 - f_ij. True.
- Ratio identities with metapopulation G -- true from 1 - F_ST = (1 - f_til)/(1 - f_bar). The census-mean failure condition is false (02-D13, numeric counterexample above).
- Drift argument :340-345 -- f_bar = (f_AA + f_BB + 2 f_AB)/4, f_til = (f_AA + f_BB)/2, E[f_AB] constant under independent drift. Delta, Delta/2 and Delta/2 are correct.
- @eq-ne-meta -- the form, the V_W = 1 vs V_W = 0 doubling and the declared assumptions match the 2005 restatement as reported by refcheck it1 (02-B3, PMC1569508 §4a). V_W ↔ V_k/2 mapping to Falconer & Mackay's 4N/(2 + V_k): Poisson gives 1, maternal-only equalisation gives 1/2 (02-D14).
- D_bar = f_til - f_bar (90-notation row) -- algebra, true.
- Edits outside 02 -- 05:198, 05:1225, 04c:1205-1207 and 91:144/:289 read correctly with the equation numbers removed and remain cited to @caballero2002 or @sec-subdivided. R/07 and R/01 comment edits are consistent with the book.
- FRBA +0.67 % (:451-453) -- consumed from refcheck it1 (Toro & Caballero 2005, Table 4: supported).
- Values transcribed from the 2002 paper (f matrix, s_til, published c) -- UNVERIFIED. The chapter now says so explicitly (:574-576), which satisfies criterion 6.
