# 08b-genomic-prediction -- iteration 1, code audit

Read-only. Chapter: `book/08b-genomic-prediction.qmd` (794 lines). Worktree
`/Users/ederdbs/Documents/SB_quanti_gen-review-04-06`. Installed `hybdiv`, `bWGR` 2.2.18.

## What was run

- `knitr::purl` of the chapter, run top to bottom from `book/` (14.7 s user, 18 s wall). Every printed
  output equals the frozen `book/_freeze/08b-genomic-prediction/execute-results/html.json`
  (checked: 0.8016810 / 0.8953664 / 0.9596232, 0.9992759, 0.4369196 / 0.4390892 / 0.9299389 /
  0.9524220, `d`/`vb` pairs).
- `Rscript book/scripts/regenerate.R genpred` in a scratch copy (2 min): both cached CSVs
  (`genomic_prediction_accuracy.csv`, `genomic_prediction_pi_sensitivity.csv`) reproduce
  bit for bit (`all.equal` TRUE, max abs difference 0). Cached data therefore HAS a producer in
  the repo and is reproducible (unlike `mating_*`/`sparse_*`); nothing to relabel.
- 40 fresh noise/split seeds (101-140) of the chapter's GBLUP/CV/reliability code, and 30 seeds
  at k = 4, 8, 12 for the Daetwyler check (scratch scripts, not in repo).
- Paired s.e. computed on the cached sweep (15 paired splits per cell; 8 per `pi`).

## Owed items naming 08b

| Owed item | Verdict |
|---|---|
| 08:`08b:43` "the saving @sec-stages calls hybrid mining (S4)" | Confirmed wrong. `08-pipeline-stages.qmd` S4 states the saving is memory, `O(N^2) -> O(L^2)`, "not a saving of time per evaluation unless n is large" (08:~700-705). It never discusses genotyping. See 08b-R1. |
| 08:`08b:729-740` Finding 5 consistency | Partly consistent, three defects. 07 (`07:670-672`) says 08b's CV2 lies at the top of the range and CV1 near the bottom: true. 07 grid is `c(1, 0.9, 0.7, 0.5)` (07:727), matches 08b:733. But 08b:739 "Finding 5's pessimistic cases are the realistic ones" and "the two chapters bracket the same interval" are not established (08b-R9), and 07:670 says 08b "finds the same structure in its real residuals" on a statistic that is one split, no dispersion (08b-R10). 07 itself declares its realised-gain difference "not a result" (07:885,911-913); 08b does not claim a gain difference: keep. |
| 01-C11 `08b:19` quoted "is the right matrix for GBLUP." | Open. 01:84-86 reads "it is the right matrix for genomic best linear unbiased prediction (GBLUP)"; roxygen of `vanraden_G` (`R/00_data.R:86-96`) says "Use this for trait prediction only". The quotation marks are not a quote. 08b-R2. |
| 03-C11 `08b:9-13` "an optimistic ceiling" in quotes as 03's words | Open. 03 does not contain the phrase (grep: only `11b:102`, `12:170`). 08b-R2. |
| 05-C15 `08b:208-250` cite @eq-era-rank | Open. 05:1935 defines `eq-era-rank` (`rank(f) <= rank(B)`, also `<= m + 1`); 08b rederives and does not cite it. 08b-R6. |
| `08b:135`, `08b:767` "dominance deviation(s)" for d_k | Open, both lines. Replace with "dominance effects" (the name settled in 05b/01-M13). 08b-R12. |
| 04c: marker-QTL / LD promise | Keeps true: traits are built on the markers (`R/00_data.R:121-124`, chapter `qtl <- sample.int(m, 3)`), no LD modelled. Nothing owed from 08b. |
| 02b/05b/11b: SCA absent from `ctx$traits` (08b:136, 763-768) | Keeps true; verified: `traits = scale(Z %*% B)`, additive. |

## Findings

Severity: H = a statement the code or cached data contradicts; M = unverified or
non-robust claim; L = wording, hygiene.

### H

