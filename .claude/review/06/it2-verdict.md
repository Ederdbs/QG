# Verdict -- book/06-metric-catalogue.qmd -- iteration 2

VERDICT: REJECTED

Inputs: it1-verdict.md, it1-response.md (writer, Rwrite, editor pass), it1-editor.md,
`git diff HEAD` on 06, 05b, 90, references.bib, R/01_metrics.R, rendered docs/06-metric-catalogue.html.
Chapter purled and run end to end against `pkgload::load_all` in
/Users/ederdbs/.claude/jobs/1f3dbb75/tmp/06it2 (every `stopifnot` passes).

## PREVIOUS IDS

- 06-D1 -- CLOSED -- @eq-catalogue-het-hs-dg and @eq-catalogue-lambda-d are correct (checked numerically, below); lambda = 1/2 under flat d is right. The 05b knock-on (05b:1754-1767) is correct: dbar_D = dbar + cov(d, y^2)/mean(y^2) and dbar_H = dbar + cov(d, H_S)/mean(H_S), as in @eq-het-alignment. The repair introduces 06-D3 and 06-D4 (new, below).
- 06-D2 -- CLOSED -- rise stated as measured, additive index declared (06:404-407), mechanism stated as "consistent with", separating comparison declared not evaluated.
- 06-M1 -- CLOSED -- 06:594-598 now names truncation as the unconstrained optimum, not the maximum alpha.
- 06-M2 -- CLOSED -- 06:550-554 gives the reason (fbar_d/n omitted).
- 06-M3 -- CLOSED -- identities asserted with stated tolerance; bias residual 1.32 MC s.e., asserted < 4.
- 06-M4 -- CLOSED -- Simpson 1949, Lacy 1989, Bell & Dean 1970 cited; López-Cortegano qualifier added (06:258-260).
- 06-R1 -- CLOSED -- 3.6 % removed; inline 4.12 % at book scale; production scale declared not computed (06:608-613).
- 06-R2 -- CLOSED -- closing paragraph matches zt (F_drift 36.0 vs GD -18.0; trunc_cap -1.5 / 16.4 / 3.5).
- 06-R3 -- CLOSED -- N_s restricted to base-referenced coancestry; [1/2, 1] bound on f stated (06:151-172).
- 06-R4 -- CLOSED -- relative-terms qualifier, inline 62.2 % / 2.01 %, reversal on z scale stated (Ne_par -12.6 vs GD -18.0).
- 06-R5 -- CLOSED -- greedy_w (w = 0.001) distinct from truncation (alpha 0.0311 vs 0.0412); Spearman over 5 points declared a check, not an estimate.
- 06-R6 -- CLOSED -- claim restricted to the redundancy analysis; metric_redundancy.csv has no F_drift/F_hom column (checked).
- 06-R7 -- CLOSED -- adaptive timing (7.7 vs 117 us in my run); roxygen claim reduced to "slower whenever m > n", which is the O(nm) vs O(n^2) comparison.
- 06-R8 -- CLOSED -- GD_WI and Eq. split asserted.
- 06-R9 -- CLOSED -- n - 1 after double-centring.
- 06-R10 -- CLOSED -- "at least n theta", Rayleigh bound asserted; max excess 0.017 %.
- 06-R11 -- CLOSED -- departure from Odong et al. declared (06:315-323); gap 0.0174-0.0178, ranking unchanged (reproduced).
- 06-R12, 06-R13 -- CLOSED -- seed placed before `sels`; B_full = 1000.
- 06-R14 -- CLOSED -- callout no longer claims global theta looks fine; per-pool erosion test declared not done.
- 06-R15 -- CLOSED -- expectation over random S declared; greedy_div counterexample inline (0.66976 < 0.67191, reproduced).
- 06-R16, 06-B5 -- CLOSED -- not required at it1; unchanged.
- 06-B1 -- CLOSED -- DOI changed to 10.1111/jbg.12455; resolution is quant-refcheck's to confirm.
- 06-B2 -- CLOSED -- Nei credited for H, Caballero & Rodríguez-Ramilo for A, weighted forms to López-Cortegano (five subpopulations), analogy declared as the book's.
- 06-B3 -- CLOSED -- E-NE/A-NE credited to Odong et al. 2013; bib entry added.
- 06-B4, 06-B6, 06-B7 -- CLOSED -- via 06-M4.
- 06-E1..E5 -- CLOSED -- tables labelled and captioned, symbols added to 90, eta/omega renames, code comment fixed; captions render with no literal markdown (below).
- 06-E6 -- CLOSED -- optional, form; out of scope.

## DISQUALIFYING FAILURES

