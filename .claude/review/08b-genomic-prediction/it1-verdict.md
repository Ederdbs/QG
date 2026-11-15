# 08b-genomic-prediction -- iteration 1, verdict

VERDICT: REJECTED

Text: `book/08b-genomic-prediction.qmd` (794 lines). Reports consumed: `it1-audit.md` (R), `it1-refs.md`
(B), `it1-continuity.md` (C), `THREAD.md`. Scratch scripts: `/private/tmp/claude-501/-Users-ederdbs-Documents-SB-quanti-gen/b21c3252-fade-4466-9e3d-6022a32fa781/scratchpad/v1.R`, `v2.R`, `v3.R`.

## DISQUALIFYING FAILURES

- **08b-D1** [criterion 1, 4] `08b:549-550`, `08b:548`, `08b:523` -- "BayesB ... learns a single shared pi from
  all 2000 markers". The chapter itself fixes `pi = 0.95` (`08b:477`, `08b:514-515`), titles `08b:659` "`pi` was
  fixed, not tuned", and introduces BayesC-pi at `08b:675` as the method that estimates it. I confirmed that
  `bWGR::BayesB` takes `pi` as an argument (`names(formals(BayesB))`: y, X, it, bi, pi, df, R2) and returns
  only `mu, b, d, hat, vb, ve, h2, MSx`: no `pi`. The causal explanation of why BayesB "can afford" what BayesA
  cannot is therefore wrong. "BayesB's spike deletes them" and the caption "Only BayesB can then remove the other
  1999 from the model" are contradicted by the output: median posterior inclusion `d` = 0.178 (my run of the
  polygenic fit; the chapter prints the oligogenic one) with prior pi = 0.95; the other markers are not removed,
  they carry a low but non-zero inclusion probability. (= R3, open, H.)

- **08b-D2** [criterion 4, 5] `08b:313-318` -- "the gap is this small only because this particular split was
  easy". The chapter's own CV table says the opposite. Recomputed (`v1.R`, 20 line-holdout replicates, chapter
  code verbatim): reliability vs accuracy CV2 0.873 vs 0.932 (gap 0.059), CV1 0.644 vs 0.653 (0.009), CV0 0.128 vs
  0.122 (0.006). The model under-states itself in the easy scheme and is nearly exact in the hard ones. Also
  "roughly half the gap" (`08b:313`) is seed-dependent: on the chapter split gap 0.064 and blend explains 0.032;
  over 40 fresh noise/split seeds (101-140) I get accuracy 0.939 (sd 0.015), implied 0.895, implied at w = 0.999
  0.927: gap 0.044, blend share 0.032 (about 72%, not half). Seed 9 gives 0.960, 1.4 sd above the 40-seed mean.
  An interpretation (that the gap closes only on an easy split) is presented against the data. (= R4, open, H.)

- **08b-D3** [criterion 1, 5] `08b:709-720` -- "`data.frame(hybrid = cand, trait1 = predB)` is exactly the `traits`
  argument `stage1_build()` expects -- one column per trait, one row per hybrid". Reproduced (`v1.R`):
  `stage1_build(ctx$X, ctx$ped, hybrids_traits)` stops with `nrow(X) == nrow(traits) is not TRUE`
  (`R/10_stage1.R:69-70`); with `X[cand,]`, `ped[cand,]` it runs but returns `hybrids` with columns
  `hybrid, line_A, line_B, hybrid.1, trait1` (the id column duplicated, ids renumbered, N becomes 250 for every
  later chapter). The claim that the hand-off is the contract is false as written, the chapter's whole closing
  loop ("this is where the opening paragraph's two steps close the loop") rests on it. One trait where
  `ctx$index` is a standardised multi-trait index is also not said. (= R5, C4, open, H.)

