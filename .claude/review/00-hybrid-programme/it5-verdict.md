# 00-hybrid-programme -- iteration 5 verdict

Scope, as authorised: close or reopen 00-D28, then judge only `book/index.qmd` lines 186 and 196-203 and the header of `book/scripts/regenerate.R`. `index:n` and `regenerate.R:n` are lines of the working tree. Severity in brackets is mine.

```
VERDICT: REJECTED
```

One ground: 00-D29 (L), new. 00-D28 closes. The word "hand" is gone and the procedure claim with it. The sentence that replaced it states an exact row split as what the record says, and one row of the 37 contradicts it on the record's own evidence.

## PREVIOUS IDS

- 00-D28 -- CLOSED -- no statement of who or what extracted the values survives. "Hand" is absent from index.qmd and regenerate.R. "Extracted" (index:200) rests on `INDEX.md:14`, "85 extracted quantities", and is neutral on the agent. "Compiled" (index:199, regenerate.R:42) claims nothing about procedure. The omitted limit is now in the text, attributed to the record. Its count is a new defect, issued as 00-D29.

## DISQUALIFYING FAILURES

- 00-D29 (L) [criterion 1, 3 provenance, 6] index:201-203 -- "marks 48 of its 85 rows as from full text and assigns the other 37 to abstracts" gives an exact count as the record's own statement. The record makes no such statement, and the count fails on one row.
  - The failing row is `book/data/mating_core_findings.csv:26`, key `Technow2014`, `accuracy_T2_T1_T0`, 0.91 / 0.85 / 0.77. It falls in the 37 because `Technow2014` has an empty `notes`. Its own `context` reads "as reported by Technow et al. (2014) and quoted by Gonzalez-Dieguez et al. (2021)". Those three values are not in the Technow 2014 abstract (Europe PMC). They are not in the Gonzalez-Dieguez 2021 abstract either. `GonzalezDieguez2021` is marked "full text mined", and its `key_quantitative_finding` in the reference table carries the same three values. So the record itself traces this row to the full text of a marked paper. It does not assign the row to an abstract. On that evidence the split is at least 49 / 36, not 48 / 37.
  - The record marks papers, not rows. `notes` flags 19 of the 39 keys, and `INDEX.md:66-67` speaks of "the rest" of the core papers. The 48 and the 37 come from a join on `key`. The join assumes a row's key names the paper the value was read from, and the row above shows that this need not hold. The sentence prints the result of that join as a marking made by the record.
  - The join was mine. it4-verdict gave 48 and 37 "on the record's statement" without reading that row. The writer took the count from there and recomputed it, and the recomputation is exact as a join. That explains the error and does not repair it: a report is not evidence.
  - The record states 24 full-text core papers and marks 23. it4-response, Limits, says that if the unmarked paper is among the 20 keys, rows counted under abstracts came from full text, and that "the text therefore says 'marks' and 'assigns'". Those verbs do not carry that limit: a reader sees two exact counts and no sign of the discrepancy. This is the pattern of 00-D28, a limit that stands in the response and not in the text. I found no evidence that the 24th paper touches the count (see the 36 rows under WHAT WAS VERIFIED), so this limb is unresolved, not wrong.
  - Weight: the file is read by no chapter, so no number of the book depends on this. The error is one row of 85. It overstates the abstract share slightly, and the warning the sentence gives survives. 36 of the 37 rows do sit in their abstracts. The criteria have no exemption for size, and this is the passage whose only job is to state origin.

## NON-DISQUALIFYING OBSERVATIONS

None.

## OWED ROWS

Not charged here.

- 04f-D1 (owed to 04f, criterion 1 and 5; confirmed) book/data/sparse_literature_parameters.csv, rows "Genotypes tested, 264-2000, all six studies" and "Locations, 2-440, all six studies", printed by `tbl-sparse-parameters` (04f:901). `sparse_primary_studies.csv`, printed by `tbl-sparse-primary` (04f:491), lists 256 genotypes (Hild Aono & Chawade 2026) and "1-440 locations" (Werner et al. 2025). So two tables of the same chapter disagree, and 256 is below the stated minimum, as 1 is. Both ranges match `reference/new_sparsing_test/20_plano_capitulo.md:282`, so the error comes from the plan and not from a paper. The papers side with the primary table: 256 in the Hild Aono text, and in Werner Table 1 the baseline `BSLN-1_2200` has 1 site. Whoever repairs this also meets the conventional arm of the same Werner table, `CT-220_5`, with 220 lines tested. That is below 256 and does not appear in `sparse_primary_studies.csv`, which gives 2000 for that study. The frozen and published 04f print the wrong ranges (`264-2000` and `2-440` found in `docs/04f-sparse-testing.html`).
- 92:343, for 92 (carried from it4-response, still open): "hand-extracted from the six primary papers of @sec-sparse". It now disagrees with index:199 and regenerate.R:42 on the same two files, and it keeps the unsupported word.
- 04e:82-83, for 04e (carried, unchanged): the `mating_*.csv` wildcard.
- Source bundle, not the book (carried): 24 stated, 23 marked. Now also the `Technow2014` row above, whose `key` and `context` name different papers.

