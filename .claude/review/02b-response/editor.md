# 02b-response -- editor report (form review, step 5)

File: book/02b-response.qmd (worktree review-01-05). No figure chunks, no static images, no footnotes, no callout-caution. All 6 displayed equations carry #eq- labels and are cited; all tables carry tbl- label and tbl-cap. book/Rplots.pdf: absent, nothing to delete. R/ and man/ not touched. book/typst-style.typ not touched. No full render; the chapter's code was purled and sourced end to end (no error, assertions pass, all tables print as intended).

## Cross-references inside evaluated captions (`tbl-cap: !expr`)

Tested in a scratch project (scratchpad, not docs/): a two-table qmd with `tbl-cap: !expr cap` where `cap` is built by sprintf() in an `include: false` chunk and contains @eq-, @tbl- and @sec- references, math ($\sigma_A$) and backticks. Quarto 1.10.18, both formats:
- HTML: the references resolve (`<a href="#eq-one" class="quarto-xref">Equation 1</a>`, Table 1, Table 2).
- Typst: the references resolve (`#ref(<eq-one>, supplement: [Equation])`); the document compiles to PDF; inline code in the caption becomes `#NormalTok(...)`, defined by Quarto.
Conclusion: the 02b captions cap_breeders, cap_gap, cap_rep, cap_genic, cap_gca, cap_sh, cap_restr (and the new cap_data) are safe. The first Typst attempt failed only because the scratch file had a heading ref without heading numbering (the book has number-sections). Residual risk: a referenced label that does not exist would not be caught at purl time; all labels cited from the captions were checked and exist.

## (a) Mechanical fixes applied

Tables
- Raw console vector `c(hybrids, markers, qtl)` (end of the `sim` chunk) -> labelled table `tbl-response-data` (new `include: false` chunk with `cap_data` built from `book_cfg`/`cfg`, same pattern as the other captions; data.frame of quantity/count; the three analysis lines of the chunk untouched). Cited with @tbl-response-data in the preceding paragraph, before the chunk.
- `tbl-response-gca-sca`: header carried no unit; column renamed `variance (sim. units squared)` (check.names = FALSE) and `row.names = NULL` added (kable otherwise prints the names gca_A/gca_B/sca twice, as row names and as the component column). Caption: "Variance in simulation units; share of the sum" -> "Variance in squared simulation units; share: fraction of the summed variance".
- Caption/cell numbers unchanged; every table already goes through fmt().

Callouts
- `callout-important` "What the lineage does and does not show" -> `callout-note`: it is a clarification of what the cited lineage does and does not license, not a design decision of the book or the package. The `callout-warning` (frequency-based metrics cannot see the covariance term) is a trap and stays.

Cross-references and structure
- Heading id added: `## Genic variance, ... {#sec-response-genic}`.
- "The section on genic variance below carries both" -> "@sec-response-genic carries both".
- "that the section on genic variance showed" (item 3 of the four differences) -> "@sec-response-genic".
- "The check below therefore asks one thing" -> "The comparison of @tbl-response-breeders therefore asks one thing".
- "@sec-heterosis-gca-sca, in the next chapter." -> "@sec-heterosis-gca-sca."
- "The next chapter, @sec-heterosis, completes the Foundations part" -> "@sec-heterosis completes the Foundations part".

Text
- Acronyms: "quantitative trait loci" -> "quantitative trait loci (QTL)" at first use in the prose (QTL first appears in the setup caption string, after this definition in reading order); "names $GD_{BI}$" -> "names the component $GD_{BI}$ of gene diversity ($GD$)" (GD was used undefined in the opening paragraph); "The GCA/SCA model of @eq-hp-gca-sca" -> "The model of @eq-hp-gca-sca" (GCA/SCA was used one clause before its expansion).
- Citation syntax: sentence-initial "[@bulmer1971] is the reference for" -> narrative "@bulmer1971 is the reference for".

Totals: 1 console vector -> labelled table (+1 new cap chunk, +1 citation sentence), 2 header/caption touch-ups on one table, 1 callout type, 1 heading id, 6 reference replacements, 3 acronym expansions, 1 citation fix.

Prose or caption wording changed: yes, mechanically only. Prose: the reference/acronym replacements above and one added sentence ("@tbl-response-data gives the size of the draw used in the rest of the chapter."). Captions: new cap_data (written from the code); two words in cap_gca ("squared", "share: fraction of the summed variance"). No number, claim, equation or analysis code changed. The `sim` chunk's final line (display only) was replaced by the data.frame.

