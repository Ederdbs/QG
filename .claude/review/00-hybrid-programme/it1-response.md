# 00-hybrid-programme -- iteration 1 response (quant-writer)

Files changed: `book/00-hybrid-programme.qmd`, `book/index.qmd`, `book/references.bib`, `book/downloads/` (regenerated: `00-hybrid-programme.R`, and `06-metric-catalogue.R`, which was already stale against `06-metric-catalogue.qmd` on main; that second diff is not from this iteration's edits). No chunk code touched; the only `#|` lines edited are `fig-cap` and `fig-alt` of `fig-hp-cycle`. One new inline expression pair, `sprintf("%.2f", sd(g1))` and `sd(g2)`. Chapter knitted to scratch against `load_all()`: runs clean, prints 5.90 and 5.84.

Status words: `fixed`; `contested` (none); `owed -> <ch>: item` (later chapter, for THREAD.md; the wording in 00 is already true without it); `-> quant-Rwrite` (its row follows); `open` (primary source not reached; wording scoped or unchanged).

## Hand-off to quant-Rwrite (needs a chunk change)

- **00-D12, drawing of `fig-hp-cycle`.** Caption and alt text now say the dashed recycling arrows leave **S4**, not the trials box. The code still draws them from x = 73.5 (trials box). Move their origin to the S4 box (x 85-99, y 24-40), keeping clear of the triangle at (92, 41.8) and the "commercial F1" label at (92, 20.5). Caption and drawing disagree until this is done. The label is explicit, so nothing is orphaned.
- `hp-drift` comments (`:512-513` of the old numbering) still say "crossing block of 10 plants" and "pool re-derived as 10 DH lines"; the prose now states these are binomial chains with `n_gam` supplied and that neither scheme is simulated. If you add an individual-level arm (00-R6), the sentence "no crossing block or DH pool is simulated" and the sentence on selfing must change with it.
- `hp-ibs-ibd`: the code's `p0` is now the prose's $p_{b,k}$ (00-M10). `hp-subset-gd`: `gd_pool` and `sub_gd[["pool"]]` are the candidate set (00-D17). Names only; change or leave.

## Disqualifying

| ID | Status | What changed |
|---|---|---|
| 00-D1 | fixed | Closing paragraph of the drift section: "dimension of a count" removed; states $N_s$ is static and that on molecular $\mathbf f$, $\theta_S \in [1/2,1]$, so $N_s \in [1/2,1]$ whatever the set size, a monotone decreasing rescaling. Matches `06:151-157`, `90:627-630` |
| 00-D2 | fixed | $H_t$ defined on the set's frequencies; $\Delta F$ defined as the fraction of it lost per generation. New sentences: in random mating it is the rate of inbreeding; in a DH pool that ratio is $0/0$ and $\Delta F$ is a different object, the rate of rise of group coancestry, the same fraction by @eq-hp-gd. Follows from $E[2p'q' \mid p] = 2pq(1 - 1/n_{gam})$ |
| 00-D3 | fixed | "maximises the disagreement" removed. Now: tends over draws of $a_k$ to raise the correlation, given similar variances (s.d. printed inline), can lower it on one draw, so the value shown is not a lower bound |
| 00-D4 | fixed | `:53-55` and `:167-168` now condition on dominance: divergence adds value only where it falls on loci with dominance; under neutral divergence expected heterosis does not move (@sec-heterosis) |
| 00-D5 | fixed | "the coancestry-based metrics of the book"; added that frequency-based metrics such as $F_{drift}$ are not computed on $\mathbf f$ |
| 00-D6 | fixed | New paragraph after the assumption list: neutrality holds in this chapter's diversity examples because nothing selects on a trait; the GCA example makes the marker set the QTL set; the traits of `simulate_data()` have effects at every marker, so selection on that index acts on the markers read. Chunk lead-in says "every marker treated as a dominance locus". Owed part under 00-C6 |
| 00-D7 | fixed | List rewritten to restate all of A1--A8 as `05:46-110` declares them: "closed breeding units" removed, A1's allogamy and A5's linkage equilibrium added, A4, A6, A7, A8 added. Opening says A1--A8 are declared "for the numbers of that chapter" |
| 00-D8 | fixed | Prose now says the chunk iterates the binomial of @eq-hp-drift with $n_{gam}$ supplied, that the counts $2n$, $n$ are inputs, and that no crossing block or DH pool is simulated. Result reworded to "the chain with $n_{gam}$ = ...". Crossing block declared as random union with selfing allowed; excluding selfing stated to slow the decay, $N_e = n$ then approximate. DH lines declared as one gamete of a random pair |
| 00-D9 | fixed | Strategy condition stated: merit-only cross selection puts the largest share at S2; with a diversity term S2 and S4 are not separated by the founder pools. Ledger declared to cover S2--S4, not recycling, and to be read from a cached table. No number typed: the chapter does not read the file |
| 00-D10 | fixed | Causal clause and the pointer "measures that" removed. Now: selection is outside @eq-hp-drift and not measured here; @sec-cycles fits rates, all arms selected, $F_{drift}$ on merged frequencies, a different level, so not read against these values. Owed part under 00-C5 |
| 00-D11 | -> quant-Rwrite | Inline-value formatting (00-R1) |
| 00-D12 | fixed in prose, drawing -> quant-Rwrite | Recycling paragraph states the S4-to-next-cycle link and what $\alpha_{\max}$ acts on. "Implements it" replaced: `run_cycles()` is a reduced form, usage-driven recycling, no trials, no S3, index known without error (C7, C8). Caption: triangles mark steps where diversity *can* be lost, with the S4 reading stated. Section header and intro: "can be lost". See hand-off |
| 00-D13 | fixed | @sec-sizing removed from the S2 row. Owed part under 00-C2 |
| 00-D14 | fixed | "in this book" removed. $F_{ST}$ here and in @sec-subdivided is $GD_{BS}/GD_T$ [@caballero2002, Eq. 8, checked in the PDF]; states that @sec-stages names that form $G_{ST}$ and logs $(\theta_w - \theta_B)/(1 - \theta_B)$ as $F_{ST}$, a different quantity near twice as large. Owed part under 00-C1 |
| 00-D15 | fixed | `:287` and `:582-583` no longer claim completeness: shared symbols follow @sec-notation, local ones defined where they appear; "where a function computes one". Owed part under 00-C8 |
| 00-D16 | fixed | Coancestry of the IBD definition is no longer $f_{ij}$: it is $A_{ij}/2$ from the start; $f_{ij}$ is introduced only as the molecular quantity |
| 00-D17 | fixed | "Pool" kept for heterotic pools; the 625 hybrids are the "candidate set". Formula scoped to S4; S2 stated not to be a subset; Interpretation scoped to the merged hybrid set at S4, with the extension to S3 and the exclusion of S2 stated, and within-pool diversity stated as not measured |
| 00-D18 | fixed | Definition added after @eq-hp-gd: $GD_T$ is $GD_S$ for a set spanning the pools, the three terms named, partition taken on usage-weighted parent lines (`gd_partition()`), $GD_{WI} = 0$ with inbred parents. "Each is defined once" -> "Each is defined here" |
| 00-D19 | fixed | $F_{drift}$ is a property of a set against the frozen base; states both are computed on merged hybrid frequencies, a notional pool, that $F_{hom}$ reads that pool's $H_e$ and not $H_o$, and that they apply to trajectories and to single selections |
| 00-D20 | fixed | "the mean gene diversity of random subsets of the same size" |
| 00-D21 | fixed | Rewritten: drift result as @sec-subdivided derives it, "does not cover selection", no argument here for a common target, rise under selection a simulation result of @sec-cycles with drift and selection not separated |
| 00-D22 | fixed | Rewritten from the full text (Europe PMC, PMC12397178, fetched again): $F_{ST}$ 0.178 to 0.223; between-group Hamming 0.430 to 0.420, -2.33%, tied to $H_o$; decline concentrated in NSS ($H_e$ 0.371 to 0.279, SS stable); main cause the Iodent/Lancaster merger; "can only speculate" on selection. "Both trends" removed; van Heerwaarden cited for separation only; "Neither study establishes the mechanism above" |
| 00-D23 | fixed | Pointer now says @sec-plant-literature reads @kadoumi2025 within its corpus, which begins in 2017 and excludes @vanheerwaarden2012 |
| 00-D24 | fixed as far as verifiable; **open for arbitration** | Identity removed. Now: on inbred lines this is the scheme @kadoumi2025 describe as tester-based or modified RRS (their words, full text), traced by them to @hull1945, with @comstock1949 cited by them for the structure it builds; the book uses "reciprocal recurrent selection" for short and does not assert the 1949 procedure is this scheme on lines. The 1949 paper was not read: needs the paper or the user's ruling. Same identity in later chapters: see owed list |

## Non-disqualifying

| ID | Status | What changed |
|---|---|---|
| 00-M1 | -> quant-Rwrite | Assertions (00-R7) |
| 00-M2 | -> quant-Rwrite | Precision of paired values (00-R8) |
| 00-M3 | fixed for the scale sentence; hygiene -> quant-Rwrite | Scale sentence limited to the book's simulated lines and hybrids; the two Monte Carlo checks state their own parameters (00-R9). 00-R10 is code |
| 00-M4 | fixed | See 00-B3, 00-B4 |
| 00-M5 | fixed | Reading-map row marks @sec-programme as an inbred-line scheme outside A1 and @sec-cycles as the two-pool one; same in `index.qmd` part table |
| 00-M6 | fixed | New paragraph after the stages: S3 precedes testing in cross and reduces the DH lines on what a line shows per se; testing in cross and recycling are not stages |
| 00-M7 | fixed | Selfing series renamed $F^{(t)}$, with a sentence relating it to the filial generation F$_{t+1}$ |
| 00-M8 | fixed | "forward pointers are marked as such" removed from 00 and from `index.qmd` |
| 00-M9 | fixed | S4 row adds @sec-advanced, @sec-genomic-prediction; `:161` credits both sources of predicted values; stages distinguished from package stages and trial stages |
| 00-M10 | fixed | Pedigree base renamed $p_{b,k}$, $q_{b,k}$ throughout @eq-hp-ibs-ibd and its text; $p_{0,k}$ stays the frozen base |
| 00-M11 | fixed | "assumptions of the simulation of @meuwissen2020" |
| 00-M12 | fixed | $F_i$ flagged as defined in the next subsection at its first use; heading and lead-in now "the quantities that share its letter", no count |
| 00-M13 | fixed | "where optimisation effort usually goes" deleted |

## References

| ID | Status | What changed |
|---|---|---|
| 00-B1 | fixed | See 00-D22. Same selective wording at `11:135-137`: owed list |
| 00-B2 | open for arbitration | See 00-D24 |
| 00-B3 | fixed | `comstock1948`: volume 4, number 4, pages 254--266; author stop added |
| 00-B4 | fixed | `griffing1956`: volume 9, number 4, pages 463--493 |
| 00-B5 | fixed | See 00-D5 |
| 00-B6 | fixed | Causal claim deleted, so no source needed; no key added |
| 00-B7 | open | Falconer & Mackay chapter pins unchanged; text not reached. Non-decisive per verdict |
| 00-B8 | fixed at `:445`; open at `:369` | Attribution of $F$'s definition to @malecot1948 removed. `:369` keeps the citation for coancestry, corroborated by Caballero & Toro (2002) p. 291 |
| 00-B9 | open | Unchanged; corroborated by Caballero & Toro (2002) p. 290 |
| 00-B10 | open | Unchanged; primary not reached |
| 00-B11 | open | Unchanged; primary not reached |
| 00-B12 | open | Unchanged; primary not reached |
| 00-B13 | fixed | @wright1951 removed from the sentence; @caballero2002, Eq. 8 cited, checked in the PDF |
| 00-B14 | fixed | See 00-D7 |

## Continuity

| ID | Status | What changed |
|---|---|---|
| 00-C1 | fixed in 00; owed -> 08, 02: reconcile $F_{ST}$ / $G_{ST}$ naming, and the opposite Wright attributions of `02:219-222` and `08:91-96` | See 00-D14 |
| 00-C2 | fixed in 00; owed -> 04: state the A3 conflict of `04:28` (a cross between heterotic groups) | See 00-D13. `index.qmd:104-106` left as is: it says a panel cannot exceed what it sampled, not that @sec-sizing treats S2 |
| 00-C3 | fixed in 00; owed -> 08: align `08:69-71` | See 00-D21 |
| 00-C4 | fixed | See 00-D23 |
| 00-C5 | fixed in 00; owed -> 11b, 11c: a reference arm, and the level of `F_drift` against @eq-hp-drift (`11b:261-263`, `11c:33-46`) | See 00-D10 |
| 00-C6 | fixed in 00; owed -> 05: A5 must say which simulator it covers; `05:83-84` "implements exactly this loop" against C7, C8 | See 00-D6 |
| 00-C7 | fixed in index | `index.qmd`: "Every live example ... runs" -> default scale, with chapters that set another in their own chunks, @sec-stages as the example |
| 00-C8 | fixed in 00; owed -> 90: rows for $\bar y_{ij}$, $\bar e_{ij}$, $q_{0,k}$, $A_{ij}$, $H_t$ in the drift sense, $GD_S$, $GD_{\text{ref}}$, $F^{(t)}$, $p_{b,k}$, S1--S4; $\Delta F$ row to follow the wording of @eq-hp-drift | See 00-D15 |
| 00-C9 | fixed | See 00-M5 |
| 00-C10 | fixed | See 00-D12, 00-M6 |
| 00-C11 | fixed | See 00-D4 |
| 00-C12 | fixed | See 00-D18 |
| 00-C13 | fixed in 00 and index; owed -> 90: `90:20` "in the pool" | See 00-D17. `index.qmd`: "a set of $N$ candidate F1 hybrids", "full candidate set", "How the candidates are generated" |
| 00-C14 | fixed | See 00-D19 |
| 00-C15 | fixed in 00; owed -> 08: `08:376, 451-452` unconditional | See 00-D9 |
| 00-C16 | fixed | See 00-M7 |
| 00-C17 | fixed | See 00-M8 |
| 00-C18 | owed -> 05b, 07, 08, 11, 12, 92: $F_{BN}$ written $F_{ST}$ by declared exception | 00 keeps them apart |
| 00-C19 | owed -> 11b, 11c: $\Delta F$ as $-$slope against `05:1045-1050` | Not asserted in 00 |
| 00-C20 | fixed in index | Item 2: "every plan that raises one lowers the other" -> "can move in opposite directions: under drift alone the first rises while the second falls, an argument that does not cover selection" |
| 00-C21 | fixed | See 00-D7 |
| 00-C22 | owed -> 05, 06, 12: two values of "production scale" | 00 no longer adopts A8 beyond the teaching scale |
| 00-C23 | fixed | See 00-M9 |
| 00-C24 | fixed | See 00-M9 |
| 00-C25 | owed -> 01, 04e, 06, 08: cross-reference 00's definitions instead of restating | "Each is defined once" removed from 00, so 00 no longer claims it |
| 00-C26 | fixed in 00; owed -> 01: `01:320` | See 00-D5 |
| 00-C27 | fixed | See 00-D20 |
| 00-C28 | owed -> 06: $GD_{\text{ref}}$ against $GD_{\text{random}(n)}$ | 00 unchanged on this |
| 00-C29 | fixed in index | Budget written $\alpha_{\max}$ at the three places; $\alpha$ kept for the loss; `\alpha_{max}` -> `\alpha_{\max}` |
| 00-C30 | fixed in index | "breaks both assumptions" -> "departs from that setting in three ways" |
| 00-C31 | fixed in index | Lead-in: the chain is the book's argument, in logical not reading order, and not every chapter is a link. List not reordered |
| 00-C32 | fixed; owed -> 90: `90:203` $p_0^{(0)}$ | See 00-M10 |
| 00-C33 | owed -> 90: link the two $g^A_i$, $\mu$ rows | 00 handles it in prose |
| 00-C34 | fixed | See 00-M11 |
| 00-C35 | owed -> 08: `08:352` labels $N_{e,\text{par}}$ as `Ne` | 00 unchanged on this |

## Audit (prose only; the rest are quant-Rwrite's)

| ID | Status | What changed |
|---|---|---|
| 00-R1 | -> quant-Rwrite | |
| 00-R2 | fixed | See 00-D3 |
| 00-R3 | fixed | See 00-D10. The random arm of the audit is not cited: it is not in a chunk or a data file |
| 00-R4 | fixed | See 00-D9 |
| 00-R5 | fixed | See 00-D21 |
| 00-R6 | fixed in prose | See 00-D8. Individual-level arm optional; see hand-off |
| 00-R7 | -> quant-Rwrite | |
| 00-R8 | -> quant-Rwrite | |
| 00-R9 | fixed | See 00-M3 |
| 00-R10 | -> quant-Rwrite | |

## Owed list beyond the IDs above (for THREAD.md at close)

- 05 (`:81`), 05b (`:825, :855`), 04c (`:22, :916`), 04e (`:157`), `R/14_cycles.R:8`: the RRS attribution to @comstock1949, once 00-D24 is arbitrated.
- 11 (`:135-137`): Kadoumi quoted without the Hamming result, the NSS concentration or the stated cause (00-B1).
- 11b (`:252`): the unconstrained $\Delta F$ is the middle value, not "the lowest" (verdict).
- 08: `book/data/pipeline_loss_ledger.csv` has no producer in the repo (verdict). 00 calls it a cached table and does not call it reproducible.

## Seen, not changed (no ID issued)

`index.qmd:165-175`: "`regenerate.R` regenerates all of them" and "everything reported here is reproducible output" read too widely against the cached external `mating_*`, `sparse_*` files and the ledger above. Left alone as unreported, for the reviewer to rule on.

## quant-Rwrite rows (iteration 1, after quant-writer)

Files changed: `book/00-hybrid-programme.qmd`, `book/_common.R`, `book/downloads/` (regenerated). `R/` and `tests/` unchanged, so `devtools::document()` and `devtools::test()` were not needed. `_freeze/` and `docs/` not touched: the chapter is stale until the render at close.

| ID | Status | What changed, or evidence |
|---|---|---|
| 00-D11, 00-R1 | fixed | Root: knitr's markdown inline hook writes a numeric value in scientific form as undelimited TeX (`format_sci(x, "latex")`), and Pandoc drops `\times 10`. New `fmt_sci(x, digits = 2)` in `book/_common.R` returns a string (the hook passes strings through) holding a complete math span, for prose outside `$...$`; a one-line `stopifnot()` under it covers the mantissa roll-over. `gca_err` now uses it. The two s.e. were never scientific values, only a `round()` artefact, so they are fixed-point: `sprintf("%.5f", ...)`. Printed in a scratch-copy `quarto render` of the chapter: HTML `\(3.7 \times 10^{-13}\)`, s.e. 0.00013, s.e. 0.00039; PDF "3.7 × 10−13", 0.00013, 0.00039. No `^{` or `\times` outside math or code in the chapter's HTML. Other chapters: `fmt_sci` is a new name used nowhere else (grep), so no chapter's output can change, and freeze hashes the `.qmd`, not `_common.R`. `make_downloads.R` copies `_common.R` into each script, so all 29 downloads gain the same 11 lines; only 00 and 06 differ otherwise. Rejected: a global inline hook or `options(scipen)`. A hook cannot tell prose from `$...$`, where several chapters place values, and `scipen` would also change `print()` output in every chunk on re-execution |
| 00-D12 (drawing) | fixed | Both dashed arrows now leave S4 at x = 98, top and bottom edges, clear of the triangle at (92, 41.8). At first they touched the "commercial F1" label, so that label and its arrow moved from x = 92 to x = 90. One code path for both formats; HTML PNG and the Typst page viewed, both correct. Label is explicit, nothing orphaned |
| 00-D8, 00-R6 | fixed | `hp-drift` now simulates individuals in place of the binomial chain: parents drawn per generation for all loci, gametes from two haplotypes, three arms (block with selfing, block without selfing, DH pool), 1,000 pedigrees x 200 loci, pedigree as the replicate. The copy counts are no longer inputs. Retained: 0.5971 (s.e. 0.0014) against 0.5987; 0.6116 (0.0012) against 0.6131; 0.3458 (0.0018) against 0.3487. Over 60 further seeds: z mean 0.06, -0.23, -0.03, sd 0.99, 1.09, 1.02, no assertion failed, no-selfing above selfing 60/60. Expected value without selfing comes from a coancestry recursion in the chunk, checked against an independent two-lineage Markov chain (0.6131157721 against 0.6131157720). DH parents are drawn distinct: each line takes one gamete, so its $n$ copies stay independent and the count is exact. Wording edits, the ones the brief named and those they forced: "no crossing block or DH pool is simulated" replaced by a description of the simulation; the Result paragraph rewritten and given the third arm; "Given those copy counts and neutrality" -> "Under neutrality" plus one clause on selfing. The selfing sentence itself stands as written |
| hp-drift comments | fixed | Hand-typed "10 plants", "10 DH lines" gone with the old code |
| hp-ibs-ibd names | fixed | `p0` -> `p_b`, `p0_lim` -> `pb_lim`, matching $p_{b,k}$ |
| hp-subset-gd names | fixed | `gd_pool` -> `gd_cand`, `sub_gd[["pool"]]` -> `sub_gd[["candidates"]]` |
| 00-M1, 00-R7 | fixed | Four assertions added: $GD_{WI} = 0$ (-4.4e-16) and @eq-hp-gd on the greedy subset `S_div` (5.6e-17) in `hp-heterozygosity`; $s_i = (1 + F_i)/2$ (1.1e-16) and the quadratic form $w' \mathbf{f}^L w$ on `S_div` (3.3e-16) in `hp-f-hybrid`. `S_div` is now kept from `hp-subset-gd`; no new draw |
| 00-M2, 00-R8 | fixed | Paired values through `sprintf`: 0.3209 / 0.3210; 0.597 / 0.599; 0.612 / 0.613; 0.346 / 0.349. s.e. to two significant digits (0.00013, 0.00039) |
| 00-M3 (hygiene), 00-R10 | fixed, one item contested | `pB` removed. `drop = FALSE` on every subset named. `all.equal()` on exact identities now at `tol_id = 2 m eps` = 8.9e-13, set from the rounding of a sum over $m$ markers (default was 1.5e-8). Hand-typed comments: see hp-drift. **Contested, GCA tolerance:** 1e-10 at `hp-gca-tester` stays. The worst-case rounding `m eps max|H1|` is 1.7e-10, already above it, and the observed 3.7e-13 may move with BLAS. **Contested, footer:** `make_downloads.R:77-81` rewrites every footer from one template on each run, so an edit in 00 alone is undone. Making the template conditional changes the footer of the chapters with no cached read (16 of 31 `.qmd` have no `book_data`/`book_fig` call), which changes their hash and re-executes them, for an Info item. Left as is |
| owed -> 05 | owed | `05:1704` `signif(ev_min, 2)` and `05:1743` `signif(abs(ev_min), 1)`: bare in prose, print `-4.3^{-13}`, `4^{-13}`. Replace with `fmt_sci()` |
| owed -> 06 | owed | `06:395` `signif(max(abs(gdp[, "GD_WI"])), 2)`: prints `6.7^{-16}`. Replace with `fmt_sci()` |
| owed -> 04g | owed | `04g:523` `n_unc` (2e4): prints with the `\times 10` dropped. A count, so `format(n_unc, big.mark = ",", scientific = FALSE)` rather than `fmt_sci()` |

Verified: chunks run clean against `load_all()` (1.6 s whole chapter, was about 0.3 s; `hp-drift` is `O(n_ped * t_gen * n * m)`, about 0.5 s per arm at 1000 x 10 x 10 x 200). All non-drift numbers unchanged from the audit's table. `book/downloads/00-hybrid-programme.R` runs standalone in an empty directory and reproduces the values. `make_downloads.R` left every `.qmd` other than the chapter as quant-writer left it.

Seen, not changed: the Typst caption of `fig-hp-cycle` prints "Chapter 13.." with a doubled full stop. It is already in the published PDF.
