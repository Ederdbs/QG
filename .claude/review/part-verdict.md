# Part-close verdict: Introduction (index + 00) and Foundations (01, 02, 02b, 05b)

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05, branch review-01-05. Text judged: the uncommitted tree as it stands, after the part-fix pass of part-foundations-response.md. Package for every run: the worktree, installed into a scratch library (`R CMD INSTALL --library=<scratch>/lib`), not the system `hybdiv`.

VERDICT, Introduction part (index.qmd + 00): APPROVED
VERDICT, Foundations part (01, 02, 02b, 05b): APPROVED

No H open in either part. No new disqualifying failure. Counting convention for the non-disqualifying rule: per part (Introduction 2, Foundations 2); all four are below the threshold of three.

## PREVIOUS IDS

### part-introduction.md

- introduction-C1 (H) -- CLOSED -- see "Decision on introduction-C1" below. The reworded promise (index:76-82) is true of 00, 01, 02 (and of 02b, 05b) as they print today.
- introduction-C2 (M) -- CLOSED -- settled in 01 (01:8-14); `@sec-hp-popgen` / `-ibd` / `-inbreeding` now have inbound citations from 01, 02, 05b. Not re-opened.
- introduction-C3 (M) -- CLOSED -- "What the scale of f is" (01:242-262); the one remaining "absolute" is the negation.
- introduction-C4 (M) -- CLOSED -- 00:10 now "the four stages that @sec-stages measures"; 00:174-176 "the ones @sec-stages uses; the chapters of the last column treat the stages, and not all of them use the names". Checked: `grep -cw 'S[1-4]'` gives 19 in 08, 1 in 11, 0 in 06, 07, 09, 10, 10b, 11b, so "not all of them use the names" is true of the table's last column (07 is not in the column; 09, 10, 10b are). "Used throughout the book" and "the rest of the book refers to" are gone (grep).
- introduction-C5 (L) -- OPEN, residual -- index:30 still writes `$G$` (plain) in the paragraph whose first sentence was changed to `\mathbf{f}`, `\mathbf{G}`. Cosmetic; recorded in part-M2.
- introduction-C6 (L) -- CLOSED -- index:24 "carries on average", index:34 "the mean over random subsets"; agrees with 00:314-316.
- introduction-C7 (L) -- CLOSED -- index:28-29 "The coancestry-based diversity metrics are computed on ... f".
- introduction-C8 (L) -- CLOSED -- index:69 "the book builds the theory first (the second half of the Introduction, then Foundations)"; true of 00's second half.
- introduction-C9 (L) -- CLOSED -- the duplicated sentence at 00:752 is replaced by a pointer to the Preface's table. The two navigation tables and the departures listed twice remain; 00 declares the repetition, the reading map carries chapter citations. Redundancy, non-disqualifying, not counted.
- introduction-C10 (L) -- CLOSED for the preface and for the five chapters (grep: no "book scale", "default scale" or "reduced scale" in index, 00, 01, 02, 02b, 05b); "book scale" in 03, 04c, 07, 09, 10, 10b, 90, 92 stays with their own reviews.

### part-foundations.md

