# 02b-response -- verdict, iteration 3

VERDICT: APPROVED

PREVIOUS IDS
- 02b-D10 -- CLOSED -- book/02b-response.qmd:298-328, 371-383. The section now says the criteria are predicted values (`traits` of build_ctx(), R/11_stage2.R:22-30). It says build_ctx() standardises each column before weighting (R/00_data.R:168-171, `scale(scale(traits) %*% weights)`), so the default is a'ghat with a_j = 1/sd(ghat_j), up to a positive affine map. It states the general optimum Var(c)^-1 Cov(c,g')a and says that b = a under multi-trait BLUP (Cov(ghat,g') = Var(ghat)). Smith-Hazel is restricted to phenotypic records y = g + e. The assumption that the predictions behave as multi-trait BLUP is declared and stated as untested. The unsupported "not the index anyone intended" is removed.
- 02b-M5 -- CLOSED -- :250-253. The heading no longer says "already had". @sec-heterosis-gca-sca is labelled as a later chapter used ahead of its derivation.
- 02b-M6 -- CLOSED -- :148-150. The shared-parent "limit" is removed, and the teaching-scale limit is the only one stated.
- 02b-M7 -- CLOSED -- :191-195. The text uses u_k, v_k, declared as the u_ik, v_jk of 05b:733-735 without the line index, which matches code `U`, `V` and 90-notation:140. Scalar g is removed (:41 now says gv = X beta), and bold g/ghat is defined at :311-313 and in 90-notation:333/351, distinguished from the GCA g^A_i, g^B_j.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
None.

WHAT WAS VERIFIED
- The default index: on a random 100 x 3 matrix with column scales 1, 5 and 0.2, cor(scale(scale(T) %*% 1), T %*% (1/sd_j)) = 1. The R/00_data.R:171 construction is therefore a positive affine map of sum_j ghat_j/sd(ghat_j), as the text states.
- The BLUP => b = a claim: ghat = Sigma_G Sigma_P^-1 y gives Var(ghat) = Cov(ghat,g') = Sigma_G Sigma_P^-1 Sigma_G, so Var^-1 Cov a = a. Numerically, (1, 1) is returned for the chapter's P and G. t(K)a = Sigma_P^-1 Sigma_G a = b_SH = (0.617, -0.141). Both match the new stopifnot.
- The single-trait BLUP counterexample: K = diag(G_jj/P_jj) gives b = K^-1 Sigma_P^-1 Sigma_G a, which is not equal to a in general. This is consistent with "fails in general".
- The chapter was purled to the scratchpad and sourced from book/ against the review worktree. All stopifnot pass, the two new ones included.
- The 90-notation Response table has 22 Symbol / Meaning / In-the-code entries, aligned, and the appendix code runs. Its u_k, v_k and g/ghat rows agree with 02b and 05b.
- No new failure was found in the text changed since iteration 2 (02b :41-46, :148-150, :191-195, :246-253, :296-383; 90-notation :328-372).