## (b) Findings for quant-writer (wording / notation / placement)

- 02b-E1 -- :480-483 -- Sentence left hanging across a callout: "And -- more seriously --" ends the paragraph and the callout-warning begins with a new sentence. Either finish the sentence before the callout ("... the proxy cannot see the covariance term, set out next.") or open the callout title as the completion. I did not touch it (content of the claim).
- 02b-E2 -- :33 -- "the preface's third item" is a prose pointer to index.qmd:85-99; the Preface has no section id, so it cannot be an @sec-. Needs `{#sec-preface}` on index.qmd's heading (outside this chapter) and then "@sec-preface (item 3)". Reported, not applied.
- 02b-E3 -- :280 -- "(see "What response means" above)" points to a bold run-in paragraph, not a heading; cannot be an @sec-. Either promote it to a `###` with an id, or replace by an @tbl-/@sec- anchor.
- 02b-E4 -- 90-notation.qmd, "Response to selection" table (:494-530) -- symbols used in this chapter and absent from it: $i_{\text{real}}$ (realised intensity), $e$ and $\bar e_{\text{sel}}$ (regression residual), $a_i$, $b_j$ (additive parental values; $b_j$ and $a_i$ share letters with the listed $\mathbf{b}$ index weights and $\mathbf{a}$ economic weights, within the same chapter), $K$ and $\bar g$ (group coancestry and genetic level in the OCS lineage paragraph), $\mathbf{y}$, $\mathbf{e}$ (records, residuals; $\mathbf{y}$ appears only inside the $\boldsymbol\xi$ entry). Add or declare local.
- 02b-E5 -- :129-132, :143-153, :788-797 (`tbl-response-breeders`, `tbl-response-gap`, `tbl-response-restricted`) -- wide tables: 5, 6 and 5 numeric columns with headers of 30-50 characters each. At Typst A4 width (6.5 in) the headers will wrap to 3-4 lines. Proposal: transpose to quantity x value (breeders, restricted), or split `tbl-response-gap` into an intensity block and a response block. Not applied (changes the table; interacts with 00-E8 cell justification).
- 02b-E6 -- :154-177, :244-252, :349-355, :425-439, :540-556, :583-600, :690-714 -- the chapter reports roughly a dozen exact-identity deviations as inline `fmt_sci()` numbers scattered across paragraphs ("Deviations: ... , ..."). They are readable but cannot be cited. If the writer wants them citeable, one labelled table "identity / achieved deviation" would serve; optional.
- 02b-E7 -- :270-277 and :296-304 -- "the preface", "later chapters" (:94) are loose pointers; :94 "later chapters use it ... (@sec-stages)" is acceptable since it carries references.
- 02b-E8 -- index.qmd:97-99 (outside this chapter) -- still reads "a sixty-year-old theorem rather than a preference (@sec-response)", the claim 02b's lineage rewrite withdrew (see it2-verdict, Rulings 6 and Owed). Content, not form; passed on so it is not lost.
- 02b-E9 -- :90 (parenthesis "The book was not available to check chapter locators, so none is given") -- authorial provenance note inside the argument; under the style guide provenance belongs in a footnote, never in the argument. Consider moving it to a footnote or deleting it. Not applied (wording).

## (c) Findings for quant-Rwrite (code)

- 02b-E10 -- The `tbl-response-data` display code (data.frame at the end of the `sim` chunk) follows the 01/02 precedent of display code inside an analysis chunk. If quant-Rwrite prefers it separate, the three-line `sim` chunk can be split with no change in output.
- No other code finding. The chapter source runs cleanly; the setup, assertions and tolerances are untouched.

## (d) Figures/files the render at close may orphan

- No figures in this chapter: docs/02b-response_files/ does not exist and book/_freeze/02b-response/ holds only execute-results/html.json and typ.json. Nothing is orphaned by figure renames.
- The chunk `sim` was unlabelled and is now `tbl-response-data`, and a new unlabelled-by-number `cap_data` chunk was added: the chapter's freeze entries (html.json, typ.json) are stale and regenerate at render (replaced in place).
- book/downloads/02b-response.R must be regenerated with `Rscript book/scripts/make_downloads.R` (it still carries the unlabelled `sim` chunk and the old console print); I did not run it.
- Sweep macOS " N" duplicate files after the final render per CLAUDE.md.
- Scratch cross-reference test left only in the session scratchpad (capx/), nowhere in the repo.
