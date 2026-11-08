# Editor report: book/01-coancestry.qmd (form review, content APPROVED)

Scope checked: figures (none in chapter), 1 table, 7 labelled equations, 1 callout, cross-references (all @sec-/@eq- targets and all 10 bib keys resolve), citation syntax, headings, acronyms, notation vs 90-notation.qmd. No book/Rplots.pdf exists (nothing to delete). No R code or number touched.

## (a) Mechanical fixes applied (1)
1. Acronyms, line 374: "few genotyped SNPs" -> "few genotyped single-nucleotide polymorphisms (SNPs)" (SNP was never defined in the chapter; first use). Only prose wording changed, an acronym expansion.

Verified, no change needed: tbl-matrix-roles has label + tbl-cap and is cited (line 462) before it appears; eq-hybrid-dosage, eq-x-freq, eq-vanraden-g, eq-g-sum-zero, eq-f-molecular, eq-f-matrix, eq-g05 are labelled and cited with @eq-; the single callout (callout-warning, titled) is the right type (a trap that yields a wrong number); headings are sentence case; citations are Quarto syntax throughout (no hand-typed Author, Year); no footnotes; no callout-caution.

## (b) E findings for quant-writer (prose/caption wording)
- 01-E1 (line 222): "as the next paragraph states" is a positional reference. Replace by a named pointer (e.g. "as the paragraph 'What the scale of f is' below states", or fold the pointer into a label), or by a @sec- if that paragraph is promoted to a subsection with `{#sec-f-scale}`. Same family, lower priority, acceptable because they point at chunk output in the same section: "the chunk below checks" (l.217), "printed below" (l.236, l.407).
- 01-E2 (line 73, eq-vanraden-g/eq-g-sum-zero): $\mathbf{1}$ (vector of ones) is used in eq-vanraden-g's preamble (l.73) and eq-g-sum-zero (l.94-97) but only defined after eq-f-matrix (l.260). Define it at first use. Checklist section 3: every symbol defined at or just after its first equation.
- 01-E3 (lines 26, 37, 57): $m$ (number of markers) is never stated as such at its first use ("$L \times m$"), and $\mathbf{M}^{H}$ is introduced inside eq-hybrid-dosage without a sentence naming it the hybrid dosage matrix (the sentence at l.31-35 describes it only implicitly). Both are in 90-notation; add the words at first use.
- 01-E4 (symbols absent from 90-notation.qmd, to report per checklist): $\overline{G}_{ii}$ (mean diagonal of G, l.150), $\mathbf{1}_S$ (indicator vector of S, l.145), $p_{b,k}$, $q_{b,k}$ (base-population frequencies, l.233-234, 416), $\bar f^{L}_{AB}$ (l.341). Either add a row to the notation tables or rename to existing symbols ($p_{0,k}$ is the frozen base; confirm whether $p_{b,k}$ is meant to be distinct). Also $GD_S$ (l.11) appears only as $GD$ in the notation table.
- 01-E5 (lines 224-241, 243, 313): three bold run-in / ### sub-heads ("What the scale of f is", "A limit of constraining this matrix", "Computable form", "Reading the diagonal") are mixed levels of structure. Not an error, but "What the scale of f is" and "A limit of constraining this matrix" are cited conceptually in prose; if @sec- references to them are wanted, promote to ### headings with ids. Optional.

## (c) E findings for quant-Rwrite (code)
- 01-E6 (lines 115-119, 138, 175, 272-275, 301-304, 322-325, 333, 431): raw R console output (named numeric vectors, `range()`) stands in for results. Checklist section 2 asks for a numbered table, not console output. Candidates: a single labelled table `tbl-g-vs-f-sums` for l.115-119 and l.138 (G-based vs f-based quantities), one for l.272-275 + l.301-304 (f summary and panel floor), one for l.322-333 (diagonal/heterozygous fraction). I did not convert them (chunk code change, and some values are meant to sit next to the stopifnot checks). `args(vanraden_G)` (l.87) and `cat(deparse(molecular_coancestry))` (l.267) are code listings and can stay as they are.

## (d) Figures the render at close may orphan
- None. The chapter has no plot chunks and no static images. `docs/01-coancestry_files/` does not exist in this worktree; `book/_freeze/01-coancestry/` holds only `execute-results/`. The edit adds no chunk and renames no label, so no PNG is created or orphaned.

## Counts
Mechanical fixes applied: 1. E findings: 6 (writer 5: 01-E1 to 01-E5; Rwrite 1: 01-E6). Prose wording changed: yes, once (acronym expansion at l.374). Caption wording changed: no. No number, code or science changed.
