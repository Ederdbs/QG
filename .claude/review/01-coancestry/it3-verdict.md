# Verdict -- 01-coancestry, iteration 3

VERDICT: APPROVED

Scope: only the form-pass changes after the iteration-2 APPROVED: wording fixes E1, E2, E3, M14 (base-population floor vs panel floor), the seven chunks converted to labelled tables (E6), the comment-only change in `R/01_metrics.R` (M15), and the ruling on contested E5. The chapter was read in full (539 lines) because the working tree has no committed iteration-2 snapshot; the origin/main diff mixes iterations 1-3, so changes were identified from it2-verdict.md, editor.md and editor-response.md and checked against the whole text. Other IDs stay closed; this diff does not touch them. No book/Rplots.pdf exists (checked before and after).

Counts: new disqualifying 0; new non-disqualifying 1 (Low, 01-M16). Open non-disqualifying: 1, below the threshold of three.

## PREVIOUS IDS
- 01-M14 -- CLOSED -- two names for two quantities, each defined where used. "Base-population floor" = m^-1 sum_k (p_b,k^2 + q_b,k^2) (:248-249, :444-445, with p_b,k = 0.5 giving exactly 1/2); this is the "floor" of 00:515-522 and @eq-hp-ibs-ibd. "Panel floor" = m^-1 sum_k (p_k^2 + q_k^2) with p_k the frequency in the N hybrids (:307-313), declared "an identity of the set, not a measurement of the base-population floor"; chunk `tbl-panel-floor` asserts mean(f) = floor_p at 1e-12. The G_0.5 closing sentence (:447-449) says the convention is not the panel floor, which is >= 1/2; both statements true. "0.5 is the floor of the diagonal" is now "the minimum of the diagonal" (:340), correct (all-heterozygous hybrid, f_ii = 1/2).
- 01-M15 -- CLOSED -- `R/01_metrics.R:2-4` now says the coancestry-based metrics read `ctx[["f"]]` and that `theta_from_freq()`, `he_nei()`, `freq_metrics()` read `colMeans(X[idx, ])`, `freq_metrics()` also the frozen `ctx[["p0"]]`. Checked against the code (:60-61, :74-75, :214-217). Comment only (`git diff` shows 3 comment lines changed), ASCII. One residual imprecision recorded as 01-M16.
- 01-E1 -- CLOSED -- :236-237 names the paragraph "What the scale of f is"; that bold run-in paragraph exists (:239).
- 01-E2 -- CLOSED -- `1` defined at first use (:74-76) with length N for both uses before eq-f-matrix; the later definition (:275) adds length m and J. Correct for N x m (`1 2p'`) and `1'G1`.
- 01-E3 -- CLOSED -- `m` and `M^H` named at first use (:26-27, :33-36).
- 01-E5 -- ruling below.
- 01-E6 -- CLOSED -- see ruling and verification below.
- 01-E4 -- owed row (below), not blocking.

## RULING ON 01-E5 (contested, headings not promoted)
Accepted for this chapter. Reasons: (a) no criterion of rigour depends on heading level; (b) the editor's own report calls it optional and not an error; (c) the only in-chapter pointer to "What the scale of f is" now cites it by name (:237), and "A limit of constraining this matrix" is not cited anywhere; (d) a grep of the book source shows no `@sec-` to either head. Promotion would add ids no one uses and shift the numbering of a frozen chapter. If the mixed bold run-in / `###` levels are to change, it is a form decision for quant-editor on the whole part, not a defect of this diff. Closed.

## DISQUALIFYING FAILURES
None.

## NON-DISQUALIFYING OBSERVATIONS
- 01-M16 `R/01_metrics.R:2-4` (code comment) -- the header splits metrics into "coancestry-based" (read `f`) and the three it names as frequency-based; `alleles_lost()` (:189) and `gst()` (:291-292) also read `colMeans(X[idx, ])` and are not named, so by omission the sentence implies they are coancestry-based. The chapter text (:516-518) lists `alleles_lost` correctly, and chapter 01 is true without the comment. Low. Owner: quant-Rwrite, next touch of the file; not a blocker.

