# 09-optimal-contributions -- iteration 1 response (quant-writer)

Files changed: `book/09-optimal-contributions.qmd` (rewritten around the bound; 17 labelled chunks, 12 `stopifnot` calls), `book/scripts/regenerate.R` (new target `ocs_panel`), `book/data/ocs_panel_sweep.csv` (new, 460 rows, produced by that target, 35 s), `book/references.bib` (`boyd2004` added; `gorjanc2018` pages 1953--1966), `book/07-choosing-metrics.qmd` (one sentence, :1005), `book/10b-advanced-selection.qmd` (two sentences, :637 and :744-752), `book/downloads/09-optimal-contributions.R` (regenerated; `make_downloads.R` also touched other downloads that other sessions had made stale). No `R/` file touched. No `quarto render` run. Scratch (`book/figure`, `Rplots.pdf`) absent after the knit-check, which was run with `knitr::knit` into the scratchpad against `load_all()`: no error, 2.76 min (not 1 min: `ocs_bound()` at 16 multipliers is about 1.5 min of it).

Status words: `fixed`; `contested` (evidence given); `owed -> <ch>`; `-> quant-Rwrite`.

## One contested point of the verdict, with the derivation (D1, R1, C1)

The verdict (and CLAUDE.md, `R/12_search.R` roxygen, 10b @sec-bound) says a discrete plan **at the same diversity** can beat a relaxation point. By weak duality it cannot at exactly equal diversity: with $V(\lambda) = \bar u_\lambda - \lambda\theta_\lambda$ and the equal-weight vector of $S$ feasible, $\bar u_S \le \bar u_\lambda + \lambda(\theta_S - \theta_\lambda)$ (@eq-ocs-weak), so $\theta_S \le \theta_\lambda$ gives $\bar u_S \le \bar u_\lambda$. The construction fails because a plan that *spends the budget* is **less** diverse than a point strictly inside it, and the tangent then rises above the point. The chapter states exactly that, keeps every number of the verdict (valid ordering at the 1% budget, `ocs_bound` 1.5532, $\lambda^* = 68.1$, `converged` TRUE, greedy 1.4227 at $\alpha$ = 0.00685), and asserts weak duality for all 63 discrete plans at $\lambda = 10$. The "best relaxation point inside 1%" printed is **1.3473** (a converged 16-multiplier grid), not 1.0023: 1.0023 is the old 12-multiplier, 4000-iteration grid, which I reproduced in exploration (`ex1.R`, 1.002295) and dropped because at $\lambda \ge$ 30 it is itself under-converged. Both lie below the greedy plan. Owed: the "same diversity" wording in CLAUDE.md, `ocs_bound()` roxygen and 10b @sec-bound ("A discrete plan can beat it, and does").

## Disqualifying

