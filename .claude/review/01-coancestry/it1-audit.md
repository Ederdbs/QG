# 01-coancestry -- iteration 1 audit (quant-Rwrite, chapter audit mode)

Chapter: `book/01-coancestry.qmd` (339 lines; 11 unnamed chunks plus `tbl-matrix-roles`, no inline `` `r ` `` expression, no `book/data` or `book/figs` read).
Read-only on `book/` and `R/`. Method: `knitr::purl` the chapter, source it from `book/` against the worktree installed into a temp library
(`R CMD INSTALL -l <tmp>`, so `_common.R` takes its `library(hybdiv)` branch on the worktree code), compare the output with `_freeze/01-coancestry/.../html.json`,
`docs/01-coancestry.html` and the PDF text; then rerun every identity the prose states, at full size and over seeds. Scratch scripts are outside the worktree.
Severity: H (a wrong thing is published), M (a claim the evidence does not carry), L (assertion/scope gap), Info (hygiene).

Counts: H 0, M 2, L 6, Info 4.

## Findings

### 01-R1 -- M -- "every diversity metric takes `ctx[["f"]]`" is false
`book/01-coancestry.qmd:320-321`; same sentence in `R/00_data.R:65-66` ("the matrix every diversity metric in this package operates on").

Metrics that never touch `f`: `theta_from_freq()` (`R/01_metrics.R:58-61`, `colMeans(ctx$X[idx, ])`), `he_nei()` (`:72-75`), `alleles_lost()` (`:186-187`),
`freq_metrics()` (`:212-213`, which holds `F_hom`, `F_drift`, `He`), `gst()` (`:289-290`), `ne_parents()`/`line_weights()` (line usage from `ped`). `tests/testthat/test-metrics.R:6` uses `theta_from_freq` as the independent oracle of `f`, which only works because it does not read `f`.
This is the owed item 00-C26: `00:463-465` says "frequency-based metrics such as $F_{drift}$ are not [computed on f]". Chapter 00 is right; chapter 01 contradicts it.
Same paragraph, `:328-329`: "Metrics that read `ctx[["f"]]` directly are not covered by that assertion" is true but incomplete; the frequency-based ones are not affected by an f/G switch at all, so the sentence leaves the impression that every metric is a candidate for that failure.
Fix: "every coancestry-based diversity metric (`theta_group()`, `gene_diversity()`, ...) takes `ctx[["f"]]`; the frequency-based ones (`F_hom`, `F_drift`, `alleles_lost()`) are computed from `colMeans(X[idx, ])`". The `R/00_data.R` roxygen wants the same edit (outside this chapter's scope; read-only here).

### 01-R2 -- M -- "absolute scale", "no arbitrary base population" and "fixed-base member" overclaim, and contradict each other
`:141-144` ("Diversity requires an *absolute* scale"), `:172` ("no arbitrary base population"), `:295-298` ("the one with an absolute scale"). Owed items introduction-C3 and the 00-C26 neighbours: `00:465-475`, `00:514-524` (f is a floor set by the base frequencies plus scaled pedigree coancestry; read as a comparison between sets on the same markers).

Measured on the chapter's own `ctx` (`book_cfg`, N = 625, m = 2000): off-diagonal `f` ranges 0.64475 to 0.76025 and its mean (0.67167) is the IBS floor `mean(p^2 + q^2)` = 0.67191, not 0. Recomputing `molecular_coancestry()` on the same hybrids with a different marker subset moves the mean off-diagonal value to 0.527 (771 markers with MAF > 0.3) or 0.871 (611 markers with MAF < 0.15). So `f` is on a scale fixed by the marker panel, not an absolute one, and carries an implicit base (every pair is compared with independent draws at the panel's frequencies).
Internal inconsistency: `:263-283` shows `f` is `G_0.5`, i.e. the VanRaden matrix centred at the **fixed base p_k = 0.5**; that is a base, chosen by convention (hence "fixed-base member"), so ":172 no arbitrary base" and ":295 absolute scale" sit against ":275 affine function ... centred at 1".
Fix: say what is true: `f` needs no centring on the data being measured, so it does not collapse to `sum = 0`; its level is set by the panel's frequencies (identity in state), and sets are compared on the same markers (@sec-hp-ibd).