Info (nothing required):
- "Panel floor" carries the word "panel" but is computed from the frequencies in the N hybrids (as the text says, :310-313), so it depends on the set as well as the panel. Defined where used, so no number is wrong.
- Table row `floor` in `tbl-panel-floor` is the panel floor, matching the caption; the row label alone does not say which floor. Form, quant-editor.

## OWED ROWS
| Row | Names its chapter | Chapter 01 true without it |
|---|---|---|
| 01-E4 -> 90-notation | yes: `book/90-notation.qmd` has no row for $\overline{G}_{ii}$, $\mathbf{1}_S$, $p_{b,k}$, $q_{b,k}$, $\bar f^{L}_{AB}$; `GD_S` appears only at :282 as a component of a formula, not as a defined symbol (grep run) | yes: each is defined in the chapter where used |
| 01-M16 -> R/01_metrics.R header | yes, see above | yes |
| index (carried from it2) | `index.qmd:32` "meaningless" | yes |

## WHAT WAS VERIFIED
- Chapter purled and sourced against the worktree (`pkgload::load_all`, `simulate_data(book_cfg)`, N = 625): every `stopifnot` passes, "ALL OK". Seven new tables rendered by `kable`; printed values equal the iteration-2 values: sum_G -4.179e-11, theta_S_on_G -5.348e-17, Ns_on_G -9.349e+15, min_G -0.1389; Ns_all 0.7442, subsets 0.6943-0.7445; MC 75.7129 vs formula 75.5192, s.e. 0.1065; min f 0.6448, max 0.8318, diag mean 0.8192, off-diag 0.6717; floor 0.6719, MAF > 0.30 0.5271, MAF < 0.15 0.8710; molecular F 0.6383, heterozygous fraction 0.3617 = 1 - fL_AB 0.3617; G05 range 0.579-1.327.
- Every `stopifnot` of iteration 2 is still present in the corresponding chunk (G sum, Ns in [1/2, 1], Gram >= 0, MC within 4 s.e., exact closed form 1e-12, f in [0, 1], literal 5 x 5 sum, tcrossprod identity, mean(f) = floor_p, off-diagonal identity, diag(f) = (1 + F_i)/2, 2(1 - fd) identities, G05 = 4f - 2 and the quadratic form). Seeds unchanged (1, 3, 11, 2). Only the printing moved (the `tbl-diagonal` print sits after its stopifnots).
- Each of the nine tables is cited with `@tbl-` and the citation precedes or sits in the introducing sentence: tbl-g-sums (:110, :132, :157), tbl-ns-on-f (:138), tbl-subset-sum-mc (:167), tbl-f-summary (:250, :305), tbl-panel-floor (:315), tbl-diagonal (:365), tbl-g05-range (:436), tbl-matrix-roles (:495). Captions agree with the code (1000 subsets of random size; 20000 draws, n = 100; MAF 0.30 / 0.15; four-significant-digit format for tbl-g-sums). Reason for `format(digits = 4)` there (fmt would round the residue to 0) is correct, as the printed output shows.
- `1 2p'` is N x m with `1` of length N; `1'G1` length N; eq-f-matrix `X11'` uses length m: the "conforming length" wording is right.
- "Floor" in 00:515-522 is m^-1 sum_k (p_b,k^2 + q_b,k^2), the base-population floor of 01; the new naming agrees with 00.
- `book/downloads/01-coancestry.R` contains the kable/stopifnot content of the current chapter and the renamed floor wording (grep).
- `R/01_metrics.R` diff against origin/main: three comment lines only; ASCII (non-ASCII grep empty).

## NOT VERIFIED
- Quarto/Pandoc resolution of the `@tbl-` cross-references and the rendered table captions -- chapter not rendered (the author's own note says the same); the labels, prefixes and citations were checked in the source only. Form matter, not decisive for content; would be settled by the close-of-review render.
- Falconer & Mackay chapter number (:45) and primary text of Malecot (1948), Lindgren et al. (1997), VanRaden (2008), Toro et al. (2014), Eding & Meuwissen (2001) -- as in iteration 2; not decisive.
