# Response to it1-verdict.md: book/02b-response.qmd (iteration 1)

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05, branch review-01-05. Not committed, not rendered. `file:line` are lines of the edited `book/02b-response.qmd` unless a path is given. Prose only: no chunk code or assertion was changed. Two strings inside chunk headers/data frames were changed because they are the wording of a claim (listed under D2 and D5).

Verified by me in the scratchpad before writing (seed 1, `simulate_pools(25, 25, 2000, 0.15, 300, 0.5)`): factorial covariance = (Cov_A + Cov_B)/4 to 1.5e-15 (population divisor); `genic_var(X, beta)` = N/(N-1) sum beta^2 (pA qA + pB qB)/4 (25.2051 = 25.2051); additive `gv` = a_i + b_j to 1.2e-14 with var(gv) = var(a) + var(b) = 22.48375; equal-effect case sum(vpop) = m GD_WS/4 (147.248 = 147.248) with GD_T = 0.32809 = GD_WS 0.29450 + GD_BS 0.03360. Meuwissen et al. 2020: Introduction and the "Optimum Contribution Selection" Methods paragraph read in the local PDF (maximise g-bar = c'g-hat; K = 1/2 c'Gc constrained; OC credited to Meuwissen 1997 and Woolliams 2015 in the Introduction).

## Disposition table

