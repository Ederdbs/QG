# Verdict: 03-simulating-crosses, iteration 3

Scope: closing 03-D7, 03-D8 and 03-M8, plus a check for new failures in the text changed since
iteration 2 (book/03-simulating-crosses.qmd:8-20, :80-92, :158-215). Numbers come from
pkgload::load_all on the worktree, sourcing book/_common.R.

VERDICT: APPROVED

PREVIOUS IDS
- 03-D7 -- CLOSED -- :16-20 now states the correct relation: same random-stream order, so the
  same lines and the same X with @sec-response's arguments, and only the traits differ. :86-90
  asserts it. Rerun: identical(2 * GL, L) is TRUE, and identical(sim_02b$X, simulate_data(book_cfg)$X)
  is TRUE (book_cfg$fst = 0.15, seed = 1, which match the arguments the prose names).
- 03-D8 -- CLOSED -- :202-212. The unbounded-pool expectation is now qualified as such. The
  finite-n form is declared with its assumption (binomial sampling of n homozygous lines per
  pool), the expectation E[GD_BS] = F pq + (1-F)pq/n is correct, the loss and gain are
  F pq (1 - 1/n), and the cancellation in the ratios is stated. The inline numbers are 0.0666
  (finite n) and 0.0694 (unbounded). Over 200 replicate grids the measured mean changes are
  GD_T -0.06682 (SE 0.00033) and GD_BS +0.06651 (SE 0.00020). Both sit within 1 SE of 0.0666,
  and 0.0694 is excluded. No gap is left unexplained. The text does not set 0.0666 against the
  single-draw changes (-0.0629 and +0.0705, which bracket it), so nothing is over-interpreted.
- 03-M8 -- CLOSED -- :186-192. The ratios are labelled single draws. Their replicate mean and
  SD (1.002 / 2.008, 0.104 / 0.102) are computed inline by the chunk at :154-167, and the
  sampling-variation inference is a separate clause.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
None new.

WHAT WAS VERIFIED
- 03-D7 assertion: simulate_pools(25, 25, 2000, 0.15, seed = 1) against simulate_lines(book_cfg)
  and simulate_data(book_cfg). Both identical() calls return TRUE.
- Finite-n algebra. With equal pool sizes, per-locus GD_BS = (p^_A - p^_B)^2 / 2. Then
  E[(p^_A - p^_B)^2] = 2F pq + 2 pq (1 - F)/n. E[het] = 2pq is exact, so
  d E[GD_T]/dF = -pq (1 - 1/n).
- E[p*q*] for U(0.05, 0.95) = 0.5 - (0.81/12 + 0.25) = 0.1825. Then
  0.38 x 0.1825 x 24/25 = 0.0666, and 0.38 x 0.1825 = 0.0694. The inline expression
  het_exp/2 x range x (1 - 1/n) computes exactly this.
- Replicate chunk reproduced independently: ratio means 1.0022 / 2.0083, SD 0.1038 / 0.1024.
  These match the response's figures.
