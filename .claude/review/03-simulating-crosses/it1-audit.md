# Audit: book/03-simulating-crosses.qmd (iteration 1, chapter audit mode, read-only)

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05 (branch review-01-05). Lines are of `book/03-simulating-crosses.qmd` as it stands (456 lines, unmodified in the worktree, md5 492d98424c1590d58217cdaef198e4d2).

Counts: H 0, M 2, L 8, Info 6.

## Method and what ran

- Knitted a copy of the chapter with `knitr::knit` against `pkgload::load_all()` of the worktree (the installed `hybdiv` was bypassed). It ran in 3 s with no error. Every `stopifnot()` passed.
- The numbers it printed are the same as the frozen ones. I compared every decimal number in my knit with `book/_freeze/03-simulating-crosses/execute-results/html.json`: 115 distinct numbers, and only print-digit differences in `head(st1$hybrids)`. The freeze hash equals the md5 of the current qmd, so the freeze is current.
- `book/downloads/03-simulating-crosses.R` is in sync. The code lines of a fresh `purl` equal the download's, apart from the setup block and one blank `#'` line.
- The chapter reads no `book_data()` or `book_fig()` file and does not touch `report/`, `data/` or `reference/`. Criteria 4 and 9 therefore have nothing to check. Both figures are labelled (`fig-divergence-het`, `fig-candidate-pool`). `docs/03-simulating-crosses_files` and `book/_freeze/03-simulating-crosses` hold exactly those two figures, so there are no orphans.
- No AlphaSimR or MaCS (criterion 2 for founders is N/A). Seeding is correct:
  - `simulate_lines()` calls `set.seed(cfg$seed)` itself.
  - `set.seed(cfg$seed + 99)` sits immediately before the effects draw (03:248).
  - `set.seed(cfg$seed + 3)` sits immediately before the 400 random subsets (03:425).
  - The 200 replicate grids seed through `cfg$seed = s`.
- All exported functions the chapter calls exist in R/ with the arguments used: `simulate_lines`, `simulate_data`, `simulate_pools`, `molecular_coancestry`, `vanraden_G`, `build_ctx`, `stage1_build`, `stage1_simulate`, `gene_diversity`. All 16 `@sec-`, `@eq-` and `@tbl-` targets exist (grep). The two bib keys, balding1995 and vanraden2008, exist.
- R/ differs from HEAD in the worktree only in roxygen text, which was irrelevant here.

Independent checks, computed outside the chapter:

| Claim | Check | Result |
|---|---|---|
| 03:205-211, E[GD_BS] = F p*q* + (1-F) p*q*/n, and the loss of GD_T and gain of GD_BS are F p*q*(1-1/n) | derived by hand. Per marker GD_BS = (pA_hat - pB_hat)^2 / 2 and GD_T = 2 pbar qbar | derivation reproduces the chapter's formulas |
| 03:211-214, expected change 0.0666 | 200 replicate grids, fst 0.40 minus 0.02, m = 1500 | mean dBS = 0.06651 (se 0.00020), dT = -0.06682 (se 0.00033), dWS = -0.13332 (se 0.00027). Closed form 0.38 x 0.1825 x (1 - 1/25) = 0.066576. Agreement within 1 se. |
| 03:192-196, replicate mean ratios 1.002 and 2.008, sd 0.104 and 0.102 | recomputed (200 seeds) | reproduced; z of the displayed seed-1 draw = +1.14 and -1.13, so "within ordinary sampling variation" holds |
| 03:131, 1 - f_AB = GD_T + GD_BS | max deviation | 0 |
| 03:305, f = tcrossprod(cbind(X, 1-X))/m | max deviation | 0 |
| 03:306, het fraction of hybrid (a,b) = 1 - fL[a,b] | max deviation | 5.6e-17 |
| 03:132, het_exp = 0.365 | `integrate(2p(1-p)/0.9, 0.05, 0.95)` | 0.365 |
| 03:75, F_ST approx F_BN/(2 - F_BN) = 0.081 | derivation (E[GD_BS]/E[GD_T] = F/(2-F)); also 90:129-161 asserts it | consistent |
| 03:275, rank(Z) = nA + nB - 2 = 48 | asserted in the chunk | passes |
| 03:436-448, whole-pool GD above random-subset mean | 400 subsets at seed 4: gap 0.00223, z = 2.93 against the sd of the subsets, no subset reaches the whole-pool value; 30 seeds: gap between 0.00212 and 0.00232 on every seed | holds with margin. The closed form `1 - [fd/n + (n-1)/n fo]` = 0.325871 against the observed mean 0.325859 (se 3.8e-5). |
| 03:20-22, same lines and X as `simulate_pools()` | asserted with `identical` | passes |

## Findings

### 03-R1 (M) 03:201-218 -- the heterosis conclusions are stated without the conditions that 02 and 05b attach to them
- 03:214 says "Neutral divergence relocates diversity; it does not create heterosis". 03:215-217 says @tbl-keystone "states that `GD_BS` is nonetheless to be preserved rather than minimised".
- The chapter's only evidence is the heterozygous fraction of an A x B F1 (and its split into GD_T and GD_BS). That equals heterosis only at flat dominance (d_k = 1 at every locus). 03 never states d_k = 1, inbred parents, the complete factorial or equal pool weights in this paragraph. The data of this chapter carry no dominance at all (03:288).
- The keystone row it cites is conditional (02:1039): "with flat dominance ($d_k \equiv 1$), inbred parents and the complete A x B factorial ... there $GD_{BS}$ is the divergence term of heterosis, to be **preserved** not minimised; outside those conditions it is not an identity". 02:1085-1097 adds "equal pool weights" and says the statement "does not hold for non-flat dominance or for divergence aligned with the dominance effects".
- THREAD (02 Owed) asks 03 to keep these conditions. The "nonetheless" also reads as if the preservation followed from the flat line; the argument is deferred to 05b and runs through alignment.
- Fix: one clause naming the conditions (flat dominance, inbred parents, complete factorial, equal weights), and "heterozygous fraction" or "heterosis at d_k = 1" instead of bare "heterosis" at 03:214.

### 03-R2 (M) 03:29, 329, 412, 414, 419, 433, 441, 444 and label `fig-candidate-pool` -- "candidate pool" and "whole pool" for the hybrid set
- The chapter uses "pool" for the heterotic pools A and B (03:56-76, 03:143-190) and also for the 625 hybrids: "the candidate pool" (29, 412, 414, 419, 441), "candidate-pool allele frequency vector" (329), "the whole pool" (433), and the row "GD, whole pool" (444).
- 00 settled the vocabulary as "candidate set" (00-C13, 00-D17, 00-M14, closed at 00:368). It is owed to 03 in the THREAD. 90:30 has the same residue ("frozen candidate-pool allele frequency").
- Within this chapter the collision is concrete. "The gene diversity of the whole pool" at 03:433 follows a section about GD between and within the two pools, where "pool" means A or B.
- Fix: "candidate set" in prose and captions. The label `fig-candidate-pool` need not change (labelled, so no orphan figures; a relabel would orphan `fig-candidate-pool-1.png` in `docs/03-simulating-crosses_files/figure-html/`, `book/_freeze/03-simulating-crosses/figure-html/` and `figure-typst/*.svg`).

### 03-R3 (L) 03:323-331 -- "freezes two things" and the chunk lists three
- `str(ctx[c("p0", "maf_pop", "index")])` prints three elements (p0, maf_pop, index). The next paragraph explains only `p0`.
- Fix: name the two intended, or explain all three.

### 03-R4 (L) 03:335-336 -- "builds the same `ctx` as this chapter" is not asserted
- Measured with the chapter's own code: `all.equal(ctx, simulate_data(book_cfg))` is TRUE for X, f, G, ped, pool, fL, cfg, N, m, index, p0 and maf_pop. It differs only in `traits`, which has no column names here while `simulate_data()` sets `trait1..trait3` (03:253-254 against R/00_data.R:131-133).
- CLAUDE.md principle 3 asks for a `stopifnot` on such an identity. Suggested: `stopifnot(isTRUE(all.equal(ctx[setdiff(names(ctx), "traits")], simulate_data(book_cfg)[setdiff(names(ctx), "traits")])))`.

### 03-R5 (L) 03:131, 302-307, 312, 319 -- tolerances not set from theory; "machine precision" shown as 0.0000
- Exact identities are asserted with `all.equal` at its default 1.5e-8, and `abs(sum(G)) < 1e-8` is absolute. Achieved: 0, 0 and 5.6e-17 for the three `all.equal` checks. `sum(G)` = -4.179e-11, which is -1.54e-15 relative to sum|G| = 27192. The prose "zero to machine precision" (03:319) is true only in that relative sense, and the tolerance is about 5 orders loose.
- tbl-ctx-check prints `sum(G)` as 0.0000, so the evidence for the sentence is not visible. `N`, `m` and `n_lines` print as 625.0000, 2000.0000 and 50.0000, because integers and reals share one column.
- Fix: a relative tolerance (1e-12) in the stopifnot, `fmt_sci(sum(G))` in prose, and integer rows kept apart from the real rows.

### 03-R6 (L) 03:112, 116, 142, 158, 173, 419 -- hand-typed scale numbers; the grid is at m = 1500, not the book's 2000
- The grid sets `m = 1500` (03:116, 158) while `book_cfg$m` is 2000. The captions of fig-divergence-het, tbl-divergence-grid and tbl-divergence-trade call this "the book scale ... m = 1500". 25 + 25 lines is the book scale; 1500 markers is not. Nothing explains the departure.
- Hand-typed numbers where the chunk already holds the value: "m = 1500" (112, 142, 173), "25 + 25 lines, 625 ... 2000 markers" (419), "400 random subsets of 60" (419), and the alt text "0.02 to 0.40" (113). 03:224 types "71 lines per pool" and `71^2` (the production scale of CLAUDE.md, not read from any object).
- Captions cannot hold inline `r`, but the 02b pattern (`sprintf` into a caption variable, 02b:12-14) does.
- Fix: use `book_cfg$m` for the grid or say why m = 1500, and build the captions from the objects.

### 03-R7 (L) 03:181-183 -- inline digits are inconsistent
- `fmt(x, 4)` drops trailing zeros: "between 0.363 and 0.3726, against an expectation of 0.365". The reader cannot tell 0.3630 from 0.363, and the three numbers carry different precision. Use `sprintf("%.4f", ...)`. The same applies to "-0.1334" (hyphen-minus) at 03:187.

### 03-R8 (L) 03:201-202 -- "of an A x B hybrid ... exactly `1 - theta_AB`": per-hybrid against mean
- The chunk at 03:301-307 proves it per hybrid: het fraction of (a,b) = 1 - fL[a,b].
- `theta_AB` is the mean coancestry between the pools (02:596-606; 01 writes $\bar f^L_{AB}$). The identity with `1 - theta_AB` holds for the mean over the complete factorial (03:123-125), not for "an A x B hybrid".
- Fix: "the heterozygous fraction of the F1 of inbred parents a and b is exactly 1 - f^L_ab, and its mean over the complete factorial is 1 - theta_AB".

### 03-R9 (L) 03:104, 285-288 -- two unconditional claims without evidence
- 03:104 "`fst` is the single most consequential parameter in the simulation". The chapter shows the het fraction flat across it, and does not compare it with any other parameter (m, n lines, trait correlation).
- 03:285-288 "read every gain figure as an upper bound on what a real programme would realise". The bound holds for gain in true genetic value at equal intensity and prediction accuracy below 1; it is not shown here, and it does not apply to diversity metrics. Condition it, or soften.

### 03-R10 (L) 03:90, 14-16 -- the assertion duplicates 02b's arguments instead of reading them; clamping is not mentioned
- 03:89-90 hard-codes `fst = 0.15, seed = 1`, which are 02b's `cfg` (02b:8). If 02b's cfg changes, the assertion keeps passing and the sentence "the same lines ... of @sec-response" becomes false. 02b has no matching assertion (THREAD owes that 03:88 stays equal to 02b:48-59; today they agree).
- `simulate_pools()` clamps both pool frequencies to [1e-6, 1-1e-6] (R/09_reference.R:32-33). `simulate_lines()` does not. At the book scale (m = 2000, fst 0.15, seed 1) 6 of 4000 Beta draws fall outside (4 in A, 2 in B). The lines are identical (asserted), but "the same pool frequencies" (03:15, 02b:49) is exact only to 1e-6. Info-level in effect; L because a one-clause qualification closes it.

### 03-R11 (Info) 03:183-185 -- the flat heterozygous fraction: replicate spread, measured (Owed from 01, verified true)
- The chapter says the spread over replicate draws "was not measured here". It costs nothing to add: the replicate chunk (03:154-169) already simulates both ends of the grid.
- I measured 200 seeds (m = 1500, 25 + 25 lines):

| fst | mean het fraction | sd |
|---|---|---|
| 0.02 | 0.3650 | 0.0038 |
| 0.15 | 0.3649 | 0.0047 |
| 0.40 | 0.3647 | 0.0070 |

- The expectation is 0.365. The one-draw range 0.363 to 0.3726 is within 1.1 sd of it (0.3726 is +1.1 sd at fst 0.40). No trend with fst (differences of the means are below 0.0006, se 0.0003 to 0.0005). The claim "flat" and 01's promise (01:378-380) hold.
- The figure's ylim = c(0, 1) makes any variation invisible (sd is 0.4 to 0.7 percent of the axis). That is intended (flat); mention it in the caption or leave.

### 03-R12 (Info) 03:278-279 -- trait-correlation departure over draws
- The chapter says it "was not measured". Over 20 effect draws (seeds 1 to 20, same Z) the maximum |cor(traits) - R| has mean 0.198 and range 0.042 to 0.553. This chapter's draw (0.14) is better than the mean. Chapters that read the trait correlation as about R (0.3, -0.3, 0.1) should not expect it on a single draw.

### 03-R13 (Info) 03:275 and 90:474 -- `n_A`, `n_B` mean two things
- 03:275 uses $n_A$, $n_B$ for lines per pool. 90:474 defines $n_A$, $n_B$ as the female and male lines of @sec-mating. They coincide only in a Design II reading. Either use $n$ per pool or add the 90 sense.

### 03-R14 (Info) 03:253 -- the chapter fixes a 3 x 3 `R`; `simulate_data()` subsets it to `cfg$n_traits`
- R/00_data.R:127-128 takes `R[seq_len(n_traits), seq_len(n_traits)]`. The chapter multiplies `rnorm(m * n_traits)` by `chol(R)` of the full 3 x 3. It works only because `n_traits = 3`. It matters if a reader changes `n_traits`; the chapter is otherwise equal to `simulate_data()`.

### 03-R15 (Info) outside 03 -- residuals relevant to owed items
- "lighter form" of the generator: 03:11-22 and 02b:48-59 now agree (traits differ only; 02b's wording is "but a different trait"). The residue is outside 03: R/09_reference.R:13 ("A lighter-weight simulator") and 91-package.qmd:109 ("lighter simulator returning raw pieces"). Neither contradicts 03's statement, but both repeat the word that 02b-M1 removed.
- CLAUDE.md invariant `git ls-files | grep -E ' [0-9]+(\.[A-Za-z0-9]+)?$'` is not empty in this worktree: `docs/04-population-sizing 2.html`, `docs/04-population-sizing_files/figure-html/fig-sizing-ancestry-1 2.png`, `docs/04b-backcross-introgression_files/figure-html/fig-bc-f2-1 2.png`. None belongs to 03.

## Owed items, status

- Heterozygous fraction flat across the F_BN grid (01): true, one draw per point as stated, and supported by the replicate spread above (03-R11).
- 02's drift accounting cited at 03:185-191: matches 02:606-613 (GD_WS falls by Delta, GD_BS rises by Delta/2, GD_T falls by Delta/2, so the ratios are 1 and 2). Verified numerically (replicate means 1.002 and 2.008).
- tbl-keystone at 03:215: cited without the row's conditions (03-R1).
- `simulate_pools()` draw reuse at 03:88: holds today (identical, passes); duplicated hard-codes (03-R10).
- "candidate pool": still present (03-R2).
- "lighter form": absent from 03 (03-R15).

## Not verified

- A `quarto render` of the chapter in HTML or Typst (only `knitr::knit`; the frozen figures exist and the freeze hash is current).
- `@sec-heterosis-flat` beyond the sentences 03 cites (05b is being edited concurrently); I checked 05b:559-700, where the cited expectations (shared term loses F_BN p(1-p), divergence gains the same) are present and equal 03's.
- `@sec-genomic-era` and `@sec-baseline` content beyond the label existing (03:329-331 says p0 is the F_hom/F_drift base; that matches `build_ctx()`, but 05 was not read).
- The attribution of the F_ST formula (carried over from 02; originals not read).
