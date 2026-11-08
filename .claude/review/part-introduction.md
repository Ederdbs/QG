# Part review: Introduction (00-hybrid-programme)

Scope: what the part adds as the opening of the book. It follows `index.qmd` (the preface) and hands over to Foundations (01, 02, 02b, 05b). Chapter findings 00-* are not repeated. Text judged: the approved `book/00-hybrid-programme.qmd`, `book/index.qmd` as changed in this review, `book/90-notation.qmd`, and the Foundations openings. `file:line` refers to the worktree `/Users/ederdbs/Documents/SB_quanti_gen-review-00`. Rendered output checked in `docs/` (HTML and the Typst PDF, built 2026-11-07 17:52).

## Findings

- **introduction-C1 (H) -- broken promise, preface against the part's own chapter.** `index:73-77`: "Where a result is an exact algebraic identity, the deviation from a simulated oracle is printed next to it; where it is a Monte Carlo agreement, the residual is printed." In 00 the deviation is printed for two identities only: the GCA row effect (`00:155`, $3.7 \times 10^{-13}$) and $F_{(ab)} = f^L_{ab}$ (`00:558`, `max_abs_diff` 0). The others are `stopifnot()` assertions with no printed deviation: $H_e = 1 - \theta_A$ for pool A, $GD = H_e$ on all hybrids and on `S_div`, $H_e = GD_T$, $H_o = GD_T + GD_{BS}$, $GD_{WI} = 0$ (`00:420-430`), $s_i = (1 + F_i)/2$ and $\theta_S = \mathbf w'\mathbf f^L\mathbf w$ (`00:551-556`). The echo at `00:432` prints `He_hybrid` and `GD_hybrid` to four decimals, which shows agreement but not a deviation. The Monte Carlo checks print estimate, s.e. and expected value (`00:498-505`, `00:673-682`), not a residual. 00 itself only promises that identities are "checked numerically" (`00:15`), which holds. Owner: **index**, whose promise is stronger than the first chapter delivers (and every Foundations chapter also asserts with `stopifnot()`: 01 has 5, 02 16, 02b 9, 05b 15 calls).

- **introduction-C2 (M) -- the hand-off to Foundations is not made, and the second half of the part has no reader.** Cross-reference graph: no chapter cites 00's population genetics. `@sec-hp-popgen` is cited only by `90` (3 times, `90:11`, `90:84-89`); `@sec-hp-ibd`, `@sec-hp-inbreeding`, `@sec-hp-not-animal`, `@sec-hp-reading-map`, `@eq-hp-gd`, `@eq-hp-ibs-ibd`, `@eq-hp-gca-sca`, `@tbl-hp-stages` and `@fig-hp-cycle` have zero inbound citations; `@eq-hp-drift` has one chapter citation (`05:999`). Foundations cites 00 twice, both to `@sec-hp-cycle` (`01:25`, `05b:1634`); 02 and 02b never. The first Foundations chapter opens (`01:8-15`) as if it were the book's first chapter: it does not say why it follows 00 or what 00 has already defined, then redefines coancestry, $s_i$ and $F_i$ (`01:147-172`, already owed as 00-C25). 00's ending (`00:734-754`) is a reading map, which is fine for a part that hands to everything. Owner: **01** (opening). Owed row added in THREAD.md.

- **introduction-C3 (M) -- definition at the hand-off: what $\mathbf f$'s scale is.** 00 establishes that $\mathbb E[f_{ij}]$ is a floor $m^{-1}\sum_k(p_{b,k}^2 + q_{b,k}^2)$ set by base frequencies plus the scaled pedigree coancestry, that unrelated individuals are not at 0, and that $\mathbf f$ is therefore read as a comparison between sets measured on the same markers (`00:465-475`, `00:514-524`). The next chapter says "Diversity requires an *absolute* scale" (`01:142`) and lists "no arbitrary base population" as a property of $\mathbf f$ (`01:172`), without the qualification that the level of $\mathbf f$ depends on the marker panel's frequencies. Read in order, a reader meets "comparison between sets on the same markers" and then "absolute". Both can be made true (no centring constant estimated from the data), but the book does not say which sense of "absolute" it means. Owner: **01**. Owed row added in THREAD.md.

- **introduction-C4 (M) -- the stage vocabulary the part hands on is not used as claimed.** `00:10` "names the four stages the rest of the book refers to" and `00:174-175` "The names ... are used throughout the book." By grep, S1-S4 occur in 02, 05b, 08, 08b, 11, 91 and 92 only; S3 occurs in 08 alone. @tbl-hp-stages assigns S4 to @sec-collapse (07), @sec-ocs (09), @sec-combinatorial (10) and @sec-advanced (10b) (`00:184`), and none of those four chapters uses the name. @tbl-hp-stages has zero inbound citations. Two later chapters treat 08 as where the stages are defined: "the S1 monitor that @sec-stages will define" (`05b:44`) and "@sec-stages S2 (defined there)" (`05b:1171`); `08:16-21` reprints the table (already owed as 00-C25). Owner: **00**, for the claim "used throughout the book"; 05b's two pointers are added to THREAD.md as owed to 05b.

- **introduction-C5 (L) -- notation, one quantity with two typefaces.** `index:28-30` writes the matrices as $f$ and $G$; 00 (`00:463`, `00:522`, `00:741`) and `90` (Matrices table) write $\mathbf f$ and $\mathbf G$. Owner: **index**.