**08b-R1 (H) -- genotyping-saving claim, `08b:42-44` and `08b:145-151`.** `08b:43` attributes
to @sec-stages a "saving" it does not state (see Owed above). Separately, the chapter never
demonstrates scoring a never-made cross: `predA`/`predB` (`08b:478-479`) are made on `cand`, rows of
the complete factorial that exist in `ctx$X`. The identity at `08b:126-131` is checked with random
`bb`, not with a fitted `b`. "Typically already on hand" (08b:146-147) and "a full crossing
and evaluation cycle" (148) are assertions with no source. Fix: reword to the memory
saving or drop the pointer; add one chunk with
`stopifnot(all.equal(as.numeric(M[cand,] %*% fitB$b), (vLhat[ped$a[cand]] + vLhat[ped$b[cand]])/2))`
where `vLhat = (L/2) %*% fitB$b`, and then the genuinely unmade cross: a line pair absent from `ped`
(none exists at the complete 25 x 25 factorial; use a held-out CV0 pair, which the CV chunk
already has).

**08b-R3 (H) -- "BayesB learns a single shared pi", `08b:549-550`.** Contradicts the code and the
chapter: `BayesB(..., pi = 0.95)` fixes pi (`bWGR::BayesB` has `pi` as an argument; no `$pi` is
returned), and `08b:659-697` is titled "`pi` was fixed, not tuned" and introduces BayesC-pi as the
method that estimates it. The causal explanation of why BayesB "can afford" to delete markers is
therefore wrong as written. Also "BayesB's spike deletes them" (`08b:548`) and the caption "Only
BayesB can then remove the other 1999 from the model" (`08b:523`) are not what the figure shows:
`oB$d` has median 0.179 (chapter output), so the other markers keep an inclusion probability of
about 0.04-0.34 (figure panel 1), roughly 360 of 1999 expected in the model per iteration.
Fix: say BayesB shrinks the inclusion probability of the others to a low background and
the prior pi is what sets it.

**08b-R4 (H) -- reliability "gap is this small only because this particular split was easy",
`08b:317-318`.** The CV table says the reverse: CV2 reliability 0.873 vs accuracy 0.932 (under-states
by about 0.06); CV1 0.644 vs 0.653 and CV0 0.128 vs 0.122 (gap under 0.01). The gap is smallest in the
hard schemes. Also the "roughly half the gap" claim (`08b:313`) is seed-dependent: on the chapter's
seed-9 split gap = 0.064 and the blend explains 0.032 (half); over 40 fresh noise/split seeds
(101-140) the mean gap is 0.038 and the blend explains 0.032 (84%), sd of the accuracy 0.016. Seed 9
sits 1.7 sd above the 40-seed mean accuracy (0.960 vs 0.933). Fix: state the gap with a mean and s.d.
over seeds, or compute the blend decomposition as a function of seed; delete the sentence at 317-318.

**08b-R5 (H) -- `hybrids_traits` is not what `stage1_build()` takes, `08b:712-720`.** Reproduced: with
`ped`/`X` of all 625 hybrids, `stage1_build(ctx$X, ctx$ped, hybrids_traits)` stops at
`nrow(X) == nrow(traits)` (`R/10_stage1.R:69-70`); with `X[cand,]`, `ped[cand,]` it succeeds but the
returned `hybrids` has a duplicated column (`hybrid`, `hybrid.1`) because the chapter's data frame
carries a `hybrid` id column, and the candidate ids are renumbered 1..250. The prose says "exactly
the `traits` argument `stage1_build()` expects -- one column per trait, one row per hybrid". Fix: build
`data.frame(trait1 = predB)`, call `stage1_build(ctx$X[cand,], ctx$ped[cand,], ..)` in the chunk, and
`stopifnot()` the contract; say that ids are renumbered.

### M

**08b-R6 (M) -- identities asserted in prose, none in a `stopifnot()` (`08b:104,133,229,245-251,
592-597`).** Printed only: tcrossprod identity (0), `max |X b - mean of parents|` (1.56e-13),
`G 1 = 0` (1.2e-13), rank table (18/38/48), `u_G - u_M` (1.35e-14). Declare tolerances
(`1e-10`; rank `== L - 2`) and assert. The first (`08b:109`) checks `ctx$G` against `vr$Z` that
produced it, which is a tautology; the claim that `ctx$traits` is `Z %*% beta` is not tested. The
chapter text "577 of the eigenvalues are exactly zero" and "48" are hand-typed (`08b:246-247`): compute
inline. `rank(G) = L - 2` "whatever N and m are" (`08b:245`) omits the `m + 1` bound of 05:1941
(`eq-era-rank` text); the table never varies `m`. Cite @eq-era-rank (owed 05-C15).