- **08b-D4** [criterion 7] attributions that the sources do not support.
  (a) `08b:330-331` "@burgueno2012 named the schemes ... CV0/CV1/CV2" with the parent-seen/unseen meaning: Burgueno
  defines CV1/CV2 for genotype-by-environment; Technow et al. 2014 use T2/T1/T0; refs B2 found no CV0 in Burgueno
  (abstract-level evidence, full text unreachable: UNVERIFIED, not asserted false); C2 shows the book itself uses
  CV0/CV1/CV2 with two meanings (04f vs 08b/90). Cannot be accepted as written. (= B2, C2, open, H.)
  (b) `08b:10-13` "an optimistic ceiling" in quotation marks as 03's words: not in 03 (grep, C6/03-C11). (= C6a, R2a, open.)
  (c) `08b:19-20` `vanraden_G()` "has said since @sec-coancestry that its matrix 'is the right matrix for GBLUP'":
  not a quote of 01:84-86 or of the roxygen (`R/00_data.R:86-96`, "Use this for trait prediction only"). (= C6b, R2b, open.)
  (d) `08b:469-471` "bWGR is exactly the tool `vanraden_G()`'s docstring pointed toward": the docstring names no
  tool; false. (= C6c, R2c, open.)
  (e) `08b:679` BayesC-pi "updates pi by Metropolis-Hastings ... [@xavier2019bwgr]": the bWGR paper does not say
  which parameter is updated; the primary source (Habier et al. 2011) is not in the bib. (= B4, open.)
  (f) `08b:42-44` "the saving @sec-stages calls hybrid mining (S4)": 08 states a memory saving
  O(N^2) -> O(L^2), no genotyping saving. (= R1, C3, open, H; same unsourced claim at `08b:145-151`.)
  (g) `08b:388` Daetwyler formula and symbol `M_e` unconfirmed (B3, UNVERIFIED), `08b:171` Henderson 1975
  joint-density derivation unconfirmed (B5, UNVERIFIED), `08b:545` "learning the genetic architecture" is a
  paraphrase inside quotation marks (refs "checked and consistent" note). B1: bib lists "Craig, B." for a
  3-author paper (refcheck-owned; wrong).
  A decisive attribution (the CV scheme naming, the S4 saving, the BayesCpi mechanism) is wrong or unsupported.

