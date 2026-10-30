# 02-subdivided -- response, iteration 1

## quant-writer

Equation-number decision (02-D5/02-B1): Caballero & Toro (2002) full text unreachable; the open review
Toro & Caballero (2005, PMC1569508, read in full) restates the partition, F_ST and N_e results WITHOUT
equation numbers. So no 2002 equation or table number is used anywhere in the book: dropped from 02
(Eq. 7, 13, 14, 15; Tables 2b, 2, 3), 05-genomic-era (x2), 04c-alphasimr-pipeline (Eq. 6, Eq. 7, and the
unverifiable "not stated in the paper"), 91-package (Eq. 8, Eq. 7). Added `toro2005` and `cockerham1969`
to references.bib (metadata from the Crossref API).

| ID | Status | Evidence / change |
|---|---|---|
| 02-D1 | fixed | `2(1 - s_i) = 1 - F_i = H_o`; "half the observed heterozygosity" stated; table row `H_o / 2`; keystone row adds `1 - s_til = H_o_til/2`, and GD_WI-hyb is described as half the hybrids' mean heterozygosity. Toy check (scratchpad v02.R): `2*(1 - s_i) == H_o` all.equal TRUE |
| 02-D2 | fixed | p_{k,l,i} is now the within-individual frequency (0, 0.5, 1 = dosage/2, as in ct_partition); the 0/1/2 failure is stated |
| 02-D3 | fixed | the tip now uses `d_bar_ij = (s_i+s_j)/2 - f_ij` (between-individual mean distance) and gives `D_ij = d_bar_ij - (d_bar_ii + d_bar_jj)/2`. Both checked against a literal double sum (all.equal TRUE; D_nei[a,b] = 0.098 vs d_bar[a,b] = 0.295). "Eq. 13" dropped |
| 02-D4 | fixed | G defined as `(s_til - f_til)/(1 - f_til)`, with a note that it is not the weighted mean of G_i (toy: 0.595 vs 0.603). Ratio identities checked, all.equal TRUE |
| 02-D5 | fixed | see the decision above |
| 02-D6 | fixed | the uncited SS/NSS "typically low" and ">0.6" claims are removed. New chunk `fl-ranges` (book_cfg) computes fL between pools 0.608-0.664 and within pool 0.668-0.719, quoted with inline `r`, and the single-draw scope is stated |
| 02-D7 | fixed | keystone row: with inbred parents, alpha budgets `GD_T = 1 - theta = GD_BI + GD_BS`. Verified at book_cfg, 30 random hybrids (set.seed(7)): 1 - theta = GD_T = 0.32145, GD_BI + GD_BS equal (all.equal TRUE) |
| 02-D8 | fixed | section retitled "Equal contributions and effective size". N_s is called a status number [@lindgren1997] and distinguished from N_e. The formula is replaced by `2Nn/((V_W+V_B+1)(1-F_ST))` [@toro2005, §4a], with N, n, V_W and V_B defined and assumptions stated (random mating within subpopulations, constant structure, asymptotic). Doubling is V_W = 0 vs V_W = 1; S_W^2 becomes V_W. "Eq. 15" removed |
| 02-D9 | fixed | the recurrent-selection bullet now says the QP maximises neutral-marker GD_T, equal to additive (genic) variance only under additive action, equal effects and markers that represent QTL frequencies (-> @sec-response) |
| 02-D10 | fixed | the text now says that only the 5 rows computed from f are a check, asserted by `stopifnot`, and that GD_WI and GD_BI agree by construction from the published s_til. The 65.5% Weitzman figure is removed and replaced by the computed mean distance (`dist` column, asserted max at Sub2). The OC solution is asserted at 3 dp. The errata section with its unsupported "Tables 2 and 3 reproduce" is removed |
| 02-D11 | fixed | the quoted Discussion phrases and the F_2 typo are removed (neither is confirmable from an accessible source). New section "A correction published by the authors": Toro & Caballero 2005, Table 4, footnote a (DESH row, "corrects a mistake in Caballero & Toro (2002)"), plus the 2005 doubling restatement. The section states that the 2002 values were not re-checked against its full text |
| 02-D12 | fixed | added @cockerham1967 (group coancestry), @nei1973 (gene diversity), [@toro2005, §3a] (Nei minimum distance), @wright1951 + @cockerham1969 (F statistics, F_ST = D/(1-f)), [@toro2005, §3d] (Weitzman), @meuwissen1997 as a constrained programme with the Lagrangian form, @lindgren1997 (N_s), [@toro2005, §2] (effective number of alleles) |
| 02-M1 | fixed | "hours vs seconds" removed; the title no longer says O(N^2); cost given as O(N_T m + n^2 m), and the text states that no timing was run |
| 02-M2 | fixed | replaced by an explicit expected-drift argument for two closed pools of equal weight: GD_WS falls by Delta, GD_BS rises by Delta/2, GD_T falls by Delta/2. Algebra from f_bar = (f_AA+f_BB+2f_AB)/4 with E[f_AB] constant; selection explicitly excluded; -> @sec-heterosis-flat |
| 02-M3 | fixed | 0.875/0.125, 19%, 1.8%/6.5% and 0.6744/0.6874 are now inline `r`. Chunks touched got labels (`ct-example-*`). This overlaps 02-R7 for these numbers |
| 02-M4 | fixed | "Nei's gene diversity, plug-in form 1 - sum p^2, without the 2N/(2N-1) correction" [@nei1973] |
| 02-B1 | fixed | = 02-D5 |
| 02-B2 | fixed | = 02-D3 |
| 02-B3 | fixed | = 02-D8 (F_ST and V_W/V_B as in the 2005 restatement; Eq. 14/15 dropped) |
| 02-B4 | fixed | the F_2 = 0.8383 erratum is removed (Table 2b unreachable, s_2 not reproducible here); the 2005 Table 4 footnote-a correction is added |
| 02-B5 | fixed | = 02-D11 |
| 02-B6 | fixed (scope stated) | 65.5% removed. The remaining published values (f matrix, s_til, published column, c) are labelled as transcribed from @caballero2002 and asserted against the computation where computable. The body states that they were not re-checked against the 2002 full text |
| 02-B7 | fixed | = 02-D12 (Meuwissen as a constrained programme; the penalised form is its Lagrangian; bold F replaced by bold f for book notation) |
| 02-B8 | fixed | @cockerham1967 |
| 02-B9 | fixed | @nei1973; minimum distance cited to [@toro2005, §3a] (the source that names it), with no Nei 1987 key |
| 02-B10 | fixed | @wright1951, @cockerham1969 (added to bib, Crossref: Evolution 23(1):72-84) |
| 02-B11 | fixed | = 02-D6 (claim replaced by computed ranges; no external number) |
| 02-B12 | fixed | N_s cited to @lindgren1997, the same key 01-coancestry already uses for N_s = 1/(2 theta) |
| 02-B13 | fixed | caveat attributions moved off "the paper": largest-populations bias [@toro2005, §3e]; effective number of alleles [@toro2005, §2]; minimum-contribution QP [@toro2005, §3e, Table 5] |