- 06-D3 [criterion 5] book/06-metric-catalogue.qmd:443, :448, :468, :476, :491; book/90-notation.qmd (heterosis table, row "H_T, H_S, D_G") -- $H_T$ is defined twice in five lines. 06:443 (new text) and the 90 glossary define $H_T = H_S + D_G$ [Nei 1973], the unweighted total, and 06:468/:491 use it per locus as $2\bar p_k(1-\bar p_k)$ and as $GD_T$. @eq-catalogue-lambda (06:448) then writes $H_T = D_G + \lambda H_S$, the lambda-weighted objective, which equals the first only at $\lambda = 1$. The D1 repair rests on exactly this distinction: 06:476 says expected heterosis is "twice the first form of @eq-catalogue-lambda with $\lambda = 1/2$". Read with the $H_T$ of 06:443 and of @eq-catalogue-het-hs-dg, $2H_T = 2H_S + 2D_G$, not the $H_S + 2D_G$ the identity gives. The argument holds only if the reader silently swaps the meaning of the symbol between 06:443 and 06:448. The it1 finding D1 was a confusion between $H_T$ and $H_S$, and the same symbol now carries two quantities within the paragraph that corrects it.
- 06-D4 [criterion 2] book/06-metric-catalogue.qmd:478-490; book/05b-heterosis-dominance.qmd:1754-1757 -- the factorisation $\sum_k d_k(H_{S,k}+2D_{G,k}) = 2\bar d_D(D_G + \lambda_d H_S)$ is an identity, but reading $\lambda_d$ as "the right weight" of @eq-catalogue-lambda, a maximisation weight with $\lambda \in [0,\infty)$ (06:451), needs $\bar d_D > 0$ (otherwise maximising expected heterosis minimises the bracket, or $\lambda_d$ is undefined) and $\bar d_H \ge 0$. @eq-het-genotypic-value (05b:143) puts no sign on $d_k$, and 05b:872 states $d_k > 0$ as a case, not as the model. The condition (net directional dominance on the divergence- and within-pool-weighted loci) is used and not declared, in 06 and in the 05b sentence that relays it.

## NON-DISQUALIFYING OBSERVATIONS

- 06-M5 book/06-metric-catalogue.qmd:561-563, :571, :585 -- the alpha reference has three names in one section: $GD_{\text{random}(n)}$ (equation and caption), `GD_reference` (printed output of the chunk at :569-576) and `gd_ref` (code). Chapter 00 (00:262-263) and the 90 alpha row use $GD_{\text{ref}}$. 90 now states that the two symbols are the same quantity, so this is not a silent redefinition and does not reject on its own. It remains a second symbol for a quantity the book already names, on the writer's open remark. Recorded, not disqualifying.
- 06-M6 book/06-metric-catalogue.qmd:399-402 -- "GD_BS *rises* under truncation" compares truncation with one random subset and shows no dispersion. I verified that the rise is real: over 400 random subsets of n = 60 (seed 7), GD_BS = 0.0358 +/- 0.00059, so truncation's 0.0524 is about 28 s.d. above. The z table (@tbl-catalogue-z) does not carry GD_BS, and the text gives the reader no scale for the difference.

Two non-disqualifying observations, below the accumulation threshold.

## WHAT WAS VERIFIED

- @eq-catalogue-het-hs-dg -- 1000 random loci: $D_{G,k} = y_k^2/2$ (max err 7.6e-17); $p_A+p_B-2p_Ap_B = H_{S,k}+2D_{G,k}$ (max err 1.7e-16). Also by hand: $H_T + D_G = p_A+p_B-(p_A+p_B)^2/2+(p_A-p_B)^2/2 = p_A+p_B-2p_Ap_B$.
- @eq-catalogue-lambda-d factorisation -- `all.equal(sum(d*(HS+2DG)), 2*dD*(sum(DG)+ld*sum(HS)))` TRUE with d ~ Exp(1).
- 05b knock-on -- the $D_G$-weighted mean of d equals $\bar d + \mathrm{cov}(d,y^2)/\overline{y^2}$ (since $D_G \propto y^2$), and the $H_S$-weighted mean equals $\bar d + \mathrm{cov}(d,H_S)/\overline{H_S}$; consistent with @eq-het-alignment. The old "ratio ... is what lambda is trying to express" is gone from 05b; 05b:1715-1716 still points to @sec-heterosis-lambda consistently.
- tbl-catalogue-het-identity -- 1 - theta_AB == (GD_T - GD_BS) + 2 GD_BS on all five selections (reproduced, e.g. truncation 0.364821).
- Inline numbers reproduced: rank_cor 1; N_s range 0.727-0.747; Ne_par drop 62.2 %, theta +2.01 %; A-NE gap 0.0174-0.0178, ranking unchanged; Rayleigh excess 0.017 %; GD_WI max |.| 6.7e-16; GD_BS 0.0374 -> 0.0524; Ne_lines truncation 4.5/11.8 vs random 17.6/16.8; bias predicted 0.002222, observed 0.002277, MC s.e. 4.12e-5, residual 1.32 s.e.; greedy_div theta 0.66976 vs theta_N 0.67191; alpha truncation 0.0412 (< 0.05, "inoperative"); z table identical to the caption/prose values; nrow(null$full) = 1000.
- sel_greedy score -- R/03_de_select.R:100-101 is `w * index - theta_new`, matching the 90 omega row.
- R/01_metrics.R roxygen -- O(n^2) vs O(nm): the frequency route is slower iff m > n; correct.
- Rendered HTML -- docs/06-metric-catalogue.html: 0 `quarto-unresolved-ref`, no `?@` strings; all 11 table captions render as "Table 11.x" with resolved "Equation 11.y" links, no raw `$`, backticks or `@` left in caption text.
- Bib additions (odong2013, simpson1949, lacy1989, belldean1970) -- metadata consistent with the works as I know them; resolution is quant-refcheck's.