**08b-R7 (M) -- no seeds before the Gibbs fits, `08b:476-477, 514-515, 605, 684-685`.** bWGR uses R's
RNG (verified: same `set.seed` gives identical `$b`, two unseeded calls differ). The numbers are now
reproducible only because the stream since `_common.R`'s `set.seed(2026)` is deterministic; they
move with any unrelated chunk edit or with `cv_split` (it calls `set.seed`) being reordered. Also
unseeded: `bb <- rnorm(ctx$m)` (`08b:128`, benign, identity) and `set.seed(9)` used twice for `e`
and `train` (`08b:70,83`), so noise and split come from the same stream start. Fix: `set.seed()`
immediately before each `BayesA/B/Cpi/wgr` call and distinct seeds for `e` and `train`.

**08b-R8 (M) -- CV table dispersion and unit of replication, `08b:356-381`.** 20 replicates, all with
the same `y` (one noise draw, seed 9) and the same `g`; only the held-out lines vary. The s.d.
(0.217 for CV0) is across line draws, not across noise. Over 40 fresh noise draws:
CV2 0.920, CV1 0.676, CV0 0.150 (s.e. 0.034; t = 4.4; 17.5% of replicates <= 0). "Not reliably
distinguishable from nothing" (`08b:375-376`) is a statement about single replicates; the mean is
distinguishable from zero (t = 4.4, and 2.5 on the chapter's own 20). State which. The
Daetwyler "agreement" (`08b:388-397`): 0.092 vs 0.122 mean (s.e. 0.049 on the chapter's 20, so
within noise), but the unit choice (`n` = 34 lines, not 289 records, which would give 0.26) is made
to fit, and the formula is not discriminating: over 30 seeds measured CV0 is 0.176 (k = 4), 0.086
(k = 8), 0.108 (k = 12) against 0.102, 0.092, 0.080 (s.e. 0.027-0.063). Report as "not
inconsistent with" and give the s.e. In `08b:384-385` "34 lines' worth of independent information"
contradicts the chapter's own `rank = L - 2 = 32` for 34 training lines.

**08b-R9 (M) -- Finding 5 bridge, `08b:732-739`.** The measured 0.96 (`08b:732`, 375 training
records) is compared to a "CV2 number" that the table gives as 0.93 (289 records) and which the
callout (`08b:410`) uses as "the same fit ... 0.93". Two training sizes, two CV2 values, three numbers
(0.96, 0.93, 0.92 over 40 seeds). "Finding 5's pessimistic cases are the realistic ones" does not
follow: which scheme a programme faces is not in the data here. Restate as "CV2 and CV1 reproduce the
top and bottom of the explored range; CV0 is below it".

**08b-R10 (M) -- error-structure check, `08b:743-755`.** `cor(outer(err, err)[ut], fcand[ut])` is the
correlation of error *products* with `f` over 31,125 non-independent pairs, one split, no dispersion
or null. Value 0.1398 (one split; 0.144 +- 0.012 s.d. over 40 seeds, range 0.11-0.17). Under
BLUP this is expected by construction (errors are functions of `G`-relationships); "confirmed here from
an actual fitted model" is stronger than the evidence. Report the seed mean +- s.d. and name the
statistic. 07:670 cites this as finding "the same structure in its real residuals".

**08b-R11 (M) -- one QTL draw, three claims, `08b:496-511, 552-557, 644-657`.** The oligogenic arm is one
`rnorm(3)` draw that is effectively monogenic (96%; computed, but the 96% in prose and the
caption `08b:523` are hand-typed). Unit of replication is the training split (15), not the
architecture (1). Paired s.e. from the cached CSV: oligogenic h2 = 0.5, BayesB - GBLUP +0.0224 (s.e.
0.0017), BayesA - GBLUP +0.0014 (0.0005); oligogenic h2 = 0.2: BayesB - GBLUP -0.0009 (0.0018),
BayesA - GBLUP -0.0069 (0.0022); polygenic h2 = 0.2: BayesA - GBLUP -0.0039 (0.0019). So
"BayesA and BayesB cost nothing when they are wrong, and recover a real gap when they are right"
(`08b:656-657`) holds for BayesB at h2 = 0.5 only: no gap at h2 = 0.2 when "right", and BayesA
costs ~0.004-0.007 (2-3 s.e.) at h2 = 0.2. "Indistinguishable" under the polygenic arm holds
for BayesB, not clearly for BayesA at h2 = 0.2. `08b:552-555` quotes 0.952/0.931/0.930 hand-typed;
they match the cached table.

**08b-R13 (M) -- `pi` sweep, `08b:659-673`.** 8 replicates per `pi` (the chapter does not say so;
the chapter says 15 for the accuracy sweep); monotone increasing (means 0.9481, 0.9551, 0.9578,
0.9641, 0.9667; paired 0.995 vs 0.5: +0.0185, s.e. 0.0019, paired 0.995 vs 0.95: +0.0088, s.e.
0.0008). The 0.95 entry (0.9578) differs from the 0.952 of the 15-rep table (`08b:554`) for the same
architecture, h2 and `pi`: different seeds and replicates, not explained. Caption says true
`pi = 0.9985`; `08b:510` says 1 - 1/2000 = 0.9995 and `08b:687` "~0.9995". Pick one (effective 0.9995,
nominal 0.9985). The sweep never reaches the truth (max 0.995), so "approaches the truth" is up to 0.995.

**08b-R14 (M) -- BayesC-pi paragraph, `08b:683-697`.** `cpi$pi` is the exclusion probability (checked:
`mean(cpi$d) == 1 - cpi$pi` = 0.5604 + 0.4396); 0.437 vs 0.439 means ~56% of markers included for both
a polygenic and a monogenic trait. "close to the prior" is stated with no prior value (not in the
docs or the chapter). The returned vector labels `acc_BayesB_at_095` while the text says "BayesB told
the right answer" (`08b:693`): `pi = 0.95` is not the right answer (0.9995). Single fit each (one
seed); the 0.930 vs 0.952 difference is a single-fit comparison. Fix: label, give the prior, say
single fit, or use the seeds of the sweep.

