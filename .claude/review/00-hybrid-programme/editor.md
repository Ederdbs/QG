# Form review: book/00-hybrid-programme.qmd (+ book/index.qmd, lines 165-205)

Scope: quant-full-review step 5, content approved. No number, chunk body or `#|`
line changed. Nothing committed. No book render run; see "Verification" for what
was and was not exercised.

## Known item: "Chapter 13.." in the caption of fig-hp-cycle (00-E1)

The caption is not at fault (`00-hybrid-programme.qmd:223` has one stop). The stray
stop is produced by the reference itself, and it is book-wide.

- Cause: the orange-book template numbers level-1 headings with a trailing stop,
  pattern `"1."` (`lib.typ` lines 411-415) and `"A.1" + "."` for appendices
  (lines 129-133). A Typst `#ref` prints that pattern whole, so every chapter or
  appendix reference prints as `Chapter 13.`. Level-2 references (`1.1`) are clean.
- Extent in the published PDF (built 2026-11-01): 38 lines with a doubled stop, in
  prose, captions and the notation appendix. Mid-sentence references carry the
  stray stop too (`Chapter 19., and`, `Chapter 18. and Chapter 19..`).
  Reproduced in a two-chapter book.
- HTML is not affected. Removing the stop from the caption would be wrong: it fixes
  one symptom and leaves the sentence unterminated in HTML.

Tested fix, NOT applied: it belongs in `book/typst-style.typ`, a shared file that
changes all 450 pages, and the brief was to check the cause. Decision for the
caller. Append:

```typst
// orange-book numbers chapters "1." (appendices "A."), and a reference prints
// that pattern whole, so `@sec-x.` came out as "Chapter 13..". Print the number
// without its trailing stop; the heading and the outline keep theirs.
#show ref: it => {
  let el = it.element
  if el != none and el.func() == heading and el.level == 1 and el.numbering != none {
    let n = numbering(el.numbering, ..counter(heading).at(el.location()))
    let s = if it.supplement == auto { el.supplement } else { it.supplement }
    link(el.location(), [#s #n.trim(".", at: end)])
  } else { it }
}
```

Test result (minimal book, Quarto 1.10.18, Typst 0.15.1, the book's own header
files): `See Chapter 2. Then Chapter 2, and Section 1.1 and Appendix A. Also
Section A.1, Figure 1.1, Equation (1.1)`, also correct inside a figure caption and a
table cell. Headings, outline and citations unchanged. The `it.supplement` line is
needed: using the heading's supplement printed `Chapter A`. Not yet run on the
full book.

## (a) Mechanical fixes applied: 13

### Checklist 2, tables (Typst layout)
1. `00:179-180` `tbl-hp-stages`: column spec `|:--|:---------|:------------|`.
2. `00:738-739` `tbl-hp-reading-map`: column spec `|:-----------|:-----|:---------|`.
   Both were equal thirds, centred, which broke references across lines
   (`Chap-ter 12.`) in the narrow last column. Now left-aligned and proportioned.
   Layout checked on the real rows in a scratch build.

### Checklist 5, cross-references replacing positional wording
3. `00:39` "example below" -> "example of @sec-hp-cycle".
4. `00:196` "read in cross, as above" -> "read in cross (@eq-hp-gca-sca)".
5. `00:388` "defined below" -> "defined in @sec-hp-ibd"; id added to the heading at `00:448`.
6. `00:528` "of the next subsection" -> "of @sec-hp-inbreeding"; id added to the heading at `00:534`.
7. `00:128` "The chunk below takes" -> "The chunk takes" (chunks have no reference
   target; matches "The chunk checks" and "The chunk simulates" elsewhere in the chapter).
8. `00:280` "The chunk below measures" -> "The chunk measures" (same).
9. `index:186` "the two core sweeps above and the three literature tables below"
   -> "the two core sweeps and the three literature tables listed separately here".

### Checklist 5, acronyms, spelling, typography
10. `00:40` undefined "QTL" -> "the set of quantitative trait loci" (its only use in the chapter).
11. `index:179` "MaCS" -> "MaCS (Markovian coalescent simulator)" at first use.
12. `00:351` "homogenization" -> "homogenisation" (book spelling; paraphrase, not a quotation).
13. `00:346` "(-2.33%)" -> "($-2.33$%)": true minus, value unchanged.

Checked, nothing to change: 1 figure (label, cap, alt, cited first, book palette,
no overlap when drawn at 6.5 x 4.4 in); 2 tables (captions stand alone, cited
first); 4 equations (labelled, cited, symbols defined); no callouts or footnotes;
sentence-case headings; no hand-typed citations; every `@` reference and citation
key in both files resolves; every file and glob named in the index passage exists.
The six echo chunks that print a named vector are declared as verification echoes
and the prose carries their values, so they are not findings. `hp-drift` is (00-E3).

