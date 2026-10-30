# 01-coancestry -- response, iteration 1

## quant-writer

| ID | Status | Note |
|---|---|---|
| 01-D1 | fixed | Subset paragraph rewritten: 1_S'G1_S = ||Z'1_S||^2/(2 sum pq) >= 0 (Gram matrix); E = n(N-n)/(N-1) mean(diag G), so the value depends on n/N. Checked: min of 2000 random subset sums = 1.77 (> 0); min eigenvalue -6.7e-14; formula vs 4000 draws at n = 10/300/600: 8.85/140.25/21.58 expected vs 8.84/140.81/21.59 observed. Negative off-diagonals are shown through a new `min_G` element in the existing chunk (-0.139). Consumes 01-R1. |
| 01-D2 | fixed | "excess above 0.5 is f_ii - 0.5 = F_i/2: half the fraction..." Checked: all.equal(diag(f) - 0.5, rowMeans(X != 0.5)/2) TRUE. Consumes 01-R2. |
| 01-D3 | fixed | G_0.5 = (M^H - 11')(M^H - 11')'/(m/2) = 4f - 2J is stated as an equation; "affine, not f", entries in [-2, 2]; equivalence stated only under 1'c = 1 (c'Jc = 1). "proportional" is now in quotation marks as Meuwissen 2020's wording. Checked: all.equal(tcrossprod(2X - 1)/(m/2), 4f - 2) TRUE. book/05-genomic-era.qmd:118 caption changed to "G_0.5 = 4f - 2J, an affine function of the matrix this book calls f". The chunk assertion requested in 01-R3 is left to quant-Rwrite. |
| 01-D4 | fixed | toro2014 bib entry is now Toro, Villanueva & Fernandez (2014) Livest. Sci. 166:48-53, doi:10.1016/j.livsci.2014.04.020 (Crossref checked). The prose says "@meuwissen2020, citing @toro2014" because the Toro full text has not been verified (01-B6). |
| 01-D5 | fixed | Added @vanraden2008 (VanRaden's first parametrisation), @lindgren1997 (N_s; metadata still unverified, no DOI), @malecot1948 (Malecot's coancestry), and [@falconer1996, ch. 5] (IBD form of f_ii = (1+F_i)/2). F_i is defined as the fraction of homozygous markers. |
| 01-D6 | fixed | @caballero2000 removed at :120. The citation is now [@caballero2002; @eding2001]. eding2001 was added to the bib, doi:10.1046/j.1439-0388.2001.00290.x, with Crossref metadata matching. caballero2002 remains UNVERIFIED in full text (01-B8). |
| 01-D7 | fixed | The prose now claims only what test-metrics.R does: f in [0,1] (which fails if a centered matrix is stored as f) and abs(sum G) < 1e-6 N^2. It states that no test checks which matrix a metric consumes. tests/ and R/ are untouched. Includes 01-R6. |
| 01-M1 | fixed | New paragraph: the sum is zero in exact arithmetic; the printed sum_G is floating-point residue, and the sign and magnitude of Ns_on_G carry no information. The table cell "exactly 0" now reads "0 in exact arithmetic". The prose half of 01-R5 is done; the tolerance assertion is left to quant-Rwrite. |
| 01-M2 | fixed | The text now says the expanded form is still O(n^2 m) and that the gain is a BLAS constant factor. Same edit as 01-R7. |
| 01-M3 | fixed | "no assumption at all" now reads "Given the homozygous parents declared above, it requires no further assumption". Heterosis is attributed to the heterozygous loci only "in the absence of epistasis" via d_k [@falconer1996, ch. 14], with a cross-reference to @sec-heterosis. The same qualifier was added at the diagonal paragraph. |
| 01-M4 | fixed | The text now names a range violation (Gomez-Romano 2016) and the zero total (shown here) as distinct symptoms of one cause. |
| 01-M5 | fixed | ctx[["X"]], ctx[["G"]] and ctx[["f"]] are used in every chunk and in the prose. Same edit as 01-R9. |
| 01-B1 | fixed | See 01-D4. |
| 01-B2 | fixed | caballero2000 is no longer cited here. Its journal is corrected to "Genetical Research". Eding & Meuwissen 2001 was added as the suggested source. |
| 01-B3 | fixed | @vanraden2008. |
| 01-B4 | fixed | @malecot1948 and @falconer1996 ch. 5. Bib: malecot1948 is now @book; cockerham1967 is now @article with doi 10.1093/genetics/56.1.89 (Crossref resolves it to Cockerham, "Group inbreeding and coancestry", Genetics 56:89-104). |
| 01-B5 | fixed | @lindgren1997 is cited. Its metadata remains unverified (no DOI). |
| 01-B6 | fixed | The wording is now quoted ("proportional to homozygosity and molecular coancestry"), and the affine relation is stated explicitly. The Toro 2014 claim is routed through Meuwissen's citation. |
| 01-B7 | fixed | No change needed for support. "precisely the failure demonstrated above" was replaced (see 01-M4). The form of the Nejati-Javaremi 1997 formula is still unverified in the primary source. |
| 01-B8 | fixed | Not resolvable from here (paywalled). eding2001 was added as a second, verified-metadata source for marker-based kinship. The caballero2002 attribution is left as is. |

Notes for quant-Rwrite: (1) the chunk at :94 now binds `G <- ctx[["G"]]` and prints `min_G`, which changes its frozen output. (2) Still open: 01-R3/R4 stopifnot for G_0.5 = 4f - 2J, f_ii = 0.5 + F_i/2 and abs(sum G) tolerance; 01-R8 dead chunk; 01-R10 bytecode print. (3) D7: no test checks that diversity metrics consume f rather than G. If one is wanted, it belongs in tests/, not prose.

## quant-Rwrite

| ID | Status | Note |
|---|---|---|
| 01-R3 | fixed | New chunk after the G_0.5 equation: `G05 <- tcrossprod(2*X - 1)/(m/2)`; `stopifnot(all.equal(G05, 4*f - 2J))` and `c'G05c == 4c'fc - 2` for a random normalised `c` (`set.seed(2)` before the draw); prints `range(G05)` = [0.579, 1.327] at book_cfg (inside [-2, 2]). |
| 01-R4 | fixed | stopifnot added: `abs(sum(G)) < 1e-6 N^2` (G chunk, same tolerance as the test); subset sums `1_S'G1_S >= -1e-8` over 1000 random subsets of random size (`set.seed(1)`), backing the D1 rewrite; f in [0,1], literal double-sum oracle on 5x5 and `f == tcrossprod(cbind(X, 1-X))/m` (f chunk); `diag(f) == (1 + F_i)/2` with `F_i = rowMeans(X != 0.5)` (diagonal chunk). All pass. |
| 01-R5 | fixed | Prose by quant-writer; tolerance assertion is the R4 `abs(sum(G))` check. |
| 01-R6 | fixed | Prose by quant-writer; :274 paragraph updated again to cite the new test (below). |
| 01-R8 | fixed | Dead `#| file: ../R/00_data.R` chunk removed. Chapter has no figures: no `docs/01-coancestry_files/`, freeze holds only `execute-results/{html,typ}.json` -> nothing orphaned. |
| 01-R10 | fixed | `molecular_coancestry` print replaced by `cat(deparse(molecular_coancestry), sep = "\n")`: no `<bytecode>`/`<environment>` line. |
| 01-D7 | fixed | tests/testthat/test-metrics.R: new `test_that("diversity metrics read f, not G")` -- `theta_group(1:N) == mean(ctx[["f"]])` (tol 1e-12), `abs(mean(G)/2) < 1e-8`, theta > 0.25; a switch to G collapses theta to ~0 and fails. Prose at the end of the chapter now states this. (The existing theta_group vs theta_from_freq test also catches it indirectly.) |

Verification: devtools::test() FAIL 0 | WARN 0 | SKIP 0 | PASS 469 (was 466). R/ unchanged -> no document()/install(). make_downloads.R regenerated book/downloads/01-coancestry.R. Chapter purled and sourced from book/ with _common.R: all stopifnot pass. Not rendered: frozen output of 01 is now stale (new chunks), needs re-render.
Out of scope, flagged: R/01_metrics.R:18 `theta_group` uses `ctx$f` (CLAUDE.md partial-match trap: with no `f` in ctx it silently reads `fL`). Not changed (R/ out of scope this iteration).

## quant-writer (editor findings)

| ID | Status | Note |
|---|---|---|
| 01-E1 | fixed (appendix) | No other chapter uses `G^L` in prose; 01's `M^L` (0/2) matches `simulate_lines()`. Appendix: new row `M^L`, L x m, 0/2 (`simulate_lines()`); `G^L` row kept for the 0/1 object `ctx$GL` (fast_ctx/simulate_pools) and now states `G^L = M^L/2`, so `G^L` no longer claims to be 01's matrix. Flag: 05-genomic-era.qmd:1372-1374 writes `M_L` (subscript) -- not touched (outside this chapter). |
| 01-E2 | fixed (appendix) | Row `M` -> `M^H`, "hybrid dosage matrix, N x m, 0/1/2; X = M^H/2". |
| 01-E3 | fixed (both) | 02-subdivided uses `f_ii` = within-subpopulation and `s_i` = self-coancestry; 10b uses `f_ii` as the diagonal of f. Chapter: self-coancestry is now `s_i = f_ii = (1+F_i)/2` (:157-159), excess `s_i - 0.5 = F_i/2` (:208), chunk comment `s_i`. Appendix f_ii / s_i rows state that for a single individual `s_i = f_ii`, the diagonal of f. |
| 01-E4 | fixed (chapter) | `s = X1` deleted; @eq-f-matrix written with `X11'` and `11'X'` directly, no new symbol (r is taken by accuracy/correlation in the appendix). |
| 01-E5 | fixed (appendix) | G_0.5 note "**this is f**" -> "4f - 2J: an affine function of f, not f; orders selections as f does only when 1'c = 1". Matches @eq-g05 and its chunk assertion. |
| 01-E6 | fixed (appendix) | Row `Z` added to Matrices: centered dosage `M^H - 1 2p'`, N x m; note: also the design matrix of u = Z beta (same object, centered markers), not the joint-allocation subgroup indicator. |
| 01-E7 | fixed (appendix) | Row `J` = 11', N x N, added. |
| 01-E8 | fixed | `q_k` removed: @eq-g-sum-zero and the subset sentence now write `p_k(1-p_k)` as @eq-vanraden-g does. |
| 01-E9 | fixed | `1` (conforming length m or N) and `J = 11'` (N x N) defined right after @eq-f-matrix; the later definition at @eq-g05 replaced by "with J as in @eq-f-matrix". |
| 01-E10 | fixed | theta defined before N_s: mean of all n^2 pairwise coancestries, diagonal included [@cockerham1967, as in 06-metric-catalogue.qmd:23], `theta = n^-2 1'f1` (forward ref @sec-f-molecular); on G (relationship scale, twice a coancestry) `theta = (2n^2)^-1 1'G1`, which is what the chunk's `theta_on_G = mean(G)/2` computes. |
| 01-E11 | fixed | After @eq-x-freq: "collected for the N hybrids in the N x m hybrid marker matrix X = M^H/2 (rows hybrids, columns markers)". |
| 01-E12 | not changed (author's call) | Editor marks it acceptable/low priority. The printed vectors are demonstrations backed by `stopifnot` in the same chunk; promoting them to numbered tables adds four captions and no information. |
| 01-E13 | fixed | tbl-matrix-roles Range for G: "centered, signed" -> "no fixed bound, signed" (a range type comparable with f's [0, 1]; centering already has its own column). |

Verification: make_downloads.R regenerated; 01-coancestry.qmd and 90-notation.qmd purled to the scratchpad and sourced from book/ with _common.R -- all stopifnot pass, `range(G05)` = [0.579, 1.327] unchanged, 90's kable data.frames build (column lengths consistent). No computed number changed. Not rendered.
