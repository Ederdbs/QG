# Verdict: book/02b-response.qmd (iteration 3)

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05, branch review-01-05. Lines are of the edited `book/02b-response.qmd` unless a path is given. Scope: what changed after the iteration-2 APPROVED (editor.md / editor-response.md items, 02b-M15, 02b-M16, the three reshaped tables, the callout type, the footnote, E2/E5/E6, index.qmd item 3, 02b-R15). Read: the whole chapter as it stands (920 lines), it2-verdict.md, editor.md, editor-response.md, the diffs of book/index.qmd, R/15_response.R and man/index_restricted.Rd, 02:1101-1110, 04c:1237-1244, 09:46-72.

VERDICT: APPROVED

Counts: new disqualifying 0; new non-disqualifying 2 (M17, M18), below the threshold of three; iteration-2 IDs unchanged (all CLOSED; M15 and M16 closed below).

## PREVIOUS IDS

- 02b-M15 -- CLOSED -- Lines 529-536: the effect on the hybrid value of substituting one allele at locus k is beta_k/2 (one parental allele moves x_k in {0, 1/2, 1} by 1/2). Correct for d_k = 0 and 0/0.5/1 coding. It is the factor of the next line, a_i = sum beta_k u_ik / 2, b_j likewise, and of the chunk `response-gca-additive` (`a_i <- drop(U %*% sim$beta) / 2`); the chunk's assertion `dev_a_b = dev_rel(GV, outer(a_i, b_j, "+"))` and the other four deviations (`dev_gca`, `dev_sca0`, `dev_vadd`, `dev_tstr`) pass in my knit (stopifnot did not fire). The word "average effect" is gone; no residual scale error.
- 02b-M16 -- CLOSED -- Lines 279-287. Recomputed: normal approximation (2 + qnorm(0.8))/2 = 1.4208, printed 1.42; non-central t, 80 percent power, n = 30: delta80/(2 s/sqrt(n)) = 1.4263 for any s (independent uniroot, s = 1), printed 1.43 in the knit (0.046 and 0.032 are the rounded values: 0.046/0.032 = 1.44 only by rounding, the text does not use that quotient). The text says the two sizes are a power and a threshold, not two bounds. The statement is correct.
- All other iteration-2 IDs (D1-D7, M1-M14) -- remain CLOSED; nothing in this diff touches their content (analysis chunks unchanged, see WHAT WAS VERIFIED).

## DISQUALIFYING FAILURES

None.

## NON-DISQUALIFYING OBSERVATIONS

