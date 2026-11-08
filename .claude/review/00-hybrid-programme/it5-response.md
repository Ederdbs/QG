# 00-hybrid-programme -- iteration 5 response (quant-writer)

File changed: `book/index.qmd:201-203`, one sentence. `book/downloads/` regenerated. `book/scripts/regenerate.R` not touched. Per the user's decision on 00-D29, the row counts are removed and no number replaces them.

| ID | Status | What changed, or evidence |
|---|---|---|
| 00-D29 | fixed | "marks 48 of its 85 rows as from full text and assigns the other 37 to abstracts" -> "marks some papers as read in full text and leaves the rest to their abstracts". The full sentence is the user's wording, unadjusted. The sentence now speaks of papers, which is the unit the record marks, so neither the `key` join nor the `Technow2014` row bears on it, and the 24-stated / 23-marked discrepancy no longer sits under an exact count |

## Checked against the record

- `INDEX.md:66-67`: "full text mined for 24 of those 73 core papers, the rest from abstracts". `book_chapter_skeleton.md:385-386`: "Full text was mined for 24 of the 73 core papers; the rest were extracted from abstracts". `hybrid_mating_design_references.csv`, `notes`: "full text mined" on 23 of the 73 core papers. Both limbs of the sentence are supported, and the marking is per paper.
- Among the 39 keys of `book/data/mating_core_findings.csv`: 19 marked, 20 unmarked, 0 with "no abstract retrieved". The sentence holds for the papers of that file.
- "the file itself carries no such marker": unchanged, verified in it5-verdict.
- Grep of `book/index.qmd` and the header of `book/scripts/regenerate.R` (lines 1-45) for 48, 85, 37 as whole numbers: no match.

## Limits

- "read" renders the record's "mined". The record does not say how the mining was done; "read" names no agent, so it does not restore the claim closed under 00-D28. Kept as given.
- Across all 73 core papers, 13 carry "no abstract retrieved" in `notes`, so the record's own "the rest from abstracts" is not exact at that scope. None of the 13 is in this file, and the book's sentence reports what the record says. Owed to the source bundle with the 24 / 23 row, not a book defect.

## Run

- `Rscript book/scripts/make_downloads.R`: completed.
- `book/index.qmd` knit against `pkgload::load_all()` of the worktree, output to the scratchpad: no error; the new sentence is in the output. No `book/Rplots.pdf`. `git status --short` has the same entries before and after the run.
- No commit, no render.
