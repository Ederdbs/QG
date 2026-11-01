# Response -- book/06-metric-catalogue.qmd -- iteration 1 (prose agent)

Run end to end: `knitr::purl` + `pkgload::load_all`, scratch `/Users/ederdbs/.claude/jobs/1f3dbb75/tmp/06w`;
every chunk runs, every new `stopifnot` passes, every inline expression evaluated (values below).
Not rendered. `make_downloads.R` re-run (06 and 05b scripts regenerated). No `book/Rplots.pdf`.

| ID | fixed / contested | what changed / evidence |
|---|---|---|
| 06-D1 | fixed | "Where this could go next": Nei partition H_T = H_S + D_G credited to @nei1973; new @eq-catalogue-het-hs-dg, per locus pA+pB-2pApB = H_T,k + D_G,k = H_S,k + 2 D_G,k (H_S,k = pAqA+pBqB, D_G,k = y_k^2/2); flat d gives 2(D_G + H_S/2), lambda = 1/2; new @eq-catalogue-lambda-d, lambda_d = dbar_H / (2 dbar_D) (H_S- and D_G-weighted means of d); stated as a local, plan-dependent weight, valid only for expected heterosis. Verified in scratch on 1000 random loci with d ~ Exp(1): max error 2.2e-16 for both identities, `all.equal` on the d-weighted factorisation and on dbar = dbar + cov/mean forms; lambda_d = 0.536 vs the ratio the old text named, 0.199. New chunk `catalogue-het-identity` asserts 1 - theta_AB == (GD_T - GD_BS) + 2 GD_BS on the five selections (= @eq-het-theta-ab). |
| 06-D1 (05b) | fixed | 05b `sec-heterosis-lambda`: the sentence now says lambda = 1/2 under flat dominance and lambda_d otherwise (@eq-catalogue-lambda-d); the first bullet's second covariance changed from cov(d, 2 pbar(1-pbar)) to cov(d, H_S) with H_S,k = pAqA + pBqB (dbar_H = dbar + cov(d,H_S)/mean(H_S), checked with `all.equal` in scratch). No other 05b text touched. |
| 06-D2 | fixed | Rise stated as measured inline (GD_BS 0.035 -> 0.0524); additive index declared (no dominance term, @sec-simulating-crosses, R/00_data.R:130), so complementarity ruled out as cause; rise attributed as "consistent with" concentration, with inline Ne_lines (truncation 4.5 / 11.8 vs random 18.6 / 20.9) and the sampling-variance-in-y_k^2 argument; the separating comparison (same concentration, random lines) stated as not evaluated. |
| 06-M1 | fixed | Truncation now "the unconstrained optimum of the index -- gives the alpha at which the constraint stops binding"; text says it is not the maximum alpha over all subsets. Printed label renamed `attainable_alpha_max` -> `alpha_truncation`. |
| 06-M2 | fixed | Replaced "not comparable ... on the N_s scale" with the reason: f_o omits fbar_d/n of Eq. (1), so 1/(2 fbar_o) is not the set's N_s and the gap grows as n shrinks. |
| 06-M3 | fixed | Identity chunk: `stopifnot(all.equal(...))` for theta routes and GD == He; prose states the tolerance (1.5e-8) and the printed difference inline (0). GD_WI: "zero to machine precision", inline max |GD_WI| = 6.7e-16. Bias chunk keeps draws, prints `mc_se` (4.12e-05), asserts |obs - pred| < 4 SE; prose inline: residual = 1.32 SE; "exact in expectation". |
| 06-M4 | fixed | Inverse Simpson cited [@simpson1949] with the Lacy founder-equivalents form [@lacy1989]; participation ratio cited [@belldean1970] as term origin, "applied here to eigenvalues" (paper not read, only metadata verified -- the sentence claims only the term's origin); López-Cortegano qualifier added (all weight within subpopulations: maxHT controls molecular inbreeding best, still fewer alleles). |
| 06-R1 | fixed | "near 3.6%" removed; inline book-scale value alpha = 4.12% (n = 60, 25+25 lines, 2000 markers), conditional wording ("be inoperative"/"bind") from `attainable < 0.05`; production scale declared not computed and not transferable. |
| 06-R2 | fixed | Closing paragraph rewritten from `zt`: truncation F_drift z = 30.1 vs GD -17.9; trunc_cap GD -1.3, ANE 17.9, alleles_lost 3.3; Ne_parents claim for truncation dropped; MC error of z (B_full = 60, inline) stated. Survives R13 (B_full = 1000: 36.0 vs -18.0; -1.3 / 16.4 / -). |
| 06-R3 | fixed | N_s head-count reading restricted to base-referenced coancestry (theta = 1/(2n), N_s = n); on molecular f theta in [1/2,1], N_s in [1/2,1], monotone rescaling; edge-case comments rewritten as the two bounds; inline: 5 individuals give N_s = 1, selections 0.727-0.747. |
| 06-R4 | fixed | "In relative terms" with inline -66.9% (Ne_par) and +1.98% (theta); states the order reverses on the z scale of the new @sec-catalogue-null and why. |
| 06-R6 | fixed | Restricted to "among the metrics of the redundancy analysis in @sec-choosing"; states F_drift/F_hom are absent from that analysis (`book/data/metric_redundancy.csv` columns) and F_drift has the largest truncation z. |
| 06-R9 | fixed | "n - 1 if spread evenly over the n - 1 dimensions that double-centering leaves"; eigenvalues stated to be of the double-centered submatrix. |
| 06-R10 | fixed | "at least n theta" with the Rayleigh argument; chunk computes `lead_ratio`, asserts >= 1; inline max excess 0.016%. |
| 06-R14 | fixed | Callout retitled "Global theta does not say which pool was eroded"; body no longer claims global theta looks fine; states the matched-alpha case is not tested. |
| 06-R15 | fixed | Equation now E[theta_S] - theta_N, expectation over random S declared; counterexample inline (greedy_div theta_S 0.66976 < theta_N 0.67191). |
| 06-B1 | fixed | `toro2020` doi -> 10.1111/jbg.12455 (Crossref: Toro, Villanueva, Fernández, JABG 137(4):345-355). |
| 06-B2 | fixed | Partition credited to Nei (H) and Caballero & Rodríguez-Ramilo (A); weighted forms credited to López-Cortegano et al., "five subpopulations"; two-pool reading declared this book's analogy. lambda = 0 sentence adjusted to "protects the divergence term of heterosis" (consistent with D1). |
| 06-B3 | fixed | "@odong2013 proposed, and Core Hunter 3 implements"; d = 1 - f declared the book's choice. Bib `odong2013` added (Crossref: TAG 126(2):289-305, doi 10.1007/s00122-012-1971-y). |
| 06-B4 | fixed | via M4 (qualifier added). |
| 06-B6 | fixed | `simpson1949` (Nature 163:688, doi 10.1038/163688a0) and `lacy1989` (Zoo Biol 8(2):111-123, doi 10.1002/zoo.1430080203) added, Crossref-verified. |
| 06-B7 | fixed | `belldean1970` (Discuss Faraday Soc 50:55, doi 10.1039/df9705000055) added, Crossref-verified. |
| 06-R5 | left to code agent | greedy_w1 w choice. Prose at "rank almost identically" stays true with w = 0.001 (checked: theta and off-diagonal give the same order on all 5 sets; w = 0.001 alpha 0.031). New prose names only `truncation`, `trunc_cap`, `greedy_div`, `random`. |
| 06-R7 | left to code agent | adaptive timing; prose at "matrix route belongs in the inner loop" does not cite the ratio. R/01_metrics.R:51 roxygen "100x" untouched. |
| 06-R8 | partly done (M3) | stopifnot added for theta/GD identities, Rayleigh bound, het identity, MC bias. Not added: GD_WI assertion, Eq. (1) check. |
| 06-R11 | left to code agent | A-NE self-distance: prose not changed (beyond B3). Dependency: if `ane()` keeps d_ii = 1 - f_ii the code agent must declare it in the prose; if it zeroes it, the formula as written matches @odong2013 and no prose change is needed. |
| 06-R12 | left to code agent | seed before `sels`: all new numbers are inline, so they follow. |
| 06-R13 | left to code agent | B_full: all z numbers inline; MC-error caveat uses `nrow(null[["full"]])`. |
| 06-R16 | not required | untouched. |
| 06-B5 | not required | untouched. |

## Code agent -- iteration 1

Run end to end: `knitr::purl` + `pkgload::load_all`, scratch `/Users/ederdbs/.claude/jobs/1f3dbb75/tmp/06r`;
every chunk runs (6.2 s), every `stopifnot` passes, all 27 inline expressions evaluate. Not rendered.
`make_downloads.R` re-run (06 and 90 scripts changed). `book/Rplots.pdf` absent.

| ID | fixed / contested | what changed / evidence |
|---|---|---|
| 06-R5 | fixed | `greedy_w1` (w = 1, == truncation) -> `greedy_w` with w = 0.001 and a comment why; alpha 0.0311, distinct from truncation (0.0412) and all other rows; Spearman theta vs offdiag still 1 over 5 distinct points. |
| 06-R7 | fixed | Fixed `reps = 40` replaced by the `bench_us()` adaptive loop of `book/scripts/regenerate.R` (repeat x4 until > 0.4 s): 8.1 vs 130.5 us, ratio 16.2. R/01_metrics.R:51 roxygen "roughly 100x slower here" -> "the slower route whenever `m > n`" (no number); `devtools::document()` rewrote `man/theta_from_freq.Rd` only. |
| 06-R8 | fixed (remainder) | `stopifnot(all(abs(gdp[, "GD_WI"]) < 1e-12))` in the partition chunk; inline max now reads `gdp` and the prose states the 1e-12 assertion. Eq. (1) asserted with `all.equal` on all five selections in the `sels` chunk. |
| 06-R11 | fixed (prose, R/ unchanged) | `ane()` NOT changed: `book/data/metric_redundancy.csv` (column `A_NE`, read by @sec-choosing) and `12-case-study` (`z_ANE`) were computed with the current definition; `ref_ane()`/test-stage-metrics/92-verification compare against it. Departure from @odong2013 (self-distance 1 - f_ii instead of 0) now declared after the A-NE table; chunk computes the self-distance-zero version, asserts gap >= 0, inline gap 0.0174-0.0178, ranking of the five selections "unchanged" (computed). |
| 06-R12 | fixed | `set.seed(42)` immediately before `sels <- list(...)`. Random set moved: GD_BS 0.0350 -> 0.0374, Ne_lines 18.6/20.9 -> 17.6/16.8 (all inline); Ne_parents relative drop 66.9% -> 62.2%, theta +2.01% (inline); qualitative claims hold. |
| 06-R13 | fixed | `B_full` 60 -> 1000 (chapter runtime 6.2 s total). z: truncation F_drift 36.0 vs GD -18.0; trunc_cap GD -1.5, ANE 16.4, alleles_lost 3.5; truncation Ne_parents -12.6 (less extreme than GD, as the "order reverses" sentence says). |
| 90-N_s | fixed | book/90-notation.qmd:610 glossary: N_s is a head count only against a base population; on molecular f it lies in [1/2, 1] and is a monotone rescaling of theta (@sec-ns). |
`devtools::test()`: DONE, no failures (R/ change is roxygen-only).

## Editor pass

Run end to end: `knitr::purl` + `pkgload::load_all`, scratch `/Users/ederdbs/.claude/jobs/1f3dbb75/tmp/06wE`; every chunk runs, every `stopifnot` passes, all 30 inline expressions evaluate; 23 `#|` lines parse with `yaml::yaml.load`; all 35 `@tbl-/@eq-/@sec-` targets in 06 resolve to exactly one label. 90 purled and sourced (kable column lengths consistent). Not rendered. `make_downloads.R` re-run. `book/Rplots.pdf` absent.

| ID | fixed / contested | what changed / evidence |
|---|---|---|
| 06-E1 | fixed | Chunk labelled `tbl-catalogue-offdiag` (caption: theta_S vs off-diagonal mean, the five selections, @eq-catalogue-split asserted). Spearman moved to prose: `rank_cor` computed in the chunk, inline `r fmt(rank_cor, 3)` = 1, with "five points are a check of the ordering, not an estimate". Prose cites the table before it. Added `stopifnot(n_sel == 60, ctx$N == 625, ctx$n_lines == 50, ctx$m == 2000)` so the scale typed in every caption breaks the render if it changes. |
| 06-E2 | fixed | Five console vectors -> one labelled single-column/two-column table each, cited before: `tbl-catalogue-ne-par` (the `theoretical_max` entry moved to prose as an upper bound, inline `r ctx$n_lines`; it is not attainable at n = 60, 120 parent slots over 50 lines give at most 48), `tbl-catalogue-alleles-lost`, `tbl-catalogue-deff` (chunk keeps the Rayleigh `stopifnot`), `tbl-catalogue-ne-lines` (callout now ends "is @tbl-catalogue-ne-lines"; values via `fmt(, 2)`), `tbl-catalogue-alpha` (GD_random(n) = mean GD of 400 random subsets, seed 7 -- `null_distribution()` default). Diagnostic echoes (:91-98, :127, :155-158, null/bias/attainable chunks) unchanged. |
| 06-E3 | fixed | `book/90-notation.qmd`: Coancestry table + `eta_ij`, E-NE/A-NE, MAF/A_lost, D_eff/gamma_i; Heterosis table + H_T/H_S/D_G (per-locus forms, two-pool mapping to GD_T/GD_BS), A_T/A_S/D_A, lambda_d/dbar_H/dbar_D; Selection table + GD_random(n) (stated as the same quantity as GD_ref) and omega. x_ik already in 90 with the same meaning; not duplicated. |
| 06-E4 | fixed | (a) distance d_ij -> `eta_ij` (eq-catalogue-ene-ane, prose, caption, `eta_ii` in the A-NE departure note); `\eta` occurs nowhere else in the book (`\delta` is taken by 01, 04c, 90). (b) greedy index weight in the five+one captions -> `omega` "(argument `w` of `sel_greedy()`)"; `\omega` unused elsewhere. Chapter 10 still writes the same weight as `w`; 90's omega row says so. |
| 06-E5 | fixed | Code comment -> `# @eq-catalogue-split on every selection`. |
| 06-E6 | not taken | Optional. The note's body states what global theta does not show and that the per-pool erosion test is not done; it asserts no trap, so `note` matches the content. |

Residual for the writer: 06 writes the alpha reference as `GD_random(n)`, 90 and chapter 00 as `GD_ref`; 90 now states they are the same quantity, but a single symbol across the book would satisfy rule 5 outright.
