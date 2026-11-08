# 00-hybrid-programme -- iteration 3 response (quant-writer)

Files changed: `book/index.qmd` (two sentences of the provenance passage), `book/scripts/regenerate.R` (header comment only; no code line in the diff). `book/downloads/` regenerated. Chapter 00, the other owed rows, `R/`, `tests/`, `_freeze/`, `docs/` untouched.

| ID | Status | What changed, or evidence |
|---|---|---|
| 00-D27 | fixed | index:186 "the two hand-extracted tables below" -> "the three hand-extracted tables below", so the wildcard of the external category no longer captures `mating_core_findings.csv`. index:196-201: the file is named in "Not simulation output", "hand-extracted from the published literature and read by no chapter". The wording for the two sparse tables is unchanged. The new file gets "the published literature", not "the primary papers", because its 39 keys were not each checked to be primary studies |
| `regenerate.R:27-31` (owed row, 04e / script owner) | fixed, closed | `mating_core_findings.csv` removed from the list attributed to `sparsex` and given its own entry: a literature extraction, values taken by hand from published papers, not study output, read by no chapter. The row needs no carrying to THREAD.md |

## Verified

- Partition, by listing `book/data` (48) and `book/figs` (17), 65 files: regenerate.R 24, run_mabc.R 8, external 14, no writer 12, not simulation output 7. Disjoint and exhaustive (`stopifnot`). The regenerate.R category is the intersection of the file list with the `.csv`/`.png` names in non-comment lines of the script, so the header comment does not feed it. The external 14 are 3 `mating_*` tables, 5 `mating_*` figures, 6 `sparse_*` tables.
- `mating_core_findings.csv`: 85 rows, 39 keys, columns `key, quantity, value, units, context`.
- "Read by no chapter": `core_findings` occurs in `book/*.qmd` and `book/_common.R` only at the index's own naming of the file, and in no file of `R/`, `inst/`, `tests/`. Outside those it occurs in the `regenerate.R` header.
- `git diff book/scripts/regenerate.R`: every changed line is a comment.
- `Rscript book/scripts/make_downloads.R` run from the worktree root. `book/index.qmd` knit against `pkgload::load_all()` of the worktree, to the scratchpad: no error. No `book/Rplots.pdf`. No `quarto render`.

## Limits

- "Hand-extracted" rests on the file's content (publication keys, per-paper values) and on no writer in the repository. The repository records no extraction procedure: the file arrived with commit c571183, whose message does not describe it.
- `CLAUDE.md` says the `04e` headline sweep is cached from `sparsex`, then that `book/data/mating_*.csv` cannot be regenerated here. The second statement stays true of this file; the wildcard reads as if the file came from that study. Outside this review, not changed.
