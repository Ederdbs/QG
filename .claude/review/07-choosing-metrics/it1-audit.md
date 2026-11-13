# 07-choosing-metrics -- audit, iteration 1 (read-only)

Chapter: `book/07-choosing-metrics.qmd` (513 lines). Run: all live chunks sourced
end to end against the worktree package (1.1 s, no error); cached files re-read;
the `identity` target of `regenerate.R` re-run into a scratch dir; Finding 5
re-run over 20 seeds (x3 blocks). Severity: A = prose asserts something the
data/code contradict; B = unsupported or unreproducible number; C = form.

## A. Claims the data or the book contradict

**07-R1 (A) "allelic richness is the one metric carrying information theta does not" is not what the cache shows.**
07:209-212, 07:218-219, 07:451-452, fig B title "the one real second axis".
Rank-on-rank quadratic residual sd (reproduces the prose 52 / 36 / 25 % exactly):
alleles_retained 0.521, Ne_parents 0.364, eff_dim 0.250, but also E_NE 0.523,
A_NE 0.556, n_lines_used 0.503, theta_between 0.653, theta_within_A/B 0.37/0.39.
E-NE, A-NE, n_lines_used and theta_between keep as much or more than allelic
richness; they are excluded for cost (O(N^2) matrix) or sit in validation item 4,
not because they are redundant. The prose lists only the three that suit the
argument. 06:316-319 repeats "the metrics keeping most rank variation ... are
allelic richness and Ne_par" and 02:990 "the one genuinely independent axis".
Reword to "among the metrics the line route can compute", and print the full
residual column (compute it inline from `metric_redundancy.csv`).

**07-R2 (A) Finding 4 and the recommendation "reparameterise on line weights" are contradicted by 10 and 10b, and the chapter does not say so.**
07:265-313, 07:446-447. 10:452-512 already states: neither arm is `sel_de()`; the
arm beaten is the N-dimensional key encoding; the selected-set size of the run
"was not recorded"; part of the margin is the cap satisfied by construction. 10b
`search_benchmark.csv`: `sel_de()` (`de_hybrid`) beats line-encoded DE at both
scales (book 1.360 vs 1.059; production 1.446 vs 1.336, mean index, uncapped).
07 omits N = 3600, L = 120, `n_sel`, NP, that both arms start cold (fig A starts
at 0.27 / -1.0, no greedy seed), and says "the encoding decides" as a general
result. 11:306 and 12:222 echo it. Needed: state the setup (take it from 10),
restrict the claim to "key-per-hybrid vs line weights through
`make_fitness_fast`", and drop or qualify "reparameterise the search on line
weights".

**07-R3 (A) "The hybrid encoding leaves every constraint slack" and "Only the line encoding makes the constraints bind" (07:295-299) is false for max_use.**
`de_constraints.csv`: hybrid arms have max_use 5, 6, 6 (cap 6) -- two of three
seeds sit at the cap; the figure (de_convergence.png, panel max uses) shows the
same, and its title says only the line arm reaches the limits. Pool balance
(`pool_imbalance` = 0 in all 9 rows) is never reported, so the "four restrictions"
claim is checked on three. Penalty vs repair is compared only in the hybrid
encoding (identical rows); no "line weights / penalty" arm exists, so "encoding,
not the handler" confounds the encoding with the decoder-enforced cap
(07:446-447 itself recommends the decoder). The explanation "DE never approaches
the boundary" (07:292-293) is untested; 10:490-493 says the same, also untested.

**07-R4 (A) 07:304-307 truncation reference has no source.**
"index 2.337, loss 1.62 %, Ne_par 33.2, one line used 17 times", and "85 %"
(1.9878/2.337 = 0.8506 arithmetic ok). 2.337 appears in no file under `book/data`
and no script; `de_constraints.csv` has no truncation row; `n_sel` of that run is
unrecorded (10:507-509). Also the comparator is an infeasible bound; the fair
comparator (capped greedy / `sel_truncation_cap` at the same `n_sel`) is absent.

**07-R5 (A) Arithmetic errors in Finding 2 (07:172, 07:176-177).**
- "5 us, or 1.4 seconds per million evaluations": 5.007 us x 1e6 = 5.0 s
  (0.00139 h; the 1.4 is the hour figure misread as seconds).
- "still 178x the cost of the line-route theta": 891.92 / 106.10 = 8.4x;
  178x is 891.92 / 5.007, the incremental swap.