No book/Rplots.pdf was present; nothing deleted.

## (b) E findings

### For quant-writer (need prose, caption or a content decision)

- **00-E3** `book/00-hybrid-programme.qmd:681`. RESOLVE BEFORE CLOSE. `fmt(dr, 4)`
  prints an unnumbered table: `dr` is a matrix, `fmt()` makes it a data frame, and
  `df-print: kable` renders it (frozen output at HEAD: `<div class="kable-table">`).
  The comment on line 680 says "not a results table", so the render contradicts the
  stated intent, and the checklist forbids unnumbered tables. Left alone because the
  choice is the author's and either route goes beyond what I may apply.
  Option B (recommended): quant-Rwrite prints it as `round(dr, 4)`, a console echo
  like its six siblings; the prose already gives all six values.
  Option A: number it. Needs `#| label: tbl-hp-drift`, a `tbl-cap`, a citation
  before the chunk, removal of the comment, and readable row names in place of
  `block_selfing` etc. Later tables renumber automatically.
- **00-E4** `book/00-hybrid-programme.qmd:577-578`, `book/08-pipeline-stages.qmd:91`,
  `book/90-notation.qmd:205,226`. Symbol clash: here and in @sec-stages $\theta_B$ is
  the mean BETWEEN-pool coancestry; in the notation appendix and in chapters 05, 05b
  and 06 it is coancestry WITHIN pool B. A rename touches chapter 08, so it is not
  applied here.
- **00-E5** Symbols not in `book/90-notation.qmd`: $F^{(t)}$, $\bar F^{(t)}$
  (`00:79-86,608`), $\bar y_{ij}$, $\bar e_{ij}$ (`00:109`), $p_{b,k}$, $q_{b,k}$
  (`00:465,473`), $\theta_t$ (`00:611`), $\theta_w$, $G_{ST}$ (`00:576-577`). All are
  defined where used, so this is a decision on adding them, not an error. Also
  $H_t$ (`00:601`) differs from the local $H_t$ of the population-sizing table, and
  that table is declared local.
- **00-E6** `book/00-hybrid-programme.qmd:356`. "the mechanism above" remains
  positional. The sentence follows both a drift argument and a selection statement,
  so naming the mechanism needs a scientific reading.

### For quant-Rwrite

- **00-E7** `book/00-hybrid-programme.qmd:239,245`. Figure labels use ASCII "->" and
  "A x B" where the caption has $\times$. Chunk code, low priority.

### Book-wide, for the close (no prose involved)

- **00-E2** OPEN, cause not found. In the published PDF every prose `@sec-notation`
  prints a bare `1` ("Symbols follow 1.", "the $\mu$ of 1"), at `00:363,583,752` and
  across chapters; the one in the `04c` table caption prints `Appendix A.`, and other
  appendix labels print correctly. Quarto's Lua emits the same `#ref` for all of
  them. NOT reproduced in scratch builds with the real `_quarto.yml`, header files
  and bibliography, with a stub and then with the real `90-notation.qmd`: all print
  `Appendix A.`. So it may already be gone from the current sources or may need the
  full book to appear. Check after the render at close:
  `pdftotext docs/Genetic-Diversity-in-Hybrid-Breeding.pdf - | grep -nE 'follow 1[.;]|of 1[,)]'`
- **00-E8** `book/typst-style.typ`. Table cells inherit `par(justify: true)`, leaving
  wide word gaps in narrow cells, still slightly visible after fixes 1-2. Candidate:
  `#show table: set par(justify: false)`. Not tested, not applied.

## (c) Figures the render at close may orphan: none

The four labels named in the brief (`hp-drift`, `hp-ibs-ibd`, `hp-subset-gd`,
`fig-hp-cycle`) are identical at HEAD and now; only chunk bodies changed. The chapter
has one plot chunk, so `fig-hp-cycle-1.png` and `.svg` are overwritten under the same
names. Tracked files, all still referenced:

- `docs/00-hybrid-programme_files/figure-html/fig-hp-cycle-1.png`
- `book/_freeze/00-hybrid-programme/figure-html/fig-hp-cycle-1.png`
- `book/_freeze/00-hybrid-programme/figure-typst/fig-hp-cycle-1.svg`

Both resolutions of 00-E3 leave this unchanged.

## Notes for the close

- Re-run `Rscript book/scripts/make_downloads.R`: the prose changed, and
  `book/downloads/00-hybrid-programme.R` keeps it as comments. Not run here.
- 38 tracked " N" duplicates sit under `docs/`, also on origin/main, none for this
  chapter. CLAUDE.md requires that list to be empty; they need an explicit `git rm`.

## Verification

Run: reference and citation-key resolution by script after the edits; the Typst
patch and the two tables in scratch builds; the figure code drawn at Typst width.
Not run: a render of the real chapter with these edits, in either format.