| ID | Status | What changed |
|---|---|---|
| 09-D1 | fixed (see contested point) | Section rewritten as "The continuous relaxation, and what it bounds": @eq-ocs-V, three statements (lambda = 0 is truncation; weak duality @eq-ocs-weak; what does not follow), the valid bound @eq-ocs-bound with Slater/strong duality (Boyd & Vandenberghe 2004, 5.2.3) and `ocs_bound()` doubling and `converged`. Table of the converged sweep with the bound term per lambda. At 1%: relaxation point 1.3473 < greedy 1.4226 < bound 1.5532, asserted. Figure caption corrected; "below and to the left" removed; legend "(upper bound)" removed |
| 09-D2 | fixed | Callout and chunk compare the penalised $V$: 50 it -5.1939, 500 -4.8790, 4000 -4.8748, 16000 -4.8748, discrete (truncation) -4.8840. Asserted: V(50) below discrete, V(4000) above, V monotone, relative change 4000 to 16000 (1.8e-4) below the `ocs_bound()` tolerance 1e-3, and no discrete plan of the chapter (63) above the converged V. "Minimum that converged" replaced by the tolerance and "at this scale" |
| 09-D3 | fixed | Log grid of 60 values of $\omega$, 1e-6 to 1e-1: 39 distinct plans, 11 return truncation, asserted (>= 20 distinct). Figure of distinct points; secant slopes at alpha = -1, 0, 1, 2, 3 % and truncation (0.52, 0.31, 0.22, 0.15, 0.1 index per pp); no knee claimed, said so; the old integer-style grid named as the cause of collapse |
| 09-D4 | fixed | Penalty stated as absolute excess of alpha times 1000; `tbl-ocs-penalty` checks `penalty * viol` against `make_fitness()` on the truncation plan at 1% (31.2) and 5% (inactive, 0) and prints the 10% overshoot price (1.0 and 5.0). "Proportional" sentence removed; "not refused at any price" |
| 09-D5 | fixed | $\alpha$ defined by @eq-ocs-alpha with @eq-catalogue-alpha / @sec-baseline; budget $\alpha_{\max}$ vs truncation ceiling $\alpha_{\text{trunc}}$ separated, defined as in 06 (the alpha at which the constraint stops binding, not the largest alpha of any subset); $\bar H_{\text{ref}}$ -> $GD_{\text{ref}}$; Gomez-Romano's $\mathbf G$ written $\mathbf f$ with the reason, covariance $\boldsymbol\Sigma_P$, $\boldsymbol\Sigma_G$ |
| 09-D6 | fixed | Block cut to what 02b supports: problem statement read in full text by refcheck, solution not read, matrix form "the book's own" (02b); valid $\boldsymbol\Sigma_G$ of 02b with eigenvalue `stopifnot`; zero asserted (< 1e-12; 2.6e-17 against 0.143); "derives", "stood since 1959", "what is new" callout and "refuses at any price" removed; the chapter's own enforcement is a penalty, stated |
| 09-D7 | fixed | Paragraph rewritten: no richness / A-NE / $G_{st}$ promise (09 computes none, says so); "benchmark scale" and production not used; line route stated as slower at N = 2,500, n = 50 and cheaper only for large n (07); cost table dropped, "this chapter times nothing"; 07:1005 re-pointed |
| 09-D8 | fixed | New target `ocs_panel` (20 founder draws; run, 35 s). gd_ref moves 19.1 % (17.7--21.3), alpha_trunc 7.8 % (s.d. 4.4, 1.3--16.8, median 6.7, seed 1 4.7), about 2.5 times less; thin panels: relative s.d. median 36 % at 250 markers (10--81), 24 % at 500, 11 % at 1000; mean difference to the full panel -0.0004 (s.e. 0.0011) at 250; within one s.d. in 20, 19, 19 of 20. Sentences in result / inference form; "not invariant"; seed-1 row of the cached file asserted equal to the live table |
| 09-D9 | fixed | Section "What this chapter assumes" (A2, A7, index = truth hence upper bound on delivered gain, A5 and where it is dropped, lens pinned and $GD_T$ including $GD_{BS}$, teaching scale, one founder draw); QP merit now `line_merit` (mean index of a line's hybrids, against the other pool as tester), no `rnorm` |

## Medium

| ID | Status | What changed |
|---|---|---|
| 09-M1 (= R7, C16 part) | fixed | `max_use` defined once (count of selected hybrids sharing a line as parent), default `NULL`, its term in `make_fitness` explained, `decode()` named |
| 09-M2 (= C11) | fixed | Ceiling paragraph cut to a cross-reference to @sec-baseline plus the two things 09 adds (stage2 warning, B-dependence); the repeated chunk removed |
| 09-M3 (= R14) | fixed | The coercing `c()` chunk is gone |
| 09-M4 (= R15, C10) | fixed | "candidate pools" -> "candidates"; "book scale" -> teaching scale |
| 09-M5 (= R18) | fixed | All figure and table chunks labelled (`fig-ocs-relaxation`, `fig-ocs-frontier`, `tbl-ocs-*`), `fig-alt` added. Orphans after the next render, to delete then (not run here): `book/_freeze/09-optimal-contributions/figure-html/unnamed-chunk-{6,9}-1.png`, `.../figure-typst/unnamed-chunk-{5,6,8,9}-1.svg`, `docs/09-optimal-contributions_files/figure-html/unnamed-chunk-{6,9}-1.png` |
| 09-M6 (= B5, C17, R16) | fixed | Callout "What the contributions are attached to": individual, line, cross named; 09's $c_i$ is a hybrid = one $A \times B$ cross; mating-design part pointed to (@sec-mating); optimal cross selection cited as the title of @gorjanc2018 "for the name only", content unread, nothing rests on it; maize and field-limit claims removed |

## From the audit (R)

| ID | Status |
|---|---|
| R1 | fixed (= D1) |
| R2 | fixed (= D2); `unname` problem gone with the chunk |
| R3 | fixed (= D3) |
| R4 | fixed (= D4); roxygen of `make_fitness` still says "proportional": -> quant-Rwrite |
| R5 | fixed (= D7). `gst()` vs $G_{ST}$ no longer arises |
| R6 | fixed (= D7) |
| R7 | fixed (= M1) |
| R8 | fixed: QP merit not random; `set.seed(42)` before `sel_random`; `stopifnot` on sum(c) = 1 (tol 1e-4) and cap in the loop; `eval` guarded by `requireNamespace("quadprog")`; `sel_random` seeded. Oracle comparison of `ocs_quadprog` vs projected gradient not repeated (audit did it) |
| R9 | fixed (= D8) |
| R10 | fixed (= D6) |
| R11 | fixed (= D5) |
| R12 | fixed (= D5) |
| R13 | fixed: `stopifnot` on penalty identity, restricted zero, V(0) = truncation, lambda = 1 row = truncation, bound = min of bound terms, `converged`, order relaxation < greedy < bound, frontier distinct plans, V ordering / monotone / tolerance / weak duality for 63 plans, seed-1 row of the cached sweep, 60 thin groups, reseed identity, QP sum and cap |
| R14 | fixed (= M3) |
| R15 | fixed (= M4). The Gomez-Romano quantitative sentence: see B1 |
| R16 | fixed (= M6) |
| R17 | fixed: the past-state claim removed; the mechanism asserted in `ocs-reseed` (`identical()` of two draws after `null_distribution()`) |
| R18 | fixed (= M5) |

## From the reference check (B) and the continuity check (C)

| ID | Status | Note |
|---|---|---|
| B1 (= C20) | fixed | Fig. 1 (about 1.4, 0.3, 0.2 % against 0.1 % at N = 20, 100, 200, always above the restriction while the expected rate met it) and Fig. 2 (approximately double the intended rate, N = 20, CHR_ove, 0.1 %) stated separately, with the regional-coancestry setting; "no single factor of two follows"; "candidates", not pools. Checked against the PDF text (`pdftotext`) by me, not only taken from refcheck. 07:1043 still says "roughly a factor of two": owed |
| B2 | fixed | "the authors' suggestion, not a derivation" (p. 11) |
| B3, B4 | closed in the verdict; wording "eq. 1a-1d" added; K&N as in D6 |
| B5 | fixed (= M6); bib pages added |
| B6 | no citation issue; Boyd & Vandenberghe cited for the one duality fact used |
| C1 | fixed (= D1) |
| C2, C3, C4, C5 | fixed (= D5) |
| C6, C7 | fixed (= D6). 02b:748 still says the paper "was not read"; refcheck read the problem statement: owed -> 02b |
| C8, C9 | fixed (= D7) |
| C12 | fixed: the committee decides the budget, the analyst traces its cost, the multiplier is an output ($\lambda^* = 68.1$, 0.22 index per percentage point of alpha on this grid); "choose the knee" removed; weighted sum vs constraint stated through the concave envelope |
| C13 | fixed (= D9) |
| C14 | fixed (= D8): A5 dropped in the sensitivity experiment, said |
| C15 | fixed (= D9, R8) |
| C16 | fixed: `upper` = `max_use`/(2n) conversion given (0.20 at n = 60 is `max_use` = 24); single margin of the QP stated, `share_A` column shows 0.60 at small lambda; same in kind, not the same constraint |
| C17 | fixed (= M6) |
| C18 | fixed: Gomez-Romano's problem as theirs; the constraint form attributed to Meuwissen 2020 Methods through 02b (1997 "reported through it"); this chapter's problem = that form restricted to $c_i \in \{0, 1/n\}$ |
| C19 | fixed: opening points to @sec-choosing-recommendation, defines $\alpha$ by equation |
| C21 | fixed (= D4); "necessary second constraint" -> "a second restriction in the discrete problem of 07; the fitness printed carries only the budget" |
| C22 | fixed (= D2) |
| C23 | fixed (= R8) |
| C24 | fixed: the cross-reference removed, the transfer caution stated as this chapter's |
| C25 | owed -> 90 |
| C10 | fixed (= M4) |

## Edits outside 09 (each made because 09 now makes it false)

- `book/07-choosing-metrics.qmd:1005`: "@sec-ocs also computes allelic richness, A-NE and $G_{st}$ once, on the final solution." -> "@sec-ocs states the optimisation problem whose returned plan these would validate; it computes none of the three."
- `book/10b-advanced-selection.qmd:637`: "introduces the continuous relaxation as an upper bound" -> "introduces the continuous relaxation (the construction below was once read off it as an upper bound)".
- `book/10b-advanced-selection.qmd:744-752`: the paragraph "@sec-relaxation has not been rewritten ..." -> one sentence saying it has, and what it now shows.
- `10:683-686` and `10:818-832` re-read: both remain true ("a relaxation, not a ceiling"; the bound derived in @sec-bound); not edited.

## Owed

- -> `07:1043`: "roughly a factor of two ... small candidate sets, as reported in @sec-ocs" now contradicts 09 (no single factor; about 2 in the N = 20 resampling test of Fig. 2, about 14, 3, 2 against the restriction in Fig. 1, for regional coancestry). Edit to the Fig. 1 / Fig. 2 wording or drop the number.
- -> `02b:748-756`: "not read for this book" against refcheck's full-text reading of the problem statement (the closed form still unread).
- -> `10b` @sec-bound (:635-680 region) and `R/12_search.R` `ocs_bound()` roxygen, CLAUDE.md: "a discrete plan at the same diversity can beat it" is imprecise (see the contested point); the correct statement is that a plan spending the budget is less diverse than a point inside it.
- -> `10b:1245`: "@sec-catalogue's rule: one diversity lens" -> cite the assumption list of 09 (item 5).
- -> `90-notation.qmd`: rows for $\alpha_{\text{trunc}}$ (new in this chapter), $\theta_{\max}$, $V(\lambda)$, $\bar u_S$, and a `@sec-ocs` link on the selection table (C25).
- -> quant-Rwrite (`R/`): `make_fitness` roxygen and the comment above it say the violation "becomes a proportional penalty" and `max_use` "enters proportionally" (R/03_de_select.R ~l.157-165): it is an absolute excess in alpha units times `penalty`. `ocs_relaxation` roxygen and the comment above it ("valid upper bound ... 4000 is the minimum that converged") state the construction this chapter withdraws: reword to "relaxation of the penalised problem; a bound only through `ocs_bound()`". After any `R/` change: `devtools::document()`, `devtools::install()`.
- Data: `book/data/ocs_panel_sweep.csv` must be committed and pushed for the downloadable script (it fetches cached files from GitHub raw). `Rscript book/scripts/regenerate.R ocs_panel` reproduces it in 35 s (verified).
- Cost: the chapter now executes in about 2.8 min (16-multiplier `ocs_bound()`); two freeze entries (html, typst) each run once. A smaller grid would cost tightness only.
- Not run: `quarto render`, PDF layout of the two new callouts and the six new tables; the Gomez-Romano and Kempthorne-Nordskog sources beyond what is stated above; Comstock (existence and title only, not cited here).

## quant-Rwrite (R/ wording, no behaviour change)

| ID | Status | What changed |
|---|---|---|
| R4 (roxygen) | fixed | `R/03_de_select.R` `make_fitness`: comment and roxygen now say the violation is charged as `penalty` (default 1000, checked in the signature) times the absolute alpha excess over `alpha_max`; `@param penalty` states the unit; `max_use` doc states the violation is the line uses above `max_use`, summed over lines and divided by `2 * n_sel`, added to the alpha excess and charged at the same `penalty`. "Proportional" removed |
| 09-D1/D2 (ocs_relaxation) | fixed | `R/03_de_select.R`: section header, comment and roxygen no longer call the relaxation a valid upper bound; they say it relaxes the penalised problem, that V(lambda) >= the penalised value of any discrete plan, that a plan spending the budget can beat a relaxation point inside it, and that the bound is `ocs_bound()` (Lagrangian). "4000 is the minimum that converged" replaced: 4000 is a default; convergence is a relative-change tolerance on V under doubling (as `ocs_bound()`), and the count grows with N |
| 09 owed ("same diversity", `ocs_bound()` roxygen) | fixed | `R/12_search.R` ocs_bound roxygen, first paragraph only: "a discrete plan at the same diversity can and does beat it" -> a plan that spends the budget is less diverse than a point strictly inside it and can beat it; at exactly equal diversity it cannot (weak duality). Nothing else in `R/12_search.R` touched by me (the file also carries another session's uncommitted edits) |
| rare_retained comment | fixed | `R/01_metrics.R` freq_metrics: comment says what it is (share of the pool's rare markers, maf_pop in [rare_lo, maf), still segregating in the selection) and that it is not the A_ret count of the 2m alleles (ch. 06). Code unchanged |

Checks: `devtools::document()` rewrote make_fitness, sel_de, ocs_relaxation, ocs_bound `.Rd`; `devtools::test()` FAIL 0, WARN 0, SKIP 0, PASS 515; `devtools::install()` done. R/ edits ASCII (grep).
Not touched, same wording remains: `R/04_fast_metrics.R:368` ("as a proportional penalty", `make_fitness_fast`, penalty 5) and `R/12_search.R:24,126` (`ls_objective`/`sel_local_search`, "proportional penalty"): also absolute excess times `penalty`. Left because outside the requested scope; -> quant-Rwrite if wanted. CLAUDE.md "same diversity" and "proportional penalty" wording untouched (user decision).
