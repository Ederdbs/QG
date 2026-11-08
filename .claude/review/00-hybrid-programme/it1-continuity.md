# Continuity report: 00-hybrid-programme, iteration 1

Scope: `book/00-hybrid-programme.qmd` against `book/index.qmd`, `book/90-notation.qmd` and every
chapter it points to, in `_quarto.yml` order. `THREAD.md` has no entries and no `Owed` items, so
there is nothing to settle from it. Checks applied: 1-4, 6, 8, plus the opening, part order and
roadmap. Line numbers are those of the worktree files.

Severity follows the agent definition strictly: any contradiction in notation, definition, number
or assumption, and any broken promise, is H.

## Summary

| Owner | H | M | L | Total |
|---|---|---|---|---|
| this chapter (00) | 3 | 10 | 6 | 19 |
| earlier chapter (index) | 1 | 1 | 3 | 5 |
| later chapter | 4 | 3 | 4 | 11 |
| Total | 8 | 14 | 13 | 35 |

Later-chapter owners: 90 (C8, L: C33), 05 (C6, C22), 08 (C1, L: C35), 11b (C5, C19), 06 (C28),
05b/07/08/11/12/92 together (C18), 01/04e/06/08 together (C25).

## H findings

**00-C1 (H, owner: later, 08-pipeline-stages).** $F_{ST}$ has two definitions under one letter.
- `00-hybrid-programme.qmd:471-473`: "in this book $GD_{BS}/GD_T$". Same in `90-notation.qmd:123`, `02-subdivided.qmd:219,255-258` (there called Wright's fixation index), `06-metric-catalogue.qmd:387`.
- `08-pipeline-stages.qmd:91-96` calls that same form $G_{ST}$ and gives the name $F_{ST}^{(W)}$ to $(\theta_w-\theta_B)/(1-\theta_B)$, about twice as large (`08:111`). `08:131` logs `Fst = dd$Fst_Wright`, and "Hold $F_{ST}$ in a band" (`08:140`) and the checklist (`08:439`) rest on it. Code: `R/05_pipeline_metrics.R:78-79`.
- `05-genomic-era.qmd:1487-1490` already reconciles them ("Nei $G_{ST}$ form"); 08 does not, and 02 and 08 attribute the two forms to Wright in opposite ways.
- 00's "in this book" is false as long as 08 reads as it does. 08 should change; 02's attribution should be checked in the same pass.

**00-C2 (H, owner: this chapter; premise of 04 to be settled with it).** S2 points to a chapter that treats a different cross under different assumptions.
- `00:153` lists @sec-sizing as where S2, "choosing parents and crosses for DH induction", is treated. `00:164-169` and A3 require crosses within a pool, and forbid material derived from an A x B hybrid.
- `04-population-sizing.qmd:15-18,27-31` sizes "a wide biparental cross between two divergent heterotic groups", carried F1 to F4 by SSD. The chapter contains no DH, no S2, and no choice among crosses (a search for `DH`, `doubled` and `S2` returns nothing relevant). It sizes one cross, already chosen, of the kind `00:167-169` rules out.
- The S2 material is in `08:165-258`. `index.qmd:104-106` makes the same use of @sec-sizing as the source of the candidate panel.
- The row in `00:153` should change; if 04 is to stand as the sizing of a programme population, the A3 conflict of `04:28` must be stated there (carry to `Owed` for 04).

**00-C3 (H, owner: this chapter).** A drift-only result is cited for selection.
- `00:273-276`: "within-pool selection and drift push the two pools' frequencies apart, so between-pool divergence tends to grow while within-pool diversity falls (@sec-subdivided)".
- `02-subdivided.qmd:354-359` derives this "under drift alone" and ends "Selection is not covered by this argument." `06-metric-catalogue.qmd:399-418` measures a $GD_{BS}$ rise under truncation and says "its cause is not isolated here". The empirical citation in 00 attributes little of the pattern to selection (`00:280-281`).
- `08:69-71` repeats the selection reading without citing a derivation and should be aligned with whatever 00 does.

**00-C4 (H, owner: this chapter).** Broken promise: van Heerwaarden in the literature chapter.
- `00:281-282`: "@sec-plant-literature places these results among the rest of the plant literature", after citing @kadoumi2025 and @vanheerwaarden2012.
- `11-plant-literature.qmd:134-138` has Kadoumi. @vanheerwaarden2012 appears nowhere in the book except `00:280`. The corpus of 11 is 2017-2026 (`11:15-16`), so a 2012 paper falls outside it; that is why the pointer in 00 is what should change.

**00-C5 (H, owner: later, 11b-diversity-across-cycles; 11c follows).** Broken promise, and @eq-hp-drift's $N_e$ reused at a different level.
- `00:530-532`: selection makes the realised rate larger than drift; "@sec-cycles measures that across cycles". `00:494-501`: a pool re-derived as $n$ DH lines has $\Delta F = 1/n$, $N_e = n/2$, for one population.
- 11b has no neutral reference for the rate: `11b:238-253` compares budgets only, and calls the unconstrained fit "meaningless". Nothing there attributes the rate to unequal contributions.
- Recomputed from `book/data/cycles_trajectory.csv` with the `11b:238-243` regression: $\Delta F$ = 0.029, 0.036, 0.026 per cycle and $N_e$ = 17.1, 14.0, 18.9 for unconstrained, 0.020, 0.005. With 25 DH lines per pool (`11b:88`), @eq-hp-drift gives $\Delta F$ = 0.04, $N_e$ = 12.5. Read against 00, selection *lowers* the rate.
- Cause of the mismatch: `R/14_cycles.R:132,144` takes `F_drift` from `freq_metrics()` on the merged selected hybrids (`05:208-212`). The merged frequency $(p_A+p_B)/2$ of two independent pools has half the drift variance of one pool, so the rate is not on the scale of @eq-hp-drift. `11b:261-263` ("realised effective size") and `11c:33-46` (Robertson's limit from that $N_e$) use it as if it were.
- 11b should supply the reference and state the level; if it will not, `00:531-532` must lose the pointer.

**00-C6 (H, owner: later, 05-genomic-era; `00:27` follows).** "Markers neutral" contradicts how the book's traits are built.
- `00:27` and `05-genomic-era.qmd:91` (A5): markers are neutral.
- `03-simulating-crosses.qmd:16-18`: the traits have "correlated effects at every marker". `R/00_data.R:129-130` confirms it, and `06-metric-catalogue.qmd:404-406` says the index is a linear combination of marker effects. Selection on the index therefore acts directly on the frequencies of every marker the metrics read. `00:116` likewise gives every marker a $d_k$.
- 00's own chunks do not select on the index, so 00 is unaffected numerically, but it declares the programme of every later chapter to be A1-A8 (`00:18-19`). `simulate_pools()` (300 QTL, `02b:62`) is the partial exception, and the assumption needs to say which simulator it covers.

**00-C7 (H, owner: earlier, index).** "Every live example" scale is false.
- `index.qmd:157-159`: "Every live example in the book runs at ... 25 lines per pool and 2000 markers, giving 625 candidate hybrids".
- Against: `08-pipeline-stages.qmd:32` (30 + 30, 3000 markers), `04c-alphasimr-pipeline.qmd:7-9` (12 + 12), `10b-advanced-selection.qmd:1045` (10 + 10, 400), `92-verification.qmd:30` (20 + 20, 1500), and the 200 x 200 running example computed live in `04e-mating-design.qmd:1065`. `00:30-33` is correctly limited to this chapter.

**00-C8 (H, owner: later, 90-notation).** Broken promise: "every symbol used above".
- `00:582-583`: @sec-notation "collects every symbol used above, with the function that computes it"; `00:287`: "Symbols follow @sec-notation".
- No entry in 90 for: $F_t$, $F_0$ (`00:60`); $GD_S$ and $GD_{\text{ref}}$ as rows of their own (they occur only inside `90:282,290`); $\bar y_{ij}$, $\bar e_{ij}$ (`00:87`); $H_t$, $H_0$ in the sense of `00:488,493` (the only $H_t$ row is `90:351`, the sizing-local one, with another meaning); $q_{0,k}$ (`00:382`). S1-S4 are in no table either.
- Many Function cells of 90 are "-" (for example `90:96-97`), including for $H_o$, $n_{gam}$, $\Delta F$, $N_e$, so "with the function that computes it" also does not hold as written; that clause sits at `00:583`.

## M findings

**00-C9 (M, owner: this chapter).** The reading map hides that @sec-programme is not a hybrid programme.
- `00:577` ("what does a whole programme spend across cycles") and `index.qmd:134`, against `04d-breeding-programme.qmd:16-21`: an inbred-line wheat scheme whose product is a variety.
- `00:18-19` says the programme described is A1-A8, and A1 excludes exactly this (`05:46-52`: "Nothing here is addressed to a self-pollinated crop whose product is a line"). `index.qmd:117` does say it; the map does not.

**00-C10 (M, owner: this chapter).** Per-se selection against testing in cross, and a cycle the four stages do not cover.
- `00:76-78`: "A line is not worth what it yields on its own". `00:154`, `08:260-275`: S3 selects lines per se. `05:79-81` (A3): lines are chosen on hybrid performance. 00 never says why both occur or in what order, beyond the arrows of @fig-hp-cycle.
- `00:146` says the stages divide a cycle, but the trials box (`00:196`) and recycling (`00:164-170`, the selection step that decides the next cycle) belong to no stage. `11b:105-106` (C8) has no S3 either, while `00:170` presents `run_cycles()` next to the full cycle without that limit.

**00-C11 (M, owner: this chapter).** Divergence stated as the source of value, in the form 05b corrects.
- `00:53-55`: the value of a cross depends on complementarity, "and that complementarity depends on the two pools' allele frequencies differing (@sec-heterosis)".
- `05b-heterosis-dominance.qmd:25-28` calls that reading false under neutral divergence; also `index.qmd:60-62`, `90:598-601`. `00:552-554` carries the qualification, 500 lines later. The citation at `00:55` points to a chapter that rejects the unqualified claim.

**00-C12 (M, owner: this chapter).** $GD_T$, $GD_{BS}$ and $GD_{WI}$ are used without definition, and $GD_T$ is a second name for $GD_S$.
- `00:14`: "Each is defined once". `00:226,315` define $GD_S$. `00:351,355,472,548` then use $GD_{BS}$, $GD_T$, $GD_{WI}$ with no definition, and never say $GD_T$ of a set is $GD_S$.
- `index.qmd:98` calls the same quantity $GD_T = 1-\theta$; `90:77,111` give it as $GD$ and $GD_T$ in separate tables.

**00-C13 (M, owner: this chapter).** "Pool" names two things, and $N$, $n_{sel}$ a third use.
- Heterotic pool: `00:49-51`. Candidate hybrid set: `00:219-229,257,261` and the chunk at `00:236-241`, where "the pool" is the 625 hybrids. `00:224` says "the pool's mean self-coancestry" of what `00:252` calls "hybrids".
- `00:219` extends $n_{sel}$ of $N$ to "members of a pool" at every step; `90:17,20` reserve them for hybrids. S2 is not a subset of the members either: `00:267-268` makes each DH a new gamete.
- `index.qmd:20` and `90:20` also say pool for the candidates.

**00-C14 (M, owner: this chapter).** The $F_{drift}$ and $F_{hom}$ descriptions do not match what 05 computes.
- `00:466-470`: $F_{drift}$ is "a property of a pool *through time*"; $F_{hom}$ is "the proportional loss of heterozygosity".
- `05-genomic-era.qmd:208-223`: computed on the merged hybrid set, gene diversity of a notional pool, "not the heterozygosity of the product"; also `05:1827,1845`. `05:229` and `06` apply both to one-cycle selections, so "through time" is not their only use. 00 has just separated $H_e$ from $H_o$ (`00:321-324`), which makes the unqualified word misleading.

**00-C15 (M, owner: this chapter).** "Largest share at S2" holds under one strategy only.
- `00:270-273` states it without the strategy; `08:381-383` limits the 77 % to merit-only.
- Means of `book/data/pipeline_loss_ledger.csv`: `UC only` S2 77.5, S3 2.5, S4 20.0; `UC + div` S2 35.5, S3 29.0, S4 35.5, a tie. `08:376,451-452` are unconditional too (carry to 08's review).
- The ledger covers S2-S4 and omits recycling, which `00:269-270` has just listed among the steps of loss.

**00-C16 (M, owner: this chapter).** $F_t$ means two things, one generation apart.
- `00:60-64`: $F_t$ is the inbreeding coefficient after $t$ selfings, $F_6$ = 0.9844.
- `04c-alphasimr-pipeline.qmd:705-708` and `90:554`: $F_t$ is the filial generation, with heterozygosity $(1/2)^{t-1}$, so filial F6 has inbreeding 0.969. `00:69` uses F1 in the filial sense in the next paragraph, and 04 uses F2 to F4.

**00-C17 (M, owner: this chapter).** "Forward pointers are marked as such" is not checkable as stated.
- `00:581-582`, verbatim at `index.qmd:123-124`.
- Word-level heuristic (will, later, forward, ahead, below, part): 137 citations to a later part from Foundations onward, 19 on a line with such a word. Examples with no mark: `01:170-171`, `02:12`, `02:672-673`. The heuristic undercounts, since tense can mark too, but the sentence is a universal claim.

**00-C18 (M, owner: later, 05b, 07, 08, 11, 12, 92).** $F_{BN}$ has two symbols by declared exception.
- `00:474-477` separates $F_{BN}$ from $F_{ST}$ and uses them as different things. `90:154-157` then tells the reader to read $F_{ST}$ as $F_{BN}$ in six chapters: for example `07:87,257`, `08:359`, `12:179`. 03 uses $F_{BN}$ throughout; 05b uses both (8 and 46 lines).
- 90 discloses the clash but does not remove it, and C1 makes $F_{ST}$ in 08 three-valued.

**00-C19 (M, owner: later, 11b; 11c follows).** $\Delta F$ read as $-$slope, against 05's rule.
- @eq-hp-drift gives $N_e = 1/(2\Delta F)$ (`00:533`). `05:1045-1050` and the checklist `05:1850` require $\Delta F = 1-e^{\text{slope}}$, "rather than $-$slope".
- `11b:241-242` and `11c:41` use $-$slope. The effect is small (unconstrained $N_e$ 17.1 against 17.4), but it is the rule the book states.

**00-C20 (M, owner: earlier, index).** "Every plan that raises one lowers the other" is not established.
- `index.qmd:85-87`, citing @sec-subdivided and @sec-catalogue. `02:354-359` derives the trade for drift alone and excludes selection. The five selections of `06:387` show no plan raising both, but `trunc_cap` lowers both against `random`; that is an observation on one data set, not a result about every plan.

**00-C21 (M, owner: this chapter).** The four assumptions restated are not the four used, nor quite the ones declared.
- `00:19`: "The examples below use four of them". They also use A8, the scale (`00:30-33`), and the frozen base of A6 is stated at `00:290,467-468`.
- `00:22-23` assigns "closed breeding units" to A1; `05:46-52` does not say it, and closure appears as C6 at `11b:98`, with injection allowed. A1's "allogamous" and A5's linkage equilibrium (`05:91-94`) are dropped.
- A7 and A8 are scoped to "this chapter" in 05 (`05:101,106`), so "the programme ... A1--A8" (`00:18`) reads wider than they were written; 00 itself uses dominance at `00:100-116`.

**00-C22 (M, owner: later, 05-genomic-era; 06 and 12 follow).** "Production scale" has two values, inside the A8 that 00 adopts.
- `05:108-109`: 71 + 71 lines, 25000 markers. `12-case-study.qmd:34-36` and `06:620`: "the production scale of `sim_config`", which is 50 + 50 and 5000 (`R/00_data.R:17-19`). `index.qmd:35` (2500 hybrids) follows the second.

## L findings

**00-C23 (L, owner: this chapter).** `00:155`: the S4 row omits @sec-advanced, where `10b` continues the S4 problem, and @sec-genomic-prediction, which `08b:43-44` ties to S4. `00:161` credits testing in cross alone with the predicted values.

**00-C24 (L, owner: this chapter).** Three systems of "stage" are in use and `00:147` warns of none: S1-S4; the package's stage 1 and stage 2 (`03:36-40`, `91`); the trial stages of `04f:99-103,134-135,1252`.

**00-C25 (L, owner: later, 01, 04e, 06, 08).** The chapter claims to own definitions the book does not cite back.
- `00:14-16`: "defined once". Only @eq-hp-drift is cited outside 00 and 90 (`05:999`). @eq-hp-gd, @eq-hp-gca-sca, @eq-hp-ibs-ibd and @tbl-hp-stages have no outside citation.
- Restated in place: `01:149-153,166-171`; `04e:162-165` (the model, unnumbered, same equation as `00:86-88`); `06:92-94`; `08:16-21` (the table, verbatim) and `08:40-48`. 00 should own the definitions and these should cross-reference; the derivation in 06 stays, as `00:320` says.

**00-C26 (L, owner: this chapter).** `00:371-373`: "every diversity metric in the book is computed on" $\mathbf{f}$. Against `05:76-77` ("Everything below is computed on frequencies"), `03:49-50` (frequency-based metrics need `X`), and $F_{drift}$ at `00:466`. `01:320` repeats it and should follow.

**00-C27 (L, owner: this chapter).** `00:263-264`: $GD_{\text{ref}}$ is "the gene diversity of a random subset". `06:570` and `90:290`: the *mean* over random subsets.

**00-C28 (L, owner: later, 06).** One quantity, two symbols: $GD_{\text{ref}}$ (`00:262`, `90:282`) and $GD_{\text{random}(n)}$ (`06:568`, `90:280`), disclosed at `06:570-572`.

**00-C29 (L, owner: earlier, index).** The budget is written $\alpha$ at `index.qmd:23,40,97`; `00:160,263` and `90:283` keep $\alpha$ for the loss and $\alpha_{\max}$ for the budget.

**00-C30 (L, owner: earlier, index).** `index.qmd:50-52` says "breaks both assumptions" and lists three bullets; `00:544` says "three ways" and "each stated in the preface".

**00-C31 (L, owner: earlier, index).** Chain against part order. `index.qmd:79-121` says the parts assemble a chain, but item 5 cites @sec-mating and @sec-sparse before item 6 cites Optimisation, while `_quarto.yml` and `00:575-576` have Optimisation first. @sec-joint, @sec-genomic-prediction, @sec-plant-literature and @sec-case-study are not in the chain.

**00-C32 (L, owner: this chapter).** Two bases under $p_{0,k}$: the frozen candidate-pool frequency (`00:290`, `90:19,30`) and the base of a pedigree (`00:374-376`). `90:203` adds a third symbol, $p_0^{(0)}$, for `ctx$p0`, used nowhere else.

**00-C33 (L, owner: later, 90-notation).** $g^A_i$ and $\mu$ cover two quantities: all of the GCA on $\bar y_{ij}$ (`00:87`, `04e:178`, `90:427`) and its dominance part on $H_{ij}$ (`05b:784-789`, `90:216,229`). `00:100-101` handles it in prose; 90 does not link the two rows.

**00-C34 (L, owner: this chapter).** `00:560-561` promises "which assumptions of the animal-breeding results fail"; `05:1806` covers the assumptions of the simulation of one paper, @meuwissen2020.

**00-C35 (L, owner: later, 08).** `08:352` labels `ne_parents_from_counts()` as `Ne`, which is $N_{e,\text{par}}$ in `90:79`. `00:533` reserves $N_e$ for a size defined by a rate.

## Checked and consistent

- Opening: `00:8-9` says why the chapter follows the preface.
- Reading map `00:570-577` matches `_quarto.yml` part for part and chapter for chapter; no stale ordering in 00. Part names in `00:162` and `index.qmd:128-134` are current.
- All 50 `@sec-`, `@eq-`, `@tbl-`, `@fig-` targets cited by 00 resolve, and all those of `index.qmd`; no broken `@sec-` target in the book.
- Promises kept: A1-A8 exist (`05:46-110`); @eq-hp-gca-sca is the model of `04e:164`; GCA form `00:100` = `04e:178`, dominance part = `05b:788`; `00:108` is the draw of `05b:15-16`; subset bias `00:224` = `06:525`; @eq-hp-gd = `06:94`; $H_o = GD_T + GD_{BS}$ = `05b:287,311` on the complete factorial; DH factor of two = `05:999-1003`; @tbl-hp-stages names = `08:16-21`; `sec-plant-literature` on assignment = `11:118-130`; the animal contrast = `11:69`; $N_s$ as a static descriptor = `11b:258`.
- $s_i$, $F_i$, $F_{(ab)}$, $H_o$, $n_{gam}$, $\Delta F$, $N_e$, $\bar f_d$, $\bar f_o$ agree with 90.

## Inbound `@sec-` count

Citations from another file only, each `@sec-` resolved to its owning file. `Self` is excluded from
`Inbound`. `99-references.qmd` and `index.qmd` own no `{#sec-}`.

| Chapter | Inbound | Citing files | Self |
|---|---|---|---|
| 00-hybrid-programme | 9 | 7 | 1 |
| 01-coancestry | 25 | 14 | 1 |
| 02-subdivided | 40 | 14 | 2 |
| 02b-response | 28 | 14 | 0 |
| 05b-heterosis-dominance | 78 | 21 | 55 |
| 03-simulating-crosses | 26 | 16 | 0 |
| 04-population-sizing | 18 | 10 | 7 |
| 04b-backcross-introgression | 7 | 7 | 6 |
| 04c-alphasimr-pipeline | 20 | 11 | 0 |
| 05-genomic-era | 39 | 16 | 51 |
| 06-metric-catalogue | 42 | 18 | 0 |
| 07-choosing-metrics | 46 | 20 | 0 |
| 08-pipeline-stages | 37 | 18 | 0 |
| 08b-genomic-prediction | 24 | 14 | 15 |
| 09-optimal-contributions | 37 | 16 | 0 |
| 10-combinatorial-selection | 31 | 14 | 0 |
| 10b-advanced-selection | 24 | 8 | 17 |
| 04e-mating-design | 57 | 8 | 10 |
| 04f-sparse-testing | 36 | 6 | 12 |
| 04g-joint-allocation | 11 | 4 | 28 |
| 11-plant-literature | 15 | 8 | 0 |
| 04d-breeding-programme | 17 | 6 | 0 |
| 11b-diversity-across-cycles | 48 | 20 | 0 |
| 11c-limits | 17 | 9 | 0 |
| 12-case-study | 21 | 15 | 0 |
| 90-notation | 18 | 7 | 0 |
| 91-package | 0 | 0 | 0 |
| 92-verification | 5 | 5 | 1 |
| 93-corpora | 2 | 2 | 0 |

Zero or one inbound: `91-package` (0). Broken `@sec-` targets: none. Of the 9 inbound citations of
00, four are from 90 and the index, and `sec-hp-not-animal` and `sec-hp-reading-map` have none (see C25).
