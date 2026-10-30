# 02b-response -- response, iteration 1

## quant-writer

Chapter source run (purl + source from book/ with _common.R): 0.97 s elapsed, all stopifnot pass.

| ID | Status | Note |
|---|---|---|
| 02b-D1 | fixed | Seed-1 gap labelled as a single draw; new chunk `response-replicated` replicates the same `simulate_pools()` call over seeds 1:30 (mean relative gap 0.006, SE 0.016, min/max -0.211/0.134) and computes the finite-N intensity (4000 normal draws, set.seed(11)); `stopifnot(|mean gap| < 2 SE)` guards the "no detectable bias" sentence. Skewness/bivariate-normality causal paragraph, "not noise", "does not shrink with more markers" and the "upper bound" callout removed. "exact for a normal criterion" replaced by the infinite-population statement. Scale limit and shared-parent caveat stated in the body. |
| 02b-D2 | fixed | New @eq-response-hybrid-var, Var(x_k) = (pAqA + pBqB)/4 = pq/2 - (pA - pB)^2/8, asserted in chunk `response-hybrid-var`; ratio Var/(pq) printed inline from the chunk (0.107-0.500). "Same sum, weighted differently" and "variance constraint in disguise" (Where this connects) replaced: the link runs through the within-pool part only. |
| 02b-D3 | fixed | G = [[2.0, 0.3], [0.3, 0.3]] (r_G = 0.387); stopifnot on eigenvalues of G and of P - G. All weights recomputed by the existing code (SH 0.617/-0.141; restricted 0.654/-0.654); no typed numbers in prose. |
| 02b-D4 | fixed | Condition restated as "b proportional to a iff a is an eigenvector of P^-1 G; G = cP sufficient, needs neither equal variances nor zero correlation" (matches R/15_response.R:62-70); counterexample G = 0.5 P asserted in chunk `response-sh-proportional`. |
| 02b-D5 | fixed | Callout retitled "The frequency-based metrics cannot see the disequilibrium term"; `eff_dim()` named as the multilocus exception, unweighted by effect. |
| 02b-D6 | fixed | "never once been used" removed; replaced by forward pointers "later chapters use it ... (@sec-stages) ... (@sec-alphasimr)". |
| 02b-D7 | fixed | H stated as an illustrative dominance-only value with d drawn ad hoc, unrelated to beta; shares declared shares of that heterosis, not of gv. "Does not accumulate" and "by luck" removed; replaced by "not measured in this chapter". GCA framed as relative to the opposite (tester) pool; [@sprague1942] added. |
| 02b-D8 | fixed | [@falconer1996, ch. 11] on R = i r sigma_A and on i = phi(z)/q; [@bulmer1971] on the genic + disequilibrium split. |
| 02b-D9 | fixed | "after eight cycles" / "cycle 8" removed; replaced by "at a crossover cycle that varies with the simulation seed". |
| 02b-M1 | fixed | stopifnot added: b S_I = i r sigma_A (`response-identity`), LD identity and genic_var vs oracle (`response-genic`), reconstruction, variance additivity and pairwise orthogonality of gA/gB/sc, R'G b_r < 1e-12. |
| 02b-M2 | fixed | [@smith1936; @hazel1943], @kempthorne1959. |
| 02b-M3 | fixed | "A theorem from 1959". (R/15_response.R:12-13 still says "sixty year old": quant-Rwrite.) |
| 02b-M4 | fixed | Formula introduced as "the C = GR form used by index_restricted() (algebraically equivalent; not necessarily their notation)". |
| 02b-B1 | fixed | = M2. |
| 02b-B2 | fixed | = M2. |
| 02b-B3 | fixed | = M4. |
| 02b-B4 | fixed | = D4. |
| 02b-B5 | fixed | = D8 (falconer1996 ch. 11). |
| 02b-B6 | fixed | = D8 (bulmer1971). |
| 02b-B7 | fixed | = D7: sprague1942 for GCA/SCA; the uncited SCA-accumulation claim removed rather than cited (comstock1949 not used: it does not state that claim to my knowledge). |
| 02b-B8 | fixed | = M3. |