**08b-R15 (M) -- verification oracle, `08b:557-612`.** The `u_G`/`u_M` identity (1.35e-14) is exact
and correct, but it checks two ridge forms with raw `G` and `mean(yc)`; `gblup()` itself (blended
`G*`, GLS intercept) never meets an oracle. Add `stopifnot` comparing `gblup()$u` with the
G*-route `Gstar[, t] %*% solve(Gstar[t, t] + lambda I, y_t - mu_GLS)`, tolerance `1e-8`. Principle
3: the fast route (`gblup()`) has no slow literal oracle in the chapter. The Gibbs check (0.9993) has no
declared tolerance and is against `u_hat` over all `N` (training included).

**08b-R16 (M) -- Henderson derivation, `08b:174-186`.** Writes the MME with `G^{-1}` three paragraphs
before `08b:216-220` says `G` is singular for every population; the equations as written do not exist
for the object used. Forward-reference the section at the equations.

### L

**08b-R2 (L) -- intro attributions, `08b:9-13, 19-20, 469-471`.** (a) "an optimistic ceiling" in
quotes: not 03's words. (b) `vanraden_G()` "has said ... is the right matrix for GBLUP": not a quote
of 01 (01:84-86) or the docstring (`R/00_data.R:86-96`). (c) "bWGR is exactly the tool
`vanraden_G()`'s docstring pointed toward without naming": the docstring says nothing about any tool
(`R/00_data.R:65,70,86-96`): false. (d) `@sec-case-study will repeat the caveat` is a forward pointer,
fine.

**08b-R12 (L) -- "dominance deviations", `08b:135, 767`.** Use "dominance effects" (settled in 05b,
01-M13).