### 01-R3 -- L -- the subset-sum expectation is asserted in prose and never checked
`:121-125` states `E[1_S'G1_S] = n (N-n)/(N-1) * mean(diag G)`; the chunk at `:129-136` only asserts `min(S_sum) > -1e-8`, which cannot fail from round-off here (minimum over the chapter's 1000 subsets 0.884; over seeds 1-20 the minimum ranges 0.816 to 3.23).
Verified by me: the closed form follows exactly from `sum(G) = 0` (`n*mean(diag G) + n(n-1)*(sum(G)-tr G)/(N(N-1))` equals the formula to printed precision for n = 2, 10, 100, 300, 624; at n = N it gives -4.2e-11 against 0, i.e. round-off). Monte Carlo, n = 100, 20000 draws, seed 11: 75.713 +/- 0.107 (s.e.) against 75.519 (1.8 s.e.).
Fix: add `stopifnot(abs(mean(S_sum_n100) - n * (N - n) / (N - 1) * mean(diag(G))) < 4 * se)` for a fixed n, or the exact algebraic form; the identity the prose relies on then breaks the render instead of drifting.

### 01-R4 -- L -- `args(vanraden_G)` shows an uninformative result and hides two facts a reader needs
`:76-78`. The chunk prints `function (M) NULL`. `vanraden_G()` returns `list(G, Z, p)` (`R/00_data.R:97-100`), not a matrix, and takes the **0/1/2** matrix `M^H`, whereas `molecular_coancestry(X)` takes **0/0.5/1** (`R/00_data.R:74`). The chapter never states either, and it is the coding trap the book is about (the data enter as `X = M/2`; `ctx[["G"]]` is `vr$G`). Say so in one sentence, or print `names(vanraden_G(2 * X))`.

### 01-R5 -- L -- data-dependent statements without a `stopifnot()`
`:277-278` "on the book data every $f_{ij}$ exceeds 0.5, so the range printed below is positive" -- true (min f 0.64475; also true for sim seeds 1-10, min f 0.633 to 0.648), but the chunk at `:285-293` asserts neither this nor the `[-2, 2]` bound. Add `stopifnot(min(f) > 0.5, all(abs(G05) <= 2))`. `:111-114` ("the printed `sum_G` is floating-point residue") is fine: -4.18e-11 here, -3.9e-11 to -4.8e-11 for sim seeds 2-4; `Ns_on_G` = -9.35e15 matches the frozen output.

### 01-R6 -- L -- restates 00 instead of cross-referencing (owed 00-C25)
`:166-171` restates $s_i = (1+F_i)/2$ and the molecular $F_i$ that `00:527-545` (@sec-hp-ibd, @sec-hp-inbreeding) already define, including `F_hom` as population-level. The additions are the only new content (numerically the fraction homozygous; checked in the chunk at `:227-234`, max abs diff 1.1e-16). Replace the restatement by a cross-reference plus the one new line, or keep it and cross-reference 00 explicitly.

### 01-R7 -- L -- opening does not say why it follows 00 (owed introduction-C2)
`:8-15` opens as the first chapter ("Two matrices are built ...") and the only link to 00 is the mid-text `@sec-hp-cycle` at `:25`. `_quarto.yml:25-27` puts it first in Foundations right after the Introduction part. One sentence: 00 stated which quantities the book assumes; this chapter builds the matrix those quantities are computed on.

### 01-R8 -- L -- the heterozygous-fraction paragraph is unconditional, loose in wording, and unasserted
`:236-243`. (a) First sentence "This fraction is not set by how far apart the heterotic pools are" is unconditional; the support (`05b:467-` `sec-heterosis-flat`, `03` fig-divergence-het with `stopifnot` at `03:131`) is for neutral Balding-Nichols divergence only; the conditional appears in the second sentence. (b) "Its expectation over the A x B factorial is one minus the mean coancestry between a pool-A and a pool-B line": on a realised factorial it is exactly that, not an expectation; line-level `f^L` is not introduced in this chapter. (c) Not asserted here: on the chapter's data `2 * (1 - mean(diag(f)))` = 0.3616896 = `1 - mean(ctx$fL[1:25, 26:50])` (identical to printed precision), and 0.3617 is the number 00 uses (`00:435-447`). Add `stopifnot(isTRUE(all.equal(2 * (1 - fd), 1 - mean(ctx[["fL"]][ctx$pool == "A", ctx$pool == "B"]))))` or refer to 00's check.

### 01-R9 -- Info -- tolerances are the `all.equal` default for exact identities
`:213-214`, `:233`, `:289-291` use `all.equal()` at 1.5e-8 for identities that are exact in floating point. Measured: full 625 x 625 `f` against the literal double sum, 7.8e-16; `f` against `tcrossprod(cbind(X, 1 - X))/m`, 0; `G05` against `4f - 2`, 2.2e-16; `diag(f)` against `(1 + F_i)/2`, 1.1e-16; `max|G - ZZ'/den|`, 0. The literal check covers a 5 x 5 corner only (the full 625^2 loop is quick). Declare `tolerance = 1e-12` in the chunk. `:108` bound `1e-6 * N^2` = 0.39 against measured |sum G| = 4.2e-11 (ten orders of margin).

### 01-R10 -- Info -- Falconer & Mackay chapter numbers differ across chapters (UNVERIFIED)
`:36` "ch. 14" (heterosis), `:168` "ch. 5" (IBD form of $s_i$), against `05:177-178` "Ch. 3" for $F$ and $H_t = H_0(1-F_t)$ (00 also uses "ch. 5"). I have no copy of the book in the worktree; I could not check which is right. The mathematical content cited at `:34-36` (F1 minus mid-parent = sum of $d_k$ over loci where the inbred parents differ) is correct (I derived it: the F1 is heterozygous, the mid-parent genotypic value is 0 at a locus where parents are opposite homozygotes).

### 01-R11 -- Info -- PDF cross-references print a stray full stop (book-wide 00-E1)
PDF text (`docs/Genetic-Diversity-in-Hybrid-Breeding.pdf`): "Chapter 5. develops that model" (`:37`), "F_hom of Chapter 10.)" (`:171`), "Chapter 6. measures" (`:241`), "Chapter 3. takes f" (`:331`). Already tracked as 00-E1, noted for continuity.

### 01-R12 -- Info -- download footer says cached results are fetched on first use
`:339`. This chapter reads no cached file. Boilerplate from `book/scripts/make_downloads.R`, no action in the chapter; the downloaded `book/downloads/01-coancestry.R` is current (its code, comments stripped, equals the purl of the chapter plus the `_common.R` prelude; `fmt_sci` is already in it).

## Verified (ran, matched)
- All 12 chunks run on the worktree code; every `stopifnot` passes; outputs equal the frozen outputs (`min 0.6448, max 0.8318, diag mean 0.8192, offdiag 0.6717`; F 0.6383; heterozygous fraction 0.3617; `range(G05)` 0.579-1.327; `sum_G -4.178879e-11`, `Ns_on_G -9.348769e+15`).
- Identities in the prose, at N = 625, m = 2000: `1'G1 = 0` (4.2e-11); `G` = `ZZ'/(2 sum p(1-p))` (0 difference); eq-f-matrix vs literal sum on all pairs; `G_0.5 = 4f - 2J` and `c'G_0.5 c = 4 c'fc - 2`; `diag(f) = (1+F_i)/2`; E[subset sum] formula (exact algebra, MC within 1.8 s.e.).
- Seeds: `simulate_data()` seeds itself from `cfg$seed` (`R/00_data.R:39`, `:126`); `set.seed(1)` and `set.seed(2)` precede the two later draws; no AlphaSimR/MaCS in the chapter. Subset-sum nonnegativity holds over seeds 1-20.
- Numbers in prose: there are no inline `r` expressions, hence no `fmt_sci()` case; the scientific-notation values appear only in chunk output blocks, not in prose.
- Functions and arguments exist and are exported (`simulate_data`, `vanraden_G`, `molecular_coancestry`; `fmt` from `_common.R`); cross-references resolve in HTML (`@sec-hp-cycle`, `@sec-heterosis-flat`, `@sec-f-molecular`, `@sec-why-not-g`, `@sec-subdivided`, `@sec-simulating-crosses`, `@sec-genomic-era`, `@sec-heterosis`); the eleven citation keys exist in `book/references.bib`.
- Reads only the installed package; no `book/data`/`book/figs` file, so nothing to track or regenerate. No figures in the freeze (`_freeze/01-coancestry` holds `html.json`, `typ.json` only), so editing prose or adding assertions orphans no `unnamed-chunk-*` figure; a labelled or added chunk stays safe on this account.

## UNVERIFIED
- `:263-265` the Meuwissen et al. (2020) quotation "proportional to homozygosity and molecular coancestry" and that it cites Toro et al. (2014); `:251-260` the Nejati-Javaremi et al. (1997) formula and the Gomez-Romano et al. (2016) contrast with crossproduct matrices (range violation below 0 or above 1). The papers are not in the worktree (`reference/` is gitignored); the chapter's algebra for `G_0.5` itself is verified above, the attribution is not.
- Falconer & Mackay chapter numbers (01-R10).