Notes for quant-Rwrite:
- R/07_caballero_toro.R carries 2002 equation numbers that cannot be verified (header :15 "their Eq. 7"; inline "Eq. 10, 11, 12, 3, 1, 4, 5, 2, 6, 7"; roxygen of optimal_contributions "Eq. 9"). Drop them for consistency with the book.
- The roxygen of optimal_contributions() says "Minimising group coancestry is the same thing as maximising effective size, since Ns = 1/(2 theta)". That is the 02-D8 conflation (status number vs N_e).
- The comment at R/01_metrics.R:146-147 ("the heterozygosity actually carried inside the F1s") should say half the heterozygosity (02-D1).
- 02-R5: the new prose states identities (tip d_bar / D_nei, ratio identities with metapopulation G, 2(1-s) = H_o, F_IT product, partition) that the chapter does not yet assert in code. They were verified in scratchpad v02.R on a toy ct_partition set (set.seed(1), m = 400). They still need the genotype-level stopifnot chunk.
- CLAUDE.md ("Caballero & Toro 2002 Eq. 8" under gd_partition) should read "(Caballero & Toro 2002)" with no equation number. Not edited.
- Chunk `fl-ranges` calls simulate_data(book_cfg); simulate_lines() runs set.seed(cfg$seed) itself (R/00_data.R:39), so it is reproducible without a chunk-level seed.

## quant-Rwrite