**08b-R17 (L) -- bWGR guard, `08b:474`.** `library(bWGR)` is unguarded in a chapter whose package lists
it under Suggests (`DESCRIPTION:27`); a clean render without bWGR fails at that chunk, where
`regenerate.R:140-141` stops with an explicit message. Either list it in the chapter header as a
requirement or guard (but not with a silent skip). The download script `book/downloads/08b-genomic-prediction.R`
will go stale after edits.

**08b-R18 (L) -- literature unverified.** `henderson1975`, `burgueno2012`, `technow2014`, `habier2007`,
`daetwyler2008`, `meuwissen2001`, `delcampos2013`, `xavier2019bwgr`, `gianola2009` all exist in
`references.bib` but are not in the repo; claims attributed to them (Gianola 2009 "central objection",
Habier 2007 two sources, the Daetwyler formula's `M_e`) were not read. `08b:330-333`: the CV0/CV1/CV2
labels in Burgueno et al. 2012 concern environments (tested/untested genotypes and environments); the
parent-seen/unseen hybrid types (0/1/2) are from the hybrid-prediction literature (cited here as
technow2014). I cannot verify the mapping from the repo: UNVERIFIED, reword to "following the
scheme names of" or check the paper.

## Checklist by criterion

1. Hand-typed numbers (prose without inline `r`): 625, 48, 577, 289, 272, 64, 34, ~0.06, "half the gap",
   0.64/0.65, 0.13/0.12, 0.93/0.65/0.12, "drops by a third" (0.932 -> 0.653 = 30%), 96% (x3), "about four
   times" (3.8), 0.952/0.931/0.930, 375 (chapter uses inline once at 753; 08b:694 typed), 1999,
   pi 0.9985/0.9995. Inline `r` is used for `m`, `N`, the BayesB-GBLUP gap, the 0.96 and 0.999
   correlations, `length(train)`.
2. Seeds: see 08b-R7. `simulate_data()` is internally seeded; no MaCS/AlphaSimR in this chapter.
3. Identities asserted: none (08b-R6, R15). The chapter has zero `stopifnot()`.
4. Reads only `book/data` via `book_data()`; two files, both tracked. No `report/`, `data/` (as repo
   path), `reference/`. Pass.
5. Exported functions called: `simulate_data`, `simulate_lines`, `vanraden_G` exist in the package;
   `ctx$f` is used as `ctx$f[cand, cand]` (`08b:745`), which is the `ctx$f` partial-match trap the repo
   rules forbid: use `ctx[["f"]]`. Here `ctx$f` exists exactly so there is no wrong answer, but the rule is
   a rule. `ocs_quadprog(f, gebv, lambda)` signature (`R/07_caballero_toro.R:199`) matches the prose.
6. Orphans: the chapter has two labelled figure chunks (`fig-genpred-selection`, `fig-genpred-accuracy`);
   the freeze and docs hold only those. Adding/removing a chunk orphans nothing. Unlabelled chunks
   produce no figure.
7. Stochastic assertions over seeds: see R4, R8, R10, R11 (40 seeds ran; cheap).
8. Comparisons: unit of replication and pairing in R8, R11, R13. The cached sweep pairs GBLUP and
   Bayes on the same split and noise (good); the chapter never says so.
9. `book/data` producers: `genomic_prediction_accuracy.csv`, `genomic_prediction_pi_sensitivity.csv`:
   `regenerate.R genpred`, reproduced exactly. The chapter says "reruns the fits above 15 times each"
   (`08b:620`): true for the accuracy sweep, 8 for the sensitivity sweep.

## Cost

`gblup()`: one `solve()` of `(N+1) x (N+1)` plus one of `N x N`, `O(N^3)`; at N = 625 about 0.1 s
(40 calls in the CV chunk). `BayesA/B/Cpi`/`wgr`: `O(it * n * m)` = 1500 x 375 x 2000 per fit, a few
seconds each. Whole chapter 14.7 s user at N = 625, m = 2000. Producer `genpred` 2 min.
Measured, not optimised.

## Not done

Rendering (read-only). No `devtools::test()` (no `R/` change). The cached figures were
not regenerated. The literature claims in R18 were not checked against the papers.