## WHAT WAS VERIFIED

Scripts in the session scratchpad.

- Split as a join: `cmp` shows `core_paper_findings.csv` byte-identical to `book/data/mating_core_findings.csv`. R join on `key`: 85 rows, 39 keys, none unmatched; "full text mined" 48 rows / 19 keys, empty `notes` 37 rows / 20 keys. Core papers 73, marked 23. The other 4 marked (Kinghorn2011, Jarquin2020, Melchinger2023b, Lubanga2025) have no row in the file.
- The 37 rows against abstracts, by DOI, tokens of `value` matched against the text: Europe PMC for 15 keys, Crossref for the 5 Europe PMC lacks (Bernardo1994, Bernardo1996, Hickey2014, Lian2015, Smith1986). 34 rows match outright. 2 match after reading: Lorenzi2022 "eight environments" for 8, and Philipp2016 385 + 408 = 793, a sum. 1 does not match: the row of 00-D29. Automated token match, so it shows the values occur in the abstract, not that each is used in the same sense.
- Technow row: read the full abstract as returned by Europe PMC, and no match for 0.91, 0.85 or 0.77. Gonzalez-Dieguez 2021 (10.1093/genetics/iyab026): the seven tokens tested (0.91, 0.85, 0.77, 0.92, 0.88, 0.80, "Technow") are absent from the abstract. Its `notes` is "full text mined; ".
- "The file itself carries no such marker": columns `key, quantity, value, units, context`. A case-insensitive search of `quantity` and `context` for table, fig, supplement, full text, abstract returned 0 rows. True as to full text against abstract.
- "Which is not in this repository": true and acceptable. `git ls-files` lists nothing under `reference/` or `doc/`, and none of the record's file names. `git log --all` on the record's path and `git rev-list --all --objects` for `core_paper_findings`, `hybrid_mating_design_references`, `book_chapter_skeleton` return nothing, so it is not in history either. `reference/*` is at `.gitignore:8`. For a reader it is an honest statement that the count cannot be checked here. It gives no path, as CLAUDE.md requires, and it supports no result of the book.
- "Published literature": 39 of 39 keys carry a DOI, and no venue matches rxiv, preprint or Research Square.
- "Compiled from the primary papers": holds for both tables. All 18 rows of `sparse_literature_parameters.csv` carry one of the six papers as source, or "all six studies". Of the 14 single-paper non-derived rows, every numeric token occurs in that paper's text under `reference/new_sparsing_test/`, except 0.30, printed there as "H2=0.3" (Gonzalez-Dieguez 2026). The row "none strong detected" has no token and was not read. The derived 8.1 = 1.13 / 0.14 = 8.07, both components in the Li text. The three "all six studies" rows are not from one paper: two are the 04f-D1 ranges, and "compiled" makes no claim of accuracy. `sparse_primary_studies.csv` has 6 rows, one per paper; of its values I checked only 256 (Hild Aono text) and the Werner sites against Table 1.
- 04f-D1: both CSVs read directly. Plan line 282 read. Werner Table 1 read in `Werner2025_earlystage_sparse_biorxiv.txt:410-432`.
- `git diff book/scripts/regenerate.R`: every changed line is a comment. `parse()` passes. Grep of index.qmd and regenerate.R for "hand-extract", "by hand", "manual": no match.
- index:186 "three literature tables": three are named at index:198-200.
- `book/index.qmd` knit against `pkgload::load_all()` of the worktree, output to the scratchpad: no error. No `book/Rplots.pdf` remains.

## NOT VERIFIED

- Which paper is the 24th: the record does not say. Decisive only for the third limb of 00-D29, which does not carry the rejection. Only the person who produced the bundle can settle it.
- Whether the 48 rows of marked papers were each read from full text and not from the abstract: not tested. The first limb stands without it.
- Accuracy of the 85 rows beyond the token match above: non-decisive, no chapter reads the file.
- No `quarto render`. Non-decisive; the change is prose and adds no cross-reference.