- 02b-M17 R/15_response.R example (roxygen `@examples`, carried to man/index_restricted.Rd:44) -- the comment `# zero: trait 2 does not move` states the restricted result as a realised property, two lines below the new text that says it is an expectation under the model and not a property of a realised selected set. The code printed (R'Gb) is the covariance, 0 in my run. Same expected-versus-realised wording survives in the test title tests/testthat/test-response.R:56 and its echo at book/92-verification.qmd:113 ("moves the restricted trait exactly zero"), which the editor-response already lists. Not in the lines changed by this diff, so not blocking; owed to 91-package (R/ and man/) and 92 (verification), named below.
- 02b-M18 book/index.qmd:97-101 -- item 3 now says "restricted selection indices ... have that form" without the 02b qualifier that the restricted-index reference (Kempthorne & Nordskog 1959) was not read. The statement is a description of the method, not a priority or a result, and the cited section carries the qualifier; no unsupported claim is added. Recorded as a loss of the "reported, not read" status in the Preface only.

## RULINGS

- E2 (Preface pointer by prose) -- ACCEPTED, contested closed. There is no `{#sec-preface}` label in the book (grep over book/*.qmd finds none), so an @sec- cross-reference would be unresolved; the specific prose pointer "item 3 of the Preface" (lines 23-24, 873) matches index.qmd item 3 in content (within-pool diversity is what protects response, between-pool part does not enter). 04b:874 uses the same convention. Nothing in the claim depends on the form of the pointer.
- E5 (tables reshaped) -- tbl-response-breeders and tbl-response-restricted fixed (quantity x value, quantity x Smith-Hazel/restricted); captions now say "Covariance row" and "Last row", which match the rows (rows 3 and 4). tbl-response-gap: the variant (transposed to quantity x value, six rows in the original order, not split in two blocks) is ACCEPTED. The caption's two groups (intensities, responses) and "Last row: skewness" match the row order; units of the response rows are in the row labels; the dimensionless intensity and skewness rows are not distinguished in the value column, a form point for quant-editor, not a content defect. No text of the chapter still speaks of a "column" of these tables (grep).
- E6 (labelled identity/deviation table) -- ACCEPTED as not done. The deviations are printed inline from the assertions that produce them; the optional table would change layout, not content. Criterion 3/5 are not affected.

## OTHER ITEMS OF THE DIFF

- Callout important -> note (line 880): the content is a qualified summary of the lineage; the type change adds no claim. The remaining `callout-warning` (line 496) is unchanged.
- Footnote on chapter locators (lines 92-93): "No chapter locator is given: the book was not available to check one." Honest and sufficient for criterion 7; the earlier ", ch. 11" locators are not in the text (lines 92, 189).
- E1/E3/E7 wording (lines 11-26, 111, 292, 493-494, 871-873): read; each pointer resolves to an existing label or heading (`sec-response-genic` is declared at line 298). The sentence at 23-26 matches 02:1101-1102 ("GD_BI is the raw material of the next cycle's response, which @sec-response makes precise").
- index.qmd item 3 (an earlier chapter, in scope): the new sentence makes no priority claim and no "theorem" claim; it says restricting rather than pricing is not specific to the book, names two instances, and says "a precedent for the constraint, not a proof that it is the right one", which is what 02b's callout (lines 883-890) says. The rest of item 3 (genic variance as a sum over loci of the within-pool part of gene diversity, weighted by squared effect; between-pool part does not enter; linkage disequilibrium not seen; only if effects unrelated to which loci lose diversity) is exactly 02b's eq-response-hybrid-var and the lines 470-472 condition, which the chunk `response-hybrid-var` asserts (deviations <= 1e-12 in my knit). Does not re-assert the withdrawn claim.
- 02b-R15 (R/15_response.R:11-16, 88-105; man/index_restricted.Rd) -- CLOSED as a blocking item. The text now says K&N 1959 is the reference the book cites, not read, the matrix form is the book's own; R'Gb = 0 by direct substitution is zero expected gain, not a property of a realised selected set; Meuwissen et al. (1997, 2020) are the lineage for constraining a group coancestry, "which the book implements", the restricted direction here is a trait combination. This is consistent with 02b lines 742-779 (book's own form, expectation caveat, Meuwissen 2020 read and 1997 reported through it). The sentence "which the book implements" is compatible with 02b's own reading (the molecular f group coancestry is an affine function of the G_0.5 group coancestry, 01 eq-g05) and claims no priority. Non-ASCII: `grep -nP '[^\x00-\x7F]'` on R/15_response.R and man/index_restricted.Rd returns nothing. The man page matches the roxygen (description/details split puts the equation under \details: form only). One residual, M17 above.
- Withdrawn phrasing elsewhere (recorded as owed, not defects of this chapter; present in the files as I read them): book/04c-alphasimr-pipeline.qmd:1239 ("holds trait 2 at exactly zero", expected-versus-realised; to be checked against what 04c measures) and :1242 ("as @sec-response argues, the classical ancestor of this book's alpha constraint", attributes to 02b what 02b withdrew); book/09-optimal-contributions.qmd:48 ("posed the identical problem", with :50 "@sec-response derives") and :70 ("Kempthorne and Nordskog restricted a trait"). They are listed in editor-response.md and (04c:1242, 09, index:98) in it2-verdict.md OWED. They are not yet in .claude/review/THREAD.md (grep finds no row for 02b in the owed-to-later-chapters list), so the controller must write them there at commit: owed -> 04c (1239, 1242), owed -> 09 (48/50/70), owed -> 91-package (R/15 example comment, man page) and 92-verification (:113 test title).

## OWED (named chapters; none is a 02b defect)

- 04c: 1239 and 1242 as above; r against breeding value versus 02b's r; the phenotypic-versus-predicted index distinction (from iteration 2).
- 09: 48, 50, 52-60 (matrix G not a covariance matrix), 67-78 (priority passage), as in iteration 2, plus 70.
- 11c, 04d, 11b/08/08b: as in it2-verdict.md OWED.
- 90-notation: i_real, e, ebar_sel, a_i, b_j (collides with index weights b and economic weights a), K, gbar, y, e (editor 02b-E4).
- 91-package / 92-verification: M17.
- Render batch: Typst fit of the three two-column tables and `tbl-cap: !expr` captions containing `@tbl-`/`@eq-`; footnote rendering in Typst; docs/ freshness.

## WHAT WAS VERIFIED

- Analysis unchanged: `knitr::purl` of the iteration-2 copy of the chapter (my scratchpad copy of the it2 chapter, 894 lines) and of the current chapter (920 lines), compared with `diff`. Differences are only: removed `c(hybrids=..., markers=..., qtl=...)` replaced by the new `tbl-response-data` data.frame; reshaped `fmt(data.frame(...))` for tbl-response-breeders, -gap, -restricted; the gca-sca table column header "variance (sim. units squared)" and `row.names = NULL`; caption strings ("Last row", "Covariance row", the gca-sca caption). No `stopifnot()` line, no analysis line, no constant differs.
- Knit of the current chapter against `pkgload::load_all` of the worktree (`knitr::knit`, exit 0, no error: every `stopifnot()` passes, including the gain oracle at 4 s.e.). Values identical to iteration 2: intensity 1.774, r 0.702, sd 4.742, predicted 5.908, realised 5.116; gap table 1.774, 1.701, 5.662, 5.662, 5.116, skewness -0.170; restricted table weights 0.6172/-0.1406 and 0.6538/-0.6538, covariance 0.143 and 0.0000, expected gain 0.2195 and 0.0000; gca-sca variances 9.064, 8.673, 20.376 and shares 0.238, 0.228, 0.535; false alarm 5.5 percent; delta80 0.046; 2 s.e. 0.032; identity deviation (1) exactly 0, (2) 1.1e-16.
- Ratio 1.42 / 1.43: (2 + qnorm(0.8))/2 = 1.4208; non-central t, uniroot of 1 - (pt(2, 29, ncp) - pt(-2, 29, ncp)) = 0.8, delta/(2/sqrt(30)) = 1.4263 (independent of s); knit prints 0.84, 1.42 and 1.43.
- book/downloads/02b-response.R contains the new chunks and the footnote/Preface wording (grep), i.e. it was regenerated after the last chapter edit.
- `devtools::test(filter = "response")`: FAIL 0, WARN 0, SKIP 0, PASS 57.
- `index_restricted(diag(c(4,1)), diag(c(2,0.5)), c(1,1), cbind(c(0,1)))`: R'Gb printed 0.
- No book/Rplots.pdf, no Rplots.pdf in the worktree; nothing tracked edited by me (the only file created is this report; scratch copies are in the session scratchpad).

## NOT VERIFIED

- Kempthorne & Nordskog (1959) content, Meuwissen (1997), Smith (1936), Hazel (1943), Bulmer (1971), Sprague & Tatum (1942), Falconer & Mackay (1996): not read; the chapter and R/15 declare so where they are cited and no conclusion rests on them (non-decisive, as in iteration 2).
- Rendered output (Quarto resolution of `tbl-cap: !expr` captions with cross-references, footnote, Typst PDF, docs/): no render in this pass; form, not content.
- 04c numbers (AlphaSimR/MaCS): not quoted by 02b, not re-run.
