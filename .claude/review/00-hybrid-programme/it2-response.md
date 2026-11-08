# 00-hybrid-programme -- iteration 2 response (quant-writer)

Files changed: `book/00-hybrid-programme.qmd`, `book/index.qmd`, `book/_common.R` (comment only), `book/references.bib` (`hull1945` only), `book/downloads/` (regenerated). No later chapter touched. `R/`, `tests/`, `_freeze/`, `docs/` untouched. One chunk edited: a comment in `hp-drift`; no code changed.

| ID | Status | What changed, or evidence |
|---|---|---|
| 00-D24 | fixed; owed -> 05, 04c, 05b | The sentence "This book ... does not assert" is dropped, not rescoped: the chapter never uses the term after 00:206-209, so "this chapter calls it" would be vacuous. 00 now ends at what @kadoumi2025 say ("They trace it to @hull1945 and cite @comstock1949 for the heterotic structure it builds"), the claims the verdict confirmed in their full text. Nothing in 00 now speaks for the book or depends on a later repair. Owed rows below |
| 00-B2 | fixed in 00; owed -> 05, 04c, 05b | No statement of 00 rests on the content of the 1949 paper. The paper stays unread (paywalled, not in `reference/`); see the RRS row below, where it is decisive |
| 00-D25 | fixed; owed -> 92 | index:168-177 replaced by five categories, each checked against the repo. Check: all 65 files of `book/data` + `book/figs` fall in exactly one category (24 regenerate.R, 8 run_mabc.R, 15 external, 12 no writer, 6 not simulation output), and the regenerate.R category equals the `.csv`/`.png` names literally written by `regenerate.R` (set difference empty both ways). `git log -S` over `book/scripts`, `inst`, `R` for the six no-writer names returns nothing, so no past writer is implied. Added beyond the verdict: `limits_linked.csv` is written by regenerate.R but starts from MaCS (`regenerate.R:617-624`, `11c:195`), so a re-run is a new draw; three `mabc_*` tables and both figures are the predecessor driver's (`04b:741-748`). "reproducible output from a simulated dataset" removed. "Relationships do not move" removed: exact identities hold under their assumptions; empirical relationships are tied to the settings of their chapter, with @sec-choosing (`07:257-262`) cited for transfer. "says exactly" removed: 92 omits files, so the index says it "tabulates most" |
| 00-D26 | fixed | 00:83 now: the superscript counts generations of the mating system under discussion, here selfings. 00:609-610: $\bar F^{(t)}$ "after $t$ generations of random mating". Comment at `hp-drift`: the plant-level coefficient on the scale $2P(\text{IBS}) - 1$ is renamed `within_t`, no longer $F$; `phi` and `rho` avoided because 90 uses both. Code and output unchanged |
| 00-M14 | fixed; owed -> 03, 04, 05, 05b | 00:368 "founding candidate set" (`p0 = colMeans(X)` over the hybrids, `R/00_data.R:163,172`). index:36 "a candidate set of 2500". Same residue at index:108, not named by the verdict, also fixed: "a set of near-copies" |
| 00-M15 | fixed | `_common.R:17` comment: the default of the live examples, with chapters that need another scale setting it in their own chunks. No code changed; downloads regenerated carry it |
| 00-M16 | fixed | index:83 now: diversity between the pools adds to the value of the hybrid only where it falls on loci with dominance, the wording of 00:72-74 |
| 00-M17 | fixed | Crossref, DOI 10.2134/agronj1945.00021962003700020006x: volume 37, issue 2, pages 134-145, author "Fred H. Hull". Footnote mark removed from the title (Crossref: `Corn<sup>1</sup>`). No key added. The paper itself not read |
| `08:167` | owed -> 08 | "This is where the largest share of pipeline diversity is lost" is unconditional, like `08:376, 451-452`; 00:326-332 conditions it on the cross-selection strategy |
| `08:160-163` | owed -> 08 | "found exactly the two opposite trends" against the Hamming result and the stated cause at 00:344-357 |
| 92 "single place" | owed -> 92 | "The script is the single place where the expensive computations live" is false: `run_mabc.R` holds the MABC scans, the external studies are elsewhere, and 12 cached files have no writer. Same defect as 00-D25 |

## Owed list added this iteration (for THREAD.md at close)

- 05 (`:80-81`), 04c (`:20-23`, `:916`), 05b (`:825`, `:855-860`), 04e (`:157`): each ties the line-based scheme to @comstock1949, as attribution of A3, as the RRS of DH lines judged by testcrosses, or as "@comstock1949's scheme" built on a decomposition over lines. **Comstock, Robinson & Harvey (1949) is decisive in these chapters** and has not been read. Each needs the paper read, or the claim rewritten as a report of what a read source says of it (as 00 now does through @kadoumi2025). This replaces the conditional row of `it1-response.md`. `R/14_cycles.R:8` asserts no attribution (verdict), so it drops off.
- 92, cached-files table: no row for `genomic_prediction_*`, `joint_*`, `limits_*`, `plant_lit_landscape.png`, `mating_core_findings.csv`, `search_anytime.csv`, and no writer stated for the files without one. The index's "tabulates most" is true without this repair.
- 92 (`:396`) and 07 (`:257`): "$F_{ST} = 0.15$" is the setting `fst`, so $F_{BN}$. Already under 00-C18; the index avoids the number.
- 03, 04, 05, 05b: "candidate pool" for the hybrid set (`03:29, 03:412, 04:15, 05:735, 05b:195`, and figure label `fig-candidate-pool`), against the vocabulary of 00-D17, 00-C13.
- 90: the $F^{(t)}$ row of 00-C8 carries the meaning now at 00:83.

## Verified

`Rscript book/scripts/make_downloads.R` run from the worktree root. `00-hybrid-programme.qmd` and `index.qmd` knit against `pkgload::load_all()` of the worktree, to the scratchpad: no error, all `stopifnot()` pass, values unchanged (`gca_err` $3.7 \times 10^{-13}$; retained 0.597, 0.612, 0.346). `book/Rplots.pdf` absent. No `quarto render`, so the cross-references new to the index (@sec-limits, @sec-bc-running, @sec-mating, @sec-sparse, @sec-alphasimr, @sec-choosing) are checked only by grep of their labels.

## Seen, not changed

`CLAUDE.md` ("`book/scripts/regenerate.R` is the only place the expensive computations live") carries the sentence owed to 92. Project instructions, not mine to edit.