- **introduction-C6 (L) -- definition of the reference.** `index:24` ("the molecular gene diversity that a *random* set of the same size would have carried") and `index:34` ("The reference for 'no loss' is the distribution of random subsets") against `00:314-316` and `90:290`: $GD_{\text{ref}}$ is the *mean* gene diversity of random subsets of the same size. 00 was corrected to the mean in this review (00-D20); the preface still names a single set and a distribution. Owner: **index**.

- **introduction-C7 (L) -- scope of "diversity is measured on $f$".** `index:28-29`: "Diversity is measured on the Caballero & Toro molecular coancestry matrix $f$" without qualification. `00:463-465` (fixed under 00-D5): the coancestry-based metrics are computed on $\mathbf f$; frequency-based metrics such as $F_{drift}$ are not. The preface's contrast is with $\mathbf G$, which stays true, but its universal reading is the one 00 withdrew. Owner: **index**.

- **introduction-C8 (L) -- part order against the preface's statement of it.** `index:68-69`: "None of them changes the underlying theory, which is why the book starts with the theory." The book now starts with the Introduction part, whose own row reads "The hybrid programme end to end" (`index:130`) and whose chapter starts with the programme cycle (`00:8-11`, `00:65-360`); theory starts in its second half and in Foundations. The sentence predates the Introduction part. Owner: **index**.

- **introduction-C9 (L) -- redundancy between the preface and the part.** Two navigation tables, the part table (`index:128-136`) and the reading map (`00:736-750`), neither citing the other, with the same sentence "The parts are ordered so that each is readable after the ones before it" at `index:126` and `00:752`, and the same parenthesis on @sec-programme and @sec-cycles at `index:136` and `00:748`. The three departures are listed at `index:48-66` and again at `00:709-732`; 00 says they are "stated in the preface and each made precise elsewhere", so that repetition is declared and adds the cross-references, and @sec-hp-not-animal is cited by nobody. Ownership: the index should own the part summary and the departures; the reading map earns its place by carrying chapter citations and should point to the index's table rather than repeat its sentence. Owner: **00**.

- **introduction-C10 (L) -- one concept, three names: the reduced scale.** "teaching scale" (`00:35`, `00:45`, A8 at `05:106`, `02:87`, `02b:159`), "the default scale of the live examples" (`index:159`) and "book scale" (03, 04c, 07, 09, 10, 10b, 90, 92; 29 occurrences), with "the book's reduced scale" at `12:34`. The preface introduces the concept without the name that A8 and 00 give it. Owner: **index** (adopt the A8 name where the concept is introduced); the later chapters follow in their own reviews.

Checked and consistent (not findings): 00's opening says why it follows the preface (`00:8`), and the preface sends new readers to it (`index:138-139`). The index's part table and 00's reading map agree with `_quarto.yml` part for part. The three departures agree between `index:52-66` and `00:718-728`. Index item 1 and `00:72-74` carry the same dominance condition; index item 2 and `00:333-341` the same drift-only scope. $\alpha_{\max}$ for the budget and $\alpha$ for the loss agree between `index:22-41` and `00:188-189`, `00:313-316`. The default scale (25 + 25 lines, 2000 markers, 625 hybrids) agrees between `index:159-161` and `00:44-46`. No assumption of 00 is reused in Foundations where it fails: 01 and 02 restate A2 (homozygous lines) where they use it, and 05b cites A3 through `@sec-hp-cycle`. The part depends on later chapters only by declared pointer (`00:15-16`, `00:18-20`). No broken `@sec-` target in the book; no `{#sec-}` defined twice.

## Inbound `@sec-` count

Each `@sec-` resolved to the file that owns its `{#sec-...}` and counted only when the citing file is a different file. `index.qmd` and `99-references.qmd` own no section label.

| Chapter | Inbound | Citing files |
|---|---|---|
| 00-hybrid-programme | 9 | 7 |
| 01-coancestry | 25 | 14 |
| 02-subdivided | 40 | 14 |
| 02b-response | 28 | 14 |
| 05b-heterosis-dominance | 79 | 21 |
| 03-simulating-crosses | 28 | 16 |
| 04-population-sizing | 17 | 10 |
| 04b-backcross-introgression | 8 | 7 |
| 04c-alphasimr-pipeline | 21 | 11 |
| 05-genomic-era | 39 | 16 |
| 06-metric-catalogue | 42 | 18 |
| 07-choosing-metrics | 47 | 20 |
| 08-pipeline-stages | 39 | 18 |
| 08b-genomic-prediction | 26 | 14 |
| 09-optimal-contributions | 37 | 16 |
| 10-combinatorial-selection | 31 | 14 |
| 10b-advanced-selection | 25 | 8 |
| 04e-mating-design | 58 | 8 |
| 04f-sparse-testing | 38 | 6 |
| 04g-joint-allocation | 11 | 4 |
| 11-plant-literature | 15 | 8 |
| 04d-breeding-programme | 19 | 6 |
| 11b-diversity-across-cycles | 51 | 20 |
| 11c-limits | 19 | 9 |
| 12-case-study | 21 | 15 |
| 90-notation | 18 | 7 |
| 91-package | 0 | 0 |
| 92-verification | 5 | 5 |
| 93-corpora | 2 | 2 |

00's 9 come from index 1, 01 1, 05 1, 05b 1, 08 1, 92 1 and 90 3: one per chapter, four of them to `@sec-hybrid-programme` or `@sec-hp-cycle`, and none to the population-genetics half (introduction-C2). Low, with no owner change required here: 91 (0, an appendix of package reference), 93 (2), 92 (5).