| ID | Status | Evidence / change |
|---|---|---|
| 02-R1 | fixed | (writer: prose) + asserted: chunk `ct-identities`, `2*(1 - s_i) == H_o` with H_o counted from genotypes (`rowMeans(geno == 1)`), `1 - F_i == H_o`, inbred subpop `identical(s_i, 1)`; `keystone-check` asserts `GD_WI_hyb == mean F1 heterozygosity / 2` at book_cfg. R/01_metrics.R comment now "1 - s, half the heterozygosity" |
| 02-R2 | fixed | (writer: prose) + asserted in `ct-identities`: `d_bar = (s_i+s_j)/2 - f_ij` against a literal double loop over all pairs of individuals, and `D_nei == d_bar - (d_bar_ii + d_bar_jj)/2` |
| 02-R3 | fixed | writer (`fl-ranges`, inline r) |
| 02-R4 | fixed | writer (prose); `ct-identities` asserts `mean(geno^2 + (1-geno)^2) > 1`, i.e. the 0/1/2 scale leaves [0.5, 1]; R/07 comment on `P <- G / 2` now says "within-individual frequency: 0, 0.5, 1" |
| 02-R5 | fixed | new labelled chunk `ct-identities` (toy: 3 subpops, 10/6/8 individuals, one inbred, m = 400, `set.seed(1)` right before the draw; 0.24 s for the whole chapter) asserts: H_o identities, G_i = (1+alpha_i)/2, f_bar <= f_til <= s_til, f_bar decomposition (sum of contrib_fbar), F_ST = (f_til-f_bar)/(1-f_bar) = D_bar/(1-f_bar), (1-F_IT) = (1-F_IS)(1-F_ST), GD_T = WI+BI+BS, GD_WS = WI+BI, the four ratio identities with metapopulation G, and that the first one FAILS with the weighted mean of G_i (G_meta 0.6441 vs G_wmean 0.6490). New chunk `keystone-check` (book_cfg, 30 random hybrids, `set.seed(7)`): GD_WI = 0 (|.| < 1e-12), 1 - theta == GD_T == GD_BI + GD_BS |
| 02-R6 | fixed | `ct-example-global`: assertion on unrounded values at a declared tolerance, `max|computed - published| < 5e-5` over the 5 f-only rows (observed 3.9e-5; was `==` on rounded reals); new assertion that the published GD_WI+GD_BI+GD_BS closes on published GD_T within 1.5e-4 (paper's internal consistency, the one check s_til admits); prose says so. OC check `max|c - published| < 5e-4` replaces `round(.,3) ==` |
| 02-R7 | fixed | writer (inline r); `19%` inline now reads `computed[["F_ST"]]` |
| 02-R8 | fixed | writer |
| 02-R9 | fixed | equation numbers stripped from R/07_caballero_toro.R (header roxygen, 10 section comments, optimal_contributions "Eq. 9") and R/01_metrics.R gd_partition roxygen ("Equation 8" -> "The partition of Caballero & Toro (2002)"). CLAUDE.md still says "Eq. 8" -- not edited (out of my scope) |
| 02-R10 | fixed | writer (prose) + asserted in `ct-identities` |
| 02-R11 | open (deliberate) | tracked duplicates; needs an explicit `git rm`, not done |
| writer note: Ns/Ne | fixed | optimal_contributions() roxygen: minimising group coancestry maximises the status number Ns (Lindgren & Mullin 1997), not Ne |

Runs: `devtools::document()` (3 Rd), `devtools::test()` all pass (0 failures), `devtools::install()` ok, `make_downloads.R` ok; chapter purled and sourced from book/ with _common.R: all stopifnot pass, 0.24 s.

04c risk check (read-only): re-execution is triggered by the prose edit only (no chunk added/relabelled, so no orphaned figures). Steps 1-7 use `quickHaplo()` with `set.seed()` per step and the Step 1 chunk asserts runMacs consumes a fixed amount of R's stream, so their numbers reproduce except wall-clock times and the runMacs rows (all inline r). Step 8 (`runMacs2`) WILL move: every number is inline r and the t-verdicts are conditional, so no stated number goes stale, but four hand-written qualifiers rest on current draws: "pooling does what it should there / is close to" (gd_elite cor_AB = 0.12), the covariance "negligible ... within 1.5 SE" reading, "selection component of the loss is of the same order as its paired s.d.", and "overall r^2 barely above" the floor. Re-read those after the render.

## quant-writer (editor findings)

| ID | Status | Evidence / change |
|---|---|---|
| 02-E1 | fixed | `ct-example-global` keeps its code and both stopifnot; the bare `ct_glob` print is replaced by a new `echo: false` chunk `tbl-ct-example-global` (kable, math row names, caption defining every symbol, says computed GD_WI/GD_BI agree by construction); cited `@tbl-ct-example-global` before it. Values unchanged (7/7 rows equal published at 4 dp) |
| 02-E2 | fixed | bare `fmt(lg)` replaced by chunk `tbl-ct-loss` (kable; headers "$GD_T$ without it (census)", "Change, census (%)", "Change, equal (%)", "Mean distance to the pool"; caption gives weights, sign convention and $\sum_j D_{ij}N_j/N_T$); prose "(column `dist`)" -> "(last column of @tbl-ct-loss)". `ct-example-loss` code and stopifnot unchanged |
| 02-E3 | fixed | `fmt(fl_rng)` print removed (all six values already inline r). `oc$c_i` and the `c(GD_before, ...)` prints removed; computed c now inline (`formatC(oc[["c_i"]], "f", 3)` = 0.522, 0.000, 0.270, 0.208) and the gain inline (1.9 %); stopifnot unchanged |
| 02-E4 | fixed | cells now LaTeX: mating meter `$\approx 0.5$`, `$< 0.5$`, `$\to 1$`; partition `$GD_T = 1 - \bar f$` ... `$GD_{BS} = \tilde f - \bar f$`, `$H_e$`, `$H_o/2$`, `$GD_{WI} + GD_{BI}$` |
| 02-E5 | fixed | "with the clean identities" -> "The four components satisfy the identities" (stands alone after the table) |
| 02-E6 | fixed (appendix + local note) | grep book/*.qmd: no later chapter uses this chapter's $\alpha_i$ or $G_i$ (04c's $G_i$ is a genotypic value, unrelated, not touched); kept C&T's symbols, which are also `ct_partition()` column names. Added rows $\alpha_i$, $G_i$/$G$ to 90-notation (new "Subdivided population" table) marked "not the constraint $\alpha$" / "not a relationship matrix $\mathbf{G}$", and one clause at @eq-alpha-g saying the same |
| 02-E7 | fixed (appendix) | not renamed: 04g:611,700 uses this chapter's $N_i/N_T$, and @eq-ne-meta is the published $2Nn$ form. Appendix rows added for $n$/$N_i$/$N_T$ (flagged as not hybrids selected/candidates), $F_i$, $H_{o,i}$, $D_{ij}$/$\bar D$, $\bar d_{ij}$, $N_e$, $V_W$/$V_B$; Notation section of 02 gets one sentence on the $n$/$N$ clash |
| 02-E8 | fixed (link) | $p_{k,l,i}$ kept (multiallelic, k indexes alleles in the worked example); sentence added: for a biallelic marker and the reference allele it is the $x_{lk}$ of @sec-notation; same in the appendix row |
| 02-E9 | fixed (chapter) | bold $\mathbf{D}_{ij}$ -> $D_{ij}$ throughout 02 (appendix was right: bold = matrix). 04g:618 cites $\bar D$, which was never bold -- no change there. Appendix row: "$D_{ij}$, an element of $\mathbf{D}$; $\bar D = \tilde f - \bar f$" (identity checked on the worked-example f: `sum(w w' D) == f_til - f_bar`, all.equal TRUE) |
| 02-E10 | fixed (chapter) | $\mathbf{g}$ -> $\mathbf{u}$ in the OCS bullet (appendix right; 08b's $\mathbf{g} = \mathbf{Z}\boldsymbol\beta$ is a separate pre-existing clash, not in scope) |
| 02-E11 | fixed | pipe-table dash widths set to 4:16:36 so the long third column gets most of the Typst width; no wording change. Not verified by render (render not permitted in this pass) |
| 02-E12 | fixed (chapter only) | % separated by a space in 02 per checklist 5 (SI): 19 %, 1.8 %/6.5 %, 0.67 % (x2), new 1.9 %. Book-wide normalisation not done |

Runs: `make_downloads.R` ok; 02 and 90 purled to scratchpad and sourced from book/ with _common.R: all stopifnot pass. Not rendered. Tables are new `tbl-` chunks, no figure files orphaned.
