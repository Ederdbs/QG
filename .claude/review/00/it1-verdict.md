# 00-hybrid-programme -- iteration 1 verdict (quant-judge)

Chapter: book/00-hybrid-programme.qmd (worktree SB_quanti_gen-review, HEAD 7952700).
Inputs consumed: it1-audit.md (00-R1..R7), it1-refs.md (00-B1..B7).

```
VERDICT: REJECTED

DISQUALIFYING FAILURES
- 00-R1 [criterion 1] book/00-hybrid-programme.qmd:347-350, Interpretation after
  @eq-hp-ibs-ibd -- adopted from the audit. "Molecular coancestry is pedigree coancestry
  plus a floor" is not what @eq-hp-ibs-ibd says, nor what the chunk just verified:
  E[f] = A/2 + (1 - A/2) s0 = s0 + (1 - s0) A/2 (Eding & Meuwissen 2001's f + (1 - f)s).
  The pedigree term is shrunk by (1 - s0). On the chapter's own numbers, full sib minus
  unrelated = 0.7264 - 0.6352 = 0.0912 = 0.25 x 0.3648, not 0.25. The sentence that
  interprets the identity contradicts the identity. MUST FIX.
- 00-B7 [criterion 7] book/00-hybrid-programme.qmd:209-212 -- adopted from refcheck, and
  aggravated. "the commercial evidence collected in @sec-plant-literature" cites an
  empirical result without naming its source. The target passage
  (book/11-plant-literature.qmd:132-138, "The empirical trend that justifies the
  constraint") carries no citation key either, so the chain ends in an unsourced claim.
  Chapter 00 asserts a commercial, longitudinal result that a reader cannot trace to any
  primary source. MUST FIX.
- 00-D1 [criteria 1, 2] book/00-hybrid-programme.qmd:200-202, "Where diversity is lost" --
  "Every step ... samples or selects a subset of a pool, and a subset carries fewer
  alleles, at more uneven frequencies, than the pool it came from" is stated as a
  general fact. It is not one. (i) Allele count in a subset is non-increasing, not
  strictly smaller. (ii) Gene diversity of a subset falls only in expectation under
  random sampling (diagonal-included theta: E[theta_sub] exceeds theta_pool by
  (1/n - 1/N)(mean self-coancestry - mean off-diagonal)). Selection that is not directed
  against diversity carries no such guarantee, and selection for diversity reverses it.
  The undeclared condition is the very one the book builds on: alpha is measured against
  a random-subset reference rather than the full pool. Counter-example on the chapter's
  own data (book_cfg, seed 1): pool GD_T = 0.3281, a greedy 20-hybrid subset has
  GD = 0.3296 > pool, while 200 random 20-subsets average 0.3209, none above the pool.
  The S2/S4 loss result that follows (:205-208) is correctly circumscribed. This
  sentence is not.

NON-DISQUALIFYING OBSERVATIONS
- 00-M1 :127-128 -- "GCA is a property of a line against a tester pool, never of the
  line alone" is unconditional. Lines 99-101 state that without dominance GCA is the
  same against every tester set. The interpretation drops the dominance condition the
  experiment rests on.
- 00-M2 :123-126 vs :102 -- the Result reports "the GCA computed against the two
  halves" (r = 0.859, 3 of top 5 shared). The chunk computes the dominance part only,
  i.e. a model with a_k = 0. Any additive variance raises the agreement. The caveat at
  :128-130 lists draw, seed and tester size but not a_k = 0, which is the condition that
  maximises the disagreement shown.
- 00-M3 :450 -- "N_e is a rate": N_e is a size defined by a rate (1/(2 dF)), as :411-415
  itself states. The contrast with N_s is right; the sentence conflates the quantity with
  what it encodes.
- 00-R2 :314-317 -- the unrelated pairs are the base-drawn parents themselves, not
  individuals "bred from parents". This is a text/code mismatch (criterion 5, low). The
  expectation is unaffected because the two have the same distribution. SHOULD FIX.
- 00-R3 :104-105, :129-130 -- "halves" of 12 and 13 lines; the inline value reports only
  12. SHOULD FIX.
- 00-R4 :123-124 -- "to machine precision" is true (3.7e-13) but is not what the
  all.equal() check asserts (tolerance 1.5e-8). SHOULD FIX (claim and check disagree).
- 00-R5 :274 -- Ho_lines = 0 holds by construction (GL is 0/1) and is presented as a
  Result. Assumption A2 dressed as a measurement. SHOULD FIX.
- 00-R6 :30-31, :104, :316-317, :420 -- hand-typed parameters. They currently match the
  code. Maintenance risk only, NOT REQUIRED for approval.
- 00-R7 :119 -- `1:5` vs `seq_len(5)`: house style, NOT REQUIRED.
- 00-B1 :79 -- "the two-way model of @sprague1942". Refcheck marks it WRONG, but by its
  own account the claim that the model is absent from the paper is UNVERIFIED. Sprague &
  Tatum supply the GCA/SCA concepts. The linear model with s_ij and a plot error term is
  the later formalism (Comstock & Robinson 1948; Griffing 1956). I record it as an
  unsupported attribution, not a false one. MUST BE RESOLVED before approval (confirm or
  re-attribute). It is not counted as disqualifying at this iteration.
- 00-B2, 00-B3 -- missing DOIs (sprague1942, wright1922). Bibliographic metadata,
  out of my scope. NOT REQUIRED for approval.
- 00-B4 -- no defect; no action.
- 00-B5 :365 -- Wright as a gametic correlation, Malecot as a probability. Both are
  cited together, so the attribution stands. NOT REQUIRED.
- 00-B6 :359-360 -- Cockerham (1967) group coancestry including self-coancestries is
  unverified by refcheck. It matches the standard reading, and the chapter's identity
  (@eq-hp-gd) does not depend on the attribution. NOT REQUIRED; resolve if refcheck can
  reach the text.

Count of non-disqualifying failures requiring action: M1, M2, M3, R2, R3, R4, R5 (7). At
three or more, this accumulation would reject on its own.

WHAT WAS VERIFIED
- Selfing 1 - F_t = (1/2)^t, F_6 = 0.9844 -- Falconer & Mackay ch. 5; correct.
- GCA = sum_k [a_k + d_k(1 - 2p_Bk)] du_ik -- derived: E[value | u=1] - E[value | u=0]
  against pool-B gametes = a + d(q_B - p_B), the classical average effect; correct, and
  tester-invariant iff d = 0.
- H1 = Ud + (Vd)' - 2U diag(d) V' -- the dominance value u + v - 2uv per locus; correct.
- @eq-hp-gd 1 - theta_S = mean 2 p q -- with f_ij = mean_k[x_i x_j + (1-x_i)(1-x_j)] and
  diagonal included, mean f = p^2 + q^2 per locus; exact.
- Ho - He = GD_BS for the complete factorial -- per locus Ho - 2 pbar qbar =
  (pA - pB)^2 / 2 = Nei's D_ST = Caballero & Toro's between-subpopulation term for two
  equal pools; audit numbers 0.3617 - 0.3281 = 0.0336 match.
- F_ST = GD_BS / GD_T = D_ST / H_T (Nei's G_ST); 0.0336/0.3281 = 0.1024; consistent.
- @eq-hp-ibs-ibd -- correct form; 0.25 + 0.75 x 0.6352 = 0.7264 matches. Its verbal
  reading is wrong (00-R1).
- s_i = (1 + F_i)/2 for molecular f and F = fraction homozygous -- 1*F + 0.5*(1-F); exact.
- F_(ab) = fL_ab for homozygous parents -- exact; audit max diff 0.
- Drift: E[2pq]_t = H0 (1 - 1/n_gam)^t for binomial sampling; dF = 1/n_gam,
  Ne = n_gam/2; crossing block (n=10): 0.95^10 = 0.5987; DH pool: 0.9^10 = 0.3487;
  DH one-gamete-per-line sampling gives Ne = n/2. Correct.
- Hybrid-set coancestry as a quadratic form in line usage -- f(ab,cd) =
  (fL_ac + fL_ad + fL_bc + fL_bd)/4, self-term (1 + fL_ab)/2; consistent.
- Subset-vs-pool GD (00-D1) -- Rscript on simulate_data(book_cfg): pool 0.3281, greedy-20
  0.3296, random-20 mean 0.3209 (200 draws, 0 above pool).
- @sec-plant-literature target of 00-B7 -- read book/11-plant-literature.qmd:132-138;
  no citation key in the passage.
```
