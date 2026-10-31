# Verdict 05-genomic-era -- iteration 3 (final re-review)

Inputs consumed: it2-verdict.md, it2-response.md, book/05-genomic-era.qmd (working tree), book/11b
(target of the @sec-cycles cross-reference), Meuwissen et al. 2020 full text (Europe PMC
PMC7438563, fullTextXML). Chapter re-run read-only: knitr::purl + pkgload::load_all + sys.source
from book/ (3.8 s, null graphics device); every stopifnot() holds. No quant-refcheck report supplied.

```
VERDICT: APPROVED

PREVIOUS IDS
- 05-D10 -- CLOSED -- book/05-genomic-era.qmd:296-313: the pair-level claim now rests on F1
  heterozygosity alone; GD_BS is explicitly declared not evidence for it (usage-weight quantity,
  consistent with :282-285) and its rise under truncation is attributed to the usage-concentration
  effect of @sec-era-step6, consistent with Step 6. Inline contrast reproduces: truncation GD_BS
  z = 27.43, F1_het z = 2.515; max_div GD_BS z = 0.474, F1_het z = 7.846. The conclusion
  ("real against the null but smaller than the plan built for diversity") follows from the F1 column
  and the single-candidate-set, teaching-scale limit is stated in the same paragraph.
- 05-M7 -- CLOSED -- :1283-1288 derives Delta F = 1 - e^slope from 1 - F_t = (1 - Delta F)^t (1 - F_0)
  and now claims only that @sec-cycles "fits the same regression", which is true
  (11b:240 lm(log(1 - F_drift) ~ cycle)). Relative error of -slope: -log(0.98)/0.02 - 1 = 1.01%,
  matching the inline value and the Delta F / 2 rule.
- 05-M12 -- CLOSED -- :1582 comment states rank(G_0.5) = rank(f) and that G_0.5 = 4f - 2J is affine
  in f, not equal to it. No residual "G_0.5 equals f".
- 05-M13 -- CLOSED -- confirmed against the full text. Table 2, Panel N: G_VR2(~,M) dF_hom 0.0085,
  dF_drift 0.0059; G_LA(M,M) dF_drift 0.0049 in both Panel M and Panel N. The quoted sentence
  "Delta F_drift for G LA (M,M) was within 2% of the target for both Panels M and N" is verbatim in the
  source (Results, after Table 3). The eight transcribed Panel N rows (dF_hom, dF_drift, gap) match
  Table 2 exactly; gains match Table 3.
- Figure point (quant-editor) -- CLOSED -- both plot/lines calls in fig-era-lens-divergence use
  type = "o" (:1236, :1239); labels, palette, legend unchanged.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
None in the text changed since iteration 2.

WHAT WAS VERIFIED
- Ranking paragraph numbers -- re-run: z(F_hom) truncation 9.408, max_div -4.793; share of null
  >= truncation F1_het 0.3% of 1000; random F1_het z -0.882; max |GD_T + GD_BS - F1_het| 0.00428.
- Reading 1 -- G_LA dF_drift 2% and dF_hom 14% under 0.005; gain_per_dF 833, 841, 897, 1002, 541,
  1282, 1563, 1284 (G_LA largest; G_ROH ahead on dF_hom alone, as stated).
- Ninth-scheme assertion -- 0.0059 < max dF_drift (0.0176, G_0.5) holds and matches the source.
- Managed arm -- fit dF_drift 0.02276 (R^2 0.9924), dF_hom -0.02335 (R^2 0.9604), stock ratio 2.0235;
  unchanged from iteration 2.
- Housekeeping, not a finding: the untracked duplicate
  book/_freeze/05-genomic-era/figure-html/"fig-era-lens-divergence-1 2.png" is still in the
  worktree and must be swept before commit; the response states freeze/docs were not re-rendered
  after the it2 edits, so a render is still owed before commit.
```
