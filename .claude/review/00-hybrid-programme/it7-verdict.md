# 00-hybrid-programme -- iteration 7 verdict

Scope, as authorised: only the prose, table and label changes the form pass made after the iteration-6 APPROVED. `00:n` is a line of `book/00-hybrid-programme.qmd` and `index:n` a line of `book/index.qmd`, both in the working tree.

```
VERDICT: APPROVED
```

No new ID. The diff has no defect under criteria 1-7, and nothing else was reopened.

## How the diff was identified

The two reports were checked against surviving pre-edit copies in the session scratchpad, not taken on trust.

- `it3/dl/book/00-hybrid-programme.qmd` (17:04) against `before.qmd` (17:44): exactly the 11 chapter-side mechanical fixes of editor.md, and nothing else.
- `before.qmd` against the working tree: exactly the five E-fix sites (`00:239`, `00:245`, `00:356-357`, `00:578-579`, `00:682`).
- `knit/index.qmd` (17:21) against the working tree: the two index fixes (`index:179`, `index:186`), plus the sentence at `index:201-203` already closed under 00-D29.

## PREVIOUS IDS

- 00-D29 -- CLOSED -- closed at iteration 6. This diff touches `index:179` and `index:186`, not that sentence.
- All other 00-D and 00-M IDs -- CLOSED -- the diff touches none of them. 00-D23 sits next to the E6 sentence; the pointer at `00:357-359` is unchanged.

## DISQUALIFYING FAILURES

None.

## NON-DISQUALIFYING OBSERVATIONS

None.

## THE TWO SCIENTIFIC WORDING CHANGES

**00-E6, `00:356-357` -- passes.** The reading is correct. The paragraph at `00:333-341` sets out two things: drift alone in two closed pools, and drift with selection in `run_cycles()`, "neither ... isolated". The new wording names both, and the scope of the claim does not change.

- Abstract of @vanheerwaarden2012 (PubMed 22802642): it reports "increasing genetic separation of breeding pools" and "ongoing divergence from a relatively homogeneous landrace population", and says "selection has had limited impact on genome-wide patterns of diversity and ancestry". It names neither drift nor closed pools. At abstract level the negative holds.
- The sentence stands on its verb. I went beyond the abstract, because the PMC page returned the full text. The word "drift" does not occur on that page, but the Discussion does give a cause: "The strong differentiation observed in the modern era 3 lines is likely the result of the use of smaller numbers of more closely related breeding lines and limited genetic exchange among heterotic groups in the last two eras." That is a drift-like account in nearly closed pools, offered as "likely" and not tested, so "establishes" remains true. "Limited" exchange is also not "closed", and the same paper says group-specific selection was not mapped. The book attributes nothing false to the authors, so this is not a failure. The sentence would not survive a stronger verb, such as a claim that the study gives no support to the mechanism.
- @kadoumi2025 (PMC full text) supports the "alone or with selection" limb directly: "disentangling drift and selection can be challenging", and further work is needed to "separate selection-related effects from stochastic-linked demographic processes (e.g., genetic drift)". `00:352` already says NSS was not closed.

**00-E4, `00:578-579` -- passes, and 00 is true today with 08 still printing $\theta_B$.**

- Same quantity. For two pools, `theta_decompose()` gives $\theta_B = 2 w_A w_B \theta_{AB} / (1 - w_A^2 - w_B^2)$. Since $1 - w_A^2 - w_B^2 = 2 w_A w_B$ when $w_A + w_B = 1$, this is exactly `theta[A, B]`, whatever the pool sizes (`R/05_pipeline_metrics.R:66-77`).
- Agrees with 90. `90:205,226` define $\theta_{AB}$ as coancestry between the pools, $\mathbf{w}_A'\mathbf{f}^L\mathbf{w}_B$, and $\theta_B$ as coancestry within pool B. 05, 05b and 06 use the symbols the same way. Before the rename, 00 clashed with all of these; `00:364` says shared symbols follow 90, and that is now true of this symbol.
- True today. `00:577-580` states what 08 logs as a quantity, and defines its symbols in place. It makes no claim about the symbol 08 prints. 08's $F_{ST}^{(W)}$ at `08:91` is that quantity, and `08:93` says in words that it references between-pool coancestry, so a reader can match the two. The symbol difference between 00 and 08 is real, but the defect is 08's clash with 90. It predates this diff and is routed below.

## OWED ROWS

Not charged here.

- **08 (00-E4):** rename $\theta_B$ to $\theta_{AB}$ at `08:91` and `08:105`. The response also lists `08:93`, but that line carries no symbol. Until this is done, 00 and 08 print different symbols for one quantity, and 08's $\theta_B$ contradicts `90:205,226`. An open row for the continuity pass.
- **08 / package (00-E4):** `theta_decompose()$theta_B` is between pools, `theta_pools()[["theta_B"]]` is within pool B. With more than two pools the first is a weighted mean of pair means (checked on three pools).
- **90 (00-E5):** decide on rows for $\theta_w$, $G_{ST}$ (used in 00, 05, 08; confirmed absent from 90) and $\bar y_{ij}$, $\bar e_{ij}$ (used in 00, 04e). Until then `00:364` does not hold for these shared symbols, although each is defined where used.
- **Close of the book (00-E1, 00-E2, 00-E8):** book-wide production items, not touched. The close must also re-render `fig-hp-cycle` and `hp-drift` in both formats, since the freeze and `docs/` hold the old output.
- **Carried from iteration 6, not re-examined:** 04f-D1; `92:343` (for 92); `04e:82-83` (for 04e); the source-bundle rows.

