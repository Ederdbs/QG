# 00-hybrid-programme -- iteration 3 verdict

Chapter: `book/00-hybrid-programme.qmd`, with `book/index.qmd`, `book/_common.R`, `book/references.bib`. `00:n` and `index:n` are lines of the working tree. `docs/` and `_freeze/` were not judged. Severity in brackets is mine.

```
VERDICT: REJECTED
```

One ground: 00-D27 (L), new. The index's five-category provenance passage misclassifies one file. Every ID open after iteration 2 closes. No M is open.

## PREVIOUS IDS

- 00-D24 -- CLOSED -- the universal negative is gone. 00:206-211 now ends on what @kadoumi2025 write, confirmed again in their full text. Nothing in 00 speaks for the book on this point, and "reciprocal recurrent" appears in 00 and the index only at 00:208.
- 00-B2 -- CLOSED for 00 -- no statement of 00 rests on the content of Comstock et al. (1949); the one mention reports Kadoumi's citation. The paper stays unread and is decisive in the owed chapters.
- 00-D25 -- CLOSED -- each sub-item of the iteration-2 finding is repaired: no external file is labelled reproducible, `de_constraints` and `cost_per_eval` are under "no writer", `mabc_*` is under `run_mabc.R`, "from a simulated dataset" and "do not move" are gone. The new text carries a new defect of its own, issued as 00-D27.
- 00-D26 -- CLOSED -- 00:83-86 and 00:607-609 agree on the superscript; the chunk comment uses `within_t`; no `F_t` is left in 00. The comment's recursion matches the code: `c_t <- c(-1, 0)` holds $(c_{-1}, c_0)$ and the loop runs $t_{gen} + 1$ steps.
- 00-M14 -- CLOSED -- "candidate pool" no longer occurs in 00 or the index (grep). See OWED ROWS for the incomplete row.
- 00-M15 -- CLOSED -- `_common.R` comment true; "Every live example" is absent from `book/*.qmd`, `_common.R` and `book/downloads/` (grep).
- 00-M16 -- CLOSED -- index:83-85 carries the dominance condition of 00:72-74.
- 00-M17 -- CLOSED -- Crossref record read by me: vol. 37, issue 2, pp. 134-145, Fred H. Hull. Kadoumi's reference list agrees.

## DISQUALIFYING FAILURES

- 00-D27 (L) [criterion 3 provenance, 5] index:184-188, index:196-199 -- `book/data/mating_core_findings.csv` is placed by the wildcard "the `mating_*` tables and figures of @sec-mating" in the category "Cached from external studies", whose stated exceptions are only "the two core sweeps above and the two hand-extracted tables below". All three statements fail on this file.
  - It is not study output. It has 85 rows over 39 publication keys (`Thomsen2026`, `Lorenzi2024`, `Melchinger2023`, ...), with columns `key, quantity, value, units, context`: values extracted from papers, e.g. `Thomsen2026, fraction_of_full_factorial, 0.0167`. That is the kind of table the fifth category describes, so "the two hand-extracted tables" is false: there are three, and the partition is 24 / 8 / 14 / 12 / 7, not the response's 24 / 8 / 15 / 12 / 6.
  - It is not a table "of @sec-mating". No chapter reads it: `core_findings` occurs only at `regenerate.R:28`. 04e types the same values in prose with citations (`04e:500-505`).
  - The category's consequence, "The code of those studies is not in this repository", has no meaning for a literature extraction.
  - The file is not labelled reproducible, so the provenance rule's central prohibition holds. What fails is a false statement of origin in the passage written to state origin. The error comes from the header of `regenerate.R:27-31`, and the iteration-2 verdict repeated that header without opening the file; that explains the error and does not cure it.

## NON-DISQUALIFYING OBSERVATIONS

None.

## OWED ROWS

Each row tested for naming its chapter and for leaving 00 and the index true today without the repair.

- Comstock 1949 (05, 04c, 05b, 04e): true today, and complete. grep of `comstock1949` over `book/*.qmd` returns 05:81, 04c:23, 04c:916, 05b:825, 05b:855, 04e:157, and 00:210, which is the report of Kadoumi. `R/14_cycles.R:8` names no author, so dropping it is right.
- 92 cached-files table: true today. It covers 55 of the 65 files; the ten absent are the ones the response lists, so "tabulates most" (index:171) holds without the repair.
- 92 "single place" (`92:364`): contradicts index:180, and the index is the true side, so the row is correctly routed. `CLAUDE.md` carries the same sentence and is outside this review.
- 92:396, 07:257 ($F_{ST} = 0.15$ for the setting `fst`): lines confirmed. The index does not state the number in prose.
- 90, $F^{(t)}$: no such row in 90 today; 00:363-364 says local symbols are defined where they appear, so 00 is true.
- 08:167, 08:160-163: lines confirmed. 00:326-332 and 00:344-357 are true without them: the conditions are at `08:381, 08:403-406`, as ruled in iteration 2.
- "Candidate pool" (03, 04, 05, 05b): 00 and the index are true today, because neither states a rule of vocabulary that those chapters break. **The row is incomplete**: it also occurs at 05:829, 05b:1750, 07:481, 09:327, 10:45, 10:125, 10b:209, 10b:1184, 10b:1233 and `90:30` (the $p_0$ row). 03 also has further lines (329, 419, 441). Not charged here; the ledger needs them.
- New, for 04e / the script owner, not charged here: the header of `regenerate.R:27-31` attributes `mating_core_findings.csv` to the `sparsex` study.

