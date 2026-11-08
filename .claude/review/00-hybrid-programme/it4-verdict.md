# 00-hybrid-programme -- iteration 4 verdict

Scope, as authorised: close or reopen 00-D27, then judge only `book/index.qmd:184-201` and the header of `book/scripts/regenerate.R`. `index:n` and `regenerate.R:n` are lines of the working tree. Severity in brackets is mine.

```
VERDICT: REJECTED
```

One ground: 00-D28 (L), new. 00-D27 closes: the file is now in the right category and the partition is exact. The word the repair used to describe the file, "hand-extracted", states a procedure that no record supports.

## PREVIOUS IDS

- 00-D27 -- CLOSED -- every sub-item is repaired. The wildcard no longer captures `mating_core_findings.csv` (index:184-186). The count of tables is three, and three are listed (index:198-201). The partition is 24 / 8 / 14 / 12 / 7, recomputed by me. "Read by no chapter" holds. The header no longer attributes the file to `sparsex`. The reclassification is also confirmed by the source bundle: `reference/new_mating_design/INDEX.md:14` lists the file, under its original name `core_paper_findings.csv`, in section 1 "Literature", apart from section 3 "`sparsex`". The new text carries a new defect of its own, issued as 00-D28.

## DISQUALIFYING FAILURES

- 00-D28 (L) [criterion 3 provenance, 4, 6] index:186, index:200, regenerate.R:33-34 -- "hand-extracted from the published literature", "the three hand-extracted tables" and "values taken by hand from published papers" state as fact how the file was made. That fact is not known.
  - The writer's own limit says so: the word "rests on the file's content ... and on no writer in the repository", and "the repository records no extraction procedure" (it3-response, Limits). The content shows that values come from papers. It cannot show that a person took them. The absence of a script shows only that the script is not here. This is an inference printed as a measurement of origin, and the limit stands in the response, not in the text.
  - A record does exist, outside the tracked tree, and it never mentions manual extraction. `reference/new_mating_design/core_paper_findings.csv` is byte-identical to `book/data/mating_core_findings.csv` (`cmp`). `INDEX.md:14` calls it "85 extracted quantities from 39 core papers". `INDEX.md:65-67` and `book_chapter_skeleton.md:381-387` describe a pipeline: 4,142 records harvested from Crossref and Europe PMC, 520 screened ("500 by LLM classification, 20 by rule"), "Full text was mined for 24 of the 73 core papers; the rest were extracted from abstracts, so numbers living in tables and figures are not captured". Neither document says who or what extracted the values, so I hold "by hand" as unsupported, not as false. It is nevertheless the one attribute the only record gives no ground for, and that record points towards a harvest-and-mine process.
  - The same record states a limit of the file that the new description omits. In `hybrid_mating_design_references.csv`, 19 of the 39 keys and 48 of the 85 rows are marked "full text mined". The other 20 keys and 37 rows are, on the record's statement, from abstracts. "Hand-extracted from the published literature" reads as a careful reading of the papers, which is more than the record gives for those rows.
  - The writer's statement that the repository records no procedure is true of the tracked tree: `reference/` is gitignored. It does not rescue the word. Where nothing is recorded, the passage written to state origin has no basis for naming a method.
  - Weight: the file is read by no chapter, so no number of the book depends on this. The criterion has no exemption for that. The failure is of the same kind as 00-D27, a statement of origin that goes beyond the evidence in the passage whose only job is to state origin, and here it was introduced by the repair.

## NON-DISQUALIFYING OBSERVATIONS

None.

## OWED ROWS

Not charged here.

- 04e:82-83, for 04e: "its tables are in `book/data/mating_*.csv`" says of the `sparsex` sweep what index:184-186 now excludes. The wildcard captures `mating_core_findings.csv` and `mating_core_sweep.csv`. The index is the true side. The response names the same wording in `CLAUDE.md`, but not this line.
- index:199, 92:343, regenerate.R header (`sparse_primary_studies.csv`, `sparse_literature_parameters.csv`), unchanged text: the same word. I did not reopen it. index:186 now counts these two with the third, so whoever answers 00-D28 meets them. The one source I read, `reference/new_sparsing_test/10_fichamento_artigos.md:3`, says the numbers were "extraídos do texto integral fornecido pelo usuário", which supports the full text and is silent on who extracted them.
- Source bundle, not the book: the record says 24 core papers were mined in full text, and the `notes` column marks 23 of the 73. Recorded only because the count above rests on that column.

