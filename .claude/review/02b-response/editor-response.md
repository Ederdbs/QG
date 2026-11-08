# Editor response: R/ and man/ items (02b)

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05, branch review-01-05. Not committed. book/ untouched by this item.

| ID | Status | Evidence |
|---|---|---|
| 02b-R15 | fixed | `R/15_response.R:11-16` (header) and `:88-105` (`index_restricted` roxygen): removed "classical ancestor of this book's alpha constraint", "the same distinction K&N drew in 1959", "the only novelty here ...", and the unqualified "R'Gb = 0 exactly". Now says: Kempthorne & Nordskog (1959) is the reference the book cites for restricted indices, was not read, the matrix form is the book's own; `R'Gb = 0` by direct substitution is zero EXPECTED gain, not a property of a realised selected set; Meuwissen et al. (1997, 2020) are the lineage for constraining a group coancestry. `devtools::document()` regenerated `man/index_restricted.Rd`; `devtools::test()`: FAIL 0 / WARN 0 / SKIP 0 / PASS 492; `devtools::install()` done. R/15 is ASCII (grep for non-ASCII empty). |

## Same withdrawn phrasing elsewhere (not edited, outside scope)

- `book/04c-alphasimr-pipeline.qmd:1242`: "as @sec-response argues, the classical ancestor of this book's alpha constraint" (already tracked as ADDED owed row).
- `book/index.qmd:98-99`: "restricting rather than pricing ... is a sixty-year-old theorem rather than a preference (@sec-response)" -- same claim 02b withdrew.
- `book/09-optimal-contributions.qmd:48,70`: "posed the identical problem", "Kempthorne and Nordskog restricted a trait" (owed row 09).
- `book/04c-alphasimr-pipeline.qmd:1239`: "holds trait 2 at exactly zero" (expected-versus-realised; check against what 04c measures).
- Test titles only (not claims in prose): `tests/testthat/test-response.R:56` and the echo of it at `book/92-verification.qmd:113` say "moves the restricted trait exactly zero"; the test asserts the model expectation `R'Gb` to tolerance, so the title is accurate only in that sense.
- No other hit in R/ or man/.

# Editor response: form and small content findings (02b, step 5)

Edits in book/02b-response.qmd and book/index.qmd only; no chunk, number, equation or claim changed. The chapter was knitted end to end (inline expressions included) against pkgload::load_all in a temp dir: no error, assertions pass.

| ID | Status | Evidence |
|---|---|---|
| 02b-E1 | fixed | The hanging "And -- more seriously --" now ends before the callout: "... no frequency-based metric sees the covariance term, as the next box sets out." |
| 02b-E2 | contested | The Preface is `# Preface {.unnumbered}` (index.qmd:1); other chapters point to it in prose (00:8, 00:188, 04b:874). An @sec- to an unnumbered heading was not rendered here (no full render allowed), so its output is unverified. The pointer is now the specific "item 3 of the Preface" (2 places), as 04b:874 does ("item 5 of the Preface's chain"). Reopen only if a render of `{#sec-preface}` is checked. |
| 02b-E3 | fixed | "(see "What response means" above)" -> "(see the definition of response before @tbl-response-breeders)". |
| 02b-E4 | owed -> 90 | Symbols missing from the "Response to selection" table of 90-notation.qmd: i_real, e, ebar_sel, a_i, b_j (collide with b index weights and a economic weights), K, gbar, y, e. |
| 02b-E5 | owed -> quant-Rwrite | Transposing or splitting tbl-response-breeders, -gap, -restricted needs a change to the data.frame/fmt() code in the chunk (t() or two fmt() calls plus a caption split): not done here. Proposal: breeders and restricted as quantity x value, gap as two blocks (intensity, response). |
| 02b-E6 | not done (optional) | A labelled identity/deviation table would need a new chunk collecting the dev values; the deviations stay inline. |
| 02b-E7 | fixed | The two "the preface" pointers now read "item 3 of the Preface"; ":94 later chapters ... (@sec-stages)" already carries a reference and was left. |
| 02b-E8 | fixed | index.qmd:97-99, item 3. Before: "That restricting rather than pricing is the right form for such a constraint is a sixty-year-old theorem rather than a preference (@sec-response)." After: "Restricting rather than pricing is not specific to this book: restricted selection indices and optimum contribution selection with a bound on a group coancestry both have that form (@sec-response), which is a precedent for the constraint, not a proof that it is the right one." (follows 02b's callout "What the lineage does and does not show"; no priority claim). |
| 02b-E8 (other places) | owed -> 04c | 04c:1239 and :1242 ("holds trait 2 at exactly zero"; "classical ancestor of this book's alpha constraint"). |
| 02b-E8 (other places) | owed -> 09 | 09:48 and :70 ("posed the identical problem"; "Kempthorne and Nordskog restricted a trait"). |
| 02b-E9 | fixed | The parenthesis on the missing locator is now a footnote ("No chapter locator is given: the book was not available to check one."), per the style guide (footnotes for provenance); the accuracy-form sentence stays in the text. |
| 02b-E10 | left to quant-Rwrite | Chunks untouched. |
| 02b-M15 | fixed | "average effect ... is beta_k" replaced by: the effect on the hybrid value of substituting one allele at locus k is beta_k/2 whatever the pool, because one parental allele moves x_k in {0, 1/2, 1} by 1/2; this is the factor already used in the next line (a_i = sum beta_k u_ik / 2, asserted in the chunk). No number changed. |
| 02b-M16 | fixed | Added after "not a proof that the gap is zero": 0.046 is the power size (true mean gap flagged with probability 0.8), 0.032 is two standard errors of the observed mean gap; in a normal approximation the first is the threshold plus qnorm(0.8) = 0.84 s.e., 1.42 times the second, and the non-central t computation gives 1.43. All values are inline from delta80, gap_se. |

# Editor response: code-side form findings (02b, step 5, quant-Rwrite)

Display code only in book/02b-response.qmd; no analysis line, stopifnot or number changed. Chapter knitted before and after against load_all (scratch dir): no error, assertions pass, every printed value identical (diff shows only the reshaped layout).

| ID | Status | Evidence |
|---|---|---|
| 02b-E5 (tbl-response-breeders) | fixed | 5 numeric columns -> `quantity` x `value` (5 rows). Same 5 values (1.774, 0.702, 4.742, 5.908, 5.116). Label, caption, @tbl- citations unchanged. |
| 02b-E5 (tbl-response-restricted) | fixed | 4 numeric columns + index -> `quantity` x (`Smith-Hazel`, `restricted`), 4 rows (weight yield, weight moisture, covariance, expected gain). Same 8 values at 4 digits. Caption: "Covariance column" -> "Covariance row", "Last column" -> "Last row". |
| 02b-E5 (tbl-response-gap) | contested (variant) | Not split in two blocks: the label tbl-response-gap and the single caption/@tbl- citations must stay, and Quarto cannot carry two blocks under one label without subtables. Transposed to `quantity` x `value` (6 rows) in the original order (intensities, responses, skewness), same as the other two tables; the caption's two groups ("Intensities: ... Responses: ...") still read in that order. Caption: "Last column: skewness" -> "Last row: skewness". Values identical (1.774, 1.701, 5.662, 5.662, 5.116, -0.170). |
| 02b-E10 | fixed | `sim` chunk (analysis, now `#| label: sim`) separated from the display chunk `tbl-response-data` (only the data.frame). Output identical. |

Not rendered (no render allowed): Typst fit of the three tables is by construction (2-3 columns), unchecked by a PDF. book/downloads/02b-response.R regenerated with make_downloads.R. No book/Rplots.pdf.