- foundations-C1 (M) -- CLOSED -- 02:605-608: "theta_A, theta_B, theta_AB in the code (`theta_pools()`, chunk `fst-two-forms`) and in @sec-notation". True: `theta_pools` is at R/01_metrics.R:120 and returns exactly those three names; the chunk `fst-two-forms` (02:375) calls it and uses them; 90:205 and 90:226 define them in the Symbols table; `{#sec-notation}` is 90:1. 00 is no longer cited for them. Residual 90:10-11 ("introduced together in @sec-hp-popgen") is false for these three: owed to 90, not part text.
- foundations-C2 (M) -- CLOSED -- 00:445-447 now cites @eq-het-wi-hyb in @sec-heterosis-hybrid-identity and keeps @sec-heterosis-identity / @eq-het-split as the per-locus expectation. Targets: `{#sec-heterosis-hybrid-identity}` at 05b:382, `{#eq-het-wi-hyb}` at 05b:390, `{#sec-heterosis-identity}` at 05b:267, `{#eq-het-split}` at 05b:273, each defined once. Content correct: 05b:386-388 says GD_WI_hyb = H_o/2 (self-coancestry 1 - h_i/2); numerically 2*GD_WI_hyb - (GD_T + GD_BS) = 0 and H_o = mean(X == 0.5) = 0.3616896 = GD_T + GD_BS (below).
- foundations-C3 (M) -- CLOSED -- 02b:474-480 and 05b:777-779 state GD_WS = GD_WI + GD_BI (@eq-gd-partition) and GD_WI = 0 with inbred parents. Correct: @eq-gd-partition defines GD_WI = 1 - s~, GD_BI = s~ - f~, so GD_WS = 1 - f~ = GD_WI + GD_BI is an identity; the inbred-parent condition is declared where used. Numerically (below) GD_WI + GD_BI = 0.294496 = mean(pA qA + pB qB), the 02b expression. 05b:476 (GD_BI) and 05b:777 (GD_WS) are now linked.
- foundations-C4 (M) -- OPEN, owed to 90 (a named later chapter). Not an item of the part's text: the five chapters are true without the 90 edits, and every pointer from them into 90 that I read (00:586, 02:607, 05b:614-624) lands on a row that is correct (90 Terms, 90:205/226). The items stay in the THREAD 90 rows (listed in the response).
- foundations-C5 (L) -- CLOSED -- 02:363-365 "1 - f-bar = H_T (= GD_T)", "1 - f-tilde = H_S (= GD_WS)"; follows from @eq-gd-partition and its table (02:433-452).
- foundations-C6 (L) -- qualifier half CLOSED (02b:592-594: the GCA and SCA of that half are those of H, @eq-het-gca-sca, not of the cross mean gv); second-run half OPEN, owed to 02b. 02b is a chapter of this part, so the part closes with this redundancy standing (part-M4).
- foundations-C7 (L) -- OPEN, owed to 03 (names it; finite-pool offset derived in 05b and again in 03; the two agree per the part report, not re-derived by me).
- foundations-C8 (L) -- OPEN, owed to 01. 01 is a chapter of this part, so this closes inside the part as a known L (part-M3). The part text asserts nothing false without it: 01:377-381 separates p*_k from p_{0,k}; 01:252-258 uses p_{b,k} for the floor and never equates it with p*_k. The response was right not to write a sentence unverified: for lines drawn independently from a pool with frequency p_A the expected f between two such lines at a locus is p_A^2 + q_A^2, so I do not take "p_b = p*" as true for within-pool pairs without a check; I did not run one.
- foundations-C9 (L) -- CLOSED -- 02b:540-544. Correct: gv = sum beta_k x_k, x_k in {0, 1/2, 1}, so the homozygotes (0, 1) differ by beta_k and one substitution by beta_k/2; with homozygotes worth +/- a_k (05b:126-143, textbook scale) 2 a_k = beta_k, so a_k = beta_k/2. The clash of the letter a (a_i, economic-weight vector a) is not touched; owed to 90.
- foundations-C10 (L) -- CLOSED for the part (00 heading "identity in state" at 00:451; grep finds no "identity by state" in index, 00, 01, 02, 02b, 05b, 03). 90:618 glossary still "Identity by state": owed to 90.
- foundations-C11 (L) -- CLOSED -- 01:70-72 names the teaching scale with inline `r book_cfg[[...]]` / `r ctx[["N"]]`; knit output reads "25 + 25 lines, 2000 markers, 625 hybrids".
- foundations-C12 (L) -- CLOSED -- "meaningless" no longer in index (grep 0); index:30-33 states what 01 shows (group coancestry zero, N_s divergent by construction).
- foundations-C13 (L) -- OPEN, owed to 12 (secondary 08). Names a chapter.
- foundations-C14 (L) -- CLOSED -- 01:377, 05b:620, 05b:1194 read "@eq-balding-nichols, stated later, in @sec-simulating-crosses". `{#eq-balding-nichols}` defined once (03:88).
- foundations-C15 (L) -- CLOSED -- no "candidate population" in index, 00, 01, 02, 02b, 05b (grep).

## Decision on introduction-C1

Question put: is the new promise true of 00, 01, 02 today, and is rewording an acceptable closure of an H or does the H stand until the code prints the deviations?

The new text (index:76-82) makes three statements.