| ID | Status | What changed / evidence |
|---|---|---|
| D1 | fixed (K&N stays UNVERIFIED, see Open) | Lineage rewritten (section "The alpha constraint beside the restricted index"). Removed "directly anticipates / ancestor", "exactly the same problem", "a theorem from 1959", "what is new is the restricted direction" and the invented claim of novelty. (a) Added Meuwissen 2020 (Methods paragraph read) and Meuwissen 1997 (reported through the 2020 Introduction, "itself not read"); `meuwissen1997`, `meuwissen2020` already in references.bib; 01's @eq-g05 cited for the affine link f -> G_0.5, noting the paper gives no formula. (b) Four differences listed (form, expectation vs realisation, quantity restricted, equality vs inequality); the equation is stated as the book's own form, only C'b = 0 is claimed (by substitution and the chunk), the derivation is declared not given. (c) K&N 1959 described only as "the reference the book cites ... not read, contents not verified". (d) "exactly zero ... not on average" replaced: zero is an EXPECTED gain for known Sigma_P, Sigma_G and linear regression; the realised change in a finite sample or with estimated matrices is not zero; the alpha bound is a deterministic property of the selected set given its reference value. C19 included in difference 3 (GD_T contains GD_BS, not in V_genic). Callout renamed "What the lineage does and does not show". |
| D2 | fixed in prose; numbers owed to quant-Rwrite (hand-off H1) | :209-235: identity of eq-response-ld stated as covariance algebra (no source); Bulmer reported as the selection mechanism, "primary text not read"; three declared assumptions (loci independent in the generator, no selection, finite lines); factorial identity Cov = (Cov_A + Cov_B)/4 given as a design identity; expectation zero under (i)+(ii); seed-1 value "cannot be read as the size or sign of a Bulmer effect"; pointer to the random-selection control of @sec-limits. Two strings changed in the table chunk: caption now says "sampling covariance among loci of the 25 + 25 founder lines, expectation zero", row label "disequilibrium term" -> "covariance term". No replicate number from the verdict (mean -0.138, s.e. 0.835; share mean -0.009, s.d. 0.205) is typed into the text: it needs a chunk (H1). |
| D3 | fixed | :323-337 callout and "Where this connects" no longer promise that @sec-limits shows the term "matters more". Reworded to what 11c:95-235 does today: it tests, against a random-selection control, whether selection builds the covariance term (significant), that it is largest early and decays, and ranks it below the permanent frequency cost (11c:207-226) on condition of fast decay; "does not compare a gene-diversity trajectory with a variance trajectory". C6 folded in: the callout now gives two separate reasons (GD_T = GD_WS + GD_BS and only GD_WS enters V_genic, so a flat GD_T can hide a falling GD_WS; the covariance term is invisible to one-locus metrics) and says @sec-limits tests only the second. |
| D4 | fixed (withdrawn); owed -> 09 | The sentence "@sec-ocs works out what changes when the equality becomes an inequality" is deleted. Replaced by difference 4: the change is not worked out here or in @sec-ocs; 09 states alpha <= alpha_max "bounded relative to a resampling baseline, not held at zero" (09:72-74) and that a budget above the attainable maximum restricts nothing (09 "Setting alpha_max"). "Where this connects" now says 09 "does not derive the constraint from the restricted index, and nothing here does". owed -> 09: either add the equality-versus-inequality passage or keep the 02b wording; and 09:48/09:50 ("identical problem", "derives their solution") (see C11). |
| D5 | fixed (rescaled column owed, hand-off H4) | Chunk string: column "expected gain in moisture (trait units)" -> "covariance of index with moisture"; caption now says the last column is R'Sigma_G b = Cov(b'y, moisture), scale-dependent, not a gain, and gives the gain per round i R'Sigma_G b / sqrt(b'Sigma_P b). Paragraph after the table gives the derivation (regression slope times i sd(b'y)). The value 0 for the restricted index stands. The rescaled-gain column is for quant-Rwrite. |
| D6 | fixed; assertion owed (H5) | Section retitled "Combining ability against a tester pool". Without dominance (d_k = 0, the case of gv): average effect beta_k whatever the pool, GCA independent of tester (00:126-129), gv_ij = a_i + b_j, SCA zero up to rounding, var(gv) = var(GCA_A) + var(GCA_B), "the whole sigma_A^2 is GCA variance". With dominance: dominance part of GCA at the opposite pool's frequencies, property of a line against a tester pool, SCA appears. Numbers verified above (not typed in the text). Dominance assumption now stated where each statement is made. |
| D7 | fixed | :(new "What response means") and the replicated-check paragraph: realised response = genetic selection differential on the selected hybrids, not a transmitted response; hybrids are not recycled (A3 of @sec-hybrid-programme); the check tests only whether eq-response-breeders reproduces that differential on this additive generator. Resolving power stated with an inline expression of an existing object: two s.e. = `r fmt(2 * gap_se, 3)` (no new number typed); "absence of a detectable gap above that size, not proof of zero"; seed 1 is one of the 30, not independent. "reaches the same reading" deleted; 04c described as a different object (progeny mean, r against breeding value), "not a replication of this check and its numbers are not reproduced here". |
| M1 | fixed | Data paragraph: simulate_pools() uses the same Balding-Nichols frequencies, lines and factorial as 03 but a different trait (03:11-19). "Lighter" removed; closing sentence also corrected. |
| M2 | fixed | Heading changed (D6); sentence that the seed-7 N(0.3, 0.1^2) draw is not the gamma/seed-4 draw of @sec-heterosis, that 05b owns the decomposition and tests, and that shares depend on the draw. |
| M3 | fixed | New opening: follows @sec-coancestry, @sec-subdivided, @sec-hybrid-programme; says why it follows 02 (02 defers the GD_BI-to-response link and the mixture-base derivation here); preface item 3 named; no crossover predicted. |
| M4 | fixed; 02 changed (see below) | 02b now carries both cases after eq-response-hybrid-var: (a) mixture base as the pA = pB limit, Var(x_k) = pbar qbar/2, V_genic = sum beta^2 pbar qbar/2, equal effects m beta^2 GD_T/4; (b) hybrids, equal effects m beta^2 GD_WS/4, equal to the former only when GD_BS = 0. Conditions stated; the chapter's own 300-QTL trait satisfies neither. Owed 02-M9: settled (02b owns the derivation, 02 keeps its three sentences and now points to it). |
| M5 | owed -> quant-Rwrite (H2) | Chunk/printing work. |
| M6 | fixed | "Two identities" -> "One identity", with the symbols and scale defined; the second identity is offered to quant-Rwrite (H3). |
| M7 | owed -> quant-Rwrite (H6) | Hand-typed configuration numbers in prose and captions; I added none of mine (used N/(N-1) and "25 + 25" only where the chapter already typed them; the new sentences say "25 + 25 founder lines" in two places, to be turned into code values). |
| M8 | fixed | Callout uses $\theta_S$, $GD_S$/$GD_T$, $F_{hom}$, $F_{drift}$; "gene diversity of the hybrid pool" is named $GD_T$ (@eq-hp-gd, @tbl-keystone); the between-pool term is named $GD_{BS}$ and the within-pool part $GD_{WS}$ with their formulas; callout title "covariance term". q-bar is defined as 1 - p-bar at its use. |
| M9 | fixed | "Where this connects" rewritten: 05/06 "report the frequency-based metrics ... neither computes V_genic"; r "is constructed as the correlation between the index and the true genetic value, set by h^2 = 0.5", 08b "measures a prediction accuracy for a different object"; Finding 5 of @sec-choosing kept. |
| M10 | prose fixed; assertion owed (H7) | After eq-response-hybrid-var: population scale (divisor N) against `genic_var()` and `var(gv)` (N - 1); genic_var = N/(N-1) x population-scale sum, stated exactly (verified 25.2051). Assertion for quant-Rwrite. |
| M11 | fixed | Quotation removed; paraphrase of the committee statement, no quotation marks. |
| M12 | fixed (Falconer locator UNVERIFIED) | "ch. 11" removed at both places; a sentence says the book was not available to check chapter locators. Balding-Nichols now cites [@balding1995]. The genic/realised definition is declared a definition of the chapter. Smith-Hazel: "papers not read; checked by algebra and chunk; notation modern". BLUP property: "standard, used without a citation, verified for the example". |
| M13 | owed -> quant-Rwrite (H8) | Stochastic assertion; prose now states the resolving power. |
| M14 | fixed | Sprague & Tatum cited for the concepts; "the exact orthogonal split used here is the book's own, derived in @sec-heterosis-gca-sca". |
| B1 | fixed | See D1. "Exactly the same problem" removed; 09:48 is 09's. |
| B2 | fixed as hedged; UNVERIFIED stays | Equation stated as the book's form "not claimed to be their notation"; K&N contents not asserted; priority claim removed. |
| B3 | fixed (not verified) | "Papers not read" stated at the citation. |
| B4 | fixed (locator UNVERIFIED) | Locators removed. Not added: Rendel & Robertson (1950) (key not in the bib, content not read). |
| B5 | fixed | See D2. |
| B6 | fixed | See M14. |
| B7 | fixed | See M12. |
| B8 | fixed | Declared a definition; no source claimed. |
| B9 | fixed | Standard results declared uncited and verified by the chunk. |
| C1 | fixed | See D3. |
| C2 | fixed | See D4. |
| C3 | fixed | See M3. |
| C4 | fixed | See M4. |
| C5 | fixed | See D2. |
| C6 | fixed | See D3. |
| C7 | fixed | See D6. |
| C8 | 02b half fixed; owed -> 04c | See D7. owed -> 04c: define r against the breeding value in 04c:850-856 and say it is not the r of @eq-response-breeders unless d = 0; also 11c:21 and 04d:260 read 02b's response as the response to one cycle (owed -> 11c, 04d). |
| C9 | owed -> 09 | 09:52-60 uses G = [[2.0, 0.9], [0.9, 0.3]] (det -0.21, not a covariance matrix) for the same example; cross-reference @tbl-response-restricted and drop the duplicate lineage argument (09:44-78). |
| C10 | owed -> 04c | 04c Step 7 should state the phenotypic-versus-predicted-criteria distinction of 02b and say what its AlphaSimR instance adds. |
| C11 | 02b half fixed; owed -> 09 | 02b states, does not derive, the equation, and says so (D1). owed -> 09: 09:48 "identical problem", 09:50 "@sec-response derives their solution". |
| C12 | fixed | See M8. |
| C13 | fixed | See M9. |
| C14 | owed -> 11b, 08, 08b | Information item: none of them cites @sec-response; decided at their reviews. |
| C15 | fixed | See M1. |
| C16 | owed -> quant-Rwrite (H2) | |
| C17 | prose fixed; assertion owed (H7) | See M10. |
| C18 | fixed | See M11. |
| C19 | fixed | See D1, difference 3. |
| R1 | -> D2 | prose fixed; H1 |
| R2 | -> D1 | fixed |
| R3 | -> D6, M2 | prose fixed; H5 |
| R4 | -> D5 | prose fixed; H4 |
| R5 | quant-Rwrite | H2 |
| R6 | -> M6 | fixed; H3 optional |
| R7 | quant-Rwrite | H6 |
| R8, R9, R12 | -> D7, M13 | prose fixed; H8 |
| R10 | -> M4 | fixed |
| R11 | -> M8 | fixed |
| R13 | -> M10 | prose fixed; H7 |
| R14 | owed -> 09, 11c | 09:50 "derives"; 09:48; 11c:114-115 "two divergent pools add more" is false for a complete factorial (the cross-pool covariance term is absent by the design identity of D2). |

Counts (D, M, B, C IDs only): fixed 40 (D1-D7: 7; M1-M4, M6, M8, M9, M11, M12, M14: 10 fully; M10 and C17 prose-fixed with an assertion owed: 2; B1-B9: 9; C1-C7, C12, C13, C15, C18, C19: 12), contested 0, owed to other chapters: C8 (04c, 11c, 04d), C9 (09), C10 (04c), C11 (09), C14 (11b, 08, 08b), D4 (09, optional passage). Owed to quant-Rwrite: M5, M7, M13, C16 (and the chunk halves of D2, D5, D6, M6, M10).

## Earlier chapters changed

- `book/02-subdivided.qmd` (mixture-base bullet, :805-808 in the tracked tree): "@sec-response, where this derivation belongs, shows that their genic variance contains only the within-pool part" -> "@sec-response, which derives the hybrid case and restates the case above as its limit with equal pool frequencies, shows that their genic variance contains only the within-pool part ...". Four lines, wording only. 02's own derivation (02:788-803) was kept; it agrees with 02b (a). The worktree already carried uncommitted edits of 02 from its own review; this diff is the only one of this pass.
- `index.qmd`, `00`, `01`: not changed.

## Hand-off to quant-Rwrite (chunks and assertions; I changed none beyond the two strings named under D2 and D5)

H1 (D2, R1). New chunk after tbl-response-genic: over seeds, e.g. 1 to 30 as in the replicated chunk and a disjoint 31-230 block, `set.seed()` through `simulate_pools(seed = s)`: the covariance term var(gv) - genic_var(X, beta), its mean, s.e., fraction negative, and its share of genic variance (mean, s.d.). Reference values I recomputed: seeds 1-30 mean -0.138, s.e. 0.835; share over seeds 31-230 mean -0.0092, s.d. 0.205; seed-1 term -2.72 (about -10.8 percent of V_genic). Then add one inline-R sentence after the paragraph at :221-235 ("over N seeds the term has mean ... and its share of the genic variance has s.d. ...; the seed-1 value lies within ... of zero"). Assert in the chunk the factorial identity max|cov(X) - (popcov(U) + popcov(V))/4| < 1e-12 with a printed deviation (measured 1.5e-15, population divisor).

H2 (M5, C16, R5). Print deviations with `fmt_sci()` for: tbl-response-genic last row (now prints 0.0000 through `fmt(, 4)`; actual 1.07e-14), `response-hybrid-var` (hidden, deviations about 1.8e-16), the GCA/SCA chunk (`results: hide` hides `reconstruction_dev` 5.1e-13 and `identity_dev` 9.2e-14, on which "variances add exactly" rests), the `response-identity` chunk and `response-sh-proportional`. State the tolerances used (default all.equal 1.5e-8; 1e-10 and 1e-12 explicit) or tighten them to the achieved order. The preface promise is index:73-77.

H3 (M6). Optional second identity so that "One identity" can become "Two": realised response = response from regression + (mean of the regression residual over the selected set), because the residual e = gv - a - b I has mean zero over the candidates; one `stopifnot(all.equal(...))`, printed deviation. If added, change "One identity can be read off it" to "Two" and state it in the text.

H4 (D5). Add a column "expected gain per round in moisture (trait units)" = i_norm * R'Sigma_G b / sqrt(b' P b) with i_norm = `sel_intensity(60/625)` taken from the existing object, for both indices; reference: sigma_I = 1.1555, Smith-Hazel about 0.124 i (about 0.22 at i = 1.774), restricted 0. Keep the covariance column and the existing `stopifnot`; note in the text that the restricted value is an expectation.

H5 (D6, R3). In the GCA chunk (or a new one before the dominance illustration): with `d <- rep(0, ncol(X))`, `heterosis_gca_sca(U, V, d)`: `stopifnot(max(abs(gs$sca)) < 1e-10, isTRUE(all.equal(var(gv), var(gA) + var(gB))))` for gv = X %*% beta, plus `max(abs(gv - (rep(a_i, times = nB) + rep(b_j, each = nA)))) < 1e-10`, and print the deviations. Reference: SCA 1.1e-14, var(gv) = var(gA) + var(gB) = 22.48375, gv reconstruction 1.2e-14.

H6 (M7, R7). Read from code rather than typing: top 60 (`n_sel`), 625 (`N`), "25 + 25 lines", 2000 markers, 300 QTL, h^2, fst, 4000 samples, 30 seeds, "seeds 1 to 30", and the Smith-Hazel caption's matrix entries (via `!expr` in captions). Prose lines can use `r n_sel`, `r nrow(rep_seeds)`; "25 + 25 founder lines" appears in the new text of D2 (:221-235) and in the tbl-response-genic caption.

H7 (M10, C17, R13). Assert (with printed deviation) that `genic_var(X, sim$beta)` equals `N/(N-1) * sum(sim$beta^2 * (pA*(1-pA) + pB*(1-pB))/4)` (verified 25.2051 both ways; the factor is cited in the text only as N/(N-1)). Also assert the two special cases stated in the text after eq-response-hybrid-var: for beta = 1 at all loci, `sum(v_pop) == m * GD_WS / 4` with `GD_WS = mean(pA*(1-pA) + pB*(1-pB))` (147.248 both ways), and `GD_T = GD_WS + GD_BS` with `GD_T = mean(2*pH*(1-pH))`, `GD_BS = mean((pA-pB)^2/2)` (0.32809 = 0.29450 + 0.03360).

H8 (M13, R8). The `stopifnot(abs(mean(rel_gap)) < 2 * gap_se)` is an assertion of the chapter's own claim and, by the audit's 20 disjoint blocks, fails in about 1 of 20 blocks for a changed seed set (19 of 20 pass; my seeds 31-230 give mean 0.0101, s.e. 0.0067). Either keep it with a comment stating that false-alarm rate, or replace it by a printed statement. The text now says what 30 seeds resolve (2 s.e.).

Also: run `Rscript book/scripts/make_downloads.R` after the chunk edits (not run here: it regenerates every script, and the chunks are about to change).

## Left open

- Kempthorne & Nordskog 1959 (and Smith 1936, Hazel 1943, Bulmer 1971, Sprague & Tatum 1942, Meuwissen 1997, Falconer & Mackay chapter locators) remain unread. The text now says so wherever each is cited and attributes nothing to them beyond what is reported. This is not a settled attribution; it needs either a copy of K&N 1959 or the present hedged wording to stay.
- The claim of what the book adds beyond Meuwissen 1997/2020 (budget against random subsets, hybrids of two pools) is referred to @sec-baseline and @sec-ocs and not checked against the wider literature.
- Quarto cross-reference resolution (new `@eq-g05`, `@eq-hp-gca-sca`, `@eq-hp-gd`, `@tbl-keystone`, `@sec-coancestry`, `@sec-hybrid-programme`, `@sec-baseline`), the Typst PDF and `docs/` wait for the batch render. All targets were checked to exist in source.
- Falconer & Mackay locator for the accuracy form i r sigma_A: unverified in either direction.

---

# quant-Rwrite pass (chunks and assertions, iteration 1)

Files changed: `book/02b-response.qmd` (chunks and the inline prose that reads them), `book/downloads/02b-response.R` and the other downloads (`make_downloads.R`; 00, 01, 02 refreshed by it, no further source change). `R/` not touched by this pass (the worktree's uncommitted `R/00_data.R`, `R/01_metrics.R` edits predate it); so no `document()`, `test()`, `install()` run. Knit (`knitr::knit` and `purl`, `_common.R` forced onto `pkgload::load_all` of the worktree, `error = FALSE`): 3.3 s, every `stopifnot()` passes, no warning. Quarto resolution of `tbl-cap: !expr` with `@tbl-`/`@eq-` references inside the caption string was NOT rendered (no render allowed): same mechanism as `fig-cap: !expr` in 04b, unverified for tables.

Conventions now in the setup chunk: `cfg` (every configuration number), `tol_exact = 1e-12` with `dev_rel(x, y) = max|x - y| / max(1, max|y|)` (1e-12 = double precision times ~1e3 summed terms; chosen before the run, tighter than the former `all.equal` default 1.5e-8; achieved deviations all <= 1.1e-14), `n_blk`. Every asserted identity prints its deviation inline through `fmt_sci()`.

| ID | Status | Evidence (measured on this run) |
|---|---|---|
| H1 / D2 (chunks) | fixed | New chunk `response-cov-term`: factorial identity `cov(X)(N-1)/N == (popcov(U) + popcov(V))/4`, deviation 1.5e-15; term over seeds 1-30: mean -0.138, s.e. 0.835, negative in 18 of 30; over disjoint seeds 31-230: mean -0.212, s.e. 0.326, z = -0.65 (asserted |z| < 3, false alarm 0.3 percent per seed set, computed with `pt`); share of genic variance mean -0.009, s.d. 0.205; seed-1 share -0.108 = 0.53 s.d. from zero. Seed 1 of the 230-seed table equals the table value (asserted). All inline. |
| H2 / M5 / C16 / R5 | fixed | Deviations printed with `fmt_sci()` for: `response-identity` (1: exactly 0; 2: 1.1e-16), `tbl-response-genic` (covariance term vs off-diagonal sum 1.4e-14; `genic_var` vs `ref_genic_var` 4.2e-16; the row that printed 0.0000 is removed from the table), `response-hybrid-var` (no longer `results: hide`; 1.8e-16, 1.8e-16), GCA/SCA chunk (no longer hidden: reconstruction 2.2e-15, variance additivity 2.4e-15, max |correlation| between components 3.1e-17), `response-sh-proportional` (2.2e-16, 2.2e-16, 1.1e-16), restricted index (2.6e-17). The cov < 1e-10 test is now a scale-free correlation test at 1e-12. Tolerance stated in the setup comment and each paragraph. |
| H3 / M6 | fixed | "Two identities": (1) `b S_I = i_real r sigma_A`; (2) realised minus regression response = mean regression residual over the selected set (residual has mean zero over candidates). Both asserted; mean residual -0.546 shown as the part of the gap that is not an intensity effect. |
| H4 / D5 (chunk) | fixed | Column "expected gain in moisture per round" = `i_norm * R'Sigma_G b / sqrt(b'Pb)`, `i_norm = sel_intensity(60/625)` taken from the existing object; Smith-Hazel 0.2195, restricted 4.4e-17 (asserted `< tol_exact`, covariance 2.6e-17, Smith-Hazel gain > 0). Extra literal oracle: Monte Carlo selection, 4e5 draws from the two covariance matrices, top 60/625 on each index, asserted within 4 s.e. (false alarm 6e-5): Smith-Hazel 0.217 (s.e. 0.003) vs 0.2195; restricted -0.002 (s.e. 0.003) vs 0. |
| H5 / D6 / R3 (chunk) | fixed | New chunk `response-gca-additive` on the factorial table of `gv` (row/column means; `heterosis_gca_sca` is the dominance split and cannot be used with d = 0, it returns zeros): gv_ij = a_i + b_j 7.8e-16; GCAs = centred a_i, b_j 5.9e-16; largest SCA 1.1e-14; var(gv) = var(GCA_A) + var(GCA_B) 7.9e-16 (22.4837 both sides); GCA of pool-A lines against a 5-line tester set equals that against all 25: 4.9e-16 (tests "does not depend on the tester set"). |
| H6 / M7 / R7 | fixed | 60, 625, 25 + 25, 2000, 300, h^2, fst, 30, 4000, seed numbers, d mean/s.d./seed, 200-seed block and the Smith-Hazel matrix entries in captions and prose now come from `cfg`/`book_cfg`/`P`/`G` (`!expr` captions built with `sprintf`; 7 caption objects). Left typed on purpose: the 0.5 in the demonstration `Sigma_G = 0.5 Sigma_P`, "seed 4" of 05b, and the `N(0,1)` effect law (a property of `simulate_pools()`). |
| H7 / M10 / C17 / R13 | fixed | `genic_var(X, beta) == N/(N-1) sum beta^2 (pA qA + pB qB)/4` 5.6e-16 (25.1648 population scale, 25.2051 from `genic_var()`, ratio 1.0016 = N/(N-1) printed); equal effects `sum(v_pop) = m GD_WS/4` 2.5e-15; `GD_T = GD_WS + GD_BS` 5.6e-17; mixture-base limit pA = pB, `sum(pbar qbar/2) = m GD_T/4` 3.1e-15. |
| H8 / M13 / R8 | fixed | Assertion kept, with its error rates computed in chunk `response-gap-error-rates`: false alarm `2 pt(-2, 29)` = 5.5 percent (about 1 in 18; asserted equal to the noncentral-t evaluation at delta = 0); the assertion fails with power 0.8 only at a true mean gap of 0.046 (4.6 percent of predicted response, per-seed s.d. 0.088), so a pass excludes biases of about that size and above only. Offline check (not in the chapter), 900 seeds as 30 disjoint blocks of 30: rule failed in 2 of 30 blocks (6.7 percent vs 5.5 expected); mean gap over 900 seeds 0.0069, s.e. 0.0031, s.d. 0.093. The same 900-seed run gives z of 4 disjoint 200-seed blocks of the covariance term -0.65, 0.05, 1.09, -0.70 (all inside the asserted 3). |
| M6, D5, D6, M10 chunk halves | fixed | See rows above. |

Not done / left to others: `R/15_response.R` header (lines 11-13) and the `genic_var()`/`index_*` roxygen still call `index_restricted()` "the classical ancestor of this book's alpha constraint (Kempthorne & Nordskog 1959)" -- the wording the chapter withdrew under D1; R/ not edited here (needs a deliberate `document()`/test pass). Owed items to 09, 04c, 11c, 04d, 11b, 08, 08b are unchanged from the table above.
