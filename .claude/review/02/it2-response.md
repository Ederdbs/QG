
## quant-writer

| ID | Status | Evidence / change |
|---|---|---|
| 02-D13 | fixed | Gloss on @eq-ratio-identities now states G = sum_i N_i(1 - f_ii) G_i / sum_i N_i(1 - f_ii) (from s_i - f_ii = G_i(1 - f_ii)); coincides with the census mean when all G_i or all f_ii are equal; the first two identities fail with the census mean only when both differ ("generally", one case exhibited). New assertion in ct-identities: `all.equal(G_meta, sum(w_he * G_i)/sum(w_he))`, w_he = w(1 - f_ii); passes (toy G_meta 0.6441, census mean 0.6490). |
| 02-D14 | fixed | Assumption declared: doubling needs each individual's contribution equalised as female AND male (controlled pollination). @eq-ne-meta with n = 1, F_ST = 0 is 2N/(V_W + 1) = 4N/(2 + V_k) [@falconer1996, ch. 4] with V_W = V_k/2; equal seed per plant under open pollination gives V_k = 1, N_e = 4N/3, gain 1.333 not 2. New chunk `ne-equal-seed` asserts the mapping at V_k = 2, 1, 0 and both gains; inline `r` values. Callout retitled "Equal contributions of both parents double N_e" and conditioned; "probably the best cost-benefit intervention" replaced by a conditional statement. |
| 02-M5 | fixed | Tip now defines d_ll' = (s_l + s_l')/2 - f_ll' (single-individual s, f via @eq-self-coancestry with N_i = 1), = (p_l - p_l')^2 per biallelic locus, averaged over loci; d_bar_ij is its mean over pairs; d_ll' added to the definitions substituted. |
| 02-M6 | fixed | 02:109 and 90-notation p_{k,l,i} row: no longer equates p_{k,l,i} with x_{lk}; states the reference-allele p_{k,l,i} is the within-individual frequency written x in @sec-notation, whose second index is a marker, whereas k here is an allele. |

Checks: make_downloads.R run; 02 purled and sourced from book/ with _common.R (pkgload::load_all) -- all stopifnot pass. Not rendered. 02-M7 (R/) not touched per instruction.

## quant-Rwrite

| ID | Status | Evidence / change |
|---|---|---|
| 02-M7 | fixed | Status number now attributed to Lindgren, Gea & Jefferson 1997 (= @lindgren1997, Forest Genetics 4:69-76), matching 02-subdivided.qmd:507, in R/07_caballero_toro.R:161 (optimal_contributions) and the same wrong attribution at R/01_metrics.R:38 (status_number). Lindgren & Mullin is 1998 (TAG 96:292-296, @lindgren1998), not the Ns source. document() rewrote man/optimal_contributions.Rd, man/status_number.Rd; test() 470 pass / 0 fail / 0 error / 0 skip; install() OK, installed Rd verified. |
