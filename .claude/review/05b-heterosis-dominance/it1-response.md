# 05b-heterosis-dominance -- response to iteration 1 (quant-fix-it1)

Scope of this pass: prose of `book/05b-heterosis-dominance.qmd` and the d_k wording of `index.qmd`, `00`, `01`, `02b`. No chunk code was edited (see the hand-off for quant-Rwrite at the end); three chunks hold a one-line `# QUANT-RWRITE` placeholder and the prose after them reads objects the hand-off defines, so the chapter does not render until the hand-off is applied. Captions (chunk `#| tbl-cap` / `fig-cap` options) were edited where the verdict names them (d_k name, "unit for unit", the new Step 7 table). `make_downloads.R` was run (00, 01, 02, 02b, 05b scripts regenerate; 02's diff predates this pass). Not rendered, not committed.

Decisions taken (rulings a-h):
- (a) d_k is the **dominance effect** (defined at the `What d_k is` section, with "the heterozygote value on the a, d, -a scale"); "dominance deviation" is kept only for Fisher's statistical term (05b `What d_k is`, SCA paragraph).
- (b) Comstock et al. (1949) is cited for the existence of the procedure and its title only; the tester-based algebra is labelled "the book's own derivation", with the sample-of-testers remainder (ties to @eq-het-rho-k), the lines-only premise, and the cross-cycle caveat that the tester pool moves.
- (c) The GCA section now declares that its mu, g^A, g^B, s are the decomposition of H_ij, cites @eq-hp-gca-sca, says g^A is the dominance part of 00's GCA, and introduces the qualifier **GCA for heterosis** (the term 90:216 already uses). The Step-0 sentence at the old 1200-1204 now says the row effects of performance are the GCA of @eq-hp-gca-sca = GCA for heterosis plus sum_k a_k du_ik.
- (d) Callout: partial-inbreeding depression is stated as **not modelled in the book** (04 P9; the book uses ID only at F = 1).
- (e) Heterosis-engine statements aligned with 02/02b: "in expectation"; alpha budgets GD_T = GD_BI + GD_BS; GD_T against GD_BS one for one; GD_WS falls twice as much (derived in the chapter from @eq-het-bn-halves and 2pq = p_Aq_A + p_Bq_B + y^2/2, not measured along the sweep); the additive-variance cost is conditional and untested per 02b.
- (f) F_BN (parameter, `fst`) in every expectation and equation; F_ST only for the statistic GD_BS/GD_T (Caballero & Toro 2002 Eq. 8 as in 00), declared once at the sweep.
- (g) Technow et al. (2014) rewritten to what refcheck read in the full text (GCA + SCA GBLUP, BayesB with additive + dominance effects; small SCA share of total genetic variance). I did not open the paper; this is refcheck's reading.
- (h) S1: `pool_complementarity()` supplies three columns of `s1_monitor()` (@tbl-hp-stages, @sec-stages); S2: @tbl-hp-stages + @sec-stages. "candidate pool" -> "candidate set" (2 places).

## Response table (D, M, B, C; R mapped at the end)

| ID | Status | What changed / evidence |
|---|---|---|
| 05b-D1 | fixed (prose); chunk -> H1 | Step 7 rewritten: the count against sqrt(2/n) is declared one relative s.d., not a tolerance; the measurement is now a replicated comparison (1000 recycled pairs, seeds 7001-8000, against 1000 independent Bernoulli sets, seeds 8001-9000): ratio of s.d. of the % deviation recycled/independent 1.15 (1.07-1.22), 1.22 (1.14-1.31), 1.65 (1.54-1.77) for GCA_A, GCA_B, SCA; central-95 % range of independent excluded by 9, 13, 23 % of recycled pairs. "GCA exposed, SCA not" removed. Mechanism (LD vs relatedness) stated as untested; limits (six founders, free recombination, one d, one pool pair, independent-Bernoulli control) in the Interpretation. **Amendment to ruling 1** (evidence below): at 200 replicates the GCA ratio is 1.05/1.13 (F-test p 0.50/0.09), as the verdict found; at 1000 replicates (the first 200 are the same seeds) it is 1.15/1.22 and p < 1e-4, so GCA dispersion is also larger under recycling, by less than SCA. The prose states the 1000-replicate result and its interval. |
| 05b-D2 | fixed | One name, "dominance effect": defined in `What d_k is`; used at the G(x) paragraph, the display, the two captions, "gamma-distributed dominance effects", the multiset sentence, the lambda bullets; `1181` rewritten to "the specific combining ability in the mean does not" (the object meant was SCA). Fisher's term kept for the statistical object only. Followers changed now (wording only): index.qmd (none needed), 00:125, 00:138 (code comment), 00:165, 01:44, 01:344, 02b:586 (string in a chunk), 02b:592 (comment). 02 has no occurrence. Owed to later chapters/R/: below. |
| 05b-D3 | fixed | `@comstock1949` now cited for existence + title only ("designed to make maximum use of both general and specific combining ability"); the chapter says it reports nothing of the paper beyond its title. The old "designed around", "built on", "selects on" and "exact sense" sentences are removed. Algebra relabelled "the book's own derivation"; (a) "averaging removes s_ij" now exact over all n_B testers, only in expectation over a sample, remainder = mean of k specific deviations, tied to @eq-het-rho-k and Step 6; (b) premise-1 (lines) limit stated, no mapping onto the source's design; cross-cycle caveat added. Unread-source items stay owed elsewhere (below). |
| 05b-D4 | fixed | Declaration paragraph "What these symbols denote" after @eq-het-gca-sca-terms; cites @eq-hp-gca-sca and @sec-mating-estimation; qualifier "GCA for heterosis"; Step-0 paragraph (old 1200-1204) corrected to 00's definition. Owed -> 90: link of the two g^A rows (00-C33). |
| 05b-D5 | fixed | Callout: "This book does not model it" there; points to @sec-sizing P9 and to F = 1 only (@sec-alphasimr). |
| 05b-D6 | fixed (a-d); two caption/chunk items -> H4/H8 | (a) premise rewritten: alpha budgets GD_T = GD_BI + GD_BS of the merged candidate population (@tbl-keystone). (b) quote block and callout: shared term/GD_T pays unit for unit in expectation; GD_WS falls twice (derivation, not measured); "within-pool diversity spent" removed. (c) "arrives in the additive variance" removed twice; conditional/untested per @sec-response-genic. (d) "in expectation" at the opening, after @tbl-het-sweep (the two changes quoted: 0.0739 vs 0.0756, 2 % apart, totals range printed), at @eq-het-bn-halves, in the caption of @fig-heterosis-sweep, Step 8. |
| 05b-D7 | fixed | Convention paragraph rewritten (two symbols, two quantities); F_ST -> F_BN in @eq-het-bn-total text, @eq-het-bn-halves, the offset prose, @eq-het-var-bn, @eq-het-gca-peak, @eq-het-sca-gca-ratio, the relocation prose and caption, the Technow paragraph and callout; F_ST kept for the statistic (alignment section, Trap-3 pointers, Step 8, forward paragraph). Owed -> 90: F^*_k row label (90:232) and the sentence listing @sec-heterosis among chapters that write F_ST for the parameter. |
| 05b-D8 | fixed | Rewritten as above; the claim narrowed to a consistency statement, quantities distinguished (SCA share of total genetic variance vs of the variance in heterosis). |
| 05b-M1 | fixed (wording); assertions -> H4 | Step 7 and Step 4 sentences now say "assert ... to the tolerance of `all.equal()` (the render stops if either fails)". They are true only after H4 is applied. |
| 05b-M2 | fixed (prose); chunk -> H2 | Prose rewritten against 4000 sets/k: k = 1 exact within noise (0.02 s.e.), k = 2,3,5,10 mean above the closed form by 0.001-0.003 (1.6-4.5 s.e.); Jensen/covariance reasons kept as untested hypotheses for the sign; the "5 testers" threshold statement updated (4.9 s.e. above 0.85, s.d. over sets 0.044). Seed scheme note: `55 + 1000 k + i` collides across k above 1000 sets; H2 uses `55 + 1e5 k + i`. |
| 05b-M3 | fixed (prose); chunk -> H3 | Interior-peak claim removed from the draw; prose now reports the grid maximum over pool seeds 1-20 (0.20 in 1, 0.30 in 10, 0.45 in 9; reproduces the verdict), the expected peak 0.36 inside that range; the assertion to use is in H3. |
| 05b-M4 | fixed | Display rewritten with the conditions and the weighted/unweighted distinction. Owed -> 06:363-364 (verbatim repetition). |
| 05b-M5 | fixed (marked) | "No source cited" stated for the corrected reading and for the maize heterotic-group system. Moll et al. 1962 / Melchinger & Gumber 1998 NOT added: I cannot verify their content (Crossref existence only). |
| 05b-M6 | fixed | Forward paragraph recast as an inference; run_cycles has no dominance (08b:136, 08b:763-768); loop on a dominance trait is @sec-alphasimr. Owed -> 11b:404-409. |
| 05b-M7 | fixed | Premise 3 says d_k > 0 gamma(2,4) seed 4 is an illustrative assumption not varied; factor 1.55 qualified at the alignment table, Step 8, Where this connects. No sensitivity run was made (out of scope; stated). |
| 05b-M8 | fixed | S1/S2 pointers as ruling (h). |
| 05b-M9 | fixed | "candidate set" at both places. |
| 05b-M10 | fixed | white2020 sentence now says "both the diversity structure and the heterotic patterns" (abstract-level), the "need describing separately" gloss is attributed to this chapter's reading. |
| 05b-M11 | fixed (prose); chunk -> H6 | Prose reports the s.d. of one run over 8 seeds (0.026), the mean difference (-0.011), -1.2 s.e. |
| 05b-M12 | fixed | Opening paragraph hands over from 00, 01, 02 (@tbl-keystone), 02b (@sec-response). |
| 05b-M13 | fixed | Opening states both halves: at fixed GD_T the loss of GD_BS is a loss of expected heterosis one for one (@eq-het-theta-ab), flat d, inbred parents, complete factorial; "not maximise" is @sec-heterosis-flat. |
| 05b-M14 | fixed (prose); code comment -> H7 | Step 5 says "first non-zero grid point". The comment in the sweep chunk ("anywhere below fst = 0.20") is chunk text -> H7. |
| 05b-M15 | fixed | The unprinted "gap the test actually sees is smaller again" clause deleted; "four subsets" -> four selections of which three are distinct (05:287-289). Typed `5e-3`, `2e-3`, `1e-12` kept as descriptions of the test file (true against `test-dominance.R`). |
| 05b-M16 | owed -> H5 | Oracle on 25 random hybrids incl. pool-B indexing (residual 0 in my run) and a comment that `ref_heterosis` takes the 0/2 matrix. |
| 05b-M17 | fixed | "Zero, exactly" and the Step 1 numbers now say the check is vacuous on simulated 0/1 lines and informative only on real genotypes. |
| 05b-M18 | fixed | "even the predictable part, the GCA variance, shrinks"; invariance stated "in expectation for a d drawn independently of the frequencies". |
| 05b-M19 | fixed (prose); constant -> H7 | Number of groups printed in prose (26; p-bar takes <= 51 values, 2pq symmetric -> <= 26). The `0.9^2/12 + 0.25` hard-code is left; no assertion against the generator is possible from ctx (the ancestral p is not stored); see "left open". |
| 05b-M20 | fixed | H_o identity cross-referenced (@sec-hp-popgen, @tbl-diagonal, @tbl-keystone); GD_WI_hyb credited to @sec-subdivided; @sec-catalogue marked "later"; "will define"/"will prove" replaced; Trap 1 credit corrected. |
| 05b-M21 | fixed (05b side) | k declared as tester count in Step 6; theta_S, GD_T in the final callout; theta_AB identified with f_AB (02) and f-bar^L_AB (01). Owed -> 90 (k rows, f-bar^L_AB row). |
| 05b-M22 | owed -> source access | Falconer & Mackay Ch. 7/14, Fisher 1918, Sprague, Griffing, Reif formula-level: not verifiable here; attributions unchanged and limited to what the chapter derives itself. |
| 05b-B1 | fixed | = D8. |
| 05b-B2 | fixed (to the extent possible) | = D3; paper still unread. |
| 05b-B3 | owed -> source access | Falconer locators unchanged. |
| 05b-B4 | owed -> source access | Fisher 1918 unchanged. |
| 05b-B5 | fixed | "North Carolina Design II of @comstock1948, as in @sec-hybrid-programme" added to the symbols paragraph (entry exists; 00 already makes that statement). |
| 05b-B6 | fixed | = M10. |
| 05b-B7 | fixed (marked) | = M5. |
| 05b-B8 | owed -> source access | Reif formula-level definition not read; the sentence already separates the two ratios. |
| 05b-C1 | fixed | = D2. |
| 05b-C2 | fixed | = D3. |
| 05b-C3 | fixed | = D4. |
| 05b-C4 | fixed | = D5. |
| 05b-C5 | fixed | = M4. |
| 05b-C6 | fixed | = D6 (b), (d). |
| 05b-C7 | fixed | = D7. |
| 05b-C8 | fixed | = M9. |
| 05b-C9 | fixed | = D6 (a), (c). |
| 05b-C10 | fixed (05b side) | = M6; owed -> 11b. |
| 05b-C11 | fixed | = M12. |
| 05b-C12 | fixed | = M7. |
| 05b-C13 | fixed | = M20 (cross-references added in 05b); owed -> 06:468-480: cross-reference @eq-het-split instead of re-deriving. |
| 05b-C14 | fixed | = M20. |
| 05b-C15 | fixed | = M8. |
| 05b-C16 | fixed | = M20. |
| 05b-C17 | fixed | = M15. |
| 05b-C18 | fixed (05b side) | k declared in Step 6; owed -> 90 (rows). |
| 05b-C19 | fixed | theta_S / GD_T in the last callout. |
| 05b-C20 | fixed | = M21. |
| 05b-C21 | owed -> source access | = M22. |
| 05b-C22 | fixed | = M20. |
| 05b-C23 | fixed | = M13. |

R IDs (quant-Rwrite's; prose part done here): R1 = D1; R2 = M1; R3 = M2; R4 = M3; R5 = D3; R6 = D2; R7 = M8; R8 = D7; R9 = M9; R10 = M14; R11 = M15; R12 = M16 (H5); R13 = M17; R14 = M18; R15 info (batch render); R16 = H7 (R/ roxygen); R17, R18 = M19; R19 = M22.

## Earlier chapters changed (wording only, d_k -> "dominance effect")
- `book/index.qmd`: the identity paragraph now states its conditions and "buys no expected heterosis" (was "exact identity ... buys nothing at all"); follows D6/M4.
- `book/00-hybrid-programme.qmd`: line ~125, ~138 (code comment), ~165: "dominance deviation(s)" -> "dominance effect(s)".
- `book/01-coancestry.qmd`: ~44 and ~344: -> "dominance effect(s)".
- `book/02b-response.qmd`: ~586 (inside a chunk string `cap_gca`) and ~592 (code comment): -> "dominance effects". These two touch chunk text of an approved chapter, no number changes; its freeze will re-execute at render.
- `book/02-subdivided.qmd`: no change needed (no occurrence).
(The worktree already carried uncommitted edits to 01, 02, 02b, index and 00 from earlier review iterations; those are not part of this pass.)

## Owed to later chapters / R (not edited)
- d_k name -> 04c:333, 04e:176, 06:364, 06:479, 08b:136, 08b:767, 12:262, 90:210, 90:515, 90:605; roxygen `R/13_dominance.R:18,26,49,125,166` and (addition) `R/09_reference.R:174,182`.
- Comstock unread, decisive: 05:80-81, 04c:20-23, 04c:916, 04e:157 (read the paper or rewrite as a report of the title, marked as the book's reading); 00's Owed item not discharged.
- 06:363-364 repeats the unconditioned slogan; 06:468-480 re-derives @eq-het-split.
- 11b:404-409 ("This chapter is that process running") cannot be kept: `run_cycles()` has no dominance.
- 90: link the two g^A_i rows (qualifier "GCA for heterosis"); F^*_k row (F_BN axis, 90:232); delete @sec-heterosis from the sentence that lists chapters writing F_BN as F_ST; k (testers) vs k (loci) rows; f-bar^L_AB row; theta/GD bare symbols if any.
- R/13_dominance.R:63-66 ("Averaged over loci those two terms are GD_T and GD_BS" omits d == 1); R/05_pipeline_metrics.R:117-119 (pool_complementarity roxygen: "the quantity that actually generates heterosis"; the chapter shows frac_opposite_fixed is exactly 0 up to fst 0.10 while the divergence term rose 2.3-fold).
- docs/ tracked duplicates (R15): batch render.

## Left open
- Falconer & Mackay (Ch. 7, 14), Fisher 1918, Sprague, Griffing, Reif (formula), Balding & Nichols (beta form), Labroo 2021, Mackay 2020 beyond the abstract, Technow 2014 (taken from refcheck), White 2020 (abstract): unverified; Comstock 1949: title only.
- No sensitivity run over d, pool pair or scale (M7 is scoped, not measured).
- Mechanism of the larger recycled-pool dispersion (LD vs relatedness) is untested; physical linkage unmeasured.
- GD_WS "twice" is an algebraic consequence, not measured on the sweep (optional: H7 gives a one-line check).
- The `0.9^2/12 + 0.25` constant has no assertion available.

## Hand-off for quant-Rwrite (chunk and code edits; all code below was run against the chapter's objects in the scratchpad `.../scratchpad/w05b/`, and a test copy of the chapter with H1, H2, H3, H6 inserted knitted without error)

Prose already depends on these; do not rename objects.

### H1 -- Step 7 (chunk `tbl-het-step7-recycled` stays as is; fill the placeholder chunk `tbl-het-step7-dispersion`)
Defines `n_rep7`, `disp7` (rows GCA_A, GCA_B, SCA; columns sd_rec, sd_ind, ratio, ratio_lo, ratio_hi, p_F, mean_rec, mean_ind, band_rec, band_ind, lo95_ind, hi95_ind, out95_rec). Runtime about 5 s. Results printed in `h1run.R`: ratio 1.148/1.221/1.654, p_F 1e-5/3e-10/~0, band_ind 0.300/0.325/0, out95_rec 0.091/0.127/0.227. Optional: print `p_F` with `signif`, since `fmt(disp7, 3)` rounds it to 0.
```r
n_rep7 <- 1000
indep_lines <- function(n, p) matrix(rbinom(n * length(p), 1, rep(p, each = n)), n)
dev_rec <- t(vapply(seq_len(n_rep7), function(r) {
  set.seed(7000 + r)                            # seeded per replicate
  rel_dev(recycle(U, 6), recycle(V, 6))
}, numeric(3)))
dev_ind <- t(vapply(seq_len(n_rep7), function(r) {
  set.seed(8000 + r)
  rel_dev(indep_lines(nrow(U), pA), indep_lines(nrow(V), pB))
}, numeric(3)))
colnames(dev_rec) <- colnames(dev_ind) <- c("GCA_A", "GCA_B", "SCA")
band7 <- 100 * sqrt(2 / book_cfg$n_pool_A)
set.seed(1)                                      # bootstrap of the ratio of s.d.
boot_ratio <- replicate(2000, {
  i <- sample(n_rep7, replace = TRUE); j <- sample(n_rep7, replace = TRUE)
  apply(dev_rec[i, ], 2, sd) / apply(dev_ind[j, ], 2, sd)
})
q95 <- apply(dev_ind, 2, quantile, c(0.025, 0.975))
disp7 <- data.frame(
  sd_rec  = apply(dev_rec, 2, sd),  sd_ind = apply(dev_ind, 2, sd),
  ratio   = apply(dev_rec, 2, sd) / apply(dev_ind, 2, sd),
  ratio_lo = apply(boot_ratio, 1, quantile, 0.025),
  ratio_hi = apply(boot_ratio, 1, quantile, 0.975),
  p_F     = vapply(1:3, function(j) var.test(dev_rec[, j], dev_ind[, j])$p.value, 0),
  mean_rec = colMeans(dev_rec), mean_ind = colMeans(dev_ind),
  band_rec = colMeans(abs(dev_rec) > band7), band_ind = colMeans(abs(dev_ind) > band7),
  lo95_ind = q95[1, ], hi95_ind = q95[2, ],
  out95_rec = vapply(1:3, function(j) mean(dev_rec[, j] < q95[1, j] | dev_rec[, j] > q95[2, j]), 0))
fmt(disp7, 3)
```
### H2 -- Step 6 (chunk `tbl-het-step6-testers`)
Replace `tester_scan`, the `ts` construction and `resid_sd` by the following (the object `ts` keeps `testers, cor_mean, cor_sd, predicted`, adds `resid_se`; `resid_sd` is no longer used). Update the caption: "mean and s.d. over `n_sets` tester sets per k ... residual in standard errors of the mean (`resid_se`)". Results: cor_mean 0.5516, 0.6930, 0.7699, 0.8534, 0.9368; resid_se 0.02, 1.6, 2.4, 3.6, 4.5.
```r
n_sets <- 4000
tester_scan <- function(k, reps = n_sets) {
  r <- vapply(seq_len(reps), function(i) {
    set.seed(55 + 100000 * k + i)               # 1000 * k collided across k
    cor(rowMeans(Htab[, sample.int(nBt, k), drop = FALSE]), cs$gca_A)
  }, numeric(1))
  data.frame(testers = k, cor_mean = mean(r), cor_sd = sd(r),
             predicted = 1 / sqrt(1 + (v_sca / v_gca) * (nBt - k) / (k * (nBt - 1))))
}
ts <- do.call(rbind, lapply(c(1, 2, 3, 5, 10, nBt), tester_scan))
stopifnot(isTRUE(all.equal(ts$cor_mean[ts$testers == nBt], 1)))
ts$resid_se <- ifelse(ts$cor_sd > 1e-12,
                      (ts$cor_mean - ts$predicted) / (ts$cor_sd / sqrt(n_sets)), NA)
fmt(ts, 4)
```
### H3 -- relocation (chunk `tbl-het-relocation`)
Replace `reloc` (new argument `seed`) and the `i_pk`/`stopifnot` lines by the block below; the prose uses `peak_by_seed` and `peak_txt`. Remove the old `stopifnot(F_peak_axis > rl$fst[i_pk - 1], ...)`. The assertion no longer depends on where this draw's maximum falls. Add to the caption "(grid maximum over pool seeds 1-20 in the text)". Result: "0.20 in 1, 0.30 in 10, 0.45 in 9"; F_peak_axis 0.357.
```r
# --- hand-off H3: grid maximum over pool seeds ---
grid_fst <- c(0.02, 0.05, 0.10, 0.15, 0.20, 0.30, 0.45)
reloc <- function(fst, seed = 5) {                 # `seed` is the new argument
  cf <- modifyList(book_cfg, list(fst = fst, seed = seed))
  Pf <- pool_freqs(simulate_lines(cf) / 2,
                   rep(c("A", "B"), c(cf$n_pool_A, cf$n_pool_B)))
  a <- Pf["A", ]; b <- Pf["B", ]
  va <- sum(d^2 * (1 - 2 * b)^2 * a * (1 - a))
  vb <- sum(d^2 * (1 - 2 * a)^2 * b * (1 - b))
  vs <- 4 * sum(d^2 * a * (1 - a) * b * (1 - b))
  data.frame(fst = fst, var_GCA = va + vb, var_SCA = vs,
             frac_SCA = vs / (va + vb + vs))
}
rl <- do.call(rbind, lapply(grid_fst, reloc))
peak_by_seed <- vapply(1:20, function(sd_) {
  r <- do.call(rbind, lapply(grid_fst, reloc, seed = sd_))
  r$fst[which.max(r$var_GCA)]
}, numeric(1))
pk_tab <- table(peak_by_seed)
peak_txt <- paste0(sprintf("%.2f", as.numeric(names(pk_tab))), " in ", pk_tab, collapse = ", ")
stopifnot(F_peak_axis > min(grid_fst), F_peak_axis < max(grid_fst),
          F_peak_axis > min(peak_by_seed), F_peak_axis < max(peak_by_seed),
          identical(rl, do.call(rbind, lapply(grid_fst, reloc, seed = 5))))
```
(In the chapter, `grid_fst` can simply be `c(0.02, 0.05, 0.10, 0.15, 0.20, 0.30, 0.45)` placed before `reloc`; the `rl` line is then `rl <- do.call(rbind, lapply(grid_fst, reloc))`.)

### H4 -- assertions for the printed identities (M1)
Residuals measured: 1.1e-13 (E[H]), 7.96e-13 (reconstruction), 6.97e-12 (lm), 0 (oracle), identities to 1e-15. Values of H are of order 3e2, so use relative tolerances. Replace each printed-only chunk by the code with `stopifnot` and keep the print:
```r
# oracle (H5 below); expected heterosis
stopifnot(isTRUE(all.equal(heterosis_expected(pA, pB, d), mean(heterosis_value(ctx$X, d)))))
# tbl-het-partition-identity chunk (add before fmt(...))
stopifnot(isTRUE(all.equal(hp[["shared"]], gp[["GD_T"]], tolerance = 1e-12)),
          isTRUE(all.equal(hp[["divergence"]], gp[["GD_BS"]], tolerance = 1e-12)))
# eq-het-theta-ab chunk; eq-het-wi-hyb chunk
stopifnot(isTRUE(all.equal(gp[["GD_T"]] + gp[["GD_BS"]], 1 - tp[["theta_AB"]], tolerance = 1e-12)),
          isTRUE(all.equal(2 * gp[["GD_WI_hyb"]], gp[["GD_T"]] + gp[["GD_BS"]], tolerance = 1e-12)),
          abs(gp[["GD_WI"]]) < 1e-12)
# ID identity chunk
stopifnot(isTRUE(all.equal(inbreeding_depression(pA, d), heterosis_partition(pA, pA, d)[["shared"]], tolerance = 1e-12)))
# eq-het-distance chunk
stopifnot(max(abs(h1 - ctx$m * (1 - fL[ab]))) < 1e-9, max(abs(h1 - ctx$m * mrd_matrix(L / 2)[ab]^2)) < 1e-9)
# GCA reconstruction chunk and lm chunk (H, cs, ia, ib as in the chapter)
tol <- 1e-9 * max(abs(H))
stopifnot(max(abs(H - (cs$mu + cs$gca_A[ia] + cs$gca_B[ib] + cs$sca[cbind(ia, ib)]))) < tol,
          abs(cs$mu - mean(H)) < tol, abs(mean(cs$gca_A)) < tol,
          abs(mean(cs$gca_B)) < tol, abs(mean(cs$sca)) < tol,
          max(abs(resid(lm(H ~ factor(ia) + factor(ib))) - cs$sca[cbind(ia, ib)])) < tol)
```
All of these passed in `h4.R` (tol = 3.9e-7). Re-wording check: the prose says "the render stops if either fails" for the reconstruction and lm chunks, and Step 4 says the identity chunk asserts to the `all.equal()` tolerance.

### H5 -- oracle on random hybrids (M16)
```r
set.seed(12); i25 <- sample(ctx$N, 25)
# ref_heterosis takes the 0/2 line matrix L; the line-level functions of the package take 0/1
stopifnot(max(abs(heterosis_value(ctx$X[i25, ], d) - ref_heterosis(L, ctx$ped[i25, ], d))) < 1e-9)
```
(result 0 in my run; the chapter prints `max(abs(...))`.)

### H6 -- inbreeding-depression check (M11), chunk after "different seeds:"
Defines `n_id`, `id_sim`; keep the existing `c(closed_form = ..., simulated = ...)` print if wanted. Result: mean of 8 runs 27.575 vs closed form 27.586, s.d. of one run 0.026, z -1.2.
```r
k <- seq_len(300)
n_id <- 8
id_sim <- vapply(seq_len(n_id), function(s)
  ref_inbreeding_depression(pA[k], d[k], 0.6, n = 20000, seed = s), numeric(1))
id_closed <- inbreeding_depression(pA[k], d[k], 0.6)
id_se <- sd(id_sim) / sqrt(n_id)
c(closed_form = id_closed, simulated_mean = mean(id_sim), mc_sd_one_run = sd(id_sim),
  z = (mean(id_sim) - id_closed) / id_se)
```
### H7 -- smaller items
- Sweep chunk comment (M14): "no marker is fixed for opposite alleles anywhere below fst = 0.20" -> "at no grid point up to 0.10"; the `stopifnot` already tests <= 0.10.
- Optional check for the GD_WS claim (D6): inside `sweep_het` add `within = mean(Pf["A", ] * (1 - Pf["A", ]) + Pf["B", ] * (1 - Pf["B", ]))` and assert `all.equal(sw$shared - sw$divergence, sw$within)`.
- Caption of `tbl-het-step6-testers`: 20 -> `n_sets`, `resid_sd` -> `resid_se`.
- R/ (roxygen only; then `devtools::document()` and `install()`): `R/13_dominance.R` lines 18, 26, 49, 125, 166 and `R/09_reference.R` 174, 182: "dominance deviation(s)" -> "dominance effect(s)"; `R/13_dominance.R:63-66` add "with `d == 1`"; `R/05_pipeline_metrics.R:117-119` drop "the quantity that actually generates heterosis"/"does not keep rising" or restate with the chapter's measurement.
- Then `Rscript book/scripts/make_downloads.R`, the PDF/HTML render per CLAUDE.md, and the freeze/`docs/` sweep.

### Step 7 evidence (all runs made)
Seeds 501-505 (original five draws) reproduce exactly (-3.7/40.3/5.3 ... independent -12.3/-10.2/-1.7). 200 replicates (seeds 7001-7200 / 8001-8200): s.d. rec/ind 29.5/28.1, 33.2/29.4, 10.2/5.6; ratio 1.05, 1.13, 1.84; F-test p 0.50, 0.09, ~0; band share rec 0.33/0.39/0.01, ind 0.29/0.32/0. 1000 replicates (seeds 7001-8000 / 8001-9000, same first 200): in the table above (H1). No other seed family was tried.

## quant-Rwrite pass on iteration 1 (chunks, assertions, roxygen)

Chapter now knits end to end against `load_all` (8.4 s, no `# QUANT-RWRITE` left in the .qmd or the download). Every prose number below was compared with the chunk output of that knit. R/ changed (roxygen only); `devtools::document()`, `devtools::test()` (FAIL 0, WARN 0, SKIP 0, PASS 492), `devtools::install()` run.

| ID | Status | Evidence |
|---|---|---|
| H1 / 05b-D1 (R1) | fixed | Chunk `tbl-het-step7-dispersion` computes `n_rep7 = 1000`, `disp7` (seeds 7001-8000 recycled, 8001-9000 independent, bootstrap seed 1). Printed: ratio 1.148 / 1.221 / 1.654; bootstrap 1.072-1.223, 1.139-1.310, 1.542-1.769; p_F 1.4e-5, 3.4e-10, ~0; band_ind 0.300 / 0.325 / 0; band_rec 0.394 / 0.417 / 0.009; out95_rec 0.091 / 0.127 / 0.227. All equal the writer's prose numbers (1.15 / 1.22 / 1.65, 9 / 13 / 23 %); no difference. p_F is printed through `format()` (rounding made it 0). Mean-deviation sentence now prints one decimal (`sprintf`). |
| H2 / 05b-M2 (R3) | fixed | `n_sets = 4000`, seeds `55 + 1e5 k + i`, `resid_se`; caption updated. cor_mean 0.5516, 0.6930, 0.7699, 0.8534, 0.9368; resid_se 0.02, 1.6, 2.4, 3.6, 4.5 (prose: 0.02; 1.6 to 4.5; 4.9 s.e. above 0.85, s.d. 0.044 -- all match). |
| H3 / 05b-M3 (R4) | fixed | `grid_fst`, `reloc(fst, seed)`, `peak_by_seed` (pool seeds 1-20), `peak_txt` = "0.20 in 1, 0.30 in 10, 0.45 in 9" (matches verdict), F_peak_axis 0.357; assertion: `F_peak_axis` strictly inside the grid and inside the range of `peak_by_seed`, and `identical(rl, reloc at seed 5)`; old neighbour-of-maximum assertion removed. Caption notes the seed-1-to-20 maximum is in the text. |
| H4 / 05b-M1 (R2) | fixed | `stopifnot` added to: `heterosis_expected` vs mean (all.equal), partition identity (1e-12 relative), eq-het-theta-ab (1e-12), eq-het-wi-hyb and `GD_WI` < 1e-12, ID identity (1e-12), eq-het-distance (1e-9 absolute), GCA reconstruction, mean-zero of mu / gca_A / gca_B / sca, and `lm()` equivalence (all three: 1e-9 x max abs H = 3.9e-7). All hold. Measured (from theory: exact identities, double-precision accumulation over 2000 loci / 625 crosses): E[H] rel 3.2e-16; shared rel 2.9e-15, divergence rel 7.2e-15; theta_AB 0; WI_hyb 0 with GD_WI -4.4e-16; ID 0; distance 1.1e-13 and 2.3e-13; reconstruction 8.0e-13; lm 7.0e-12. Prose of Step 4 and Step 7 now states the tolerances actually asserted; the residuals of the reconstruction and lm chunks are also printed inline through `fmt_sci()`. No tolerance loosened. |
| H5 / 05b-M16 (R12) | fixed | 25 random hybrids (`set.seed(12)`), `ref_heterosis(L, ctx$ped[i25, ], d)`; gap 0 (< 1e-9 asserted); comment that the oracle takes the 0/2 matrix. |
| H6 / 05b-M11 | fixed | `n_id = 8` seeds, closed form 27.5856, mean 27.5746, s.d. one run 0.0259, z -1.20 (prose: 0.026, -0.011, -1.2 -- match). |
| H7 / 05b-M14 (R10) | fixed | Sweep-chunk comment now "at any grid point up to fst = 0.10 ... more than doubled between fst = 0.02 and 0.10" (divergence 0.0107 -> 0.0246, 2.3-fold). Optional GD_WS check not added: the prose says GD_WS is not measured along the sweep. |
| 05b-R16 (roxygen) | fixed | `R/13_dominance.R` heterosis_partition: "with `d == 1` at every locus, inbred parents and the complete factorial ... for a `d` that varies GD_BS is the unweighted version". `R/05_pipeline_metrics.R` pool_complementarity: no longer "the quantity that actually generates heterosis"; says it is an indicative statistic, zero up to fst = 0.10 on the book's sweep while the divergence term has already risen. |
| 05b-D2 owed (roxygen) | fixed | "dominance deviation(s)" -> "dominance effect(s)" in `R/13_dominance.R` lines 18, 26, 49, 125, 166 and `R/09_reference.R` 174, 182 (line 148 "plus a deviation" is the delta, left). R/ ASCII checked. |
| 05b-M19 / R18 (constant) | contested (left open) | `0.9^2/12 + 0.25` still hard-coded: the ancestral p is not stored in `ctx`, so no assertion against the generator is possible from the chapter. |
| 05b-R17 (26 groups) | fixed (prose, by writer) | printed from `length(grp)`; unchanged here. |
| 05b-R19 / M22 / B3 / B4 / B8 / C21 | contested (not verifiable) | sources unavailable; unchanged. |

Not done, deliberately: no render, no `docs/` sweep, no commit (instructed). `book/scripts/make_downloads.R` run: 00, 01, 02, 02b and 05b scripts regenerated; no `book/Rplots.pdf` or `book/figure/` present. Complexity: Step 7 chunk is O(n_rep7 x (n m)) for the two replicate loops, 2 x 1000 draws measured within the 8.4 s whole-chapter knit at 25 + 25 lines, 2000 markers.
