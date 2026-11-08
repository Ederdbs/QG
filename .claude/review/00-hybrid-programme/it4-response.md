# 00-hybrid-programme -- iteration 4 response (quant-writer)

Files changed: `book/index.qmd` (provenance passage, lines 186 and 196-203), `book/scripts/regenerate.R` (header comment only). `book/downloads/` regenerated. Per the user's decision on 00-D28, the text no longer says who or what extracted the values; it states origin and limit.

| ID | Status | What changed, or evidence |
|---|---|---|
| 00-D28 | fixed | index:186 "the three hand-extracted tables" -> "the three literature tables". index:200-203 `mating_core_findings.csv`: "extracted from the published literature and read by no chapter", followed by the limit, attributed to the record: "The source record of that last file, which is not in this repository, marks 48 of its 85 rows as from full text and assigns the other 37 to abstracts; the file itself carries no such marker." regenerate.R:33-34 "values taken by hand from published papers" -> "values from published papers" |
| index:199, sparse tables (owed row) | fixed | "hand-extracted from the primary papers" -> "compiled from the primary papers". "Extracted" was not kept: see Verified |
| regenerate.R:42, sparse tables (owed row) | fixed | "hand-extracted from the six primary papers" -> "compiled from the six primary papers". Comment only |
| 92:343, sparse tables, same word | owed -> 92 | "hand-extracted from the six primary papers of @sec-sparse" unchanged, by instruction. Should become "compiled from" to agree with the index |
| 04e:82-83 | owed -> 04e | "its tables are in `book/data/mating_*.csv`" unchanged, by instruction. The wildcard captures `mating_core_findings.csv` and `mating_core_sweep.csv`, which index:184-186 excludes |
| Source bundle: 24 full-text core papers stated, 23 marked | owed -> source bundle | Not a book defect, but see Limits: it bears on the 48 / 37 split |

## Verified

- `core_paper_findings.csv` is byte-identical to `book/data/mating_core_findings.csv` (`cmp`). 85 rows, 39 keys, all 39 of relevance `core` in `hybrid_mating_design_references.csv`.
- Split, recomputed by joining on `key`: `notes` contains "full text mined" for 19 of 39 keys, 48 of 85 rows. The other 20 keys, 37 rows, have an empty `notes`. None of the 20 is marked "no abstract retrieved", so the record's "the rest from abstracts" (`INDEX.md`, Literature coverage; `book_chapter_skeleton.md`, Appendix B) is not contradicted for them.
- The book's file has columns `key, quantity, value, units, context`: no marker, as the text says.
- Sparse tables. `reference/new_sparsing_test/10_fichamento_artigos.md:3` supports the full text of the six sources, and `11_parametros_literatura.csv` cites section or table per value. But `sparse_literature_parameters.csv` is not extraction throughout: of its 18 rows, 1 is flagged `derived` (8.1 = 1.13 / 0.14) and 3 are ranges across "all six studies", which match `20_plano_capitulo.md:282`, not a paper. `sparse_primary_studies.csv` is a condensed row per study, with a paraphrased conclusion. "Compiled" is true of all of it; "extracted" is not. Werner et al. 2025 is a preprint, so "published" was not used; "primary papers" stands.
- Grep of `book/index.qmd` and `book/scripts/regenerate.R` for "hand-extracted", "by hand", "manual": no match.
- `git diff book/scripts/regenerate.R`: every changed line is a comment.
- `Rscript book/scripts/make_downloads.R` run from the worktree root. `book/index.qmd` knit against `pkgload::load_all()` of the worktree, output to the scratchpad: no error. No `book/Rplots.pdf`. No `quarto render`.

## Limits

- The 48 / 37 split rests on the `notes` column and on a record that is gitignored, so the book cannot reproduce it; the text says the record is not in this repository. The record states 24 full-text core papers and the column marks 23. If the unmarked paper is among the 20 keys, some rows counted under abstracts came from full text. The text therefore says "marks" and "assigns", not that the rows are from those sources.
- Accuracy of the 85 rows beyond the reviewer's sample: not checked.

## Observation outside this scope (04f, not changed)

`sparse_literature_parameters.csv` gives "Genotypes tested, 264-2000, all six studies" and "Locations, 2-440, all six studies". The book's own `sparse_primary_studies.csv` lists 256 genotypes (Hild Aono & Chawade 2026) and "1-440 locations" (Werner et al. 2025), and the record gives the same two values. The two ranges appear to be wrong at their lower ends; printed in `tbl-sparse-parameters` of 04f. It needs a reviewer's ID.
