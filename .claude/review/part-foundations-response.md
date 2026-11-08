# Response to part-foundations.md (foundations-C1..C15) and part-introduction.md (open: introduction-C1, C4-C10)

Wording only; no chunk code, no number, no R/ touched. Chapters edited: 00, 01, 02, 02b, 05b, index. `Rscript book/scripts/make_downloads.R` run (all chapters ok). The purled scripts of 00, 01, 02, 02b, 05b were run in temp dirs with `library(hybdiv)` replaced by `pkgload::load_all(<worktree>)`: all five exit 0, no error. No `book/Rplots.pdf` or `book/figure/` present.

Counts: 19 fixed, 0 contested, 4 owed (23 IDs).

| ID | Disposition | Owner / note |
|---|---|---|
| foundations-C1 | fixed | 02:605-607 now reads "in the code (`theta_pools()`, chunk `fst-two-forms`) and in @sec-notation" (the symbols are defined in the 90 Symbols table, row `theta_A, theta_B, theta_AB`, and used in 02's own chunk). Secondary: 90:10-11 "introduced together in @sec-hp-popgen" is still false for these three: owed -> 90 (not edited). THREAD 02 entry "Takes from 00: theta_A, theta_B, theta_AB" still to be corrected by the caller |
| foundations-C2 | fixed | 00:445 now cites @eq-het-wi-hyb in the new @sec-heterosis-hybrid-identity (and keeps @sec-heterosis-identity / @eq-het-split as the per-locus expectation). 05b: heading "A second identity, at the hybrid level" given id `{#sec-heterosis-hybrid-identity}`, and the sentence introducing @eq-het-wi-hyb says `GD_WI_hyb` is half the observed heterozygosity $H_o$ of the F1s (@sec-hybrid-programme). The id did not exist before (grep) |
| foundations-C3 | fixed | 02b (after the $GD_{WS}$ definition in @sec-response-genic): "$GD_{WS} = GD_{WI} + GD_{BI}$ (@eq-gd-partition), so with inbred parents ($GD_{WI}=0$) it is the $GD_{BI}$ that @sec-subdivided names"; the identity is the one in 02's table (`tbl-gd-partition`, row $GD_{WS}$). 05b: at the $GD_{WS}$ sentence (was :777) added "(the $GD_{BI}$ of the budget paragraph above, since $GD_{WS} = GD_{WI}+GD_{BI}$ and $GD_{WI}=0$ with inbred parents)", so 05b:476 ($GD_{BI}$) and 05b:777 ($GD_{WS}$) are linked. Kept both symbols; did not rename either |
| foundations-C4 | owed -> 90 | appendix not edited (later chapter). Every item stays in the THREAD 90 rows; add 90:119, 90:627-630, 90:587-591, 90:10-11 and the missing rows listed in C4 |
| foundations-C5 | fixed | 02 (:363-365): "$1-\bar f = H_T$ ($= GD_T$, @eq-gd-partition below)", "$1-\tilde f = H_S$ ($= GD_{WS}$)". Both follow from the definitions in @eq-gd-partition / `tbl-gd-partition` ($GD_T = 1-\bar f$, $GD_{WS} = 1-\tilde f$) |
| foundations-C6 | fixed (qualifier half); owed -> 02b (second-run half) | 02b: one sentence after the "illustrative heterosis" paragraph: GCA and SCA of that half are those of $H$ (@eq-het-gca-sca), not of the cross mean `gv`. Cutting the second `heterosis_gca_sca()` run (chunk `response-gca-sca`, `tbl-response-gca-sca`) needs a chunk change, excluded by this pass; left as a keep-in-THREAD item for 02b |
| foundations-C7 | owed -> 03 | later chapter; cross-reference rather than re-derive the finite-pool offset |
| foundations-C8 | owed -> 01 | not wording-only: the statement $p_{b,k} = p^{*}_k$ for the book's simulated pools (and the floor $m^{-1}\sum_k(p^{*2}_k+q^{*2}_k)$ in expectation) is a claim I have not checked numerically here, so I did not write it. To be verified (one chunk in 01) before the sentence is added |
| foundations-C9 | fixed | 02b (first appearance of the substitution effect $\beta_k/2$): "this is the additive effect $a_k$ of @sec-hybrid-programme and @sec-heterosis for $d_k \equiv 0$, since the two homozygotes, worth $\pm a_k$ there, differ by $2a_k = \beta_k$ here". Derivation: $\mathrm{gv} = \sum_k\beta_k x_k$, $x_k \in \{0,1/2,1\}$ so the homozygotes (0 and 1) differ by $\beta_k$. The $\mathbf a$ of the economic weights and $a_i$ (line value) vs $a_k$ letter clash is not touched (90 owes $a_i$, $b_j$) |
| foundations-C10 | fixed (00 heading); owed -> 90 (glossary) | 00:451 heading now "identity in state", matching 01:239, 02:95, 03:537 (and the adjective "identical in state" at 00:454). 90:618 still says "identity by state": owed -> 90 |
| foundations-C11 | fixed | 01 (after the `ctx` print): the data are the teaching scale (A8, @sec-hybrid-programme), with inline `r book_cfg[["n_pool_A"]]` + `r book_cfg[["n_pool_B"]]` lines, `r book_cfg[["m"]]` markers, `r ctx[["N"]]` hybrids; no number typed |
| foundations-C12 | fixed | index:30-33: "meaningless" replaced by "the group coancestry and the status number computed from it are zero and divergent by construction, and carry no information about the set" (what 01:92-136 shows: $\theta_S=0$, $N_s$ diverges, `Ns_on_G` the reciprocal of round-off) |
| foundations-C13 | owed -> 12 | later chapter (secondary 08); no edit |
| foundations-C14 | fixed | 01:374, 05b:620 and 05b:1194 now read "@eq-balding-nichols, stated later, in @sec-simulating-crosses". (05b:670 as numbered in the report carries no citation of the equation in this tree: no edit) |
| foundations-C15 | fixed | 05b: "the merged candidate population" -> "the merged candidate set" |
| introduction-C1 | fixed (preface reworded, no code added) | Decision: reword the promise to what the book does, not add printed deviations to 00, 01, 02. Why: the identities in 00, 01, 02 are asserted with a stated tolerance (`tol_id`, 00:58; `all.equal`/`stopifnot`), which does break the render if they fail; printing a deviation for each of ~45 assertions would add chunks and output to three approved chapters for no new information beyond "below tolerance", and the instruction was no code. Index now says: the code asserts exact identities against an oracle or second computation with a stated tolerance, so the book does not render if one fails; the achieved deviation is printed where a chapter reports one, not for every assertion; Monte Carlo agreement is given as the estimate with its dispersion and the value compared with (what 00:498-505, 673-682 print). Limit: the sentence no longer promises a printed deviation per identity; a reader wanting the deviation for an unprinted assertion reads the chunk |
| introduction-C4 | fixed | 00:175 "used throughout the book" -> "the ones @sec-stages uses; the chapters of the last column treat the stages, and not all of them use the names" (S1-S4 absent from 07, 09, 10, 10b by the report's grep, which I did not re-run). 00:10 "the four stages the rest of the book refers to" -> "the four stages that @sec-stages measures" |
| introduction-C5 | fixed | index: $f$, $G$ -> $\mathbf{f}$, $\mathbf{G}$ |
| introduction-C6 | fixed | index: "a *random* set of the same size carries on average" and "the mean over random subsets of size $n_{sel}$" (agrees with 00:314-316, 90:290) |
| introduction-C7 | fixed | index: "The coancestry-based diversity metrics are computed on the ... matrix $\mathbf{f}$" (the 00:463-465 wording) |
| introduction-C8 | fixed | index: "which is why the book builds the theory first (the second half of the Introduction, then Foundations)" |
| introduction-C9 | fixed | 00:752 duplicate sentence replaced by "The Preface tabulates the same order, one sentence per part." The repeated parenthesis on @sec-programme/@sec-cycles (index:136, 00:748) and the duplicated list of departures (index:48-66, 00:709-732) left: the 00 half is declared repetition per the report; not merged here |
| introduction-C10 | fixed (index); later chapters follow in their own reviews | index "The default scale" -> "The teaching scale of the live examples (assumption A8 of @sec-hybrid-programme)". "book scale" in 03, 04c, 07, 09, 10, 10b, 90, 92 untouched |

## Diffs (all in the worktree, uncommitted)

- `book/02-subdivided.qmd`: ~:363-365 (C5, two parenthetical equalities); ~:605-607 (C1).
- `book/00-hybrid-programme.qmd`: :10 (intro-C4), :175 (intro-C4), :445-446 (C2), :451 heading (C10), :752 (intro-C9).
- `book/05b-heterosis-dominance.qmd`: heading id and one sentence at "A second identity" (C2); :479 (C15); :620 and :1194 (C14); :777 (C3).
- `book/02b-response.qmd`: ~:474 (C3); ~:539 (C9); ~:592 (C6 qualifier).
- `book/01-coancestry.qmd`: :374 (C14); after the `ctx` print, ~:67 (C11).
- `book/index.qmd`: :24, :28-33, :34, :69, :76-81, :159 (C12, intro-C1, C5-C8, C10).
- `book/downloads/*.R` regenerated by `make_downloads.R` (not by hand).

Not verified by me: the S1-S4 usage greps and the 90 cross-checks come from the part reports. Nothing was rendered, so the new `@sec-heterosis-hybrid-identity` and `@eq-het-wi-hyb` resolution is checked by grep only (one definition, one citation), not by Quarto.