Same-edit overlaps with audit: R1=D1, R2=D2, R3=D3, R4=D4, R5=D5, R6=M1, R7=D9/M3, R8=D6, R9=M2, R10=D7 -- all addressed in the chapter.
New chunk labels (no figures, nothing orphaned): response-identity, response-replicated, response-genic, response-hybrid-var, response-sh-proportional.

## quant-Rwrite

| ID | Status | Evidence |
|---|---|---|
| 02b-M3 (R/) | fixed | R/15_response.R:12-14: "sixty year old ancestor" -> "classical ancestor ... (Kempthorne & Nordskog 1959)"; ASCII clean. |
| 02b-R/15 index condition | fixed (no change needed) | R/15_response.R:62-70 already states b = P^-1 G a proportional to a iff a is an eigenvector of P^-1 G (i.e. P^-1 G a proportional to a), with G = cP as sufficient condition and a correct counter-example. |

document(): OK; test(): FAIL 0 | WARN 0 | SKIP 0 | PASS 470; install(): OK (hybdiv 0.1.0).

## quant-writer (editor findings)

Re-purled 02b and 90 and sourced from book/ with _common.R: 0.97 s, all stopifnot pass, every printed number identical to before (mean gap 0.006, s.e. 0.016; SH 0.617/-0.141; restricted 0.654/-0.654). make_downloads.R re-run. Not rendered.

| ID | Status | Note |
|---|---|---|
| 02b-E1 | fixed | `response-replicated` -> `tbl-response-replicated` with a standalone tbl-cap; no other file referenced the old label; rownames dropped (`row.names = NULL`). No figure, nothing orphaned. |
| 02b-E2 | fixed | `response-genic` -> `tbl-response-genic` (fmt table, cited before it appears). `response-hybrid-var` and the GCA/SCA identity chunk get `#| results: hide`: the first's ratios are already quoted inline, the second's identities are enforced by its stopifnot. No code or stopifnot removed. |
| 02b-E3 | fixed | Headers in words with units via backticked names + `check.names = FALSE` in tbl-response-breeders, -gap, -replicated, -smith-hazel, -restricted; prose reference to `R_from_regression`/`R_with_realised_i` rewritten in words. |
| 02b-E4 | fixed | $H$ kept for heterosis (matches $H_i$ in 90-notation's heterosis table); Smith-Hazel aggregate genotype renamed $W = \mathbf{a}'\mathbf{g}$, $\mathbf{g}$ defined. |
| 02b-E5 | fixed | Trait covariances renamed $\boldsymbol\Sigma_P$, $\boldsymbol\Sigma_G$ in prose, equations and captions, with a sentence that $\boldsymbol\Sigma_G$ is not the relationship matrix $\mathbf{G}$; code variables `P`, `G` unchanged (09 and 04c use them only as code). |
| 02b-E6 | fixed | "$t \times r$" -> "$n_t \times n_r$ ... for $n_t$ traits and $n_r$ restrictions" ($t$ is the cycle index in 90-notation). Also removed a clash not reported: $q$ was both the selected fraction and $1 - p$; intensity now written $\varphi(z)/(n/N)$. |
| 02b-E7 | fixed | 90-notation Response table extended: $z,\varphi$, $b$, $S_I$, $p_{Ak},p_{Bk}$, $q$, $u_{Ak},u_{Bk}$, $W$, $\boldsymbol\Sigma_P,\boldsymbol\Sigma_G$, $n_t,n_r$, $\mathbf{C}$ (flagged as not $\mathbf{C}^{uu}$); $V_{genic}$ -> $V_{\text{genic}}$ (as in 02b and 11c); note that $H$ in @sec-response is the heterosis value. |
| 02b-E8 | fixed | Note rewritten: infinite-population bivariate-normal result; @sec-response finds the replicated mean gap within 2 s.e. of zero at teaching scale; a single seed can over- or underpredict (table min/max -0.211/0.134). No number typed. |
| 02b-E9 | fixed | "the next chunk" -> @tbl-response-replicated. |
| 02b-E10 | fixed | Kept callout-warning; body now names the wrong number: reading flat GD as flat additive variance puts the whole disequilibrium term of @eq-response-ld into $\sigma_A^2$ and hence into $R$ of @eq-response-breeders. |