- **08b-D5** [criterion 3] empirical support below the claims.
  (a) `08b:644-657` "BayesA and BayesB cost nothing when they are wrong, and recover a real gap when they are
  right". From the cached CSV (recomputed, `v2.R`, 15 paired splits per cell, paired s.e.): oligogenic h2 = 0.5
  BayesB - GBLUP +0.0224 (s.e. 0.0017), BayesA - GBLUP +0.0014 (0.0005); oligogenic h2 = 0.2 BayesB - GBLUP -0.0009
  (0.0018) (no gap when "right"), BayesA - GBLUP -0.0069 (0.0022); polygenic h2 = 0.2 BayesA - GBLUP -0.0039
  (0.0019). So the claim holds for BayesB at one cell; BayesA costs 2-3 s.e. at h2 = 0.2. The table at
  `08b:627` shows means only, no dispersion, no pairing statement; "indistinguishable" is asserted.
  (b) The whole oligogenic arm is one `rnorm(3)` draw, effectively monogenic (96% on one marker, per the chapter).
  Unit of replication is the training split (15), not the architecture (1): the generalisation to "a handful of
  large-effect loci" is on n = 1 founder/QTL draw. (R11, open.)
  (c) CV table (`08b:356-381`): 20 replicates share one noise draw (one `y`, seed 9) and one `g`; the s.d. is across
  line-holdout draws only. Over 40 fresh noise draws I get CV2 0.917, CV1 0.689, CV0 0.154 (s.d. 0.220; s.e. 0.035;
  25% of replicates <= 0 in my run, audit 17.5%). "Not reliably distinguishable from nothing" (`08b:375`) is
  stated for single replicates and not distinguished from the mean (t about 4.4). The reliabilities have s.d.
  0.002-0.003 across replicates while accuracy has s.d. 0.07-0.22: "the model knows" (`08b:403`) holds for the
  mean over replicates, not for any one holdout. (R8, open.)
  (d) Daetwyler "it agrees" (`08b:388-397`): 0.092 vs 0.122 +- 0.049 is within noise, but the unit (n = 34 lines
  instead of 289 records, which gives 0.26) is chosen to fit; the audit's 30-seed runs at k = 4, 8, 12 give measured
  0.176, 0.086, 0.108 against 0.102, 0.092, 0.080 (s.e. 0.027-0.063). Not verifiable as a confirmation. `08b:384-385`
  "34 lines' worth of independent information" contradicts the chapter's own rank L - 2 = 32. (R8, open.)
  (e) `pi` sweep (`08b:659-673`): 8 replicates per pi (not stated; the text says 15 for the other sweep), means
  0.9481, 0.9551, 0.9578, 0.9641, 0.9667 (recomputed, `v2.R`), no dispersion in the table, the sweep stops at 0.995 so
  "approaches the truth" is never tested at the truth; pi = 0.95 gives 0.9578 vs 0.952 in the 15-replicate table
  for the same architecture, h2 and pi, unexplained. (R13, open.)
  (f) BayesC-pi paragraph (`08b:683-697`): one fit per architecture, no seeds, labelled `acc_BayesB_at_095` while
  the text says "BayesB told the right answer" (pi = 0.95 is not the truth); "close to the prior" with no prior value
  given. (R14, open.)
  (g) Finding 5 bridge (`08b:729-739`): 0.96 (375 records), 0.93 (289 records, table and callout), 0.92 (40 seeds,
  my run) all stand for "the CV2 number"; nominal-grid vs realised-correlation not distinguished (C9); "Finding 5's
  pessimistic cases are the realistic ones" does not follow from a simulation whose scheme is not tied to a programme
  (R9, C10; 04e records the published T0 0.77 against this book's 0.10-0.15 as in tension). The error-structure
  statistic (`08b:743-755`, 0.14 on one split; 0.144 +- 0.012 over 40 seeds in the audit) is the correlation of
  error products with f across non-independent pairs, no null, and "confirmed" is stronger than the evidence. (R10, open.)
  (h) Gibbs fits (`08b:476-477, 514-515, 605, 684-685`) have no seed immediately before them; results move with
  any unrelated edit; `set.seed(9)` is used for both noise and split (R7, M-level in the audit, counted here under
  reproducibility of every stochastic number in the chapter).

- **08b-D6** [criterion 2] assumptions used and not declared, or declared and violated.
  (a) `08b:37-44`, `08b:140-151`: the "operational payoff for a hybrid crop" is derived from `ctx$traits`, additive
  by construction; the text states the consequence for real hybrid crops, where SCA and the dominance part of GCA
  at the opposite pool's frequencies exist, and concedes SCA only in the final callout. (C12, open.)
  (b) `08b:197` "sigma^2_u = 1 because `traits` is standardised ... the same number entered twice". Recomputed
  (`v3.R`): mean(diag(G)) = 0.898, Var(g) = 1, so sigma^2_u is about 1.11 under the chapter's own `G`, not 1; lambda
  is off by about 10%. The equality is stated as exact; it is an approximation.
  (c) `08b:573-579` writes mu-hat (GLS) in the identity; the verification chunk uses `mean(y[train])`. I computed
  GLS mu = 0.0169 vs mean(y_train) = 0.0337 on the chapter split, so the chunk does not test the identity as
  written (it holds for any fixed mu, so the claim survives, but the text and code differ). Separately `gblup()` itself
  was compared to a slow oracle by me (G*-route, max abs difference 4.6e-14, `v3.R`) and agrees; the chapter has no
  such check and no `stopifnot()` at all (R6, R15).
  (d) `08b:208-251` rank(G) = L - 2 stated "whatever N and m are" as an identity on three scales with m = 2000
  fixed, omitting the m + 1 bound that 05 (`@eq-era-rank`, 05:1935) states and calls a measurement at one scale
  (C7, R6). `08b:218` "singular for every population" holds for G centred on its own frequencies only.
  (e) Marker panel = causal set (no marker-QTL gap, no LD) is a best-case assumption that 04c/05 route to this
  chapter, and the chapter's limitations callout has no such item (C13, open).

- **08b-D7** [criterion 5] internal consistency. (a) `Z` denotes the incidence matrix at `08b:168-188` and the code
  `Z` at `08b:258, 302`, and the centred marker matrix at `08b:97-101` and `08b:569-579` (`vr$Z`); `08b:569`
  substitutes u = Z beta "into the equations above" where Z already means the incidence (C1, H). (b) true pi given as
  0.9985 (`08b:668`) and 0.9995 / 1 - 1/2000 (`08b:510, 687`) (R13/C15). (c) "the CV2 accuracy" = 0.96, 0.93, 0.92
  (see D5g). (d) Henderson's MME with G^{-1} (`08b:181-186`) three paragraphs before G is declared singular
  (`08b:216-220`) (R16). (e) hand-typed numbers (625, 48, 577, 289, 272, 64, 34, 0.64/0.65, 0.13/0.12, 96% x3,
  0.952/0.931/0.930, 375 at `08b:694`, 1999) are not inline computed; they match the output now but nothing
  enforces it.

- **08b-D8** [criterion 6] limitations omitted: single noise draw and single QTL draw (D5b,c), 8 replicates for the
  pi sweep, one-fit BayesC-pi, marker panel = causal set (D6e), seed dependence of every unseeded Gibbs figure,
  and the "known sigma_u^2 = 1, known h2" assumption beyond what the callout names (the callout lists
  estimated variance components, so that one is acknowledged).

## STATUS OF PREVIOUS FINDINGS (first iteration: all OPEN)

Severity as in the reports (H = contradicted by code/data/source; M = unverified/non-robust; L = wording/hygiene).

| Source | ID | Sev. | Status | Carried to |
|---|---|---|---|---|
| R | R1 | H | OPEN | D4f, D6a |
| R | R3 | H | OPEN | D1 |
| R | R4 | H | OPEN | D2 |
| R | R5 | H | OPEN | D3 |
| R | R2 (a,b,c) | L | OPEN | D4b-d |
| R | R6 | M | OPEN | D6c,d, D7e |
| R | R7 | M | OPEN | D5h |
| R | R8 | M | OPEN | D5c,d |
| R | R9 | M | OPEN | D5g |
| R | R10 | M | OPEN | D5g |
| R | R11 | M | OPEN | D5a,b |
| R | R12 | L | OPEN | M1 |
| R | R13 | M | OPEN | D5e, D7b |
| R | R14 | M | OPEN | D5f |
| R | R15 | M | OPEN | D6c |
| R | R16 | M | OPEN | D7d |
| R | R17 | L | OPEN | M3 |
| R | R18 | L | OPEN | D4a,g (UNVERIFIED part) |
| B | B1 | wrong | OPEN | D4g |
| B | B2 | wrong | OPEN | D4a |
| B | B3 | UNVERIFIED | OPEN (decisive for the Daetwyler agreement) | D4g, D5d |
| B | B4 | missing source | OPEN | D4e |
| B | B5 | UNVERIFIED | OPEN (non-decisive) | D4g |
| B | B6 | abstract only | OPEN (non-decisive) | NOT VERIFIED |
| C | C1 | H | OPEN | D7a |
| C | C2 | H | OPEN | D4a |
| C | C3 | H | OPEN | D4f |
| C | C4 | H | OPEN | D3 |
| C | C5 | H (04e, LATER-OWED) | OPEN, belongs to 04e | -- (not 08b's to fix) |
| C | C6 | M | OPEN | D4b-d |
| C | C7 | M | OPEN | D6d |
| C | C8 | L/M | OPEN | M1 |
| C | C9 | M | OPEN | D5g |
| C | C10 | M | OPEN | D5g |
| C | C11 | M | OPEN | M2 |
| C | C12 | M | OPEN | D6a |
| C | C13 | M | OPEN | D6e |
| C | C14 | M | OPEN | M4 |
| C | C15 | L | OPEN | D7b |
| C | C16 | L (11b, 12, LATER-OWED) | OPEN, belongs to 11b/12 | -- |
| C | C17 | L | OPEN | M5 |
| C | C18 | L | OPEN | M1 |
| C | C19 | L (90/04f, LATER-OWED) | OPEN, belongs to 90/04f | -- |

C5 is an open H of continuity but its owner is 04e; the 08b side is C1-C4. It is counted against this
chapter only where the chapter's own text makes the claim (`08b:140-151`).

## NON-DISQUALIFYING OBSERVATIONS

- 08b-M1 `08b:135, 767` "dominance deviations" for d_k (use the term settled in 05b); `08b:136, 766` cite the
  chapter label @sec-heterosis where the SCA section is the object; `08b:12` cites @sec-choosing where
  @sec-choosing-error is the object; `08b:210` cites @sec-why-not-g where @eq-g-sum-zero is the identity used. (R12, C8, C18.)
- 08b-M2 `08b:156-282` G vs G*, u vs g vs u-hat: the model is stated with G, solved with G* = 0.95 G + 0.05 I (named
  only in prose at `08b:295`), g and u are the same object under two letters, and u-hat has the opposite role in 07. (C11.)
- 08b-M3 `08b:474` `library(bWGR)` unguarded though bWGR is under Suggests; `book/downloads/08b-genomic-prediction.R`
  goes stale after edits; `ctx$f[cand, cand]` at `08b:745` should be `ctx[["f"]]`. (R17, audit item 5.)
- 08b-M4 `08b:10-26` does not say why the chapter follows 08 and what 08 leaves open. (C14.)
- 08b-M5 `08b:719-721` "has until now been handed the truth" fits neither 09 nor 10b; the `lambda` of
  `ocs_quadprog` is not the sigma_e^2/sigma_u^2 of `08b:186`. (C17.)
- 08b-M6 `08b:520-531`: the caption wording tied to D1 is for the form reviewer once D1 is resolved; the
  paragraph at `08b:28-44` and `08b:140-151` repeats the same payoff argument twice (redundancy).
Three or more non-disqualifying failures accumulate; independently the disqualifying list above rejects.

## WHAT WAS VERIFIED

- BayesB fixed pi: `names(formals(bWGR::BayesB))` = y, X, it, bi, pi, df, R2; returned names = mu, b, d, hat, vb, ve, h2, MSx
  (`v1.R`); median `d` 0.178 with pi = 0.95. Claim at `08b:549-550` false.
- GBLUP chapter split (seed 9): accuracy 0.9596, implied accuracy 0.8954 (matches frozen chapter output).
- CV table, 20 line-holdout replicates, chapter code verbatim, `v1.R`: accuracy CV2/CV1/CV0 0.932/0.653/0.122, sd
  0.013/0.073/0.217; reliability 0.873/0.644/0.128 (sd 0.002/0.001/0.003). Gaps 0.059/0.009/-0.006.
- 40 fresh seeds (noise seed s, split seed s+1000, s = 101-140): accuracy 0.9392 (sd 0.0151), implied 0.8952,
  implied at w = 0.999 0.9271: gap 0.044, blend part 0.032. 40 fresh noise draws for the CV scheme: CV2 0.917
  (sd 0.021), CV1 0.689 (0.076), CV0 0.154 (0.220), CV0 s.e. 0.035, 25% of replicates <= 0.
- `stage1_build` hand-off: fails with `nrow(X) == nrow(traits) is not TRUE` on the full X/ped; succeeds on
  `X[cand,]`, `ped[cand,]` with columns `hybrid, line_A, line_B, hybrid.1, trait1`.
- Cached sweep (`v2.R`, 15 paired splits per cell): BayesB-GBLUP and BayesA-GBLUP differences with paired s.e. as
  listed in D5a. pi sweep means and n = 8 per pi (D5e).
- mean(diag(G)) = 0.8976, Var(g) = 1 (`v3.R`); G*-route oracle matches `gblup()` to 4.6e-14; GLS mu 0.0169 vs
  mean(y_train) 0.0337.
- Reliability formula in the chapter (`1 - diag(C) lambda / diag(G*)`) is algebraically sigma_e^2 C / (sigma_u^2 G*) with
  sigma_u^2 = 1; the marker-space identity at `08b:573-582` (lambda_beta = lambda * 2 sum p q) checked line by
  line: correct. G1 = 0 from 1'G1 = 0 and PSD: correct.
- From the reports, not rerun: producers of both cached CSVs reproduce bit for bit (audit); rank table 18/38/48.

## NOT VERIFIED

- Burgueno 2012 CV definitions, Daetwyler 2008 Eq. 1 and `M_e` notation, Henderson 1975 derivation, Habier 2007
  full text, Meuwissen 2001/del Campos 2013 content (B2-B6): refcheck reached abstract level at best; papers on
  disk (`reference/papers/`) are five diversity papers, none cited here. Decisive for D4a, D4g and D5d; they block
  APPROVED independently of the failures above.
- Habier et al. 2011 as the BayesCpi source: not read.
- Whether a scheme name or published accuracy ordering (T2/T1/T0) transfers to this generator: not testable here.
