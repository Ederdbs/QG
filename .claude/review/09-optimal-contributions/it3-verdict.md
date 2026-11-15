# 09-optimal-contributions -- it3 verdict (form pass)

VERDICT: APPROVED

PREVIOUS IDS
- 09-M7 -- CLOSED -- the unsupported claim ("not enough at larger lambda") is gone; the text says larger lambda and N are not measured here and that ocs_bound() checks per call. No 4000-vs-64000 numbers typed.
- 09-M8 -- CLOSED -- text now states the 1e-3 is applied to V at lambda = 10 here and to V(lambda)+lambda*theta_max in ocs_bound(); "converged" is a stalling criterion. Matches R/12_search.R:347-353 (tol on the min-over-grid bound value, not a certificate).
- 09-M9 -- CLOSED -- four rows in book/90-notation.qmd, consistent with eq-ocs-alpha/theta-max/V/problem, no clash.
- 09-M10 -- CLOSED -- "no bias detected, resolution about 0.002 ... against 0.037; a few percent not excluded". Recomputed.
- 09-M11 -- CLOSED -- assumption 3 now states the exact-optimiser inequality and declines to extend it to the chapter's heuristics. Correct (same feasible set, f is the same).
- 09-M12 -- OPEN (not this chapter) -- cross-chapter wording in 07, 10b, 02b, CLAUDE.md, owned by other reviews.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 09-M13 book/09-optimal-contributions.qmd tbl-ocs-thin caption ("Four decimals for the bias, one for rel_sd") and tbl-ocs-panel-spread rows ("seed1"): the caption keeps the raw name rel_sd where the header now reads "rel. s.d. (%)"; the spread table's statistic column still prints the raw label seed1. Same metric, two names.
- 09-M14 book/09-optimal-contributions.qmd, convergence paragraph after tbl-ocs-convergence: "checks the change in the bound value at each lambda grid it is given" -- ocs_bound() tests the change of the minimum over the grid between iteration counts (R/12_search.R:336-352), not each lambda; the reading "per call" is defensible, "per lambda" would be wrong. Imprecise, not false.
Two non-disqualifying items: below the rejection threshold of three.

WHAT WAS VERIFIED
- Chapter purl'd and run end to end (load_all of the worktree, seed as in chapter, sandbox png device): every stopifnot passed, no error. Scratch only; book/Rplots.pdf created by my first run was deleted.
- Column order vs col.names: tab_relax (lambda, index, theta, GD, alpha, bound_term) = 6 headers; conv 4; front_qp (lambda, merit, coancestry, n_used, share_A) = 5; sens 4; sub (w, alpha, index, Ne_par) = 4; thin_tab 7. All match the headers and caption keys.
- The two row.names = FALSE chunks (tbl-ocs-frontier, tbl-ocs-thin) run: markdown output has no blank row-name column. thin_tab: 250 -> bias -0.0004, se 0.0011, rel_sd median 36.1, within_1sd 20; 500 -> 0.0008/0.0009/24.3/19; 1000 -> 0.0001/0.0004/10.7/19.
- M10 inline: fmt(2*se250, 3) = 0.002; fmt(mean(full$a_full), 3) = 0.037; ratio 0.059 ("a few percent"). Rel. spread of a third = 36.1% median at 250 markers.
- M8 numbers: rel_change of V from 4000 to 16000 iterations = 1.76e-6 (< 1e-3); V = -5.194, -4.879, -4.8748, -4.874792; ocs_bound = 1.5532, converged TRUE, iters 8000 (= 4000 doubled once; caption "doubled from 4000" consistent).
- a_trunc (seed 1, B = 400) = 0.0412; panel table alpha_trunc 0.0402-0.0421.
- book_pal keys used (mid, loss, ink) exist in _common.R:58; hex of loss/mid unchanged; legend colours match plotted colours; frontier line no longer pool-A blue.
- Callout tip -> warning: fences consistent (::::-nested for the two with code/wrapping, ::: for the other).
- Notation rows: Symbol, Meaning and Function vectors have 16 entries each in "Selection and optimisation"; V(lambda), theta_max, u-bar_S, alpha_trunc agree with eq-ocs-V, eq-ocs-theta-max, eq-ocs-problem and with 10 / 10b usage; no other entry in 90 uses these symbols (V_W, V_B, V_genic, bold V are distinct).
- All @tbl-/@fig-/@eq-/@sec- targets in 09 and 90 resolve to a label in book/*.qmd (script: none missing).
- downloads/09-optimal-contributions.R contains the col.names and both row.names = FALSE changes.

NOT VERIFIED
- Quarto render (Typst widths of tbl-ocs-relaxation and tbl-ocs-thin, legend overlap in fig-ocs-relaxation, orphan unnamed-chunk files): not rendered, form matters owed to the render batch (09-E5); not decisive for content.
- book/data/ocs_panel_sweep.csv is still untracked (`??`); the chapter calls it reproducible from the repository and the downloadable script fetches it from GitHub raw. It must be committed with the chapter; not a content failure here.
- Claim that the iteration count that converges here does not at N = 10,000 (pointer to @sec-bound): carried from it2, not re-measured.