1. "The code asserts [an exact identity] against a simulated oracle or a second computation with a stated tolerance, so that the book does not render if the identity fails." Checked in 00, 01, 02 (and 02b, 05b): every exact identity is under `stopifnot(all.equal(..., tolerance = ...))` or an explicit bound, with the tolerance stated in the chunk (00: `tol_id` = 2 m eps at 00:58, `1e-10` at 00:146; 01: `1e-12`, `1e-6 * N^2` at 01:132; 02: `tol <- 1e-12` at 02:482, `1e-12`, `5e-5` at 02:657; 02b: `tol_exact <- 1e-12` at 02b:20; 05b: `1e-12`, `tol_H`). `_quarto.yml:107-110` sets no `error: true`, so a failing chunk stops the render. True, with the limit in part-M1.
2. "The achieved deviation is printed where a chapter reports one, not for every assertion." True by construction and I checked each chapter does report some: 00 prints 3.7e-13 (GCA row effect, text at 00:162 of the knit) and `max_abs_diff`; 01 prints `sum_G` and `Ns_on_G` (01:124-136); 02 prints 4e-15 for the enumeration (knit line 257-258); 02b prints a deviation for every tested identity (02b:572-583); 05b prints residuals (05b:252, 1030). The statement no longer claims that 00, 01, 02 print one per identity, which was the false part.
3. "A Monte Carlo agreement: the estimate is given with its dispersion and the value it is compared with." Checked: 00 prints estimate, s.e. and expected (00:287-308 `sub_gd`, full_sib at 00:523-527, drift table `dr`); 01 prints mean_MC, formula, se (01:183-197); 02 prints means, baseline and the largest deviation in Monte Carlo s.e. (02:257-266) and N_e with its s.e. (02:920-940). True.

Decision: the H closes. The defect was a promise of the preface that the first chapters did not keep (criterion 5). Rewording it to what the book does removes the inconsistency, and the new promise is the verifiable one: an assertion with a tolerance that halts the render is a stronger guarantee than a printed deviation that nobody compares with anything; the standard does not require a printed deviation for an exact identity. Had the reworded sentence still been false of 00, 01 or 02, the H would stand. It is not. The universal scope of "the book" beyond the five chapters is not checked here; it is a keep-true row for every later chapter review (not decisive: the new sentence is deliberately weak, and a later chapter that breaks it fails against the preface in its own review).

## DISQUALIFYING FAILURES

None, either part.

## NON-DISQUALIFYING OBSERVATIONS

Introduction part (2):

- part-M1 index.qmd:77-82 -- "so that the book does not render if the identity fails" holds when a chapter is executed. `execute: freeze: auto` (`_quarto.yml:107-110`) re-runs a chapter only when its source changes, so an identity broken by a later edit in `R/` does not stop a render of an unchanged, frozen chapter. 92:377-378 states the freeze rule, but the preface does not point to it. Accuracy of a method statement; low weight.
- part-M2 index.qmd:30 (and :109-110) -- `$G$` in plain type in the paragraph whose first sentence was changed to bold (introduction-C5 residual); bare `\theta` for the group coancestry at :109-110 where the rest of the book writes theta_S (owed since 02-C4, still in the THREAD index row; defined on the spot, so no reader is misled). Notation.

Foundations part (2):

- part-M3 foundations-C8 -- three base/ancestral frequency symbols p_{b,k}, p_{0,k}, p*_k in 00, 01, 02, 05b with no statement of how they relate; owed to 01 (in the part).
- part-M4 foundations-C6, second half -- 02b:582-626 recomputes the GCA/SCA split of H on a second draw (seed 7, N(0.3, 0.1^2)) after saying 05b owns it; the caption declares one draw and the qualifier now separates it from gv. Redundancy; owed to 02b (in the part).

Owed to later chapters, tracked, not counted against the parts (the part text is true without them): foundations-C4 -> 90, C7 -> 03, C13 -> 12 (secondary 08), plus the 90 residues of C1 (90:10-11), C10 (90:618), C9 (a_i / b_j rows).

## Owed items: do they name a chapter, and is the part true without them

| Item | Owner named | Part text true today without it? |
|---|---|---|
| foundations-C4 | 90 | yes; the five chapters make no statement that 90's stale lines (90:154-155, 207, 232, 179, 118, 119, 627-630, 10-11) contradict, and every pointer into 90 lands on a correct row |
| foundations-C7 | 03 | yes; 05b owns the derivation, 03 re-derives and agrees |
| foundations-C13 | 12 (secondary 08) | yes; the protocol half of 05b is complete in itself |
| foundations-C8 | 01 (in the part) | yes; no sentence equates the symbols (see C8 above) |
| foundations-C6, second run | 02b (in the part) | yes; the qualifier is in |

## THREAD corrections owed at close

