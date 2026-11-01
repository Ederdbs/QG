# Verdict 05-genomic-era -- iteration 2 (re-review)

Inputs consumed: it1-verdict.md, it1-response.md (writer table + "Editor pass"), it1-editor.md,
`git diff HEAD` of book/05-genomic-era.qmd, book/90-notation.qmd, book/references.bib, the rendered
docs/05-genomic-era.html and book/_freeze/05-genomic-era/figure-html/fig-era-lens-divergence-1.png.
Chapter re-run read-only: knitr::purl + pkgload::load_all + sys.source from book/ (4.0 s); every
stopifnot() holds. No quant-refcheck report was supplied for this iteration.

```
VERDICT: REJECTED

PREVIOUS IDS
- 05-D1 (R1) -- CLOSED -- Step 7 (:1600-1625) now proves rank(f) <= rank(B) from B 1_L = 2 1_N and
  labels the equality a measurement; era-rank-check asserts rowSums(B) == 2 and the bound separately.
- 05-D2 (R2) -- CLOSED -- no N_e or rate ratio is read off the managed fit; R^2 = 0.9924 < 0.995 is
  reported and asserted (:1183, :1244-1252); the carried number is now the cycle-12 stock ratio 2.02.
- 05-D3 (R4, B1) -- CLOSED -- reading 2 (:701-705) gives +40% dF_hom and +68% dF_drift, computed;
  side-by-side cell says "the drift one by more".
- 05-D4 (B3) -- CLOSED -- reading 1 (:685-690) treats 0.005 as a ceiling, G_LA 2% and 14% under it;
  consistent with :568-570, :624 and the caption at :654; asserted at :679.
- 05-D5 (B4) -- CLOSED -- :1264-1266 and :1783-1785 both say G_VR2(~,M) has no directional selection
  but still maximises a (random) index; this chapter's arm is the one with no selection at all.
- 05-D6 (R5) -- CLOSED as to dispersion -- the ranking is read against a 1000-subset null
  (tbl-era-hom-two-levels-null). The rewritten paragraph introduces a new defect, see 05-D10.
- 05-D7 (B6) -- CLOSED -- :175-180, F as correlation between uniting gametes [@wright1922],
  H_t = H_0(1 - F_t) as its consequence [@falconer1996, Ch. 3]; key present in references.bib.
- 05-D8 (R12) -- CLOSED -- G_0.5 = 4f - 2J throughout (lens table cell, caption, callout, notation);
  8 Zh Zh'/m identity and rank(G05) == rank(f) asserted; theorem extended to G_0.5 at :1621-1623.
  Residual wording in a code comment recorded as 05-M12.
- 05-D9 (R13) -- CLOSED -- full rank of random_20 stated as generic; 1000 draws (seed 33): 90.4% full
  rank, min rank 18, rank(f) = rank(B) in 100%, theorem asserted on all.
- 05-M1 (R6) -- CLOSED -- "three distinct plans", "worst of the three"; identity asserted at :927.
- 05-M2 (R7) -- CLOSED -- yardstick is the s.e. of the 20-replicate mean per cycle and lens; 2.13 and
  2.06 s.e. against a Bonferroni z of 3.08 for 24 comparisons, asserted.
- 05-M3 (R3, R8, R9, R15) -- CLOSED -- derived numbers are inline expressions; 71 + 71 / 25000 is
  labelled a declared size no chunk runs.
- 05-M4 (R10) -- CLOSED -- every prose identity now under stopifnot() (inbred-check, base-zero, rebase,
  p0-identity, centering-vs-structure).
- 05-M5 (R11) -- CLOSED -- set.seed(31) / set.seed(32) / set.seed(33) per draw.
- 05-M6 (R14) -- CLOSED -- fig-cap and fig-alt are !expr built from n_cyc, n_rep, m, n_line, pull_m,
  stock_m; ylim from data. Rendered caption resolves (no literal !expr in the HTML).
- 05-M7 (R16) -- OPEN -- :1273-1275 still says "Delta F = 1 - e^slope; @sec-cycles does this on
  run_cycles() output", and 11b:241-242 still computes dF_per_cycle = -coef(f) and Ne = 1/(-2 slope).
  The cross-reference in this chapter asserts something the target section does not do. Deferral
  noted; the defect is still on this page.
- 05-M8 (B2) -- CLOSED -- "nine schemes they ran"; ninth scheme recorded in the chunk comment and its
  ordering asserted (the transcribed 0.0059 is not confirmable here, see 05-M13).
- 05-M9 (B7-B10) -- CLOSED -- @vanraden2008, @nei1973, @toro2014, @liu2010, @wood2014 cited; all keys
  in references.bib, all resolve in the render.
- 05-M10 (B11) -- CLOSED -- industry generalisation removed (:579-581).
- 05-M11 (B5) -- CLOSED -- departure from the source's centring attribution declared (:1542-1544).
- 05-R1..R16, 05-B1..B11 -- closed or open exactly as the D/M items they map to in it1 (R16 = M7 OPEN;
  all others CLOSED).
- 05-E1..E6 -- CLOSED (form, quant-editor) -- render confirms 30 labelled tables + 1 figure, every
  caption resolved, no literal markdown or unresolved @ref in docs/05-genomic-era.html.
- 05-E7 -- OPEN for quant-editor, not counted here -- tbl-era-maf-weight and
  tbl-era-hom-two-levels-null still type 200000 / seed 21 and B_full = 1000 / seed 7; they match the
  code today.
- 05-E8 -- OPEN for quant-editor (optional), not counted here.

DISQUALIFYING FAILURES
- 05-D10 [criteria 5 and 4] book/05-genomic-era.qmd:299-303 (@sec-era-fhom, ranking paragraph) vs
  :282-285 and :1421-1440 (@sec-era-step6) -- The rewritten paragraph now states that truncation
  "lost merged-pool gene diversity, while the A x B pairs it kept are more divergent than random --
  GD_BS = 0.0524, z = 27.4" (the it1 text said "happen to be"; this iteration upgraded it to a claim
  against the null). GD_BS is offered as the evidence for divergence of the pairs actually kept.
  The chapter contradicts that reading twice. At :282-285 it says GD_T and GD_BS "are computed from
  line-usage weights -- what a random re-pairing of the selected parents would give -- while
  GD_WI_hyb scores the pairs actually chosen", so GD_BS cannot describe "the pairs it kept". At
  :1421-1431 it says the rise of GD_BS under truncation, read as divergence, "is not" a gain: it is
  the usage-concentration artefact of GD_BS = f~ - f_bar (Caballero & Toro 2002), with f^L fixed.
  The chapter's own numbers support Step 6 and not :299-303. Re-run: truncation GD_BS z = 27.4 with
  F1_het z = 2.52, max_div GD_BS z = 0.47 with F1_het z = 7.85. Pair divergence (F1_het) and GD_BS
  rank the plans in opposite orders. One quantity gets two incompatible interpretations in one
  chapter, and the first one is an inference presented with a z-score as though it were a result.

NON-DISQUALIFYING OBSERVATIONS
- 05-M7 -- carried over, OPEN (see above).
- 05-M12 book/05-genomic-era.qmd:1568 (chunk tbl-era-centering-vs-structure, echoed code) -- the
  comment "G is one rank below f, G_0.5 equals f" can be read as "G_0.5 equals f". That is the
  conflation 05-D8 removed from the prose, and the comment is printed to the reader. The assertion
  under it is on ranks only.
- 05-M13 book/05-genomic-era.qmd:687-688 and :669-671 -- two new attributions to the source that I
  could not confirm and quant-refcheck has not checked: "their text reports the same figure for
  Panel M" (G_LA dF_drift 2% under target) and "G_VR2(~,M) ... has dF_drift = 0.0059 in their
  Panel N". The source is named, so this is "unsupported, not confirmed", not "false".
Three open non-disqualifying items (M7, M12, M13). Under the accumulation rule that is a rejection
on its own, independent of 05-D10.

WHAT WAS VERIFIED
- Rank theorem (D1) -- B 1_L = 2 1_N, X = B G^L / 2, J - X = B(J - G^L)/2 => col(f) in col(B); the
  m + 1 bound holds because col([X, J - X]) is in span(col X, 1). Re-run: ranks 49/46/32/41/20 equal
  rank(B) in all five selections; 1000 draws: 0.904 full rank, min 18, equality share 1.000.
- G_0.5 = 4f - 2J = 8 Zh Zh'/m (D8) -- f = 0.5 J + 2 Zh Zh'/m, so 4f - 2J = 8 Zh Zh'/m; Zh =
  B(G^L - 0.5 J)/2, so the theorem transfers. Asserted in the chunk; holds on re-run.
- Managed arm (D2) -- R^2(F_drift) 0.99243, R^2(F_hom) 0.96037 (both < 0.995); increments 0.0122 ->
  0.0221; stock ratio 2.0235; F_drift(12) 0.2309 vs closed form 0.1136, so the alt text's "rises
  above the closed form" is correct.
- Unmanaged calibration (M2) -- dev/s.e. 2.133 (block), 2.055 (DH) < qnorm(1 - 0.025/24) = 3.078;
  min R^2 0.99935; dF 0.00979/0.01007 vs 0.01; 0.01941/0.01987 vs 0.02.
- Reference transcription arithmetic (D3, D4) -- A: 0.0070/0.005 = +40%, 0.0084/0.005 = +68%;
  G_LA: 2% and 14% under 0.005; only G_LA has both rates <= 0.005.
- Null (D6) -- truncation F_hom z = 9.41, F1_het z = 2.515, share 0.3% of 1000; random F1_het z =
  -0.88. Matches the rendered text.
- w = 1 vs truncation -- identical sets; sd(index)/sd(theta) = 1319, i.e. "three orders of magnitude".
- MAF callout -- kappa ratio (0.001 vs 0.05 floor) 32.4; book kappa 1.27; F_drift = c^2 kappa and
  cov_diag = -2 c kappa are exact for delta p = c(0.5 - p0), asserted.
- min eigenvalue of f -4.3e-13; log10(1e-8 / |ev|) = 4.37, rendered "4.4 orders".
- Notation (90-notation.qmd) -- Z_h, B, J_{r x c}, kappa added; X = B G^L / 2 matches G^L = M^L/2
  (0/1 line matrix) at 90:28. No clash with the field budget B or the genotype W (both disclaimed).
- references.bib -- liu2010 and wood2014 added. Volume/pages/DOI not checked here (quant-refcheck).
- Render -- docs/05-genomic-era.html: 31 captions (30 tables, 1 figure), all resolved, no literal
  "!expr", "**", backticks or @sec/@tbl/@fig/@eq left in the text. Figure caption shows 12 cycles,
  20 replicates, 2000 loci, 50 plants, 5%, 2.02. PNG: three panels, legend and marker encoding as
  the caption states, closed form dashed. Its connecting lines render broken, because type = "b"
  leaves gaps at the points; that is form and belongs to quant-editor.
- Housekeeping, not a finding: an untracked Quarto duplicate
  book/_freeze/05-genomic-era/figure-html/"fig-era-lens-divergence-1 2.png" sits in the worktree
  and must be swept before commit (CLAUDE.md sweep).
```