## WHAT WAS VERIFIED

Scripts and copies in the session scratchpad. `R/`, `tests/`, `inst/`, `book/scripts/` have no diff against `origin/main`.

- 00 passage after the dropped sentence, 00:199-212: reads through. "this is the scheme" refers to the recycling paragraph; "They trace it" to Kadoumi et al.
- Kadoumi et al., full text, Europe PMC PMC12397178, fetched by me: "tester-based reciprocal recurrent selection (RSS), which had been conceptualized by Hull (1945)"; "also named modified reciprocal recurrent selection (MRRS)"; "Each group of inbreds serves as source material for within-group selection ... and provides testers for hybrid selection in the other divergent population"; "a distinct heterotic structure between groups ... (Comstock et al. 1949; ...)". Matches 00:207-211.
- File inventory: `ls book/data` 48, `ls book/figs` 17, 65 in all, all tracked.
- `regenerate.R` category: 24, counted from the `write.csv`/`png` calls whose destination is `data_dir`/`fig_dir`. `null.png` and `metric_correlation.png` are written to `fig_dir` but are not in `book/figs`, so they do not enter the count. Names that occur only in the header comment were excluded by reading.
- `run_mabc.R` category: 8. Header lines 15-25 and `main()` read; three tables and both figures from the predecessor, as `04b` states ("no full re-run has been diffed against them"). The four full-run tables date from commit e302107; the two paired tables from 06e653c.
- External category: 15 by the wildcard, 14 by content. The other 14 are simulation output by their columns (`mating_validation` compares against AlphaSimR, `sparse_validation` estimates against true components). The tables are read by 04e or 04f.
- No-writer category: 12. grep of each stem over `R`, `inst`, `book/scripts`, `tests`: only `cost_per_eval` matches, and that is the function and the two `report/` tables. No `write.csv`/`png` call in any `book/*.qmd`. `git log --all -S` over `book/scripts inst R` returns 0 commits for the nine stems tested (`cost_per_eval` excluded, as it is a function).
- "Other cost tables" (index:191-192): `cost_per_eval()` returns `metric, us_per_eval` for one scale; `book/data/cost_per_eval.csv` has `L, N, m, n_sel, metric, us, f_matrix_GB, f_formed` over ten scale rows up to $N = 22500$. True.
- Not-simulation category: `bibliography_*`, `plant_metric_usage` (metric counts), `plant_lit_landscape.png` (read by 93 as the literature's metric use), two hand-extracted sparse tables. True for these six; one file is missing, 00-D27.
- `limits_linked.csv`: `regenerate.R:616-647` calls `alphasimr_founder_pools()`, which calls `runMacs2` (`R/13_alphasimr_bridge.R:80`). It is the only `regenerate.R` target on MaCS (grep). Later targets reseed (`set.seed(4242)`, `4040`, per-seed in `joint`), so the stream left by MaCS does not reach them.
- index:203-205, "marked where they appear": outside 04c, MaCS founders reach the book only through `limits_linked.csv`, read by 11c alone, which marks it (`11c:192-205`). 04d uses `quickHaplo()` and says so.
- index:208-209 against `07:255-262`: matches.
- Labels `sec-mating`, `sec-sparse`, `sec-alphasimr`, `sec-choosing`, `sec-limits`, `sec-verification`, `sec-bc-running`, `sec-programme` each resolve to one file (grep).
- `00-hybrid-programme.qmd` and `index.qmd` knit against `pkgload::load_all()` of the worktree, chapter seeds: 1.9 s, all `stopifnot()` pass; 0.5971 (s.e. 0.0014), 0.6116 (0.0012), 0.3458 (0.0018) against 0.5987, 0.6131, 0.3487, unchanged. No `book/Rplots.pdf` left.
- Downloads: `make_downloads.R` run on a scratch copy; `book/downloads/` identical to the worktree's, `.qmd` untouched.
- Regeneration, on a scratch copy of the worktree. `f2size`: `f2_results.csv`, `f2_multilocus.csv` byte-identical to the cached files. `cycles`: `cycles_trajectory`, `cycles_crossover`, `cycles_maxuse`, `cycles_injection`, `cycles_selector` byte-identical. `mating`: `mating_core_sweep.csv` byte-identical. `sparse`: `sparse_core_sweep.csv` byte-identical. Nine of the 24 files reproduced as tables. `cycles_gain.png` and `cycles_diversity.png` differ in bytes from the cached figures while the tables behind them do not; same dimensions, 0.06% and 0.16% of pixel values differ, by at most 1/255 and 4/255, which is rendering noise and not content.

## NOT VERIFIED

- Comstock, Robinson & Harvey (1949): not read. Not decisive for 00; decisive in 05, 04c, 05b, 04e.
- 00-B7 to 00-B12: unchanged from iteration 2, UNVERIFIED, non-decisive. @hull1945 not read; 00 reports only Kadoumi's statement of it.
- Re-run of `search`, `genpred`, `limits`, `joint`, and of `run_mabc.R`: not run. Non-decisive: the index says these scripts write those files, which the code confirms, and does not claim the numbers repeat. Tables with wall-clock columns cannot repeat in any case.
- No `quarto render`: cross-references checked by grep of labels only. Non-decisive; the render at close covers them.
