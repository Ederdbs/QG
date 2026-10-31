# 00-hybrid-programme -- iteration 2 verdict (quant-judge)

Chapter: book/00-hybrid-programme.qmd (worktree SB_quanti_gen-review, diff vs main).
Inputs consumed: it1-verdict.md, it1-response.md (writer, Rwrite, editor-handoff rows),
it1-editor.md. Scope of new review: `git diff main` of 00-hybrid-programme.qmd,
90-notation.qmd, 11-plant-literature.qmd, references.bib.

```
VERDICT: APPROVED

PREVIOUS IDS
- 00-R1 -- CLOSED -- :422-430 now reads E[f] = floor + (1 - floor) A/2; the inline
  excess 0.0912 = 0.25 x (1 - 0.6352) is printed from the chunk, "not by 1/4".
- 00-B7 -- CLOSED -- :276-282 cites @kadoumi2025 and @vanheerwaarden2012 by key; 11:137
  now carries [@kadoumi2025]. Both abstracts read (Europe PMC 40883612, 22802642): SS/NSS
  differentiation up and intragroup diversity down over forty years of a private European
  dent programme; steadily increasing differentiation of North American breeding pools,
  with "selection has had limited impact on genome-wide patterns". The chapter's wording
  matches both and does not over-attribute mechanism.
- 00-D1 -- CLOSED -- :218-231 states allele number non-increasing, the expected excess
  of theta for a random subset (1/n_sel - 1/N)(fbar_d - fbar_o) (same as 06:330), and no
  guarantee under selection; new chunk hp-subset-gd measures it and asserts both.
- 00-M1 -- CLOSED -- interpretation conditioned on dominance; d_k = 0 case stated.
- 00-M2 -- CLOSED -- Result says "dominance parts"; caveat names a_k = 0 and the
  direction of the bias (checked below).
- 00-M3 -- CLOSED -- :533 "a size defined by a rate".
- 00-R2 -- CLOSED -- prose matches rbind(mo, fa): the parents are the unrelated pair.
- 00-R3 -- CLOSED -- 12 and 13 both reported inline.
- 00-R4 -- CLOSED -- gca_err < 1e-10 asserted; text reports 4e-13. Claim and check agree.
- 00-R5 -- CLOSED -- :345 declares Ho_lines = 0 as a coding guard under A2, not a result.
- 00-R6 -- CLOSED -- parameters now inline from book_cfg / chunk variables.
- 00-R7 -- CLOSED -- seq_len(5).
- 00-B1 -- CLOSED -- GCA/SCA partition credited to Sprague & Tatum; linear model to
  Comstock & Robinson 1948 (Design II) and the g, s notation to Griffing 1956. Keys exist.
- 00-B2, 00-B3 -- CLOSED -- DOIs added (bibliographic, out of my scope).
- 00-B4 -- CLOSED -- no defect.
- 00-B5 -- CLOSED -- Malecot probability definition, Wright gametic correlation.
- 00-B6 -- CLOSED (contest accepted) -- the diagonal-included convention is stated in the
  text and @eq-hp-gd is asserted numerically in hp-heterozygosity; the identity does not
  rest on the attribution, and the attribution matches the standard reading of Cockerham
  (1967). Remains UNVERIFIED by refcheck, not false.
- 00-E1..00-E5 -- CLOSED -- verification-echo comments on all seven chunks; theta_S and
  GD_S defined at :222-227 before use; alpha defined at :262-264 consistently with
  90-notation; fbar_d, fbar_o, F_(ab), a_k, delta u/v added to 90-notation; recycling
  arrowheads drawn solid. Form is quant-editor's; nothing contradicts the text.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 00-M4 book/00-hybrid-programme.qmd:218-220 and :267-269 -- "Every step marked in
  @fig-hp-cycle samples or selects a subset of n_sel of the N members of a pool". At S2
  the DH lines are new gametes of chosen crosses, not a subset of existing pool members;
  the random-subset expectation (1/n_sel - 1/N)(fbar_d - fbar_o) does not describe that
  step, whose loss is the gamete-sampling drift of @eq-hp-drift (N_e = n/2) treated later
  in the same chapter. The quantitative claims are correctly restricted to "a subset drawn
  at random", so no number is wrong; the framing sentence over-generalises the sampling
  unit.

Count of open non-disqualifying failures: 1 (below the threshold of 3).

WHAT WAS VERIFIED
- Chapter purled and executed under pkgload::load_all (book/_common.R sourced): every
  stopifnot passes.
- Random-subset excess -- E[theta_sub] = fbar_d/n + (n-1) fbar_o/n without replacement,
  minus the pool's fbar_d/N + (N-1) fbar_o/N, gives (1/n - 1/N)(fbar_d - fbar_o);
  non-negative because f is a Gram matrix (f_ij <= sqrt(f_ii f_jj)). Same as 06:330 and the
  90-notation row theta_S = fbar_d/n + (n-1) fbar_o/n.
- hp-subset-gd numbers -- pool 0.3281, random-20 mean 0.3209 (s.e. 0.0001), expected
  0.3210, random max 0.3251, diversity-greedy 0.3296 > pool. Reproduced.
- M2 direction -- with A common and independent of D: cor = (vA + c)/sqrt((vA+v1)(vA+v2));
  d log cor / d vA at 0 = 1/c - 1/(2 v1) - 1/(2 v2) = 1/29.58 - 1/69.54 - 1/68.24 =
  +0.0048 > 0 on the chunk's g1, g2 (v1 = 34.77, v2 = 34.12, c = 29.58), and cor -> 1 as
  vA grows. The "pulls towards 1" claim holds for this case (in expectation, under the
  declared independence).
- hp-gca-tester -- gca_err 3.7e-13, r = 0.8587, top-5 shared 3. Reproduced.
- hp-ibs-ibd -- full sib 0.7264 vs 0.7264, unrelated 0.6351 vs 0.6352; excess
  0.7264 - 0.6352 = 0.0912 = 0.25 (1 - 0.6352). Correct.
- hp-drift -- 0.5997 (exp. 0.5987), 0.3496 (exp. 0.3487). Unchanged, correct.
- hp-heterozygosity -- Ho_hybrid 0.3617 = GD_T 0.3281 + GD_BS 0.0336; He_pool_A 0.2953.
- Citations -- kadoumi2025 and vanheerwaarden2012 abstracts read via Europe PMC; claims
  in :276-282 and 11:135-137 match them. comstock1948, griffing1956, malecot1948 keys
  present in references.bib.
```