- THREAD.md:135 and :144 (entry 02-subdivided): "f_AA, f_BB, f_AB are theta_A, theta_B, theta_AB of 00 and the code" and "Takes from 00: @sec-hp-popgen (DH sampling unit; theta_A, theta_B, theta_AB)" give wrong provenance. 00 defines neither theta_A nor theta_B; it names theta_w and theta_AB once (00:580-581) inside the description of what @sec-stages logs. Correct provenance: `theta_pools()` in 02's own chunk `fst-two-forms` (02:375-390) and the 90 Symbols table (90:205, 226). Also THREAD.md:24 (entry 00, "Takes from: ... 05b: GCA dominance part, H_o identity"): the pointer is now @eq-het-wi-hyb in @sec-heterosis-hybrid-identity.
- Keep-true row for every later chapter: the preface sentence at index:76-82 (assertion with stated tolerance; deviation printed where reported; Monte Carlo estimate with dispersion and compared value).

## WHAT WAS VERIFIED

- Every `@sec-`, `@eq-`, `@tbl-`, `@fig-` target cited in index, 00, 01, 02, 02b, 05b resolves to a definition, and no label is defined twice across the 31 .qmd files -- python scan of `{#...}` and `#| label: tbl-/fig-` against all citations: "duplicates: {}", "unresolved: []". Quarto's own resolution not run (nothing rendered).
- Chapters 00, 01, 02, 02b, 05b run end to end, chunk by chunk, with the worktree package -- `knitr::knit()` of each .qmd (wd `book/`, scratch library installed from the worktree, `find.package("hybdiv")` asserted to be the scratch copy): all five "OK", no assertion failed (00 1.6 s, 01 1.5 s, 02 4.2 s, 02b 3.1 s, 05b 8.4 s). Inline values in the knit output: 0.3617 / 0.3281 / 0.0336 (00 H_o, H_e, GD_BS), 3.7e-13 (00 GCA error), 0.859 (00), 0.7442, 0.6448, 0.6719, 0.6717 (01), 4e-15, 0.126 / 0.224 / 1.78 (02), 0.238 / 0.228 / 0.535 (02b): the same as the part reports quote. Limit: the whole review is uncommitted, so there is no pre-pass baseline to diff; "nothing moved" rests on (a) these values equal the ones the part reports recorded before the pass, (b) the pass touched prose and one code comment (`# dominance effects, d_k > 0` at 00:138), none of the hunks listed in the response contains executable code, (c) `book/downloads/` match (grep of the new anchor and the comment in 00 and 05b downloads).
- GD_WS = GD_WI + GD_BI with inbred parents -- `gd_partition(all_h, ctx)` at `book_cfg` (seed 2026 in `_common.R`): GD_WI = -4.4e-16, GD_BI = 0.2944960, GD_BS = 0.0335968, GD_T = 0.3280928; GD_WI + GD_BI = 0.294496 = mean(pA qA + pB qB) = 0.294496; GD_T - (GD_BI + GD_BS) = -4.4e-16.
- 2 GD_WI_hyb = GD_T + GD_BS = H_o -- same run: difference 0; mean(X == 0.5) = 0.3616896 = GD_T + GD_BS = 0.3616896.
- `theta_pools()` returns theta_A, theta_B, theta_AB (R/01_metrics.R:120-127); on all 625 hybrids 0.7046656, 0.7063424, 0.6383104.
- The S1-S4 name counts quoted above (`grep -cw 'S[1-4]'`).
- `book/Rplots.pdf` and `book/figure/` absent; `git status` untouched apart from my report (the knit wrote to the scratch directory).

## NOT VERIFIED

- Quarto/Typst rendering of the new anchor `{#sec-heterosis-hybrid-identity}` and of @eq-het-wi-hyb from 00 (grep and the python scan only). Form; not decisive.
- Scope of the preface sentence over the chapters outside these two parts (unreviewed or reviewed later). Not decisive for these parts; keep-true row above.
- p_{b,k} against p*_k (foundations-C8): not computed.
- External sources named as UNVERIFIED in the chapter verdicts: Falconer & Mackay chapter locators, Malecot 1948, Lindgren et al. 1997, VanRaden 2008, Toro et al. 2014, Eding & Meuwissen 2001 (01); Wright 1969 (year), Cockerham 1967/1969, Nei 1973 beyond its abstract, Meuwissen 1997 beyond its abstract (02); Kempthorne & Nordskog 1959, Smith 1936, Hazel 1943, Bulmer 1971, Sprague & Tatum 1942 (02b); Fisher 1918, Reif et al. 2007, Technow et al. 2014, Labroo et al. 2021, Mackay et al. 2020 (05b); the supporting information of van Heerwaarden 2012 (00). In each chapter verdict they were recorded as non-decisive, and in each chapter the text says where the source was not read and no number rests on it. None is decisive for either part.