## WHAT WAS VERIFIED

Scripts and outputs are in the scratchpad directory `it7/`. Seeds are stated where one applies.

- $\theta_B$ against $\theta_{AB}$, `e4.R`, `pkgload::load_all()` of the worktree (namespace path printed). Unequal pools (12 + 18 lines, 200 loci, seed 1, my own generator): `theta_decompose()$theta_B` 0.505972, `mean(f[A, B])` 0.505972; within pool B 0.604444, so the two meanings differ. `Fst_Wright` 0.217824, recomputed from those means 0.217824.
- Book data (`book_cfg`): `theta_pools()` on the complete factorial gives theta_A 0.7046656, theta_B 0.7063424, theta_AB 0.6383104; `theta_decompose()$theta_B` 0.63831040, difference 0.00e+00 from theta_AB. The uniform-weight case of the definition at 90 is therefore the quantity 08 computes.
- "Near twice" at `00:580`, unchanged wording, rechecked after the rename: `Fst_Wright` / `Gst_Nei` = 1.814 at book scale, 1.8135 on the unequal pools.
- Three pools (8 + 10 + 12): `theta_B` 0.5338176 against pair means 0.53725, 0.50167, 0.55725.
- Scratch render, `quarto render 00-hybrid-programme.qmd --to html` on a copy of `book/` (Quarto 1.10.18); all 19 knit steps ran. `@sec-hp-ibd` prints "Section 1.2.3" and `@sec-hp-inbreeding` "Section 1.2.4", each id used once; those sections hold what the references promise (group coancestry at `00:531-533`, $F_i$ at `00:537`).
- Of the 86 unresolved-reference warnings (43 keys), a script found no key with a target in chapter 00 and none without a target somewhere in the book. They are other-chapter references that a single-file render cannot resolve.
- 00-E3: the rendered page has 0 `kable-table` blocks. `round(dr, 4)` prints a console echo: 0.5971 / 0.0014 / 0.5987; 0.6116 / 0.0012 / 0.6131; 0.3458 / 0.0018 / 0.3487. The prose values 0.597, 0.612, 0.346 are unchanged.
- 00-E7: rendered `fig-hp-cycle-1.png` inspected. It shows "to DH lines" and "A × B crosses", with no overlap, and agrees with the caption.
- "Set of quantitative trait loci" at `00:40`: the example does give every marker a dominance deviation (`hp-gca-tester`); it is the only use of the term in the chapter. `@sec-hp-cycle` contains that example. `@eq-hp-gca-sca` at `00:196` is the partition the sentence means.
- "The chunk takes", "The chunk measures": each is followed by the chunk meant. No "chunk below", "defined below", "next subsection", "as above" or "the mechanism above" remains in the chapter.
- `($-2.33$%)`: (0.420 - 0.430) / 0.430 = -2.3256%, and the Kadoumi text gives -2.33%. "Homogenisation" is a paraphrase, not a quotation.
- MaCS expansion at `index:179`: PubMed 19029539 reads "MaCS (Markovian Coalescent Simulator)". It is the first use in `index.qmd` (next at `index:207`).
- `index:186`: the two core sweeps are named at `index:176-178`, and the three literature tables are `sparse_primary_studies.csv`, `sparse_literature_parameters.csv` and `mating_core_findings.csv`. All five files exist in `book/data`.
- Table column specs at `00:180` and `00:739`: alignment only, three columns each, no cell changed.
- `book/downloads/00-hybrid-programme.R` carries the new strings for all edits checked by grep, and none of the old ones.
- E5 facts: grep places $\theta_w$ or $G_{ST}$ in 00, 05, 08 only, and $\bar y_{ij}$ or $\bar e_{ij}$ in 00, 04e only. `90:378` declares the local symbols of @sec-sizing.
- No `book/Rplots.pdf`; `git status` shows nothing new under `book/_freeze` or `docs`.

## NOT VERIFIED

None of these is decisive.

- The supporting information of @vanheerwaarden2012 was not read. The check asked for was abstract-level, and the main text was read by search for the relevant terms, not line by line.
- The response's 0.518287: it does not give its generator, so I did not reproduce the number. The identity is algebraic and held on my own data, and the number is not in the book.
- No Typst render, so `hp-drift` as an echo and the new section references are unobserved in the PDF. Check at the close.
- The scratch render used the installed `hybdiv` 0.1.0, not `load_all()`. The worktree has no change under `R/`, and the printed values match the response's knit.
