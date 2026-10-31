# 05-genomic-era -- production editor, iteration 1

Scope: book/05-genomic-era.qmd only. Not rendered. Verified with knitr::purl + pkgload::load_all
(scratch /Users/ederdbs/.claude/jobs/1f3dbb75/tmp/05ed/editor): every chunk runs (3.7 s), every
stopifnot holds, every `#|` label/caption/alt line parses as YAML, no backslash in any tbl-cap,
no tbl-subcap used. book/downloads/05-genomic-era.R regenerated with make_downloads.R (no other
download changed). No book/Rplots.pdf created. A script check confirms every @tbl-/@fig-/@eq-era-*
reference resolves and every table and the figure is cited before it appears.

## 1. Edits applied

### Figures (sec. 1)
- fig-era-lens-divergence: `fig-width` 9 -> 6.5 (a 9 in figure is shrunk to ~69% at the Typst
  text width, making the cex 0.75 legend about 6 pt; a test PNG at 6.5 x 3.4 in is readable, with
  no overlap). Label unchanged, so the PNG name is unchanged.
- Figure now cited before it appears ("right panel of @fig-era-lens-divergence", Step 4).
- `#| fig-cap: !expr cap_div` / `fig-alt: !expr alt_div`: verified. Both objects exist when the
  figure chunk runs (built in the preceding chunk) and evaluate to the expected strings
  (12 cycles, 20 replicates, 2000 loci, 50 plants, 5%, stock ratio 2.02). Wording issues -> 05-E6.

### Tables (sec. 2)
Five kable tables were unnumbered (`era-` labels) and 16 result tables (fmt(data.frame) under
`df-print: kable`) had no label or caption. All now `tbl-` with `tbl-cap`, captions written from
the code only, and each cited with @tbl- before it appears:
- kable tables (captions moved from `kable(caption =)` to `#| tbl-cap`): tbl-era-lenses,
  tbl-era-matrix-signs, tbl-era-side-by-side, tbl-era-reference-results (caption rewritten to
  define every column), tbl-era-transposition (had no caption).
- result tables: tbl-era-hom-two-levels, tbl-era-hom-two-levels-null, tbl-era-maf-weight,
  tbl-era-rebase, tbl-era-p0-frozen-check, tbl-era-signature, tbl-era-signature-z,
  tbl-era-traj-block (was era-traj-fun), tbl-era-traj-managed, tbl-era-traj-managed-fit,
  tbl-era-audit, tbl-era-audit-gaps, tbl-era-pools, tbl-era-s1-monitor, tbl-era-rank.
- Prose references replaced: "the matrix-sign table (above)" x3, "the reference table above",
  "the reference-results table below", "the first table", "that table" / "the table above" x4,
  "the `era-pools` table above", "@sec-era-step2's table", "the z columns above".

### Equations (sec. 3)
Labelled and cited: @eq-era-rate (Delta F, N_e), @eq-era-fhom, @eq-era-fdrift, @eq-era-cov
(Meuwissen Eq. 3; in-book "Eq. 3" references replaced by @eq-era-cov, "[their Eq. 3]" kept as
provenance), @eq-era-rank ("the theorem above" -> "the theorem of @eq-era-rank").

### Callouts (sec. 4)
- "Every inbreeding metric is a ratio to a reference population": callout-important ->
  callout-warning (it describes a trap that zeroes the number, not a design decision).
- Blockquote "The diagnostic nobody runs" (Step 6) converted to a titled callout-tip; text
  unchanged.

### Text (sec. 5)
- Acronyms expanded at first use: IBS, IBD, DH, GD, ROH, QTL, GEBV, MAF (callout title), WGS,
  SNP, SNP-BLUP, GBS, NCII, DE; "within-family LD" in prose -> linkage disequilibrium.
- Citation syntax: "Liu & Woolliams 2010 [@liu2010]" -> "@liu2010"; "Meuwissen et al. (2020)"
  hand-typed in two table captions -> @meuwissen2020.
- "see below" -> "see @sec-era-fhom".

## 2. Findings passed on (quant-writer / quant-Rwrite)