- Verified ok: 14.2 h (14.198), 482x (51113/106.1 = 481.8), 5.7x bitset
  (5090.95/891.92 = 5.71), 1.47 h, 3.77 GB (22500^2 x 8 / 2^30), table 5/106/7/0.9 ms/62 us.
All of these are typed; make them inline `r` (rule 1).

**07-R6 (A) Live reproduction does not reproduce the claim it sits under.**
07:221-252. (a) Caption "Ne_par still varies by a factor of two": the live band
(|theta - median| < 0.0015) returns n = 55, Ne_par 31.6 to 41.9 = 1.33x.
(b) The chunk reports `lost` = `alleles_lost()` (MAF threshold), the metric the
chapter itself calls redundant (rho 0.93, "not recommended"), not allelic
richness, the metric the argument is about; prose then quotes the cached 171
markers / 30.1-55.8. (c) band half-width differs (0.0015 live vs 0.002 cached).
Compute allelic richness live (`alleles_retained()` needs `GL`) or say the live
chunk shows Ne_par only; fix the caption from the computed range.

**07-R7 (A) Finding 5 holds in direction but the single-seed numbers are presented as the result.**
Re-run, 20 seeds (`run(r, s)`), mean over seeds vs the seed-1 table:
truncation alpha at r = 1 / .9 / .7 / .5: mean 0.0412 / 0.0416 / 0.0396 / 0.0379;
seed 1: 0.0412 / 0.0406 / 0.0356 / 0.0301. alpha is monotone in r on only 4 of 20
seeds (truncation) and 10 of 20 (greedy). "alpha falls as accuracy drops"
(07:372-375) is true of the mean, weak (r = .5 vs 1: -8 %), and exaggerated by
seed 1; the mechanism ("closer to random") is not tested. Inline
`reported`/`realised` at r = .5 (1.62 / 1.18, 07:365-368) are seed-1; 20-seed
means 1.77 / 0.92 (the gap is robust: min over seeds 0.45, mean 0.86, sd 0.27).
Correlated vs independent at r = 0.6, three blocks of 20 seeds: alpha ratio
3.23 / 2.79 / 3.02 (paired difference positive on 60 of 60; s.e. 0.001-0.0015),
max-line ratio 1.44 / 1.24 / 1.33 (prose 1.4 = block 0), realised index
correlated vs independent 1.151 vs 1.225 (block 0) but 1.234 vs 1.232 and
1.245 vs 1.244 (blocks 1, 2): the "delivers 1.15" of the callout (07:413) is a
block-0 value; the realised-gain difference between error types is not robust.
"Same accuracy" is nominal: realised cor(pred, truth) at r = 0.6, seeds 1-5:
correlated 0.50-0.68, independent 0.58-0.62. Fix: aggregate `run()` over >= 20
seeds with s.e., report the ratio with its dispersion, state nominal vs realised
accuracy, soften the alpha sentence to the 20-seed result.

## B. Unsupported, unreproducible, or undeclared

**07-R8 (B) Provenance of everything cached is never declared in the chapter.**
`cost_per_eval.csv`, `theta_identity_check.csv`, `de_constraints.csv`,
`metric_redundancy.csv`, `cost_scaling.png`, `metric_redundancy.png`,
`de_convergence.png`: no producer (index:198-204 says so; the chapter does not).
Hardware, R version, timer and the redundancy cache's settings (N, L, m, n_sel,
fst) are not in the chapter or in any file. From the data only: N = 22500,
L = 300, m = 10000 (cost); retained + fixed = 12000 on all 621 rows, i.e.
12000 = 2m alleles, so m = 6000 markers (inference, not documented), and
"171 markers (of 12,000)" at 07:214 and fig C label alleles as markers (06:464
reads "12000 markers"; 06 is closed, note for the batch). Add a declared-external
paragraph; never describe these as reproducible. `regenerate.R` `benchmark`
writes `report/cost_per_eval_book.csv` (other schema) and `identity` writes
`report/identity_sweep_book.csv` -- neither feeds `book/data`.

**07-R9 (B) Identity sweep (07:86-108): partial producer, no assertion.**
Re-ran the `identity` target logic into scratch: worst deviations 3.3e-16
(sub vs line), 1.1e-16 (vs freq), 0, 0, 2.8e-14 (Ne_par), 1.0e-15 (pools),
4.4e-16 (swap), 0 (bitset) against the cache's 2.2e-16, 1.1e-16, 0, 0, 2.1e-14,
1.2e-15, 4.4e-16, 0: same magnitudes. But the target has 8 of the 10 columns of
the cache (`max_pairwise_f`, `max_alleles_lost` have no code), no L/N/m columns,
and no `set.seed()` before the 30 draws (not reproducible digit for digit).
"literal transcriptions of the reference implementations" is true of
`ref_theta_pools` and `alleles_retained` only; the others compare against
`theta_group`, `theta_from_freq`, `he_nei`, `ne_parents`. The chunk prints the
cached maxima with "machine precision throughout" but declares no tolerance and
asserts nothing: add `stopifnot(all(worst < 1e-12))` (tolerance from theory:
O(1e-16) relative, Ne_par ~50 gives 2e-14 absolute) and name the 2 columns that
have no producer.