## WHAT WAS VERIFIED

Scripts in the session scratchpad.

- Partition: `ls book/data` 48, `ls book/figs` 17, 65 files, no name repeated. R script over the listings: regenerate 24 (file list intersected with `.csv`/`.png` names in non-comment lines of `regenerate.R`), `mabc_*` 8, external 14, no writer 12, not simulation output 7. Sum 65, no duplicate across categories, no residual. The external 14 are 3 `mating_*` tables, 5 `mating_*` figures, 6 `sparse_*` tables.
- `mabc_*`: all 8 names occur in `inst/scripts/run_mabc.R` (grep; `mabc_bcnf2.csv` separately, as my first pattern excluded digits).
- No writer: grep of the nine stems `de_constraints`, `de_convergence`, `cost_scaling`, `metric_redundancy`, `pipeline_loss`, `fst_definitions`, `dist_vs_variance`, `theta_identity_check`, `metric_pitfalls` over `R`, `inst`, `tests`, `book/scripts`: no match. `cost_per_eval.csv` occurs only as `report/cost_per_eval.csv` in `run_benchmark.R:73`, as index:191-192 says.
- "Read by no chapter": `core_findings` over `book/*.qmd`, `book/_common.R`, `book/scripts`, `book/downloads`, `R`, `inst`, `tests`: only index:200 and regenerate.R:32. No chapter builds a data path dynamically: grep for `list.files`, `dir(`, `Sys.glob`, a `book_data()` call on a non-literal, and pasted `.csv` names returned only four caption `sprintf()` lines of 04b. 04e reads four files by literal name, and `mating_core_findings.csv` is not one of them.
- 04e reads the rest of the category: `mating_scenarios_summary`, `mating_optimizer_frontier`, `mating_validation` (04e:6-8), and the five figures at 04e:526, 587, 762, 944, 946.
- `regenerate.R` diff against HEAD: 0 changed lines that are not comments. The new header entry is at lines 32-34.
- "The three hand-extracted tables" against the list: three files are named at index:198-200, so the count agrees with the list.
- File: 85 rows, 39 keys, columns `key, quantity, value, units, context`. Commit c571183 added it; its message does not describe it.
- "Published literature": 39 of 39 keys are in the bundle's reference table with a DOI and a journal venue; no preprint server among them. 29 of the 39 are in `book/references.bib`; the other 10 are not in the book's bibliography, which the passage does not claim.
- Spot check of rows against Europe PMC abstracts fetched by me, by DOI: Technow2014 (1254 hybrids; 0.75-0.92; 0.59-0.95), Guo2019 (276; 2,556 wheat; 1,439 rice), Massman2012 (0.87; 0.90), Gaynor2017 (2.36-2.47; 1.31-1.46; 40 years). All match. Gorjanc2018 was fetched, but the excerpt read stops before its numbers, so no row of it is confirmed. Five keys sampled, not a census.
- Provenance documents read: `reference/README.md`, `reference/new_mating_design/INDEX.md`, `book_chapter_skeleton.md:15-28, 376-392`; `grep` for `extract`, `by hand`, `manual`, `LLM` over the bundle's `INDEX.md`, `README.md`, `literature_review_mating_designs.md`, `findings.md`, `book_chapter_skeleton.md`: no statement of manual extraction.
- `book/index.qmd` knit against `pkgload::load_all()` of the worktree, on a scratch copy: no error. The passage holds no chunk or inline code. No `book/Rplots.pdf`.

## NOT VERIFIED

- Who or what extracted the 85 values: no record says. Decisive for the word under 00-D28. Only the person who produced the bundle can settle it; the user arbitrates.
- Accuracy of the 85 rows beyond the sample above: not checked. Non-decisive: no chapter reads the file.
- No `quarto render`. Non-decisive; the change is prose and adds no cross-reference.