- 05-E1 -- Raw console output standing in for results (needs code: return a data frame, which
  `df-print: kable` turns into a table, then a tbl- label). book/05-genomic-era.qmd:60
  era-inbred-check, :420 era-identity, :428 era-identity-residual, :453 era-base-zero,
  :721 era-p0-identity, :911 era-w1-equals-truncation (prints `[1] TRUE`), :1042
  era-traj-drift-fit (prints TWO tables in one chunk: split into two chunks before labelling),
  :1403 era-s1-identity, :1494 era-centering-vs-structure, :1595 era-rank-check (three printed
  vectors). Several are referred to in prose as "the chunk below" (:1482).
- 05-E2 -- Tables too wide for the Typst page: tbl-era-s1-monitor (:1392; 1 row x 11 columns --
  transpose to quantity/value), tbl-era-pools (:1318; 11 numeric columns + row names -- split
  diversity vs. line-usage columns, or transpose), tbl-era-hom-two-levels (:227; 7 columns with
  long names). Splitting/transposing is a code change.
- 05-E3 -- Symbols not matching book/90-notation.qmd: (a) $\mathbf{M}_L$ (:1540) is the 0/1
  `L / 2` line matrix, which the notation calls $\mathbf{G}^L$; notation's $\mathbf{M}^L$ is the
  0/2 dosage, so $\mathbf{X} = \tfrac12\mathbf{B}\mathbf{M}_L$ reads wrong against the appendix;
  (b) $W$ is the MAF panel statistic (:530) and $\mathbf{W}$ the stacked marker matrix (:1545),
  while notation's $W$ is the aggregate genotype; (c) $\mathbf{B}$ (incidence), $\mathbf{Z}_h$,
  rectangular $\mathbf{J}_{N\times m}$ are not in the notation ($\mathbf{J}$ is N x N there).
  Rename or add to the appendix.
- 05-E4 -- Undefined acronyms inside table cell strings (cell text is code; not edited):
  :607 "within-family LD" (tbl-era-side-by-side) -> "linkage disequilibrium"; :1743 "with GS"
  (tbl-era-transposition) -> "genomic selection".
- 05-E5 -- tbl-era-lenses cell "G_0.5 (molecular coancestry)" (:129) contradicts the 05-D8 fix
  and the table's own caption (G_0.5 = 4f - 2J, an affine map of f, not f).
- 05-E6 -- fig-era-lens-divergence caption/plot (built in tbl-era-traj-managed-fit, :1126 ff.):
  (a) n_gam is called "gametes" in the left panel ("100 gametes per cycle") and "allele copies"
  in the centre one; use one term (allele copies, as @eq-hp-drift and `pool_traj()`);
  (b) the caption does not say what the points are: replicate means, filled circles F_drift,
  triangles F_hom, no dispersion shown (the s.d. are in tbl-era-traj-block/-managed) -- say so;
  (c) plot code hard-codes "#b2182b"/"#1f5f8b" instead of `book_pal`, and draws F_hom (not a
  pool) in the pool-A colour; legend shows points only for series drawn with lines and points.
- 05-E7 -- Captions of tbl-era-traj-block, tbl-era-traj-managed, tbl-era-traj-managed-fit,
  tbl-era-maf-weight and tbl-era-hom-two-levels-null hand-type run parameters (50 plants,
  12 cycles, 20 replicates, 2000 loci, 5%, 1000 subsets, 200000 sites, seeds), because the
  objects are created in the same chunk and a `tbl-cap: !expr` would be evaluated before them.
  Same desync risk as 05-M6. Fix if wanted: define n_line/n_cyc/n_rep/pull_m (and B_full) in an
  earlier chunk, then switch those captions to `!expr`.
- 05-E8 -- The callout-note of Step 7 (:1470) contains a derivation, a code chunk and its
  output, and the argument continues after the callout closes. Consider keeping only the
  implementation note (alpha on the diagonal) in the callout and moving the derivation and
  era-centering-vs-structure into the body.

## 3. Orphaned figure files
None. No figure chunk was relabelled; fig-era-lens-divergence keeps its label (only its width
changed, so the next render overwrites docs/05-genomic-era_files/figure-html/
fig-era-lens-divergence-1.png and the _freeze html/typst copies in place). The relabelled chunks
produce tables only.

Render-unverified points: tbl- labels on chunks inside the MAF callout-warning
(tbl-era-maf-weight) and on echo:true chunks follow the pattern 02b already uses.