**07-R10 (B) Live identities print, not assert (07:112-130).** `difference` shows
`0.0000000` and `2.2e-16` with no `stopifnot()`. Add
`stopifnot(abs(diff) < 1e-12)` for both (rule 3; preface index:76-82).

**07-R11 (B) eff_dim form of the cache (owed from 06).** Cache `eff_dim` mean 1.486
(1.438-1.506) is the uncentered ratio (06:458-467: 1.47), not the package's
double-centred `eff_dim()` (26.19 there). The chapter's "|rho| = 0.97", "retains
25 %, close to a restatement of theta" (07:211-212) and "Not recommended ...
rho = 0.97" (07:461) are therefore about the uncentered form. Indicative
recompute at book scale with the package (seed 11, 250 selections: 150 random,
40 greedy over w, <= 80 restricted line pools, n = 60): package `eff_dim`
|rho| 0.89, residual fraction 0.42; uncentered |rho| 0.94, 0.32; Ne_par 0.90,
0.41. (Different mix and scale than the cache: indicative only.) Either say the
cache used the uncentered ratio and that the claim is about that form, or
recompute the column with the package.

**07-R12 (B) Redundancy numbers depend on the strategy mix, not stated.**
Cache: 300 random, 120 truncation, 113 restricted pool, 88 greedy. rho(theta,
Ne_par) is -0.925 overall (prose "|rho| >= 0.93 for ... Ne_par", 07:200-201,
is false at 3 digits; 06:319 prints -0.925) but -0.60 within random, -0.955
within truncation; rho(theta, alleles_retained) -0.35 within random.
PC1/PC2 88 % / 7 % reproduce only on the 16 columns excluding `mean_index`
(87.6 / 6.6; with it 84.4 / 7.2; dropping the four exact monotone copies of
theta, 85.4 / 7.5), while the prose says "all 17 metrics" (07:190). Band numbers
(399 selections, 11680-11851, Ne_par 30.1-55.8) reproduce from the csv only with
|theta - median| < 0.002 (theta 0.66609-0.67006, rounded in prose to
[0.666, 0.670]); 295 of the 393-399 are random. State the mix and the rule, and
compute these inline.

**07-R13 (B) Book-scale cost chunk (07:182-184) is not informative as shown.**
`cost_per_eval()` times with `system.time` over `reps = 40`: values are multiples
of 25 us and `ne_parents` prints 0 (the quantisation CLAUDE.md warns about for
`bench_us`). The table has no line route, so "the same ordering is visible"
cannot be seen: `theta_group` 375 > `theta_from_freq` 175 here, the opposite of
the production table where the genotype scan is the slowest. Also unseeded
(`sample.int` inside). Drop the claim or time with adaptive repetitions; a fix
to `R/02_benchmark.R` is outside this chapter.

**07-R14 (B) 5 us vs 7 us (swap vs Ne_par) is not an ordering.** `cost_per_eval.csv`:
at n_sel = 1000 swap 5.01 / Ne_par 7.15; at n_sel = 200, L = 300 swap 6.91 /
Ne_par 5.01; at L = 50-100 Ne_par < swap. Read "a few us each, same order".
`fast_ne_parents()` recomputes `line_counts()`; it does not share a state vector
(R/04:166-170) -- "shares the state vector" (07:29, 07:173, 07:442) holds only
inside `make_fitness_fast()`, which tabulates once.

**07-R15 (B) Drop-in code (07:486-506, `eval: false`) ran with edits; three mismatches with the text.**
Ran at L = 50 (simulate_pools): works, returns the named vector. (a) NP = 200 <
10 x `n_lines` triggers the DEoptim warning that 07:309-313 explains and says
"at dimension 120 the recommendation is 1,200"; (b) only three restrictions
(`pool_tol` missing) against "four"; (c) no `set.seed()` before `replicate` and
`DEoptim`, and a cold DEoptim start, while CLAUDE.md requires NULL never to mean
cold for `sel_de`. Align or comment.

