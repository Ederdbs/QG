# 00-hybrid-programme -- iteration 6 verdict

Scope, as authorised: close or reopen 00-D29, then judge only the changed sentence at `book/index.qmd:201-203`. `index:n` is a line of the working tree.

```
VERDICT: APPROVED
```

00-D29 closes and the sentence raises no new ID. All earlier IDs stay closed under the scope of this iteration.

## PREVIOUS IDS

- 00-D29 -- CLOSED -- all three limbs fall with the counts. (1) No row split remains, so the `Technow2014` row no longer contradicts anything: the sentence says what the record does with papers, and that row's own provenance is not stated by it. (2) The unit is now the paper, which is the unit the record marks, so the result of the `key` join is no longer printed as a marking made by the record. (3) "Some papers" is true whether the record's number is 24 (stated) or 23 (marked), so no exact count hides that discrepancy.

## DISQUALIFYING FAILURES

None.

## NON-DISQUALIFYING OBSERVATIONS

None.

## OWED ROWS

Not charged here. None of these is in the sentence under review.

- 04f-D1 (owed to 04f; carried from it5, not re-examined): `sparse_literature_parameters.csv` ranges "264-2000" and "2-440" against `sparse_primary_studies.csv`.
- 92:343, for 92 (carried, still open; line re-read in this iteration): "hand-extracted from the six primary papers of @sec-sparse". It disagrees with index:199 and `regenerate.R:42` on the same two files.
- 04e:82-83, for 04e (carried, not re-examined): the `mating_*.csv` wildcard.
- Source bundle, not the book (carried and extended): 24 stated against 23 marked; the `Technow2014` row, whose `key` and `context` name different papers; and 13 of the 73 core papers carrying "no abstract retrieved", so the record's own "the rest from abstracts" is not exact across the core set. None of the 13 is among the 39 papers of the file.

## WHAT WAS VERIFIED

Scripts `it6.R`, `it6b.R` and `knit.R` in the session scratchpad. No seed is involved: these are deterministic reads of the files.

- "Marks some papers as read in full text": the `notes` column of `hybrid_mating_design_references.csv` carries "full text mined" on 23 papers, all core (R table of `relevance` by marker: core 37 empty / 23 marked / 13 no abstract; supporting 63 / 0 / 18; 154 rows). The marker sits on paper rows.
- "Leaves the rest to their abstracts": `INDEX.md:66-67` "full text mined for 24 of those 73 core papers, the rest from abstracts"; `book_chapter_skeleton.md:385-386` says the same. Among the 39 keys of the file: 19 marked, 20 empty, 0 "no abstract retrieved", none unmatched. So the limb holds for the papers of that file, and it matches the record's words at core scope. At core scope the record's `notes` are less exact than its prose; that is the source-bundle row above.
- `Technow2014` has empty `notes` and `GonzalezDieguez2021` has "full text mined; ", as it5 reported. The paper-level statement is correct for both.
- "Read" for the record's "mined": the sentence names no agent and states no method, and `notes` contains no "hand" or "manual" (`grepl` returned FALSE). The claim closed under 00-D28 does not return. I do not count the paraphrase as a failure.
- "The file itself carries no such marker": columns are `key, quantity, value, units, context`; a case-insensitive search of `quantity` and `context` for full text, abstract, table, supplement, fig returned 0 rows. `cmp` shows the file byte-identical to `core_paper_findings.csv`.
- "Which is not in this repository": `git ls-files` lists nothing under `reference/` or `doc/` and none of the record's file names; `reference/*` is ignored at `.gitignore:8`. Unchanged wording; rechecked because it lies in the sentence.
- "That last file" resolves to `mating_core_findings.csv`, the last item of the list at index:200.
- Counts gone: grep of `book/index.qmd` and `book/scripts/regenerate.R` for "48 of", "85 rows", "other 37", "hand-extract" gives no match, and lines 1-45 of `regenerate.R` have no whole-number 48, 85 or 37. Grep of `book/*.qmd` finds no second statement of this split; `mating_core_findings` occurs only in index.qmd and `regenerate.R`.
- `book/index.qmd` knit against `pkgload::load_all()` of the worktree, output to the scratchpad: no error, and the sentence is in the output. No `book/Rplots.pdf` remains. `git status --short` is the same before and after.

## NOT VERIFIED

- Which paper is the 24th: only the producer of the bundle can settle it. No longer decisive, because the sentence holds under either number.
- No `quarto render`, and `docs/` was not inspected for this sentence. Non-decisive for the text; the change is prose and adds no cross-reference.