**07-R16 (B) Forward promise of 06 not kept.** 06:989-990: "That contrast between
lenses [GD vs ANE z-scores] is what @sec-choosing turns into a recommendation."
07 never uses the z-score contrast; A-NE appears only as "not recommended, O(N^2)"
(07:462-465). Either add the paragraph (the 06 numbers are computed there) or
send 06 a wording fix. (The other forward promises of 06 -- matrix route
cheaper, Ne_par in the objective -- are kept: 07:63-67, 07:441-444.)

## C. Statements, symbols, form

**07-R17 (C)** 07:35 "Three findings drive this" -- the chapter has five.
**07-R18 (C)** 07:59 `\mathbf G^L` is undefined here and clashes with VanRaden
$\mathbf G$; 05:1919-1941 defines it ($L \times m$ line genotype 0/1). Define on
first use. The two displayed equations (07:49, 07:56) are unlabelled; 10b:219
cites the section for $\theta_S = \mathbf w'\mathbf f^L\mathbf w$; label it and
cross-reference 00:537-559 (same identity, asserted there), 00-C25 pattern.
**07-R19 (C)** 07:69-72 "w is a sufficient statistic" for the diversity set;
state the scope: F1 heterozygosity and `GD_WI_hyb` (06:225-245), expected heterosis
and any non-additive index depend on the pairing, not on w. 07:74 "rank-2
update": `R/04:143` documents four rank-1 column updates (w changes in <= 4
entries). 07:78-82 "exactly optimal-contribution selection on lines" omits the
margins sum_A w = sum_B w = 1/2, the realisability of w by n distinct A x B
crosses, and the additive-index condition.
**07-R20 (C)** 07:335 `ctx$f` -- the accessor the callout at 07:135-137 forbids
(correct here because `f` exists, but the book's rule is `ctx[["f"]]`).
**07-R21 (C)** 07:455-456 recommends $N_s$ as a "reportable descriptor" while
07:199-202 and 07:460 call every rank-identical function of theta redundant
("Nei's He ... it *is* 1 - theta"); 06 shows $N_s \in [1/2, 1]$ on molecular
$\mathbf f$, a rescaling. Say it is reported as a rescaling of theta, not as a
fifth piece of information (or drop it from the "three at validation").
**07-R22 (C)** 07:480-482 "Predicted Delta f is biased downward ... as the
candidate pool shrinks" has no citation; the source is in @sec-ocs
(09:322-327, Gomez-Romano 2016, "roughly a factor of two ... small candidate pools").
Cite it.
**07-R23 (C, owed in THREAD)** 07:87 and 07:257: $F_{ST}$ for the setting is
$F_{BN}$ (00-C18); 07:481 "candidate pool" -> "candidate set".
**07-R24 (C)** `fig-alt` at 07:150, 07:195, 07:275 are labels ("Cost per fitness
evaluation", "Metric redundancy"), not descriptions of what the panels show.
Variable `all` (07:237) masks base `all`.

## Verified, no finding
Live identities hold (diff 0 and 2.2e-16). `null_distribution()` seeds itself
(`seed = 7`), `set.seed(51)`, `set.seed(77)`, and `predicted()` seeds per call:
seeds are placed correctly. Prose 52 / 36 / 25 % reproduce; Spearman 0.932 /
0.967 / 1.0 reproduce; 621 = 300 + 113 + 120 + 88; Finding 4 table (0.351,
1.988, 50.08, 6, 0.448 %), "three seeds", 60,000 evaluations all match the csv.
Cross-references (`sec-ocs`, `sec-plant-literature`, `sec-case-study`,
`sec-genomic-prediction`, `sec-genomic-era`, `sec-catalogue`,
`sec-simulating-crosses`) exist. `book/downloads/07-choosing-metrics.R` code
matches the chapter (header only differs). Inbound claims kept true by 07:
06:172-173, 06:279-280 (yes); 06:316-319, 02:990 (no, see R1); 11:306 "encoding,
not the algorithm" and 11:23 (see R2); 09:385, 10:52, 08b:729 (yes).

## Chunk labels (rule 6)
The only live figure is `unnamed-chunk-10-1.png` (docs and `_freeze`, html and
typst). Adding or removing any chunk before it (R6, R7, R9, R10 all do) orphans
it; label the figure chunk (`#| label: fig-ne-par-at-fixed-theta`) first.
After edits: `Rscript book/scripts/make_downloads.R`.

## Not run
Production-scale cost benchmark (no producer); the redundancy and DE sweeps
(external); the eff_dim recompute is indicative, not a replacement for the cache.
